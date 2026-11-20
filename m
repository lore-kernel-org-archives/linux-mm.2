Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB82060722B7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Y4iR+8+s
Received: by kanga.kvack.org (Postfix)
	id AB0D56B0720; Thu, 19 Nov 2026 20:07:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60DE6B0722; Thu, 19 Nov 2026 20:07:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 928BE6B0721; Thu, 19 Nov 2026 20:07:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6287F6B071F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:07:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6FDF40C92
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:07 +0000 (UTC)
X-FDA: 85453708494.23.1ECBDDD
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf06.hostedemail.com (Postfix) with ESMTP id EE551180002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Y4iR+8+s;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3OJ3_agYKCM86C3KK919916z.x97638FI-775Gvx5.9C1@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3OJ3_agYKCM86C3KK919916z.x97638FI-775Gvx5.9C1@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795136826;
	b=qWGDuoReLKlrHt1BsbXxRqq5wiUO0GtXdiZFyjVzeZDoE+wq3tkKjBkkwYuh8Bb54mfJIj
	itp9GMpxA4B4AwFJvClCNx3UoGFJe894315SfsOpwMsCevQjBsS5BxXEHHfjXpMY693bAM
	Vk+kNFgWOs27X6hcLiRL1+RG7nV2epM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2lQEgM46XfGX9Y+WBdBsZ+ch/UK8taZtJapXbU3k+0=;
	b=VOjw0irbwbDkoEEcvTRwju3BrO3FKKPv/cZ66v9uzH8mzpqtORHzBNFgYuAWYKmrccVTRn
	mTZzGdlZ4i4/Jc1/MqOqyHVL2sd+/ctEi2ih5gfFJt9lsf0/+7uc7dE7ctlfo9S4Fd3Vdb
	M9fWEDEBKNiXS8AeE2oGENMe7x9YxF0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Y4iR+8+s;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3OJ3_agYKCM86C3KK919916z.x97638FI-775Gvx5.9C1@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3OJ3_agYKCM86C3KK919916z.x97638FI-775Gvx5.9C1@flex--lrizzo.bounces.google.com
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c504b52eed3so34979966b.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136825; x=1795741625; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S2lQEgM46XfGX9Y+WBdBsZ+ch/UK8taZtJapXbU3k+0=;
        b=Y4iR+8+se034WoMwW4STbNLRbNNRiqBvqSzEUuT/SRC1pZ/ojOLu9UZeaaE1jDiQlG
         al/SSzPL0JRgDOqG9+EBWJd3/ocdZa4NTHJT3+aYe1B2itUNjl24vOXxc/sCkKzde/Hn
         3kfSSv3pSydPmQRgAoe0FTdaZarA5PLYPtw4I+3NA02nt62ehqeWhMPiHfVih9oQhffQ
         PEyiY+HERmy/GgeeQEggqsXyC4w0ybPzav1s0V0cn8lC2ggB9ub75w9t2/c/0IKzGj0l
         5Phum0clzv61WgK5grHSzIdRAi6MJmGurIf188uz15NNESYq3bSXSKldHWc8bhMy1bxH
         a5nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136825; x=1795741625;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S2lQEgM46XfGX9Y+WBdBsZ+ch/UK8taZtJapXbU3k+0=;
        b=uqrac16zvc/y0S0DCqEOvF7dpB3LQwZ8cMkflbLdnL2lkspD0RoZ3kA3l5HtFLaz6x
         myA5opgbI20FXfNGmjp0GoPH5NiGZ1Jo4xZAnwOT3DqRm2iZplClCxUQGZ6a3ppbnb1T
         JGsruhY95Uc3Z02vE/vxB/EzP/KRb+sB0tXqOew7MfSnpxuzTxg11lpVAyDka0rpZsud
         NTAKjTplWxiTTAyd1afP3lFRcztzzqtWQZ99pynbhEj0wJE6KeiOaTJHw8MKttwlQCKf
         obHZCki90I+jnbzvJCrbxYoql/MzTnJckJnfiSNRENK0pD/Z5juaQ3eqPvB1Aj9G/T6d
         SRrQ==
