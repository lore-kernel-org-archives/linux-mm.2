Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29725C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3359C6B00B7; Tue,  8 Sep 2026 16:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E65C6B00BD; Tue,  8 Sep 2026 16:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AFB06B00BE; Tue,  8 Sep 2026 16:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED7416B00B7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:16:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87B41C023B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:16:19 +0000 (UTC)
X-FDA: 85191702078.20.328C4FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9784114000F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:16:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BIny8R0H;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdqrKu8t+WYJ+ouEDCa9SDonWfa/NDTVSZ6bOn7dzu0=;
	b=LVhNFbzfsmfk4nBeuCZXwAy0mCZ8qC3k55RgsiGnm4Hp5QLMhZOay/u1cqpT5a6MU9Xiob
	JgHKF/Dkbjg1s9Du+VjEVH3b/TikErstEaKB8MrCI9xpEws0aDx6GZ5lna8/vcSmm8pYrv
	hVRaJB+4M07Iped362x/xYufAqw88JE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898577;
	b=T+d+haPGcKUdINkk4x0t9BsnZIq0VzLUe+vUvIq1NO5Eyr4XzRosyRAPdtu7Sg4AqOwKYY
	PzdcvV2SDTy+1B8SkNyD7/Toh456vWAhiANZidZXRKZQligiBALAcmHveWrcu9hlWn7dTO
	ONIZ3NcYlBT2uNadJED8G0kwAlkIXuQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BIny8R0H;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCC9C43647;
	Tue,  8 Sep 2026 20:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5741F00A3A;
	Tue,  8 Sep 2026 20:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898576;
	bh=pdqrKu8t+WYJ+ouEDCa9SDonWfa/NDTVSZ6bOn7dzu0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BIny8R0H16xJOceHNFcowy6Hr/hPn3LpxBR3bBmr4ZsMC9AipqSk8VrHCGZMG90j4
	 +rVBnsAk/T4cv60Ej5f8N4w8zpucQ/kpjVhsajnXqYy/eJn98Ogd/N0Aq6Mjfn3vgb
	 YvxmZ8zyRYOnkjzeww3CKnk+IP7ZU4VyRCnICMQc5STFGwsOeq2zUB1jgb6y0Xedh1
	 DCKtBeX7Z7Zld3RG3/pPTQEfrE+z0+SP5og2sTRztF2Jlg7Rljt4VdSbtfiLJaH6Ul
	 WMqVFncdOGI3cpq3kl4nMgr2YmIhGLFyxfSzlEXpxv/oxYHx1w+q3ZX278KV0w4la+
	 Gz0T8bZwmz9/w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:33 +0100
Subject: [PATCH 29/39] mm/madvise: update is_valid_guard_vma() to use
 vma_can_merge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-29-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1939; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ggho2nxN8+GLmUxl2AhYwXCAN84J7vCZcuIKKsWQe0k=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG41r7miprb/jZSCkXTIIZ3+TOGnJ3YKTDta80Thr
 Ov9BZ+ndZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiDkyMDFsWcE/vDbgY2jCD
 R+ZzzP+HT+4KPvb/MW3p7El9O7/qF7QyMqyeKRI3OeOiz/pLa2Y9miPUXGz4+Py6Wp/gfNNLS9y
 Pe7MBAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: a3rhgwi8oqjrebewxqp9tpi8sdsxipff
