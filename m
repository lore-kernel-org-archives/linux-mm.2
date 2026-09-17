Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CF44C982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0B06B009F; Thu, 17 Sep 2026 12:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652906B00A1; Thu, 17 Sep 2026 12:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A616B00A2; Thu, 17 Sep 2026 12:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3BB6B009F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:32:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A4711A0419
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:32:42 +0000 (UTC)
X-FDA: 85223797764.30.45A8D8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D859D40012
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:32:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FdLw98tn;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1TTFxJqK2JOmLB4wxg0hlSgvzQnwmSO7NGWVXFT9S4=;
	b=ps5fGPRr+kKxsFmnZiTJCxkgZw8Q6E/35vUMota3ud0z1lD/nefJIupub4u/ZNhKwCwdhD
	PiyVgcF6Pd4p4ah4z4QNfGbfOEP5E0AVQ1FWhz0l9F2jvfKDRuLb77SBiIIxaBkQGuPXjP
	8Rz7hw6R6OJhdHOPXks3/nsCWdWIHy8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662760;
	b=qAxIBs3eJgpSe66MQ7zinfLiiMwlop0o6Z6qbZrqy5wVIR4nh3RWTr0hRBb0qx2hAyWwmV
	Yjv3MzxMYakgA/dpjTmlOCX0NVFW4yZ694ZyL78FJzDj8qdwOqmv9Qo79mJkzGJsAFtpRS
	GcgX6N36bIG00GmYUj42WXo3l2jc94M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FdLw98tn;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BD9560204;
	Thu, 17 Sep 2026 16:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC201F00899;
	Thu, 17 Sep 2026 16:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662760;
	bh=R1TTFxJqK2JOmLB4wxg0hlSgvzQnwmSO7NGWVXFT9S4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FdLw98tnnAoDtWH8kD0dPvk66NNqKS785LfS0XG2ecgpcUicXfTn4HGu3RCwa2PmW
	 tPhI1GvWWiu11djXSGAre8RjZgwuCIibHgzbSC6aSdaemxpRXKiorH/HqCo2sgumn/
	 fvbto+ZFnQL6qSXhc1Xj+kLs10DOhc3iBSRgQQoSDG9t2MRbNJb8kV0gDl2WYT/Je/
	 PyeOf5EwRvMKqcXppj1Nc7NIYrxSxhLgXwXtr9nlTLPjIEzaIs834ljJ91EuHrQrKT
	 /3V4+AavOF/q2rkxgpcN9Y0daI6siTUv8WWfukz/a4HpzwIh6nvg4pHK3HEBHqDDmX
	 OLAFkk6l2yBHw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:28 +0100
Subject: [PATCH v3 19/40] fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO,
 add VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-19-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2362; i=ljs@kernel.org;
 h=from:subject:message-id; bh=In9WHX8b1sLbbe6jUcP+2i7LCzJ4p//dj4w0OtHuz9I=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB+8bOi9UPLIo/LJk2JWhM3+b3BdgtnAyfJrpf4ET
 s3Sm/x3O0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRD0cYGRrX9Htz//Woqtj5
 yGpTVNPsHHWljs3FZyeckZj57lRJoCTD/1qtjbYPt3hX96zbuyf64ve193k5H5nVanZnM7eYLUs
 W4AYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: spbm4rhgxzpx4kgc4s4jccryfuqhaoxq
