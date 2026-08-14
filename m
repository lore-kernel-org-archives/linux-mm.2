Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8911C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 23:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DE486B072B; Fri, 14 Aug 2026 19:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B4C16B072D; Fri, 14 Aug 2026 19:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F12A6B072E; Fri, 14 Aug 2026 19:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16C1C6B072B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:52:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 85FE840211
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:52:40 +0000 (UTC)
X-FDA: 85101527280.25.4C5DAC7
Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	by imf08.hostedemail.com (Postfix) with ESMTP id 67FEB160009
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:52:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZzKLhQFB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.119 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786751558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0+YvVA4yJSFcGhdjjNVgXVFRTYW9IoFy7ix+7sFg+o=;
	b=def1lmbWDKL6hsZ3ZoD8EXSQEbkL57Q6gjvPTBh6iAkmooGxiwo3jVDyBceouC94bOplk1
	0k6iUWPjBkpqlq/ZZd5dreVuiacm0ucPebFy6pFDq0POIpwXlikxEptfEwMOFAmzWA5OJL
	9ao7R93ah3BlXYJC21Flk6WfACzuANU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZzKLhQFB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.119 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786751558;
	b=zR5BIrRYAiAX1jhn0Ozrp4WTnJEorchqbQl53Mmv0NfBp1NSUTYJLoU9OcqHvrk3thN0ZA
	JyYF++0yJOe9DPZnLGxhz6VZHWtuXf1SeK37jNJvIhMSIWQNULt7Y73oyql4+LaXWrnryp
	DKJ2GwlVIr9G41c6HhKdjyHx0ePWOKo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hlOxz5VUnYNLigWKPPNmAANwW8QKdqA0qYdZ4B7zxBU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786751557; v=1; x=1787356357;
 b=ZzKLhQFBwZfEEaJpNR2214OuNvG5XpbZiCgsYAelRLnEx6Jhk7cVR4kdIjvf4W+Ja7itZDjC
 EepKC4Vh4xg6GDrUBNaniKy8mgORnkk1k5w58ZioOB65gJfK0BEpDWaCjdJpAEaoCMWwp33ZsiJ
 ah0WgKDibBUwz5J0qTJXohxM=
X-Envelope-To: linux-mm@kvack.org
Received: from isolodrai-fedora-MJ0FVMD1.thefacebook.com (2620:10d:c090:500::4:b8fe)
	by mta10.migadu.com with ESMTPS id 9d17edb13127eb6f;
	Fri, 14 Aug 2026 23:52:37 +0000
