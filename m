Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B67CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47A096B00B8; Fri,  1 May 2026 17:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42BC26B00BA; Fri,  1 May 2026 17:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31AD46B00BB; Fri,  1 May 2026 17:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 19EE96B00B8
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:48:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2D6F120239
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:48:17 +0000 (UTC)
X-FDA: 84720189834.17.84E3E02
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id C018A140008
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:48:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P5xgpZw0;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777672095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hc5RHLA5VFRb81K4SZGy+0XpIw2C1HBIpUMvPfNhCXc=;
	b=gTOY+fpVr7UvWfwMnH9KfO8Yjjt4V8HzAl5oA+19CR7iDjcrAjRd+ii5+Y0YeqlyYlTGRx
	EINEbWGAXni+ECBz8bnjX3AcTLu+5+B7N2qcAC8x2BuxbUTP8LEJkUxOO/EJZfjr4DToFj
	fnbm9a6qiNABjDCknod4zn0ydqw1Ecw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P5xgpZw0;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777672095; a=rsa-sha256;
	cv=none;
	b=n3JMqfqLIgdDf/f7MCYSJlDEfvoES4yCZH2SiFxb9xtYw19dV4OikAke+rC8aBv2S4KZgc
	tiDWrAWSdcdScloIgKwuRhxliFO2b80t7MGG6fEIH1znAkEllMYwBpBk0p+0ef1FGQgBAR
	lyHthJPaaR7pWAMAIu3h+7qCrRM5doo=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8ec37d52c0dso248622885a.0
        for <linux-mm@kvack.org>; Fri, 01 May 2026 14:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777672095; x=1778276895; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hc5RHLA5VFRb81K4SZGy+0XpIw2C1HBIpUMvPfNhCXc=;
        b=P5xgpZw0zVpTzGnKDrnqHOKUxWecDVykG2fUaAU7wy7Zp1lpjj7p19ykqfb8/sD4SB
         qYvHTha0vbPvfSyveGpPmQ5bhLpH4E3uoa8nUEYeQ4eeBO3GCZiCPLRPghXJrYOQblC6
         WyuUq/1460JQ/CWmmU4AxcnPdPpt9CeYhPR8R6jHnF0/tepEQ/Z9oxU8zfplPQP5ABgO
         U+u2PXRf/Ly21So6wtCxtAaF0tEoF+syrxejMOgwqpaEld4gwveLXguckVhrpYXLStL/
         HzK/XGpNbnAzDxiKXhgfMBqli1iBc3i/CHloHnJ2g95Na+g5/1NLV2eP0IgRpHET105L
         g4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777672095; x=1778276895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hc5RHLA5VFRb81K4SZGy+0XpIw2C1HBIpUMvPfNhCXc=;
        b=Klzm03BboegBN8rbTymlCa9GypBkVJCAd94NZW/9dMTTXpXhjv5Rdhc6dUZxuB2ZCC
         xwKrYH+9EGb2hbzFVjbyDwrpdvwEAq8fP+H0Grq6J35eDPP6UZqzRNXbvAex7d2Tv4Vf
         ugfvuzb0gToCMS1UZk/ylV6805/w8BTG3taN1dMhFGbqfeB9R6jQUzfM1pdb8LpDeBB7
         6KCLqfjOLk6FvanyBybhHmcJe53bDyQcx8ISh7MRLu7bXAOBEu5JDsJGXAg65GApTpLM
         KaJ4qylSjUxtJp1KWZjhHfI9r1QInfBbIJYlJ4Cyk3BoJmrKkcyDumhrgOmVDM2F3ZpN
         yl4Q==
X-Forwarded-Encrypted: i=1; AFNElJ8hko5eOOOq6Zv4zwCrGIV+rtYei7K6FDlYwskuqu6KFEMQ4TBjArRDtBFF+0Wa+uakidblJsl1Sg==@kvack.org
X-Gm-Message-State: AOJu0YykMpGDXAXUhUV/WcNdj/JToRSeqJLsPw19sqdXNFYdLp6e3bJo
	p066oIIHSQIJcl9AZ4UUOq6MRYTnQVYZlgwUELeeuVNp2qaUqQKD6/qtWI+Q2Iz6nks=
