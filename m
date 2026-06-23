Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50153CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256C26B0092; Tue, 23 Jun 2026 14:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E9F6B0093; Tue, 23 Jun 2026 14:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CEC06B0096; Tue, 23 Jun 2026 14:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C89C26B0092
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:01:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D4781405BB
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:01:31 +0000 (UTC)
X-FDA: 84911944782.20.A043622
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id C2AB716000C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:01:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZQVw4n8S;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782237688;
	b=FNjo8SqSRC6qxvhdYsl02YBXWgIGSl9/Lq464rKMpzPYhXUsuer1a7jYKsCv1D+ceABg67
	knlNB6JIYTCCEkwCHzXnLJr12G9otxYemXfwf6lhD3sdfJFNmDSR8DkIkJcQ61lXmCrLuo
	B/4gRaQ+EESJUZwZIMh0hs2qUdUR13c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782237688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pzU1DE9THaq3wZw8gndmiVL6XdA2w7BeQ82VsVhXVw=;
	b=knnpMWI1C3gKTnvP74L3F8OT4Fn5gcWqX5fiUoXYOpj8KCw5zKOQkDiGEFgOPKyOvx9rwM
	06BP5uc8nSyFJUMnyD2l8Qs2viinKdUanQR4n2uoPKvO6dhj2/wLk34H1ncQFxEPh7i1rY
	Y4VD0/XNmFR9dPExOVBkvjsRlUH1OVU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZQVw4n8S;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e6b5c374e5so133116a34.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782237688; x=1782842488; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7pzU1DE9THaq3wZw8gndmiVL6XdA2w7BeQ82VsVhXVw=;
        b=ZQVw4n8S9R8D0OaEuhyLN+lvM7bBmoQXf9B+6la9WJ95gcgSuyvi7on8S8wMHBy7hT
         iS7EvhS5E0upXiIs0fSG+enTB2Xwyw42RGxDuK9ZvCkDy8JzVvvidhLwtoAFvjxfogEc
         KIHk/FzEpBFrB3C8xLTxHXq7tSQtBUJ2IZEiIqMSa0052QFu3wFr6E5J5HafF9S1Tpgz
         T7Th7zIel7BdRAjav9lc4WXeZMUu/vLRSHyXQxQN6hQ56jTAhWS1d0BlWwYLkC0cQmYv
         LzdUxT9k6QCau27u+jYVNvb5nnuuoClBrmvvfn3p/YulrFqNRt5clXSORHdD9nfRXJI5
         d3tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782237688; x=1782842488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7pzU1DE9THaq3wZw8gndmiVL6XdA2w7BeQ82VsVhXVw=;
        b=oxXbGH56jpO+vnmGiRIjSakKaPnxCmstLesij67bHFGcs/0WDvie886KNri8wgIYz+
         gYKuZ/3xIbeCrNzxrrOUUzWgdbi97hSkXS8PeHNjaCDVAktj2f2SmZtZ0zNaPrv2iQk9
         NumB/vM5Kkt8D4dUAmAIcNF5WHSJUdjold6aH8ARInTMOJvZ6HnfWTKWVlIoYqtJhvNU
         vzjYoaD4OC/7iTclU36RNCiRWMxRHCibmBhnycEu1acH48xcybQkCpzYg7zAUVz4oddD
         bl95nDUYzvOVGxnQ+Bvw6tB/n/yiJ5yGuQ15x1LozKUwYPxaLghTPaLP2GmYFPnmNerA
         YHUw==
X-Forwarded-Encrypted: i=1; AFNElJ8EktgCpDqLEwfpp4+I+wnke/X0U3SyOla6Yrbk3Vf+1Ub1pOqXMhGTCmvpdVLnJXuyDfai1oBnrg==@kvack.org
X-Gm-Message-State: AOJu0YytZP0LAFWbqT+nuq7gr0YG36ZFPYS/2+AOjcpG3aJ0/QqGG5aj
	kriuMx4crtDqf6uDYShHgPVguKHAgXpUvkXZX89sw+RaKFZZaW8KpXJl
X-Gm-Gg: AfdE7clobDeriv1vrOrlU0xE5TJOwAOUgAZFRbi4dTQC3g0zWuU2l51R2nUGrXoriIe
	tNljggEhl0yMqX6+E4OCZUzuK7s9WLeXcHCq+45g2X3JRLMmEM84i4j9RIMOXoLT++UzAfmKC9X
	grJkJdN9BE/BCePVcsljsZm5Vc4swluCjndpe+gt4HHo/q2meErgpM9SnaCV9ULnn3UbGVwaORQ
	JNbtObnWbtpxjup6cD+gehodFY2TzuopHFvW7iDJtYvhGPRPQ5QcuhW9fwvevy1kCft+XffnPNR
	cg4t4gazTbheFEKkgb326h1bkObgoOkJ94dnGWGVIU2JH4/n92EHnYnF0zNPX8Sq6Ch+avcLwIB
	+qf2c2R6S+DjJ2necNVG5lRif0CwxLABPP+tvfwW5/Won59S8YSu1Z3veqfba9zq0qflwo4kTjZ
	vDEy0kvr4HZi3JalDqdMdwkXOCXhvGOAxjoiXD0TgSRbg=
