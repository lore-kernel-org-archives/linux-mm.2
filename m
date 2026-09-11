Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E182C88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 10:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4506B0092; Fri, 11 Sep 2026 06:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685996B0093; Fri, 11 Sep 2026 06:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574C26B0095; Fri, 11 Sep 2026 06:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A8D76B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:16:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 10613140195
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:16:48 +0000 (UTC)
X-FDA: 85201077696.30.F78EDE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 70C6220003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:16:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAW41siy;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789121806;
	b=hahbScmOea1bW3aoAj+KYbGtHtmrqG09XBN6mn8V0lMikMFfsLCc9Dlveg8JmL0fCSnGGA
	eLlu5W6/Ej1lT7XKBn2YipQiXs6VHCtqzv3OLW7yOn+pXQZW3wVE31zZhv6SVyinGycEPs
	PKApc7nuHRDnIFIRvd92H6A8SZnJQaY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAW41siy;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789121806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=giLIDOVuGk3wU4sINvGbjDY5Co7tru0+JFiE0K9FPLI=;
	b=fYWS0POhzKmn3fdU8ei77I4trCPcrIHS3BNgft5YMdrsDn6hO9I9bDwSI3x85tVNd7e8QZ
	ePLAIgh2gFfT5zJyM2SBRJJqZMq2/ttopSHfMjp2LPTrziXWRKsslc+0vGUwedt/NLkzew
	Zo7AGBSEmgIZJ9cBV+oW3IMz3Q2NG+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9263B6025A;
	Fri, 11 Sep 2026 10:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B0E1F000FF;
	Fri, 11 Sep 2026 10:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789121805;
	bh=giLIDOVuGk3wU4sINvGbjDY5Co7tru0+JFiE0K9FPLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bAW41siy0jHTB1qfl3qn4gdNLwygOP92sxwRZ5j93bg2aVlvwhPZHWNQXCkbUnxC6
	 9zk3b5mbI7ab2hw7oNcaGXVKHnNx1qFzqMm5NsCPo7iMQTWRRa4ga4/FYZMgemnHMR
	 LUWR9RDzd1jBIAPZg7P5yYAnVdcGzlswz7uYblSZrI8mgcWzefXPuZrclq/aRa18mg
	 UXHtcfHYeWzL2TMktPNfUxYpL9byrk5pz2SSOJ+Hi6IFxR8hMDvGKPZB2iRfKGLL8X
	 ZmrHB9kpMAfbsIpyQlYJu0jR9aIkQQcmQfumaGM+wf3Q1dTyf8WnZzhQjhpzxy2VYs
	 gbIALJ3tDM5qQ==
Date: Fri, 11 Sep 2026 11:16:14 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH 11/39] selinux: reject writable opens of policy file,
 drop mmap shared/write check
Message-ID: <aqPUqU3eZeFrykj3@gremlin>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
 <CAEjxPJ7hXSi=oLtQPV+7GEvN+txfYwZ-u-v_EysNHM0gSGNrCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEjxPJ7hXSi=oLtQPV+7GEvN+txfYwZ-u-v_EysNHM0gSGNrCw@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 70C6220003
