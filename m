Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E8CCCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 754D16B009B; Mon, 12 Oct 2026 14:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7067C6B009D; Mon, 12 Oct 2026 14:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F47A6B009E; Mon, 12 Oct 2026 14:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F84B6B009B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:16:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A226D1C4D3F
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:16:00 +0000 (UTC)
X-FDA: 85314778080.18.F860F38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id BB6D01A0003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:15:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGNHymLw;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791828958;
	b=xEPLD1naQmcdvr+RiAR0allbnKDYQqEDN0tm1hT208YiHlv/T+mvNgo4oEKbc7e0hbe9gb
	XuJG7QDU4s+lrJ/4IcTphOoZIKJQTkn7uXSLymuTuFIO1qf2c5MFD+oenX+P84SAsTftVd
	YGvyGgTN5uR+XbCr3bGsXTmmP9cox/Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGNHymLw;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791828958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYY0MSTSV/lzjFZVBtMBYKll1hhz2HZYmEB77bYYO8k=;
	b=WaqZ44PnBZDsX6nMtDL8pgP49HENU8GfEfuCssPuIeRe7qTRRfNmPPKKPPJgnwDicwBgpS
	aMRbs6Q5GP8kqLyfUVm0jA+iuYLc5QakvqGy3abBCJ08bSugUGJHcACR71qCmzD8t663w1
	97t3RU8g5pSif0zGoVV8tK6PVVitrMA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F38F760142;
	Mon, 12 Oct 2026 18:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CAA1F008A1;
	Mon, 12 Oct 2026 18:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791828957;
	bh=UYY0MSTSV/lzjFZVBtMBYKll1hhz2HZYmEB77bYYO8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NGNHymLwZKbCWsslcnEUwI//+cq6FM4jrs7Ia4F+jhzWDXKoZWIgGKDTaly/zYCVy
	 N+u1mw2NdZ92jr/bNvHzwEkIWzCVEzwNXu6gIE00aKEVtClmyPdMax8rEr8S6UODpC
	 MfmedbtTEJ2mNqfIHxKYTlHH73Y0G/oSXblggh9QGAyRRxb0CLwIMwpqJGM504CZ5X
	 XwlQ7niweJ7YuNmIIZV2JU+6rjKnr6s7+UcK552McrgXS+YYD9hU/Z7lWoVtfyFXTP
	 ASpYZzxjtE9xK7MNYdM2ZPWWDVodgdmtgIzCRz75qkJRgDq3yVLOYqSo2cDEsvTtrz
	 dXghVzOn8w/Qg==
Date: Mon, 12 Oct 2026 19:15:10 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Bert Karwatzki <spasswolf@web.de>
Subject: Re: [PATCH v5 14/38] mm/vma: add vma[_flags]_is_mm_managed()
 predicates
Message-ID: <as0jWKT3NgK7NP7i@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-14-923b70125b1e@kernel.org>
 <7554094f-d853-482f-ba82-3e2f7b1cf4a0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7554094f-d853-482f-ba82-3e2f7b1cf4a0@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB6D01A0003
