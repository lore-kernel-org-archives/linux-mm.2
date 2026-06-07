Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91FA8CD8C8E
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 16:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08CF6B0088; Sun,  7 Jun 2026 12:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9386B008A; Sun,  7 Jun 2026 12:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8226B008C; Sun,  7 Jun 2026 12:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BDE26B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 12:06:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DCBD1C1D49
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 16:06:06 +0000 (UTC)
X-FDA: 84853593132.03.A5F1014
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 89E1C8000B
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 16:06:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SfTSr+6m;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780848364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KygAnOo/dmpBJQ+i2VrBBc9LJ5ZQpG2OVVfBe430lG8=;
	b=7YrXtIRcgnJA+mbRq4vxF6lP8d0fmfg8RaG4SR/8Y6n5yity1dfQDYFQYx8EH1n4emBcIs
	fcvfEWE2hQVKIkHC3L2Y0ihRWfgxiCEJ5HAe0dhIv8isuTqs7c9yNaJP1mc1ugCBBQV+AU
	NMXQYTUIUa38FOVKcauDYv+Z9UDMmg4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SfTSr+6m;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780848364;
	b=tw6vP8vqMpRSvyQKlyogPz4B2DfqYWSBlQZACZZFahf4QTHZaIaS88w4Hzem0Ta54nDDcY
	xbXWkYne5Y6Ayy8noYPB2yVjvjU8Ik9kZbMvy+3Riqce1vC7d5URIB8xArfz6fjfcDk5t/
	roXPtZ4hzGkee0zzqisjVZ3uO53504s=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7e8833c99fcso39961237b3.3
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 09:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780848363; x=1781453163; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KygAnOo/dmpBJQ+i2VrBBc9LJ5ZQpG2OVVfBe430lG8=;
        b=SfTSr+6mCXPObgtindzIyOCx68KRA2sE+wDJtVSgzxH4/v6BU6aak8TEAMJx8sc0Wh
         1AQwJ2Hjxr436HDLVugGnPCFlHOzLI+XsyIHVwz3xp2+pvZL2KWZXcBzbtZmNQl+qt4Y
         E2hr6tvXJ1/MVrre2qKatm8YSzA+5FEwCfBcfgwq0WqmAviJ754TgXTgM90cbr9fPzam
         pBasoWs9cN9jgvcyK4m+6vtu41hpCeyhrqsq64LDcQil6u6XXtqzf31f8ijpw/kkVo/1
         GexGoJyHy10XQPDyUOw102RozWHQUeRyJfK5l1og9MLi1Hcj+bJZKuS6hDpxEb7VMtsv
         IsKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780848363; x=1781453163;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KygAnOo/dmpBJQ+i2VrBBc9LJ5ZQpG2OVVfBe430lG8=;
        b=nQAT+wdY5keYGAQLmgrjykf8HHvg0t19rxOlXQ7TdtreTsCZfj7llt7ieV/uZormtT
         cQfKDJEgqT/eEymvRj/TKA3cqHzLydza8EGIMxCVyRqh7cthvVH8atst2JmHGsAuyWvq
         VAr+b+Yv/9hPeL34GTkFCXZxdTs5dTfsVV1Q+Ef4qC6qXPwIXjZ9uGYee9SgMmb/qgu0
         Ja/5NZVVQQYVPP8DbCHOrPQG6Y6LvIHWb+IE0ssy5Dt9BqiN8Vm37V6SIPea0YX2eKto
         yyB8wQy/eCcCKulHdlR4biLSeC47bDpg00etkOCnCkVXFASZ1VWqrqsAOd7ksP4j4KfB
         ZvIg==
X-Gm-Message-State: AOJu0YycRVaatsDZjgqEEsFhUzTIjuyYG5VTgplmE4hAyTw91+gDZnvk
	CcTTfOkROOjjwamz3UDfLBb9cq0rwkIPD6dnq5lXftXXB8ZBMXy5HqanJ9Ar3PEJwfY=
X-Gm-Gg: Acq92OFDWwUbyyfkubEwTLJvDC6Z2XHxn4D+aRKJ4ojWTOWC5zXU/uRxW1829mPP7FJ
	W9uj1a0r6fKrJ7gwU+Wzpi3LarLLBhbiTDz7L5w7UDxq+Fko2XQSELGII7l639AX9kJhKwLkb47
	zUmZR7xwPpfXt2bkJCGxT6DtDiiGAWPoGSsCV2hCqfe3s2lkstnJjbJQMdD6YxVwBTpMpFPqM+c
	XWXHri3DYqUczjN7r5zt/Hg+h2bD9nh10CZymKApt/vRp8mipbyuoQF0uMrHBOpnimVnn1MGDnc
	yATQWgFuxaK4CJCk83kpzWgxfDvUxNufZ6mceW06Lobsf/Yo1l4GEdY5hFK81o9wTZOjsBsJv6l
	buKq/Jdn50hm8im3T7glV/I6jTRg1XlUR3J4D6PK945gCKTq3TA9MueZhwtbK/Dl7ee61FxI4OD
	PTlasd+bxEsM27n08LyS1fysIlal/Bmr/s4RTVvAbcfl1+Coc0aoXV+Ku1yhCEwa/uC+XqFuGnJ
	tW4qfxo8gWOsKhl4JhatmawfbAxLhfJGCj+MdT0fEnZkW6RqVFE5wA=
