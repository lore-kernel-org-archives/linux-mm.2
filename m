Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA66CCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 23:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7044D8E000A; Sat,  8 Nov 2025 18:48:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DBD38E0003; Sat,  8 Nov 2025 18:48:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6187D8E000A; Sat,  8 Nov 2025 18:48:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CFAC8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 18:48:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA1391A0840
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 23:48:37 +0000 (UTC)
X-FDA: 84089081874.21.4130E7A
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id 20289140004
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 23:48:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RNLE5PWP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762645716; a=rsa-sha256;
	cv=none;
	b=rTS86EiVwu1VtJ0x8QGtxKkY7Ae+WDiCJ3a8eDhPxGBwZvBbWBAW3Kk5j/PMKKwIQejxd3
	L5cWwt7YDtNIEA+oh/eazzvtgcMfc58PvjOhGUU+hICsWb4CB9OnmpbRW0vd8BxVIhbDO/
	VUiZ/6N0t6VIrzbiCty1vLFUYqWh7uw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RNLE5PWP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762645716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qwrxSi6UEHqswkqxklVcNAH4yAiA2ZEOPwBLU1p/RJ4=;
	b=tVRU8xDZhFD1EsoOBxtXM6EAsxwKHjroGsl6S1cKoAHF9gYJ4rFgNg1/tWyqJ+sQCsmhjV
	5/tNG8P9XbFERZWusqplpULJpvJ0HepaZQ59cDCHqNeNRsl3vsOQW4cIZH6dyRQH8dWkDL
	MZWeq1UQfmBKco7dmsTZbmhaL0W6MMA=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-295c64cb951so174005ad.0
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 15:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762645715; x=1763250515; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qwrxSi6UEHqswkqxklVcNAH4yAiA2ZEOPwBLU1p/RJ4=;
        b=RNLE5PWP2pStAeijUN5qyiPV44BfgvbAyPVdXh4/EwScTlDSixmaHcH539TboNxSlY
         4u6JFwOwdoOwAs1s2Ej5RdVkz28JAyXq3FKLmejAV+0m1SoL1tTHEPFyV6ePUWD2FvUh
         XQYCOcHPxfxM8oVl2osTJblR0yAPVzWMqKRLWVGkKDbBpaEMEEC8dLAwBHKiQfA/z7U4
         mLys4s7hTp9ZrbI7HTK82Dqw65yqPxuNH/H2YExA/IGVL2Vx6oO7VtB7+Plz3LJUJv9Y
         g3BMAPFMNuZAfwPDQVi0tQqKyY36bNVSqACJgT1pXbbTMIUMw4A3TFNlKJ0Kob3LNyqd
         fTdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762645715; x=1763250515;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qwrxSi6UEHqswkqxklVcNAH4yAiA2ZEOPwBLU1p/RJ4=;
        b=EHA/jwQ5VqPi10hLUXKyqi31djI+IFfs79jjRSHt0rfqP8l2B80mlIW+nTI20Pqjdw
         Cn21eX77vfYfys9HzHQTnirLtKWzZGLW/GiMDMhPmkt41vI6KMyxL7jCMDAOnToXF9Jt
         RJBQOJtMiPHfoUD16dYjIBaCHKkfe38bOWaQR0muX6ueYIY8Zz4+NJQ0/m/CHqsTYqrK
         DKHDMwB6PwtmyJDR0//WlrsKrMsSP5HDPG8bG6feQLyRyGouEKaLnrOh21eOgJx37T4V
         g8Ek3eD++IKk9a7dBWFGExGrj0aIq1pSYKZwR6HsJIpUmDS8NC+KwokVjqccWbpaIq/T
         bZxA==
X-Gm-Message-State: AOJu0YyNK3mGG1rl+FVuUNPNEM4eJuXy9JOOlPoxlGLggbUDxiIvpD1V
	mH00hHS0HEyrAn+xrM/9+b17buaHe28FZ4L2ljtfT3lIBFdRMVJW5MfRagWccYr3Cw==
X-Gm-Gg: ASbGnct6C9XGRTwb6hiORfpDO8aT5IhFKH7MPkBoUaOEcWio/i27SeqgTZtqu+FV9rr
	ya4JO2dGY371guzsyQpzBkuEdn0S3BYJ2blkwpQg8Ftj8TebiRYof5nyxduDRSejDNRinkqe8Sc
	s8vrRjEU4ex8dg7DuPVMVce4XwixNCGp4mIZp7o6CCXbHFJwYcVA4it7IN1bE+9g4gq4auUWXfc
	rl2Dc7J/risoGwLQZO7vx5VaAAwVlbYpG0Z8KJ8+mWCoH3NScFkm03P1aHKPaSJhsSKPBKVPcX4
	kyixl8KzotkUE80oUU0VoxXRS2HrnEK2E/vhx3wBdhblTBovX5GlSDRnMyIq1ksPjaFsW977Co6
	5HT1zJSIHDQgBO04sslUk7Ww/S8tx6qiMRF1UtwscOFum4tPnC93oUpyuhgu5co2+sKCjIXg4AI
	JZl/wJ+bTpZub2D4N16iq10uF50nWGW2CdgAp7QVlM0KG5nVQWfJDztOGFzEW5PPcJjqvkf5SPL
	FGopU5ueZmViUh7j8Jq/GR5YY91hDDdO8WDjJE=
