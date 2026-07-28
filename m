Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F1C4C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE12B6B0099; Tue, 28 Jul 2026 08:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D921D6B009B; Tue, 28 Jul 2026 08:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80CE6B009D; Tue, 28 Jul 2026 08:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 824986B0099
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:11:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E92D04036C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:44 +0000 (UTC)
X-FDA: 85038071328.30.555ADDA
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	by imf14.hostedemail.com (Postfix) with ESMTP id 32815100006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SdxlT3nt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3fZxoagkKCLIlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com designates 209.85.221.71 as permitted sender) smtp.mailfrom=3fZxoagkKCLIlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=A3x31jTyX9GVbaN5Ccntk2NfcOSeaYrewYI0sLHeraw=;
	b=PJxZ/4o8K5oaovuMKWlDtTNgip9f2YqIRDhy3MO7aqfRmgYPyN87It4sAIXvZgLm+k2bKm
	XoWdkkmYuDH9QYFC3mgLubHLKWEbeVYI8mdYSx7aPWjWzWUwcOEISL9tuWc3BAV8fuFBio
	U56ZguUF9W02UyohDTM+JRsy8DZcPsU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SdxlT3nt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3fZxoagkKCLIlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com designates 209.85.221.71 as permitted sender) smtp.mailfrom=3fZxoagkKCLIlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240703;
	b=iMJF0gkW8aNrTY/TWtPHU/aozX/MutacDlyou3bjZmrcwB30xPRHfrTFF2MTYrh/7VQLp4
	n68a8xW33kgV0GS7OHkyu3KnmPxgeEJew0Zk4/KC3EzQ4WQqnNqSkEZ3lJOvmuFk7YjnjG
	dEaiEw5zWhadoyh9mGerwGnJSlWEfRI=
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47f6e658363so2684270f8f.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240701; x=1785845501; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A3x31jTyX9GVbaN5Ccntk2NfcOSeaYrewYI0sLHeraw=;
        b=SdxlT3ntYlHBPOaqCQzD6anDO0GXsNj2V5PmFqRfAdzwV9ZLe3mpB3syAc1vHlMaJn
         fdckGd8lY22HlO87UaIhlvMgM8yqNnet0ALI2o/vgu+OPxVGweeUZ+cRQMOkPMJMjqGW
         DLFC3l37i+tCDdv12Y18a3mZLpl6vsAJjWQLAZT8NxteAWO1XimEUdzVGKh4KD4BLhM2
         OZSnWrUmjUB99jae+sAHDvHXwcX8pW3oeS39llTw5BO6tjL7NKWJwcqfrjnvu+JaAfKo
         xuGnnck0LFPBs1R8Bbv4Iej8GsYbt+32dKIDd9C/LJdWt7vT+Cc/TvysYKLiJ95X1pZV
         itWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240701; x=1785845501;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A3x31jTyX9GVbaN5Ccntk2NfcOSeaYrewYI0sLHeraw=;
        b=cHqPWY8UpryA+VlQwWTii5Q+X+ypNqh+ucDSekcfgyYj6xM9LdMvunodIwQHcHuDmR
         I1A8d3gvWknI/ur+XPZksBSt3b/xEdJORKeQkCdFm7KEsIOCQx1HFRrYtX7obP9ciLl1
         UOv2i+hj2BrAMkZz7xwsLzwfJufhld5hcMyxDgtCYc9IXUo1hChOEeQwLt1YUx+s7NUC
         pZAFIcOw2Adgrp86I9Z/LA0Xo1wiQNvZLLxcPpx294CaDYiJQysrjc1zwfAa9h7Wp5tO
         Vrp70soMG1cWbyh9Bj+owJQSDxYb8rNCsPWVy4Z3hO769eDObW1V7rpMrBavpGV/++HF
         e21w==
X-Forwarded-Encrypted: i=1; AHgh+RrkTtWH0Atat8qI8n30ir+RWLqC+13bELggW9nKwGZFOJzSaTTEZqO1IPh+vw2V07oHwucnyc95KA==@kvack.org
X-Gm-Message-State: AOJu0YzlcQYH8EWPFQYxUHX4i82EqegiIBnXn9qdvzsGmXoIIvVlX1ek
	kJw4p0IMI6ySsiRa8JnIFEuJrQEuKSYR+cmdFiUGBv6Pe2RnsH2tY9+g7xH5Ccs0hws1ZBGYrAU
	8aHSGrEwWqUxkIfJsAQ==
