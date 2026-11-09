Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45FC606B583
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=R9oZhfmS
Received: by kanga.kvack.org (Postfix)
	id 8FF186B05BA; Mon,  9 Nov 2026 13:25:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AF3D6B05BB; Mon,  9 Nov 2026 13:25:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777436B05BC; Mon,  9 Nov 2026 13:25:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C88B6B05BA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:25:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CAFED807B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:49 +0000 (UTC)
X-FDA: 85416409218.24.2A2E1A5
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0DAC1120004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=R9oZhfmS;
	spf=pass (imf29.hostedemail.com: domain of 3KhDyagYKCHEagXoodVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--lrizzo.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3KhDyagYKCHEagXoodVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248748;
	b=e4B3CuGZPaVS0W53MB0N2+Vb2+6+eppoJKNta1wxvxtfK2XASr/cumvT0ZYd9Z5YMt/FVd
	sz2gewJF3EJ3vn+SFjUfBLXVUhQcO+yHy3rFPQ0zv7zvjmuLEsWJAUqPuyXadWZ8upbpNs
	NAlTUPElI+7X7fJejTeFg9Vk6Ajgx6w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=R9oZhfmS;
	spf=pass (imf29.hostedemail.com: domain of 3KhDyagYKCHEagXoodVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--lrizzo.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3KhDyagYKCHEagXoodVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KIwBzE5/gTDRHFi1rb7GevJXqS3ssTxf1jc5qeulzMc=;
	b=4oaOO3wLgxeMTODafGYyrJpGG76mlT3s1GOraIZWCNzOu2J5bslLozjvGQdH3NoyveZ4td
	vDvPA8dyYRaY6ugWUJVIfXxhG4tVbXtPo2r3rPTrnhiz6KCkeqNbGV586CdURUxnU0cqtD
	SLGdFkITZFwtgAQgahiTxtkNBn45GNo=
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b597374a17so1195891a12.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248747; x=1794853547; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KIwBzE5/gTDRHFi1rb7GevJXqS3ssTxf1jc5qeulzMc=;
        b=R9oZhfmSFYj48QjCT3BGfUI1fyoWcxHtE86B0qNiPz0Ep9JoKZK7chGCVwSHF9tcXT
         ilBhCSMfz4WD1J8oznsXA+EkQ6H2Ep/GsU+3qpsvWVrnk1FTedo2MfwMxFGQbVAdUmwl
         xmfDPO1uWvspb8J+5xMCIP3nQa6cmPbmkm083y0SPQRwsQUf9Ux28uYklwv8zxs9OK/A
         d8r7O4xvHUHJWCoAdoLu8qLW+Uu7W3RcF8/8tBN/UDxvdOSfAb8EMu5/a3DnOIO7/0yx
         ZnS3XSBzEUyCcsw0lfrK6MxTrzsdaLoL1V0e9BlX/wDRj4KSoyfDH7WvUuY2oqD0BgdF
         3H4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248747; x=1794853547;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KIwBzE5/gTDRHFi1rb7GevJXqS3ssTxf1jc5qeulzMc=;
        b=TLI2GzU1sSc21N5e9bkdB1stSBM2TRl42QpyEfXRhbzVT5pUF/SlEh6JMvzmMY48Te
         3GKiNjNJF2eMNBNPhauRP3hmaG+clhC0W22REWhsor4nVPkiqkiybUY5GNnZ2jWx2pvE
         sOwQgDjggmi6QeGgVvVBsWWPq5hh+7jzBaxB6tQb0Ct5uetR0pmdS9jz6UHr0JIqyO3a
         Sm94fdGkMs5x6buhO7lMakvEkbIZ7jSq1tJvtrSQkTgjv5wP8/K2/qARMWnVUiaEHEy3
         Rksa//Iio13GGSQgCFvBOEF1mgW7Gg+Tr/x5uJm0JC3dL1TZv73EEm5X8ebP78k53VqO
         dPOA==
X-Forwarded-Encrypted: i=1; AL+hErHg1443eNHCsOcaL2uDi40r1HgJEg8M8UGukD4l1k8969mjvGzfXs+szVIa37OGGob1BWDcVVjFmg==@kvack.org
X-Gm-Message-State: APuU4Z8IDOVuJ6SPnTYZxPEPk0+Ye0p53sG+Ms+66CAEx4ivQMg4x6O4
	U1JZkRqLP6Ppawt8GBx9+mM5yxn302lxvRZxyx5DuWv0gJFv1CwU1nCflSKZ27BcagfmaHaPi1N
	xKCE0tg==
X-Received: from edsl3.prod.google.com ([2002:aa7:d943:0:b0:6ac:afe8:e21a])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:a6c6:10b0:6b5:6a24:6cf9
 with SMTP id 4fb4d7f45d1cf-6b756ae3a73mr246715a12.45.1794248746339; Mon, 09
 Nov 2026 10:25:46 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:17 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-10-lrizzo@google.com>
Subject: [RFC PATCH v2 09/25] driver core: Add per-device pisa_* sysfs
 attributes for PISA optin
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ae7i5cxnzenq9uudd7fu5ygmboe1fa1b
X-Rspamd-Queue-Id: 0DAC1120004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794248747-425325
X-HE-Meta: U2FsdGVkX18DwTLde7uYAaykg1oomro5167YIkf1vq4SJpqCEq7QTeC5z8Dlhnf5e/FcUGhBwTOfeP7B0NGfF5Rt7RaaDswUTS+1dd7uhUabSndPl9NXKrGzymqzUYpIgJ4LZjeGZ4qfQR1HAIXg0tJDnwzx4z4UwjCwjOgbTzcvqiFcreil8HZzSmS6sGbmxHvrGHN2KWsZi+3QaH/fPRbYS8TPWBx4VSJVfk8PsY3PfBnV6C6GoH4FdbE7ZdFSvWbxB0dp+tOMu3ASvtek8ADBJIxK0ISuFP+F3oDi7LNYC1XoqBKUjZmdHfPlWBgJPQ7g7SBy1W8PWYWO6CgJ1aaEuJDfDL0T0lGQODFdIA6D3b7qzrDjS7BLQOvxdUp/lM1YTEQTBZo833AjlSAWZrCunSUAWXSwRqCUL749U/ziswiY+dMc1LW5bHCkERuJqR1OYQnbDd4YmyE8sNDtrqEgVO2RoCp7qC3bTdgykmS3jNEHf8LAyTN3Wk6RZ3X7p1d7i+XJIyFo1jEfVWPhDOw/E0uZALkEZXP3ETlKeHNBKFFmPmFKPjnwRaPJCJ2jMi8zK2MjM6uWRbp1C46de+rHzTwkQGYp/TLm7dySZaINJN1PnWPZdXU7f6GLIuYhyT8nM8Uxfz0b9YWnUDDLGDrUnQOt7RpK4oRU4lBZv70mEBbZg2kuZsSYk0OnBVHkyJ2pcBdut7JbcvZMLp9Le9qeCutNBUST7hy6DKYuglht+wo2MPgnETZp9ozMLYJA+Jel/iv4Ivp0xUNdsd0qt8X4m2uNb6Rd7A5CkgGcddJN5fKW+yAGHFhvJqANmosTfsiBf08L7mqGbfJoTiUbFxLP1OqH+MIu4hUqBQ/Geh0yn7NctAQMMbXjbNHJXqqbd6RgRqcbx6K7ZuSDj57eD3Yri0XTKmFb2Ye4wPVU9fsQFy03aZfSCjejuDVdRYiMimfzmkiFpbHdo/rFiFu
 6ZeV/SvO
 Ogssyo4CMqy4j2X5goep2hY2KQ6FtuVZ0AiSK1/ICIjKLMaZ0KoAJ9CHBLA0uUQs6JVnRKEzw+YpJ+bG04hcqfZU2v1nj9JgcRwrU981tJex+/jy5CtFCmKA1iTot7xIheb2bFYlRkVtQgHDr7bGJbu4SgrVN9cR8m/cLC3Kg5Kt1Vi/6LUKa7d5R9guQQPW6atknwsdSOFvL+R0YRs/Kg18XElm1ZiLKLvvNLmLEKIPRX6mEaHS/z6Af8E8A1vYUK/qZaRT6/TE72qxmzK0SUbQngMkmAs1uNBFoFnaoPlDXZl2k1vqevWrJyZr1xoHTsg30hzor+i6Y5lT8LPneKTngS4Esm2f4KiqIeamcEqULYUYHzJ8+YQFvtsolCX00ld368ntfT4MHRtVO+/t0yhYb5aqfTh91zrMPBQ835qq0828QwYb642ur1IS20giYmxTUEcxwiHvSiTzqe/q8AK+q2z4me9d+/NceBNnFZumdcgrgsCG2dZGHjuqbDvw6VF/zxho+XLZ6JV9TUbX6v/+u3BePwz6bWfGyCoTdYOnqKOJj/lpDAWuyfYikfzmxhWwiBNTGxtdEc9EL5HsLp9FlKOshuU0V1qd5UNNbWrcFxfl79UZT2H1dsg4aSuGE+hfxxpB+QAN5gx8IwoXOKqw/1l7fN1c1m0GE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Because of the performance and security implications, the use of PISA
features is opt-in and configurable per device with a fine granularity.

Add boolean attributes to struct device exposed under
/sys/devices/*/*/pisa_*:
  - pisa_coherent:     enable PISA for coherent allocations
  - pisa_rx_bufs:      enable PISA for RX buffers / page_pool
  - pisa_tx_bufs:      enable PISA for TX socket page frags
  - pisa_tx_skb_heads: enable PISA slab cache for small TX skb heads

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/base/core.c        | 64 ++++++++++++++++++++++++++++++++++++
 drivers/iommu/pisa-alloc.c | 24 ++++++++++++++
 drivers/iommu/pisa-kunit.c | 67 ++++++++++++++++++++++++++++++++++++++
 drivers/iommu/pisa-priv.h  |  1 -
 include/linux/device.h     | 12 +++++++
 include/linux/pisa.h       | 19 +++++++++++
 6 files changed, 186 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index cbe05197d4a0b..97cd2d03ff77c 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -25,6 +25,7 @@
 #include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/pisa.h>
 #include <linux/pm_runtime.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
@@ -2907,6 +2908,54 @@ static ssize_t removable_show(struct device *dev, const struct device_attribute
 }
 static const DEVICE_ATTR_RO(removable);
 
+/* Per-device configuration to selectively enable PISA */
+static ssize_t pisa_attr_store(const char *buf, size_t count, bool *field)
+{
+	bool val;
+	int ret = kstrtobool(buf, &val);
+
+	if (ret < 0)
+		return ret;
+	if (val) {
+		ret = pisa_meta_init();
+		if (ret < 0)
+			return ret;
+	}
+	WRITE_ONCE(*field, val);
+	return count;
+}
+
+#define PISA_BOOL_ATTR(name)						\
+static ssize_t name##_show(struct device *dev,				\
+			   struct device_attribute *attr, char *buf)	\
+{									\
+	return sysfs_emit(buf, "%u\n", READ_ONCE(dev->name));		\
+}									\
+static ssize_t name##_store(struct device *dev,				\
+			    struct device_attribute *attr,		\
+			    const char *buf, size_t count)		\
+{									\
+	return pisa_attr_store(buf, count, &dev->name);			\
+}									\
+static DEVICE_ATTR_RW(name)
+
+PISA_BOOL_ATTR(pisa_coherent);
+PISA_BOOL_ATTR(pisa_rx_bufs);
+PISA_BOOL_ATTR(pisa_tx_bufs);
+PISA_BOOL_ATTR(pisa_tx_skb_heads);
+
+static struct attribute *dev_attr_pisa[] = {
+	&dev_attr_pisa_coherent.attr,
+	&dev_attr_pisa_rx_bufs.attr,
+	&dev_attr_pisa_tx_bufs.attr,
+	&dev_attr_pisa_tx_skb_heads.attr,
+	NULL,
+};
+
+static const struct attribute_group dev_attr_pisa_group = {
+	.attrs = dev_attr_pisa,
+};
+
 int device_add_groups(struct device *dev,
 		      const struct attribute_group *const *groups)
 {
@@ -3014,8 +3063,20 @@ static int device_add_attrs(struct device *dev)
 			goto err_remove_dev_removable;
 	}
 
