Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09406C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9606B00C6; Thu, 17 Sep 2026 12:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9856B00C7; Thu, 17 Sep 2026 12:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0720F6B00C8; Thu, 17 Sep 2026 12:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DACF66B00C6
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:42:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68B3AA040D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:42:02 +0000 (UTC)
X-FDA: 85223821284.07.F7180BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9B5174000A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:42:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c0PXqfZ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789663320;
	b=7ZTbQJYfWAlvpWjd1K2ux+qLvoXlrrejnPdw0wIAiYOsXSvMzanDPzeVQ7z85zIPaQZUnW
	HKn2E/LA36QBWqdXfKFEcDCPCyWpsEiEwLHYN1/SIqzLKZuYXwL2PGK/bR1NUoN6YHuT92
	yaLSk6LHPMy3A32yvUmz6cxUkHiQv4o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c0PXqfZ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789663320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=su8bgOkCvyNvIB967tFkj8yv2aWhlZWN8sUGO47iizY=;
	b=CGCkd+alguZnG3nMESBjbBCRC3seMC00km4g7DBfH0P4s0IRAmLOmLGWsMB9lmgzTLqIhT
	t7Ws45DEmDhMcdow2+3ut69X+pk0dEqwmpiwzSgRX3hbL7KUS6MRrz3dlJVih88UuRntVX
	95bCjNnC+WYOcJ+5oYumPNI5q8kFrAA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D78C140BE8;
	Thu, 17 Sep 2026 16:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF631F00893;
	Thu, 17 Sep 2026 16:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663319;
	bh=su8bgOkCvyNvIB967tFkj8yv2aWhlZWN8sUGO47iizY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=c0PXqfZ573Q0kxg5ZLeMWH+mhCj5uaDatF5aO16czzDv32TOa3laN/rXcLacJ3/Y+
	 Am6bVU5gTdNcrfxpPW8ooNKKaZXNBFGeyzXY6dEci0SfXdFTYNDdP0cbuYQYKTgQKJ
	 Xsublurv4BtuxUEfakKK4JsoOFYsgxd801n3DzeIet53xLfHRfLgLizEDGy+mZiERn
	 7gp4BpJHYYCMkaGLi8AEvCBDkN6vucsmOw5zeXtm6XD4muYOzjeBKUV5ItdXPNyHDB
	 A9w2rSTy2YcoFteX8lq7y8W3m043GBO0kojWLFQpr5jEe91i+CuSGvi2iruLqMDVwf
	 2TaD2IlZvub7A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:46 +0100
Subject: [PATCH v3 37/40] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-37-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2135; i=ljs@kernel.org;
 h=from:subject:message-id; bh=UUak+/IsP9T/XKu9SnwNXgsEKVs/RAhL9XJGmPxiiTs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB/5w6vN7R0o16GQuSMx6Ze6Czfn79WXCvw/7BPqq
 rwStNS0o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABNJ+8/wP0pMbZZlzam/rU++
 JLJyGhxZc7ZrLctLHq9pAR6Jkx8UcDP8T5/Z5fIw37viY87DNbH9TqqfTzKd3NImE39hq/7LtjU
 L2QE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9B5174000A
