Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5945CFC29E
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 707C36B0092; Fri, 21 Nov 2025 13:55:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620096B009F; Fri, 21 Nov 2025 13:55:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424E56B009E; Fri, 21 Nov 2025 13:55:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3556B0092
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:55:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0E6B4F05D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:46 +0000 (UTC)
X-FDA: 84135518292.23.11207EE
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7616280012
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=MO+iCsoU;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763751345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pH3tylSDYWWE7T+VMZYdhlnwJgMTm4AeNoqz5h0S1Tk=;
	b=aQfhVYxFG78txiHquSSdGbYgeXcTYNh7GBgXrz5Q67mG2OjhzRbmnt4IFWR9RInuAGZgOo
	9iyshxEsQuVNYn6qIPhMsaATbNuazT/EYTuUZOs3rpdnAuISGE+6XbEEjSDum0vu1mcLE2
	tgTryjLHMuS4IfEzQc3i6pvAE4WBVWg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=MO+iCsoU;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763751345; a=rsa-sha256;
	cv=none;
	b=DCsETRN5MYdWh+FDHDI8pVf84HdISKWUgl5+NBH2K7H34e88hIlEB3Iwnd7Tn79Lq5LbpW
	HTTc9FGKb2aYHGFPiMg5+QMCq0cH0xkhJFZ0LhVSylHDFfk15/gxuX+rnUeb24hN2zp9iH
	eKw3zmtv5H6Zp49fXarzXR7cWDxFTiQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pH3tylSDYWWE7T+VMZYdhlnwJgMTm4AeNoqz5h0S1Tk=; b=MO+iCsoUnmRNZodJZd+ICylvzf
	CRwukQLAvh/vsnqme1KtUT+EuEKO/QY9dhULXrvdUKwgMM7FJfdWF0C6gi1ExHbSNMwKgLr2YiaHn
	0wFwjVQn18gFXEm1K3xHYbOnPYSINA47qHX9iSnp9SVa8eIa1aQO1NK6Dok7dQje3kJY/vf+QbBTm
	wJymoIKOODkT23bOWlnEdmgIZw3jPR9olYcSMpkC6i4ZiSI4BEAFQoDjPv7gSDZLoQAs26wSJUfg2
	fi+w1C78eAYq2Wkql9EPY5/9UZapsiCo0jXQ/7p8OOZIqEjE9ObVQOJR7Z7791A59x9WoX/FFvBzD
	2sWRRAYQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vMWI9-000000003i4-1yCh;
	Fri, 21 Nov 2025 13:55:34 -0500
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	peterz@infradead.org,
	kernel-team@meta.com,
	bp@alien8.de,
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC v5 8/8] x86/mm: make RAR invalidation scalable by skipping duplicate APIC pokes
Date: Fri, 21 Nov 2025 13:54:29 -0500
Message-ID: <20251121185530.21876-9-riel@surriel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121185530.21876-1-riel@surriel.com>
References: <20251121185530.21876-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7616280012
X-Stat-Signature: 9p1th3wpewrq7858qu967eo86rn9gfc1
X-Rspam-User: 
X-HE-Tag: 1763751345-481136
X-HE-Meta: U2FsdGVkX19rFAQ+1wY6KjVpWPClFsF36NVWVMP4ys0kN7cdDEJNzWwQOvlaeD8lQiY/cea85IFUYQqWhiaSTEUu+iIh8sr4ArpBolK7pLnmrqFcapEPNG50XvPfwDNQBl+6RlKM/wwW2QTk+4jxWpFTZNuobyShvEU3p0s4YGwgi5BJSRNf10nY70JM+p/y82m/Sy2vcwq/xhKeIdgcFJ8aVcFBym3mIjZAN+dpk0BFX2B7HSXil5o3HN+cphMErQOFcCm2GOUPeIUAZkbawKes3hdYyj6pq8ocoxwULozxbD2+LOqGj0VYk/r4itzSO9dD/Do6zdS4ETA0vqftypMvWEz5sfWMkJMp5ifG13dbytXdK7sf5m+nnwenhRh1huakAH2PsPMjRUHcokX+LUYVNs43jGg2/TvpZU9FF38a6w4hJEZrBkdgNvWNgrINBDWGMxB43tHdgozIxJ7OaVpYN2xNhuXRTsyIXzCO26pn4s0USe0rH2TvN1Wo1yFiy9eoHkI9jOegNuf4YI0nCIuJKrwK7LFNHc0Z4wDAG5i2GgvUitBdEc55ctFuIFNc+VT/tqasL7MuSQpODocV4NsSt0+rr+2rKIl6TkLuKWAfkPNkbz/GSkaA0newDh3YY8P66FqZc7JpLmqkqwbJ9fTHN3PW5nTWUtj8uxsCpXu0XFxs6KhXoK7HQqhPFVbs590yD1OUbDZ222qQk4nolIhkNElQaMIAh6Z7LH4yKOtZCzDBCqItpD4w4ssAdvaiY87OQwX8LnAm7jxV5LE0IGSuIqfLnCr2e4241Es3JbzLSS9Z/c9h9qV+C7FfYYgid7XRpuYrMeRaemf7KKspkLGn73ZlufiR1QCH8AKGgaW67353H4/qWLhg5jkAFOFbnMHMLkehoK40QotnGuX54lfzcrliN0vCRbpbeLOgmKzKABRya7f/7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