X-Forwarded-Encrypted: i=1; AL+hErGAn3YQQW8GQt+kYJlrqv49qiNDAr1dvLxp0nZpDf0fjj4dG84+ZfKHR9GNh9+oQ+dCo7HLflpELA==@kvack.org
X-Gm-Message-State: APuU4Z/c2dH5v5QBvPZEALEvBUokGwYtiuLsxZtvNZA3UMMqm5Ao4eph
	qqudUYNcv+XxbASRFHX+1OzT7nHUeeF8FL+YLkUFfJ9nHizj2x6BAPDoJ8F7ggeq0U6NRhKjXIU
	EkA/B4w==
X-Received: from ejdr23.prod.google.com ([2002:a17:906:38d7:b0:c50:94e5:4db1])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:2897:b0:c51:24e7:38ca
 with SMTP id a640c23a62f3a-c513aada38amr99742966b.44.1795136824073; Thu, 19
 Nov 2026 17:07:04 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:33 +0000
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-4-lrizzo@google.com>
Subject: [RFC PATCH v3 03/25] mm: Add per-NUMA-node PISA page reservoir
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
X-Stat-Signature: yncxd8r95idihsx5cz6p78o1gwyhgqch
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EE551180002
X-HE-Tag: 1795136825-82691
X-HE-Meta: U2FsdGVkX19O5fM7RyYS4uXJMRmdhnQnkmgcVsNPKJQTrb9nJdigq+Wldj0EqHDSSHJabNhfd1UR6JHYAXdcqSfmj4cuV9j7y8uOP/hSOSbtM/sMrBMffrcV1Iw0A+naYrg/r/hE7YYBf99AH4/EqveIQgH+7VDDBHK6CGt4Tk8RzUyw/p92KcNNWlT7bDx4t9Ue5By/hdEPlQg30juSIOGbodNwH0QAmD6/nUjZ9IzbBTCaldurDRq0dt1UEuP/xioWKBJxjlXHXGG/N3uvvwYl76UMhhxVgKG764XiKAOTFI1zht0MfG+jedGkSb1hzXZ3Auy+P+9WFGXvaFKg485QHBsNcJ3pP2UC5r2uQ8muXvw6lMPDQ6zOjH7JKC6MQxGYlDsHzk4owtEo7Zwlz5uOuZuMLaMEU4aLGTm54OTTBSgThafMdyhaVK+thZbjTqAWW9RVgiXGB74UBfC1Cyo7moOClMXEeAgp8AuD9DmZrEy/0DHjEkXnuUqqzLtMw84rhRaIHqXS7MJCIIjO7Akakq48UAej9ujh2cdzjbO+dvsVnKozpFWeE5NziFwMHok1nVNxRkNzn5rZwm9SM+G8T4c609mpX8KOzlYxQyYLRSuOu+7mih3UDsiJuiWeJAuHJfUS5umZ2r095SjCAntGJ9nvRt1eYPCWBueaBfcGbFlXgFogads9cCoNb19Jb6oRyRmWaawErrff4/1gROAk+eqbrabiyUm3weg60UhRaEdLBayOj5A+bRAPMXNFS9A23qUPVy6UodW5MgHercTwmuE+kb+MUfIBxIua4x2jBkMk6EN5/8hrFOMmBHT3NhtQmr22cQgL47AI6VAXbjmSFdUcZuXU/U8YTothTfEhDh+wuarNa8JqnZn16O88KQCFiIwOxOz8Z6AXL/60+38xQ/7dYKkdYy07xfNJSZDravD53CN3UekXbVXeWHTMW8L/qEJlKAnkIwjr82W
 hPXs6fB/
 MT3wABJheGLQ00ijwKehGoKHSCZJAKA+tNlFqFUHm11NwjLF+phEs2RZnms/H2y4O1Y7rGTQVU6GbLwvczO9FOzaa/cIB1Ko5ei5dorEsxrb1OjQYOYmn08t+aAWp9lv+exVnyJ+B5jpTaugRKxWGrMuMf77Ww/8tDDCqtQ1LqRBSOtxIMBKA9VZarG4/NDa5fxeNRlmnv9Fy5DH1khAmEYT/K8RC7gbERb7wPQ5byxfGHahgBzCSOLuCniXkZr+6w+tsFsLLstE5K4ucTTrX73RVlcsBrnqrqqyPmnbWnqTb5cRsCrB/m87UZYsEOKe5wwBqfTruCqXYg3iPR6F5K0Lsoet+iZW/01jcngZiCPp3sH0YwOjkl+LA4+7eXkBCohdRh387HAatQaezWIb2+jh6/XHK+WbVXg6mmfk7UasjeQng+Y+Cpv3S8b4yr8T1/4wfUrY7DXWh3AcDx76gUDvIL/+qPcCQCAqRgVPaVWjDew+q8n7AZinb/MNtjmzwaG/bZXC2ljIyoFxrJohkSvnO65eSBm/0R00jIeinVMpXCcg60UOEU1AvqfBlVLxSkVCYM4R1WOc+gjTONvraDeMQ6sOiwKmG8DH2VB1g84keWO3fxF5InqLZlG297An+3udIuYZj9/1YbSmSKOcamr29wqWFQfLZd4DUTwdr2l++sdMw0LNSmROeBZu1YJQJvMVO5aPFujCTfuszsnyCqhPUbiGPrlij5kMyNK9nHqwBeujS02q4ljJFD4dDeLuoNMpKxIyRhPMigEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Allocating a large page may involve compacting and blocking, so it cannot
