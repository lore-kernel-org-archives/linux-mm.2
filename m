Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E66C8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FDD68E0078; Mon, 25 Aug 2025 16:29:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE5D8E0038; Mon, 25 Aug 2025 16:29:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB83B8E0078; Mon, 25 Aug 2025 16:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D68B08E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:29:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9750D59624
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:29:47 +0000 (UTC)
X-FDA: 83816420814.08.3EA0CC8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6848240007
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:29:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dian+jXT;
	spf=pass (imf01.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ex520mDAAluSLXFdiYJ04d7IrdUaRDN9zWUBH2TlPCk=;
	b=lAfN8gKc22zFoaoUozA9qIvZs8yypty6AsD8Sgf6Mvnlu3nzeIXXiyhaUowPxTRElMJ8ye
	EyUaXAkboXsFIXFCxxRYs118xik8g4d/VPdXMHVCuRqredgV2nWv3i9V8Sh2FSLMCxXagT
	ipbpNOu3AL7/qaOuMvKiirn92QYsXSc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dian+jXT;
	spf=pass (imf01.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153785; a=rsa-sha256;
	cv=none;
	b=iU2rJS7pxP1Rg38Nxk0VCPFSDzg+lmWkk+g2QkX1AYr2LNgT1mN21VJ0GDQun9E9I9eOHN
	4AEvXPQDWw5DZUkn5iY9L/WuUMjCHKSthwKVKZHaT8AaZUeFTMx56IFmWFInyfL+owl31S
	f3d0fRRsFP+2mCHIpb5OEdFyRd6EP7Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153785; x=1787689785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9AhOaWTatNb4QMfmox2H6CEYyqT3KnhFIot1r52xKmg=;
  b=dian+jXTupm4mBFdeCqUV8qY5p3sv6MpDJfT6nd4OEyd0VmnQrXbL//p
   mWIWs5AYwqljdYNUDDUaNyre9nxAiDb5H8SxB6kpMZFBBshgQkFKrxT4s
   tIG4TXf6NQ9/HsDaNFjq1deH408IcosjGPo78sRKSaVUz5rWv4QlQuDVG
   0u4b+Yt7BE+9vX39Dwor67Q28oJS0fZwBWhK5j1D1w/r4p09WdKnLM98n
   q5Q1KVZ6lFHo+qMIG080+3neatUwjgAcyFPkyT7SZZCQnJsnUL5cdR8M1
   Cq4UpiFcIN27xs0Oo8oWyLOQlbaOGJSqKOK6gXrKGkcwIXcfY6QhWKVow
   A==;
X-CSE-ConnectionGUID: bDx6hyQgQW6nBfDPONGGHw==
X-CSE-MsgGUID: 5ulhAyImR9i9JRaT3HJOTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68970836"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68970836"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:29:43 -0700
X-CSE-ConnectionGUID: dPjkVayTRFCsnqA9Ybv36w==
X-CSE-MsgGUID: H249bgJTR6CaQrcj46DBWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169780586"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:29:23 -0700
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
Subject: [PATCH v5 12/19] x86: Minimal SLAB alignment
Date: Mon, 25 Aug 2025 22:24:37 +0200
Message-ID: <c9dfcee8bd04161394f41a21f78fc3e01a007ddb.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a5mfwrwaa8xpajpjfiki5w7sno4s65rb
X-Rspam-User: 
X-Rspamd-Queue-Id: 6848240007
X-Rspamd-Server: rspam05
X-HE-Tag: 1756153785-770279
X-HE-Meta: U2FsdGVkX1/OI7jS7EmGF5rM5ugnjv20RjS6lVNvrjLhEGQHK7DwvwLgDWfV1g+DFmm4AZzPANP08dWjeQtrWj/s6xjjJWJPRoahyziaOLTYoT7s71jwnavIjvK0NtaiK7NVTnSIYsJ/TeliRA/5wDu0gu/IKGLIvmj/ULNmQsZelmIrsjaP31yBJdRHMyPBBW/F9CXk06c8jr3wipY1behn1RZFAKgL1c/an5gq6IzoFSzLwgmYD2roeNdDsOPmkknxkdsPqq0zz5bTOFXRrf0attzhcsRbm/3PDITlYyQ9mWBSdTC0Ip0B0/ODPKcdf7DWQbeHi0tM3LDwbDZevkZxdC0IUZJK9/v/gKk9BVwdDfhoxw0xKYReRyf3yynxXJLyN/F5u4PAImqN+/k9eBkUAsUuJxz4jWtveK+vaffMgb9uJJNIpkLPXREMDXtFnSfqaP6p1D3J3m9xhX9to9Vg2pzAIyqepp86qdB4zV67A0EE0jdIjen6U7uxLDgirK4M8KJ8sxPvVd4DuGCUEYDgqNOXycwrHfv9g4rzeDECLH7QO0xsslTyXvp6ZSP+TcYDyDa3xKarIqtHxX2z4YrsBGy9L2ftqlyY3CgnWAfoDpwOddosSWPUoeFWd68P84VnIrcAxu9kGSYOcqkOuNrfsdlvDXzER6KvmxvXb8ZABu/Yj3iobbb7xpoO8qkuTWjOQv3MhCv8BaL8jXW1rgAoblqYffCyh0TiYBIZ5f0BMgvsAxGdY3EFDE+OWp+mJkUH/7LR1cWJzTnfin38ws1nGcZcMNDMMKzuFU4BVMQ/R3+kQH5jgZswsLSw/e7pHxzHBq+uEWSQ63mJuEIvxruOKBDb8UlRy6i4KQJszursxybP52hUd2IOzPi00H3Ub4KnnORs0Lr2DSVPNhZtwpsJFS2t2q1zV/ozdy9lCs0Y+QBDsUFLPl6ExOQa8DzzYwx2mbHQZ0kNrHt49PU
 FWGpCuky
 o7iqbKhb0mxvBtzuz58IShkUdsLki1JmcyzAslKMpng4089yLlpsfoQhNWHLxZ9GIMX37gwbpHir1Eys5ujzA88ruyaSQOH4SY4gzgKsOH+Zv5gxdrYhNKdI8Xih8q8oVAKyBcHk9SZx9jwNdkEU1LLbWhxtF4Emi0vLw++uYGf/io8R8t20hPxZePGfmQDDln2x/hHo/1PajO+v3UWoDoiKdPqUYo77Vi3q9I1C2xWGLmJ8qLpmN74uFs6fTZ2U8pube
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

8 byte minimal SLAB alignment interferes with KASAN's granularity of 16
bytes. It causes a lot of out-of-bounds errors for unaligned 8 byte
allocations.

Compared to a kernel with KASAN disabled, the memory footprint increases
because all kmalloc-8 allocations now are realized as kmalloc-16, which
has twice the object size. But more meaningfully, when compared to a
kernel with generic KASAN enabled, there is no difference. Because of
redzones in generic KASAN, kmalloc-8' and kmalloc-16' object size is the
same (48 bytes). So changing the minimal SLAB alignment of the tag-based
mode doesn't have any negative impact when compared to the other
software KASAN mode.

Adjust x86 minimal SLAB alignment to match KASAN granularity size.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Extend the patch message with some more context and impact
  information.

Changelog v3:
- Fix typo in patch message 4 -> 16.
- Change define location to arch/x86/include/asm/cache.c.

 arch/x86/include/asm/cache.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
index 69404eae9983..3232583b5487 100644
--- a/arch/x86/include/asm/cache.h
+++ b/arch/x86/include/asm/cache.h
@@ -21,4 +21,8 @@
 #endif
 #endif
 
+#ifdef CONFIG_KASAN_SW_TAGS
+#define ARCH_SLAB_MINALIGN (1ULL << KASAN_SHADOW_SCALE_SHIFT)
+#endif
+
 #endif /* _ASM_X86_CACHE_H */
-- 
2.50.1


