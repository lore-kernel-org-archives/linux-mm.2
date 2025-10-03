Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24993CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 14:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502C78E000B; Fri,  3 Oct 2025 10:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA838E0006; Fri,  3 Oct 2025 10:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F06C8E000B; Fri,  3 Oct 2025 10:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 268F88E0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:35:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB7AC13BCDF
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:35:21 +0000 (UTC)
X-FDA: 83957050842.19.F59BD40
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf24.hostedemail.com (Postfix) with ESMTP id 04923180004
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:35:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=22GHiV4b;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3Jt_faAYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Jt_faAYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759502120; a=rsa-sha256;
	cv=none;
	b=3GqD8kiRmxHf5/8KcOmXknA8GkFUnFpEtFp3f54oa934jgFwX1cAncHmrldrXYlN7VNY7V
	NIU6BC1fQg4x9bNckj6Vd5DntOobx+sNa7YChnDmih3e+nm2tRHrfxgwoV5CAuuQwIF9OM
	ZWs5/U7pSGxLr9vcU3pRzkXLA5TUajU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=22GHiV4b;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3Jt_faAYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Jt_faAYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759502120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iz/kuorGnhS1JOjPWbMWU1uMXuAxZjX5KeqruEHo5gU=;
	b=sV/eT1qu4B9oJj12s9ow4uDiy1Qsx2u8OY4oBxi7tRgitJg7yRaOmDxcVpse+S7URfhFYd
	RY4w9lieivjfPKE56V82FIukTKn3vGdO7r68hsmCugcXBgH+cWh9o2ILJrNWGFA9QVGYFa
	bSdIJzizRFyQLiwji0JfcJnWCN3abrE=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b55153c5ef2so1671317a12.0
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 07:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759502119; x=1760106919; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Iz/kuorGnhS1JOjPWbMWU1uMXuAxZjX5KeqruEHo5gU=;
        b=22GHiV4bcskvQg5IXO0Mh6YvRsLfig6TGn+xlauiIYRE+MDmr6CaIAX8oMpr9zLXbb
         84SJURAa2fxPMxUMQn+sH3XEjWOyTjluX8bjB9stapVtaNre1t0DpRCNhM7bcj31M4Gw
         xc810VtQLj8FYFkK0TN/j2E081ZlL/o47vZPqThpmmeYtcH8jX6cJWrClwFpwi/BuhZZ
         BL0nwFfm2yiAnATpupzAEZO8AMlzvBDmHYcqfM28ACFrCvPHDHow/Jd/JOloGSkG1dpU
         liaCS4UaYdB37CxsiYQYYdAFLqh67Swu3KdWCcvyy3lqDs7bU4q9Tv/apA0H8BkvjIrn
         lrPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759502119; x=1760106919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iz/kuorGnhS1JOjPWbMWU1uMXuAxZjX5KeqruEHo5gU=;
        b=uNWRT9XA+DcvOO3seN/fxHPQTpTRDRmk9xPi0drj2X2a9FCf4l29Qq2F4Zmq/0Y+b/
         YcTl/zRlPWS+4IeWbOrugBLvhzDmum+ygwToXlD9sQhwPY4S18RsASlE9gGqyQV6sfVs
         Mrm+z1573/Ixk1zQU2zno7MWqlOdNn8XdpDt7YmaBglIfC1LLVFtkbYVpYBHVKgOrrPb
         qZuYu31uJVHNjx4i06FG6Ylo4fsGPgSka3P6EKEyDp8By6tO6bMro+YxB+2kIW+K88a2
         JvrK+IN/x5kCFSKHNwYj0tcREq4iwyp/2uxJL79WDQhOb4yQ7vf/PNr3LvZVHs48hckR
         LBGg==
X-Forwarded-Encrypted: i=1; AJvYcCUK1VV+5/e5DEVLKGcgSm2Sh1oL1mlTE/B+z6PKFyM8T1LAFIlw3UT0jW5kqtu05tLeRq2zJYErJQ==@kvack.org
X-Gm-Message-State: AOJu0YwJdJrkP2MVu1Aij+NfoQfX4zmqzgq5MuGsk2Rp88Uy7Z/ckkdV
	1DzPjlXedtd8PpCZ6tudz5ParNA0bRoqv6qACM0Ve4fk6CnkAyGlSWz20V6bNOJ1EGTkKyHneau
	0cBKCnQ==
