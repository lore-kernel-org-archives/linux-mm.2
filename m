Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E52CBCD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA746B0092; Thu, 18 Jun 2026 20:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC1B86B0093; Thu, 18 Jun 2026 20:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A956B0095; Thu, 18 Jun 2026 20:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67C9C6B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D04B8140182
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
X-FDA: 84894784338.07.BAEA324
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E9D21180003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hKvGwGw/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829107;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7weiUjO3i82vJ8DcDkinfvE9s3fUyHxI63rHpv0u8rw=;
	b=D2mXncxRAwBOA9GSq7JgDLw5etL9h1Mt+n2237z700/pIz+L4rkt91tYMdCVofuMkgzAgX
	7bqOAgY8qaDMud05OG7Sn8eWSdxdCum6LiXk9Q+3DNlmvAcRUGhnzJYTDCFpEDnlGr8r4Q
	9v2LiCQo5Tm85Y4Es3lOl46c2OAwqv0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829108;
	b=U0RPNYjJYQqECNUNVYbH8baFd8xgtxnw6dtE8gUOXT3PIvqtaUgwmsmtUTRhyocTONTAl8
	qg13jZWoXRWJwxHH23qGr4KFcTqwg0ybZg/TnNvW+/IyoG2WZHoHycsG5BwHfFQ3mYqQ79
	I4tSTbSeSiPfzPRJIGbPJkhA2AcWYP4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hKvGwGw/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F766601E2;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B448CC2BCB0;
	Fri, 19 Jun 2026 00:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829106;
	bh=DmHNL9HxSc5i2u3ht7onNcHWKGGg3Cvj27v8XN2B4Aw=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=hKvGwGw/ob0U0hveEirgB0m42RfrDrohMgophiUN/7SsKvW6aJR+tooxTgBucoi4z
	 YVSKxRH5PVjYMK4QtviHRZ25RshTQGhXXFae0mQgST2ahPKL9gGhNKAuvCGxMp4N7m
	 ieV2HHCmhVTZlG5yWtcEFSmBUn9VnDn4wGtdAnLCOWzvi0YQ+s/7ZWbS6fEGXprCBB
	 obdGygzcISP97ZOMPIHnaMG+AItiqy/beV19vyDllCrN7KKeWGxnE5wsxn7/hlbKxa
	 uRr/kxp4enIZpMBzTm59/GdsIEYFw1t4K1luphr08+HgMl4ER6W1WUtHl0gxQj1FTU
	 Btuetpk8sRAkg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E630CD98F0;
	Fri, 19 Jun 2026 00:31:46 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH v8 00/46] guest_memfd: In-place conversion support
