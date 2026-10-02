Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 846FECA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 06:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 805F26B0095; Fri,  2 Oct 2026 02:58:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6C76B0096; Fri,  2 Oct 2026 02:58:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67EF76B0098; Fri,  2 Oct 2026 02:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38DE56B0095
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 02:58:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B27891A0615
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:58:10 +0000 (UTC)
X-FDA: 85276781940.09.5F70694
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C4C7A40009
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:58:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZEml77Q;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790924288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fu3Iu/gEhueAyG3mvEvskapgxrTQuPV0qPl2NW4TdO0=;
	b=jHfjGsUYuxxGqOfpPiZbyUuN6zdsTYIVVtODConfTTOyzUXPOLAjW8+aradHLZqMmtLkL9
	ZK1HmI2dNq03IxmBCDX8COmGfJ3ORCCZHVWhLlZYXUe0n3TGNcuazrAn6mxQv9cNnaW18w
	UjLBSXLu67sb7M22sMWyAmVRRJydprs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790924288;
	b=ikQ+NuUU6fxfKqc0FXO262zKhRJrfxR8J5X9GL1VXr6YuUIijwJPEUehvpRmNrkDnS7fq2
	sbX3Tp4B+ra/ZgvYdIzfZFu9djDBQPmHLTv8K0oOYBoQUKDhx8HG1dF8U4fZP1W9XDHYCo
	CPGWE8s1v+kMz4rE9gJ+0SS9MAztloA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZEml77Q;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 00145403C9;
	Fri,  2 Oct 2026 06:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A201F000FF;
	Fri,  2 Oct 2026 06:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790924287;
	bh=Fu3Iu/gEhueAyG3mvEvskapgxrTQuPV0qPl2NW4TdO0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QZEml77Q9r2sTAkkCtBoHvaT+mj+1tDODZUrLGqwvtSwG246NM65eA1dzYWxf7YW8
	 FsZHsJ5bHXSNrjOMhjIn7vxhTfqBxb5BbIaCq3FhBRTvTnT4cgJaMPpemcORNqu7us
	 KZ5vOERy+jet9qfghjrMSxipKIy8nSINWZMt8JI0W/EcqAmuf1XL8JBjreMbrM0wcX
	 Ag2ygVqLrNx0bed/Uo3rgTOX0dyCxzypBaFxKiNkqAIo5H6yaLty1QyOMTBxvr6K3J
	 7fZhyvWOcYx5fyoMuZSOY9MxO7T8zpbMzKLeD7GAZRKRiD63ibsiIJtYCY3a/tMxPp
	 zCope7IsHy9eg==