be issued in GFP_ATOMIC context.

Add a per-NUMA-node reservoir of pre-allocated and set up PISA pages,
that can serve allocations without blocking. The reservoir is refilled in
process context by a per-node work item, queued with queue_work_node()
on system_dfl_wq so each node is refilled from its own CPUs, not bound
to the CPU that caused the miss.

pisa.reservoir_max, writable at runtime, sets the number of PISA pages
per node (default 16 = 32 MB per node; 0 = disabled).

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 mm/pisa-alloc.c |   2 +
 mm/pisa-kunit.c |   7 ++
 mm/pisa-meta.c  |   1 +
 mm/pisa-node.c  | 273 +++++++++++++++++++++++++++++++++++++++++++++++-
 mm/pisa-priv.h  |  22 ++++
 5 files changed, 304 insertions(+), 1 deletion(-)

diff --git a/mm/pisa-alloc.c b/mm/pisa-alloc.c
index 557ec1ba88c78..7ba93746f6a89 100644
--- a/mm/pisa-alloc.c
+++ b/mm/pisa-alloc.c
@@ -328,6 +328,8 @@ bool __pisa_free_page(struct page *page, unsigned int order)
 
 static int __init pisa_init(void)
 {
+	pisa_node_init();
+
 	/* Dedicated WQ_MEM_RECLAIM workqueue so reclaim never blocks behind system_wq. */
 	pisa_wq = alloc_workqueue("pisa", WQ_MEM_RECLAIM, 0);
 	if (!pisa_wq)
diff --git a/mm/pisa-kunit.c b/mm/pisa-kunit.c
index 7436d1c9b86a6..bdf5184bbd52a 100644
--- a/mm/pisa-kunit.c
+++ b/mm/pisa-kunit.c
@@ -192,12 +192,19 @@ static void test_quarantine(struct kunit *test)
 	__free_pages(page, PISA_ORDER);
 }
 
