Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42A37606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=HMx4aSqi
Received: by kanga.kvack.org (Postfix)
	id 370CF6B05B0; Sun, 25 Oct 2026 10:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348F66B05B1; Sun, 25 Oct 2026 10:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210A76B05B2; Sun, 25 Oct 2026 10:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB7976B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:36:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62D5A14056D
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 14:36:07 +0000 (UTC)
X-FDA: 85361398374.14.B113121
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 98AD180003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 14:36:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HMx4aSqi;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792938965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=p8TpnlZQqHoJQXNIEVycNifGEfr+D4SXzqPcwNXn9W8=;
	b=tB3TSnwddDUOOX/czKV1gvLSi3AJYeOJmvN3khILlpuqzFmrZCBPh1+bQ1D5AMg5McCObb
	ucyi7+7l9mk7jkp5fAqku/pfkd2Pcwb3awvmFnIT6XGeTOLzMIt4DjELmQUwKImdHzeYhp
	oVTk145f5CDHJkaq8N696hWPr2qeGnw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HMx4aSqi;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792938965;
	b=PWN2VPWaDU2Mtf6ivIZXl30mUR77a/+30c4Tk1sOxrKGpU2bEx043TocSdArjwMKQqTJ48
	hm0+wGCsEmDCO+fNz86FNH0k7jkyjoTacCpMSaWFQXl90taLFlRl+xR6D1A55FppkBw8aS
	vlOjNISFfZj+d/6UsVRnRcwemvwjbxI=
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5eac6c5f927so916226e0c.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 07:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792938965; x=1793543765; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p8TpnlZQqHoJQXNIEVycNifGEfr+D4SXzqPcwNXn9W8=;
        b=HMx4aSqiRH7ZXi8PK5gvMMwEJZJ1uV0/C9RNwa62oZAo/w1KzstggQDvBIFZianUs8
         Q+UnWxwKujmixdBLuuCmLyjet5fb41pFmVCSQ7BXHWntuxQXKy7molBEjftb8b+buekw
         DGK8Jo6L1HIanTDJK8BDsi523FuUeW0LsuTOWMQdXjASHxoXyhw2sQOEwsw6g4YtxcJ1
         5iWVeCxeVTbiezheKJLu0EPT5lqZeOa+AuNzfg/MkvfDkO6zGKfnvCVox9el9QbcXRsP
         LtQ6ChUxh4WLZguhNiB6p3SOO4nlZ15PI9tgZSJjXxd4tvhGzW1fGquFYXEWTDk7Ec/2
         IdXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792938965; x=1793543765;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p8TpnlZQqHoJQXNIEVycNifGEfr+D4SXzqPcwNXn9W8=;
        b=KjgaTUSdP+eVDSkeK14AmfbWpcuSsbekzUtb+ja0Le+3jW2nrTellVbFEtVDNp5fx4
         1xMLKMqi8gSGSO3PGPpRHfrY6JCKEukEiGZlCOBKYPExVPPmAJdnnIQ+DlBkH03zLdTB
         3Gl5odKCNCj8r74ksThNKjpxHCpO7OvRIaHd+X12zXAMLwnroyP60817bkI2Lpcti4OR
         g+C2xLU1O6q8LiX78ONVpjqMhVaPKv9NQzmZyXh01eEaHSBgy5EVCgm1x5MZgtnIdNkG
         tKot8AN0BvZvsivZLPpjyBzMYngLaU5KnPfqso+wgCnN4sKjJMZcqXEc6dsaLE+up3zm
         Pgvg==
X-Forwarded-Encrypted: i=1; AKwUvBzF9LIyn3tUiLGc1qgyUyRT0rw7PD2g7MBWa0H0HJ+TmMIE/MI5u7P1QdzW7JxcPEi7oDlrCfp6Zw==@kvack.org
X-Gm-Message-State: AFq9FYL2XzriEJlTOdVI4uKsi2fRmDBkK8onw+ERFCDVt+vyx3BCX/Ef
	FNG0pmRVvXT/jAkhmEEuI9MrpcwSA81ZeVPVsw62S5L6Eo68u3kfc0kwnIIONWPJ/CA=
