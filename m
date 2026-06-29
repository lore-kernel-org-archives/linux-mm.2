Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13CF2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 17:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0C536B0107; Mon, 29 Jun 2026 13:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBDD06B0108; Mon, 29 Jun 2026 13:41:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CACA56B0109; Mon, 29 Jun 2026 13:41:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A08186B0107
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:41:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2DD9BC08E9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:41:16 +0000 (UTC)
X-FDA: 84933666552.30.4893B7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 751E21C0003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:41:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JwaoyB6l;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782754874;
	b=VAdNs++F2JVgO+0cimKZ3jdc2gKWsmBh4Je+DkeuwEa1SyZKDcWCOE9UvqdrbhwmSwi3re
	rg1O//YsfOx4yT9m2jL36/RTJSZJfdSkePuqTS1obTFFkiexdgh0MHBw6lcdpfuN1PQg3n
	1ejs7cddix8JxXgx3GHqUxszs2g/42M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782754874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQOiijNvdTgOg0ZDAoyrNzD33sjFLDelNYagWZ6KgVc=;
	b=iANTkUlCZ67na2ju8VBMbjyCvzxmVg8LCNqvXcZUrqo+A8+RZqutot7EL5ZrH5wkg+OKh5
	w/PqpDbAdeP/OitFE0YXShKOVGGpLOv6ORsp2P/mgp1rS7E4N5isGM44wnJVJrlzHosO8b
	i1jUV7gxhnBTxwmhvsTKbLa8/h1FDwo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JwaoyB6l;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AE82414BB;
	Mon, 29 Jun 2026 17:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA521F000E9;
	Mon, 29 Jun 2026 17:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782754873;
	bh=aQOiijNvdTgOg0ZDAoyrNzD33sjFLDelNYagWZ6KgVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JwaoyB6lWKH7ik47HITJbeTKRuRVfEO/0pfh+FINdeuw0SW8eTRpmytBGps7cxq+S
	 kCNxhF/4sUF9JTuYBPt+gxEficptfxjI4Ts803QKT6eKGg4SzB2GwWxKUWqlCQn0l9
	 8f9cXn9tIT+sPqdX3U0y0w9x3G09VMFKEVU1DGcxCD4GVjIrlUxjbdU0zRQEz8q7QC
	 mcugOs41Y7eE/Nj43NtJtSgVb0EqBim8qmc/DbOOo6P9Tky+uXOtwwn26EwNHq3UCN
	 XCWemy+r6UszZnRM3oT+U8VC1D0qCApuNOrmYwKXCeFmYfWusMxcdVWgEhsuAemzi7
	 qVl/nL+loLawQ==
Date: Mon, 29 Jun 2026 18:40:51 +0100
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
Subject: Re: [PATCH 05/30] mm/rmap: update mm/interval_tree.c comments
Message-ID: <akKt5S96pJZGzeER@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <80d482a927b2e9862487b812e0ab48ebc1289a70.1782735110.git.ljs@kernel.org>
 <akKWvnU2Ua-8ceSb@gourry-fedora-PF4VCD3F>
 <akKfAl-wdIAbexNR@lucifer>
 <akKnNy64lhNqPtLL@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akKnNy64lhNqPtLL@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 751E21C0003
