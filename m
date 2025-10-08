Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AD06CCA472
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 12:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C781F8E0025; Wed,  8 Oct 2025 08:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4FE78E0002; Wed,  8 Oct 2025 08:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8CFF8E0025; Wed,  8 Oct 2025 08:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A87E78E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:54:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68191596C3
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:54:48 +0000 (UTC)
X-FDA: 83974941456.27.1A93D04
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	by imf03.hostedemail.com (Postfix) with ESMTP id 244F22000D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:54:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=s02w6y8m;
	spf=pass (imf03.hostedemail.com: domain of "prvs=3690e73b8=acsjakub@amazon.de" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=3690e73b8=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759928086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZRDeMLmMEK6yn6l4ewtwCCdRu9Khsl3Xp6VISO2xrwE=;
	b=RLLyFid0nXYbaSj1+1l3z6n5V9paT4T6hcF+TyPN8cYsuzHQLCoQthgicKsWCo7NETx0DE
	b6g6L3uUxJQjaMbu07yffm1Bql+soue+iCsLaNNMyCDPyogR5NtLlq+LXHC+vQdKQc68md
	qxjvfV4JezbqtL9iScy+fbQKZBbRmO0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=s02w6y8m;
	spf=pass (imf03.hostedemail.com: domain of "prvs=3690e73b8=acsjakub@amazon.de" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=3690e73b8=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759928086; a=rsa-sha256;
	cv=none;
	b=0SWKInLfL4IfZQkHmcJUsi+oZLOt3+3WfIRgvWq10+JfDD2FKpb00Co+pZva19dEqW2u3n
	+auF8vfFFww4usdc0sVRUxUIyRA+Ms+wEr24ULoof23VrLJCYrQ6m0uw9WUAAkX1or9iXj
	zPJ7mFJA9RC+UvadXZGxxNItiQU6Uro=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1759928086; x=1791464086;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZRDeMLmMEK6yn6l4ewtwCCdRu9Khsl3Xp6VISO2xrwE=;
  b=s02w6y8m2+3glXSOeOd/olsTC2zFI/ZEXw/61C5Sef6IhZLDwgE8EZQo
   WUYe42TPTEQcGgRqXfb5nPhTnE+/b6TQ3gw7r3t71g/imHM87z4Sk7iXl
   /i1Br07Yz/l3Pzgmz/nXIBlIs0udM+e0rGHwRTp5RhEWbAilmy18dfEHn
   xchSWeII3xUpzDo/JR147mezyt7hs3jwr0SNXfvnzJzyDCrZdFE3RLgHs
   Be9Ftp3RkFtPRjPmP1JCUzW/I+FvQzCMM0tlVXwifJCPibP93UYeozjT0
   VPsaEmuXSC/h0Jz2peMVNc3fve5XybfmjuMp6QPRN/r/XGknPvRxf8QkY
   Q==;
X-CSE-ConnectionGUID: mLsNYFOJRhSzPy7GhW1xEw==
X-CSE-MsgGUID: Jm0hr+PXQjSTK4ngOiWpag==
X-IronPort-AV: E=Sophos;i="6.18,281,1751241600"; 
   d="scan'208";a="4518957"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 12:54:43 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.21.151:27609]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.20.71:2525] with esmtp (Farcaster)
 id 1b53c0ac-769c-46a7-ba29-79ccaadef900; Wed, 8 Oct 2025 12:54:43 +0000 (UTC)
X-Farcaster-Flow-ID: 1b53c0ac-769c-46a7-ba29-79ccaadef900
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 12:54:42 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 12:54:40 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: <aliceryhl@google.com>, <djwong@kernel.org>
CC: <jhubbard@nvidia.com>, <acsjakub@amazon.de>, <akpm@linux-foundation.org>,
	<axelrasmussen@google.com>, <chengming.zhou@linux.dev>, <david@redhat.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <peterx@redhat.com>, <rust-for-linux@vger.kernel.org>,
	<xu.xin16@zte.com.cn>
