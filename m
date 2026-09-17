Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80F8EC982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97EB06B008C; Thu, 17 Sep 2026 12:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956D96B0092; Thu, 17 Sep 2026 12:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846976B0095; Thu, 17 Sep 2026 12:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59C1C6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:28:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE95140421
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:28:38 +0000 (UTC)
X-FDA: 85223787516.14.1F203AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0D86A12000E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:28:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eptxRHyb;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10L90PzOXSgbgk2Yp7RVeipj6WjV7mej+Ed4jbhmuXc=;
	b=Xw1aFqs4GlX/QuK+6pkhbQeIPCta8yTqQRVTM3YYG99A03/UlmlWzkBEFMojsRqIp9CWZ5
	a2lSXcGjIgClMBxBPIEmMAsHQkc81lHQoUNZlEHi14u8bTcxaLjUJH6ddMH/QS4QHgCA0R
	vwr4RF/DGwfbEMudfNvXPk/kVxLNPqg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662517;
	b=Zk06mynQChpDfnKHQ1170hAOuLQghmUIiGbArAwTHDMegf578d94o2py3OGFITxq8VWWp1
	DT4UUncuhSWXxiiGnv1D4SuQFXZHGt3xW7f07gij7zYfJum7uwXGsdPuTWXwhNGSP4Aplo
	sgwT/otO2Lk71lyZh0XZe2XdC9gNKAY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eptxRHyb;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39E1342B8C;
	Thu, 17 Sep 2026 16:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2124A1F000FF;
	Thu, 17 Sep 2026 16:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662516;
	bh=10L90PzOXSgbgk2Yp7RVeipj6WjV7mej+Ed4jbhmuXc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eptxRHybXyah7jNOCIE+oNZ/IohTqXcA0mkjUlcUQNeIMBlwC5WNDaEuR8zKtnzp4
	 d8gtAZBhi138AiUGojyUOlhSC6Bwi6+oyHGdcO6uaB+TO6TNwiasU++a5qxAMoMUOU
	 8XiShLwMIh5+BqAn96wOTWp1Dc0vJZpa0rkoYOfM+K+a5qP8hlcAxkdbt9H+MGcfGy
	 SuiBKUxlWP78pgDt3HtcFJ07iR5IUgdl05lka5bLNHOTdtpu07zevV83G1yl6K/X5j
	 JUeen7SEg+ZMhnQNHztAL3ahdOERkML9Qe/Tsy/kHlDigHfQHtqNpfEX71xIsrSuE7
	 N8yKvZuWdcGTw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:20 +0100
