Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74D93C624DB
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 02:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44F8A6B0096; Thu,  3 Sep 2026 22:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427066B0098; Thu,  3 Sep 2026 22:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317486B0099; Thu,  3 Sep 2026 22:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 041376B0096
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:47:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7DAC4806A1
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:47:32 +0000 (UTC)
X-FDA: 85174543944.16.E912FFA
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id BC7DA1A0006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:47:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WVdE+5dv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788490050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LxY6qhOONdJBthzGvWEGTMppcR7CBwrMwbeMuLpGO0o=;
	b=rc01Hl/iEMg+66F3MFlKtVsKGjqyf8LNBNJ2wQp1pR84Bz5169t3eFmqXf/bKTQVRfrdbt
	A7mTaEhBre4PYIT6a+T3Gj1864NdeTa2cBRWHTC5LGLCXs9QHmoAdPntzBIydF7mny1+2D
	/G/3hDH7AJ1UfvZPXVBs6eNIrBYdUqo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788490050;
	b=5S06PCTJyJ7w7t/ky+9ny0X1G8o/9bV5BMj8tR9IeUCiHOs3EFRmXIvvxXsyZBBa53Xygk
	BWWHyXilWWq9UxvCFwNmR4e3XxE63rMSI741KCDAfC9yR/6WL/9beRiWzAuyZRRTNmbJuy
	u9e3uFLew9QMYJjb9M88zliFbhtMoOg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WVdE+5dv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-66f7f62e915so483222d50.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 19:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1788490050; x=1789094850; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LxY6qhOONdJBthzGvWEGTMppcR7CBwrMwbeMuLpGO0o=;
        b=WVdE+5dvs8zQSfON5gEsbdGg03AesEKH3n/F72icqNdzCYpkzdHhBb6Gcud6GQ8k0X
         tTpXjI0wUkUGiE2TQ2+DsosmT10kNpUbxmtkbwxm08GbtjfeW/jlbMS2v0FAcvynrLMT
         JB/veE9XAn7tc2mpoBfQ9PE8664dFOnMHLHGBaezEJa89iThJN9xvA/iG4QQw4FG+S8Q
         AONHzKePfcSR6ZVmTCBrqsq+6WB5udlzHZksCilEAvtqSA/lrFulgn9JeBU1UJMYT+aZ
         5q1w0x5qLNOKVOlAH65kt2IN/cjkMtuIBK8JnJo2k/4SzIPS+TahYpJ+D/mzn0aMhhoR
         lTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788490050; x=1789094850;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LxY6qhOONdJBthzGvWEGTMppcR7CBwrMwbeMuLpGO0o=;
        b=k1Mt/UgxBX+G2tJb3DVYQZiUdUscwCwZeT4pT5zeS2NHUfWod+mjEeyVKf3uzuS+KN
         ZIko2RnEzU7DfCbGUlUOsjgcKtfKdN3pYpYQZwFSctmXs8aKzD1R/b+BkC9kIJC6932P
         UlgYBQkT19EJxL65EcALkmzslEcI2kWIh/inN61kNxIo5ZsJ3/wbJ/rIW/jSUoG/YySD
         6cHz16q57CZUUOuFFkameddPBZZYVgXs6AWaKVY+tMDel9UtftjP3mlIUgU+vtNqxbQy
         9fC3eWzu5FAmJlohbaQiymXgwvn+ZoEraWEqll5W7dCmxAFL8ux4L3Z11cpXDz5CabU4
         Bb/g==
X-Forwarded-Encrypted: i=1; AKwUvBxPPMoDuHqHWDKnbh1G/A9FpFl/r+38te7XZfAWxKjepQ+Bd/Uk3YOJbwqX6NcOvEh4X62QLnieKw==@kvack.org
X-Gm-Message-State: AFuF++mFrvqIjPaxkz2yAZHbYHsN4u81kk++N/RCSDKRF/06I1Yfp047
	HGBFfVLFH57AYS+VFkn4Bi2AT5nvC9FAAoqeQIE4F6b0Db26eYXLjZMuoKvPFtyXDbc=
