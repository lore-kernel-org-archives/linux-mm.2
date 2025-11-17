Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C811CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 23:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69698E0006; Mon, 17 Nov 2025 18:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B193C8E0002; Mon, 17 Nov 2025 18:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2388E0006; Mon, 17 Nov 2025 18:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8932D8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:58:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 243A758559
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:58:51 +0000 (UTC)
X-FDA: 84121766862.06.A25D1B6
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4EDE6120005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:58:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="hQ7FQ/9e";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3uLYbaQsKCOMFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3uLYbaQsKCOMFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763423929; a=rsa-sha256;
	cv=none;
	b=01owxkiGE9jqguLagCmzDFAhyIwYz3TVjAZFtlMNQMVDGbWPHRVHPRdlLOAazmoWXh227C
	mC/1LH6h9BJRpqAwIuQjV0AbqUgU5mK5sZFCUCrsHbeh9u7aINY+AB5erBm4Sw5Ropc8iW
	i+Pk5t9Tb4Kf2Dmpg6ED7+lyL0jwrrI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="hQ7FQ/9e";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3uLYbaQsKCOMFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3uLYbaQsKCOMFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763423929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ygYEskeqBNerRcGoe7wVhcGY+hSYx1t0h+PLU7ikDc=;
	b=w1npQTSDsVAqdG/wkcYu816Zw/xvFcbONbnmLzjVqVaBJ2dntZ9B6fM/i5FLxGyDOJtrU7
	qDP/uBGgnx0RxK6A0pFteqjvhJPPNrMwUHacKrlNnGd2buo2DMniS71Djmsm7m1buavVvg
	rLCviKHDQJhK7HOL0AyXlg2N3XTM8sw=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7bad1cef9bcso8478596b3a.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763423928; x=1764028728; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ygYEskeqBNerRcGoe7wVhcGY+hSYx1t0h+PLU7ikDc=;
        b=hQ7FQ/9e9rKp6VhkJN0JlWvqjQC06KRPw1Eriq/cbRw66K7Vb7vIzN+rLA1+/zproM
         ru4Hs+U6m1OH21MtdRwDVVQweAwxQZa/1814j//aWEadnc9mg/eZjTNiW2byMn4GMuI9
         mfqHXWBCyKR+MI6yId0yXBQAlXh9Ukz823zm46kTpiL2fLZ2b5KkO5uvocXS2Fl8vsab
         QKdvkmgjuwi7cNkfRKiV+1+ARUjhvh3nOLKEc1LQENrtrrMHtVS0+wlEkCY+vtgYRN7x
         P10ARdpRcgIg5u8dxq5XLU5dWdOnoJqLBhGU2Ucabs/JKKJK96YoSQuPcTH1GX9mn2Bh
         DS8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763423928; x=1764028728;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5ygYEskeqBNerRcGoe7wVhcGY+hSYx1t0h+PLU7ikDc=;
        b=KLAPNrRXlpT6jCJ+xhdQ4AHoabmvDkSLagOUkH2r6FSsUet6rpbAFYT4zZ0TPSy4D0
         7dcmamcbjW3VB3HI1jEV8yd3tgpZeYaWmqZk8w/fuxH4ZwzqULccJycBS6UHgGBCfh3t
         i7PTfhA1gQDFEMSFhJVwbWzBQyLWBzdt3mo2zqUbRvsd4xpwfwJcoGYhg8WYAMHNDe2o
         EWwYEWsUVTJQ1qp3EY/AuIS9zjoZsiksvbCLvBKuY05eHxKGHgudEIryPm7u3St3cUHF
         h5aVxlQFTxYGxdaSL8f+UIQsogcd4GYHUKz3XsmNSRGF3y86dQmE6CibNc+AMeZ/ljnt
         ZCCA==
