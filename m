Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81033CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 02:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD2D6B008A; Wed,  7 Oct 2026 22:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ADD16B008C; Wed,  7 Oct 2026 22:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3EE6B0092; Wed,  7 Oct 2026 22:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF28D6B008A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:08:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8BF740445
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:08:06 +0000 (UTC)
X-FDA: 85297823772.07.69D12A4
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf19.hostedemail.com (Postfix) with ESMTP id 05C8A1A0003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:08:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=f+CUJzz8;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791425284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODRL+vWaVDz42U2hwyZZZW2Lci6L6eJHWxbCTbwo0Bg=;
	b=ZFI6KP/AQ5R7P9qY5GUmGfmVUg2MlfL49wQeteoSZC5Oy4n0lx6yfCdW2fXfgO165eH6y5
	rNk2EHjXj8IisBO9Xdm/BHAqVxUoM7ADuQqTJvUz/QL4y9EQOS4lZn8jmkEcZE+qqBjP6+
	yYhaTxR1IvvTt3mb3gZ0gzjuL32IPDo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791425284;
	b=WDxuYNSejT1p9jHoMvAI5a4Q4Ng28szqQdh7mDAzBI8nQyr2BEg5v6ELobDQDX0ScCIAiw
	4CwGBkJva7P+VAKvtKwIOCd9ePtHRsuwSyOjYm7YNiCHrxs0ntVBBImq+LI1h2MGMAGLvx
	pUB7/HenX0u7IgWCgQPMhiW2ZLFzhcc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=f+CUJzz8;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791425279; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ODRL+vWaVDz42U2hwyZZZW2Lci6L6eJHWxbCTbwo0Bg=;
	b=f+CUJzz8a3do2c6s9gQaX44Cbq47dj+lZ+S5rnwXzVNMHy2+wntTYpt+2zr2llr7uDnooGTSV1EluEwsZATJuuH3s3fVjHQ52nOe3L/A2w34P/mgMkvwRrC3f5YkkI/ZzJSo91CSJuAB029xoubOPxbl9kgf5oet6hgbmOAcTyE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XCIdo11_1791425276;
Received: from 30.74.144.149(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCIdo11_1791425276 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 10:07:57 +0800
Message-ID: <4db5fdee-4bca-43bf-8ded-2fd8808ac289@linux.alibaba.com>
Date: Thu, 8 Oct 2026 10:07:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 14/14] mm: thp: always enable mTHP support
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <752f528f0fed5cdc9de12b54260b0495d4e5a6cb.1789695931.git.luizcap@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <752f528f0fed5cdc9de12b54260b0495d4e5a6cb.1789695931.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 05C8A1A0003
X-Rspam-User: 
X-Stat-Signature: wti3966maezpmsrc6z6j53nimr1d8ojb
X-HE-Tag: 1791425282-290944
X-HE-Meta: U2FsdGVkX1+KRuOnZNGnhppP4m0MgdYd77kObHI5za7zKNDNVluLoTKUheFMgXbadyqkAsSbsze0RfNVDLIQk6BIUSof0j60NmTuIoCFLY67vdxqDzbo20xBG+LTthx/1RYggpnD5EUt5IwVzfSgKLmejTNUb+6pfWuWfuK6hJ8dzcKeocKsfBqg8Qx2gBgRbxBh3Ghj6b+nZUJYuvFe5Rayey31wcFnq8Hh6g7IKArqJPSB+4+n0kjymJTEVuPPZzuCL5qSvlIsSl0jyvuy2mec/A8NGwIZbs+0a4fVerAhw4sRdyfoA73GiUc4fyIJvePJ20/yF/2LPKYco4y1RrQAPvlst+Yxsgoaf8yOHSMvvkPGvtBXP3C4f/Vzy+iz9vM+J73bgCA7Rus2PhAV72FFSW30SyoQ840kZfDMI8mJ2eGLvLsT+DCHpAH7o5+QyGVg4qTWl5RPBE/Y2Inw6/HCFVus8NVnbpOnINAdxfo2UIWdOjWVkb4bYJBUfo+v6tGI2sF0FP4G5vcFcjy7nlYnXjCdnk2vWjEStJu92WjHcIbmLJt7isrdzlGJ5iYNqtp3fO6m9iSdkxoSB99sF6A9r0yV2hCjeJSLrkU+XsjbDkkXhTj2alLIJ3QozOA4CwGDdh9UWdNxqke/K/sM8VcOb/h6sbhBIcDTL4wfPH6zW/KA9mvFp6Uy8r0IV61Xh/eFd4A8n9NIRUgMOIL2c1TgkTGHXFUf2rAIVdSH6k9ibjpZwioWafEBe3RhVwlKl49O25sKxluhra8ojosKqJ0FPreH15eTndoiuyYWvfOWhjm6ArKFXVRxEW2n518AZhJT0Y/qKcm0X+t5pcaCuVc7REZABFaZAoe4+Q2i5z4W4BZRbEOf4w92xrDQ5kTCHMDy1nYedAW71MP4kyh6+d5wUMHvGimBOnk5kjHvikNH8qnc8go2uR7PXdWhdsE7o8uPnalT+MNUpkoAC5B
 SxAclIwo
 clwU3dZ+KN58mH8Ij7WhD1+TF0XWqotZCNWPs4efT28IWlUm2wrdGvNLFmhyyYyf+xy3x9GGrGNvh8AcBkmo+vf9JovjjCZyknFlw2m8uPusEQZovaGVDLiXwRMHurzyvdv7Btp1CmsKPBHdKS3D6N1D6FA2gvx34c8gNwNOJx3AXnpFQTUar1zk5WsiGL6V35eIgirDOMGmyrfuzFK7I4Hr/+LwM1T58bY6ABs1ktz5U7VSNdi0cyNVF3tnSVM42HJxcaCGE0TVFEY7DTCX/dnsgFXbLZyk1hzCtAFC/VrJqcoRP54aqHl5rUJwn3KJnkbSfQRpP/cGUwH5rXypZ2o1Vsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/18/26 9:45 AM, Luiz Capitulino wrote:
> If PMD-sized pages are not supported on an architecture (ie. the
> arch implements arch_has_pmd_leaves() and it returns false) then the
> current code disables all THP, including mTHP.
> 
> This commit fixes this by allowing mTHP to be always enabled for all
> archs. When PMD-sized pages are not supported, its sysfs entry won't be
> created and their mapping will be disallowed at page-fault time.
> 
> Similarly, this commit implements the following changes for shmem in
> shmem_allowable_huge_orders():
> 
>   - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>     considered
>   - Filter out PMD and PUD orders from allowable orders when
>     PMD-sized pages are not supported by the CPU
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   mm/huge_memory.c | 25 ++++++++++++++++++++-----
>   mm/shmem.c       | 14 +++++++++-----
>   2 files changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index a06025b87e7c..a2d6de3ea988 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -189,6 +189,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	else
>   		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>   
> +	if (!pgtable_has_pmd_leaves()) {
> +		/*
> +		 * If the CPU does not support PMD leaves, assume for
> +		 * now that it does not support PUD leaves and disable
> +		 * both folio orders.
> +		 */
> +		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> +	}
> +
>   	orders &= supported_orders;
>   	if (!orders)
>   		return 0;
> @@ -196,7 +205,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	if (!vma->vm_mm)		/* vdso */
>   		return 0;
>   
> -	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
> +	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>   		return 0;
>   
>   	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
> @@ -979,7 +988,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>   	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
>   	 * constant so we have to do this here.
>   	 */
> -	if (!anon_orders_configured)
> +	if (!anon_orders_configured && pgtable_has_pmd_leaves())
>   		huge_anon_orders_inherit = BIT(PMD_ORDER);
>   
>   	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
> @@ -1001,6 +1010,15 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>   	}
>   
>   	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
> +	if (!pgtable_has_pmd_leaves()) {
> +		/*
> +		 * If the CPU does not support PMD leaves, assume for
> +		 * now that it does not support PUD leaves and disable
> +		 * both folio orders.
> +		 */
> +		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> +	}
> +
>   	order = highest_order(orders);
>   	while (orders) {
>   		thpsize = thpsize_create(order, *hugepage_kobj);
> @@ -1091,9 +1109,6 @@ static int __init hugepage_init(void)
>   	int err;
>   	struct kobject *hugepage_kobj;
>   
> -	if (!pgtable_has_pmd_leaves())
> -		return -EINVAL;
> -
>   	/*
>   	 * hugepages can't be allocated by the buddy allocator
>   	 */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index bc2de3a7c1ea..8c0f7e3efeeb 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2046,11 +2046,14 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
>   	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
>   	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
> -	unsigned int global_orders;
> +	unsigned int global_orders, disabled_orders = 0;
>   
> -	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
> +	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>   		return 0;
>   
> +	if (!pgtable_has_pmd_leaves())
> +		disabled_orders = BIT(PMD_ORDER);
> +
>   	global_orders = shmem_huge_global_enabled(inode, index, write_end,
>   						  shmem_huge_force, vma, vm_flags);
>   	/*
> @@ -2058,7 +2061,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   	 * sysfs configs.
>   	 */
>   	if (!vma || !vma_is_anon_shmem(vma) || shmem_huge_force)
> -		return global_orders;
> +		return global_orders & ~disabled_orders;

If you move the 'disabled_orders' filtering logic into 
shmem_huge_global_enabled(), as I mentioned in patch 8, then this change 
can be removed.

>   	/*
>   	 * Following the 'deny' semantics of the top level, force the huge
> @@ -2072,7 +2075,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   	 * means non-PMD sized THP can not override 'huge' mount option now.
>   	 */
>   	if (shmem_huge == SHMEM_HUGE_FORCE)
> -		return READ_ONCE(huge_shmem_orders_inherit);
> +		return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;

Since you've already disabled PMD-sized and PUD-sized orders for the 
'shmem_enabled' interface in hugepage_init_sysfs(), this change can also 
be dropped.

>   	/* Allow mTHP that will be fully within i_size. */
>   	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
> @@ -2083,6 +2086,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   	if (global_orders > 0)
>   		mask |= READ_ONCE(huge_shmem_orders_inherit);
>   
> +	mask &= ~disabled_orders;

Ditto.

>   	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
>   }

