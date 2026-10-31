Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62D68606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 13:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iJICbfa8
Received: by kanga.kvack.org (Postfix)
	id 86A516B00EF; Sat, 31 Oct 2026 09:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B856B05B1; Sat, 31 Oct 2026 09:40:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B1E6B05B2; Sat, 31 Oct 2026 09:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6016B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:40:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34F27409DD
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 13:40:21 +0000 (UTC)
X-FDA: 85383030642.29.E369031
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4E1D740003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 13:40:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iJICbfa8;
	spf=pass (imf04.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793454019;
	b=nvuWbYxX8flcxW2WhSfUDNvuJ+phxid1wk3kkFl2oXvvhwwTOJBH8MNaOsGSVqYSuxya3/
	4yZIiEbtKcbcFhH8Shelm9fMPvpfXBmK8HUA148QJpVZWzZEW2RBYvcQ7NDA5VyaIoeZc3
	/b5KefRaOmvQho3+Epl+3oUwDm0cRYc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iJICbfa8;
	spf=pass (imf04.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793454019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AvdEESxqCoWismxl8U8najQ6zPeCJtfE4dKqVYiQpFs=;
	b=xbQ5MNcBffybNTT8HWhBVD1YMrlBQnqCwgT6qWhhFetGHFmkjsNzVOrtqAWwC/oimkBxV/
	EI8MpWSGqLp3OqxGd1FE+7aDU4LYbHDtkPXYDTtqZpwRX0TD7SGXVTEhiOma89bK1TEB7b
	rqok97706lCHwOtoLakXh9Ybzc2GBAU=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so16631265e9.3
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 06:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793454018; x=1794058818; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AvdEESxqCoWismxl8U8najQ6zPeCJtfE4dKqVYiQpFs=;
        b=iJICbfa8H+3F7fUpujWWuiyuI1AM4wgaElzcecqkYr1evKfm2wW2KPYtqyJGVqwNve
         vquQ5zoIG1KP0OXvKBDCjbtFYZrE5XB33pzuu+ooTR5pvFxk9SrD/M2gG6DQZx6w5adT
         0x2ViZH5HW8BJhLi3ZeR1g6Q2GNe8FefuzdDEP0BYxcv1ZcqDEQ1iZEG1Dl3pCmBdEl/
         eYqabtfQKSuPn46qKA2H9OynNYIjDk7GbsGvCOYahdIz4mVpdTohf1PIXvV6xlMMlipx
         MenDTgWaqGisldpR7gO+UNqUpo16BmWzP9wOHZ1MbKMEDS64eDez4HpGCpzXjYWLG1rt
         iY+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793454018; x=1794058818;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AvdEESxqCoWismxl8U8najQ6zPeCJtfE4dKqVYiQpFs=;
        b=0IjOWaxWitQouLR1ko69Y0F+cHJ8jwLPQogZT7RRpVacXY3vAvOFWb3sDPuEESwrYI
         kkF/xv1KtP/u5z46GgXHwe/l9C20jyCBkCucRSi0gH1MUy01UN2DW5caacIdLsj1+FaM
         TIox3yCqVqr62JNm26d8upqOi5YV+7xE0OH1OHWTFEsuJZYmThvUmFu8idm93bJXRo8B
         UGos+CLPaFjQAEqvchPCoIRbIXeq5sPnqDZIuprJN5rAbmRiHA+uPkelpTwi9sPS2YMA
         +0jU36YPyJEDgoWwB0Cf72NGlnDVolsFr+6s6gBjgXgpBiOs0pWBOgsjU4/2TB3j/SVI
         Z6zA==
X-Forwarded-Encrypted: i=1; AKwUvBy5Gj7hADCYR0+JZxq6zAWmViJdpmMNNWqNDxN43ZtS/4J3o8uevt6RM/VPqy92prOst9pVODnDGg==@kvack.org
X-Gm-Message-State: AFq9FYKrpy/3nrUxjrx5UEnkFroQnbJds+/qhlCu/0VH4chJBmRqz9/o
	YQ/gu11Bd7Wu057IdpV7nCt/lubtpTl4xLsh+IZAsgipNhQvDHGNh96ULQUg6zFz
X-Gm-Gg: AYBFou0zec/IGnABRTgngdlktdbNiKsKaZrGpdVZ4kenfPWckYfbQ3AXcT97l6cri+l
	AE8fhZdFMYNKYFqQW4Ks3OOGuO+zTdp974CgsIvzOHvXjx99DA2kYnMY6zmzMt1OY5BZPmPNZI9
	841S7lH0+6pEbnOkaO3ADhqVMDsO2wOaVyuE3hmfv1MsbLf9Dp/pBsn2a9i9aVs7QdYU+jS2o4q
	IIfBaKXqP3vA6dg/oB+6KreGGVPEPV8fKM++9PIX8G6kc3v2IZDxJnmgqGebFqIRzRyxXetkE6n
	aRMVMXSYGW3Sm8mae8KsgHFTHE7APp34M1iYgctPpgC5dmZi5+S1Bfce2Tip6ws4bowr7IKSilM
	ByxWyl/A8fq5MHgVR80HBQwprE5imp/6ss6BuTM3KB+2LsUFYBQsmnFG2Fp2zQ+mslUSnolD7No
	0n+CjTSHC2mulO5yJZEX1QmSZplSUh3aHYNWlRwHnQDRDqCDH0xvqjeGx0IkEBXdccE6B/TaUuh
	dXTVI5UnNsYW1xBToWQyGrmT4nXCOlSi2tPXHae6VBJ3z0SG3vcr/0X/Fkcp0svSC+2hYD3QZrg
	IkZdISJdS2M6gWcjk2SVGzpS
X-Received: by 2002:a05:600c:c16d:b0:4a1:e00b:a0ea with SMTP id 5b1f17b1804b1-4ac150b204fmr125293245e9.1.1793454017873;
        Sat, 31 Oct 2026 06:40:17 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm193004545e9.1.2026.10.31.06.40.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2026 06:40:17 -0700 (PDT)
Message-ID: <2c132a52-1118-4773-866b-a8c713c4933e@gmail.com>
Date: Sat, 31 Oct 2026 14:40:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] userfaultfd: clear uffd state in child PTEs if uffd is
 released during fork
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261031-uffd-prot-bits-fork-event-v1-1-3572921c2111@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261031-uffd-prot-bits-fork-event-v1-1-3572921c2111@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k7j4xm7kszyahw5kbjgo18z98ohbyfha
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4E1D740003
X-Rspam-User: 
X-HE-Tag: 1793454019-435368
X-HE-Meta: U2FsdGVkX18v0xTnxdc1SYnCglHemFG/70kBcO/CtaAkOF6G6upbpnBLJjH67IU//F/jrOvgm4NcEF9wXquzxAug24A5GC3AYnowrnfy2QGpb7XA5axUNGIZ3jyFyaAtI0dyug4SM6kf0WBSwUOyJtEoiXTEvXAa6JjEafHjEyLE8XEPqY3b7f0nr1BYkSBiU0X5XqM3/DWXLxD6OXbpxdahwGeoHwaVABj2urVZ+7RHQwqs9QQT9SJAWDjynoKdG8dZ4lnffK11TUgBLbXVl/2oSTwOQkTplyi8+hCCGP8VuaCCtU5gR/pRaVtHFRU3q5iycuODs91a2ZEKO4H9nuZUxVhcXWm0QbFDffZTS0sGnZVSVQNx/bKVHxGcIGmGr2cZd2sphgm2FICndl5chrYlzZ4+a2rO/qWvuIiWyLE4sCF8UBnrfmhPdV85leoa1K+mcmjIVFGRG/5egFfAWa7pHeuy9SpQopxTZu7nBszcdaIaH1nKaFeCIjcTJin6IncAuNC3B+bA6ZueDDDfOWvolKyeFJ/GVM2ECIvAov0j2NiU3sZevUDu7IiYuXGkC9pn7nKEqeY/skmBjavA4K8E3w6Wv3TXRdlwtLv4W//LwDvwJ1gHB5saU/gJZBILb34KSurKoXvviczJq/ZcP5p50+9Uvf+M+zJTfwUDwRsUld6uWd4R5j5njFNxXHpxyne+c9uozUtmAMLj2y+IvH/Scr7/G2V1SjrwloqV+fW1a4ACU0Ioex/KLmvHuyi98ONKyUaCT3FhyQ10xWQMKR1ERADDUO9oFBDpi8lVS5l4KthZyfpJVh76vlbCwhfg1eRF2035Sq4ryBvstaY/TK6rM3P/3XYEufxNvkZKYb6TpyZOSK2shw7DI0dKFCM/8LgF8wTPzvXWbqVlLeLH2754rg08BkTarHlgW03OMgZB0UGdLFJmDtCQAw1obohJqYTMVF4POe3lv1p+o5c
 cvtBun94
 BQrlr62qWK+2ZIocvVi2FRqWG1mtAryxGS4lsbOyl2ZLE2vQJD8Vl0LLrP8iu0GTCBgOoqqT6MvPxmfSFIxOEU21jJQNu3kfLy2APs2mGC7afJnRSlVByN619QukDMXCVsMTMBL4dopxyeFwan3sUKB4VXdzCKp1kgBrv/McoVzGq5yd+aF30d+1Mc4dY19DnpQ1wnmf7Sq2zV16swm4HFqTx9AqqByYcG40ScsYEYZ36cHbCulzxApPYUvheICOQ9Gn9n9nClP7iTCgdPKgJyvWPl/KerVuDhtgrXi1I6I3VZ9BW1ponhLZbPLNXvgIzOtzMhaYQb+jHhjPBn9vPf+/TZPyMyEuwO3CA+yXAipqkohxiIgdNcF5iimWd1ypt0+sgyKeysoPwx5/V/n94WAuwEq7VKafIXxiZF2A/lhcM4gKPL0JlCjADYZ6HQEZ9iuPsRLFuzrOGdIjyS8xdmu+GjkW1ITiDsyVxb3zOGNarm9s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 1:35 PM, Mike Rapoport (Microsoft) wrote:
> With UFFD_FEATURE_EVENT_FORK the userfaultfd context is duplicated for the
> child process, the child VMAs are registered with the new context, and uffd
> protection state from the parent PTEs is copied into the child.
> 
> If the parent's userfaultfd is released before the fork event is read,
> userfaultfd_release_new() resets the VMA flags but keeps uffd state in the
> child PTEs.
> 
> This leaves the child's VMAs in an inconsistent state: they are not
> registered with userfaultfd but their mappings carry uffd protection state.
> 
> If the child registers the range with userfaultfd again, the stale state
> turns into protection the child never asked for.
> 
> When a write fault makes such a PTE writable without copying the page, the
> uffd bit remains set and page_table_check_pte_flags() warns about it.
> 
> Split resolving of the uffd PTE state out of userfaultfd_clear_vma() and
> call it from userfaultfd_release_new() before resetting the VMA.
> 
> Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/userfaultfd.c | 43 ++++++++++++++++++++++++++-----------------
>  1 file changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 3b71712edab4c..2c11ac5dad3d5 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2220,6 +2220,28 @@ static void userfaultfd_reset_ctx(struct vm_area_struct *vma)
>  	userfaultfd_set_ctx(vma, NULL, 0);
>  }
>  
> +/* Clear the uffd bit and/or restore protnone PTEs */
> +static void userfaultfd_clear_ptes(struct vm_area_struct *vma,
> +		unsigned long start, unsigned long end)
> +{
> +	unsigned int mm_cp_flags = 0;
> +	struct mmu_gather tlb;
> +
> +	if (!userfaultfd_protected(vma))
> +		return;
> +
> +	if (userfaultfd_wp(vma))
> +		mm_cp_flags |= MM_CP_UFFD_WP_RESOLVE;
> +	if (userfaultfd_rwp(vma))
> +		mm_cp_flags |= MM_CP_UFFD_RWP_RESOLVE;
> +	if (vma_wants_manual_pte_write_upgrade(vma))
> +		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
> +
> +	tlb_gather_mmu(&tlb, vma->vm_mm);
> +	change_protection(&tlb, vma, start, end, mm_cp_flags);
> +	tlb_finish_mmu(&tlb);
> +}
> +
>  static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
>  					     struct vm_area_struct *prev,
>  					     struct vm_area_struct *vma,
> @@ -2239,22 +2261,7 @@ static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
>  	if (start == vma->vm_start && end == vma->vm_end)
>  		give_up_on_oom = true;
>  
> -	/* Clear the uffd bit and/or restore protnone PTEs */
> -	if (userfaultfd_protected(vma)) {
> -		unsigned int mm_cp_flags = 0;
> -		struct mmu_gather tlb;
> -
> -		if (userfaultfd_wp(vma))
> -			mm_cp_flags |= MM_CP_UFFD_WP_RESOLVE;
> -		if (userfaultfd_rwp(vma))
> -			mm_cp_flags |= MM_CP_UFFD_RWP_RESOLVE;
> -		if (vma_wants_manual_pte_write_upgrade(vma))
> -			mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
> -
> -		tlb_gather_mmu(&tlb, vma->vm_mm);
> -		change_protection(&tlb, vma, start, end, mm_cp_flags);
> -		tlb_finish_mmu(&tlb);
> -	}
> +	userfaultfd_clear_ptes(vma, start, end);
>  
>  	ret = vma_modify_flags_uffd(vmi, prev, vma, start, end,
>  				    &new_vma_flags, NULL_VM_UFFD_CTX,
> @@ -2353,8 +2360,10 @@ static void userfaultfd_release_new(struct userfaultfd_ctx *ctx)
>  	/* the various vma->vm_userfaultfd_ctx still points to it */
>  	mmap_write_lock(mm);
>  	for_each_vma(vmi, vma) {
> -		if (vma->vm_userfaultfd_ctx.ctx == ctx)
> +		if (vma->vm_userfaultfd_ctx.ctx == ctx) {
> +			userfaultfd_clear_ptes(vma, vma->vm_start, vma->vm_end);
>  			userfaultfd_reset_ctx(vma);
> +		}
>  	}
>  	mmap_write_unlock(mm);
>  }
> 

reproduced the leftover bits in the child with wp and rwp on all memory
types, and they're gone with this. tested on x86_64 in qemu. LGTM so:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

