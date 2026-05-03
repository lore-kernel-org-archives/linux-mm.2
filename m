Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 562C2CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 16:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA546B0005; Sun,  3 May 2026 12:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96AA26B009E; Sun,  3 May 2026 12:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859F46B009F; Sun,  3 May 2026 12:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74A176B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:57:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E7A0160814
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:57:24 +0000 (UTC)
X-FDA: 84726714408.23.87F69DF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id E771CC0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:57:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DgUfCvRV;
	spf=pass (imf22.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777827442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZAX/3Dxul6ab0aa4nY+5/E1aKies+ngH//pLM2CQH8=;
	b=ymo3E4w2sk5LWl3geOBIvqLc6t/4XojhKIun5GwWIiJ/Tt6TdW4RlJLv19f588qnpqgK0O
	zSjEDEFZBnXkhXPBWLWG4r34n1mA+OTnejy6PVA6xAi77hnAjBLRl/AiKiDIWkzqo2rdGn
	Ne3J90wOrmP38+Z7+HYgOObsiL1GhPc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777827442; a=rsa-sha256;
	cv=none;
	b=o7s08FulRpFMTSMHNBgckjcGLQlLCC/qsfJMpVoBMBgTBWprSSwxh7KqAqfcQ1M4lyj+1K
	aPwm1cIBC9N6lV5M26SEk8hzB2+5hW+8fp8pqvvQaqB4cUTScuX83tgCBV10EOV/om8tZ6
	bavtr5OMdn7KO7UJqFpWNl8mrEaz79c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DgUfCvRV;
	spf=pass (imf22.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777827441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZAX/3Dxul6ab0aa4nY+5/E1aKies+ngH//pLM2CQH8=;
	b=DgUfCvRVnxqbOwpakxKF6tkY2CQCl5LSrOYg3BKffb1zF3rHOxb3n4Rkf7ThWj0/HPoX9x
	5oWAn93vUTr+GtmbLuhv7/AbAkoRLsFfavsttC28WzGuzfsTA4SwVhv3SZJUVhyOd+qc/6
	/jPKgfSlW1067y3dyVV6lQw1Pw8E0Bs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-70jg2xwsN1eXqfpV9N74MA-1; Sun, 03 May 2026 12:57:20 -0400
X-MC-Unique: 70jg2xwsN1eXqfpV9N74MA-1
X-Mimecast-MFC-AGG-ID: 70jg2xwsN1eXqfpV9N74MA_1777827439
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4837bfcfe0dso38442135e9.1
        for <linux-mm@kvack.org>; Sun, 03 May 2026 09:57:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777827439; x=1778432239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wZAX/3Dxul6ab0aa4nY+5/E1aKies+ngH//pLM2CQH8=;
        b=XS/aOy3dHiH8lXLHmSwReIgvtHluu/PAW0ou40A3V35kOiKWXfBSl/KTwXotusMUQP
         qYQEQNrI0HGjdaXUz4+2dUEmA8jsXBwzkl3FAoj6g/zyGuYqE6U+kcukfZ9RWcJVmySa
         EwesbAog4lKy2swp5a5HKyFuGSMfa9Kki3yzP1fUh+EUFqN+VvS1WI7RyQoWTt0ZU52t
         150LuQ68lIcxio1549euXq41BYOYAhd8WTq2BxGFW6Ozw2iy8/L/BPshN7WQeyrekQKG
         8WC/l1QRO8BJeG6hhlAf5I23RBpUhKfIKpseUiZ4nENaAZEywIoghYCF5eQ/gL8msP18
         NEug==
X-Forwarded-Encrypted: i=1; AFNElJ/j2dBaH3glWQwzxwFd7ESTr9glvmiTab4e7Vc7L2or0M0lRye7rYB8t1nNwpezK8KbTs4hm3mYOA==@kvack.org
X-Gm-Message-State: AOJu0Yyr4g9uy2jyewb/qm9UvvLj7JuX+PkeaD0ZxhHFdOSWMYZv5eF6
	Ru+4yfyN467yCuLY560p+ZNZ4+6RdtLNDLhDDlnQ7jWPYPgI4ikBfkd1ObXaS4T4PI7py4kFFEr
	t6TSwaERCMOIoIxvo60muac8kwSb36Rcng3dGfwS5XB9yVGNO808lrPQgymb0ygFQAyRGFZOQW5
	+GBAt6UMNTmRBGTUxSqes2rRv29R8=
X-Gm-Gg: AeBDietj5tGlwGNo1MuK9ikn9LgWR/vf4cM+pla7JcFMn/HZFzHi5AgvXIpGkXQpEvQ
	KR/Y70gVr3QK+vwqdCAWXaBIH1rAmeWySm7A/4bU1EMJYKTTIGCRiBowNVjo2psfiSGPIZ52bXS
	+b9YxOuNrQCZwwYMPn0RTf9PtEwV1/syQStWGErh1bAo7iRz5eIMyjlDqRA3E3XXuadCsJu0Vry
	F5dxSrNG1nrMrabxMA6Y29Oub9P8h4kHNrIMi+I3iRuJ0eOTo1RpvtXR2bWm8cazlHV6gHvNgrM
	VrgwP8xeua/Q1Kw=
X-Received: by 2002:a05:600c:c0c5:b0:485:30d4:6b9e with SMTP id 5b1f17b1804b1-48a98662e71mr84651585e9.21.1777827438734;
        Sun, 03 May 2026 09:57:18 -0700 (PDT)
X-Received: by 2002:a05:600c:c0c5:b0:485:30d4:6b9e with SMTP id
 5b1f17b1804b1-48a98662e71mr84651295e9.21.1777827438361; Sun, 03 May 2026
 09:57:18 -0700 (PDT)
MIME-Version: 1.0
References: <afEwWZksU0Fw61oT@plex> <0a71472c-b397-4699-a518-61faffcf4ab2@redhat.com>
 <afUNlL_lRDP6olHE@plex>
In-Reply-To: <afUNlL_lRDP6olHE@plex>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 3 May 2026 18:57:06 +0200
X-Gm-Features: AVHnY4LZ9SLOVvMSSNVqrWN2ReqSfwRcQuKsaciqQRZIlDN_XSMAX0q55GthIJg
Message-ID: <CABgObfaqZ8GGaLV_gp8o+nQSe+JfnBbZP0X9cDxdvEpyUZQRnQ@mail.gmail.com>
Subject: Re: [RFC] proposal: KVM: Orphaned VMs: The Caretaker approach for
 Live Update
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	rppt@kernel.org, graf@amazon.com, pratyush@kernel.org, seanjc@google.com, 
	maz@kernel.org, oupton@kernel.org, dwmw2@infradead.org, 
	alex.williamson@redhat.com, kevin.tian@intel.com, rientjes@google.com, 
	Tycho.Andersen@amd.com, anthony.yznaga@oracle.com, baolu.lu@linux.intel.com, 
	david@kernel.org, dmatlack@google.com, mheyne@amazon.de, jgowans@amazon.com, 
	jgg@nvidia.com, pankaj.gupta.linux@gmail.com, kpraveen.lkml@gmail.com, 
	vipinsh@google.com, vannapurve@google.com, corbet@lwn.net, 
	loeser@linux.microsoft.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	roman.gushchin@linux.dev, akpm@linux-foundation.org, pjt@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z1roluRNDQjp7-HiKDC1IX6vnGiUX1Vx4vCokA2pg3A_1777827439
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E771CC0005
X-Stat-Signature: s83k7ct8zwpz48mh8a8bw3bxz15ub3in
X-Rspam-User: 
X-HE-Tag: 1777827441-176031
X-HE-Meta: U2FsdGVkX1+OrzNGfZMf5kFSxq6hq3VrCO2q8XHIqjZOp1DC1XwDnHMkbIByQt0s4OL27T5lr+FKZBETEOUmIoTGhdp5ZIA2Y26W07N+tx+Uq6pxvR9XstzbWq/3kcpAOnDRHY2K4jkkmvs3nBWcONLuL8nqD6LvW5U8fKpENusleKuTe6aZU9MJZJaC5xYHZdydlbzqqRGevvTHTFDUW21/D1I9f/xURYk4LWkHQze7RA8ZYADXPq8EusgPKwHZKFhr8lEiXPzI/ZUIKYCoRT87gzmxRTW/I8BXqVCY+7Atk6KKMdOYJzXpkhNER4g5I0RGtV2us0lHoXfytJHUsanVt7RMUNu8089csbaHtlMhP+L/AYnDRZmsZHwWDvCa2PUTCJEc8VZndb13fcjmEBlXdD/o2iypJs4WPI1m3Iq18mBnN6KuLdPRPYR6FDyPE3ijHD3lbW62vv3Wj3STcerOL4QuzAtmRpPjMlo1vhgroA9tPRV3avnklvwgyOajO4Fm1nO/FvT+Zrsioad5GGB4xfFX6oBV1U+AZCNU4y2An+Ezv6ofwlb/UjKyJEiAjYcnRgcp9fJDbDil0GmYjfBub2jE+BUQ73fY66N+2u7xf3eevjoLwemgDcg8bTe7HMDcv/h9Ag8vcC35yaxwaZFVtQaKOAO4oxHZQfNrhHMe3HEFWJYvL4Awu73JRs2ZfHYwkfhWMYFLgnRiurk6aL9Bi4Iy3DaDGXZfv6pQjp3VxrpqcoHeG77HAlPzl0DX/Oh3QwCyQuDM7KEgjahOAByPy77zX2bw/htmcO8YUzxvqx4S5oSSB+NizRP7ufx943Dwz6y/gRSJp5TWbbX4V+9bl4WmlHIINx3E50Ve52/NX5SW00gOaP3bl4DewThcF+5jvfTr8UlfCYCPLf+3JMn1USTgzzof7MQ5Vojd8MfS1oLViVqUpt1gCWCxukwC2ghb7/TrLRXN3Z6uJN3
 D9du8okd
 qCapx4AAijt7APu/BkJmwRZAhtMJbooBPgn0fozIzMYTTMsbwOAXk2SiJ/swjR++Ims7Af0Os64odhEJhZuaTpIkBp9d8n0VA2SquXBxqV8nM7kQAWCkyHxmwvDSIM6vlpedq44Q1vzwdjdiU+Ef3swz3R+E/igQyTzyapcoqZ9zp5C/YLfzKdne7d1YBVJXNoDJZpVQ183P0z0/qb6u0YSq61oTsX4dmoDtpF9ILBrthYKmz/fc9R9NbKvdIUDi5EE3L4nwXc5YK7fM2GfX18OU6z2MdA95gBiJ34ybJoO+uEvm0tlulGqbTTI6tNI7o1CNMdLN1SC25dzshJPar7EjNSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 1, 2026 at 11:48=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
> The way I see it, vmfd and vcpufd need to support LUO preservation by
> implementing the liveupdate_file_ops callbacks (.preserve, .restore).
>
> When userspace preserves the vcpufd, the kernel isolates the assigned
> pCPU (probably requiring the vCPU to be pinned to the CPU, and the CPU
> to be in an isolated cpuset),

Generally speaking vCPUs do not care if they are pinned. Do we need a
preparatory ioctl for this on the vcpufd side, even just a
KVM_ENABLE_CAP or a new bit for
KVM_ENABLE_CAP(KVM_CAP_X86_DISABLE_EXITS)?  If
LIVEUPDATE_SESSION_PRESERVE_FD suddenly can start offlining pCPUs,
that would require a capability check.

> Even for this simplest form, we still need a defined ABI between the
> host kernel and the Caretaker. The host must send an IPI to
> synchronously notify the Caretaker of attach and detach transitions.

Yes, but it's unlikely to need stability unlike the KHO serialization.

> This ABI must also handle Caretaker replacement during the adoption
> phase: when the new kernel retrieves the vCPU, it requires a protocol to
> notify the running Caretaker that the pCPU is being onlined. The
> Caretaker must reach a known, state at that moment so the kernel can
> seamlessly replace the previous kernel's Caretaker version with the
> current one. Finally, the Caretaker still relies on the CCB to access
> KVM routing pointers for forwarding VM exits back to the host during
> normal operation.

I'm not sure if routing pointers are needed, as opposed to just a
call/ret (ignoring detachment and reattachment which are different
anyway). In the end, the x86 caretaker is basically the
non-preemptable part of vcpu_enter_guest(). Even once you add
attach/detach, the body of code that runs in the caretaker is roughly
the same and what changes is setting up the address space, the IDT,
etc.

> > This must be done atomically at the time Linux offlines/onlines a pCPU.=
 The
> > interface from Linux to the caretaker must use some kind of IPI so that=
 the
> > new kernel can force a VMEXIT (if needed) in the caretaker, ask it to
> > serialize the vm state, and pass it down to the new kernel's caretaker.
>
> Yes, agree.

BTW, the same IPI is needed to force a VMEXIT even before kexec, if
the old kernel does anything that breaks the running VM such as
madvise(MADV_FREE).  Should not happen with properly behaving
userspace, but it must be accounted for.

> During the kexec gap (when the host kernel is completely offline), the
> Caretaker acts purely as a producer, writing trace events directly to
> this physical memory block and advancing the ring buffer pointers.
>
> When the new kernel boots and re-adopts the orphaned vCPU, it retrieves
> this memory from KHO and attaches it back to the tracing subsystem.

Yes, this should work with remote trace buffers.

> I agree regarding HLT: during the gap, the simplest approach is to just
> skip the exit and return directly to the VM without attempting to handle
> it.

Or even disable intercepts for HLT/PAUSE/MONITOR/MWAIT.

> I completely agree that the transition into and out of the gap must be
> synchronous. As discussed above, using an IPI is the right approach. For
> entry, the host kernel signals the Caretaker via IPI to ensure it
> reaches a known state before the pCPU is offlined.

And then does INIT/SIPI on the offlined pCPU to re-enter the caretaker
in detached mode.

> For exit, the new
> kernel sends an IPI to the orphaned pCPU to force a VM exit, allowing
> the new kernel to take control, update the Caretaker environment,
> and complete the reattachment.

> > Yeah, I think APIC emulation to some extent must be moved into the VMX/=
SVM
> > fastpaths.  The good news is that this can be done already as a PoC wit=
hout
> > needing the whole caretaker and LUO infrastructure.
>
> Moving APIC emulation into the VMX/SVM fastpaths makes sense as a
> standalone effort.

Yup, that's nice to have.

Thanks for the detailed reply, I limited mine to where I wanted your
input as the author of LUO - especially with respect to privilege
separation.

Paolo