The naive RAR implementation suffers from heavy contention in
apic_mem_wait_irc_idle(), when multiple CPUs send our RAR
interrupts simultaneously.

When a CPU receives a RAR, it will scan its action vector, and
process all the rar_payload entries where the corresponding action
vector is set to RAR_PENDING. After processing each payload, it
will set the corresponding action vector to RAR_SUCCESS.

That means sending one single RAR to a CPU is enough for that CPU
to process all the pending RAR payloads, and other CPUs do not
usually need to send additional RARs to that CPU.

Optimistically avoid sending RAR interrupts to CPUs that are
already processing a RAR, looping back only if our request
went unprocessed, but the remote CPU is no longer processing
any RARs.

This changes will-it-scale tlb_flush2_threads numbers like this:

loops/sec  IPI flush    naive RAR     optimized RAR
threads
   1         175k          174k           170k
   5         337k          345k           321k
  10         530k          469k           497k
  20         752k          363k           616k
  30         922k          259k           754k
  40        1005k          205k           779k
  50        1073k          164k           883k
  60        1040k          141k           813k

The numbers above are on a 30 core / 60 thread, single socket
Sapphire Rapids system. Average of 4 runs.

This exact same code reached up to 1200k loops/second on a
-tip kernel from a few weeks ago, and did so reliably across
several reboots. I have no good explanation for the difference.

Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/x86/mm/rar.c | 60 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 54 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/rar.c b/arch/x86/mm/rar.c
index 76959782fb03..fd89eaaf4fc1 100644
--- a/arch/x86/mm/rar.c
+++ b/arch/x86/mm/rar.c
@@ -11,6 +11,7 @@
 #include <asm/tlbflush.h>
 
 static DEFINE_PER_CPU(struct cpumask, rar_cpu_mask);
+static DEFINE_PER_CPU(struct cpumask, apic_cpu_mask);
 
 #define RAR_SUCCESS	0x00
 #define RAR_PENDING	0x01
@@ -47,6 +48,32 @@ static struct rar_lock rar_locks[RAR_MAX_PAYLOADS] __cacheline_aligned;
  */
 static DEFINE_PER_CPU_ALIGNED(u8[RAR_MAX_PAYLOADS], rar_action);
 
