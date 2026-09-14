Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C95C6C88E77
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B066B00CC; Mon, 14 Sep 2026 11:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFAAF6B00CD; Mon, 14 Sep 2026 11:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3B06B00CE; Mon, 14 Sep 2026 11:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 965FF6B00CC
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:10:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36193140181
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:10:06 +0000 (UTC)
X-FDA: 85212703212.01.746EDD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 496C6C0012
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:10:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bwmD/Jom";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uq2xWQ1p6mPiNzp++s6Aro3m2E6wKT5sSjQYvI7TYg4=;
	b=N3PthP30+/fB/6OtpEaSsg2xmj8jeQyLiczT8ZAiL0XVFvZcluHlLtW/ZUukPpjBWj3WVl
	u8st+6eRK0/ZarvAHE4VrF0U2Ya2VBWWd54Bxh6jU5/Ew2TUR5o0nX7mhi/WVVw6BJ3h0s
	Q4fLqtzE9N71Cw57gNKrnnRqY8+IKyc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bwmD/Jom";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398604;
	b=ZwS6IwX4btopOQTKN280o4d2KCuC77EIOvy0Y/T3c+tf0ITcX1QZP2s4Qr4gw3h0HJnDgV
	PuTwn+xnTCwsf/XF5q98/Fe2UAgZ5ygfZqV9yDZnsd3CQ3rD87O55GOORQx9EZG3JZ8AbN
	0oDb0wHNJ6JIUIcLU0Qj3N3Lu/MsI/I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 763B3406B5;
	Mon, 14 Sep 2026 15:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29411F00899;
	Mon, 14 Sep 2026 15:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398603;
	bh=uq2xWQ1p6mPiNzp++s6Aro3m2E6wKT5sSjQYvI7TYg4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bwmD/JombA0FO9sHhGiNJeS+ZvfheSA2psdLNu15mTk14rHrqYQ/IPA/3U9osrT+E
	 xe39lsxBQOZZqjwvEM+rcTzfDj1ai5jy7AY57BD5ejit2mVRCobgEvn/nFrGpVDf7m
	 f25BnyZENCEruuQWi5TZK3sg0ODagQlo3M5aesNNtGvWo+Ztie81hj9SDBnfrCIwMV
	 EEX5U6G0fLVmKsHUFtz0/YenMyf5kLX/LNx9mXftV1CQ0Ths8Z4US4czSQIb09tO4F
	 ENszegDt2bEYLVaYQ6UCvJtW+bGYP4XAoE9BZaiCaSrIBY+HcYyoIIIFJaFKtJQnnb
	 kIUwHj7LB/SNQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:43 +0100
Subject: [PATCH v2 23/40] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-23-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2686; i=ljs@kernel.org;
 h=from:subject:message-id; bh=BsZqCDBeNZFMnLDuCh83Km3v/CdnahcHMG4JtnCdsfU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG90KEmdmv3sU+TkKlvftOYi640HdivPDj6SPf/Fm
 ZOLrprv6ihlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEgvQY/ucXzf+Qv212a3LE
 dr/5c/q9Xj86bZW+8d7W2Ehl6QCPXV8Z/go0LK9fn1Z0oJd/34KkKzan/O9d2nrvxZ0XgROrvp7
 5Y8AFAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 496C6C0012
