Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0798C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 19:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C6C6B0095; Wed, 16 Sep 2026 15:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75806B0096; Wed, 16 Sep 2026 15:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B64C46B0098; Wed, 16 Sep 2026 15:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95FFE6B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:52:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D02E40129
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:52:42 +0000 (UTC)
X-FDA: 85220672964.07.42C393D
Received: from mta0.migadu.com (out-163.mta0.migadu.com [91.218.175.163])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3AE4A4000D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:52:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dzLH3eKI;
	spf=pass (imf27.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.163 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789588360;
	b=N1L2M7KRw7qO1bfdfnzJ55R/t4d769nPlbIrwB2AZzJtHPbbxtumw8pzNW5eQKK0pHAOq4
	RML6ktgD5tTkKxeufqHm4rnVFkTp8JQr/5xWqMdr/QQziLTh0mrcOB1zPedF07nxXsYar/
	fGO46K/oQx85wJf0l0DgGOYN5KaIbI0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dzLH3eKI;
	spf=pass (imf27.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.163 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789588360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aM26vRNM8N0kowVXJFnhsjWIQzTExkuI4R9Cm0AA1L4=;
	b=h1XTYBZGZl2P/yWaVLCQKGHeO4eKXf1VAo4S9qSWUKWqRxZlFyV8OA0BkRXzE1dh71KD47
	K3NkZqg4209ew+QFuWANGYn7R3IppmL8++9PtszMYtJ3emv8AHy9r0i3butiSINKeAAOs9
	a9wuqROEcNWX5gJFcCqKHfv1Z6qJXUk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=c2qPDFF4kfts5j40iNg40AreFJxVYAetkHMQoD+HVsY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789588358; v=1; x=1790193158;
 b=dzLH3eKI4Uh6rkWoSJD6vGu6fvM27SKbLD8oX6TFYEH/KRHltqKwWGTtWMJ2kafwc0o57w5j
 /I2cHbqtygzKk4P7nnAQFcPcW7hNpRe7I+HroH/VUEMhYQU8h/K5U+ytf5SOWJ2sFQ+FDtdP0iZ
 0TurEznQTi2yM8/TgfoZeEn0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id c4c15b9716180eaa;
	Wed, 16 Sep 2026 19:52:38 +0000
X-Mizu-Trace-ID: c4c15b9716180eaa
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
Subject: [PATCH v3 3/5] x86/cpu: Inline generic_identify() into identify_cpu()
Date: Wed, 16 Sep 2026 12:52:01 -0700
Message-ID: <20260916195203.1099646-4-ihor.solodrai@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916195203.1099646-1-ihor.solodrai@linux.dev>
References: <20260916195203.1099646-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3AE4A4000D
X-Rspam-User: 
X-Stat-Signature: dw96koegnpzzkbq1u8b6kqwrwsqfsm1p
X-HE-Tag: 1789588360-344022
X-HE-Meta: U2FsdGVkX18EUnpdDUB1Am6wpT1xIEGmD7yZ9OuFqWL9/a4NbiqHtfqdhGQXm9w0SPUJRWsptvWgU7BY+MeSIr7mJ33GShvSM9arlu4+Y+V+bc2/Alc+Cyd9tQie1afLDLl/4ctlGQdvKuGsWcrAU/eX6NIgs9W92Ff2x7OfUifoZGym1t+Xm+FSQA/A3dynUEewYnXh/abzOlok9POkmW9t+4G1pthI2mztTGb/C3J8Fzv/tBmjRsAEngxOxnCb6180x7QL2WfB6kZIsbeGbQvX+xRn7PediCclohRGadfvbn95ljUteWINCYVsZEhFiar6JmIkZr5kEe5IFGy+/pK/wbocXnWjvdD8wCwqybUaGG5C2+jYwlFPjvSz0kER3JL5mkHKwEdZTCGCg8+Zxt+Pd1I8Azq18INW2B+i5Y3LtHRX+qQnSbIfo1TNpkbWzRmckvrybAEDy0yHQtwJMM3v+sKNsJ8DI8150p7NbELzU3dLVugIRMrpjQKNniDs9gcmh5E2pyPkCYMbMaGVXCY0OJIfJbxwKs3VQRvtbEbAJJ6T2I2u/AmP9w5c3Tt9qHU/TcJewlP7pF4IYK23ehYOn3m12KxlEFCAhIYMEquJ/ZHpGNhqWvirHL+T9jqKE0d55mW02EUUZSBMdWdISCpBBEfxFNmnnDSDILBh8Xx0dOwqm6FWUdOFOUyTNAzdOg3eWLnTcYEjJM3QGlpQJGcZFmUU/l53FvC3Qsv/Mb5xtItv1fnD5UWG/k+287zco8PB8tIgQeR0A45GpcBqCJXXLMF4ZawrbevN5+kwOf6TzgElAOE6uUJOfwfO1oUAkyomUfDBYaGpBgAjuXc0ZiiRDjBtSSPim9K/clOHL/28jP6qxAIjzuAEf2f/uQMC6/sWNRirQh7fqeL0TUw4gINtZtt1asx6YEwFqzNhDg8ON7gBXk+/uJuANeJdlJzbzVIbAa8LYMsas4GN5e+
 C63GIfsq
 /0Z7Zr6NRpCb+uSWqo+Va1EH4btj7EoY7soGJCYfAVMx9E7IRDOqRm9hHthRU+d1SPUujSob7T2jl3yBK+xivenza+7yku06SLK+wlI3gZkMhF8VjFcmlL+EkUrOaQPda6Z3YzWI+pcdL02AGR1QqGPyrbycBmP+B0tz+GygQzHVi9/vSKgEz6tfptGSjhGJfVF7rLVNsPfPO670Bnh2x0t7iPtDmZ3jXSRVNEmYXjGA/ePXYQ8dX4wkXzlKlI4tUBxpq9MgmqtOJQXU3hQvBzNIgWZleegya737z6D4+h4U2/6uHgixtFLPH7H5lQn1/7BQ5cUcnSadrToYMU32tDU41t/bnNl7W/D5g
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
index 66695addbdf3..2b2a4c40ef76 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1825,7 +1825,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	if (!cpuid_feature())
 		identify_cpu_without_cpuid(c);
 
-	/* cyrix could have cpuid enabled via c_identify()*/
+	/* Cyrix could have CPUID enabled via c_identify(). */
 	if (cpuid_feature()) {
 		cpuid_scan_cpu(c);
 		cpu_detect(c);
@@ -1989,14 +1989,23 @@ void check_null_seg_clears_base(struct cpuinfo_x86 *c)
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
@@ -2024,21 +2033,8 @@ static void generic_identify(struct cpuinfo_x86 *c)
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


