Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19784C44508
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 23:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735D56B008C; Wed,  8 Jul 2026 19:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D9B6B0092; Wed,  8 Jul 2026 19:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624206B0093; Wed,  8 Jul 2026 19:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3472F6B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:49:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91C84168BEE
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:48:59 +0000 (UTC)
X-FDA: 84967252398.28.AE732FB
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id DE934C000B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:48:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="nmXoiJ/0";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 36OFOaggKCEEvnkdzdmdjrrjoh.frpolqx0-ppnydfn.ruj@flex--skhawaja.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=36OFOaggKCEEvnkdzdmdjrrjoh.frpolqx0-ppnydfn.ruj@flex--skhawaja.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783554537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFhl1KlUjTv27006fhIt6b3pOPGmn7+PIUCxNMQiXPw=;
	b=uzoUxHpO79HpQEV0QkvRDmLd8VA5LeOIGAiznqU6YbcoGVo7Fl1QMOCPmhiGq9pMOwPPKk
	HrwY3F0BsZIuwlLa5si972ONr3lluwUgDgYyERyt6Jk/oQ0tpRP2yPMN64qf8h9tYQEIuE
	8lnE48F6YTT5qTWs/Kgmn9CRyE7Aqks=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="nmXoiJ/0";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 36OFOaggKCEEvnkdzdmdjrrjoh.frpolqx0-ppnydfn.ruj@flex--skhawaja.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=36OFOaggKCEEvnkdzdmdjrrjoh.frpolqx0-ppnydfn.ruj@flex--skhawaja.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783554537;
	b=XL1Gdrg6MYifaHQF+XPWi7tmm6ZlnBJmWOk5yI3om6RC4xqxuV5xzlM8IEBldaNNlQsTsI
	M/KklbHhHmyrb69PlcVO1gvnzecDu3PKerja0cb96swJj7DHsqhbXkCbkK2zFvSAn61/KZ
	xuhRGTy+SgXmNzSKzfCM916SfyqdJfU=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-84770f89b99so436191b3a.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 16:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783554537; x=1784159337; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aFhl1KlUjTv27006fhIt6b3pOPGmn7+PIUCxNMQiXPw=;
        b=nmXoiJ/0zbqIGmJSbgn4DUYHXAWuTym1hHqasVdtQZGxvlOgkQj4g8fh/UL9WlFJWk
         oV8miPvF4LCHqq35N+UgFCGO/Af9XkxfFm9g4G0N0l3ov1rFUCRt15C1cBTQXYAvWaab
         1P9LQokH53WyKR4SPx3ggqeKOWhJEtVN2WO3j/gsWNy1fFt2QHHMg4NE3ENh51jzjMEh
         4abbpQXioxbExlWfrHHLBtwwB4IXlWv8ICRjPqjn9Wn2wMw5ug+sEMwME7o8QrDLbXeq
         t6BFFFsxJGNgTga6cJ9lctUZjBNysJs5jIXibirtoeTBzd6o20dgLCUB+2vldroO84y6
         sAtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783554537; x=1784159337;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aFhl1KlUjTv27006fhIt6b3pOPGmn7+PIUCxNMQiXPw=;
        b=dr0Ey50DUot8SyAp5pok8ir6qIOokUivNZIy675e/WI90YY/LiIlNbuLkYG2nHOiJ2
         1z/oauEWiGqnSZ4t+ZRMaWdLxrB5JxefVmPxM2Hy46rO4F18Xjb2dC8QhZcNqMKDQhOY
         RBT9vfoPmibHXRn/a2/f1Z+sp3ASPJfrQYZ37PIEssTRuAOGr2JMboZSqVBhMD9Wy0nM
         ci+AMImds7VVAl3BtvjOmbwKakgWePL8yJl/s8im4oz/UpLW6JP5qdFEUQQ62LX9rTvd
         RXR36VnrGhkjOt6AfSIfmtbYIrtyc0k6MbSGsFBoG/MXLQZtvYeQAzqvNC327rCCdPAS
         lxXQ==
X-Forwarded-Encrypted: i=1; AHgh+RoRd/ckrDt6ox7BjR1sIV2kysEhbmzPE+vrMRgw8INxGzONabx0Dp7WsPdulqZp9vr8ydBxatrO4Q==@kvack.org
X-Gm-Message-State: AOJu0Yycc/atRHPTZe/UX3+Rlob2njVF4tPnyhN4mNyHOZFeAJqp6/UM
	YHBYyKfaa7TsmjuYm+7raW54B5KquZ9z3vAR+ryHfzDPx/GTlHk/KzdbZe7Zkn6rs7A0LtSApLu
	VQC5rc6uyx0RznA==
X-Received: from pfcp8.prod.google.com ([2002:a05:6a00:a248:b0:848:4e44:7f19])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3e12:b0:848:411f:3969 with SMTP id d2e1a72fcca58-84842ee66f7mr4071344b3a.20.1783554536532;
 Wed, 08 Jul 2026 16:48:56 -0700 (PDT)