X-Gm-Gg: AeBDiesmIaQ0fA3PdoAkwwKAyh176QRGJSl3RSo5D9kGq2DttKniPNQkz87xpaYwNdo
	dUmUgRy+e7bpchnk0SFUBqBGsflI8w6lJMVldhUA0WTgg3HJ0OXYSe+EMeHeRxSaP9khPWQy8De
	Lta4G+cg0woHmjRRQ2C1Y9d8INrtEcKo5C2zFHPoKkQ8Y80lF5BmpZ59hjxVUc5femFsQZbB7G1
	FojSWQ4RzVfknI5UwlTcdB27O2aTMv3OaNI0rlcHmYCC4B05wTmjH19CHsqQVTf/L1SwumsDFkF
	2EjMhDIaNiSypNYMkyuQQpXjhZSANl8wyQJ3GJi4VS35A2PBSb8bti72WOrOXfI8bLyYL6eSGpC
	F8c0FfAXZAXRMxdqYegMz1PBP3BqAxnAW/KJRcyAptdF/2ayxf9azJ94x7RDZHnundv356vJYW9
	u4BL8F5ZfozUYCNEJIxoEHsFyu2hG1aSkDuY+tmz86cUK84pY/oAg5XHFCratxnxSxoseRujKq
X-Received: by 2002:a05:622a:1a82:b0:50e:a1ab:67eb with SMTP id d75a77b69052e-5104bee8fdemr16187191cf.33.1777672094661;
        Fri, 01 May 2026 14:48:14 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51040b8174csm28918761cf.25.2026.05.01.14.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 14:48:14 -0700 (PDT)
Date: Fri, 1 May 2026 21:48:12 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, rppt@kernel.org, graf@amazon.com, 
	pratyush@kernel.org, seanjc@google.com, maz@kernel.org, oupton@kernel.org, 
	dwmw2@infradead.org, alex.williamson@redhat.com, kevin.tian@intel.com, 
	rientjes@google.com, Tycho.Andersen@amd.com, anthony.yznaga@oracle.com, 
	baolu.lu@linux.intel.com, david@kernel.org, dmatlack@google.com, mheyne@amazon.de, 
	jgowans@amazon.com, jgg@nvidia.com, pankaj.gupta.linux@gmail.com, 
	kpraveen.lkml@gmail.com, vipinsh@google.com, vannapurve@google.com, corbet@lwn.net, 
	loeser@linux.microsoft.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, pjt@google.com
Subject: Re: [RFC] proposal: KVM: Orphaned VMs: The Caretaker approach for
 Live Update
Message-ID: <afUNlL_lRDP6olHE@plex>
References: <afEwWZksU0Fw61oT@plex>
 <0a71472c-b397-4699-a518-61faffcf4ab2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a71472c-b397-4699-a518-61faffcf4ab2@redhat.com>
