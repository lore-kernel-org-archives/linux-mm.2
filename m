Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71358CC6B01
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56FDF6B008C; Mon, 12 Oct 2026 14:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547D56B009E; Mon, 12 Oct 2026 14:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437AD6B009F; Mon, 12 Oct 2026 14:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1AFCA6B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:49:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5763EA0DB7
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:49:23 +0000 (UTC)
X-FDA: 85314862206.21.DC83FB2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B6D0040003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:49:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QD0nlTSY;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791830961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5xYZY9H65OUGpiRPimS/vpQtz07u0fSLV/oQCSpMuo=;
	b=cmb4y7WeU2TIVlAZjF89R6LwAdur8bXAlhFNsWD2YCNDl9/IVarktdWtpiqvmxCjO2Gi3j
	ZsIysUEwZuUf0n94ajUinLWe1Em00g8/zJiZTZT+KPYdTcQmZLxcthTk4nd0EBikZFYPWF
	gLUUVBOTAe7fBOXGfRabSb9hmQtSFaE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791830961;
	b=ZRDrpUPgxTZH9dMkr3xHxSy9scuyXtnbgEGQaE/q0tgVnkkdxAHBH2Gn+8pGmbZFax4WXo
	0tt9F4GABKc530cCux4Vonq7opxkI24eoDilShQcVm16FX7brT9Pd30KN6A4QIR3F2Svtl
	yZGzEOdo2gaPxXl9r23o8UMfvDnwvKc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QD0nlTSY;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F132F4398D;
	Mon, 12 Oct 2026 18:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2A01F008A1;
	Mon, 12 Oct 2026 18:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830960;
	bh=z5xYZY9H65OUGpiRPimS/vpQtz07u0fSLV/oQCSpMuo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QD0nlTSYVtj4dNkFEj86CW+geONwlsBOCCxKL4Z5VI8jl9RxNu+ctk47hohFj6Fu9
	 +e008cXUT+5s+dspRdF9mukkJrSjMqJuYauZgZXirZaou0iae6xnrMdwnn3C4LHJLG
	 l+rwIJ0HJm1INbdiZmmkcvWCdZnZWMk/0GxoTFohesUYAMQe2SvdzViSzb6SiInh3b
	 a1Pp+lrht8MKe7fPvZ+Ldk4pbNrpIc4cOAmMFt+Iozcz7DCPZt+GFnFr6m6HOdpKvK
	 eqlLtmiwxsfhYmOgI4guB2j2wveanvpJWWJRM7K/9lsaQnSred/JAbtKnvetwME2C7
	 +846hHAR76X9g==
Date: Mon, 12 Oct 2026 19:48:34 +0100
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
Subject: Re: [PATCH v5 24/38] mm/vma: enforce that mm-managed mappings may
 not set VMA_IO_BIT
Message-ID: <as0qUOfS-FQgRnm4@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-24-923b70125b1e@kernel.org>
 <5d51b6b3-ad58-4827-bedf-f1a79ebd5c86@kernel.org>
 <as0nF53W7dug-Fem@gremlin>
 <5ba7305f-0ad1-44ee-be0b-36752684cdb9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ba7305f-0ad1-44ee-be0b-36752684cdb9@kernel.org>
