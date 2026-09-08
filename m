Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC728C79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB5B6B008A; Tue,  8 Sep 2026 16:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9B7B6B008C; Tue,  8 Sep 2026 16:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3CB16B00B5; Tue,  8 Sep 2026 16:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC39C6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:11:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4DA31A0741
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:11:07 +0000 (UTC)
X-FDA: 85191688974.05.30F33BB
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf25.hostedemail.com (Postfix) with ESMTP id 31C70A000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:11:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788898265;
	b=iDv2NxPGfHuZKUfxR5TsGNJG7Ub2QqsHUD8NhAz30G63T+GmgxLoOpsAkDramPyq5wcZYR
	v27XPuGIKBurlZV6JsSOoQWewpYC13deJEqNV5RVEd205gsGl+3EFCNZWbzJgHNpt6KdT1
	mvDZL5lBX2/3vW5Ch6lEAlqW2KS0+Ck=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAOIZdRVUolP7m+UlelI9upMvAKcRO1WMQng4paj+jo=;
	b=LWUNw8eKtxmhqYRZXYHnTexL480dDEIG4VxkZ4b7NDCY6/GMH7u/3+pt5Qw9r3Fkwqrv4R
	q1EkncG9oehEug3Qv68Hl+h/6tCjpv9eKbXarwSbBoBwVqYhdJnHOuVPAFXruKGaFXDTbJ
	CMPnbkA2t/NFxHJivFFHh1lubEgR64M=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B07F61A07C0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:11:04 +0000 (UTC)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83A40140232
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:11:04 +0000 (UTC)
X-FDA: 85191688848.13.E7D390A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A78EE160006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:11:02 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAOIZdRVUolP7m+UlelI9upMvAKcRO1WMQng4paj+jo=;
	b=xcmqLVfza0dWTavnzLwZcXAGuZmb1E/c7nGKUuNd4Jems9mhu6ityvgeqrAT41NYKRFcy6
	7uPxi2FeD/bfyYrUjbz6gYbx2xicD7TLtJ6o8OsOE6spnRk5pUjLUWTqZlZLObg23Erj1a
	3n70pW8n8Gs3H6sWRDWgQfnh4rISSMQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898262;
	b=JlMEgNgtMmGDCK5x+MQuu5ttiJR/TorcdEhnhFa0G/rwzb9GMBNiesKjptDqlhd/BKkRkt
	G2OIWSMOYSFkS4SLzOm3up+Qid4itQsLYrA1xTEcSRHUcuY8MlXYhjBorc95SueY8+/ECI
	BVa7r2GwrZswDC9hi/EpVHQe6SyjV0c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DBmTdx1K;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E10A1418C8;
	Tue,  8 Sep 2026 20:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87EB1F00A3D;
	Tue,  8 Sep 2026 20:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898261;
	bh=OAOIZdRVUolP7m+UlelI9upMvAKcRO1WMQng4paj+jo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DBmTdx1KZGSkEDEcii/q39f+XKsGHraP4WDkgtAf8wP7TIpwv1k00mEV1lgAB96X6
	 JFTze709burwTzs4EmZWJxTKW59UStMjF9b+5Pq/Lw0FDWDOnISmKILxwphHTzdck0
	 NYLzka1VDWQ2LeBLzKL0rzVzSoiR2OSuPcjSVoWZF+h9mf3VEwi4dCnusX+02tn5Cg
	 tvPq8yx5jRtbNY1zcLwwRcQR3Agy1bwWAspTm8/tCJyhFlE5Boi+tX42B5bTjDPZ6A
	 yQZtgSju8tugLzrzGaSyZqkHEwhBQkT/49kJBGXUZq/yv8ok4BVaUEb2mm0eVTlsDn
	 XbXi3m4fkJPWQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:22 +0100
