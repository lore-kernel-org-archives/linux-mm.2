Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 973C2606AFC3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OT+8WvIY
Received: by kanga.kvack.org (Postfix)
	id 15E566B05C3; Mon,  9 Nov 2026 13:25:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F756B05C4; Mon,  9 Nov 2026 13:25:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB616B05C5; Mon,  9 Nov 2026 13:25:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0C456B05C3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:25:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4153CA04E0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:56 +0000 (UTC)
X-FDA: 85416409512.08.5408D36
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf12.hostedemail.com (Postfix) with ESMTP id 55E4940009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OT+8WvIY;
	spf=pass (imf12.hostedemail.com: domain of 3MBDyagYKCHcgmduujbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3MBDyagYKCHcgmduujbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248754;
	b=WzTjU9wt0Kx5cQI32My8IrZAOmOndflEL/eE8Zs9tN0NEsOyFv9IRuPvDIFA32wwSkdkYQ
	vPZ+Z2pIubQFw4jybpRcJwQ3NcF60u4r8HL1BCvEAWD2EXwj3K6Q/1ITG3u1qD6DpuGCQM
	VXZXrRBUmd3uqv7G9mKNAULrBG4AS1I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OT+8WvIY;
	spf=pass (imf12.hostedemail.com: domain of 3MBDyagYKCHcgmduujbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3MBDyagYKCHcgmduujbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gomwgjRp8gnNvcmuG0DoiSv5Tpyva0FtvGRYSv+rt0I=;
	b=Sn66kDXdg7EkxlMQVnAsF+a8otPYo0x0kFeEdtnTaAB6Vj4+aOY/VxH32aYBJ0R7KKB/pX
	74aFwmmXuh7w+V0/fuOjt7m6DJ/SVIZji3pg0W4GmKqrjUyjQqY8s/hJD+FIiVuQiil7e9
	93GC4BdRmMjjKgUeJGNWawrFpdDtJ/8=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c4cd91204f4so96195066b.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248753; x=1794853553; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gomwgjRp8gnNvcmuG0DoiSv5Tpyva0FtvGRYSv+rt0I=;
        b=OT+8WvIYby5Dn7mxMwHelGdsYOvmBQjLsQkZgQ60GyeOrMuSEiC2d1jyAVGrklqqpm
         Cpo2mEgT+x+3ITbdhZxuNriExh24g4s6hWEfktScEY4e/WxcmUJuo5PhO3BCg3BNJPjO
         WYljFgD8Lj8BaDKeKulhi+m1KlOEz6yZG3ig+2+uKTGQjH45zh20KmAIp0x3TCtzDvyi
         Jls/41+ziWeDwfk8i9GCdgLuxcF6ke/F/0shMZNvfMkXqJKIJLEjM/nbxgtM/X2G/IPS
         gkn0dShcicV0X6rdkjnTCEgWb4avM6D8Do7GZe8gsErYhWbaki8W116y8KFNDjRGZJrZ
         apCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248753; x=1794853553;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gomwgjRp8gnNvcmuG0DoiSv5Tpyva0FtvGRYSv+rt0I=;
        b=uxyAhsmPuZ6J9T++MGTvAzKY3tDfSy1r5Bj6WZPGcTdMy8NBiIZzlUtVfD0/K+1uYe
         ytQCObqpdQ5EoOpmSq0JcJ1pzFjBygZKLdRV5v5CzX5LsZMTExWo5+hnfnhwjtqY2Pgh
         wq7z9q1F6MWufXarxhZDeeyzP+H5ibv1NsErFY9OWOIl4uloIFjjGnD3UttjcHin5Rv5
         mWc5fqAICcENwqJDoEl26Ci7XFd7ppg0WT9EPj/QNQJWMlytvUr7ntmDM2SupGN/qBuP
         sBECsjbXlhxGx0ITAmqPrzxyoqSHIODWAInrAsDvb9CadVYABVTEBfsO54maY50yVsnA
         cHrw==
X-Forwarded-Encrypted: i=1; AL+hErFIcefZ5tIpxN9aF+JaAhBHHcnEgxAxPWe0pDY7SQWXX5so3h/L9UT4yLU42NB71ZDwpTzj0PXHdA==@kvack.org
X-Gm-Message-State: APuU4Z+PBJYT0L1xTJThxF0HNNBju2N7vFH6LBS1b6qVgwpABUcv+O9G
	n+QGGVGh8+pq1tsx727fcMdg0wEaudkbDwkMfyoA7ycMrsVwUE/Z3V/Ey3rArLjSqi00vwzWbBD
	+WqmL7A==
X-Received: from ejpg23.prod.google.com ([2002:a17:906:7c57:b0:c3f:d175:ee6a])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3e20:b0:c41:64c1:cc2d
 with SMTP id a640c23a62f3a-c50491bd62emr17871766b.2.1794248752661; Mon, 09
 Nov 2026 10:25:52 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:24 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-17-lrizzo@google.com>
Subject: [RFC PATCH v2 16/25] mm/slub: Add SLAB_CACHE_PISA_RO for PISA-backed
 slab caches
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
X-Stat-Signature: xxj79wedm51je1g7guywa3onbarc1ozi
X-Rspamd-Queue-Id: 55E4940009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794248754-399399
X-HE-Meta: U2FsdGVkX195UYGJRjKzYnibzPLQsXC3vZG9Oqxdml5lrHd3auaZGycnrFl8WhjwHQf/zEINpjzxm4JvSjvIySEpuhghLvtwXxT8KRSkZtSmsffmV8Sxo2H4tVKTlPNIpzUVvVnh2pR5eW+mWn+dAdgpVmwmgiXHNEhDEgBHxWh/749W3C2/OLvu2NmGeNF+Afgkq1PimbZll13fkVa99vd9pZLTlcucqQl8ZQV3chRh9IyxQ/wl0HGxX0Aa1LP2sQtun0SSXrjjUCkKOab0mcq1rvksj+yJXHyjKra5d/NhtbLjNsviUFaoBTRuFiVMk8WhtGAlFlkzH7n3zDISfOp0saRcIi04kTjb3DRwUwMnuo9VI/TZxXj+GkGqDvrzWjXIqxUCDlGWmhJzTwO0ECn6PvKQiBKusp/Tq2ZvFmUuYXRNWFIn+V6HSjYNUu45uVJKWQUi6DH3IGLvjXtkH54pT/FQP8hVJq8Vio7f0I0eKTO0SnQBdsQdA8koU2aXxW+9l3rpm3x4ozXJdOQ0JEjEM+npsItJZJ5sUnXb3G7aDWDyHXNf64zGDJsXZTBb6E6PR5v9imeWZhqCbzpewKhIu4NNm8BCr+Equ15uaF012ftKAKt1wTNM1wStn1QxooXULX9WD/P9N0EwE/z97MroITeuHBhcfp/8EhvM3KKH03syKN+01dG1rWSx6zLIaCE93pFnnRnY/x1ebdQnmKzs2rIPXcJlybARXqk2zRT13jo8RYBxFAcQG4ftx5ULCShwTb5h2U8q1IYNOyF2ei0E/BC1wIjI4mKoOOaIztuF7n3JjPQZdB+dGR/IVDyZb3KXqfoyXgFVzEzMQ+vJb4U0zK8hcm70UF80y5Cvrw2+Fizpu+1l1jl468stVRc4PZ0iiO8XtYcTxCPWS3oHzFfh/8I7ODWimUzqO4Ug2/OSMqrl1rO/4suQMnAEd+9K1+PeLz4K4EZwu3PJnqM
 EQcH+Hfm
 FNoL4pD9mZ8ElM7YQWmZrcx8vLppOnMLssLvYq7O/PZfDXQs5YBoDdVrB8HriaUUe8J8QFHAJ+i3TyeGHBRL0JvuOgJZ4rZKlkUXoxsOk/jL7tA9bWkwb6FsAy4+tPjA/YLmvSCzdE5pdyGlTtakGrUQZEtga86lnUSlT7K4jY3dRiFwsshSIMrQbqJto6iUgo3lXt268GEdDeu0iPkMHOcSHgn9h6cdpnbwOdC+P6lEnJZSvb/PHVJSxSuZttWAUBHhoZMh53M5C7SFij2JCeJjUIJTWPdoSmi1BJh/zLk5A7liCBBL3DjdCRPGyCWfMI0eyfSHS51zaixLJiN6yR/1+iTU1rUbpA5tBDNDQMTQc5m4R9fQF/T2mCFIIfMl6/b4PZP86FrBv6NSs6BesDa6df7g01npAkkML7okV31pHJE79RsuBzLZYYhfG+LwmZXkjzK/2KIVyRxSXom1vU8I1u66BD8ajSTWtExKTcgEsEfST8Cj2qEJjov2LJllvxAvcAq4uSu/h+AIta1n9x7n78M2qjq8AHucLDnkZ2zFfAAZzaE1qwbIZCBQZKT1cHT4eWfOHOWVC/Zzy6xk39v+o+6ZcPskGSZss9G57QGESQ4bNrCR6ixuH7tqha+jxcc2ZnAs0Bk61JWbbr23fKXlgUngOBg6K297N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

skb heads are provided by a slab allocator that is fed by alloc_pages().

Add SLAB_CACHE_PISA_RO so that a slab cache can back its slabs with
zeroed, read-only PISA folios (__GFP_PISA_RO | __GFP_ZERO) via
pisa_alloc_folio(), clamping the slab order to
[2, PAGE_ALLOC_COSTLY_ORDER].
Slabs are still released with free_frozen_pages(), so pages from PISA
return to their allocator via __free_pages_prepare(). Caches with
SLAB_CACHE_PISA_RO skip KFENCE and are never merged.

Existing caches are unaffected.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/pisa-alloc.c | 27 +++++++++++++++++++++++++++
 drivers/iommu/pisa-kunit.c | 19 +++++++++++++++++++
 include/linux/pisa.h       |  7 +++++++
 include/linux/slab.h       | 10 ++++++++++
 mm/slab.h                  |  3 ++-
 mm/slab_common.c           |  5 ++++-
 mm/slub.c                  | 14 +++++++++++++-
 7 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
index 4b61ec84ed6d1..3b5c49d143a7e 100644
--- a/drivers/iommu/pisa-alloc.c
+++ b/drivers/iommu/pisa-alloc.c
@@ -848,6 +848,33 @@ unsigned long pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order, int preferred
 	return pisa_alloc_bulk(pa, gfp & ~__GFP_PISA_RW, nr_pages, page_array, frozen);
 }
 
+/**
+ * pisa_alloc_folio - Allocate a frozen folio for SLUB (SLAB_CACHE_PISA_RO)
+ * @gfp: GFP flags (must have __GFP_PISA_RW or __GFP_PISA_RO set)
+ * @order: Folio order
+ * @nid: Target NUMA node (or NUMA_NO_NODE)
+ *
+ * Drops __GFP_THISNODE before calling the per-node allocator and verifies
+ * node placement afterwards.
+ *
+ * Return: Frozen folio of @order, or NULL.
+ */
+struct folio *pisa_alloc_folio(gfp_t gfp, unsigned int order, int nid)
+{
+	struct page *page;
+
+	page = pisa_alloc_pages(gfp & ~__GFP_THISNODE, order, nid, NULL);
+	if (!page)
+		return NULL;
+	if (unlikely((gfp & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
+		     page_to_nid(page) != nid)) {
+		page_ref_unfreeze(page, 1);
+		__free_pages(page, order);
+		return NULL;
+	}
+	return page_folio(page);
+}
+
 /**
  * pisa_has_free_blocks_rx - Check if @dev has free PISA RX blocks of @order on @nid
  * @dev: Device to check
diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
index 40bf7801183da..9cc1328893ace 100644
--- a/drivers/iommu/pisa-kunit.c
+++ b/drivers/iommu/pisa-kunit.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/shrinker.h>
 #include <linux/skbuff.h>
+#include <linux/slab.h>
 #include <net/sock.h>
 
 #include "dma-iommu.h"
@@ -621,6 +622,23 @@ static void test_reservoir_and_scrubber(struct kunit *test)
 	WRITE_ONCE(pisa_scrub_max, old_scrub);
 }
 
+static void test_slub_page_alloc(struct kunit *test)
+{
+	struct kmem_cache *s;
+	void *obj;
+
+	s = kmem_cache_create("pisa_kunit_slab", 1024, NULL,
+			      SLAB_NO_MERGE | SLAB_CACHE_PISA_RO);
+	KUNIT_ASSERT_NOT_NULL(test, s);
+
+	obj = kmem_cache_alloc(s, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, obj);
+	KUNIT_EXPECT_TRUE(test, is_pisa_page(virt_to_page(obj)));
+	kmem_cache_free(s, obj);
+
+	kmem_cache_destroy(s);
+}
+
 static struct kunit_case pisa_meta_test_cases[] = {
 	KUNIT_CASE(test_meta_init_and_roundtrip),
 	KUNIT_CASE(test_meta_invalid_phys),
@@ -635,6 +653,7 @@ static struct kunit_case pisa_meta_test_cases[] = {
 	KUNIT_CASE(test_pcp_cache),
 	KUNIT_CASE(test_gfp_pisa),
 	KUNIT_CASE(test_reservoir_and_scrubber),
+	KUNIT_CASE(test_slub_page_alloc),
 	{}
 };
 
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index 89eb0722d90bc..b9c5197f2d88d 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -110,6 +110,7 @@ unsigned long pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order,
 				    int nr_pages, struct page **page_array,
 				    bool frozen);
 
+struct folio *pisa_alloc_folio(gfp_t gfp, unsigned int order, int nid);
 bool pisa_has_free_blocks_rx(const struct device *dev, unsigned int order, int nid);
 bool pisa_page_can_recycle(const struct page *page);
 
@@ -181,6 +182,12 @@ pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order, int preferred_nid,
 	return 0;
 }
 
+static inline struct folio *
+pisa_alloc_folio(gfp_t gfp, unsigned int order, int nid)
+{
+	return NULL;
+}
+
 static inline gfp_t pisa_rx_gfp(const struct device *dev)
 {
 	return 0;
diff --git a/include/linux/slab.h b/include/linux/slab.h
index cda126def67af..df19c5898e9fe 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -66,6 +66,9 @@ enum _slab_flag_bits {
 #endif
 #endif
 	_SLAB_NO_SHEAVES,
+#ifdef CONFIG_PISA
+	_SLAB_CACHE_PISA_RO,
+#endif
 	_SLAB_FLAGS_LAST_BIT
 };
 
@@ -260,6 +263,13 @@ enum _slab_flag_bits {
 #define SLAB_OBJ_EXT_IN_OBJ	__SLAB_FLAG_UNUSED
 #endif
 
+/* Back slabs with zeroed read-only PISA folios (__GFP_PISA_RO | __GFP_ZERO) */
+#ifdef CONFIG_PISA
+#define SLAB_CACHE_PISA_RO	__SLAB_FLAG_BIT(_SLAB_CACHE_PISA_RO)
+#else
+#define SLAB_CACHE_PISA_RO	__SLAB_FLAG_UNUSED
+#endif
+
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
  *
diff --git a/mm/slab.h b/mm/slab.h
index e94ac63d10dc0..53620e40b216b 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -473,7 +473,8 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
 			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
 			 SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
 			 SLAB_TEMPORARY | SLAB_ACCOUNT | \
-			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE)
+			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE | \
+			 SLAB_CACHE_PISA_RO)
 
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
 			  SLAB_TRACE | SLAB_CONSISTENCY_CHECKS)
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 01c64ef661e7f..d6c00047b1623 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -49,7 +49,7 @@ struct kmem_cache *kmem_cache;
  */
 #define SLAB_NEVER_MERGE (SLAB_DEBUG_FLAGS | SLAB_TYPESAFE_BY_RCU | \
 		SLAB_NOLEAKTRACE | SLAB_FAILSLAB | SLAB_NO_MERGE | \
