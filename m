Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C06CA5FF0
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BF316B00C9; Sat,  3 Oct 2026 12:45:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996A86B00CA; Sat,  3 Oct 2026 12:45:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ACA36B00CB; Sat,  3 Oct 2026 12:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE2A6B00C9
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:45:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8F25C09C6
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:45:32 +0000 (UTC)
X-FDA: 85281890904.27.27E69C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3860B1C0007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:45:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G5/FVDQf";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25TcrP5NPlHeICyKz/Dt0wvN5LMoYnpbWYR4UkDCBe8=;
	b=XJa2a3vf+USuQLYCOG5C8ijtixesgL57anNcYMl7kyOU7TVo7XuTCHRVM5AfqiZsV2PV8G
	gbeKOEbUemRy5pCdN5SE/k1HKj73BeryJR9I7O/p/XgNOBkr/FiYJLAD5vYT149kgKdwFj
	HT3rO1cUmGQ5ciwVNJ7wyeZwBc9ykos=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045931;
	b=pAiDelmeHbPYsi/tMjahDqnZDHkSn/v41ZJ/7BRy7BHL5KRQJ8Ea5GrLinLYY1+ZY5mABa
	9EXAZn2qvcQCrVpFfbVm4lsPgOHkCtPR6C9YrYcopQ9xdii+7Rk4PDSWAL8m5yzDKiw8Di
	/wWrUFjZwL/gP+X6OJWUxBNYsNX5hMw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G5/FVDQf";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D267E60D82;
	Sat,  3 Oct 2026 16:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED621F0089E;
	Sat,  3 Oct 2026 16:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045930;
	bh=25TcrP5NPlHeICyKz/Dt0wvN5LMoYnpbWYR4UkDCBe8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=G5/FVDQfvoYTJCzTLSVTkfA3W7zXwd0+P4TlSS4Sakw98qwGsNVohk4KgR0qpap7R
	 JEGJY2oaV9CBwe5J/PSnX+GFlZK9j5jfYWwRkMG6jzhslO0Jw/wiyzHIvhI9WmHQOw
	 NRkKO8oW0oTqXH/QYUTClfraylv3NBBqB1N+T4LiRhScknf1BO0dspa1JHNXeq2NKv
	 EAWaDillk4LcTTAkJqVEp+IZblnJndxzr+akIJ0VdMAAhNwawII50EBZJo4hLQkHnJ
	 VqZRmJ12Pf75sQWqOZFILOO7IGTYBAwkSHV+QlvXBG7xLkzEC/uDx9xWnCQa3pQxzI
	 n4zT3xlJUuI8g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:33:06 +0100
Subject: [PATCH v4 35/38] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-35-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1717; i=ljs@kernel.org;
 h=from:subject:message-id; bh=iFGL+FHCILhy9SDbSepqrBsRxsucMM51zxGaU7Q5a2U=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6ukU3YubcDL78qIwe4d98U4MB2oO3N5t5zhBNjV7/
 uMNBz7yd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAi/U4M/+NvfD6g8uz+5tWq
 okdq+fc/1f5/71xWzM9lb7LmGwY/0nrPyLAmyr8/4Y/fhKqpSgeq5uS98lS0YFwQsEBZe2O2vfC
 Gy/wA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3860B1C0007
