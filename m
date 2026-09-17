Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9302DC982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921016B00C0; Thu, 17 Sep 2026 12:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8396B00C1; Thu, 17 Sep 2026 12:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C16A6B00C2; Thu, 17 Sep 2026 12:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54F386B00C0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:39:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5AE4A0453
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:39:49 +0000 (UTC)
X-FDA: 85223815698.15.1A116FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 02F7180007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:39:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXlzrcdv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789663188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7igvapfDwrm+6txgQcyn+RMKEShI1bTZhFDIgbQAbI=;
	b=ojSGQkc7gI325WzOCu6shRC6q/mgg5gts2cOfNF2TatmIkOevsFLD0NbnkDJdqEErS4n8i
	Eeu738K3sdU7HRtYRg9tY+hTphtziktmaUChh5jHBms0qLbirxJApexneJPKxKpWxA0GPR
	sLQVg/Pi6xl7fiHFbnscapjBAup7Ng0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789663188;
	b=I54wPPQ94dpJZmR0AEjuOROojNb21LVCr34vWsBNm8MDHBlJ/k4LlB3Np9ixc7lfJcTxBa
	ViSy6Cg9vP0DKNS7QE/m13P5xKH6+01EIUiODesf0/RrxeDkGLkRgNpr1nS9VvGRhfeDip
	coXWhN+7to9CltuEUUyEkNv82OyurCs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXlzrcdv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E37641676;
	Thu, 17 Sep 2026 16:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BD71F00893;
	Thu, 17 Sep 2026 16:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663187;
	bh=Q7igvapfDwrm+6txgQcyn+RMKEShI1bTZhFDIgbQAbI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WXlzrcdvB27dNz/P8fXcUhO78TiBpsDAscSo6k7ve2SsKbAa1LfeACh5BlLu8aME5
	 vovXK74qJt0dDl7o3y8RQrcYpgG2S7MTHWgiZZ3VAercG9ZPudQZUvcNl4TkyHZGCM
	 tmf72RuV4Uj6KLqiVvmMxxNCU1i/onR+4mI0XBGqKFnVIVtJIrGBrN1KWlndSs4bY6
	 d2yoD3NtHi3pm/PdGTsOBejNNPJwK2f0WWA6iyzUdjcZ/JggiiPSpvVYiVRZhUEiRW
	 5V3OUrBhNrca3ZxIfqAbo0cC/hqeLdOFO3Rs8Q2vxUYb/RK/kQyepsVHmJZxltTgMf
	 BGQ3vFMrSxvyg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:42 +0100
Subject: [PATCH v3 33/40] mm/madvise: use predicates for madvise(...,
 MADV_DOFORK)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-33-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1318; i=ljs@kernel.org;
 h=from:subject:message-id; bh=73C/rtzFa+0ZWXqoblfAsIR57zB38R+k6a/jXJhy+os=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB/Jbo/i/9WleylGkUOJSVnsF+vBqDUTc/O1pRKZh
 PutF1d0lLIwiHExyIopsjz/Ir4/SCRsXucFfzeYOaxMIEMYuDgFYCJR1Qz/LCTWeyxN8uuO+Dfh
 1tnvF5ZZdbjMPmw38/uBjzF68geEIhn+RxSZL6s5IHRKK+JivrVjwcXdHhLOe3V2LJr/dOd1rtn
 L2AE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 02F7180007
