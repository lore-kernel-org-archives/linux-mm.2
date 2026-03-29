Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6694010D148A
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 01:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37B916B008C; Sat, 28 Mar 2026 21:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32CDC6B0095; Sat, 28 Mar 2026 21:03:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242106B0096; Sat, 28 Mar 2026 21:03:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 12F816B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 21:03:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A0DC258616
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 01:03:37 +0000 (UTC)
X-FDA: 84597302874.18.77C627F
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id C9B5E1C000F
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 01:03:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HBI6exYr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774746215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4NsleX9u5aPhbjAVr0Nezc/nBr+cao/tGbHhc5N7BqY=;
	b=GNdGhFqrLJljVmwexuzcq25thPhWIwt8LVrM10414IUqdmvz/Eb09Mu3qJO/YhN0ozPn4I
	EDak9l/3nR9Nkk1xtTAAhUvnVtRtMMhmt2z+yrVJs1hmdX9U1LCNu/pJrrT/6rLi7jc2Ea
	kuL6PDNCj9YwietNjLHMjYYHh5Ocwsw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774746215; a=rsa-sha256;
	cv=none;
	b=nSF1SmeU9CI6kjgiMAhputgrkJ3wC872lyztColPQgPfBAXNkKWLM7V2Q7kTVoubXazyAF
	PPt92MFA7sMtlnj1SIblJMz9AJsGQe1vZtiLf+FXOmCnfAeWVluLbfGjr2oLva9oomjZcM
	DRGFoNjSaEyXxAzTFdNnVCFWzyMbf1s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HBI6exYr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b052562254so83225ad.0
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774746214; x=1775351014; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4NsleX9u5aPhbjAVr0Nezc/nBr+cao/tGbHhc5N7BqY=;
        b=HBI6exYrX9ZoSEeSNSwmzo0VtmiiAWnrDYfYnfmclDt3gp8gi4yBFQI6/eyG0kaQtU
         i3d0znYXmYEbFJyWVbbRhr36ZHNukY21WDyP/TLXLgYNCVXI6DtAPkXBfXuX/5b3GwBV
         CAYmxpFKKpst3DSWba+cFG4bmTM1UlvlG2JelWhyoCtojjhPSWITNGr3ABNQOnyiXcsl
         s2chSBVIfXJ0ybieKtc90qRfPsCN0t1DE/AjfGgTAz3o9JdTO68Q57HItGwktKLBhzog
         KtMe4BDFdBNaTxKKJmdCfKazU4owgCSjDo8z/22nd7H9NRUxkUNdn5oobeBXcsCx6/2X
         BfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774746214; x=1775351014;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4NsleX9u5aPhbjAVr0Nezc/nBr+cao/tGbHhc5N7BqY=;
        b=hAZcYcFG142Ayfb0CmlsbRz6DzB6zT3R6VoQxfsWtGsQZqraOEAjoS+Tc/Je64Ujpv
         fVGrpvVr5PC7SUbeG/ymDBkN7X6nLU3TQV6ANTRAoFL7vWM8fEwrTpsEcQSG9xPG1hWe
         46JLvj6OdYRrMmviN50i4YSKhdlxNz3BtS0lMRFd1bg++mX4rvpq+abYC4ZH5FtcJYz0
         2piVjHT6/yjE2/T66AqmoC1NFFcoiiPqvw8EKNJ/sCthxFZtHxdQxpp2Cc1f9ue17K2I
         +FElnz/cMTQERLHyKPyif9k5mfzc6KWy1USMw0c7bK0uxx2O7oSmrSO0UNyBkQhbwM1C
         YW7g==
X-Gm-Message-State: AOJu0YxTlCHd2RO9DojJYVP7dK8bG0hENG3F8xemUmTwIgFba5xlAihM
	Rv0G8EOF3S5ufU/AjNUazIVFJP2mqIfgo66VmaiaU5a2ARMsWSuuz4h61OhwV5W2eQ==
X-Gm-Gg: ATEYQzw1L8cl/OKI/vpDqDSfA6/QdqVm6sIB0Uv7uKuijKgQ6GZcCFRJpgw3SAWm9Cz
	ZUT9RQMAoqwWGukALmbp/P+dwXq8ai/YrNhP8Iy1yilLRvH8Bgua4Wf46jyxSKBu4WpoJVjosMm
	RRpXeqw4fQckmKeH88Zqi6ThmnI+XxaK6Ij3wANQBC+tf71U/9dQ7MgssN0/jniLsfa3MRfOfJL
	PnSw1VxENu4Oz32qrZoT8ofMVYXk8XLMwNv8MzLH8saczJAC6CHhaS9Fhyc520ZTPh485u+WOZL
	ybK1IgBchsY8VZzzlerkNAi4JIjI1q12AelojIbeN3zP0hd4MveBtkMU6C+7CGR7tdkObRK36cW
	aXxxRYIBuPMXfwVgdJ/MjvySa56mvnjFZnQyKpa5tTy1PXzYkkwBs6JM0vHC4fDVKD79TRuMkeU
	hrC7ePsG23GmOODDeBcIvEbmS1Y5Uru1sNiqLF7xQssEb1quKLYwDpklZhN5YpHGk9zNmKLh6/I
	0LQ7MjYbC+lO+Zljcfh5Y3A17hMk+8nP70XEnBwZ0Nl3qsfLHt3ng==
