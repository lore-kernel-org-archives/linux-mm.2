Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C992E606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=l78LEh9L
Received: by kanga.kvack.org (Postfix)
	id 66B736B0726; Thu, 19 Nov 2026 20:07:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643806B0727; Thu, 19 Nov 2026 20:07:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531DD6B0729; Thu, 19 Nov 2026 20:07:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DFCD6B0726
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:07:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87BBF1C481F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:18 +0000 (UTC)
X-FDA: 85453708956.16.F5AA236
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf23.hostedemail.com (Postfix) with ESMTP id BE8D614000E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=l78LEh9L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3Q53_agYKCNoHNEVVKCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--lrizzo.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3Q53_agYKCNoHNEVVKCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795136836;
	b=Ey3hPHK4BWfBXY5IMzEzbZsDELSS3YirFayE+7wWtlrBRV2N8gfQBr63btreW+jNPlXoHS
	4KMTf5WmsNPUb+PlWMkT3ECYmDZeDIg3X8wCBUaFqYoYPGgO8d5uQ5Rz/ICPhmWrfOj0j8
	odc9vGDrTxbFFmjEp4+RiNBRt4wFRDo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FkHIJ0AqEEou0V4yLcGWQGEIWwBaAdh9SIA/wm+Eg+o=;
	b=8Itqx0xVfGMCrt/bXThuONJ/KK2qh1AC/e6DRvg930B26cH2NhUhA7INXudwTbqC9ZoOFt
	hh6dtgp22Bwsl23g6bRci8y3A/g3F95x8IWLnQ1FWVhw8stO3LTQXcS7r5RrHY2fTMM8ti
	xnBSC54xxa26PavBgcTopbElkPy9O8E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=l78LEh9L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3Q53_agYKCNoHNEVVKCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--lrizzo.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3Q53_agYKCNoHNEVVKCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--lrizzo.bounces.google.com
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4994d67d0e3so1376445e9.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136835; x=1795741635; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FkHIJ0AqEEou0V4yLcGWQGEIWwBaAdh9SIA/wm+Eg+o=;
        b=l78LEh9LFsYIq8R+VMQPtN49TFm1mbvbC1rg544FCgQ5Gtd6LY9xiXoS4MQC1aFQBU
         jixNZxZwaArErKgy2IxvhV2IGCfrhllFxiQ0rI9c1unu8/eOjVmzIcEjDQA1MFf005LT
         vm9Zr5YolJYg34DMEiuGI9ocen6YHqtcbiLO6pMKc9Af8FNsvuKMtOZIPffxOSq9Tvz2
         H4p9ZH33gPLr1BAdOscWZvplXaO8nFdA3ae9ahDLtY6oXsVrpnZG0q00IFo+RT1eVGJg
         yii22SGt8fgjuMG4oyXAIaZcgYavDt5VX5d6lAaqgJh6ZbT4C+C497f0o2nqXNNxW2kH
         qX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136835; x=1795741635;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FkHIJ0AqEEou0V4yLcGWQGEIWwBaAdh9SIA/wm+Eg+o=;
        b=yVZFRIWLVoW0+l/BKUW86fWrsSLtL6qC2P/dtKHc4n1GRQ5KLGRMHgMxGHAdIIvONL
         auT/4lEBQ9md4OgTaOazrRbMbfNT855scrJl9hAF+skvfyusBmDSnakEwD+1/hZrnrvC
         5sKA20K1QrI2O5y5kz3k0eHZ86xknmXve0xaqGyt+SxTDG5CZTRU26rSidadWF6yEG3r
         6DNingAhqtmPe1LdwBOxQua6SOD9J5tPJrScFUbuxSZWEMbobfbiXkSwbJz5tcfEYHhJ
         RU7xeqEXk6yn/qNX1UhcjjDoPkq/yFLlc6ypRHukuwuim01ga8RWy1sto1wmEJXR+voF
         UC7Q==
