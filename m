Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA12CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E3C28E012E; Tue, 12 Aug 2025 09:27:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444E48E00E5; Tue, 12 Aug 2025 09:27:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5678E012E; Tue, 12 Aug 2025 09:27:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 199618E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:27:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE3A858577
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:27:04 +0000 (UTC)
X-FDA: 83768181168.28.0D6ACA3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf26.hostedemail.com (Postfix) with ESMTP id 79D2E140016
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:27:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RiM0QO5D;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005222; a=rsa-sha256;
	cv=none;
	b=2w0WNfXSXvFum0HNROvjNzyrWtpcnwFCUDbNWJbG2A7T/lPz9A8QFqtPhbRHuiscdgsUaK
	lxxvOTgoP2HOc0lT7oi6n539oTS8MsxCn+Sk7uOMdKtS1P8eZRsw7QxXksyC4058MoNud2
	NFaaymm4zFHwa8dOclPcP0+Y5LnGGEQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RiM0QO5D;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vi+DnfymbWINgDO7B71cxapm47NMkhYdRMHYX+0KAIs=;
	b=0FRZYrwrXcYgQMpNStzNdqlg9s/WQnBI/O6HbkTNV2DPuL5VGsKnazHW5Spjb1fYuUfQdC
	JQBay7DlmQBOmroL9nlT2qkB4buR7XfvGVzS6lYH+AzNSPsaJ2tVavhHQR1h67TYl3Yb6R
	rqA3dQfgW6F9cSFq9APT00tEYzCZFXs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005223; x=1786541223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mZLJdH3rbK1bxCuEzF7KjKtbxlAVDYknI9S994S9uz4=;
  b=RiM0QO5DHaJjWTHT1DZVDOV2cfv4S+IQ+/gUEY1Doph15f0QsQOcfcnH
   ZMJT1jJ2yFyYQngLoQuj/RpdnC28eEq+CIpALICg75sPPOufkUX7oPEmH
   2tzJFlHw4awBCfZyX3qkpqR1ofQZRJjynhzPsc9ATAWjjuvPcQ1YBiYEV
   K0ThuYgD+2c3npyOcVQPNTum2iQffHydDWwdh/9oiUqplsexzTWCYnjau
   AOOubnaBT2+6R18ZMAkstsWuTcjtonvs9D4hAOrXPZbjTKpPtnht7OwfY
   lVMKYhOCc2+sLZCxByRvQX5w5+oKIF7dwHab8sLQgiZXy4+y+vlJWwp9K
   Q==;
X-CSE-ConnectionGUID: kOjMiO/xQuGAh6vggVH5kg==
X-CSE-MsgGUID: zxJoLTd6R9OQD+Ki14E22w==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60903418"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60903418"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:26:55 -0700
X-CSE-ConnectionGUID: 0gOP6hCJQl2mMyP4g+OHwQ==
X-CSE-MsgGUID: 99luYSpdRRigAj3rcRdRgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165831406"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:26:32 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: nathan@kernel.org,
	arnd@arndb.de,
	broonie@kernel.org,
	Liam.Howlett@oracle.com,
	urezki@gmail.com,
	will@kernel.org,
	kaleshsingh@google.com,
	rppt@kernel.org,
	leitao@debian.org,
	coxu@redhat.com,
	surenb@google.com,
	akpm@linux-foundation.org,
	luto@kernel.org,
	jpoimboe@kernel.org,
	changyuanl@google.com,
	hpa@zytor.com,
	dvyukov@google.com,
	kas@kernel.org,
	corbet@lwn.net,
	vincenzo.frascino@arm.com,
	smostafa@google.com,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	andreyknvl@gmail.com,
	alexander.shishkin@linux.intel.com,
	thiago.bauermann@linaro.org,
	catalin.marinas@arm.com,
	ryabinin.a.a@gmail.com,
	jan.kiszka@siemens.com,
	jbohac@suse.cz,
	dan.j.williams@intel.com,
	joel.granados@kernel.org,
	baohua@kernel.org,
	kevin.brodsky@arm.com,
	nicolas.schier@linux.dev,
	pcc@google.com,
	andriy.shevchenko@linux.intel.com,
	wei.liu@kernel.org,
	bp@alien8.de,
	ada.coupriediaz@arm.com,
	xin@zytor.com,
	pankaj.gupta@amd.com,
	vbabka@suse.cz,
	glider@google.com,
	jgross@suse.com,
	kees@kernel.org,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	ardb@kernel.org,
	thuth@redhat.com,
	pasha.tatashin@soleen.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	maciej.wieczor-retman@intel.com,
	lorenzo.stoakes@oracle.com,
	jason.andryuk@amd.com,
	david@redhat.com,
	graf@amazon.com,
	wangkefeng.wang@huawei.com,
	ziy@nvidia.com,
	mark.rutland@arm.com,
	dave.hansen@linux.intel.com,
	samuel.holland@sifive.com,
	kbingham@kernel.org,
	trintaeoitogc@gmail.com,
	scott@os.amperecomputing.com,
	justinstitt@google.com,
	kuan-ying.lee@canonical.com,
	maz@kernel.org,
	tglx@linutronix.de,
	samitolvanen@google.com,
	mhocko@suse.com,
	nunodasneves@linux.microsoft.com,
	brgerst@gmail.com,
	willy@infradead.org,
	ubizjak@gmail.com,
	peterz@infradead.org,
	mingo@redhat.com,
	sohil.mehta@intel.com
