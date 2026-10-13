Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9DCCCC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB73B6B008C; Tue, 13 Oct 2026 11:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8EB06B0092; Tue, 13 Oct 2026 11:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7DD36B00B9; Tue, 13 Oct 2026 11:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 974806B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:12:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2CC39A0CB8
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:12:33 +0000 (UTC)
X-FDA: 85317944586.07.FFBE676
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 61DFF4000F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:12:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fE8j+Uae;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+8Low1WFTt4yh1DePV0dXKzvnJlhZgfafzJ/Pukt6A=;
	b=PqBCL5j/jRMX6G33fBWjYDZlNekvihoICsllerJxFjgtkRSw8yhl9NmA5AtvH5P1VERH6n
	cfYKGG9fmbHL5AksWsitwqyLhvLbSmSPMjYeNBj0/UFQrGuBi5EKMd2uBDOA/XIsqVD9hq
	PdeMabj+KEEecpRG17Sr5PVz2tc3EW0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fE8j+Uae;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904351;
	b=TwVSZsRSvz6b+D/xyKeW5f2ca/J7qpsTEMzN+QIuX01TZRtzXn7EkSTyQiDM0+9ozckpHp
	FFS+nJhuH5snkabjww256LqodiLH9uC1adBCl0qTZKp8tL0+vuGrasRF/cLL7acSkb3JrK
	pEhGLKlBC6Icmgm7ww+sr+qZmqm9bTA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4A4F431D9;
	Tue, 13 Oct 2026 15:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6F21F000FF;
	Tue, 13 Oct 2026 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904350;
	bh=P+8Low1WFTt4yh1DePV0dXKzvnJlhZgfafzJ/Pukt6A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fE8j+UaeGxQ+QGyATVi9xu51YnmjPWaSOWpYqjVx0cTYdBh7ShnkDmYnQd3oUKWzx
	 jckseIVWunIrkiE58LcY0AY4tAUsFLmt0OfUysG7s6psKl55SJHQm+w8OyR4Mp+yeX
	 I96Uu7EHuaoRI6gYI4bqKRSW37+VgZsRE7Va4Zm4TNxREgbQb69vNUhMdh0+FMcM7U
	 q9SUoVGFxvPktaes3wA8/GJdpVafXQiEU8xHZBZsJqqcb7PLrysqrceisCQQNT9qif
	 tIzcGzpCjRG7Lqey5yCQ45p32yW6iPp6lpPflBUiAwa4M4Ok7cqwwFtMrjRqkN6FiP
	 co+jjyqdCqQEg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:52 +0100
Subject: [PATCH v6 12/39] selinux: reject writable opens of policy file,
 drop mmap shared/write check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-12-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2031; i=ljs@kernel.org;
 h=from:subject:message-id; bh=l/++R8/n4xjCDK2aA9rF98doLh0BQskyZb+UQHltnWs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZwwOHHzdbOygPDEwpjZV9+8bZ26suKx7/LpJ9dUP
 t816c6vyx2lLAxiXAyyYoosz7+I7w8SCZvXecHfDWYOKxPIEAYuTgGYiHoDI8PKmX/stjML3Xgk
 flfodd7ukDMT9r42OMRXVjQt/pG0d7YMI8OGT/d9pW+8PjBJ4DfHQabFXjKKvtZG6Qdyl1vFub4
 8zMADAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 61DFF4000F
