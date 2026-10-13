Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94D0BCC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40BE6B00DA; Tue, 13 Oct 2026 11:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1766B00DB; Tue, 13 Oct 2026 11:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B94D6B00DC; Tue, 13 Oct 2026 11:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 713866B00DA
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:21:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 143A8A8AA0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:21:25 +0000 (UTC)
X-FDA: 85317966930.14.D9FB5F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5775D40005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:21:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AW5Rags6;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5upPOtDABwwVpDceVPyuSA83QzDcrZ56JA1+Hc43xbI=;
	b=BE0hiylUWnlOURFToiFM4PEw4jORpfdxC94bZeJwIerDntizLp/qapg1oQ4A0/k1L1Vmxi
	6erKS45picamNnfyUmnkPG0zaYHE6HGlEqmzGpyQdC3zPun3rQeqV5WVdyeWl6lol8sJ3w
	rHNOKF0HkkOTC3PGF7rSm/FZ42F9OW4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AW5Rags6;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904883;
	b=BK5JicWJ89vhsgB+I/78HbGyutJcva9FuL2k4SCzQfGOtreKfSkaqCkDHFsE4oIPl+95TW
	wzLtMATKeNHBauW41nL+9HtxPtzFQ3EekQcVP4LIFQp8LsUN8CSXJjW3VYiZkPEqEGQJSL
	JuJw1UbMWKdx3kXTHtA9F5qymMAQRZ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF07B60A64;
	Tue, 13 Oct 2026 15:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C094D1F000FF;
	Tue, 13 Oct 2026 15:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904882;
	bh=5upPOtDABwwVpDceVPyuSA83QzDcrZ56JA1+Hc43xbI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AW5Rags63C6td5M6b7VqigkXIDFfXKaHR+C8fTp9LHbiL0+Vw36DizQSNaLH9JI/l
	 LhijdbZAsP4Vjbp3e8O6o4aNg5O7t60HCmhVvL25GBFb/mRiNnI8GLLIDgcKOCqrYX
	 TYxWT0W1SNtr8iRRruzTFFlQuX7r+5+Y1fmtuvvOHPtrKVNc5Uj/y2uGreaaaYtn0J
	 TfjB7jrnK0bigDG0bYZG0JiWnB8WKgkjMNbRjgaKXW8dRuNsTKriIkLJyX7gEbgeqh
	 //ChXeuNvMX3v1EwgHfQF6ubT1qWJRaCCBcKiln1bt9u0LrQA4UUd9w8/gXboPSQgl
	 wwu6fHTQismhA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:09 +0100
Subject: [PATCH v6 29/39] mm: drop some redundant checks around hugetlb
 VMAs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-29-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2822; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ULLCLMudbM+nA5DIlUO12EUl7FbXJrpgl/45EV2ltd8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZz2u3rtJtORho/pMxS3nrRQcKoUVdwombjMQ3Sx2
 OZA2bt1HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhI2FRGhjUhF9V7RU/KZi/8
 df7ZrFTZJo2FMgJ2GfvEJuiHOgefl2Fk2Lpv2f5D14OmsuQKmSinfahx2HXq7sdlNxcuPMK87u2
 EU/wA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5775D40005
