Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC7DC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF2F8E012D; Tue, 12 Aug 2025 09:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051E28E00E5; Tue, 12 Aug 2025 09:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9B28E012D; Tue, 12 Aug 2025 09:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CBD1C8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:27:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 969151A0303
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:27:02 +0000 (UTC)
X-FDA: 83768181084.11.35DDB35
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf25.hostedemail.com (Postfix) with ESMTP id 59F1CA0008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:27:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gkO1hVUT;
	spf=pass (imf25.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1eXm8xfKIhjDNACz9/lPozC75PsVZy+RO5JY/jLRAo=;
	b=IPEg3PojmvP6hvaHGNOjUXdLdvhEBWdyQMm4cYvHrJ7LzQLBv8B6Cj0bb5jt88EpFtCPEm
	1ZZw38sfyoXcfR0hAtrUXRx8w94U48yyM6CPTy4/V0uiVLeTISuFw+fjOuIwdR5pgvfgrm
	d1Xy27owYk3t3BKP/Gtjl3IEGzTGle4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gkO1hVUT;
	spf=pass (imf25.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005220; a=rsa-sha256;
	cv=none;
	b=bFV5tXK50u8Kyl78oDcZ4vRJeW11wCQgK2CQbCyElJ4EVCg9BjNgwgUSMUuQbfGYkhf9R+
	2v4w3iw16A44gkmm446N8+LTkz0Iq1C5U15popYxPj5J+iZh93FmrYt3yMxfjFpAQMdTGh
	/nGugSBap6DkV2W4kblcHMvAbVvd1do=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005221; x=1786541221;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=umSIEr/jpouxzkGHeJJ2QvhqsNKgw+HWF35dK6bLmas=;
  b=gkO1hVUTfBgcsoGnDeJZ9CuedMz7RoOXXlO/RN5kMeamtYKfc2JIpf5y
   km+qtLjPtOMmLapadj7b947nc7FJDX+vkAJvPT3WGGC0fjv1TSY+EklMy
   FVgHcfKyG0j6FwlVkzvF6q+d7BARouoCsgnqFfvg9eBR16ZDCgQtIchii
   t4qOBibwBYHFlbK0KfFZAQyX82xytc0qhfggtWcR0w7ZPWZ7Qo3NKKn2Q
   NxCmTDhJnXN+a0QKLVrJctGqjYkCEFyhmqbvrlOLxUOvpTc6d/WQOuirt
   6/LvWYTkdDEfzNuYmwKaQ9lsb8+rsdAZZRO+ZPikm1LtLbI95RYpf5Eke
   A==;
X-CSE-ConnectionGUID: eosJuJKNSICy+XUyBALv0w==
X-CSE-MsgGUID: IztsETmqQ1Ct8K4zjK/HyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60903367"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60903367"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:26:33 -0700
X-CSE-ConnectionGUID: ZdcdAsOcQWWTFu4OTS0rRA==
X-CSE-MsgGUID: cCyGXKgLSeWES9FNw89vig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165831396"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:26:09 -0700
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
Subject: [PATCH v4 04/18] x86: Add arch specific kasan functions
Date: Tue, 12 Aug 2025 15:23:40 +0200
Message-ID: <b8d16cb57dc7ebfdcd0652eab030af4c6a3d0d63.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cf767jr33zar7px9ey8fbm56uh61tfz3
X-Rspam-User: 
X-Rspamd-Queue-Id: 59F1CA0008
X-Rspamd-Server: rspam05
X-HE-Tag: 1755005220-497218
X-HE-Meta: U2FsdGVkX18dwlRAc7FvcXxWt9RBEER5JyYOXhQY8MjDUXIA4tseuJ99p8M0D55vG3tDZFjl3AQVJbw+EgN32z3019PXYVgQk6bBS5HdfxQ/cTn19LnqdQZ1DwUsB0x+NtZpnMTPl/7XOE5poJ38mHOfUc1i+MAQYROR01vhbagUa9cDTx+aGVt7uJuOQue5J3ONhkv+I/SENJT1nCkzT6HtAxWE01kbHQupth5xZMvxci/VfDSwIYn/AN+GrOLLqWi7WDxvcKMRRBlkfkXzpZTft5cgQzQGPPhB4mSccB1u4LW083Nx6z7B7lK/0gJoVPSxAHDU/gyCiKSKucoyj7+7F/JL3jXprmjcr0Co4KUinfqviZjfer0JAjBh2DfY+4EJsASUWqFeB/ToNv7P6M/4CKZsVTzgIEfArt16o4DQBRDF9iO/LziVrwhoWmLuHDWkH04GFGSz6ylu0eRuIZJlUvAZriEscy+iLGIYuTq9hrWW+uQfun7HyqgETuCCMWmKYPC/nZvcUHW2gyZl+4ZOQQdn64L6QzqwBzy5H8906CPd0XNbKX6kZayYrZ0xUojgz79cjWuXfLpR43lttE+abarivETZKEm4qu71pIwW+1YdSfFrL5NQMtJb6fZB5beek80FEIGT49hkoSCiSSAf7I+LbdAi9FPqDLiiq+TEqEHmxiL/ukgNG26gh116mgn6VxudbDna1NB9gN59t/SJDoFimV+WSX8jNp16joH8616D8B2HwgdKYa1wS8noQ7B0eBmMaaCn9QoWhevV8Zo6aIbzmIV2M/4OJ9WiwJ8XqTEVJ+C9JYBrVniNBm1lpQ/q5JUNFBStNejXo7EU7pnz1z5Ox/Bup/aIjgPxusBejO7RDQrlU9ukckCyc/dTvz9VCsNyr3L8suuNRToqoqEigflDA1Um/ycQ66y9tEtaB6Hjnxor4fgkN9vUNIVjiuYA9jUcwgiHJ8DSYJW
 HA3lHwhH
 vDvZUxTDmGmV9qeLICQvDAl8Fg5Yjd9qec/6o4QoeyNxnsfBbvq1878Lz0zr3aguWxI867+BHXQ8K8Ff4jXoqjpGCdzf2xbS12p4T7+pohlwn9rOQlmYzszul2yqUhyWx8a++YdewiXV3PzfPSM9Sszcj76yorY4TVd3URkfAihe87ETGQlaavwkNDgLzdTnkeVJV9Dg+ONMRlkTjEDoFPyNo2QUxGjLc5mov+ErZf1NxvwZUWi0j7g4TsFYycdOAhve4acNzJVRy3GhmIfBek0nHIZw6lQT+91iT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KASAN's software tag-based mode needs multiple macros/functions to
handle tag and pointer interactions - to set, retrieve and reset tags
from the top bits of a pointer.

Mimic functions currently used by arm64 but change the tag's position to
bits [60:57] in the pointer.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Rewrite __tag_set() without pointless casts and make it more readable.

Changelog v3:
- Reorder functions so that __tag_*() etc are above the
  arch_kasan_*() ones.
- Remove CONFIG_KASAN condition from __tag_set()

 arch/x86/include/asm/kasan.h | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
index d7e33c7f096b..1963eb2fcff3 100644
--- a/arch/x86/include/asm/kasan.h
+++ b/arch/x86/include/asm/kasan.h
@@ -3,6 +3,8 @@
 #define _ASM_X86_KASAN_H
 
 #include <linux/const.h>
+#include <linux/kasan-tags.h>
+#include <linux/types.h>
 #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
 #define KASAN_SHADOW_SCALE_SHIFT 3
 
@@ -24,8 +26,37 @@
 						  KASAN_SHADOW_SCALE_SHIFT)))
 
 #ifndef __ASSEMBLER__