X-Stat-Signature: qun5tm4ppkwr6sa5ythk9369ahrs7dnk
X-Rspam-User: 
X-HE-Tag: 1789398604-999043
X-HE-Meta: U2FsdGVkX1/Jn8TRM2n57AYtSCNg8d1+S7LtNtOY4f/juZMiuqE77JRcE3PG1uzozf6+VCJhU8JlIc6nmOu+xf3Ic1TycyguEwVvnfX31W76heqdLKnvqYapzR914G58uktJKTXIn5wiWHdDvH5aKYLgqIVOtrmv/tBAwAM1zhzYk0crvDy41J5xF5u4vzBScxpDuz9AfzTIr1ijdGPCC8JDWJ5ANz7x0EpYz6QPyGgr8adreyitaJ/fmXlRa1mGjb+dKubG4XdmnoMXRO1/K5dt+6zjAcVTj4JOgS61fFTdkJSZrKPftZxa8Dd+OiP9K5vxPUESVdk9YRTivWNQRp31TeJgefTrkNLmHdTuWvADrLf2Z5WKYlzy3LtPw5cajUSo3j1IPxKAhHTZfCpA9H5yHpzJN5Nk7QqiSTCXnzkTeWMS0ht8nck1UcyYI5WGePrieRzZOp/k8sJm5FSg3+ZMfZ64bduQ2TII68u7GsinTc1KEWXcDkC64qvZVNOJHtS08seZsE+UqENsFIHalikjC1vR/rnj1/rjc+zP21ZQWle3JAKVdVqe7ow3zg9iTZYV/z7KOGDC7mISRJo158Vkp7HAdMEQk6LWFrHA9kdTDbnWBFWeeu3ueL/z6PZvsU2VmB5pb9AewmywM9t4MdbwW9Kp4pPgO6XvP11L+eCN70Fho76HBpYMOYZpAWhKm9g+9pH9K/U5TCA5PlEosEtHoe3K8t3sLQe8yPIJfgaXLPPywDa58Fe0l5haW3ihmFxs1OVNRzCOJieUwA1/0vasVBoz1kWVc4ZngsQVLgL4VcV8obVnBMfZTGG4sDQjgXxZf8JhaVkfCR7839EI+ksMb2ThXtNj+XeP3l0v4K33tN10amRtlFXytE0tqnxvwXmfNOHqqkAMf0z3ja0sbDCOUa0vwBhOYxs+FUpj4kkPNB8wCp51FbjbgbuI5yxdDgPL98n7aW8cYq2M6DI
 2JzIOTnh
 abSjMoZeggQ9Zpmmq4vxaRu9iB5fA3IkIZy++P3Kx6rCO9LfXHyg5gVzRHdO1GxKJ1ahF5Em6rNcYIJLridVo3Rmm+AHoMLBBPdGrfvvp/VgGVG1TuQIavZoPD5O2K1Z+6Sly1llj2ZLZNmMI7NqfQRMnlLaWESiV655+YX5YjOJCuzPafpxcNsj+SBi+8EHl2dAQ0PmfhOcLf0DSdai9UH97peBiTq0usSGP/1wZ+SrXR2a2YfPvHCqac4fQBYVxKanRGkB3WHwynOZV4bvTItrNDp8h2qrPA5ElaDznGQDMG5gd/U1B339O/Km/F4G5X+tVFo7LU0QcJ8z8FmOvDj32QDvewyxrQsVzrItGrRArrniwCXkYSc4GGaabB6Qnlat426UGXj9LlRKSnyzMZQYPZpF8jIcW96jMVyAAolPRbO3TuVEzEXV4Eivyj/l8egfslyUg3zlEiZWTHzDBU1UvHfromND/7xREn5m0N/Ec5YmrtlP3pbZjnDMHeEMbK+rCOG7uVD2LPVFZnMJiyc5i1upxKKnZh7GlPVGHIhWkLT9Yd64dM11xBy7/5z9IB4EQpHPEBaDiLuT50/RBCBeJQntx33GVYVFWnistWDhvkUGDMDzRLb/N02PM/fW1ouWVz36FNcQur5CCy7SESmRvumWKhs5YLxZSwpmvp/9OMY8zO3jiu6Y699o2cjgN5Me1xcABUIoOnS+nMWrpt1OkW7YG7bTtmkZkUAezjir4+6BviLVZCQHRKtLTSQzxBd/5c95T84GpVcjkAcouM56Yy4XbHmeX11u1j5mjawYCcAKeps93NjegpUl3oybNluKAR+pLHWVVURGarVL4qQzgIl+VCfsA5DDhS1Vbt0l12rWFY0HFkZ22Mu25PlhfvOgm03Bb38SgEMKoiOUr0HhQi+mxCOp3suv4orA4ERhO9i9Atm4YTUV5hb+K6HjH0s5rYay0gCtY1pu6t/XUyMLSiNes
 rZBhmJ0i
 m+P+Po96vKCl3cUwulvAtg1tnYBwQuhR6Rcy/QnGYENdrSzC5yuEq2Xg67xHV7ieeh4/gIG7drOQxR4P7rx48LR6EUxTRDuA7brB0NOPkqpWzSC3BcekfFl41+k1ZPe5Ux+j7irq2EgwpB64Dz88Yf5WX60cW0bezYkOJHkHtaU9LT1qtJzizZc3bLNXRCYA5JarzoAL+Vx2CjBetb/N+0SxhT/Zj5Aw2MRGPIWhrPeWo9lUGiZ2/PXXjeesNPNwqUjpEMG1K1eYIdOyAvTevJ4rJXHDCQNMzYe+bfVAnLFEGVv7KZdPP/Whh/Xne5pRWaxPnxxYQBIlfYGaWEF1EaW67RrzBbByVZaTQwdmUDAw9vokZDFjENl1VI8O/904sNT1npa4Ehp4zApcT+Oyg11mba/0lBdGggwW8Ffgxg7n2zNaNB8mJazyjxcUxWwQHcvW3/WT56LOdJ6clGqk99S/HA2RyKcUC8xPgaW9++jvFUfyGnSjlGQ4xlxct55247UOGNGDJJ+eOjOdUchnT/vbb5hYNoNIrW5vo7MPPrSfNToSnAnmQTnKYSNbu7wdBaJ3QAYhlHuTHtvGR0F0TIvVnZEkUzc0ioZzNvNPXvCLgCa7bbbc0aeKpTB6TJgcZvsfH/PtLZffM4XlqUkoqlT21NpR4UNqxnX09g04T7vy4HOwv4US4RpTik9IgFaZbNV0KphgWHfA1jI6JmSodld6vKq+HMR6Dfo3JoCW3TBRzlthx+SyjMZRDU371wWAwAOHL+SjQB/HS7fGiiCXhYsI7TXQiTVBiEhKyM6op+EzvtDuh+NkU4ZLmT5N+JZ/YtvkI4m2hj+KFI/ZujYwbJwSGEOHxFrjfJ7liMS+7NfIBWxIW2qczIz+yBz2pgqY+bPFA8QtFevHqrS+t2fAqI6/rgLnLmFqN1gv7QFCLlJKUrInyX0/cq8U0nqyaHECIen5Il12HpdyTkND/rtbL6fJwIi37
 5foZOk++
 ZCmapxneRTvQHPoMtq6zZQ1IE9rMNiu3Etj3gZpVt+6TwkTAQKVDZPzuKwWuWOkt/0lZw6mUUbFGj9GCdoMP5ijQKQ4K7PKR/IiexgIUaiVjygmaqEq1HdrlxMwDl8UCgclB3zCkYCoZCtmMB+gAhUMuS/OyXTL4kzABZoWkrC767FRRu8t6cnV1EtfzLjBiCTD14n2S0geSp0k3Wgusw1xOBk9XbjLDUYv12MTUmzsMqaDRMFnSCCBu0qsfcF+Npo0ZhjZI6ClK3xfugG2VtXO91et4K4pH9WLD5nLqoALwtnik+Q5j72tnIC2T6BQqsKP3tdMVcnza9oiZ3fKUDI6F7hZItbqHeR1OxwVjh52BVriU6cFco/m/WZS0sP7lBxKI30ipU9d7ZHH9YuIA54Bv/QmSJywTeC+crV5GpGYqh3f9pMMiGe8k127vB1zq1O1ub6HB8FflP4svIB4YbI2hUgbGNWqpvnSoVT5Qvz9uv2SDo7GmHQETi2FjwFvjz6U3Wv0s9bXcBBpeRgZg1W7TR8LKvfUb2uDu488C2ZojJs2AuPzOVRbQ9y5pxK0i+S5TYxipcv6pZtWizkD2Puwnp38WS1jlx6E3lkay992elq/CXOI35xBs0ToSymn1LHLQ2sF0J15L4zJeFOZVyDKJWIB2pPR39WT5Trg8rUSiJz3zeWo/4KeeRwCRwX3wXgR6P0dww+X4FkxrcSrlFaMg6rPkS9HU0OyUEYInkAQYjKtBTXB+g/sjeQ1yfU6U1PYr3OhLV4UcIgaU9mYK3d40CPQ9OxEDaaHMrqXLHovvk7OOPCb6XNBUHYTJgyL/EUAFdxmMJ3RjLxX15fJWC2uFx0FnEIP0CLdZzaqlBdeyJ7IgIhbBRh1YFkl2FK5p0gaMDobq5zQiRychsL8fRmajHDeWrkloKpjbhTclIQ0f1FwXm+0DNG749IBjzF887LDbL0bYPcdrvTaY+qpXEZIlDEBcK
 5U50YRMs
 6Yltt7tftA+usl5kJS8AhLg9iv6X9g4eNc84V1exJUsi6DlJS5XJp8KYzbvCTU+Jx/dbxeclA7w/MZ3W2mB2ndVCq5WdVxx0mK3Dwslwof45y4Br47uIY0z4qVqhKqbjBzCLDUWPmU8nYgF5ZdJnQuuYcujPlDL2Ecv6TrjCts9FhnAYteuYGBirWoOAb6Zwn/DNoIzrFEVmZqpkaS7Gzvt5NeW2m4sWHVVyTLtVOV0LTUuMUQRrEptajaV9lf4T5P4ve1+zW/IuwhELmqkaYlLUDQHLRZ4LhQCm2yfa3pAeEMk8jpZBiXv0tTplWYPObC5OJEw8GugEUAU/RK+oGl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently there's a confusing mess around VMA_LOCKED_BIT and