Subject: [PATCH v3 11/40] infiniband: update hfi1 to use
 remap_vmalloc_range()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-11-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10306; i=ljs@kernel.org;
 h=from:subject:message-id; bh=t2zMqz7GwrO9LwCoKVbfTLpQhoUUcOpzKx1NKvIhX3o=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB/I5ar705nlbL5p8RP3w1ENcvnWn7/u+3DPM1z4x
 s7dtlNWdJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAioQsZGZbmbN6bpFR6+7/T
 KY9TJsH7NW+e73vXWf95deY+y18yvwwY/mmcfu6nElTK9/PA1i+9Bi9XdGeveP9BuvB0xKNzR2Z
 nfmAHAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: ogdym1t1bss5x3m6t4ykfsqpw1j8fqbk
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D86A12000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1789662516-639636
X-HE-Meta: U2FsdGVkX1/C9frQ30+Q7sRCg7rddq5FXSQ8C/Z2DmX/djBXMi77vSwqIAUgaNmROcQJQxaBb+BXInCUYbj2bfb0xJCrlyFhw2to9xhinOJuTGtVxYr27nU7OWBLEhsaIKtGjLXemVJ7vDz35u9M/y7ecntLCe1TjIR730jDuoXft5KDIp5Qv7k6mxbcTdBpc93QjWMb2+GnA9+ihnzv9ClVTQ+M23/lL/QuASLy9lqdk9lnLelJxT8Lkc3yrRWCrz6Gym2BhfD4pI390FgMfVeRFbTuVLi2r0yawvWKY4FQlKqgeVc5jQt6m6W21NHNfTuz5O5UebdoZpc9ydufSHVLvOi9LMGP+6VqpkYGzv3soGwzeOOZWJSsnS6ife/upKgxSvfQ+NPaLbfBaCUJCMGWoZLTGDr1Wh3dke7v28fHHWHWuj4iiVZDnVVwamK2KRpmZoYdHpPeAq2TSj8uuB7hQ9Ec1l7ztLUChdjWsfmjZYLsEgiPlxE/kMAg6N9LknAUkKPkEDxrahK4tjcbXh7jEj/C+RoGSwcYdbhWeVBUonT9WLS71iBgJ6pzW4VrwouvG+rITpYiX1dnRz/0Jje59GYY2nEyBWT8UHWCQXjFTkUzINpkjII4Be7IRQFfUtbeLxQBHp/weJdU0s3rlGXuVWhB4NqfnMjuYqzxhZ3oml0SzWyym3D8pOkfYMqc14oVKQfZIcIRamDjb1hnAef4Enf5IZkruMkbiwxoIbnC52XWud/tsnnoITOt3ZAvgNO0SvqmFPM7wPm5nTBnF5PLRwxB8Hery7Z7+f8jxCP4tI700bybdXoUIn/I6xTAU7r4CxiCq+hhPUN2cAb8THIO4OrsUlsB2GzKlUDWzkZXMvo0H33bB2bFmnAO5ku3lhBa3m8J7UbvUpvFS6ZMTXNZt/KqqurgIBL+NNSpaYo7oJOuwAZPzj8I8mSEeSFvhVRyJUZwZlMiQoGXldd
 bLONYb22
 4y9zC8qL34So5LokB22V/wNxLF0oYZmg/totnFnqJ5RFDiMBGeILbpEXdZYk9SIqnRZobwMO14CjyZ5a3X0xiL38AkkSc+z0s5Il2le2HzguLg+czk20w0CoWmql2tk6hUe5349QeMNIGSrpl+SmKCxuPVaHH0bBGewOcVzO/uwRVbo9nlqzJPj3hmm1ayxoC1lKwCFI4oTQl5rx0Y0FlT5WzjD4hrlavWwHNL57EqbQOSUR21MYivTQEAQmQ3jol1zSmU6xzj80/4jnHhuWqy154CVZoI8V7g6P5x8qJThlaK2FfQ9J3UvvZybiAJAqvbaGlUNs5WETtKrj0T5o7s8/OsFL1l/sb5+YTL4MP6YkitS9EKIWy2DrDjyhkzyQ8uWNtjUcpBqOh1+U4+lxG6+jpiVbL/ATBRkVkehMPvm78VmHfys41sCUtFmUNlE0dCGBpmtlk3T975qa/iW+23YtapzVv5ymSYLfsB/NfCAWOCtakXuuSxf5DyDJ7uMfNIrZGrpRu+92OjfWqZN/GyMQBdGVUn5NcKyj3NG/foSP/ETSq5Na5BAce/hts8V3uOTdKiCIl2ONl+7jCvzchQ7tZ8fcqh5rf1IMbkOH6oGWWL4IV5k3tIV5u4cs7u1pJMkkYfivK1nGLNo2WwWaW6C32zJv1KV3kLPnXSM/lHjSKk1ppZUfkPIJanIcrKck3mSQ2oIg1/Eg3JHnbO8XzCRkiWw6OcflmkHsgpeCqgwAe2hSXLS5StG3g/IqNjtZLCsD2ncJPZbv4IzI5FetfKSh49SETMXafLT4l4GY71PjMr20gi6DMTI6VYZ4frvsRSR4fJHC5+koOnRjq29zV4Y77FYWp4mgEbKnYphi8G0UtlK0ROm6lLqTwQ9BK9QfDua1QPaBKpJM1fo9wnw6Uk+Q3B7w5n6+Y62jPmlNHTzWEbvbtqM+Yb7Zt01I7JGRRK92JLOwfqmyVoe+y44ElFHikpiCf
 xXIdiQCV
 4gYSYN46d3ud+1UgT/kSSuyeEEKW8EtWazw6dBRjt+n4yqjkTI2wUBPcGajZ1IjKLOF6ZVwpcNLk2+lLyhqrN61CytkYCnbJgshQOSWEhPEL/yxEE3pV5K+vctExeck5WBQHrVrI4NMhJ6ruSL0wTKO1tIdWtDtXJ5UzXhuHilEUBM3C9Qc9L8eHs0jepWEW1z6oik2/Yo2jwjGUaM6RaSCRa/fx1Oc/vRW8pPwNKoROH7apMUgkGAZCFifCBPEtvkueDAke6wAuev+SKlq3JAI3o5gilBpHJDElV6gh0NMtk8oROjS7HgcAG7vo/AxTEnLPXrNwRLS10lSMz3LPZzAT32AjmtCYmsxM0tq9pTQB4uL1R1ShdZudOcERvhcbs6Eh4e3n3yRqyFMxUWuNe3TONAAxHYYxqpyeYuspzVb34QbnA93QlVfVNJcIsYmfVMOCGrdP/BYk7PrJ9OgsxCvwqe5pjpAtQeGVepWLUwTPTTaxEzYoZMC5tt0ModFT5LF+hzI7XwK5j2lME4xry5zpUL3BrsjQ8hZNm5ybmndx30b0EDWgiN6TTKcu57KNVoiFcDCgsl1Yqjk1pUjE7Sx8nUWLl2IaYZ08F34+1+PnXVn5eP7hzdxzzYdD4w7Jyz4K6VhLE3bTlLpHVtvCzRMpfnpK5EFVx6f8fwe5mQueOivc40DXpL5fRB/fL4IrqVGhQCIWjb9BVUP3IMJ5DtqA9zrCLwj/o2aPGIkU8B2PSTWLuFaDnPawJx5EHGSFQgu+9AAlDC9kv5x41wAOwCxyFlGwWsl8QOl8A+Tx7nBqxmCnVOSrIRFKw0plxDEX2wq9wxgceO+IxSaBQeZrfDFS6RFnSSC4pH4WM6FOeoDeceAaMECRZXY6AwTmwFJl5pyeSWaICPqaNalO44yeusrIgfh+MFGfB94zXednNwwrYA/oaeY8oIoyhOqddbAP9PQTEtfbj6t+alePh0dW79I5O9o0a
 dbzL987S
 cqqmhrjRwY1oPWaY0WepcV9XKBVWyiYBIzgbRyZiJtNfxG80/OPYrC9sX39h7HGv7NiHeVZZmNjHSUNkx9dD+RvEsdlwWfq9kWtOi5XZ1ESWEseEuK8mj6t1jYKe+xjeieqlJMKCqXUEokud5Upylg1ny8R5LFLifc1JnSEYvaQliUZ4L6p0oWCc/WUHOjwFznVR2SVUajn6TuxU8iPDAFITPMDGpe7i8Q+wcjks47bu95nEvrbbNndbyprrrBFxXEAY1oxTZOYnp4ZjOEGMgj+Idw2iQO5Hc3FoIQMB3hFA6FHtJyFCQPZVY75UQFyVCyq/n6j5KJ/oScl3rpopI5Ez+y33+jXQZPvm+2e5DkmwFxyAasaCPzlYPlkfcjcYL1fGOLgwqQyZF4jVbckm3x499z+t9YaC4Jipf/2ZOAayRrOp1K0dxboKDelfZKDXoJGGlzlqA+moXw9VLDdNQrqHnpZWmFLZ8EW4EE2+XqcPwyGj0iQnCBMcU6RAJAZUE5qruhbwTOJRqcAeiPZYLV7p4/fzaTgnyGLV+9UuPC4KfIm70+/ntgKcmPLWnOqYqelbQCfoiiKOz7aMuvaw6XpGocyQdc+ZZNTBUwHIIY/eJxkDadaO/UumzoHo/4rmbaU5kj2CCI/CDjKUGmmrMzoq9sC2fD2pEJeHOD5KivthosBZgYX7zSh57OPr/y79xgh9L5cPVhZxzH69Pd9EVeyY4rLmEJ9inHOi5tZvAs5eoTIqByOBwcTWNNAYcP+LF1LAHF3GWvriJHljAEiVwMZZ7+h3hXLjkiVzHVhtKqsVXIeXt/gCOb2/AJhJV8QRUSjBX7nmkqJaDS0VC9+wd6jixI+pmPiJndJJ/ENodKIphTuzmnVos67MqK3UHcPzVaf56cHcy5pPpEu5Z0Frdg33LDbgTp7+wT8PxAzymWxx9ZTH5qchIR/mcfWsgADeK8uHZHab0TDobdVQfWsoV/azaE7ch
 Eus33qJ5
 9jylj/TaGFrr8IOFYUALu6f4AB9So2cxW+3jwP2crvctWvfN3A2L7dnz6RE8idoXRg1C2/r6SVKQXU/jBvD4cYd4jE79tEd4FJmOMBXeMYPge4EQ3j7RuDSVCoTEf4Am1d+Fqp8p3pVq8EuDc+oN2wpPyyWrmV/aD7Y7SJRV27maGxOzMDoelvYemEuyoEPwfJfx1cMBhIOvgf2mweSaqs1z1h8OHeuXvL+PErlzt5rzM/ZSKU5GmnvlVFMk+FdeFWmT2zFVVWUWfTxWKGXiW92upYeLRzLmsF79lpYZXtAxwVDSit9pMzrnyHisX1Xkrz1MWihzCkIfeDzJIJpMZPgK3hfjYM7Yl8n8qxsGFkENS7ry8W34Eblf/QWdWMurF6g0xjAs2vyMfZkEgT28LuGibPxPBjm/ElTyVNS5KjU8q6bFVVsspk1TdOw+ud4pXIbAKEkdYW9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In cases which map chip memory from vmalloc()'d ranges, the hfi1 infiniband