X-Received: by 2002:a05:6830:378b:b0:7dc:a51c:9197 with SMTP id 46e09a7af769-7e9740b24efmr2719111a34.7.1782237687708;
        Tue, 23 Jun 2026 11:01:27 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:51::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e943d5dc07sm10116277a34.0.2026.06.23.11.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 11:01:27 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v4 1/5] mm/page_counter: introduce per-page_counter stock
Date: Tue, 23 Jun 2026 11:01:19 -0700
Message-ID: <20260623180124.868655-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623180124.868655-1-joshua.hahnjy@gmail.com>
References: <20260623180124.868655-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ew6ensjc3ns85scff1u53wmbzau1377c
X-Rspam-User: 
X-Rspamd-Queue-Id: C2AB716000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1782237688-996962
X-HE-Meta: U2FsdGVkX18wzucS+KhQ43opQTUWk00RFPxesFSnHsz6J6K8AV8UYqG4ASBq/+Rm9F3tbyqHzBCERy18wt/WumHs9FzA0vGtjXdCcD2u4Iv4j6k3obZKClsThduV9kBnSjLUyVhuX42GVQmzY0ubaz4znM9x4VlV97cMhuRobiKgcudnlhfMpMbL40yIgWmGxjGPPybGl3BaZPNjW9Otxru+cuvbc/nEl4EmdLPiYJTn2PTvkLCpUKpW5Ao9oAmx+4KHHyq/3IS1INVgX58oL0/RTBPTAIMNaxTM09n7AUIP/3VpBeb5S9aqzV5ibcu9wbMMDhVQqGADhqk0bXhTJOdMmo55pnLZDvanvabwX77u8sS3zzXyiQ5Wu/8/OswtFK5w7aFimgmcoS6Sn6fOY7xYFd9RIGovTGd/4K5jB46FeVfvSodCAH9EOvCLKDpjEbQlavOxCMLxWIrGnYP7xTq8OnQq5Ah/hNxXXJzF3NMu9RWtrP6WWAK92tnNtxd4tAeO6caZoGRTBKzFAc4AEzENTqimtna8L3khlzy1irLyxMmrTQgWqjZnzegYf9p5yt4w0hTwvYI3cZb5ZcgrCaj0PF28V8jqnUEF9iSSt9w3iFA+slqBN/mlRXlkQVOJhL4aUUuxycXNkYCi6FbK53GW5DfnPOz8Rh7XmgD5krPzrq1wYEf+8G0YKmH+iZhM+uJDMNVx9n6CP7vRAQA8Vaf6U7SBiLdetFLFJCTJXL0uUy2A5muh/53wk+ceA0Sj913jSa2aO3oD8WjjMcLPcmjFBZPXCi51s01eK7bLAKVehYmCOD21RmSVfGLSiZxRw4pOu2WZ3n7iqa72A/QBAomzZcTLnGwkprvgKn1B6F0bUfbJs0OeJunL4oSlykwLvOeXxDkS/qfp0dELY5LibKeCoMt9eO/0atSAflTuAfjHsr1sTvNqx7ruODBJeO9rPOBE99k/Rk9+72DC+pX
 zgfdVrBJ
 2jhYYmZPljpUn3R6PVSoQZMRCvDnx0O+qJXQvmPqiMpR1v9uexAkRUnLLDLYdBxEDUMdHttETZKJHTXbiOEREVnV5+WZAgaZbxRPiPH2S89pO2BIDszKiGfQKD+vcupbkKDLuQGC1M+WsejYHTvykW9U2tcbse3lu1Bi8jpcFYvpDRHDpaz3PWrVVvwGSxg0jL3MpFJA8FfNCr22KPML0HtCV05E6sY7u+JyYD1sxeX4Oq9AOftUkbLxIX5u74ZbM08Z57dQjwIu3y4AIhEE98/giAEpi+8qArfpuScortGZaPaqezkjVGjeVSoStIGozH5R0zi+j7wtg+4nwzrrZtiZV+kbNbIbhaVyjjJMc6k3uWTMIjF8p9T6J7WMS2nnyg6hB4CltIrIbrFglxdI6563jyaWnJYDdt2ZASe/2k8FaMwjs/8H44jgVtf0NRukKxtFwCyhd9l8X/DCl8cl5hgiLKZuoOLG1uPuLeaJt4MPa6SAyvFulmXgUHgYzjbTHcpEBfZP98/h3HBoacEmxHkIOkMnu83NfkJnh/4MT21PoSFTwrdt2iEgEAOGR10cUL3wGPuH7lc6R0NyDLvRrckR/OxuC+mUssjENNNr9QA0KPHk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to avoid expensive hierarchy walks on every memcg charge and