Subject: [PATCH 18/39] fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO, add
 VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-18-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2308; i=ljs@kernel.org;
 h=from:subject:message-id; bh=sqcIlbxY+dm7DeefjumELfmk33yU5orxoE39c7c7Zbs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG6WuGeiusTh3B7GhKNzFKZ+lurLVP6t02HKsKbr1
 LrfalPmdJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiZc2MDM1X7h7bEfPG8hxX
 Znxi3b8FT2anxu09dUQ0olb5GEfxgWpGhtnCvvW1dUf7J9q/y7h3dMnaZDdVyYW+xidVTbKZdXv
 c2QA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-HE-Meta: U2FsdGVkX1/hyk4GGlSyU+5LnpcWEvb2+Z3saITPfE/sUUSXlgsbijEdUmI4bFVNAtiNqL8R5/kd1VoVR8woPSKprDz+wNONQQrjmogEdq0SRyLEQ+KrLmYjiK7i8Lp2591vekgRTqOZi2cNJ0rLbskA/URIz6zrxJnsOu3ambXUrc2MEzNBXHceHgz66OESKu+l93y/0dLCxFUCB4noo2SguU8bvQBq8qybnDfg+5NgUdK4DYL8sxc3rFSOEJOeTCemA3kIlUiNoXk0tSm8XZWE6Q2KEHTur6TP9X02otT30qbR+BG+R8ZR1sxq43qMWqHV8W1tIp9lVOowIUL95CkDK3onKTRgTRtnSAGcr9Hs9mWvK2zlyBTLKpfhxAI0+PUvvFLio8vStW69PNMv5/kcxFSTSdB5em0S2sc8qC8WesSSNCi++JgkOT6Sckl0fIaAP2nrWs6xsvf8U2BToqWPgos8zoRt0SxTD+vo8VBmwxySvZE8yoVmfyzg/GJc8S0ft2XfsvjQk1FVuY6AJAAXiI703M6cV5vJoV7W6+TaAS3oxrdWe4m7IsCFUHVFmkv7VA9fHK7ArhVTPZR2QM9BUu9PPdwHcAfnZ990Wa53CptY7s7vi1XM6j6gHPaIsvneb4HFPtxT2EjvzlldffoZWHkSnDOc6x3bAonmPchYi1eUZJOzPYeLZ6GLU3xzH8NK/Hd7n9yT2Nh8kv4l30T6m4KT23HKy4jI+lzMgxD33zPsV77bxxWVzWSsCKDb8ftrwNzpffn4O8gYJoXKBMl+nrNjgm66cZtxwZYuPiatebg+3gAe/EvfSKYutQpUcL72OksHW6JLb8qDy+kpK0JVPFOrofgVuxyy5sEYP/8LxbqvVuMvQXRLAf2yOlS9qdWE8+cmGIBflHNgp0Nk0K5t2GIY3i1wx/GfPcFtK7jTnkGoq9tOPLdIC7Xvmm+3btW65OabvtZupiptyG/
 6rsqQ16q
 TSjUXPXPgVE9xBrx1zvbYgjBqy7tifm10GF9Nv/pYZY0OxkuDVzaYM7NpAmzHDDYK85Z0+k/0W6EdiBRN7VmBfFrZyCXmuyzqJSD/7y5V3XAXFIngZ1ttXcXdeSgSa1uqBjdk5G0xSV7LBltV1KpsWLYcxsdZtLjC1JXx9KsJGDlVow9I45RTdxsbry57zXjZCfu61BSWpfWL2smpazuS+Kf9yTyNaodYgDhL9umEdybL7aDLXaMOfWPQXQb44B6Msu7BMPYPqdLvZ85l8P+B0UdrYxzaaVgfiJqARZZ+gp2V/p89jmbc6/IDzUwjdPxXNIeExCcfzc4N9/kRv/hNn2QXWwB0FD4I2jhd6SWAEOexrDG7O0sN4tfhpfgGrJyC4rArMEpV6CLGSYnlYWmeai0ToRUltxQqbFQpR0ppUC2W48A+8m6EuMadXfC2Iw1Y0IQsfdjOtQGYnXOMC4Hs4HIwBiWimEkgeYBWSLdq/xmypd8JUj9ZOmvH0mcKpWbFLbqJ+pkOKoYAnGJ37Fl9UCFMN84rgsxIVO/awcYBh+WpAKTW1/9oF2QZIkrL1zT4c8HqGqma4X0lwpvZYL+OwKUX19yDOrgh4PDGecRxk+JKRKBxLkc7upiSq2oII9LqAAoFYvm7GquliTKFQja2ipFseVi+m5NSew8vVhiCINTWR/plF5rolwUAjmgLLQOK7myxh2Rk4o1I5XgYON+Eq0bE5kNdMHAFb5auDLVm9WCdgZ20bT7U4ycCt1aPna2nY11zQnZESCcUuHMjdwXlFbGS8n/TtNGk13A6L4lyh48ZyyuKQRNonFPrf3FY+3uM3JV9jVhiHj0MYJe/2NiYFPratChjn7Q7PCcm7tw0/EQNMCRQ7W+j8kckBj3NI+rC/NRCpPnh70c2zn92xBwq2AbSufGaBQMNgit843dDkmUvKSaQFrN85qPlmgeWg7jPPhhfB1WxX4clEQebA6N63wTjtyk+
 h8pwxFWz
 wZ5/C0KtCIDfz34+SpdjsBxfqqsdKD5SWmOoEcN8sgWY1kpQfOkva0Fe2s9kjsEtw/bL6pGAB78rILVK/zYYq43KgaC+wwg0xTtQeVV+AhaN6KKXpunbhMWHaHxtEZVefK2lJpFbzWa/w2/fcRBCdyf+W3SXaow7C33wMB1AEJiZDlVQVxKkcGlVUZUbYhU18HYvQiEI822PWd79qEDBAGFtxqAB5JM9aRa39IRLtI94hjgLsMBhluwdPYwJ8xS/EcAhhZBlx5HvEHde4SVQxWxWpQCflvnFBRSP5AZgTBhhVz95y1dwDDUY4yDy44AtxBZuxb1ZYA+NH71ZOvpbjxqDWy4HPJ7UTZ8fb7kBqdbaoqXQvDPpJAYFQQaDKT8HRZVXbdGtha0/hah798pg3IMuWZVwupCl3O8ZZA0EAh34lu43ikWW5wQZub2kC5hM5MrJBAGJ8kf61sUP1grLi1yH+16KLd9aVN4p/wwSIIeRNPi9QZnkct07A+wnHIaL4jkEarInbJT6erC3E6FiC67e/ZEpkUqGeji6+K1HPmQ9bsGivd+qLHBnEurJ3UiUwcXBOdb26ZKcjilVdp+bgYQo3SwL1UbOJrO1cFlUf5No6fLgJyPHHT3ElSnvKWdHfW/J6j42rqYkKFyU8kZq53+7lRfAECg1T5NUoolbP3+fpHVK+G00TGVfBu+PUfgfQaRXP+QwTNf9PkW51CX6+EIp6tjeRHu0yM8AFBbRXcyOIMFIPMELtzhSPGv3f9A/XyF8+E7a++fzdi77eFdeSF7WOo6ZRlcH0VdsAnovVurpVzhz9giTyYosFQNzMKuWPQc7tK7VKljXu6VzRiyihle8fgAr/rXIbZUT8UD5PBQ97JYWWgngCIM64ndbQRoY9UIcUagInLQ3YI/igobupVxxRhplqC1DOsGRG6p/AKj8ld4kG0bahg1osq63i7WLL2KcQCMoaKktDR6MZfxpTvEa/I+Wd
 F+eOc+me
 eqvh73d9c+PTH0lIKmYzX9SOkntc1Mmry0xM62lIH0rHJJteE2ZVU05GpmlYDKluNyWgiIwx1cuDLeKJIhCwm4CwxBf2dLkab4VA0L9wswDTsTmCejA4s13KaSeV/a0jAVaBiea4qIFgSW51x6PCGRh4LWFt/5m3GIeO5NDsI0v4AYG9LkNNz4+dLfRgKV7XPhRm68vV0aA5zMlPSn1Net9X/ZRfjzBStIUi7Mu6mqsWIUxRC3SP3GUDAy6iRofgwNJyfTvPGC0GSm8sLBMSow+YeEMCftxTOkwFkufNw2JaSLGlAJMkC81LL4rKPR87EX1fKtKSB6gPKft1fBPi2aeHP3PY1ia2xLIlUXwkAHeRxBiplfIk6OGigw/O0Cf+xopoeaoDtmrx0BX1tJg874gB7AaLac2C7e9KJKoo1H2hKDglxr9gjc6AqhJ3OuVVOrR4csXEkfGfNBNrgliufbbXsPAFcAhNiQtTeT56qlPdAMUz7NCXNK8e4M81nuVvHJ2Kprkh5oq8u9MzftiuY2bDPdULods7MQYMg9rQQEj9ZkDODuNk7HXsu+ZpgKVXEc7Qoe2a+AlVTEiT/kpamj57gzhSibSYmIeRjXbfozFbPB4p/+7IMWA/CP1DLVb9m5tAniMoh1QAdbnw/aSpGYkOqKHWZ89nigzWiwYdvxhAf95GyzfLFIMBLEfQEipBW4ak4w8uy8fX77XdFzAuxX12LazFUPbzGKEgSo+MlhSwA/UDLiUJ4G4YmobQZ4FVV0xcKkFtp1LWlMZF/7v3UKyOM1JTj/kNUF5zl0xJ2RH1FQ0jGMaEHwCal6gjHZuBHYyy16nBwENgcn0sN5FRebMQ/KE3u7/sS9ZvGpg93mxz8Mg2EjbBMZJur7nd/5pvO99w7weiEUIhKjjFHRnZgi3ot79s/QBb0LZfEYBcqJtnk5LZ08wfON3dWVAhvOTbL+LhOjyqD/VEd9YHMgG6qbb42TD7R
 Y+MNWEei
 sOQbfUjNYXgdVG3+86Gvc43sbdcU9R6b5N2uuJRtFTU9s8l1iPbyfna0aM03WriaPDutTeAZb4RQVmgSQ8zI/BYBgWYmSTwhIvCcYfKpCyB0J/996Dj1qlf+sOmPo21IHeKr3GYYfoyCwrvdlep4cN/FYs3NtzdIxJV+ESaMciAOt4FdrxruEiqJelg2n7BwWpM3poc9/kyaF+l+jq7mOxf0l3KXuttcOXQHem10ipNAuFvbz/T5kVxr7syl3QnFhMKytrIz8SFn2gLHs3eiR6MLd2ZuhsNtXfsEwkUkmvCBm1a+haZN3NFeOy8JYq8aBHMq4B87bzqG2sYvXfXkPX
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 31C70A000C
X-Stat-Signature: g1fugh8hiodi3cfky4a15ku8ptbctcbu
X-HE-Tag-Orig: 1788898262-972776
X-Rspam-User: 
X-HE-Tag: 1788898264-225940
X-HE-Meta: U2FsdGVkX18OIUt6YjaY/Xbh2EfIyS8dboJNQeE1P50AU7pfwX0+Urst6oFfxtSgvxgjqBsVjYonWNwlfZyYWOokSjF2Ksfn/GVoXv5Jv6vYkPgt6x0iF8J9GRMtxsq0vsOVKlF5JiMqTa6mGOvCSEudTSGE7rZQ316QUoL4+4hRDnXNS7tRkQ5ifEJ28uE15mQVQgwnAccbFGJ6sPyF7cdRLo/Qn5kph6gezTwMPcAfNF9JyVPyQAK5VFDNxVGt+mp53BzMbXZEAPAUMFdefrN67g/wfyxxWvQpNfHSkPjixumdEpEOLnPXyXbsXz9YFlafX4j2Z+UfJ4PpXOVgW8oxkLFNohDu7JNmBoS6CyvrfW3evj5724Wk8XwAau7F3awL5DsNWv12iLDjmAlxn5F6l8xEQ5hK2GWx4Sy/wgDrb9gEJLpjn8dRad91tnUSe1xQyBOk53j8ek6T9sMd+PspzdPy8KG/jZfebMpyZbCz3e4V68xjeQMcixQbTeGhfybzd4DNNNzh4jEzcK8h9PXN8wmM/9rpJgqBbKL0s6nJPeO1LezkPBPVQQbkOHxCCS/GqpplzoedDqwqb9V1nP0A2DO7URfhhG7ihm/rMEU5W7I+sot5l5ZWKUsibyLKIPhtcDBUgKw9xckUejOESArAdt8UXD3mbwrTduKL1fW/66vc1T1+KWN0aJOh9vg7p03XpFrXOiTt/fkJb5j5IW9pJYc4R6r4Y0QrSK5M2owVzhw+79qZ1DesgV7Wg2ofug/Q9wXwanIUXyEOK68B3xE0FqHPPmEE2h2C34jkTvEeG5uuTkF1lwAVupQGo3R2/PGW7J8PXJEfiOIBqPP6peV/vqDOQtZ5zYsvcB6h1FhNvY+2icZ6MDAkreNDiTrxCObQRR72k7m4fq42zrf7epQlhw2gYs9UGV9ZUmpHzIMEzp2ZcWYM6jT5FzwsQSs7bbsc3FDdqlloLsinsbb
 0bZ0MZJo
 XKD00P15qkkc02JNt5cuhKqJdY6oTfxGEyar0rx6HXEJ5KBgP9D2WPRci5cHpMjQNuCHn13AgzPLWApHjcMr+ptxXj6Xb3JxpW3NiUJX0wFTljhu7WJVeuZrPWzMfcRZ0C9vvLWsIACcBz5o0Yqgjz/OYCGH0TykkJRyD+iJvIGYSV7rtRR/nRRwQ8y8qHaaWQ7MajUq6w9C8wnA7z8l3/sWKJUW6dn2ByBsO8mETrUZpXGaK6T+9hfYPiqb3qMiOvkDzL3T1K8+o99o+r0NKm5NlDJ6PcTGGaw8kXltBy5pgM92cWdw7fG1XgDQ0HhvzQshicmLfvHuLwWw1v4A7KB6tzsX9rVPvfuMrmc0BRAdTMCdGN27P1sFpQX+J3s/9ZVaQqLH1lLA81vP9tXNh5Wx4nAt2cMZ9PIfhPX+2411GeE/JJV3QPdlQgMkymPre0rBUGX/ssTrmiMFBOm1JyMZ2A5Xr93d0Sf+YzQI2QUgKl0J0xHnHqx3TylKINpqM2P0rupBsU3fjZhegjbCV58tSIorv7trj/ApuMzD0hb6pqr0EUB2mloS1yhb6LcmHpnaHieR9UuWmo4TyFfzuqUxZsr11nekOiee29bbUX5T2McOIDeKMGLp5qJSF3O/s31bxeMqh6bA2c15kSVVo5my8gizsc6Gm++LPfAhrZ8BAFiyZ+H0iVM0QHFVV9nci+UxyzEcWmjHG7UQlvDAfZtJ0+M7IxXbqF8tMtHmttdh+YfptzZ308BaQ180zn7VSWbERIjP3WCwKFbcfmGYjvUTNaQG1wZkxN+xMHpbGjyETzsNeVR/iLtwBheSAmKA8yhVqFiY2JAw0OsFdD1f7dGYh0MAaKZz/Zdyqm+X5yTGPZ7iCO8JlxMWzhNK5pxmHwmMHG1gdDmQCrOYrq/208FFOvN2LrevMcarSUYkzofLnSUKBRvHQOhekXMC6hx6o6MMMpOjIxHeCvuMVvV0rocAsOqp2
 9sg3ImxX
 r5uNdib7ppO8kVIADN0Tlt76nZEcfG/QPPhNvx88p3qBCRI1bxOsxK20ue+ne5wVGXhD66c9PbSO73S1xHqcXIxJ1mZsSF/M+mm5rQq209mCT5rWlJ6o8QfTC2OwoFrWn+w4Eq5AkpV+cHGEAyhpe5W65uNtaaYP0sMUILQmdNtKP+Gqu2jjL5H7d9hl7bzeCJ0w4OtkBUv7zSVzuRVS0i7Xa1CT+8ELS27K69pX8TvAAeL/INJbUfKeLb23+GmNGIjClZPllddNYc3ZJO21LivNfH+BdQsJkJKwqfnwjCaVuacVAijrs2ouJdulArbnrmPLsL7hUFRjkKg5KIM7IF2fx8fK3ci5Pt45fDUzItNKt4KCFmLr6mWPFqEdBttKPupRthMP/4VGajI00lioaNW0NQwpMqHPFIWD5Np0pchdVdkrZx6a43qculA4KRGavppCaakER3GHdPRMJQACR1OI/p9s5xuG0b8zmsIuWibA+6zjhMCT7Xab8eN2yO1fO9Avd4naIfQkGFB3/UQ6cY7ZZRfz6xKXdid+n/jNEkrFRutJglqArCXIwmlJsSXQwFbFgBaq8mNUtCrSTfbdS4PWs6DBWDa42OTWKb/RrASXf7NW49jrCIFnVX9Cy+/1Z514OfXWNCaPdmViol19Rs1xvPTYTbQyEtcSDr7RcH38s/OV0ECDq1Ak81gbLH1Sp7kWpmHStYhiwE9cXeP2rwlkkNLhUw/v9nVV+9qfZO58Cf695fk58TeK3b01MZbJnSA1wD+xVc/OI7zKxo1tN62uvwckfIGsUNqtXguf21j5+3htuVcUU4ivNFuQj/w+rsCJ9HmjpPZjRN9+ZbrNOAMH+9BEtygyHQAyJmcsJC2NztOG/g8gm8T3e7GVhxZggD7hUAzQU1jo8TMsvb2g6K6JR+zAcSvvGbAHjxt3IbhZtQWzZQQ7LCHCTWP62pkAJHSM/+oQolaS5TTjp3VWScTquO23y
 Rf4yrAZL
 06ulLbtKoEUFmiQRw6waJL1WY3v1E1xY3ihyxkz8g17uCGzOEUxHqhkadMFyA/V1QHHJ5KDqYd8RwxXGDmz8apoM34bF2BORZ3mHDRH/EjLLwAkiAQooobCG+YfeczUU8CFEvD6Hq1mg6KzK3pN6T1i4YMXOFz7VmtxYhWRMIoXD0p3YSXq90ybpoLSqntmCMBNuCn2ewpHMBDEOpg0csr4zCoYd15bsDNdjBbEVXFozZU8VfrHyfNroOlyotY0bYt2Cri0uwnmU+xTKc+ZDmubzDLQoxP3TLzqtqMO3afxxLrT1kVLix4ukV4hm/DLB9Q43hOjOtrmm36LsUMhLXsO1f/147a3Gt0EMtTjEQh9OEMbQ8a4sYGMPkb6BqayUR/3DIblgARD/bT9UbaBZs3iirNMvG2xTFwFiWd2/wxc49BCOpoFz5b1bncUE5A4QkqWqnsS8DS+LiQrC1VumOsjLwcAda5x0FixPFIoQ8c9P9iAOfmDStTRI3J3bdpk0sYdwPGPX2KH59sSDyL7dIG1XtPZp0VDzuuf2izuDjzmV5arAU20frEJCHIuJkK8eRon1HW0NYdtZLCDLNf0Qq3Szs5oJbSdq9v5Ti+w0KCcWzd45lWbpGmQmA24P8F+JnEINXc3uElLcJ4OAMBLLh4lnNNaOjZQ02NnhTy0f+LzHL9ptbK3oUHRCGKRgBjFAftjvNLJxQUg/vTZp9gibz81TIvs75uRdMlwI7QSQQzJXKul2kFuZkzIXlKuLYv/zCnUILbypyMpTkCrjHSWfQEV9dN9L3P9nieQ8OBZHv3mb26XDvsGz3FCUgJVQq5gKbr9EOkBWBNsWrxd0hgFLq+kyaIwts4tCgpZvjvM+isNYRVi2UclTAw7bB1yrRy37wRKhJFWGaGl5/bJqO0NW8q/A2vMmNBQLd2bwLt56mA86vjAZ4qJB4KxBb6Hut795FjP9aiqbm9J8jY/uocyRaP3oQ/TKS
 cZFoF7BA
 erJ7CzFuEXb/6coZa7srgp/a/xTGLuwSY9jggDgdxjMeBSt2i9MdNr+qKZAC01uif++8zzoDBhjPW3kZDWErZD4sgVJtbMJffVXvbs026n2AOkA4dU+zfWIJhY+ZYb0EEdJWVPy9c3ADwj519l19KtMZu4SMS+YcHFxv4XGtnrpbl0MB5xRiW1A/amIWGIYWdtsrY18ffQr9PiZyZRIMIiqoL4DPSXn1Fn2jYDAA9jklMCuMN8ah5oGPXFxcQEhTfGxgrszNMyhGhKkDEJAU2xH8A547gbrFMvaEI7y6byhUw7AFmKHW9CRUyGmzP3B+FpzBa+b87QQ6TvqGFDgbFmhz2NenBGe04m+C6KnsVg8FKAL0oszj5Z
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



