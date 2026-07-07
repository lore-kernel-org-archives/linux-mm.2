Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E07C44500
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88FDC6B00A0; Tue,  7 Jul 2026 06:17:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F6C6B009D; Tue,  7 Jul 2026 06:17:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708566B00A0; Tue,  7 Jul 2026 06:17:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D74C6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:17:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCF621A03D2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:17:24 +0000 (UTC)
X-FDA: 84961578408.08.11CDFF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 95707180002;
	Tue,  7 Jul 2026 10:17:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cGH+4V3q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783419443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnyEnVNjUbkl63yjftBd6ZAUslZHuhLMLE5i1q1dbiA=;
	b=RnD5LEepETFoVwEm8clY2TX029sSxGS67zFhNu8kmjFQElZzCKRhapdKz5Beb/sbIFXJvh
	HNeNCYDwdHhf/nFTTbWPKTov4n522oNNpARBO9xW0fxIl9fzcOewNY8YJTyWKVvbhqJW6u
	OgIuakAg/T7064+ip/p3dFby1Aer6uM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cGH+4V3q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783419443;
	b=ljtnav/PggB8av87J91Y+6llaQepUnzRjdHu0azYi7so4qhM3EyHwTGDzAFNd2uxiIa9Hb
	zFwgfQRjLSwhHHXdddOm7ylLmByqWP78e+kxueaoFT5sSFMjTMfnHopq1ZM/glNSdbv9Ym
	cQJydUDMFUKt/QEKCXaYlv4GFDWtV2A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86145419A0;
	Tue,  7 Jul 2026 10:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122461F000E9;
	Tue,  7 Jul 2026 10:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783419441;
	bh=mnyEnVNjUbkl63yjftBd6ZAUslZHuhLMLE5i1q1dbiA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cGH+4V3qnWn/h2ntR4JOMP1MeFASTJyb/ukIFIKga6vmMPs4hWnZeyozgnP8o9zcj
	 4aOepXlE5yG0XgvATIbejO38So9984JOSQXxfemV7MrbXTQdbQqJryZ7by0rmLtk6g
	 KbyecrBlOO6RxZhZHoEJHQvN3lfQ+IRVIfllVkFrcFe5jzAzy0lAaGw02N38CG8Xem
	 bIuNc24pIIBeQZLitf75XKOixE/v2BoAd9XaTV+y7NflJFaBKiVOSfh8s3qL1kjbV3
	 QtnOkHzUZcffKxdXoostqrwbOmOdDgDEYFoMQefdIk5SYi6OuZQQ8BSF6bkbad2igD
	 ZZ2I4X8hc6i0g==
Date: Tue, 7 Jul 2026 11:16:56 +0100
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
Subject: Re: [PATCH 03/13] mm: convert __get_unmapped_area() to use
 vma_flags_t
Message-ID: <akzR7JQuaKEQpH5Y@lucifer>
References: <cover.1782760670.git.ljs@kernel.org>
 <b1ad7c4443f5cba622e4c48c5a9ef15427001a93.1782760670.git.ljs@kernel.org>
 <DJRZGEZU5ESV.3IP5LEAUQJCBK@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJRZGEZU5ESV.3IP5LEAUQJCBK@nvidia.com>
