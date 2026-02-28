Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2107CFEE4F0
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 12:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53DDE6B0005; Sat, 28 Feb 2026 07:44:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518816B0088; Sat, 28 Feb 2026 07:44:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41AB36B0089; Sat, 28 Feb 2026 07:44:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F90D6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:44:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C49271C003
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 12:44:31 +0000 (UTC)
X-FDA: 84493833942.06.8B04779
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 140DC1C000D
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 12:44:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wdbLMqVI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3LOOiaQkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3LOOiaQkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772282670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RH0L9WD4/u9mQiuU+Jc2bLYt2zoxsRLi5sNyM2YzgMo=;
	b=baB6zsef9mWxag60W6z1BIPSIwk4LlOG1YBJkkhtneivlZq3n5JYjZhmm8FYjE4XqxSH1w
	Ky7V2rCZbhFr48S2ZH0ZzhY6SxBq0kpEpmxg22Smj/ra06+okdif2sI4AmaQ6iU62Pz8wF
	KMhHUiT+sPhik2s0QSbJs89AIQGK9zM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wdbLMqVI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3LOOiaQkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3LOOiaQkKCNEx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772282670; a=rsa-sha256;
	cv=none;
	b=LWR6kMGaLb5J7ylIRxyvxu8WE1bH0ZfwpM16NeWqmNNj9w8g9ryxqxXg8o2lkyociu3W/g
	sNHXQqcxEIHrUuUiP7Pv7E8Zola8//I/2JTcj8Po1P7YkP8iaQuzo0P4vf1fCgAki2S/KS
	6BwL0tkiqOzIo2VCw85mXK0Iu41cWvA=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837c597cd5so16662235e9.3
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 04:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772282668; x=1772887468; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RH0L9WD4/u9mQiuU+Jc2bLYt2zoxsRLi5sNyM2YzgMo=;
        b=wdbLMqVIXdloq5GwU4MqdjeaaCwS+YRpQmSzSzr5T0rYSRulViuUx/8iWzuz17u0m5
         Lei0yWvfYJDFzC7HwkcCnl04OnSSxa77p6hu9xUXJ3+vJbljpr2sXx2lCmxEi+9z5D3K
         uWC3KdFU3TPM5E+1U/fW9Lr2r3fa3Alf9ykIjhdZ3LZAa8Nc0hXtg2DRszKM2m/YXtn2
         jFkO8JILDrmF9mbXao3bnBuvx/coJqAuvYJq0waAd3x7EC1riN4HErVQVFux9Iqb/SRV
         A7d1RebgLhLON1E9R0oSXFKO77JngIF2FHUeuR1XoJFlqzO5nhwPUDi5ZxLW8iI4Fjb2
         Liug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772282668; x=1772887468;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RH0L9WD4/u9mQiuU+Jc2bLYt2zoxsRLi5sNyM2YzgMo=;
        b=vK1O2k5J8dh+O0Iu2vRm0vqsuRsB+SGKm7kJyd3EnR4heGt+nVEKZSsclloix6qG6P
         ZzSMtgjFLhJoSDcCdJO2bVbvQ/1fj6g0Ovt4rWG+E94jOjihJnpKq8Z+Lt9ndKZclyIM
         FTJs+OqCa9kPdgFd5tX4JqXMsneMzzVUaH3IG0K7GyiQ8HAe1+3yRVY3bQHbO/cvMiC9
         DHruxmiiFT/T/W75106hXkTjQb7pA9pn3/M5nlnKPJrKQk9LVDGk6hYU80hAbEyNi3eo
         1ossVOPN+Tl8pJYvuNqY1bWAfgJMJXWGXHwewWVeINlCjvMuSARfBOEbZl4xinoWc1Pw
         Sukw==
X-Forwarded-Encrypted: i=1; AJvYcCVW25mLanOJao0+x3zIh+6m+hCp+l7jQwWo5D0zJMIDBSjtP93c1hetaUIs2NgAlb4A9uYZWl7BUw==@kvack.org
X-Gm-Message-State: AOJu0Yyyc2KGObpKNQ803XqGv00TVbo8c3spf00qqc+/dSwIx25mPOLP
	bJg4Q0/ETmTiSo9fFgfs2yHs75Rj+gGzqQg3s3JYC/GY7s6cAIL1zcrD4Jh2kTyYeiE60tjvL07
	pyoMotEe9v4mXXzPyIA==