X-Stat-Signature: qhqw7oy5ymzies9sjgfndaryfjit4ea5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C018A140008
X-Rspam-User: 
X-HE-Tag: 1777672095-306287
X-HE-Meta: U2FsdGVkX18fCDCXS4kp3U6B8Y0FwQEloPyY4QMaNEQteDMhHljACCwcmojWfdWQMHTwGOORtxhLiB98xgFA9fxJ0ANkDlzbtMqRyR/4PF8+8vh08ih1U7FgbpBWtruDKrGSx57njCPpk0CDseKd0FDZLWRuQUmqbAwb+LBnGE4Ni07/LGOk8DrBrCcOqS3lbVUrS0zYwJ/LLXxR3CJ9VmsCBz6S0bjyf3lC5wvJGF4Su91MLCN5JP2Yg6s/fYWYYnuVOzNzqGrz7tpry8084lEhl/lT5PxnsisOa0qWV6ZxSX86pbQCw1eiV2rLvrLH1oItUylQ+cefASoLiKSLLWFQ+070fnTyh2OBF8BNssbN4V8QuIRSdIWcNqBiHeHDlMbmgc1sGl4rvuVlgesWi6Wn5ui0QNpbZ6y61Vc+oaVL25eNt5t/zs/FuJvDi2JCBMxZQcg7qqYQoQZ6Mn+vwUe7Piz2e1wrbxh8ADJJyh7ZnefAFG/MW4FtGqoODJhzMq5XV1QdOXzZU7eRf0tUjI5+dOkJga98LoMFX/SeL/XR+RSVOTf7DTM7cf3GIH/1yWR4NVw5Hnd4nfY+vHPKJIsMGa61bZr++JI2mClC0c1HetJ6dWtdn4CSOCGTh1flyfTHDCDJfzKJCMU3q66N4LDgh0ZZaQwxr4a1KFCKoqvjFOfUblh96MdcxF7M90UZeJ3xKtWiw1zaH40k9F5vdTxohpEmAuNozbKI8vwddD2CkokuOVx7LbIKLSbFMcDfMWTv+p4xrFYd8vDNet7as6fjGP3qDw+HYqyVK4qF4pwF77F0S9XPz9POaqwI8OogKWtVvDBoNn4sJski1yfgypKqcPhAm93DCbo4JRP7Z/tml5FBRm0VtVbQ7QV53U6A6CfH+mxvASzxgKazqQ3Roq4HM2ylJWubNNcdhILOWc3Q/OUHOAgf52iJW8Wjw/5tv5oiF/b/JxAQm5I/1lZ
 rEmdOS1a
 xqlPhtLs8kqqpN3PE6luvpn61XZoizb5iUQkKAiJ23o/th4AnuzHu87gagR+LW2X3O+h+pwM4DoO1MzH/mSQODE/Ls696170jOrlEsAehu5HPSxxNcjirko56cX9FWgjRoiLL8sKI/qW87CA+ygyjDYRedrx7l5ZGeji4W6qVkfQLe29A5wz54TkOmgUOOqFd70RUWjKsrnEnT9LAClgN43CRjwsUuRR5J/Hwm2M8y9KLxZYo3q4Yu9p0k8qNUaWyZIuAsD3xipfcK4JuRlHAEqwdVkJEHwZ8dg9uJFxOKzKD2YrY6H6TncIsJSIFyA1DOqpds6rKmeRXw4KFq2tJYbtQLp7Y4621XBXsjEUlakMCP/kmcBp9GNe07Kd598IG711c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-30 15:28, Paolo Bonzini wrote:
> I have some very similar observations to Alex and some very similar
> observations to David.  This has to imply that everyone will agree with me.
> :)
> 
> Seriously, the main contention point, from reading the thread, is the
> placement and lifecycle of the caretaker.  More on this later...
> 
> On 4/29/26 00:29, Pasha Tatashin wrote:
> > While this proposal focuses on its critical role in minimally disruptive
> > Live Update, the Caretaker is fundamentally designed as an extensible
> > primitive. Its architecture allows it to be leveraged for a variety of
> > other advanced virtualization use cases, such as running custom
> > lightweight hypervisors or completely offloading virtualization duties
> > to an accelerator card.
> 
> One step at a time please---and as an initial step, just place it inside the
> kernel, a la Arm nVHE.
> 
> Since your design would have anyway the ability to update the caretaker, you
> can embed that part into the reattachment process, so that the new kernel
> can use its own caretaker.

This is a good point. If we make the Caretaker built-in and always 
enabled via a module parameter, the update to new Caretaker can be 
handled in the new kernel when we adopt the Orphaned VM thread during 
reattachment.

> This reduces a lot the need to establish a stable-ish ABI.  Only the
> handover (kexec/LUO) needs to be stable, so that the new kernel can populate
> its kvm and kvm_vcpu structs.  And for that we mostly have a solution
> already: a stream of serialized ioctls.

The way I see it, vmfd and vcpufd need to support LUO preservation by 
implementing the liveupdate_file_ops callbacks (.preserve, .restore).

When userspace preserves the vcpufd, the kernel isolates the assigned 
pCPU (probably requiring the vCPU to be pinned to the CPU, and the CPU 
to be in an isolated cpuset), offlines it from the kernel's perspective, 
and signals to the Caretaker that KVM is detached.

We can start with the simplest form of the Caretaker for a PoC:

* No ASI. It duplicates the kernel page tables and uses its own mappings.
* It does not handle any VM exits locally. It passes everything down to 
KVM during normal operation, and treats all exits as blocking events 
when detached.

The PoC can be demonstrated without kexec: execute vcpufd .preserve() to 
isolate and offline the pCPU, and later use LUO .retrieve() to online 
the pCPU and re-adopt the running vCPU thread.

