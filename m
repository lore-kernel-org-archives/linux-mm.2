Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98312C44500
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766386B009D; Tue,  7 Jul 2026 06:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7173A6B009E; Tue,  7 Jul 2026 06:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D156B009F; Tue,  7 Jul 2026 06:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 359F66B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:47:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5BC41C7F4C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:47:42 +0000 (UTC)
X-FDA: 84961654764.29.7F7DA50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1025F100007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:47:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nAwcbqQZ;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783421261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LLhzkk/JgHcYgAhLZKjLeN62LByel6fmISiRV1ITuB4=;
	b=v8xx4pRTbffq1vOdhiTsFgDcA7WkZ2jdFMqEFBomYJ8NSr5Bax7vjcGRug0M4uB7FYFRjy
	2QCFPIsw3faqi//pGoNjZmxYa0aRWVsPCb/qHQLyKgQU21/Px5uuGgcJjbNs8nmPQXFtnH
	X22AMHzKsqhSKYfoJXRFBrS4XkOWwH4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nAwcbqQZ;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783421261;
	b=anzJesU7caXsowA2lzDXfOyqv/QHmT4220Pw2CVE2UP+cTJJ5OGSClvgG1WiF1kmNELJOF
	EzZMG7/lFVYXs4/CaWeIrxapLXeKo/Ky4RHpvVGMDcnPEdlOOadCKPlgIcJcJuvVUv7CSY
	Vk+pd10p96MHqpRhTGo8Nwn92BYMat0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4330C40715;
	Tue,  7 Jul 2026 10:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA301F000E9;
	Tue,  7 Jul 2026 10:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783421260;
	bh=LLhzkk/JgHcYgAhLZKjLeN62LByel6fmISiRV1ITuB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nAwcbqQZ6EYWFhU6Pa79F4DwZWj+s50w7KhSPUgAeSGSsvopOpj4c3CR6Dc4BvSKY
	 UI/T4Y1V/RDDoyeFB8sXD2vSc8XMgX7PuHapXBY0cr7IWraSANQSAw1tuqycqvya7H
	 EOLCy/nYmsu9fsBZZUMJw29VxKcXmmkS6wgUhpYDSoopqSIeazhcGwCvu+qGCZzZfm
	 i6rrFcDrq00hFMpsTT5W6KK6td/K2YCAI1AB22h3luD//ahG1ub28FDnVRKZXh9KJy
	 yczJHuo2utfhmEijYANtSxrq9T9w4QGeuL41lVe4jp1n6hobidMgbC6xXylCzlyKTK
	 rSE3IBUcHgXTg==
Date: Tue, 7 Jul 2026 11:47:16 +0100
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
Subject: Re: [PATCH 29/30] tools/testing/vma: default VMA flag bits to 64-bit
Message-ID: <akzZBrZC_ja-R-nJ@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <27cd07f6dd862d92410cf9db03f7c11e5f66854d.1782735110.git.ljs@kernel.org>
 <akZO3xI4Lt1iSbms@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZO3xI4Lt1iSbms@pedro-suse.lan>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1025F100007
