Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 273D6CA5FEF
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EEB76B00C4; Sat,  3 Oct 2026 12:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C73E6B00C5; Sat,  3 Oct 2026 12:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5246B00C6; Sat,  3 Oct 2026 12:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 069B36B00C4
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:43:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E377140963
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:43:04 +0000 (UTC)
X-FDA: 85281884688.10.1E910ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D7978160007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:43:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2b7PkUT;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5upPOtDABwwVpDceVPyuSA83QzDcrZ56JA1+Hc43xbI=;
	b=8kJQ1mIlvnoctIDWPEJNwqzUrw8Jyh5tu3TNoWbOoLIpZRrZBebs0BfF+kdDwXNV8uHmK/
	rBG3Ed4NPLk0Bdjl4SQSUy1vXGTpcWAAK9sPmjct/VPAmVcjXRj6HeYkZROM5/ogtpD/WN
	3XgjPZCO3dNCjeUD9tGQH4gZNvcAdrk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2b7PkUT;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045782;
	b=yYONNduOzWHzB9ZkpPg4r83SBCoe5dEtPpRL1UDR9ac+7mRQAUdMYpRzeXzPb1doTghyZR
	ptw5Qvn87XKeauSKIqPxuFxVubjuXiCFuEriH0hWUv2prG/GFg65kQyFHfoMe4SdAxi9YY
	BsjNUkUHg0BwKafkuZLw8P6X5AeMrX8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EBBC60DA1;
	Sat,  3 Oct 2026 16:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3F01F0089C;
	Sat,  3 Oct 2026 16:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045782;
	bh=5upPOtDABwwVpDceVPyuSA83QzDcrZ56JA1+Hc43xbI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=P2b7PkUTyOjmh1xHk8NiOWQAY8x2LXNUSG564AE4Mhpy8zfUBUBuBe++LfZnRWybq
	 UioT2K923OqIjsu6B9BUP5Qb1NTSuvRKUpEPyghAsmv+NNoL6dmHn6QaL0xghMsCE9
	 SySGozsTqjvQNZNcbtXxUYZRcVHqbGoDfEQ7C7q+ODkT5Zm4WOEtyoP1zlcmJpGI7S
	 MY3d5ZsoE9MbYJoKwRL0DU2ZLiJvE+8eKrdYWrRkpg63IDltRjRn0no7EM92KktkaE
	 EJWE/eJIqvg1Ok+bgW0G6C1bPeVg3O3P2k/vHAQz2La+WgaNOJ3XBy944TIbmElAzR
	 rP5CqB1VuLxLw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:59 +0100
Subject: [PATCH v4 28/38] mm: drop some redundant checks around hugetlb
 VMAs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-28-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2822; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ULLCLMudbM+nA5DIlUO12EUl7FbXJrpgl/45EV2ltd8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mkfulL/PLlQ2ShlrWzkYaPlF0OCijyPmtrKfD10p
 CDnbpV0RykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZSmcfwV+qX9slK3ZziI+8c
 Vuyz1D3zZ1NpzScTgU0PVmofsvjYp8Tw33tSvqO0u+7qI4ySvwPD9m/WX8JzcOpjhdlSTIt3BYk
 e4gAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D7978160007
