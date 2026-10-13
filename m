Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8447ACC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F7AB6B00AF; Tue, 13 Oct 2026 11:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF406B00B0; Tue, 13 Oct 2026 11:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BFC56B00B1; Tue, 13 Oct 2026 11:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 493C76B00AF
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:10:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5EEF80A12
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:10:30 +0000 (UTC)
X-FDA: 85317939420.29.8CD38EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1B33D1C0009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:10:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oEQmDWyF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvNCVv407oP1J+2+2+/w7eOySEPm7czlapySWz7Rx+E=;
	b=Xypn1VGQR7Nf6tKpXNUithDs3N9I+ZUOC/GsgHDM53UtiqtqGi/ksXQogPxTZGFRj9Kf8A
	JbIHlY6SsHX70JJOcchgTFNuOqhhWl7i5eJOKOCpk6a8Ay8Ftte7eRMeE7nsyTvDDoy8LT
	rGExfdGCZxfiR2auX7azulVejWFd2xA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oEQmDWyF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904229;
	b=fjfiDfZqoUjpt1Ab4eWmYmKou124un88Nj/diNoE01ITz4bTm0Y+jOTCs/MgkVU0Y2a3Iv
	78LvAdy5/q7MGnhYCXliKtKoDBgg/racOOP1BjlnlrVxHiN5lk0aYyeD0FUHaD2oj6uYi5
	kdJ8DA5IGDhvX3N8IyfCbYt+Tvvlvyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7415B60A5A;
	Tue, 13 Oct 2026 15:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BB71F000FF;
	Tue, 13 Oct 2026 15:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904228;
	bh=cvNCVv407oP1J+2+2+/w7eOySEPm7czlapySWz7Rx+E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oEQmDWyFqtqLIYvFp16ZPd1LP9dOsh7yKMW/xLnlpa26DDrax0FYoZi/vfx3rkf8l
	 /EX7yxUYhw916xzTYGutga5drHDIBcPbvs+aLf1XlNjIIK7DQbTeXmFtsM/P3pdrwW
	 orSZQntjSN9t7e5L3g0LkGLPGSvd3719UpE2u9VgjV93sGcvd9DTOv/XkwDJE9VD2s
	 RydvH67Gwdb2HF+OpkQNQOYNGvXKYYysq2sHb1KRaaapNXidTQbelgJYubyO4WrxkK
	 L7ljQ26fPcFrLp89EuSUdhdYSMqC22czuqfB0sVTNy81b6HRWrxZdakKFPmbmoA/CD
	 xHMzWEBA5mGWA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:48 +0100
Subject: [PATCH v6 08/39] mm: add mmap action for discontiguous kernel page
 mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-8-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=14061; i=ljs@kernel.org;
 h=from:subject:message-id; bh=anga8ZEkLxXiNHXgWo7ZH5P8MagtESPng5PPsCIpWT0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZyomBF0MTrzy5OVb9oen14W/uLQfGUzjfexll3v1
 qXMlTW41lHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJLNNj+Cv+aAqnwGtzqeSN
 Gx8bvDH/eerb3PNJM8893GEvrP1guTknw/8Y57aJmy84VcbXLbLV9LgTo/DmiceJXi+j3xEBunt
 Vi5gA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 1B33D1C0009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: grp1j9ur4sm7y5yrf388gbqgcay7rg18
