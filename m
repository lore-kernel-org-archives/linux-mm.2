Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6AA9CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 10:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7DDD6B008A; Sat, 10 Oct 2026 06:01:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2EEA6B008C; Sat, 10 Oct 2026 06:01:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BC36B0092; Sat, 10 Oct 2026 06:01:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82A316B008A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 06:01:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9220F1207C4
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:01:34 +0000 (UTC)
X-FDA: 85306274508.30.709D2DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id ED58C1C000A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:01:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CXv0u/LL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791626493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxghfkk9ZcOzzHrH4POV+dHpr3b3+ZDhOKp5XX6zWMA=;
	b=mUO9V2MCkO0QxKdR0z5Qc9O3+Ufv9++WQ08s3S9yrcYoHI4aKDfKWLPq+Npq5KoyJaFX/9
	8pLeA583s88la+uMI33mbG54dDfRbnBKJ7lwV4uMtb9HHIHTac4t34U0g1SrzAwFiIxvJ9
	nK9JiUMGrs5CAWFFwWNpOZusO9KbiJ0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CXv0u/LL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791626493;
	b=aMtxGkWHDna2sNeLk9KxsKLuHH8YR2ZgTDEDR0eA0JVUvejzACWQi9FT0A/bHmGbK40XSp
	Qat+UZK9VSHF0dCxSsnnwg0B7/SHoMxAXGg739nkKvyHbDJjUHeTFUonWQU4s+ptlS8h/w
	vxragz/ftBZXtXNfQ8UiP6+YOAP/KSU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 294B441883;
	Sat, 10 Oct 2026 10:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3A51F000FF;
	Sat, 10 Oct 2026 10:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791626492;
	bh=yxghfkk9ZcOzzHrH4POV+dHpr3b3+ZDhOKp5XX6zWMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CXv0u/LLebHMF6g/2GK3TvCGBelT7PPH0HIRnflCf6AZ0lVwkZgTWwxvuQI+s9qMo
	 ft7jV7D8Qxva2ItzH/MkbLDHDEbO0hANLYn5fxEXZ55ukUHdB0mGreeyNQb0gRBVoX
	 GvDcmGzAlIjOGHFlErUh2IZlaV8eljjni7igTE2vwGw9kUGtTtHVU7D7lYZifyzzve
	 4z5Diw9TikIM7l4mmswNF7YEcDdBlTEZfcWirr61J0mPjYl9O4asyE/fZMh9ABnACS
	 hQuaEnLI0zSjN74PdduIr5wdHA9UxKRrDlhcwOf6tR/zJArMSWXwVbnieyTVkKv2i+
	 bB5D41vN0Gm3w==
Date: Sat, 10 Oct 2026 12:01:26 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Saravana Kannan <saravanak@kernel.org>,
	Oreoluwa Babatunde <quic_obabatun@quicinc.com>,
	Wandun <chenwandun1@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] of: reserved_mem: allocate and map the reserved_mem
 array early
Message-ID: <asoM9sKML-7BIEOY@kernel.org>
References: <20261008094125.3197971-1-m.szyprowski@samsung.com>
 <CGME20261008094130eucas1p1120c66c914aa2b93fa3d7e6e494e7eea@eucas1p1.samsung.com>
 <20261008094125.3197971-3-m.szyprowski@samsung.com>
 <20261008140515.GB183998-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008140515.GB183998-robh@kernel.org>
