Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 009A9CA5FED
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0FC6B00BC; Sat,  3 Oct 2026 12:41:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E71A16B00BD; Sat,  3 Oct 2026 12:41:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D627F6B00BE; Sat,  3 Oct 2026 12:41:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE0736B00BC
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:41:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3159B1607B9
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:41:18 +0000 (UTC)
X-FDA: 85281880236.12.24CD55D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5EA09120005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:41:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HJ0dMssJ;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+i+DaAt9JzfHEIOjru3Rvly0KtZKnnSUfWMgzuFSoU=;
	b=clWCEFqDW+jeq+dSbsLw+dWMhFm1CSLII2IW2xQp/VVeEg366gVIf6UIYefMRWEl8UQnnh
	VZHLjxwsnTEqsGTd4ohTGFjsuhtzMyMoPXCB/6Bm+b95ndI7Vt5pMzQgXQKNodiK50POZr
	gQjvxSfLexRqspBhbGt1ZTmHmBI74YQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HJ0dMssJ;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045676;
	b=8N5zwNITEC4vK6pIc3XcyfyR6nYNdY3cwvR2GfHl1t0ZAIi21L9l+xGjGFg07nv1D4XBjI
	FNyGuzpns6cvDLgnwZRovHlSrhYzVd6JWRHAmt3UJrjFh1T8oiXwj/mD/kivUJVyFs4Y8s
	DIv5GG0IwleNIzT80MyaL3Idh6hQfM4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98A0A4091D;
	Sat,  3 Oct 2026 16:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95D81F0089B;
	Sat,  3 Oct 2026 16:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045675;
	bh=D+i+DaAt9JzfHEIOjru3Rvly0KtZKnnSUfWMgzuFSoU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HJ0dMssJAJQp7Wft+YK+Sqw5CMfTXSDpwcHumun0jM3f+RUdAudnqmKu3xhMViZ4X
	 RnO4PtMpkhLhYw2Qh/ShBhivaE8HEYxu5mNA3+H83HjtS0ukfk/YwJrrc7MjvjEUT1
	 MGM/IkBjpHP5z/K+Qz5fr/dSMA0EFwV0JxyPWcYlLHvpQeTn14o8Zm+v6UwrlfKxpL
	 24JCFILDUZIlf8SlooslNnfr0Tf/wHw3lW8xlhFMYsJLn71bRtxtNbasUs4OIpcEca
	 aNrh0iE6XVuaO5vZqlyfr+h6FGsgabRVtGiwrO5zPe3WAANwqPaiZIJLuE58TyoROr
	 HXar12veDOJIA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:54 +0100
Subject: [PATCH v4 23/38] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-23-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, 
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
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8341; i=ljs@kernel.org;
 h=from:subject:message-id; bh=DEwsIsHyrU8dUc7I0Q85dMjaxlNnAODqsthg7xucj5U=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mnN3/Xu9o623i8vi6bXPj61VbbZb+Ny1nlfXnMKv
 pQt+6Qq11HKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJXDrDyHC+vfFFAkfihNPz
 Thq2S6qwddxgPvDfijO9rYR3dvXrC8oM/4xX/VrSv+6PXj/LPd7v3JbTbqa1JH+c/dT771+/eoU
 vgpwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5EA09120005