X-Google-Smtp-Source: AGHT+IHnRXXlbxI6BuGqHQ+Qtc6VE3S+F4KHSKReZWqHs/e+LWVIZk8w0dmbYu68ZQcpwXrQfqtj7g==
X-Received: by 2002:a17:903:1a70:b0:294:e585:1f39 with SMTP id d9443c01a7336-297e569ea05mr2974675ad.14.1762645714529;
        Sat, 08 Nov 2025 15:48:34 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:1130:5154:e55c:701] ([2a00:79e0:2eb0:8:1130:5154:e55c:701])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651c6f20dsm98249625ad.65.2025.11.08.15.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 15:48:33 -0800 (PST)
Date: Sat, 8 Nov 2025 15:48:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Alexander Graf <graf@amazon.com>, 
    Anthony Yznaga <anthony.yznaga@oracle.com>, 
    David Hildenbrand <david@redhat.com>, David Matlack <dmatlack@google.com>, 
    Frank van der Linden <fvdl@google.com>, James Gowans <jgowans@amazon.com>, 
    Jason Gunthorpe <jgg@nvidia.com>, Junaid Shahid <junaids@google.com>, 
    Mike Rapoport <rppt@kernel.org>, 
    Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
    Pasha Tatashin <tatashin@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
    Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
    Vishal Annapurve <vannapurve@google.com>, 
    "Woodhouse, David" <dwmw@amazon.co.uk>
cc: linux-mm@kvack.org, kexec@lists.infradead.org
Subject: [Hypervisor Live Update] Notes from November 3, 2025
Message-ID: <7742456c-b248-04cc-0e1a-9da7d0546f1a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 20289140004
X-Stat-Signature: w87jo7c1jjnzxiho8c658eguybxdafro
X-HE-Tag: 1762645715-825993
X-HE-Meta: U2FsdGVkX1+jthCBdZHVOeCOTMgb5nwo2UQJrFGvmem6Nyq0bFDCD7y+jbVCEFjnT73rueUSZ4KFkP8DzE0U2wJGk1gNreTs4LnujvTygapHbW4zLUpL97zY5lvP4ofQc97DUEcoohvo0We0d1oJsRhol5pKHGBw/GB363C+p0CBbn38+4eg1S4dixf0vRs3Kj9H8UGKtmjaG1G5jgKwKbQnSiTByiofEc85gQLjW6z4PmO8/5jz7LfIBy6twHURlNql2CkUObdbwMAWCd6hPMPsZmP2w5vrVcHz4Tczsy0n5mnQE4j5SiMd26y0gRgCoKuy3mKYFzFQasI/zruJnHHe7IiDy9/BMXGelypeMONuUdyKu9OO2Gt9I7DDgOhVeikrfqJxLKUrHIQ5lW1rKrFNQmrUj439Nawa/BJ4S/fkRdBGkEdFNcwLFR7RRJi8AyzA4CDdsWH5wT4UijRSnnEteSHVwlpdWvJUbRZZGHNQlUEpCguHcNxqhgFL1iftLXWXmEh/mDiqtOOWDaaeciI9n+rgokEZ3zpXuxn46uW6BFE7JNaIx0Ktwz9X2kid/qv+o9ZR/Bpe5PtP5roTIpGUwgZkWDdWA5iA/ZszPoKruJvP46QzQ5oSnRK+wZDLbROi10fFWBlQ1erh8uYT3H0IjgKfgG95V+RTwCaHq/IPnCchPB3lmyP1XK8GEBvBBLy+STypifKslODVdvUd+BYOsiZC7OXPk6U2ip9B9c8sQypq6agDU6HwO/yGX6+mwypDtFrN++RTD1dgmw+jA43SZHNIR93WG+KQEqrVtyg2kVwObfn3iFOWikOB5ZL2Ypb9VTQP+jwY45uAHZ6lbkPgrc6nYCCWdzM6vdIdg6gyF0oHsjGhMBN+MSQZ9apG6DNz1Q8DSJaQNbIktE5hfRFE1JZIxy6oDWM7D0SAJWaHTsVQO2t8l73DpTxwptmEU7uQA55Czbrpt45p5GU
 OohUZff4
 W78fT3/tPHRGBOBomSYJLGZwr7vA8MpVnS4jcXLWS15G8llpa54PzuqNKHhQHD45Ewx/iFGBmzvqCQVGbwyBLPNXog8z8hT0N/sSf7gMGaLvqp3/yU/TeyR8WR4XMNzvs36KM4FP/wMX+MrNa4hterQzt+DKwXyrJ50G3jdJlkgg/iGS3sO+uQZkHBfqiuhVDULNeniActh5Dl81wRb7fVR/JAy4xt55DCJZYLcjdkCwHShIr/9KB1OXYkrV68bQeiOefOXugfPMX9tiRJoNi1vfPVhaxLm1phBjCtVv3SLpyU5m0XHhbJETirl3zG8AUqv1PiZZ3CrTPjSOkAVvUGjZyDsuijEI9Z9xe62ePjuXSXq8cVN9Gad2/TOi6O1iDnUNBEwSbqG6WvOkKt2SSLwjN8nBSE9Zru9baGsiGmClnlOkSpQjLn1yCm7Y/aFKd+Eg7qPyMITCdvUtkgk0ZKOY+Q8KZiTycUdDvtn4mYViz2nORnSWNqBs9vwUxtGnW18VRymdbuP4kUfg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, November 3.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
