Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF5DC87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 04:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680F26B009E; Mon, 11 Aug 2025 00:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658236B00A4; Mon, 11 Aug 2025 00:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E476B00A0; Mon, 11 Aug 2025 00:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FD616B00C2
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 00:23:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFD01828D2
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:23:14 +0000 (UTC)
X-FDA: 83763181908.12.11E3705
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0197140008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:23:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HjInaA4C;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754886193; a=rsa-sha256;
	cv=none;
	b=Vhb7oos1QkV6zPFv1TZ3cjfyZKLCKM8Elj9s6XpGO5E1yPNlnzRH6TgvdDXqpq143124Jg
	79YQX8jfLoMScwAR0E+FQkPRxBQXLQkfkou8eg6I9nZ5yfySm3wMAL2txw5iut3Xvdv2QP
	FMu7XjtAIQ7AMIGrVXcES7Mi4NpGapI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HjInaA4C;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754886193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UCSBCXnMQmaIVAH+e3b7TVmR3mlo8rlRXRLYG8Vjwv0=;
	b=OYC4/XbMYwivJZEST18Fzpj4POxxJYF7M2RLkxvdd34TUcU0UwlqYY3/2nUmbOyE4Em31G
	Xw/hGFWajd1VvyeIWXW71fuwKvMrc8qGhGM+7rtHlqV+45vVtZzB7k79UcaACOCnTorr7p
	BZqVB75JB2rWQL7dwnjGggDw4kxo0V0=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-242d1e947feso234545ad.0
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 21:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754886192; x=1755490992; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UCSBCXnMQmaIVAH+e3b7TVmR3mlo8rlRXRLYG8Vjwv0=;
        b=HjInaA4CgFEJjTUzM0dVOpM5JS93Fu+2snmICyYyEmDiFXIS9IjZaFzy3ti865ft4s
         y4PN0I/7uXJF1j9rHexvgKImnAKA3bjpAtmaIcYqBeTQII7cQNP2fmVVRvCXmn1HrlZf
         dxtQaEAsNJmuvvyOIWOFzce80qlwGXrv3Z0X3++UO8ak9DkNIOfucFeZrp5lxwhxIevi
         Lsyt4KHHSqIXFkcd2yuS+8eqWFnQqD0+Y+VsvoPJDbWLn+NrPENMnfcbSfImITzSfaJr
         3yU9uZzxajr3rSeHZG2994TEJFQsIJoEa/CmgExini2IuJmUmHU+Meft3kiNHgACtm3Z
         zUJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754886192; x=1755490992;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UCSBCXnMQmaIVAH+e3b7TVmR3mlo8rlRXRLYG8Vjwv0=;
        b=J/hsiyQUNwQwLG0Y0E/gy4pnXzbBeo6Jp6I1jU/MAYmIF1o1/zeZBbJUXiGbFOiP9d
         6ceD0boGoTH8bDPhIAT8HbSVbvHRJNWzXwx+5nn13VNJa071afq2zjtREGq+0qmVcFtW
         2th7NustKnakYAux19wVzCi0C0VO5vM7h6ATNzn5kNSa4AYBsZ2RYg9n/Ui+1D+rul6J
         5BCqXmDfdB+mi4Yvjt/NLz2dUN4ehK5n5lNEjGk2wPeLIkSxdqVRJ7dbzz417qReYoU0
         sH8qtALTl+3QYTZx3qpmh61CKvSRGV+L1Q1DN++pp2pkVsDpLVN8Ks9hGm+HDaLCYvBA
         P0iw==
X-Gm-Message-State: AOJu0Yzln/Ja66bztASD78vx1c6KGntlqctQ38sEag9dXZmQ9dgXK9/2
	wO9Ig+eLaxC92cQBSzw39x2F12iNKDL3lB4WteOYq2KIlaPshdykwyhHCKUWEVT5ow==
