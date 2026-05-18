Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9182CCD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04446B008C; Mon, 18 May 2026 05:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB42D6B0092; Mon, 18 May 2026 05:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9AB6B0093; Mon, 18 May 2026 05:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9C9B6B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:36:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36654A0859
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:46 +0000 (UTC)
X-FDA: 84780036012.21.43F6F7C
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id 755E74000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:36:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oSnKegV8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3qt0KagkKCOccJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3qt0KagkKCOccJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=i1VtCXUBD1t3jnHSXjRhHz2N7tgp4UH2XPLZEo7iEPE=;
	b=pqk7J/sDXz6C2jCjjzTHH+4B++DNDc6dvmFE6UQekiLlutNNfkS+RuFZd+3w9+La8rqqWx
	v7DApxof2BiDxWd/owYPsR9VUTFftsDwQ4Eer7ROsSdYrvaUxdP7V0UrDI+uS9NWjwAp5K
	BIhsaFNv7WtSoLRxKMNu8AIcsQe/xLk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097004; a=rsa-sha256;
	cv=none;
	b=ETAosnCEuFR/VDP+kjESbRAwoSHwq4Cau17/LGqkl9daH362kCiZ0evpzrtp0kh14h9tD9
	Lfd+rVrlJUSPjEf0Q5fJ5J8BGRvEsGk1nk2eK64tlyDn/RpTja2XlEImWaU4e7OVrEPJi0
	P//nhPnFDUo6cAGWR/FZeHs4D9xzRKY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oSnKegV8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3qt0KagkKCOccJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3qt0KagkKCOccJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bd548eb1008so187752566b.3
        for <linux-mm@kvack.org>; Mon, 18 May 2026 02:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779097003; x=1779701803; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i1VtCXUBD1t3jnHSXjRhHz2N7tgp4UH2XPLZEo7iEPE=;
        b=oSnKegV8AJkb7FLzJ2UjlT9SvHguR0iN4LgAi0JPUfu3RJw+8imKJQHEzjTkbiDY/V
         d+pp6Y/bOkhvtedPlJsZGkfJsNu/DuMi+DDARQ8TbyXwlIJyO2Qr+ODDxv+RlqYoMlVX
         fIlPkoWlAg8XYS5UpiqW2p3UOlMJQ1fqRuEDF/eeEAvH2wdYrlnGvBqhiiX8sx8GcYe0
         Nw9G3ywY+vTmpoS50nAhKzuEqFpN/kna4FBVAqT34Wi+Cc2XZRbpiGTkY6pAl3/gLykI
         XGBJqD9jpJbyBKTy4iBSPZV9EgfA91znwPW8SMdK/Xxa5E44CT8HxjO0hnGmIDokTbUk
         /Xsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779097003; x=1779701803;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i1VtCXUBD1t3jnHSXjRhHz2N7tgp4UH2XPLZEo7iEPE=;
        b=HHrd303YkWcreAN6UV07Y7FLx1GjrKv64PB0HqBeUNYwpFJ+KNnWAr3rFKZk3ktuRK
         rVuU3nsgMjdIZ5DfW+oaWir7Vc72ywnAEjaa5tzkl6pBohApbm3Va0QxAxv5o3jkwbHV
         EbMx7No7n4WWJyg8CELWyLReovVZT9YI6v/UfhtwHHdnL98/gBCkYn3sDQ408KUXOHF3
         8PZt2a/JUkWPaT9eF0QwsOJTSyaP9C/095ODxjJc7sbwcz5SKp78R/uV8wB0Y1YSXMfW
         cHYbv1ppHAjEhib7Srmqwu+2XcTttaxlIESCVORWofknnT6LOVWO7D/+Z8xARP8LNLLA
         HmUQ==
X-Forwarded-Encrypted: i=1; AFNElJ9K+dOYHzhAKy5NJxpouiD7taqcjcBV/Okq02/n4kGC6JVTLenMfr9tyDsGxOWI/Fc8hWvoI5pJjw==@kvack.org
X-Gm-Message-State: AOJu0YwesQN2dW/9HhNiDYr2AjyRl1n0BkUOlM4nLBJxm7rHazJ4FTC1
	gEnLjSOJJBRI+00bVe8ma7s9qdggJ1XhfIB847ADy4C8KyQreSiUNHfA4knOgtbdE6QfhqjA5hi
	5pUKVaGTEA7/zmdOLVA==
X-Received: from ejcjg37.prod.google.com ([2002:a17:907:9725:b0:bc1:3569:5260])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3e27:b0:bd1:6909:d013 with SMTP id a640c23a62f3a-bd51780c64amr686154466b.8.1779097002163;
 Mon, 18 May 2026 02:36:42 -0700 (PDT)