X-Rspam-User: 
X-Stat-Signature: pnaiem44akppf4ce4i764aq1pc7rgdrp
X-HE-Tag: 1791045676-638734
X-HE-Meta: U2FsdGVkX1/yrSLJPIIGMwsVI18bDPOfukH+ZO/Nh5Jjf9wogP9G84G4FJPBvxDNYpNgofJNQH3DDsRv6rIgYsRf1fwVblNYFNM+KratCs92MwMMSxP7NM8ummmBMN5iPlddRpybGeytNFGdBhoSMln6JpphZ2htwAOiC9yFyEnV31GM3+h9NKZHHq5RB0z1n9xYEqNBuTxQyHH24Bwud7Gyrx+9zBw3kUoXw1YA5q9y2L/kMHW3DEhx4Q6FlM4/VYs+IAnWZAt8GWjiVFO43KvuBcrABlzSfskjRtXw6iHyzOf//54Jek8BvelICPZmalImtkXsA5Xb/tufFXuTzm4BEz1LqY7+mzHGy9mDYgX4FHj0GcWabHsWbFdZRE84njfz3BFP9uyhPxMTh33W1DrkcYvVRmPMJX0uJXlO9YumH2Mn+2Unp0J8zjyCYh2EJe4iBzdGIT5+TOUZQWZIZ1g6eLo7O0/Yr8+igzm2KLSbkUrnnvw1Zju2ZYQU1jUXpiKC/QIuzCoFbt/cw7w8tYmtPaZzNjEzS+mHcHUHdoXeE5kN0u+xpmoE3TcRCRYmCCwcMojVsWjf23hWq4Pcr6KnQ6u3qQzqC8mozMNk8lpL592dRm9XHSu5kKDViyItjEEXkDeGV10uKF4g/rVwpoxHVHmhD10tCJ0mSwVFIikQz4MI3xM/rsNELr9TmTJGAi6MkdBfwA12V9mT4IELH7DFS0X20NY0Xf79oNtmcLPpvSKQ5orhUFdrppnxsDA0A4+dIyw6f4asmaxrQZ6NLxVDTl2r/h8Pa6qaEnLh9WbZHEUrTgkJ+JceDMQBnXotX6Die7eooIJ6j2ih8vjLzyz2/7CvhXe7bQRh96eS0nHD1f0Yay9lbuXXMt3ZfR1ce8RDjMCcO/QF9+PftHhvYv9a+RyDvWouXyro6P6C17uoGE6fZLApr651QkHEYN1jBpo8UrqZaRoO4nhCDHq
 kKMWYO7f
 6OjvveR9HX1UFPc588JM6cAUcZq+/Y5fRu7MTkSkQWXkn/4PFV8jWGuS4fAOElwvlHSMY+yN7cQoqk96YJYgNyMh+/R7wco7h4pVNq68M2A3NG5ohnfV8vkUlOCgky9B2AGoGPlQVb5/qWufY68r2Pg02mr4knAkOLWaeCZyT8Itkigq4KEyhX+sYbxAE4msSGikDrCW/G8YYpU+Pep9GP4QmWNem+F6f8d7t+X5LFPI9C52c/mWaC7u3/AtIHmjD0g+wfeURTBIloawC85CocxacMLW7YiJp99TUDevx9IqcvZMFZarcjZDAeiUtGBhBF8A8EhF10+qu+OWqeo4hlh2CF5zsOPRYJfDaKW5Rk6/fFhYHr4sYJsiVPBCnoUW18ut4fepenV28ramR6mY+jTT1DHvd0mVk3rjZqleE0S+BhLtXSkqqANQ/BwzQLjSL3a+inVs+7lKLl4b3M2umU1tZIN2Z6//FCoEVzsN20HQmizorSJvPyVG9t8HbZnRXkTH4KdNvMYBDKiH6ivo8ju35qUV8Ip37P/8GqLIfubzO+EOcGl2OOAupbHXsF4YfhQOvjAN/QbwVPvJqps3BTSStQEiW/EFGYYod3bC5hgGMjNpuFI4ujBLh6Zf5txpW2VTcKnZCA1aQrNC9rx3b4o7bhYbVaXMKAcATIUIxt8ov+HgvN97p6r14gUYGe0GeTvnYylobRc3MtcaWpwxUZDCDizC2q9Gwl4GX5vw06LiPzzOMVqhGirNxHZRqNd6+2rAxBhry+CVGMpxCu6Ps1+RLtjIX829Yq9sRrqT7iKjDmuAbVgFKIFbTWRg8qvwWs1dvSnC4sA1A+8WhxOZ2wq0qRBQyiJYqqbFLyUReQCTgnWUnJhWsnl1ogPa1tJakbsc2ps7dytbEvAqVJLZupppq9AbZVP7zk+fi//bSNQbXoqXsWAHugCGA+6fEwqdF3N7V9/eGPInpl94An7qtWC0Rglym
 AWELEbvj
 7TIOl4Xb9FII1TqxwkHbqk4UHfJ/Z/GdVPsckaRXUyZfSptaEGVuqNBWLPAIGmU5yeFxodu9Ppw1prkhx1KgbUDgzfMfwKMS3gkmYO4c03UBAp/0vBeNSxnBv30jbgAi5RsMzwe19b0Iwjpm9JBxeOv9MrvjRIs9ZCZrjG9/jeeorIHE9u/Uv63GWU6IMOaJpGYeWHBwRZ8EOel/sMpW4IlfPCPl1v7KbJeIIu732f0DdD7zsthQFarFmAqZ5ak5Vt49YfpKOrUmmVWbc1Ev+RwM8GUuj8LCvNnw9q5ToRdsSXnps0cClXhMvl/seak2O7zGV18E7fGCFQFJVbXXXgoYclTgZs6rNcccyne671NdfL5POhVKuO3aCTFQk+TtanpWVOH8ODDzLX5Te5IcrKq1eVIArzZtvlrYyJ/itTmJxuiTgfqiIJI4CefLQBzaq5+c3oOS/JR/GT7QX2gavvntXZW/P/sUS38GiEN6mb09NbrOmrdpGZ1F16jIPNh3Auk9g1c+ITzoaj15jO5MWekOVK25exW/ayUVUZbbKv5dRwr9KNrYQfPpdeniialEbTkQon6S2CCvDXrCZMJSMBW1ZZsU4INgcgk7ijxGSRJ19xPQRjpuH2+8G+k3nfglUsGRd3GJO9T4ZzJntvhffnzX7+vi2qVfS3DP3IzYIq6XBiCPX9/39D6U+Pzm91fJvdcWAukAQ8A4TIKWD6f1IvMaPAh6Et0idtbW862TBx260b95cwjA2TFJ+PYER7ge/lewWfB0R2AJNevHpisl5ilsrStEGzzUGf+/WWjxNtG6nhWlGqzNOIusM0puFIDo0hCHFrPZWBXJUaB/1KIIpRPyKDwymSO+cCXen6qk31ohOAQHUpICJRkxydtRI9jJkPtgoNi3rPQ1KlllDTGIoPCS2bOjx/pr4d1riQavJAazjlTNJ81iyZXXB3c/zg55TBGavNc4UDOIZx2whIZbM0mpPyLwH
 T4qEXS1q
 j3x9vTmwZ8MQEZxdc1Rt5aMmARS5UFAL2z7LSlgbJHkD1niabSUsMUmaA20XDPWIi0L2UnncUiA3eJsIbJxlYPh6WS5cWVsI9B5oDOvjaGSMG8V8hrvjvKNT7cpMXUKpZ9PIrv8X60yFRNMMm9ewySwy7jxrCqyNkCbmd6tWLT056ucQ4DlaXJaDn5QLcnQgwaPfWLf3kUP99OXSdKqPfoyCxtakk5VL9X1a05t57n8mAE4zyIim5QZaCeUVn908m106yEmp5DR9NSKMScXPkHWjZi/bZJbQAumUbAMcJ/QzBycB9L1LfLJ7dwC/0PD0KS3kioVFKwc8i8dfL6neJUxZ1RgIKpi9TvTkWX5YFuMNxY49oBXEfEiKqkGhb8E9TWEjF9YY7TEP57lwQczDO1QWmeZaH4ip7pJlX6QpWoV671pTFS2lrJMIgYn2BqYNTXerpTXRhBoImFp4YKtlIMHBdApEA4p+3jaFl2NT2uVyf9uGW1juLozW3IrgebTSIgnYKZxgXwK3EXW1tnCjHPKclq4rYYB5zgeHOtOewBqCeDmgFAS13jdEF07kuPyz4XNv/AOmmeRjgI4MQk1V26sITELme8BZPyvs6neYEQIVfssrPAJrBjiRCUesG/mk+/gaaPp11ogzseJ5VylB0kROsjMv6Rt79CYCAcgIcL4qIzCSS9Ode3kMYvJPk6+aJXQBxjMlV1dRQ0zVz4+ScpphvyBDd006V95jJqWPqKKW4snevplcsGRCmObpr6RURRHru15ruoRXdD5jeD27+dN4vvIarZiJDjZNTVSJuucmrAW0NKRICuHfqy6XFTdkWbaTb4aMGoGQJZPTJqIa7KjlAKxgDI7yPM4MOYg+wpvPso142w7LWLKF/WFIcff2dxHRy+uitNcpDQOCi2vXQzlZZE9Y7/5yD/oEJ8+bDuaAD5X02qdP9Sh21cPbyhvbD6sj1sesIL2Dj6SxcvlLfMq6ybPzl
 dvOgSpka
 VLiVN53QsCyXymqpPo/KiTXG2R/Tj/UTMxHOzEwWsuAwavQuZXu96J0lhcgjLCJ5jpjjlA5gav7GNx9XcAtYeZrv9n5xkDyeyUReqeVtikL/zJnCMg1dtBzY97wfkyh9pPliiZRPRsw7H4T9JE3BG+6gVxHONJIR9I31Lok5q1DIOXUMyj8LeIRJya3HNHWfOU41MQhuwWuMCEgyxzQnfqcQQC0+fFQPw8d3A1tTu7qDVv10nnGXT7dovdYS8T+ubzP8KCbgfFp5lbl8VeFKQXWzilNYqspnOOh5e1yU08etiwadMyCKXkAYeKcHqhM3JAdCXFe2uZXVKvvHbZxhWWI4/tJru7DqtI9vcfv+u3IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When performing mlock() or munlock() otherwise normal VMAs have VMA_IO_BIT
