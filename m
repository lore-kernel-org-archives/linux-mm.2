Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0D0ACDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 18:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9370A6B00D2; Thu, 25 Jun 2026 14:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0746B00D4; Thu, 25 Jun 2026 14:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761D86B00D5; Thu, 25 Jun 2026 14:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4056F6B00D2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:49:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE6691C18CB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:49:08 +0000 (UTC)
X-FDA: 84919322376.21.18A6C94
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf21.hostedemail.com (Postfix) with ESMTP id F2B7A1C0014
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:49:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bWEsU4cr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3IXg9agYKCGAQSPCL9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3IXg9agYKCGAQSPCL9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--surenb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782413347;
	b=hPkJeWNMxxFcEMCBrfwNfvmLGmtaQhLr2WQns7D7Upvik/ATEUin0uEgCoenaj1728skm7
	pZ3O1tjPcmd4V7jSSfa+aBAij+n7sKXR80YOYieKBlbR9ide7HFPk3GXOgVrWG9wDLyELL
	vuTZgB89Ef5PN2sq3HybqCjZOe8KIEM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782413347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PljyuUHvnv7Sc3Pl2TIaDdc5arqbRo7b/02GpkBHtD8=;
	b=IQdxIS3Ual7m+W7X8iQfK8k8eLntO9/89CPKh5QkMvdn1e/18sQjT2CwAcwUawYS4ccVbs
	wdsvSbkBEE1Ay4/9GadAsqPH4o+yC51eE/ZfxN5x7ixgaHgZOmznXHUA7QC53cGhRYjLtn
	58sTXSa51shozYfSYec4tVrbcMSCChk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bWEsU4cr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3IXg9agYKCGAQSPCL9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3IXg9agYKCGAQSPCL9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--surenb.bounces.google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-30bcbb34e57so198589eec.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782413346; x=1783018146; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PljyuUHvnv7Sc3Pl2TIaDdc5arqbRo7b/02GpkBHtD8=;
        b=bWEsU4cr4btKKLItOtOD5ezxzeAR3P1pzvADBn4QuK0Kk1lheuPdI1ZJ1R04/LwiDx
         IXtjQKAdkgiXD8zGF30h1qUDk4ylHbF3mVqW7esJz9fwo3L2jwjNsOiTvEliJZaM7QpA
         aChXc1pvykuUz8MbYW0weDT+1+54GaARzdNe0E0w9DwTg2/BcP/dWMoxBa39C54BSy05
         KECoMQvu7KCiGUaosNGPWDgQB5WLYkpI95T3vZsaNRjRa/awe+xKGc43jcUK0mEIdnw2
         oFqj6jKUUhd+Xp/njrnbaj8NKK+TadBGHpkLLcmM8jy/QyBc3FwvFOeB4nFkENfxUJJN
         BfUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782413346; x=1783018146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PljyuUHvnv7Sc3Pl2TIaDdc5arqbRo7b/02GpkBHtD8=;
        b=BO9pZORhGAk54p8c8QFeduz6Toddijk22AUZtw5pDiuFtwVxqVQmZ+SfATuH6aWCac
         dAkJPQ3V85zGMaj5Kx0V2dD+yjZJonex9SAfn2g5zMgfj6PaZ6cNepZc+0nVYdOTR+m+
         pewl4TmpJY1sYV8jtJMCqIpUHA7JKWSk1bKIlBh6/ZFIkanqJ2q7TwnL55tsVUdwLSt0
         GEFB+3IUITopSEDYhYek6lygLR5mmd3QXOU3dDGIgartQxAZAteZ305cjcjfh356nxHE
         KEafRKv2Ku73wIM2rbCOmYZPWSlLUK02nMrhySYO2vccnk2YB5vkpe+OJ7HNOonfJSfb
         JhXA==
X-Forwarded-Encrypted: i=1; AFNElJ94DElGarcbSvpixw5OeoH/ea2YaqgYaEqfiC5OVKR3lFSjSgAXCrj2ePTGUZtt7gw6RgGX1PXoog==@kvack.org
X-Gm-Message-State: AOJu0YxqXmN7o/5bw67ChuojO4EU73DGscbDuODlnHa/mJ/R0h0CikQF
	J8NiF+fTRFuPSCcgHHwPh00hBnXu+iUHifwSq55teWSOgVphNk4vUTPPOksVukUCzHe1o5Wkr4A
	hBWkgpA==
X-Received: from dlbsj2-n1.prod.google.com ([2002:a05:7022:f902:10b0:139:bb10:9e5c])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:1707:b0:139:beba:8216
 with SMTP id a92af1059eb24-139dbbafdc1mr2041359c88.30.1782413345354; Thu, 25
 Jun 2026 11:49:05 -0700 (PDT)
