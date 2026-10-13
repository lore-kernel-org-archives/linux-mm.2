Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19A6CC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD2F56B00C3; Tue, 13 Oct 2026 11:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B845E6B00C4; Tue, 13 Oct 2026 11:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25496B00C5; Tue, 13 Oct 2026 11:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F19A6B00C3
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:16:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2951A09F0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:16:06 +0000 (UTC)
X-FDA: 85317953532.05.D72605A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 00EBB14000C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:16:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oXRyBlwb;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GFhfE0EpCejkYMfipk7Q12g1VtbQ/nJQw01XCYAedo4=;
	b=HFe+/dNQ55vIQRDZMv8iHm/2Rw0GO32/vmEzXClrTdV76Ts9gYTAwBvT1VtFJxkbmdeX7p
	WwICUNn2zaRpW3TqOewQfqljuha+Cjzs3pf1fvNxUVfZ1UYeceUEb1PPvupBmYXT0HFFWp
	MK7d2JP5ngaHCoNXjeahB7/aGrFjdYI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904565;
	b=T1AwBKgd3bEz5D6f5A182mp0FOOqug+I0VJ8PMKcXUch3+fRsigg1ViV+rSxQNftaoYd0j
	ZR/22CFTW/GasTfqnCRe6H/dyRevtmqhyruynKyUWkamA3955h6j4HpwdzUD8Z2btg+UwA
	c6WGJ+N86gB9xwmnnhyiIioFknlsW7s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oXRyBlwb;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 820DB60A5A;
	Tue, 13 Oct 2026 15:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B441F00893;
	Tue, 13 Oct 2026 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904564;
	bh=GFhfE0EpCejkYMfipk7Q12g1VtbQ/nJQw01XCYAedo4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oXRyBlwbANCVnegp8iY5cvbAabzXfj7uUWG6HhCOs/m2gAAg9SHQKtYTIXLYZmhGU
	 PQ5SLGPgKkNbAUAFxAFzfOy9nOM5On+4vw8QFPdcKNuOiJTEmrNOOQIN7oVMJY9AJh
	 Z0cLlUEWHBql8lSrt6YwoEYoeBlm3HP99n1KUUtvGcihgzPboSk/CcQQCG7FpQcV9t
	 zV6piyKQPCpcBp68tfpewArXOCIJzZRK7mFR/LrtCvCcnbllR45tE1dSVaVdR8p1q5
	 8lZLI5QktBckfspAyjjvz+J0dOMYGDYMsRjt8Swy4F3cjWDlt0zFJKE1VO1eMqL+Za
	 zTq8OB5/LWNOw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:59 +0100
Subject: [PATCH v6 19/39] fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO,
 add VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-19-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2469; i=ljs@kernel.org;
 h=from:subject:message-id; bh=E35+ZMn94RagHNIjsMN4/PIbgNGNlEUqBmCKgWbVnaI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZy6l/j3/7mDaSI3zSJqPf9uujU3O7z5TcLd1Aff7
 u6sT4u06ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEpGYx/I/pkjx+UcHxg5LH
 agEVsX8vptTf5tD7ftf69+arRr/Ot39mZOhUOrvUR+Y8W+6cF+d4Dc9c75k2ja8uK+jOYdt/DtZ
 qX3kA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 00EBB14000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5jxucmijpeqp83mrfn6z41bcu7ghurq5
