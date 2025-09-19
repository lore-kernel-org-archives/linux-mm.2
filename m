Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71485CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 13:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A358E000B; Fri, 19 Sep 2025 09:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29F98E0001; Fri, 19 Sep 2025 09:14:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B194F8E000B; Fri, 19 Sep 2025 09:14:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0C38E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:14:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 137F21A0650
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:14:54 +0000 (UTC)
X-FDA: 83906044908.04.79B9115
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 22F7114000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:14:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JVeqk9Vi;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758287692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4TO8ldCpCwaQtoLKPhvsFlsBIhB9gZdGySwv7zH4ykU=;
	b=YPL51jkaeOuPoi6U6lGR9p/D39x+j8qUp8yZX4nTePdE4LplCVciAPobnF3Gs53+dYYHmx
	5xfntpy87qYyngKTZT1WagDmpaQ4xsP6x3ib0+xzJiVCRokkGohrpx4ZYiW1Fvx9ow1jht
	C8rI3qEjRfyjyY4HUpi9+mSBK3UqCZM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JVeqk9Vi;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758287692; a=rsa-sha256;
	cv=none;
	b=r5LVljquTFmGH0wv1RX2wq7ayh+9v2KLIfjZNnE/tDuxxH/TsHK2RdU1Iu5RuBnDweW96b
	Ame3CK79lkMxOrw0PUMOG4aWgwi1a1mjst+7eHa7/r3XjtMZk1LUHH338xy7smtybrJJXw
	zBfCY3prugeJkwrKhfO45MCGpqJsdRo=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b61161c32eso31769121cf.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1758287691; x=1758892491; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4TO8ldCpCwaQtoLKPhvsFlsBIhB9gZdGySwv7zH4ykU=;
        b=JVeqk9ViNsn+THunXZqjXSsUOyySUcY2EY/nwbpSEyPficIvoQxC8MA5cSmxoB652c
         hkWxkblzCWQZKeiX4e74lsMtvT3sVsYBP/Tt/K/DLtzGq5FBfWEmgyuKV4t6jtEoadQ3
         /6YdODw9CgGzbH7Mtf4LqfS2mOaBTrm8GJpQA7cCr/NvQqM5csVztJluHjoeU3YaC/PP
         Dp1lmsFOt5w1N4n9CfL2Y/SEkcapofna3q0vSMZ3d6hl3Rq5BMEb3MGD9JljZv1G0sEd
         iGfmKpKLbN6Y841UhD9tjJxJiOHanncMXRrVLVRhOuDBWO6VdmGZkDBCFws422eXXpnV
         GHCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758287691; x=1758892491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4TO8ldCpCwaQtoLKPhvsFlsBIhB9gZdGySwv7zH4ykU=;
        b=SFw6SDiiudE/7c4cWWHkcjK/+yrF66QBD2ZvbX6jtARByqNnzBLMOm9b5DH5tZu4qQ
         CZWJeCv65rdXJaz+K2t9I8wm/G/ke+kftiQ3MWHBcTzNjM69Pw9gPQk6nLQZ1WQWrqK5
         niYA3TLNjVlxuUlum0Tiqdc1Rw8TOrBzFjIsHcClh1Rdd2AWFzklR2E6K06q/42TP40B
         63YD+Q6UyD9qE9Fl2T3B33SAZsLfvidD2rCpEnX3TZdTsTDHSJ5TKQ81/Ke30LGU0o3W
         X3NXJEenhLGTysOf5xZwFumgxeN02ZD9sjCoU3oiYvgkK8IAg/RGR3dkH37mNJI0Y8xh
         KGbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtK2u/7G6GPhSVaPCbXLBTlyfJEgf0esersMFsvmKWUCEMTOxy38uOGCynXXaoy37aCUUocTAOvg==@kvack.org
