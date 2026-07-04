Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC306C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 00:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AA3F6B00BB; Fri,  3 Jul 2026 20:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8336B6B00BC; Fri,  3 Jul 2026 20:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749A96B00BD; Fri,  3 Jul 2026 20:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 482186B00BB
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:21:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 35AD41C71A3
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:21:22 +0000 (UTC)
X-FDA: 84949190004.15.F1D966A
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7379740006
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:21:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qxR95fJB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783124480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuMw32Syx9wqhPoQjtOxdSm4SDxWM6dpur5hV6NT1WU=;
	b=RrzCLfwPQ7Dl9Btq1AkdI8RQIhFM+MDZcoN3+bdFH2UzoBPf/YyzofunNntQDZT34cS8c8
	WdS5jutSLiJ5sKDPMXtreaG2wZxxkDIU5iApCWKwc3UxbwgNRrgtefbDT9EYuvYZ3Y7M90
	s+q6NFDUwtnrQOIRaCrkKjwpukXZItc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qxR95fJB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783124480;
	b=TUCuiVaP9eXkQcu5TXvs13ysW/JvV1sSuFkPxK9bG5t6A9iL5HZsQeJ1qrUdigtQ2OZXsN
	nGNWZ8J3CJ2h9Y7TPyXqK1i7x2V18BkD3xEMg7D/NuarbiKOFat8Pz6515rsxtrvqHiDXs
	05gQs3D/pRIqB1TfC+EmNrm8rrPg30M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783124477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XuMw32Syx9wqhPoQjtOxdSm4SDxWM6dpur5hV6NT1WU=;
	b=qxR95fJB2K4bXaf3wuOKm2B76E/cL8QEbgT3oEwbpDqrGyLWJP5v+oOZ2UTs8AEl44q7SU
	AQ9/f89btaR4TnfXHhVkYHlJhNlFU/FVWSab9HtK8RIT6syO/xIggvD7uqxerThgYoYlij
	ofKlpCOc3rwwFSVt6CxkmdFf7dai8hc=
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
	bpf@vger.kernel.org,
	kernel-team@meta.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/5] x86/cpu: Introduce identify_cpu_32() helper
Date: Fri,  3 Jul 2026 17:20:44 -0700
Message-ID: <20260704002046.3859585-4-ihor.solodrai@linux.dev>
In-Reply-To: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
References: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7379740006
X-Stat-Signature: ga6ueznc594a74jhfuidfkqs5sxye5ap
X-HE-Tag: 1783124480-733261
X-HE-Meta: U2FsdGVkX198m3CAX/ljY2uSP3w8/02EPyOGRI3sh/LvDKVnv/lbJJ0RgHNG4XTJ1ZBJS5hcZCeW4spsF2DWgKaSNNLshLHSaCqnptqPkgcRPQ/1cW8up/SF8ck5QTrcfZoxTMkwIB70sF55fEGRx80Xb7qr0DIvF/qN6fodWQFhofhtw4FAqQjHMCLy39aW8ueuFznrRafawJ6jcq3x7pwusJ+vsTcbT/JKmrSawrY2ThL4z7J+0/QtzcfdtGnbDVd6CAGZdqgY7tbPH8r9BmZ+hxFfo4HnJfSOjmWxE2FhDEqPCytw5DqcMHFsJuxb4Pqr3SEN6FKN68G6/MgsFMQtAXGVmGmS48E01qepNVTi94nH+AZMz93KwcqhZ5HmGE/pBiw72d+i45C+Pmt4V3M2AZxWLb26KrniOAo/XEX32tod1VsStpxWjq9AMPsKpmmgCuTUNj/hoEiFu5Zm0KCbGxO8N6lA0B2xEr87aNHV4jUSSMe2obAuPDn0sYdON+DJ3Ji8kllAv9QKcpg5PRETb4L7mLY/7I8QrHsVIVAC5LS8WmbdTocy/p6sDLBBv7RR5paHa7RnIORqFNQsHF9TUozR3/LXjXahkJF5Dvn16w++diDTAv2rwalRx1ncM78x9FBPUO1I5koDceaO4+btY0FnoxTNNV8kSuKUjD2BjEZ/dfZXbm2YGbCz7WgzB+jndZCh7ly/S4xm1OrBAiu3YOB927tyMsT1lBOkLVEOHXbtJFH1jbFzNej9NbXgMg5Tt3hgmSolZ1+uphgA/jsgzw008bL8IM/F3G+RhY3C/+bEBaWj1zjuCFKLnVSmEnvuH31CXUnP0UepuPK+umXIezq3YjNCsZJC8l7Zofc3pnmxk9qSWNL0X+g3mVdeZHtA3aOsHUG2XLHl9g2IsKvaU+RImH2sCEpSjP3GYTlskiw/3M1nDLTYnEYLhxjTeSWQsKlqACG9sJ5NYxI
 cUHBh2CI
 kQ2/SqPdygW/hsIjl2wK9m1X+4p5ImihHyh4RQiqyu8NfepxM1SaBJAn4rs4gSNOWOEaQxmEw1meK6dB1UK6prjE00rWAjwhGRdOjJu+duHyYW0kJ+mJMprvg/W3I+C6y3JBIxcr8ahp06ED9obLV7iF/W3XDx+7r3CVQDl5PBph4jJTEFoSJo+sSXqrz5z6oS4okCX5BmUj2dDEK5fqEyHKQgj+Sz0Ab9LEsTFyvlwYpjxXSyxo+ydmP09lPgNbotXgbQV9Hj3Yq5mx4yOnEkvgG4VYkS5ws/sVEx4WlkSuANnnJdLOeO+LmQIc9dlrVMdx2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both identify_boot_cpu() and identify_secondary_cpu() call enable_sep_cpu()
under a CONFIG_X86_32 #ifdef. Move that into a new identify_cpu_32() helper
guarded by IS_ENABLED(CONFIG_X86_32).

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
---
 arch/x86/kernel/cpu/common.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b9a736728a0e..519e495c4a14 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2146,14 +2146,20 @@ void enable_sep_cpu(void)
 }
 #endif
 
+static void identify_cpu_32(struct cpuinfo_x86 *c)
+{
+	if (!IS_ENABLED(CONFIG_X86_32))
+		return;
+
+	enable_sep_cpu();
+}
+
 static __init void identify_boot_cpu(void)
 {
 	identify_cpu(&boot_cpu_data);
 	if (HAS_KERNEL_IBT && cpu_feature_enabled(X86_FEATURE_IBT))
 		pr_info("CET detected: Indirect Branch Tracking enabled\n");
-#ifdef CONFIG_X86_32
-	enable_sep_cpu();
-#endif
+	identify_cpu_32(&boot_cpu_data);
 	cpu_detect_tlb(&boot_cpu_data);
 	setup_cr_pinning();
 
@@ -2173,9 +2179,7 @@ void identify_secondary_cpu(unsigned int cpu)
 	c->cpu_index = cpu;
 
 	identify_cpu(c);
-#ifdef CONFIG_X86_32
-	enable_sep_cpu();
-#endif
+	identify_cpu_32(c);
 	x86_spec_ctrl_setup_ap();
 	update_srbds_msr();
 	if (boot_cpu_has_bug(X86_BUG_GDS))
-- 
2.54.0


