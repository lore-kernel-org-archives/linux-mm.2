Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C5A4CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 23:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262CB8E0087; Mon, 25 Aug 2025 19:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213F78E0038; Mon, 25 Aug 2025 19:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1030C8E0087; Mon, 25 Aug 2025 19:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED3A08E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 19:08:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 593BD84442
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:08:24 +0000 (UTC)
X-FDA: 83816820528.18.B2E7FF9
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 89C5BA0004
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:08:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BuAgneXx;
	spf=pass (imf25.hostedemail.com: domain of 35eysaAsKCL4egoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=35eysaAsKCL4egoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756163302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6PJFrEMJOsfQGkwPQ/N5M5tBh51DW0OHIWOkD4RTR+M=;
	b=3Cfv6cRedXXGx8ffMf5ZgAE5uypqPHSKLgB5LGKWWfbN5yiEfCezCNdfRobfdj9wTtdyxK
	UbNydjq3gqerCHMCawew3NnAeI7ZWKjx3kdFv3m+BDiPLmO3qoUAgo1D+8Q4Yw5/zKX7hW
	64Vmw6qegN8AqadyO+KedKpS8tPKqVo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BuAgneXx;
	spf=pass (imf25.hostedemail.com: domain of 35eysaAsKCL4egoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=35eysaAsKCL4egoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756163302; a=rsa-sha256;
	cv=none;
	b=ZlGvscXdVj9LB+k7lYrsxT+PUBhBUK+U+Jj27Cxh+pd6Xl9WmRvgZQ9gmb4g98ZpLpxZqo
	ykB0b9FgfE5XYD1NiE0wZ1tn6TTzkrz8FKzQq7IWRODZc77Al6TqRoYomERgrkg7FOu+L3
	fpcjGZVu++xHwYha1oVT497lIAtwuZQ=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3253c517fecso2770850a91.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756163301; x=1756768101; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6PJFrEMJOsfQGkwPQ/N5M5tBh51DW0OHIWOkD4RTR+M=;
        b=BuAgneXxbuTyGrC/AvkNlgi1KRda/zwlowJKqRPzvELEF0hzE1Vn+dOGyEYkBuzMgt
         XoBakHzylcFbZ4Phli5eXlR5XAZR4l00FS1X027+qJI6JgDcdDjurSUuFKYrhyGPYwC4
         jrtLbc716n0iGSFPgPx+pWpTAEYBcjHluHMxTSqu2FMd4+mmirtH/GNu+cnsJtgn5n7r
         NWkDlEE1i5MlgMtc9nrETAN/R9zIFERvTylB6PDyTi/q89Jm2sI7UtycaEJPvRjyN03f
         C3r15m9Vw4CbuR7CbyB9F4wv1ylvYAJtRBaCxtuDYM4nvlgHL3nrd/Y5IOE7ZA3GlhEs
         d9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756163301; x=1756768101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6PJFrEMJOsfQGkwPQ/N5M5tBh51DW0OHIWOkD4RTR+M=;
        b=qxuprnOYHwPpyK8ozVl+9i+P+GffSYlv+X1piwRmTVdg+m7cGHfyIkSV99ajKrMA0W
         IHQ3eZAEeuW0gPtapXf6leObjeK1kT0WxcyqJL1Lf0aQ0puh0NEV1XwTYPwKpIa8GNes
         JHzXPZfYmSc/fZaF8Ig7bkV/2HfrjX040xZHASksV89Sl4JuB2Zx/AXBOny/Xuhe6YpG
         msuuvYXaW9E3BfhcxMjP3rn2zESLIAo1FgPa99zYkY6yj+XanRcmbHg2nlS5wbr9IVRX
         Hhhgec8Jq/uOafkLu4jrVfI8hFNPzQZDLPv1775ArTv63x57fDOOfPki5H50JlgLtvYO
         7wIg==
X-Forwarded-Encrypted: i=1; AJvYcCWRJk6UT+MIX0TBuj1wiozGVCqxHYw4ddinl7iuQqkLwRQw+6RQ7N61y3SKIrQeAxWVSWTT9Vi9lA==@kvack.org
X-Gm-Message-State: AOJu0YxMhVT24QP84voTXff9rdFlOV6Auy5blzPwf8lPBU644Tn5jhTy
	Ni8lky3RK7rIVjePJG+U5nTJ+Pnn/940nVqvK4FCcLrdYVKpcIV20U8seRjtt8JjQVZxNmdcR+N
	0Tld70NVjvH+BjLuLivSimozVig==
X-Google-Smtp-Source: AGHT+IGrq+HLRwUNYqwfx0diY7kjY6ycSz8/ZKkUZKHTSFbsyen18fZ+mR6CbkMqwPv1W2G7A6frXbr5O63R9MtgwQ==
X-Received: from pjbpl15.prod.google.com ([2002:a17:90b:268f:b0:325:220a:dd41])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3f88:b0:31c:36f5:d95 with SMTP id 98e67ed59e1d1-32515e2b881mr14983372a91.2.1756163301311;
 Mon, 25 Aug 2025 16:08:21 -0700 (PDT)
Date: Mon, 25 Aug 2025 16:08:19 -0700
In-Reply-To: <20250613005400.3694904-2-michael.roth@amd.com>
Mime-Version: 1.0
References: <20250613005400.3694904-1-michael.roth@amd.com> <20250613005400.3694904-2-michael.roth@amd.com>
Message-ID: <diqztt1vf198.fsf@google.com>
Subject: Re: [PATCH RFC v1 1/5] KVM: guest_memfd: Remove preparation tracking
From: Ackerley Tng <ackerleytng@google.com>
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@redhat.com, tabba@google.com, 
	vannapurve@google.com, ira.weiny@intel.com, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, joro@8bytes.org, 
	pratikrajesh.sampat@amd.com, liam.merwick@oracle.com, yan.y.zhao@intel.com, 
	aik@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: k18gst5zauxyo9dj148dgrystjs16jq9
X-Rspam-User: 
X-Rspamd-Queue-Id: 89C5BA0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756163302-982068
X-HE-Meta: U2FsdGVkX18PwyMwmKomh3FPqJ9yryRV6FuUi2mhnIItLgDZorKtGbUSpoTIlT/R1K1N7J3daWWR4/zyI2eLf3tPXV7X1hyPgJlxU8lrVjvSPLk21KTwubUfSq78G4lrfxdavXb7d/IWMjCc8XtXr28syd+b/H2ryo5TmsGHLUfKZzQ6Th6WW/QL6z5hksHe93oDqkCi9htI+M1sFcbcP40PWoktTsDGKcUU2J3YvQzT9UOfbTQoqgOrHamiXtcNoorEcAjiDSC0/nMg4gAlCbBgM+JfSyZc5gsBGP5ppWLRsdELatDiLMKd4sHRy/ipdFcWG98qJ1y94ZjCsjnOs2xUZKiawGRczF1DAnny7lazmLPemboGuOjQIlZ0BIqVImCZlONMwDkNlm0TTXISfirwEtn/Z8YqEwYOsqa7m5cyAQPwsXg5J5T7yHaDmIY1AaZGFfWEamc07vzoKwW337WY5mWGjDXesvIFpt3ZzBTkt3K7PcuGm9SIGf9RTZgcDfPhA+oDOBsiGTqvTmzomX0NhQk7HFR26Dvg+6PAR/Jw0OzMgBoERWsO2QxP/u0z++Au02jW7CRikI2swcKvSYk++AWwQaJ0vVP4Rn0d6HbDXf84n0ukM+ZIU2eN0K6++lnKcAyeH8NOYSEJmih1zHlzMKLQTS9n0JPshby/ZF20v7eD411RjZ4Vs9tvFIJ5WlhGmEkdUVpJP44pbo0STjjUyNKGOscaZjdp6BQDC4gLiGgshtz8z5r9OhXxukdEsxwSayfP9XHsznoIqZd0DczRQqb5SMHCoPcvqMKZhgnDlWIJl8DNeyGMCkvnKVP+df/D3tXsyJ3ZRra9jt8FDEoNf0hu3HZyFozmNmmSH4ma/DKj2DqtH2CqOWzTNTuiwqdlb4U1yt0rQefuLvrhj3TWFklX34tnlOe0EZWJEkEqfwxP5o5LV5kbOuUJOzPzCzjEcrp2rZtj5icY+5F
 dnWbrEaU
 klpfz8r7SBbcWUx7xPN0Zi3MZFqu+zKjLlCpPNcOkVRUPtikhTqvRHSfHD8vzXTe3wW/qj7k3SPPifxmSEkSJsXN+ZTRbGb2LgwzU1p0hwlCLStx9StXXKarWGwsoWBjS1vIJKAEGszMBaGaCOCuGraO0Em7cjl2M3yPJpUs4GImpKE8/aJ00RHrfw3QaOjvAE0yYMZAXSg/vgHbFFz0lqchk5bXvcRsr/kvps8TbNgeMTl5Sc6g9cVoTsqIH5A2k3s4nRNODjm0DfvY8kADFmAFVXuPj6CmYGs9iIvVA0ALOlc3ROif8XUUEAPX18SLBslIqJhsZpNGDFmiPpTksUos+srfBKZG0rUoKT4NDNXd3Y5d88Z9m7MiuLaLhctEYiQzKAyOtARuk/rRO9vksthxLCrzM3kuzNTBn6c13+1oGBgAIEia3yCUA4ac9VWMPZhl6wRttBT+0zxoSjfQVQW+rMgzzP1rjgeRH5j9x6f39NHkcoQcLiByVVk5EaMxTO99KChG5o2Wvgrf5Ecp4n168r4uQ/362q3C+HdEwaliXqnOaYPRpfYBpwsh1IEuV+jgJv6aYmXmq5ky/T6qwwc73YaJsCO9gjKRbbnxXsm1+OXJghET8Xhlzor6AbKFuH1jrr5ScboQIaPkvs5rWGuWTYY+gjY6dxdYrz6S+mGkJHX5NOGk7Srop2JAT2z907Txa4ddMwIDsjm0atSBs/NuykjRWbY9Xbk5zWLjCTmgdke826P6vBNuYYtWmO2154cwOdwehEqtfWI0=
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
>   1) whether or not a page had been cleared before initial usage
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
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  virt/kvm/guest_memfd.c | 47 ++++++++++++++----------------------------
>  1 file changed, 15 insertions(+), 32 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 35f94a288e52..cc93c502b5d8 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -421,11 +421,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
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
> @@ -435,13 +430,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
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
> @@ -459,11 +448,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,

While working on HugeTLB support for guest_memfd, I added a test that
tries to map a non-huge-page-aligned gmem.pgoff to a huge-page aligned
gfn.

I understand that config would destroy the performance advantages of
huge pages, but I think the test is necessary since Yan brought up the
use case here [1].

The conclusion in that thread, I believe, was to allow binding of
unaligned GFNs to offsets, but disallow large pages in that case. The
next series for guest_memfd HugeTLB support will include a fix similar
to this [2].

While testing, I hit this WARN_ON with a non-huge-page-aligned
gmem.pgoff.

>  	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));

Do you all think this WARN_ON can be removed?

Also, do you think kvm_gmem_prepare_folio()s interface should perhaps be
changed to take pfn, gfn, nr_pages (PAGE_SIZE pages) and level?

I think taking a folio is kind of awkward since we're not really setting
up the folio, we're setting up something mapping-related for the
folio. Also, kvm_gmem_invalidate() doesn't take folios, which is more
aligned with invalidating mappings rather than something folio-related.

[1] https://lore.kernel.org/all/aA7UXI0NB7oQQrL2@yzhao56-desk.sh.intel.com/
[2] https://github.com/googleprodkernel/linux-cc/commit/371ed9281e0c9ba41cfdc20b48a6c5566f61a7df

>  	index = gfn - slot->base_gfn + slot->gmem.pgoff;
>  	index = ALIGN_DOWN(index, 1 << folio_order(folio));
> -	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
> -	if (!r)
> -		kvm_gmem_mark_prepared(folio);
>  
> -	return r;
> +	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>  }
>  
> 
> [...snip...]
> 