X-Received: by 2002:a05:690e:1908:b0:650:1cdb:5f57 with SMTP id 956f58d0204a3-66106e0097amr10641440d50.5.1780848363355;
        Sun, 07 Jun 2026 09:06:03 -0700 (PDT)
Received: from google.com (212.255.145.34.bc.googleusercontent.com. [34.145.255.212])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-660d5f3b494sm8243034d50.2.2026.06.07.09.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 09:06:02 -0700 (PDT)
Date: Sun, 7 Jun 2026 12:06:01 -0400
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
Subject: [Hypervisor Live Update] Notes from June 1, 2026
Message-ID: <aiWW6ZwwalqQmVcB@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 89E1C8000B
X-Stat-Signature: pkyf44eurrdmd74j9o4esbonxttam4mk
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780848364-678461
X-HE-Meta: U2FsdGVkX1+ylWVy4DxQwJnd1GIQjkEdPEwbsJTES8FnoJifdRkeyQh2wPRa6QDncO293uaBIEKsm9d8/G8BDh4HByGPmA13m9KjIXq+Y5O0MMN0tf53ScgX48YVWfIludkPpWLYSL+rgepTMFi0MFmciiGdteGiBWDg2TVjfbqk1QA6t1K2/uyRgzU81uw4ecOKTiZx+vKNsTNxlOJswnmHuXrFA9QL9/UcpdEx2na/Z97NfhzOYblZ0hfcsbEirDxEbOmyuvbotvZx2u/0dlTIDjStLD/djaShIWi8jkptqo1qk2IvI0M1iTQm05LxBz9biz8RJd3j0izhsJj7zKzjnrWA2qkSpPSf5BDAuEOD8q37dgVG5bdQaO/B8YJ6m8P2SFnAVS5+iJ5qHJhR2CmpKaB7FavBRDoK0Lwv6R/vvZT6vpvf4f32vucKHai9PTwKVEyXdDR28LgTr/jQ1RI8UPzBuJGRpciOSjIFmOHIqC5ZayB0hETzCWI+F+VKx9yyhSCKknXaHDZC9M6VKIghw6ICMjGjFdBETTbPgRlpr/ARCq873YctagHnhJcQtCtZDEe2uJ2j6BF7ctVvfA7g5RLEy89+7FxEbkbYy+epTpPzPm11J7x7Fhr8Ynk/6OQc07pr7q0Q29srhRYxZ8sxkNB0a9+Pj5COMMMX/eDlnyy4buOj500gwqAc04aHkeOFspiUxfV7v6Y8fgDY0qX7OwGa/xVSLsXLVjvs642xI0HtlksKcfjnm1eFto6RHcfBQuRuNyDU7d2j0ztZPLg/YgfUzf3iexiTtd0A5zrBzezCwtCXBnLE2mfLG95awoaZMOKMDo8qCMbOIm8t6t67+ExTCYlsXYeEJaMPTKiJtcGL6TnK9Ebd+yV8ouH9g9mQotvVUWAiHWFAqGl3/WzrWu5hy5e/nb+/VW1p357OOK3vvmhJkxCSnJF1KznsrYhVpdBVAycPICCDPDx
 CgydBajU
 ZG5C8sOkCyzHgrCbSkIDTq92zWsdvLCtzhz3cOUjp9HPjrAZGoVXZ391wMuwrvsNf6cGpha1lb7Cbus22tTVlLZj4MkIa1B3NmkKmEnEc1M8FatQ3wC/Cqk3ZAQUJqv5/smuucw5MK6cspKv0v3b/psGkhtEa72B/VzOIEL6EzqkSd9LtF+FAL3Rn0WBesuptbihi9kOhTdM3WgzHXLsHBp3DXRx/pkQGv2g+kN0og946Q14DGRaFIejSJnKCvpBlOVtD9B1zQebmNgWEyJGN6EB7ohTF8WQl+wZkfWTlM4ssxvESEVwVTztNz7+lnEkKa/D2YBIpEOYbnRnUMMd2M/5DkR7wY/lk8/xZXPnvDQ2GieiOnS9P1X+/2x07ZtsQz3KLyrxmrh4b0jYmWR0JRUVd135c1o2aJv91wSXajdQl/vMBEdcmQUGpFqMkunSQ5YQjz2HC6qorhSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the Hypervisor Live Update call that happened on 
