Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 844DBCA5FF0
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93FAE6B00B5; Sat,  3 Oct 2026 12:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EFB76B00B6; Sat,  3 Oct 2026 12:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B8CB6B00B7; Sat,  3 Oct 2026 12:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56DFB6B00B5
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:39:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5CD84099D
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:39:52 +0000 (UTC)
X-FDA: 85281876624.17.E3FF82E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3139B140009
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:39:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Eb4zke4Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhSwIhda5SwYvYTkOqlzzzYcm2yovY5S5sJ87DUE+qE=;
	b=FYLWpPFzAkjqfj9GML72g2QxTgN9iN/qcttQ29kkH9oGjC8ZBqnFj3jelSeFnIexRoIJLU
	5pmHCLciivDHKOq7RbDgSUV0YZ4WNk3TG1utfWOOmB3wnzd5a2Lit2nu/UWu8dBXyvfxPW
	SjTWXgEjULPiH1ti974i8OerGXvWt2M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Eb4zke4Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045591;
	b=S5RBL3bn9qLCtjZPFjUv2xJglWDMXHEN34CwLCStX3N/y9UDU+yFSmSEikEyfckejrIoV8
	ht3Q4L5XfYym9GTVcfRkN4MZUwcbH5l6HNAWTF2wEMr/qtFUaGpRqmmszY99OJ5u6MJ3e5
	d9/AjIER7s1Fm3qTqEeVo/dS/h5VUb4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B5AC160D82;
	Sat,  3 Oct 2026 16:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A3C1F0089E;
	Sat,  3 Oct 2026 16:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045590;
	bh=FhSwIhda5SwYvYTkOqlzzzYcm2yovY5S5sJ87DUE+qE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Eb4zke4Q9Qn6CRUc6WUxmkGaik5XGPQQB3DGUSAqaZINP8oiCy0hTc6caTGrqaPUC
	 KEmNHJk1wdKBcDKWft+LsfjFGip5E/CPkShMomriDAgys/rp3Oo4iLqIOttofHBTSo
	 B5JWTvoxy21Zj5MLEWqH01sqMoKDQHoJlALTYgLlHYXvgBDJHEW0Gnr0IOqJtDfHiW
	 f6exisuCZMOFzUOIfHESn4G92PdiwIquASbx2xeXrZqOoQHB2FmMKYMHCR8kkO83Va
	 cf1KfU9U/+z/3GA4QxdYbCTlHuZ4YM6cJLeRuqMWVI6oslp0KiIqphuMfI39tGgp5k
	 w1o/LtHnirGvg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:50 +0100
Subject: [PATCH v4 19/38] HSI: cmt_speech: convert mmap hook to
 mmap_prepare, refactor
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-19-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2632; i=ljs@kernel.org;
 h=from:subject:message-id; bh=GNn4/WHo/gNb5sHnp4BEq122HpiBRxK72Bb5u1n+58g=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mm+rWSpibv2fBJnzXH27aUCq702Gh/L9dc5t3t/Y
 nOXxrZTHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIIz+G/1lf16lKXWfId7rh
 lJdw/Uliw9ZTQuKF/50veIVfvBlYPYXhf4n1F50Wq8l5f8pvC7ksPrPc7W9WeUzDdC4nmd83fiT
 dYgYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 3139B140009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: cwhrm31ur5z6a3wpgpds6afa88amt111