+static void test_reservoir_and_scrubber(struct kunit *test)
+{
+	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
+	KUNIT_EXPECT_EQ(test, READ_ONCE(pisa_reservoir_max), 16U);
+}
+
 static struct kunit_case pisa_meta_test_cases[] = {
 	KUNIT_CASE(test_meta_init_and_roundtrip),
 	KUNIT_CASE(test_meta_invalid_phys),
 	KUNIT_CASE(test_meta_active_toggle),
 	KUNIT_CASE(test_alloc_and_recycle),
 	KUNIT_CASE(test_quarantine),
+	KUNIT_CASE(test_reservoir_and_scrubber),
 	{}
 };
 
diff --git a/mm/pisa-meta.c b/mm/pisa-meta.c
index 41ea277c60f00..7cdb1c45d65c8 100644
--- a/mm/pisa-meta.c
+++ b/mm/pisa-meta.c
@@ -657,6 +657,7 @@ int pisa_meta_init(void)
 	mutex_unlock(&pisa_meta_mutex);
 out_enable:
 	static_branch_enable(&pisa_key);
+	pisa_schedule_reservoir();
 	return 0;
 
 out_free_vms:
diff --git a/mm/pisa-node.c b/mm/pisa-node.c
index fe9f37deac755..5b9b44186b967 100644
--- a/mm/pisa-node.c
+++ b/mm/pisa-node.c
@@ -6,14 +6,114 @@
 
 #include <linux/atomic.h>
 #include <linux/pisa.h>
+#include <linux/err.h>
+#include <linux/gfp.h>
+#include <linux/list.h>
 #include <linux/mm.h>
+#include <linux/moduleparam.h>
 #include <linux/nodemask.h>
 #include <linux/rcupdate.h>
+#include <linux/sched.h>
+#include <linux/sched/mm.h>
+#include <linux/spinlock.h>
+#include <linux/topology.h>
+#include <linux/workqueue.h>
 
 #include "pisa-priv.h"
 
+/*
+ * Per-NUMA-node reservoir of pre-allocated, pre-zeroed, and pre-decrypted
+ * PISA pages (pisa.reservoir_max, default 16, 0 = disabled). Refilled and
+ * trimmed by each node's work item on system_dfl_wq, which also scrubs
+ * allocators on that node.
+ */
+unsigned int pisa_reservoir_max __read_mostly = 16;
+
 /* Per-NUMA-node PISA state (ring/TX/user allocators, reservoir). */
