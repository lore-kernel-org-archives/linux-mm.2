Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E894C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7077C6B0088; Tue, 11 Aug 2026 16:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8976B008A; Tue, 11 Aug 2026 16:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5808C6B0092; Tue, 11 Aug 2026 16:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1893A6B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:06:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8FF3F1C0869
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:06:07 +0000 (UTC)
X-FDA: 85090069974.22.62A4A33
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf15.hostedemail.com (Postfix) with ESMTP id D4E10A000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:06:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q6SAT3xQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3rIB7agYKCPUpbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3rIB7agYKCPUpbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786478765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHNzSxXj0COMq5ZCxE4trCLjxzBSaHB9lM75a8GWZr4=;
	b=MpCXV0GEB4lsU8zDl2WGspa1o6yPTKDKFiMd7A2r6vv318v3T8jqoCmjQxrjsusVop7pGZ
	J0jtuLtjY6806NlSw03k4QVz+RJzDwiOGHBLWWcfoBCAvTpPfpPBsvSxMp0id9J5bHOwvN
	gr8La4q2KfWUIRvGhP35P1khumWsZdA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q6SAT3xQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3rIB7agYKCPUpbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3rIB7agYKCPUpbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786478765;
	b=az6HXXFfUhstFX/fpnf8Kbx2ctcZ56hkufVAA+bzrDulx1GM1ZmhAW7kImrnj7p09bMX4H
	eO1tdXqAwASeNth5GDYlB4sreytQRSIIEPiONbuL3A5xg/qZiQm0W6UxtCe5E2BifFxoqL
	VurUz/V2ib63pe2MHqzbc8gNESEIf5M=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cacf17c7e0so4741085ad.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786478765; x=1787083565; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mHNzSxXj0COMq5ZCxE4trCLjxzBSaHB9lM75a8GWZr4=;
        b=Q6SAT3xQarPdqD8fYcXKC4Vg3hIJEVqV3ZIX7PPnavOcN+gAv2pcAGNlXeoPtJzYz7
         GGKJhaObg+IkZo5OfmRgmGAL2AK4mqMNys19cpNIUFoaGZN891VfR2ST8dEHxI/2/4GF
         kpGY7dP74xAG4WkSH/T3me7M3VqiS+Nci+L9ysJNXK4W4vKhhMNv4kA32uxBFGKaF94G
         zO+IfYOuEncFblZ3TbJGi+pgNdkvJzwfwM+PUg4oj67/oYbNr1JlUayLyxOAKXPKy0kl
         NG84uiqKPAuXA9Y6XBWvHFeCXtYJk/E7pNBgjg151cETVFnvAcepGxqk9H7GOGRGcrBj
         sKlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786478765; x=1787083565;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mHNzSxXj0COMq5ZCxE4trCLjxzBSaHB9lM75a8GWZr4=;
        b=mUSIaEQahsBh2rrsj3TyHnQauaF6Anx59S6HmPmdOKnQayAPVV9fcDnnYr5O9svXS9
         X22a1GIhpA+ykSgn+4n9ausS2N1297sy5GwwPT4A5/82nFyG+bI65vcgpxs4l6EcJG8P
         LE7RubA5ahQ0BXdyu1hCBc4/6xytraGPzfs82uqONmIc/+tYRf3aKziGHWa0u1WQAJNe
         npLIYrIyQzxlxj75qnOpJlJYYI6d3lO8xc87KFVyFNqAIX9EKugsFGAzPI/1NdyTrIEH
         nwU7jkFwiP4t7irRBvt74QREbjig/+OVWFpPo2McmRx8URGoOn8R/uWx3njUXDDEtTUd
         gQqA==
X-Forwarded-Encrypted: i=1; AHgh+RqTUAlMO1zIaMXRbfjpMlZBxvK+GwVsF83sf8reM0sFmZUMJdn4ELSasr9D8yB+6vBVk/ARvSABmg==@kvack.org
X-Gm-Message-State: AOJu0YyM4m8mvBAZJAxhH69twmWSL5U1ViPXBRhu1QpQLnHIEkHHR5V+
	ahB0f1sIEiihNqsEATshW3WYf2eeyM01lz9/l612X96j/qLoxbL8aDU6CPJ/K6bmz6uVHNnuFQk
	1XIf1fg==