X-Gm-Gg: AYBFou3NvvPd2UxxlaVcIivx8XjT8bblYh73JDPqykpYSRccCFtnzTJL87SH7srRt3L
	NOFoADgYmAOIupHEu21ddqJwt2oDjKClSNPXIeFgcQriw4GVaVaAvRAJGRdVb/4DIOWVjPeVbR4
	ptFWGMnw2LyssYnjT+uNqMqozr91nyqQ8pCy7oC9a2N1FuFjNs0TeVvdIKjt0VKUFMFCMRMZbEq
	EgsD72Ay3M7wUptUZ1kcySRLylbXkhxuYj9PQUCq1uVBId/sTY1OhmoQMsfkbyZ1Z5axkZlfQmR
	J+Kl68CJeiop0dNZkErefqb8eYegTYx2D+K+/u3d9S2yj/FXGAWsJzzTHhco4huERTiL23B5V8l
	kIefEFWfbcmhDI00SOmyI2Rpb5NCJbDbI4XbeFJNm95zEhleqpDy1LKhQmhjzBSPQRpw8aqT7uN
	MInNtL4mE/obgpW5VZgNn7LReG+KnBj/dsQui8MNcKW8/BmAVn3AaFMp2poDnbkxgBRcLX3908m
	Fj2AMgYQW1GJKcUJ62SDOZEXbH4/BAh3Za/wLdB8ol2ldeGme3uCIhK/H7LbcUUJJA2pHGPIK6+
	r+eLFdmg7ijl/8J5ULw1OQfY0fVKf+qqy9+okPXryGVvtJmelVsEgnUAUEEB7UBu5b2LppOHWQ4
	o
X-Received: by 2002:a05:6122:1b05:b0:5db:4749:1737 with SMTP id 71dfb90a1353d-5ec231f5be2mr1218362e0c.4.1792938964559;
        Sun, 25 Oct 2026 07:36:04 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec234618c9sm5531291e0c.11.2026.10.25.07.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 07:36:04 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	"Andersen, Tycho" <Tycho.Andersen@amd.com>,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Matlack <dmatlack@google.com>,
	"Heyne, Maximillian" <mheyne@amazon.de>,
	James Gowans <jgowans@amazon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Praveen Kumar <kpraveen.lkml@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	"Woodhouse, David" <dwmw@amazon.co.uk>,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [Hypervisor Live Update] Notes from October 19, 2026
Date: Sun, 25 Oct 2026 10:35:33 -0400
Message-ID: <20261025143601.2564170-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98AD180003
X-Stat-Signature: jra7q6791173xezn3xf6zjke3xmt1wc5
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792938965-330411
X-HE-Meta: U2FsdGVkX1+2SILnZjzBH4VDTxbxBB8EKUreAH997wB6iAbLl+4wTCCvth+UeZDrOQfFv+ZU8PdFaldkMWkxBW0AcakXCnhYiPF6c/YmM76vfmB9LUh1YgKgR8XTWXWw6xMBTpjmbKVxyCrdll16/YMw/QSxahSkAvPXpzp7HQf6Su7taeoWu9vdw7Ed6e+ZHzCgwM8Ge7zrOZQ2ve3ppdsEZvDfsHpF9hTM11QJ7aurbM3qgK/mpePCcXkzqc+GkU+ciKkx+dsDQZIkUvsp2W6D/fy411v54dbYpnI7bZmYL4tN73Ju8QzLR8W4fJ9vDaTYR+t/JoALKOoA6ITrzFKrmcm7kALWgkkS9KCJsmWy9GAxPhfAHR//oXvKLbo4qBRPD8Y7gtmUR/PguZ0YHyouMk1mYreClubueROVYI4KbCdE5dnNdjC3HtXVAYgYw7ukEKIOoqYXrj8/9KzebDHOb9s1ewzMd9nStsI/38M9Ukhas9KLaI11JxmJajtlubs2W2TBGl9YlcPJNUwliKAHv5Yh4h4Rgs0DEq4M6Ps3C84vkvr8wdUSFC6xTVgFcWi/mE7C1mey/kG0CUTXSOWaC9Y299TdF7H3irNM9VDii8NwEGicj7k5z85zFJCQuAJkCIZpdLgT0SNn9HCGEouQPehCq3QyA1Lzb009ycYxYH7IDm9j5yRLnBczWiXcKaNK65mYQIula1oEfxfxDSjLz143wOZuadXg2OVLwvqMR2mn/iAnJ5iP/uCaDdEqtP8qxZ5AwGcE8isFflWnajs7tzzbLleLP95Gjf5n2Z9cgkHIzPM39nXNFe1YPoG3CPb8Oz+iru7flke9Oxt1GcsMfQUMUSS63pMjiALoRgkyBLbWj98P85IcK1K92iVhdEO7BpOu6x1QER9PDkIxYVUUClRnbPGXODfv0KhoUtIp9FJbww/uoSYJx5DkexcY3mMvnzjuReL7O7bGLRH
 fDH42bUq
 /ofFn15srDcwGsmo7anmz3tfDd3pYlvnHK5b5fWgVlgblMRJo8kds9UW2ojjAEGpbAfsVIC36d6mUPXKZRiEGsb+k0Ywcii1lyeBGboIakIshWB/NSdg6TwKIO9D4G/34CW7gusS7X8dUSFyDG9qwnY81yZu1CgfjB0ww1SEdwoTOfBoYH1xYH51r6/6gI6LlLlBKopLKRSLcCSPbrS1qnYMae24vKf3ZUjJRJVxDApTNh7ywuqCB+3AMRnUW8lAST4e3q5rLT3TGXJ8mD6V3KIpJ7A+ll8jXCYcVxVoii+nErczZ2iKBoDedmC1d4mQejEVj2PRD6LKyDlGEGKXUq1VfiHuqpiwxq4vQyhvPUPCWpe7U0AXdHog2bBxiAKfVfCYnFp/ZF1xG7bjnHWODjGOLFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi everybody,

