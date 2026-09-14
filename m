Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AFF3C88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD766B009E; Mon, 14 Sep 2026 11:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE936B00A1; Mon, 14 Sep 2026 11:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977756B00C6; Mon, 14 Sep 2026 11:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6ACEE6B009E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:08:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04353A3FAF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:08:42 +0000 (UTC)
X-FDA: 85212699726.05.6491606
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1977B2000F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:08:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UziRXkB8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UziRXkB8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398521;
	b=x/hbSBh3pLD80yiOaZ2IqKNopoymFDC4Eb1rg88M74j45/PyAgP5ZBdo3zFP6LeIz7y41c
	6J1x1KXQls3lYboBvYs7W8lTWjLqfFyLNL6WmVrPHEVvGX3XRcxNTmA47wgeXFakdFtbwY
	Adu7be2VNZNDffax+AenUlYfQWWylm8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhSwIhda5SwYvYTkOqlzzzYcm2yovY5S5sJ87DUE+qE=;
	b=nu3Y0kJqMbnXB+Ae7rg1f52oFoQGaSrZzYqdzM2fBwCW8rNeKUhX7gfIW7EQELintDQFdj
	lZQ0QsdeqZC5uLip5Ncaq1BuLxXzJB7Pk2xBUCxnepciQjWuDSe3xxUdDZ24gTZXAjwijA
	X2ZjAfPxKEF1NdGjMB8qNIWJXfNKTMk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DECA40BBE;
	Mon, 14 Sep 2026 15:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7DC1F000FF;
	Mon, 14 Sep 2026 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398520;
	bh=FhSwIhda5SwYvYTkOqlzzzYcm2yovY5S5sJ87DUE+qE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UziRXkB8qeSmqlpvH0/NIIVjVlvQFMtZLRcgdF/oXLW1jALG9rz68famtPGxfLLRs
	 ji+y6RHPJeqximzqtvzaSgpAc4uXtBs/AMiDNlmrLZ47tNoBw3/ehPBq1GU+cLbJs4
	 PtV0usZP8WfROMhRCoKLEls1iPIULSzemQVda7uTFDM5Zth9eIIe+IOt5/gcqWaics
	 +A/fYodcbCpRBT8PQwbnjmpnErJp/wDNYP0A5jHhXz0HpAeGt1EUKsfw2qVCWjvnMu
	 tvLS7QNxc97ZPr5o+qhHhw0Avm/Rxv7LXwKdr3G/PyVf9ypPArUlzvdv7RdyeZfcoP
	 7xyKOl+2eOqxQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:40 +0100
Subject: [PATCH v2 20/40] HSI: cmt_speech: convert mmap hook to
 mmap_prepare, refactor
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-20-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2632; i=ljs@kernel.org;
 h=from:subject:message-id; bh=GNn4/WHo/gNb5sHnp4BEq122HpiBRxK72Bb5u1n+58g=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG8s77svu6u5dsuErBTja8a37zyVSJt9796Z3YtK6
 7f33TQM6ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBE3LIZGU5fWS/bJcm2O/Xy
 19eHU4M1av5JSFhFFIbqtl6SL6jXfcnwP/iD4rvg+8YGP2rkw57pN8j0rTiv4WXNP6/xgxPXg6j
 PrAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: 1977B2000F
