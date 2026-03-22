Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6330CD58CA1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 22:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A098C6B0005; Sun, 22 Mar 2026 18:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992916B0088; Sun, 22 Mar 2026 18:44:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A7F46B0089; Sun, 22 Mar 2026 18:44:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7820B6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:44:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F98816091D
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:44:38 +0000 (UTC)
X-FDA: 84575179836.03.EADBC55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6056B4000A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:44:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oUGcCIcX;
	spf=pass (imf07.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774219476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVw5hEgtSMsez88gR2GuBdFTDR00fN3LqNjrht3JeCQ=;
	b=qRtNLaa9XZwhvbDWfx1h3M9ZGf507X1MNpI0qeRYPOCfcgPkPO0DyyKcPtQV1KCpYWUrVs
	lXgP7VsDMAph4EtGzFYJ3ElrsYwc9PFJx5ESVELk9HLLzvWT+k7Cqt8O+zHJjzwT/Vd1xN
	IdLMdhZWjaeSP/MNg3+FvLd2vpifbaE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774219476; a=rsa-sha256;
	cv=none;
	b=n4l3MmElMY0G+e2oM8hqQfZQ0w6PbKUeoXIdnwIQdUklqCEJH7g7wWZsr9cdnMadYZSA5I
	y1dyvrXFCdAt+VkNXQI0SRnigc3Khe3B55PSL4L+nEAbCRRPyx5MM/aJliM/67BuBmfBcs
	Ti0rwcFhBMsWLR9oaxdBgolrvymz1VM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oUGcCIcX;
	spf=pass (imf07.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E9F44197A;
	Sun, 22 Mar 2026 22:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07631C19424;
	Sun, 22 Mar 2026 22:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774219474;
	bh=6hZJNTCd20BU5NgurAZ+cW59ZrrC5upeRvDtAPs/bnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oUGcCIcXbmu9pKFb/XiPZ6L/LpzaBj6DRSPAJOtIMR2p/kth6TsDGk8ci/iynG/86
	 RHOSP0ehYRHEazOvptm9gxp2OnritUAd4HEg+ZSEyRtPUgFfh2H6+bWNcHcoX6cHhX
	 2dsEXvEWY9XCEhYPb+LbZpVUwWcOvoK6w4I97QyGHbfxr1rE1Br0arT2lTuXqpVpWj
	 Y/JnxZ4HjRuYVb1TX1XlMJt6e69X6tmSb54BcmTwHfW9gJLBzarpdarMTSAOJl+A0I
	 olkvTv79301bpP9WYBcHiix+Y/6cXL7AXrh9eo6bXkGkuEDih9Sl4w1pSzc6BnfIGb
	 MAQE19e98XSNQ==
Date: Sun, 22 Mar 2026 17:44:32 -0500
From: Rob Herring <robh@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Saravana Kannan <saravanak@kernel.org>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, Krzysztof Kozlowski <krzk@kernel.org>,
	Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 0/7] Refactor reserved memory regions handling code
Message-ID: <20260322224432.GA16628-robh@kernel.org>
References: <CGME20260313150809eucas1p169ab0904a217a04e0601e2ef01854c73@eucas1p1.samsung.com>
 <20260313150802.1121442-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313150802.1121442-1-m.szyprowski@samsung.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6056B4000A
X-Stat-Signature: 54bq7icjfmx6y5dbw3by4xgnpp4mhtz8
X-Rspam-User: 
X-HE-Tag: 1774219476-442187
X-HE-Meta: U2FsdGVkX1+Cu+b3XMIsw7XvE7jGC3/dJ/+7LkrGKCxH/6rwV6HcKBy1j8VLsgXTHQxnYPzI2hjwZ4kEEL4fnddssiQXY+cEIlPWZAmg+ADBVAIILw0snm/N15KFDMZFF+3EERIH6Yfjuq+KVmSGw6i6oRpbGtxTX1fZegBn6sR8SYuLr4uFUELqBVwOl7XkmKPkeEI+Q/MftkXFPRmJD8cgFep/JJEMhkgIBxrhw8mCpe8UEoOXhshea0a51riS6x98kfTsJdA86pV9L2o7JyCq9Rf3E/eKmgaoEaq+P5Xo+69DhnQDf2lofv0AhkY2uGquFMNKb5Su9zMdG/D4eOBYKJV1urs7aaDpErAF68D9biBY+5p2KuzCuXuc6OLLwB52ekAEspLn8Y2LUHlMT4OWwjeKZlJQR+Gu/mM4G52JaxOdyQKNa/SWs5wHUtL+8rTCO9XAgncc2oaqM7intNm+tzxs4BNSvxDbJTDOEXiafWVq0pkxKQLqfQ8lJSd/U3UuirlZqLq84Al+oVcNJfZTiJHcj8+NtzdgjXsoxuiQjEjBeRM38D26XsgdMPX+RV768182FD3ipQ4N/FXTePM7ZjBjtaKGxVrqgR1/TjnlS563WhlcC5yh7Wf9hv2J2qv3IAq3KKRGPaUzCikp94mgmJ+EF0pxkhl2yGrmU7klvNQlu6kSTS7xhBRbT1d1HaGRwal8mrFxFdbLS795AE4ZrvUnGkNRkzRuUgWnglOJwLkU18g9HFXg/RXl1UqMYExNoLhyE6Ok4A5U/X8vqL5c/xtsd4gf+1oobR/nbIDAyB6yCOSRgY7SLCMrOQFwucc6SKaGQP2AstYOF8IIeA2BrFSEV09QhlRsEP/Tr7zfz3qas1ym4k79Q9319QfPdIuXleIiCqTPz4Hlpsf7YAnj1IheNFvSOnzx5I7SObmMlZX76j9THBOwv2y3U1CCHMo97rxfFECkTnuZ6Ll
 z1u+XuQ4
 NnVGSlIL7lX2s0uqk6S7nDYtHNiuBCD7ak8vLkZoVxFQGBxjTDrkYGd85c5mszZ8TvKbK87QpFK43r7RLWgExYpJXJ+QjlGIO61AnFIche2J1sbPsgNcnIqxJUEkqFoVnq5TgdzT8jEJeU3lCtC66rMn7s7yhy0zeuuecYpVL+Tb7y0CP9DbOIYUUqVNz5pgs/tOj8Y2Y0MpTD7Uqf8l+uggqB0H81ypUUI1rXdmsI0aFpDeSEv8P+E0f6Ae78Q2QThkO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 04:07:55PM +0100, Marek Szyprowski wrote:
> Hello,
> 
> The reserved memory regions handling code was reworked to handle
> unlimited so called "static" memory nodes in commit 00c9a452a235 ("of:
> reserved_mem: Add code to dynamically allocate reserved_mem array").
> 
> The side effect of this rework was a set of bugs fixed later by commits
> 0fd17e598333 ("of: reserved_mem: Allow reserved_mem framework detect
> "cma=" kernel param") and 2c223f7239f3 ("of: reserved_mem: Restructure
> call site for dma_contiguous_early_fixup()"). As a result, the code in
> drivers/of/of_reserved_mem.c became a mix of generic code and CMA
> specific fixups.
> 
> In this patchset I try to untangle this spaghetti and perform some code
> cleanup. I hope nothing breaks this time.

This all looks good to me. Can you respin and fixup the issues.

Rob

