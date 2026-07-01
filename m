Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71CB6C43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 10:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474726B00A6; Wed,  1 Jul 2026 06:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B2B6B00A8; Wed,  1 Jul 2026 06:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3632E6B00A9; Wed,  1 Jul 2026 06:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10F766B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:20:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97040A02DF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:20:25 +0000 (UTC)
X-FDA: 84939813210.13.5A67C57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0CC3F160012
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:20:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cuGMmNGU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782901224;
	b=QrR0SgVGEUZmCL3n/lQOXScRJJ7T3gK5cJhgqp5dCilnxy3EvDkXSOHUBb0VWacdEBryn5
	83wgZ6XS+0b5pTtxxjd91cEEtz+wMK+4hxE1AVuM7Zt3x2SfbxlqCPI0BIbgvahmEx+QIP
	UdjLokXXtfIujUysYTjrRNXb2q3WF8U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782901224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5+bWR29OngXVj5rwG1+zYSN1WwMk4/7ECM6WfNh2uI=;
	b=e+J2ev5gqfHOM+GAi6Z/SLF85iIYQI1DlSw+9LIMw548T0c4NCurACAlKcATdj19gnW8MT
	/YuwuOWGHnbZA3z7DRhAK8F3csc1ecwXWUX0nt1zAzS72t0J5xtTPMzyrs8a/jMRu1R2t6
	iFOHUEjeDRvhKqdCmsekGV1Co2d+YIc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cuGMmNGU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69CE6601DE;
	Wed,  1 Jul 2026 10:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7771F000E9;
	Wed,  1 Jul 2026 10:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782901223;
	bh=D5+bWR29OngXVj5rwG1+zYSN1WwMk4/7ECM6WfNh2uI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cuGMmNGU7E65Dg68eYFJaoaIWAAXeqkJUg8FZQJgjFh+i1j9q01MpEqRw5mq7z2rO
	 rkXRZR9NGSQ9sII7fZOwfSIwzleA8JRMW111/zeCE0qmHsxiY/HLQ0Dm8xGge55Nbo
	 /rPxBfTmGORtHvvZPyK97uPKTZnGWvFXgU7p2RkSdlG4PEyzwi19N3lXnrYxEkZX5b
	 zl9UvB9/CJ8gR1giihtd/aBTGzdpN/Ulj4oApN/i9Aqbvc2Mp6sFjuGNqa0yzOHDgG
	 nR1WDpWllVqYqSGN3pkdhjkgYYrs6JaUJqiQNQpkXzrrwNWf/Am7VMbc8hwnba0Luf
	 /Q1TqhzeWdoGA==
Date: Wed, 1 Jul 2026 11:20:01 +0100
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
Subject: Re: [PATCH 12/30] mm/vma: clean up anon_vma_compatible()
Message-ID: <akTpyNqkh6W1SmhI@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <5a7a07bd2a774989849b0fea84f758059ed914df.1782735110.git.ljs@kernel.org>
 <akPwbHbGiF1FxL6m@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPwbHbGiF1FxL6m@pedro-suse.lan>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0CC3F160012
