Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AFABCFD314
	for <linux-mm@archiver.kernel.org>; Sun, 14 Dec 2025 04:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780A76B0005; Sat, 13 Dec 2025 23:15:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70A216B0007; Sat, 13 Dec 2025 23:15:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2286B0008; Sat, 13 Dec 2025 23:15:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 452F26B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 23:15:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A56A58B667
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 04:15:11 +0000 (UTC)
X-FDA: 84216761622.04.FC801BE
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id DA94012000C
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 04:15:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OFpDVJjB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765685710; a=rsa-sha256;
	cv=none;
	b=mBayLA/kP24rCe3+I+GGLGCHx2k969DcyIdib2rS0r1/PggqIlyZmN30YNFu9EWBeTu4fI
	U+Jk9qtR/I5mxfE8NagTmixOuJ3Hgw9kzRt3ly+jpMUbCwxMKMmW8hBZ48UcFSxYJdHRlS
	ig4DD6Fg64Vwy20d8vsO81BB4GTYg7E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OFpDVJjB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765685710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Sdsg4erWIutvgEa7dX1ZHucXpg/1kUTw5cVvZEYCiLk=;
	b=8iMeYCkUWaeMIB7Hzu8hU/fOT+1NYly5GmxORfYmymNruiQlwf8isZgM8iWWjwTl9swrS8
	zis/VDP0PEUa+upjX0HbiZlSpRV2KHW5NNgBqO6LsjwdmTAvJ/sS7wsO0iElV+/q3dy2KK
	FS5mLLmz5sGSkIsznfYILrXRiW863GU=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-29f02651fccso451725ad.0
        for <linux-mm@kvack.org>; Sat, 13 Dec 2025 20:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765685709; x=1766290509; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Sdsg4erWIutvgEa7dX1ZHucXpg/1kUTw5cVvZEYCiLk=;
        b=OFpDVJjBTIqcSU5wXBheR8QoNzxicp8xvlmmZoXIiQx4whoofgXn/e1NTYfzw8YzDc
         HpEENH0cAiaGibhBB2WuSnKCnvEzdeBEPKgDm0qfZsyJMpw5Bsx/5yubSozkcFFNUVxG
         l5IC8SwRlGSznFsrbCu2LhPS6sIS1awbZcDNxDUXcdWzbL7LNZ59bRSwYRUFwWTGAlEo
         it0fEUGmCQxQW8v9QDIDXRHIhATR5ZW1DXLJe7Emg6Td+npsHR87U1Kke17bcvJc65ol
         kMvKl1TAlvKzuI4mMiYF5dVGEinucQiWoM1KYEtrf1HjsWO9ZGCThWzNMjVJVW1kShlK
         Lt7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765685709; x=1766290509;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sdsg4erWIutvgEa7dX1ZHucXpg/1kUTw5cVvZEYCiLk=;
        b=m521edkJsu8L/YfXCdnw1Fk62f+EU+GEZuwzDSyRfJTaOIvbVPgjCOHDwcRXVysyw8
         dCWXcAJUm5hJofdM7akjy7+KOeR3fEoIM+kaPAltJnu0QDPSckYtv86G/ChWOUTHDKw8
         JeXobvCGQ9joutvs7URpwygKQt0CA9fq6wYWO3NXn7zp47mDh69ip+uOboffS/WjpXKr
         CFa6ludy3NHBwTkxsJLwPx/VuXge/Z2PGirspV81/QkYuxEGtyY3wrg50nNPdtvyfeKH
         XcEOwp5meiWCu/vXCNHNqMxHjWlKfrT1uevTXZwpQUiE+uyULnxJpo5JjRMqMw8UeJUM
         ld9g==
X-Gm-Message-State: AOJu0YwfCBZrC3+qIlRYZJGScqWJPwDBOgmtJREeCSvPsTaL50WOShVG
	242DLcBKqCU+G6Ln3ttGyxDd8tcZTKT0OC8FeByE8af/vEnI1D2uEOvREo4b+9IMAA==
