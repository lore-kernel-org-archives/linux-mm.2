Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33EA0D47CDD
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CFE16B0089; Fri, 16 Jan 2026 05:57:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 990C46B008A; Fri, 16 Jan 2026 05:57:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA226B008C; Fri, 16 Jan 2026 05:57:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C36B6B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:57:56 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 33A371BF5F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:57:56 +0000 (UTC)
X-FDA: 84337526952.17.36E3862
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 593BF40005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:57:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uIWEV7lo;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768561074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+oNd72p9SBuXMGquVdQhqvPXMYtRJrLP+uAXNlpV7zQ=;
	b=AORUbssIppZ98kM3ixSU+7IgMCZnt5PB4uAPl5GotEXPBT/PVtWFcjQUekEAn0cfIL23io
	QxQbzI2a3eEklHjlYsOHVyCKzpbDcfLZv4yGSpDDmGNpUoWzZUaJ4fW48kIqA6mWS2PWS6
	SfrQ/fXfyOqA2SPXLrXIZF0L9OUq7hg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768561074; a=rsa-sha256;
	cv=none;
	b=StYS4EGR37xr0vqffmA5KCTsw5A/LbPTT0E+Ajw4GbunT7emItv+OPFmxSBHNcmH37zgva
	esZHnVcYVfqr4WnScmjmAM8sgRODnGgvs9qvqGmJK5ZJe5SdCorKUP/DfWrDxG912gDdeG
	4+X8OZDSdhNNwPWnvewolIjjIecSpv8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uIWEV7lo;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EC974028D;
	Fri, 16 Jan 2026 10:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391BEC116C6;
	Fri, 16 Jan 2026 10:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768561073;
	bh=6DjcMkXc9f1BwMlBm8c7Btnf66eaPXQBDuFx+FT+D9E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uIWEV7lo3E1/A00cvkDA5WmRA7zqH+4P8sIaHCV0L+jv0h2Y2fw/z345lI5B+/jc0
	 D0mbEEej9otO9LxmuW9ufGeE1rhcuDc/6tVZnlejK3ZGW319jXeRCvzefmmHLbY4zt
	 oWSlgBeEcp+l/lax/2y4wOK1PXKE4mezV9SOuF7CP0gcCikuq2dddPX6IluU5Zaq4W
	 t7IzcXSSPT7OX32RSBkuLqCQGPm+7tlFpNaPu00yG0vKhxkZsj2sZPcYik6PNIPZOE
	 9LKAaR2dcGsjpCmbMPyRO0dHXVv4IYq9EkRIS9B/NHZFGQt5VAcTAcT1wfxKBoalVM
	 0IsdbCKbPj5gg==
Message-ID: <9edeeef1-5553-406b-8e56-30b11809eec5@kernel.org>
Date: Fri, 16 Jan 2026 11:57:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable] mm: Fix uffd-wp bit loss when batching file
 folio unmapping
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, ryan.roberts@arm.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260116082721.275178-1-dev.jain@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260116082721.275178-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 593BF40005
X-Rspam-User: 
X-Stat-Signature: 451wtu3fex7sf73xqd31m47446xwqcdp
X-HE-Tag: 1768561074-312194
X-HE-Meta: U2FsdGVkX18IrYqILhg5+bIBNk+PG+UBHk96rPfbgW23yfDGwd9VjeB7JrE1m5J59T7CD1uRiNY5j4mdfqfHeg7HuCNM3hgJGswzQUH6AGq4DyxRwRuSVzjHxnUXlvLhN9lhFdBZybYsC31IDYjKbub5oJpdoToyakVb/yw60/ZLGdX2CucjA35Sq4UcNW5JuwZ2hpi/swaWyih9tSmC0jEGoodFkZdc2CSCemPLzzJ5tZrfvicgaUdH3KMenhiOn8TQFZsUm1AODUFSuJn4RkqplL7XZJNFPLTFj0f59HmcE2Ztl/xSk7JOFUrRnZS6tsB2GiO8n08TMcDvsRjcM6T8oysXBYq2S+s3P97m1Dk0INrvp3uydtGEa7lJPr6hIG0WNVpq3Mtrlt0NRoUB/ipIRe8QOBrafOu8Fffuxdw8BajETWOrY54jbvlC/xaDEQomp3b6KDQYA4entCWL6207chcfP3vpcNPwVfVJrftRb66N1d3TfyCaIaty9bwS5PdaaA3QXW4RHSJoxq/qHwv156mcwZz4rP4JQK6ZkzV+6r+yVzJ0QGwyxAhYUYlH1ZODdiU/qhb9y4jIKCXGfu/Wa07+Is3RlYaP0fl2jK0U7H/tFYrv5Vjgp3iJSH93+7c8KTK87CfCgPVBIgjw3BZQMOmSt/niqoJ3C/cBwguu6+0fD2GzcOLCNnl0ctJnVJ3Bftan1ypaIaIhfbKn9G83ZtiU4RkpuZ24S/EnKnpqwCJQqM4VAY2plmDvc/WgSlxggswfCOB+986gx3pz9PPSLylnyuJSPiA22z0NpkTbNMesynp4Nh1AaACzFLcOlgzwoy3iXzDxCq7QenA+a4RG8yzvxJXLXzLivdFa4D0vdda6JoJwwWYefyoKtOYVg6C24ghirwXHfwY2HBYIrpprT7/dgObWxhBnKqUPEUIaiwe+R6xmIDynziNYW26elKi6jdbZkKaL2wfkedI
 PHkwz36T
 nlNSP2Y79Qcy8ybdd88bP3YP+QR2AkCpJ3zBOBk6F7myMbzEkTmwIY4zDAN8U7/S/75suLyD+M37bmS3mz1IH27n2rcoEYXLiXrxZkjQbW8wmA1aDwRaGNTdBZ1x/KSHdXEuQ+4mEpZ3JeuoKxdsnF6e4+01RCeeOvYV8OO67YV55T3KCETbuKKnAzuW+uyJ5Rvi9GmxHh8x+/2CbtGPBu8Y1xPz7udr9Ap4CGVdOC5cFCZX5fq9wcvgKbdXQfOaZcVraKpdUyKI3ykldTt0z2BApvVY2dJKiTBOUEyrssVgVDtoZS4gwS3jjDnLDoD+m0HjU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/16/26 09:27, Dev Jain wrote:
> The recently added file folio unmap batching support forgets to update
> pte_install_uffd_wp_if_needed(), which still updates a single pte.
> We end up jumping to the end of the folio in page_vma_mapped_walk(), thus
> setting the uffd-wp marker only on a single pte in the batch. Fix this by
> passing nr_pages into the function, and set the uffd-wp marker on all ptes.
> 
> Note that, since the nr_pages passed to this function is always derived by
> some sort of batching, it is guaranteed that the set of old ptevals of the
> batch have uffd-wp bit on all ptes or no ptes, therefore it is safe to derive
> the value of the local variable "arm_uffd_pte" from only the particular
> pteval passed to this function, but apply the result on all ptes of the batch.
> 
> Use set_pte_at() in a loop to set the markers - we cannot use set_ptes()
> as that will increment the PFN, but we don't have any PFN to update here.
> 
> The userspace visible effect of the bug is inaccuracy observed by workloads
> relying on uffd-wp regions to install their own pages.
> 
> Fixes: 8798e255b5ec ("mm: rmap: support batched unmapping for file large folios")
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> Patch applies on mm-unstable, commit f8ed52ac0cfb.
> 
> I observed this bug during code inspection, but it turns out that the uffd-wp-mremap
> selftest will skip some tests with a bogus complain that "MADV_PAGEOUT didn't work,
> is swap enabled?" even when swap is enabled. It first sets the region uffd-wp,
> then swaps it out, then checks through pagemap whether it got swapped out. For
> file folios, this check makes no sense since the ptes are simply cleared, but in
> this particular case, because of uffd-wp preservation, we need to store PTE_MARKER_UFFD_WP,
> which is stored as a swap entry, that is why the test works out on a non-buggy kernel.
> 
>   include/linux/mm_inline.h |  7 ++++---
>   mm/memory.c               | 14 +-------------
>   mm/rmap.c                 |  2 +-
>   3 files changed, 6 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index fa2d6ba811b5..adec1dcb8793 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -568,7 +568,7 @@ static inline pte_marker copy_pte_marker(
>    */
>   static inline bool
>   pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
> -			      pte_t *pte, pte_t pteval)
> +			      pte_t *pte, pte_t pteval, unsigned int nr_pages)
>   {
>   	bool arm_uffd_pte = false;
>   
> @@ -599,8 +599,9 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>   		arm_uffd_pte = true;
>   
>   	if (unlikely(arm_uffd_pte)) {
> -		set_pte_at(vma->vm_mm, addr, pte,
> -			   make_pte_marker(PTE_MARKER_UFFD_WP));
> +		for (int i = 0; i < nr_pages; ++i, ++pte, addr += PAGE_SIZE)
> +			set_pte_at(vma->vm_mm, addr, pte,
> +				make_pte_marker(PTE_MARKER_UFFD_WP));
>   		return true;
>   	}
>   
> diff --git a/mm/memory.c b/mm/memory.c
> index 6b22dd72ebc8..35ac86d29e77 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1588,8 +1588,6 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
>   			      unsigned long addr, pte_t *pte, int nr,
>   			      struct zap_details *details, pte_t pteval)
>   {
> -	bool was_installed = false;
> -
>   	if (!uffd_supports_wp_marker())
>   		return false;
>   
> @@ -1600,17 +1598,7 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
>   	if (zap_drop_markers(details))
>   		return false;
>   
> -	for (;;) {
> -		/* the PFN in the PTE is irrelevant. */
> -		if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
> -			was_installed = true;
> -		if (--nr == 0)
> -			break;
> -		pte++;
> -		addr += PAGE_SIZE;
> -	}
> -
> -	return was_installed;
> +	return pte_install_uffd_wp_if_needed(vma, addr, pte, pteval, nr);
>

That should likely be factored out in an independent patch.

And while we do that, we should likely rename the function to indicate 
that we consume ptes.

That patch should also describe why the change is ok; it's not just 
simple code movement. :)

-- 
Cheers

David

