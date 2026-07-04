Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21527C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 00:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883DC6B00BC; Fri,  3 Jul 2026 20:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B516B00BD; Fri,  3 Jul 2026 20:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A196B00BE; Fri,  3 Jul 2026 20:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4843D6B00BC
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:21:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C58B91C722B
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:21:25 +0000 (UTC)
X-FDA: 84949190130.24.0AF7F5F
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf29.hostedemail.com (Postfix) with ESMTP id 34EE6120005
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:21:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Bx+/rbkl";
	spf=pass (imf29.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783124484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdrYYHrpsx+P80tgVW4Fs8Ygiy8h4jkJ/VS0hdKA83I=;
	b=h9JIZZdtS+PlcKs4NqBRga9EPbkttkfpJIZ7x4bA3a78i0pkYk4+4CS9lgRhseiiuFsEHm
	alkd3EPf5cIuWdgUx4s7bpISipKeX7Yt6iOQqwbHLLt43eGiFiWnF18isIdnIbnSEqiY/Z
	A8QMxqKCFWa+opIT/4P3YZBskQAccHQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Bx+/rbkl";
	spf=pass (imf29.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783124484;
	b=bYIbMFfBzZq8K7VXmavAouNBp+cCKIPjzroXaimwp61KIHLbh7i4GEL8pp1rmhYT6II3UK
	/UWZi48wnSnpVVcMPwj5wBrVKjKQ6Kk8txC3GL0S9X7Qf4PBzPnH5Z2cZF9E9uIBXYLhes
	arSsk2uj8+Yp4jThm8wWHGAPp4aOdKA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783124481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zdrYYHrpsx+P80tgVW4Fs8Ygiy8h4jkJ/VS0hdKA83I=;
	b=Bx+/rbkl966Cw6MlCohyWVIf/IZfvZXlYuLgbVti/XOaa63KVOYwAeXbsakWLkU6TPJAnw
	o8CJHR9qB2tnnMBib/8skqUH2E0qx5EJaqeG/bmskJEAG7jhXdmD8PrptegdNX2sNxLAvJ
	x3oAR44UV31IQ7IxL9QOpHshhgPFnv4=
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
Subject: [PATCH v1 4/5] x86/cpu: Set X86_BUG_ESPFIX in identify_cpu_32()
Date: Fri,  3 Jul 2026 17:20:45 -0700
Message-ID: <20260704002046.3859585-5-ihor.solodrai@linux.dev>
In-Reply-To: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
References: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 34EE6120005
X-Stat-Signature: brnzqhaomfin71df7qotms383iohmz3o
X-HE-Tag: 1783124484-87517
X-HE-Meta: U2FsdGVkX18K+k+Msgc/7kUNa5ng81Hl7xy80c8XZkJqt5UuAfxQEX8hcA9e3CqQQNUI9U8A4B0K8gfoBisUagQ3aHc+tMIyzNueeu8mA5bXihe2vWX+O11Ws10c8oQtqFIKs6MFmD5ltY8VrgQRznqGdDUSLgnZtaNwlZNpaikCjT19SMqRiKJKbmzFI9p1Bp4R+lwtNHoBtryPzmjwibZUecrSZbFjpgLKrvUvR/ZuqDYr3seVgmk3nAqR1Sg1oPJKnDVZ8dBrWsUCERJR8mcG4DQmzlc8DRv6xAq8Z2BASWMZUdAAvOQTISwb2JicvEYb4fgDQt+RowiS+wz/5XF0dbgGrzqX77nrROhAluP5XLMLxc1xYku+srXREBx1m+bD7iNiT/Soph+Q9EJZcN99djB49jURvxvnR9iAnw/Q+sUW0dRayE2z9bfcluJEOwQyI0mXAg3UDUstdZzUe+A+zB4zodBnkhMAuzuqcYoIa00K1YrEcwBQavhCAQSmuxV+80PVh0NIgzTH8RXYzvunybuXONCMTfB1SMUdFYDg/hdQgt/62U0xC2HS694rO8ae+pcMpLYIqby1qGEfduxuMikrhC+43ZqdOw18iUIqBfHsY/jHvk+8y+770ZR8dmnj8J8C3p8Hax1kiH9VaJa9QuJNgcjd1Ylj8YvmLHlZn9ribws3iYLA4CWbetUG7t2KxWiUTrsPKRJUWza1tkEKxDWc7MOaqKoovsgeFr8fNHkcnPBSIVzR54ubhOQeAYGwKFytZ5y6RJjEbdCtM081W4RYlMFZ3sRTpykMnn3vxSVl3w/orDjQKq7xu3kMyWeGAMk+LYUATSdbBEtjaJ5SKb6MipJ1ZqGCk+EbO8SqJDCHhtaIeuLy1SV/TTVEDb53mgXSDX5Q4N0aQB9NSDv1R3WHhAXStB4pq4J2ivFzLsNvx+uUHY+fzqHvdHwJMb6yrb3dp2O0dWZyZI7
 2smAB84p
 iqc2MeYx763eaT5cpC/tl/P8IFSMp5vd26Spqn9+yOLaOhmLCk5VfVtr99iM9BJ70CucxIDHXVoDocJBzVDqQiM/9+995QtGn+AkuKyRmGDbGn1+/CI4w+rxllRbVl4p11g1D8rrZocQDQ1i/mSh4cUKzUMkraGbaZcHY++dJ/7/x9j5GPxh/VAaGX6VJMmuiwRppjI2szf4ne2EpA3/Bq7QjFnNizUuyRqfPfdriXDOMZQzKZrUFuxRGGWONlvKY6kMlA6vR3NOE8omLQi/otc7uIinsa7qMvVFNoO85o61zFhesH5uSZ6NRW8WBCuRbMfAP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

X86_BUG_ESPFIX is 32-bit-only.  Move setting it into
identify_cpu_32(), next to the other 32-bit-only setup.

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
---
 arch/x86/kernel/cpu/common.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 519e495c4a14..8f093c6c7ccc 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2005,23 +2005,6 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 
 	get_model_name(c); /* Default name */
 
-	/*
-	 * ESPFIX is a strange bug.  All real CPUs have it.  Paravirt
-	 * systems that run Linux at CPL > 0 may or may not have the
-	 * issue, but, even if they have the issue, there's absolutely
-	 * nothing we can do about it because we can't use the real IRET
-	 * instruction.
-	 *
-	 * NB: For the time being, only 32-bit kernels support
-	 * X86_BUG_ESPFIX as such.  64-bit kernels directly choose
-	 * whether to apply espfix using paravirt hooks.  If any
-	 * non-paravirt system ever shows up that does *not* have the
-	 * ESPFIX issue, we can change this.
-	 */
-#ifdef CONFIG_X86_32
-	set_cpu_bug(c, X86_BUG_ESPFIX);
-#endif
-
 no_cpuid:
 	cpu_parse_topology(c);
 
@@ -2151,6 +2134,23 @@ static void identify_cpu_32(struct cpuinfo_x86 *c)
 	if (!IS_ENABLED(CONFIG_X86_32))
 		return;
 
+	/*
+	 * ESPFIX is a strange bug.  All real CPUs have it.  Paravirt
+	 * systems that run Linux at CPL > 0 may or may not have the
+	 * issue, but, even if they have the issue, there's absolutely
+	 * nothing we can do about it because we can't use the real IRET
+	 * instruction.
+	 *
+	 * NB: For the time being, only 32-bit kernels support
+	 * X86_BUG_ESPFIX as such.  64-bit kernels directly choose
+	 * whether to apply espfix using paravirt hooks.  If any
+	 * non-paravirt system ever shows up that does *not* have the
+	 * ESPFIX issue, we can change this.
+	 */
+#ifdef CONFIG_X86_32
+	set_cpu_bug(c, X86_BUG_ESPFIX);
+#endif
+
 	enable_sep_cpu();
 }
 
-- 
2.54.0