Date: Thu, 25 Jun 2026 11:48:57 -0700
In-Reply-To: <20260625184857.2193482-1-surenb@google.com>
Mime-Version: 1.0
References: <20260625184857.2193482-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260625184857.2193482-3-surenb@google.com>
Subject: [PATCH 2/2] mm: move alloc tag to mm
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, hao.ge@linux.dev, 
	jackmanb@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F2B7A1C0014
X-Rspam-User: 
X-Stat-Signature: xz8gha5gykydo7syxt1uwrjzgazuxpy3
X-HE-Tag: 1782413346-699079
X-HE-Meta: U2FsdGVkX18LiqSsTDi/7uE6cNH9Ny1ZJKK3lDSB7nMkjNfSenfQVyWnzlidAuylMtH/5Kzfd/u97WI0Cz9aQetDatTE7eVwfbZOgxgqGujroJjCqvfc028HSpXUAKi8BLUVOL1qRP888mr/VMTSc5VmjXvn/Q15FiBQZOuLaOoWQKwlMRrL4+2tQGWM6UXw/wdtAkhWJoDeTaFFFAyIq19X7NnjC1Ks+qwJkHDuZkTWdjmWt6MNeZ01v/2soDBFCZff+Xcx+CZ0K7NhbtboqnFcvwLQcAbvJ6+YeLAO44SjglN6jZWM7MpG3weSqmJddxAOnfpfnjufVxJq+5QzN4l6QvogSIwi0AlPu+YO3pagbx71DjJQ9xWpEThxMhD6dZbp5rLmPJnDi+5IFW+CZp68hetKhPO+yZ1UAI2tlYnyGCIlogQqwnwgns/P7D71qfdY4llU4iLZ+hH2HlCFrxJF1J7yS1XYIOH5D3rUnmoZfB5FUTRtGtlAhFWBMRE2o2uXTIplX77dXDr5sRboHXQ78fjddP7hnlUYD/+IIzHOOyyLiJeZ2nKnjsCucTk8AVpn9IY46wOWKTMTcvyRweTr1fZpXxmJYHHeQlebwA7ZpGVHSxzl0ekHQuNfZl8DHGFtnK6me53YsqGlVDoDmLEjdwb7VAAT8zHYSwoBVUgTU1mUHAMKeEYe4HyMD6Rxh+qbd4ge9suKWe8RquCNxw/QPlXTQ8EaQh3ZaWqtAqYoFx1dKndCUhWf7Pvb4ZreiuwOTx2gU0RPWpH9wpVWIuLELwSHidc7RYP/k5R+BzH9MuYnBDV3cRk8xU4eBE/jNLt9CQw4UE6nSZmYZWxoIZkxeKdCMNQ/mY0WvM0bN4/2wOSqD4o+3sNXfeOeeD+aPP6+sLKBQ5a086Ar57yiSFIHhmrN2DF1hENT3OxdJl6NmN64sDDI0451irKyn0g9c7hSdCNB8wd61oqt1R9
 UpI4MXAE
 nUKOedzSF2RKgRl7p6rHb+LUb9yi2OUXd0RfSD0tfc8mMVKHACgljLAVI2hlgU7PkV2HVpCdBH0MApDn4eVAcXj6usCR+WGcGL1eUfG08ItQn0WDMzQD9EHmU+iYJdStA1cf99kE23+KlsQZ09353a4pKWjv9YPvhmK6nZEzfVRWmD1lo7vJ1w6JCLiak1i+5NBUsf43iirYkUDKJDYoJbgYsyso2q5jUvsOWgdSjPoRW74FYTOxBGQ8qYoTZJgq8XNUMcCVy1cQxXj7dbjBcmZLCAuDi9gcvh2mR/pDOR82OD/YQUIaCgblFyNqRPjwr8NA9YglLFcnfGXtJZYj2GxpsdeITeC2jeAec+clouApZLH7v9Pw5bwI+cJmOhCJvTBa2l8Mz1Z++HuKaxLJVPEhRu9a6Ol71Zdt2syydVgEWStyTc0q80fqwTXdjhaqdJd/qdTRh+spUfUwEILWRlQxPYZnI9m7xSLc/mRqoJg6caYt5INkNnLpbU+GfZjxCp+mIouG9dJD5oh9u3UxGRyR210pZNtyjj7vWW9BrWPiLOMKtHnliXUSs/ZMpqjjV24ooXM9cOeUGbIXmkH74RzARhuIjrkhiIMUP0xZGhIM/D4PQbzotZDSvDl8sXLPgx6msvwRDdHQenzVeQ2rw47rzvgPZ3f1OXPkmbHwBmmUSTCA9LEyE4RwsoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <ljs@kernel.org>

