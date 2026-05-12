Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D30C7CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:49:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0307F6B0088; Tue, 12 May 2026 12:49:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFBFF6B0095; Tue, 12 May 2026 12:49:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3376B0096; Tue, 12 May 2026 12:49:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C85A86B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:49:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 715A240549
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:49:11 +0000 (UTC)
X-FDA: 84759352902.17.390FC67
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CE11A180013
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:49:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SzBrj4kc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778604549; a=rsa-sha256;
	cv=none;
	b=kKdLuAKCKRi5dF9qYl5zgMw9X/aW5a+1h3Vqebfymho5gpmyzHUoj1QLCTqkgoX/Nnn3nv
	9oyYitrHSIgarEBjhxrH4rR4khBa6ezIvtNS1g5qvJFbPlkAD5dMk4MG5Y0Z1AlckcQZuh
	t11k2uam/gqD/umcFU6qupdaEcpFzvA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SzBrj4kc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778604549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96cEczZVVuv6C6y0pZIECfa+oQ5GabfQd+MvrAagGeI=;
	b=i8N8muX9IgWmf0VJCQOTID+Ub6OaIXsqbXGbPyAepYy1WQt8WlnwcKL7GbaaGEfm79Yp5R
	35D8nhwiy5EppYtQOUZ0b69Q52zSAyf5R4g83bSeah4oh4TTRV/TnpGlBpxs+jWTruQBdS
	3Fgtcl00JHWU90ZftuaYdoIsFlCBjdM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E87A61119;
	Tue, 12 May 2026 16:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18C3C2BCB0;
	Tue, 12 May 2026 16:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778604548;
	bh=dTqLTRTuoCK+qHQVUE3hzoOV3vNVfAyMSu0DEB6GkGQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SzBrj4kcyWoKsuKzpstlzcU9JRKNFW/UT44aiyBR/6bdKiWSpT+YoWi+lwMwJ2jJ9
	 6W+7jtJf8HYcEbT+KtAcOQkqAo3Pdt8S6OrREAb3p7sNYhkvmjzhl2gvwjvpxLiFCo
	 8aCTAMU3kex41W3c34J7VapJ5ZugDRebFlz6yKUTYTOVh6k3k2wB/u2I832xsiDm+K
	 ofteUGekKc8t3phkpRuJugVkM954ouM2tk5iH91EKA8iIhTyH3WMmnDxsyK9hQ3nan
	 bGzbO27RQlDinIWLGHSWDfJk89tUYWL2wXsWNrTBZxIqqESBSvYMFVULsG0p7oD2hd
	 CpK31d9RCu+YQ==
Date: Tue, 12 May 2026 19:48:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 04/14] mm: add VM_UFFD_RWP VMA flag
Message-ID: <agNZ-Q7A0rfY66gj@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
 <b47d8d5681fd8730f6090ebfdb72f219a8edef1e.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b47d8d5681fd8730f6090ebfdb72f219a8edef1e.1778254670.git.kas@kernel.org>
