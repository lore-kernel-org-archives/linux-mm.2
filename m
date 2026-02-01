Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32FDDE7C6F6
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 02:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50AF46B0088; Sat, 31 Jan 2026 21:39:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8866B0089; Sat, 31 Jan 2026 21:39:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4766B008A; Sat, 31 Jan 2026 21:39:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A70D6B0088
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 21:39:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B313CD4A5F
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 02:39:37 +0000 (UTC)
X-FDA: 84394331994.02.22EE8A1
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 324E4140003
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 02:39:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Gkp5kVI4;
	spf=pass (imf26.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769913576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=f+oWmSGi3OnfcgGTsDgVrrdujfgV5/abaDUEB3zopaE=;
	b=EOzI1k4w+aGxVkZgXcQSlm+GbgNCTfi+Zb+px4dhd6gYsowVM7f3KTtUWQd1ZRmYnGP1wW
	HtIg+ipGomDWUThUu5z56nP7kc8Ry4BxhY7fiMfz5+A5TpqLiQFv0ofgTEXcQH3hQ4mgef
	Ss5dEiz/+iqhZYiEfcH65P0kNm2MmcE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Gkp5kVI4;
	spf=pass (imf26.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769913576; a=rsa-sha256;
	cv=none;
	b=t6lEwqaSjIz2EgPss5FrTHVw7OeQfG0dONXvV7QDcNjW7cZlAzSw/SdubSg8OQELLqfFp6
	5Hi7uj1EaoklKtzJ1+ty2RnGPRKbK91+brPu+GafXyd9InxubpPWDg1hR8wjHdUYSkMQYl
	BiVdhu7UPyWDiPgPpmz0q7Yr6HDH6kQ=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a1462573caso65715ad.0
        for <linux-mm@kvack.org>; Sat, 31 Jan 2026 18:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769913575; x=1770518375; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f+oWmSGi3OnfcgGTsDgVrrdujfgV5/abaDUEB3zopaE=;
        b=Gkp5kVI4zF5enlfx45ezgxDbrBywEAAD4zWPrCOxIH2lPh2yaRv1qQI6JhCPF/gkFG
         NFQdiWGKatzLulkXr/SZn9+n1+ncQHCpIRdEd6oTcR1XDx2Jq/jEyoY3HSCfoDxAl2tp
         LxgddcAZjnVWydKvPor/bWsXAlc3wy9Zr6+Cmc58fTDbQHDJUWUFBk2ErLwcdnQDcJ/I
         6FJqKFyYQXNnz5OIFd7MnfOqJIP8Yja66Lffry6IF+plKCzF8SSw/kMHB1NkUUFLjrZq
         /lWYlo3kLtp7mrqxKnmf1jiKPecJkTJv6MTnKjx3CpPb9yv4G/9R0UXdzEIpecw08HMd
         5V3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769913575; x=1770518375;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f+oWmSGi3OnfcgGTsDgVrrdujfgV5/abaDUEB3zopaE=;
        b=pKkSIy39dm+IyR7OrKiJuxnBbUjk37PSihWe8yihdCekZgc9Mo+lgXSantsMAC42kE
         dRwK65NPfjSGTE8VggJYDvS5CS+8C0CmcCWzutY77eZToZn51+RrDOgv32eNgXKt3GBa
         NmbTdI4xp0VbNjinM4vf2ZP6oPIxJrhYR6BYXRptOVGXUsOhoRtj4LjVeH2e2syvyW5m
         ZknItKE0T80ZHWKlSkzz8WhHkI6GKhfJBdd9ucQn4y5KkEDpA81zYm/+mv/hzs0Ufk84
         WrRBdGUWkiX6ZQLixcKQt9y7po8xV5JXJT9nSDxDfSBfIx5VnLxsTfKxWEzhsdjkrJNT
         3l6A==
X-Gm-Message-State: AOJu0YyJGbJJ/ANl/LJdW3WsYGoaIjYpCakC6suDdbCTT7cAm5NGLunR
	CJKyYvGkogtd3neXnziDvy4ziL2m7wmB5dGBXnkCuqi/zbhsFqISzcDYKXa0MAR7FQ==
X-Gm-Gg: AZuq6aK0y80HtdYSOi37Jxdlfwh6r7B+LdGLLWs86dWLFjwbCuzJi1z4ZHf+ntEQb8g
	ta3R/X+39LfY1z4GcHMp3lRhvWKkKDHeTyqcgtiuAA0lJFkPKSV/Uyjxr9F+pLO0AVoA2y5B4X9
	yO1kc5zBr8InjVsudjUnOTiBy64rHVrwuDVUHCdKmy2ndkzfkBhghjNaJXysiz43vKX1IQFOrFe
	nh3AjZnFT4d8tKFfo+O0c2WA6uvBH3Wx6+Knm3gdgrumAFHIYWxnhgiUsgq9AW5jRjdlscy0CFi
	ejR99C+Vqq0zaA6eIV8KhV3OXZLm+8gjJ9EIHOyqwqWOwu1mj5PBx2BeTO+fCIpSSej5GN2LjrW
	oEZFRs6T+yau2CV1VhWxj+18Vf4Ibn2MHPnFKbsGn//8unqUQ34ZGUeD5dfB6Ke82gR11o2N7XE
	8ph2ZBmtrwGWVXBdaztmr39p2vrxttAP6tjVKcnK9effEEvcJIgDmJZKH2GsMGSJzXkxhKuL8h0
	mQXi8fXNCiZozyB+PxOKCZbaYWJoRSHhaOOG25iUA==
X-Received: by 2002:a17:903:41c2:b0:291:6858:ee60 with SMTP id d9443c01a7336-2a8f303cd1dmr2763475ad.4.1769913574385;
        Sat, 31 Jan 2026 18:39:34 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:863b:f9a9:4fb1:e225] ([2a00:79e0:2eb0:8:863b:f9a9:4fb1:e225])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3543d52c396sm3585655a91.4.2026.01.31.18.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jan 2026 18:39:33 -0800 (PST)
Date: Sat, 31 Jan 2026 18:39:31 -0800 (PST)
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
Subject: [Hypervisor Live Update] Notes from January 26, 2026
Message-ID: <5f9a56f2-ee8a-0a7f-206e-fef46595c4d0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 324E4140003
X-Stat-Signature: 6c7ch8a439ryb7uxyn5698si7b3h5z9o
X-Rspam-User: 
X-HE-Tag: 1769913575-147425
X-HE-Meta: U2FsdGVkX19A8NabSqUibC8R/q0yopyR/+6PlQCecnRV+LqitlxZGlghbg0FBsVqhmc+bF2H9guBjliRHscES7jXKQxGDev6XiMvQ8G5Gmi0xdr7+FjOqkxtuZ2ING5Ejs7+vyxetOC9J5wYKJ1Q4SWnbceJI9Njnbn6OF1bVDqBeN9877hgEPWDTiLnPxOZIqJ+mvkK0Ru8rc1JeHmltZhP94D8bxDRghha29CywRsZYNbPFw475EvdIYZgehSOzK7TvJ8fh97U6jEFEiOKPD0j0yEVV16LvhfzDLTh5QyOugPBWGK07Vjy8Igq1dRQCYTAKfJswDaThIADoKEiBcnA7sd59sQbmIEx4mqJLtfu7eaz88x05Y29Kh83cUrf7T6OhXcGfvGSyuSsK79IP/5scychCDXxj+uR7elZlSr/O5lHdEssig26DlfcxgXE2/XVX8EfovC1V5Oo1Zw83yFZ2N03tQu/hnwS4rd2CmqPWLrZYAXcsGQ+k5AylCAUiQs/AixRqoCZ1bLQHIZvjAFwnHdyK5JOvHKOanzlyeMNDGs5J9r4/FMnfH2z/XofSsuFSu1dmSjIVPNdJ5fpS49Tr1ZfrD6sWHISS3HRNQZAEWNbyCHc7BJ4MqXjD1rN32hCBihvPyl5xXRTK5Bt7O4+xJDMbrZoecnKb6CLQl5qdp3F1f36BU7jHII6yjR5Nr8lyPOddJ++172OrE6zZ8toek1ZowmQVRHWA660DS+XomYBAb8q0Owo6wejMFQW6Gw8JWbA5oHjo4DhfRcBNOj5i48Vf990UGFrYYQ0G4QERpJb5a2xZxdL5yU1mXUDjj7x0EDTsjhJcltKCNMgsbviA7PH3Wofy5LF9MkN2qHYZQur+lbPV1y8vwoyRiK329L6Cr9qa0FJZK8OdKq7UMgDFQzF/9avnHBG5dYXTgUdjLiTJfbR9z8+0e9LMbUdhZfbC0H+SmS0SrAn4XW
 tgiYJ57k
 H/gAnR+M9u1SUajRbCRqBpE2jPSYSyORbcNybM8MbtBkU8v3e1YHGR0xWa/Tu5DRLqvRJM+BDwW3ue8kXBNdQSqJGn8HPvar/dN4qTs274RG2nkQdN6sXo6pdn+B59R4aLMIYuUae5eDuvdBrptyr9lmNwQuGriC8o079UnTJgYiesX54bk3smTa/zqxkDtmZ76JG+PHwRD11ZySKJwDZRavJH+wn3MT8aVmhh0cR5TnkXliGoqe5v8E0+uZG1DngM4/UVWGcsJVKP2KKpONBNyyUws+8ij+gQ2Hxvtfh7RKlkDU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, January 26.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
This was a lengthy meeting with lots of discussion on various topics.  
There were a few quick updates to kick us off.

Pasha updated on the status of stateless KHO: Mike approved of the latest 
changes from Jason Miu and a refresh was on the way as long as there were 
no more comments.  It should then be on track for inclusion in mm-new.  
More review will be possible even after that.

David Matlack updated on ordering issues when disabling interrupts during 
live update, he is working with NV GPU team.  They have a subject matter 
expert who is looking into the issue and will update David next week.  
This should not delay future VFIO and IOMMU patch series, the changes for 
interrupts would be incremental on top of those series. 

Pasha updated on the status of luod: there were no major changes since the 
last meeting but Pasha was still looking for feedback on the design[1].

David then updated on VFIO v2 based on previous comments and was looking 
to post an update this week.  This includes documentation for device 
preservation and then extended for iommu in the future.  He's also getting 
rid of the patch that does auto-probing.  He's also reworking the PCI FLB 
to not be accessed after devices are initialized.

----->o-----
Samiullah continues to work on iommu persistence, he was looking at 
Pratyush's series on memfd seal preservation so that will be integrated.  
The next series should be sent out in the next week.  He also discussed 
hitless replacement for iommu domains; he had connected with Baolu 
upstream and received feedback from Jason.  Baolu will be reworking his 
series and then posting a new series upstream based on that.

Jason noted some differences that will need to be done for hitless 
long-term to support ARM.  Sami noted that he'll have to look into that 
and discuss with Will.  Jason suggested using a temporary VM ID.

----->o-----
Pratyush updated on HugeTLB preservation RFC and then presented this at 
LPC.  Feedback has surfaced no specific concerns.  He'll continue to work 
on this over the next couple weeks including tests.  I asked if this was 
being reviewed by anybody outside of this group; Mike Rapoport noted there 
wasn't any feedback from core hugetlb reviewers yet.  This should be in 
good shape within the next month or so.

He also updated on versioning.  During LPC, it was clear that the full 
support is not yet ready to go.  The luo agent would read the vmlinux of 
both kernels before performing the load and then can look at a special 
section where all the versions of the different file handlers are listed.  
Unless you support multiple versions, you can never roll out a new version 
in the fleet, the next step will be to figure out how to do this.  
Pratyush was leaning toward his suggestion for version negotiation.

Jason suggested writing out all the versions.  Pratyush said there may be 
a conflict but also was curious about how that would scale.  Jason 
suggested there should actually only be two; this should be considered as 
an escape hatch and shouldn't be overcomplicated or with new UAPIs.  
Writing all versions sounds like a useful starting point.  Pasha said that 
adding a new UAPI could also be done later.

----->o-----
Pasha brought up topics for LSF/MM/BPF that is coming up in May.  Beyond 
HugeTLB preservation, he was wondering if there were additional topics to 
discuss there.  Another possibility is guest_memfd support for HugeTLB.  
Pasha suggested KHO may also be in scope.  Struct page initialization may 
be another topic to consider.

----->o-----
Stanislav Kinsburskii noted that he sent an RFC out for blocking kexec in 
the kernel.  He said Microsoft needs this ability when the kernel deposits 
pages into the hypervisor and we want to make sure that if guests are 
running or pages are deposited before we have proper support for these 
features, we want to block the kexec.  Otherwise, the new kernel would 
become inconsistent and can't access pages that were deposited.  He asked 
for any feedback on the list.

Pasha suggested to use fd preservation for this instead.  Stanislav noted 
that the kexec syscall does not shut down userspace so even if an fd is 
exposed to a userspace process, the kernel consistency depends on a 
userspace process to do an ioctl to keep an fd and if kexec does not shut 
down userspace processes then there is still a way to get kernel 
inconsistency.  He suggested that this may not be a reliable way forward.

Stanislav said with proper integration, we have a file descriptor and if 
userspace closes this fd before the kexec, things are consistent.  We can 
have a guest running and pages deposited into the hypervisor and then 
somebody can do a kexec.  The expectation is that the new kernel boots and 
that it is reliable; this is not the case with their hypervisor as the 
memory can be leaked.  This is different where the VMs are KVM VMs and 
userspace processes.  The suggestion was to have a hook to block kexec to 
support other approaches.

Pasha noted that if you have preserved the memory and the state then this 
is no longer a normal kexec, it's a live update.  Stanislav asked if this 
is the one procedure that can ensure consistency across the live update, 
if one does not do this exact procedure then they shouldn't rely on 
consistency after kexec.  Pasha said that with LUO if userspace preserves 
fds then those fds are going to be preserved across the live update; if 
the session is not closed before the live update, then those fds are going 
to be preserved.

----->o-----
Next meeting will be on Monday, February 9 at 8am PST (UTC-8), everybody
is welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - latest stateless KHO patches and inclusion in mm-new
 - ordering issues when disabling interrupts based on feedback from NV
 - luod design feedback and implementation next steps
 - VFIO patch series that would be incremental on top of the previous
   version
 - IOMMU persistence patch series
 - hitless replacement for iommu domains and series from Baolu
 - HugeTLB preservation support
 - versioning for luod to negotiate
 - live update related topics to propose for LSF/MM/BPF 2026 (hugetlb,
   KHO, deferred struct page initialization)
 - later: update on PCI preservation series and next steps
 - later: guest_memfd support for 1GB HugeTLB pages
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update, including deferred
   struct page initialization

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] https://tinyurl.com/luoddesign

