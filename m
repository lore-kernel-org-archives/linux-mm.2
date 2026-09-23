Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EAA0C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955AF6B0088; Wed, 23 Sep 2026 11:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E246B008A; Wed, 23 Sep 2026 11:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 844116B008C; Wed, 23 Sep 2026 11:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 677916B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:54:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 511C9140520
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:54:08 +0000 (UTC)
X-FDA: 85245473376.18.D5C074B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id A9FD820008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:54:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kO69tl0G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wAV8stNGXVD0suD8B1a8qtsl7mm0RfyqHixhi/NZx3k=;
	b=tXVu6pCG/ZIU4YmDY+YHMLyT9wOjBrLQhdbB0WeB66NWn1hub4kpZPDgwMyoDltFcNIsuA
	cuP82dX2T1kb5pFVZD8yqD8NlRUaiDGpyUFWS6dyzSPrjw0cbgnjaXUIkyWMg18qKt7qf2
	cuen4/6se67Cw0IeXKqbqHCdPey4Zl4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kO69tl0G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790178846;
	b=Wxcp2HTiCMTs5SQ8bdmRly/YOFPAGZGojB7TgTP2HKxfz9u98bKbqjBsKbed6tKbGqVctn
	L7cRGYaCSx14krUrHIQB1TC/zItJgpYSizkW2dafrW88GYP2joyAUflRb2qHdnrHVcZ0hf
	oX1b70+o22LsvIdEz52E4+zH08GyqGM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 857E960D79;
	Wed, 23 Sep 2026 15:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF3C1F000FF;
	Wed, 23 Sep 2026 15:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790178845;
	bh=wAV8stNGXVD0suD8B1a8qtsl7mm0RfyqHixhi/NZx3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kO69tl0GVqEJBDtzXtj722GeS02r981KicvQg4cQHtdo8zYbHSuzX4xKugLSuxZ80
	 hNKF+inpI1rG93f1F5QhrTtVFxLcKRCTL+snyRWCp/N/q3HEczsFeIqExmwrr7tt/Y
	 BvYVVTOYIPgApkyrBXMn24Qh05xMwuFcGHVzqgJTNe/gle65zMUCXYN6+65S4HSHY7
	 tGBuhIwWJ1Pazb14YseddKo0V64lXM6Wy4pe1LmUGi7p3l+GZYljbhlHPVyxqBuygF
	 nqC8DLo3R+mPNhwr+2JNkPsIA6gODez9Nt0VUzmMq2DMdlQhA1/ymS6rMHMT1y9mfa
	 Lr1sgEWelyeVQ==
Date: Wed, 23 Sep 2026 16:53:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
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
Subject: Re: [PATCH v3 02/40] mm/vma: predicate setting mmap_prepare VMA
 fields on new vma alloc
Message-ID: <arP0oJgrgZlgtrb6@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
 <CAJuCfpEa8tUmYJBjx-cRdAE8y-jcKY0C81kAOa1QZS7F6tKdfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEa8tUmYJBjx-cRdAE8y-jcKY0C81kAOa1QZS7F6tKdfQ@mail.gmail.com>
