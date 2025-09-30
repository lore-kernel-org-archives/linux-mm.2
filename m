Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D513CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 16:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2108E0018; Tue, 30 Sep 2025 12:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91CF8E0002; Tue, 30 Sep 2025 12:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80E38E0018; Tue, 30 Sep 2025 12:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B18A08E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 12:52:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 64FA913BB06
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:52:24 +0000 (UTC)
X-FDA: 83946509808.17.792F122
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf30.hostedemail.com (Postfix) with ESMTP id 89E5580015
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:52:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=eIpbCLbB;
	spf=pass (imf30.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759251142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzDW5ATQqGrOAdv7EI0KUoGNLMQXHstRTksxpnYMqg4=;
	b=fxzum7MeVJLKK2JnqCed8jRKtZXZ92sxf4BuyY2gaDO6OLFYOXfArwMEo3j59Z83CRhk+n
	FLE08bQ1yLVRL1t2Z4VSMkkHA0VpYR70RpGFkaaP2EeJK2FL//zxtkw/Qf7RWohdkoi8ff
	ddxlaoGn8kKqaWfiG8HS+4Kub8/63XM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=eIpbCLbB;
	spf=pass (imf30.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759251142; a=rsa-sha256;
	cv=none;
	b=mv8XkOKH0TAEuuB1y+3j5EMplulh+RaVwK3KsLUb2dgJiCSH3T9Fs4k4UeUw8LmwxLBG23
	tp18iAV9Wv9Ls/9DK3ewuMNnhHRE14B0UfV56y76XoPgzSSvpl3wXLwG6606por6zJ5HsS
	lRkknEyaK4GHdhjI4XHJT2KXr1jfCxA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759251140;
	bh=6F5HZUHWmfM84MuVuhHdpmdFxiNcPSoV525Ehw7vQXQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eIpbCLbBiLlNsrWXZWLfs66puqbb8GGKuERAQ4nZEmXBOeHs5dZfqwFFZya2GlnW+
	 0E+jzeUfKSUR1efBo4yJtRnCAGCWv7jkkMzEpurVJKuD0P6Wo2RUiGlLIB1C6y9TRI
	 XE6zlk+0Z5N6eS87R2l9pzogJel9iWxzIDGRVCWqG46ynhlb/Hl30lcRbvi6MsEd6p
	 bgR2wSGIKSkRVuPldmehKVjZCoZP3TTid7rBWzRacr9VyvSke79j4L3wZSM8IgCUN3
	 cKoC15XoXGr3CHSWntaNGPAzy78b+jG3El5BgLK5lhf/5usxv0ExM02bxdNQKUYpOH
	 gZ3Arl9SmvKzg==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 19C1317E02B0;
	Tue, 30 Sep 2025 18:52:19 +0200 (CEST)
Date: Tue, 30 Sep 2025 18:52:16 +0200
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
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org, kernel@collabora.com
Subject: Re: [PATCH 6/8] drm/panthor: Introduce huge tmpfs mount point
 option
Message-ID: <20250930185216.0219a542@fedora>
In-Reply-To: <d3b927b9-ddcb-492a-a72c-d42abbb11cff@collabora.com>
References: <20250929200316.18417-1-loic.molinari@collabora.com>
	<20250929200316.18417-7-loic.molinari@collabora.com>
	<20250930123416.4ff59b11@fedora>
	<d3b927b9-ddcb-492a-a72c-d42abbb11cff@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 89E5580015
X-Stat-Signature: xe6e87pc5zd7tq7j5dw6rndsjfho7t98
X-HE-Tag: 1759251142-273830
X-HE-Meta: U2FsdGVkX181ir3zYVoCR73lNhi19uDjOxUZR57JNqF0UksfQ4tuitGgHDtJQMqXQ2JrsQWWsbCypprqyhj4g3IUl8aiW3V/ctgFKJN1wOe6L6ZEuWmuNTQrkfALBSOwh/V7pzUa58fkD4Ya+FVh3JQVjCUo61QqDE1WCtcBjrqUyw8vbHU1KaRjbolQczodegz5xBVxCYiC0rrhvCX/6sX3BLQbOPHqDXKyUzpCyItS9OPJVLpYjSiDxBK8B+tADgfG3xc6wNuys3pICZnNSv9w4ThmfeoD1mmAJHaaxT3jYKGyDxF2jvzB7psDOFwZjDwCc48XNAUsFtRrufL2FMzJX5JXqiRUmV8p0bfjt17LZ6H+h/QR7z5JrwZQGK2rmbDv/LMWRgAs9l/wL7wCxvKJT9HQRqofzbKyje8ykHc3y0LMQcdrjiFP7LlSw7H4T3WIVMmmBbZVTALoxqOrR0JNS8LdtmGu4Nl/AXiUlldCZYeUuM/MFbfJUk54BIZtO78PfwWjZxIC5mcw7DJdCsNMUyqQm+9LfO1FWrYhCUZMdClOQIkOLXM7S1w0qg3XUum2RNmwapPjDQzrBNPLgwDgSE4WHSiO/lnDQ7mjZ0e1O6EROJmEia5BB+hcEPE5oKQLyiFf4IzrRAr61GTq3kM/PYWDE83BMOvdKSNssRYT0lsv4o/Qs4tPcn14+zdBZniQ4/gjN+fxhOHiQSGSWDAG5UwL5zWgFN5OqzzFAqub4TuFMur12HNlvqm1y6PMyOm/joA+7WFtB/71IHvlgRqqxUKjr0WQ2KQE6WgKs8TdR8pV0YXO/QPlP6KRDXp0mrvJQyuH6e5B0lYePOLnLFKvy9IveqAK+zmXWbiuHW0yqRThJ1QfVJPPLcGXQKbERXCPydOX88P4IQJ4OC2LWcEpHu95eh3Oy7CPr2uQC8Eex1nMkFczuJAlBSzEg8DqEIWpdt5T8Tlr8NSc7dq
 uO2O4dO7
 81wvfi1v15CU2+yTZC+0AHwLdT9EV/c2s4eXRJV/wNMgJ/ROdWMxIIB0UzUE7DKe4DTGWO2E925XXKWhPqbEnTOE+mbohybN6UL1KQgAxrTQmlP5+WxBckIPEuCzf5bnlFFoenKUBoqtkGVc5tIm9dw0Oiw/3SAUQbCMh3nRvcvcNrgu2m27F2f8GH7sqsUEHUfyxsDyDybYoy6LXz1BN765MaFRDFdDOzmQjgwlJa9N4vuWAIB/LGw4TbEu/BtH0DhkczBes9zmmbPRpV4QSS42t9qSvX0/jrrANqoHCVhU+ALqpRdV3gpOTGmFEJwEDLO5Fc47tNRCMWAHVxhRbZ+dxM05fcNn6pGMX5tPatGbEK42gp3LlLwi8Bw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Sep 2025 18:31:11 +0200
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> On 30/09/2025 12:34, Boris Brezillon wrote:
> > On Mon, 29 Sep 2025 22:03:14 +0200
> > Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:
> >  =20
> >> diff --git a/drivers/gpu/drm/panthor/panthor_device.h b/drivers/gpu/dr=
m/panthor/panthor_device.h
> >> index 4fc7cf2aeed5..54ca61567426 100644
> >> --- a/drivers/gpu/drm/panthor/panthor_device.h
> >> +++ b/drivers/gpu/drm/panthor/panthor_device.h
> >> @@ -135,6 +135,9 @@ struct panthor_device {
> >>   	/** @devfreq: Device frequency scaling management data. */
> >>   	struct panthor_devfreq *devfreq;
> >>  =20
> >> +	/** @huge_mnt: tmpfs mount point with Transparent Hugepage enabled. =
*/
> >> +	struct vfsmount *huge_mnt; =20
> >=20
> > Now that we have a helper to create a huge mountpoint, wouldn't it
> > make sense to have this field in drm_device instead of having each
> > driver add a huge_mnt field to their <driver>_device object. =20
>=20
> Not sure this should be enforced for all DRM drivers since most of them=20
> don't create separate huge mountpoints (only 4 for now including this=20
> patchset) and I guess some maintainers might prefer to depend on the=20
> sysfs interace to enable huge pages.

I'm not saying we should create the huge mountpoint by default, but if
this is a generic helper, it makes sense to also manage this mountpoint
internally. In the end, it'd be a small price to pay for drivers that
don't need it (the size of a pointer in the drm_device object), and
with this in place, driver wouldn't even have to call
drm_gem_shmem_huge_mnt_free() manually (can be automated with a
drmm_add_action_or_reset() calling kern_unmount() inside
drm_gem_shmem_huge_mnt_create()).

>=20
> >> +
> >>   	/** @unplug: Device unplug related fields. */
> >>   	struct {
> >>   		/** @lock: Lock used to serialize unplug operations. */ =20
> >  =20
>=20
> Lo=C3=AFc