Here are the notes from our Hypervisor Live Update call held on October 19.
These notes are intended to bring those who could not attend up to speed
and to keep the momentum going between meetings.

----->o-----
LPC 2026 Recap & Takeaways

* Track Placement for Subsystem Topics: Following a successful experiment
  moving KVM-related live update talks (such as Orphaned VMs) into the KVM
  Microconference, David Matlack and Pasha agreed that subsystem-specific
  live update topics (e.g., VFIO, IOMMU, PCI) should target their respective
  subsystem microconferences next year. Now that core Live Update concepts
  are established, presenting directly in subsystem tracks ensures the
  relevant maintainers are in the room while freeing up time in the
  Live Update Microconference.

* Focused Core Sessions: For future Live Update Microconferences, the group
  plans to be stricter on topic selection—focusing the track on core,
  cross-cutting architectural topics (such as versioning and LUO core)—with
  longer time slots, minimal slides (2–3 slides), and discussion-focused
  sessions aimed at concrete outcomes.

----->o-----
Cross-Subsystem Versioning & Compatibility Strategy

* Post-LPC Alignment: The Live Update BoF organized by Pratyush Yadav at
  LPC helped clarify maintainer expectations and establish a path forward
  with Sean Christopherson and Jason Gunthorpe without blocking ongoing
  series.

* Minimal Expandable Header First: Rather than trying to lock down a full
  versioning UAPI upfront—which requires extensive scrutiny given permanent
  UAPI stability guarantees—the group will start by introducing a minimal,
  expandable serialization header (with size and feature flags) and updating
  all existing serialized structures across upstream Linux to use it.

* Next Steps: Tarun Sahu took over sending the initial expandable header
  patch series from Pratyush, as it directly unblocks the guest_memfd and
  KVM preservation work.

----->o-----
PCIe Persistence

* PCI v10 & Target Kernel Retargeting: David Matlack posted v10 of the base
  PCIe Live Update series, adding ACS egress control vector save/restore per
  Alex Williamson, kernel-doc improvements per Mike Rapoport, and a flags
  field in the serialized structure (to be replaced by the standard header
  once available). Because v10 arrived too late for sufficient linux-next
  soak time ahead of Linux 7.4, Mike Rapoport noted off-list that the series
  will now target Linux 7.5. Pasha will merge v10 into liveupdate/next
  immediately after the Linux 7.4 merge window closes.

* PCIe Core Roadmap & Upcoming Series: David published the PCIe core live
  update roadmap to the mailing list prior to LPC:
  - PCI Save State Refactor: Posted upstream to restructure PCI save state
    data structures in preparation for VFIO preservation.
  - Peer-to-Peer DMA & MMIO Preservation: Ready to post this week. Preserves
    bridge windows and device BARs and avoids destructive BAR sizing during
    enumeration so preserved devices (and Orphaned VMs performing MMIO) can
    continue memory transactions across kexec.

* Testing Strategy: David is currently validating the peer-to-peer DMA
  series using the VFIO live update kexec selftests under QEMU with PCI
  config space write tracing to verify that preserved BARs and bridge
  windows are untouched across reboot. To enable standalone PCI core testing
  before VFIO support lands, David plans to prototype a selftest kernel
  module (a minimal no-op PCI driver that binds to a device and preserves
  it via LUO).

----->o-----
VFIO Persistence

* Full Preservation via no-IOMMU Mode: Vipin Sharma returns from parental
  leave on October 21. At LPC, the group agreed with Alex Williamson to
  restructure the next VFIO series so that it lands full VFIO device
  preservation in a single series using no-IOMMU mode (preserving internal
  driver state and skipping device reset across kexec), rather than landing
  a partial series that resets the device.

