Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5878CAC582
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 01:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926308E0002; Sat,  6 Sep 2025 21:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7118E0001; Sat,  6 Sep 2025 21:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC618E0002; Sat,  6 Sep 2025 21:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67BFF8E0001
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 21:08:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 100151DF0D3
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 01:08:25 +0000 (UTC)
X-FDA: 83860668570.27.51E44BB
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5BCD6140002
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 01:08:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vYpD56M6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of rientjes@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757207303; a=rsa-sha256;
	cv=none;
	b=evgoXQ5Vh6tCPDnhm1ROjryZJMLMPscy20DY9MyeMxkO8djmy5h9tzRmUlHSnSvs8/lpFJ
	I4MNxbpG+xgayoCCKj1M7IMUwSACS/qTChZhRDU62J3AGeBgd4R4qRNikFxVczhG9rER0g
	NImOGqI4nOEK4zSWjq2c+hqQv386Pac=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vYpD56M6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of rientjes@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757207303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mb+Xc/Fhoa55OVesG0tBvrpUm1r+fHKYqn+NVCDgkGI=;
	b=25YL3h8hwQNNp7A/u29fsmkskb0/wooegoYYmezdeA8cd01++KXp0OhW3CrSq63IVziDJV
	M8YzTFesry5aP8ARM9JQEEX8C5NGAQ6FygxL9TP2Axwe3ZNODxzlbxl8x5gXl5ZzdZ4Acz
	4kJ91famCME7qYK08jVGWhigoJNcWzw=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24cca557085so142375ad.1
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 18:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757207302; x=1757812102; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mb+Xc/Fhoa55OVesG0tBvrpUm1r+fHKYqn+NVCDgkGI=;
        b=vYpD56M6Yd3TlvacQClE/++Wk/tEiX0G/nQBUdim+z+0mIKFDbezreuXyyIhaQpVh7
         hLd/2+tTPfgWyCHLkSvZHTkouyNjw0saiSugjXnylp/IQi9Qc6U7dA7u8L+lKMUHwJd6
         vCa0S4ITVWB1xEBC3kXPBz0XxNTsPciVDACKm2A+1TEZxJX92h93OZDCGUVGFU3E5BD1
         miRZhWVdKSvpaFZIBp7q+/MQuqIdG5KLmc4dgF1wO8v3jtj3jryvYCYWJXQxeb4Z/4yk
         1HRSdxKYRbW2+QSu5yac5+PEBoCx+6l2RdU3q0IfRJ0BR6k2DbqKhJO3GxnAAFjhg3AI
         /Ncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757207302; x=1757812102;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mb+Xc/Fhoa55OVesG0tBvrpUm1r+fHKYqn+NVCDgkGI=;
        b=btBT0+sS+QLbID6SDQTc5HiCOC5V+anf+piWxLfocWASPSfMwgrPMoPClpPhbrbE0h
         uaefC+ImGWtG7EXthuFAPEucI5cX9QPLfSZ3JulWEsp6DzFNpr01i6xS02eNJGdP1qr0
         N51kgyQMkFVEkxSd2bZpcpi+QKIk/uTAizb3pBuC6BRbzKcrRU9r8psLOwaGtOzk/a6+
         BrRicykpFpDubbzynpP7ZIiiVE4pnyPEWs6FvvrxuC2d+puoTTpM9rCxMVpJIAwE4kg0
         5UYjWTOWDB/z7KXLGWJMfKdBI4lXRfRDLsSHKw+JacPvNDsRLm5XnNUlSw0yMXasA6CU
         Bq6Q==
X-Gm-Message-State: AOJu0YxhO8i1qwtTMMicD0NGMaOO7hEqxdxkFJrSuPQ2/cOidU3dwNoH
	3w/gTZx53YzENWG5ZmVq8285arEWGGs1J32eJF1Eb+zbZQbQPkvw/zyEWP8YP3mz6w==
X-Gm-Gg: ASbGncvWcCqbRy4PZf7vgRev2wJMP43DYjKvy6CX3lNv/2aCAuLHPjKc/ZsDtVkhwu4
	Orq3BvyrAvBvkepVE7EDz4l2TT8ubHOVzt8sL6efpVHXg3eusHuMHQ4YdJ7jx5ONOD6316dxCsi
	+N3IXl5i1D2d/Kj02tPCWgkF1qyHoW0iMLVGovzWUDk8Aqj5FDi9/aJ+wN+5zB6w3Ncp0hKS6ig
	hUpCMcbkNoH0Q7eFEPNunOPFaz/myrYlk+d98OWtewejtkQHrxlNhUWA3ly2WkyQ623eU2DnF9n
	wgNp0940VQAx3B2G4zZB7GuUGxOzfsM+mk8sxDycb1Zp3FaCkB0FV0oxCKocX3L0J3KI4hIOQrM
	PFbJSpcMuws4gsleZq9Gu2hAFm+LPtrY0ErDbUCwdwYI/4yAlJ8rKjKC0vAZVR8HtGogBICSXiL
	aZXvnrCuiMtV3trwykplZhs5FTYmZfnQRk3JzTMTyXyOBTplDYK1Xl7Uj1juCxtvccSQ==