X-Rspam-User: 
X-Stat-Signature: irm5ppgj6edpsg8jhtja6wdbfme7wuf7
X-HE-Tag: 1789121806-302489
X-HE-Meta: U2FsdGVkX1/pCA+J5HmDnyHJYtfc69Rj4drtpN/7myzCHw3+p+luW+9prPc/PDvbtKlo9kZLgDX6ccyhf/3vG3E8sc/RIqfGXK1GKHK+ZfXr2hrugRr05DyexAteFtcn8Oo6LjuT5UqiAOkXbv7px8rVyaxpUSOVL0Gx3QPS5LIfTmm3k4sstPOUD76bXFT9pXFfRGclZzqNEP/BRXUjjk9XI6wNkO3JhplZbvhB86JeUA1A4PLVut0zWzdDKg3S6olL9hLDWMXJq/rCk5vrrfuEGcGaW0SM/e1L9QN++48YFRHVHJyK7i/OBETRThMSBpHE8DMwXMChtazyVX7BxRwgvWg/asKJlb7KrZVMs4Dp2vGQTYhM2EPiS5NUfPA1FXUzMCx/Oo7TIzCLmoFzNJJRzqDbbRL+JClYyED1B7cIk9f7VtC5NlQz/LTJhF9kW/MrFNnuPTdQaIuibxThu8/okdUwBw3puTya7hG/Wu6M4szxiB8SLynZu+tmFAgy4hGkJ4p5hjf8gyCxbjNmEb1dbeeFF/TA+OVmmMn33HwMKV/s19FilhxraFsjsdk8I7jXEDRl7pEYaDo5P3vP+Jt1fokNZY90AapeWGOOVRXOMLHorHv8Gn7OoqDeT37bf/6/NuDShEUnQfdL7PtLmVmMDjsZJJOHIBf09kyWG8HXW1YbILPPSAj1pmbtLZUgH9/XgXpYxrdI0ywQWBw+wTmJQJmmXzQeQ7mizaAHyS8C9w4jF/uFWjDKRRsmqQ+pqOorSS02SxYr5aTrZU3ORnWVZZu8JWhI5tLwvyVVoBWswIELpZfjFpXUzxJ/7wOQCIntT/1CesAvNFzHgedRGVRtuckjpFhr+GGRuOdouBPQhZVWJwrc9rbND1BC0aJhxKVzfgirXn0jJqVHQkZOEaL3Loxe+VJdeGJDTfZ1UKLLGXz8ITIlqxK9XBlAxR9IBc29LJJlQ7mVuNMsWat
 PszEmNEG
 PVLR1zlRsrjtNQF0tSpEfUbqTVlX539PVkqcCPMZvGcx8tFx49/istejVLk3ub9qyRUq8T5Tz9kHfbFyNWNCiI0L1wpFOftfIeHUwRV2nTDQLo3dFVr25STudcAyT7F9YBJQkv/f1D1TXbetQ70lhr2JlrkpN0een1HZAq1VoqesUl7WmZnjdS5sKdBgYxbW+GYhXqaChfpNS0GVHZLtYPelZMgx5lqZvUGMEI2TTTHj4pB+kBFdOlJ6JfjYRXx+XVFUC+KPDebhnGjNwB3pTGrtW36P8rfAlzQ2tYlfF3aO7YxkKxmPnsCHQ98AHKpsZDSg86dP93Ilet9rkeE3ztucEcVm7sjHVLD6xycnnZ3TqgNT0quF/MEcPY0amqsps4mi6/AL8jBYdQpfEipYQSwMxI8sgmkdxskPn2Wbhaxf1GVtA7++M2/xKxGYHO0jtj/OcSRdv7CUz6/F3VUZ9viPZTedWnwc0uJS2eq4vmfIMqEcaofCNlUsodtEa9NzByVRIw0pIORnn/u7LKbs4SAumV1JOVYz+IGMdle9FnCkBGTY/F77bI6HfrNAz34A4L/Q+RP0sAz7E3t5aweN0XXbKave9JJenuh8dy9O+cZfrUGFQdOdse1Bi5Tv+N/C+Lgo3YcXJSOr6uJtinAYm6CdxnuXal4LOGy+lOERVofhUeeDsipnI9ffBbK0Nify2lGnl5n/+9NIZ3tPd8ClR87ZxAaMgiWj0Xzu65vnNbslx1Syvea8vvqqsOxNssD4nCxBlnHMoFgi1gNbb1A960NxrOa5ORcYkOIVMyPQNYIqaV8xrxDOByeLp/LFk4XzigUfmve/46U498dgR7ZYwlnzVnkt6YkqsbwrE2+wHGttIC9XWfIbsiMbs6u+jZbqZZC9jHZBO7yBgrlwuLpdIbb9wYMoaQ2yLO6bJ/jfaG43wEG2lvumiPx6tU1Siyre/KTDig2HLe4/QPItWt5/meTZxyRCk
 KTPJHzJD
 9SQHwV6MXVykJlHNALhucq0Cbm0jujFQxj94zCMYPr9GPjcBBciKzX65GFdqS6O+88IktLdB9VCgcskNzw2yWX2XyL6YphcT+9P/E2cGOFjn6GJ96fPWEsdQMEdb1Lr9y5bRlK/4KBJ+sRpWan/xvEGy2ntZC0WfoQdbokilJeW7NqpIZG7qF7/YpF23fJckRjtUq+ueNu2lccXTTQhUuyq0Rt8jZfhFLFWbEjuWAmwD8WXKQ+7RtsoBYEN3E4zSnh9Gecyqg+lK57UvV5xonGGuJnFV3LHe/5mnbejsDUFbqQ+8BUYwkJt5CllGFIJpc3+4i24+u3F8OBOQ8Knr3NFteSjWVDmnhaRT/WbLo6gkw7GxXnQHlZPZH55+1gxwglU/3Sppvl6DWBpyc5zF/b/uSpEUDrkTbr90dkp4wY7eorBMUgkch6li4kjpWZHafoiNiYS/vnRYwlL0etC6XyRGSxU9W1SyMyDExJzP1Fn4wDdeoAmAVsnhH7CqTX43Ut1XtRvSUQKpzKBlShHoQBUMb0j9kaq9Gio3072XAyDpWheAvk0JAg1ZbdBznxl1sb8Y9/T5jImEIFc1mDWrwlHkPtf+ibs+3m7QsjvAM6zyx+dzM/pJUNpw2DjdKKMeTk4DFQhGTCqHUO77jVWZNT6k2ZwNGMx0TYpizaht2CaFEIeRbgD0XIJDumiumZrm/dhS2Gws8v5PI0b8Q7e2a/zzdy1DeASSfOPgJ7GCK6BNNibYixFwtlmJutzZQWxlulqLvyPdar5mx8wulCo5HvJDBh/ArxwhGzhhq4Pjx1vr/ziLckPrSz81okCm0gzrJtv4rLoiQ10jofrEB2J8ex0mP5INj+dyVdIwAfmkTWUM5LIdZ2/e9Fv7tWl5+Mcl8VKNImCpGF+EPUWrlLznJc6R8LynLpVl4KTPDl3RzaffCsFXSGjPAfMjz4tpAkrNaHveOLF1QiPur89choD2xncrLA4IR
 LNIsCasc
 vBwmTPvgfcIzARnWp1Cth/0S5R+eJJnGRKaQIdIOVsRqwUTO4kK3bdQLczvU8LkYjmiTKjMzcyKnRVT9nu/DjToqrxTWGfosWlmAwyCG/iC+JG1CNiW5MVx5EssOQOb/IqlupKnD4fKrlasnZUImPl8Qq1vvA8Z3egeeffqrkFt9tq+Xj1FRLM9EtHLPCsVClAkU/qI76eiQLAdA+HaFdEaYzV+KU4j85r2zqoo3P3fZYhjrxsmtK/DcpyQXwShSkMSqPDtJL9Ge6LW31Y8cNrqeUTlUb7/LnmgUQPsE2vcQ9atqJ/at1I4PEnXsgF2yGpXIVyeqMBx8t4cz7ZsRB4yR2CEM2cT8gydzA0JZ1LROfZIMmMPPcpb6XLQHifevvufabepPWIZ6hFkksHbO7wNKBMg4RSMDMb0VBHaZfgaHDDqzTktDK3UwGs6e73P1mD0Mdlg4zDb2Nvq+M8R34fXahwRcWUYXJx6WRJrN8Ur0DvpsZ/9UjNHogaIpBG9KABXfcGmL1BFtHXnKSfhsWe5TwffhFCuYo2uZWwU6Lv5W6WOx/hfJ3nEA0v9laIEPdp5oD4tPamb4p17IwXX3za1eQI7eKxhooq3eHUKDhFmELhIvKyYu2XJNM+l/0p4gBacCgT2wwSixrX1b9ETx+NDYTFx9Qhsa97lkqBeoo1frQLul5m5r+Xj/6J68q3IX2r+Y+P38MhOqOun8pyARgrzBV15r4TTLJghHcIt1niiO7Q2QbQRzMt6SLuRY44p+6RxZX+SDes7zqHf8zn9hQ1zH99YuNvt+YXpnFNhJmbAORq8XsVeuEnMFV09xP1Xf8c8JJBYSClRJ1rkZUhcyxZNus7gbpTM3LIFGii/ap+xCYFEObwfcYib7TnXtJZO2SE5cQS+KJc2aagMKyKKvap/jj2C4tFZKWsNFGHu0qhFrdcMzpdkTvIO2KBydw3EogOee1OLTem+yLB108y1OjPU+/6F/U
 DL284/c2
 Ts7QGkizYq34nMA4cGPrc9wA1v7H5PToreZL3WTHluPJD3mGrQV8FZvLcLp6hux8JXBAEc2/DaHQRywsECeT0nFvewNTs7M1eM4tnpjn3ZIBp1KGUz28r9Z06fITffEL4lL6I3zDTCWYkfCq/3sBoCgRbMtO1CDpeQ2ML8L39iYbO88cGzjnSyLEU9czZTfgkXddExCwjjCt/IgfEm0do4zF01oPqki1xWu2et23vi1R9DvE5fX97cqF9pyDVfErS/7s/6wBTBowYmPcwdVuiswTrJ/8hKV/AUXub6tyyuJjeAPpPbPoJk1EMKH5z2/fBLgks1A/8Nsfty9FIXyuWUp/vO6FU8x+FSHnYj1JALWRVCB2PuB0Us
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 02:11:18PM -0400, Stephen Smalley wrote:
> On Tue, Sep 8, 2026 at 4:07 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > The policy file has no write method and is exposed read-only (S_IRUGO in
> > selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> > CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
> > kernfs does.
> >
> > The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> > clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
> > check in sel_mmap_policy() cannot be reached. Remove it.
> >
> > This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that is
> > neither a PFN map nor a mixed map, ahead of the core enforcing that only
> > such mappings may do so.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> We should likely do something similar for the other sel_open_*() and
> sel_mmap_*() functions too.
> In particular, truncation of the status file can bring down systemd
> since it is mapped by libselinux.

Yeah I think there's definitely more that can be done there.

Though I think obviously that kind of stuff is better as a follow up as this
patch is focused on eliminating a case where VMA_MAYWRITE_BIT is cleared
incorrectly.

>
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>

Thanks!
>
> > ---
> >  security/selinux/selinuxfs.c | 11 +++--------
> >  1 file changed, 3 insertions(+), 8 deletions(-)
> >
> > diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> > index c7d91476971c..545a6f89f9e7 100644
> > --- a/security/selinux/selinuxfs.c
> > +++ b/security/selinux/selinuxfs.c
> > @@ -340,6 +340,9 @@ static int sel_open_policy(struct inode *inode, struct file *filp)
> >         struct policy_load_memory *plm = NULL;
> >         int rc;
> >
> > +       if (filp->f_mode & FMODE_WRITE)
> > +               return -EACCES;
> > +
> >         rc = avc_has_perm(current_sid(), SECINITSID_SECURITY,
> >                           SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL);
> >         if (rc)
> > @@ -424,14 +427,6 @@ static const struct vm_operations_struct sel_mmap_policy_ops = {
> >
> >  static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma)
> >  {
> > -       if (vma->vm_flags & VM_SHARED) {
> > -               /* do not allow mprotect to make mapping writable */
> > -               vm_flags_clear(vma, VM_MAYWRITE);
> > -
> > -               if (vma->vm_flags & VM_WRITE)
> > -                       return -EACCES;
> > -       }
> > -
> >         vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
> >         vma->vm_ops = &sel_mmap_policy_ops;
> >
> >
> > --
> > 2.55.0
> >

--
Cheers, Lorenzo

