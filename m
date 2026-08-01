Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D908C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 12:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80DE56B0099; Sat,  1 Aug 2026 08:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7036B009B; Sat,  1 Aug 2026 08:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5246B009D; Sat,  1 Aug 2026 08:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD186B0099
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:32:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B2E541A02DD
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:32:21 +0000 (UTC)
X-FDA: 85052638482.12.78B1E73
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id EE627180007
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:32:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YlpDipHp;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785587540;
	b=5UU0hSxVucP166GFv+KglEwDDpPslpyBWJTvrjVaS59SYkgEr4fE8zPdtDL0xTHAfveyUj
	GG3Cm7V2RqPAMxXZwYgafDdxg7QirHq46HjowIRuE46cxPRwIYgajx8kQ5mb0WC+sZlgo/
	Zzq6VKjWOBd06StAHOxksmvGjFkqXS4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YlpDipHp;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785587540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GBMKwQxu07dAahElgzkICs5Y0p256zctbXyzmgOcwEM=;
	b=w+ygNMaj04Qh4LjOq6Qa4So1jwZz9ZONXlksIjS4AdRUPWHYXI+weItHFvurOxTzH1IfGd
	Fi/t1NBq6bdcq9u47EHFlTT2NPju5PnuHBH96y3YXi4/ovms0vZilizdXhw9mio7aAGtCP
	tJbucgUSeIFogksGC8Cti184c6SLZ6w=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-81ed2a06b9eso17514097b3.3
        for <linux-mm@kvack.org>; Sat, 01 Aug 2026 05:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1785587539; x=1786192339; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GBMKwQxu07dAahElgzkICs5Y0p256zctbXyzmgOcwEM=;
        b=YlpDipHpSXyAKGAZ27NojYOmSEz4PYmD20fYvk2wSYv2WaIB+0VxsZH1Yi6TN8kFeZ
         jmedEEC29guvCWCBLabmP8SKueeBktI2c8UCgjsp9c3AYqv4nMf4vrdhc+TZx7+9OpLh
         Uux8M57VpLzrSmAMC4ukzdMVQsiEsFL7HK1sE6RR14vr0PDc1Ceu2L4iWGENG2IX9b9Y
         dS7/FlsIguH0VD68Dxf1ZntBmoqHyUaxcwL/7EkFn/JifQsQb2bm/dYZWbRmalXH0CuY
         8W7tPPrbEFwyReYagrvMkBKuN5nEn4DvzHyL+kfo34fnI0LHnKj30ajbQkMi9l2hsycM
         h3kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785587539; x=1786192339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GBMKwQxu07dAahElgzkICs5Y0p256zctbXyzmgOcwEM=;
        b=RYU+yczC1Mm2V9X+PHv6vdCmBcmYP6RT6iD5yjEgaDq5lL80ta544zPtDNiD6tdyrh
         hBDntuhaJnshyi/CFYqVc6VBzgd30HvEtR8hH1VEMP9YDw1pqLmNTzbr9U2wnre8u8uk
         U94+eeDMh0/ogNol1UfcF2AqmGqaqbvI0YtKDS8vHz4W93QlqTX2JYviVI3n83pT65+6
         FbH8K1SDkfAhNA9yHUDXpsBL3+OLCj9XvpLll7KYkYXdtwQlmxPHsPfIJp4QzDznp7/0
         t7prwVVXcAe/+8rVVq2s7q2wXXdpv0wTrY5wA4NABvyGW5NXnMC7GfzGKgwzQQhHu2JK
         /DoQ==
X-Forwarded-Encrypted: i=1; AHgh+RrriSGjTKcqzI+NgoQpl/KG6rEdHStwHtCYLtmA3eWdKtdtVMALQOtn8wtkZ+rImUpyHB3m7QuJaw==@kvack.org
X-Gm-Message-State: AOJu0YyQHFlmX9RXsf3/LaKkXZD6Vs7kVFKrma0LVboWo4J073M7HDY/
	Re096VyFUcty+tF0TpMyTXBvIJ0dIRYVQDfL1BNZHOHkuTfhaEyZdJwciEr2StUXyWY=
