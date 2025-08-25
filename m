Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9803DC8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0B88E0071; Mon, 25 Aug 2025 16:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79978E0038; Mon, 25 Aug 2025 16:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1A558E0071; Mon, 25 Aug 2025 16:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA3258E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:27:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 539CD139501
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:27:23 +0000 (UTC)
X-FDA: 83816414766.10.80F8F04
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf12.hostedemail.com (Postfix) with ESMTP id 086BE40003
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:27:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ly50iY2g;
	spf=pass (imf12.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=siX9X8C1ebWNpAl8jAmF0YHWnm6v4zSBKwYpTwwyAIU=;
	b=fNLLtt/2CvPfFl24aSFWROGeDv+eaKKfYjx4hHf4GVACyCYLS2IwEbl5MBF1byeQxV3Dvw
	QmR4gAjS/Ck5iDGmMRV1S0wgfp+a5HkukpDy+0w5ObI3PxS8vDa0t+Dd2KjZ7TkXY/ELCM
	62p6BymhB8gf+2WV/qGRjj/QBg1pOWk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ly50iY2g;
	spf=pass (imf12.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153641; a=rsa-sha256;
	cv=none;
	b=BtGx8SzUTNmNAyiGRjwzJli5BKrxzILDoEpeCd77pS2MOxulYq/v8RNSNyeYh64jHKRy3/
	kdyMdiHUVlq35PcUjCaWk8SkoGO1Bf/IJNq2M5PgUwSpUkdYh78HJVk5L2hcYGKpdx4/JB
	dOZgCb8CFsZSPdCiXqWZf4gxFElYbpM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153641; x=1787689641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xm2JHVeyAyS1boSSRsktnh7jJ0yWea9I1N2uiKqy64Y=;
  b=Ly50iY2gcnCB0l4eOF2jM34plWD+0LthEe40cazccYU4nthMV6id/Hfz
   51RvOwMNE/5PeC31A1YJWa4/iq4+NF+JZrnG0yugyKKHwkIUogsmMMUlp
   IHVzP0VmqT/X4zm/+BSeV968lSkJTRiPEj4p4BuWyp84uCiWCpKRf06bt
   v8qh3LnEC2nWJNSYOxjvScha7kBvYQrzAT8pI4hGbCkrFrYDbWeJDZRkT
   k7So7/28bc0X1BA1P6w0YlMzfJxoGN6tGuUCDuZaBM1Opw+Uzcw6fLkAm
   g/0PxqN9jG8H80IOmFe3/K4pQqNCDXmebybPWmqIBIjTyUOm6I8RlB39l
   A==;
X-CSE-ConnectionGUID: 6ZeSObJ/TeWDSZ1ogJvY0Q==
X-CSE-MsgGUID: rpf+9X9/RECug157/i4GmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68970473"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68970473"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:27:19 -0700
X-CSE-ConnectionGUID: aQ202IPqRcWU0JmqPLmwhQ==
X-CSE-MsgGUID: fhmF8QYeQ8GO7LAXlViwDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169780311"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:26:57 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: sohil.mehta@intel.com,
	baohua@kernel.org,
	david@redhat.com,
	kbingham@kernel.org,
	weixugc@google.com,
	Liam.Howlett@oracle.com,
	alexandre.chartre@oracle.com,
	kas@kernel.org,
	mark.rutland@arm.com,
	trintaeoitogc@gmail.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	joey.gouly@arm.com,
	samitolvanen@google.com,
	joel.granados@kernel.org,
	graf@amazon.com,
	vincenzo.frascino@arm.com,
	kees@kernel.org,
	ardb@kernel.org,
	thiago.bauermann@linaro.org,
	glider@google.com,
	thuth@redhat.com,
	kuan-ying.lee@canonical.com,
	pasha.tatashin@soleen.com,
	nick.desaulniers+lkml@gmail.com,
	vbabka@suse.cz,
	kaleshsingh@google.com,
	justinstitt@google.com,
	catalin.marinas@arm.com,
	alexander.shishkin@linux.intel.com,
	samuel.holland@sifive.com,
	dave.hansen@linux.intel.com,
	corbet@lwn.net,
	xin@zytor.com,
	dvyukov@google.com,
	tglx@linutronix.de,
	scott@os.amperecomputing.com,
	jason.andryuk@amd.com,
	morbo@google.com,
	nathan@kernel.org,
	lorenzo.stoakes@oracle.com,
	mingo@redhat.com,
	brgerst@gmail.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	luto@kernel.org,
	jgross@suse.com,
	jpoimboe@kernel.org,
	urezki@gmail.com,
	mhocko@suse.com,
	ada.coupriediaz@arm.com,
	hpa@zytor.com,
	maciej.wieczor-retman@intel.com,
	leitao@debian.org,
	peterz@infradead.org,
	wangkefeng.wang@huawei.com,
	surenb@google.com,
	ziy@nvidia.com,
	smostafa@google.com,
	ryabinin.a.a@gmail.com,
	ubizjak@gmail.com,
	jbohac@suse.cz,
	broonie@kernel.org,
	akpm@linux-foundation.org,
	guoweikang.kernel@gmail.com,
	rppt@kernel.org,
	pcc@google.com,
	jan.kiszka@siemens.com,
	nicolas.schier@linux.dev,
	will@kernel.org,
	andreyknvl@gmail.com,
	jhubbard@nvidia.com,
	bp@alien8.de
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 05/19] kasan: arm64: x86: Make special tags arch specific
Date: Mon, 25 Aug 2025 22:24:30 +0200
Message-ID: <7a85ceb0918c6b204078e6d479b85fef6a6c1768.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 086BE40003
X-Stat-Signature: yh1jzfrip8shmfw9rwmgr8sg4byhrzoi
X-Rspam-User: 
X-HE-Tag: 1756153640-738524
X-HE-Meta: U2FsdGVkX1/05DInEZlIjDsuffr9DB5elfelK2yfGeBZYDCZoQfV8oLZ2PBuDP7rCzQztrPVuw2w9UvQL4IcRo8oryMal4bof4lrEN2Me8OgSo36C6nQNkQVz/B7ehqbEM3jDvS0a/SVa2y9s4iq4yM4daL5hSO0ioSTsrTbRnBxA5QERiWzF5DscO4lA5anVTC4DukkVWaZxc5REGdDaogPzXPj/7zz/ThppJI6xknoczr3ftdXzhQyErUxRXQ1M9hmMUQHvohZxCwRe4jbhQW3G4Wd3iNV7szzlGwJX9NgsOSC6uAHzY4YvbywUJtNoxBr3IcDV5UBB0Q3cioDQIKkalVfnvfN9/eYIq66esUFpq/TIDU6o8+YWZCbucMjjm4nvThofwmOmSIOpVM5fetiMs70ls5vrHT5Y/fJxX/EFJflPAR+oUpp9NDKMu6ljKWXiAsWr+ES9MPyKK+M+E/AgkuCoif1BCIB/MT/2A4mBCQ+NAc5HNd8ZENHNu7n+T4+LauUQaio6I/sUPI0AqIM/LVtjbmAiqL3/TuuoG/KvjCqGA9Mu2aYoKL+v6bHgNOMkF0n3TTRaS+ZFYZPIgPEc997+WB7qWueYXNSb3aoe/tzLFFwo5HOp54bIsmNpgMc9HIdENmB7d6TEkg8aU+O1b6cHgnYRGg85Qu21MAP2tktGj7UDMM1CL4Ex//J4LmBsMUF0mS242kgDNkKzhKx71/Tz3WQg8SHyzz1KKdhqJ+OTwqmO3krVHHC+kFS9wxhzFdawuWVEkG+b2nkghQpImI85WJsLerLWDbVZRG4B85EMBcmpZmXpBCc9DBWZjIHxjMv7H/6S9l7quEPBCpzq2gnpnY+lDvsm4hepZE1cLenaWSjlAz807vT/xmWTPBn654sNYA4VXrm9wc9t+CGCpaBl+1TxfyCL7tacFiJS2ZWLOXTcr59tBWd3UDhvjgS3bd5wiVGW+FM8lx
 CBkSl1pk
 8vkGSnUBDrREe8I3VqWIYx9utgYhjfr7tSwzuJiPGPTC5OyUh/N1qz9VdtLzIYGK+mLE/QW6ft1fRiRdt+6LV9gNuxWX0TAcb1ksodKgZPb4WeP4E+TdkQugu57jIB0PKzJPeYAKJRR3PWfDUQXGQ1t5D7thninsgT9YXTROTv3pT2NBmQud1QTTz+MV876h9gY3GInl6xDRWfn16hXQpHtJZrpOgO4VXbZMa14+jjSNOxCWxMPv87I65xN00mR8Kz/s2bBfGU2HoY6NG4iqLkBpff0WpLYfHwK5vqV5tt3+xbh3G73U32ljUaQ3rJPunCDBUwjRJoxkpErkRpMuDtXCsHy+Bf7HbqquZuGKjIL+k4OP9Wl7QfZNeCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KASAN's tag-based mode defines multiple special tag values. They're
reserved for:
- Native kernel value. On arm64 it's 0xFF and it causes an early return
  in the tag checking function.
- Invalid value. 0xFE marks an area as freed / unallocated. It's also
  the value that is used to initialize regions of shadow memory.
- Max value. 0xFD is the highest value that can be randomly generated
  for a new tag.

Metadata macro is also defined:
- Tag width equal to 8.

Tag-based mode on x86 is going to use 4 bit wide tags so all the above
values need to be changed accordingly.

Make native kernel tag arch specific for x86 and arm64.

Replace hardcoded kernel tag value and tag width with macros in KASAN's
non-arch specific code.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v5:
- Move KASAN_TAG_MIN to the arm64 kasan-tags.h for the hardware KASAN
  mode case.

Changelog v4:
- Move KASAN_TAG_MASK to kasan-tags.h.

Changelog v2:
- Remove risc-v from the patch.

 MAINTAINERS                         |  2 +-
 arch/arm64/include/asm/kasan-tags.h | 13 +++++++++++++
 arch/arm64/include/asm/kasan.h      |  4 ----
 arch/x86/include/asm/kasan-tags.h   |  9 +++++++++
 include/linux/kasan-tags.h          | 10 +++++++++-
 include/linux/kasan.h               |  4 +++-
 include/linux/mm.h                  |  6 +++---
 include/linux/mmzone.h              |  1 -
 include/linux/page-flags-layout.h   |  9 +--------
 9 files changed, 39 insertions(+), 19 deletions(-)
 create mode 100644 arch/arm64/include/asm/kasan-tags.h
 create mode 100644 arch/x86/include/asm/kasan-tags.h

diff --git a/MAINTAINERS b/MAINTAINERS
index fed6cd812d79..788532771832 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13176,7 +13176,7 @@ L:	kasan-dev@googlegroups.com
 S:	Maintained
 B:	https://bugzilla.kernel.org/buglist.cgi?component=Sanitizers&product=Memory%20Management
 F:	Documentation/dev-tools/kasan.rst
-F:	arch/*/include/asm/*kasan.h
+F:	arch/*/include/asm/*kasan*.h
 F:	arch/*/mm/kasan_init*
 F:	include/linux/kasan*.h
 F:	lib/Kconfig.kasan
diff --git a/arch/arm64/include/asm/kasan-tags.h b/arch/arm64/include/asm/kasan-tags.h
new file mode 100644
index 000000000000..152465d03508
--- /dev/null
+++ b/arch/arm64/include/asm/kasan-tags.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_KASAN_TAGS_H
+#define __ASM_KASAN_TAGS_H
+
+#define KASAN_TAG_KERNEL	0xFF /* native kernel pointers tag */
+
+#define KASAN_TAG_WIDTH		8
+
+#ifdef CONFIG_KASAN_HW_TAGS
+#define KASAN_TAG_MIN			0xF0 /* minimum value for random tags */
+#endif
+
+#endif /* ASM_KASAN_TAGS_H */
diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.h
index 4ab419df8b93..d2841e0fb908 100644
--- a/arch/arm64/include/asm/kasan.h
+++ b/arch/arm64/include/asm/kasan.h
@@ -7,10 +7,6 @@
 #include <linux/linkage.h>
 #include <asm/memory.h>
 
-#ifdef CONFIG_KASAN_HW_TAGS
-#define KASAN_TAG_MIN			0xF0 /* minimum value for random tags */
-#endif
-
 #define arch_kasan_set_tag(addr, tag)	__tag_set(addr, tag)
 #define arch_kasan_reset_tag(addr)	__tag_reset(addr)
 #define arch_kasan_get_tag(addr)	__tag_get(addr)
diff --git a/arch/x86/include/asm/kasan-tags.h b/arch/x86/include/asm/kasan-tags.h
new file mode 100644
index 000000000000..68ba385bc75c
--- /dev/null
+++ b/arch/x86/include/asm/kasan-tags.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_KASAN_TAGS_H
+#define __ASM_KASAN_TAGS_H
+
+#define KASAN_TAG_KERNEL	0xF /* native kernel pointers tag */
+
+#define KASAN_TAG_WIDTH		4
+
+#endif /* ASM_KASAN_TAGS_H */
diff --git a/include/linux/kasan-tags.h b/include/linux/kasan-tags.h
index e07c896f95d3..fe80fa8f3315 100644
--- a/include/linux/kasan-tags.h
+++ b/include/linux/kasan-tags.h
@@ -2,7 +2,15 @@
 #ifndef _LINUX_KASAN_TAGS_H
 #define _LINUX_KASAN_TAGS_H
 
-#include <asm/kasan.h>
+#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
+#include <asm/kasan-tags.h>
+#endif
+
+#ifndef KASAN_TAG_WIDTH
+#define KASAN_TAG_WIDTH		0
+#endif
+
+#define KASAN_TAG_MASK		((1UL << KASAN_TAG_WIDTH) - 1)
 
 #ifndef KASAN_TAG_KERNEL
 #define KASAN_TAG_KERNEL	0xFF /* native kernel pointers tag */
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index b396feca714f..54481f8c30c5 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -40,7 +40,9 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
 
 #ifdef CONFIG_KASAN_SW_TAGS
 /* This matches KASAN_TAG_INVALID. */
-#define KASAN_SHADOW_INIT 0xFE
+#ifndef KASAN_SHADOW_INIT
+#define KASAN_SHADOW_INIT KASAN_TAG_INVALID
+#endif
 #else
 #define KASAN_SHADOW_INIT 0
 #endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..bb494cb1d5af 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1692,7 +1692,7 @@ static inline u8 page_kasan_tag(const struct page *page)
 
 	if (kasan_enabled()) {
 		tag = (page->flags >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
-		tag ^= 0xff;
+		tag ^= KASAN_TAG_KERNEL;
 	}
 
 	return tag;
@@ -1705,7 +1705,7 @@ static inline void page_kasan_tag_set(struct page *page, u8 tag)
 	if (!kasan_enabled())
 		return;
 
-	tag ^= 0xff;
+	tag ^= KASAN_TAG_KERNEL;
 	old_flags = READ_ONCE(page->flags);
 	do {
 		flags = old_flags;
@@ -1724,7 +1724,7 @@ static inline void page_kasan_tag_reset(struct page *page)
 
 static inline u8 page_kasan_tag(const struct page *page)
 {
-	return 0xff;
+	return KASAN_TAG_KERNEL;
 }
 
 static inline void page_kasan_tag_set(struct page *page, u8 tag) { }
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0c5da9141983..c139fb3d862d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1166,7 +1166,6 @@ static inline bool zone_is_empty(struct zone *zone)
 #define NODES_MASK		((1UL << NODES_WIDTH) - 1)
 #define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
 #define LAST_CPUPID_MASK	((1UL << LAST_CPUPID_SHIFT) - 1)
-#define KASAN_TAG_MASK		((1UL << KASAN_TAG_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
 static inline enum zone_type page_zonenum(const struct page *page)
diff --git a/include/linux/page-flags-layout.h b/include/linux/page-flags-layout.h
index 760006b1c480..b2cc4cb870e0 100644
--- a/include/linux/page-flags-layout.h
+++ b/include/linux/page-flags-layout.h
@@ -3,6 +3,7 @@
 #define PAGE_FLAGS_LAYOUT_H
 
 #include <linux/numa.h>
+#include <linux/kasan-tags.h>
 #include <generated/bounds.h>
 
 /*
@@ -72,14 +73,6 @@
 #define NODE_NOT_IN_PAGE_FLAGS	1
 #endif
 
-#if defined(CONFIG_KASAN_SW_TAGS)
-#define KASAN_TAG_WIDTH 8
-#elif defined(CONFIG_KASAN_HW_TAGS)
-#define KASAN_TAG_WIDTH 4
-#else
-#define KASAN_TAG_WIDTH 0
-#endif
-
 #ifdef CONFIG_NUMA_BALANCING
 #define LAST__PID_SHIFT 8
 #define LAST__PID_MASK  ((1 << LAST__PID_SHIFT)-1)
-- 
2.50.1


