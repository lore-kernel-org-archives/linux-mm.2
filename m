Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0653C5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97AE06B0098; Fri,  7 Aug 2026 17:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952816B0099; Fri,  7 Aug 2026 17:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A396B009B; Fri,  7 Aug 2026 17:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57E416B0098
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3E3C1601EE
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
X-FDA: 85075823700.25.08D83A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D429540009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hZZDe9nA;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139568;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=abOUWt893PqsEAWMjHKh7zNUwNyz1Jmt8CM07OKZRdw=;
	b=w3hMV8QwJ2RveF+8NDN06pXwYyyxoXj3US8urHioF5ieURzsdLhrnpY1Zmh5OnNe23ZB2S
	1Uq0Dju40HWfmEp3q8aYRhyZAdRcyVeKEA9LLrcAsshk8RFH2SznaIX3XOx+IniOqiJ09v
	uoA9IBhcbz3uPRe1HjKju69eWQkzYbY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139568;
	b=gmhIXNWPd2nn/XGNMVV4/UL51Jghr6gFO4S9HwktbQs+rNl9gougJ4ZIWYMJcJ2Gyr4ni+
	31sUV9l8qFBJ/jjDVTrnptWF1AnKTF42vkeo5j4bNlJ0x4XKLm46q05tFAST5Oh/0pVM1v
	GpbCXUr5PPJEZE3HJEYzzT62ZdvTqKM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hZZDe9nA;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3273F60054;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6402C2BCC7;
	Fri,  7 Aug 2026 21:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139567;
	bh=VRY21HbGe+yrXyu21+xEN17//OmuhC1bDdv0JvaqW4Q=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=hZZDe9nAPE71x/6W7qTfborur/rgdxBksXQgjdrTG3UHLpXU11vEEA23dZdDkNNHx
	 b3A0fwJJPTPufkBeG98p4hsOJqIP1tZwdiP/axVkaO2v5+aMubb2i9/93QN8Eu/dJs
	 LDRae5YVEPxuiT4Y7GsXrJQOldgWnSY6M1iMcJGDcqVIFdT5SFCb0WqtCl50iEgxm/
	 Nqrct6gzS6gvM4IADtdqEbSl/Eri2Bhc1Zd0sKJ+cs28/guc7ex55IlHrBV9VXMpAO
	 lg9aU+X37pFrgdtoQnR3LbbGfDPU6chvOtFOYCsgBDKg1APWgTUxLwS+lRceNsHs4r
	 h8KJpEBMT58+w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96420C5ACD3;
	Fri,  7 Aug 2026 21:52:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH v10 00/41] guest_memfd: In-place conversion support
Date: Fri, 07 Aug 2026 14:52:39 -0700
Message-Id: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKhTdmoC/33SzW6DMAwA4Fepcl624JC/nfYe0w4hcSBagS4w1
 Kni3RfaSXRC9OjI/uxYvpABU8SBvB4uJOEUh9h3OSjY04G4xnY10ujzAwEGkgEIWrfY0tidjtY
 hdX03YVqKaOWZrzw3SnBLcvUpYYjnK/3+kePKDkirZDvXLN7n1L50eB6X1CYOY59+rkNMfCm4t
 eMF3203ccqoCK4Aqxg6bd7qvq+P+Oz6liz9pvIOArkPlRnCnBbQCBaC30BihUrQ+5DIkNeSaee
 CswAbSK6QYGofkhkyha2E1VVhbLmB1B0EsA+pDEFgwWJppOBsA+kVksWDr+llIg9GGC6UFnwDm
 RVSj3ZkMsRFMBYdWPT/dzTfzibh13c+xPHvdub5F8bP7JKmAgAA