X-Stat-Signature: namtbqrwqyinj8o6zkcpt8inab6aru6f
X-Rspamd-Server: rspam01
X-HE-Tag: 1789398520-643597
X-HE-Meta: U2FsdGVkX1+syl7GxgR/XM6KA6JPNq6kIiIR+MI/tuMDZh/wAxm5zmHyPNe3//l5evii6gOJNq013dGwX2YvSUvBBzHkiCmxSoqjq98pAwGaVpovtyN6K00strX451BvC1lXsoaQhUmx/LUh6QYZSRTOHOA4cegBglB+UmWnGorIgt4o2VSyEg4nWIEQXC8bB1c2zPwOYK3QLSHaDDBynhqTmBkttmd+A8TcWbusXc64o560/qAIhZLfzDzVorQ+kSWYydlDX5cSUUCghI95yZKdhO1Mc8prMf3dLvNY/yyuuR9S1Eckdj/1ZiQ45Ndryv6w02wOIkf5ONvZPzerGF0h7j61vIKfGAOiHVFR1BONNkpeGKmU29y/Cg+ta0yijoUJ9alGhhI4oRcc+KgWjnKcLNme2h22eOxjXlq9R8am3J6dxRswYfSrTcxhYOFjYMWmgRqdcyBGqku/bmZRSmtxlDIzH5x/V+IyGiopF5WkOLgz5BiJ4ilDGgNRL6HgXvjYPYA4xMvQBgxMtORZqmPElxCrb/coU+bTBw0wRYSvmAQDYHcaIXiWK+STunNyj3oiwsiDNMwX2C1pyORAiET/b3/l4RhqbFTvl1H4veMyLJQcca74xYqhyL1oEeQpASiOS0RrpOqnTkkqmCG0VGVrUY4oKoPeFsLZ+MGFY8Ke3SnrPFC8nW+8bGVZ6dTGWjG4WMRAXMu1NNi9Gz8QNlGqF8HiM7KH8gWMFKnsIw18ZBktDMA6oE8VXDe6amXohyILs8VftGFa6DGMcT4yf1Rt6DfJi78f+Ql2CRCHGtNKJFFVJ7FcMcxIOSng7eSQy6EaueovXn4B3l/LY1Z45NswjkkJ3JwAgPdcItcLGb+AkMc+VhtEjMqR/3Pb7DInAODLCyHk3yqNY/Yds8PcRUiQsBQejIeM8Qjo40jKnFo6dC/A2m3ktFhy5jzShsGiiCQd4bUUeCT1OoUy6vr
 t9YqOwoJ
 huzvng9gGSqU6Mh8Y8o1n1PnFlgqm8T8zJcENn6Ocg6ftRCMQjlAROYBQ6t4iaGVBc/9D+38GKWt2A4HPwt3Zkui2rndKEC6q00o8Z04M9XS8UTjVUSXSWH/s541E24XVp+iZ7LkU2D8CmDyrp7VA/+1U5ZTRoqVPaXzQb8iQs8rBLhRDEro7rEkekanvym+4He9rS7YYWx73MoWHSLfdtIVqf7YM0tDsKCHH+Wh3dIojGrk3NbJEWfhWIH9XQZwLI9MdeT20mybfbUuIy3IUOWbMK3RZTzlHbhrj10yIOAwh3dQbXV7UJAV1FO+G9BJNpvXC4LHJ3PvRyfE9uTmhVMSEGws8MhTndESfewtkJWuDepPEHj0bu5+bHHMaiOwNtNCKw6o06pWvL7HL3IdL4gt+i74pEwCg0HZC7hgLPf18MiPeHaVlM2B/cuEE3mSUBQe6xut2XiWnY8JaiOPmo+HpJ37r1p1Q5VtofbaviT0u8MCB186x8ToMgpPOpWFDNRce0pBpyx26dR1Mcdd9LJSRN1vZ3Iwjhlbv2eELHT48z76pbBGoBqNLwfN/A3Gc1j1RANgZquRDrXV0TyYe1wxpbMphxjQ/TgN0jvDEjBMmE69QaCxI3C1a1hGhTOQZ6YGGs/lCBDqcnvXDLZFS8hccd6zydGAaVsRBWWuYg7r5aRNjTp5gucHUxZ7aBByO6hGoGvjtYnGABt2LER3i+ox43MT4Pm2ZwpX/zRFm0N5dtPF2FvCOY+Rz9rXQ6J77xFrJ31GnV3xfMZjfs595nwyploq5LZMhBLbVFNtjzzbthuzHBUOHUOloTF5u+RcFcVOfrqZw8/D7EtweVF8tK6mDWruqxTpZjIwh0hjbvQqSK8mmXfSkpgwMkfcxswZhJW3iQweGSAf3466zGR6SKx2kvFzFeOpeIt/vCsyIZ/rob+Hu1YYRswNBVhy1NX4sFX7iZV8u0oHvUeYeVBcN5jcvdQ66
 S/ESgWgV
 3foYNXXcmv+429qjJLmuk2LqDF2C4EAseNodmjrJqOQGgZbHhAQkPD7ghNgCbrM0EeKp3T8A73qJ3yt1Tt0fSTxqtFlsKv/D850+oz9kLhcdhGDr6nukIRfAo0RLPKEo2XoVYOCfQE+cx8/3bFfNktodVP7u0NyHb/VNPLTZYERov09eyI3O7HOnviwjxLH3+jG7dbXXj5wT+3+t8gh1i1A7ZqrGNJJZtobCUv/2HIWIZahoUrPucaJiV1NOoDuP7xPiPWQe1uxbp3iVe+plH/nXrbBGtSSecEzaBA1Ph+RPhVSRC0Ec/JApScMJyepWLor29BqD2yqQCap9VC/wdW89O56Zj5DyJogWovwbj3BCyIsj6PF/7NLL5bLO7fQDoPZpfhXBsSEj1qUMJmYQUfpqzWd54SViZ4ISD8R1AEf8UhJSU5bRj5HWACqy7uanJvHPSvUvlcRky8w8GV/qHFsp1gkFW6hDbKdzhybSc6xLvH4aHbawFtJdjGNGv7ZfOJVFJs8yk+wq9trb0FPG5OdOzEpZphsbdnFolEzAIradC1sOj/lNuHpJgGTq0nMIPw+Eya0k8e22uQ2pCMPK2DliZRHYdRafC2wAelVQb3/4ypWvf+ZtMv8PYOsSIf2v669DMfXKHS+ye/RanvQhv54slC8/lBczuKkmLQnEF/sNSqwFgSOwMyKXo04yxBdPOA7B+zJLRWVZ/mqGdFEzZpihKge3nSg12SSHNp0N1Vj8yH5BFBMzkDzrDOVyENAtvhQuJiFlWNgAzkS3Ih4WY8cG1QLYrWwZ2uLc3f9B+0G56QBMozqbsmDqE8GGbhjbhJH0eaMp/rmPRiMSDWwC5U+aVsKPAFzp3vYQ7bfcgYA4GA0lcLYPlQBrTAV3htfuBHkmtZLwP5iQdeGGc98zldkBIM3JqAfoLddlBGXEETjwjSsNEV3w3Vf8BgPCtTyShzQCD+P2avUwtyCzU0r4QXoHsb6yj
 GE8kaEiv
 rn1nfajZw29eZg4ICB+LmIg+eTPcj5P+xlIS7ABzTLR1TYRdTX0iJJkMsJnujSBLMoSYs/qRW06erFFlXGhEPmdMQFuBtJNV4dp7FiIyHxYv0KrYl7bhhU70RbHdeQw0FVDeQcjxQUXIraGEvElTRIBpbSm4NaZaH7bz+QUvc/OUkudYZ1jYIyczrLQ9bPqPEOqZTHDNRlJmw8NoCj92tdJwBPj8Fs6yNwO7AdtUNLZZ00KC+mhE2KJaWmg36O5ms01Rde+0VAr1jYL18jQ4UgGxNvi0Fp8+tAkketxHdN6ebvl2bK1Kxy9JOERgmVngeP+l6Bs0LkYeJwfxIUTFKe5grg+syQvv9O5wkaEv2tj/zN3Qc6QiPyGE6mMqyjiOY7OxcJ0+oShMerTPg6MZWwTXuPBUQpEu81MIJPgwy0oglxtZoLOQsfvW0mAVz6m9UL5U86PX5brKeYc1Qa+JCEtcHy/QaB1VEbhxXHh6dyIBRhzuXNVBXzMP3hdpyfyGoIF09HbEC5UcMx0yWP1zNP//Qngv3jmaqm5Siz9J4HiX/+EQMixkya1Err/E4L6/6I7OOpX4MNn02t3zqDb8gAfSe5sN7u4Zqy09fP21xnrZI9RJ0Db58bw5ba6HcUaGOWJaC5XS5Kcvh4761Gn11JzIT3Rie69/2oVO/6erHQOOOvY2hyRwGCCPRxI3vdelizZwzJ5nnVDw2pe9F30Run8qVIYUT2GeK9GKvf9Sfq3LfppwKjJEtgjv64H4tJQoZJyDP2SqoCcqIHbW/MbC/F/kK8vFYA7rlStjocXXKHbJa/LcD05/UG7wEcU7JfjKuSYMyPqJ2jOPgjk/bud8YY9InizseYWEi4ZPvpNwt3+PxdjQe+cIqZ0Xd4uh9J9l3WMZ64vujsAJi7NdaUBeqEhQ9rRhYW6WYWkjB1UP5M/zXvhy5rv84uPipItrTDexnkYYr/0Dm7kaYMm9h1CmvdeddoBG6
 ZN+lwdir
 /obqGL2x1yWDPlAZYu+NjH7FysXlHEvbFR0Y8uic6mJzVxR/07jhvfKpV9df5dgUGMAJrYNzLm3CyinbpCYQFIOelgweWzE4VdtRndYBUdaiQ+OEi8Ya+CeXV4oSRiz0KlWiMW6PWGpqeWzjqD4KuQU23mbSUxr6sPW0KEoXiy0tSiNDNUL1vSPxopMCO85RRDpaMrggdyHiQlkGQ0kw1xNtOmcIb+ACG4ZRXmRTU5qveWUlCfivEfKE3lBzafVWWRz9F8MWMF9+Oq8lDWN+IH6qF07Y6RF3a7qiXUrLogE+gOU6HL9f9zr0hhjsSpqhz67xC0/BwArfy82JJ/JgvAH9dwQTnY67EVn8PiOpz3EnlcaBkSjrwTsBjh/+vc7NCaD4Oy5LRB7syp+AHap43lk26Rf/etaOF22aUanuxrDedc/lVrtM1LKvDxz8VuEo6wRGhmX94Giw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the mmap_prepare in favour of the deprecated mmap hook as part of the
