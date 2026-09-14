Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2FC1C88E78
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5AF36B00C1; Mon, 14 Sep 2026 11:07:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5116B00C2; Mon, 14 Sep 2026 11:07:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAFD36B00C3; Mon, 14 Sep 2026 11:07:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C41B6B00C1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:07:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1388F16017A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:07:48 +0000 (UTC)
X-FDA: 85212697416.17.7828FDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3491780010
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:07:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HmeQTLrg;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398466;
	b=sJWXg2CzEK9+U+KeAM6O+kTqLdlC4tm+jQOzc/q6t6vwKeVcVDRjqjhm8YqScuMu/4jpFH
	nRfM8VA/AJhzWHPdO5Su3WeUxArqT2bF3ISAT6XMCHGe83jOhlT/3wpcxNGbhs00Sv8ljW
	0CabE3L5x1fE5JDfMK3FFuZJkJcK3ic=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HmeQTLrg;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqpk9MXgaX25nS5Ys5rO6UCVR/iTsHvR4Kg11ITNpTs=;
	b=uyBGGoobLj7D4Iapbta1gzj0+OpiAj8twBN68YuqdpHogwEYGwJYf22B+iJB6iaJdVMIMt
	s5Erw3aTkEwSOX6rI19ab+b/ifzXgTleVSHHcWQEPFJEoecSBuf3ZOpuDfRFHVklLzPUOd
	rOX4X05InL6t08h+KDPItV2VQG7XeLE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52A25418E8;
	Mon, 14 Sep 2026 15:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CD21F000FF;
	Mon, 14 Sep 2026 15:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398465;
	bh=zqpk9MXgaX25nS5Ys5rO6UCVR/iTsHvR4Kg11ITNpTs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HmeQTLrgoimbYzYyF1rT1WkQ6aVpTWU4qFFntK6aiUaKPZLAxsSLWNJ4yY7LD7lbI
	 ZseHju5axoEj1lvyD+W6HgGWBGNzwmVxzDAb9lzGUVPlJbhk1RGmrqj+I5PjXuorcI
	 5ptV/vMor4Wykd7PBQ+fO5LSx8/pskNH+oZgN53eAveKFqk9QEkbPkWujm1io5dZiv
	 P3TkjeyaWcecyrBNYLy6oibGBT5fPJGeKbWVBD7HKivHa+6othTPwyXbYJZB958Ief
	 skQOSisyvVnwpjZKFfWee1UUWLZmK1jFOBTNh2iKT/aO1o84xoyMFpf9/i5/OkOe34
	 sEilfyVorcz+g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:38 +0100
