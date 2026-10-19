Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5AD0CCF2DF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323B86B00C2; Sun, 18 Oct 2026 21:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB226B00C4; Sun, 18 Oct 2026 21:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212346B00C5; Sun, 18 Oct 2026 21:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB7DA6B00C2
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:15:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63817C0379
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:15:00 +0000 (UTC)
X-FDA: 85337606760.24.B09CF69
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9F1C4100003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:14:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jvkSh0cs;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792372498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AG4iCQmCtWMmOqYT8IYP5jpAChTLSZorOObJHVgwpSM=;
	b=tF/VUyMRzn0HDJWfKbdEtEXYGzf1gpS2BtcbgmHflyrhhVr2uWyHaoORYvKmc1ptxg8YOV
	kXoMXNLPHwqPxa1z8tNXCYIG7Vh6JHDfjhhYzgBrpje0SHTD75fJT+k9HPqIBsPz0Xn7FP
	Aee5uzqvZDrrjEL3JFjNH3XF6uVhwl4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792372498;
	b=1fEqw+GXAhyOieg0mvyO2RIsYUFj9d+s8usudmI9Ungdm7dquBShsvRN0MaY/dHCAaSADy
	SRbo3zwG10WX3P625xHpgfGNaS6EGjI/sLOS4YgZd7eOjEhleO41BgAz20h7qMdAYPRpjs
	MrZwhIyx9Rcsw1El4eXA1409ZtU+rds=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jvkSh0cs;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5eabf7d5bbeso1054290e0c.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372498; x=1792977298; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=AG4iCQmCtWMmOqYT8IYP5jpAChTLSZorOObJHVgwpSM=;
        b=jvkSh0csY0XcRhvmRAnyHxBB4MZRm+cXDeFiUyyypLhQO3aomi4GTn2TgaSkHeuica
         QGdcaTrxd3akSLrvvH1EM2xBL6gbOn1biqGv7v6NjwiqX6TiPbExC45E6G78sL490dZI
         hLpqw0ae96uG8fxBuMgf78UF/snt6PUA+blHRlQK2Mg1WXfbnfT5fC6Y/VMTIlSCXhgJ
         crUGLQKTLOkHKDJOsVUPIxwa3SuCVZIPWboqqV4b0+9umbjms+nOPQPqKU4fu5G5TpGU
         FaoNOSSbqUl7U+Pu+EyjWSwSGufh4gtAvh501llic51pCVRkFINS0UHMJss5ueQYbCrW
         +h/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372498; x=1792977298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=AG4iCQmCtWMmOqYT8IYP5jpAChTLSZorOObJHVgwpSM=;
        b=ePd/TOChTRwxk0MzVa/yX5Ge0ROHpT46Yce+HKWgLjfwjEpxJg36+FEKV+58tBG5V0
         s6aNUAvq09e7bJc8V4Rb36MGZvTWTB6kzKOAPN0HXXZtAG1cV5Hm9xjju8aAZoMRX3im
         au9YaSTiQiyQJ6O2kBU55RmQQLrk+SV1aQ/ZaSycc5OyIt30Lt7J3+GaVZBYHGdwusM7
         lED4k+qgS/XdwNBVBh6p++19Wjy4ZU37DCdy8YJcxVIkTOcYEtPtLbVcyQmx6dy7fhZm
         D9eMqo+kSnW5kLSTCAvaL8/Kg+O6sUzZSIWma1Sj8RUtB7ypTWLWfujBj8K2osfeP3tH
         xgZA==
X-Forwarded-Encrypted: i=1; AKwUvBxKF7AdX6xk9CQ2vgrrB2iQ3A/Yp0+TUQ0rwIbH7xodnvWueQl2I9QtR0/yC5tqVWCHZip+t43AmQ==@kvack.org
X-Gm-Message-State: AFq9FYLgHSKFFZphw0L/dnjYbiOvucs0jieI3D6UmfL5ZJQ2lkeTw76J
	BvkOlrhXCdAoNPp2YGauVcw0mYiuyPxxoyMC8NwmgMeMuTIVbYnXjfLHNhAiYEkcsCc=
