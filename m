Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58A45FF887E
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD1556B00C9; Tue, 28 Apr 2026 19:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA46A6B00CD; Tue, 28 Apr 2026 19:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E2E6B00CE; Tue, 28 Apr 2026 19:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2AC6B00C9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:28:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0CD4160DF5
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
X-FDA: 84709548000.09.C02FD73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 917F41C0010
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NWJCOnWz;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418718;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LOkEh7ZtqsOZMQ4KiVSMVgi+cl5SCcF2u2ts64IykkE=;
	b=mWeP6MP1U1pJMLuEdfi2qKpYXwImUoxpGZVBPbr+a75JX+koBMgD9YcTnvWx8xHLSkyfIt
	5JaCGjZp0erAB82wWxlqTZ1Ef5dVm3Jg8A5uttLj47MM+SNPi9vrdA2LbgIqy1XpL3TpPF
	Q2X7J9y8J6kg31Ee2bspk6F8qX67X7s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NWJCOnWz;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418718; a=rsa-sha256;
	cv=none;
	b=HSHGtUm1uJhBA967eYHow/BP72w4Mngt2nJ7QBpzLRx+m4Cl7kxXeDu3M4Gx9wh7N/U/c1
	0tSwi73lPE59ZMYqH1T8NVxobVPA5c02va7rRyRR2uyroBAGy4MC2kfQ/velhYV4sSwVU2
	ZCm0d6+ooxwAcrHu6ARB+Iv6563FmTc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 405284065D;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 087EFC2BCAF;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418717;
	bh=svzUpBBdu7c/okzZHdk95phkHOtm8MccWFmUfZ97Ar8=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=NWJCOnWz9Zy+sGJdjfmd774CXIoDYgCTLGSnXlNfv5ATQgY1Px/iGnL/KHuvEtcDh
	 YEMsfwXEdj7jttG0RadnWi+LJtM2pvoGMQTZGeM5J5Z/2JWskBZjf4456sWeBUg+qg
	 +StYFMY+99PHUVyVTuTRAqARQMfD+FXl86nv4R1w+QZ2Y/s0F8ckQM8cNWSCDkLRNX
	 fFACHTFAOEjpllyutxJabZo/zrNqaITV+Zy4DdD/kkJJ52l2+tyYsxnNKTK9c4/uYq
	 Pn+SbUJQoI42nUkBh4hl5g8J3Gr+n9On2fyZ1/A9Hz3XG9WXyepnmNbklMaB4DZ2km
	 UaL6BDF3iCKSQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C46FF8875;
	Tue, 28 Apr 2026 23:25:16 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH RFC v5 00/53] guest_memfd: In-place conversion support
Date: Tue, 28 Apr 2026 16:24:55 -0700
Message-Id: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMdB8WkC/3WOsQ7CIBRFf6VhFqUg1jqZmPgBrsaBwqMlttBAQ
 2pM/13KpIPjfbnn3PdGAbyBgE7FG3mIJhhnU+CbAslO2BawUSkjSuiBUMpxO8CAjR17IQFLZyP
 4lcGNIqpRrK44EyjRowdt5my+o9v1gh7p2IgAuPHCym6VPuOwszBPa78zYXL+lR+JLFN5k5Xs7
 2ZkmGCuZUlFRUAe63PrXNvDVroh78X9l4ge/ov2SQSppqHmRGv1I1qW5QNanisVKAEAAA==