Date: Mon, 18 May 2026 09:36:30 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <cover.1779080766.git.tarunsahu@google.com>
Subject: [RFC PATCH v1 0/8] liveupdate: kvm: Guest_memfd preservation
From: Tarun Sahu <tarunsahu@google.com>
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
	kvm@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 755E74000A
X-Stat-Signature: 7m8whhkt95dhesatwfq1k35fzr9ec7xz
X-Rspam-User: 
X-HE-Tag: 1779097004-66320
X-HE-Meta: U2FsdGVkX1/huSiQC1uILJBCvPIa9h8SFamKUOqFh5Zxy3t89HRX5DN7+sP3y1H9GqsgCBk1yrIuScv/xyIeYWlGtuJZiRRlCjATM1z1uBKR2JAIOJDSx0ut3SADUCb34yisu5x+nY70hjsgzp1gZyMxARVm7Dnf3sXQkpcUukls7zaRfQal90tcQS/9NHRXWbtoNoIH0H53pno8JTmkKVc/zs3f3E/aTuqoWntulTRVCOACsfOBdLbC9frpBsb+GI1fsE3A8CgCTljgKWcLuzz9B0uqGTOs1C15RLs+CpwQq2my94Bj06mQQyn0GqFVjHULKI5Upu8UaCWKHt1wQEGqX6x1oUSsSq0ynlYbO/dCv/HgjpKhnlu/vh2OM6xuSXIgJvooVxOWgGtEIwqTATHM+HRbIahODfKQq4J5tckbomA1CFwYhNJhlsLlnioAHeN2mASp+CT6q6tD+BskAiNu/W+LDvu4eV383DgjaBaWvN4M8owUVsQVecjSz8bwwUsMFTj+GOfZQcCKgxSZm0VVRN99Xw9nt9ymqp9Yc4fnya1kCYiWpKXYDfvo06pQ/JFK4rV6uQFy+86wDLicWOlPvoNhGOk5XN/dOdjMyPU5uSb6YpnfgwKZTdsCn+fPgosFCkNCmN3km3c6gL1vRP1qyLNAovrWCizZ3CrYguYzoRpcrX/hvFXmAO9sQqcmzx5S765YT2d0Yst64CVavEU2tUvzKg4FL5zevLwE38lDfVAA+WFrMKCEo0ryEbJZnp16/+SmjFsVsWde+s2ongZN/JFAKgerAMnJVonhonc4eZ2S6uJhUL4VIzj80qy0n/xSfR8iFQZo0dxoex374RFd/fvKJZyovLIAEhwZuxg293+sI/tmBS5JIh5p4cWG8TVX4fCiIkqCarUHg9rNYqrN13IWPO6atvdALpDueeRH9WxSKYqmz/wovTuodwWjyAVNMMxzBR++pCTOXO5
 4mRst1Ba
 mwfE/5JmwyHA/J0xjz8RN8TBCRT6boYTGdeOx5qeoVYS9aHOqFZFgDSZOuW1EkStvKMNAP8SVv0x60WiSIhwo4Zk+/RqL24kOzxr+tOfcFg46uUZnszS2qdWn5RGP4esfWIJ8x8ZpeYGRuYR6IcEW6340Jd+8OhaEpGthqQM/u8Fko+2mf7r/aJRh+OcgaZvTLrna92k+jf6dLl/5p7QWKTVDTXOgpeDj+KkTDKG1XabMxmiI4CHaG8uc3YVK/TwcCfPNI9Fac9pt91BkYnHrK/AT47s4RCuugcGZvkTf8h5IE8U9DhZXm2/4iX1WajWq2BUPgZ54Ss5BJ+htlJmb/w/CWTsE8pe5suAxTddVMQhIXG5ngkxibN4f3zzpAM8FgK2lIf0jpZJCsWcBtncPupoStK4LR8Y/YJQblmSmtPOE4sskBk3F+3Bs85h/Mc9nFGDapmomoaUegKyAt2e89zua3o4mILOM8S5/WVz0jJaUpFA8ImRkoNSBbL0kuE4ZzXWP65mfUTGXgLIwpwtC8eeKKSr8WkLKVK5OLqNs1k5s7pMaszFPAB5Kap9F9qm3I01m1zcO9dQLZRnCMAlSt+Fgk11WAyaU2DEPirJDLxtdGrffUiMXHhxg+7HcqSFgvOaKYCu5sFVgDMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