X-HE-Tag: 1791045590-844534
X-HE-Meta: U2FsdGVkX1+YZE1fZyUwoO/fhwrg9CFyJEyYY7/9UMtpO7XovHQIX2iDqGXryetyqSvuJHI1V5Jo77YUDLjNLKXFXdRvZU3m0vQ38Z3/2NT/olzCzBze/gCtG1dgulRjeNAabynWyJpOfcr1Z0IFbRwsXhxE8rotC5AXsEbHQr/AXLtB0fVFYE66rZFELYi417Tmm8s7Qt9cfEktr1bD7XroedQYaRBIjVxT9NSFsIKiqKFQa2LXhCGtDO8ixvKvreCusnwJigAI6PGICIbhw9oNXuCPNSQ3iM+lLq268Zy04rj5fNLP6zq6BlgJlMhKAw4XGBUy6mENr1uQBnMIO3eF0/mvjHc9IiIPbe4LYRg+9eOXNuQ301kPLj0i8dKErYU6nICFYBZ6ku7DScJaOkGyXDcl3M1bF1dJnGuZRyYG+ZQ2ltRkd/0+NY5jN5A2e74297hCDiRNcga0KhBb1d8zOHGfcW1jkzNdNgJvyHlEHqV8eikeHJNr8pnPtbZdVoBTPKQJ7RNasGc8JFYQHkBEuMS0lWhRyikknKoXUc5N5LamGrr0hIBgH0rrqNQZO9n1ocJXrX1Jj69FsBo+6W2VG/q1YUygyzB9qcM8l83hsNY/UIHww9AAA1tvSxQggoySC1wlePUXDe/gcs2U71ZXAic0bwd0pYPFwg0a1wNF+uQMD7Tsqwu3r8rUoK3sFxnNjpX2vQLnjo48oqQfC4DT7CRE83ZojUJDqZdpUmtqojwimmMlYJASMDEs03xDgzKaZhYZ6MZuauSpbobb9hXIK4Z/xU2uwhhNUhzMxtp7PyzgN/yNzAXnhp1/6kyNzcHpXtMAdYjCmOBuIE3bu8t98WmZ5Z9mlfe1KF6/6711uPL+xVbDpXYFjbfTcSVZwykd64m3elIPTzpj2zWoWh/Qf41D8R8PnX001FjZjBgZ02feAVUnyHM3uqGe8NKwjnSFZWy9VTAXDeUHNOL
 yI35ZN1s
 AKSO/64ua+9jP+nuNAEfXYhTNbcOo/4SEWs2NS9NyK0+McCyJo0+sbVRFxisZOzsi/wwRKaWnWKhTu3M6uRHkYDvDA4gV/XN1dqyYkCxzND2vmnShWSvnD+ZuUUUTA3Appk0+9ExxL9hDRS367MMEHyv5iE1XhclN0gfGvRR08gnKgnlLsM3h0sxQtE9dGzvpgaEhmwy/iE6FgBfkYHIXOzL/9g3g2uQSHjYR+cnfIDUMeKGUJzQwFULTu9jAk6WteJvo6A/eWH7WzbRQE5no2b6h807z0vCCLseW2pNmcoQnV9ZrkwthKs1iEKaDoKMqXeBbJ4BmH+j4E3DM4/GBPrQ1fjeMt+04y/fI18Ep3sN2LV6PSCF5lOgGPcfwfdina8GpumgsuZD9pDOASNd6qD+CKW1RXxiYLz741dMjfO1WpW2YSIX/jmdciCF/7wU8qMHUpKXm26BThXneUmoGrRcvBpqnGclIfSrmGgooI5OxBAqqu8REEWSm3Lj+FnhhapZzsnldlXxNtKp3btJK6vJEMKhLXdFM9m+mbZ7RlHUlDqhl23WAvsXl44bxn/VRFQMwevt1WH6OhjQWgHe3g9xsK6BtfhzM7jZdEviOlp6lG0uUAZiiQanpCDXqTuh6Eu/1XcOslqQbW2RVxF4LyGcVPeRYKov7pS0jcxzS747qFpn3bq5md/9uFh04I8y/dVrg5PmINUFNyuvUqZhLFNQG6d0Y4vF+nC2Xcd2AQX5o3ydUp5VqHdJJhgnFCpKz9i6Pdl4pv3liDtqxDgdFV5YSQ/ttg2szcNryef0xBsqih47fNyp6rO/d9y/eM5sEgMVlkqSd/8nBI1+DZSe4W01SBdbSxIL07RZVtrVyzhtCGkOWZ7TegEuTUmvwGo0WDbCbxtgzh/SqgbhhhB5e+NrIAavX1D4q4LMHf3S13VZPNxbqsyYdbCg+wuWDxZiIHN67HYgZHA/IcNNRmnBFFvGTTuJC
 mtptbOMJ
 uqBv2pIwf+9cJYUhW881dpudfs9pDnCybs/wuDii4Q7sGpK6ea9f/Wcz5LJ1pLgrRSTqffsr1yKm5SNxtn2IzBHqC54RK+dHLKv/R+a3vcG3g+QaxpHcRRBdaw4aIySJuHK0SG/PNLiXtExeN7DfGZ04QiYR02XXodtS2KR18feKnbCekpgL9dZIwH04qnOb0wWTsbsBiGWo9xHePp9Ysryi28v5xpOg7ZY80SUi9+iLSzkvkYU0wyyprVHHTbslToEFLsfY6pWzXIwpHQN2njA3OuEMP/bEmxEJVIftD4GW5+61UYqHHf6caODnvOHRoCHig2nxkP4HTFPu9f05jw3OJCU8Od0HYUseEbJ6wkB/QefjGJzn+3ImaIboDmhgraY4kLnXH8fhUikae7rzA9W7UBPug9ohAk5IYRwmTv7P/taXtVzfnSrKF6jYCnPNZ1Lq5InTgzsLoc5jiOp1/1lusL2Yi/QKmG5dB6HPJ0qYg/EBK3v6l/J0N6alzjxDzJH6rtigjL4hj2gDbg68PXdR32adAqR1aa+An5RhokAEllki5lYpXQ5pN40jqNZOUqXso8ehT/q9X9nFUWO9esxWbMkpZ6l4YZ29E0LbI3OV15GyTO5tJmoYRs+P3pcOcG7z/Ml6NQDcumK7PFdaKVeHJgNLq0zIIEvmoJUhoXoXGuMKJWkKsbVHoWZXZJ1SRS/yDp4k3ywt60Bh+EGY34F7w5sVOuQ6Dd+NYaP8BvBA5S+nrGqHbv3JO5CuD34CKNrsnUL3oSa1Fks7h2LLPYMub1k2KzXRVS9BHjR+jc34t4t7HIlQIf8xv+2BRkqlkYbrsRFmXyq3qltNvHNMSqziXuJCe+eTlWotP3RWQoPi84Op5SYxEm0uJuOwN+unk3dhUDGyxAe58FWakFmV6R/ztICh0/t9KkVyemw0dhwnyDWR+m7EH+63IQD2qP50RXV8l8sLdgLhCixOurl1K0mMRpljA
 DPVJTwCj
 BXlu9XBpyvd5+fnkufbCnFtPqyUc6nmTBMvkXTzVtvJPdc1UlJjW8oo6BWxKxFn9qNeiddWkPiFBdKNvLSbAmHpnd8LuP9oqcW2la3F0Ay1NdavPuP/2yBTUxIlGjGQJGyWk+HBee4pFFRNeIXupMrgpNXkJH9VRLWW9w5umLj+0nu7C7DSFlrTVbAlaXoxxN5rEtoFw/SGnYOjGmI6ScvxUJU8hMoQ9Dvh1GR1RR8eAq3HoxhtrETlkdYhUeDWJu3hGreDG9HOlxi/rMpTVlB8rb3C9MaMuTPaOXAOXrhewfM2EeVdwNy4A8VzgO71gI191ZqF2YUWkfPBjJMH2obTGny1aZWnk663AFpLqiImobKGdXxrzqM/90rs1HqulMGzrGyndC6ZrLAtVMqonuqoAOjC2CHUjBmGjKkmvxByxXTp9O+LsQw6Rdkh4+1YlDzDCHad2WoJrWW5vZuwcduOGizBYCjuSfdhWtO5ur8zoacXAHKhklBhBVucj9CEiQW2KtknNn0BJM0+h90cp90dF/l+v8IPh76pklg9HyJQrZ9NtSr3Bq2j569tHgQP0Sr67MWhZEW1mrG4t0+gL6CptRHiwQGzkNr2fQ4FLluXvblF+1IIZKt6ARPABRLqXi1DV+JmiBcNuVZEDmbTF+xsXGSBY5zARGbt1+zNGPclTzHfLTGhK1t49+PZdfbtPL1k/kKzMMMVDqbE1ZwOwCNJ4i3tbi+KCSC86Nc8MSI1YAY5cOaQwnGJGAMVyl2lq6ZW99DyyoRFOMz453BE8cszG/7FhNAdMz/VcWn75IqKh4TQTGoOBQkjjucG7vIjrm4ZXdeUXlERpEx5hlImwPi73LNpPUVcO8JnqRVppKVULFYfzHdejrBNIv9lnGwTLqFWB6ilDZh5fFfUYeiOTZ9RnI+6YrUV16PgWl05uOQQkaqgEIUgLeSBYoyi4Ac6ombOVI5GWjw+9k1IbHg035cjA0Qocd
 o+hK+g4O
 XY4/rLgrEsgI1mSb6VX+ngTFwnUZVrLrHSTrk/qUrBuR3JMqVdqEw0udExvRJiBDouZStnpBcVhpk/WcjUVLyyynT/5wyXbjfno5gQs0iBPJqubsVcD3lwqINQysUgn9n+d8R7NDjOUbgaFMLYBMvQCiPsYBxq1SpUtJ/1Tmc/X89GI88ULv8mILn8FCemlVw0H7FVDX8WDKSO2Z1Q9lLZnN5Xjepc5znKIMWXLxZRxQ1LOd/pfWYWH8JvJgXciFnquOG57DqcIP6iODKukJ3BG5A5NG1snCFi7afc6qiEZRqPv7BZXLIASCCuB4y+/yYT24KMbXFWkSQ9VVpvzwfE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the mmap_prepare in favour of the deprecated mmap hook as part of the
