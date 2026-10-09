Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 685F0CA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871F46B0095; Fri,  9 Oct 2026 14:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823146B0096; Fri,  9 Oct 2026 14:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C35F6B0098; Fri,  9 Oct 2026 14:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E08A6B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:05:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFA451A0483
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:05:00 +0000 (UTC)
X-FDA: 85303863960.14.8D3989D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 13C764000A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:04:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G5GM/NLh";
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569099;
	b=WY1SniZLmLyCNEscL75xUU37lk6YC6Tbptxar4ouqK7VTURq1/ETanQlo3GHxLjJKFk0AW
	FGo6U3QfEPVJN5ItnfyRkN7YNoSfS7sVfW2OcKuGW4JXTRE90N7htkoQV7LhHDxCJlzBy3
	ZwIZhJcTk7KMozUqZgifn83hEU+Sov8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G5GM/NLh";
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Fqy5CealUldTwU/LGJC2dIT3AOdk0HYZp0RuL8SmXU=;
	b=cNTluYSz5FB612Dbfq/HccN+rlkk+qtihxQIMHj8x0tYm/+O7zwPH+ClB6zn8t2uqBJ65E
	zVjDIM26nnvO9RvrrJMS1QTQFAi7YAkGxZoTT7EWtXPO4/c+YB3vIHaJT1RGaskQbceyqa
	bPnjAju+gtf8Em2LT+3UQjAunPCCpPk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FD7C6020C;
	Fri,  9 Oct 2026 18:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4736A1F00893;
	Fri,  9 Oct 2026 18:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569097;
	bh=7Fqy5CealUldTwU/LGJC2dIT3AOdk0HYZp0RuL8SmXU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=G5GM/NLh4ZLZQwV2PPV9YyJLVlykIKDz8rv4nu5UX+jNSbDe0tlPnbsQJLkuXzbuK
	 31uWfiV1o1L52xtGNIJiALqeA7Jy8pU8JmSp6bQTj3UxYwRC9vVaylQGiqAMC2Sqqo
	 CJfcL0gyYH7yrAOXQTzS7RaOY+bIPY8qtBrd1zVoVcKIuAOqVhCJxvDo9fdjjnBtpS
	 pGDbjg/RDtXK0FWrJPoQCVH20pWam31oLMKxNx/7OsMQPmLenO636tpwC/Vb45f999
	 LrG5ELLAU7rUGq04UaF9sb2C+Tt1QHiO/b/KFT1Vp47x8ZnkFh+boHLaJonZtUcjPo
	 2W7aehbdGbvKw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:03:55 +0100
Subject: [PATCH v5 01/38] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-1-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=11336; i=ljs@kernel.org;
 h=from:subject:message-id; bh=NCrL2U2bu3SYoKSTzL7YMvnG9Zxk7Z8SDtyXYUu7I1g=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sx4K19v82Dtputt5e9+Osw88f7/l/9puvPv5bvci
 DvV/tjiWkcpC4MYF4OsmCLL8y/i+4NEwuZ1XvB3g5nDygQyhIGLUwAm0v2X4X95Q4CwsNZN8UTT
 Vbe5eed8MTeIn2W5bLrzza337lUr/e1h+B/huDyrpX2nysRMoXjLF9Hry1cbON5/WMIftol1TtC
 +CVwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: scox353rs3k69swxn9o9tqde9o63g8qj
