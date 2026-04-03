Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 924C6D6AB1B
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 00:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 072A86B0089; Thu,  2 Apr 2026 20:51:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04A5B6B008A; Thu,  2 Apr 2026 20:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2D06B008C; Thu,  2 Apr 2026 20:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D72446B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 20:51:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84E251B71D0
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:51:50 +0000 (UTC)
X-FDA: 84615417180.08.D0E119E
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id BE0141C000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:51:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=C7AhoVcN;
	spf=pass (imf20.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.172 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775177508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HM9+eAkKdOrABgkFmwCHnBiWfkCG9uPNCsfKJXOxWMI=;
	b=HoJaeT/oHKka0JxJRTAa7/95Rfi+GIG48gn/M4BhEvAVZ7o+jyXOMMI4anMDFJln3/hUyb
	OcR74NeO0F1M4vDzaZXXgtFza9WjtcI6bBE/hU1/zYZZ53lOqoyhraY8dHzhPb++0itV2c
	7G0DVi8GL8N8JkLjo0JlmODqWDH3llM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=C7AhoVcN;
	spf=pass (imf20.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.172 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775177508; a=rsa-sha256;
	cv=none;
	b=mz/PK+cKmhxF9yeaK91IstTABfwZBtgcQjIivq4rxJK2z+4oGyIyvr7TQOh8eoKIMZjgQ9
	b7EMqSg4bS+rdjcDq34lmxRViRWj4+Ui4sLFjYi5QiQwC7wY8ksDhqhOzYIK7HX7Q8ryP1
	OVVFF9KQLzdPagHPZ/3PUBid25iie88=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2c54c68db4dso2775235eec.0
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 17:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1775177507; x=1775782307; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HM9+eAkKdOrABgkFmwCHnBiWfkCG9uPNCsfKJXOxWMI=;
        b=C7AhoVcNBfdYmStSTEsySS8OC62X+xmCg+ABXamKZx7tmf2OZkdStJlvlv9ku1xrz8
         AQAJ28NIkedjQETwLh0RTa7PLPIL7zFZMGmsCQdwty2MeL5Libbxmnv9jzuYpOXNBLr+
         sMQN7pPRQpF8yfr8yvhNNs7O19cHUvhj3tiUc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775177507; x=1775782307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HM9+eAkKdOrABgkFmwCHnBiWfkCG9uPNCsfKJXOxWMI=;
        b=IpKIGC+JjLfFlFN0798WBhd66+sifyDIQS/zEIZZsCKCJ+yXncv+O6Vq6Xeu9FDlD2
         zAocaXzdOPqgC5ilIxqXigt5+JOgrUifmvzEV2vE/310lS8ZpbIxJGJzb7pzkqvrYOiC
         nv2bzuQoywKItsdt3C1nrydS0kNDm/R4j57na2NkQhryUdxpAjrC9yfVv7Xyl4y7EDe/
         vDb/oxIcI+dk3eVp/LoUAZFiD2H6u97TLPjAQphN2h/Td7n/uA4GvIbZA9Mq8swLIEAJ
         bmjDEpecuUORe1Zm5r4MI7qIv+iIZBKaVJYRMEPTv/0+v4sQxYzjdCtJZdPRKtSme9J1
         c9zA==
X-Forwarded-Encrypted: i=1; AJvYcCWL62FuVSGvHgsC3DcCBZsKg9TwPIB5pOTjN9+SNqyg5vGqiuWrKkhCIe/mHqtfWemvAzyIJsTHHg==@kvack.org
X-Gm-Message-State: AOJu0YzfK9Pvs/hXiBR9Oovd5IRrt9GTiuFpxDF4fSzcokZTPE8PB1nM
	KMhFvcRY0jeXgcUacTQV/yR82TivlexYnwsbK2yugk7mVkIPNHcxkY3UQuLuvIYD6Q==
X-Gm-Gg: AeBDievkKyxUhDoAgJX4v6UeeKsD5GL/uNwc3iZVbDWt47Ztam5o7jLwpDOV9RUl9AA
	ljRfttybAZb1141kO+5vgG17hmWTU2Qv142YDW2y7peeIAtZBpHbTS6lMiLWAx40kqaQwPi+CTW
	CphmFpyseEuT5X4YWxo38g9scykxL6Axo24qGdciYsJP/lTCDEymYrZ5mUiRePMjX+iWXnYOij+
	OXbSeAFiuszQ/iR23YuxejzRCTOoN0bxvV+qDRKtziGdxeRx80RqLQbMrlJZOSLflWxgFd1xlAD
	OHk5mZBkjt7qta/KpJb/qvg2vHFWhlVJeWGjSaM9RabgVXAMBbUQpUTJv+mfQB/iIKsppmiDmhH
	tHi+HCufxscIlWevSXzlrfLBTmvAYJiTdSJK/fv3UkSw9htOfz1h5D11Vyxx/K/hNiTd22nw9xC
	9n2Cy/X29ei8KNOvXt7zK11+Q5m8oIItidHy0E+p/3DaDpRwM08H5ZvOrb03vWHDZYXmOGriMdZ
	q+/cgqf9pw=
X-Received: by 2002:a05:7300:a506:b0:2c5:50fe:c786 with SMTP id 5a478bee46e88-2cbfa2ce19dmr720875eec.9.1775177507537;
        Thu, 02 Apr 2026 17:51:47 -0700 (PDT)
Received: from dianders.sjc.corp.google.com ([2a00:79e0:2e7c:8:5db3:7542:a530:f43a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca78df3b84sm3630074eec.5.2026.04.02.17.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 17:51:46 -0700 (PDT)
From: Douglas Anderson <dianders@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Leon Romanovsky <leon@kernel.org>,
	Paul Burton <paul.burton@mips.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Toshi Kani <toshi.kani@hp.com>,
	Christoph Hellwig <hch@lst.de>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Johan Hovold <johan@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	driver-core@lists.linux.dev,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	m.szyprowski@samsung.com
Subject: [PATCH v3 4/9] driver core: Replace dev->dma_skip_sync with DEV_FLAG_DMA_SKIP_SYNC
Date: Thu,  2 Apr 2026 17:49:50 -0700
Message-ID: <20260402174925.v3.4.Icf072aa4184dd86a88fa8ca195b09d1651984000@changeid>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260403005005.30424-1-dianders@chromium.org>
References: <20260403005005.30424-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BE0141C000A
X-Stat-Signature: 1dcu5kmgpmbiekmxbxxkeryqdtinw8ik
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775177508-601381
X-HE-Meta: U2FsdGVkX1+QdIpMFYfw4Ebs+j8R/500p/GWi+JRoFWS9XpvARseF2MsthIEK9/82wAC0HkoK5gBan6LTFOq9uko6aNm8cnRSLibaI+0rJIndaIPdgCdU0GL8SwaH8f1nyN2RqsTpvZP1kJOElj8Q4pUqnRw7D/5cUMIIcrzuHQDRuluvuF4kIK4+MWSLBui4AbRisNrJuj7aFSpt8gYrkR8JcC+l5j+q3jUKhWU81WnP2MrIEdeqSP1Ozgt6MENyeIcCWcV2ZVgDnL+Mv0DSbVKfN7aQ3QI5UOaKNMca+b9i+0qI8mpwi4cFDa+21igPdalWVpHY30H0W+ai78ssUkfBKaJZZb/D7/PdeMzxp2oKCSHkIKjDGAonEwFzlBZOx17+4kyUSu1BMv056KfNDWj5mvKmZMJepNNkoxp3ljBNt7GZ1paq7OrkwKXPBZCy9mwxyqvu0KhMyIFwHiqNNlkh7MZvKm0/fDLLWiWloOaMAPEPNzHlM2FNcaiDaQS3BbmXhE5hiCfPIuLv8FkVgIREr5OTqBwF4DNO8UmprSBD+sCv8U8irxmkwVRrwjun7yFiTp4NjScoH94/LnL3y0ypWJimBwLLP7O0/vIGM8JWBJds/K4/i4JVYyYwBHnQHT8OxvR6bg2UNneUaitsaNDFXidw0kM1C1PWfFFkM7vkM5TjVYZsQUv1JokQgu7ng5enanci/+DpBjadVvf00wDZEya74PeMMjp0PyNl2qGu9klw1yyujm+SevIj392LPKbxJj8Bfm524Xs80I7T9skXtFUbVN71njrXzLNjAk8X4cAMLK7lSYs3TF+ljP/JBSg43ivfGM5UvRoDsYRabz+aCySaqoo7r/QtjfvJ9764ZBrqBa056TBd4Ccl3Qfq9bZvqfusvCuT35v7pRlRQ29ul8GfPwBz6zOaXpTgzY7GZDXF69rrOpKfIna9+KvqpRSAnk6yxRIgiIs0eF
 X1LcPh8y
 e0XivkZP36Yi9pzq6yUKtbJ2QVkAb3W9LIE8eC0H5p6ujRptx3/u14wfmnqa8T0fQOLp3cVEnjqfW9yOOq6PUn//yUi2Oi9E8JOKR5e8+flCGXCxw++GvzoNuJBCbjkGZwrz4HrozZmPskFU8ZUQSg0bRRWrDkUd3w7+C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In C, bitfields are not necessarily safe to modify from multiple
threads without locking. Switch "dma_skip_sync" over to the "flags"
field so modifications are safe.

Cc: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
Not fixing any known bugs; problem is theoretical and found by code
inspection. Change is done somewhat manually and only lightly tested
(mostly compile-time tested).

NOTE: even though previously we only took up a bit if
CONFIG_DMA_NEED_SYNC, in this change I reserve the bit
unconditionally. While we could get the "dynamic" behavior by changing
the flags definition to be an "enum", it doesn't seem worth it at this
point.

Changes in v3:
- New

 include/linux/device.h      | 7 +++----
 include/linux/dma-map-ops.h | 4 ++--
 include/linux/dma-mapping.h | 2 +-
 kernel/dma/mapping.c        | 8 ++++----
 mm/hmm.c                    | 2 +-
 5 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index e74c7d0813ce..e900748d3038 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -470,11 +470,14 @@ struct device_physical_location {
  *		until other devices probe successfully.
  * @DEV_FLAG_DMA_IOMMU: Device is using default IOMMU implementation for DMA and
  *		doesn't rely on dma_ops structure.
+ * @DEV_FLAG_DMA_SKIP_SYNC: DMA sync operations can be skipped for coherent
+ *		buffers.
  */
 enum struct_device_flags {
 	DEV_FLAG_READY_TO_PROBE,
 	DEV_FLAG_CAN_MATCH,
 	DEV_FLAG_DMA_IOMMU,
+	DEV_FLAG_DMA_SKIP_SYNC,
 };
 
 /**
@@ -566,7 +569,6 @@ enum struct_device_flags {
  *		and optionall (if the coherent mask is large enough) also
  *		for dma allocations.  This flag is managed by the dma ops
  *		instance from ->dma_supported.
- * @dma_skip_sync: DMA sync operations can be skipped for coherent buffers.
  * @flags:	DEV_FLAG_XXX flags. Use atomic bitfield operations to modify.
  *
  * At the lowest level, every device in a Linux system is represented by an
@@ -683,9 +685,6 @@ struct device {
 #ifdef CONFIG_DMA_OPS_BYPASS
 	bool			dma_ops_bypass : 1;
 #endif
-#ifdef CONFIG_DMA_NEED_SYNC
-	bool			dma_skip_sync:1;
-#endif
 
 	unsigned long		flags;
 };
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 60b63756df82..4d9d1fe3277c 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -245,8 +245,8 @@ static inline void dma_reset_need_sync(struct device *dev)
 {
 #ifdef CONFIG_DMA_NEED_SYNC
 	/* Reset it only once so that the function can be called on hotpath */
-	if (unlikely(dev->dma_skip_sync))
-		dev->dma_skip_sync = false;
+	if (unlikely(test_bit(DEV_FLAG_DMA_SKIP_SYNC, &dev->flags)))
+		clear_bit(DEV_FLAG_DMA_SKIP_SYNC, &dev->flags);
 #endif
 }
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 99ef042ecdb4..23273b0fe84e 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -419,7 +419,7 @@ bool __dma_need_sync(struct device *dev, dma_addr_t dma_addr);
 static inline bool dma_dev_need_sync(const struct device *dev)
 {
 	/* Always call DMA sync operations when debugging is enabled */
-	return !dev->dma_skip_sync || IS_ENABLED(CONFIG_DMA_API_DEBUG);
+	return !test_bit(DEV_FLAG_DMA_SKIP_SYNC, &dev->flags) || IS_ENABLED(CONFIG_DMA_API_DEBUG);
 }
 
 static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 6d3dd0bd3a88..f50b648ed460 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -467,7 +467,7 @@ bool dma_need_unmap(struct device *dev)
 {
 	if (!dma_map_direct(dev, get_dma_ops(dev)))
 		return true;
-	if (!dev->dma_skip_sync)
+	if (!test_bit(DEV_FLAG_DMA_SKIP_SYNC, &dev->flags))
 		return true;
 	return IS_ENABLED(CONFIG_DMA_API_DEBUG);
 }
@@ -483,16 +483,16 @@ static void dma_setup_need_sync(struct device *dev)
 		 * mapping, if any. During the device initialization, it's
 		 * enough to check only for the DMA coherence.
 		 */
-		dev->dma_skip_sync = dev_is_dma_coherent(dev);
+		assign_bit(DEV_FLAG_DMA_SKIP_SYNC, &dev->flags, dev_is_dma_coherent(dev));
 	else if (!ops->sync_single_for_device && !ops->sync_single_for_cpu &&
 		 !ops->sync_sg_for_device && !ops->sync_sg_for_cpu)
 		/*
 		 * Synchronization is not possible when none of DMA sync ops
 		 * is set.
 		 */
-		dev->dma_skip_sync = true;
+		set_bit(DEV_FLAG_DMA_SKIP_SYNC, &dev->flags);
 	else
-		dev->dma_skip_sync = false;
+		clear_bit(DEV_FLAG_DMA_SKIP_SYNC, &dev->flags);
 }
 #else /* !CONFIG_DMA_NEED_SYNC */
 static inline void dma_setup_need_sync(struct device *dev) { }
diff --git a/mm/hmm.c b/mm/hmm.c
index 5955f2f0c83d..137450e096bc 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -709,7 +709,7 @@ int hmm_dma_map_alloc(struct device *dev, struct hmm_dma_map *map,
 	 * best approximation to ensure no swiotlb buffering happens.
 	 */
 #ifdef CONFIG_DMA_NEED_SYNC
-	dma_need_sync = !dev->dma_skip_sync;
+	dma_need_sync = !test_bit(DEV_FLAG_DMA_SKIP_SYNC, &dev->flags);
 #endif /* CONFIG_DMA_NEED_SYNC */
 	if (dma_need_sync || dma_addressing_limited(dev))
 		return -EOPNOTSUPP;
-- 
2.53.0.1213.gd9a14994de-goog