X-Rspamd-Queue-Id: 9784114000F
X-HE-Tag: 1788898577-490534
X-HE-Meta: U2FsdGVkX1/gKR7+mEJ1S+ffIv3Wu7MwAUKwJuuPTDwBphEBqlTO3pPGSCA0my19JoPxM9jpnx/NbDyEZj5AWQUa4mESdq4hys3mxlgocHMRtX7/6FEHJjoBnmyvb9VK5xVUMah1zyVolQ4/6JDNLSNCSYPvgEFzRkMbUGEb7IAuQJvkBT4USFAxwJC00Ix1kfS7hO35bAZRNxqd3YDDL2nmWRdRmPA8seydkgjRhQV4EbC7JdWTU0dapQRLOmLxP78JW1u2R2wg4ObR3IhMGFV5kdFuXuKmwuKgAwlXnXE8Tb4XO+iN4Xpmkp1oAyj/5F6clS0SCX/XWLk2O6BR/UnQRTyDVewgCt6iua02xcM7CHLfY8i4+Kcy6Pt34PzwAPUnqJv9ZPM3USwz5r3JOZjHcOt+cLVVIJ205rX4m6ZlXCxSjG+EQ0+kQpA6fVPT9EvTwKBxPsmbvoQNZShNkxLgVWbfJk3iKCiiksUC7AfiogwcFy84wEEcTLDcY0/CyX34ZvvmUb3Pr7D72nA5qI7z6SFBa1xsuK3xbuXd7UD9nmRvASWHSQtAVzoyOKocRG/hC4RrXYKZBR7E7cOChpnDddsAn9j/ib9KBeLYptQwX+FVyi+qHqJNnFqvnxFZ3NHclz08lBsag7ZPoMBfi2M2Gypte8HU62xljrZZHIm3UTp27OT9rMPfZ4boyiQfAOXD9O+ahhUmRUv8KKWj+7EV/BVXo/4mSRLXMuSD5lgCu/ZPB6T3+pu46Ej+OWUjbitby1opC2AyZpFER9XwcU4wPVXe50qBXMJkPibj5ihlNometOEJdE0FK7RcgrhQqJyfWxkAy5zP2ruhNxLS5LL2fmJlG+3t6eYu9Jx0rSArVusyKdJnVwNQc/ExdOqKud1piAPll4JtjKXUzmWxs7U9NjU8lFDKW+oE2pqit+Qf2B0gM+5aAQNLCzw1RHvmaNJ/7A43JHxulMr0b5Z
 cy5NALKF
 hI8utPblVXTD3ay9P3NMPTJ+rvPuvkMgHJiOM0M7gfIDbzUX61bWc25dIzgjDRodOj/5e3/ImCJyqKPj1llXhTcIoe5GiGFTELx9zjBuYCP7sZL9hEjCPB0w57jL0j8AwwJJESD5s4twSyrC1Q0z3DGqPm226KjAvqp4nf4qyAwCbY3yFdpMoJ/asmupN4Sw3vyzG6w5uTmuQCH3niNwVFiIqRN2VVImBBJsLxdIWbSoG/SsY08FZ/puBoPrhMA2T+lefUGr2CdJ5wLlA4VkMITvHrYRNaHQMMEzw2d4qpeAKTbSWr2C9VglOxss9PIaCHwlXgeofGEL3Gjui8u5KuarT97A+FROUe5x4EYu2SGgu/Zn9QrO+Ek49HmXcKRlx312Biaw2xkzw5zrK9YQnCLzjT9f+oBA7IatQmTSzVoH8vn2yOcPkyWipnjjM/TOJYFU+cSi8syzE5/YT1koyAA5cwTZ2sqfmnTjXdomHWI4ekpzySlnEhxncL/ZmIdO53a9PwhIbEzmvQatxlwzr6R0JpXOprufy1ORfUWVn53+JKDksjWOJRd7SxnsDliZej5+ekhuEP40LWnLFrOMTw4yUyvE2sqVd7tezU+XCNaFUsduAboO+ca+Te9JeNz1LJPr31YrMo/OVAwIZRcoDFa7TEQS1bv+9C94prZHtDqewzZ+lAIQK05R2h9OiEPd5CpQdsT9vGK7ofCbnJ7B1eQOPj9uk6rvPWKqWLF61RTjiAtNZ9Qcza7dXnemfQkY71Pp4Kw1SNThXEm2EHA0I8voyr0pxlxeHggE4dTCvz/WczJdvMh1XS3/2s2hgUZd0yz7YzpCoCuMpuixl/QonGrL+ThjU+K0FKI8uao4IlOEsO8wBBYiEa7KU+SvQD9JRQ6g4VsdU5JqOLimvtuoZYaBohMtaH3/jBPq++TFGuvkG+gtSkLmwc1qyC4+QfahVFsX6n1qrDqq5Yt6KKZmLizf9LxVD
 kULxZgV9
 oUaSjlNBwMfYyKqvP9lmSgv5ZTyeisM6S1upG9fga+nXDZYEOmYWgEO4yUniUsd62QqokGpvuB14CYB6iTibiBYD8q5MTi/z4cG1RMZM0eW3FWu5z0k3mAMxTympry2TG6/z3kfebdpjJeNlP+29zGTUKsznwRtdWAop/9iKKF/HD34E7lmhvw+0l+UFY3Ailo99jVhhidc2sEgHEwWghZGFrTzbynHIaLL2oBUJgR+ZFZHD3syTAiXJ63o65UDn7fSQ5AX4VfHPqhIPOtQLoTda8Ad1hLP9QTR8jJ4YEBqThAyN5IZxe9M9sbJCrLIz2+fZTAOT1VQ9VsS1hxyxt3txSMHgVZi6rH9Fxw8aQzNQOngBnhiYD8JmFtRK1nRs/mbJ8KYAWdrPuomZJH1oJrES5Q+Uf3R3fPF7KbjDUmHqt4BrdfFSwCOL+9FN/axWPodoX4gOSd6a5bmXfSUBifCJtbgK4cn8zIyJ7KN/1qvPsWFZvs0XfZ4eqjrJthmppR5QT+EFwVmOFuMcBm4d2i7Bo48AnDk3UsgiAG6EnIVnzE0T2aARjfho3RKj8mD5T+ultJffyC8hCB9C7LawGd2TU8HxuhNc077ItF/z7h5UWdQiyAhxjJpkbK4qSPupnqQXtKH6GyI8rEzVV94rdTzfabWuwa0UAkIyvdQAKvCJDxMIhYBJKjqRrogauEXkLXhwmuH7VKU6VJe/Vl7HK90ACnJr2iwIExwqavJg10T+BepkwY6oEwIOWbfnqyiOEq665DniZCW0fRmIvirmPrlO3t+/frxw2X7b2qpmwzYG6Nfi082IZQU7pSa+Nok4ZjpqH+5KiF83B0hqbKKtaFkS+yR2GSffCIG9RzlEGAtBHUXCNs8E6rPkZLNXNP11gEzYbeTZ227geP2i4m+rgHesGGaS58OZECD8lI8tgD427/4YdJOEdafE8y5UVqMdSjZ5VH3eOew4hKbYD1/5cQDz4eccG
 LZMUk2ve
 ww24UkVobccYH3JNaRyuXwbimyHsTLu80Q4gTEpKbcudVHU03wFv28G91dihW9x/pGc0VRSThRm8veA9dtR6KDttlpP5thImbjTf8Soy+KIabYQScLVrFapDJU8TKZ+TNRG10xmL1OhDRNbNWZbwGGdLatucFVuEIrmwvgrGkPGqUADAgrqu8LZRkmNxe96wkhiteLCvi+uMfuBY2WCq8fPxeizve2xN45SIPHaB2BfONG57PgLrphR5pxPjswnQTVcRwqKR6lW13jvLxybq9lrf8HejSAkpcM2JjYh49EvEzmwVzO3/0hgG0hE5SlELq7o9KDb9SptJQKvHwKGNpIuP1eg+MxIVBG+cZK2tlt8IUhAsY+I3DAK0tguHtW/uJLfHQpp94yNHd6j6AUMqdUfHzNrDX1uMaooJJccvf59d/2Rw1XdkCTbIwIp1NZRvIescEimjkdzo33bcPXkXXzQJyRDCP/oNN/L5wJGgRZ10awiO94DgounlJBLp2V8AFaBBd/ZxZGqZLhTBTqA5Sy6BY068Tf8kY/SgEgXP8Yj04pFiCYd0j7lBLjNobdoZa7Wo2MNkb2A8ipN/5HQxtzyT8YYfhwBONuoLbks05Td/ZEPar0wkZdh7CAKzdXw80WLQ3n8Ga7OVABMuGAZie1joQ4Cu8h4N9oMB5GkdjKnn76aDbWYLESBN7o3OuKMsXXmE2NiOkPCFREzn/MY/FyqwlTz0lhytf1AgM4/TAI8+THKedLDfhLAoGlwPrZAk0IkR533mWF4pEqTBbLDXvPjyQsSs4pnhRVTqe7QGdvtkNViEAMpwOJ1rShN+B59WCHVVRe2kwkLmM8IMymWy7/u9AhZGHUetcixA5JpBQfRhHFZ9CEOk6l6JXJ0WnXQ1vKQWDR/wXNQjyy6csjgZzOyqarG7sEGYji4wb9SNZPpKcX7oKAKKV6iNuC6W9IIjyJcA0/kW1ag41vyWU6hzWmhWMfai3
 CtF/2TYb
 JMIV0AQ67wIjNYVClQaQmC2RErE5HoxT2hrpo8sJJsVgMsVitclNkLHuYCDltgg1n1GQAennpWP0f1IG6I3pMps+zyKz3ycXkqrBZMr61Bhae1SEw9wIDzP/NW/PjYaWnIORC9ebkDaX4YomQVkuk07pZR16865/oi8epvNyXNH+Sk4lIDvArWstuiCbh7cosgFTzuk3XlQcRPO+4DeUv5Fo4uA8wccvwKV/8PY/EHzqnQxfsLHod6xFFq+Opy4lzh+eEQotOvTP97zObxK+A5rQlw1QrjBZ/Hmz6msUpKM2psYudCjHyIflkBRLCh8U5iwP5Mhw/uU4CadwkuOV+A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We currently disallow the installation of lightweight guard regions in VMAs