X-Received: by 2002:a17:903:15cf:b0:2b0:b925:da98 with SMTP id d9443c01a7336-2b242ceb47cmr1976585ad.19.1774746213717;
        Sat, 28 Mar 2026 18:03:33 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:a947:3e4f:679c:4c03] ([2a00:79e0:2eb0:8:a947:3e4f:679c:4c03])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca843d8e5sm3682786b3a.5.2026.03.28.18.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 18:03:32 -0700 (PDT)
Date: Sat, 28 Mar 2026 18:03:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Alexander Graf <graf@amazon.com>, 
    "Andersen, Tycho" <Tycho.Andersen@amd.com>, 
    Anthony Yznaga <anthony.yznaga@oracle.com>, 
    Baolu Lu <baolu.lu@linux.intel.com>, David Hildenbrand <david@kernel.org>, 
    David Matlack <dmatlack@google.com>, James Gowans <jgowans@amazon.com>, 
    Jason Gunthorpe <jgg@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
    Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
    Pasha Tatashin <tatashin@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
    Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
    Vishal Annapurve <vannapurve@google.com>, 
    "Woodhouse, David" <dwmw@amazon.co.uk>
cc: linux-mm@kvack.org, kexec@lists.infradead.org
Subject: [Hypervisor Live Update] Notes from March 23, 2026
Message-ID: <d07decf3-bd88-0ebc-1aeb-f91545318d3f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: C9B5E1C000F
X-Stat-Signature: 4res39wpakmo6k8e7ghum9yfjh86x4ad
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774746215-719389
X-HE-Meta: U2FsdGVkX1+bdoT4i8ZuejI65A5CpqQrjIoeztvNuV/DT1sdFDqtYQ8S7yTj29i5fZiaTbBmv3mvRvHocvr50eZEDp6mlt8fENv6PAIbtnZKZZKKlLRw9hzArEkEs5y7t/LLEFsexIWSnTuQTMyt6id2uznziUjOr2FdxPki3xQ3HGj6IlzsEzxxCXZAqk+Jjw1Y2udQIbTMEKQeADCz6oTOBjL2z71Rwj6YmDfXx7cGGJyaMymhnK/oO3GZpwiAfitQDPkicSecVoC9UC3UpwyOmJSkDORSqgK2uevJOmW4cQxE1aakdUAVz1Dd9dzq8Vhex2Cc8DyAhQDFnRlmoCA5LW8Kpy/PLvHaybb0xNEID+yK65zWdC9ZDZe1Ign4vWluZEf2jwa8uF6ShVF5XFYAm4mtnFDEet3r5wGF/WlQj2bOmMtTM4GacYrhuWA6PDfQNYX7pEb0SoAOFT2eGctiBx9TwZqC1eLhg/LaD8TGT43POYmtwg81YZYpiiGpuTZIX6upTXsCGuR3gtOxONFbl3FyNhDIJu5JQQVZFRnCSx4JKhYUnXa/rGFXUoBOnIYjmLzoO0n8HMmwqjW1KJR61pqPYhzt3hRChHKiq3/tiuAxKVmV6HOrB8Jn2GvtVgX25gPhnWfx0dF+zva9PZWKHa6X2zE7yWcxFGu156oVu83SD7NL/mdzanW6rOFnTN6R2FEmdCu8UOA6IJ91pPWpueUAbsWxI1FA49K+hZACGOUyNi1H8Sup+1PPNEZ1V9VUSHk6FrNw9wm8GJnntyO2KA58eZM7u15ssOHk/uo+dmw2tOal8AKGL+Df/Gjy5Cl9HuvwvnRfpvrBAbSLhSh24izn5vTCYPscwNNSW9Ryd7uEE9ZOlJwt6hKi2p3qIUdu23ux+kGqP/9Xq29J+s5Gdq+XnATSaV1R6Xhp62+I5xxX1VqEfVyu1Rc9ud1z3GXiqjivIf4ePg7mYwn
 ucr+jjdQ
 y3zOWcIHcNXOlpTIOtGHXDSEx5wyRk7GL42tZPa7X31I9GOxgT8OHBCetzVy8TvcPSgQKHRdmB8cysYrLY7t5e37b3D5paLWy2Y5NFPJ75SVF+MkIoXTAHbQTNRnTG1YanN7uMFqzjvvSKo5vwDF5wwJL9H2GEKzXvuBwpaC8v4AunvdC5MzMdGPQvXClTjyhNbrvQkH/MwH5v0DvtDIH8MKRdXtA4Q09gwLWgUgaCdhN9K/2CXg0KHcLCMDz1AlHiVIn6SicZ1alSKX5Q+HKlHAoH7ukgQ0auSPEL2AG0VW5KDC7yHGy+Jbfn5nPa3nVWTeI5JhC8qYcIg6A9QmMg3qTPenFVj32HCm7KVl0lv+ClTh+WWk69vKbZUqI3IgyEx6MhHN2lv1IWNlcPGlX9SP12DrWu1W90o2AWJzCC6OQMCBHhqLX7OasjcVgogBc0pTwdLhdSpsP87hNTdgyU3EyTgxGDQjObSCR9x8nQevb2H/6C3dAuAt0dGE9mdhXNtsLNUpNm45MHUZRdtutioG3qZye6JLv0h9sB6HehEzlhOVTldn9vQdE+HwBKc+jg2IYbolD40wKme4x5reJPSxnPcCfG5ZaqOnJjJU4VQ7kUMlE3DtDIt6ygWSm6Jj1Ul7IwXLzljn+mphPt1aKsPoWLj6G7aWphTjw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, March 23.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Pasha updated on the status of luod and a good conversation with Luca who 
