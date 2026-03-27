Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3F1010BA435
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28F16B00B6; Fri, 27 Mar 2026 04:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00726B00B7; Fri, 27 Mar 2026 04:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D076B00B8; Fri, 27 Mar 2026 04:00:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D257A6B00B6
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:00:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99C46C51D0
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:00:32 +0000 (UTC)
X-FDA: 84591095904.24.F398B9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D5C424000D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:00:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="AMzp/MVP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774598430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCvKiGQQGgNb+W8jpSb1OQfHQ6uPzFJnDIdt+xnmXLA=;
	b=qep/Mc1GFvEf3RZ7qUnAoww+KnHpIiXBlYsi+S8gu0/rAZ03hMNIIDpSGrdaBekmNZLF7L
	mCDfMVzOD31W8AHKIw9RTgJ4N3CzSKcYSM41l4BFcVgXHM/rj1WRaSvci3+Q0ek8YyNH8L
	z3NbJErVOY5t4O5j/mgOiA3zNDeY9Uw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774598430; a=rsa-sha256;
	cv=none;
	b=eUDsMvLiLfFOeQlXoGXQGHFQ3Vhi+1d7z0+eHtOW3btbJRzF5KhMmJh/W1M0SaSfN+LoBB
	YYyGrSOa/X1yJQpdBU+Vxb7e9C3Zidxn8NPW3+xK9EX0qlByu8O2P8Yo7lY7fLzUoatVdM
	2BvbPEI/BgV2sSUEnJWCPgZppKpYf7A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="AMzp/MVP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 37B1760133;
	Fri, 27 Mar 2026 08:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817F2C19423;
	Fri, 27 Mar 2026 08:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774598429;
	bh=UwiT4eozaNGhaqFAauKAmgowg7gYec1LshvaOOfoH98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AMzp/MVPmPrMezJQOn1mDo5LbPa0YLeYE9UEXhRtDjY761/eB6HLSdUWo0k4iudr2
	 THtMHRLbROmmOI9KZrwzdmsJ6gh7yTMDPscEk/RomiGW8sOv93Er7o6APa6N/E0DRq
	 t2i/tWzBCaBv/NGniY6Wi5Lh13A3njCwJIxTSvU3bMFDQtinLe9H3pIUbOuoEGYrsw
	 l/o5a82T9A1KUIklrp6f2umrcYamik9UYi6skrdYy0rfIH2LR0QH3EbqgR1Ryqx3ib
	 RBfCEdSdBhnzq0K4STJ1DRkIn67MSohEnbSIOigrsd53k4/yf2+jKNKrEfrLBL2yiE
	 N0m1ObfRtkHWA==
Date: Fri, 27 Mar 2026 17:00:27 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
	linux@roeck-us.net, andy.shevchenko@gmail.com, hch@lst.de,
	Jeff.kirsher@gmail.com, Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
Message-ID: <acY5G-lKZQEsUbRw@hyeyoo>
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
 <acYlxRBhSMcwBnja@hyeyoo>
 <CABXGCsMTk6kDuJxsTAUKP6npTvp4X6Ryng+P4xjMUsPbTA43+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABXGCsMTk6kDuJxsTAUKP6npTvp4X6Ryng+P4xjMUsPbTA43+Q@mail.gmail.com>