drivers currently installs a fault handler, and then smuggles the kernel
virtual address of this range in vma->vm_pgoff.

This is exposing KASLR-sensitive internal kernel state in the VMA, and is
entirely unnecessary.

Instead, use remap_vmalloc_range() to remap the VMA to the span, and
eliminate the fault handler altogether.

remap_vmalloc_range() checks that the VMA does not extend beyond the
vmalloc area, and the driver already requires the VMA to exactly match the
span of the memory being mapped, so this has no impact.

The memory is all preallocated so not having a fault handler has no impact
either, other than pre-mapping the ranges which is beneficial.

We also remove the VM_IO flag as it's not appropriate here, and the
VM_DONTEXPAND flag as remap_vmalloc_range() will set it (and also mark the
range correctly as a mixed map).

We also update the vmalloc paths to place the virtual kernel address in
memvirt, rather than overloading the physical address memaddr. We predicate
the vmalloc handling on the vmalloc flag before we check memvirt for the
virtual address-derived PFN remap path, so this works fine.

remap_vmalloc_range() requires that the vmalloc()'d areas were all
allocated using vmalloc_user() - each of cq->comps,
uctxt->subctxt_rcvegrbuf, uctxt->subctxt_rcvhdr_base,
uctxt->subctxt_uregbase and dd->events were allocated this way, so that
requirement is satisfied.

