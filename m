Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89656CA5FF0
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93BCE6B00AD; Sat,  3 Oct 2026 12:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB886B00AE; Sat,  3 Oct 2026 12:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 790F56B00AF; Sat,  3 Oct 2026 12:37:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF346B00AD
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:37:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1C70160954
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:37:45 +0000 (UTC)
X-FDA: 85281871290.07.9CF8CE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D63A580005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:37:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxtxLILh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBCUNumavtqCDVMDKQI7JmbidEurxJXLhbUCZn7VyHI=;
	b=SThDhy2gafVBiR8E3c4S84YTtl55x1smAeFSNHFWwHLwkK6gkNMgD0y6eD2PHix6nJ9Yc+
	Fjj7ud95SSmdquaLHjWm4W8JOlLWpgUgshywEuQF8meiR1aFwR3loOYHziDnecwYMc/aSN
	veCADRqXt1Epuyv+lB0CApzNNxspAtM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxtxLILh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045464;
	b=0dRF0s1s/qn/XGbIQEyuSKOHlsBdF4gkfeHlZ4kioHbOlV4SSDnLx4KmVixSL/8ty+VGXq
	+ZQAqgdBqqhRIXE45EuMyD+VLa5FI1sIO2Dyrpk3lQ3MEVJYHlXrbmnJtUDd3jeu9/cX63
	cQ2VvsnS8bNpQWaTn1NPJc1t5NF37JU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CAB943ADE;
	Sat,  3 Oct 2026 16:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0111F0089D;
	Sat,  3 Oct 2026 16:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045463;
	bh=pBCUNumavtqCDVMDKQI7JmbidEurxJXLhbUCZn7VyHI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KxtxLILhV/BXVO/E4G1U/KkjUp3D6RCxdjVhS+7A0flJgGGXb9fWGk553mMK/UTzb
	 1gDjs3C85k1WMglX/qI36NtzltXNjWUTg4fLPavUnG6zTOFOPwKr1WX4C0U0vPxF0l
	 ElvorMBTiY/lkUjR8lNKgv3fJQt6P4QOrIAQhMHMb/iUK4RHMeakTYQE8VpkORJBkf
	 giovwZ9RbZ7qzMiEr4BKCPehFPi8/l/Qte/KVsN0ynapJTHTcel7Uzu5UKsQDcC18F
	 4NQ/A70rYtY/GDcWG73WZyOqdRk1QPuJ7T0NOPPTWQXvI+ISG80fV0Fh9g+CSaMrS1
	 B+ytDoHw70cPA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:44 +0100
