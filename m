Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97D1CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 05:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FC538E0008; Thu, 16 Oct 2025 01:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3C58E0002; Thu, 16 Oct 2025 01:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3104B8E0008; Thu, 16 Oct 2025 01:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FDE88E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:56:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9CF031401D2
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:56:47 +0000 (UTC)
X-FDA: 84002918454.08.D0F071A
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9692F10000C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:56:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=QX6T8jHl;
	spf=pass (imf14.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760594206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUoXGifOUwa5eJDK0H/0ZsjDJ+8Tut16wGFRi/864/w=;
	b=AildzfrT/pC7InGf6k7TDotoZoxSEXdSLKPZyJQyv7RXpLRi9h9xK101wg6yg8TIWEuAQS
	O3gdc0CkPGNzZjn2yOYKCrgMMI7szH4cZa6TPpmXsgOGdYT3dvJIhgHsqyFMnRmjEFPdYp
	mN1ra+lkK4PfIN1Gi2uwI5MYLnStJiU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=QX6T8jHl;
	spf=pass (imf14.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760594206; a=rsa-sha256;
	cv=none;
	b=Aw2Lntc/6Qwr3mb+OHL5PbCLDUbYjBDKqmpRxOubG4eW2e3vNB/S6NCLLY5fnnJnrfEbIw
	RL8+0u8EDSCZd67NHpR4R6HCHrRgPPsy1NAkhRd2xtQIlJpg67di312kXu9A+f60Xlj1at
	Gc4YlblQCNnVT+ISlvdU+vR9KUpn8Xw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760594202;
	bh=v28SW4C2/MMOF14xcWGZoBm6mtw65G/uoNs/VCAmapM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QX6T8jHlaUjF0jv51uLgXQcAH7TxnY63c9Eq9eYQ1SzI7HC8icxUPRUT+OqhI3q2a
	 aNY85XuyJmUMasOXGX4UFdMBaBlsUXPRsLEkcDqYLhYXLCC87kSqkwEAZTGLVKiRJb
	 RXsiqT3UNRlkB9Txx8SCDvpvuSTsIbsL46Dc0PEWOe5iwjhpl/Mc3MRc2tphIzbg73
	 GsyPOGwRLs/KVDy6n4d58AS2lyJfGM/dCUIdWvij/K5YtOzG7UDxC2nkMq34mPuzvY
	 LXm8HjtBEZEL6kXwi2xc4qY3QLgDb9uYZIci2jO8EuCNonyr6x82jtHXk4wRc+X800
	 5sfj3NaFXCraQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0EE9017E05FE;
	Thu, 16 Oct 2025 07:56:41 +0200 (CEST)
Date: Thu, 16 Oct 2025 07:56:37 +0200
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
Message-ID: <20251016075637.3aec3465@fedora>
In-Reply-To: <efc1d805-1613-45a9-aa15-fcc009adf27c@collabora.com>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
	<20251015153018.43735-9-loic.molinari@collabora.com>
	<20251015201737.3956f801@fedora>
	<efc1d805-1613-45a9-aa15-fcc009adf27c@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: h9dfn54t1q656hi1bdawdu6uyw8543r6
X-Rspamd-Queue-Id: 9692F10000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760594205-67668
X-HE-Meta: U2FsdGVkX19o0CKZSY2eEE8nGZyQsoUCyAlgFCShTHXl0qkoLYq5SJ2uE1hlCHDpY+EfQhH7sEliP3qBKhRsKsQsYkz3uHExUfAm+HiOY4VLqfP6SizqxyjovWHDa8ckw2hkvQ40BNR0MO34mv9SD0wCMldngYSXMRrZm3QNWyZipKmGzeyyrL3QSrcD4JMQjaqOjAfJiBQW8sX1dkUzKk/XJ5kK0btqmtoGOiLuM7FXC3nZSuToSgGWBatKb/MzHzR5Uc/w1QgY6SrYEObQBVl78DNv757nqjUrRH6kYt34HI5zJFFpAivdpaIJgEYs3Cjyl3ftx6aw3XVvyRBnDoiQ1gnhPuQMcgTcq44WXWgQtPfga03JgWbRhfGpIqE4bLWQKui7ahqJBzwZFqx2RjP4PiF2ee2VW2B3o6gjSMmxQKnc6jMZRx8xOoRYXxXCo5TDhZ7HjDjOuUh6yo0+uQr37Daeol929TMOvCvW8ccfVyr6TSPLIpExnvKUz2bjxtPnDE71AP+qxIDGXSwycez4mXaCS6pmlT3MhRz0eA8S/0FuiOivQ0Ms8f3q5+cY73ZqQNW/qhv2SsUNUTcp57BsFK1iU5KdrIbMJ7vdVOdJpsvCZKJMyRibMLn9atub24aCq58zqqrCukBcvp7Gvu6R8spxTiOHTCsw1714+cmtZqCttqCMfwIVNSbWeZFu/74al4t7oASqZPpXDCkJnGJtVBnHhvdCQD1/4HtJkfn2m0pMyuuq9wazB4hE7JrWdigbIvRPEaUvYnzfGIUtbBbXeBLUr+rzijQ5/Fy0FkqCLDlFCQjo2neSolt8ggOmi7IyJbic79VBgow8V3qjC1bSGuAXkvTMcYe9pAX5nLDIwGES4bipNO6ZHJU1c3WEvqJ3GPxCp9ynRG0MtLbMBFTlebznLVijt5TrszrFlXhBTqrlXEEcP5aTPE2Lrgw3FaeaymCWJlAEx5+Ie1C
 0vcDPcjv
 p4opiJeY9l44oNVPxFKBxtNoWOe6LLlU6LaqXqFsu0IxT36jJrx0v+57k8Zo2b9ZXrnUdOhGFyJOjBhHAIt/+6dZ1//7stwGyE60eGbA//a1N772hKWA9f4oinZVZcQrCcNH0f01qeyb40vnYUz4zfbNk7RoW/y8a4HOAfsOt4b/lQBleogeid1bS0xxWvbzO7ecF0+lvLpGUZBJgPdoTpjZkHQklgQ64h7Y101RAtIEy74b79YpPIqEpgvBuLRXikr1boqVjkI+Ds5nASfvx6RNjahTsmcPzUJpb5up8M8rwyqJmEWb6w09bLy5VkS0fQyPSw68889ZEhlNN8qR1dGjBumOGcmJOvxMgQpQ3VHXBVMnKenvKJtkiXAkZ6OXhMCCuWyUSl/jdRosByWgs7CpmK4QTUOe/yH4bY0gntzqQhyg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Oct 2025 22:41:59 +0200
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> On 15/10/2025 20:17, Boris Brezillon wrote:
> > On Wed, 15 Oct 2025 17:30:12 +0200
> > Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:
> >  =20
> >> Don't declare "super_pages" on builds with CONFIG_TRANSPARENT_HUGEPAGE
> >> disabled to prevent build error:
> >>
> >> ERROR: modpost: "super_pages" [drivers/gpu/drm/v3d/v3d.ko] undefined! =
=20
> >=20
> > I believe this is a bug introduced by the previous commit: the
> > compiler probably drops any code between the
> > IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) check and the err label
> > because IS_ENABLED() evaluates to false at compile time. So I'd squash
> > those changes in the previous commit. =20
>=20
> Right, it's been introduced in previous commit.
>=20
> > =20
> >>
> >> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>
> >> ---
> >>   drivers/gpu/drm/v3d/v3d_drv.h | 2 ++
> >>   drivers/gpu/drm/v3d/v3d_gem.c | 2 ++
> >>   2 files changed, 4 insertions(+)
> >>
> >> diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_d=
rv.h
> >> index 99a39329bb85..481502104391 100644
> >> --- a/drivers/gpu/drm/v3d/v3d_drv.h
> >> +++ b/drivers/gpu/drm/v3d/v3d_drv.h
> >> @@ -564,7 +564,9 @@ extern const struct dma_fence_ops v3d_fence_ops;
> >>   struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_que=
ue q);
> >>  =20
> >>   /* v3d_gem.c */
> >> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >>   extern bool super_pages;
> >> +#endif
> >>   int v3d_gem_init(struct drm_device *dev);
> >>   void v3d_gem_destroy(struct drm_device *dev);
> >>   void v3d_reset_sms(struct v3d_dev *v3d);
> >> diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_g=
em.c
> >> index 635ff0fabe7e..0039063eb8b2 100644
> >> --- a/drivers/gpu/drm/v3d/v3d_gem.c
> >> +++ b/drivers/gpu/drm/v3d/v3d_gem.c
> >> @@ -269,7 +269,9 @@ v3d_huge_mnt_init(struct v3d_dev *v3d)
> >>   	 * match our usecase.
> >>   	 */
> >>  =20
> >> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >>   	if (super_pages)
> >> +#endif
> >>   		err =3D drm_gem_huge_mnt_create(&v3d->drm, "within_size"); =20
> >=20
> > Why not
> >=20
> > #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >    	if (super_pages)
> >    		err =3D drm_gem_huge_mnt_create(&v3d->drm, "within_size");
> > #endif
> >=20
> > I guess
> >=20
> > 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && super_pages)
> > 		err =3D drm_gem_huge_mnt_create(&v3d->drm, "within_size");
> >=20
> > would also do, since it's likely to rely on the same optimization the
> > previous v3d_gemfs_init() implementation was relying on, but it's
> > fragile (not sure what happens when compiled with -O0). =20
>=20
> I'll remove the #ifdef/#endif around the super_pages declaration in=20
> v3d_drv.h because it isn't necessary if super_pages is compiled out in=20
> v3d_huge_mnt_init().
>=20
> In v3d_huge_mnt_init(), I'd add the #ifdef before the ret variable=20
> declaration and the #endif right after the last else so that it's clear=20
> drm_notice("THP is recommended...") is called unconditionally when=20
> CONFIG_TRANSPARENT_HUGEPAGE=3Dn, whatever the optim level. What do you th=
ink?