X-Stat-Signature: itbik4y5an9fm9btsrx6kny1irketpnr
X-Rspam-User: 
X-Rspamd-Queue-Id: CE11A180013
X-Rspamd-Server: rspam07
X-HE-Tag: 1778604549-966397
X-HE-Meta: U2FsdGVkX1+qkX8mlEGnwVy+IBKjmhazmod5rXTqdGGlVxqnDpIPeDPjG36pfh/DA4rfqEatthilY9S3XSRaHa5vnVKSaQ5nf43LfcVELaWyYuMMJb6ct24ExxYcl8zHlj/t75R2D3iisWHTkZfKAYHWFeuNCPf+47/ulS5qB3ZDHfZGxfFYRXQvwN4x2Eqx8gnpbYCH4mEUuUM9bdexF+a6HfyHk++msVrIepWuuxAh+Mc2ZtuL83U8Bxam0OT4gdCFFrrl20QkCZ9WASvjT+IPs18Um7ofwOOcs3AXq960VuvUULiS9WD/7dHR2hcMS/mfi4Ng22Mbsd/xNkETLPLLcC07tb+lpazEmM7Z6Mpiaoypl9sbaaZnmvgyOXEJhfautKlTNC6eFOGguUU6tdp2+n7wDomiz0c8y3GJXMVAa7Sr6a6b1Rgk/04kJY8V6GgmB3JgJsKJ7JwMvg82teGr5TSernPRbCVi14+ANv9ugsUIPE1e5y/9p+XNYVjfi0HNyvCMYQKtuhx4oI2CHwO8//3/vlXdVZIJdydxxgt8tR6nsznMkz0TEk64MGHdCrn6owVeYxaMWB/NVd5Jr/OeuMRtxxYCpRKq43laUMuxGJCluvOTyw9chlR/Ia+C/R4JRNOf2R3SF+i73f1pCodhwj71jV5LiFfthn2LQmKKD3GelwsXJdoVdHM5qnEluvEaLc3f7M9Ep13Jq9sslcwlAopCuyObNLNqv0ihzKILwdn4xUe20LRhsc3J4uxXxzMwSGb2unfPbe1ENASYkHO9WoNPX7g9lFmsgO3/1c6k2Aj/qU7JAdouK2YWlpLxkD4MAqGkc07V2M+nIHhWF4T56KibDu8ncqDWFrhIzza9TPnLiu6f+mhdIpzI6yr0O50fqqYDXKo/e3GfHn+KhAc0XHH4X08AZHKlfbATpvxHTiaQRvYotpqU/OC+4yBOiF7cRvnXC+yDF95NFJT
 PsI01GGZ
 a5AdQDZxdYp05o39n/oz4gPH9SMzfwxl706FVeN/ivaL/2xmXXEc6Y2pv4U9HDe7sfLdNNOLrzOiWP51q106HVLb1bwzVu1u2dNFJ6N/hbuSNNSZRA/KqCGaGyvrSlntnOpfGQb/RaIICbtfXwjLyGCWwfvz2s7DmRkXg5viAsiFtgI3tP3UEXVcHmAqF3H7YHLYFVEigEaaK62N+gmRdGeKDSkr/6m492tlD0Y/uFQuRd/qznGiOK+rk/ai8Sq0Ii8udIe8x4XuEecKNB6TI1KonsYLFrJPpjm/44WPBiSrroRvMH61VvbcTS3YP4u4pUvbi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:55:16PM +0100, Kiryl Shutsemau (Meta) wrote:
> Preparatory patch for userfaultfd read-write protection (RWP). RWP
> extends userfaultfd protection from plain write-protection (WP) to
> full read-write protection: accesses to an RWP-protected range --
> reads as well as writes -- trap through userfaultfd.
> 
> RWP marks ranges by combining PAGE_NONE with the uffd PTE bit, so
> the flag is only meaningful when both primitives exist. A new
> CONFIG_USERFAULTFD_RWP Kconfig symbol auto-selects when CONFIG_64BIT,
> CONFIG_ARCH_HAS_PTE_PROTNONE, and CONFIG_HAVE_ARCH_USERFAULTFD_WP
> are all set; call sites that gate on the flag depend on the symbol.
> Elsewhere VM_UFFD_RWP aliases VM_NONE and every downstream check
> folds to dead code.
> 
> Nothing sets the flag yet.

And nothing check for it as well, am I right?
Worth noting here, IMHO.
 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  Documentation/filesystems/proc.rst |  1 +
>  fs/proc/task_mmu.c                 |  3 +++
>  include/linux/mm.h                 | 28 +++++++++++++++++----------
>  include/linux/userfaultfd_k.h      | 31 +++++++++++++++++++++++++-----
>  include/trace/events/mmflags.h     |  7 +++++++
>  mm/Kconfig                         |  9 +++++++++
>  6 files changed, 64 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index 98f546e83cd2..fcf308dba311 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -21,10 +21,11 @@
>  #include <linux/hugetlb_inline.h>
>  
>  /* The set of all possible UFFD-related VM flags. */
> -#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
> +#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR | \
> +			 VM_UFFD_RWP)

Nit: can we keep mode bits together and protection bits together here and
in the below changes?

Otherwise looks good to me

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  #define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
> -				      VMA_UFFD_MINOR_BIT)
> +				      VMA_UFFD_MINOR_BIT, VMA_UFFD_RWP_BIT)
>  
>  /*
>   * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
> @@ -192,7 +193,7 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>   */
>  static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
>  {
> -	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
> +	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR | VM_UFFD_RWP);
>  }
>  
>  /*
> @@ -222,6 +223,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
>  	return vma->vm_flags & VM_UFFD_MINOR;
>  }
>  
> +static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
> +{
> +	return vma->vm_flags & VM_UFFD_RWP;
> +}
> +
> +static inline bool userfaultfd_protected(struct vm_area_struct *vma)
> +{
> +	return userfaultfd_wp(vma) || userfaultfd_rwp(vma);
> +}
> +
>  static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
>  				      pte_t pte)
>  {

-- 
Sincerely yours,
Mike.

