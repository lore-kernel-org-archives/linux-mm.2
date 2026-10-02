Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 442C7CA5FE2
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 12:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15D4E6B008C; Fri,  2 Oct 2026 08:36:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10EAA6B0092; Fri,  2 Oct 2026 08:36:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3EF76B0093; Fri,  2 Oct 2026 08:36:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB00D6B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:36:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53A444071E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:36:14 +0000 (UTC)
X-FDA: 85277633868.16.93149FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AD8C840004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:36:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y04Ou6XX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790944572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gHT1eHrCeRGheckcuVuH5tVn5htGR9KNUyLnh8eDOzU=;
	b=mQBn4EvwBC9FrXRnFw4GzNBY3llfEfnvRlxeOrJjaQ83IgSiigGZf3AyOcDwgdvNF1CQbr
	x1Ta4X3ojyNPwzAlx5EcNLnzYCQqgt8YrtaDHpr6aNq8tmKQ0QcVr9k62XClLuvUpSSqzy
	SLviv74Cz99ndtcVSzkb0/UBY3/bUsE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y04Ou6XX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790944572;
	b=iHy6bVZhztiAGPAxo/Vbl1P81DFb8ajIkv88JZ11RFkwLMX/H+vNi1+zw+53aZ/IZxho+O
	M3y/WIxRky7c8VzE90fg/S3vylCvJDhhQZrZ3FHTrUNRPSe0qes1irgW4p9uciuCplvC+l
	asASIvXHsxVJOTg1kyLJggIfXzBKZDs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FDD443B57;
	Fri,  2 Oct 2026 12:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D291F000FF;
	Fri,  2 Oct 2026 12:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790944571;
	bh=gHT1eHrCeRGheckcuVuH5tVn5htGR9KNUyLnh8eDOzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y04Ou6XX6SdMWUWTarLUhIsaN9w+3Pqeg8oUs/7OIb31JfWW0vUEVzkHQmEdDgjhX
	 rMOXzqjsfTki350NeAiEQUKi4/Wmdue8la++1bjfwJl0sJt9qPFQ5jP+SuL7Z0VIrT
	 fF/q64PoEK8zQ3Hm3rGDp9dID/9LqdMIt5ul42FGVvVWpLww9nxdUXfWoDIelUsaAq
	 8uHXbsWsAqgQEMs5R7FJEaINNCSu3zIGTrOrgwAyZ/QFIZy9pBQiDvOq7P6XMWUnTW
	 K0nPXJCzRbOceqmLZfwrGmVvzEwYcn9zKQTP/XretUzMvEj70sWs0xCGSfo9UlqM4u
	 t7IisLDZyS3qQ==
Date: Fri, 2 Oct 2026 13:35:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
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
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 32/40] mm/uffd: use predicates for userfaultfd checks
Message-ID: <ar-k7i_hZC-SqCLO@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-32-4583d8a23bca@kernel.org>
 <72bbb616-e84e-4635-9d0a-336916db47e4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72bbb616-e84e-4635-9d0a-336916db47e4@kernel.org>