X-Stat-Signature: 787cha63sjx5x6r36nwahoehzij9w69b
X-HE-Tag: 1789663320-895007
X-HE-Meta: U2FsdGVkX1+7/4IvXJ7SvvtyufD0a4Rrmg06QWHKphLuNfQdxr1wQxFjtPIyA9w7VKNnmJkZaPccjOsZev6ViHEdvaelx5soxUzggY1wotFEom0fcEKyDRmHbrAxtAsTfZBTPCuQqYOzZYHMpEeq/1+pWMAyM9M+HJXdUIopH7wi9QTGNoRoZYWq7j4v2+bQx0OX5ey4jCxlGJvEMn2Hi7NtssPaTM8fa8gOax4BgV06JIUNDSB5Hc3Eb3rcYUtmycfoZ379Jl4z7orTpV634uT2xMtMjHvb75VEfbliGrKcsWD0ZS57iy937hLne7TI9UmV6FXZKmi3zFKl8h7lIOKzDnjq/cUVrwpbE9JEQG75d9mT3PdcD5cQyUav0YDtt7kN/TKtiHi2vc1SZMMsd9Fe9D+lZVX5HnrslErWiHqva0NiBMCfNt0wEmuhm9qV5sc1HmdRpp6aLWK1FIl+J0BHmdb20b+Q1BWxs60ZZBImSlDkiiBDec0CNYV8xN0QJdtHvS51fKVhMJtocR79HjV1zpUuquokF2stw+nQQq+499qpTDYVZjmA/Yod9byYPK1wKY7sLc3vETpVGkcG74sv9Um9e0In4J3uIFDFt2K6nZGiTA8ZMEKKbmOqg3OBbZ93ASDc52oZ9hny5leXIpE322XtlwZqrf8YWumc+anReEdG9CNf7QsAkn0QtYP8vuRuh+g7/BOYaNrEpaXMwOlsLGYRiov1+q9Azf+uJMQi11Ho/K5JO/cROyEui5UwLC5HF7dAU2ikpR7IGSGP1K4a7h5NVWR8ySsK3PFU+IiP5gFS2qD8NFXB7lrwL3rHElMOcOsGv1uc0S5MZ0sT5YTe+9XFB+1YW83y+X1pVSrwrtOV/4EvdbGqM1dJgx+qc8GQRJ2tpHDgYauqXz8hen2d0EIaB6lhQ5fWtWfLTFHqJbCxBwj58rEZiny/6AjzTcQsrKKlB/hfW4ijuU+
 wGqfWYJR
 Fc0kKHecqpUw0D994wQA7sfXapKsZuEH32GZyszuapKlNbX67xjOBjYCbqsndneTPe/Q4rVEkmQCdrSG/yxGPV2OmU4Ppdr0IaLF2Oa5gMeJFYjI1cgOH1wHsSdlBOV35YUeERwAh52IqPzK047wjX4huQ/jAVOn9QOha0gH/MMcVq8VCoqBogyuwmrgOYSIkHrHQU+MloDqAUfatjizPKhwRLBY8N0+yzlNhGsuuDI2rkg5GEJezDYSHyg2a7Ht+ToPQtrUJ2z+rWquTLOALYg9cyTdVmV+J1KGMWMwAnDCd1nyR37okOhZ3QcgAJRE7HKQf72RKYpwgd7ckUyZnLNLC88Dc2a9h3IZ1gVmObxOYuKOoNVpzJv861ZgfQX8OyfXU5qpnzRwUX6llcI87R931k9OEe2pR3WqmdF/ZCjSmnLfWpjIeSKIystFQa9SNPvUkkJIPWigCQGaMrlPokEVqD4/Zrx7D3B5xwdcilkTHDUAL/2mVoTZCRaW7dO5aaKg5xBv82RyhWp3YijwCbmzqKG1X1iOEAS3kk/SPV9E10QwdGy3drjMN7Q1kM6LFlo3tg5jQDanOm+f6+RgnvneZqZ+drRY+sOgtZl39n0/QtfRN+Lj78yqku5KfvHYHiA/T4Vp9vvidtzrXxJsy2CrTjiNMgr3gt2e6PZNuqBv7kDoVU+iMUPNHXpWsoQfV00UadHeJN9DpyruYtvytUy411LY9ZInEjFPQ5G8mSZSPvgfXecalGL2nEozuYP8pdCaOMhXqhxKtNiSo9tjw35N29o7akVe4CVA260IFfA4jwqVx/T3U/hFatgAuuJBHWjBG0B7UtrTTrTCHX4+PaY1EvL4uEqwYwNj2hBacRhJ9qs9ujsDsMr+4W5Km7YY05+b+b4JQnarcTouG/FWnc9QU9DyyehkndbWN8jl9oVwGPevyzoqnLBbMM3rxEeclzXmEVOir6I/m+HTYlz3NVmG3FK4N
 aOzbJDzk
 b94xK31jppKeBqp9PSC7Qa25oN0l95QbUUnM2pX+IuVazEJJrT6U3btgGQnfSUCY1xedmNoL4Lxr5Batk7qfRiEeq8le3x3P+Lief4LeaUC1uKa1Zoe9gAsYYtfnLqHWcNEV5bBKoT3fr8hfRmb2Lko/noYrjcOyZbSid+RoU0j63hc45b81x9W1Dh1hyQkjlhJK27YPcStR4S95IYik6rGDsWCu8gMM/edLczIBtMKe6t9/RRJ9zmx5w0Jz5pxv7eCf7FXi2EnONuGcKonz0Ig8A0JH6G818yQC32TBpXEQCXU/jaxZrW0kzuUHiqv/ItiaEwxO6dPvYtJQ7bvIhq/Kj4yxau9ZYdiITs6IxNSUeSF04NalSXWHlOXAiomNPKXIDnoDeI9VygTI4EdKLPIoCeiRoIGb1dUXaPdt6SzEHVDD4dn6jb0fMrnUGZUDx/O9+j9nXph2XCHxfT866rED8C4ZGG0tzTBiIeERJ+ENAbyObW6UYgrp7MyYySfNqqD1mRzf3Vu7sezuVFKsy3ZWC5JmwI43mC0zE52Xn4dGNAfXVLyqK9YZlvxJM+M1WDhjs7rSiCtzQwluLM2rSDAgX5JzfLJi/Bx0wccL1aCEh6vZdv6wLAcm82W5XVu9YnwZ/IAx+ydRmhZkM16bJL5uNQKH7fUyZexv46HfElVEzjvZ3jTNrSQ1QDVLM+xwhg13bw8+9pUdEdTFVtlT/X8I6F6HunQyvFKKOmNDOLFbes3yVjTKvEB+XGaU3L5e/+FQ1iHSiNhSsyGT16IXhHitWiPhtV/9zVmSn7OQuJIxrdmKWD3QIwE246nqz+3q7y6fQAODaNK6pH/N2BDBIPn9/kkA7c8OOYTDfcTYF7LxsY9Mlks+RBl691MWoiJ8sxBZUA+gdH+4eaj8v6WmUjZUWG0qfOFwjsfwz5RFpC3xyOUDxdQjlsvKU6M1OczBuRsf37r00NqUlIHoPma0cWPmb03mf
 81AV+HfU
 /M3p8WU5rLb6RxYTie3JIgQLYaHb4BYwSBGSaoARRa8esWykkNckqYFGr4vhRy67AZD6UFGHI1zZdJ6a6lFtXiouh+jjwpt/Xa4aKUscwWN8KCRGjHUzjKQ+MyTyYaRNoq2Q5qG7HBzA5NQu9oKUIaRc8URyJtILLPkn56L37wzfiSJzxOg+OyXV9MO560gBJULp3IcRNJyQ68RFfJ+0LArgcZwMLkLbPBuQr/e8Cmmong/ZSIssucOt1bEbur8GHxqhP7/Z0A5LETkQNFidYeGh2laijw1HFiKYdeDqqJo6EbJ9UCI2ZKdP6K+qr71E0a2xvHBKeZ/BlhDHCe7q48L5JgyXNDNU0rvb7pZ4MLvpuzZAgO20+xiLotLbmkwrBo/xX+6ueZWnhBAcZwn5wuCuxzG8BBof6vLF+JjQ2pU7b5w86enAl0aO6WwEd5Jqvy6+0TLy9mToQBUkCTk/4iCghQXHq+N4NhA112BKVrofmE/hwAjWP4JXM2y0a7ekK4KQ3L6kjJ2D7gqMQP9K9v7hzVm0eIUUI4Iiyq3nrvJGfR4NR7iI7R9jnf/HxvWP18Q9hCq/dN3LzGRt8q8w0dUoDFyRkCKK9cV+fcHFHgL/Kq5zeHIKPHSx5NMqN8aFUnk5khX+1hHVMYZv433BFCGvfp9nMAJxCqhxaM6FqKCdVko4bSBYcC6nUgySX+FEsz9ppoZUAGG60YZ0f9pa2Sdga8ryAIj+ehDkHfO3oFKv+ue3CQZCUXL6Bx/4103xIaabcWgm+dUkKXgWficFYvTrznZ9j/+q3ObMgq9OdGLnRdGQpYVcAX5OfZZGGrBQwSFqoSC5lNL+78FYhLX+AfGQTUN0o5HgJ3ppiivTkDti3UTKU5i1vcL1bexSgAn3IMIMF1gIjLpeObRR5aRAli5mSFFifUV2JKFTmGNMruZ/dTXkciQb+WPJwUL5H1laPdKUTuPqd1k9O+rg0o8unG+5/wdYx
 o1nXqVxc
 m+I8K7eJ/jeW4/FIxYklNvy2ZlANrvwt0tt8WkNJ2WRCnVMLoQA2vtapEhnlmh0qQURlYr6CikFaEBQegqzATDjg54VebruR5FxQmjb19tyGEVk2ip/Mc1Z5gtCF2pXlP9kcxOA6tUyNjjqAkVv23E6vx2tABRHlHlZZ11N853ZqiVvPHt5RRfM4f2Lrn3fVR5HV6mQerKSKtQj8hMOeYBicYcjbbHNNTPk6PVgHUsQk2UohoQhmMU/lSCHqkhA5+W6n6rA4xW4N99gpTe/NGbnkbFiVmo/HrxEiflJ80U5CDT5RTneH2OB+HzBZZr1IAwPjDU64Jwo886qvdauiO9sGZJo65fa6mGK4zvnxts/fhL2P3K9VGgyipsFSQoZK66CVA9W9ZSpz/eLzCigSuw+uI8Z/rHL4QRlxzrq4BpaMbMrIA6T6Krcq01wAEpeojiib5xtS5IUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted to
predicates which explicitly express what is actually being checked for
rather than the nebulous concept of possessing 'special' VMA flags.

In any case 'special' is not so special a term of art in mm - it includes
VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
other cases too.

Therefore make things less special by eliminating these now unused flags.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 8 --------
 tools/testing/vma/include/dup.h | 8 --------
 2 files changed, 16 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0579e6afb19f..5860a3b4dba9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -576,14 +576,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-#define VM_SPECIAL vma_flags_to_legacy(VMA_SPECIAL_FLAGS)
-
 /*
  * Physically remapped pages are special. Tell the
  * rest of the world about it:
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 97d3bf6cd5b7..c21f67decab5 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -352,14 +352,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 

-- 
2.55.0