Message-ID: <c832c064-15b2-41c7-b785-bff1bad5977b@kernel.org>
Date: Fri, 2 Oct 2026 08:57:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 30/40] mm/madvise: update is_valid_guard_vma() to use
 vma_can_merge()
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
 "Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>,
 Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>,
 Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
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
 fuse-devel@lists.linux.dev
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-30-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-30-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: hsschkh7j3x1onimmbdit5osmmxj7iy8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C4C7A40009
X-HE-Tag: 1790924288-715871
X-HE-Meta: U2FsdGVkX1+2CHk/4eBmNtTznFrWKUwFPxI8BxpqXUBLYj0AlQcu1ajdceFY5JW83j9pgI8C9fEOSn6Ka/SqrbZaw7+NZ4moTKRQTcXIwajZYj7b1kJzxQ6Miah3qm45A2ye8Caso8pCSJpnEdFkzoyc/II8bzljMgthi9bSt6w/9rcFlNj4culRFl7KF4UXYJLaKZ5sw0jsiWqcYjBLwujdm1U+wbRVIuHtJqQkQy2ZldNMi10ISdhaLkP2PtSsaDhraZ/R99/n7B7yJ2dYKrFIUtTJtu9ec+RP3XSzk0UB6R1yTqFtzyTkPZ9eamdz9Vi4Y6kUC9jvtKjTojVefC5FCR13R9eyFtmvd72NCvR4qU4ZHsq4gpgJxMYxYoRjnv4LfNL4h/ts0B3mL7CYFmlNMHncP7ngbJibkRuZgnGZwWnGjk7u6AbHQxEWNFiDIizF8E+B8aJ2nowH6XzidHYNdFsviP6LphisuTlwY+qpuU9FyvLf75K+Aa6kgc6gdUjqYtG2S3B6RT2fQeAg4LVA8qpp1OZqg1Nr3DypHJsnXXtyrpmQfGj5hnJyFlyfHXTkbDOtvEJyFY7ipBGLrV9XkLs6wmYW9Lc4t1jMZjXJK3j5gX6VkD1ntDI/g7osocZ21/kJErBI/0OP8lGp227P+9LyOJphhan3DNyVUKTRLHwcc9xpgb1hpPoObm4/hboIaT/J3PK8hHFMhRe0Bn4l/wwdH2WLpI9hxG4o4SDnPx9s29T1lfLEx9M6rlTrx3tVNNJ5YZSe0vW7u4DNKmazcMdUHFacbUCxUIhLA7v2P70b3mK9Vcdu0EKVDeRc4LOTN8cLnHzhbuzOt51NHmsMSdyuZRU2YswPA+ntcClJPtTlME9Y2oKknuno7cgChU7/y3ngeD9JS0GG8xfKCPBrj6dgNtLj5NHLlNp2TLvvMGPYfJePVeZkjYNJQn3SsLBZdmXD3/8yPGVW7gA
 7ApDnaHD
 t6IvTdELMf5cwOsWxRXPxt1EWQUO0fSCZdK78FJY3BC4znXREkgoEXr7YR0A0TEZzLAYWpwRfxrxzoYSWBjRZnMsMfT1UE+Nbd7GVmg8EZsLESdcfytoF6VMLEsad1GqfJamknPTnPS/6BW/D/ddT7dg2qC/Ypy4rxeTy5mdNfBXv/MaH3rlyvW4pu/7Sv63XkTOI3B20rNtRfzDqZXvix/mkrfJgA14nZoAwbeXvf+PwszaOQ8QHeZolFPOBSBsuM7DL3qK82M3IVB9ewvi2+XH+FsfGbC1Wthg/+cfaEARZnM3CXRqsyMEduBwyGlheU8D9v4USmZWGHzCgqIJga0qHtG0Sef5Y4OajnmUb60cY0kxQf75RoqF8uc8mGXoFbr0/7qSjAauzJ5wMUezoJJRElAplo+pS9xYUGyczyLXxmZf+dPjFCWvcKydEm7xqbbIXjqfj0nOG92silCjp9P+fePjmsZJfo3YmHl6G2DQzBDUxSaNRvChT0Qn2xtA0c7Uvz2fUVJ9Fob6OlFEr9t+pD3+TxO7hXxDksT7rkJXmgK4LBSBihhUWT/N0ZmzAPmMTWMYZ0qrNIK+Do0mkj8yQeQ/U9+HP5vRZ4L+UuGP5K0jYtyN6WIuHpYeSHawMxsmIxfSFLU+Ybb+TunBQO67PyoSTlY/n7LvdgnwIADMsPk0ErOj5A3ki8lMPneplujuEY3YV4VNxo+NSqJYve3l4zX6QQX4y4AZ8ftPIv3XU3IJpkb1iuTOkHy9aUWyFko+pZ3KAkk0J/7rFYj/4UZctYtO5aDcU1EpHhctRC5kQk/Z5LEUefGWnRjRY60l+39IaC/kH12yPxmvepoaQd+P51l8inFUnc8bc+9+UuisYAwYJQWmwD1/GwNjMb6Q3D/y8b5Hnm+89SvW7iy90L3owM3X6I2NnB8914KIVP86SqQ9kbdnLkhAs4DKN7bGb8ZG2X5+jSDb18GvgsWEJO0xGNryV
 Jtlnxct/
 emtpov5CBhrrljoLQCoPfBLIjjowd8kPCPtSz8WuOd/rFe3+L5DgOP7ZIQdCPKgF/hjt0Fx92uJhCe1ciJh6/YTRmGg74iqdde2TqIhjL5gWuP7xWFwu1lScv000PgrWjO6lE2p0wEV/hmjReuVircIYCsLXtJJCZk7SRAy6c7wfG9ZmxXTM/+0wa5S124y7TH2e0k2whlh0VGtAA4EzYGYELM8KY/ZkYnTZSK2+mPGVImjypEXQ9Fybovf9xQV1o6VFp0t+A3Bwo2KntE7p7h0QRXDy9Tvu04CC8OOTlqsfqYnxOuq1NoZHF2O45jrMZ208/lABu3xlN3JpXQx/MEmnCF27ciY6CaQ2MKEMM9T201uGc7oiR3OTZ3q5W7A3NpYaAIt5Zy4ohfSQaE/WKEjaRMxg9q77iIXL3nNYDItSry+A/7PQt6/yzH+EBvfVAVF3kdFjNJiVBWcX7elhccUN1TwxOhy5f3pGH2qECUUYNoWX3xgqaGUp137qG5RQ4btgFEUyQ9V0/tYktYIzC3zEvzkH8COO2CmCEOAWcpZ+vaBm31U2WrgorEnurijbBUO5XugO/g7SgjTECe3xyE79hixFYIxQj5v2ryHjTTUeulV1eHah/E+YTtp20cXF/eec+R3ENo6u1Vqu+n4QAFOkFmxoeU0lyeGjIimTYdd9FBR/Yfo+rz3JlFUpueuK5pk4bfeN6JirjVt7n0OHLBhh5XgEbWk/pSrAq7GceixQrOKUyMzyjpVFn4Bx8ndfVb4VHYXccH4WZelPVlR03TRolitwrbSqrVis/MIB84rX0OTM8cdyESzGryw7gUogySNzN+A6bSlf/TPf5zOeLMyX5Sg8KClpQPZqEUXEZPQC8aUXRBJ0rjfUm1oQZMYjythVrXCQe1NxhIvaXuiz0QyMSfe5HiYGdgVKdWqz4nq/a7bg1GbePcWBt/pNKgGW+ehQGSAYuEgWvy3aGBxZ2LSDafWTj
 qZJJiAha
 dgLTayCtJ/4oQeyHfyiTKaklyc1xusKOEXgieebFrZWYQ+CXC5TwOpb4/maMAtd2ddSx5Zszdecbgpd51QkQnw9J3m5LRBk6Y8C3/AeLi+UICZaTrLBbLQ6EkGlvsbNPs3nU0aF3rXtGtEwcAyPaDpuRx7zhE90k8MVzE2YA3zlu03hYelm8Ano9PETTGsispLA5DwHB7YFZcbNMVQXpEMs3tTlcr6gZZiLtlUOz6X61Sdx3nXOGjZHGxpdeCKPjexCMKscGjnaJ4A1hf+Odt9QjN2x4+O0BT7OnZG7NDOniZENy6uJMLlDEYJBAmFToL2bJ6FO1BpZ/yq7ZcWERX3CuXbczB2VO/+S2QyG5BpXus6OG0qj8rw6MUQ2cOYGgWisDsLnwA/d/mw3cevew7fm2Gwj478uwBlZIPXOM8wDiAU7KZaeHO5X1HvepeUHMsXAuzg839LVEreKkUvjRy2VXtai4G1JJAMYH3xDAjStPYMN6ym1wL8Gm6jyHd7tTWs4+f7CV6vk8uZm0IGJtvk0XFTBw4UJSKqpPezWg8gzACanjkgytw8X2fXCe0Ic/gt5zrjLZtFMB0Ab9aPB8vwxqMoJRBVm3S9ZX26104y18wnaVPGTmnNS5UHKWIZUZIeVuMGoGTbstNo3tOaLw+TLps1mGyXeEg5X9FUBHiiqzAslHH1dED2sU0KYigXfXUCVwELsANVqQos+7H+uboCHjaUEh19PA95Y4LG+1HDfM8OGohVaIfEi8RSQYW1nse/JcSN7rw1VJu8iRvij6/MWEFTVUb8Y8RSk6s8WU/fq6KH9PWBUQymEOv9rgzweiiyvlBFYpxnv473MvpKgtkUFdOgUsjL+omEf1NUwWSwVDfLgokHyvCLeVlojTdIe5acDh979bqG8IEhFgXN9KtKbjTgy0hFdrgoaOOWaJoR63t6GuWOGSM4O49L0wCpkHrqbevaUIwZrp95Xo+CwO7ZzRaLy3u
 wcPoej1x
 bWorfCGKLvMoyDeVBiZMJYM/bXwxeH7Lf6N6qxKZVX4o4b/NTIshpuSKH54oaCGySyie3nnRdwqNtI97ksQn+Qfonm4Av6E9WR1hRlFwLBTC2ZGI8ANPbgjyG18Q4Mfvd7jcXKqNt5yxToMqTr4r6nvAugwL8JMRRVHqmLZHiHGsVCC//I+UX/sqSjw7Ayj/1NesVAaJRXvmBLTOVDCTuQD9eSsI7hAziBrsAAeM8ZlqstwjS4UXxei2uWQ1J9LR2Wcr03tiMGT26tI1+ztJdFjonuiF4HcbiSmEuSEZpWAMSQ8wE6q3MEUUzVuQhDB556+zO+j28Yi2JKyKGVNHzhH22r4hQp3r08ge/iWH5br72zQLQNsZhs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> We currently disallow the installation of lightweight guard regions in VMAs