Subject: [PATCH] mm: use enum for vm_flags
Date: Wed, 8 Oct 2025 12:54:27 +0000
Message-ID: <20251008125427.68735-1-acsjakub@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251007162136.1885546-1-aliceryhl@google.com>
References: <20251007162136.1885546-1-aliceryhl@google.com>
MIME-Version: 1.0
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D041UWB003.ant.amazon.com (10.13.139.176) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 244F22000D
X-Stat-Signature: j8wu6ccxy4b8um73jodpguumborpifpc
X-Rspam-User: 
X-HE-Tag: 1759928085-101916
X-HE-Meta: U2FsdGVkX1/74O7/WNU+Amecjlnvbl5e7AEc6JCQlPGe9ppnfgvoVKPm1p8u8g2pTb/P5qN6URla6fcFvVro2PaUwu1Totq8f1Y3GLbzR6YgLfj6fKgKgxi5w1tXWpFHZYyVuI/L4X15IV0ysYZNUYfvyIbPYNV1WrrTsvE6JXOVBFDlx7ZD22KifObZX4oPdvcFMev4Y/Eh71go1GmH2xiBLxukANgmdEvZGVVQETVUpjogMo6B21FGp9mP4wRPj/yTANp5A0o/suaXmG9cigxS4JnhiQIwvoqc72+wt/yTfqNHgd6DVxfBCBcGHoYVP4rC/zxxCf2JXdA6C3UY5nIkbdLd74pPYT5pgQzzoVoRnotJstAXwapNkGD8koYHQJRAF29Q3wa+3ro791Az1XGp7+u0BowxvtVu5G7OXA8kBgl9Q+U4BPp5MCEw8zr3ACvxoOBzORW+bXPfNj3yTpiN29nIYW9mBbwNydMEU6mHStWe9gU+B3DOey8JMgD1Wv0PE2lBKdViGn7CqDcLgWJI0crHTJRWfOOX32RIPPgmZ1A+0AL8YmXLZ2F3bV40GG+ac71VATvLZQ8LqXXPuJw3s8nP6QlJb35HJAnsa99HKkFn47vCzixpqQQQdjqJwCvIi41EXnUw2pgDBui0fJErcX85CQVviMqzGkchPtPYMTyuANCUGizRaBNEhB0PBSJzIna5tcMit5d7M83neTofqrcezaH0VA4l42pRxYlp2kGn6YawCksKuLjUY3AA3RLr/BQnhqku9KydGIuYmjq4tUU/K1pM/19+3NEz4rQzoHNkcCOcengP8GGOrijraLDNaDhSuQ3Wi3Kxl5nuntDf2hkR/CYGDGaTihV4A6DgiYPfQgC4qUEpFhnl5k6Pf2Y64Ct6dhK2Y+HUfMkhi/MOAEJpvNiSXEJR/tL2muMet8LVA9+qublge3+fnDVFQVSL0XCSyLbyRmHremN
 XYao4FCD
 cDK9iRssjPmPTKBKUHImpA38E7WYaSqwLBy/ODeEpGEFYNX9+gvCsD6SOgecYFs6ZlU8Rrbyvqis5+JCjBt9xHExqlVHSXu3ihSo9wweiXvrKcBtonx+IohLhXFGq75NOMW3dSupAZxOTq30m7opeK3NeXRiFyBJ3926/POCSlX+hjg+5Ni8Ojdbf60IbwKHvvO0vXTSwkiXFGb8tnCTqRF69Yk573GEoKrI2Lb+qw5juTixt6uxrW3t6/j6mkzy2HTDeLMRmvpH+km8+DfbuaOtQquL2mispJ+UNImQtIrvBKhiO/XurBDF7IKgL4MmYTkzPTXybyhknN8YOeORDPAuOYrkd7nOU1fj1z7tm0nVBfkcUaiOqyCAPu1MIqRqgRnwYSRvlHAUGxHNXxA4xzyxhOo0XJChlz8L6womWtHM37P/p7xhmhjYGh1aU5kGE2kpaQEL587bmVNbHNBCsL/9O3B+dIuYFj3CkYbQwa10DWo/W2v/YwOz2Pa7PQTsmxDMqP9kaDMaiS2w/JIrGZk48jeNRtfLQBiO30xGeCSZlCT/P/mv8WOQ6wxByB1G/yEWKbABQ5YCugOlWaliR8TwnIYiLyAYQlR9OPsKa6MSL/LF79WorxsqM/fjUaD8Y59vw3Ks60cE1DYopaP9EyVm+xvHzpGq8HUez5xYsq9c5PwOJ4i2cz0kRJPoeX3jukTf9MLwFcw44KDmvignXo4F1E8v/a+2klCKNtMPfV1g5YaPAAw/wFjw0jRn/JzcYuilbYytZ6p7ABQkIO0rQ7BY9ZC5IMLZzH7CMPPxJgkomang=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

