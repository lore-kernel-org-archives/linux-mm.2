Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C865C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 19:36:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0F116B0088; Fri, 10 Jul 2026 15:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC02F6B008A; Fri, 10 Jul 2026 15:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB18C6B008C; Fri, 10 Jul 2026 15:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EF9C6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:36:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1899B40537
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:36:11 +0000 (UTC)
X-FDA: 84973872942.06.3AE92F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6DE6220002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:36:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GMSJQzHY;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783712169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfLPpKhOWsC/sVsNuiGUTkxCqQvuOvc9PrMkV9J6Kkg=;
	b=TPVA+1qA4pwAKUMcS95NLApmbMGfDGwcu31JK7wVUQprlbVtoYPMz0KprRlMr6ifcpnbkT
	vWp2V32MA8mRuJ3mYwYlnCALTwurBkTCrrJLABHE4pcfBx6hIKzQzU42mVp5Jr/b+eVuGh
	JPT+EI+WgZ1+uxdIsM/gQYDq3gsfABQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783712169;
	b=Ewuhd2mTUYv8YiF5D687WZWo2sKRc/sOLnlM3Pl0UyM9kp040erl3t9p4rByArBiysq9Be
	jNlkCIfSsrVK8ZCuqQfoWw7jwsjAe71H8IERC2fN1d64m8Gn2B5PiJiDhK8Ki/39qwgOsJ
	VZS9wDzVKyT/jH9vSk42nuBbNfegm1I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GMSJQzHY;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21B84413DA;
	Fri, 10 Jul 2026 19:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EA21F000E9;
	Fri, 10 Jul 2026 19:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783712168;
	bh=FfLPpKhOWsC/sVsNuiGUTkxCqQvuOvc9PrMkV9J6Kkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GMSJQzHYzzqQWm9PYMzUnrJgvzs2G9TH47wDGMDemvUAcIBLvWbRt6SIta8fNBwpk
	 4I1KzrcwinweqkCs0PIx0LTM6cTuB1EbRcqAQa1jYKzjr9JQ5Wtcz35zBJE5VHsTO2
	 cG9UL0/p5mQIf6dJdIDATgnZoBwiS18qqWXfRPN1X9YuCai4Sxlbmwyp1iHn5oqaVT
	 dYn1B2V/Mcdasv1lXZW09wtL6Km0Wa4YkT0iudkguHEDJPY6VHY2zx2FH0me1qiUli
	 FT7YTboRx/zld4NxRHycYg9RobUPctsDzxrL3Ch4bqyHkHMgOJIWg31b9WaLtB1aK1
	 q5GlLYmUSufqg==
Date: Fri, 10 Jul 2026 20:35:43 +0100
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
Subject: Re: [PATCH 27/30] mm/vma: correct incorrect vma.h inclusion
Message-ID: <alFJUfaGHVnKd-Nb@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <22d0f4e3fe11f6fd1312734e242d008267ad142c.1782735110.git.ljs@kernel.org>
 <alFHR3fg8K1-SITK@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alFHR3fg8K1-SITK@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6DE6220002