X-Rspam-User: 
X-Stat-Signature: w8qcyetmc5uu8wwij3wbtykch46gis9y
X-HE-Tag: 1782901223-208657
X-HE-Meta: U2FsdGVkX19BzARGp3gL0rO08M9ZSnTEJiF2z/SppIxm/DEODUD/Nd0KrCHIjn527lY5Aa7SkPClhnu2Vuc1aLVbTvq+Yk9yW18UASJeEetL2wCGPEXbUw0Sx+2ZBnXMr17Vq7ZFgAQ5kDjwDfBQWuWphEPXVYYZ5ibTaqdxr6B3knAXFh+qtBhsE3kz32BZ5Hq5QTfsB89r9TEVaAbsmztGxNUIJCxf37XwFD5xQK0MsMNs8uldADzRrdRlECjjzSfYshVOsTxWJjpe1CO71d5Iaip/InfiAFMg7PodSW1ny9fZ+1anb6CmLNZlegZYmjMCVk/racCDAkzlk/lpV84HFu7mTVHcrHWxgslbLssJPQxPTgEuoIHI/G2JwCU84lW8S16VaozRDf3YbDIxClVP/yQ9dqQnMLLEff8J/eNCKXHNcnpkKSQ0YdhvmvPM/5+bO8FL/sc6e/6/yQ7nwRM+HbkJ40MZPR3aP4oxiwyj2qo6ZT4vHZMs1hBz1sCfwcOneIBU76aSKvMRz9eBlyXzFaoGv1XUYw1mbuwx0VeqiR/iUnVT1OOu/HBQs3H2o65qQqsUDtmbUKeWFYszP3+Fre0djRw+bvoNe/TERjh1BWbXIkgp+REoj/PgZHpqejX8DEL98UXhsAcVcMHZVY2BlpFbbrOrFlgPos2kOK3FQe/RjNLn7M23lrjfR6Oi2WIbQx8cuAzTPHh+B1Mu8gcSrEylIzXR1n578jSq/xNlyeXjxxsvuzvuzQvwsU9vr8VKh8LXbFkLT1Q7ej8RffkW3r+/CPKL5y3sIsgJ1YgiiyTAZG44kMc3aAFGiICNLx2+QdR5z6vEcjGRv2RtrkfsafFhwDr/dYIWJuQzmhTPBwZ7TrNjKbWovM2ZNohxHpvY0zzKXSHDpIlb8trXMGDWqiVdyq0DNVZPiwmemuByfY+lBxCI0W69UpzlMD7Kko2u4Skx+hjCaUt8LTz
 9kFzVm9Q
 uq20D+ujRh4APXnwJGFgxPrLU9xc8ANZG/30ZE5x3aDf6MxPXknKJEDbmWA7KZUseauc+0Y5HK1zdM9acxNSg6JRssLqiypqlhlVQIfkciyWyWb//oEegwKBfOuhIVZnxkxOe0QkiD2YSJwtt1eRObgfpDOHZXqnS+U+/z1qV+k38hBPENhBOzgN245ssrjIVexBvo7wQ93oNbY87ZuEh5CnKG4gMk8bryyma3gYMKFxg4gYAIuXfPAZDkGI385/TPoshmsdMOHdBf5hywVfYfJkjxH5skA41xIhBVD6ghZ79wJgWQtm6Lx3Q2pEm5xCDBo7MqgwGArZARm4Z/fQTa1DPGZv7Csq0jB2GkIhxogvRKGqGRBCGp8qQsrn33QXL2BtKGaLXByn25wg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 05:36:18PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:23PM +0100, Lorenzo Stoakes wrote:
> > Break up the existing very large conditional, add comments and use
> > vma_[start/end]_pgoff() to make clearer what we're doing here.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  mm/vma.c | 21 ++++++++++++++++-----
> >  1 file changed, 16 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index b60375c6c5c3..6296acecf3b7 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -1967,14 +1967,25 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
> >  {
> >  	vma_flags_t diff = vma_flags_diff_pair(&a->flags, &b->flags);
> >
> > +	/* Ignore flags that mprotect() can change. */
> >  	vma_flags_clear_mask(&diff, VMA_ACCESS_FLAGS);
> > +	/* Ignore flags that do not impact merging. */
> >  	vma_flags_clear_mask(&diff, VMA_IGNORE_MERGE_FLAGS);
> >
> > -	return a->vm_end == b->vm_start &&
> > -		mpol_equal(vma_policy(a), vma_policy(b)) &&
> > -		a->vm_file == b->vm_file &&
> > -		vma_flags_empty(&diff) &&
> > -		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
> > +	/* Must be adjacent. */
> > +	if (a->vm_end != b->vm_start)
> > +		return false;
> > +	/* Must have matching policy. */
> > +	if (!mpol_equal(vma_policy(a), vma_policy(b)))
> > +		return false;
> > +	/* Must both be anon or map the same file (MAP_PRIVATE case). */
> > +	if (a->vm_file != b->vm_file)
> > +		return false;
> > +	/* Flags must be equivalent modulo mprotect(). */
> > +	if (!vma_flags_empty(&diff))
> > +		return false;
> > +	/* Page offset must align. */
> > +	return vma_end_pgoff(a) == vma_start_pgoff(b);
>
> Very nice.
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks :)

>
> --
> Pedro

Cheers, Lorenzo

