Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6366CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 12:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F48F8E0010; Fri,  7 Nov 2025 07:12:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CBC68E0002; Fri,  7 Nov 2025 07:12:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB1E8E0010; Fri,  7 Nov 2025 07:12:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA0308E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:12:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E209160469
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:12:48 +0000 (UTC)
X-FDA: 84083699616.10.76E288D
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9EF1EC0014
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:12:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3VCIaY06;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3PeINaQkKCIgmxuoq3Atxs00sxq.o0yxuz69-yyw7mow.03s@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3PeINaQkKCIgmxuoq3Atxs00sxq.o0yxuz69-yyw7mow.03s@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762517566; a=rsa-sha256;
	cv=none;
	b=2bsfjNNMV6A0kDFTncJlFnJRQ/sm/dduh0/zc3uaNltTqTUmhJnBIzwKKZJU1jYyxqd8g1
	EHJou3wE8YX5wou/Zk41ZgvIF3Pv4nYZSGU8UHtILYBdz6EgWrmOCBgTjl7CUhbWCLhaNU
	W0EDFVBSsyZZUbwU2IyJWCL92QGwizw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3VCIaY06;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3PeINaQkKCIgmxuoq3Atxs00sxq.o0yxuz69-yyw7mow.03s@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3PeINaQkKCIgmxuoq3Atxs00sxq.o0yxuz69-yyw7mow.03s@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762517566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jiMZz3p9r1cXUEtJOvXENsRsqsu1S4GTx2JzdMxXhCI=;
	b=FUp3bJKJrgtp13btIJuBcHlg9yuFlBYQgPZ/gwsRXLKSWjrv3VqLIdRRKr2q9raCSI35HW
	7Es4gsmAJ90v65s4lMML7b/EL6urOP9warfsV52wADsHUvbSGzEaaDE4xUP40fLfkLciTn
	0OTzal1YSuJFonPqXESwBmEwiFB/B2Q=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b70b1778687so61215166b.0
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 04:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762517565; x=1763122365; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jiMZz3p9r1cXUEtJOvXENsRsqsu1S4GTx2JzdMxXhCI=;
        b=3VCIaY06Uh82aqo4RhUx8TRQ8GXsWeRYq0u+Kg7jXhE0FVZtaYKqUjqpSuj4uWTujX
         iOHCjlu5lUe0XngNvb0xuAqnu9IPsiYAv/5hrhgOH21VMmDOqhwCjzC1hb9zlFwfuvSu
         2rUp6KdrLnfXS4+o9t1TC8lz5BQaBlPCVd0ay3Wvr+q46wiXafkdqOwO0DdzXuUyFxv3
         NdifB5SL0dJXfeVsXaXWTIwA6FY0m3USs+pShMOix5CuGVIIHvjCxzkcYdWPKGRtWjkP
         7siimnYiUa7BTgD71AIa3OrHoUGoM4KAhYWgGPch1hIcQjMAPtlgX85f/+p3zIi5+swO
         dHpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762517565; x=1763122365;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jiMZz3p9r1cXUEtJOvXENsRsqsu1S4GTx2JzdMxXhCI=;
        b=QER7Ben45OxjifbJ+MSiQ5RrDIGwvwciVjkfTbmzzwQGkLB0c8Hw/bIVLI4kwyZrs+
         1Y8DL3FjTNkL/WGNaY+g5ycxQaSX3vN1vTT9AoH8KPUHn2ivxn1HTq56kXEkBV1rQL5H
         nwyrm1mzoyMbY7iytrCSpS4J2dPY6mC3KOZZNO0kyuipUR4rUYznJnPn20yqnH24cIMn
         YXVsTNZiIGbA+mD0UojF5Qwi7N3KfXT+VJXBFl8e74JTaxCwQKAA0rs0HOCBDz5a2f6u
         8o4JX2QyrdaPZqSz66NBZqUaT3lh2R7EgYlw1Qzjrer6ENJzf5Bv3oaePGzZ9YqeWHSS
         hHlA==
X-Forwarded-Encrypted: i=1; AJvYcCVGF2Ug4ofSeecPq9wgSB1gHD0lwf1aSMp+MKgDTwRlfr6i3ybH6QQztui3PIawE0hbHNlCX9rsog==@kvack.org
X-Gm-Message-State: AOJu0YxHqrFw3tqb8aCR06VkCpiOjoe/8pCIyqSxH/XBq/4ZNJJ5EZQJ
	0NaSgr1PKPySIkta1BM9370KqONxsH7m6JvHbImeowVry/HQhxNPS8iT4n3fpfnerITpEYJvD68
	dJc2K174YmIyy5yC3uw==
