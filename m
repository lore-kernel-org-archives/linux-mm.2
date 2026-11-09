Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07AF5606AFC3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PiHx2WlQ
Received: by kanga.kvack.org (Postfix)
	id 974596B05C4; Mon,  9 Nov 2026 13:25:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6FB6B05C6; Mon,  9 Nov 2026 13:25:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68CEC6B05C7; Mon,  9 Nov 2026 13:25:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A77D6B05C4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:25:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB8E48079B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:57 +0000 (UTC)
X-FDA: 85416409554.16.2177157
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf01.hostedemail.com (Postfix) with ESMTP id E4EC440007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PiHx2WlQ;
	spf=pass (imf01.hostedemail.com: domain of 3MRDyagYKCHghnevvkckkcha.Ykihejqt-iigrWYg.knc@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3MRDyagYKCHghnevvkckkcha.Ykihejqt-iigrWYg.knc@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248756;
	b=bnj5oLS8FJE4HB3xN/WX4V5nazN9dSSny3Ng1ukVgwwfPsxc4VUihZHM9Vhsf8HXI8wIM9
	5Ct5c3ias4hbxwQwZJxM8ECsX+ioN3SOf7BpoCNqiAxoNm5lKuFctCYCR3fuFHHERLQbMJ
	zrdAVp5xOL5W6bG7MjTVd7tXTE4tSsE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PiHx2WlQ;
	spf=pass (imf01.hostedemail.com: domain of 3MRDyagYKCHghnevvkckkcha.Ykihejqt-iigrWYg.knc@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3MRDyagYKCHghnevvkckkcha.Ykihejqt-iigrWYg.knc@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOBLNFdEo9U1nkMeSubCwXPQCx/4OB0eWyI1PfnbzsM=;
	b=u9V1YTJ2iZ4lVsBvRFa1yJBkiTi2EHqmRHKXLH4mU1SXWiIlsD9F2QVupqF62bdwQsIV3U
	g85spg+RwvgJkjmGCb9FHHFie6mA6EvTqS36f5SqAkfFs4Iyxxy+f3S2HzcXNrF3Xv5iWy
	J44RKIO9OfyqUJ/V4Fbk1ZtUmRuPIlQ=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c41f85ee4a3so104229866b.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248754; x=1794853554; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EOBLNFdEo9U1nkMeSubCwXPQCx/4OB0eWyI1PfnbzsM=;
        b=PiHx2WlQQJ/1K7+TlVRcDO/jj0dSSu5T6rzzVz4iANtrYCABPZ93LQJksORafa5gru
         EnRXAawgODHkzz48+k22WC8eJNyFo4ZTj2lt/raqmmTBzI6TrxKRQceJs8F4zq2HkuM7
         iT5DLz8Tr5YbmxTI6kR01WaY5c7ohmXFUtQ55S7+UiefU0+qzHoritcSB2sUP8Lp6HTE
         7P6ojJc7MYCDYHrvWxpG0PWwIQSIGwAd0bJcwcu7bsG5i9bjYSFQFTdmUsSngM8WN2J7
         srExl759cZcpwV3+gDwOIPGq7mcFpjOZ8WzBV4yXxIeVRUo8J3mxforYtPSmVOYPQ5nm
         e8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248754; x=1794853554;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EOBLNFdEo9U1nkMeSubCwXPQCx/4OB0eWyI1PfnbzsM=;
        b=qVIm4Lf97OyoS4rD0llI8QpFEKI/CQ9yo+MhTk7Of79IAWm0Bc3Uk2EWMowkI8elRl
         6Nza4GmbUa0ioHpoAzHPbEjIvcbCY9MMK+JdhFgAgluGq4Kp1r5/uHg+eN0cEnxwcRgz
         rs8XMpABvr6dxldfaahB3wbtJZORBGEGDfM0UmQWiH+rqA4lnthsImwqQ59CdaGF6GIX
         VUsdcp+bTNsrN7VFT1075plm65NlflshwrS1MbvgkgRpRfLauYdC0p7i1s1aSR9slBfC
         VZQ3e/K+fSvU6TTAllSCHC8eMBN9JdrRL7L0juLTAGn/cOTCeYLdamtWjgGwTwSZEFnM
         d9iQ==
X-Forwarded-Encrypted: i=1; AL+hErERcP9uV5hv5KD5P9IPtvLadWtjOGhP7QzapRbJaUArw38VNBNIRsuorADpxW9ZZ5Nhz6V1eJ1PRQ==@kvack.org
X-Gm-Message-State: APuU4Z9IZiJB8bAp85JufEvsb9eATp2cqp+3DIFKe4A5zXdYB2iQvjFE
	SqHqg9JudodAHgmFItuW70S+jZf3DYXrTU6U4biuAFU9sKSPM/HP5uI3WQGR/5bzbPKC0Srq/mT
	y7gxcog==
X-Received: from ejmc5.prod.google.com ([2002:a17:906:5285:b0:c29:6cda:93b5])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:cd07:b0:c42:e6c8:e494
 with SMTP id a640c23a62f3a-c504955cc09mr14726566b.37.1794248753833; Mon, 09
 Nov 2026 10:25:53 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:25 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-18-lrizzo@google.com>
Subject: [RFC PATCH v2 17/25] net: Allocate small skb heads from PISA
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
X-Stat-Signature: 5pjrezy5mbsd3zt411y8p7fjqp174y7q
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E4EC440007
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794248755-770012
X-HE-Meta: U2FsdGVkX1/Ae7OSaKNNiPiN9tEd9UYsVnQoEpQOHvxHF6025Z0p5i/re+3BwYcfxRY4savF5W5B/KK9EU4Rpq/E0WDkFUF11LSu5i2SPyy+doIx/guiVF0+YT0PP0afH+6erZ6vk2MDUejUGEuASoo7cmauUtH9bJ3lwjuBp+hr4CHqcpSGvX+X3p1FHpKafakS8t4ylu4vn+Vd/vqawFUELu7e3dqAWtESmyjlogCCKN3dPHC42HZiluMcny0exCWTh0mkogxXNZQ/Dqlarsw00CZUQY5w45gx204F/tiYBqz6w0ZpJrji1ekEni4NT/p3dMeMUEZ6TfJ0KthguC4p6YbEm/Ui48mmRRoks/xNBJNa3144FqcZgu79obP0AmlXw0rZ3Fil5HJXVT2WXpqRlea1K1LbJzPwy/I17BLAS2S/lFM3L7HH4d88kc94cNyBKrOJg0WhudKrazK2O7VWGcpJ0CNKypRR+dJpdk3Ho8zA4ukcYumwg+SKd39duXCxUQE67UKCQ43YZW64vDkz+ZGBpYpb9uvS3FheuxKB+jHQcTtN7LUohcZud+7g5mphrRY1eKr3D4iDo5FC/DwwADGmTnm5THsxHScC39QOlijjQnYRVzhqKklYz8APLTC+fT65RWE0mlZEGP4q9rSLs02EArUMiGSq3ukyGvSSqM4Rkk70ttys6YfqpIIGptyZX/jYTmdhvprzDRridTUy+Wvu3fTYBRwrnPB9F6IUOT42l+Vr3iikCDmQbOtbIE70S2ZSHPB1NC8yxSpAAUWOjSud2hcXTzA3OVnIrWpvuFTxGNz903no6E4rJ7ZkUfaHu6w80OSuo3JQWCJYEtUL0Al8Pl/JLjN+Meap4EsZ3QnyPRAtAJaHIYJ/x3TZqPdM2K9kXE9BJyg2/2waCLhWhDgZT15KtTRfoGcvYuyi4oDo3jWpB8ueDxj+ZceuEbRG45lOOstoAjMKHYa
 zEC0Zk+X
 vv6K4yQeaW45nC/kCjrlFaoZ8HbDqKI7UGGWf0e/+F33AulTkTUJ8TOypqOzr/8l7CsTqAKyhkDwiCIkdRiBV/IXz5vzWZdyLWoWaHpUoKSqZo7ehupgWZkY85OTPDrG2uoXURuIeZWc5fRn5GJjKnwTO5BBFub/FVNtK6jevnPS95bHQR0RpLaCY94aQaXU7T8W2P2xmCK6rjKoenbZ67XRxnYaun6hL10gGS8xeemJsOqnrGE0Y9ytcnFCjsUgTbEH3qH/Dex8Swsc1xZtPrEhwJ2n5zMSX62rGgMOERFKHV1nAg2nutBEAlKIlSoQA3yrrcN0it6oU5gyQ2NUgJdbgML9cscwmoI4GZ4r5gThJGuN7EiAh+GOLat/BFiSOvdqPL7zUE+V9vwzEseQ7ToLng2+EL++bw+fO2tX9fcY5IrlhKRMD8Qw+VHdjcJVFQ7pxN9FShJGCs4YQCc9KslCXiNeO+0Qsk4winhshjcjCDqajDlmLyAEESTjgQfxKEo/mFMsjv/hNfGuchqavsfpaYW5/H3X5KZcSAtJHULEGNQEf5WsS8PeN4XFUtpOR1XhtfgkFX63jcrgS/w2/hLzSCvZZY8GHEEvwFwbND/jnMzdF0U6yfklP2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The linear part of most transmitted skbs is a small head from the
skbuff_small_head cache. To avoid per-packet IOMMU map/unmap operations
or bounce-buffer copies for headers, allow backing small TX skb heads
with PISA memory.

When per-device pisa_tx_skb_heads is enabled, create a parallel
skbuff_small_head_pisa slab cache backed by zeroed, read-only PISA
folios (SLAB_CACHE_PISA_RO). Eligible TX paths passing __GFP_PISA_RO
allocate small heads from this cache and fall back to skbuff_small_head
on failure.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/base/core.c        |   4 +-
 drivers/iommu/pisa-alloc.c | 133 ++++++++++++++++++++++++++++++++-----
 drivers/iommu/pisa-kunit.c |   5 +-
 include/linux/device.h     |   6 ++
 include/linux/pisa.h       |   6 ++
 include/net/sock.h         |  74 ++++++++++++++++++---
 net/core/skbuff.c          |  39 ++++++++---
 net/core/sock.c            |  23 +++++--
 net/ipv4/ip_output.c       |   8 ++-
 net/ipv4/tcp.c             |   2 +-
 net/ipv4/tcp_output.c      |  12 ++--
 net/ipv6/ip6_output.c      |   8 ++-
 12 files changed, 263 insertions(+), 57 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index ade0c94b02ae7..efc1f9b9d255d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2951,7 +2951,7 @@ static DEVICE_ATTR_RW(name)
 PISA_BOOL_ATTR(pisa_coherent);
 PISA_BOOL_ATTR(pisa_rx_bufs);
 PISA_SET_ATTR(pisa_tx_bufs, net_pisa_tx_bufs_set);
-PISA_BOOL_ATTR(pisa_tx_skb_heads);
+PISA_SET_ATTR(pisa_tx_skb_heads, net_pisa_tx_skb_heads_set);
 
 static struct attribute *dev_attr_pisa[] = {
 	&dev_attr_pisa_coherent.attr,
@@ -3113,6 +3113,8 @@ static void device_remove_attrs(struct device *dev)
 		device_remove_group(dev, &dev_attr_pisa_group);
 		if (dev->pisa_tx_bufs)
 			net_pisa_tx_bufs_set(dev, false);
+		if (dev->pisa_tx_skb_heads)
+			net_pisa_tx_skb_heads_set(dev, false);
 	}
 
 	if (dev->physical_location) {
diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
index 3b5c49d143a7e..7df2ecde32916 100644
--- a/drivers/iommu/pisa-alloc.c
+++ b/drivers/iommu/pisa-alloc.c
@@ -37,6 +37,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
+#include <net/hotdata.h>
 #include <net/sock.h>
 
 #include "dma-iommu.h"
@@ -922,37 +923,133 @@ int net_pisa_tx_bufs_set(struct device *dev, bool val)
 }
 
 /*
- * The sysfs attribute pisa_tx_bufs lives on the physical DMA parent
- * (dev->dev.parent), whereas a socket route (dst->dev) may point to an upper
- * virtual net_device (bond, VLAN, ipvlan, etc.). Walking lower devices via
- * netdev_walk_all_lower_dev_rcu() on every TX allocation would be too
- * expensive, so dev->pisa_tx_stamp caches the walk result on the net_device
- * and refreshes it at most once every 256 jiffies:
- *   bit 0 (PISA_TX_STAMP_OK):         pisa_tx_bufs enabled on lower device(s)
+ * dev->pisa_tx_skb_heads: when set on an egress device, small TX skb heads
+ * (__GFP_PISA_RO) come from a copy of skbuff_small_head whose slab pages are
+ * PISA blocks. The linear part of most transmitted skbs is then mapped
+ * through the PISA window without per-driver bounce buffers. Several heads
+ * share a slab page and each one ends with its skb_shared_info, so:
+ * - the allocators are TX-only (DMA_TO_DEVICE): their PISA pages are mapped device
+ *   read-only, and a DMA mapping that wants device writes gets a per-buffer
+ *   IOMMU mapping, as for any kmalloc() buffer;
+ * - slab pages are zeroed when taken from the allocator, so the device can read
+ *   skb heads (live or freed) but never older contents of the page.
+ * Heads are freed with kfree() whichever cache they came from, so the key
+ * can be toggled at any time. The cache and allocators are created on the first
+ * write and never destroyed.
+ */
+DEFINE_STATIC_KEY_FALSE(net_pisa_tx_skb_heads_key);
+EXPORT_SYMBOL(net_pisa_tx_skb_heads_key);
+
+static struct kmem_cache *pisa_skb_small_head_cache __read_mostly;
+
+/* Lazily initialize skbuff_small_head_pisa on first enable. */
+static int pisa_skb_head_init(void)
+{
+	unsigned int size = kmem_cache_size(net_hotdata.skb_small_head_cache);
+	struct kmem_cache_args args = {
+		/* As skbuff_small_head, see skb_init(). */
+		.useroffset	= 0,
+		.usersize	= SKB_WITH_OVERHEAD(size),
+		.sheaf_capacity	= 32,
+	};
+	static DEFINE_MUTEX(mutex);
+	struct kmem_cache *s;
+	int ret = 0;
+
+	mutex_lock(&mutex);
+	if (pisa_skb_small_head_cache)
+		goto out;
+
+	/* No slab is allocated before the cache is published below. */
+	s = kmem_cache_create("skbuff_small_head_pisa", size, &args,
+			      SLAB_HWCACHE_ALIGN | SLAB_NO_MERGE | SLAB_CACHE_PISA_RO);
+	if (!s) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	WRITE_ONCE(pisa_skb_small_head_cache, s);
+out:
+	mutex_unlock(&mutex);
+	return ret;
+}
+
+int net_pisa_tx_skb_heads_set(struct device *dev, bool val)
+{
+	static DEFINE_MUTEX(lock);
+
+	if (val) {
+		int ret = pisa_skb_head_init();
+
+		if (ret)
+			return ret;
+	}
+
+	mutex_lock(&lock);
+	if (dev->pisa_tx_skb_heads != val) {
+		WRITE_ONCE(dev->pisa_tx_skb_heads, val);
+		if (val)
+			static_branch_inc(&net_pisa_tx_skb_heads_key);
+		else
+			static_branch_dec(&net_pisa_tx_skb_heads_key);
+	}
+	mutex_unlock(&lock);
+	return 0;
+}
+
+void *pisa_skb_head_alloc_node(gfp_t flags, int node)
+{
+	if (!static_branch_unlikely(&net_pisa_tx_skb_heads_key))
+		return NULL;
+	return kmem_cache_alloc_node(pisa_skb_small_head_cache,
+				     flags | __GFP_NOMEMALLOC | __GFP_NOWARN, node);
+}
+
+/*
+ * The sysfs attributes pisa_tx_bufs and pisa_tx_skb_heads live on the
+ * physical DMA parent (dev->dev.parent), whereas a socket route (dst->dev)
+ * may point to an upper virtual net_device (bond, VLAN, ipvlan, etc.).
+ * Walking lower devices via netdev_walk_all_lower_dev_rcu() on every TX
+ * allocation would be too expensive, so dev->pisa_tx_stamp caches the walk
+ * result on the net_device and refreshes it at most once every 256 jiffies:
+ *   bit 0 (PISA_TX_STAMP_BUFS):       pisa_tx_bufs enabled on lower device(s)
+ *   bit 1 (PISA_TX_STAMP_HEADS):      pisa_tx_skb_heads enabled on lower device(s)
  *   bits 31..8 (PISA_TX_STAMP_MASK):  upper 24 bits of (u32)jiffies
  */
-static int netdev_pisa_tx_bufs_walk(struct net_device *dev, struct netdev_nested_priv *priv)
+static u32 netdev_pisa_tx_flags(const struct net_device *dev)
 {
-	return dev->dev.parent && READ_ONCE(dev->dev.parent->pisa_tx_bufs);
+	struct device *parent = dev->dev.parent;
+	u32 flags = 0;
+
+	if (parent) {
+		if (READ_ONCE(parent->pisa_tx_bufs))
+			flags |= PISA_TX_STAMP_BUFS;
+		if (READ_ONCE(parent->pisa_tx_skb_heads))
+			flags |= PISA_TX_STAMP_HEADS;
+	}
+	return flags;
 }
 
-/* Slow path of __netdev_tx_pisa_ok(): refresh dev->pisa_tx_stamp. */
-bool netdev_tx_pisa_refresh(struct net_device *dev, u32 now)
+static int netdev_pisa_tx_walk(struct net_device *dev, struct netdev_nested_priv *priv)
 {
-	bool ok;
+	priv->data = (void *)((uintptr_t)priv->data | netdev_pisa_tx_flags(dev));
+	return 0;
+}
 
+/* Slow path of __netdev_tx_pisa_ok(): refresh dev->pisa_tx_stamp. */
+u32 netdev_tx_pisa_refresh(struct net_device *dev, u32 now)
+{
 	if (dev->dev.parent) {
-		ok = READ_ONCE(dev->dev.parent->pisa_tx_bufs);
+		now |= netdev_pisa_tx_flags(dev);
 	} else {
+		struct netdev_nested_priv priv = {};
+
 		rcu_read_lock();
-		ok = netdev_walk_all_lower_dev_rcu(dev,
-						   netdev_pisa_tx_bufs_walk,
-						   NULL) != 0;
+		netdev_walk_all_lower_dev_rcu(dev, netdev_pisa_tx_walk, &priv);
 		rcu_read_unlock();
+		now |= (uintptr_t)priv.data;
 	}
-	now |= ok ? PISA_TX_STAMP_OK : 0;
 	WRITE_ONCE(dev->pisa_tx_stamp, now);
-	return now & PISA_TX_STAMP_OK;
+	return now;
 }
 EXPORT_SYMBOL(netdev_tx_pisa_refresh);
 #endif /* CONFIG_NET */
diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
index 9cc1328893ace..3fc17024bc9d0 100644
--- a/drivers/iommu/pisa-kunit.c
+++ b/drivers/iommu/pisa-kunit.c
@@ -489,9 +489,10 @@ static void test_dev_pisa_attrs(struct kunit *test)
 	}
 	kunit_check_pisa_attr(test, dev, "pisa_coherent", &dev->pisa_coherent);
 	kunit_check_pisa_attr(test, dev, "pisa_rx_bufs", &dev->pisa_rx_bufs);
-	if (IS_ENABLED(CONFIG_NET))
+	if (IS_ENABLED(CONFIG_NET)) {
 		kunit_check_pisa_attr(test, dev, "pisa_tx_bufs", &dev->pisa_tx_bufs);
-	kunit_check_pisa_attr(test, dev, "pisa_tx_skb_heads", &dev->pisa_tx_skb_heads);
+		kunit_check_pisa_attr(test, dev, "pisa_tx_skb_heads", &dev->pisa_tx_skb_heads);
+	}
 	device_unregister(dev);
 }
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 08f511b978ded..d588ae27c960c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -816,11 +816,17 @@ struct device {
 
 #if defined(CONFIG_NET) && defined(CONFIG_PISA)
 int net_pisa_tx_bufs_set(struct device *dev, bool val);
+int net_pisa_tx_skb_heads_set(struct device *dev, bool val);
 #else
 static inline int net_pisa_tx_bufs_set(struct device *dev, bool val)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int net_pisa_tx_skb_heads_set(struct device *dev, bool val)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #define __create_dev_flag_accessors(accessor_name, flag_name) \
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index b9c5197f2d88d..452b8fa20c8d7 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -113,6 +113,7 @@ unsigned long pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order,
 struct folio *pisa_alloc_folio(gfp_t gfp, unsigned int order, int nid);
 bool pisa_has_free_blocks_rx(const struct device *dev, unsigned int order, int nid);
 bool pisa_page_can_recycle(const struct page *page);
+void *pisa_skb_head_alloc_node(gfp_t flags, int node);
 
 static inline gfp_t pisa_rx_gfp(const struct device *dev)
 {
@@ -169,6 +170,11 @@ static inline bool pisa_free_coherent(struct page *page, size_t size)
 	return false;
 }
 
+static inline void *pisa_skb_head_alloc_node(gfp_t flags, int node)
+{
+	return NULL;
+}
+
 static inline bool pisa_page_can_recycle(const struct page *page)
 {
 	return true;
diff --git a/include/net/sock.h b/include/net/sock.h
index 73906351d11db..78f16b76dfc3b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1900,6 +1900,10 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 		  sockptr_t optval, sockptr_t optlen);
 int sock_gettstamp(struct socket *sock, void __user *userstamp,
 		   bool timeval, bool time32);
+struct sk_buff *__sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
+				       unsigned long data_len, int noblock,
+				       int *errcode, int max_page_order,
+				       gfp_t gfp);
 struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 				     unsigned long data_len, int noblock,
 				     int *errcode, int max_page_order);
