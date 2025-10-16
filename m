Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE2CCCD195
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 07:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C4E98E0008; Thu, 16 Oct 2025 03:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C358E0002; Thu, 16 Oct 2025 03:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D93A8E0008; Thu, 16 Oct 2025 03:22:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDEC8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 03:22:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12B4E85D18
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:22:18 +0000 (UTC)
X-FDA: 84003133956.30.598CDC2
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2E4E080005
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:22:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=i5cGQ7rh;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf02.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760599336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZqcJnVygG1QL1WKB2Cax/0IlnYRrGnjFnlUd17zjww=;
	b=W9XNZA39uWvUZmGmL+Q5EORdCuHM+5drPrK4bkbqLiteLOwZ/jNSVtaE2WIquCcY7WMS+G
	19EW5zeVHja3VD4pGBpndAdi8nYlQFkngdXa6ermeb0tSzVJfpFn4yB91YumOCP6DFFaz9
	cDQmo1sygTz22xWq9kscHpn9dkMOekc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760599336; a=rsa-sha256;
	cv=none;
	b=MgIoVar77iUXzqgKehce6ZUPvr4T+r3DSKb/pn/SIv6FuPez72n5vwsaFuRS5NeC9pdlyD
	4f/nayKWjXomToyCmSWIfLoBDAtdn2jAQs7j9XnvWhEMBrYbbq11pcQWz39mPecBmiccxG
	FXblx8Sfz3MDveqAfmHjcVRDCay2hE8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=i5cGQ7rh;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf02.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760599333;
	bh=IoepIVDWjMVUEYx/JMoNNzAWuBitBwwdY07odCMO0Q4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i5cGQ7rhvkjDuErtbB5sX5ggFRBd+1rGKxncPvI/s6TjTXgo1MQZQIyPkkz6s/D3u
	 J01+9DTEkAR9KOL7ZUQepTLpi9qT4NuGqRIpj7EoHAM/pR8bW9RVqi/mOFotKFX0MG
	 7OReNQZgSFwj9belOQ1F/n63dbOFBn55qZEl8WnDClGF0rsPm0Kt4zFY+kSF+9vVVG
	 UigzSGtC5g50UmmqqsV1QxvZEavI52MBBZPRGP8L4zL2l6fIsA7amz/+AFSGLSBFVe
	 6vL0YQqnYE1OqalIp70NkJnwcgKze8eI+KsFgeRZ+WlkLAdXY8GoRbY6CpqwWDalZp
	 yJb2MR/ufjNuQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 8A48017E0FC2;
	Thu, 16 Oct 2025 09:22:12 +0200 (CEST)
Date: Thu, 16 Oct 2025 09:22:08 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: =?UTF-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, Rob Herring <robh@kernel.org>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Melissa Wen <mwen@igalia.com>, =?UTF-8?B?TWHDrXJh?= Canal
 <mcanal@igalia.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?B?TWlrb8WCYWo=?= Wasiak
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>, Nitin
 Gote <nitin.r.gote@intel.com>, Andi Shyti <andi.shyti@linux.intel.com>,
 Jonathan Corbet <corbet@lwn.net>, Christopher Healy <healych@amazon.com>,
 Matthew Wilcox <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH v4 08/13] drm/v3d: Fix builds with
 CONFIG_TRANSPARENT_HUGEPAGE=n
