Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B95C43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 10:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90E26B00A6; Wed,  1 Jul 2026 06:14:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68A76B00A8; Wed,  1 Jul 2026 06:14:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59A86B00A9; Wed,  1 Jul 2026 06:14:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84F046B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:14:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02486402E9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:14:35 +0000 (UTC)
X-FDA: 84939798552.02.D93FC1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6AB4B4000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:14:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SsMSUbAA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782900874;
	b=JlFTb6Vu74aH342rIsgZfASOt1XNTCsTkY4PXCUpXQYKwzwNpNnXgIDFWo8MxL2gT0GEQC
	6eLCK4DmhiDqPj66mTeaC4ff3eRuUhNBK4x4VVZWRc7WZ1WG9K0WbVzJRo8w6kBqMMQDCJ
	4ZrAYOojIqb2g+TluCCdmlH347M0R2M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782900874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MxQbnGsZoYEeUUWCNxHFMLWCbhf6XkMB4J/kyZCw7aQ=;
	b=3pUA/eURWlgspyl+UcOTkvshy3/XHO2gldrSL9gJlsJ66dVwWTzIyUPzqzT+iNjPF5j3jC
	/2E+Uno86ceNc9+SqxhY4eVyRumoMb4IN0d1Z4AYTXVconhB8QEEnNZznLJbX4C6x9cGui
	LYjyY18/Pp4hw9IvKC7sKu3xlWohvro=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SsMSUbAA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD4C66001D;
	Wed,  1 Jul 2026 10:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9816A1F000E9;
	Wed,  1 Jul 2026 10:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782900873;
	bh=MxQbnGsZoYEeUUWCNxHFMLWCbhf6XkMB4J/kyZCw7aQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SsMSUbAAV6xvXQAFUx89uz5IFhN7+Zl1QTMWjM1sfBzD12H9w9GlLytFDAvlfqEtu
	 zxM1nx/Rw+0etgyNI/MUT6BoXukwf38U1evQ9uAuYcVhPAZon9ACkm+QDkxCLUZGOV
	 jfEfE5rqcIppLW/a+fFzg/lxdqwkSprEQ5wQzNhAM4QTPk/LKJXoFlzAwqp6zt4Pdo
	 MZsZG+fVKjkTgAWqt2sNhKdd0V9vHe1rSxqL7N2gbyIy7k6rBJg99uje117D1fIMTs
	 Ofv+7N0ZI9pM30elRxaNZLThhLB/mgA/4FFYjnJTIBx8Ssa/NQrq/aaGT1eQD2mIsM
	 MrCyKM8zicfjg==
Date: Wed, 1 Jul 2026 11:14:11 +0100
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
Subject: Re: [PATCH 08/30] mm/rmap: rename vma_interval_tree_*() to
 mapping_interval_tree_*()
Message-ID: <akTketJmWBOSThSf@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <f95462457025370efd047b9dfb039e76bbddf58b.1782735110.git.ljs@kernel.org>
 <akPtjuele4I7iqTQ@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPtjuele4I7iqTQ@pedro-suse.lan>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6AB4B4000A
