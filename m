Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C2D4CA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:15:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B056B00B9; Fri,  9 Oct 2026 14:15:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3506B00C4; Fri,  9 Oct 2026 14:15:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AA636B00C5; Fri,  9 Oct 2026 14:15:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 655486B00B9
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:15:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02723A7E1B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:15:07 +0000 (UTC)
X-FDA: 85303889496.03.CE099EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 20E4F16000F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:15:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KrEnhiqR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569706;
	b=fKZXXPg62LHUTdLIvnaJfGlvpQ/6nGXuY+uTU+AtE1fEoND4uMZTDqVeaySTGliwHxP/EV
	SeVoKyknBcul7/3hUcF83z3UrQv/F1fncOK9zY4rtyKb0PWHNr+qZL4jkkMC098pVcxL49
	ZCIFrCKWbpOVl1jYZSED4zm18b1xpjQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KrEnhiqR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kIT+NSwzB8WFQk8dJPoNJK+jJx3kX+5/gdc7Ft1Lo4=;
	b=m7JyWwveFLjp3YN5ebanI4U7kLONrq0+acM6cVjq2jwid+L7rSqagoWRUETlsrd7GNOQrp
	ms471hbdPKbv4LUgHmRyonRLmmNBE6mhLpkAlyXOxx6sCI4St7ljCeRaimIYircFTxav+U
	l1CDir03KLsdz2K8l+kMxEVszDVcMmg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88DF360D86;
	Fri,  9 Oct 2026 18:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F4D1F000FF;
	Fri,  9 Oct 2026 18:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569705;
	bh=1kIT+NSwzB8WFQk8dJPoNJK+jJx3kX+5/gdc7Ft1Lo4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KrEnhiqRu9i4lsDKc+JSDpwMae6weGLuBFO+ArbsmpRyva9g0FDdn6c+DSyj23vDY
	 rhkcMfR5Ghltsrdk5pnZzOy7MBhnF2qmhb0+Mljgtpk4hLS54eU84z5vpzMAN8ZJ39
	 X99Tc83fsNjl7wgUqfb2Jb5f9Bg+jS2Ah7ujtLKDsfdMPjOBx9L+GGdKAoVYHGIar8
	 Z2IB9m8xZQQhiGnaO99hX/5aXzMt1UCkObU/7sM84LvniQjG9XGMBViBkpbLSNsNvF
	 8VPrgZdboUiqF2qzdaVApOxiVQoD5NNHQfyJ5PvXGYpbVxb1g/fo1XmLo8nCK6kNh4
	 yKuKuhRE8TJJw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:24 +0100
Subject: [PATCH v5 30/38] mm/vma: introduce vma[_flags]_is_mm_backed()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-30-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4160; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Y3b8xUgToSJog4n58D2kDCliQEWnfU/R2ucO/6ABcQ8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sybP1t+UYb2hMjvMf1s19Klrj5Svru4V1m9xf5Xy
 J51tiWHOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRhhmMDE3fl3C9YDLxseJz
 cYu9XDvn/+rJK7KiGETvf7vJv61bJp3hn/X+qdVMjXKXLotvydaSOcl2oOGjy+OkrQeWvJeekBp
 gyQgA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 58f4mfrbhz9gbsc1tjtz75dquggm8dzj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 20E4F16000F