X-HE-Tag: 1791904564-125349
X-HE-Meta: U2FsdGVkX19Fxr0AYZyYXTEBH/MGQS5hIC0RTYbfK1OFkKPFBHHQjWDK7nc5362gKtqWWN+ioT8oTKZhf+vcTZXRw8nDdcMDwP903GjASJLxcqtE2sZUpkgi0CreI0QrNXXp4wuHZz3Jy7CTSKCjw6sVxpu+tawUq1gLDAVBBKppONJdDIpJ2ycCReht0Rs7nkUw9llu3NQeTen47E2ilsaKPc3Vg0ykBRXRVCqxO951Fm03W17fMx6CslGAxKji2c4gY53qFwdCkn9rv1+emJW0m3OiHnNy3ldniYfa2deR17TpFYW4g+wPUMlJZa42VARE9m/kRCbQhp1HAZRuBqJjdhvi0xNv+E0V3at7TsrDYLVEhwt/YG2Gw5VLs1GsgpcmCrzqJxJNgGKVu6asQJAYIFgwz2Li9IkE88IlubmRCFZfJRTN5R3V2h0i9rZxdAevblUE5VZCh8fgxv5OKANphRQg5nXKUesF4yQkUL4iSJGY/dSERJjyRDAi6QKnT+yCnkKovZ53cJKh2Co+x4Ym8GaYb6poYf1YaoTPgsCFR3WVzaI0MKEGwG502yuTpfJPIb+DEd7SSIn15kvdDN7wntRyrsP05ypjYvuvoXi5UJpTfp/JNW0EU/TOP1aFZJhxmJQEYh4CHGlXKVzZmpxC+F/AVj0+Ea79BKwmJTR1R6XcbqOTV3xQZNQsKSevH0I/CZ5RV+PfLwPDK45Uv9wgaGuNmApU6elVwvIC8E7YoeIFLEWzebmIhMLAWWXef8tNMQ+xEniyK0zCIoVDMFxZTus6mV8Tc1sYwSvLVUb+J9d8Yr3gdIhCEmx3oKh5yZHGp9fTiWT3VO0+T4hAE4H9K0ncmL1AXjeeh0cCWFE9b2UfHCg5lRs1rRsqB/OLN4RNvhD/sfaCDeyqMoRGzhZWXXW0LCbfQk48tH2fZE5I/6ULou+vf7Ky2BNqutQ7Fjsvxu7ATOScIquERbc
 8UMiGy0S
 YXVVMSB8JvWqjn4qgsl8qyM3EsXJwzbwGRgvSg2xVpXjJCXgGicpS03dycVhT1GoBmWrZ8Al5Y7xQIY1GldDM7qof5AvRpEUBeWRTyxof2yt8Yf6v5T2zwvFd42ki+Fre7/BheCfXpyFtDHaMRNkMQk6GvBL9zgvoy0zogZhhjfnoSG+Z/2QzMJa1qKJYbeIcQ6UAD+Bdm1qlc1Yqo3YEHMEhsesk2LVE7LvPJz+NM9NT9UlVpCPCfZG6BBHtf7hQFVrOWP4MCMq4VOdI/n72wvskP37xnwPR2fYFSb6vOCBqxdP+IX+ARII4nlvdMhuU/UC0pGqfXPgOOtmJZIbHlwrB4cxURCg0EDPJkB5JHE66V2+OGJkBNT+qM9v9veRdrnqWK5bl3GLsYwu8y8psDZJaSgpkCaFcXnqCvDLx7TPvqgrAD5An7yCwdDcxPqj5Y8Mzm6qdRSt8e3qXxoRrXSIQQjEQnb1JAl7UGiTI3rTJopMr7xMaFtcDHaA3aKgOvTUZa8jspZGWYoO9iT17rKJMA70kF5aJd8URRHtbmGT3OlZX3jKgc0vCPaEEYtGaOU3RU/KtiZVc1UeU/digD1fhVsjzoOhmzaWhrAWvEmciLjNTUIUKvNB4WylS6GAA1ckCxvOKKElcxorYUgCXrLVlKmLT9hKBAIpas+RSKkU2aOe+99MD1FjQiM49AvigHBN0bh5/pe7CnVC3Kqzzc/Jp+K8X0/GIHlNhSWCZNemsoHHWViNOKb5EPkLaG1xKLIIQ+YuYDrxRfEotn9Tqmyng5UnTsYeJVaZqc4ZnrbKhGoEehVIO1CJWjpZauRBWsgMRIu7/+681M7PFwFG2fBPub4L1JySemfUs8noVld5e+iB++AkcpybHtzMydYE7N3MuCArQ5tu4RGG/XJPf8pzmPN1iSC/z6xnW8joI4qWb+AYpwEf9potA0IcL9FBbLEOgF6HSFBkHPK9ncIx+3S7KBbkS
 K5kTy0oj
 gardH+Vn6JSEup1U5AzeIzAGT4f+H4JhKhVwgzzdMorft/8GmnwxotK2VYPgRxTDqDTOMm9CCsBHGPJVO8b7Npi65enWHlVuk83LVwbssjKHDKljtwppZG+4dNbfnvzT8r6E7KkIAVw1hZuFXXH/OCjPwi9vmHl7GkWdn9EVQS7RI+M80s/rpNdr90GXcWnfo6I9YTNmYKFQJ0qyf1IgxsYsBYb+kmGfh6JoL3dRtf4Ja0/Jxg0CdP4EBbXnr2ShVyve1fGxjN49dVk0gYw0s1GVuQGOSUVLJOMJ7ansec+49uisAU8t9sBbFZ3zJ9Z1XX/7HPB6d1uPI1OcevM7KT0ebUq7tq8fsU8mYkhVnhk5ZOqfCLTn/PfhT3zA1ILr2C3Sw2dZq/0+B7i3vDwb1Kdx5Lrr3HXL+MGs0IWxpMaPvqbDoj8TzXFJUJIQOBsp8jb2ZPNa6GI7XM2b+eLKm6CFOLw1bDqlXrMZGhtjdr+GxSsYu5uMJ3eSNB80AdOgPNp6I/F9dAPjRuTHpC2spJJ7fK4YgMc7zrTgWPZbePYpMDw+PzWhkC0boeUhxfxtzmA6wVkQPBtgI+tZbkVzUbjucdF9hXE1GCLAXAfkIOTGC7jSYXf5fNO4L3nSTM37mpWUvk86F0I2+Hdk8SBmMdJxBEBxLD3wFIQ75okzJK7KplWSoeKn6T3qbGvT9mMHtCIrI4NX69c8PLENjQi2b7zXMoDOp9KlsNVHT2ltz3AsXR9zdvZfbdptIWesl+MFsqIpEWghMXClYZETY9niwtoY0Kxl5Bv81KNJwWdvySNyLz1hBmJy7a7ta3eJ1MykCkna0s8V60onDRdBdRrhwG3ZjwOizIBvNYyls7xcL8rEDLsYr4GJ3pfEmqDQszpDBQ1DI68wJL4MaeSTVR0WxwiK6nBg7IYnIeVGV87Jm1MRXcfJa+fPfarBI15CMrrU4WJm+Kev0hyU5If9RmSr7XhqcJBJZ
 cBV8mCeS
 N1SE7ezdHyH37bc8Kj1JE/YCw0/siq4f1B0DWW0/ZM1cVLmNI6RVxBMnydcYNFr8MPwcQ/PdpXJgtTQWbupz8ncakgDrv2oKEVFB55GwXacbxl89v8mEqzwbgEtvK6SRH1iH6ngrQ+GSpdLUOr0J8nn7nVUMIhtgllbPwhTCLFd1HlRf6L6XZOwnAVV2MAv55OmZ0TTz7T4vbjke1eI0TJeZYErwbgIwhrc9ZJofo65ioXPrvYZnEFwfME2wBj/X18YhTghUKwq6F2qObBUvbZn4utuuhsagco9njy4n9H75DriCf+kNreFl6spSgpjC/gOf6hJZ03EPGXEzDB5Jhpcdls+E04i4p6Ox6nwLERI8WJg9H+b2+nX/H0qtln8t7ZyKFvK5yTXmxC04Ei594LVWe9+n3ybGrIhFua9J2ul905Ljuatnu1yusFnnE2Tyo6UORXjes8pRPZj8iObjX18Qthu6oukb0+UNO3ZWYLw30FRCdtVyiXy27JtFDBUenQKMLPSt9BJew50KlCFVH+90pZIMV8eYxPlZ16eBL2TI05xngbatf/3LVg4Le1RhFh34GJCxgAxF+DbXMPaOy2yMNQHvwLUtSRnkDo+0Omhkxb3SyE8z2dDNAXF6PR5yNx1DSV2RFFRIcB6hfNhg9R11k0GgjXN6o1mIOO0hFsCSkFelJ7kzliqlQtrBsQSuER/3uPiubA68pM+jFBRrpiR4d2Iuv8/4l0MyFisHd5KRB+kYZ+T9ecM8R7Mtp9TfoXbTdS7nCEDhv3qJqXPX/nLWXIOFEQH4zxXeCitp3Gn7siqZOa2NjisuR3lI1hYCF132U2PK/lYp8dosfxeql92YmiKGJfS25nyZgUFqinzgwJonHcDi6455wkbf+w5PEgNKkrYMG4naizA7zQgG4y+OvElv0AdU7MzAdaE7P5ybW9UiapsBpROHlVcgWj7T5wTMITaIBXzjG7nLh0EX4U+sMkQhu
 D0wcD3Yz
 y7OXp0+NKt0aFSjhqTEDqqec3ylciJAREYHPbaKNNciOW98XBd+qo4G5mSComzvsPKalUYT0JBPCqKPbh49j4x/8PrCbKqlL/YvMUrx/s2yo4f4WBvFbiOxySiSbXJDoOppTKNIFYc+pQvjTbjiypFW7N9X0UwnlStrcUTEBzsmQZ7t+HgOQsih3n7vPYjvZbnNrSH0aH9XN6T9q3ZlMtXJ0p1rexvjOEFEuoUWNbsXf8JR/PcD9wwzWEjH++mjtnrhhYap4a3tyYIQf8/Vy2PNBlzsMOVAXdNFhPF3H/yQqJeqOFjuaKeGERvxleiNM48QuKmpTFLwBENHl61sCRKG2ek+Jkn6gErwY0gstB1jQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently all drivers which use defio allocate system memory. All of them