X-Stat-Signature: a71kxk5joxd1jwkfc6q4y7t1g8mup9a5
X-Rspam-User: 
X-HE-Tag: 1791045931-991738
X-HE-Meta: U2FsdGVkX1+s5rsNtUjkFM4NUvsh8J5AQVs7ibClYKyYJvdH1CzoZCFQNIZXg8JQKZue7iDQtzt78KDpUCD7zbjB8b9Sg571DQ7VMn5XgjDQ1hAVmNSu9Nuip0CnYZeO7Ehqm8bpTwhfBGx5T3OAjqr9UK6xQngmbAQHFGK/0QNnoIRWzHZmtROXbUM1AH1wGKsl04FXdlC8wJ20ulnVLpbw+S9kQtXuOjeQGznX/oxJ7R2mIAeGxKc1BRQOE6es2jzPRBwnbikh8QqzGyNaXYcx2L0A2wQCfHDlMgvexxTMBlKRp70h9J5Z25n88z5TUqt04uFoosAWhiPjQVd4nRy1HVLHH1oqFDtxwGC9RfvD8tVmsAwmnfNpbEJ8EdEGJ/R6lr5Wknzkw+LwDR7XEO7fASnBIJuo8lbiZWilAHaSsT0mm/GtSKekz0jewHvRVExrytN1v4gX0aB559H7SeD244ph35/dj1+CvNtbtva4cCGzpCee9kYk4HPsYgdAoIkpsFooaakrwOTr9GQ4DkhIObifuNmWsZmvG1PUm5FRBPr54HdKgyp/bYIQdbapiFuAczv1Y0NIGv6G20BlT2tfOCLvktO66mwcNkSXo1i4uyWB5YbmHzfB5p+2e14evgMDR4aQZdPlbrGKfBNDCH/HPD8zulG6+wMvpthIDRECJ+fCuxCZl1I82lfQh1lZ5RfcppCdo2dAJsE45tYLC/DFotdr/wemjCn5iTmlV4rtymrtx/Hrc7jfeGguXeoxr5vxAfSDL8IoP0icMbpcRp7iIO09W4cWH6S3MlWODVnUBOYjM+qIMwtNB8INSlzNrqAU+BTDwtYTMzRQqDdRiL/RYHOcmj0YZAy8I5zQHCGi8WSkZn3eJAja3IOgta3+epLsLUEwdYA6imKShr3hNaG7cAktoJjwgl4qjAdVz0mlGx7+KfCoUxoROSTtk4UFoGf3o7jv9pn1R2OaVuQ
 vcxkyak8
 RfRxCj4Qb2dcY2I1V5Q8Sk85Jdk5kVEbTj3i0/sb9W29gnas8Or4H7HLM0nUGS0W0/wmeLYgrFbwQCzHO4G/foHaIgoolDIf5QUVR7Xf75mvMGSpkJHliQfuXZkgtx4xNm3Z4vLYPAxW1JPpTXjytucukUsQvjGg6PQ4LTb/EZywEfMAm1qeL+wAwbpTk9K6UJ5LlAzgv2cIp0wLUSgI/KtRC4aCFLk6jIDnpJR3ilri/Kc/t48qJI8+ITkEON3KpOx28qYnZeStkn5VyYf0f3f18kKGrnrl0eSUz6OnB1TcLMk+ZFP4AkZ12AgHOZyD0hqivNF4JfJzi/nl7EFUEgx5AXiGAMkFoD3k/5Eia9vWYtnRvoYHG08cCy6h7l+UkpKvUcN2b1tFDTeWD8tjjus7VMXo/hQ5luN3Lm8DFCPyAg/reZqfNpQJg6QwOGjFLjxEEymT+6NDMuQa+mMysWrTWmTTdyfUAbhwXVsp5sJRSe5lmHCCaeiTTMn6eUj2l1jNibr3/WQwX3Ifr062lNMNRy6ONPXzrjMDfD330R9rI4+uUOVSBAj3fbPZSMLG2oK7cUsMiQ2YVBs5xJmMLRB0UJsylYR3NIzi+xlDW9LexNzy56HaZdMwG6Vq7DY+fG0FLKzF446Dz1UyZOO2B60I22zPC5HHaWPzcn6D3k2Q/qk9b1M2lOvzTV84X3P6AODhoO5stcZrZXfZKF21WpSjcs0+7TPs+JfS5Vmqg73tM4Mdlx8rJf/ih6HhJo+80Q6Lc7uDrlR3Xkq9BQukmq9pELJuVsIGggO1enWld6mI5dmDVt3VEMIV1Y93d6lHkkp0XEP3W9l7BimSnliNebZbNN9a+swoGtL7XmT6B2Z3IeIC7PWjCloHY0Xl9Rk0OLNcattlwYbXUR+vgvHGXAnrNCyNAM+cDYmPcWYo+VUNmicR+ekqC7Ex2VZVIC/OrRvF4qr/kSxKyNSzIvo1W76H1eB+q
 N9+ILUe9
 CWJ5cZBhajUKSFwymTDYbGdcIqe8VkEKLTxU22A+MzmYEssYfplkCN9y97E+M6cl4QgWAKp1vPnRuCIWnTmQ16YIl3t+USlI0j3YD4QIoZo1bZ/UpVacL4N0pYIBNsNtT1P4kwLHpMqhKNE0I5dDipE2IktvgNPrJmzBfFZTFcesAN865aBKiS1G1N8eF0uPEqx5AeCwEnSaoBp+KQDTYemJN0NxCdKC4ZN7hl6QzIg+wJbLpucLn3G/T8sQ9qST0kAgdaLa4qZT5B3MoFLi5rg483gSDuhcvXbPYiaDiMaHDZsXUYEX80lj0zTO9OCp9hjF4mFRWv5K2ASyaCuwmbQEtoM6+G97JS/WFxpWtO8QMNrTWXx+pHvm2plhG+DY2HbLhUx6wh82Pa4fk308g0Jx23/q0A0z1kOrnVcwhlAxOXTc6Fw0qwrRZcJpYX7fDvRJ5gNwDqSqZwZAK4MaRbVCPltE05nQCoMb47gty7//Oqj0RQh8ljpOazBkYZ9XYgq7xhgVkfoQ5r7h81lsdXiWC4T+upJxxjgv3pfl7aDxgRL3s+ugJJ24/7oqGGDXF7d64/MyMHX5v5WARj27dOmlIQxr4PhmMhjADkyRdhQ4ysqEofCIR1YcKrGy67YYyWhQZKnystky1cYwsdlzWXSY3hC+1XKJp+hrQDLXr5LzL92K39DxGWFShyb6vREWwi2CZi+NiRQhxOjhdgGxvTZUAMvXhmChCoOYlVDZkw8TFR9jqA5+xkKKx0J+lWXd4e+qd7HHuBzP064DGrG8uYq+KhWXsC+Txxx/dNCixN48hrB/6IbijPnZmGD2R7awZAIVatLPBBUtqsS6SCG604Ab2qzwM+JkRqEeVdZCymsPtb/i3oshiZ4S5GzqjcIljChGf5B6levUInOb6fmE+vd/0qbfGHzNhxEOzFEEvELmeZHKrPcWHEkULMvVdzd0F4s4gkeZFfvHtYQHwrH6DLNSqL9oD
 1KR0o0cf
 lPNN9K2eUdOijOaGLdfUQstmP50S/hxdQPpxPe3jJZNgFd8HLPPP+dacT0nWvniSkihf+B9zf7RQ/B3xA1NTEpRp8ZGJW667Cc+P+dnDzZkzLKxh5vNexHUUi3Xroh2Yjb45ZqfxywGLdjVmNJxM1y6ST1hanUQino2wgx6lrspgvI0vx/N0wRo8rezXpn1XLxlYE6i5NXVgGe+S6ARBE6Y/8wmmt1kRHQvaw6h1ICry0TmVPdH7W++ADt3/XKXtdkUNbLPYw2s8Ow6WCKdbjR8sLBtbmVs5les8vEh+CiUTlMlVJvMcVhNKt+v2f3ROa/Qr2iS51AY8TGhCj1SqErnr+T/Y7oNVuuSxaTewSfA1HjKssyIijMV/X11rMftMH0jR51/Q/QWanYQi4Ky5+JDTmqnPq5ODgo2RbVUjC9NwJqY0FQY53wajw4wICcE0WDb8DQQ5G7LTmLNJEG/I+cR7jxu/tAMfLlMa3PIy+mipkwHf7QON8ObYmk9ZuekohYmfKJ/aT1Y+C2ZIwICP0fs55uN/+de5k3+WJuzf/VR2WMvDjxsCKNufbIODTk/xOWkZdVPO8XAHUAI9P01aylj2cpClt95JXCylmneMm5LXVItGqWhDYgVtNXqGauucQzu6GvklpLq+H2pS56cyvQowzUUfkhMN/2Eu7YyEgWUv6PwR3QLb0E8GQfVS34MJdnFAAwmhv2kMj4FbLZnyrBXvYl/O5+eBv1BUmZ51R9siHgcWwixtmO5G97i5Go917x5ZdJi78rkw3LFm9bFxxvQiE48hxp+Xq3YlbdfEaM0EJXqUff7+u1VNX5JKYGQvOQJOANNUhthN9k9W9Ho9WVYfOr8iJTgY38kCg5Bap/4IoLKjynWk0yE60fJR6fekhIfWeLqepbiUkGdh6PsYTuqBXVn3k5iZ4d+QZsoqC+OdgSkifHTFgXG4ZB+rND+pg9sY0rkt8i56lZCoxRTY6cbryO7it
 3tXDBLvx
 9eJYTiIsM4sUh/ieSsYdxk0rzqZGPHgijKCczldGVHx0rTD9aDElQTE8rGjyRvSpLpka6Z5XNyJv3eUgOpx2Eckl1MV/UaRBTZlFK5xFvjl6Gm8G7vtznlIO4ZPoTpJrEAbFqHCLd+QW8GjEEqI9EUAcvqdh6r7elb5s1LZ5aLFI6ufIixWLDUAMJplnV/DOECWR34g/yJ/wgZKW95XpGI/WrTZymW9ALRb8sBUJ/AFO8ZS8EoGzdxArxDpkY/uhhV2emfZl7fqALNXYB1loTuD1Y9GaHspoPQPI3DXlghLMpkcKwM7fgp/WpJ9a6HTWgBXqbtzs1w8TN2aLnFSMw2F7fFH0U85wTcc8A7g7Gu4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have the expressive vma_is_mm_managed() and vma_is_fixed_mapping()
predicates, use them to determine whether to proceed with migration. This
drops the VMA_IO_BIT test, which is safe as mm-managed mappings may not set
it.

hugetlb mappings remain excluded, as they are fixed mappings.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index b9c453c28795..289d7b08ace4 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -739,19 +739,21 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  */
 int migrate_vma_setup(struct migrate_vma *args)
 {
+	const struct vm_area_struct *vma = args->vma;
 	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
-	    vma_is_dax(args->vma))
+	if (!vma)
+		return -EINVAL;
+	if (!vma_is_mm_managed(vma) || vma_is_fixed_mapping(vma) ||
+	    vma_is_dax(vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;
-	if (args->start < args->vma->vm_start ||
-	    args->start >= args->vma->vm_end)
+	if (args->start < vma->vm_start || args->start >= vma->vm_end)
 		return -EINVAL;
-	if (args->end <= args->vma->vm_start || args->end > args->vma->vm_end)
+	if (args->end <= vma->vm_start || args->end > vma->vm_end)
 		return -EINVAL;
 	if (!args->src || !args->dst)
 		return -EINVAL;

-- 
2.55.0


