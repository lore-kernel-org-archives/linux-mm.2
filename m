Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28800CC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30C196B0098; Tue, 13 Oct 2026 11:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD476B00D7; Tue, 13 Oct 2026 11:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15E3E6B00E2; Tue, 13 Oct 2026 11:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E21486B0098
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:26:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 64ABB1C478E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:26:12 +0000 (UTC)
X-FDA: 85317978984.03.E2AA610
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8DC23120007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:26:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PZOBya++;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4u/5yOQJ9DvGgmtwMCTNwSFdn4Bt/KH0TLY0ESMg1E=;
	b=z3yIfxiJB9LHy8j8HVYZ/ie9ijbx61Pgu0ciVD0TwjBFXkV3PIrILdUyeqAYqzlnW1NLFr
	qBgmZS+CBt8NMHBvh9Z7kUl+0XXQArTPW4iyzbiWXPC7lprCNZBhLTxo+/1A4/enGEFXq5
	b6wYS3Orqafw9aQA8e5HcfAumXbd7FE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PZOBya++;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905170;
	b=4taHnaJ1erHrwDKs9gaFUAhYNswi0xRD1QauWrMoJPjLlroon56wSDlZqkr3OPD0JA2b6n
	YIvSAAxY3fWbjNrsXJDaqyZKMxytun6kqV3iq3593boZrpgT16WF5XIvfKN+Qf9n7tulFc
	fz5U62kQvFF6pqJs22zzURTzIC0xBM4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFFF64125B;
	Tue, 13 Oct 2026 15:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7B71F000FF;
	Tue, 13 Oct 2026 15:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905169;
	bh=G4u/5yOQJ9DvGgmtwMCTNwSFdn4Bt/KH0TLY0ESMg1E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PZOBya++ukTznkcFehO8mUZ/500E6EjoUbkakGO4LAJjse/uybNRq4JgfI4l2XPde
	 biJU+3ftzSrE3lxabC/wUtQvplsNRf41l4nhCKCiqJxyYCs+QmRYLW863oL1ZzgQqn
	 CSKVQbdsvxSgBfe6D7sX2fmPuzgFEDU3PdZH/DNL9YfqfH0zQU6c56R0WQDWxNytCQ
	 D8S0OkiBTXs73chJpVcL5i3f3S9sWdgaNGbx02F95N2VeA85vk52wKbv4gp6Kq/1rk
	 jC2u7PVOECqeXedpj70EJihHLltFuDkTB1mjGIKBoiNHQxk5OTt0dsrY2Cjxo7vyok
	 0JLbZ4KqAQ75w==
Message-ID: <69ce0f48-aec7-448a-adcf-8cac08a2696c@kernel.org>
Date: Tue, 13 Oct 2026 17:25:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/39] docs: filesystems: update mmap_prepare docs for
 discontig kernel pgs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>,
 Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Xu Xin <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>,
 Bert Karwatzki <spasswolf@web.de>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-9-1aa3c9b139f9@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-9-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8DC23120007
