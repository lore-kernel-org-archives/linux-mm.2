Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F41776098A18
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A2SWU1YD
Received: by kanga.kvack.org (Postfix)
	id 138C96B02BA; Mon, 19 Oct 2026 11:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111596B02BC; Mon, 19 Oct 2026 11:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF32F6B02BD; Mon, 19 Oct 2026 11:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC06B6B02BA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:49:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50A091406DB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:49:35 +0000 (UTC)
X-FDA: 85339810710.30.86937B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 490D2100004
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:49:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A2SWU1YD;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792424973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Nw+dRp3BsamXDt/gXHq20wL6FIVWvA/eL2Wq+/2wtQ=;
	b=AbPNYBj9uBW1gnkUIco6PmNFtQtj63dzEufSEu5gZzZwfrAuh+WzrdfGBP2j0iUJ0lHtzi
	XEnLW8CrbqWaYWlo2GMXTl+qnquG1mUa0Vnz2HJZhUiWl9gio7vzHMP8RJ6Fa1noNCUBod
	QpGhpC7X4yuR9RAc7WdS3P9F7AAh+dE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792424973;
	b=SIyCUBeOdSmGRRHG6mVh6aY6TVEaGX9FLtNjpxsd1DO+OlUENONbzNYi3d41Rj5mFhZFgZ
	IOcZyZ/RzVC31ZuLRrsP8EzwHv3d1RYuXpTZgZXesqCRBoUuAznVsC6DgNWJP/QkOGqz9r
	lHzrD30d8DixVrGxKTGl1/G0IouGj5w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A2SWU1YD;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74DA443DBA;
	Mon, 19 Oct 2026 15:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05651F00ADF;
	Mon, 19 Oct 2026 15:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792424972;
	bh=5Nw+dRp3BsamXDt/gXHq20wL6FIVWvA/eL2Wq+/2wtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2SWU1YD2gmUSdWCu5DLVytZUw5Py0fBrWGuTB0H5kdVTyDuVh9DuTyMPkLzwu5qE
	 J/MSvca/T8QWhr+3Ax0FXhcZly1nrzFloa2VYh6xUM8qYRfCegiNlOHWvQu/hxzrLF
	 c8zkYzZ7bMgT1qlUKlmt8C/PFkaSIaGmPNbaFVCSxw7Nk0gnGqEC7qSloqN7UC5kOi
	 Mobb7DCoyYkHWtv9dvFffZ9Z7ysyoKabAxVGb4nbc6KAy+5HqtPjC5KfBsiNRYfHtK
	 CsttFzVG4NX8Ysr/J3DRrrURNY2l5KkCWMQVvNzOt0kXWVXOSWrvf7HKyMg7AyZzuv
	 q/1JgL0FL+S3w==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.ams.internal (Postfix) with ESMTP id 46C781980047;
	Mon, 19 Oct 2026 11:49:23 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 19 Oct 2026 11:49:28 -0400
X-ME-Sender: <xms:AzzWavEvajVicTgJMss2wI1uROdTwu06WDtuBR0te8Tc-yyqfDZJTg>
    <xme:AzzWat0LPBeoFs_y40xCqE4TVDKYDfq6AfE9YgSnYIPhrI1kotzMoKPA2daTgGfGl
    RTcGRkP8pQTBk4fARNtue_WUERxovDtq5H92HMAjl4BOEveSW7dGSL7>
X-ME-Received: <xmr:AzzWapwpDiIIiQEIJsb5xjsBqialvL5abOj_6gA0HrlXxI2la24xnAux8U8>
X-ME-Proxy-Cause: dmFkZTESqR4vElUNfwe4Wb1kabMg9MdYUtHyNIvlHi5jfGRsEd0tjiYfzpqh5FemuLlMuA
    +QzWL/iolJzzDzQk8vzuoT2/u2xyL/YZG/CihU2eaSQe3uAw7YKu/Z/hQfgMIJpEQrBQkK
    hH3KJVpCmjg+gNXnnOIkdBMKpJa1pvTLqzuojrt68Uovke10kpOzVhZrNEf3d58NDgoR+6
    GBwzdAiHoLFFDGJo3/r+XBHeUTBbw+IeFaYdgC0j5JEQlKAOMB5I7tBUfVMuw5hMfUnXf2
    vE1DwOk7N/x2FbtU++Y3QX/1ODQhD5sTVGp3EMvK4jUTItTZrn4RBPsK+PhnbeHfl8JcOK
    eC93Uux4gzDYkGL3LunO0coPzmDCOalx65wUsbcyE59TK2N8vbmnx/aORMfTFkjXU6EQa2
    mvfPQs1C5tE6wzAWQ4KD9dF07RoozXA2WCG/KEiETgzvG/4lg3sjD1CtDs+wka96IlgryC
    P3OuWIy05RuEXEfkgI1DdKyHfBIuYnnpY2rMFCYc0GWetFEbb36i18ArZE6KO7h4T1BDlj
    9xsAsKEhI2XclfxVGU9Cb7sYpyUQzlQ1i5HYHsKck+DBb3JNGeyVRVXwi5QapHcy8Fzr8l
    zk24zapjBXVNhkeLB6VEhlwqLebKeilb4kWe1F/FHBK5qEyPFy0X/65SepTA