X-Gm-Message-State: AOJu0Yxn84qVEHTSWwtNRxO0jngrib+5r80fU8UhzIi+C1CVdm2OaUYE
	AOxWln23SyZCkrm4QKqnyZWW2/3Q+8uDcRQ2sIgNtKfp/mbq5bxGVlh3FgDGdOVTcJwmgqIC8Id
	cmNB6NZi5C8a3LSks/iw+7VOynExv6/YmNr83YEY3xQ==
X-Gm-Gg: ASbGncu8I1IoT3arqGk15oHT35YxwlAV/+UJZWFvsqeeFrkXHyyekMxsY/T3/ZqzMGm
	xshG2YTuEwib1hYaEVeEr+sWLMWu7DKiXtPDA+24yk/MaK7SX8TCI2nexD6SY3vTGdYnAJJcgFE
	lIF6+M2G4SdsLZFLi5qPnn9luDb9A+ikD7yB3UYvAB/CZ03mkM75zZGLRYScOxpFx1wVwQJEdD3
	WO3
X-Google-Smtp-Source: AGHT+IFP5OPPTxwZ8V54f9/k+r549Cc9+2zxQm2wZ1tAr4n+kgl+fwpljr133j453kMoly6d472Qfg2qfJWHUKMsWzY=
X-Received: by 2002:a05:622a:1a02:b0:4b5:da5f:d9b7 with SMTP id
 d75a77b69052e-4c073ab0dd8mr34737991cf.78.1758287690916; Fri, 19 Sep 2025
 06:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 19 Sep 2025 09:14:12 -0400
X-Gm-Features: AS18NWCzyLEt0N2rB1CWsx_n5vr6VC5G7l3ExS6vuWkIq3v8_7YkqfncY9X_FkM
Message-ID: <CA+CK2bD3D_XFu1E60qBYwdDzK0c7_bN0BkGBE7h6h_sxmmfvAQ@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <cwang@multikernel.io>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Changyuan Lyu <changyuanl@google.com>, 
	kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 22F7114000F
X-Stat-Signature: rbr1fho8mmnuhd7yo3d6zfcxx1q8dza3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758287691-922992
X-HE-Meta: U2FsdGVkX1//YDZvDoJItnoiX/2KG7aS2TmxAJtbr2Uag+9mQQ1BpL+r1lh2t/9+dNxmmYVo+K3cgSOIV6Tu/nbS67vIFg0KbsbJDJ4fVcWFEE0zJhQ09Xz5RWLOPXa3l2llkSG+SqXcSnleppSNhMg1+kpD/vVRdXfNPMCG3xuQlOg5JL0YuuA6tWEddLhFfhdDWWNGDW2t8cgsaY8r5PxxeVA18vzPWNgaU07MQdUBtVoSj5zKO848OU4yukgjm7bgLdGeZUSFA0vx7emgLJLjFPDUnW63QhowdPJnS6zv0CbLI+o4uhPZCF3/D3jUCe9EJwzvKU/4nFCyKvIlIHwhWwM90R4SZeKrMpIDSLR+m9ccW+ACR78VJG5roUdW89mJIvZ+Liy/8HwfORCNPbn03My+JS38b/JaltvtytfBRBRuZDS6GQJSulblKP9lDCEXrvrKJpKEfWKTFCBl37rppiu2CMWM7b4RL+OL+pdLj2g7uempkmPBmADPg7cTdYs+QSPf6NV6HQDl0fYSvLeoTMHBrHaqDeqFuLMuAoaIiOmNJyeI6oBzOkIcraFdxOfELpwSp1iRZ3iEAH3hBwdHh2wKl8pSh74kg5n4uLBUS/8mJ5+5p5DMj5t+l2Pn6qqtKLqkib/9I4epxcuAmhM7lhNT9NOGKo6qs716scYyz83wFz2exfhj6aRbOwIF5MRY5U1fkuRV+USyxR+4hsIB2zI5By7RFHuz3kJA2OjEXMnuFMCayyWQvmn82i1obg/D5lCtOd1GGkgxtB7/69bkV742kXKrECQ1gLbPeUzXUVabqvPhnKgv8h1B0csky1FWX3s4vw6WlDWcCouSpXjTQ7kjzR16jEd4yBErXWXtK8Vv78OulkFuZne9i/1V9OXHxnQgkEtckWPVb25VKyI5209CP/OILtSTdf4RUiAycUQlRTiPxRsb9vc1gubqy2St5Vu5I0VuE/oCDH/
 uVtxQ6hQ
 NbHg7CYPMcZyQ07ZDRLsaK0dfd+L6bF7QYQBdn5yR+Xb0DYucBNW5bHoFH9Vsq6HUDWbcOGqlwGVepxzu9lrzxhU9hBBfCbHejrb5dcr+Ijvv929xS1xLpyQpdkxQNViVbKM/HGFi1lWUzCTGRyJeVD8KfwVx1bouk0RvQj4Vqgoh2XRmbApHvPjXuoBDO37bfJSU7r3r+u4HrRqttXzPI9yx3eFUcrjOwS2x6PJjTRHhtdBvPDwHh7U6KFhsQLF2VYO+yOJ22sNC2c2OxQr9gWt3WO5QS+3t8BXO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 6:26=E2=80=AFPM Cong Wang <xiyou.wangcong@gmail.com=
