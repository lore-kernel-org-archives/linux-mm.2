Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80F01EA3C23
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA3636B0088; Thu,  9 Apr 2026 06:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54226B008A; Thu,  9 Apr 2026 06:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6AAE6B008C; Thu,  9 Apr 2026 06:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C526D6B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:56:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D4D71A0465
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:56:18 +0000 (UTC)
X-FDA: 84638713236.24.8EE0E9D
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 747B714000C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:56:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775732176; a=rsa-sha256;
	cv=none;
	b=AXEou7eU6Cctiv+qbLB8NuVzLnkA4p54SaYsOgflqCvSKxlJl2blHFum/+y1dsmf07AiDz
	WRorn9LnoIf4FetsWL7jQ+XTYK3a6CmWopnZVsKF0Eb5e9StZOXCCXG/Y956LhO2d+mqDx
	g7+9h5ch3t1ju0sKYCSakBn37BEHwA0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775732176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iIBiK8wABF5x1NnwEBya1kdtdbJZAjm5/AsKpZ2KEXI=;
	b=R0UxGpfByJGKFl0A7Y2XjxbBJVJ2MADaLDm0Bvca5Rn3YKdNxEGV7nskUFtw5VC2RPlyJR
	gcRqfQxowv5qTRz2uEq2wg2QrSsYGasoX+hIO+6djMJawMsJvCJ0+zd1OHFuBiZM+vkN0j
	JbppzOycqviQ6aiU5JmhtBnpQTvtJQc=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4frxgc4Csbz4yjjF;
	Thu, 09 Apr 2026 18:56:12 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 639Au8As082303;
	Thu, 9 Apr 2026 18:56:08 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 9 Apr 2026 18:56:10 +0800 (CST)
X-Zmail-TransId: 2afb69d785ca5d4-2df34
X-Mailer: Zmail v1.0
Message-ID: <20260409185610930gKQqJsFs5KoTU4S8MrflI@zte.com.cn>
In-Reply-To: <5401c1d2-5f42-4288-9dad-2b9768b579c7@kernel.org>
References: 9950c6c1-f960-58c0-4312-e4f5ac122043@google.com,20260407142141059pWDasxUAknP5rqvAMl28K@zte.com.cn,adTPQSb-qSSHviJN@lucifer,8332aedb-e499-4789-8f46-832df8d60224@kernel.org,addoN3ur7GtiKOFf@lucifer,015c3268-9c95-4314-b28d-c5e33eb2fb86@kernel.org,d659edad-863c-498b-b215-b9f98d15e0ce@kernel.org,5401c1d2-5f42-4288-9dad-2b9768b579c7@kernel.org
Date: Thu, 9 Apr 2026 18:56:10 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>, <shr@devkernel.io>, <ljs@kernel.org>
Cc: <ljs@kernel.org>, <hughd@google.com>, <akpm@linux-foundation.org>,
        <chengming.zhou@linux.dev>, <wang.yaxin@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <michel@lespinasse.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?562U5aSNOiBbUEFUQ0ggdjMgMi8yXSBrc206IE9wdGltaXplIHJtYXBfd2Fsa19rc20gYnkgcGFzc2luZyBhIHN1aXRhYmxlIGFkZHJlc3MgcmFuZ2U=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 639Au8As082303
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Thu, 09 Apr 2026 18:56:12 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69D785CC.000/4frxgc4Csbz4yjjF
X-Rspamd-Queue-Id: 747B714000C
X-Stat-Signature: 6uj9xndo4oqwfydx6go3gjnf6zm9zb87
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775732175-623259
X-HE-Meta: U2FsdGVkX1/AHHdWyNMqTInT7iidpzWCoW4V6LdfqrKucAsmfAdQaMF3rG08S14dws6pWajKQe0UXGPhlxb5d8e3tS3GTmJd/49yGW0feZDQB5MNJcJPQb8jc/V4r8GLioF69H8LqHS9jhVxt/TWjk+it5FuELCbu/nDee5/e8iMTQPh8xHPD9FsrLfCQcZo94NEZaSvJoV1LEfG84DlvvvTrp695ySHKvp+LqCtrVFHWW2GgYRuw7DgrRiiJQiHJaWqeFI2vJspYDdJm0hW57BEOHvHX+d1QVZbbBXbLxL+1ItuWkN2IzLiXVDxNJT6WS6aZ09NeZ7m3ByhPwGr1ZCYMgSdmKu3/7UMuu+bq5pkvBTypx5C7CC4fMkhf3f0egynQpAHOHoIl8WEb+6dhl6tPuQHDzrvMrehG/G9cBLmMiX7oVOUMKNVidYFqtVYt60QcCLusDsDeNYIJZAnNAkxXEQRIcgi36a9bVP2X17MqHeAY9Xty7WNq59nnA4FRr6tEsPuEKtWHgtmHbqxO2Cz0+6A9fSENp5rTh3GLHwBwDPpYlHD8HDK9oxRaD8nPsxYS97EJZEU3P/ve+f0GJE89TrA8XlE8BKVhsIIvh8NwCLkZqt/dIT90z4ll9UAWl62PbjDYfYjUcjWn1v7Nf8yNrzfpsCLix+OsjCcxSvzLiuwyneIo4E0IzT6qXLZ5ObRNINrIGm46iza3Jhf11e0OiwpNRTyBisp/BR2Lw4eKjYIYKxnQBSW9K0MRklP0hctMtEd5YqKffcnMnxZM/Bynj4EaI7AfSCNCFMmYgOQI5n3LyfUrAhEKuTQbkpK6u0WxJcKXorOt5JLigyCEMBoXbek/Cf4qFyXHPCnC+mymEhgPA4cBFBAbWcV6vEquLZ0ea3grTn/aHJxEzLCWHros5r0dQZW+j3M9iya/yMGfCLl+z2Wis8jBCuWemVnTp5jWi222XrBlpBMelY
 qeaFwqx5
 AGAzHdWx6xT7jW1yYKBn26Ah6fFpqA+FGukN97BBejYO2JvAxsdfFfrvIkt7GLEFXxpsTpHIwRfClrBTb380B4nqPFkVW8lkgRrWqAMwkD98NFXtZYRn+gSdRtvt+iy3F0OHRuoFeKcx9bZ3wDZ5AgfoiS2FpV0C/p8Br
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 4/9/26 11:41, David Hildenbrand (Arm) wrote:
> > On 4/9/26 11:37, David Hildenbrand (Arm) wrote:
> >> On 4/9/26 11:18, Lorenzo Stoakes wrote:
> >>>
> >>> anon_vma doesn't have a vma field :) it has anon_vma->rb_root which maps to all
> >>> 'related' VMAs.
> >>
> >> Right, anon_vma_chain has. Dammit.
> >>
> >>>
> >>> And we're already looking at what might be covered by the anon_vma by
> >>> invoking anon_vma_interval_tree_foreach() on anon_vma->rb_root in [0,
> >>> ULONG_MAX).
> >>>
> >>>
> >>> One interesting thing here is in the anon_vma_interval_tree_foreach() loop
> >>> we check:
> >>>
> >>> if (addr < vma->vm_start || addr >= vma->vm_end)
> >>> 	continue;
> >>>
> >>> Which is the same as saying 'hey we are ignoring remaps'.
> >>>
> >>> But... if _we_ got remapped previously (the unsharing is only temporary),
> >>> then we'd _still_ have an anon_vma with an old index != addr >> PAGE_SHIFT,
> >>> and would still not be able to figure out the correct pgoff after sharing.
> >>>
> >>> I wonder if we could just store the pgoff in the rmap_item though?
> >>
> >> That's what I said elsewhere and what I was trying to avoid here.
> >>
> >> It's 64bytes, and adding a new item will increase it to 96 bytes IIUC.
> > 
> > As we're using a dedicate kmem cache it might "only" add 8 bytes, not
> > sure. Still an undesired increase given that we need that for each entry
> > in the stable/unstable tree.
> > 
> 
> Hmm, maybe we could do the following. I think the other members are only
> relevant for the unstable tree.

