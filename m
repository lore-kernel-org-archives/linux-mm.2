Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8020103A9BD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C164A6B0089; Wed, 25 Mar 2026 10:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC74E6B009E; Wed, 25 Mar 2026 10:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD206B009F; Wed, 25 Mar 2026 10:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7956B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:16:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 375051A09A2
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:16:52 +0000 (UTC)
X-FDA: 84584786664.13.B744979
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 52D0940003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:16:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SbEu0mJ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774448210; a=rsa-sha256;
	cv=none;
	b=T08qXyIMYeYpnhhzESd8WXCJwgvp1KRNldM2UjS/aCNKVsluXJI4T9SARhJIiQce0hcvPa
	IWTB+EEN6oAOJgfw8/4gKcJaFIvWgMB/C5cDf6J9s7QtwimmFPRDOZS9Lc4kOaCkuxBwba
	NtZvsYWdm6NY+AH9JwDmxeFiUIiuIyw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SbEu0mJ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774448210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yhVIlpHmi2opi+9CDarB44lMTCxpp0yPj9q2T0Gl3B0=;
	b=2VKXSJZe+i1C7SH7OBneWkujdIyDQTQ75l6j0FDALYYQpAg7J/xcrKOFSvwKo7nTb9e/LS
	Q/4sgTas2jDeXYPvtGa21IFr3caUdrMQxhT3zPRpMSf4jzgD4em1SK3u5ms5PO0m6IC/zz
	tz8iB2IifvURkOtzoybfGg2edZhrLCg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B9AA41779;
	Wed, 25 Mar 2026 14:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C294DC4CEF7;
	Wed, 25 Mar 2026 14:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774448209;
	bh=8ngHDk8lWpxvFOPiWfS0KRFxiWHuNBJQ/GDAuJ99gWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SbEu0mJ2dvQV/K5tuQS9fLd/5QfQEZJ1AuXyxzFLEGHOPmX5Q5RgBY6Jb9MLmGgtP
	 KsXdOxp0Un8VMpdkZZOGbRjtlpT/NkkOP82QEqIB2TcMAdq/EqKujVy+tPpPvQIkv5
	 GbYswH+1Ovsc9ReRSRi3irUbs9cbqZCSAHKsmXELTAWcvrkD9tj6Dw48Cp+Oft1n9j
	 1oQBHLA5Jew9pc0r+xH8xc93+iTk5hiDatPmX3eECeN8S9hy/8aG+afOr90uhU3zf1
	 g/CvKeLb54HC8JWQKCb0cTXVUoiXukXE4RvG36Z5jozMro9gcDV3tXQCzc5Yt/a4O4
	 77Agr73H0j61A==
Date: Wed, 25 Mar 2026 09:16:48 -0500
From: Rob Herring <robh@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 0/7] Refactor reserved memory regions handling code
Message-ID: <20260325141648.GA2685599-robh@kernel.org>
References: <CGME20260325090029eucas1p1932917cc4839c3349932aeda37a7125d@eucas1p1.samsung.com>
 <20260325090023.3175348-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325090023.3175348-1-m.szyprowski@samsung.com>
