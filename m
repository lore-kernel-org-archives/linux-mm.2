Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 576B8C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:48:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A32D6B00A1; Tue, 22 Sep 2026 04:48:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5538D6B00B5; Tue, 22 Sep 2026 04:48:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469576B00B6; Tue, 22 Sep 2026 04:48:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 269CA6B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:48:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A185780406
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:48:49 +0000 (UTC)
X-FDA: 85240772778.19.E985D7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E2A72140002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:48:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dP6cTy4A;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790066928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mh0mGm1ld8tg6c7EhdkM1d4eVMd5E3LVT8DC3vIY5K4=;
	b=2WpHcZKvuqN+WjLjRKY3Tey3Jjg8gJ8W4EpEsMquHDzCQgj4F12fJQtJQ8Yw5TAYsx7RGz
	b2DiNJPBPR9Sjr2b3/tOeFx+St9hPyZggnN61U6Hy0JLu0AuTClC/MKWY/uvrNEEguNfOK
	s+y6gVQF02GLxisFwjHFb0CpABE74ZI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790066928;
	b=59l+29XgQNEnwBlSlGjaQMIz7I3CzuJVU8VyB6dLYxuokoxX8uiC7k0Y+yv/JU/OF84ObB
	O3idIZXKh/FiaNNugykiut40LEWAN7MiixSzUMrz0BPUG6Gl3C5NGv3T6ALfp6hDteao2X
	TM463Onhyp4vGdswJ90od4gxGt4TQSQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dP6cTy4A;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2175C41B29;
	Tue, 22 Sep 2026 08:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEDF1F000FF;
	Tue, 22 Sep 2026 08:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790066927;
	bh=mh0mGm1ld8tg6c7EhdkM1d4eVMd5E3LVT8DC3vIY5K4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dP6cTy4A0UXusAiIQuf7XHNmCf0oksDZeYiXkIeS4XXg4xTKSCusJ+1EB8onw5qko
	 0SqSET7QFRY6zchqE3+lUMrykDB4zkFnSGVGn4rKXU4CoETSgIB9dWMp7VxXlihbOZ
	 nqGQimkWf8DFDOBYHw7uhOjD4sB/STapR4N+cRzTtoxkPfUPADU3jGqhwBdkSpxta8
	 SJ8bobM0qgqFd3Upoo9rp8QIn3hgrUxWrhrHHdhduBmJ7HytD0aTZujUSKTUogFBfY
	 xzeXlmNQMsTaHDfep4OGfN2vD4Hy00fVfzkuoYcKTVH3TY23ue7cLBnmlEIhWDywRy
	 boHs5zSa1dgBg==
Date: Tue, 22 Sep 2026 11:48:41 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: robh@kernel.org, saravanak@kernel.org, m.szyprowski@samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH v3 0/5] of: reserved_mem: several fixes about reserved
 memory