solely to fix a race with migration which might otherwise double-count
mlock VMAs.

This is unnecessary - at the point of applying folio mlock state, whether
setting or clearing PG_mlocked, we know whether or not we are locking.

Solve this in two ways - thread a boolean through the page table walk
indicating whether a lock or unlock is being performed, and run a locking
walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.

This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always implies
VMA_LOCKED_BIT. These are also always cleared together.

Then, update folio_add_lru_vma() and mlock_folio() to check only for
VMA_LOCKED_BIT, and update try_to_unmap_one() to check for VMA_LOCKED_MASK
instead.

Also remove the useless invocation of allow_mlock_munlock() which simply
returns true if unlocking and instead rename it to allow_mlock() and only
call it when locking.

With the other mlock abuse of VMA_IO_BIT addressed, update
mlock_vma_folio() and folio_add_lru_vma() to simply test for
VMA_LOCKED_BIT.

The munlock_vma_folio() function tests VMA_LOCKED_MASK instead, as an
unmap racing with the locking walk must still munlock folios the walk has
already counted.

Additionally, in order to ensure a racing unmap/migration releases the
reference munlock_folio() took (whose put was batched), check
VMA_LOCKED_MASK before calling mlock_drain_local() in try_to_unmap_one()
and try_to_migrate_one().