X-Google-Smtp-Source: AGHT+IFUN7Oe4z6ZymRlBXqr3L4kG4PYp2PMFWWKwKk/eG/6YDVO+WPrjEYPY3MOxRYFU3HuhZBFs27G7uM=
X-Received: from pjpy4.prod.google.com ([2002:a17:90a:a404:b0:32b:95bb:dbc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a11:b0:32e:e18a:3691
 with SMTP id 98e67ed59e1d1-339c27b3cf0mr3856927a91.35.1759502118454; Fri, 03
 Oct 2025 07:35:18 -0700 (PDT)
Date: Fri, 3 Oct 2025 07:35:16 -0700
In-Reply-To: <b3c2da681c5bf139e2eaf0ea82c7422f972f6288.1747264138.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b3c2da681c5bf139e2eaf0ea82c7422f972f6288.1747264138.git.ackerleytng@google.com>
Message-ID: <aN_fJEZXo6wkcHOh@google.com>
Subject: Re: [RFC PATCH v2 29/51] mm: guestmem_hugetlb: Wrap HugeTLB as an
 allocator for guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org, aik@amd.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anthony.yznaga@oracle.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	bfoster@redhat.com, binbin.wu@linux.intel.com, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	dave.hansen@intel.com, david@redhat.com, dmatlack@google.com, 
	dwmw@amazon.co.uk, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	graf@amazon.com, haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04923180004
X-Stat-Signature: hzzgub9rg5putqgcamo1eayinmsopdgu
X-Rspam-User: 
X-HE-Tag: 1759502119-385353
X-HE-Meta: U2FsdGVkX19c8q5ORHkORDdA7L0C5F0kG5cXFP4mzdrYoTC3pfvH2PSZXxzGRAmelu7iM4iTvaPiejMSLV9QjubF9feZOJtuHxLc7+38R8tukdLNO/6hQc2o+CgDbwrOiOCGwb9EYvxrWJPInpGkeNyhSOpIcKif42XoWLbx1HgLd3sLedwpR3FfJf3uu3GV4NB2nIpJCpe2jGqL8aUXivvHQQ0Wajg8gQRmZyc91Si2k53Fn5ic/ycZr5SMlbTRmWLGhQJibkCikkOlzfJ0N5+bvV/f1KSNlmV+ZZAAfBLmn/HDsnyX0cjh3PGpOr4VNQY1l9V9MnQikvSHw2A8gi1cMmt+OcC0tG+gBjX7mj9m/XjtJ0UAQWwuZmyNiWUqggLAmhcPIuamxHlgvPdesJuN9Edy7Ye94M6I1BkqTT2zqomlwQz85AA8UzVJPJlAGO0DlxjBCL7/FNy318XeUQv+bDfViMDrs0JDFTW+ZeXOfvqKu1VzqGqxQxaXjWwQLvF1fXWDbjUu9fuBdQ9Gz7kr4H3c2iqbRhs+D/7HYngUvRh/RTi3JFcjhpBIlFG2ex5U0Y8P/gV0tKmSGE3zI1ZNzwfTFjiziyh+Pq7BfO289JlJitj7NgMDQWCo0ozefMURxqXKAz4fXqKKQBvI9rUsAnVsU34Opk8BBufc83yg6wrw9lYijBJqG8eqglIb3ICpnofblb7RTta56ytu6qqx9CTF6hCz12Ngq1VWDQl2Ryoig+n9iQ88Nzg0mVJe2qFHE1zepHlcHmnVWPYaxhpTw/LZVdPkNXv0Q+RTBbNBuhSZKCPafG7ewOueFlvZ/71PoBlpVd/hvVH5AtT2bFro56SiUkm/wEeblvDBPWyHm9HjwoICspavFfpVf+/IRqw0H3fIzsJYVJqdLES0JHgHAE9nQNiOgHrTD4qVL2+CN4nINeP5O3F/A1RAnU/GTEBZQFC8eD+StmvSpK2
 1xT6j7Kw
 ZxaVwxmAujy08kW2Sy/Sjv9yYcgP9WCEjdbGIbj7pupy6b9SAy8oAFJFxLCJCJXWwfUQV+INceT/LlP7UzKF/uhT5GyiGV+U8nI/NF76UE3E8z1YM+nyt0JwNom/0EB8XcqKSTsktR+aHtFZ+XmKgJOOxzVcAr7RCv+DImCM2YfrY/hhUqZYdzF321sHQvnvgzj+wqGmMi/iJne1eDLLsmPZnt9oBB40uwtnKu4fNa5OXg44JljJYk6dTnqD3zV4wkQmSiM3p7dw9kD/z3lbVpQXIy8FPwFrL4u9hGu9wUXdJE6uJOoyNRlB3yuoHeitNXPnUO6u1gjNUoYLAAZ2T+o15I5UIOTfKDUZjuRDF49Uld8uUNeIS0sFjEa0fM7dZdSCKkOS/RT9TZKNPmhKtjDY6OzEGnHG749uDtYRnCIGHSM3xnP9zBoIcLuuwuimy6iug+56YjSaykmc82ZPES+2qllkbDOjXBE1lroQDr6Eh7zQb+PEfPugwYJGg3IZf1aUrxRgRYNSFNDjWe6/GYlU4kz0MzUuSRQkzkVzaeRi80S1wfxlxbPbA41qjIZ0/rP+B0cun3Dp1g0vp5S7iCa9E8rrx9B5RX75b6NkJtTp1XXU8LbqEqLCU3L4HBrY9oenO+lHeMtfcV4Kmnkq+pwwtN1VLqQNb97eIvmkBj4A/59Wcfnpkpfcp6R0SEfFD97zXmJRC7ASwxof5AOxzEz4pTk+Zo1TqFHftm8DKfFfNdypTD2mJSBqWVnJchX8RSCQw/vzW8OnOhBRjlkEHz/sJrFxjxlIW/puONxU9vWPGvPG/OJFk1EwYaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 14, 2025, Ackerley Tng wrote:
> guestmem_hugetlb is an allocator for guest_memfd. It wraps HugeTLB to
> provide huge folios for guest_memfd.
> 
> This patch also introduces guestmem_allocator_operations as a set of
> operations that allocators for guest_memfd can provide. In a later
> patch, guest_memfd will use these operations to manage pages from an
> allocator.
> 
> The allocator operations are memory-management specific and are placed
> in mm/ so key mm-specific functions do not have to be exposed
> unnecessarily.

This code doesn't have to be put in mm/, all of the #includes are to <linux/xxx.h>.
Unless I'm missing something, what you actually want to avoid is _exporting_ mm/
APIs, and for that all that is needed is ensure the code is built-in to the kernel
binary, not to kvm.ko.

diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index d047d4cf58c9..c18c77e8a638 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -13,3 +13,5 @@ kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
 kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
+
+obj-$(subst m,y,$(CONFIG_KVM_GUEST_MEMFD)) += $(KVM)/guest_memfd_hugepages.o
\ No newline at end of file

People may want the code to live in mm/ for maintenance and ownership reasons
(or not, I haven't followed the discussions on hugepage support), but that's a
very different justification than what's described in the changelog.

And if the _only_ user is guest_memfd, putting this in mm/ feels quite weird.
And if we anticipate other users, the name guestmem_hugetlb is weird, because
AFAICT there's nothing in here that is in any way guest specific, it's just a
few APIs for allocating and accounting hugepages.

Personally, I don't see much point in trying to make this a "generic" library,
in quotes because the whole guestmem_xxx namespace makes it anything but generic.
I don't see anything in mm/guestmem_hugetlb.c that makes me go "ooh, that's nasty,
I'm glad this is handled by a library".  But if we want to go straight to a
library, it should be something that is really truly generic, i.e. not "guest"
specific in any way.

> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> 
> Change-Id: I3cafe111ea7b3c84755d7112ff8f8c541c11136d
> ---
>  include/linux/guestmem.h      |  20 +++++
>  include/uapi/linux/guestmem.h |  29 +++++++
>  mm/Kconfig                    |   5 +-
>  mm/guestmem_hugetlb.c         | 159 ++++++++++++++++++++++++++++++++++
>  4 files changed, 212 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/guestmem.h
>  create mode 100644 include/uapi/linux/guestmem.h


..

> diff --git a/include/uapi/linux/guestmem.h b/include/uapi/linux/guestmem.h
> new file mode 100644
> index 000000000000..2e518682edd5
> --- /dev/null
> +++ b/include/uapi/linux/guestmem.h

With my KVM hat on, NAK to defining uAPI in a library like this.  This subtly
defines uAPI for KVM, and effectively any other userspace-facing entity that
utilizes the library/allocator.  KVM's uAPI needs to be defined by KVM, period.

There's absolutely zero reason to have guestmem_hugetlb_setup() take in flags.
Explicitly pass the page size, or if preferred, the page_size_log, and let the
caller figure out how to communicate the size to the kernel.

IMO, the whole MAP_HUGE_xxx approach is a (clever) hack to squeeze the desired
size into mmap() flags.  I don't see any reason to carry that forward to guest_memfd.
For once, we had the foresight to reserve some space in KVM's uAPI structure, so
there's no need to squeeze things into flags.

E.g. we could do something like this:

diff --git include/uapi/linux/kvm.h include/uapi/linux/kvm.h
index 42053036d38d..b79914472d27 100644
--- include/uapi/linux/kvm.h
+++ include/uapi/linux/kvm.h
@@ -1605,11 +1605,16 @@ struct kvm_memory_attributes {
 #define KVM_CREATE_GUEST_MEMFD _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP          (1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED   (1ULL << 1)
+#define GUEST_MEMFD_FLAG_HUGE_PAGES    (1ULL << 2)
 
 struct kvm_create_guest_memfd {
        __u64 size;
        __u64 flags;
-       __u64 reserved[6];
+       __u8 huge_page_size_log2;
+       __u8 reserve8;
+       __u16 reserve16;
+       __u32 reserve32;
+       __u64 reserved[5];
 };
 
 #define KVM_PRE_FAULT_MEMORY   _IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)

And not have to burn 6 bits of flags to encode the size in a weird location.

But that's a detail for KVM to sort out, which is exactly my point; how this is
presented to userspace for guest_memfd is question for KVM.

> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_LINUX_GUESTMEM_H
> +#define _UAPI_LINUX_GUESTMEM_H
> +
> +/*
> + * Huge page size must be explicitly defined when using the guestmem_hugetlb
> + * allocator for guest_memfd.  It is the responsibility of the application to
> + * know which sizes are supported on the running system.  See mmap(2) man page
> + * for details.
> + */
> +
> +#define GUESTMEM_HUGETLB_FLAG_SHIFT	58
> +#define GUESTMEM_HUGETLB_FLAG_MASK	0x3fUL
> +
> +#define GUESTMEM_HUGETLB_FLAG_16KB	(14UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
> +#define GUESTMEM_HUGETLB_FLAG_64KB	(16UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
> +#define GUESTMEM_HUGETLB_FLAG_512KB	(19UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
> +#define GUESTMEM_HUGETLB_FLAG_1MB	(20UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
> +#define GUESTMEM_HUGETLB_FLAG_2MB	(21UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
> +#define GUESTMEM_HUGETLB_FLAG_8MB	(23UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
> +#define GUESTMEM_HUGETLB_FLAG_16MB	(24UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
> +#define GUESTMEM_HUGETLB_FLAG_32MB	(25UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
> +#define GUESTMEM_HUGETLB_FLAG_256MB	(28UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
> +#define GUESTMEM_HUGETLB_FLAG_512MB	(29UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
> +#define GUESTMEM_HUGETLB_FLAG_1GB	(30UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
> +#define GUESTMEM_HUGETLB_FLAG_2GB	(31UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
> +#define GUESTMEM_HUGETLB_FLAG_16GB	(34UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
> +
> +#endif /* _UAPI_LINUX_GUESTMEM_H */

...

> +const struct guestmem_allocator_operations guestmem_hugetlb_ops = {
> +	.inode_setup = guestmem_hugetlb_setup,
> +	.inode_teardown = guestmem_hugetlb_teardown,
> +	.alloc_folio = guestmem_hugetlb_alloc_folio,
> +	.nr_pages_in_folio = guestmem_hugetlb_nr_pages_in_folio,
> +};
> +EXPORT_SYMBOL_GPL(guestmem_hugetlb_ops);

Why are these bundled into a structure?  AFAICT, that adds layers of indirection
for absolutely no reason.  And especially on the KVM guest_memfd side, implementing
a pile of infrastructure to support "custom" allocators is very premature.  Without
a second "custom" allocator, it's impossible to determine if the indirection
provided is actually a good design.  I.e. all of the kvm_gmem_has_custom_allocator()
logic in guest_memfd.c is just HugeTLB logic buried behind a layer of unnecessary
indirection.

