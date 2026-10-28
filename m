Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C53606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=aQdsKYio
Received: by kanga.kvack.org (Postfix)
	id 7EC0F6B05BD; Wed, 28 Oct 2026 06:09:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C38D6B05BE; Wed, 28 Oct 2026 06:09:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9C76B05BF; Wed, 28 Oct 2026 06:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 432E76B05BD
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:09:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C82A440C35
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:09:45 +0000 (UTC)
X-FDA: 85371613530.23.3BD583B
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf20.hostedemail.com (Postfix) with ESMTP id B846D1C000B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:09:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=aQdsKYio;
	spf=pass (imf20.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793182184;
	b=6Zo68wDfv1N0mZElWMKc/DuSV5czgQ1eqH8M6XF+DC+xDRPo3noMBzgTomW2xG3zAc/pyz
	smLv9VIzwYsPMWATuORmzsKfyU3lEhgjAZ0J/zD351UyTLBF17zeehzhbMVknz2IvgVg22
	7CDt3jYtmCrqrzdsDn5ZwPSRdmmcFUE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=aQdsKYio;
	spf=pass (imf20.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793182184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaAMBt0M7fytje9obiSckvadBN7geaFIvY0a1pcfao4=;
	b=OOHLUIF9tSZzbmpYJ9Q8RJ0dFzlPHnLIY9ddkKpxO6DiIhDoVagFDMpK1TW9Ijljfvav5x
	TUwdWSGp+D8ssv4breJzSOk9dQiijv5xTPHSmHjmiy/fMHYzW+I8g+ll0siXqTD8KHjUKD
	CHjEV/wLCcU44UqXQG7lZSck4wCyQXA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UaAMBt0M7fytje9obiSckvadBN7geaFIvY0a1pcfao4=; b=aQdsKYioEr2aA2SwuXtgLyM/5V
	nyI0IDg18Ebu43Pw1O4XgYUobzzrxAr0WGm2xqzvY5Kej9AG/rxD82tkbNQPnRutTmZti2SNJrY9d
	vzy9ulDV1doBYEZAd4L3N080Q3GUoDjji7kirsCzbCYSZQXrycwYwfg1DdAr8fk0ZAnGAYUphh7GN
	3XMVnPXMsN6rApoqCm7T341tCDnDEtUX1K5h357Czru1dO4Zqo551ubcqCkdExIsgfU0XWCdgeDHz
	lGJLenI1vcf/OwGqoEKAzU9r1ozKSe4NWWhOukb92cPn+qgFwrCS4+PkWJ6m6EUvS1Hx+r/FVF8iI
	sB2oizzw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM0b6-0000000FsBy-14Sc;
	Wed, 28 Oct 2026 10:09:32 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 340BC30120E; Wed, 28 Oct 2026 11:09:30 +0100 (CET)
Date: Wed, 28 Oct 2026 11:09:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
	gourry@gourry.net, mgorman@techsingularity.net, mingo@redhat.com,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com,
	donettom@linux.ibm.com, xin@zytor.com, hpa@zytor.com,
	luto@kernel.org, tglx@kernel.org, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, jgross@suse.com,
	boris.ostrovsky@oracle.com
Subject: [RFC] x86: Remove CALL_FUNCTION_VECTOR
Message-ID: <20261028100930.GP2668564@noisy.programming.kicks-ass.net>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728054356.291998-8-bharata@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728054356.291998-8-bharata@amd.com>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-Rspam-User: 
X-Rspamd-Queue-Id: B846D1C000B
X-Stat-Signature: op3rw865w15d9c39yg5isu9d9wipyec6
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793182183-768763
X-HE-Meta: U2FsdGVkX18eodwphvdahQP0LXQYFosH+bjYndFWWzXFO4l72Tac+LIejCPrs8DeQLFCarzgl9kJAFWWZ2p2LjgTr0dwe6B7TxjrzERCaNBxYHEdXGVUM7QgteAeKd73lzyTW2XT9nrnpQ4dvwB4DCOsMwrXQy3TkIKFP5fRF53VFs3Tba+30bdesHKiMrTTRfmEM1cfHKgoBeSZE2asx2T5Ki0yKDnmj3iy2so6X3C/Saq8e2Pz85V6n8a8IEmy8Y7g9PWPhyAgB6U0Uh+INL5SKx+xLqPMAHmhFgWw+3/MdXbAfLUnAjamNVvcAd8iJoTvQiy2aYZQsMMj4vmOAjiVwicHTGSRjFSPD+/fpk1AdRxcPb0gD2rw5DOZ6QZaZl0JQy3N/we2vYLYoiH3BGU1BoD+VfndteiLiUs1Nh26/fuWMPnPL2EJx0IbNj4Vl0/Yxk3kWcsamTesmHXbaYTAjAQoYlzYvoMoqVqtOqZf64VthWu80joXGaqwF0zcEwa+7R/ZVeLoD9lPBzPLzTmp1xLgiGylZUeMiSAGcQT5Xah7kEw3RsPKFaw70oJvILCRQbehr6ShO7wlrabnZ1iNFXYwNEh3tCzvc3hCSW5+qcx675LXxxlE9X0is2nXUy80TQBGDPQcvdyT+Mc0sFnQbVlHxjHdir7MVB/ZvGgfs8gf84pLEwBEBejb2PGVaoe4QXn9FDh4lwp/Ot+D5HfjIJHhDrZuqLdhlb1V/sHyj7V4VboLzQFbarlLqgIIqsDScaMh8XCQrYMNaf6BEvHFwj9Qj3rhLKOeXyJqrJKvzUx6AlNsWzsHTJaB7IX+/1hCevl1GD9zWzFfw//isIHh8hhh+P9KVy3SrfjBVCeXJsvnf4k4swEl6BdxD0KWKkj+cITB8FpPUr/phm2AJF7zSOgMxV4ecEiX1LWqTfHmqwQx6HT/cuBT8spDCCumHFqBJ6JBrp7Zuh+MKlh
 8HaANnDr
 qrOod5gM4/B45FHubn5UxkVZRmn6H/XExuzikmeqLPVm3UWkT4r/fArpMFCosM8bWD1ul19JaA3HZlWwEGrB2c0WcxJ2FEki4h3JW3XTzGkF8MsYKdZDMGUuX5jJgJa5n8tunfPIi7rPudG9APLu5SnMIgO7YfJJovnB6TXnxQqDCGC06y8vat6tKCldKWkHfhwPOBpxTKZU8gljPk+FFxHKgtHMJTDJh81kSTfU1mesLgx/NRmajIxikMnX08xIEaZL/pYNGezp/5xgoOiJr+kwWkCWe/DKf53QtsCY1r6qt8CJwIF+wl5fOgpJTMb07wh98W3Qd6MzK08TQw9azQhN91Xb/Cl2Cx9rdm02z0BSF3GRn9eZOLjk7MOWd+P5mFrZkHEiRGZvPt+I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Jul 28, 2026 at 11:13:55AM +0530, Bharata B Rao wrote:

> diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
> index 85253fc8e384..575f880cb147 100644
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -105,10 +105,12 @@
>   */
>  #define POSTED_MSI_NOTIFICATION_VECTOR	0xeb
>  
> +#define IBS_MEMPROF_VECTOR		0xea
> +
>  #define NR_VECTORS			 256
>  
>  #ifdef CONFIG_X86_LOCAL_APIC
> -#define FIRST_SYSTEM_VECTOR		POSTED_MSI_NOTIFICATION_VECTOR
> +#define FIRST_SYSTEM_VECTOR		IBS_MEMPROF_VECTOR
>  #else
>  #define FIRST_SYSTEM_VECTOR		NR_VECTORS
>  #endif

Right, so while looking at this, I noticed a few things; and I think we
can do the below.

---
Subject: x86: Remove CALL_FUNCTION_VECTOR

Per the lines in linux/smp.h:

  #define generic_smp_call_function_interrupt \
	  generic_smp_call_function_single_interrupt

The CALL_FUNCTION_VECTOR and CALL_FUNCTION_SINGLE_VECTOR have the exact
same handler and are thus identical.

Boot tested with vng; Xen parts completely untested.

Not-Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
Note: we could also move HYPERV_*_VECTOR to the bottom and compress
FIRST_SYSTEM_VECTOR depending on CONFIG_HYPERV, giving 2 interrupts back
to !HYPERV peeps.

 arch/x86/entry/entry_fred.c        |  1 -
 arch/x86/include/asm/idtentry.h    |  1 -
 arch/x86/include/asm/irq_vectors.h | 39 +++++++++++++++++++-------------------
 arch/x86/include/asm/xen/events.h  |  1 -
 arch/x86/kernel/apic/ipi.c         |  6 +++---
 arch/x86/kernel/idt.c              |  1 -
 arch/x86/kernel/smp.c              |  9 ---------
 arch/x86/xen/smp.c                 | 22 +--------------------
 8 files changed, 23 insertions(+), 57 deletions(-)

diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index 854899bfec5d..661e125ed936 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -114,7 +114,6 @@ static idtentry_t sysvec_table[NR_SYSTEM_VECTORS] __ro_after_init = {
 
 	SYSVEC(RESCHEDULE_VECTOR,		reschedule_ipi),
 	SYSVEC(CALL_FUNCTION_SINGLE_VECTOR,	call_function_single),
-	SYSVEC(CALL_FUNCTION_VECTOR,		call_function),
 	SYSVEC(REBOOT_VECTOR,			reboot),
 
 	SYSVEC(THRESHOLD_APIC_VECTOR,		threshold),
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index f400cfac69a6..d429a2720e8e 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -679,7 +679,6 @@ DECLARE_IDTENTRY_SYSVEC(X86_PLATFORM_IPI_VECTOR,	sysvec_x86_platform_ipi);
 DECLARE_IDTENTRY(RESCHEDULE_VECTOR,			sysvec_reschedule_ipi);
 DECLARE_IDTENTRY_SYSVEC(REBOOT_VECTOR,			sysvec_reboot);
 DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_SINGLE_VECTOR,	sysvec_call_function_single);
-DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_VECTOR,		sysvec_call_function);
 #else
 # define fred_sysvec_reschedule_ipi			NULL
 # define fred_sysvec_reboot				NULL
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 85253fc8e384..ca8f2045f915 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -44,10 +44,10 @@
 #define ISA_IRQ_VECTOR(irq)		(((FIRST_EXTERNAL_VECTOR + 16) & ~15) + irq)
 
 /*
- * Special IRQ vectors used by the SMP architecture, 0xf0-0xff
+ * Special IRQ vectors used by the SMP architecture, 0xec-0xff
  *
  *  some of the following vectors are 'rare', they are merged
- *  into a single vector (CALL_FUNCTION_VECTOR) to save vector space.
+ *  into a single vector to save vector space.
  *  TLB, reschedule and local APIC vectors are performance-critical.
  */
 
@@ -61,49 +61,48 @@
 
 #define ERROR_APIC_VECTOR		0xfe
 #define RESCHEDULE_VECTOR		0xfd
-#define CALL_FUNCTION_VECTOR		0xfc
-#define CALL_FUNCTION_SINGLE_VECTOR	0xfb
-#define THERMAL_APIC_VECTOR		0xfa
-#define THRESHOLD_APIC_VECTOR		0xf9
-#define REBOOT_VECTOR			0xf8
+#define CALL_FUNCTION_SINGLE_VECTOR	0xfc
+#define THERMAL_APIC_VECTOR		0xfb
+#define THRESHOLD_APIC_VECTOR		0xfa
+#define REBOOT_VECTOR			0xf9
 
 /*
  * Generic system vector for platform specific use
  */
-#define X86_PLATFORM_IPI_VECTOR		0xf7
+#define X86_PLATFORM_IPI_VECTOR		0xf8
 
 /*
  * IRQ work vector:
  */
-#define IRQ_WORK_VECTOR			0xf6
+#define IRQ_WORK_VECTOR			0xf7
 
 /* IRQ vector for PMIs when running a guest with a mediated PMU. */
-#define PERF_GUEST_MEDIATED_PMI_VECTOR	0xf5
+#define PERF_GUEST_MEDIATED_PMI_VECTOR	0xf6
 
-#define DEFERRED_ERROR_VECTOR		0xf4
+#define DEFERRED_ERROR_VECTOR		0xf5
 
 /* Vector on which hypervisor callbacks will be delivered */
-#define HYPERVISOR_CALLBACK_VECTOR	0xf3
+#define HYPERVISOR_CALLBACK_VECTOR	0xf4
 
 /* Vector for KVM to deliver posted interrupt IPI */
-#define POSTED_INTR_VECTOR		0xf2
-#define POSTED_INTR_WAKEUP_VECTOR	0xf1
-#define POSTED_INTR_NESTED_VECTOR	0xf0
+#define POSTED_INTR_VECTOR		0xf3
+#define POSTED_INTR_WAKEUP_VECTOR	0xf2
+#define POSTED_INTR_NESTED_VECTOR	0xf1
 
-#define MANAGED_IRQ_SHUTDOWN_VECTOR	0xef
+#define MANAGED_IRQ_SHUTDOWN_VECTOR	0xf0
 
 #if IS_ENABLED(CONFIG_HYPERV)
-#define HYPERV_REENLIGHTENMENT_VECTOR	0xee
-#define HYPERV_STIMER0_VECTOR		0xed
+#define HYPERV_REENLIGHTENMENT_VECTOR	0xef
+#define HYPERV_STIMER0_VECTOR		0xee
 #endif
 
-#define LOCAL_TIMER_VECTOR		0xec
+#define LOCAL_TIMER_VECTOR		0xed
 
 /*
  * Posted interrupt notification vector for all device MSIs delivered to
  * the host kernel.
  */
-#define POSTED_MSI_NOTIFICATION_VECTOR	0xeb
+#define POSTED_MSI_NOTIFICATION_VECTOR	0xec
 
 #define NR_VECTORS			 256
 
diff --git a/arch/x86/include/asm/xen/events.h b/arch/x86/include/asm/xen/events.h
index 62bdceb594f1..11eeceb91fd6 100644
--- a/arch/x86/include/asm/xen/events.h
+++ b/arch/x86/include/asm/xen/events.h
@@ -6,7 +6,6 @@
 
 enum ipi_vector {
 	XEN_RESCHEDULE_VECTOR,
-	XEN_CALL_FUNCTION_VECTOR,
 	XEN_CALL_FUNCTION_SINGLE_VECTOR,
 	XEN_SPIN_UNLOCK_VECTOR,
 	XEN_IRQ_WORK_VECTOR,
diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index c627bee3b14f..499bb3b8803b 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -88,14 +88,14 @@ void native_send_call_func_ipi(const struct cpumask *mask)
 			goto sendmask;
 
 		if (cpumask_test_cpu(cpu, mask))
-			__apic_send_IPI_all(CALL_FUNCTION_VECTOR);
+			__apic_send_IPI_all(CALL_FUNCTION_SINGLE_VECTOR);
 		else if (num_online_cpus() > 1)
-			__apic_send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+			__apic_send_IPI_allbutself(CALL_FUNCTION_SINGLE_VECTOR);
 		return;
 	}
 
 sendmask:
-	__apic_send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+	__apic_send_IPI_mask(mask, CALL_FUNCTION_SINGLE_VECTOR);
 }
 
 void apic_send_nmi_to_offline_cpu(unsigned int cpu)
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index 90a22e24a9eb..b48e0e33ff03 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -133,7 +133,6 @@ static const struct idt_data ia32_idt[] __initconst = {
 static const __initconst struct idt_data apic_idts[] = {
 #ifdef CONFIG_SMP
 	INTG(RESCHEDULE_VECTOR,			asm_sysvec_reschedule_ipi),
-	INTG(CALL_FUNCTION_VECTOR,		asm_sysvec_call_function),
 	INTG(CALL_FUNCTION_SINGLE_VECTOR,	asm_sysvec_call_function_single),
 	INTG(REBOOT_VECTOR,			asm_sysvec_reboot),
 #endif
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 985103cab16c..c7397816b311 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -255,15 +255,6 @@ DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_reschedule_ipi)
 	trace_reschedule_exit(RESCHEDULE_VECTOR);
 }
 
