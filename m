Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C5CCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 15:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDC596B0088; Tue, 23 Jun 2026 11:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8E0F6B008A; Tue, 23 Jun 2026 11:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7BB86B008C; Tue, 23 Jun 2026 11:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A36E6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:27:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8165DC244B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:27:09 +0000 (UTC)
X-FDA: 84911555778.07.E760C6B
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id E6EDF140002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:26:59 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782228420;
	b=R//VwCpzU5Oxzgps8gBP+LJ7prgR8IwJ+JGuaphrgp9FhKx/aA2pmOSRRsE5JIGSNHMy1d
	3Dn/f2wPRL9W5hqyWCjrMNrUs4Ucoi/ov5a00ez6m+Tp5BWNFPxey/v54rC0brL4lRVBln
	4L+R4aI2Kqidis1SIBQedB6+5tAYlM8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782228420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=POq5WAcl76yaAXi1cUQuh7VATxHjgX7QPcwXsS7qv8s=;
	b=5e147wa4Qs+yhCJl0wYhnB8kHr99k5hmbCT/Ziht1Z9HiJ/ii7GTn9EhRQ1FqaJp0o3+ys
	D97LEZ8MDczb1SCGbSK1wy5cyHZO8jI7XRImn0Gu6I5t65VrP/xcJrDcFvFIJatXABEOKv
	PYwpvQJwkwnuoBXVP+kd73NDtJE2skQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ogNZu8yg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3waU6agkKCFABs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3waU6agkKCFABs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bdad545342aso652247666b.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782228418; x=1782833218; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=POq5WAcl76yaAXi1cUQuh7VATxHjgX7QPcwXsS7qv8s=;
        b=ogNZu8ygGeMcid4k4oJphA8OrnSP0+GwULXM+1qIiNoaB34wHNZ89iT2Q00oLCnsV3
         EZcHMX5UiRlbLny3lRV+D2t6juZjp0jp7HcvcrlBQF+E/LHony8lHWuggFARZK3gow5I
         Lbr1lmhjk96GVDa4wnSmSlqjPuLUWpaajallkYASSwJvkENhIi7H2fqCqSskKw1IBte9
         iXd07PpZzVMQkSe/Foznafh1uSW41waYe1r0G+mh5McMAnyyHYA2W19Aq42RRvmEvX/6
         tEn4RPwuEfLN+0y6W0vaUt2Ifiq32l4LGqMck6Gy9N7+5xhBXXqpcQhVh1DzQfzvZlMY
         yoOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782228418; x=1782833218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=POq5WAcl76yaAXi1cUQuh7VATxHjgX7QPcwXsS7qv8s=;
        b=JX9nsPFW2UlGqtp688VhEXtKacAtMJqG7fHZp3z41Un+38cYo3SZ/HUt0wiTrXXaHp
         yzXz5/R5KWuCdA2C2mrj6NBP00PodVK/rog1u5V83dLJD5+TFidISwgdtLE79KzJo0Il
         wnCr0Ksyyq15C5sevuPqwRRIVfR5zv5OiCVzsqtMexDnJBvDOUyBe2dDk34/LE8r53Kj
         XdxszJ7C6n4HmRyoJjRcmtnQbdE1NPXiHrqf07wEkWGORMyPimhDSvpkfuwxAREcI9OT
         UQ7gvUz0medkD74BBGNrBrdQDiitzSl8VyJN33Bq6gpxuF+mWcFu8oxllwUVO87BHPB7
         s56g==
X-Forwarded-Encrypted: i=1; AFNElJ8IF710NKFiXzOikRH1oOBIK2T7hv5wgpqO8EPKFw4N1l4vldWaURcgsO8eeRbJX17k7DwN6IJqRg==@kvack.org
X-Gm-Message-State: AOJu0YxDfntjsds0ZdbwlIVD23z+6YDOVVkfwl2oJWM6Z2XHmAg+dHDe
	Dv+MAG/PPdixzDkBaowUCnkzKFZ6dUDBcIvQUCGPh2pmS1mgJIVs/4kUZXMBLZhfM72jp6Qnsx1
	mAF/s+kxfNsM2ZsaRzg==
