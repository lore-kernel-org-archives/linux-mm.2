Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F02C4C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2FF86B00A3; Tue,  8 Sep 2026 16:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06E76B00A4; Tue,  8 Sep 2026 16:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6206B00A5; Tue,  8 Sep 2026 16:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B04C86B00A3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:06:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44173C0641
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:06:19 +0000 (UTC)
X-FDA: 85191676878.24.23EAB02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5F7112000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:06:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VGKeUcB6;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788897977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxJPdlL4ukdxMfUTmFq0FMtswRM14QRAmb+14GeHlio=;
	b=KPpSYLVjdfwumnHG10AqhzAn3jf664KkSnnHMrOi2PeFXYZCpnU8pHunBzXC7Ovb6jmTnC
	87vOflAuyixnDLb0mFpZzOOQLzqkEvNL4DWCWWIi/jA4f2IN783zjUcNKIJCoNZKXFwgfD
	xCRmsop3xUR3TmCNbLF0szKUtHJ/dHI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788897977;
	b=axYlQgN+SfjCi6AiLvw1XCFYvKPnpBk+AmgIto+Dp8ClkDzVuNoG/kDLeuuYpZSB3nZ/FF
	2alXHg2/kDQbXYC22+1ui4RQg7fIqTRArYHeV34VyQ/Fxcq/i49KA0i3w5dO7miaqTrI7N
	/54g5saIq+PYbwGECKls62W+NC3lukE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VGKeUcB6;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A49CC43A26;
	Tue,  8 Sep 2026 20:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8918D1F00A3D;
	Tue,  8 Sep 2026 20:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788897976;
	bh=CxJPdlL4ukdxMfUTmFq0FMtswRM14QRAmb+14GeHlio=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VGKeUcB6SUFLsSVulzqqQfyaFz69NQyby2vU8XLSBUmGFDMbCJPSyoJGPIOC9nknp
	 YlLLLNB1c3/NwBUzuvm71qtgs3xh9aXPHu1f8/84w1ZUz6tso/7EN3wpR2x5RrxqI1
	 FAapoB9pql3luYUvaoesEhmMXGdcafc+m8jfWIpN23x0gaG7/lQW4qzb7GW9A3h/sK
	 AUVoUXtZ9IOKcZctb9ifbw6Y3iyBZC+h4/Dqw+OtSsSsHG6MMQ+76u/67m1RxlgAvw
	 emgvFdJ/Iqsc6Eb9WUd8KgN5wh90axjl39n9zOW4/x48c8VIcjO544EftN7hXMfcu3
	 ne4KzPtvSqzqg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:12 +0100