X-Gm-Gg: AYBFou06wETnxKO89XniEpvgmcWK+4H11LU4MjM3Zkcs2+BQtYRNr3K/zswex53QJFf
	4zjDw3HUIxICs+aEytMIkSY//lZjs+oHI0E/B7sxXfxX4oEYJJVpFWEm8U64klOjEMXZut7Dk1G
	o+69C5Pu4qyjlQn6FE1eAHAkNPcwk4g7Z228jAXtbttk6Euys9vj1HAli6uMg4O7gMH5hcanFOn
	Kfx45WNfxhzRRQlk1855jg3Z5kB3bGYrz/IY6CHAHVnhLxgXs+gFoOyb+WjWVEVKp016uQ+MwcC
	WToCZj318d2X7CkA4N1ybcygXMragPMhqEsX6kPqiMSl65yIND/tZOLhlCL8UCosVTz5IIB7CVB
	3HX1Snncf2EOrJPiPF3O5lghqg7ryJwqq5NAs2o3l2ksybMsv479By+Pq6xybsUwkoWYkf3FW32
	TaWXYduGb8Gk7cHueJjBiQavk/tHZoCd21XRCYVurj/oLgGCnwUgfE5oDYGQtNhu3kOIMKTRMYY
	pY6lA3gii+DH+J/hAYTlGRNQBwPSZwWZd34Tp7PWSBXCaSZ3hnioQx49BYiJJh0H9bF3FZuscHH
	ONg+6T546ML8v2+0lNw=
X-Received: by 2002:a05:6122:d19:b0:5ea:c90d:d1b2 with SMTP id 71dfb90a1353d-5eac90dd9bfmr454444e0c.13.1792372497778;
        Sun, 18 Oct 2026 18:14:57 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:14:56 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kees@kernel.org,
	rppt@kernel.org,
	juri.lelli@redhat.com,
	nik.borisov@suse.com,
	tglx@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	vincent.guittot@linaro.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	cgroups@vger.kernel.org,
	tony.luck@intel.com,
	david@kernel.org,
	mingo@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	ljs@kernel.org,
	zhangguopeng@kylinos.cn,
	dietmar.eggemann@arm.com,
	mhocko@suse.com,
	vinicius.gomes@intel.com,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	surenb@google.com,
	hpa@zytor.com,
	x86@kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rostedt@goodmis.org,
	gmonaco@redhat.com,
	jgross@suse.com,
	mgorman@suse.de,
	graf@amazon.com,
	linux-edac@vger.kernel.org,
	liam@infradead.org,
	ridong.chen@linux.dev,
	blum@kernel.org,
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v2 3/8] x86/mce/intel: Bound cmci_rediscover() to a single topology peer
Date: Sun, 18 Oct 2026 21:14:41 -0400
Message-ID: <20261019011446.834487-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9F1C4100003
X-Stat-Signature: 5ci4d3wro5h7oh7hqstr3gbyp69jozc1
X-Rspam-User: 
X-HE-Tag: 1792372498-229489
X-HE-Meta: U2FsdGVkX19DwT5O5JoHQIg9pu6hDjGmor75bpNo5zyBYECAmm+TAI8Q2w8UE3il2Y5srCp3BK4FRG+Izu4aqN/mUWQ6ZT1d/UxzumR23arOlMuZ5KlpW4gDSk8zbzxwNho89bTHlOOqoTYIzRR+wEeBnsaG3NW3DVyKa4d+jRDwlPTuPV2IpcMhupSynv6lLTObDmXN+jYfF6jnIa22wwJSVQh2oFGyCBGEnhMrdY0ZqIaVG0+3xJ9c6L7I8ZnUdSmX0Rn4rwpYnwPXALxaazbrrFgEC7FN3O1Fjx8OAroYudB4ZIkELmbQmfne9ZQtYcXGsSlWHrKRh5VnDlRnzRy+iXz982MuYyYMAJzGwpzxkFmxniYoxvOvoU2TwSX8g1shLodGS2OI1mszv4lh/8OAG96lUI3Wpt2HgcA7Qgpgsom9UxpTyI+NBEgc1mKxuDaXes+jaS1VMHfYvQqbiu7X62OpyPVYVbSFCpjDeSq3Maez8+aYMaojnbUavzzHy9QEyGTvnsVigEuOnxPzBecovSDEl57/cgQ+WqRS+Ft6rOw09Hk5vLeBA6O4bZrkzzh+Y0wyK4Irca+MoW/C+l7Nkol/PYZKS6IMevc1ti3Q28OY7Fj67u14RXGxyYq0ycwDKt6ATcaCzAsH9XSCdsWuutfCu4xD+66cBIW3rnhoEz9wnGhomvOYSEo0gbhlxNAcrFpiEFXTGmCJxBCSosL/Q9oUL+kyLeB0/t42IaxqmcmwYT4I3tOJqKDY9xXVHv71RnbAnrIGRyCv0dShKVdlpHbxdLZ/GFroImzRoiBL4Wa86cEP5gChVIIOlCB79zxCjRBfipDnDMxr8m4uYsHC6H1m2rXut0zUwqDOw42KxpRs0LgFkYwXx5HJ0+7rFK7gp0Ik0MrK12Go1bZw9OdmdDPXL5tJa+VH+NR9T1KN31+hBZM0P1T0XdUiEbkRmACM2grQzmMfN+x/3vh
 uKy+4X1v
 CASkxhv5OszhrMnkElkHzNT5hrecwZHkAoed6rdMOpiUBlJ71ig8Y+fzGtd2xF0vqQgiQiTlN+H9k8ya9sIphBEpjMGY5lSZozlZeVzKyPWah52IYZuEiKDb23YTusFkTefjv+M1wWizaMbpGZYCGnuTxqwwBTGtEsoPhu7V7JflAw4Pe07mlieJaigtSTn8htXmyLE2wTAsi+uVXkh+/eTDNjEvblLwPNwjd2sKi065k3yiGz3fnnF8cEolbsry2HJ8JXaF1xJsh3i+qHGnue880ixUKSbRd5T1VZ/uyvFAwRs6HuSW3WUTihntaAzHj/0LdAJ5z6JLvtDA+qZorOL+8KDxVhT6YSVRwjN/fJNXDDKsX9NSE73Vt6lXcRS8iBfVB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a CPU goes offline, cmci_clear() disables CMCI on any MCA banks
