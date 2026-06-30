Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F2ACC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FDB36B00D8; Tue, 30 Jun 2026 03:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ADA56B00D5; Tue, 30 Jun 2026 03:39:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275366B00D9; Tue, 30 Jun 2026 03:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFE526B00D7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:39:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 723BB1C6769
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:39:19 +0000 (UTC)
X-FDA: 84935778438.26.1B4E79F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3588318000A;
	Tue, 30 Jun 2026 07:39:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fDaf4ZqW;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782805157;
	b=y3KCuCJTl5sFWgzMefp9vfneckYNp90JkwGPcvWvwtOby3w59YzSDf0Ap3l+cA9fboy0ht
	gJn2Q+rnTKrbZQqx9WtU+asuBwOBK3bMbf7ZXRm0HceeoToSb6F2Gqo8Kjrx+M6RelUZe0
	sRzVBrHADb4ZmS1yLaBkgxJkpjvwwGg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782805157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFTirDmiRXM2E2UxDPivyHpH5WU8vmAPSC3LpjlrT8o=;
	b=3x7V4pBSRQdQUgZs97GS0inWby+Wh4SGCRu+QukMuxIghC16aSDoErrQWVJX3ryESKJQtf
	wFc1HZC7UFDVs2goXFatPE5XCR+RIstAmlb0wN1vMaSbMjn9sKXWpqzdbyCvl/ndUaPBTW
	dxXGs/fhj7sZqvybC2jcGNPrE3H9QVU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fDaf4ZqW;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3547140B7E;
	Tue, 30 Jun 2026 07:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F3C1F00A3D;
	Tue, 30 Jun 2026 07:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782805156;
	bh=QFTirDmiRXM2E2UxDPivyHpH5WU8vmAPSC3LpjlrT8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fDaf4ZqW3PD9fY8acsrJCsXc7pOEzc4lLsW2jgJhfYGl7NXG5KcVo4Pxek2Uz+Nla
	 tOcu2NuZHwmic0JpBPUEEgMmuaTGNKExmRCbT0ES7+8QhHL9YqeimbRUf62O0HtMfs
	 LYny1udM2eWLdF0sRgHD+bBsvogcyV+srg+CrLasOfuUZDDcJr8dZlygrFZBfDoggP
	 p2mllhEamdnPs77YGrH3WGaXXIkqv4Xgyt7g+R7YVqHEf/NFyfi55aJUF3SRsQX/b0
	 NUbVhpaMaUvlKWWtDdlDlkLmrVKracrOVgHvCwNbE5g49j/+vG6Xvy5Wxh+acQ6BjY
	 MYjz8K0OvlQ3A==
Date: Tue, 30 Jun 2026 08:38:51 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Lucas Stach <l.stach@pengutronix.de>, Inki Dae <inki.dae@samsung.com>, 
	Seung-Woo Kim <sw0312.kim@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, 
	Krzysztof Kozlowski <krzk@kernel.org>, Peter Griffin <peter.griffin@linaro.org>, 
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Sandy Huang <hjc@rock-chips.com>, 
	Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>, Andy Yan <andy.yan@rock-chips.com>, 
	Thierry Reding <thierry.reding@kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, Zack Rusin <zack.rusin@broadcom.com>, 
	Matthew Brost <matthew.brost@intel.com>, Thomas Hellstrom <thomas.hellstrom@linux.intel.com>, 
	Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>, Helge Deller <deller@gmx.de>, Benjamin LaHaise <bcrl@kvack.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Kees Cook <kees@kernel.org>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org, etnaviv@lists.freedesktop.org, 
	linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
	nouveau@lists.freedesktop.org, linux-rockchip@lists.infradead.org, linux-tegra@vger.kernel.org, 
	virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org, 
	linux-fbdev@vger.kernel.org, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH 01/13] mm: introduce vma_flags_can_grow() and
 vma_can_grow()
Message-ID: <akNucoP3eaDN2_Vz@lucifer>
References: <cover.1782760670.git.ljs@kernel.org>
 <f2e8c32515d328db62279cc8bab8398ea278d74f.1782760670.git.ljs@kernel.org>
 <DJLTDCPWMXDL.4ICZ77A1LPZZ@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJLTDCPWMXDL.4ICZ77A1LPZZ@nvidia.com>