Monday, June 1. Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not 
attend the call as well as keep the conversation going in between 
meetings.

----->o-----
LPC 2026 Call for Proposals

The Call for Proposals for the Live Update Microconference at LPC 2026 
is officially open. Please submit your topics and proposals before the 
deadline on July 24th.

https://lore.kernel.org/all/ahcc3Qyuy7Oy03Iq@plex

----->o-----
KHO Xarray Implementation & Core Data Structures

Pratyush is collaborating with Mike on a KHO fallback allocation 
strategy for memblock. Alongside this, Pratyush is designing a 
serialized, sparse "KHO Xarray" data structure to lift current mapping 
restrictions across all three memfd types (shared, hugeTLB, and 
guest_memfd). By allowing runtime page faults and allocation tracking 
post-preservation, this avoids flat vmalloc array scalability 
limitations.

Potential wider use cases for the KHO Xarray were discussed:
- MSHV sparse bitmap tracking.
- IOMMU page table tracking (Samiullah will evaluate domain/device tree 
  association fit).
- PCI/VFIO sparse tracking via Bus/Device/Function (BDF) key spaces.

Slab/Cache Preservation vs. Linked Blocks:
David Matlack noted that using an Xarray page per PCI device would be 
too expensive given their small struct sizes. Pratyush suggested 
preserving slab caches via dedicated kmem_cache flags to manage small, 
arbitrary allocations. As an immediate alternative, Pasha's ongoing LUO 
limits refactor series introduces a highly compact block-linked list 
structure optimized for runtime file/session tracking. David Matlack 
will review if this fits the PCI core tracking requirements.

----->o-----
LUO Limit Removal & PCI Core Status

LUO Refactor: Pasha is updating the LUO series to address Pratyush's 
comments (primarily renaming iterator functions) and plans to send out 
v2 shortly. Given that LUO is not yet in fleet production, the group 
agreed to fast-track this into the upcoming merge window to align with 
systemd's fdstore integration.

PCI Core v6: David Matlack sent out v6 incorporating two critical fixes 
spotted by Sachiko regarding get/put semantics and double-retrieval 
failures. Review tags from the live update team are needed to help 
secure Bjorn's Ack once he returns from vacation next week.

----->o-----
IOMMU Persistence & Process Memory

IOMMU v3: Samiullah is addressing recent review feedback on the IOMMU 
persistence series and intends to post v3 by the end of this week. The 
associated development roadmap document has received positive 
stakeholder attention.

CRIU & vm_splice: Maximilian's investigation into optimizing vm_splice 
for copy-less data preservation remains deferred but remains in the 
pipeline, with potential future collaboration with Google's tmpfs splice 
efforts.

----->o-----
guest_memfd Enlightenment & VMM Documentation

Tarun debriefed the community on his upstream presentation regarding the 
initial guest_memfd preservation patch series (currently covering fully 
shared mappings with page-sized folios).

Key design and architecture alignments include:
- VM File Association: guest_memfd requires an active 'struct kvm' 
  context to be retrieved. VMMs must preserve the parent VM file 
  alongside guest_memfd, using LUO tokens to re-link them on the 
  incoming kernel path. This sets the stage for future private 
  mapping/secure EPT table tracking.
- Relaxed Fault Logic: The group agreed to drop strict upfront pre-fault 
  checks. Instead, standard runtime page-fault semantics will apply. If 
  a guest page fault occurs post-preservation, it will bubble up via 
  standard KVM_RUN ioctl exits to the VMM, which can safely pause vCPUs 
  and retry the fault post-kexec.
- Centralized VMM Documentation: Pasha and David Matlack proposed 
  creating a centralized guide under live_update/vmm detailing the 
  overall live update flow, timing constraints, and subsystem 
  requirements to assist external QEMU and VMM developers.

----->o-----
Next meeting will be on Monday, June 15 at 8am PDT (UTC-7), everybody is
welcome: https://meet.google.com/rjn-dmzu-hgq

Note: I am going to be traveling on June 15th, David Matlack is going to
be hosting it.

Topics for the next meeting:
- Presentation of VFIO roadmap (Vipin and David Matlack)
- Status of KHO Xarray development and slab preservation feasibility
- Review of PCI core changes v7 and upstream merge coordination
- IOMMU persistence v3 review feedback
- Detailed review of guest_memfd v2 and VMM interaction documentation
- Review and coordination of LPC 2026 Microconference topic submissions
- later: KHO support for Confidential VMs including page table
  preservation and pinning
- later: versioning support for luod to negotiate
- later: KHO enlightenment for ASI
- later: update on PCI preservation series and next steps
- later: testing methodology to allow downstream consumers to qualify
  that live update works from one version to another
- later: reducing blackout window during live update, including deferred
  struct page initialization

Please let me know if you'd like to propose additional topics for
discussion, thank you!