X-Rspam-User: 
X-Stat-Signature: bcgnoqsei7npdn7ici3whz5gbfekg8ce
X-HE-Tag: 1791828958-967217
X-HE-Meta: U2FsdGVkX19agvzx46/PzVe9BqH2qSX14InlX9pWNf+nm5syvEWzn6Z4CADfSph4GuI7NBMJkr14uDZ8TRg2qgWV0R1FI8Intmgcu1zmKOMiDXVUjLMy5I5M61Ign662qdCfcka0tirHyrF3Spwm3bzyOvLuSrsJStqSdQri3O1U5rwGLI9gSb/dJ5Ba9YLa33IBt53YaQYJw6mPHJzNUmm/4mhK8ckbBpxVqyfLvj7Bw3HaRCSN6gv+7Os8HlLfEMUT9oX6YBFD4NYEAvaABkyM5TMFBrttlLDjlVfpOjd4+zCefVTALShhanb2XH2ouV26HRHIUMKv6/ARkAzgOw0+MInEmRak0PGoeoVQ2Cmz3Sb0NNR4+kv4D3FFVJiz/srsapU8fhyVfLi/+CjOe5pGX4dlZJNhVYxRR/ibImVRAaCOcHAodN5azdWriDl9/+28OExO8o/FfRxcZvyn0JJWN7zfZKmkxwWJfY/nLWbK/b1UhCDIvM25CSCBol+6gpS30v9W04ZnXmPrLZZW7bjuBW+up8+8q3OfNBfkUP3XPtf3Z7INUZ4hY8vUzfLmUTJX+M5muyJgYGXt8VUPs9kvDIm93YrmmI2h8rYf1TZAAQ8w1kFsMdLIjoz06yDZVt/3EWRSrR5r80AMJfBKFIO4MGK7LHGLDYkSp9RJYVY5lR+o2G7XvIs9yLUWPdEp+eXxTZeDVR3sq3rQYqrsaHBlakAAwi+//e6IOFWo1hRr4GgM6xpZvdPoB1r6gp+vzwmnhlr8lffiSDmALeeoIjil4+JGCiW5UhrPhkwxij7HICDSmurFGucH2VXt9sExZck1Tf4nqmT6uRw1Vv+v0QbHQH10IrVHytuu6YZApCWZWa36RJEE3MjpPvHuurRFTh0OsnYhNBMHodBeAizYMsvJChBz6yfPtOhbGCZgi0A+ru6SViLB3c5zZ8eDaQYfGYFKAgCww+65MIqFXCm
 J1ldYVYF
 O7nEjaJ58Vmqw9/Hvb7DMtFXfA0MOScOGAAzFr/kElwV9B0raiGAp3VOyj/1O0YFHiKmzxdLn7UhRg5ALpJ76znz0jPsADhqwfg38+UUmmnUnA3bLzkfp6MkkSYQ724uA48PLvHGc5sykaaujs//h3r3fooogdT7uMRAC9xmzJSnW8Subsnvt/3i4vxT7gav8Akk874BzS0lx1TgZBVOVpcGMB/AaBgiuONi7ZRBxQh6CBpOK+DWen0ysu2dsO5gOaHAEEZgEhNuXhfDZKBoywKqpbItNQoQuGfkPf8OU8hDLzWzGw8Ir/MmwMQ/3Kfv09gZC7ziFHE21LbGABrv4yHkQy+PyyUzpYg6VUM+GIslwRoJJhcDyjUc3Qvo7+CNvSINQWa8pcpOj7Jsg6M1KEa4H76osuhEhu81DQy8/RUTiCGTnI9vm0H0uE5EraBIgxYx1B9kgWEogr24Niny7WGwfBtTtFlXthDk90U44YLKfmuomKweJkDsop+bjTRom++aMeeocosJ18XWZgdNiAi5xWGjYVs65qW+bUf/R3ePLdNf65Zmr/k89OAPbfkzSZHg0E5E0IGQCkxwkHa5P2/DErhPsCK4CfY4+OVTDyIqC3jrYiTMvFLcoX2aUO4HbnvKBTOJmzxIdQmxsuOCJ0tzD7Ev/p/DQSopFGej5YI/4HyChez3W2EMKTIUu+y4GsdrxJzqzVwbD5WHokT6DHFfutZtQxmdRqO7bvatWtfDCgRm2MTSthnts6u3+sRxdek6nLhai5flFcsJb/BQKvw0AoQiE2DU7UQnOZrydaFtJgiHvC1MUV71viV3Ly+p1Vrg4Ydvzjt9IqgRIOyIyhXUNjP6vHl4TR8Q5th7iXFhTAlHGfSh5p1cvpZowr04fLjA5hPQOwb8FKv+J64tVwIsNFE+xHsdN+TosFD35hspJ3MVapMXPc8HYNmd4wTHH3Hic7p/JdaGU+3wLT77AxwWdW9wI
 Q7/PwkPQ
 Pc+V3FNBcYgiEUD5un8svhiIgvBcf8FZ06hF+76ct+fqclWBMQHp4k/fZeQU4HgfKCCoAjTu6sY7nGZw8s87s/d9ZMxHI/qrGr/WQGy4QqTbdOXh6F3PnH67zpRh5dYkAnqJ0d4Iyrn3P9fMbfCe02QzSVS6liU77+toXe9YGqGdfVRTNfhOYdnlTHyspVP0YEyq0+8WgIXisYncmnePpW8diYa2PdN4xqyXQFtlD6ptj4S1xWRlPvirwl8BtD9bOx0rfQtp+ndMGYFtUf5zTxNuoGvL2we4LuV9iaTLCb77KVWdZCuaDE5OM4liSkvH0sv1Oz5vHg5TqOyCcy2wz8BZuW4BZQyuhkrWYr8vB/OjlNIK1vN62UYLDq4uQxG8a8CqegRdMg/ysf/Sn2hsY9XL54p2LW97dWiA3VffRKzoJJBaqeEZ8LRwCY+2WrtfDcQ75MTiIErqZjGlaMThgnp23Qwaw7r+pmF2puZbXuCQxLnTlN/RGDvKuSfOKhcuAIHVPpnKFTf7ssRN4IPhJ0KmMS3pJ1Y0nfYWJXiJ0kckLTm5BpRI7rJV64djcgBQRb5WXH+T2gjyjC/BdfSXH2JpdHbkK8fqzAHNN5fQOd3irXzCL+3xvlvGTOYXPAPyWEMeBWxp5ozMhZB5vJmdkV4v5pmgJSBN3UYkmc5xuO5LkOaMDWsHeNFgyUhA6U8qhGx7GyMDCP2NNeuVUM17RNgIem2MzJBstRCkpKmzYUwm5Jqxqe9/JPF/5pXAc4Y6wQFEWW4wyhbYcE01J+2pWbOG2dTFwkAS0FAT6cKRhY1fpqnm/qcKZ3AAoDyKnki2H3V8nBX1kP5tzHdKeJJui/FZ5YwkE5wJ7AdlCVORZEIJ339MVjSMJpPMpGNTXBE/uhmOOn6JyLq7MmqlYP+zPsuszYvaMiwfPLKDG4irXKDCG+LRS6ZujNRngI9yXsh2gbbIwbqeM0xb870t04Qky/xptr3o+
 ScJurrIg
 gddp0PANI7sPOPuuHiXHIyzbhIBt5K9PIu4pZgJiBVGjqRIAV1V2+qE2axeIAXwvqiB3Ssf6A6DLeWXtH691fU4BFjKpP/CFVleJgrZZM8ubFNnFckg5DJL89QJrCyy/pJoufKXB6t0L9xypb6F/67GmSPiFi3sI7AI8liZ9iYWpkcyuZQ5AAxKsTnOspmRpkUdOeAfZCaxirfiTJ3PwU7NXy8YRsPl1KSM9J2GifxHMiktty/5o53y3vY6pSchw/xx+pNr2nDq9Z0tay09fGN+hFbpXno7tSWeJgwBNVgWSr7agJ/MlMY6k9e5yzm1+zhHH9DHKZzYLwBfBHBGLn4Kvm1d/8T6k6xCR4wkMF7DM7yjp8cldzX7klyE7Uf4ftNU9D0Q1G/CHW0eU3bN+goVH6mKn1XrzYoFeHI4n8Q7DNMd5GB0jGtFDmyMxz+IYK/QWbUAYFRY7JdI6oDZUCe9dWaYdIdRUVAmxRbfLzKJeGI8pg/M6eFceJNRocY0PaKUGl8yc7Gh7gbCabLpB1CaIw2J29XzFUordVpkAW1BxU+k+LkJ+1IgeIf7eQexaZHhBDdojAvc9GxjN+HS/ijPVoo2ph9PejaVO45A8TP6rN9V1T+Hb6TP3D1f311ED1h03wlJKUD+yC/ZGZe91S8QATEcjL86h0NFo5XPeF/T+b/H3eEVyj9Vq16DWg9qtg9q0qZBcAa2ALsfaiv42HtLcy7+lxqlWB9RgfuYkOzs8ckHmKj8TNl61/pq+zkw2hXOm8aMkiuEPObG59zAewT8n+JKBeMhXp6PhOrfTEYKeKcPvLPKgphklRLtXDZQH4mCC+beswfg03EWL563xAFonbAfC3NWlTlxWv7rXsdkuvMQfuA3p9PPBA39b2BLwBhgPxfRSQqNwqDYWNymth+RBbkGpQ2iZqAmsoRgBNpe/rvsayDi7h0i3BAsAqjzPB6batcsCObZT0aJavC1Mf/uMq/4J/
 InkmzfVh
 tb5xnMlI/3Sw7R6YTiP8pe7LaFJLClaGW0p6ib1VODf3Qfu0/6b201x771K8ijpj0r400a4+PCu75h2QiiOKr4AUbheseROlp4W+WTnf6wboIVC5RIZvSrhlrHg1RRm6De55ok75u6eRid1HkV4RWJva9n/71BHWivTuVSEhJb3OEeuZiTcvOJhiief1t8DLAiOgv+uLxdmAXP+dCJb+5O2ZyCyT31KcgGGdLgM9kn+sBiVdhbRKsfmud1GcWVPFHlOF0Dy2Nr3I5iFBPDPT91QL197OrnRvCbjo0ycnuIlytB9eHkSVLWCnwofhkwvDTPznpHHAO3FbL9t5o88fg+Shuu0/QDMVTJCFK452MEkszTX9puxJl0OQSaSBDwF9I5EOCFuX9ijKEgn/hXJulxHxC2axtZcAh/5VP8FrLNAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:06:41PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> > Rather than referring to VMA flags with uncertain meaning, add a new