Subject: [PATCH v4 13/38] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-13-a1f052500fd7@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2126; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ODXQMwEU9PihiteDGZJqvreyAaBC04iCZqq/OAqYwcw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mk09Z0tdJ14bS/37R2L+PkDQ6osrvgEZ8SpfTmuy
 ih1wGpBRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZilMjI0Ch560K/Ge9xu023
 1zJou5hebzjhPqf3bBfP5rmJYedY9Bn+SrFc0bwtd+Ofes9/taLP15rmaWcWO00wz2XdeitnvcF
 UVgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: jpxasn3zqtin1pssnhhk3xi3jny5rr5g
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D63A580005
X-HE-Tag: 1791045463-707362
X-HE-Meta: U2FsdGVkX19/+VzYCcvPJVaxHyNRvIuD5JV+fTQz+Tbdz+GqfqmFG/UL2arU7OsOcKBPBOxy4WpXff6dG0VTVnhsfg9aI0IfgFuC0GC8rdVbm276gELWfhgK0R1GarTsUkZ0C+QVCkhHxeROV0L5eD65kV8eLn9IOenDOrI6k74NH4y2L4/5OAj4sflQcOEub/aajDXt5FBi3U6zX9LdWcBBHceZelZj66ncE1shQAjLvjbSrCh4NLln/5gQg7Tk/nGe3zcvai03Qhr2n0UCLOY91PPpGmg9KClMap7HP1VqRwyeaQlJd1IOkLTcHrH1QVN6g9nt9emJn3QavKjVZVvoj/WUOYeX3r6MjpHXJ9oM4VwWdFiRUlaEmmKLZbp9pXW5fSWT7U33t9iHXS+ArMt0puOOareY3+ta7saJYBziVHcorzjenoAv1k57TkH6Boel3UCCf59IWouiAIFgpnP8auzWm5g7IkmV2vBAQxhQnl4FDA3+LxOyCcWU9wMWlFCdexooXYs+8fi1a7Faw0Sxt6wXkeJq3Hoo/RlTpY4U9rO8/zD+9TPzYth0Fj9g/7NnbhUziYe4d0mu0KZjKggz8gPB1U5hZCH9LSshuXLDZv5nCPMhNlsRPy6NmWebanrSxQaYDudA88BKWs5DidO1S2SHv5Beap8COxYFd/jraKLulYqcPi2O29VqUT4y3EbKvXcfQUDmMQKBygHudKIIkjNZ3IpTlzpUEjjvXc7weOPhEfxYWHhohy6inMip5N1xvKeQK4Mz1xqm1IbScI0D5cwrUE70HYQDGzVcqtW6Za+Gt7G7pS+gRorx73uD7LBZltPNK+KAEVbhB7FEyXgVMFvZC4/o7njJ0ZqFsM+8IBebZJqJSqakUyPI5pk0lgmJxYYjA1j78MFRpaaaVcf8+pNesYTat+oG4VsIEbb6o0s5gE2eJejDhvQBudrk9HoYipbtjdwr0a+o+Dk
 N9bg0dsb
 VGJej4RusmU3kgyBjB2EhGmIcGZKJAvrkEGbuJuBP9LuGwIlRKAA/mbGQer7SoixdmfIHBIELB4cycPbnkhUG0jq7ZGfH2265KgvbzNppKT86bDOdbpwZLq+ElwkG4YdvvTLKmkxkULeJNLomPbpeqHllxn5EqmESkRIMZWtZvxbSVLiClTa7iQtR1pMSeF2+r9MF//6sisNIXLAp9xEnrIjviXJL8jcVP1EZx2hncMEWk2ZiE9EEcFKEGN9RuQQIlVNuUsoJ7vqCOuPyhiugEQAVrsGf5Nah42cngFRuhJFm5qwtx41hJV8vf1ifPucQC06qewoXJunYqy+jewr4M4eDRFVBpNLH6XpgUzOxQ1ibuQdN8bPlyzo+0FONKHRTaemTJKocHQguO752xm7TsqJCawwb9Go0kid9nZa5NM3scaltssAp8tTt+ZTR6FRz50+XJUEW2liVKKIE6Wr9RDV6YHbMPukYCiU4QafK8Q+gF/PaNHeMINud5uQdB6+xrSd/3p34lsVGTskRAjWofKk5oLbg8pcKSELsvZul5dA6aMpG0u3krLtpMczDpOIGfKet09K/39xV1CCe4keMczMxmGeLBwFBVxiNfgbcpjg+slk5IWAlGRDyX9spT6ACOkDiX6Fv38PAV5ocL8mf3PWmAcDYqcnZpLVrk51pKIgCsutbZPOb3aVM6dU+KWfaEt1Cvb0ZilwGZYIVNC+d2/JBxRzZiFi9LAZiuitSb/hDpUeqSC/dt7P/J/j95xPpsEAsTgXfmqVqimIFgCLTAVQMKKEuVgFQuZ1Uhog7qlvrY06bYfA4IVj6U4YF6CC936pisFqchhLIzO5dCVscXSXU3b7YB+KHdCbc0VaIBQNtFsr7KsH2Bbw/CST6dS1Ed+zNzTs5Qreu52CNsarpTX26Kbov0M6sDY6eibvZwJ6jA2xFZJ7uGx8QC0x4QAFI/x+CSVakYPXFx8ynvn4jSZOZAAZQ
 0ZMQXp38
 QfxUVXWS7umyr5LkdRAZ9WhQtczsEsmkd4tHiuDZokMPxi+BiFZI2/3DT5v5X+j+LOJxLernN4LXeMjELdfKaVjUH2QXx2FPEDkMjLMLvTPaPcMYMvWeKg8jjOnT8B0aTZvb55COdfdQdIY9rR5b7fhRuxG0z4pwpGnKTS9edgzdaKu7nyJaW5T3sjAuoHS9NkWw7TxfN5WCNaJKPNNq0UyzxQ7VmofAS/S3/N0GykeBAxJJT7wxV2OYtxZeu3SMUDcA7B5SqJW23vjm/cW9X2n1hODUeKz3d2Yej/oCXCc/AKs/20VjT3sTvhtxXpvNqUSXyT4k5hnjoHyEyBqDMJ5d0JkLbw+K3bnGH7kIv+nJseTbsgiGv0ioMUsM/UNo3OINyKvObvPu0s7fGHwdDtBU8iLxkKm+u8vnzt61kmrN2WZBoDNQOrVhRZhqIXuBePoWAmdlFJFMIDmWtk895OKVgXEGuhMPTB4pzKa4C8DKfzFHkC2RhmdbQgXqAs1AI+CQKBMOfNE/t3B8vg+o2I1BNPxc3pMvLAi0mo17eQUqRXImuk0ghGG1fqgWppuAT0PMaRA8QVQZxRvY16mwAH3q1rJSy6tjTFKplpUDbX8djWKm0T+7b6XiW/T7G52GD5Y5qKwNtGCTyv/9IVIF0LExrmyZkqurrgK4TOx9VVYhYFCA1afkb9J7Mk294r1g6Gm0qomD2F7ajWBYc0VQLaHt7lK150R78ydosML496sPjRGRTojszXN+gTItOEAYZkL89n+HDVWIrxZ40rDNipsVElpJomrVIef/WnsCgVKmPpAsOKh74SqaUB5idqeKWHcScr507WgZJiIMIjrup5FJqGtvlW7/4M4UAQLcKoml2T+xNarfeWMSU3OmwP6MlWlwc2RMWGbO6vC5g5ql0pRSI/o1wenvmIuCE/2+D/MenBzzPRxdRGoL0uXf0HC5FrRPsVpBVtc6iydJT+B9ko/9OT9Rw
 m1rWDB57
 j2DvQw2yF+5J5mmmJj5iWMvBPuzPv1d2gc6qgguHL5bzRs4xPE8YsWgdeKK5DntTeStgRtZt83OOPfg1al6MXsj6JB9Tyh0otkgWAuO7s+X0u4klnW7OAFgezcB22Lsph+GhVlnz37imFgECfMbELhzTqaMXp8NTXMfuq++gXDTvXO4Y5rpNpViS0xEmZIia0SnfsC/GHSyY/9rV7uC+gF83KxSwQaMXHMthIEjF/ovDK1aQ1YLSG3aQFSxYOKk84LOPcrPNBJ1HSxeYyLT3Sk2PXT1QfXllIoOjNfk58BsyyKJ5+T93x6vahNzfnMh6uY6oeQpeCaPf2CpeiAActFEjEpXGhSvpuErUODQeHX9+A83+Ih3orAo/h3onsLubS+P9aQQGBjVYdjAPeuRQY4JGcW8SXrBipUmCAiGWRmzvJYFrUCGn9A5Gf/9RsNUuMmLmjDyyLAtNSrys+rnEg4TToJrbMx9tlKSAGA6Uaud3Gd3pilC/qa6W7VESZXtmm6ADg+n1ck92w5lLL8K/VklN8wTUwwdlLkv0KE83qjBKIC0A8brdSfIsCANTyaK0jyyBLwpu+4nVuDd/VJxdtWLUN7949NYYGwhugKUJFSiSPzvaFATgvb0ejQ0G7RFuhg15kx/L/uQgytMPMxL6CG29nB8GzdCZOlss6sCNDhr2rYMNZqKzyl+yNE9dAywMRH4A0TTTpt7atVurUds0f3/Llr38TMEkz52tfb/9medKuxK3r3YUKnTTGORz/gQYojul3rgkIManqAq6+pqS3Zw9quVoqQ7ti8Vwz6SnLPbqy4AgD7Xlhzb5laKSINppdElgMDXafW5vb1gfuTeyzY1Cs/2h3WFqaDDquQsEYUR2B6UrNfO+8pJa4YI5qgpAALHh9RjvNlbfKSkU79OM6FCZd5v0M2T3sb1ounAzQz8ToIs4hFv0Gh8vY+ch1q3dJh2Ts1M6/eV8EzsiC0uXA0ClknGZh
 /koFP+0P
 REBGvS49pb+pGhjIlLTB9M6JvWsVlygeFwhE+xGeB0jgx6toblmRtgv7zl1bNlaYf4R8bzdFQaTZKKQzKFK2i2WW6d1q4VgWbDdWr9OddGTGFzJWP8657DvwCNel+BQ7jTiFt/BD0TpiGjcBayGA5pSA06UHULDYZZjtYgBrJ+bPn9KdDnWodJe4chhfBE2MZcEAIgQMoJ3JZidCxAqZmMhc7I9ECHVvcC06RONh2pOFnHOzZdXB1jF6jyWZetOsRrz23w1vd1C6Qi1SxZdZ98AKApnglMWlr5WNVC529skpCGhhPmLHqr1wNHPSw1cBHSTgXtK1As8J8jR+rNZ+SMZi0SEXpfLLX8vRsWGZXB/5Yx/q6FzauoKWiLamOCEyHTO/SbjYlCW/FmDdZbvb1I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set to
