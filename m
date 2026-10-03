Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EC29CA5FEF
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 749176B00B9; Sat,  3 Oct 2026 12:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71CE96B00BA; Sat,  3 Oct 2026 12:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4996B00BB; Sat,  3 Oct 2026 12:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5956B00B9
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:40:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C28521A09A1
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:40:35 +0000 (UTC)
X-FDA: 85281878430.07.58B697B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E7A271C000C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:40:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MzEw4ieF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfRJzELhUA3zmjv637fDp+tblD+oWrGBxslIXX4F7cw=;
	b=r0E6gm9dDTaqDPlxKTmkEjD44OvRV1WxlQ1LqaCi5UeVz9AXTYZg1eVMU84fTCZpCFE6Rk
	deZ3wbbSBlSt45LrHkAOa84iyKcrpAe9c0sfK30CU4HUYgB4GmWz8yw6IbfFcuQmdJoj/0
	HWP9J9F8jmWSu/Jr/p5coUcPkST1lYA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MzEw4ieF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045634;
	b=Q/fOKD3QvJeRLnma5/+CrVQ/Zb7S2RH23fvy55wMymM56dMNWGLiEL91k97j1ZZbzwOWNY
	epQrjZyHCsM9IAN2MirVEAZoaXV690G8sGWmrghKEO5MXNX3nw4VtBIxTGduoez4qa8+qL
	x+Mq5vsCcSWH8WebEqGk1C0nGXgMwQQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37E1A40DB2;
	Sat,  3 Oct 2026 16:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557FE1F0089B;
	Sat,  3 Oct 2026 16:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045633;
	bh=GfRJzELhUA3zmjv637fDp+tblD+oWrGBxslIXX4F7cw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MzEw4ieFr11M5xHt2StEg6ORuVCD4VqADro6fX5jY4Ta3/+dMmpHToQqa+TKOvHpb
	 IPMFcq6S5OlnoYGqd3tbx+zczcLOwZ049eISw3ZbGqinvJ8vB8TIJGSH+89hLlIyuu
	 GCrEkGdm8lminJ7UdcjQx2rHVh67gDPTW89nGvvEVK3rMD2O+y61f7DyKG+EBBGv+9
	 zNYh7D7+yvaw5+NF90qj3Wv17VO1v4AOYerCJx6Q4MN5gWC4inUQq3kshfEyJtFUv/
	 iYdkzvnAfDCraTTT++jWofvtKAF0IvVBTVyyBbsZejJe3ay7nMmyB10uba1kwfaht9
	 P/kq77Leo4ktg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:52 +0100
