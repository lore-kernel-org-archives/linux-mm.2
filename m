Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF71CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 17:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE766B0005; Thu, 28 May 2026 13:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 848CE6B008A; Thu, 28 May 2026 13:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70FBF6B008C; Thu, 28 May 2026 13:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 584026B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:20:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1BD912089F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:20:35 +0000 (UTC)
X-FDA: 84817492830.16.F8FCF90
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id C51104000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:20:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=huVJTU1I;
	spf=pass (imf04.hostedemail.com: domain of 3X3kYagkKCAw5m36z4mt6s00sxq.o0yxuz69-yyw7mow.03s@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3X3kYagkKCAw5m36z4mt6s00sxq.o0yxuz69-yyw7mow.03s@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779988834; a=rsa-sha256;
	cv=none;
	b=Ie0pZP1H4B2UAFq5g0q9N5ETQi1BPyl1JTHaoqXsMDNqbMaXK5aA0r6CJcirSP0zCaq+ML
	P5Q8TpeWsVg/8uoJbinvxa2Mu+hQGSmTP3bvSxNTUwySEmSfmkeJ4So5TF7RZr0Xv0ThPB
	nYBEfXnFX4GLbwnsLehH8azhe0zCM4A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=huVJTU1I;
	spf=pass (imf04.hostedemail.com: domain of 3X3kYagkKCAw5m36z4mt6s00sxq.o0yxuz69-yyw7mow.03s@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3X3kYagkKCAw5m36z4mt6s00sxq.o0yxuz69-yyw7mow.03s@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779988834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1jqnliR98jneaD+lQwah17DldevvtYlAZzFvc5/oGg=;
	b=QBv8QjXI7fmAZOv6oXZq4xpI0nCTMhtaWY+M0xxk3u7sQQwxPgIS+fMd9U+Z7ZoMVwLzXD
	fKjuSfEuZzla4j9P9tXHdNmYSGZaSplpn0wFWfnUPuybQg2PUe3FGRdz3IDgBvTWYelX+e
	xE5baAr/oj9UVDUjFENK00FBHWOjY9k=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-bd68244c455so1019248066b.2
        for <linux-mm@kvack.org>; Thu, 28 May 2026 10:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779988832; x=1780593632; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G1jqnliR98jneaD+lQwah17DldevvtYlAZzFvc5/oGg=;
        b=huVJTU1IHIskSpZlsJRBQjt1zim8VdMzX+g+dJPU1dJZHtwbM8H+M5WwqKQ0wCcIA/
         ndAkDLvGa1ELTGH5ALoBcZHEAMwawxKtpffyQ5zlBgg+IuiDmfH0QP/211xg+a3RLB7o
         cH+EG49QyxUiufnTEqgPJKD69UDYee1sKQvjXJnY5UV+G0yvOPqttIiXbS8ph6mBR5/V
         KOM91r6eHFqXj8lZCRYaDkZmGgoNXucOgru09JmU1kCpFY5VH4FRqYAjmaYQ3flqyCcL
         bG6PBCzilW1iCFhqOlBL4P15VBS7zU+HOnTDxeyuusfq3FCWzEUkSp4RDYxgjAyVoIMJ
         WNMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779988832; x=1780593632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G1jqnliR98jneaD+lQwah17DldevvtYlAZzFvc5/oGg=;
        b=n3HQSz6jorrO1qmGioJcpMeQaKMWCfPF69pRcwdxOBF5UnTEP2Ry6ZYu4iXXEFHDv6
         FxMyQLo+b18IMNoLwYV2bL8j3H2qTyUy2wY90poOEl16fL7rqb+4AknJ/qUCqxKAmenH
         oCrk/JuL05mjtYn1O5WGvI6ij5tD9ik5u7RZxS2qQLZKd0ByhmJYuWyytZeYyYH1tOIX
         NGf/lM4/dA0diIOt3wHt2+K39YCVH5pef9jKffEKAbcBdhZ8h4HP+b0H4XWb6bEqOh/0
         vN+HinVpf2xJsL2Xmq0IPlKp6kB3xdMDvj9jZcb+OtSKSNYAqBmhuIRdHkx6jr0geNT9
         3ECQ==
X-Forwarded-Encrypted: i=1; AFNElJ/CerpRzy8RPUwRJl+Tlu+NYq92w6SBgxfp6rjnY6T9sbgz0i4ZP1u2Pc3fpMDnSnc0Cb9vdQZtsw==@kvack.org
X-Gm-Message-State: AOJu0YzPJlsnvVJtw2Ul7uzN2yX9xmep0BoHp5tSe66YUHhVzMolWSkz
	JrWfuZuEtJXvacsvJ1ItqNdSY0iPGjEr58zaTCwfw5b2tmPpKUYQJkH1kjPuAnhTl+rj+f9Yuau
	xmqvd1DXJjcHApW22UA==
X-Received: from edbay13.prod.google.com ([2002:a05:6402:202d:b0:67c:4a59:4f8d])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3d49:b0:bde:4dd2:6312 with SMTP id a640c23a62f3a-be974019025mr6289866b.37.1779988831481;
 Thu, 28 May 2026 10:20:31 -0700 (PDT)
Date: Thu, 28 May 2026 17:20:30 +0000
In-Reply-To: <cover.1779080766.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1779080766.git.tarunsahu@google.com>
Message-ID: <9huzwlwnbgdd.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v1 0/8] liveupdate: kvm: Guest_memfd preservation
From: tarunsahu@google.com
To: axelrasmussen@google.com, mark.rutland@arm.com, skhawaja@google.com, 
	Mike Rapoport <rppt@kernel.org>, sagis@google.com, Jason Gunthorpe <jgg@ziepe.ca>, 
	Shuah Khan <shuah@kernel.org>, ackerleytng@google.com, corbet@lwn.net, 
	dmatlack@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, vannapurve@google.com, 
	Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, aneesh.kumar@kernel.org, 
	vipinsh@google.com, Alexander Graf <graf@amazon.com>, David Hildenbrand <david@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kexec@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: C51104000C
X-Rspamd-Server: rspam03
X-Stat-Signature: rff8i8x9mdyo61r7c7enejdrua4rkrhd
X-HE-Tag: 1779988833-219846
X-HE-Meta: U2FsdGVkX190QmhorhFgsyilFgeqqBVXes0/qhJGptPmCsSJwogdQhm5gt1Ks5AHA8VQVYUfuT7qmmfgASVSwvgzelYTj2S/TjgjcUK/a98HLlX9Hrlj45mOjPPH92MVUW1H2Lq6MTPq1+5JyZtc5jXzCWSMLYYRLaLX21ww48AiQAFfuVPvxStzSGO4HsXWMO9DEmocBXhiozOohJFznOp7nUDyQe2BFl712GUFylEzEjNow3vwESXe7RkyimeKHgj0FXGkNlY8CGcGVx/NEvFGcLMvJNBaS9TdHXdhGnWEYL/RctPEzp7MN2g/1sHW1YchcH/oQNGhCgfKRoyDKoDUo52PAAvTzwSpTF0GaNEWZxQxZNK1rTJicdMO/fZachwOB7Ruuvak0lTsqMBa3t9wIRYI10DRzzPpp2GTrc1nxCuRsiytfAmIA6L3WoiWyDmgom4hH2FEy68kFcRriEAvr0fCY8KIY2xNjmtNWKVGs66y1vIKbdgm5pjig9g+pUdYXMxKu+zC67eegkRJ+IsGpBHY5jxmnsM300vFguCTnSpa/Yh9ueQjBaQ8CBhL9Bdv3qqRKMZznqH02jVbHVtmIoQVohLfocA/hCbxx9pj7eV7pdXPp/LBV7nc2nmSrHf25AqHXZTMVm0DEHUkQ+bEpS9CS8pjmrINLot2ZMP1r2XDc+2O9RdCgyimOQZDzaBSryWXYSLpj2uPTlzSOk06YjEULZDT1SWyGWvQaIE8ViPxQpPqH9oaA0hcelnMQ6I2poAMUf9OoJsBIZPnPRfUD9rZP/U+rpFPxEieKNRhEpP2PEIe9aWjgJRoszWCB06/RNVKLi+/fqnmZ/kmj+jGYIsZTLKhrqyjF9xbQXUcqGwDmgQSHeR++jZR5pdaMOgdCRJrl72AxFPTPEfKSr96cYd7zGz/yXQOYhEKUlrLL4BMEH6x9eeJh/ja67Qorn+Sv9grr0Bx8vZMnzU
 rFclNQIV
 zruH+4OMxeNkg3pnwIwWh95gunTuhHjy8i2vdWGggkNJF3eZhPrf2+vbh2V97uFQrzA8xgH8k7md8nKirJpDLCyQY2ZKnjzS+mZwhNTVS0SaXR7fuR1Xrtk5+K4qN0ydcSBTfVbL0RBdPY/u5u85/ULqVfL0rJVd4LSViYFSygWbh6oBBljmrkfGfzK54YQAO5kot/Y20MlKMucWedTMfTEJvCN/7hH4fCFtxHL/x3TbEMVsSHW59AJZNCC1B9Z8QAzoFFP027L87sbvsY/PZs0SlZ28hbN6RFiyPviNMC6hZStb8uRRJFU0/LjdYxUvluNKA4NYYHc9USauTmY1lnmU5K5AfVlOWCveX9fY+srpTojnauwrSwaHHC5FuRSbEiLy6lvpL4/oRNKPPuwtQpp7U7T+8CDI+rB7kEWVsEkWuwh+VkwMCFgwOahu71p8Oc8czSLQ5zD2YIaiW2QyLipwv/MjMhZOFI1bcTT+Xh5VFr+TTttRet3NzfzoYflxq7as3rgHbkhHfmDrQLlxn/SYpIVx4/ganl1FcFvJC5ifA9qicsoF74nPgzMfW8Y5AkANjkaIOs82mJrhsfUakeFOfau+/nYD6EV/nvXmrK/owN4G9JN7mQu14Mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tarun Sahu <tarunsahu@google.com> writes:


Hi,

Based on the discussion on Bi-weekly guest_memfd upstream call.

The following suggestions are made:
1. Remove the prefaulted condition and During preservation, let the VMM
   have the policy to either pause the VM or avoid any upcoming faults/conversion
   (conversion is not part of this series, but design concept for future
   extension) occurs. If new fault/conversion requests are originated,
   Kernel will return error to notify VMM.

   In future, We will revisit if this functionality can be extended
   to handle post-preserve fault/conversion with having data on preservation
   latency and complexity. Pratyush is already working on implementing
   similar thing for memfd and hugetlb preservation.

2. We are going with preserving the vm file along with guest_memfd file

3. No need to preserve kvm->mem_attr_array, as this is on deprecating
   path and For this series, where only fully shared guest_memfd is
   supported for liveupdate, preservation of these attributes not
   required.

Due to time constraints:
we have one open Question left:
1. How to check guest_memfd is fully shared. Currently that is being
   done by INIT_SHARED flag. But with in-place it is going to change
   its meaning and it will mean only durng the creation of guest_memfd
   it is shared whose folios can be converted to private.
   So for this series, I am looking for suggestion, what is the best way
   to find the sharedness of guest_memfd which will be compatible with
   in-place series. OR we can go like this (my personnel recommendation):

   if (guest_memfd_is_fully_shared())
      return true; // support the preservation

   // This series
   int guest_memfd_is_fully_shared(void) {
       if (guest_memfd->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
          return true;
         return false;
   }

   TO::
   // Once in-place conversion series lands.
   int guest_memfd_is_fully_shared(void) {
       if (No Private flags in (guest_memfd->attributes))
          return true;
         return false;
   }

~ Tarun


> Hello,
>
> I am proposing this series as RFC, to initiate the discussion for
> supporting the guest_memfd preservation. This will setup basic arhitecture
> for VM preservation during liveupdate. This Cover letter has three
> sections (please feel free to skip the on you already know):
>
> A. Guest_memfd introduction:
> To make the audience familiar with guest_memfd
> B. Liveupdate introduction:
> To make the audience familiar with liveupdate
> C. Actual Implementation Design and questions.
>
> **GUEST MEMFD INTRODUCTION**
>
> Initially, guest_memfd was created to support guest private memory in
> confidential computing VMs (CoCo VMs). It was designed so that whenever
> a guest wants to grant the host access to private memory, a series of
> calls occurs: from the guest to KVM, KVM to the host userspace, host
> userspace back to KVM, and finally a new page fault maps the memory into
> a separate shared address space. Conversely, if the guest transitions the
> memory back to private, the subsequent fault is handled by guest_memfd.
> (Dual Mapping Architecture). In such a VM, all guest memory is initially
> shared. On the fly, the guest may request to change pages to private; the
> metadata indicating which parts of memory are private is stored in an
> xarray inside struct kvm (mem_attr_array). This array serves as the source
> of truth for the fault mechanism, determining whether a mapping should be
> created from host-userspace-mapped pages or directly from the guest_memfd
> file. For private memory, Fault also calls architecture-specific function
> to set up private hardware access (e.g., on SEV-SNP or TDX). This type of
> guest_memfd is fully-private where shared mapping comes from userspace
> mapped address space.
>
> Subsequently, support was added to allow the entire guest memory to be
> backed by guest_memfd. This led to the implementation of the MMAP and
> INIT_SHARED flags for the guest_memfd inode. When KVM_CREATE_GUEST_MEMFD
> is called with these flags, the guest_memfd becomes mmap-able by host
> userspace. The INIT_SHARED flag is used to make the guest_memfd completely
> shared between the host and the guest. Consequently, page faults from both
> host userspace and the guest resolve to the same guest_memfd page cache.
> However, under this configuration, marking a portion of this memory as
> private is not possible. This type of guest_memfd is fully-shared.
>
> If guest_memfd is created with INIT_SHARED without MMAP, the host
> can never access the guest_memfd. But the memory is still considered
> shared.
>
> Hence, At this point, Only use-case of guest_memfd is either fully-shared
> or fully-private.
>
> There is ongoing work to make shared and private mapping in-place backed
> by guest_memfd. [1] There is also ongoing work to back guest_memfd by
> hugetlb pages. [2]
>
> **LIVEUPDATE INTRODUCTION (LIVEUPDATE ORCHESTRATOR - LUO)**
>
> Livepdate support was added in kernel to update the host kernel by
> minimizing the downtime to minimal. This is generally achieved by
> preserving the current state of the system and retrieve after boot to
> resume from where we left it.
>
> Any subsystem that wants to preserve themselves, register their handler
> with liveupdate system. This handler includes calls to the following
>
> *can_preserve (file)*:
> This tells the luo system about the eligibility of the file. When
> preserve ioctl is called, it first loop through all the file handlers
> and call can_preserve, the one which return true, luo uses this file
> handler fh->preserve call to preserve the file.
>
> *preserve(file)*:
> This actually preserves the file.
>
> *unpreserve(file)*:
> This unpreserve the file incase userspace want to go back.
>
> *retrieve(file)*:
> On new kernel boot, this function retrieves the file.
>
> *finish(file)*:
> When userspace decides that all the files in the liveupdate session has
> been retrieved, it can trigger this to do final work of cleaning up.
>
> LUO preserve its memory using KHO (kexec-handover). All these APIs will
> be implemented using KHO calls.
>
> **GUEST MEMFD PRESERVATION**
>
> This patch sets up the basic infrastructure to preserve the guest_memfd.
> Currently this supports only fully-shared, pre-faulted guest_memfd
> (INIT_SHARED) backed by PAGE_SIZE pages.
>
> It registers a new LUO file handler for guest_memfd file to serialize
> and deserialize guest memory. This allows preserving guest memory backed
> by guest_memfd across updates, ensuring that guest instances can be
> resumed seamlessly without losing their memory contents.
>
> The preservation call is straight forward. It walks through the page
> cache, serialize the folios and preserve them.
>
> On the retrieval path:
> Currently, creating a guest_memfd requires an associated struct kvm
> (derived from vm_file / vm_fd). Since there is no direct way to pass a
> VM file descriptor via the LUO API, we considered two main approaches:
>
> Approach (1)
> Split the KVM_CREATE_GUEST_MEMFD ioctl into two separate ioctl: one
> to create the guest_memfd without a VM file (without struct kvm)
> descriptor, and another to attach a newly created VM file descriptor to
> a retrieved guest_memfd.
>
> Introducing a new ioctl is in itself a problem (UAPI). Currently, a
> guest_memfd file belongs to a single VM. Decoupling creation and
> attachment could allow a guest_memfd to be attached to any VM, or shared
> among multiple VMs when passed at different offsets. Fully supporting
> this feature would require extensive work, and it is unclear if there
> are any non-LUO use cases that justify this complexity.
> There is related work going on here [4], but not exactly same. It still
> does not allow guest_memfd to be created without vm_fd. But there be
> other ways to use it, I would like to discuss the idea.
>
> Approach (2)
> Leverage a companion patch [3] (Also added as part of this series
> PATCH[1]) that allows one file to retrieve another file from the same LUO
> session. This enables the guest_memfd retrieval path to obtain the
> preserved KVM file, use it during guest_memfd file creation, and
> subsequently populate its preserved memory.
>
> Preserving the KVM file allows us to preserve additional VM-specific
> metadata, which will be crucial in the future for cleanly resuming the
> VM. Currently, it preserves only the VM type and kvm->mem_attr_array.
>
> Though the ongoing in-place sharing series [1] transfers attributes to
> the guest_memfd file, But preserving the kvm file opens the opportunity
> to preserve other VM state in future like registers state, vCPU etc.
>
> Having the extensive usecases for preserving the kvm file, I went
> ahead with Approach (2). In future, if approach (1) become possible, it
> can easily be integrated with approach (2).
>
> Following the first approach (preserving vm_fd along with guest_memfd),
>
> ** VM FILE LIVEUPDATE ** PATCH[3] && [4]
>
> *PATCH[3]* has refactored few functions to support kvm preservation.
> During retrieval, vm_file needs to be recreated which will require kvm
> api. This patch exports those APIs. There is a new addition to struct
> kvm, vm_file. Which will be used by guest_memfd. I will discuss about
> this later.
>
> *PATCH[4]*
> The preservation of the vm file is straightforward.
>
> On the retrieval path:
> KVM normally requires a unique identifier (fdname) upon creation,
> which KVM typically assigns based on the newly created file descriptor
> number. However, in the LUO retrieval path, the retrieve call restores
> the underlying file structure and delegates actual file descriptor
> allocation to LUO (check luo_session_retrieve_fd). Currently, I used an
> atomically incremented sequence number as the fdname. I would like to
> discuss whether userspace services rely on specific naming conventions
> here. Or if we can change underlying the retrieve call
> (luo_retrieve_file) to pass fd?
>
> **GUEST_MEMFD FILE LIVEUPDATE** PATCH[5], [6] & [7]
>
> *PATCH[5]*
> During retrieval of guest_memfd file, for its creation, this patch has
> exported APIs from guest_memfd.c to be used for guest_memfd_luo.c
>
> *PATCH[6]*
> This patch implements the API for gmem inode freeze, which freeze the
> fallocate operation on this inode. Freeze check can be extended in
> future to prevent new page faults as well, when liveupdate support
> for non-pre-faulted guest_memfd will be implemented.
>
> *PATCH[7]*
> Preservation Path:
> We have discussed about this before,
> I would like to add to that and discuss here a major design decision:
> "Preservation order in between VM File and guest_memfd file"
>
> Preservation Ordering is required because guest_memfd needs to store
> vm file token as one of its data, which it can use during retrieval to
> get the vm file and use (file->private_data: struct kvm ) for its
> creation using [3]. So KVM file must be preserved before guest_memfd
> file, so that guest_memfd preserve call can find vm file token from the
> same luo session.
>
> Currently My preservation implementation does not require any strict
> ordering, they can be preserved in any sequence from userspace. I
> achieved this by implementing the freeze call for guest_memfd which
> gets run at the end just before kexec. This call freeze the luo session
> and no further changes can be done to the session. Inside guest_memfd
> luo_freeze handler, I update the token for vm_file. Which enable us to
> preserve the vm file and guest_memfd file in any order.
>
> The drawback is, incase vm_file is not preserved, freeze will fail. And
> in enforcing the preserving order fails the guest_memfd preservation
> from the start. As with VM preservation will evolve in future, it will
> keep getting complicated so avoiding the preservation order should be
> the better choice to make the userspace simpler. I would be happy to
> disucss on this further.
>
> To get the token, we need the vm_file and there is no way to get the
> vm_file from the struct kvm, as guest_memfd file only store the
> struct kvm. I have introduced a new member in struct kvm, vm_file.
> But with weak circular dependency as it is just to get the pointer
> for the file. we don't want to keep the reference of the file as vm_file
> takes for the kvm to keep itself (vm_file) alive. So whenever there is a
> need to use of kvm->vm_file, we take the reference and drop it suddenly.
>
> Retrieval Path:
> During retrieval path, we just retrieve the data from kho and populate
> into the newly created guest_memfd.
> To create guest_memfd itself, it needs struct kvm, as we discussed
> above, which will come from vm_file, hence retrieval order is needed
> here. VM file needs to be retrieved first before guest_memfd.
>
> To handle this situation, I had three approaches in mind with their own
> pros and cons:
>
> Approach (1):
> Use [3], retrieve internally using liveupdate_get_file_incoming which
> inherently retrieves the file incase it was not retrieved by the
> userspace already. But this creates an scenerio, that userspace might
> call luo_finish which will drop all the references of vm_file (and
> userspace not holding any as it has not retrieved it yet explicitly).
> And vm_file will get released. But this is a valid situation as when vm
> is going to be put down. Userspace can close the vm_fd and have
> guest_memfd yet opened and so other user of struct kvm like vCPUs etc.
> Only thing, this makes retrieved guest_memfd unusable unless, there is
> a mechanism to link to another VM (Nope).
> This leaves us with following situation:
> 	(A): As it is a valid situation, We can leave it as it, No
> 	retrieval order enforcement.
> 	(B): We can implement can_finish to check if userspace has
> 	retrieved the vm_file, otherwise can stop luo_finish from
> 	succeeding, but I did not find a way to implement such check.
> Approach (2):
> Enforce the strict order, by implementing a new call which will first
> check whether the vm_file is retrieved or not, if not, it will not
> retrieve it internally and retrurn err to the caller which is
> guest_memfd retrieve function in this case. So guest_memfd can report
> the userspace about this error.
>
> I have implemented Approach (1)(A), as it is a valid case, and does not
> enforce any retrieve order on userspace, which relieves the burden from
> the userspace when vm_file preservation will evolve. But userspace is
> now expected to retrieve the vm_file before calling luo_finish or
> guest_memfd will become unusable. As per LUO philosphy, It is userspace
> error.
>
> **KERNEL SELFTEST FOR POC** PATCH[8] & [9]
>
> *PATCH[8]* refactor kvm selftest framework to expose some raw apis to
> setup the VM.
> *PATCH[9]* implements the basic test, where it spawn a VM with guest_memfd
> or 16MB and fault it completely and write data to its 5MB portion. After
> LUO preserve call, and kexec, On retrieve, a new VM is spawn with the
> restored vm_file and restored guest_memfd and the data is verified.
>
> I will update this test in the next version to use the liveupdate
> selftests library [5].
>
> Future Work:
> 1. To support preservation for non-prefaulted guest_memfd to save memory
> in KHO. (Already working on this, will post another series soon)
> 2. Support private guest_memfd preservation.
> 3. Extend the support for guest_memfd with in-place conversion of
> shared/private.
>
> [1] https://lore.kernel.org/all/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com/
> [2] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/
> [3] https://lore.kernel.org/all/20260427175633.1978233-2-skhawaja@google.com/
> [4] https://lore.kernel.org/all/cover.1691446946.git.ackerleytng@google.com/
> [5] https://lore.kernel.org/all/20260511201155.1488670-1-vipinsh@google.com/
>
> Pasha Tatashin (1):
>   liveupdate: luo_file: Add internal APIs for file preservation
>
> Tarun Sahu (8):
>   liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
>   kvm: Prepare core VM structs and helpers for LUO support
>   kvm: kvm_luo: Allow kvm preservation with LUO
>   kvm: guest_memfd: Move internal definitions and helper to new header
>   kvm: guest_memfd: Add support for freezing and unfreezing mappings
>   kvm: guest_memfd_luo: add support for guest_memfd preservation
>   selftests: kvm: Split ____vm_create() to expose init helpers
>   selftests: kvm: Add guest_memfd_preservation_test
>
>  MAINTAINERS                                   |  13 +
>  include/linux/kho/abi/kvm.h                   | 121 +++++
>  include/linux/kvm_host.h                      |  14 +
>  include/linux/liveupdate.h                    |  21 +
>  kernel/liveupdate/Kconfig                     |  15 +
>  kernel/liveupdate/luo_file.c                  |  69 +++
>  kernel/liveupdate/luo_internal.h              |  17 +
>  tools/testing/selftests/kvm/Makefile.kvm      |   2 +
>  .../kvm/guest_memfd_preservation_test.c       | 285 ++++++++++
>  .../testing/selftests/kvm/include/kvm_util.h  |   2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  26 +-
>  virt/kvm/Makefile.kvm                         |   1 +
>  virt/kvm/guest_memfd.c                        | 180 +++++--
>  virt/kvm/guest_memfd.h                        |  44 ++
>  virt/kvm/guest_memfd_luo.c                    | 495 ++++++++++++++++++
>  virt/kvm/kvm_luo.c                            | 346 ++++++++++++
>  virt/kvm/kvm_main.c                           |  79 ++-
>  virt/kvm/kvm_mm.h                             |   3 +
>  18 files changed, 1653 insertions(+), 80 deletions(-)
>  create mode 100644 include/linux/kho/abi/kvm.h
>  create mode 100644 tools/testing/selftests/kvm/guest_memfd_preservation_test.c
>  create mode 100644 virt/kvm/guest_memfd.h
>  create mode 100644 virt/kvm/guest_memfd_luo.c
>  create mode 100644 virt/kvm/kvm_luo.c
>
>
> base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
> -- 
> 2.54.0.563.g4f69b47b94-goog