X-Change-ID: 20260225-gmem-inplace-conversion-bd0dbd39753a
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=12535;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=svzUpBBdu7c/okzZHdk95phkHOtm8MccWFmUfZ97Ar8=;
 b=0QkV8hZP8hOH+hNCjeSswDYv3vwtP0XxQooAEB0MYPOPaJ61NRztWoDddvIp3XyKA8ztoEmSN
 kkCot+LkiE4DyIM4Rvv4GTzuOq5tFyFCn3jEr0j4bB0zWVpIPJWfHca
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 917F41C0010
X-Rspam-User: 
X-Stat-Signature: bsofsjprjpfccgpznugkn1cowipxhqbd
X-HE-Tag: 1777418718-586878
X-HE-Meta: U2FsdGVkX1/c5DkUtN/tBNQxL09JGsedbJTkM0IM1CRTDUkiCxHus4OmPDUPr+w1kw41kD3C9mySGxXSZrAabnldytbvnI+ptVVhDmMeJkXkog+/uoKObdMXd0qAh6qAy64QndpS0ytBleMCaLd3XqzZCiOaTujvVuQD/zQIjjat7YCJc1Ghkzgy/jxWNTXdP92xttTwlPFaUPhQ1KftxOkGLokrXLThKBOXUZn2+IbnH0BBEeNkQOhPhaqVigvA6DPCf1iqNHywImErPvpPNjKaRO7wMpIPCA/LOQtMX38swQ5Q2p9bGywnd+ftHumtm3zWoh7RSZcNZweRQBz3wnNk11wq42Nek9nigHmUP9C/TjckwDeun/zp6FuiBqcI3xRUE7eS/OF2Y/SbzBaYBeEaId+86i671vWRjodC76Xr6DuPerf9xAkMJ1cZq5tN9GkHjnvaDJ8Bq5dZC0s7Lg5PYRGx1ATo32PP0A1ZLa/nRBxi1vW7glmuLaZ+Shp4cw8MmZrBgTW84CdpsJDL5i5TNWdOQiSIBDDxLUbBk5w/jmdEy+fcH8+fXCUOEBkSC3m8sH9m80VDRWQ7m1rpLUpcHAWkzv1jina0FUA+WM7uj73TLxGlspt7w+P0s4O0QSq0M5VZ8ShSZsCW8At/5w1HU3tUhSirp8z8Q/OAtwythZaJxbd7zUG5u9VjRRD/DePNAn9rgTnnsiuFoDD4TPYDWvquSxFK03FgviqBTpBfHwEoNz/BvIHACt68+JAhqAEN/hK0YW3+m0dNchH2XPNy+1cp6WVp8vJm4cth+tqfBP5rdLHCB53D+mnegeLgNtTDaXHj5MLpltiXqzImAWSlvK0r4bxsFuLJfbWeLJvx0/uV1SyTerq+AhMdfREhsppklsr1ylBuuA7IDcWgYgqnnP7bU+V914zM0ZgEVDhPYNOinSm7zxWlIfEhbno3IJGfBRtghDjnes/mY46
 0Ig74AO6
 h6w4yWyiOT4WJkFdJRbiwbkdDyTlWQcLxTSby/rpoFEeCfiyYIL2bAFmLWuPpUtjlB7iCdbdW5As9Uf7fxVmvVUBTBAXCp75uXxKK8sq17T5HAtuwluvC7XDzKaYDTDfJprIhapBNuZCkZ6CmGmh14Kuy+14sMimXLOV6YBilmCpb+CqfeIZuiKR5+uukV8ucr8VTATkCAYY045wDKLS9/oLgZCvpAbJDyB/OUQdTKQowV4aBWUBro3Df6zeZQaPlYVOs2mSjGQu240nWR/oO/e0vaMi7LQjFXee19F04WwxZs4QbyqF0qBd6Pe83+wxjw2zR3N918pGXkGdI+YVcZE9hFg9FEPDSL51NmLruXuzZQGn8FRGgnEak2sOvrfXFehwnvu+Je96EjnVDZf5bEm+xd7kEbHk0wIHBUeX40obHSAbnmEhNZJu8nq4mdAzA8MlnfEhB32VlPqesJQiSKbMOfOGt1YttkoYwTEqCN0sUFGaApLYhvA3s7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is RFC v5 of guest_memfd in-place conversion support.

