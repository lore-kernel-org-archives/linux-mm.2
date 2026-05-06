Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20650CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 18:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6492B6B0088; Wed,  6 May 2026 14:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9EC6B008A; Wed,  6 May 2026 14:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E89B6B008C; Wed,  6 May 2026 14:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 397256B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:27:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E1F301A02BF
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:27:55 +0000 (UTC)
X-FDA: 84737828910.27.D0C7F39
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id DEFFCC0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:27:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I8Yke7sH;
	spf=pass (imf22.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778092074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ahWUXqPYeaMsd00zZP6mrvWm2cueyZ5IdvRpeyyBBs=;
	b=hApDvhdoPtkJCwlSH4AZWALc30WDayiQjWSl6DtQdwUB/2R30S+jCtVFKg+YOVZCXndJpg
	/JCVNTcJd7ZvHGmKVHIPyukzP5ol/saqz8ZJ/YhXOuPk10T5w4iOSyTBzsknaANZwVpP/V
	IyUpld1X9eFCmivEz2n8teIxrxHoa/I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I8Yke7sH;
	spf=pass (imf22.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778092074; a=rsa-sha256;
	cv=none;
	b=eJ+TS9o0ka8E3ZBhR267C8u9Nye/YCdNL/deFvTZa008vxXpSWAsjqShzscngpoDNw1s50
	+xe3uf/No1Tb4Kqfdq3+8YzSFDkTcB72TvbfEsjzFYnF02zNaTddTW4LIsCjnHVtIK8UPq
	5+jRXCUdjL7OL6f+LoKaKXmvNEEvKzE=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5a525aedb24so7440408e87.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 11:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778092072; x=1778696872; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6ahWUXqPYeaMsd00zZP6mrvWm2cueyZ5IdvRpeyyBBs=;
        b=I8Yke7sHiTmkdULpgc8kqkhiz3Q9YG0Br8FVZ915/fOB2V6wCMzsioRSe61Rcnz4cx
         G85+Bc+x6Xl4JNiGHJgrf+g603krBZCVItiuyqEN/iP10LpksLpW5qpgpkNRCbzvmyoI
         BUfKYwQmtThfuDWcZYK2FkyjJx3obBFzwIS+4Q6rSzipGd9LQgmGMpa/0VppsrJ8gGIm
         U1XffkHZdSZ67U4yaidZrPy2sQdwiqDNKPqI2Z07gVo8IDFySLAAURflCMaOVcOV/um8
         8h5H9NddvtTY8YjUkjxqwNCPL1WaNxK4gddmFhEHcBBVwbqxrpSt0DE/i/XCZk4fg3Sk
         K+ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778092072; x=1778696872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ahWUXqPYeaMsd00zZP6mrvWm2cueyZ5IdvRpeyyBBs=;
        b=Un8yrI5p2MAGha6R6wO8YIp7r2iJ4gGtrlK5NSDLRJWH62vcvjcdqWw7NbwnKKWXzc
         mZhb0TLmD3IkokgflHi9+ADqhBXD1PKQpEMeodLNeYFyf8saz3ud8XQzcbAJoG8aa4lW
         j4m1hvnr4/UISUg8JAV0X7y+MLOqqcEqV55taVg/MMo6JsKIRnfvBenl9gaWBhT5Zwmg
         SB2ngbIBrk4b88uFgqo8Q9ylZJLvODb44hxTm+BCvP4llHT4wynZtG4OXkWryI5/1/RX
         WzQHLtPh4Ly3m0/oo+8TNzQZiks+OTzrvJxVoBRd6EZdJZ0zWm0mOq1R9Q0bhbHtRo/M
         regg==
X-Forwarded-Encrypted: i=1; AFNElJ+JNcDD7sCCE7VyaYvGJZb+gXvsAseGcbaG8Yu1wU2syVt0dCpRe8eQzomBiDGE5EMDSGWdCsac+w==@kvack.org
X-Gm-Message-State: AOJu0Yydi9RVXwVMB2QM0928Gc8khULChGUUWw43G0s+e6AVbxG979Zw
	DychMrp4HycGom4ADdO/HWx4E5ujLMAfGDzP/alO2nKAgXiOzlt7sSH7
X-Gm-Gg: AeBDievYRGyQBXxwCMd8+v8jy8h5MinrQ3zDIfOFboWsLYMtePXD/eHEpk2G6+Y0PWp
	cXJLoqwrgTY8j5pcXrsJ4WOC09AHEySZmlVaq7bAGvPsn9ZTHdB/ZbnyP2zm4jSgQf3AAIju6+U
	ayVIvL9lr2aq3VIm0ixfrNI048frzdRvWXobeVaoImax6+YqQ1n1dCFt3wyudVRsT/EGZGO9fJ+
	mZKke5i4rkvKWmBLWyvRaeHKXUESqqYOzd/oFPSEjHgXkoYHmAZc4FLATO+CcLoIF6HNh6fKTo3
	ciP9HeD49BStYN+QFLG4N3sL0mGyheNs+NoMkEMgFN/n5ceXlbII04PIZu/6VMPJ6j4srvRgXC2
	kZbNwZUnpUvnP8KEjjOFg+Z5UkLbATMzAYxwjTlkvg7qRitpJokn1Mbm1wIofWdOSX16oZEQXOv
	aGEAokEkarZIuSFJPERhLMdtgz4fGS7g==
X-Received: by 2002:a05:6512:304b:b0:5a8:6e64:a932 with SMTP id 2adb3069b0e04-5a887cea7efmr2029835e87.32.1778092071653;
        Wed, 06 May 2026 11:27:51 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500:de96:9acf:5dca:ede4])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a86d599974sm3611601e87.49.2026.05.06.11.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 11:27:51 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 6 May 2026 20:27:49 +0200
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v12 4/5] mm/vmalloc: free unused pages on vrealloc()
 shrink