X-HE-Tag: 1791569705-908287
X-HE-Meta: U2FsdGVkX18SCGkdEaf6bY7Qwnsc4RLZ0IQ8TQxSFkP0C7trft/GwzisRFpsxjLnj6h45vp62KfO9lXlO8yrDcyOIGt0tANg57RqB/MCBu7SqvC7XU6wJ235cr+EpF598SURJLmWAfK5bWVvtYzPAVpeHINYhe9cucxtm+qE/7v37cDtJ67T6TiwwnHLRs2deZWr8UepO78Obw90dSDyZ1h2LM93lshO4w6hABLHk3ZHPFaQKQbMvY7bgrdJSGYHU8vZ/+Zd0/Dn4kp0X/JwicA/MDa4IU6v8be4upeZmAP6aFq+uRmjeI13FkUa1eIJ7PFCuBxeHfZwgBFrfEaq2wmLCtvZnS4+yL2wU8I5OFcoZm2ZQR7zn9bwm9ynr+aKZuGsiP1LaPNDmK3ROWnQnxk4lh6L4IB3Ti6TAfZdj4EX+gIg3gc9cAUJeH5xOWDv1JQFiT2zu0WfKKoXIkpKDiuBl2d9J7IsG59cctUwaoN59YS69m8g/Ngkq+wvy08+f0OGp9HyPIwxswNvheJFj0iiPUn3TGQD7zUq/0rhN+vWNrrwEWQf4CnAl0Ibk2pPlHxuOOFoHvJd/xq4EODDRLrbYRHM69DpebPD1id6nuks9UtVwxPMuPbs8PFW3ynl9VnOV217HTSY00ZMTuNzGXKuwXw9BISoM9QILWm9sOo9iEwdwLdBdFN5eSVX/jariKxbB8eE9VhhtsfRlSvKFw2cVhDF/Eqcsfl4S3pSF1pq12lXBLNfFCoZBp7ccCPMbpCZZj9t1eAOZChuchWbAB9j3rlHf+1/WGmwljrMHI4WlMhbVnfi3HoX3ENip1frd2901vcbqufOhpwwytysh9BOPsW5ELNsMIk1gjJ1FWKYiPfZSnd6lsTQxu7XoSPPJyOvS3etgmnBnkD5eMW88SeH684b+9sNsg7q/hwe/pTY81orA0xjONEm1qk2Pzm9wzR7ljsuocKvufhvtRd
 NMKRbvqt
 fQgxJ4RhQ0DrJqTq14prXP6XsGgsyNbCkUZ58uvBw+IxAbGNY0QuOETh1g36WNoTXySJz+or9UYp9feLNq/pmWGWdFMnZ1ouRbrKsW5AIIYmzOfCFbpbSrNa4/rINASLtYg13IvwmByw7FbdRn2OiC5vl9bAySTvOXfT5wxe6WMtPMCubN3YC7tUjq6uxEPeQWiAwmxvf46HikJqTwJqv3NumlUfjsuHxMgjNoElho4EsmCg1Wt5SBgysqadNSNU4xVb7B0sxaEoswH6puglNlCstJsocZK+aruko3FAnP0QOINQoOK5KYfOySEkxDvyjyHjj6z28F1iwB/X8Alkrg38COiUf3v29hOtIEG3iP4afc5i7eGjodT6+NEWD74zhOVbscO/rbu/J0hEXCQIJcfg4LWDPqR3xys7buTm5FukcgOOsLX6ui4oknohARPR09d3s2qWTSkVH1CeA+CKzKA1MvnZ2DkZACtEMkLIMYrwBTlrwCB1Q5qpxFR6gzEUX4LT5BMUZvN8r/Nzu6g9xT+vN5egCpfp0zQO4ONThRGsCDu7EjGxaDYEZQev/5+NfOBEY4uCY9/O2GfE5J3sl3hvn3Y11NgGczUNcDpZOsS9MGik2kiDvSRwv234PHH0Ue2YUu2Qqi6F75vfZ9PjU0OmyLM4xo0xF4owu3zcT96KpW8ftUrXrHaZ52kAa1Ol9/2ftc6anu7XtkHDc0Q/JgTcndcUTrnI4+IHImA7b68kssRZTX1TcFTmYoBT+83mdkJ3BccfgYtSgnPJaJtF+AJZ9OaOgBbA9jhiZSexNTi5ojvZbeBusrUVqHh2tumlI3IHAMnVZjrs3i73lslaiyfBpadWKFmTWD7KlwQ8pRVC7RdynPYGml0lRV1V/9zLUD56KVpDUc1d0oWvB/Tky/vS1g2fz/MDcQCjFmnF5UdbFKUpZRSSpQUxCtK6KTbwshhPyZLotj1UlyoRVl9zaTfNlsX+8
 sku6QzOs
 rwVWTym8a9Iebp3gHW6RDTCAZuRUMjWix6C5PBmPHFTBoM+UB3lrMsrXNhI5C/faQqkuQxofVNiLFRHVnSPsOqebVmz+xpdF97p4U9Toeae8yQ4M3qijeTZkdWyl8+Ab1CWDgavXgqjt0c2n9WofsDeJ/7AEkVwoBzZZj+7OJj+G5HISEMy8nVJxYziI6pFcW5ail9aTn2S3e2205DJamLPx1lSyoYPWGrePRtEetuviFQ6Te8MTVBI/MLq719v1mNwWMkEVnb9U+N/34VGy4U+CRwVcWkwBUlof5rb8wdKs1IKJEPadWJbvOwXOvMBF3Mg5jHP3vu/a6M5oh1sApSA36AV4X4kWL1PYLGOV7vJdmpRNXpSGfwSx8KmXPK+0pIUjLzCv7oSZ306UDHkUNqA2rj9BYBUl902yDHXtMukvOFyH7nEZbRXzI5tFpPYFBGe7tcqsK7FPlxDdURy0xjfi8apqHqoil6aaZnmgdCj5Ib1NZt6n/sXZk133qMwjrx5f3PMCv9VuuDIK5IHRFhWyta8jwZYr8CHZHigLY2RZGQExQNNaKvJFSCWZoAuKzN87Z6DPvBWWBXLruE8+e0xO8aoCmd4QY+sfNIQwGdge9b3TvYhNWcOifQXCc7rArUI0J95OYZbTQ54KSJhMW+BlgbnFFy+Npsp5bfLmFoszDbeOwilSagMDROO1ldjRScBoqe8h8YKC2se0VbP93eIKyDDf7D2U78hkM+zcWjtpHcEBTWmn+41RZg+RIp2n71f6I6x8ujkjr/EzBOv6oTfD/ouVNVzLd9TLt1Etcxq5lEsZUYSXF1QSyjLoT64oXhbkH6tLWbZtN+o6NBOgO1dajbdxZ+MaEXPTks8TztCzA8kcS58JPjcoFYWWRZJtjWDGauQY5aEQR8I7ljdrcMkpqaMys5vhet0B3AFjpkToWKZP5dvq4JOE7+d2BMMnlDC1GJhVEC2DyaVS+dOoSN7mBRg1n
 /Xgc0dEy
 qaw08sgKB8t34oNg3jMnq3e7/A7MMQQWqN2ixppJ6ujVxm6gS1PxvAZlMzFSI4XPVT/TvAYMRttxmxjr0p3PcECB2O9lJhMiYl0c0S9PPNo0Yh67ox4upv0S6AhggSnhht5NyT4gwauMZ6tSho2OHQ8dFeNsgpYnyJsq3qYiiUPUgM9IIbY15XFfr+Gw6h+iwWwM83P7yfuK61pn1mhx8jU4hjUrxMCPn/uPV13/oc5lNJzKNtx4mFfKEIVIq8XmksN597pqkbxqqnynyFMuEafPUhzX2LxUl+AsnNli1SdzQLQ20Uy/NAtnCCUNvQ/V1nA21c/poNd+hHoWfBYsjr7oJjxtIiG95GWn338CtaUMHYvNsQTDhTZv6hwhTet/hCKHpKdIR/zs1eF0dNn/x18qO4yxh6/nmwv5zR4GYAY7EpV+VnfatehqwEMX7acS1krcaa8/SiE2P36Dx3EtMZAnCQ70MCi347sUgbhfeSjEtJd9FeMGXv8E+9weBQxG5kcmrtgVmUqcPQ5WmBvUur1F3S8TyTOTkhHqfakNz9owcUcm2qE0ipfMc3TIRcNbXJW/bvv6gZ8cR2VwBOxr77NAmRM7l+3oebjIAH8vGYNpMPXL6gYj2ldRrbVKt2B0rpsoiGHHhS+AiEs6nFX3bxaVNsLx84eJQpchgOhsHaaVIIxvoTSu9zeZ8+2lewwwoHnkdGJPa1dP7VaA/ZW3dqoNH8Mi2lKBk6Hv4xhS4HID/P4WrvWHD7YT0APUL/1xuQVQ0s/ra5Sh69T6QpaPzi5EbDOowTHPfdgCCRnGIwXcYQeqR0GYmz5eNStvWr+Z0B0GR62hUVBfE/kZVVOozwVLfidLAf3DuVjYTXU0+vOElWKwjx74+ShncpnIE0drUI+iNVwZeyS23uioWz8t88TCsOeXDdOpsGxCmF/oUlJJ4V147tFSX1tuBqajl55/PAVzbdTktpKdU/VM/nh+/9cPXF8wU
 J5q7knp9
 ahQvyhrsT+cSAFmTYg24117CQ9R2Czx7dppjUBbezc9Fhy+YSkEhKkptnOk32hgtbIVXrJ/AFwzqnGCJVoVSKHNww35ELoOYsjFW9ITE5qWBBAjOBSiS6mQuf7PvO/tINQXFkc9la/gcpfo8q8oQlS4vdZavqRqOy2aumfkuGpa6nIzZbIMFZMlIefaRUN278+rpWQXMkfM8MefLIv/GGUHEzJm1WMr7B8lAbePN+VKyLOh6ia2JogdA5NPaWTc59/qXGXfSJu1G+MdY5Cojp8rva2pt4Njasx4kesC2Z0QtMruMUXQS3aV26VzRUcU+Zz+s/cWrA0DwK8mJZhahvlRcgK4hb+1aJcFH0yRcGUZBdCC654xI25diipRIxkdxm1+EsKH2w9xCvgVA/0GvvA2qPlcMEhsXY5ttfQfdoxzbud9iDTsw3hsvOtp9pph6wlsUVMYN+U0DqGbL3jEg36v3csk1PDS5Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce vma[_flags]_is_mm_backed() for the purposes of identifying
