Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE5D6C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7FEA6B010E; Mon, 29 Jun 2026 12:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56BD6B0113; Mon, 29 Jun 2026 12:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B426B010E; Mon, 29 Jun 2026 12:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 927CA6B010E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:35:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 168521C5EB2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:35:41 +0000 (UTC)
X-FDA: 84933501282.18.E5A892C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 665E84000D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:35:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfDXIPAD;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782750939;
	b=IXVqh+u/DlxksJy+KHRVIQn0Gr//zK4/vui93eXuUQkGYMlVzHz4yeFTdDwG2UkMRBDf5N
	i/pITrKcN0FIeVqKbTLD+CaDnz6Vpk2xZzzx76OYeJalCdPr4Oz61blNNDEfzUi6hJIQQ2
	Hw8A+BVtohZgsSDuVnNFBq/7+wCRxEM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782750939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqvibWEtQh2T48OiewXhNx0S0zqLKa3gex5DVvzFGOM=;
	b=zG7ngp7mJxR+7mOqceHwLDlQGJyfmOKOkaiaPdyt1w9ATd4VLqK8yEENCcRczREss30qNx
	PI8WfjJnrjMWxrDqzx/waZNu8A0yLwtymhKcwfA8hm4YT4A42MUlq4Oa8rI5qwfvoP9IYy
	TVp/ydnuA/8eY1UglrJrmGm8zXL7W+U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfDXIPAD;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B28A434BC;
	Mon, 29 Jun 2026 16:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5B21F000E9;
	Mon, 29 Jun 2026 16:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782750938;
	bh=tqvibWEtQh2T48OiewXhNx0S0zqLKa3gex5DVvzFGOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PfDXIPADcSrUOwdTRGhDf130tTlUjzfb55asHDeokcwn4q2fFY7uD5zpTbQijKU2j
	 A3h6LyrgBRhD8vjv/PCOQbIS0x10wNp15U53uZUeJSa+ZUUtNYjmvMkaFTX0FdsPtY
	 5VFsbeAwARiOlYL96AR5bc/UJx13BAZgTchhOZXOoq884yT683+Ba+UY0kenSbPQ5G
	 /9Y3STPVYFUZGbaD/nfway1UOiEmxiypL1sfzIHXjp28wqpXFD1BkVYOwnVTwzjxBO
	 T6iDd2rL+GJ7Oq4z7lXn+Gf9jPYSMojIl9QVfBm4ugrQ3F58b1YoFt3gxDwWn1rh48
	 BJyQRg2g8eDBw==
Date: Mon, 29 Jun 2026 17:35:16 +0100
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
Subject: Re: [PATCH 03/30] tools/testing/vma: use vma_start_pgoff() in merge
 tests
Message-ID: <akKeKSnWlc416OIP@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <b501eca378b9d9734e83838102aadc9276590fba.1782735110.git.ljs@kernel.org>
 <akKR3bFV7393yOUs@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akKR3bFV7393yOUs@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Stat-Signature: xpsc98e7usktwi63uno9n3hg8h3tutqm
X-Rspamd-Queue-Id: 665E84000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1782750939-661311
X-HE-Meta: U2FsdGVkX1+tuJCyAm6smntPY/F+7rwei4gMHgdwjVOfyHyiwyabBqn+30U0cj5SRAXr+cX1ipU+MkVH5oKKJ4T+eIzQsBn3xx08w5XdFgF7h5UQoqcWecWqfGcUQEymuDmfLBpPxF5pH9i0Fee3bXQOg09V8yLsfFJz392uA7mm2KKJqviterTmbxERvdzriiQEb0vDxM3fB+4NERZlUNVhJUFc6GKJ8EPsyVpLiZkpGTL4ayreZSC5erMtaXPT3mOiLm7Uj6um1Agj3jxflTiGDmFZqR1IWUF25dzby65AER19/+benuSHo8y1WcAnCs1N3macypoberQ6Hu+rfGO3K5Dfauk33LKF8gkSEJ+78X5FpdwJMa3bZjZbTVOcv8WtD7RhERBj6Q+j+0P+mc1mDXRmdIXEqy2Fm2Uwh9K7a2NN9ItkzVlthiaeE8vP2JjGseXl4Wxek0ZLcYSPed7aY0cErrxu95UYl3rFHS0UseKsuhux55r6rEuebbOywIOXtFhNb8t0qCY+8vmsSHf3mVCD0gQvndp/jf/bZytQZgAMzrHpQv+umKODwpD1ickvWeQz0XUtbLnYBKytqbiEbEO/uT6HuetTvynnDo5rmeIQjHhEAq4cpKkrOS/zlL0UASx2k2pVoNsamQBR9Mvs7wV07Ygm+DVpr0M3KpZzNIlMZpFXMwiQMymp/943qUa6Q8gHoCoJ2ndzXVLCX558zaYF9OFiCbWsDAqN/DtgDZGJ6lArJYwvczNXvk2c1mA4RRT9pF+RTZr070kGZFyH/vBTru7gYSViO9btgNkxFgCslPg22JqRlGLbFmUOaXiG5vKdtljpvQXvdAaAfoyZwgWsTix6iNKy5J3dTevIA/GAhXylIgFy2YzzDxCcEyilMrhykaBRHLGM6hL2VHQ0JPUmnf0eNHwHMP9H7pjO/4RF66aN2chNktteEQ3WCYr1IjjZ5rGs1JA0CnS
 JG2jT11A
 Kp+YJpNTmX+mWgCvuy530y1blhVJ9MJfBpvgG1J6CP+TKmLK6wnqhPAWEKQzOOhPrkwG+SCbUZqOT9vD+9ZCBoCJAGauWVi+7sVmXsGPcdkOOqtQpeAhCR+NAAXlsem16b7vJy0EoyAJK4mby3oiukw88Z45tElfsuppLHjoXj4o7quZdlOCFNAVR881Ang1oMOBMfN7V10z74W0T2B3eBw3NQ0Z/DbJZZQJyXOamODNUAad8XSWq2n58WSni+4pR2/1zuUVEr1CJ1vlHOZCkadaw/8jJ1H5SXdiMuXQG6EbWIFDJAHNc+84DKjHwwHsSEft0eDmg589YABiAymYO4dWce6G5per42djfqNSenPWwbRalQ5TtE3QfOa9kE1R3FZv8JsrpmwA+3ObztdQmOSaQAU5YxNbuhijFlFz5qa5799u8NPwnTpS1D6P7y9DboTQ/MAJCJJxD8oo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 11:40:13AM -0400, Gregory Price wrote:
> On Mon, Jun 29, 2026 at 01:23:14PM +0100, Lorenzo Stoakes wrote:
> > Now we have the vma_start_pgoff() helper, update the merge tests to make
> > use of it for consistency.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Question: Should we have primitive tests for vma_*_pgoff() since
> the behavior changes depending on file/anon?
>
> Nice to have the cleanup and clarity. Maybe worth asserting no
> one ever breaks this.

Well funny you should mention that :) I do add some asserts as I go.

In my RFC series which this series is the predicate for, I add more as then
we track virtal page off separately (see [0]).

Amusingly (or not) /dev/zero breaks assumptions a bit (anonymous VMA with
vma->vm_file that tracks by file index, just glroious). But I plan to fix
that later!

>
> for this patch though
>
> Reviewed-by: Gregory Price <gourry@gourry.net>

Thanks!

Cheers, Lorenzo

[0]:https://lore.kernel.org/linux-mm/cover.1782745153.git.ljs@kernel.org/