redefine VM_* flag constants with BIT()

Make VM_* flag constant definitions consistent - unify all to use BIT()
macro and define them within an enum.

The bindgen tool is better able to handle BIT(_) declarations when used
in an enum.

Also add enum definitions for tracepoints.

We have previously changed VM_MERGEABLE in a separate bugfix. This is a
follow-up to make all the VM_* flag constant definitions consistent, as
suggested by David in [1].

[1]: https://lore.kernel.org/all/85f852f9-8577-4230-adc7-c52e7f479454@redhat.com/

Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---

Hi Alice,

thanks for the patch, I squashed it in (should I add your signed-off-by
too?) and added the TRACE_DEFINE_ENUM calls pointed out by Derrick.

I have the following points to still address, though: 

- can the fact that we're not controlling the type of the values if
  using enum be a problem? (likely the indirect control we have through
  the highest value is good enough, but I'm not sure)

- where do TRACE_DEFINE_ENUM calls belong?
  I see them placed e.g. in include/trace/misc/nfs.h for nfs or
  arch/x86/kvm/mmu/mmutrace.h, but I don't see a corresponding file for
  mm.h - does this warrant creating a separate file for these
  definitions?

- with the need for TRACE_DEFINE_ENUM calls, do we still deem this
  to be a good trade-off? - isn't fixing all of these in
  rust/bindings/bindings_helper.h better?

@Derrick, can you point me to how to test for the issue you pointed out?

Thanks,
Jakub


 include/linux/mm.h              | 142 ++++++++++++++++++++++----------
 rust/bindings/bindings_helper.h |   1 -
 2 files changed, 98 insertions(+), 45 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 70a2a76007d4..8b9e7a9e7042 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -36,6 +36,7 @@
 #include <linux/rcuwait.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
+#include <linux/tracepoint.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -273,57 +274,58 @@ extern unsigned int kobjsize(const void *objp);
  * vm_flags in vm_area_struct, see mm_types.h.
  * When changing, update also include/trace/events/mmflags.h
  */
-#define VM_NONE		0x00000000
+enum {
+	VM_NONE		= 0,
 
-#define VM_READ		0x00000001	/* currently active flags */
-#define VM_WRITE	0x00000002
-#define VM_EXEC		0x00000004
-#define VM_SHARED	0x00000008
+	VM_READ		= BIT(0),		/* currently active flags */
+	VM_WRITE	= BIT(1),
+	VM_EXEC		= BIT(2),
+	VM_SHARED	= BIT(3),
 
 /* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
-#define VM_MAYREAD	0x00000010	/* limits for mprotect() etc */
-#define VM_MAYWRITE	0x00000020
-#define VM_MAYEXEC	0x00000040
-#define VM_MAYSHARE	0x00000080
+	VM_MAYREAD	= BIT(4),		/* limits for mprotect() etc */
+	VM_MAYWRITE	= BIT(5),
+	VM_MAYEXEC	= BIT(6),
+	VM_MAYSHARE	= BIT(7),
 
-#define VM_GROWSDOWN	0x00000100	/* general info on the segment */
+	VM_GROWSDOWN	= BIT(8),		/* general info on the segment */
 #ifdef CONFIG_MMU
-#define VM_UFFD_MISSING	0x00000200	/* missing pages tracking */
+	VM_UFFD_MISSING	= BIT(9),		/* missing pages tracking */
 #else /* CONFIG_MMU */
-#define VM_MAYOVERLAY	0x00000200	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
+	VM_MAYOVERLAY	= BIT(9),		/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
 #define VM_UFFD_MISSING	0
 #endif /* CONFIG_MMU */
-#define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
-#define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
-
-#define VM_LOCKED	0x00002000
-#define VM_IO           0x00004000	/* Memory mapped I/O or similar */
-
-					/* Used by sys_madvise() */
-#define VM_SEQ_READ	0x00008000	/* App will access data sequentially */
-#define VM_RAND_READ	0x00010000	/* App will not benefit from clustered reads */
-
-#define VM_DONTCOPY	0x00020000      /* Do not copy this vma on fork */
-#define VM_DONTEXPAND	0x00040000	/* Cannot expand with mremap() */
-#define VM_LOCKONFAULT	0x00080000	/* Lock the pages covered when they are faulted in */
-#define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
-#define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
-#define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
-#define VM_SYNC		0x00800000	/* Synchronous page faults */
-#define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
-#define VM_WIPEONFORK	0x02000000	/* Wipe VMA contents in child. */
-#define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
+	VM_PFNMAP	= BIT(10),		/* Page-ranges managed without "struct page", just pure PFN */
+	VM_UFFD_WP	= BIT(12),		/* wrprotect pages tracking */
+
+	VM_LOCKED	= BIT(13),
+	VM_IO           = BIT(14),		/* Memory mapped I/O or similar */
+
+						/* Used by sys_madvise() */
+	VM_SEQ_READ	= BIT(15),		/* App will access data sequentially */
+	VM_RAND_READ	= BIT(16),		/* App will not benefit from clustered reads */
+
+	VM_DONTCOPY	= BIT(17),		/* Do not copy this vma on fork */
+	VM_DONTEXPAND	= BIT(18),		/* Cannot expand with mremap() */
+	VM_LOCKONFAULT	= BIT(19),		/* Lock the pages covered when they are faulted in */
+	VM_ACCOUNT	= BIT(20),		/* Is a VM accounted object */
+	VM_NORESERVE	= BIT(21),		/* should the VM suppress accounting */
+	VM_HUGETLB	= BIT(22),		/* Huge TLB Page VM */
+	VM_SYNC		= BIT(23),		/* Synchronous page faults */
+	VM_ARCH_1	= BIT(24),		/* Architecture-specific flag */
+	VM_WIPEONFORK	= BIT(25),		/* Wipe VMA contents in child. */
+	VM_DONTDUMP	= BIT(26),		/* Do not include in the core dump */
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
-# define VM_SOFTDIRTY	0x08000000	/* Not soft dirty clean area */
+	VM_SOFTDIRTY	= BIT(27),		/* Not soft dirty clean area */
 #else
 # define VM_SOFTDIRTY	0
 #endif
 
-#define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
-#define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
-#define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
-#define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
+	VM_MIXEDMAP	= BIT(28),		/* Can contain "struct page" and pure PFN pages */
+	VM_HUGEPAGE	= BIT(29),		/* MADV_HUGEPAGE marked this vma */
+	VM_NOHUGEPAGE	= BIT(30),		/* MADV_NOHUGEPAGE marked this vma */
+	VM_MERGEABLE	= BIT(31),		/* KSM may merge identical pages */
 
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
 #define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */
@@ -333,14 +335,66 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HIGH_ARCH_BIT_4	36	/* bit only usable on 64-bit architectures */
 #define VM_HIGH_ARCH_BIT_5	37	/* bit only usable on 64-bit architectures */
 #define VM_HIGH_ARCH_BIT_6	38	/* bit only usable on 64-bit architectures */
-#define VM_HIGH_ARCH_0	BIT(VM_HIGH_ARCH_BIT_0)
-#define VM_HIGH_ARCH_1	BIT(VM_HIGH_ARCH_BIT_1)
-#define VM_HIGH_ARCH_2	BIT(VM_HIGH_ARCH_BIT_2)
-#define VM_HIGH_ARCH_3	BIT(VM_HIGH_ARCH_BIT_3)
-#define VM_HIGH_ARCH_4	BIT(VM_HIGH_ARCH_BIT_4)
-#define VM_HIGH_ARCH_5	BIT(VM_HIGH_ARCH_BIT_5)
-#define VM_HIGH_ARCH_6	BIT(VM_HIGH_ARCH_BIT_6)
+	VM_HIGH_ARCH_0	= BIT(VM_HIGH_ARCH_BIT_0),
+	VM_HIGH_ARCH_1	= BIT(VM_HIGH_ARCH_BIT_1),
+	VM_HIGH_ARCH_2	= BIT(VM_HIGH_ARCH_BIT_2),
+	VM_HIGH_ARCH_3	= BIT(VM_HIGH_ARCH_BIT_3),
+	VM_HIGH_ARCH_4	= BIT(VM_HIGH_ARCH_BIT_4),
+	VM_HIGH_ARCH_5	= BIT(VM_HIGH_ARCH_BIT_5),
+	VM_HIGH_ARCH_6	= BIT(VM_HIGH_ARCH_BIT_6),
 #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
+};
+
+TRACE_DEFINE_ENUM(VM_NONE);
+TRACE_DEFINE_ENUM(VM_READ);
+TRACE_DEFINE_ENUM(VM_WRITE);
+TRACE_DEFINE_ENUM(VM_EXEC);
+TRACE_DEFINE_ENUM(VM_SHARED);
+TRACE_DEFINE_ENUM(VM_MAYREAD);
+TRACE_DEFINE_ENUM(VM_MAYWRITE);
+TRACE_DEFINE_ENUM(VM_MAYEXEC);
+TRACE_DEFINE_ENUM(VM_MAYSHARE);
+TRACE_DEFINE_ENUM(VM_GROWSDOWN);
+TRACE_DEFINE_ENUM(VM_UFFD_MISSING);
+
+#ifndef CONFIG_MMU
+TRACE_DEFINE_ENUM(VM_MAYOVERLAY);
+#endif /* CONFIG_MMU */
+
+TRACE_DEFINE_ENUM(VM_PFNMAP);
+TRACE_DEFINE_ENUM(VM_UFFD_WP);
+TRACE_DEFINE_ENUM(VM_LOCKED);
+TRACE_DEFINE_ENUM(VM_IO);
+TRACE_DEFINE_ENUM(VM_SEQ_READ);
+TRACE_DEFINE_ENUM(VM_RAND_READ);
+TRACE_DEFINE_ENUM(VM_DONTCOPY);
+TRACE_DEFINE_ENUM(VM_DONTEXPAND);
+TRACE_DEFINE_ENUM(VM_LOCKONFAULT);
+TRACE_DEFINE_ENUM(VM_ACCOUNT);
+TRACE_DEFINE_ENUM(VM_NORESERVE);
+TRACE_DEFINE_ENUM(VM_HUGETLB);
+TRACE_DEFINE_ENUM(VM_SYNC);
+TRACE_DEFINE_ENUM(VM_ARCH_1);
+TRACE_DEFINE_ENUM(VM_WIPEONFORK);
+TRACE_DEFINE_ENUM(VM_DONTDUMP);
+
+TRACE_DEFINE_ENUM(VM_SOFTDIRTY);
+
+TRACE_DEFINE_ENUM(VM_MIXEDMAP);
+TRACE_DEFINE_ENUM(VM_HUGEPAGE);
+TRACE_DEFINE_ENUM(VM_NOHUGEPAGE);
+TRACE_DEFINE_ENUM(VM_MERGEABLE);
+
+#ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
+TRACE_DEFINE_ENUM(VM_HIGH_ARCH_0);
+TRACE_DEFINE_ENUM(VM_HIGH_ARCH_1);
+TRACE_DEFINE_ENUM(VM_HIGH_ARCH_2);
+TRACE_DEFINE_ENUM(VM_HIGH_ARCH_3);
+TRACE_DEFINE_ENUM(VM_HIGH_ARCH_4);
+TRACE_DEFINE_ENUM(VM_HIGH_ARCH_5);
+TRACE_DEFINE_ENUM(VM_HIGH_ARCH_6);
+#endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
+
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
 # define VM_PKEY_SHIFT VM_HIGH_ARCH_BIT_0
diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 2e43c66635a2..04b75d4d01c3 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -108,7 +108,6 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
 
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
-const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
 
 #if IS_ENABLED(CONFIG_ANDROID_BINDER_IPC_RUST)
 #include "../../drivers/android/binder/rust_binder.h"
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


