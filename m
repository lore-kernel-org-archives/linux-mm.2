Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA155106ACEA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305E16B00BB; Thu, 12 Mar 2026 17:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD976B00BF; Thu, 12 Mar 2026 17:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2CC6B00C0; Thu, 12 Mar 2026 17:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0ABE36B00BB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:09:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2C3A1A0289
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:09:24 +0000 (UTC)
X-FDA: 84538651848.05.EF5D514
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DACEA20004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:09:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nOqke5uH;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773349763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JtSPrg3d/bsrsxkOxGYb2djj98brgdbcSeDCm3QOpI4=;
	b=tLXYxshxun2ePvvx7OQ/0URsB4qQ4lSXZGwFPWM9dYEt1clm7V6m6Son+2rnhqf7m5ym5T
	LhGnf5Z+IRE04YhKcNAitCO14FsN6jTT+x/XGAAiIZ/W1J322++/u+SqqmdiME1Tum9mhY
	xGi04Bp9IlY1Fu4XMQvAc9hclqVyNpA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nOqke5uH;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773349763; a=rsa-sha256;
	cv=none;
	b=nr2n9fZeI4lHi7fvm4oJovHiyu81Cd+weAshoX/TEWKTZpjYvFOoWBu7a6h0HRTwSmjZF+
	WlE3pjE2F24yA06lz5zEHr1M0Rs2xYVwuaoqUn2sCkeXkVv3iXwnEwRsQsY4gdXNPmaufq
	juVr9ORhiKF1RbnRXXEKol1cp++sn/Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E479B42E41;
	Thu, 12 Mar 2026 21:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C8AC4CEF7;
	Thu, 12 Mar 2026 21:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773349761;
	bh=KgadnpunSgn4gbBZJyKyKq3y6aZd94JO3aK4Pmn9t+s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nOqke5uHz3c8Omr8Fn2jbW5MHHG5OuPLMw1lLfed1JGaFfykgXJjuqzL1Hi+4WtoG
	 +jBvLMTkMO1mVi4JSWlb6t2S4RsyCiq1zpMPMbbpxzeU7XAO4F2eUlYJM72UZcmZL+
	 u1z923V6dbF2O4hgLytDjQISNB8FtPCew/kW7K9UCjrqkX0VZhX+xsAKN/GSUvUxFu
	 jF9+3tI1AUG764wYWaMQ1Bi0bgL4Akk+KL/qH7U6sGl9TR34BpOrqoFymyLNhC5576
	 WhHptdIK9xAkNPvKggauQNvE7aW/o+HhQrqkCUm3XWvORXkEylaRApJRREPATEeb94
	 WRcgh8sTsEksA==
Message-ID: <7f850a9a-0ac8-473d-a4ec-914462e4014d@kernel.org>
Date: Thu, 12 Mar 2026 22:09:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 09/13] mm/khugepaged: introduce
 collapse_allowable_orders helper function
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032542.233891-1-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226032542.233891-1-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DACEA20004
X-Rspamd-Server: rspam08
X-Stat-Signature: ff558364myseth56age85pcd77tryt8q
X-HE-Tag: 1773349762-429320
X-HE-Meta: U2FsdGVkX1+MrFTcw/e+sPze9S9uwN29RX9coTFPPXKN/U4RPnLByhwtiMZQi9IUOC/Qmghx/w9eE8iSHaJE9CX7iR0qDgSm11qleLhRtqHSQaXzstMDyC7GeeDzRqDz04wUTYO23MkndBxOf8JZFE5Tkh8YY92oNMZdPciymCEXRNXKO3zvOBsVSmAqqwh0QVnFU0fkTB2aHhU8QwDSKtlh7aFEH3K2735wsmHAasbD55ExSah2qBMXaTmRqVN3ltkivxj21I61GvPLupv6P9AFhJDO3pyBy5lOuoIuKez2HyyB201dmIuYz3KFq3p1sw491GjfOtXkPKwF3pzAvlBcjs8PbSv3EK/seXoZgBk+eWDdWoQnb2Anbdfp2qFuEGg6NNuevsKOicBn7IVVoBPU8SttbIzl+TJ1QhHJm4pZj8GMD5TKWgmNHxcbw8aKkhANj/PntT1caF8Waumk/rzPnVukuFg1iZbTOJLkbot0jc8CmO2k7gwWPmb2HsTP23KgUrVIMj5H6Q3dDSyDxX9B+S9aIeKvBJk9W1ttM1+9cYqF8G3yyhtXZ3pgtaRn5ABqYpD7oZ755GsyAoe2302n83MmSv7uq+aWQmdnx8qT3TBT8SSUWkGTaczhvmrpzysY0mwc1wn6e9zDx3Xbw9CaLEX25wP5PxVTCurfevNTw6vt8GbHmNfFvr4pbhiTX6UbYtw82Kj3i+30TcbRtcePBCNuEtxZkkPSW6bHaV4TVkyl/MndV9h9Tmr7nv9slcPsCr2HstOsWd52fCrpCdoaz8ZyGJgcOPw8dqG2QpJDdKS4Tgq3UTTDkeqZNEd2WiUcBLTaUF1jlvqM43suTwdXzjQ2WSyhU+cdj3GGb1R4KRTiXa1icvrS0jVpCfMnV7iMOXggXJg8891vwKC/hjioOkxN4QLQOkb9rjrAWtA5baub4KRfK7o97MKJukcRs+stu10j2GzNMJeHCCv
 aT2RWxmg
 o/DeWay280QxRlgr6QN03p+v9y9Z/bgRr5ex/e6gbWHBGoQbSZ85xvtquqC2yQtg34LNAksP/qpxgrLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 04:25, Nico Pache wrote:
> Add collapse_allowable_orders() to generalize THP order eligibility. The
> function determines which THP orders are permitted based on collapse
> context (khugepaged vs madv_collapse).
> 
> This consolidates collapse configuration logic and provides a clean
> interface for future mTHP collapse support where the orders may be
> different.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 2e66d660ee8e..2fdfb6d42cf9 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -486,12 +486,22 @@ static unsigned int collapse_max_ptes_none(unsigned int order)
>  	return -EINVAL;
>  }
>  
> +/* Check what orders are allowed based on the vma and collapse type */
> +static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
> +			vm_flags_t vm_flags, bool is_khugepaged)

Nit: one tab to much

> +{
> +	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
> +	unsigned long orders = BIT(HPAGE_PMD_ORDER);
> +
> +	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
> +}
> +
>  void khugepaged_enter_vma(struct vm_area_struct *vma,
>  			  vm_flags_t vm_flags)
>  {
>  	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
>  	    hugepage_pmd_enabled()) {
> -		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
> +		if (collapse_allowable_orders(vma, vm_flags, /*is_khugepaged=*/true))
>  			__khugepaged_enter(vma->vm_mm);
>  	}
>  }
> @@ -2637,7 +2647,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
>  			progress++;
>  			break;
>  		}
> -		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> +		if (!collapse_allowable_orders(vma, vma->vm_flags, /*is_khugepaged=*/true)) {

I'm not sure if converting from a perfectly readable enum to a boolean
is an improvement?

I would just keep the TVA_KHUGEPAGED / TVA_FORCED_COLLAPSE here/

If you want to catch callers passing in something else, you could likely
use a BUILD_BUG_ON in there.


-- 
Cheers,

David