X-Forwarded-Encrypted: i=1; AL+hErEzSvgtBfcY9Zw4tXdfqLCVLiqG4czk5+BvFyDvIPt8BKxR7eLFWim+E349Km/CGd83Ds3N/IwLbQ==@kvack.org
X-Gm-Message-State: APuU4Z8JRd2raFkSkdN3yp0lsqhMA1HY/gfgK3MgEct1xWnWpwkZjxRv
	SasYv6UokU9X8OqALYCT73k6Ss2OAfR0yJMXkQj5lVtfEfXTg0LWpwL+SHjUXWTj1Nv7EcbRS7v
	AFqQ5+g==
X-Received: from wmbh22.prod.google.com ([2002:a05:600c:a116:b0:4b6:5d12:e070])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a4b:b0:4a1:dade:f049
 with SMTP id 5b1f17b1804b1-4bb88806292mr26486795e9.15.1795136835025; Thu, 19
 Nov 2026 17:07:15 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:43 +0000
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-14-lrizzo@google.com>
Subject: [RFC PATCH v3 13/25] net: Cache leaf PISA TX flags on struct net_device
From: Luigi Rizzo <lrizzo@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, Dragos Tatulea <dtatulea@nvidia.com>, 
	Naman Gulati <namangulati@google.com>, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 85sa8f6zigtmg41k5b1e6e5ypq5suf1j
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BE8D614000E
X-HE-Tag: 1795136836-18356
X-HE-Meta: U2FsdGVkX1+PcPiOS8/lTqd/L4xHutWiOMMuu8fXJteB6Vp1UH8Mg8OqUKfKT0pq72Bwft3xLKIXvwzY1R8aP1mhklDtzuz6RQG3i88IljADsfF91i5DIWP0iyKFzcMqgHQ4blKQgZK7BczvoDui1qLlH2Y6RLbTg198Xy0Z7eT00ijrlDQiKJk10Z6eVBhIt8ARgd52mW+iLWrXdXuCuXfDyMMU6b8/vL8rw2ktwJabEgjdXbtUAnaTjxjK+Gv5mtau64lf8jrlhyH9FtBhXzepg1bJkJ+U69G9kEZwUNXrbBlG+kIH93bNzg015lPRthM54FI6OHIvj4m5PK1bkSoqVUI5O7AnIW3uYcEI4rzxrW9+2Z6qGFZE3RMNc4uyyXuk2WKOQX5MKiq+zNYlHACOCX87mjV41uOjF7MuNe9XfzP2deq0Q83f0qWcRDXoJ2gnu9TK/oXKytJCh6thsGlRTEyVj8RW3OchOdE79466Z+Sx4ga6xSkGbXA6doXy8bJOFv75Y6p8mkQrfe75cvKaMShaYJBJW/8JEG2wWEsYyfykshuWDdO9UsktbOkdkyraOul29p/LVt5Pfa04RTzZe3iSXO6pY3mMCLYKy2KUL/KhPgP5pT2HXKjjmkXAehvg+b0YGWQEPPwlY4JnuI4i+eSHPluvdKdPm3cbzKMw8vpye/vDeyuy55j6T08n+5hooJ14w0ONhhqPJ3s8DicgH1G/Z7B7OUSm6ZhIWY3fSx+hiDknMYhcXhjeCsID89jBj6sKch96XL1fzBGhHdaI9QjA0qsVt4lM8n/7hzFN4VaIxEjZFrkchvc6ErTxMyuVZfGa8fh2cJ4gvSo5dnOYdKzpayzyJt0bAfKgnaTnHVU5urt/aX3QzxgNGnfPb6LZjZV31bo5rq4tfJuOc6opKiEflnh847f0+wHvxMXzbqhf7atDCA4WG4NCSd7kUw/v0z1glt7kSGKLeh6
 HE7UDU88
 z1bzb84aNMC3DQjrMN1AdTuS+MnjsGpPLnCA9ADB9TkwPH+ioyLJVSKM9dFSiGa1l3J4i1zvmIcqX1ZRBpVf+ksfS9Z9i02R99dFLtcaacX0j0QAIf3EGM8187jcrwTZ8hUJeGXWrh/C4spKJT9juVqMmSk8uA24dkJp2BekjuSWKIpkb1fFre8WzzYPyocQXVwo+m8N7zC3XfYV4PYqnmCEZ9H3U0QKwQ/vxUsIuaPMrad6Rqr0TQmkt7wBe3E/dCBc6qlWM2i+KiFpghR3A1R/zDY/njwuYQpSBss9AhfRhPLs25hM/fduFlTjnT4YbHzZJ8y5Z/6DOu+cYz4w6gVvVjw72sFt4dhWl02VYjbLssKDqjT9fAaphiyqYkvJLuHSo+PZf6fNmU46XxLyog3Z+bZrQ+pJ2/XGctd01fpx/ZrVmA1qqWLQHaZBOGQboWQaFSNZB+HdiMDVyKNgylIawZqjkD+8YXjvgJkAga+wLNbpnyoq0+0oI3XhZwKRmavelQWTuWtukoPErKb+tG5ZqjluXAyNGIfVdama3BbNCvRyUy7CxLpeYHpSAbpyfKmU+6tiuKKQbvevlBolx56WmYH8iaQT1VVk0pAC/wRBRwfkqmw/WTpSjdxmLT7GCXIE/jaICpuSyXOJEptff/mAAKMvSJHji6YD8mHxwFPO0yIjHIA6W1Lj88pyWS6f6iaQuh2cjtQh/XAt6N2pniKECeluMrqftpqOsEX+kFyv29qLIivwiBpErjCwTTDxua8ZxW9hPksPVeZ6YYB2W1e9wnvUlwRWm5CXyr0U3GfCxZdSgzcTU1w6wFPImxPK5MwVP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The sysfs attributes pisa_tx_bufs and pisa_tx_skb_heads live on the