> > predicate that explicitly describes what absence of the VMA_PFNMAP_BIT and
> > VMA_MIXEDMAP_BIT flags means, and then refer to that function for
> > determining VMA mergeability.
> >
> > If neither of these flags are set, that means the contents of the mapping
> > are managed by core mm.
> >
> > Otherwise they are instead owned by some other kernel component, usually a
> > driver: the memory may be MMIO, kernel-allocated pages or even ordinary
> > pages the driver maps itself, but core mm must not populate, reclaim,
> > migrate, copy-on-write or merge the range itself.
> >
> > We initially also treat VMA_IO_BIT as implying a mapping is not mm-managed,
> > as by implication it cannot be. (mlock() also sets VMA_IO_BIT transiently
> > on ordinary VMAs while locking them, which is addressed later in this
> > series.)
> >
> > However the intent is to in future remove this, as no mapping should be
> > marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.
> >
> > This forms the basis of further work intended to improve how we express VMA
> > properties such as this.
> >
> > Also update the VMA userland tests to reflect the change.
> >
> > No functional change intended.
> >
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  include/linux/mm.h              | 53 ++++++++++++++++++++++++++++++++++++++++-
> >  tools/testing/vma/include/dup.h | 29 +++++++++++++++++++++-
> >  2 files changed, 80 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 97e1eb4fe3a4..83953757735a 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1612,6 +1612,41 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
> >  	return is_shared_maywrite(&vma->flags);
> >  }
> >
> > +/**
> > + * vma_flags_is_mm_managed() - Do the specified VMA flags indicate that the
> > + * contents of the VMA are managed by core mm?
> > + * @flags: The VMA flags to test.
> > + *
> > + * Such a mapping is one established by a simple mmap() or brk() with no driver
> > + * or other kernel component involved.
> > + *
> > + * They are rmappable, and core mm services rmap operations including reclaim,
> > + * as well as population, CoW and merge/split (if eligible).
>
> I assume ->fault returning some kernel allocations (VM_DONTEXPAND set but none
> of the others) will currently contradict to that. But hopefully we'll clean that
> up in the future (or improve the documentation to cover them as well).

They really shouldn't be, but that's one for the future I guess. I hate that we
allowed ->fault to be that 'flexible'.

VM_DONTEXPAND is already a weird case that needs rethinking/renaming I think
anyway.

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