X-Stat-Signature: 5kqay1g334obc8jja5iejhh11zmhwgct
X-Rspam-User: 
X-Rspamd-Queue-Id: ED58C1C000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1791626492-87612
X-HE-Meta: U2FsdGVkX18CyXPV5J1lTRwceoAjiPWgJmU9ya/5Wv0zgBNxUOfi78uKSpuL0c1cBvdT4BEXkekCGhs+sDsfcVsTPKXXN2dKAI6a8s+k9fNu9/uPD4QguXLldLgpz0k46ooYFGYhqRbqOzURgG8eTV+vWtITePgE5UEriAkQzSskFMfMKUg5IPLijDft0fl/JFv5XolEO7T8D580WvNPE3zPJceyc8XOnRgJqCvkoNMEIsl3WA7cEeQE+vjG9BxkzcWAguVbYpJFBxTEsIYkldC4fj2bsYZm9ojIBdkYwtm6QgSYKrpkpRLFIYCEmK+tH+vEqnNCXt1xMKyty31wUBj1Re1U9Nwhgb3FH3klAuhOH3gi8fuB6yUSbl+KQ5SmF3Kge3YWSTIc5gsuPnKf7HxTUF8+aQpjpDtiPJNCixDuCL98+91ocLrgPdfguUBkuzFJtdpWwtBTPZKZ+b2+6vEV5YMhiT0+iQpxM8OGxUCFHmOEmdizs7QUZ9cugE3G459im+jXGXWETB2I5//V3Pchmb38ZO/lIkTF4Y6cuc/7vtYEal4mUeJlUAIkWA1JXHCf8lrt7qXeJWHimEuFCODKsMeWmh4KHkFpxnaFEK6Qe30SzWRqczNvY4+31TeDiehwwJ9yTzoFrTIaK/R+pM/aDAvbN/aTLig1ZMrUcTs9UVnbiFx3ctQcG/gjD+PUEwPyD/Yj9IHsoo6CzM2HD4xIAfA7FiOrXDB+oSHSTeND+ta42c7PhgpSz+6X1aSy/sveyZEkePwxbVb/52ndWqHakc+ZWpliylZEJBCPUmdg5psgHiBS0KlJro8TaK3XjqvY4yKLQxmnAYkBEmBl0rIrWXukZwgLX6HYX7Fa8ZmI/v/GamVsjDa+fksdku19izrUaCMizZvk/pH0+QhAQj/EHHxYIXvVX/0Wt8V7E3CJJ83MgC3T+kKLaj3YRzZnrQRmHi8uD+09OCgMtcl
 AteL+3YU
 JGFIZrnN4eqe2+myK8kAR0qCWehQD6xPsE31vNXXsYLLfJpJC8vaJu4f7/MAALYhCkaiuEmlEcw0yUHwH+vVEomOqiiplohggsFvgRacQnUY45/Ui1iACenoXGVnvmeOmnHZXTqSHWaiV6VwgbAEGbauZMvtu+hOdXFXiLv33FxPq0GCMLDxjTIS4xF/wnfGacmv6rGaiGE9sfnQT20nYlDe3g0b8vjNb7eet7a7wZoj2Th/a9eW4uNGfbiiTPjwUzMt/Ovogc/XbOh3tBiQIzJkLOnQ0/FTElR4IuQ4t7Wsk46UggSPQHhB/obpbz4Hqh9tQegx5USWq/8ZKIdQGzbIU6zyR6OoV3UAsndXNigcuI3zsKFHVe9qhWPjIfoG/WCxofdKvOmWbfoKK8kPWoPpw8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 08, 2026 at 09:05:15AM -0500, Rob Herring wrote:
> On Thu, Oct 08, 2026 at 11:41:23AM +0200, Marek Szyprowski wrote:
> > Get rid of the static, limited-size reserved_mem array and replace it
> > with array allocated by memblock_alloc_raw() and accessed through a
> > temporary early_memremap() mapping. Such mapping is needed for some
> > architectures (like ARM64), where linear map is not yet available during
> > early boot scan. Having a single, writeable array with all reserved
> > regions removes the need to perform two step initialization introduced
> > by commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
> > memory regions are processed"), so all regions can be processed
> > directly during the early scan again.
> > 
> > Suggested-by: Mike Rapoport <rppt@kernel.org>
> > Link: https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/
> > Assisted-By: Claude Opus 5.5 <noreply@anthropic.com>
> 
> Assisted-by: LLM
> 
> is the new way...

Probably not any more :)

https://lore.kernel.org/all/20261009083137.3-1-sashal@kernel.org/
 
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/of/fdt.c             |   3 -
> >  drivers/of/of_private.h      |   2 -
> >  drivers/of/of_reserved_mem.c | 251 ++++++++++++++---------------------
> >  3 files changed, 96 insertions(+), 160 deletions(-)

-- 
Sincerely yours,
Mike.