Even for this simplest form, we still need a defined ABI between the 
host kernel and the Caretaker. The host must send an IPI to 
synchronously notify the Caretaker of attach and detach transitions. 
This ABI must also handle Caretaker replacement during the adoption 
phase: when the new kernel retrieves the vCPU, it requires a protocol to 
notify the running Caretaker that the pCPU is being onlined. The 
Caretaker must reach a known, state at that moment so the kernel can 
seamlessly replace the previous kernel's Caretaker version with the 
current one. Finally, the Caretaker still relies on the CCB to access 
KVM routing pointers for forwarding VM exits back to the host during 
normal operation.

> > During the execution of the KVM_SET_CARETAKER ioctl, instead of
> > pointing the hardware's return path to standard KVM entry points (e.g.,
> > vmx_vmexit or svm_vcpu_run), KVM reprograms the host-state return area
> > of the CPU's hardware virtualization control structures (e.g., Intel
> > VMCS, AMD VMCB, or ARM equivalent) to point directly into the
> > bare-metal Caretaker environment.
> 
> This can be done unconditionally for all VMs based on a module parameter,
> again as in Arm nVHE.

Makes sense.

> 
> > Note on Optimization vs. Security: Constantly switching the page table
> > (CR3) on every VM Exit can be expensive due to TLB flushing. To
> > optimize performance, the Caretaker can share the host kernel's page
> > tables while the kernel is still around, and dynamically replace
> > HOST_CR3 with the dedicated, isolated page tables only when the vCPU is
> > orphaned (during the detachment phase). On the other hand, maintaining
> > a permanently isolated CR3 for the Caretaker adds a strong security
> > boundary, achieving hardware-enforced separation similar to KVM Address
> > Space Isolation (ASI).
> 
> Agreed on this.
> 
> > The Caretaker requires a defined ABI to communicate with the host KVM
> > subsystem. This ABI is implemented via the shared, identity-mapped .ccb
> > section of the ELF payload, acting as the Caretaker Control Block
> > (CCB).
> > 
> > The CCB acts as the source of truth for the Caretaker's execution loop
> > and contains three primary elements:
> > 
> >    * Attachment State Flag: An atomic variable indicating the current
> >      relationship with the host KVM subsystem (e.g., KVM_ATTACHED or
> >      KVM_DETACHED).
> 
> This must be done atomically at the time Linux offlines/onlines a pCPU. The
> interface from Linux to the caretaker must use some kind of IPI so that the
> new kernel can force a VMEXIT (if needed) in the caretaker, ask it to
> serialize the vm state, and pass it down to the new kernel's caretaker.

Yes, agree.

> 
> >    * KVM Routing Pointers: The physical function pointers that the
> >      Caretaker uses to safely jump into the host KVM's standard VM Exit
> >      handlers when operating in normal mode.
> >    * Shared Configuration Metadata: A physical pointer to dedicated
> >      memory pages used by the kernel to share dynamic vCPU configuration
> >      data with the Caretaker. Because every guest is configured
> >      differently, KVM populates these pages with the specific parameters
> >      negotiated during VM initialization (such as CPUID feature masks,
> >      APIC routing, and timer states). These pages also include a
> >      pre-allocated Telemetry Buffer for the Caretaker to log VM Exits
> >      and spin-wait durations. These dedicated pages are explicitly
> >      preserved across the host reboot via KHO, ensuring the Caretaker
> >      maintains continuous access to the exact context required to
> >      accurately emulate trivial exits during the gap.
> 
> All this is mostly unnecessary if the caretaker is provided by the kernel.
> The recently introduced remote ring buffers can be used for tracing too.

I will need to learn more about how remote ring buffers work, but it 
would have to be possible to use them even when there is no kernel. So, 
as I understand it, something like this would happen:

The old kernel allocates the remote ring buffer, passes the physical 
address to the Caretaker, and preserves this memory via KHO.

During the kexec gap (when the host kernel is completely offline), the 
Caretaker acts purely as a producer, writing trace events directly to 
this physical memory block and advancing the ring buffer pointers.

When the new kernel boots and re-adopts the orphaned vCPU, it retrieves 
this memory from KHO and attaches it back to the tracing subsystem.

