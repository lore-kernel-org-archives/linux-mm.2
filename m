Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA6E8FF8850
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 03:07:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AFA66B0005; Fri, 24 Apr 2026 23:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2604D6B008A; Fri, 24 Apr 2026 23:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1767A6B008C; Fri, 24 Apr 2026 23:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09B0E6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:07:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 656C3120194
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 03:07:57 +0000 (UTC)
X-FDA: 84695593794.23.05B4023
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id A45F5A0006
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 03:07:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FaHu6SnJ;
	spf=pass (imf15.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777086475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yQTvhWSyeRzzkMlZ8tRqN85t2RdPb6JQ5sP+OFC2oos=;
	b=aU2VAdBEQAvKVzWTcO05+tFoMqKnQoZo43nb5Bty1xs4vY+s3qOjFzOIRaSsOIRjnnNgxM
	yoO+maqVujFpF7gQAbg75stiUt+ILUC3Cppm4EJ18hIbMra7NHKiF7duveSO7Kf1p0M+S6
	IaIKwZnoNjRVJeAUimMDeGq+0PN37r4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FaHu6SnJ;
	spf=pass (imf15.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777086475; a=rsa-sha256;
	cv=none;
	b=w6PuyPizoxrTuGwgBITxET/Wt5HfYEP7CjGeZWaIKYDWjSfrppT54XHc4qWH/uxs8OHTyC
	CqDBcFIbeW+CxfBVmXgRsCxICh+JwXefE31Yfe7p4zDo3N/Wt0xIL/ONfqEcl/KwhIWUcp
	EOxO0mfaW4IbEx2WIUJ9F9M4gDNORYI=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b46da8c48eso283385ad.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777086474; x=1777691274; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yQTvhWSyeRzzkMlZ8tRqN85t2RdPb6JQ5sP+OFC2oos=;
        b=FaHu6SnJopIUf7+A6p1QUPBjdzeyeiH0RxUdVZk6HhTN/+Sy6Q3ZQeB+cRqvSoCgPJ
         Y9Q8b4TwZAzjbdHm8UozAb2DFWr5BsttXSWHyAAg+rPtAlCuJScXX9XdmM6kXDj1TbGw
         G/ng1soFWJvZHeBMHsv+KNx8InGYe6mDL3N/K3xWX1SzBnXbk4VtEDSQ6BJ/vQLA9HdM
         FvhN5q5HlDm7Bw71IADZC78yLSliUvs9gDutiGVhU++PvgY9fyYwjneBUGZwHGJOm1aP
         3Y2Ti4xOgt0DdxJ1lx0AccMusmyI80ZdPywLQgjEoO/IiTR/GoiP2rdwGKAPAHdNqd1d
         /nNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777086474; x=1777691274;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yQTvhWSyeRzzkMlZ8tRqN85t2RdPb6JQ5sP+OFC2oos=;
        b=s3UyT5oeFOrvBf7hMqfyS9ldtGZcnmS7V/X//SGFekhO7idYQtrPv9W7AePmO97iDQ
         /M5gxuMxUr65rkb9kg/zrEfa718vX72rUL+jR86elC24dKmU8A/fxHmwn4GWNOaCMS+Z
         aPhuE4b/dOyLlUTtm0YwDW/fGqapr0k5rwAAuVuSKA1N1kMtGdACi1xo7FStR2p2Qwxu
         BThCCMkXYa1SooJkE3g3i9NtBZH0+dWh9LL9olkoNfc98qa2Dd4u5hFiAeKwpRqqYrrk
         aKZAryCGvQy6kW2Wk8RE0drlphTWKwsNxzpuw4a6C0ZMGiwrOxn/QMODpG1QqoMksPUH
         RNMQ==
X-Gm-Message-State: AOJu0YwwqZz/2nPrlvrAydYNjac3EDcCYR+CFk15gY7uxGVycRRgAeu8
	KZimIljY7ncKroxq/eL0oGVDEaZMTqeKVJPW3orvkCViy+Td87+rzxEFTySSawXm/g==
X-Gm-Gg: AeBDieuuAKL+kxydcVPGtUKGQyD2by26ksWpnI/PioQAz94AP5lLTRHiv+0f/Py5in3
	Nop9XcCmizYqRuUf7iGn4Hyons1sZIlY9TussJfyBIarGJn9lDSVC6wdT5IjdT3Jp0aJT6ytTkA
	JD9WaF+U8fE7di3vgTHi1kTcoIL85QIQmWiEpS7QDicYlYIl7RnCQdbrDC7+iaUj8pavZNInBWu
	+ag8vkAYxNy9ZdQuWkqUNC9Ndd7UulhIvBrxf6E1M9r6y6y4BERUbpUqTmj7mFbhOAri6xZTDbB
	BI/QOKLKbuNVkuRji3n/SQ7oDwmKH8OllzWqfZRpT69FPBjgCptfdJvkxOa6POQcjdpByD9Ocej
	onNZrJBn/FyNEG3EHNDFdyaGXOOdHbJmCFqkz0P6yd2VJn9CvHS2Exfk8Zv5zT3vpdRR7NoTi91
	LCjSe0Xx4lPbAQr89zBWY18MrbcOXFFel9L576AuaBsG1iDI/5htY1ppDshhW9syeznOIiDDwmZ
	cr61AlnuFKXyHdhHFlHrRib+lSQJ4g1v5lnjJFFu94tn7SGdr43+bzUG54W0mZeZdfWD+8hZlw=
X-Received: by 2002:a17:902:e552:b0:2ae:45cc:aeb6 with SMTP id d9443c01a7336-2b602f42603mr12894195ad.6.1777086473646;
        Fri, 24 Apr 2026 20:07:53 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:a18f:54fc:a476:f72a] ([2a00:79e0:2eb0:8:a18f:54fc:a476:f72a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3614186adddsm25961188a91.2.2026.04.24.20.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 20:07:52 -0700 (PDT)
Date: Fri, 24 Apr 2026 20:07:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Alexander Graf <graf@amazon.com>, 
    "Andersen, Tycho" <Tycho.Andersen@amd.com>, 
    Anthony Yznaga <anthony.yznaga@oracle.com>, 
    Baolu Lu <baolu.lu@linux.intel.com>, David Hildenbrand <david@kernel.org>, 
    David Matlack <dmatlack@google.com>, 
    "Heyne, Maximillian" <mheyne@amazon.de>, James Gowans <jgowans@amazon.com>, 
    Jason Gunthorpe <jgg@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
    Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
    Pasha Tatashin <tatashin@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
    Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
    Vishal Annapurve <vannapurve@google.com>, 
    "Woodhouse, David" <dwmw@amazon.co.uk>
cc: linux-mm@kvack.org, kexec@lists.infradead.org
Subject: [Hypervisor Live Update] Notes from April 20, 2026
Message-ID: <014fae14-28e1-ff32-c126-28bdffdff636@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: A45F5A0006
X-Rspamd-Server: rspam06
X-Stat-Signature: 6ifg9ym9smh5eafso8isbptk6hsdsd8f
X-HE-Tag: 1777086475-847714
X-HE-Meta: U2FsdGVkX18tcZ9mcz0lb2kVgjQVxyuXYhDcIrcel7LmXe4nmI/Zj446Pi39Gu/7BfS+q+fEe6pMR1qeGeAUq+zocaQ0kgHqrfqCgsiAHIJoVJuSKipHM1+RBuZE2xds/WH73IyyUqtkvsEApd1kHR4J22t7mIrJYe3yU5P8T/wsaTKeN1ZyhPqjuMIiqUKvACm2VHBeC1uzKZFmaN/IDGU1M5k1af/IuQMP33595smOJnwMOHPcd6tD4FbGcAZ5oYMoN+s4jzIuguzzsdRZNZEtXSJNGkMG7A2h6CJgl2hZqItSnUVpNlRG96SGujJqNtlOdJOVZUJLad5DfywoauCjpOtYJ7q7/z+Po+4WDkG/5pQTcNnKBR8PCTIwTWaNoKixa/outrpODCPhiZ1VUW5u6Mv3Pin5qXkzcHXmKzClfVgiTgB6QX1ZxaRqkWhAgNtt1asoGwoqbURnLuCUteWgU3tcHAGHL2IgWF+od9f0lMdmuqUpnLfrflz4wsRgc8oe5Lnsd29gYEyE8lXba5p41BV4RW8B28cQP3U63MmF1J1Ftd4OiCRrB0KdvETFCfbJv22h5feu8FpI3OSRvfHI62gw2DmDEOqXQzw8Ezq9QtAfrrNT9dUL/HNGodbMj8+9I6WE93Ypo/0dujpXG0ihNiYMFldRF4Kxd0zXAtdgy1+HFOJs4lP7Wtt9cBzzMa4HDSzu29ttzkvoWnRYHYPFwNFH8EKZIvgeSwDBHsxOLOLwMY1ctNDMjmASwRbIfb3O/3HuWarSROlkFNtEy73JHEZ095Jw9HGVryCUt+jwRKJ3qTOysPhqVSB90qmJM+UfVr/XcP7WaDlDfzeWCmKDvXldIJkiqluoH67ClnMq4UfZ4+QA4kKJSryuLzn2bHfmXqtqRiNaQwUWEPVxVVeRxxniAN3iCds9sGu3zDvIOU81/Vskb0S5sIw29Z0EccK+ilvHhV2hPuo3Wcb
 0S3qV5Vi
 c6xuNPtuxB6aFrtUkoPk0ME4K8VKH6Je2Y1qr206GO/Ug1kFPqLLF/xbOZYUhJ7DcyJVkZyH596QJIcdHPtXTvDOsfgfeqElS59f9cKZP2cBXp3Rjl1Y9YmW8KId6fF12ok7FpckgaIFOTeJkBCGhL+MMii/IiblSHhYYd9I42H2FKXvHdw1DnKHtoqZg4++BFbhV9+YnPaRvaXlqrqICsGFcCeysSGc/055m4Wxky8EitzMz7Y6ZfQgCfl/j0p7XTUweFkaBB50sB9cY3xKTMhzousk0NYNQBEc3GyW5DINVTv3bj2Yh7c3WeCECB+3JVniH8rUmTv4FMiQ2is1qAIwwxtfr+aiJu8u2Vb0OSlirGwTIK+5jvq2N+kbdv0Qj/R2BLYyqExzHgUN3xBnALfVLjoiHsOynv+HjYKmUmBe9Gpdimi9i/q5WH3KX19bv/A2WQqJDQA/BfPAa8nCY7/z64T7MpI6Rb62z6caDLNbAMTJ3Oo5zlcZi3ZrgliCVO93MPLpK15HDhY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, April 20.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Pasha updated on systemd integration for LUO.  He created a pull request 
for initial LUO support and that patch series is under review.  In 
addition, the session limit was removed.  Luca sent a patch series that 
allows finding the name for a session and logic to determine if this is a 
LUO session.  Those patches are also under review.

He also mentioned that Pratyush was working on boot time optimizations for 
KHO but were not in attendance at the meeting.  Deferred struct page 
initialization v8 was sent out last Friday and all major comments have 
been addressed so we are hopeful these patches will be staged soon.  For 
memblock improvements to automatically expand the scratch area, Pratyush 
is working on this and he'll likely send this series out soon.  This will 
add a new data structure to find holes of 1GB or better to create separate 
radix tree for boot time allocations.

----->o-----
David Matlack updated on VFIO and the roadmap going forward.  He said that 
the series will be split into two with him taking the PCI core changes and 
iterate on those separately while Vipin Sharma takes the VFIO patches and 
selftests.  While iterating on them independently, they will be tested 
together.  v4 of the PCI core changes are prepped and ready but he's still 
cleaning them up for posting this week.

Vipin updated on VFIO which will largely be based on the previous v3 
patches and he is targeting sending these out before the next meeting.

----->o-----
Samiullah updated on IOMMU persistence and said that it should be out by 
the end of this week for feedback.  There was discussion upstream to 
preserve the minimum that is required to free the domain.  He is planning 
on sharing a roadmap externally on the shared drive for discussion to keep 
the conversation going and to preview future thoughts.

----->o-----
Maximilian Heyne joined us and noted that he is continuing Pratyush's 
work.  Imagining a database or a process with a huge amount of cache or 
memory, all that memory is gone after updating to a new kernel.  He wished 
to discuss how to preserve that memory over reboot or kexec.  His idea is 
to take a process and dump its state to disk and then restore on the other 
side of the reboot.  The problem is this takes a very long time so perhaps 
it would possible to leverage KHO to preserve the data in memfds.  He is 
using splice to move pages from the process into the memfd and this seems 
very inefficient.  He would like a solution where he can turn the process 
address space into a memfd to do the preservation directly.

Pasha noted the limitation with CRIU was the snapshotting and restore that 
would make this difficult to do in place.  He also pointed out existing 
APIs for preserving memory through DAX.  He didn't think this would need 
to be an application level change but rather a CRIU snapshotting change.  
Pasha said the VM use case is different than CRIU because the guest memory 
is preserved but the data structures associated with it get recreated.

Jason suggested the pathway would be equivalent to converting an anonymous 
VMA into a memfd so that CRIU can just use the memfd right away and that 
would likely be better as an upstream discussion including core MM 
developers.  He thought that some amount of application enlightenment 
should be used for this, however, either through memfd or hugetlb.  Pasha 
said an alternative may be to preserve random files in tmpfs.

----->o-----
NOTE!!!  The next meeting will be canceled due to LSF/MM/BPF 2026.

Next meeting will be on Monday, May 18 at 8am PDT (UTC-7), everybody is
welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - systemd integration for LUO, patches from both Pasha and Luca
 - KHO optimizations for boot time performance including initialization
   of memblock list and deferred struct page initialization
 - HugeTLB preservation support including selftests and fallback
   allocation strategy
 - PCI core changes v4 and next round of VFIO patches including selftests
 - Vipin and David Matlack roadmap for PCI and VFIO changes to solicit
   upstream feedback
 - IOMMU persistence patch series status
 - Samiullah's roadmap for IOMMU persistence to share with stakeholders
 - Maximilian demo for persisting process memory across kexec
 - guest_memfd HugeTLB enlightenment: conversion support, HugeTLB support
   without restructuring, and HugeTLB support with restructuring
 - KHO support for Confidential VMs including page table preservation and
   pinning
 - later: versioning support for luod to negotiate
 - later: KHO enlightenment for ASI

Please let me know if you'd like to propose additional topics for
discussion, thank you!

