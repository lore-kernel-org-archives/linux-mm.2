Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FA3AC8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8DA18E0073; Mon, 25 Aug 2025 16:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E6E8E0038; Mon, 25 Aug 2025 16:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D060A8E0073; Mon, 25 Aug 2025 16:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ABA288E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:28:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73AF359652
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:28:02 +0000 (UTC)
X-FDA: 83816416404.01.8AD89C6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5396E100014
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:28:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MLqsJd2t;
	spf=pass (imf05.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYZ+dqLP5QNCFRdzHbpUCXXAFIxaQWi0G4WcLC3mnNM=;
	b=hSH7Jni6B9M8cOI0nNRN4LNWC0lu9axFI/4Ik1un7YLpk5ZrM6fc16jYuXpfAwyFvqcT2j
	7mq3/+g8grkHg9OQQhER88gnffXfEmSncli5w9Bj402tHP9Z7M6l4GmEJ5p541jmmYtkIV
	b/OA5b5phrrFXLeBCeStnh2+YMKHUpA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MLqsJd2t;
	spf=pass (imf05.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153680; a=rsa-sha256;
	cv=none;
	b=A3VYCKv2L2gXAVU8e8jGXCC+0B+Fb8u3QxVLtdFsLDpGObiGVgs6FewcelDGMpwljnxHlN
	UEr2/VgGiLC2VjWKZWAOUP515mmVRuEhXZIEN3WXBgqyHAvgnPoyP9wjWLNjzDf21hvFdJ
	/XWpCI5fvaBQuVtV+M6mBF5zVt4K+1k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153680; x=1787689680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dMA5jYCjV4+NamgNRk8yI8/DC0XoZzSYJsm5xOSYSXU=;
  b=MLqsJd2tMMNDRCKSWw3YoJsDeAjB4Jt08SBb3rws8j3NQrtbv/3K28MP
   V+R/4ZSfWvacJ8PEFFXjpcq8hVNle3CupPJsJc81G5SEJp6d8zG6eC21F
   nBtiyuXzNJxFZXbd9h7c+zqJ1lDQYGoZIhhBaO0CHGlbZ22HPt+wrb7ZT
   O3mmeDFh2V0PCYBZPzRxHUf06PhMghDK3hLPssZQLFz/ATLea6WovO6Yw
   fsXK5WdOGCdMn7ofJXizD7jrYzke1CE9KuFAClI6U+4vNsmxZqEjsBOZi
   Q3pmR3KjFqTJgAWEzK6CFeGYGvzW+xsOEA4XABdtkRSxwmQpd9GvHUJVq
   g==;
X-CSE-ConnectionGUID: 99QJaxWQQSm63cHePCKP2g==
X-CSE-MsgGUID: 98SCfzHkQMmezHuRJbCJjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68970563"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68970563"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:27:58 -0700
X-CSE-ConnectionGUID: TjWS6R7AR16c56RIZHi+hw==
X-CSE-MsgGUID: 97rsnWJETkOP5iPCSk+S2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169780379"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:27:38 -0700
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
Subject: [PATCH v5 07/19] mm: x86: Untag addresses in EXECMEM_ROX related pointer arithmetic
Date: Mon, 25 Aug 2025 22:24:32 +0200
Message-ID: <c773559ea60801f3a5ca01171ea2ac0f9b0da56a.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5396E100014
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: oxb3rwpz8f4huyrde1rxkgzse3ugebtg
X-HE-Tag: 1756153680-766200
X-HE-Meta: U2FsdGVkX19DUSwcoBFtAsJmJya4lYS5g+XFs4TzP+y9E5oCi1k6Ewdu+nCdGgLyYPbK+ZXf9xCPIPKzlM7OAV1G4B/U1fRD6z+3K+uDxd0QNLUReH8rm5PyxuPSWqqV6floFiKinqckw5l9DAaVZUiM/D78rhw2LHZdbVGdR0ZDgdq284HtbERWD6jGVwu70LZyLc6ctg5RR97TDfYPmdetvl0FQoIt6NchhlSR3el4c7LpWDLI13jKY8i8jAmXt2QI+9ZOULptLVc2eCH0/11ydjgoKqep58pyIjzqy+BvM49ayPS5nL/N6kSztrmrCJKuRQbyVgdBUTcuotyABcXm1o0EeSnBFNFunQLLLNVam9XvkOPI9Pnxjn0Kk6Jy0MVH4b3GNhrfimb/K48BkTk7sZW6N7tI48reD2Y3SPftv8knrkfKq3zp9ZF3hxPz+1UlbvypdNZcsDNwddEYZoh2wmmrF6HweqoiLbWwTm+mmpgcDP8lXvFKtKPw/4snctSSMYC5G8TwJDTYb5W6KEENLSxNX38HiFSZPB/iXRw/pvrXVqYRjW30p8WmIUZCb0gi/Ql7MyEB35RE0Cek9fBXktKMlut6m3P1F0e5/VzoPHmLELYXa8nKyBoUGpMVNdOd9ZmpE4X1PjFlLFv30esgFw6MuslYZbBsXTdGAJ8wBkNnZc1T3A9oyK3FgXyEUP+VMuBlNuHPhwT9tllQYf2Gv/Q0NYA/i6yFJDbDJv79M04Vs7La6bqtHVP0VqNf0+ir3mbNNgu/YPePfqVliHcKapZrNUO//hGZslLaQwDWaotwUajPfD/Jta/Vx3vtyXZrqzIwOS8Dm0SykKsBiZZxv1BRRaV+8t5Q9g58eb0YAuRZC5zNoIyeHxhSfhSPxJg/MNDhmz5tEwR6Zlpbx/lKNWCd4J/dY0UXDmMIOLabEGU7SDno6O5plrBdGp0/5RYbFJqOKL6yJkd1BLN
 TSXUUCNL
 F9Qacz1oUGm/GUDPCVC65YOblc0Zl+0V6Pft65J2Xqr2JajT3GN3Yo0LsaoECkmE6oqCZs/MKkB2s0vEFsN6CTgZnt+6yqKq3yXsiFodxdy28ywcanUgwYu9fUc0Bh/+8VHZ/i+BK4wvfxnp7TU/D3srs4e6L+2p3ZDNZrbNwJ/5x6qfFUCyvY5EmYrgufQRfunPfnUsXmAFMvTdeHRlTR2hPJmSXTEVA/egUQ4JLbtQtLEB1zgnTgXs/395FKMWB59IBU8LguQKzm1waSnfrMUJna7HhuRXkv0AH1OunRzAtqBfnXUYZ+FL4Xw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ARCH_HAS_EXECMEM_ROX was re-enabled in x86 at Linux 6.14 release.
Related code has multiple spots where page virtual addresses end up used
as arguments in arithmetic operations. Combined with enabled tag-based
KASAN it can result in pointers that don't point where they should or
logical operations not giving expected results.

vm_reset_perms() calculates range's start and end addresses using min()
and max() functions. To do that it compares pointers but some are not
tagged - addr variable is, start and end variables aren't.

within() and within_range() can receive tagged addresses which get
compared to untagged start and end variables.

Reset tags in addresses used as function arguments in min(), max(),
within().

execmem_cache_add() adds tagged pointers to a maple tree structure,
which then are incorrectly compared when walking the tree. That results
in different pointers being returned later and page permission violation
errors panicking the kernel.

Reset tag of the address range inserted into the maple tree inside
execmem_cache_add().

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v5:
- Remove the within_range() change.
- arch_kasan_reset_tag -> kasan_reset_tag.

Changelog v4:
- Add patch to the series.

 mm/execmem.c | 2 +-
 mm/vmalloc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 0822305413ec..f7b7bdacaec5 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -186,7 +186,7 @@ static DECLARE_WORK(execmem_cache_clean_work, execmem_cache_clean);
 static int execmem_cache_add_locked(void *ptr, size_t size, gfp_t gfp_mask)
 {
 	struct maple_tree *free_areas = &execmem_cache.free_areas;
-	unsigned long addr = (unsigned long)ptr;
+	unsigned long addr = (unsigned long)kasan_reset_tag(ptr);
 	MA_STATE(mas, free_areas, addr - 1, addr + 1);
 	unsigned long lower, upper;
 	void *area = NULL;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6dbcdceecae1..c93893fb8dd4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3322,7 +3322,7 @@ static void vm_reset_perms(struct vm_struct *area)
 	 * the vm_unmap_aliases() flush includes the direct map.
 	 */
 	for (i = 0; i < area->nr_pages; i += 1U << page_order) {
-		unsigned long addr = (unsigned long)page_address(area->pages[i]);
+		unsigned long addr = (unsigned long)kasan_reset_tag(page_address(area->pages[i]));
 
 		if (addr) {
 			unsigned long page_size;
-- 
2.50.1


