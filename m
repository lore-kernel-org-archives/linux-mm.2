Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA8D0CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 08:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C9E68E0006; Fri,  7 Nov 2025 03:48:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A0DE8E0002; Fri,  7 Nov 2025 03:48:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DEF78E0006; Fri,  7 Nov 2025 03:48:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7588E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:48:47 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A549213AB92
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:48:46 +0000 (UTC)
X-FDA: 84083185452.21.678382E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id ED33F18001A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:48:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Rf/i0p2W";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762505324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MRGtFMuLLkjK1MuFo8Ood1enwihg+pwL8yAvyzU/j8k=;
	b=bEDp4miBGiFZX2tVv0p0ig2KDkEHL982B1elskIjOAA6wKcbJH9CtmTWCxxzzWMYu2fd8j
	G7gNh4O2F8C64HcXHGhMiNIw0QrMrNm2eInld3wk9ZW+FZkml65lbSISOfsg8cdjJ8JhCj
	1Q2VPexMKCeMPTT/KMwHoMxqrrJE1X0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Rf/i0p2W";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762505324; a=rsa-sha256;
	cv=none;
	b=vWZVV85uqR09xnxnmzMtlKZ32ZVmDA9ggJxvXkvNT1e+Sjgy07Q447HYZlMyIMMTLVaEJJ
	MhGj8Uir6pwnQgVhPziBOP3s2g4HBZr0rHHWJUaMiPGhy3xBXGT4+Gynm/m0kDCK6/WyWR
	OHnOk9PnHUqDh/pI9C0gOYqfF7ZENgo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 54B88618FA;
	Fri,  7 Nov 2025 08:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE20C4CEF8;
	Fri,  7 Nov 2025 08:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762505324;
	bh=E3TwJzPNvZUaml5cZpTDTUQufuUCSzPOAK8264B+Oms=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Rf/i0p2WMdBHgz6Jt2saUAD8COs+9ceeeVFfjJ0Mj7t4/8ZMJc7cXG10Il75xumNO
	 JAmz4UB+O0L1zs1qS8DH0pFitMi20s0t6y+q1DpCfuvjV2wgDnli+QLRgAZdWgSptx
	 fwqaGMdEgPrPBXL4Y0fjavTXbcW3s3eU1UsbS8zcDTdz/TohFk3GVHD1QBYLfedUeh
	 96oVrENtNESgRixnXbHp2hwjA9bRgroHzEFz5TT1KdkGECjdnL/H09WyxZCZLc6jeX
	 3Wokhb6gem3x2YIIaH/O0H1E/vwfSvW7LQuenGG8lycjBlxAzxireur3rTqC6e6+oJ
	 ARmVb98KojHDQ==