X-Change-ID: 20260225-gmem-inplace-conversion-bd0dbd39753a
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139564; l=7969;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=VRY21HbGe+yrXyu21+xEN17//OmuhC1bDdv0JvaqW4Q=;
 b=1MMm0tJlW1y4Emo2ScsHjlWOO+GuUKmskR1J2fwzVgT2PGgtiz+v6uJrsvDDPE/XdsXrfLDJw
 o+0+DbabpMKAo/92iXSHQw01z3E1wx+Iu+a6Vsp3cbzsxoCge5e4wd4
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D429540009
X-Stat-Signature: 4a5zrqr1m13g6g1sfpnf89jhk1ikdn3c
X-HE-Tag: 1786139568-715044
X-HE-Meta: U2FsdGVkX1/BXkjOWz7exClJ/lOsWLlmN/gVLIJY5ITTh1xqRrJg64mXbId5KbSp2fcxitb58U8cnLF3OCCXk2YgT4X57Hptw+bUofCwBAddFLpAzRv5PjllxdBZg+h+FK8vOKWRrXcchxUwG4W23IVvl8v1lcuohxDQuEhrt4sYVi5gX2ZcfCkSwzsDV59XMpvALbZIEfZYsdx/2whK6g2KGLJ8XAI5NXLbEY4zWn4itWAXz7xSTP61ILb9lMFIWfx3Xg6JbkQXvnAM34+pG2xdE/Cd9Ya0QHG3QvOUyBXj6l2O0IUoysiP+G41WVj75JmKVnzM3BrGY2kX96aivyVYgSZOxTrrldRqrISRYmhwQNSwyFft/Pl0b+Cm+Kke4j01o/Jf7dxBa5t7m1GcLA8Ir6O0lDyJL7DhkT47c3C1ZyMZZdqHd4VkLWyHfUhx/Rpy60yly9RwANEpwLfwj+lqTyi+3VeApM1r8EMgA3702b0gfz0p/LmR6tzj7VQIx8/TKF23Wt0PHbfRdX1Crpdli+me9S/RToxKps4LaV4G9jmdeY4ctCbxWT9w62CIz1YB/c898gRg+zLFX2ge8yeweSdbvTpLnNRdjq2GozlYVGJTMYTCk5tT2BeTDJ431+ODav/+rBHvfyjw+SKszS9YIwwGXQThYjwhZSssTitO6A3X8kqtCHLcEYsOjg0Iy2n0VzkFAMmxoURdY6Alb6JcZGOP849mxQgS4lcdxa6tYMqi5wBcuEn3QDecOPSTvJmSmQC/eJMp2T5bdMQtXQp4qFB4zYR7Jn2DHInt4wIIwReOtVccBl1UAO55glSWAUUedq9+jFSjHv+iLv9zNW7rUFaVxPv6FUXLj95lFY8zk6UHzbgKYmx1bViHH32nnc0RDmm5sCeV3UG3Vk45i8qyiP8A0TFvl3kAM35UbRnNWcNY7XVCk8t/DpPVgFhTL/rJM7HU84BU0MxbwGM
 iuCMsu3X
 G9wJ1LCZHzWgOWHAIlsYOnqRRqzc+VWMW/Bwmn6Xi06DZXa7dviK0mKjhZnZkiIg5fZ9+pbiOCbPlYmSuiJfBdDyf1S84G+Dtfq+Av+zSbSUWmn1lw41Tu3yWPuOZpDFVWpwPC36tlFGSrWQ/EvBKB6xTK8M5gIgahJ+QcDcP4N6zdRWElunIiV8GQZB1VnzwJEx0sR8SGNLUiuiItcLVv6ilnIS2unG61es09tKUS/EXHne0tO25hXx/mYqLDTYxY6bIGeBUpCgpdxBTcauqyhyygZ8HB6RZjFPNvNVkbQjxamCquxOZtBPgKaO1E5Qm0sA7FaNkr/dmQzjh69rtfWOYzwVym6pdGoTmZ6Zwje+WtSh5X9JRhvByqgaD2M3BBgkAZLMoGRd5twUnUtEdSWhGnm0BktFZO2cnd0bdOjAs7+n4gWkHohQYpmzPpoPyTPgInbCHA0Vsy0wzxpxVVRMzUuiL5D8xslOsA5Me69LYjD03mCi90lRsFRoOo0cgaL1HI7thg9CshuKsxsV6530f+c5rBv2anEol8DZRovX4bn8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v10 of guest_memfd in-place conversion support, which addresses
comments on v9. Please find the motivation for this series from v8 and
before.

v9 is based on kvm-x86/next, with a cherry-picked version of David's GUP
fix [1], and a cherry-picked version of David's refactoring patch
[2].

Here's everything stitched together for your convenience:

https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-v10

I tested v10 with CoCo selftests on top of the branch above:

https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-coco-selftests-v10

Tested with both CONFIG_KVM_VM_MEMORY_ATTRIBUTES enabled and disabled:

+ tools/testing/selftests/kvm/guest_memfd_test.c
+ tools/testing/selftests/kvm/pre_fault_memory_test.c
+ tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+ tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+ tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
+ The TDX and SNP conversions selftests in https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-coco-selftests-v10

[1] https://lore.kernel.org/all/20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org/
("mm/gup: fix always draining LRU caches in collect_longterm_unpinnable_folios()")
[2] https://lore.kernel.org/all/20260806-lru_cache_drain_for_folio-v1-1-c6287d295e99@kernel.org/
("mm/gup: factor out LRU cache draining for folio into lru_cache_drain_for_folio()")

Older series:

v9: https://lore.kernel.org/r/20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com
v8: https://lore.kernel.org/r/20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com
v7: https://lore.kernel.org/r/20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com
v6: https://lore.kernel.org/r/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com
RFC v5: https://lore.kernel.org/r/20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com
RFC v4: https://lore.kernel.org/all/20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com/T/
RFC v3: https://lore.kernel.org/r/20260313-gmem-inplace-conversion-v3-0-5fc12a70ec89@google.com/T/
RFC v2: https://lore.kernel.org/all/cover.1770071243.git.ackerleytng@google.com/T/
RFC v1: https://lore.kernel.org/all/cover.1760731772.git.ackerleytng@google.com/T/

