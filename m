Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D73CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9B66B0095; Thu, 15 Oct 2026 11:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289BE6B0096; Thu, 15 Oct 2026 11:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178976B0098; Thu, 15 Oct 2026 11:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D35EF6B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:33:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B1F0C0A4C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:43 +0000 (UTC)
X-FDA: 85325255526.17.BF6439A
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8D165A0006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eZkZS7pk;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792078421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IofewvjhR0Ae8pfrPVVge9u/2aO2fEHS91BGZ9RvoVo=;
	b=gNl5ELfBnRllT75iNgpgjDftNiACmvZJMI/es3HkzciH303thRMUrvkWK+D6SMRS9DSTpt
	O1jMTOHVBkRYMhAW7wFaVHW7n0CYybF7Ww9LklQtU2z/qsMDdcI2HiwhLcymIQFq4KAbpU
	CkMe4mXwYrZNMI59ZSeKqhySSyYAAxs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792078421;
	b=I8wdMTjAMgSs9qTf3ojD7T6AZq1gRwPDDwKUuTPiSqcRnR2PSAJaIShCrGql+v8lHkdQ4t
	QLvNwrHQszUze1jticwuHAty2ZpaF2lc1Y5mzVevXRLaoDfGfHevaWIqhhIX3DrqT8sD9I
	i7uBUBWF43tglgqpIg4+de06ViHaw0Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eZkZS7pk;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-98c786605e7so822177241.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792078420; x=1792683220; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IofewvjhR0Ae8pfrPVVge9u/2aO2fEHS91BGZ9RvoVo=;
        b=eZkZS7pkUF4T2WJjCLXZzVsbYsTWX3GCNkf+oQUAGcE8+fmqzqZ2bkb66NCXJg3ptV
         iPAoyQJGt1qMbCw1muH80lwzA+voH3rtfDLigPnZdLjWuwNjB0/mbYJ7bkcqKLiILnqc
         z56Exg01Jwj7ryE7md8H8mP9v/cOuIg4YDsS3zFNBsSfe5FIUeNb5l+9iKF9+YbOK8n4
         x2ADaa6hxwe5uF/ySOuITtiuxgZzkViNNiC9RbuQCbhgF1FAPOe3UngDXBU1UmdvSICA
         +eBd133dSlZOpdGae2LOjLU13zblZYBRvhtRH1ZuBm3cGHB64MLo5DYqSjRwYCrJ62hE
         bazQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792078420; x=1792683220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=IofewvjhR0Ae8pfrPVVge9u/2aO2fEHS91BGZ9RvoVo=;
        b=tTdHCHEBZPlfUC+R28Tduead0kFo1SESMn6/qQThxlNFKlOadDA+mJgaVgTIvpX48Z
         HeWzsCRUOjjvKoXMNMwiGTG0OT/CUNc2crPRxp14MfgOvo5DC3qrp4MVjACR5we5VO3m
         RqT0I/iyTGNi9Y38DCBPfXW9bFMJDmF9JE29883wLhY01lGfuwGM+YJta0aMagASCk9W
         vjKfVudbl7eE9OofMbuKKXcmq5P5+Jq4lBKCTEEm/kL6/AB0BGZQ6YnU6Qc+yRVitGDe
         gxvddiEhBdTiJr9xMzm/v4lEEFJ/yQlCIzDtcJ2q1du3TmX4e4fIQjdkzUxbp0SnUJHH
         GPYw==
X-Forwarded-Encrypted: i=1; AKwUvBy+ZzZ/jwJIhzXGBOJxBkRC8GXvBOhE8DWJ1ue6BzKPwr3Z+1O/KwqOWZrKl/nVERA2xXm0Oq81FA==@kvack.org
X-Gm-Message-State: AFq9FYKEJG5fUMVsIhO4PBrjL/GjCdcOX2u4zcSHJThu5FZ+jHkwXqae
	gh6x8re1bO42v15LWyNNMhQuv5orBe4RlT0fapf9GOxlHNMxJDmQoR9mYwgy4m/mo3U=
X-Gm-Gg: AYBFou2jTESHbk3nZ48fqC1wnCfgRovU1I5/9TJ/aTEWbh/4ZC6aKSxkIa/yifkdWJq
	V7wQIzd+Y49+DFcyyF9ybCrIQE5Cvx8CFsIBqFwTq4ZtN8Hw73kexCisJu17blWqRKRBsgn7cwa
	uv0CF8/aw8BXsdnFU5ytG8PEiyXB6fyB2IcRehZbTIWjNGOeH+l1IkJgH3zEHT/rpx/dri6Y0sl
	p1DOlm0OsphpENfkfDUqCIkam5Ch1NRwr3YD0BQE8VLOVkKCQ4r2pfTdLg7glVXMbLN7AfDyfEt
	OOU/DniphyTORGSUW+8I4Dsv0VBVqB8gfvCWLXaG7bQub/9dtYHNCyJP4wV1o/9/AIcFAeMNJAs
	Ricnw+8k4ih5ylZYyRdW1zJ0ngl45RVC+Z/G1S1ZfpyAOqd8Wqy7hTUnli+VA62GDrSLHb5vnD7
	djG6xOspxsXpseDuhKqeICrrw2jYc3j2OxEbb0W3l4240lauTW7qGw0nrN8Jj8Iv913Xt5eSjqt
	qe0rT/u30nT3oZRqhUSp2dgM+RuPZWRQM+iejq25/VQOLO4quaxptC07w7S8f1yh42qdKbyi5CV
	/DDGR4r+PdwOzgFYGnE=