X-HE-Tag: 1791904228-726754
X-HE-Meta: U2FsdGVkX19iXiMBuAUHEPEvgjhS+4C4z96AzX3ySxbNUWBwhhkho0llsxa/tI2jkUaxsOh22Px1PjuMY8l+wnIu0IqGWLp+c+jojmIjkfqTF7q2RNqxs7Dy/MoJnCUd/oUU6w+CLc/FdxGA3hWDn8rQ//01iXYWOs/DJeH6BlmMQRNrPJvja/k1AV80jAWDCVxoPbJeOy9RYGX/8OEaSQ/o5qC0mRLLeL48SZ5dR6YU1iafdK6n7+0MQuQfWJLC2oOfKoVZRUNiIvad6J0k3iwFqBNRRT/+o6CrmcL4TjwDXS2+eklf6m++EuATuJ3mhcsIRKpXtcgAdjI5u2lYVlYgvm+JMuO4K8sS/pGI7ffdBvQVZrbiy8Ub7qxh0iloys1YwCSoLIBCUvQYJoBxI/HJ5psZcMVw1unzWMDJeE6gglLjT+XnhhxzE6xFzC9VC/ibSPBGscQEf5T0nJjmS37BTnD5oLdzV9TQrPRWjyZSNBpgCbsaw/aslF+47tdusbt41/InQl3kQaWC0ksR/0qL+WA+0cPT+q9ggtAxQAj8HfRho3XvKh2FZ4JVHPTqWQel84GGYt78rUqvA+LvTiVcWjpNygQw16bbEpInmo4UgD+3n0yYb7+GbpsZ5gBnyqIQfLRHvgpW66P55ILb5uzIqA+ej/tCkdC3VecCtVz93jC9Iubc3oiy+EQmADZonzCmwJtj2ec/R4O2FJx0LXQaYATpSg6RdmglPmbxTX/s7i5ALSbPQeGB2L3OQQ6mXlY2uns86ObveCUJ+YJECN2Yiq+2uBfwNhXtQxER6mysaL3ty/7sgXgUSzk7OoqeMXf6d3FgRvDlDlJ4/OdT3xSGrOQYYuPQ5sG5mUX+SoSnGbYsFXGnnRC7GN0RE0j9tdFoXgjjlypxJkF4Czn34oSFWXn8+WOdhd2eBosVQnF+oFbp006cKUH/uxqqlrGFBHWgueJ4WeUOw2TpRXn
 Ns4qV3+O
 8ly58XaZm9DIT+I0v1rjrWmkd9E0TCbd+Qk4e4doZKyWxVTK+QmUTSripJx6SGSoEvqCKKnbwkY2SL483gQvLqxFacMek2aiHYxyHEOPSJ9Hixl/KFXjiBn6bQ/i28CARxKJij4eoB8UF2Bx2CW9QIJpJwz2hXcumK9i5k0pQxX0WZd7Cxv/RxqGxiM4/tC+k5G13rPsVAJy6WmmDvOmoTPlLX8dRrW0G5P2gATjcI9mMQRghaizrQ40q3EbWlLQlc1XjMYjmcaVk6zPr1pSKB1xQ2bK39/AIivsuwWYI6f5kyUocp2uRC8QRzRYwpCagbxEkItmqGhaaHCKnnGX9pTd7I10ufxMhjG/w+hM2nzVRdWLXy2YKEa5GVJ/85JfVY0td55RvT5zF3GvgrfWCjcREZnj9g9NU67i+tPDxWKn439a1cdhtGmej0MiMxqyi+gUFcHW9ygBN6lMxiUT3nODH3isUy5Mlks3swWIGczeHj+bIhh9TS38zHWUmCffXk5kCdTy+y+4eWqssfdedb/tF2WO6pXopsVOzXCNeGG9TxEiUsy+mKrDbaz1sJ5o37VkrsLU14jxt/JVAvM/yHIUE189JUY1GRXp0AytiJ2LMHUJ33cYmgqLrX1JrGqupKyNCmgzSUq/Iu7pbFyNnPCMtN3AxSt/i7wyuTeMw3tuwGFjMejzN3V1m7/gJIr5c96iucBsdOgsa/4e+3UhmkvysaZC+oF/j4NeCewjKNEMQmpSOS5axaBF/17s+1Wp6gFSd6KdsffgwZ8NahpVlo3Q22BuyT7WvCff664wTv/Pqz+s5nsYv+iTYTug95CMietAi9z32ZXZXam/eLg9mPsGy7JWoBrXlkvGj6ktpKrNCz2EN1RFtfwpU6PukWBkBtY0MKxOt1YU1LwPuo7kqYe0GXIOGkFosTncZifgtsrLMoNouYrFqCVwJGgxPnUrfXNkXNCFPBdMfDzM3ES7cr/zR6MaH
 +69WZBDq
 UT1dqFEgfHv8EKU2I0AYzNhewRlgLWh3bk92tlNiyfKcQtAw+xQix2SsCtZISL+PCZ79J7V+BYhxUEzOQ83Bpv5G7bCOgTIO/0JNeXHhCZ0OSyiDtOjdq3PJqId+286U6wcvPuXy+w4+ZryMAFc1kZHUt/+oG6IVn629BvS2oroS3eRDPRbj50gM8J6DtpTtzvo6uq3KXdEnq4Yr+mZsb4quEhLyoXj4K2efgOij81aJ72SJrfyxbqELem2UMNtiVO3zcJbJyklTxQsuW0ke51r15ss/a4cHAtLyTrDLiPSX9RZcgHhGaXilnhGM7MfIe5Orp1Ja5LvRqcUB9O6f6YeM+b4Qctq/B2v9H68Sc7QNevIQNTjt+TjzhtzssGbpJhAW1UBiAl7wWLmA4q/tKLC5IcF0CsCbS8O9yNY0rGi12ONya3XGuqAttt9i0QuMiyB6tQ0rLBZ9+D42XGbjiOvxj8y2g/jQu7iZjs3nPvYy1E/8TMpRncREJ06gf9HSonYHx/RMJiwgjQnVoe33i+N7iEs1tfdIykhYmbEqB/0F/LYGmBd+f4xlPzHQvJTHX1QUNLKu81hNudqzUWCmWZzYdN/VIqmpMii/TWrIuDnt9ODkP1zrL8tae0G8NJlZEbs27o6wZ/5xTbJuGcWqUZIpEponrs7oIf5xnEkqPeNHE8ITw/O+YDBDdDJFM/QBH0rLelxcG7vMB8hom5deOX3qWEoEUriE+2imuuPH0LcgZgAgf0qu/MSSvdoMfKfFAIyC+FrizLUGDSx2JUEfsxb9mzU7ucM6wVrIBziF5c2z83dVtsJhXji7vcu+7opBMtkVXVBeHs0PIpyjeDYkIRzMZfZvT+8TEwpK4FkcIkF2ExMsnVT3t/NqUnOh486O8imAqz+GGNBaeE8TQYjcsPyQ1f/yae5IrKiy+lOEkTkz91pg6F5kR/x7PN6jPd0eiNV8LA3LVsKF5pHRZ81yAXRRaquSe
 iaVh/fEb
 NKe9y/HS82FJhF7DZ+CyeuOSQZEtFVnD5fCUH6CB4ol2ZFrIRs6JWkXtK8UztxyUy2BsgNpAFp/Uu/4zuAtJ3ci8wSfXK/RckeuWaZz1aVHEckvX0SyU4fWItVTwsaTpZhovLqfLWX9yQGBorlgcPxPZmjnDjfRnf5MrvXuIu3CIePTGI1bDL61z1aAoyYcXh7zcfCmIKzJAhbBBQWS/EsWo/T+VobWU4gSJ7YTEbnnQGs0jaDJcus8WjYtQzzC3selUSh3XG0LC2gM5gMeWNXzeXdpLSnl0rqO1upwElaR9T63wBMXNfmzTBaqGqDLBCRGOTqew1vz0KYdcKODiUfQBLyOyhII6V0U1bWgH27kIHUdi+R4Euz9F83SR/+0vXjUGGXsyzfGFCH+WQCVzNmfYW/HZ9zBuUt8I3nmzg/CPweqWFE9DFMwkwAr8NRd3ebfQjdQ1pNURGBy4RNFsrDWS8Ti5mLvteJV/hrizEWMoXyIapdUI0L5q/g+HKznBifr2iDJs/sATvCPbuAw2itxSP0Y/aYGBYIL+YQHge4SmJJoGFL0SOFuGVF4YqGfj55m/UlMa2YxmX1KK6vMjQ6JI9Li5Dhmy9PWfyVg5cZl4brqCGcDd3UQrOj4Bl/jZ+oEJ/k/NkqH8qaR5WADZEWhRSXBvzr16X1dNS87SX6tBwLCJoefRcDf8fub8D7BQWOXZzA6UBJMxEtaJCxBwu8spGFEHwhwdZQEzDTdwVXoEk4nN+kdYu4KjsnpR/kM982DJzZXfXFGaOUaNn05BzVntTVPLbZzul7fOCZfpKV82e67znFBEqCHc3KyARsHaLCDHoSasbRfMcKq3ou3rpooyXgwgj/Mz7g7N3wQij526rZQURqw10lodELuPK/diGjNLE6+/Aho7jYmnuJ+csXRu5x9F+wJR8qQBoMLZ2zjkwP+Fv10e8Ek0TNQ3h87wbdaKTLKWJtUwt6zCeEnSpH2gvJh7D
 phsLQRwf
 NLqTmjEGjcdbD7VDawu33xZyR9ZG+fl0dpE/RDi7gtIh/akplgpujqyktIWYjax5dhQRw+MFOOv5lmEO1pYsRKcpxHKRkT4kxpLlbriMH5L7+ZiZlCv07VMzKjRTsXYBGtzFdmx4Rk9fQVT9mkjIvJndRSXSGP6UcWXK9isHRad/XMVE/zxXdymXfpGEdscN58pHz950KsKyhIBL07qcx/6ZFu/kBAU+kWtnTjvKlvd88kSos8BnSloMVH0UQsySUUSOlAaxOB8JOL3B2r/SwniI2K1xAudOvPbROVP2Ug6jNF3R+ZmGRtRke/Tt0WzM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing kernel page mapping mmap actions allow for partial and full