X-Stat-Signature: kcan1fuznwn93eyy7s5g3perh5tnbus5
X-HE-Tag: 1782900874-498961
X-HE-Meta: U2FsdGVkX1/TmIh3BsYzuEdfdoi5Sgk5t1Lok/oCrI+M7kMmVV8tRYie+zgxfc3buRnB1daJXgf8wf34wE8accuZLwn3zYCf0sRkiTE+6zRVNNvYq+ki8om+wZAVF1R4JBPphktvVfyU1XAIqzUxN9RdVZAcf0j0LG4ux3AX5lZUTYK+gWSoKoOXX9DETLKr2dcj09EHZWMl/Vxb9OYpHf3JsfOfy5VtmXeNBc2e5vlPNyFBWFEQRO2UWbnQFIIhr+pO54pZpEVn0qfRm41R7zOl9aToEgq3rJ/4KSJ0XhRfwfOAkRhdY4iW40rROvbdrriFabnCuV4nCme7CpJwpg8T+8I0H5I7/tdzRG4NGlzZEaaN38uRrTW8+RANLsT6hmB++cVnE2lYDdCbG9lSKbF26vwf9ja52OcFw+JVq8KxXe1KniTzQn48zGzp6jKPCoKJeZGoN7WuPooPPJ8/5jPdClAsjksNOnXcTJCGU1kwkDc+SXUoaruYKilWHEusZIu0si8s4ZNINDYFaFbiV4sJE0w9uff28GO1M8nMRNe8wdnx4qjDG8UyyI+2otEHDo7mQ0g8KdL9/BaXlcD8HOf+yYAjFqAV5iuPCWbwOwjVdxwQ1itpZ8XV5yMujlOQSggrB/rA2DUPwdGaBkgpNygsXbySKz248HFDtyjb32NOvW9fCUlCu3EsO1mPZsNx69CIZOy13S6+Aj7Ta0B+AZbCU7D9YA7jB5/q3HTD7kiYcqfcor5fB5k//3d0Xo/ZOkKs9S5hAo+jGaFPNiYq87M7U+QZJVWjyjgq0PCr7zq2kW83VE/AT0AvD1kz9jzIS89KdIONyu0bKPpS/WsK/c8xkB1syD2pXwOwe530YjS+r67wBlCVXPBkPk1Fm99YiITUikGy0Np9siZxQukdWgYOIDS2dawsu8B4+LlX4gEkFmyNDL8RAX2f9yv3FMVW6nJbLYBPiToFdDKXmC2
 DIngeVl9
 APNLI4l/LFdU56XpWULiRx8auR+S4JI+gXWAuGy4xMro/3QJrGf4Zajio84Hzd1vhWebDEsDGdi0vOcFT8cXz5p68T8d1BCnE6MHjFwMtkRzET7sGdgMvdce2ypEuQ4t8fSlS6f071Ax6Gu/Wj7XWxjkjOo5UVi2mj31SXWg0cHWmLvAAqfGbM8VzqgMEtUhmZad/QvRMU+k+lqn4lB4DjeoGYpx/lsCEErTxAogopLIm6ok7FfVeiFeWdPALNsUTS1d7IWILi/lIpqiUnuyqD6fb5EOTV0HeG+hs3UotV2nftboeHpE9qdGS/h0tK+5Om2EvYD4Gx8h7HfHPo/wv5H3z8gS79wjAevWZENqdtvHoHbY1p74Pfbh2rHrGHUMLD8kv54Hm2YGiTA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 05:28:20PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:19PM +0100, Lorenzo Stoakes wrote:
> > The family of vma_interval_tree_() functions manipulate the
> > address_space (which, of course, is generally referred to as 'mapping')
> > reverse mapping, but are named the 'VMA' interval tree.
> >
> > VMAs may be mapped by an anon_vma, an address_space, or both. Therefore
> > calling the mapping interval tree a 'VMA' interval tree is rather
> > confusing.
> >
> > This is also inconsistent with the anon_vma_interval_tree_*() functions
> > which explicitly reference the rmap object to which they pertain.
> >
> > Rename the vma_interval_tree_*() functions to mapping_interval_tree_*() to
> > correct this.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> I'll have to nitpick this and say that I prefer [1] file_rmap_tree_, or
> mapping_rmap_tree. Or possibly even better - mapping_ (so
> mapping_for_each_vma, mapping_insert_vma, etc).

Haha of course.

I don't like mapping_ because that is such an overloaded term and it's confusing
really.

I'm iffy on mapping_rmap_tree as it feels like that implies 'this is the whole
of how the rmap lookup works', and it also makes it less obvious what _kind_ of
tree it is, though I suppose you could look up the types, but the crap macro
generation makes that more of a pain.

Also, for file 'rmap' you are potentially not actually doing an rmap at all in
the classical sense of folio -> rmap object -> related VMAs, but rather are
going from file/inode -> <page cache abstraction> -> related VMAs...

But then again a quick spot check suggests it's usually from a folio... I guess
only the rmap really needs to find the VMAs.

Also if I renamed it to mapping_rmap_tree I'd have to respin and churn all the
anon_vma code but I guess that's not impossible... :)

I guess I'm a bit stubborn about doing much with the anon_vma stuff until I get
rid of it.

But I couldn't live with the stupidity of calling it vma_interval_tree_*()
anymore here...

OK I'm a bit torn, mapping_rmap_tree*() and anon_rmap_tree*() are the workable
contenders from your suggestions.

Let me think about that on respin... :)

>
> A bit of bikeshedding never hurts ;)
>
> [1] locally I was naming things file_rmap, but I never actually got to
> churn these names away
> --
> Pedro

Cheers, Lorenzo