Cc: linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	llvm@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 05/18] kasan: arm64: x86: Make special tags arch specific
Date: Tue, 12 Aug 2025 15:23:41 +0200
Message-ID: <788b6f9a1f5adf2b69564489d16de436ba1bdc3c.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 79D2E140016
X-Stat-Signature: funtx53ho55wnho9aht4dw45edz1eeok
X-Rspam-User: 
X-HE-Tag: 1755005222-386005
X-HE-Meta: U2FsdGVkX1/tENpg48bG1SXkiA12K8XEsXmLTxU9Y9k/AC9LQF8Vs7cdo/6ZSfZ9yabu4bwNRCEnm6lZjGo554G3/LX1K0TGDwzB/2DPbTebDDLuXwbcyEX/wPWu5mS6Hxy7hbAASIgEfi3p7ZFp5zAyFBFzw6KPkrTD4G43v97cJSSqJrRPNCVKb1FkpVrn7nVOWJbFGJsDpbEDHR/6yqQWONEWAzsep/P1w0JPPp9BUbOd0rbffAZWCaH3n/sUg27ybZYe+gGURySWdWGGHUL0O93klAEroCtpjvsLolPO8ptodfffkzlDvswt9ZNN+qKLKnx7ByNz/kprhiHXWQaF8Szr/mdohm01qAZahZZp9T2m3XRagGprmI4sUmYHEnzA/0Cg6yga5RmNeb6YLdfq7PcQ0NIZ+e6gouOQa+7J6XcZPfoN3dNCG4i2LpQel7gy/lRvcgVvY5qSQjmWREo9qaR+bvrGT8M0N7qrLbZMvWydLZDg4/eNXjd5K4eiWS+XAbDqKLHGz/zE+Ix13opHDqu8PxHid0AJZEXVWNZHGjIoEr26KH0pbsC4P2IuZMewrUF6faTwt+SX36lLFzj32lCDNfVcQPmRbb4N3z5UpCShfHQWIU2xNyj3+rg6Sl4wPXLuOe3hQdB57K6xMm656dQz9Wbnna4HcKat1vC51KPCFTls30Qvmd7xpO77CrSPK5zWeel+aJL0KsYVveaRFCohV5MaEOstlyuyP+M5zb8acLvzdkFiofYrB3UH8gxcd4lKokHQ7Y9V3Uad9mH67lBJFQhvn0QKUGnsdF2EgYAj01yJvKy5Ph+hnDCbzN8afq3M4BEITrgrw9at/gnJK4FBkdoIo2BKnEr1YcF9zcF5ObWtP/kD4eBhFybwq/kxq+8GMnOc0uRlJljt8I1MeZMSKPSQX/FoyOVfyOy4AJ57wnKCWXGePjX/b9VgeZut9P2luWo9uIWNpiy
 UFyB8msC
 42NRTg7T/OnfuZiLTUFYuCycpkBoao8Dypt20EBQ5Qoda/fYfP0GVi6Hr2FTxAChkMxweOzFVpTbwyRwKJ6H+MNTaPKGTZUlJnkN0EPZatIsR1Gui/zBfTbfh3NccGViM5a8b6J1HDzM2wMy61Vh4rg4iEksQQ358G3X+YswOHlP5Ev3IjuWxyPaPbTDdxlhbW7Z68SQd1ZRgUudJ+T2MCYUcNd4Dj3l/7WNMBZTBBl14FattMzwyyRpGib2/Dq6yZI81Z9ToXFpKuchc+LLZl9f7/VlnsrMzvD9zf6gLcQggoxXvmdUU1fVMKB/LPTFKzUQ1VQiWs+Mnyue9QnDhsYj1fjavx/l339DnbuQxm6Fcw7BqKKlYUtVdGw==
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
Changelog v4:
- Move KASAN_TAG_MASK to kasan-tags.h.

Changelog v2:
- Remove risc-v from the patch.

 MAINTAINERS                         |  2 +-
 arch/arm64/include/asm/kasan-tags.h |  9 +++++++++
 arch/x86/include/asm/kasan-tags.h   |  9 +++++++++
 include/linux/kasan-tags.h          | 10 +++++++++-
 include/linux/kasan.h               |  4 +++-
 include/linux/mm.h                  |  6 +++---
 include/linux/mmzone.h              |  1 -
 include/linux/page-flags-layout.h   |  9 +--------
 8 files changed, 35 insertions(+), 15 deletions(-)
 create mode 100644 arch/arm64/include/asm/kasan-tags.h
 create mode 100644 arch/x86/include/asm/kasan-tags.h

diff --git a/MAINTAINERS b/MAINTAINERS
index fe168477caa4..7ce8c6b86e3d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13166,7 +13166,7 @@ L:	kasan-dev@googlegroups.com
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
index 000000000000..8cb12ebae57f
--- /dev/null
+++ b/arch/arm64/include/asm/kasan-tags.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_KASAN_TAGS_H
+#define __ASM_KASAN_TAGS_H
+
+#define KASAN_TAG_KERNEL	0xFF /* native kernel pointers tag */
+
+#define KASAN_TAG_WIDTH		8
+
+#endif /* ASM_KASAN_TAGS_H */
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