mapping of an array of struct page pointers.

However some drivers require the mapping of discontiguous ranges. Permit
this by providing discontig_kernel_page_ops which allows a driver to
specify how the operation should begin and how batches of pages should be
retrieved.

It uses the minimum exposed interface to do so, providing address, page
offset and both vm_private_data state and a local private state object.

ops->init can establish state for the operation, and ops->get outputs the
pages to map and their count. Should an error arise the core unmaps the
VMA, invoking vm_ops->close, which is therefore where any state established
by ops->init is released.

Also update the compatibility layer to do this too via
compat_mmap_action_abort().

Batches may not exceed the VMA, but may map less than its full range in
case the driver wishes to allow the user to map an area larger than the
available data.

To use it, users invoke mmap_action_map_discontig_kernel_pages() with
initial local private state and a set of operations.

Users can then use one of the provided helper functions to perform an
action:

* discontig_kernel_map_abort() - Abort and leave the mapping as it has
  been accumulated so far.
* discontig_kernel_map_page() - Map a single page, or a compound page given
  its head page, as 1..N contiguous pages.
* discontig_kernel_map_pages() - Map a struct page ** array of a specified
  count, mapping only those pages which fit in the VMA.

The userland VMA tests are updated accordingly.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  43 ++++++++++++++++
 include/linux/mm_types.h        |  42 +++++++++++++++-
 mm/internal.h                   |   3 ++
 mm/memory.c                     | 106 ++++++++++++++++++++++++++++++++++++++--
 mm/util.c                       |  27 ++++++++--
 tools/testing/vma/include/dup.h |  11 ++++-
 6 files changed, 218 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a1f2d375cf7d..438ab06a4a91 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4647,10 +4647,53 @@ static inline void mmap_action_map_kernel_pages_full(struct vm_area_desc *desc,
 				     vma_desc_pages(desc));
 }
 