-		SLAB_OBJ_EXT_IN_OBJ)
+		SLAB_OBJ_EXT_IN_OBJ | SLAB_CACHE_PISA_RO)
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT)
@@ -377,6 +377,9 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 	if (s)
 		goto out_unlock;
 
+	if (flags & SLAB_CACHE_PISA_RO)
+		flags |= SLAB_SKIP_KFENCE;
+
 	cache_name = kstrdup_const(name, GFP_KERNEL);
 	if (!cache_name) {
 		err = -ENOMEM;
diff --git a/mm/slub.c b/mm/slub.c
index 45e077c7526c2..63609768f4e3f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -46,6 +46,7 @@
 #include <linux/prandom.h>
 #include <kunit/test.h>
 #include <kunit/test-bug.h>
+#include <linux/pisa.h>
 #include <linux/sort.h>
 #include <linux/irq_work.h>
 #include <linux/kprobes.h>
@@ -3378,6 +3379,8 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
 	if (unlikely(!allow_spin))
 		page = alloc_frozen_pages_nolock(0/* __GFP_COMP is implied */,
 								  node, order);
+	else if (unlikely(flags & __GFP_PISA_RO))
+		page = (struct page *)pisa_alloc_folio(flags, order, node);
 	else if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages(flags, order);
 	else
@@ -3484,7 +3487,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
 	gfp_t alloc_gfp;
 	void *start;
 
-	flags &= gfp_allowed_mask;
+	flags &= gfp_allowed_mask & ~__GFP_PISA_RW;
 
 	flags |= s->allocflags;
 
@@ -3495,9 +3498,13 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
 	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY) & ~__GFP_NOFAIL;
 	if ((alloc_gfp & __GFP_DIRECT_RECLAIM) && oo_order(oo) > oo_order(s->min))
 		alloc_gfp = (alloc_gfp | __GFP_NOMEMALLOC) & ~__GFP_RECLAIM;
+	if (unlikely(s->flags & SLAB_CACHE_PISA_RO))
+		alloc_gfp = (flags | __GFP_NOWARN) & ~__GFP_NOFAIL;
 
 	slab = alloc_slab_page(alloc_gfp, node, oo, allow_spin);
 	if (unlikely(!slab)) {
+		if (s->flags & SLAB_CACHE_PISA_RO)
+			return NULL;
 		oo = s->min;
 		alloc_gfp = flags;
 		/*
@@ -8182,6 +8189,11 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 	if (s->flags & SLAB_RECLAIM_ACCOUNT)
 		s->allocflags |= __GFP_RECLAIMABLE;
 
+	if (s->flags & SLAB_CACHE_PISA_RO) {
+		s->allocflags |= __GFP_PISA_RO | __GFP_ZERO;
+		order = clamp_t(unsigned int, order, 2, PAGE_ALLOC_COSTLY_ORDER);
+	}
+
 	/*
 	 * For kmalloc caches we enable sheaves later by
 	 * bootstrap_kmalloc_sheaves() to avoid recursion.
-- 
2.56.0.542.g3ef89b7020-goog