Subject: [PATCH v2 18/40] scsi: sg: convert mmap hook to mmap_prepare and
 rework
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-18-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5937; i=ljs@kernel.org;
 h=from:subject:message-id; bh=HTYbod2OP3AjRPEv6Ph886TsUDFUWldGDo6PKBX7Wqs=;
 b=kA0DAAoWz53NioHifxQByyZiAGqoC7CifAo2LYHs93Csrg+FAX/PITR+MsmaU7ihJZemgKNxJ
 Ih1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmqoC7AACgkQz53NioHifxSgXQD/YHmd
 +7NVyi7o2SOOfYbqXyUEIdYXlh9OoJdt4BbzpFkA/05DF7kkq2mIvCKe8SkscJWlGPSdAqoROH6
 pVT6HQ3MO
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3491780010
X-Stat-Signature: unixsc41gjeaxdo7uucnqfeh8qkyr9de
X-Rspam-User: 
X-HE-Tag: 1789398466-337433
X-HE-Meta: U2FsdGVkX18tRaMSWR/CLcRat8LI7wIR+VrwHDyYxSYvEhdyy2x+Ck9kOyRMo6BbWkojy/HxTRYQDKwKCLSEsrnlI9PRjyec2ieuFUd9Zvb+0/6Xg8wmA/PqKHH9HPLojt7DMPDbWzP4xkFD4AwJ4MOdxeTTADyMOCyw18Gv1EIBbeHvqpSq499ost67oVI68J7POruE0XUKZsQnsggVLLHvUTHPvyYCDfv5g40XdOxfeiwLdnLANchqAunVEwOYbGY9QifAOPM8LOL+Jb3w/rdXVCwyz3hlu4TbIXqw+xBRbn72EiqxCQ/q7GQ6yH1CbADHsSJp0Azwe5uzqe2wdbz8oBeAI/IEeFK3Ra/w9l2J4lQmRbM8BWLzIM0mhQ+mNep6L8Ai4w5JvWAJwDEA5wXyWYIpmsM8Csl0Cy6Om6sWmEInPMPXQg5nl3D1fPQc/IBmWF2Gb0VuumRas6u0HcMfhFlaAlZavIbniXFMIiGgY/mzQxPFbI3WXCMAm/ckN/sQXgbzvh4iS6cyAvbgSPTGXx0fTXkxr+iY+xoJT/Pdm3WsXZCX4w1y+LGil3VTLGDKbII+1NmcgbjMfhMFz6tuZ2bilpF61V+FMtmZapFuqFo3twh/tXJMZO2LKAYF6dITPlghOg56QFr3KxxkKS+cNn3IT/Mk9HKZUOWP4dWC0qwJPoDXwrg3ceq3De60jugDH5tJ5WJkFB/6swPp2mtOMgI18YQo9vAp/0gcmYq07fYAAPRJo1Q67HE1gNcQHV8dWx7J6egAweXtMGkfKH1X+0CW/vvTiflnLALFqecSEyI1fe/maMJ8ho/8DMrhevqmBPo8VuK4BkBvuhj3zFDuqxK/ux3B1jdEHCEG1D0WyXy/rNxAax33bTtLRlri+Y59FTKXGnnyWMHAPc/poee3r92twD0MNBAPURVlt8NOxH0R7QdEALAz9Dz0UnmZV6cMuNquzf8vhi2DWnM
 BYqCI6Ui
 bZ/NnKo9+XG9J+syi/dSMMqcXiwKA7LFMNwGwxHQrbCshFNQFfeWJdlERCEHwwZDrkTjKi+ubVXPSKdOpbkW+ohczoejTH1i26NOJWrmcr432LSQl8uzmXAht1Itw6Y0h5yXzTKFxx2V8zoLWUi3pKh3qEbBQ9mT97TXGuBGEog4USpIwCjASNLQ7OL24sosUp+U9uzTgYJOiVOewjcoNRFHgIRtDTG0ZWQScN9+srnTfs57I7g/+5FyCCptAzAyIQJFEtrnDR3ptNq9djkLhiv40HvP1YSiTdiH/9v1uHfEH4MzRIIEKtPwpZ19Lc5iLAGOyHO56X7tEFiB1l/MfLfUF/Cgv9iZLl5KPUGR9/3xfeZteGN0ctYz/qzkf1CB4vg3h22lgmSV3Fz6hKhH7rnn8Lsdmpsarv4wB/Qwe9GqJsIQuBm9pacmspPTxcj1NRRtE1ZBOXwhlMNU35AFMMrB0y6KvCqpAIZbwTxDdRAVGY5ox9hQxfIGogbmUPXCa8/N8ozQYxFStR7KbOyfb5tXVZVdQmDTaHQdo2Uo1qHDjO8orRHVgrjVLMJ4SA4vJZoIqUh0tx9a6NzMY0stEfCDKGb1JkBCPeIoB+aXGIeoiP4Rjzsp9ZMxATJmXopGQ/O1wIrIT4qq9UOimuiDzt1O8/rmd10uOzh8h/rKFKY6YmEeWcBOm6i7+Btc9Ef55Mg7dDjHiSWxkTwcyYLA+XayHtXsAsRHlgEwKEYdNgXiaBJCmIm4dAekFw7GGag1bueuQHIs+QA9kRYgukXO12ThQ4/4wvaFtTC6dVmh6qtuJ74Sy8HBtheBptACz6jyf27a9OvXxjYWdC+kEPi1xJcTit9O6Y56U6fFUUnUyKNJ14Zcmz4KeNwjur2y5vsqPW/7jPxOrujZotblF2WVcnBMFpUa3UDuuwMP+j2F8qnn6ASVVA3OhiOei5lwNzcxBW1Sm7do/lXHMOfM0vk7grqNVoXNt
 CMWeSFPR
 t5QrhAA4kvagSBJOmqTXnTzV14KBv4WOdrU/lv2q080TBylKti0xQGxTL7l/2YDvIWqq2b7W6ByZsoQoDyLCUNK9D5CehPc8l4K1z5HbD1GMvF3POwADGsyICJfOiQ2fqesx9joZptUaT+MGrTHYjPYDMP0gLe/hZsTj4eVglCKAyTI4CWtPsiNHJJEeYIjZ3chPKoS3xR85Y3jhG39YZX67e/0E+Emx7NsI4hPbeNOwGY+psWeDXLaPKp7lQUJlOF1rLOEMRm5qm3HZA0dFX4M03G03VziS50KYDQRTrb50JOxfzjPJdEHRUsMrYweKHXFTxS/MJkJZp09HJtCBpHiIXJ/okSlzAC41Kt58ORmwqwIKFNq0A9dw459CbPd7S6gDuutszLrhgEJAR7tD6pBWHkeDVQv3dtXaaebVIHIant80vPt9lD6XL98WyQZHHNNnaXpibRzwPQhqh/FgnFIdupJ0tzn4nuGwP49XhqbWxbpiVpXhVK1hmvQjCXATbzpkJFCARfh+2Ke3iat2DHPIGsQhWa5vRu4kdXwL1s+QlOpEx+/xwxb9GqtB+q5cmFqW3Zh4jrSFHq8vlq/bwLldXaZAS5uhsI9obPU1i5RvLQPbmsynqJx/norxv83GvXh6a4+zSPvkEeW0JHoWPoy3MCCCgLdPeLYtY3wqRMyxUPjjA/LUlBY5NxHSbnpUnUyEgDb6csUNUj0VPGhOkXAh40YlZDO/J0d3JfYJVcmbJrFxQoZJESn6zE4vrrZ2WINKLrefaJLVUdIlCaLmGIuHQC61M7ErrNFXvvMdd210nMVCVcoyb7M973sut9312s66RiCKp2R12q3ulvz3hkYfwm3MXYZs8dopOB8tdegG019Mz+96XuLKuMvxe/p1435XKl0+2ne7wy1NSHhgCDmciulWoLNHAc5pZ84sY01H8gs5Dw0GqSZz+gWoSQkm4Ft4PELJxRyUqRSgvQAWtwIJk+uB8
 VMWT8Tsd
 SKdRmIVS1QbvjwEbnAK1XUxBgy3fyC9g//XyqEQ83HoLBeChUJF5LWtlzPV1ZsCa3dsHPaqoni7zwY1q2bYhW25IZkyiJgqDQ2fisa9Z7QduvTrjeebqiEAZkzAGmBeTa3Hpz6gRZez5SokmLRtfgwF8zJe50k+gKgUjQy6Fw4kj9o4qp2d5zTDcs+jn4991y5sSsTv2IuIaVV8FHe8xxZy6E6SZvydltoYLBYUbdeTHa433HjJv/2wCO/Rt94E+jDgCc0o2fTdH58+Nh15B2i2RH223v+8ZdBU9V90xuTSuxNl1IJrtpbtFTTOT1Vbr9QY0rPpcM73y+TTZp3Ihtskloh6GOp9PbWGORb81l+GT1NAwJ2+lNevQmuZFmbsaOfp/jwGTJmGRlGhuTmGwrnb/sx+neSxBDPk9TSAfujixxIeHyMmCMg37r1+lTMH3e0iD402RERL7B1BEzFk+TC10bZjnCR7grKMraTNW0fypp8GcIB+tWG2Va81ynQiR5O1ClOyPpdMZpz+NNk7pZSxVZIOKzopGo3LyGL1ItYAFQy6fxNFX6UzxF4CQECzPAWfjGOe1GTTSnHdKIROZ1XyYRnrqkZTmRIyvAmTIVt1+pr2cq8ABdkNa37kL2xi50Orxb9npYSTc1T5sC74hVt/ylc72MQhrJAiAbGlEUy123sJ//qbRKjPSuWf36b4yPmvf8C0SRwzVIys8F993i4WvuyPEUb6GHUjy0MFwVmOFwOPCOZTiivelVeqWeHZCryVJBSUGyfzJE0v9kuBM+3dezXbKdikIUXkeORfwsZXiYHh2cIUBIsO5JzZGs4ib2WMlPoLtmdgvifxQjCAfL3YY+DaI216fcrGtg0dMFmM407HWeCeDK44ycswteukuq6XYpz1Oad9lsDDNEE+Le9FHBN3NLh7tLPXpGoVM5ZCx1D/yHptcOpp+JZ9nfIkpiMLRHpHrEmLUuYvYR49XLde5lPvL/
 KyMqeoCL
 3nA/BCtiXZ6K6ROj5bjUUC7uThOBgLB0dhbNddgYP7/Ep3WTj9hmQg1lbzpMaBwwTWtMPwoM3pq1bJ/8qwZFVFsfqqyFslVBDCcJgdtQGA9fIP53qbH8fRC6WGoBWvGzkNteZLzOhJF0xvoOsxq/PdApKJKjPk0VZq6iTBWdFAwLKh+W5hLusA4niqPA5z1lNfiRcj61wHc9kUgITvX4b6xSb0kSzLd8EiU2hWXknmDPGQf8Z9XXyT/KtUeBjW+hKdXEzpXc8nXjYqkB4j8k300w5S6K5FaalxCS/+dkKrWk1MXeO0PrTQob2+T0p4uYXLigWA1U2NnqfVBrJtYx314TiVadd1+jTIC+N2JcprxZjeaVa8J3oOPHaEToNm66ay6kDAT5QYm4v+6YhAe6ZRM4aW/Y6CqDEab02O78q3zIB4FBtdF0LLrNIPgdy/QhsPVMCVGRVLKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move from the deprecated mmap hook to the new mmap_prepare hook.

