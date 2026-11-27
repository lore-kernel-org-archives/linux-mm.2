Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C425B606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ImSAllIj
Received: by kanga.kvack.org (Postfix)
	id C3E666B05C6; Fri, 27 Nov 2026 15:14:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEEF36B05C7; Fri, 27 Nov 2026 15:14:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8FAF6B05C8; Fri, 27 Nov 2026 15:14:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7175E6B05C6
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:14:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0436A1C2689
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:14:23 +0000 (UTC)
X-FDA: 85482001248.27.3EF9DDE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id F250412000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:14:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ImSAllIj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810462;
	b=NTpWXG4EyFTQ4c7OLAVKt9HsUnT9/cY6RFD0j+83qLKrT5dgZCQYnK9Erhy5cXNONvmNVA
	IuYjutXUFfXXV2tfMSNUyvUiet6C/UQ6HW6Mol7AKWEzpG5uEZuYhTww4Hf+c0RyEjb+Ze
	q4WbqQqm2gOxknKvtpv4gf6ZJHJkXL0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2OzrTCLFRXHQ5G5PcwdIRVZPS7FUL7CLCrYOZTtcWGo=;
	b=0XJnJPBfqdKNz0gqICan9BLUl5tNJsWJBpeDhcLLbVKaf9TlDgIG4Q1S0cyqnNtpu+/+pa
	+P+I38jlpLYFfTII2IwHOGub/gCy+FjvmdIe7slg+iQY/g8dydhnJ99HIFhaTTyGtx/Kqt
	MnNyEmhu5aC3TdyK1Gu6NsEAH7GSi+M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ImSAllIj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795810461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2OzrTCLFRXHQ5G5PcwdIRVZPS7FUL7CLCrYOZTtcWGo=;
	b=ImSAllIj4C90HpR7KV79g5Bq/dm7J/lFqyUd3wskOFToogn+aBo4ujzN4zeMyNxlFCsQUd
	6U5ZvvHdrAEttUl4yTc5X9QDdXV2dzKzC9yQdDW0T21KBIfE5rZmBG77FbCM7hso2Y25b1
	PaaTTfUd0czWUSDx484nBI3vnF0feNw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-kVyebHtEN6SvC2uM12T_1Q-1; Fri,
 27 Nov 2026 20:14:17 +0000
X-MC-Unique: kVyebHtEN6SvC2uM12T_1Q-1
X-Mimecast-MFC-AGG-ID: kVyebHtEN6SvC2uM12T_1Q_1795810452
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 639931800556;
	Fri, 27 Nov 2026 20:14:12 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4BB7436;
	Fri, 27 Nov 2026 20:14:02 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>,
	Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Dan Beimborn <Dan.Beimborn@qube-rt.com>,
	"Pak Hung Vincent Chiu" <pak-hung.chiu@qube-rt.com>