Subject: [PATCH v4 21/38] uprobes: remove VM_IO, set VM_MIXEDMAP for mapped
 kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-21-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2070; i=ljs@kernel.org;
 h=from:subject:message-id; bh=joQXUjvjM3OjL+Ta6QEJ1w5g7Vsv4M79ot1AULAZKpk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mnpVu/bE3Fl5sa7KacdG3OWXlVbcOqVV+eyO1eK7
 2YF5n1421HKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJSN9jZPhZf5i391D042MR
 MUZhsy7sc1b9yPr2Xruu0dtrt2b2HvVjZDi1/1bGz761fdtPvhNmnZ/7f+37frOIO3sa56ibMKs
 4+bEDAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: ari8qj5bpcppm9hs7q9sku88agjs854z
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E7A271C000C
X-HE-Tag: 1791045633-987011
X-HE-Meta: U2FsdGVkX19l7bvBCHhcGlVOQQKk58il+qRXJBYDxNHBxoN9/j9NH2B5z88Oz3Xy/K10iRNjcXBaHAvyvnLOZhGX9mXPa6UcMqBdzlw1QmdUqWTxBWjvcbun2d+QQRafNF4pLNHZ22NFjjrpHhSVavwBYIjugVnsX4mVE23YpuruPVK+3kci+6RP2MuBcRoJgdfyRawwWjNcjb+xczp8b1o5M1Cob53iAPgp+hpDWsE/8asdkq8C9rdha6hPX6mg5B0QO7fLUZEXCDvzSkpXbyy/pUi3omkmQ5AkOgF4Zsi1KWNNTaZyIvF8l3MG2NMr3ZFDKpuRC8j9sF7uYIeULgCOrdc32InVArh73kl2W92Hs3n/4lqeS0xvGirXFppBykWlITePj2fTP9ofiQVo5C0P6lgvrvc30jcF7M+L2BepkOIisAADTv/QY1ZjuZ/5pAQj74Q3o6ARasTOA2dJoZoOVZmJJMbxu491bfAKPejJ1GUVSFYxd6MwNwn82Ho0XtyVVdYHLCO3cGY+FMa/E7FAupugIuKLGUYuOoAfmtdFTTsrWLyHgKGZ360O/bztNuW/Jgk+1ErDFWK9fpHcsDjrYADbrckAh24jUBFjED8u4JCWgMjs8vqTMyB7FuRlWzrJtJS0P96iWliPyuAVKQlezDPaMCuy+HJ5D4fHXiI37Fjjk1SI4NFjR3EnqQB+k0nmzX0vxKxiQRVZvMfdmH/pLD3cRG90irDpLmwLhwP7J8LQ/V/hJZqzIMDU9ZqZbzU8/eKAbXX3+/A+Jxoact+G0GvUYJHjUwfTqPGPNfZTWFtw2Hm1XHMViq8gqb1KL2/KYjxjRFa/y8Wh0YDKaRON+o9AjmGOGHqmBTYammFfb91MJTzkXlR4uK2hX4MZ29PDMgAoxcvJxemVHpp20+SyNqBwyt5031w+JaimC9L/3+qkI+DyLoavr5lRWECDutDtOOK1xklv4ybcYO/
 hhwTRzo4
 aIrvAi3vixiuW8eWzQniXh02MkdGffSuSV/AMxHZ+o/28au/gv5iUxD7WIu1kZ9nXSa1DUe4p1FktEjRl/wDqiTbqPs55T9C+mq+R0k6Lv9e8PdMz6fy7lBXHhM7VtfuMUmCcPeQ83JCVms1r/HfddzirodE1FdUcLunWJ1rLJU8/LwfgRlFQn9dZw8Q17PrJla3M68edOTGafo5iDfoF5C5vlZdjSHJhCq12RMzlJQ2nxZDlD16aVipt/sUSDPZzwllc3ZrPTLXXdA4VKKAZ19GGYHcLheuplvk8LsnwOaGDTKoSz9rQGBDAk1lf+eWJRKZnpxyc0GeBJJweVZ/k7BdS507Ne796k21Kj7Wh39DT9TxvxS2LbOnDmHtLc/PF00ECVg6I7dRBR8wgp9PBjhM+EgmvCZZpkiFdLaLqE9R6yT1bej9XbJJ6wr1/NpjlNO96iGkmDxN0xCoGa5+ZTVIQMHPrVDksxAlWZ7oeiwPZTOrWAQ1gnwMbW3h0VRqNM4TZ/7EIQsZ1n5EjO6j6x8W29Dta2jL6Er0HezTLj4fBzmqMOCU0k5Nz96fI/n8X8G0NDlEjBsx+4FRd8LdGKBFDThN6FljLOjVsm6RIahXi1jNGWmn1t2G+K1R9QzBVVPmSvRFtyElbdwWTA4RqjJcmYEgAolMkGVfPdfhVHCEeYpBhvgJ28k2s1H3TVM3JfwEArnZB7+ICuZsOgkANlLTI0ltYHUML7Y6Ty1KDkeZpGZ8petEy30iYmePwvUW/e3Jw/reinYyyUXi191zbzXJ9YcaoOnaX638G8L8Gb0JeBQh6bMui4Hl1t8Bp8UzrDgdFhQB/vd0GdSKeSppJZEp1HDfN85Cdsm9t6WcLbGcXljhzozhNQHvVQnzb9aH7Ukiv2ok1WgzVCWHHIukhewB7nmXVd/RevMyg+Ot440CXXmCkAonP6IeIrnBzTdIC1u/cg78Pd9SnXolSNps6k1j3gJE6
 pd8mN9Fg
 /O5VqRRxYow3k4GOEqbK/rdCGBVVNOJs9BwtZFAIMm//u+FbKk5gziB1WZ95lmhdPpQu90UBHgS1MZdBRj1LdMDPM+LvpEDGj6d+TjFBGplZzsxoCYNBb15IQOF14T0zbY5ldJg3659gIM2TddxGzqNY8VnqtZog13ZtwGiIjir2PMgBsG/oY9AskZZ31S7t68+RtcU/cJm8K/F34ysppcgs2Op3P7yv1VIPE+mXBJDSqXdqZiNMDmDJfw4zkvxQZOFzLXhe1Kr40JSLcuhHKqZoBuok1XGyBUdZIyzofobTTCLoKo2OhUxZLhIF4/XLadFRbmRWYI564WmrFLdbXp7+OZWOthICNt+nQW3tU9YFgrxCLjWALSHazAlS3zbIE9qcAdQ+jH6ZFTTqGnQW2VvzuaOIRbxJ5KSQQeUJItVSs8SciENYT/dazhpzpGpSSqJjEtb66RSExwnKwVsri7q5Y7SS8gIBJP63ucdXRbKuiAh4Gvm+FvEB8ziZsZkFlebFMkRuP+fk/OsnnojpLq1mWk9XI7LRZvgFKN4xvxxn9QBvlCM/QPyB5yGym0OIOcKMCYXcsfnwMZiwP6NNCBzi7IEN1JnEmJPbx1do9OzbYsJQxI+UNV3YQDRzg+eTm0X5BgXsI9DiB2Y/qeN1B8CrDnD98kia5uqTutY5F92SRIEirvydlB2IqCPWlb6SSlbEq72SZlYfy4V7gRSoLtvxIRpnmMaoN9Hgs0QgTmjX3ZaQL0lTqFycgTFSnvd83jYGtCPHAQh4SEgTrRspdv+CouctlEls6GeJy7ObJVMJw+cJyQp18gf8iCumoRuosFvR2ttrp0goKF99knYdp89gJfwSt6k/NSGn1Vj82P+KptdkLEwGO6n1+pQT2LhWQHhzrESp9ti706Hibi8Au8s1xCswnrlGxTAfTG5BRhq7ZH5am3ZCkiy7fdMiKH9Dx95V+nNUsawiah0ckVgjFjGA6LylQ
 j9eJLjmZ
 8Y0Z55LDj5I1o+YR/z4pDjCNQZb58R2WSaJtF9KOamZCiRYqcjkNet/ZCRp8+NdjJcKPCctK7bm/57tWw/b5uBuNKAMNN/gBOj8w2Yrk6b6IpGV6EAh0kuyVIhbdbrx6D4BfM0iLTvkRqzjvy/B2bGhOCPwrUnKZJmrrxSch0GjKsDuj1yYUd/jDYkZPyoTpd55s96rhSBq1gCS6iNbY93TbXKkTV5pas1IO9dX9kOrdk/cNPUfo+8allMOrt0D7/hpsxxPYVEkQKv2ld4pob3TrRflh1dDVRcSWCdBgNFDVDzWJnSOyIli1DyOB3FQU5faxQ1gbe/z0yOCRNSRWWwOtPNh3A/WARAaGptv4m6MkmtuJcEbxsZypN3LeoB4mQsK787rCfLmMG1RrFnN6JranqcGD+FGZWiFqOUvjh8H9g/j8BnNLskuuenBQr8xfjRvw/IXvWpKZcFsKv+2G+714BHp3p7YOqV7AdkNnh/t1GOWjR2EfTDIC/SKTR582eBBJFpFxmOnikxXsdKksTAUJMXfOCtOhqa/S1mrF8UEM9nKysoO5gty7Vt21VQ4CqFcUbKaw/wljjIppirXRRH6ut9moQ+5uvbnkjIsloBM9GU8HrM9DjaVv4HKMHB9P7V4W0O1/SBNbc3RfyhFwEwPCex9DOTzAoXzrWiCmH/uMAkbCZhAgFnyVF7bRHVqWdwRu6sHG3V8a5lXnZI2py4VhJB4N1lVdwTwuLVhnV2aoew7UIr02YRytbpRngIeINGWzg5p2NmHOhaPaNJuN2q8tiHTxDm0Rx/B61kWrqnOm3WEpAaGyAcbU1Uuj9RIAaZ4uEgqccq7NRFFLWu9yx30rjpneAH4gEQsA+GqdL6KJNkvMByJI0JFFBXO6TZXqzWSKqmgX8q1Hl2ZyeuyZ9nGuTUm+UAZaVttYnNXhWULnHaJkP4+W+/Hk6FgBu/5TEgEWFjSoIWxQaJeuH6Bm8FKfS4AvE
 M0oxTJp6
 /RcfwWt3qudSe8fwp3FVyVUOaHKLfk+gYzvazQbIn17KZiFlzo6XOOmShJzInH2+ezoo40BY+wtwpt6iq+OGs/PW1rlTS58tiFk4s+Wvk0AK59IlQNgzJigQoFS/Bc3ckR++KgldHexvVfPKyH2mxRkTBP1gSxaoxi9RzEGHMavOkQyXN5w+CH3rU1r4We8zGwKrZPZvkkyh/sLalCmxn+94X4SKtOhrmYaPS+gDS1CUOQW2oh3yTxv2/MDQNMV1ZISBVAHVdTSXq/qL8+4mR8867+qPUwG3sBjhCGP8l77hjDwMVrn4yK/6t3CZ4x9G3jyIf/7rx7MOMM01a5NJ1s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are not MMIO pages so VMA_IO_BIT is an inappropriate flag to set.