> wrote:
>
> This patch series introduces multikernel architecture support, enabling
> multiple independent kernel instances to coexist and communicate on a
> single physical machine. Each kernel instance can run on dedicated CPU
> cores while sharing the underlying hardware resources.
>
> The multikernel architecture provides several key benefits:
> - Improved fault isolation between different workloads
> - Enhanced security through kernel-level separation
> - Better resource utilization than traditional VM (KVM, Xen etc.)
> - Potential zero-down kernel update with KHO (Kernel Hand Over)

Hi Cong,

Thank you for submitting this; it is an exciting series.

I experimented with this approach about five years ago for a Live
Update scenario. It required surprisingly little work to get two OSes
to boot simultaneously on the same x86 hardware. The procedure I
followed looked like this:

1. Create an immutable kernel image bundle: kernel + initramfs.
2. The first kernel is booted with memmap parameters, setting aside
the first 1G for its own operation, the second 1G for the next kernel
(reserved), and the rest as PMEM for the VMs.
3. In the first kernel, we offline one CPU and kexec the second kernel
with parameters that specify to use only the offlined CPU as the boot
CPU and to keep the other CPUs offline (i.e., smp_init does not start
other CPUs). The memmap specify the first 1G reserved, and the 2nd 1G
for its own operations, and the rest  is PMEM.
4. Passing the VMs worked by suspending them in the old kernel.
5. The other CPUs are onlined in the new kernel (thus killing the old kerne=
l).
6. The VMs are resumed in the new kernel.

While this approach was easy to get to the experimental PoC, it has
some fundamental problems that I am not sure can be solved in the long
run, such as handling global machine states like interrupts. I think
the Orphaned VM approach (i.e., keeping VCPUs running through the Live
Update procedure) is more reliable and likely to succeed for
zero-downtime kernel updates.

Pasha