X-Stat-Signature: aymos7tm64h37m85iy4apwj5ify11jns
X-HE-Tag: 1789663187-1966
X-HE-Meta: U2FsdGVkX18qNUdwpzGNiXFrUSvaqwhVeVZqsF7cUU42r9YpTS/3LcYDY2tiX88mSA0lc42zKx5l9wPzmAm3bWg9bQ1IU7aY2soR8iEZV/aU0N+mTfUvySHg8VbZGXH/FCO5NcWmE5GFTMbLOUZ8faEcTXTCu2P1B9X7sd64h5bBzZ28ZcAMgjpuRJkGBiFy1qb2BCtUwJOVB/zP0PA6M8Q45v9VHoN09OWILsJnxu/i0xAMGdd2qDg85nVn7ZCtzAZIm36P0AOe3iKDxEGjNRwLpcucfn7cM2Jtdvf79v9zj+E272GlJXhJMM79n25+b4kT3xQHoYagGCXJTgM+BkKfViRgxol7GfWKi3O1f5iKQiH/WO7w+0tAemnRIqcWJHeu6/v6yqNDTAazitVZ9TOmoPQYC/VMPB6nBTP1E4Y47Enqq+aiwVAmtuXICvDw/K453feNy1cAOD6QG7BztI69ba7cp5Q369xXXup8M+X2lresbrK1HyPcce6HSAUmZ6BdoWzz7kESrvK0lC1+e6hEk87HA6vSHHdc+BaO914iN3Rgr3sX6+R6YMUYRMElro2Tw2WAryZIr8vzVmH8AB5tKCxBPgglT7dey6qxaGVI1GC0CSDpkAL508hGfMzq2QzAlyc+vX/Vb62zLDZZK35gioLkLmnk0Z1F2SCr0af3D05koYKHl6Kgt+d+HLx4DdSI420fmU5gh/714zbJpYOXEhmm7RdL3ejf3BMqznKl1nFIDZoBMGImSOby+kGNmz5OqdAwDeF2LmnN4KaLrhA6nA0Qa7cZjjKyDfzLV/kfhhEGyGj5a0t5xoagYqHUWRSjqhxnoh96SzXZhICPdVCb7VkZsHH0UcOm49JiE44wqewVZTQvVX8IzAm7VdK0jhitv3opQBQsU0sovuhAirKETUnLom3QgzDuBUOyFepBvDpXPjigsdW3Yl645y0n+zRbAaRgcN8yqpJtaoR
 nAGyFvHE
 WfajaIb0/9PRKG/pQkYxIJE/EaSNH+Busq8BzuWgZwcFYcMubXZSZq2qXWO5LFLzuqkTCKoBFjCD5fpbkBXK32+z3+Mni7WJsD2980OY8NE/Dam+35NHPq0GOh+E4FQ7clBk/BX9OMO8ZCbhitbvj1HV+vuZRXJWfInZ8GzFe+Z/k66rWKEivKFSZHcC4vaadA8edOrqrtmBd6r0OT7kgfOs/wf14GMthOB+02vK8MDSxSs4j1Xg1Ij1GjEDUeF2D1lscrh9ynKmm9XwSmFtPzXS0NxNoFBjYGznZA/vQKmyZ2zNR4V0M23vUopCSDR1wrwUe8vqGivrDVhez9O2IXPdr8746uNV/qbbAT3COfmeuHLYHgc1BoO2t1NCuytPSoBqJuLzYv0prjxXwWZZCQYbxJ2TauSBWnP2AuEt/q4iwUyRN88iFrhjKmkDMgId9A7tCx4f9NM3J+7DHhYZMU9cfytvC3hr/c4IrUXL7AppVFVX8O1Qy1Jfx/nxXkLVveMj0bXfpqVyqypYaReLtdIAoK2pHMtQ4VlBtgFL4Z+Rj7n/scjlw5sqVBm9IY669npbdoNLI23CEVG7jRBlZwLYaT6af8hHLPxQFb9d6URQEnb/f7oZ5sjia6xFGp8dPtApn2fFd6C1cCxmasb4WDprzGojgE9tlXXPlcjkzNfxlkQvOMmpjBndVLPPejOqD+unrJpjtO8d9mgvJsxDAC5M1wGWNYwrSFoRNWVkZdLNNkLzVbHOdevkocNy9cif6dpfbxEu0aWztLiNB+wIyQCYUKgekaxntm4Y6JsSQoC896AfADKSkttXLGkvLUSjyJD859vcDUfU3bw0RyPg6XWWWghb0tgGjYkOB4f73sv2qBAL0LF5zkeYyMfI2G8DkbBXd3f7Ks765fl6t6RsrOE3cHOcS9PGqPdL8fV+Z7TFwaNm33QRBYexzQqaFpWxDG8PBe1Zt2dwtZekKAHeCDoUkyCdx
 IjzUYdr4
 xZQ478wyoQyBiYPQ+tqhbbrb1r+A+4IOZp7p4o+bodBrIaNxUfbQM0h/AaXqe883yBBkEfqEiOw/ILMbuPpIhxrbmsaBRkNnJCYN07sceEr1SOnmq8WW8YgNSDonjMQ5o5GyTUvV5/zfATqE3VY7xUpmvZlK/tbwNGwuEWq1KG9I55GKtgzxxtCfqGxYPMObl/plEXSuO1lYEBfzVjA1cuiR0w8mnprm/249dQHAEDy2pA9+CX6eBPTYQNRxfL8J0H7VE/ItGiD/rNoUeBQ2ej6K5suD3iQH8antKB0NsD8kS3cH55ci9kwm9lZ0NZB6jcMUoZ04edXaiQ5cvk9kF4/abeKwpIk58Hct9PL0n5s+ZjSdXTTrUOfPj5QRZz3cTQowzBZmA1HoOGnXxGyUzGinKrlZSPT+9fSjBzQ2L2d8rV4WN+zSrShu+IqzF0qon2/ituQPET70cyUwBauyhPSeoCiNYhFnlf87zHurA6rMLNCr1+rFC3hPzsLOpUQKU1kQ96pL898fUZChTV/oo41sNaXfCeliq8k303xTohRQFKK4gpc3ckSsGZBzheNAsexp6/M95NLa5Ozj1dRuV+FJMPu2KRr4vc/bQe4EOGRNTFOk8+J/yqq1/gTmNKCSRptfIRs56dl0dbuZRDoyq8M4e7TRFzFCKFj/0o8HnP1Kuniq8mrQXJEtNIWG9C67m8cO8PQh5AWihOPqDhh3cwQFEiI4iRMq7fbM7Edmf3sZwoQTKOo1doU3lMOREJMMXQwQb0lf9nXBW+IXHxUJgLFMoixzRlPz2yDc7Z1fEkHXu4sUfusXJkUtNRNTF5XD6ed6N625CfRqUmn/OKXCkqKqbE5h7rOs7AfReSZWV0DUHweJu0BEjiz6cIpja7pG1Ln7JvUMZWukE1jMUGRb6KiehDGAiWyj4Qq8B1tRC/93SPZ7nhNcimG6HunjNRUi8RKg495cnNANjWdk30//64+vWavXf
 KExBot2N
 VQt/8kPtmZO23kmFTE/AHK+1UxJkqG40k7csMkPFZY7XtY/zO7nMDiZKPmf2Tl2f1TVYmGg+tRLowqbN9blNYSkLldPc6dDPH+TZxqzoP4C2wafa0PhDDbNsu76bU3GqzBV/QL2yO3CCQl50Zgf5x/F27MBzDSXoRy+VdC7dXqeiPvacT78Fj12y9TvDMDP4bUtzYJPTvGu+QTOxPimY3otPmQ0ETWwtdxwIXaKG/OuKh31fkcbaXYLQ0I34s4cZGqrVBK8CIBeX/qXye5uoPskRbl+u6+9hbCYKd1iktGKbN3pbOWn33kLDy0I/HtH+lUIY6bJVeuu8pB7iv5GY/cARqJ84zvibOIBd/U+pFoba8fizu0f5OgjLE4xfYw/slcAVJP5rl5qPo+3igze5SnrSSYBVoXtYgmawXQE22bC+bOdXKC7WTUiiCJET5IIP9VrGG6VAflHZCkdyCTKx0s372b6cU11ghaDP5qdxVNvGo8wvad+hr3x3wm7IB0Dj+jr6i0jphatFlC9oLZXyy8EMJy2PPZjRXI8hwdvW2+poALwkbbS3TaHMevpqQX/OSbo65zw7fR6+H14OTxfl0AANLFHXvcA/lnrkY3yxfNujgge5rNhr+zBo0K/81kHtC4Rw7LnhVtc/8FfPfBz613Wpy9xbhytybMrkAsrQHOuslGAFF51C8tird7ggL06JXJwnjqfGbCsDLC/IZnFDMThoMAldpuxStsAEgbsCMxcL5/jjAqqPtinHUGHzbW91g4VCZMd0y9yDesvhTLGj161yMKoVlRK6A8ef8uVNo2CqD8OlEyFsfVjtfIMM6nvmdWyFF0ZdSte+wfEjJXzlUrcHdxys+M39oPyW5yLy+2v+5rdWi8Ny6wF74zfUjXqtv+FYz6ITqN0eltwQDITPYlCmSF8oOgVVx4E4pZ4Hd+iHSGMn9RbmZDQGS16rh7JCjD4bi05908FLHpzzwRjtO/ABpq0OT
 xFYgmSIJ
 z9JcIDk/5a6bgRGaPofx0sN5CVSnpcRI4ccpLEgj57txQoOTRcufSPatHh2Alcwpfy3pRyI8LQoISDE5QceIxWXgnnaW3f3LV3pXaCBRK7/yuOXwOS0opNuMWapcnIlFDGTf4gaxYu+Sh25GXjKc1hANlcOcF2WsuSjUaLx8TOiSA8ino8yTsjl5gb+uqdouraLz+cat0Cld/QBC8Qj/ITf5V3YcmQvMVyN3CmMemDRmVcDCaXRS63iSo9vQBqtGK6+zrvAv+vBv+OfDlZC0wVbKOQOmAXIn/jKP6sMteuVtDDkDvdu6x/ZREyaA/5SdWCP1PcmxboNaeZDQb3klvxSQaQrGFi5q9eqx7895ZJ2N4J3HgQL2L5+IAP5no+uv+1D8aj3lTTU+wupydBjUW/sChphFAMdows6hVIRBo1TrvWi26e+Qv3xuIza9v1OCD+kfdfLlR9Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make it clear what we're blocking in MADV_DOFORK. Previously we simply
disallowed VM_SPECIAL i.e. kernel-owned mappings, fixed mappings and
VMA_IO_BIT.

Now the invariant is established that only kernel-owned mappings can set
VMA_IO_BIT, the VMA_IO_BIT check is redundant.

The rest is equivalent to testing for a kernel-owned or fixed mapping,
i.e. exactly the same check as whether the VMA is permitted to be merged.

This was established by commit 0b2758f48f22 ("Require (reasonably) normal
mappings for MADV_DOFORK") containing my hands-down favourite call out of
all time.

Express the same thing differently - if we wouldn't be allowed to merge it,
then we aren't allowed to manipulate CoW behaviour on fork.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index e15973292f94..1af82b044d23 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1565,7 +1565,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		new_flags |= VM_DONTCOPY;
 		break;
 	case MADV_DOFORK:
-		if (new_flags & VM_SPECIAL)
+		if (!vma_can_merge(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTCOPY;
 		break;

-- 
2.55.0