VMA_LOCKONFAULT_BIT.

It is permitted for drivers to set any flags they like, with the VMA
already possessing lock flags.

This results in the absurd situation of a VMA possessing both
VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.

This has resulted in mlock_vma_folio() having a very silly check for this
scenario to work around it.

There is no need for this - just clear the flags before invoking the hook
and reinstate them afterwards if they are required.

Nothing relies upon this being set during the mmap operation.

mmap_prepare is unaffected by this so requires no fix.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h |  9 +--------
 mm/vma.c      | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 3a395e8c224c..9108b2b2cd03 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -969,14 +969,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/*
-	 * The VM_SPECIAL check here serves two purposes.
-	 * 1) VM_IO check prevents migration from double-counting during mlock.
-	 * 2) Although mmap_region() and mlock_fixup() take care that VM_LOCKED
-	 *    is never left set on a VM_SPECIAL vma, there is an interval while
-	 *    file->f_op->mmap() is using vm_insert_page(s), when VM_LOCKED may
-	 *    still be set while VM_SPECIAL bits are added: so ignore it then.
-	 */
+	/* The VM_IO check prevents migration from double-counting during mlock. */
 	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
 		mlock_folio(folio);
 }
diff --git a/mm/vma.c b/mm/vma.c
index d71ec51255b1..c6ed04d27351 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2607,6 +2607,11 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	if (!map->vm_file->f_op->mmap)
 		return 0;
 
+	/*
+	 * Driver-specified flags may make the lock flags invalid, so clear
+	 * VMA_LOCKED_MASK and reinstate it afterwards if appropriate.
+	 */
+	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 	error = mmap_file(vma->vm_file, vma);
 	map->vm_file = vma->vm_file;
 
@@ -2623,6 +2628,15 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		return error;
 	}
 
+	/* If VMA flags still valid for locked mask, reinstate. */
+	if (vma_supports_mlock(vma)) {
+		const vma_flags_t mask =
+			vma_flags_and_mask(&map->vma_flags,
+					   VMA_LOCKED_MASK);
+
+		vma_set_flags_mask(vma, mask);
+	}
+
 	map->vma_flags = vma->flags;
 
 	return 0;

-- 
2.55.0