X-Rspamd-Queue-Id: 52D0940003
X-Stat-Signature: d7uptwsbfz7ne74eohzw3fdxn3bsebzy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774448210-415074
X-HE-Meta: U2FsdGVkX1+xHlTP5+aEBelKR4Fc3jY9OmR1Bc+sgBKzbLurZ3476xeVtLvezqEcod6Tq/4Z4gladTv+zD/d2CoSjMWOZ7l+/oJrN4+s47JtpGBXDspp7Wp2A5p+FQMh3GB/qoIS7VQHZNxFlrZ/6YVXi0UBiJw4PLpbZwtJfOl3X1evZjl9RyPlOwaK66PpQ+rI0Z5bQ8fWIDYaqLdOKsc01k8yr/6UKn0soPk4ZG+kBwLussFFdWn6cZN4NqDLYPovRGAPWnPnRsWN+aKJtJzfvu/8k2ulj+E4R+uXwhGo8GlDtxeIA/aVOfbxIX2FKkNsRdt37ApxOcX0gHitjxpUi4+GBvlyeSTych5I1Q84RlDqSOgR8OqffmSONEx/Lg0MTv3FiGSgXcnTiVmmi4rYzVf8Ui7/QGb9Hs7SJEcnYVdaK/hiJtjni0UhXukJqGHRnMIZWFGOaktXf8+7/IoI7NyxpPlXwwkA7gBmDA8Y1/MEtTNCzPtpoaOSLtE+9vjSdhngW0rsIeOZTd2xkEG9FJ2AIlXdQytp1KjGLCAN+CCkgEgVpHQKfNpblj1aF2ELhxfvlFA1z4j1/O3zRDgUOMiiUB8MRrZAB9VlFNN4Oqdo2AUKqgBNTKUUDhKa99hgvXJvVldYbFZbo0rm9N6hs2vmCpOwpwGX0b5+DQYKGfzwy74pMOlAM09MTZy4rB4tmHpoVw34HyCdO8yrm2RQVdkvNawNu07Bi65sgZURXHJgm+jxXZT6qR6TpEZ3vPxxye+RLer2MSyK/1YJ6Np+VTu489vWG8Z+BU0lXBgDrt6ZtpVmsG47yyohdqmqGexBIqa9YmWwOe3IHG+/kiz5Q1lss7/gjyc7iuSSl4fLCHDg3+kfvz/PHtcIB8c+4PIBhLFyRqRz0VrDWjUXcXfonOwvt2/uOgLoswEQTCXogZEUTBShJTsMuV8zeGRg0fyWs7rqqvAxuqcRmnM
 G7u+QHXp
 WIHzvpaOAbSmIijnW8owIrGp2ouCBNpWlb9SXdepoabYk9SHOJeEDScZTtv4kQ7f2xZySz60glQ8ptnClRQi6ccvq9CIZOmzfzgYdHIc7xE4QdXxCREBn4gdc3gfaAkpVXX34NiDoNAif7g4NHj9lzWnKvwtnMc5XYjsczTsy6oGlJ6sl87WvrtmlnAee2W795t3hRtpDfQjBVv7aklJRU0+xqEm+hCEQPcyGHxhEE4fFgfVf+ARXnJz9rOoNT2Xpz64QcSr1vKptwk7MbGuSUdxbaSFjl2Yp7ZpAzzUfPzTSp5yXqAtf+kwIkK4A0Fhh4xfTFsuMoqsiHwHn3pqN3M28OEbWlaFpmaR/Ak0RFcfJ7ig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 10:00:16AM +0100, Marek Szyprowski wrote:
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
> 
> Best regards
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
> 
> 
> Changelog:
> 
> v3:
> - fixed more issues pointed by Sashiko in
>   https://sashiko.dev/#/patchset/20260323100901.4079171-1-m.szyprowski@samsung.com
>   (restored use of _OF_DECLARE macro, extended some comments and commit
>   descriptions, the remaining items I consider not relevant)
> 
> v2: https://lore.kernel.org/all/20260323100901.4079171-1-m.szyprowski@samsung.com/
> - added missing ops assignment removal in tegra210-emc-table and swiotlb
>   drivers
> - fixed issues pointed by kernel test robot and Sashiko: removed typos,
>   improved comments
> - fixed incorrect node passed to fdt_validate_reserved_mem_node() in
>   fdt_scan_reserved_mem_reg_nodes()
> 
> v1: https://lore.kernel.org/all/20260313150802.1121442-1-m.szyprowski@samsung.com/
> - initial version
> 
> 
> Patch summary:
> 
> Marek Szyprowski (7):
>   of: reserved_mem: remove fdt node from the structure
>   of: reserved_mem: use -ENODEV instead of -ENOENT
>   of: reserved_mem: switch to ops based OF_DECLARE()
>   of: reserved_mem: replace CMA quirks by generic methods
>   of: reserved_mem: rearrange code a bit
>   of: reserved_mem: clarify fdt_scan_reserved_mem*() functions
>   of: reserved_mem: rework fdt_init_reserved_mem_node()

I've applied the series, thanks!

Rob

