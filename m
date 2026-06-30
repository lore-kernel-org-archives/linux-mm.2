Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C428C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 17:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C47B16B00C6; Tue, 30 Jun 2026 13:25:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8526B00C7; Tue, 30 Jun 2026 13:25:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1916B00C8; Tue, 30 Jun 2026 13:25:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8098D6B00C6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:25:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09A3A140593
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:25:32 +0000 (UTC)
X-FDA: 84937255704.07.5D2516E
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id BE58020018
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:25:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YVp9o9E2;
	spf=pass (imf31.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782840330;
	b=XECGmRYLz+i/SnqWk9JZlVQkSaC4wsmgiQ4VtFYx8xpTfUwVXe/276vqKS7lwHCE7Fd4TV
	7qrMfOivdIJMnFmApSjbSKgHkgtL/IX6CdfKguArqJzhDfoNvrkhPDS9Am4fl5cjEUZgg4
	7NsIu2kobIvsoMohZChjv/MKFs+lgMI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782840330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zwd17XGb6yIU1LeV9+8Zji359XnI8ZNwG9WGgGJkKVI=;
	b=ozd/PDlQtG9AO9oLYzrhgjb5gJWWmUZ8qvqXix0Q6nILgltF4GWN2mVXAaae1aah5a6rlG
	X8NLFYRS/n4Ya8p4pCtjkqHHNW/g4DhyDoYsiItWj+OpmuqmruLi0B1+Q/kk2ZkCZ+Z6Ca
	wm6HLPmIrvQPDx+IvsgSwXN+WqHFTfk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YVp9o9E2;
	spf=pass (imf31.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782840324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zwd17XGb6yIU1LeV9+8Zji359XnI8ZNwG9WGgGJkKVI=;
	b=YVp9o9E2KjDijUfWSjyzvp47sdVZJvQLpBipEG2C6qkqtzunfWsxXhw5ll3prEk7fOWGEK
	YkHVuIiNE/+fx/0o2fmyM5mcdUGIBsFimUMdh2kfx8yYnD6FLK61sJ2BRY1894iXr7DbjA
	/q/b0beFc+pfsOE924rAjPuJT19ykfI=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 17:25:18 +0000
Message-Id: <DJMK5BJH77WY.2IYQ67ZBPU7QK@linux.dev>
Subject: Re: [PATCH v3 02/16] mm/page_alloc: some renames to clarify
 alloc_flags scopes
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Hao Ge" <hao.ge@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-2-57bef0eadbc2@google.com>
 <5dcdd1ef-21ad-4ed0-9e8a-0e5cf96b4392@kernel.org>
In-Reply-To: <5dcdd1ef-21ad-4ed0-9e8a-0e5cf96b4392@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: abowjx4po1ghjiyyr1hf9yg4zp7hu8ue
X-Rspam-User: 
X-Rspamd-Queue-Id: BE58020018
X-Rspamd-Server: rspam02
X-HE-Tag: 1782840328-305566
X-HE-Meta: U2FsdGVkX18YAO9oSjZ0gcPgYIhI5ckMF6rzmcudyN2Up3C1gXTSaSagqWQF6Imse/8Ch+Q7juyS5xJwlLjPhWFFBUHx8MGYSQ9o4H0ufziKj0PfDRN+UC7dAciJCUeB/6PakVIe6phS2/Wf/cVZ+0muCnjVHxpdieqynBFhDgBqRl1AprX3NZi40yqg+nPWYf5hi04sC2dcp5p/ZGsWWKWJTqgL9t7/j92FCF4TAyjybt1nFuHjo2EWezxIPND3FdmHdwHFVWkoOuakodgM2S6VGeRwEeE3TP9v+kv1iXUFcf6REn95QgGUo7GbcxdugoN8bXssUmEcLvF1oLnT4WKudDN5S8hMZtQpncgJz9h+pXSwW/gdkdROWoQEFVBMYwmOtPbfRrSEHmiS2zLqu2lE+eIYcEOONKlp7aqKUdQuKShfayarPDSd/1usnbXJ8yVj7jSBoaQUfcnUA1ixQ7XezNcfgajXfkDafpUBgxSRoch6REzaL2wrTeCQuHoPHNu6F3dhI0wCIzXfoF/nJ+cy41btV0D1ae+Cx7r5kjsXmoWRZhhltIbSttac1zMk3eZwT7yhxeTP2xLwMJU3eIpjy1ERyYQdfTraymDxO5av7xXpemjFq/+mpgjIBgEBQY4GGicJEBm/7sFxcGtqnqJVn7gLsuVugM4aRvoWvKFawdGiF+dnDxkRqhiWHizyOBc0ZyjkXpdN1zqW04eXBZNWgV5rYtbHg7DdEqCb7urAlONXmcfnULto25vQWDfzEFEmJ12D4cGzBLPeZHVCHegB3iAffPbMjIlu8bfUlLMj1rVcvFUSYZiGN4ReEQsAm83ZVVYdflpAGgCw0NemDGm2g83SaSY+r4LpJDJFMBJH3N2gIO806qcK57k2se/CIHq0lih++/4jZJewAy3RaxZntojA8sx5r0xRpV62RjaPnKfwYRtoQ+bou5Yw1dvrv3ZzFmUBT5m7iw7RBvX
 G5cYKp/9
 ui5kBbIL2MuCkrvmg62PG3PJl5u0PaHwSvcogUgtBthbl2TlCnfe51W3uQNPxPifAHw7+vzzrd0xAaFdd0QPPx48xE0l+Vmm1GGM11gqSjivJ6S1FXxw+bLy0eNDKra9v2a1kmk0OBq71YQCRVn4rL6JGIeEsn5+r8+HS9vfIZs7RD2FNyi1PeCmeL1u4bSD5SfZX3/diD9dGe6caVIDrZGz2c1YLfgWKqNt9gkP3AkU1zxGZk+I8pN8dNW8oGuYnTynkxme40z+lPqXL5wFug+pOZj6yiEmXxXnPuN9MekR9Y8/oE2Z1IvUmrhn2Z7zBcn0HELY9zkVcuJcHzcSxVvWNzugvPu9srL/vVGTv5VeT8Lg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jun 30, 2026 at 12:38 PM UTC, Vlastimil Babka (SUSE) wrote:
> On 6/29/26 15:11, Brendan Jackman wrote:
>> It's pretty confusing that:
>>=20
>> - The slowpath and fastpath have a totally distinct set of alloc_flags.
>>=20
>> - gfp_to_alloc_flags() sounds generic but it only influences the
>>   slowpath.
>>=20
>> Rename some variables to highlight which alloc_flags are
>> fastpath-specific. Rename gfp_to_alloc_flags() to highlight that it's
>> slowpath-specific.
>>=20
>> gfp_to_alloc_flags_cma() and gfp_to_alloc_flags_nonblocking() currently
>> have perfectly harmless names, but to keep the naming consistent also
>> rename those to the alloc_flags_*() pattern (which already exists for
>> alloc_flags_nofragment()).
>
> How annoying that alloc_flags_nofragment() doesn't have gfp as the first
> parameter, unlike others.
> Oh well, must resist too much OCD :)
>
> Uh, more annoyingly, alloc_flags_cma() takes alloc_flags and returns
> augmented alloc flags, so there's stuff like
>
> *alloc_flags =3D alloc_flags_cma(gfp_mask, *alloc_flags);
>
> Since we're unifying, it could be make to work additively like others? Th=
en:
>
> *alloc_flags |=3D alloc_flags_cma(gfp_mask);

Sure, I can chuck this on as an extra patch.

