Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE64FF3ED67
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 00:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFCFE6B0089; Sat, 11 Apr 2026 20:14:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5ECF6B008A; Sat, 11 Apr 2026 20:14:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26716B0092; Sat, 11 Apr 2026 20:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9AD516B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 20:14:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3107E13BB3D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 00:14:27 +0000 (UTC)
X-FDA: 84647982174.20.ED31A5B
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7FA304000A
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 00:14:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ovn6JymF;
	spf=pass (imf01.hostedemail.com: domain of rientjes@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775952865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lmunf8hKp3UcnRXrvQgVK828HP0WXdYhEtCShztRC04=;
	b=X4fdHecbeGalJUsOFqvsK61RKv8zd+0XWdXteP+H6+AUmS+UHke7lnggVNG1kYL74V6SAg
	dII1jYd/CXm1AGRm41wmlj7OJ6qvopqf4zMZa2vy+Pqa2r/MhQvBQoM9qSDp0ytaMxvFwP
	yVYkp5saFAuyQNeIYlgtzr/FVlEUXV4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ovn6JymF;
	spf=pass (imf01.hostedemail.com: domain of rientjes@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775952865; a=rsa-sha256;
	cv=none;
	b=S8vMATF9b6cz2YdXCqkvNtiLtK9Hc2uxkWgAZWmX5E90zwJ/66d8L+NltQ/qdTLd+FewSe
	WkCsJKU+5S6PXXAA1DbKfXC6jPWr1V2nlvJGAe/d0zTb4SYKth4cb7Y8hNuFaJ+BQigEaQ
	JsDwCIE4JuSgLKEjArLvA9FUULPmSLQ=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso21575ad.0
        for <linux-mm@kvack.org>; Sat, 11 Apr 2026 17:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775952864; x=1776557664; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lmunf8hKp3UcnRXrvQgVK828HP0WXdYhEtCShztRC04=;
        b=Ovn6JymF7wVVnZICN2U+QXXDqbTEEJxa9nqPPdEnM/lUj+xLfcp7WXszpbCPzYhiGf
         HnULfI0wX4y3dxy32QuT3d+/bId8eBuY8JagwtrKRp004IgVu2JzUvswqT4ndhygCwJX
         6TCEJpah3/IK8jiNtVWL0dyNPdVEi1MzslXHnyXLJfgqhrlz7UlqBjiYgW8hL1vWD+r3
         wgvcgywLGYpgSgJbs9T/fqVtjcvw10gI7yA+srOGnoIrg/IXaekm23fh9xMNR1/qwbxv
         UUlnFqw8nsxh/SjA6szu6S+WcICPQ45ynMgK+1K7/4gcAnNcgXY6fZQvAguroMHm8mJO
         LcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775952864; x=1776557664;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lmunf8hKp3UcnRXrvQgVK828HP0WXdYhEtCShztRC04=;
        b=FmNCIcbs/AopGGcW6f+PH8kZ1niCvEnLsXDRUBLOfLDfo6iDUWm9CS2OXL33UwdECq
         fc2Hzq4Ebn09XVCj0P3VpBcJem/g6uYy4WgyCUfHW5462Vy6gSIeWqPlOpNhydgqWMhl
         4tZ5ub5E0gMfIf5UaVFtYKfZ63d2H3Qq1hv60x5ZjVTI1dXERbQLWfDAHD06uplTpd8a
         f9GRCRFVx+wqz+kSHJla7F45uGAbwPBbO+pKtw4nAyx56T4E8kw4FJy3sfHRS/dZUkQV
         3tJ7nu1jwM1YEGO8WDNvlvenF+YQGp8EPixnipa/ioRk1bxQ9z2b9PVVBBJIOSInlA0F
         orRA==
X-Gm-Message-State: AOJu0YzGuxfm54fhQll5aMEO5Dc83+iGAgaIPRg7nPpvgYDcWqcqVcz+
	CfS/R0h/A09R4E9wofj9JHBvqcDT7RVvnqpd+UynsNGqAOlhgjpLZ56xazUJvxwLmQ==
X-Gm-Gg: AeBDiesbhEO028YPs53Z7bmRRRt+w1A0luGqktP1Rhp9DnK0pwsUpLkDx4i0lx6rojo
	Vv+9V83mlms9C/e+DUdaOIJ/5NVfDofSdH6BbgDUkACpW6op/WT/ybxq22Oxxz9b2vUBTz6tNIJ
	LSjloX3dLFvulAQHbagb4Go8kufC+Ta0UI9GJdswHgmLz+5Hjjqa677I4IDzsoR2zuLOzkN4mbu
	EN/7v6aIhaH0QTJcqoqvANJYCTx7lHmQ+qOFD89k92g4EfCF5RLRxdL94GXdFq0bu9Lo14r3eUk
	rwFA1oer8Hb0h6VR3GAVaNNTVUqCMXWd80NQekP2lgRHusITuaQSd4pa1BtODRu4kJBoy4gVkT3
	U+duIB7K6yD5i4r7wqojzNge2v6AEudxeHofVaq3+H3D02TZ/9V4scIZVWqqANc5UPmzvvoBmPb
	2ZgwSfOj5NZdnjdkMD7ACqKX0H1GEZp1kuOMMhNQzFWHTGT5pSrfHi9YQnttVYumOjuggOgWk81
	QpiQJ95mQAB1EjSo9FeQGnFJMipJph3mo957x0Ry8RQMeCF5OVfGrC02hk7dpT8J8aGbUlI
X-Received: by 2002:a17:902:e785:b0:2a7:6c4e:5914 with SMTP id d9443c01a7336-2b2c79eaf87mr10814865ad.6.1775952863560;
        Sat, 11 Apr 2026 17:14:23 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:3927:c82:6a08:f01a] ([2a00:79e0:2eb0:8:3927:c82:6a08:f01a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4dd7faasm70316735ad.26.2026.04.11.17.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2026 17:14:22 -0700 (PDT)
Date: Sat, 11 Apr 2026 17:14:21 -0700 (PDT)
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
Subject: [Hypervisor Live Update] Notes from April 6, 2026
Message-ID: <82db97e1-791b-770a-ebea-0e364dbd08d7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: 1fg8fu33ooc9dm5jfehcnoj8p7bcad64
X-Rspamd-Queue-Id: 7FA304000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1775952865-29994
X-HE-Meta: U2FsdGVkX1+Zb2MhIMeUrqYQuEq/ksS24fyjJf9GfYJ3+PXmB2aTKVDP/QA97/oChKbhMDuZBXpMcjc7EH3OIE0dB4a4/8dogry0HPlvpV2RjNGPlhXFVEn37W4ucV+Ugl8hYChVs8/QnXEB8uZm1sH3sgk0yEXxRSeBkbC6qUvD0B7efb0pVyxpg6t9AsuPjR1FiHEYuPHpVXsvDYOP2fE7TyxGJsMZFctVBQjN6lvJWeL5b8gnfqayh7+xPSd8AHNdyESYSVtrzOEWZOIXuonNd4Yl794A/dptnD1/WyJElZmpttIGTy144WVqo0z7NbWrTNt+8Koh1h1+CfdVfe4x7IKE+555PzCsICukVx+LNOBSqZKb/Bg9/6JGZtnPA0YURdyDGnz5VNChcJKIjPv6am+cKptJ9IIbHqtgQ3HX4oTh373CMOeA4FbF4m99CPmMS2Aea4ZjpDqiFhMtGV9wUyj7EeoHlFv662AoE66vLlyaTtd8SclHoY3Zw2mpXS30MsXYwcRTYJe9g6xS+wqnJTbB3DBVtZnmnqGKg/Wof4exsatMqd2lQ501XxlaD48MI71DVpQz4rFEPwWy72fPPNRxmeoZ8jGHn22JnHzoycubEsujjrtTZHOp7UoxQKu3vp+meDnofQAbrRzK3g7L8cb/TQ0ffdZZ+ztKA0JUMq05hpynaOD2stDvLrPCn2lhzrwPA3rob+PiUoRiIem4HEPuOEeYPEmZt2UxB4UbfJFpZhni79PuxyX+ABXaf5wu5boBYf/R+k81NDHsDkuP/x7ByFefTmb4PV99FimYWm6AJKbmChkL/H8ZU/Eh9onopx9QmJE1BJ7xZ2JNgLL3/ImIlPfnJqQGR0OsJhNzMobcAlSw0OSZd2evMDlutB5LqTZwLEwQPvWBjUgvghyss436fS4IF2YWz4jZXy6B4WeSlnDKGcLH0kxWcHnj/tCwtRwgyJrLQk3Ty1C
 w8jVeGT1
 bxVElKvKzIYev0hS0Eo/oodAxtl3zARXu+SOXHui5d19cFe4xTgIj5YCwOctW8pXi4Sx6x5FigC7V24NTw/JpDy43dA1t/8H9OQXbBi7e1IxXM3YgGHWq/DcsbfUwf2KnBJDBWyxsCRVkopbapdcirA7y7V+yB/zSDG+KVreG8qhWsDy4jtEk08xtxY2ZBx+pxjHJComWmxk3lR0GCMqPxWXmyM8Nm01OThJrhSCQBkOvXkZYfpRta8ol272LovnL3OX6g80fU1SFuElCXL9PvLC4zlhbmbyAR4FS+A4WR2NaMb31Dbb8GDMKyW6Xx5j6f3/4mLC94N8sWkbZJDqRIaAjpsYKQwSwFNt8Dbm1rSGPynrM1J67N+sbtw0DFdsk6IOtyGFknXryY5MhAa/dQTBIdqkL66fn4zQRMLdJoj+9tn+vlgFi+bYe7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, April 6.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Pasha noted that discussions happened between Luca, Jork, and Pratyush for 
LUO integration into systemd.  Luca had written a first attempt at 
integration and it required some changes for LUO.  It was also discussed 
that unit files that start the VMMs will include the session name in the 
unit file itself so at shutdown, systemd will know the sessions that are 
created.  There was no update on the timeline for this work, however, the 
next step was to start discussions with other systemd maintainers.

There was no update on the status of boot time performance optimizations 
like deferred struct page initialization.

----->o-----
Pratyush had no updates for HugeTLB preservation after being out of 
office; he thinks that the memfd selftest series is close to landing 
upstream, however.  He also updated offline that KHO patches to lift the 
limit on the maximum preservation order from folios has been in the mm 
tree for a while and should ideally land in the next merge window.  This 
work is a prerequisite for the HugeTLB preservation extension.

Pratyush is also working on a fallback allocation strategy for KHO when 
scratch runs out.  When walking the preservation bit maps, the goal is to 
find a big gap to fulfill the allocation; he had an initial patch series 
that works and is still iterating on it internally.  This is also going to 
be a prerequisite for HugeTLB preservation.

I provided the link to the Linux MM Alignment Session that was had on 
these HugeTLB topics if people were interested in watching the video.  
Pasha noted that the biggest takeaway from that session was the CMA 
limitation and supporting early boot HVO because KHO requires a struct 
page for every page that is being preserved early in boot, and this turns 
out to be incompatible with HVO.  These would need to be resolved to be 
fully compatible with upstream support.

----->o-----
David Matlack updated on VFIO v3 which was getting feedback upstream 
especially on PCI.  v4 will split this series into two with David posting 
the first series (PCI) and Vipin Sharma posting the second series (VFIO 
and selftests).  This will allow for faster iteration.

Pasha asked if the PCI changes are likely to be able to stay within the 
PCI subsystem itself or will it have broader scope.  David did not think 
we would need to change anything in struct device.  Pasha asked about the 
scenario where a host driver needs to be preserved, David said this would 
still be the struct for PCI device on top of the struct device driver; he 
was optimistic we would be able to come up with changes in PCI core 
without becoming overly broad.  The group wanted to fork off a separate 
discussion on non-FD related PCI drivers and how to support them in a 
generic way.

----->o-----
Samiullah updated on the status of the IOMMU persistence patch series, he 
was planning on the next series to be posted over the next week or week 
and a half.

----->o-----
Ackerley also updated on the status of guest_memfd HugeTLB support and 
indicated he was still working on the conversion support.  He suggested 
there will be an update over the next two weeks and was targeting final 
reviews by the end of April.

Pasha asked about current limitations in Ackerley's series, what features 
are needed as follow-up after his work is going to be done.  Vishal noted 
that there may be some memory error handling that would need to be 
extended.  Other than that, it was targeting full parity with HugeTLB.  
Vishal noted that direct map removal was under discussion upstream to 
support CVM use cases.

----->o-----
Vishal noted that Sagi was starting to look at KHO support for CVMs.  
Vishal asked about KVM page tables and the memory donated to the TDX 
module and, in the future, will also be used for ARM CC.  He asked for 
example of preservation of kernel owned memory.  David Matlack noted that 
IOMMU preserves page tables so we could look at Samiullah's patches.  
Pasha noted that if memory is going to be preserved then it has to be 
pinned.  The consensus of the group was to get started with guest_memfd 
preservation and then to add support for CVM use cases on top of that.

----->o-----
Next meeting will be on Monday, April 20 at 8am PDT (UTC-7), everybody is
welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - systemd integration for LUO, socializing the design ideas with other
   systemd maintainers
 - any progress for KHO optimizations for boot time performance including
   initialization of memblock list and deferred struct page initialization
 - HugeTLB preservation support including selftests and fallback
   allocation strategy
 - VFIO v4 patch series status, separated between PCI and VFIO+selftests
 - IOMMU persistence patch series status
 - Maximillian: supporting CRIU with KHO by using memfd to store the
   state of a process, moving mmemory from a process to memfd
 - guest_memfd HugeTLB enlightenment: conversion support, HugeTLB support
   without restructuring, and HugeTLB support with restructuring
 - KHO support for Confidential VMs including page table preservation and
   pinning
 - later: versioning support for luod to negotiate
 - later: KHO enlightenment for ASI

Please let me know if you'd like to propose additional topics for
discussion, thank you!