-DEFINE_IDTENTRY_SYSVEC(sysvec_call_function)
-{
-	apic_eoi();
-	trace_call_function_entry(CALL_FUNCTION_VECTOR);
-	inc_irq_stat(CALL_FUNCTION);
-	generic_smp_call_function_interrupt();
-	trace_call_function_exit(CALL_FUNCTION_VECTOR);
-}
-
 DEFINE_IDTENTRY_SYSVEC(sysvec_call_function_single)
 {
 	apic_eoi();
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 05ee0d3b0874..d5544026ede5 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -11,7 +11,6 @@
 #include "xen-ops.h"
 
 static DEFINE_PER_CPU(struct xen_common_irq, xen_resched_irq) = { .irq = -1 };
-static DEFINE_PER_CPU(struct xen_common_irq, xen_callfunc_irq) = { .irq = -1 };
 static DEFINE_PER_CPU(struct xen_common_irq, xen_callfuncsingle_irq) = { .irq = -1 };
 static DEFINE_PER_CPU(struct xen_common_irq, xen_debug_irq) = { .irq = -1 };
 
@@ -37,12 +36,6 @@ void xen_smp_intr_free(unsigned int cpu)
 		unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu).irq, NULL);
 		per_cpu(xen_resched_irq, cpu).irq = -1;
 	}
