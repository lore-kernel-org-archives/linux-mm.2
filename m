Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F492C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9CB76B009F; Mon, 24 Aug 2026 11:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C806B00A0; Mon, 24 Aug 2026 11:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B147C6B00A7; Mon, 24 Aug 2026 11:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74F936B009F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:29:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E456112019A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:29:41 +0000 (UTC)
X-FDA: 85136547762.11.2A74E4C
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf25.hostedemail.com (Postfix) with ESMTP id 28CF8A0009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:29:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iF9ujG37;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3YmOMagYKCLUgmduujbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--lrizzo.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3YmOMagYKCLUgmduujbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rIIxKJ/h4TdOX2PzM8xN9SJKh2HJ62O9uv+0COVNyBw=;
	b=5aWfj9BK5ye5ADA0tdcldmBGHzR63FNLMKvTNViNSfG8lk4XQ8JWtXTj0BePSXVkHMMH6o
	QMyam6dRamh5a3oSVuTjg79MHDtd9WVx0zke+RvjA3sxCbUpcEtSyYEWm3QwsqIGnyN8VA
	whj5MEEuJ7HjvMGD3xn7AyoYUSB9X0g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iF9ujG37;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3YmOMagYKCLUgmduujbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--lrizzo.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3YmOMagYKCLUgmduujbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787585380;
	b=BUIvuKWAJ+HU0yBRsJus4P72vCjV7JKjkiBrpDZRJZmBef/IMbKCvjjlTJ6dBYWk5cOIRq
	qRd5yBNTlvzV/J5WdD8/BtO3/h29RRiIpNpW4gEh5nT8LVF+hmZfywochdb4YhxzFbqTr1
	zeglTMnZi6kVK2sUDiktY1QaYFAi7Vo=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c15ddb61f13so336762566b.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787585379; x=1788190179; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rIIxKJ/h4TdOX2PzM8xN9SJKh2HJ62O9uv+0COVNyBw=;
        b=iF9ujG37giOLW2aUI602/FupgQbfThycgGVkdqQvTT0S/UmJbS+GL+j88HgODKt8cu
         WGz83WMsXBEreLldUSFL5XweCFu894FCiFin49D53rNEOAeJDqA/T8l/DYd0rNKebCpB
         0LUSzBB5u5RJMO8OxU/k3FoXa7DbqfX4RwiyP679pU++MR7d+mF1Y3u/YYYvi7YGIFbT
         I24wzZ3JFk9XTKTzazVf1EQwP+a43H76CI+VNkTtgJJ8ccnLaVGa8fDUX5g2EvSVXXrH
         sY5Lre1y3uP0WYjin0p/K2eTTtRX/+Q6qXV7WkqtbefSEGNXUIuSozXhw0hX5BS+8Ww5
         +yvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787585379; x=1788190179;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rIIxKJ/h4TdOX2PzM8xN9SJKh2HJ62O9uv+0COVNyBw=;
        b=VeJg0XFhoEayjp/8cD3TfU48zBZhVPWmV9ySPsLXM7BnyoR7mTvJfyD52iMXh2ECAG
         TClX+h3rRNdsSdotctrqwaF7/XN7aqC0mMqzCfl4j6Jpg2Q2YRpqMqNr6F5E97etAcFz
         nPMkXq/1uLRGF5F6Y7h4EuwRqhdVwHIMbRKcNPWbdSI0i+IOomougsz/3/9vHtnsbLZ3
         +VA0EOyGjsy0f9CiJ/K9ILEyBP5mU1QDENqEb88Tk1H4XjsEMi6gXUD6ko5ohDXJbVnK
         XKqIi1VL9ZHQ4itS2mF10hZox295xd9+pBNmCnqMOCOEFSG58arx2fGtmExAQxpRKJOn
         J7Rg==
X-Forwarded-Encrypted: i=1; AHgh+RrGQYpQcy29ACAyFaUUMQZrHh1PmI5n2mVLKCMWR9Bcccu85GQR2ETfF97Mggr7Q1gvfJURf/vPyw==@kvack.org
X-Gm-Message-State: AFuF++lBBtyUwFticbMsR071XFD32FA+DD2XeCzTNdNaRBKmXrpDP4O8
	bWBRaZLIkcG7cQosK2ifoXITGkJe42tSHfS/CTPLmm2ZOEieJCpygGclIQwMbWaCLgINWIx6kU+
	4kEO9zw==
X-Received: from ejzq1.prod.google.com ([2002:a17:906:b281:b0:c12:5229:7355])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:f509:b0:c19:49ee:19b9
 with SMTP id a640c23a62f3a-c246a654f4emr3342635466b.15.1787585378467; Mon, 24
 Aug 2026 08:29:38 -0700 (PDT)