We also remove VM_IO and VM_DONTEXPAND from the STATUS command, as these
are both set on remap.

Finally, we remove VM_DONTEXPAND from the PIO_BUFS, PIO_BUFS_SOP and UREGS
commands, as these are also all set on remap. PIO_CRED retains it, as
dma_mmap_coherent() may map via vm_insert_page() on the IOMMU-DMA path,
which sets only VM_MIXEDMAP. The RCV_HDRQ, RCV_EGRBUF and RTAIL commands
also map via dma_mmap_coherent() and never set VM_DONTEXPAND, so set it for
them for the same reason.

Note that we retain expected behaviour throughout - the vmalloc remapped
ranges set VM_MIXEDMAP | VM_DONTDUMP | VM_DONTEXPAND for each range.

VM_IO was never appropriate as the ranges are explicitly not MMIO, and the
reference to the v3.7 VM_RESERVED semantics map on to VM_MIXEDMAP |
VM_DONTDUMP | VM_DONTEXPAND correctly - no core dump, unmergeable, no
normal vm page for purposes of reclaim/migration/etc.

There is a change in behaviour in that pages mapped using
remap_vmalloc_range() will now have normal GUP-able pages, however this
should have no impact as there is no reason not to allow this.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 83 +++++++++++------------------------
 1 file changed, 25 insertions(+), 58 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index dc548e6802e2..b02d1f1dbb27 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -70,7 +70,6 @@ static int set_ctxt_pkey(struct hfi1_ctxtdata *uctxt, unsigned long arg);
 static int ctxt_reset(struct hfi1_ctxtdata *uctxt);
 static int manage_rcvq(struct hfi1_ctxtdata *uctxt, u16 subctxt,
 		       unsigned long arg);
