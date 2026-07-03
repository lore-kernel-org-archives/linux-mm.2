Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72CB8C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797926B00CB; Fri,  3 Jul 2026 08:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720FE6B00CC; Fri,  3 Jul 2026 08:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636AC6B00CD; Fri,  3 Jul 2026 08:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2FC6B00CB
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0F7FA04F9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:40 +0000 (UTC)
X-FDA: 84947404080.12.4957AE5
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id E46D71C0005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cuv9qoo0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 35atHaggKCLQdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=35atHaggKCLQdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081958;
	b=g56Z99a6DcgMQMdKHWxv8vwCk0dNAB0Sh0ykhKMYcvQerlnTaYWuCFdhBkd4xA/WcY71eh
	Dcmc+gZn45V0+D3LW347JDVs41nXVj79P6YGI6nbnRtO+e5NFabVq7GeG7DiP3U1SnU7bc
	NscL7gc3coHjnReqNum82w7EmrJPkfM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1tnwOMpS/BIg5QL0SfFSSGMbCh9S3UbjX7wTwpmbKGs=;
	b=ouqxALEhjTabtj6ZueaMtjy/K9oiTim4etrXEa1rxaGpmkqBH88HUs5h4Yna0CkHPeNnqK
	pzbq1FX9iH4Al5WXZjWR76CqddP7qrv2LKer9W4bgJ6MiAjDosTRH9oxwXC5fzJ5sJ8VFi
	OJDUZ/syJET4OygcUTSjbkv/yTbfs68=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cuv9qoo0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 35atHaggKCLQdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=35atHaggKCLQdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490c56e2576so4221265e9.3
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081958; x=1783686758; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1tnwOMpS/BIg5QL0SfFSSGMbCh9S3UbjX7wTwpmbKGs=;
        b=cuv9qoo0yILUe4gUvvUq2WCcC0WiSeqSC+4Jqc0SSEVSacGy38Nxe7LQ4pYCV6n7uv
         wmpKZw4UBnd5+DweEJEnCI1E22TIIXz0nYnoF2XAR3kYa/0BeNr/0ZIIjVrop29A26Hy
         k/08bOuAGni379nJfYj5i67ooMI3OYT0jygYNsg40F3+4NZfwnOGAckEl2D14Je8g4ia
         5x1J8zWd8CsqkaReXPA/R6eutitktLgO9kUXDmG7kgdyzDLQjRO3u5UNghT8HKxSmbO/
         SDQ8ytT0AfZIY/Wzy4/+DRZpVDZJbe1nqxkNNCYyCuQWu9eTNv08adKDu4iPmz+OffYC
         cYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081958; x=1783686758;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1tnwOMpS/BIg5QL0SfFSSGMbCh9S3UbjX7wTwpmbKGs=;
        b=ShqEWuTSbTW5YkbKjeAANr2Tt1iuxmjigzqBNKvFaw/4OjWr5VCkK5WxTyEnYhJXn2
         +sYgBqT1sYdHCs9BR8iMY2NuQ3WEN7m7dLFGQHCEX/I8cqyY4LOJ6xX+l2P5OKQT0RdU
         uiQHA3lG7QCU+x/sQUtoSifhH4E2OQGzymAViXBXMTlt5XQAAJMfzeQhxSQdNVTINw9O
         6X2YljGdXUjkOVYszvEb/x+4YcBI7qfU3T/fXP8ukiuCcLpUcW8hbySpOI2dQLoJD2tY
         y6aYW7dtHsJ1PRzw1yt+Q1nOzypJCOEye6K3/7HS5sOUiaOyJiLI+6fSbKx/lVPKZ/4s
         on0A==
X-Forwarded-Encrypted: i=1; AFNElJ+NY/Pj5dl/HfOtIZrjDDI7Wh0uyl8bmE5juset4UV54EcOoGpz7NjfqnejTJ26r1vdCZhCVhU/fg==@kvack.org
X-Gm-Message-State: AOJu0YxbNSWGxF/YlnfxAqkURn2PMBDzZiPCiXZpCHHmrFHKqqYb+Q+n
	y4d/zJXK0xvJ0vveBH7YLhH+7v3goTW+AAYcJNZOSTsjy8z5Unga0ALi059CIHleCtTZdRymAqk
	f3q/dI+boduXwlQ==