Message-ID: <arJA6fOMetzoBhDH@kernel.org>
References: <20260920092852.614973-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920092852.614973-1-chenwandun1@gmail.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: yraktg3ce6nb9o5wbasn9am5nb46diaq
X-Rspamd-Queue-Id: E2A72140002
X-HE-Tag: 1790066927-43307
X-HE-Meta: U2FsdGVkX1+J9WNyNuqkrPCvYlA7Zi0/3JGozIGAO82fyrWplJDGoTOEOEjKMloMQ/CRJxjXVunHJr3i76cOYXMml/tF3DfbZncORu8tMiIJBbkht46lQM85GbJe50McLNYjjt0SEgtwdlqvam4Qolb406BHlpdoOPkpTVex5uluvxQPV8Ufc5/63NVWf27ANFZ7mm8FhOjKYgoUEOYqZ2U58quOfl88k8kfjk22VWdaxSX31HAHUrNytNvwFEPLKGxanmnW4jE0RRbWsWCpCZDD8BUOTTtchfrH2Ti0mhkmfvI2D0Qq/Hbp0lnTa3H9Cr8rIEf+kMZx4x8f+XV15QFp5ThibemXckjsxsxgHkLor+Tj+zJoVvwWG9nHgbVjOydhJmccaxsc1ws9Do3Msup+rFkLMjF2d2rq3NBvIsoHBz46sLF+SttprYFVscdtOcqwGFvt6WLdaJF4cpt4ZebHy1itjOGLH7yXuig0JLvAx8+nowCVONRIvvfPj33zyl89sdUmIWHCQWG3icD6K5/4Z7bmsPel82yNGngZGfnl1dI/ARO1T4xn+1GKDEz2ZQPFcA7gMiTUKjWkDRDorvhcDcy8REJcJ+N45mBratZzFf3TXyaT5D6gXbDJGylBMPOqhOGyAv1N6fLluaxQevALJEse/hwtV8BNHDpJGJR6aNyu2IcnkkdIVQnDx+R2gXTJwxR4gR/jgFMB5+oi4/x0NDePA9jcZJQi7sfpksEctaWiJv27uRh8e0iMugAiLFzoOuZ2nATMal4P6++ySCqfyWBkTa56fEeCjQ4fUGx9QKnIvlRX5T0sjIu+ABWyXKlrS3iinVT5k19Xl4pca0+RcsYezD3AOlVGG3kvZYnzvDwgUoW5fgkQQpc9YoPP5/0y8bHsiSQcEfHR5MS5HkWI+klF5ZYoXtLiU+C9DgfVBfs+X/p0/HzDT+ZmXxTjU+K6SLFOw7CSiEZs9kb
 TJEsXGu3
 6p6AkOcsqjDC+LKPn9Eq2a9UAhJKSu6o2VSI2j3rwEJc2t1MALcEjNR4v1pbfPfbgINt6+B6j4Fqk9KMICj/7ODZeW/Thu7U/y1jpiDdCO5HyF8Ea5lGLrD/RKq3RrtTluieSlmBM62p+gSa5mRAg1D7ZtgEt19bL+riRKJq3MuKUdnK4e7LOYWaBL8Jl/S3tYBwy3rO9ukHA1+WTccM3rdcmuicHTPnC8HQPYuWaSbpApevdIi1fBlt3RMj+1sFBDIHQgI/naT3O+OiNAQoMrH/uRWyR+ZJAgcjKfcCfCdlm+CPKNi9zcytDobg9SIncyktigb6bZlP24At7iNNTVCanphw/Dl5cCCdJC2eSJYtyu44kJFaRQEY/r/plxhcwBAiIe7re1UuCXT6CzOSufUsyw/NaHsGqYE5yrMR3pNCpZjCkKrh3DeDSRishJiev9qWc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 05:28:47PM +0800, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> This series fixes several error-handling issues in the reserved-memory
> initialization paths.
> 
> The first two patches fix cleanup of no-map regions after driver
> initialization failure.
> 
> Static reserved-memory nodes are reserved during the early DT scan but
> initialized later. The third patch tags regions whose early reservation
> succeeded, so the late scan can skip the nodes whose early reservation
> failed.
> 
> The last two patches reject overlapping static regions. Without
> these checks, overlapping nodes can be initialized over the same
> physical memory, result in data corrupt.
> 
> Sashiko reported these issues in [1] [2] [3].
> 
> [1] https://sashiko.dev/#/message/20260814090305.4C8741F00A3D%40smtp.kernel.org
> [2] https://sashiko.dev/#/message/20260814084718.29C341F000E9%40smtp.kernel.org
> [3] https://sashiko.dev/#/message/20260806100605.2C2C01F000E9%40smtp.kernel.org
> 
> v2 --> v3:
> 1. Rework the mechanism that checks in the late scan whether the early
>    reservation succeeded (patches 3-5, suggested by Marek, thanks).
> 
>    Patch 3 adds a new memblock flag MEMBLOCK_RSRV_RMEM, which is set when
>    the early reservation of a static region succeeds and checked in the
>    late scan.

Can we keep this local to of_reserved_mem please?
 
>    Patches 4 and 5 are reworked to reject regions that overlap or are
>    contained by an existing reservation. The code makes a little different
>    from what was acked in v2, so the Acked-by tags for these patches are not
>    carried over.
> 
> 2. Reorder the patches: the two cleanup fixes in v2 now come first.
>    In v3, the first patch now introduces the 'dynamic' distinction in
>    fdt_init_reserved_mem_node(), which the following patche 3 build on,
>    so the series reads more fluently.
> 
> v1 --> v2:
> 1. Rework failed-node tracking in patch 1: do not track zero-sized nodes,
>    and keep a reserved_mem slot when tracking overflows.
> 2. Reject static reserved regions overlapping existing no-map regions.
> 3. Keep MEMBLOCK_NOMAP flag for static no-map regions when init failure.
> 
> 
> Wandun Chen (5):
>   of: reserved_mem: release dynamically allocated no-map region on init
>     failure
>   of: reserved_mem: retain static no-map memory on init failure
>   of: reserved_mem: skip init for regions whose early reservation failed
>   of: reserved_mem: reject static regions overlapping no-map memory
>   of: reserved_mem: reject static mapped regions overlapping existing
>     reservations
> 
>  drivers/of/of_reserved_mem.c | 86 +++++++++++++++++++++++++-------
>  include/linux/memblock.h     |  7 +++
>  mm/memblock.c                | 95 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 170 insertions(+), 18 deletions(-)
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