-struct pisa_node pisa_nodes[MAX_NUMNODES];
+struct pisa_node pisa_nodes[MAX_NUMNODES] = {
+	[0 ... MAX_NUMNODES - 1] = {
+		.next_alloc = INITIAL_JIFFIES,
+		.lock = __SPIN_LOCK_UNLOCKED(pisa_nodes.lock),
+	},
+};
+
+static int pisa_reservoir_max_set(const char *val, const struct kernel_param *kp)
+{
+	int ret = param_set_uint(val, kp);
+
+	/* Schedule per-node workers to refill or trim once pisa_meta_init() has run. */
+	if (pisa_enabled() && !ret)
+		pisa_schedule_reservoir();
+	return ret;
+}
+
+static const struct kernel_param_ops pisa_reservoir_max_ops = {
+	.set = pisa_reservoir_max_set,
+	.get = param_get_uint,
+};
+module_param_cb(reservoir_max, &pisa_reservoir_max_ops, &pisa_reservoir_max, 0644);
+
+/* Apply GFP_NOFS/GFP_NOIO scope around internal GFP_KERNEL allocations. */
+static unsigned int pisa_memalloc_save(gfp_t gfp)
+{
+	unsigned int flags = 0;
+
+	if (!(gfp & __GFP_FS))
+		flags |= PF_MEMALLOC_NOFS;
+	if (!(gfp & __GFP_IO))
+		flags |= PF_MEMALLOC_NOIO;
+	return memalloc_flags_save(flags);
+}
+
+/* Allocate a PISA page from the buddy allocator and initialize its metadata. */
+static struct pisa_meta *__pisa_page_alloc(gfp_t gfp, int nid, bool can_block,
+					   bool *clean)
+{
+	struct pisa_meta *meta;
+	unsigned int memflags;
+	bool can_reclaim_fs;
+	struct page *page;
+	int err;
+
+	gfp = current_gfp_context(gfp & gfp_allowed_mask);
+	can_reclaim_fs = can_block && (gfp & (__GFP_FS | __GFP_IO)) == (__GFP_FS | __GFP_IO);
+	if (unlikely(!pisa_enabled())) {
+		if (!can_reclaim_fs || pisa_meta_init())
+			return ERR_PTR(-EAGAIN);
+	}
+
+	/*
+	 * Long-lived active pages must be unmovable, lowmem, non-compound, and
+	 * must not dip into emergency reserves or trigger OOM/warnings.
+	 */
+	gfp &= ~(__GFP_COMP | __GFP_HIGHMEM | __GFP_MOVABLE);
+	gfp |= __GFP_NOWARN | __GFP_NOMEMALLOC | (can_block ? __GFP_RETRY_MAYFAIL : __GFP_NORETRY);
+
+	if (can_block)
+		memflags = pisa_memalloc_save(gfp);
+	page = alloc_pages_node(nid, gfp, PISA_ORDER);
+	if (!page) {
+		if (can_block)
+			memalloc_flags_restore(memflags);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* Bind this PISA frame to a compact metadata slot. */
+	err = pisa_meta_ensure_pfn(page_to_pfn(page), can_block);
+	if (unlikely(err)) {
+		if (can_block)
+			memalloc_flags_restore(memflags);
+		__free_pages(page, PISA_ORDER);
+		return ERR_PTR(err);
+	}
+	if (can_block)
+		memalloc_flags_restore(memflags);
+
+	meta = pisa_meta_of_pfn(page_to_pfn(page));
+	*clean = (gfp & __GFP_ZERO) || want_init_on_alloc(0) || want_init_on_free();
+
+	return meta;
+}
 
 /*
  * Idle PISA page release proceeds in three stages:
@@ -53,9 +153,180 @@ static void pisa_release_page_rcu(struct rcu_head *head)
 /* Unmap a retired PISA page, clear PISA_ACTIVE, and queue RCU release. */
 void pisa_release_page(struct pisa_meta *meta)
 {
+	if (!meta->pa) {
+		struct page *page = pisa_meta_to_page(meta);
+
+		pisa_slot_free(meta);
+		__free_pages(page, PISA_ORDER);
+		return;
+	}
+
 	/* pisa_unmap_all_domains(meta) will be called here once IOMMU mappings are added. */
 
 	/* Clear PISA_ACTIVE before the RCU grace period so new readers stop entering. */
 	pisa_meta_clear_flags(meta, PISA_ACTIVE);
 	call_rcu(&meta->rcu, pisa_release_page_rcu);
 }
+
+/* Refill node @nid's reservoir up to pisa_reservoir_max pre-zeroed PISA pages. */
+static void pisa_reservoir_refill_node(struct pisa_node *node, int nid)
+{
+	while (READ_ONCE(node->nr_pages) < READ_ONCE(pisa_reservoir_max)) {
+		struct pisa_meta *meta;
+		unsigned long flags;
+		bool clean, added;
+
+		meta = __pisa_page_alloc(GFP_KERNEL | __GFP_THISNODE, nid, true, &clean);
+		if (IS_ERR(meta)) {
+			pisa_alloc_backoff(node, false);
+			break;
+		}
+
+		/* init_on_alloc/init_on_free pages are already zeroed. */
+		if (!clean)
+			memset(page_address(pisa_meta_to_page(meta)), 0, PISA_SIZE);
+
+		spin_lock_irqsave(&node->lock, flags);
+		/* pisa_reservoir_max may have been lowered while allocating and zeroing. */
+		added = node->nr_pages < READ_ONCE(pisa_reservoir_max);
+		if (added) {
+			list_add(&meta->list, &node->pages);
+			WRITE_ONCE(node->nr_pages, node->nr_pages + 1);
+		}
+		spin_unlock_irqrestore(&node->lock, flags);
+		if (!added) {
+			pisa_release_page(meta);
+			break;
+		}
+
+		cond_resched();
+	}
+}
+
+/* Release PISA pages in @node's reservoir above @max. */
+static void pisa_reservoir_trim_node(struct pisa_node *node, unsigned int max)
+{
+	while (READ_ONCE(node->nr_pages) > max &&
+	       READ_ONCE(node->nr_pages) > READ_ONCE(pisa_reservoir_max)) {
+		struct pisa_meta *meta;
+		unsigned long flags;
+
+		spin_lock_irqsave(&node->lock, flags);
+		meta = list_first_entry_or_null(&node->pages, struct pisa_meta, list);
+		if (meta) {
+			list_del_init(&meta->list);
+			WRITE_ONCE(node->nr_pages, node->nr_pages - 1);
+		}
+		spin_unlock_irqrestore(&node->lock, flags);
+		if (!meta)
+			break;
+
+		pisa_release_page(meta);
+		cond_resched();
+	}
+}
+
+/* Per-node worker: trim/refill the reservoir, then scrub allocators homed on @nid. */
+static void pisa_node_work_fn(struct work_struct *work)
+{
+	struct pisa_node *node = container_of(work, struct pisa_node, work);
+	int nid = node - pisa_nodes;
+
+	pisa_reservoir_trim_node(node, READ_ONCE(pisa_reservoir_max));
+	if (pisa_enabled() && READ_ONCE(pisa_reservoir_max))
+		pisa_reservoir_refill_node(node, nid);
+}
+
+/* Queue node @nid's work if its reservoir is below or above the target. */
+static void pisa_schedule_reservoir_node(int nid)
+{
+	struct pisa_node *node = &pisa_nodes[nid];
+
+	if (READ_ONCE(node->nr_pages) != READ_ONCE(pisa_reservoir_max) &&
+	    !work_pending(&node->work))
+		queue_work_node(nid, system_dfl_wq, &node->work);
+}
+
+void pisa_schedule_reservoir(void)
+{
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY)
+		pisa_schedule_reservoir_node(nid);
+}
+
+/* Pop one pre-prepared PISA page from node @nid's reservoir under @node->lock. */
+static struct pisa_meta *pisa_reservoir_pop_node(int nid, unsigned int max)
+{
+	struct pisa_node *node = &pisa_nodes[nid];
+	struct pisa_meta *meta;
+	unsigned long flags;
+	bool refill = false;
+
+	if (!READ_ONCE(node->nr_pages))
+		return NULL;
+
+	spin_lock_irqsave(&node->lock, flags);
+	meta = list_first_entry_or_null(&node->pages, struct pisa_meta, list);
+	if (meta) {
+		list_del_init(&meta->list);
+		WRITE_ONCE(node->nr_pages, node->nr_pages - 1);
+		refill = node->nr_pages <= max / 2;
+	}
+	spin_unlock_irqrestore(&node->lock, flags);
+
+	if (refill)
+		pisa_schedule_reservoir_node(nid);
+
+	return meta;
+}
+
+/*
+ * Pop a pre-prepared PISA page from @nid's reservoir (scheduling an async
+ * refill when <= half full or empty), or allocate one inline on miss.
+ */
+struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool *clean)
+{
+	bool can_block = gfpflags_allow_blocking(gfp);
+	unsigned int max = READ_ONCE(pisa_reservoir_max);
+	struct pisa_meta *meta;
+
+	if (max) {
+		meta = pisa_reservoir_pop_node(nid, max);
+		if (meta) {
+			*clean = true;
+			return meta;
+		}
+	}
+
+	/* Back off briefly on GFP_ATOMIC if previous allocation on @nid failed. */
+	if (!can_block && time_before(jiffies, READ_ONCE(pisa_nodes[nid].next_alloc)))
+		return ERR_PTR(-EAGAIN);
+	if (max)
+		pisa_schedule_reservoir_node(nid);
+
+	meta = __pisa_page_alloc(gfp, nid, can_block, clean);
+	if (IS_ERR(meta))
+		pisa_alloc_backoff(&pisa_nodes[nid], can_block);
+	return meta;
+}
+
+/* Number of PISA pages held in all the reservoirs. */
+unsigned long pisa_reservoir_count(void)
+{
+	unsigned long nr = 0;
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY)
+		nr += READ_ONCE(pisa_nodes[nid].nr_pages);
+	return nr;
+}
+
+void __init pisa_node_init(void)
+{
+	for (int nid = 0; nid < MAX_NUMNODES; nid++) {
+		spin_lock_init(&pisa_nodes[nid].lock);
+		INIT_LIST_HEAD(&pisa_nodes[nid].pages);
+		INIT_WORK(&pisa_nodes[nid].work, pisa_node_work_fn);
+	}
+}
diff --git a/mm/pisa-priv.h b/mm/pisa-priv.h
index 776462a2f1ee2..bca35f463c3b7 100644
--- a/mm/pisa-priv.h
+++ b/mm/pisa-priv.h
@@ -9,9 +9,11 @@
 
 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "pisa."
