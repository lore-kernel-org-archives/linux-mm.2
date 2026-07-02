Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34506C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F20B6B019F; Thu,  2 Jul 2026 21:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A3F16B01A1; Thu,  2 Jul 2026 21:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3296B01A2; Thu,  2 Jul 2026 21:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B98F66B019F
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:16:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7AB98B436
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:46:30 +0000 (UTC)
X-FDA: 84944263740.12.B80E91C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C73581C0007;
	Thu,  2 Jul 2026 15:46:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mynx6GD6;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783007189;
	b=JSO22uiw0mgxwwQSRrb6uKfYPHVJBUsvUarPiG0wOJMq1R88t68w5H6MALQOLedVK144+g
	KCqYv3ZOlJhsqkebf2cPIBR2trVFYNluYV8IV/CE/A5HIf4IlywIP5OL1I/QK4CNgxGNB2
	uzKMmonqvYwkwDj6gOM3hOjrnORsC3M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783007189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvE9wSqWBUCbGMsJG9svgBUezevNvrm1MrcHHSCChso=;
	b=Qdf/YFrqQomK8hMNk6mos1UhizBcRIlFDZHZkyLEt49qaM2blkru5ivxusiyoMC6WsxWrm
	a+CrozxBJ+TYCZwOT0OTOiBDZMJt9p1qFZv6FfZVanmIsCKhJqPhVpc9yu4omMX1P4jGCU
	nUE19+I6KroT75iYJbLv/AcCAEw5ktA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mynx6GD6;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EBA4601EE;
	Thu,  2 Jul 2026 15:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EC61F000E9;
	Thu,  2 Jul 2026 15:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783007187;
	bh=jvE9wSqWBUCbGMsJG9svgBUezevNvrm1MrcHHSCChso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mynx6GD6LkebsGmUnF9MjOYGoc5t/kjVRBAa3y4hDMiI7/vl1tQdkpNYaMYBglDKt
	 PpjOhV7WkyGWbA6148JfY40EHSUewPFem4EcHLSNtrDL52P+m6uRZFhhXV+p8drDP5
	 krlXhtnXXcRAzWJ2KFYq3Hh8rhTgMNWOvfDO5ubcScHxjko5fhA5/oYXfBSBTm3FYZ
	 q91+d//PbttUXOxvDyYYUNz2FFsT7LJ6pIAF99pcS/rpWlpmF6qsZCGqK6q0R7Cu6u
	 A7jMMvK5AtByO3p0pYtd9gulxJxBI42o3AQ7j7VXEvArqPbpGQYUH4EuymRAwVZamK
	 6IrFtw9w61Ysg==
Date: Thu, 2 Jul 2026 16:46:04 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, tsbogend@alpha.franken.de, 
	maddy@linux.ibm.com, mpe@ellerman.id.au, maarten.lankhorst@linux.intel.com, 
	mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, 
	l.stach@pengutronix.de, inki.dae@samsung.com, sw0312.kim@samsung.com, 
	kyungmin.park@samsung.com, krzk@kernel.org, peter.griffin@linaro.org, 
	jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, 
	tursulin@ursulin.net, robin.clark@oss.qualcomm.com, lumag@kernel.org, lyude@redhat.com, 
	dakr@kernel.org, tomi.valkeinen@ideasonboard.com, hjc@rock-chips.com, 
	heiko@sntech.de, andy.yan@rock-chips.com, thierry.reding@kernel.org, 
	mperttunen@nvidia.com, jonathanh@nvidia.com, kraxel@redhat.com, 
	dmitry.osipenko@collabora.com, zack.rusin@broadcom.com, matthew.brost@intel.com, 
	thomas.hellstrom@linux.intel.com, oleksandr_andrushchenko@epam.com, deller@gmx.de, bcrl@kvack.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de, 
	david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, hughd@google.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de, 
	kees@kernel.org, perex@perex.cz, tiwai@suse.com, linux-mips@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org, 
	etnaviv@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, nouveau@lists.freedesktop.org, 
	linux-rockchip@lists.infradead.org, linux-tegra@vger.kernel.org, virtualization@lists.linux.dev, 
	intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org, linux-fbdev@vger.kernel.org, 
	linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-sound@vger.kernel.org
Subject: Re: [PATCH 10/13] mm/vma: convert miscellaneous uses of VMA flags in
 core mm
Message-ID: <akaGxiTaJreEQn8T@lucifer>
References: <1e7d834c887b6a65627d730addcff13d458c6268.1782760670.git.ljs@kernel.org>
 <20260702131233.59026-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702131233.59026-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C73581C0007
