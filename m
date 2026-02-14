Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34018EF5858
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 23:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082A46B0005; Sat, 14 Feb 2026 18:48:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02FFF6B0088; Sat, 14 Feb 2026 18:48:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7EA86B008A; Sat, 14 Feb 2026 18:48:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D66EE6B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 18:48:47 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C48A13BEA5
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 23:48:47 +0000 (UTC)
X-FDA: 84444704694.15.037AB0C
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id A02B1A0007
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 23:48:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=36FSvaDe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771112925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CkdJp5ac3TutvWba81u61sOxpegpzJzEEd6Unh7sqvo=;
	b=Xg8VqdrmKDVzLn1KG5DbvDgGMeT/GH4nnqdKyr0/71ebaul9slYeXl34Ffn826E6reRxEm
	DLL36HB9kOwYF/bMMS0ajsvcP9UBG0d50vMRZ9zWdypXNDsPLdLZtfwr3ig9FRuhrgooZ3
	jstleCo4/64cQqjNgdS8jH798vV2cKo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771112925; a=rsa-sha256;
	cv=none;
	b=XC6DtJSO3WGELC8Iloiuv/fR3CKOHcAG9WS0Nf0JQJgGawquICFZKr/h9dlzZHcPBno7vh
	kOGzMsrS/Ub4uzZ+XhX6MDUCDxeNpF0e0ueI6cpyxDUgkvv0xwCPsE1fOKLa6hK7cLDhDA
	AJr/tP25ntsMI4Z9oPSanYZDq+oUz5Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=36FSvaDe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2aad8123335so55815ad.1
        for <linux-mm@kvack.org>; Sat, 14 Feb 2026 15:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771112924; x=1771717724; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CkdJp5ac3TutvWba81u61sOxpegpzJzEEd6Unh7sqvo=;
        b=36FSvaDefI3TiIslyDLwiGyogFKGO/d50I0k9GoG/KJ1Uly5HzgCAJXVP+Br5Po9Rx
         CuiuoipsFR2RjbLz2aiKWEbf+XDS45zu7v3fuGPH9YRy2wYM7X+UmKjGTE4lBDiZ/g5R
         iFkD5fonVMsJr1wP1k7yG30hJNyN+VhlkqBR1lxYFWCEdVdmkdvnsSJwf80PwXfYbn2T
         mBa7vxDPVceI/4QFGaAGPM5ERqBZRQI/ZiKG2ox/0RR6QfySI/f/+4c6htIqPkWAiW8Z
         9RHexJp3SoFQtHJ4kbeMAHGrWN82W3UiJcvNvn1KoCUBxxEc7BO8xINqOrp4o/s4GqbZ
         WfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771112924; x=1771717724;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CkdJp5ac3TutvWba81u61sOxpegpzJzEEd6Unh7sqvo=;
        b=aMNRmORKGzhdNBo1MjpDNvKFb7T9k9bW9RnqHTBkxjpMhpStCMwJlM+G/HA4qYJkuC
         OeAK+hHOUjgcQkqlBk0BF9LnYlgzABFvQA3/Sv46YV1ujTexYp6yVPtOw05QDYWQP7WU
         FsQeuy6wIGe1+U5WUoaQtUSFcPe5qV4/m7tV7Wo8GI+ebZmO4LjcVEYSdj/NyYzfOCPe
         zmsuUcON5tO8G+EcJ+FmHhSx0vrr5VAP4wPJ6ihABot9Kyr2hoaliFpVfcSJNH8fPjTZ
         RbNhVh0G8Z3IknwACv2fFiuC06cjNQ0S1sWxtjOI4Aq6gmDZn9I/CBRRwCF5FJDryHBz
         OkEA==
X-Gm-Message-State: AOJu0Yyl4ZNEmJtJ4rrBR65tAPBi4zX4fk9mEcASOT4gn3Fxiu8AMMsM
	5oijH26WCktnezq0+lpM3/XerpyrkwcOijt8iinfa1iOm0T5Hb+MKHDQAMjWF0fnSw==