X-Received: from ejdi23.prod.google.com ([2002:a17:906:917:b0:beb:3f4a:8163])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:26c4:b0:c0e:89eb:f601 with SMTP id a640c23a62f3a-c108ecf7392mr192539966b.25.1782228417619;
 Tue, 23 Jun 2026 08:26:57 -0700 (PDT)
Date: Tue, 23 Jun 2026 15:26:57 +0000
In-Reply-To: <CAEvNRgGYM+evk5H-bU8suU++zX3-w25fcc+9mu1YoNG8DtysHw@mail.gmail.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com> <4b2216f5c459fe699a3f62464cbc765624e20ae6.1780676742.git.tarunsahu@google.com>
 <CAEvNRgGYM+evk5H-bU8suU++zX3-w25fcc+9mu1YoNG8DtysHw@mail.gmail.com>
Message-ID: <9huzqzlxmg5a.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 07/10] kvm: guest_memfd_luo: add support for
 guest_memfd preservation
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	fvdl@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, aneesh.kumar@kernel.org, 
	skhawaja@google.com, vipinsh@google.com, Pratyush Yadav <pratyush@kernel.org>, 
	david@redhat.com, dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com
Cc: linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-HE-Tag: 1782228419-155348
X-HE-Meta: U2FsdGVkX1+Uve84KXaq0f2jruv9N+JfnPD5+SIUR5Qw3MGUYwvNOa5ufiq0Dlt7JVj9+OvQEvWvGPucVneJITA2NktSa7yJslwVs15nx7Xs8asZ6Tds3ntRG27qoh24phVhWA9Mju13k+GIFRJSINy/v89RIcaMbdrDADMsALB9dRIGhqQQ69sqhwQqCUhdU7+Qt1xHktKGexTdueE6JAN5Hlz1Abr7XuwSI5FhjaaJIWtHH28d2GlzRK4TR61qfYn7u/vY/VxFr1/4c6dkJJK5p1zxONmmWwlSO7qlhszB46DDhmK2DoebLJErdsdrrjSOufKuLkRr+ANYtRy6cFVr2EkvNHgFi+HS9gRFE/p8/K9BhAU15xKh6aMGVrmqRnWdvPMryJ4fEosSD+1L+X3AQYERoRLmNdV6sy8z3Tc/Zw6qSFLDBhqOAEj+O1o+sn4UpCaZafKq4i1SNxE7bXaN4GIYY1PZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Thanks for reviewing!

