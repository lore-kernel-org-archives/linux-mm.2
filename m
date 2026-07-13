Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A72C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 024CC6B0093; Mon, 13 Jul 2026 12:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1F0D6B0095; Mon, 13 Jul 2026 12:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE17F6B0095; Mon, 13 Jul 2026 12:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A75A96B0092
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:13:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C23A401EC
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:04:13 +0000 (UTC)
X-FDA: 84984225186.08.5269DCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7C58C40007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:04:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fS+exrWX;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783958651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ctxaFih00G9qrQW0mFgwMAslrGjZZ5EaDpOAMDEo0jc=;
	b=gskY9xatZT0TbahvkJVQiwI4YXs9prmKIS80ZZ3luuHKOtvF0i2ncPoa/Cvf7FXOar1bjn
	AgtgDH1O2TMehbbBjLUUmHbmRlUcTpcRh3+P5HdTB495EP1lb2mJgm/vdJezlIQdgg2Abg
	/TvzUcsR/uuPMC/X8+GCRoh9NduUkDg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fS+exrWX;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783958651;
	b=GVKbZCNOgrFt511INmUZS5Jf3GsIAKku9HVlArHa7kg4VV+Tr4kzLnED8in1TI15Wj9vzG
	Wavpxa2n0gr4dyj1Fd0gLXDpf6UpbzbubFsQ1xuIqyTYN+4cOJVC/iS45DVWsoQK7RdvHK
	P40ipSvJteN5PCwbZj0NLd2aMfzGePk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B14A641AC1;
	Mon, 13 Jul 2026 16:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A074C1F00A3D;
	Mon, 13 Jul 2026 16:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783958650;
	bh=ctxaFih00G9qrQW0mFgwMAslrGjZZ5EaDpOAMDEo0jc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fS+exrWXCr+L3VLPeSXD+tD3xkU6t9CX/R2wB0P2yv0LiuamHNkl6sKHPr8KBHQ5S
	 pSs5LTOBX8iA38rGaAqlX+plNEjShJs1m1CQ2GklWuvmaT6Q3Uk0woyNV/BfM5OEgc
	 aD3PSQMfK9CVsVDevOSlv2Rpmuk0JI+KOC8Ua9XCmEVFbYx4lqcPeXPnpW8oPWI3Ac
	 o9PX2ee6TYHVb4Nmvef5W6hldsDUQf6Ug36fPE6FSWPuh+OlgmmqOs6FMzBIrg0kHq
	 hzmN96dmjXhD6qUog9uZ2Y5MTkFB5BxSFhdIj3AHV9UVG/CcpxVv0vVo1XMexigQLD
	 hbR4uV+Fe+xAA==
Date: Mon, 13 Jul 2026 17:03:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
	chengming.zhou@linux.dev, qi.zheng@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	wang.yaxin@zte.com.cn
Subject: Re: [PATCH v2 1/2] mm/mm_slot.h: add a helper function mm_slot_remove
Message-ID: <alUMUs7p8irN79gL@lucifer>
References: <20260713143534964Cml5-QLfcPMDtbbq_j7tG@zte.com.cn>
 <20260713143707966lCkTinO0i9zYAc1K2ZmqZ@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713143707966lCkTinO0i9zYAc1K2ZmqZ@zte.com.cn>
X-Stat-Signature: twxp3dxs95jwbxsdjum37chkaqtkepzw
X-Rspamd-Queue-Id: 7C58C40007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783958651-680741
X-HE-Meta: U2FsdGVkX184wblwswmxFK2WckHj/MemrjT9UC1vN9OlvtOSXFM1RlZoAFHAINlwmTAnSGDjcdarjxZM2PGaGBsTNZgK9Ge/rXGdqlj4JS9RpH4xtd+d+duglLwLnUtosFDQRuQI2g+MxsQ3MgEev14ssjDyPReTejtUzBvKY3Ij3jg140QRQFNZQPDekhqvfNbrhN2OcX0YebBlI9oRzvR61pLZJ2d91PLJsxLMGKrl6Jc1+MveVeCWAULbsG/x88nRZG1JmW2cHiyKSLLivBEZ2DHnZjhMsQVuFmLefCNK/0ykKM0wU20uN0EZ71zsINJgh8wOBnJoL35lgWsYrZK1rvBZihNf12CbCWXWt6upnxc1aE5x4rj37um+819XMT2BFgXNNxwQ8MXEAA/BQyV63W8iUXfV6oR0lYuYwplaX6akkSDa8b+7iPlj9RDPbfO54YM8pnWIBxpOQmaLHHFhZ3TEL6VGtDMkhjxLcBOh92IIU52ROfUoRrbivYviB612W01A24SOQ6naZAgoneKPMlPFCMIW0CxEqo0f1xydu3hXpPprizxkjFKWnQKnvPSgRIKaqGL/b+9uvRFYNL/bwf+HBe068XPbppoUTREy3p0r2PZpggKc52uySdf7Rx5XkiKmkaPX07WAqxfNM7HukJ20ndquwOVhdysEBOXPLh9l6SkChcLmgx967r92wHoVs0erNlkIodEvakavU0yMZAs33YBGnvaw5/ZRvMfo4oL4uoADfeXi3UzPfxPz0QV/y95rDNvsaCXPQ3CpQRAHuFg2mZrmttkGcmNSCIkKTGGp+h3lHIUOABYrD36bykR8pdGjtTd590Eh7nlzmvTKuhYhz51e0y16KSH6oWyK6P2w2QOB/UfKhX+P7tRoL9OVotSZgnnAzGSRW5ro3mxWWKJHObkvAtJX2qlc2bH5l3w3YONef2ROCxgd+Kua8NEbTR2DvNGiUEU5mKQ
 vnJrzIE5
 qOkfXdLYN9OOz7BMp/JfWDAVFoy7i25LGXnbY1lGjVQ4N6ANzNiQZt7h41wATcIFdAwbjgm8fYWehlMdMzqGYrdrFdDkq1VEJ5ZYnvZGUCsBypth3SE+ykCriFtFNORDaRy95l076pgl/2GDJS8tfq8zuf7fM9/vPRFbkmy77GGTx3uNheEy8tVGXJYXw1tUuccqANuVXak2ILls6uxaW+ZI8T3bUxyToQN7WG+L8L/O+vQzxVRXTgpT3I1yjMIz9TAGTQy2SyP7XNZLL5irO791uQlHkElSVv33ydlMPf+zRS3FLbANoFH4fVmPGiPyLoMLbsOYYB6S1x9BG37IXdqDm9bz0xLNbCl5AjtgCJdQT8R0sixuuhJSFZ0ucHzz5M31F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 02:37:07PM +0800, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
