Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1DD5C9830E
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 01:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38AE36B0005; Fri, 16 Jan 2026 20:07:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338E76B0088; Fri, 16 Jan 2026 20:07:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237C36B0089; Fri, 16 Jan 2026 20:07:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10BD76B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:07:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91FD3B7C08
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:07:14 +0000 (UTC)
X-FDA: 84339667188.13.ABE3D68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 146A2120009
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:07:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sXJ14kh+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768612033; a=rsa-sha256;
	cv=none;
	b=dAOlFqIsMPCT8vE4Wqm7IDbAI24n9/kyM1ykHh3X7mGijipmH4cJZgs/7ILVU2ys9g/2KA
	W6eqkZ5zGskc2vlI7PULofMereIzwVBAbbrUkXu3ne5G22rdjjxTYqkwDvoAl1LkLqyXHj
	vt/t2+mEm63TKW3cpaNqy5JK42yMZ4Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sXJ14kh+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768612033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTzsMW0uWZWElBoe6I6mi7ljNA7eSaPWdC16tQrqxHE=;
	b=wS6jPqbt/Mw67Vy1q5+AevZIBiJ4tMZxFErpWaOij55/uIKZk2/8QB5GSokJEKGqQyaIoD
	fW3Our63pAZHVG3pjCk2pZnFmsBnxn3U0DvUGZ3098J8WHfDkoeIFDXuttcZZJOj5ePbgb
	41eiMZZbRp5d0FqF7Xouc9rVsGPQv/Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FFC560127;
	Sat, 17 Jan 2026 01:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80632C116C6;
	Sat, 17 Jan 2026 01:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768612031;
	bh=Yb4v3IajHaFF5TUgV9j7J4S6o9nlOQUjjSjdutEwvZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXJ14kh+megJR7ZOJymB4hVjgWQBTshQgWAykPvbODTIMgJBlTSk/DaQoHenmk21y
	 21PeMOXoVGnOPPx4zOtNaGYWrt1L6gGQqBA3oxqRPlxnL++iZ6oC9Anz/sIElqByzm
	 yuEpQXXvsdb+p3y/4auAV++rBvZgKfaPome271UnCHY6jxXZmpwdmDRh52xpP0Yj88
	 a7jbSPDLSyD0Vr375udWQlgyjbCK11jkGP6DlFvzo6sYAwDLAW+czzdqCGkKpm34Ij
	 G8Rbg4FKg54onWj2NLup2HUjqV2q91UBle7ge9YfaohoZBQ1SQvPVu5brs/HXa78fO
	 HpZUnfUJmCCtw==
