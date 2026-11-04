Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7226D606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFF1tJly
Received: by kanga.kvack.org (Postfix)
	id 6129E6B05B1; Wed,  4 Nov 2026 08:01:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9BE6B05B2; Wed,  4 Nov 2026 08:01:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8A16B05B3; Wed,  4 Nov 2026 08:01:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1233C6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:01:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72A36C0732
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:01:40 +0000 (UTC)
X-FDA: 85397448360.11.F9C1B15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 48E54100008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:01:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFF1tJly;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797298;
	b=kOr97MSe4CYStLtbNAPG7VEZgBPAhMQWEQuIhPQS6/QYYCvLBGWkB5YCi7wd+sChuPAZYD
	V4jv/tNODKeGz8iujxMPzp6SmacXpP7AFOlRErTzokc01UnCsfNt9OZWFpv6icnTLVyCGq
	JHXNUrchSfHgXj7xBCNji3a7VZbeXI8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFF1tJly;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6Rfwa2eXU8GjwfNAOM4D1Li2Qxj0vjGvYHOqbKiyzU=;
	b=Both3bsPNAJgzD0s3bT2OPCFyMXdzkJiC1XPRa0tTK0C5t+n25PJwCT1eNHb++qBzZrgxk
	oOM/od+ZaLWwz39CcruvBsWmLnDST1rD86NeONnJzx1mDlN6V+gpq9MP4q2ZQRi1N8E0ZK
	d+cbBXAJ/QLzC07Ea5ePUO/EcOt0VS4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36F2B44801;
	Wed,  4 Nov 2026 13:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE231F00A1B;
	Wed,  4 Nov 2026 13:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797297;
	bh=R6Rfwa2eXU8GjwfNAOM4D1Li2Qxj0vjGvYHOqbKiyzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFF1tJlyJYDOdJ+G1lzkLhkaORtpMFMFI8OJgTM83MUD3q11lWtssNpiilFSoCkl3
	 SHSSs5nnO9Ob3qdt2tgf5OLjWaCJXQj/Jx1zfy0ZMQmh7QLjteiD9JQrrLsdeE9OWh
	 MlJ5sMm5QgDOb8SzuaKudtDSNnHMzo9cHo+W+qL1to3Qz2+UJTG3HlQhNqrhusN75w
	 rjPgm/+R7x2AmVYsuBrwjMtt0NxBc9NEBv6xxn9VNrKOdCJkSYdYaaMD+wocQJQDXP
	 kAzc73t7kHIzNFUZU30ggpwU96fF9+Q7JP5buWC4+VUEY+MtsEon50LpfRNHwyy4Tp
	 nMJixjBolz60A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id C4DFE1980054;
	Wed,  4 Nov 2026 08:01:28 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 04 Nov 2026 08:01:32 -0500
X-ME-Sender: <xms:qCzrapgBAPoJ8pQUM0P8Mqo9aaz9RnphQC_FifzmLg1ZECvMb3cd1w>
    <xme:qCzrajRRbHLbArmyYQWwbQZNy3a_lBm3M-wkGABBgqSIoM3OThuI8GU08Oq_-m-TK
    FkuQyXgZgZQGOn4H-PIAsbD5jwh-mz5X00gQN69YY3QM7RWEF1Y4GY>
X-ME-Received: <xmr:qCzraruaTyHVIW0hXmWv5ATvnjIAYja2FCTvPjK1j8Cg0Ktdu0N5gqk8G6g>
X-ME-Proxy-Cause: dmFkZTGcnWxWNdwzviArTqwO8SleswujEAoF3G5cAnzgWuj9VIXYzVn8L/YtSSoCVpDQCx
    AFAjkaMBKJDECegKseyQPi3BoJ2ULdzgEWHQh0kOOdV3qcZ96T5qYw8zvnYBduU6y+7gOl
    ju1hRqdfaUd029Zpq0M1QKVfvNYpVJXA03mIXM/FVYF2n1TVZdGxcwDBil6kVRafbiJtv0
    QuPNDwYksKVrYzT4QGS7HIxmz8ayVgiPQk5G9zoQji1nSBMTr/zV+0QH6w0a9BT4L54N+d
    cRhB7KhKgiZgmWNJc1G8l9d+gvjQ75B75nEIsy2loqzEXGvtqjUcmfJ5UhZu2fDzNX4Rjl
    vnpZ4QeNny1QYnKMwB6gIM5QdzBGfcdgkYwYw+Bd78cBJEycD5qxJfJeQdpg02UO6MFr40
    PuY5XFiV7j0UW88sAt7cVQOghCnk79NSUeG1j0WKpx0Mw9prXYAYm1V0h1acJiumLArIrN
    mqx28zKBZoQ/E0LHnYiWzd+lkMd7Xn3pBBZPzESYN2WUpKtd17mym+QTAdYju4n//gph3P
    toiWPpq4aPHfz/aQwFM4rVAZlItMOXPrI16hwJKwepRZMIp0sImFQ2artJEN6PVJR+abOP
    ohuF6ItSRUxXG8WHN3IdWlXQvu/ptYaWQol/h8hv0fjZLoqUz/jnShf7hzKQ