X-Rspamd-Queue-Id: 13C764000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791569098-906120
X-HE-Meta: U2FsdGVkX18VkgHClF6Qt6ZvvhV9w7YcHNp9zKjQKhmQQEqHkcpOesvcAiIym31tI7Xy/kjwJdujvp2qqMWJMQ2XIz5b4KgmW03vKn7WY6+w7srsbNiUINZxgw1B04fjxkaOuxs1e/MkOnMkLIdp5n46Mjy293HSGCGlOXUzGL9PjlAlPtHSTZNEh2pV1v8D/FUKNfQCJ07lal1A3q8Av9T3rHux8X4ep1o5Z78nSVIlycuQJRPzwHkFoQolo/KMIf4EomxfazlqHyGpx1mvAcGwP/UNLKDOnZ0qsI4i/WR2GQrbtMKjoq5t0zua4E9reKcbIGRGKMAMlXNTNlKLYR/PQBWykH2ZlkWRuMQARQIYlyovhVPyi5NBMC4Bp6ztY7kQU3PxVENqGwkvRe7UgzZC7Ol8GjyPC2+xsM2rDq+sfiQwFXzq0Ewyl9K39Z07HhHLUZAZ3rdvt7mJK1leVr5Rd784VXPyblql+8jFjxqAQpbjeSBk9YcsysHJWG4/pPs8c3xhPTMue+7Al4kQy4B7wiopd0NwTPjBGr+ChvQKgDP4gwWc+1aVULFyy3aQEfs9A4gEDMiSEHxMQDb+/WJyq3L+QwZPv0djcPoXLFdcWGf63uKWAKXymRIB6/dbkLK0wEEWcryE+pHXY12y5jjE3XFjEHCq/RkZ4MuV4BL7SMiNf2xPPo6RTVCITubUU1c2IAw7imWVWSq7Z2AIlidbL35e7e1NLtmRWj1RxuC9se5tt2QHh8974uzgU8DBqGg704KPgOvbLzL3VVPFtFHOAk6AJXSoYoTBlmO1R2USMq7lrSBcZLJvTFI1a5YNnvPU5HGI7yzipqiOGj+FRhgoQzWI8ugcwAMFXLPZ0XtfcETK/S96QySIflkhFqsbZfBQZsxW5QP8ZaFgiStZIK4gSPKizIws1nurB8ZeJx5kMwRjCZ+cb/3JYPLqV/rxHCym9upFrLy6P31GMtn
 qO+WmQ9h
 vQKICnKdIIrF5vQyf5ifdWPHyqDUa3ZldqfdSjkS7V/PuMNR2Vrm5ShuYm2EQgMDYeO+jg2Kq3GNnX6Gf51+yI//gagJxLF/sWJ/i/wpqx7ousnuNCTfMLMTy0TnZT7Tf503Xv5QdzBqeKLqtPHDiR1tQSx3uYk9lZCzb2da87VWMmgMkhaRhplKWgD39b2opAjR0VyDV3LEOuBWqlWB8ZN/Ez6qkkOIa5BOsp2kBRe9oQgTXrW+iD/3fW1zn6u9ODg0ZPTfnAU2IrUTpVVnO0oKKQ/3YVLcfAXUCFFKv9CCERVaITii8XpPM0YGd/n0pdM2wC04dChJeziu89db7n53dQJdrVy0OQI5WdVp6IRaxJyQmnkUwuBFcMGdA347Ym0x3uTPc678qn/mu44c30QuR203BvXYzDBGQIpl7So6EkfqcyjDgR9BjoyasPdh9KyX0fgIo3WlMbGvAXLN3o/+zCrSQ8l8+2o0/FcEObXDipGqaLWRr0ss/t5pxHDz4V4qPsbSp6Vz54o21iKB6gEKNUdU20hnB38b76yj0QH2WGS3BxhwuwKuDQCjq+49a3sPlcF5pWhSiOqx3lGMbALQ2YewCRQVzJ/JTmvVOKcC1qykhBhO+xC2TmgpuibRLVfAlm9jKqP2vDwExHEWRXBTJltxIJMjLzmQR1WB5jwmOZ2PLbzZd8DHldhT1Bxkyn7jE0KRm4If1HSm86VaDH+Hfe/UBWqFY8scY7AGX5GTisvcpqs9OnA/DZjj/q4kKt/dD+4JdaIVxdrHcUJHligV5Rk4L7FnbX+e+TtWB6KJr4NNNxwLt/nwm6WQa9s/43A4Ma3h9allSZO7QMtwrP5RjJcBIWY/qVKcgWPMWdeA9nJiDI71CRFa2R7aRwRHa586LUZW1zrwM6z65BSTeBDt9jxmzgXBljV6CcyFXI6qWbc728l6TdH41fpog9SH6+jgrNN854kyKdoTd7g2NuGh///o2
 KH4rxRbj
 2namnhVD9VcsAQEZ7XIu00a/ZYAL3MpkXyj7yNPlZQZfQsuY73mMJ902/EjfxbVcu2GtVLPpNAyFSAYUu50j8eh6sK2KLDeWq6xT8pHvrZmphO+OBRNq+ktDfnCt6vdLtnLA1tIGHEpxyQJDkBwaiP+mfF2bfTXLGeo/vlzbU8aaRp0tRG7j25gFbEPR/oO7RZrGH+DjgsTsd7AOMHvFsEssNqIG+ngpSrOrJ78vwMGR+YsWuCiwwWQHZnen/+oytPxykot8T1hy2V8Qcf2bEcR0aViU/BGOUJlI/zUpyYwEejdl6r2dwq8GFkxV0zziQhViwe21oK6yJbfHFj884aljh3Ooe725Jp/sdA+T9R+AN/xUgDNeRO46uVn8AimdLN9IKTCYVqdh4nngPaG+qSpWpKRdSuzuDaaSl7st1ottRIyGtAf3JCAhdkSWk+kDQ1ywgblda99xeC4LRm2sX0dLTMk+VhsAkvEWwRw2A4EvFrClnBDVk2uHRunsYe+oW40FTtTJn83KvhYUj4f5FtHbBWPjbtVoWwYWLl5yS1W5Gsls2u8GzcOM6DeAhHvRNcXDArbGTDwtWOo7yZCDsuZ0SwhEz9I4LMK1M229VbgnO0QonBkcobribz4pU4BT4o5bb3DK85f2g/binbItvw56IsGQkBZgPrNHTIe4uMAY0oRAiouOc43HyY0jHYBNObVqpRKTo1PMXt7IsxMa7uEb3ilA9EY5prRrd/tJdZmG30u4ODjVdwENOhNAimlM6GoVV69LTSqcXIIiddDsT+q8jG+8tLwq2OCzEjcUWR81mNF9m6V5HKV0TSnl9PWKWiU/tAvRdWJO3AzxUy/CTZ44EgpbtJdaG5eyqVAAHsj+ornmJ4FIJTxCU5fdRDKrw6fkdJ2ZqEs1qSznwHOqsdtFv9dY+C1xQXgcT71S5VAZ60i4USzO38r79ZsE69rrxSK93moXvhmAihf6k4EnSRX8wkv22
 afoQ71UA
 Ry1f+9p5kcLDVHjUvgQZ64cS9Ooyc8ytwNY3Cf1T9PzL8D9YEu4LKqLjcY+PFq+UcXYXQp4wP9jEkFwYgpnIDTN2D2ynX8xdhMPz82FyuflMnqPZHMpWPm5xxi2czDtjwh4ZRIwBy/2bdzxgK/+dcOYyU8iHjFHo7aWpEc/LvqBkb/MGGXmS3ImjbMsbyeYxKUkLm9EQLN/2VLEmfb49pKTAAyLLGl3I2nU72tkwzv2EyNfgVjZ+wnmH2PK+P2Drng6jaaGnQstvBB+BN6+AcgsZPJacNg/qknFDwiQ5UPZc0UlhonaF2Uf+Gy6IOG3d3lxiBWR/Txzimt3OCC2yEzCV+9x7n8qNW64LhOtXjFWqfwTXSR2z/KaSzk6p1hMi7lDzToTMO4wKId7dng3MzwjRZZIGWwyYOUJKDOe7MSIDFEVEpHqDW3GTPO2XGkI3Q5ZX7hf/90n+RIpR2CgR0aNg/yRpr3CD09QVdWFQheUMOsVSvDMsSb1ww6GECJo8s7S9wxw08rDw/pcUtLpVs84FiirjrC8yH8jeV4ujb408sgVyUH8NMEVLkyqP1ce97PoDiE6cP9QFyH82ta/hLsSLWlt3D+2LRkayOXgGT67DrAtnXnlPUfeYEwuZU1EExxSs0Sdcu0jP6psNVxs5MGbc+0A1JvOA5fRzAa05sbeCGJJzLUpMx2iXQ4/UPBPhZZLEO0WUyEHIVcB2Lho4zzaEibukWgJMuhJb0ziukQUmWC2ocO55zPt0HuBl6PYm2oK8AhPt5FGvPtfq8+E8v8rWVp1AR85avVepYBRs5NFzQaAVZt2r1rdijOpSYVgzdZItHBd7OF+chniNBcom1xh5X4Lyl+FASyBBWBKji8Ljfs+P77I1fz2blYY4hZomdvQ37dF1DhF6pM+opJheKYXsQ/SmVFqRxq1Ikng7JzwaZ8BgTpancmtPMEPxDlN/Fx2uwUe7UtQuCQ4aMEau/51uy9Hhs
 sNUcc+Di
 d1CMIbSqsseL5MGaOvB4+GJWZdAK/qBS9xys3f4fMX+7gldz0VsqYzEb0sfguSeO0MjdnbQi8PzBVNqEkTCX5OY6UknzwrkIkeJgQG7tb8UTSrBl2+DCswooQqResuv4VA4QVKv6QZbJqTVaiF23ul1ngarUkB0vsMvgNUWbkdR4qz+CBI1LTTWZv6E/2rltyEdrnFrvLZyfb5pAXy5KBDzXSY3dkTmtAH14wGCTarphUDasxtI4xVYk+eqMMJR+dfKy68ewQovpV1i9invM1yF7g4Yn8eSHUI1XX+m/2JKV5z27pPxzLHyLa6N0ZxvsGnf0PkzFA4cz8anWz4u/E1smwYQu0uhTSZkICCsRko6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The map->file_doesnt_need_get flag is confusing and the existing