X-Forwarded-Encrypted: i=1; AJvYcCUGt/dKk+I5lPAMAFsgud1cJYtPpBFjhWKsLMSrDaryfTcCaj1H6w1hMm9/p2yzXcM0BGJyspe3Hw==@kvack.org
X-Gm-Message-State: AOJu0Yz0g90IfWAqseGVSnewnfaJmsDaY98sV6gSr9O/Xy3lTdH7wj4x
	TIRYT8ofU3OQalfKzqXlwulXEUDBkOE7kRBWlfwLNnmRyIhWXKRitCx8S8XPYrI8ptWeUo0fL4i
	U07JxJSFgJZ5lrM17Ghmn1TlpgA==
X-Google-Smtp-Source: AGHT+IFxWXTBTtI2UukXobkfyKxRwRm4n7RvJLDKs/34/nWfTRqU+euiKxMKHvOHpr1hhg/cnjE46GW2X2zehltdJA==
X-Received: from pfbhm22.prod.google.com ([2002:a05:6a00:6716:b0:7b8:fc17:3960])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d27:b0:7b8:7219:63e8 with SMTP id d2e1a72fcca58-7ba3aaca144mr15697963b3a.14.1763423928025;
 Mon, 17 Nov 2025 15:58:48 -0800 (PST)
Date: Mon, 17 Nov 2025 15:58:46 -0800
In-Reply-To: <20251113230759.1562024-2-michael.roth@amd.com>
Mime-Version: 1.0
References: <20251113230759.1562024-1-michael.roth@amd.com> <20251113230759.1562024-2-michael.roth@amd.com>
Message-ID: <diqzqztwb495.fsf@google.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
From: Ackerley Tng <ackerleytng@google.com>
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, vannapurve@google.com, aik@amd.com, 
	ira.weiny@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4EDE6120005
X-Stat-Signature: k63oguf3e8rf9daxnar47tggarqshsg9
X-HE-Tag: 1763423929-462792
X-HE-Meta: U2FsdGVkX1/lRm4D/X5OxRTseUNsL6O2980hKNSaybC3pIj9dBfKLPFsnWVrWKeDV+WzB6Sg3LxT5OHIJPTnfSijpZX9o4oKl/Jsk5hO2Z3iwTxpfPXB7vihwtT2MafcQxhHmwjvWV6KQzuh+u89DHDUQWM54EL1eiWbltQV5BAwlXDRYKSYsYmc8xX7zmRfiyxnz6kHE1mGV1CrlZlLQkO4Gpxn40CCFEHfvz/7OIXr+yw9Ye1voGS0B8KW4Y3wZK8dNPEZ38eJHA0zTGXxBu6HJxTwGqX0A1UTzL3Hk0E+gpu9GNRCEaWUfHOA7azbvbLtEWavXGsRGMmQZvMc9MSGF4WY/RXCnqZmZi+zs+2FHLxm1sxlRMdCi8hFssGYxsMvjzGKySkOuUHUlPTt8rUP1xjjPtVCbatt6J19vxOzAgERW9nOttr9iQhBIQWP1AtaW+uyuqim2JKUvjf4iRe+Cx5b/1vHnr/w17zJvUKehemQfqj+jomEnwl4dyQBr7oZNCsWtGIbyHpaLw5jJzgxifKi19eo82Uqz+xZB/MtasisjQpK+/yWJqIDpFmqYAhl7Yh/zD3tngBJmFd+MupgU96gCrYhddXH1bFG9no6qIesXZI5HaLbIbFHq+djYkE0VDE4+bqz2X2XovD/ooL5Vm8WUp/BTuwRJmBQ5+xKwz0xXabSbdaztPiPBCZgdRPFAv3GcAmPcB2XoBJPPy4YOAGBKNCFwr4dEAW8UUFUlH7Z+XE1hiBIqVnxh+vvIEDHrXpSC60vLakWhjMQ0FxeykGa/Hr6vCXVIRtx0ZfCyS4+bDqtHaUWztN1ybWkh9AL0oczT+KKRoMu5oxnEtUigap8BVqKEGLUbvOMOPADVCJhDQeXnuLNwHIIwkcOTFPnAmjkBiQ6M9ePl2XC/HeSHdP+LP8RbyXSN2TPrX2j/2TrXJJBlryZljzcl49NiGHhb5IDVm/hjhi+c/9
 FrLsZKKv
 L/mpspNyuqRaLykYtmr6eTN0gRw1WovTDtbsTSOUkAOt7sR96r7qDZntP9tXeFwlFf70YV4SX19B3aCwrVPA9Q6IrJ7cH6dot/wdNYCOOvpAPK2D7lz3XPXC73V2YqfRItLdVvfQ2n6C8bB7ASc3x4weg8PEejNHPTS4vobQmSdm+SNkesMBjMRzpPKg7OG3pvHvoI5tE4gu90vcF9zEzQpFarQ8ppRVRg7+DzSOPf+/yt594bj0G285gS/WTxepgSxy0RCBF8JGmaK7HFK1Ge+6/aQ3sL5rO9kA56vZovkqXVyszLd5UXfnAV8+xD2nAkJ9o57cdzD4Ir6Swlpcu/03+j87/uZRaOfYiad7QncCXHIkLEhgd04rG3zIwCn8W1SLgkphhoK073rrKEB++Vef332dqVi/dO7rVs8K2WdR59/vXCJpBYYaH6YPcJW6r2DmIEpyZzpAj9lBKdB56gqV/9fA0n7WP8E0Kdz6JkQ89zkE8/H7VSvrnN1XmfG5mUCp+/5NrTHwJwNtkXA1MqNYPfzgq5klkLHyJrhwIsRxZsGMv5zpHFSNgjPrQC4cwA/uSwfvPvSWsnRjUOIP6Z/C/gRlz8vJZxhtsTN0ZDngWRtsDbVTgEjl51EaQHVJmQ1tHVTL6CRlZtMQvgkt+0N1x04wz5eTo58OeFAI15bDlnvge4NuUL1CPHbxFCnuxlwLh8Zygy+w9NcE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michael Roth <michael.roth@amd.com> writes:

> guest_memfd currently uses the folio uptodate flag to track:
>
>   1) whether or not a page has been cleared before initial usage
>   2) whether or not the architecture hooks have been issued to put the
>      page in a private state as defined by the architecture
>
> In practice, 2) is only actually being tracked for SEV-SNP VMs, and
> there do not seem to be any plans/reasons that would suggest this will
> change in the future, so this additional tracking/complexity is not
> really providing any general benefit to guest_memfd users. Future plans
> around in-place conversion and hugepage support, where the per-folio
> uptodate flag is planned to be used purely to track the initial clearing
> of folios, whereas conversion operations could trigger multiple
> transitions between 'prepared' and 'unprepared' and thus need separate
> tracking, will make the burden of tracking this information within
> guest_memfd even more complex, since preparation generally happens
> during fault time, on the "read-side" of any global locks that might
> protect state tracked by guest_memfd, and so may require more complex
> locking schemes to allow for concurrent handling of page faults for
> multiple vCPUs where the "preparedness" state tracked by guest_memfd
> might need to be updated as part of handling the fault.
>
> Instead of keeping this current/future complexity within guest_memfd for
> what is essentially just SEV-SNP, just drop the tracking for 2) and have
> the arch-specific preparation hooks get triggered unconditionally on
> every fault so the arch-specific hooks can check the preparation state
> directly and decide whether or not a folio still needs additional
> preparation. In the case of SEV-SNP, the preparation state is already
> checked again via the preparation hooks to avoid double-preparation, so
> nothing extra needs to be done to update the handling of things there.
>

This looks good to me, thanks!

What do you think of moving preparation (or SNP-specific work) to be
done when the page is actually mapped by KVM instead? So whatever's done
in preparation is now called from KVM instead of within guest_memfd [1]?

I'm concerned about how this preparation needs to be done for the entire
folio. With huge pages, could it be weird if actually only one page in
the huge page is faulted in, and hence only that one page needs to be
prepared, instead of the entire huge page?

In the other series [2], there was a part about how guest_memfd should
invalidate the shared status on conversion from private to shared. Is
that still an intended step, after this series to remove preparation
tracking?

[1] https://lore.kernel.org/all/diqzcy7op5wg.fsf@google.com/
[2] https://lore.kernel.org/all/20250613005400.3694904-4-michael.roth@amd.com/

> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  virt/kvm/guest_memfd.c | 47 ++++++++++++++----------------------------
>  1 file changed, 15 insertions(+), 32 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fdaea3422c30..9160379df378 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -76,11 +76,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
>  	return 0;
>  }
>  
> -static inline void kvm_gmem_mark_prepared(struct folio *folio)
> -{
> -	folio_mark_uptodate(folio);
> -}
> -
>  /*
>   * Process @folio, which contains @gfn, so that the guest can use it.
>   * The folio must be locked and the gfn must be contained in @slot.
> @@ -90,13 +85,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
>  static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  				  gfn_t gfn, struct folio *folio)
>  {
> -	unsigned long nr_pages, i;
>  	pgoff_t index;
> -	int r;
> -
> -	nr_pages = folio_nr_pages(folio);
> -	for (i = 0; i < nr_pages; i++)
> -		clear_highpage(folio_page(folio, i));
>  
>  	/*
>  	 * Preparing huge folios should always be safe, since it should
> @@ -114,11 +103,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, folio_nr_pages(folio)));
>  	index = kvm_gmem_get_index(slot, gfn);
>  	index = ALIGN_DOWN(index, folio_nr_pages(folio));
> -	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
> -	if (!r)
> -		kvm_gmem_mark_prepared(folio);
>  
> -	return r;
> +	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>  }
>  
>  /*
> @@ -420,7 +406,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  
>  	if (!folio_test_uptodate(folio)) {
>  		clear_highpage(folio_page(folio, 0));
> -		kvm_gmem_mark_prepared(folio);
> +		folio_mark_uptodate(folio);
>  	}
>  
>  	vmf->page = folio_file_page(folio, vmf->pgoff);
> @@ -757,7 +743,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>  static struct folio *__kvm_gmem_get_pfn(struct file *file,
>  					struct kvm_memory_slot *slot,
>  					pgoff_t index, kvm_pfn_t *pfn,
> -					bool *is_prepared, int *max_order)
> +					int *max_order)
>  {
>  	struct file *slot_file = READ_ONCE(slot->gmem.file);
>  	struct gmem_file *f = file->private_data;
> @@ -787,7 +773,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>  	if (max_order)
>  		*max_order = 0;
>  
> -	*is_prepared = folio_test_uptodate(folio);
>  	return folio;
>  }
>  
> @@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  {
>  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
>  	struct folio *folio;
> -	bool is_prepared = false;
>  	int r = 0;
>  
>  	CLASS(gmem_get_file, file)(slot);
>  	if (!file)
>  		return -EFAULT;
>  
> -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
>  	if (IS_ERR(folio))
>  		return PTR_ERR(folio);
>  
> -	if (!is_prepared)
> -		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> +	if (!folio_test_uptodate(folio)) {
> +		unsigned long i, nr_pages = folio_nr_pages(folio);
> +
> +		for (i = 0; i < nr_pages; i++)
> +			clear_highpage(folio_page(folio, i));
> +		folio_mark_uptodate(folio);
> +	}
> +
> +	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>  
>  	folio_unlock(folio);
>  
> @@ -852,7 +843,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  		struct folio *folio;
>  		gfn_t gfn = start_gfn + i;
>  		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> -		bool is_prepared = false;
>  		kvm_pfn_t pfn;
>  
>  		if (signal_pending(current)) {
> @@ -860,19 +850,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  			break;
>  		}
>  
> -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> +		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
>  		if (IS_ERR(folio)) {
>  			ret = PTR_ERR(folio);
>  			break;
>  		}
>  
> -		if (is_prepared) {
> -			folio_unlock(folio);
> -			folio_put(folio);
> -			ret = -EEXIST;
> -			break;
> -		}
> -
>  		folio_unlock(folio);
>  		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
>  			(npages - i) < (1 << max_order));
> @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  		p = src ? src + i * PAGE_SIZE : NULL;
>  		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
>  		if (!ret)
> -			kvm_gmem_mark_prepared(folio);
> +			folio_mark_uptodate(folio);
>  
>  put_folio_and_exit:
>  		folio_put(folio);
> -- 
> 2.25.1

