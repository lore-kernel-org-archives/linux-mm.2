Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14935C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 23:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE2C26B008A; Mon, 10 Aug 2026 19:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA106B008C; Mon, 10 Aug 2026 19:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA9B96B0092; Mon, 10 Aug 2026 19:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7466B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:42:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01990802C1
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:42:05 +0000 (UTC)
X-FDA: 85086985452.16.AAF0D65
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4CFFF4000F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:42:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=axlj65k8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3ymF6agYKCNEF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3ymF6agYKCNEF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786405324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A61U9gaW98E0bIoWCcW/i0GsXSPspOMzgO62CMQ+Bvc=;
	b=0J/d2PoJ/wfJVzdXPbFJ2Hnu3gU5ZCWdhHr/X1SBWvhVfilyfC8Uh3nOSAw/jG9gaOChHK
	BKz6BRvu92makOGmQZKw1d3cz7PTAVEbk9laJOwAuiOAuRYWQ8mdeH7DgvXpoP9bCF7mLh
	o2ooqQfKDkNVQFkvWGjpCRW9Ag0a/pg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=axlj65k8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3ymF6agYKCNEF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3ymF6agYKCNEF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786405324;
	b=ftEpMJ6aK+eGBmRBySV+BzC+9pYv/nCEZ0AEcfL7sA6adxnC4C1T6bZxPkqYg5pjL5gaee
	seixQjnHXWOnVJU1+tqDfg2RruIyIBRvHt/LekhuCEeaKmcr2sWgnHf3gLOst6TBfI+MI3
	a4QVCC35b3Qal/8QLJF0DDHipyYYma4=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84e048a801dso3588097b3a.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786405323; x=1787010123; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A61U9gaW98E0bIoWCcW/i0GsXSPspOMzgO62CMQ+Bvc=;
        b=axlj65k8AMUwjA8S/zOd34D+PoZ84jFqQp2ZyYklsZ4MyDwgueb1MM73ZPST8VCbay
         CI36KTqCEzDF/QwS/QoJv6n4E5NEqYW8/P+7NkHmDwNSN2me/2a8oxeIrZqIQyhjWxZJ
         z39+c/aKquOQEZLX7tc+QMczGO624y9RTeghLno/irGHUSsh7jf9N5kOzwbhhCcO4xTg
         V+LJfC+ZHiXk47nBEvjFrrKxCAlKqWjyq1dWYPT84gy2Ei4ox3rHrAbunuvrB6LuMo2Z
         NVR/dVVKO6p/KTqA6ONtU0pBz/9CwIcXSqeTQWVwUcxFplOw2yiv2670iu+HIAH8PQ38
         bBeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786405323; x=1787010123;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A61U9gaW98E0bIoWCcW/i0GsXSPspOMzgO62CMQ+Bvc=;
        b=Xn7tCfaJsjn1KsW5rjcjXQpr84IyjMOpBf/8HZ3yPMMYjZ0TJsHnzGnxrNk6DZ3Iga
         WaZHAemSo7UtBulMRp3Go9ohSf0zj1+KYbO9MawiDD/hkjFqmDhO2PJfg9U42uzW8U8Z
         wRbqAlHRgTuv2PBdg3oNUp+v05dm9p9gTXu70EOwcsl0PQANwDrjxi5wGYDIH5So94YJ
         XgS0bwWF3nN2e1hpkob7MDqOuTOg04m5tIY9pCW0xIz1l2GbX2WiMo0QclF6+xK92D77
         fMqgmRs4Xz/nZCcq51l5UInm973q5ZU4ECkNypWjJET4a1T5qCD9eQzE/mkE/9nOhkg/
         Tj9g==
X-Forwarded-Encrypted: i=1; AHgh+RpBVtk1NWYO2a7fldMlvjwLf5N1jfIDScAzPdt7UOFj0QfYWh/0rZE0Vw3Z3ZjRn4ubkE4oS3qI8Q==@kvack.org
X-Gm-Message-State: AOJu0Yx4HjI9gk2u6d3yxckohk8ckuji3rSJyaTpvQjNG+cn9+H6BSbD
	68h8MHY64zuNc4ea44SdEaNgAMEVBnTzGH0aGlGqGRY+unKBGPurorcjEISnDZb92C2PQs0qLpg
	7B6hReg==