mappings which are mm-managed and whose contents were placed there by core
mm's own fault path - rather than a custom ->fault handler - and which core
mm has not reserved the right to discard.

Mappings not managed by core mm do not fall into this category, as they are
populated by their owner, and nor of course does memory-mapped I/O.

We exclude fixed mappings as these have a layout core mm cannot assume
ordinary fault semantics over.

hugetlb mappings are fixed mappings, but core mm owns them entirely, so
they are explicitly carved out as mm-backed, as the MADV_DODUMP check
already does.

Droppable mappings are excluded as core mm has promised it may discard them
at any time.

Use this functionality to update the madvise MADV_DODUMP check to test for
this rather than open-coding it.

This replaces the VM_SPECIAL check which means it no longer checks for
VMA_IO_BIT, however this is safe as we have established the invariant that
mm-managed mappings may not set VMA_IO_BIT, so we implicitly include
these.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/madvise.c       |  4 ++--
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2ce68713e4c3..55320cf2c525 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1738,6 +1738,56 @@ static inline bool vma_can_merge(const struct vm_area_struct *vma)
 	return vma_flags_can_merge(&vma->flags);
 }
 
+/**
+ * vma_flags_is_mm_backed() - Do the specified VMA flags imply the mapping is
+ * backed by core mm?
+ * @flags: The VMA flags to test.
+ *
+ * An mm-backed mapping is one managed by core mm (see
+ * vma_flags_is_mm_managed()) for which two further things are true:
+ *
+ * 1. Everything mapped was placed there by core mm's fault path (no custom
+ *    ->fault).
+ * 2. What is mapped stays there until it is zapped or unmapped by the user.
+ *
+ * These mappings are the only ones which can be sensibly locked, merged, dumped
+ * or be subject to uffd faulting, as all of these assume core mm and core mm
+ * alone manages these, and that the mappings will remain there.
+ *
+ * Returns: true if the flags imply an mm-backed mapping, otherwise false.
+ */
+static inline bool vma_flags_is_mm_backed(const vma_flags_t *flags)
+{
+	/* hugetlb is a fixed mapping, but core mm owns it entirely. */
+	if (vma_flags_is_hugetlb(flags))
+		return true;
+	/*
+	 * Mappings not managed by core mm are populated by their owner.
+	 *
+	 * Fixed mappings may be mm-managed, but their contents are established
+	 * by a custom ->fault handler, so core mm cannot assume ordinary fault
+	 * semantics over them.
+	 */
+	if (!vma_flags_is_mm_managed(flags) ||
+	    vma_flags_is_fixed_mapping(flags))
+		return false;
+	/* Core mm may discard droppable memory at any time. */
+	return !vma_flags_test_single_mask(flags, VMA_DROPPABLE);
+}
+
+/**
+ * vma_is_mm_backed() - Is @vma backed by core mm?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_mm_backed() for details.
+ *
+ * Returns: true if the VMA is mm-backed, otherwise false.
+ */
+static inline bool vma_is_mm_backed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_backed(&vma->flags);
+}
+
 /**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/madvise.c b/mm/madvise.c
index 0922d5f07a12..9d0cde25da61 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1584,8 +1584,8 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		new_flags |= VM_DONTDUMP;
 		break;
 	case MADV_DODUMP:
-		if ((!vma_is_hugetlb(vma) && (new_flags & VM_SPECIAL)) ||
-		    (new_flags & VM_DROPPABLE))
+		/* Only mm-backed memory can be meaningfully dumped. */
+		if (!vma_is_mm_backed(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTDUMP;
 		break;

-- 
2.55.0