X-Received: from wrhm3.prod.google.com ([2002:a05:6000:1803:b0:46d:6fd3:e5e9])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:34c8:b0:493:c2e3:b2c1 with SMTP id 5b1f17b1804b1-493c3df75ebmr139076715e9.33.1783081957147;
 Fri, 03 Jul 2026 05:32:37 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:54 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-14-c87b714e19d3@google.com>
Subject: [PATCH v5 14/18] mm: Move __alloc_pages() to mm/page_alloc.h
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8onmsia6k38zzb9mehy6f9tjt7dg6ytg
X-Rspamd-Queue-Id: E46D71C0005
X-HE-Tag: 1783081958-485447
X-HE-Meta: U2FsdGVkX18xUX1wH7EH6N25UNqTX8PGa19gpv84zsYcrIT2GiqELi0cHSeN5QtdoOJtBs9ZbHIGYIT5tLmGnG76D57n9aM/N6Fa1KU8YFP9j1fxsuoX9sqwU7X8R5MG68vrs75IzsgmJJbgNoHggZwPkqilCK/RnKgOJGhbX6G1MCdCh8+wRC20UULcvaIY3jlem5h3Q422ZZMVJRUlkug65TuvDERhmCP9UDfhJPJIwFWa3L0U+mPI3HVBuI6bW5RYlk5uvEcknpu7TTT3U4hH3axJhTDu3uePEGeMZbanJTI38Wzlmd4cPGYjgoCR51YpwAR2kJJ4sgH2M8n6inkdXsi/ndVeVHhNLy51bQtRlnN7ZVTeV4vbuA/U+737WRyFrdXGtrR8HPMeQZV3y1aHMzEBAgNg8sE/RwSP9T3NlUKnGCspLU8leRPDjqundMs+XIhCKzw5Y4Ot41zSDduZHGNiRfTknTcGHzbDImX3CWVGUBKDgfj+ZwGEmdgElAssnU9nh3DFEn07LAwocV4TN4z2lhLjDBlQEiFgHyTUkMDEbKuMfO9UtmmcsdD1TyY16RfWuXVRcVzOjFVCnVwpT7JWFrqveVGchmbTYxILRJqWoBdFARToJUUt13EzmCiPXsJSaRLjRyPWuEKk/+S3V6pUc/vNjPps8gs6Rus5KY9aBHeNeYblMVy9yPHOEkgcZLl4Z9LqX7ORkyRujTPpIHpKPv2UafOlDj+p2rBKcpxx3cOrRa44qW2TEaZ4WIMuQVj6rcH6tLPjEjucsv42EsAoQQhNW6biJv/EA0UBTUq7iN9FVBKJnr3hFmaluzOhQ+2M0mP72SCUJ9e3Ulz9DvlnjUHwXk61eLyLl6LNDos5z7qdGOCu2dfN5GiBOTw7OsJkRQleIb3XOE4N+F2aCQVk4C245Cp4snA6QCymhciYEDuNqsFynrJmpvvrOrn6GSrdxIN8RX8/BJb
 GYecyvWf
 x1RByXYD/vj3qF5d8eof97xUHqNLSDb+mZdvV51h96V06zsj3uUbPElrO3jKVcd1HU0gE6d7t5CAPz9t8pb5Zt0P+D5ZlVcGdBTkvl+Jn00ttX0BFnnE+jSWTXsqd9WqmXhVQ+VNy701fse3XhJTMkNendjXD6h8jQHpdr0jM8lD0rUKEiOMc4oH0q9rCYcSABVewdOD+4pXxgjc+JcSYdnic6kDQCRa2j7iY2W0z7pNlHnCP5giXArBx+9Ekipe5cEPCOBLToyqgVCstf9yjiHsBZqyv17sYo5+YTJ5RRRGTTDJlRR3JFDKa1Pgg3aaDxK63SK7EpCKyZSMvAQI9n3kEj0aIQPQ/lXebkDVnLVeHttdEKyfjK0U6up3F5Bwb4MtJxXr6ZrYopObdevsFMQko8jHE9VndHukG0DR2PQk7nswMgDTgKAgNaJO60KOIFr0I+/R7VjcNz+DedlB4he01VaWa3JX8KMrVUtsFhUFD+tZ6Cj90BYRQpffCwQGV+qfe4ho/ZL5bGdZRSw4nhm23i7kd3wEPLhFbz8KO4bn75sFUIW2eTqXP7lfl3opDiVUt1OGVdtKVMh3Tnczb/tMXDfpNNCgzhoMJ8Ire4+VauedMNUfgVmljQUHPC1mN4CWZ2BjQ+nDXVGKVc9KpcAXBMfWK80NookQAzCpggT3RJs+ZyBXCjnmOCINeIs2Wjy8U1dDtXFVz66M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer used outside of mm/.