-	kfree(per_cpu(xen_callfunc_irq, cpu).name);
-	per_cpu(xen_callfunc_irq, cpu).name = NULL;
-	if (per_cpu(xen_callfunc_irq, cpu).irq >= 0) {
-		unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu).irq, NULL);
-		per_cpu(xen_callfunc_irq, cpu).irq = -1;
-	}
 	kfree(per_cpu(xen_debug_irq, cpu).name);
 	per_cpu(xen_debug_irq, cpu).name = NULL;
 	if (per_cpu(xen_debug_irq, cpu).irq >= 0) {
@@ -80,16 +73,6 @@ int xen_smp_intr_init(unsigned int cpu)
 	callfunc_name = kasprintf(GFP_KERNEL, "callfunc%d", cpu);
 	if (!callfunc_name)
 		goto fail_mem;
-	per_cpu(xen_callfunc_irq, cpu).name = callfunc_name;
-	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_VECTOR,
-				    cpu,
-				    xen_call_function_interrupt,
-				    IRQF_PERCPU|IRQF_NOBALANCING,
-				    callfunc_name,
-				    NULL);
-	if (rc < 0)
-		goto fail;
-	per_cpu(xen_callfunc_irq, cpu).irq = rc;
 
 	if (!xen_fifo_events) {
 		debug_name = kasprintf(GFP_KERNEL, "debug%d", cpu);
@@ -154,7 +137,7 @@ void xen_smp_send_call_function_ipi(const struct cpumask *mask)
 {
 	int cpu;
 
-	__xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
+	__xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_SINGLE_VECTOR);
 
 	/* Make sure other vcpus get a chance to run if they need to. */
 	for_each_cpu(cpu, mask) {
@@ -179,9 +162,6 @@ static inline int xen_map_vector(int vector)
 	case RESCHEDULE_VECTOR:
 		xen_vector = XEN_RESCHEDULE_VECTOR;
 		break;
-	case CALL_FUNCTION_VECTOR:
-		xen_vector = XEN_CALL_FUNCTION_VECTOR;
-		break;
 	case CALL_FUNCTION_SINGLE_VECTOR:
 		xen_vector = XEN_CALL_FUNCTION_SINGLE_VECTOR;
 		break;

