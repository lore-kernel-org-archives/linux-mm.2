Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3A63C98338
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 13:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6A56B008C; Sat, 26 Sep 2026 09:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 828446B0092; Sat, 26 Sep 2026 09:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1DE6B0093; Sat, 26 Sep 2026 09:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 357916B008C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:22:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 959C1A6CDD
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 13:22:40 +0000 (UTC)
X-FDA: 85255978080.14.ACD3ADD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0E35514000B
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 13:22:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gn1PEczg;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790428959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ho6ODA6dlgcOvdPnhowd9GgmBiom3Zlo2XTvzY/VTW0=;
	b=hjBcipGYbpksMF1xLyvE25EWHi1EGjyy4faRq9ohylQm+0DrwhWYYOQRYUUcqCXUDn9mNl
	nS+lnBZ4s+cEjd7v6g4o8PBZaGKaIeiTXSW0LOyeTa+eVvT11EwkTwZ/1GskVtshFTcsqt
	BY8Un8GweJYXK2+zogsf29JiL90cR9M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gn1PEczg;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790428959;
	b=Z9Gp5a+wk3z8ZC46u/scGB1WrdA0AVzRkp+CqmEqHn39OTzDuxM1Cdjjg/++IN9KAnAYPc
	ZBI/ZwE7cvCFEezDaV9B0hQ2C0xZ2no0RlgaGY8DtYiAlxevDSBFpfu5XzxAmmXUYOXe+c
	57KHhYwnAxWW5MvkmPxuUFCQduhI2/k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF426602D1;
	Sat, 26 Sep 2026 13:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B984F1F000FF;
	Sat, 26 Sep 2026 13:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790428957;
	bh=Ho6ODA6dlgcOvdPnhowd9GgmBiom3Zlo2XTvzY/VTW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gn1PEczgsD5J29kex3G7noDS0spUTsU0srsr+zO1nZZFuyKKVJFH88OWSVdctFAta
	 v7+cMia70kZ1YiuCIVpgK+S7YUkcgPcfUscXxMIVNy2T0tNen4vpOI9UIX+1BDQbbc
	 ePRW1SWCr2qEbUMLcslI3kLtHSdkz6HzShrhvUDCAIXM9cTBfN59vnzkvSpAY5sH1A
	 HiO3kEDoHq52UM6A/hwkWmFG1rbuJuaaijRW4+S7BnYNa61yNGGxIUvVs8xVjcKOaU
	 2ZsrOuBc7LttfpdBhGRS97sgpAQW2anj2l9mfgb3mnYHtFFH+/VpzMj5GLRW0f0MCb
	 rDkMkQL9UaUiA==
Date: Sat, 26 Sep 2026 14:22:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
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
	"Kirill A. Shutemov" <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, peterx <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Dave Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S . Miller" <davem@davemloft.net>, 
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
	linux-perf-users@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev, Takashi Iwai <tiwai@suse.de>, 
	Emil Tsalapatis <emil@etsalapatis.com>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Message-ID: <arfGmNiEngnO3JKm@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <d4d7d4c2-a1d5-41d0-b1c8-8ea0cc5a0397@app.fastmail.com>
 <areSEI5pWBadkqIe@gremlin>
 <408aef6e-5b0a-482f-8ba8-f8c20ee870e5@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <408aef6e-5b0a-482f-8ba8-f8c20ee870e5@app.fastmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0E35514000B
