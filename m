Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0D29C88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAFAC6B00AE; Mon, 14 Sep 2026 11:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B066B00AF; Mon, 14 Sep 2026 11:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02AD6B00B0; Mon, 14 Sep 2026 11:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94A8D6B00AE
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:02:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B188BC0193
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:02:44 +0000 (UTC)
X-FDA: 85212684648.14.635B3F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E2D0F2000D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:02:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LosMDrZZ;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WNH4ajOGiRyME4gV0hKpqyimaBUBR6xvgBKJbfZQV4=;
	b=GiZcnZOWGoaQjiVzv8phnkZkW8NH1GpeB6GbgUDlE+QyT/O0WwywNv4bIulelRCTBOy9ZV
	DKRaRD/U46uvuQGaw9jTb+rAyKD4WTyICra1iPztnIhz7dXcndxR8x1NCaZNW9sD+hl6QW
	wBu4qsyLVP0DA/OaYkHITRrxpWJUTTA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398162;
	b=l/B7HTeMQerT8zyBCDLnxrb3VLEvseQXpbmgkDIH7yJDYZzVlOJG1JvsTnZMA9Vhfn+cOJ
	6jlGrGkLUvMdBD68tHYrrXTXnvqfJw+K42uL785OulfunRnFlc0z9oOHyfXFGlZ68UVpI3
	5+ZCqG3FuYMUCQi8lhn3q6E5XVRIt+U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LosMDrZZ;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67031601FB;
	Mon, 14 Sep 2026 15:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1884D1F000FF;
	Mon, 14 Sep 2026 15:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398162;
	bh=6WNH4ajOGiRyME4gV0hKpqyimaBUBR6xvgBKJbfZQV4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LosMDrZZjI+QrX79kGmc0Y7vfXqOojWfZcIQPNqK8y+pCBEfaW3BGQkgB/waeaSKW
	 ptv1ekb6f/qS/4lf2b9Y4mYrZIJPJM38mAercgr5eON2xxEdqHtnVUYwc+bhdFBFd7
	 JUOyLUmBSsfp8s0yeqX1ILz0qq87+M7D+2HXRNrM+mrD8ZO1GBkYLMJNIpTmlLWWme
	 kCRpYF9FITLLy296+jZePjhEvUpWxgoaj5DGHM4gOF9UEPA7RWsolGONiG650q8STY
	 SKYYrv733ibMIKX/+HECmhlmlC4mFyhxLdCVJJWuR8AlgmxxnAFK+BgW2QwjNINvLt
	 NPk1WayinSQHw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:27 +0100
Subject: [PATCH v2 07/40] mm/vma: tidy up map kernel pages enum values
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-7-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3944; i=ljs@kernel.org;
 h=from:subject:message-id; bh=HY4Q3Cfycqa6fp8N5aZLFaoVFjw/3MQxTeg608Oh/QQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK+TT2527Ama6l20Xs9lW3WLn8fqOf/KexnPtX76/
 U1oC+PxjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEyEs5/hv0fsPuNnr35sPNf0
 6Lt6osJhFwedhEObvN7d2LXE7Of3Z+0M/8OqLR992WhxcV3K9XdavKmzV20+xHFSwvLEEa8Nyx/
 uDGYDAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2D0F2000D