* IOMMUFD Integration & Ordering: Once the complete no-IOMMU VFIO series is
  in place, Samiullah Khawaja's IOMMUFD persistence series will hook into it
  via a single small patch calling IOMMUFD preserve/unpreserve/restore APIs.
  Samiullah clarified the dependency ordering: userspace preserves IOMMUFD
  first (preserving core domain state), followed by VFIO. Because an IOMMU
  domain may have multiple attached devices where only a subset is being
  preserved, VFIO calls into IOMMUFD during its preservation step to
  preserve the device-specific IOMMUFD state whose lifecycle it owns.

----->o-----
IOMMU Persistence & LUO Core

* IOMMU v6 & Architecture RFCs: Samiullah received review feedback from
  Nicolin Chen and Baolu Lu on v5 and is preparing v6, incorporating
  LPC UAPI and design updates. Additionally, AMD and ARM IOMMU preservation
  RFC series have now been posted to the mailing list; Samiullah will review
  both series.

* Dependency Ordering & Early Freeze: Samiullah will defer his LPC proposal
  for explicit FD dependency tracking and batching in LUO. Following
  discussions with KVM maintainers on how live migration enforces strict
  ioctl ordering in userspace, Pasha and Samiullah agreed to enforce
  dependency ordering on userspace during preservation, while using Pasha's
  new user-triggerable early freeze patch as the synchronization point to
  resolve any circular dependencies across file handlers.

----->o-----
tmpfs File Preservation

* Refined Retrieve Design (O_TMPFILE + linkat): Building on the LPC
  discussion and subsequent mailing list refinement by David Matlack,
  Pratyush Yadav, and Pasha, LUO will create the restored tmpfs file
  directly during the retrieve ioctl via generic arguments rather than
  backfilling a pre-opened userspace FD (avoiding races with concurrent
  userspace accesses).

* Unlinked File Creation: Modeled after openat(2) with O_TMPFILE, userspace
  passes a target directory FD and flags to retrieve, and LUO returns an
  unnamed, unlinked tmpfs file FD on that mount. Userspace can either keep
  it as an anonymous temp file or link it into the filesystem namespace via
  linkat(2). This keeps LUO completely agnostic of filenames and variable-
  length path strings.

* Patch Series Split: David will include Pasha's generic retrieve argument
  patches in the next revision of the tmpfs series. Pasha's early freeze
  patches will be split out as a standalone series, with Pratyush reviewing
  them on v1.

----->o-----
KHO & Scratch Memory

* Scratch-to-Bootmem Rename: Pratyush reported that the patch series
  renaming KHO "scratch memory" to "boot memory" (bootmem) is queued in
  liveupdate/next.

* KHO XArray & Sparse memfd Support: Pratyush has implemented the KHO XArray
  data structure and is integrating it into memfd. Pasha and Pratyush
  discussed using sparse memfd preservation (large virtual address space
  with unpopulated holes) as the primary motivating use case and selftest.
  Supporting sparse memfds without faulting in holes requires updating the
  pinning path to pin only populated pages and disallow new page faults
  after preservation; Pratyush will evaluate the fault, migration, and swap
  path implications.

* CMA Pinning Bottlenecks & Scratch Memory: Pratyush noted an Ubuntu bug
  report where KHO's pre-reserved CMA regions restrict pinnable memory for
  GPUs. Tarun has been analyzing CMA allocation behavior: normal movable
  allocations default to ZONE_NORMAL until it fills up, leaving no room for
  pinned allocations in ZONE_NORMAL because movable pages are not migrated
  into CMA (ZONE_MOVABLE). Tarun discussed adding ZONE_NORMAL-to-CMA page
  migration with David Hildenbrand, who agreed it would be a valuable
  kernel improvement to alleviate CMA pinning pressure while longer-term
  alternatives to pre-reserved KHO scratch memory are investigated.

----->o-----
PowerPC & LoongArch KHO Support

* Real-Mode Execution of kho_populate(): Sourabh Jain reported a review finding
  from Sashiko on the PowerPC KHO series: kho_populate() was being invoked
  too late during boot, after several early memblock allocations had already
  taken place and could overwrite preserved memory regions. On PowerPC,
  running kho_populate() prior to any memblock allocations requires calling
  it in real mode (before the MMU is enabled in start_kernel). However,
  generic kho_populate() uses early_memremap(), which returns virtual
  addresses that cannot be accessed in PowerPC real mode.

* Architecture Mapping Abstraction: Sourabh and Pratyush agreed to add a
  lightweight architecture abstraction so generic kho_populate() receives a
  usable pointer—continuing to use early_memremap() on architectures like
  x86 (where the MMU is active and uncached physical accesses are slow)
  while allowing PowerPC to pass a direct real-mode physical address.
  Sourabh plans to post the updated series this week.

