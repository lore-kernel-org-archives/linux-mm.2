Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D18C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 15:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 834AE6B06CB; Fri, 14 Aug 2026 11:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796386B06CC; Fri, 14 Aug 2026 11:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC306B06CD; Fri, 14 Aug 2026 11:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FFAA6B06CB
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:05:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9AA9B4016C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:05:04 +0000 (UTC)
X-FDA: 85100197728.23.8D812FE
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id BC10C1C0013
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:05:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HSBNIpIn;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786719902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=86UK8C/44s//WP7keHPKgb58fEaGLPE6HLPpAhR5zNg=;
	b=wLvGx9/1/3go1RW0sEaqOeKBoWJjeD6lH2/uCYsoacH1PTvd/jfmvflh4EwQzX0NDXndBR
	br7auSfTTHGVpod4uxAJ00D1l4pnSRMb8xDIMVdYtViqsIxyGGkpqryiZO4wRMpl4klgTi
	1J544QuE26M7IQEzv7NZ7s1OWbGGaPg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HSBNIpIn;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786719902;
	b=wvgzwKEs1Tcknjk0s8lPPJ64cJJHgX6vNn/Ck+y0RJPZp969F4UxH8Mh0gKmA954L5o0+n
	KdNXtCti6ih5byBvhif3LdnOO1De7mJsMqjt3NaseTMHF2JGclCbm09CA3+gb4JW20vVbG
	yENUTOfK7AE9TOr0+uN7TSi5DPCBNIQ=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-836cd7310f4so16322007b3.2
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1786719902; x=1787324702; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=86UK8C/44s//WP7keHPKgb58fEaGLPE6HLPpAhR5zNg=;
        b=HSBNIpIniHFMmSJN29H1JrJ0rv9OA/IutZYODTlVebh7NhOr2UuMZgKmQmK9uwBIV5
         b62qO8cgiKlFLPX0IthlTAP9U/VLD3etY/+zNdPj7CwTFhenGoX7GxY7yNGKlgXbC3ea
         3nbyZd7oqUvOnO79uwr0XEaKU1gN1i/nkMX7r3XrTnvUrCHZk7S29xRu+7LHPBFC69ma
         am/KMvkAVam1vx3i84n6VwK8ltMIcZita4JsjNuL4POiIWSzSGRKcyNTHEhc5NfkZejO
         rsRc8nlzq6LcQT4e9nyxwGvZDlLixMT4O7cJ10DJlJ/O+eUw2hqHarHd2oR8oD8JRm1s
         0Grg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786719902; x=1787324702;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=86UK8C/44s//WP7keHPKgb58fEaGLPE6HLPpAhR5zNg=;
        b=CzkQ5na5yHSxuVppLPhSlCbTbd8zswwvI2X/AaD2GPE2yw3TdTjTUW6bQoCxGFyuTp
         cJ20U3Yfn9ypRxNEot31vN/6lt8yA9whF46G30k5+JRXgTq2ACY8nnc2x4d/yuz7J9jL
         ER2RusG5t0lkmSHTk8K7kl588GHYgdbBHQemDWSie8Xe/nOf68A7t2d6Y+GAcSJjBeoP
         ERE/O3nXOiLYWY3z+j4zBGvVWT0fUIa5jf3/L884lxCGTsAqcCop2wveqVOI0um6Y6qV
         ssRbJH1QYlEkWWqQ6mnk/qJLi8G8NAOLz5vGB/Ml85z36uhCQxzkN4psgiEfKb5Lpt/6
         kdFw==
X-Forwarded-Encrypted: i=1; AHgh+Rqv+GHCJ/VrJB+/L18t8bK1cO/LGNsDCbCzHALCSRHyx4B1OOHu0qhB1UMkrv0tfAz0X1NWJJR6iQ==@kvack.org
X-Gm-Message-State: AOJu0YyTGuZk5/zbnjalvjIvBzCXNF7MZUdkWQ8mKsIO3EC776fz233H
	kyDqFPwgszy96HCZWm7PBvnTQ3zzBFZaiDuDwszYAIXHtfSmmH9rtXk0LUhO3oG6Dcs=