X-Stat-Signature: r1wbje4qx6pbfkp67kobjoacats1jrk1
X-Rspam-User: 
X-HE-Tag: 1789398162-144600
X-HE-Meta: U2FsdGVkX19i9QuRcKOmCVJogMwgyCGKQ/bbQijfB9zporqNhh+adnYxUplY1g3l5VoiRxeQxpWGTiMJjtvxqmbbECSkYyzr4P6mqAXUPKJiwUcVjE9cegVkd8TxeVoP+trXaIuwidB7+rK3uLGJjIeDIzcBLI4EiE1w0RPHZlcT+py4cUf/fZ56RQXJOlLBw9CaF7TICAgXpnkLTf/5kGjca9SDH9ZNkk5l+Gw88CboVsfIMDW+6o7aPiurddMKO5PUJI8bpo6SH1SPv9hWIb3EkBEtAyFxfFdgs1vSjm+0BuOt5zDDcTnrTM5/Hflm785PjrkN+KNlHQuMKMD7T6MaW2k4rnlMEC+L2Ni7R0p5zmF6futozBaz1pFDRjkUNNaNKu8Mhpo5VFL2oubaKMHFYhRLiSUoKTBHtrYz6IGP4BNF/wQUQ4sq1K06X787k1bduFbDaejskWAZVV4bk8FfmCeNPwWEDtxaD65VEnNIkF9tn9D1TIY6g0KhvLzemfd4lQGmVOhErXcLgowS2WEj+wrIQPMHkNHRraqF+wvBp26Qdg5IDBSGFQY7H1Eua/AzOXZrPTLuIOFLldR9dGuEtRavgoeaM2z4ixZ2i+caBpZ0EOHb3+xVpaXCGvqz6tFaq7iHE+DkbVbPZkxozsVbuIplzKufFKZV9dxoL9vh7NRMql1Sb5bW/ITMxsfTbz2e8Nm6Wjb4pJLpeXzcnQthVMVU2t1Ku3gnHMM11jaXh1V5UbmjOEbTnbQy4zsVPdvJkkrnciiV7iU6dfY+fUBUA8oqJJjpEB3MNJ+CGA3Fyfe+caxRmPPTiRH7LSpI8R2slSsP6j1C+T4YKxYnn0PM8crIXC+N2ARZ9vp3jxiKPoVn72aAzFsFtF9UbFStjDivm33UtpPzEaVmkTFoC2+Etrz//HGDNoASMEPlDkKrCC7nj3D6HH9WRTGE/gIlDH3NBeF1xzeLlogYe3E
 uA2g5K8W
 KTkpt6IZ0xRq7RJIy0NPBS3dxhLx6pjMrj2Esw9i2iNxN0YypHyjfS0vPahDaf8yydLKOIJ+zgzSNqVyP9sB64yrI/1rsy+sdJS1bwQrFatmLtvSsmOFoWi5Prhs+0OxtQTbVXqcjhXKXecDeSSCwOUq4TYvAy/yxsqZUtwhQHR5feBZD2Y+tC9kNp6i+Tm71vDNsNyYMo7CCFDuiLv2dCMbsTVuoBmMZsFVLOQq+SQzmKX4FwJ0T+Cs65aJEN3F2mJezSTJdujqaF+NXYQVcD8fUxCkxv6w1uTE27g939vR5P/DVH3IPCtYyUFFOZAuMK7gfDGgOhGpQ3Fxq36uOwVcTvmar+8E2uVx8WEJEAmGTm5UGgBNRCIybwmnm+uxy+VPZNMbUgbc+Yw2S/F5+pzISx48ZQh9lDKUWOtHnD0Pcr5EFkME3nJBdyuWY+mB0LYCzhOlSueUEduaN3p6WKezn5uk5l788ZXFvtNhPcgaoUtqRMIiUrmnKC96k8hc4MNUbiziSDQz7ZyTBvDmfviwCwtHb4vR5hk2M0bx73yeNnQyeinN/z0MChWNMuVW05cJpf0AlN4eYEfoqhUUgIinwVq1J3/6U0NaTrla3KClSq0HcPJFgDIHCVH5WbuVA4mApdYgFneRnX2En8AVNMMIHAs6OGMCx+ZGHmf69RD70uoT/79cCwOaGBWtw/J+cFfZ6ZMS7BVjTshP+adz00aCLcVvzLsisUEWvLCL1JU51py5BqIcn5SNQd51nw4tJDEgDoQlldVAlOQhH6cAenDT130Y/FVxnKdFyVm6jo5EqovJzzdvvwe3dvuwTGyr0/AaQ44LjobDh2z5nhGlf/Xs0V8gCGsAoT9JPsb8xq+tCuXayZXM9SclKIatfL5Oigj81O79AWDWYeQ074BH0h9905LT26EoaFqB1YrzgIlM/nN3asezM5dFJQSJ4OIzLLbqB9D/wYW7bykdkIn8h+kAGAN4I
 umFYvifI
 9dg6fplnprayWVSTNTTxnFIOjsJ/cCgHkxLN1QktGQsYSjPirp4uutMt7HeW405I+WgJa9Erl1+yAAE+uKfhm//TMTAFkfvTDrVHdEFAzulXHOebriq/9gxg6GtPbPTKY/WllqOY5tl0ClTU6xLIZHrBTBiZwVwZ+JDi+Zt2nGTEB6NZqjZLQnPIRrc4T1xSBKl2m1OeVm3gq2jPurjkAYhhkB1rIpLuuhoGn1FD05DumDlNQ8A2N5Ak3zEahx+AB/aFLz1mcGh2xw8BYkBculeOGCLPHHFSXqo/p9hV0PTOk6pj2jUramRq7jUKX+cB3HLkzd3z8MqS98Kx21mGOMfGMcTRKPD2jxmKo6MYrBKVSFHHKHyNm8YvTsd77ynOuAwHyT0ycE6macgYbbKnKPxLAu2ceL15Y8+yYz6NKQ+5tfRmMfAvT1Qh950ksuqOIl0OfLE0IJnDhxJg9e0ah0p81sbV3RCbn/ecf04yUHglc4raT/XxDsvenwus6P8/cXJVWrQKhMRTNbdnyOnLNp5wKIY9pixlY6ApXlsCgj5yO0EiVCqgw2rQmtVF/Znx7yTRYsXOquAN27es8qQgy1JwKnfvfsKF3nnuM4QSB0Q8OVfdRY/qUcEGle128hLwlmB0gQCN5q1iJUt0KN2kfqt81s3JYeSlG4mY9sNfU3HK/aeiUgAkrfo8A4s/lPU5DoMa0dWCVDvBfnUnG8qR3Q5K8fHxKc/uS74np1Tmm5hPf3/Sd+Wyth4nzD4UjeHnsL8oWmMnFMdpuSYRfJkUlJl2EJ/4zgCo59sn1b9Kq5QgDNv2Dxe+LLtEdfvgoyCfxTuEq15TOzkUyXUM53J5sgNbkOs1GUB/mhbRawCd5fZ2Rdqh0LinJ2TAcdJOTSDAJzR3W8Z3esYXq02FL+tIGEWRCPifKhD2JVzTrH5Jjk9qqNeYvL2ALkcLGsrZwiddh3F16qlFHIdH4CXek8rzRZOAnv/L6
 DLioTJB1
 yc56+n7kK9dg40QWC0cDWhdOf+XwmWHsvRy5ctdDN8s4jZXiUGimDWuWadLNBYcol83Y0mvX5TRMBlvXpU7iNeBFB9+Y5ozRavewzdKQm+a+cBZHIPUt1bCcFheKbd4MulZvy3duZS4ziBLOvl50taSIrtfB4NxNuPSzYFcTYTrarI3iVME73uUikxAMaRdBCGKDGg3XpBFQLAw5mCQ9v3o+K2Z0zgJcUaJsmorZyGOUQF44XMT7gXva6RsHlqHEHe0vmz+uep70puXXZg23+3oYl7klmGO2td7n653IaxkoLIJ4m+iAIrSbnvvRsgncFzvAGGILoqIYnxVWmz8QpqfcqtWpb/+DPOYttCupeMmljW/zeJfvorziEB08AAtexViw3Qbm5Yw/7xOb9wDjr1NRz+AJdbGfhAtJtQvDI+gdsemrIaqiUcS19G//EQAPWZPp7FLyP9rzeoJJ/sUVlzGkvJt+rJxrVf/4nQ2cSsaW38JQVIpBnZJnJ88DR/wFA5pRcTT05Es14KuvAe3Zpo2+TB3Nh+iWpO2H9kuAjg5Tcby2GnXDiBuD4aNsY1E0WTHqJpxjN+MTCQBdNAdMEUt1wtUcGAVEcdHEM/sEuqJj5Sl3KvEzTlDUIBJR4fescNF/8LklaffCQXlym5yRyb7cYnNKVTpHqoyqZ4wx/o3JqaUdsjjs79bO8r0KZjdE72DSDcvchnFQngz1cthzHRFuMlD9veyn/1OVT7D1xofsmWMsRRZspKhMUd8lDJEd80ZWBfiNlIxbhz1jXWN+GYX6Hr9iFxe9U3rbfGwRczo0zfyrcsk0Z7S6+rPcxVDMvJFtPEVStHrOxQmcwhw/5P4BqYmG/OAG7KMK8d9xq1aQINjoDILqLqyp62WOly2e2kfVus9xFUCpkB+CCycGxOkJ+hMYPq6+4qnGPlCfD92alpXdEzlW2BmzjEJI+zczv0+YyrosUNvCtxaU6XxCAdD0vPKXT
 +rlFJinl
 a9+wf4fjpVpHutkjw0eu+GRB74FZg4/BxBg3bH0CW5TIQp07biMnhAZVlT2NegLNnR7xpvEYFmQrmNeWxF7C0FguBsOHYwgMuu/PHDwYWqGuUcc+ZV+QWUw7soIZvH35PDcxqyaokh4vHUqX+Y7TrPDORzPJo8sLqKXA4rYYw9AqVBqv3Koe0AlILP/7hg42ZdazbpVwYwF1ZBet5g7AmFMDTlCeR7UeSmgnHq8xkwNOyDZQMmwZwK37lS9mFY3Jg00mrMtb17lDOBWRs+2JEJjeuG4qHUwJU7+e20q8ML8CEsdI9AWF99vYLfeqGtcrYOgNVHzjaSgjn2MqhwlyOY6B0u7pX6ccWeE5g7UBegZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
