Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 135B6606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 11:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DG5qlG+6
Received: by kanga.kvack.org (Postfix)
	id 410326B00EF; Thu, 29 Oct 2026 07:06:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0F46B05B1; Thu, 29 Oct 2026 07:06:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2892B6B05B5; Thu, 29 Oct 2026 07:06:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0196E6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:06:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0409403AD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:06:27 +0000 (UTC)
X-FDA: 85375385214.30.9F0DB16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E372240010
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:06:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DG5qlG+6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793271985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4SI2MOIEpxP5HU3ERLaWsdHJtIDnixVPHVu+nHUwyQ=;
	b=T9FOhPjCkHAShkKzDO8J67hICJfwjol7Nt/2w56oFFTGoN82PRMx8WRkk3YRYksLyjJtNs
	PewqcMaH0THVIPlkNc8tZ4wUBa0h+wF71ohzgPuvv8SMKNzwyyWxM/ztgirNa1l5XnGYp/
	KoTrWNmpBHvIM91iMH0GFnQGmKhSYXo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DG5qlG+6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793271985;
	b=pDyzOXgZ9HPAf3d2tAg/k5pcOHMBIy3dnT3SZayhsJIevzpUVRiK70840lFndgyZI8gzr4
	k2y5w2baGOUG4AEjOoVDeGYDoTPSUP+26zHZkSy5K4mU0Tc74dsGwaQlpwtZhmkZTflc3R
	jpvgFh+4QnFSVRot3lwlc8if/RCESmY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 16B53600D1;
	Thu, 29 Oct 2026 11:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D77C1F01825;
	Thu, 29 Oct 2026 11:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793271983;
	bh=G4SI2MOIEpxP5HU3ERLaWsdHJtIDnixVPHVu+nHUwyQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DG5qlG+6Sja3SZ5kFUK34tgk4SYB6mT49t9Ydiwl1UmmUSD3Z7eZTpdi9hErSp6J3
	 rJy+pdJ4xnrv+lAE+8PJM9LuhQ91KO44IKjD6i7lRiQF5sAG6yfA42ECErt9i+4hlZ
	 VqUZ+q8IKKTOoKoRg0gz3v3YNhG4U3iakSFkuH5T2JEkY20iTWI+uTLXikjQQRHGFM
	 iitTQcffWyPVBKOk5dKhoqgHt5X5LmnO9yty8zuvAujX+5k++YqHcbVx84qeghojpP
	 ONGbbquOo1zaFCKZkU54MNJA/SW+jdnu2TfP3rM7xp551okzH9jzB8lL389t/PCYJF
	 RNML/haAtaDfA==
Message-ID: <676e49b1-6cc0-4d0a-8492-452ffb294d2a@kernel.org>
Date: Thu, 29 Oct 2026 12:06:02 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 36/46] mm: fix unkillable fault loop on MAP_DROPPABLE
 memory
To: Andrew Morton <akpm@linux-foundation.org>,
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
 Pratyush Yadav <pratyush@kernel.org>,
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
 Jason Gunthorpe <jgg@ziepe.ca>, Johannes Weiner <hannes@cmpxchg.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-36-6f74bec9a5bb@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027-fixes_core-v1-36-6f74bec9a5bb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E372240010
