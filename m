Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0579CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646D16B0093; Fri,  5 Jun 2026 13:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6996B0095; Fri,  5 Jun 2026 13:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF006B0096; Fri,  5 Jun 2026 13:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2826B0093
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:08:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D6F414022C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:45 +0000 (UTC)
X-FDA: 84846493410.07.59B03A8
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id 30FEB4000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XzY8jOz3;
	spf=pass (imf01.hostedemail.com: domain of 3mQIjagkKCIIzgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3mQIjagkKCIIzgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=d5WfUZoABBIW0tyIpALU+TWbIZ4Vz/CJ1yqpAAE2dls=;
	b=SVaqutBigk8tqSH3MjFzMnhktA++deCF+jzY0+lYe/+c9/7PM/0+/5SLtaPxobXMojqeSL
	DavvifbSnZgNK8YIO1D9BWqaEsBIGMlxVzfgQjLGag6kBZikeP2isRSWlrNBitre1Rc2D4
	OxzYQ5K8LH5YahAM4QnTGBZjdQjnHMk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XzY8jOz3;
	spf=pass (imf01.hostedemail.com: domain of 3mQIjagkKCIIzgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3mQIjagkKCIIzgx0tygn0muumrk.iusrot03-ssq1giq.uxm@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780679323;
	b=6HyDhIwiM+ZeKv7mb6UOwb3nldd3mdnXsNcn9oNiPsCFYBGTrcJVtpYPfv+5GZ6rpf6zk5
	rvWVqRmHsSMypmnWEzdTKkrBaUMzzUGX2bUOPaHOi7Xxt4SxtJTzXfTkQsJiw0LIjEcilI
	vQKCXQQObnRl6ZRAaa/88gAyLBF4HpY=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-beb833df15dso342935766b.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780679321; x=1781284121; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d5WfUZoABBIW0tyIpALU+TWbIZ4Vz/CJ1yqpAAE2dls=;
        b=XzY8jOz3N5+VU0lG51dTnyhm1dA70ODtpDrLpdiAsYSW7d/XBTBBuSF63XhKjSi73L
         +/2DB1zvzDIfT8jQ7bU41Kh0lUlDlHNJ4wu5orRsDSWvEFtlDiEi2ijsYMmvanrgsnW7
         Hx/SDiTkQwPOtamvHd/MXlM1V1L2q67532mfeNLHot6l8jFAwnlpgo0up8QQsS/IDPi9
         eI6gwoTJqc8vpFueurodj5U2Hj7UbuvSFTaPbe5C5Bd32KI/hSaZsvddlgoRbkTJXza2
         zL5ISZcqG22tS49lmL21Zl2pI3wnrQMM32PqF6E+ybske3EnsLI9eOAd1f8bGaz8+8us
         az1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679321; x=1781284121;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d5WfUZoABBIW0tyIpALU+TWbIZ4Vz/CJ1yqpAAE2dls=;
        b=MhWpn90leiCkWFn9klQB2wShjHlTZDyEPz4IOTclH5tkZIWV1D0dLZp2dCjPgSOdRs
         GziOoIaQAsIqOQ6/t0K1dmDHb219c3HbFl48rSlHjONqSzGcjLZRRS0a1LskvxRMBLvj
         n15MEpkCmhXRVaN+XM0Iac8A3rBvusyJ3D0C1keQIGDOXHkU6mEQhcqNKFnoAIgUiACE
         ulkNAUJDFLJ92wAyRAhQLx26FDgJH3wf2owTFuNmrrSRdNRfe2wuy3MpvInHTJL0Ni/K
         ZIc8jUjEih1L/5qxNfSIwGIwhJTC7S9RQUOCGH2by1EvTB1c5rp9POihEaxsWbg1GH5Y
         GKiw==
X-Forwarded-Encrypted: i=1; AFNElJ/x00QzFz9+Bhe6VYNHt4oGVuzKsYh2EvKfiT2XNFVGo07ExM4eTEFvbqmTulAO78JBHWUu/ZAPPQ==@kvack.org
X-Gm-Message-State: AOJu0YyYyKYJwGkgXGT1CDNPTuC9zbqXzpRDQVZCjJWVvOxzWdIVTpyn
	Eg4JCX38lbtUfiHBy2kXV6HqIxTkFt4hlfpkptcn0SipfQHtHuXnevH49/tjBwmtly64zb/oVbT
	5h3TPJoyrteW5N8XdIQ==
X-Received: from edbif10.prod.google.com ([2002:a05:6402:5d8a:b0:68b:12e9:a194])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9487:b0:bdf:b9fa:6683 with SMTP id a640c23a62f3a-bf3a71f72c7mr204228166b.14.1780679321346;
 Fri, 05 Jun 2026 10:08:41 -0700 (PDT)
Date: Fri,  5 Jun 2026 17:08:25 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <cover.1780667929.git.tarunsahu@google.com>
Subject: [RFC PATCH v1 0/10] liveupdate: kvm: Guest_memfd preservation
From: Tarun Sahu <tarunsahu@google.com>
To: Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	Tarun Sahu <tarunsahu@google.com>, fvdl@google.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, 
	aneesh.kumar@kernel.org, skhawaja@google.com, vipinsh@google.com, 
	ackerleytng@google.com, Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, 
	dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com
Cc: linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 30FEB4000A
X-Stat-Signature: oec86k5axs9tpuzfjg1qzgwi6gizj5hk
X-Rspam-User: 
X-HE-Tag: 1780679322-446573
X-HE-Meta: U2FsdGVkX19VtBwpo7boFIas7fotRmJ4y4whnEkOSbVDbrKs7sEz6thjxewx73rL0bH2JVvIp/pZDecl2FxQWRxHs1lOaZlUlYnnZV/GSwtxB0RANPlgPoCIVbv/56pMr56DB3HhkRpR/R6mF/NLm/Jj85KIIFAad0g7NwVDlRusskz4atmCliG3aRBOmEcDR5xMiwxF5ofHh2mSzPr5EBcaAx+3YQKEqt1v9GEH/hGy3jIo5drJvuxzC4xKqrfyOgNtYCsffMPvmezVeKb9Zm+vdZCoThAP3MdJGONrWQszx3uF8UH326T/qyKpKGfy60P2A1M5UILSNNCkssXJziX9wS0oL6RwgO1vijPAIhhH1jl2SUI+lfBVPc7NXjxxfvDCjANxQye1/7LmbYpwRIew0J9Cp005CV2ZMuDh+cXDcofneIoAwF0HpmNn0k9yI8qU61kzskYv8c/hAT2ZfOh6+dnBUSRAN5iFFgYueZmHnvUEasQSPdUCHN30E2Jev8/5E3iC9tMvHT6rdn6fIib1RvDv8N89U2yfYWa1qd6nEPnJg6xQhPLEJ9iW4L13fHfatvNeHUlCqVh4XWZMwZABln5YCnlUwHzwGHN9q5jVpF78Y/UBKdy7WO+cQCn9g4cO5dRoJep37+JYX2QXnqQgrIU8ObGPzs2HZH1FKMH/uddihfqO8Hl1mmT4fsZYnj4lZRo4OL6Q4QWyQui0jvbTO4/IlBaMflz07JKSUDhfks/GBljmuBCK57FNW64jIamtxo0r7OOxoQJ/EqeJHdN+GFt2qiHqnlCiHcAbp+eS1KDUS9XY8RReLVgzuALr2KQS0Z5J+fJR/dQC8PZKOvw0QJCoJB60N/vFNPQKUJEai0oYXI32QQ4YhmttEIbfwSM0bdHfc6ees7nbbpRzQQGJ8wEInIHfE+/lqKK6Wfgb9S37YSeImPoekXbiWjn5Rjgw9/oOHBcD+ozvOLV
 ewv+6jLE
 1F9YX19fzZZ7x/QbFJfon/BAdsoxmIzkXoJLylpD2WTuPf9DRk0mZTKuS1el4gKjFVT1Q2YIFwBOFN/7QcDaIgC+cfYthFvjxbXfAo3HcBYlKBa7X1aFEMsFeCIrZ3qhwDCa0X7ruLsAYpQqyLIDpG9ZzWwMAFq4THAfCGYqvQUowG66Jo3Dx7TMOHDTu3WdKXADgeeqmcicyFu9qsYNVnmn2ukHKms2CD1RI9br4UvyB3e6j1p8BtaZF6K4G0+T9n9oS73o1J5afFZh35OveHspnV1n94zGYJEb6sxddIccykU5e+gzExfBM1c9+53hyMA5gLe+4ZJEFzPO4Z1JK4pKUnp7Ec4QggxsIAn1woH4RxFuqImIw6V26K1aoKnjJCWL74+xGwm8sQQyLIIHEUN/W54VQ7B9UUahRvgHyBMh0BT7rJ9xxHeaFLvigcEKOb+JF1KChuZbhAAA4Mj5hn2fpccpnoY71lVDBiewGQvkdK2cg8uHsDKF6rwaxaeAqJg+/G5WErZFhRjW9b+IvES2nk3jukHGl7vbYOwlNkTykmXXKcAosAWA/sCbBD2kROMVpJYJBEfSVHT2kyigfRHkLVjFzQquIxX5VjKwf2igCBIU50BObkKEWEPhGDFlk/O14mIvRYX1rdNuX7J/aai+Fnk6Mc1TF7K+geqnVYgcNL95ZmNrDYPXnwhxPAAOFEhyTRGdCcZPL7AKLPAfvGM1lCMwDVg7hOLUC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes from V1:
1. Remove mem_attr_array preservation
2. Removed prefaulted guest_memfd condition
3. Updated the check for shared guest_memfd from INIT_SHARED to
   kvm_arch_has_private_mem
4. Added the document liveupdate/vmm.rst

Hello,

I am proposing this series as RFC, to initiate the discussion for
supporting the guest_memfd preservation. This will setup basic arhitecture
for VM preservation during liveupdate. This Cover letter has three
sections (please feel free to skip the section you already know):

A. Guest_memfd introduction:
To make the audience familiar with guest_memfd
B. Liveupdate introduction:
To make the audience familiar with liveupdate
C. Actual Implementation Design and questions.

**A: GUEST MEMFD INTRODUCTION**

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

**B: LIVEUPDATE INTRODUCTION (LIVEUPDATE ORCHESTRATOR - LUO)**

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

**C: GUEST MEMFD PRESERVATION**

SCOPE:
1. Fully Shared Guest_memfd
2. Guest_memfd backed by PAGE_SIZE pages

Any VM whose memory is backed by such guest_memfd can be preserved
across liveupdate.

The preservation call is straight forward. It walks through the page
cache, serialize the folios and preserve them.

On the retrieval path:
Currently, creating a guest_memfd requires an associated struct kvm
(derived from vm_file / vm_fd). Since there is no direct way to pass a
VM file descriptor via the LUO API.

I leverage a companion patch [3] (Also added as part of this series
PATCH[1]) that allows one file to retrieve another file from the same
LUO session. This enables the guest_memfd retrieval path to obtain the
preserved KVM file, use it during guest_memfd file creation, and
subsequently populate its preserved memory.

Preserving the KVM file allows us to preserve additional VM-specific
metadata, which will be crucial in the future for cleanly resuming the
VM. Currently, it preserves only the VM type.

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

This series also introduces the inode freeze call for guest_memfd inode.
Which fails any subseuquent fallocate calls or new page fault allocation.
VMM is supposed to take necessary measure when it is triggering the
liveupdate. VMM must:
1. Either pause the VM before preserving the VM/guest_memfd OR
2. Take action (vm_pause or unpreserve/destroy liveupdate sequence)
   when a fault fails and VM_EXIT to VMM with -EPERM.

Preservation Order between VM and guest_memfd file:
There is no strict order, they are independent. Guest_memfd file needs
the kvm_file preserved token, which it update on freeze call as freeze
is called just before kexec jump. kexec fails incase freeze will be
unsuccessful, for this case, it will fail if vm_file token is not found.

Retrieval order for VM and guest_memfd file:
There is no strict order needed for retrieval.
1. If VM file is retrieve before guest_memfd: guest_memfd will be
retrieved and vm_file also retrieved and userspace hold reference to
both files.

2. If guest_memfd file is retrieved before vm_file: guest_memfd will be
retrieved and it will retrieve vm_file internally and userspace can
retrieve vm_file later. But userspace will not have reference to vm_file
and luo_finish() will drop vm_file final reference if userspace does not
retrieve vm_file before calling luo_finish(). This is valid case, as
guest_memfd can live without vm_file as in the case vm_file is closed
before guest_memfd file.

I have implemented the basic test, where it spawn a VM with guest_memfd
or 16MB and write data to its 5MB portion. After LUO preserve call, and
kexec, On retrieve, a new VM is spawn with the restored vm_file and
restored guest_memfd and the data is verified. It uses the liveupdate
test library [5].

Future Work:
1. Support private guest_memfd preservation.
2. Extend the support for guest_memfd with in-place conversion of
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
 include/linux/kho/abi/kvm.h                   | 106 ++++
 include/linux/kvm_host.h                      |  14 +
 include/linux/liveupdate.h                    |  21 +
 kernel/liveupdate/Kconfig                     |  15 +
 kernel/liveupdate/luo_file.c                  |  69 +++
 kernel/liveupdate/luo_internal.h              |  17 +
 tools/testing/selftests/kvm/Makefile.kvm      |   6 +-
 .../kvm/guest_memfd_preservation_test.c       | 230 ++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  26 +-
 virt/kvm/Makefile.kvm                         |   1 +
 virt/kvm/guest_memfd.c                        | 185 +++++--
 virt/kvm/guest_memfd.h                        |  44 ++
 virt/kvm/guest_memfd_luo.c                    | 489 ++++++++++++++++++
 virt/kvm/kvm_luo.c                            | 190 +++++++
 virt/kvm/kvm_main.c                           |  94 +++-
 virt/kvm/kvm_mm.h                             |  15 +
 18 files changed, 1456 insertions(+), 81 deletions(-)
 create mode 100644 include/linux/kho/abi/kvm.h
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_preservation_test.c
 create mode 100644 virt/kvm/guest_memfd.h
 create mode 100644 virt/kvm/guest_memfd_luo.c
 create mode 100644 virt/kvm/kvm_luo.c


base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
prerequisite-patch-id: 85705fb54d3065efe1d87ab4b69e828a9f3404e7
prerequisite-patch-id: 7bf85ca17e12b26a72d41ee35f2ec8fc5ce2e692
-- 
2.54.0.1032.g2f8565e1d1-goog