implementation has holes.

Drivers are permitted to change the owning file of a mapping. If they do
so, they are required to take a reference on that file.

The mmap() operation which ultimately invokes __mmap_region() is guaranteed
to drop the refcount for the original file the mapping was made under, but
this is not true for the replaced file.

This has been addressed so far by tracking map->file_doesnt_need_get, which
is rather poorly named and unfortunately fails to correctly track whether
or not an additional put were needed in a number of cases.

Make life easier by removing this flag, and instead drop the reference for
both mmap_prepare and the deprecated mmap callback in a new function
map_put_vm_file().

Track whether this needs to be done by aligning mmap_state with
vm_area_desc and store the original file in the map->file field, keeping
the updated file in map->vm_file.

In order to have the same behaviour for both types of hooks, only drop the
reference __mmap_new_file_vma() itself took in its error path, deferring
the replaced file's reference to map_put_vm_file().

To make this work correctly, map->vm_file has to be updated before any
error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
set this field first.

Also when mmap_prepare() changes the file and is then merged, the reference
count also must be decremented, so update the logic to call
map_put_vm_file() in this case too.

Also update __compat_vma_mmap() to manually perform this step for stacked
file systems using the compatibility layer, and update
compat_set_vma_from_desc() to replace vma_set_file() with a correct
refcount/file update.