-static vm_fault_t vma_fault(struct vm_fault *vmf);
 static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 			    unsigned long arg);
 
@@ -85,10 +84,6 @@ static const struct file_operations hfi1_file_ops = {
 	.llseek = noop_llseek,
 };
 
-static const struct vm_operations_struct vm_ops = {
-	.fault = vma_fault,
-};
-
 /*
  * Types of memories mapped into user processes' space
  */
@@ -304,13 +299,13 @@ static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 	return reqs;
 }
 
-static inline void mmap_cdbg(u16 ctxt, u8 subctxt, u8 type, u8 mapio, u8 vmf,
+static inline void mmap_cdbg(u16 ctxt, u8 subctxt, u8 type, u8 mapio, u8 is_vmalloc,
 			     u64 memaddr, void *memvirt, dma_addr_t memdma,
 			     ssize_t memlen, struct vm_area_struct *vma)
 {
 	hfi1_cdbg(PROC,
-		  "%u:%u type:%u io/vf/dma:%d/%d/%d, addr:0x%llx, len:%lu(%lu), flags:0x%lx",
-		  ctxt, subctxt, type, mapio, vmf, !!memdma,
+		  "%u:%u type:%u io/vmalloc/dma:%d/%d/%d, addr:0x%llx, len:%lu(%lu), flags:0x%lx",
+		  ctxt, subctxt, type, mapio, is_vmalloc, !!memdma,
 		  memaddr ?: (u64)memvirt, memlen,
 		  vma->vm_end - vma->vm_start, vma->vm_flags);
 }
@@ -325,7 +320,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		memaddr = 0;
 	void *memvirt = NULL;
 	dma_addr_t memdma = 0;
-	u8 subctxt, mapio = 0, vmf = 0, type;
+	u8 subctxt, mapio = 0, is_vmalloc = 0, type;
 	ssize_t memlen = 0;
 	int ret = 0;
 	u16 ctxt;
@@ -347,7 +342,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	/*
 	 * vm_pgoff is used as a buffer selector cookie.  Always mmap from
 	 * the beginning.
-	 */ 
+	 */
 	vma->vm_pgoff = 0;
 	flags = vma->vm_flags;
 
@@ -366,7 +361,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 */
 		memlen = PAGE_ALIGN(uctxt->sc->credits * PIO_BLOCK_SIZE);
 		flags &= ~VM_MAYREAD;
-		flags |= VM_DONTCOPY | VM_DONTEXPAND;
+		flags |= VM_DONTCOPY;
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 		mapio = 1;
 		break;
@@ -401,6 +396,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		memlen = rcvhdrq_size(uctxt);
 		memvirt = uctxt->rcvhdrq;
 		memdma = uctxt->rcvhdrq_dma;
+		flags |= VM_DONTEXPAND;
 		break;
 	case RCV_EGRBUF: {
 		unsigned long vm_start_save;
@@ -422,7 +418,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			ret = -EPERM;
 			goto done;
 		}
-		vm_flags_clear(vma, VM_MAYWRITE);
+		vm_flags_mod(vma, VM_DONTEXPAND, VM_MAYWRITE);
 		/*
 		 * Mmap multiple separate allocations into a single vma.  From
 		 * here, dma_mmap_coherent() calls dma_direct_mmap(), which
@@ -438,7 +434,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			memvirt = uctxt->egrbufs.buffers[i].addr;
 			memdma = uctxt->egrbufs.buffers[i].dma;
 			vma->vm_end += memlen;
-			mmap_cdbg(ctxt, subctxt, type, mapio, vmf, memaddr,
+			mmap_cdbg(ctxt, subctxt, type, mapio, is_vmalloc, memaddr,
 				  memvirt, memdma, memlen, vma);
 			ret = dma_mmap_coherent(&dd->pcidev->dev, vma,
 						memvirt, memdma, memlen);
@@ -467,7 +463,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * user registers.
 		 */
 		memlen = PAGE_SIZE;
-		flags |= VM_DONTCOPY | VM_DONTEXPAND;
+		flags |= VM_DONTCOPY;
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 		mapio = 1;
 		break;
@@ -476,15 +472,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * Use the page where this context's flags are. User level
 		 * knows where it's own bitmap is within the page.
 		 */
-		memaddr = (unsigned long)
-			(dd->events + uctxt_offset(uctxt)) & PAGE_MASK;
+		memvirt = dd->events + uctxt_offset(uctxt);
+		memvirt = (void *)(((uintptr_t)memvirt) & PAGE_MASK);
 		memlen = PAGE_SIZE;
-		/*
-		 * v3.7 removes VM_RESERVED but the effect is kept by
-		 * using VM_IO.
-		 */
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case STATUS:
 		if (flags & VM_WRITE) {
@@ -493,7 +484,6 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		}
 		memaddr = kvirt_to_phys((void *)dd->status);
 		memlen = PAGE_SIZE;
-		flags |= VM_IO | VM_DONTEXPAND;
 		break;
 	case RTAIL:
 		if (!HFI1_CAP_IS_USET(DMA_RTAIL)) {
@@ -512,25 +502,23 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		memvirt = (void *)hfi1_rcvhdrtail_kvaddr(uctxt);
 		memdma = uctxt->rcvhdrqtailaddr_dma;
 		flags &= ~VM_MAYWRITE;
+		flags |= VM_DONTEXPAND;
 		break;
 	case SUBCTXT_UREGS:
-		memaddr = (u64)uctxt->subctxt_uregbase;
+		memvirt = uctxt->subctxt_uregbase;
 		memlen = PAGE_SIZE;
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SUBCTXT_RCV_HDRQ:
-		memaddr = (u64)uctxt->subctxt_rcvhdr_base;
+		memvirt = uctxt->subctxt_rcvhdr_base;
 		memlen = rcvhdrq_size(uctxt) * uctxt->subctxt_cnt;
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SUBCTXT_EGRBUF:
-		memaddr = (u64)uctxt->subctxt_rcvegrbuf;
+		memvirt = uctxt->subctxt_rcvegrbuf;
 		memlen = uctxt->egrbufs.size * uctxt->subctxt_cnt;
-		flags |= VM_IO | VM_DONTEXPAND;
 		flags &= ~VM_MAYWRITE;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	case SDMA_COMP: {
 		struct hfi1_user_sdma_comp_q *cq = fd->cq;
@@ -539,10 +527,9 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			ret = -EFAULT;
 			goto done;
 		}
-		memaddr = (u64)cq->comps;
+		memvirt = cq->comps;
 		memlen = PAGE_ALIGN(sizeof(*cq->comps) * cq->nentries);
-		flags |= VM_IO | VM_DONTEXPAND;
-		vmf = 1;
+		is_vmalloc = 1;
 		break;
 	}
 	default:
@@ -559,12 +546,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	}
 
 	vm_flags_reset(vma, flags);