work to convert one to another.

Since this is simply a refcounted kernel page that has been allocated, it
should not be marked VM_IO and should be inserted using the kernel page
insertion mechanism, so convert it to do this instead.

Use the VMA descriptor's private data field as a scratch buffer to store
the page in - this stays valid throughout the kernel page mapping
operation.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/hsi/clients/cmt_speech.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 7226677ebde7..801697b74d4f 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -1084,22 +1084,6 @@ static void cs_hsi_stop(struct cs_hsi_iface *hi)
 	kfree(hi);
 }
 
-static vm_fault_t cs_char_vma_fault(struct vm_fault *vmf)
-{
-	struct cs_char *csdata = vmf->vma->vm_private_data;
-	struct page *page;
-
-	page = virt_to_page((void *)csdata->mmap_base);
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
-}
-
-static const struct vm_operations_struct cs_char_vm_ops = {
-	.fault	= cs_char_vma_fault,
-};
-
 static int cs_char_fasync(int fd, struct file *file, int on)
 {
 	struct cs_char *csdata = file->private_data;
@@ -1256,18 +1240,19 @@ static long cs_char_ioctl(struct file *file, unsigned int cmd,
 	return r;
 }
 
-static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
+static int cs_char_mmap_prepare(struct vm_area_desc *desc)
 {
-	if (vma->vm_end < vma->vm_start)
-		return -EINVAL;
+	struct file *file = desc->file;
+	struct cs_char *csdata = file->private_data;
+	struct page **pages = (struct page **)&desc->private_data;
 
-	if (vma_pages(vma) != 1)
+	if (vma_desc_pages(desc) != 1)
 		return -EINVAL;
 
-	vm_flags_set(vma, VM_IO | VM_DONTDUMP | VM_DONTEXPAND);
-	vma->vm_ops = &cs_char_vm_ops;
-	vma->vm_private_data = file->private_data;
+	vma_desc_set_flags(desc, VMA_DONTDUMP_BIT, VMA_DONTEXPAND_BIT);
 
+	*pages = virt_to_page((void *)csdata->mmap_base);
+	mmap_action_map_kernel_pages_full(desc, pages);
 	return 0;
 }
 
@@ -1353,7 +1338,7 @@ static const struct file_operations cs_char_fops = {
 	.write		= cs_char_write,
 	.poll		= cs_char_poll,
 	.unlocked_ioctl	= cs_char_ioctl,
-	.mmap		= cs_char_mmap,
+	.mmap_prepare	= cs_char_mmap_prepare,
 	.open		= cs_char_open,
 	.release	= cs_char_release,
 	.fasync		= cs_char_fasync,

-- 
2.55.0


