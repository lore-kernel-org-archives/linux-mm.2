Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97036C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 00:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835536B00B8; Fri,  3 Jul 2026 20:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80DA56B00B9; Fri,  3 Jul 2026 20:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB816B00BA; Fri,  3 Jul 2026 20:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 466F06B00B8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:21:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4537120321
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:21:16 +0000 (UTC)
X-FDA: 84949189752.13.C43825C
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2848AC0006
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:21:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KhyVl8fl;
	spf=pass (imf10.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783124475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFpVxmC6lW1JIGACiGglEHWFaPfq5ymDv77uwyPpK1o=;
	b=sLZu5QF3p2cQT+4wSNOVGdVn5lnkpYNUSN8TWZKAmmJvd5mhBxYwn/ANBpwlbMnAyYrQ74
	1eY5wQtmL7OxO93fzs4bHEbXYtVWPIrwOMIUEoquHfiGGhGOnaZf66jZ2cmg1vElfqqHHp
	fMtuwRfOfxrq1vrXAXh34g3I6/mlI1I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KhyVl8fl;
	spf=pass (imf10.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783124475;
	b=cJhlRht9znIW6g9KvXgMaRZ08Zd3lUPQAn2IEXOi81YCO7Lk5Kxj5BKX2A0LtPDN8+keLc
	LjKhj7rwV8Z7QseMsPH0QsLIrU2+I7mobta9PUhdUKQDDy0OWL1IcO2k6BrxQtps2hEvY4
	lGkojJy2sd9JUL8rxtiG8jWcd1i3UOg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783124473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lFpVxmC6lW1JIGACiGglEHWFaPfq5ymDv77uwyPpK1o=;
	b=KhyVl8flzrsYbLM8ezm8lnETvPP0ZjGAwHSCm0yGixpyiQN0XrFjIS8+I9YxvJzwM2YtFt
	nRlqCZK6QqVNFdAewDIjSZdDvuakbZAcCUuB/VeN6Dbj2IYEh+Hc/8u0gP86/ITA5g3xzR
	Ig/B6dNLIu3ZdqKVG8q9zP88mQwd0Dc=
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
Subject: [PATCH v1 2/5] x86/cpu: Inline generic_identify() into identify_cpu()
Date: Fri,  3 Jul 2026 17:20:43 -0700
Message-ID: <20260704002046.3859585-3-ihor.solodrai@linux.dev>
In-Reply-To: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
References: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2848AC0006
X-Stat-Signature: 8tspf63c1wwsjfp1qkeuruinkonkz88i
X-HE-Tag: 1783124475-292786
X-HE-Meta: U2FsdGVkX1+xYuEuf8dVttIOl/NqLYx5Pj5IDHf5hm1j5TynZ5jWSBSrQrF2oGxbV60/RwVwjrvQsVs+j5kFiRFth4qKmEGRqNP7i3d/wLvQBMRHk2wr4jNvVz9fVW1DmMekSvlfeRzK6JP1BhBAPzetZT/o21PCiGrqvYR7b6H+uwblyNhDjkaRmFfCUjddol3fqhlDt7EV1XBo9RBHjC59pAj08VU4+9C2W32YkmcaXIQ8SE0gDNFWwR9baagRnhueRIzloRr9mG6SjUHGsaPCm1lxmp+WPQRDZxbEoHfFPBtkey58WDQZcHlTltu4X4j0G59ysSY91Fzv4Mp8KmncHpzed942CBLrc5obLrBr3Y8XGnGLoOJxv5/chJIUzk3UWVU4bbSWU0xENY/tGlaMM0VE75dINuCkXn5Yiwx2PcmE3lomiulO/b+bvkwFb+6ny3O6rZ09ttpQsfBcpISQFnMkmjkr3UeDBX+TfQzUZk2ELyZrLKOkRbWCHx9f/2QrcLt9rwhB8F5d56hcohlxeHo0dMPMgEoCBFLXgcgI/YuePPL2oX2txhbmouzdQrVNsd2gZzB3LO65la9/c5K1uO7jN5xgJZRjpopWX8mEY2KQt3t+T0K162admifr4x/a32WZOcMkHnlpzuQr20R4iQCCrZNhHXc4FsfiiXX1Q6iDAatqcxiqvLTdBrR3d7n+Vmjam1gH0w5AXf9qnV4iwJWKNmsvIxnysHzGV5Uv282hNN6y6Euy9O5xs1RFLTiBN+79m/qZDyoONtP4ZYUUNB4RwxZlzaJxa/YuRafZwJjzYobAdnYfZKk9eUNkJuLdscyK70tNAMTHNAzEoD48GzxomSLKLDWkDSIAgFz+u3h2xuhaY21bnKikwQBr3ve0Ky38EWJpIZHeCIeDqtKS00y6GDmVRfYBq/Lwb8Sq4baxhI6ANkToFLn1QaAxiONk2QQyhgE2fP6B4di
 gIlIrODD
 tTidBb+bo/f63pGNR7Y7HIcqDAR7YVkVbWM1ve3A4kwxjo+xIJxCClV/XuBlOowVSTr+YDqZ/D7FtRVat2Ld6XlmJMMC4F9cQm9XyAOvg28r49hFKgAedZwo3IIku+oKpu51FZzcAloW3e7i4ufVgLAZUpzqhhlJqPz8Y9TFE3W81qbGLAq09Htpnx/Jt7sZdRk7qthP8pnO518pEsXaoemLIs88+V/MF30H3yihg4dhZPoFX0FZR9NZRdD0j4u0ToA4zyp9bOq4bM3LooBKUx975b5qSTA7BqUVz4NX0SJWS/oWx6h2VRzwf5Escud2QqW24
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

generic_identify() is only ever called from identify_cpu(),
immediately after the cpuinfo reset. Fold it into identify_cpu() so
that a single function does the job for both the boot CPU and the
secondary CPUs.

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
---
 arch/x86/kernel/cpu/common.c | 73 +++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 505ce329e821..b9a736728a0e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1954,16 +1954,46 @@ void check_null_seg_clears_base(struct cpuinfo_x86 *c)
 	set_cpu_bug(c, X86_BUG_NULL_SEG);
 }
 
-static void generic_identify(struct cpuinfo_x86 *c)
+static void init_cpu_info(struct cpuinfo_x86 *c)
 {
+	c->x86_cache_size = 0;
+	c->x86_vendor = X86_VENDOR_UNKNOWN;
+	c->x86_model = c->x86_stepping = 0;	/* So far unknown... */
+	c->x86_vendor_id[0] = '\0'; /* Unset */
+	c->x86_model_id[0] = '\0';  /* Unset */
+#ifdef CONFIG_X86_64
+	c->x86_clflush_size = 64;
+	c->x86_phys_bits = 36;
+	c->x86_virt_bits = 48;
+#else
+	c->cpuid_level = -1;	/* CPUID not detected */
+	c->x86_clflush_size = 32;
+	c->x86_phys_bits = 32;
+	c->x86_virt_bits = 32;
+#endif
+	c->x86_cache_alignment = c->x86_clflush_size;
+	memset(&c->x86_capability, 0, sizeof(c->x86_capability));
+	memset(&c->cpuid, 0, sizeof(c->cpuid));
+#ifdef CONFIG_X86_VMX_FEATURE_NAMES
+	memset(&c->vmx_capability, 0, sizeof(c->vmx_capability));
+#endif
 	c->extended_cpuid_level = 0;
+}
+
+static void identify_cpu(struct cpuinfo_x86 *c)
+{
+	int i;
+
+	c->loops_per_jiffy = loops_per_jiffy;
+
+	init_cpu_info(c);
 
 	if (!cpuid_feature())
 		identify_cpu_without_cpuid(c);
 
-	/* cyrix could have cpuid enabled via c_identify()*/
+	/* cyrix could have cpuid enabled via c_identify() */
 	if (!cpuid_feature())
-		return;
+		goto no_cpuid;
 
 	cpuid_scan_cpu(c);
 	cpu_detect(c);
@@ -1991,43 +2021,8 @@ static void generic_identify(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_32
 	set_cpu_bug(c, X86_BUG_ESPFIX);
 #endif
-}
-
-static void init_cpu_info(struct cpuinfo_x86 *c)
-{
-	c->x86_cache_size = 0;
-	c->x86_vendor = X86_VENDOR_UNKNOWN;
-	c->x86_model = c->x86_stepping = 0;	/* So far unknown... */
-	c->x86_vendor_id[0] = '\0'; /* Unset */
-	c->x86_model_id[0] = '\0';  /* Unset */
-#ifdef CONFIG_X86_64
-	c->x86_clflush_size = 64;
-	c->x86_phys_bits = 36;
-	c->x86_virt_bits = 48;
-#else
-	c->cpuid_level = -1;	/* CPUID not detected */
-	c->x86_clflush_size = 32;
-	c->x86_phys_bits = 32;
-	c->x86_virt_bits = 32;
-#endif
-	c->x86_cache_alignment = c->x86_clflush_size;
-	memset(&c->x86_capability, 0, sizeof(c->x86_capability));
-	memset(&c->cpuid, 0, sizeof(c->cpuid));
-#ifdef CONFIG_X86_VMX_FEATURE_NAMES
-	memset(&c->vmx_capability, 0, sizeof(c->vmx_capability));
-#endif
-}
-
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
2.54.0