I am proposing this series as RFC, to initiate the discussion for
supporting the guest_memfd preservation. This will setup basic arhitecture
for VM preservation during liveupdate. This Cover letter has three
sections (please feel free to skip the on you already know):

A. Guest_memfd introduction:
To make the audience familiar with guest_memfd
B. Liveupdate introduction:
To make the audience familiar with liveupdate
C. Actual Implementation Design and questions.

**GUEST MEMFD INTRODUCTION**

Initially, guest_memfd was created to support guest private memory in
confidential computing VMs (CoCo VMs). It was designed so that whenever
a guest wants to grant the host access to private memory, a series of
calls occurs: from the guest to KVM, KVM to the host userspace, host
userspace back to KVM, and finally a new page fault maps the memory into
a separate shared address space. Conversely, if the guest transitions the
memory back to private, the subsequent fault is handled by guest_memfd.
(Dual Mapping Architecture). In such a VM, all guest memory is initially
shared. On the fly, the guest may request to change pages to private; the
metadata indicating which parts of memory are private is stored in an
xarray inside struct kvm (mem_attr_array). This array serves as the source
of truth for the fault mechanism, determining whether a mapping should be
created from host-userspace-mapped pages or directly from the guest_memfd
file. For private memory, Fault also calls architecture-specific function
to set up private hardware access (e.g., on SEV-SNP or TDX). This type of
guest_memfd is fully-private where shared mapping comes from userspace
mapped address space.

Subsequently, support was added to allow the entire guest memory to be
backed by guest_memfd. This led to the implementation of the MMAP and
INIT_SHARED flags for the guest_memfd inode. When KVM_CREATE_GUEST_MEMFD
is called with these flags, the guest_memfd becomes mmap-able by host
userspace. The INIT_SHARED flag is used to make the guest_memfd completely
shared between the host and the guest. Consequently, page faults from both
host userspace and the guest resolve to the same guest_memfd page cache.
However, under this configuration, marking a portion of this memory as
private is not possible. This type of guest_memfd is fully-shared.

If guest_memfd is created with INIT_SHARED without MMAP, the host
can never access the guest_memfd. But the memory is still considered
shared.

Hence, At this point, Only use-case of guest_memfd is either fully-shared
or fully-private.

There is ongoing work to make shared and private mapping in-place backed
by guest_memfd. [1] There is also ongoing work to back guest_memfd by
hugetlb pages. [2]

**LIVEUPDATE INTRODUCTION (LIVEUPDATE ORCHESTRATOR - LUO)**

Livepdate support was added in kernel to update the host kernel by
minimizing the downtime to minimal. This is generally achieved by
preserving the current state of the system and retrieve after boot to
resume from where we left it.

Any subsystem that wants to preserve themselves, register their handler
with liveupdate system. This handler includes calls to the following

*can_preserve (file)*:
This tells the luo system about the eligibility of the file. When
preserve ioctl is called, it first loop through all the file handlers
and call can_preserve, the one which return true, luo uses this file
handler fh->preserve call to preserve the file.

*preserve(file)*:
This actually preserves the file.

*unpreserve(file)*:
This unpreserve the file incase userspace want to go back.

*retrieve(file)*:
On new kernel boot, this function retrieves the file.

*finish(file)*:
When userspace decides that all the files in the liveupdate session has
been retrieved, it can trigger this to do final work of cleaning up.

LUO preserve its memory using KHO (kexec-handover). All these APIs will
be implemented using KHO calls.

**GUEST MEMFD PRESERVATION**

This patch sets up the basic infrastructure to preserve the guest_memfd.
Currently this supports only fully-shared, pre-faulted guest_memfd
(INIT_SHARED) backed by PAGE_SIZE pages.

It registers a new LUO file handler for guest_memfd file to serialize
and deserialize guest memory. This allows preserving guest memory backed
by guest_memfd across updates, ensuring that guest instances can be
resumed seamlessly without losing their memory contents.

The preservation call is straight forward. It walks through the page
cache, serialize the folios and preserve them.

On the retrieval path:
Currently, creating a guest_memfd requires an associated struct kvm
(derived from vm_file / vm_fd). Since there is no direct way to pass a
VM file descriptor via the LUO API, we considered two main approaches:

Approach (1)
Split the KVM_CREATE_GUEST_MEMFD ioctl into two separate ioctl: one
to create the guest_memfd without a VM file (without struct kvm)
descriptor, and another to attach a newly created VM file descriptor to
a retrieved guest_memfd.