Well, I suspect that "SmartScan-Related" members might be also needed and used even when

it's a stable rmap_item. In should_skip_rmap_item(), if its page is KSM, it can't be skip.

What if the rmap_item is stable, but its page is not KSM?

Cc Stefan.

> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..0c6bfed280f7 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -191,12 +191,13 @@ struct ksm_stable_node {
>   * @nid: NUMA node id of unstable tree in which linked (may not match page)
>   * @mm: the memory structure this rmap_item is pointing into
>   * @address: the virtual address this rmap_item tracks (+ flags in low bits)
> - * @oldchecksum: previous checksum of the page at that virtual address
> + * @oldchecksum: previous checksum of the page at that virtual address (unstable tree)
>   * @node: rb node of this rmap_item in the unstable tree
>   * @head: pointer to stable_node heading this list in the stable tree
>   * @hlist: link into hlist of rmap_items hanging off that stable_node
> - * @age: number of scan iterations since creation
> - * @remaining_skips: how many scans to skip
> + * @age: number of scan iterations since creation (unstable tree)
> + * @remaining_skips: how many scans to skip (unstable tree)
> + * @pgoff: pgoff into @anon_vma where the page is mapped (stable tree)
>   */
>  struct ksm_rmap_item {
>  	struct ksm_rmap_item *rmap_list;
> @@ -208,9 +209,14 @@ struct ksm_rmap_item {
>  	};
>  	struct mm_struct *mm;
>  	unsigned long address;		/* + low bits used for flags below */
> -	unsigned int oldchecksum;	/* when unstable */
> -	rmap_age_t age;
> -	rmap_age_t remaining_skips;
> +	union {
> +		struct {
> +			unsigned int oldchecksum;
> +			rmap_age_t age;
> +			rmap_age_t remaining_skips;
> +		};
> +		pgoff_t pgoff;
> +	};
>  	union {
>  		struct rb_node node;	/* when node of unstable tree */
>  		struct {		/* when listed from stable tree */
> @@ -1600,6 +1606,7 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
>  
>  	/* Must get reference to anon_vma while still holding mmap_lock */
>  	rmap_item->anon_vma = vma->anon_vma;
> +	rmap_item->pgoff = linear_page_index(vma, rmap_item->address);
>  	get_anon_vma(vma->anon_vma);
>  out:
>  	mmap_read_unlock(mm);
> -- 
> 2.43.0
> 
> -- 
> Cheers,
> 
> David
>