Subject: [PATCH v10 08/10] x86/mm/pti: Introduce kernel_cr3_loaded
Date: Fri, 27 Nov 2026 21:12:19 +0100
Message-ID: <20261127201221.434876-9-vschneid@redhat.com>
In-Reply-To: <20261127201221.434876-1-vschneid@redhat.com>
References: <20261127201221.434876-1-vschneid@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: 0IKeWDDy52NppXVzewyG6Q3OSDYnMfhx9Oqvpd-QtC8_1795810452
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F250412000A
X-Stat-Signature: 8twz4cn5x5rksxowm5xt8wza79qgehkt
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795810461-509383
X-HE-Meta: U2FsdGVkX18uGmPZSz0jlxnF2UrJAm8zQBpJRdknOaUeJfcvGn0gurCohVNWY7vtkkRP2gqR+f+O82PadXEL/NQyn0B1Yn08zEIDqxYrYPkiEylEz0/YCuBI5RDaXYbSVJ2n33ujKHiIdvfkZN6Bv22w2tDgqzEqZ13a5lsPF/2FIyvOSkeOL7hn1MeKl84rmpGH/ty0v1gLAHQQt6PCG02C5T8XmWGWkOpNiYfvLqaU2T4B5WTnQf2RP+pTEy1IyIvQcUiuQF9kSsfwxvhfeUItD3nnqGpnqEz/IvGCFak8QLo/00WV9pyg++ptbJ9Nc3xwozpXbvucLPtCc8EAfck1J6H+cSfSnnnx+6gmzX+KaxLlajKVdkchEBDKIjwyDM8q51FUSwTTGpH9+muxFcd0RLY+7jY4MjSl5sF/84EGWmzp3CA2ahnfO4REochvaXv29BMWCQxcaqSDws0ViFOfvxECXshjz36GOX2IN0sc/qMUPtIQiseYr2p7UogtFWa7Yn8fC6bmRgRaM5q9L9NMkOJui8IY2lfMnuYefy9tDD6z/D82F9k4Zp67wlNW2UAUomIDEjR+63lYFk3nychIP7XXsGbuIOfnVMUBFHkkCa1EZkKH2Y3NXQ1pnD3mruGOqQKaJZggKMObYJQ+lFlDAmBSw/QkjV0HXqNMHjqpe9F550au7UIFz8S/TDPBrkr0mNH+oQBILWAUmg06en+wmBsg02x0LnhmXvR6AaA4LMEK62mtGI3XE6U2pObKKAFj+JTeGyth94EN5fKau2uA0QlcOe5t03l8RkDqbcMbo9yWMT6+kXU3jcDXYhl0C0f5B0HySkmfiMLZs1HvLCqGB/DZrq9CPsHmY4ZFmR3Xj1i92dP9rIdZrCPizcYRLU55ldhpRBeFfwXN5Ltf7AJyccsaXOQabRXc2iydOkZApqF+3/xX87eRqFR/S+uVtSfkqgjCAIKLEYAfX+o
 dVytFtkH
 4thJdhwoprH9t0sd7gN4HM/d8J+iHonyPv4DnQwpY0axvImU53k+WysyrSuxAC0647Vxk+hVQSR/O2E2mHPW+GXuPeutra9Gl9PDpCfWCoMt0IrtYFV18r/3z3UjUdQdRHlAJiEHNOjCdDGz8FnrhKFLnxSNMT/VQeZOsLl7NJnLvrqRqeasgnzEz9UatjDR7OQm9S2mdeAC0UCEPRVESOt65ZOq9+k6SrSE7gbNeE9Vm46kG/BVLRTDeas0ADhpEIaxV9pvOg+/jnKOsaFXXy2+dUCyxqpTdoNjngEalp6GAvueaq4o0107eoeIA7TgZZc4X2XWc+Bgmu+7uhEd60u04TZQpf5YzCychfIzJoTuezkng72mrMzo2vowRWYkvkXDcsAzVEzSo47xERtRCS+yVxDNGCIttvmW+T6T+MLr2/v5g39G/bXSQOLuF6TRdhTFsEmjycLrFVOFd2YyPM2KRgeKz2BFZt59iiNlM4W5FMmYSDTwtnJO3Kw+rTgEcCQ0RndvIk8CzJpdrs8TTxRAqngC2bro4XHIWdvaZb6LRu2GY49+wG65Bf6sipWmY7wsmcwcCNbb/iNJy0hU1jDSUvAxRA0qZAXmcRMROyWxUe59yybMKThH6P8OTfUzJjrYwUf6hsHAjLsopR5LnZHciXem8euzzPCA28MU51uqEjxrIKAOSg+t5s2syaeTdgVJzTxknkqw3Vo94X4xINKuHBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Later commits will rely on being able to check whether a remote CPU is
using the kernel or the user CR3.

Add a per-cpu variable that will be updated right before switching to the
kernel CR3.

Note that this only adds the backing data, a later commit will drive the
updates.

pcpu access in early entry
==========================

The variable is accessed through two different ways:

1) The general case where swapgs has already been executed, and the usual
   gs-based per-cpu offset is usable. This requires mapping the variable in
   the userspace visible pages, since CR3 hasn't been switched to the
   kernel CR3 yet.
2) The paranoid case where swapgs has *not* be executed, in which case
   a CEA alias is used.

security concerns
=================

That variable does not contain any exploitable data, and being in the
.data..percpu..aligned section it occupies a whole page - that is, as long
as it is not the last variable in that section. AFAICT the last one is
always @entry_stack_storage (which by itself is a whole page), although I'm
not sure if that's a happy accident or if it is actually enforced somehow?

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/include/asm/cpu_entry_area.h |  4 +++
 arch/x86/include/asm/pti.h            | 11 ++++++++
 arch/x86/kernel/asm-offsets.c         |  3 ++
 arch/x86/mm/cpu_entry_area.c          |  5 ++++
 arch/x86/mm/pti.c                     | 40 +++++++++++++++++++--------
 5 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
index 462fc34f13176..e321fd7f50d2b 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -127,6 +127,10 @@ struct cpu_entry_area {
 	 * Reserve enough fixmap PTEs.
 	 */
 	struct debug_store_buffers cpu_debug_buffers;
+
+#ifdef CONFIG_TRACK_CR3
+	atomic_t kernel_cr3_loaded __aligned(PAGE_SIZE);
+#endif
 };
 
 #define CPU_ENTRY_AREA_SIZE		(sizeof(struct cpu_entry_area))
diff --git a/arch/x86/include/asm/pti.h b/arch/x86/include/asm/pti.h
index 88d0a1ab1f77e..142b2d225c5eb 100644
--- a/arch/x86/include/asm/pti.h
+++ b/arch/x86/include/asm/pti.h
@@ -1,12 +1,23 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _ASM_X86_PTI_H
 #define _ASM_X86_PTI_H