>
> Both THP and KSM manage per-mm scanning slots using the mm_slot
> structure. The slot is kept in a hash table and a list, and removal from
> both containers requires the same two operations: hash_del() and
> list_del().
>
> Introduce mm_slot_remove() to abstract the common hash_del() + list_del()
> sequence used in both khugepaged and KSM.
>
> No functional change is intended.
>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/khugepaged.c | 6 ++----
>  mm/ksm.c        | 9 +++------
>  mm/mm_slot.h    | 5 +++++
>  3 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 58e14d1543ec..5f6eb1bd9a67 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -606,8 +606,7 @@ void __khugepaged_exit(struct mm_struct *mm)
>  	spin_lock(&khugepaged_mm_lock);
>  	slot = mm_slot_lookup(mm_slots_hash, mm);
>  	if (slot && khugepaged_scan.mm_slot != slot) {
> -		hash_del(&slot->hash);
> -		list_del(&slot->mm_node);
> +		mm_slot_remove(slot);
>  		free = 1;
>  	}
>  	spin_unlock(&khugepaged_mm_lock);
> @@ -1802,8 +1801,7 @@ static void collect_mm_slot(struct mm_slot *slot)
>
>  	if (collapse_test_exit(mm)) {
>  		/* free mm_slot */
> -		hash_del(&slot->hash);
> -		list_del(&slot->mm_node);
> +		mm_slot_remove(slot);
>
>  		/*
>  		 * Not strictly needed because the mm exited already.
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 2791ce5bd44b..443dab513da6 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1257,8 +1257,7 @@ static int unmerge_and_remove_all_rmap_items(void)
>  				  struct mm_slot, mm_node);
>  		ksm_scan.mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>  		if (ksm_test_exit(mm)) {
> -			hash_del(&mm_slot->slot.hash);
> -			list_del(&mm_slot->slot.mm_node);
> +			mm_slot_remove(&mm_slot->slot);
>  			spin_unlock(&ksm_mmlist_lock);
>
>  			mm_slot_free(mm_slot_cache, mm_slot);
> @@ -2772,8 +2771,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>  		 * or when all VM_MERGEABLE areas have been unmapped (and
>  		 * mmap_lock then protects against race with MADV_MERGEABLE).
>  		 */
> -		hash_del(&mm_slot->slot.hash);
> -		list_del(&mm_slot->slot.mm_node);
> +		mm_slot_remove(&mm_slot->slot);
>  		spin_unlock(&ksm_mmlist_lock);
>
>  		mm_slot_free(mm_slot_cache, mm_slot);
> @@ -3116,8 +3114,7 @@ void __ksm_exit(struct mm_struct *mm)
>  	if (ksm_scan.mm_slot == mm_slot)
>  		goto unlock;
>  	if (!mm_slot->rmap_list) {
> -		hash_del(&slot->hash);
> -		list_del(&slot->mm_node);
> +		mm_slot_remove(slot);
>  		easy_to_free = 1;
>  	} else {
>  		list_move(&slot->mm_node,
> diff --git a/mm/mm_slot.h b/mm/mm_slot.h
> index 83f18ed1c4bd..5de3e91d86b4 100644
> --- a/mm/mm_slot.h
> +++ b/mm/mm_slot.h
> @@ -52,4 +52,9 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
>  	hash_add(_hashtable, &_mm_slot->hash, (unsigned long)_mm);	       \
>  })
>
> +static inline void mm_slot_remove(struct mm_slot *slot)
> +{
> +	hash_del(&slot->hash);
> +	list_del(&slot->mm_node);
> +}
>  #endif /* _LINUX_MM_SLOT_H */
> --
> 2.25.1

Cheers, Lorenzo