X-Gm-Gg: AZuq6aKIyxl1O0DLFojibpIV3cl+PjVaLRIuHEH1Sb4e6Uuvup+erbJoa/Agt7PAjPp
	i1eNMhA5vODVonTT0jSHl65BH4qebDnnn9zUv1LfHoqmQcASwkEZdwOFVlyOz/xZNSlS2Lx1SbN
	FsVBWrfbDTUwF6ffCkdlHJxqs5RF072E9irg3a86pT6XVkKsoG/DHABrpAaiiGXAMmRJc75MlY1
	GQHZeFeMGN3mnasHtKR9zWqMXtT1FuuzU4RiG+85QChaLDabvoTlJlukAwMtCB2lrnl++3JRW1F
	GH7XA3AaaFwX19OSV3jcv+iRIpP/X1zr2Nklny/k5ArEfXCwzdYgXIO15pHj81j6b039sLPbBzx
	RPd/QPKfqGiABkMhPlm1b5sikh9gKiJzuWaDHmv/n68XNVZt1RInaHtyce9Xu9tDCAObjLMnff+
	m1LtfVPCphn9U3DKKQEM4CEzDiPvTOZ/vYCFmziVdIcJsueSRjYv21RrJUja76WjRPMeliE40Mw
	mXRl7Fm0hwfFOUfJwbHKEaHvMWMpapwqnOqpunAG5tYvgFMxJcBXA==