X-Received: from wmbdx8.prod.google.com ([2002:a05:600c:63c8:b0:493:f434:c988])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3f16:b0:495:607e:5ee7 with SMTP id 5b1f17b1804b1-496c6435aeamr21806975e9.17.1785240701228;
 Tue, 28 Jul 2026 05:11:41 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:27 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-1-tarunsahu@google.com>
Subject: [PATCH v4 00/11] liveupdate: kvm: Guest_memfd preservation
From: Tarun Sahu <tarunsahu@google.com>
To: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 32815100006
X-Rspam-User: 
X-Stat-Signature: m456sfsc6zygargcbzr5dck5g4bwmg9a
X-HE-Tag: 1785240703-510333
X-HE-Meta: U2FsdGVkX19XN+QUsap7/WM0m6PPZxKUq8hHzBgRMFStC07ZwejUfO38wFzmuk1Sp15NpQ4Oe0yxIis3i+2Y50T8BHHBvakdj9FBSqJVovERmYWoihD3TSD//LopfujU5sUj4MEIuBOWy01853bWcUp3aytZleCqkLhwVWhyodvQUdQpJGrv9gs3gVXCwnJG3BrcLxCS1NEUVLigqSZy7NUwk2EHUpWfjjfNVk8MlX0s4CrJKOScpIqNQYTAzyIbeTj300w6qwb2e/O8SP3wkAdxDQBGhpjAQTs367aYduw0q/kgw6Kcz5RdVMqWIXZU7nbPoNpRaUf9wolJeBO0ERroQdAedbH/g0bsBxPkZyxL7uWKZk52gRewVuEvzgwinEqpu1NwhVM0ShhAYpo+o9ykRUAurZZljiaEA9Qex47H0BF9uXTVaaiIpiEymda93wdRNU351ppDhZ7mzNbaOR3FWK4VYX917+GUbdVMAPe8+lFSGvwzTNscCV/s6+kQvoVxtoHY1Utj521aOJeVfF+2UWj5QcSLsa5KW7pVX7q1m348q5VjsPVAYBNblfsutNJPs/spbpO0yrp5dUmEjT54/Z0iLCuTcCYSEsew8dtBzKcwouDtrydkpLLAOts/e07n07556+jMCyUPrSVQ2LeZpwyqRyy1z0UBCxuJ2FE+wXbK+34J65U/r/CspXNgDSyxouO4lCdc2B8mInR2sLc/sK1PgXmpU/puz/I7bo3zQnOI4CRcew85KbErjELMbJ0xbBMSA7lHc/P1ubHGpT61HHJ7Aa2RBNv8z/RGMJ1oD+EHQY058/MyDByEf13CAjYsCjfWqJDe1oH6sWPa43mx5KIwi81we3refUMN3kM9YcIxYdV7x3qKWM73+8V+ebHIQ24/wO0D0CZIvfBvWOLeN363banVQEPVtmtJZ2WfKgJJfYFvZ/u+eUCrwedND/emJldEIgne4tO3lEO
 t8Qo5u4N
 PzaUiOnzhlamUBtNHRbg1zhPHING2MvjjtdmNzWG/zZpq+67ACpyjLp7F8flD7wdZQMcIerq33Mv7XULTI+e8NB/Z1WpZTdly8PdgKwq4F6ommdIIoeOynyQ1/VO/8AREEUDNs+daNO/5/j+oFDNkljzeszomzzjPO+kW5QTPDzEtak0dIEtG3kvSGk6CcFWEpnXeXmhG47/0S79MUSXSTxirIbesLZF0URQcNFH8i3GOC6q+TqmIDZyPpgCjiAnn/rr7eIoc/us245q6HxWwlaco96Qh++oqw7hQVsdupBe28HVvvL1pwmuiKcuWOPwXc1PPR09iIp93vTQd684JYAIGG/NfaQt9kcjc3RpUV8HgT6Qh6X96tKTbfyUoaa19QyCpGdNXOxUg84jh76hyfzlk017+GL5VrLmmXa+Nds9R7Y2PHIBhQyiaQ/sTUur/ucsZ+mKqRn6UmJs+ItOHcsxc6sekGNWlZKanruuYkvDzU4UxdALxFF6N3e40debHpN1uTmiYB9iU74pHwc2yMZcN2mJXJYyl37voJ0rwyB9hA/P4L1WjUvjeHMdt3tCgt4JvDK310ik7KwHJ0A76XAlpEv7UIVApWuN4MOFO0t/+xAcSKTvXjOmIJkB9uOUZ6hAFxLeahO3g4ZLaPRm6Jr1WmF1bdqGKx78lTKSIchkDDeUCcV790fHkTh1V/Ek0Co5w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This is v4 of guest_memfd preservation during liveupdate. As per