X-Rspamd-Queue-Id: 95707180002
X-Stat-Signature: etzzn6r3tnparc9zbn4psx9ro7d1nsdg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783419442-325228
X-HE-Meta: U2FsdGVkX18VyaPaTDfRVjPT/8RG0jv4C6nFU7z6g4M5JDEUqvPm/jjJbl0PnC18LVjb2YeJFvlJoJyWny8pdGDTCJ0Ti5bOs/qoBH6NxBUeJyVUL0HDci1A6t+UdG3sYr6bygWAYJd9uIRQlPz6EitI+wv8aUoRzMIEPW1IjsSvFRy4MTyBJgmnzJ1N6sGGbK3vexD3TwECY8LtPffVaw/0HK/dcaXkKjtwL+RRjaGgjUJIqRKoNdvH8scnX1W8XctdKjF1qfAtwZpbRHclN+ug74YXYcs2y/sOAIf8lA7JIOhgKZY+uF5IH+mQ29izbAl+fhfVWHwwDG3pnT6Ptp2QRCUzzvNrGBw1iD/1MlBQlsBi7doXTh0inkChTfOyd/7U4JLnILCyCyIJvNON5/jhaiS7jbl6RQI3Zb1HrbpZ5Oj99ea1+Nx905lUyi3DwOxljFtcc5Uiju/o9n8rgug04KR7JG90k/QDGg8jssoVZgB0++8JIZJRQC9zwlCaSbj9RcqODsU0tNPczuoy5DLcXO109Jo4xyBpMzY2/aAy+Mx8U7gKUkKjQ5KrtoOEFqfvFtPzX2rYbRdnHwWiu0nk6tWST20KDgBcW5BdFM6n8Ee5OPeOoEI16SR1CEtaXTbVs1RMfNYbVF1u8u1AIbMKh6zIugXngy2nTvffCTV+vZPpwp/P6T3MPwwQ5oGwwHPS/Y4YfeZfuLGxpD1uXWW8OIwU8pv2ZqMajg6zbwDGfzghN0TnrmFM9f6Vu7mHByW0tX5djcqm1M9020NslzWSoV/TCZTUctcPkbFR/kTK6mJRw0wHHkwf9CxfdhnzAfgfXRXTq9hOMM22FmFw8cMiUC4IJzg1HFZl+kTuDHFIFneBwa1C+7SYNfwq3WRMfqdzJ1gA6RIe1/OsgPPp3wjDh6liYdF+V+JgVOzMQWtfJiApUbqoLBO5P3fwq3jPLAKJUIj+YBgfi1a7DhH
 np82gFxQ
 h3lN/m+bKsR++CIdIdF2O3TYKRvZQgPdJR3YVeVNSV3Dpi9ZEQIpTz9QBua444hUCeqm4cYP4XKmCG4ATLQlz/TUNzbIHYJsyGAmUjpo20UHjMpgqdi9ksPOBLb5OZ8YY4Cf5c7H+Nfb7SVH9LGBM/I1i4wmO6D2OAtYfuI+6HyFdwPlZVCWPkAbBWlHLvQxKzBB1QO10nTUK6FfCIEPTPD+jHYCaCc3ryXTQn6vrUddMrM+WTfdBI/4DHGErn161p6RjagprdVHvGjL1DW0ErdYsyBvVdRzuSkVcWi4PzgYAHOCVMjRL+m1dlxAvMoi8ReKLkcgwkOG75DrWxfsG5ah96g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 10:28:24PM -0400, Zi Yan wrote:
> On Mon Jun 29, 2026 at 3:25 PM EDT, Lorenzo Stoakes wrote:
> > Update __get_unmapped_area() to be parameterised by vma_flags_t rather than
> > vm_flags_t as part of the effort to move VMA flags from a system word to a
> > bitmap.
> >
> > We cascade the changes up to arch_get_unmapped_area_topdown() and
> > arch_get_unmapped_area(), where, for now, we use vma_flags_to_legacy() in
> > order to propagate the VMA flags.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  fs/hugetlbfs/inode.c     |  3 ++-
> >  include/linux/huge_mm.h  | 10 +++++-----
> >  include/linux/mm.h       |  6 ++++--
> >  include/linux/sched/mm.h | 12 ++++++------
> >  mm/huge_memory.c         | 21 ++++++++++++---------
> >  mm/mmap.c                | 27 ++++++++++++++-------------
> >  6 files changed, 43 insertions(+), 36 deletions(-)
> >
> <snip>
>
> > diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> > index 95d0040df584..b301ec90740a 100644
> > --- a/include/linux/sched/mm.h
> > +++ b/include/linux/sched/mm.h
> > @@ -193,12 +193,12 @@ unsigned long mm_get_unmapped_area(struct file *filp, unsigned long addr,
> >  				   unsigned long len, unsigned long pgoff,
> >  				   unsigned long flags);
> >
> > -unsigned long mm_get_unmapped_area_vmflags(struct file *filp,
> > -					   unsigned long addr,
> > -					   unsigned long len,
> > -					   unsigned long pgoff,
> > -					   unsigned long flags,
> > -					   vm_flags_t vm_flags);
> > +unsigned long mm_get_unmapped_area_vmaflags(struct file *filp,
> > +					    unsigned long addr,
> > +					    unsigned long len,
> > +					    unsigned long pgoff,
> > +					    unsigned long flags,
> > +					    vma_flags_t vma_flags);
>
> Want to use two-tab indentation while at it?

Yeah sure will fix on respin!

>
> <snip>
>
> > @@ -812,19 +811,20 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
> >  }
> >  #endif
> >
> > -unsigned long mm_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> > -					   unsigned long len, unsigned long pgoff,
> > -					   unsigned long flags, vm_flags_t vm_flags)
> > +unsigned long mm_get_unmapped_area_vmaflags(struct file *filp, unsigned long addr,
> > +					    unsigned long len, unsigned long pgoff,
> > +					    unsigned long flags, vma_flags_t vma_flags)
>
> Ditto.

Ack will fix!

>
> LGTM.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
>
> --
> Best Regards,
> Yan, Zi
>

Cheers, Lorenzo