X-Rspamd-Queue-Id: D859D40012
X-HE-Tag: 1789662760-684195
X-HE-Meta: U2FsdGVkX19ToOK4fdeHL6P2Km4nZao07I31vDSrJJC+sZTl3W+I6Guf7sHPbxWV1xCzs7YnBZJzuOcXfCf6VLOb0baxIplm89fJ5Z1TQMBNDmyJp6TfQX9oWY2Hnig4QeS2Waqd8K1N9OAvY8T/NkXRb/z4Mb+NRUWb9SsdXFKFx52xkvc/z7gH99ugZ0TR4lK0FfOOgOdywukTIrDTXvHtWyoJfAXFV3CknWXQAA3SoptS0ktJZeOzePgQW3TxX24I4VYGbXoW3nGpZ5bgi/RS909WIAtw6XMP8MbtuBFGthhKXaz4GGNWpiXGeTput7QOnQBI1dP9UAjnAalpu4L9fmEiCAf7Jv44rDrPR/oP/Uas80pV6MpE8Zcqo6E2L8W9OCzDpmmUREF9oGFpqVzIVsy91+R5CywI2oZhZw8ra0ZgXe8YWDtjkgJ9hOuxqI7gqvMHu1s4ux4hqnma43OI4XBj84vsRQsKMhPuaz9ylllcgNOczG7QFrcJJOCd39KtFoWupZsjMl8WdOHRRjUzb9m3DrQqfQx/cCQ5kqcAAgjmT0eBWn/XiLnNGen5xlcX3t5UJnherpQO+v3nY1oYDn9LAncRu6sMfqQZjc8kJJxUElv+NfhkVRjCxIrplaZejaDKRZRhakFdAuPknF5MB897kgE4gu71SYh710mfxZPf2iA1iUI4vnMoGHyzsg+R+8xullJfRxLeH5eDZq7M/QDI+7+RfSwY8mWGA2GGmSlS7gLYZAKSePU+2h2Rz7B4hAAGmyFHolsmWEpxwMJKeP0oyWAtJAoPITGrMHEWO2gOIbbP2rVKDh4wQv5MRubuyErW3tV4qlJAQ8yn2IEUxe2HRmSXJMymAYM7tbSJtQk139hT6OarDb1fhX2P+6Nme3nmem4V7KjzBlCLTOKn6sLaVN5/apfW4Hdu2zHUZQbNHd45dk1PaPKu2YqBC+F+sjKNVo2YOUO4bZa
 2CZvOhdw
 6WdSBefIyKLFGmaYNB52kECMSG7W9Ulfsq8lSWgSBHGeP7Tw/iZfpEiez9zLNxmdsmkFbl1YDkDqBpuUJBWHBSIF+HwDs2IvCuJ6GnEgTPajV4dAAIicGOT8UWfRxOM8R82AWoUhRzvheiwpWCo3XJZx8raGxZ8C4drfOGp/n+qsUBo2MScJVe7B2A0oiLlGnQsfxMhm3tJyF27qSm08zBievawC3EK1P2WP9NOBLorbBIm+jVzntqwtx3RYXijBR1JaX3lGZDtDpVGIKYdDHtaXRWyW+GvwBk82SYp5AcwlnGxwa6Op/8MI+Yng8IZD1NL+gL1VEmqA+LJIDYS/xxkgfLTHOBSK/Nru9xJ2PPtzM6PJ1dfp/ERpnCZKaB+QEl39exVWCr2UmK39Y5UUvtPQ5Du7dLhctlZ/7D46HhgeD+8GIcRytmFtMbu2SdIdx1nK5oM/jRSHr0BevmyijhUcBWp2LpHhhE7e/9DeEpcZArNRzfrav9HxP7gfIL82DwIr0+DAU3fpcEomSAJV9vTIz2TPU/SNie//WFDwZds1fmGd1cZbaMu02J5W3GyKQEcykjx9r5nTUvLxYKDs7pVnLXvWeXUESn1olTecYztbZCzR8ce5zY0JZQqRDr7jXalzy2dx09hRidsMSejJ6e6xXvBL2Tylu4GdCqFy62QBSBCrwVoePhD5rPQF7p78WX43tm2ynbaM1JZq6kxVq5EYEjZAvlGkFyvgqDvcVVxweT8Sh6Cc5mb0CVVeR2sTtMg5k/pPuv+vwiUvzWevnMOqrgoegO7dsa0b94XPCxO1k13uteXAs9nLItyP0RvaLbSZzbnYZsMV+/Ofy2mYIS2hylrWT3Tkf/6gk69QBkWiBd5Duu3BDzKr6DJ6UkXyYiLurjohL0aI587Oetd0xOsRgvcXPbZeH2KINq+bVpyNyvb8yuTxI799MjeFso6iYeP5hrn3joamL58TvjtI0Cg6MZAIk
 aJYtlzmn
 HpjKrUCg3vI6DQDT9Fd8JLF/s6S9oHI3avPAzXjWvl1WUUoMz3a/yTQ21MXwQunEMJx7Ib2s7ojObzeVZgL34PEverj9HFsr2ZOvLe20+8jQgUJ/FeyW/MnTVLqT9jo8JKESqXn9TNaAIhdlZ6imS1U84fSWyvzRfR9YOmJEIG72tA4zI8zXl+iaP3z3kAbbhZRUvDpKXArAjShlQ0TS/tsHSSMorrIR0v3X70y1DXO1zLvGd8f1crwzUWuhaqi0cjIiy7S0rPfkoVYoB4Eb7IRT8uzgt28M46v+b5KDLlJ7o7HNnW1cUx10XBpV2JmHrcqetyow87F5e6bppcZNXONz2QVp/5vYrl4Qjg4qvHDQCMK+jmHYbtIllVRmrEN9+C/Zql1W8b42ZS1Ft1wsxdFpmWrlbZpElxzVKh+KZ/+r8B8aBHlxA+aJBgVLCvoBiHej47HgBcgOCsT+FwOetsdvFCWhz0jd6+YZu5LcsAEhc5zxSeREkRLQ+WlygoMia5RIfItLavlOin+91/UpS+TAWeklDG05+YS8GmICSh7hytu/IGSvrmYH7A0beOpgQe/ISEdEM+Z4j5fEEJ1i+LgMlb6s6iZqTf+0pvosJLZZveLg7NkvB/wgimNb0SW0uX4t1c+X4r4Ad9FBIJr1Zmes8fAuBhhlSU/DRCJIFWdnvSkIbDTjoq/KgjxzIVHVyPL2IQU/1In/2hVK0by8lky/Jd6KL1RKVxluAeXwXWxHEXN6cYH2ExmsYrfREHxWrItyQQG1ZPYtzzW4JJQtGpujCsFcYJBDu06XHrz6RV3VmdGpytu9Ly5bt8Otg/T4KeEIQj393+ADx1LCjiR7NoEQSMNKmnD/mnJARYHrBovV3SLVhtYu6catTj1SKmUPhKLDELuJ/eMQBIezquLfh3ecnLDLBfOxAuCJBMiTu8uAy3e4jEGgBknt+0M3sLL82RYtMU3yN/IrPb48rPbYP9SVnBWbv
 eBDu6NqH
 YjuhpujVTyb7Tm1TvL8ywVeo45GjAfyku7tEaUaZr4g+SqRu6VkqjTOPwHwiy3vu9os6VBBjbXt5GHlsG4woPHjmX5fkoYV4ROXidDSaVk2gkfGi5l4Ue3kHT+G/iIygS4q9wv8e3H45yUoWbiAS2erZ6cXnPW5ib4tgikN/UrKJVWEhogzGnj+P6Bnu9IdstxAKf6x+ULOTJCfhMjyzHhJmyrvgPn85n4gMReLpsbwzFtWsb9BNxSFhh/DCJXnhHET3nkxsQKxnA/00Ifb/4C0nxvtkPTGvK09pEhDtcpMl42bLov0D9BgltMy9KKDLLRcA3Vrg6YMkEjmhwxnqyaZ/AZagq0LK4YPfZ+enVAlgcbhYfidv2RAUllHBg1Oz+m1mXRZVnhCpGwuNBa8FiptcY2YjyEkFSrqwidNLGAL3CnkzJ/f97YhsXkrRz/1+azbyWiFx/7kLwnCTah5ViCpINe685NAc8IuXs3ZjuQI0L6tdbEa8fPK2kx0+UKSdSVT5foS2jKRlJxNSbjBlh23dPe8jn6JfW/1wVLb4jUrQQw5TWLb1fQLn2SWzDUWCooraV0O4jhzMeO7Ya8P/cVBQNaZJQVDOWJ3wu6oFOFwp563scuFCme5zw9DNiZ8qbkhX/cznzbJUnkEUCfW9KTX8iGghq91yXZ/JGVimG1/+GKfeTwn3+iHUFolJKfDQn9gWuc+m8EAHqfJ92pq/q55neWovX665kNvLb4C4kOYrTy0lC5mkcf/sENegg0oHUSQKLtQCq7WrjfTGfh8w+gtvwsTdrPpZ+m9BJkBKCuxNzSf2ocpYCe8leHo/8zwXU5GVhEad1vksK+e/w8PH59HpBOtTSmnpogcGqLlpJViJLU5dF2TqRqkU57BMpDVd3uScnFoTqEMzGBgjDcWmfF2pwBXrt9y+YovMafovKete9HnSa+bfSppZcz1geKch5PINrKv9rFcWAXFbFCg/+joD29BRW
 iESU2C5Y
 dCQg7ZoNQuHmiFV+A0QUsg8f0qxTA7nYc0t+jYXGr3p0b6QABqQeVIQ4sBbI5cv0+igMYQ0MxDFmwtSvjMYwxC8cKqK61YBbL5e1WMCQkLVFIc8OvLUxdZgSQhBCw1yhteWD5I+Ka3t/WM4a27TqBnXknRF9xulPXqzkpa3Ff8vF9UEpUjof664wCwPic9RRHl0r1JXwbZV9SVFx/86n+jbz+tWlzEcn+a4ZP9v6eYK1btagcOLJjsME/AXKX+2aSzb1qs8IqYQNaHt5QI0QUOgLfLJUxgAx87TNXxfw2U++MT+AUDPETOshDRjnwIcHlAScyZ2GRTFSo3bvSHnIZ/5INsccNNye9MUeVNuRs/KAQhGiwzIKJnQb1szH3eNTfUDEaTTrxl7Oz59E04qJsV68km4UcDEc47Hmka1Yu2j1IofJmHn3adYCr8vtMQy+wYl3Fcg2axKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently all drivers which use defio allocate system memory. All of them