X-Stat-Signature: oe67zp7yrh1fai9c9ibf8z8jccfeto37
X-HE-Tag: 1783712169-453167
X-HE-Meta: U2FsdGVkX1+UJ+B+CvHmGqYE2gYjHFLAvLshbvh51UYRXpOPeI/4SkRTy+ZUkEg6nRS6maPozlXC+7R6yQxx1sOjTL4HclbOZcaFBrpv0D/MDxSI4YvT0pjkY0YgSe1E/XEQbrDgzRCABC2zumNaXwcOQRgjdeg7/66CL0ng4w3groq6NOfhHoDErAToHtE8+I7FKnDZ8ka8XR6x72EhsHBmKjMTb8+d20zYQWHCR80P/hhH1Fb29zJdG6tvq6HfEm67fx/1ZzwgGv6cgtDAlk3p+1mFfXHDbUbzr9Nu2GT3TjzCZpGfc70mgk/kPYUhJUa+KTTXSxpb/cfPC8Nr+8Thcui/h14JLd0kpgvCgcar9fX9jU1NKtwTCXzPmqCwmLCX4Aok0SuUGRiwIhiM78OuY5tiQ1332F8NnFVWHT8L1xYOH2d/1IlMpCyhXmBkHoOvSLz4mV9ZD8TGTC6BmbfSG/EK1e7ruMEoiYm6k98rd3JVCBjFHZVUtw1Z8m+s8DXq4EZn9l1EQtQMVF+pHyrQr3nS9ox4wCq96us01TvGv4qso8nCEeukMUT8YyQeT9gs2VpsWkTPJ4wq0sXjF835qWps+YnR84qDX6LIjJdf7C042PW14kM7pnyfSNHxS282zpWRYc45lYyYeJb2CosGUe10eSRlqfw3RfmMixrnNG2aDleCr1+J+CdcfcbKbT+cW3bZHkc0/4tSPaNiFIlcFYfyIgTbrr6sG9r9CKtcQRKOP1BP/8LwjRAZ/LY36CRnXz7vXiAONprExuGwbh8IN+/dHTAElgMPATDu5EMBjkR7hyqPdl9ND+0Fu9Bmu71U0M0rKQf3L7dLTUDpa1PRMMGqJGQhP1nk5VUev7mTNDwlfNtaG/N6l+HVUc6GpzCQ/hsf8LRKu1aagaEdh5BHiK0W6/hCNWO7tgKzxwzs8gistFIQSvQ0WWDMNI07AOeGncJzeBJrd3YFz/A
 iEROmHCM
 V3kopPyLFuqKrW7Wq0otVdawZh3q0OPTHPuXSgFPqkctf8S/QDb2MoWbyST0jvahzWi80ziiSE+AqpCMK1Vbt/OV6Gcvy2ZnHlqfrffDeqkcNLr62/NsEO3KlGgSdXUq8ybn+1ifdpNBVpZHttfqFUVeimXb77zk5rx6UQCJO545vKu/3aiA4lOTFb37tddAgNSDxlny7cDs2PrdbzFXE8itbXdcLfleP0I+BrBo+TPo0MHFeO34EVQes1uwhWCKYguBSTE36WtD5js5qFY5FEkMhzfuZT/ZqchOX71a6JSEUIo/dfi/vu0z9NT5Pu5Ok32Gar4Crk4uwMKobWwivSw/zru0iMJlpxp2M0s7GjvG382t0tAWHykRIym1pYdb4Fk+n2UKLaaAdt8M+erxRuNUIRFtjkVCp3+cI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 03:25:59PM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 01:23:38PM +0100, Lorenzo Stoakes wrote:
> > The only files which should be including vma.h are the implementation files
> > for the core VMA logic - vma.c, vma_init.c, and vma_exec.c.
> >
> > This is in order to allow for userland testing of core VMA logic. In this
> > cases, vma_internal.h and vma.h are included, providing both the
> > dependencies upon which the core VMA logic requires and its declarations.
> >
> > Userland testable VMA logic is achieved by having separate vma_internal.h
> > implementations for userland and kernel.
> >
> > Callers other than the core VMA implementation should include internal.h
> > instead. This header does not need to include vma_internal.h as it only
> > contains the vma.h declarations, for which the includes already present
> > suffice.
> >
> > Update code to reflect this, update comments to reflect the fact there are
> > 3 VMA implementation files and document things more clearly.
> >
> > While we're here, slightly improve the language of the comment describing
> > vma_exec.c.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Reviewed-by: Gregory Price <gourry@gourry.net>
>
> > +/*
> > + * To allow for userland testing we place internal dependencies in
> > + * vma_internal.h and external VMA API declarations in vma.h.
> > + */
> ...
> > +/*
> > + * To allow for userland testing we place internal dependencies in
> > + * vma_internal.h and external VMA API declarations in vma.h.
> > + */
> ...
> > +/*
> > + * To allow for userland testing we place internal dependencies in
> > + * vma_internal.h and external VMA API declarations in vma.h.
> > + */
>
> Do you actually need 3 copies of this comment or just one copy in
> vma_internal.h?

I'd rather have it at a glance, it's a bit silly but C headers are silly :P

BTW you're kinda racing against time here as I'm on the verge of sending v2
:P