@@ -2671,20 +2675,27 @@ static inline struct page_frag *sk_page_frag(struct sock *sk)
 }
 
 /* 256-jiffy cache in dev->pisa_tx_stamp; see netdev_tx_pisa_refresh(). */
-#define PISA_TX_STAMP_OK	BIT(0)
+#define PISA_TX_STAMP_BUFS	BIT(0)
+#define PISA_TX_STAMP_HEADS	BIT(1)
 #define PISA_TX_STAMP_MASK	(~0xffU)
 
 #ifdef CONFIG_PISA
 DECLARE_STATIC_KEY_FALSE(net_pisa_tx_bufs_key);
+DECLARE_STATIC_KEY_FALSE(net_pisa_tx_skb_heads_key);
 
 static inline bool net_pisa_tx_bufs_enabled(void)
 {
 	return static_branch_unlikely(&net_pisa_tx_bufs_key);
 }
 
-bool netdev_tx_pisa_refresh(struct net_device *dev, u32 now);
+static inline bool net_pisa_tx_skb_heads_enabled(void)
+{
+	return static_branch_unlikely(&net_pisa_tx_skb_heads_key);
+}
 
-static inline bool __netdev_tx_pisa_ok(const struct net_device *dev)
+u32 netdev_tx_pisa_refresh(struct net_device *dev, u32 now);
+
+static inline bool __netdev_tx_pisa_ok(const struct net_device *dev, u32 flag)
 {
 	u32 stamp, now;
 
@@ -2692,9 +2703,9 @@ static inline bool __netdev_tx_pisa_ok(const struct net_device *dev)
 		return false;
 	stamp = READ_ONCE(dev->pisa_tx_stamp);
 	now = (u32)jiffies & PISA_TX_STAMP_MASK;
-	if (likely((stamp & PISA_TX_STAMP_MASK) == now))
-		return stamp & PISA_TX_STAMP_OK;
-	return netdev_tx_pisa_refresh((struct net_device *)dev, now);
+	if (unlikely((stamp & PISA_TX_STAMP_MASK) != now))
+		stamp = netdev_tx_pisa_refresh((struct net_device *)dev, now);
+	return stamp & flag;
 }
 #else
 static inline bool net_pisa_tx_bufs_enabled(void)