Date: Wed,  8 Jul 2026 23:48:46 +0000
In-Reply-To: <20260708234854.4044652-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260708234854.4044652-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708234854.4044652-3-skhawaja@google.com>
Subject: [RFC PATCH v2 02/10] dma/pool: Add an API to check if DMA allocation
 is from pool
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DE934C000B
X-Stat-Signature: 5uoe1jdmgkezzf4j31ka6yt6c3kxsnzr
X-HE-Tag: 1783554537-41370
X-HE-Meta: U2FsdGVkX1/a30dqmB6KRvnkFVJo9dES2p4++CS1S53IbKflSKba0NU9mzWLDBSsXfYxHpg1j1ofvE1Wt2k1kxhvkLqQFxcSTkk/AawpQA4fTwhy/L34AljPM3qVFTohvMsR/W2XJ8ZzUFpvhsMNoD6Ns0D75ld/kXA9h55XWDtUxBLllJfo/Rkmy3sTLg9f3NyO9OpnlEYee8vUiza/Z/vBtVmERCXAFXnDTP4d1fCK7JV5Aauq8v9c/j2OdpxutLtgl2SuKLIiGeuaYNy5RgnKYXLaglvFZg2B8nO4Oo74LFFAe7hNY7ljO+BVSqsw9SD9g9zwlwQV0/zZhpCosAMtzaL0Iz9SBVECkfmz7YnUyrjEAhcCKmwFUlx2FtinhwlWgS894wfQFLBMt4F1iBzgYvGTvkwKq1smquxe4ctPL0QJx5xjrmRxL9TwYMwhK4LKUWAsVsJ4j7BhZrOC7tTLOWM82vDY5PBn9b9MpbhofFHakPYsWKra8ljhcMVux+LgSjpBAzV0TjtCuBInvrrnt9DtYSlmj4/Xq2HDKn2wIlsZMUa/gL5N6d1bBPCfnoqyEYmD8YnOLdxbmZINImeicp9lhGgOHLMIzwPZDjwsHOOLJgD8ggwctTe3eoUEWvgSHh833cuHfErW0dlN3W9REuxuMS1db2Us0HpoKDQYmqaTeLH16/dgPqXhEpAR0tqIm0FTwWK+mYYnwBoxRTiKc0eIY12Rqi0QubG+16sd6OOd9NtEfI48Ub/nbGYqtQ+Pu0ZJQnPlRn1xhbmCBMj4RSeprPgL8B4cwtsPaZYYbb0FCbHspUpvcFLZJwby5BXWWo6BPbGAdQCqysynafP40kvx75NbIwQJqMqA45rKId/7H3iUpEaao2DXZvNf8M8RsQH4L/0GYW6LPfAbJ+n6iaGQEfM8LjwKYBfWfX8lvYdW3BeR17MBCXNNbsDfiBwdJ1Mav06pwLweKvJ
 F+Y2tT9X
 Uo5pIb1ilAwd/1xgeCicx+35wwxKPMrDw/lMtDa5GsR81ZJzRWst94tkvB3KCaJm3tkl55UTtjQjTaMEio+B2Ow/6SpObowqk+Ww5T7cSnJ4v08gi8cPoCMJUQUWyd9WkeAt3pF+Trat8zy1b5eZTsfP3fQUb1+rAWhV2OqwZuZ7Z+1KldFA15oSPph4ptAiC3MI0UoEiYfwY+7EQHB9NcQi3C8qFmf9ll6m3elO8A4bATX0RvUcx5KxkMHyj1fabsUG4+b0QSrn6thgM6quLK/kdHlM2BwNZbK9AA+CY2AWDENJjtWRaumzNqYi2qbVn6aKbjDPqyiH0FDz7+1sHn9dgyFl1xfp5GPSW5EHtudQ5DyOUVY7vDWpJbJoXZxCH/qoZH50b21x4wcTKa7vi6Y7NvNSIccGkSWLTUSRESjFWRA7mxB36RCML/Qcf49LfUtjWyuUy/VstNIdRnwAxcBJL81djBHTPN0HPYC5NAujtR85W70qGzPovriX+yWP7kYHvH4x3CJQ7NpvAbTJzb+QsZKLVy2p4CHEooTr7+UYG3FOp2mVPCeOfrWEH56YTDTRmQzZUxTOpalRS0OF7n5lhbgBbkzn6F0e6QKP5o7I+MC8CUMzmCuVLDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DMA allocations can be done through DMA pools, add an API that can be
used to check if an allocation is done from a pool. This will be used in
the later commit during preservation of DMA allocation.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 include/linux/dma-map-ops.h |  1 +
 kernel/dma/pool.c           | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 6a1832a73cad..9382785a2faa 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -216,6 +216,7 @@ struct page *dma_alloc_from_pool(struct device *dev, size_t size,
 		bool (*phys_addr_ok)(struct device *, phys_addr_t, size_t));
 bool dma_free_from_pool(struct device *dev, void *start, size_t size);
 
+bool dma_is_from_pool(void *start, size_t size);
 int dma_direct_set_offset(struct device *dev, phys_addr_t cpu_start,
 		dma_addr_t dma_start, u64 size);
 
diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 2b2fbb709242..d1a0bb03e478 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -307,3 +307,16 @@ bool dma_free_from_pool(struct device *dev, void *start, size_t size)
 
 	return false;
 }
+
+bool dma_is_from_pool(void *start, size_t size)
+{
+	struct gen_pool *pool = NULL;
+
+	while ((pool = dma_guess_pool(pool, 0))) {
+		if (!gen_pool_has_addr(pool, (unsigned long)start, size))
+			continue;
+		return true;
+	}
+
+	return false;
+}
-- 
2.55.0.795.g602f6c329a-goog


