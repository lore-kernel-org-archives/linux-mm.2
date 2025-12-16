Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0980D5C0D0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64C466B0005; Tue, 16 Dec 2025 03:12:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603336B0089; Tue, 16 Dec 2025 03:12:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54CF16B008C; Tue, 16 Dec 2025 03:12:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1D06B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:12:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D61F9591F8
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:12:28 +0000 (UTC)
X-FDA: 84224617176.01.C910305
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1C7D3100005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:12:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=opaF+Bh3;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872747; a=rsa-sha256;
	cv=none;
	b=hCJaW3Ua9b6UrLJAwqwtFNR6wCVVLs1YPUCdlniBd924LRixd/3XCmp4g3lAv2x16T0Ssk
	0uEBeqjiOafd7otfmux+z+lILq1h0io/4luDYvMT86WSc6r/X7HPqsnMtp78xwWyuuFHNW
	G4Xhmal8FqMDDNUdUgxNuym1127MzaA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=opaF+Bh3;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cHy+HtrbS2UBAVjktv1rULuod/Fzmc5GYewrN5/jhk4=;
	b=XyB46Z89gUMQqOhG6tHA9MQ2q749i1REJ2uthLZosNorYWstvWJYpoWvL+NE9NuV9tQFx0
	100UsGMnyxV3cQic/OZa/MpjF+/lzIKU+D8JO/OU1/fAtyaOq2eImie0c36mZo7gzXrpM4
	/0SlptBfMzW8p8boRUUmbkWovLMMnlo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765872743; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cHy+HtrbS2UBAVjktv1rULuod/Fzmc5GYewrN5/jhk4=;
	b=opaF+Bh3zpK+OJLnzCtdIDAhozKUfW487D9RyC4vYByy27N4Qoak+gWhVAh9xUiiaZw4bKRsE3eTi4Im3juKB1BAaKBmcUhUwqqdzbwmqHY1IuKrV6OpMG2Y/qGhsLj9hBxh22eR/4zpGIaviU9xxnV2lxujmPOLAr0Lulmq1sE=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WuyV7lv_1765872740 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Dec 2025 16:12:21 +0800
Message-ID: <95b1403f-3ddb-43ff-b481-2ecc6ab8352f@linux.alibaba.com>
Date: Tue, 16 Dec 2025 16:12:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 mm-new 07/16] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
Cc: david@redhat.com, ziy@nvidia.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251201174627.23295-1-npache@redhat.com>
 <20251201174627.23295-8-npache@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251201174627.23295-8-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1C7D3100005
X-Stat-Signature: s6zgcd9mwah9t8u79wew3s3admdf5qq4
X-HE-Tag: 1765872745-687355
X-HE-Meta: U2FsdGVkX19BHLBcnnrTZS2O1o3NKEFFH0gEyABJO6j+s1JyveMIoEud5wqhuAlu6eL2rpQQt+evfTePC5fZHa+rpEzjaUhu1kHRySJUDtrjl2s+eP6LSrTN/yoekg8pucWlRawc+wK6Wzprq2ZBqa/rKVFuTC0q8/JXQRjePy+o/TfHVIVv0xGvWuSnZL0Fqmbh51tBt7pMgDEX7b1aSaH0FxOTE4MsSgM5k8OcT35ERW8+dnFAOr36W6I+qd/AGdUobDgtaqsQvmhRF02P1xrvCIdqBJU5RrLqnjvbV/Z5iFITqJJmFAq/xwY59WAADABJ3f2JbVkj210PmwmiwzyydAZvt6nUyfQX/wo8pYNKqRR4Bh6orM2+4kgNj624ccUCpJrRIf8JX0Tg/CUaKk1+AWn84orUBgbWnh0PHAKkH6odE6NCZpZoN6oJBCX94VJzVtapcCHEqfUO+5PmnmMqi870BzqnyD5vISzY87o7LdB+Zosk577cLffATodoj2MqkK6+7xpkPXDeMb+jYqVVwdce9xvw8tVNADYQGuI5UIRRfcDMLM00HqfGbMgupcswOyVlbDX2YYPeQRS5hZ9uOJdbTupUDNx8wdl7KtlBCQ9rjdfGcLcCx+bZI9le4pJJAbQoMKYYUZ7it4ljB9C32TPN3kJDg54zp/iu4SXb2nvo00oujJPmYK2v/hJB7BBydCVxxzeP73yBd9Z7gJLgqcEQdM5P1AeBWTpNqB5jxM6XVjcgi3oRmFlYRBF+YZyN4ye0Lx0YJHNpVtwvZkY2yM/KcMesO0mSGha0zn8gpfvR1qGtAU+L44rpNP44N9JR/0y3TyjEbPv+2nsp+yuv1ybKxYw93beFUibbS+2G4qhQFdXFdMipECenK89aU7gfeYfxltlcuYcYvtzO89dqcuRgbHh62ce2/26869ghpFYNR5VqxzUX7u3AdP+gcIxNxYGtRfz+wTFe7Bd
 4NVFvwfa
 HiDxzXA5171fhpAsB2FfUnvaZmj50FPKuBP6iKX5giXPeKmCOZuSKgjorrMmVBIFyDpFxViCGH+7/obOwaA/2BXYAqgCHclsSS78lpJIBINfGEbqTKXPX3M7DW9su6iDMZ4daxHgh56dSbXIED7sDCnRJOT1AwhhlHUuFRjsM9h+LbPzek7nYrvHeHoDuArgd0tppspZQzfhpp7TWHcad24Bpohg+mQbWlMgmYeNomo3gLCO/Lkt3hFgvjgPNxGtMF2gRE6WEFU2huyi1x/NFfBlxuirXKwT5Tbbaf02Tx2W97aJunhejN9pVTmj2bjEv6p5jjJNNQPoF/fzPVecIDzpC3PiA08RNKUTduBSZO1YroOG8WRx6gWC6t9qxIuMyaYfZdJc9nknCVNXezq+D+zjPkIgSatDZ80fHQ7GQYIFmq32MU5Gb2iuFtEFYfeGXg9NmTIbC+m73Pd4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nico,