Introducing a new ioctl is in itself a problem (UAPI). Currently, a
guest_memfd file belongs to a single VM. Decoupling creation and
attachment could allow a guest_memfd to be attached to any VM, or shared
among multiple VMs when passed at different offsets. Fully supporting
this feature would require extensive work, and it is unclear if there
are any non-LUO use cases that justify this complexity.
There is related work going on here [4], but not exactly same. It still
does not allow guest_memfd to be created without vm_fd. But there be
other ways to use it, I would like to discuss the idea.

Approach (2)
Leverage a companion patch [3] (Also added as part of this series
PATCH[1]) that allows one file to retrieve another file from the same LUO
session. This enables the guest_memfd retrieval path to obtain the
preserved KVM file, use it during guest_memfd file creation, and
subsequently populate its preserved memory.

Preserving the KVM file allows us to preserve additional VM-specific
metadata, which will be crucial in the future for cleanly resuming the
VM. Currently, it preserves only the VM type and kvm->mem_attr_array.

Though the ongoing in-place sharing series [1] transfers attributes to
the guest_memfd file, But preserving the kvm file opens the opportunity
to preserve other VM state in future like registers state, vCPU etc.

Having the extensive usecases for preserving the kvm file, I went
ahead with Approach (2). In future, if approach (1) become possible, it
can easily be integrated with approach (2).

Following the first approach (preserving vm_fd along with guest_memfd),

** VM FILE LIVEUPDATE ** PATCH[3] && [4]

*PATCH[3]* has refactored few functions to support kvm preservation.
During retrieval, vm_file needs to be recreated which will require kvm
api. This patch exports those APIs. There is a new addition to struct
kvm, vm_file. Which will be used by guest_memfd. I will discuss about
this later.

*PATCH[4]*
The preservation of the vm file is straightforward.

On the retrieval path:
KVM normally requires a unique identifier (fdname) upon creation,
which KVM typically assigns based on the newly created file descriptor
number. However, in the LUO retrieval path, the retrieve call restores
the underlying file structure and delegates actual file descriptor
allocation to LUO (check luo_session_retrieve_fd). Currently, I used an
atomically incremented sequence number as the fdname. I would like to
discuss whether userspace services rely on specific naming conventions
here. Or if we can change underlying the retrieve call
(luo_retrieve_file) to pass fd?

**GUEST_MEMFD FILE LIVEUPDATE** PATCH[5], [6] & [7]

*PATCH[5]*
During retrieval of guest_memfd file, for its creation, this patch has
exported APIs from guest_memfd.c to be used for guest_memfd_luo.c

*PATCH[6]*
This patch implements the API for gmem inode freeze, which freeze the
fallocate operation on this inode. Freeze check can be extended in
future to prevent new page faults as well, when liveupdate support
for non-pre-faulted guest_memfd will be implemented.

*PATCH[7]*
Preservation Path:
We have discussed about this before,
I would like to add to that and discuss here a major design decision:
"Preservation order in between VM File and guest_memfd file"

Preservation Ordering is required because guest_memfd needs to store
vm file token as one of its data, which it can use during retrieval to
get the vm file and use (file->private_data: struct kvm ) for its
creation using [3]. So KVM file must be preserved before guest_memfd
file, so that guest_memfd preserve call can find vm file token from the
same luo session.

Currently My preservation implementation does not require any strict
ordering, they can be preserved in any sequence from userspace. I
achieved this by implementing the freeze call for guest_memfd which
gets run at the end just before kexec. This call freeze the luo session
and no further changes can be done to the session. Inside guest_memfd
luo_freeze handler, I update the token for vm_file. Which enable us to
preserve the vm file and guest_memfd file in any order.

The drawback is, incase vm_file is not preserved, freeze will fail. And
in enforcing the preserving order fails the guest_memfd preservation
from the start. As with VM preservation will evolve in future, it will
keep getting complicated so avoiding the preservation order should be
the better choice to make the userspace simpler. I would be happy to
disucss on this further.

To get the token, we need the vm_file and there is no way to get the
vm_file from the struct kvm, as guest_memfd file only store the
struct kvm. I have introduced a new member in struct kvm, vm_file.
But with weak circular dependency as it is just to get the pointer
for the file. we don't want to keep the reference of the file as vm_file
takes for the kvm to keep itself (vm_file) alive. So whenever there is a
need to use of kvm->vm_file, we take the reference and drop it suddenly.

Retrieval Path:
During retrieval path, we just retrieve the data from kho and populate
into the newly created guest_memfd.
To create guest_memfd itself, it needs struct kvm, as we discussed
above, which will come from vm_file, hence retrieval order is needed
here. VM file needs to be retrieved first before guest_memfd.

