Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A13D606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ucu/USF5
Received: by kanga.kvack.org (Postfix)
	id 29BB36B05B1; Mon, 16 Nov 2026 11:28:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C376B05B3; Mon, 16 Nov 2026 11:28:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13BEF6B05B4; Mon, 16 Nov 2026 11:28:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E00C46B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:28:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8111D1A01A8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:28:50 +0000 (UTC)
X-FDA: 85441516020.20.12E5342
Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1A63240004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:28:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ucu/USF5";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.191 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794846528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqhrbr8iKieSrVR0UuN7fPro2ug2CEul2vf55oUadPY=;
	b=VVig1CpcfHcIWzVYUmPeYP39A0LD2yKRPjU22oHY76jI6Ad081MaLx9wwa0cbe5r09xxb/
	Z2483RnsldY7qhGdk93leAf8LfxUnH++fi6G4o7zYEdtADvkoH7DZHvaKyzbBiF9dlJ7XM
	HSZjOuYsfyEXNJTPzJ+FeClPlTJujAU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ucu/USF5";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.191 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794846528;
	b=ObuzM7Epo5M/tL0YsFPXTI6GlK+rjUjqFgaY8LdobmzJaV1DKaaTaFRFQ5ho6jDUUy49Pe
	xeM+MkMRU2fVRR8khtydAzaWM0wDOpC1u4EozGu6qybud9kCNYrpGccZjvf/xSN+afW6VJ
	CHWfySEtFtE/35swOpy7mDDN5XoJSlA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eqhrbr8iKieSrVR0UuN7fPro2ug2CEul2vf55oUadPY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794846526; v=1; x=1795451326;
 b=ucu/USF5L6j3xx8be3/FBm299AV+a47dsd2tH64gH3jq95m+jjGg9LGcprLI3q9oULItOeUt
 Qc39SLVTcnghWOkNSUl1uK3rrukH4CmW9GJc+FCrCro7iw4B6m6d8S+12zKFL1B779157/6jKvP
 9pjfCsJg5MA9gmWzf/d3q6RY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1cb6a267da102afd;
	Mon, 16 Nov 2026 16:28:46 +0000
X-Mizu-Trace-ID: 1cb6a267da102afd
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5be58ad9600so11490e87.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:28:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFc3JP3sWMNVFapBHve8uT5zphEvcvHCol3jKLEcpbP1TUvoiY19jpIbtHDKuAOG8Kp6VQi+ZN/nw==@kvack.org
X-Gm-Message-State: APuU4Z+veqO+3iYGcbC4pUshvM2tEjhxLE+mDjoHlAna4BJFBrex04j5
	RiZqgejjX2nYnUjSJ2G3XjnY8d2jEaP5pPt3cMYOIjrFb+O99fjkFZZF8ojO8gskKesRxRZ9Ct3
	L8LFAqRtWzLLecHMZnKZvd9uzisfeN/xEj7vdbCqa
X-Received: by 2002:a05:6512:1290:b0:5c1:5209:5a44 with SMTP id
 2adb3069b0e04-5c17d8cd72fmr248826e87.4.1794846521147; Mon, 16 Nov 2026
 08:28:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-3-aneesh.kumar@kernel.org> <CA+EHjTw7QzzkQYKV3jyvW5mqZQMenTfm=kus9i87tYqACDOv0Q@mail.gmail.com>
 <yq5ah5hgyj1p.fsf@kernel.org> <20261116140259.GL2532299@ziepe.ca>
In-Reply-To: <20261116140259.GL2532299@ziepe.ca>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 16 Nov 2026 16:28:04 +0000
X-Gmail-Original-Message-ID: <CA+EHjTywWTaKLtM6OPF_0ETv29-m8JsHdvF3BeW9Xa=h713eEg@mail.gmail.com>
X-Gm-Features: AclHuK8v9DG_RUNyj3rKA0Y0tmAlsYWqFzMKzPZz5wl1VueI09Ml-h3rn0SbMmg
Message-ID: <CA+EHjTywWTaKLtM6OPF_0ETv29-m8JsHdvF3BeW9Xa=h713eEg@mail.gmail.com>
Subject: Re: [PATCH v10 02/13] mm: Zero memory during shared memory transitions
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, linux-coco@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <baoquan.he@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Steven Price <steven.price@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>, 
	"T.J. Mercier" <tjmercier@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, dri-devel@lists.freedesktop.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1A63240004
