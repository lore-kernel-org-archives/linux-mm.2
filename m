Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5412C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11566B009E; Wed,  5 Aug 2026 05:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC10A6B00A1; Wed,  5 Aug 2026 05:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD166B00A2; Wed,  5 Aug 2026 05:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71D006B009E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:49:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04DCCA1D16
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:48:59 +0000 (UTC)
X-FDA: 85066742040.27.DDE47B6
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	by imf21.hostedemail.com (Postfix) with ESMTP id CEF141C0003
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:48:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b=OQwTPY4F;
	spf=pass (imf21.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 178.154.239.136 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru;
	dmarc=pass (policy=none) header.from=yandex-team.ru
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785923338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txy7XdeWKzueWCucPRXi6adETsnhStuNq13oMYnNdp0=;
	b=rM6/FfxB312Ni8wJSslO9q67/RLT9i4pxzr4u7waga6fHrngHh/Vhshy3Pl1C/AObvj24/
	qvJk7nOh8aXybe5eGvVAqSg7TEMzENNAfkp7+cxIGv9kJ6kHG26y4XJ0KWGeJ6FcXvIn2O
	6TZ1+JRFPlBuAfzZsP/DsBVd70gHYnI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b=OQwTPY4F;
	spf=pass (imf21.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 178.154.239.136 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru;
	dmarc=pass (policy=none) header.from=yandex-team.ru
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785923338;
	b=Gv/7ZYmILn5qO629jSZVycQjYGEi25QAkUEqGovp/x0mhT8lbEBEBzG6qh2bZPgPuBra1x
	4IkiM2dWLIbIYRstVmdr4zKL3gLw21CND9dno6Fjd5MEMmjN3EZT4TxDj+ctYw4KCRjb1Q
	qcfYb3+ar6ivv/KgsgVqKiBUORJsV4g=
Received: from mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net [IPv6:2a02:6b8:c11:43a8:0:640:574d:0])
	by forwardcorp1b.mail.yandex.net (postfix) with ESMTPS id 17FE9808E2;
	Wed, 05 Aug 2026 12:48:56 +0300 (MSK)
Received: from i101646577.yandex-team.ru (unknown [2a02:6bf:8080:43c::1:39])
	by mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (smtpcorp) with ESMTPSA id lmErQB23hCg0-WtxDo90n;
	Wed, 05 Aug 2026 12:48:55 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1785923335;
	bh=txy7XdeWKzueWCucPRXi6adETsnhStuNq13oMYnNdp0=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=OQwTPY4Fl4gi2xKppKdVfGp0Edujpnzp9YsYCCxa17juxvZdpMOfSJN/JPWhAzpkJ
	 Yry6H/cCawKYQOdfA8qX8Uh04Sb3x3Fw1t2QcQSaTMXlf555rhTf5Jsgk/QglDR0AC
	 GpsarBNTeW9HI6jJs6U/NeW4y9dpPhMPaZamoMaA=
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Hao Li <hao.li@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Daniil Tatianin <d-tatianin@yandex-team.ru>
Subject: [RFC PATCH 1/3] mm/slub: allow capping the order kvmalloc() uses for kmalloc()
Date: Wed,  5 Aug 2026 12:48:41 +0300
Message-ID: <20260805094843.292134-2-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260805094843.292134-1-d-tatianin@yandex-team.ru>
References: <20260805094843.292134-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CEF141C0003
X-Stat-Signature: bitwetk9rbozm61px9e9sdedytk1hea4
X-HE-Tag: 1785923337-525707
X-HE-Meta: U2FsdGVkX18XfcSgMpyOSmaLEfM3WPV44EwXWXrnQzqvdZW4pmQMhTRjX7cx2BT7ibx7BqTefrb+G74dTtDJEAJIBvnNTMYWBxRLrCYq4NEyFd9xLgsSlRL5+HJG4rRfxcABjDtYNbTX7nu8tMmJ9wi7diZst8cF6Y8oKD1Irw21xkMbPse3rJh05MabzCVkD7R6O/D0APPrw491RicP0djO9h7HcUr4sVHrWEPu1vg0p9x5buB+5/KGZlASEGu8VQVHdZ3IR1Nh1UA1WnDGaGMWzN5527yrQXdhXE/+vmR8UcB7l/MMIm456IYCvJ+uydoO+Mv401xg+p6gtfLqS5yBT95utQlqcELkq6Il+Nkav95m5r0PyxKaQdHRz5us94wK4y9UBIC7DtDUVvtKTk1giN+FUS6Swkgil0x0kowTs6g4yAnLJJVnZMPADIUlPmfZsKEdX/HN4EsNROsRdTbJMrqeQLi1ohOkhB6iCxvyuygyGmfoK5Ed1qFRkEwUWnxaV+9JiIgkgLI8WPjlPOJRqhUnTBuyMSBPwV/ho8kJmc2yPzl5wh85OQPnz1PG4YCkf7ttyNfR5hMytWDrnKLLoF+pd0bozMbp6rqjMzplGeW78yDq3KD5EpAWEREeqM7EuFqqt+gpMoQySz78zuIpYuXmnRy7u2TBoSy8BcadoH0Ux0ABDHLzYe6DRfKVsOB6zH7sGSAAP0NQ+/JnjTen25H9grT7yhuwje/5bfzcvdKUPxyrgurtmhU6bf2v/YWyaMyi2CLrnc3s9f/YfZjSOqoFqgky49+T5irO/ygIgfobD93x5MoTSCpp4YyScIY6F/lppSaq8ApTwvQB4KXhhrY7lE8r0UYxTbRofT5wo3mL7NseLtTBqgOc53QNgsBiOczYtKTXy9XPAaBGzDUcOnX9t+A1T6SGpxFkGR0stzEyUJxRkEYD3C32y9h8Iw/StydKzfxAmqenLb5
 mROFqH5S
 cwvT4UDbEkch9WqMPZQONcK2gAGsaQ7qQ5gp8+pNckLrAeRCmfM6Z8vFedQzTHWqgM6zIYI7kLJTZveP3fi+w86DT7P4NPEwFqz3JY3zdHqAvztnbXmaUxkJcxdl5LW0VBhGh5KremB+7i7U5/48o4og665RnYcFc4a9d+Qlf+qzaaIQZDpPEXImVbtnPJzO7CpDTbwtYpLGXF+9cVzEK7uvTj6mQpAnaQ6aQrETPOPIX/hCRXARM2cffWgKm42ZfbR2xvzcCfnKCsRUwNy49DVfbJIr7Ci1ZF3rW3WVBc1Ak+oESOLsulZmnJnuiwkGBNscpGKd/XNultUGRVe5wCoyURkLOz49JukLf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kvmalloc() callers explicitly state that they do not require physically
contiguous memory, yet every request is still handed to kmalloc() first.
Above KMALLOC_MAX_CACHE_SIZE that becomes a page allocator request of the
corresponding order, which the caller cannot observe any benefit from,
but which the rest of the system pays for.

Commit 46459154f997 ("mm: kvmalloc: make kmalloc fast path real fast
path") removed the worst of it by dropping __GFP_DIRECT_RECLAIM, so the
caller no longer stalls in direct reclaim and compaction.  What is left
is cheaper, but not free:

 - the attempt takes the zone lock and either splits a higher order block
   or steals a pageblock of a different migratetype, which is precisely
   the long term fragmentation kvmalloc() was trying to avoid,

 - wakeup_kswapd() raises pgdat->kswapd_order to the requested order, so
   even an attempt that fails makes kswapd do higher order work later on,

 - when the node is balanced but too fragmented for the order,
   wakeup_kcompactd() schedules background compaction on behalf of an
   allocation that ends up in vmalloc() anyway.

Callers who would rather not pay any of this have no way to say so.
kvmalloc() has become the default way to allocate anything large, and the
overwhelming majority of its users have no use for the contiguity at all.

Add a vm.kvmalloc_max_contig_order sysctl that caps the order kvmalloc()
is willing to ask the page allocator for.  Requests above the cap skip the
kmalloc() attempt and are served by vmalloc() directly, which is the exact
path they would have taken had that attempt failed, so no semantics
change: __GFP_NOFAIL is still implemented by the vmalloc() fallback, and
the INT_MAX guard still rejects oversized requests.

Anything a kmalloc cache can serve, i.e. up to KMALLOC_MAX_CACHE_SIZE, is
deliberately left alone: it comes out of slabs shared by many objects and
is far cheaper than the vmap area, page tables and unmap-time TLB flush an
equivalent vmalloc() would cost.  That is enforced by the accepted range of
the sysctl, which starts at the order of KMALLOC_MAX_CACHE_SIZE and ends at
MAX_PAGE_ORDER, rather than by a size check on every allocation.

The default is MAX_PAGE_ORDER, which is also the largest order kmalloc()
can produce, so out of the box behavior is unchanged and this is strictly
opt-in.  PAGE_ALLOC_COSTLY_ORDER is the natural value for anyone opting
in, as it is where the page allocator itself starts treating requests as
expensive.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 Documentation/admin-guide/sysctl/vm.rst | 30 ++++++++++
 mm/Kconfig                              | 20 +++++++
 mm/slub.c                               | 78 ++++++++++++++++++++++---
 3 files changed, 121 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index b9b0c218bfb4..bc669052c50b 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -41,6 +41,7 @@ Currently, these files are in /proc/sys/vm:
 - extfrag_threshold
 - highmem_is_dirtyable
 - hugetlb_shm_group
+- kvmalloc_max_contig_order (only if CONFIG_KVMALLOC_ORDER_LIMIT=y)
 - legacy_va_layout
 - lowmem_reserve_ratio
 - max_map_count
@@ -365,6 +366,35 @@ hugetlb_shm_group contains group id that is allowed to create SysV
 shared memory segment using hugetlb page.
 
 
+kvmalloc_max_contig_order
+=========================
+
+The largest allocation order for which kvmalloc() attempts a physically
+contiguous allocation.  Requests larger than ``PAGE_SIZE << order`` are served
+by vmalloc() without attempting kmalloc() first.
+
+kvmalloc() callers state that they do not require physical contiguity, so the
+contiguous attempt is only ever an optimization for them: it saves a vmap
+area, the page tables backing it and the TLB flush when the memory is freed.
+That optimization is not free for the rest of the system, though, as high
+order requests fragment the buddy allocator and wake up kswapd and kcompactd
+even when they succeed.  On workloads where large kvmalloc() calls are
+frequent and the callers do not benefit from contiguity, capping the order is
+a net win.
+
+The default is MAX_PAGE_ORDER, which preserves the behavior of always
+attempting kmalloc() first.  Setting it to PAGE_ALLOC_COSTLY_ORDER (3) limits
+kvmalloc() to the orders the page allocator itself considers cheap.
+
+Requests up to KMALLOC_MAX_CACHE_SIZE are served by the kmalloc caches, out of
+slabs shared by many objects, which is cheaper than an equivalent vmalloc()
+would be.  The limit does not apply to them, so the accepted range runs from
+the order of KMALLOC_MAX_CACHE_SIZE up to MAX_PAGE_ORDER.
+
+Requests above KMALLOC_MAX_SIZE end up in vmalloc() whatever this is set to,
+since kmalloc() cannot serve them at all.
+
+
 legacy_va_layout
 ================
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 9e0ca4824905..9b1fcabb6d8f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -248,6 +248,26 @@ config SLUB_STATS
 	  out which slabs are relevant to a particular load.
 	  Try running: slabinfo -DA
 
+config KVMALLOC_ORDER_LIMIT
+	default n
+	bool "Allow limiting the allocation order kvmalloc() may use"
+	depends on SYSCTL
+	help
+	  kvmalloc() attempts a physically contiguous allocation before it
+	  falls back to vmalloc().  Most callers do not benefit from the
+	  contiguity in any way, yet large requests still have to be served
+	  by the page allocator, which fragments the buddy allocator and
+	  wakes up kswapd/kcompactd for no gain.
+
+	  This enables the vm.kvmalloc_max_contig_order sysctl, which caps
+	  the allocation order kvmalloc() is willing to ask the page
+	  allocator for.  Larger requests are routed to vmalloc() directly.
+
+	  The default value of the sysctl preserves the existing behavior,
+	  so saying Y here only makes the tunable available.
+
+	  If unsure, say N.
+
 config KMALLOC_PARTITION_CACHES
 	depends on !SLUB_TINY
 	bool "Partitioned slab caches for normal kmalloc"
diff --git a/mm/slub.c b/mm/slub.c
index 0337e60db5ac..0a9910602cec 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -50,6 +50,7 @@
 #include <linux/irq_work.h>
 #include <linux/kprobes.h>
 #include <linux/debugfs.h>
+#include <linux/sysctl.h>
 #include <trace/events/kmem.h>
 
 #include "internal.h"
@@ -6887,6 +6888,62 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
 	return flags;
 }
 
+#ifdef CONFIG_KVMALLOC_ORDER_LIMIT
+static unsigned int sysctl_kvmalloc_max_contig_order __read_mostly = MAX_PAGE_ORDER;
+
+/*
+ * The limit only ever applies to requests too large for a kmalloc cache, so
+ * the smallest value it can take is the order of KMALLOC_MAX_CACHE_SIZE,
+ * which is KMALLOC_SHIFT_HIGH - PAGE_SHIFT.  kvmalloc_order_denied() relies
+ * on this floor, do not lower it.
+ */
+static unsigned int kvmalloc_max_contig_order_min = KMALLOC_SHIFT_HIGH - PAGE_SHIFT;
+static unsigned int kvmalloc_max_contig_order_max = MAX_PAGE_ORDER;
+
+/*
+ * Decide whether the physically contiguous attempt is worth its cost to the
+ * rest of the system.
+ *
+ * Requests that a kmalloc cache can serve are never denied, as they come out
+ * of slabs shared by many objects and put far less pressure on the buddy
+ * allocator than the page tables, vmap area and unmap-time TLB flush a
+ * vmalloc() of the same size would cost.  No explicit check is needed for
+ * that, as the floor on the sysctl keeps the comparison below from ever
+ * denying a request that small.
+ */
+static bool kvmalloc_order_denied(size_t size)
+{
+	if (likely(sysctl_kvmalloc_max_contig_order >= MAX_PAGE_ORDER))
+		return false;
+
+	return get_order(size) > sysctl_kvmalloc_max_contig_order;
+}
+
+static const struct ctl_table kvmalloc_sysctl_table[] = {
+	{
+		.procname	= "kvmalloc_max_contig_order",
+		.data		= &sysctl_kvmalloc_max_contig_order,
+		.maxlen		= sizeof(sysctl_kvmalloc_max_contig_order),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1		= &kvmalloc_max_contig_order_min,
+		.extra2		= &kvmalloc_max_contig_order_max,
+	},
+};
+
+static int __init init_kvmalloc_sysctls(void)
+{
+	register_sysctl_init("vm", kvmalloc_sysctl_table);
+	return 0;
+}
+subsys_initcall(init_kvmalloc_sysctls);
+#else
+static bool kvmalloc_order_denied(size_t size)
+{
+	return false;
+}
+#endif /* CONFIG_KVMALLOC_ORDER_LIMIT */
+
 void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long align,
 			     gfp_t flags, int node)
 {
@@ -6899,14 +6956,21 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long
 	};
 
 	/*
-	 * It doesn't really make sense to fallback to vmalloc for sub page
-	 * requests
+	 * The limit never denies anything a kmalloc cache could have served,
+	 * so a denied request is always larger than a page and is therefore
+	 * guaranteed to be vmalloc-able.
 	 */
-	ret = __do_kmalloc_node(PASS_BUCKET_PARAM(b),
-				kmalloc_gfp_adjust(flags, size),
-				node, PASS_TOKEN_PARAM(token), &ac);
-	if (ret || size <= PAGE_SIZE)
-		return ret;
+	if (!kvmalloc_order_denied(size)) {
+		/*
+		 * It doesn't really make sense to fallback to vmalloc for sub
+		 * page requests
+		 */
+		ret = __do_kmalloc_node(PASS_BUCKET_PARAM(b),
+					kmalloc_gfp_adjust(flags, size),
+					node, PASS_TOKEN_PARAM(token), &ac);
+		if (ret || size <= PAGE_SIZE)
+			return ret;
+	}
 
 	/* Don't even allow crazy sizes */
 	if (unlikely(size > INT_MAX)) {

