Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8E20CD3439
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C1BC6B00EC; Tue,  5 May 2026 12:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 198C56B00ED; Tue,  5 May 2026 12:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0616B6B00EE; Tue,  5 May 2026 12:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4C9D6B00EC
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:08:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8789C120560
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:45 +0000 (UTC)
X-FDA: 84733849410.29.7BCF368
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9DB4418000F
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=X6x3WfuV;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emygvYxhkWsqMuM5q9K6kqLmMjPTQyXSCWgwyuJaPJY=;
	b=gMAOLIjVB1Jyh2V0jczklVFxFlV0lQ3rqcDMlQJXziJg6ofpBPioj/+lgkJx9MQPUe8zva
	4cKrAkdCGMb86aaUdIhaNXdoflN3h9R+9wbERCPU7gkEJyhtt2jaiK2j04P32T86Ek6Vi3
	zK7tsvVAc0JNn17pT3LXVjcrhzTk7bs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997323; a=rsa-sha256;
	cv=none;
	b=yKNlyW+BMnmn2DFtEm4/to84DaMHUqViW+M2J7O4h95Cc85xc/an1uo+wQoLht4D351BGV
	rsC1hAbuFG7WJGuuXDnXnWlvC8i8D4dzwcqTRtq99ftOJqBSXn3eU5lMd19MNrcbDje2kR
	v4wNV+u1rZFL8lMjObWZfcqcyx7ozPM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=X6x3WfuV;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78F252681;
	Tue,  5 May 2026 09:08:37 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B442D3F763;
	Tue,  5 May 2026 09:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997322; bh=f+o3e9jzGdoDfuO+adnmSdYfcmQjcKxMxDU6OWrV3wo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=X6x3WfuVRAyqbywkdsGnl0sui3YNIg5jFtn36geeq5uIEHXTnZmlVP54JVQL0nTMi
	 l0h3QOXe0Y9H0WSc0BT3GMN+z99Q9Y04Vj9LsR0A4OVhSv9K9aGgc1CFyI6h+Ju+Nm
	 DwVPp+3fY4/FMQY8kOZlG2ej8NT0JNEYj+KaczZg=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:06:11 +0100
Subject: [PATCH RFC v7 22/24] arm64: kpkeys: Batch KPKEYS_CTX_PGTABLES
 switches
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-22-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=4465;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=f+o3e9jzGdoDfuO+adnmSdYfcmQjcKxMxDU6OWrV3wo=;
 b=PPAeqK+xR0TL5xmJOHSr96gQ6oYWuWxUNLJ9UTPTSIBd6v9as7uP3u6NrAS0h5F6THC0xVx9N
 xbLQf16NKwrCBNePl8I/XEO8e4jgpt7i+z5HiRQG9jpr65qSQ2+dILS
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DB4418000F
X-Rspamd-Server: rspam04
X-Stat-Signature: nm3whm1q7y6w19k3d77fdmy5e9iahx98
X-HE-Tag: 1777997323-697870
X-HE-Meta: U2FsdGVkX195pWPvvml5lKXFj1PIHwng1aQOljVE2ofLjhavjVtBJMSHqMWsG0j77TeZPmUyU+oSoIZ60A0ltLCayMCd4gVylfqCKDTfbUQcDek0LOmahWX5E8oQuthPOW8ICtkLf45t4Ciw//EuV5e9HLRpWBHwxJuS6hRIisN46gVNyH8wy++FOw97sQ8E3hZ9K4PKvK4mx8etsISumdK48LUrbHxuvQsJ2zipFBKyUfqHM9vSwo3HxWPsLFLOF2ugjWZDqPMf7KdX2ozH0uC0WFPrbFh3qtYn0PYI4YvXF6PLuxwRnohSXihX7CMWueElCKXMkt4ofhjd5ux/Zje1JCMgwkNNac+llYUa3vasc09ooqCtFpR7i8i8OEoJrpcZukTy07SlUNZ1YSh3xKYB4s4fswMfW4kE2caw1SMW2NOeHQWPF5ZClV4ARFu7zbvyNxxD6Lf1MWzmcsyVPmoxUgNukBrhwDf4PbHn9uxslP1iPcdNJTeDVAvAWLOq3WwXX4w/fLN66hvcGAz5A3iflGfPJBRIV7zTkBycOMUcm/8Qvh4s3pTqWJK2yBSvg0LB0N6d0cqF8KIisjj0VM1o2/1lbT8JkG9QVYF5Ip8ulUZv1CZFjmyhdaYtu9LGclhYh0H0Vs4BEXfLU/pHcQUuaJ+dF8LPWd6b9NP+ZCy8PNzuYr51khB6TYXIlNlxvjw760DekMuwRHhbeQ61u7u5e4dU/1yzRZd+fN4+gBu79EWPBcJo5oxlUfcMmUN1vyMsu7f+LUKtzgQPwWJA42aWQcvuhblipqKpEc8xezUIFoWKejWfTS8a5nIFzR4VL5zjxutoMa1Zqdfqj07/GQs7Z9SBq8dnJSgEaPwp1sL7b/NXaeth0K8Qi6amIzdLpJ9Cf99CdsLRQ9nWl+w8mLMxoyGTZ25kWeMrcpGz3T/kuyD3mfu9m73VbQmWa0pnZ3UB/UY9LRjOvorQSjh
 Oou/h1AT
 1r+WUUxWq50L4vRRCGVTiDmtUAcB53hV9D6Z+RqLqo0vpEwCsBuLwmbkknueMrjNKHuQ2RPB4DoyGwDDZLSRvzxiZ68LUYZ1q2+j+3bpiwz9SzycLyCgWjWFtF9WW1fRk/inocMpCi4Iuo4CPAu/Ky9FaEHTmE1caU0mzwtfjro5Ol/8bOyYTM5qzCOHu8E1HUrf7wL5mm4Co3tl896bVsBwcFRslaw9EPMe5nhI06cOWHaV1xTFF8jzRlxMAIwHPJ8XwwW5LgzQGPlVElr7UFzomGstNqDYFTxlihaGXrF9XSpY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kpkeys_hardened_pgtables feature currently switches kpkeys
