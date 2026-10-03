Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E3BCA5FE6
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60FC6B009F; Sat,  3 Oct 2026 17:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39716B00A0; Sat,  3 Oct 2026 17:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75586B00A1; Sat,  3 Oct 2026 17:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 985A26B009F
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:23:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 229DD1A0A14
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:03 +0000 (UTC)
X-FDA: 85282590246.13.AA7D9CE
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6DF9E180002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oXrpMWll;
	spf=pass (imf24.hostedemail.com: domain of 3M3LBagYKCHojpgxxmemmejc.amkjglsv-kkitYai.mpe@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3M3LBagYKCHojpgxxmemmejc.amkjglsv-kkitYai.mpe@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GInLAF6QzIbkn/554tL70qj8kbEMjqAAjjITOwkojYs=;
	b=Xct5xEW0AlBuQQhedrFBZPnq38hwKhkj5xRd21+RDFYEr1a+hVuDXHxHLzZ5fv9Y1zwtz/
	JIs8axGd/Deirtpr9RNEkZ46kbPjcuyrKbOFvROESsK+kkyeoFf0koHYaix8DiumcGtTtK
	ecocfFYVD78Gy2vRasyVim8tVSnPBQI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oXrpMWll;
	spf=pass (imf24.hostedemail.com: domain of 3M3LBagYKCHojpgxxmemmejc.amkjglsv-kkitYai.mpe@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3M3LBagYKCHojpgxxmemmejc.amkjglsv-kkitYai.mpe@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062581;
	b=8eaLRk3NafS30usmpr9XLv6XZoshmP/97pDov8+gEx1QZuGjVfcaqsPfDOIbmS4CraQecz
	JgCLcgveQG4ydu1UozYi+tdKHffkwmSzmI8mJXiW12jffK4u1NqNUdD5SpZW64dBqbSGAg
	iybCoM16uaSjp3MEUO2VPtoV6QcpYYw=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c2e47a584edso110017066b.3
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062580; x=1791667380; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GInLAF6QzIbkn/554tL70qj8kbEMjqAAjjITOwkojYs=;
        b=oXrpMWll3BDPPyMikdz+vtbvBNk5mCX0JZOhDerqw+O1HZaeRNJ7N7/rTaHek636+J
         Kd1pSbqVMfRg3ddP16x0PW7ZQfvNk7yN5vGGltKp3GxLnmIixuBfMPWEnV1AdecEx8pH
         4fvkFT9PmIb42PdWc5KreJO0LUvBMbNy7gmVUrh9t3WIb9sszy+iVPDHw0vd8ZwbUTJY
         kO/qmz+/G+z031zGGCZX/Ba0K78xSAQclIqNFIB3g1IUlEJ5mR+Q1CIUTH4S8MbLtfMf
         A6Id45oCdeslkhrqoV6FwDz4hWMAGeOv9M81/pC39GAgDhJBtR2orKy9BtCPLPaWnQRk
         r0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062580; x=1791667380;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GInLAF6QzIbkn/554tL70qj8kbEMjqAAjjITOwkojYs=;
        b=ov1xy3vnvIv8QmEvK7Dk2av5LdT0V8wqi9ZPs5HlGP6GlwCaBFy/6YPXr1HuGjYJ7i
         zOpR41XMI2nn0iJStcCH7OKNIhkwZUAFGZquDBFQ/vUjN+aJDhIc60Z26uZKV4Ke47yL
         /dPiHusKauY/YT+fOWlbqTXZi8A1Pohs9uvCzs+5md6QdoUhV8ZY9auDLNzsLW4rqHMp
         0BfTTo6WxmjqUV0Nk8b6rFZcNYYlfC1aDQbMMVPy+OEfCFUMdLV+q0NzIf8fqqY4H6Rd
         HJ8sICi+dDujl2gyKOZIc1HAZc9pbAb36FyGVJyEx1tUgJ5DUBW/OT9MQYxNvpqQ1Q2m
         J2RA==
X-Forwarded-Encrypted: i=1; AKwUvBxvEqaRUTFPJeU0c8Xsm5+S7T5H3k6ce3qcxteF6BwRdncwlQGZAxK41fUpsELcCWrRhzVY4uZslw==@kvack.org
X-Gm-Message-State: AFuF++mnXp/+j3x4OZhb3FN/tz9MSP0k7GYsGQ2GHeWY6XhJ6YfldApX
	7lDoo/WUSqOhUCognVCz+Z1Ton2HM1LVMlBBm+Ga7bIAasPBfr9vl2BAPmUD/Yv0/RGhQWquCys
	K7e7DtA==
X-Received: from ejyb21.prod.google.com ([2002:a17:906:8355:b0:c2e:2022:87e8])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:c011:b0:c2e:4e08:19b4
 with SMTP id a640c23a62f3a-c2e6e9c9fd6mr253423166b.3.1791062579466; Sat, 03
 Oct 2026 14:22:59 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:29 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-11-lrizzo@google.com>
Subject: [RFC: DMA_PMD 10/22] driver core: Add per-device dma_pmd_* sysfs attributes
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6DF9E180002
X-Stat-Signature: s874upttguwmpjy1mk5hmd6cs96y6wqq
X-Rspam-User: 
X-HE-Tag: 1791062581-216356
X-HE-Meta: U2FsdGVkX1/FreqzYlSjJ1HcwWFA0UlUxrg2eSpSJJ9P1eQkqyWivrRHP5NscjV1I39FsMrE01LPRNlv0vq0yKR+vjhlM2n9Y9vpWHDx8XBprJ0wcaBI3iCo09iJCESWua5KTbhp4yKNyz4T1rmzk5OZg38tKB/oH75ougXNBUHfXH1lwJHPqyn98reBqAEcFR/HQi3NHOoxN60Br5qrbgx2wdcjSs89BNqz5m1p1F9ZHHC6/otvkM5RzGa23Ddc1hgSYr9qGcYWCPggsqaAKnvaeZq2SBL8QA/OJFwe0gWxXx8dwiFSiz126VPt6NGrhsAVY1BH8cshlXJQO83pAdfSGIwONkubn3hV4VTEBGBV+/Sj+FJsWsj+CHUhBPscjUx699hzhYTDkMxCailYuKNhbrClW8MMs+WBZaLMN3+7VHgEDfnssltVXQ7Voa7ZQ1HcJ+A9PP1xfDiQUXa/YuBwhDuOXxOHFm2Hn8viRUUgSqy8zfilIHxLUpC1iLNw83Vwlh3PrAZ4OI7o+7rT12PdSuSTsCgiqFYWr401N/n/YIg8LyKz1woKrupWtUeQMt70yNJ8qWvEFDQf6c/psEhBo9wy2AE5aoZMRHsKNc3yjl4fzVrXwq2N55mJN2Dqlh4cFBP81M+5EVnbSyKQtXg3tfEPT7nGMkUorb7RWl1rkCNuuH5PFx/EppTWxFzUs3HHk8G5LH+uKr5Orq4VvFYssgDx+mJZpsaxFb4as6wVyfaygPbFQGA78IUMpayA7/4TzltUiEk5pGUJ2rAmMM2Y1LGHWYKgqOWA52akAEisp73EsygDwDk5U6VIu4nWBmFOHVn4k0hRzJXoRbdCDTb6S8cRVcyijfdNbtoobdKTfermizC1jeyhABW+YCo35DeZZgKqqfoU2PT4WnW74Djmvr44674AgJAob3JALAcwFcX3RkwpoWHm2DdwD9kXw/ZbeLk4LKGJk+D5rgQ
 nrbQH9cJ
 A+I/aRiojvHgZcIYnblqv7adMYOgg4Y5LYwkPeV8UT8O71S+Y3NEUGxvcvVXniBpmVpHnCzJOYLurPNuA8ueLO/q1tpIj6uCzJ7y7qF9ooezn7ljFtgCeKNGJEPUOr+oNSEZiucnm4e2c3KNkNnrfRj2HKi4YulMUabPT7+f0BifOVgpe9qODOoATeJklF1TrvAO3KSo/xnGTFYWyp0NzDuXBTTOmsJpErpGkyHTcCh5DdOxj+fc5x76n77bCfLSKT10ReCho7gGELzZYTiVdwNkv9rHhCm6HuhwtlAtn1wI0mAnodgJY5vEX37NcVtYjyVQ1QvkpX9w8jOOWnLCLk1mvGdaORDh2modeD2ZLEfsTAkCXtUGtEZ7g5L+VpTGeFoJH77hC5/OXfISALwsIQ0Qh6aPZJE5UVpRad5hCHViQIryzSAK4T1FPp0qvSr60gHW9bFmmeoJbuqtlCxU1pI2fFDCkGaev2GjHjoNp5l+sq0M63z8mKWE2frXZBxRcForcKbC0NTs0ktIrnhlc+SUW1ACcWUr/XDJ7J+/u47ZewqJ3tAHGZ/RPVfyaLLQkbGunf/vE8IBxRiVNdqX4kwI1DU4PKMo0Of0bfE3BJqOnpVUgjC4JQtA1XQeUV3a+OF6U3mhka537sgzUGL5DI9h2Azh4e/UeLJ6r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add four boolean attributes to struct device exposed under
/sys/devices/*/*/dma_pmd_*:
  - dma_pmd_rxbuf:   enable DMA_PMD pools for RX buffers / page_pool
  - dma_pmd_tx_hdrs: enable DMA_PMD pools for TX header bounce buffers
  - dma_pmd_rings:   enable DMA_PMD arena for coherent rings
  - dma_pmd_debug:   log coherent DMA alloc timing and arena usage

These can be used by device drivers to selectively enable DMA_PMD for
their allocations.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/base/core.c    | 51 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |  5 +++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4c0c373998a19..f8c3c42d84b8d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2905,6 +2905,43 @@ static ssize_t removable_show(struct device *dev, const struct device_attribute
 }
 static const DEVICE_ATTR_RO(removable);
 
+/* Per-device configuration to selectively enable DMA_PMD */
+#define DMA_PMD_BOOL_ATTR(name)						\
+static ssize_t name##_show(struct device *dev,				\
+			   struct device_attribute *attr, char *buf)	\
+{									\
+	return sysfs_emit(buf, "%u\n", READ_ONCE(dev->name));		\
+}									\
+static ssize_t name##_store(struct device *dev,				\
+			    struct device_attribute *attr,		\
+			    const char *buf, size_t count)		\
+{									\
+	bool val;							\
+	int ret = kstrtobool(buf, &val);				\
+	if (ret < 0)							\
+		return ret;						\
+	WRITE_ONCE(dev->name, val);					\
+	return count;							\
+}									\
+static DEVICE_ATTR_RW(name)
+
+DMA_PMD_BOOL_ATTR(dma_pmd_rxbuf);
+DMA_PMD_BOOL_ATTR(dma_pmd_tx_hdrs);
+DMA_PMD_BOOL_ATTR(dma_pmd_rings);
+DMA_PMD_BOOL_ATTR(dma_pmd_debug);
+
+static struct attribute *dev_attr_dma_pmd[] = {
+	&dev_attr_dma_pmd_rxbuf.attr,
+	&dev_attr_dma_pmd_tx_hdrs.attr,
+	&dev_attr_dma_pmd_rings.attr,
+	&dev_attr_dma_pmd_debug.attr,
+	NULL,
+};
+
+static const struct attribute_group dev_attr_dma_pmd_group = {
+	.attrs = dev_attr_dma_pmd,
+};
+
 int device_add_groups(struct device *dev,
 		      const struct attribute_group *const *groups)
 {
@@ -3012,8 +3049,20 @@ static int device_add_attrs(struct device *dev)
 			goto err_remove_dev_removable;
 	}
 