Instead, set them VMA_MIXEDMAP_BIT as they are kernel mappings and this is
the appropriate flag to set for those.

This provides the semantics required - no VMA merging is permitted, but
does not prevent GUP.

However this has no meaningful impact as these are refcounted and thus can
be GUPed.

A previous commit already prevented __mm_populate() from being invoked on
XOL areas, which VMA_IO_BIT was previously relied upon to do, so that is no
longer required.

Both VMAs set a VMA name, so always_dump_vma() returns true before
vma_dump_size() reaches its VMA_IO_BIT check, and thus there is no change
in core dump behaviour.

Change this for both the core xol_add_vma() function and the x86-specific
get_uprobe_trampoline() function.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/x86/kernel/uprobes.c | 2 +-
 kernel/events/uprobes.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 65a2de82ecd2..0f60c0d076b6 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -715,7 +715,7 @@ static struct vm_area_struct *get_uprobe_trampoline(struct mm_struct *mm, unsign
 
 	*new_mapping = true;
 	return _install_special_mapping(mm, vaddr, PAGE_SIZE,
-				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_IO,
+				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_MIXEDMAP,
 				&tramp_mapping);
 }
 
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 7709ea882477..b89cc5cee002 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1726,8 +1726,8 @@ static int xol_add_vma(struct mm_struct *mm, struct xol_area *area)
 	}
 
 	vma = _install_special_mapping(mm, area->vaddr, PAGE_SIZE,
-				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|VM_IO|
-				VM_SEALED_SYSMAP,
+				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|
+				VM_MIXEDMAP|VM_SEALED_SYSMAP,
 				&xol_mapping);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);

-- 
2.55.0