X-ME-Proxy: <xmx:qCzrat__E0Q-VFSBJ_57yOnyLjQS07Sht7mFFF8K6nXa9V8d_Nraug>
    <xmx:qCzranbaEu2fiRO46API7Y48dHJxr-52LO66K5PjvIupzfMOBJinzA>
    <xmx:qCzrasMabt9tFQQYYmW0EXHBVSGNyCTaMwWC62U9qmNLRI6F_tqtqw>
    <xmx:qCzravTQMBsu1sE_3MZD8H5EujKgDFuwIilvNu_XlsEwbOOVPQsPlw>
    <xmx:qCzran91T2sW8RPcdv2Z0-BFlsotCy4zl61kgfFRXDzODKdgauNa3eVg>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:01:27 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Harry Yoo <harry@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH v2 01/18] mm: free PG_rcu_free folios only after an RCU grace period
Date: Wed,  4 Nov 2026 13:00:57 +0000
Message-ID: <20261104130118.2507513-2-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: neipd5u7uiub7fqy6pppqamtnrrza6gc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48E54100008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793797298-517109
X-HE-Meta: U2FsdGVkX1/B+u7htzcnMfpOm0TPstHVgkyV7EOCoEMuv/DNDLnTALuFSpZ04to0udbLX8Blb9djYuyhaJ67YivBSF54/DjDbZfJ+Y1G0ht/Pvr7Gqk9OFxho8BYumYjf4TIwuywdw3nc6XSh/bJr4JpG0ukrEhG37/uXiDLdTYM68Z1sK+NkdmKXLOWvv8LitrZPPd17SkaGCIFDIzV+1GSzMUvSXAsyteT6hjcBEEqLOQg7hXcAUYAQpCoOXP5mLJ4uz86/Pi85swBmw38oPAU6+cRk5gpS8V6LuKDGDWAvBc+P5JefotIeqiKID2MOVZieKOvCqvq2f5TNQLsAR0Hu7xjsx9p5RffOoYEhQRRJZOPOYnH59U2RJDaA9GRfhDL5dhNnhNX9ZFlPjDbre7dxcmaskXdPU3AVX01ozStZf1kAERRi8c6CUNAYnrytFEARjp7Zu1XeG6KubZuRmgH0m/C4D6BD2m2J5Heqx0tiLKpUpFUTAa2JDQoHoMViPMvSOxqeNbr2D0lLxpcHpCM9JC/oOgOi4zIl4WBx7G2lxnrB7uUSb+QWIWUhnFNYDKsa6K4j9V/VydCEi1jZG+Gl+V8SYfusNeXeteopPebVatAq8M9mR+kwhvhqZuvWZrcjLHBj3Ff6X2VEmTIl3i7lZWYVD1BrejLZtu8Z1xWzrxdnCw61YTTTfL9G4TCotnEAtkKAvuUaQK+k0JpEcGtAv4P2xQo4su5EE3siPfvbsEW0AAHYXwl29USTLlMCMdE9xVtPHBojmQ0o/DO66CG4H1Uwi0Fl8VZy1gAj08kEdAaqhNrygGvx/wET8yhTppPeg7ZHlaTrlxoR+rCrVz5iadd6C39hWm3HvDUjE4InADg6gfbiJAU9Yq4mvR3CZp05P89Ki3W4mqbbex9Lf5Jj4+X1nLr+aKRFLICT2h0sGEK21iQGh7R2E8uTpf/yn3fWvdTLZlCmIHeJJ0
 mbQMthW6
 pTZxXO6eMio214WGbCW8++1ApuJ9vLmCeDGOLm2L555iwlb/8ipHKCUK0Et+lauirr7dILw1d3BHpwUSY/ryK2Yc40KdHMmAx8NV207BazjvczmzwTZRb0mYQEfwFw+RuTjuU0Pwx+RhiEaF2r487lVzmPy69lE9I0/ah2VZpPQsCv45MlpDpG+J69oNjxbMBPCaTUInOJXz3rfnV/nAV+X3FAToSv9dbWrbTlBnFd1onRg98sBpbca5KsSl7iN7Qb94nmFp7uVX5UoasYZ/hpB2y2y6GFT3SwFCBa272LXul65RFi9/6cs44Qw41lS6DmvPLY2RBoq0UjMiaKeLYviRJoY2AnyFZvXu20xEtyW8ptVsi5A0Rn+fP/nc8JLNYk+8t01xOA9ElQAiW2rz5udIwOfbPlOHadtGmQ+ECXOJ1Gp+3jkxdBrYb6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Linus Torvalds <torvalds@linux-foundation.org>