X-Gm-Gg: AY/fxX6BCFeC5LM30b9AGHga2uoRtsq/Nn+kLieY3+8hV9hgIm2hzIGP1E75jPG/0pJ
	SDJ8s0oP0oNCOIfk91osJXl3vaarxpYsLT/tLI1eS3FwrZqiJpAFCoLRrQfm6oZIWGd5qWt7wRp
	k9nrb+Pu7n2RleJkgRgQpW0FERhXSzK0nNrEgSbQHAeZmh/AVxXgx0AdhaT2uec6E491Iuc876Z
	sgVwj+Y6vQ2u9axb4DmGKNM0qtvgtzASTn32ezxljmXm2KFaexhEPVoSEKGZ9S8mm5LZTiI249A
	CiDimrY29ru56Miaz7R8pa3ROefPr78lXCQhUaIBt8DW/LXqcsRwyxWVw1VwdQldLHXNfzwqepw
	3N6E033TP0qh3R2ys29ms+aDCCF9+D0ELR26Il5dUzN1mkhO0+3Xc3PFVU5+WXt/LEZmMNWZl4u
	vgMxZdAKcv92Gqi+GlsrIPYv5b/LjCWz60js38GC3BNtBT3rYSzKlsEVqPivtyswdIFe5cZsSGV
	pFhloqJlZlGmSBKXOepNTPg4SrsUGvBymz79bU=
X-Google-Smtp-Source: AGHT+IExXFmG4ZkryCzQAXH2+nkErBtP5RMjFwMlasAYbVEuysL//WH3R+aZs7pF+b/vG6hdceMudA==
X-Received: by 2002:a17:903:1b63:b0:298:45b1:6ef4 with SMTP id d9443c01a7336-2a09060d850mr2737425ad.12.1765685708353;
        Sat, 13 Dec 2025 20:15:08 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:54d9:374:d4d6:8842] ([2a00:79e0:2eb0:8:54d9:374:d4d6:8842])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea06ae3bsm96645555ad.93.2025.12.13.20.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Dec 2025 20:15:07 -0800 (PST)
Date: Sat, 13 Dec 2025 20:15:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Alexander Graf <graf@amazon.com>, 
    Anthony Yznaga <anthony.yznaga@oracle.com>, 
    David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, 
    James Gowans <jgowans@amazon.com>, Jason Gunthorpe <jgg@nvidia.com>, 
    Mike Rapoport <rppt@kernel.org>, 
    Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
    Pasha Tatashin <tatashin@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
    Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
    Vishal Annapurve <vannapurve@google.com>, 
    "Woodhouse, David" <dwmw@amazon.co.uk>
