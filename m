Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2905ECD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 18:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58DD26B0099; Tue, 26 May 2026 14:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565776B009D; Tue, 26 May 2026 14:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 453DC6B009F; Tue, 26 May 2026 14:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB6E6B0099
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:37:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B75441C190D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 18:37:11 +0000 (UTC)
X-FDA: 84810428262.22.0774C4C
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0239A100003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 18:37:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YC2eRC3y;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779820630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=act60vUxIIaCqxwJhQbB9YMS0EUrx0ri9T2HmFauSng=;
	b=RvIS/zJryPtvkUKBOOaGbX/2gNhfl5nWmSIrz6c0UypEKxdaQjkpflYhgjlSOLY1WIjBzh
	hVtFsClE8PlHhfXhq1HKMfPz9UKemdoAkBRQ3t9EoRB626uBnArpdvSprvS0JYLOpWoJt1
	y3MOenXxb8xVdfPUd9MS6WIkgSKIwhA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YC2eRC3y;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779820630; a=rsa-sha256;
	cv=none;
	b=3DRaaWRNdEXyEhT26QGQZi1vRQ7T6uCvSXdCpVXpWIrKa7DCtPi0RMSjveGDZ0lJQHy5K/
	5vcFULdlhVhgIijayI6ddrShQlk/HeXZ9mwW0p1UXbFD1JKQP5VUmapT/X/iqbKc+f1HDW
	gbUwcxrbrqr597rJg9WimvXaWI7RSbY=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7ca947f9b00so102490737b3.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 11:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779820629; x=1780425429; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=act60vUxIIaCqxwJhQbB9YMS0EUrx0ri9T2HmFauSng=;
        b=YC2eRC3yh1YB+GdM4+kfveziJ8F/ANhcd1Zb0+CNpnWC5PJQhscWoBNxTsUtEIGnBa
         J3OG3kOFa3FiDhRH6HDjJ35m7nqVww5ox4f6mfeO1JzLKoZA0zkk92j/mWiYfh7YwtMk
         Vmj/yIqgeALiGRZdL/JWhC0Vpvj+UYLrz2XdQBIf8ht5YecXcbjYk8+pQLAWjwwwyQil
         PXWVk8BuV4JZ53AHBMNk9qcfIuy3hQGOYBIYxKjiCPDDxHr1FAAsR5n/GzMkaA53dMCO
         2qATh4Qra+kCYxtt3kydZQZa32P4AoBs4ZkzrdF5SsZZEdE1nmGeWwVi8YSUYLEary9u
         yIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779820629; x=1780425429;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=act60vUxIIaCqxwJhQbB9YMS0EUrx0ri9T2HmFauSng=;
        b=Jn5hD6ldDCh3aWXmMoRBV6eARX+A9S0tR+nDQvhKlNoArZfLScvntoYnAfW2tSHdVn
         /a+UELubpOfJ54j7tvFFi6Af4IeTX3D2lT5iFCZ2+vhZWcXW+ZapVGKd70iyZz/TjCP1
         PNm6j/GJXvWhA8QCkTdlR6AguZ/Q8HnZGpRTOdV4Iw9tWd8IIfmj3PYDooxFrYOWx/cV
         eIptmVywFwg4hxZ3vVpGPza0BXv/3bStH01CLns4DDdYQnbG35/BNGRXctYgFAec0uuD
         nSpt9IDlX/sypuJIAUcA1tryGDPDeLbu/ZvsxhJxpJoU0mQEaF8AO2LpgvGE+m56K47L
         37Fg==
X-Gm-Message-State: AOJu0YwF/hknaxfyfmPxDe6PpKbHix0OK1XWyTjyCBDBZRwqPiZsWp+b
	JOJeowsckytgucMY9k2xaU6vLflyWCKNsFdjIbgOsWhsu/8kwmlVgeFr4gkJJlqJS9M=
X-Gm-Gg: Acq92OExSe3f4RpzVRr9IVGXvCoo07qvgz8WELG+NpKugyZSFR3d+wmS3JyB/h+M+Yd
	X8xuiLVw9kgA4ff8jVrb4YhEB9mXnJ4A3zdKSPcVx09s1IQeIJ3Jo8tZa/lWE0BLmHYPbjE9wQE
	t58jgLxQen+zqp7/diYIAazh20pnNX1ibJJz0L4K/sPi+t+u/nx7C7fV1+8i0VF2wkTAC8wMR5S
	thMleO4uZcqsTdGnxdhZRiSjV2IhPHZmUpas1buXnHBqxnt1fyQETKu9YWDF2y6rK5UM4UhYG9y
	CwjAqPOeUqz4YodJD/he3OGc9t+4A4hJkZqXkk0N/zVED0S8/2jhaIvuwFeGLjv/BChR/wr/ner
	B1sZUf/4nsZCigC1V4lnnTdaEOaJrZyQNa5nUl++QTv3yLzpy7vh5YQLEhPIvcO0uxdhqk/C9Sm
	9AEWePtWOmlafbPwYGLmaqyMWwpJTnn3yjWoPY/ZuTZhTZNB0KsGgshl1ipjkSZhNBvvNBXMRVD
	SXQZi3FRQmXdgNGrLVzrusjSUGhemBt