Message-ID: <afuIJQ8jZr7pQMxE@pc636>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
 <20260428-vmalloc-shrink-v12-4-3c18c9172eb1@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428-vmalloc-shrink-v12-4-3c18c9172eb1@zohomail.in>
X-Stat-Signature: 6hzdxnngfjhyn11dmbrujw9niqai4ux7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DEFFCC0005
X-Rspam-User: 
X-HE-Tag: 1778092073-170859
X-HE-Meta: U2FsdGVkX1/EJgT9olXXxEP09WBozd+6uxPbAJA0N3fBU0eHWn43nrfNY3gwd3kTThqYSDvtfUX7HwanKCakGz9MqmjNX+dZwwAdZFITJd+Faxm+SoICn/mG4wrqCFRf5tNlRp31tXThDEyGf+9lIlVGNlw9WIjA/5UAnU3qFPaA1EfPKQHyObgaEaXyPdx4B2EPgWlnkWFtH9TnyeL0S94dYHvU/zFbhSRYp/9Viwi+y9ySmUfv6sEGHg6+ySpda48syA23YbiIVwim1oyL+Qevz+uvVWa8VpvxMRdkyeMI/uI0GM1vP7mQXlbSw4TBGHQ9MHNfUM065jIjvuqEOLqoe0g2w5/oY44Fhr01HHGi6kqoTb/a4Ml45gf0KET97i8vNE2A9asxWFgViTsVyOz5W8bkwfthTzEe8cKNKAs99cLN6wq772ksAs7xZfF3W4ZhbfWsb5FjlNltigMOZ+xKkapEN0+vuiYZmEiCY5d/WN2dGyVnfpNYNQUpM6gea5Xj8vAsQHhdV01RdY/7BWb6p/CXBnOkbz138Bp7JX+5u4jwXtfDCJjiIdD+El4zCmkgaxgKLOPkfTGkBoUxmLXmSu8A0/vPjfAThESbWfhaSuRhUi2Qv4XOz8XrEroaiOLsIl0h+1uV7xZyu7bwvoJacNEx9krf8iJEGOhGwX3brphsCeWvcEGn585nPNCSuQSYtqu8MWXUpQY+fSS51VncCKgZw+GZauarqcmyRQHoOTdDdJhvUFyDutyz4jiVWpPDJIoDbiCtcUYDR7PGM0cRLpiOc8NVc/qkQWrsTyRzR9qopjK5yJyUY2j0G+sr6LgqvNONFd2driPdwZNj3D3bcMrnpMnUuP4R9Bh2ZCV/EKYQqkV22enKBWJ5FtLLrmkT6JTlxCoLwIvF7/3iCgpr9TrSYloMZzjkIf3AQI7r0I8jZZaZiSEGAB6Wsp8fMjLWxNZyIt/7NzMDFln
 izW6e3DW
 5cvAjN5sRjvSMfOVo9slkFf60rn0B+VJ647jzeaS0/P70gGphH27qAS9BQ9VU1fizu6n3RnD+OBFJaKRrfCJYZpWAnqWLdHH8pufgelTWJw0Tf7nPIwb33GOAJ2nJmY4fS9+dNYBb6K0vpfmuFJxuuHZVDDDSoOfzio1r8yttJASGzO3QV6StPLsZeRrzRGw1Qr+XGEGxGES83sMoUPFh2ECo4OyMs8o/6fpsLLeRPJ1BXbLcIqBXgngE/WUmMfnYc4f22ZgWRuNTq4EV7qPDOe9JU/ihcnBX3I4x7gdaI0B5oZc6RjWibRaWSa+TXYSVvEkv6hK57XfsuI4l0BSuMDSSSmiqBo8FGMOB5gusjVCa9/Cbo0sD5SB4ZMA1Ppgh4M2ZN3YBpybVnS21W2wpn3PPIlRUmyvrV+KFQsMCj6+3DTIi+inf5P88fK9WDj4rBkxoJtK6goUW0G4hDD6wLq4j6Z/Cf6KlaeijCBbttJZIvt4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 01:54:19AM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> When vrealloc() shrinks an allocation and the new size crosses a page