On 2025/12/2 01:46, Nico Pache wrote:
> The current mechanism for determining mTHP collapse scales the
> khugepaged_max_ptes_none value based on the target order. This
> introduces an undesirable feedback loop, or "creep", when max_ptes_none
> is set to a value greater than HPAGE_PMD_NR / 2.
> 
> With this configuration, a successful collapse to order N will populate
> enough pages to satisfy the collapse condition on order N+1 on the next
> scan. This leads to unnecessary work and memory churn.
> 
> To fix this issue introduce a helper function that will limit mTHP
> collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
> This effectively supports two modes:
> 
> - max_ptes_none=0: never introduce new none-pages for mTHP collapse.
> - max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
>    available mTHP order.
> 
> This removes the possiblilty of "creep", while not modifying any uAPI
> expectations. A warning will be emitted if any non-supported
> max_ptes_none value is configured with mTHP enabled.
> 
> The limits can be ignored by passing full_scan=true, this is useful for
> madvise_collapse (which ignores limits), or in the case of
> collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
> collapse is available.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>   mm/khugepaged.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8dab49c53128..f425238d5d4f 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -463,6 +463,44 @@ void __khugepaged_enter(struct mm_struct *mm)
>   		wake_up_interruptible(&khugepaged_wait);
>   }
>   
> +/**
> + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
> + * @order: The folio order being collapsed to
> + * @full_scan: Whether this is a full scan (ignore limits)
> + *
> + * For madvise-triggered collapses (full_scan=true), all limits are bypassed
> + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
> + *
> + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
> + * khugepaged_max_ptes_none value.
> + *
> + * For mTHP collapses, we currently only support khugepaged_max_pte_none values
> + * of 0 or (HPAGE_PMD_NR - 1). Any other value will emit a warning and no mTHP
> + * collapse will be attempted
> + *
> + * Return: Maximum number of empty PTEs allowed for the collapse operation
> + */
> +static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
> +{
> +	/* ignore max_ptes_none limits */
> +	if (full_scan)
> +		return HPAGE_PMD_NR - 1;
> +
> +	if (!is_mthp_order(order))
> +		return khugepaged_max_ptes_none;
> +
> +	/* Zero/non-present collapse disabled. */
> +	if (!khugepaged_max_ptes_none)
> +		return 0;
> +
> +	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
> +		return (1 << order) - 1;
> +
> +	pr_warn_once("mTHP collapse only supports max_ptes_none values of 0 or %d\n",
> +		      HPAGE_PMD_NR - 1);
> +	return -EINVAL;
> +}
> +
>   void khugepaged_enter_vma(struct vm_area_struct *vma,
>   			  vm_flags_t vm_flags)
>   {
> @@ -550,7 +588,10 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>   	pte_t *_pte;
>   	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
>   	const unsigned long nr_pages = 1UL << order;
> -	int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
> +	int max_ptes_none = collapse_max_ptes_none(order, !cc->is_khugepaged);
> +
> +	if (max_ptes_none == -EINVAL)
> +		goto out;

After testing your patchset, I hit the following crash. The reason is 
that when 'max_ptes_none' is -EINVAL here, it shouldn't goto out to call 
release_pte_pages(), because the '_pte' hasn't been initialized at this 
point, and there's no need to release folios either.

After applying the fix below, the crash issue is resolved. I'm not sure 
whether Andrew will help fix this or if you will send a new version to 
address this issue.

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8cffaf59ced8..2e8171a6d7df 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -646,7 +646,7 @@ static int __collapse_huge_page_isolate(struct 
vm_area_struct *vma,
         int max_ptes_none = collapse_max_ptes_none(order, 
!cc->is_khugepaged);

         if (max_ptes_none == -EINVAL)
-               goto out;
+               return result;

         for (_pte = pte; _pte < pte + nr_pages;
              _pte++, addr += PAGE_SIZE) {

"
[  565.319345] Unable to handle kernel paging request at virtual address 
fffffffffffffffa
.......
[  565.319409] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000001f8549a000
[  565.319416] [fffffffffffffffa] pgd=0000001f85f2a403, 
p4d=0000001f85f2a403, pud=0000001f85f2b403, pmd=0000000000000000
[  565.319427] Internal error: Oops: 0000000096000006 [#1]  SMP
.......
[  565.326733] pc : release_pte_pages+0x68/0x178
[  565.326960] lr : __collapse_huge_page_isolate+0xc0/0x748
[  565.327232] sp : ffff800083593910
.......
[  565.331476] Call trace:
[  565.331664]  release_pte_pages+0x68/0x178 (P)
[  565.331940]  __collapse_huge_page_isolate+0xc0/0x748
[  565.332249]  collapse_huge_page+0x4cc/0xa70
[  565.332510]  mthp_collapse+0x254/0x2a8
[  565.332754]  collapse_scan_pmd+0x5a0/0x6d8
[  565.333010]  collapse_single_pmd+0x214/0x288
[  565.333275]  collapse_scan_mm_slot.constprop.0+0x2ac/0x460
[  565.333617]  khugepaged+0x204/0x2c8
[  565.333992]  kthread+0xf8/0x110
[  565.334368]  ret_from_fork+0x10/0x20
"

>   
>   	for (_pte = pte; _pte < pte + nr_pages;
>   	     _pte++, addr += PAGE_SIZE) {