Since this means __alloc_pages_noprof() is no longer visible from gfp.h,
this also means moving the definition of alloc_pages_node_noprof into
the .c file.

Also remove references to this API from the documentation tree -
referring to the specific function name was already questionable but
now the function is not even public it definitely seems wrong.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 Documentation/admin-guide/cgroup-v1/cpusets.rst |  2 +-
 Documentation/admin-guide/mm/transhuge.rst      |  2 +-
 include/linux/gfp.h                             | 16 +---------------
 mm/page_alloc.c                                 | 13 ++++++++++++-
 mm/page_alloc.h                                 |  4 ++++
 5 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/cpusets.rst b/Documentation/admin-guide/cgroup-v1/cpusets.rst
index c7909e5ac1361..52a213aff04e5 100644
--- a/Documentation/admin-guide/cgroup-v1/cpusets.rst
+++ b/Documentation/admin-guide/cgroup-v1/cpusets.rst
@@ -284,7 +284,7 @@ take action.
 ==>
     Unless this feature is enabled by writing "1" to the special file
     /dev/cpuset/memory_pressure_enabled, the hook in the rebalance
-    code of __alloc_pages() for this metric reduces to simply noticing
+    code of the page allocator for this metric reduces to simply noticing
     that the cpuset_memory_pressure_enabled flag is zero.  So only
     systems that enable this feature will compute the metric.
 
diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 23f8d13c2629d..16f37135ed80d 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -761,7 +761,7 @@ compact_fail
 	but failed.
 
 It is possible to establish how long the stalls were using the function
-tracer to record how long was spent in __alloc_pages() and
+tracer to record how long was spent in the page allocator and
 using the mm_page_alloc tracepoint to identify which allocations were
 for huge pages.
 
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 3bf55a5f9143e..4d57e9c0bf204 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -204,10 +204,6 @@ static inline void arch_free_page(struct page *page, int order) { }
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
-struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask);
-#define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
-
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask);
 #define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
@@ -272,17 +268,7 @@ struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
  * prefer the current CPU's closest node. Otherwise node must be valid and
  * online.
  */
-static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
-						   unsigned int order)
-{
-	if (nid == NUMA_NO_NODE)
-		nid = numa_mem_id();
-
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
-	warn_if_node_offline(nid, gfp_mask);
-
-	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
-}
+struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order);
 
 #define  alloc_pages_node(...)			alloc_hooks(alloc_pages_node_noprof(__VA_ARGS__))
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c2839959d7908..f68b2b138a2e8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5431,7 +5431,18 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
 		set_page_refcounted(page);
 	return page;
 }
-EXPORT_SYMBOL(__alloc_pages_noprof);
+
+struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
+{
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+
+	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
+	warn_if_node_offline(nid, gfp_mask);
+
+	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
+}
+EXPORT_SYMBOL(alloc_pages_node_noprof);
 
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask)
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 2d60551b4453f..aa0c1481f7ca3 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -244,6 +244,10 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	alloc_hooks(alloc_frozen_pages_nolock_noprof(__VA_ARGS__))
 void free_frozen_pages_nolock(struct page *page, unsigned int order);
 
+struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
+		nodemask_t *nodemask);
+#define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
+
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);

-- 
2.54.0


