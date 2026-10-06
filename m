Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34542CA5FFF
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 18:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0652C6B0092; Tue,  6 Oct 2026 14:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C576B0093; Tue,  6 Oct 2026 14:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94096B0095; Tue,  6 Oct 2026 14:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B747F6B0092
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:32:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51857A6C9C
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:41 +0000 (UTC)
X-FDA: 85293047322.21.908F4F4
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 75A39100006
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l5iERuRW;
	spf=pass (imf14.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791311559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PbNlJIjJrzwYLlIXsTciTEeuyKiagOAxZiup4TU662M=;
	b=GeoMVaAm9Ipz5odPRzF4bTLwIWkScebOt5YYtXFv6MvgVG2jr5y2pun05vitd/+ytexYju
	caDRMVaiD0AVuxmiPveRk74HoIG58s5UX0qe99VBOcPGy/U955U6nBuiZqOZRlXBBLM6OY
	mtQaJfSrqGtyEBAdWC4CdFXAhmlVmx8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l5iERuRW;
	spf=pass (imf14.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791311559;
	b=8LZDTjKR/ESmGfpPClgyInNq1qDzSax7NBQQyOk2xmUUjUtzjTvj/3OO5s7Mu+95dfT8un
	DcYTMuYqKRf9YGQk+4M6DiO51ri8LCt8LgDB388/l6ltrA9JyLilZWFlt2g/VeNMfYxKqY
	KPboYaQgGzg2ZwYuQjo7KOLaPuzP3Qs=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2e43f3d1fdso446691066b.3
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 11:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791311558; x=1791916358; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PbNlJIjJrzwYLlIXsTciTEeuyKiagOAxZiup4TU662M=;
        b=l5iERuRWOzktnG9rGEJpWIx6DnsfQth2PpgxATYWccAYmR/MaCmiu2YEuwvoviRbMU
         g1z3pku4O+Xf8In1fPpTi7xO7tNjTHdTpF+PxethIiQS6AH5lgdfWQ/2OrZlU6gxsMAy
         5N8oM03SQ5aZMP0eq08nwGW5SBV5uDPippCYBvgke4ObeP2jIVEJ07DcRdnobMlPH8bD
         GxHQmUfTQU3MgpI44yDMlxKjpZeEOXypxykcMDnWJsYG9b5TUatsSh0oj/f4dM/3Ljk1
         2i0QRJE/siYQykRlgXgwZZRHRYfakDuhTLM0IQRPb28Soqx9OL9zjMzN2ew68IGo0e1q
         aKJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791311558; x=1791916358;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PbNlJIjJrzwYLlIXsTciTEeuyKiagOAxZiup4TU662M=;
        b=aM098PK5g8opLcnLyijqUuFhptiXUvkXlg7AehWK4dXYf6rnrrLK7rXYtL2DZ0h7VM
         TEs1+x88Xj4iiNFdE+xwHCDjnxbIru5lImkeIlhFxMdAj9Ujt8lkgicnu0d3d7Tdhn6C
         7Od+Ag2mTqd2QPhZfcddelGPVjI/ut0eBQrxfDXN0abORFSX2th5dpnogdaMK+NLM07B
         oKJ4fDlNBzLUUrhYMWHjz1Mv1F8PrIOOj/ish7NemzhM/ROwRqRffHMVcrtqX9GmPWvQ
         vomJwbB8+UlRPlOu5xeJZA82Ufr7lee0dlnX60ra3y/T7U+rjEvy5/mB4PjYmrplCaMM
         lH1g==
X-Forwarded-Encrypted: i=1; AKwUvBwQm3/e3mXuIP0tX8hqWqS/1e3MC8hj3U8llwAGXdFwCZvFxizFgwHwNezeDtoRc8uBLH190htwaQ==@kvack.org
X-Gm-Message-State: AFuF++koDPeAqL/FJCZVSR0EWiVG3/C1heEeULQsOIQX1EBl5oegUNjt
	vXFHF5wCcz+mHaNngPxcyK7SqxrFoGJ7udkaStkdkg/zRtGpnqVCAxuF
X-Gm-Gg: AYBFou2rgcvBiyqgX73COWiy2yvgK0PJNG6HNoQ6f0+dwavePr1mL7d506xLsa105WE
	eYr9wVTBrtVIwkQ+hwoQf/5cmTAuA0zdNhjFWe1MyZR31b5wnOW72XDwGXu+WWQCTNn6eZKmGGL
	6orWlr52HebxuWkxtyIlmeosmrkBdXoioCozPN0Wxe+1Zn1L/aqqImtnj/2Yv5Sf7j9aj85ZDgS
	KSxR2B1cjykG/2VZerfkSTXFLAgOELZgufOqe36ekm2C9S+wbeHdsM2SMHCZ+em2jxV2vyevpxV
	37IWKZh0tsa9zr3NhsiBeOhadJrW06D8gp3K1s7JKcJUvxZXUfii9uU27YeHTQopf8XJzBz3kAC
	6vBIMZuOXyh9t/xyvq+Y4KXeR1obGfTITSy1fUqfBUhuB/PYcf71vrwG/PP6gONikqwkXTM4lP/
	dQta11Ob8P3ae39AWz9w+A4MWcab8B+vivBoG+p4o2DcYKmrH79UcHGs3nRKOKzFtacHxkc04fl
	04CH/3cKEm3DjG9J3W2QoeHOC6gIX24DsButDsf8joBtu+giEwa103TN899oJsaW/1V/5dqWSFS
	MUsOWeiahGqddXfzHc6Oz7necYwOOYZ5awsHNXrGrqr1hw==
X-Received: by 2002:a17:907:d10:b0:c2e:40a0:7978 with SMTP id a640c23a62f3a-c3169f5f01cmr247936866b.9.1791311557634;
        Tue, 06 Oct 2026 11:32:37 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3158260f7bsm221934866b.6.2026.10.06.11.32.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 11:32:37 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
Date: Tue,  6 Oct 2026 18:32:26 +0000
Message-ID: <20261006183235.16576-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720111259.122911-1-dwmw2@infradead.org>
References: <20260720111259.122911-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 75A39100006
X-Rspam-User: 
X-Stat-Signature: 8pn8pc14zhcq7ubndtrodi78dong9wrm
X-HE-Tag: 1791311559-65479
X-HE-Meta: U2FsdGVkX18uvBV4HVg9pv5tf9AgBUVEbsKtM2tvkrSIwVWePNHjDJeVbQbYdh+wpqWpaoJG2RZqEQuF5YowiXNsEunX6xqxIx9OKSF2UZp2MQQM0Ul0Ag1q5n4agWJrYnAzdDB/JXzMeEyrscAEYCXhkPvuOa6JjA8LMbwQ1nN3Rkj2oA4x2JbK2cK58lgyothWNv6lCAy9+cmdCmd3ccFQ0WaPZoQRmiKABTobTnHm8k5JLN8osjDQdjg4g852HCb3KCfqVW54TC8f1SvGN5RXMpMxjunIVJ6Dk1c+aOZEK/KoN9yN1DNrYFeNrTWDTGeEpI5GzExchGOkFcz/B1TG7ftu6Ag9cX0py6+vkCs/dUKAujhPBHjMTlJmYeUSvRZlSluiqebcAKpJu4zj1YQEzVicSua4bs8tzgdRX8Wog0v9KYqwka6bKxbyGHTgLomxh+f1BQivQu2oQdSZFEPd9rnfIxWPYEbeTxXdPlHubrDqOVr0cAlXLv1KDwG0OFvg9apiwGUki5qlUE/dYeHfHAXZRozi5Mn0vzZXyx+jzRYx/sKFwmwn8Fls3RFWJGJ7wO5m1aJdXE4A1z9N6A2xwFCsXsyHqs9MrCdT38+x+8eYka/3xTkS/3eP/ZhenPQsMGl43NKVjioIeHiy1ILCtxguzlwPL3vGVcxGo4OlndMxC7fqqSVZO913NCDWAAt+jBmq6fcgIasDg4C2uiMj0WDJjSq170gxrnxBW3CkS+/8Zy1MLJMV7o+/oRenqVfp1GNh5wy+yNG3iDrlcFBL38nKrriILOKB0jRF31AqEyG9aVqe4LU4Jqgnrcr4a6xeoQWkQL4v4ILia4VFR/BgBJkpULb5Uhw/84et+/LVNv5JE8Dv5fd+YfxqLRFbqo0bylaEZ0+jP5vbwuhF6RrDrMAhHRF8+oDRYNWRabGO3Q9cE0SKJE8M5wHId4Ym6g0sfA61PwRv3+h8AOl
 NXEH/pw7
 US5cWq5Ig3DNBGwczL7g/V48E0nojRdae4g1cIFnFcvKyvbn9VhaObYrZcHfa00TYRIH10YRcYka01rpqKbFGy5iQXSmejpdMCzV+QtRWZvnygmJTcRXFjXSh/zWCyrfkSpJ5JXl/WUMfs+qTt4OMvdFSFpJE8TlKWGnU8i6RcWaekUGz4n2LTey3Ltjl3PA8aWey434ffZaCI+SMNiQQXEX2mr0VgOjNYO828Cp2RPjGQXW9I3r7R1ywH3/fZ2P6teU2TVO49jehwtxwk4v0X6zurtVu92PW8AQA2CaL47XshSFY0l1bw/ILwRKebc6kBEuS0Fxw9r/WotY8rkarFHRR866UR6kCAK9tjCa+QTlCI15PNBb5xW7y9ooDnF7Rnrhb6iqi47NxDxpMbOy5LjdlY72zNG3dfXGwDLc7DwBxaaynoNbXXj4b+tAWgiv6ju8ficN1DALxZPUmbaVpyVxwbBmMflnCC2UR4nurJqWyw+81q7WVrFZiASKAVsigxK3m1W+m9JGuYQz2yFmJ6H6pHCjOuPIinwGmUiDCfFhQJPOnxkuk1E/1THQEf60jXTZ/l+k25POjwtfksqcO3e7jKKm0P0T83U3TmehQTUMJd50mpmlCAptkWKb3GFa6Zr0mlInqd8qh7UkNdTnudnGhtKPiveV6G7SqaPmEbuhRjko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Fred Griffoul <fgriffo@amazon.co.uk>

Some drivers manage RAM outside the page allocator: a carve-out, device
memory, or memory that a host component moves between VMs while they
run. This memory often has no struct page. The driver wants to lend
pages to a VM and to its devices, and to take any of them back later.

David Woodhouse's series "KVM: Allow alternative providers of
guest_memfd backed by PFNMAP memory" lets such a driver back a
guest_memfd through struct kvm_gmem_ops:

  https://lore.kernel.org/kvm/20260720111259.122911-1-dwmw2@infradead.org/

That covers the guest, but not the VM's devices, which his cover
letter left as an open question. This series adds a small interface in
mm: the driver that owns the memory becomes a provider, and the code
that maps it attaches as a consumer. There are two consumers, a
guest_memfd backend and IOMMU_IOAS_MAP_FILE in iommufd.

The series is on top of David's v2 (base 0e35b9b6ec0f). Patch 1 was
part of the earlier dma-buf RFC. The provider backend depends on it, so
this series carries it.

Why not dma-buf
===============

The earlier RFC shared the memory as a dma-buf. Christian König
rejected that: an importer must not build its own page tables from a
dma-buf, and the use case should stay out of drivers/dma-buf. I
acknowledged that and dropped it; this series does not touch dma-buf.

Why a new interface
===================

kvm_gmem_ops gives KVM a way in. For devices, the only option today is
a dma-buf plus a private call that iommufd looks up with symbol_get(),
which is how vfio-pci works. Each new owner would need another such
lookup, and iommufd would end up knowing each owner by name. With a
common interface, a provider module only calls into mm, and nothing
needs symbol_get().

It also means the provider revokes a range once. The VMM hands the
same file to KVM and to iommufd; on a revoke the core forwards it to
every consumer, so KVM clears the range from stage-2, iommufd from the
IOMMU page tables, and guest_memfd from the VMM's own mapping, all
before the revoke returns.

The contract
============

For a page of a provider file, get_page() returns the frame, its type
(RAM or MMIO, read-only or not), and the largest aligned block of frames
of the same type, so that consumers can use large mappings. A page
without a frame is a hole.

Consumers take no references. A frame stays valid until the revoke that
removes it returns. To guarantee that, a consumer either holds a lock
across get_page() and the mapping that its revoke callback also takes,
or detects a racing revoke and retries.

The interface does not deal with folios. The native guest_memfd backend
and memfd pinning in iommufd handle pages from the page allocator, and
pages that can move or swap would need references. A backend that needs
full control over the file can still write its own kvm_gmem_ops.

Backends
========

The motivating user is a host-side memory manager. It reserves a region
of host RAM, lends parts of it to VMs and their devices, moves pages
between VMs, and has to survive a live update of the host kernel. The
sample module in this series models it.

Device-DAX could also be a provider: its range never moves, get_page()
is short, and it only revokes on unbind.  iommufd can map MMIO, but KVM
takes only RAM, because it picks the guest memory type itself.

Neither consumer keeps state about the provider's frames, which helps
with live update.  guest_memfd has nothing to save across kexec, since
KVM refills stage-2 on faults. The provider saves its frames and who
owns them. Devices cannot fault, so their mappings stay part of the
existing iommufd live update work, and the provider only has to give
back the same frames.

Confidential VMs
================

This series does not support them yet. For now only x86 VMs of type
KVM_X86_DEFAULT_VM can use a provider.

I don't think a provider should back private pages. Revoking a private
page loses its contents, and only guest_memfd knows which pages are
private. The interface could still be useful there later, with
guest_memfd acting as a provider for its own files so that iommufd only
maps shared pages. I left that for a later series.

Patches
=======

  Patch 1 lets a kvm_gmem_ops backend map a page read-only for the
  guest.  get_pfn() gets a writable output, and a guest write to such a
  page exits with KVM_EXIT_MEMORY_FAULT. KVM_MEM_READONLY can't be
  used for this, because guest_memfd slots don't allow it.

  Patch 2 adds the interface and the core, and the FOP_MEM_PROVIDER
  flag in struct file_operations.

  Patch 3 adds the provider backend to guest_memfd, with the
  GUEST_MEMFD_FLAG_USE_PROVIDER flag and a provider_fd field.
  guest_memfd also handles the userspace mapping of the file, if the
  provider allows it, so providers don't each have to get the fault and
  revoke handling right.

  Patch 4 prepares iommufd for tracking pages it does not pin. No
  functional change.

  Patch 5 lets IOMMU_IOAS_MAP_FILE take a provider file. iommufd maps
  one PAGE_SIZE entry per page and pins nothing. It leaves holes
  unmapped and honours read-only and MMIO pages. On a revoke, it
  unmaps the range and maps whatever the provider backs now.

  The PAGE_SIZE entries are deliberate for now: a partial revoke then
  never has to split a large IOMMU page. Using the block size the
  provider reports would be better, and needs the revoke to unmap and
  remap whole blocks. A device that accesses the range between the
  unmap and the map faults; replacing the entries in place would avoid
  that, but needs new support in the IOMMU drivers. Both are left for
  later.

  Patches 6 and 7 add iommufd selftests: two mock-domain queries and a
  mock provider.

  Patch 8 adds a sample provider. It gives each VM a child file, can
  move, donate and reclaim pages, and supports read-only pages. A child
  file is read-only to its holder; the owner changes it through the
  control device. It only uses the mm interface.

  Patch 9 adds a KVM selftest with one provider and two VMMs. After
  each change it checks what the guest, the device and the VMM's mapping
  see.

Testing
=======

x86_64, in QEMU with KASAN, PROVE_LOCKING and DEBUG_ATOMIC_SLEEP, with
two ranges hidden from the host with memmap=, one for each sample. No
KASAN report, lockdep splat or warning in any run.

  - mem_provider_test, the selftest in patch 9: pass.
  - guest_memfd_test, including the USE_PROVIDER flag check: pass.
  - iommufd_selftest, iommufd_ioas: the 12 provider tests pass in all
    four variants. The 4 failures are access_domain_destory, which the
    series does not touch: it needs hugetlb pages, which this VM has
    none of.
  - David's gmem_provider tests, which this series does not change:
    hugepage, revoke, iommufd and readonly pass; the SNP and vfio-pci
    tests skip for lack of hardware.

Not tested: arm64, where guest_memfd refuses providers; a real IOMMU,
since only the mock domain was used.

I wrote most of this series with AI help, and I am posting it as an RFC
to get feedback on the interface.

Fred Griffoul (9):
  KVM: guest_memfd: Add a writable result to get_pfn()
  mm: Add memory providers
  KVM: guest_memfd: Add a memory provider backing
  iommufd: Track the domains of pages that are not pinned
  iommufd: Map memory provider files
  iommufd/selftest: Add mock-domain IOVA queries
  iommufd/selftest: Add a mock memory provider
  samples/kvm: Add a memory provider sample
  KVM: selftests: Test a memory provider shared by KVM and iommufd

 Documentation/virt/kvm/api.rst                |  45 +-
 MAINTAINERS                                   |   8 +
 arch/arm64/kvm/mmu.c                          |  13 +-
 arch/arm64/kvm/nested.c                       |  16 +-
 arch/x86/kvm/mmu/mmu.c                        |  18 +-
 arch/x86/kvm/svm/sev.c                        |  13 +-
 arch/x86/kvm/x86.c                            |  10 +
 drivers/iommu/iommufd/Kconfig                 |   1 +
 drivers/iommu/iommufd/io_pagetable.c          |  37 +-
 drivers/iommu/iommufd/io_pagetable.h          |  54 +-
 drivers/iommu/iommufd/iommufd_test.h          |  36 +
 drivers/iommu/iommufd/pages.c                 | 340 ++++++-
 drivers/iommu/iommufd/selftest.c              | 286 ++++++
 include/linux/fs.h                            |   2 +
 include/linux/kvm_host.h                      |  20 +-
 include/linux/mem_provider.h                  | 211 +++++
 include/uapi/linux/iommufd.h                  |  11 +-
 include/uapi/linux/kvm.h                      |  11 +-
 mm/Kconfig                                    |   7 +
 mm/Makefile                                   |   1 +
 mm/mem_provider.c                             | 177 ++++
 samples/Kconfig                               |  17 +
 samples/Makefile                              |   1 +
 samples/kvm/Makefile                          |   1 +
 samples/kvm/gmem_provider.c                   |  67 +-
 samples/kvm/gmem_provider.h                   |  17 +
 samples/kvm/mem_provider_sample.c             | 855 ++++++++++++++++++
 samples/kvm/mem_provider_sample.h             | 135 +++
 tools/include/uapi/linux/kvm.h                |  11 +-
 tools/testing/selftests/iommu/iommufd.c       | 119 +++
 tools/testing/selftests/iommu/iommufd_utils.h |  64 ++
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../testing/selftests/kvm/guest_memfd_test.c  |   6 +
 .../kvm/x86/gmem_provider_readonly_test.c     | 150 +++
 .../selftests/kvm/x86/mem_provider_test.c     | 582 ++++++++++++
 virt/kvm/Kconfig                              |   1 +
 virt/kvm/guest_memfd.c                        | 286 +++++-
 37 files changed, 3531 insertions(+), 100 deletions(-)
 create mode 100644 include/linux/mem_provider.h
 create mode 100644 mm/mem_provider.c
 create mode 100644 samples/kvm/mem_provider_sample.c
 create mode 100644 samples/kvm/mem_provider_sample.h
 create mode 100644 tools/testing/selftests/kvm/x86/gmem_provider_readonly_test.c
 create mode 100644 tools/testing/selftests/kvm/x86/mem_provider_test.c


base-commit: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
prerequisite-patch-id: 2a0016e90f0690baef841a8c34c07b96e3f1b941
prerequisite-patch-id: c497c1ff1e9de8e9c470c58b163ccbfce4827ae7
prerequisite-patch-id: a16b61afd172662bde725e5c12805758f76b89fa
prerequisite-patch-id: 0ddee6c1b48fa853e6a94f2746340e525477d287
prerequisite-patch-id: 4dc9a395a2eb73283b20b75e2ba763ec72b2e22d
prerequisite-patch-id: a9758d7f8f6959dae6ad154902fa1269234dbc3c
prerequisite-patch-id: 0537bcc3ca5e3bb9b86fe7c99a245a9ff9d67831
prerequisite-patch-id: d5feb18b6630c99973259804418243d856c37ce7
prerequisite-patch-id: 2a08a105b6b5d46240a69f5bbf646211d44f8412
prerequisite-patch-id: 760b34834d5d8dcdf1ae1a09cc6aae267dd7760c
prerequisite-patch-id: dd94ecc7ae9472c2bf005c9cb1c483994eacd163
-- 
2.47.3