While here, also replace some deprecated VMA flag predicates.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/folio.c    |  2 +-
 mm/internal.h | 10 +++++++---
 mm/mlock.c    | 51 +++++++++++++++++++--------------------------------
 mm/rmap.c     |  8 +++++---
 4 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 47a437e0f7fd..35e242b48870 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -505,7 +505,7 @@ void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma)
 {
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_new_folio(folio);
 	else
 		folio_add_lru(folio);
diff --git a/mm/internal.h b/mm/internal.h
index 4ae08fedffff..ea8fa94ebe1b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -970,8 +970,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/* The VM_IO check prevents migration from double-counting during mlock. */
-	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_folio(folio);
 }
 
@@ -988,7 +987,12 @@ static inline void munlock_vma_folio(struct folio *folio,
 	 * always munlock the folio and page reclaim will correct it
 	 * if it's wrong.
 	 */
-	if (unlikely(vma->vm_flags & VM_LOCKED))
+	/*
+	 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+	 * mlock_vma_pages_range(). An unmap racing with the walk must still
+	 * munlock folios the walk has already counted.
+	 */
+	if (unlikely(vma_test_any_mask(vma, VMA_LOCKED_MASK)))
 		munlock_folio(folio);
 }
 
diff --git a/mm/mlock.c b/mm/mlock.c
index 39215a3eab1f..4235a1518fc9 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -316,22 +316,10 @@ static inline unsigned int folio_mlock_step(struct folio *folio,
 	return folio_pte_batch(folio, pte, ptent, count);
 }
 
