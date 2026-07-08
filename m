Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17665C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 23:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17CD6B009D; Wed,  8 Jul 2026 19:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7B096B009E; Wed,  8 Jul 2026 19:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1BEF6B009F; Wed,  8 Jul 2026 19:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72FFA6B009D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:49:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8783402EE
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:05 +0000 (UTC)
X-FDA: 84967252650.28.4422DC5
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf04.hostedemail.com (Postfix) with ESMTP id 28BDD40007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wU0FH0CZ;
	spf=pass (imf04.hostedemail.com: domain of 37uFOaggKCEc1tqj5jsjpxxpun.lxvurw36-vvt4jlt.x0p@flex--skhawaja.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37uFOaggKCEc1tqj5jsjpxxpun.lxvurw36-vvt4jlt.x0p@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783554544;
	b=wDg4P1nT+BLoCR3GZLzZAmfdEN+SQzN4XovzGjr9CHUK3GLJUSBQifBjsWcjZrq7NvVZQx
	Ue/8cP9C0YyvNJLyAnGGtbM/xr2Xdz3tNmq2qTCqAcT6OYVfSiQ4v0iY+pfmBOVgYGGzSJ
	AmSYeyC2dcg4JhoqwTfIF4PXJwcfNY4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wU0FH0CZ;
	spf=pass (imf04.hostedemail.com: domain of 37uFOaggKCEc1tqj5jsjpxxpun.lxvurw36-vvt4jlt.x0p@flex--skhawaja.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37uFOaggKCEc1tqj5jsjpxxpun.lxvurw36-vvt4jlt.x0p@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783554544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqgUUDLbrc3OMfaB+epoRKq9BuL+wqg9nIdlWGSYSoM=;
	b=enxqPy2vECd2rWGCw4NioBX6YZZwR3SYJyq5iiT+VaTM8ChrOdG+zQyX++QgZooxYSURup
	HxHGww0rHiaC9JfZtIvDbClbAp5G7lQHJILOgIDjstdhVb1O42GxizcCSy2AxBV13nAZpQ
	3CvFvUOMlTBnRQqmyXNKyMxWoq5TdSs=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2cc77a6943eso28434575ad.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 16:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783554543; x=1784159343; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nqgUUDLbrc3OMfaB+epoRKq9BuL+wqg9nIdlWGSYSoM=;
        b=wU0FH0CZAUBX/A3HiQtnFky5amfU0vYRsPkXzZ9w/2h7zFyRIf4Tmn4TZ/dnsFty51
         jVlIqX0vW2SFZ6N0lSwOKXZ7HLLuUyTCD16MAT5yJSATX/n0f72Yu4AwlwsHO7Sx/1YE
         sz+nTVXmsgGBUAjRLky9r0BfvXThCF3zw7A8pyNcnPZe3d0HJXPVeB5qqQl4G63WsTRq
         fyYE9Z+QiIBmpmGfpP9n1w5nxgI7njy6ClWyoiCGowU8eTgMV3VZDOE7iElrpm0h+ui2
         exMZIQhve7G5AQMOsv6gRxZIlCH4sQQJmlq9OTiYYNmLsZTevd3Bb37S42/2F4VRPeV3
         ae2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783554543; x=1784159343;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nqgUUDLbrc3OMfaB+epoRKq9BuL+wqg9nIdlWGSYSoM=;
        b=m2OM6HWvKb8fgF+z8ZMTAVSyWo26/ukLzVdbYqPnfh1lK+BlmjAOonbBqBOFzHu1TN
         1B9na8tdMhBAh9dNgzZ5XHggHptnquZtZLFOexDJ9DER/w0uNpZviV6qpvFj8SIgc9Vo
         GcHom8uz8p4jtgpX4WvejeY0vLuDkleu/5PWg7oO5n/DT2xJLfffNRGqLwB0Yl5PsUD4
         MuSCPnPsx/Hq5chb69e4F47mjhO/Hd33dHO2R4e2jSeha9uTAluGCWOKQZXY18DRSRYp
         bMAz9PYGBlgYJxS2zItFTm1zE4/5sHzytppm04a4Mrthbv1pJYuEzINPfniKJ7g2TbFn
         xwDg==
X-Forwarded-Encrypted: i=1; AHgh+Rqbs2LagiYwJUyr/mnEsZ94Ipz3V0P/RVe6D+Q87nLKGFEDmk69SFdfLUWS+SLNvjKwv0HRJjZEpQ==@kvack.org
X-Gm-Message-State: AOJu0YxNWosQFWDPxr7DZr7gfTzq3VOjx8teeEb+Tkvlc63WRs8pY6eD
	OS8uRY/WVSo87gIY5m4LghAnYrArFgOZ3sYVOXqD3cdiZHPIHG/MjUdkLIbM/kzsXXbmBNTEDlX
	9pUn68FX60A3XrA==
X-Received: from pldv18.prod.google.com ([2002:a17:902:ca92:b0:2ca:d0f4:2f91])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ef06:b0:2ca:a03a:29b2 with SMTP id d9443c01a7336-2ccea2a565fmr51586345ad.8.1783554542780;
 Wed, 08 Jul 2026 16:49:02 -0700 (PDT)
Date: Wed,  8 Jul 2026 23:48:53 +0000
In-Reply-To: <20260708234854.4044652-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260708234854.4044652-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708234854.4044652-10-skhawaja@google.com>
Subject: [RFC PATCH v2 09/10] dma: pool: Export the is_from_pool helper for kunit
From: Samiullah Khawaja <skhawaja@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Will Deacon <will@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 28BDD40007
X-Stat-Signature: ifpdest8z1ssactup5y1xo5r64zx3sta
X-HE-Tag: 1783554543-983611
X-HE-Meta: U2FsdGVkX1/RqhHCe1G5i45aAaU0LWBIHQtbCGa3K3TrUpwFnhcTmoD0xVl/n1hBmk9Y+ksfkIuPnjVW50ljWRXpuEKSV3wlPHZOSp52Q9joyeMJSLeNGNLXDhNoF9ri6GmJVRCId4AUXkKdKMUvgQHUG07hnEXgsR3b/5BS+qCwHrXGQZlxz0o5OM8ulOxTUi10uZdREOEpZ0jPW/Qz+EbT4djO5NUawSHsrzFkYDCjKbaPgQha98wTs6/cwOedJSUa0CFp+6bhvP1GGf5UpKCVbytPu1J5oNgAZH++VjlEw0hgUx0UxqEOEWrahqTwfEfKmSJoS0XkDaAODBS25wQxlHuBuE8X5ViQ/YkoJwpNFKsQom+tllgedB3rpmoYq+8NxRxX68DTcfPnIuP3KTWdrNWDD6k/xH5N4EhzpwYxnr7E1/UjR4Eh5b65smIt967E+zy9POei10wUo8BA36x5ZvLufsuUPVXt6Qkdlm5fFLdOdNAdXp0y+Jo0Ysxf3xVWvMOzA4E7ST8IBIZHc/X8xvv8DdVuNQn3Wwi+13u8KCx35kHT2W85icEEtLSRe2ZUocQgcU3iNoRhaihDa0P/6gw1GGwzzXeyZBkgL3VFyeObr4I84713m7gwgQK5z2S/5Yrdb+ksJxnulKxqu4/dwWBhWjpdNtqqbyysDn/VgzYPBQv7Bv+SdwVJT5+Jqe+BDRKFELwMZd5WiHUkMGVXSWboCsqmSxvcWG6R9A2xjfhXZXnrvUsJc55diXphDYePR3ih+KIO08AnhPR5vPni/U3SpUS7ndBYQaznEORxcI8FFfh0ANssg/rz+QT6HMpy0Soys//uluZrDlX6Q2AiMv1kqHUN0HuY1FTH+oUCPwaqbc5mNQLA1IWyC6vIXU+QE6EyKDitYdP2X4qAh+V6qehbz/2xtnbHRoyD34RH5XkAvxojKHGdkAKcIWeGJjRlSa0KEIMJ83EcsE8
 XojAvTRl
 pQv5vQLQO8QZRU8eKifQRyDl5wWOuOW95EepcXGfFwVgEu7frPTeNXV49GJ0c323X412+7+BEjtVRpqxmPAoHNdEJQUZcy5GRO/cXC9Kc8i2KOipgOBzmE7quu60GwkAN56pVYL2ZuB9gYFucNbIJNrKByGHOgtRCjNMcsY5JDc1/+7bBg+wOEwwhO5e00ZAedNOPoKT9kxchxItbn++yFoNIZQFNZYDDiSgLqRx8W5ZDG9dUPkLJwwA8Qvo7rCFge+dzg5vqZ2eWI+fdkXx+CBb16mFWPZ3Lij45DXkhLoFaWweEEgoM0TmcFlfBR3EuEeViPvSCN9iILSRzvmYyR9si7Ku+OCY4H5fBmO3ra9hitKXSWudqPTFIaXZYFrUminvou08xcQppkIyi3RS5Jk0bP8eH1ZrFFh3Z+GD2DNM6CAdp/5+5k10RsEv+x3Htf+ZFJmnc9qCIfkLgMuL+u3CIA3JjtDw5dIUuzi9E2K8NhV6nWAWOD8+DJDEX13EVd2cr6qGoDJ4LCxJMZI6NWl4yCMhtIql9ISxzeLLhFU6Y21my14fgqSDmzpig7qGHUX4R2DErhPfruMeHGGKF1jSd/LSqkdOeJUKsBy9O9kgEQFVE4AuS37juqOxUQCfNHYbBEKM+KG2Is6Z/onDaIQ2TvaSrdW6Gyv5tu9MpPiZ5ep0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kunit is enabled, export the is_from_pool() helper function so it
can be used to check whether the allocations are from DMA pools.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 kernel/dma/pool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index d1a0bb03e478..78496568973f 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -3,6 +3,9 @@
  * Copyright (C) 2012 ARM Ltd.
  * Copyright (C) 2020 Google LLC
  */
+
+#include <kunit/visibility.h>
+
 #include <linux/cma.h>
 #include <linux/debugfs.h>
 #include <linux/dma-map-ops.h>
@@ -320,3 +323,4 @@ bool dma_is_from_pool(void *start, size_t size)
 
 	return false;
 }
+EXPORT_SYMBOL_IF_KUNIT(dma_is_from_pool);
-- 
2.55.0.795.g602f6c329a-goog