Ackerley Tng <ackerleytng@google.com> writes:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>> This patch sets up the basic infrastructure to preserve the guest_memfd.
>> Currently this supports only fully shared guest_memfd and backed by
>> PAGE_SIZE pages.
>>
>> It registers a new LUO file handler for guest_memfd files to serialize
>> and deserialize guest memory. This allows preserving guest memory backed
>> by guest_memfd across updates, ensuring that guest instances can be
>> resumed seamlessly without losing their memory contents.
>>
>> Preservation is straight forward. It walks through the folios and
>> serialize them.
>>
>> There is kvm_gmem_freeze call on preserve which freeze the guest_memfd
>> inode. It avoids any changes to inode mapping with fallocate calls or
>> any new fault allocation (fails) on or after preservation. No need to check
>> this during the page fault as preservation is only supported for
>> pre-faulted/pre-allocated guest_memfd.
>>
>> While retrieving the guest_memfd, it requires the struct kvm to create
>> new guest_memfd. So it first get the vm_file from the same session using
>> the token passed during the preservation. And use it to get
>> vm_file->kvm.
>>
>> This change also update the MAINTAINERS list.
>>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> ---
>>  MAINTAINERS                 |   1 +
>>  include/linux/kho/abi/kvm.h |  79 +++++-
>>  virt/kvm/Makefile.kvm       |   2 +-
>>  virt/kvm/guest_memfd_luo.c  | 485 ++++++++++++++++++++++++++++++++++++
>>  virt/kvm/kvm_main.c         |   7 +
>>  virt/kvm/kvm_mm.h           |   4 +
>>  6 files changed, 571 insertions(+), 7 deletions(-)
>>  create mode 100644 virt/kvm/guest_memfd_luo.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 9bfc3c1f6676..16cba790a84d 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -14418,6 +14418,7 @@ L:	kexec@lists.infradead.org
>>  L:	kvm@vger.kernel.org
>>  S:	Maintained
>>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
>> +F:	virt/kvm/guest_memfd_luo.c
>>  F:	virt/kvm/kvm_luo.c
>>
>>  KVM PARAVIRT (KVM/paravirt)
>> diff --git a/include/linux/kho/abi/kvm.h b/include/linux/kho/abi/kvm.h
>> index 718db68a541a..42074d76e04a 100644
>> --- a/include/linux/kho/abi/kvm.h
>> +++ b/include/linux/kho/abi/kvm.h
>> @@ -9,20 +9,23 @@
>>  #define _LINUX_KHO_ABI_KVM_H
>>
>>  #include <linux/types.h>
>> +#include <linux/bits.h>
>>  #include <linux/kho/abi/kexec_handover.h>
>>
>>  /**
>> - * DOC: KVM Live Update ABI
>> + * DOC: KVM and guest_memfd Live Update ABI
>>   *
>> - * KVM uses the ABI defined below for preserving its state
>> + * KVM and guest_memfd use the ABI defined below for preserving their states
>>   * across a kexec reboot using the LUO.
>>   *
>> - * The state is serialized into a packed structure `struct kvm_luo_ser`
>> - * which is handed over to the next kernel via the KHO mechanism.
>> + * The state is serialized into packed structures (struct kvm_luo_ser and
>> + * struct guest_memfd_luo_ser) which are handed over to the next kernel via
>> + * the KHO mechanism.
>>   *
>> - * This interface is a contract. Any modification to the structure layout
>> + * This interface is a contract. Any modification to the structure layouts
>>   * constitutes a breaking change. Such changes require incrementing the
>> - * version number in the KVM_LUO_FH_COMPATIBLE compatibility string.
>> + * version number in the KVM_LUO_FH_COMPATIBLE or
>> + * GUEST_MEMFD_LUO_FH_COMPATIBLE compatibility strings.
>>   */
>>
>>  /**
>> @@ -36,4 +39,68 @@ struct kvm_luo_ser {
>>  /* The compatibility string for KVM VM file handler */
>>  #define KVM_LUO_FH_COMPATIBLE	"kvm_vm_luo_v1"
>>
>> +/**
>> + * struct guest_memfd_luo_folio_ser - Serialization layout for a single folio in guest_memfd.
>> + * @pfn:   Page Frame Number of the folio.
>> + * @index: Page offset of the folio within the file.
>> + * @flags: State flags associated with the folio.
>> + */
>> +struct guest_memfd_luo_folio_ser {
>> +	u64 pfn:52;
>> +	u64 flags:12;
>> +	u64 index;
>> +} __packed;
>> +
>> +/**
>> + * GUEST_MEMFD_LUO_FOLIO_UPTODATE - The folio is up-to-date.
>> + *
>> + * This flag is per folio to check if the folio is uptodate.
>> + */
>> +#define GUEST_MEMFD_LUO_FOLIO_UPTODATE	BIT(0)
>> +
>> +
>> +/**
>> + * GUEST_MEMFD_LUO_FLAG_MMAP - The guest_memfd supports mmap.
>> + *
>> + * This flag indicates that the guest_memfd supports host-side mmap.
>> + */
>> +#define GUEST_MEMFD_LUO_FLAG_MMAP		BIT(0)
>> +
>> +/**
>> + * GUEST_MEMFD_LUO_FLAG_INIT_SHARED - Initialize memory as shared.
>> + *
>> + * This flag indicates that the guest_memfd has been initialized as shared
>> + * memory.
>> + */
>> +#define GUEST_MEMFD_LUO_FLAG_INIT_SHARED	BIT(1)
>> +
>> +/**
>> + * GUEST_MEMFD_LUO_SUPPORTED_FLAGS - Supported guest_memfd LUO flags mask.
>> + *
>> + * A mask of all guest_memfd preservation flags supported by this version
>> + * of the KVM LUO ABI.
>> + */
>> +#define GUEST_MEMFD_LUO_SUPPORTED_FLAGS	(GUEST_MEMFD_LUO_FLAG_MMAP | \
>> +						 GUEST_MEMFD_LUO_FLAG_INIT_SHARED)
>> +
>> +/**
>> + * struct guest_memfd_luo_ser - Main serialization structure for guest_memfd.
>> + * @size:      The size of the file in bytes.
>> + * @flags:     File-level flags.
>> + * @nr_folios: Number of folios in the folios array.
>> + * @vm_token:  Token of the associated KVM VM instance.
>> + * @folios:    KHO vmalloc descriptor pointing to the array of
>> + *             struct guest_memfd_luo_folio_ser.
>> + */
>> +struct guest_memfd_luo_ser {
>> +	u64 size;
>> +	u64 flags;
>> +	u64 nr_folios;
>> +	u64 vm_token;
>> +	struct kho_vmalloc folios;
>> +} __packed;
>> +
>> +/* The compatibility string for GUEST_MEMFD file handler */
>> +#define GUEST_MEMFD_LUO_FH_COMPATIBLE	"guest_memfd_luo_v1"
>> +
>>  #endif /* _LINUX_KHO_ABI_KVM_H */
>> diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
>> index c1a962159264..d30fca094c42 100644
>> --- a/virt/kvm/Makefile.kvm
>> +++ b/virt/kvm/Makefile.kvm
>> @@ -13,4 +13,4 @@ kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
>>  kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
>>  kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
>>  kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
>> -kvm-$(CONFIG_LIVEUPDATE_GUEST_MEMFD) += $(KVM)/kvm_luo.o
>> +kvm-$(CONFIG_LIVEUPDATE_GUEST_MEMFD) += $(KVM)/guest_memfd_luo.o $(KVM)/kvm_luo.o
>> diff --git a/virt/kvm/guest_memfd_luo.c b/virt/kvm/guest_memfd_luo.c
>> new file mode 100644
>> index 000000000000..d466f889c9aa
>> --- /dev/null
>> +++ b/virt/kvm/guest_memfd_luo.c
>> @@ -0,0 +1,485 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +/*
>> + * Copyright (c) 2026, Google LLC.
>> + * Tarun Sahu <tarunsahu@google.com>
>> + *
>> + * Guestmemfd Preservation for Live Update Orchestrator (LUO)
>> + */
>> +
>> +/**
>> + * DOC: Guestmemfd Preservation via LUO
>> + *
>> + * Overview
>> + * ========
>> + *
>> + * Guest memory file descriptors (guest_memfd) can be preserved over a kexec
>> + * reboot using the Live Update Orchestrator (LUO) file preservation. This
>> + * allows userspace to preserve VM memory across kexec reboots.
>> + *
>> + * The preservation is not intended to be transparent. Only select properties
>> + * of the guest_memfd are preserved, while others are reset to default.
>> + *
>> + * Preserved Properties
>> + * ====================
>> + *
>> + * The following properties of guest_memfd are preserved across kexec:
>> + *
>> + * File Size
>> + *   The size of the file is preserved.
>> + *
>> + * File Contents
>> + *   All folios present in the page cache are preserved.
>> + *
>> + * File-level Flags
>> + *   The file-level flags (such as MMAP support and INIT_SHARED default mapping)
>> + *   are preserved.
>> + *
>> + * Non-Preserved Properties
>> + * ========================
>> + *
>> + * NUMA Memory Policy
>> + *   NUMA memory policies associated with the guest_memfd are not preserved.
>> + */
>> +#include <linux/liveupdate.h>
>> +#include <linux/kvm_host.h>
>> +#include <linux/pagemap.h>
>> +#include <linux/file.h>
>> +#include <linux/err.h>
>> +#include <linux/anon_inodes.h>
>> +#include <linux/magic.h>
>> +#include <linux/kexec_handover.h>
>> +#include <linux/kho/abi/kexec_handover.h>
>> +#include <linux/kho/abi/kvm.h>
>> +#include "guest_memfd.h"
>> +
>> +static int kvm_gmem_luo_walk_folios(struct address_space *mapping,
>> +		pgoff_t end_index, struct guest_memfd_luo_folio_ser *folios_ser,
>> +		u64 *out_count)
>> +{
>> +	struct folio_batch fbatch;
>> +	pgoff_t index = 0;
>> +	u64 count = 0;
>> +	int err = 0;
>> +
>> +	folio_batch_init(&fbatch);
>> +	while (index < end_index) {
>> +		unsigned int nr, i;
>> +
>> +		nr = filemap_get_folios(mapping, &index, end_index - 1, &fbatch);
>> +		if (nr == 0)
>> +			break;
>> +
>> +		for (i = 0; i < nr; i++) {
>> +			struct folio *folio = fbatch.folios[i];
>> +
>> +			if (folios_ser) {
>> +				if (folio_test_hwpoison(folio)) {
>> +					err = -EHWPOISON;
>> +					folio_batch_release(&fbatch);
>> +					goto out;
>> +				}
>> +				err = kho_preserve_folio(folio);
>> +				if (err) {
>> +					folio_batch_release(&fbatch);
>> +					goto out;
>> +				}
>> +
>> +				folios_ser[count].pfn = folio_pfn(folio);
>> +				folios_ser[count].index = folio->index;
>> +				folios_ser[count].flags = folio_test_uptodate(folio) ?
>> +							  GUEST_MEMFD_LUO_FOLIO_UPTODATE : 0;
>> +			}
>> +			count++;
>> +		}
>> +		folio_batch_release(&fbatch);
>> +		cond_resched();
>> +	}
>> +
>> +out:
>> +	*out_count = count;
>> +	return err;
>> +}
>> +
>> +static bool kvm_gmem_luo_can_preserve(struct liveupdate_file_handler *handler, struct file *file)
>> +{
>> +	struct inode *inode = file_inode(file);
>> +	struct gmem_file *gmem_file = file->private_data;
>> +	struct kvm *kvm = gmem_file->kvm;
>> +
>> +	if (inode->i_sb->s_magic != GUEST_MEMFD_MAGIC)
>> +		return 0;
>> +
>
> How does .can_preserve decide route to this function? If it already
> routes here, wouldn't this inode definitely be a guest_memfd file?

No.
kvm_gmem_luo_handler {
                 ...
                 .ops.can_preserve = kvm_gmem_luo_can_preserve;
                 ...
                 }

.can_preserve is eligiblity call. LUO preservation ioctl can be
called by any type of file (for example: memfd file). LUO internally
loops through all the registered handler (memfd_luo handler, kvm_luo
handler, guest_memfd_luo handler etc) and call their can_preserve
function, which is kvm_gmem_luo_can_preserve, For memfd file, it will
return false and for guest_memfd it will return true.

In short: This function is used to filter the handler for the
guest_memfd file. We have additional checks to filter only the
guest_memfd file which we currently support for the preservation.

>
>> +	if (kvm_arch_has_private_mem(kvm))
>> +		return 0;
>> +
>> +	if (mapping_large_folio_support(inode->i_mapping))
>> +		return 0;
>> +
>> +	return 1;
>
> Let's return true and false rather than relying on casting.

ACK. Will update it.
>
>> +}
>> +
>> +static int kvm_gmem_luo_preserve(struct liveupdate_file_op_args *args)
>> +{
>> +	struct guest_memfd_luo_folio_ser *folios_ser = NULL;
>> +	u64 count = 0, gmem_flags, abi_flags = 0;
>> +	struct guest_memfd_luo_ser *ser;
>> +	struct address_space *mapping;
>> +	struct gmem_file *gmem_file;
>> +	struct inode *inode;
>> +	pgoff_t end_index;
>> +	struct kvm *kvm;
>> +	int err = 0;
>> +	long size;
>> +
>> +	inode = file_inode(args->file);
>
> I think to lock out all allocates, you'd have to take
> filemap_invalidate_lock() before freezing.

No need, freeze wait for synchronisation. Only after current,
allocation finishes (future allocation as blocked by freeze = true),
It will proceed further.

>
>> +	kvm_gmem_freeze(inode, true);
>> +
>> +	mapping = inode->i_mapping;
>> +	size = i_size_read(inode);
>> +	if (!size) {
>> +		err = -EINVAL;
>> +		goto err_unfreeze_inode;
>> +	}
>> +
>> +	if (WARN_ON_ONCE(!PAGE_ALIGNED(size))) {
>> +		err = -EINVAL;
>> +		goto err_unfreeze_inode;
>> +	}
>> +
>> +	gmem_file = args->file->private_data;
>> +	kvm = gmem_file->kvm;
>> +
>> +	gmem_flags = READ_ONCE(GMEM_I(inode)->flags);
>> +	if (gmem_flags & ~(GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED
>
> Why condition this on MMAP?

Here, It is only checking what flags are set in gmem inode. Currently,
gmem inode (not talking about preservation here) supports three flags
MMAP, INIT_SHARED and FROZEN. So, other than that if there are any
flags, We fail preservation with -EOPNOTSUPP.

>
> After conversions lands, we'd have to iterate to check that the entire
> guest_memfd is shared offset-by-offset instead of checking for
> INIT_SHARED.

This is unrelated to comment to the code snippet here: but we can
disucss this as it is good question.

I object it. It will not be needed. If in-place coversion lands first or
after this preservation series. There will no affect to the preservation
series (IMHO, IIUC). I have following two checks in V3:
https://lore.kernel.org/all/20260622184851.2309827-7-tarunsahu@google.com/#:~:text=static%20bool%20kvm_gmem_luo_can_preserve,0%3B%0A%2B%0A%2B%09return%201%3B%0A%2B%7D

INIT_SHARED: Which makes sure that initially, the guest_memfd was
completely shared, when created.
!kvm_arch_has_private_mem(): Avoids Any future conversion.

So, If these two checks are passed, that means guest_memfd file does
not have any private pages. So we can preserve it. This is also aligns
with logic in in-place conversion series.

>
>> +				| GUEST_MEMFD_F_MAPPING_FROZEN)) {
>
> This would always be true since kvm_gmem_freeze() is done above.

Like, I said above, it is just checking if there are any flags set other
than these three.

>
>> +		err = -EOPNOTSUPP;
>> +		goto err_unfreeze_inode;
>> +	}
>> +
>> +	if (gmem_flags & GUEST_MEMFD_FLAG_MMAP)
>> +		abi_flags |= GUEST_MEMFD_LUO_FLAG_MMAP;
>> +	if (gmem_flags & GUEST_MEMFD_FLAG_INIT_SHARED)
>> +		abi_flags |= GUEST_MEMFD_LUO_FLAG_INIT_SHARED;
>> +
>
> Is it intentional to have a different set of flags that are actually
> preserved? I think we should refactor out a function to transfer the
> flags over.

To have backward compatiblity with userspace ABI. the flags
must be constant across different version of kernel. In the
file include/linux/kho/abi/kvm.h

I have defined these two flags, and they will be certain to be
constant across different version of kernel. Internal flags might
change their name, but externally, this will remain constant.

gmem_inode->flags (internal kernel variablity)
                   |
                   v
"userspace defined gmem_inode flags" => preserve

<KEXEC to new kernel version>

retrieve => "userspace defined gmem_inode flags"
                   |
                   v
gmem_inode->flags (internal kernel variablity)

Ack on refactoring out the logic: Will take care of that in next
revision v4.

>
>> +	end_index = size >> PAGE_SHIFT;
>> +
>> +	ser = kho_alloc_preserve(sizeof(*ser));
>> +	if (IS_ERR(ser)) {
>> +		err = PTR_ERR(ser);
>> +		goto err_unfreeze_inode;
>> +	}
>> +
>> +	/* First pass: Count the folios present in the page cache */
>> +	err = kvm_gmem_luo_walk_folios(mapping, end_index, NULL, &count);
>> +	if (err)
>> +		goto err_free_ser;
>> +
>> +	ser->size = size;
>> +	ser->flags = abi_flags;
>> +	ser->nr_folios = count;
>> +	ser->vm_token = 0; // It will be set during the kvm_gmem_luo_freeze()
>
> I don't think // is commonly used.

Will take care of such instances.

>
>> +
>> +	if (count > 0) {
>> +		folios_ser = vcalloc(count, sizeof(*folios_ser));
>> +		if (!folios_ser) {
>> +			err = -ENOMEM;
>> +			goto err_free_ser;
>> +		}
>> +
>> +		/* Second pass: Fill the metadata array and preserve folios */
>> +		err = kvm_gmem_luo_walk_folios(mapping, end_index, folios_ser, &count);
>
> I think it's clearer to just define 2 functions rather than using the
> same function twice to do these different things. The comments on the
> two passes can then be dropped.

I have single function to avoid duplication of the same code.

>
>> +		if (err)
>> +			goto err_unpreserve_unlocked;
>> +
>> +		if (WARN_ON_ONCE(count != ser->nr_folios)) {
>> +			err = -EINVAL;
>> +			goto err_unpreserve_unlocked;
>> +		}
>> +	}
>> +
>> +	if (count > 0) {
>> +		err = kho_preserve_vmalloc(folios_ser, &ser->folios);
>> +		if (err)
>> +			goto err_unpreserve_unlocked;
>> +	}
>> +
>> +	args->serialized_data = virt_to_phys(ser);
>> +	args->private_data = folios_ser;
>> +
>> +	return 0;
>> +
>> +err_unpreserve_unlocked:
>> +	for (long i = (long)count - 1; i >= 0; i--) {
>
> Not sure if it's common to define long i inline.

I will correct it. Good fine. thanks.

>
>> +		struct folio *folio = pfn_folio(folios_ser[i].pfn);
>> +
>> +		kho_unpreserve_folio(folio);
>> +	}
>> +	vfree(folios_ser);
>> +err_free_ser:
>> +	kho_unpreserve_free(ser);
>> +err_unfreeze_inode:
>> +	kvm_gmem_freeze(inode, false);
>> +	return err;
>> +}
>> +
>> +static int kvm_gmem_luo_freeze(struct liveupdate_file_op_args *args)
>> +{
>> +	struct guest_memfd_luo_ser *ser;
>> +	struct gmem_file *gmem_file;
>> +	struct kvm *kvm;
>> +	struct file *kvm_file;
>> +	u64 vm_token;
>> +	int err;
>> +
>> +	if (WARN_ON_ONCE(!args->serialized_data))
>> +		return -EINVAL;
>> +
>> +	ser = phys_to_virt(args->serialized_data);
>> +
>> +	gmem_file = args->file->private_data;
>> +	kvm = gmem_file->kvm;
>> +
>> +	/*
>> +	 * Obtain a strong reference to kvm->vm_file to prevent the SLAB_TYPESAFE_BY_RCU
>> +	 * file memory from being reallocated while it is being processed.
>> +	 */
>> +	kvm_file = get_file_active(&kvm->vm_file);
>> +	if (!kvm_file)
>> +		return -ENOENT;
>> +
>> +	err = liveupdate_get_token_outgoing(args->session, kvm_file, &vm_token);
>> +	fput(kvm_file);
>> +	if (err)
>> +		return err;
>> +
>> +	ser->vm_token = vm_token;
>> +	return 0;
>> +}
>> +
>> +static void kvm_gmem_luo_discard_folios(
>> +	const struct guest_memfd_luo_folio_ser *folios_ser,
>> +	u64 nr_folios, u64 start_idx)
>> +{
>> +	long i;
>> +
>> +	for (i = start_idx; i < nr_folios; i++) {
>> +		struct folio *folio;
>> +		phys_addr_t phys;
>> +
>> +		if (!folios_ser[i].pfn)
>> +			continue;
>> +
>> +		phys = PFN_PHYS(folios_ser[i].pfn);
>> +		folio = kho_restore_folio(phys);
>> +		if (folio)
>> +			folio_put(folio);
>> +	}
>> +}
>> +
>> +static void kvm_gmem_luo_unpreserve(struct liveupdate_file_op_args *args)
>> +{
>> +	struct guest_memfd_luo_folio_ser *folios_ser = args->private_data;
>> +	struct guest_memfd_luo_ser *ser;
>> +	long i;
>> +
>> +	if (WARN_ON_ONCE(!args->serialized_data))
>> +		return;
>> +
>> +	ser = phys_to_virt(args->serialized_data);
>> +	if (!ser)
>> +		return;
>> +
>> +	if (ser->nr_folios > 0)
>> +		kho_unpreserve_vmalloc(&ser->folios);
>> +	for (i = ser->nr_folios - 1; i >= 0; i--) {
>> +		struct folio *folio;
>> +
>> +		if (!folios_ser[i].pfn)
>
> Is it possible for pfn to be 0 here? Perhaps this should be a
> WARN_ON_ONCE().

In LUO design, We explicitly assumed, that pfn 0 is invalid.
Looping +Pratyush for more context.

Yes, WARN_ON_ONCE makes sense. I will update it.

>
>> +			continue;
>> +
>> +		folio = pfn_folio(folios_ser[i].pfn);
>> +		kho_unpreserve_folio(folio);
>> +	}
>> +	vfree(folios_ser);
>> +
>> +	kho_unpreserve_free(ser);
>> +	kvm_gmem_freeze(file_inode(args->file), false);
>> +}
>> +
>>
>> [...snip...]
>>
Thanks,
Tarun



