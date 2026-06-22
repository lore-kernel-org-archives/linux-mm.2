Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FC4CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E1D6B009F; Mon, 22 Jun 2026 06:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2369C6B00A0; Mon, 22 Jun 2026 06:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172B26B00A1; Mon, 22 Jun 2026 06:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C482D6B009F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:02:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CE72140621
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:02:01 +0000 (UTC)
X-FDA: 84907107642.28.511B228
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4DCAB18000B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vejfnWyB;
	spf=pass (imf16.hostedemail.com: domain of 3FQg5aggKCGIJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3FQg5aggKCGIJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MsOFaY28yUvKoPbHZxbuYx2M7iMWmO856P7+eBzy0OY=;
	b=OJS8eTYTDBqibuj1xIY1A00KXEFMnRfR1fhIn3hzJeaoSDIzDV/4kozHKrzM6twRJIS3PL
	01EGqMDsXmskMPdX62Kn0gkqIbasN0U6q1Scg0g/UhBUspF6+PvKR6ippLFxOOkk8F/Gnk
	/wEzZMRNc6HhUtzA/s7mQbzOcqTwfhc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122519;
	b=Khf/uDDp0fgTzWkAI6WXme3GwSDuGFvWHpTYrfzDeXubzSWQ2b8OIGEcH1SvvN/P5LghlV
	qFuSpZyB2FTO1gsW/NV4SQoZJM65wJuZA1fCSMhyhFbmzonhmWScyyDmfW9iutPE68WeEd
	V3gUf9aCR22pGyEpmoAT/PwmtnKf1EQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vejfnWyB;
	spf=pass (imf16.hostedemail.com: domain of 3FQg5aggKCGIJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3FQg5aggKCGIJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b0682d2fso31491355e9.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782122518; x=1782727318; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MsOFaY28yUvKoPbHZxbuYx2M7iMWmO856P7+eBzy0OY=;
        b=vejfnWyBPYcQS6V7i/eI5V8/GmogD5YWf9zqh3fHi9zG0tISoQU5cdkwh9LLIjx+/X
         1BsaSygxNhTqlfS/EUO1jH1EywjA2Nec7l5KX1O1ZVWDPu9pOGB5VzD/tVmSJY+o5Xzb
         y9GBKJHdRQCXE0s4Lg7JTv+fdboKKv6SafR6mzxmewNPn1Ah7iyNJ2Ig8MKr0NU+yzQo
         wYGhK2Z9vBQd/gfE+W5Gb+CaMEB46Pw3TEUg0DvHTQ73MnUDQLSphkchvWP8t1AT7MRj
         nFRPc3B+GvgLODcc34grco5mC8MtlKuysGdlnW+o92FN/oJS9afiADCcMuT8zLjyxhUH
         Z8Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122518; x=1782727318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MsOFaY28yUvKoPbHZxbuYx2M7iMWmO856P7+eBzy0OY=;
        b=PG9/K2HXW2elcwrfD6DuJghWJw38ol4m4AwmnQ059qfw0wKjmup9u+kOzA574oQBHd
         V4FY12ry0Zj0F3VrwX6qdkvQKrw+g5mUI5QnlMtzCp86JPJRjnZJDxBDxa1vFOBjYC2F
         2OGr9Lr7PXlxrm9aJzVc+1gr7+zEfF4ATyBke2rophmGxwlnSmjRDZkG3F0nuu+IcNND
         oEnTAxQYA4Zr4jCgnZglVWCHZS18MNJdsWv9t9LoqDHpEJ6Kw5Q9uqHjbK70/Q3tSP/P
         9xyPc/InsGjCOE8pT3qETLYdSFIM4D8TlAccPpOuEMaNuYJZjMDWZdcPNL2y7Op36i1U
         WnxA==
X-Forwarded-Encrypted: i=1; AFNElJ/R9UME51z16zjAv+kjmMVyQzQiWOvjr2e7xsKsuvqgbb2izzcwt0fqmP+Y2E8kz77lKd0cb7de8A==@kvack.org
X-Gm-Message-State: AOJu0YydhbfSYf2k35hz+ksz4TQsB2M65zYRZQRQX7NccbztlpL+FZSR
	zc4UYAXwdfg/kjhK3YHBQQIrZPtFdE7/LhgMz2pnWoussSYEpd7VwFhk1dv7BnpWDbHJ9CO4Jy3
	ZORgWIGwV3XERKQ==
X-Received: from wmjk5.prod.google.com ([2002:a7b:c305:0:b0:490:dc44:9b3d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c088:b0:490:4ee0:82ff with SMTP id 5b1f17b1804b1-4923f58896emr216559755e9.27.1782122517852;
 Mon, 22 Jun 2026 03:01:57 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:39 +0000
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Mime-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260622-alloc-trylock-v2-12-31f31367d420@google.com>
Subject: [PATCH v2 12/13] mm: Move __alloc_pages() to mm/internal.h
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
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 4zbgp7rkf1pu118s366cy5hk4b4scn89
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4DCAB18000B
X-HE-Tag: 1782122519-148570
X-HE-Meta: U2FsdGVkX1/OaB/8XDf/Ccz9nRtiQ59ilbB4YA8no6dguBsV2AG2gJAg+gdE6xPK28Ru76Doj1wToAxSuFpxS/klQQj8JL1U6nVwOTPQ4EwkIoe+mrPUmpCHJPe0B5m/g64FuwSsr6SsT/bEGgR7GsuoAcDHnf+SXG9Bw7ID7BnVMP1eu9d30/u2coRWzUxQJTq8lXJSHNoyQw8kIFd130maAhqNFowr36DyM+3oOM9WzHCDvPEJIL9QcQ+WsHdDHToOMj7rH5eVRgtMNOQSYXNti4mC5zi4OFU9aU1zf8JkHgrqX9klg7VZbw5+ErHxC2rLPaiM58iiMLrkHQfq4N3XHBw4pFZ6h13l7N0OPbyV94NgOs5iSMlsD1COsydbo4xOB41TA8ga6KKe1T+raJg/obY5Unjx4FJHj8AhsFd6BqA3DqxjQvT7fP6JPrtqr00ED9v3bwIYh54l05B/ntft+MQcsyEtFIN9bakpcixysNawsFa8GN1MbzUUOq6uzLaQNljYKGbr7M+pL3J5pUk6HlJpklNlNFS1vXimLzUA66KTwYmNM2Ti9t9rJYzimUe5LM6gFrtF7hP/XvYeBZjgmWjq11xfqSMG+O3AgijZKYspyqqG5Fk1WD+EvBB5FruLnpgTQh94smSWEYLgP5q0cH9tx9crHDViTapewolWgukykpzSAnKood6shKUEhGMe/CtIXgJ8xf+q8CZ4RG5loFrZApUCjlqn0L0Zb3PI3FcTdMnTH+qhWR86Pa/zHNF20HBtL8qeVhRnqKV7HU8CCZiLYYrQNkedHGBrIGDc+Igttoq/urT0C5lBcl4aWu5wq4R6o/x+fiGT3TPejTJwrsn3iEqHLyCLaIhleP5da0kNGPfV0W4znbTbQ2S+d0gIwaBnoR5eXH0SeZzwIRsmMTUH/RuwtQlHu7aLxKW89uUiVxJHzEKjiCOwle/FKb5YzdKymSZfOCebr4j
 KBLjC0rV
 TFYuXiD6Rw9jeXE46iOI1RRMpbBaCyy55m6cK2nUby+ZupXsul3QAPUZBDCrGstPPjsOjpZHID/oFPfy+tWpCNySr6OUbFuNzyGZpra3e5ouDyK1rDLtxKw+NPpyu037GVgztsEsgxNk/QH6J9+l/iWJ6qKprLmS6pJLhBNqZzXonGsFeKzbaR6B4hV9+v9jjOAKz72Xstd0TmrdYG2BixJDveXVgzybyTj1Z0OSn8hPz94Qu3UxhkMnVYuqHMfuN9215MYMTIuPPveXlDlWlPPxZJtT7yMhJVxwJDIzgWkXTdUmkd4yAxJMdurNOETdeMrt2sk1VRuJOyz7wxP/ldMa7vNHUSzg1Y/aAQunscVmq6tlBJf2V3P/lGW8VD0IO9QirfvPFW9T/K+588odhY96auITaNkuAwm+8Pvv2BG6exDlsR0RSDhI/OedmX7lfpz+OdGmoDj/IEBfoOGaOcD2s5Ksxq4JCP9Yp9jCWKk9adW8q6R9uEHQOPCZ0FRBU0AiSI8ZpWLqu6VLSCdgic6Q/5bW0qisvZZ78ZsGO5NyLAR0lkBxXMaBY2NTRjI/qpKjtMIkrl8Y5yP3/n6wyOU14uI+8rxKzIaKWyfoigUmNAox0ZQNM+Ywheq6e45WcQyQbWIc+kPcWumnPHWPFFbXlwt9dObVmgFE5RTtE5Ck3Zm/DJE3S6fFiqg==
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

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 Documentation/admin-guide/cgroup-v1/cpusets.rst |  2 +-
 Documentation/admin-guide/mm/transhuge.rst      |  2 +-
 include/linux/gfp.h                             | 16 +---------------
 mm/internal.h                                   |  4 ++++
 mm/page_alloc.c                                 | 11 +++++++++++
 5 files changed, 18 insertions(+), 17 deletions(-)

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
index 7edcc2e0be9ce..9656a62138917 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -226,10 +226,6 @@ static inline void arch_free_page(struct page *page, int order) { }
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
-struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask);
-#define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
-
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask);
 #define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
@@ -294,17 +290,7 @@ struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
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
 
diff --git a/mm/internal.h b/mm/internal.h
index 6bc89ec62e527..0847b55bfc147 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1955,4 +1955,8 @@ static inline int get_sysctl_max_map_count(void)
 bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
 		   unsigned long npages);
 
+struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
+		nodemask_t *nodemask);
+#define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 074e007bf1bc3..d99e4ea8307ea 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5410,6 +5410,17 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
 }
 EXPORT_SYMBOL(__alloc_pages_noprof);
 
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
+
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask)
 {

-- 
2.54.0


