Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF8F8C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1686B009D; Tue,  7 Jul 2026 06:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78176B009E; Tue,  7 Jul 2026 06:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8EA56B009F; Tue,  7 Jul 2026 06:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FA156B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:41:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E459C403AD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:41:26 +0000 (UTC)
X-FDA: 84961638972.06.C3D5A4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 43DB220009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:41:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4xQ1MLY;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783420885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJf9TD7SQDB5FPJJW2/ET84adS4IbuPC7yAGQona0w4=;
	b=ny3Hlhj3QRoga6IBcG1hEsYvazwSV1lkhGQcuki/2WQkT46kkSbgKtrQBMnHQigMTTCUUm
	bAe48KTo9UUb88KFgftbfJhpTDSscTRRP6cyajCXXlIcpdPx91HRtReTs7m0/B92ZRjKiH
	zDMGBeeFp8j8cZ3g8jPndFQxWmF9Xak=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4xQ1MLY;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783420885;
	b=JG65LdKed3WLxiv/pBuf9cJBHBFTq5a7dS05EerqXI6Jsp/D9R5FE1djqN+3OwKRQ7b/De
	+pZaSqdPLxubr1oIwoQ5/g20Van3H+CPtn0ZVXLOwFUqUMFXbJvPgfAC5+0uDZ/8KDK/k0
	FNIVhJbL1VqjbNyQtFWUm6hOmFHwQYY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27A094346B;
	Tue,  7 Jul 2026 10:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBB51F000E9;
	Tue,  7 Jul 2026 10:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783420884;
	bh=oJf9TD7SQDB5FPJJW2/ET84adS4IbuPC7yAGQona0w4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C4xQ1MLYDSpZyJ9vErhP7qHq91i9ikXGv0t5hCWrCl9eUTArSekW8IgLF8XGmtWKd
	 xTIGCAyh1qfIlIufd5l17Cgwg4WqZiF4dc+/TCPc8HvDG1fNFYGWBlF0ToYxYrqjvN
	 YneV9/r2ute74xY+Q+roObPcxwoMMhJLENuNjhLyPISKLBSurogQ/rIw6E73c+hLlm
	 hTTkc75Ea9WO07vhZSUrk0zIjjA/Vuj7oO0Rk/wliB+L2u0OvPNR67ir9nUGC/aRRp
	 HRIxrduui2kRQb/MqDuhLQSFwpD8S/oxg/5H6IXHtt0/ADede4e0LeTLhY0Ts2D2mS
	 8/Zlwql9MxhGA==
Date: Tue, 7 Jul 2026 11:41:00 +0100
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
Subject: Re: [PATCH 27/30] mm/vma: correct incorrect vma.h inclusion
Message-ID: <akzWq08xwXKqwwtq@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <22d0f4e3fe11f6fd1312734e242d008267ad142c.1782735110.git.ljs@kernel.org>
 <akZNiN5Y9fPk8bZH@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZNiN5Y9fPk8bZH@pedro-suse.lan>
X-Stat-Signature: sj36e7pfb11nnjbp1nkayk5ppqd189ha
X-Rspamd-Queue-Id: 43DB220009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783420885-387621
X-HE-Meta: U2FsdGVkX187m6S0pdkqENnokVfwMLpQ2ue+IQN2GsOGsh3DhpNyKLi1coONyPxtWcEGd+16ATtljkTPaPTRAuPi5nvaAArqlFleih9Ojr4lE3EU6BfzLpqKTeYxjCHaszaZjJ3CMIM8tVrvUaJoPDoRe9dighjPNGN5aMuUWrCVmkZUo7+P/LKL2zDp8GuD8AYcK6/IHZQdM/XCypwCxNZSlkDhFSbSsQDXFx4K42QJvhXbYypheLqygbRYIfACAH+NMa1iZAbwNnWKTlukUkUTWE8LPrv4TMt/EQz+m+GBtVsI5Jc8lwwbucKOLWt9hSEbNda517iH5FFlMO8RvXvoDVp1Sri1Yx25V4M5NH1WzLaDQQQaf/iEuwU5hxRCtkqvxIeoi6g4yM3LyrBWdmuz1uNAJrcJQHkmvEk0EAbEU1jEZuB1NB7PB4fSUEl8F6gMOIett8Y1kUzY2AP1pcLzeTOOrkWrU0gmzmZER6TC13oS2NWI6k2CrkB1qE/mLTM7LGpeBZITD51i8nHrYWZxXq84gg+D9k2jQIkxZ+GHl8Oi0RQc8jMCe3/GTVzlY/Mv+eNUxqLVuwWNzkUpQjTBgSOij+fV1+z+jH8wvQ4t6eY8CgTwi9ScGxaOUZmJocXmkE/HZnbAGc1QCZt5x+GMTxspZcrK/IKAENc7mkaAOaqh3PQiYSOpyG7G/M3zFTy5ghDwAp2J3qvRytq28jeItKWg1pKFO+E06dYktKrUqc95yfqkSe1VV8m3nJEL7FO5tVHpFZn8uf7qL4HNoWmzm93IzI3ZxbUYwZQIv9jRt88WMN7bpEKPqZO0PcUztPfxZgtC+ZWs1LBSPbvbcGM5gEmR/vcG29oz34HMuO1BIlk6MAcL+8DCeix2meaj1Y9zTCetytcEaXVPHaQqlW8NBYJoy7+Y6Y3JX6IMoK/WixtSzW7+v7uvCilqwPOH2ZlMUuyms8R8FrtjGV8
 CpH9ukaR
 r8Oj0q0aYaErjtIiBu33Amrcq4i/pxcDOzjtUAUqjOPBp5/mixUaBk9o7KrQqrt3Q5B5pmiMxHusnWLakiwo8/8+KC8ULNq4qJvfN4P5y8vJG24BV2iTZg58UGTb4E+1f/vY3W8MmtlVDHbzdRVoyYPHkZ7gUxQ4xaSa1VpxmF4pyl+TgkLHpDngAuV1+CbVick1bRWq1enIhLyURufzwAj4idAZcUE31TDzr1DJFnMUmfbd3Cf8s2+LnaqbftaPkMqi8niuuvlPFwnGmPIUNxqdJ5QFgDPu0vvv0K30YsLiVxm5oG2nicIg7/AKfyzipCiiNPBxIwGKNa1sMONh0s4u6H9ctFklawEsWiQcXMONGml8+mjtkmKmxlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 12:40:30PM +0100, Pedro Falcato wrote:
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
>
> Two random thoughts:
> 1) perhaps vma.h -> vma_private.h

Not a bad idea thanks!

> 2) https://lore.kernel.org/all/CAHk-=wghMm2c+AYEcwYY7drSVXB27DYqc-ZXpFiq=XFs-w59wA@mail.gmail.com/
>    mm/vma/whatever.c :) would PROBABLY solve the issue of people snooping vma.h

I think a vma/ subdir would probably confuse things further, I think renaming to
vma_private.h neatly solves it actually, along with a comment maybe in the
header itself?

Then again mm/vma/{vma.c,init.c, exec.c, private.h} isn't too crazy
either. Though vma.h is the actual 'shared' bit, and vma_internal.h is the
private bit that the userland changes. But could switch things around vma.h ->
mm/vma/internal.h that mm/internal.h imports, and mm/vma_internal.h becomes
mm/vma/private.h.

I think that could work but definitely a follow-up!

>
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

Cheers, Lorenzo