X-Gm-Gg: ASbGncsI2xxdmbFieZF0stRWWBy2yzsb9K9vYbqW5Ipe+bmdqMwDYXXa6CmrZI6nkQR
	rx4u1vA/RP4PLoj801O71xWAZX+SkLR30+sy8ATu6XciHMtildaAoUB8ZOoivhklxX9j2R1i76H
	ijtibToPB3KGdW6a8qseMfGV5BSiEkVBKWWJdfU7F8srTEPS1MhKmn56yEqsPX1Y5S37p4X1fP5
	HE4K3drmfZ7KWZleWTE9VVJk2NKgpmVn8DqhT2JE+FBsy7Uqk6DrSP4Iz24zT/fWbCueZNimHsl
	Z5EbTztozjAVnwm2UTwEIjRjPaJYLTvQiATKYQzPS/XsqVsM8v6mfSSh8M6MMtD3KOSQhskw8GN
	l5vzdF17QelKL4xTLY8htsb2NkYVZawN6/mbcaI3qVvc0BmL0ThcxRuJXQwXF0PSZ15Hbdq9Zc+
	vvPzaOGx2jYrboYdCO
X-Google-Smtp-Source: AGHT+IEPFfcbgvOfxJdst9AfZvSBtoZS/zbmaiucrFo4yynA5He38FqIVteTcaFq8sU9C/fFf6t6iw==
X-Received: by 2002:a17:902:d507:b0:240:2bd3:861 with SMTP id d9443c01a7336-242d2bc657amr3889325ad.10.1754886191100;
        Sun, 10 Aug 2025 21:23:11 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:bf4b:17b7:3044:fe58] ([2a00:79e0:2eb0:8:bf4b:17b7:3044:fe58])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e899b6casm258903005ad.127.2025.08.10.21.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Aug 2025 21:23:10 -0700 (PDT)
Date: Sun, 10 Aug 2025 21:23:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Alexander Graf <graf@amazon.com>, 
    Anthony Yznaga <anthony.yznaga@oracle.com>, 
    Dave Hansen <dave.hansen@intel.com>, David Hildenbrand <david@redhat.com>, 
    David Matlack <dmatlack@google.com>, 
    Frank van der Linden <fvdl@google.com>, James Gowans <jgowans@amazon.com>, 
    Jason Gunthorpe <jgg@nvidia.com>, Jork Loeser <jork.loeser@microsoft.com>, 
    Junaid Shahid <junaids@google.com>, Mike Rapoport <rppt@kernel.org>, 
    Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
    Pasha Tatashin <tatashin@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
    Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
    Vishal Annapurve <vannapurve@google.com>, 
    "Woodhouse, David" <dwmw@amazon.co.uk>
