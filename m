Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BBD0C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DBC46B008C; Wed, 26 Aug 2026 03:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58BD66B0092; Wed, 26 Aug 2026 03:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A3D6B0095; Wed, 26 Aug 2026 03:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1046B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:38:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2EA9A1A0212
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:38:02 +0000 (UTC)
X-FDA: 85142616804.01.9B913E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7F3E040007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:38:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nz0FH2Tj;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787729880;
	b=Y5xSdkp4jr1OdJ8mazWQQ3ZBYh/RVDBO6jm80/xanV5Aeg7kliUGV5lIJrrRFNXjr/Zyep
	Y2xmANnqk1mnEgPQiUTuH6Hk9UCSpSvf9pbjdTTZ+Y40cs3vRJHLDwKma1g4OhDHItc8QO
	07x5kaAfYNd2J+uRwHQ81StdIVMek6s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nz0FH2Tj;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787729880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3fyVWIcLR4BT0Lr+lsWGbKZhjjFZeQzS30Wi0hDYmg=;
	b=6kDxSAxiAqkaCxZr5sLZSOcK1ssnn+0v+nUJSiV5X3fm6MLuzhI2GSFA2DdkbXo0rFlMgd
	3SKqLrR+GPH2qFAOD68iZEVRDbQ0NNMbbneJoTrcB2hnfYXVaAwzdkfjs1mk5cfAhpt+TD
	6jyFlIghwnZnGVSgcI7LVFi6Go8p868=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 618F660A59;
	Wed, 26 Aug 2026 07:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D8F1F000E9;
	Wed, 26 Aug 2026 07:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787729879;
	bh=P3fyVWIcLR4BT0Lr+lsWGbKZhjjFZeQzS30Wi0hDYmg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Nz0FH2Tjm9c6MLpQSfsHVQMDdL5N9wPANW0kFIc78cWdOdCmKv+0FuaIx4eKzU4E8
	 JPW9gIeQrl+iFPx4I+iXl9P1IGMwjrVFS85Cdr+PxIld7SY1YmGUmt4OyofKBY5lxZ
	 u97svBjmeQz5pW/QxGt7kJ0NNiKSk3p6JWaMfFaZs0JdjAMCtY2cQ7nEiIOJfGYE8H
	 F/0lQrSVnaUwoJxPb36M8KuRxXChf+AJ+z2Ib8pqehmQP0UJzNAYTunK3/bjfAR+VA
	 xqRrAV0jbD9LabU1G/l8WX47r+aXkYG4NFunV3pEKufhdxIiswCjDKajfVWiqebQx8
	 CsFzLW73fNupw==
Message-ID: <cfe22f1a-2ac9-48dc-a2c6-4369e45a852b@kernel.org>
Date: Wed, 26 Aug 2026 09:37:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix line buffer leak in mremap_test
 is_range_mapped()
To: Anshuman <anshumantewari123@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260826061300.14038-1-anshumantewari123@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260826061300.14038-1-anshumantewari123@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: iw9c9xwhg3ikhshptmcysgt4h4iowjt4
X-Rspamd-Queue-Id: 7F3E040007
X-Rspamd-Server: rspam06
X-HE-Tag: 1787729880-603221
X-HE-Meta: U2FsdGVkX1+kCPWvMQDsLocNAxHN4T0t+IMTmOwXtUE17HAh4yf7HQLvxrtU3Ru69nIQJyseRxnB2NIPAx/lxstVmCFKwZ4E9dbyupl2iGKglfr1NgpLskVyen+GxIYsYPI+iEVONXjs24igidwFNgWUsw8R7EAb0qVGFv5UtZ5nRfAfbVFuarouVJvwGTSU2dqeWJNUSM2bJLLApIars1jo+tdd3KoZlt2c8X3k9zni7pss545yEPlquO89/5M1PeZNkksCgXjvmQswlcwDfuFLnhHK/pUjX0QJiawAmUSqmiuTISO7/4gKUHqoZiR+GLSOon2n8/R2IQhx44vqukzWRcPByuvSkYKK4r9Eirinp8oFy/Qhj+GLECIII8fMdctNFMT8TNEWthOcxcWk0Y7QoUOm0Oi9HGDb46WE+bqkg8qPqw+Nv+utGi2DzzR6+ET0JgO8TbyjXWg3GvdqxFDwNkNCvjbnZFsvz+SWhohlAgmI578dpzyGrMw/G9JtWKkEU7ad700Fnn8O2Oz5NnXriJ1sGDDYVO3rSrp7mZNU1DCOu7A93Yi8+ZUotvlMUr6kUbCkT9tcSpVwr+WdgJ1oZ5hcWA52jub7Cc5ATapsg/A2bgBar2sclmVpwJQaAHNqBsBeKRazKVSD2v3vRD9G0/hqGn2hEDSUZh2EPTT8z7PMKxIXT1CUbJn9oL06Mcra6tAWJU0BZUkEC+b9VJkH4SCOneRSNfXiV5TnN0z7ysSM+6tQYyI9u+s4cJqFnvoydZVFjraA6gvdXlh7ftV2KFg/cwnnyReqcYX3dgJx/a6n7ITFPWznwIghkGHL7fle1WMA6bMTQjQk7GOm7PMxiS6anGHpWz3/QStIJUCr17p4Xm+EgIF8J7vAmydqeodagyf6nubULSLonNu7ekc7Rbb4LbiDbcwlmilTsbwgoNg1AWWqtRpbvxLqoo84udc+1QnsyiCM5dLxjOy
 WBh44oGV
 ELCWsl2kg0HWr5r4/4lJQEx3jW+bU9RIjgxqDeHXMmNPRb0yRoafrKYIXMCydEkI2kK5dvKky0nAT9A7AMWKkwo7js3OLWSNsAlQGhLCnxWp2/C36OMj4JaK0P/EuzzBJ/SgjvubVYoozekVFKKJt32cMncIj6Uo9cFobEoLO9YHFQjeC7WulUBsRn8fVI0+QdnhGUw4dkeB1SJIKMFPRr8+mB53423acwr7XYuUSmTM9Tlc+6/CwkE5LCV1VuQZ0+6lH0R9LucDzH2u4N/X5kmKtC11qtJ3dS7h3/jCk2MIby4FdKBkm7ekPqcvUymsny4nsKMtZRw1JDipl1U3VZ+D9PFyx3rgrnWsu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/26 08:13, Anshuman wrote:
> is_range_mapped() uses getline() to read /proc/self/maps line by
> line, but never frees the buffer it allocates. Every exit path
> (parse failure, match found, or reaching EOF) returns without
> calling free(line), leaking the buffer on each call. The function
> is called multiple times in this test, so the leak accumulates
> across calls.
> 
> Free line before returning.
> 
> Signed-off-by: Anshuman <anshumantewari123@gmail.com>
> ---

Looks good, I don't think Fixes is needed (even though called multiple times,
the effective waste should not be relevant on any realistic system).

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

