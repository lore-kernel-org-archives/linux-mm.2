Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00104C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 21:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D376B0096; Wed, 16 Sep 2026 17:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEDFE6B0098; Wed, 16 Sep 2026 17:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDCC56B0099; Wed, 16 Sep 2026 17:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A7DFF6B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:06:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18377C0159
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:06:01 +0000 (UTC)
X-FDA: 85220857722.26.5644FFC
Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2ECB32000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:05:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=njg6yNGN;
	spf=pass (imf31.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789592759;
	b=WkyqHkN7mrQ+LpyH/IpUwPpbYIKC4mTrcDxliuVrJWPOBQDZ66K+aaWG3leMYosMt38aPF
	sJYg7rpVWX92t9W6jiTynN8YVqW05OBXHffBTD4jI+4E6UIB4t1YaFpBLBKvJdxXcI1Fd9
	rUCf+Ub6pTvxbLc7KL4sr0HaAhdLsJA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=njg6yNGN;
	spf=pass (imf31.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789592759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpeT7E+4SgQjmsGt8zdgsDPzGh6zBoDDRVsBk7NbP6k=;
	b=SOkandpTwrq7FXR8FmZ1XszkNa5rHq3MXbW++QxfPtsMfrpc1X2PVQvbf0xwIqXvzxxyUc
	vWdiYCxgehfD9/DjbGCGXDiPyGLdpJ4LfbpFKP5YueCUY7V09hh59CCrZChU9dQrcw2O9J
	JbmLqT+Liq74dWM4gVkqL0d79nWkwL4=
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4b37a3688a2so164655b6e.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789592758; x=1790197558; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OpeT7E+4SgQjmsGt8zdgsDPzGh6zBoDDRVsBk7NbP6k=;
        b=njg6yNGNb1GnTlFumFdkCBrB65CiohcVsQucDOsShm1zJ7EYxtmkUYl7KAoRn4PDOf
         qPaadgbMSMOYFlwn6zbwKtF7fGcwS5hnDlQRwQ08jOnrcpX59kpnoOsJR438lU8ctxfA
         vZ9rXe0iKBw/5oLBExZlf6E/MNzyq4OAENteQq9wfbSVuUyfIv2dP8zc9iVMOyvsL3jw
         DDq+DJZIInBGU4gvaDSIxql1e12mpfo31nj0eF2L6FXHf8yWED+UQuJKlz4HXF+4oEaa
         H4/0jJyLQZFeJMAubSoshtL7KTXzdX+6X2Mt1VO40ESMzMaxF1yruvQOCU7aIPd1vclb
         ShCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789592758; x=1790197558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OpeT7E+4SgQjmsGt8zdgsDPzGh6zBoDDRVsBk7NbP6k=;
        b=L3noLL8vDKSNiKJWcSahS9BXI5EQpC7WVP7f46pqT3Qa9gHMlPrbeXptzu3LKsqUwW
         CXwQYdbEgbSzvkeGyj69Dz4OOdPkHIcqlcOJTC5afvDTt76WS8wykCB7lquZJp2kVLJ5
         PxwzMcUB5TLbpe0t1RcmF/BcVHwONfTOv4s/T9UCD6ZXUU6oIanNkWsfeFhESqqoYz2w
         iLAzvvuShaHW80oviDxB0tX8akb/IW2fLUUwEOM2ZLKj5Ic9owy9GOc4VYmqLs7FFgvM
         78nKBTuNEVr2zLcQ5p2rmrmMy+hsJafmDKIsW92VdtzmKH86w6di8aJUiL65pw+D/Po/
         Ywyg==
X-Forwarded-Encrypted: i=1; AKwUvBxL6rc+5xMKIeig91CKg0qmOdl2AxQSDuMJDAu1d8wbUtyjwQ/8a/Syox3c3oheSiBdzdrxkixjew==@kvack.org
X-Gm-Message-State: AFuF++maL0GCTRHPul3yu1b6QeNv6JfZLdM+UKiXnUNbpnDWCuxH+I6j
	tSWkhIVJqUuOTF3sGf0bA2gLW28ol9yZ3evRWOFg71oqg2shHZ0gKYJc
X-Gm-Gg: AYBFou3lYZouA4SRyaYOFLCBiNfBuYqjizUig6h8ifCP+zNalS94ZRGLkgNL2Orv52e
	l/D66o3fuik+FdT+SlwRVgwWCT4xs5S201Fqi9Znl6pkibZoPQxexJ9D7KTDjnes2hE+mdJ/8xF
	BXEDKhArXYD53evajHE76jc254+l4r8FLWDEk3knUMOsEZGAtBcKqYdSyPfKMzDeHsuOvh5oejf
	GqvhADRpU1EbGBNQajs/Mblxt+R9QYb93XRxOzqrZRaOeRZvkeBZ/kM4aZLMnQu+UTZ3pPhua6s
	yFdE27DMKvRvaoC1bxYXiar7A4pStonTzX3uXMCOwgS2S7yB9dvzi+bKPzH+/PpmsSgL8FhI4er
	5fsoNBW6koLoKlPc36Dcr2V6KCT5uyArjCyH3eIEwy5lkfXtPmdGDF2geIkuA5BM6V1iwOkJE9q
	0rzLXzqVCCCNQndEaG55dz++O6k1HCTeqa0z8zL/yP6mrjtF0+XqIXUcTa7NJOlsLdi61Bda9zo
	M5/Vr9I3U2dPeVlMAv/laqrG6ztyA==
X-Received: by 2002:a05:6808:1921:b0:4b9:a8ac:480 with SMTP id 5614622812f47-4ca4c6bab9emr5238137b6e.30.1789592758099;
        Wed, 16 Sep 2026 14:05:58 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:51::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4cb6d796b64sm891175b6e.15.2026.09.16.14.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:05:57 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v6 2/5] mm/page_counter: introduce per-CPU stock
Date: Wed, 16 Sep 2026 14:05:48 -0700
Message-ID: <20260916210552.891730-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
References: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2ECB32000B
X-Rspam-User: 
X-Stat-Signature: 15fastpz5ny8kkq5r9sdoy14qwmgfnw3
X-HE-Tag: 1789592759-653864
X-HE-Meta: U2FsdGVkX1/4cSsPMdVZbOnTugxvyW6MX+CkvOF9VhB9fK0o1Y6iURUpmMmdVh259471oQpjfRei13E7l8kNStcrh4GPtHf2C29xKILKpuE7uctTxaDDiKXxJ8oyTCjtkMUFL8sCpD/8vt8iCd9EpdrJLPXWdfo6FQunA8uovG7aD32UDe9R2wRTbQ1bn99w7ly8EI7Mh5YOYinnA+WvhJD8C6W7DzgB0wd1q3GUjbv99xgFXCPngJ/zfHgvT2DE7Z3p88CAluXbjXz4xxNkcoDqeKwdgByvQ/OfCaCS4TQZ+SN8hahK55BnRa2Jsj+RArtjs5PkwJvfPHUFsVj0Qb9oXiporaY9a6BgF2X3gO9bgPBwxuctoSx78mAVh6eL6b+H3ta5aa6ydyg5unbEiacxPAy4kE0H2iSG3ADxKsgzd3I90+vV4MjfjM86PRgA+k/gmOpNSxGnxD3bWUlPXPs8R97kN8TGKR1LybWkTkIEWOH7P4qiF3A/A5KeGKMsyxbt7im+S4f5R/QdIBD9OBihxuvTwdo6dV91XY2QVToi6cIHU3otP722AdsGkPNsWC5XtEH6/xKXIx4z2Rao6xiHdidcJEWPB67ss9TDriRGLp8hdY/XAwpet7jbKZA3qLIYJPZplBMDP3U0iZL9YMV/bn2p79jG88kdX1lVP7RGVsq3j7NQvlLZXpTEzMMWE26aaMrT1GvIr8Gs0kd8rNgBctEdi89S3MgUFrwFSwsNxRzcWV9BERRXHnaQTB9bYuRkWNVEvqTAmx4WwdQkRRRphaziN6eyPUVDKu8tDVkpVQJM/ORU7kkAJaRmWzv0+uLzPz8Ff5tGd+Vz8QPKI4zf9Vh9RN9R4uPQFBJSNqmPjRcXsbVFX+FcSA7kYxUAhIe4RGcxS4tuJ+Ay7+Cl82ei0gx3rwk7zD121ban4vhmAjnDBkukeZ/env3J7IQzrJW0kro+HpntRPKya/n
 tstCnRXL
 ljFxOuWY6MoDuZxpZfRqEVEl2OiwgsTGOYSBBquXAlzJ7gEiytHGT3UKfxPbkUilpTWeLRVTUQcTwjrRgME1vVKHWxP2kmaFQli5bDd+pVX7uTfnpGLphLfPwY3Cd9J2sUaPC9VzlMxU+EK9b8xDTrS9oFDgoq0Lkh+LqvqNyw85VRvgVK3IVQL67uji4YNQ6ej4+IH1odGDK0SM7M/EpHYydXmYwSd1kEZfmz0dcdBYrou1pmf+Lg6augM1Nu7ulxY/IBaXEdrXVxhKIL/Xf5zISkR8GVH5RTCotnL7YFOoCE8u7LOiSjGtcrdq0Mbj1KTIO/nVU/u0ugYE6PUrXyzfaV/JPqD8nhb7IwSEpl1dmBQrwMPdjoX761JnQngUrZ/9pG/4VyU5J+tKWCcFAGNMt1zrILgPIFjVq/Qnk9AmbSvJV5xvxfuLHpXqC5PywZa7HKHtLA7OmlPK3IM/sW5lMQWn5lZ9Wkj7qLugecT27KvFasjkx/RDC9nhZTdOJISLrwo5UGpjG7CsIwowD/frsXxzXQ3xhFIQokBWO9pcHSlHKCoyIzLla+BRQp9idF0Dpl8KNo2gBj5Un8a/ZgyN1vqUG+lrsuYGksXkopLrSM8Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a copy of the seven-slot per-CPU stock representation from
memcg in the page_counter layer. struct page_counter_stock_pcp preserves
everything from struct memcg_stock_pcp, but adds a new backpointer to
the base of the percpu stock, since there will be multiple percpu stock
base pointers later in the series (one for memory, one for memsw).

struct page_counter also gets a pointer to the base of the percpu stock,
as well as a struct cgroup_subsys_state pointer to pin its owning CSS
as long as the cached counter remains reachable.

Let's also copy over the drain, refill, and "flush required" functions,
preserving all behaviors from the memcg equivalent. In this patch they
are not connected.

No functional changes intended.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  31 +++++++++
 mm/page_counter.c            | 127 +++++++++++++++++++++++++++++++++++
 2 files changed, 158 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 07b7cb12249c7..9cb5612fe190f 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -5,8 +5,30 @@
 #include <linux/atomic.h>
 #include <linux/cache.h>
 #include <linux/limits.h>
+#include <linux/percpu.h>
+#include <linux/local_lock.h>
+#include <linux/workqueue_types.h>
 #include <asm/page.h>
 
+/*
+ * The value of NR_PAGE_COUNTER_STOCK is selected to keep the cached counters
+ * and their nr_pages in a single cacheline. This may change in the future.
+ */
+#define NR_PAGE_COUNTER_STOCK 7
+#define PAGE_COUNTER_STOCK_BATCH 64UL
+struct cgroup_subsys_state;
+struct page_counter;
+struct page_counter_stock_pcp {
+	local_trylock_t lock;
+	u8 nr_pages[NR_PAGE_COUNTER_STOCK];
+	struct page_counter *cached[NR_PAGE_COUNTER_STOCK];
+
+	struct page_counter_stock_pcp __percpu *base;
+	struct work_struct work;
+	unsigned long flags;
+	u8 drain_idx;
+};
+
 struct page_counter {
 	/*
 	 * Make sure 'usage' does not share cacheline with any other field in
@@ -41,6 +63,8 @@ struct page_counter {
 	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;
+	struct page_counter_stock_pcp __percpu *stock;
+	struct cgroup_subsys_state *stock_css;
 } ____cacheline_internodealigned_in_smp;
 
 #if BITS_PER_LONG == 32
@@ -61,6 +85,8 @@ static inline void page_counter_init(struct page_counter *counter,
 	counter->parent = parent;
 	counter->protection_support = protection_support;
 	counter->track_failcnt = false;
+	counter->stock = NULL;
+	counter->stock_css = NULL;
 }
 
 static inline unsigned long page_counter_read(struct page_counter *counter)
@@ -74,6 +100,11 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
 			     unsigned long nr_pages,
 			     struct page_counter **fail);
+void page_counter_refill_stock(struct page_counter *counter,
+			       unsigned long nr_pages);
+void page_counter_drain_stock_fully(struct page_counter_stock_pcp *stock);
+bool page_counter_stock_flush_required(struct page_counter_stock_pcp *stock,
+				       struct cgroup_subsys_state *root_css);
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 98322803941a7..480a447bd7265 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -7,6 +7,7 @@
 
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
+#include <linux/cgroup.h>
 #include <linux/kernel.h>
 #include <linux/math64.h>
 #include <linux/string.h>
@@ -14,6 +15,14 @@
 #include <linux/bug.h>
 #include <asm/page.h>
 
+/*
+ * Watermarks for a charge stock slot, in the spirit of pcp->high and
+ * pcp->batch: PAGE_COUNTER_STOCK_HIGH is the high watermark at which a slot is
+ * trimmed down to PAGE_COUNTER_STOCK_LOW rather than emptied.
+ */
+#define PAGE_COUNTER_STOCK_LOW (PAGE_COUNTER_STOCK_BATCH / 2)
+#define PAGE_COUNTER_STOCK_HIGH PAGE_COUNTER_STOCK_BATCH
+
 static bool track_protection(struct page_counter *c)
 {
 	return c->protection_support;
@@ -192,6 +201,124 @@ bool page_counter_try_charge(struct page_counter *counter,
 	return false;
 }
 
+static void page_counter_drain_stock(struct page_counter_stock_pcp *stock,
+				     int i)
+{
+	struct page_counter *counter = READ_ONCE(stock->cached[i]);
+	u8 nr_pages;
+
+	if (!counter)
+		return;
+
+	nr_pages = READ_ONCE(stock->nr_pages[i]);
+	if (nr_pages) {
+		page_counter_uncharge(counter, nr_pages);
+		WRITE_ONCE(stock->nr_pages[i], 0);
+	}
+	css_put(counter->stock_css);
+	WRITE_ONCE(stock->cached[i], NULL);
+}
+
+void page_counter_drain_stock_fully(struct page_counter_stock_pcp *stock)
+{
+	int i;
+
+	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++)
+		page_counter_drain_stock(stock, i);
+}
+
+bool page_counter_stock_flush_required(struct page_counter_stock_pcp *stock,
+				       struct cgroup_subsys_state *root_css)
+{
+	struct cgroup_subsys_state *css;
+	struct page_counter *counter;
+	bool flush = false;
+	int i;
+
+	rcu_read_lock();
+	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++) {
+		counter = READ_ONCE(stock->cached[i]);
+		if (!counter)
+			continue;
+		css = READ_ONCE(counter->stock_css);
+
+		if (READ_ONCE(stock->nr_pages[i]) &&
+		    cgroup_is_descendant(css->cgroup, root_css->cgroup)) {
+			flush = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return flush;
+}
+
+/**
+ * page_counter_refill_stock - return pages to a counter's stock
+ * @counter: counter to return pages to
+ * @nr_pages: number of pages to return
+ *
+ * If the stock cannot accept the pages, uncharge them from the hierarchy.
+ */
+void page_counter_refill_stock(struct page_counter *counter,
+			       unsigned long nr_pages)
+{
+	struct page_counter_stock_pcp __percpu *stock = counter->stock;
+	struct page_counter_stock_pcp *pcp_stock;
+	unsigned int stock_pages;
+	int empty_slot = -1;
+	int i;
+
+	/*
+	 * nr_pages[] is a u8 and a slot is capped at PAGE_COUNTER_STOCK_HIGH.
+	 * Raising PAGE_COUNTER_STOCK_BATCH beyond 127 would need careful
+	 * handling of nr_pages[] in struct page_counter_stock_pcp.
+	 */
+	BUILD_BUG_ON(PAGE_COUNTER_STOCK_BATCH > S8_MAX);
+	BUILD_BUG_ON(PAGE_COUNTER_STOCK_HIGH > U8_MAX);
+
+	if (!stock || nr_pages > PAGE_COUNTER_STOCK_BATCH ||
+	    !local_trylock(&stock->lock)) {
+		/*
+		 * For a larger-than-batch refill or an unlikely failure to lock
+		 * the per-CPU stock, uncharge the hierarchy directly.
+		 */
+		page_counter_uncharge(counter, nr_pages);
+		return;
+	}
+
+	pcp_stock = this_cpu_ptr(stock);
+	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++) {
+		struct page_counter *cached = READ_ONCE(pcp_stock->cached[i]);
+
+		if (!cached && empty_slot == -1)
+			empty_slot = i;
+		if (counter != cached)
+			continue;
+
+		stock_pages = READ_ONCE(pcp_stock->nr_pages[i]) + nr_pages;
+		if (stock_pages > PAGE_COUNTER_STOCK_HIGH) {
+			page_counter_uncharge(counter,
+					      stock_pages - PAGE_COUNTER_STOCK_LOW);
+			stock_pages = PAGE_COUNTER_STOCK_LOW;
+		}
+		WRITE_ONCE(pcp_stock->nr_pages[i], stock_pages);
+		local_unlock(&stock->lock);
+		return;
+	}
+
+	i = empty_slot;
+	if (i == -1) {
+		i = pcp_stock->drain_idx++;
+		if (pcp_stock->drain_idx == NR_PAGE_COUNTER_STOCK)
+			pcp_stock->drain_idx = 0;
+		page_counter_drain_stock(pcp_stock, i);
+	}
+	css_get(counter->stock_css);
+	WRITE_ONCE(pcp_stock->cached[i], counter);
+	WRITE_ONCE(pcp_stock->nr_pages[i], nr_pages);
+	local_unlock(&stock->lock);
+}
+
 /**
  * page_counter_uncharge - hierarchically uncharge pages
  * @counter: counter
-- 
2.53.0-Meta