X-Rspamd-Queue-Id: B6D0040003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: cax8rexhano4j4f3hz8z4trpnr13uccj
X-HE-Tag: 1791830961-885967
X-HE-Meta: U2FsdGVkX1+b8UI5+0IUC4KRMRwLJRJ8gBV0uibxg4QQwSElQhPFDbRKR67kRGvvkPTvHL4jh0oCOAXsqFYfRVCcWGkB8UVOlMfjtIijekV1uUOENS4Ptn89KUGAQH7VDoHNHG0mWR1+m6FyCcZXOXo6KWLFGCgT6DZg4zq9UNnc9/wBN7AtHL5uTI2hYX0o8QYwuQHIjTCldKqXehBQjrTfDMNuf5VStOt+1OT9Dq46dqPpi+U37rXLBuBgAgBhG3FetFCDZ5zJ/Vt6yrmfxPglHapE/2BRtqdjHx7ByZ0wgu/FYE8YJjKoadB1eY75tfrox9hTi6JMG6RBB15trG93+WPp9Ak8D9a2bqhXdqTZPg4MqfFb5uSbNyfYAbQLvj90JfefgOMxEfV2F6ympbf/TeoXncVza5FgLIL01TsnMrkA0OFwyvfbmtXlQuNQDzMmhmx2CMXunqoFUZJzhQ+/WzqIMPJbmZSLqlQe2MMICoLklPpTP0A1uGIoUvCYsRYvV5yMPgKbNJWT2NAFgDjerZ/F7NevsKXcyGWitUFfBsCj0Xw4e9Jkdi7FxGCTZYqqOdlrcGcrR4NQxXffxS+fA1k31UIZGg7p3JxrSKOAxdq5SFswEn/+MNUuCHmHWhrSiXy/HywsvufWRIshHUdHYPNWOUIOkiL96Kc2jJ8wQ9FWADQGa2NidiLS8irD9TA52ESLYCnCh5T1Zv/vFtmmVI4nroijvE3ujAgaGhwB5dyeOUP1fPg2sc2TWMfprtr7UC6/0M98AgTZsmg//B2QKnZN2iVM804rQA5pGmBOB4Oyr3e8Fav8PWSwZTnrJAkCPbfQI2phd5jbFcqq9lvrojSjaMWjwOeMD/j/b+V5INvs1xFPD0HkZ0am3Mppu0+2V5Q1kVJZImIuioi2pnSMkKUuvo2umC+YPnh0r7A5cxgfSUj0SiLsLb6RbRKIQ2jLJJzveFtOQ+iPi++
 8k0bzRuU
 W/YXIBePHlOOuDPY5kYYCdnwUD/G5RG/IAP7hFpcaG+kgaYwG9RlGmMA9A/CZrR/y44hhK1B1vhh53BOP51g1MnhKist+379RtI5Nc+W8Lth2jWut2m/33/KXaN4MSWIQbBvCR8evXhiuab5FvPMaVMf+jJdME9OzhcK284Mbn83w+c7q+xjjSFQcoZFWKLJZwZyOgCH3KOTauv5MPBdvpoDQ1N/7KWfSPh72lE3s4jprsEraYxKzGzeaxe2Q4G0z1PODej362sEvOjjgV7t57hoHO/z6GjrDq+fdeCP5ZmjBDbFSCR58S6tSDQKHWqHmzq9o5Oaf4uBssoPCcNXig1v345+2a4MOswbeIf8Itlg1RSoY9qVSlouaNwacSr31YW+ViagM9d1OdhrUG3Zhc5OhhxZvmneXgFXb8nYNgKL4WEQWiQZ5POQf5zNd8rwP80wN8u0XkMQIoJzPmk57Obcwz9+RQ0PmlCltE88iJsnr1L9wYuZCTJNu5U0Jahkuj6AE02aWuqL+OQSAmYA1LpL0Qlip+zbJ8SXhlYTy5NzFs0EXwnraLr21hcds+4Ume9XZ1qY0MR/NLGILtvl+RT9JhoG4SRWnYzFLGZmKBp4S+uZACdOMShhdLJbg+7SqwRe1Z3q2Lnej/leW1uX04ysFWmzvp/qx36YzRzAQ8hVqgMIl76M7RBDu5BUVLqmP5SxPqlsvTKsT8pvL3dpM3+ecn2vHroNnaYd3uQfDHU/RZbTeFGXuBL6dmSsQEkQoQGC3NYt9JTTVFhN/C/h7MtsYia4Dg3KwYUkbFGpFLnPq3WKKmoWouSZNFZLmGOseDRu0zM2CYFaiDV17lyIAZ0/TooO0lX88x+PQlWV6PCPZJAxxRjZ0KuvJRgiCPLDLTlCCuXod79O7im7hD7agtIhigqinBFajO+ZrDo+WcnS+Pn8U4YplEgWqN65XT7ZgYEdKXueF44iqCB2hEE2MtlFRHQqZ
 ReI0ZPGr
 CqbxD/hUbUwyrk9Ywdi0AvFqrPFcE4t96Eh/2OhCe6UGRPb1d5hxdXxYgKtSJQAYL+RK+DskM6wHR0jsMS/E1DwCQzic9tRLSF5AheHhFKhMXdtxlcfGA3JD9Fpg8EAW1vl47PD2OUUq6dn3H6FY7g7A7CY/VocxGf1Gvq74wg2kGDduTn4Dg3DossTYS9zhAwn0Ww/y6tC6SoqMOD9O1U45gF6cC0CqZHMXyFbPa8HqW3fJQdW5STNKaFDIHlOIHcVKAlXT7v6UAku2zabJAgKPD0ZNxwbdv8RD8I3a47L8t2gsCriiNTxV+w5WW33B+F1zcfYHf92yg4H3amFW6Ko6/rovcH8Y9NMgSKLR/AYppldGHEDf9EjQi+DZR29jrMc2Qe6af+Kwpg+N9/5rvY5SL1aqzr+VG7JoPeRh4hULTaHZeem92jKRTraXDgcg4Q9B4HeXa026B6gVtCVXjmw8U7UNUnHNPBvKer60ysefOGYjHaXNdf52n/je/zxYpzrAbn0pMc4qPr4K3Io8ZgL5zsxpsEcl/g4Jy3l9//JfDlVgjgjHIiLrCXhD6Cn3uWDx3ehIPTyvUQUUjrVG93baMBfD/2HwzUOE0uPYeqCatPva5cjs71EJiGQVvhd9AenVxnOSf26S//E4C2zUoMQoDpsiHnEhRu7STY09pCTl856/VdDdicRr7tk7dHLkPpLYqDhH727B87C9SuUaPtZ8vqyEvkvv/e2ujPlbTtfFAUYvL4m3aeQIWyyQfS3xED6OM2ix39IeR4qVjLqepTKV33aelAF62BfYJGDIa0pwBJaGQNXnz2h981nTEvsH5ZIYL/tQ5ynfmgqF8TXxdktldIlIR863PONl3ncjr+4gthw+6QKKDRqZk6PKVK75jZK48NRNvPBttRs2bKrR3rp2/XwCsT6V/2iCnZRUa54eacifqzXsZq0ALvOwPmL8RauDEGx5aAaPRKlFXLCGYmvqrH7gK
 O3oHDuqG
 JPoH9H5l50+6Ap6TcL0xsj1/bSWZnW1cLJss82TFANYCMXMDG1MK/U/OFLZcfVyy7W7x8fnJr1cEuEKJ3W9g9EvFCcbRhu9a424SricpiHsPa0tqx/re2bXBd6wSXMRTNQJipDOmPWRhkcJF/ssAjRWg02NsEWOPkuuLLCawoZ0LSHHU2+wV9CHWwHfO6H+5Pn+r++eUMS9jiZhSF2e30bYbUrW6dQv9zamZbGc2oi4btJuYeKezDbjXB4+LoEjQokpVuoIAA05AETM3loe8X5xyHybNBx6GiLkav2oJavk6ZqbEqHmmqPj8pV+ikkeVM4OK8g06LIBlyou86KlcHN6cwpnULPI1VFL6/mm8e6dGX15Nhs/tgle62FU+GV7nTVvZZhOQj0zMJrILlkZWAUZQ/euy8TcUhWDOFAkuIc/UO+6YL35iqCsHQtF1E6qxcEX4OC8wUZyAzGaAB61MhMJO+VjBtV00VxwtJJy60/EE/pHKLCWQE3cu67pOftsYicFVRe2CO1Omhk9P7OlJhD4GecUzqGNN1geXKYoAB9m04aTyBbdkcaOAcrp74pu9cdwp1k5hnI+xv0FO6zommGvyX/iS6Kz9KruVthttL40uA6pdeamqPEwv8pIkrw1QcczHCh2d0aRACqud2UnESOflVO3w7XgEVgLFPmRyYbiD8bv2rMC/JZhKdhW51stSufGXy+o7i+2fEFeLpu5d8rpSMHqd8eoxBR5qf/TF9BqjibvN+y1sgJ9306+Q78BlZtke2EDvjsys++58/1EaCO4FxGUHo8US/91qyXOKwevwMtTJb6DjxFqLAsdxG9T1D7Gcgh7CHvDeyqpP4c/RZBab531x5w3yUdV39S5r7uttxZseD3zWmCY3chFwgL59yfQD2eP200IJLPQazndCO2dmDw8znjfuqPpM/j8FeecQJ4d+XfUfBTRSMpppOEmGcZn1XX5RJRQCf34G4LGtCCZ4AfK2V
 WoGU4yCD
 Zyf/sybTEjGZksnYDcRHuyp973kulO4y9+5QiTNM6KNo+YNDjwfCzuMPbXq7Mkr8HwlcYzn2fX/tNC6Y/Yof/0ricDXeKtA5NvT6LKr8hzsn4puCVfyF3aWQdyJ4L109ONQQe/z8d3pwE3HH6zBHFaw89Xz4soCkxiPteLGM1HuF9IlOc4MbpYhKFzz+GPcIGZ26LJd67ZSWJOZjZVyCFI3DjHNBRyW68btrrQjjBJAn9ja9MWalWJtbtZ7sfFChBpM+0Fvedy4YoCas9RvTpIfF6U3fIjEan3xJfJ63zQ7xYIGdLYN88QEes/uba1ApfYQAlT0tOHkWA/m6Pl6QRRg/wl9vvoUHUCTOZhkQ166y3eugfmmTbiY1GN4naZvTSl2Swg+V61Bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:39:35PM +0200, David Hildenbrand (Arm) wrote:
> On 10/12/26 20:35, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Oct 12, 2026 at 08:25:54PM +0200, David Hildenbrand (Arm) wrote:
> >> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> >>> It makes no sense for a mapping whose contents the kernel does not own to
> >>> specify that the range is MMIO.
> >>>
> >>> Prior to this patch, all in-tree drivers which did so have been updated
> >>> such that they are marked as not being mm-managed. The check WARNs and
> >>> fails the mmap for any out-of-tree driver that still sets VMA_IO_BIT
> >>> without a kernel mapping.
> >>>
> >>> No functional change intended for in-tree code.
> >>>
> >>> Reviewed-by: Zi Yan <ziy@nvidia.com>
> >>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >>> ---
> >>>  mm/vma.c | 6 ++++++
> >>>  1 file changed, 6 insertions(+)
> >>>
> >>> diff --git a/mm/vma.c b/mm/vma.c
> >>> index 4f09fb98a2fd..51bdbe08bb02 100644
> >>> --- a/mm/vma.c
> >>> +++ b/mm/vma.c
> >>> @@ -2796,6 +2796,12 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
> >>>  		return -EINVAL;
> >>>  #endif
> >>>
> >>> +	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
> >>> +		/* mm-managed mappings may not set VMA_IO_BIT. */
> >>> +		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
> >>> +			return -EINVAL;
> >>
> >> We do have a helper (vma_flags_is_mm_managed()) but we're not using it because
> >> of the VM_IO situation ...
> >
> > That gets removed.
> >
> >>
> >> That's confusing ...
> >>
> >> Could we do something like testing vma_flags_is_mm_managed(), but removing the
> >> VM_IO flag from the checked flags?
> >
> > I mean we do that in a subsequent commit, I think even the next one?
> >
> >
> >>
> >> Then we can add a comment about VM_IO in the future getting remove from
> >> vma_flags_is_mm_managed() ...
> >
> > Yeah, but to do that the code would now be something like:
> >
> > 	vma_flags_t masked = flags;
> >
> > 	/*
> > 	  * vma_flags_is_mm_managed() tests VMA_IO_BIT, which will be removed
> > 	 * in the next commit.
> > 	 */
> > 	vma_flags_clear(&flags, VMA_IO_BIT);
> > 	if (!vma_flags_is_mm_managed(masked)) {
> > 		...
> > 	}
> >
> > Is that really worth it?
> >
> > I don't think there's really too much confusion intra-patch about that is there?
>
> I would do it as above (- the comment, as that is the next patch indeed) and
> only remove the vma_flags_clear() in the next patch.
>
> But in any case, you should spell out that this is only temporary in the patch
> description :)

And then there's a 'masked' variable that is unused?

You need to have two vma_flags_t variables to be able both clear VMA_IO_BIT
and use vma_flags_is_mm_managed().

So the change would have to be

+ 	vma_flags_t masked = *flags;
+
+ 	vma_flags_clear(&flags, VMA_IO_BIT);
+ 	if (!vma_flags_is_mm_managed(&masked)) {
+ 		...
+ 	}

Then:

- 	vma_flags_t masked = *flags;
-
- 	vma_flags_clear(&flags, VMA_IO_BIT);
- 	if (!vma_flags_is_mm_managed(&masked)) {
+ 	if (!vma_flags_is_mm_managed(flags)) {
 		...
 	}

Which doesn't really seem worth it for somebody who is confused between two
patches mid-series.

But if you feel strongly I can make the change like that?

--
Cheers, Lorenzo