> whose flags intersect VMA_SPECIAL_FLAGS or VMA_HUGETLB_BIT, or
> VMA_LOCKED_BIT unless allow_locked is set.
> 
> hugetlb VMAs set VMA_DONTEXPAND_BIT so this was already redundant,
> VMA_SPECIAL_FLAGS already sufficed.
> 
> However, now that VMA_IO_BIT is only set if VMA_PFNMAP or VMA_MIXEDMAP_BIT
> is set, this check collapses to being the equivalent of
> !vma_can_merge().
> 
> Update is_valid_guard_vma() to reflect this.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/madvise.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 467601a8525b..0922d5f07a12 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1221,19 +1221,25 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
>  	return error;
>  }
>  
> -static bool is_valid_guard_vma(struct vm_area_struct *vma, bool allow_locked)
> +static bool is_valid_guard_vma(const struct vm_area_struct *vma,
> +			       bool allow_locked)
>  {
> -	vm_flags_t disallowed = VM_SPECIAL | VM_HUGETLB;
> -
>  	/*
> -	 * A user could lock after setting a guard range but that's fine, as
> +	 * A user could lock after setting a guard range but that's fine as
>  	 * they'd not be able to fault in. The issue arises when we try to zap
>  	 * existing locked VMAs. We don't want to do that.
>  	 */
> -	if (!allow_locked)
> -		disallowed |= VM_LOCKED;
> +	if (!allow_locked && vma_test(vma, VMA_LOCKED_BIT))
> +		return false;
> +	/*
> +	 * Guard regions require a VMA whose page tables are managed solely by
> +	 * the core, which is also what merging requires, so disallow any flags
> +	 * that would prevent a merge.
> +	 */
> +	if (!vma_can_merge(vma))
> +		return false;

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

