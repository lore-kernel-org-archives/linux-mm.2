Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3467CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 23:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C39C8E0020; Sat,  1 Nov 2025 19:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674318E0015; Sat,  1 Nov 2025 19:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53BF68E0020; Sat,  1 Nov 2025 19:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2DA8E0015
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 19:35:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD6978901E
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 23:35:12 +0000 (UTC)
X-FDA: 84063646464.02.2538FCC
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id ED821140002
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 23:35:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UZQTEOzM;
	spf=pass (imf26.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762040111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9/E0WGv1nNLr0QHf8SUrmzyKi+YvfP6z/hFCykkZxzY=;
	b=noT33VZZKsreJ0f/Tl8/2hPxM3QFK6oAuq/GbKgh1NX4atQVvaDK63AXQN4ZsHCDel10/X
	T/jAYc7SASvD7ZGiZlw7LvaQvXe5aRYcOV5O+zGVzWn88MjcXOfDQw1H3txTQg22kWsTdw
	VPjZGAjx5Jrxle3phZEH3UzjTB1B59M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UZQTEOzM;
	spf=pass (imf26.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762040111; a=rsa-sha256;
	cv=none;
	b=hWfW1SSPExvpjCx11BXP5sWmAqRmm3zOQBaBFP9YaK9PgVFJeYtBH3ICZjaS6Q/64rohl8
	1t+FAEuzf0X+tECOUyizsTnGjVFmWIwn91K8RaNFVLqqBhYst93XFy6/mu8HH353bVoQy+
	k7GmgIw0xY/ZR1sZGM7FXOXBEA1hsxc=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-27eeafd4882so233395ad.0
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 16:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762040110; x=1762644910; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9/E0WGv1nNLr0QHf8SUrmzyKi+YvfP6z/hFCykkZxzY=;
        b=UZQTEOzMiKXRC/M+skob4JzDOMnzf30J+Sqij4wqs8zMKnV591CkxxOKKT7UnhGyW9
         RAjLSeApXdixAlcsQfcFIk7rW+JlKeB0lgX8YLnBez41ocZJHd6iqsZ3ngAi1g/B8Spt
         awQJs8GBeYRyorvLwIwsbjy+woLri1qYEM9+I07fF3l1KUcjWuAtlWQBtS8Ujg/Vx+gz
         XxyBcqyeHhF9FlgyYx/FJxtvimIFNLuDUYQy6EpYLDZrP/uL+TzIK5lSzrswcpJDqAze
         BCQl/XKU1OISwN36TtXM7F2Gnr1K3kKFDCFenWwZTSEUP4cWnvsw6sLIwax0XH8gAY08
         XELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762040110; x=1762644910;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9/E0WGv1nNLr0QHf8SUrmzyKi+YvfP6z/hFCykkZxzY=;
        b=m8Vnxac+HsrAmRHyqyciQTLuf94z3GwzjfKolnt/L/kUvIeL8XdreI80X6I58vCUj0
         Rcvt2bkb2lHuGLmyy6EO6Ibg3lWRHwepKG1yIfQL+3McpZmlgdBsnxeto3XDIA8jOUMe
         rmDNuS3faHGvx9c9U+7gZo3ToeEjPlO+dK7/BC/AyHAq0DJhqqmG1pJE1YlsLwQd1HXL
         yFW6fx/Rq3bHudK4ml92o4FcWP26C8q/u+XYxLVQI9khfQLTcYbQL/n1o3ArBip1zdyM
         t6k2iz29YC+Im2W6Vj33MIisxW2JwvibjWdcOfPsz4CTUdNCzG82MzKFXSyL0RVZfGi/
         y8mA==
X-Gm-Message-State: AOJu0YzIoMX/fq6TiodN3Wmmhumj2aNRsCNFlNEiOVNAhkxA7TPgU7RL
	B3pT/GvTlJ0l7Ba34B2P32Bl9CEDcZTx7xpYfugTquOclwBn7OOrLETNSaiW9SLEDQ==
X-Gm-Gg: ASbGnctxbtlsl6GaCYndotfxdLikcHuBPCjYozSI9OALo/mjiAt2ThkLQU5v/SeLB0w
	Um4sAm7xVPZQ8V4gNs7eeD5UFx25lWd/3SS20aM5gdinEtNKl/QAyRGkuO/d1dyLbW4Qey7ZUPo
	WTyQ1RlE9cUQJmASNYGhiIHUPb39C/jExfd8oQIfKFmqTXr03lXiqAUwHsTj+GdXgTmJV8wLbih
	1Z5vOzTwXecpQ3gkzaqso2Ub5yyzQqIShkQVUQLNW6ZEtGhdTQ8xa0mH+nJNTcH3N8Dled0QlrL
	SPCv32wXnUx+x6BcvsqNeiHv1l+5QqmTdLbTTVWUCGuiaDf2zepccYDQ4MwbzPODspxo2e0RsNR
	fHyc+Of+h6iUxUZo6UtMo/lKLJkQlX7qhccEdtY6a50OTMkxhNKksSM1f5mnrCXRbL8ecn/DDl9
	JFyBED+H12YRM6CzekKlwGDnK3hFcbOxk0qOCw7peufOnXk3dyPreTQPQs8oxMUJ0T2nlSpNc/2
	05Nx94ycrqGm9eVZnVLQLLNUyXrg3Gc2xWZ1xGUlA==
X-Google-Smtp-Source: AGHT+IEgMLSpidpLn4EmEnPXsZydRPUhGLJ3IE7xOOEurckkpUMnihEKZNkc9Lqt1xK89NmR2Gl9NQ==
X-Received: by 2002:a17:902:ec8e:b0:274:1a09:9553 with SMTP id d9443c01a7336-29554bb5d5cmr4197895ad.6.1762040108930;
        Sat, 01 Nov 2025 16:35:08 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:61f6:625a:7108:5b62] ([2a00:79e0:2eb0:8:61f6:625a:7108:5b62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a7d8982117sm6245553b3a.15.2025.11.01.16.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 16:35:08 -0700 (PDT)
Date: Sat, 1 Nov 2025 16:35:07 -0700 (PDT)
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
Subject: [Hypervisor Live Update] Notes from October 20, 2025
Message-ID: <734e26d2-ac5f-47be-331c-40e9b535ce55@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 3fwrbhg1x17haq4h5bnu1owqjyqt4nue
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ED821140002
X-HE-Tag: 1762040110-677309
X-HE-Meta: U2FsdGVkX18sSBjzWRaQKoRfjG+JGPs7IcDIdGMW+z4TabBv/nf/BoU6HyK62E9n3tNRW5FT88pL7UooTwUfW6MikjuUu9+5FmXdiFMHZ9QGLoJ1m3+XnK2aqE17pA679CGbvsVn2QTBwc3v8cM9tvU548jJjnxSmc3LA2aP6wTWVCk8e+cuJIrhMD3GxsAAFrIMvJ/yEUJifyfEE7cFMOeZ8+6al7/ncTVPaKmp3OoksKM67Aws7SBjDoM4ZtJ8D9LqJb7hn2SQpIIAQ40azdXSpJpJOcbdxzUUtsA/u8i9vrOMZBTwVZXJSQatepqZ+DSH80ghfrBluSrJt1ZBQ/Ya6/w97i7R5ucilLyPOmFtx2LQksw3MdxBcg0Xg6lluJT+lUwJ1Q7Die6bPsDlJqeYvEw0+/l61bJ2GfeCAltn8UvI1VWkhUMhpo7SW+VBkDX1JCv5+ALw/ecNGiQtE8z/bR18nMLq541naL/Px65tBYB4nBP2+FYx9dRvOVOLklc667NuJXnCV+bKWbz3eB3VlE3Qzm2YGobt5d1g7tEGSGiaLRXQBDsG5KHswmJW9BVhz73Bo8crqsopzEIPPW5+BkJQXCVD7nvJA3sB+VXgbIYtQZRn3py2Cd4DA6+MWcjZqUsHfZ8LOONNoLRAsZ0M0dkn+fJZgJ4rGcqr9Q8i8jS8ln0sT+J7Mkqwuc1mNZkq+5XrnGIQsCGEiHBJnOSmqJBCJ4UhEcm6SQI8Y+FnR2OUR3YiO2pk9DT3VWWRvHTaX5tPkFPlHwpBAtIWLL4vgYhyVDdc6Gt4tn5vMlZbnFolzYSk1A3B9Xd9pkxFuVA+KfwXC9BftrkesNkl5Pu90j/uHGUT5fsqnLY0k7i0GTCInOCa1pWflI6cI0W5JEUQPkMpi4xz+W3q1XtwxCeOYc3ZDwnVEQhuY26Gt30W6OKV6LfxdAHWtyCInRmksGWz8Il9mM0XCVtF5Xn
 Mb67rkY+
 xRKXMAJh9xcL9XQ7kxbY/WbWgQpli9RdISCxpz5GGx1ckbv2LOS9ydwxwqRyePaNht4oYtgX0RdKucATRmM63qIUeCt4GOwxfiy0WlUKufGdpSnyLnkhWZoicEagNF+ypighoVyo1J6dhDqQcCE/l/hJgskt39FhX5weE6Yl1htHunSvbEb7+qmyI+gt88Bnooh8u88/VyVmuEOa1v70pl0u9fqyu3uRudR/niHEr3s+pu3Wa8TqSpSTRyGqKGpf3GqR3rwUdTb42tWf+7IItUyYau+vNppyu/dewrFooPghvS2TeYeBpO4gBcMu976IkUjpBMyWuuZzwen7CF2SjGNseF3b/5Q75QE7tcVFopVYPXPqRRWP/Ig6a3n2iN3MzLITngH4abgmAXSd6x2GzxW7oqQmeOeVkHG80VxOvHy6msm3jVqSfsohR4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, October 20.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
I thought this instance of the meeting would be short and I turned out to 
be very wrong :)

We touched on the discussion from the previous instance regarding the fd 
dependency checking and this happening at the time of preserve rather than 
prepare, Pasha noted that the discussion continued upstream afterwards on 
the mailing list.  The biggest change would be that the order is going to 
be enforced by the user.  The preserve function itself is the heavy 
lifting now; the freeze and prepare are more for sanity checking.

David Matlack asked how the global states wuld work since that's outside 
the fd.  Pasha said the subsystem will be there but there will be another 
mechanism that follows the lifecycle of fds of a specific type; example is 
if a session has an fd of a specific type then it will follow the 
lifecycle of the aggregate.  This will be supported in v5. 

----->o-----
Pasha updated that he had sent the KHO patches that provide the groundwork 
for LUO.  Last week he also sent a KHO memory corruption fix.  Once those 
patches are merged, he will send LUO v5.  He was targeting sending the 
next series of changes before the next biweekly sync.

----->o-----
Vipin Sharma sent out RFC patches for VFIO and was looking for feedback 
from the group in the next instance of the meeting.  Jason was providing 
feedback on the upstream mailing list already.

----->o-----
We shifted to discussing the main topic of the day which was iommu 
persistence from Samiullah.  His slides are available on the shared drive.

There was general alignment with what should be included in the next 
series upstream.  His demonstrator so far included iommufd, iommu core, 
and iommu driver patches but was just preserving root tables.  He also 
proposed hot swap.  There was lots of discussion upstream around selection 
of HWPT to be preserved, preserved HWPT and iommu domain lifecycle, fd 
dependencies, and LUO finish.

Pasha noted that LUO finish can now fail which Jason asked about.  Pasha 
said if the fd hasn't replaced the hardware page table then finish would 
have to fail.

Sami noted that the HWPTs are also restored and associated with the 
preserved iommu domains and this would be done when the fd is retrieved.  
We can't restore the domain during the probe but there is no mechanism to 
have the HWPTs to be created during the boot time.  Jason said during 
probe time you put the domains back with placeholders so the iommu core 
has some understanding what the translation is.

----->o-----
During the discussion for hotswap, Sami noted that once all the preserved 
devices have their iommu domains hot swapped, we can destroy the restored 
iommu domains that are not being used.  Jason said that once the iommu 
domains are rehydrated back into an fd that they should have the normal 
lifecycle of a hardware page table in an fd.  So they will be destroyed 
when the hardware page table is destroyed when the fd closes it or the VMM 
asks it to be destroyed.  Jason noted that the VMM needs the id so that it 
can be destroyed.

Jason suggested restoring the hardware page table pointers inside the 
devices that represent the currently attached hardware page table and this 
is done when you bring back the iommufd.  We should likely retain a list 
for each hardware page table the list of which VFIO device objects are 
linked to it and this all needs to be brought back.  Or an alternative may 
be to serialize the devices.  IOMMU needs the VFIO devices and this needs 
careful orchestration.

Pasha suggested that since we have the session and sessions have specific 
orders, the things without any dependencies that were preserved first and 
things with dependencies were preserved last.  The kernel could call 
restore on everything from lowest to highest.  Jason said there needs to 
be a two step process: the struct file needs to be brought back before you 
fill it.  VFIO needs the iommufd to be filled before it can auto bind 
before it can complete its restoration.

Sami suggested if we don't restore the HWPT until we have all the 
information, even if it closes it goes back to the state that it was in 
and we would consider the iommufd not fully restored until it is.  Jason 
suggested that would require adding an iommufd ioctl to restore individual 
sub objects: restoring a HWPT that was with this tag and give back the id; 
the restore would only be possible if the VFIO devices are already present 
inside the iommufd.

----->o-----
When discussing LUO finish, Pasha suggested we need a way to discard a 
session if it hasn't been reclaimed or there are exceptions.  If the VM 
never is restored then we will have lingering session that need to be 
somehow discarded.  Jason suggested all objects are brought back to 
userspace before you can encounter an error.  If there are problems up to 
that point, then the cleanest way to address this is with another kexec.

Jason stressed the need for another kexec as a big hammer to be able to do 
recovery and cleanup.  For example, if there are 10 VMs and one did not 
restore, do another live update to clean up the lingering VM.

----->o-----
Next meeting will be on Monday, November 3 at 8am PST (UTC-8), everybody
is welcome: https://meet.google.com/rjn-dmzu-hgq

NOTE!!!  Daylight Savings Time has ended in the United States, so please
check your local time carefully:

Time zones

PST (UTC-8)             8:00am
MST (UTC-7)             9:00am
CST (UTC-6)             10:00am
EST (UTC-5)             11:00am
Rio de Janeiro (UTC-3)  1:00pm
London (UTC)            4:00pm
Berlin (UTC+1)          5:00pm
Moscow (UTC+3)          7:00pm
Dubai (UTC+4)           8:00pm
Mumbai (UTC+5:30)       9:30pm
Singapore (UTC+8)       12:00am Tuesday
Beijing (UTC+8)         12:00am Tuesday
Tokyo (UTC+9)           1:00am Tuesday
Sydney (UTC+11)         3:00am Tuesday
Auckland (UTC+13)       5:00am Tuesday

Topics for the next meeting:

 - update on the status of stateless KHO RFC patches that should simplify
   LUO support
 - update on LUO v5 and patch series sent upstream after KHO changes and
   fixes are staged
 - VFIO RFC patch feedback based on the series sent to the mailing list a
   couple weeks ago
 - follow up on the status of iommu persistence and any addtional
   discussion from last time
 - update on memfd preservation, vmalloc support, and 1GB limitation 
 - discuss deferred struct page initialization and deferring when KHO is
   enabled
 - discuss guest_memfd preservation use cases for Confidential Computing
   and any current work happening on it, including overlap with memfd
   preservation being worked on by Pratyush
   + discuss any use cases for Confidential Computing where folios may
     need to be split after being marked as preserved during brown out
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update

Please let me know if you'd like to propose additional topics for
discussion, thank you!