Message-ID: <bd11e906-8d01-4e39-b385-f158520b589b@kernel.org>
Date: Fri, 7 Nov 2025 09:48:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/7] mm/highmem: introduce clear_user_highpages()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-4-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251027202109.678022-4-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ED33F18001A
X-Stat-Signature: 76n11rknyihets6p7ughqdbjnz6rii35
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762505324-235507
X-HE-Meta: U2FsdGVkX19trIbQ5oTIJ0VZGNIOIOwqWb7kdl58by2o1yT17Q6NbIwCTdtTuIojo3MHsd2a3jW1daVWe2ZQwxpZvcxp4m9RU6xMCBkaUkgWNqGlSPeL3MgAs5nHkbTnz3s2x07RvXEaRMZ8YZ2MfBimCijYHXlpc6fouE5S3J8aiUTSkQJAYIcbUBSWB9JTpeOcTHl5obgDfR0Pa6BsuzbGMeV/Jed9BSKqnwALWkuKk6IVTS2jNx7WrnmMmTtAhX3A3mHjYSfGPZdbCfqCKzYeXuad1jjt67VyTPbuMyoxvHANFkOh82WfMDpkO8XQ0YEqmIMrmJ797P0vVCP+N5Zl5ayRlictNmk79IM1dDJ3vLWQLOEjn11J5ek4lIroX/gwB2x+EvAZJ89WmV8y2kivSUCp96IybHf5sfiGQRihz5r2SFOs98/2a9rh1f1chEKF45ZJ8YUMd2PZuSz5KLZ/JBSWVq1QKDl5JkfMlETzrgnvWO0CMO7JEre2zBdwF2zlSpDGwws8+sARNTum8XwRfdf5REjRqZpEIfX79kZdkIgexavd5ruSdv7DezFpZZqUEPxivFNDacj2lj7PEGMUzi74fNnqhzIhzqTEeBk5y2CyS0Y+hIqwkvdt/+Ns1vpzRiDhpRJsWotbQufOatcEFG9D04lsUianVwCy6gWLcd4Xs+An9m435WLxCXB0mZG7HibteeqXpMj8+oUqWkzU04Zx+XfQtCBWq9FbUzRxNROWlq6NBXkuf2wyiRlEeQ5pAFKusK29bxeDg5OOhe98dA3vCWoURj3MPPmZyM30Igc2qcvoJYlZp3nc8Piog99pBw4Ali1eMLPHLCkLpnm2mxmTwB9+wBOFamcMcdNCLvL1MfRL2i+FzBRRtJHZ8zKFSt4QRcm3DoYPpL7H607A7MFZx4mFAwp1ckZuaSuOOgCpPfCpi8cGw4ZNf9Ri3SI4F6wTnuXKCiGgEOz
 BXfl/4p1
 pfPJu3BhVkwFdplzkcrOx6tINF62aq2gGeywxgL73ALTQzKdnBH2X9jgVymYd9OFF6Q/ioGVbJd5cA1vNXc0m3R9TtGRKyJIK+vJIJVnFeZIIVLsoXk5bzeVf2Iub7650hQlbPM/baELxI+ZVHB0bvobpu8bcVVAfvf+8+ywct6+x/5//uzYicZalKXPlNGykHlwZUKTW08ySIrdwCR1RLvs1Xcz9CjBClF4qtIHaweLRk8rQpNa+srVjKRs2tkhFMHqtykUvowbRb/4ljulLGZAsI6SjhtZd63hk7gpFCnkxTJJDfoiOZxMeeSD6u7KV5YR8wCTrNkkSt3Bx9yzitLUejsYKYIN1zehKpgGS50oiSpspIsZMBCUCZMnR7pwbH4nw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.10.25 21:21, Ankur Arora wrote:
> Define clear_user_highpages() which clears pages sequentially using
> the single page variant.
> 
> With !CONFIG_HIGHMEM, pages are contiguous so use the range clearing
> primitive clear_user_pages().
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> 
> Note: fixed

That should be dropped.

> ---
>   include/linux/highmem.h | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index 105cc4c00cc3..c5f8b1556fd7 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -199,6 +199,11 @@ static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
>   
>   /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
>   #ifndef clear_user_highpage
> +/**
> + * clear_user_highpage() - clear a page to be mapped to user space
> + * @page: start page
> + * @vaddr: start address of the user mapping
> + */
>   static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
>   {
>   	void *addr = kmap_local_page(page);
> @@ -207,6 +212,30 @@ static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
>   }
>   #endif
>   
> +/**
> + * clear_user_highpages() - clear a page range to be mapped to user space
> + * @page: start page
> + * @vaddr: start address of the user mapping
> + * @npages: number of pages
> + *
> + * Assumes that all the pages in the region (@page, +@npages) are valid
> + * so this does no exception handling.
> + */
> +static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
> +					unsigned int npages)
> +{
> +	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
> +		clear_user_pages(page_address(page), vaddr, page, npages);
> +		return;
> +	}
> +
> +	do {
> +		clear_user_highpage(page, vaddr);
> +		vaddr += PAGE_SIZE;
> +		page++;
> +	} while (--npages);
> +}
> +
>   #ifndef vma_alloc_zeroed_movable_folio
>   /**
>    * vma_alloc_zeroed_movable_folio - Allocate a zeroed page for a VMA.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