also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocates
system RAM, so simply failed to set this flag when it ought to.

This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_IO
in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
erroring out with a kernel warning if not.

The logic requires a page from the driver and since commit 1ecbc7dd2902
("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
always required it to be refcounted, so this was implicitly already the
case.

Finally this patch sets VM_MIXEDMAP, as the logic is mapping
kernel-allocated memory so this is appropriate.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/video/fbdev/core/fb_defio.c | 6 +++---
 drivers/video/fbdev/ssd1307fb.c     | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index fd00b86e1ae6..fb359ecc3966 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -366,13 +366,13 @@ int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
+	if (WARN_ON_ONCE(!(info->flags & FBINFO_VIRTFB)))
+		return -EINVAL;
 	if (!try_module_get(THIS_MODULE))
 		return -EINVAL;
 
 	vma->vm_ops = &fb_deferred_io_vm_ops;
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
-	if (!(info->flags & FBINFO_VIRTFB))
-		vm_flags_set(vma, VM_IO);
+	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_private_data = info->fbdefio_state;
 
 	fb_deferred_io_state_get(info->fbdefio_state); /* released in vma->vm_ops->close() */
diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index c4fdecafd856..958514a35433 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -763,6 +763,8 @@ static int ssd1307fb_probe(struct i2c_client *client)
 	info->fix.smem_start = __pa(vmem);
 	info->fix.smem_len = vmem_size;
 
+	info->flags = FBINFO_VIRTFB;
+
 	fb_deferred_io_init(info);
 
 	i2c_set_clientdata(client, info);

-- 
2.55.0