Date: Thu, 18 Jun 2026 17:31:37 -0700
Message-Id: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOqNNGoC/3XRS26DMBAG4KtEXtetsfErq96j6sKPMVgNkBqKU
 kW5e4ewSCrEcuSZb6z5r2SEkmEkx8OVFJjzmIceC/NyIKF1fQM0R6wJZ1wxziVtOuho7s8nF4C
 GoZ+hLDPURxZ9FFZL4QhOnwukfLnLH59YezcC9cX1oV28r7l76+EyLa1tHqeh/N7/MItlYF0nK
 rG7bhaUUZlCxZ1mEIx9b4ahOcFrGDqy7JvrJ4irfahGCLAtgZUspbiB5AOqudmHJELRKGZCSMF
 xvoHUA5JM70MKIVs5L53xlXX1BtJPEOf7kEaIJ5Yc1FZJwf5BtzWkAt8/mPq0JrXGhO9dno4Hr
 5MH6yqfLIAKVmlIWkehVHDSBIH3T5UxGrHbHw/lk/dKAgAA
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=10113;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=DmHNL9HxSc5i2u3ht7onNcHWKGGg3Cvj27v8XN2B4Aw=;
 b=Fphn+UWGofkr9D7C0HN4P2Rzn1gYU/RvmfDEDLBaB854QD3We/tF+yrWMsjXXZR3P/7AIXLB7
 sOU1ochoQAbCZJHbWnZ3wqbYF3FzCYhR4LCLdK6gZn+kjUwXbIyi6Tu
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E9D21180003
X-Stat-Signature: w8ustmfezeo9yseeot5nzqxffsh1iaay
X-HE-Tag: 1781829107-510048
X-HE-Meta: U2FsdGVkX18POWKAoPmPeoNRM3E3hVoe62+0RzTLha1cACLNAStt7hhEIrIBZgbh3Z8HNYk+fU9+6941ylWaQTVJvv7R2xSJauCeGUtxp/XpMdVcybgzCN8iAvNuTsz4G28GzPyWknBYcOxQF6JG3koD/A785lLc+lMnPLwMIzq3NanMlh8+MaXqVShantK0ka36THfQggMjh6KKWorb0BPfjGI6HxRxuigrNDiTERBekGwhx4EQO/I1NYvqUfXooWIFKN6pbNtwZTydmgiSRMzTofUi3D/ymQE4zf+vc2jLElFi/vcoEJCWoiOqOPYgKYNXImS0CZjUFvZQQmBoVTQ2fXUEnGBdFkRnwJOOQeLtN5PXR14YOBTAIfkjUrtT/aWmKYMU3mU897qReCKkXD/jt6ONLi6erW6SFQqr9rwfJOlpA2Fy1TIpV0HFJvT2ROZNDMC9dq7Yd2SE76A769j9rGExRDZnsv9TIep5fj7rMMQJDxQDTQW1ajOSoyc5uBNz+89UZC0DYwcEJI690ypazpYxRiT+MOLxpQ1b4JxFdLjrl+LxFECBrqZWyYkvuE5dPQAfummw25Trj7u9f3ikOJKvQ/n7pQI2W1c3lo8DQ6kTbkg2cWMtRmuIYMY/c5wYfVwXxiLRnYky6MG69kZjlC3dz5K5/NTobNDWjBg2gTta11r8v+jEs9dtUy+5shiDpoEkfTXZ3x7jstibrVKPsPQb9UIB4ctkIiqFOyLnP0X8F+P0Z/j0IGApH1A7SI7kBS8lCEuZxCd7CWtcVV/rT0bcCYrnYHV5o3XzA9u/6KN5bvf7JpIgV2pntnztyUWevJ1jmrB7s8P/dITr1lJwIVTHLuI+VmOcdhfqUOJUmsGMTKkGNOAY7fBniTI2vWzTBAKDcKB8vJUftLQ4pwwfsnPzeOYFn67lPlMsySr36ir4pzDfKc/WjW+MhGQCcBsDa3xrO36st28GtKo
 RrZYfeBC
 OUdfabsB74qEKmqqAEOswxoBr6V5/iTMooTBXeK7M0FNtUWSCprITNQEz+YxoO2oEg8CAkLfqJFQm4XfxuHyGEi0Q1dRJcAIuiYj1fMQntKnoxJhpJSS8MOEX0fqbqjqqYVvADaHyjoXOuX26AElbJyxYmDLDm/2m1NNuOyKxtT+fmMbWRNXyFZaJKjMx2Pmoh80X+yU/2O2lRfslEawSUJFY49FIBIl5UZlj7iMqb8koUtJBl1rlvMEbHjl/Fism+OOM09Qq1nbqkCECEsBCSHIUQmEBkbOWUShZ9FTILxsFtmyw78lggrd67ixOxKv5UWY3SHXFD49XSloJzVdA8S3L3psoVUx0/NiWnYNBzl3bgmH82LHZC0lcK0vT6dN2E9HN8T/MHsipUFMk6DuJfRRV2EvCAkHhiXxo5Nr7a2YSoJ33tE2VRotmj0/i+/iZcCTkRpZjqDOQJmVGrv+oFbJkrlHvk5FLKvRCTKZlni8E2QESbllLXObjgpSeKqUvd3eM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v8 of guest_memfd in-place conversion support.

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
+ tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c

Updates for this revision:

+ Updated the series to _not_ deprecate all of VM memory attributes, but
  only deprecate tracking of the PRIVATE attributes in VM memory
  attributes. This takes into account upcoming RWX attributes support,
  which will be tracked at the VM level.
+ Reshuffled the earlier commits that deal with preparing KVM to stop
  seeing VM memory attributes as the only source of attributes.
+ Addressed comments from v7

TODOs

+ Retest with TDX selftests. v7 was tested with TDX [12], but the setup there was
  wrong. Conversions were successful (no errors), but the shared memory being
  tested is actually in a completely different host physical page.
+ Retest with SNP selftests. v6 was tested with SNP, I ported that to v7
  and those ran fine too. Just need to double-check for v8.

This series is based on kvm-x86/next, and here's the tree for your convenience:

https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-v8

Older series:

+ RFCv7 is at [11]
+ RFCv6 is at [10]
+ RFCv5 is at [8]
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
[8] https://lore.kernel.org/r/20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com
[9] https://lore.kernel.org/all/20260414-selftest-global-metadata-v1-0-fd223922bc57@google.com/T/
[10] https://lore.kernel.org/r/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com
[11] https://lore.kernel.org/r/20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com
[12] https://lore.kernel.org/all/20260605134153.204152-1-ackerleytng@google.com/

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (27):
      KVM: Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable
      KVM: Enumerate support for PRIVATE memory iff kvm_arch_has_private_mem is defined
      KVM: guest_memfd: Introduce function to check GFN private/shared status
      KVM: guest_memfd: Only prepare folios for private pages
      KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
      KVM: guest_memfd: Ensure pages are not in use before conversion
      KVM: guest_memfd: Call arch invalidate hooks on conversion
      KVM: guest_memfd: Return early if range already has requested attributes
      KVM: guest_memfd: Advertise KVM_SET_MEMORY_ATTRIBUTES2 ioctl
      KVM: guest_memfd: Handle lru_add fbatch refcounts during conversion safety check
      KVM: guest_memfd: Use actual size for invalidation in kvm_gmem_release()
      KVM: guest_memfd: Determine invalidation filter from memory attributes
      KVM: guest_memfd: Zero page while getting pfn
      KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
      KVM: guest_memfd: Make in-place conversion the default
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

Michael Roth (1):
      KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE

Sean Christopherson (18):
      KVM: guest_memfd: Introduce per-gmem attributes, use to guard user mappings
      KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
      KVM: Move KVM_VM_MEMORY_ATTRIBUTES config definition to x86
      KVM: Decouple kvm_has_arch_private_mem from CONFIG_KVM_VM_MEMORY_ATTRIBUTES
      KVM: Rename memory attribute APIs to prepare for in-place gmem conversion
      KVM: Provide generic interface for checking memory private/shared status
      KVM: guest_memfd: Wire up core private/shared attribute interfaces
      KVM: Consolidate private memory and guest_memfd ifdeffery in kvm_host.h
      KVM: guest_memfd: Enable INIT_SHARED on guest_memfd for x86 Coco VMs
      KVM: selftests: Create gmem fd before "regular" fd when adding memslot
      KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
      KVM: selftests: Add support for mmap() on guest_memfd in core library
      KVM: selftests: Add selftests global for guest memory attributes capability
      KVM: selftests: Add helpers for calling ioctls on guest_memfd
      KVM: selftests: Test that shared/private status is consistent across processes
      KVM: selftests: Provide common function to set memory attributes
      KVM: selftests: Check fd/flags provided to mmap() when setting up memslot
      KVM: selftests: Update private memory exits test to work with per-gmem attributes

 Documentation/virt/kvm/api.rst                     |  78 +++-
 .../virt/kvm/x86/amd-memory-encryption.rst         |  13 +-
 Documentation/virt/kvm/x86/intel-tdx.rst           |   4 +
 arch/x86/include/asm/kvm_host.h                    |   4 +-
 arch/x86/kvm/Kconfig                               |  15 +-
 arch/x86/kvm/mmu/mmu.c                             |   8 +-
 arch/x86/kvm/svm/sev.c                             |  16 +-
 arch/x86/kvm/vmx/tdx.c                             |  11 +-
 arch/x86/kvm/x86.c                                 |  15 +-
 include/linux/kvm_host.h                           |  74 +--
 include/trace/events/kvm.h                         |   4 +-
 include/uapi/linux/kvm.h                           |  16 +
 mm/swap.c                                          |   2 +
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 tools/testing/selftests/kvm/include/kvm_util.h     | 139 +++++-
 tools/testing/selftests/kvm/include/test_util.h    |  34 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 164 ++++---
 tools/testing/selftests/kvm/lib/test_util.c        |   7 -
 .../kvm/x86/guest_memfd_conversions_test.c         | 509 +++++++++++++++++++++
 .../kvm/x86/private_mem_conversions_test.c         |  53 ++-
 .../selftests/kvm/x86/private_mem_kvm_exits_test.c |  36 +-
 virt/kvm/Kconfig                                   |   4 +-
 virt/kvm/guest_memfd.c                             | 474 +++++++++++++++++--
 virt/kvm/kvm_main.c                                |  86 +++-
 24 files changed, 1547 insertions(+), 220 deletions(-)
---
base-commit: b7fbe9a1bf9ee6c967ef77d366ca58c35fcf1887
change-id: 20260225-gmem-inplace-conversion-bd0dbd39753a

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