X-Stat-Signature: j6p97jrcdifxpd7gqsxpjd1xzp6emy4r
X-HE-Tag: 1783421260-246967
X-HE-Meta: U2FsdGVkX1/9Rl0H0un0tLfAkOx1M4JPk9yhocRHvBcUwXHQGng0VQovjum5ZQJ6fmJFsTSRwk2y8jEcIRvJSUAZGxATwXOqax/r5HoIPrc/LIRYVqbCo6pSMpITg4QbYW9voSqBdAEFpa9wzC+r58pdCROmFjewkRwtcnL9pghVmSNj3o4W95HlZUBbIukwtFaKiW6vcbPxbHGo1lBBqPpxlMkvaulUtA293TfoT9okpLlBwyxoYEBS7HgqWyim80rORSlrBJjgPvYG2Sr1bzvE7fpPnNO71rZy1KC9iXqqHxI0Dya/KAB1U+EiNKMCuSDnxvT5xphHzxPiC79oqW2a7Fd5UTuDyNG8T3sHt4/lwELbdK9as7LWpFuSfw3s/BkitJyWpQTs/6jeS2tGBNNqOJyjz33f1bsYf7iFYIUtB2Ai+5530QJHKxwMzQI3QkODQFE+2aiFjMATv0Sg4Xg1ExSkMlCzCu+ghsluHHLtoz2YciUOMqM09gnypbW+qBfWoMo/5msuOlgEBAOGKRjbMPVvx8DjQSL32y/FHnvHCoOUawoZpCmhXN4ECTGOmMV+6iA7cVCNJu2BjWa+thTopcy7RlIGvA5YJ7dOyLWRwFgoJSq9rfZEPE/lzrRH2T9zD91ZFi3mD/bqSYwvrRynPNseAMOq0z17bhWjhoGZODnlUzzhzgPLtZ/bOeCwTl/l59t24LfyN9yzgZz7Q9+qgOeL9DCjer7HoNoM3ljLkdKY+VqE4ItiFLhRsNJ8/ZBps7WgP8hmnxnHKQlu3Ye9XS8Sj1u8SQDubxlphok8mX4oZ0jaM3gr0AiIiemTK1oLRQc4MoB2v7/uv71bgvHMOzsjg4UjPJ3Jx6/UxuR4Zo1p49ih9Bqt08MI+g4t+Tn7UepN4ZmouPJLcGGDmTwmlkQDpP9O4DYOjGNs0yWqu2oUbUKrGXOR8sRxU5Fpb80fNz9907bZLVMqVon
 GfUOHxQ0
 JINaszoyNXEO5z28Ta3CiDP3tgDDaDZAJFKQCU7slfdDbohyebS8Gv85amTRq/jNglgBP106Tta0Qp969TSj2tWhs+f/1blrLpVOo+ZG4XQsvj11vHYnxicUHOX8rjoRuOQ768uupeIWbOzJhsdxnTtE+H0NtTcxfMY+A4wo6yy5r5NOzePC9YwvoC14mrMLr028f6zyiyUF0zAymxcUNo9MbipJqxRdBL9+AmgL/T4bL5g+RY16ktk0Qpi4BRLAzJ+MAfaffP2l72VrA54wMQpiIudpK4J6qs6wk8YYftX+CKvK3HKNbyfNComY/N4BwpOqViMoXgLVgZtTDlURXM9UXYYfxe1lukMSq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 12:44:21PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:40PM +0100, Lorenzo Stoakes wrote:
> > With all of the sanitisers turned on, setting the VMA flag bits depth to
> > 128 by default results in overly long build times.
> >
> > Reduce this to 64 - we can always manipulate these later for testing of
> > larger bitmaps as needed.
> >
>
> Hmm, what's the problem with the sanitizers? Shouldn't this just result in
> slightly different codegen?

I'm not sure but it results in vastly longer build times. It was a fun idea but
it partly defeats the point of the VMA userland tests.

Rather than spend too long investigating I'd rather we move to a sane default.

>
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  tools/testing/vma/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/vma/Makefile b/tools/testing/vma/Makefile
> > index e72b45dedda5..ef6cc558afe1 100644
> > --- a/tools/testing/vma/Makefile
> > +++ b/tools/testing/vma/Makefile
> > @@ -10,7 +10,7 @@ OFILES = $(SHARED_OFILES) main.o shared.o maple-shim.o
> >  TARGETS = vma
> >
> >  # These can be varied to test different sizes.
> > -CFLAGS += -DNUM_VMA_FLAG_BITS=128 -DNUM_MM_FLAG_BITS=128
> > +CFLAGS += -DNUM_VMA_FLAG_BITS=64 -DNUM_MM_FLAG_BITS=64
> >
> >  main.o: main.c shared.c shared.h vma_internal.h tests/merge.c tests/mmap.c tests/vma.c ../../../mm/vma.c ../../../mm/vma_init.c ../../../mm/vma_exec.c ../../../mm/vma.h include/custom.h include/dup.h include/stubs.h
> >
> > --
> > 2.54.0
> >
>
> --
> Pedro

Thanks, Lorenzo

