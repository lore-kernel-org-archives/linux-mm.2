Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD01C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 23:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7146B072E; Fri, 14 Aug 2026 19:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4669D6B072F; Fri, 14 Aug 2026 19:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37DCE6B0730; Fri, 14 Aug 2026 19:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10B876B072E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:52:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 76ABA1A02B2
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:52:48 +0000 (UTC)
X-FDA: 85101527616.04.9D608FC
Received: from mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	by imf08.hostedemail.com (Postfix) with ESMTP id AB625160006
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:52:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ohgoOk1+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.125 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786751566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XEpeijWYqKvBohCwkmytlryqDUll97bzl4mWdkeaA0=;
	b=JqSe46nJCG257GQbp1vWN7Rdb7a1wBLtYPgSWlC8j5Pp6yXpt6XrtB6g6Zf+rjWhLx5hRn
	u0BqARQMyJIy/U22mcBzYnWsF7MORen37ZctW0YtPFdynolq7U5QU4Bqfbsw+9dImZnsb7
	9ly7A9UsGXmDfhP9LdLlopfT3eMXv6k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ohgoOk1+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.125 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786751566;
	b=KWJydV6fkpRwmL6CCSecV+aQ3qX3Z/AbwyWttVAgoz+i+OQAt5y+nn7RszCbswhcOftDLn
	Gq3M4R0bNN99NtXqcAfwuH5CdnA8VLBsT3RpEWW2Akw1gF83KnBTGBcqtZ9Lf4QHK0uihy
	Mz+2Mvc9JJIikUvtpKAggQ31prfx+1c=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AKXY3VLj5AbiyXes7sILpjywYCJvZ1tj9cAxnFQY9M4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786751565; v=1; x=1787356365;
 b=ohgoOk1+sMpuchk0BPwF0qT2Hsdmqe4RrXbNQh97KpOmExFN6JhPGVSvREjbm4mRaVon6Dhx
 I9w2mJ7oofqYEso1zp/U0bQJSaidy09v2RzhZMCMJEk19ccjz5BDekQtIounohCsyVjZ7aUDs7d
 9MWMBomuPsGl3kkURIBAm5g4=
X-Envelope-To: linux-mm@kvack.org
Received: from isolodrai-fedora-MJ0FVMD1.thefacebook.com (2620:10d:c090:500::4:b8fe)
	by mta10.migadu.com with ESMTPS id 89459ecddee178bb;
	Fri, 14 Aug 2026 23:52:45 +0000
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
Subject: [PATCH v2 4/5] x86/cpu: Move 32-bit SEP setup into identify_cpu()
Date: Fri, 14 Aug 2026 16:51:33 -0700
Message-ID: <20260814235134.3461435-5-ihor.solodrai@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
References: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9koutkg5st1a3p9ki6zey1qzn496sztj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AB625160006
X-HE-Tag: 1786751566-583267
X-HE-Meta: U2FsdGVkX1+R4D5bPea6W4CZusrBoisR9m2fuXnmNk5OvBkDh+z8cvCVw62dio1/5o9ooE/CBMf6LKKNCN6tP4k+DTFsaH8kzbUhsm6EQZ4N48ydkBnLdAFLHO7eleQr8jA+Jb5YeIRRHuVZOrF4VwXptXwDNindELW+HxgwG76BwnxrBn6c25XDUfj+NAqlWo/BiPInqB5t6MiO7bP5+LbuHHZwrEH+kgk/UcuHM3qQgRwzfzVd5805dM6kJ+D34eHtF1fp45ybCkoZBx4vyUctff2wgbOeB3JCEdGOiFjbtew0zePSlb07awFJc7E2F7A3eOUpq5o9gzaAxmqJdgxjbb3mszYCbTpYTnJ+s6d+g80+PzMsXtSYHp3FzzCXR4e9JU0xtVOfJbwEaSer2C1HYjhA6Nu/UlFcN20Sqn3WxGeK8B93kTJMSxyzkS7MNo0Jxat/zCZlig//14tZZWmm5iAwfSPAm/fY58oPp3S4/UHMBDHEFX1SKuCwnAANtmYy5crI6WdX719CMmOZFF/UVPJ8XxOyXEfP4jRxjHmr4Iz0Er3HOq8yMeKNFlQMLInP7EaSCa70fMLVKXiYPkEMWqFztJG2aGM6W2Vdfu8RrJ8m0mL7+NYod8xSdVMK/JWKK0BQEox7O3IGhzu9bi23tfCsuH7MlUb9gP9RbXs3grLGSzpQebG9ycaTNki8hw5TxXDOhIuIqIVz1GbYfVaSANW7jWwd0wEXemmwXRphmFvUtyR2jvA0F7hVXIe+4aH7NSBiQxKmf0WQfoDjhciRM9xWjXsR4/MlaYshLXWZH2Cp8eQwPA22bMuc4CNWEARfTZkyTFkZJwzSs8EQQuj2S4/v9TA2eV3LPA2x9pt2zQto6QEC8xhRgbKnfqZLqMv46OMaSC2iOgksqaR4NZjXirk4NfzbzMEejvbDCs8MRS6/oZ9QQP7ywlGnGHLX6WmDIwRykeYLGnXjy1V
 rBkwsInz
 ho/DEwfY1hun4qOEXOPElA9My3Q62h8f1z9MUICcF7g5zbKz4wbcLmsAWg930alB8OWseeh6Z41FXfMLg6/ytnBZSfKdl8ElxtcPGvPvvWfUnEhZOCtZX3MGPRvWwc/LxJsCy2Lt+I0P4a9ZE0yCiy/lsx3KsJtRhN3dBQZzK8SDbWHHgy8Q3W0w4kreyCDWx1Bc7FifgKI0khNS78upR4UdUmq6hZadC+lgL/fMwbfIWKMViT8dckjdpStij7arR3Q+yc3L4GUP36mou1oAJR6iOarBFmCKEbAiQ8y5bZtfh4v6iJ8YwRS60lfxQYwm7F62hDkm8ICprj0A0kCei8lsxrO6T5VjIsnjN
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

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
---
 arch/x86/kernel/cpu/common.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 08c4a0162581..671a430994ca 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2116,6 +2116,9 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 	mcheck_cpu_init(c);
 
 	numa_add_cpu(smp_processor_id());
+
+	if (IS_ENABLED(CONFIG_X86_32))
+		enable_sep_cpu();
 }
 
 /*
@@ -2153,9 +2156,6 @@ static __init void identify_boot_cpu(void)
 	identify_cpu(&boot_cpu_data);
 	if (HAS_KERNEL_IBT && cpu_feature_enabled(X86_FEATURE_IBT))
 		pr_info("CET detected: Indirect Branch Tracking enabled\n");
-#ifdef CONFIG_X86_32
-	enable_sep_cpu();
-#endif
 	cpu_detect_tlb(&boot_cpu_data);
 	setup_cr_pinning();
 
@@ -2175,9 +2175,6 @@ void identify_secondary_cpu(unsigned int cpu)
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