X-Stat-Signature: 3kttfq9mpk6cfoyj58s6jsp3drkrsij5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A9FD820008
X-HE-Tag: 1790178846-975713
X-HE-Meta: U2FsdGVkX19C+MMYCZ+hIaSCOI4y/VQd5AUYRxvpCV3lgYJg0FaJNOZ1P8oLdPyuW46Qs+VVaqxfqHk51jVyII7penaJ9rK4TUxIuD55SqI5RfJS+UxiIeH7j78nXGULlZvkxJRdqACXEI/UcltI8KQDfL0TUW8VlBuLnIZWIgQ4II3RLKFiHsDnJKfWnXjF1CTHd6XwGSUEX128Ra04XiG4lzSAGtRp0qrC5ETNa+AKDFxYWxOHJ6K2hGRtvakH7A6ijb2wFsY8CrMJXiDohStDRdTB+/zqjQQB5v77BcOOywSxq6zIDxc/pVgVvWT8T5AcrSOQLzjlag0OoZG2X+7v85+1e7rvZKEULTjT0oQZINs4QC04axgp20idHa0JqG7alB9oQkGRTORq01/8Z+AjfKLZI2AyXmCd2zCAHLeAEYeHnND7eCMq1gAdytIg/ueTTnpSXL7huE7bgS75rPsnqY7QGoH/uT8/i6/wktjZJ5VEZgBPk729as6svo/8YIE5ZYYvmsW23zn6+x3LgrtEV7gAYPtTtu9MbzaSby41xBoF/055QMb3op4IiVvbAXgNuwEqCSDtLaPfS7JYnqymkXnLNlYqPGVlM/Gp4u4uH6Dqq40SnXMZ7dQnCIQkOlDgYs9WmxVhjHdbCPIYHk8FPw4353l0zXFRcARxuG+F0qgUSUoQvonHDNERsFVDF37Fxn39aw8x61u4MMCovYllDdxFwJUqbMs8YLn4MF8NNMu2Xs90+W7NNv5eMip5f4WXXaEAmdzyupUaPsBEL7iOkkeKeOhi8P1dOXCtFRoH0Qg/CWb6zfu6oDt38qxWmC2KMjijK7KCg294M7MTdOH5w/ut92UKQzJVUqflxBM9UsGDBbHufq4Ikk9t2KLnWftUBU4FBPsWlBs1S7SWijWPcfaSsmRHzY7Ksc/I35OrqNgnmSAuACVVo4uaVmzoBUp2j+ljC29wyz2qVQy
 OqyEgYQz
 rnG07l7+EnuOSkNT8TH/n4m0kd/9iYExtUMkXs5WBHwL6XNS0b+E5CWP2NrF7y5fYfqQUfuK52LFOnKpzIMtLzc2q0FiDb5yDhVBNQT04Jo9bsnbj4ebDAoetjDnGOdDDszgK+rpiq2lSrdrpGfSu5eMQQ+4pxhbbHP1+6hOf+A1sAq5Mdlb2w+60/dHQx0lU7EFGK0hP9o6EgVGBFocdYh82O8B8VIxP8vwz0SGgXpokRj2beB3i54vEICdFVDi7S/Ixlv2Wsz14DbjU0q680uOsYiI0hlmJm8l9C9pW3efIY8rP58EOv39NqKqUyA78nCWjpesx9tTJXqsZXcupv/WIu2vlxXxhqpEaoZl+f+HdoCcsRliLyAOvLByudPXDpKW7eIDubED1wpMkESIOYbMWNAxXD/DQCGqRgzqXOFthjDqAB+tfTfTi4i3vRIT2vFiIrMWnJh7Q19qJz4UbPYUaxR18u4xsD3b8BFZK3HzZ6y8WPenncqEFYnC9020IVZd4ZXPFJMhvpv5Hz/jFKq8kilF0heUr30xaX0gcoEN46knkyyfKCzTzrNTrT2EleFU26GqMrIYrH/1lryqxXygtvEyAy0xdfHkuDmHsP3MR0xzEO1QyeLk2Pz54u9WVp1BhyqxtvelvwNeVuBDwPkw2TQIi4zUNLr5JKb3vFvO3AdAL9ujE4m/RVz8XwrfX73ukYXneA7hP9PRnn0TFUuSUU9aCrKWHfNEw4K3tq5bXR7bNw8OmyYE+Kiw3z4K92psbJjVZSIxk1hGqzeLcGW3kCn+qHyqCdICQG3k8DDpGdVmgvX27KcB4ExjFiTNpblI2xf60VnwbBXh9VRz4XTQOx0UyaSHIz6AQcgtCTi1HuGzrwyvkYsCgm7d3Hjt0dM89M+R9MhcpJNo32TjSFHFcjT/zYklT9PdcwURCUUyJ37VUbkjYmIi0mzvmPkjkNZV1kKy78U8T61Th7Peb3ueNIsys
 xt8zGdLU
 Kn19HfmiQjq1cXoftQjILpmKHp7EsxxcGxQFtWMHq+bosmcv7RMpdsIpf2O/YnXEiVgIYJFmtZOOE95MeApyS6vTwmUZzCQg3zG1iMP7Gcy2gdz61QMBae0xxGYC3Zx8OiVr7HxDQqAnpua3jm0Nmbbyvh0WDOJ+47+0nkRbzJuZdSvz3F08pzXZ7F9XY4Rrb4iknpOnbpfecAumr/37oPIbvsplvH3Iv2rJL9cAFpF6HnezpT0zPZl/vbgyDaEDRx+nGQwbSRnb786s2HP+wyLU1Di7HuizeX3TtRxGLsA1Tnz0K2kkAf2tr9/9QFbuJWJHol5o+fQ5fWvfo6wAatPHwRCN4e01oGmL0Qjxaq+XH8atkUu7vzp59HbofJixn17TVzsvq2AZarCxbOypco3TEwWDT3q1aMbzZrI2Hu1GK0B2JkkaK+5suTR+U2IHFkrQ9WncoWuMfo43oDuDZgXS3OxvJ7sBG6xM0+aPr23AVVUL+D6755uTDBEWX7mahvAZioaYAslgmJkH5f6k/GSoZ9dEzBHZYstFutAUB67vLS1/2OTkpS1ag2KJMl1g9avOSt0Yuj0tiR6g66tdOMoqlDJmzXXb/2r/oPqgnP1GtVhP+XMDTc1Sa2aoGVCVe9HoIkaVRV1dOZ5fZmk6Kk2HPVjyn4dI8Ri9P84SsT/mbKleGXLQnIIUi1bw4ViA1C+YnEtUj5hqAUs6ckcmsAzJhFsOHg6TBcvO3tZRzfSNjDXARM6Utl7WYZ8y+fIIB7dLvmGgxyL1TWE6BqMxGtPNJtiWPB9Tc95zxlpH+cS8J8ysGG40iFG4LydTF9De5dp1zBtVRxUy/J1eCFCMzO0W9YJrnU+tJe7zWS6/USRAIPZWKWY9DSgFijK01CHYQA1JALuyfSOj7JmYLCJHv4wAGKWV/qu/SOlJgpbKKDh3x+nq+VKb61Xz5NvhrrVlUfeVCHQoZualCkaawEnFTGl/xMly0
 N1tQgDFn
 ncXbnQTrLvxbVdPp99RHRr3cZDsTCwqBPm7XmwvGaJ/dqEL2S/1Izxve67DuhWhnE4mU+c/VnGMfofuzaEvaLOSZcIjRzIowbHwlI0D8qwveCCqRO/IN6XPg0jagCwhmvUFmvX/kWqY+iSwMZlcPZjFT0qJMCyg4u2aC4m7Ajv959We8IvpY7OoERqyxehG8gVHerXPR3Mflo1dzVndsF+ODmzmr5OANpAguXz+Kotbb9+wprW4IyHeaYSvVYCv/8iN8xsO1Y+wC9jAjn5ieoQHkwhmH/f0RKlwmZChhaJElNDceP7RgpzX57nN9XSUYWJfpM/ZZynABu3zEPnHO3oO4U4TLofnr47JoHs+QN/+0WbFLO/vBU7+Tja/FeoDfUHUDecoq/6/8WAJbG3AQRO0DQc9QZk5RBlY9uyJcm1echnBoCAQok8Tjq54N4gMFQPzO0WBN1jr4u2LIF20GWS98gBAsRAkSLOV3otgDwJP94MnPMCwHoJkYmlPIOAPCIlNx21qsYanwBfpnBjfje7JpE+UU1M3DgH4WHVLGZZNwb5kwe+GiiPHw2uenQLXgCwZRPn7aJ0K3BUk+HPwXjTmShqbJrPsgm1ptaL3SSfI/Pyl63Av95/lgHbFIyzI+osfOo4kg0dGxjSMo2Ogz59b/ehQKuWnKsyKw7kk6wBA8eoZzwLqmk9T4kLD3MUn9z5Cr+/ip+12XitroHyQEwZAy/tP1O9Xe3ohqF8Iw/ctgOVxqlkUpTl3nkjaFlNulVI6f7L3+QlG5t1qLhL12xWvjmmQ46a+i5Evt+SHl6bBne1o/Jct1VR7vC0KUQQxChxnuygNGmAikekT3XDz8tRfyPozCtHx6fTv8egabx60Da01zg3prOZIYFZ4PGQnmANOPoV93/J15QgptJAdDPZkumLee3Wyd3LPWFIdk+beRxzyypHrfcP38nqxaP7BpW/rG2k7/XfyFVirRp5nTgIew7zMW4
 LzMJkIvw
 2urVSPZopygCUCl37v8NP10s7B+EZgQJcyKnpZrQQRvre7GPMSsRbkCP96uc6VsGD0tOVovwD4Hk+TvzbY7dTRH06lxmE/VxXzgCm8w0s0vBLQ5ogQ5NokGiPYmhO35JjpeDq4a0bBsEtfI/y7fX7oM2cEFj0CbaHJqND/0AzoTPtCYY4JQVk3bAmwkf2dXXOE4hPr1Qqmau74soJbcMYwfBpvnkjWAFRht5mvY7o27SEEqoEK9tRkotbTfhq56oE7V8rLVlP+4686XCcujPDHUAQF3afO/sxe6jjkclEInSPLsmTt49E8GUuqKw2L1MIxJ7h05E/uhlHofCyrG1AYhos1Qu4BSiUueha6JI0YheK+PGfdEA8MAYyQpU7VtUl7PefUPJirGLJ8YlKwaW8/dfGMmKM5txY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 08:32:43AM -0700, Suren Baghdasaryan wrote:
> On Thu, Sep 17, 2026 at 9:24 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > It only makes sense to manipulate VMA fields if we allocated a new VMA,
> > rather than merged it.
> >
> > VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
> > keeps its own, which is also what the legacy f_op->mmap path does since it
> > never touches an existing VMA. Previously set_vma_user_defined_fields()
> > overwrote the merged VMA's fields with those set for the new mapping. In
> > practice these are the same values, with rare exceptions such as shmem
> > selecting vm_ops based on whether the file has been unlinked, so no
> > user-visible change is expected.
> >
> > Make this dependency explicit, and additionally constify have_mmap_prepare
> > while we're here.
>
> The fact that we might be overriding attributes of an existing VMA
> that we merged with is technically a bug even if we never hit it,
> right? If so, should we have:
>
> Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")

It's not a bug, it is an in-built assumption that the state used to assess
mergeability implies the same properties.

And if it was, it'd need fixing a different way (check the field for instance)
and would apply to the legacy mmap hook also.

This change is needed for the series though.

>
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>
> > ---
> >  mm/vma.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index fa784f069da4..4b74b48c29b7 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2894,7 +2894,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >  {
> >         struct mm_struct *mm = current->mm;
> >         struct vm_area_struct *vma = NULL;
> > -       bool have_mmap_prepare = file && file->f_op->mmap_prepare;
> > +       const bool have_mmap_prepare = file && file->f_op->mmap_prepare;
> >         VMA_ITERATOR(vmi, mm, addr);
> >         const pgoff_t anon_pgoff = addr >> PAGE_SHIFT;
> >         MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_flags, file);
> > @@ -2937,7 +2937,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >                 allocated_new = true;
> >         }
> >
> > -       if (have_mmap_prepare && !map_is_anon(&map))
> > +       if (have_mmap_prepare && allocated_new && !map_is_anon(&map))
> >                 set_vma_user_defined_fields(vma, &map);
> >
> >         __mmap_complete(&map, vma);
> >
> > --
> > 2.55.0
> >

--
Cheers, Lorenzo

