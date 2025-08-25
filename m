Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F37FC8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E39D8E007D; Mon, 25 Aug 2025 16:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 593A48E0038; Mon, 25 Aug 2025 16:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B808E007D; Mon, 25 Aug 2025 16:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30AFD8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:31:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAF57160423
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:31:33 +0000 (UTC)
X-FDA: 83816425266.17.6287EF5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id BCA57120011
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:31:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S7THyHCe;
	spf=pass (imf29.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153892; a=rsa-sha256;
	cv=none;
	b=0fO8RYJyVHKkoHZ2fjXDSeUYnJTmpu9XmTmzA62o8dqBY3wCHV5uKuM9PydGfkmXe991mW
	6w77n/KPwbfnp5wXls2oQVFbWEQQ9TeKhSuEDD5eUglCtiZIkW/DfQbxjdQKlrPc2WUb6x
	9ug7nxrTHsFYniALkDouT6vtvXemr6Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S7THyHCe;
	spf=pass (imf29.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FgG19j2BqQ8cVtEc3PQrHQvOEoJlx9KCZ9IJnwkLDpc=;
	b=wPEPe4vTSyPGQMD8qnJ72LYG+1KLD7dAmGSTKBYHhev6ezxG6a6SuYw/74byLKDFie76ft
	j6/igruB6yUzeb/xfb/hd1z/qc0pJ3mU3fW8gtVqlAS+d4+G5ZhRSlrh0Ax7RrXORQk3o0
	sobjpNQ1j4v2W5U2JCS2SDc690hSaFo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153892; x=1787689892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JSgqcace1ZHH5nH7cPzoLy1AXwxiMzBjeR3CdVvlZ7Q=;
  b=S7THyHCep2Z8nO2k6U9ejp32q4zcHTIvJAI+2ZX+yr88m3+x7nBX6NMT
   gNloDlZhy+fiBF5fnVKRzNbY5SYeWzmaSxnRUP7OkEzNvT6a2aWeQJaX5
   rqaWYwEx5xk5C9PyVaSwxDPnSkarxsge8VM4S4ggNKQhsjTWYDLw/ClCu
   qS4RbYhSlKvsEFJ6WRetHCOVW9pZQmZpDadlyzPbJAEgUW8l8DRUgVVYz
   z0w1NVQpGc6hFu77ZY1NuMClvmk8LZ1kflPV/7udPFkERXgI5+TkmYK8q
   FGODjww/wHNf8lK4kmFnDahGN+edgIE6mXbB5JGr3mgT9011YZBy97U+n
   g==;
X-CSE-ConnectionGUID: GAYKT+M8Ry67ErKepaJJ9w==
X-CSE-MsgGUID: SFK7koLfTdekRhOhdY+VYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68971164"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68971164"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:31:30 -0700
X-CSE-ConnectionGUID: BoQjm7KIRB+2p+yFhmf/bw==
X-CSE-MsgGUID: iY6qVZe4QbiO9mWsK80olA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169780999"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:31:11 -0700
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
Subject: [PATCH v5 17/19] mm: Unpoison pcpu chunks with base address tag
Date: Mon, 25 Aug 2025 22:24:42 +0200
Message-ID: <bcf18f220ef3b40e02f489fdb90fc7a5a153a383.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BCA57120011
X-Stat-Signature: ae6s1eww6gij7pb4bobwmg6ujwqx14db
X-Rspam-User: 
X-HE-Tag: 1756153891-809319
X-HE-Meta: U2FsdGVkX18Snp1RRtpiAQPjBYPZzHifc0AY+XUpYvvRFJiVo/Tggd5D8EClgXh6uSuG+7p2uQPkN9iLfk9ANLYLBlWCRPiPzgMzfhKKfuFFRgG2PrMCQ02YumPFdQK1QQ2Zgcv8bmvEW5JSHSIb2KeGnecRajqQzm/FItpwv6seUX1o6QSezvgeU0pNsYs6U2UnRNitqHxKkl/t5GJcMMBXUZukPPrhE6CFdJsYefOeh7w9Z0IwBZMRsPg2dMNvQd9gASEYrAsf5aDdRuJ71N/2QW3yPh4msv5FfOMrHeuW1eh1Z9P5gcm69wTM2VuxRQs3qV5jTcQ72K9M9Kg4rZiQ80kF07cU0dSCTWfQBSzqrqY8/MV0ECXHs3x4FaNQUu8a7/5U0m1oqunnnCXhxqYO46hS+zGwdwt2yX0NXUhMBK9rEVXpTyASAIr4nbhgRN2FYItt1FbUVhNyId+qa4jSrKKYSbmF9LuEbqz/z9+5OSCA9poWGJ6LX+eJJ/1B+yDA5cnN9njb0PPnXII/H43M+2Gp7QY+YoCjQjlh4+FJECphJ7aizbxzxJxkye8WS6MgI6Z/SzgD1stWVq+CY7Pbohb8svNiBd/3l+GT8el1OedcwG2tQRt54QKjc6jhh/00hlJ0ID4MtkYAvBh5PdZeeBeFCBiobPFc+uJh7EPlaT6120Qdxb1AK0WGVoEo5aAx6wsLfbD48Tb0pEIHEp8H/4kCnkoc1pAC+Syl3TjaRuG1cfaTApV5PRf9FDFPUa7hPrUKn9WbM8EJuDVOGvQ6ZFAPyqHh4TPh1qoOlrfWcXqlRiCEuI2j44L29Fge/hc2XeHBGaHFb2FF6iA2BJ3/jKhgtZpEqMzHpE6ocWCFHArgLjNSLslk+MULV/MbVnZe++6MA0pnsjWFjVlZXeElDz1VjUC1wdQSdOWBv+0bs69wcwSsQemO4MgMkNMU55kh43gepVEd86hVBpp
 lE7aVs0j
 b0/k0Z7rrTWcm3LLIDU9s+yZGosn8KhZ1SC++f7t5FfQB/l64F4E4ulw759Uln0uzTGvuDKyyhDy4TqCxkfvJqAprDnwxHJYugPE4AfH5xCB7uwCqfS6jPZnaYIsa3JLVOrgd0Hqib4hhWBsN0b2hUiqmv9b1t3+lrXkxFIaYCt9VX+6orfpCMzcrFJszxjs7cDni7RP42H/yw3iYJLMQBnHE+iJvuhBWWrq8zHOAipklH6SkgySacC5GCkY0j7gwwLWCMXXcEu3Z0hGZGSPYO2FuU6e92gOFsSgILH5bK3wRSzBfTQsutHQcgAEtBDHzkwCuIAHgy4iS020=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The problem presented here is related to NUMA systems and tag-based
KASAN mode. It can be explained in the following points:

	1. There can be more than one virtual memory chunk.
	2. Chunk's base address has a tag.
	3. The base address points at the first chunk and thus inherits
	   the tag of the first chunk.
	4. The subsequent chunks will be accessed with the tag from the
	   first chunk.
	5. Thus, the subsequent chunks need to have their tag set to
	   match that of the first chunk.

Refactor code by moving it into a helper in preparation for the actual
fix.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Redo the patch message numbered list.
- Do the refactoring in this patch and move additions to the next new
  one.

Changelog v3:
- Remove last version of this patch that just resets the tag on
  base_addr and add this patch that unpoisons all areas with the same
  tag instead.

 include/linux/kasan.h | 10 ++++++++++
 mm/kasan/hw_tags.c    | 11 +++++++++++
 mm/kasan/shadow.c     | 10 ++++++++++
 mm/vmalloc.c          |  4 +---
 4 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 7a2527794549..3ec432d7df9a 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -613,6 +613,13 @@ static __always_inline void kasan_poison_vmalloc(const void *start,
 		__kasan_poison_vmalloc(start, size);
 }
 
+void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms);
+static __always_inline void kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
+{
+	if (kasan_enabled())
+		__kasan_unpoison_vmap_areas(vms, nr_vms);
+}
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 static inline void kasan_populate_early_vm_area_shadow(void *start,
@@ -637,6 +644,9 @@ static inline void *kasan_unpoison_vmalloc(const void *start,
 static inline void kasan_poison_vmalloc(const void *start, unsigned long size)
 { }
 
+static inline void kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
+{ }
+
 #endif /* CONFIG_KASAN_VMALLOC */
 
 #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index 9a6927394b54..1f569df313c3 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -382,6 +382,17 @@ void __kasan_poison_vmalloc(const void *start, unsigned long size)
 	 */
 }
 
+void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
+{
+	int area;
+
+	for (area = 0 ; area < nr_vms ; area++) {
+		vms[area]->addr = __kasan_unpoison_vmalloc(
+			vms[area]->addr, vms[area]->size,
+			KASAN_VMALLOC_PROT_NORMAL);
+	}
+}
+
 #endif
 
 void kasan_enable_hw_tags(void)
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index d2c70cd2afb1..b41f74d68916 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -646,6 +646,16 @@ void __kasan_poison_vmalloc(const void *start, unsigned long size)
 	kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
 }
 
+void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
+{
+	int area;
+
+	for (area = 0 ; area < nr_vms ; area++) {
+		kasan_poison(vms[area]->addr, vms[area]->size,
+			     arch_kasan_get_tag(vms[area]->addr), false);
+	}
+}
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c93893fb8dd4..00be0abcaf60 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4847,9 +4847,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 	 * With hardware tag-based KASAN, marking is skipped for
 	 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
 	 */
-	for (area = 0; area < nr_vms; area++)
-		vms[area]->addr = kasan_unpoison_vmalloc(vms[area]->addr,
-				vms[area]->size, KASAN_VMALLOC_PROT_NORMAL);
+	kasan_unpoison_vmap_areas(vms, nr_vms);
 
 	kfree(vas);
 	return vms;
-- 
2.50.1