X-Received: by 2002:a17:902:db03:b0:2ab:333:22d2 with SMTP id d9443c01a7336-2ad1f0ded00mr889685ad.20.1771112923780;
        Sat, 14 Feb 2026 15:48:43 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:97ad:c968:9be7:91a9] ([2a00:79e0:2eb0:8:97ad:c968:9be7:91a9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a2afeesm7588583b3a.2.2026.02.14.15.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Feb 2026 15:48:42 -0800 (PST)
Date: Sat, 14 Feb 2026 15:48:40 -0800 (PST)
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
Subject: [Hypervisor Live Update] Notes from February 9, 2026
Message-ID: <4697ba0d-8291-d9ca-8895-c3dfe4113166@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: A02B1A0007
X-Stat-Signature: 9zgurewnw7q683i3zn3c4mhki15iujk7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771112925-718497
X-HE-Meta: U2FsdGVkX1/rZ/bSbu+y5xdXQB83IfEP9N8be132IIw5RyTco7XYG89DnCr50RAzJgDAyyuNeM3g575o8rUgq//b/39AGt5dNWnA59APJhb2vrYxnf2j0vldVXHHsh6M1KA/tehlFxeffs5co0uxWw6RoJSHAsg08/I/DfTnTciI3CGZuycHAfnVIhnyL/8h4KhrPKmau26VbnaBxyTBf1bjFK3HXWzREaN0rd/Z6mnLOb4T8b3Ty+enMH3iQjSHb/xUw8VILdmAzfVr0WSanezi/9o9TmHM9ku6mar3pGWNHfw27WMPqrIegBNFAr2nz0zAECEE5t32W2F3eRh9duf7BPm9NIsWvGxaTIozt8E0BiIjdF9wIaW9TVNMDLB6XyjyETXJfCnI/gYQYE2pKFD9JPHeQ9cq05veAKhZxp+l8o0gyBSq1JUsupTZdtxM17OPMpWkm7e3NT+qNWwCaJx2Y54RoSGaSlLzRNmlTT7cc598fNTC2/DrVUCRNfm83Qz1hmkQ9VS/qbk03oAxvLSR0Ig2JEUPU3QbugT9xJsV4WK/E0lARHTUIfXk0mjs91qwzuNRF3TG5lCAsHDjqbPcfYYj0hkPmJNK0AMNzgg13zd1M6K40SL0Q/ZXTIr4XfsL+iEfmKZgeNulysxrbLCCokUkHxgfzb8wm05w33bJd1RUWF6N2G248wZRVrbjKbPr8S7abT2Zx0fKZ2TomsExzv6PZ0088ZQmyA1N50ra5ATmW0wsA9clpvdVxbEIm4D8awelBk0Sgy95zUnZhqEhOcPwGDUd++fCrnMjUMi6niYTGMPQYU3YbDqn3rdSW1VD9tVZf3WvMspFOS4AYCSDCsmohi/TaWP/7JuX1nKuM0r+WVXFCj6ETQZiVD4Wiolipc1Hrio4uyeb9+57gwS/EIZ0mYyxU3e8N+/7TznitauS1ldZRJhEEVb3F9nOgwBJly6n+4SmN8G93Lm
 TSmkQyqJ
 GCoPo9g7rqF/rdfONEqRB8oOeEnYqQZO0Fo/PEBqOtCN/tKP8KfXuC9yPIW7yjTbnrGflzTomYNxrev24iG3b3vC5bsa0B7zXrEWQOp86ooi1gr4s86iWQyfYRzuO/l6MkV27VT5TikPhJ7hG9XGbU0XJT8X+1A9YzY2cg1120xinytu0gKwK4mg2K4+jjIguvTHD14UMlzUWzL6eWnLRsWYj9vzwKAfdglg5Y2jhYdtMJM1Bjll5gFyagkApVbNa3itUV0hV85SI2YiyRxB7GzuhTOy7rK0m8LZNBoJHpuhkRwtHN4Hl8MvD20NHNH8EFLC41uKaaf1sNet7VZLA/BQ8egDonBw8VenInyxeNyoj3ERjGQQdKoySzQYIUFaxp0Ix/6v0+J1ovwsLAYUHhzS3xLfBJw6E19WH+HvjjEwd5aS8r73oqjKY76cIgyRKZ3q4l4w4NXzV+uOu2V127fqPS1PNqomWuq7j3rA9J0KSAoJPX2G3V2cGwzP29F5e7OnjeoGcCROfEOZZQs1B3n7lrWgDjtnrzBIUMT6vAqtQIM+y1UP9gs/z0qOUgh9Aqp77jVBujfSLcy0W1FFF7LMbCBOq95dSGsHHBeMhz5VZWtwojIu8Pkw70i0+ARKpqA+a/1M3kEoM75UzgBH2oWcsKd3fSCgWTnGl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, February 9.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Stateless KHO was reviewed by both Pasha and Mike upstream and they are 
on-track to be merged into Andrew's tree with no blockers.

We're awaiting additional feedback on the luod design doc[1], so please 
take a look and provide feedback directly on the doc or bring comments and 
questions to the next meeting.  The main question is whether this should 
be part of systemd -- if so, it should have a different design based on 
systemd.  Luca was noted as being interesting but there hasn't been a 
design review yet.

This is important because VMs would interact with my luod and LUO 
sessions, so there are APIs to align.  If luod is standalone, then this is 
more challenging to align; if part of systemd then this becomes easier for 
qemu, CHV, etc.

----->o-----
Sami updated on IOMMU persistence.  He sent out v1 last week and there was 
feedback from Jason to divide them into two phases, so Sami sent out the 
first phase.  First phase only has preservation, the state of the IOMMU 
page tables are preserved across kexec.

----->o-----
Pratyush updated on the status of HugeTLB preservation, he's planning on 
sending a series out for RFC v1 next week.  He also sent out a proposal 
for LSF/MM/BPF for this topic.  He also suggested we do a Linux MM 
Alignment session for topics between LSF/MM/BPF and LPC.

Ackerley updated on guest_memfd support for HugeTLB.  The next step is for 
conversion support for private -> shared.  Although not a hard constraint, 
this is what the community has decided on for upstream merge.  Pratyush 
suggested parallelizing as much of this as possible including for HugeTLB 
cleanups.

Vishal discussed folios being fractured on conversion and the Confidential 
VM requirements.  He also discussed dependencies on guest_memfd specific 
features that work needs to be done on for HugeTLB support.  We planned on 
carving out time in the next instance of this meeting series for that 
topic.

----->o-----
Next meeting will be on Monday, February 23 at 8am PST (UTC-8), everybody
is welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - stateless KHO patch status in Andrew's tree
 - determine if luod would become part of systemd and discussions with
   Luca; implementation and next steps
 - versioning support for luod to negotiate
 - HugeTLB preservation support
 - ordering issues when disabling interrupts based on feedback from Nvidia
 - VFIO patch series that would be incremental on top of the previous
   version
 - phase 1 of IOMMU persistence patch series, then phase 2 status and
   updates
 - hitless replacement for iommu domains and series from Baolu
 - [15 min] guest_memfd support for 1GB HugeTLB pages and preservation
 - live update related topics to propose for LSF/MM/BPF 2026
 - later: update on PCI preservation series and next steps
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update, including deferred
   struct page initialization

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] https://tinyurl.com/luoddesign

