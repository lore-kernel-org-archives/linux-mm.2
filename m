Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD432C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 19:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD80B6B0096; Wed, 16 Sep 2026 15:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85AD6B0098; Wed, 16 Sep 2026 15:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC54E6B0099; Wed, 16 Sep 2026 15:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAB956B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:52:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 378B5A2F34
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:52:50 +0000 (UTC)
X-FDA: 85220673300.04.6E2CECF
Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 52449140003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:52:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JFQef9Gt;
	spf=pass (imf09.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789588368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hS0AHBmvrUqGsEmf69kh3JZMua61p/qOJmz1zCzno+s=;
	b=AOwqdjN6WOrb0KPKjYu7GzWpaPZyZSo0BeduvJU9Bm6llb1ekZJaVVJac+AElzAg/pPbpX
	IWshP5e8Ug56s6mMSz7BrjVi98j8ueKisfcASgNGr8muKmWa5BUp+jtGatOIamJaVqbWWB
	DWl2squUmyMdXFzdVAF+yJQhSxWzBgw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JFQef9Gt;
	spf=pass (imf09.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789588368;
	b=zyt7MCFefzt5dZEq/xaU2duvYTa7jmC8BHOaqh3/7cKmQf7KAN3WXkk1jWXtD4wFhBGX7V
	BipAPHCXm19zzhmOwb2drLwAndaICBJacSw4osVboxX4tyh7mLS1vHadpJ1z8SIh5XRPq+
	vy18S+aoJP+wXplC5uz7AFBMXq4SGjA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NkwRWssGXzQfAtXSgywsv6pvQ9Jdw4rpWWvy40Z4lEU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789588367; v=1; x=1790193167;
 b=JFQef9Gt3KpXMJmayecRqz418APz6tHDMrFI4RZZCL/FjpDUGXoGTfWhJqRr/j8kbdi5j9UA
 6c2OkuEUhnUeICRlmKpy2gUoGI6oyPo5/kxNlFz7H3U7zWy3iOAC0Zk+4tNTjaIka2FZ5pa3Ym8
 PeRphGun1jYq2mcE2By96a9g=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 4af099ac9b2f47f6;
	Wed, 16 Sep 2026 19:52:46 +0000
X-Mizu-Trace-ID: 4af099ac9b2f47f6
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
Subject: [PATCH v3 4/5] x86/cpu: Move 32-bit SEP setup into identify_cpu()
Date: Wed, 16 Sep 2026 12:52:02 -0700
Message-ID: <20260916195203.1099646-5-ihor.solodrai@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916195203.1099646-1-ihor.solodrai@linux.dev>
References: <20260916195203.1099646-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 52449140003
X-Stat-Signature: rmbmzrnud4gxhcb1hgjcdouctb9yw4mj
X-Rspam-User: 
X-HE-Tag: 1789588368-294445
X-HE-Meta: U2FsdGVkX19WVJ1gXa24wX50giWAqkD+KISnsr6Bw7iGIIIR1cpkMdYYffRqXf94KPYizMmnUKnTGSoV5b3z46F8dE5sCiUCriRmFM8QYyWY+Ee+qezaAMdodlA5+ryGUB+y4SIGddXWKkg7CglG4qwHWp4FXuUQZkEMvTxTg7hnZcRlZxzXaE2yRj7q3Cm3NgZSLQTV1Kbt/LIz2y02Z90yzlsDHqrxt6Yy3JxS003VF6YbQScfyLwaMrJB3K7ioiCiUSi/GX+G++I25At9w5zPtBWFN4apQzWdFndrTl8zad3FcvfHlpJ/TPPLc1+Mgsteg741fGCDbWbzRdTJlHK9h0H9le4J9cVS5gpZRc2imHEHLoSFcHMU8fe0oB2cSPEEpGsk/k/lB33b/czOD5AGd1BNAHe7Boay/9+YxeE9Ps98Y4usjaemFx1L6oZuiiRuW+V6Gr2RCCKNqKO+ePfYBL+1xDcasoVZaPQx9FghcdE3UfmqzDbRg+juT3nSH5jJElcEoMPqkxcPwdk7bCKUw8GDSyOacawP7mA0euLSctJS9FHaySxD1ABUGLFdeJGeHXyqi4u8aoeB+gv4OrnFiq8ALrVhmoY9AUIxzkgPrDNmLLwXD4nuWqJwR3/vzbLtVfKxW1TnAwSev907MLxXtEGMhm0qy/d9NUVE0Hzsoqm44wWiTng+DjZZTOeWvBrNaZqcW4v+FCMMtVEod+ZKQq8cExMBB6oU6oj/H8um2HAsu2guBJTVW3FT2El0D2xgwPey4w4QIX6Cv/Kpflzwi+GsuZye+336GyvL4pKHQ9hkdf/C0qLvB5/4QQXji08O/LBQSS+sVUv1jyojPje6YcKY7exVNqbJ6k527Wyr7vpPAPBmZU6qB5nPOS0WJVIXVexpC8mSyrM3/x6oI504kthCterSTZ1ueFPqFv+HfJ/NeVyD9QVORsdLUbiaRVGIFhLAb2UWtNXqOWy
 NfFxl4Wu
 oC4K23yjjEZNo2DZbAErNVSeVHV/X1qGhgr62Mt24LOnxIE+sHB5kIRSrsKNgOdNFl0Zv8H0H722Dp7RQw89cON8xPUi/5g1MzTq+IN9huVPzK1jm6XbB4w8RiDwDgeYn1XWEWyCGN3RjsVoceTINr4dpvLq1XC0dzGz+1+Z0YT8HGDZ1dnysjCdRJMWLV5SOe2OjO0gOsKqcbw3HoCPUARD1iAapI8LIILkIGTlsWbiWMSuDOwcChBhm+fpG0MG+CM4I1BE5yvcMJxfQCRA/i0Zpe5lD5n0NnFFXVmKoeBvKNaMXJaxqlSgXWYqcFqEM19qcuJPH9hKy4TYxwNEw1fkiv0/DM4x8cVdMxw4w2nGlMxJSHglarICQm8KIkHFjQBgbtkLT6yi/cCV8sv+yw0qMPx5oT4xD0vtn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

identify_boot_cpu() and identify_secondary_cpu() both call
enable_sep_cpu() under CONFIG_X86_32 immediately after identify_cpu().

Do it once and drop the ifdefs while at it.

No functional changes.

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
---
 arch/x86/kernel/cpu/common.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2b2a4c40ef76..83d613d07997 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2126,6 +2126,9 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 	mcheck_cpu_init(c);
 
 	numa_add_cpu(smp_processor_id());
+
+	if (IS_ENABLED(CONFIG_X86_32))
+		enable_sep_cpu();
 }
 
 /*
@@ -2163,9 +2166,6 @@ static __init void identify_boot_cpu(void)
 	identify_cpu(&boot_cpu_data);
 	if (HAS_KERNEL_IBT && cpu_feature_enabled(X86_FEATURE_IBT))
 		pr_info("CET detected: Indirect Branch Tracking enabled\n");
-#ifdef CONFIG_X86_32
-	enable_sep_cpu();
-#endif
 	cpu_detect_tlb(&boot_cpu_data);
 	setup_cr_pinning();
 
@@ -2185,9 +2185,6 @@ void identify_secondary_cpu(unsigned int cpu)
 	c->cpu_index = cpu;
 
 	identify_cpu(c);
-#ifdef CONFIG_X86_32
-	enable_sep_cpu();
-#endif
 	x86_spec_ctrl_setup_ap();
 	update_srbds_msr();
 	if (boot_cpu_has_bug(X86_BUG_GDS))
-- 
2.55.0


