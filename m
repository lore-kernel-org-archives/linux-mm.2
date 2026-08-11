Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82F50C5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 19:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5890C6B007B; Tue, 11 Aug 2026 15:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539B26B0096; Tue, 11 Aug 2026 15:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427AF6B0098; Tue, 11 Aug 2026 15:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 01D8B6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:25:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8151CA01F5
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:25:46 +0000 (UTC)
X-FDA: 85089968292.04.8A66A57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E81B4180008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:25:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QjR46Q4l;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786476344;
	b=bP8nGh+orSgOrrPlA2w/QYyPxfr3D/B5K8xMNZB0wDYElJ0AG1oWJfNkEniJnhvgfZQn7C
	OdYZS9FMoRxeZnDwujYvp1BhTni6W438cS73McZh1cULQdjDUbR4iHuKR6w2WGQfwnU70S
	WH0VuKjjNaiXNuvMln6PfW27jrwsQCw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QjR46Q4l;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786476344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/kFT/bPhzj3VGlufcHrxy72DzfiKj46fSUWmYSSRdY=;
	b=S5FXJeM/teXZgNufjlcuObDDEKOxcElbtxxuUQUMWe7QnR+gX++p19R9mG7vXGEQbC+RD5
	WvfWDykzyRUpsMhUQqCLO2KO+6yfWUUB/ke60oPo8QNVKLDbXzdS69bhElGzkv9hFxVcEL
	CsEYwf1SzIJM2zkNq+NHi1q1530X22A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CBF5600AD;
	Tue, 11 Aug 2026 19:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2051F000E9;
	Tue, 11 Aug 2026 19:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786476343;
	bh=d/kFT/bPhzj3VGlufcHrxy72DzfiKj46fSUWmYSSRdY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QjR46Q4l38ohpBPR9a3NVpyj00X97b0QAtzWD4CJusxEIHEk06ZVprfqvGEwliaFz
	 ApBeXPVAZFUoE+1iAOYtGAf1euN2IjulS05jD3suRf8nP+UXfJAjvY23m4sDGtj2gN
	 0iZV+swR1WmPVz6C9JwEZAJHMXnIVG0wfTVbm3960TN4McRip96oHmA0zV1PTgK4PR
	 sMEkhML8HuqBfgHxpw5B+Vxc7jB7S5Ing8jtzB1kK0TmQkbcsUP5Z6S8nxav9KhiA5
	 LIHxirdJ5+/7iEag07J0iZPWWUreSRXob3X4jSbGiOtkALzPRhYglSoT5SwTdh0u/I
	 C3aXsRk4aSs+g==
Date: Tue, 11 Aug 2026 20:25:07 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Steven Price <steven.price@arm.com>, 
	Liviu Dudau <liviu.dudau@arm.com>, Huang Rui <ray.huang@amd.com>, 
	Matthew Auld <matthew.auld@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 17/20] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
Message-ID: <ant1xwiG3djtoXoe@lucifer>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-17-ab318a350404@kernel.org>
 <c7930f14-5978-4709-bac2-54950c988883@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7930f14-5978-4709-bac2-54950c988883@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E81B4180008
X-Stat-Signature: m9ouq16877fry73ab4ruwfrezjtgx9mr
X-HE-Tag: 1786476344-855726
X-HE-Meta: U2FsdGVkX19VRCdz/8jt0miZMOtxBsFEjrLWmRBti2VvXEeD3WxCTL5CRonhrNciiwaqG7j29gyyOlvoiZVtJJ770jxxSJK2Dj3bBF2EWooIPKzWybqtw4tuJBmZIp8jSNCuUaNMpEFM00xiK/unPQVIHS+pRvqn2hIUhIJcGlygRSvUEacKbRk/Tke/VcqAR8kiNRZJukQ8epzlKgQ4tf8JykQ7KXs6ZO+MG3aqUNTvtYfRpf41yoDR+mhx+XxSQ9VSQzE5s+xWqyDbb77fz1lw7fZqHXeFDDamO/1zrgsj8t171MsDeyFNSyOT5g1lVSYFoAq5BkXmohBx61b8xjYmied+ISgTSFXt2bdcAuQ6uGLh00s+ZL/nfVXtG4HqpZMpxEI6dTN3HhIvqfDhrdmwlsyGnlQ7mbaFqowJ0REwHR1X8JzT0CgqojmJAAEjMLFNO25F7SAFx5SmepRgKWrDYCJKTEiPzJuEPA+iY1m9Fdv2+t8RBh+ZsSE9ukSqAO+sGVsbN8OlbnZC06Tfh2wPOd2hFjfY4haM1EBeHHpeKt3sgKfI2Zj1DkhZUBM8NHH5eaTyJBD3E843x+60nYOMSBrzUTAuHafnfYVVz+woc6w+GG3ESL7j0a+vKIwt7H8Pk5X0NP0ELaqh8Fui4BKrjPABE8oObShncvoNf3AO2BnWWn6FaGLZDkWbyt59sKpDHfqE79Sf71dToUmZx+43DZz1IJnv9+ifrFMbH2Nro73NaCh9N8D2MQGkIAprZ8Whg6axpRruXzjO35MfjWzK8Rhwpubf2W5J+9QwMpN4qtCWo7RvrlPKpsoZqnc8oS4+OQo5Ma2qSi0UsfaIaLKTQ9HHChzkCZHs63ZSL+Kslr3W851zfYl0J7XkKR873gC+RI7Fh1dF+9WXJ6g8xxXQcDtp5mM7UBz3XB6Uj169Fsr1Rp3YmZSwHr0zEm0lcZjEKY0sGXfYbd6mTm9
 YnX9sw8Q
 DpcTW2yYd+BHuGVi1BXMtwcbaTNNOIxlqjBrx9A9NB1MZbKXFBgOR4FADzciarO5tVBzHN9eJp7caN9U2wGq62xieGjpLY2x9GwSe2BjU9XNFu3X8/eatHEleC8WDwpXkAISezm8BQx0QvYdxYHsxLmJfFXYfRHCQMFti09C7Lj7qqmv1k0M3Cch1JORpCsaamEd0twuz9T56qkTO1siE/4/cx6NMCcVRs90veU9paxx3EKff8BC3SmhTFDwowzVy0UPG/v1WPgN2oBTHe4BrK5MwsjFw9tAMu6pBcQXWFtRmYCGT4oFl6l26QHdHEvDkl7wJGo/eFIspW+mYbyoYiTLIsXV3Orsu8b9OmQbmZ/HN1w6QZZ32yJvPFgH5Hdseq37xGTofBz3wgWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 07:07:27PM +0200, David Hildenbrand (Arm) wrote:
> On 8/6/26 22:21, Lorenzo Stoakes (ARM) wrote:
> > In order to use mmap_prepare() with MAP_PRIVATE mappings of /dev/zero
> > without the success_hook hack we explicitly permitted mmap_prepare handlers
> > to set NULL vm_ops.
>
> The sentence is a bit hard to get as you are mixing "with" with another "without".
>
> >
> > However this is dangerous and we really only want to allow this for
> > MAP_PRIVATE-mapped /dev/zero.
> >
> > Make it possible to explicitly identify /dev/zero by setting a global
> > DEVZERO_MINOR device minor number then explicitly check for this in mmap
> > code for a MAP_PRIVATE mapping and only set the VMA anonymous if we have
> > positively identified it.
> >
> > Then remove all ability for mmap_prepare or mmap hooks to set a VMA
> > anonymous and update mmap_zero_prepare() to leave it to the core mmap code
> > to mark the VMA anonymous.
> >
> > Note that this disallows nested MAP_PRIVATE-mappings of /dev/zero
> > regions. Doing this would be broken in any case.
>
> What exactly do you mean by "nested MAP_PRIVATE mappings"? You mean, reusing
> parts in other drives?

I should have said stacked I think.

>
> Do you mean things like ...
>
> [...]
>
> >
> > An example of this is drm_gem_shmem_mmap() which deliberately clears
> > vma->vm_ops before handing the VMA to dma-buf. Cases such as this will be
> > updated when they are converted to mmap_prepare.
>
> ... this?

Yup.

>
> >
> > Also, in order to avoid a single commit bisection hazard, add a temporary
> > workaround to set the VMA anonymous only after vma->vm_file is assigned in
> > __mmap_new_file_vma().
> >
> > This is because vma_set_range() calls vma_set_pgoff() and
> > assert_sane_pgoff() in turn, prior to the vma->vm_file being assigned. If
> > we set the VMA anonymous early then this assert will fail.
> >
> > This is removed in the subsequent commit.
> >
> > Also update the VMA userland tests to reflect the change.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
>
> [...]
>
> >
> > +static bool map_is_dev_zero(const struct mmap_state *map)
> > +{
> > +	const struct file *file = map->file;
> > +	struct inode *inode;
> > +
> > +	if (!file)
> > +		return false;
> > +	inode = file_inode(file);
> > +	if (!S_ISCHR(inode->i_mode))
> > +		return false;
> > +	return imajor(inode) == MEM_MAJOR && iminor(inode) == DEVZERO_MINOR;
> > +}
>
> My brain is a bit slow after digging through this series.
>
> We identify shmem, for example, through shmem_vm_ops/shmem_anon_vm_ops.
>
> So naturally I am wondering: couldn't we do something similar to identify that?
> Like, checking for zero_fops?

We don't assign vm_ops for a MAP_PRIVATE-/dev/zero mapping. So that won't work.

We could expose zero->f_ops but then it's literally in drivers/char/ and that's
just weird to expose in mm.h or whatever.

I'm giving a really minimal possible thing to export, which is the DEVZERO_MINOR
number which avoids all kinds of weirdness like that. No driver stuff exported,
just a number :) MEM_MAJOR is already available.

So I think it's the least bad choice in this one, very very specific scenario.

>
> > +
> > +static bool map_is_private(const struct mmap_state *map)
> > +{
> > +	return !vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
>
> Can't we use the is_cow_mapping() helper instead somehow?

Lol... yup. Let's see how the rest of the review goes and we'll see whether I
can ask Andrew to change it or I'll change it on a respin.

>
>
>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

