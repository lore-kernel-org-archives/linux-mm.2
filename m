Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1370CFB5173
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 23:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DCDE6B0089; Mon,  6 Apr 2026 19:25:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3F46B008A; Mon,  6 Apr 2026 19:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17C9A6B008C; Mon,  6 Apr 2026 19:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08EE76B0089
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:25:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AEC588BF90
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 23:25:36 +0000 (UTC)
X-FDA: 84629715072.07.D9C6D3D
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id CB31F12000B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 23:25:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PcSx7fl4;
	spf=pass (imf29.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.176 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775517934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QDRSd3siXPnUjKK6z9y9zPLL94slqZupXaMexT4yHSg=;
	b=jDpNTrPDA2T+vehzcJPKU/oTDLvBX7GI2sJGOBozYWk3B1yE98SpXCzNvp1ryZE0ewa+uK
	zIQ6KzMu48F3gdZAUEN21Y7gLoNGgY3KP7UdlW/zsGKzzP98d/FnnzniDiWI2WxNeIWI8D
	4EsaSvYslpu/SDEj1Ji2AjdxuSCId10=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PcSx7fl4;
	spf=pass (imf29.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.176 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775517934; a=rsa-sha256;
	cv=none;
	b=BnQU463lxy2IypHsdfuC4eUnNKWHWXjDfgCIxaGOJ5EmCQXB34COLpc7LW6H55Gz8ck0zA
	8bfqKjC+i4fiOedQ9Gc5eAuZMXYOBAOxoT0e8v9sx5SedqKwsLI6vOyHMLp5ybQqpWn4LQ
	C/Q1GXkKC6swm2daEZCqcgYnMVbqKBA=
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2ce102afb0aso2630143eec.1
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 16:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1775517934; x=1776122734; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QDRSd3siXPnUjKK6z9y9zPLL94slqZupXaMexT4yHSg=;
        b=PcSx7fl4Ao/sVu5Pmp6Kx9IwU0iReGomWp5Qv/xa/J8LibdpxkP6htnh2/+K4x4g59
         lwkZokDXdP/tnnkKc6ZfKjt61X60HnuPYa2xm9t3u2UIFzQXk5+Q5yh2A04EtmNy6gaM
         46Lhw8a7ZczuY0aqrAopvLPnE+OQBelh5u7t8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775517934; x=1776122734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QDRSd3siXPnUjKK6z9y9zPLL94slqZupXaMexT4yHSg=;
        b=fJGHCsrIQibrFo4LLztK6bektv3xDIN9kmKNmr9ARs3pjaSB30mHh1fSmb/kiNa1vx
         7dlilKDaZqIKaPjVf/RcAQ5x10tx7Jh9bkco0XDLq8YQFMByo19UHr8VvDECUf1jEzpG
         Twopna0FwQURH0i/W8INKp50TGKN47yVFF0+C3F/4hktQKpGY+yjQrDTrkE009b58Byx
         8IloNv6ka2/vgPHgG+y3ptux1D7piQpbEkLwO9EWbmdQtAWZ4n01NaOk+qcL3qy04qPj
         zwcoAWvPYogo+vCfssLUIJA8H9AK66E1eTLzL6k+MwpJ8dpq8gQQw70rVCl6hMocAumi
         4g+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWlqLeTC6J39eMpX4yIPeWFywkyBDukMPO31Bg4kXVUgsQFUr5tP5hAzSdGNTYqeB7dkAMDw+ABGg==@kvack.org
X-Gm-Message-State: AOJu0Yx12Jyd9PdrgSutJoAEb3B/Y84u1WwpWB8ZUoLkkca/g9ReBY4r
	UBzQVgZjw0EmtdnWzYBKMzdAizgey0D18Snysel74HNk9/SYRivMHyPUywxdqm5SHg==
X-Gm-Gg: AeBDietj9Qv60TjM2FpI/08WiwAuDYhpBo3LIUwpafx80MCYZnEWHl4jJ/ISOMS3Jz+
	DjNP1zWNG9pVQJtMro3T4AWsuzFpmFd7ICdKMJNM64flbB6pI9m7X2Y3m06zADyJMfTlIQCl91Y
	kVnKv9Mgbg7XCYxq9E82263pZhuNnye5O9c+xLHiftpi1CqT32qNfrm4cyQrGB10jK75mptPa+a
	RltGHQWEyWnEyGrEVUeG8QA2uomxAaNoWicOoyZ9BMV31809noQS+KEsrmJHjQ4yspd3v25LR+9
	NOpREFz+Fj/gDmFOSBTUC53Z8KdGVG72KvEXHci1GYE4Q7cCYC9TWYmYr8PTVmyvAAHDGvmoxt7
	oMcN6+PECR3AATbjOZfeZ/YOCZlaiCizbgf6iwdHgEOvJfS1Ng/y6M2GJ9bnQcSOo/J3H+MoxKQ
	3FISKEuNaWiXisyMVNeSHjmukTeSU7PALu69bhIrs8Zj3DWg57gNv3yOcSEKAuHmr4udWQEPbdi
	mZk5fr83w==
X-Received: by 2002:a05:693c:2c93:b0:2ca:9b08:e7d2 with SMTP id 5a478bee46e88-2cbfb4a8218mr6499235eec.22.1775517933588;
        Mon, 06 Apr 2026 16:25:33 -0700 (PDT)
Received: from dianders.sjc.corp.google.com ([2a00:79e0:2e7c:8:c071:3b78:5a5:824a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca760b0518sm14730975eec.0.2026.04.06.16.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 16:25:32 -0700 (PDT)
From: Douglas Anderson <dianders@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
	Johan Hovold <johan@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	maz@kernel.org,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	driver-core@lists.linux.dev,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	m.szyprowski@samsung.com
Subject: [PATCH v5 4/9] driver core: Replace dev->dma_skip_sync with dev_dma_skip_sync()
Date: Mon,  6 Apr 2026 16:22:57 -0700
Message-ID: <20260406162231.v5.4.Icf072aa4184dd86a88fa8ca195b09d1651984000@changeid>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260406232444.3117516-1-dianders@chromium.org>
References: <20260406232444.3117516-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CB31F12000B
X-Stat-Signature: u6bt7mmfgmpir4irjukks17pazy8yd1g
X-Rspam-User: 
X-HE-Tag: 1775517934-622260
X-HE-Meta: U2FsdGVkX1/FhpGxStkfIRY2Dg5Pkn6saLYmc2r6b/lQl8k7jTUA8hJE4/qwlWPvxD31ywpPeFNwjTmBQSdRcSjbt8DFU6a9jcQfSjGnZ6gzT8K9MKj5hrSsL9dUHTVA+BFYu0Gj5EDgRbyKNMm2lZ5aXG4vbXyyDtgAq3qxfJrrqBZLYusewqujDU9mcym+VSXJikIP6a8PgR1a189YZ2NYkc+l3Li8iEkYzAfsbrjNER6JWqtX7D96d1disIyKSbH3MIzIzDfkY2zWM2W5YuknHBJe7B0SXMVD6vAFHQQl5D4NVBw4AQ1mk3TK1CxLaUvdWNXtDJv81Y3QoSr4xlPTX8yKAM8kj503UE62ZsbayXYg8OvHo0/SWGlnhoYQj+LIsV5GOd8PdP77C+pKViIRLESINmVkuf221xiHXCkbgFEZ7Db8gu64fiCmapHCnYSzqdYNN89T20o7px/6Bgv98mexHHbf+w8lL9Na7B7fKjx+oaWXlAqIZ6xDKkKZPVuBr9fP0XsXXLCBlqO4lwXwW6jzqFrt7ee/wUHEo+VP5ay0G0bwZ0XxWyGnRfGO9GJGsVDBaPGIsaNlEPjUFaeGiJjlUFYCjmttLkUun+UU/bAyZtVgMb2Gj43ZYbhD6g7odWLU1uk0tP6AuwijgI0OoKo71a0qnwKHQPx3m9RctMckDGa3dv7VY7JW9fs9vR04iaVg0le7X9VGmEvERORU2tToEEWUONr8IzSBcrsKThYBWqK37fctRyYh2G7QR9//rhMRNLvtDJG99ghTTR/9aUZKqy12t0ozhh7bRpLuwKRqIv4jvwBjAV9WQvHq07j4/sNfphof5NHiK9m9nqnhfnCMuTFkORwGvzzYbR4wxTEBA3y/t8FmlNNiD6wQcE51HRNJqmAdvSFM3rRaDli1omzC0IWccDvFeaApnOyv+/gudxHZvlVw4xEBRPiSmUzefCrgyOwg7kn1znq
 49vDmf1w
 iWDm4MEuOrk1Eaq/16cUzhIEaiejDeyHXTRiSxDwCtZwATnh7SGzS3kjRiAAvCn/y6s69mM50uBIpJfiPQpJBCihlzQKxX0MfscJidR1qArLhvk/13KT1ZQrPXb2mruVwnvtJ4YSFBB7mHXgVlZi6WJiEB+URwIWvCE0NFwQd5pq4hoog7Li6J4XDHeJ5WrZpBnxsksREiH9bIGVT8UZ6+gYDcsKIV1RZfp7LwJ4QicYkDjhoqzUs5q5WLia6X2xHmtTha95hm1ry9DdoMHyVLfWg48+svh1S5urfIfBY6r6uvvM8xbZVCVcVRG3H4HImtOw8iONMFRtkHnVG+Uneqahs5+dhUr/DmTEqbMQUgiQSFd3S8TCipxWNSgD5rmSlSGnnA/gTucTxJuj/yZ9jSfefU9IfHEgNHtuJMXg8vT9RwawTTEhQRh/Ra6tGigoiB/DHN9Xt14DT1nrrY1IBY/qviA==
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
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
Not fixing any known bugs; problem is theoretical and found by code
inspection. Change is done somewhat manually and only lightly tested
(mostly compile-time tested).

NOTE: even though previously we only took up a bit if
CONFIG_DMA_NEED_SYNC, in this change I reserve the bit
unconditionally. While we could get the "dynamic" behavior by changing
the flags definition to be an unnumbered "enum", Greg has requested
that the numbers be stable.

(no changes since v4)

Changes in v4:
- Use accessor functions for flags

Changes in v3:
- New

 include/linux/device.h      | 8 ++++----
 include/linux/dma-map-ops.h | 4 ++--
 include/linux/dma-mapping.h | 2 +-
 kernel/dma/mapping.c        | 8 ++++----
 mm/hmm.c                    | 2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 620306e8380a..c38593cf2583 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -471,11 +471,14 @@ struct device_physical_location {
  *		until other devices probe successfully.
  * @DEV_FLAG_DMA_IOMMU: Device is using default IOMMU implementation for DMA and
  *		doesn't rely on dma_ops structure.
+ * @DEV_FLAG_DMA_SKIP_SYNC: DMA sync operations can be skipped for coherent
+ *		buffers.
  */
 enum struct_device_flags {
 	DEV_FLAG_READY_TO_PROBE = 0,
 	DEV_FLAG_CAN_MATCH = 1,
 	DEV_FLAG_DMA_IOMMU = 2,
+	DEV_FLAG_DMA_SKIP_SYNC = 3,
 
 	DEV_FLAG_COUNT
 };
@@ -569,7 +572,6 @@ enum struct_device_flags {
  *		and optionall (if the coherent mask is large enough) also
  *		for dma allocations.  This flag is managed by the dma ops
  *		instance from ->dma_supported.
- * @dma_skip_sync: DMA sync operations can be skipped for coherent buffers.
  * @flags:	DEV_FLAG_XXX flags. Use atomic bitfield operations to modify.
  *
  * At the lowest level, every device in a Linux system is represented by an
@@ -686,9 +688,6 @@ struct device {
 #ifdef CONFIG_DMA_OPS_BYPASS
 	bool			dma_ops_bypass : 1;
 #endif
-#ifdef CONFIG_DMA_NEED_SYNC
-	bool			dma_skip_sync:1;
-#endif
 
 	DECLARE_BITMAP(flags, DEV_FLAG_COUNT);
 };
@@ -718,6 +717,7 @@ static inline bool dev_test_and_set_##accessor_name(struct device *dev) \
 __create_dev_flag_accessors(ready_to_probe, DEV_FLAG_READY_TO_PROBE);
 __create_dev_flag_accessors(can_match, DEV_FLAG_CAN_MATCH);
 __create_dev_flag_accessors(dma_iommu, DEV_FLAG_DMA_IOMMU);
+__create_dev_flag_accessors(dma_skip_sync, DEV_FLAG_DMA_SKIP_SYNC);
 
 #undef __create_dev_flag_accessors
 
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 60b63756df82..edd7de60a957 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -245,8 +245,8 @@ static inline void dma_reset_need_sync(struct device *dev)
 {
 #ifdef CONFIG_DMA_NEED_SYNC
 	/* Reset it only once so that the function can be called on hotpath */
-	if (unlikely(dev->dma_skip_sync))
-		dev->dma_skip_sync = false;
+	if (unlikely(dev_dma_skip_sync(dev)))
+		dev_clear_dma_skip_sync(dev);
 #endif
 }
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 99ef042ecdb4..ef4feb2b37d8 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -419,7 +419,7 @@ bool __dma_need_sync(struct device *dev, dma_addr_t dma_addr);
 static inline bool dma_dev_need_sync(const struct device *dev)
 {
 	/* Always call DMA sync operations when debugging is enabled */
-	return !dev->dma_skip_sync || IS_ENABLED(CONFIG_DMA_API_DEBUG);
+	return !dev_dma_skip_sync(dev) || IS_ENABLED(CONFIG_DMA_API_DEBUG);
 }
 
 static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 6d3dd0bd3a88..76fc65d1a8a4 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -467,7 +467,7 @@ bool dma_need_unmap(struct device *dev)
 {
 	if (!dma_map_direct(dev, get_dma_ops(dev)))
 		return true;
-	if (!dev->dma_skip_sync)
+	if (!dev_dma_skip_sync(dev))
 		return true;
 	return IS_ENABLED(CONFIG_DMA_API_DEBUG);
 }
@@ -483,16 +483,16 @@ static void dma_setup_need_sync(struct device *dev)
 		 * mapping, if any. During the device initialization, it's
 		 * enough to check only for the DMA coherence.
 		 */
-		dev->dma_skip_sync = dev_is_dma_coherent(dev);
+		dev_assign_dma_skip_sync(dev, dev_is_dma_coherent(dev));
 	else if (!ops->sync_single_for_device && !ops->sync_single_for_cpu &&
 		 !ops->sync_sg_for_device && !ops->sync_sg_for_cpu)
 		/*
 		 * Synchronization is not possible when none of DMA sync ops
 		 * is set.
 		 */
-		dev->dma_skip_sync = true;
+		dev_set_dma_skip_sync(dev);
 	else
-		dev->dma_skip_sync = false;
+		dev_clear_dma_skip_sync(dev);
 }
 #else /* !CONFIG_DMA_NEED_SYNC */
 static inline void dma_setup_need_sync(struct device *dev) { }
diff --git a/mm/hmm.c b/mm/hmm.c
index 5955f2f0c83d..c72c9ddfdb2f 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -709,7 +709,7 @@ int hmm_dma_map_alloc(struct device *dev, struct hmm_dma_map *map,
 	 * best approximation to ensure no swiotlb buffering happens.
 	 */
 #ifdef CONFIG_DMA_NEED_SYNC
-	dma_need_sync = !dev->dma_skip_sync;
+	dma_need_sync = !dev_dma_skip_sync(dev);
 #endif /* CONFIG_DMA_NEED_SYNC */
 	if (dma_need_sync || dma_addressing_limited(dev))
 		return -EOPNOTSUPP;
-- 
2.53.0.1213.gd9a14994de-goog