X-Stat-Signature: b5mp6e54j1hiae3b3jpb9ww19p7otx1z
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD8C840004
X-HE-Tag: 1790944572-911586
X-HE-Meta: U2FsdGVkX18gcxBHYL/HW8R5jg5JKhRfoPidnFNn+G6pahntPe/vimkojE0qNu1lL91SH3BBOeir/TXP+RyvkukSTsgwBLnNKL0PJbGjtSI02Cwj1bzrBXqxJScNj3z9BgUNKr3rP0xtVTnMobgm9KHuMdEDQ07T0Gdj0cve98iU3ltYSOdqeyl7ViWTx4RcAamU7j0CB2fMZFhSmQ/AeongfKSkEVIEbkKYVrJ+CZkL1AmUseAAx9VPOFx+V5PDZ+hGng53YmAnOChNDJexqfAdQpAaZh7TpzFMtBNCGGHg5JTPCsNDe5BlDBeBy+vba3cw9g+Qb+u82o6E+vNiJHksDCzeR54ZuDKfsyxAbsKcpzDBDwV5dBzs8ThjtTEqN8eLhzKaUufqyZKl+YNuwMFbYB2hiG/83Z7xEQHQckssOofQTab0O3cnnySPDNX5fQGaJ5BjQucJ5LWEu/qpPEFKNDq0MNodLLB1l6ZcOWQ78Vr8QthdpeqXqE9LCL34EWcfR6Zp1pEaZwAhNXbdcAXvVOBeNMiQAHywN2GRY81P8tHzE/sOUtupe4Ckj2E609z3pw6i3xDJpg/MGJ63bnk8+Z+RRq0TJa3ta4vQjMWU16M9N7SAprvNHJ7K8a+UbU70LHf/ARpjXNzuxWYyhftHqX3+Giz8EoWT6cIopsPpRH6OaVqOWfNCoWz/cG5TS/XFAvE4AAPJt9+4Uux1XtKgkBz/CxQIk12LyJkWbBWrEmePZOQB7W33DNdCHJruS00VYJyBNraKIKlakAq7EmajfBOSVF88QIT+aGjLjpk1D3FXT4aqosEtILGNtKMv/5H+aMRbH4XcojE/2J9qwv4RxG1pso9G1y1I8HcGAnMibTK0W73cvHMo/N6kHF/hShK98oOYqn1OtJCxSQ7pkU7Cx8sK2pyRyGoXb+/GebGVgpxWFVheHedKU+6zz2VMvwlTC76/PyvQYMEI/hm
 cIBbciT1
 CKAB+AJ4Lxbj1BspcDhBtu8SA33/PCcIlfgwezNVkbjGSNTFnzb58nHmypi4QrwtzzglyNjj27NRMIiQEJRMmxtXBFq+Blpm9Bm1klb1S2Q1r8MtfWTe3KYZDeD4Ef+8GiBa+nF2v+vUFJGtKzBEOv2f0DLtSvL1+MUcuGETHizILWg7l1LA2+ftf2tU9Z9Phqjd98142t9bjwxndCXsY330wW+F/Hipkw1NDTQ6Yob0FrfeCmLlus7uBsr4WzhLBHCVfvdgYrIReRYLtT9bTDB/qz0F6LIIYyyecV2MPAEWKi5hmV05zOGsWhEbTAwurhxeJbr3KYBiePbDWXAe+5Hocv1Bw9bWYHIQKEdpAS1CNRjpGxfoq8wKOju3JvpplHrHyhJuRbI6lDPaf9dSe/b+xSKQkUByyHjrJBk12nDKb3Y9fCvr7b8xIRt4qQ57mLU1kMJkj9E1B8VhJsZIE05Qs6UjAro4+CkmdoW+Xncx0PRZDXjEW7KJDJlah3IQcXPsrRk0Aw38t09LJeZB7qQDCd2rOXxMJ8IMWJuK9+etnhpXb7OmRMi4KSYawRk4cS/uMcfZUpo9dLlddiOjGyOZQXUHuQIx+kpcB4Vmf7LymuRDxL1AZpSrsYLp0CXoyXkqC804Us2z02mY7AWUsJgSkDroQZ1hX8qLQcFEJbZempsF44bsXNlhWydkSco9pXjIdO5Xf2v1cBrDdpbyyFwWtdBBHhyDJWf0ayBTKlbmxKSBHa2tFrWsc1S7yBB5pa24wlIa3RB3CMUBMFb+JwIkezVNDUi591NF6mxLSXr3kF8kkFOnwFPigEf6XgYE4W6SHvFR6+gjUqf6K7D3OIbXdfxQUkAdHmzexVJ+wP44SKTaYs0A8BW/D9k8UDm4X7GIlyDHM15shYlbJ5nUg5lu32SoKO3PUtuMLj53P7B1Fn54EAYivdfgfALzZ4Z6C5/VXA9Oy4Q7zfWm7854tDOb2ASa6
 ZmAmefaQ
 MpFf3XHhiz92jVqtkmAS3MM+76N6/2Qg2wD6vfvEjttGiKjTLCPKEIfkEby9Y0LTNQIfgs8Byq3zD+52zL8j7+Gj14hFiWwwlT1f3huspSeHLyCLK2rYOChlTjZfsyc64S13mWN0TsErodZ/yWh9Q840LMzVQpqHb9m+gnLLmTwarM7Yg5nQKW8uODYi+YX/RYCNZjSzZwvJoxvNKKW4io5Pb+daMpBjYfabrpKD5+f6YC4HlV9fh3NhiG8vkPVFI536d2uoQxuu1Yy1RPwhnSqDLDEUW2FGqtvb/ucCCbBSnF4Qmbo09XZbIOcXnGy8mt5gmjPaJhrssJKm2miLpjn272igrilq98pqv6XbQ5PPqGYZwdqQtB1DaLuLGIp1XmoxBjX33CXKmc3n+c4y39QIlfBnrmoeDxVm7IGA+yj8tRmV/K88HN2v2tmQjawLLwSsPM0dCv0v/gH8ZJF+a8JBTj71otEmznvyg3jXj4JaQgwHiF+7ZXwX8ZjFjoBNnlgmmqWfyn04Xh04Xtfv7ZetRU12xABu5HqBJPKfeq6VBo0/SkjvNom3h0oxDsfrxoVPOG1dxd9MQRPWvFUv6z1wR60SgzLFhAyHU0uxffOEbOi5qPuqdMHPfHBSoggWZuUheRw2ryRbJ6oO8rY+s309f7Wbk9UpxMHlycVZyUD1ag4OEdVy+OuEZeBI6j0P0BEtHf82WdA3dZd+9txcbe/+G/adp8ks8u2pRw0CeaL2ookrIYp8PeMoSDoWYy95JCK3bHK+7I2AWq7lww6AESuOHy6MvczRynoKGg5tReW5rtkBRF4d52eiREXcHaqrUbelBIKmYN9hsrZASS3m++o72zFvLgPzuYBxVpGPQchPEAEApraVzs7mn9zipPAH13sYDTORr7KI9PfHs+jiwEo9m0qdl0OgdCZrmNsLoXEZ49O+jXcSM3DUWvL281VOYFB7QICYrzVTvWh5gYbKtH5zfiOpn
 QdzvbNCk
 DqfYTLacJb56ikc9aeMZ0FXrayQ8rlmuey0bcSZVGLNHWzYph2FAy3j0Xc747BjoYxPT8vYacvN4y3j9+b3hwhCJ3Fzbi8VedhpeXPa6Aws4LmYSaq+Twamu3X9x6o1aQTi70ljsD7xJCCuQFXlG4J+rmYEEo1id+VB+TwJVUIdizYqFnB9lLmplNuxnGfD5bfufKxl/SlX3ZQSq/1ErErcwfkaRvD8hewLGSYr1P7VbZOzoCPe1YssmEfFHpF7JAGcC8uwa/cJqAyq8U0E0Vz7W/MT6HMcuu1G/T3t2OMP+JLu8uYI/L7h/AvvDg4ZEHirpgvXjKhVvqvOsLLqghVHUGW92zYip3dsd3NDpyBjWut1HFNrqQBf12TCR6CxSqPCvAbLgQZ50ras6/b8HihuL/1LAam/rYTDwuEW9ei1SZHdb3EavZ6IovSX6AoqUgKQnMb1M+H/pD68AVTNHIowp9RX2Nmf3hUZrbqDtANYDsOBZYLa0ag7jsIASPBFO0oVbNG851aV6Ye9vwfargrBt7yszXgJDY232DOeuxSjOK2eZIewAGMOOT06W/sdsaE6VKIHUHQZB8Bb6xMwwMVeEnBjwwEgRrQoifzcAQ0PKpCa3/AwxOFIQfCsy6qC8PMs9BXUQXMYWIWzpiZlSR6czGIeodjovJjay+0aUNW/udmsE1HgZ9+i2YLf7Cnd/ogL1Sg+kI/KeEe0ET0XD3A2RZB+eQ8YlXT0BII2SoBAqEk6eTX8pSuRat6ukPcIgmWOtOFgfHlxWWoCjw9D63OzYYDHEDelD04Ia9Thc4BzS1UkZ+xziowDVpnV4Dfaz4U/uwZ9QW5ywlZjxniTqhlw/K1bXhLNXcwmFo0ro8KP7W2N3fjriVtDhQ4UPqzDrXX38f6kIvPgA0EbpQ04zmchT47OCbZkCnBCuddf2TTtwhEhkSgl2yzh3HmJppYt6v25hD840/TvXm1dLUTuIwHzALavB7
 WWUrUmfr
 LLfyfDjUWLnkRu5Cc0TUWP3O9tyeORZFTgp7LYoH4lDfZILxE3Dl8lqYVr44dkOZdZa1exNOT9D/rqW8/yTfjdSf/2RdAywbs/QVy4VogjG7FlJrgG6OKKqJ2x1TCfOaRGYudOaTv4WlzRdXYh+NYzltAO1s8N/uQHjr+UPku2FUvyLtubc//0pt0C0hmi8rwXHOHancyt5WK8m5gfm7LHvnGxC3lajxhuNCgo91JHh7BnYelfiD4CZb4pDuAwou8cn8qdLT6s8tAwadlQtdsbKhsNldrh/fi5aoZUVEZ4KYD4WkJ1DLOqNNofBC0n4e8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 09:04:17AM +0200, David Hildenbrand (Arm) wrote:
> On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> > Rather than directly checking VMA flags, use the newly introduced
> > vma_is_kernel_owned() and vma_is_persistent() helpers in userfaultfd when
> > assessing VMA suitability for userfaultfd and UFFDIO_MOVE.
> >
> > Update vma_move_compatible() so it's expressed in terms of VMA
> > characteristics rather than arbitrary flags.
> >
> > Additionally, update the use of the deprecated VMA flag API when checking
> > VMA_SHADOW_STACK_BIT.
> >
> > A VMA_IO_BIT check is no longer required but that is fine as a hard
> > invariant has been established that only kernel-owned mappings may set
> > VMA_IO_BIT so the check is now redundant.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/userfaultfd.c | 21 +++++++++++++++------
> >  1 file changed, 15 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 949017e60608..ddf0a4a3d399 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1754,10 +1754,18 @@ static inline bool move_splits_huge_pmd(unsigned long dst_addr,
> >  }
> >  #endif
> >
> > -static inline bool vma_move_compatible(struct vm_area_struct *vma)
> > +static inline bool vma_move_compatible(const struct vm_area_struct *vma)
> >  {
> > -	return !(vma->vm_flags & (VM_PFNMAP | VM_IO |  VM_HUGETLB |
> > -				  VM_MIXEDMAP | VM_SHADOW_STACK));
> > +	/* uffd is generally incompatible with kernel-owned mappings. */
> > +	if (vma_is_kernel_owned(vma))
> > +		return false;
> > +	/* The shadow stack should not be written to by userspace. */
> > +	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
> > +		return false;
> > +	/* hugetlb mappings cannot be safely moved. */
> > +	if (vma_is_hugetlb(vma))
> > +		return false;
> > +	return true;
>
> return !vma_is_hugetlb(vma);

Ack, done for v4.

>
> >  }
> >
> >  static int validate_move_areas(struct userfaultfd_ctx *ctx,
> > @@ -2146,10 +2154,11 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
> >  {
> >  	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
> >
> > -	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
> > +	/* Non-persistent memory is inherently not controllable by userspace. */
> > +	if (!vma_is_persistent(vma))
> >  		return false;
>
> Completely confusing. Just avoid the helper and open-code this here.

See the other thread on this. I think with this as vma_is_volatile() this is a
lot clearer.

>
> > -
> > -	if (!vma_is_hugetlb(vma) && (vma->vm_flags & VM_SPECIAL))
> > +	/* The shadow stack should not be written to by userspace. */
> > +	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
> >  		return false;
> >
> >  	vm_flags &= __VM_UFFD_FLAGS;
> >
>
> Other stuff looks much better to me.

Thanks!

>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