No in-tree driver is impacted by the incorrect implementation of this
currently (no driver that does this is mergeable for one), so this does not
need to be a fix.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h |  1 +
 mm/util.c     |  5 +++-
 mm/vma.c      | 83 +++++++++++++++++++++++++++++++++++------------------------
 mm/vma.h      |  6 +++--
 4 files changed, 59 insertions(+), 36 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 0dca33db068f..fe576d468af4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -7,6 +7,7 @@
 #ifndef __MM_INTERNAL_H
 #define __MM_INTERNAL_H
 
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/khugepaged.h>
 #include <linux/mm.h>
diff --git a/mm/util.c b/mm/util.c
index bf0513d1d3d0..016932780925 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
 
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
-	if (err)
+	if (err) {
+		if (desc->vm_file != vma->vm_file)
+			fput(desc->vm_file);
 		return err;
+	}
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
diff --git a/mm/vma.c b/mm/vma.c
index 55917d097933..c27aea6d58d9 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -24,7 +24,8 @@ struct mmap_state {
 		vm_flags_t vm_flags;
 		vma_flags_t vma_flags;
 	};
-	struct file *file;
+	struct file *file;	/* mmap()-specified file. */
+	struct file *vm_file;	/* May be updated by mmap_prepare. */
 	pgprot_t page_prot;
 
 	/* User-defined fields, perhaps updated by .mmap_prepare(). */
