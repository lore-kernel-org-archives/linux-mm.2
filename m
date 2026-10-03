Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70E8DCA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 811116B00C8; Sat,  3 Oct 2026 12:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8D16B00C9; Sat,  3 Oct 2026 12:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FDDF6B00CA; Sat,  3 Oct 2026 12:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9D06B00C8
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:45:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E04784099D
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:45:11 +0000 (UTC)
X-FDA: 85281890022.10.2E5ADBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1FAAD1C000A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:45:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j4qRGtsg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045910;
	b=ch6YxeZzmUAQX+X85qIs0K9RZbOUtJOTUg3x9xuDEoimoZkPeZegQEqW0t3iJ29oBGSxIB
	hxcYCMvA6DDbSB7TTOnRzSSELsrCXYx+iiKqKtLVuv3GUYHr+H7PbvhooshaSNIrzlY9oC
	c7+NOqUv9KJl8G+aQFq2Qs1ZvHuCEno=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j4qRGtsg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNxRxaa4FCG/PyGcafpOW4Vhq6S2764syPChNm7Rjt0=;
	b=vZY0EOtQpVg6uN+BPPlw7JDo5+j9m2FSUONwS0s9u0zvjZF5uYzgCOy0nf/ctjL7lG0R+6
	XdLOu33V4q8pd4Nb28lC+ihYdGBWEfuMhJrWGN0DB0tXzocEkx/pLYXgUmPAuU+fior7Ax
	lKNgp2P/aTCsD34nReFObpBU2z1Oexc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6DC060D9B;
	Sat,  3 Oct 2026 16:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FEF1F0089B;
	Sat,  3 Oct 2026 16:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045909;
	bh=sNxRxaa4FCG/PyGcafpOW4Vhq6S2764syPChNm7Rjt0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=j4qRGtsgQ6djuzuqvyz2e+E3pUboFJ2dXQg/TM+LFKeGrf5EC7S+Qh79x8Kzbzt39
	 FAvqIqzpxFJQ8yWN2Ei+6/Oo44KI5T5pKh2dJyAeOEeLIwY2FwcsiJDJLHnF8fwAqJ
	 iKlroW8hXtPnUSLqT/VrWzy2gwBTOjP7KsnB+XvO7vgWHX0sO7S+oXJOQioWFroHum
	 89rKRcvqhT2hBQQOv80p2OH9OQHNZ58MRDJbSPuyuktSQZSVoALgeDcKTb0Ge0LvoD
	 MrOB9gPqrdDZwS2aI1Hdga1wR14e3gk9cVjWPOl0j1johf5duE1vU/GN3XP3cNY2Qi
	 KyVoCz591UnbQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:33:05 +0100