Up till now, guest_memfd supports the entire inode worth of memory being
used as all-shared, or all-private. CoCo VMs may request guest memory to be
converted between private and shared states, and the only way to support
that currently would be to have the userspace VMM provide two sources of
backing memory from completely different areas of physical memory.

pKVM has a use case for in-place sharing: the guest and host may be
cooperating on given data, and pKVM doesn't protect data through
encryption, so copying that given data between different areas of physical
memory as part of conversions would be unnecessary work.

This series also serves as a foundation for guest_memfd huge page
support. Now, guest_memfd only supports PAGE_SIZE pages, so if two sources
of backing memory are used, the userspace VMM could maintain a steady total
memory utilized by punching out the pages that are not used. When huge
pages are available in guest_memfd, even if the backing memory source
supports hole punching within a huge page, punching out pages to maintain
the total memory utilized by a VM would be introducing lots of
fragmentation.

In-place conversion avoids fragmentation by allowing the same physical
memory to be used for both shared and private memory, with guest_memfd
tracks the shared/private status of all the pages at a per-page
granularity.

The central principle, which guest_memfd continues to uphold, is that any
guest-private page will not be mappable to host userspace. All pages will
be mmap()-able in host userspace, but accesses to guest-private pages (as
tracked by guest_memfd) will result in a SIGBUS.

This series introduces a guest_memfd ioctl (not kvm, vm or vcpu, but
guest_memfd ioctl) that allows userspace to set memory
attributes (shared/private) directly through the guest_memfd. This is the
appropriate interface because shared/private-ness is a property of memory
and hence the request should be sent directly to the memory provider -
guest_memfd.

Tested with both CONFIG_KVM_VM_MEMORY_ATTRIBUTES enabled and disabled:

+ tools/testing/selftests/kvm/guest_memfd_test.c
+ tools/testing/selftests/kvm/pre_fault_memory_test.c
+ tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+ tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+ tools/testing/selftests/kvm/x86/private_mem_conversions_test.sh
+ tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c

Updates for this revision:

+ For TDX and SNP, PRESERVE supported only before VM is finalized only for
  to_private conversions.
    + This allows PRESERVE to be used as part of the VM memory
      loading/encryption flow
    + Only support PRESERVE for to_private conversions (to_shared on
      populated memory on TDX would cause zeroing)
    + Relaxed constraints for SNP and TDX to allow NULL to be passed as
      source address.
+ Dropped KVM_CAP_MEMORY_ATTRIBUTES2. KVM_CAP_MEMORY_ATTRIBUTES reports
  attributes supported by the KVM_SET_MEMORY_ATTRIBUTES VM ioctl, and
  KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES reports attributes supported bt the
  KVM_SET_MEMORY_ATTRIBUTES2 guest_memfd ioctl.
    + KVM_SET_MEMORY_ATTRIBUTES2 is not supported by the VM ioctl
+ Resolve locking issue when kvm_gmem_get_attribute() is called from
  kvm_mmu_zap_collapsible_spte() by bugging the VM. guest_memfd memslots
  don't support dirty tracking, so the locking issue is not on an
  accessible code path.
+ Moved guest_memfd_conversions_test.c to only be compiled and tested for
  x86, since it depends so heavily on KVM_X86_SW_PROTECTED_VM's as a
  testing vehicle

TODOs

+ Perhaps further clarify PRESERVE flag: [8]
+ Resolve issue where guest_memfd_conversions_test, which uses the
  kselftest framework, doesn't perform teardown on assertion
  failure. Please see proposal at [9]
+ Test with TDX selftests. We're in the process of rebasing TDX selftests
  on this series and will post updates when that's tested.

I would like feedback on:

+ Content modes: 0 (MODE_UNSPECIFIED), ZERO, and PRESERVE. Is that all
  good, or does anyone think there is a use case for something else?
