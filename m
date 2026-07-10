Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B01C44507
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8F66B00AD; Fri, 10 Jul 2026 16:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0946B00BB; Fri, 10 Jul 2026 16:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1446B00BE; Fri, 10 Jul 2026 16:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4F1D6B00AD
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:26:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51D661C8A9F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:26:15 +0000 (UTC)
X-FDA: 84973999110.16.05D8E58
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A8CA340007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:26:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V2b4QNsr;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715173;
	b=QKdtIGSbid24kUf+DZKdqTrrXmmO/682EH6tEM9qZZctjnzuHVjEK4/LdF/M5LU6K+7KUe
	TjLfZJV1R3KSCWtPXSm8MVc2FgS3UvTfc6iXJo0Hmaldm1EXnBHJKWWEr3mQL7f08cSAkE
	4x7ZkYrvFZmYK02rhoFij3NY6ZSM90M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V2b4QNsr;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6273CuNOciMTKCjXSxMrvgGm9l+epwLM6e4G6yOjIk=;
	b=YUnvqwUX8MyCMMqOiMr/nLe+C9cgu7ra+zGAXWnvCICL9BqcllEWalS4VW8FWul9YB3AiN
	wYIZyGUpRylm0T5k3euTMLYkwfqD0Ym6xveoufeqvK40wXW1iy85U6IItGd5/jgGxq6CQ1
	qI3MxhnxGKcWK4qVJ9glltsZqte2xds=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03F9340AFA;
	Fri, 10 Jul 2026 20:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180A71F00A3D;
	Fri, 10 Jul 2026 20:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715172;
	bh=n6273CuNOciMTKCjXSxMrvgGm9l+epwLM6e4G6yOjIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V2b4QNsrlF0LdXzO3awhRO40eRtQvfaV/HOjdbw5a9ThC5CaV62SRPS+o0Q+YfyWf
	 1FVCx1Os6a192C2l5SnQMCn0D7RrdCz2ViuE7eCtMLxvcfkCQHjC0nn0igDYgx/lEK
	 8v8I7ByoNOMMbCUdWAR7qOt4PyHUnaVpBakMgQLbjRjpNsRE73xOFL/wPzBQ/rOSV6
	 tkllPYfbAzDgQ0XGhYYzZc28UxmgDagjeYwNH6ql4CD6zU4oFDuJT/UxPIWqXHJJR5
	 Og/JsMmeP3J2/oqnYpv5pL/Ia81wK2Bfj0r5G7e5AmI+G7yexlxowXi92aVVdo47u/
	 UbXYnmBP/FRjQ==
Date: Fri, 10 Jul 2026 21:25:47 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
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
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 29/30] tools/testing/vma: default VMA flag bits to 64-bit
Message-ID: <alFUVjk7yP8VoBGp@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <27cd07f6dd862d92410cf9db03f7c11e5f66854d.1782735110.git.ljs@kernel.org>
 <alFT7lx8F04rN01D@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alFT7lx8F04rN01D@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A8CA340007
