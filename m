Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C302CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 17:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737588E0011; Thu, 16 Oct 2025 13:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70E9E8E0002; Thu, 16 Oct 2025 13:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64B548E0011; Thu, 16 Oct 2025 13:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 538EE8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:30:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E19EAC03CA
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:30:35 +0000 (UTC)
X-FDA: 84004666830.08.AD4C1E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9AC4340016
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:30:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=biocjUso;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760635833; a=rsa-sha256;
	cv=none;
	b=BUVVTH0OJ40oXNvgymY/oPTbG0Obunh6lizFMS1RBc6IOLTjj9AN8avpxronALEymVZ0Nd
	G68fFjVUNUuaCNUA9wUNoiOh+cSDzqjH5Gsx1CP6O73arxhFEM5bCoaptGXZuCxIZWN2jq
	Ye7lnQM8uxx5RASAPEXXL8jBvKPz3+c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=biocjUso;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760635833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yaSrB6WrfstavEQy5KHLKblsYTdGUmvU5liHybQtBtk=;
	b=ibwwKgKRWf6waU2o/NYaAx5ydaYUv73WO+vyVQQPlREJDDNBOSD2rKGYdZLAg5q63P0NwZ
	r//0ISNK4NoZJTPGHTX+faHJWh9nWrjdsLMg8uLGgl8dWGJCGK214QlAPTTLgJG52ehcHb
	mhCeuwUZrg5BgwGzsUsvEGWJrcCgF5U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 378CC40B1D;
	Thu, 16 Oct 2025 17:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A100FC4CEFE;
	Thu, 16 Oct 2025 17:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760635832;
	bh=O1PeDs+ueaf6tTqY3uTzigyg4af7TbN5NLCGU6ditm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=biocjUsoQunlT8LPzGwXoaMftmMLyNtQUGK0upt4nFv+6zS5o/8KHL/QlKhW7RNT2
	 lMMpYFTZJJFVzKc3ct/vaGiAtKMfUGXWP5RVolXqJafCGbcmeeI1xHQuv9tFduCxpK
	 lI9LD2YQdSwYy7rZ62XcwPFSfYGqakBf64Q5+oVvFkR68zODKNu1Z//HuEJe8YiPqF
	 aLEhCGh6/z7jqnre8xvXnUaWEdvV9OX9JwdlqPIcQI2jKnMFCg27Ar2PT4IC+bexEQ
	 C+WbCmS1vDnv6k1Yrt9Lvf240+FMRYUZ1PzmG10etWJrf6es0p9lot8KZHSvVd7vrO
	 V5AtGDnq1aN3A==
Date: Thu, 16 Oct 2025 20:30:24 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org
Subject: Re: [PATCH v5 6/7] liveupdate: kho: move to kernel/liveupdate
Message-ID: <aPErsBFxgxJ5VntU@kernel.org>
References: <20251007033100.836886-1-pasha.tatashin@soleen.com>
 <20251007033100.836886-7-pasha.tatashin@soleen.com>
 <aO9WvF_WMkKKqYo5@kernel.org>
 <CA+CK2bBC57v_CYdpT-Jcu4LX4MxZZ5CyAJBVTZVXdMnCXR-AmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bBC57v_CYdpT-Jcu4LX4MxZZ5CyAJBVTZVXdMnCXR-AmA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9AC4340016
