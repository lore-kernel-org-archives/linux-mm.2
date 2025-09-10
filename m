Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B43CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 15:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4EB8E0022; Wed, 10 Sep 2025 11:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC6E8E0006; Wed, 10 Sep 2025 11:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2308E0022; Wed, 10 Sep 2025 11:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1DAEE8E0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:22:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9479313BF6B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:22:32 +0000 (UTC)
X-FDA: 83873707344.07.A376033
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id 558F41C000F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:22:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TCx6kk20;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757517750; a=rsa-sha256;
	cv=none;
	b=jr7sTzA2kIo71LyTeru54UxI4bbFlsWQCrEZXTo9MsaNG3BpZOlCurdqmFoO79TyAGeLSo
	8/EglVTAHxa+w5QFupuiAChn4nMfJXbB2rsw0RPZVzrwS11nIY05k1+S3EtDXNwqcRHGhN
	1E3DqG6LY8W81KMUHq0GeaGjPrhijR8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TCx6kk20;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757517750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Q/qIKqTt/TeHwEAuPNWMb+Opu1b3bhXOvxk1BCU0qY=;
	b=QyEJGoobf9F/NsL2nVSJctp194Vu7rzWtaA/uCEpebTK2cXwMKzdspdNxiuyKPTlO08SKX
	U5l0OFMvD+h8FwSBHuVARmAoUxMsn7fekXKUExtSWMnudD0l8Tzx7g+yzWWHt87NOUhEXT
	/dVjDS41+pU46NkHYfm0gr1oMK+0zKw=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b0787fc3008so148086266b.3
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757517749; x=1758122549; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Q/qIKqTt/TeHwEAuPNWMb+Opu1b3bhXOvxk1BCU0qY=;
        b=TCx6kk20/xx6+iNyw8/vkR9P5/EUX7156m9d/hHaOub9dBDIQkVSL9zEX+JzV7EnUa
         1gZovga3jkbvHvPGyXbUgX+csUOrTXd41jMVOBh0gfFI9JBfH9TyCtnnxYxUjp7Yw41L
         IfvK58Qu0HSltt4LOm/43iKFfAFI7vAvfncQyy1giODEJDgrQANFJ4kn7ILmHBtBE+1e
         HzuYjqioqRb1Z5o1f+/Kh1PTfbVXIda8b8VTnohLEMpt04QgkHn2ve9kPbrfh2T2DOXr
         /UwXw2BuNdGQXdwuT9OzWKBrN6DsIWhWTAJAIFR+nz9czC+uiiSx4/RP0tfpE6tefvG/
         3FIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757517749; x=1758122549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Q/qIKqTt/TeHwEAuPNWMb+Opu1b3bhXOvxk1BCU0qY=;
        b=K3EZdzpcINhZahuftNUH9gjnCBMGfT4Ylvrrym6NDKDdGDlw/WvVAiQAYqvDUEKZLj
         4zjk6wkudNIg80GRqBt3/UGZ9pJ2OqYnPJiyJu2oCLm1zCRhZRE4d3pdwKjTQTIPbzbq
         IWUnQhn1RgsFx9ikq3A3zFfInh7enttiol66bZEnzcFpABe6SIaPoNSVQsrh+/4uLNrm
         YzSlWCaWsfpxCvgUZ0mPmnEGWi+HLfMO6T6jEF143boJYF8M3EZsBtjI0iqP7fXH0k1+
         3GXk9/hoFfTF0TU9iJE4DdYjY5VJ0D2A57lZ2AyK7jBbZtbVnY8v4L53FNCxVP2K9GBm
         dc0g==
X-Forwarded-Encrypted: i=1; AJvYcCVgmXrFK7hR/NtYn1/ELS3R1MEcj/cyaxC7zIMVwzu72wQlADfdsNqUnmsn8M+3OO+zZJFjjhy4qQ==@kvack.org
X-Gm-Message-State: AOJu0YyF5l2VgCzGLVTuXofP+DYRQSW/Mam76irtZATS4M28irexguIS
	omxBJlc3Zvl+xdD2ry2QkqT5xKbRREaF6qYS+gi/Xm8Zxug0JWzZ1UD35BMz1E0rY1k=