First off, I'm not a huge fan of the following pattern

#if foo
	if (xxxx)
#endif
		do_something

which also applies to

#if foo
	if (xxxx)
		do_xxx
	else if (yyy)
		do_yyy
	else
#endif
		do_something

I'd rather have do_something duplicated in an #else section
like that:

#if foo
	if (xxxx)
		do_xxx
	else if (yyy)
		do_yyy
	else
		do_something
#else
	do_something
#endif

But I'm not even seeing what the problem is here. If you do:

	int err =3D 0;

#ifdef CONFIG_TRANSPARENT_HUGEPAGE
    	if (super_pages)
    		err =3D drm_gem_huge_mnt_create(&v3d->drm, "within_size");
#endif

	if (v3d->drm.huge_mnt)
		drm_info(&v3d->drm, "Using Transparent Hugepages\n");
	else if (err)
		drm_warn(&v3d->drm, "Can't use Transparent Hugepages (%d)\n", err);
	else
		drm_notice(&v3d->drm,
			   "Transparent Hugepage support is recommended for optimal performance =
on this platform!\n");

You're guaranteed that err=3D0 and v3d->drm.huge_mnt=3DNULL when
CONFIG_TRANSPARENT_HUGEPAGE=3Dn, so the "THP recommended"
message should be displayed unconditionally. Am I missing
something?

