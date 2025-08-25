Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EDD8C8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787788E0070; Mon, 25 Aug 2025 16:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737A58E0038; Mon, 25 Aug 2025 16:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FFD38E0070; Mon, 25 Aug 2025 16:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49DC28E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:27:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F058C0442
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:27:01 +0000 (UTC)
X-FDA: 83816413842.19.326E78B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf07.hostedemail.com (Postfix) with ESMTP id EACBF40004
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:26:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cdWGJiCj;
	spf=pass (imf07.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1eXm8xfKIhjDNACz9/lPozC75PsVZy+RO5JY/jLRAo=;
	b=X4ChXFUbj0MBrOIhhoCCNPLNuhu6bjAX2wgDOcafDA/ECAEi/r/LqErZ3A226fzOS3aft6
	iO7JP28AQf1ulPx/AZyggO8r348NncsgSX3TBNpp88sU4yNd8u/hOatDB9kyZZRRzECSv9
	KxcUB7dQM/sHAaf+ZbpNz3NyWGRQ7Bs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cdWGJiCj;
	spf=pass (imf07.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153619; a=rsa-sha256;
	cv=none;
	b=4JgBMDpZSx0KYE9cbuIjyfn2upLgmqIYJRulzM6A+P1ls5DwiU2jCjluYOSLFCgydg89GG
	qKh1AvEkEOpKU+7miCnhMPp4APPPT2UkE5AIOcX7lM/R23HgDnEPknXG3cho4AEoSOG1wz
	SqqaJML9x+iBY1Z5JDa/DUH47LpxEyM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153619; x=1787689619;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=umSIEr/jpouxzkGHeJJ2QvhqsNKgw+HWF35dK6bLmas=;
  b=cdWGJiCjLz3B9EWczTSZ0+DLmoik+VPPu/yRtjmeXdWM8j4TKlsAS7tF
   zw9RcGeyjYoQ3CdQ0GjR9TafpBAUfDGFjqvSUjJM+qg5Ii231AAg7hTrG
   enVN5SW1Lp417MyA63xYSuvN/5INLsXYYq5YIsewtfhhkGTwYj6qD4pes
   UDJVhDK4vnP3VHYMn6UuKfBuBIqMXcVkgiGZpj3sy/p/ejeRZLvO0SqGt
   AYJA/3IDH8A5kto4KHlZKtd1ORvYAj+2W3PCQoZKX/UlvOAT+bL+EzNKo
   tQJ+bIAJMshQCdBFSwSQQVzYajiuUAzmPwRwcXsLRUdHJqKz6cz+lwkOj
   g==;
X-CSE-ConnectionGUID: /SPbHSFlQiCXL/vgBQIJOw==
X-CSE-MsgGUID: 24AI4hrBT3Cn9KIkgmhDFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68970410"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68970410"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:26:57 -0700
X-CSE-ConnectionGUID: NLx4kw5FQRqFjJVf8cE+Cg==
X-CSE-MsgGUID: 21hF26/3R2SLuLwXAqtixQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169780102"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:26:35 -0700
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
Subject: [PATCH v5 04/19] x86: Add arch specific kasan functions
Date: Mon, 25 Aug 2025 22:24:29 +0200
Message-ID: <7cb9edae06aeaf8c69013a89f1fd13a9e1531d54.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EACBF40004
X-Stat-Signature: gr6q4r4cjrwridph1uk91hh6mpbrpidj
X-Rspam-User: 
X-HE-Tag: 1756153618-824377
X-HE-Meta: U2FsdGVkX1+5WtUrhgCcTszktbvm33li1wYAZ6OFD1sVF9eFi653wQcCdpYDaCcUvC2U7fG/KFsI/F4ndUrugrZnuQvXDjenfcCk4nMt1sfk+VuO3di9bXDeyvlLZltKJcgLbEAPx7+/6M6zmb/j545qSO46C0qG/mbpYTLacCXy6Uf9H5Jg8obMmbZjMZxMA5ZOGIEqYL4DqLF/YsYGsP0MLAfYeqBjK3FqOvSLxYv26RPkXhtLOvlFbL6IOOXzrTHJ6SsZUk3jc4FsrFLwEQ705zkcFP8L3TGUHRBRnWU54OEBtipSBjm0vicAnme9UCOSczYA05qWSHI8oao67hE8d906Q1k1D3zzcOjRC9XXEQ4MAhmyFlQg7B+rcOUCNRJ4AQM6nQIhV1QZHHWYTQiMLzcsKS/fOW2FG25jD4/qxky5OCpfozkEScbdtlaihJiMq1hLVhEXKufoKGICMskfOiXxHcWVC8HzXL0EYJDGXX+X3F/3XJ7rJGy9DRZYPCaZXkF0IR0vq1HqDR9Eu1ZfOjoIHvwa+VX5x7EnSdbHkkJ+b0b0aYXjIXUXErbQ9LtaUHT3sd3Zj7t9rd9v3GvQuIdIbmqNJWS9OBgpej7iEXeB/GEpdRpwELPi+CBXLZhe+C11JdI+hP793aXoEzhlMj4DIFTT0pWZoMuvLmI9qrK6G4LeNXeV1qgigKGsxyDYrNOg/84utsikGZaHfLsV9O+I9rmE0j0JjmE8lR/MSJm2ycspOKxxTPsUH1RAQE3xobHlHzwh+Q9Pu0GZgqUbLmdky4g6Os8svHdUq2dJY6Fjcnyo+LFco2uT3nRgaqGs4ehJyC0jy8zdjXBsYjw3wqbejyHWEjHAJUL8VHiTbWMvTBu+54nMTdyhC2iz1GbW4Yki15cC72DxQytAYZHioUeGfYJwqbN5kju99QdRuKqburKxeTsln1RFpUrt1u+lTfqOoTmUl9vQ1Yd
 08wbXASp
 /oKiY3iszjPpYvL6c+TwZO9NdDjfcn4zRDDeYGtCXCeCn3N8v1j/RE8aPSDOTT5lGVu78ahy5so9gqnnMwtFDlbOH8ZEhZqnly/pE8ppc9qhBQN2VvsBqoDYP4OiomYOaJBSaOxB9aduF0oiYaF+Devh3Vd5I5vjoPWfcaMNvehDt7zC7a12DrnVl9GQrbEhLMWu62h/8msUu6jDcRYUoU2I2ySetmM5m9lSPgR5JHMRnqQQakuzdb6iB/DdyDzbjEk+KjMHQpcXHLILwl1+KFylJeC4SygUWpSPcH5THJyFsJubVM2bVquHowUB9HuvPhtnQ
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


