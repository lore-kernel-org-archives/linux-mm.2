Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35B5ACAC58E
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 01:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 253396B0008; Sat, 13 Sep 2025 21:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 204526B000C; Sat, 13 Sep 2025 21:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3546B000D; Sat, 13 Sep 2025 21:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA4F06B0008
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 21:56:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 815E95793F
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 01:56:21 +0000 (UTC)
X-FDA: 83886190962.11.2F32280
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 826991C0007
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 01:56:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zWHf84G1;
	spf=pass (imf18.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757814979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vjCs7FIKhGYTaI5MHKlkJ6fq8tqN7U3QyTgSWV87yJY=;
	b=JkDNDRxtc1uCYeSUhgbe05klPMyjSL5edxaclyACvBWeTzvJV/SY24B+oTDFRGjkM136hv
	L5qBsbRvHLZGks1IfZYqnBtsSRK2kXhso7M6fKkCC1DWrm00UpQGFDRTGeiwxk72Ey4kOh
	fFfL1Uom1NuHADjeJAlQIru0G6sisaA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757814979; a=rsa-sha256;
	cv=none;
	b=hrFco4oDXaXV8f5+CeJyvG0FntArRExp5HOd5686hMcQ8LPO/YcqjAWM7zO/TjpVZEpmKy
	BSWUuBbIqiNmsV6HMHdvzo79DwG8z7ElTejq0lDB1UEQG9zQ5wHWasuJBjp3ocxsEDcoGI
	JghOkXHU5viQGVkNzt7O5vlQ6DQoZlg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zWHf84G1;
	spf=pass (imf18.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2637b6e9149so60895ad.1
        for <linux-mm@kvack.org>; Sat, 13 Sep 2025 18:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757814978; x=1758419778; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vjCs7FIKhGYTaI5MHKlkJ6fq8tqN7U3QyTgSWV87yJY=;
        b=zWHf84G1+eRYHsxsPQrQ7gm7iagfaKvp6LUDw//3KgIv1J2P8laubv8WUnJoI2XVit
         FFS9Tx8aYv1l4IwPJ63l/C3iODHbdemenIz29vStVWZTBvLUfWBQzRvVxKePEoEFqGmR
         m9Qp2Gqh8FUuXd//Vo/1WeZt6Yi/4klTGHNLCotbalxgwfHQNlJIlgAVPAvYNhfP0er7
         Q5G2FG9Lo77msYp8xBWSLJd1QwxTyP7Vh4qYd1PqE9iel4Dho7yvFtq8o76cP9TMiffT
         VG6jXgFx8ddVNGBD4TgJinTqtmM+R1fSn/sczgK659Q8fkEjUtlUh0M4c/XyodRzlK9L
         HI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757814978; x=1758419778;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vjCs7FIKhGYTaI5MHKlkJ6fq8tqN7U3QyTgSWV87yJY=;
        b=uzox4Pkx7TniZ6890LNnlnVMTvfx1t2p2EjBNnJ/mPf4CjM1XrQMxzYrn1duGKsDg6
         WcR7n/eBKsx15JfYVfIy+H1XcVmmta+1bwZ0w9b9g7cDeyNVdSwWk6TyU8oJPKOIz4kB
         LR7Y46gnKpy0i76R6kLqI29/srGjODz2oY4PMGTHdj/FTfkX0uqaWSZMWNftpg4NXKGU
         TbcS3/s5RUw3nIZh5/ml4DuoqxnEsc63cWtSFrJEbLOiQ8uCEyJH0T2A5wWvkx0ud/pV
         RWfqP3lzColwkIGOzT7xh0eV/pu9LteB/kBN7Mxk6nrEzQEUlVEqfSkxRGUxJXOMyR4e
         PMhA==
X-Gm-Message-State: AOJu0Yyd+ev4C1jtgDD1AuU3Fbsr3uPT/oFyf6Tiq89tISyleKpBSQib
	yWHXpJutiGMTq732cpT9JcRVolP9A5+WvmcBBGicqb++ISbSmF6+VxD8ufoKS5SeMA==
X-Gm-Gg: ASbGncvZ4cZs5LmSekdaDZ2jJ67PTGkPtADMrJ45V1bTJhy85TAD8bOgC+Hd3Oshl5z
	YywNcgfLhI2/rGnmRi6XeQOtJIQZZYIDdI+l/rDU2+UdjkeWZSXQU7KJ3oWoOTceWnt/IjDmyF2
	1KTzmCujkm1vVzfbUGQBbyMjGQT0ha9hYstQ9g82nawdEkfljFPLX/h8aFWqSLALnx0odrebP6M
	jbTHIj9EX6WCWIIP33YxrvR/+aW7p6IUVzfYuAkh73yDpWlnAa7DkS8Y2sRFHAnz4I4F+Dw7GVq
	Hz2YZT98TXhcf7w8mrtjhxTtn9BF1jVu413gBXhvUR8ZLk/H8UstnQ0/igiesaqDXr2Iwz240Y0
	FJESyqvpF3TwdZcWzWZ1xpJGTREWDfQUl/GG4dLHxOj3tnHomLPr/6+kikZuipP2awiLPVtVT9h
	9c9fNye8mIf+VOgQjStC5gSpIV2fGid5JBbq4O9K35dFrTsUTAXIBCzqZRQ+gsB43MGtmkol/Vz
	iS4
X-Google-Smtp-Source: AGHT+IGDJa1lL70XMMd5Je6cvOH5zekLB1M06oJvDtXwFRJlN15res7fswi8As8eyCvf7x9Yz50GYw==
X-Received: by 2002:a17:902:ecd2:b0:264:f533:75d0 with SMTP id d9443c01a7336-264f5337a4amr159305ad.9.1757814977860;
        Sat, 13 Sep 2025 18:56:17 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:9637:d030:f547:d052] ([2a00:79e0:2eb0:8:9637:d030:f547:d052])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32e0c2863e6sm3512068a91.28.2025.09.13.18.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Sep 2025 18:56:16 -0700 (PDT)
Date: Sat, 13 Sep 2025 18:56:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Alexander Graf <graf@amazon.com>, 
    Anthony Yznaga <anthony.yznaga@oracle.com>, 
    Dave Hansen <dave.hansen@intel.com>, David Hildenbrand <david@redhat.com>, 
    David Matlack <dmatlack@google.com>, 
    Frank van der Linden <fvdl@google.com>, James Gowans <jgowans@amazon.com>, 
    Jason Gunthorpe <jgg@nvidia.com>, Junaid Shahid <junaids@google.com>, 
    Mike Rapoport <rppt@kernel.org>, 
    Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
    Pasha Tatashin <tatashin@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
    Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
    Vishal Annapurve <vannapurve@google.com>, 
    "Woodhouse, David" <dwmw@amazon.co.uk>
cc: linux-mm@kvack.org, kexec@lists.infradead.org
Subject: [Hypervisor Live Update] Notes from September 8, 2025
Message-ID: <e3935e6b-0475-e780-fad0-85933377aa38@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 6gs7biwugc8uqe4ec73kf1yim4mryci8
X-Rspamd-Queue-Id: 826991C0007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757814979-935646
X-HE-Meta: U2FsdGVkX185WLrmTwP8ycHlbJ6BTToiZzLl114tTA65RgwMGq7D8kfqfpf+LkmBkbnPYFnszK20qMid7aOr1p9wJehE8wOCs1elNbk3RVWyY+dZEXCp81B9qCY9iTXSz6ysyCNaL4rDHbwHp4U80en586xOg+rZrMsVZcl6K1nqmlbv8iFTJdBtDxBMdG5qvDsW4gR3oZqfV8hQ11iy7i5JY+ACOv7+Bv0HiWUC5gLWLl2h4m0bz+oopb+/HQT0PBdyId3So39xoi0aEzw8PggJmMiLV/W4aj86Hm/7zTE3Ej7QFMwZhJrd+9MVhRQO6cqGxMv20HfB4zaF0uUVvTmp7Q3NUVEsGqnKdgRBSRKm/8mNGH1wl8ErPHtpi264yJNbJoPB891ce8ABvXhynthxpDS8cj6XGQKIb12lr2aC/14awAyO6Exz0D6jbY6rurY9okmTpVIUhZDHNqj53+1AKGE6k97pMfbLMtXA2uKVZWaJ52DiVv8sRd3ZzaKbfrYxgI8q15Gcex0uuOIef7VxkGUC8YZSdNt5pcR2sVYTr4FJK6jcysmZZchT7PYnscz74ZU00HBJre+uaXguM5m9+EqADmzBT5bfI4TgibLznl/xjyjEuZ8aFDhKmbPRhlTBqnHGbvbm158WQ2R/pYFycRolUYe+ePOllpujZdA3AqKCQDjcfnuuXAk+ivd7aKN0baEmiSF/VAdTNvapVFzn+VCXA4bzBHbKTlv65vExy2DoFNGAVyxvMjHQL8cXCbQGSP9gLgi5E3AP+sNBNLInUW5lDgOEYZv1YFJqlQ7zflFd0NSfHeZz8aQMIdxxOPALt98DTO4IFLMsB7iZmKWiRBEDOoE3UKoCX4A5ypm8HUtc5CqmBu7Klms4vVu1PHaEkweA3wLOEZQaaMEN1eUQPZZYugkxqXZ2FZMbThYptBiuvhS4upKHWichSbUPpKWx81CcU9mJCTHhvxD
 5Wx2xQ2p
 yWIka+zlkpLGOJvDJNgAGGTuPPYkMdjjHK5Sb30ioYNasYp1G6gJWsl6cfbvKeY8JDAqdZB/30kngYBIOE4gp3kSlgh6Y1HuCBi9kvsHT6fgolUiQuZ4FtMPZfqNH/cdG/b7FHrOQgfUFRIK/NDKDtgFi/JHHwh82O2yhpFTJvsnKrp3EhoIRiYrcr6eV/Rh7ZRgqoMQmCJ/9gK34alZ5gLc7Hf33gcKU6dsfsz5RIgsSmxAb6dbFqDAcX6gOj03ZQXqj2B7cNokzBMtc9CpWguXJI716mGW+nZVG+M0V+e9DPMZalBDPEWNI50eIQqI97QAWhJcqDr5mmW/zcJYpXOc/pR0yofHOKLJWs+oUc7usdrihw6cd5572vJRZmJ3RLh3pqzOLmfWiybwR00nX1RINX+4eNsb0Tomnhoh1hcm1St1ncy26GifGUtiNK1ueua+ChVTUhW8UjX8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, September 8.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
I relayed updates on KHO, LUO, and memfd preservation:

 - Jason Miu shared the page table like implementation for stateless KHO
   to Pasha, Pratyush, and Mike; they'll send this out more widely after
   iterating on it

 - Work on LUO v4 continues with session functionality being a work in
   progress, luod will be able to create the session through fds and pass
   them to the clients and fds can only be preserved and unpreserved as
   sessions; this requires an update to the design doc

 - Pratyush shared an updated version of memfd preservation; we chatted
   about the 1GB limitation.  He will be incorporating changes for that
   into his next patch series.

Chris clarified that the work happening on the page table like 
implementation today are not real page tables that get loaded into the 
cr3, it's an abstraction different from PKRAM that used real page tables.

----->o-----
Chris Li brought up a topic from an internal discussion on whether 
stateless KHO would support folio split after the page has been preserved.  
The answer was no, if a folio needs to be split then it needs to be 
unpreserved and then split before preserving again at the lower order.  
This has some complications if something under the hood is doing collapse 
or split.  Chris clarified that this happens during the preservation phase 
of memory (live update prepare).

I suggested that things like khugepaged doing collapse could easily be 
enlightened to avoid this but split is more difficult.  David Matlack 
asked what actually happens when we try to split folios that has been 
preserved, i.e. what's the failure mode?  Chris suggested that this isn't 
handled at all and the new kernel will see the wrong order.  Jason 
Gunthorpe said this was user error if folios are being split after 
preservation; after a memfd, for example, has been serialized then you 
cannot do things like punching holes.

Chris said that the call should return an error when this happens and we'd 
want to avoid silent errors.  However, the only rules that exist today are 
that you'd need to unpreserve if splitting the folio before represerving.

----->o-----
Chris discussed KSerial and the kernel-to-kernel API interface, not a 
kernel-to-user interface, so it should be considered possible to update 
later.  Chris mentioned that he was working on incremental helper 
functions.  There was also discussion about posting patches before any LPC 
talks as a general best practice.

For PCI preservation, Chris said he send an updated patch series this 
week.

----->o-----
Andrey Ryabinin noted that he had prepared an update to KSTATE on top of 
LUO and suggested that KSerial may be too much.  He asked if there was 
interest in this being shared, and the group echoed that there was 
interest.  The patches will need a little more work later, but it works.  
Chris suggested there may be some good collaboration opportunities here.  
Andrey would also submit an LPC discussion for this.

----->o-----
David Matlack noted that Vipin Sharma had discussed VFIO support for live 
update at KVM Forum[1].  He suggested that we may want to have the same 
talk happen in this meeting series.  There are not patches available yet, 
but they will be available for LPC.  We planned on setting up about 25 
minutes in the next meeting for this topic.

----->o-----
Next meeting will be on Monday, September 22 at 8am PDT (UTC-7), everybody
is welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - update on latest status of LUO after v4 and next steps for merge into
   akpm's tree
 - any updates on luod based on internal and external feedback
 - update on memfd preservation and status of 1GB limitation before
   integration into akpm's tree
 - discussion on what happens when we split folios while preserved and if
   there are failure modes when this is attempted
 - update on the latest status of PCI preservation, registration, and
   initialization
 - any updates on VFIO with noiommu as a next step for preservation after
   Chris's v2
 - update on status of KSTATE and its integration with LUO
 - 25 min: VFIO support for live update from Vipin Sharma
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] https://www.youtube.com/watch?v=IYfR1jYeM1g&t=1583s 