X-Received: by 2002:a05:690c:4d05:b0:7cf:ab4d:a0d7 with SMTP id 00721157ae682-7d3341d5e82mr196847047b3.19.1779820628942;
        Tue, 26 May 2026 11:37:08 -0700 (PDT)
Received: from google.com (138.200.150.34.bc.googleusercontent.com. [34.150.200.138])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7d389e1291asm65377997b3.12.2026.05.26.11.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 11:37:08 -0700 (PDT)
Date: Tue, 26 May 2026 14:37:07 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Alexander Graf <graf@amazon.com>, 
	"Andersen, Tycho" <Tycho.Andersen@amd.com>, Anthony Yznaga <anthony.yznaga@oracle.com>, 
	Baolu Lu <baolu.lu@linux.intel.com>, David Hildenbrand <david@kernel.org>, 
	David Matlack <dmatlack@google.com>, "Heyne, Maximillian" <mheyne@amazon.de>, 
	James Gowans <jgowans@amazon.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, "Woodhouse, David" <dwmw@amazon.co.uk>, 
	Luca Boccassi <luca.boccassi@gmail.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: [Hypervisor Live Update] Notes from May 18, 2026
Message-ID: <ahXiYGo-IWI94IVP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: reeh7g8kuxu7peesjew7g3i98rtfti4g
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0239A100003
X-HE-Tag: 1779820629-328820
X-HE-Meta: U2FsdGVkX1+jqH5KjzkG9HH85mZBlQFbx9X3YC4JU53CR1u7QRka2yvwWEsePAVKOQsxwLfp+jOtV1Y2dkEz1D3as4naeb6nTisPIrlFnx+OjWBtog9Q6TAAFqtlK1dUKu53NDwhuXUckP4cNQyVkptNGZr+6qoiadVWSlwBiOk2hQm+kQDfjl+OLcKTs6PumGtbA07VLTUFLydPAzH4aqs1eaetz1F+ex3smAUvQfpqG4G4KvBgti5smq/yFE3B7yuiuXu5Cm8lnd0aBxGQideNlg5el+TPqbiA8nw0WtuEZL9KPdEY4ZKa4D71/GYQ9/ZFSh+PIHiYTV/Fa4/ZfXpZGWvEZvIirJ9XHMZdUwgnvNVLMRRASrODqVRZQApR0k24t2Uj6mSdqKbbON7y3OTProcIXyuasEA99nWjVEVEmrCx/fsLupM9kiuUvaRC1y3LK+ghdNi4JHlZ6mDSqFQqeP/H01bIr2K1esTSnfaIIsYT2uMl/J/XwbMgx+TvBKyv+E5YJ5EPFaLxJ5lE2j2C87I+jWNqgSDD76+xSxz6A4O8REgsUubs7rtDmbcL8Zh0p9b3EGNgf/xSY+TrEFD5M520Q/qYOerZk51Z30DKJKkRXQKscfLjdCoQd/8tgk4LFS2AmMFtg9rshu8x7D04DMMko5j0Im66rR+qI9jrxmOKZacAbaec6/B+N9gAN7nKSloaNEcakBWt4D1QyN5q9KnOl2UdPoTfgCrt7NNqv/9oeBzpmgvXIV/ObSR1xchlFvjtZMFb+ZfuO/uXlhi+r+XmJ60QRKUr5CURYpyQKA7qjkIJW+kj0zLz5ch67H6sV4g+z7KlihAUgFxm1qsL77qgND/1IeYVdK95l/rZ47cWyiXUY+v3OaqpK+Q/tNCplcdDq/j7M05CCKOG73ZOgDwc3tp/py7JL7bu+u+sgP2fjaRlDVw/sfnYAQMpjfneC7viSSVzlIoKGol
 fysiYlsO
 8YkbrMD8JkACFaNfHzVQT9uNTe20fCrnKq0fCCkiWhU3JRg6c7jZxt9C52ce88HO3i4dBTxGWm4ASQmJhouZ+WNB6gxAM0D+NOYtDE+yaddwphiSjycLkJ10RxClCMXT29P2KmMVmaeQSJ+NRwmaRHItko8ZWa6nOlDodSXMAkYV/YIPomBrn7DyymR56qvIH1CeGFtH5StTorsS1BRcJ44JkxyIbA9S2EZOCHVbF+HKGtG3DkkoYmtteqkfB9FR6FnQLmMR7UEbRVWH1Nl4IAhwiJ40Ild69jYFC0WDA5E1/gUrzPyPcDMPswdOt9+IDYpU0c4W2OdbPHE+cof7ZbhUnrz0DfyTj0HLOh1pN7ZDQN7bu1XciiwQ+tJLS5JFVH2QsQOcDvx6cEQY99MvfigGnCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that 
