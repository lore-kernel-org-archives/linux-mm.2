Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AFD4606A325
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z3V2ir1f
Received: by kanga.kvack.org (Postfix)
	id AAB7F6B0657; Tue, 27 Oct 2026 05:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A836A6B0659; Tue, 27 Oct 2026 05:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999026B065A; Tue, 27 Oct 2026 05:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 637336B0657
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:35:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31D594098B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:35:16 +0000 (UTC)
X-FDA: 85367897832.29.717248F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A31A280005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:35:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z3V2ir1f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793093714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyDf/T3A99e/UK5Tx0KKev7xPaxEfXMruyrCYj6de1U=;
	b=IJ1J8aM2h67GvoEDeBY0b/5EuFgpwglFERqhJ6P5YiSzBWhoXhthMRZVie06pqOV4axH3J
	k1lRRhlxGuCqvd42FAAqf8SvXa0jHE6S6IX1SMr6Kn6npn0m9x6AO1BSsrSJcblcZYWs2K
	V95Eb3rqwsWy0NxLLZ/fKCxAMUMzKZc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z3V2ir1f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793093714;
	b=2Q4/CG6piJ+UEu9+gWZVAeTs7H23FRVtbY1o0NNzJfFBA0tDG83dfKv2QOcIiYcPN/yu0B
	mqNKObX1lomF1euk8TeNxwLN8a2+y7VANe3sMxqvDo0Sedfl6MdEut9M31FQhFpkZvS35x
	PuOFZ+/sdFuTdQxfMPJeumsqPIYsoi4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E4E460052;
	Tue, 27 Oct 2026 09:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD641F01825;
	Tue, 27 Oct 2026 09:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793093713;
	bh=GyDf/T3A99e/UK5Tx0KKev7xPaxEfXMruyrCYj6de1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z3V2ir1fhLjLEOG38tPqPyKd7K/FHGfPC09OfR7eOlE/pdqk+8s3kVa1i4DQbH+Qx
	 MZ32NLc7julvf25Egjxt2K1dVEewhL3Of9L8IHSEkMikSMuPsfkdtPqT3BAFRQIx4l
	 I2aocqwSNzVOB8HXoD0iEYYGXcOv8ZXfRuVth/j1TS6G/Q38VWONKl+4C7n5MEPxNA
	 MdDQY8Y20j6O/Wno2AqROjn/Br7ZnF59rm1EwFzdyTg2TjL0F8dx2lgZTIglHC5tyA
	 DHYvTnMV0DHzDPWwpSElNE8EW4/oPBEyMA8Gm39jeV4/zgUOyB58UgoLt0XQBoz9Do
	 0CxG7SV58ggfg==
Date: Tue, 27 Oct 2026 09:34:57 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 22/46] mm/gup: check for overflow when converting
 nr_pages to bytes in GUP-fast
Message-ID: <auBwBYzcs-segDVk@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-22-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-22-6f74bec9a5bb@kernel.org>
X-Rspamd-Queue-Id: A31A280005
X-Stat-Signature: tinyga3hdhu1stq613zfamcipatos9x5
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793093714-728426
X-HE-Meta: U2FsdGVkX1+K0kSncXlMzU5blG7Z0OdC0kaWa77UD0wg4MV7mOataCmOautuznWN3vxQnoZUKtXkjlbf+FMYyT9zx1eeAojPM4ZbocvEM1Ihal/yd2Q3FPBv157gfdR1g98mQy9R0GIg9pCoXiTO0S7aCh7nusmx5srXYz4pJiM3TSuTAdQ332sAMWSpccnf+yHCyOoUhwGPI9AFIMa6Ul9nYoSJ1bOU0zd53DCny8DjBe02MFR/aA4q0JLn1ZUcm3cLGO3we+vT80bzgrp1otLDoSQbmFhrwatgTNDbSyrbbI7DgFeASOTYi1sBT/LqypbmHpuZRI0GzJkn53eQGKOidWdBJnY3+HbC4PBc7Qfv3YCHZcgT+gE0qQ/IymgG48Pka/g9Ks/EEM3YWg5sAPti1pbJA0eulljMihd9iLZEmXmBwirLvr/VbUf2ClF4hNKqov91pk80ucSJdb/Y7DOxIo6Dihf3xdIckrM50A7VJl1fCtpOfTqMmtOdwrHutvlm7cSu6LgO0uPsIBrDq9tjfdoEyvfedV/I9/JLNgCDEk9A1R4ok8OpWLmV3O+SqqxLhvQ3QhWLottfw7ksfvbUW2w8Hwefij6RsN3qKplA0yrdwlpgfqOPiWX54KlU3BWJ4uqwsxISuNOujnnZeYPN16U+WyJ5vHaA8G+egrZVBnoLq7oGkgTE1RY5/B2TreCiNP8twLUypzVLIqjH+fxUN2DtUdf+k/9QTpXZVXB03IRkQkYsGeOMBOkIQrIQtUeXxmoWTkSMiouqcJcXkq4TnHbz71DZvnD2xef7dNmPseP5ih/VQrWXmoXjvsyVEgiUAPnwmi5WgNW0Oo9YBYC12N/i54otDFf9eC5RtixozBXgETlzPz9jJCdy3+D60cufk1CjBeGk2/NOirOgJ1ySfR6sg8nSvunda90RLqlRoSvCtQXidDmyeZz1tPoRuCbb8yMpQjMgxBAC/jB
 NyCCRgJn
 reDbqzMsJIk8JEuQdgW4TlKuYAuDdenIh9EDxxn8IkSH/79ImKhOQ5e4Nw+XV7hI0B2+YXvY8e/e5H2M0gtx+dr/ekBuaxHXX1qZNlBfLNWbul5Zj5kKDYOrDLpFymiBQUtBy42FpDDf3Ygx07/7CF8XcPPZkGhfu9ITbe997EDWKC2CIdd6c2MRfIVWw/R+R6dnq+pukBi3wswjJsd3hyuJ3g59nBPQAf5kL3B3PvwtAvv/CtSDMGs74DbYnBTAHHMA+vdPpqfdG+QPOmcTpuOWsHlaFSx+/OMQuo76EhZn2Jqh+JkUzysiY6TLJP2uqSS292JPbPOe5qQe3jcZJCxb3yeXt5u3j49zKGgshVeChAzWl/l3P9lnwJ6Ij9Fon9JNax5sgNpztcxE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:42AM +0100, David Hildenbrand (Arm) wrote:
> The overflow check in gup_fast_fallback() only covers the addition to
> start. The preceding nr_pages << PAGE_SHIFT can already have truncated
> the length on 32bit.

Insert rant about 32-bit kernels here :)

>
> Users such as RapidIO's rio_dma_transfer() can derive such page counts
> from a 64-bit userspace length.
>
> Let's just check_shl_overflow() to reject any such overflow with
> -EOVERFLOW early.
>
> Fixes: c28b1fc70390 ("mm/gup: reorganize internal_get_user_pages_fast()")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/gup.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 9906965893431..48e1bfe5ab9a9 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -3214,8 +3214,8 @@ static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
>  		might_lock_read(&current->mm->mmap_lock);
>
>  	start = untagged_addr(start) & PAGE_MASK;
> -	len = nr_pages << PAGE_SHIFT;
> -	if (check_add_overflow(start, len, &end))
> +	if (check_shl_overflow(nr_pages, PAGE_SHIFT, &len) ||
> +	    check_add_overflow(start, len, &end))
>  		return -EOVERFLOW;
>  	if (end > TASK_SIZE_MAX)
>  		return -EFAULT;
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