X-Gm-Gg: AYBFou0GuqHDd2HxAFt43kCA3PIBVXwgbzIkvS9pYN/zufl6+DJJ45a8dgWiYTXLpgz
	aN2TBPw8ur8jiSGnO762D6DJ47FBPx4tcm8INy1wmIKysBGQv1073ALE1FmN9ywxromvWWSQOGB
	OwQ8b6cb9g4F3U2+y+WNvfiTaGMdZzCHQ+otN/IgfaELBKKfCq7YdeR7yN1vBipvvvQ/m68FJx5
	3yMYAmXrCVTvFxIm/OQjXWMOHZ810cdXyV196UB/vtOJW3QQDCQVA/xuX+yO5IcAb8b0SxCgXkB
	eCcOf/dlYx2uz6356vmyJmv8TY7d8D1RV67o9pu2nGH6M7dCHGgA4P4DQ/kZytm/QQsRLqa/Ul0
	YhmQVb4cORrPXceL/aq+9n+0QoRZ4dfD44irecxq/YzwkTACff7E/34y8PhOzHVb7l0QDlGXuA7
	yx9/S+cXiCNWowGscc1D+v4eDHvGi6V8Qgk3uHJK8cBR+0cqqTP1R1UETneeBEvEkyUUsnJCdcD
	NnNhN2eE5FB3XaRNHTjc7BdDUcFvung9p/WqAJ8rmpV41BCGi7Xyjk6Lp47cKlukWKKqQp3/yw2
	uj8Uyg==
X-Received: by 2002:a05:690e:1a1f:b0:66c:486c:aa1b with SMTP id 956f58d0204a3-66fb5aa022amr879870d50.38.1788490049588;
        Thu, 03 Sep 2026 19:47:29 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-87149315127sm9475207b3.10.2026.09.03.19.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 19:47:28 -0700 (PDT)
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
Subject: [Hypervisor Live Update] Notes from August 24, 2026
Date: Thu,  3 Sep 2026 22:47:07 -0400
Message-ID: <20260904024724.3815033-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC7DA1A0006
X-Stat-Signature: h78wy7h1b768uhhup3xzx6opc6nbmmfp
X-Rspam-User: 
X-HE-Tag: 1788490050-905794
X-HE-Meta: U2FsdGVkX1+rg5reJKkxX3w8OEONBOAajSlF9yBZ5JOOGbijEmkSJf3lGRHxlq4UXATps6ungxj8TSv5kI49YNQIBpTzb4dBsDQ8XnRc9V3pNvfeYPk8NFDywjxCmHkIY5Ns339q5ngwZt3VitE1vzcxtj+9JMNP+EURnemlh3304zkTnYbqj9sH++Ycq/kF/mweThwLWhGTVj4YlVwN0yoHW8Oy6T6jra+tKNPmOTG4am2h5za/2pJg7kI26DfOIZuaYxl2JhkoXfyXgIxhSJFs7SlnBzbFe6s4JR993jWLjDRY44w6cBmFH2+jJV3Je/j56ir3SAaQwVBzFCcl0VmU/wJqncGOVdWuHwEjIxacV5P9p0CZzMcCcA87bQezU+DkPFP15qTcJ8DJWuCBLiYcZKYTFqcSOtqeMnq0NY575S1UiHFRVt3Zg+osq+pg6Jr1j1BPdT34dPnVKxRLFgWi1iT7PWAH/jEK/rRshkeUk7+ITtn1qHgimJhfIMyp2VU+cnM9E4p0U9Q/UAEz6uZJX+aZ/GOYH3kozCoueOMmDtcDJwli3Kbtr6hwMeiduBExkQSgDWOibmJHwtJSXxnbaCnxq3X/VYze34E2hkMn9BeCLhto+MmWsmqROvJ+aF8HbvKN4u+hauszgXAxnvtghyP2C7SJo4LSqu7GShi+eC1WnVdmSOb5L3Q6VZlU9PDK9iD5NF17VNwiu8EcVzg90SmmZEseVo2KMjV/bXBZ4mMWcEjx59VjRvWzStqJKJ9Kj197FGv9lcO5o/tM5fYuN1VzeUPnMkmCULxaEnElatyu68mkiq8jHP8iJgrZDdJXD6txKXu9eR/J/TLc2HY76/i93yA8+yqgjqh8G2XeWhU8iWs10xlechqv6s4NX8XVJQjyuq0JyMsKR1R6DB8zu0zLjokBS6Y0dZldtUBZ60JMaLwdJWHS4iVfSlpvMSSESG0rr9DZ4ZlmEjf
 RPyCqAO0
 CYk9WIEegtqMHpVfJ8KpZihUVl2yumyNADrI7Pd06qbqIPpD4ekh6A+jC4AbQBtcUPLK0dkFFV4IKMN9DjvZLlYJ1CbIJ96WDbKP1YQfoosB5ZfBYSaHeH+L/En6gW6VglGAFTbVJCIytgsS6KVTitD303ZP0TUDlpMfavQfMe9f5KouCuDEZVE02v+WniA8CeUnskWAafjcj3tlTbg0es7O9kfOwQGPpX36M+ElXt+rHzskYhfnZ0XkaDH6HJ5fgx/dVEZpZV5vBvN4VNPD4e+77QmAW9zVj1d4rW5UYuhBxnN14PSsKq6ZIBo9S/Sno9nD0K09eXgbbBZUh55yQbrWuVStse99FOpBHkg14PzUL452urzBQrwGYUGqsdMQGiyQBsJ36dmW0hLlMwuN3Dszu3duEuf7ac+6gdYENW/9m4dwlN9yffs4gQpbaDDn7qrGO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from our Hypervisor Live Update call held on August 24.