+	if (dev->dma_mask) {
+		error = device_add_group(dev, &dev_attr_dma_pmd_group);
+		if (error)
+			goto err_remove_dev_physical_location;
+	}
+
 	return 0;
 
+ err_remove_dev_physical_location:
+	if (dev->physical_location) {
+		device_remove_group(dev, &dev_attr_physical_location_group);
+		kfree(dev->physical_location);
+		dev->physical_location = NULL;
+	}
  err_remove_dev_removable:
 	device_remove_file(dev, &dev_attr_removable);
  err_remove_dev_waiting_for_supplier:
@@ -3037,6 +3086,8 @@ static void device_remove_attrs(struct device *dev)
 	const struct class *class = dev->class;
 	const struct device_type *type = dev->type;
 
+	device_remove_group(dev, &dev_attr_dma_pmd_group);
+
 	if (dev->physical_location) {
 		device_remove_group(dev, &dev_attr_physical_location_group);
 		kfree(dev->physical_location);
diff --git a/include/linux/device.h b/include/linux/device.h
index aee79fd6b32b4..52aa4a7e1cc45 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -794,6 +794,11 @@ struct device {
 
 	enum device_removable	removable;
 
+	bool			dma_pmd_rxbuf;
+	bool			dma_pmd_tx_hdrs;
+	bool			dma_pmd_rings;
+	bool			dma_pmd_debug;
+
 	DECLARE_BITMAP(flags, DEV_FLAG_COUNT);
 };
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