@@ -43,8 +44,6 @@ struct mmap_state {
 
 	/* Determine if we can check KSM flags early in mmap() logic. */
 	bool check_ksm_early :1;
-	/* If .mmap_prepare changed the file, we don't need to pin. */
-	bool file_doesnt_need_get :1;
 };
 
 #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vma_flags_, file_) \
@@ -58,6 +57,7 @@ struct mmap_state {
 		.pglen = PHYS_PFN(len_),				\
 		.vma_flags = vma_flags_,				\
 		.file = file_,						\
+		.vm_file = file_,					\
 		.page_prot = vma_flags_to_page_prot(vma_flags_),	\
 	}
 
@@ -70,7 +70,7 @@ struct mmap_state {
 		.vma_flags = (map_)->vma_flags,				\
 		.pgoff = (map_)->pgoff,					\
 		.anon_pgoff = (map_)->anon_pgoff,			\
-		.file = (map_)->file,					\
+		.file = (map_)->vm_file,				\
 		.prev = (map_)->prev,					\
 		.middle = vma_,						\
 		.next = (vma_) ? NULL : (map_)->next,			\
@@ -2447,7 +2447,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
  */
 static bool accountable_mapping(struct mmap_state *map)
 {
-	const struct file *file = map->file;
+	const struct file *file = map->vm_file;
 
 	/*
 	 * hugetlb has its own accounting separate from the core VM
@@ -2496,7 +2496,7 @@ static void vms_abort_munmap_vmas(struct vma_munmap_struct *vms,
 
 static void update_ksm_flags(struct mmap_state *map)
 {
-	map->vma_flags = ksm_vma_flags(map->mm, map->file, map->vma_flags);
+	map->vma_flags = ksm_vma_flags(map->mm, map->vm_file, map->vma_flags);
 }
 
 static void set_desc_from_map(struct vm_area_desc *desc,
@@ -2506,7 +2506,7 @@ static void set_desc_from_map(struct vm_area_desc *desc,
 	desc->end = map->end;
 
 	desc->pgoff = map->pgoff;
-	desc->vm_file = map->file;
+	desc->vm_file = map->vm_file;
 	desc->vma_flags = map->vma_flags;
 	desc->page_prot = map->page_prot;
 }
@@ -2586,6 +2586,10 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
 	return 0;
 }
 
+static bool map_same_file(struct mmap_state *map)
+{
+	return map->vm_file == map->file;
+}
 
 static int __mmap_new_file_vma(struct mmap_state *map,
 			       struct vm_area_struct *vma)
@@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	struct vma_iterator *vmi = map->vmi;
 	int error;
 
-	vma->vm_file = map->file;
-	if (!map->file_doesnt_need_get)
-		get_file(map->file);
+	vma->vm_file = map->vm_file;
+	if (map_same_file(map))
+		get_file(map->vm_file);
 
-	if (!map->file->f_op->mmap)
+	if (!map->vm_file->f_op->mmap)
 		return 0;
 
 	error = mmap_file(vma->vm_file, vma);
+	map->vm_file = vma->vm_file;
+
 	if (error) {
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
-		fput(vma->vm_file);
-		vma->vm_file = NULL;
+		if (map_same_file(map))
+			fput(map->vm_file);
 
+		vma->vm_file = NULL;
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&unmap);
@@ -2623,7 +2630,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
 			vma_test(vma, VMA_MAYWRITE_BIT));
 
-	map->file = vma->vm_file;
 	map->vma_flags = vma->flags;
 
 	return 0;
@@ -2631,7 +2637,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 
 static void map_set_anon(struct mmap_state *map)
 {
-	map->file = NULL;
+	map->vm_file = NULL;
 	map->vm_ops = NULL;
 	map->pgoff = map->addr >> PAGE_SHIFT;
 }
@@ -2643,7 +2649,7 @@ static bool map_is_private(const struct mmap_state *map)
 
 static bool map_is_anon(const struct mmap_state *map)
 {
-	return map_is_private(map) && !map->file;
+	return map_is_private(map) && !map->vm_file;
 }
 
 /*
@@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	}
 
 	/* Invoke callbacks. */
-	if (map->file)
+	if (map->vm_file)
 		error = __mmap_new_file_vma(map, vma);
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
@@ -2797,11 +2803,15 @@ static int call_mmap_prepare(struct mmap_state *map,
 	int err;
 
 	/* Invoke the hook. */
-	err = vfs_mmap_prepare(map->file, desc);
+	err = vfs_mmap_prepare(map->vm_file, desc);
 	if (err)
 		return err;
 
-	/* It's invalid for mmap_preprare hooks to clear vm_ops. */
+	/* Update first so file refcount tracked correctly. */
+	if (desc->vm_file != map->vm_file)
+		map->vm_file = desc->vm_file;
+
+	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
 	if (!desc->vm_ops)
 		return -EINVAL;
 
@@ -2811,10 +2821,6 @@ static int call_mmap_prepare(struct mmap_state *map,
 
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
-	if (desc->vm_file != map->file) {
-		map->file_doesnt_need_get = true;
-		map->file = desc->vm_file;
-	}
 	map->vma_flags = desc->vma_flags;
 	map->page_prot = desc->page_prot;
 	/* User-defined fields. */
@@ -2826,7 +2832,7 @@ static int call_mmap_prepare(struct mmap_state *map,
 	 * anonymous mappings. Rather than allowing these mappings to be odd
 	 * outliers, simply make them truly anonymous.
 	 */
-	if (map_is_private(map) && file_is_dev_zero(map->file))
+	if (map_is_private(map) && file_is_dev_zero(map->vm_file))
 		map_set_anon(map);
 
 	return 0;
@@ -2845,7 +2851,7 @@ static void set_vma_user_defined_fields(struct vm_area_struct *vma,
  */
 static bool can_set_ksm_flags_early(struct mmap_state *map)
 {
-	struct file *file = map->file;
+	struct file *file = map->vm_file;
 
 	/* Anonymous mappings have no driver which can change them. */
 	if (!file)
@@ -2868,6 +2874,20 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
 	return false;
 }
 
+static void map_put_vm_file(struct mmap_state *map)
+{
+	/*
+	 * An error occurred or the VMA was merged.
+	 *
+	 * If the file was changed by the driver (which is required to increment
+	 * the replacement file's reference count), drop its reference count.
+	 *
+	 * On error, the caller always drops the original file regardless.
+	 */
+	if (map->vm_file && !map_same_file(map))
+		fput(map->vm_file);
+}
+
 static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		unsigned long len, vma_flags_t vma_flags,
 		unsigned long pgoff, struct list_head *uf)
@@ -2922,7 +2942,10 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 
 	__mmap_complete(&map, vma);
 
-	if (have_mmap_prepare && allocated_new) {
+	if (!allocated_new) {
+		/* Merged, so need to drop refcount. */
+		map_put_vm_file(&map);
+	} else if (have_mmap_prepare) {
 		error = mmap_action_complete(vma, &desc.action,
 					     /*is_compat=*/false);
 		if (error)
@@ -2936,13 +2959,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	if (map.charged)
 		vm_unacct_memory(map.charged);
 abort_munmap:
-	/*
-	 * This indicates that .mmap_prepare has set a new file, differing from
-	 * desc->vm_file. But since we're aborting the operation, only the
-	 * original file will be cleaned up. Ensure we clean up both.
-	 */
-	if (map.file_doesnt_need_get)
-		fput(map.file);
+	map_put_vm_file(&map);
 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
 	return error;
 }
diff --git a/mm/vma.h b/mm/vma.h
index e97bd2dfa786..f15faa83f3d6 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
 
 	/* Mutable fields. Populated with initial state. */
 	vma_set_pgoff(vma, desc->pgoff);
-	if (desc->vm_file != vma->vm_file)
-		vma_set_file(vma, desc->vm_file);
+	if (desc->vm_file != vma->vm_file) {
+		fput(vma->vm_file);
+		vma->vm_file = desc->vm_file;
+	}
 	vma->flags = desc->vma_flags;
 	vma->vm_page_prot = desc->page_prot;
 

-- 
2.55.0