the discussion from bi-weekly guest-memfd meeting, This series
will be go to linux via kvm tree. And Planning to get it merged
in upcoming merge window. (7.2-rc1 for release in 7.3)

The changes are rebased on:
	kvm/next + liveupdate/next (merge) + [4] + [5]
	Where,
	[4]: luo: APIs to retrieve file internally from session
	[5]: selftests: liveupdate sefltests library
Here is the github repo:
	https://github.com/tar-unix/linux/tree/gmem-pre

Patches [4] and [5] are prequisite of this series and they are
rebased/merged on liveupdate/next. kvm/next is behind few patches
from liveupdate/next, hence direct cherry-pick of [4] and [5] is
not possible. On Linux 7.2 they will be aligned. If we
succeed in merging it before I can request liveupdate maintainer
to provide the tag.

Steps to test:
1. Compile Kernel with CONFIG_LIVEUPDATE_GUEST_MEMFD=y
2. boot kernel with command line: kho=on liveupdate=on
3. run the following kselftest
	$ .selftests/kvm/guest_memfd_preservation_test --s 1
	$ <kexec> --reuse-cmdline
	$ .selftests/kvm/guest_memfd_preservation_test --s 2

NOTE: Assert the following:
	$ ls /dev/liveupdate
	$ ls /dev/kvm
	$ dmesg | grep liveupdate # (should have kvm_vm_luo &&
		# guest_memfd_luo handler registered)

V4 <- V3
1. Split the refactoring patch into multiple patches [2, 3, 4]
2. Updated commits msg as per the kvm documentation and suggestions
3. Removed KHOSER_PTR and using raw pointer, as series [3] not yet
   decided to go in the next cycle
4. Implemented more tests in guest_memfd_preservation_test
   allocation during frozen gmem_inode, non-guest_memfd preservation
5. Moved the vm_create_from_fd to kvm_util.c from the
   guest_memfd_preservation_test.c
5. Minor updates as per the suggestions

V3 <- RFC V2 [2]
1. Finalize the design
2. resolve sashiko reported bugs
3. Use of KHOSER_PTR instead of raw serialized_data as per [3]

RFC V2 [2] <- RFC V1 [1]
1. Removed mem_attr_array as it is not needed for fully-shared
2. Removed pre-faulted condition
3. Added vm_type preservation for ARM64.
4. Removed liveupdate_get_file_incoming api patch as it is sent
   separately [4] by Samiullah.


**GUEST MEMFD PRESERVATION**
Below is the cover letter of the series which explains the design.

SCOPE:
1. Fully Shared Guest_memfd
2. Guest_memfd backed by PAGE_SIZE pages

Any VM whose memory is backed by such guest_memfd and satisfy the
above conditions can be preserved across liveupdate.

To Add support for liveupdate of any subsystem, we need to implement
the following calls: (e.g: subsystem: guest_memfd)

guest_memfd_luo_can_preserve: used by luo subsystem to filter the
			      guest_memfd files
guest_memfd_luo_preserve: triggered from userspace by PRESERVE ioctl
			  If can_preserve says the file is preservable
			  by guest_memfd_luo_preserve
guest_memfd_luo_retrieve: triggered from userspace by RETRIEVE ioctl,
 			  recognised by the passed token from userspace.
			  Used in new kernel after kexec.
guest_memfd_luo_unpreserve: triggered from userspace when a session is
			    closed, which inherently calls unpreserve of
			    all preserved files.
guest_memfd_luo_freeze: triggered just before kexec automatically in
			kernel. no userspace involvement.
guest_memfd_luo_finish: triggered by userspace when all files are
			retrieved and want to finish the session
			retrieval.

*PART A: KVM VM preservation*
Introdcued the kvm_luo.c to preserve the vm_file during liveupdate.
Currently it only preserve vm_type. This can be expanded to preserve
more details in future as need arises for example data related to
cocoVM (SEPT etc.).

	int kvm_fd = open("/dev/kvm", O_RDWR);
	int vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
	preserve_arg = {
    	.size = sizeof(preserve_arg),
	    .fd = vm_fd,
	    .token = VM_TOKEN,
	};
	ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &preserve_arg);

This VM_TOKEN is used by guest_memfd preservation. guest_memfd
preservation save this token (fetched internally by luo apis [4]) to
associates the guest_memfd with its vm_file. On retrieval, guest_memfd
retrieves the vm_file using this token and use its struct kvm to
retrieve itself.

