Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E144D105F7B1
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071216B0088; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052A46B0089; Fri, 13 Mar 2026 11:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E694D6B008A; Fri, 13 Mar 2026 11:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6FCC6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:08:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72820B6E29
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:15 +0000 (UTC)
X-FDA: 84541370550.27.A8585DE
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf01.hostedemail.com (Postfix) with ESMTP id EE3454000D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=kSqUTRdF;
	spf=pass (imf01.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773414493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=ieZsFx6ApTvtzCX6XrisGuhU15p9rYRXxzDN/ZilEbc=;
	b=YSCbRMW1wU9nXE9OuGJU6QfO8dN0HBo3Tftp1dKglXSor5V2O59ko6Zl83tsSnpKdEtX9+
	bZBvpI4EOJ8Nq1d9Ir7vg0UhJu/XqXbvsnH/s9LqIhJgKDa4Y2n9TjwgAWS//W74XgcUIU
	qp2jGaXWH7FnJe1iX6faPfdRwCdh25U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=kSqUTRdF;
	spf=pass (imf01.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773414493; a=rsa-sha256;
	cv=none;
	b=mR3TAf1i1Lt3OPbrHj1X0xcVmKHV9fEc6iilydfAJIj6BPYnJDOmUxF6VGhhFTpEa4vKJ6
	P+EbUDflgDKWbS1J/NNee0ri/ZFQORHjcmj5FPtD7XOTofC+09SM4gfVvDm9W0NZMgZEkm
	Xk/KrMcsAAbHWFrckgBOxqKlbha0Ggc=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260313150810euoutp013eba8561378f3f7b7474e80c60d139e2~cbxU0Bd6w2418424184euoutp01C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260313150810euoutp013eba8561378f3f7b7474e80c60d139e2~cbxU0Bd6w2418424184euoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773414490;
	bh=ieZsFx6ApTvtzCX6XrisGuhU15p9rYRXxzDN/ZilEbc=;
	h=From:To:Cc:Subject:Date:References:From;
	b=kSqUTRdFlhls6LGeB/gW1ePORD385noPahaD89ukVIdsLtkfmMLxMi1hRSBM4a4+s
	 fLmeERysE9XYIVodCKyzifD1u2T5SvBRSOzM43fsVtseGFxrnWB07C+7kojwAFbKOt
	 /zBYM+9w+x09ZcKH02ijpFMVQTAyrDmU+2PMlACI=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260313150809eucas1p169ab0904a217a04e0601e2ef01854c73~cbxUNE6ka1866218662eucas1p1i;
	Fri, 13 Mar 2026 15:08:09 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260313150808eusmtip1d9210d2958f7bd448b7051b9db3217fc~cbxTpGxpl0299002990eusmtip1w;
	Fri, 13 Mar 2026 15:08:08 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Saravana Kannan <saravanak@kernel.org>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 0/7] Refactor reserved memory regions handling code
Date: Fri, 13 Mar 2026 16:07:55 +0100
Message-Id: <20260313150802.1121442-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260313150809eucas1p169ab0904a217a04e0601e2ef01854c73
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260313150809eucas1p169ab0904a217a04e0601e2ef01854c73
X-EPHeader: CA
X-CMS-RootMailID: 20260313150809eucas1p169ab0904a217a04e0601e2ef01854c73
References: <CGME20260313150809eucas1p169ab0904a217a04e0601e2ef01854c73@eucas1p1.samsung.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EE3454000D
X-Stat-Signature: hktrpbfzenwu8yitsrn6p9hbkh799u6j
X-Rspam-User: 
X-HE-Tag: 1773414492-433715
X-HE-Meta: U2FsdGVkX1+i2glBOEreUxdB7TFG0e9Ydlf7uIMMojMUoe8TifV55zheWBtEezgOIf4tCVhygOWrGVE2rH91HYi28z6R4oQrw0cDcM+I0PWQIGfy4w47RbBSKUFcsc8mI1pR45McD4PVhwrX6t3THR30QxiX0dCuHnq8aI6BQFmk1lLWKTeINsiYbkgk8/5opplYR0frrs/RW2Afp70rF6oh1/mtl8ggZx45wKVyRhJ+UCUBd4U1fh+qHk9Ab+i2aSwLWf+lRQcVn73HkZ53vDIBrhUoFXF8xk4bSaZJXLIxJ76YfNO0X6wzijei4TVpvaeACVvwMFeXAfQUKncHBEioxez2xCanwBge65rWuJTblnzIGnK0xNnlSThXLTznDQppU6MhW5Pjj/H9J+pqA/7oxkXBoKRcnPQtwcWClI6ti6u1fSA8CWKCCcibEXohpzdllNqb0LL/JqVlSnj52buxSIHCNe6G77H24aveB1t2/pAgyM3Uv2F0I84dkwCv8ERt6j0Ym6yWc+418C8CYzn+uIYjYCpPPYSwNGXzqhvVsEDMY6PsQUUvH1pDAMiaJZ7oPrPTXZs94bey0M6/TLZOcxUuN5qeqxPNm2oQWgrfrlt64yehaxj42BtQxBxwM45bfKpJHGqa7l0VRXxsTunjPeu9kiWA4ykesBJS99ZGXLEm8QZnXPUj+ONhulSmCoyUx8g3BPgC/wCFsZ/NKQFBCXPcC5LoHjW7nd56nCTf9sZzSV6GWeWAVb2Pvk+Rqw6qi8aSj4uEWOSi1j08/8cXE2dnWZy/ORlvA8thLnws58asxLgLjwjFdcBRpxd7qy5/KB8IMQxiKBk0cJCphUeJll92X6MeYVAepN4uC8+DjtPQsCMRDyGKA5DYgCIaR30IpIFWINdG3I4+fBeZRDdhPWxriBZE6VAkvPbuo2vn0dbyd4X86T2PWEMpkmPMGbdbCtGXL4QkSnRXkCS
 QsGD/U4n
 XvdMtZ2HZ6OZOSbAlMY34aniltz7q3ltCiex/vfbuYc5OlQ+/+Pbw/FYEAl6MErXwOBQHCsDGW8raEbkWGZ8Dh+5gAw==
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

Patch summary:

Marek Szyprowski (7):
  of: reserved_mem: remove fdt node from the structure
  of: reserved_mem: use -ENODEV instead of -ENOENT
  of: reserved_mem: switch to ops based OF_DECLARE()
  of: reserved_mem: replace CMA quirks by generic methods
  of: reserved_mem: rearrange code a bit
  of: reserved_mem: clarify fdt_scan_reserved_mem*() functions
  of: reserved_mem: rework fdt_init_reserved_mem_node()

 drivers/memory/tegra/tegra210-emc-table.c |  17 +-
 drivers/of/fdt.c                          |   2 +-
 drivers/of/of_private.h                   |   2 +-
 drivers/of/of_reserved_mem.c              | 289 ++++++++++++----------
 include/linux/cma.h                       |  10 -
 include/linux/dma-map-ops.h               |   3 -
 include/linux/of_reserved_mem.h           |  18 +-
 kernel/dma/coherent.c                     |  19 +-
 kernel/dma/contiguous.c                   |  86 +++++--
 kernel/dma/swiotlb.c                      |  18 +-
 10 files changed, 256 insertions(+), 208 deletions(-)

-- 
2.34.1