work to convert one to another.

Since this is simply a refcounted kernel page that has been allocated, it
should not be marked VM_IO and should be inserted using the kernel page
insertion mechanism, so convert it to do this instead.

Use the VMA descriptor's private data field as a scratch buffer to store
the page in - this stays valid throughout the kernel page mapping
operation.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/hsi/clients/cmt_speech.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 7226677ebde7..801697b74d4f 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -1084,22 +1084,6 @@ static void cs_hsi_stop(struct cs_hsi_iface *hi)
 	kfree(hi);
 }
 
-static vm_fault_t cs_char_vma_fault(struct vm_fault *vmf)
-{
-	struct cs_char *csdata = vmf->vma->vm_private_data;
-	struct page *page;
-
-	page = virt_to_page((void *)csdata->mmap_base);
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
-}
-
-static const struct vm_operations_struct cs_char_vm_ops = {
-	.fault	= cs_char_vma_fault,
-};
-
 static int cs_char_fasync(int fd, struct file *file, int on)
 {
 	struct cs_char *csdata = file->private_data;
@@ -1256,18 +1240,19 @@ static long cs_char_ioctl(struct file *file, unsigned int cmd,
 	return r;
 }
 
-static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
+static int cs_char_mmap_prepare(struct vm_area_desc *desc)
 {
-	if (vma->vm_end < vma->vm_start)
-		return -EINVAL;
+	struct file *file = desc->file;
+	struct cs_char *csdata = file->private_data;
+	struct page **pages = (struct page **)&desc->private_data;
 
-	if (vma_pages(vma) != 1)
+	if (vma_desc_pages(desc) != 1)
 		return -EINVAL;
 
-	vm_flags_set(vma, VM_IO | VM_DONTDUMP | VM_DONTEXPAND);
-	vma->vm_ops = &cs_char_vm_ops;
-	vma->vm_private_data = file->private_data;
+	vma_desc_set_flags(desc, VMA_DONTDUMP_BIT, VMA_DONTEXPAND_BIT);
 
+	*pages = virt_to_page((void *)csdata->mmap_base);
+	mmap_action_map_kernel_pages_full(desc, pages);
 	return 0;
 }
 
@@ -1353,7 +1338,7 @@ static const struct file_operations cs_char_fops = {
 	.write		= cs_char_write,
 	.poll		= cs_char_poll,
 	.unlocked_ioctl	= cs_char_ioctl,
-	.mmap		= cs_char_mmap,
+	.mmap_prepare	= cs_char_mmap_prepare,
 	.open		= cs_char_open,
 	.release	= cs_char_release,
 	.fasync		= cs_char_fasync,

-- 
2.55.0