context in every helper that writes to page tables, such as
set_pte(). With kpkeys implemented using POE, this entails a pair of
ISBs whenever such helper is called.

A simple way to reduce this overhead is to make use of the lazy MMU
mode. We amend the kpkeys_hardened_pgtables guard so that no kpkeys
context switch (i.e. POR_EL1 update) is issued while the lazy MMU
mode is active. Instead, we switch to KPKEYS_CTX_PGTABLES when
entering the lazy MMU mode, and restore the previous context when
exiting it.

Restoring the previous kpkeys context requires storing the original
value of POR_EL1 somewhere. This is a full 64-bit value so we cannot
simply use a TIF flag. There is no straightforward way to reuse
current->thread.por_el1 for that purpose - this is where the current
value of POR_EL1 is stored on a context switch, i.e. the value
corresponding to KPKEYS_CTX_PGTABLES inside a lazy_mmu section.
Instead, we add a new member to thread_struct to hold that value
temporarily. This isn't optimal as that member is unused outside of
lazy MMU sections, but it is the simplest option. Nesting of
sections is not a concern as arch_{enter,leave}_lazy_mmu_mode() are
not called in inner sections (nor do we need to do anything there).

A further optimisation this patch makes is to merge the ISBs when
exiting lazy_mmu mode. That is, if an ISB is going to be issued by
emit_pte_barriers() because kernel pgtables were modified in the
lazy MMU section, we skip the ISB after restoring POR_EL1. This is
done by checking TIF_LAZY_MMU_PENDING and ensuring that POR_EL1 is
restored before emit_pte_barriers() is called.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h   | 50 +++++++++++++++++++++++++++++++++++---
 arch/arm64/include/asm/processor.h |  1 +
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 20072f32677d..1c0dcfd14678 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -43,10 +43,44 @@
 
 #ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
 KPKEYS_GUARD_COND(kpkeys_hardened_pgtables, KPKEYS_CTX_PGTABLES,
-		  kpkeys_hardened_pgtables_enabled())
-#else
+		  kpkeys_hardened_pgtables_enabled() &&
+		  !is_lazy_mmu_mode_active())
+
+static void kpkeys_lazy_mmu_enter(void)
+{
+	if (!kpkeys_hardened_pgtables_enabled())
+		return;
+
+	current->thread.por_el1_lazy_mmu = kpkeys_set_context(KPKEYS_CTX_PGTABLES);
+}
+
+static void kpkeys_lazy_mmu_exit(void)
+{
+	u64 saved_por_el1;
+
+	if (!kpkeys_hardened_pgtables_enabled())
+		return;
+
+	saved_por_el1 = current->thread.por_el1_lazy_mmu;
+
+	/*
+	 * We skip any barrier if TIF_LAZY_MMU_PENDING is set:
+	 * emit_pte_barriers() will issue an ISB just after this function
+	 * returns.
+	 */
+	if (test_thread_flag(TIF_LAZY_MMU_PENDING))
+		__kpkeys_set_pkey_reg_nosync(saved_por_el1);
+	else
+		arch_kpkeys_restore_pkey_reg(saved_por_el1);
+}
+#else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 KPKEYS_GUARD_NOOP(kpkeys_hardened_pgtables)
-#endif
+
+static void kpkeys_lazy_mmu_enter(void) {}
+static void kpkeys_lazy_mmu_exit(void) {}
+#endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
+
+
 
 static inline void emit_pte_barriers(void)
 {
@@ -79,7 +113,10 @@ static inline void queue_pte_barriers(void)
 	}
 }
 
-static inline void arch_enter_lazy_mmu_mode(void) {}
+static inline void arch_enter_lazy_mmu_mode(void)
+{
+	kpkeys_lazy_mmu_enter();
+}
 
 static inline void arch_flush_lazy_mmu_mode(void)
 {
@@ -89,6 +126,11 @@ static inline void arch_flush_lazy_mmu_mode(void)
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
+	/*
+	 * The ordering should be preserved to allow kpkeys_lazy_mmu_exit()
+	 * to skip any barrier when TIF_LAZY_MMU_PENDING is set.
+	 */
+	kpkeys_lazy_mmu_exit();
 	arch_flush_lazy_mmu_mode();
 }
 
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 6095322343fc..c3a86ddce637 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -193,6 +193,7 @@ struct thread_struct {
 	u64			tpidr2_el0;
 	u64			por_el0;
 	u64			por_el1;
+	u64			por_el1_lazy_mmu;
 #ifdef CONFIG_ARM64_GCS
 	unsigned int		gcs_el0_mode;
 	unsigned int		gcs_el0_locked;

-- 
2.51.2