To handle this situation, I had three approaches in mind with their own
pros and cons:

Approach (1):
Use [3], retrieve internally using liveupdate_get_file_incoming which
inherently retrieves the file incase it was not retrieved by the
userspace already. But this creates an scenerio, that userspace might
call luo_finish which will drop all the references of vm_file (and
userspace not holding any as it has not retrieved it yet explicitly).
And vm_file will get released. But this is a valid situation as when vm
is going to be put down. Userspace can close the vm_fd and have
guest_memfd yet opened and so other user of struct kvm like vCPUs etc.
Only thing, this makes retrieved guest_memfd unusable unless, there is
a mechanism to link to another VM (Nope).
This leaves us with following situation:
	(A): As it is a valid situation, We can leave it as it, No
	retrieval order enforcement.
	(B): We can implement can_finish to check if userspace has
	retrieved the vm_file, otherwise can stop luo_finish from
	succeeding, but I did not find a way to implement such check.
Approach (2):
Enforce the strict order, by implementing a new call which will first
check whether the vm_file is retrieved or not, if not, it will not
retrieve it internally and retrurn err to the caller which is
guest_memfd retrieve function in this case. So guest_memfd can report
the userspace about this error.

I have implemented Approach (1)(A), as it is a valid case, and does not
enforce any retrieve order on userspace, which relieves the burden from
the userspace when vm_file preservation will evolve. But userspace is
now expected to retrieve the vm_file before calling luo_finish or
guest_memfd will become unusable. As per LUO philosphy, It is userspace
error.

**KERNEL SELFTEST FOR POC** PATCH[8] & [9]

*PATCH[8]* refactor kvm selftest framework to expose some raw apis to
setup the VM.
*PATCH[9]* implements the basic test, where it spawn a VM with guest_memfd
or 16MB and fault it completely and write data to its 5MB portion. After
LUO preserve call, and kexec, On retrieve, a new VM is spawn with the
restored vm_file and restored guest_memfd and the data is verified.

I will update this test in the next version to use the liveupdate
selftests library [5].

Future Work:
1. To support preservation for non-prefaulted guest_memfd to save memory
in KHO. (Already working on this, will post another series soon)
2. Support private guest_memfd preservation.
3. Extend the support for guest_memfd with in-place conversion of
shared/private.

[1] https://lore.kernel.org/all/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com/
[2] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/
[3] https://lore.kernel.org/all/20260427175633.1978233-2-skhawaja@google.com/
[4] https://lore.kernel.org/all/cover.1691446946.git.ackerleytng@google.com/
[5] https://lore.kernel.org/all/20260511201155.1488670-1-vipinsh@google.com/

Pasha Tatashin (1):
  liveupdate: luo_file: Add internal APIs for file preservation

Tarun Sahu (8):
  liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
  kvm: Prepare core VM structs and helpers for LUO support
  kvm: kvm_luo: Allow kvm preservation with LUO
  kvm: guest_memfd: Move internal definitions and helper to new header
  kvm: guest_memfd: Add support for freezing and unfreezing mappings
  kvm: guest_memfd_luo: add support for guest_memfd preservation
  selftests: kvm: Split ____vm_create() to expose init helpers
  selftests: kvm: Add guest_memfd_preservation_test

 MAINTAINERS                                   |  13 +
 include/linux/kho/abi/kvm.h                   | 121 +++++
 include/linux/kvm_host.h                      |  14 +
 include/linux/liveupdate.h                    |  21 +
 kernel/liveupdate/Kconfig                     |  15 +
 kernel/liveupdate/luo_file.c                  |  69 +++
 kernel/liveupdate/luo_internal.h              |  17 +
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../kvm/guest_memfd_preservation_test.c       | 285 ++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  26 +-
 virt/kvm/Makefile.kvm                         |   1 +
 virt/kvm/guest_memfd.c                        | 180 +++++--
 virt/kvm/guest_memfd.h                        |  44 ++
 virt/kvm/guest_memfd_luo.c                    | 495 ++++++++++++++++++
 virt/kvm/kvm_luo.c                            | 346 ++++++++++++
 virt/kvm/kvm_main.c                           |  79 ++-
 virt/kvm/kvm_mm.h                             |   3 +
 18 files changed, 1653 insertions(+), 80 deletions(-)
 create mode 100644 include/linux/kho/abi/kvm.h
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_preservation_test.c
 create mode 100644 virt/kvm/guest_memfd.h
 create mode 100644 virt/kvm/guest_memfd_luo.c
 create mode 100644 virt/kvm/kvm_luo.c


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
2.54.0.563.g4f69b47b94-goog