These notes are intended to bring those who could not attend up to speed
and to keep the momentum going between meetings.

----->o-----
LPC 2026 Proposals & Microconference Planning

* Status & Notifications: Review decisions and reply notifications have
  been sent out to all authors who submitted proposals to the Live Update
  Microconference. Attendees are requested to confirm their attendance and
  notify Pasha of any registration or travel issues for Prague.

* Session Timing & Format: The schedule is being finalized; time slots are
  expected to be 15–20 minutes total (including Q&A) given the large number
  of accepted topics. Presenters are encouraged to keep slide decks brief
  (2–3 slides) to maximize interactive discussion on technical hurdles and
  unblocking upstream progress.

* Orphaned VMs in KVM Track: Orphaned VM proposals were accepted into the
  KVM microconference, which takes place immediately prior to the Live
  Update track. Attendees are encouraged to participate in both tracks for
  comprehensive live update coverage.

----->o-----
PCIe Persistence

* Landing Plan: The PCIe Live Update series will be merged into the Live
  Update tree (liveupdate/next) right after the Linux 7.3 merge window
  closes, targeting Linux 7.4. David Matlack collected additional Reviewed-by
  tags from Samiullah Khawaja and Pranjal Shrivastava.

* Upstream Review: David followed up with Bjorn Helgaas to confirm the
  landing plan and request his Acked-by. If no reply is received by the end
  of the week, David will reach out internally.

* Structure Versioning: Cross-subsystem data structure versioning will be
  addressed as an independent follow-up rather than holding up the current
  PCI series.

----->o-----
VFIO Persistence

* VFIO v6 Status: Vipin Sharma was delayed due to personal commitments
  (relocating) and plans to post the v6 series next week.

* Subsystem Landing Path: Following consultation with Alex Williamson, it
  was confirmed that VFIO changes will go through the VFIO tree, using
  immutable branches for dependencies that touch core Live Update or core
  PCI.

* End-to-End Demonstration Strategy: Alex noted that because live update is
  marked experimental, seeing a working end-to-end demonstration would help
  build confidence and expedite reviews.

* No-IOMMU PoC: The current VFIO series performs a reset during freeze and
  does not yet preserve virtual config space or PCI restore state. In
  addition, full VFIO device retrieval post-kexec requires IOMMUFD support.
  Because IOMMUFD recently gained an upstream "no-IOMMU" mode, Vipin will
  build a working end-to-end proof of concept demonstrating continuous DMA
  across kexec on a separate repository branch, while posting the v6 series
  upstream.

----->o-----
IOMMU Persistence & LUO

* IOMMU v5 Status: Samiullah Khawaja is preparing v5 to incorporate review
  feedback regarding device removal, rescan, and rediscovery handling.

* Device Retrieval RFC: The Phase 2 implementation for device retrieval via
  IOMMUFD is functional on GitHub and will be posted as an RFC series
  shortly to begin upstream review.

* LUO Core v3: Samiullah posted v3 of the incoming and outgoing session
  management series (get_incoming / get_outgoing), including updated
  in-tree documentation.

----->o-----
PowerPC KHO Support

* RFC Patch Series: Sourabh Jain posted an RFC series enabling KHO on the
  PowerPC architecture.

* Memory Reservation Ordering: On PowerPC, Kdump memory reservation happens
  very early in arch code, whereas scratch memory reservation occurs later
  from generic code (start_kernel -> mm init). On the PowerPC Hash MMU,
  the crash kernel must reside entirely in low memory (below 4GB), which
  exhausts low memory and causes subsequent scratch memory reservation to
  fail. Consequently, the current RFC disables crash dump support when KHO is
  enabled.

* Use Cases & Roadmap: Pasha noted that cloud hypervisor live update targets
  often do not configure Kdump or use firmware-assisted dump (FADump),
  making the initial series without concurrent Kdump sufficient as a baseline.
  Sourabh emphasized that enterprise environments will ultimately require
  both crash dumping (via high memory reservation on Radix MMU or FADump)
  and KHO to function together. Pasha will review the RFC patches.

----->o-----
Guest Memory (guest_memfd) & Compatibility Strategy