+/*
+ * Tracks whether a RAR is in flight to this CPU. This is used
+ * to avoid sending another RAR (waiting on the APIC) when the
+ * target CPU is already handling RARs.
+ */
+static DEFINE_PER_CPU(int, rar_pending) = -1;
+
+static bool get_rar_pending(int target_cpu, int this_cpu)
+{
+	int *this_rar_pending = &per_cpu(rar_pending, target_cpu);
+
+	/* Another CPU is flushing this CPU already. */
+	if (*this_rar_pending != -1)
+		return false;
+
+	/* Is this_cpu the one that needs to send a RAR to target_cpu? */
+	return cmpxchg(this_rar_pending, -1, this_cpu) == -1;
+}
+
+static void release_rar_pending(int target_cpu, int this_cpu)
+{
+	/* If this_cpu sent the RAR to target_cpu, clear rar_pending */
+	if (READ_ONCE(per_cpu(rar_pending, target_cpu)) == this_cpu)
+		WRITE_ONCE(per_cpu(rar_pending, target_cpu), -1);
+}
+
 /*
  * TODO: group CPUs together based on locality in the system instead
  * of CPU number, to further reduce the cost of contention.
@@ -113,7 +140,7 @@ static void set_action_entry(unsigned long payload_nr, int target_cpu)
 	WRITE_ONCE(bitmap[payload_nr], RAR_PENDING);
 }
 
-static void wait_for_action_done(unsigned long payload_nr, int target_cpu)
+static u8 wait_for_action_done(unsigned long payload_nr, int target_cpu)
 {
 	u8 status;
 	u8 *rar_actions = per_cpu(rar_action, target_cpu);
@@ -123,9 +150,14 @@ static void wait_for_action_done(unsigned long payload_nr, int target_cpu)
 	while (status == RAR_PENDING) {
 		cpu_relax();
 		status = READ_ONCE(rar_actions[payload_nr]);
+		/* Target CPU is not processing RARs right now. */
+		if (READ_ONCE(per_cpu(rar_pending, target_cpu)) == -1)
+			return status;
 	}
 
 	WARN_ON_ONCE(rar_actions[payload_nr] != RAR_SUCCESS);
+
+	return status;
 }
 
 void rar_cpu_init(void)
@@ -183,7 +215,7 @@ void smp_call_rar_many(const struct cpumask *mask, u16 pcid,
 {
 	unsigned long pages = (end - start + PAGE_SIZE) / PAGE_SIZE;
 	int cpu, this_cpu = smp_processor_id();
-	cpumask_t *dest_mask;
+	cpumask_t *dest_mask, *apic_mask;
 	unsigned long payload_nr;
 
 	/* Catch the "end - start + PAGE_SIZE" overflow above. */
@@ -213,7 +245,9 @@ void smp_call_rar_many(const struct cpumask *mask, u16 pcid,
 	 * flushes at context switch time.
 	 */
 	dest_mask = this_cpu_ptr(&rar_cpu_mask);
+	apic_mask = this_cpu_ptr(&apic_cpu_mask);
 	cpumask_and(dest_mask, mask, cpu_online_mask);
+	cpumask_clear(apic_mask);
 
 	/* Some callers race with other CPUs changing the passed mask */
 	if (unlikely(!cpumask_weight(dest_mask)))
@@ -225,11 +259,25 @@ void smp_call_rar_many(const struct cpumask *mask, u16 pcid,
 	for_each_cpu(cpu, dest_mask)
 		set_action_entry(payload_nr, cpu);
 
-	/* Send a message to all CPUs in the map */
-	native_send_rar_ipi(dest_mask);
+	do {
+		for_each_cpu(cpu, dest_mask) {
+			/* Track the CPUs that have no RAR pending (yet). */
+			if (get_rar_pending(cpu, this_cpu))
+				__cpumask_set_cpu(cpu, apic_mask);
+		}
 
-	for_each_cpu(cpu, dest_mask)
-		wait_for_action_done(payload_nr, cpu);
+		/* Send a message to the CPUs not processing RARs yet */
+		native_send_rar_ipi(apic_mask);
+
+		for_each_cpu(cpu, dest_mask) {
+			u8 status = wait_for_action_done(payload_nr, cpu);
+			if (status == RAR_SUCCESS) {
+				release_rar_pending(cpu, this_cpu);
+				__cpumask_clear_cpu(cpu, dest_mask);
+				__cpumask_clear_cpu(cpu, apic_mask);
+			}
+		}
+	} while (unlikely(cpumask_weight(dest_mask)));
 
 	free_payload_slot(payload_nr);
 }
-- 
2.51.1


