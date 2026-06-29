Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFCE1C44500
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9045D6B00F7; Mon, 29 Jun 2026 09:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D456B00FA; Mon, 29 Jun 2026 09:12:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E37F6B00F7; Mon, 29 Jun 2026 09:12:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1746B00F7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8AD3A0691
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:37 +0000 (UTC)
X-FDA: 84932989554.21.4D8A452
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id E261A20002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ZpbpCD/d";
	spf=pass (imf13.hostedemail.com: domain of 3Qm9CaggKCIMqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3Qm9CaggKCIMqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738755;
	b=ZyHMznh7QUr0zxEpt44nSkrZNxpOkBY+kc/VBN1wMswh9IV9Sqi7/IhjKsAP9a7zgBZLIZ
	SF+phvhRzZmi3RUfIfZtg3rVkcjdSiehSvfDbFQUxzrgmLM40zy1dmBpyDEHa8uFUnRmDp
	7vm/NN1twfykli/ZS6ebI1GdJpNwKAc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JBAu5z1qpXLt1yVYTZOb/NZ4VE3m9FIqmIALTgVK9u0=;
	b=XNC9WQZP62pXWOnzF94bGwT3uyiNcEPUFEqK/FZKPjTATf20LkvxQPtqqxso6i+oFEjU1L
	i/G6RPhw9n9HVaFrBhydTnGEAFuuLNhQq98t4f8F5AEoshCxrdElviDdq8k6Bm70RRgvnZ
	h17aAu0a8QfDPW8P55jaEUOtUBVpv3o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ZpbpCD/d";
	spf=pass (imf13.hostedemail.com: domain of 3Qm9CaggKCIMqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3Qm9CaggKCIMqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c1237547c18so227649566b.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738754; x=1783343554; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JBAu5z1qpXLt1yVYTZOb/NZ4VE3m9FIqmIALTgVK9u0=;
        b=ZpbpCD/db2oSLqYBaxDy5nsRxUrKmYsPV+vhDCogjHkXSyK//t/mnpZvi0jvrQgesQ
         UbUKYs/BApIKhMe+DPpEg03CU2JbljAqlwuvCWCXfiUP5UGOWIWtqYVLOJex0WJWmrbL
         SXv1+hfMjEXp/ZJNIdSKB+xwOpfOhx4Ae3Xw4lBHk8Zl9fRRcwEXnfM1exeIueGC5M6W
         fQSorXh6RE1bUCX7u2ucnLwvqyF5pgDN4UpDoxBU0L0eYwQJKlDUNQAv/hBRu2qe2T3y
         ZwngeW8IwqLJyc7tfYH614FM2sHRHfgmf2Bk9Zic0ZW/t3wqpW9Rb3hAVzixYKbrcIUk
         tKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738754; x=1783343554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JBAu5z1qpXLt1yVYTZOb/NZ4VE3m9FIqmIALTgVK9u0=;
        b=Vvcz/cCdDqk3Q3Jpu4YuGZKW7wALVPvbCHdYmDvCOZtXWTEfUhINjXE3kzCV80NhQB
         XOkjz+hfvsJWezVGn0BcAkFubfDdaZk/63Zg9ugDDMmwQe3x9+Lg9oRGVQXBdUsv4iNe
         OqDDIJ5N7sX01IW8kaoAG8QqrgKj0TmbVYx99saQrh6M7NWuoO5xAEVac9LjfZUCOlSr
         ROZ/h2OBAiXcfZ6PM7wFHi8KssUMLz7EgicmzkcV7EzBbWWLWcBoMujJ+14pvbtyIgrT
         8Q6cBWC+Py7PdsSWnuWXZada1+Vzc6IkAFqoH3y/FBZo71litxiIf5Fc24JQ0X8p6F6K
         C2aw==
X-Forwarded-Encrypted: i=1; AHgh+Ro0UQRKvfFnv7+5HBeoVoxD0JjkEl7cgNvVzdHZ3TClVyX2gnvAxz6uDqgO3v046Gi4o9GcJ5QTjQ==@kvack.org
X-Gm-Message-State: AOJu0YwIk2MSoUA6sD/xY3yvOUsPqHn9JUoNdLvHCH7JAdUKuJZ8aoKc
	v5T9h79DdTdPyrC5icquZngppSmRD9vwHnXl/INvZCWU66VZmIJJgevKQ+EGCtBC7Cn8Vn80w/t
	m1MTvE5PgRWSN3Q==
X-Received: from ejdn16.prod.google.com ([2002:a17:906:1650:b0:c12:6c81:a8ab])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c00b:b0:c12:80f5:d841 with SMTP id a640c23a62f3a-c1280f5df41mr35865866b.56.1782738754134;
 Mon, 29 Jun 2026 06:12:34 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:12:03 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-14-57bef0eadbc2@google.com>
Subject: [PATCH v3 14/16] mm: Move __alloc_pages() to mm/page_alloc.h
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
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E261A20002
X-Stat-Signature: 9tbgrds6usbrkmuf598xm9jd958mx6is
X-HE-Tag: 1782738755-627982
X-HE-Meta: U2FsdGVkX1/kWep9KC5ST0PiR0grOxJNtoJbcuwGk/0KYhsX4uxKPZNfjfMlbYE8PWwdCC2SagcHM9R8MN+42+H+8O41g2EAGhICXhCFr8gMu9OSLJpjL4Ehi91QBZsPwuIKiQabSr2j3qzHbqfipepReMZ4ND0BSi+vdmqI6FHsGcH2m+gt79NJn2W+Q9kfCPgI0N4PLsU3ende1EcMeQgrUxsY0OXRsN7h2V9hj7ajQsEt9HY4JOMO54doU0mizWLkQpdoDLkqeJ3DnJOvwK+GEagT598WrniQe1fQPimFE9ZxchDe6pd4aW6qRjkI9dfDmQuNuU+Dd9yU8D94g0TMVL6qHe8GA0h4M7XRif++P6DZqVL2NhRAJHJ6vCxA434ZUN5lY+p0TLCw4ZBeWpYzZrXkmqr8MjqfDOEDJY/mvpxtH+s9m4bXGJOCYLbVijk7iIQBmRtUZHq+egk5F47glJj9I3nlH7pzI+LUoU0mpT1IVVQM3SbiRwAY9/37SKwcSovsUB9gpujJCDBeUwemwWg8T/h2UVokpt0vYpIkPELrerLMD/UgRdaBGBF8aI1e6noZFPhrk8EkS3N8/Z6Ocfj+daPk4h/69rNKpI092bSws35CbRkWMH0z+SsXUmhTbstCL4BfAQCs+ojFe7UmBj4i1bkvPMNiRwR0x9Yn+HPCuu1gNLY04iBhybVlG8VKe4FEfovaGtXnSYkm+SyPmUq12E6ZZY6rqJ9s6XzGQkM0bu594Cn6wlvan7NCF/fMA6Y9c1c9LYdqirrnSZPd+s1CuhFKAIDubwUZEHc7omhZobcQkYTrLn6mHpYUBHtcY7dWG8knBPhLIcgn9mvyH/KJ1obTExT1JFT+tbH1Zv5PEnfl5ae2ERnD4Xnd7ozpz5t5LqRplDFLJ+z1bQeyIgIqCNqkt8ZGM0MIyKdCfUAONxrzv6k6ZCt3cx7idRuRSzRoxuFARk8LjDn
 Vp51tFQA
 SZnUB9LcxwvSBNb1msl7kA7TatB+2ttOXOUqjI7bhEwdCjnAvy8IpniYynVEWfrqly0KJvBBS5mFh5IRbUX0vyxIaUKhwvqVYHbZIjpD4tWjAYcg1MOOxRYN4D4ME1G5NbU/DffIEwl2YZNb1uXrj0PCtjGGCgj5wPxjoVD01bIpRJV7io/ceTafgYwV7EffIAEhdl+08drGeISjKlogTyB40J3tKPDTwNOMicl6BggvF9ifrRRQBgy0R9r6sfq+uQwn+Z/pty2KrXsgBucP3efyVS1xWEn46w0cdOBvp3EUExR34EolQ9aCUXH1afC55rQpj+dZBhYPdH67HHLk0+S/tuMOVbQyXhhEiMSHV/ql3UZGBKl5h28A+57NEQ4Iy7Ag5K8mZUWNpCNSKqtfWWP9/WnFYE4wbCwjJ+Pp//m+Zp9Mwt3whqFNEYn2ul7okgUO0ynzvAJ1WBYkD3NjyBo0BPoO2Jh4IQEyU4/J37YGGOtoTWd0Bt9zyCvt2mCQbuJ1DJwaL1PCk94Gi/5F1IsT+xBhl+nBVqWt7MH6/pCjFxZUGE92hCArcYbwxfzhImGEyqYVpO8HeOXAlFUCDX1fbPYbpGNPDt3e6bErxk0IPFbLQLAPq2L4+lrp1I7SK674FjWD/8FMQkWgyVyw1AZkoEWUJr4NGPR+Mn56kgPq7gr34QGdtnmRx+w==
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
index 9cb3f1665b41b..026f33f217036 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5427,7 +5427,18 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
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
index af83764788b96..2058cbdca56e7 100644
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