cc: linux-mm@kvack.org, kexec@lists.infradead.org
Subject: [Hypervisor Live Update] Notes from July 28, 2025
Message-ID: <05f47f4f-524e-0925-9e23-bfa7286d455c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: i4o9obrepiwmabcekz91yh6j8aym8ahu
X-Rspam-User: 
X-Rspamd-Queue-Id: 0197140008
X-Rspamd-Server: rspam02
X-HE-Tag: 1754886192-474736
X-HE-Meta: U2FsdGVkX19+8fToaTiIE9vGxfHUm+d6prZveW8dD+WILP2nR1hGf4UexsZb+4SszwndwzhC/ORQiAGMpnqarXHRtRhETY0OlXMcVyAQA9Cxyjxiv4WtKnFuJPRSUtTiMHBOgGlxiQuw0jm2cmUs4pkb/X3PLdRr2mWMoc4Kg7uoV3PlA34FAzwTVxs6FYntfGvL7GCNkcNUw19r8ebbqoHGmRl/aRlM/ERO2JKRb+xqynR+zx9jxQMiqnyOnjDUaRGBUyri/ryCXsGdLIrT84Mj2ky88X2p7SUMgsNfy3PuMCKPmiv1FAilREJccxClvKUooohreC96Yu0byQ/XW+2BC2xV9IiWmsPztLeJoH5eiKNk3pn3km/rG3HvG41wOa+uHx3s8n/hwukORHJBDk4iYdm5riMUoB4+fGxNm5NAoypjjW+kKtOSgNxi5IJSJX69EOt+M1K9V4d6f1G3XOaJvxyg6oH6d+NIibmz33/69ZlGNEcDbZPS/0S4tyYvjvqWO+EBMxXaesQjA9XiMBcMh3kO5d2b1OnTKCCfh9QHejopgTWgHxCZulpb3tmmWWV+cYTFRtIACfVyUuDhdLke4A4zT/dG1yyks6fxBtA2FI1m7hp0Ze8V9o840xaRF+DpOToJMPqxmYoQ0FzBC/khfSlooNYONXe3ohe89OejPao/FXVhKtrUlLpTnVxGX2UsUwEAQEXGFX+ZT8pfizbRL6AUl1lQU3UMYrLwjWh1JxW+wlRW7Gjy/3cWLZou4iznEsf3VvCIbqSNnJ+PXrwrYRts+4uKyEhQead1K5qUQ+wso5qZSi34UW5iWnQGImit2uNdzZvCaxe/xRTZSg4PXSTmfMrX9NKvgf9S7cqH6CIXHmvx0wu0e2nYtsxevzlY91pXI1gTvngKEVIsQVz1cfixBrlcXMe9+6GruDMqeV7gZ7oXCgTMMqM7eja45lJOpU15Lqs7C0B05pr
 XN1qgTCz
 zstxt26E0l3P7QK6KYWn/ee+69pl/9pj6328CHiK2ULxeogZOhYvWKzx5ziBQehtqa9xUuRtc0AkLJoGGHxkTf3TXp58gBke11iZH/iBDzD3ej3uDeF+z+NPVlDk7Dct/iiugxGmeUiUzx/ctkgevQ/1fKUur6tT2U5O7hN3g8uGAyEwUvBzUJIfZL2GM/w1EfPmiOIu6VOMdtIoFCN+xFAp9FLufiuc4qVraIFgHV9tEFV0UhL5CN0kEn4MIs9xL+rjPtbv6li0Ae1aC+S75FRLsj1xRr9IZul7b1s9C6KE9csQAsqB4Cm7esL6+1FYHyDiD4+3dTC6yXROjvP1s+2TbMgZnIHG0coCoxhKHAnnWtG2eaNh/VwPmwbRfQjBihQhIA5VH0ekjcZnAoi2fXypW6e5w+8PU4QZFhTELHWRE5qv2BXboKmVYfoVgp1rb+py6UEVPXXaQq6o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, July 14.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Pasha Tatashin discussed LUO v2 and what parts could be staged in the MM
tree.  Akpm suggested updating once the 6.17 merge window is complete and
then rebase and send v3 which should be around the next time we meet.
There will continue to be feedback addressed upstream in the interim.

Pasha noted that there were still filesystem discussions happening, so
that may change on future iterations.  Jason asked if there would be
objections to the series upstream; Mike Rapoport did not believe there
would be blockers that would prevent merge.

Mike noted that systemd folks were not overly happy with the new UABI but
that they can live with it.  The nature of the feedback was not
necessarily about the ioctls, but rather the systemd preference to have
everything be hierarchical.  Mike noted that upstream feedback preferred
VFS be mountable because of a preference for user namespaces, but there
was not a use case beyond init namespaces for now.  The feedback from the
group was that we should define the security model first before requiring
a filesystem.

I asked if this was a one-way door, if we could eventually go back and
support filesystem in the future; Mike suggested that we would need to
continue to support char devices in that case.  Pasha agreed that we could
do an extension in the future if needed.

Pasha asked if we should enforce a single open of /dev/liveupdate.  Jason
thought this was appropriate due to the clean up semantics.  Pratyush
noted that if we support multiple opens then the agent can hand out the
opened fd's to the requesters and if they crash the fd goes away as well.
Jason said we should do this with an ioctl to give you a new fd with a
session label.  Jason was concerned about the lack of the ability to
preserve the access control for a filesystem across kexec.

I confirmed with the group in the call that there was no objections to
proceeding as discussed for LUO v3.  Pasha noted the only planned changes
would be to enforce a single open and then use the ioctl to get the
session.  Jason was going to provide minor feedback upstream.

----->o-----
I pivoted to discussing the agent, affectionately referred to as
LiveupdateD.  As the LUO design was not yet finalized, there was no
decisions formally made on the LiveupdateD design.  Pasha suggested that
LUO v3 and LiveupdateD development could proceed in parallel.

