Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9953C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 06:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692286B0088; Wed,  8 Jul 2026 02:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61D276B008A; Wed,  8 Jul 2026 02:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3EA6B008C; Wed,  8 Jul 2026 02:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25BA16B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:09:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F5B9C3FF3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:08:59 +0000 (UTC)
X-FDA: 84964581198.15.E260E0A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1D8CC4000B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:08:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYX6AO3h;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783490938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXYsrdEbQvlPjl1uht/h4kWy1QyDvVCqKoZYxI/q3SI=;
	b=7B8QgBhZoPbnCkkwNfpIkNz3leYiWrUj/sWRp/ccX/Qu04SFf7Tk3bwuAF7RInswz3Y96w
	y9by1d8Xd/bqgz3CAoreH200uBMIZB1Kd7El0Dk83G+DajFWM1ccCr4qY4jaKJ0FUPNql2
	wEYPCCIdbvcY3+cS1sOzZMQka+oWvLA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYX6AO3h;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783490938;
	b=nIeLS75qYyB4NdS7jF6v2M3+yHBwNmciDTMBUD0nAdAA9nHsccvbBFTEAg1Dze+La3lclb
	Gb/rVqrxR0QPtxbjS6yWmCwGjwGJ3Y20WYa6nyJ7L5hPFSUnfVz1NRCCy/Af8cuxXlxCa5
	F0lytvdcDvpWCeMRTX4CevGhhprHrm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55B016001D;
	Wed,  8 Jul 2026 06:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF84F1F000E9;
	Wed,  8 Jul 2026 06:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783490937;
	bh=QXYsrdEbQvlPjl1uht/h4kWy1QyDvVCqKoZYxI/q3SI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YYX6AO3hdEi9m/q1XH47iSD+UNkPfg4oPc3zq2g2N5gushnNghyd8YHYTWiWtfJ5F
	 NoRiADuOJYEKz/EofPKj7GCMxv8t+7/V7/l4olpJLPqG3KF+vwjoADJRLlxdXzvrrL
	 /XxE/W1SxQ/S8ydJoa9OHQuZEg2q8mDOrGUmdB3ZrlagsAbqt4yC6M3oYA+b66VBFH
	 ZIZtDOzvoUfnAnqXVCOow0sCjT1HUi+Rl74qFn5J/LjTqbRwPbt+cCd4F9rdRA9bnf
	 NF/UHneHvyejQcc3ffXfS5eLTcqAbn8QciekgMmyeq3ElnjruRKuhcPAwY5DtsVNCa
	 TvEisjAEmtmcw==
Date: Wed, 8 Jul 2026 09:08:36 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: Will Deacon <will@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sowjanya Komatineni <skomatineni@nvidia.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Russell King <linux@armlinux.org.uk>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
	linux-trace-kernel@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>, Chun Ng <chunn@nvidia.com>
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
Message-ID: <ak3pZG3GFLT1SSBh@kernel.org>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-4-d80f7b871bb4@nvidia.com>
 <akYs91INHMXMTI-t@willie-the-truck>
 <akZkuwktaXFTrASP@orome>
 <akaSJ5D98w2cHqb6@orome>
 <akftuw9NyRy36fXA@willie-the-truck>
 <akuvyu1Pq0ZVMZV0@orome>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akuvyu1Pq0ZVMZV0@orome>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1D8CC4000B