PART B: Guest_memfd preservation
Introduce guest_memfd_luo.c to preserve the guest_memfd file during
liveupdate. Currently it only preserve guest_memfd files that have:

1. INIT_SHARED flag ensures intially all the memory is shared
2. !kvm_arch_has_private_mem() which ensures no shared pages can be
   converted to private after [6] lands.

Preservation first freezes the gmem_inode introduced in PATCH [07/11]
and preserve each allocated folios from guest_memfd page_cache using
KHO.

luo_freeze (not the gmem_inode freeze PATCH[07/11]) call update the
vm_token which is preserved across kexec.

Retrieval retrieves the vm_file using vm_token and create the
guest_memfd with vm_file->kvm and populate the preserved folios
to guest_memfd page_cache.

Added the Documentation for VMM on guest_memfd preservation guidelines
To know more about, PATCH[10/11] can be referred which has the more
detailed documentation.

Future Plan:
	1. Make preservation immune to new allocation and fallocate
	calls so that we can remove freeze call
	2. In future, When IOMMU will use guest_memfd and can allocate
	page tables for DMA in that area, Later it will be a problem if
	other user of guest_memfd do punch hole before preservation,
	that will make the pages to be lost after preservation. This
	will be taken care of when IOMMU will add support for
	guest_memfd.
	3. guest_memfd preservation for private pages + in-place
	conversion.
	4. In future, when guest_memfd will have hugetlb page support,
	add support its preservation.

[1]: https://lore.kernel.org/all/cover.1779080766.git.tarunsahu@google.com/
[2]: https://lore.kernel.org/all/cover.1780667929.git.tarunsahu@google.com/
     https://lore.kernel.org/all/c054ba0fb2639932bbe354420d3f4f84cce84905.1780676742.git.tarunsahu@google.com/
[3]: https://lore.kernel.org/all/20260622184851.2309827-1-tarunsahu@google.com/
[4]: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/commit/?h=next&id=f4d2e4f0d12d88155cd1128ed3294f7827bf4c5d
[5]: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/commit/?h=next&id=2f3f53a3735a7e67bbe9e580cb49372bf9261967
     https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/commit/?h=next&id=df1a0d068d481b7d175c5af3970043206409a062
[6]: https://lore.kernel.org/all/20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com/

Tarun Sahu (11):
  liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
  KVM: Introduce kvm_create_vm_file() helper
  KVM: Export kvm_uevent_notify_vm_create()
  KVM: Track weak reference to vm_file in struct kvm
  KVM: LUO: Support VM preservation across live updates
  KVM: guest_memfd: Move internal definitions to internal header
  KVM: guest_memfd: Add support for freezing mappings
  KVM: guest_memfd: Add support for preservation via LUO
  docs: liveupdate: Add documentation for VM and guest_memfd
    preservation
  KVM: selftests: Split ____vm_create() and add vm_create_from_fd()
  KVM: selftests: Add guest_memfd_preservation_test

 Documentation/core-api/liveupdate.rst         |   1 +
 Documentation/liveupdate/vmm.rst              | 107 ++++
 MAINTAINERS                                   |  14 +
 include/linux/kho/abi/kvm.h                   | 106 ++++
 include/linux/kvm_host.h                      |  14 +
 kernel/liveupdate/Kconfig                     |  15 +
 tools/testing/selftests/kvm/Makefile.kvm      |   6 +-
 .../kvm/guest_memfd_preservation_test.c       | 357 ++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  49 +-
 virt/kvm/Makefile.kvm                         |   1 +
 virt/kvm/guest_memfd.c                        | 185 +++++--
 virt/kvm/guest_memfd.h                        |  44 ++
 virt/kvm/guest_memfd_luo.c                    | 515 ++++++++++++++++++
 virt/kvm/kvm_luo.c                            | 195 +++++++
 virt/kvm/kvm_main.c                           |  94 +++-
 virt/kvm/kvm_mm.h                             |  15 +
 17 files changed, 1640 insertions(+), 81 deletions(-)
 create mode 100644 Documentation/liveupdate/vmm.rst
 create mode 100644 include/linux/kho/abi/kvm.h
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_preservation_test.c
 create mode 100644 virt/kvm/guest_memfd.h
 create mode 100644 virt/kvm/guest_memfd_luo.c
 create mode 100644 virt/kvm/kvm_luo.c


base-commit: a204badd8432f93b7e862e7dac6db0fe3d65f370
-- 
2.55.0.229.g6434b31f56-goog