X-Stat-Signature: iu6hgj5nkmx7e5qx8nfgayjkimg4cfd9
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793271985-128203
X-HE-Meta: U2FsdGVkX19ucHyPKhQTTDjbQIcNrdxdeE/AZuVHsHTS6v/5oC+szYjvtbxsyCQmgQt1JBuLBTRUKyKIFMpotxlSUSPf3C8AFBrT9DTCsUwcM+4awNFcBJ0gXIE0TGarS4Bwy/51jczJTQ8PYso/1F3FpryBS1Q59qe5DEqQV3g6v6BxaU5dxof1gC3lUHg7Vsk00pRkVF3sDS52HHuI/lQZQ2fnYM7qbY7t2YrU5sGWqYBQcDHyZIBTYxNtTMZ5Gsog2IyhqaM6z9FN+AP5tODZoEidEA2VZWkRL2g4xd9mYEgGtJNhfJrzJrms0yy7+nkbIawMmeXqGbq6f9jEolKGEM/BK9rUkm/Hl42j3Mz5vR2ek0IKAsozoRGgmyvv7t4RCv1pxKt+JPQx/oCQklFwDtYG2jMzuyiqBfHRrsXmNIibaPcv+qYywTfLAjiIXTrq7lu3gs6BKkLki05ClA3JwZgK79Haq8iMbqSG5py/MlOAnUJYbpoucIkJU2aTV+IAngx8Rtx0Hh05F73wqTICTaXGlBzd5egjvr1LMj7mbGKTgIGlyR78Cg8+pVv5ZJ5mTWLfwYbHqpWnOOLFY3/H5z9u53DZ/LykJqlgIIjo5yBd5Ay04Dtn/ZAKfpYV2hVa9WryyiRqESH2LXnQU0KymIxPlDpF8eCIGc8k2DNx0jhvxSo7s3PghUVF6rlGpyzPeMu13N4hltNP++GohCGBkUNFN7qgChOwRNdW0eRt71y/2vkgV2EoNR9yWfAoZ9m7gqQajwqX+iyzee48kvB21gcKGf7yYxu2di7wP1ujJErNdxceXx+0+gRnTb4d+vyqFHk6RRb3G3p6RvVyWllb4HCFWScrIVHnVH0NGnjjzkp7LmQRUiR7477bcsyT1JNqKs7OvN0AkeZ6F3p/dlCk4qXTIMJIb27v6Te/BkC6z/ZmzkXKSMYt5meJ4kPWyTGJsMjw81P4hDy39Bb
 4TCIUL1U
 ruUXnmDm8ToLlVw1eNIJy7alsuWFvcmJX3+krdSuciGe7dT6wDC60g4V9ZzFiVb1Hy94Q8DRgIM5lMqqm4/9o6808yMz+Ex3SPTY6q0Paa2gm4YvMBlP/kcO4KRJYoFfh9NsBk1zGESTnFOaJXfCRrdn7Ulqmg3kguDIK8WhRR9gCA0mlAaZ4bTyhnvKLxlR3xWrST7PNQsvUHsvFO/XPbglAY155bRbHas20a/soDmtzVme5YxHdS01auyJINA6e0i4gkw9ei/3AIEN9b8yAVUM1HOTIjTumnSdh9TB1D/1Mf5RTZI+fA9MliEfLCUCDocbZDbk/U2znwbRUtKyGe0voT8PqzHeQuirymjmJrQ+M4LfCE7PIW+RJUz4dgCgImTidNBvyxn3WlC/sQWGTl5wa5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 00:17, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> handle_mm_fault() suppresses VM_FAULT_OOM for VM_DROPPABLE mappings.
> 
> For user-mode faults, pending signals are processed before retrying the
> access. Kernel-mode faults on user buffers instead return directly to
> the faulting instruction.
> 
> With persistent allocation failures (esp. memcg limits), a syscall,
> such as write(), can therefore loop while not dropping locks.
> 
> Only suppress VM_FAULT_OOM when FAULT_FLAG_USER is set, allowing
> kernel-mode faults and GUP to fail and signal allocation errors.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ david: simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/memory.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 5c5f326b8bcbe..230a2f4dafa13 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6957,8 +6957,12 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
>  
>  	lru_gen_exit_fault();
>  
> -	/* If the mapping is droppable, then errors due to OOM aren't fatal. */
> -	if (is_droppable)
> +	/*
> +	 * If the mapping is droppable, then errors due to OOM aren't fatal: the
> +	 * task returns to user mode, handles its signals and tries again. A
> +	 * fault from kernel mode has no such return, so it must see the error.
> +	 */
> +	if (is_droppable && (flags & FAULT_FLAG_USER))
>  		ret &= ~VM_FAULT_OOM;
>  
>  	if (flags & FAULT_FLAG_USER) {
> 

I think this is the single patch in here where I struggle with the side-effects
and possibly remaining issues for user faults.

It feels like the obviously right thing to do, but it all feels a bit shaky.

Maybe the memcg/reclaim folks have a better understanding of this?

-- 
Cheers,

David