X-Stat-Signature: o53xqsmdjjdz1gp4wk18xyzxmofjfqij
X-HE-Tag: 1783715173-218009
X-HE-Meta: U2FsdGVkX19iBik13laCY2OoychF2+mCjnHC2WfiiElHQKo3IHLCMMuOy7FJxbjzCiTCmxjN4JgaFk1cYRCumUVcZX5+B4Jc8yVGH4VjZT2dUuOHSB9pWPbzGVBKBuHcicQhjZ//MMryZgVAcsaTcgRWwb8/sIKFCwtRQojAFfkjkmq9tnF1sxK+0DA8i3rsbY3GSJAopL7VKAdaxgQ+71e9blYoNYJMQk45AAnvgULFpz1EG6itEnht5vDNr/FzwZakmw54zWsvfh37MigY4nX5hnwfR6GNs+rrLMZIQIZ8R6EYK9c08ZrBhHJ++a2CkzSLBJpsLVqAahkhGWrd9xg/Hfpa5LRBNvZ9kKPfKXbuim9zOv3eyKSU/tcXeRAEWUEYf/coz/25l3Le0W2Ks1kUwcpo26WMeR0H8AYLnVwxIiyfphczhKd/sEPB0CH+rKVst1KgZ2U2RnJl49MARFSSB7Ni69NlsMEBcHALuVYQGpl5ohxlD0u7739sbR9KhSw3i05XyZQhr1waWwqGf5t3C90Q3WtlT89p/NO25+wnWJRRf37GXmni30uXDmRxZrfGknvo0QAVWmifgPjFdc5b1w6e+bOCR2qjYbJDfWEiRcq9WO2NtRFK3x23xLXx3rwebGIzUXFaM28qwxjBq2o1xY3Qf9qMdd/KFY1t/2bS1pUOXGFDE2cRtbnMWmr8rVlVdZqNPapdcc0L9ZFPoFUmzMhUcH8QFMz9aMgW1ArdghPVtrQ+lbSMsvuVk/BjMcr45dObqFYddcLS5j+5SgCxv0ucOEoYxFfZUyggNkr+MvST/9VGg9XJO3u2gGr3d0ZvxgPHRX4E7LGEnBZbfgwrxnMwWMJ48nCsLPtCbs5KYAHExdgyjz4EDzZnByFsCKuqcwdeFqDZhASTIAIkvvSTEiM1XdTIJhKLEzB12MZcEh7jiK8kTZrDWjVU90XEJ7ie18ZfYIGw8E5ktHb
 Nz+P8oqw
 RMJR7crVn3A2nPEBtrraLkCPFfUHebWEDkmn1y9tPeLa8lzKAM9psnnCpmeFD1XdZ3j7qfvdO08DFL90ZpSp4hxzNM438zUGG8tYJw+bHjLkKzKcKuehfDmfVvvLvNifEnu8jL0vdKt6/t2L6SWepDYUJ6EQgpPvT6wdrUfL9IiV1T0YHosPAZUSSKQ0eVBU3uPk6+CNOe1fEffXdKYgO+TxyJpDk3HSLEMo75MvjG2mQLYUsZTr6x/zgKyWaaTQ8DA2L+y9keJQ7c61aCJ6ZHJkGVh9Fy2j4f6G3ZEY2a3ZGJ9oVVm+AqQB8KyNsNYGBqN7qQFDulyPR8XuByzVmWC2JOOwKKkTZnjHnmW06PhTOJ1/Um79pSu/ukkVJsq2DAgXeKJvUAa+Jxm32o0do83DrodelVxx766QV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 04:19:58PM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 01:23:40PM +0100, Lorenzo Stoakes wrote:
> > With all of the sanitisers turned on, setting the VMA flag bits depth to
> > 128 by default results in overly long build times.
> >
> > Reduce this to 64 - we can always manipulate these later for testing of
> > larger bitmaps as needed.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Seems like this causes instrumented inlining to go crazy.
>
> static inline void bitmap_or(...) {
> 	if (small_const_nbits(nbits))
> 		*dst = *src1 | *src2;
> 	else
> 		__bitmap_or(dst, src1, src2, nbits);
> 	        ^^^^ this branch is being hit ^^^^
> }
>
> tl;dr: __bitmap_or() gets emitted and then the sanitizers have to
> instrument a ton of inlined functions instead of the compiler simply
> injecting a couple 'or' instructions.
>
> if you wanted to keep the coverage you could do something like
>
> # These can be varied to test different sizes.
> NUM_VMA_FLAG_BITS ?= 64
> NUM_MM_FLAG_BITS  ?= 64
> CFLAGS += -DNUM_VMA_FLAG_BITS=$(NUM_VMA_FLAG_BITS) -DNUM_MM_FLAG_BITS=$(NUM_MM_FLAG_BITS)
>
> w/
>
> make NUM_VMA_FLAG_BITS=128
>
> would let you still test the branch but not by default.

Yeah I need to make it easier to set.

And that's a pity re: the sanitisers, the generated code should still be
efficient (will investigate some more over time) but yeah puts a lot more
pressure on the sanitisers for sure.

Is there a way maybe to configure the compiler to not instrument like that or
somehow derive things? Or maybe it's inherent... I am kinda fine with assuming
the bitmap stuff is OK!

>
> anyway:
>
> Reviewed-by: Gregory Price <gourry@gourry.net>

Sorry but I'm sending out the v2 I thought maybe you were done :|| and I'm so
tired with this heatwave + UK houses being like ovens in the summer (cold in the
winter!) that I just needed to get it sending.

Could you pop it over on the relevant patch on the v2? Once the sending stops,
b4 went crazy and added half the kernel so it's taking a while ;)

>
> ~Gregory

Cheers, Lorenzo

