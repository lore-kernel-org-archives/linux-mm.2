Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E59C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3048C6B009F; Tue,  7 Jul 2026 06:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DBD56B00A0; Tue,  7 Jul 2026 06:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB766B00A1; Tue,  7 Jul 2026 06:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E95E16B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:32:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 69D4E1C7F40
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:32:03 +0000 (UTC)
X-FDA: 84961615326.08.27F8C25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id DF6F91C0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:32:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJQD7ZPp;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783420321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=soT56A/TsitxOPYJdfdItvncnq3Epp2rkiDUFibzwAc=;
	b=wA0hHsjfH3frV9Ssf+HhU4Yj+fCGWyEaOFvQmx3LmTfWw0ELUsitEQNC6We+UYSO/WcTE7
	LkeFJjmv5n2EiPLmLBdGcPUbxJqjhcX8hKYNWnOtAzFaxI1C0w+LIkmOKbVhZuT/qrGw3k
	Hh0MuIXrLFPFl2iyS8nXA09jna5Bqbw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783420321;
	b=Of1Y1lhTruYcvvvXXEFfiN4dIPI3+MmC0gQWjBkuVq7jAV09QcXaMAyO5YmUHCcOPLb6Zg
	3EQBASNien6KXyo/W3pGKp3j79fbhFFJS06PDIPTwgPaAEwvfAKkV4ni3+A2ww6c5nuwtg
	3qe6TXXBwmkuSVDyvzyD0yorpbcWTus=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJQD7ZPp;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48D5C618A6;
	Tue,  7 Jul 2026 10:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76161F000E9;
	Tue,  7 Jul 2026 10:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783420321;
	bh=soT56A/TsitxOPYJdfdItvncnq3Epp2rkiDUFibzwAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CJQD7ZPpnY0LATwFP4HY6e99mGG6GCfwtV8prggnPIqZJoBT7sw1qkGBcMUymGabb
	 thMKdB37j3Mngsn9NR0xZM3ngVTkWAKFGJ1phdZyrmdRqTmT//SItbTSX5gLMuvCGh
	 h03dHdDBVKfa160LAt0yaBWio5lu77qjq0yudAYfiJObv5RjqQLRDbmptoyC6hGNHW
	 E8y81BbE7fqCE9Ns7/a0r4BVgl44yGmApnpjPyV6g+rojpwE7+I26L2qbh+RXETO8y
	 +yjDFpLtM0uRECmpnCPEvJUaccNc37yoAjGG17lTCIWiiaHTnl5i2XvNsouOomVvyo
	 X9ITIQzR+3YOQ==
Date: Tue, 7 Jul 2026 11:31:37 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 22/30] mm/vma: move __install_special_mapping() to vma.c
Message-ID: <akzTj7Xv8kiUU2-w@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <b3254231831037ca3e9757e3e05c90072e04a6aa.1782735110.git.ljs@kernel.org>
 <akZJjNic8u0pDxgD@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZJjNic8u0pDxgD@pedro-suse.lan>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF6F91C0005
X-Stat-Signature: s6ra6k7oi5xx9zy3n9kqn9no3yfsqni8
X-HE-Tag: 1783420321-410308
X-HE-Meta: U2FsdGVkX1/MilHrf09aYmGg6lBdI3woFIJdxCEn6DojmiY3+A5Ha+w5nXb7EB8muspjx4vHfD7YdIKYsJzMYti8HkUL6trUhx6V22e5MxuU1dBWX2Q1GPA9wadGJ7uBbSP5gK+WLrfbKHhlLAbpiO/dODuzhey1C0GmlJ1aP+mRwUMZ9f/YHcZ1MV4tsQcX5x6cHYRqvobjP4Ku0RsVOwvJyZRFxLCBCVylHaMxmrTH7gEIHj/hp3DUhFjTdaAWW1SdtKrPQoogPSFWnspMnu2Qobd1Mj9XUSKJ8KrnAMyXTULtpzKBfgpYsX/9397/7jKLoYlnAxB4XrAE9j1OpNWcnDocS6pdeG53asQG6K6hpGRiGICCduH4077rvZ5ihXgzZirKivfVIGkqzBemOHthr/HvqYecYKDYiqkwT05i0imyvCTdfIJR2LaR+H+Vnd8kCaz/FPYfjulYb/nuo60Ubh39x+AfQCTB1tpnQMBvD854lozaZ6FhysCZ0UXZjB/RLQXjE/tXcdGx70y+VvqQ9hspJxKj5jJy8JmtehYntCDtrF/lYNXWecRbHa5of15JYpEufhOnctOC+o2ZDybzZumdLFvj5I7WY03Zitd8s/Tx3OlwZ3H4RXVbtcOg9ziUmB+FJhRA+JgcqQmNcPbsOBcZBQoicmFgtb+Tcd8KZ+avgMQOCSvFxUd7mtr/oz/JmwWTCe/H/f4ynDEYLt40jcK+rq96o7ou85/Hx6Gy5N/gSr7qrG11f3I8fvJ/2/Ce44I4oY2k3sdPBEb1lDjJOoyr2tHr5UPhsKdjq0AeOf/rZgv24ujoHvQP6nhgqurdT3gzze72QeEHb+aKffplXIlCnvHSpRt4vU8ewQBQhQTcYno4bLSs8ar8OIHn5TLuyh4sg8HJjxzwXmN+Dkg92Fb5yuL3jYSK6FeP5p45rHC67es/HGiQbV9NN9wMRWqJpqzJiWa1c57NNlU
 unHWrPAL
 KkTtsXgqgtN6ngmeh8rjO3+GTKg7cJJYBkMN2MTvZSCub+w4sS0zJkMCoX33LNedv7LlHWBiJ5Ri/ZhxI3bUeR/qSpiReFhgz8DPpHTvL2jbobmN/TqVYwTpgm/CfQP+Wz+rcAdeGD3nyNzPycM7awgseSTzVT0AlJ4KIKzECtKNbVU0LjMj3HXUNXXyMLuIOT5x9DwI/1UFFvtpWQrv0+aAiMAMmnns9j7BsiflmCQ5GnvA2yWjgxholz4WjzNo09+zPsq8Po5DaEJJzz+WzS+063O5WXGRxm55ZmAiH6n2ec6EqKSDSMVe3j4pGBPN5cGpAKbD/N/xi3m4l/X8VUwLlLhNmR3ZWso2TuJIb5pyNIFf5pwHbnyHgoWI/ANopwXi8dPx5BHXN/YwFCFOk/wztb2KlMlE2XEH32MObYwqF5GkeFOKqmTe5gGjeWoREE6eznqN1uEcFGIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 12:22:56PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:33PM +0100, Lorenzo Stoakes wrote:
> > This function is operating on VMAs and rightly belongs in vma.c, where it
> > can be subject to VMA userland testing and allows us to isolate it from the
> > rest of mm.
> >
> > The _install_special_mapping() function will remain in mmap.c as a wrapper,
> > since this is used by architecture-specific code.
> >
> > Doing so allows us to isolate more functions in vma.c for the same reasons.
> >
> > This forms part of work to allow for tracking MAP_PRIVATE file-backed
> > mappings by their anonymous virtual page offset, as doing so allows us to
> > isolate and keep code that interacts with this together.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  mm/mmap.c | 38 --------------------------------------
> >  mm/vma.c  | 38 ++++++++++++++++++++++++++++++++++++++
> >  mm/vma.h  |  5 +++++
> >  3 files changed, 43 insertions(+), 38 deletions(-)
> >
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 2d09a57e3620..46174e706bbe 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1447,44 +1447,6 @@ static vm_fault_t special_mapping_fault(struct vm_fault *vmf)
> >  	return VM_FAULT_SIGBUS;
> >  }
> >
> > -static struct vm_area_struct *__install_special_mapping(
> > -	struct mm_struct *mm,
> > -	unsigned long addr, unsigned long len,
> > -	vm_flags_t vm_flags, void *priv,
> > -	const struct vm_operations_struct *ops)
> > -{
> > -	int ret;
> > -	struct vm_area_struct *vma;
> > -
> > -	vma = vm_area_alloc(mm);
> > -	if (unlikely(vma == NULL))
> > -		return ERR_PTR(-ENOMEM);
> > -
> > -	vma_set_range(vma, addr, addr + len, 0);
> > -	vm_flags |= mm->def_flags | VM_DONTEXPAND;
> > -	if (pgtable_supports_soft_dirty())
> > -		vm_flags |= VM_SOFTDIRTY;
> > -	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
> > -	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> > -
> > -	vma->vm_ops = ops;
> > -	vma->vm_private_data = priv;
> > -
> > -	ret = insert_vm_struct(mm, vma);
> > -	if (ret)
> > -		goto out;
> > -
> > -	vm_stat_account(mm, vma->vm_flags, len >> PAGE_SHIFT);
> > -
> > -	perf_event_mmap(vma);
> > -
> > -	return vma;
> > -
> > -out:
> > -	vm_area_free(vma);
> > -	return ERR_PTR(ret);
> > -}
> > -
> >  bool vma_is_special_mapping(const struct vm_area_struct *vma,
> >  	const struct vm_special_mapping *sm)
> >  {
> > diff --git a/mm/vma.c b/mm/vma.c
> > index cb7222e20c93..f4de706a2728 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -3399,3 +3399,41 @@ __weak unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
> >  {
> >  	return vma_kernel_pagesize(vma);
> >  }
> > +
> > +struct vm_area_struct *__install_special_mapping(
> > +	struct mm_struct *mm,
> > +	unsigned long addr, unsigned long len,
> > +	vm_flags_t vm_flags, void *priv,
> > +	const struct vm_operations_struct *ops)
> > +{
> > +	int ret;
> > +	struct vm_area_struct *vma;
> > +
> > +	vma = vm_area_alloc(mm);
> > +	if (unlikely(vma == NULL))
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	vma_set_range(vma, addr, addr + len, 0);
> > +	vm_flags |= mm->def_flags | VM_DONTEXPAND;
> > +	if (pgtable_supports_soft_dirty())
> > +		vm_flags |= VM_SOFTDIRTY;
> > +	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
> > +	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> > +
> > +	vma->vm_ops = ops;
> > +	vma->vm_private_data = priv;
> > +
> > +	ret = insert_vm_struct(mm, vma);
> > +	if (ret)
> > +		goto out;
> > +
> > +	vm_stat_account(mm, vma->vm_flags, len >> PAGE_SHIFT);
> > +
> > +	perf_event_mmap(vma);
> > +
> > +	return vma;
> > +
> > +out:
> > +	vm_area_free(vma);
> > +	return ERR_PTR(ret);
> > +}
> > diff --git a/mm/vma.h b/mm/vma.h
> > index 47fe35e5307e..14f026bf3be4 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -775,4 +775,9 @@ static inline bool map_deny_write_exec(const vma_flags_t *old,
> >  }
> >  #endif
> >
> > +struct vm_area_struct *__install_special_mapping(struct mm_struct *mm,
> > +		unsigned long addr, unsigned long len,
> > +		vm_flags_t vm_flags, void *priv,
> > +		const struct vm_operations_struct *ops);
> > +
> >  #endif	/* __MM_VMA_H */
>
> I'm really annoyed that _install_special_mapping has a leading underscore.
> That's it.

Yeah it's horrible :)

>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

>
> --
> Pedro

Cheers, Lorenzo

