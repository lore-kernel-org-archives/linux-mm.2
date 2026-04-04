Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB4EDE88D72
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 00:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F45A6B0089; Fri,  3 Apr 2026 20:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CCEC6B008A; Fri,  3 Apr 2026 20:07:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20A626B008C; Fri,  3 Apr 2026 20:07:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1320C6B0089
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 20:07:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94C148C119
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 00:07:33 +0000 (UTC)
X-FDA: 84618934386.28.A3941AC
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id A8C3F140008
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 00:07:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NzYZRrBc;
	spf=pass (imf09.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.46 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NzYZRrBc;
	spf=pass (imf09.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.46 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775261251; a=rsa-sha256;
	cv=none;
	b=qYKBiCD8cuXhFPOUnwz+Dkh/8JTTvta30mqiQ11/uirYqv91Z23pghmpfXeLLA1o6M4InX
	28JS7/m1dVNDrrw41LN8KCXzwdvdTSp6JboIi5ad+gchE7wTZPtMYQLFc2k3GTiHLS/FUh
	cA7M8o8EXgpv6H+fkJ/E+Y17PmhHHlo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775261251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iaEmExAw4Fi7AHFQ4lJ7E/IDLxtvfEnb2vcxgfiheP4=;
	b=vjZKHiKHyyle9+eKxDBO/yqfknnHrpRyLvw6K/y03EvoQ8cCyK4MtTr4voDdbwiCSGcIox
	P5CIYUY3T7IbcJ0ws5yL1Uz8sVLwBOCgS52YGKk4aCEWjfieT3+1+N6r3q/28INJKeyyN/
	PBXcHh3wO91FhT95pbTmjVJWltyAYyo=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1279eced0b9so2748107c88.0
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 17:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1775261250; x=1775866050; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iaEmExAw4Fi7AHFQ4lJ7E/IDLxtvfEnb2vcxgfiheP4=;
        b=NzYZRrBcBsfzCcCf2+SPdQdBf2ygiSaWOojNn2Kel4ymurC5Ju8DsxyOMpKDWV6GWf
         4lhqozb4IQqeMQBEcwiKGiJDp3XMNmVUZMFVfwMA9nYgI4O51XZz0NBcs5DmlsJ89T38
         /KjMjo/LO9KRKGekr+2q5LGhcA4pb9Za4pjrw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775261250; x=1775866050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iaEmExAw4Fi7AHFQ4lJ7E/IDLxtvfEnb2vcxgfiheP4=;
        b=G7yhoPEXLu3f+bIqzuC+GT55OaVLYS/HtAZMeoZMr/j7Rcexan3A9KriqkzKaIedi9
         szZbtoVguAz7aVvwBLcpTCHr+ns9DHh58icYAVtoodC6kQlmMsvGe1xY4pyMI8B+FYnY
         b6vRnkLWxmY4N4qE+2xSnUA1NoMW5YToLN6mblOdk2bF0Is6eeqDnrQOjKck0bv3Ns9H
         v2JaARIVBGDjTWpMqwp7oAN4FTWKfe5RvKIf/ZUllRGdNzksSR6sLJ0E/U/pxWa80Iyr
         10RPXsUT5f4ZgP6nRKEnb/AJ73PTlR6HvxqEUFvxrK5zc4XZOMWDYtlcYtQ2NJouvgM0
         s29Q==
X-Forwarded-Encrypted: i=1; AJvYcCV4DxkvWHWtmmyE6I+preH+PhBOwJinu6vLyktjZds5mt7rTfpzbNqTv3LXFpNUXqwvXvz6UE3C5w==@kvack.org
X-Gm-Message-State: AOJu0YxbdxqoM/StpJL0pNubo7l6Bmi4Y51EMYWYecu+Gg+za3+DPDlI
	98WCb0zdF3csOKc5ZqX89MrxbQL+YTJb5rksL9EjWZNxG8fLF/hhjJQAbS9pgtprrA==
X-Gm-Gg: AeBDieunacTKxhuQd6R/2gJhpLXJ0UI2jOHTmmcEttp9sQRshPNaIovml11xqCrmNB7
	DOXgKOP3rTrKEVPunVnoRYTM7wfGl7m8u+J9HLVkoMt3u18bAEdniy2foruRkZN59Ou/yW2zIu3
	FJlvxWMtHvd0yHLs/xvUF0OY1U3UWRy5U/HgpagbYtSCgpx/+QFvtDjZsjYQfHhJWANNfxy9c9u
	H4LHB2x2adIK2j4wo4L+NHOgCppEgRkbch+BVYv0qYgososSDcW4OwruJSsiGXbAsAevZZ/mZdD
	iCVr3DG7toPI4SWryphqp6+YJcfF9ZzXlYRfZyOWv8pXAIODI3e6LlpFuvRQMELGXaUpSBDAmn9
	jfM2Z85kBjbXSxGaAJ0zRFelyqRn23gGDfJ4zlZvxvS3N4QUpB2tsYQkKClMJciEIGzQ2Ou6EjY
	FjC5lzCBtfuV0pkfAluCNiDsienKG8buzR+903VQ1HgYMOnCeHEf/cKSzNN9074lX9hG0AA2AeD
	Lmlp4dLIss=
X-Received: by 2002:a05:7022:4a4:b0:128:d5bd:3572 with SMTP id a92af1059eb24-12bfb765439mr2140467c88.31.1775261250429;
        Fri, 03 Apr 2026 17:07:30 -0700 (PDT)
Received: from dianders.sjc.corp.google.com ([2a00:79e0:2e7c:8:a8b6:55b2:3eb6:2c0e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca79e1d93bsm6520716eec.12.2026.04.03.17.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 17:07:28 -0700 (PDT)
From: Douglas Anderson <dianders@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Cc: Saravana Kannan <saravanak@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Eric Dumazet <edumazet@google.com>,
	Johan Hovold <johan@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Robin Murphy <robin.murphy@arm.com>,
	Douglas Anderson <dianders@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	driver-core@lists.linux.dev,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	m.szyprowski@samsung.com
Subject: [PATCH v4 4/9] driver core: Replace dev->dma_skip_sync with dev_dma_skip_sync()
Date: Fri,  3 Apr 2026 17:04:58 -0700
Message-ID: <20260403170432.v4.4.Icf072aa4184dd86a88fa8ca195b09d1651984000@changeid>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260404000644.522677-1-dianders@chromium.org>
References: <20260404000644.522677-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A8C3F140008
X-Stat-Signature: d8sziashc34qzh17or77kh37hie565es
X-Rspam-User: 
X-HE-Tag: 1775261251-467077
X-HE-Meta: U2FsdGVkX190EmdsSfZVWrdGeeDdW575SQIxLmcM4DtIJrwkoDlieceJxdnWrxsj0rWwZN8zoOpV/80WvTnnBHxSK8EihSU/OIC+tjsXQOaODa4RfchA+D9exR85ZztbMBZgA0fmrkKQior7mqg/M95zetBZ2gI/r4L4gzSpgNHN1e3SdK3pBHjUUMYY2lTlsDNCFaxx6qRWkMUcFe+GYvjnTbF7JYqR2KuRjKUlkPqANho/Se0UvN3PtqWgk8D3mey6NyaUKHsFEZ+fyAswrX5kUpuoFbimcvsrBt2oI7IlNQdYVslosfIi7v3PsR+54jalPbyzA0uaoBCDqRRyt6bqhJznK/5gxvXG7DVzou1XbsfmIBTAwSJPN2ylQgZmhdSmL/Rqo3cUgV869kTM6ibCCDtH/M76r1ITTeR5S3G/D/tyZsiayM3m6dX9gfluwrjvw3mWsrkVDUvGNTgh6p48y02+K8wpO66LZuS4tE78QVgtWinT5y3uQrJWcdjtzO67PsS9ma2enWO9eEdy5+5QH2sr1jHMqLUH+ED5wVx8khnnHjKUzMsbUR6Uhhjlf508hRCHA2W4hRUpoySt4H8753jI3zLv7ipSVxi7AFRsG9v/RcIGtVZzgA6WDwMT/EYDCWvKQeSlvaGbIZ5xx7gXzuGF/pFaXwnGUwpKvENDGoGwkKfRODoHbjthm4xkiIets/WHg63ibjc4A6JsVKhyqHZtO676sof9n8jIDCbv/vD4pt9xf/D+8POMZefN0Jrq6Ib2JTjjMkaAkzHBpJ3nvMnkvYVnUv2VqQJYbRawMJe9vGPwF2TTw5Ywvx+oi8E3qwzrDNpifI8eq0NxGgtdkb4q2xrM6gO7YIe7XH6aXW7araaB7H/EwOZe6z6OdFdMHdG4CDXz3SbsgEgiUCb1GZSozEfVdOeVg3AbeWXOQTIxhMncjTulsKn1v+OT8Z+o8jZYhCh92jqxOH+
 wuKrIAwK
 gkTVfN1q5N271P25Xxk0FFRXOe5N/Jjhc7gdS/R6GACu9ElyTCY68Xlklo2h1m+dNWlxbn17RE+0i01wSuEKRu925LZ2yojyJ+KieZ/ray0tm3e3ILZDTDeQxllIsTzwiIaT9B28d2SFt7IoVKU1GrQhxKkpTous251E/qYjgvmcl0YJGPEF5iX+QDHDbz9NxXox6Bm0DjbSWyUQFI800c8/byQ3iMfwnF6kJbhEZ1dfxNRcq40LZqCvJCWKrFHg9Vfg0kyOVx1r0b4AdOWsnzb8cpU0AhNh4Wrz2D8CEMdJEu8iIFW+wQugZQmxTVmPGyu8zUuS/DvfIFvNysTuyfZ6glZ4GckF42vHSSIaAsLcMZIk=
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
index feb11ba1ba71..fde0c72c3159 100644
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
 
 /**
  * struct device_link - Device link representation.
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