Previous versions of this feature, part of other series, are available at:

+ https://lore.kernel.org/all/bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com/
+ https://lore.kernel.org/all/20250117163001.2326672-6-tabba@google.com/
+ https://lore.kernel.org/all/b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com/

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (21):
      KVM: guest_memfd: Filter both shared and private when invalidating
      KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
      KVM: guest_memfd: Ensure pages are not in use before conversion
      KVM: guest_memfd: Call arch make_shared callback for to-shared conversion
      KVM: guest_memfd: Return early if range already has requested attributes
      KVM: guest_memfd: Handle lru_add fbatch refcounts during conversion safety check
      KVM: guest_memfd: Zero page while getting pfn
      KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
      KVM: Let userspace disable per-VM mem attributes, enable per-gmem attributes
      KVM: selftests: Test basic single-page conversion flow
      KVM: selftests: Test conversion flow when INIT_SHARED
      KVM: selftests: Test conversion precision in guest_memfd
      KVM: selftests: Test conversion before allocation
      KVM: selftests: Convert with allocated folios in different layouts
      KVM: selftests: Test that truncation does not change shared/private status
      KVM: selftests: Add helpers to pin pages with CONFIG_GUP_TEST
      KVM: selftests: Test conversion with elevated page refcount
      KVM: selftests: Reset shared memory after hole-punching
      KVM: selftests: Provide function to look up guest_memfd details from gpa
      KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
      KVM: selftests: Update private_mem_conversions_test to mmap() guest_memfd

David Hildenbrand (Arm) (1):
      mm/gup: factor out LRU cache draining for folio into lru_cache_drain_for_folio()

Michael Roth (1):
      KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE

Sean Christopherson (18):
      KVM: guest_memfd: Use kvm_mem_is_private() when populating guest_memfd memory
      KVM: guest_memfd: Introduce per-gmem attributes, use to guard user mappings
      KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
      KVM: Enumerate support for PRIVATE memory iff kvm_arch_has_private_mem is defined
      KVM: Rename memory attribute APIs to prepare for in-place gmem conversion
      KVM: Provide generic interface for checking memory private/shared status
      KVM: guest_memfd: Stub in ability to enable in-place shared<=>private conversion
      KVM: Consolidate private memory and guest_memfd ifdeffery in kvm_host.h
      KVM: Move KVM_VM_MEMORY_ATTRIBUTES config definition to x86
      KVM: guest_memfd: Enable INIT_SHARED on guest_memfd for x86 Coco VMs
      KVM: selftests: Create gmem fd before "regular" fd when adding memslot
      KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
      KVM: selftests: Add support for mmap() on guest_memfd in core library
      KVM: selftests: Add selftests global for guest memory attributes capability
      KVM: selftests: Add helpers for calling ioctls on guest_memfd
      KVM: selftests: Test that shared/private status is consistent across processes
      KVM: selftests: Provide common function to set memory attributes
      KVM: selftests: Update private memory exits test to work with per-gmem attributes

 Documentation/virt/kvm/api.rst                     |  78 +++-
 .../virt/kvm/x86/amd-memory-encryption.rst         |  14 +-
 Documentation/virt/kvm/x86/intel-tdx.rst           |   4 +
 arch/x86/include/asm/kvm-x86-ops.h                 |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   6 +-
 arch/x86/kvm/Kconfig                               |  15 +-
 arch/x86/kvm/mmu/mmu.c                             |  16 +-
 arch/x86/kvm/svm/sev.c                             |  11 +-
 arch/x86/kvm/vmx/tdx.c                             |   8 +-
 arch/x86/kvm/x86.c                                 |  20 +-
 include/linux/kvm_host.h                           |  76 +--
 include/linux/swap.h                               |  11 +-
 include/trace/events/kvm.h                         |   6 +-
 include/uapi/linux/kvm.h                           |  16 +
 mm/gup.c                                           |  15 +-
 mm/swap.c                                          |  48 ++
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 tools/testing/selftests/kvm/include/kvm_util.h     | 139 +++++-
 tools/testing/selftests/kvm/include/test_util.h    |  34 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 164 ++++---
 tools/testing/selftests/kvm/lib/test_util.c        |   7 -
 .../kvm/x86/guest_memfd_conversions_test.c         | 512 +++++++++++++++++++++
 .../kvm/x86/private_mem_conversions_test.c         |  53 ++-
 .../selftests/kvm/x86/private_mem_kvm_exits_test.c |  36 +-
 virt/kvm/Kconfig                                   |   3 -
 virt/kvm/guest_memfd.c                             | 450 ++++++++++++++++--
 virt/kvm/kvm_main.c                                |  92 ++--
 27 files changed, 1574 insertions(+), 263 deletions(-)
---
base-commit: 4217d4987bbe33e331764a752721f781123b2e07
change-id: 20260225-gmem-inplace-conversion-bd0dbd39753a

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