physical DMA parent (dev->dev.parent), whereas a socket route (dst->dev)
or skb->dev may point to an upper virtual net_device (bond, VLAN,
ipvlan, etc.). Walking lower devices via netdev_walk_all_lower_dev_rcu()
on every TX allocation would be too expensive.

Add dev->pisa_tx_flags_tstamp on struct net_device to cache the leaf device
PISA TX flags and refresh them at most once every 256 jiffies via
pisa_tx_flags_refresh(). Also add the net_pisa_tx_bufs_key static key
and helpers (use_pisa_tx_bufs(), pisa_tx_bufs_gfp()) for subsequent TX
buffer patches.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/base/core.c       |   6 ++-
 include/linux/device.h    |  11 ++++
 include/linux/netdevice.h |   4 ++
 include/net/pisa.h        |  81 +++++++++++++++++++++++++++++
 mm/pisa-kunit.c           |   3 +-
 net/core/Makefile         |   1 +
 net/core/pisa-net.c       | 104 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 207 insertions(+), 3 deletions(-)
 create mode 100644 include/net/pisa.h
 create mode 100644 net/core/pisa-net.c

diff --git a/drivers/base/core.c b/drivers/base/core.c
index df93b6b6e125e..5f1291e644c5e 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2950,7 +2950,7 @@ static DEVICE_ATTR_RW(name)
 
 PISA_BOOL_ATTR(pisa_coherent);
 PISA_BOOL_ATTR(pisa_rx_bufs);
-PISA_BOOL_ATTR(pisa_tx_bufs);
+PISA_SET_ATTR(pisa_tx_bufs, net_pisa_tx_bufs_set);
 PISA_BOOL_ATTR(pisa_tx_skb_heads);
 PISA_BOOL_ATTR(pisa_tx_zerocopy);
 
@@ -3111,8 +3111,10 @@ static void device_remove_attrs(struct device *dev)
 	const struct class *class = dev->class;
 	const struct device_type *type = dev->type;
 