cc: linux-mm@kvack.org, kexec@lists.infradead.org
Subject: [Hypervisor Live Update] Notes from December 1, 2025
Message-ID: <02fa839b-2e4a-20f1-9eaa-03df5947976c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DA94012000C
X-Stat-Signature: k963efj6je41kfrwuonmshmap13zogcu
X-Rspam-User: 
X-HE-Tag: 1765685709-596137
X-HE-Meta: U2FsdGVkX19yxEUWdATLMw+g0YB7GPsnhbNoEwHvzdzphm0FYdFflG8XriuZdj3r98H7o6qYJmx1atBNUyB8/twPgAnPNuwTawcjDh8+GXrUX2JzyAt1z6SFLm69uyhTzjy7dXN9Jwtd6kudelG+/sZ8v+za8B3U7iMAEGH4yGAIy+rfldR+4+vIA/FmZTmZUl+xeVQ0PRDVLcxxsLpvxztdI10PZX7S8jOaq8eE0lTL4ASO8d6vcJ6LoPEBP2JkaeCEFaKtH5ODZRCAa1m8uy9hZUpH0nWWIp012Hj9Ln1SKHQCma8DXjwqrbRYafeq4Sy0KH3eVK8gEiyFR/k8P3koSnKAOysG/wTgiEsq/pjyeRUY+3VejhygbGziCLadTbAF4UZvr2cuUPWKsJn6PrOoZipbyqrt21QMQFBaNSEazXdCPfn4Zp48S3KbNjbezYamoh6Vcz+VJO/wuJ+Gizh5xl24iS0vd1791ahtqUVnmSQ/4BfMpHbbLlHUBNthfLGydOmzMP5SPGeqQ3NoaPDWbHSdeS0aXCC008EwwernehhW/XzLcXIpVH5l32S+jgz7BC6beF1GLtWKIw3c6ivQujqyJxM55NTdJWA+ileP2jH9jCgZuWdwuL28IFT0plBYaIn0UlxSrzyPNlzMzdb/rxXsXCuGztduB+CbxenGQ0J70UpF5teGJctsH+ZXKmLXQ4LBEWrUPMDxdtcVbE4WSRHASQ1oF+H8J2VNirmNdpkWAU89+AE7gVHgKUnKrNKgqvDUTMEpdcM+Jlwija2UO7sayS+6clVQ5ho11au/RGbUOp+YenAqzI0kX+pQCcbTbTdMclYMHq0WFpQd/EMYkROE2SUDpAIMdbthghJVZbvNTQ0+G7t09Lqtbuq5TMC6CCOEm+RtbuRutoUm2SZKTzJzq8mVhBxPXcogL7zQAOPiCs6h3Y5627TT1BaQE21zeSpJqe8xIEYsyyb
 o6vuBdkU
 rqp0DCqTalwS3XqfpNvdQIhQQz/vrmcRKQ1h+VbLibVYBoKEDzDqmuZxlOJaUhe4MFIGIFhfU4mWck2OLkX+k3Tahnz0f8zit07phSRdfXGPl6Y3wiq1lYSWkIJbALh3YiJixopcWX99IYhqk9+qdDNu3LpSn0VaQ2IIScFiVyVPH2XNjCYD/pjc/ESkqzLlndYDz9p47DhtZzjw3K3tGdY4r7SQW4sag6XZC0RBBybfSoOWlktyNIsLIYEljC/om6+VQ2awOfzM/We3VnIuVvnbhRP/AvT75OiFTnrer1CBgcnQsoGoRHKO2vcy+q/CzJcn6cUcylB86Mv2DAp8dxu3LtUm0B7tfEwcKIrTH7V08pfl/i3L1atEdGl/eJVlFU8GWNf69zjqeoVAR+xF2UeHXkjUnUnJYf8FV8G7XhvHMOysnuZXtFR6kdhmEVZ/vVEP6Ct4yKCWTHkA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, December 1.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Pasha updated on the state of stateless KHO :)  Jason Miu sent a recent 
update which received feedback internally and then will be sent again to 
the upstream mailing list.

LUO v8 has been merged into stable and is scheduled for merge into 6.19 
now that the merge widnow is open.  For LUO, there are a few patches still 
outstanding: end-to-end testing (there is one patch that allows for 
creating a VM to do automatic testing) that is postponed, a change to 
preserve file life cycle bound global objects (no user in original patch 
series) that is postponed, and a patch for an internal API to retrieve 
struct files and get tokens for dependencies (no user) that is also 
postponed.

Whichever user is merged first for preserving file life cycle bound global 
objects will upstream the overall support.

----->o-----
Jork asked if user mode tools intergrate LUO into systemd.  Pasha said 
that luod will be integrated with systemd; the design proposed the way it 
would be integrated.  luod would be holding the sessions through the 
reboot command so that the VMM can exit.  Jork asked where the designs 
were, Pasha pointed him to the cover letter for LUO.

Pasha noted that the source code for luod would be open source and added 
to our GitHub.

----->o-----
David Matlack updated on the status of his VFIO series[1] that was 
recently sent out; some feedback was being provided upstream that he will 
be iterating through.  This series is largely mechanical to add the 
plumbing to preserve the VFIO device file descriptor across live update.  
Actual PCI device preservation will be built on top of it.