X-Received: from plbko6.prod.google.com ([2002:a17:903:7c6:b0:2cc:77e3:3ef0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e784:b0:2ca:b4b9:4586
 with SMTP id d9443c01a7336-2d3178e8ac4mr77418145ad.19.1786478764486; Tue, 11
 Aug 2026 13:06:04 -0700 (PDT)
Date: Tue, 11 Aug 2026 13:06:03 -0700
In-Reply-To: <20260811181915.GO544626@ziepe.ca>
Mime-Version: 1.0
References: <20260811162423.GL544626@ziepe.ca> <f33571137d2e3973e440d09c7602edaebe08b714.camel@infradead.org>
 <20260811172627.GN544626@ziepe.ca> <B25708F5-8425-4075-8D95-5E2A00C933DF@infradead.org>
 <20260811181915.GO544626@ziepe.ca>
Message-ID: <anuAq2s4mtyw4_Ql@google.com>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Woodhouse <dwmw2@infradead.org>, akpm@linux-foundation.org, david@kernel.org, 
	mhocko@suse.com, rostedt@goodmis.org, bigeasy@linutronix.de, 
	simona.vetter@ffwll.ch, jglisse@redhat.com, christian.koenig@amd.com, 
	paulmck@kernel.org, pbonzini@redhat.com, linux-mm@kvack.org, 
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Stat-Signature: frptrzb1jhbeojwsfy13sdyua8nhfiao
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D4E10A000F
X-HE-Tag: 1786478765-885582
X-HE-Meta: U2FsdGVkX1/gWjBKZh7Iw5CiT3Vt4NIp9jkaNvdbG33w0EBplg/PigrcvVjplC7/KqWGXelTX1EXRvXM3P7I1lK9uNqTf4wdzqP3G0DbR6Y1UohUGO6Df3eWSnXnxMYjj8QYPb8CI2HXnlWCCu5hThizVKVTMnP7KZEuA22Qw95Hrz3wfIjTjUbGkwB816XxSMTEwj4dVJ81ycb7RMLwP4mY5K/7riSHD94zE9klbEGL+GyTWcmTfgZlOLjAd2/vVeSitcCo7E0/Lk5mFkI1DVPHoTZmK+DEI0tKwM8ASeWaNpnTmHWe3wvKxCEqdO0z7unlP9hipe5rTUvCiVm+uCT+HBphf/Wa3GXSD5z93tjC9Nhwy9AEhqfNrSwJB9KEMujx1hY0XftSpuMNXQCI/n9nrVW13TKzdtNnQmtSQgPc3xwmokyvc2dNC/kVZSawljUKFm2TmZh33UOcR/DsorKl6+GLg681HLdcqoMxE2HgyxBJcd38zZ4tCwMxa2mEpwblnknFZy9Jva7/NNth//BzRWYgkKcys3XNRWKj4XZPZ5VH8Y+KqnyR07iwmK55sMKWd0TaOIGlZYk+3UXwGKBlnHu7fpn83tHF3kHAkJCeQEazawUNNi4I9GRlmqDWasLFB9EF+OIry83ZfY45ril5NjED8eeNCa1p35onxkSTF8QMmqUQTxINMnuAVtDeNGs4Bhp4d37zCrjs19N+ddb40kXMEd1Y5Bhoz34oq3PcytS/RGyjNR9tlH8nbul5j2t93PoHHyU/92Myt270+QW/YRybmCxFmEf0g1RTLNNLd2rdULVqw3ENTRmnE7fz2xQV62gb6T5C6JM/58sDyKYpMaYiB2kheMLSQauP7zvf2lk3YoDv2HPT4d2FPQXDXgVOhJC1jI5jIO+Id814WO4/MloZiDDquXCTWrPy1nhrKdNluinQkuTS9RhkFicu0zHg+fnmJUwxDnnXnJz
 V5ISJIdr
 Qje6mMqFrCyn/8aU1sQhMdHJDCDD0rlOq3CA0jbQ4poS6l+tof4902x3zUrA/RQ2rXVc7XYOJr6M7jcFZWi4utyNbR1epi/7KIyJo6ti+JIzAJDdfY2Df+x3BRxm0562VRk2Eip3vDyJUToGUEef/tY4SUU+TK6a0VYblbwTLZDNLTfK96OSeVZLPapWac3m6i3kxPYOjuDO0JO40pDPbp4so01E03REYMgmWMtc3gecpsBdzRYMN0ahzZhB826dsqtGPO40HisaunNfzuUJdk6d/QvKWLJryQqsGJRLuN5OH7K5m+DExrrEvJENU7ewyIWCOYO++6jTHLlWrpiSv8Yu3AySg+vPrA8Ndqs3Fz7L0Cyndf4OEGeWuUR8JDCCwjrVugjnIX2tN64hpiBXEgxhwjyk+wC9xZA3kkkWZbhS6QLPJQT5yRCROxqN/SrH92NN/KcB4a2Xd5gGX6WZjaA1Cwg/rlwVQSDYnPVcqh6rQ76V4dooSmiyP1XB+XW/lRfdpRXKhxc3tVMuHq+igX9ueF5QnKrbwQqPg2QcoPzxfnuqgtmQydIukCHBjGO1+fOtP8Vnbdy3ZAlpu9vcV/YPdkkDTZLpQO1NRX+zezKr654TuYLBbXtqIo4Per27vtpXUCjF5xC56VNh65ako8fja90bRprztyFd18TVjRm+DsDlq561QQZ7CsrFmRAczJcY/DAMLsv8RNl8M0Ql+X4jj8s1Eb+rQiM5ePP51XlB8mCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026, Jason Gunthorpe wrote:
> On Tue, Aug 11, 2026 at 06:59:24PM +0100, David Woodhouse wrote:
> > On 11 August 2026 18:26:27 BST, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >On Tue, Aug 11, 2026 at 06:22:12PM +0100, David Woodhouse wrote:
> > >> On Tue, 2026-08-11 at 13:24 -0300, Jason Gunthorpe wrote:
> > >> > To be clear you should not be using any synchronize_[s]rcu() primitive
> > >> > inside the invalidation callbacks. These are well known to have
> > >> > multi-second delays on loaded systems which are a completely
> > >> > inappropriate performance characteristic for these mm callbacks.
> > >> > 
> > >> > This statement has nothing to do with deadlock.
> > >> > 
> > >> > RCU is always a trade off, you can make the read side run really fast
> > >> > and the write side is ghastly slow. If you can't handle the slow write
> > >> > you shouldn't use RCU techniques.
> > >> 
> > >> The multi-second horror stories are about the *global* RCU/SRCU
> > >> domains, where the grace period has to wait out arbitrary readers all
> > >> over the kernel.
> > >> 
> > >> This is not that. It is a dedicated srcu_struct, private to one VM,
> > >> and its entire reader population is a handful of KVM fast paths that
> > >> until now were under irqsave rwlocks.
> > >
> > >Are you sure? I've never heard that srcu has those kinds of properties.
> > >
> > >If its so fast you should just propose a non-sleeping version and
> > >leave the notifiers out of it
> >
> > I've got torture tests running for correctness on the GPC RCU
> > conversion. I'll throw in some metrics on how often even in that
> > pathological case we hit the wait case, and how long it actually
> > takes.
> 
> Well, to hit the bad RCU cases you need to usually do some other
> workload too..

Yeah, and we've had several (recent) examples of SRCU tail latencies causing
problems for KVM.

> I guess srcu does have some meaningful functional differences, but it
> is hardly guaranteed to be fast or non-sleeping out of the box.
> 
> I guess you are making an arugment that if SRCU critical sections are
> atomic themselves then the synchronize could also reasonably be
> atomic. That seems plausible, and may be worth some additional API
> surface on the SRCU side to expose this use model and drop the might
> sleep that is causing the trouble.
> 
> Some sort of "atomic RCU" that has a slower reader but a faster atomic
> writer.
> 
> I'm much happier to see a formal API under the notifiers that has
> strong properties of being reasonable than KVM using SRCU in a way
> that just happens to do that by accident, under the current
> implementation..

Agreed, I suspect shoving a synchronize_*rcu() of any kind in the mmu_notifier
invalidation path will come back to bite us, hard.

But I don't think we need an entirely new type of RCU for KVM.  Unlike (S)RCU,
KVM can and _must_ block relevant readers when an invalidation is in-flight.
I.e. the invalidation path doesn't need to ensure *all* readers go away, only
that the relevant readers have observed the invalidation.

The readers also don't need to be allowed to sleep; I suggested using SRCU instead
of RCU purely because the tail latencies for regular RCU are typically much, much
worse than SRCU (and I agree that they're bad for SRCU).

Earlier, David described KVM's GPCs as de facto software TLBs, and KVM already
has code to protect walks of what are effectively software TLBs, specifically
walk_shadow_page_lockless_{begin,end}() and the associated write-side handling
of READING_SHADOW_PAGE_TABLES in kvm_request_needs_ipi().

And looking to the future, if/when we use GPCs to track PFNs that are mapped into
the guest through control structures, i.e. not through page tables, we'll already
need to rely on kicking CPUs via IPI to ensure readers see the invalidation.

So rather than use (S)RCU, what if KVM tracks which CPUs are reading and then
blasts IPIs to complete the "TLB" shootdown?

The biggest wrinkle I can think of is that unlike READING_SHADOW_PAGE_TABLES,
there isn't a 1:1 association between vCPUs and CPUs, i.e. KVM can't walk its
array of vCPUs to see which CPUs need to be kicked.  But that should be easy enough
to solve with a cpumask.  Cache line contention might be a problem, but if so, it
seems like a solvable problem.

Very roughly and incomplete, relative to David's series to use SRCU:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac961f4c91da..b4a7b613ad91 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1719,18 +1719,18 @@ static void kvm_setup_guest_pvclock(struct pvclock_vcpu_time_info *ref_hv_clock,
 {
 	struct pvclock_vcpu_time_info *guest_hv_clock;
 	struct pvclock_vcpu_time_info hv_clock;
-	int idx;
+	unsigned long flags;
 
 	memcpy(&hv_clock, ref_hv_clock, sizeof(hv_clock));
 
-	idx = srcu_read_lock(&vcpu->kvm->gpc_srcu);
+	flags = kvm_gpc_read_begin(vcpu->kvm);
 	while (!kvm_gpc_check(gpc, offset + sizeof(*guest_hv_clock))) {
-		srcu_read_unlock(&vcpu->kvm->gpc_srcu, idx);
+		kvm_gpc_read_end(vcpu->kvm, flags);
 
 		if (kvm_gpc_refresh(gpc, offset + sizeof(*guest_hv_clock)))
 			return;
 
-		idx = srcu_read_lock(&vcpu->kvm->gpc_srcu);
+		flags = kvm_gpc_read_begin(vcpu->kvm);
 	}
 
 	guest_hv_clock = (void *)(gpc->khva + offset);
@@ -1755,7 +1755,7 @@ static void kvm_setup_guest_pvclock(struct pvclock_vcpu_time_info *ref_hv_clock,
 	guest_hv_clock->version = ++hv_clock.version;
 
 	kvm_gpc_mark_dirty_in_slot(gpc);
-	srcu_read_unlock(&vcpu->kvm->gpc_srcu, idx);
+	kvm_gpc_read_end(vcpu->kvm, flags);
 
 	trace_kvm_pvclock_update(vcpu->vcpu_id, &hv_clock);
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7b2dbbd6b104..54ec1082c5ec 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -189,6 +189,8 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 unsigned long *vcpu_bitmap);
 bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 
+void kvm_kick_many_cpus(cpumask_var_t __cpus, bool wait);
+
 #define KVM_USERSPACE_IRQ_SOURCE_ID		0
 #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
 #define KVM_PIT_IRQ_SOURCE_ID			2
@@ -814,7 +816,7 @@ struct kvm {
 	 * A dedicated domain (rather than kvm->srcu) keeps those waits from
 	 * being lengthened by unrelated memslot readers.
 	 */
-	struct srcu_struct gpc_srcu;
+	cpumask_var_t gpc_readers;
 
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
@@ -1569,6 +1571,20 @@ static inline bool kvm_gpc_is_hva_active(struct gfn_to_pfn_cache *gpc)
 	return gpc->active && kvm_is_error_gpa(gpc->gpa);
 }
 
+static inline unsigned long kvm_gpc_read_begin(struct kvm *kvm)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	cpumask_set_cpu(smp_processor_id(), kvm->gpc_readers);
+}
+
+static inline void kvm_gpc_read_end(struct kvm *kvm, unsigned long flags)
+{
+	cpumask_clear_cpu(smp_processor_id(), kvm->gpc_readers);
+	local_irq_restore(flags);
+}
+
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c6e1c9c28b7e..9ef14057e477 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -205,7 +205,7 @@ static void ack_kick(void *_completed)
 {
 }
 
-static inline bool kvm_kick_many_cpus(struct cpumask *cpus, bool wait)
+static inline bool __kvm_kick_many_cpus(struct cpumask *cpus, bool wait)
 {
 	if (cpumask_empty(cpus))
 		return false;
@@ -214,6 +214,18 @@ static inline bool kvm_kick_many_cpus(struct cpumask *cpus, bool wait)
 	return true;
 }
 
+void kvm_kick_many_cpus(cpumask_var_t __cpus, bool wait)
+{
+	struct cpumask *cpus;
+
+	guard(preempt)();
+
+	cpus = this_cpu_cpumask_var_ptr(cpu_kick_mask);
+	cpumask_copy(cpus, __cpus);
+
+	__kvm_kick_many_cpus(cpus, wait);
+}
+
 static void kvm_make_vcpu_request(struct kvm_vcpu *vcpu, unsigned int req,
 				  struct cpumask *tmp, int current_cpu)
 {
@@ -262,7 +274,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 		kvm_make_vcpu_request(vcpu, req, cpus, me);
 	}
 
-	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
+	called = __kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
 	put_cpu();
 
 	return called;
@@ -284,7 +296,7 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_make_vcpu_request(vcpu, req, cpus, me);
 
-	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
+	called = __kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
 	put_cpu();
 
 	return called;
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 97958af667fb..305706ba35dd 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -121,7 +121,7 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 	 * "size at init" flag, or GFP_NOWAIT in the upgrade).
 	 */
 	if (cleared)
-		synchronize_srcu(&kvm->gpc_srcu);
+		kvm_kick_many_cpus(kvm->gpc_readers, true);
 
 	/*
 	 * Note the GPC_INVALIDATING markers set above are deliberately NOT