From: SeongJae Park <sj@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	kernel test robot <lkp@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	chrisl@kernel.org,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and vms_clear_ptes()
Date: Fri, 16 Jan 2026 17:07:06 -0800
Message-ID: <20260117010707.202128-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <vcxnsoihqohhmgurdkbx2hvybuhaql7yruv45k63jwevlpkdod@4eugq6xubcug>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 146A2120009
X-Rspamd-Server: rspam06
X-Stat-Signature: 5ed96q458enbdhyh1stq5t65qjjtsjij
X-Rspam-User: 
X-HE-Tag: 1768612032-76024
X-HE-Meta: U2FsdGVkX18GbPXlH0UO4JreHaplMId99qzY/7kFViraRBDh5IlC5FOoHyogZi2Op38uzJTZNkLjWg+8wGlGVI3UhY2fmsiQDSyXKBqt/POWsm6HCwxfpMmnYAV9L04V1es4ByeanlwcO7Iz35ycPPeqlOukEOvUysizkTq6ZzgWw2uSp7ykdwjFCNYEnOsic7CBmBPpO4xeaRPI7Fx5RWTRHkRrh16kQuZ90sSHmEmGw/GIuRxETDvuqJk1JUw/3L9iwM+hZQ9xRBRBx203H0TulSPxdSmN0bfQzxjsjAFao8Do+wJ6prRIC43wXOFNWg2udx5G+ov2BUfd2kQ8WYgZldJmGJfviAglZsnDByjCfB60jotVKP5w+mqC3DeZkH7hhLoJXp6il+re3+8JGEB00hf4xsa3csFdKOLTdqdGBYM2ine72FfEhXEA6/Ttu98IijEUebimD8euPcNOg0DpmaX4VkLSAy0Z8qBo9Ka6GdI/VBz2vZH+cZxQ3zSP63SHshzidJqp1ECet3V0aOsRW+Lu1d0OVE4UK7yeaMkIu4wiyd6yh4atKuuiqTG5mxfNUcF1KTOCqe7Cq1h54ek8uQ57TWQUtwxqlHmsprQFrsiPFT41Totukt386a+Vx2cLZNT9pqAMHyB5Ixzmbs4MClGmnuSIwv196Y0U7MfYCXozK3IABF6Xl4l/PEmgZci+ZKUhKOtOEat0Ix3SeRXbjwP425C8IE6TzFLQJS2KAf92RphGQ9ZfvJJGEa7LVHs5yF0/xWWlcas4hiH0vC8QG0kdLoAsQdlk8nxRw47bl3btft6FzBMSlhvX3BgR6yy4Vw26yg312DYn3pjvYNne8ftLmIFdZSDa6Fkzg2qXY6v0SlY/KiMm3IhXgLjOfRsZT77uWKU0vDswdNSetsu1sIS9sXBQKlL4PaR2GMSFp9aeExOr9zhm/86VJOH8W09F5M9yOknrz5U+RYs
 yJ5uH6N8
 r8SIq9V9jHo6HL8Pa1ZQGJCtSnqSJ/iL/KDuW03+hFavH5pzT4xVn6YP+ipuUi4Qu1OBNDNFP7vQazXDW2huk3Ywe87e9WOfeIMGgBQGe6VduCAlcXzL8d+2b/Z8nyEaEE7TqHzC+QrgmrUUUcyVhlOQOyc88IwNTNGhrl5U0JM6Ub5JJ0mcvsrTgJjhCyYA6cyaQUk/XaRIXkG4HNRXCQEJaOJXIpPBuTcNNYxE9uolAAjK87zjMf8U54gS17PJ+bLOVjceSkqFrrhFRHLtoKaxnbY/1UwHyzA0E8tCUFMoPA0PzOhuoSOvlyYNEAFkkKj0czSn62kf/ZUvBCH2XLbwi42ji0rD/9//D3bVDm4znoo0PVIXKn5ILuQfrSUoXqg34UFz412IZbqfowTcsc79jmzIuOhJ8N/iZcK0yROch0XN4AenuNrz3SQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 11:15:43 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260116 03:27]:
> > On Fri, Jan 16, 2026 at 10:04:27AM +0800, kernel test robot wrote:
> > > Hi Liam,
> > >
> > > kernel test robot noticed the following build errors:
> > >
> > > [auto build test ERROR on akpm-mm/mm-everything]
> > > [also build test ERROR on linus/master v6.19-rc5 next-20260115]
> > > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > > And when submitting patch, we suggest to use '--base' as documented in
> > > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> > >
> > > url:    https://github.com/intel-lab-lkp/linux/commits/Liam-R-Howlett/mm-mmap-Move-exit_mmap-trace-point/20260116-023126
> > > base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> > > patch link:    https://lore.kernel.org/r/20260115182720.1691130-9-Liam.Howlett%40oracle.com
> > > patch subject: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and vms_clear_ptes()
> > > config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20260116/202601160925.VR8a2hUw-lkp@intel.com/config)
> > > compiler: m68k-linux-gcc (GCC) 15.2.0
> > > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601160925.VR8a2hUw-lkp@intel.com/reproduce)
> > >
> > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202601160925.VR8a2hUw-lkp@intel.com/
> > >
> > > All errors (new ones prefixed by >>):
> > >
> > >    In file included from mm/internal.h:23,
> > >                     from mm/filemap.c:54:
> > >    mm/vma.h: In function 'unmap_all_init':
> > > >> mm/vma.h:175:27: error: 'FIRST_USER_ADDRESS' undeclared (first use in this function)
> > >      175 |         unmap->pg_start = FIRST_USER_ADDRESS;
> > >          |                           ^~~~~~~~~~~~~~~~~~
> > >    mm/vma.h:175:27: note: each undeclared identifier is reported only once for each function it appears in
> > > >> mm/vma.h:176:25: error: 'USER_PGTABLES_CEILING' undeclared (first use in this function)
> > >      176 |         unmap->pg_end = USER_PGTABLES_CEILING;
> > >          |                         ^~~~~~~~~~~~~~~~~~~~~
> > >
> > 
> > Suspect you need to add:
> > 
> > #include <linux/pgtable.h>
> > 
> > to mm/vma_internal.h.
> > 
> > Some arches don't define it and that header has:
> > 
> > #ifndef USER_PGTABLES_CEILING
> > #define USER_PGTABLES_CEILING	0UL
> > #endif
> > 
> > ...
> > 
> > #ifndef FIRST_USER_ADDRESS
> > #define FIRST_USER_ADDRESS	0UL
> > #endif