@@ -2702,7 +2713,12 @@ static inline bool net_pisa_tx_bufs_enabled(void)
 	return false;
 }
 
-static inline bool __netdev_tx_pisa_ok(const struct net_device *dev)
+static inline bool net_pisa_tx_skb_heads_enabled(void)
+{
+	return false;
+}
+
+static inline bool __netdev_tx_pisa_ok(const struct net_device *dev, u32 flag)
 {
 	return false;
 }
@@ -2714,20 +2730,58 @@ static inline bool __netdev_tx_pisa_ok(const struct net_device *dev)
  * active, so only data that leaves the host in clear qualifies: IPsec payload
  * is still plaintext here.
  */
-static inline bool dst_tx_pisa_ok(const struct dst_entry *dst)
+static inline bool __dst_tx_pisa_ok(const struct dst_entry *dst, u32 flag)
 {
 	bool ok = false;
 
-	if (!net_pisa_tx_bufs_enabled() || !dst)
+	if (!dst)
 		return false;
 
 	rcu_read_lock();
 	if (!dst_xfrm(dst))
-		ok = __netdev_tx_pisa_ok(dst_dev_rcu(dst));
+		ok = __netdev_tx_pisa_ok(dst_dev_rcu(dst), flag);
 	rcu_read_unlock();
 	return ok;
 }
 