X-Received: from wmqi19.prod.google.com ([2002:a05:600c:3553:b0:483:6fe1:c054])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fc8:b0:47b:e2a9:2bd7 with SMTP id 5b1f17b1804b1-483c9beaca0mr120569145e9.19.1772282668287;
 Sat, 28 Feb 2026 04:44:28 -0800 (PST)
Date: Sat, 28 Feb 2026 12:44:27 +0000
In-Reply-To: <20260227200848.114019-15-david@kernel.org>
Mime-Version: 1.0
References: <20260227200848.114019-1-david@kernel.org> <20260227200848.114019-15-david@kernel.org>
Message-ID: <aaLjK2Q2q5ghE-uE@google.com>
Subject: Re: [PATCH v1 14/16] mm: rename zap_page_range_single() to zap_vma_range()
From: Alice Ryhl <aliceryhl@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Arve =?utf-8?B?SGrDuG5uZXbDpWc=?=" <arve@android.com>, Todd Kjos <tkjos@android.com>, 
	Christian Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 140DC1C000D
X-Stat-Signature: enenqz1a9hhekdbcgro4okf5rm9k5ro1
X-Rspam-User: 
X-HE-Tag: 1772282669-722347
X-HE-Meta: U2FsdGVkX19xRoNln9QiqWBytD9Hx+HD1B7p/187WV6vEAnc39byTTmwLoeGhisQQ0Y4SLUblDbgifB/gIqStL7cufXSuhXslSPrNSL7fMSbV0LfDiaajZkPBCfrkPbMXs7T5/Q6UGFA2BigAuIEr5TZma8t3FjxTQv7Re8+rylVj1ryZXxyOMAfvs85e+vQ9BN6/3eisKLueJk7IqK80+1U36cO4QoYiAOS0WItdRGchNAbspH6x+9k5Bd5YNbaBNNHIVVA2xckpPQVVWLBky/nPtLBKGZ2SCqbC2zr1HAISLfRoGkcg3AtZ7Y5GZqLO7z5T3WYidB1HN/4UhvH5GFcPJmT8Qs1dLGExX2hzXzztolbC7ZM9g/SOEfnjUUJGmkt5Yy1NPHs9JHdlmooejlOIHnE7GEi8CVkM0OoVAV/gbn4osKEsV/Y9wZ/CEIrz+Z5oJ+VHtjsV81dEMHxYzpd0/Q+MLTIopBnlhbekJ2XziBZUe4KN+yfeHl9gvObtoteawJ5XnH0nPVwEy6/QKF+xoKINnkSxgT/egADExImW2YNbnzY47+q71vs/iphT4zNhXH7Vqf9WTgFIbham3LUSPhSdRR5XFfu8ZOSmxwZJWpJAmO8ZJKz1eub4RUygpS5nwy3RVTNv+zpBRI1fmw+LHvJPLdBvvBjY8fuP9uugzt68PN0xtbGwqVqMROQdb3dYsRz0Yrme4aNpjgpixZ6blrVzghjrB4QTOMqNW09nrv6OuBq65ik43UnQuT46Am60io4VuPqptufPHGcnwMXque9dQOazj7TRoobFHSgRM3IfdsDydU6UYUEAV3Gnm68Guwv0/rGRZHVHnWyRLIuIk7SzNbfPbSOcPw9Pwvz920FP7/IDFkehXWn6i+5+xHAIpxfMiyLDNExH3vZA9pMY7kqnKeysYAczEq4c9EZPImmMDXs5tpk7Jsd8gqmPjop3XCwJif2s74pAQo
 w/m+KWN6
 96YHtEwh76l914MFxw10PlSlJhpliw05lyYWH3P+WR6Y3P2y+Xo1lGj3e+mIlUVGQwdE2oBO5DgnaadhAQ0Keh1tCfiGxNYX+x7iLWPe+xUNUy2b3W0q9/8GpuI+5Qn/7OVIqjztvJT1I18dSZt6lauvFxgyIevZkZ9onzEenlGgNoMFFphDvf8DFAZffM9e2IZfNEYcJJuFjU0J+qc75tGIwOESY31zdpMakRxFc+CFfcsu1j7908PoplVdV8OreWuCA4JnUmrkj7BSK+WEDCzfemjZzDTvDMdHNFNR2MlA4eRPvFen6EnmsBp/+j2PvDI45PebuyeXsET/JVbWrO7XQt79O2zgC0y/gBgbiHXOIrONTd2s9Ss7X8o9iuda4kEqfInOsx9IjSNoPaGa8fyGbdpBlA2uDuBUVQcm2WKIeCoCtfaNkFjQFBlYhjQEewOnnnFAQRo6PwQ1vXsnW/o5IQPoZfneEXUU/QBkSICjZLbSiOaUtPkLDQksaA0XpslCn93e/v8GM9+ZN0/Cjkxl8NDmggl0q4o495JCiSMLs6354wOurOF9GDLJUCdQO7wFiEiBhV2kAmfXPbIxSYxZzjTJ0SvaC5tTSaVIfekj8Kbfznqb05XC6jbDwIEq/T6erPGMlIGX4x/TLbE5qYYlflA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:45PM +0100, David Hildenbrand (Arm) wrote:
> diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
> index fdd97112ef5c..2fddd4ed8d4c 100644
> --- a/drivers/android/binder/page_range.rs
> +++ b/drivers/android/binder/page_range.rs
> @@ -130,7 +130,7 @@ pub(crate) struct ShrinkablePageRange {
>      pid: Pid,
>      /// The mm for the relevant process.
>      mm: ARef<Mm>,
> -    /// Used to synchronize calls to `vm_insert_page` and `zap_page_range_single`.
> +    /// Used to synchronize calls to `vm_insert_page` and `zap_vma_range`.
>      #[pin]
>      mm_lock: Mutex<()>,
>      /// Spinlock protecting changes to pages.
> @@ -719,7 +719,7 @@ fn drop(self: Pin<&mut Self>) {
>  
>      if let Some(vma) = mmap_read.vma_lookup(vma_addr) {
>          let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
> -        vma.zap_page_range_single(user_page_addr, PAGE_SIZE);
> +        vma.zap_vma_range(user_page_addr, PAGE_SIZE);
>      }

LGTM. Be aware that this will have a merge conflict with patches
currently in char-misc-linus that are scheduled to land in an -rc.

> diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> index dd2046bd5cde..e4488ad86a65 100644
> --- a/drivers/android/binder_alloc.c
> +++ b/drivers/android/binder_alloc.c
> @@ -1185,7 +1185,7 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
>  	if (vma) {
>  		trace_binder_unmap_user_start(alloc, index);
>  
> -		zap_page_range_single(vma, page_addr, PAGE_SIZE);
> +		zap_vma_range(vma, page_addr, PAGE_SIZE);
>  
>  		trace_binder_unmap_user_end(alloc, index);

LGTM.

> diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
> index b8e59e4420f3..04b3cc925d67 100644
> --- a/rust/kernel/mm/virt.rs
> +++ b/rust/kernel/mm/virt.rs
> @@ -113,7 +113,7 @@ pub fn end(&self) -> usize {
>      /// kernel goes further in freeing unused page tables, but for the purposes of this operation
>      /// we must only assume that the leaf level is cleared.
>      #[inline]
> -    pub fn zap_page_range_single(&self, address: usize, size: usize) {
> +    pub fn zap_vma_range(&self, address: usize, size: usize) {
>          let (end, did_overflow) = address.overflowing_add(size);
>          if did_overflow || address < self.start() || self.end() < end {
>              // TODO: call WARN_ONCE once Rust version of it is added
> @@ -124,7 +124,7 @@ pub fn zap_page_range_single(&self, address: usize, size: usize) {
>          // sufficient for this method call. This method has no requirements on the vma flags. The
>          // address range is checked to be within the vma.
>          unsafe {
> -            bindings::zap_page_range_single(self.as_ptr(), address, size)
> +            bindings::zap_vma_range(self.as_ptr(), address, size)
>          };
>      }

Same as previous patch: please run rustfmt. It will format on a single
line, like this:

        unsafe { bindings::zap_vma_range(self.as_ptr(), address, size) };

with the above change applied:

Acked-by: Alice Ryhl <aliceryhl@google.com> # Rust and Binder

Alice