X-Stat-Signature: itpombrudu8xirzxs5u93azho5491sqs
X-HE-Tag: 1791904351-262348
X-HE-Meta: U2FsdGVkX1+4IawmWUli8z6iUv0BGmy1AxEst4ZodsEWY71blSHNRZ6KkVcM/2B6hIe11mxCLzizZFTDJCytjvXKeQe7/yRYMMgJqSfN+Sa/7wd+GhRyk6NDW060eoUbI+AumIHVwJA/lkAhqPTBgEByr93r+D1lEoagBhn7asSRazwfENQNmBy7eV2l1TpEOu/yiiSB8TmjELGrIkMHuIBxhoCdlyBjRB2LGDD+vvB5N4Fh3OpfgPm9A/kn1Iyml9Dgm6GDVxHTPbCarLw9ew2iGNCQa6Tf7iJ4OPLl1TDcsc3LogQraiJLyrgEjARYqTqVpqi+2nQbwud1u8pEmAZeA7GqA6Q2ooILnwo5m0CtJdj5l1jV3fwX0/tlRlMeHMteNvHRRk+2ZJwHqrAARm7v9fi/DMFQwuaN7xZyidxKmZphaC/20dGDgYrLpggcKZS/i3nDcgwaww/TpBFMcapnXog2d/48pRslMUw4YpSxH0n8PaIb0F4OhkjkKF0qCvKoDHJiS2LHLOFIfEd2NtWvst/5S4hUaSalggR0v72OnzcgGo2qv1XsTmmmEnzCwZFx/OmgDJh209sTSg83ulPdb4ZnfV55lMJApLxNG7PxTfbh8uMYrI2dD4i2pjR3uD/kIrvKljzXLE7opnqllmhNObMcJ/PNYm6aH+Q9PFSwQBZrMDMoIMx/ejM1qrcGbJM+ds7HqKko95c55AgVa7bMEzEhekocueCGcBoNE0nXZK8d4wyhZCtAlPge0mFms2KZILSVw/67yPeedAo3ab6Vt1nq6SYKCjaX1NltNOx5RPy1GHSHeqnroF4jMw/ukl5zSWtESARI+F5H/EDABulInUHmzOWBLsiGa9FrnwTXl9FTc2GFlIZ5C40Lk4cq2B9GD29v03cnUzFl9AfCS/qnqW8XOovr/OvJrID82qtq0JCdgdFNkN37LWm40rBnCKt7GepHPOG/BG/og4G
 dDB6rGd6
 NI2nJRMJD9vfiZxyWPG8bRIMduRXUWAv9MPumljgBKUgHaTwRprVykwuvSBNGfoxCFjBDcChWPCkOZPGojw+zf66ymEriiy1Uwz5Eo+7HPrqo0c0/TDDHm5jK3Qwd/zNlHmFpLCkD4EsWEMXusExC/TzCWvpPENv/tAYgc5DAD7CRZmojOabih6/Otgj5T87PmCIi4/NdsICkZKK7GvUomhsLOZnWkOAQDYM+t25eeRf+lg8dW4TC97Lex4XCDst0Bo+kRwskDMfV0aj7fK7uD580rywFf6nm9m10sQNKmR9Gzc/y6F1yj91hbMNplJ2/UL1Aels2vwcLmXLsqm9NhhuAcOs10ZXXRwPMiYVta9vAH2VnGF3fOafFvU42rt6v502Ul4ZEtX8LHyjitkzRyDeHtAOuOKgma2IIU5Q/1qRtkOHVPgZFAexL6jZcULyxoGSAnhsN8IvkGJ1HrP3pS4nI8Ot3kWUL+p72yW3ig2f+XcFjbGM34oGPeDGx6EVDQ61+hEKiTDSrvTWv/5y7lk1xE4Xu6UUveJqVuaQxebKBunVOBbxjspdcS/kKd/X+hPJDSgVYGQOvyIdHIeKLthP2ArR60X9682g+WYC14VbJB/wtMG5gJe2+wgQOBsa+pPr8N1k4ntNeqv35lw2P9az6ZZqSPa2b24Uteo5BuviqrPlrziybq3DYfc6j9l94vZMNL3GcAj98JZ+E8m9FMkKoVkILBV4yr6iSMM3ybpJYgIgUicDQC1AyAJYIFGwvBBcyftz4djoBw31DzD43JIieG4Zh74G6BQRSRsJVI1utwJIo42dm+nG36+DlnNWEo9OHF2UFb/RHR+Q3eKrg2+Fv7HaVxZz7Ie5mSO5PzGiq/aK7n8C4l/q3UpXF6XSl1JYDV4L1/esHNMGdlFLvbBAJHI5dhDwiNj2L7lw8ZbEbFfnKWd4HPtmLxT6hP9/kgJkxrsLu/WcgaHDPCigVUqfKlBFI
 5YoqNxzT
 60Ee9qbAcI90zFDxoCxhPJ4xWwaXL/Dhq+aD9n/IFEljSY1m2bwIDiNr4T92kdgadwAqRu2YXgYDd4DcGxWAMdOHxORTwNtWZMCyflKHbT/ySEOOalEnY46+mjEANiDYwONOZCZsR/HwACpI3BMxELw982Ft+UHsdX7CT0XUU5g1YhaodCtqeowoIH+HcnjkKamIqScsf8CiuQJgYz8FWF+hOsZZv+wKJkMyu3lhMaKcKRjaoBKVz9m60Ism/CzAEHGeDeiWKquUwjBhG+d3UZbdoeT75+THnZtSPa0suw/4fjTmJdmeFCVrc8LIYLZ1K+tVlJ36YVMgAKekvbwDs2ksi/yHGTyNtMek8RX8x8B6/GbfQL5oHjZrr8CrgOAWm2JULNojC8dgZ+tOMTrOTa7GcIWV60MnfzKp9FU8J40yoY+nyrtF57+0aSxyLMkUifBLKcSaMscDkyCp14RgS1yRLKSHmknQHoezhxkYB9+/g4uNe1Krek89Rb0XdZJvX2ywR6gd1BB0MdSlTjNAKZb92R15haqa0czj6EytLk7CwWOGiu0/1n8xMkPAA89h5e89pNvi9OeMPi/iFgKC4oGXbk/qPDlxG6MREtoyk/CcTy6+yQIOGLGVTASdLh9W/TJdlF+4OfyNNcqU80V4Cg1FfKbp3f+S5ib5ByTvFSraECAJho9dH/etadzc2fEeb/UW5EpFRlqlRPjcEQN9Izp9LMBcreWYl3l2FX+E3A49f1UWYle2XNLLNuitkLQpMBMZEeQ3etRBpddkm76kNcq0jnjeiCsiol0Y3UeCECxFkQIb/P+zpRQgg9cyk1PN2A/VZI7Gg1gtDogEb6YZnqUtPlsCX9sI6bqVVHY+GE6lyV9r+3wer96uRNw1CqNQdxbYWnXX/R13kmjzuRQuvXBIS507Nd0/aUp32IsBmSLpjF7e7R7BHCFjK2EAPGTyOCARpzqaD66gMbUh7ymYxaRTPvQvT
 dGDiFJsQ
 zibKqt/ELrD7N2mJG0PhVFNtSQ3BP0rAuAYYTucCE90J6wmlVQOCPf9mI7nnOlIvXHcQOKwBWQ2OAKL9/tFU8VlSHMloILpxzlehnvQ8SXjRMP4Jxaesuoygjj3MI+IzvgNNSledaFFTdiokrEjmJKoBBarNzacJ7vfhwJbqNqWqlEqtVnlmI0HKU/qyep4qKVJfWZCwfGLlEN91ZbBcO2xbQD4Eu8Nxd4A8AimUaQOe6S0+j0HUDbfi04fGvhl4LItSbdllvGS39sXUw7os6BWoJC+WUXlZjcQ1BhSGnjrAl3MxsUNhPau/lEem/JdVwCWsei6K/1JsKLPnzyCNCkApigi4oM8Yby1KK9hTfx02ihAKMpHSq+uved//5C4tHmRg/n6OInITlK33cRrxsl5QDFIDGWNb6s4HWGJhPsjiI8WCxsBP03LSZ6LyuYVeyDVm8WbL151FLpG1+m/Hj+5/6BW4a/AKTdHxuCa6Ll7iDlgFL5LsL6tc3kUaU3leomvWu6lmWUmeGxDv6aIY2qLrHGVExptrkCScJJenzpmlTiAHvLyrT97oD1v9WQNyagM7OATDrIuaaaQo8t3vKPsw4D6ba59PYiInMIr/Q2aLjpcGyIQXLry/HKW+Q6jxpGITpd03OsjCFXBRbCCcnmmyJZGf3xjvukzuEJNIKaO0tI5s10SPmnLPBAuX1NjNMpaVEKaf/mY9iVkpwGdSloG0Xf1s01ET0g3IL5tj1ALFlYZSPZUIQR+DYoKdLpUjy6/QMSlZ9f3/HD3BNi77OCqK51jwbPMjq1r4ptD7q79rC0a5LiFuRjaqar5IRSdHhj/N4Cj/o+LJiXYbY6gx0DEH+49v6wWcYwq68iOcPgl+udRnSEHcTDjwk107TU2OJF9hDWv6ndVTHDi/FLjtirEGyfac+oW+05O3uhsxm6U4FdOoMKMMOc2zoAG6vBtNj0KakzPRPSHlJLL3w9Nf5YtiVuhC3
 IjghfRa0
 3jZNgOJFzE3jetUUPT/zLL1w06hiq1Txda74cRCRtKpcY+PdmkTcSLzx2IyzAWwjoDaUrNVm3HZQn8YOTmVDnQdAeF4GgMcbN/T8BXxVzKtYmvgwe+f2wIXFirEZTr2S4DpHZ/n0TYuhO8pddXrYN0KZ835UAhwDBUu5S3cjMqsLZ0ufjgeWw5A0PelWCvHeOORzPwA5u2UicXsfLPoliTDQ3OVRefGeMIlAI3W7vJRc1yIL9VXZnv3mxZuPqA0WB+F7BwbRR8joSZXZQiqHblHKS/EpjLKS0izvURZolH7RN6njqpmg7k0ITAlsbWhNxBCT0eewji1Af+P+vWacR3gnUpapXc2+YuZb4xbdgkUS/Qb84SEDxjAvlarsliq9PsU2RwtwaUMF0e/VJCFYG3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The policy file has no write method and is exposed read-only (S_IRUGO in
selinux_files[]), yet sel_open_policy() performs no open mode check, so a
CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
kernfs does.

The file can then never be mapped with FMODE_WRITE, so do_mmap() always
clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
check in sel_mmap_policy() cannot be reached. Remove it.

This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that is
neither a PFN map nor a mixed map, ahead of the core enforcing that only
such mappings may do so.

Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Reviewed-by: Jann Horn <jannh@google.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 security/selinux/selinuxfs.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index c7d91476971c..545a6f89f9e7 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -340,6 +340,9 @@ static int sel_open_policy(struct inode *inode, struct file *filp)
 	struct policy_load_memory *plm = NULL;
 	int rc;
 
+	if (filp->f_mode & FMODE_WRITE)
+		return -EACCES;
+
 	rc = avc_has_perm(current_sid(), SECINITSID_SECURITY,
 			  SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL);
 	if (rc)
@@ -424,14 +427,6 @@ static const struct vm_operations_struct sel_mmap_policy_ops = {
 
 static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_SHARED) {
-		/* do not allow mprotect to make mapping writable */
-		vm_flags_clear(vma, VM_MAYWRITE);
-
-		if (vma->vm_flags & VM_WRITE)
-			return -EACCES;
-	}
-
 	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &sel_mmap_policy_ops;
 

-- 
2.55.0