X-Stat-Signature: 6mxj4u4q9djebpj6yitbagwth4tynk8i
X-HE-Tag: 1760635833-610232
X-HE-Meta: U2FsdGVkX18Hif6fbqby4OvB7shVw3jwVG2sQJu8eqOc8v9aUSvKJ9KRDajiHVy/gcclSaeluulABTFJ5u26S2BcjAi/G+P8gDUGACsGMpo+8FkORhMeZcNDwUJ7BXHuGN4GMYXKqalrXMWTjXFA0co/SpzZ0GiFmoeaJURxEL0B1dV+/+UV/0BYmxuR0ORUKu5XbGtuxC56USf/ZPiGCd13efmct4c9RjNeCX19IE6Dfsnty5cA++h4nA06tzJm+7CyCLCSUZAjFWIGIzrn5UL6JJXtDCDMpEEFgbPGEy0xobkh6Q/Wv7ewZNPH3uCJwogBciMeeNRVhk3c3OJt7nY/AdGZMGWUR3FQFPaKRecUsY/QMsvoGXV58pYBhP8mVVXNQNSjdRkIWJyACosghutKD4a3o64Zt2kkyjHI+rYdBl4NMKLSZJ24jBfpGazPOR9/9Z+V7n8jrKK9r7UL63UBbrD0L/MgvWz2ZY/vIzsKrmHnBgPNHH+I3HizLuLYkWxTLWwDb2EeiubL5zEMNJ+3VrxR4WGImXqewKEu5G6XTSsnEE+gZSw8snyGHF7TjJFO6cn90rUDaeKvkwsbTTbee03sajxlN7xiIyYYNxn8isICfDIeWab5qbGnNSJ9gqVlL+vCcZoAXSjd2d5WX8y2Fgkd0ndpYZfJxRW54ZKZrOsVmtVJq3LJcK5dpW3611Ec63dmFsg8P/rZHqwZ5179ogmPHCLzFClWVlYSwwsB2JSAzo8/0vbPZa5aICMN+oxBrkMqU6rhhOO1A1GUyh/AFPuj6LgU457EoA67mdUfR1HgOW+j1ll+nSEfGJGhNn71+zOK/DgOqivQvuGM3c9HSlTsCHGqYt//zx+ZRC4a80n+F+qRK9b4iwDYiYVohgu+0bDSXWMvRBrTlgi367sM9KS4BUkEFVCz7kIPLdCz5nZF/Et5CS/uwGjRjAwAenb9I7mFpaA1Lnhiob2
 HbHcwi9f
 FP77OI7j0M8EOPE6Lit+V0T8m8SxwQoKwnuX0serHqtEK0+H3EBpqknQ3Alg5iy5VuD7Xc/wOSS0PNSh2096wT6q/ly3ZsyzZMulPIgcU3A9bKVImh80UMWN/Oqx4LQfw3Dprdl+5BBHdUCkFLZB2GEmnenilodUHN/oSDgomS+tY1EAUBL+fjYtgjJy53/e0mEFP/NRQZVeJipsr0Q4M1aFyjG4mo35UuloQTB3PcieLllfEeEWV2NK0SubgHW1fJjBcS1N18EylX6KY/phPaG6wQRWoLDV+tSZBMkCDFbh0Vnz0n1/DGwsCqAkLOpwum+sL2R7sJb/rNFwayhYdNKlYz0lHxg0o9G6Vz54UwYG4VjVQgw62b+PvAlBINQnl8jX2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 07:50:59AM -0400, Pasha Tatashin wrote:
> On Wed, Oct 15, 2025 at 4:09 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Tue, Oct 07, 2025 at 03:30:59AM +0000, Pasha Tatashin wrote:
> > > Move KHO to kernel/liveupdate/ in preparation of placing all Live Update
> > > core kernel related files to the same place.
> > >
> > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> >
> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Thank you.
> 
> >
> > One comment below.
> >
> > > ---
> > >  Documentation/core-api/kho/concepts.rst       |  2 +-
> > >  MAINTAINERS                                   |  2 +-
> > >  init/Kconfig                                  |  2 ++
> > >  kernel/Kconfig.kexec                          | 25 ----------------
> > >  kernel/Makefile                               |  3 +-
> > >  kernel/liveupdate/Kconfig                     | 30 +++++++++++++++++++
> > >  kernel/liveupdate/Makefile                    |  4 +++
> > >  kernel/{ => liveupdate}/kexec_handover.c      |  6 ++--
> > >  .../{ => liveupdate}/kexec_handover_debug.c   |  0
> > >  .../kexec_handover_internal.h                 |  0
> > >  10 files changed, 42 insertions(+), 32 deletions(-)
> > >  create mode 100644 kernel/liveupdate/Kconfig
> > >  create mode 100644 kernel/liveupdate/Makefile
> > >  rename kernel/{ => liveupdate}/kexec_handover.c (99%)
> > >  rename kernel/{ => liveupdate}/kexec_handover_debug.c (100%)
> > >  rename kernel/{ => liveupdate}/kexec_handover_internal.h (100%)
> > >
> > > diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> > > new file mode 100644
> > > index 000000000000..522b9f74d605
> > > --- /dev/null
> > > +++ b/kernel/liveupdate/Kconfig
> > > @@ -0,0 +1,30 @@
> > > +# SPDX-License-Identifier: GPL-2.0-only
> > > +
> > > +menu "Live Update"
> >
> > KHO can be used without Live Update, let's make this "Kexec HandOver and
> > Live Update"
> 
> IMO the current menu name is OK, as it is an option presented only to
> users configuring the kernel, my rational for that thinking is that
> KHO is an independent module, but it should be enabled as a dependency
> by other kernel features that require it.

I think that we should allow enabling KHO on its own. For example, preserving
tracing data in reserve_mem usecase does not have a strict dependency on
KHO and it surely does not drive it. 

-- 
Sincerely yours,
Mike.