Subject: [PATCH v4 34/38] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-34-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1268; i=ljs@kernel.org;
 h=from:subject:message-id; bh=HkTbLGiMaDy9mSSm1Y8681jTpkwBcd1ymOGev1wsVuw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6unEc7tciRfd9ceU3zWGI9r8WtxsuaTp73ensM4q1
 Qo1CcztKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwERs/jP8z3okcOup257oHGXf
 ZmaVJytX3jknkzyjebfwYvf0z+3fvjD8j13nqOBXz+/Ix7lw37qKbesWvJf6yVyt9j7KfXvClmR
 jRgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: s561jgd6ygk4eu53b9e1bfqanfcxgi1c
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FAAD1C000A
X-HE-Tag: 1791045909-147802
X-HE-Meta: U2FsdGVkX186x9S3E/inYIzIUeqJRZqm6ZKj79n9YsykNt1DKR4qz4g2zUPnnjChn7SCsiVC0KzcE7ZA5OWa0ciYNJsRUBXsL0hWf7eWA0dEreiYEGKjg29QAx7wtdfzJNAzB3cEJ/g3moaiK+Wak4ku8uDsIkT1qb4SnA2Qcqryy/cqE3jMJnUqZ6kuE9EOaeQ6y2OtzfWqhh2ZepNdNJCIx0sziq+V7FCqmh8vSqIjhDg7NPohN4VTtvOiWT8J568wNvFB7rZ9/UzyW3NLXDyOtm27KfaKnTYrQbYB7HtMWwgc/hKlQhkjpPMBO/x3MZuq1oRjwoLOwSA/MJdr/q8W6fmOaDBAfFNT+nDJbQ+6jIsgZjNFW+/Ko1V/pSWihQ5IhDPIqv0SA7oVDRGJWprrquiWevjbnL3MMrJZwMq018eQzlVt+IIPv76M0Es2e35OC7I0prUYV/TMg3au6bmjfsdCPCSvjRrHmSK1nhtfADjZhtKMktyLC0DWErNXh5S63Tt5Oj+64WFtW+wOCZhDOiDxu4vc6XmhvXGXNHZ/pdsaFETe0r681rS0UrjepjQcFpYW6X9aNjQdM/P5kH7wNKehbK2QebvVLgdyA7JgYkV+DbmwOMx6jb3LcBtYRriESKesXXC4U36zAV/qEEb5JZoI/E09c5Be4rrrsdu+kXiedf0kI/MPw3pqrxvHyJHhOqGacf7Pwla66KZqLlYwCPWSBI7NShd19BfBiUtK/eu2A5DNLmp4UF8ux94SwItgrlBqhWUMHYF+aWVDt5jKihnMgbv6WXStGChvuF4Y/AR6v1d4dsar2BijdVPdxmJVzuoKs5Jz6YMGhVk7wHHONg2F83rYuGK57G2mBBmt08A56MNQtTW2HH7gBR++mwofA0KO6P6GkaaUxy7j2Vjg9i4jkDxYHNj4RCXf9YfyxZ69FXhtId7vcB6wWQN3+uSw7UfSj3xSF9LjjsI
 tsOZt1dE
 51h3QTCql+7eyykRRBvcUDZIdeaxVzb9Ifp960ulRSk0RHFnMR8BJ0u0Zqhmgk5QNPf1kRJDFTvRSPg9HZHLixy5/rW5Prk5ZOb0aGyH2u2GIFqRelmXom/ypjv2Ht8F1EmEi7qxV8T4BQXsjG9E1LOjp+pQ1fpsfMi+UPdqg3XHDYfb+bOTBs/TJM72XTOjzt2O8hJweCj0XhMHW6j8s64kbvYA3EQ0nHRlvjlaM/cv5nM/vgXsQiHXQNaPBI+qJz0jEiU/3I7WMDltKr2PDSzXTXv3HxMFOfsS90FgdZq0j6MGuiJODgEPPC+ab/DtjY5sOmigsAXLNOZaoWkvfJ59EHJ4fyNNU6Rs7tBbwtw6UYCwRBWX1cWT9dy7fIAHpofxbtV2R/0tW7FVbIqAKt2Re+lyG2+3vTU4uOuLGl0BPb3+mxWxQWYLBUMGOfDyNNj5+C+ElIB2GjV3IkfzuKIirdNotXAvan0Ofx+KtvrysmRGyF+WrAcQADQNsGSnFT+6T+7W4dhfPAmzL2PzkGR+XUQwi6ExqKOohgDCrYDzNaNe0CU0/E5se6WXdn6OqlZlFYW7cquH2kumzKPTIlJKHEbBRNErA6Lfuw0bje6YgQORIScTEY4iirCQkhu8QdSD4pHhGJw+u/6u99DRiXKyql/aLqIc5JijfuY69iAm70sl3PSyEAXRRfmihrWoNg02WZhag/hXJoblArAOvRx8m4LQ3mbN3ABs8aqbo5OPvzUGOlFVi/3KggMB9QFhuEPAQ9vTD4HD+pHevorfr+FanOkzgW+YzRqjTfBWFKNXlReWSJauCbOsVqoyc19KHf00S5K3sMW3ZK1I2YvQ20iBufIVuXQOfebg1ZGJIbrYj0fhLQ2AIZynaADUUD/2oFgR6qXSbWrillYVmc2Uz80kYK7Ucz5B3TOHK/b/SlwQvfBTWkcSgQXACugWXS70hR7Xj3m8ZgnF87BYRfnghBKTLDC8S
 mhgwcoqv
 +QaOTGzRUmbkdNyeBMN7SvXz4sbGW0+0ql6WqxQewGw5gbu+wv9rIEHuHQC0HTo0ioikRot7Y2YhSGJiW1ZO9oDLuWZojQUouPyygNlDPtWGyIbaoHl6VCQePXbL9+n/EotvXQInwr1+0RIKlH1ikX5SnmgrcoQuCuhX20iZvHCjMxUXZekojeIO4npJjF6iXu/NdH9QFgdhPMav/9BHevnDcifyJV+FcPXqXNp1IjaWAVermN9Ls2YlHUYFMx150n9qbHn8CoSR4eel5MHHfxdSaJ4Ko1+jtVPKAJo9CVNh+WXZkUS2WR0vCyyVGhQTlNXA115hoiKN2vjOMbkGdVWZvVzwNeD8/duOdoFnKiISgB4m6Nssyl48gSy3bUi/3ivqqOGbnWYSTIkOVR/2I29y0v2pzer7RszzyaQpQztehk5cjK4N3SJiIxoGr6Mk5dWLXSa2wauTDzNR51opGXEdVMB7ddB48xxclgI0Ahtm5s4C5Sk4lerohyXBTFSvlK89rqFF1/Em+mXQH3m8LBhtC8rEjEwzElr3OJ3pCHB7X4KFl5VHNot4SdhXFob9pP/icuYCn/jZwhYSUD3wlymqWzF21FMXVlL2i2uN2cXpQbWCXnFUFWy/E9UGNz+B9mkP4oE1Rn9x1NNzkQsWIuQht7npxKateSBeECx8+Dt6ZeG6FKwMs4K7S2aPXGNpT3k/jsvGcBi0h2uObG19rffL5ToVbRSbyUhXg+wZnbpSwoLJUTWZCJXNYMTuhn1wI5t1AgBQ5aAV9XpS/+X1Fi9tJS+0XUDAXbPUv4A72WD1b0ykC3ZJ3PuebwYjKUYJAnS8tBI2Eg0E1uCpcNUjgDvqNeA8jUbwD/A0mFWfmpA1xq/EhPyJPBvsd2PYISg37Wi2yphB0GgogG3oAmtWIW9tWxxgaF+bAvAvHDFFbIIc4RJnhdIZRG2guwVtyGbiZhAXIsLLOK+nPiwpk5s0fM1hd0poK
 9j0mxbs+
 rvnN5XTQHjHQBHsUI3bGwbfjHa5lNJxK6K6teEdvR0TVSYURp60XHf5LDlzcsbkgGm277PvtpaBBtxkEVapSyzeiO8y8/UUaDwEts0Dem0+GGVqgqkp+t4Qt7KWGtkEcBDzW16plpdypqHvuO1+MnPxAVn4bqUMiDDPM7DMwgu0+lKe06FZ0NxBF/fYcsMDibWeRrnCh1Law3tXyfOFg32ii3PELBu9PnFWgOI2tgmtYROBe79eFEHEXMofYZ/GovQ39XLNiE9T0ElZeG+N+7WXJtz9OxUs5GPZK17MJqrGkYc9IDQZgunQp6jWPUeR6n1J89sxVar+E3MxZAPPtlckvtOxZ780Jn/9PMatiC7alPovcbI6YqDJCLJCTduw05u3JrYl4nPSmMcmdpHTXOomOd2tfEueby4XKUMzLdNyenXoj25PdxYF9bBiG8cjO1Maixspy3kLLHuDOeVHPdOLDTu6rkJWLLeOetOZ/AOuS8KbR3DQEgnQerxQzW4AjSAGM172mCBnkXFJGnvQHbNDZEN0tcCFS5gMAz7h5axsMElS48CwU3Tv5qqFJGhGr/XYCEZqy8jOU0P0vf+IedIEY92FmQM8RdiYGupeRqYwC5DnPrdIAA5uGpKy38oc0YqfrjBRSCJ5TBZl4TTh+aASetpLWMBsDC8UoeEdZbOPfsJES/x49x8sNTbuwsxmeUttmpGSxHKJ2rPx4vb7/uDs2hCR2SQH+pc9VAdjwid6EMnbaKAWSIkcjfNwQ9CnhX3BoAVww8142br5U4TLAs2p/NlE+Su3YDPZ/sMUVyLaHoM2VcIGZRw4fSoMJBCQV0KzUXd7JAyK3wRnXBJqduAHDP4Ev49tzHlQO+DeRU1GZ1tBgocLMaG1p9QATZCljniUYi2rsyUO8A5KcPIs2AttuT4pi6UjzlMArrfrSfYCxDWtZxRhBoG5wxP7wiT/rp1HCZsRWpSv3Pi69W2gB1vKk6nWhu
 rvEgvzxt
 d6+kfwMJCTByvFHnkQ+hhunPwE+f0LPQmrdn9jr0bv6WXIYnk7mTHdO2ga1tcE2mLtgzer21HIsRqCkkdxtfDsXrlxOSUbIOkv2Tq82mPLszneB69NmNOkZEBPEbtJHLi/HPS1WIkIMJ2ZI194N13o8YO+jZVck/7o46P7y7/GezsOSTeppNi8KS5VXZkbu4e2fsg0RxKCTzVAOKlVAHG6SX607Cqp0pqrAMTBoHBp0ZypBFpUET/DigatbVGpNVGunUjIycDI03GiJmmfaX8JnOi+0G2aLgKkFS177CZAUdrnCBJk6KWpQ23tewOABGipkXbmSG9T7ZXDG+TYeMUuo90cG10ujHLDZFum8lX0DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A fixed or non-mm-managed mapping is one which sets VMA_PFNMAP_BIT,
VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop as
mm-managed mappings may not set it.

Using these predicates rather than VMA_SPECIAL_FLAGS makes the check
self-documenting and helps eliminate the confusion around 'special' flags.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3b318efa2916..7adffe8182b3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4418,8 +4418,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	if (spin_is_contended(pvmw->ptl))
 		return true;
 
-	/* exclude special VMAs containing anon pages from COW */
-	if (vma->vm_flags & VM_SPECIAL)
+	/* exclude fixed and non-mm-managed VMAs containing anon pages from COW */
+	if (!vma_is_mm_managed(vma) || vma_is_fixed_mapping(vma))
 		return true;
 
 	/* avoid taking the LRU lock under the PTL when possible */

-- 
2.55.0