happened on Monday, May 18. Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not 
attend the call as well as keep the conversation going in between 
meetings.

----->o-----

Administrative Updates & LPC 2026

To kick off the meeting, it was announced that I will be taking
over the management of the Hypervisor Live Update meetings going
forward, with David Matlack serving as a backup for scheduling
conflicts. Thank you to David Rientjes for running these up to this
point!

Additionally, the Live Update micro-conference has been officially
accepted for LPC 2026. Attendees are highly encouraged to submit topics
and proposals as the micro-conference will be listed among the available
tracks.

----->o-----
Systemd LUO Integration

Systemd: Luca's patch has been successfully merged into systemd. This
allows for the use of the fdstore to pass file descriptors across a live
update, which is a major milestone for adoption.

----->o-----
MSHV + KHO

Pratyush and I discussed using the Radix Tree as a
sparse bitmap for MSHV. To improve code modularity, we agreed to explore
establishing a new lib directory to house common data structures (e.g.,
blocked linked lists, memory management structures) that can be easily
shared by the other KHO users.

----->o-----
KHO, Boot Time & HugeTLB Preservation

LSF/MM/BPF Debrief: Pratyush provided an update on the HugeTLB
preservation talk. The consensus is that VFS hooks must be made aware of
the freezing process. Generic fallocate and setattr functions will be
updated to return errors up the stack immediately, rather than requiring
individual filesystems to handle freezing logic.

Boot Time Performance: The struct page initialization patch is ready for
the upcoming merge window. Broader boot time optimizations (like
refactoring the buddy memory allocator) remain a future project.

HugeTLB Preservation: Progress is currently gated by the I/O freezing
work and the fallback allocation strategy (which helps the kernel
discover free memory ranges lacking preserved pages for HugeTLB
allocation). Pratyush has requested reviews to unblock this.

----->o-----
VFIO, PCI Core, & IOMMU Persistence

PCI Core: David Matlack sent v5 last week and is planning to send v6 this
week after incorporating recent feedback. He is currently awaiting
reviews from Bjorn on the refactored code.

IOMMU Persistence: Samiullah Khawaja noted that v2 of the series
received positive feedback from Intel. He is preparing v3 and has also
submitted related series for VFIO self-tests and DMA lock preservation.

IOMMU Development Roadmap:
Samiullah outlined the following milestones, noting that
architecture-specific streams can run in parallel once foundational hooks
land:

Milestone 1 (Foundations): Intel IOMMU state persistence.

Milestone 2 (Multi-Arch): ARM SMMU persistence; Intel 2nd stage
hitless domain replacement.

Milestone 3 (PASID): PASID support across core and driver components.

Milestone 4 (Virtualization): vIOMMU and nested IOMMU virtualization
(Intel VT-d, then ARM/AMD).

----->o-----
guest_memfd & Confidential VMs

guest_memfd: The team discussed the guest_memfd HugeTLB enlightenment
RFC, highlighting challenges with handling shared vs. private mappings
(since LU currently only supports fully shared guest memory). There is an
ongoing debate regarding flags and whether one-time creation flags need
dynamic conversions.

CVMs: We acknowledged that supporting Confidential VMs will act as a
massive stress test for KVM due to the high volume of 4K page table
preservations. This topic was tabled for a future meeting.

----->o-----
Process Memory Persistence (CRIU & Kexec)

Maximilian Heyne presented a PoC using CRIU to preserve process memory
across a kexec reboot without writing image files to disk, successfully
keeping 10GB of memory in a memfd.

----->o-----
Next meeting will be on Monday, June 1 at 8am PDT (UTC-7), everybody is
welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:
- Vipin and David Matlack roadmap for PCI and VFIO changes to solicit
  upstream feedback
- Status of I/O freezing implementations and HugeTLB fallback allocation
  patches
- PCI core changes v6 review and next steps
- IOMMU persistence v3 and roadmap progress
- Updates on vm_splice investigations for CRIU memory preservation
- later: KHO support for Confidential VMs including page table
  preservation and pinning
- later: versioning support for luo to negotiate
- later: KHO enlightenment for ASI
- later: testing methodology to allow downstream consumers to qualify
  that live update works from one version to another
- later: reducing blackout window during live update