Reading a page cache folio without taking a reference would keep CPUs
that read the same file from bouncing its refcount.  But without a
reference the folio can be freed, and its memory reused, while the
reader copies from it.

Add PG_rcu_free: the free of a folio with the flag waits for an RCU
grace period.  A reader that saw the flag under rcu_read_lock(), and
then still found the folio where it looked, can read it until
rcu_read_unlock().  A split copies the flag, as such a reader may still
be reading the new folios.

The folios wait on per-CPU lists, one grace period in flight per CPU:
call_rcu() per folio would queue a callback for every folio of a
truncated file.  A work, which can reschedule, frees each batch.
Reclaim depends on these frees, so the workqueue is WQ_MEM_RECLAIM.

The flag is 64-bit only (CONFIG_PAGE_RCU_FREE): page flags are scarce
on 32-bit, and the contention this avoids is a problem of large
machines.  It is off on PREEMPT_RT, where expedited grace periods are
normal ones, so the waiting pages cannot be freed quickly when memory
runs short.

pgfree_rcu in /proc/vmstat counts the deferred pages.  Nothing sets the
flag yet.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[kas: rework for flagging at read time, 64-bit only and not PREEMPT_RT,
 shorter comments and changelog]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/page-flags.h     |  21 +++++++
 include/linux/vm_event_item.h  |   1 +
 include/trace/events/mmflags.h |   7 +++
 mm/Kconfig                     |  15 +++++
 mm/huge_memory.c               |   1 +
 mm/memory-failure.c            |   4 ++
 mm/page_alloc.c                | 105 +++++++++++++++++++++++++++++++++
 mm/vmstat.c                    |   1 +
 8 files changed, 155 insertions(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7a863572adce..a1e52a1f8a52 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -111,6 +111,9 @@ enum pageflags {
 	PG_swapbacked,		/* Page is backed by RAM/swap */
 	PG_unevictable,		/* Page is "unevictable"  */
 	PG_dropbehind,		/* drop pages on IO completion */
+#ifdef CONFIG_PAGE_RCU_FREE
+	PG_rcu_free,		/* free only after an RCU grace period */
+#endif
 #ifdef CONFIG_MMU
 	PG_mlocked,		/* Page is vma mlocked */
 #endif
@@ -602,6 +605,24 @@ FOLIO_FLAG(dropbehind, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(dropbehind, FOLIO_HEAD_PAGE)
 	__FOLIO_SET_FLAG(dropbehind, FOLIO_HEAD_PAGE)
 
+/*
+ * A lockless lookup that sees PG_rcu_free and then still finds the folio
+ * where it looked may read it until rcu_read_unlock().  Set under a
+ * reference, cleared only by the free.  Not for hugetlb or
+ * free_pages_nolock().
+ */
+#ifdef CONFIG_PAGE_RCU_FREE
+FOLIO_TEST_FLAG(rcu_free, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_SET_FLAG(rcu_free, FOLIO_HEAD_PAGE)
+	__FOLIO_CLEAR_FLAG(rcu_free, FOLIO_HEAD_PAGE)
+#define __PG_RCU_FREE (1UL << PG_rcu_free)
+#else
+FOLIO_TEST_FLAG_FALSE(rcu_free)
+	FOLIO_TEST_SET_FLAG_FALSE(rcu_free)
+	__FOLIO_CLEAR_FLAG_NOOP(rcu_free)
+#define __PG_RCU_FREE 0
+#endif
+
 #ifdef CONFIG_HIGHMEM
 /*
  * Must use a macro here due to header dependency issues. page_zone() is not
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 2628ccda076a..cbe849701653 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -36,6 +36,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(ALLOCSTALL)
 		FOR_ALL_ZONES(PGSCAN_SKIP)
 		PGFREE, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE,
+		PGFREE_RCU,
 		PGFAULT, PGMAJFAULT,
 		PGLAZYFREED,
 		PGREUSE,
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 935893e5ea53..47c3411a75e8 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -117,6 +117,12 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 #define IF_HAVE_PG_IDLE(_name)
 #endif
 
+#ifdef CONFIG_PAGE_RCU_FREE
+#define IF_HAVE_PG_RCU_FREE(_name) ,{1UL << PG_##_name, __stringify(_name)}
+#else
+#define IF_HAVE_PG_RCU_FREE(_name)
+#endif
+
 #ifdef CONFIG_ARCH_USES_PG_ARCH_2
 #define IF_HAVE_PG_ARCH_2(_name) ,{1UL << PG_##_name, __stringify(_name)}
 #else
@@ -152,6 +158,7 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 	DEF_PAGEFLAG_NAME(swapbacked),					\
 	DEF_PAGEFLAG_NAME(unevictable),					\
 	DEF_PAGEFLAG_NAME(dropbehind)					\
+IF_HAVE_PG_RCU_FREE(rcu_free)						\
 IF_HAVE_PG_MLOCK(mlocked)						\
 IF_HAVE_PG_HWPOISON(hwpoison)						\
 IF_HAVE_PG_IDLE(idle)							\
diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..6e5341b0bf64 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -718,6 +718,21 @@ config PCP_BATCH_SCALE_MAX
 	  latency.  This option sets the upper limit of scale factor to limit
 	  the maximum latency.
 
+config PAGE_RCU_FREE
+	def_bool y
+	depends on 64BIT
+	depends on !PREEMPT_RT
+	help
+	  Reads from the page cache can copy from folios that are read
+	  again and again without taking a reference on them, so small
+	  reads of one file from many CPUs do not contend on the folio's
+	  reference count.  The cost is that memory freed from such
+	  folios becomes reusable only after an RCU grace period.
+
+	  64-bit only: it takes a page flag, and those are scarce on
+	  32-bit.  Not on PREEMPT_RT, where expedited grace periods are
+	  normal ones, so freeing the waiting pages on demand would stall.
+
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1e5d68acf62a..25082949a4ca 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3743,6 +3743,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 #endif
 				 (1L << PG_dirty) |
 				 (1L << PG_dropbehind) |
+				 __PG_RCU_FREE |
 				 LRU_GEN_MASK | LRU_REFS_MASK));
 
 		new_folio->mapping = folio->mapping;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a8b03e2920ba..7dde7c3c9a0c 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -211,6 +211,10 @@ static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, boo
 			return false;
 	}
 
+	/* The free of a hwpoisoned page is not deferred: wait for readers */
+	if (release && folio_test_rcu_free(page_folio(page)))
+		synchronize_rcu();
+
 	SetPageHWPoison(page);
 	if (release)
 		put_page(page);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..a371e92da273 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1313,6 +1313,96 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
+/*
+ * Each CPU has at most one grace period in flight (@queued), covering
+ * @batch.  Folios freed meanwhile wait on @pending for the next one.
+ */
+struct rcu_free_pcpu {
+	spinlock_t lock;
+	bool queued;
+	struct list_head pending;
+	struct list_head batch;
+	struct rcu_work rwork;
+};
+
+static DEFINE_PER_CPU(struct rcu_free_pcpu, rcu_free_pcpu);
+
+static struct workqueue_struct *rcu_free_wq __ro_after_init;
+
+static void rcu_free_start(struct rcu_free_pcpu *r)
+{
+	lockdep_assert_held(&r->lock);
+
+	if (r->queued || list_empty(&r->pending))
+		return;
+
+	list_splice_init(&r->pending, &r->batch);
+	r->queued = true;
+	WARN_ON_ONCE(!queue_rcu_work(rcu_free_wq, &r->rwork));
+}
+
+static void rcu_free_pages(struct list_head *list)
+{
+	struct folio_batch fbatch;
+	struct folio *folio, *next;
+
+	folio_batch_init(&fbatch);
+	list_for_each_entry_safe(folio, next, list, lru) {
+		if (!folio_batch_add(&fbatch, folio)) {
+			free_unref_folios(&fbatch);
+			cond_resched_tasks_rcu_qs();
+		}
+	}
+	if (folio_batch_count(&fbatch))
+		free_unref_folios(&fbatch);
+}
+
+static void rcu_free_workfn(struct work_struct *work)
+{
+	struct rcu_free_pcpu *r = container_of(to_rcu_work(work),
+					       struct rcu_free_pcpu, rwork);
+	LIST_HEAD(done);
+
+	spin_lock_irq(&r->lock);
+	list_splice_init(&r->batch, &done);
+	r->queued = false;
+	rcu_free_start(r);
+	spin_unlock_irq(&r->lock);
+
+	rcu_free_pages(&done);
+}
+
+static void rcu_free_defer(struct folio *folio)
+{
+	struct rcu_free_pcpu *r = raw_cpu_ptr(&rcu_free_pcpu);
+	unsigned long flags;
+
+	spin_lock_irqsave(&r->lock, flags);
+	list_add_tail(&folio->lru, &r->pending);
+	rcu_free_start(r);
+	spin_unlock_irqrestore(&r->lock, flags);
+}
+
+static void __init rcu_free_init(void)
+{
+	int cpu;
+
+	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
+		return;
+
+	rcu_free_wq = alloc_workqueue("rcu_free",
+				      WQ_MEM_RECLAIM | WQ_PERCPU, 0);
+
+	for_each_possible_cpu(cpu) {
+		struct rcu_free_pcpu *r = per_cpu_ptr(&rcu_free_pcpu, cpu);
+
+		spin_lock_init(&r->lock);
+		INIT_LIST_HEAD(&r->pending);
+		INIT_LIST_HEAD(&r->batch);
+		INIT_RCU_WORK(&r->rwork, rcu_free_workfn);
+	}
+}
+
 static __always_inline bool __free_pages_prepare(struct page *page,
 		unsigned int order, fpi_t fpi_flags)
 {
@@ -1327,6 +1417,19 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
+	/*
+	 * Not for a hwpoisoned order-0 page: it never reaches the allocator,
+	 * and page_handle_poison() takes a reference right after this free.
+	 */
+	if (unlikely(folio_test_rcu_free(folio)) &&
+	    !(PageHWPoison(page) && !order)) {
+		VM_WARN_ON_ONCE(fpi_flags & FPI_NOLOCK);
+		__folio_clear_rcu_free(folio);
+		count_vm_events(PGFREE_RCU, 1 << order);
+		rcu_free_defer(folio);
+		return false;
+	}
+
 	trace_mm_page_free(page, order);
 	kmsan_free_page(page, order);
 
@@ -6401,6 +6504,8 @@ void __init setup_per_cpu_pageset(void)
 	for_each_online_pgdat(pgdat)
 		pgdat->per_cpu_nodestats =
 			alloc_percpu(struct per_cpu_nodestat);
+
+	rcu_free_init();
 }
 
 __meminit void zone_pcp_init(struct zone *zone)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index cb57714539fb..66ed017bde46 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1343,6 +1343,7 @@ const char * const vmstat_text[] = {
 	[I(PGACTIVATE)]				= "pgactivate",
 	[I(PGDEACTIVATE)]			= "pgdeactivate",
 	[I(PGLAZYFREE)]				= "pglazyfree",
+	[I(PGFREE_RCU)]				= "pgfree_rcu",
 
 	[I(PGFAULT)]				= "pgfault",
 	[I(PGMAJFAULT)]				= "pgmajfault",
-- 
2.54.0