X-Google-Smtp-Source: AGHT+IFsuipR/DgiNICg4e4PuE3wa4KSpjdqnBxa/j9NLckSMg1RLjJgvs6aq56radYTICZ0438NfQ==
X-Received: by 2002:a17:903:1ce:b0:248:bac6:4fd8 with SMTP id d9443c01a7336-251753d8c2dmr2133515ad.15.1757207301592;
        Sat, 06 Sep 2025 18:08:21 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:3c1b:d276:de82:d12c] ([2a00:79e0:2eb0:8:3c1b:d276:de82:d12c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24b1589e505sm135481755ad.123.2025.09.06.18.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Sep 2025 18:08:20 -0700 (PDT)
Date: Sat, 6 Sep 2025 18:08:19 -0700 (PDT)
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
Subject: [Hypervisor Live Update] Notes from August 25, 2025
Message-ID: <eb24a22b-8fc0-efe1-9633-bdc7734eb13c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 5BCD6140002
X-Stat-Signature: d7sarojww1uswz5kohe3s38pbf17ppz4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757207303-91461
X-HE-Meta: U2FsdGVkX19AiXHtSqa/ncp3Hg4N2KPkAkZDisMIkuosyUYP1uClBAlYMhchLNU4kyc7wJP+bgXewOjmUXO81yT4VuvFKZdJPOnr1K4T6+Kfi3W4FCCsahE239j9hkLRKWj5pjkJjULTo5cOUF5t69MobIwGcDlpHqcT6CDSfwh90ZyEXzPFDTmzystr6QN1vUcmET153+GME+Lom7STL/sJ3C/WYvoydJuiMD1DtSqnAMLVLJztH4so40BgLsQZWwOYUCGBOguV4GKTT6nLa6ZXfcepR6/k23oQrFNP+jru0tSKlQtrXhx8R1oDn2nI60snmvmtWur1u6cubcksDgwos8LkSAXJfuHjZTNsOas+edyuo5y5zAgcPvhhi2420+2LXZe2aG6BwsdsKiE83zJ9SQjY3mTYwbUUar2mR6cI8qgFImOC15Qkw6oqMcB3NN9v54R6WVDkeFWKkhLh+Wt7ZGN5WPazppl3XznWWQGD5MpmHlgmzeO8130NDD2+SwaM0BmbzB8S00R0o863O/k/j/tVdUIavwxD0kfzMxovOSZ7wQ94FmRf9ZGjBKYkCvgRet4Ek8NCURI1rlkVF+GhTwDdYTRf62jE55mAbxyQTgndl4nyIUfG6oQa+yRuOuqvaRCOPyRUHBY+j0XhU/7l0XpsW3lE1aGLFTM9+BCSf3I3nGVKX/bVwRdbAv2sxYDLiOzZX/P33xbEjGL0myhU5m2/D+f2Dd03gQXnIjjT3gN3EKxn+PBvmyZhc6YFXDFKfxWRCyGrz8Dry2qaaHlIddHFxFFOjPtOIikxdfjlj9ZBLp9HAG4/evnNO9RCASaRVQvcOzU3mEBpSZWYhWYAkoJiOCXDSAFMaKNgHowYDfN3SbRp3q9PjpAzmfKBWdGtje4Cdd2LFNd3pVSrW108IVe0DxqliFzxA2UipOJROhzeAYFvRX19WMBm6oyW515gCxYNwC+cn9DnYY+
 59mbw4qm
 etsPqsICf4tvmBahVC0ru+fWlVfXCQ+KF0ey2GZ2GmXSiNXtJK7nfp5dCQEY8Sloq9jNm2f9F4JZRruecnjYhqR0DS7WW9XdfdDuR0OH/3wLzLDmS8V2t22Zv+DZyZGXHYbBx9P6pg4xmsvHCw7svqb+pFb4iw+VQM+6VCjyXqI8b/Wdf1MKYCctIvrpc979hBxvd3NaShBazSzZp8U2L0KLFey/sBAEHglddD0dwJ/q7x0yXHv4xYFOFgMFuRQm11rQKTUmSQRq2E2dTVl84tdkEvNnYbPRtCrMA2PX2+LUTmrRvk5oDr6vXLPpuL37vDmhayS22uEZuYTCcpGgIJ5JkSvft6OVOyViht2GpTcgqotWTrOLW1jYTolvm/AL1NarBYFWa+eXPaWbptIV2dszDDCltB2cqvmkQa9eVVncqZACyWQGOtSusGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, August 25.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
We discussed the feasibility of sharing the videos from this series of 
meetings as unlisted videos on YouTube.  All of the previous videos and 
summaries are available on our shared drive, which requires being added 
with your corporate or personal email.  After discussion, there did not 
seem to be interest either way in this so we decided to proceed with the 
shared drive as normal.

----->o-----
We got an update on the latest of LUO, Pasha was working on v4 that akpm 
requested based on upstream feedback and for rebase.  There were no 
additional updates for luod, but feedback continues to be received on the 
externally available design doc.

For KHO, there was discussion on making this entirely stateless and the 
format to be used as a result of that.  Idea was to use page tables and a 
bitmap at the bottom to specify the preserved pages.  Pratyush noted that 
he sent a similar proposal as this earlier so some ideas may be grabbed 
from there.  Jason Miu is working on this and noted that the proposal is 
similar to what Pratyush sent before, he said a draft implementation would 
be sent out by the end of next week.

Jason Gunthorpe asked about the staged approach to avoid retaining the 
page table information.  He was concerned about the circular notion of 
preserving page tables and then their page tables.  Pasha said that we'd 
preserve ~4MB or higher order for the buffers where the page tables would 
be allocated (shallow page tables); to preserve a 4MB page, we use pages 
from itself to create the high-order page table.  Jason Gunthorpe was 
concerned about being able to allocate such high-order pages.

----->o-----
Pratyush noted that there was some feedback on the memfd preservation 
patches and he planned on sending out a new series shortly.  Pasha said 
there was the 1GB limitation with the current series and he implemented an 
extension for that so he was planning to send that support to Pratyush 
offline.

----->o-----
We discussed luod and its implementation language, which turned out to be 
interesting.  Feedback from Mike Rapoport and Pratyush were to implement 
it in C.  There was general concern about some developers not knowing Rust 
well enough to implement in that language.  If implementation was going to 
start in the next couple weeks, we would want to settle on the 
implementation language.  As a result of the discussion, it was decided 
that the initial implementation would occur in C.

----->o-----
We shifted to discussing PCI preservation.  Chris Li noted that v2 would 
be scoped to only preserving the bus master bit and not doing any DMAs.  
He was looking to send out the next series of patches end of this week.  
Praveen Kumar asked if the hand over was part of this code, Chris 
clarified that it is not.  Jason asked how this would be tested, Chris 
said that he was going to be checking with a printk on the other side of 
the kexec.  Chris said his next step was likely to extend for a networking 
card that would allow the packet to keep being sent.

Jason suggested the next step might be to make VFIO work with noiommu and 
idx testing.  He suggested doing the IOMMU side last.

Vipin Sharma subsequently noted that he followed up internally and wanted 
to discuss interrupts being disabled and then blindly inserted into the 
guest after host kexec.  He said the PCI specification allows for masking 
the interrupt and there's a pending bit array that can optimize for what 
interrupts we are installing in the guest.  Jason suggested this might be 
done as a follow up but will be more complicated.

----->o-----
We moved on to a discussion from Chris Li about what he referred to as 
KSerial and this solicited a lot of feedback.  KSerial was a serialization 
protocol between two kernels, specifically structs between the old and new 
kernel.  He proposed depositing members of the struct into a wire format 
so that it's not tied to the kernel implementation that the new kernel 
would read from.

Jason provided some feedback that we will never want to serialize IOMMU 
groups, they should be discovered independently.  Same situation for a PCI 
structure pointing to a bus, which Jason also said we should not be 
serializing.  Pasha said the focus should be on the generic format for 
preserving anything, not specific to just PCI without using FDT (which 
should be read only).  Jason expressed a concern about very complex 
support that is not yet proven to be needed; Jason strongly suggested 
against preserving native C structs.

Pratyush asked about FDT and suggested there was a lot of boiler plate 
that you have to write to even get simple things validated.  Chris said 
this would indeed by additional developer burden.

----->o-----
Next meeting will be on Monday, September 8 at 8am PDT (UTC-7), everybody
is welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - update on latest status of LUO after v4 and next steps for merge into
   akpm's tree
 - any updates on luod based on internal and external feedbcck
 - update on making KHO stateless and preserving page tables, dependencies
   on high-order page allocations, any next steps
 - update on memfd preservation and status of 1GB limitation before
   integration into akpm's tree
 - update on the latest status of PCI preservation, registration, and
   initialization
 - any updates on VFIO with noiommu as a next step for preservation after
   Chris's v2
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update

Please let me know if you'd like to propose additional topics for
discussion, thank you!