X-Rspam-User: 
X-Stat-Signature: gpdcxygagpie5b5nqdjd63frdtk4a9r5
X-HE-Tag: 1791904883-681417
X-HE-Meta: U2FsdGVkX1+yiYsteB4UnmmGdz+6OVIKlsFWGS0Qhm2uIZFWxDRa0rLZDBd2MBEnbNdazQ0LSYi0sUs5EAnWFAmceeKVxDXUfVstPR1g5HO6fuvqO9xrgHESJjD+kkOYOtaZYxi77gmBX7UZSJkL563b2bxaHw17aT5qLFBDkmy3Q1cGb2Vx09jvkH1UKIvoUb5YdqYfOsYnc+iY/qSBUJfFCH0Ws3AvMrUap2MjfFJ5k9BmCHa2c+CRWEFiWxxxbKIIVzQCd07fzT6mlAy0yNLBbQ25R9RB7iGCP91lw+ytRmiB4enzpbcWUA55Zp+b5MCp5HgZo9JTwkUAnrT4KmVFFJ95+ZzdkAgdmWOi1/N39nlW17qdq6xJt3iR0HHs5LlM9LEhWbK0tEQA2aZx2GBOESdDecnQg75e26p4+KD29iUeUHl1NFSbVpxBj9WqRwU2Gv6NbIcHxiJzq3P+a3jjldMK4/CKCLR2wdsAAG1jWLwJPpJLXJ+3RQrQUaPIRooKidJiSrX458OfP6kK6EWm+kiBOqu2nHYUq7hSd42aeMnluwHT1gVgR/6Sw6NkCHRGPPOH/+YwTTqFiXd/vi7L9kLaUKqbysVu5W3wRQY4laZ0cke5q2oOHnZ5HNBYNoFkqP9ikraz7Z0iF3/P6D7mVbmomO9VWjizWl/WVL01bbkydOLUHvbJQCU9qxD+5/d++c9sfG5DRyqLAHY196GmAvsxxgz2sGggOGoVHKSzA29DdR+/LUGeUzG7lxyV/m4Bipt89mkEBrWIyJElxOULrjBCVcKga007H2MJc/fgLZQdAh73Mog2ud3UjSz5nb2wb8CxguEI+O/XgO5bFGV72UKxWukYTTnWx7C8vBcddswUxfzoSKazlkLW2N+xifjAbBHl4f8EEdmvb1SZ4ur6fsy2TnLjLeleeyRoywuEpRMSXZ7EzSjc2qBd3qXhRPb5+dw6/PX+NigaR5e
 FUdpT6mZ
 xFguR5AmF5uQ8S+x29ya7i8ZXjJt6E6SoYki/7k7oYCf78FJAvV1jAXcFkpfcD3UBkPZ5AaqJRzqsAmR0ECDCiBTxIyz/Thbm3coH7tUjywvIu7dDc9igLIVgse+dYA0Qf7U1QQitg/Xmu15q0JmRn4uxmKyL/elnyw5AL5+GXUBDlTZ0HcAGy8cadpAeCf1sUjDqUQGnRJFTfIERBswjieLJq0BuzoPiZtElFpaqocLcJQcpJSqnfqQiefCqre+9N8E+Kw0DAiNMQtpn3CfG2MsfzQkjaTyhGqHnQF3j7q2mJH4NYCohgG5sCg0hbtpnWBP3uSCfkWD017RIhGp3dGN52MdRoW0g0WCQs5eNADi4gmd9Ux15exCv78tPgdzMWEPE3kRXt3O56xJKeuU65MejrnNv+H8IROYpsgC2MJhOChPRnVKYPLXPSKoh0txGotzxYzIGOyYc6iSzO6B7VjjHDgy04KeBGiGndTy1ZJ/S8cvnJ004JvCi/moYAVPCXslKLLLXj7gKK/lEj/E8/I9HLZBlMcvHtz1n5RQ1kYthmkTMdYGKBtw/43KqD/COqbOBRAc7pJtS5mSwF8uLB15UK/aBi5oas9lzv/uu3166ziB0B6l3dfN/T0tnIL1hqqPS+c68kop00cHfzUqNIEn7EEpU8KEYnGPHqLtHqCBzrw1K4FrZNYIfPuM1MXr8bQvWY7UgNNLxRLbE69qP2dRHb4/3GkqFobt8e1wEiQ/aExsiqxYqw8AkM6n5/TJU1OQhcbKK3liV8x988CVRYfCuepn5v2di9Th2rxC5G4EVoaPs0suxYDXxlaACEAWoii61D8YVAnr9prnNNUIR6ftO8Qtl3cZenqWksvdfwJ58dOkbMZaY9yI6didUZ+PZYgoFhqQxMlP/K/irMxrwg9Zmetcb9O/pPgPXre5khT6X3XARASye40diiQI+Q88+IxgwzSmgklHU9L6I6iMxg4fxjcBD
 qcVgX7Ke
 vfmYiPdyGKfD5qzN5fBMf1rjd2H7q5JlD6+ITP3r8ay+12t3FHPqf6zXpM+05c6GF9KcRD9WaUVdL9pvCP3Gp+X6S1F0t2f/W9PeZjHEYgJGHo2mN2qYKAvlKBN8u3olUJz7IN8zejsTFFpV3dC1B6abVf1ble0wQWSFMrSOOldIRqeDhFet0GOAjD4+nLJXwvDJrScjY3yYf+2/VnMnJA6JlyXFpIz88MTFfse7uJyw7bpGvyzzHzzRgZL5UdUTicKNkeNMrFIbTklbo/JsxLE/Hi3hLS/knozVvVHVqPH0NA6NWe9gMY8qUoog0t+lR48b/ceCTf/HT58CP8VDDfFsB64IDuVmF2i2JiQIG/GpgZt19t2JrgCNGZb2Uj/Sb/WIAtEdeKJGyy33FTLAwoGS5iA8odTbEc1vNDhnTP1r0U1+gbenFkjY+4vMAZn/xhnhrc5RS8I3QMNX86IMQyUjZBYYc/1HiUIre6o8adqdFxwEI35N3ci+EsDBdaAEIVPVt0px4Hj4n3elUv0oIYvwYgb7G5X/hqS3b3ttv2Q8mY4OTJJIQ9xmF7h4yxinfRVdUe0nhjJTHMZgJTuXsSk94bjz5E+G+X1HtFX1Em3VL94nUVAaAE5UBXzkSsXxCZNfSZF8ncF1PH3WxDOEWf5IpncbiPnC1jxMGkJDvbhBc9tOOZuuIeC9gh+94doPxaikft/qrcivj0xP25wKmQ4FWvK1lnQNd2YmIPyzQqciKBS0QdHZ7QNU6ihHdA65pvv5YKyxLaBvPKKAIHbGJSi5CY/l8TGZkewY6pvjpBtzBe7WKqBc9HdJ9GoZtVRaDNZcTyjZkNaxrNNqUbXOPG+rhgKomWEame/DK0EXcPqCS988vgyop989De01vxVrvDM4c4zZWVx6uHsPAfPFWpegEDolB1n2dmCPmwfzwQZYFxSORHcFcr6Im8yjArF6GJbmqB+jKp+JrNyIm7PcLocfIXAo4
 4law0yeL
 crJYO0LaeQJeFUM/HzfZbIypYPCRFho2lP0aDJr/7fKMgWDRA6A6ZzcXjS8cnKUinSwGNk4B0ilu6qYZBDZfa+ORGuruZVzXFOFToYZ1r2rzOp3nWKXbbyHFcdvatjvMspcPRyQQldUPH1vWZgvOEAXmpD8s2AFGSiYEozaDhahjnTunARn1xiy4UEGpRkjg2XlIdDchIa6uI7QadA9S90TCC74F0YkmD/drJvrkFYKD3Lprtqs7hCLh4lgyLxsdxsTLhNhIAT8AkUnOX9p2fFjFcxUlABjt3Ui6xwWoPXTNJIwqmBK2TseBZDJQlJ3AH5m8j3ftUSH+vU8q3sjyJpPQx92L+JP9B2CBnRL5OZbZP5EFEnxacu3sTGoEoqrYVO8cnvyEsFrS4H3BQ1HLhXj4biEAubxwYe94k4JzAE/DOOiINtcSDLMEnf9Bh9yz2JfV53JM8xbArSDn+4y1eOAoNCWEgLlHDLAPTp/1w4tSGr+tVs1JfA5CiuoLTgcXiOtcW/yvSptU3NzVWQsAMgMEeYaPMNfbNqCQjzZWlWNUtIC3DDmNZV7Im1/hvqJ63HU/b/qtcn61SB1QZPo1/QHj96Esg3HEDo1Zj11DrNDl8RPpDAh1FFEPFFaKTPHmgN7cPbXZmJsFkOinJkqXS+HJv7h/kAiqjGkJKp1Nc8hT7GfL1Kn3Sw/jjhP9rxT0qRx2kuM3sVvp38XBtTDHDmM7BF0aB/rkLVUjv500iEgwdTPSa01fwXu4ckHWe7qZyz6d7dMmYOWo/jKT9vrRDs6jfmlZAc5mfv9PrX+PdSbGhoaSL2KqAGfheUJ1aiPbd/p+Seg08BbhE1/pijLIqN3vdZgACl/qZ5GdWG4rN97BrtC//bVfpFFQXu8lI10ZRhXGFuakC7YV55HAPj1cswOG/l8M0nGeAgFJuWNJi+zoxoUlXG1VA6wd4nw8P4t4msz8mBjPX82HQ0F5TsTNr3naVR5iF
 0MwI+YQ5
 cGOPfd5azaUL/65mt8jonMVzrRy1HiHCA0/Y/qm0gWycFLUzSts6OYLl0M9qmgEdRV+YjNKuVbNBSiwJld45DXOEpVoUMZK00nQ31nZToYZtQYCZyGUl4Wsul7unzZquu/sJy8eYIiCOLFJdYmzV2AaSZPBwq4YzLTXx+Nyplt7UBISKJVgcwF565zSF8LC343R3TBMxnj3GpkTZ0D8VOt8u8W7Sq5qJghLHJOLxQ+RvEvXPr4jYCM5UP3ydcw+y1HWSXvvueIsEdnQmSRNDWm7P4MmWN+z62sStpzzq3mMF0OrVrr7GQ5kQmUqX5Ay/hOfiXe4Xur0/GCgx3STQLnFU83/OPJvBxk7OPpup7DyZJBGDOdFWOAeKKlxNxAUP7/+lNpV7D4FYki2R+k77lUKgz+O3Jcf/y7g2+7ILsqGmRg5vU6jRAM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adjust code which inadvertently perform redundant checks on hugetlb VMAs