> > The Caretaker first evaluates the VM Exit reason. If the exit belongs to
> > a category that the Caretaker is programmed to resolve natively, it
> > handles it internally. For example, profiling of guests has identified
> > the following exit categories for potential local resolution:
> > 
> >    * Guest Idle Exits (e.g., HLT): When the guest OS goes idle, it
> >      triggers idle exits. The Caretaker intercepts these and halts the
> >      physical core until the next guest-bound interrupt fires, preserving
> >      host power.
> 
> I don't think HLT can be handled entirely here.  Either you skip the exit
> completely or you have to go out to the scheduler.  The HLT exit could be
> skipped unconditionally for an orphaned VM, but while there is a running
> kernel the caretaker has to run entirely with interrupts off and that limits
> what you can do.
> 
> In fact there is already a blueprint of what can be handled easily in the
> caretaker, namely vmx_exit_handlers_fastpath()/svm_exit_handlers_fastpath().
> Stick to what exists already.

I agree regarding HLT: during the gap, the simplest approach is to just 
skip the exit and return directly to the VM without attempting to handle 
it.

Also, yes, vmx_exit_handlers_fastpath() and svm_exit_handlers_fastpath() 
provide a good blueprint for the VM exits that can be handled directly 
in the Caretaker.

> 
> >    * Timer and APIC Exits: Even an idle guest frequently writes to
> >      interrupt controllers and system registers to configure internal
> >      timers. The Caretaker handles these trivial writes directly,
> >      acknowledging the timer updates.
> 
> This depends heavily on the implementation of the hypervisor, for example it
> can be done on Intel via the preemption timer but not on AMD where an actual
> hrtimer is needed.

The Caretaker will have varying degrees of support depending on the 
architecture.

For the initial PoC, we can start with the most primitive form: treating 
these as blocking exits across all relevant architectures (Intel, AMD, 
ARM).

Beyond the PoC, we will expand this functionality independently per 
platform to reduce the blackout window, berpaps based on fastpath 
support. If a specific architecture lacks the hardware features to 
handle a certain exit natively in the Caretaker, it will remain a 
blocking exit on that platform during the gap.

> 
> [...]
> 
> > When the new VMM process spawns, it retrieves the
> >     preserved session and issues LIVEUPDATE_SESSION_RETRIEVE_FD using
> >     its token. LUO invokes KVM's .retrieve() callback to map the
> >     preserved vcpufd back into the new VMM's file descriptor table. As
> >     part of this retrieval process, the host formally brings the
> >     isolated pCPU back online, and the new VMM userspace thread is
> >     attached back to the active VM thread running on the vCPU. Finally,
> >     KVM populates the new KVM Routing Pointers in the CCB and
> >     atomically flips the Host State Flag back to KVM_ATTACHED. This
> >     breaks the Caretaker's spin-wait loop (if it is in this state),
> >     allowing standard KVM operation to resume.
> 
> This would also include some kind of serialization of the old VM into the
> new kernel's struct kvm_vcpu.

> 
> Also some kind of feature negotiation is needed (if that fails, the VMs are
> terminated unceremoniously) so I believe that the transition into and out of
> the gap must be synchronous.  For example with INIT/SIPI for the entry, and
> an IPI for the exit?

Yes, the serialization of the old VM state into the new kernel's struct 
kvm_vcpu is handled via KHO (Kexec Handover) during the LUO .preserve() 
and .retrieve() phases.

Regarding feature negotiation, compatibility checks are a fundamental 
requirement for live update. If the new kernel does not support the 
features required by the preserved VM, the update should ideally be 
aborted before the point of no return, or as you said, the VM must be 
terminated unceremoniously.

I completely agree that the transition into and out of the gap must be 
synchronous. As discussed above, using an IPI is the right approach. For 
entry, the host kernel signals the Caretaker via IPI to ensure it 
reaches a known state before the pCPU is offlined. For exit, the new 
kernel sends an IPI to the orphaned pCPU to force a VM exit, allowing 
the new kernel to take control, update the Caretaker environment, 
and complete the reattachment.