+static inline bool dst_tx_pisa_ok(const struct dst_entry *dst)
+{
+	return net_pisa_tx_bufs_enabled() &&
+	       __dst_tx_pisa_ok(dst, PISA_TX_STAMP_BUFS);
+}
+
+static inline gfp_t pisa_tx_gfp_dst(const struct dst_entry *dst)
+{
+	if (net_pisa_tx_skb_heads_enabled() &&
+	    __dst_tx_pisa_ok(dst, PISA_TX_STAMP_HEADS))
+		return __GFP_PISA_RO;
+	return 0;
+}
+
+static inline gfp_t pisa_tx_gfp_sk(const struct sock *sk)
+{
+	if (net_pisa_tx_skb_heads_enabled() && sk) {
+		bool ok;
+
+		rcu_read_lock();
+		ok = __dst_tx_pisa_ok(rcu_dereference(sk->sk_dst_cache),
+				      PISA_TX_STAMP_HEADS);
+		rcu_read_unlock();
+		if (ok)
+			return __GFP_PISA_RO;
+	}
+	return 0;
+}
+
+static inline struct sk_buff *sock_alloc_send_skb_dst(struct sock *sk,
+						      unsigned long size,
+						      int noblock, int *errcode,
+						      const struct dst_entry *dst)
+{
+	return __sock_alloc_send_pskb(sk, size, 0, noblock, errcode, 0,
+				      pisa_tx_gfp_dst(dst));
+}
+
 /* Is @pfrag the task's frag reserved for PISA-eligible data? */
 static inline bool is_pisa_pfrag(const struct page_frag *pfrag)
 {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8da53d5b76fc2..04ae3bb4bd905 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -93,6 +93,7 @@
 #include <linux/user_namespace.h>
 #include <linux/indirect_call_wrapper.h>
 #include <linux/textsearch.h>
+#include <linux/pisa.h>
 
 #include "dev.h"
 #include "devmem.h"
@@ -607,16 +608,23 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
 static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 			     struct sk_buff *skb)
 {
+	bool pisa = flags & __GFP_PISA_RO;
 	size_t obj_size;
 	void *obj;
 
+	flags &= ~__GFP_PISA_RW;
 	obj_size = SKB_HEAD_ALIGN(*size);
 	if (obj_size <= SKB_SMALL_HEAD_CACHE_SIZE &&
 	    !(flags & KMALLOC_NOT_NORMAL_BITS)) {
+		*size = SKB_SMALL_HEAD_CACHE_SIZE;
+		if (unlikely(pisa)) {
+			obj = pisa_skb_head_alloc_node(flags, node);
+			if (likely(obj))
+				goto out;
+		}
 		obj = kmem_cache_alloc_node(net_hotdata.skb_small_head_cache,
 				flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
 				node);
-		*size = SKB_SMALL_HEAD_CACHE_SIZE;
 		if (likely(obj))
 			goto out;
 		/* Try again but now we are using pfmemalloc reserves */
@@ -2144,6 +2152,15 @@ void skb_copy_header(struct sk_buff *new, const struct sk_buff *old)
 }
 EXPORT_SYMBOL(skb_copy_header);
 
+static inline gfp_t skb_head_pisa_gfp(const struct sk_buff *skb)
+{
+	if (net_pisa_tx_skb_heads_enabled() &&
+	    !skb->head_frag &&
+	    is_pisa_page(virt_to_page(skb->head)))
+		return __GFP_PISA_RO;
+	return 0;
+}
+
 static inline int skb_alloc_rx_flag(const struct sk_buff *skb)
 {
 	if (skb_pfmemalloc(skb))
@@ -2182,7 +2199,7 @@ struct sk_buff *skb_copy(const struct sk_buff *skb, gfp_t gfp_mask)
 
 	headerlen = skb_headroom(skb);
 	size = skb_end_offset(skb) + skb->data_len;
-	n = __alloc_skb(size, gfp_mask,
+	n = __alloc_skb(size, gfp_mask | skb_head_pisa_gfp(skb),
 			skb_alloc_rx_flag(skb), NUMA_NO_NODE);
 	if (!n)
 		return NULL;
@@ -2226,7 +2243,8 @@ struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
 {
 	unsigned int size = skb_headlen(skb) + headroom;
 	int flags = skb_alloc_rx_flag(skb) | (fclone ? SKB_ALLOC_FCLONE : 0);
-	struct sk_buff *n = __alloc_skb(size, gfp_mask, flags, NUMA_NO_NODE);
+	struct sk_buff *n = __alloc_skb(size, gfp_mask | skb_head_pisa_gfp(skb),
+					flags, NUMA_NO_NODE);
 
 	if (!n)
 		goto out;
@@ -2315,7 +2333,8 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
+	data = kmalloc_reserve(&size, gfp_mask | skb_head_pisa_gfp(skb),
+			       NUMA_NO_NODE, NULL);
 	if (!data)
 		goto nodata;
 	size = SKB_WITH_OVERHEAD(size);
@@ -2524,7 +2543,8 @@ struct sk_buff *skb_copy_expand(const struct sk_buff *skb,
 
 	oldheadroom = skb_headroom(skb);
 	n = __alloc_skb(newheadroom + skb->len + newtailroom,
-			gfp_mask, skb_alloc_rx_flag(skb),
+			gfp_mask | skb_head_pisa_gfp(skb),
+			skb_alloc_rx_flag(skb),
 			NUMA_NO_NODE);
 	if (!n)
 		return NULL;
@@ -5025,7 +5045,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 				hsize = len;
 
 			nskb = __alloc_skb(hsize + doffset + headroom,
-					   GFP_ATOMIC, skb_alloc_rx_flag(head_skb),
+					   GFP_ATOMIC | skb_head_pisa_gfp(head_skb),
+					   skb_alloc_rx_flag(head_skb),
 					   NUMA_NO_NODE);
 
 			if (unlikely(!nskb))
@@ -6974,7 +6995,8 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
+	data = kmalloc_reserve(&size, gfp_mask | skb_head_pisa_gfp(skb),
+			       NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
 	size = SKB_WITH_OVERHEAD(size);
@@ -7096,7 +7118,8 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
 
-	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
+	data = kmalloc_reserve(&size, gfp_mask | skb_head_pisa_gfp(skb),
+			       NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
 	size = SKB_WITH_OVERHEAD(size);
diff --git a/net/core/sock.c b/net/core/sock.c
index 695fefe316925..0ddb5e57f4969 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3061,9 +3061,10 @@ static long sock_wait_for_wmem(struct sock *sk, long timeo)
  *	Generic send/receive buffer handlers
  */
 
-struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
-				     unsigned long data_len, int noblock,
-				     int *errcode, int max_page_order)
+struct sk_buff *__sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
+				       unsigned long data_len, int noblock,
+				       int *errcode, int max_page_order,
+				       gfp_t gfp)
 {
 	struct sk_buff *skb;
 	long timeo;
@@ -3092,7 +3093,8 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 		timeo = sock_wait_for_wmem(sk, timeo);
 	}
 	skb = alloc_skb_with_frags(header_len, data_len, max_page_order,
-				   errcode, sk->sk_allocation);
+				   errcode,
+				   sk->sk_allocation | (!data_len ? gfp : 0));
 	if (skb)
 		skb_set_owner_w(skb, sk);
 	return skb;
@@ -3103,6 +3105,16 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 	*errcode = err;
 	return NULL;
 }
+EXPORT_SYMBOL(__sock_alloc_send_pskb);
+
+struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
+				     unsigned long data_len, int noblock,
+				     int *errcode, int max_page_order)
+{
+	return __sock_alloc_send_pskb(sk, header_len, data_len, noblock,
+				      errcode, max_page_order,
+				      pisa_tx_gfp_sk(sk));
+}
 EXPORT_SYMBOL(sock_alloc_send_pskb);
 
 int __sock_cmsg_send(struct sock *sk, struct cmsghdr *cmsg,
@@ -3322,7 +3334,8 @@ bool skb_page_frag_refill_dev(unsigned int sz, struct page_frag *pfrag,
 		const struct dst_entry *dst = skb_dst(skb);
 
 		rcu_read_lock();
-		if (__netdev_tx_pisa_ok(skb->dev ?: (dst ? dst_dev_rcu(dst) : NULL)))
+		if (__netdev_tx_pisa_ok(skb->dev ?: (dst ? dst_dev_rcu(dst) : NULL),
+					PISA_TX_STAMP_BUFS))
 			gfp |= __GFP_PISA_RO;
 		rcu_read_unlock();
 	}
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index a5ea530bc8b5b..c49a33355ea45 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1134,14 +1134,16 @@ static int __ip_append_data(struct sock *sk,
 			alloclen += alloc_extra;
 
 			if (transhdrlen) {
-				skb = sock_alloc_send_skb(sk, alloclen,
-						(flags & MSG_DONTWAIT), &err);
+				skb = sock_alloc_send_skb_dst(sk, alloclen,
+							      flags & MSG_DONTWAIT,
+							      &err, &rt->dst);
 			} else {
 				skb = NULL;
 				if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
 				    2 * sk->sk_sndbuf)
 					skb = alloc_skb(alloclen,
-							sk->sk_allocation);
+							sk->sk_allocation |
+							pisa_tx_gfp_dst(&rt->dst));
 				if (unlikely(!skb))
 					err = -ENOBUFS;
 			}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b8d44a0638914..038063717951c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -931,7 +931,7 @@ struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, gfp_t gfp,
 {
 	struct sk_buff *skb;
 
-	skb = alloc_skb_fclone(MAX_TCP_HEADER, gfp);
+	skb = alloc_skb_fclone(MAX_TCP_HEADER, gfp | pisa_tx_gfp_sk(sk));
 	if (likely(skb)) {
 		bool mem_scheduled;
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cf3ddc055d48d..b7f04a9df199a 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3892,8 +3892,8 @@ void tcp_send_fin(struct sock *sk)
 		}
 	} else {
 		skb = alloc_skb_fclone(MAX_TCP_HEADER,
-				       sk_gfp_mask(sk, GFP_ATOMIC |
-						       __GFP_NOWARN));
+				       sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN) |
+				       pisa_tx_gfp_sk(sk));
 		if (unlikely(!skb))
 			return;
 
@@ -3921,7 +3921,7 @@ void tcp_send_active_reset(struct sock *sk, enum sk_rst_reason reason)
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTRSTS);
 
 	/* NOTE: No TCP options attached and we never retransmit this. */