>
> Architecture Overview:
> The implementation leverages kexec infrastructure to load and manage
> multiple kernel images, with each kernel instance assigned to specific
> CPU cores. Inter-kernel communication is facilitated through a dedicated
> IPI framework that allows kernels to coordinate and share information
> when necessary.
>
> Key Components:
> 1. Enhanced kexec subsystem with dynamic kimage tracking
> 2. Generic IPI communication framework for inter-kernel messaging
> 3. Architecture-specific CPU bootstrap mechanisms (only x86 so far)
> 4. Proc interface for monitoring loaded kernel instances
>
> Patch Summary:
>
> Patch 1/7: Introduces basic multikernel support via kexec, allowing
>            multiple kernel images to be loaded simultaneously.
>
> Patch 2/7: Adds x86-specific SMP INIT trampoline for bootstrapping
>            CPUs with different kernel instances.
>
> Patch 3/7: Introduces dedicated MULTIKERNEL_VECTOR for x86 inter-kernel
>            communication.
>
> Patch 4/7: Implements generic multikernel IPI communication framework
>            for cross-kernel messaging and coordination.
>
> Patch 5/7: Adds arch_cpu_physical_id() function to obtain physical CPU
>            identifiers for proper CPU management.
>
> Patch 6/7: Replaces static kimage globals with dynamic linked list
>            infrastructure to support multiple kernel images.
>
> Patch 7/7: Adds /proc/multikernel interface for monitoring and debugging
>            loaded kernel instances.
>
> The implementation maintains full backward compatibility with existing
> kexec functionality while adding the new multikernel capabilities.
>
> IMPORTANT NOTES:
>
> 1) This is a Request for Comments (RFC) submission. While the core
>    architecture is functional, there are numerous implementation details
>    that need improvement. The primary goal is to gather feedback on the
>    high-level design and overall approach rather than focus on specific
>    coding details at this stage.
>
> 2) This patch series represents only the foundational framework for
>    multikernel support. It establishes the basic infrastructure and
>    communication mechanisms. We welcome the community to build upon
>    this foundation and develop their own solutions based on this
>    framework.
>
> 3) Testing has been limited to the author's development machine using
>    hard-coded boot parameters and specific hardware configurations.
>    Community testing across different hardware platforms, configurations,
>    and use cases would be greatly appreciated to identify potential
>    issues and improve robustness. Obviously, don't use this code beyond
>    testing.
>
> This work enables new use cases such as running real-time kernels
> alongside general-purpose kernels, isolating security-critical
> applications, and providing dedicated kernel instances for specific
> workloads etc..
>
> Signed-off-by: Cong Wang <cwang@multikernel.io>
>
> ---
>
> Cong Wang (7):
>   kexec: Introduce multikernel support via kexec
>   x86: Introduce SMP INIT trampoline for multikernel CPU bootstrap
>   x86: Introduce MULTIKERNEL_VECTOR for inter-kernel communication
>   kernel: Introduce generic multikernel IPI communication framework
>   x86: Introduce arch_cpu_physical_id() to obtain physical CPU ID
>   kexec: Implement dynamic kimage tracking
>   kexec: Add /proc/multikernel interface for kimage tracking
>
>  arch/powerpc/kexec/crash.c          |   8 +-
>  arch/x86/include/asm/idtentry.h     |   1 +
>  arch/x86/include/asm/irq_vectors.h  |   1 +
>  arch/x86/include/asm/smp.h          |   7 +
>  arch/x86/kernel/Makefile            |   1 +
>  arch/x86/kernel/crash.c             |   4 +-
>  arch/x86/kernel/head64.c            |   5 +
>  arch/x86/kernel/idt.c               |   1 +
>  arch/x86/kernel/setup.c             |   3 +
>  arch/x86/kernel/smp.c               |  15 ++
>  arch/x86/kernel/smpboot.c           | 161 +++++++++++++
>  arch/x86/kernel/trampoline_64_bsp.S | 288 ++++++++++++++++++++++
>  arch/x86/kernel/vmlinux.lds.S       |   6 +
>  include/linux/kexec.h               |  22 +-
>  include/linux/multikernel.h         |  81 +++++++
>  include/uapi/linux/kexec.h          |   1 +
>  include/uapi/linux/reboot.h         |   2 +-
>  init/main.c                         |   2 +
>  kernel/Makefile                     |   2 +-
>  kernel/kexec.c                      | 103 +++++++-
>  kernel/kexec_core.c                 | 359 ++++++++++++++++++++++++++++
>  kernel/kexec_file.c                 |  33 ++-
>  kernel/multikernel.c                | 314 ++++++++++++++++++++++++
>  kernel/reboot.c                     |  10 +
>  24 files changed, 1411 insertions(+), 19 deletions(-)
>  create mode 100644 arch/x86/kernel/trampoline_64_bsp.S
>  create mode 100644 include/linux/multikernel.h
>  create mode 100644 kernel/multikernel.c
>
> --
> 2.34.1
>