+#include <linux/jiffies.h>
 #include <linux/nodemask.h>
 #include <linux/spinlock.h>
 #include <linux/topology.h>
+#include <linux/workqueue.h>
 
 
 #ifdef CONFIG_PISA
@@ -24,6 +26,7 @@
  *
  * 1. Allocators (mm/pisa-alloc.c, mm/pisa-node.c):
  *    pisa_allocs_lock (rwlock) -> pa->lock (spinlock)
+ *    pisa_nodes[].lock (spinlock): leaf lock over a node's reservoir.
  *
  * 2. Metadata tables (mm/pisa-meta.c):
  *    pisa_meta_mutex (mutex): init and hotplug page-table population.
@@ -99,7 +102,13 @@ struct pisa_alloc {
 
 /* Per-NUMA-node PISA state. */
 struct pisa_node {
+	unsigned long		next_alloc;	/* atomic alloc backoff jiffies */
 	struct pisa_alloc	*pa[2][PISA_MAX_ALLOC_ORDER + 1]; /* [0]=RW, [1]=RO */
+
+	spinlock_t		lock;		/* protects @pages and @nr_pages */
+	unsigned int		nr_pages;	/* entries in @pages */
+	struct list_head	pages;		/* reservoir */
+	struct work_struct	work;		/* refill/trim, on this node */
 } ____cacheline_aligned_in_smp;
 
 /* Per-NUMA-node PISA state (ring/TX/user allocators, reservoir). */
@@ -136,6 +145,12 @@ static inline struct pisa_alloc *pisa_node_pa(int nid, unsigned int order, bool
 	       pisa_nodes[pisa_sanitize_nid(nid)].pa[read_only][order];
 }
 
+static inline void pisa_alloc_backoff(struct pisa_node *node, bool can_block)
+{
+	if (!can_block)
+		WRITE_ONCE(node->next_alloc, jiffies + DIV_ROUND_UP(HZ, 100));
+}
+
 /* pisa-alloc.c, also used by the per-node code in pisa-node.c */
 struct pisa_alloc *pisa_alloc_create(int nid, unsigned int order, enum dma_data_direction dir);
 __printf(2, 3)
@@ -145,5 +160,12 @@ extern struct llist_head pisa_free_list;
 extern unsigned int pisa_idle_ms;
 void pisa_release_page(struct pisa_meta *meta);
 
+/* pisa-node.c: per-NUMA-node PISA page reservoir and work item */
+extern unsigned int pisa_reservoir_max;
+void pisa_node_init(void);
+void pisa_schedule_reservoir(void);
+struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool *clean);
+unsigned long pisa_reservoir_count(void);
+
 #endif /* CONFIG_PISA */
 #endif /* _MM_PISA_PRIV_H */
-- 
2.56.1.809.ga0b61035b5-goog