X-Stat-Signature: 1w7xwyukeh3z6j1xwubo51k7ang317f3
X-HE-Tag: 1782754874-32971
X-HE-Meta: U2FsdGVkX1/C7A0m+yEKPrQSvIPXzyOKdQQTwg9/V5uryMVyFEVcP1fQqhm6+PE/dD+VDRplzGNxSPAlQvjz3eAHakzJ5g840cziH9eS6xuXL0g2t1NvkjPIa+YfpEtT4yrjAYtS9sEVJm12/4wu1u8Lp86SAW+3ROO/J6giayEPfQbbhNNnKOFRCwWfwdFD70vVwkLfqKoQEK2j45og4jxEYHr4FUqXFKpUiAckqLFaszyB2rNk9m22iXO/OpmoMIoKwUz5oT/RoEccdb7LY2AtmprbDJDAFwVJooXWgZ+0o36kIkd4W4dyzYP96uM0MMajt5LVEN8XvP1rQ4MYvUgzgMlotAGPmQavkn+5Bsr+3qqtH4+6eVGidN4PHDdydxSc8oua8qeRbCbGUOU3BX43oMk/TuBFqHQaU/NhJ9uejau67BmShqpARUaLNHTZZ5D+7ccV9UKaHEfji8RtcWqkN3Udhm7DgtfqmKJtiPjPt3HYcQ3Rk3l03uZOXyY6JQG37VtatJyRIv217D9gyWIDNVhEPU4P7hHpLQweN53FWow4RYD1QDGdnK7Afpls0kQm5Df203rzG2VGTWwjvRWCBN6a1pMcSlh9PhpTT5D2cG51Q/y8wsfkNy/4ClXyCkiDjZKdhYKRfFhxCel0grie6fX9PWUJCzVqKTXKca0W+M796k99FLlQ50b1Bwpz8XZnjcfddnBFUtj7s2IQeSz+Vzjx/ILOv2tcYFA3Y0hGgiGOO9yvMKlFHeoyq2V/vNqsvys56yf40D+2Uux8LwbP65AS0LFwf9HqUFZip2UC9un+eR+APM0WrvKSvfN/jgdNsa5hV93Qnn1SKOlkMV4BOyAq4yGjm6nhXDSTPxJXXnjxov+yCHOCnXHPQD7aGiUkzPVZ9BMVni4B+g/7yDpVCKkvHI0g5Ff81uQWEcruuOk5Ke4doqfB2LpbovJX7cvj918idpskoh8VA9A
 UmdzfRy+
 TLyrBSp+k/Bc6g30ePiUUV3m1tFcvADF+ljqsjuFn4fRjf7bkabKuSe5YpRC89sbSvbUJtkLKOHoQACqn2dA3nD48CKHDXlqYolS/daJLnVdiLRgjTH1xqe5U8d0bu7KqutO42N42SNBzsC5O9KV+1fg/mAAqTAlbULUjSZvLbJtUMSgy1TThQ/6t6iUp2NumW5Nw0HUQkYtxioFUdJYDgp/Sp/9VuRot3enNcaAmqoqmDZMfFh2ZskUrejen+NOZcaNIJfWhaBH1nXUikoC7abr0lwRDf6gXT7W6HNbyAkwmFAAvYZ6ZClKpywuup8vD6D3FoDNRXHRM9f+TAZk26I3gMt1DnURI07g+7wQaAXmP9Z8XOBy+0P7VJzmzCMm9wA5pRYGhcIHBIxkQUfEaMLp/CCmbtC7celwwtfOToM0Lv0d+ppnRRfr0gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:11:19PM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 05:41:16PM +0100, Lorenzo Stoakes wrote:
> > On Mon, Jun 29, 2026 at 12:01:02PM -0400, Gregory Price wrote:
> > > On Mon, Jun 29, 2026 at 01:23:16PM +0100, Lorenzo Stoakes wrote:
> > > > Update the file comment to clarify that both file-backed and anonymous
> > > > interval trees are provided, referencing the relevant data types for
> > > > clarity.
> > > >
> > >
> > > Isn't this self-evident by nature of the function definitions?
> > > (one takes a vm_area_struct, the other takes an anon_vma_chain)
> >
> > Well you see you're already hitting up on issues there, they both take an
> > rb_root_cached and the vma_*() ones do not instantly scream 'file-backed' do
> > they? As VMAs are obviously used for buth anon and file-backed...
> >
> > But later patches fix this stuff :)
> >
> > And I feel it's hard visually to see where one set of definitions end and
> > another begins, which was really the motive for this, as trivial as it is!
> >
>
> Fair enough, I scanned the rest initially but trying to wrap my head
> around everything as i go through one by one.  Generally this really
> screams "fix the apis" not "comment the bad ones" - but i suppose that's
> the whole point here.

Yeah intent is to eventually completely remove the anon stuff from here at least
:)

And Pedro I think is looking at the file rmap so we'll get there :)

>
> It's definitely an improvement either way.
>
> Reviewed-by: Gregory Price <gourry@gourry.net>
>
> ~Gregory

Cheers, Lorenzo