Date: Mon, 24 Aug 2026 15:29:30 +0000
In-Reply-To: <20260824152932.1583506-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20260615234220.3946885-1-lrizzo@google.com> <20260824152932.1583506-1-lrizzo@google.com>
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260824152932.1583506-4-lrizzo@google.com>
Subject: [PATCH v2 3/5] net/swiotlb: Track bounce device per socket
From: Luigi Rizzo <lrizzo@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <lrizzo@google.com>, 
	Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dragos Tatulea <dtatulea@nvidia.com>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, netdev@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, driver-core@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 28CF8A0009
X-Stat-Signature: p9k34pe5ysmigungeb41wpieoc79ssq4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787585380-703028
X-HE-Meta: U2FsdGVkX1+x0xo4nXP0VOJKLDHDGw7RgfnEU8miXvndQcUzFS8UA1WnQvkKyWc66xuNyQVAYYlV8OVfF7uEMyMgO3uX77cqxBzXmRExexRJtrkngtikNgt2SaKWUqfxrb35x4gWhqN1xUDps1NiuOdx8r+5ZeBYEURoPVW7fDznhzuAuMBmbyBsfX4IFVrlImnx+NZ5+ebCE7d55B1PtRVa9g1vZykFFoRb1DRWtZ9d1emSK31Exz+bvvvjlkKVI9mT55vsDr0RkMd0I/tsy/tmW3yhKDiVvpUB62hwxSYqemMUTug7N+WX3UBTDJMWYMI9WADD4NHnl9/E648DQyNuAOdlq332LlrRjU0DWezhX+YKuT3FD7HqXygrO5hTVul79S3if+ca/4PMDpENijYBrhWSmNK4EhCqc4S0Rbl9A7CJtM0Zv6Q6nLEVEuE1xbdb9pO3pd7kACi8iqJe2ErWTMH1auKYwdmSjop8ypNCWz+mckgJ/Jz8v1C89Ial7ug6oU2j4Lyghk2G08+rbReMvWVORoqoSteEeQPLO0ZqB1XA2QQk5qREHtG9C8KkN9bcwqJlVKWzqz55fpBGBE3mhEDr7yg+i+6Wyh35E2Vh1cHZGLBoCMH5Wh9q4x13VhcwhU0aqahcApu5koN01u87tVWjJWq5ewlP9UKrGF2b89If/TuLvZ3pJmX8ViEK47TuR8BNYtM0nKCUciKGKkeeky563MXSxcyRZFGSMsMnJtGPq5YKXfRO21weGRK2IwwrK0GHLRKudkl5nvEzrvHEcU29APzoWa4XSmEePzAry47daIe15Dcom5etYl1qoCcoEajORL1G0fUpAJO/xI8y2MOqL/K2YOHUjI/m9BQjoNbiZNVdZy+0Zvw/IYoBAVOYxZVpF3zyLT8chnUdMuoN9WNELQYqawYbhNr2Qe1uV/+yG6T4Ahk79OZ2us2eiIqNMgH6hfiUlBFv46w
 S4GtNI99
 D40jgAMN5CErSsKzLs4eS58OO4UuuiqXvcqcnVA1jP+1aBj4+JYgRWuNNuMjRk4g9QGmm/GfRV58kvq0lBqn0D2EaMPe+pQDzvMT3JuYTBuoCJuwHdp96LBSpgXUCSwEZMB0SthXiHYg1D7W/kywJ1dg0gO5zMX3fsoKXkUM2wk9DYXQXhtQABqKsn7leR2C+fS2f9HF4fSW7Oy74TwXe0MD0ZJI84AygC0OZi3xAjvV5LMgSDWdZu0Nr3TYFNmTwOJZwCktMJHGvFVdC3pVOu5kJLlM6sNMuUUa5tCpJWHKK1QLZTTRpDy4PiIUf+kzEIA8lBtmW5V+/c0Gu2q/ZPSkbUMAPkBQv1UUxcUoOXfhnT9A6vlKY043TOtd07ZCSrLaVYyWpI1vj8XJPexPwNxtxN8lXvocsbvSkKOE7yPrWyW/HsH3Ek1BiiImUEwIY+nCkZQh5UIMBdqCR1NQ7xpBN2IwN/XDMTBQhKz2p4HgEAqUg8Ucx1o4yabae2HvruK5zEkO/bvcG7rwPYXrF8QbDVRaLEcal0s6Q2FsF9SoTiZtd7roE7cXOlrNoIq0I2FIrqAxvdOrr1Dcvxow6QtEej/zy7I9AIp3UpZjhzd1spvgiXzDW5unYDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Record, on each network socket, the underlying hardware device that
