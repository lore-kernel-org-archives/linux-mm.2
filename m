Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65645C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E8806B009D; Thu, 30 Jul 2026 07:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A066B009E; Thu, 30 Jul 2026 07:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0436B009F; Thu, 30 Jul 2026 07:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2E96B009D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:50:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA8E2400B0
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:50:40 +0000 (UTC)
X-FDA: 85045275840.09.160CD24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 41FE7180012
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:50:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VFxavYoI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785412239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2x/3afnS5nA1+U4o3Wmcac5daCL5SWJ0JULSmSn8Nlg=;
	b=UDicvZ8BXH68/ZU2rmUvWz3PCWT8zr/4nCbxPXujYiLEVTsHwMLNwYayp4UGofV/9S9j2A
	B5jEi4kv6t+sVqKB52Rz5b5kMpu+VuGiuc1Zf+xiwHcYmvpeGrFmyEiOcRRvnunaijA6i5
	kk1fQuJau0UHDj7OS6x+1m8mxkBlkEo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VFxavYoI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785412239;
	b=Ld7PyJ+mZRRcGuC2w+u2W9MXK90b8/bm3VvimWjAGxV36AD9hdlBfPstFggU/aCuohiWcF
	H/wyJIh91hT8fI1JHj/ye6r6EVE1chYmJGPgAC1Bv+VbBwAN71Xkwl+4xjYSwYKK1/Bczl
	PQ2XfCmQB6HvRuKNftyYqbJcr/L7bSQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BC3A4075C;
	Thu, 30 Jul 2026 11:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE7A1F00A3A;
	Thu, 30 Jul 2026 11:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785412237;
	bh=2x/3afnS5nA1+U4o3Wmcac5daCL5SWJ0JULSmSn8Nlg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VFxavYoID/H1SY3p3HdWy6FGgQHd/Sc3WjhPk+qvd7eOlGYPzkZo8IULG3d/Yrb8P
	 iOx/Wkl/68RIeETIGvf7cm8dC2UMMZ1wbyKxqav0vNGc9eoTVdOAhOwg99eCoZoam6
	 owNFEC3JwnEO30HkW3uOqO3ALOkSiuWzjNwwrPM7x7Xh2Qa+Jq54B6PD4TnGKro+eB
	 C51nzZV87/Yb4XRcHdWeJMx88WWTlnurt6kNXm8tFVuB5MOzOYw0dWFZNf3afQuQJM
	 7a05sBj0fVAfgP7CAnAZkdt9liUQ6j5fgy6hfRYcbaazkXrGsBQWYwKLS3WZW7s6c0
	 KGY7i8A1ouf5A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,  Jork
 Loeser <jloeser@linux.microsoft.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/22] kho: generalize radix tree APIs
In-Reply-To: <amsN9_4LTNFBxaFE@kernel.org> (Mike Rapoport's message of "Thu,
	30 Jul 2026 11:40:23 +0300")
References: <20260729145610.2827231-1-pratyush@kernel.org>
	<20260729145610.2827231-2-pratyush@kernel.org>
	<amsN9_4LTNFBxaFE@kernel.org>
Date: Thu, 30 Jul 2026 13:50:34 +0200
Message-ID: <2vxzmrv87l2t.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 41FE7180012
X-Rspam-User: 
X-Stat-Signature: s6xxkgx49wx9jcr3wb1cdh6d1sowtkjx
X-HE-Tag: 1785412239-22309
X-HE-Meta: U2FsdGVkX1+ofHZp5iwEx3DNqNk9NpPDP0WKNqgNWiK+6pGKf39hNPxmd//dRQRQrCJ66zpj/hba0Vbl2iyhuW6OT/wAK0sQaJdH4jO/FEUBBHNT8wDoKsVsU3YWD6YNI2kY5CVsUlZSW6vt40Ksj9ZJt5BCSzUsMIhvtzgHycjUK3KQhCbRDhK3F2w1rvdOUy8rLaYoVpHJ1vhY6sA53bp74IUDgLVPJwKl7AssUpn1m+jRApvOe5vx6O8fAiXjsPRYKW9rf8vlkYxjrdMJmSN5mI43UXhRcKRwF8MJ/OpcT904wTVkjfywOTA99VVv1NRjQrRQUA2UZR1/eNvYcpobI0nNO6nQG6mzWX8UIZIuelsaDk5O9guexZG/j9q2tnGxEi4E7SlPhrnEZG1pKqjfItbTFx+UR64btpCawZqjmefP/15Ja8Q91FoC0VFo7c6NViQeLXHuwe1dcjfa58f1s3ZQk1JLb7CSM/X0/rOY4+NAdmMmNLudH5IGbDaU0DuLTDP3qqmXOTg8CauoUy6DyzZU96oXE7n7O3Wi9wSkG0ToSkS0I3jOLeLiFSTiLQuqHTHA8btTMe0oXgPApk7Vc9dKBIvhjZ0r1u5RtX5fQEz9tyK3jGI/IUrjxWopGokpUbSkgm1YjXCjJyc6lCdaHO3ClGwkaBBQtJmslZjj5Z3C7nGW8W1/EKae1hmPuGwFIJyt56nu9+cU8e51cthcAWrxtRMs4kufFFCNGBHx4tZu8kKGGdIE2r31iBFtkzTB/yFazCuR3hZ3wGsyMN4hCkdUcN//aewtfeNJoAS0qNjNUr1ry33isKtxud/eO1lisMoBomvFocGeYXBJArS/3aNG91nPxsnXZXeB/v3qNgGtGhOfZX8UfaD//Lnulp7ndEEafCcZfyO+GWRkWT57ozMk76hTZn1RT5JPSB9y+vTKQKsjbD1MtyjryYxBFnQfkAU3HAdZC11D5pj
 /rL0s72u
 U6DuWqf4saep5GO7d0aDVQaee2xcCYkqvOXWkRxxePVWQTx23iCvgPHErj7Zz0Zb5GtCOlnF2IVElLiky7TgrK4qx1NBWQwNhJvm7PJYaMs/VwXsi78SJL399tx9AJJLNC6MVlywWSHU9y13KxtxQPkFSqkqI0eQRX7QKZjLyuhI9QGyQJpQG2WeSf2AZ3FE+CpxqatwCXo3MlXNjpxNmYQC72atqtXRJc7M8r47OX1RKBKQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30 2026, Mike Rapoport wrote:

> On Wed, Jul 29, 2026 at 04:55:46PM +0200, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> Generalize the APIs by taking the key directly and doing the encoding at
>> the callers. Rename the functions to kho_radix_add_key() and
>> kho_radix_del_key(). In practice, this removes a line each from the
>> functions and moves the encoding function call to the callers.
>> Similarly, update kho_radix_tree_walk_callback_t to take the key
>> directly.
>>
>> diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
>> index 84e918b96e53..f368f3b9f923 100644
>> --- a/include/linux/kho_radix_tree.h
>> +++ b/include/linux/kho_radix_tree.h
>> @@ -34,30 +34,24 @@ struct kho_radix_tree {
>>  	struct mutex lock; /* protects the tree's structure and root pointer */
>>  };
>
> sashiko: This isn't a bug, but did you miss updating the kerneldoc for
> struct kho_radix_tree?

That's new, sashiko didn't find this on v4...

>
> And indeed "DOC: Kexec Handover Radix Tree" talks about addresses and
> orders.

Yep, will fix for v6.

-- 
Regards,
Pratyush Yadav

