Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7477DCC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FE286B00A3; Wed, 14 Oct 2026 05:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5296B00A6; Wed, 14 Oct 2026 05:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3436B00A3; Wed, 14 Oct 2026 05:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50F906B00A3
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:37:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF4CB1C3A52
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:37:38 +0000 (UTC)
X-FDA: 85320729396.14.FB3C978
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf31.hostedemail.com (Postfix) with ESMTP id 21FF220006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:37:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PsjtpTSg;
	spf=pass (imf31.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791970657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R05RRinsndJYz9OgDk1E3BcfzrlmFh1Ft/JMEJneKqY=;
	b=UaHt3JZuN7a7q3+GmtEr/LAcTgrpDrqWZTjPL3+ldxWRuYkBsyRz+v/R+ZRmf2SSfuEq7B
	9gYuNe66YT/8tnRFHmbuNfQlve0Y+tsV90juTYh1378ho8pzEuO0mUFalb0En+jvNYZ4VF
	M3frk8NBDsjqQoPWj14kWyN783Ba75M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791970657;
	b=Vx5Sj/FpgP3b4MW5gEcfGWpkyQf1Ax2fy6yf1bZhqhBrp122vpeMynDVoZjO7GeHaciqSa
	VAyfG6EQquPSn4yD1NIwm39jNTdfLBccvwMOnNF/SXl2Tr1gylypPyTg64Un3X55baYxOC
	GLFWhnIj8ZusyR/ccdJkYQNTjKeg0A0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PsjtpTSg;
	spf=pass (imf31.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a018dc1f98so30941985e9.3
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791970656; x=1792575456; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R05RRinsndJYz9OgDk1E3BcfzrlmFh1Ft/JMEJneKqY=;
        b=PsjtpTSgXqq6P+7txAhZ0IMCRF85nBju/dqrz9M9hiAmqyTPnPKg4sEBPwEVqzv3i9
         SvLmrtFUrThlKB+hpx3IhBrAjkKlh1m9qyGzcEGapvdBLoL3SAeeVCRpNg2rO2cU3niC
         0X3qVubfSfDMjxfVBvRc7PznP7q0nd38BiOb2hgYfrEEQ0o/E4CozsrJ0xVUKhXk1pyk
         wEYVXncdRWsbviZsoRhx5uHSXf2QE7r8dUk+41B5FPJ3S7oHMUwQrCb6MlwQSm6eCyiL
         mxwsy/hm1MoyJKCmFxISXQLYOW6ivubf+CZXlyP9rfbg5eUtnMdxHPGcNMvfLXSb/GFl
         K4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791970656; x=1792575456;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R05RRinsndJYz9OgDk1E3BcfzrlmFh1Ft/JMEJneKqY=;
        b=nYtapbE48aOzOXIhBeBYfUQMCc27kJ1CaLytHGutSlT7f3liDolD40z3Smc2txBLqI
         BirNz0ZTQ/HymWwYN1SFwX6hCGVH50yypv9grKEwRCD6FbmUiUUEuHZeE8KB87+9hZcZ
         97eaM7CVUr0OsPsqiuoI2zJziyPshx+rOw6SZjAKMbuRvHTBYyx5/7f2sq4HMIg1Kb2e
         qCSsxPzaXh+nMCLWawTMu98EMXUa1Ba2ExjUB0F7KZ22xYbLH5ghbrJpdPgZa2SHzi9B
         acdlI2al/+8G7ZPwB8RQjan4EeXvgOft+0hWbH/McR8r9+YbB92oa2/zY75pyTY9JPq+
         nYkw==
X-Forwarded-Encrypted: i=1; AKwUvBxc7tvu8DIvBaBhphANnuJAL7Mgew8PFp2Rl26R7xMeR9l9I8ZaYgSer1WkLWPPVGb0Qh2O37MpIg==@kvack.org
X-Gm-Message-State: AFq9FYJq3bPiUkjg5tmCcoQsqUGtHbdZ/Hc0sMdkR2b2crO6PQw4Nz1g
	BIYdpjgM4/99pEhtej+lnXMz26Vwi0zjksY1fmKnRS9S3xdkzQjfYYun
X-Gm-Gg: AYBFou1yrVCFCoI2v5kiO2xR2Rz0Ibqt6F1RB+QZhXx9XZtxUQDW7a0hy/VaONoqC2P
	Nrggpw07SgKG5040xQP0Qx5KgHdShnIDC9DhkuwAeWDT6I02AQXUpU/6AouBLj0/+HxrBWb+Vng
	i6dDm4SX8WQLAkL9rg/MIr/eJ+gIZRyIZMXdw7qKMahoUynCnxMR6W6gqlD6vWOGJWbDavsaXFi
	rKT1Tk+VA6iQAPEw0iJYdcAOrszokBCurlpQKhkaQv6F7jj9XSWsaqfkNnC3Qxg96jjmfKyeddI
	aKm86a2yB9S9/FwwVx7SGHemJRkmP28bvfirAlIe5TwKBMWfOMl1yBYFTGUoPM24YfvLMLaeG7W
	WsRohdp1oxZxY6UOEIoL9LFuWjCATnauA29T8xoBf2hh44O6lwneqwUB6nrH+bJl17Xh6lYDDYo
	/PGqqcLV7xdYOM9KxiR1i2fnSWcip8+ETAbK15nSR5Q3iAy3mOsAg7gvYJR2g1YVEuf0EuoP3T/
	5O+Fu2LNDd92IwoceIHTE+fo6Qj8XWSKJLNqK7Gk8arTbzPmY+b5Pgc1WBwd4Fga7bXLD8uTJXi
	0F1aHwd+509akk1HyhbSQrVLST0pi7isWFQ=
X-Received: by 2002:a05:600c:3e05:b0:4a0:2391:6540 with SMTP id 5b1f17b1804b1-4a18e4cdbd0mr281195195e9.25.1791970655308;
        Wed, 14 Oct 2026 02:37:35 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de3f7f8b8sm9365477f8f.35.2026.10.14.02.37.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Oct 2026 02:37:34 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
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
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 00/11] mm: Memory providers for guest_memfd and iommufd
Date: Wed, 14 Oct 2026 09:37:22 +0000
Message-ID: <20261014093733.90312-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 21FF220006
X-Stat-Signature: raxkehj4asr1nrnr7yw5mtwbpwx8dcq5
X-HE-Tag: 1791970657-628166
X-HE-Meta: U2FsdGVkX1+MfeX834FqCQSEOt8wO1BKBfD9T227pbXnhXJ09++iHcdGvXWmqx6J5ITVZGcYIpkuHwP0paxe+OQiz2t/7fXAy8PeQkA32XFU5/dtmt83udcMWm+xpvdJcpQ2sLyBT5/9LO7dELWERXtkm2SeQYIw90Rt04Bv7OldV0XUMwUGenDQRNylhUWyotO2vXzOgktFwKlOHnkZP1TbH0uTggbTycngLYQ5Z6OtP11P8h6PlZhT+mB6bmozwBWcGix7cPIdMoCAl6FEH7UIpLNf533AW3MhSFfpy81jMgJVLHGhHX9a8mXvEgwGvSpBFjydQk2u99An5AYJjXz9a4dSbU3xInDAb3p6Ewbqsy43SGvykP/F54YYqlw7UGlbEISLQ/wiS2DUT0NDb5HJs6wR2iy86DpyQOAParQXppltl8KI9rQVyUdl93IKpV95GzdfFurBYSpiyTbMW2TXm3JnHyBvDQpJigpF9+vnQQhngsoYxvQ/5dfORO+hansb6qVLkhayC3O6e3Aq/UN0Wq2VH9BZRYKMNOLUMA7W2oG6ofHnce4hwpOgubXEv/XBm48WvVdsGrCOTN/kdW5iw/X//iRjXbAzgnFwqRytYuy+mcfdBtiUOvcNJy+XxWPIdGRIP6svwbzDUdJ75hRgsNfL7SZM6+P0jlBYAg5ekReybn7hlFNK8ikXTLfsEVTmRecQRb86pjeBPdVxl3lv25hVvPNHYdzJ2DeaTVjvJT2c8bwJUOWinDcQ2pLW5gFpv9QdN1SDrlNP4cqgBCUTIWXGXvGQcPpMFUlLsV4bKEZO3+94DtJnYLjKFN0gtwV17zNiTRQQ7kJO0As5Ftq3XgFxqrKywZIdX4pyjgGtyHoZ8YQoFeiLLkgP30ravS+rUV3dUzri+sFrWr7RtBCtJZ1Hab2l1M+MGr3bm0siK/FDvhM/u146dm1xonB/Uq0zxKmToQ/XiArbwE9
 S4lF1lTd
 PlPeaQ5+3zlxraVybMYxAF7I9GCHwmbNMZu4iF2qwVdLsSlHtDKmvkYvghu0ygibsBO9DkA9pHEhYDRl5+c4/eaCKoO3wXRusrQRq0+4G1jagEh7l0bA2lnvS9nQE1INDuEjcts46h7YwxopaakcO6XRP4BdL9nlI+l5cp8JUfD1LQf08qKL7zH2aJ81W3G+KCm4rlSGRsyOVlPW1yq0n/88uFbRTlEjtywMKz7OtVd/EiwDJO9NDubVj+kI2daCOAXj5Wg3Wy5mv9HMiQ7kI9B+AhYdCj66XZJKMJTfRgdLS+6BJBuw54TOuGaEX5XLFQfw+njRtsQnB4c2rkNkDoKinjTNHOHgwYQT9Q7n3N35eG5uftQ/vTUL6w4WkaIL6htQTMhjnRREvyhukQUBc1stg8GjFVVdx2BoH90D9MH8SC+KkBcj41Ap+AGPleEd7TSaBw3kw1XogxWy4xRt+N48FNEDCC4fSsKfleQSUxK6FsOQuKafUiNt9A+CcH8Kj1tiJ1HblRdp+/DcIfkZ6sKaovQN3Mwju6SYI5E2QeL85k/ENfL9tD/s+W6r4L+chirx7DHUo3dvcKQuKr5asCtmv/7cZhAwdnBQxOXBpoUmUo/bzdWncVcuGmxIpK3NM5GqMBfvdrh/8bqV34mVrJY9i7nDuGeB0UCIhm6qHk+e/8gz5/nin5W2mQJI2dow32QYaqALdPgHkeVf4njat3dIP+w==
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
is short, and it only revokes on unbind. iommufd can map MMIO, but KVM
takes only RAM, because it picks the guest memory type itself.

Neither consumer keeps state about the provider's frames, which helps
with live update. guest_memfd has nothing to save across kexec, since
KVM refills stage-2 on faults. The provider saves its frames and who
owns them. Devices cannot fault, so their mappings stay part of the
existing iommufd live update work, and the provider only has to give
back the same frames.

Confidential VMs
================

This series does not support them yet. For now only x86 VMs of type
KVM_X86_DEFAULT_VM can use a provider. That type also covers legacy SEV
and SEV-ES guests set up with KVM_SEV_INIT: for them, a revoke and the
closing of the file write back the guest's caches, so that no stale
encrypted line reaches the frames once the provider reuses them.

For VMs with private memory, guest_memfd converts pages between shared
and private, so it should tell the other users what to zap. Only
guest_memfd knows which pages are private, and revoking a private page
loses its contents, so a provider should not take part in conversions.

The interface fits that model too. guest_memfd can be a provider for
its own file: it returns the frames of shared pages, reports private
pages as holes, and revokes a range that it converts to private.
iommufd then maps only shared pages, without pinning them, whether
guest_memfd allocates folios or takes its memory from a provider. In
the second case, guest_memfd forwards the provider's revokes. I left
that for a later series.

Patches
=======

  Patch 1 is David's: guest_memfd gets a per-file struct kvm_gmem_ops,
  and the native backend becomes one implementation of it.

  Patch 2 lets a kvm_gmem_ops backend map a page read-only for the
  guest. get_pfn() gets a writable output that it may clear, and a
  guest write to such a page exits with KVM_EXIT_MEMORY_FAULT.
  KVM_MEM_READONLY can't be used for this, because guest_memfd slots
  don't allow it.

  Patch 3 adds the interface and the core, and the FOP_MEM_PROVIDER
  flag in struct file_operations.

  Patch 4 adds the provider backend to guest_memfd, behind
  GUEST_MEMFD_FLAG_USE_RESOURCE. guest_memfd also handles the
  userspace mapping of the file, if the provider allows it, so
  providers don't each have to get the fault and revoke handling right.

  Patch 5 prepares iommufd for tracking pages it does not pin. No
  functional change.

  Patch 6 lets IOMMU_IOAS_MAP_FILE take a provider file. iommufd pins
  nothing and maps only what the provider backs; a revoke unmaps the
  range and maps it again. A scratch page for devices that cannot
  fault is left for a later IOAS quirk, as David suggested.

  Patch 7 maps each block the provider reports with large IOMMU pages
  where the IOVA and the frames are aligned alike, one call per page so
  that a revoke never splits a map call. A large IOMMU page can only be
  unmapped whole, so a revoke that cuts one unmaps and remaps all of it.

  Patches 8 and 9 add iommufd selftests: two mock-domain queries and a
  mock provider.

  Patch 10 adds a sample provider. It gives each VM a child file, can
  move, donate and reclaim pages, and supports read-only pages. A child
  file is read-only to its holder; the owner changes it through the
  control device. It only uses the mm interface.

  Patch 11 adds a KVM selftest with one provider and two VMMs. After
  each change it checks what the guest, the device and the VMM's mapping
  see. A third VM checks that KVM maps an aligned block with a 2 MiB
  page, and drops it when a page inside goes away.

Testing
=======

On x86_64 in QEMU, with KASAN and lockdep: mem_provider_test,
guest_memfd_test and the iommufd provider selftests pass, with the
mock IOMMU domain only. Each patch builds with KVM built in, as a
module, and with SEV. arm64 is not tested.

Changes since v1
================

v1: https://lore.kernel.org/all/20261006183235.16576-1-griffoul@gmail.com/

  - Sit on David's kvm_gmem_ops patch alone instead of his whole
    series; its revoke, iommufd exporter lookups, sample and selftests
    are replaced by this series.

  - Take the provider file through Ackerley Tng's
    GUEST_MEMFD_FLAG_USE_RESOURCE and resource_fd [1], as discussed
    with Aneesh and Ackerley. A file that is not from a provider fails
    with -EOPNOTSUPP.

  - Map the blocks the provider reports, so the IOMMU can use large
    pages, and flush the IOTLB once per revoke (patch 7).

[1] https://lore.kernel.org/all/20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com/

David Woodhouse (1):
  KVM: guest_memfd: Introduce guest memory ops and route native gmem
    through them

Fred Griffoul (10):
  KVM: guest_memfd: Let get_pfn() report read-only pages
  mm: Add memory providers
  KVM: guest_memfd: Add a memory provider backing
  iommufd: Track the domains of pages that are not pinned
  iommufd: Map memory provider files
  iommufd: Use large IOMMU pages for provider mappings
  iommufd/selftest: Add mock-domain IOVA queries
  iommufd/selftest: Add a mock memory provider
  samples/kvm: Add a memory provider sample
  KVM: selftests: Test a memory provider shared by KVM and iommufd

 Documentation/virt/kvm/api.rst                |  46 +-
 MAINTAINERS                                   |   8 +
 arch/arm64/kvm/mmu.c                          |  13 +-
 arch/arm64/kvm/nested.c                       |  16 +-
 arch/x86/kvm/Makefile                         |   5 +-
 arch/x86/kvm/mmu/mmu.c                        |  18 +-
 arch/x86/kvm/svm/sev.c                        |  13 +-
 arch/x86/kvm/x86.c                            |   9 +
 drivers/iommu/iommufd/Kconfig                 |   1 +
 drivers/iommu/iommufd/io_pagetable.c          |  37 +-
 drivers/iommu/iommufd/io_pagetable.h          |  58 +-
 drivers/iommu/iommufd/iommufd_test.h          |  40 +
 drivers/iommu/iommufd/pages.c                 | 435 ++++++++-
 drivers/iommu/iommufd/selftest.c              | 325 +++++++
 include/linux/fs.h                            |   2 +
 include/linux/kvm_host.h                      | 100 +-
 include/linux/mem_provider.h                  | 211 +++++
 include/uapi/linux/iommufd.h                  |  16 +-
 include/uapi/linux/kvm.h                      |  11 +-
 mm/Kconfig                                    |   7 +
 mm/Makefile                                   |   1 +
 mm/mem_provider.c                             | 177 ++++
 samples/Kconfig                               |  17 +
 samples/Makefile                              |   1 +
 samples/kvm/Makefile                          |   2 +
 samples/kvm/mem_provider_sample.c             | 855 ++++++++++++++++++
 samples/kvm/mem_provider_sample.h             | 135 +++
 tools/include/uapi/linux/kvm.h                |  11 +-
 tools/testing/selftests/iommu/iommufd.c       | 185 ++++
 tools/testing/selftests/iommu/iommufd_utils.h |  69 ++
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  |  15 +
 .../selftests/kvm/x86/mem_provider_test.c     | 653 +++++++++++++
 virt/kvm/Kconfig                              |   1 +
 virt/kvm/guest_memfd.c                        | 645 +++++++++++--
 virt/kvm/kvm_main.c                           |   8 +-
 virt/kvm/kvm_mm.h                             |   4 +-
 37 files changed, 3987 insertions(+), 164 deletions(-)
 create mode 100644 include/linux/mem_provider.h
 create mode 100644 mm/mem_provider.c
 create mode 100644 samples/kvm/Makefile
 create mode 100644 samples/kvm/mem_provider_sample.c
 create mode 100644 samples/kvm/mem_provider_sample.h
 create mode 100644 tools/testing/selftests/kvm/x86/mem_provider_test.c


base-commit: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
-- 
2.47.3