> > Guest-to-Guest IPIs
> > -------------------
> > 
> >    * The Problem: If the guest OS attempts to wake up a sleeping thread,
> >      one orphaned vCPU will send an Inter-Processor Interrupt (IPI) to
> >      another orphaned vCPU. In standard virtualization without hardware
> >      assistance, writing to the APIC ICR (or sending an ARM SGI) causes
> >      a VM Exit so the host KVM can emulate the message delivery. During
> >      the gap, KVM is unavailable to route this message.
> > 
> >    * Proposed Solution: The architecture may leverage hardware virtualized
> >      interrupts (Intel APICv, AMD AVIC, or ARM GICv4.1 virtual SGIs).
> >      This allows the hardware silicon to handle IPI delivery between the
> >      isolated pCPUs natively, eliminating the VM Exit. Alternatively,
> >      the Caretaker can be programmed to emulate the IPI delivery. By
> >      utilizing the shared memory metadata, the Caretaker can determine
> >      the target vCPU and directly update its pending interrupt state.
> 
> Yeah, I think APIC emulation to some extent must be moved into the VMX/SVM
> fastpaths.  The good news is that this can be done already as a PoC without
> needing the whole caretaker and LUO infrastructure.

Moving APIC emulation into the VMX/SVM fastpaths makes sense as a 
standalone effort.

> 
> >    * The Problem: What happens if a Non-Maskable Interrupt (NMI), a
> >      hardware timer tick, or a Machine Check Exception / System Error
> >      (MCE / ARM SError) arrives while the CPU is actively executing
> >      Caretaker code in KVM_DETACHED mode?
> > 
> >    * Proposed Solution: To safely handle these asynchronous events, [...]
> >      on x86, when transitioning into the gap, KVM explicitly programs
> >      HOST_IDTR and HOST_GDTR to [the caretaker's] tables.
> 
> Agreed and this also shows that the transition must be synchronous.
> >    * The Problem: As the guest executes, it may attempt to access memory
> >      that has not yet been mapped by the hypervisor, or it may interact
> >      with MMIO regions. Normally, this triggers an EPT Violation (Intel)
> >      or NPT Page Fault (AMD), prompting KVM to allocate host pages and
> >      update the secondary page tables. How are these updates handled
> >      when the host KVM subsystem is offline during the gap?
> > 
> >    * Proposed Solution: During the "Management Gap," there are absolutely
> >      no updates made to the NPT/EPT. The existing secondary page tables
> >      are fully preserved in memory via LUO kvmfd preservation prior to
> >      detachment, allowing the guest to seamlessly access all previously
> >      mapped memory. If the guest triggers a new page fault (requiring an
> >      NPT/EPT update) during the gap, the Caretaker simply categorizes it
> >      as a Blocking Exit.
> 
> Yes, by default everything is a blocking exit.  In particular, unless one
> day we do x86/pKVM, page tables can be handled entirely by Linux rather than
> the caretaker with no change to the existing MMU notifier architecture.
> 
> As a consequence, the caretaker is absolutely not going to be a TCB---at
> least not in the beginning.

+1.

> 
> > Compromised Caretaker
> > ---------------------
> > 
> >    * The Problem: The Caretaker runs in Host Mode. If left unprotected,
> >      this could allow a lightly privileged userspace process (e.g., QEMU
> >      or crosvm) to inject arbitrary executable code directly into the
> >      CPU's most privileged hardware state (VMX Root / Ring 0 / EL2).
> > 
> >    * Proposed Solution: To mitigate this risk, the KVM_SET_CARETAKER
> >      ioctl may adopt the security model used by the kexec_file_load()
> >      syscall. Rather than trusting userspace to pass physical addresses,
> >      the kernel must take full ownership of payload validation:
> 
> -EOVERENGINEERED.  Just shove it into the kernel.

Ok.

> 
> > Caretaker Update
> > ----------------
> > 
> >    * The Problem: Given that the Caretaker is permanently installed
> >      during VM setup, how does it get updated on long-running VMs?
> 
> Via kexec. :)  I understand you have bigger plans, but we need to crawl
> before walk^Wattempting a marathon.

Sure.

> 
> I even wonder if, for long term simplicity, the interface for
> host->caretaker should be just for the caretaker to swallow the host into
> non-root mode, again as in Arm nVHE.  That would make it much harder to
> implement some kind of live update, but my answer to that *really* is just
> to use kexec.
> 
> Paolo
> 

