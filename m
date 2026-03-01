Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94279FD0049
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AA9E6B008C; Sat, 28 Feb 2026 20:44:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032DB6B0092; Sat, 28 Feb 2026 20:44:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E818D6B0093; Sat, 28 Feb 2026 20:44:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D60036B008C
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:44:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A909C1A61
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:44:24 +0000 (UTC)
X-FDA: 84495799248.28.CDBD7F5
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id BE2B61C0007
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:44:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SQspmzXB;
	spf=pass (imf18.hostedemail.com: domain of rientjes@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772329462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ep1r+TxTVXsjleXDRELngb1lJHdD0DP3WlzMub74vCE=;
	b=w7V/PMVIpurjWtVx3K1AiqBUq9y70sWVCotx1aZVeXvR8T6Ly+kx9E+DIX+5Yqawjpl55I
	FhYZIunvr91L7sLUb0LV1SlpkAIKh5UK6QfGSLL5C8Lqlo2gnHZisqC/fhE8CHnzwn7pIh
	d+MxEF3fRc5qkgM24pEkd53MHRiZC08=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SQspmzXB;
	spf=pass (imf18.hostedemail.com: domain of rientjes@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772329462; a=rsa-sha256;
	cv=none;
	b=PCGbmQsXUQZIHE4xNxOmHEQToPihEEMxGzMPQQzod09kbwYtCucYQCkLBMI54uomibUpo5
	86iOSXkIdfGWwRG3Psr7j91SbQBPJLRivQJSMMT+j3P23QSUVCs/IbT+WSFtwFXGyIbpbU
	7VPXiLYUljVxUWH5JJYQwVKsRWYkvOM=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ae3f822163so37855ad.0
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772329461; x=1772934261; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ep1r+TxTVXsjleXDRELngb1lJHdD0DP3WlzMub74vCE=;
        b=SQspmzXBcjie1/H6rftYEz5ZmpvJk03piVYVE0iPeKLjkGRVLshzDyzAed1sztSxvB
         txiwrEdrxXQNwH6QYXqD3/nsvBknUetqFb71VrfrcNq2qGoJ9ctprBefNmTv7aM6jJqZ
         QuKLs/ZUhsvFd0GaJjSeRKNzsPmcaRf/26dzNHeYjazZZrcSpcMkNtTjPJBIs2pNZMTB
         bHek3C0taARtXqLg8yfynekZRUa2foIRJnPAAHkXf8RShCR+HFj1O5gFKMUMqDeBLkNG
         fd1Hok+9a61ybm7t5xPjTyT+BmKXwBGNQIoubLqTo/dCUhW72xCpg2jg9cdbMGYG8mpy
         pnUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772329461; x=1772934261;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ep1r+TxTVXsjleXDRELngb1lJHdD0DP3WlzMub74vCE=;
        b=Y/jy33IkDhrKUwM/1vRMuQ3pVH/Q2r/FMFnkTRDqfUPOmHYJRZaV9FHJr+XruHCchR
         oSuU5v3WZmVVsUCAbikdlAIRQitKSTmYXSv/ebRQFOUpZ11FmGIHRg/iDIyYYc014Q1+
         2ZugiAdof0yt+CIrzP+3Ev3v2cFLMYjowZMQBWQZ3iRBO5HUg+fsRlnkrt24+PREFs4n
         7eWKw6+P7i0lUpbfyNufXG0Ey9MoWAPRZ1u4fgALP1PpkHVJ5W9dtWMwFuzHbbtiv8Bm
         4f7V0F3w07o7iXBpiYyDrR9vxeo3GdyH2qNnjx2T09Sp2wJuKBgmVwhBYca82euypVw5
         I1EA==
X-Gm-Message-State: AOJu0YwtoiY3tn/3Y8CLVFqXMqvGzQOH4ju8iF2kTjNESh3d7yqCyUTI
	AecncF2subcxd361LDs+yPokFDDdapsaauKyy1thFHB/FScZfHRShNTT6tS7NWRgqg==
X-Gm-Gg: ATEYQzyr7N7QM2LozjVHBIylgvLATfTep940/92XZhR26oE6WmOdtk8WDLknvSxiFl6
	rJmAdNZYzvITak7z3hfMRndcJrwYFjzvH1To91sdKTIfbHzP032Ffxgsh+olUWXN+ZHStR/PM9E
	gWquzJ7uzC/NtqX4SvdjiQnpb0Nw92aI4XFLmgZie17xJge1AZS8dqNUjdmScsyUNJlYUX33yvn
	R9WFEuANqwsf3TmcvfqQrY6q0HkklFQvUUvLoK334WX6DLcbr7iY8bVp0ByEWUBkuyTpo2welZ2
	5ZTwLkU6qN4AoBFimuw7mKPH1VzSnNEPQMqAHw5cuEXCi7qUdbaXS3+YIGNDd6MO/L3ZPuAs/oL
	UgqRCi+wNKt/E2GxcbAE/UcAbZ/2QzUauxqfrBpTBk2Mrr6Bxxhioc1rbJo4yWtRx3RSLMGAqr8
	+LunotTCfbFmP/sD+CrzVmd9fVgdqCj5YgM/zDh+pkCI0FJz6RtbmO/ISlPuwnq6HCc6jLlocGP
	UMIJeHgcSps7n8w2yuDrW4qFOktmDWr42Uz8EryyUPFFdm5HOjUPA==
X-Received: by 2002:a17:903:3903:b0:2aa:d604:62f3 with SMTP id d9443c01a7336-2ae397254c0mr1958145ad.10.1772329460775;
        Sat, 28 Feb 2026 17:44:20 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:963e:838d:a96b:8016] ([2a00:79e0:2eb0:8:963e:838d:a96b:8016])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8273a01a9dasm9104749b3a.49.2026.02.28.17.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Feb 2026 17:44:19 -0800 (PST)
Date: Sat, 28 Feb 2026 17:44:18 -0800 (PST)
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
Subject: [Hypervisor Live Update] Notes from February 23, 2026
Message-ID: <8dff046d-a819-ac8e-c1fa-8b5a35740cbb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: BE2B61C0007
X-Rspamd-Server: rspam08
X-Stat-Signature: nhkhjjtinim8xr53jbmdyeua6a7tray6
X-HE-Tag: 1772329462-741334
X-HE-Meta: U2FsdGVkX18LLOubkKSSuVRw5mKPPiJ3Xbx3IaOrTgWr8+syyidwg6AXwB8cYXEf7Y5g4bSBcXZR0UteciHSZz9LymiccOIfJbUEpUOnV+9OlOAzW0UltPPiCwtRiEqP6uBjt1DTrdd3BjEOLWElOR4IqakpOGnYLTtG4WY1P0QvBqlXk5ywdqLKnpiJI7FVGz4wHcOeQu0ZDEio3fa0Gyx95nIPiA9Qd9L7vV5pXZM2u62MN2JdKYYWwZwArkchp5YQqDlAulcrITsaFFPhGb3VVmQvgKXJBWoHgYVYisxejIcwHMCAG3y1YnkDqFcxTQNuWJ1vz1ohWteRJJpIHgCLgt02LAEJOEOCrY44Tanrb/R0PozEFIIVOFkey9ErhYp/5D/ATtmcwMOakOXH5ZonCwFzbV0vUPTaquTceZkAmojdVAhmamr4D9PqbUbuFbowGStNe18+5E7406QbUpJl6b6YBEqSFjIeLUV8XdEGolDVOsEMUeaDq3dxTPFErTyhHXI00g9V+hgO09Q2mm2Oyqn9AGqp6jRWeiYneRUS7uGe8/QOiSi+2yw2/kU604gn1pwffCBd6N+Y1W/44hMYJltGhUqKpxLmLRsmgVnt7QXX2yBBdDOGlfAY9uHDCPvoOIQHcghHa2DjhCy0Ro0lYjmqMRVqSRHMvTjGUDPcLDH8Ff3kGH8IoXoFVoVxDDq8Dt816OcsU0aqf1hPhncZV/RCwUhuYjoSmjuEcJpV6BM4f6FMLFX9x4nyuFJhSdaMKXWzkYwgcLr2GkrHZC5eow9qkCZM3gh1O4Y1Ws951Hi1jB15OI8hyfDCndaCSUEs7yg87rXbO+b44l1gWDTTXiG7sXulH1cZxcquBnKjj80Y/Hw8+F00WF7jDnwmhhBijfVviBknQFabF2JkAwfJkycy7y7/syrVlhyVJpb5QIzL1A+LuEpStYMAYaKb3VkWSAYuy0+lUsQt4xR
 XgG3/tkd
 4HUmNZe9KJFWo4sL7G/FDcJJiYJj9rJYZ6myWWoxOxtv6N4mVEzJNXhQB9BKU8ZceLAAZAZU4y5VYOlf6eS+luBiKgDYfm92jISxskrcyGGJPoRv7SiP6jjNnSGqv0vQsXs/WRyxoZITxOA5PNNcvoLx2GseNzCwF4gyAAuBsnHwKxI+NECCNTjKq6Uda0b/FRAz+vFkrQUUiYEcxhM9xneAFF2myFYQFYbqL3pMUVByRZYnrlfnexsXHT5m6LcBIv3jzjKZajB5N90v8QewiwYBIHUTNB5Fr/q8aVVMTRjXPW2IJKZ+twUZBpVXvWR7oBPkKGBZW0gwUQoP7e0kzwzFVCFsGn0+2tkTWhxPCaUGD153Qjj591DYPKDbWRzSHUktujKb1+dqA1uXRAW+mw15FR0H432bAS0XdvjwGK33750P8PU+PxxNxf9GkTj1suEqBpjH8qfNvjEwtfx46tRTItAQONfiXfH31gR4KJVOsp4l+7lhJ9qyflKximIDKyvOx0qEOJryHJbJlmVjwvYKCGj9DA5CZJlBYybu5ocJUmIU8ezrL9Jf7hMlYq48QxdMGUoIbbEaNuMzAKpqPPBxIhA/nxwobj6ghZZHgjHy/V2DfVf09tVm0/DyMjvO2DSJ7paO8iB6V/S7shBdtLbTDAvDTMOMVE93e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, February 23.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
We briefly mentioned the luod design doc[1] and asked people for review, 
Pratyush noted that he would be taking a look at it.

----->o-----
Jork Loeser noted that he was looking at HyperV partition survival.  They 
donate pages to HyperV which is a concept that doesn't exist in KVM.  
These pages are removed from Linux entirely and cannot be accessed.  He 
was playing with stateless KHO and extended some features but is not ready 
to send the patches out for review.  He was wondering if there was a 
possibility of landing changes in 7.1.

Pratyush noted that stateless KHO should go into the tree independently.  
Any consumers of the radix tree can be independent and build on top of 
those patches.  He noted that he would be happy to review the patches when 
they come out.

----->o-----
Pratyush noted that there were no updates for versioning support.  There 
is a clear plan forward for it but it hasn't been implemented yet.

He said he updated the HugeTLB preservation support with the requested 
changes from the mailing list but doesn't have selftests done yet.  In two 
weeks, he was hoping that these would be posted to the list.

----->o-----
David Matlack noted for interrupt ordering that discussions are still 
ongoing with NV on the topic.  Right now the simple approach is being used 
for disabling interrupts on the device and then reenabling them after live 
update.

For VFIO, there hasn't been a lot of feedback yet.  He was going to ask 
Bjorn and Alex to take a look.

----->o-----
Sami sent out phase 1 of the IOMMU preservation series and is looking 
forward to the next phase.  He was asking people for review upstream.  
Sami is using the VFIO patch series as a dependency.

----->o-----
Ackerley Tng went through guest_memfd HugeTLB support; the link to the 
slides are included in the cover letter for participants.  He briefly 
touched on an introduction to guest_memfd as a guest-first memory provider 
to KVM.  He then discussed how guest_memfd simply wraps existing sources 
of memory like pages from the buddy allocator or HugeTLB pages.  The 
folios are put into the filemap.

Every page is individually tracked to be either shared or private.  
Confidential guests can request a private page to be shared with the host 
and vice versa.  For shared-to-private conversion, the userspace VMM makes 
sure that devices stop using the memory requested by checking refcounts 
and then sends the SET_MEMORY_ATTRIBUTES ioctl to guest_memfd; that unmaps 
the range from the userspace page tables and records the page as private 
before returning to the guest.

Refcounting for a HugeTLB page is taken for the entire hugepage so we 
cannot identify which page within the hugepage the refcount was taken for.  
For all private-to-shared conversions this requires splitting hugepages 
into pages.  Split folios have to be merged back together but may also 
out-live the guest_memfd; for example if the fd is closed the memory may 
finally be unpinned.  This requires tracking outside of KVM such as the 
original size of the folio and which memcg was charged for it.  This is 
also required for memory error handling.

For KHO preservation, for guest_memfd pages (not HugeTLB pages) we need to 
preserve the filemap and associated folios, mempolicy, and memory 
attributes from the Maple Tree.  For HugeTLB pages we must preserve the 
restructuring metadata.  It was noted that there is no memory failure 
tracking today, it could be a future extension.

Pratyush asked if we can disallow any conversions after prepare.  Ackerley 
said if this period is very short than this should be fine.  Pratyush also 
asked if we should associate the guest_memfd with the host VM which, 
today, we rely on the VMM to do.

For timelines, Ackerley suggested that we would be able to merge 
conversion support with private/shared tracking in March and then HugeTLB 
support without restructuring in June.  He was hoping to have 
restructuring support later this year.

----->o-----
NOTE!!  Daylight Savings Time starts on Sunday, March 8 so the time of the 
meeting may have changed for some participants.

Next meeting will be on Monday, March 9 at 8am PDT (UTC-7), everybody is
welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - stateless KHO patch status in Andrew's tree
 - determine if luod would become part of systemd and discussions with
   Luca; implementation and next steps
 - versioning support for luod to negotiate
 - HugeTLB preservation support
 - ordering issues when disabling interrupts based on feedback from NV
 - VFIO patch series review from the list 
 - phase 1 of IOMMU persistence patch series, then phase 2 status and
   updates
 - hitless replacement for iommu domains
 - guest_memfd HugeTLB enlightenment: conversion support, HugeTLB support
   without restructuring, and HugeTLB support with restructuring
 - live update related topics to propose for LSF/MM/BPF 2026
 - KHO enlightenment for ASI
 - later: update on PCI preservation series and next steps
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update, including deferred
   struct page initialization

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] https://tinyurl.com/luoddesign

