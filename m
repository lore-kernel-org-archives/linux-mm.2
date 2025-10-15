Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E779DCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 13:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CF3C8E0033; Wed, 15 Oct 2025 09:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480A28E0020; Wed, 15 Oct 2025 09:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD3A8E0033; Wed, 15 Oct 2025 09:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2C68E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:13:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E149E1DBA48
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:13:03 +0000 (UTC)
X-FDA: 84000389046.20.9EAB83C
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id F17EF4000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:13:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="m8Ob9jb/";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf04.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760533982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HvqBNDKYzNLYuvJ6GCsxKgFo8vTAb1l0oaB8RnCFMGk=;
	b=XiYEmGKigGKglJEdpUot57orCoBJ5O2ZcNnjw6iaVp/OzmSpCY7A41NN3obCbARbJnOKII
	97q14uJfJLHvT1SplCshrzJ/2lAnhGWInrmy1kCceL7aDrzciLcVPRiE3nEvUaMkQyvbw0
	LT091UbOTPRjUpjKdS791zI7/FE7ACE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760533982; a=rsa-sha256;
	cv=none;
	b=qntNq07AQrPSMbwZc1ORWgn6mElCdkyyMOvos+X1V7dKx61nzRpJqxRU6sEbvvWJVfQkji
	LXuQVhl/hkY4iodBLNao9wnquRdscBGe5p6pdJWNUGpWAOWx5YBfdXes5Sx6TLmGRy720H
	PjoM8uRPWlx44/3HxbMvlAuvSmHdD+0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="m8Ob9jb/";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf04.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760533979;
	bh=CbnARJ1NcaAYMxMWl6wrepneykP7YTXb9rnB9JY3DjY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=m8Ob9jb/yqmdZN5gbXCzgVebh2Me0gTPCS7skTCvVHKVKZb+E7d3Ne+V6rwVXRlDt
	 VYSG1AI2Zntyba9pSD9ieku+zAV8xZnQZKl1w135SeDH5V4jRI+7aCCI29CMlO7vgi
	 EB2NhMEXtEfUYG/7m5wKCKYVi2mOj9ZciBV77NvzD2jEhcQknQBWaf5TS/Gqz67Q2G
	 6WKnH7+N7X6nLqyebw7YxBL1E6GQZIu4uWTpxiRS5TaV9n6PV6zCSts1MNZuwssU6O
	 IGZzlxOQrCxo4Rfk1xY97c/4o8aeVa8stN4cxnQC+n8Zo7D1h0zeDOcmkFdwD1x9B8
	 boa/A3UcsyrGg==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 27C4F17E05FE;
	Wed, 15 Oct 2025 15:12:58 +0200 (CEST)
Date: Wed, 15 Oct 2025 15:12:55 +0200
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
 Christopher Healy <healych@amazon.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, kernel@collabora.com
Subject: Re: [PATCH v3 07/10] drm/panthor: Introduce huge tmpfs mount point
 option
Message-ID: <20251015151255.6f314a11@fedora>
In-Reply-To: <6f1fb1a5-5d6f-4ebf-bf12-3481d360fb7f@collabora.com>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
	<20251004093054.21388-8-loic.molinari@collabora.com>
	<20251006092856.02fbfd9e@fedora>
	<6f1fb1a5-5d6f-4ebf-bf12-3481d360fb7f@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: i8i4fq9b9tqmetf77zzzhsftq9okki5w