+
+#ifdef CONFIG_TRACK_CR3
+#define KERNEL_CR3_IN_USER 0
+#define KERNEL_CR3_IN_KERNEL 1
+#endif
+
 #ifndef __ASSEMBLER__
 
 #ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
 extern void pti_init(void);
 extern void pti_check_boottime_disable(void);
 extern void pti_finalize(void);
+
+#ifdef CONFIG_TRACK_CR3
+DECLARE_PER_CPU_PAGE_ALIGNED(atomic_t, kernel_cr3_loaded);
+#endif
+
 #else
 static inline void pti_check_boottime_disable(void) { }
 #endif
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 081816888f7a0..5ba8d5b791e1f 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -117,6 +117,9 @@ static void __used common(void)
 	OFFSET(CPU_ENTRY_AREA_entry_stack, cpu_entry_area, entry_stack_page);
 	DEFINE(SIZEOF_entry_stack, sizeof(struct entry_stack));
 	DEFINE(MASK_entry_stack, (~(sizeof(struct entry_stack) - 1)));
+#ifdef CONFIG_TRACK_CR3
+	OFFSET(CPU_ENTRY_AREA_kernel_cr3, cpu_entry_area, kernel_cr3_loaded);
+#endif
 
 	/* Offset for fields in tss_struct */
 	OFFSET(TSS_sp0, tss_struct, x86_tss.sp0);
diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index 575f863f3c75e..a8c3381432a57 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -202,6 +202,11 @@ static void __init setup_cpu_entry_area(unsigned int cpu)
 			     per_cpu_ptr(&entry_stack_storage, cpu), 1,
 			     PAGE_KERNEL);
 
+#ifdef CONFIG_TRACK_CR3
+	cea_map_percpu_pages(&cea->kernel_cr3_loaded,
+			     per_cpu_ptr(&kernel_cr3_loaded, cpu), 1,
+			     PAGE_KERNEL);
+#endif
 	/*
 	 * The Intel SDM says (Volume 3, 7.2.1):
 	 *
diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index 598f553cc8713..69c03acceb1de 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -446,6 +446,22 @@ static void __init pti_clone_p4d(unsigned long addr)
 	*user_p4d = *kernel_p4d;
 }
 
+static void __init pti_clone_percpu(unsigned long va)
+{
+		phys_addr_t pa = per_cpu_ptr_to_phys((void *)va);
+		pte_t *target_pte;
+
+		target_pte = pti_user_pagetable_walk_pte(va, false);
+		if (WARN_ON(!target_pte))
+			return;
+
+		*target_pte = pfn_pte(pa >> PAGE_SHIFT, PAGE_KERNEL);
+}
+
+#ifdef CONFIG_TRACK_CR3
+DEFINE_PER_CPU_PAGE_ALIGNED(atomic_t, kernel_cr3_loaded) = ATOMIC_INIT(KERNEL_CR3_IN_KERNEL);
+#endif
+
 /*
  * Clone the CPU_ENTRY_AREA and associated data into the user space visible
  * page table.
@@ -456,25 +472,25 @@ static void __init pti_clone_user_shared(void)
 
 	pti_clone_p4d(CPU_ENTRY_AREA_BASE);
 
+	/*
+	 * This is done for all possible CPUs during boot to ensure that it's
+	 * propagated to all mms.
+	 */
 	for_each_possible_cpu(cpu) {
 		/*
 		 * The SYSCALL64 entry code needs one word of scratch space
 		 * in which to spill a register.  It lives in the sp2 slot
 		 * of the CPU's TSS.
-		 *
-		 * This is done for all possible CPUs during boot to ensure
-		 * that it's propagated to all mms.
 		 */
+		pti_clone_percpu((unsigned long)&per_cpu(cpu_tss_rw, cpu));
 
-		unsigned long va = (unsigned long)&per_cpu(cpu_tss_rw, cpu);
-		phys_addr_t pa = per_cpu_ptr_to_phys((void *)va);
-		pte_t *target_pte;
-
-		target_pte = pti_user_pagetable_walk_pte(va, false);
-		if (WARN_ON(!target_pte))
-			return;
-
-		*target_pte = pfn_pte(pa >> PAGE_SHIFT, PAGE_KERNEL);
+#ifdef CONFIG_TRACK_CR3
+		/*
+		 * The entry code needs access to the @kernel_cr3_loaded percpu
+		 * variable before the kernel CR3 is loaded.
+		 */
+		pti_clone_percpu((unsigned long)&per_cpu(kernel_cr3_loaded, cpu));
+#endif
 	}
 }
 
-- 
2.56.1