+	if (IS_ENABLED(CONFIG_PISA) && dev->dma_mask) {
+		error = device_add_group(dev, &dev_attr_pisa_group);
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
@@ -3039,6 +3100,9 @@ static void device_remove_attrs(struct device *dev)
 	const struct class *class = dev->class;
 	const struct device_type *type = dev->type;
 
+	if (IS_ENABLED(CONFIG_PISA) && dev->dma_mask)
+		device_remove_group(dev, &dev_attr_pisa_group);
+
 	if (dev->physical_location) {
 		device_remove_group(dev, &dev_attr_physical_location_group);
 		kfree(dev->physical_location);
diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
index f98142882519c..b0d968aa9181c 100644
--- a/drivers/iommu/pisa-alloc.c
+++ b/drivers/iommu/pisa-alloc.c
@@ -9,6 +9,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/cache.h>
+#include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/pisa.h>
 #include <linux/export.h>
@@ -392,6 +393,29 @@ unsigned long pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order, int preferred
 	return pisa_alloc_bulk(pa, gfp & ~__GFP_PISA_RW, nr_pages, page_array, frozen);
 }
 
+/**
+ * pisa_has_free_blocks_rx - Check if @dev has free PISA RX blocks of @order on @nid
+ * @dev: Device to check
+ * @order: Block order
+ * @nid: Target NUMA node (or NUMA_NO_NODE)
+ *
+ * Return: true if @dev->pisa_rx_bufs is enabled and the per-node allocator
+ * has a free block available.
+ */
+bool pisa_has_free_blocks_rx(const struct device *dev, unsigned int order, int nid)
+{
+	struct pisa_alloc *pa;
+
+	if (!dev || !READ_ONCE(dev->pisa_rx_bufs))
+		return false;
+	pa = pisa_node_pa(nid, order, false);
+	return pa &&
+	       (!list_empty_careful(&pa->partial) ||
+		!list_empty_careful(&pa->partial_dirty) ||
+		!list_empty_careful(&pa->idle));
+}
+EXPORT_SYMBOL(pisa_has_free_blocks_rx);
+
 /*
  * Split a non-compound page of @old_order into 1 << (@old_order - @new_order)
  * pages of @new_order (compound if @new_order > 0), all frozen at refcount 0.
diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
index e16268d55f3de..ab64657ad5c58 100644
--- a/drivers/iommu/pisa-kunit.c
+++ b/drivers/iommu/pisa-kunit.c
@@ -5,6 +5,8 @@
 #include <kunit/test.h>
 #include <linux/gfp.h>
 #include <linux/pisa.h>
+#include <linux/kernfs.h>
+#include <linux/sysfs.h>
 #include <linux/iommu.h>
 #include <linux/iova.h>
 #include <linux/mm.h>
@@ -350,6 +352,70 @@ static void test_map_and_domain_lifecycle(struct kunit *test)
 }
 #endif /* CONFIG_IOMMU_DMA */
 
+static void kunit_check_pisa_attr(struct kunit *test, struct device *dev,
+				  const char *name, bool *field)
+{
+	const struct sysfs_ops *ops = dev->kobj.ktype->sysfs_ops;
+	struct kernfs_node *kn;
+	char *buf;
+
+	buf = (char *)__get_free_page(GFP_KERNEL);
+	KUNIT_EXPECT_NOT_NULL(test, buf);
+	if (!buf)
+		return;
+	kn = kernfs_find_and_get(dev->kobj.sd, name);
+	KUNIT_EXPECT_NOT_NULL(test, kn);
+	if (!kn)
+		goto out_free;
+
+	KUNIT_EXPECT_EQ(test, ops->show(&dev->kobj, kn->priv, buf), 2);
+	KUNIT_EXPECT_STREQ(test, buf, "0\n");
+	KUNIT_EXPECT_FALSE(test, READ_ONCE(*field));
+
+	KUNIT_EXPECT_EQ(test, ops->store(&dev->kobj, kn->priv, "1\n", 2), 2);
+	KUNIT_EXPECT_TRUE(test, READ_ONCE(*field));
+	KUNIT_EXPECT_EQ(test, ops->show(&dev->kobj, kn->priv, buf), 2);
+	KUNIT_EXPECT_STREQ(test, buf, "1\n");
+
+	KUNIT_EXPECT_LT(test, ops->store(&dev->kobj, kn->priv, "bad", 3), 0);
+	KUNIT_EXPECT_TRUE(test, READ_ONCE(*field));
+
+	KUNIT_EXPECT_EQ(test, ops->store(&dev->kobj, kn->priv, "0\n", 2), 2);
+	KUNIT_EXPECT_FALSE(test, READ_ONCE(*field));
+
+	kernfs_put(kn);
+out_free:
+	free_page((unsigned long)buf);
+}
+
+static void kunit_attr_dev_release(struct device *dev)
+{
+	kfree(dev);
+}
+
+static void test_dev_pisa_attrs(struct kunit *test)
+{
+	struct device *dev;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, dev);
+	dev->init_name = "pisa_attr_kunit";
+	dev->release = kunit_attr_dev_release;
+	dev->coherent_dma_mask = DMA_BIT_MASK(64);
+	dev->dma_mask = &dev->coherent_dma_mask;
+
+	if (device_register(dev)) {
+		put_device(dev);
+		KUNIT_FAIL(test, "device_register failed");
+		return;
+	}
+	kunit_check_pisa_attr(test, dev, "pisa_coherent", &dev->pisa_coherent);
+	kunit_check_pisa_attr(test, dev, "pisa_rx_bufs", &dev->pisa_rx_bufs);
+	kunit_check_pisa_attr(test, dev, "pisa_tx_bufs", &dev->pisa_tx_bufs);
+	kunit_check_pisa_attr(test, dev, "pisa_tx_skb_heads", &dev->pisa_tx_skb_heads);
+	device_unregister(dev);
+}
+
 static void test_reservoir_and_scrubber(struct kunit *test)
 {
 	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
@@ -365,6 +431,7 @@ static struct kunit_case pisa_meta_test_cases[] = {
 	KUNIT_CASE(test_window_helpers),
 	KUNIT_CASE(test_map_and_domain_lifecycle),
 #endif
+	KUNIT_CASE(test_dev_pisa_attrs),
 	KUNIT_CASE(test_reservoir_and_scrubber),
 	{}
 };
diff --git a/drivers/iommu/pisa-priv.h b/drivers/iommu/pisa-priv.h
index 8d83ec09c19a9..e5ca95d2654cd 100644
--- a/drivers/iommu/pisa-priv.h
+++ b/drivers/iommu/pisa-priv.h
@@ -133,7 +133,6 @@ struct pisa_alloc {
 	unsigned int		num_idle_pages;
 	unsigned int		max_idle_pages;
 	unsigned long		idle_jiffies;
-
 	/* Cold. */
 	int			nid;
 	struct list_head	node;
diff --git a/include/linux/device.h b/include/linux/device.h
index 429e39f647cf9..b3c11e32116ca 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -695,6 +695,13 @@ enum struct_device_flags {
  * @removable:  Whether the device can be removed from the system. This
  *              should be set by the subsystem / bus driver that discovered
  *              the device.
+ * @pisa_coherent: Back coherent dma_alloc_attrs() with PISA
+ *		(sysfs pisa_coherent).
+ * @pisa_rx_bufs: Use PISA allocators for RX buffers (sysfs pisa_rx_bufs).
+ * @pisa_tx_bufs: Use PISA allocators for socket TX page fragments
+ *		(sysfs pisa_tx_bufs).
+ * @pisa_tx_skb_heads: Use PISA slab cache for small TX skb heads
+ *		(sysfs pisa_tx_skb_heads).
  * @flags:	DEV_FLAG_XXX flags. Use atomic bitfield operations to modify.
  *
  * At the lowest level, every device in a Linux system is represented by an
@@ -799,6 +806,11 @@ struct device {
 
 	enum device_removable	removable;
 
+	bool			pisa_coherent;
+	bool			pisa_rx_bufs;
+	bool			pisa_tx_bufs;
+	bool			pisa_tx_skb_heads;
+
 	DECLARE_BITMAP(flags, DEV_FLAG_COUNT);
 };
 
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index c64689b81befe..92482fce943e9 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -7,6 +7,7 @@
 #include <linux/bitops.h>
 #include <linux/dma-mapping.h>
 #include <linux/jump_label.h>
+#include <linux/device.h>
 #include <linux/mm.h>
 #include <linux/numa.h>
 #include <linux/rcupdate.h>
@@ -82,6 +83,13 @@ unsigned long pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order,
 				    int nr_pages, struct page **page_array,
 				    bool frozen);
 
+bool pisa_has_free_blocks_rx(const struct device *dev, unsigned int order, int nid);
+
+static inline gfp_t pisa_rx_gfp(const struct device *dev)
+{
+	return dev && READ_ONCE(dev->pisa_rx_bufs) ? __GFP_PISA_RW : 0;
+}
+
 #else /* !CONFIG_PISA */
 
 static inline int pisa_meta_init(void)
@@ -109,6 +117,17 @@ pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order, int preferred_nid,
 	return 0;
 }
 
+static inline gfp_t pisa_rx_gfp(const struct device *dev)
+{
+	return 0;
+}
+
+static inline bool pisa_has_free_blocks_rx(const struct device *dev,
+					   unsigned int order, int nid)
+{
+	return false;
+}
+
 #endif /* CONFIG_PISA */
 
 static inline struct page *
-- 
2.56.0.542.g3ef89b7020-goog