X-Rspamd-Queue-Id: D5C424000D
X-Stat-Signature: 668gh7pe4zfedob79gs848npdthpkxzk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774598430-890742
X-HE-Meta: U2FsdGVkX1/mmVB0jV2dC49IFSD5E0KJVAyGJT9B5GJDvMzTKyoIaLJRFl49djpTb54lFex/zuikqheFXhLtK1b5sszLsTgNgFio9P5qWxwtlzD4Rh9WhzqiM8A7W+jj7DlE29q3BJAsj1Ga+dyH6zUfH5cUUn50AbyMRnvL1uX/7p6R33w223DQTvWXzlOW1U7B6ZEWsaXcTxQGnqXbq4uKeFGUD5iuwfW9R6iLcWpM2bvrrMFBDgkl3IHJwqdJn1tRDzx8KAhRCHS5B/lbPc3/XjewqMQ5fGGu56XUnCx/fa6KRz5EKSuh/gexs6V+dQqG50JSUZIDkFT96ubjoJbkMPrFcp100zhmfuuYv9HlAvW+3iIJa3Xrulg71ZcftJXixOLhqsDT9aYbvgY2Cp44GMnlFaZW80jhjr7u6qdMMRlIaYOhyqjsNb6jusgOEbyAdw0WUVAt8YO3Aw5NLD1mOM9BvznV5gWpohGlY8OE1ZHtlsNJOOviXRzC/CiQ2iiJ6olbMQ4qAZ6bfQ3MfpRP7Of9gPssEM5zW2hNgsjCTp9INfU5n9Xwl57DoZWNsn5oSkBsk5c2nFlkmrurMfRp3gcvsYSwlOrDhZOYBdqnNP9/m5RfR3Z031yQ/U1mm7sOu3wJJ88Fgf9ZZrWsiqKOIkllRHunGHno1V+ygz6sKT1p/0f/LsLeYh7yzmE7ojUzIK66mFMsXmc5Tkn96XF8UmGKUCfpassBUrh/X8yqiUm8rDa9moYHCO7MvnrVHGPkRyJnTgiMZKfZoDGHanlSUpKq4hfNsVYSnWeWcKGpCVXklTB0BuR9Aa/Bo2Wogy20jiZg6kxUcHSk2strWE6OyNuVykpBRlGwovz6hklVF6X+c+jGn7e4BUz27U/io7Knzb1uuSJdJohQ8ODEWm+Yb8/4MP4wJXACM/g6epvufIPfXFGXO+rY/h3FbnPdtTEf0oZ+IQuuQG6PdKz
 Z4z0xdsS
 z0bH0dr6ybBPYRQRPAPoECddpK9WXM2HRoX2GrqM+H9zz39+hRRUYtCNwMdmVQGXElm1n87XQLUiMhtcTnJ11iYz1AqJI/ay4Axe/FeLRiYEIFIatqPYep+y/iBddMy2xEF9uoCSmELqyrIGHpQweumTkDwrCTiXXKL7GqupzCkZkhKZDDP8iFiyKwuz1gp8U7DEXSIEfOG/76N0OyVLyGfFyqIro3+kTRnviKe6uJpVlE1YkX6xl+FPnJbx69lA/GMJhYXsQ9+BkKL8sdTPtFtuRnyvxymhJFDayKdg6PDFrd+6Typ4CEzgbF4LAPQzdbSqKxNKo8LSuD8mhjR5Uop2045ggCdOnBufNO0bQ1QgAS9pqh9x4vUXo4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 11:50:07AM +0500, Mikhail Gavrilov wrote:
> On Fri, Mar 27, 2026 at 11:38 AM Harry Yoo (Oracle) <harry@kernel.org> wrote:
> >
> > On Fri, Mar 27, 2026 at 10:58:46AM +0500, Mikhail Gavrilov wrote:
> > > When CONFIG_DMA_API_DEBUG is enabled, the DMA debug infrastructure
> > > tracks active mappings per cacheline and warns if two different DMA
> > > mappings share the same cacheline ("cacheline tracking EEXIST,
> > > overlapping mappings aren't supported").
> > >
> > > On x86_64, ARCH_KMALLOC_MINALIGN defaults to 8, so small kmalloc
> > > allocations (e.g. the 8-byte hub->buffer and hub->status in the USB
> > > hub driver) frequently land in the same 64-byte cacheline.  When both
> > > are DMA-mapped, this triggers a false positive warning.
> >
> > Is it feasible to suppress the warning if dma_get_cache_alignment() is
> > smaller than L1_CACHE_BYTES?
> 
> Hi Harry,

Hi Mikhail,

Please keep in mind that I have limited understanding of DMA API,
but just wanted to double check if there is (or isn't) a sane way to
fix it on dma-debug side.

> Good question. I considered the dma-debug side, but the issue is
> that the cacheline overlap check in add_dma_entry() is intentionally
> strict -- it catches real bugs on non-coherent architectures where
> two DMA buffers sharing a cacheline can corrupt data.

But dma_get_cache_alignment() < L1_CACHE_BYTES means the architecture
actually allows overlapping cachelines, no?

A non-coherent architecture where two DMA buffers sharing a cacheline
could corrupt data should define ARCH_DMA_MINALIGN >= L1_CACHE_BYTES.

I'm not sure what kind of a real bug this will hide,
or am I missing something?

> Alan Stern discussed this in the bugzilla [1] and concluded that
> the slab alignment approach "seems reasonable" [2],

As long as there's no good alternative way to fix, yeah.

> noting that turning on debugging should not affect the way the kernel
> behaves -- otherwise what you're debugging isn't the same as what normally
> happens.

Yeah, this is why I'm trying to double check if there's no feasible
alternative.

> But given the way the DMA API debugging is set up, I don't
> see any alternative."

I'm trying to say adding the (dma_get_cache_alignment() <
L1_CACHE_BYTES) check might be considered as an alternative ;)
 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=215740#c31
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=215740#c44

-- 
Cheers,
Harry / Hyeonggon