requests DMA mapping of tx packets. This is used for nocopy confidential
computing, so that sockets can eventually allocate socket buffers directly
from the swiotlb pools.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/base/core.c       |  1 +
 include/linux/netdevice.h | 21 +++++++++++
 include/linux/swiotlb.h   | 36 +++++++++++++++++++
 include/net/sock.h        | 46 ++++++++++++++++++++++++
 kernel/dma/swiotlb.c      | 73 +++++++++++++++++++++++++++++++++++++++
 net/core/sock.c           | 39 +++++++++++++++++++++
 6 files changed, 216 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4c0c373998a19..091062228740d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3925,6 +3925,7 @@ void device_del(struct device *dev)
 	unsigned int noio_flag;
 
 	device_lock(dev);
+	swiotlb_change_epoch();
 	kill_device(dev);
 	device_unlock(dev);
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 87cafc932e9e6..2457f4e464acf 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5429,13 +5429,34 @@ static inline netdev_tx_t __netdev_start_xmit(const struct net_device_ops *ops,
 	return ops->ndo_start_xmit(skb, dev);
 }
 
+struct sock;
+
+#if defined(CONFIG_SWIOTLB) && !defined(CONFIG_PREEMPT_RT)
+/* Per-CPU pointer to the socket currently performing transmission. Used
+ * to bridge the networking and DMA layers, allowing dma_map_page() to
+ * identify the socket originating the packet and apply SWIOTLB optimizations.
+ */
+DECLARE_PER_CPU(struct sock *, current_tx_socket);
+static inline struct sock *__save_current_tx_socket(struct sock *sk)
+{
+	struct sock *old_sk = this_cpu_read(current_tx_socket);
+
+	this_cpu_write(current_tx_socket, sk);
+	return old_sk;
+}
+#else
+static inline struct sock *__save_current_tx_socket(struct sock *sk) { return NULL; }
+#endif
+
 static inline netdev_tx_t netdev_start_xmit(struct sk_buff *skb, struct net_device *dev,
 					    struct netdev_queue *txq, bool more)
 {
+	struct sock *old_sk = __save_current_tx_socket(skb->sk);
 	const struct net_device_ops *ops = dev->netdev_ops;
 	netdev_tx_t rc;
 
 	rc = __netdev_start_xmit(ops, skb, dev, more);
+	__save_current_tx_socket(old_sk);
 	if (rc == NETDEV_TX_OK)
 		txq_trans_update(dev, txq);
 
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 4661e361c60e4..b1140db3cc397 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -202,6 +202,39 @@ void swiotlb_nocopy_inc_ref(struct io_tlb_pool *pool, phys_addr_t phys);
 void swiotlb_nocopy_dec_ref(struct io_tlb_pool *pool, phys_addr_t phys);
 void swiotlb_prep_compound_page(struct page *page, unsigned int order);
 void swiotlb_destroy_compound_page(struct page *page, unsigned int order);
+void swiotlb_safe_put_device(struct device *dev);
+
+/* Track epoch (number of delete operations) for leaf device info. */
+extern atomic_t global_device_epoch;
+
+static inline u32 swiotlb_dev_epoch(void)
+{
+	return atomic_read(&global_device_epoch);
+}
+
+static inline void swiotlb_change_epoch(void)
+{
+	atomic_inc(&global_device_epoch);
+}
+
+#if defined(CONFIG_NET) && !defined(CONFIG_PREEMPT_RT)
+/*
+ * Track the socket for the currently transmitted packet, so the dma mapping
+ * function can record there the leaf device if it needs bounce buffers.
+ */
+struct sock;
+DECLARE_PER_CPU(struct sock *, current_tx_socket);
+void sk_record_bounce_device(struct sock *sk, struct device *dev);
+static inline void dma_learn_bounce_device(struct device *dev)
+{
+	struct sock *sk = this_cpu_read(current_tx_socket);
+
+	if (sk)
+		sk_record_bounce_device(sk, dev);
+}
+#else
+static inline void dma_learn_bounce_device(struct device *dev) {}
+#endif
 void swiotlb_dev_init(struct device *dev);
 size_t swiotlb_max_mapping_size(struct device *dev);
 bool is_swiotlb_allocated(void);
@@ -258,6 +291,9 @@ static inline phys_addr_t default_swiotlb_limit(void)
 {
 	return 0;
 }
+static inline void swiotlb_safe_put_device(struct device *dev)
+{
+}
 #endif /* CONFIG_SWIOTLB */
 
 phys_addr_t swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t phys,
diff --git a/include/net/sock.h b/include/net/sock.h
index 51185222aac29..39b5e81c7cc55 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -47,6 +47,7 @@
 #include <linux/skbuff.h>	/* struct sk_buff */
 #include <linux/mm.h>
 #include <linux/security.h>
+#include <linux/swiotlb.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/page_counter.h>
@@ -70,6 +71,14 @@
 #include <net/l3mdev.h>
 #include <uapi/linux/socket.h>
 
+#if defined(CONFIG_SWIOTLB) && !defined(CONFIG_PREEMPT_RT)
+struct sk_swiotlb_info {
+	struct device __rcu	*dev;
+	u32			epoch;
+	unsigned long		jiffies;
+};
+#endif
+
 /*
  * This structure really needs to be cleaned up.
  * Most of it is for TCP, and not used by any of
@@ -602,8 +611,45 @@ struct sock {
 #if IS_ENABLED(CONFIG_PROVE_LOCKING) && IS_ENABLED(CONFIG_MODULES)
 	struct module		*sk_owner;
 #endif
+#if defined(CONFIG_SWIOTLB) && !defined(CONFIG_PREEMPT_RT)
+	struct sk_swiotlb_info	sk_swiotlb;
+#endif
 };
 
+#if defined(CONFIG_SWIOTLB) && !defined(CONFIG_PREEMPT_RT)
+/*
+ * Clear bounce device on newly initialized or cloned sockets.
+ * Note: During socket cloning, sock_copy() performs a raw bitwise copy of
+ * the parent socket without incrementing the device refcount via get_device().
+ * Therefore, we must zero sk_swiotlb.dev directly here without putting a
+ * reference. References are acquired solely by sk_record_bounce_device() and
+ * released in sk_release_bounce_device().
+ */
+static inline void sk_clear_bounce_device(struct sock *sk)
+{
+	rcu_assign_pointer(sk->sk_swiotlb.dev, NULL);
+}
+
+/*
+ * Release any device reference acquired via sk_record_bounce_device() during
+ * socket transmission and clear the device pointer. Called during socket
+ * destruction (__sk_destruct).
+ */
+static inline void sk_release_bounce_device(struct sock *sk)
+{
+	struct device *dev;
+
+	dev = rcu_dereference_raw(sk->sk_swiotlb.dev);
+	if (dev) {
+		swiotlb_safe_put_device(dev);
+		rcu_assign_pointer(sk->sk_swiotlb.dev, NULL);
+	}
+}
+#else
+static inline void sk_clear_bounce_device(struct sock *sk) {}
+static inline void sk_release_bounce_device(struct sock *sk) {}
+#endif
+
 struct sock_bh_locked {
 	struct sock *sock;
 	local_lock_t bh_lock;
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 6b86a1e955fb4..d4a07a7c570e1 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1683,6 +1683,8 @@ dma_addr_t swiotlb_map(struct device *dev, phys_addr_t paddr, size_t size,
 	phys_addr_t swiotlb_addr;
 	dma_addr_t dma_addr;
 
+	dma_learn_bounce_device(dev);
+
 	trace_swiotlb_bounced(dev, phys_to_dma(dev, paddr), size);
 
 	swiotlb_addr = swiotlb_tbl_map_single(dev, paddr, size, 0, dir, attrs);
@@ -2085,3 +2087,74 @@ bool swiotlb_pool_is_nocopy(struct io_tlb_pool *pool, phys_addr_t paddr)
 	return pool->slots[index].flags & SWIOTLB_SLOT_NOCOPY;
 }
 EXPORT_SYMBOL_GPL(swiotlb_pool_is_nocopy);
+
+/*
+ * Dropping the reference to sk_swiotlb.dev must be done in two steps:
+ *
+ * 1. Readers inspect the pointer inside RCU critical sections without
+ *    acquiring a reference. Use call_rcu() to wait for an RCU grace period
+ *    to elapse so lockless in-flight readers finish accessing the device.
+ *
+ * 2. The RCU callback executes in atomic softirq context, but put_device()
+ *    can block when releasing a device. Use schedule_work() to transition
+ *    to sleepable process context where calling put_device() is safe.
+ */
+struct swiotlb_deferred_put {
+	struct rcu_head rcu;
+	struct work_struct work;
+	struct device *dev;
+};
+
+static void swiotlb_deferred_put_work(struct work_struct *work)
+{
+	struct swiotlb_deferred_put *dp = container_of(work, struct swiotlb_deferred_put, work);
+
+	/* Stage 2: Safely call put_device (can sleep) in process context */
+	put_device(dp->dev);
+	kfree(dp);
+}
+
+static void swiotlb_deferred_put_rcu(struct rcu_head *rcu)
+{
+	struct swiotlb_deferred_put *dp = container_of(rcu, struct swiotlb_deferred_put, rcu);
+
+	/* RCU grace period has passed. Queue the work to do the actual put */
+	schedule_work(&dp->work);
+}
+
+/**
+ * swiotlb_safe_put_device() - Safely release device reference from atomic/interrupt context
+ * @dev: The device structure to release.
+ *
+ * Enqueues a deferred put_device() call on a workqueue using GFP_ATOMIC.
+ * If memory allocation fails, the reference is leaked to avoid an immediate crash.
+ */
+void swiotlb_safe_put_device(struct device *dev)
+{
+	struct swiotlb_deferred_put *dp;
+
+	if (!dev)
+		return;
+
+	/* Lockless fast-path: if we are not the last reference, decrement is safe */
+	if (refcount_dec_not_one(&dev->kobj.kref.refcount))
+		return;
+
+	/*
+	 * On the last reference we must defer the final put_device() to task
+	 * context because it will trigger device_release() which can sleep.
+	 */
+	dp = kmalloc_obj(*dp, GFP_ATOMIC);
+	if (dp) {
+		INIT_WORK(&dp->work, swiotlb_deferred_put_work);
+		dp->dev = dev;
+		/* Stage 1: Wait for RCU readers to finish */
+		call_rcu(&dp->rcu, swiotlb_deferred_put_rcu);
+	} else {
+		pr_warn_ratelimited("swiotlb: failed to allocate deferred put, leaking device ref\n");
+	}
+}
+EXPORT_SYMBOL_GPL(swiotlb_safe_put_device);
+
+atomic_t global_device_epoch = ATOMIC_INIT(1);
+EXPORT_SYMBOL(global_device_epoch);
diff --git a/net/core/sock.c b/net/core/sock.c
index 1ad41904db25b..ca3e08d3de141 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -103,6 +103,8 @@
 #include <linux/sockios.h>
 #include <linux/net.h>
 #include <linux/mm.h>
+#include <linux/swiotlb.h>
+#include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/poll.h>
@@ -152,6 +154,41 @@
 
 #include "dev.h"
 
+#if defined(CONFIG_SWIOTLB) && !defined(CONFIG_PREEMPT_RT)
+
+DEFINE_PER_CPU(struct sock *, current_tx_socket);
+EXPORT_PER_CPU_SYMBOL(current_tx_socket);
+
+void sk_record_bounce_device(struct sock *sk, struct device *dev)
+{
+	struct device *old_dev;
+
+	if (in_hardirq() || !sk_fullsock(sk) || sock_flag(sk, SOCK_ZEROCOPY))
+		return;
+
+	old_dev = rcu_dereference_protected(sk->sk_swiotlb.dev, 1);
+
+	if (dev != old_dev) {
+		/* Rate-limit updates to once per second to prevent bonding thrashing */
+		if (old_dev && time_before(jiffies, sk->sk_swiotlb.jiffies + HZ))
+			return;
+
+		get_device(dev);
+
+		/* Atomically swap in the new device and get the actual old one */
+		old_dev = (struct device *)xchg((struct device __force **)&sk->sk_swiotlb.dev,
+						(struct device __force *)dev);
+
+		WRITE_ONCE(sk->sk_swiotlb.epoch, swiotlb_dev_epoch());
+		sk->sk_swiotlb.jiffies = jiffies;
+
+		/* Only drop the reference to the device we actually replaced */
+		if (old_dev)
+			swiotlb_safe_put_device(old_dev);
+	}
+}
+EXPORT_SYMBOL(sk_record_bounce_device);
+#endif
 static DEFINE_MUTEX(proto_list_mutex);
 static LIST_HEAD(proto_list);
 
@@ -2387,6 +2424,7 @@ static void __sk_destruct(struct rcu_head *head)
 		__netns_tracker_free(net, &sk->ns_tracker, false);
 		net_passive_dec(net);
 	}
+	sk_release_bounce_device(sk);
 	sk_prot_free(sk->sk_prot_creator, sk);
 }
 
@@ -2489,6 +2527,7 @@ struct sock *sk_clone(const struct sock *sk, const gfp_t priority,
 		goto out;
 
 	sock_copy(newsk, sk);
+	sk_clear_bounce_device(newsk);
 
 	newsk->sk_prot_creator = prot;
 #ifdef CONFIG_BPF_SYSCALL
-- 
2.55.0.766.g2966f0265a-goog