+ Should the content modes apply even if no attribute changes are required?
    + See notes added in "KVM: guest_memfd: Apply content modes while
      setting memory attributes"
    + Possibly related: should setting attributes be allowed if some
      sub-range requested already has the requested attribute?
+ Structure of how various content modes are checked for support or
  applied? I used overridable weak functions for architectures that haven't
  defined support, and defined overrides for x86 to show how I think it would
  work. For CoCo platforms, I only implemented TDX for illustration purposes
  and might need help with the other platforms. Should I have used
  kvm_x86_ops? I tried and found myself defining lots of boilerplate.
+ The use of private_mem_conversions_test.sh to run different options in
  private_mem_conversions_test. If this makes sense, I'll adjust the
  Makefile to have private_mem_conversions_test tested only via the script.

This series is based on kvm/next, and here's the tree for your convenience:

https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-v5

Older series:

+ RFCv4 is at [7]
+ RFCv3 is at [6]
+ RFCv2 is at [5]
+ RFCv1 is at [4]
+ Previous versions of this feature, part of other series, are available at
  [1][2][3].

[1] https://lore.kernel.org/all/bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com/
[2] https://lore.kernel.org/all/20250117163001.2326672-6-tabba@google.com/
[3] https://lore.kernel.org/all/b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com/
[4] https://lore.kernel.org/all/cover.1760731772.git.ackerleytng@google.com/T/
[5] https://lore.kernel.org/all/cover.1770071243.git.ackerleytng@google.com/T/
[6] https://lore.kernel.org/r/20260313-gmem-inplace-conversion-v3-0-5fc12a70ec89@google.com/T/
[7] https://lore.kernel.org/all/20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com/T/
[8] https://lore.kernel.org/all/CAEvNRgGbMhkX310CkFY_M5x-zod=BDTiuznrZ0XvFPUK7weL1A@mail.gmail.com/
[9] https://lore.kernel.org/all/20260414-selftest-global-metadata-v1-0-fd223922bc57@google.com/T/

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (34):
      KVM: x86/mmu: Bug the VM if gmem attributes are queried to determine max mapping level
      KVM: guest_memfd: Update kvm_gmem_populate() to use gmem attributes
      KVM: guest_memfd: Only prepare folios for private pages
      KVM: Move kvm_supported_mem_attributes() to kvm_host.h
      KVM: guest_memfd: Add basic support for KVM_SET_MEMORY_ATTRIBUTES2
      KVM: guest_memfd: Ensure pages are not in use before conversion
      KVM: guest_memfd: Call arch invalidate hooks on conversion
      KVM: guest_memfd: Return early if range already has requested attributes
      KVM: guest_memfd: Advertise KVM_SET_MEMORY_ATTRIBUTES2 ioctl
      KVM: guest_memfd: Handle lru_add fbatch refcounts during conversion safety check
      KVM: guest_memfd: Use actual size for invalidation in kvm_gmem_release()
      KVM: guest_memfd: Determine invalidation filter from memory attributes
      KVM: guest_memfd: Introduce default handlers for content modes
      KVM: guest_memfd: Apply content modes while setting memory attributes
      KVM: x86: Support SW_PROTECTED_VM in applying content modes
      KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
      KVM: x86: Support SNP and TDX applying content modes
      KVM: x86: Bug CoCo VM on page fault before finalizing
      KVM: Add CAP to enumerate supported SET_MEMORY_ATTRIBUTES2 flags
      KVM: selftests: Test basic single-page conversion flow
      KVM: selftests: Test conversion flow when INIT_SHARED
      KVM: selftests: Test conversion precision in guest_memfd
      KVM: selftests: Test conversion before allocation
      KVM: selftests: Convert with allocated folios in different layouts
      KVM: selftests: Test that truncation does not change shared/private status
      KVM: selftests: Test conversion with elevated page refcount
      KVM: selftests: Test that conversion to private does not support ZERO
      KVM: selftests: Support checking that data not equal expected
      KVM: selftests: Test that not specifying a conversion flag scrambles memory contents
      KVM: selftests: Reset shared memory after hole-punching
      KVM: selftests: Provide function to look up guest_memfd details from gpa
      KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
      KVM: selftests: Update private_mem_conversions_test to mmap() guest_memfd
      KVM: selftests: Add script to exercise private_mem_conversions_test