X-Received: from pfblc11.prod.google.com ([2002:a05:6a00:4f4b:b0:84a:1bf6:cb4a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1910:b0:848:4859:a45
 with SMTP id d2e1a72fcca58-84f9c893fe3mr5371451b3a.2.1786405322699; Mon, 10
 Aug 2026 16:42:02 -0700 (PDT)
Date: Mon, 10 Aug 2026 16:42:02 -0700
In-Reply-To: <20260728121138.1103610-6-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-6-tarunsahu@google.com>
Message-ID: <anphyjFv3FhF61iB@google.com>
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live updates
From: Sean Christopherson <seanjc@google.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: wfq9ieqi8tx3398duacupwmc3owtmuwz
X-Rspamd-Queue-Id: 4CFFF4000F
X-HE-Tag: 1786405324-938893
X-HE-Meta: U2FsdGVkX19mCNVzNT4Gbrtu95NDAQL0MfeFSXODcmPXsgthyP492P9ooieEXy8dcEY0ZXDC29WMSRjbq/wHdaA/5hDnVDfuUwwHrtdAyt3PxLxqW/zJFITH1SocZIZKVN0NYtpL1+fDPfPO3qZ7tD2PE7qyK17H4qFsJ5Lh4FUenHen0Iic5FVATx3BSAYUAdZasDhlIKZ1b8e6IpSZVL176RPqPaPygqAp0Oapw2TaZS6XsxXgay/dgpGETCJ3e0suTD7bl+2tqgAwQ0rjZG+NTlUMu+i7P8fKQBcqEE8il69FCpFN/UySYGes/ugka+yiztOlIQkYzUmqAKIAS0PEDmFCTIiZ+7PCT0kK8Pq3oV+S/uzWhBDTJwQD5R00tSQh8CHhjjeDyBI7VJQLtLSJ/+c3QsuABpaCm8slcq9T5UmQ7J6PmXct7mpQMWhr1ka+BBa/mPrOe5ueIAdtdFWIAJVqwPfj87Q/E0ydr7/GMdtg4z/G1Vu1DmSAV3qt/nRiASHXG6B6TOBGjH4oLFr1ZxNKJ/m34yV/W/RnCMxR+ezmxFjw5cG13yNsQAQ+RVgN8HZAVFpzRPX0SCwCyE2CBJzpxEyVZnFG6SgQ7FGl48p0sBk0Nwm29jmoKaI1eErP4oiMmv76FCdTZoURGwYnVSgdGkwn0h8Dfa3aMk6CA/anLZLm13lDpyoATCV0q634g2DAqtQbTJ7spH+vmNO4ywOQFm4Tx99XCA4EYLviPlJMlfs48/u07vVstBvkwE2t6Fe0NLhqlTkXbcR61RLavDiaOhwlGtp3gr9jCXAL2G9myaCBP6A+CXaG6gR71V4Vz04ASRtpnff2S7BawgesISsI/el4wCuNgHm3L4U/9sQabSgtLKvYXc1RzmmqxVasVOKvdSrmJPfe4XBAmCVkBUPRLXkDZStGWBspAlf/qdmkPskofOLY+fRuCSjZl2lhD/FUdOEYKZmErM7
 j1dLCEJu
 5/RDuLouPnVvYP0/78Ekj8m9mR1BDjeETEK9ragv2TCHZ+eBVabKPLQs5DnJfUUWBP4hJIfyV0EGlig3cCUpZ744YgUNQG59a5KI2XVQ/fr81KuFWxoglJdotrk9/6xtcFS/UCcwm5u18eJdDizJo2DxR61pL9ZkXE0wHgPZ4n+DQ7GGBmounSDPT3zcp7wETX7ZROg2ur3ZKlF19cbQG6ZNz2gutYqfwQHXKaXX1/ToDV8vJ/XmCHpFEOzg5aPpandsq5Ea5iyYmvAHiePiEjGk1Xir+NL79BBA+Ew6mjvV28A5lOV9RpPDUfsrGYXB6QkuVZoD0JmbOt2Dz3sLgu/7avALpIxq9AVGUW710IxOJcoz24htpOV1YF82Ew+9aJB5Lj/joIavsHvvS+wJE9lcc/b2mYT2qGbwf+qQRSMyEYMGVTNGHYU6bgCJINVdbopBzwgqOihLD/M7fefgBCs+4hYyREa2cxNydZIUoncwIMn+L+w4uoN2+O2DSMwqbiE0jeLhgVo0kgD1dUg9Up6Tatgie5zwi1qVeKtfg8Xk8N8T2xF67nunvh6O8tRekHQwbYCY5TQVoLkIZ6n45TGEZWRDBFBMRWOabAh7IzUBF2Wpi87ZWQXnrqykCayBmm9yAhHbe6HsW8mrD6hpvgm5iBl9ulsIK0ZupEKtF1XZA72ZPiPKBs4vAK49NEm5OdbMsvqK/XVks8gdbhl09wfc1cPk3Fxk48NrNE6EJir6CGMRjG6uRF2i6HbIglnwEKjkXZRekyiua+NdYdAWvEkeYuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026, Tarun Sahu wrote:
> Register a Live Update Orchestrator (LUO) file handler for KVM VM files
> to serialize and deserialize VM state across kexec live updates.
> 
> Currently, Only VM type (e.g. arch.vm_type on x86) is preserved as part
> of VM preservation.

Why?

> On retrieval, kvm_luo_retrieve() recreates the KVM VM file via
> kvm_create_vm_file() and use an atomically incremented ID for the internal
> fdname, as the final fdname assigned by userspace is not yet known during
> retrieval. As this fdname is only used in debugfs infra, This will not break
> any UAPI.
> 
> This infrastructure establishes the foundation for preserving guest_memfd
> instances across live updates, and can be expanded in the future to
> preserve additional VM state.

Uh, why guest_memfd?  As much as I want to push guest_memfd adoption, it seems
guest_memfd should be the _last_ thing we support, not the first.  As evidenced
by the last two decades, it's very doable to have KVM VMs without guest_memfd,
but it's rather hard to have VMs without vCPUs.

> Also updates MAINTAINERS to include virt/kvm/kvm_luo.c and
> include/linux/kho/abi/kvm.h.
> 
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  MAINTAINERS                 |  11 ++
>  include/linux/kho/abi/kvm.h |  39 ++++++++
>  virt/kvm/Makefile.kvm       |   1 +
>  virt/kvm/kvm_luo.c          | 195 ++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c         |   8 ++
>  virt/kvm/kvm_mm.h           |   8 ++
>  6 files changed, 262 insertions(+)
>  create mode 100644 include/linux/kho/abi/kvm.h
>  create mode 100644 virt/kvm/kvm_luo.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a3ed337e827d..0283f0fd6ef4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14539,6 +14539,17 @@ S:	Maintained
>  F:	Documentation/devicetree/bindings/leds/backlight/kinetic,ktz8866.yaml
>  F:	drivers/video/backlight/ktz8866.c
>  
> +KVM LIVE UPDATE
> +M:	Pasha Tatashin <pasha.tatashin@soleen.com>
> +M:	Mike Rapoport <rppt@kernel.org>
> +M:	Pratyush Yadav <pratyush@kernel.org>
> +R:	Tarun Sahu <tarunsahu@google.com>
> +L:	kexec@lists.infradead.org
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git

NAK on taking changes through a different tree.  This is KVM code, period.

In general, I'm skeptical of the dedicated MAINTAINERS entry.  It's extremely
difficult to tell since this series is little more than a skeleton (either that
or liveupdate is way simpler that I was expecting), but I suspect that maintaining
liveupdate for KVM (or for any subsystem) will require more subsystem-specific
knowledge than liveupdate knowledge.

E.g. the LUO APIs seem pretty straightforward; I assume the bulk of the complexity
is going to be in knowing what to save/restore, and how, which is much more about
KVM than it is about liveupdate.

> +F:	virt/kvm/kvm_luo.c
> +
>  KVM PARAVIRT (KVM/paravirt)
>  M:	Paolo Bonzini <pbonzini@redhat.com>
>  R:	Vitaly Kuznetsov <vkuznets@redhat.com>
> diff --git a/include/linux/kho/abi/kvm.h b/include/linux/kho/abi/kvm.h
> new file mode 100644
> index 000000000000..718db68a541a
> --- /dev/null
> +++ b/include/linux/kho/abi/kvm.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2026, Google LLC.
> + * Tarun Sahu <tarunsahu@google.com>
> + *
> + * KVM Preservation ABI for Live Update Orchestrator (LUO)
> + */
> +#ifndef _LINUX_KHO_ABI_KVM_H
> +#define _LINUX_KHO_ABI_KVM_H
> +
> +#include <linux/types.h>
> +#include <linux/kho/abi/kexec_handover.h>
> +
> +/**
> + * DOC: KVM Live Update ABI
> + *
> + * KVM uses the ABI defined below for preserving its state
> + * across a kexec reboot using the LUO.
> + *
> + * The state is serialized into a packed structure `struct kvm_luo_ser`
> + * which is handed over to the next kernel via the KHO mechanism.
> + *
> + * This interface is a contract. Any modification to the structure layout
> + * constitutes a breaking change. Such changes require incrementing the
> + * version number in the KVM_LUO_FH_COMPATIBLE compatibility string.
> + */
> +
> +/**
> + * struct kvm_luo_ser - Main serialization structure for a KVM VM.
> + * @type:         The type of VM.
> + */
> +struct kvm_luo_ser {
> +	u64 type;
> +} __packed;
> +
> +/* The compatibility string for KVM VM file handler */
> +#define KVM_LUO_FH_COMPATIBLE	"kvm_vm_luo_v1"
> +
> +#endif /* _LINUX_KHO_ABI_KVM_H */
> diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
> index d047d4cf58c9..c1a962159264 100644
> --- a/virt/kvm/Makefile.kvm
> +++ b/virt/kvm/Makefile.kvm
> @@ -13,3 +13,4 @@ kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
>  kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
>  kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
>  kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
> +kvm-$(CONFIG_LIVEUPDATE_GUEST_MEMFD) += $(KVM)/kvm_luo.o
> diff --git a/virt/kvm/kvm_luo.c b/virt/kvm/kvm_luo.c
> new file mode 100644
> index 000000000000..025b53151b6a
> --- /dev/null
> +++ b/virt/kvm/kvm_luo.c
> @@ -0,0 +1,195 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (c) 2026, Google LLC.
> + * Tarun Sahu <tarunsahu@google.com>
> + *
> + * KVM VM Preservation for Live Update Orchestrator (LUO)
> + */
> +
> +/**
> + * DOC: KVM VM Preservation via LUO
> + *
> + * Overview
> + * ========
> + *
> + * KVM virtual machines (VMs) can be preserved over a kexec reboot using the
> + * Live Update Orchestrator (LUO) file preservation. This allows userspace
> + * to preserve KVM VM state across kexec reboots.
> + *
> + * The preservation is not intended to be fully transparent. Only specific
> + * VM configuration and state are preserved, while other aspects of the VM
> + * must be re-established or re-configured by userspace after retrieval.

IMO, this is not helpful documentation.  Anyone with passing knowledge of LUO
already knows the above.  What people like me don't know are the exact details
of how preserving a KVM guest is expected to work.

> + * Preserved Properties
> + * ====================
> + *
> + * The following properties of the KVM VM are preserved across kexec:
> + *
> + * VM Type
> + *   The VM type (e.g., on x86 architecture, the vm_type parameter) is
> + *   preserved.
> + *
> + * Non-Preserved Properties
> + * ========================
> + *
> + * The preservation does not cover:
> + *
> + * - vCPUs and vCPU states
> + * - Memspots / Memory slot layout (memslots)
> + * - Interrupt controllers and IRQ routings
> + * - Coalesced MMIO zones
> + * - Device bindings (VFIO/Eventfds)
> + * - Active paging or guest registers state
> + * - etc

So... what's the plan?  Bluntly, this series isn't going anywhere without a
clear plan of how all of this is going to fit together.

> +static int kvm_luo_preserve(struct liveupdate_file_op_args *args)
> +{
> +	struct kvm *kvm = args->file->private_data;
> +	struct kvm_luo_ser *ser;

I *really* dislike the "ser" nomenclature.  The abbreviation isn't common, and
IMO it's not intuitive.  This also needs to be more specific, becuase I'm guessing
we'll end up with more than one "kvm" LUO structure.

Maybe something like kvm_vm_luo_state?

> +
> +	if (kvm->vm_dead || kvm->vm_bugged)
> +		return -EINVAL;
> +
> +	ser = kho_alloc_preserve(sizeof(*ser));
> +	if (IS_ERR(ser))
> +		return PTR_ERR(ser);
> +
> +#if defined(CONFIG_X86)
> +	ser->type = kvm->arch.vm_type;
> +#elif defined(CONFIG_ARM64)
> +	ser->type = kvm_phys_shift(&kvm->arch.mmu);
> +	if (kvm_vm_is_protected(kvm))
> +		ser->type |= KVM_VM_TYPE_ARM_PROTECTED;
> +
> +#else
> +	ser->type = 0;
> +#endif

This needs to be properly supported with arch callbacks.  And per-arch enabling
needs to be done in separate patches.

> +
> +	args->serialized_data = virt_to_phys(ser);
> +	return 0;
> +}
> +
> +static atomic_t restored_vm_id = ATOMIC_INIT(0);
> +
> +static int kvm_luo_retrieve(struct liveupdate_file_op_args *args)
> +{
> +	char fdname[ITOA_MAX_LEN + 1];
> +	struct kvm_luo_ser *ser;
> +	struct file *file;
> +	struct kvm *kvm;
> +	int err = 0;
> +
> +	if (!args->serialized_data)
> +		return -EINVAL;
> +
> +	ser = phys_to_virt(args->serialized_data);

KVM generally uses __va() and __pa(), is there a reason to diverge?