X-Stat-Signature: fpft5xxczpsy3kgyhj8wszo71i3oxthz
X-Rspam-User: 
X-Rspamd-Queue-Id: 3588318000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1782805157-106637
X-HE-Meta: U2FsdGVkX18ie4JvL+xKNzs97oAejynQPHrq3hRnlif0R1gFnFCwvOd0nHIiYLBmIIu4QRx0SyVgtrB/2L5dbK58AdZ0FuzfAX6WhJEtCydiT3lxZi4JOxd6lEqAonKOeR4YLy9oBghORZ741sRd0a0D0f8LtgjyVHcyB+VcLc+uCgFRLNEzHg54KhIuSJ1D/hsmlW+rMw/oz1T4jY/Tj1d2fUtDaTyZ0jGK5jqmYS71VQxWrFB0h10CQ9wSlmmDPp+eswKiHW7jHm3mG5c8KsPF7G0EjUgbB5jHm7MobdQbPWV6wdQIhKL3Ifw0XCOtvYNcl3KjRHbaFx/uCMeysAPpQSoH/SMBlq85GsDPI1xwPjnOWMLuo/3w4B/MzB2xr9eonze9UamvNw3l+5un7g5MOcaZBmBAAasXMnfjgAXmBg0yls9DDplbBe9LK7PiUkDBOmquIsxBt9rJzLxxYldD+lHVHFnV1/gS1OSyZUpJSX8ez1xnxKYnwRJykQ1quCDVQFhcEZqaRMwVHHzz5Kkd8puKp/Iv0AQxWBwEhfnLC161Y/jVkfulVYNXURjCF7Qy8o6Bti7hg3QxnwPm/HXsHzro+zELhgq4mTavTTsuwLNksV14+nOoniqC1R3xFyt8esxtkngzT6f/LgCuVsStaS9Y5/XNEqvXHSbp4RJf8g3DTttEEuu25H3gv5eICezjejQqlsL5bmvH5cKs3cZhwps7lS/Nr6A+jv56HL+5AqPZP+ZIBYeDz1GZTChxoEPXEOf0qJIt36WEkb7RuiTf/QmfvJMIUtVaYO9QPRmgRXyzg/vsbbRa3urY24gGYbgeCNbTvtszCJz+KIeEZIOGCYcm6KKTHs2yHVrl9DRdNhh/QXP6eghpzM2wzRTpSTWZKibuA7CLafoMH+mXhgaZuSZFSYT+MSBNjhAum1oOAolNQp+GmlUM0qbBBRUHhBDZhtkkb3JwAqUnUFx
 kDyf6n0n
 j9BcilQsxTuup0hg4E937UM/r37ZK/iDLFO5z9Dbwywl7KKb0zCUG8tKUJGnNHT/cYybWRIc3Hng1Bq1vKZrV+a2QVoGW8tXo20Z/W/Pla3frjnrqCpsRb3JAJoBV2XX6ky300HwITVJXnifMgs1Pw4QQjrLi0xrxb8xbDWUhpA22dlDwHxSPFdbj4G+6q9dBRmZBu3MJW5KY9tYeuOybqhJIzg+RNN76AxnxV5dOPMnKxFp72eqpsJOzGKSj6PI2g2Del4638P48n+NTK/H//mFxsSRZ1zXYrAjOLOF6SyPY/28TZChVmzVkukfEhB5oCJqu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 04:26:18PM -0400, Zi Yan wrote:
> On Mon Jun 29, 2026 at 3:25 PM EDT, Lorenzo Stoakes wrote:
> > These test whether the VMA has stack sematics, i.e. is able to grow upwards
> > or downwards depending on the architecture.
> >
> > In order to account for arches which do not support upward-growing stacks,
> > introduce VMA_GROWSUP whose definition depends on the architecture
> > supporting it, and use vma_flags_test_single_mask() in vma_flags_can_grow()
> > to account for this.
> >
> > Update the VMA userland tests to reflect the changes
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  include/linux/mm.h              | 21 ++++++++++++++++++---
> >  tools/testing/vma/include/dup.h |  4 ++++
> >  2 files changed, 22 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 868b2334bff3..cf7df1569052 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -472,6 +472,7 @@ enum {
> >  #define VM_SAO		INIT_VM_FLAG(SAO)
> >  #elif defined(CONFIG_PARISC)
> >  #define VM_GROWSUP	INIT_VM_FLAG(GROWSUP)
> > +#define VMA_GROWSUP	mk_vma_flags(VMA_GROWSUP_BIT)
> >  #elif defined(CONFIG_SPARC64)
> >  #define VM_SPARC_ADI	INIT_VM_FLAG(SPARC_ADI)
> >  #define VM_ARCH_CLEAR	INIT_VM_FLAG(ARCH_CLEAR)
> > @@ -483,6 +484,7 @@ enum {
> >  #endif
> >  #ifndef VM_GROWSUP
> >  #define VM_GROWSUP	VM_NONE
> > +#define VMA_GROWSUP	EMPTY_VMA_FLAGS
> >  #endif
> >  #ifdef CONFIG_ARM64_MTE
> >  #define VM_MTE		INIT_VM_FLAG(MTE)
> > @@ -1563,11 +1565,24 @@ static inline bool vma_is_initial_stack(const struct vm_area_struct *vma)
> >  		vma->vm_end >= vma->vm_mm->start_stack;
> >  }
> >
> > -static inline bool vma_is_temporary_stack(const struct vm_area_struct *vma)
> > +static inline bool vma_flags_can_grow(const vma_flags_t *flags)
> >  {
> > -	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
> > +	if (vma_flags_test_single_mask(flags, VMA_GROWSUP))
> > +		return true;
> > +	if (vma_flags_test(flags, VMA_GROWSDOWN_BIT))
> > +		return true;
> > +
> > +	return false;
> > +}
> >
> > -	if (!maybe_stack)
> > +static inline bool vma_can_grow(const struct vm_area_struct *vma)
> > +{
> > +	return vma_flags_can_grow(&vma->flags);
>
> Would it save vma_flags_can_grow() if we do below?
>
> return vma_test(vma, VMA_GROWSDOWN_BIT) || vma_test_single_mask(vma, VMA_GROWSUP);
>
> I find these two functions when I am reading mm.h.

Yeah but we require vma_flags_can_grow() for code in mmap.c, the majority of
checks of this have only vma_flags_t to work with not a VMA :)

>
> > +}
> > +
> > +static inline bool vma_is_temporary_stack(const struct vm_area_struct *vma)
> > +{
> > +	if (!vma_can_grow(vma))
> >  		return false;
> >
> >  	if ((vma->vm_flags & VM_STACK_INCOMPLETE_SETUP) ==
> > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> > index 5d7d0afd7765..6f5bcd7fbcd8 100644
> > --- a/tools/testing/vma/include/dup.h
> > +++ b/tools/testing/vma/include/dup.h
> > @@ -245,8 +245,10 @@ enum {
> >  #define VM_STACK	INIT_VM_FLAG(STACK)
> >  #ifdef CONFIG_STACK_GROWS_UP
> >  #define VM_STACK_EARLY	INIT_VM_FLAG(STACK_EARLY)
> > +#define VMA_STACK_EARLY mk_vma_flags(VMA_STACK_EARLY_BIT)
> >  #else
> >  #define VM_STACK_EARLY	VM_NONE
> > +#define VMA_STACK_EARLY EMPTY_VMA_FLAGS
> >  #endif
> >  #ifdef CONFIG_ARCH_HAS_PKEYS
> >  #define VM_PKEY_SHIFT ((__force int)VMA_HIGH_ARCH_0_BIT)
> > @@ -315,6 +317,8 @@ enum {
> >
> >  /* Bits set in the VMA until the stack is in its final location */
> >  #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
> > +#define VMA_STACK_INCOMPLETE_SETUP append_vma_flags(		\
> > +	VMA_STACK_EARLY, VMA_RAND_READ_BIT, VMA_SEQ_READ_BIT)
> >
> >  #define TASK_EXEC_BIT ((current->personality & READ_IMPLIES_EXEC) ? \
> >  		       VM_EXEC_BIT : VM_READ_BIT)
>
> Why are VMA_STACK_EARLY and VMA_STACK_INCOMPLETE_SETUP added here but
> not in mm.h?

Yeah urgh oops my bad. It doesn't really break anything but I'll fix it if a
respin is needed...

>
>
> --
> Best Regards,
> Yan, Zi
>

Thanks, Lorenzo