X-Gm-Gg: AR+sD10OUxEWL3nnJb8PM/5g7vyG7SoOi83Du1CRHVil8fnZDYx5GLIP5le7+6R60zu
	rZuePJZFJMFSnzZNwvL2iQ8i3Xm+GZVUYh76VtjBkS063xuLFpOWmf66sSsV9q9hHf5DDVWCi/x
	WXlVtrRGilY/mPTZKoq075B+UPrODcEF7rHQkPGfVhZXaxZxNs48pg3cGMdOdX8ZqQYvMtk/1bM
	Kt+6HmdR2K5ZAOtjmFL6cL8W712ea7pNIfTu7yt+CqFlhd8tndlGcxeuvCXfFv6QWGGzDPBFsxP
	6t+JQmJoFkurlmBPB3gpbCqsotnMzkyDe+WS7S7vyyzRaljHHMgh1LqzknYxYo1e4BOR+Dm5a4D
	arel/mjMQS2qZZ4qDvgCuwwORurd5h/q/XMROgHQR5mizyrW84jYSjVd2Tunrl6ww+oMZ061wZi
	803+IwDt3K0+eWLdOjIAtySERDfNCjw8MoN/Ahgh/GaHaRPMbLsOSM1vln/zXR/CLh2wPGXCXs+
	8hjuxVKCv0sQsyUqcAWfSAb5slP558z33MRy31/GNUUBe6lSTWZBHQYNQqPrp+VUQJzwFoPhI0c
	jyc4wek=
X-Received: by 2002:a05:690c:6604:b0:812:be92:6ea6 with SMTP id 00721157ae682-81fd4b909d3mr37800897b3.28.1785587538894;
        Sat, 01 Aug 2026 05:32:18 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fccf9555dsm24556607b3.20.2026.08.01.05.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 05:32:18 -0700 (PDT)
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
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [Hypervisor Live Update] Notes from July 27, 2026
Date: Sat,  1 Aug 2026 08:32:07 -0400
Message-ID: <20260801123213.2259109-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m5u39wggkhid7f9qpd16toj5d3b5xsrt
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EE627180007
X-Rspam-User: 
X-HE-Tag: 1785587539-829828
X-HE-Meta: U2FsdGVkX191JITeZCi6m3OKt1AcLzpNb3PfpS3suAXn1wYHOkrlFJh6PDUwUiaWKsdRi5yDqsqOCsq892hTH0nFFczBsqxXDAJV5Z9ukw7kq1rKR0FLyJP2OP2R0A7DlcoysH2+7QZTVJu8t+BOFK9lnlkBeaxprJONob3ZEeY7WwX16E5cteuS/P+IUSA0y+dfbx3RiLwuqyYkSwH7SU6zZZyN6XCGmkfuf77GIKIImD46foK92vP4hM4PqQIxeSXcqeb0mLVoIpLGK4AeTxz3iaMaEi91tCCd1esE9zM30vQ1B+bxDukV4X853JEqqeGTMPNvOo9Vzttb1XrT06ut5EcKHoIx7hnYogQO4YyNNkdksoWwxhZ8kfS9Um8rAogXB3QZ9cfBaplsGYKTZjMuhYSKLc5cEhMLHBEJsiueml8q275+oij07WytbHWlbUQMzMZzDk8LDFlBKQc5wVmzkkdsf19F5+X7+XLX8ivHmwMHeZ/bo89KLXzHLblUlQrlCxY7HcTceNQqQOeAjpyyAWCwD7V0aS1pesoIZUWazj9t557RuWVWfcMnSVqGxyuwlP6bgjOvahPIwmvktEfbtUvSLwrOigjRFtr0TFXmfViUuOfUUgBTH/UisZgK3a+L2SsxANGXI1fE/CE/E9IZ97OmhrxbjIohd8I5/HY4XfR3TFbSIFkVfcoLXy/6x+z9/pzj6JgkPmnRT0KCKpyNhLgCvKqGkuUzLwei+I4egUnWlJVQvAgdYZuKVErBLk7bf7gp5v7cQFsv5NzF1hoIJe87F5IbjDOtu1znvlWGunFPINlaZA7AyZuPVqV/epZoa8EaX101Ct6ahgB8h+PBKkBUFmfGRf9vT1t7iSLZGIR7f+8pyd+nnPC3CGxAUZUoy/k1xoQjJFubQ27e4L2nhuENytSBRgyCvVYHWUEinI/wCd0FICXmC4Wcl9S+0HmV2sLLgSNWDeIDZAQ
 Ui+KMv3V
 yzuqEnXxwRxTKPh3dDyq1pYL/MPeIZObuRfRtZbj+Doya2EUWOBxQzWJttMSRbaGu2+JZP6cMw5OqowfP+jBP1N1+JtpgarMGAVqFCfSJQoOx4oFnyGi3FoUQgViekdgPUKK330YXiJirOlaj3awlZG4QeVnlzHM0ieD+QVx24QAxHOY1ZP9VGPLK4RKIF7c/4/dJkR4c3bkVY1XaFQP7gO6iW2uVsBoFH25B3/t2ht22F5slHl5a+JQjhFBXCCxeotp6BwbJJA5O/difypQ0Yc3eX/3zY5/SffMlkloAlEQaG09Mn2CkwiLn72qwFk9m+CgzPO1VqL8DyXPkCFQ3J0RvHgX3IOxPo4uAeyFVjJARcq94Q98tVUjY84NcRaDXj1cke4dhSSR3uzbbWLEoct6zvp59YcSvRKQQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from our Hypervisor Live Update call held on July 27.
