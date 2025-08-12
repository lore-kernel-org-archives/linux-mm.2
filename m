Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E7AC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA0E8E013C; Tue, 12 Aug 2025 09:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFE478E00E5; Tue, 12 Aug 2025 09:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6878E013C; Tue, 12 Aug 2025 09:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7A898E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:31:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71F43140341
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:31:12 +0000 (UTC)
X-FDA: 83768191584.21.EC792E6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3613C40014
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:31:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nK1AKjUy;
	spf=pass (imf04.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+edTXQcTXvLIKifsLnkJA7/3GYnbD7057WahxLr9Lg=;
	b=JEK8cha5L9wsjKcwhKm3Og0eBnrw18/r3rB4RixT9ONp17fCuOMiPDRkKRn0TrnG9Xp+Ws
	e+gDj5V/V/yo9IFSoDeFyYlCLsdiJ5zjjBTQYJLYoFB1MPLK/S4lgUgGCS40/xaN1hhonb
	E53WkjHadKpGhI4YFAWlNaIP1HwTjjA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nK1AKjUy;
	spf=pass (imf04.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005470; a=rsa-sha256;
	cv=none;
	b=QNKntK3CdkInw++Do8oq2yHuhunsazJ0iEjO1ae+iVi4RxAIfxuNizMNX/emxagK9PC3zi
	ViC4Z1NpjbuYBaz0ucG/sKRK0TH9UaVvlVhvMUqxjSDq9Rp2IzyDpTpFaJHAOgKHMtgAFt
	KSpzlR+aqC6SWZXfBh9lab7qcivD1t0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005471; x=1786541471;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HiW8X4qWeN2pPHljIwWnxU5OYoff7Zyp0Lg8pvxu5HY=;
  b=nK1AKjUyYi6WBs7cyayjbCZ7OIorcJSzLL6S1ci5T8FzBrnF7xh79jXJ
   1IiSSJNPbF7Xof3Isw2io2lp2X7VXTNVv+Ds030CkLFRCiANrmCHHCPWx
   DWA03yyKYlxit6K/ygY32/tXW9/76q23gZJl5ZUxVOMfBXICO2FplHgmn
   H181oH5mtZ1AH2tTTYxHGNlzFlC3BTQA1Haug5XQeBdF/bZAmdnblob0W
   06NxLlSHCgs5QJxKTFuhDU+YeNRtae+zoJ59fLkXMmxvkhsBf4SUZ5COH
   7pyk6/hWw0lq1h5d9tP5fdY4QifOdPeFBhDIHMtDeFVqR3fZUdhkqUkjh
   g==;
X-CSE-ConnectionGUID: hYBqly2tSS6GLkaEuUCUag==
X-CSE-MsgGUID: hpSrlFLMTtycIEOLtmbBPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60904083"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60904083"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:31:09 -0700
X-CSE-ConnectionGUID: 310Nw93RRXy9OmSdy8cVzA==
X-CSE-MsgGUID: xzKkOVDzSASmChbZfONGbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165832087"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:30:43 -0700
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
Subject: [PATCH v4 16/18] mm: Unpoison pcpu chunks with base address tag
Date: Tue, 12 Aug 2025 15:23:52 +0200
Message-ID: <f3519195a98428998160d272997a3d2ed6c53c6a.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3613C40014
X-Rspamd-Server: rspam06
X-Stat-Signature: 7tgc3wd3mtb45nz6uy73yfourfyqop3h
X-HE-Tag: 1755005470-693288
X-HE-Meta: U2FsdGVkX1+vp+9kxOiw8gaKMeiao7OTxJgo0K8rhHd31KgZ7KKYX6CqS1ylPV8X8X5otVj9QorGLhTJa1ZFzDo7bOopYaTpe+zcREMSyFPalG1Q40Lp2MQjjqlrnq1EFAgz1q6VBGY8uYMhJ6zSJ3Ob0Pu98WwEG7vTW96SXBz5Ewu7S58ifXTyXmAgLHLjGXLVq2BMaPfO0ae6fdT6pjY2l9mMylNFVd4qkHy5qn/xyO3TGn20K/dQyHqTSSvkwgEH+QokBmvZGrbgalvykqf8Uyd8hzPjSdLBoSl3vyczL8xTKwZmHHR+EjHckWjRIpgKojQCVS9M4Ny5U4SFhabhJu9m5Le+xYPjCzGj9jvMcik/BQ+GlVzrcI4MTdHz6BwkK7MuaMP3ZKiKar/JybV/7GjgB5qHibBUPgEdal3YuiZODvdoF+yBpMypnRnReL7iHvbem8m99gyVnbrZBwmxrKZkleoJOnsj2fXK906WK9+8VyrpgZnu6F+Mb90zbTrL70KwBnyLQu8HUUp+zWMzCBoN30jypl9+pwPOKoIMzQGJqoj1IbzmNG+zaup1MI9X+EFROfWfBxeSnXLcH8PDNhH0f6p447pWdCDKzUsz+p/DgtAcMQh9sTebLU/7h9eDsEh+8nCjmb7/mLG/OwDkmbchm4w1POobWSof/fBmtk3iR1nKxXph839IgS2f/gIeI/1DyhnYLKgNJTl3y4bacfMuDUIrcxM8MdkXB3IPMSomoFkOfSaejafEa3+nyuwX+WTs+V0ysckN9uff+q2waStrlSLXoTNSWWNAFXDZjbYdOBN/h/Ikamputm9ixhTt9sz13vH4kdYQNJAqFdAC87W/OOpN6TKcpNazfh8DnqjEyEY1/9vtfs+UynfW3njHNzzA1ogYz9Nu3hK6ms0ZD15UzCcaNvlFQ8wP2OGkhQmXpbvWwmqlxcGr0pnKyhxmqU28F2776r1ZZIM
 vfdZ1yen
 QUpYxtlWaeP9U969ftXIs18HQNmjahX12EuI0vrFcbHTtdDLPUew03Q1leJ12C4FGdqjVOKPiK7Dlpz9akhfK65xg1W7M514qW/P1LoZFd7RlfrBNQwbgc5oSr5IyPq35Y/X1VhGZB+FZYcswXUsU2575g00OguwdEjqs3RNu4gT8iCYavJqGDnc0DVfsUxaTnaBqzSUEq6rV3ZEn1z8UxtZ0CKERPwQK+OJBlZasFU8Rz+wFVsLdJuHmDt8kAUQbYUw+Hy5kJ+rA1uaiEegHoNDSPz6J71dUWLX0cROwN92VXeowDd5vKlEJ+BkiHGXZavzo
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
index 83d666e4837a..72eecc8b087a 100644
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