X-Stat-Signature: co9o7ukb33m7rnij8dnpdtz5rbys1ern
X-Rspam-User: 
X-HE-Tag: 1790428958-952467
X-HE-Meta: U2FsdGVkX1/m3Ccgf0hy0FF3Viyj2nBg5jbmi1T20+PHS0TG1gHa9mQSDa8VjjhasU4JK1ZOXS9VaDbjZloEN/4IytwTITCFCf29Nc/6lc6rRPLSDl9L2wiKYoP4Y0C6AfkhlrchyRhfZ3dsMwuhHUCJ3+x24i8SKHqm+e2jLFcYuhsXeI7I8S9QD/zmOwPWlyA2l9BbFY4C4b0yAdqG8czxOV86nSDq3oABeMSm0g00HsUNtnpE1rNQnvTFlpWUdsVOJm4LHW8VfF6/GyIlB/voZH+nU0PFsi6L0ObRYrH69ctkjOwUxdBgnrl50jlTDMh0bdWG1qboj9330/7ojmxpMClVtUBNEgJbpGu4HP2T2GVEcApHfsYV6QIjiboJGiWpJBJ/ES9v5MJqzIQv5EVyAzon4FC2idZR2ovXnAuCS9FC8GA1iofSvUlFikYwbdPcDw3D35m/NQ4LceK25JVXs9hD4IonP4az6NLSAZ14x/xmGYhLMJINI7W2GsNBIPmufTVcyES8K7Dfs7f/CSU5z3N7MqzeHyaijx2kBZjcvbwAhvOtBP1JkiWEfFrmhgdJUQRirQ/zOeWLMlj8llId2xdVtw7s9k0GkPGv9ueb+Ac6ZhjWsOX7sFD5PzoBcGleB8M0vpUo1fk/fMOKRpdh484Hc5NZAldBSfzx2SNkYavhuCWje25/rNRHUOBbuiMr8XmX57F0C0rZRpI5SafgBrhSSrWUHVT1iZCkLYRGtPgnfl73AsFEs/MrrQsMTIHSXl1FdAZWa6nXj8Ycl4z85b9VQ+ZgIkrZObY0nxwf4Y7IYjwSSLpdekn7kTY3guBXtDdKcQt2keFBhu0e2LcegLD2Nb/tMiKPwlw3LlVPKyXFKLxawNjSflaHySVIz2QU7FYWGQB232pByBIbF+ATI50aMtbJ5sagbXbQ4D+iAOZ9xBcmnbnveXOOaVu+RSp8jBBsNS/xLxNkA3B
 /dilC57Q
 +5QgSZD5PvswI78hrYJG/sfpzqPBVWA5J5t8bcHm6hX0OWQwnHCd/OXAtp6uAVbu1Fv2jBxVJMVDJdURq+yeKO8fx7pCaI0+ghhvkmRInCge94vjzjiJZiA3MsNxBrkD2klU8J3LQgGlYOgoEKqnEDiDv6ycjokcHY8BRVyOqejtSGc8YKKZufeliv5FXAczR4ovDLOlN39A+EPew3Rq2WeOJTb/Z8icu+v57pooB0HNP2eS9kCIkBt1AWEfCXjTBjKkEky/owcE5C3dhJqmVp5RxkC0GZ0K5FjbbUT7PPXnITlsEVvqkGuDguDJ0ePm+FJ5v+wImpQUH+hOhvX1Ft4QDF7jViMkkPTT9eKSeu4SpYMNKKW/ruRI4KurMcL9nkcIec52GJBLjqIjqdF8FDutrC/ln3ykTWSg4N3GDOcOASikAT9y+WWNwNM8yJSdvwng945ZnPjGOly+fIqwlbfmPaHhcyZkKb5Pd8/1VHNB3uAx+NK7rwGPCv6tKsGHIAWMRAIvzcabcdMSDFlRsJZ9jW6EN1HIwsI/ThmZ0Yda4wBRGve64mMt7d1AC7AQXIiVUSZj4QD5KTs8eU7aCwuyjhldt5RxPUYR9qooguKH9AGw7cjXd7qYBqRkbKUCk/rRzWg3peUYIrJzmZEXgpGPfe9TBz93GskwCn2S2SAXJGL0+YodbLjcNfCYXv3C9OND8HT2rSKrsWqDeiwfuOFNX4lf0nk+dDjwUBpFWTyLbUF2Fv32o3o34jZHF0otIRgKVSG1nzQvbW3eAIXOxLKLXp+qmZsKJaquyVHqFaOVuuDMf10e3XsArDZwfxNN/i2Du7PvMyojM/ZJdqrJPpXkwJ9i1Hi8ouccbvmwc8xqgbAsBz8vkL+nToF0RkPqoGCktjr8r3YejUpnkvL08+OzoSXbFgJvfHpES2nd1jVJdbBtmpVKb05ck3hvexE0RYf3cvu8C5eqUqRCjyIp6Fgmi1BHd
 g4xaHzL2
 ycB1OxHI1EXAAsPpahB/2e9UAzRYTXumhdtwR/iZjVPxR5utRPQoAfx9Oe2LYdW76btm6FkDHYW0FGp2GPUjombdhlnuFviCVwpN7CSdMiKwAK46TJ/l7uvpHxKEgLVrXJQzMnxqRyVMFfogS8E85o+Stqv1QKMVRt4+7UgP/nI+/Nzi1AAVci3zZa3Lm78ovv/kuyB8cTdxhxnQ7hAjBORscRZ6d125usMBHALF7DlJgwnedCMHNTVgQ1+F2C9ob3i4e4IqpjOZ48BfwtgypIk8Jqy170kI6GaN9O6/yeiG2PArrAe7ow2PB+Lc0om3boxSybkWfLIKpvHPUmGg9iO/Zf1FVsN4tirH0v05onQNraWvyOtkuS0tHVEQ705AilYowTuKFFKchY5jlerwri28UrVlsqajgWS5So1u7PsUpwoXFdyg0fWIupjwuDeVjS6XLHBSdvZS2in4n5wSwCYXjRaoemFb1iENsvWXA+Knt7gWkL9OSWy5/dewYzI8L/Y4XpJSQSsBmsmc2R+WJ7Y6HLq3Vptq9LBKy1uRxyBhl+XRvNU9ism/OKKmeeiiVy2yikKpAYKJbYnI062faY+BhHq9ES1OuvbydYGYHUq7nSZ5qoPXUtI9SS01LhJWiBqrkpqgJIx1EWmnbiJ3jUN4Dqw6Vso7k3S/srHXKeCTbStuKtJ45FtcmNy9Aiadqj71nHq6rjwoTQkkvBIhAdREySRw/8X/5YBri7Ec3120j87Q9H5CHTEq0FVBbbou30NISP1VFoOBejFCLzcgFDd1xgJ8zk+w3uCGAFquIY2yx3gau6IFiCoOprjXP4U3WxtnQRSk3dmWru6BThGs6JDfoz8ecTOydMpcHA+wy6k8voMag/k+29LTOrp/8UogozZ2Tfz9nWl9adliwRCbOZMhDsnitPrRchbkVuNjJ3svtkanSQvNjnWP+L1EjZoIvaHfYv4kPI9w816Jj8r8+Mx+YjPmW
 1muVi5s/
 j5BBleOqwEKPF3hyODDAtzZtwIshMDeFPWrAczGT9VwVTo0PChZXtxmU7XZtR9EKr0xAY/FSJl159UEl9fLfk+Od6XMh70LdEnjEP72Yw16ZCAkmMozuQY4GU9Yig7j8GDHw1P4x5uZ6kVOEOy7JLYIHdepbWn5bcier45EDwAiabZUP4waesz/DOgKhH74+ElX6MOdM1VX3s2H9gxfacOPYBFIIVTnliWQrY+2snV9x4Tu+wFxR35S6IqujJev6M9gQuHp8w2wZcWiFjNVTiIDh0HMDJfmVtZz/2w1K5IH49EV7lhdL4NfCJ+yZuNDHVqy3Yl2qHYgSFiyYXfyKZIc2aK6gGdaMMEqGROOpK46GBuA59w7Zf2F2/5GQTnBp3OsKCLYRoKaKKbxg7HlNCVRKJKKLQcuQv5I/17X+2pPLe5DFuVtk94POJsgL7KLgkDN3zmd1lE32A1H/bY25VCz9H1fDtclA3E+1+323Ge7Dkakd5O0T/DeX3JgvbkFpPBG1O7fVTY2OzZD8OtdOJrK4MX1Zzo36506Ady1RV/0+mFO/wfIAUqHmviOUW1MG1oDGMlYGtuAO0E8D8USbO+G1cu+mgK9hvKfWeMBk3pFh/Lcn82jRXRWG08JcweswgG1C3RFqFTeOpjYo0cEhr+KnLmbf+k6/yJreNjfko1m4zHKsbeokoSpKJr9kjNQDk0OOnoJsdEvP2YjRpuK3i9UzowzH/jLC1tsenguLHOFWHWtLZMFjboK3c4l4AHuW4s0flMFhRRQ2ftJeYtGIj/reXWxw1Hspq4k8bbWMg2Qf85MnJMzCL94zoirVSFsVYHE8P127l45Y04wQqmUO0r+wQdQ8kYuuBAcnfLmZN0AJoR7S+8L2xy6CV1eI7C3jX1KkdvJQ0R5Zl0qT684zUAmG4+Q9ZhyamQxXB2Z6J81ZPXXXQbN6gW2K8DYEEzC9PbCItaCwmsL6Yh1GQkyW4dS+OPhwn
 QIYIrBIo
 Qm5CVqE93rHIwlKN2fPBSomdstwzN9rTcVuGiG0qzB9o3TB5Gb4F6Y55RmHHQtPYMX7ZpHV6oWyHtQTVBVmn9XeJuqTIV9A8+JhrhHWp1wA/8LCXzHEoHy3NymOOdPuoRPL1ltwGbsOnGL4LFmUYytJkvVKBJol30cg+bayzmiVvO2kPRhvXYa/VHhqWhCOvYAsxQsUx4u9OsIajCn4xFhrDmxXng92kTgUdfgT9wMsm3O0HRyy1s9L3bxVw7ypOyyESHN6o2gND/7q16ytjOP8Da3RaF3OxEykRijPu5Iq/33kdZsjrBIfjTh7Xw8DfclPcEfoluooOfFdszeCw5Nd4SLSd0F5tw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 03:06:33PM +0200, Arnd Bergmann wrote:
> On Sat, Sep 26, 2026, at 11:40, Lorenzo Stoakes (ARM) wrote:
> > On Sat, Sep 26, 2026 at 12:06:22AM +0200, Arnd Bergmann wrote:
> >>
> >> mm/vma.c: In function '__mmap_region':
> >> mm/vma.c:3083:1: error: the frame size of 1552 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]
> >>
> >> I don't immediately see anything that you did that would have introduced
> >> something bad that wasn't already there, so it's likely just gone from
> >> just below the limit I was using for my testing to just above. The 1536
> >> byte limit is what I use on 64-bit builds with KASAN and otherwise
> >> still has a clean build (with a small number of local fixup patches).
> >
> > Hmm are you specifying this limit manually somehow?
>
> It's a Kconfig setting upstream, but the way I'm doing it is to have
> patch that calculates a sensible default based on other options that
> is a little smaller than the default (currently 2048 bytes) on x86-64
> to catch more cases where something sticks out.

I see.

So this is an early warning more or less :)

>
> >> If I sprinkle some 'noinline_for_stack' annotations on functions
> >> called by __mmap_region(), I can get the size down to 1144 in this
> >> config, but that doesn't sound like a great workaround.
> >>
> >> The large stack usage is potentially harmful if this ends up
> >> in call chains that have additional large stack usage (e.g.
> >> kmalloc() leading to reclaim). Any ideas for how to reduce it here?
> >
> > That can never happen :) this call chain is _only_ for an mmap() call.
>
> I mean more functions called /from/ here, something like
>
>   __mmap_region()
>   __mmap_new_vma()
>   vm_area_alloc()
>   kmem_cache_alloc(..., GFP_KERNEL)
>   slab_alloc_node()
>   allocate_slab()
>   alloc_slab_page()
>   __alloc_pages_slowpath()
>   __alloc_pages_direct_reclaim()
>   __perform_reclaim()
>   try_to_free_pages()
>   shrink_zones()
>   shrink_node()
>   lru_gen_shrink_node()
>   shrink_many()
>   shrink_one()
>   try_to_shrink_lruvec()
>   evict_folios()
>   shrink_folio_list()
>   pageout()
>   shmem_writeout()
>   swap_writeout()
>   swap_add_folio()
>   swap_write_submit()
>   nfs_swap_submit_write()
>   nfs_file_direct_write()
>   nfs_direct_extract_pages()
>   nfs_do_recoalesce()
>   __nfs_pageio_add_request()
>   nfs_pageio_doio()
>   pnfs_generic_pg_writepages()
>   pnfs_do_write()
>   pnfs_try_to_write_data()
>   filelayout_write_pagelist()
>   nfs_initiate_pgio()
>   nfs_local_doio()
>   nfs_local_do_write()
>   nfs_local_call_write()
>   ->write_iter()
>   generic_file_write_iter()
>   generic_write_sync()
>   vfs_fsync_range()
>   ->fsync()
>   xfs_file_fsync()
>   file_write_and_wait_range()
>   filemap_fdatawrite_range()
>   filemap_writeback()
>   do_writepages()
>   ->writepages()
>   xfs_vm_writepages()
>   iomap_writepages()
>   iomap_writeback_folio()
>   iomap_writeback_range()
>   ->writeback_range()
>   xfs_zoned_writeback_range()
>   iomap_add_to_ioend()
>   ->writeback_submit()
>   xfs_zoned_writeback_submit()
>   xfs_zone_alloc_and_submit()
>   xfs_submit_zoned_bio()
>   submit_bio()
>   submit_bio_noacct()
>   submit_bio_noacct_nocheck()
>   __submit_bio_noacct()
>   __submit_bio()
>   blk_mq_submit_bio()
>   blk_mq_run_dispatch_ops()
>   blk_mq_try_issue_directly()
>   blk_mq_run_hw_queue()
>   blk_mq_sched_dispatch_requests()
>   blk_mq_do_dispatch_sched()
>   __blk_mq_do_dispatch_sched()
>   blk_mq_dispatch_rq_list()
>   ->queue_rq()
>   scsi_queue_rq()
>   scsi_dispatch_cmd()
>   ->queuecommand()
>   ata_scsi_queuecmd()
>   __ata_scsi_queuecmd()
>   ata_scsi_translate()
>   ata_scsi_qc_issue()
>   ata_qc_issue()
>   qc_issue()
>   ata_sff_qc_issue()
>   ata_sff_queue_pio_task()

Ugh delightful :)

>
> There are many ways the call chain can go of course, but the actual
> stack overflows do tend to follow this pattern where you are at a
> function with high stack usage and call kmalloc() during low memory
> condition and that ends up waiting for a block I/O down the line.
> (you normally don't go through swap and nfs, I was just looking
> for the worst case I could easily see in the code)

You certainly found quite the example haha.

>
> > In general I am absolutely taking this seriously and will find a way to
> > reduce this, but my only question is whether this is actually something
> > that needs to be done in this series?
> >
> > Because it's already huge and I would rather avoid adding yet another patch
> > to it if possible.
> >
> > If I can do it as a follow-up that'd be ideal!
>
> What I was hoping for is that as you are already deep into the
> exact code that caused the warning and you can already see something
> in there that may help.
>
> I don't think it's urgent, I just don't want it to be forgotten.

It won't be, it's now on my TODO and I see it as a relatively high priority
thing to follow up with.

Will likely send a patch for it next cycle (this is about the worst cycle I've
seen workload-size for mm so I don't really want to send anything more this time
around).

>
>      Arnd

--
Cheers, Lorenzo

