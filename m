Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CBBAC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 00:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EBCF6B00BD; Fri,  3 Jul 2026 20:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574CC6B00BE; Fri,  3 Jul 2026 20:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491B76B00BF; Fri,  3 Jul 2026 20:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE08F6B00BD
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:21:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1488B4035E
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:21:28 +0000 (UTC)
X-FDA: 84949190256.23.99A1214
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 61CF240004
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:21:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w9EOB3lT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783124486;
	b=oOFWtDTXyJX3sBswXR6lv1gL1bMivjW+UUIoumyfxR8kjlYiBvl/pyg51RhxSjCP9mf8pX
	mnRjCgFAg1P1RE0I6R8j//z0uXpebxO2CtVXRmwqNFCbKJYc9wdnz26n1+ASQvZVqmpWUR
	g6IJyXJ67t2zkiuINAXe3Ll40PjpVrc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w9EOB3lT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783124486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Udq3/2zgh/qo/G71V2iT9d+CQ5RvaKNE12ZPGhXw2jY=;
	b=tB1xAKSlhvPVfGwSHN/GegGN+0Lashgk5DJXh2p7MAszJH3fZdnKZbdTK3RaM4ATFIpBxg
	MeBMQzqSH9N/QaJe/BEX/TkPQ6SfPrI6VE/fAvX73JVKF8wX8PKd5BAJellDoVL97dnx1q
	MxKv+ADTF1eEoLsKDn+vb60eYBTmriU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783124485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Udq3/2zgh/qo/G71V2iT9d+CQ5RvaKNE12ZPGhXw2jY=;
	b=w9EOB3lTthCQPBsNqGF0bkCe84OTmUAadNbqCqOqT6Tf04IVwAjVDBq6bEf04vFnKX2nT8
	yMb88Y1+zhV7rAqQXWZTAykCx9MzYm33aVeoJrIrbDf+C0z2gjstdeJkxBmc4aZBleuH5n
	+EJ4Ga97YxepfCd5rdwfTSQGuPRqDtA=
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
Subject: [PATCH v1 5/5] x86/cpu: Don't reset boot CPU cpuinfo in identify_cpu()
Date: Fri,  3 Jul 2026 17:20:46 -0700
Message-ID: <20260704002046.3859585-6-ihor.solodrai@linux.dev>
In-Reply-To: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
References: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 61CF240004
X-Rspam-User: 
X-Stat-Signature: nixprrhjominmegoncw8pm3n4qu4zwxq
X-Rspamd-Server: rspam03
X-HE-Tag: 1783124486-268204
X-HE-Meta: U2FsdGVkX1+og+ELvTK3iE8SuU9CjfJMhViPMBcphy6cwOqkD9tDNMX6G+azhvirL1fhcKPWwPq0LRGl+JVfIRDRvWvxhyz5Sd0LqRlmJeKNrxXkhDNpiAvKO7d0+JYf+siu/nt+S6pvWNwHup1NMc5nwGh3QA4N0eVlb9tJfIeLrHjxFQSCV4YHYph6Wjy5M9mNmScgb5Mv77EqrlpMxBZ2dXi4J1C5VTiolsop7SzINA9VE3YrFK7nopaxde8IFZ7cFm2vVvgwgRlkADPsvCEbqljajh+WyKXbhDLBsKROsC4zERi2KvncOYdi3VQKNhN5vUTXi7q3suHqtNIZpXVIIil/eUJCAsyzDQFcunzEF8Kiat+TdT+L7teOWUB0mYQMolexVXUqIGFKkDm3FLn0N4S7Sa8EqQfVgobvjYqFtcmLcIdYHP5cKkShbMIpKT6uGSt0ChYzWVzGSHsyMJuplN5Df9u73IlPtOUXigtMAbiUJ3ze/xJ+tmggr+oY7FpdvWGkXA9ySztwUGmTgI4ximx5Ue2j5F//TM6MLhn5+bOutJRtlNHtygddhmycj9KEwVgH2Bwz9TycfOFpEn5Djt4dl0i1t1Kygoc+N1TyzYlzi3ngNQrIx6HH9nBI+ObS+DXqfArqW9ZomlpsXC80oqDibTq68LFBogrjMwNIuJPyOkZdBbnytn3oJxgJbsowBOqYE0BmUr5qVc7b60PHEK8z/qHEh9cHjfbtw56d6VUkroq0oHfU061nCVUgfVaADvx+2nqIcR8o2RjSlCx6DTKmpGpjrXtUiWcBxNPJ3uPUEi/7DX6NGn/U8/IOjuNPfi2SQHfo7VSBrIxpLbgYJeHXMjv8evWjqZhagO3HPg1Pcmv75urRSEm8pZPNDeQtyUReDkWa9rbikBmIWRCv9HeXe4qY0Tt02qVMR8OBgPe19/qeZ/iTCI9eSURC8mgWytsdh0J3B4rW9dG
 CvExP/rL
 2UGH/jOxYkVyadbzn6GO+g3dqYYA0wlTlNw36QOJa9tbiJ2qqnxn06O8Dbj+4bfWtQGMHekGnjlmeFXXn1TpYv0NlbJvIcHZZKmkKwQTDqIgSXUZGIIiMYKfIhHzV03gT11g/jFvWjqBaaQdjocj4oxlVi7nd5Mx0fhkTyHZhYY+9wGWAvVRJrL9Mlegdp3iBRqhNhpaFNr9mM3uz7FR1aSp0H5ibIA5aSAyKermEIaDBDu+Jtq/bj+Sv0uEfN92fKFlfOk1iBjkxmO8KhNHNex0wc2iyngspR4QHIBUgixKZwYJNL/GUuKFtVZlztcoXDiIPFOxnN2vZDA8lZRR3iwEDEDDiKpR3Rwvk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