X-ME-Proxy: <xmx:AzzWavHxkiJnmEEpQZiznBQjxd0P3KcQ5XrpsricoeMVSTLdGxpQ0g>
    <xmx:AzzWaorDmw31xAOF0GJN8Ma19OOZLE8MemPwg-IY1R475B-It64jXg>
    <xmx:AzzWal2DE28L_LKuifAnxtBR5_0jsXZf7ykYvQhxzPcjFIIlOLtmSA>
    <xmx:AzzWahlzbztQvbdoBAsxmChlmGKkqG0qNq9LfX9bjmz36dc2Arwf-Q>
    <xmx:AzzWaonhalMgAJnM8vRePPJTMykAfycyPjaAD_HHojUhRO3QZc-z0Xjl>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:49:22 -0400 (EDT)
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
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
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
	"Paul E . McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH 01/18] mm: free PG_rcu_free folios only after an RCU grace period
Date: Mon, 19 Oct 2026 16:48:54 +0100
Message-ID: <20261019154913.1765974-2-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 490D2100004
X-Stat-Signature: qbdd5r3cfffykz889k4dreu9f6w6dpr8
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792424973-925423
X-HE-Meta: U2FsdGVkX19aLi6R8CU5xGqIxlPjHRaIwV21L2DEC4pIYmN9PXDDOT1YCF/JsddBwP4XMuR5CangIO1lvgB5K7EVnlE+J2RBnccH8xDIBzoGbnQ0WTrJCBogymcWpT6uRfilhNNXPCJEF+bnDiJ85JlHWgpeCPbSUwblqsiH0IdQWAZpKq+LMJsW7j91D9iQSQEPWGLYtg4chg476VXj/2Ty42pLqsKhBK2Ii0SKfIrBp0aYM3tteWNIeITRYDz73s8zFpOY32uBfhoUaYGMa5YnS59QwETS2nJL5QSKsZi2aO+HhDiWnp3Al4kD3rszF8CeM6hiCyLGsJiztqSA8+OyUXEGBULXIqQQIsFhxWo91FucYmadIne119w+MIv+lBNvm/PFlIgFgJ3KB1O/EmA0ykpNtJizaJ5iJ7VJD/WJvfGlkNnSoE1elHvXzJWBhYIiikbFTlmNSaZCaD5bxZWjMrE1w8x5bKbWyIcisKKumkJgrwH8xpSXbOYZZkusLVoO/6wS0/ntoZOd01FyIBhfc/g3XABa1w2hrL+v0LcEnfTuvjzxSAJdDpcnisVd6ANfbRQviziTMnQUbw8JGzawy4O0Uj+vgfMis5nEUKeA1zlCi5c1c4xlOiHqmLD0j0IgR4fQMkWKtakW4UJQUrs6HdhalqE/SD+2SPpO5j1cR+fB3FBAX1/fxw0+l6aTgOcACQHD16B/rphz9SXIXK1Xluo6jn4HI+D4k0Vx0mgjfmyEAcaLBz/oSfLqNew8zo2vqVXWJOUIqLblqmuTpU6FBCZdB9ndfMDzvm0+MMQ25js6UvnEAGsylJ7mr0z16gQ7S8huva/SEJRvxyOgMAalpind0YbHJWjsmAJIFQ5SFM8jJFt3Vkum1FXGtc9m4XZzCyF+HrJQ/EzcyV/hUS4JmGNHlx0HhmDzAlP6ioVxj5kL74wmeq1UpEhfUcgInsf6SM15pIuJ2jWbncQ
 M2DbtNje
 5BG2d0I26zCrEA7wt1TGMlTrnczxFJPLwXvzb8YMGigh7GVu2zQaJ2DY80IIFlChrKfwJrx6PC6ZyBM6EvR30TQvn4k28viI5FnHdgFsB6ALp6I7V2yhgem66fH4L4L1WPRaSuOdVO9Y7+5LX3mY8X2oSh69BIfzS3wMYIgfM2wRccZNEgEauesvdssF9FWV0JSE8B/aFwkAREd2AVRo61wtgAqNe3PnlGg/l81xHAo4Lituzv5ODJmAPoMmvobcj1GO2BYMbRd79pXmSFeLtbTn2fkXZ1pXrIxgxTnUHFrUee9txOx05N7xYVYvBoVWwRc+e6Udl6RC6CVeZKCd1jQFNZlb77avL6zIvmefjBfoznL0CbNoDA17WoChHpGfqIL1PP2lsR3lrD7uDkfqjRSXE5wEd8B1VwwIyrZ8xF0k+JcDSFM7PDNRBbw==
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
machines.

pgfree_rcu in /proc/vmstat counts the deferred pages.  Nothing sets the
flag yet.

Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[kas: rework for flagging at read time, 64-bit only, shorter comments
 and changelog]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/page-flags.h     |  21 +++++++
 include/linux/vm_event_item.h  |   1 +
 include/trace/events/mmflags.h |   7 +++
 mm/Kconfig                     |  12 ++++
 mm/huge_memory.c               |   1 +
 mm/memory-failure.c            |   4 ++
 mm/page_alloc.c                | 105 +++++++++++++++++++++++++++++++++
 mm/vmstat.c                    |   1 +
 8 files changed, 152 insertions(+)

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
index 604c58199acb..5af00db23f90 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -718,6 +718,18 @@ config PCP_BATCH_SCALE_MAX
 	  latency.  This option sets the upper limit of scale factor to limit
 	  the maximum latency.
 
+config PAGE_RCU_FREE
+	def_bool 64BIT
+	help
+	  Reads from the page cache can copy from folios that are read
+	  again and again without taking a reference on them, so small
+	  reads of one file from many CPUs do not contend on the folio's
+	  reference count.  The cost is that memory freed from such
+	  folios becomes reusable only after an RCU grace period.
+
+	  64-bit only: it takes a page flag, and those are scarce on
+	  32-bit.
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