* Backward Compatibility Concerns: In upstream reviews of guest_memfd
  preservation, Sean Christopherson raised strong objections to merging KVM
  preservation without a clear backward compatibility plan (specifically for
  kernel rollbacks, where an older kernel must deserialize state preserved
  by a newer kernel). Sean cited Intel VMCS AR bytes handled via microcode
  as an example of maintaining architectural compatibility without breaking
  software contracts.

* Alignment & Roadmap: While Linux historically guarantees UAPI stability
  rather than in-kernel ABI stability, Sean is treating backward compatibility
  as a prerequisite for merging KVM changes. He also requested a clear
  roadmap for KVM state preservation (clarifying why VM file descriptors and
  VM type are preserved alongside guest_memfd) to ensure serialization
  structures are extensible upfront.

* Unified Versioning Proposal: Samiullah suggested using extensible structures
  with capability flags to decouple serialized formats from internal kernel
  layouts. David Matlack noted that Logan plans to post an upstream RFC thread
  proposing a unified versioning and backward compatibility model across
  subsystems (KVM, VFIO, PCI). David will invite Logan to present this model
  at our next biweekly meeting, and Sean will also be invited to align before
  LPC.

----->o-----
TDX Model Preservation

* Proof of Concept: Sagi Shahar demonstrated successful TDX model
  preservation across kexec: running a VM, executing a live update kexec,
  and subsequently launching and running a TD VM on the new kernel. Code
  cleanup is underway to share with the group.

----->o-----
Orphaned VMs & Development Environment

* Multi-Architecture: Pasha presented updated results
  from the Orphaned VM prototype
  (https://github.com/soleen/orphanvm), showing uninterrupted execution
  across kexec on ARM, Intel (Simics emulation), and AMD (QEMU emulation).

* Continuous Workload Results: A guest workload continuously writes to a
  2MB page while the host monitors write throughput across kexec:
  - ARM: ~3,715 loops/sec baseline -> ~5,000 loops/sec during kexec (throughput
    increases during reboot because host interrupts are quieted) -> ~4,700
    loops/sec after resuming under the new kernel.
  - Intel and AMD showed similar uninterrupted progress across reboot.

* Modular Architecture for LPC: Pasha will present an architectural breakdown
  at LPC to divide Orphaned VMs into reviewable upstream components (e.g.,
  separating physical core preservation from vCPU file descriptor
  preservation, an in-kernel caretaker thread, and suspending vCPUs when
  physical cores are not preserved).

* Emulated Devices: Addressing Tarun's analysis showing ~52 misconfiguration
  VM exits/sec from emulated devices during live update, Pasha clarified that
  emulated devices requiring host VMM MMIO handling are intentionally not
  supported in the initial Orphaned VM architecture; hardware offload (e.g.,
  smartNIC/accelerator) may be explored in the future.

* Repository Access: Pasha will send David Matlack an invitation to the
  private development repository.

----->o-----
Action Items & Next Steps

Pasha:
* Review Sourabh's PowerPC KHO RFC patches.
* Send David Matlack an invite to the orphanvm repository.
* Finalize the LPC Live Update microconference schedule and session timings.

David M:
* Follow up internally with Bjorn Helgaas on PCI v8 if no reply by end of week.
* Coordinate with Logan regarding the upstream versioning discussion thread
  and invite him to present at the next biweekly meeting.

Vipin:
* Build an end-to-end working demo of VFIO live update using IOMMUFD no-IOMMU
  mode on a separate branch.
* Submit VFIO v6 series upstream.

Samiullah:
* Post IOMMU v5 addressing device removal and rediscovery feedback.
* Submit Phase 2 device retrieval RFC series based on IOMMUFD.

Sourabh:
* Continue discussions on the PowerPC KHO RFC regarding memory ordering
  trade-offs and MMU constraints.

Logan:
* Post an upstream RFC/discussion thread on cross-subsystem versioning and
  backward compatibility.
* Present the proposed versioning model at the next biweekly meeting.

Tarun:
* Continue upstream alignment on guest_memfd and KVM preservation with
  Sean Christopherson.

Sagi:
* Clean up TDX model preservation code and share with the team.

The Group:
* Confirm LPC attendance and notify Pasha of any registration or travel
  issues.

----->o-----

Please note that there will be NO meeting on September 7 due to the US
Public Holiday (Labor Day). The next meeting will be on Monday,
September 21 at 8am PDT (UTC-7), everybody is welcome!

Join Here: https://meet.google.com/rjn-dmzu-hgq

Please let me know if you'd like to propose additional topics for
discussion, thank you!

Best regards,
Pasha