But the macro definitions are enclosed by '#ifdef CONFIG_MMU'.  I have
!CONFIG_MMU build test, which shows similar errors, even after Lorenzo's
suggestion is applied.  Should we move the definitions out of the '#ifdef
CONFIG_MMU', or implement another unmap_all_init() for !CONFIG_MMU case?

I confirmed a simple version of the first option (moving definitions out of
CONFIG_MMU, in addition to including pgtable.h) like below works at least for
my !CONFIG_MMU test.


Thanks,
SJ

[...]
=== >8 ===
From d5b441af2f31164a46240ce4179db8e0d2fff372 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Fri, 16 Jan 2026 17:01:27 -0800
Subject: [PATCH] mm/vma: temporal build fix

Link: https://lkml.kernel.org/r/20260115182720.1691130-9-Liam.Howlett@oracle.com
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/pgtable.h | 38 +++++++++++++++++++-------------------
 mm/vma_internal.h       |  1 +
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index ce2dbebade4c..4f063438a4fc 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -22,25 +22,6 @@
 #error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{P4D,PUD,PMD}_FOLDED
 #endif
 
-/*
- * On almost all architectures and configurations, 0 can be used as the
- * upper ceiling to free_pgtables(): on many architectures it has the same
- * effect as using TASK_SIZE.  However, there is one configuration which
- * must impose a more careful limit, to avoid freeing kernel pgtables.
- */
-#ifndef USER_PGTABLES_CEILING
-#define USER_PGTABLES_CEILING	0UL
-#endif
-
-/*
- * This defines the first usable user address. Platforms
- * can override its value with custom FIRST_USER_ADDRESS
- * defined in their respective <asm/pgtable.h>.
- */
-#ifndef FIRST_USER_ADDRESS
-#define FIRST_USER_ADDRESS	0UL
-#endif
-
 /*
  * This defines the generic helper for accessing PMD page
  * table page. Although platforms can still override this
@@ -1660,6 +1641,25 @@ void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
 
 #endif /* CONFIG_MMU */
 
+/*
+ * On almost all architectures and configurations, 0 can be used as the
+ * upper ceiling to free_pgtables(): on many architectures it has the same
+ * effect as using TASK_SIZE.  However, there is one configuration which
+ * must impose a more careful limit, to avoid freeing kernel pgtables.
+ */
+#ifndef USER_PGTABLES_CEILING
+#define USER_PGTABLES_CEILING	0UL
+#endif
+
+/*
+ * This defines the first usable user address. Platforms
+ * can override its value with custom FIRST_USER_ADDRESS
+ * defined in their respective <asm/pgtable.h>.
+ */
+#ifndef FIRST_USER_ADDRESS
+#define FIRST_USER_ADDRESS	0UL
+#endif
+
 /*
  * No-op macros that just return the current protection value. Defined here
  * because these macros can be used even if CONFIG_MMU is not defined.
diff --git a/mm/vma_internal.h b/mm/vma_internal.h
index 2f05735ff190..2da6d224c1a8 100644
--- a/mm/vma_internal.h
+++ b/mm/vma_internal.h
@@ -46,6 +46,7 @@
 #include <linux/swap.h>
 #include <linux/uprobes.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/pgtable.h>
 
 #include <asm/current.h>
 #include <asm/tlb.h>
-- 
2.47.3