owned by that CPU, and mce_cpu_dead() calls cmci_rediscover(). Currently
cmci_rediscover() invokes on_each_cpu(cmci_rediscover_work_func, NULL, 1),
sending a synchronous broadcast IPI to every online CPU in the system,
all of which contend on the global cmci_discover_lock while reading up
to 32 MSR_IA32_MCx_CTL2 MSRs.

Any bank disabled by cmci_clear() is either thread-private, core-scoped
(shared between SMT threads of the same physical core), L2-cluster-scoped,
die-scoped, or package-scoped:
1. Any bank index that is already owned by the target peer in its own
   mce_banks_owned bitmap is private to a narrower scope than the shared
   level and will be skipped by cmci_skip_bank() on the target anyway.
2. Core- or cluster-shared MCA banks can only be claimed by an online
   SMT sibling or L2 cluster peer.
3. Shared die-scoped or package-scoped uncore banks can be claimed in a
   single pass by one online peer on the same die or package.

Record the bitmap of banks disabled by __cmci_disable_bank() in
cmci_orphaned_banks, select a single online topology peer
cmci_orphaned_target (SMT sibling, L2 cluster peer, die peer, or package
peer) in cmci_clear(), and mask out any bank indices already owned by
that target peer. In cmci_rediscover(), return immediately when
cmci_orphaned_banks is empty; otherwise probe only cmci_orphaned_target
via a single smp_call_function_single() call.

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:  11.42 s ->  9.63 s (-15.7%)
  Online:   11.08 s -> 11.11 s
  Total:    22.50 s -> 20.74 s (-7.8%)
  cmci_rediscover() (cpu479 offline):
    7,720.6 us -> 0.6 us (-99.99%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kernel/cpu/mce/intel.c | 57 +++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index 4655223ba560..f57718b097d9 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -11,6 +11,7 @@
 #include <linux/percpu.h>
 #include <linux/sched.h>
 #include <linux/cpumask.h>
+#include <linux/topology.h>
 #include <asm/apic.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_device_id.h>
@@ -40,6 +41,8 @@
  * owned by the offlined cpu.
  */
 static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
+static mce_banks_t cmci_orphaned_banks;
+static unsigned int cmci_orphaned_target;
 
 /*
  * cmci_discover_lock protects against parallel discovery attempts
@@ -244,6 +247,7 @@ static void cmci_claim_bank(int bank, u64 val, int bios_zero_thresh, int *bios_w
 
 	/* This CPU successfully set the enable bit. */
 	set_bit(bank, (void *)this_cpu_ptr(&mce_banks_owned));
+	__clear_bit(bank, cmci_orphaned_banks);
 
 	if ((val & MCI_CTL2_CMCI_THRESHOLD_MASK) == CMCI_STORM_THRESHOLD) {
 		pr_notice("CPU%d BANK%d CMCI inherited storm\n", smp_processor_id(), bank);
@@ -328,6 +332,7 @@ static void __cmci_disable_bank(int bank)
 	val &= ~MCI_CTL2_CMCI_EN;
 	wrmsrq(MSR_IA32_MCx_CTL2(bank), val);
 	__clear_bit(bank, this_cpu_ptr(mce_banks_owned));
+	__set_bit(bank, cmci_orphaned_banks);
 
 	if ((val & MCI_CTL2_CMCI_THRESHOLD_MASK) == CMCI_STORM_THRESHOLD)
 		cmci_storm_end(bank);
@@ -339,6 +344,8 @@ static void __cmci_disable_bank(int bank)
  */
 void cmci_clear(void)
 {
+	unsigned int cpu = smp_processor_id();
+	unsigned int target;
 	unsigned long flags;
 	int i;
 	int banks;
@@ -346,8 +353,31 @@ void cmci_clear(void)
 	if (!cmci_supported(&banks))
 		return;
 	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
+	bitmap_zero(cmci_orphaned_banks, MAX_NR_BANKS);
+	/*
+	 * A bank is shared by the CPUs of one SMT core, L2 cluster, die or
+	 * package, and these scopes nest. The first online peer found from
+	 * the innermost scope outwards is therefore part of every sharing
+	 * scope that still has an online CPU, so it alone can claim every
+	 * orphaned bank that is still claimable. If it already owns an index,
+	 * the instance released here is not shared with it, hence not with
+	 * any online CPU, and that index can be dropped from the rediscovery.
+	 */
+	target = cpumask_any_but(topology_sibling_cpumask(cpu), cpu);
+	if (target >= nr_cpu_ids)
+		target = cpumask_any_but(topology_cluster_cpumask(cpu), cpu);
+	if (target >= nr_cpu_ids)
+		target = cpumask_any_but(topology_die_cpumask(cpu), cpu);
+	if (target >= nr_cpu_ids)
+		target = cpumask_any_but(topology_core_cpumask(cpu), cpu);
+	cmci_orphaned_target = target;
 	for (i = 0; i < banks; i++)
 		__cmci_disable_bank(i);
+	if (target < nr_cpu_ids)
+		bitmap_andnot(cmci_orphaned_banks, cmci_orphaned_banks,
+			      per_cpu(mce_banks_owned, target), MAX_NR_BANKS);
+	else
+		bitmap_zero(cmci_orphaned_banks, MAX_NR_BANKS);
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
@@ -360,15 +390,38 @@ static void cmci_rediscover_work_func(void *arg)
 		cmci_discover(banks);
 }
 
-/* After a CPU went down cycle through all the others and rediscover */
+/*
+ * After a CPU went down, rediscover orphaned shared banks on a single
+ * topology peer (SMT sibling, L2 cluster peer, die peer, or package peer)
+ * selected in cmci_clear(). Core-private banks whose core is now completely
+ * offline cannot be claimed by any other core, so probing more than one
+ * peer is redundant.
+ */
 void cmci_rediscover(void)
 {
+	unsigned int target;
+	unsigned long flags;
+	bool orphaned;
 	int banks;
 
 	if (!cmci_supported(&banks))
 		return;
 
-	on_each_cpu(cmci_rediscover_work_func, NULL, 1);
+	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
+	orphaned = !bitmap_empty(cmci_orphaned_banks, MAX_NR_BANKS);
+	target = cmci_orphaned_target;
+	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
+
+	if (!orphaned)
+		return;
+
+	if (target < nr_cpu_ids && cpu_online(target))
+		smp_call_function_single(target, cmci_rediscover_work_func,
+					 NULL, 1);
+
+	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
+	bitmap_zero(cmci_orphaned_banks, MAX_NR_BANKS);
+	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 /*
-- 
2.56.0.176.g3575e65682-goog