Michael Roth (1):
      KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE

Sean Christopherson (18):
      KVM: guest_memfd: Introduce per-gmem attributes, use to guard user mappings
      KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
      KVM: Enumerate support for PRIVATE memory iff kvm_arch_has_private_mem is defined
      KVM: Stub in ability to disable per-VM memory attribute tracking
      KVM: guest_memfd: Wire up kvm_get_memory_attributes() to per-gmem attributes
      KVM: Move KVM_VM_MEMORY_ATTRIBUTES config definition to x86
      KVM: Let userspace disable per-VM mem attributes, enable per-gmem attributes
      KVM: guest_memfd: Enable INIT_SHARED on guest_memfd for x86 Coco VMs
      KVM: selftests: Create gmem fd before "regular" fd when adding memslot
      KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
      KVM: selftests: Add support for mmap() on guest_memfd in core library
      KVM: selftests: Add selftests global for guest memory attributes capability
      KVM: selftests: Add helpers for calling ioctls on guest_memfd
      KVM: selftests: Test that shared/private status is consistent across processes
      KVM: selftests: Provide common function to set memory attributes
      KVM: selftests: Check fd/flags provided to mmap() when setting up memslot
      KVM: selftests: Update pre-fault test to work with per-guest_memfd attributes
      KVM: selftests: Update private memory exits test to work with per-gmem attributes

 Documentation/virt/kvm/api.rst                     | 139 ++++-
 .../virt/kvm/x86/amd-memory-encryption.rst         |  19 +-
 Documentation/virt/kvm/x86/intel-tdx.rst           |   4 +
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/kvm/Kconfig                               |  15 +-
 arch/x86/kvm/mmu/mmu.c                             |  20 +-
 arch/x86/kvm/svm/sev.c                             |  18 +-
 arch/x86/kvm/vmx/tdx.c                             |   8 +-
 arch/x86/kvm/x86.c                                 | 145 ++++-
 include/linux/kvm_host.h                           |  74 ++-
 include/trace/events/kvm.h                         |   4 +-
 include/uapi/linux/kvm.h                           |  21 +
 mm/swap.c                                          |   2 +
 tools/testing/selftests/kvm/Makefile.kvm           |   5 +
 tools/testing/selftests/kvm/include/kvm_util.h     | 141 ++++-
 tools/testing/selftests/kvm/include/test_util.h    |  34 +-
 .../selftests/kvm/kvm_has_gmem_attributes.c        |  17 +
 tools/testing/selftests/kvm/lib/kvm_util.c         | 130 +++--
 tools/testing/selftests/kvm/lib/test_util.c        |   7 -
 tools/testing/selftests/kvm/lib/x86/sev.c          |   2 +-
 .../testing/selftests/kvm/pre_fault_memory_test.c  |   4 +-
 .../kvm/x86/guest_memfd_conversions_test.c         | 552 +++++++++++++++++++
 .../kvm/x86/private_mem_conversions_test.c         |  55 +-
 .../kvm/x86/private_mem_conversions_test.sh        | 128 +++++
 .../selftests/kvm/x86/private_mem_kvm_exits_test.c |  38 +-
 virt/kvm/Kconfig                                   |   3 +-
 virt/kvm/guest_memfd.c                             | 591 ++++++++++++++++++++-
 virt/kvm/kvm_main.c                                |  87 ++-
 28 files changed, 2075 insertions(+), 190 deletions(-)
---
base-commit: 39f1c201b93f4ff71631bac72cff6eb155f976a4
change-id: 20260225-gmem-inplace-conversion-bd0dbd39753a

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