Subject: [PATCH 08/39] docs: filesystems: update mmap_prepare docs for
 discontig kernel pgs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-8-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4561; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ku45FxaXB5jDrWF7xzKWcksoG8pHB6sirZFvJa9Q21A=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG40yzl3S0bbfdV5lj1Wju9vbK2b8fXiT66j54KLT
 7cFxDAndJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAisVKMDGvmHuaUbdd3mH1Q
 VvmsWUMDJ8fR85zTff4c3CYtezPIuo2R4aSOfd0+J5fHj+QdN0TU+X4PyOBfLSMWfcPe7fVH7rm
 9nAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: czbkx4uy1nip8ba9ncue4pozq63wy3ou
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F7112000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1788897977-149701
X-HE-Meta: U2FsdGVkX1/wuNJ3hfKtwn9xLqRcGEGg7/hpUsNu+J/jTw9IQebEC8juNeS+4UzbGsAsyVCkvtyNgM5ukdk1sTsi/40Zlleezip4hdkKajtgjh2o0DnitHR0VG3Hskp5COT9vz6F2/2iUlxdvnThNifiHzEQzTOreYVsDifjS6hYai2+nWQezmwmZyInwne2oeMmQM3ubztf9xv3xeXubq+UxqX8j48d3aGLTKgTO0RgAVcU2s1mDzuELzA/93pJkFaMtg9Vo7NOLhoNqFk9CAsK3LDy23Xq0M9+46bMBqvA3XZCXxpIOyzpbQ9bxCwFlwuVh7F2wX8Cdn3Gh4FOgAc6VFMkWHOED+msXjdHfEpFRwqVFHHYDwtAUmIPwLGfpY7Y0mLAxvK3LxoRrqbEriqtUToUZEo3x/wbKxfbGChLK/57XoDfBbozbonF1KOfiVf+fUiboKGV7ItzqMe/bMWCYFR1RYniF+2owA7jA6YENBCEqU3ES5xW6693P9h5hbh0SnMyexTU/+CVcASGL1MTOUhQd8xvN5Wh/t2IdLCj+pGY+p49xwhxL7xSZalZnZEsqoIslkGC9qU3nn2Gnj9ItRFGWUvV0JlxC8rTfEm4thuH+70Did6gEgmPdM2ZHeyJXzXeYWBAP5d+8O6ulyll1dS7kGs9BrRdwB1AZtKC4LBStqRpW7EPPARpoJcmHn1hrWCmv5rHOqfW/T6GCYbelCUPvQeCu91Ab8hWtm/8koenkpnetBWfFXzxg4mc54yWY1Yx4Z8u6oqlrbKBjChAxpD3o8/j3K1r4oyctPFPFbhUyoKbmlYvZ7W8A991pgc3sgfhUyE1kRg0isK8sYP7Ov4UdlfK6Ywmce2hlEjhipJo3M63Xn/mS7cpHFqSjVvNKhmqG/8Tv4UxotUGaD2ThMGKqkgkKG4QCbBPjFJB82y1pCY3tyh97DvSsLW6ds5Qcvy/R1fCBY4bszL
 wl3jt0rh
 81qBam5bropY0Zi3epJVizs+u7P8SW6VbHnAM+INsYqNIGeAppaR5NajbZU3luZmiFAiVfokvkklww6CNgZY+xgTWEhkKHxNR9VuISdq6j5n0BMCa52BItqyOcQng2vGBF183eqQeGXu1iXOgf3SQfT2gloTkY9AsDW9kRhiw8y8I/QwNL/6PLSpgGxDqHfKl3qqGUC4zzeiI7zh+nsLDfelWLSR5230VXmzGSOC5stQwqy7t2+s6y8hVeqUwiv4turg5zrwbhemOdsslf6h3KXY6icUaOtmHP3kdnNhVTHh8qPp0twMt/SC9tzF4kdxoSqYQAXQlrztvO1GyZPd/Xd7uUXRJ6KMtjXPBiDmz8chGpgCSlvfyoKPS3R/gmWRVTBss/PQCtp+lalja+pzx3+hgoSLJoaoDnNBWVVykqtpEd6qypCVezoai5sOX2crfyL5A5bhk9ZG7j0utqwH9W3wPU45xk0yDpf4Hj4mgpYNzQKIvze4H4ILpwx+wd9jT62uUlbu5UpdrE8NwrS5TJmlPzWhA+zeXDNkYZzhOjCplKx2xljqIY84EHeoSHtokTFTiuVv8KX2uL7lGVtF77GwODC4gcGClWYPWkeOsQ7z3O059Ca+K3smOsb0SC4SX0+D+yqkE471z6ilvnYjlkSKInZDQofvwQzyO5sPVercLahO59BspYI8bNoC0qU4L95snOfBdrVbH4EPuvaOPhp9m+/l1F3v70deTi4ElyQl0abd3jkkZ6BdGqJ+LO9p4OI8MQ4inefr7IE2T90kyGIEGPbNtR+8+y5QxRcQGVLyw8sg9vPhcrcqPF93XCXg2lD7aWEkBeJXQbSAEvIdNGx+sJ17jePO2A483tOTU/M2GAiWB2BExZHp0nBLARORoLKtai9leHDYlhbDXqcqLafc1fB8c2MddauYYu4Yg9zEUasNWDPS3Kc3M1ffblQIp25X9zbnae1x24vZuBZbQNhDvuWxo
 L+LWe0CL
 6LDF97150fO8DDOI4pxoKhQ3C1x79xwnvfIE66gTx0fee//0i56T4ry8/O6/lWodHKrEqvCBehw24AByk4orfch8HEU06UxPQbpWwJj45CJtgu3nJCh34A7H4pS47n+SMa/kU/uvNG2ZhbH7wXNFqBxIPIyIMv004KBZ6YKYT8xDCELRUYYOYm6h+O+Y18Jbr1gKSmIIuaKZMyyHS+7nMO1MN1UXJReLh5VhgfQ2pF151TrvDSaWGJcnbQzFKR6xY4aT+V7CnRtZ9h42pKSb8PYjafUv8Q27c5cQ1eI43eYMQXtPv41r68W5qKXljdl3bfgYPnmAtz51G3XnK1scgzkZ7+RzT03iFXcmaauhy9JFFH444ZRqBWlUZR1myKl7ez1KiLZrJtdlZqBrhizyasMxKr5vvwYGH77J1WX+1JfFWP1N1RzplGcTrLMc3X7RcRTb9YI52VP4rOKzR/1mo76IPmGKH/5IF/y/tiRKXRs0rQwYUgbHgxHKn2ZPD+tvx1/ZizkkTnohgIKCGmuMSXdEHn+aAmUiaXAnJoSprgYnxhHqDkiGHCJEs+cozzIrRNz0hz9MntFKF/lrNYbmfC1tUPiN/Akd52Lx6x7S4l8lppCRR/wEtZYhh5bjO0vlzb7CR2nOozaIcGuBOvtB0oorME8tCfGK4Jw/yrPgdJXa0Ygc7vqIR0Z/178w7rx3NHGkSKUTgoCkROGp4Gt77NpawqCBpd0UgFK/srRlRZWM6cCb4AcC4uJkzFBmjEynWhXU9l6G5+wd8ATR9duetBq3kFfcWyNZnzsIPfn2/+a71QlulpmNmaU5VMYYLUHhBM9pbmQ0Rgmi1GzL/tb5jiALZMZB5YeSpgGORB3ls88ugNxobZHZpuUkBpV0cSjCx6jTIyBgYbeTd0sKFn4tNnS24OdYgdsyWzHFm8w/+IO/SwXRJ2egRis8/kCw29Kj0Zol3PqSAoZsvj2MhaC6OwfLlmF9P
 LI/Jsrpo
 PAqwqls6/wbceyILIIflkv1ITK0t1cwIcnst0Ka+Ozi1BqF1Sk4wgfP+r/lOILOV3M2jvet0HOucXy18xnjEfs4QlY31FQpvMGzI9vBTz39q1L0+/6WyM4deqtCY2D52dgk2Yv5JXpT+0m4SBXTtMsJG5YKHfafd+ufR3+atuXbfHp2fZl3c2OzibGQY1gF0m2zxl9O7Lzl6XslmOfwyTNk3GxRyKnedKU5YPtaUl+NZ8MwwOvMazJm4FLEWs66pgqsQMOlkqfkwMaq6bsGAyu95XTBkOknShpPBCCgTuUyJq1xUjvtGDBK33wNx63IPryHERN/dMHyra5qxe2A0LPP4cz5hlAWMSBuNxF79QRkWPJarWgZnRdVrYC1oOvEqoxKO6LtwlIGOLctnNZTKpiaR2nRzJr74K52cz2ZPjSnwIW4Lr6E3XwDCWJzFqG15faHEqKvLh6rosqL/3qX0ULDcHLG2Vj3lqOpX7inK55lZduouSAsOI8q+xQvVv19Uzp1nNnPUbyIkHpKgBN7M7xjrfPwvionB1Lzzgk8fOsdI5V3yiNvF1+uXqzXTgE6pFBYVM0pLRR1SCZvCNczIz0X/MTh5pqBylnEs1DvOuu0QErb8H52ewuWPIw0wblm7AvlQ2YdBpp5XSBZulmPDVdkClnETwCKLgmSDU1twKvHkqGI7ZvTh3uRWi+ozz4z252pCKLxU8NZ7j5X9I58KGH4IRplKWO/s/4s+O6zcEqnEyw5PZI+3qZuNb4hLsubpx21bX+bpUkjufcvrXzqCxuiIkznjh8qxCZEWT3UdDxpqmb6gxx18cbLZy0Ny5v0MqLyrhc+HTTbmSPuC0Wbf3HKey/sGbPXdqZqYKpyWZ85RaRRK8+vEkXa8rV78AyY8pfGX1lytYOPoR+mV7GdigfOpQJnJNbUSoUcCF3ASNSoCqxOFN3Z0XFE0I76QoTWBpei60UmefV/4KXeGv+ppGM4QByiD8
 m1d6PN0m
 XK7Alz8cXMk1coCJj7ez5QYVEmYHc6pyJwnx/PAH4ahTnQEJm2zFMCMcPSOukpiCwWqTMFEVdOswXVt8uUo3gBGLwvw6j+4TCC2un40TVIFHDW5QpFhDDUgNRAUlWK1hA73ARp+1uY9pY6b6Ry2VJVWMnB57tiVit48BAqBhJsH5b+YdfLTyBQPPAQy1pe38yazBSnGNFAc2Du8hKYPdjDa1fwOEectHT0NyoUEGxNAbE7fIGqSOKE8naZjsdT9y0K8sJiaE3eJfKy11dy1bAaUJ+V2z9PPy+BEPksV1/A3FGJFjPc96bfwiK8A8k4qCCxyn3BzOMlef9XlhlIqz5e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe the newly introduced discontiguous kernel page mapping mechanism,