-	mmap_cdbg(ctxt, subctxt, type, mapio, vmf, memaddr, memvirt, memdma, 
+	mmap_cdbg(ctxt, subctxt, type, mapio, is_vmalloc, memaddr, memvirt, memdma,
 		  memlen, vma);
-	if (vmf) {
-		vma->vm_pgoff = PFN_DOWN(memaddr);
-		vma->vm_ops = &vm_ops;
-		ret = 0;
+	if (is_vmalloc) {
+		ret = remap_vmalloc_range(vma, memvirt, 0);
 	} else if (memdma) {
 		ret = dma_mmap_coherent(&dd->pcidev->dev, vma,
 					memvirt, memdma, memlen);
@@ -588,24 +573,6 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	return ret;
 }
 
-/*
- * Local (non-chip) user memory is not mapped right away but as it is
- * accessed by the user-level code.
- */
-static vm_fault_t vma_fault(struct vm_fault *vmf)
-{
-	struct page *page;
-
-	page = vmalloc_to_page((void *)(vmf->pgoff << PAGE_SHIFT));
-	if (!page)
-		return VM_FAULT_SIGBUS;
-
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
-}
-
 static __poll_t hfi1_poll(struct file *fp, struct poll_table_struct *pt)
 {
 	struct hfi1_ctxtdata *uctxt;

-- 
2.55.0


