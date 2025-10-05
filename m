Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2103CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 04:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 895888E0003; Sun,  5 Oct 2025 00:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846E28E0002; Sun,  5 Oct 2025 00:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734C88E0003; Sun,  5 Oct 2025 00:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 595AA8E0002
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 00:49:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0F5086301
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 04:49:38 +0000 (UTC)
X-FDA: 83962832436.18.0EB392B
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2AB3A1C0007
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 04:49:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=j9nwXLqR;
	spf=pass (imf18.hostedemail.com: domain of rientjes@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759639777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YtRjel1HG5STXuZLFeW7ky9+MooC7qPIEizO0OKUdcE=;
	b=2bvEBEcdcaZTfcv/d3Yrd3cWL02zlpY12QhfakYYiViHpPK9MVBYK/fJOGhpQkm7ytfO0x
	13AtzzxCLJNziAA5g4IgQc4rVpVATNG5tGoKOaeoAB9aIe1oMnYvDu4Whc24UYO5sEh/1g
	okATjAhUJ/ppz/CLWuuxET5AWStuiYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759639777; a=rsa-sha256;
	cv=none;
	b=gcLSaD6rWHTM7L+keAHOYtvCPi6IIhhDaKoAM8WWcMka+hGZHL1/o1rSjZmimqhbPzMt1N
	djado0V/ganofjRjx+lWbN1VfXzPGGl0z7VivydcnCExB4nZ95ztJPVJD09iOH2B42OyLs
	g1J0nn0skDygWcI3qWfVJ6rHYVF5s48=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=j9nwXLqR;
	spf=pass (imf18.hostedemail.com: domain of rientjes@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2731ff54949so156185ad.1
        for <linux-mm@kvack.org>; Sat, 04 Oct 2025 21:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759639776; x=1760244576; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YtRjel1HG5STXuZLFeW7ky9+MooC7qPIEizO0OKUdcE=;
        b=j9nwXLqRj6ARHhTJ3lbWzAYPBbD6n9mKvOdsVB8PRdDRw/Q5Sqx/RBkrrUZITECesO
         KA0hx8h9AsZdiuBO/ui2tuiYNC4aDyGYn6IAdOTeImwnLtYup0iOuI+Rq3pcKX1JVfel
         aPoPckamAOkUmpw1ldopB4UueMXbYXrZKIhF2TjfDQRuIurLzH9GdsAcmf6YxSjENjIq
         M+kT4bzaZif9VbqBJZ9eEUCTZrb8BKxV146SauwYrfiYk4DcOP6ViPFas6mlAFlfv3Hp
         1tkdWsWhFiu2tzEIHyiUOyGQ9J6C8fTAiUj8d9B1SOhJwX0lijKRlgWMwdKcRzhKgH9K
         +7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759639776; x=1760244576;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YtRjel1HG5STXuZLFeW7ky9+MooC7qPIEizO0OKUdcE=;
        b=A8cpWyyWJYZr5VL7BV7hkbqBCSpeXHN75jFUlG0RbuU33/CR7KzD9JD6Ws/oiXa8u5
         j26Oe+LHy+pDCtOdlVJiYfx2ht5FWAdnrTzPhn9roVU3zFgBvSvXiSfb8YUqS322dNI1
         KBQWCVg99zfNDS2JxE/EowVwLTszFnn4x6H323gKtMJXCHBzsmUjmAPlYtq2qck3A23g
         H6s2ctRUb/9j+Yv2CsAwdPwUSAqC2bNJfC7MAHSwOGuP86LIhQI1Xwkhu+ELiJE32B9D
         OxpEW6EHHBGWZzRq+WWm8uNcgwk34wEstp6MxzwtGYkVEgAOOYlfDnId8w5D6nVVCwMo
         Hcsg==
X-Gm-Message-State: AOJu0YzhXVw7U5QKVlblVMJz1SoKe5DzYVd6SrsmwyP7tYbFYSUFssWB
	Np23ORoQCFwcPzIe7Z6XI/cjuI4JngvNnCUFN1L5+X8L0D2JDJ+oW8ocaugyL6y57g==
X-Gm-Gg: ASbGnctOehbbrJ5q3idYanBYr9DLt88uqlrOeNGznZu4OGkFTzBnkin5XUnAoJ3Gt3Y
	h8++C0lXjMM0cz9xdzKg0sasl4ErygL6mE0R3s4xLwCLHNvo6HQ7cMnp1atvtBndFSNIsyADBIx
	4cz9j2GpDDWg1Tc+vyp9uthjhzHftRty/DAHZuznxj4ZMtXzPlMEiDauk/xOrJFRqNKOsSO79mK
	4JMfKgO/7Y8d3E58Ch4BqUsZWQZnOvaoR7bJsWa1A+y0joW7R1RU8T5lON/GrqXatnUZk7unz77
	RAcqK/PSVv0+gCPaPXOkHx/vuJp5dOzPypN8cucmebCl03G4FE/vx6oW/OvOBxsDdGBxo7v8Rg8
	p8CMbrvwJb3baxQVGNwHpkklDnOpG5YYad0eMgVlW63lBvjjy43fQ0ELvwogbZs5YStQOmpDzMP
	f0LFA30Lc48Yth6g9V32FdTQz51KRrAZ+FyzvslTKcdgQBzk0tVxzWpu8hl2qu6N3OILoliFoWk
	qjNo9Cbd2YlvdQGNc6RE9cf/75R
X-Google-Smtp-Source: AGHT+IGl2dZ4bBXbAE3dltXggDm/JaFJh+YfPTUIUtiSp316mGfJLHul8RCceskvrrqOdr7ugKUMyQ==
X-Received: by 2002:a17:902:e550:b0:27e:e96a:4c6 with SMTP id d9443c01a7336-28ea7ec09dbmr3993895ad.2.1759639774950;
        Sat, 04 Oct 2025 21:49:34 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:2b1a:83b3:ba8a:7851] ([2a00:79e0:2eb0:8:2b1a:83b3:ba8a:7851])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d11191bsm93535125ad.11.2025.10.04.21.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Oct 2025 21:49:34 -0700 (PDT)
Date: Sat, 4 Oct 2025 21:49:33 -0700 (PDT)
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
Subject: [Hypervisor Live Update] Notes from September 22, 2025
Message-ID: <365acb25-4b25-86a2-10b0-1df98703e287@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2AB3A1C0007
X-Stat-Signature: 5irzyp5iqbjnpj4r3oc3ct9j4bocf9rb
X-Rspam-User: 
X-HE-Tag: 1759639776-567423
X-HE-Meta: U2FsdGVkX18fuoprY4QN4+AuMURwPmnuWwI7b5ri+6P2W47FAbBBQyhK9y2FLyKLyAa4gfxC9yoHTUF5wvtSu8jUOjXIy1v0OFo37nsjLOOUiRxh/tQ5hHlRy7hzETgOq634T3Zpn1a2xL8kXIDBKArK6XlE43pgSL0f8RbCjF32tYQsTKHM6K8NwYr9iQIPxL8263PAnXfH/wqfVWJNazy5QMYjgR7IKDOTZusEEjjfsXjCUWfOYT/JEbZ20sphQy+/t8KMvWuLP5TvZvtw1+JNxEkZjJU+yKsQTQFg02yr7B3ZPKNjhJk4vgv+Vyke6gyMKQId6m0lehvCl42tQ2Ns8DePBE1pGeZVPPEtEIDPh5d0/XwTfAVzFOnTE3z8D644rt1XGy2+ytN6l0Mp92mmyz3GFDVfgX1LXSDTelZld/5jsVW66ZIOVrFz9nTt6HpxDD74dJWkZehvM8bNc0zbYm/Sunu7u0QOC9ALuahvZoTvy7biXU8tLEM4jQRhwoU/3edfQdnURvSZPIoI4CxbdcmbCYsf7o0wdcZ14k27/c6NqZBJzUEHC546BcFC0Wy9+sHpCCqCFvRR6Y2pRIXaL0y0FfWX3VXeE2mmWiZE7tq84ITMpoLA+5lE5M5V9OhybkpjlaJu9gtIQYIq/+pmASaA7zUkO3x4zIERNiKHo9yZh6ISpkFAzzCL8aSaCmi6nQA0usAo6seE/Retro1B4PNXLxBDGMo4MvY1wht2io/eS25rqaXBpzUsD25CpA+3zryAClriwWKXFSsUer6Q7r7YgWwMdsxwzV3tYUsdkadHqigX/nySLpV4Js6A6uoGvSYqmU3r8IorELFLcTVpVkveGsmiSmXj+ckoxGyPEIv2hoy5usTKBzpjPFcTF9g6A4zbIIRFSzt3A7bg2eZVN2/UmskDTR/46kCwJLq6dG38odQSfPNI+DDLMNDXbqdpZ2dFWAVBj3PAT7W
 ldYnOO4r
 bioc++RoeCfsofTO3i/g71oufJ1Y70HeQ/kIZNHeOz6Js6IrtZ1ZrSBbJDQA3rlty54281HjXkHgZgjLKhFS8ffaGZ/G8B3gYD4KcX4a4ruZ0V3J/DwdEmanhz2uY6TpWsOIWaboJnJx4jPQ0j9Qz1rZZFm8hnkGqQKsMOGzVQ/FNr9B6zoiCUn+xxGC8ejPSR0eIbZMJC7+ARUWQ3ZVRwUsbAhp5gscmWNiJ6XXLSfth1KTBZMHlbZnJIOvS5+Z3QGhurl//3OOavdkJ0Tak1BjDPR5lrodJvLt3rSOZlRrh2F0M9oHoIdRojJ9+xCv8AVQFD8x8zlGSIy9+IiFwivFwYbZ8AkZ4K0rz/YQUeTrMp1S0rHYSOwZlQhIyR7nV9PdL/iqPOmfLE3INdEGsvHN7PMtUNyLlKrsL/+dLXUPMj3Xbv9SnaXICZfPm2DMmoDeURAKjy+gLp764dZMNoqwF+vYSQwYwZkYV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, September 22.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Pasha updated LUO v4 by syncing with linux-next and was going over all 
feedback.  The session support had been added and he planned on sending 
the next series over the next couple days.  No major changes other than 
the session support.  There was a lot of discussion about versioning but 
that will not be included in the next series.

There were no major updates on luod, the design doc continued to be 
receiving feedback.  We planned on sending this to the googleprodkernel 
GitHub when ready[1].

----->o-----
We discussed memfd preservation and the 1GB limitation.  Pratyush noted 
that he had worked through all feedback based on v5.  The next version 
will still have the 1GB limitation and we're waiting for Mike's series 
before addressing that.  Once we have the vmalloc support, this will be 
more straightforward.

Pratyush noted that the next steps for memfd preservation would be sparse 
memfds and hugepages.  He suggested that guest_memfd may be simpler as an 
extension.  Pasha noted that HugeTLB support would actually be harder.

Vmalloc support should make it into the next merge window and then memfd 
support can avoid the 1GB limitation, so it may be possible for the next 
merge window to lift the 1GB limitation and include sparse memfd support.

----->o-----
Chris discussed preservation of memory with split folios and the error 
path.  If a folio is preserved and then it is split, the preservation 
needs to be undone before preserving it again.  Pasha said that this 
simply could not happen because KHO memory is not migratable.  Jason noted 
that memfd would have to prevent any split, including in cases of page 
fault with pinning.

Pratyush noted that we may want to add some debugging assertions to ensure 
all KHO memory is pinned, cannot be migrated, and the folio cannot be 
split.

Vishal noted for Confidential Computing that folios are sometimes split to 
handle the sharing of pages, the conversion of shared <-> private guest 
memory.  Since the guest can ask for this conversion during brown out, 
we'll need to ensure that this can't happen.

----->o-----
Chris updated the status of PCI preservation and sending out v2 of those 
patches.  The current patch series only preserves the bus master bit.  He 
asked for any feedback to be provided on the list as he was planning on 
pushing for this to be merged after LUO v4 is landed.

We discussed where to merge the changes when they are ready, the consensus 
was that this would go through the PCI maintainer tree but after the LUO 
APIs are already merged upstream.

----->o-----
Andrey provided an update on KSTATE, he said he will would be willing to 
go over the current status and plans through the end of the year in the 
next sync so we planned on carving out some time in the next instance.

----->o-----
Vipin went over VFIO device preservation at Google as a follow-up to the 
KVM forum[2].

Vipin noted the internal approach will be different from what is sent 
upstream.  Vipin discussed passing VFIO device file descriptor to the LUO 
ioctl for preservation similar to what is being done for memfd.  There was 
an open question on whether VFIO cdev should be shown in /dev/vfio/devices 
until the VMM has reclaimed the device from LUO.  Jason suggested that it 
should either error out or cancel the live update (resets the device and 
operates normally).  Pasha suggested that if the fd had not been reclaimed 
after kexec then it should reset the device.

Vipin discussed interrupt preservation and the internal approach for doing 
this.  There's an alternative of disabling interrupts on the device before 
kexec and then after kexec, set up new interrupts and blindly inject all 
configured interrupts.  At KVM Forum there was feedback provided about 
side effects of this for Windows guests.  Jason suggested sending patches 
for this alternative as a starting point.

----->o-----
Next meeting will be on Monday, October 6 at 8am PDT (UTC-7), everybody is
welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - update on latest status of LUO and next steps for merge into akpm's
   tree
 - update on the status of versioning support and anticipated timelines
   for inclusion
 - update on the status of stateless KHO RFC patches that should simplify
   LUO support
 - update on memfd preservation, vmalloc support, and 1GB limitation
 - discuss guest_memfd preservation use cases for Confidential Computing
   and any current work happening on it, including overlap with memfd
   preservation being worked on by Pratyush
   + discuss any use cases for Confidential Computing where folios may
     need to be split after being marked as preserved during brown out
 - [20 min] Andrey will discuss the current status of KSTATE and plans for
   it through the end of this year
 - [25 min] Samiullah will discuss IOMMU preservation plans to get early
   alignment with stakeholders
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] https://github.com/googleprodkernel/linux-liveupdate
[2]
https://gitlab.com/qemu-project/kvm-forum/-/raw/main/_attachments/2025/VFIO_device_DiiwG94.pdf 