+static inline
+void mmap_action_map_discontig_kernel_pages(struct vm_area_desc *desc,
+		void *init_private, const struct discontig_kernel_page_ops *ops)
+{
+	struct mmap_action *action = &desc->action;
+
+	action->type = MMAP_DISCONTIG_KERNEL_PAGES;
+	action->map_kernel_discontig.init_private = init_private;
+	action->map_kernel_discontig.ops = ops;
+}
+
 int mmap_action_prepare(struct vm_area_desc *desc);
 int mmap_action_complete(struct vm_area_struct *vma,
 			 struct mmap_action *action, bool is_compat);
 
+static inline void
+discontig_kernel_map_abort(struct discontig_kernel_page_state *state)
+{
+	state->action = DISCONTIG_KERNEL_PAGE_ABORT;
+}
+
+static inline void
+discontig_kernel_map_page(struct discontig_kernel_page_state *state,
+		struct page *page)
+{
+	struct folio *folio = page_folio(page);
+	unsigned long nr_pages = 1;
+
+	if (folio_test_large(folio)) {
+		VM_WARN_ON_ONCE(page != folio_page(folio, 0));
+		nr_pages = folio_nr_pages(folio);
+	}
+
+	state->action = DISCONTIG_KERNEL_PAGE_MAP_CONTIG_PAGES;
+	state->__page = page;
+	state->__nr_pages = min(nr_pages, state->nr_pages_remain);
+}
+
+static inline void
+discontig_kernel_map_pages(struct discontig_kernel_page_state *state,
+		struct page **page_arr, unsigned long nr_pages)
+{
+	state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGES;
+	state->__page_arr = page_arr;
+	state->__nr_pages = min(nr_pages, state->nr_pages_remain);
+}
+
 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
 static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
 				unsigned long vm_start, unsigned long vm_end)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 9ca2ea3664bc..07efb336bacb 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -818,8 +818,42 @@ enum mmap_action_type {
 	MMAP_NOTHING,
 	MMAP_REMAP_PFN,
 	MMAP_IO_REMAP_PFN,
-	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
+	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
+	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
+};
+
+enum discontig_kernel_page_action {
+	DISCONTIG_KERNEL_PAGE_ABORT,
+	DISCONTIG_KERNEL_PAGE_MAP_PAGES,	/* Array of individual pages. */
+	DISCONTIG_KERNEL_PAGE_MAP_CONTIG_PAGES,	/* 1..N contiguous pages. */
+};
+
+struct discontig_kernel_page_state {
+	/* Map state. */
+	const unsigned long start;	/* Start address of VMA. */
+	const unsigned long end;	/* End address of VMA. */
+	unsigned long addr;		/* The current address to be mapped. */
+	pgoff_t pgoff;			/* The current pgoff to be mapped. */
+	unsigned long nr_pages_mapped;	/* The number of pages mapped. */
+	unsigned long nr_pages_remain;	/* The number of pages remaining. */
+
+	/* User-defined state. */
+	void *vm_private_data;		/* VMA private data. */
+	void *private;			/* Mapping private data. */
+
+	/* Users should not touch these, use discontig_kernel_map_*() helpers. */
+	enum discontig_kernel_page_action action;
+	union {
+		struct page *__page;
+		struct page **__page_arr;
+	};
+	unsigned long __nr_pages;
+};
+
+struct discontig_kernel_page_ops {
+	int (*init)(void *vm_private_data, void **private);
+	int (*get)(struct discontig_kernel_page_state *state);
 };
 
 /*
@@ -844,6 +878,10 @@ struct mmap_action {
 			unsigned long nr_pages;
 			pgoff_t pgoff;
 		} map_kernel;
+		struct {
+			void *init_private;
+			const struct discontig_kernel_page_ops *ops;
+		} map_kernel_discontig;
 	};
 	enum mmap_action_type type;
 
diff --git a/mm/internal.h b/mm/internal.h
index fc4e249e2343..557e629db8c5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1515,6 +1515,9 @@ int simple_ioremap_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_complete(struct vm_area_struct *vma,
 			      struct mmap_action *action);
+int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
+					struct mmap_action *action);
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
diff --git a/mm/memory.c b/mm/memory.c
index a35cca09eb71..1a6bb0aef8cf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2610,17 +2610,23 @@ int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_pages);
 
+static void __map_kernel_pages_prepare(struct vm_area_desc *desc)
+{
+	if (vma_desc_test(desc, VMA_MIXEDMAP_BIT))
+		return;
+
+	mmap_assert_write_locked(desc->mm);
+	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
+	vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
+}
+
 int map_kernel_pages_prepare(struct vm_area_desc *desc)
 {
 	const struct mmap_action *action = &desc->action;
 	const unsigned long addr = action->map_kernel.start;
 	unsigned long nr_pages, end;
 
-	if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
-		VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
-		VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
-		vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
-	}
+	__map_kernel_pages_prepare(desc);
 
 	nr_pages = action->map_kernel.nr_pages;
 	end = addr + PAGE_SIZE * nr_pages;
@@ -2641,6 +2647,96 @@ int map_kernel_pages_complete(struct vm_area_struct *vma,
 			    &nr_pages, vma->vm_page_prot);
 }
 
+int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc)
+{
+	const struct mmap_action *action = &desc->action;
+	const struct discontig_kernel_page_ops *ops =
+		action->map_kernel_discontig.ops;
+
+	/* At minimum need to be able to get pages. */
+	if (WARN_ON_ONCE(!ops || !ops->get))
+		return -EINVAL;
+
+	__map_kernel_pages_prepare(desc);
+	return 0;
+}
+
+static int apply_discontig_action(struct vm_area_struct *vma,
+		struct discontig_kernel_page_state *state)
+{
+	unsigned long nr_pages = state->__nr_pages;
+	unsigned long addr = state->addr;
+	unsigned long i;
+
+	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGES)
+		return insert_pages(vma, addr, state->__page_arr,
+				&nr_pages, vma->vm_page_prot);
+
+	VM_WARN_ON_ONCE(state->action != DISCONTIG_KERNEL_PAGE_MAP_CONTIG_PAGES);
+	/* Contiguous pages - have to iterate through each one. */
+	for (i = 0; i < nr_pages; i++, addr += PAGE_SIZE) {
+		struct page *page = state->__page + i;
+		int err;
+
+		err = insert_page(vma, addr, page, vma->vm_page_prot,
+				/*mkwrite=*/false);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
+					struct mmap_action *action)
+{
+	const struct discontig_kernel_page_ops *ops =
+		action->map_kernel_discontig.ops;
+	struct discontig_kernel_page_state state = {
+		.start = vma->vm_start,
+		.end = vma->vm_end,
+		.addr = vma->vm_start,
+		.pgoff = vma->vm_pgoff,
+		.nr_pages_mapped = 0,
+		.nr_pages_remain = vma_pages(vma),
+		.vm_private_data = vma->vm_private_data,
+		.private = action->map_kernel_discontig.init_private,
+	};
+	int err = 0;
+
+	if (ops->init)
+		err = ops->init(vma->vm_private_data, &state.private);
+	if (err)
+		return err;
+
+	do {
+		unsigned long end, pgoff_end;
+		unsigned long nr_pages;
+
+		/* Default to abort. */
+		state.action = DISCONTIG_KERNEL_PAGE_ABORT;
+		err = ops->get(&state);
+		if (err || state.action == DISCONTIG_KERNEL_PAGE_ABORT)
+			return err;
+		nr_pages = state.__nr_pages;
+
+		if (!nr_pages || nr_pages > state.nr_pages_remain)
+			return -EINVAL;
+		end = state.addr + PAGE_SIZE * nr_pages;
+		pgoff_end = state.pgoff + nr_pages;
+
+		err = apply_discontig_action(vma, &state);
+		if (err)
+			return err;
+
+		state.addr = end;
+		state.pgoff = pgoff_end;
+		state.nr_pages_mapped += nr_pages;
+		state.nr_pages_remain -= nr_pages;
+	} while (state.addr < vma->vm_end);
+
+	return 0;
+}
+
 /**
  * vm_insert_page - insert single page into user vma
  * @vma: user vma to map to
diff --git a/mm/util.c b/mm/util.c
index 1660910e2a22..5b2e1ab4aeba 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1401,6 +1401,15 @@ static int call_vma_mapped(struct vm_area_struct *vma)
 	return 0;
 }
 
+/* An mmap action failed under the compatibility layer - unmap and close. */
+static void compat_mmap_action_abort(struct vm_area_struct *vma)
+{
+#ifdef CONFIG_MMU
+	zap_vma_range(vma, vma->vm_start, vma_pages(vma) << PAGE_SHIFT);
+#endif
+	vma_close(vma);
+}
+
 static int mmap_action_finish(struct vm_area_struct *vma,
 			      struct mmap_action *action, int err,
 			      bool is_compat)