We chatted briefly about the status of the stateless KHO RFC patch series 
intended to simply LUO support.

Pasha started us off by updating that Jason Miu will be updating his patch 
series and is expected to send those patches to the mailing list after 
some more internal code review.  That would be expected to be posted 
either this week or next week.

Pasha also updated that is plan is to remove subsystems to simply the 
state machine and the UAPI; this would be replaced by the file lifecycle 
bound global data created and destroyed automatically based on reserved 
file state.  He was also simplifying the state machine to keep the minimum 
needed support in the initial version, but with extensibility for the 
future.  No exact timeline although it is currently ~90% ready.

----->o-----
Pratyush discussed the global file based state and how it may circumvent 
the LUO state machine; it's an implicit preserve of the subsystem 
completely independent of global state.  Pasha said the state is now bound 
to the state of the preserved files only based on sessions.  We're getting 
rid of global state for now.

Pratyush suggested to tie subsystems with the file handler but this would 
not be possible if subsystems are going away.  Pasha said the new global 
state is flexible and can share multiple file handlers; one global state 
can be bound to multiple file handlers.

----->o-----
Jork Loeser as if there is a design/API link for the memfd and whether 
this is something a driver could use to persistently holding data.  He was 
asking if a driver could associate arbitrary pages with a preserved memfd.

Pratyush said the memfd preservation was part of the LUO patch series at 
the end.  A driver can pass a memfd to LUO after creating an fd.  Pratyush 
suggested using KHO to preserve data; the data may moved at runtime but 
would need to be unmovable during preservation across kexec.

Jason Gunthorpe suggested using APIs to get a page from a memfd at a 
specific offset.

----->o-----
Vipin Sharma had posted a recent patch series for VFIO[1], David Matlack 
will be working on v2 of this will Vipin is on leave.  Feedback was 
received about not moving the PCI save state and making them public, so 
that's work in progress.  More feedback said there was missing bits and we 
need more PCI core changes that would be updated in v2 to be more complete 
(but also include more PCI changes).  No specific timeline yet on v2, but 
it will be based on LUO v5.

David said the VFIO patches are using an anonymous inode to recreate the 
file after live update and asked if we care about associating recreated 
fds for userspace after live update with a particular inode.  Jason said 
that VFIO would care because it uses the inode to get an address space 
which it uses with an unmapped mapping range and this must work correctly.

----->o-----
Sami summarized the discussion on IOMMU persistence.  He was working on 
updating the patch series to v2 based on the feedback from v1.  He talked 
about restoration of the HWPTs on the restore side.  Jason thought that we 
wouldn't have an IOAS for the restored domains and suggested it could be 
null instead.  Sami thought this may be slightly invasive including where 
we are taking locks; Jason suggested against a dummy IOAS.

----->o-----
We discussed briefly about deferred struct page initialization support 
with KHO.  Pasha said KHO isn't compatible with deferred struct pages 
although when using KHO we definitely want fast reboot performance.  We 
decided to discuss this more later after LPC where there will be some 
discussion about reboot performance.

----->o-----
Pratyush noted that he is working on the 1GB preservation but will take 
some more time to clean up and have it working properly.  He said 
guest_memfd would use hugetlb for 1GB pages so he's working on hugetlb 
preservation.  Pratyush was focusing on generic hugetlb support that could 
be ported for use with guest_memfd when it supports hugetlb.  He's aiming 
for an RFC to be ready by the time of LPC.

Ackerley updated that the hugetlb support for guest_memfd is currently in 
RFC patches posted upstream.

----->o-----
Next meeting will be on Monday, November 17 at 8am PST (UTC-8), everybody
is welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - update on the status of stateless KHO RFC patches that should simplify
   LUO support
 - update on the status of LUO v5 overall
 - follow up on the status of iommu persistence and its v2 patches based
   on v1 feedback
 - update on the v2 of the VFIO patch series based on LUO v5 and expected
   timelines
 - discuss status of hugetlb preservation, specifically 1GB support, with
   regular memfd, aiming for an RFC by the time of LPC
 - update on status of guest_memfd support for 1GB hugetlb pages
 - discuss any use cases for Confidential Computing where folios may need
   to be split after being marked as preserved during brown out
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update, including deferred
   struct page initialization

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] https://marc.info/?l=linux-kernel&m=176074589311102&w=2 