also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocates
system RAM, so simply failed to set this flag when it ought to.

This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_IO
in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
erroring out with a kernel warning if not.

The logic requires a page from the driver and since commit 1ecbc7dd2902
("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
always required it to be refcounted, so this was implicitly already the
case.

Finally this patch sets VM_MIXEDMAP, as the logic is mapping
kernel-allocated memory so this is appropriate.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/video/fbdev/core/fb_defio.c | 6 +++---
 drivers/video/fbdev/ssd1307fb.c     | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index fd00b86e1ae6..fb359ecc3966 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -366,13 +366,13 @@ int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
+	if (WARN_ON_ONCE(!(info->flags & FBINFO_VIRTFB)))
+		return -EINVAL;
 	if (!try_module_get(THIS_MODULE))
 		return -EINVAL;
 
 	vma->vm_ops = &fb_deferred_io_vm_ops;
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
-	if (!(info->flags & FBINFO_VIRTFB))
-		vm_flags_set(vma, VM_IO);
+	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_private_data = info->fbdefio_state;
 
 	fb_deferred_io_state_get(info->fbdefio_state); /* released in vma->vm_ops->close() */
diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index c4fdecafd856..958514a35433 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -763,6 +763,8 @@ static int ssd1307fb_probe(struct i2c_client *client)
 	info->fix.smem_start = __pa(vmem);
 	info->fix.smem_len = vmem_size;
 
+	info->flags = FBINFO_VIRTFB;
+
 	fb_deferred_io_init(info);
 
 	i2c_set_clientdata(client, info);

-- 
2.55.0