Pasha discussed BDF for PCI device preservation and whether we should use 
a path instead, which shouldn't add much overhead.  He opined that we may 
need to preserve devices that are not PCI, like TPM.  Chris Li noted that 
the bus number is assigned from the ACPI table so you need to infer that 
the root is flat and that the first bus number is the slot, but that's 
ugly.

David said that for non-PCI devices that these would likely need their own 
solutions.  Pasha asked if the PCI device preservation would be extendable 
to non-PCI devices if possible; he acknowledged that BDF can't change but 
still wondered if there was a more common way to preserve.  David 
suggested that anything here could be added incrementally on top later.

For PCI assigned buses, Pasha suggested ignoring this parameter or disable 
live update if the parameter is set.  It opened up the general question of 
how we should handle conflicting parameters -- should this be handled by 
VFIO or by LUO?  Chris suggested bailing out when the buses we care about, 
i.e. those involved in the live update, get changed.  Pasha suggested we 
could allow the auto assignment on first boot and then ignore the 
parameter on live update.  David suggested that whenever a PCI device 
needs to be preserved (a callback into the PCI subsystem), that code can 
check if this option is enabled and, if so, fail.  The next kernel would 
still need to check and perhaps panic if it's set.  Pasha compared this to 
sanity checking the memmap for the new kernel which would be required for 
consistency.

----->o-----
Samiullah updated on the status of the IOMMU preservation series that was 
going to be sent before LPC which was building on top of the VFIO series 
that David sent out above.  There will be no autobind in this one and it 
is using internal tokens; the LUO get token API will be integrated later.  
This is currently planned as an RFC.

Pasha asked about the lock-unlock functionality and whether Sami thought 
that this was lagging -- Sami said that it was actually better now because 
there's better flexibility.  David said that the only locking for his 
series was synchronizing finish when the FLB is freed with anything that's 
using it.  Anything using it already takes the mutex.  If you try your own 
locking, then this ends up in a deadlock that is mentioned in the cover 
letter.  Sami did not encounter this issue.

----->o-----
Pratyush did not have updates for the HugeTLB + 1GB page preservation 
support but was hopeful there would be an update in the next week.

He also updated that end of this week or next week he was hoping to have 
an RFC to share with an early implementation for versioning support to 
discuss at LPC.

----->o-----
Jork discussed measuring KHO recently for internal use cases and found 
that traversing the preserved lists and inserting them into memblock took 
the majority of the blackout time.  He asked about the later agenda item 
for deferred struct page initialization.  Pasha said that was actually 
unrelated to the blackout window, it's rather an incompatibility with KHO.  
He acknowledged that KHO is very slow at inserting the memblocks, we need 
to address this scalability problem.  Pratyush had some ideas how to 
handle this, but none of them are easy.

----->o-----
There was an update from Ackerley on guest_memfd support for 1GB HugeTLB: 
he was working on qualifying an internal version and was hoping to get 
reviews on extending xarrays to support splitting to multiple levels[2] 
which was a prerequisite for the series.  This was on track to post by 
early next year.

----->o-----
The December 15 instance of the meeting is canceled due to LPC travel.

Next meeting will be on Monday, December 29 at 8am PST (UTC-8), everybody
is welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - update on the status of stateless KHO patches from Jason Miu
 - update on the the status of LUO v8 for Linux 6.19, any patches that are
   still pending after upstream merge
 - discussion on design and status of luod as well as its integration with
   systemd
 - update for the VFIO patch series to preserve the VFIO device file
   descriptor across live update
 - timelines for PCI device preservation on top of VFIO patch series
 - next steps for iommu persistence to build upon the VFIO patch series
   once that is merged
 - status update for HugeTLB + 1GB page preservation support that was sent
   out in preparation for LPC
 - continued discussion on versioning support for various components for
   luod to negotiate
 - later: update on status of guest_memfd support for 1GB HugeTLB pages
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update, including deferred
   struct page initialization

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1]
https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/
[2] 
https://lore.kernel.org/all/20251117224701.1279139-1-ackerleytng@google.com/