* Static memblock Array Limit (128 Regions): Sourabh also checked whether
  populating KHO regions before dynamic memblock array resizing is enabled
  could hit the static 128-entry BSS array limit. Pratyush and Pasha confirmed
  that 128 entries are shared across architectures and sufficient for 2 + N
  scratch regions (where N is the number of NUMA nodes); if ever needed,
  dynamic resizing can be enabled as soon as the first scratch region is
  registered, or the static size can scale with CONFIG_NODES_SHIFT.

----->o-----
Guest Memory (guest_memfd), KVM & Confidential VMs

* KVM & guest_memfd PoC Series: Following LPC discussions, Tarun Sahu is
  preparing a combined PoC series (VM preservation, vCPU preservation, and
  guest_memfd preservation) by the end of October to demonstrate the end-to-
  end ABI for KVM maintainers, after which guest_memfd preservation can
  proceed standalone. To unblock this, Tarun is also incorporating custom
  arguments for LUO preserve and retrieve ioctls alongside the expandable
  serialization header series.

* Confidential VMs (TDX & SEV-SNP) Require In-Kernel Live Update: Pasha,
  Sagi Shahar, and David Matlack confirmed that confidential VMs (Intel TDX
  and AMD SEV-SNP) cannot perform host kernel updates via userspace live
  migration / copy-out flows: guest memory and control structures use
  physical-address-dependent encryption (pages cannot be relocated in
  physical memory) and architectural state (TDX SEPT tables and VMCS pages,
  or SNP RMP/VMSA state) cannot be exported to userspace. Consequently,
  in-kernel KHO/LUO preservation of guest_memfd, VM FDs, and vCPU FDs is an
  essential requirement for updating hypervisor kernels running confidential
  VMs. Sagi noted that Google's internal copyless TDX migration uses this
  same in-kernel transfer approach.

----->o-----
TDX Module Preservation & Orphaned VMs

* TDX Module Preservation Status: Sagi Shahar reported that TDX module
  preservation across kexec is working. He is now connecting it to TDX VM
  preservation, where the main remaining hurdle is traversing and preserving
  Secure EPT (SEPT) tables across kexec. Pasha pointed Sagi to the EPT
  traversal and preservation implementation in the Orphaned VMs RFC series.

* Orphaned VMs Supporting Series: Pasha posted two new upstream patch series
  supporting Orphaned VMs:
  1. Read-only KHO: Enables the lightweight Linux caretaker to read preserved
     KHO state without full KHO initialization.
  2. CPU Hotplug (Online/Offline) Performance Improvements: Standalone
     series accelerating CPU offlining and onlining, benefiting both general
     host operations and Orphaned VM physical CPU preservation.
  Because time ran short, Orphaned VMs will be moved to the first agenda
  item for our next meeting.

----->o-----
Action Items & Next Steps

Pasha:
* Merge PCI v10 into liveupdate/next right after the Linux 7.4 merge window.
* Split early freeze patches into a standalone series (separate from generic
  retrieve arguments).
* Move Orphaned VMs to the top of the agenda for the next meeting.

David M:
* Post the PCIe peer-to-peer DMA / bridge window & BAR preservation series.
* Prototype a standalone PCI core live update selftest kernel module.
* Incorporate Pasha's generic retrieve argument patches into the next tmpfs
  preservation series using the O_TMPFILE + linkat model.

Tarun:
* Post the minimal expandable serialization header + custom LUO preserve/
  retrieve argument patch series.
* Post the combined KVM VM + vCPU + guest_memfd preservation PoC series by
  the end of October.
* Continue investigating ZONE_NORMAL-to-CMA page migration for pinnable
  memory pressure.

Pratyush:
* Review Pasha's standalone early freeze patches on v1.
* Evaluate memfd pinning and fault-disabling changes to support sparse
  memfd preservation with KHO XArray.

Samiullah:
* Post IOMMU persistence v6 incorporating review feedback and LPC updates.
* Review the AMD and ARM IOMMU preservation RFC series on the mailing list.

Sourabh:
* Post the next revision of the PowerPC KHO series with real-mode
  kho_populate() mapping support.

Sagi:
* Review the EPT preservation logic in the Orphaned VMs RFC to integrate
  with TDX SEPT table preservation.

----->o-----

Next meeting will be on Monday, November 2 at 8am PST (UTC-8), everybody is
welcome!

Join Here: https://meet.google.com/rjn-dmzu-hgq

Please let me know if you'd like to propose additional topics for
discussion, thank you!

Best regards,
Pasha

