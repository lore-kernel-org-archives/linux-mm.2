Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EF8FEA833
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1946B008A; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299426B008C; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6836B0092; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0413D6B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E38A1A0809
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:35 +0000 (UTC)
X-FDA: 84583989630.16.83215E7
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0E1044001C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ApqFj490;
	spf=pass (imf27.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ApqFj490;
	spf=pass (imf27.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429233; a=rsa-sha256;
	cv=none;
	b=JMEDvttueRP82jWaHrRywJ6dQ1A7Ckv428JvTqVL3BNM1V7AetsEG0lzhdpXEI3b6wEeLd
	N4rJgAl7dmoG2A7aFfFkhAgaIgy7cfsIbcEKF4IP3RVo4/EQ1l1UJIQCAGYj4KH2pHozjQ
	OhXZFR4qyoB9h/UHRmLDEqvvlPdUBm0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=xr00VxfpgT/xYpT8va2S85ir5lg1pq/tHyuOxyPdoSE=;
	b=ua4DSwiWeEIJR03dG+tGprx0jqzFsRgApyodrk2tSqYe2qhXWcymR80VFhBKJp4dFE587O
	msWRUnokWLF80J7TM7kB2BkfoGb0F5dpan1hRQ8YN8QUXyl8BcjkqCeGksYNX3JjyQial9
	qYLHoVCUBEWvE9U3Hs4qXErndey9Vfk=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260325090030euoutp0119666fe444314f2710d35ea7c1c9e926~gCfvK12dI2273022730euoutp01A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260325090030euoutp0119666fe444314f2710d35ea7c1c9e926~gCfvK12dI2273022730euoutp01A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774429230;
	bh=xr00VxfpgT/xYpT8va2S85ir5lg1pq/tHyuOxyPdoSE=;
	h=From:To:Cc:Subject:Date:References:From;
	b=ApqFj490J2FaCBWf05Sulxqu8/krLyh5tS1JpbonyFntdOWGiL36NEr0gzf10MIs0
	 LdZBWwy5xk6UaI936G/12KABKq7oiSbx6Fvn3hnuxCW7xAEv+SofUAeFa28PAPLmTF
	 45pnDzMvYFWraE42QZbwUwqhtB8aYUOYxWUrhDeI=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260325090029eucas1p1932917cc4839c3349932aeda37a7125d~gCfu8a8si1802018020eucas1p1r;
	Wed, 25 Mar 2026 09:00:29 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260325090029eusmtip1481ac2e1eac2b8395f0dc2fa13d06d72~gCfuZuF8-0140501405eusmtip1L;
	Wed, 25 Mar 2026 09:00:29 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Robin
	Murphy <robin.murphy@arm.com>
Subject: [PATCH v3 0/7] Refactor reserved memory regions handling code
Date: Wed, 25 Mar 2026 10:00:16 +0100
Message-Id: <20260325090023.3175348-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260325090029eucas1p1932917cc4839c3349932aeda37a7125d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260325090029eucas1p1932917cc4839c3349932aeda37a7125d
X-EPHeader: CA
X-CMS-RootMailID: 20260325090029eucas1p1932917cc4839c3349932aeda37a7125d
References: <CGME20260325090029eucas1p1932917cc4839c3349932aeda37a7125d@eucas1p1.samsung.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0E1044001C
X-Stat-Signature: nb4hic67uksosma1h5nuimbwfz7skb4h
X-Rspam-User: 
X-HE-Tag: 1774429232-15140
X-HE-Meta: U2FsdGVkX19w9Fw+ucIoFd0k/FrQRMAQHYLIoM/3+IcF7iQCNl2OU3zQzB0eRbhnffq9rIfDqNqiPdbRt1oJF2Fw26LmPnohP002nDrh1OY+3qQabaFaTmDLbjNkbbysGk1hP2C2gCqM1mY1YcEFwWRVwyRJB1SLydbOaWJo1j5divMKoP+i4WL9jU+hUgNAsMisp/XwuIA6ARwWHMhLAHP6K2+CVclnhzn3ZrM5o/Op2u5xr3fLT6MCcXyBjL1MwFuJc2W1Zo/RYszctaZahJOUgmGM/mJEZkvaor9fivUmrE88jV1xd7dmkXy2CNlv++FBwAQ7YU/tlxlmN+2H22tZj/1FG1AG3WhU6wOgZ67BBm1wTwksorGpumLKEC424oBxSn6sp9NyFfmU+QB8hvEpg+as/PuovuGmIqd5OL/86p2aCo/SlAAQKrbMYkU1ACpeqcT0CQeVU/o+4oKxT+f/A6hTeKBXLRLUXvTD/BsaQMSP6LMfhAVZfb4g7H3JpwRKrb3yJgEbArOVX6qTLleA5jj+of/AdPtX7TcFz3HoV9nS7wmD5GcgqudUHAUV5VfqXzZ8W4DNvbhdP/Lh0t2uEr9+oCrbJ0Go0JdLv3b2O40gEkOiQ7Pn4KkPOm6j2Fy1eeKGh74JNtmODXnv34ROaTGN+ByAGXLd+uHf2BWmSsNPK0e2AmP1hvZHPk1C1Vf2aR9V/iBki8c5/D1qUYnsbSGl55k7oOcbGzJ02ZjxTfyPKa5n0lTek4Z4gUM1AmUhyb9uNzW2QwfQtAbYXUzRVV3tq3Ht3k1P5jWD6mrL4YEq1A5rRp8CQLC+ct+CYo7l1ZywhyZxFxxfePtv15ohBOURXLeiom1PFGSCCwRbxT0xbdmJ3GBL8uqk/3luLN2kSeHkJgwylC0v1Zab9mqb6ssWhHTOjAOy79P2/WHEmGou7lDz5o8riymFWPq58J+GcRAcYEPHjs4mxUD
 A/AW5zdu
 NCIryCaH4+dVn7CdbMinUleGdjN0oXGsIR3eJC8qy51AGDev+wMUVmb6kSkoZ5JvxidlltpIjuvhF+te46oZpbDCwgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

The reserved memory regions handling code was reworked to handle
unlimited so called "static" memory nodes in commit 00c9a452a235 ("of:
reserved_mem: Add code to dynamically allocate reserved_mem array").

The side effect of this rework was a set of bugs fixed later by commits
0fd17e598333 ("of: reserved_mem: Allow reserved_mem framework detect
"cma=" kernel param") and 2c223f7239f3 ("of: reserved_mem: Restructure
call site for dma_contiguous_early_fixup()"). As a result, the code in
drivers/of/of_reserved_mem.c became a mix of generic code and CMA
specific fixups.

In this patchset I try to untangle this spaghetti and perform some code
cleanup. I hope nothing breaks this time.

Best regards
Marek Szyprowski, PhD
Samsung R&D Institute Poland


Changelog:

v3:
- fixed more issues pointed by Sashiko in
  https://sashiko.dev/#/patchset/20260323100901.4079171-1-m.szyprowski@samsung.com
  (restored use of _OF_DECLARE macro, extended some comments and commit
  descriptions, the remaining items I consider not relevant)

v2: https://lore.kernel.org/all/20260323100901.4079171-1-m.szyprowski@samsung.com/
- added missing ops assignment removal in tegra210-emc-table and swiotlb
  drivers
- fixed issues pointed by kernel test robot and Sashiko: removed typos,
  improved comments
- fixed incorrect node passed to fdt_validate_reserved_mem_node() in
  fdt_scan_reserved_mem_reg_nodes()

v1: https://lore.kernel.org/all/20260313150802.1121442-1-m.szyprowski@samsung.com/
- initial version


Patch summary:

Marek Szyprowski (7):
  of: reserved_mem: remove fdt node from the structure
  of: reserved_mem: use -ENODEV instead of -ENOENT
  of: reserved_mem: switch to ops based OF_DECLARE()
  of: reserved_mem: replace CMA quirks by generic methods
  of: reserved_mem: rearrange code a bit
  of: reserved_mem: clarify fdt_scan_reserved_mem*() functions
  of: reserved_mem: rework fdt_init_reserved_mem_node()

 drivers/memory/tegra/tegra210-emc-table.c |  19 +-
 drivers/of/fdt.c                          |   2 +-
 drivers/of/of_private.h                   |   2 +-
 drivers/of/of_reserved_mem.c              | 320 +++++++++++++---------
 include/linux/cma.h                       |  10 -
 include/linux/dma-map-ops.h               |   3 -
 include/linux/of_reserved_mem.h           |  16 +-
 kernel/dma/coherent.c                     |  19 +-
 kernel/dma/contiguous.c                   |  86 ++++--
 kernel/dma/swiotlb.c                      |  19 +-
 10 files changed, 285 insertions(+), 211 deletions(-)

-- 
2.34.1