The alloc tagging work is really mm-specific, so move alloc_tag.c to mm/
and additionally update the MAINTAINERS entry to place it within memory
management and port over the Kconfig and Makefile code to mm.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 MAINTAINERS             | 20 ++++++++++----------
 lib/Kconfig.debug       | 28 ----------------------------
 lib/Makefile            |  1 -
 mm/Kconfig.debug        | 28 ++++++++++++++++++++++++++++
 mm/Makefile             |  1 +
 {lib => mm}/alloc_tag.c |  0
 6 files changed, 39 insertions(+), 39 deletions(-)
 rename {lib => mm}/alloc_tag.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0948dc573744..3cf3cf2311e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16704,16 +16704,6 @@ F:	mm/mm_init.c
 F:	mm/rodata_test.c
 F:	tools/testing/memblock/
 
-MEMORY ALLOCATION PROFILING
-M:	Suren Baghdasaryan <surenb@google.com>
-R:	Hao Ge <hao.ge@linux.dev>
-L:	linux-mm@kvack.org
-S:	Maintained
-F:	Documentation/mm/allocation-profiling.rst
-F:	include/linux/alloc_tag.h
-F:	include/linux/pgalloc_tag.h
-F:	lib/alloc_tag.c
-
 MEMORY CONTROLLER DRIVERS
 M:	Krzysztof Kozlowski <krzk@kernel.org>
 L:	linux-kernel@vger.kernel.org
@@ -16758,6 +16748,16 @@ T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
 F:	mm/
 F:	tools/mm/
 
+MEMORY MANAGEMENT - ALLOCATION PROFILING (ALLOC TAG)
+M:	Suren Baghdasaryan <surenb@google.com>
+R:	Hao Ge <hao.ge@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/mm/allocation-profiling.rst
+F:	include/linux/alloc_tag.h
+F:	include/linux/pgalloc_tag.h
+F:	mm/alloc_tag.c
+
 MEMORY MANAGEMENT - BALLOON
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8ff5adcfe1e0..3762015522c3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1048,34 +1048,6 @@ config CODE_TAGGING
 	bool
 	select KALLSYMS
 
-config MEM_ALLOC_PROFILING
-	bool "Enable memory allocation profiling"
-	default n
-	depends on MMU
-	depends on PROC_FS
-	depends on !DEBUG_FORCE_WEAK_PER_CPU
-	select CODE_TAGGING
-	select PAGE_EXTENSION
-	select SLAB_OBJ_EXT
-	help
-	  Track allocation source code and record total allocation size
-	  initiated at that code location. The mechanism can be used to track
-	  memory leaks with a low performance and memory impact.
-
-config MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
-	bool "Enable memory allocation profiling by default"
-	default y
-	depends on MEM_ALLOC_PROFILING
-
-config MEM_ALLOC_PROFILING_DEBUG
-	bool "Memory allocation profiler debugging"
-	default n
-	depends on MEM_ALLOC_PROFILING
-	select MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
-	help
-	  Adds warnings with helpful error messages for memory allocation
-	  profiling.
-
 source "lib/Kconfig.kasan"
 source "lib/Kconfig.kfence"
 source "lib/Kconfig.kmsan"
diff --git a/lib/Makefile b/lib/Makefile
index f33a24bf1c19..44f6538533a9 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -197,7 +197,6 @@ obj-$(CONFIG_OF_RECONFIG_NOTIFIER_ERROR_INJECT) += \
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
 
 obj-$(CONFIG_CODE_TAGGING) += codetag.o
-obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 91b3e027b753..5737a504efbb 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -320,3 +320,31 @@ config PER_VMA_LOCK_STATS
 	  overhead in the page fault path.
 
 	  If in doubt, say N.
+
+config MEM_ALLOC_PROFILING
+	bool "Enable memory allocation profiling"
+	default n
+	depends on MMU
+	depends on PROC_FS
+	depends on !DEBUG_FORCE_WEAK_PER_CPU
+	select CODE_TAGGING
+	select PAGE_EXTENSION
+	select SLAB_OBJ_EXT
+	help
+	  Track allocation source code and record total allocation size
+	  initiated at that code location. The mechanism can be used to track
+	  memory leaks with a low performance and memory impact.
+
+config MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
+	bool "Enable memory allocation profiling by default"
+	default y
+	depends on MEM_ALLOC_PROFILING
+
+config MEM_ALLOC_PROFILING_DEBUG
+	bool "Memory allocation profiler debugging"
+	default n
+	depends on MEM_ALLOC_PROFILING
+	select MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
+	help
+	  Adds warnings with helpful error messages for memory allocation
+	  profiling.
diff --git a/mm/Makefile b/mm/Makefile
index eff9f9e7e061..4fc713867b9b 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
+obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
diff --git a/lib/alloc_tag.c b/mm/alloc_tag.c
similarity index 100%
rename from lib/alloc_tag.c
rename to mm/alloc_tag.c
-- 
2.55.0.rc0.799.gd6f94ed593-goog