X-Stat-Signature: 8uf97bef6bg98ytbdipyy7cuikaum6ue
X-Rspam-User: 
X-HE-Tag: 1794846527-630474
X-HE-Meta: U2FsdGVkX18hyOuOPS7l1u3TSUGWaDcRQIew+c8lh2PRxfyTd/98z1mm8KZdxbG3enSPPmVx4COIOil92D8KVvIZITUpc3J+sgwl/rIZYkfEpC3DQKGg3/2MYSB9Z2W2MdpBQgXQicThpBVWGW9QPNCPdnjSx5If+6r3Pqat2YKtnuhR+0PdsnEQG8rWeAytttVXPhbDC5c7tVxwcpk5lCrelJgAtYg1YHaHL+FEJYSkjuL2OLc04AkMWlLE7dhTJ18o9eFLProVay17KdkR3M9ZzViyx/kt4X+l4Li3sVPMXff+L7cvQujbSoUSxuEydIDJOEOywUwATtr40mABxGv2nyjzWuDpIwiANc0jRx9OE3mmUDsXwi6MTVo0OMRYPmmohsmIsOjXOLB7MYGSXtSJ87i1VYPcq4WRsvatJPOXJy6N8KqlEZhUN5mLS/pPjPTf8KJJMrkKt4ZwKFhAqthpzy1J86ht3UqNpLDOM6lavd4wp+2R22MNmJLwtT52S6kGDoVlYuHFxDPNTFcUCdbM4YNiDhz+hg+UPUfrMygOLBOke7H2LELM3/9Zi4M4lbv0mjk+06ieKCdPD6e+TLbQFQnIzEGb17ko8f/EE058P7w10YNbSiq1NSKp/SxJPWjG74c3yog1ZoETHioJHeY8cD3cEkMDp2hlQA8Qrzd97xKSTKCrbKf7zPkAErb4LU3FEX876Fj9fsvrZDfekepaH6RJHPVLJRZxS/a8beBeF1DUOxSXykoohhGnhPBSJW7SbM08DAuSpAhIIw9eI8IrsxBn/mdprTlwDOlVdJr/TaHPgQnfrxmUM8XSocR13crfUABHZl7tGTDupdQjUhjZvlgqLQAhrg+nqjFpNMEX1PxR5t94uuiF4d5aa0RP1o0zMgGUiIYlK0gxLz0Y2uuq8hi6lji1Bk+LKtlhTCbinB/iExYBJy+7UejOAZNgXzXHvzUPzQ/OT1jIxiF
 IxGlTG7x
 ReCIUuGCJsNyWQ7D4j2PXU6SX+rEiWa3hsxaTpvH+zLZ04dWNP+93mQRsfAapY5zlM9DCTYvxSPTNnL0ySJ8nFVH7K+uUgQiF9Srv3l2t4fkQPTJKiFymaL9Iq07F7F4Rd2HP3p0BA/2Va0xn3aj8JpNQPa35K3PTOeHBMSDphlLvFZXJm4rhhcNPNgt3Os6fHQKc9D9Qp8sLPmK/oVX+qszCkCfUBPtG3UYy0/0q0Z0m2mONrJTB+DN9dBxrQjp6aC8FtafGCqSvm2k8hYGjX+5K9P8nJyK8jnDqdLpV9u7PpcasTMBLZQnAiD1HzNwe2yytBLcOtEmR38L/tbcnIvqOYueKpXeupzVGVXplX324wcD1xORC06Ur5efaLOohGJcwm95cwayLi3TPYmIxDVhzsUVnfB+F7cqRAqg/Lz6+IVLB/hNnSi7FhGYY5plOp6De
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jason, Aneesh,

On Mon, 16 Nov 2026 14:02:59 +0000, Jason Gunthorpe <jgg@ziepe.ca> wrote:
[...]
> Just like you are wrapping set_memory_decrypted() in an allocator API
> the user that wants to have the no-change sharing needs its own
> special API too.

That works. A separate API can cover no-change sharing when a user
needs it, so I'm fine with set_memory_decrypted() zeroing.

Aneesh, the pKVM hunk does need cache maintenance after the memset(),
which I have in the Cc: stable patch I posted earlier today [1].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261116110549.1863653-1-fuad.tabba@linux.dev/

On Mon, 16 Nov 2026 at 14:03, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Mon, Nov 16, 2026 at 07:28:42PM +0530, Aneesh Kumar K.V wrote:
> > Fuad Tabba <fuad.tabba@linux.dev> writes:
> >
> > > Hi Aneesh,
> > >
> > > On Mon, 16 Nov 2026 at 09:12, Aneesh Kumar K.V (Arm)
> > > <aneesh.kumar@kernel.org> wrote:
> > > [...]
> > >> Keep allocations on platforms without memory encryption on the ordinary page
> > >> allocator path so the original GFP constraints, including __GFP_ZERO, remain
> > >> intact. Remove post-transition memset() calls that are now redundant and
> > >> explicitly clear allocations on paths where no transition occurs.
> > >>
> > >> This intentionally makes every private-to-shared transition destructive;
> > >> callers can no longer use set_memory_decrypted() to preserve existing contents.
> > >
> > > pKVM shares memory in place, and a guest has to be able to share
> > > memory it has already set up, as Vincent pointed out [1]. That was one
> > > of the primary reasons for in-place conversion in guest_memfd.
> > >
> > > Cheers,
> > > /fuad
> > >
> > > [1] https://lore.kernel.org/all/avro44jUWOARFzul@google.com/
> >
> >
> > Thanks for catching this. We discussed it before, but I reached the
> > opposite conclusion:
> >
> > https://lore.kernel.org/all/yq5a5wzw2ree.fsf@kernel.org
> >
> > My mistake. How do you suggest we handle this? We want to avoid zeroing
> > pages multiple times with different CoCo configurations. For example, to
> > allocate a zeroed page, we currently do:
> >
> > alloc_pages(__GFP_ZERO)
> > set_memory_decrypted()
> > memset(0, PAGE_SIZE)
>
> Just like you are wrapping set_memory_decrypted() in an allocator API
> the user that wants to have the no-change sharing needs its own
> special API too.
>
> Then you can bury a special implementation for pkvm there.
>
> Where is this special user in the kernel anyhow?
>
> Jason
>