identify_cpu() used to rebuild c->x86_capability from scratch:
init_cpu_info() memsets the capability array to zero and
identify_cpu() then re-reads CPUID. On the boot CPU identify_cpu()
runs after local_irq_enable() and before alternatives are patched. An
interrupt delivered in the window between the memset() and
get_cpu_cap() therefore will observe cleared x86_capability [1].

However the boot CPU's capabilities have already been scanned, with
interrupts off, by early_identify_cpu(). So move the init_cpu_info()
call out of identify_cpu() into its callers, and skip it for the boot
CPU on 64-bit.

Secondary CPUs call init_cpu_info() then identify_cpu() from
identify_secondary_cpu(), with interrupts off, exactly as
before. 32-bit still resets in identify_boot_cpu(): it relies on the
reset for the no-CPUID cpuid_level default.

[1] https://lore.kernel.org/bpf/20260610175651.647515-1-ihor.solodrai@linux.dev/

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
---
 arch/x86/kernel/cpu/common.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8f093c6c7ccc..cd3d7c37c174 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1986,8 +1986,6 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 
 	c->loops_per_jiffy = loops_per_jiffy;
 
-	init_cpu_info(c);
-
 	if (!cpuid_feature())
 		identify_cpu_without_cpuid(c);
 
@@ -2156,6 +2154,13 @@ static void identify_cpu_32(struct cpuinfo_x86 *c)
 
 static __init void identify_boot_cpu(void)
 {
+	/*
+	 * The boot CPU's capabilities were already scanned in early_identify_cpu().
+	 * However 32-bit still needs to init_cpu_info() here for the no-CPUID
+	 * cpuid_level default.
+	 */
+	if (IS_ENABLED(CONFIG_X86_32))
+		init_cpu_info(&boot_cpu_data);
 	identify_cpu(&boot_cpu_data);
 	if (HAS_KERNEL_IBT && cpu_feature_enabled(X86_FEATURE_IBT))
 		pr_info("CET detected: Indirect Branch Tracking enabled\n");
@@ -2178,6 +2183,7 @@ void identify_secondary_cpu(unsigned int cpu)
 		*c = boot_cpu_data;
 	c->cpu_index = cpu;
 
+	init_cpu_info(c);
 	identify_cpu(c);
 	identify_cpu_32(c);
 	x86_spec_ctrl_setup_ap();
-- 
2.54.0