These notes are intended to bring those who could not attend up to speed
and to keep the momentum going between meetings.

----->o-----
LPC 2026 Call for Proposals & Registration

* Deadline Extension: The Call for Proposals deadline for all LPC 2026
  microconferences in Prague has been extended to August 7th.

  https://lore.kernel.org/all/ahcc3Qyuy7Oy03Iq@plex

* KVM Track Load Balancing: Due to a strong number of proposals for the
  Live Update Microconference, the team discussed moving select topics
  to the KVM track to balance the schedule. Orphaned VM topics (proposed
  by Pasha and Pratyush) and potentially guest_memfd preservation will
  be submitted to both tracks. Pratyush will coordinate with organizers
  of both tracks to ensure talks are accepted in one track rather than
  duplicated.

----->o-----
PCIe Persistence

* PCI v8 Status: David Matlack is preparing the v8 PCI series, targeting
  submission by Tuesday/Wednesday before leaving for vacation.

* Versioning in Structure: Versioning is being moved out of the compatibility
  string (which will remain a constant string like "pci") and into the first
  field of the pci_ser structure. Because retrieve failures in the PCI core
  are fatal and require a kernel panic to prevent memory corruption in
  dependent subsystems (such as IOMMU), embedding the version in the struct
  allows the kernel to reliably distinguish between missing FLB data and an
  incompatible version.

* Reviews & Landing Strategy: Bjorn Helgaas provided review comments and
  Reviewed-by tags on several patches, including feedback on structuring
  and naming for the bus number preservation patch. David will reply to the
  v7 cover letter to propose merging the initial series through the Live
  Update tree due to dependencies in liveupdate/next.

----->o-----
VFIO Persistence

* VFIO v5/v6 Status: Vipin Sharma sent out VFIO v5 on July 14th and is
  working on v6 to address review comments, targeting submission in 2-3
  weeks.

* Lockdep Investigation: A lockdep warning reported during testing was
  investigated and determined to be unrelated to Live Update (involving CPU
  hotplug locks during boot group operations and ATS). Vipin will start a
  separate mailing list thread with a reproducer to discuss the lockdep
  issue independently so it does not block the VFIO series.

* Landing Strategy: Vipin requested guidance on the base tree for landing
  initial VFIO patches. Pasha will reply on the cover letter thread to
  initiate discussion with Alex Williamson and maintainers.

----->o-----
IOMMU Persistence

* IOMMU v4 Status: Samiullah Khawaja plans to post v4 this week. Changes
  include lifecycle edge-case fixes identified by Sashiko, refactoring to
  separate non-live-update functions, and adopting the constant compatibility
  string with private struct versioning (matching PCI v8).