We discussed where both LiveupdateD and libluo git repositories should
live.  There was a general feeling that this should be decoupled from the
kernel tree.  Pratyush was going to create a repository both for GitHub as
well as kernel.org.

----->o-----
Frank van der Linden then discussed his concept for a physical memory pool
allocator.  Frank presented this as an allocator for large contiguous
stretches of memory, such as HugeTLB and guest memory, including for
partial mappings like PFNMAP required for Confidential Computing use
cases in any size that we want.  If we have a 1GB physical range of
memory associated with guest_memfd, for example, it's fine to map a couple
megabytes of it; if you have a 1GB folio, however, you either map the
entire folio or nothing at all (or break folio).

Jason said that if you are happy with PFNMAP, you can map part of the
folio; you only need to break up the folio itself if you are going to put
the folio into the VMA as an actual folio.

Vishal Annapurve said that the way we are handling 1GB support today with
guest_memfd hands out physical memory backing shared ranges to the core MM
so that things like gup can use it normally.  This requires breaking the
folio.  Jason noted, as he mentioned previously, that you can keep the 1GB
folio and use pfnmaps everywhere else and ignore the folio.

Frank noted that our interim solution of using many devdax for preserving
memory across kexec is more convenient with an allocator underneath it to
avoid needing to specify tons of memmap= options on the kernel command
line.  Similar to hugetlb_cma=, this would specify external memory such as
extmem=0:1G,2:4G.  Only the bitmap allocator is used for creating raw CMA
areas that are physical memory only (this memory is removed from
memblock).  Jason suggested that there may be pushback upstream for
additional allocators; Frank suggested that if this forms the basis for
other allocators then this may be a different story.

Vishal asked if we should mandate PFNMAP mappings only for guest_memfd.
Jason said that if our only need for guest_memfd is to create a vma to
speed it into KVM, then use PFNMAP is reasonable, which disables ODIRECT
and RDMA, etc.  That may be appropriate for Confidential Computing, but
qemu certainly relies on it today.  So while it may not be possible to get
rid of the folios in a broad sense, it could be possible to propose.

Frank noted there is a conversion layer that allocates the PFN range and
does minimal hotplug as necessary, converts to HugeTLB pages, and adds to
the pool.  Additionally, there is a device interface that can be used for
testing.

The pool and device interfaces work, as well as KHO on top of this.  I
asked about the minimal chunk sizes and alignment, Frank said this has the
same alignment requirements as CMA today.

I asked about early RFC timelines and use of the biweekly Linux MM
Alignment Session.  Frank said an RFC about a month from now would likely
be feasible and we should continue to discuss Jason's point about the
concurrent use of folios.

Jason suggested that we need an answer to what problem this is solving and
if it's only to use PFNMAP memory for guest_memfd then this may be a lot
of complexity when there are cheaper alternatives.

----->o-----
We transitioned to discussing PCI device preservation.  Chris Li had sent
out the patch series the night before that can get the list of live update
devices and their respective dependencies.  For example, if you need to
preserve the VF and then you preserve the PF as well.  Additionally, if
you preserve the PCI device then the parent bridge also needs to be
preserved; this dependency goes all the way up to the root bridge.

Jason questioned how it will keep track of what devices are bound, that
makes the driver name part of the ABI which isn't great.  He imagined that
if the device is marked as preserved for KHO then it would sit in limbo
until somebody claims it.  Chris said that the kernel cannot detect when
we're finished probing the device.  Jason suggested using an ioctl into
the LUO file descriptor so this becomes the responsibility of userspace.

----->o-----
Next meeting will be on Monday, August 11 at 8am PDT (UTC-7), everybody is
welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - follow-up on sticky preservations with KHO, any additional insight
   provided for MSHV use cases
 - update on LUO v3 and akpm's request to rebase on top of 6.17-rc1 and
   send v3
 - discuss enforcing single open in LUO and also support for using the
   ioctl to get an fd with a session label
 - design discussion for luod, the agent previously referred to as
   LiveupdateD
 - update on physical pool allocator wrt folio support and the ability to
   pfnmap from within the range of memory
 - update on PCI preservation, registration, and initialization, and the
   RFC patch series posted previously
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update

Please let me know if you'd like to propose additional topics for
discussion, thank you!