whose flags intersect VMA_SPECIAL_FLAGS or VMA_HUGETLB_BIT, or
VMA_LOCKED_BIT unless allow_locked is set.

hugetlb VMAs set VMA_DONTEXPAND_BIT so this was already redundant,
VMA_SPECIAL_FLAGS already sufficed.

However, now that VMA_IO_BIT is only set if VMA_PFNMAP or VMA_MIXEDMAP_BIT
is set, this check collapses to being the equivalent of
!vma_can_merge().

Update is_valid_guard_vma() to reflect this.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 2db11c832d0f..d0b14cfe38a1 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1055,19 +1055,25 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 	return error;
 }
 
-static bool is_valid_guard_vma(struct vm_area_struct *vma, bool allow_locked)
+static bool is_valid_guard_vma(const struct vm_area_struct *vma,
+			       bool allow_locked)
 {
-	vm_flags_t disallowed = VM_SPECIAL | VM_HUGETLB;
-
 	/*
-	 * A user could lock after setting a guard range but that's fine, as
+	 * A user could lock after setting a guard range but that's fine as
 	 * they'd not be able to fault in. The issue arises when we try to zap
 	 * existing locked VMAs. We don't want to do that.
 	 */
-	if (!allow_locked)
-		disallowed |= VM_LOCKED;
+	if (!allow_locked && vma_test(vma, VMA_LOCKED_BIT))
+		return false;
+	/*
+	 * Guard regions require a VMA whose page tables are managed solely by
+	 * the core, which is also what merging requires, so disallow any flags
+	 * that would prevent a merge.
+	 */
+	if (!vma_can_merge(vma))
+		return false;
 
-	return !(vma->vm_flags & disallowed);
+	return true;
 }
 
 static bool is_guard_pte_marker(pte_t ptent)

-- 
2.55.0


