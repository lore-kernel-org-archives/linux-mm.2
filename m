Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01BB3CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8CE16B008C; Mon, 22 Jun 2026 20:29:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C645C6B0092; Mon, 22 Jun 2026 20:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B79BE6B0093; Mon, 22 Jun 2026 20:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB996B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:29:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 103E31C5372
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:29:24 +0000 (UTC)
X-FDA: 84909293448.24.56B9A25
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 056618000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:29:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZtCd3XDx;
	spf=pass (imf30.hostedemail.com: domain of ihor.solodrai@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782174562;
	b=udMu5cqjfia8sDoRDc9y8HlWiqlICHQgs5hwc4BYkpLXlQ9j3Eif0mIwnUtj1irt1hnUh7
	hM3/3S6lo8k6lcspS9HJwwp3OqkkSAMUboHFrF8WroL1sWzDlaedjqwpEn9X6WfpMTwnjN
	W8bQ0FYRFrRYGXEefOLhfY0JQFBuXbc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782174562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lef+zbZlC2cznmfkqDRBusiikF7Bb2MGAD4tRP3lvcI=;
	b=sc1ydB7D+9ZhSWVpLVVWT+jxf6Mj4mJEQsYlflYjj/OZGqxkoqKQWK1iaWEaB11FiQPFoa
	MAkES/yrjWD9qRE/juJDG33dAghTvGlyKWCTzB1O94s4WpHW3iVUqMaP6NTDOkpANjoND8
	UOskKcfxHE0Ql04O2PkaqjfSa3lRIzg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZtCd3XDx;
	spf=pass (imf30.hostedemail.com: domain of ihor.solodrai@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <87643862-e32e-43c7-8c81-7186f30059ea@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782174559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lef+zbZlC2cznmfkqDRBusiikF7Bb2MGAD4tRP3lvcI=;
	b=ZtCd3XDxWg0myslgDTzVk2YO2R3BnwFZmpAoKhA9z0ZIMsOrDnQFedfzaW0FuaQqSny/iB
	XYlbpSnXAQeic22gwrkLt2R1F+7zT6puwWjkHkLl5TFtCsOwVRS72C9j/kCFMUDkbruCSU
	VyCQm9v69Zf0f83gU9SARBWTZqxzVHE=
Date: Mon, 22 Jun 2026 17:29:12 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Eduard Zingerman
 <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, bpf@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Andrey Konovalov <andreyknvl@gmail.com>
References: <20260610175651.647515-1-ihor.solodrai@linux.dev>
 <326b85af-c41a-4387-90a0-60720111934d@linux.dev>
 <20260618170913.GBajQmOQyOiBLqopUl@fat_crate.local>
 <3207a706-354c-4e9d-ba53-dded1abb1842@intel.com>
 <20260618183815.GDajQ7F-bqTHnrakoi@fat_crate.local>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ihor Solodrai <ihor.solodrai@linux.dev>
In-Reply-To: <20260618183815.GDajQ7F-bqTHnrakoi@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: kjuairrwm6c8igudm585uk8cmd4jb1sg
X-Rspamd-Queue-Id: 056618000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782174561-695813
X-HE-Meta: U2FsdGVkX19PSpkI6x8PhG+0aWnZkzoL3YmmJj5OKEK8U7rlRTrjm34sD2Ebe9OVmETNt4jQ1tksFnYpBGTgF5jjmbKmsTH8g6wLLxEynFDysSBUSsG8iFVKHJK3oZ3Ood46nQrn35gDrI9UZAaiI+96U02PWX42s+TvKn34dT+Ttbf+n/Z/+PEFXPKmygFTgSYPGvFAdUKJ1TgvGQQ8lK9vL0ip/LXPRQpHBrq93z8LjMca4shH1NOlgYtz/UX0sM9xsrrbrnwoe1xx7HdNOfK77tzZrGVAMUSbBok+OsYSJ25Cl4nvoPqgxzD1KFqm26dyPflqoA8NGXlnVJc9mjw2zLSbzf560v4l/wIWVKwPZTG2o7UmlngQaEflbCJEeV/bjw1mNzh6+M/1sMjjVRPqBQsPmgIraSOy0tluoY4SO+DxJr7KJS4qYlkkXc26TniQ+z3Bcu7RlXZw0LVIIu4aYyAy8p/UnmEGi7u6e6UWcBbmA8kgJcXSwdPWeVcmmINJZmtOEC/Lh9m3z6tR5JwMcUMKcWKSr2UyBTCLtRabO/F7zL0djdY2wioCGOJGw18GZ03IKAImRnbb8rjxqhxq/L1QXpTdZTx99aMWv8Ux1qP+RIVg9+Pof3zEfmYtKhPgwJFAYKrVhcrfhArazRJIKpULeM1qBS10Ac4gLGeCE13KoRDnI9byqqQKPgucRnTAoBZtTfkDoy7S+E0n770HMx1pvXpjm133V8d1+Up2UksivJ192Hf+zH2E9ILojGB/H9QS5m3Aw+6m68lsfN73/x3GuDhLqmKzdneIxVIYbAyT5UiXwNj/0q8UTIB4s8r3ZW0/nINneqxKKFlU9FtummR+rFgX7kqShHDi/MSV50VHbpQl0qMJd2O0rz1T/cLYvaaioPlwjUdA0cl3RgURq6/5/fjR5tg5ptmsQrEWM9nSxwg/fNRlo2f+rl7hpWZHMBx3JPFAunAoixI
 82lqhsab
 42z04qN+XKe9HrDE90eDrbLwen2ospMTIoICmmo7En1G8TUKwhTBDj4TmGIfoOqFEzOOb/8nV4w3NJKWgDp/rdQuAEJcmvOmTrxhwtn2EYycbFE1aCmY1aUoau+WtI90Xcbf/5hdx2dVJPGz3p/3AUKadxGX3heWjTlzhUvBVMzm6HHjZQf7SfrSHS2cEZmis95xtevr0+KzIdSxl0wVS7ZzLgPffDd681VovQA9/s8vU0OsYPwgHjlFv+Al9kEEnhlQxDVnK6i4lpguO+sm3jQGHU7GNGdqNiLbEsfRNNyHeuMnz82/UdaM+hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 11:38 AM, Borislav Petkov wrote:
> On Thu, Jun 18, 2026 at 11:12:09AM -0700, Dave Hansen wrote:
>> On 6/18/26 10:09, Borislav Petkov wrote:
>>> On Wed, Jun 17, 2026 at 03:13:33PM -0700, Ihor Solodrai wrote:
>>>> So my question to maintainers is what approach seems best?
>>> The CPUID stuff is being rewritten currently and it should address your issue
>>> too. If not, then we need to rewrite it better.
>>>
>>> Can you reproduce with this set applied ontop:
>>>
>>> https://lore.kernel.org/r/20260528153923.403473-1-darwi@linutronix.de
>>
>> Thinking about this a bit more... If Ahmed's series does fix this, I
>> think it will be accidental. It still uses identify_cpu() and also does
>> a memset() of the new c->cpuid structure in addition to the old
>> c->x86_capability structure.
>>
>> I'm not knocking Ahmed's series by any means. It just probably won't fix
>> this issue.
>>
>> In a perfect world early_identify_cpu() and identify_cpu() would either
>> get consolidated into one thing. Or at least become two discrete things
>> that initialize two completely disjoint sets of data. That way,
>> identify_cpu() wouldn't memset() anything.
>>
>> Isn't that the _real_ fix? Instead of trying to hide the inconsistency
>> when good data is blown away, we stop blowing it away in the first place?
> 
> early_ is only on the BSP and you want to scan all CPUs.
> 
> AFAIR, the last time I was looking at how we scan the CPUID leafs, we do have
> cases where there's blips in time when cap bits get disappeared to be
> rescanned again. The toggling of MSR bits which control feature flags is one
> thing that comes to mind.
> 
> But I'm with you on the consolidation approach. I think this is what we should

Hello Dave, Boris. Thank you for the input.

I tried a slight refactoring of the identify_cpu() machinery to
eliminate the memset(x86_capability) from the boot cpu, and it fixes
the splat that I reported.

identify_cpu() is split into two parts:
  * identify_cpu_scan() - the top part, up to and including the
    generic_identify() call
  * identify_cpu() proper with the rest, no memset here

Then (gated on x86_64) identify_boot_cpu() *skips* the
identify_cpu_scan() call, only executing the bottom part of current
identify_cpu(). We can do that because boot cpu already did the _scan
part in early_identify_cpu(), when interrupts are still disabled.

One caveat: get_model_name() is moved from generic_identify() into
identify_cpu(), otherwise it wouldn't be called on boot cpu. Same for
c->loops_per_jiffy = loops_per_jiffy; - it's moved to the "bottom"
identify_cpu().

The behavior for secondary cpus is unchanged: identify_secondary_cpu()
calls identify_cpu_scan() then immediately identify_cpu().

Please take a look at the diff below and let me know if this is a good
way to proceed. I don't know exactly what I'm doing, so concerns and
corrections are welcome.


diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a4268c47f2bc..4a655109cacf 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1978,8 +1978,6 @@ static void generic_identify(struct cpuinfo_x86 *c)
 
 	get_cpu_address_sizes(c);
 
-	get_model_name(c); /* Default name */
-
 	/*
 	 * ESPFIX is a strange bug.  All real CPUs have it.  Paravirt
 	 * systems that run Linux at CPL > 0 may or may not have the
@@ -1999,13 +1997,12 @@ static void generic_identify(struct cpuinfo_x86 *c)
 }
 
 /*
- * This does the hard work of actually picking apart the CPU stuff...
+ * Rebuild capability set from CPUID and re-apply the forced-cap overrides
+ * through generic_identify(). This *should* run with interrupts off, otherwise
+ * an interrupt handler might see the capability bits cleared.
  */
-static void identify_cpu(struct cpuinfo_x86 *c)
+static void identify_cpu_scan(struct cpuinfo_x86 *c)
 {
-	int i;
-
-	c->loops_per_jiffy = loops_per_jiffy;
 	c->x86_cache_size = 0;
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
 	c->x86_model = c->x86_stepping = 0;	/* So far unknown... */
@@ -2028,6 +2025,19 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 #endif
 
 	generic_identify(c);
+}
+
+/*
+ * This is safe to run with interrupts on.
+ * The boot CPU can run just this from arch_cpu_finalize_init(), because
+ * the scan part already happened in early_identify_cpu().
+ */
+static void identify_cpu(struct cpuinfo_x86 *c)
+{
+	int i;
+
+	c->loops_per_jiffy = loops_per_jiffy;
+	get_model_name(c); /* Default name */
 
 	cpu_parse_topology(c);
 
@@ -2154,6 +2164,17 @@ void enable_sep_cpu(void)
 
 static __init void identify_boot_cpu(void)
 {
+	/*
+	 * The boot CPU's capabilities were already scanned by early_identify_cpu().
+	 * Here identify_cpu() only finalizes them.
+	 *
+	 * 32-bit still needs the full scan here: it sets X86_BUG_ESPFIX (via
+	 * generic_identify()) and the no-CPUID cpuid_level default, which the early
+	 * path does not.
+	 */
+#ifndef CONFIG_X86_64
+	identify_cpu_scan(&boot_cpu_data);
+#endif
 	identify_cpu(&boot_cpu_data);
 	if (HAS_KERNEL_IBT && cpu_feature_enabled(X86_FEATURE_IBT))
 		pr_info("CET detected: Indirect Branch Tracking enabled\n");
@@ -2178,6 +2199,7 @@ void identify_secondary_cpu(unsigned int cpu)
 		*c = boot_cpu_data;
 	c->cpu_index = cpu;
 
+	identify_cpu_scan(c);
 	identify_cpu(c);
 #ifdef CONFIG_X86_32
 	enable_sep_cpu();
-- 
2.53.0-Meta


