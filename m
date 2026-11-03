Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF75606A33E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cmI9Krf0
Received: by kanga.kvack.org (Postfix)
	id 16E026B05B3; Mon,  2 Nov 2026 20:26:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1DE6B05B4; Mon,  2 Nov 2026 20:26:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D016B05B5; Mon,  2 Nov 2026 20:26:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B53506B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:26:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EBCF160336
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:26:57 +0000 (UTC)
X-FDA: 85392068874.25.DD12CAF
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8909040002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:26:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cmI9Krf0;
	spf=pass (imf11.hostedemail.com: domain of 3XTjpaggKCNAx49254wA2AA270.yA8749GJ-886Hwy6.AD2@flex--bingjiao.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3XTjpaggKCNAx49254wA2AA270.yA8749GJ-886Hwy6.AD2@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793669215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7D6YYqUkQHDitGcevsXkUUkt65mK09YII27r9MSsFk=;
	b=eQBpeIBIM+Hmt+Mwzr8k9l45tYR/mJqBaYKVeYb5+ruf57cUwiyc+7MkQCAtuR6uuDdwxC
	5wBm7SqvD9E6hRGZZYN1XabyOScUvCXKCI7LUqF2PFy4iJmxEcl1ftkgQ0+vUqm/FRmbvQ
	lgtnUF2/ugmQxB6POVv6sACmupB3CNg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cmI9Krf0;
	spf=pass (imf11.hostedemail.com: domain of 3XTjpaggKCNAx49254wA2AA270.yA8749GJ-886Hwy6.AD2@flex--bingjiao.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3XTjpaggKCNAx49254wA2AA270.yA8749GJ-886Hwy6.AD2@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793669215;
	b=2HdfQilRNEE37o4QCdqy78FQ6D6xwXHjKHD6ThhKhARU1iwsYiiLwsxZjN8Y9mt+g/Dkx+
	6dfIev4rV4kx6qobZ47TqnpjB6Vzrje3m3HAAO1FKlYiABisEPjOOmT1O03kr6iVbweSk8
	m5O+Su8oSrpi3WWJ2nhi0jEAk82Mu18=
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3552883bd19so4712134eec.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793669214; x=1794274014; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T7D6YYqUkQHDitGcevsXkUUkt65mK09YII27r9MSsFk=;
        b=cmI9Krf0KQkl32HIsb78YqsNRrQBtFp19JoDnhlxw5w9gTSSRWf5NHRVwSFa4Dt/T6
         PMJb7eYm0VhhnIbS6Takc69WmIhlTXlan/okawnNqZtTOJOR0NYmWxs4DmXCIx5w2nlu
         XGEujYEdwGbB/yaNWN7E5weH6QXDEzGPUjndsAnSSLgQ7ghGTWYmu17CLscKCQGezWRo
         NoNzYfwEkd8cGIOpWBpkug1WXe73EpEknRFKktY/kAkmrx4qTF0bIDGJ5xT+AudnI/ZE
         pEw2YkaUrqJNghbg0T9EMOhu5/mM6kUOLvMtXIi7RtlF9VKY035DOm5iPKIp6MIX/c4V
         84fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793669214; x=1794274014;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T7D6YYqUkQHDitGcevsXkUUkt65mK09YII27r9MSsFk=;
        b=OeaV1IKlAZ6UTCerK1SPmNjerXQv1GyWs5yQXbcoGvWAggteGwXyGzsB/fDBNz5xgJ
         OSYq+up6sPaJ0ypr/d9ciq68IIjuBJ5QNFvEVp+jw1wSa871CL0oT7Fx3Zyn3fYd1auL
         bZZ35N6mzxRqq+wwXABACs7g1l1/sk/p9aFXiFbprlPJ6UuJPnhofsY/mGEFNatUFUZ2
         5x2I/myspDUkQRK4Ca+MCNnx4CqOdEzmCcs1crBQtGXbf191HEnE1eVgWe5kNnVKtf6c
         HqtdKYOjIEoUnXwaSLb8zDUfI7vykIGKh0bbwc3N4ii96Gnkgd/qW/MJwVXQ0DqAieyh
         /5IQ==
X-Forwarded-Encrypted: i=1; AKwUvBxsNuODJ5YatiGAdpjji+KFTNbzuW/CNcRDrHJ8HrppqN3k6UIiK2h4q0jUzmy978eKWlacXdix+w==@kvack.org
X-Gm-Message-State: AFq9FYJsQkEvaA4lKfYlAAUQ02m7iZ1aehCcYqI3uSpKG8n7BemOlaBm
	pKa1HuO7zBL5Oo+A06VtTuAvuqiAgLhRSko6NYqK9FfDSq5/xHHLBISLYxORYgaYRTswCGBjt1f
	6AGR80gUSOAf7PA==
X-Received: from dldz2-n1.prod.google.com ([2002:a05:701b:4182:10b0:1a1:da78:f9b9])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:f90c:b0:14f:505d:813 with SMTP id a92af1059eb24-1ac5cb195a0mr16787382c88.41.1793669213882;
 Mon, 02 Nov 2026 17:26:53 -0800 (PST)
Date: Tue,  3 Nov 2026 01:26:26 +0000
In-Reply-To: <20261103012626.2699661-1-bingjiao@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103012626.2699661-1-bingjiao@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103012626.2699661-3-bingjiao@google.com>
Subject: [RFC PATCH 2/2] x86/mm/tlb: Skip stale and lazy CPUs in arch_tlbbatch_flush()
From: Bing Jiao <bingjiao@google.com>
To: x86@kernel.org, linux-mm@kvack.org, 
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Bing Jiao <bingjiao@google.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@surriel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Huang Ying <ying.huang@linux.alibaba.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Chuyi Zhou <zhouchuyi@bytedance.com>, 
	Xie Yuanbin <qq570070308@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: djqug4rsada55cy5b5ow9huay1i1jyxp
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8909040002
X-HE-Tag: 1793669215-801141
X-HE-Meta: U2FsdGVkX19mG91aOgC+c1SpiNHJEbC6oOOsQ1hSBy33SbKX44rHRfR/Vw40DhHdtHf1AZThpSlzXYfDkCLYeet8e9F6HS0U6PTnphKVgfelM9s2oUYSvkrxnUK7eY83O+FHdqMhruYB4DtZUxoM2nXT+/IeNe7QS1PUARX1Aim+7h5Xq3Wutw2UDdddafdl2HFgOgu35gPVvIIY4NjD5l/eqTz+sgwMeox1mF0SaVdbVQEbvPGOP3kC0hFljNDG9K1ZBNyXX9NFIdzxlk1RrnxHBaNKynzDWibMzr/el/07qcs/tzY/plTKkicf7ij8EUXDah/NvbpKprJ5AUkWWLnwExFJs7T1Uy/MuoCosNBBT5IlGA1muAgJBtjw7Ek2Be4dtiX0FRofPP79PAWrjChGnhNhXcbdvF5KKXdruuI5lBZ3dZRli3UvDJ+LdGbjXcZq2J96W10Cc/IJkLlyf7dUKbXtZQ7lW4Y5pfiqlOkk8Df0auTerGwK4beERYF/JCG4d8aCJ07JrHnf0ElkqwhHG0wjE/QAIHyqcxKS698FXNZOaFTG0gG+lBquqQaxmLrDqlfvYv7l8lhtXaLyruXarhkjAiCbfRIzo3wZc9du8C6La08crCRjff73UPtfkh4iwE4uhcqwgqh2JN3e8meSBaZXTTvs/O2Cd3PT4P+u67Y/mFGSgmEUW0AIJ2no5kq2HzwAx0Po2i/rJn8cGx3pAGFfVUdM3h1lk6UOH57jz8epY/2YAoY25hJO0L2MX2wonfWmqczyFsHUfuRpPos3a1XnyMOnCBzgiOQdeKl2OFdOhIHBMEzylXCL5SaJ1zMz+Uq88LMHd1H7eCjgczNnWa2LlMjOyZvXoBBTyDuQAbW5mSAZPFe2sUwJKJUhKhMlt17AaIoNInfZ0vwzMAEKbzKwTXAsEyJin5Sp6YtxhwAdIE3Xrx9rvGnFbP4zC/yirQFY0SOdw0MUwS1
 oT07JPiz
 ilrGiJp5GomrrECTLRl+kMJ0WNRORnZgBEhRvAISeuJOONw2GF0nAuWNWpOrBsuH2bYwdVgbKWf+urAZhioq0N6dTZfWpnsIHbHCQwLi0ohmIg6UvGOPzWs9plffnSDzgXpupJJnavu1+Lb+N4iP07kUzE3Ue97LFPRPrYJAyflnsoO6c8zoqofX5UX0fNV8FQG0+aY+43mEQnSQDJbHJC+OLVs73lWOKp3F05cC5Zju2LNXqDj5rExKlCjxIAZL3K84eB5BtlCd6J72rx29AppkiXB3F5LHq/PbeKAZyNJ9My9baX+lb+bus3LYrqtw/1jYiHfEsFBBwyY+po1CEMb7HqDFhaIGDzGYAQLChzXIoAh5mIVIee0DcXIE3f6eSi7415ffRlUANTAfhava+k6P+Crde9UQrkp8tVeScwgkiECET600VP9K0RDk3Qp6ScMP9uImaysDjNy7HEIluix7U0HXqckMa2d9GgJPYJ9Pbz3gOH5iAIhuK2ozka8nEGURRt9ydBnayWDQOZsITSDj+Kd4DwnW3Tf8oknL+qSYaQwDGSXbQ1iGRf9GVBcyyEw4ms2Ewtmv7Q2uh/BGmCyeOvjoymI8T5VEeKKF+bnlHOTMMZhDLuNpV0U+Cubtkt/3zapqKtfNCWrA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 209954cbc7d0 ("x86/mm/tlb: Update mm_cpumask lazily") and
commit 6db2526c1d69 ("x86/mm/tlb: Only trim the mm_cpumask once a second")
stopped clearing outgoing CPUs from mm_cpumask(prev) on context switch.
For per-mm flushes, should_flush_tlb() skips CPUs where loaded_mm !=
info->mm, and flush_tlb_func() periodically trims stale bits from
mm_cpumask(f->mm).

Batched TLB flushes used by page reclaim, migration, and page demotion do
not benefit from this. arch_tlbbatch_add_pending() ORs the full
mm_cpumask(mm) into batch->cpumask, and arch_tlbbatch_flush() calls
flush_tlb_multi() with info.mm = NULL because a batch can span multiple
mm_structs. With !info->mm, should_flush_tlb() returns true for every
non-lazy CPU, and flush_tlb_func() cannot clear stale bits from
mm_cpumask(mm). As a result, every batch repeatedly sends IPIs to all
CPUs where the process previously ran if they are now running other
userspace tasks.

To fix this, record up to ARCH_TLBBATCH_MAX_MMS (8) unique mm_struct
pointers in arch_tlbbatch_add_pending() and filter batch->cpumask once
per batch in arch_tlbbatch_flush() via should_flush_tlb_batch(). Keeping
the array at 8 entries fits within a single 64-byte cache line in
task_struct->tlb_ubc, and batches spanning more than 8 mms fall back to
the unfiltered cpumask.

Tested on 112-CPU Intel Skylake, 384-CPU AMD EPYC Genoa, and 512-CPU AMD
EPYC Turin with CXL memory, all using IPI-based TLB shootdowns (5-run
mean). Following the setup in commit ed15468787dd ("x86/mm: Move
flush_tlb_info back to the stack") and commit 7e12beb8ca2a
("migrate_pages: batch flushing TLB"), a task with all CPUs set in its
mm_cpumask runs on 1 CPU (2 CPUs in test 4) while the other CPUs run
unrelated userspace tasks:

1. Pageout reclaim (81,920 4K pages reclaimed to zram):

   Platform          Metric        Baseline       Patched        Change
   --------------------------------------------------------------------
   112-CPU Skylake   Remote IPIs   9,092,156          191       -99.99%
                     Time (ms)       2,974.6        763.0  -74.3% (3.9x)
   384-CPU Genoa     Remote IPIs  31,377,184          157       -99.99%
                     Time (ms)       1,652.6        483.1  -70.8% (3.4x)
   512-CPU Turin     Remote IPIs  41,859,670          119       -99.99%
                     Time (ms)       1,695.7        476.3  -71.9% (3.6x)

2. Page demotion (81,876 4K pages demoted from top-tier to CXL):

   Platform          Metric        Baseline       Patched        Change
   --------------------------------------------------------------------
   512-CPU Turin     Remote IPIs     958,699          526        -99.9%
                     Time (ms)         213.0        168.2        -21.0%

3. Single-threaded move_pages() (331,600 4K pages migrated):

   Platform          Metric        Baseline       Patched        Change
   --------------------------------------------------------------------
   112-CPU Skylake   Remote IPIs      73,370        4,964        -93.2%
                     Time (ms)         702.4        699.7         -0.4%
   384-CPU Genoa     Remote IPIs     252,899       13,899        -94.5%
                     Time (ms)         392.4        347.1        -11.6%
   512-CPU Turin     Remote IPIs     337,426       18,193        -94.6%
                     Time (ms)         370.1        368.1         -0.5%

4. Multi-threaded migrate_pages() + active memory access (656,940 4K
   pages migrated, 2 active threads):

   Platform          Metric        Baseline       Patched        Change
   --------------------------------------------------------------------
   112-CPU Skylake   Remote IPIs     144,610        3,362        -97.7%
                     Pages/sec       386,385      391,050         +1.2%
   384-CPU Genoa     Remote IPIs     493,035        7,730        -98.4%
                     Pages/sec       673,166      725,680         +7.8%
   512-CPU Turin     Remote IPIs     658,193        9,685        -98.5%
                     Pages/sec       670,288      733,020         +9.4%

Fixes: 209954cbc7d0 ("x86/mm/tlb: Update mm_cpumask lazily")
Fixes: 6db2526c1d69 ("x86/mm/tlb: Only trim the mm_cpumask once a second")
Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 arch/x86/include/asm/tlbbatch.h | 14 +++++++++++++
 arch/x86/include/asm/tlbflush.h | 16 ++++++++++++++-
 arch/x86/mm/tlb.c               | 36 +++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tlbbatch.h b/arch/x86/include/asm/tlbbatch.h
index 80aaf64ff25f..aac4fc5cba3a 100644
--- a/arch/x86/include/asm/tlbbatch.h
+++ b/arch/x86/include/asm/tlbbatch.h
@@ -4,12 +4,26 @@

 #include <linux/cpumask.h>

+struct mm_struct;
+
+#define ARCH_TLBBATCH_MAX_MMS	8
+
 struct arch_tlbflush_unmap_batch {
 	/*
 	 * Each bit set is a CPU that potentially has a TLB entry for one of
 	 * the PFNs being flushed..
 	 */
 	struct cpumask cpumask;
+
+	/*
+	 * Unique mm_struct pointers unmapped in this batch. Used only for
+	 * pointer equality against per-CPU loaded_mm in arch_tlbbatch_flush()
+	 * and never dereferenced there. nr_mms > ARCH_TLBBATCH_MAX_MMS
+	 * indicates overflow.
+	 */
+	struct mm_struct *mms[ARCH_TLBBATCH_MAX_MMS];
+	unsigned short nr_mms;
+
 	/*
 	 * Set if pages were unmapped from any MM, even one that does not
 	 * have active CPUs in its cpumask.
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 4ec71ea0943f..0e86ade83ebc 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -379,8 +379,22 @@ static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *b
 		struct mm_struct *mm, unsigned long start, unsigned long end)
 {
 	inc_mm_tlb_gen(mm);
-	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
+	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB)) {
+		unsigned short i, nr = batch->nr_mms;
+
 		cpumask_or(&batch->cpumask, &batch->cpumask, mm_cpumask(mm));
+
+		if (likely(nr <= ARCH_TLBBATCH_MAX_MMS)) {
+			for (i = nr; i > 0; i--) {
+				if (batch->mms[i - 1] == mm)
+					goto out;
+			}
+			if (likely(nr < ARCH_TLBBATCH_MAX_MMS))
+				batch->mms[nr] = mm;
+			batch->nr_mms = nr + 1;
+		}
+	}
+out:
 	batch->unmapped_pages = true;
 	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
 }
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 0c4da320831c..10b8e839e964 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -1679,12 +1679,48 @@ void __flush_tlb_all(void)
 }
 EXPORT_SYMBOL_FOR_KVM(__flush_tlb_all);

+static bool should_flush_tlb_batch(int cpu,
+				    const struct arch_tlbflush_unmap_batch *batch)
+{
+	struct mm_struct *loaded_mm = READ_ONCE(per_cpu(cpu_tlbstate.loaded_mm, cpu));
+	unsigned short i;
+
+	if (loaded_mm != LOADED_MM_SWITCHING) {
+		for (i = 0; i < batch->nr_mms; i++) {
+			if (loaded_mm == batch->mms[i])
+				goto check_lazy;
+		}
+		return false;
+	}
+
+check_lazy:
+	/*
+	 * Order 'loaded_mm' and 'is_lazy' against their write ordering in
+	 * switch_mm_irqs_off(). Ensure 'is_lazy' is at least as new as
+	 * 'loaded_mm'.
+	 */
+	smp_rmb();
+
+	return !READ_ONCE(per_cpu(cpu_tlbstate_shared.is_lazy, cpu));
+}
+
 void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 {
 	struct flush_tlb_info info;
 	bool remote_flush = false;
 	int cpu = get_cpu();

+	if (likely(!cpu_feature_enabled(X86_FEATURE_INVLPGB) &&
+		   batch->nr_mms && batch->nr_mms <= ARCH_TLBBATCH_MAX_MMS)) {
+		int target_cpu;
+
+		for_each_cpu(target_cpu, &batch->cpumask) {
+			if (!should_flush_tlb_batch(target_cpu, batch))
+				__cpumask_clear_cpu(target_cpu, &batch->cpumask);
+		}
+	}
+	batch->nr_mms = 0;
+
 	init_flush_tlb_info(&info, NULL, 0, TLB_FLUSH_ALL, 0, false,
 			    TLB_GENERATION_INVALID);
 	/*
--
2.56.0.385.gac671c819a-goog