and clean them up:

* hugetlb VMAs have VMA_DONTEXPAND_BIT set so a VMA_SPECIAL_FLAGS check
  suffices. (migrate_vma_setup() regains an explicit hugetlb test later in
  the series, once VMA_SPECIAL_FLAGS is removed.)

* hugetlb VMAs unconditionally set vma->vm_ops, so they are never
  anonymous.

* hugetlb VMAs do not set VMA_PFNMAP_BIT so checking for this is redundant.

While we're here also drop a VM_BUG_ON() which the simplified check above
makes unreachable, and use the new VMA flag API.

No functional change intended.

Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/kvm/mmu.c         | 4 +---
 drivers/gpu/drm/drm_gpusvm.c | 3 +--
 mm/migrate_device.c          | 4 ++--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a7968f8d24bf..3c1240ffc38d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1463,14 +1463,12 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
 {
 	unsigned long pa;
 
-	if (vma_is_hugetlb(vma) && !(vma->vm_flags & VM_PFNMAP))
+	if (vma_is_hugetlb(vma))
 		return huge_page_shift(hstate_vma(vma));
 
 	if (!(vma->vm_flags & VM_PFNMAP))
 		return PAGE_SHIFT;
 
-	VM_BUG_ON(vma_is_hugetlb(vma));
-
 	pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
 
 #ifndef __PAGETABLE_PMD_FOLDED
diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index a1d4989b0b61..fab34fea99c2 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -1141,8 +1141,7 @@ drm_gpusvm_range_find_or_insert(struct drm_gpusvm *gpusvm,
 	 * limitations. If/when migrate_vma_* add more support, this logic will
 	 * have to change.
 	 */
-	migrate_devmem = ctx->devmem_possible &&
-		vma_is_anonymous(vas) && !vma_is_hugetlb(vas);
+	migrate_devmem = ctx->devmem_possible && vma_is_anonymous(vas);
 
 	chunk_size = drm_gpusvm_range_chunk_size(gpusvm, notifier, vas,
 						 fault_addr, gpuva_start,
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index c38cbaaef5a4..b9c453c28795 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -743,8 +743,8 @@ int migrate_vma_setup(struct migrate_vma *args)
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || vma_is_hugetlb(args->vma) ||
-	    (args->vma->vm_flags & VM_SPECIAL) || vma_is_dax(args->vma))
+	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
+	    vma_is_dax(args->vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;

-- 
2.55.0