-static inline bool allow_mlock_munlock(struct folio *folio,
+static inline bool allow_mlock(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, unsigned int step)
 {
-	/*
-	 * For unlock, allow munlock large folio which is partially
-	 * mapped to VMA. As it's possible that large folio is
-	 * mlocked and VMA is split later.
-	 *
-	 * During memory pressure, such kind of large folio can
-	 * be split. And the pages are not in VM_LOCKed VMA
-	 * can be reclaimed.
-	 */
-	if (!vma_test(vma, VMA_LOCKED_BIT))
-		return true;
-
 	/* folio_within_range() cannot take KSM, but any small folio is OK */
 	if (!folio_test_large(folio))
 		return true;
@@ -352,6 +340,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 
 {
 	struct vm_area_struct *vma = walk->vma;
+	const bool lock = walk->private;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte;
 	pte_t ptent;
@@ -368,7 +357,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 		folio = pmd_folio(*pmd);
 		if (folio_is_zone_device(folio))
 			goto out;
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -390,10 +379,10 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 			continue;
 
 		step = folio_mlock_step(folio, pte, addr, end);
-		if (!allow_mlock_munlock(folio, vma, start, end, step))
+		if (lock && !allow_mlock(folio, vma, start, end, step))
 			goto next_entry;
 
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -428,31 +417,29 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 		.pmd_entry = mlock_pte_range,
 		.walk_lock = PGWALK_WRLOCK_VERIFY,
 	};
+	const bool lock = vma_flags_test(new_vma_flags, VMA_LOCKED_BIT);
+	vma_flags_t walk_flags = *new_vma_flags;
 
 	/*
-	 * There is a slight chance that concurrent page migration,
-	 * or page reclaim finding a page of this now-VMA_LOCKED_BIT vma,
-	 * will call mlock_vma_folio() and raise page's mlock_count:
-	 * double counting, leaving the page unevictable indefinitely.
-	 * Communicate this danger to mlock_vma_folio() with VMA_IO_BIT,
-	 * which is a VMA_SPECIAL_FLAGS flag not allowed on VMA_LOCKED_BIT vmas.
-	 * mmap_lock is held in write mode here, so this weird
-	 * combination should not be visible to other mmap_lock users;
-	 * but WRITE_ONCE so rmap walkers must see VMA_IO_BIT if VMA_LOCKED_BIT.
+	 * LOCKONFAULT without LOCKED never otherwise occurs: it marks a walk in
+	 * progress so that rmap-side callers, which test VMA_LOCKED_BIT, do not
+	 * count folios, while try_to_unmap_one(), which tests VMA_LOCKED_MASK,
+	 * still refuses to unmap them.
 	 */
-	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
-		vma_flags_set(new_vma_flags, VMA_IO_BIT);
+	if (lock) {
+		vma_flags_clear(&walk_flags, VMA_LOCKED_BIT);
+		vma_flags_set(&walk_flags, VMA_LOCKONFAULT_BIT);
+	}
+
 	vma_start_write(vma);
-	vma_flags_reset_once(vma, new_vma_flags);
+	vma_flags_reset_once(vma, &walk_flags);
 
 	lru_add_drain();
-	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
+	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);
 	lru_add_drain();
 
-	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
-		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
+	if (lock)
 		vma_flags_reset_once(vma, new_vma_flags);
-	}
 }
 
 /*
diff --git a/mm/rmap.c b/mm/rmap.c
index 5332c52909be..b4a4b3929044 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2239,9 +2239,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
+		 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+		 * mlock_vma_pages_range().
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
-		    (vma->vm_flags & VM_LOCKED)) {
+		    vma_test_any_mask(vma, VMA_LOCKED_MASK)) {
 			ptes++;
 
 			/*
@@ -2395,7 +2397,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 finish_unmap:
 		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
-		if (vma->vm_flags & VM_LOCKED)
+		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
 			mlock_drain_local();
 		folio_put_refs(folio, nr_pages);
 
@@ -2770,7 +2772,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			hugetlb_remove_rmap(folio);
 		else
 			folio_remove_rmap_pte(folio, subpage, vma);
-		if (vma->vm_flags & VM_LOCKED)
+		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
 			mlock_drain_local();
 		folio_put(folio);
 	}

-- 
2.55.0