X-Stat-Signature: ijrdehwmzpes3j5dobupbjysoqa66ytb
X-HE-Tag: 1791905170-904163
X-HE-Meta: U2FsdGVkX1/wNHAmN2i8JYbl5X2x0c2gWFZpcB/HeJ+GPZB8THmKX1Inynoz9ai0nTdgvaJH8g1Ne5o9iv13gsH7QrOhGJk6NjylxAf105yaFp5TjKQn4h+pk3+x90viS7gzwACNTebox3Ig2uzDBn89IADfvLNSlj99RGHeotdz7h8QRHjfJEsU7mCIreFGPEQ5nz5aDGNLkIKW4AVsetpgM5zOpOZub7ceMIHHPbur7yGLhlDFf3OKN5CTDYxA19W+5Sko3xAAqZl3eICQZw4aZZ0d7RUr7DGQ6KMuQ9b+sau9T2i5HKDeEsGiHIvZyPZB8tA4YoYp2QI9ZuSBowqpRQqqzQP+0yuwmy7fyc+I75T/SCmCXmgFJ7hdec8Saf4fHQosBfIqZa5T2pD22IDK+pYRlWdVFNXhVkdhn533MKPcHRLgpwtQ9Q8cGZoB0oOd27tGMSZRn+plGalPI/IUGGtcWjw8Nnm14fXdgss/50OnsA1xBAtK0RY6OlQLB7k046GYpANG20JYeTZhOoTqp8qx/FF7UOzUDYnk477otRPaRMpr3P5dNFtBM0GZUK/e+qW3E2vQLqfKuApo8j3A/SEpWgUs8TOhh8BexRmhLTED3DeP7mVcW4IoOMq6r84vav8O7kjg+M9UtecsDsYOmq1IJNVcrDPmsnNGLRov5/d7hsA/msPmmmJMcdF7uMCDHs0xVZaY2taPmjqZpIKrXimx6QfMDZDCJgYuT7e2+CrT2B/eL0mLWQ7w0LfsA7gGRpYbwA3YxIpXr+njrHPlp1JFAZkPMe6/t5+Y7wKympaEU1ZtRwXkNvz1qiuQrMh1mOwi9gf02S5VXwy3q7il8wG4f/iiy6Q/dhfAx1mdmyWUZUMu37IdpvieC1Q/yP0s2mV8TYZ3CeafRoASH4/B486Ky4KBUVK8expk2ftZNKX8lVFDL8MmTbpDhFWJDFUmkrcS7JTmEjV38hV
 eskS0jOC
 CcOn0drhBwdiqew86UeOhnZ/xD3eQbmqJYxofH+nduiqmX7/F9rs7JvL3ld9z65XHVCg3bIS+95vVCBGBrhgkzs2dyQLwXvV+RZxT7LE1JrpDMHs8AxkTtqkvTfSm4pEbY0gXdsfW2R08/EGkBM3MSQ4T33GmMrbE3HRQLfyD67qIXrGmbEgLLiY7G3V9ENOVyK2HNkuNFb+z3gUHMPwx/Zm6rWj4XnerjJoXppQphQm9bagKEczekbCJX5vpnd+Rl0p2zMtSJ/UxjO00sisMQOKvTCN6cxYE0oCPfWBAeNdVM83zKwIhfiknKl2Z+gO8WNZC8SPX/crDvCFmJ3/ta0ByHJVqXDgIQV1aJkBgJg1TzkugZBQfSt2LbMP7/RxDQU1tTivq6lqs3IFPZlnjHiV55lkh7nQaYRVZFIAn45qTwP7DN/NAwaO9fQ/OS9N+EHrc+oKfCGJyUW1ZGnVpPAoBHqHwJXGzNtmJeLwBf540XbjJo7QQNFBR4BK3mFn6mlMrXy6FqSAqu7rR+y6ul1z2ou8CQ4sZ2CI996U83W9Cn5jZ3ixAEFUtiVkgRFqL5cID1uza/cdLfdX08gpcNUr7EWenK1qa7wx+/7d7wTZCjamBTXIzESIRaNv6pusML1A/Ug43XjQkr+0an2UnSVL0YFzAHwL2tmTcTXOTmX+gnTW4ZAhg+wkAVBExrf4YXWMsWurt+cci0h27LGp5Knpixq5L9y2ort7uxZxh27TsZnW/UyeVAIO0QXgUWdNgoBwpDPQcHtioiopZ1CAqSzS0ZC+sh0wway6UfO8fnMlMc/LyamDUQnyKoPLTwyQRQuv2rBQM4hpY3jmARoInf4gdDej155TYwbY0E8Cm46sFGH/R6hkElhbG3R6Q3ltv8J7wo+t8j+FvBAZomj5320NmcqupbgwIEqRdQjYGXd8o1P8nx8ZhGDt9QnqDHzg6LbhC3Ns5wPLzTe+audLwpCFvCcYy
 HPovq7z1
 cm9huFIr6xBX7BHD1AnhF8LTCuDASS+8UXTUY2qagOS2u+TN9vHbkZuXFO5TVsGI0KkOUVBJ+Jcu2Zt9iTofw6A5jjlIRClo1h4rPRxlqnN3Wj/SKglJ8yP9pSLDMmyvEVeBo9f329NTWNPVGuH8N+L3f3IlEKHjPxNFSsY7RlNoNY0qXpgPZojG09iqNZ8WknkdIESPC56ETRdreaABH3hZb7H9Srkm8yXf2GGJ+RNnr8KXw8yEH3i3c+A8U8sRKCUSJl9iyHKjn1WDj3G8bpCkitXGIWHOEfJEVMAx+3jCfqfWLqR1BVSyg7FVze99mVkkR+9ay2r66uT24T/xu0N6ibTVwC4IR+YSVUzZG5q1M3qJbbatp5ucciiesoZfhwJzReFn61IPnIj26JYIVuq9MNgZ+HS/9oX7m2yTYsSvedA5a1lshqddQAVHbkaNNk9HYZRPLV1U9pJBB2rVkJyySmnIOe3BOhDFfYRx/jhhbzl6hEnRWbQQwJtpnXfZp4MSlQTygV8JmrvnH8MOpsZ53baBnzx/M6BZqnAdTD0D9m4q7sTCfeKM0sc35RLGHvThXzyknZTUxO+F7r6d+AwN+z4q702ZuTXChNKfLs3AJBDKGrBWp5NFdQadMXAMnpm1x7leREnb1YxvTyUcR0lqnAyRIr4/tSGDh6GVb0V0h2X/7TnESHvWMhvGYSMrcv5NlZwEXrsi6fSuWR+jaIOKmV9fty5H6fhAxSiLucDxycHpaRWuKukiazKuuZWY7kvo6OX+OeD8+fpHxDesJgYQUwyvboa3I1xTrX1qRyYHuul/yBLHf+rn7Pnx4nSrpjMx41yDjw1Z9n5q+ZMSDw20H1JTU0CIX0fxIMrUSharGv1aJUFjbUiJUB6GU8lEPrBe5n1RDNi2k0ir+wXMCPmD/2spHWuu4D2GAJl4xVeFT17B+f0SgXLeD9oGE81dSvsr5pUBwymGWCewIlRf1Qk+8xpQp
 XRi2ScYB
 gj2kFhnYGEYiZ+fQpAQ97deQFEyN/ALHztRPJcBofRkwbxr4B0FXQjrZNu5ctRrbOQ4TWxwjM7n8aezBdtBa9WHqqpm0O+0k9DS8j8MHoy1OJMX6PW5giIDF9Buy7xk/Kw50jYqQDdJ6OVVO0dFomjq8BHAnle5Buo3ojI0AkRgBJIjQ83jGyk8weWy0l5PMBgcH2BlLCKHVMq97xcq5vo5hOKOrjsso0XM/vNMoRp3DlYKTmXZINUrE9M/vqspPhk5Rdsm7/KNHMq/t+9ztHxkeNh+0QIihMYId6mEQCuca6IqHZuplGvQOCyD3u077zzucr80NdN0bcyQHcVMaUmULcQzDiYik1H0ljU6oU0MGWTHeWenDvtGCDldSyXd847e/wJX8aPYXtvBKzCVCIZLqmrL6AlG0/mRqPbVyWShUvnN2rO1Bk4PovVgArBLVt+BmcSeKn/zh6DRAYdUjRjMejkzu8RltUX5s1Yq/88yh1FRRsWxITOdVwvpnVAnynS593JjD7B/mnlc3CdbhpNoFFFkaRpLfyt9UAwFYNrrLIXRWQShqXeG8oA/iAnGYLG8VU1Ny9WTPoMrmETAgWIuBw9Y+7Qat3IiwctIs7NH1CrdjOpwln8GGMZlVRHNGAN7gswZuyzqEKMUyoRWZWlM6qEehhCT7QgOm7bWCD8B9r5M8jfxZPaavbxFTI7EVYI317uF9kWI6qVmsGQ+a/qlwrVuvzuCEp60HQAVyjExchBFgL//VLGU2D0bK5k3MgZjXcqOF/+DXKI0dCfaIMquGe0hJObZnFa2BZ132wRwWeFlyRuAUYoIFpZgHqgrGynlk2Jv425V5JIJWQ4ZLKbPHWsqcYKcJ6VfB95feV8k6u4qNWMGMPLJTY9IyhZWTSyGNW2mxuFxTJjZQAkYHIQwLx7fsPkBA3266QRn7iWcs+fQEIZPllWNsOJA6hO59V0dfqgY5F8S+/iBIX6WoFHqIJMGRH
 svEmpRcu
 Yr8jlC7lO4Hmhncw+XXEUvRpBl+TOD/esb9+dIbuscxr53+nUVE5h0y2lfiY6l30ksawojJ++dTkdCmSSLlqP4NlEHow7AdddL86Xwd2wpWUL5MjPd7bgr/Crf6txxkBCuILxH3HC0VlnMIKHKvpASjQBjqzVkevrJMaiX8xittIQvzfFabBSSByl8Fvho3HdTPCWjvpv7HVsIhyo1mZdgX5c78A8g83Vi2MC76LdKV+TnZxVd+lbF4vn+QCKChEJ4XkjDMI77z6CSTB5sc94d27ooKBKylKtwhuCZemRfVza/ki7I03bufT6UfdvYO5pozw8UUN/zUM5yyXwQsyYcx44cwhUOwbpEwGrRtcydaxKC3RSK5suS6KGa4CEB8Eati3qd8EAjtAg3PGZRx+3Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 17:04, Lorenzo Stoakes (ARM) wrote:
> Describe the newly introduced discontiguous kernel page mapping mechanism,
> detailing how to use it sensibly and how the API looks.
> 
> Explicitly detail the various discontiguous actions available and how to
> use them.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  Documentation/filesystems/mmap_prepare.rst | 81 ++++++++++++++++++++++++++++++
>  1 file changed, 81 insertions(+)
> 
> diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
> index 82c99c95ad85..b5afbb33e5c8 100644
> --- a/Documentation/filesystems/mmap_prepare.rst
> +++ b/Documentation/filesystems/mmap_prepare.rst
> @@ -164,5 +164,86 @@ pointer. These are:
>    sufficient entries in the page array to cover the entire range of the
>    described VMA.
>  
> +* mmap_action_map_discontig_kernel_pages() - Maps a discontiguous range of
> +  `struct page` pointers over the VMA. They must span from the start of the VMA,
> +  but may terminate prior to the end (leaving the remainder unmapped).
> +
>  **NOTE:** The ``action`` field should never normally be manipulated directly,
>  rather you ought to use one of these helpers.
> +
> +Discontiguous Actions
> +=====================
> +
> +Some actions can be performed across discontiguous ranges.
> +
> +Map kernel pages
> +----------------
> +
> +To map kernel pages discontiguously, you must provide hooks using ``struct
> +discontig_kernel_page_ops``:
> +
> +.. code-block:: C
> +
> +    struct discontig_kernel_page_ops {
> +        int (*init)(void *vm_private_data, void **private);
> +        int (*get)(struct discontig_kernel_page_state *state);
> +    };
> +
> +The ``init`` hook is optional and allows state to be established before the
> +operation starts, for instance taking a reference count. Nothing is invoked
> +after the operation, so ``init`` must not leave locks held, and state that must
> +be released once the mapping goes away should be released in
> +``vm_ops->close``.
> +
> +The ``init`` hook, if provided, is invoked prior to the operation starting. It
> +may update what is pointed to by ``vm_private_data`` and/or ``private``. If an
> +error is returned, then the operation is aborted. The ``private`` field can be
> +reassigned.
> +
> +**NOTE:** The operation may sleep between invocations of ``get``, so locks
> +needed to stabilise state must be taken and released within each hook.
> +
> +The ``get`` handler is the key means through which the operation is
> +executed. The current state of the operation is provided through ``struct
> +discontig_kernel_page_state``:
> +
> +.. code-block:: C
> +
> +    struct discontig_kernel_page_state {
> +        /* Map state. */
> +        unsigned long start;            /* Start address of VMA. */
> +        unsigned long end;              /* End address of VMA. */
> +        unsigned long addr;             /* The current address to be mapped. */
> +        pgoff_t pgoff;                  /* The current pgoff to be mapped. */
> +        unsigned long nr_pages_mapped;  /* The number of pages mapped. */
> +        unsigned long nr_pages_remain;  /* The number of pages remaining. */
> +
> +        /* User-defined state. */
> +        void *vm_private_data;          /* VMA private data. */
> +        void *private;                  /* Mapping private data. */
> +
> +        /* Users should not touch these, use discontig_kernel_map_*() helpers. */
> +        ... internal fields ...
> +    };
> +
> +With ``private`` being an additional user-controllable state variable,
> +initialised via ``mmap_action_map_discontig_kernel_pages()``, and
> +``vm_private_data`` being equal to the ``desc->private_data`` field set in
> +the ``mmap_prepare()`` hook.
> +
> +In the ``get`` hook, the user must choose how to map kernel pages:
> +
> +* ``discontig_kernel_map_abort()`` - Call this to abort the operation, whatever
> +  has been mapped so far will be retained, the rest of the mapping will SIGBUS
> +  if accessed.
> +* ``discontig_kernel_map_page()`` - Maps a single page, correctly handling

"single page" can be misleading with compound pages.

"Map an entire (compound) page" or sth like that would be clearer.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

