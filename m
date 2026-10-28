Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C733606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WpZXmrJh
Received: by kanga.kvack.org (Postfix)
	id 7A3046B05B4; Wed, 28 Oct 2026 16:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72CB86B05B5; Wed, 28 Oct 2026 16:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F54F6B05B6; Wed, 28 Oct 2026 16:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 335EC6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:58:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B347712019D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:58:16 +0000 (UTC)
X-FDA: 85373247792.25.E9A711B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 07A19100009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:58:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WpZXmrJh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793221095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkkxJXamG/EOg1fXbdxdVy//NPlViTUZPyzdPBS0XNI=;
	b=RIRwEaSlYk9Q799gn1PgJA7daffRDkbq9Xwufn5yJ4ZLzDGiSo7XEwFJi98XAvs0PmX6tX
	uCw2OuzCTV6GX6EgZnnxIsoEI1J2INcybiUAguoe6J8YI9UD00bfbkTRB+OC/LMkro62nG
	BIn/9SdVg0toUkLEYeNh6YDCqAqqnwA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WpZXmrJh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793221095;
	b=ngq+RKlLIIR6LtmTSEnfCuDSfMvk84rNvTBP9Uf46+NpY/MUcDhT8NweeWll5xs2Dta8Fb
	ossq87/Q6wartWM2FIW5zZYm3yrtgmd06BllpOOgZ1NsUdjw6xyWRXOC0EIEGi4bdxLavg
	3tXJbsUmstoxWRyJ8aFjjOcro02Gg/Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BF55601FE;
	Wed, 28 Oct 2026 20:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385F51F031E1;
	Wed, 28 Oct 2026 20:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793221094;
	bh=OkkxJXamG/EOg1fXbdxdVy//NPlViTUZPyzdPBS0XNI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WpZXmrJhfZ4oFqEjPk/JBXWd575607dk5zGyo1rvpwVg3yy5YfXeNqH5w4vNIuQ0d
	 ktOBD8dQNFzWnH3XPl6qzKMN2hP2/vyEl+46oFkRGa6BZf7drUChBa82kCuH/c0DUS
	 4CdKqDnR8j5WZaqwqSM2nFlx0ftJBuLWGr4Lbh/2VrlOFq7ZhO68etuPzFcaxVfO9F
	 ZsFMFRIJFcw/2vEWbBe/tqJrUBZIpK95m9X3L3KY24CdVU5OCiwKZO7X6MQczUDuDg
	 AGEl/ld/sByznq2EWDJP+O/uKfdSVS5eGuApV6Jdg6Ibbm/bAgkmLKnbgUaCwCgLH9
	 zwTicYTUGAKpQ==
Message-ID: <da631095-bc93-4b18-b5b3-c68644f9ee0f@kernel.org>
Date: Wed, 28 Oct 2026 21:57:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/46] mm/gup: fix clearing folios in memfd_pin_folios()
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-20-6f74bec9a5bb@kernel.org>
 <2vxzbj8fp4sn.fsf@kernel.org>
 <ec55c760-f099-48e1-900b-9f8e2e5315da@kernel.org>
 <2vxzld7injcv.fsf@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2vxzld7injcv.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 07A19100009
