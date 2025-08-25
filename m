Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CBE1C8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878AE8E007A; Mon, 25 Aug 2025 16:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8309F8E0038; Mon, 25 Aug 2025 16:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1CD8E007A; Mon, 25 Aug 2025 16:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 57ACF8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:30:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2980959263
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:30:31 +0000 (UTC)
X-FDA: 83816422662.07.C6E21C8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf03.hostedemail.com (Postfix) with ESMTP id ED2F22000C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:30:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kNdFWBb7;
	spf=pass (imf03.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153829; a=rsa-sha256;
	cv=none;
	b=W2MiJNuINbp4tml9Ix8z/9hqbZy6pQZkKOo/8NZpTyrZKyBJkjwmwQ4f07p2Pnf+sIKLct
	WFNtJoQMbhnXdLWwdnemcyWWoR7ly67lkuOO12twhaCUZu79wNk/FWWSvy+Q5zBYaQDpYm
	ER9/tsgv75OKk54VIggQs3BP4suv0D4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kNdFWBb7;
	spf=pass (imf03.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tb40DjADZPAVu1YBMPC2bsaVVCqkmgwDwfx+9HETv9w=;
	b=EpvsLi77s/Dc5z4vK3xHf6COv98ASyYFWshabIEMPHVlOnzJ026Rw42Qgecna1tUcMrPni
	S4aKB5VpSGdQBfmrde9E5UX47xZ/54BJcfS/uRDjd4u8YUl6jWBgTcwbGypPuTpNKh7wJ5
	QovcCuWzkBEQ25aqkDUTd7mdjvwFnkM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153829; x=1787689829;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o2WstSsN3DwiMSlfnUVPQ/30DcJD0g1hms7P7z4Z3ls=;
  b=kNdFWBb75ZwstDfD2ooGa5ncguiiLgu9409/iH9o4SSxJr7WFr/t8d5/
   IiB8+v+y8dy/s1X5DHOIqVT4r6K1zmhlhY7vocQQOb2RLqQJgnNOADX7q
   VKXaegYMLMrkDRHw0RaeYrqiBIlYLSoOB40deJ7DY080Akr0M3tBM0EiJ
   vgJHgTJuUUAxL8nFCsw5ZyIO3CosDaLJCJEiCB/7NjPnShXwmvyz1Y8N/
   S0S09w56UBKibI5KE8IotxIDyVi+0b8poGEsRG9JkUKfnnx7zpTmPfV0h
   NFpZQTGnsR8Lzy7lNwQGBIcDGBzmL5fQguTRrXwRgNkLWoT6vZ8uXUDiu
   w==;
X-CSE-ConnectionGUID: 0/qm1UCzQcG47jorrILUJg==
X-CSE-MsgGUID: fgZvljwyTNSnag2iTOSuyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68970984"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68970984"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:30:27 -0700
X-CSE-ConnectionGUID: nLGGLHJ9QoyoMNF1I/U6NQ==
X-CSE-MsgGUID: HzKVIVamQzSIU+bcFYV6OA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169780844"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:30:07 -0700
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
Subject: [PATCH v5 14/19] arm64: Unify software tag-based KASAN inline recovery path
Date: Mon, 25 Aug 2025 22:24:39 +0200
Message-ID: <eb073b008b547cf87722390cc94fe6e9d21c514e.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ED2F22000C
X-Stat-Signature: 17sc1jti398jghihuxicspenym1on8e3
X-Rspam-User: 
X-HE-Tag: 1756153828-294246
X-HE-Meta: U2FsdGVkX185Un5ydzb5+LkB/cX9u2NtlkvXFjU0EYfhPKpG37cAcS/wUQ4a9KSvMH0Z145Mw030N9BtIAkCMjOFj7Q5Sxzhlvs+phwi0XxlzQoEXOIgIK/ts84MyJ3gLssjdfbI6Uo/fU60HsvnJ63B4byis4DlhfyWkVkcfwodWsWQ0JXA/IV5BpuukTh2ZN35KrXgfxE2iYH9Na494PNtrZSZe/qXofi81RdDk/nkz8u30gSQlvWAS3LdBAXt8FAOr3rFWR7oHH+FoUi6JYoTkNztqQtWtGrZj+i/wNchEEkprCEAEoc9M9uRH/0lpHVLiY005orbWHA7b5Sm5VJ+EYC1mZz8J2c1Pso9pDvhGpYuqdcyUye215vEN9pmibXmZPhtLN+XQ03fKU2M2bHGq+3FRrofpW/1FbuV4pA3TgO4Rg3zVWD8SCdsOfmFVOU88LlcOG+eF24Ua/FRRJH076HI+drd+4n4Z8nofaqdTE3QfiJW56MKmUgM49YB7rGHB2KW8l25TQTKNGyVQm2Qh71VpgpvZTu9A4gU9V9200fxpW72A6AIIyq2Wdkt4YJHN0/UrhCxjW7GB7yGy3FD5329NdZ78K92wEog+7WbYqqTPQMmoqACVIGABiFZ8Lv3j9Ur3HTAE4TUNqHVR+gT7HyqB953d+Tgwhmd8votWiv7lZy6Eoq9Ih4A2xFwovIqVX1WrXjebXk4HNjihtGY77H6EQThmInRXFgZbCPnnJWe4W0XkDUByl7MUg14H7Qq+r8fJ7btFCnAHvJ8rM9Yq3P3kV35zt/Y/ddlKK4n6K74Jmbe77RtLht3eej/5gtWz41idZv4XYBiSebzUCLsVxDJlN4c2pQyxhgTJ47f87bOa5yumAmJhvr5XCpUuTVSUZhEyg2bEMMf+0sfQGEm9im6bHp4lY4LMweffloLNbO9euGXEnib5Juz/kLWiyRBBllUDukGjXk1ETO
 iWus/Nbi
 mPGOljYKa92ui9eT5gmArttoxIMSJ+nfTQ52lj6vJ7KrLHIXFgj8gejPEd/ZtuJES5KZ4ZCJFour98YTsAvyTMgegU4B7JBa6dV0w4cMsPbxNfB54S6/HJruraqHGn5I+f0+Ojix/YnW7fm+mjeAZVTjBT2ontUFXWfUKpl8N2Q9LY8PZFUbIvHwALXw/OsRqSycTsYmEF0xHMtdEiyxwIp9CPX9OFvcYS2MNB4NqU6pBcfiTLMH/XQZ2VqaB1zjXLfkC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To avoid having a copy of a long comment explaining the intricacies of
the inline KASAN recovery system and issues for every architecture that
uses the software tag-based mode, a unified kasan_inline_recover()
function was added.

Use kasan_inline_recover() in the kasan brk handler to cleanup the long
comment, that's kept in the non-arch KASAN code.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v5:
- Split arm64 portion of patch 13/18 into this one. (Peter Zijlstra)

 arch/arm64/kernel/traps.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index f528b6041f6a..fe3c0104fe31 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -1068,22 +1068,7 @@ int kasan_brk_handler(struct pt_regs *regs, unsigned long esr)
 
 	kasan_report(addr, size, write, pc);
 
-	/*
-	 * The instrumentation allows to control whether we can proceed after
-	 * a crash was detected. This is done by passing the -recover flag to
-	 * the compiler. Disabling recovery allows to generate more compact
-	 * code.
-	 *
-	 * Unfortunately disabling recovery doesn't work for the kernel right
-	 * now. KASAN reporting is disabled in some contexts (for example when
-	 * the allocator accesses slab object metadata; this is controlled by
-	 * current->kasan_depth). All these accesses are detected by the tool,
-	 * even though the reports for them are not printed.
-	 *
-	 * This is something that might be fixed at some point in the future.
-	 */
-	if (!recover)
-		die("Oops - KASAN", regs, esr);
+	kasan_inline_recover(recover, "Oops - KASAN", regs, esr, die);
 
 	/* If thread survives, skip over the brk instruction and continue: */
 	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
-- 
2.50.1


