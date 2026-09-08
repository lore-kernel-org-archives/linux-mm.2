Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A958C79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 557F16B00B2; Tue,  8 Sep 2026 16:15:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508276B00B5; Tue,  8 Sep 2026 16:15:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1136B00B7; Tue,  8 Sep 2026 16:15:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E6E16B00B2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:15:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F0111A0779
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:15:51 +0000 (UTC)
X-FDA: 85191700902.22.D995541
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5041C1C000E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:15:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lbDwRa8g;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppismYwdrne4x7KodwF6y3kmVmoi42d3nut3iH078TU=;
	b=lQTs4F/hsyNDfWerkFpUeHihePyJl9JTmPPlWAQfp1BzFjwPMM4lZrexAogY3kul/NEnkO
	Y5XZiwWdA4FIUzuuUIDFfamIrFcaAbmipR29Z3PK4rY2r8vsQCUR1Rzi0L7ldNgB/dz0zv
	k+uid4pfPr7jjzRdw07H7ry0aoVqOnE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lbDwRa8g;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898549;
	b=tIjEY+/5h8o33JbpR/689jQ3rP0C5TLKH4gZnUqbp4y+jrWAuR3+lDx/WylAkYqhwZfA/7
	lUbk+Jnkyrye5sz4Kn3zdU++PBbkJXOe/TMS9KH1wnVo9qJzIQqwnpjn90/CKs7+ZCStp0
	jYHa0O6ZYTOOmR9Piiaf9j0QhAbhuRA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61D2E40B9D;
	Tue,  8 Sep 2026 20:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404991F01569;
	Tue,  8 Sep 2026 20:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898548;
	bh=ppismYwdrne4x7KodwF6y3kmVmoi42d3nut3iH078TU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lbDwRa8g8oSyfwfXZHZrOWwL7Gd3NQRwfPH8vDfGhP7oU4sQeNBhNCDbOcmJujzz5
	 Cw7PBIqcQfYVo5nMYl9iahJQJihvmCANm5T27TWL5AY+FLuJTEGdswZbj2qqcXJYmi
	 d916uvYFzHYuffvh1DF4Utcb0C6DdyUUufmlKpZLw6J3CgoAzadE0Jc7rnux4y/I9s
	 oEMQHbqS61Kpe6ib9AFJBFKCLezPGq+sSgepqUx/4FsBmnn+I0b2qCImAxaJ+fpcqK
	 zHJ7hEsRqofAPvcMRpw7b+J+wb9GMoy3qfZN6tR1E/kM5D5nHIzbo2iDXEpDJWdI0c
	 IGwes58ba5f9A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:32 +0100
Subject: [PATCH 28/39] mm: drop some redundant checks around hugetlb VMAs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-28-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
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
 Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2689; i=ljs@kernel.org;
 h=from:subject:message-id; bh=IRDOQ1NSUqnc+chO1D9dAVkYabHZJrZYbY1u/yAFj/4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG59d+5SRUvecp236z/qmyy7Ls+92MEl0OPmkqNu7
 rrJp4K2dZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiRxoYGQ7HbPy4VP5PMufz
 Tt93k1wV7/e9Yn1ddkC9xUIx6kj7tieMDM94nrM0tLcr7v2f/CDkYl54W/amNzvCYs/vvlj9xJj
 vOgcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5041C1C000E