MMAP.

Also while we're here delete useless comments for mmap actions whose names
clearly indicate what they are for.

Also update the userland VMA tests to reflect this change.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 2 +-
 include/linux/mm_types.h        | 8 ++++----
 mm/util.c                       | 8 ++++----
 tools/testing/vma/include/dup.h | 8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0c17f0932b76..a1f2d375cf7d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4623,7 +4623,7 @@ static inline void mmap_action_map_kernel_pages(struct vm_area_desc *desc,
 {
 	struct mmap_action *action = &desc->action;
 
-	action->type = MMAP_MAP_KERNEL_PAGES;
+	action->type = MMAP_KERNEL_PAGES;
 	action->map_kernel.start = start;
 	action->map_kernel.pages = pages;
 	action->map_kernel.nr_pages = nr_pages;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5413bd10fff2..9ca2ea3664bc 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -815,11 +815,11 @@ struct pfnmap_track_ctx {
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*
diff --git a/mm/util.c b/mm/util.c
index bdd5923eebc7..438170490e7f 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1467,7 +1467,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return io_remap_pfn_range_prepare(desc);
 	case MMAP_SIMPLE_IO_REMAP:
 		return simple_ioremap_prepare(desc);
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		return map_kernel_pages_prepare(desc);
 	}
 
@@ -1498,7 +1498,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 		err = remap_pfn_range_complete(vma, action);
 		break;
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
 	case MMAP_IO_REMAP_PFN:
@@ -1521,7 +1521,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1542,7 +1542,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 2986ae6ca1e5..1098655a5f4a 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -454,11 +454,11 @@ static __always_inline bool vma_flags_empty(const vma_flags_t *flags)
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from an array. */
+	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*

-- 
2.55.0


