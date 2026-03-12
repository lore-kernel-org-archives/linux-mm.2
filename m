Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D981FED2E4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 07:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347376B0088; Thu, 12 Mar 2026 03:59:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA8A6B0089; Thu, 12 Mar 2026 03:59:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D61D6B008A; Thu, 12 Mar 2026 03:59:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2566B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:59:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B0CA8C9E2
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:59:54 +0000 (UTC)
X-FDA: 84536662308.11.9C8AEF0
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id BD88D180013
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:59:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4J49J26E;
	spf=pass (imf06.hostedemail.com: domain of 3dnKyaQkKCHkXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3dnKyaQkKCHkXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773302392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=veAXwLuzVC+ZNIrlPS+GBtiqKF5VYtsA7fb3KMFtUEM=;
	b=mJ1sjoCNDPwOkbI9/2ZvT/q03YVZxQ7/doTr9QTSrpkuiLwISmipYo0N9Z/jZ2t6v4N8NV
	pGMPDQY3BVsoekSamMYbLlrsbS8gWxFL9MeeSTxV1IfHWfuhS9n80Utc0UaMbTAZlcSEHo
	WUVlOVvF2nGjNq+Vd7mc7QgbeR6i9eo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4J49J26E;
	spf=pass (imf06.hostedemail.com: domain of 3dnKyaQkKCHkXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3dnKyaQkKCHkXifZboveidlldib.Zljifkru-jjhsXZh.lod@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773302392; a=rsa-sha256;
	cv=none;
	b=fXmpLm+j1KLNO7If6ElJgYMJs39ptR+99AtSXOYhplmvtWKXuhtT7Gk9bCyk55imAeVpJa
	vubzLL5TP1s6YIH9BLQv3SVhwoH1BIUK9+hs0mC1KpRrsbE87CMd5vAQqRUq6bEmjrAYMF
	YO278d/LhNxME2Zym5LvxicvEsku0JA=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-663678f9e6bso472831a12.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773302391; x=1773907191; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=veAXwLuzVC+ZNIrlPS+GBtiqKF5VYtsA7fb3KMFtUEM=;
        b=4J49J26EQJW8mSjFCpyuwPP0Xi+wgL2TTxYWI8s2sjXlI2c6m+Vw4bWL1N30KTP1RT
         93fXicZucHabCNeif/1y6+MplYovdDOBIDmHedbYkXdhXAVF/seqz71appFcmB0IKB8e
         vVuyI8YAXFkji9c2q9ljzZ6i5ANo5ngukpIeo9hf0RcpldRpj/SFvRn4AaQVT0fEUano
         Hd2oPHQ0ioFOtqsc27It6A5RPZakE5S0hM66ytt6EQPddaC+XzKAd+pOSBqiDHcFpQBa
         zHUpSrGfoh3pB7kQ8UCI8MtihcKEVXDSA11bzp18YgP8mnNv/URAqc1OD1pzEGdy+a2P
         KG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773302391; x=1773907191;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=veAXwLuzVC+ZNIrlPS+GBtiqKF5VYtsA7fb3KMFtUEM=;
        b=W3+3HvUJTSLlQo+pCwNsVcXZNKzFtMIS+wINdbOoVFDNG1OMhStQdJvxiJz3qVcuVy
         PA9+3vwY9vHwt5Rb0hwheigFMPFpVQdhsy3rjjNf1FowMvMXSfF69cA9VeKEIQI+ac/d
         4+0QSvJGyswMNE/eQB8E0EMBx/vaaABCKJ4p/dAclHUj9XaeH7JdrVxqNHVB1hbNh0C3
         fILmWliQv/hU0Gv79PLFmoUPwckPFto5+o2pRBODwyyx22IWNtn8zwlTAF6qjc8a5rD+
         QSNkLnfc86tx0htX17lsamXf3hL97TrRF/4sij9VeQBliEAva+xlPore7Ufe0zzcYmKA
         yAwA==
X-Forwarded-Encrypted: i=1; AJvYcCWCZAYuGCtd7Ec9Bu9w0VtLknJwfjKk2yCDC4VXpG23VSLZ+jdR76qt6SYvATE4hpxIeKlBTPQ6dw==@kvack.org
X-Gm-Message-State: AOJu0YxP77lDMLEax8GTCqZ3x6NinWVQeW0yvj6iWyTv+iEwXm48ct4u
	Arim1ENTHBKCuACAsyeMwyTpDKmQwqlLx2nkcZ/311GDgjvLXq8hfxADcnSbG44ddQ0T69no0Hc
	K0gldaH364Brbup979A==
X-Received: from edf9.prod.google.com ([2002:a05:6402:21c9:b0:660:effd:a3f7])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:13d2:b0:662:ac7e:aab9 with SMTP id 4fb4d7f45d1cf-66319cc15a1mr3102004a12.8.1773302390771;
 Thu, 12 Mar 2026 00:59:50 -0700 (PDT)
Date: Thu, 12 Mar 2026 07:59:49 +0000
In-Reply-To: <20260309-vmalloc-shrink-v3-2-5590fd8de2eb@zohomail.in>
Mime-Version: 1.0
References: <20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in> <20260309-vmalloc-shrink-v3-2-5590fd8de2eb@zohomail.in>
Message-ID: <abJydalLnoddywQq@google.com>
Subject: Re: [PATCH v3 2/2] mm/vmalloc: free unused pages on vrealloc() shrink
From: Alice Ryhl <aliceryhl@google.com>
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: BD88D180013
X-Rspamd-Server: rspam08
X-Stat-Signature: 9dcsygheuqmoatag86jpj4nqp55g869m
X-HE-Tag: 1773302392-583853
X-HE-Meta: U2FsdGVkX18QmXUFXOFDYR8cjKj5C1cuboQutFuIs/hVFcK45FzU32LqP/XhYM/c3ulVOn4hboDIVyNSOghIQB+8msxaUXuwJvBphIa+hRTy3F9ysMACl+DJCb39xl3+TUEpWZoA6ST5lnm+qJy2cwwI5gFujKJcm/0NTJbCbQSxMkjk7dtgW1PbQzETWQeXZp/HSVp0nBRtD1PnbAkUJJI5Oe2mxixDXmuek9Uv9ZTnQI8pC2AF4e1MRekgWCA/7GLpGeUYxIgq8BbfrK6KlomIwcT2LIFnA3dFr1uhJkknKnlOAF9RrT3K0AptKo/rMPqIfG1zWAYcKx/JGie2bjominXBq5LlvAAjXhSUy7gDLFFTZlymnOc7E5OlrRzvUkPeR2bVdjFJKMZfnlQxbU+++e2zQH8OZ+H7T0HRbmF8ZTCrGLhnWUhdjlzXgknYY+x8Tn+CsT+JXFdLrO/V8EbXkBc7KMSxbdlc6uosig59gxWSKOLdGEqiH+m0q+0H9CBwqQh/o4+ERR7LSq7VNBkCYyJNAkzCdqBHlgFXO2diQTdtn+hiQLzyWD4svrsYyT+u6i/216HpmK2vDy+nCTcPjfBZNCNH8cekfzWiXqz4Pb4nK15d7qcycq60QL5kOH7LhTI7JqvIAEJB9HjGuWyihUG+DraONzTJJTzKwHnEYkI2a8bACn0tYets0stwqDszBPJ8LEp/APH/otg+eUlc68E0yN4p2sS+PkFEfL7l2UK1iwUoW/atpGq+nLNd2F9yMqigN9wmlgF7HjNtEQKGsfefiOMAx9dn62N414M0B6c8alWiAP2rpSi2kMwRCmcJ2338dLIujF7bxLMK5/YQFc9Nx/W6pNUneX4p0eVkHk025W/+1wlCeVhSxwdDMdd0/o7/IJGINzZF193ySPbCVkxLAp+r6BTokoBn+RulFF2jgX0fQDkQD+eI7T3N8kSgEAKs6e12UGGOnt/
 qFOg3yjO
 X9gkopUlXYPsbqzlyDuivRNsUCYErkqexB5eSdgZMfNLNaeM2T/F9F0mfURqgFuEJ91nGvwVzQ6BlrvBzhV6PrRmihxZ4BustRd8TDO3Y97ZDzXH9Zwr1tajf+0d+O0AOkjdB5CVB0eu2Tn/ZIKBFWI+bb68pyvyDqHxPnGfvhxUY1/wPCw/N4eYZo1Ini6EhEJ2LQfQoDKIbmmIk0JWD0LqtOB6VNtQ1NhK9/XCMQbUN3BON8NFsIu2QdDNDLh9GYjCqUDWj8hsa+M2F5YHnXPD46JZC7cSjpncIGDLuNtLedxs8TU5A9rYjrj50KyHmAcKFa/QDLLfcoOFkoIfW7kFBzbNTvXAsDUH9LuVr2MUybksOZ/zJUviinRVnZQxGl8L6yl6cuecZCRlljoO7noWAXtI5mcPZS+Z741/LO/8KF9uu2BITpo0NsMoZ/6oh/AB5bbPC2ToqOAHUrXC11E1A3usFa6/uMWUbCrBSPKinS8u3F9D0PHVUTcNPbSXkTzQTYEx5jHZvG3UYlzKisrd8FPGTypOTa/8AStzH3adiOMqkEMxbm2OMol/9zyLrTuHFokclky+rFQVHG49XNutI0EvarSz4O7Q7yKgIx4fydcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 05:25:46PM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> When vrealloc() shrinks an allocation and the new size crosses a page
> boundary, unmap and free the tail pages that are no longer needed. This
> reclaims physical memory that was previously wasted for the lifetime
> of the allocation.
> 
> The heuristic is simple: always free when at least one full page becomes
> unused. Huge page allocations (page_order > 0) are skipped, as partial
> freeing would require splitting.
> 
> The virtual address reservation (vm->size / vmap_area) is intentionally
> kept unchanged, preserving the address for potential future grow-in-place
> support.
> 
> Fix the grow-in-place check to compare against vm->nr_pages rather than
> get_vm_area_size(), since the latter reflects the virtual reservation
> which does not shrink. Without this fix, a grow after shrink would
> access freed pages.
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 42ae68450a90..114e0bd1030e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4344,14 +4344,23 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  			goto need_realloc;
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
> +		/* Free tail pages when shrink crosses a page boundary. */
> +		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm)) {
> +			unsigned long addr = (unsigned long)p;
> +
> +			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
> +				     addr + (vm->nr_pages << PAGE_SHIFT));
> +
> +			vmalloc_free_pages(vm, new_nr_pages, vm->nr_pages);

This leaves the range vm->pages[new_nr_pages .. old_nr_pages] with
non-NULL but freed page pointers. It seems less error prone to set those
entries of vm->pages to NULL here.

Note that it's not a problem for existing usage of vmalloc_free_pages(),
because it is immediately followed by kvfree(vm->pages).

Alice

> +			vm->nr_pages = new_nr_pages;
> +		}
>  		vm->requested_size = size;
>  		kasan_vrealloc(p, old_size, size);
>  		return (void *)p;
> @@ -4360,7 +4369,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  	/*
>  	 * We already have the bytes available in the allocation; use them.
>  	 */
> -	if (size <= alloced_size) {
> +	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
>  		/*
>  		 * No need to zero memory here, as unused memory will have
>  		 * already been zeroed at initial allocation time or during
> 
> -- 
> 2.43.0
> 
> 

