Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D50E3EC01B9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DBCD6B008C; Mon, 23 Mar 2026 06:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338BA6B0095; Mon, 23 Mar 2026 06:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188226B0092; Mon, 23 Mar 2026 06:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3A326B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:09:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A5C813BFED
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:13 +0000 (UTC)
X-FDA: 84576904986.19.A799B0D
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf21.hostedemail.com (Postfix) with ESMTP id DD03F1C0007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=qPpo4h2L;
	spf=pass (imf21.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774260551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=6U023ro9kxomqVcVF/r7g//Mb/LGZ46g5cga3RP+O7c=;
	b=7yz5FigV9AOjTIUWNfISsEvE7iKyJ153qZNvu464qx2JPwtxDeoPKz6ceXeshvO5eH+UKD
	p/ca+GfXLueI2LRHSUoLSUIZ4Z/H39chauGZawmFGvHe3cd1IK69EUjyexCNE4szsLRGBW
	aBHD9L+V6ikXy/aa4RF9BNfEDy2KHzs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=qPpo4h2L;
	spf=pass (imf21.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774260551; a=rsa-sha256;
	cv=none;
	b=TQjeZhlPXmo2CM7Dx5N0iaqytJntwUK75sH/CNXgF8/lvgLUW8xIGuvJKpyXMX5cmpDN3V
	x5T6AXGO6eVxUDLaV+DPgwPJx+wk06otYzzViLJLOaKpDpjkd3lbaRyR9RMTKvt+lQrRew
	Q4UxrYK4nCtMCOVUUY4Z7wi+UW0e/EE=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260323100908euoutp01e66504f83bc26fbb150edde81995fcad~fcJF8SHvF1314013140euoutp01X
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260323100908euoutp01e66504f83bc26fbb150edde81995fcad~fcJF8SHvF1314013140euoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774260548;
	bh=6U023ro9kxomqVcVF/r7g//Mb/LGZ46g5cga3RP+O7c=;
	h=From:To:Cc:Subject:Date:References:From;
	b=qPpo4h2LLV/dgQcUT1G0Ov9ns2N60pTIab7FagGkM7KCU/Y3efhUHvyLoZpJU/m5t
	 wxBXlIN0YeUxt7UtpeqGaUZmzMtDQfbu+CQD7xje0cxP5NBE62W/UJ6du5XZG2ZDQT
	 LV0r+Lj87J8hkA71T2MMeIRmKFCjAkF3vJoUcs4c=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260323100908eucas1p2f471760fe1b26181c9b0cb90dd0739a6~fcJFtZAtx3016530165eucas1p2O;
	Mon, 23 Mar 2026 10:09:08 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260323100907eusmtip2658502ec69d59c68a76f64db0b353a36~fcJFHlhjF0976309763eusmtip2h;
	Mon, 23 Mar 2026 10:09:07 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Robin
	Murphy <robin.murphy@arm.com>
Subject: [PATCH v2 0/7] Refactor reserved memory regions handling code
Date: Mon, 23 Mar 2026 11:08:54 +0100
Message-Id: <20260323100901.4079171-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260323100908eucas1p2f471760fe1b26181c9b0cb90dd0739a6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260323100908eucas1p2f471760fe1b26181c9b0cb90dd0739a6
X-EPHeader: CA
X-CMS-RootMailID: 20260323100908eucas1p2f471760fe1b26181c9b0cb90dd0739a6
References: <CGME20260323100908eucas1p2f471760fe1b26181c9b0cb90dd0739a6@eucas1p2.samsung.com>
X-Rspamd-Queue-Id: DD03F1C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: 97nncjihkipbgxauh9nxgon9a8kwewmt
X-Rspam-User: 
X-HE-Tag: 1774260550-985944
X-HE-Meta: U2FsdGVkX1/onabAwqcFYR2NEyMWQgpNJ8yyKFKkoEgqGEyd/A8ATCBQT/YTK1QfTSZTtxI3gjDovKOT1wiJAtoRXCucpejW5Zc7ookEKos9v2wfZ9XEHZ7PeIcHCIkhJTAOg9SJI0EFGLrHazh+L8ghnxH7KnpYg7IPbaSVj5ABfjHY392ptnOztfLTGQt3Vh+XInP7rVsfQ+Rh8vIWD/Y8x16X/lhzO7MeCDpyZqiSaW/HCzbAKnGM8AwJLGwpwyBsUd5KkDgSZ7IFz/StakQo6XdaX3sU9Yr4tGleCYsKJTwiol+QIf8N1PcIeDqpiPvpWlU+p5XAX/U95GU7KxJLeKzj78hMAWhcf8I0M9NyWsJNWcBv96vTT6f/zUttwt483UjqNxg+nTmAcn5iYmQ3f/QLG6dlt89LvXsPQjuKuOCKMgN55ixTV2a9q3Da5DUyWPT10JmbuaMUSBoYPmVgo3X9wNlOQ8V5H6T6JjSuK4F8yXqI9X4indR1lHQhGbMqENmKvtDtETyiUAO3rkXR/scY/iVP3bYOthcGlUOAKNlwuhh+bA033+LlmDqthDNhQy/HjiXVPyM2M9UeBYphW4d4g25DhPVhPUsafuOnNqeR9priODEBVpDqJqGteL3XRotdbBQ941aKqJU1qo+ytYCQSiNiVS4/I6p4drgoLQKCE4QIOiD2bStG63r2/CWlFLWkrlmiWV4zeYq3zfmJ2zUr8DaQ76JxWjMHvHnzPOL8O1f8RZZ5sW9AUzc1FA+4lozdPmutPmm0i1MPD39u7Hhmg1qP1RTQTgTNofF0Wx2ByDYnO2KAYGPdf+dR3ZPCLfcavhLLG4xYn8rCw7AVmNqgJYDzwNU+3C+8LAcNOsXEJ2m6mIELVmwJuxBQAJgviKmr7lb2EwW5TNpRsq5wBL4X2OhpsCaTdPs1TlbZNns6uh97UwRaW27d8Tsd8AlAVggXFZqfXgssvEn
 H+3Ivkhw
 1cGXfsZPu7c9y/PNDK8t5vJ+j2h9P2jMz2UaYQZH3B5c/lyQZG51ZPatMP8O4CzWiTKNp0FLSXArDCuAHzHJOe7qIfw==
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

v2:
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
 drivers/of/of_reserved_mem.c              | 318 +++++++++++++---------
 include/linux/cma.h                       |  10 -
 include/linux/dma-map-ops.h               |   3 -
 include/linux/of_reserved_mem.h           |  18 +-
 kernel/dma/coherent.c                     |  19 +-
 kernel/dma/contiguous.c                   |  86 ++++--
 kernel/dma/swiotlb.c                      |  19 +-
 10 files changed, 285 insertions(+), 211 deletions(-)

-- 
2.34.1