* Recoverable Error Retry Logic: Samiullah noted that retry logic for
  recoverable errors is not required for Phase 1 and will be deferred until
  needed by subsequent patch series.

* Dependency Ordering Documentation: In response to Pratyush's question
  regarding file preservation ordering, Pasha and Samiullah reaffirmed that
  LUO does not enforce a hardcoded preservation sequence. Any ordering
  restrictions imposed by file handlers (e.g., preserving during preserve
  rather than freeze) are strictly for optimization or immutability reasons.
  Samiullah will explicitly document these guidelines in-tree. Future
  evolution may only relax ordering requirements, never make them stricter.

----->o-----
KHO & LUO

* KHO Scratch Extension v4: Pratyush Yadav posted v4 of the KHO scratch
  extension series on Friday. Feedback from Sashiko was primarily on
  pre-existing issues; Pratyush aims to land the series in the current
  merge window.

* LoongArch KHO Support: Pratyush followed up with the LoongArch developer
  regarding boot protocol preferences and maintainer feedback; awaiting
  further updates.

----->o-----
Guest Memory (guest_memfd) & HugeTLB

* guest_memfd v4 Status: Tarun Sahu is ready with v4 and plans to post it
  this week. The update integrates negative tests, including verifying
  allocation failures when guest_memfd is frozen during preservation and
  ensuring guest_memfd without required flags is not preserved.

* IOMMU Interaction & Freezing: The group discussed how IOMMU DMA pinning
  interacts with shared guest_memfd preservation. Unlike regular shmem/mmfd
  where sealing prevents hole-punching (fallocate), guest_memfd currently
  relies on freezing during preservation. The team agreed on a phased
  approach:
  1. Proceed with the current guest_memfd v4 series as-is (using freezing),
     with a cover letter note clarifying that IOMMU support for guest_memfd
     will be addressed in a later phase.
  2. Pratyush will explore removing the freezing requirement for mmfd and
     guest_memfd in favor of dynamic updates to serialization structures.
  3. Implement IOMMU support for guest_memfd once the freezing/updating
     model is finalized.

* HugeTLB: On hold pending landing of the extended scratch memory series
  and removal of freezing.

----->o-----
Orphaned VMs & Development Environment

* Prototype & Repository: Pasha presented an update and demo on Orphaned VMs
  (allowing VMs to survive host kexec/reboot without stopping vCPUs). He
  published an open-source development environment repository:

  https://github.com/soleen/orphanvm

* NanoVM & Simics: The repository includes a lightweight C-based VMM
  (nanovm) that demonstrates end-to-end live update across kexec. Pasha is
  running it under Simics, which provides full hardware emulation of Intel
  VTX virtualization instructions (unlike QEMU full emulation), booting the
  host VM in ~6 seconds and nested guest VM in ~5 seconds (real time). This
  provides a clean, bare-metal-like environment to study vCPU state and VM
  exits during reboot.

----->o-----
Action Items & Next Steps

Pasha:
* Reply on the VFIO cover letter thread regarding the landing tree strategy
  with maintainers.
* Coordinate with LPC KVM and Live Update microconference organizers regarding
  track placement for Orphaned VM and guest_memfd topics.

David M:
* Post PCI v8 series.
* Reply to the PCI v7 cover letter proposing merging the initial series
  through the Live Update tree.

Vipin:
* Start a separate mailing list thread with a reproducer for the lockdep
  issue independent of the VFIO live update series.
* Continue work on VFIO v6.

Samiullah:
* Post IOMMU v4 series.
* Document in-tree guidelines for file preservation ordering dependencies
  and optimization/immutability requirements.

Pratyush:
* Follow up with LoongArch maintainers regarding KHO boot protocol support.
* Submit LPC talk proposal to the KVM track and coordinate with organizers.
* Continue work on removing freezing requirements for shmem/guest_memfd.

Tarun:
* Post guest_memfd preservation v4 (including cover letter note regarding
  future IOMMU support).

----->o-----

Next meeting will be on Monday, August 10 at 8am PDT (UTC-7), everybody is
welcome!

Join Here: https://meet.google.com/rjn-dmzu-hgq

Please let me know if you'd like to propose additional topics for
discussion, thank you!

Best regards,
Pasha