Message-ID: <20251016092208.2b8ae536@fedora>
In-Reply-To: <02c8447d-25fc-4503-873f-0b2932e218ec@collabora.com>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
	<20251015153018.43735-9-loic.molinari@collabora.com>
	<20251015201737.3956f801@fedora>
	<efc1d805-1613-45a9-aa15-fcc009adf27c@collabora.com>
	<20251016075637.3aec3465@fedora>
	<02c8447d-25fc-4503-873f-0b2932e218ec@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: inwt5grd47pe4yb1bzyjrjtgnikkpumx
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E4E080005
X-HE-Tag: 1760599335-314364
X-HE-Meta: U2FsdGVkX1+5vVdJ0K72jszs9JjW3uwnbQVKoSOmOE3Mo8IMdfHkH8K+Jso1y6hbhBH+/XSKlndVV30beyJNzXkQlTQSHBoofAt3V46Q8poDvMQqDpYC8NtXzLMb0sDOgp7ScCrrKWfKZgn8OQAvJ6Fk4IlJRaLg7Gf3LvIkiWyvjMg7nehtQJDI0/hDeSO1LRCfNwFQIsotHytsk4+m+kkEvuvtl+FwzALMnccggjlgsmoefWQsLArnRasdM49LvNq1Hrtp7o5eoSNKrjQGBpQj24s4qnaoStvhP5W7jundU7dR7TxPr993TnJtnE3vjQBTtJk+n//0UD671sTUpg+da2c/2H6AOyJJX4Uu2azX8WGEc09U0VGY0smynZ7ajaOx6kpeKQ+2Vvht867PRnouRLevEDyMLyz/MTnOeoWndIrbBf8b9pidrX10Q8Pzv4GaJyMy9cjp9ZewNC/aqzCN9xZeM63ULcsrlqkJ7zyvU+7gsd/vflyd3B3aXLhfmhCmBFD38iGJtdPAid/qWk/RTu4dGeMGSFkA/GoUsYaOmd1IQk+IxfFV7cn1vk6xCdMcwpbLKAXIC8zRHF5oC1abCle1OGXEipRTDgFy/bP8FexuVfVxfNMdZb3PWTdwXdEz+hZtMOEn7lV9UVoSQLbGZdq9cBnLpyo7KxPc70PI4hPbnhUSeP8Uedc9Ob3413FrLDFsg9TKzOAjzluZISeQZX1B5BrPHCJgHmgoAEjSG2a8H7nVGwIM4NpqcRgABbSDsvpsapBGJJRGoyEkiJN44jMUoQUhGpgQRaoyXOG1TxAD4ac7mpqwWyJY+paO+UTNoGkbRtReURxi1PE4WcU2Sq/0ypF0nIgIvNOMWapxKgFr3RE1O91IY8J5EyYBWLGiIEmdu3S7Xs7dJE34OGsey7twLgV8ZNja/4HUVyMPWlwKYt88zCPz9zcALuFQi+dJs2ZKpZwtVI+I3yg
 A9cjqZ/q
 E3Qka9fnN1HZP+734NQfuwOb2grOyHS4DFFdyRF5o65fp8yBzZ/Ew/mfmYPQc7rBiNIz5sagqaRDlvJnfoPodviFBddXZSOPwsQH/l2Ca8MxwTe94jE/HBQA2BdkPHpGS/nIT5eMBw8NHK3ivVxKghrvHPjr8+NB9AW8db058IZhf/QZ2F7Hzl1DbLOF6nM8rzNrZXjJiPN798Kor9dzS7vlGMDqVF44KDQGOxi60PsPGLUUUDZs9J/5qDnmeGO++ZuloDYPHiAhR/iUII0/yLt/gsp7VkbgQofNusm3JpUAYk2rvJBAoR1tJD/czxX6uhJicaHUDETcmfy1EYzsrx6QJ5vxHnDQTVuWM/FjQXILc+n+fv1ZKJJVCZediWAamuXtLiYNU+Ena+ZXrhWs2g1JI/KL41SNcQUZRdlxn7heFNpg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Oct 2025 09:09:26 +0200
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> Hi Boris,
>=20
> On 16/10/2025 07:56, Boris Brezillon wrote:
> > On Wed, 15 Oct 2025 22:41:59 +0200
> > Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:
> >  =20
> >> On 15/10/2025 20:17, Boris Brezillon wrote: =20
> >>> On Wed, 15 Oct 2025 17:30:12 +0200
> >>> Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:
> >>>     =20
> >>>> Don't declare "super_pages" on builds with CONFIG_TRANSPARENT_HUGEPA=
GE
> >>>> disabled to prevent build error:
> >>>>
> >>>> ERROR: modpost: "super_pages" [drivers/gpu/drm/v3d/v3d.ko] undefined=
! =20
> >>>
> >>> I believe this is a bug introduced by the previous commit: the
> >>> compiler probably drops any code between the
> >>> IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) check and the err label
> >>> because IS_ENABLED() evaluates to false at compile time. So I'd squash
> >>> those changes in the previous commit. =20
> >>
> >> Right, it's been introduced in previous commit.
> >> =20
> >>>    =20
> >>>>
> >>>> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>
> >>>> ---
> >>>>    drivers/gpu/drm/v3d/v3d_drv.h | 2 ++
> >>>>    drivers/gpu/drm/v3d/v3d_gem.c | 2 ++
> >>>>    2 files changed, 4 insertions(+)
> >>>>
> >>>> diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d=
_drv.h
> >>>> index 99a39329bb85..481502104391 100644
> >>>> --- a/drivers/gpu/drm/v3d/v3d_drv.h
> >>>> +++ b/drivers/gpu/drm/v3d/v3d_drv.h
> >>>> @@ -564,7 +564,9 @@ extern const struct dma_fence_ops v3d_fence_ops;
> >>>>    struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_=
queue q);
> >>>>   =20
> >>>>    /* v3d_gem.c */
> >>>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >>>>    extern bool super_pages;
> >>>> +#endif
> >>>>    int v3d_gem_init(struct drm_device *dev);
> >>>>    void v3d_gem_destroy(struct drm_device *dev);
> >>>>    void v3d_reset_sms(struct v3d_dev *v3d);
> >>>> diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d=
_gem.c
> >>>> index 635ff0fabe7e..0039063eb8b2 100644
> >>>> --- a/drivers/gpu/drm/v3d/v3d_gem.c
> >>>> +++ b/drivers/gpu/drm/v3d/v3d_gem.c
> >>>> @@ -269,7 +269,9 @@ v3d_huge_mnt_init(struct v3d_dev *v3d)
> >>>>    	 * match our usecase.
> >>>>    	 */
> >>>>   =20
> >>>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >>>>    	if (super_pages)
> >>>> +#endif
> >>>>    		err =3D drm_gem_huge_mnt_create(&v3d->drm, "within_size"); =20
> >>>
> >>> Why not
> >>>
> >>> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >>>     	if (super_pages)
> >>>     		err =3D drm_gem_huge_mnt_create(&v3d->drm, "within_size");
> >>> #endif
> >>>
> >>> I guess
> >>>
> >>> 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && super_pages)
> >>> 		err =3D drm_gem_huge_mnt_create(&v3d->drm, "within_size");
> >>>
> >>> would also do, since it's likely to rely on the same optimization the
> >>> previous v3d_gemfs_init() implementation was relying on, but it's
> >>> fragile (not sure what happens when compiled with -O0). =20
> >>
> >> I'll remove the #ifdef/#endif around the super_pages declaration in
> >> v3d_drv.h because it isn't necessary if super_pages is compiled out in
> >> v3d_huge_mnt_init().
> >>
> >> In v3d_huge_mnt_init(), I'd add the #ifdef before the ret variable
> >> declaration and the #endif right after the last else so that it's clear
> >> drm_notice("THP is recommended...") is called unconditionally when
> >> CONFIG_TRANSPARENT_HUGEPAGE=3Dn, whatever the optim level. What do you=
 think? =20
