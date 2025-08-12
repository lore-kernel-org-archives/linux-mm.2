Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D2BCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892898E013B; Tue, 12 Aug 2025 09:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A3A8E00E5; Tue, 12 Aug 2025 09:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7594A8E013B; Tue, 12 Aug 2025 09:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 666B78E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:30:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 43FD01A0142
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:30:56 +0000 (UTC)
X-FDA: 83768190912.18.B89C59F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E8CB180002
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:30:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZstZAxny;
	spf=pass (imf06.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9pMJ3Vo5IMuP6mFoJhewFUZLR0jAiqJe8Z9tK6dwhQE=;
	b=o6ZMlJXDBmwxl1zWISPjmbNNh04ufFOQxzw3J0kYBdw6GtKzqKHH7RBVyyyE+zMlTI9itF
	WJdljs16rqYlD+Y/eAALWPjuS2Xy3b0CqeZBOxzFx9jbbhc79H/mtUzKzq0Zjzlm/mZUNG
	AvQMqoob5rjMEzEGWUvkieC+8pE35z4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005454; a=rsa-sha256;
	cv=none;
	b=Pty1mD0vXE1ju1pyDFNJ/KpjPxUDvKY0Qo/c5IEcbOAgj3QGxUez+sblWOVFKsrYc0Zvk9
	JotN/WKjZslsSZ8vRlECOWrPcDUAZfCqGTe79bPOrBGRwisCCp+VITpwEqFpVGkoG3cqVM
	byD1//hffV7v4DVLIYmnfCxtLK+IPxM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZstZAxny;
	spf=pass (imf06.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005455; x=1786541455;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bLAP3Uvsa+ddGeiTQivKwBmzgkLDslUubgZ6G8l99Io=;
  b=ZstZAxnyt2RuClToH22k+oTfiSCevYv5jAJ06/naZc2cz6wmZT4IlClu
   wW1+UkDsKDwU/9anXHv9eYQkTxKycm8357XZ/4++FqtuKHy/jI1MAd92v
   h/TNjIsM0VIXFS5XTy+EXB4i+YcWYd5j+chSi0f85q+FbGqjiEGf28jGt
   bbk8zv+EFG3TZN1ERsCFKhQP0Navjn9+MaJK7BFKumYFlv4Jd8GmmSFXw
   34O6EwstDkoXwEVOwJkK6PAJw3HwcB8OzQWU00p8Y3qcs2DFdrpGxTJOw
   5x3tCJh230jqk+xWMTkZATVjCjGI5WpJpW1IPjsyEQl1Ck12f00uplIvR
   Q==;
X-CSE-ConnectionGUID: RfziFgBMTaCs6Z+WVBaBtA==
X-CSE-MsgGUID: KxHkfWxgR1GndH6cKnlnTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60904013"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60904013"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:30:53 -0700
X-CSE-ConnectionGUID: Qs0HalWXTxanbhip8kE5PA==
X-CSE-MsgGUID: lUt/yXQuTg+taKHifBrAyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165832023"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:30:21 -0700
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
Subject: [PATCH v4 15/18] kasan: x86: Logical bit shift for kasan_mem_to_shadow
Date: Tue, 12 Aug 2025 15:23:51 +0200
Message-ID: <a1a7d761bad9ead5596edb2dbe62cab26c24602a.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0E8CB180002
X-Stat-Signature: wfrtozwnjom1tniosenweyoyp63jawgg
X-Rspam-User: 
X-HE-Tag: 1755005453-470753
X-HE-Meta: U2FsdGVkX1+AM995wba0YWFZm+4GTdh0EB51alWZTzBvb/xoOEgemK4/F15fvzE8d8wugGlfJGNbuvkZFT0MkEx0KB66L8ZH/VCaqGRbBWxAqaANUU7RPzpwygtU+BU0OXzg8AC8WQDOo9QEeu/DVPD/0ZQ+tQIkJ3Sudou/AMDq8PcIK65tm7NZEeqxt4UtiBR0vkLTL97wmb/A+5IQqaJ7GzybekvKjjj6I/ikfayhNYWxZuT15a5xjNG3xrs9P1zX6IOcYUODvMgHVY6YQUFHh8HUjBi6pvpYrgR7e2QLLWhVnfpbc6pUb6ZRgjcz/olwJ6/cCngZcPMI7Wt3+mHwPPlD7S+hrwC2nSIPyEF6or6hNd1f2k4Gp1mN1/BptgfU+ORxxF78Hhgz9UiKL7PoI3HbTmtP8dYGW1AfksUdRxqRnIW9f9+5yKzQAEV3eP5XdOVRcw+7cju2kAM++FqZ/uZNTlUkbSl3WkLXLUKUE4mOadsDWVEi+nD8R6qKlBk3x8RxVRNhxZuXZ78ebOJKnEB1pNp+T2Uk8/tJBerRxyY2Zlsd7dCJ/sT2WYh46keQywZHjfIr34VBNA8E2IvdNwIvE48RHRtaBiTITdOpqiK/bDEL5/S3aj1TytlBR8+LARXL6Hu2u49dFa1Z1l9nn9dmltywdMJyqy4djB48rkdyi9eoWTHC/W/NOWxRytehv4jh8qrD083bkHK/l+mI+5Vb8a4oTNgdbVUl/0ko5PlOiR8Kcns878Iati9Frg5X7uSp1judRvVjyiFYaazlvO2BgOvugPnZkhgUjMKGPBhdc3fl8clmM9ShpHz7UfanPj6uW7CHv+zv8X+zmgDj67gdSu+GxeOy4z4iaTJtPHG3yiJklbOTvNMa64xxbCvBCxeEhnDj7V6nPJWnvXcDvWWZ92hhuarUAuKMO/eaQuq3KmEE75vM0yKZggUWVYOvnejxQWNrtdw7BxV
 PWaF1PLA
 fRwxoB6fSyfjOx31rEf7UdPm+LyQvMf0EPn95P7nhOe2DBb0PFMwjVcegt2267dVO6C4ZcC4eXpTNy7M+DuZwjKSpBGjVZ/BXr/Z6Uxe2IdPIPRxSD0+U0uNPYFceMLErvpc4yaMhfcL116neRS4imxo0XsSK9YK3XkuJ2um+F2ba03S1hC0iNeT58y5nG1Q/DjWK4ZsXWHYh+pk2TMk5XoAGbF+HDT4zqgUzuYQS777fmEshUzVDvRWoCaiFSUNIft4Eeh2j2Mfc9TF+TWgAnVZJ602E+F+z+DQt4LAqKcc1yyo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While generally tag-based KASAN adopts an arithemitc bit shift to
convert a memory address to a shadow memory address, it doesn't work for
all cases on x86. Testing different shadow memory offsets proved that
either 4 or 5 level paging didn't work correctly or inline mode ran into
issues. Thus the best working scheme is the logical bit shift and
non-canonical shadow offset that x86 uses for generic KASAN, of course
adjusted for the increased granularity from 8 to 16 bytes.

Add an arch specific implementation of kasan_mem_to_shadow() that uses
the logical bit shift.

The non-canonical hook tries to calculate whether an address came from
kasan_mem_to_shadow(). First it checks whether this address fits into
the legal set of values possible to output from the mem to shadow
function.

Tie both generic and tag-based x86 KASAN modes to the address range
check associated with generic KASAN.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Add this patch to the series.

 arch/x86/include/asm/kasan.h | 8 ++++++++
 mm/kasan/report.c            | 5 +++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
index 5bf38bb836e1..f3e34a9754d2 100644
--- a/arch/x86/include/asm/kasan.h
+++ b/arch/x86/include/asm/kasan.h
@@ -53,6 +53,14 @@
 
 #ifdef CONFIG_KASAN_SW_TAGS
 
+static inline void *__kasan_mem_to_shadow(const void *addr)
+{
+	return (void *)((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT)
+		+ KASAN_SHADOW_OFFSET;
+}
+
+#define kasan_mem_to_shadow(addr)	__kasan_mem_to_shadow(addr)
+
 #define __tag_shifted(tag)		FIELD_PREP(GENMASK_ULL(60, 57), tag)
 #define __tag_reset(addr)		(sign_extend64((u64)(addr), 56))
 #define __tag_get(addr)			((u8)FIELD_GET(GENMASK_ULL(60, 57), (u64)addr))
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index cfa2da0e2985..11c8b3ddb4cc 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -648,13 +648,14 @@ void kasan_non_canonical_hook(unsigned long addr)
 	const char *bug_type;
 
 	/*
-	 * For Generic KASAN, kasan_mem_to_shadow() uses the logical right shift
+	 * For Generic KASAN and Software Tag-Based mode on the x86
+	 * architecture, kasan_mem_to_shadow() uses the logical right shift
 	 * and never overflows with the chosen KASAN_SHADOW_OFFSET values (on
 	 * both x86 and arm64). Thus, the possible shadow addresses (even for
 	 * bogus pointers) belong to a single contiguous region that is the
 	 * result of kasan_mem_to_shadow() applied to the whole address space.
 	 */
-	if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC) || IS_ENABLED(CONFIG_X86_64)) {
 		if (addr < (u64)kasan_mem_to_shadow((void *)(0UL)) ||
 		    addr > (u64)kasan_mem_to_shadow((void *)(~0UL)))
 			return;
-- 
2.50.1