X-Stat-Signature: rsogef8fuxx8jg7twu7uo9158mntxyuf
X-Rspam-User: 
X-HE-Tag: 1788898549-17483
X-HE-Meta: U2FsdGVkX18dtwG4ewUx3lZvNHj7OGa9CbD/WgpikTzG2XdM59U6jbpKcuEVnv94nFd9dy5TJpl1GyUpoXpLaWKTdcsc6+485qMpR+H/k5l8eJMqfRO9jcivFI3HNh4BtoLHEcy3PB+LDouGgspQmpCVgRykf4xFqb4Mi4xmoIrKXQLL0dWu/Tlrw6mlw0ZnAMVJogOAc3wTRtaiS65YjwmDUQK1TshiGWp5QhNUv3KiQK4LB62kD0saA6HXcHOIoO30Ckj2t8qpakyBwmdzqR1L7YYJveTcaOCalNB1rw3aQPIEL95qiTusrf2RUpwi8bv7HGr6FiM3r5H5Pmlp7xUK/84HW6/aAPjcO/B3XUZK9MuVflw9BOOlOmWCiP+JrCKpZwEZhO4Z0JfCYXWpzXCHWLj6sk0ixMjfB6FNouCCVpRp3YBDmG6DVGcbLZbvaoNJCv7YtcSPHu30Vm6knclAzMhIL55+FVZDDHlyTvX0kIj7MMC9SV3x/h/ZHfHgDONLluvhAkNMSPaz3COzEIenv3OpB6VbAbn1nPLrzf+UsjiZAk9cntP/1mumfB2fwnz8Ge8BF82pS0D5aupUuYN+NvWIbb5al9PYqA4BdteZKHAvWeUFuSeZSWsu0/BGGiTW/rod6oCfgJLZZ8CoHnWD6VmhgnZLKOnd2W2q9S+kLTzTJznRHoTHk8t+auspFVsxq668qVSyYIzAQ5UjSBRrQo2MM9Mdg3WqBFxkO/1J0mhLOeuIudozJWVkPjYQo3c9w4g+c87HUivluUQ8hTgdIYEj5k7sE0vrTStUPP2xHVe1DZiIrlE+FE1HIMK7JiOvFglaXAJGaXPYW8VARuUHWu/zCgacvRBb3dStiZLGtGKCwB43/p9AtQMub/+DHyvARMLyNinZgiIoXAWuqHDXvza7tlisXnwouZSFfxvGsYxvBgSzvFnTw2gc9nn5VA9gmmqOjZFR+stjzg5
 cjCD8slQ
 zK83KNfCLj2ESyXvpXkikauPk0/ebQGI8y56XBbsvoIPFwKsGXKOVOGWAGk1lbpqTgfhFiVPbMzwD3Rd3KVK2A+9OlUz/0eedv5KuL2gAcvQsTM+Iz1Fj+9m2FLV81OrX/wZNVM+uRgW5/4KgxJXiuoAVsGVpZFgQbh/sVnaVDXLRmDVLxiIqsePPPnFBnZqPK7DuB9cGAj0Bwn2TzPzzoWH48+yPImzkjkm0v89zRB86Fw3v9yqrRpICiOqOZk2DH/8x65BV1S82HNypyzNNxbPTZM0Nyzw2DzxnaYtLGl+NXNja+ey4mlrsTMzhL/P/yXAyXtXoyel4nSnA55xe+3Z4b3rYdFIn1lC2whnXXY1Avl6u/yIKDJb5oId+/JHomOF6LfabM+vn84X7jWHtuwj4SQZUJv79nVGry7mkKJFbiu1+Ws0PwNcggmos0gKdtLmxuaNqwc/3N21uztmVXvqhzEy/LwEohAAD4LpfAwJSQVkqNdi3PdNUStxC8eMtnPHrjBgxjJ1talupJ3JYRHdDyxUt51vfg+gELFCgWwcwIWRjMBqwM6GC2OAmLccwqJLY+cNB+lAhu+DVqjUigdU5fZFAGI9vNK1GGO51PcqCN5l14jinTOAU7JoZhNfLS1LHVnKOfjoF06Q/IcD4kK1GCN94qYfNjFs76vZwg2qv+/UX+AfuldQHKPSzn+jRJN4u3sPagGpUMxBPA8syjbgAWrDD5mTMhUqx7Au4OuMbi4SE5FORFoPr3+aKL9OXB1ezOnpBDweyNhdhC6pvtkJ9XSFXo/DyhX9achCV61zpT4b/4UW6T/Hv9PNk5gYYlt5SK8NJUp0LLl5mMcKq4iZL6poz/Fsxo/KCawFOPNBK/dtoCQzzqJu9JV4NV7mNfINvwy/1QE3kAey61wvzuJNWWvPM3vuZ9RgM7BeaQkbDL1gJS4SFeUht3a0UOs6mTQ5kJQNkHe/2eindBDb0ccvtFYrL
 mv1OR8cv
 9kn1LpvS4QPVMJVr5Tn9xocfWqs3gJ2isnJNThp0Rn3++j3qozY4UF6aoXSMMRbd9kLPLlhXm4Kn5YDWHUt9EGrs++nCCOsijUmnQn30QL7DPJ37MZIcgXDFvnEyRy+qCj33YOOmLlVnPacYPygasHQQ3/pJRNN/8HYN1FHOFiqPJgr3ozN0E2pAnVEAKQ8b4tnYJbPYZdgwnf+9veHz4bnE/KzNArDtgrt+Ad8fGxhKgz77zjpUCMFTAFoNHY3qtzMP7UJiMrsI/Y/AunSNy9jEs+qhfqISC/8h7KAj23isgMUq8+0QpFjzZEnFxBLwPLlxzlmLbO2D+DjY26NFSh0pjcfKhwOhW6Qgwvl1uKw9bryljHiEN4TWFMuFivasZajoSOgm3FHR8h0kF9zqmL/x6TtuWDrsdiDaQz3mWF1vygMrC0LZM/JiiCzf9N9JjC2IYE88Fbmptq0Wm9Xe7VPjpL/RTtukrTOXUBxAMTvQtYXI1d3XQkPpNTcNLii61t7EOTeS9P/Q5E3r0nc0S6NYIiWv4GbIg6kZ6doTJXXkhZRj4/pFWduWfbihPXzp2/NeSYNrqwue8rKZGKPsHDWalZ3+1VY2Ifv3jp+ZlVAXNeqkOA6oMDNQ8xH+/pg+g9D/EZ1ioDABHQojv43n/BclS9RdexYug8AP7A6AZ/5IMHEGg8rDrJ6ZxyLofnCFfvCJKvfoUdLmXu7LFsM8CTCTDepVc5XhzHVsXnUTLjsisg+Q5c1/mLdk8Dav5KF+5Vr4B1rvJIUKiluZ9N3toV+Jc3CoXN0Bq5PHH7U0VcDa78F/bLa9y0OwqBA7sDCLReoFjJvBwEPMgGXKkjNxCxPNB//C4C6QqBajllYmWbW9QYOhmYhch2Ngqotk/RcY4IX+vlp5iqJcQi8TSIJTuMPCosNNgE7FXJi+9cyO6mY6Mvwfq7PCc2XSGZtzsUGcArQk7ndalboTeoarLI1HZUDo+Oyjn
 NcziIOEH
 rpgC2ZisKKYw0L8Dki4dF+N/Oqo6t0DRYS3cSt3s4sdyhCXNidX0GMhLHT/+QS49LvHWFBTdXZ/pY/oLr5iVuST2yrqr+kqYf8XdPPgw155VBbfstmhDYyD5J/XsF0gEmPGId8IzzhWYuzstcPf7c3sT8EbUW8O60be3sLu2VOYNUJ/XM7DAtUSvJHW15kGOyMW2DSlTf4G1gexuEWkqUpzHbEmZRYlp6PKdnw6pC/7uygM+CIvGOZeQv5vTxHSHEO0pRAuYyUFeW4fvA1elOnZDW9WYxo48fj6qY6Oj+lB3OkJ7nFlmejlb7+caq2lYWc1nA+skXTqMU/wOwViFBvkt0IUAGwoiClkz2Bv1WYFZ1ia4U2aUiCxRE0+LRrA4E9eoA3sGqCCqnTofhY3u3qP8fLtSYLmEx2GwZhcUXeTHSx0XLbTcRpbrX1FJ/nTzs1ZOa82VU0bkG9J8fuBFW+xzeTSw1Vr4bGCIzJI4z8NUOSgYDxZ8GwvEp5qf7tZSdDiTc5DqUS8eDKEaZS88Jnar6IMPd2dOm2UhZV38WYF/cK6CbrW24lZlqARCC6j7s6jrEgOsjTSYSEbxSDn/IlnSaSKNPMVHPcv1M+fmn6tLWJ3g/98bHD7kcwULC54xYPoa8lXp+2rNYF1/yWnux7q3j731+7bcxMix9/coa8u3ga+F3ZMMXAHmzxH3S7gLWlfkByPFusePDdX7shqtrVImaqBVHlVNpR9FS1RK7SeMfnkZ1VvV/i4CpHLeAxxUvab9xF55+diCjFf0W7E7+F/V7L51OhgdLK8HYIwYN4LR0FzYCmPPs0NNnK/W+1G9fmrXrSyCTALNte665Lq4r+aIptwb7YSlKQQP0gk7827a9wSbU/07P7uK2AmecUqhILJcQIU5G02VzFuH6An8Q/Gw9Gw/IHFoN1d8tcFbL//YognCmD6JGyHw58c4Utr00kR156RFaGYLHRkdqxQMezuxwZWuJ
 BmjrCrFo
 PDwvWbvz/rdwAac/tYlhU1bMorUhq4soIFh3EuXnXWTFPWoX8Izg2cYswV/sntNhFYWCYGDpXpVaD+fpK1rMoqPngir44tJFMJnzxgynbqsDaPjB9uADSwKRC1Tzn/jbNOson4t9rtMUrupzFqV+BuPH1Fn+E90i3I9beKel+njRxBOb+6HYasIaiPvVrDDS0TgFUjXgEldQyFNeYWsaxeEpQ75djyp4G8VEpx02ZMAmvzmgOZy0FSYEqys/wRXu6lPGf5CNvEgNAh/l+CYISO7xV/YzdfPsIXe9qsrXGoww==
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