X-Rspam-User: 
X-Stat-Signature: xt9yk8sas3chf4m6qxciwo3mtbgzds6q
X-HE-Tag: 1791045782-12995
X-HE-Meta: U2FsdGVkX19Dy20NfWUjQ3nkMhiNVABpV08IKfNuOdjsIN8iMzKptHPahZbD5iqqOorBQUH6psWe1BOLrtmDxCmzheU0vCzobTFy+q64gv9OZWcBPPwYEtICkpXSEJDZa5MRHLDRGunwxaV8Xr0iEcMlbtAkDfgAaYCZnkeBloQCZ1kzTLvxxbE2bZKDc2TSUQ0c8LirUigLWjyjq9xdiQ6j1bR9zAz93BOVQUCS5MLUJlKg6pKK71ZxOZmxVXsM9Pqa6ODGjdlAD2Z9JGzio9Iokvecf1g33CZSXie2n2kZeC4qWJXBtKQdohvAOnEGu9VOq80FiJo4EuSW/LPkiCFaNsaT/fcVykG3S+mBWzHkBmjuOiG/sBNCYnwEt0UmRWRLHI1k55diQAvKeBvUHLWLrYUta0bgudCJCivzHc9BYPa1gEv4C1SR3+vwyLFBIpYE0Y8SHpkdBG/DnKtE+E822RBoa5PrDaWbk1B4sXrfdXJYtZwPqcvbFD4z2e1gCTOwkrAs/3mCpbWMIL8UGCUhSwQ3UEWlN9C5oIsURMD5tRgWqFO8vziCb9i1I2Ue+0spVqh1W7ug1gCatDlAIXSAfSw94KlDfG6ScrWXl9WOJ+Bh46tMaceU7wBC8BgKLw5m+SytpUq9tfRuFIeivbqZcci12PzZNMMian8hUR9ouppfE90NrdJDbNornQ0K/NEp+9Uta0D3m7b/O86cLd85AyuIuW/dJQUY5lDLMQ3X1Y/U/9GdzXBpCVyb66reBTCONu5FwzUN7sxf5rXUGQmPy1XK3jGJ+sefT3uqQGHgNH+b8U6KyfexSd6MihvtgXe7GQgi1sWiMXPZqXMlC4zWPFaR9irhQOCw9xpYkw7TN9j/aBHV9BbOrGgyTuTrA3Yrnt0AaBowA4EnPlfa8TzxwqXatRrOCOd5ER2GDX8kyzB2HewF2XaHjugMm/YeuPgFEUU7VPXQOUx/V0v
 71QT+Dkr
 slzQzccbd1+NzHDb7pD8yYhv2jmTGydSLbq8fuNr7skE8GIbwsZIDFz9FtZh3ACENweknD5zybhhtBASgkSRJnVKkco2jmMyXHeBRmKjm/mftzTyind62J9hioqzNLo0CVb2fQ1Ale4rG4m6Jn3TwyueGsewvpKTf85Hsw1N7H0f/oaRu4c7P/xXSfmafLSqertM5XYcUrZADxtg3vUwq0L//uCTb8QafcOTdiQoB8QZiW4Qb0t6aYPlJJxNl3f/55JQzBb2dAlZwPz/AJL8RpTUHJc7+nNSFdlPcHXyHFt+AuBT1zDDhCAI9J/mkFRG1E3jcMEr9Kx2sw6/hpIF0UfISw2k64GJVVDJVFzXVSA7SdShSp0S3On0OTTFsZTx0/uv0wvFeJgL4W/qdT7QuEh+6OTORFiDTpITDfD5y3SQsx33r7iS96eOQFHqhI0OSgm1WrCr4KpN9kms6H3KekvnHWacE+YRmmA8zbkANTO64P4VBl5aN7ZeG5bA3uAUpjgtYQAza/e0JKA6HXZxCdg0O+j/8Yt7PGZOMcYmt9CBLinrW9Kk9cH60sj23dthxFeHCmJpYaIlZWBTfxUoNmrrcmGYkHQgt+LllHSCQw13VXLyKwBF9y2cZz4fb5TbtjcidEKGImwvU73lRHku4XVZSe9pq5CHvMN2MLPSqb3ozrweTweOwVs50B7SPU5Ls6HG+7letK8yfNGYqeAuXnnNHv6+LMFQ4Rn8zttDLpUC1kbvQiqq8VHqMpClRerAZjNDwAN0mEOWphDelxDyCzttBUHliInh+etxRwU6BHXPTxscIIUbGvkdvDilTherIC5/nMRNBTuao3DIhiXaXkxlysVjKBOOlGgWXd62rtgIlRT+sygp1hVgT+wWwMHnqOXAvpgWJZu04mn9taMJOkVPEL+qV+iZ7JeaDBPq7dbmN8KuKiTJJc15t4FfnEWW6GbLZtHGTalGEQKlazdRLFcCbR2lw
 h1iTc7ZT
 4wUUKPyVMHP7HPbsN2Hp6KtTM+PCz5cny+bufdckKGUGwqwu/2YzixaF4G1Xkr/PjlCnJE3lBBCcTOXJiPZvMMqxsjPODcpnn5c4MvFVHRZOvM9Ltg3eR3TO1Ub9pnAqotDzwLmh0qiievDRPti5oPQVe1NP0n0Lbi7LIXk+PThTe3FtTvxJix26XwWqtNf79WWDAJ9jxqjZG7cfUyr7/ZVcfxYcnY8b0bYFD/JIXV/G0J3IOpiXTPF5PZk+oeZGjbDT5MvGJ/DsTJVmLO32/uAAo7rAiaWdQLpLZkzSTMl8oH4oa4T86ww9jt05a6eht4OoL2EIF1vZEe458DGOqmzz1Vg3cVzRRPVFvP2SWAsXqKKy02wyQ4A2qZiTadKI9zJFHcFozzdAdR5KGxbH7LKs704tseVE9kF4g1XFZITv6mQQ6BBGtUPqwYReSOH3rDGHdujZVZn6YcTYCmY/A7efnA46ilQcmvITlxJrZQ0J6HVCa/D2br+UlfxpBbFKz0UBK58FA0nlf6ppTKWP1EYlUJ1FZ77RzyeBDObmv+/OMuLmFPP7MT6MU9w84skN2XNvJmk9Sc89rX2oVsAnZMDw7ek7omf0UtcAnjI3WYKP45MsF9DwzKCHhDoYzqM5I2FS3Gk9tyZXo5YpMKjhnNpKjOW1yyvC9PTq3I5jK0T2fI1YcdFOPNf066HawTvuUyYSvtlE/La+cOnPIRD2J+cf+U66Vduo9EOoODBDuGmoC4u5Plhqz1wYKGbpoETSlXql0LsEeKLqZjgmWu/eFnNkc1TPykB1ELy4SylbWndNvVMYXmnneSfGfhXYJ91HtNrH0mC2zGIps7hbzoG72wSOkXhY0SCEfcsdE9tj1Awiq+XLwwqVFGFOFghDI8G0Lw8xB1hhEsV0bt1uygZHJEj3X8aqLOD6RmbvtIuzzjTTRfHr2mCMgAIM5+WRReyGICKskBH1ST+zxq0G77mRSz3GI0Z/i
 8myvcH4e
 ++Fve6/G8rxHuv3PrmLJeGuhWUhbhqm6b02Vto888w2vxCAkDsz9SlQF+hZbo8jCHofvjfkNbIF5rcZoKnsZTiULCApe+mg/L0hdCJnk3lhBcaKhh2hcBTZebKYVWcUg3GtG04UMc02MbL1inVksFOI3jy/ukS0uVnbLGwgRPMiz0WqzA18E+IoxfNEX/vjmBRUfyFvqLqHawqy1M6xhUhodK/xIpPhoEreevjpBaUK0Bm+6062y71CsD8Kry3WQDn4xU7VDsURS7YFzukBkmt7kEGv/93YDrenSnsmcAAU7z1yuHkmOslNEWyQsqqwa5jaE/Q19E1YPbr3IgPA6+0BrdPdKNto2JYr2rXwLCTfaINYOTBRSJ8iQ8SIs2SEz7t4N79PF+4G6pEJYCzObQjCqGWm7pHb66KLOAlUTaZpHoQwKRqoh4Y9HkN5+bLCUJJ968LM56Pnh1coiPkgPvqOXLadyGCkBZ54vD7fynhhhCiNexg1TJCa7G740gVZ7mcQ2I9HZ2p8GeazrJMXiX7PpjQUiLcp4k1YSigqpIOGuhmiBhMhee63ejKWGSo6cd4euSNhqPW1m8JcE/yd8Jav3IpHVzQ7oEyBx1Z2DubxA7hQNBXz2fdaSi9+rcYhzP6ZxxJEG2g3Ea3a+WcVtLKwTk4NvWizaLslkspHbwBvR/N1Ic6GJ7u0usQQMgWYfihTDjVZYP4OislHet+Ll2I3Lw2jKhPHDoW4L+PLfHtw95czGenxrJ916Q/oTCsV/fL0u49NK95z0Qd76Mp5mnBLVUjfUbDvno/Gu7o2nA+wvDJONa0tLxISA7bdij/YAD5FbT/rla0K+lBBEhBfPE/glMbEKOahzdgAsARSKjH404HRCpu7UWEVv2Z2X83XNbrX3VgqNtVIoUX7PdetVJ/6sd5WIs2xwiDXhnLjDPtYTg0MFF9z/5uG+wicRg3qOJElotRB8jpje0bb9Za2i4Qv8aB/Sf
 CKQJB61i
 TIGec0BMSSdRiBYtjU3InNCFHdtHlNRqSiysWFU4AOeh7b027Jugj1u7MgPT4+b2b6PuCVbBk8rKrMIuETvwV0szNQXJ1C3OdmwMowi4Rj4VNMKCmUJSvcLIZ2Or3Xx3JgL1DhOhubx1WuAEZLH43+IiKE7H75AyyOQDKyAUo3UYyo24Yt879N4DLOr/TzNKtvd0OBJMz7L1yu5wKHoC8UbiCLGhhDWj2XTRhG5u1Rs0BPtyxjnLeLsrZC6CIwC2ezghlbIzZsW5jSJIAvLQE6Zr/mFnQVv4iu22i3Q6ziJUFHCERrns7NSw3N8wov/M0=
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


