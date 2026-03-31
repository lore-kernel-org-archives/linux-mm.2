Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B5910F92E6
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 16:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1622E6B008C; Tue, 31 Mar 2026 12:29:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1132D6B0095; Tue, 31 Mar 2026 12:29:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 029066B0096; Tue, 31 Mar 2026 12:29:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E629E6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:29:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A16A813A42E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:29:56 +0000 (UTC)
X-FDA: 84606894792.10.A4B3268
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 66505140006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:29:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HStgsD/V";
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774974595; a=rsa-sha256;
	cv=none;
	b=mHAIZyASPAi98OjRgUu9AE15WJmgDZduymx/12FQdstlGnY/xu+MMGWaBccw2XiwVawj2t
	BmcaYaz8PykUmGhj9MD2AiLEFnxmcqmQPcH/pupX61on5n131XadP8M7JbGuVLNrodzN2h
	cAbDxRnKlwXp2H31ddYsEA2qPlArwxQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774974595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+PBWmKg1y16S9pTva+QSFTjRb299uFwMvllatkfV6A=;
	b=JCFpxq5WkTIOe7OOW0zJk2Fq2awfkH6DR9Ohm4ltP2J/oQWftO9+JeWxfQahfmQvZ7W2ZP
	IkinCn/Vd/HIg9pCulECPAmS97xuyoCliw2uWnnEDSO4RDSIH5kH0GBhZRyWqXgycekw20
	OVjf2Rcoyf5cg7M0hsSDd5ekUHg725s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HStgsD/V";
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <abd47506-9bd0-410e-861a-a747d284cc77@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774974591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+PBWmKg1y16S9pTva+QSFTjRb299uFwMvllatkfV6A=;
	b=HStgsD/VCRwVsSFrv9YmieEjeotbS2UpvXyW4M+abW7SekkdkMRu+geZDuDaMCdFwZ9CEL
	dvuE06nvZHXXp5b530P3Jzdtocua3lOERUfFwUOtgD6f+Srdf3Z5Akw72OXUD3/iEwpSid
	HxXZc9L5mtyQD9G1JlZaTqfwn0qEZhM=
Date: Wed, 1 Apr 2026 00:29:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260325114022.444081-1-npache@redhat.com>
 <20260325114022.444081-6-npache@redhat.com>
 <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 66505140006
X-Stat-Signature: 8h6neistow7h8k1kkbznko5764o796g5
X-HE-Tag: 1774974594-678430
X-HE-Meta: U2FsdGVkX1+LZTZhRsc+04R7kMGwjK3enyMFR9OSsbhtL1FSDtITtqGui3t4l7k+2ZUXwgSsUl/EtCSyYZIG/Z6jiF0xIYR/BwEhVPN0h616+Jpk1jKMg60z1/HysA+6MssQycwdwhAkgLLPpAV0oI0aV1p22zSnvGD/6e0v+aRlyLglRL0AplDY/6/lDO4AqE/xgk7ry0/0bpoUOK+UMrofeS9XamJcROpf2tmIXZcnNeEGijXMoW3WX6HmLh4FVPGDESDPownEq5VWPbueczL9oPBkavBk+Pd+cm2Kgr+BfHnpa/xg+hj643T6NZPpf62A3ptgGayMAPl6xnQD0PYl3djhl5IyAVIu5MkhnP8VHEvRC0IXq6uFoMQmkyciUNcVsm1o2Cn5yriOg0i/Jox9R5kAbgQfN6sCJV3bbf/xW9OUjTcissmyqQx4e20QKmGVqE9mQADYJA6QQ0XX0B6c2QYrVXA6GURjrPA5LOBOIh+cNvqgo424Yybj8Mu12N5Fo6qx4hJ1FIooCrDLe7o3g5cMBLPghqMyvUbY/urIRIUu9qiC/If4hBEKSrWhyZ6bh5ZDGrjkRnWCSimT27Lmr4wdk+cG5X1u9TaWL5RJcna6gOcmWYuiAf0+NJJl3Ah9AJed69vqOfQ8feqYlA3YM03f24N12I+JTUrsb9dZ7CUz8qja2DA6O6U7cwXCcsum/gX5jc7Px5ZPdzXRpAxq+aNyDsHoyqX9u0LcHXtJ4N/qjbq976TykBvRzDSO0VlwiLis1vYmGZowqXhmH44bbARcZycCRRAgz5Hb3edx6TlCSg6AZA6p+Su0cJizCxxHs3ionzS6Jo/obKkZ7xOuuJCKBeb+fee+S70bPPDSrlDWSpaiWTNaaVjtaKQHdXc+Sulli2bfwSnF/fJsml9ncIQaA0Yynf67828BAAvNLb5mOyUCXZb9BMmqUITKml9W3HQzTlqWbIXhJ4y
 eMTbe7j9
 eVRFfcCmZvgQ9l2g2tr4/M5cJ0OGSdYF0flJqWoYj7Z2u/tTr9XvDvV9vD46DU4zUUv7XfOXEwwqPYHyNyz2KM53RI8PoDdCiUyBn1mnRCQB1vZaozkTO+bM3sm5gRpAb2HnMtYEtksJx+48Owt/zSIqjjPKzKyzy+ozSVIk3d1jJMjh4VG+/gLT1d4wlvqPdvNvw9Ljc4mmrPWOYE6sT/uaKyFI/DYDemEUip/PFWsaAyMI+SVGy222vFxYvN4pHl32FHiFVab1FDjhHsvQcnD8qeUP6a2iWUf/tFSle/XXbupFMpi3ZOXI6NIeDgJRiWvC4PVV1QTNfD2G0FOxcabJu81xEXTSYJCC7gN60EF3eDsf+lEK49BV+BJk8pJ6eTpy8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/31 22:01, Lorenzo Stoakes (Oracle) wrote:
> OK we need a fairly urgent fix for this as this has triggered a syzbot. See [0]
> for an analysis.
> 
> I show inline where the issue is, and attach a fix-patch for the bug.
> 
> [0]: https://lore.kernel.org/all/e1cb33b8-c1f7-4972-8628-3a2169077d6e@lucifer.local/
> 
> See below for details.
> 
> Cheers, Lorenzo
> 
[...]
> 
> Fix patch follows:
> 
> ----8<----
>  From a4dfc7718a15035449f344a0bc7f58e449366405 Mon Sep 17 00:00:00 2001
> From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> Date: Tue, 31 Mar 2026 13:11:18 +0100
> Subject: [PATCH] mm/khugepaged: fix issue with tracking lock
> 
> We are incorrectly treating lock_dropped to track both whether the lock is
> currently held and whether or not the lock was ever dropped.

Good catch!

Right, lock_dropped is not supposed to mean "is the mmap lock currently
unlocked?", it should mean "was the mmap lock dropped at any point
during MADV_COLLAPSE?"

> 
> Update this change to account for this.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

Thanks for the fix!
Reviewed-by: Lance Yang <lance.yang@linux.dev>

>   mm/khugepaged.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d21348b85a59..b8452dbdb043 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   	unsigned long hstart, hend, addr;
>   	enum scan_result last_fail = SCAN_FAIL;
>   	int thps = 0;
> +	bool mmap_unlocked = false;
> 
>   	BUG_ON(vma->vm_start > start);
>   	BUG_ON(vma->vm_end < end);
> @@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>   		enum scan_result result = SCAN_FAIL;
> 
> -		if (*lock_dropped) {
> +		if (mmap_unlocked) {
>   			cond_resched();
>   			mmap_read_lock(mm);
> -			*lock_dropped = false;
> +			mmap_unlocked = false;
> +			*lock_dropped = true;
>   			result = hugepage_vma_revalidate(mm, addr, false, &vma,
>   							cc);
>   			if (result  != SCAN_SUCCEED) {
> @@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>   		}
> 
> -		result = collapse_single_pmd(addr, vma, lock_dropped, cc);
> +		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
> 
>   		switch (result) {
>   		case SCAN_SUCCEED:
> @@ -2893,8 +2895,10 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> 
>   out_maybelock:
>   	/* Caller expects us to hold mmap_lock on return */
> -	if (*lock_dropped)
> +	if (mmap_unlocked) {
> +		*lock_dropped = true;
>   		mmap_read_lock(mm);
> +	}
>   out_nolock:
>   	mmap_assert_locked(mm);
>   	mmdrop(mm);
> --
> 2.53.0


