Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D078ECD342C
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 00:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC7E6B008C; Mon,  4 May 2026 20:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4C26B0092; Mon,  4 May 2026 20:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 764E06B0093; Mon,  4 May 2026 20:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60AD06B008C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:27:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0AB0A160310
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:27:45 +0000 (UTC)
X-FDA: 84731478090.26.0DB5A2D
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id 494034000B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:27:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rE11DwdS;
	spf=pass (imf07.hostedemail.com: domain of 3fTn5aQgKCCwaSPIeIRIOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--skhawaja.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3fTn5aQgKCCwaSPIeIRIOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777940863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fPL/zEjIbq1+/WxDxvRlbVhXmcB0wkR7Z2KUt1rRxnY=;
	b=JksDylF1Q5k5yMiIGJ144Nj7Tmi/ByOMRMwDD0qgujIUHzY0K7HS+f+FZT8ujTuXR+AH8N
	UVfZAhgKqq1VwKhzQ/MAYZKcJP/rfBHtBrQIc80nUrm/DJEBToEnbOg5Jhar30GFS4IKEn
	WPAd0U6Vw5ES2Bu+P4ROgr+93bQwHxk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rE11DwdS;
	spf=pass (imf07.hostedemail.com: domain of 3fTn5aQgKCCwaSPIeIRIOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--skhawaja.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3fTn5aQgKCCwaSPIeIRIOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777940863; a=rsa-sha256;
	cv=none;
	b=ryCGaY+65xyhpJA6PYh9j4shwEAG7fd+dzkSaNKcnb0Q/vKsSf8H/5lp+l01Y69R/LHzfy
	lU8amu1WPr1bcmFfj+xTds77VgRFQQxjSbaOX8sNnNbcKSdzIvjI8PJ61oXsNBLHbDr475
	LnVsJAJca4t5/eb412PAOixj6b4BpEk=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-83565161a6eso733634b3a.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 17:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777940862; x=1778545662; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fPL/zEjIbq1+/WxDxvRlbVhXmcB0wkR7Z2KUt1rRxnY=;
        b=rE11DwdSTog3GUWgIXawxPhdXg06hWY7Nn4uCuq2sVq9euQxxJIshK08A3cASvjbNZ
         4OwNtEsV5jj2Qo+7bUGIXG+dzdb/KmJmeJAmTMoZ6omel0ipnA9SaYgdEnQxcNwiXTMq
         7H+cujwR4cRlRRDDsLpkpevfUYvUleSNgrCSkEoJQvaqEPqmmUMOkwvh4oNlMoE8GSQI
         ybppOumj4YhxKpCod31PIfjz/lV73LfOcw76RCmpaRITNeRDqoE7vs5Z0GzXSr2TeENy
         5pGN+4mZePmvXLEBc99VCA7+cYtZrIVoCLekCt52GbozvGDktMr+V5tcSGdEIhjT3G2U
         Rxcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777940862; x=1778545662;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fPL/zEjIbq1+/WxDxvRlbVhXmcB0wkR7Z2KUt1rRxnY=;
        b=fIegVskbyoxP3eMXy5JiXfTXpRo0wVHSU1MAmzWpJ3QaDCTdDT+/mxk80dMcfFFP8z
         FvmH3Wx24Cx8DmU2Ax3M/osUWmdNZlIiPa30FW+YNQVbEOWKRGhS68yH8f56fL+0vVzD
         zLvtbOaOcrSBmHqZqynzdbYpo8eMyGu2M9fsM36S7Ce0EALOUSXs+DqFU33+CB96Wqa8
         rvIbEf7cibpVb8F30xwLbq1FpBWfFFGK5576u5LvqcGAyFz1wiLYKgUdQhYUHlxayw9H
         YaEUH7fxjuCK+nifiEGjolPsRnwAEyjf1AVrSFMDJQ6TwikyUU7l7Ce502Ft6tbZt2dY
         n+Ug==
X-Forwarded-Encrypted: i=1; AFNElJ92pQUbFLZjjUmM9NN/B0d+7wZKu5RuI0XVJRW5hnqa83rYvNKXRSEW1MJsdNr8Oe7xxZic/0AX1A==@kvack.org
X-Gm-Message-State: AOJu0Ywj9rGlG5Y550SJEVrIuJyYI09EMg0/bhN0zZ1C9/0jTHOdf1gM
	SvKKHzvUE0W1J/4VS9cxTiSBR+woCpsg6CABdVZxYSPgbAYqcGoZmJ7KZADDYth8s0LXyZXVHu+
	H+5rWPCTv8c91qQ==
X-Received: from pfbgj10.prod.google.com ([2002:a05:6a00:840a:b0:82f:d8c0:fef8])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:340e:b0:837:8a0c:8f70 with SMTP id d2e1a72fcca58-838fe8703c4mr1212855b3a.28.1777940861986;
 Mon, 04 May 2026 17:27:41 -0700 (PDT)
Date: Tue,  5 May 2026 00:27:35 +0000
In-Reply-To: <20260505002737.2213734-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260505002737.2213734-1-skhawaja@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260505002737.2213734-3-skhawaja@google.com>
Subject: [RFC PATCH 2/4] dma/pool: Add an API to check if DMA allocation is
 from pool
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
X-Stat-Signature: zq4ibwfzep89597a6razhqa9p9xh71p8
X-Rspamd-Queue-Id: 494034000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777940863-921604
X-HE-Meta: U2FsdGVkX1+Yy2p0D+ODigKMKaT+pzodm1EjTd5PfKhIN5sCO3WcV6F5N4UnVvt+3CvW2syCeu6hW1nuxDs+lmlH1CLb+gvtSZ4t8/ZJnuobW9/Iz9ohLBuI5ZrDL/decGDv1tW2PyrCJJe12+f9XKTJa3QCH99jbnwdqstBVaBP+ps/5tnbu2EaHh9aWCy1bYuLaaP/0ylzlVXkU8MJAzitpaZs00pms0yS8gU8Sd5+KKuHHubrpTg9HTov8H5+tHXuHnJcmjMHvOCy5v5feihulx3vv4bGL1BWoJFobHgdJ/axg2Cx7QmJOW3GRZoXt01+ycUkID66lqXVDM9wxlr2qftzjegdYbIfNDgf/RNWcS3erLaFg+uhL86DR2UGKjTBdYNQ/eSRiexwBzM71MPuricoujJ9S3ZCDb85fOeRUaUsWI2E52fblZF11qtdIKdXpP8GJnpVq9+UtfW1eBD53Qk9eGPF07rPv4rUxmYIfVCJr5R6/xmWAO0Jc6PaUR/+CZ3vZTnMZIDeRJj5NXUzcFpX8LetfYDw6DtIQLqBQwvTfmDOiQaI3qdkmnYshE5ALypSB027K0MdCrVvFOKpUWe7KC52urfZ7DnLYZW/9Afwfuyst/JdNN505X4lPsv4Ik273PU1KbXWN/EfQzxsnWxiFCB2QEy7CJ+USPlXdwKZbXRhWgdhu+O19UWOVpwLUBwhdmpuIDAm9TlEGk9bmmpCXE0PVb4m017wmP3wrilbAL+4DLMLeMjoY0t8w03jphxVK13b+/vq+J4rQXDk5f7xKiG9OblskfZOVuTnYa0DT9q6yulRpN03RKthwqmSZ3lHTOSRkzNOACbNeE+RpaVtwtvnGTN68rK55oSBaX3o152Z5/SFHyWd8GobhZjqLhMcuJMHyVJOXWSckIlW9CzeYWdYTu1U/wVHDMCk2Lsuc70i4Tp6HW9uk9WH5Bzef/nSWLEAvpcnVrM
 6xNRmL8Z
 vVPaadnvxzOwh0RXVAE4p7U8vLahmpGpeshWmdP2no3rxT80TS686sKflM6Nv21zUaDoagYStDvfePUrMsTcMzpWm5uCZdaZNi1OHLhqGWFbXPPF9GcxLT01VzZTOiARKempOqM48zmsyKodDkzZb6GNvY6KJnR+GhnFKYdk8rldV1GoXKKFeYiu4xZ6nfeOwjCI9PRuErgPpisM6a4rIJKKH3lmr6RoAIoadDWfrRE3G1FJs0JQ6ttX3dvj1TYtRtO5z+HImO6cauCHkSdiBXSsHP1QAeNDyMCm5/HQHh3aNgGreAnk8BKJtxKp/HM2LcWSOBO9kgUni5v4/1rX5lR3Vi9R7q02mVBFSs+XU84fGwH4zo7/+3USTL3YKbkDEG1HlehUBXdKLjIpLih9YXrmVyABETRRnkLsNocUQbDEbXfp2Pyyuw+1d7gT3O8W4oXc26SdgLa3ai+zH1zcjmZB6Cys6E9mSyKNwyYYCW011mZCSrqa633fZekwzyvm+SsMFqtmONrU/+uSMrOfDz2RVZu2CiVsExMiXKGMTwk2wxOUuR/PI5GiSE8eZCzq1r5UYKwaSMl3+wfRWUivwZdHIQw==
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
index 6a1832a73cad..6a0bc4ea2467 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -216,6 +216,7 @@ struct page *dma_alloc_from_pool(struct device *dev, size_t size,
 		bool (*phys_addr_ok)(struct device *, phys_addr_t, size_t));
 bool dma_free_from_pool(struct device *dev, void *start, size_t size);
 
+bool dma_is_from_pool(struct device *dev, void *start, size_t size);
 int dma_direct_set_offset(struct device *dev, phys_addr_t cpu_start,
 		dma_addr_t dma_start, u64 size);
 
diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 2b2fbb709242..32ce4d6d7683 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -307,3 +307,16 @@ bool dma_free_from_pool(struct device *dev, void *start, size_t size)
 
 	return false;
 }
+
+bool dma_is_from_pool(struct device *dev, void *start, size_t size)
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
2.54.0.545.g6539524ca2-goog


