Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DD36CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC20D8E007B; Mon, 25 Aug 2025 16:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6BEC8E0038; Mon, 25 Aug 2025 16:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D338F8E007B; Mon, 25 Aug 2025 16:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BCE098E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:30:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84F631404EC
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:30:52 +0000 (UTC)
X-FDA: 83816423544.01.0146983
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf15.hostedemail.com (Postfix) with ESMTP id 859D8A001D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:30:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mex5CDkD;
	spf=pass (imf15.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XP32GgD+gomeVeYmlRqjPEh/ESuam3YgqvUl7LwQmAI=;
	b=PGQMVKSTW9KCnbcvSwgGFdCesW9AJZ9+e96b24kU6Wb4NN1Hr+LbP7BcTns8SUD8GE9d4B
	J1ph6stPWpVbWdTUQFzW6a41q53gkU5A1FVQG56gbMNk/4V8A8yMoOO/1eVjvoaAS3t3zA
	Jz+zhDvWPZCxTKy3C8el/FuJ4LPSBuQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153850; a=rsa-sha256;
	cv=none;
	b=TBEJQhHqhQfcVwFWtU/Noa0IGA7PlN+MLT1nAOU1SsprjdFGwpztQGSe7InoOC5ji1IIf9
	p6x37y3kJU6Qb1lhmVDjz4YRBWj6pzQWmtDyzQAwpPy2+zeIa1y7jqNSruurhrliwUA81N
	o79whcgBIDz/5fGA67tu1zmB6HEBAdM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mex5CDkD;
	spf=pass (imf15.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153850; x=1787689850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o5F0wPdxTZ0bQcRnx5I19obOwawHIRj4vxPdiutM1tI=;
  b=mex5CDkD/ANAKmy3gBH56xVFNyRPTF+ocF1HtHbNOvZwqxJGAVTKglLE
   E0+CNFlkJ3cJ06pT09THIQLD6lX4Yn/pR/nPhupJcjUacgdTutMdoQN34
   z/HGXBnoad6o6YYJRT5w21DyZIC8X6WIBxqNBPb2lW2XwYinDBNUnQfXs
   gpgezLpaAGay/nBJRDaKB6aKeOZkhZ/w3rvtdGOaA9Md95lgKAH3e23gF
   ta4LY47rcqVGCq//YoaqaKTAsSUsDfiPvPOYLhTo937+bOwDPpcS9RMU9
   od7X8oc/Fz7aoPLbbq7PBsOB3ZS961T6HVIJMxW6RVD6otf4zNefZqBbP
   Q==;
X-CSE-ConnectionGUID: k6ulGiGDTN6acRqYzFmhsg==
X-CSE-MsgGUID: d/jW/CtWSc+sgrEk7fMB3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68971043"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68971043"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:30:48 -0700
X-CSE-ConnectionGUID: K2BRmtlySGeelzThEKb4eQ==
X-CSE-MsgGUID: X0GDFQZSSQO4ZbqrrO+rdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169780899"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:30:27 -0700
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
Subject: [PATCH v5 15/19] kasan: x86: Apply multishot to the inline report handler
Date: Mon, 25 Aug 2025 22:24:40 +0200
Message-ID: <2f8115faaca5f79062542f930320cbfc6981863d.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 859D8A001D
X-Stat-Signature: iuqa4xdabaggzyxam1k8s8onxy65myjy
X-Rspam-User: 
X-HE-Tag: 1756153850-335875
X-HE-Meta: U2FsdGVkX19HToYqwCu+oo9pDUHGvlP/KjFNSM4rcuExfn5KlNiRCnnEOPrNQWmq3cdxxUdXUgOgnKwJi+I7lhZCVBpTsRVkSzICHBxguywy5mFbhXe+rPAgczjcmHcOqNm5naJQbLqFz9XSGullKZXttRAnsVkLyBwz4JXm8mHmFXoGDtICgLSGIKX7NfUw/EP/zltJLGSgZakbCn8xf7p/86ykVEeCt4dN/q3+Mg0Al1RL8oXCpIWn6sc5tEj/Fk7b8/UwMUDTwLVedBvwGYtextuiFv+GKDXN8+TJJ2s47ECZI4ORLkGau3wGLHnmq7td2qU0rUnpcyGZFQ3ts/qYL45tISJbngX2h9vhdyB9PMZy7h+9tgfSSndYShlB6Cu+MDMkXrjS0kDoYU0AtBW//jjxWZZ8FuL5TsuGFmvbG6aVj//JzV7Y1I/wAUOtOsspUtOc4rzS9uw5gj20ZdGqt/OkhEedEVvfHjoQPgf2+wIfwgEnXMfAyEOEl2nSHkyltLqsXHNnRlHaTqjTDXpxtdt1gRAlodtqlbcFF4ZEw80TXtupC47IaZ3Y3m3Smk/RZXzlWsxTIv6gQg7aBUPDupxlr2Bu0DvMTo/RShUxjABWsyYuE6V4jOOeinXFCfn28+ToFun4llsOCCKZjk+E63eXNu5PtNkkGyS709qRz3b4iiql9kAzIMqfv85jt4ljHwEBu/2v6f2n+K1URwt7xQd5UR6zm3QfzQnVvA2fKerhmLy+phDBAQaEtvAJk3nrFVhUmNhZvz5aBs8gP+i+mb5BUwhDzVmQYfUO3VsiV9bgijqcsz+7nDArDoIuS4tBSpaR13A/Pq5PdyubaYnM2aa2M1RVmt2UH41/QfwK7V+Hv8BIvcjoOZbTYYdxDc9wARYztXf9DRLQAURYPONZuffUBSCnPpG/Q9rjw5tiM2QcBUmMLJkAPhl/IxE772JY/sMUbk4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KASAN by default reports only one tag mismatch and based on other
command line parameters either keeps going or panics. The multishot
mechanism - enabled either through a command line parameter or by inline
enable/disable function calls - lifts that restriction and allows an
infinite number of tag mismatch reports to be shown.

Inline KASAN uses the INT3 instruction to pass metadata to the report
handling function. Currently the "recover" field in that metadata is
broken in the compiler layer and causes every inline tag mismatch to
panic the kernel.

Check the multishot state in the KASAN hook called inside the INT3
handling function.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Add this patch to the series.

 arch/x86/mm/kasan_inline.c | 3 +++
 include/linux/kasan.h      | 3 +++
 mm/kasan/report.c          | 8 +++++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/kasan_inline.c b/arch/x86/mm/kasan_inline.c
index 9f85dfd1c38b..f837caf32e6c 100644
--- a/arch/x86/mm/kasan_inline.c
+++ b/arch/x86/mm/kasan_inline.c
@@ -17,6 +17,9 @@ bool kasan_inline_handler(struct pt_regs *regs)
 	if (!kasan_report((void *)addr, size, write, pc))
 		return false;
 
+	if (kasan_multi_shot_enabled())
+		return true;
+
 	kasan_inline_recover(recover, "Oops - KASAN", regs, metadata, die);
 
 	return true;
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 8691ad870f3b..7a2527794549 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -663,7 +663,10 @@ void kasan_non_canonical_hook(unsigned long addr);
 static inline void kasan_non_canonical_hook(unsigned long addr) { }
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
+bool kasan_multi_shot_enabled(void);
+
 #ifdef CONFIG_KASAN_SW_TAGS
+
 /*
  * The instrumentation allows to control whether we can proceed after
  * a crash was detected. This is done by passing the -recover flag to
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 50d487a0687a..9e830639e1b2 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -121,6 +121,12 @@ static void report_suppress_stop(void)
 #endif
 }
 
+bool kasan_multi_shot_enabled(void)
+{
+	return test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags);
+}
+EXPORT_SYMBOL(kasan_multi_shot_enabled);
+
 /*
  * Used to avoid reporting more than one KASAN bug unless kasan_multi_shot
  * is enabled. Note that KASAN tests effectively enable kasan_multi_shot
@@ -128,7 +134,7 @@ static void report_suppress_stop(void)
  */
 static bool report_enabled(void)
 {
-	if (test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
+	if (kasan_multi_shot_enabled())
 		return true;
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
-- 
2.50.1