one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
or arena_map_mmap().

It is convention in mm to mark mappings whose pages the kernel manages
itself with VM_MIXEDMAP, so core mm knows not to treat them as ordinary
page cache or anonymous memory.

The map_mmap callbacks ringbuf_map_mmap_kern() and ringbuf_map_mmap_user()
use remap_vmalloc_range(), which ultimately invokes vm_insert_page() and so
marks the ranges VM_MIXEDMAP, and array_map_mmap() sets VM_MIXEDMAP
explicitly.

However, the exception to this is arena_map_mmap(), which doesn't set the
flag.

This patch corrects this and updates the comment to reflect it.

The pages are refcounted and vm_normal_page() finds them regardless of the
flag, and VM_DONTEXPAND remains set (marking the memory as VM_SPECIAL and
thus unmergeable). The one effect is that NUMA balancing now skips these
VMAs, as it already does for the other bpf map mappings, which is the
reason array_map_mmap() gives for setting the flag.

The intent of this patch is to be able to establish the invariant that only
PFN-mapped or mixed map ranges may clear the VM_MAYWRITE flag, as is done
in bpf_map_mmap().

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 kernel/bpf/arena.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 7b6847200b43..b69fe5e34339 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
 	 * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
 	 * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
 	 * being copied into the child process on fork.
+	 * This is a kernel page so set VM_MIXEDMAP.
 	 */
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
+	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
 	vma->vm_ops = &arena_vm_ops;
 	return 0;
 }

-- 
2.55.0