We are mapping kernel pages here, so use the discontiguous kernel mapping
mmap action to do so.

Unwind the rather confusing loop and instead map as many pages as we can at
one time.

Note that we do not need to pay attention to rsv_schp->k_use_sg here, as
the pages are populated for the length of the buffer at
rsv_schp->page_order granularity as compound pages.

The discontiguous kernel page mapping logic handles the compound pages for
us.

sfp->mmap_called keeps the buffer stable for us. As before it is never
cleared, so a failed mmap also leaves it set.

We also remove some useless vma, vma->vm_file NULL checks - these will
always be non-NULL if you reached the mmap hook logic.

We retain log output for consistency, but change what's output on page
mapping to indicate that sg_discontig_get() does the work now.

Note that we drop the VMA_IO_BIT flag for the VMA here. It was never
necessary as we invoke alloc_pages() which gives us refcounted folios that
are fine for GUP to access (VMA_IO_BIT would prevent that).

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/scsi/sg.c | 115 ++++++++++++++++++++++++------------------------------
 1 file changed, 51 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5408f002e6c0..3f9e08725602 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1212,85 +1212,72 @@ sg_fasync(int fd, struct file *filp, int mode)
 	return fasync_helper(fd, filp, mode, &sfp->async_qp);
 }
 
-static vm_fault_t
-sg_vma_fault(struct vm_fault *vmf)
+static int sg_discontig_init(void *vm_private_data, void **private)
 {
-	struct vm_area_struct *vma = vmf->vma;
-	Sg_fd *sfp;
-	unsigned long offset, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k, length;
-
-	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
-		return VM_FAULT_SIGBUS;
-	rsv_schp = &sfp->reserve;
-	offset = vmf->pgoff << PAGE_SHIFT;
-	if (offset >= rsv_schp->bufflen)
-		return VM_FAULT_SIGBUS;
-	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
-				      "sg_vma_fault: offset=%lu, scatg=%d\n",
-				      offset, rsv_schp->k_use_sg));
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
-		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
-		if (offset < len) {
-			struct page *page = rsv_schp->pages[k] + (offset >> PAGE_SHIFT);
-			get_page(page);	/* increment page count */
-			vmf->page = page;
-			return 0; /* success */
-		}
-		sa += len;
-		offset -= len;
+	const unsigned long req_sz = (unsigned long)*private;
+	Sg_fd *sfp = vm_private_data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	int err = 0;
+
+	mutex_lock(&sfp->f_mutex);
+	if (req_sz > rsv_schp->bufflen) {
+		err = -ENOMEM;	/* cannot map more than reserved buffer */
+		goto out;
+	}
+	sfp->mmap_called = 1; /* Prevents changes to buffer size. */
+out:
+	mutex_unlock(&sfp->f_mutex);
+	return err;
+}
+
+static int
+sg_discontig_get(struct discontig_kernel_page_state *state)
+{
+	Sg_fd *sfp = state->vm_private_data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	const unsigned int order = rsv_schp->page_order;
+	const pgoff_t nr_pages = state->nr_pages_mapped;
+
+	if (nr_pages >= (rsv_schp->bufflen >> PAGE_SHIFT)) {
+		discontig_kernel_map_abort(state);
+		return 0;
 	}
 
-	return VM_FAULT_SIGBUS;
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
+				      "%s: offset=%lu, scatg=%d\n", __func__,
+				      nr_pages << PAGE_SHIFT, rsv_schp->k_use_sg));
+
+	discontig_kernel_map_page(state, rsv_schp->pages[nr_pages >> order]);
+	return 0;
 }
 