detailing how to use it sensibly and how the API looks.

Explicitly detail the various discontiguous actions available and how to
use them.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 Documentation/filesystems/mmap_prepare.rst | 81 ++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
index 82c99c95ad85..a476e1006bf1 100644
--- a/Documentation/filesystems/mmap_prepare.rst
+++ b/Documentation/filesystems/mmap_prepare.rst
@@ -164,5 +164,86 @@ pointer. These are:
   sufficient entries in the page array to cover the entire range of the
   described VMA.
 
+* mmap_action_map_discontig_kernel_pages() - Maps a discontiguous range of
+  `struct page` pointers over the VMA. They must span from the start of the VMA,
+  but may terminate prior to the end (leaving the remainder unmapped).
+
 **NOTE:** The ``action`` field should never normally be manipulated directly,
 rather you ought to use one of these helpers.
+
+Discontiguous Actions
+=====================
+
+Some actions can be performed across discontiguous ranges.
+
+Map kernel pages
+----------------
+
+To map kernel pages discontiguously, you must provide hooks using ``struct
+discontig_kernel_page_ops``:
+
+.. code-block:: C
+
+    struct discontig_kernel_page_ops {
+        int (*init)(void *vm_private_data, void **private);
+        int (*get)(struct discontig_kernel_page_state *state);
+    };
+
+The ``init`` hook is optional and allows state to be established before the
+operation starts, for instance taking a reference count. Nothing is invoked
+after the operation, so ``init`` must not leave locks held, and state that must
+be released once the mapping goes away should be released in
+``vm_ops->close``.
+
+The ``init`` hook, if provided, is invoked prior to the operation starting. It
+may update what is pointed to by ``vm_private_data`` and/or ``private``. If an
+error is returned, then the operation is aborted. The ``private`` field can be
+reassigned.
+
+**NOTE:** The operation may sleep between invocations of ``get``, so locks
+needed to stabilise state must be taken and released within each hook.
+
+The ``get`` handler is the key means through which the operation is
+executed. The current state of the operation is provided through ``struct
+discontig_kernel_page_state``:
+
+.. code-block:: C
+
+    struct discontig_kernel_page_state {
+        /* Map state. */
+        unsigned long start;            /* Start address of VMA. */
+        unsigned long end;              /* End address of VMA. */
+        unsigned long addr;             /* The current address to be mapped. */
+        pgoff_t pgoff;                  /* The current pgoff to be mapped. */
+        unsigned long nr_pages_mapped;  /* The number of pages mapped. */
+        unsigned long nr_pages_remain;  /* The number of pages remaining. */
+
+        /* User-defined state. */
+        void *vm_private_data;          /* VMA private data. */
+        void *private;                  /* Mapping private data. */
+
+        /* Users should not touch these, use discontig_kernel_map_*() helpers. */
+        ... internal fields ...
+    };
+
+With ``private`` being an additional user-controllable state variable,
+initialised via ``mmap_action_map_discontig_kernel_pages()``, and
+``vm_private_data`` being equal to the ``desc->private_data`` field set in
+the ``mmap_prepare()`` hook.
+
+In the ``get`` hook, the user must choose how to map kernel pages:
+
+* ``discontig_kernel_map_abort()`` - Call this to abort the operation, whatever
+  has been mapped so far will be retained, the rest of the mapping will SIGBUS
+  if accessed.
+* ``discontig_kernel_map_page()`` - Maps a single page, correctly handling
+  compound pages (if the compound page is bigger than the remaining pages in the
+  VMA, then only those pages that fit will be mapped). For a compound page, the
+  head page must be passed.
+* ``discontig_kernel_map_page_range()`` - Map an array of pages of a specified
+  size. Note that if the number of pages specified exceeds the VMA size then an
+  error will arise.
+
+If an error arises after ``init`` succeeded, the core unmaps the VMA, invoking
+``vm_ops->close`` if set, which is therefore the place to release any state
+that ``init`` established.

-- 
2.55.0