> boundary, unmap and free the tail pages that are no longer needed. This
> reclaims physical memory that was previously wasted for the lifetime
> of the allocation.
> 
> The heuristic is simple: always free when at least one full page becomes
> unused. Huge page allocations (page_order > 0) are skipped, as partial
> freeing would require splitting. Allocations with VM_FLUSH_RESET_PERMS
> are also skipped, as their direct-map permissions must be reset before
> pages are returned to the page allocator, which is handled by
> vm_reset_perms() during vfree().
> 
> Additionally, allocations with VM_USERMAP are skipped because
> remap_vmalloc_range_partial() validates mapping requests against the
> unchanged vm->size; freeing tail pages would cause vmalloc_to_page()
> to return NULL for the unmapped range.
> 
> To protect concurrent readers, the shrink path uses Node lock to
> synchronize before freeing the pages.
> 
> Finally, we notify kmemleak of the reduced allocation size using
> kmemleak_free_part() to prevent the kmemleak scanner from faulting on
> the newly unmapped virtual addresses.
> 
> The virtual address reservation (vm->size / vmap_area) is intentionally
> kept unchanged, preserving the address for potential future grow-in-place
> support.
> 
> Suggested-by: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 52 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 65e0a23efb3b..9f810d306db9 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4346,14 +4346,62 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  		goto need_realloc;
>  	}
>  
> -	/*
> -	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
> -	 * would be a good heuristic for when to shrink the vm_area?
> -	 */
>  	if (size <= old_size) {
> +		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
> +
>  		/* Zero out "freed" memory, potentially for future realloc. */
>  		if (want_init_on_free() || want_init_on_alloc(flags))
>  			memset((void *)p + size, 0, old_size - size);
> +
> +		/*
> +		 * Free tail pages when shrink crosses a page boundary.
> +		 *
> +		 * Skip huge page allocations (page_order > 0) as partial
> +		 * freeing would require splitting.
> +		 *
> +		 * Skip VM_FLUSH_RESET_PERMS, as direct-map permissions must
> +		 * be reset before pages are returned to the allocator.
> +		 *
> +		 * Skip VM_USERMAP, as remap_vmalloc_range_partial() validates
> +		 * mapping requests against the unchanged vm->size; freeing
> +		 * tail pages would cause vmalloc_to_page() to return NULL for
> +		 * the unmapped range.
> +		 *
> +		 * Skip if either GFP_NOFS or GFP_NOIO are used.
> +		 * kmemleak_free_part() internally allocates with
> +		 * GFP_KERNEL, which could trigger a recursive deadlock
> +		 * if we are under filesystem or I/O reclaim.
> +		 */
> +		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm) &&
> +		    !(vm->flags & (VM_FLUSH_RESET_PERMS | VM_USERMAP)) &&
> +		    gfp_has_io_fs(flags)) {
> +			unsigned long addr = (unsigned long)kasan_reset_tag(p);
> +			unsigned int old_nr_pages = vm->nr_pages;
> +
> +			/*
> +			 * Use the node lock to synchronize with concurrent
> +			 * readers (vmalloc_info_show).
> +			 */
> +			struct vmap_node *vn = addr_to_node(addr);
> +
> +			spin_lock(&vn->busy.lock);
> +			vm->nr_pages = new_nr_pages;
> +			spin_unlock(&vn->busy.lock);
> +
> +			/* Notify kmemleak of the reduced allocation size before unmapping. */
> +			kmemleak_free_part(
> +				(void *)addr + ((unsigned long)new_nr_pages
> +						<< PAGE_SHIFT),
> +				(unsigned long)(old_nr_pages - new_nr_pages)
> +					<< PAGE_SHIFT);
> +
> +			vunmap_range(addr + ((unsigned long)new_nr_pages
> +					     << PAGE_SHIFT),
> +				     addr + ((unsigned long)old_nr_pages
> +					     << PAGE_SHIFT));
> +
> +			vm_area_free_pages(vm, new_nr_pages, old_nr_pages);
> +		}
>  		vm->requested_size = size;
>  		kasan_vrealloc(p, old_size, size);
>  		return (void *)p;
> 
> -- 
> 2.43.0
> 
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