-static const struct vm_operations_struct sg_mmap_vm_ops = {
-	.fault = sg_vma_fault,
+static const struct discontig_kernel_page_ops sg_discontig_ops = {
+	.init = sg_discontig_init,
+	.get = sg_discontig_get,
 };
 
 static int
-sg_mmap(struct file *filp, struct vm_area_struct *vma)
+sg_mmap_prepare(struct vm_area_desc *desc)
 {
-	Sg_fd *sfp;
-	unsigned long req_sz, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k, length;
-	int ret = 0;
+	Sg_fd *sfp = desc->file->private_data;
+	const unsigned long req_sz = vma_desc_size(desc);
 
-	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
+	if (!sfp)
 		return -ENXIO;
-	req_sz = vma->vm_end - vma->vm_start;
+
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
 				      "sg_mmap starting, vm_start=%p, len=%d\n",
-				      (void *) vma->vm_start, (int) req_sz));
-	if (vma->vm_pgoff)
+				      (void *) desc->start, (int) req_sz));
+
+	if (desc->pgoff)
 		return -EINVAL;	/* want no offset */
-	rsv_schp = &sfp->reserve;
-	mutex_lock(&sfp->f_mutex);
-	if (req_sz > rsv_schp->bufflen) {
-		ret = -ENOMEM;	/* cannot map more than reserved buffer */
-		goto out;
-	}
 
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
-		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
-		sa += len;
-	}
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->private_data = sfp;
 
-	sfp->mmap_called = 1;
-	vm_flags_set(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_private_data = sfp;
-	vma->vm_ops = &sg_mmap_vm_ops;
-out:
-	mutex_unlock(&sfp->f_mutex);
-	return ret;
+	mmap_action_map_discontig_kernel_pages(desc, (void *)req_sz,
+					       &sg_discontig_ops);
+	return 0;
 }
 
 static void
@@ -1415,7 +1402,7 @@ static const struct file_operations sg_fops = {
 	.unlocked_ioctl = sg_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.open = sg_open,
-	.mmap = sg_mmap,
+	.mmap_prepare = sg_mmap_prepare,
 	.release = sg_release,
 	.fasync = sg_fasync,
 };

-- 
2.55.0