X-Google-Smtp-Source: AGHT+IFz1d7JwOnWSoe0fVf8qRe2tAmBflmhL4Mg+i45pACLer1ETGlr4r2lHbYGUH0n6LT169uz4zsABZFzda8=
X-Received: from ejdaz21.prod.google.com ([2002:a17:906:8f15:b0:b72:5aa5:2d0b])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6d16:b0:b6d:7e04:7a24 with SMTP id a640c23a62f3a-b72c0ac01aemr279299066b.36.1762517565061;
 Fri, 07 Nov 2025 04:12:45 -0800 (PST)
Date: Fri, 7 Nov 2025 12:12:43 +0000
In-Reply-To: <0f7186b3-16bd-44b7-a3fe-637af9d25dd3@lucifer.local>
Mime-Version: 1.0
References: <cover.1762422915.git.lorenzo.stoakes@oracle.com>
 <fe38b1a43364f72d1ce7a6217e53a33c9c0bb0c5.1762422915.git.lorenzo.stoakes@oracle.com>
 <yja2mhwa4bzatbthjjq5rolqlkfgcbmppic3caaiwi6jc63rbc@cims6rqnotvj>
 <043dcbdb-e069-46e7-8f79-8fdaf354fb44@lucifer.local> <aQ24HAAxYLhIvV5U@google.com>
 <0f7186b3-16bd-44b7-a3fe-637af9d25dd3@lucifer.local>
Message-ID: <aQ3iO40QYEM6Dxfs@google.com>
Subject: Re: [PATCH v2 1/5] mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps
From: Alice Ryhl <aliceryhl@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Jann Horn <jannh@google.com>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Andrei Vagin <avagin@gmail.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9EF1EC0014
X-Stat-Signature: 1ktc5zoxobseiyuc3oz6bxnyjmnqrhy3
X-HE-Tag: 1762517566-623070
X-HE-Meta: U2FsdGVkX19nayI+lzSqy+s5QYQazamNFXbdT5besaCxPquGlxlpK6aVCgcFNrwhC/BpdrBwVazPNjeyVt/tE/5K3tmb6KT+qnh86FnYUI7+Z+/jSzmBxlXems1fGXg72UVK8AzguZH5XcD4FbYYip2pfFcJ3xKbkedsxHhqf6z10dhJ2oLvnRSOkZ190HT5omMbA1txKtMK60C7FDGGdqi+mD+DFHzLGdFW0Oi9MENaYgtgUR0EZU3cN1018jAXD1Wc094oqbCk7dpNeVDibcGrrUb9bHqMfAcRH6FrivrzwKS/dp7jfAxqrppAYucOfymZQQO+dyJVuujAr43TEMqzFG37/M2ASKS2mLacrPBi8XB/oYxA6SX+YnjNN29lP5GwH+7cOP+KtE3HF3tSOfYULRY/yE8KqFCqrxN+Kde18xJUrdX32NV1JSnPVaoK1Yvypig7F6GYI6NFlQ/ip8q7sttmblnVReCX11B4IYMSHp3l7q08BmPfwcAwHazKXlZs/98kZBms7xe1UquIGQsgFeKMmUKKfCn8Ye+zVAgg6+3m8Q0qCOTKPeYQZZtWp/Fay9UBqjJUOftmT++xG23k9qjumyeSeQWHUYckIyRgIShWfMoURVUHHpdvt0jkBJuLwYWyMBVmD8prVOMDGtPLEZcWUy0Hh++4ICw/nb8yvc8VMzCq8NprbiYT5AmlLwO/NvqkSr6uNjmgAUMoUMN14MPA9CRgHX9B+f59Sjit8JRiEjuXhbEV2vW5jxlAaqhxH5yCaYgkMR3Au2LvgUPCZFXHYe0c8v+1XQDUCwG2MAhxJYpDpQcj53ZmUlgQclxx7tuACejE+ImiPbhCe6erjj2vqKxOtBXzlAWhZat8bh6f/D2KxmBhANvIrs4Uv9cjYl1sAawTP3AdDgMaAu/d88vAVvgYSIxe9NIFgoL/F0D1eeSUvO8cj73PV6duw5JFdL+AcaWT7qA9jxr
 DktHrPrv
 q169bvBNWUfaOmeoq4bpLMc8x+Qbs7OtjRjb0iGGJEVGTvdftns56OJJnzuoIkoTbt1mW65JrEKnX261gXk9YPwG9qJcKtVuxdlY9rkiiqsGvgpJqY7KlWOcMTuOioGreQctYpskPoyVXGFTTMuFT067kIk1bcBWYJDrj6lQ7E1swVjiOLCiOe4YLNSj574B0eyXOzM9BQIxZUxuF9wcB1az5MK+3LVv3GtImSeJ5JCf1Be/Qtq8kDOds7bUBlTLVKPYeJFOFqPO0hwrr87MKzjBk1I2WN1yr8imdQzrcKUGO8/bwdiYartY7M0TIRN5bJJDmKuuBCn343jfHQCuHS67ssxqUJcRaJKkUYAnCQoXrrAGt4yDSmLYUZAdJXjlxTxFUXHsgFxiGpGcxfrf/4kycL3JrMomgMIeJBg9vhqmRV/aZn1RRgBYnLH7VN1tARCwQbvZczOft+tGoKsy7+rKKCP0KIYdqpN3kc0vI8YaUTxQbsrAq4CdY24d+e/IGBZqvmRhpOYx6Sqjcu1BZKAhdm+OzqLQI6okSpDeNBgRnLKYLA6inFVjUWGjGxFszBYEIPX3wDMFh1bOcHI5WpVCxJOrZvi05V70dwN/b4DqXbd9z1ktW8o18JOZi/BprujXLsdS+0EjVlfDs+JCVoZdGOizddAgLu6gkmQsbVaErgOumCjrOtvZG9mKcHXMB/BSd7nvwMR0D9u8vCe2Oq8NWl/vq5BDTd/4m8bDJS+7sQD9XIO17lBZhayX1ttFyl9kNxfNC0hj6ZbFZ/n9vUvnA2r23f6+E6PMcrITeUEPEcPOZybK42/PcJDCMXNKFo4u7FKuaSu3YIiCazmLcIIREZXL5ynZKmJZud/8RhYX/CeI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 09:44:22AM +0000, Lorenzo Stoakes wrote:
> On Fri, Nov 07, 2025 at 09:13:00AM +0000, Alice Ryhl wrote:
> > On Thu, Nov 06, 2025 at 02:54:33PM +0000, Lorenzo Stoakes wrote:
> > > +cc Alice for rust stuff
> > >
> > > On Thu, Nov 06, 2025 at 02:27:56PM +0000, Pedro Falcato wrote:
> > > > On Thu, Nov 06, 2025 at 10:46:12AM +0000, Lorenzo Stoakes wrote:
> > > > >  /*
> > > > >   * vm_flags in vm_area_struct, see mm_types.h.
> > > > >   * When changing, update also include/trace/events/mmflags.h
> > > > > @@ -296,6 +298,7 @@ extern unsigned int kobjsize(const void *objp);
> > > > >  #define VM_UFFD_MISSING	0
> > > > >  #endif /* CONFIG_MMU */
> > > > >  #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
> > > > > +#define VM_MAYBE_GUARD	BIT(VM_MAYBE_GUARD_BIT)	/* The VMA maybe contains guard regions. */
> > > >
> > > > Don't we also need an adjustment on the rust side for this BIT()? Like we
> > > > for f04aad36a07c ("mm/ksm: fix flag-dropping behavior in ksm_madvise").
> > >
> > > That's a bit unhelpful if rust can't cope with extremely basic assignments like
> > > that and we just have to know to add helpers :/
> > >
> > > We do BIT() stuff for e.g. VM_HIGH_ARCH_n, VM_UFFD_MINOR_BIT,
> > > VM_ALLOW_ANY_UNCACHED_BIT, VM_DROPPABLE_BIT and VM_SEALED_BIT too and no such
> > > helpers there, So not sure if this is required?
> > >
> > > Alice - why is it these 'non-trivial' defines were fine but VM_MERGEABLE was
> > > problematic? That seems strange.
> > >
> > > I see [0], so let me build rust here and see if it moans, if it moans I'll add
> > > it.
> > >
> > > [0]:https://lore.kernel.org/oe-kbuild-all/CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com/
> >
> > When you use #define to declare a constant whose right-hand-side
> > contains a function-like macro such as BIT(), bindgen does not define a
> > Rust version of that constant. However, VM_MAYBE_GUARD is not referenced
> > in Rust anywhere, so that isn't a problem.
> >
> > It was a problem with VM_MERGEABLE because rust/kernel/mm/virt.rs
> > references it.
> >
> > Note that it's only the combination of #define and function-like macro
> > that triggers this condition. If the constant is defined using another
> > mechanism such as enum {}, then bindgen will generate the constant no
> > matter how complex the right-hand-side is. The problem is that bindgen
> > can't tell whether a #define is just a constant or not.
> 
> Thanks, I guess we can update as we go as rust needs. Or I can do a big update
> as part of my VMA flag series respin?

Whenever you think is a good time works for me.

I think it would be nice to move those constants so they use enum {}
instead of #define at some point.

Alice