X-Stat-Signature: xqftjunk4qdqqdckq6nq4zf6qq43aor6
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793221094-264581
X-HE-Meta: U2FsdGVkX18ASL/c/jsZCnhetftx57rWieN5WtrMaS6IB138CICYsBP4QVwyut8tR4FmnkBeTf+oZrtMLDIZCRZ2n7Xsp4C2WaPxZLbn4rtRL2nUHXvzdEi8w8RgIxeYkcfdKlw88vUXkxXoC06BJyUFT8hUmqjiz3Ay55DFaKM32+8XfdtyLN1XGKLiyeg1h3aYqNdxbSiUNjeq3e2J4hXBS/3xufHaimeIuvfAV03VT53P6kTDTg+37BSx4vNcOYzc2kp4BEBBtNf5hZgRgMPHY1j0T14F+7ajGAaTUIuAQP+nfRHBxk4oxEms2jOEtfCiZn5EpwFWzXBSL8ssdpI7XcZPN88mrsDIvMzRJ2iWMgmwR4AL/aKvyIB5RkN69NDxNC/JG0ebpe+dKTcUNWIxqQi+Y77pXyDnKCNrOV0SfqsFad8U+YluvVEsU7m9ALBv/6+oZAidWFfx8VdHm3AFx1EYZburIVxAh4iB1dPhw+HXvhdTyYTfXzA1jK/z3STkhQ73YKj4Kaef6Wz/3BuoJZr8aQwzuyQU5UTDehKUqqz4Wk3lwWfZtgXi3GUBdfJcMP0IxdvV0qKjdKCZLihnfwQtjeLGPVTNx/EjghWKxhJcbYw6vrzir4jObj+3ufyZXP01da6SuNGbFoXLEv/DvF0f3TXirt1+hp3thyub/J7lv4Ma6ksU4gcLKroTe9xr/CqokystO/gLPDahS6OYU2sDwLxQYpBFrvI/QCLhAIQGzkLR0ufQIu4xVnLXZN0W/YrFM8XDPouLHKp62qPpVtYkMb8DZMJXGd5m/GIz3GxXAa3GB/ZYtL7jPtOYgYvWtWAUbF0gKK8/ZcmWC+Ww0GrjVUtJCscNqQlA5VnjpVjRBRk2Oromv3eZARITaAxjrYWTLzUzmNBJpqnrJe1jtegtsuiFx0ik90HTsfwo41g9VTaIIio408zCHTwBxUp+XL8449/j+6yTNrX
 a50/2KOC
 QWhfkx6jFQS6FUR77G7ZWYhJE6pgf59doh5wkfGUT93LA4DANZMFMviz/D7LZefwaFzWqyZrmrYxfqrk4uWGAkQ1XmiShbwcD3qXHkq8zEh7nVmxhj6uvuMH0WErIlR6n6H68q3wh8W+DqFoSmmgNYRjK9GTjfOgrNc+RE/jxKDw2EqbLaEtXXW9GiZPgOh707rtN2hDZEgAA4UlKSv3fsJQM3KEs22rS07uOAbYCXTfGVEkCmDyYQU/Xlt+k7kM9r3SkecMLyRhPyjnxNYAufRqYHFAua8XzC1MwovokfSSFSplziHFgpRSGlWC/FYps5AEvWlSZZlto+joIDrMzv1eIAZbhbD9WwGBHnBq9MySHnh95P2E9d2AueWUXNIC4z9zs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 12:40, Pratyush Yadav wrote:
> On Tue, Oct 27 2026, David Hildenbrand (Arm) wrote:
> 
>> On 10/27/26 16:00, Pratyush Yadav wrote:
>>>
>>>
>>> Nit: this logic is repeated in a couple places in shmem.c and in
>>> memfd_luo.c. Perhaps it deserves a helper?
>>>
>>> Anyway, sounds like an important fix so don't make my nitpick stop you
>>> from landing this if you don't want to bother.
>>
>> Thanks! yeah, I had the same thought when trying to improve this. We should have
>> an easier way to just not hand out unzeroed folios outside of shmem core
>> functions in the first place ...
> 
> Normally this should use shmem_read_folio() to get all the folios, which
> does zero the folios before handing them out. I guess memfd_pin_folios()
> uses filemap_get_folios_contig() for performance reasons. 

That is my recollection from back then, yes.

> It does the
> lookup under RCU and doesn't need to take the folio lock. Perhaps we
> need a shmem_get_folios_contig()?

That sounds like a reasonable cleanup I think, without looking into some
of the nasty details. :)
-- 
Cheers,

David