X-Stat-Signature: fqrhmkst8pno6tzbgxj7ijzrkdskkqsf
X-HE-Tag: 1783490937-314171
X-HE-Meta: U2FsdGVkX1+CrWM+lLJGP66zbOIeIOmZVGK/l9fYhyfe5gENtJFSNyzSAyzJ17dGPfjEJ4BSkoAkfVRwmoyGGdHPWgzqwEnt2qlbQPr3okImnEe21VTmBqNxofoGOLAe6v2X0qXR2yUQbKRrw89v7Af462zfrcshC+9rn0zsPAC0lbsKUjFzBzuyLE3CesO6vsGdQIoqcr0AJkG1g3EmcGHi2933a8PLuStQdhxM7Q8/Pu1Gz35MiKlKywNkBfxwo348jkPbrTHmUjJjil7hvkavaxhepxJWlw7A3qzG6nNkgPZrykqePbl3j7Ekb3AemNMNmKgJNczQ6343lTzfmQmLsuzKFvZ7A46dYOconbhOWehhzLSLGWraYXYhfWFqEqIYSQS4cbjkZOyshLziScdMItZ0a4p3w/sJV8V6ayDWl8DewwGrBw1bRi7resdFO0LXBfZ4tBCErO5bhwvNfanXJCJFjqW6LxbK8nqTRJU7G1pq8dmx6VXwKAJdjV2SsKkJ5qmksucR7L3hbIK0UfmzJfWgDpJ/fOHataRAm5l+92g/r0gaWvthAv2tWoTCdiycMv2gywbHYMWkQI43Orens04OiD+1H9MzfIP1jEsOS0dSwpTlnVp+eYyM8qxijwbKDyowUK13WLO/B9mSX+suM9o17ZRnhlCppVJ3WF2hTRcnydOAAGUYjJ1UY3XGoKYSwfYqoTwJwDwEW8N0wvzN5AfwxnVRihZ+7To36nk9giLGQvq/pGSWAul58Y8jCBKlDbN4DM6O5alEa0PU3Y/UlkQOZQLXkn3eL6K1NaFsJaF6482tLmJTVbh8IdXh5mhgBRFY0L1bW9vYy2qKVEyEGt9yuh9LSJTR7Yaf/R7ft9bFrUwLIn6kbkq197XIZDUbedo2r+Jftf3Olykp/W3d+p9AY04zMlwfHgXJJjS+G94oK1SN8uqXmEnyW5hCg1ZFAQNV0zPEOXXYk8e
 Z7xiAaRZ
 KTDPCSGSj76nvldo/8n+NA3I0zMWumEq0sLajiZddXO4kVlI+736mMYYE3D0/2Fb4SazRnCP4crZysheYb59ifYzOAUa1run3z7sWV5IscDFnKMFVb59orCldFsBMHtsWWt5joOkbiyCdlc3suWAUZHoiZ8d0++IUd0eYG8MZTrQCfBXrANzf2McjzzTEmAjAakHVHd8IWowfGTy4vJHcA9CiEtSycT9PXWzt83EnkFHgVTOxyzuR+h4YFaoBPz+CmV40W91gwI6jp+ROBzY0laD87jsHASDaTKnE10JBAaQg92P0VyPOSsEuWEACf6ENEDjrqOk5FfWDfl7BXsJAPl5eAH2nL7C/8RCCrmAsrNZKWVMbJg7QoqJ/I29Eklql2hNSYMShPXECK0RqZVO3rakG2FWbheRdjp1ga6nUxxBpnRMsGxTOYnoTumG1IAcbjSyFd7mPu2wVuHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 03:49:24PM +0200, Thierry Reding wrote:
> On Fri, Jul 03, 2026 at 06:13:31PM +0100, Will Deacon wrote:
> > >
> > > How about if I extract a common helper and provide set_memory_p() and
> > > set_memory_np() in terms of those. Those are available on x86 and
> > > PowerPC as well, so fairly standard. I suppose at that point we're
> > > closer to set_memory_valid().
> > 
> > Why not just call set_direct_map_invalid_noflush() +
> > flush_tlb_kernel_range() for each page? We already have APIs for this.
> 
> Having a "standard" helper with a fixed and documented purposed seemed
> like a preferable approach for this particular case. We also may want to
> make the driver that uses this buildable as a module, in which case we'd
> need to export these rather low-level APIs. And then there's also the
> fact that we typically call this on a rather large region of memory
> (usually something like 512 MiB), so doing it page-by-page is rather
> suboptimal.

There are discussions about adding numpages to set_direct_map, e.g.

https://lore.kernel.org/linux-mm/20260410151746.61150-2-kalyazin@amazon.com/
 
-- 
Sincerely yours,
Mike.