is interested in integration.  Luca had proposed to do it in phases with 
the first phase being support for systemd logging during shutdown when 
devices are unmounted.  Luod will require preserving the logs and passing 
them to the next kernel and next systemd.  He was also interested in the 
next LPC discussion on the topic.

Pasha also updated that there are new tabs added to the design doc[1], 
this will be expanded for systemd and its communication channel.  The plan 
is to have 100% integration into systemd.

Jork Loeser noted in his discussions that systemd was very adamant about 
supporting fd store and asked to what extent we need multiple sessions per 
service.  This would include the LUO client interface as well.  Pasha 
noted there were discussions on how many files per session we can save, 
for example, and added a limits tab to the design doc.  Right now, it's 
about 128 files and a thousand sessions.  In the future, the file and 
session count limits should be removed entirely.  Jork was asking about 
whether systemd should expose an interface to the clients where the yget 
explicitly tied and create multiple sessions, or whether the interface was 
just fd store.  Pasha said the plan was that systemd would expose the 
sessions interface so clients can create new sessions.

Pasha said next steps include getting the design ready and then the first 
implementation for systemd logging.  The latter would be implemented 
before the next LPC.

----->o-----
We chatted about deferred struct page initialization.  The patches are not 
yet ready to be merged so we would follow up next time.

Pasha noted that Pratyush and Jork had discussed scalability of memblock 
reservations.  Jork said a couple approaches were discussed one of which 
is to move the quadratic initialization or setup of the memblock list to 
be linear.  This would allow us to interate over the struct pages as well 
as the KHO tree to avoid restoring the memblock list.  There was also an 
idea to side-step the memblock entirely and to use the buddy allocator.

Pasha asked about the proposed changes to the radix tree: if we move the 
order then the bit in the bitmap at the leaf levels would not represent 
the order size but rather represent the page size.  So the memory overhead 
could be much larger.

Pasha suggested allowing the scratch areas to grow when needed by finding 
the biggest hole in the radix tree, this could help to solve some 
scalability problems.

----->o-----
David Matlack updated on VFIO v3 which is pretty much done and is going 
through final testing for posting this week.  v4 should include a roadmap 
for what comes next.  Starting at v4, the series may get split into two: 
PCI patches are growing so it may make sense to split PCI and VFIO 
patches.  Most of the code is behind config options that should help with 
merging as well as the new documentation that should also move this along.

----->o-----
Samiullah updated on IOMMU persistence: his series is getting reviews 
upstream.  He's preparing for the next verison of the series.  There was 
no update on the hitless replacement, this would be worked on next.  There 
was a comment that we should standardize on naming in the tree between LU 
shorthand and using liveupdate as a single word.

----->o-----
Ackerley updated on the UAPI for guest_memfd HugeTLB enligthenment, he is 
still working on the conversion support.  That work is pushing out into 
April.

----->o-----
Next meeting will be on Monday, April 6 at 8am PDT (UTC-7), everybody is
welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - luod design feedback and intersection with systemd; implementation and
   next steps
 - KHO optimizations for boot time performance including initialization of
   memblock list and deferred struct page initialization
 - HugeTLB preservation support including selftests
   + debrief discussion from Linux MM Alignment Session
 - VFIO v3 patch series posting to the list and roadmap for v4
 - phase 1 of IOMMU persistence patch series, then phase 2 status and
   updates
 - hitless replacement for iommu domains and patches from Intel
 - guest_memfd HugeTLB enlightenment: conversion support, HugeTLB support
   without restructuring, and HugeTLB support with restructuring
 - later: versioning support for luod to negotiate
 - later: ordering issues when disabling interrupts based on feedback from
   Nvidia
 - later: update on PCI preservation series and next steps
 - later: KHO enlightenment for ASI

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] https://tinyurl.com/luoddesign