X-Migadu-Flow: FLOW_OUT
From: Ihor Solodrai <ihor.solodrai@linux.dev>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	bpf@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2 3/5] x86/cpu: Inline generic_identify() into identify_cpu()
Date: Fri, 14 Aug 2026 16:51:32 -0700
Message-ID: <20260814235134.3461435-4-ihor.solodrai@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
References: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xbg71zdswgius9d363di1shc38k3zkqi
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 67FEB160009
X-HE-Tag: 1786751558-955805
X-HE-Meta: U2FsdGVkX19g7NcbfCl3nAf46Qvn/mReTz3OnUaPPsuT3lOzG8t1swiNyoHUHdoDoP4XzWHzM7rmVTidRoGIZWl3kpSiMB63spxuM3QaCELlkmFjiqdA3NSDZQwqsfSvU38MlDCkwUAXWIu+uK1IaFTbr2o3rXwro8BU6PclDagcPYW7pVELxU5sinuU3X/pC00t9At7cm1fL5hPuFEooeLmNrwDPHXDjnEiUSVzBOusZADLiO8d8taPEed4tBVfu363I+9xzUXKELsPi+cRvlGRUQA43d//I8RdbdiNyu1MEiLleRPzzsDY73+m0VDeUJ3oyWhyonJs50/VSLbmQRmp3QoMZNblB+9MtAYplUzcrdmvzTMA6o0jhBFEvpjfj5eh2W7zMxCZpqAIEZgU3mt/PDtj3QX7PVTwDAz1HVjxYOZnTqEuFq1YHjAm3OWh65euFUeiuF7yyuz3V/OCip/dLibFwtGzSMFz4PF3wVl+huqhvW6f4BpyTvl2trfxakuOrGKuKwCuJcx01Aii3NCEUytb37eoZs6QYvHoapT84FTWfU72QyCYVyaoxKvCqYKxtNZZoI0wZuJsrvbsGLGGK0BsnQr/TXDFdxYSyncD6RM0APTok/w/v9dgL4j98CBEwsXjPNo7R/XLZ0L8NI7WZRXwdNbSUOOOQZ2wtzMrg5kzp+dGJqWmFWjYwNP2EjCONMxCfuPcWVWQF0dwk2bABFBxc+atDbY+SIvFZuCuSwEu7TydyAoQMqN+d17KtNXRkFPrADlxS1J7mAcz0pJWZ6vGo8rqDJlZV8336a+BpgTSeW/RmmzgQdwEIULfDP3LjKKktIYBW4SYOrLY2rw2O55pQyClrF1SSMM2OWQ5oTz0KWloIxNRCxTo9/MPR8jYAei0IY5Wg+F9UtIUkTJglqs351d+ZrSuZnioqJduiX2SYtt1EriNjZh/mYUhARQbTKE3vBcN4khdPFp
 i5WOxxuC
 iNf8E5VEaYpPRhaOwAlJ6ViTNcELRksBGgvtcMuSlSgOo+bQEdnWW59XK/OxKreRVklW/tfVPkyePmSJXKmUZ4BW0CjjjuPZxLuRZrDtWYfEAwMR100XV2CEwWINO8yNOmkTwIJ+1Shxof0h8D7nd0UsM1Y8rzI3E1jKjTdhIUGancf092H454q6wSj+Bg/eUivWxtEjuzM0GPl86cQBLoSthg7MBQM8ZGU0eEF99BbDkriekzR5kV4boEIUszV0q0TurTTLiQf1bgFkev7ZdpRRm9bdfvxjJrTIytpLwBHlqM/e9Ge/LrAR+4Nrj5eUi0pds8jJ0qriLZgje2LHWDn4syuJT2KbA8Owf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

generic_identify() has exactly one call site: at the top of
identify_cpu(). Fold it into identify_cpu() so that a single function
does the job for both the boot CPU and the secondary CPUs.

While at it, fix up both copies of the Cyrix comment.

No functional changes.

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
---
 arch/x86/kernel/cpu/common.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f43584c8aeab..08c4a0162581 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1815,7 +1815,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	if (!cpuid_feature())
 		identify_cpu_without_cpuid(c);
 
-	/* cyrix could have cpuid enabled via c_identify()*/
+	/* Cyrix could have CPUID enabled via c_identify(). */
 	if (cpuid_feature()) {
 		cpuid_scan_cpu(c);
 		cpu_detect(c);
@@ -1979,14 +1979,23 @@ void check_null_seg_clears_base(struct cpuinfo_x86 *c)
 	set_cpu_bug(c, X86_BUG_NULL_SEG);
 }
 
-static void generic_identify(struct cpuinfo_x86 *c)
+/*
+ * This does the hard work of actually picking apart the CPU stuff...
+ */
+static void identify_cpu(struct cpuinfo_x86 *c)
 {
+	int i;
+
+	c->loops_per_jiffy = loops_per_jiffy;
+
+	init_cpu_info(c);
+
 	if (!cpuid_feature())
 		identify_cpu_without_cpuid(c);
 
-	/* cyrix could have cpuid enabled via c_identify()*/
+	/* Cyrix could have CPUID enabled via c_identify(). */
 	if (!cpuid_feature())
-		return;
+		goto no_cpuid;
 
 	cpuid_scan_cpu(c);
 	cpu_detect(c);
@@ -2014,21 +2023,8 @@ static void generic_identify(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_32
 	set_cpu_bug(c, X86_BUG_ESPFIX);
 #endif
-}
-
-/*
- * This does the hard work of actually picking apart the CPU stuff...
- */
-static void identify_cpu(struct cpuinfo_x86 *c)
-{
-	int i;
-
-	c->loops_per_jiffy = loops_per_jiffy;
-
-	init_cpu_info(c);
-
-	generic_identify(c);
 
+no_cpuid:
 	cpu_parse_topology(c);
 
 	if (this_cpu->c_identify)
-- 
2.55.0