X-Stat-Signature: 7zs8oqyjyxb9m6bbnoawymu89ks3gdgy
X-HE-Tag: 1783007188-156681
X-HE-Meta: U2FsdGVkX18yXngQauTTwneNP9zt7mk26pAgEVMSNYOpiUl5Kdmqsxc1q/TfojT+GG0E09CPxUz1UkVjzBAeaJZaCBPUzJUhcXI4hTKbx2w9nodC6dMoX0FLWfYZT0TuRi7h/QWuV5aEkDuV5MmMYk26JYutnjqYHYt7xFvABupDHQzA43Pouh5mPm3Onkr8PBNp9nXupwljP4+3hMidWshLV5ySQb0WPp2HdBEyWhCKcf89DOXiX5eckuPMvXSt+5BqyrIBsVfj3KHUsza7W8DLIYx1pEJ4Kij765PDn4ixsu92Psa9rKFDmdIHa+QI9E2ZkLmWuCaN7VPTCFSDB4YaGQe9W5jFy3T10dTTALD5Hc8DPePxqzOCcp/CrB9ogx/vJL39oPYJCeZp3E9Ag1WVaX/lhmFA8YZ99PyzlViG9t9tBrD9XxIvyzJezrp2rbRvnwuRhZ2iaVzdbbBQO4o0X5aMjX74P0BLTPebrjwhaNb51MJjTXoKiwHZzC+bU9AQH14yggaaeVRjdrM/IHGVOQ11443qd2aKeL/+7z2P1TfpyzQ45RIg4RYrO2L+CA2hf2qwc59wXtWSz6CUthjFDI7+UMJvtniFLTP//evDRbkFYGFvP1iUuN2UVZyoE3oV7Iw7U13gIecxb8+lAD1kblNx8nVexLJWgpPvHyxEYB2umEnhQDEqhv5ED7RyQFY6hq4DjHvRP/YRbdl2Woi5mUxiE9JV3MX/wC7o9pSf5ySmKwfaBG3B0iqiYQda+K+8rCuu0HEQVwyuzSzjIVvv65Nd2LJ5fUU1i+wdUJ6XyikWMHgoeR9fXrSxU/s3X2ijBWxfKL3820uwuHh3HkqB/xSBN14HIizQ40O8GYF2iGITXaFE+EgPer8IfJx9sQ5RSO9qGt9Y7VqIrHkCt60kC7TmQ3dJj3/28J4IqNzBuCrpyNog7RfvfZyEAgsaF1n0OLa6gIZbUsV+g+I
 5vWvpMOg
 DcnW4hTZHNftc1nxdvjBmlPlNTmTwtxLHhVC9kWPs+Wm/qmtNdwJ6NrL6LQiYR2To9Nwd9caeAXR2WjJJT6MYh4cjPZsL5z31oISdVkkXH6TXNITHlI2d+mMXSQEacHoEIAC/CcqAt20p/99Ml9jHWaVo3sSHDxop0Rza0TQpyFU7fLjdEsOMvu4iKpjp49Mf7ETkFOKYIU/l4elgGLO8+9ZI/jWEcqYMVbSeHXTVb15D/F4U/oWSv1djGir7MZTu2PoWu7xvUftA3gehLYLb1ecZig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 09:12:33PM +0800, Lance Yang wrote:
>
> On Mon, Jun 29, 2026 at 08:25:33PM +0100, Lorenzo Stoakes wrote:
> >Update various uses of legacy flags in vma.c and mmap.c to the new
> >vma_flags_t type, updating comments alongside them to be consistent.
> >
> >Also update __install_special_mapping() to rearrange things slightly to
> >accommodate the changes.
> >
> >Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> >---
> [...]
> >diff --git a/mm/vma.c b/mm/vma.c
> >index b81c05e67a61..ab2ef0f04420 100644
> >--- a/mm/vma.c
> >+++ b/mm/vma.c
> >@@ -3417,23 +3417,27 @@ struct vm_area_struct *__install_special_mapping(
> > 	vm_flags_t vm_flags, void *priv,
> > 	const struct vm_operations_struct *ops)
> > {
> >-	int ret;
> >+	vma_flags_t vma_flags = legacy_to_vma_flags(vm_flags);
> > 	struct vm_area_struct *vma;
> >+	int ret;
> >
> > 	vma = vm_area_alloc(mm);
> >-	if (unlikely(vma == NULL))
> >+	if (unlikely(!vma))
> > 		return ERR_PTR(-ENOMEM);
> >
> >-	vma_set_range(vma, addr, addr + len, 0);
> >-	vm_flags |= vma_flags_to_legacy(mm->def_vma_flags) | VM_DONTEXPAND;
> >+	vma_flags_set_mask(&vma_flags, mm->def_vma_flags);
> >+	vma_flags_set(&vma_flags, VMA_DONTEXPAND_BIT);
> > 	if (pgtable_supports_soft_dirty())
> >-		vm_flags |= VM_SOFTDIRTY;
> >-	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
> >+		vma_flags_set(&vma_flags, VMA_SOFTDIRTY_BIT);
> >+	vma_flags_clear_mask(&vma_flags, VMA_LOCKED_MASK);
> >+	vma->flags = vma_flags;
>
> Maybe worth a vma_flags_init() helper here to mirror vm_flags_init()?
> With this open-coded, we lose the soft-dirty WARN_ON_ONCE sanity check.
>
> Might be nicer to keep that check in one place ;)

I really hate all the VMA flag accessors, they conflate things horribly - we
should be explicitly taking VMA write locks when we need to (and often killable
ones actually) not assuming that a VMA flags accessor does (they should at most
assert).

This case is even more terribly egregious - you are setting flags at an
arbitrary time, why are we asserting something about softdirty?

You may update them as part of initialisation, maybe not. It's far from a
guarantee and feels like a lazy place to put it.

BUT obviously it's an oversight not to open code that here, so I'll update the
patch to do that!

I want VMA flags to be a clean stateless thing, other than the flags
themselves. Implicit, unrelated, asserts or lock acquisitions in general should
be done separately IMO.

>
> [...]

Thanks, Lorenzo

