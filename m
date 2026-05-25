Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4287CD5BC8
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 23:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20C676B0005; Mon, 25 May 2026 19:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BE5C6B008A; Mon, 25 May 2026 19:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D46B6B008C; Mon, 25 May 2026 19:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F0B156B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:04:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85FC0120217
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:04:25 +0000 (UTC)
X-FDA: 84807472890.10.26B7D0F
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id C662510000F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:04:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=esKgEHGv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779750263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfRCGs/J5hRiEUILEO3f4AuKoAZdtqxzS7pzC9urB+o=;
	b=5mPk1/nS4710aw4IOSY9L3wRVYu5/SZeMwl4ZofFmlShI+RzxmsRxnjlQ3L08TDg0zkxFF
	cxKsZPn27cGlOvhbaR6PlQq5KkzEv2XlgG5P3R7Er2ACIbDlI1CB/fGP8cvwMN3rfXajRA
	5frJpikVQjwUjDV1LiEqnW16s04t99M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=esKgEHGv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779750263; a=rsa-sha256;
	cv=none;
	b=cZ1c0Vdv62BgDpSA2ZWjAevx4wHARNvI3efdWOVOTWtTalc5VFA9JX8/reY7eojkUOv+YX
	wyG0TS7qBmQS1R+eH2MaPvHiX4BMMatVA+5WV6SdGOvu8gpFvdYITWBOZPf9xzjE5kLHAU
	5A/4mzRMdlV+Q/Ys6PbyAZoQwYqXLXI=
Date: Tue, 26 May 2026 07:04:10 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779750261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vfRCGs/J5hRiEUILEO3f4AuKoAZdtqxzS7pzC9urB+o=;
	b=esKgEHGvsXOPdD6FjDGRu5GQsjqd0gSih1rqrwpGZXi4ErFpCGaa41wTJXVHnZsFnQzmpI
	nO+ALdzzyjhabI9VMh6ALkdzrZuxVg9rycCFbEC46KLpZ3N0qopaM4MPM/IVG/+yGxJ0Pe
	A2FK0zrL9W8z2N2XQqfwKK7JylPXHEQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 2/4] mm: swap: associate swap devices with tiers
Message-ID: <ahTVaix8eauPfUtx@MiWiFi-R3L-srv>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-3-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421055323.940344-3-youngjun.park@lge.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kyoir6znow6x5ah5odaha3cpwpm6rmgt
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C662510000F
X-Rspam-User: 
X-HE-Tag: 1779750263-670464
X-HE-Meta: U2FsdGVkX19AdxcyixOegUHS0xQAOp6YhU2n1vXTuJn7e65b3gGwsbp5wG/nnTmeQmkyOImGIPOMyX2a14vCw4BI0hWh1r3NA+vA2R7+EnAzClc0EyX3j3SFYxm1Dla1WyQQDwg97NQztVrFIDz+smnecabxFMiHulV3XWNcpXqS9wkl3a9dt76kZtlgv0Sfc4GP+5urLoIycHqm28PzAAVvJmlDM5QQAQi5sZju6+9+DHEUwCguXNwv9r1JzLA3s5VE0q46Bo+LMDUZBs3LEfCTg7zmhCQQk7S2GdQ5Zdt/pg9jmq6G+nIOn0tSfH2LFd239jYDrmDVk6KwYrPxOfpOqRp0+v/DuPhyGQ/VKEUR8oWtH7UTgwCqlEtqdO0payzDu83n5RnsKbiiUw4ACenKBJkg9p37QA20P91SF3UB6Pjr9HR0f416BZwn5FZxH8x65Kwu0LZfWPZvnhym94F93Se5R4veApP1Ze6ht13MuufskEyR8g69VLoDVTHIkQLooXG205/Lejz8AMySWXmcm+OEuJ5JZR6hnj/jd1z8RVj+hD0XcxmMTiq86j4ETtYj/gvDNKM0sO1APxseUizMqRNADhdzLBF3Xchep62YysfzfTyVz6gLQ3CLQ0l5nYaNompRzF0uJd/4IJ2/7c/cyKa6P5fu605Hm42VlZNWVooaJV8EB0LcAJRJRcaBMCclRdVYfwzcfOFLCpaEAsm9w5KWFdrd950WvEUyf9O1Ieko0DxwyfmRrsBpW6QlT+WpuEtr5GsC3nYNsj+lp1hDM0eQbRZZmAdX8A6Iq8zfyFcmCmTvYkqpJcAJbQ2lUzJi0j9oshJa66vPB9GVIZo53TZ3xPnP5L6gcU06ap9sQkfnC5j1bZ3LMwstoS3BRbbQSGa5ziuHArlq4PYfdMt2uSuQozYwb7nakEKXFS6g9Nv+tnfympdCn0T49lEGbbpwBP/pSsIAWgALiEm
 mETqOBjT
 qujkSpstdWQUfR1Dbf4/ol8yCJrTBUFT894eoSrmWOCpkMbRMNNJ3N9TI6T98u8AF39SSHItasUGFGgh3clLSB+EbXwKOotN+Hbc0Hd9cT0iee2onIf8VEKahEIX25L5whjiKocPEIz+YPMp1613nf3IIXHYQ80qM1qjdFiIAVkEXMmY5nCiQm9+FtqlqZ/4CfH8Mkh/H7uvRTeDyRLnYujVhvehBOsSFC5EnkLoPyXjNntS842+qhvQe1UpCrhazKKf17Y113smThX4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/21/26 at 02:53pm, Youngjun Park wrote:
> This patch connects swap devices to the swap tier infrastructure,
> ensuring that devices are correctly assigned to tiers based on their
> priority.
> 
> A `tier_mask` is added to identify the tier membership of swap devices.
> Although tier-based allocation logic is not yet implemented, this
> mapping is necessary to track which tier a device belongs to. Upon
> activation, the device is assigned to a tier by matching its priority
> against the configured tier ranges.
> 
> The infrastructure allows dynamic modification of tiers, such as
> splitting or merging ranges. These operations are permitted provided
> that the tier assignment of already configured swap devices remains
> unchanged.
> 
> This patch also adds the documentation for the swap tier feature,
> covering the core concepts, sysfs interface usage, and configuration
> details.
> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  Documentation/mm/index.rst     |   1 +
>  Documentation/mm/swap-tier.rst | 159 +++++++++++++++++++++++++++++++++
>  MAINTAINERS                    |   1 +
>  include/linux/swap.h           |   1 +
>  mm/swap_state.c                |   2 +-
>  mm/swap_tier.c                 | 101 ++++++++++++++++++---
>  mm/swap_tier.h                 |  13 ++-
>  mm/swapfile.c                  |   2 +
>  8 files changed, 266 insertions(+), 14 deletions(-)
>  create mode 100644 Documentation/mm/swap-tier.rst

LGTM,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>