X-Gm-Gg: AR+sD11oNKQwpDSoF5dkMmYM2ukisWcmmdAOJXdx6+uS+1CwYh65KtJuOZOiaqKCEjz
	tO8PXG+VDMGlKrykoxTRjgh5LXeUPydpOKIQyy1w9AuRT1NEGxZkz6rYsZ91BkIq1pZ4zyDrAeE
	imwxtm/AC+AIM6wruAysKJGawbDaNnkTKPEC0rUvBj79gbFw2Afgx/TdRVWcIhRhAjiFbJ7oR3n
	Mwu/LKdjNeN3AYLo7VPK/vZ1R2MQFBMTvE9vvZ7+IxpU+YDucdCyIQuJxYkKIz3v15LxIEnf4UE
	YlE2O6fT/y8iaBPervjWPds0d8VKadREpHELpffRe/hVH8t2rBeGQdT+ksmmA6r4COtTbCxkACU
	gs9sfoyBWi05/ZzqzYbasVhi8mgYawHWGntnKqcekwua7rVA2+unzZ1PCtZHwvD9GBNE7xYgCP2
	Bno/Sxaa6m6hbSlKS5AJSnAR1EtllIy/wVxd3SHKK/N2l9mr+t/AKi9k38YW+zs7aI0CAPaRM+U
	nR+CcU+KA2C0sGRwk4kESI1wcqZSPuqnE02UAWXq9Pp03ERRc/80ScMr0hsUssRop//IlJmktkU
	nYGpQ1xasN+wNc23
X-Received: by 2002:a05:690c:388:b0:81f:e85b:f9da with SMTP id 00721157ae682-83713575858mr25091967b3.33.1786719901568;
        Fri, 14 Aug 2026 08:05:01 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-836c1778540sm14328757b3.29.2026.08.14.08.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 08:05:01 -0700 (PDT)
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
Subject: [Hypervisor Live Update] Notes from August 10, 2026
Date: Fri, 14 Aug 2026 11:04:53 -0400
Message-ID: <20260814150457.2268163-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8kqbc75xo7pncixaiej5hxrjxmqkpeaj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC10C1C0013
X-HE-Tag: 1786719902-906003
X-HE-Meta: U2FsdGVkX183Qb5/iwLUeoq3vsGnpHDDxK7NfJ7ggvS4rZ68cHbtDt1MaGRYmKdM/xf4M36w+3Cg6EC72ZKZEmUTBaymYavipduXYLphbL6+12znOPVKEYClt+eWdb1P8Zla3bTsu4wJl5LcGcS9rE++ZoWHFs35AhgaxlOm6YW/eejKB++VeK7ZFlHWBrplA0Mcv7VgLVks//DOMcbHGcY2K9kBLBNE7cZRURKHjoaY8NzsMv97LQYmJy4jVoyCMpUPKHVsfTPM9oQ+T1jlIAVWMcIB+xavS2u7ceTetwJJdWsib2P2KEVfBm7QlbhJMRnf8lfaoO0L+WRZSM6jWdhsxrcP2e+tEaElgyCkPvGNSw+VCLZ0p1PChXwHo/6RIiuHtpErxduLnI5ky2UVLkRX4r/F8q8V2CihXR0zmLrDDDJsjWdddOIJMhYi7wcpq6PnGzWAlQEQW8RkJ48hiqENsfCcO+nLtE5Xxumg7FdkyoApYt0eh4OYpGimKW4GJNSpQ4vs6ymx9zJKUdIqdBjYI1Zd3thDkVQB0MDyuiVJJsMeki2j1+YbDVC2o1cAr4KZilfnJxAs54g9NifeDD/TExHAp4Z3K3ZKnXxEqP6b0AR8TssBLXbUAh3u6oiiRDuL3SHYB4F6Q+DoAdvhq+caDwLyfEZ/4A9cih5g9gxqEoCqL2eMhyICGjehImAMGZmHRp1RpTS0J++6+miOd3o0wvjuNpj8PnROOvCJ7XWCk0Z1pTPHWJdhXZNmV8luH1tuQiCfRUVCcfY96muN+BBqQ5gtP7VTIdoWB6F5M3B8YaHWo9YszcLDiTKn6pUQQmlUFZR3y8M7NLwsP633v2J8aCbVmmBWDH33XNOVD4TwR/SpquhaldY83YIugmzSEj806gv744A28ZfmVKWYBza7DkRf5hntn6+RAyj++4mgf+gJNcLujAmVquKg5YkiAnodpJ+M/bgEDGUmaTh
 8/Ym/tYe
 9TfkIiXyQonm1DJVjRYJ4mpe7tajCPsKuDIkQya39sahtizcY4F86vLCCbjAr75olFMzsZhF5g9852LQ9uybJwlTP6idQz+PKowff4BadFX6AXNQjvapeE+kDjOIwHi/ehEMHPfYcJwHQcszPQ3brTtnGUxBVK3lvo4X21srnDSFGVqmVCwlOoV8xiTR1X2d0P6oO8XIfin9ImKznvOVvGrnPFYQGXs5tOxFaB9gFCTKmy7fxIDyctOfDNkaWJy2/Rdj34uYY10sY9HHLNCa3O+V9Sij6nZBcyqTQBW7RiKiQvp09uzCjf5ZaMs+OF4L7YLQd7Ud/yGuZtNEvm9MysFCbJoGh1dn1JzEYrdUoRSnh68mat7Xn1h5z6Zhe1IGxiV7FEtGJCJFDYZk9koptJ/nPDS92lhs/jRPW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from our Hypervisor Live Update call held on August 10.