-	skb = alloc_skb(MAX_TCP_HEADER, priority);
+	skb = alloc_skb(MAX_TCP_HEADER, priority | pisa_tx_gfp_sk(sk));
 	if (!skb) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTFAILED);
 		return;
@@ -4011,7 +4011,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	int mss;
 	u64 now;
 
-	skb = alloc_skb(MAX_TCP_HEADER, GFP_ATOMIC);
+	skb = alloc_skb(MAX_TCP_HEADER, GFP_ATOMIC | pisa_tx_gfp_dst(dst));
 	if (unlikely(!skb)) {
 		dst_release(dst);
 		return NULL;
@@ -4548,7 +4548,7 @@ void __tcp_send_ack(struct sock *sk, u32 rcv_nxt, u16 flags)
 	 * sock.
 	 */
 	buff = alloc_skb(MAX_TCP_HEADER,
-			 sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN));
+			 sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN) | pisa_tx_gfp_sk(sk));
 	if (unlikely(!buff)) {
 		struct inet_connection_sock *icsk = inet_csk(sk);
 		unsigned long delay;
@@ -4601,7 +4601,7 @@ static int tcp_xmit_probe_skb(struct sock *sk, int urgent, int mib)
 
 	/* We don't queue it, tcp_transmit_skb() sets ownership. */
 	skb = alloc_skb(MAX_TCP_HEADER,
-			sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN));
+			sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN) | pisa_tx_gfp_sk(sk));
 	if (!skb)
 		return -1;
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 957c38a08680c..47a6fea3456fe 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1695,14 +1695,16 @@ static int __ip6_append_data(struct sock *sk,
 				goto error;
 			}
 			if (transhdrlen) {
-				skb = sock_alloc_send_skb(sk, alloclen,
-						(flags & MSG_DONTWAIT), &err);
+				skb = sock_alloc_send_skb_dst(sk, alloclen,
+							      flags & MSG_DONTWAIT,
+							      &err, &rt->dst);
 			} else {
 				skb = NULL;
 				if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
 				    2 * sk->sk_sndbuf)
 					skb = alloc_skb(alloclen,
-							sk->sk_allocation);
+							sk->sk_allocation |
+							pisa_tx_gfp_dst(&rt->dst));
 				if (unlikely(!skb))
 					err = -ENOBUFS;
 			}
-- 
2.56.0.542.g3ef89b7020-goog