X-Received: by 2002:a05:6102:8088:b0:7c1:62d2:e18a with SMTP id ada2fe7eead31-7cb372f3a68mr6949040137.16.1792078420419;
        Thu, 15 Oct 2026 08:33:40 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003f66ad9sm12986347241.10.2026.10.15.08.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 08:33:39 -0700 (PDT)
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
	thorsten.blum@linux.dev,
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
	tj@kernel.org,
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
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v1 3/8] x86/mce/intel: Bound cmci_rediscover() to a single topology peer
Date: Thu, 15 Oct 2026 11:33:26 -0400
Message-ID: <20261015153331.1872641-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8D165A0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gzbses14drtrjf8rwky9ezsp7en7zcjo
X-HE-Tag: 1792078421-666531
X-HE-Meta: U2FsdGVkX18QdbToS+sWoGU6AvKqMxt9IqJg88OFK72Ss/Af8SsbebobbrdOP40GhuRwPdJmKVQ23+bB9+x99ySQfGv0W4FAnptR/pLT32wJkn2P8d2V4lIwqcEa+FlQlXHRO8ymvKyhSQIuWMm71bhhWBjxLKkjms0vfPKvRNWnPnJcUmG4u8K8dfjT64laJ0oNzcIBXO4VRUKg389B35sGTWNCMPRiySHc6wW15T/VkP+oSd3bJH6YL1xXNLFc5q3qWbyROE/vMd18+c8rs92JmXtpc1q5sbYF0InOkKWshM5XnAfrFRawoUe++LuS93dhfhzS+QRNzdaqf2bQyAtHzfsQOfg99WK4b6RJNH/qMaM7OKwH+3+yVtdfwvo40QkywDSbQAtve36v2yeC1an910PCunbBdALaV8iydI5+E4ZYCNr0T6XwO9Z0kMQsSbE5zNt2sniHsgWSfEEEa16Xfo67Mka6Gv0h89/68K0Y51a71B+F3NDUnBZiH89u0NFUtCwAJNbuBzGUQv48aXnITqtHpPZfhhJKk0h657sm/E67V4biBZ1ZlT4fzagFCSMxNdWwqWsclFXmL2/ni0W9YkdzZGP7BqCeah9J/B59+dKTEFll/7versHPcjdowdFvgSt51i0cUwd7+N29rQghAMvI7pHqbC78jfrnYo0gr1wTDdkK3J7Tg/jOCg/3oeBDpWzqITHHN0T5ndFzopQtz6ayZ7FGkasjTcTq+JOHFM/qugNB0V580GFrRffKawTnn/lS6jTx1VTnKb2dLoyie/L69n/B6fjmIu3IQegwMo/i3mBm3SDbo0D10Iqr2I8M28zXX4ASZ7oKSKvDf72pmz40Wi5c98DYcyDzd1/ck9KipmYTCx/DxmtDSxbldSr99di5BNb+1GwvA4lr8aoHJR5sD7Zb8D+yg4THdNl159Mijk7EvLkR1+xwWVor18iqlBYhXdGGKfCBjEe
 AWkneUuh
 EzpPCjKtrSkOgxNffPNYy++ScO8Rhk46fLmQ8+ZUHCYItxC0zWjKVrKLYYrBYSil4xy9SqXq56tSrdsodfdFZwFWkG0Q0BjKQvVFcAXfEo2Y9xYPVg4eGK5w617Ae9Q92VtTzQ76GL87FPdVnV9Ho0yl/P5BDV+bEzpIga8AJTaoyad0oMCB0D6RJ3HR67CtvuVU+q4iQAjZEFgRJNMET3wT0i+sFK1k3cqdmh+D8qwNbcFIMm7Tu5IPmfIgarHzKVXjJbs2wSEZXWgLuWlHwrYjEmWlzvBeMX1qI7WdqoOeWlcbMwwdbNVmWWifYoPDdji3D48KCPWQpk1MCzLjffNR1VJLdoJ63PrEsTPvhgK1uXKO8VB0AL2IlZoJ9VSHwoMXI
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
index 4655223ba5606..f57718b097d9b 100644
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
2.56.0.385.gd3acb90ef8-goog


