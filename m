Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9E17CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 409568E0076; Mon, 25 Aug 2025 16:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9CE8E0038; Mon, 25 Aug 2025 16:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282138E0076; Mon, 25 Aug 2025 16:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 11EA58E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:29:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A42EEC0510
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:29:05 +0000 (UTC)
X-FDA: 83816419050.08.76837A6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf09.hostedemail.com (Postfix) with ESMTP id 91D02140017
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:29:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=R0+tyzln;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153743; a=rsa-sha256;
	cv=none;
	b=pW7fXICLXePf7ZatO1FXpd6GOXvjgHlJzo9+tzlYwCgmJRgbJSP384IRYNftlksWSGlxbQ
	nz0yyRNX61nZJG7R4I68BJm8QhgrSB8m4fW4XNTZXQDpBnon7svyU7Tk4/ymaJg+hn6Ive
	05pDKzMhdbfQqvlo5CuWN3gGukzBhDc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=R0+tyzln;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3VrKnxx0tLdbKl27xV7R8JaVVS1HXCMAhrp4rAkEYCM=;
	b=WAIR9a4Zhb3F5RrlgrvMFTDLI/AHQAq3TYvts/svaeXu4m9ltu76r/AMVQvLZDuAAgrUH7
	RUx41ZwrjR2y1eZUMfbMM57xVvF2IPD/1eoQ4r4MOUD1LmS3bBhsCm1IXyx92ZkA/wWJL7
	3/HlmM1ANB7vdatYfjWTUV7mMfubRks=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153743; x=1787689743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/h/qS5k+guufmpe0QiUnjnkdA3RIS+RF1dHh88nhkcM=;
  b=R0+tyzlnURCKzVOH/YG3kG49QFxq2Y4bOq+w7PPo3XB5TY/4kinlKdaE
   btSLNDGxYsreS2vFj2xmqZEqeUlYu82mvrH1vOkPgQx6zIdY/zrXdduBs
   X5kwYP90cntW/nNrQ/ycMNqbtb9Pc3D7wLyTw/FaNS7uvUMdZNvRq6ZdA
   7FvAGFYJliMiWAdn6K105Ys09W4BsdIFtHdxDFAgovFO1CDZrq4sM2t/t
   5/Qdbaf/YNM4UcPmHr3iw/sh/wUK+G4vxB7OUeVo0ctZAQr7ek6pSRZkP
   o3yJgAK3KoMGOkUyN6kTQKJamsAmnrwXNdRz25ENHGyeAlZZYKMnk6XBn
   g==;
X-CSE-ConnectionGUID: CwXqvBuYQHGnfSbHqRUdKg==
X-CSE-MsgGUID: 00WMJG8sQl6yH8P6d/14ug==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68970715"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68970715"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:29:02 -0700
X-CSE-ConnectionGUID: w+rKNHaARBe+f4eoM8vVOQ==
X-CSE-MsgGUID: /Hw/gZN7R822ANQdWoGk6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169780519"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:28:39 -0700
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
Subject: [PATCH v5 10/19] x86: LAM compatible non-canonical definition
Date: Mon, 25 Aug 2025 22:24:35 +0200
Message-ID: <c1902b7c161632681dac51bc04ab748853e616d0.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 91D02140017
X-Stat-Signature: t869pww43cucckah5cqdgfnat8rmqfs4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756153743-736402
X-HE-Meta: U2FsdGVkX182hoPKw3I0gTiOdRjK0PQVuiJgj7ntSbPR4YwVr5sDut5QGdXp6wgB82VzVWdXDwaVL/MJjV1utI5zugfmOrfhfp7JaP1fjYBoZeXrLilnVDW92Q/Sd1T5bmn+G5kAkAkPG1OtntZjl7aYShMSpjagvkMahtl3I4a9iS6b3iSTKuitWblHB6d53zd1kes3QFQxHlQG9I8L8z09q7Za7PBDuKGGUkJlMM1CsVqmMDaW6D6mCp+FCS/yTwX7KtCd7u6xr5yXP5YeRILV9uZ0uQBLsw/j2eU6ouB+kOBjR2y5cc9FSpfjIxbiGcEdI2r1GL8VG9avgRp6dGjG6Bm0aYKDJEsQj4Em0egmbug/0SATt1fiXMN0Yr0L7eBScL2LlTrI3WB0SxrxC3x9P4je213ZJN41Oy8Fj9GYWV56V78VCrFk4aHhaTZLwpa72G9hkB3wgSBwWwdtxozr/K5kUWJhkHt8JlwBzyR+Ot/U2JbzXRXHldSVkcJU4Ma1akQ04kqKVYmjlH+emQBAKW/Or7XBVtnqkLtRqZdKF7VbjYJcqZUyFD+86DDTpGYwHCi/uAqYFDhMu57hBTkBcJ+T+J6i9io7eI+foUOaO3T3HIBHIgFChvfQzfzrVZGvjuFtQki/rfGmCSD774ssi1aBJ7T7NyUqlZ0eBqy9wdy6YYpVi/tWYD7pjEtadvJOYrFnmK5arSgkxgRfspD1WasQYyVIgiCUDpc0GIUjAeuD7MhNO+JYtGUWxz2Ltbb7JZh2Jj2VdOweARCA1PXT8kbe8RnjVfL9TBxBXPhBz0QMzEYApxMrYc+BLW7FeQ7t9s0zW8EY3gHTw3vXvE+qaRZECLTQZHjaIo0VXW9A3+XUz4f0o1dIce+ROcOtxLIGXbuexIxlCYvVGRnvu+CQnkwtuclKJCmy0BNzq/b7GWC+hXnFJzq26t+FvE5KvenBytcp03w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For an address to be canonical it has to have its top bits equal to each
other. The number of bits depends on the paging level and whether
they're supposed to be ones or zeroes depends on whether the address
points to kernel or user space.

With Linear Address Masking (LAM) enabled, the definition of linear
address canonicality is modified. Not all of the previously required
bits need to be equal, only the first and last from the previously equal
bitmask. So for example a 5-level paging kernel address needs to have
bits [63] and [56] set.

Add separate __canonical_address() implementation for
CONFIG_KASAN_SW_TAGS since it's the only thing right now that enables
LAM for kernel addresses (LAM_SUP bit in CR4).

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Add patch to the series.

 arch/x86/include/asm/page.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index bcf5cad3da36..a83f23a71f35 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -82,10 +82,20 @@ static __always_inline void *pfn_to_kaddr(unsigned long pfn)
 	return __va(pfn << PAGE_SHIFT);
 }
 
+/*
+ * CONFIG_KASAN_SW_TAGS requires LAM which changes the canonicality checks.
+ */
+#ifdef CONFIG_KASAN_SW_TAGS
+static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
+{
+	return (vaddr | BIT_ULL(63) | BIT_ULL(vaddr_bits - 1));
+}
+#else
 static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
 {
 	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
 }
+#endif
 
 static __always_inline u64 __is_canonical_address(u64 vaddr, u8 vaddr_bits)
 {
-- 
2.50.1