X-Gm-Gg: ASbGnctPECOzu5SQgYhBzogEoDaqknQ63C4qmUH3gXUgHad6CFokTZv7WPklXenrOfB
	2VXpczsDgZJafYWOquFYHAAAJDNjbuZFY8CsjZrdrp4a92aCoVNhkEkMa4Tt7Ly65b3IMptCbSh
	jnrVm9p9GmH1Lg2vld4BPplgQESm65arSx5qFspBlDrgZ53PV1JcXFZn6iw6wtWm/XSqXxeic7u
	3PnchMmnYSHf/6FiRTJ6+gVDuj6q7a6RzljtWHknB09GY5gDMhab2BYF/QNSDFw7RbsJYFG4eIx
	gRmUXCrR6oHHz0tHXjZYum4NmTdCebA2e4SdL+YdIeIbPBHoFv1Ii/mbuJ3lqQZtGqrSbrbBs52
	J7g+Y5LUXbQ3HDp3sw1nNfCNJNX1yYfLkF8My8SQp11SpPBGMR8w5gmw=
X-Google-Smtp-Source: AGHT+IGu1RPgfzvjjZxcEkpx1Cu0aX34wfa0rbwgT6cXKfY+5y9LXUr0ynjlTUCJ2SRrzExxIqoXFA==
X-Received: by 2002:a17:907:6088:b0:b04:48c5:352 with SMTP id a640c23a62f3a-b04b13ca12dmr1500001166b.5.1757517748203;
        Wed, 10 Sep 2025 08:22:28 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b078e361902sm110599966b.67.2025.09.10.08.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 08:22:27 -0700 (PDT)
Date: Wed, 10 Sep 2025 17:22:25 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	tglx@linutronix.de, liam.howlett@oracle.com,
	lorenzo.stoakes@oracle.com, surenb@google.com, lenb@kernel.org,
	rafael@kernel.org, pavel@kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v9 2/2] mm/oom_kill: The OOM reaper traverses the VMA
 maple tree in reverse order
Message-ID: <aMGXsenuvA682-Dc@tiehlicka>
References: <20250910143726.19905-1-zhongjinji@honor.com>
 <20250910143726.19905-3-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910143726.19905-3-zhongjinji@honor.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 558F41C000F
X-Stat-Signature: ryxbwzcj73uzr9sx4dg8x6zh1f4m3brm
X-Rspam-User: 
X-HE-Tag: 1757517750-736768
X-HE-Meta: U2FsdGVkX19osSvT5dWT+T5QlUAoo0+Ff6p3uHD55pjWQACoH4jz3UL2s3FNIz6gryM0ScFJ2UR7/1ix4svpEdieEEbTJjCAsVB6pSj984H/xlPUsGO/yHdMBq1K9ArBhsN1wPM4f8oTi35bbOYBQBAFQWFsInoVJ8JvhO9ScpX8+4a0qlLWhHMgZbs9pccuPQSu8flx7dUkKP38P4BlShFArLTZyszQtmX78jc+o/2tEaFLpkvqCoN6aAU9YWrbf5LXgcRbruEGGIaXajNEo9N065I6l/P27mMJkpmrlETj2pT2JJ47Z0OE1eOsOp2zN1eKCF5gPHEkvrDPJGLCRtfhrGMD1ElAKz71EJAuxtPSV8ghQ6ytaugcu65KmblMe9x8rkRzhGJpFZLI2571VEdaxZG+glS/iKcTLm31TO0t82pSDyzKGR3CK/OGeSM/Sk1BsfqmV9yJsM14FjV6G3uJp5dONKbpeeoQ+hbadKs6kzjUWxtwpLF4KpLmac4ZmzOJR3dicpK7kNFNeEcuLx6KUA523fRdZVFOgP4mcWLJ0U9qRp0QUfxcS64KXQOyM4vgXyewcgbi09VNuVoMqd9y4xKhO/rb51Wn3ivZFFWNL67YqEhbqdaYN+a0fx1I2GWoor2zgBCtt3rO3Lem+Ih7xSran3Ea7JLbdh8TQUX/ompbO7L2uvWsuoUww6kQKRCifIOMedNDnw+nLc+InfoqhH6LiJlZNnmRF/jdWbn6nxFiVzC+waY2ZSPhTVZyy/f6iUdbrJ6lSUI+GN7IrldT1plOFj4f72SdVohKyySQuLdQtjAmmoe4gIeCPZjalU3Mr8hoZGwpi0taoMBFqvvbmE/yf857Dx2mgC2DFSrgZlfUl/oveKTiahq60z6unsu7R4sQCuXE2i6tLJAF2tCxhPfqFw7TwZRPqRSPRY9zqIx+tjSLmcvYl9LR/GzSxDXQtDGktrsuPmV8UFf
 AGhx879G
 jCgdZ/2UPTQgmO9qSwBWYQgscvj0K06oHSgnEZ85aIRDx281WDJZH/Bd3soul7ynhILwwo2jaoPu+uZ/Fb+MZltvNAJdGosg+4G/XPsXMJhp3PUaD9OI2xiOKYwi6+ufUDMvx/vM0lNMcXbpHJATla62t4LcHQbZ2aki43iRdm+Odax5akfxRN0u+ARC9KgWwPBA3v2PN/YZDrJvRKFee/a9rZhNDPLy84+zH3rYk3j5aUhgJBqmeizE362u55IimprmwUHD0Suu/o3FiXZgPNspbdIH+xi3ZUeVvW4nFodTZsCV/+HSaHEF4DQkY6XnkneoIg7N/zjvMbjVGSAjmExKTFkJXNqcI/MRrNqcD5afosaLmFa1aTdFzP7JFancL9yHOF64Q5ynM7OTOZjpz9PyZIeFueIteDOjoeGR2zE9Zti1PiDs8MenigWmC7G5Y5ZQ8FJ9TcyReVsmHemvKIi6V/ijQjCL0WwR4OoQIaoaUa4kXmFV+7F5QdOLtu6chGBxJoEYmykdh6Lm7Rr6YWNRVfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 10-09-25 22:37:26, zhongjinji wrote:
> Although the oom_reaper is delayed and it gives the oom victim chance to
> clean up its address space this might take a while especially for
> processes with a large address space footprint. In those cases
> oom_reaper might start racing with the dying task and compete for shared
> resources - e.g. page table lock contention has been observed.
> 
> Reduce those races by reaping the oom victim from the other end of the
> address space.
> 
> It is also a significant improvement for process_mrelease(). When a process
> is killed, process_mrelease is used to reap the killed process and often
> runs concurrently with the dying task. The test data shows that after
> applying the patch, lock contention is greatly reduced during the procedure
> of reaping the killed process.
> 
> The test is based on arm64.
> 
> Without the patch:
> |--99.57%-- oom_reaper
> |    |--0.28%-- [hit in function]
> |    |--73.58%-- unmap_page_range
> |    |    |--8.67%-- [hit in function]
> |    |    |--41.59%-- __pte_offset_map_lock
> |    |    |--29.47%-- folio_remove_rmap_ptes
> |    |    |--16.11%-- tlb_flush_mmu
> |    |    |--1.66%-- folio_mark_accessed
> |    |    |--0.74%-- free_swap_and_cache_nr
> |    |    |--0.69%-- __tlb_remove_folio_pages
> |    |--19.94%-- tlb_finish_mmu
> |    |--3.21%-- folio_remove_rmap_ptes
> |    |--1.16%-- __tlb_remove_folio_pages
> |    |--1.16%-- folio_mark_accessed
> |    |--0.36%-- __pte_offset_map_lock
> 
> With the patch:
> |--99.53%-- oom_reaper
> |    |--55.77%-- unmap_page_range
> |    |    |--20.49%-- [hit in function]
> |    |    |--58.30%-- folio_remove_rmap_ptes
> |    |    |--11.48%-- tlb_flush_mmu
> |    |    |--3.33%-- folio_mark_accessed
> |    |    |--2.65%-- __tlb_remove_folio_pages
> |    |    |--1.37%-- _raw_spin_lock
> |    |    |--0.68%-- __mod_lruvec_page_state
> |    |    |--0.51%-- __pte_offset_map_lock
> |    |--32.21%-- tlb_finish_mmu
> |    |--6.93%-- folio_remove_rmap_ptes
> |    |--1.90%-- __tlb_remove_folio_pages
> |    |--1.55%-- folio_mark_accessed
> |    |--0.69%-- __pte_offset_map_lock

I do not object to the patch but this profile is not telling much really
as already pointed out in prior versions as we do not know the base
those percentages are from. It would be really much more helpful to
measure the elapse time for the oom_repaer and exit_mmap to see those
gains.
 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Michal Hocko <mhocko@suse.com>
> ---
>  mm/oom_kill.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 88356b66cc35..28fb36be332b 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -516,7 +516,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  {
>  	struct vm_area_struct *vma;
>  	bool ret = true;
> -	VMA_ITERATOR(vmi, mm, 0);
> +	MA_STATE(mas, &mm->mm_mt, ULONG_MAX, ULONG_MAX);
>  
>  	/*
>  	 * Tell all users of get_user/copy_from_user etc... that the content
> @@ -526,7 +526,13 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  	 */
>  	set_bit(MMF_UNSTABLE, &mm->flags);
>  
> -	for_each_vma(vmi, vma) {
> +	/*
> +	 * It might start racing with the dying task and compete for shared
> +	 * resources - e.g. page table lock contention has been observed.
> +	 * Reduce those races by reaping the oom victim from the other end
> +	 * of the address space.
> +	 */
> +	mas_for_each_rev(&mas, vma, 0) {
>  		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
>  			continue;
>  
> -- 
> 2.17.1

-- 
Michal Hocko
SUSE Labs