+#include <linux/bitops.h>
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+
+#ifdef CONFIG_KASAN_SW_TAGS
+
+#define __tag_shifted(tag)		FIELD_PREP(GENMASK_ULL(60, 57), tag)
+#define __tag_reset(addr)		(sign_extend64((u64)(addr), 56))
+#define __tag_get(addr)			((u8)FIELD_GET(GENMASK_ULL(60, 57), (u64)addr))
+#else
+#define __tag_shifted(tag)		0UL
+#define __tag_reset(addr)		(addr)
+#define __tag_get(addr)			0
+#endif /* CONFIG_KASAN_SW_TAGS */
+
+static inline void *__tag_set(const void *__addr, u8 tag)
+{
+	u64 addr = (u64)__addr;
+
+	addr &= ~__tag_shifted(KASAN_TAG_MASK);
+	addr |= __tag_shifted(tag);
+
+	return (void *)addr;
+}
+
+#define arch_kasan_set_tag(addr, tag)	__tag_set(addr, tag)
+#define arch_kasan_reset_tag(addr)	__tag_reset(addr)
+#define arch_kasan_get_tag(addr)	__tag_get(addr)
 
 #ifdef CONFIG_KASAN
+
 void __init kasan_early_init(void);
 void __init kasan_init(void);
 void __init kasan_populate_shadow_for_vaddr(void *va, size_t size, int nid);
@@ -34,8 +65,9 @@ static inline void kasan_early_init(void) { }
 static inline void kasan_init(void) { }
 static inline void kasan_populate_shadow_for_vaddr(void *va, size_t size,
 						   int nid) { }
-#endif
 
-#endif
+#endif /* CONFIG_KASAN */
+
+#endif /* __ASSEMBLER__ */
 
 #endif
-- 
2.50.1