-	if (IS_ENABLED(CONFIG_PISA) && dev->dma_mask)
+	if (IS_ENABLED(CONFIG_PISA) && dev->dma_mask) {
 		device_remove_group(dev, &dev_attr_pisa_group);
+		net_pisa_tx_bufs_set(dev, false);
+	}
 
 	if (dev->physical_location) {
 		device_remove_group(dev, &dev_attr_physical_location_group);
diff --git a/include/linux/device.h b/include/linux/device.h
index e705df38e49af..0d867d8255ba5 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -817,6 +817,17 @@ struct device {
 	DECLARE_BITMAP(flags, DEV_FLAG_COUNT);
 };
 
+#if defined(CONFIG_NET) && defined(CONFIG_PISA)
+int net_pisa_tx_bufs_set(struct device *dev, bool val);
+#else
+/* Without CONFIG_NET the flag still gates block-device writes (see pisa_bdev_enabled()). */
+static inline int net_pisa_tx_bufs_set(struct device *dev, bool val)
+{
+	WRITE_ONCE(dev->pisa_tx_bufs, val);
+	return 0;
+}
+#endif
+
 #define __create_dev_flag_accessors(accessor_name, flag_name) \
 static inline bool dev_##accessor_name(const struct device *dev) \
 { \
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 435be7880d7e5..f973faba4402c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2161,6 +2161,7 @@ enum netdev_reg_state {
  *	@neighbours:	List heads pointing to this device's neighbours'
  *			dev_list, one per address-family.
  *	@hwprov: Tracks which PTP performs hardware packet time stamping.
+ *	@pisa_tx_flags_tstamp: Cached leaf pisa flags and timestamp.
  *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
@@ -2276,6 +2277,9 @@ struct net_device {
 	} adj_list;
 
 	/* Read-mostly cache-line for fast-path access */
+#ifdef CONFIG_PISA
+	u32			pisa_tx_flags_tstamp;
+#endif
 	xdp_features_t		xdp_features;
 	const struct xdp_metadata_ops *xdp_metadata_ops;
 	const struct xsk_tx_metadata_ops *xsk_tx_metadata_ops;
diff --git a/include/net/pisa.h b/include/net/pisa.h
new file mode 100644
index 0000000000000..1f95e67e99bf8
--- /dev/null
+++ b/include/net/pisa.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* PISA hooks for the networking stack. */
+#ifndef _NET_PISA_H
+#define _NET_PISA_H
+
+#include <linux/pisa.h>
+#include <net/sock.h>
+
+/*
+ * struct net_device caches the PISA enable flags for tx_bufs and tx_heads used
+ * by the leaf device, refreshed every 256 jiffies. The helpers below decide
+ * whether to use PISA memory for a given dst, sk, skb.
+ */
+#ifdef CONFIG_PISA
+
+enum pisa_tx_flags {
+	PISA_TX_FLAG_BUFS	= BIT(0),
+	PISA_TX_XFRM_OK		= BIT(2),
+	PISA_TX_TSTAMP_MASK	= ~0xffU,
+};
+
+/*
+ * Static keys guarding networking hooks:
+ * - @net_pisa_tx_bufs_key: enabled while any device has pisa_tx_bufs set.
+ */
+DECLARE_STATIC_KEY_FALSE(net_pisa_tx_bufs_key);
+
+u32 pisa_tx_flags_refresh(struct net_device *dev, u32 now);
+
+/*
+ * May TX data routed through @dst use PISA pages? Those pages stay readable by
+ * every device that mapped them for as long as they are active, so only data
+ * that leaves the host in clear qualifies: IPsec payload before encryption has
+ * dst_xfrm(dst) != NULL and is rejected unless PISA_TX_XFRM_OK is set.
+ */
+static inline gfp_t __pisa_tx_gfp(const struct dst_entry *dst,
+				  enum pisa_tx_flags flag)
+{
+	const struct net_device *dev;
+	u32 stamp, now;
+
+	guard(rcu)();
+	if (!dst || (dst_xfrm(dst) && !(flag & PISA_TX_XFRM_OK)))
+		return 0;
+	dev = dst_dev_rcu(dst);
+	if (!dev)
+		return 0;
+	stamp = READ_ONCE(dev->pisa_tx_flags_tstamp);
+	now = (u32)jiffies & PISA_TX_TSTAMP_MASK;
+	if (unlikely((stamp & PISA_TX_TSTAMP_MASK) != now))
+		stamp = pisa_tx_flags_refresh((struct net_device *)dev, now);
+	return (stamp & flag) ? __GFP_PISA : 0;
+}
+
+/*
+ * ============================================================================
+ * Networking hooks (every hook starts inline with a static-key check)
+ * ============================================================================
+ */
+
+/* Hook for route-based TX payload fragment selection (@net_pisa_tx_bufs_key). */
+static inline bool use_pisa_tx_bufs(const struct dst_entry *dst)
+{
+	return static_branch_unlikely(&net_pisa_tx_bufs_key) &&
+	       __pisa_tx_gfp(dst, PISA_TX_FLAG_BUFS);
+}
+
+/* Hook for ESP output skb_page_frag_refill() (@net_pisa_tx_bufs_key). */
+static inline gfp_t pisa_tx_bufs_gfp(const struct sk_buff *skb)
+{
+	return static_branch_unlikely(&net_pisa_tx_bufs_key) ?
+	       __pisa_tx_gfp(skb_dst(skb), PISA_TX_FLAG_BUFS | PISA_TX_XFRM_OK) : 0;
+}
+
+#else /* !CONFIG_PISA */
+
+static inline bool use_pisa_tx_bufs(const struct dst_entry *dst) { return false; }
+static inline gfp_t pisa_tx_bufs_gfp(const struct sk_buff *skb) { return 0; }
+
+#endif /* CONFIG_PISA */
+#endif /* _NET_PISA_H */
diff --git a/mm/pisa-kunit.c b/mm/pisa-kunit.c
index 4effbc8610079..d7670c76e98c5 100644
--- a/mm/pisa-kunit.c
+++ b/mm/pisa-kunit.c
@@ -578,7 +578,8 @@ static void test_dev_pisa_attrs(struct kunit *test)
 	kunit_check_pisa_attr(test, dev, "pisa_coherent", &dev->pisa_coherent);
 	kunit_check_pisa_attr(test, dev, "pisa_rx_bufs", &dev->pisa_rx_bufs);
 	kunit_check_pisa_attr(test, dev, "pisa_tx_zerocopy", &dev->pisa_tx_zerocopy);
-	kunit_check_pisa_attr(test, dev, "pisa_tx_bufs", &dev->pisa_tx_bufs);
+	if (IS_ENABLED(CONFIG_NET))
+		kunit_check_pisa_attr(test, dev, "pisa_tx_bufs", &dev->pisa_tx_bufs);
 	kunit_check_pisa_attr(test, dev, "pisa_tx_skb_heads", &dev->pisa_tx_skb_heads);
 	device_unregister(dev);
 }
diff --git a/net/core/Makefile b/net/core/Makefile
index c20e520358b8e..3c84358d6b0c0 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -52,3 +52,4 @@ obj-$(CONFIG_NET_TEST) += net_test.o
 obj-$(CONFIG_NET_DEVMEM) += devmem.o
 obj-$(CONFIG_DEBUG_NET) += lock_debug.o
 obj-$(CONFIG_FAIL_SKB_REALLOC) += skb_fault_injection.o
+obj-$(CONFIG_PISA) += pisa-net.o
diff --git a/net/core/pisa-net.c b/net/core/pisa-net.c
new file mode 100644
index 0000000000000..6d4909c82070c
--- /dev/null
+++ b/net/core/pisa-net.c
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * PISA networking helpers: leaf device TX flag cache, small skb head slab
+ * cache, and MSG_ZEROCOPY user page upgrade.
+ * See Documentation/core-api/pisa.rst for the architecture overview.
+ */
+
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/mutex.h>
+#include <linux/netdevice.h>
+#include <linux/pisa.h>
+#include <net/pisa.h>
+
+/* Enabled while at least one device has pisa_tx_bufs set. */
+DEFINE_STATIC_KEY_FALSE(net_pisa_tx_bufs_key);
+EXPORT_SYMBOL(net_pisa_tx_bufs_key);
+
+int net_pisa_tx_bufs_set(struct device *dev, bool val)
+{
+	static DEFINE_MUTEX(lock);
+
+	guard(mutex)(&lock);
+	if (dev->pisa_tx_bufs != val) {
+		WRITE_ONCE(dev->pisa_tx_bufs, val);
+		if (val)
+			static_branch_inc(&net_pisa_tx_bufs_key);
+		else
+			static_branch_dec(&net_pisa_tx_bufs_key);
+	}
+	return 0;
+}
+
+/*
+ * The sysfs attribute pisa_tx_bufs lives on the device that does DMA: the
+ * closest ancestor of a leaf net_device that has a dma_mask (dev->dev.parent,
+ * or further up behind bus glue such as virtio). A socket route (dst->dev) may
+ * instead point to an upper virtual net_device (bond, VLAN, ipvlan, etc.),
+ * whose leaves are its lower devices. Walking lower devices via
+ * netdev_walk_all_lower_dev_rcu() on every TX allocation would be too
+ * expensive, so dev->pisa_tx_flags_tstamp caches the walk result on the net_device
+ * and refreshes it at most once every 256 jiffies:
+ *   bit 0 (PISA_TX_FLAG_BUFS):       pisa_tx_bufs enabled on lower device(s)
+ *   bits 31..8 (PISA_TX_TSTAMP_MASK):  upper 24 bits of (u32)jiffies
+ */
+static u32 pisa_tx_flags(const struct net_device *dev)
+{
+	const struct device *parent = dev->dev.parent;
+	u32 flags = 0;
+
+	while (parent && !parent->dma_mask)
+		parent = parent->parent;
+	if (parent && READ_ONCE(parent->pisa_tx_bufs))
+		flags |= PISA_TX_FLAG_BUFS;
+	return flags;
+}
+
+/* MACsec encrypts in software above its lower device: its cleartext must stay out of PISA. */
+static bool pisa_tx_dev_excluded(const struct net_device *dev)
+{
+	return netif_is_macsec(dev);
+}
+
+/* A leaf has no lower devices; what its parent device is does not matter. */
+static bool pisa_tx_dev_is_leaf(const struct net_device *dev)
+{
+	return list_empty(&dev->adj_list.lower);
+}
+
+/* Every leaf must have opted in; a leaf without a DMA device (veth, tun, ...) has not. */
+static int pisa_tx_flags_walk(struct net_device *dev, struct netdev_nested_priv *priv)
+{
+	uintptr_t flags = (uintptr_t)priv->data;
+
+	if (pisa_tx_dev_excluded(dev))
+		flags = BIT(2);
+	else if (pisa_tx_dev_is_leaf(dev))
+		flags = (flags & pisa_tx_flags(dev)) | BIT(2);
+	priv->data = (void *)flags;
+	return 0;
+}
+
+/* Slow path of __pisa_tx_gfp(): refresh dev->pisa_tx_flags_tstamp. */
+u32 pisa_tx_flags_refresh(struct net_device *dev, u32 now)
+{
+	if (pisa_tx_dev_excluded(dev)) {
+		/* No flags. */
+	} else if (pisa_tx_dev_is_leaf(dev)) {
+		now |= pisa_tx_flags(dev);
+	} else {
+		struct netdev_nested_priv priv = {
+			.data = (void *)(uintptr_t)PISA_TX_FLAG_BUFS,
+		};
+
+		rcu_read_lock();
+		netdev_walk_all_lower_dev_rcu(dev, pisa_tx_flags_walk, &priv);
+		rcu_read_unlock();
+		if ((uintptr_t)priv.data & BIT(2))
+			now |= (uintptr_t)priv.data & ~BIT(2);
+	}
+	WRITE_ONCE(dev->pisa_tx_flags_tstamp, now);
+	return now;
+}
+EXPORT_SYMBOL(pisa_tx_flags_refresh);
-- 
2.56.1.809.ga0b61035b5-goog


