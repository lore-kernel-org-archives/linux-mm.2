Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B0FFC98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 14:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DF2F6B008C; Fri, 25 Sep 2026 10:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7016B0098; Fri, 25 Sep 2026 10:30:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CCAD6B0092; Fri, 25 Sep 2026 10:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDA386B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:30:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63E5B160629
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:30:08 +0000 (UTC)
X-FDA: 85252519296.07.0D58C43
Received: from mail-yx2-f41.google.com (mail-yx2-f41.google.com [74.125.224.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8FF8F1A000D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:30:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KY17kpVi;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790346606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZxNgNSJX4HyjFFXMdv8+7KY9lC6WrSxA50f2U6JT134=;
	b=U+ZSbSHiwjZNa3nn2xXBCNAx9V25gAZvIta45MAmGX6SQJWCuw3bkNlk/RBvx/+Wq/6+oc
	52i0AOL/EvE2RedeXQL9Ikg/VgiQO0fc5GF7GNgBFAgdpxLo6lrj0S934mNgAXYpKEWkxu
	McjINukun+BRr4LmXIJuBvjmPZSkpVg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KY17kpVi;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790346606;
	b=ww48NpLhmvz5UePATUNIZxg5r/JH020fw6VjmWuoHxRh8FSDA18iCCjJ5Grhpd2JlIcuRw
	k+2zuP5yV5Jfzuyowj6tn3C+ykUb+/CZGxGEdhmtfLvCgkrJT9GBVvxqFIaxP17eoSKD5f
	UwzyiGnkVuHDRxkVrsHHZlujgtmcSfQ=
Received: by mail-yx2-f41.google.com with SMTP id 00721157ae682-8a860e5505aso8438987b3.1
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1790346605; x=1790951405; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZxNgNSJX4HyjFFXMdv8+7KY9lC6WrSxA50f2U6JT134=;
        b=KY17kpVi7ER+xYoJ3297egH0jkNaKyKt2bjbIurh/75Sjc7tT7xqZ5yvsa+OpoCsg/
         RxSxSVW+Ws9xs4eh4yoP30y3OMyvnOgpe9rTUqWxvFLpEmputS8+LDr/KsGV/M8JllA4
         VXrqBMXT4W1PW+08/Ahuyc80C5P/hxReqlSJ1zGj/IaqrqIUv2kDAos2SlnA+QU8Td4D
         VogiFAExrLMS4cgxRiiuusX4bbpH/Zt6bVs14048GPlgkpymNVWl6EGX/EO2eFuUZuzz
         j8lBEamVZ4Epz0XC6KE0JvybQ5ykLqvEJM+oQ3HXrWgqchT0CP+wk52mGVV85CmjZIxn
         /bYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790346605; x=1790951405;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZxNgNSJX4HyjFFXMdv8+7KY9lC6WrSxA50f2U6JT134=;
        b=bh7fHxPVYS3frwVkimq6fLU+xtvozTxKcWDuiM1BW0ptZHqOUDwIq22Tp67dB+NCRm
         xIEmAQ6Sa/opDAcuSER8qCUw5dGy2NREKxjh2H8AEgKPkDlNQ2rkW8VC+Y0Xbb6TzY1n
         HBRTijcumsEc5/FrXGEgwPKlOOJV3RDO8a/dLj09H5CkvF5Spfwx6Kn6e+lda4bmkPl4
         aavJrbmSu1PPIsT99+UW4Du45MnGe6QDhpq/hcJdDLTe1uiatr/wUxaLwiZrKYbS3d5Z
         bf0prc1JsqhzGFIOM8ClFLh7HqRnwX+vWa38PVgunxJFK3UdqeiFfgbxjHgC392n+z1d
         uscw==
X-Forwarded-Encrypted: i=1; AKwUvBz4E6nhf37z6576c2S719KlGACSBxpECQr5+F2D0zJ3WjmqG7AsVdL6AZQDMhrimnqJvN0aOBS10Q==@kvack.org
X-Gm-Message-State: AFuF++keu1LneCAYnJ1CpGdpS2aiKNVKy+Qkk/87XiWChbzNSA97c3LD
	bXVr9yzJZRNY1QkBVdjsTdk8v0YH1FdHvEyibTQ5pLf/YQzGQirOxpEtIun03PcwNYM=
X-Gm-Gg: AYBFou3mfz6tWdOT0he7a8Wb3LGErkGgosmY213S5nes6HP3oLng5DnuntTNXSV1kwH
	G9C3XUowpTGtSU6++VapNiCHmHSEx+QG/q4N47w2WRC8fARf2hI3O8pd9Yb64q7UXka+kbFGiz4
	PMACeriy7UspTAjSIfP2PeYco/zpVw6qFDXCKpsIu82tTYaQN/HiN2C1k6pYRiNLZiJ2hK87C2U
	AFbS9s7xgIuZ3nKCc7bSXNJcI47pfeJMzd7W4Hi9gnP6LkrOTakwFRouKAclcLc2+ue3W4oG/Wi
	Qp8JgkBGKMNzZzMqY/xdHT/UelqJtNe/TyCSTvYvIdu0q5fvxeXugfASOrpYCI7i/BQKbjuCZQY
	xvhjimwHkYZH7l1OS6HCIBx4qudC2IoaHxSZF/WyfvhzAUb0WH4PWy3AI500NqAhHaJCSpyG2Sw
	tuabLfcT4HiBa+5NzVO36mANJOAVYDOlX8LtuIlnbzxJ+K9WqxNu7iBnqbHxspZeNzjtbBSZrvd
	9olQaQ71AD/Pn06jfD4kHUgbjhY2se+0sfUC3aJP7OzsNewtg0jYAVTZ3lUuKjE2Y7h4B5UF29A
	8Bk83Rts9lMrlBUB0n4=
X-Received: by 2002:a05:690c:c4e5:b0:8a8:675b:2bc0 with SMTP id 00721157ae682-8a8675b2e50mr10279907b3.35.1790346605434;
        Fri, 25 Sep 2026 07:30:05 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86102bbafsm8810897b3.39.2026.09.25.07.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 07:30:04 -0700 (PDT)
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
Subject: [Hypervisor Live Update] Notes from September 21, 2026
Date: Fri, 25 Sep 2026 10:29:43 -0400
Message-ID: <20260925143000.2729890-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8FF8F1A000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: pztaac6xx9bo91bx3anosyywx53hb5ck
X-HE-Tag: 1790346606-466490
X-HE-Meta: U2FsdGVkX18N6qEfTOSlQlQxz1jWgc53uiS1f3cAUOFPY9Jm5X59J3NTFUk7UR1HXrETodYiVFgMPIsxdV9+Fv3cdVXOOzCuVLUVZqhKDp1uZskIp7qNLwcsbsBPaomWcIZauDnv0Rh8c5G5CPV/DuvDqpaQxgBzuPHGDG8M6pKDP8CE1oBv6/XHD9Y2Imb8Gmj/208Brt1s+dQd0VWrMMrDhjgKlTPMRg4A0L1dJTI+esvijTppSqMwKBEPw6sep3Tiw3rHLf9Z5mKQKMGQPvhm+y4deS96+MlPcJZf4XS9x4JqXIcJHZblThWS6VPHfwFzhufHThlQyVFRPbEiOm3g23KI7j1QaStLCqB2u4ZLR7V1xty7tfkgkpI338IhjHYhW27YmmKXeDgORluI6509LhhL8SVGHicHkXKScLXkpzQfUlxcYRpswAaf5zdYhpRXSMGs7HIOhgCB4nlMdTHHNPFx2Mftrq2nUU2Z1AE08B+5aaFT4xzAEoHNURIVVfPobZuYjpRlCNU7OpRsXmjmaKXQCnW0Ozzfr15JGD9ZkMAfSEKGqbeCEk3d6j8iWGgsVbGy9kuN2wFStNLKL7XElWg+52aLqyC9xomfAKXEVnEuGW6q2/K9tjO5jigs86XPyUlRQ5TwFOR6NgXG7Yga5yQ4nr9/+jyM6E0Hia8S1WK+bxrVGz79tqgI823VreYjhiVMxq3Y2XmJO3aSuipBTfExoH8Nln3y/onEy7NvH8ssO3pgYh2EK1pcsmlD8EL3Rnly7bMRaoZykoT7IXj9d6E/wP94ipI+P7FgmL8kwAohKFx4HCRIlee2jsWHNm3G1OK/ASiRLhne2HOfe7ePqlTIZ6aQbrzeKoZVDi+bwEZhVhxMe51jPHc8hYCoSXtoxuzyPCTb1N8C/kZNPlDtWSb0h0sPs+H6FMCHb7Q8lqDA8jHvo7y19K03fijZAVrJmEaJlRU7fz6dC/N
 2ObTjg3w
 q3dWTlm8tNdHHpzN4JfZxR2NCISbzKoEuTaOu/JvB4dUc/B1kbmfz49hE4s9Kuq2Mo4Kz/Er9dhiSVtZb0Sjg8MZliwkpj0FBXrZBQTLMXeZk0b8xaaelukYiUGmr6LRdobMSOGb0sLXvUl4ndhOj4qkNXkIHn74vEmFs4xCHClkskpD3HFoUgF3vIHZIn4b7/OTG6HMZHZI/c9EmTXllny4fozajdITJ0OsPDxeEhWXRSe7K2+ClpBKaaOGrE+hnOaSnAJv5n8+PoM5uCR/Pjfy6sdSGC26txJ/KivHFL3tcwgzCG8SZ8frSGNNtzwXFEGeeGZcWVdyBtvP6gNp/vqjhyN/ef05KTNIa6ZDsZYgYafevfqC3ZY9Z5ta10P7aMsKQ3Kc3TjuLENE/zxHtru13y1IVxyuBsca7F6y7829KVX9GivnqBdoy0McmLKtT/BNNtmt4AR+RDemXo27Sy0S/xoBVQWH7L0IwxIpFteXDtts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from our Hypervisor Live Update call held on September 21.
These notes are intended to bring those who could not attend up to speed
and to keep the momentum going between meetings.

----->o-----
LPC 2026 Microconference & BoF Planning

* Topic Adjustment (tmpfs vs. PCIe): Because the PCIe Live Update series is
  converging on the mailing list and close to landing, David Matlack and
  Pasha agreed to repurpose David's LPC microconference slot to discuss
  tmpfs file preservation, which requires broader architectural alignment.
  David will still prepare PCIe roadmap slides for anyone interested.

* Versioning & Compatibility BoF: Resolving cross-subsystem versioning and
  backward compatibility remains the top priority for LPC. Since a 15–20
  minute microconference slot will not be sufficient to settle all details,
  Pratyush Yadav will schedule a follow-up Live Update BoF session after
  Logan's talk (targeting Day 3, as Day 2 is fully booked with the KVM and
  Live Update tracks).

* Single Combined Overflow Session: To avoid splitting attendees across
  multiple rooms and times, the group will hold a single Live Update BoF
  focused primarily on versioning and compatibility, using any remaining
  time as overflow for tmpfs file preservation discussions.

----->o-----
PCIe Persistence

* PCI v9 Status: Bjorn Helgaas finished reviewing v8, and David Matlack
  posted v9 addressing all feedback. All major design questions raised on
  v8 have been resolved.

* Remaining Reviews: Three patches in v9 still need Reviewed-by tags:
  - Patches 6 and 9 were simplified based on Bjorn's feedback, so prior
    Reviewed-by tags were dropped; previous reviewers are asked to take
    another look.
  - Patch 8 is a new patch added per Bjorn's feedback to save and restore
    PCIe ACS controls.

* Landing Timeline: Pasha will wait a few days for Bjorn's final review
  tags before applying v9 to liveupdate/next, aiming to land the series
  within the next 1–2 weeks (ideally next week prior to 7.3-rc6) for
  Linux 7.4.

----->o-----
VFIO Persistence

* Status & Device Reset Discussion: Vipin Sharma is currently on parental
  leave (attending LPC and returning in October). Samiullah Khawaja noted
  that during end-to-end testing with IOMMU Phase 2, the current VFIO
  series resets the device during shutdown/freeze, whereas the PCI core
  does not.

* End-to-End Preservation: David Matlack clarified that the current VFIO
  series provides the mechanics for preserving the device file descriptor
  but does not yet preserve enough internal VFIO driver state to skip the
  reset. Avoiding the device reset to demonstrate continuous end-to-end
  DMA across kexec aligns with Alex Williamson's feedback and will be
  addressed in the next revision when Vipin returns.

----->o-----
IOMMU Persistence & LUO Core

* IOMMU v5 Status: Samiullah Khawaja posted v5 of the IOMMU persistence
  series addressing review feedback and corner cases. Baolu Lu raised a
  concern regarding keeping ATS state synchronized between the old and new
  kernels; because addressing this requires additional PCI core changes and
  complex IOMMU handling, it has been deferred to a follow-up series to
  keep v5's scope manageable.

* Phase 2 (Device Retrieval): Samiullah pushed an updated Phase 2 branch to
  GitHub reworking device retrieval, keeping it on GitHub for testing
  before posting an upstream RFC.

* LUO Documentation: Samiullah submitted a separate patch updating the
  in-tree LUO documentation, which Mike Rapoport has merged into the
  liveupdate tree.

----->o-----
tmpfs File Preservation

* Retrieve-into-FD Proposal: David Matlack presented his RFC series for
  preserving tmpfs files across kexec. During preserve, the kernel accepts
  a tmpfs FD and preserves only its underlying file contents (folios,
  seals, etc., reusing the shmem/memfd mechanics) without filesystem
  metadata (mounts, permissions, UID/GID, or timestamps). After kexec,
  userspace recreates its tmpfs mounts and empty files with desired
  permissions, then passes the newly opened tmpfs FD to LUO to backfill
  the preserved contents into it.

* Dependencies & Post-Preserve Updates: David noted that keeping
  preservation within a tmpfs file allows dependent subsystems (such as
  IOMMUFD mappings backed by tmpfs) to be preserved naturally. Pratyush
  added that converting files via splice breaks the live-update contract
  for post-preserve memory modifications (and future support for growing
  or shrinking files after preserve), as userspace would have to manually
  resynchronize changes.

* Design Options for LPC Discussion: The group identified four approaches
  to evaluate at LPC:
  1. No tmpfs support: Require userspace to migrate to memfd directly.
  2. Retrieve into an existing FD (David's proposal): Minimal code and UAPI
     footprint; Samiullah noted that backfilling state into a userspace-
     opened FD could also help non-anonymous files with specific paths or
     permissions (e.g., VFIO cdevs). However, Pasha raised concerns about
     breaking LUO's resource/session ownership model and cross-mount
     accounting, and Pratyush questioned whether the new UAPI is
     sufficiently generic.
  3. Mount + Selective File Preservation (Pratyush's proposal): Preserve a
     tmpfs mount FD (metadata only) and selective regular files within it
     using LUO's internal dependency tracking and relative paths. This
     avoids new ioctls and keeps resource creation in the kernel, though
     David questioned whether kernel mount management is necessary when
     userspace already manages mounts pre- and post-kexec.
  4. Zero-copy splice between tmpfs and memfd: Uses existing UAPI without
     expanding LUO's scope, though limited to isolated files without
     kernel dependencies or post-preserve modifications.

----->o-----
KHO & Scratch Memory

* Mainline & Rename Status: Pratyush Yadav reported that KHO extended
  scratch memory has been merged into mainline for Linux 7.3. He will post
  the follow-up series renaming "scratch memory" to "boot memory" (bootmem)
  after fixing minor typos reported by Sashiko.

* KHO XArray: The basic XArray data structure is implemented; wiring it
  into memfd and testing will resume after LPC preparations.

* Re-evaluating Pre-Reserved Scratch Memory: Pratyush, Samiullah, and Tarun
  Sahu discussed whether pre-reserved CMA-backed scratch memory can be
  eliminated in favor of relying entirely on dynamic extended scratch
  memory (potentially with a tiny early-boot bootstrap region). Pre-reserved
  scratch memory has caused recurring issues across architectures (PowerPC,
  LoongArch), NUMA accounting, and CMA compaction regressions. Guaranteeing
  reliability against memory fragmentation remains an open challenge;
  Samiullah documented the initial ideas for further discussion at LPC.

----->o-----
PowerPC & LoongArch KHO Support

* PowerPC NUMA Accounting Fix & v1: Sourabh Jain reported productive
  feedback on the PowerPC KHO RFC series. While testing with CONFIG_NUMA,
  he discovered a bug where global scratch size calculation inadvertently
  includes per-node reservations when the node ID is -1.

* Next Steps: Pratyush and Pasha recommended landing PowerPC KHO support
  using the current scratch model rather than blocking on long-term scratch
  redesigns. Sourabh is preparing a separate fix for the global vs. per-NUMA
  accounting bug and will follow up with v1 of the PowerPC KHO series.
  Pratyush will review the latest PowerPC and LoongArch patches on the list.

----->o-----
Orphaned VMs

* 47-Patch RFC Series Posted: Pasha posted the Orphaned Virtual Machines
  RFC series to the mailing list:

  https://lore.kernel.org/all/20260920193650.3373435-1-pasha.tatashin@soleen.com

  (The first 40 patches are on the list; patches 41–47 will follow once the
  24-hour mail server recipient limit resets.)

* Modular Architecture & Workstreams: The RFC provides a complete end-to-end
  implementation with regression tests, structured into layered components
  that can be developed and reviewed as independent workstreams:
  1. KHO/LUO: In-kernel vCPU FD and VM FD preservation (building on
     guest_memfd preservation).
  2. Physical CPU Preservation (cpu_preserve): Preserves physical CPUs
     across kexec so they appear offline to the host (also usable
     standalone to speed up host reboot by skipping SMP bringup).
  3. On-Core Scheduler (oncore): Schedules contexts onto preserved CPUs.
  4. KVM & Kernel Caretaker: Lightweight execution context across Intel
     VMX, AMD SVM, and ARM64 handling ~12 essential VM exit types during
     host reboot, with potential application to syscall-free userspace
     processes (e.g., network accelerators).

* Live Bare-Metal LLM Demo: Pasha demonstrated a live kexec reboot on a
  13th-gen Intel server (20 CPUs, 32 GB RAM) running an Orphaned VM
  executing a Llama LLM text-generation workload:
  - The guest generated ~48–56 tokens/sec prior to update, streaming output
    to a pre-faulted guest physical memory buffer monitored by the host
    (with all guest memory and EPT page tables pre-faulted).
  - Suspending the VM onto 4 preserved physical CPUs (leaving 16 online
    host CPUs) instantaneously transitioned the guest to the caretaker at
    ~22 tokens/sec.
  - Across the host kexec reboot, the VM continued generating tokens
    without interruption (advancing from ~3,000 to ~4,000 tokens during
    reboot) and seamlessly resumed full 20-CPU execution in the new kernel.
  - Pasha also demonstrated scaling to a single P-core vs. E-core and
    inspecting caretaker VM exit and stall counters via debugfs.

----->o-----
Action Items & Next Steps

Pasha:
* Send the remaining 7 patches (41–47) of the Orphaned VMs RFC series.
* Apply PCI v9 to liveupdate/next once Bjorn's remaining tags arrive.
* Include caretaker debugfs VM exit counters in the LPC live demo.
* Share access to the meeting recordings folder with Sourabh Jain.

David M:
* Prepare LPC slides for the tmpfs file preservation discussion (plus
  reference slides for the PCIe roadmap).
* Follow up on reviews for patches 6, 8, and 9 in PCI v9.

Pratyush:
* Schedule the LPC Live Update BoF session (versioning/compatibility and
  tmpfs overflow) after Logan's talk.
* Post the KHO scratch-to-bootmem rename series.
* Review the PowerPC and LoongArch KHO series and prepare Orphaned VM
  profiling material for LPC.

Samiullah:
* Share the design doc on dynamic/no-pre-reserved scratch memory with
  Pasha and the group.
* Continue gathering reviews on IOMMU v5 and testing Phase 2 retrieval.

Sourabh:
* Post the fix for KHO global vs. per-NUMA scratch memory accounting.
* Submit v1 of the PowerPC KHO support series.

The Group:
* Review patches 6, 8, and 9 of David Matlack's PCI v9 series.
* Review the Orphaned VMs RFC series ahead of LPC 2026.

----->o-----

Please note that there will be NO meeting on October 5 due to the Linux
Plumbers Conference (LPC 2026). The next meeting will be on Monday,
October 19 at 8am PDT (UTC-7), everybody is welcome!

Join Here: https://meet.google.com/rjn-dmzu-hgq

Please let me know if you'd like to propose additional topics for
discussion, thank you!

Best regards,
Pasha