These notes are intended to bring those who could not attend up to speed
and to keep the momentum going between meetings.

----->o-----
LPC 2026 Proposals & Microconference Planning

* CFP Closed: The Call for Proposals closed on August 7th with 13 submissions
  received for the Live Update Microconference.

* Review & Track Balancing: The organizers are reviewing submissions to
  prioritize key design discussions. Three topics (Orphaned VMs proposed by
  Pasha and Pratyush, and guest_memfd preservation proposed by Tarun) have
  been submitted to both Live Update and KVM tracks. Organizers will coordinate
  to balance the schedule and ensure appropriate track placement without
  duplicate sessions.

* Session Timing: The group discussed session lengths (considering a mix of
  lightning talks and longer interactive discussions). The Live Update
  microconference schedule is finalized with no overlap with the Networking
  track.

----->o-----
PCIe Persistence

* PCI v8 Status: David Matlack sent out the PCI v8 series two weeks ago,
  incorporating review feedback from Bjorn Helgaas on v7 and moving versioning
  out of the compatibility string into the first field of the pci_ser structure.

* Landing Strategy & Linux-next Soaking: Although too late for the 7.3 merge
  window, the group agreed to create a separate PCI branch and start soaking
  it in the Live Update tree (liveupdate/next) so dependent series (such as
  IOMMU) can base on official Linux-next, targeting Linux 7.4. Pasha will
  review and add Acked-by tags.

----->o-----
VFIO Persistence

* VFIO v6 Status: Vipin Sharma is preparing v6 rebased on top of David's
  PCI v8, targeting submission before our next meeting.

* Landing Tree: Awaiting feedback from Alex Williamson regarding the base
  landing tree. Pasha will follow up on the mailing list thread.

* Lockdep Investigation: Vipin will start a separate mailing list thread with
  a reproducer for the CPU hotplug / ATS lockdep warning to address it
  independently of the Live Update series.

* Testing & Review: Zhu Yanjun verified the VFIO live update test setup
  successfully in QEMU. Vipin requested code reviews from the group on
  David's patches within the VFIO series.

----->o-----
IOMMU Persistence

* IOMMU v4 Status: Samiullah Khawaja posted v4, incorporating Baolu Lu's
  review comments, refactoring code into live_update.c, fixing lifecycle bugs,
  and aligning compatibility string versioning with PCI.

* Landing Tree: Confirmed with maintainers (Will Deacon and Baolu Lu) that the
  series will land via the IOMMU tree (as noted in the cover letter).

* Ordering Guidelines: Samiullah will document in-tree guidelines for file
  preservation ordering dependencies (e.g., preserve() vs freeze()) in a
  future update.

----->o-----
KHO & LUO

* KHO Extended Scratch Memory: Pratyush Yadav's KHO extended scratch memory
  series (v4) has been soaking in Linux-next for a week and is on track for
  the 7.3 merge window.

* Scratch to Boot Memory Rename: Pratyush will now proceed with the follow-up
  rename of scratch memory to boot memory across the codebase.

* KHO XArray: Pratyush is developing the initial skeleton for KHO XArray, which
  will provide the foundation for removing freezing requirements in shmem and
  guest_memfd.

