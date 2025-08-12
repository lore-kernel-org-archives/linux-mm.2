Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882E9CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 250258E013A; Tue, 12 Aug 2025 09:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA388E00E5; Tue, 12 Aug 2025 09:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A14E8E013A; Tue, 12 Aug 2025 09:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC0DC8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:30:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8084B8061
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:30:26 +0000 (UTC)
X-FDA: 83768189652.06.F10AA86
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9F9FA10001D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:30:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HpqEEwRe;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005424; a=rsa-sha256;
	cv=none;
	b=1D0Fv2FzdJYtBou31llOvgJrLbihSIez5ReEjUsrH/vPDnkdUltLbzFnfI3S/ulYpBfyRw
	quFpzc8MCdJCrwJIrhJ7cNZRfaF2oC3iWr0vP8NfVmd0yJHkQibURMvIsbtXb5F9ir1PIH
	xQNfXa4BhAj5udtrmJrfHBuRwiGSYow=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HpqEEwRe;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FRb88WAfTjJryGAWrsyeX434cCBjyUKjIIkgHfjXhc=;
	b=6V9GxZUTRVTMwAg0iEppopRsiO67cK5j4aEt9c2qh+f4abDzdJ9L8pFM7dlfoE7sJtN2D8
	WxDzlLNUFbTOdTS9ktbLqTaLdfdOg0fRyMtXaSb2mxgrjntkSuSEoiq5Ul6zlPlUYP/MFw
	WXiGW55zqQywUBgoaCU88n8zI/CH/EA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005425; x=1786541425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z/kDn3NFABCWRH7hqk/aYpfugnY8BGjn3l5jxoLYjts=;
  b=HpqEEwRe0HXmcEyDwD8/jVg9LmIyQtsyQFihwm8v+NBJg9remiu8T9J7
   vaBMwCfuv7YW3iUBkZ1hWoKA/vmg7JT4sQYw4c0LsSqPf0ofwmFDI/8p7
   UFVI5dLU/dq0hps/PfqzyzuhCWzRe8WNDZUPYwA39t+TV5T6KGSUN/SLP
   kB21C/6yQVV75wScF6QScvdOoU1ZxxtEHh7ZeVQJaJX8uwjs6eqyTdBAT
   riUxKNQCLXEeJ16MK+yi5IQSdN+kautzbHiir1fo5fx8sPNrzvA7taefa
   gIV9mhdfi4QX2oSubVntlJl16i/KOCBPGvbSgHij621cb27FYKXqCBz8z
   Q==;
X-CSE-ConnectionGUID: KuDNzG7CQJuts7xCDgHwKQ==
X-CSE-MsgGUID: ariFusPAT7SujnBOZlajqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60903952"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60903952"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:30:24 -0700
X-CSE-ConnectionGUID: O4o3sBLXTKmQMTR9muYdMA==
X-CSE-MsgGUID: lT/GoXCxT2av3FFB71gMVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165831775"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:29:58 -0700
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
Subject: [PATCH v4 14/18] kasan: x86: Apply multishot to the inline report handler
Date: Tue, 12 Aug 2025 15:23:50 +0200
Message-ID: <8ace14464d88b51f309b289874760b5d6265e438.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9F9FA10001D
X-Stat-Signature: 79m871cbbmnsh8mxo9rsy4bfy4uxu8kn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1755005424-581964
X-HE-Meta: U2FsdGVkX1/iijmYEYgZe+5aelIPe/THyRczqs44TVsPfAbbOQms8mVa1Hr8iTNlo762CWcbQ9/OrkS9NrDm5EmxcHj/WcB+1VijrXvdmERLVvWtAM4Z5tfGMyEPa66kQj516VHloY5N+Zxg2VaoQZvn+mXYHj/7qHjC5xQeHYo90UAZZQcdsWCex6/hD5QCnGd2plzpFMe/mj6q97PNqIDhtqTaW4aB+nstjL7JSkKRHikoWf+Yv+kUMpQICPVwV8z8sUQN7rz5qCwZMLnacLP3O9pcTqcsFzfk2Q+52lCGdxJZEZrbalA6Dc67JuHPXHbVfb4PZ6VQi/XWVNeCHBfFtxcE5lFmKaYDNL3nppQQMlDEZuDAfcu7sSPH3dNEM49b+YpaA8QtiSranVKmT4grP/kzTy1ChvoMQNL7kFuzR7VOhG/DP6nObT0OTQk02LBFO7CKdfqJQ4i69XdihUdBfXglWdq3ms0uBERkwOGz+TPCOYL/uMyVdHzoGiGTbQLgsq/NIg5B6MgFViME+Fyjzcn2+5tJXFDV/ui/oPUfTuwPUiXlKzs8MvWB76CL1nXzM3SNejtKjfRnu0V19xvAiyUUy6EHx2xRw81/HZ6L2fIFa4NVm9AY2hLO6Si5yL+AgUpuAA0wXslGBwZrcaFs5ypzfU+cQewy4dEcsplJiwBrA69yQsHknjL+XIjPThCw8qK46FxE0ZLMgECt+L0vi3NLkjBmx/EF6Fs6FAEyIZ0LkKs/OMaAPi1Fr/P4y2jUZPOO+tZLtioCMoy9pIv7XuFLn1CCzSH5hV9aHufK6RcFz6a+kIe2f/eGoRW8lI2PZVAdgCYCFk1Paxq8JOBCfQE1SSA5b57zPh90yFOmz3CQ0GZdrIitK1d8R4xTy6ObzP9mSRIMbcGax3L/FtoCHAeeps2lUbUeFA8U8WmmNL7mdaMOHCgx0h18fGaSY+cl/AghMaapMmumCxu
 R61SVIT3
 R25hzOvXC+e7L2pL7iL0DGOMrqUcmNhSqyZUlVg8nmcg5thTCkjrR6KFFg460eXkTqlmBzwRHibwW5j4ZGviBxEK2KevP2AUgE1lD/lK/l52Jpsa/oFyccDeRvM0BGyaJQMliy5/GZGuSLydlQHMcmpw2r167LOfpvJczdXyMnFSwnfDkSNyez6N1D5lJubUl0XeTlGZRW1g1n8j0nGRGxVnDqLOkLcKo9fAQD+XKD1CRWUySNvOhoi+dwsUyzw53QNV/
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
index 93c6cadb0765..cfa2da0e2985 100644
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