limit check, memcontrol uses per-cpu stocks (memcg_stock_pcp) to cache
pre-charged pages and introduce a fast path to try_charge_memcg.
However, there are a few quirks with the current implementation that
could be improved upon.

First, each memcg_stock_pcp can only cache the charges of 7 memcgs
(defined as NR_MEMCG_STOCK), which means that once a CPU starts handling
the charging of more than 7 memcgs, it randomly selects a victim memcg
to evict and drain from the cpu, which can cause unnecessarily increased
latencies and thrashing as memcgs continually evict each other's stock.

Flushing a memcg's stock on a CPU also means that all other stock
present on that CPU is also flushed, leading to poor caching for systems
running multiple memcgs competing for the same CPUs.

Finally, stock is tightly coupled with memcg, which means that all page
counters in a memcg share the same resource. This may simplify some of
the charging logic, but it prevents new page counters from being added
and using a separate stock.

We can address these concerns by pushing the concept of stock down to
the page_counter level, which addresses the random eviction problem by
getting rid of the 7 slot limit, and makes enabling separate stock
caches for other page_counters simpler.

Introduce a generic per-cpu stock directly in struct page_counter.
Stock can optionally be enabled per-page_counter, limiting the overhead
increase for page_counters who do not benefit greatly from caching
charges.

In this scheme, stock usage and refills happen via lockless atomic
operations, eliminating the need for asynchronous workqueues as well.
In this commit we introduce the alloc, free, and drain operations,
although they are unused for now.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h | 15 +++++++++++++
 mm/page_counter.c            | 42 ++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index d649b6bbbc871..4abc7fe7c3494 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -5,8 +5,17 @@
 #include <linux/atomic.h>
 #include <linux/cache.h>
 #include <linux/limits.h>
+#include <linux/percpu.h>
 #include <asm/page.h>
 
+struct page_counter_stock {
+	/*
+	 * Consumption/refills can only come from the owning cpu via
+	 * atomic_cmpxchg. Remote access only happens on drain via atomic_xchg.
+	 */
+	atomic_t nr_pages;
+};
+
 struct page_counter {
 	/*
 	 * Make sure 'usage' does not share cacheline with any other field in
@@ -41,6 +50,8 @@ struct page_counter {
 	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;
+	struct page_counter_stock __percpu *stock;
+	unsigned int batch;
 } ____cacheline_internodealigned_in_smp;
 
 #if BITS_PER_LONG == 32
@@ -99,6 +110,10 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
 	counter->watermark = usage;
 }
 
+void page_counter_drain_stock(struct page_counter *counter, unsigned int cpu);
+int page_counter_alloc_stock(struct page_counter *counter, unsigned int batch);
+void page_counter_free_stock(struct page_counter *counter);
+
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 void page_counter_calculate_protection(struct page_counter *root,
 				       struct page_counter *counter,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127a..6bb48a913a90d 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -8,6 +8,7 @@
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
 #include <linux/kernel.h>
+#include <linux/percpu.h>
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/bug.h>
@@ -289,6 +290,47 @@ int page_counter_memparse(const char *buf, const char *max,
 	return 0;
 }
 
+void page_counter_drain_stock(struct page_counter *counter, unsigned int cpu)
+{
+	struct page_counter_stock *stock;
+	int nr_pages;
+
+	if (!counter->stock)
+		return;
+
+	stock = per_cpu_ptr(counter->stock, cpu);
+	nr_pages = atomic_xchg(&stock->nr_pages, 0);
+	if (nr_pages)
+		page_counter_uncharge(counter, nr_pages);
+}
+
+int page_counter_alloc_stock(struct page_counter *counter, unsigned int batch)
+{
+	struct page_counter_stock __percpu *stock;
+
+	stock = alloc_percpu(struct page_counter_stock);
+	if (!stock)
+		return -ENOMEM;
+
+	counter->stock = stock;
+	counter->batch = batch;
+
+	return 0;
+}
+
+void page_counter_free_stock(struct page_counter *counter)
+{
+	int cpu;
+
+	if (!counter->stock)
+		return;
+
+	for_each_possible_cpu(cpu)
+		page_counter_drain_stock(counter, cpu);
+
+	free_percpu(counter->stock);
+	counter->stock = NULL;
+}
 
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 /*
-- 
2.53.0-Meta