* LoongArch KHO Support: George Guo submitted a new version passing the KHO FDT
  pointer via a new EFI GUID. Ard Biesheuvel provided an Ack for this approach,
  establishing a clean, generic method for LoongArch and any architecture
  using EFI.

----->o-----
PowerPC KHO Support

* PowerPC Enablement: Sourabh Jain (IBM kexec/kdump maintainer) joined the
  meeting to discuss enabling KHO on PowerPC.

* Memory Reservation & Discovery: Sourabh reported scratch memory allocation
  failures when Kdump (3GB) was configured. Pasha clarified that scratch memory
  does not require low memory allocation. Pratyush clarified that KHO scratch
  discovery (kho_populate()) must run very early right after memblock
  initialization to activate scratch-only mode before any memory allocations
  (including Kdump) occur. Cold-boot reservation (kho_memory_init()) happens
  later after mm_init().

* Next Steps: Standalone KHO tests pass on PowerPC without Kdump. The group
  recommended submitting the initial PowerPC KHO series with Kdump mutually
  excluded or documented in the cover letter, followed by investigating early
  virtual mapping / Kdump co-existence. Sourabh will participate regularly
  in future meetings.

----->o-----
Guest Memory (guest_memfd)

* guest_memfd v4 Status: Tarun Sahu addressed review feedback from Ackerley
  Tng. Test cases will be split across separate commits within the test file.
  The initiate_shared flag is replaced by checking kvm_arch_has_private_mem()
  to verify whether confidential guest memory is supported.

* Freezing Removal: Removing the freezing requirement will be addressed as a
  follow-up feature using KHO XArray and will not block the initial guest_memfd
  landing.

* Module Loading Requirement: The group discussed handling un-loaded modules
  during live update retrieval (missing file handlers currently cause
  retrieval to fail for all sessions). The team agreed that for hypervisor
  environments, all required modules (e.g. KVM) must be loaded prior to
  session retrieval. Tarun will update the LUO documentation to explicitly
  state this requirement.

----->o-----
HugeTLB

* HugeTLB preservation remains on hold pending the landing of extended scratch
  memory and progress on KHO XArray.

----->o-----
Orphaned VMs & Development Environment

* Multi-Architecture Environment: Pasha presented updates on the open-source
  development environment (https://github.com/soleen/orphanvm). It now supports
  Intel (Simics full hardware emulation), AMD (QEMU full emulation), and ARM
  (QEMU with GICv3 full emulation), completing live updates across kexec in
  under 10 seconds.

* vCPU Aliveness Test: A guest test workload performing continuous computations
  and memory writes was added to allow the host to monitor vCPU aliveness and
  state during CPU offline/online cycles without making syscalls.

* VM Exits: Tarun has collected VM exit trace data during live update and will
  analyze it to present findings at the next meeting or LPC.

----->o-----
Action Items & Next Steps

Pasha:
* Review and add Acked-by to PCI v8; coordinate branch in liveupdate tree for
  Linux-next.
* Follow up on the VFIO landing tree thread with Alex Williamson.
* Coordinate with LPC KVM and Live Update microconference organizers on talk
  selections and session durations.

David M:
* Follow up with Bjorn Helgaas on remaining PCI v8 review tags.

Vipin:
* Post separate thread and reproducer for CPU hotplug/ATS lockdep issue.
* Rebase and send VFIO v6 before next meeting.

Samiullah:
* Document in-tree guidelines for file preservation ordering dependencies.
* Coordinate IOMMU v4 series landing via IOMMU tree.

Pratyush:
* Implement KHO scratch to boot memory rename.
* Review LoongArch EFI GUID KHO patch series.
* Continue development on KHO XArray skeleton.

Tarun:
* Post guest_memfd preservation v5 with split test commits and
  kvm_arch_has_private_mem() check.
* Update LUO documentation clarifying that all preserved modules must be
  loaded prior to session retrieval.
* Analyze VM exit trace data for discussion at the next meeting / LPC.

Sourabh:
* Post initial PowerPC KHO enablement series and test updates (with Kdump
  mutual exclusion / caveats documented in cover letter).

----->o-----

Next meeting will be on Monday, August 24 at 8am PDT (UTC-7), everybody is
welcome!

Join Here: https://meet.google.com/rjn-dmzu-hgq

Please let me know if you'd like to propose additional topics for
discussion, thank you!

Best regards,
Pasha