@@ -1412,12 +1421,13 @@ static int mmap_action_finish(struct vm_area_struct *vma,
 
 	/* do_munmap() might take rmap lock, so release if held. */
 	maybe_rmap_unlock_action(vma, action);
-	/*
-	 * If this is invoked from the compatibility layer, post-mmap() hook
-	 * logic will handle cleanup for us.
-	 */
-	if (!err || is_compat)
+	if (!err)
+		return 0;
+
+	if (is_compat) {
+		compat_mmap_action_abort(vma);
 		return err;
+	}
 
 	/*
 	 * If an error occurs, unmap the VMA altogether and return an error. We
@@ -1469,6 +1479,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return simple_ioremap_prepare(desc);
 	case MMAP_KERNEL_PAGES:
 		return map_kernel_pages_prepare(desc);
+	case MMAP_DISCONTIG_KERNEL_PAGES:
+		return map_discontig_kernel_pages_prepare(desc);
 	}
 
 	WARN_ON_ONCE(1);
@@ -1501,6 +1513,9 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
+	case MMAP_DISCONTIG_KERNEL_PAGES:
+		err = map_discontig_kernel_pages_complete(vma, action);
+		break;
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 		/* Should have been delegated. */
@@ -1522,6 +1537,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
+	case MMAP_DISCONTIG_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1543,6 +1559,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
+	case MMAP_DISCONTIG_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 023ad6092e9c..a6a8e53c4b38 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -457,14 +457,17 @@ enum mmap_action_type {
 	MMAP_NOTHING,
 	MMAP_REMAP_PFN,
 	MMAP_IO_REMAP_PFN,
-	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
+	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
+	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
 };
 
 /*
  * Describes an action an mmap_prepare hook can instruct to be taken to complete
  * the mapping of a VMA. Specified in vm_area_desc.
  */
+struct discontig_kernel_page_ops;
+
 struct mmap_action {
 	union {
 		struct {
@@ -483,6 +486,10 @@ struct mmap_action {
 			unsigned long nr_pages;
 			pgoff_t pgoff;
 		} map_kernel;
+		struct {
+			void *init_private;
+			const struct discontig_kernel_page_ops *ops;
+		} map_kernel_discontig;
 	};
 	enum mmap_action_type type;
 

-- 
2.55.0