X-Rspam-User: 
X-Rspamd-Queue-Id: F17EF4000C
X-HE-Tag: 1760533981-970479
X-HE-Meta: U2FsdGVkX183iQqOxilSDVWC9p9n6fDpWrcwiQOUbH2u9PCsrSY0+UGC9rm3LNRwhYdHpAzzJ7gNnUtQfYNq5zBuosk9iJPJgq4dNhRUod+Txi6bT2H4Z7uK6E3KdUdQXdeNcrltFQ2MyFsmayfPx0Ig/8EdCVIy2eG32WUfwfWZjKxsezUb11gqlIaRGhf1lkQSGxsRXcO9wCUaRLB4gTaZMJMu+USuluEqqYRMTNxetvtZJSk5pPaF14L4CjUA9uOs1rLXsgilpS2B0w5ppIn6UjZlO1d6+YSfoKErMyHkEoUlEEmGM7o68Yeoo3PaYwspF2ixQtc6507UNd89tOQva2IvkPCNHWKE2YwJkUbd0jG4kiKIVCkJGKLdpc1HTftdFY5c0zu11t12oJ47yeJAq7KxAJsk/V/hIM92UspGc/PQCY1lJWlG8p8ar8cLeEmZSsbQHCNtikFRN8uwuuVO4hahmf7LwRhcVsZO+bCoL3uKCGsEEqsOzc8Q8vzln57v55kXJ6JzEWFT9DSDag1L5jmdV3O+avAXEnxlrsDYqPgMwg5rvRUeebDpbb5eFXT3xOp+CHfGrUgmqWXvG59yXBGVccYsQJkKidvjlnw54CM5qdTU+s4RkKE4h/9alwlE++H9RzL24yE2qwIVK9/HvIX/iY5BqLJMxZDKkRKCxSRk0t9zUFd5aBFAyp6mBzXpFy92iN15WctfMYzvn4v+UaVM1Knxhtjng9GGSUv8v9VBj8HBhKOImQRFWFRWO7sXMLyBicRi+5h5lsaxnUuAYe+RJkD+yNV69Ppu9rHq0Xc6TMDhXeMHblgy5PGboCAOLpJRYltZQFIh4C+FmyiF1n0H6HRWFjSTFq3aUgyaRqj11d4cuQ3xZKdOMmzXmSeY2w+XFZBVQBUu8qMBfCBmL11ioLoAG/ddvSbp5/8uqSp5FXjc/TrB59Dt10X1rNi8fvAEyH3zz2pjnaT
 qnPiWxzS
 O/9rlYcGVZaBHHXDNw4xeUA0T3Nmd//0C1442h+VAnMOX+pBm0REbGfpyhuj1fEnfMoynV00XrbkevhcRxH/B8KHNQx3lfRj03tPr1aWkZkj5bceOT92pA+lcTNx3If3fLQ5sJTpiRwrtihVCJpmDztWz0qEwVONBbNFqHEizDJCMDvBHE+GJHldxdQfpgNuFde8RZteteGyp6cHuPCS/cmOHRN98S94V2Z9plk67Llja9aT6tkv72EBAVFQvczbkKvF0CWw3UrR7RQxSTBZ/IWA1jcu2IIm61zesi3qo2yEDM7RudlALcou24FWjC4A8fLe30Cr/Lf6t0mVIFe29RTfXJkylQr3xCCWfjOPMC49gc74JZkh8i7WFe61Oj8TBYr+FFndSm4ctmqw76cDY0Yjpqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Oct 2025 15:09:31 +0200
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> On 06/10/2025 09:28, Boris Brezillon wrote:
> > On Sat,  4 Oct 2025 11:30:50 +0200
> > Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:
> >  =20
> >> diff --git a/drivers/gpu/drm/panthor/panthor_drv.c b/drivers/gpu/drm/p=
anthor/panthor_drv.c
> >> index fdbe89ef7f43..a2be3b904ca2 100644
> >> --- a/drivers/gpu/drm/panthor/panthor_drv.c
> >> +++ b/drivers/gpu/drm/panthor/panthor_drv.c
> >> @@ -1623,6 +1624,12 @@ static const struct drm_driver panthor_drm_driv=
er =3D {
> >>   #endif
> >>   };
> >>  =20
> >> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >> +bool panthor_transparent_hugepage;
> >> +module_param_named(transparent_hugepage, panthor_transparent_hugepage=
, bool, 0400);
> >> +MODULE_PARM_DESC(transparent_hugepage, "Use a dedicated tmpfs mount p=
oint with Transparent Hugepage enabled (false =3D default)"); =20
> >=20
> > nit: I'd go for a slightly shorter name, like [panthor_]enable_thp. =20
>=20
> For v4, in order to be consistent with the "transparent_hugepage*"=20
> kernel parameters, I'd prefer to keep the "panthor.transparent_hugepage"=
=20
> (and "panfrost.transparent_hugepage") module parameter name
>=20
> I could keep the parameter name as is and change the variable name though.

Fair enough. Let's just keep things as they are in this version.

>=20
> > The patch is
> >=20
> > Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> >=20
> > regardless.
> >  =20