> >=20
> > First off, I'm not a huge fan of the following pattern
> >=20
> > #if foo
> > 	if (xxxx)
> > #endif
> > 		do_something
> >=20
> > which also applies to
> >=20
> > #if foo
> > 	if (xxxx)
> > 		do_xxx
> > 	else if (yyy)
> > 		do_yyy
> > 	else
> > #endif
> > 		do_something
> >=20
> > I'd rather have do_something duplicated in an #else section
> > like that:
> >=20
> > #if foo
> > 	if (xxxx)
> > 		do_xxx
> > 	else if (yyy)
> > 		do_yyy
> > 	else
> > 		do_something
> > #else
> > 	do_something
> > #endif
> >=20
> > But I'm not even seeing what the problem is here. If you do:
> >=20
> > 	int err =3D 0;
> >=20
> > #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >      if (super_pages)
> >      	err =3D drm_gem_huge_mnt_create(&v3d->drm, "within_size");
> > #endif
> >=20
> > 	if (v3d->drm.huge_mnt)
> > 		drm_info(&v3d->drm, "Using Transparent Hugepages\n");
> > 	else if (err)
> > 		drm_warn(&v3d->drm, "Can't use Transparent Hugepages (%d)\n", err);
> > 	else
> > 		drm_notice(&v3d->drm,
> > 			   "Transparent Hugepage support is recommended for optimal performa=
nce on this platform!\n");
> >=20
> > You're guaranteed that err=3D0 and v3d->drm.huge_mnt=3DNULL when
> > CONFIG_TRANSPARENT_HUGEPAGE=3Dn, so the "THP recommended"
> > message should be displayed unconditionally. Am I missing
> > something? =20
>=20
> It doesn't really matter here but I just thought it would be cleaner to=20
> explicitly let just the drm_notice() because the compiler doesn't know=20
> v3d->drm.huge_mnt is always NULL here and would emit a branch in=20
> CONFIG_TRANSPARENT_HUGEPAGE=3Dn builds.

Okay, well. I think it would matter if this was a hot-path, maybe? But
that's clearly not the case, this code is called once at probe time.

> I know your dislike for this=20
> pattern now, so I will stick to the suggestion :)

Actually, I would probably stick to the original

	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && super_pages)
		err =3D drm_gem_huge_mnt_create(&v3d->drm, "within_size");

pattern since it worked so far. If -O0 is really a problem (didn't
check if it is), and v3d maintainers care about it (I doubt anyone
forces -O0 to be honest), they'll fix that in a follow-up patchset.

