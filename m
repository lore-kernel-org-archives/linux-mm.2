Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59B7DC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651086B0098; Tue,  8 Sep 2026 16:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6289D6B0099; Tue,  8 Sep 2026 16:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 517686B009B; Tue,  8 Sep 2026 16:03:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27C6C6B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:03:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E1B51606FA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:03:56 +0000 (UTC)
X-FDA: 85191670872.13.628E835
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E38AB140016
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:03:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hOjkwIOp;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788897834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MgpJM0gxrPMK2aMmTEHBRsRtr8Iid1PSeEmXNGIS490=;
	b=fWIIMQEEidMLRWDm5qa3nbEL7ZLvG48hdO7/F1GqjVtqgTAdoFKSC9o4j1K1OIGOMwU6aw
	ziV3ThzAH+efaAmsTh1EpWoFBgnakTodgsni1j+U5ZyQ4sciGVdj19/CXRZuuTkBytItYS
	fiHAQzvJxqmiWRxOzoUcELrThP78lEg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hOjkwIOp;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788897834;
	b=p8Nz9wNjNHuz2mmsBdGASD2mCb5qikqqZBK3I1pND5bj69+ZV4UIdt8z2Bh90iVUZZt47j
	myOfNnVeYjoqQo+5pB/80ZJCNeKqAg6lOMlXobdobwaWXBFuRA+CdghznBTae0Fqn0iAQW
	oVdyipvqNeip0CPk3lLV+u6Ity+NHqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57178601DE;
	Tue,  8 Sep 2026 20:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F831F00A3A;
	Tue,  8 Sep 2026 20:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788897834;
	bh=MgpJM0gxrPMK2aMmTEHBRsRtr8Iid1PSeEmXNGIS490=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hOjkwIOp8261HSQudpZOV7VIYvTA7XH9us9Kk3LrjL/r/quuZsXNP9F1SR5sj03w5
	 rR3FdHm+A3cEU0nLEmaFE1HFYpBiUTZ55tQVCe4ZHDPAwpaw1MMk32GGM+xgo1yRtX
	 cllgFRN9A/8Y1Q+5BlqUC2hi7lvpsWXFcPTui3eJcomosYvQPH23D5WW0ft8peuf+o
	 7gI+Wb4p5qe44OvVmimJcS9buxoeyKgNnpBgYDHXf5FDIELwKCKq26u3o+HJoe1may
	 vK07AIq6FGFrDOEO08B+PKytMMezgzu/sjfrxRawONjtA2CV/BOhQPHVRyGURmjyU5
	 vbXLNvLgH1mcg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:07 +0100
Subject: [PATCH 03/39] mm: consistently validate VMA state after
 mmap[_prepare] hooks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-3-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12573; i=ljs@kernel.org;
 h=from:subject:message-id; bh=lWoC370i/kohl/sqj0NKxzbsOFNUopCPVYoGOeoLoxk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG6w5n9ZZHGLs0do4aJHwoWPvy2V03rz1GZd6xbl5
 Z5iLyYZdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiy58x/BVY4a5nzT3vhfMV
 /gD29wvOSD00/RRQn75U3dVWsCCp6Q/DL6Y5jZkmMkvfzt+txr/bvWrSi50X9s/WNZ3MkFnVsPG
 4KhsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: ya5tm5aqkux4444x5qx4wau4xgf6x4kb
X-Rspamd-Queue-Id: E38AB140016
X-Rspamd-Server: rspam07
X-HE-Tag: 1788897834-333831
X-HE-Meta: U2FsdGVkX1/vA8atKm3NwmWnNU846RhZEJDnhib1hfT33M4Yjo1weg2dppXD0Y24GyM+kazALvdZap9u/R8MzqifoOf5319wHHmPSs3gyNPAxnObCC/5pt8mO/UyYGUV3ZJSBCcYNppeaZnOH9fujSPOlFJxDfL11FdlNPuGbJjaJePj8+5WdBgLmj6Hkt2FhZ44Z2jT4JkM88gCEB69McbvGI9mSpAJOTu3cws2nD+OcJpnc2BhrNc1alemiUc8OQvBbF7CSvxWJ0IGO5CTQa15D7zqINlkLR5H8tzaF01upvCGqkk7zZMSzIl5tYxB6mcu/RYlXY5OLMTthxltVEniI0iFwnt/ZmyCTaP4YVZSARXdkr3SjK78ppUDtBwEVWy6jJPl9uNCMY4yNp3aBD/9hWU9EmY8kCSYqYbh42GtB+P6U5UkMTcuLWRaSzac/4vln4LTB/mdHWTEMOsfcAMSdGKpfo7k2XDvPbpqO6gEnq/dlqjInwCzWxMBnffpV3KvUyDb6l7kxvdfZlhHHyJbE4MOkGllNKW25dloSsbGbDZyVAOTq6w0aqrFDtufPNiex1FTqRLqGggzqvqiJUYlVRu6fea/EWOsM4KNz8WrcS1Xh7ULY0lBGoxXho8D5E9J7yxldXShv2+yxzDqaWu5EYw7NF0yNRhccufMd7TRF3BdlIOfdqe3ZKnczWZaGGtwUjMfQQN4kRDJvYgDgzTSkc7u7eecKxeQI8O6ba5mO55OmagO/mJth5Wl7qj5hsPbMdleB6n/K+yGS3OsQwEf4JZp4V7PQM2UKTdmgyCgwdc9s+SiANnqSmUUmUmefg2FbZWRQGN+6b29ttUN6FJjD4mXhB9CQopyll940xTQBZ0fnvCRJWmrrwdFPWC+Mg9SI90AGMZnqD6ANIg42EB5WNEQi3IlXbm32DZSfzI0jXcSuU6U1ZNcesH2TKpcInnNXcVuY9JMBOsvb3d
 nPiDYUv0
 i89P8lNqtHoBF+a0lBBwXw5GXGFipzqnvLAWaAATvzKwUTUCnYj0fYYimSXP9PrxsA73Xwbr7NuyMvvqa8jM2Azfo/Zrj0uCRZjxGCKtnb2X42Lk1nMqXhlaqXZTLlLWrvkfIDculSdWv2l3gwDrsLwOBIyh49fAdVvPbHkLIfM4QMILIyL3OMLgWu4JrOZsVh1MiGo3VZMU7zR6RBcNzY+/0xDqWAou+PRkw3Nl0qcx7n+CNi22ftyv631wj65O74hqzwwD8SiKrDDtvL4NXqm9mQuO9QfOD/qW3cEkYRgKu3eEZ/LwUHmyTHx8/KWXzYm7re4V5oeZMghjQ0/7bk1pc9zkv9KHyxIcSU5fqlwr6f+A5TvU5NMRRkQcdCxlyTR9oAuId7MTMEJMuLqiYuTJZ9raHjdC1L6pim6Ytc3BLzRteujE8P/vwumFJJdo94uPjILGDi9TNl4/NuvQjC3af0tMLl7ll9eGlIV+3TDQiuBsnVZY75UaOVqtz4Oa3UYktsIPiF/XJbP8G53SutpCNueWRhk0Prf3QIDCo1bsP+vZ0HpBDL401Pi08H/dcQXZ27pHrIjIT4c/7pTXMPYQHYHYSOe00vlab6kHiSqJhFrdZ1RWaMPpiMmgwNOqDpmna8VkAgKdEahnLgSEXyV0Ee+UcslbFS7+MqlUIsM4lybk3DUXWq3ySLoGnd2cwJC6GrvpXquG7HptCsB9HG2+R6jLvdcotS0Mkst5635uSq0yhCTLwJgAWqOIkwiOjEJM3YbPzyX2miJkFtQXx8hj0A3gl8/cvYmGc8g70CUnid8xJ65H+eDhJsLCcn3RZj2SmV13OObb2oBt8N4KUMdnAhRe/neNBqEda+YK+8ThwPOmlwhAd1QSTjX7+hs+tvmrGVSoot4xttKiffAHGrFPCS8Lv9E4H/2RLxrXjaGOqYTSUyQbs1AoHwe4S33N09MxcyGP/gdmbmTSXrvjA49T2k1D3
 ag5rPqd6
 f7YC7J/c99TXuAsEj5Pcc3y+uFvQnLrAwUIj2ET6zcPa/MyXxAgoeH38E0Gf3Y10llggR60oWu2LtPxiZWi2H/gjzqQHTSh3URkPjl7yt4zqlgD0xi7l99tyqhQpFyuqURqgF/o5VRRhk0Izo5AsL4IHqGmupZ/bR2r7K1fbOwN/9szxTzA9r5glkzzh/HVDzp9lrLsofE5uoP4E9kW1dy6zgEgPo5Ahq3D5sr+F/UKZpX5T2LM0dZyCX2uPrNz6//H1ioZElPP5eWjeQNOJKRbpV+cAD2EiMkcXKrNSDHzIh8cngqZ9z5coglJ2pnQLd/Bur5BUh6kVuaTAAM9HFGJOXAFlGWHbOlmTjO0kn9/VNdVQlwVh7lUh/rQK9uWa3kqFRcdWOGDyD2eNLhIbOVpOlc2E/8VL46TXQffkJKHOyL6qoXGIz74KLVyq/sbYSmJz6LYfLdXIb7I8xosDLX+/15RoRq/gmT0buqz2Znf7lvAx4CasHreqFAENQMft5r1f6J/t+79T107p5sAuSK/0ytgAN2s4taBajHSUfnHSxahsIUSoNNbxaMtJxz3q1S+QyadEuVXSF5NuL3rI28N/TwtYkQrwUU4RVqowuduoltW5Af0YRBK8bQ4x486ji8+k1pC5CllWoFzpmOnxl8znIA2P87MncRTF+SECP51fU3ZHHNCafdB6mVm9FR8JPD7QuvFKWQTvYYzAcd/eC1D9A6SE0fFcrlIEejvvnJ/gW9veAfYJgGXQqJscYB53vUmWQtuufDTErdfg6M2A+kXEyLzQzJv2SUVXLDyLmS4vkCaPJhT25W0Ksx+LKPrLtmajOEP8PkWeoVPYBHz7qVeZ2m55UaQphVi5MtDZP6ey7121NRyXLwg9Bwwmp2BY2GoEazw3CXrKLp0Zba/T28kJmzoGG4xXlACYvN77Mm04JhgzG1RF8bB8xhYWeVjJ4Vdq49kwD7/5dBSNUQeTerQ134LJV
 4hw02oTR
 6cnnC7VV0X46kf/x0umKtRbpMW5Xnrruiti0HJPhtF6Nza6n6qekaihpHpIkvB7+odSq2XbUifsEO18LjjGqOroHywnjF9sS9fsNTS6krYs/HIVzl2vHqHP32b4IbLc4hwvISbafSF5o1v/zFii06WkjiDu6N1rrW8LvuSMfDU3kAv0mDEnPzbInAQKnEm3FYUuhmUR1K1vim7MYVF0wmGUj+FAMrhRwvdaFi+BzXtGQE8lmVHwDoDeXgnelEDEHLlAKfFxcU7kKalItahm+ZrB/LicK6lrFsJyW/GyZTOXWo3JYlQdpFrFh+AykKZFkU2CRsBgzSrkX+2hEXFbJr481w0oHWYqrZJeOhTtuM6jiOJUPNMJ8n1viKEn0MjCWjzxpWGWEKWEler1XOUCraOS7ITgBVu+iB3onjUe/GaDtRj2YrC0nmhVjrfE8sxIQuVLZtg2zNXhNGVHzN0xBQ0nvQGbklwgcZahoJjGQfqDBkk2ol3AUCcz20g6utC9y9LbvbklBFSS6FLxqyOr2IMwghe8U4SLPZmG3YjflQkbuiG/uWDXwqKU3e20MzmJ6HbNOeLKu4UMehJgqRg9fzK+UKse3MOtNkODPIRonduDPm1pAkzbxEAM5l9bZ2RmdhMdAksHyvh4bcBM3DGvsskdIWI3xwlstBeESSDO3UEg9k0DQTMbgxwE0ebvZJevPbUKzerOvTtecgp1hwTjExGRRZ7+b/zEsZQEqITBclkbRRjIBTqYLZjqENjmJxR0B/JuFped3Dh4U0OOgaR2pzuBgKNwlxo2MK1NODNAif9NS3yPd1AUZNXsl9iJUCNZxBMVDWqoT9Mh91ij1f7DzCrX77FmZ54SEtQHvLkuDqEqrVP4hLscS9tmTuG51wQqjPJr8n9EsAu8wDX1TmGZ4fLqU9CoDkhxXV7jtdQoSt0BmlTJnstr4aipeWiwb9oeIkZzEOiHR+D4Ddy7gHwtQxfHKGlInt
 lH24zCZM
 rFzdnJpvELgEFLygjAFS/yuki+p+1fJLCMcyekrr7k3vKeBRlHBGIaNuzc7/Qwx8XnHDA31W/X3gqAp26ZlyZ1Skw0rdBij/0iR38ADNhR/ao0kqdVGMDPf8KmnUuR/VGpMwOsi0gmtqzpMhkF+QxSK/oQMIUpejaYdJsJjXlMhXITcQeWGhGnp4Y5AWFdf4H06oLa4qX7LcLCTmB0dD0fdwHar5wFxo+SXNlTOX0AvgxVtq+EAqOef2tYTyuuAFntYoFdicaYozhD/lWkT4XP/Zli/aX0/mwRiQJ8oR3+5bwfTCwyqUHvLxtkYA2wZwcS4j6mecjLLIWnv7mTh82X9U6eye+Qp7qy/yncvlmVUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked, the
driver might have done something crazy that is not permitted by the kernel.

Currently we check for three such cases in __mmap_new_file_vma(), but only
if the legacy f_op->mmap hook is used:

* Did sparc ADI result in invalid flags?

* Did the driver alter vma->vm_start?

* Did the driver make a file-backed mapping on a read-only file writable?

Generalise these checks for both mmap_prepare and mmap and apply to all
invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handling
in the core VMA code and the mmap_prepare compatibility layer.

We also WARN_ON_ONCE() on these conditions as they are things that should
simply not occur in the kernel and it's important to call it out when it
does.

We invoke mmap_prepare_validate() after mmap_action_prepare(), as mmap
actions often manipulate state in the descriptor thus providing the final
state the VMA will be derived from.

Also call mmap_validate_vma_flags() in insert_vm_struct() to ensure that
special regions which are inserted (such as a VDSO or VVAR) also satisfy
the sanity checks.

This way every VMA established through an mmap hook, whether via mmap() or
the compatibility layer, or inserted via insert_vm_struct(), has been
validated. brk() VMAs never pass through a driver hook and so need no such
check.

While we're here, also fixup a couple disjoint blocks of #ifdef CONFIG_MMU.

Finally, update the VMA userland tests to reflect the change.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h                   | 47 ++++++++++++--------
 mm/util.c                       |  7 +++
 mm/vma.c                        | 98 ++++++++++++++++++++++++++++++++++-------
 mm/vma.h                        | 24 ++++++++--
 tools/testing/vma/include/dup.h | 10 +++++
 5 files changed, 148 insertions(+), 38 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index da14c56fb24e..abb0fae8c637 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -212,6 +212,24 @@ static inline void *folio_raw_mapping(const struct folio *folio)
 	return (void *)(mapping & ~FOLIO_MAPPING_FLAGS);
 }
 
+/*
+ * If the VMA has a close hook then close it, and since closing it might leave
+ * it in an inconsistent state which makes the use of any hooks suspect, clear
+ * them down by installing dummy empty hooks.
+ */
+static inline void vma_close(struct vm_area_struct *vma)
+{
+	if (vma->vm_ops && vma->vm_ops->close) {
+		vma->vm_ops->close(vma);
+
+		/*
+		 * The mapping is in an inconsistent state, and no further hooks
+		 * may be invoked upon it.
+		 */
+		vma->vm_ops = &vma_dummy_vm_ops;
+	}
+}
+
 /*
  * This is a file-backed mapping, and is about to be memory mapped - invoke its
  * mmap hook and safely handle error conditions. On error, VMA hooks will be
@@ -224,8 +242,11 @@ static inline void *folio_raw_mapping(const struct folio *folio)
  */
 static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
-	int err = vfs_mmap(file, vma);
+	const unsigned long prev_start = vma->vm_start;
+	const vma_flags_t prev_flags = vma->flags;
+	int err;
 
+	err = vfs_mmap(file, vma);
 	/*
 	 * Either we tried to call the file hook for mmap() and an error arose
 	 * or a driver set vma->vm_ops = NULL intending there to be no VMA
@@ -238,26 +259,14 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 	 */
 	if (unlikely(err || !vma->vm_ops))
 		vma->vm_ops = &vma_dummy_vm_ops;
+	if (unlikely(err))
+		return err;
 
-	return err;
-}
-
-/*
- * If the VMA has a close hook then close it, and since closing it might leave
- * it in an inconsistent state which makes the use of any hooks suspect, clear
- * them down by installing dummy empty hooks.
- */
-static inline void vma_close(struct vm_area_struct *vma)
-{
-	if (vma->vm_ops && vma->vm_ops->close) {
-		vma->vm_ops->close(vma);
+	err = mmap_hook_validate(prev_start, &prev_flags, vma);
+	if (unlikely(err))
+		vma_close(vma);
 
-		/*
-		 * The mapping is in an inconsistent state, and no further hooks
-		 * may be invoked upon it.
-		 */
-		vma->vm_ops = &vma_dummy_vm_ops;
-	}
+	return err;
 }
 
 /* unmap_vmas is in mm/memory.c */
diff --git a/mm/util.c b/mm/util.c
index bf0513d1d3d0..a3cef493ed70 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1224,10 +1224,17 @@ EXPORT_SYMBOL(compat_set_desc_from_vma);
 int __compat_vma_mmap(struct vm_area_desc *desc,
 		      struct vm_area_struct *vma)
 {
+	struct vm_area_desc prev_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&prev_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
+	if (err)
+		return err;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&prev_desc, desc);
 	if (err)
 		return err;
 	/* Update the VMA from the descriptor. */
diff --git a/mm/vma.c b/mm/vma.c
index 0db2fc306993..a24f04428580 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2581,7 +2581,6 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
 	return 0;
 }
 
-
 static int __mmap_new_file_vma(struct mmap_state *map,
 			       struct vm_area_struct *vma)
 {
@@ -2608,16 +2607,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		return error;
 	}
 
-	/* Drivers cannot alter the address of the VMA. */
-	WARN_ON_ONCE(map->addr != vma->vm_start);
-	/*
-	 * Drivers should not permit writability when previously it was
-	 * disallowed.
-	 */
-	VM_WARN_ON_ONCE(!vma_flags_same_pair(&map->vma_flags, &vma->flags) &&
-			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
-			vma_test(vma, VMA_MAYWRITE_BIT));
-
 	map->file = vma->vm_file;
 	map->vma_flags = vma->flags;
 
@@ -2696,11 +2685,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 		vma->flags = map->vma_flags;
 	}
 
-#ifdef CONFIG_SPARC64
-	/* TODO: Fix SPARC ADI! */
-	WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
-#endif
-
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
@@ -2763,6 +2747,76 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
 	vma_set_page_prot(vma);
 }
 
+/* Check to ensure that the VMA flags of a newly mapped VMA are sane. */
+static int mmap_validate_vma_flags(const vma_flags_t *flags)
+{
+#ifdef CONFIG_SPARC64
+	const vm_flags_t legacy_flags = vma_flags_to_legacy(*flags);
+
+	/* TODO: Fix SPARC ADI! */
+	if (WARN_ON_ONCE(!arch_validate_flags(legacy_flags)))
+		return -EINVAL;
+#endif
+
+	return 0;
+}
+
+/* Check to ensure a driver hasn't done something crazy. */
+static int mmap_validate(unsigned long prev_start,
+			 unsigned long curr_start,
+			 const vma_flags_t *prev_flags,
+			 const vma_flags_t *curr_flags)
+{
+	bool was_maywrite, is_maywrite;
+
+	/* Drivers cannot alter the address of the VMA. */
+	if (WARN_ON_ONCE(prev_start != curr_start))
+		return -EINVAL;
+
+	was_maywrite = vma_flags_test(prev_flags, VMA_MAYWRITE_BIT);
+	is_maywrite = vma_flags_test(curr_flags, VMA_MAYWRITE_BIT);
+
+	/* A driver may not make a previously unwritable mapping writable. */
+	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
+		return -EINVAL;
+
+	return mmap_validate_vma_flags(curr_flags);
+}
+
+/**
+ * mmap_prepare_validate() - Ensure the driver hasn't violated invariants in its
+ * f_op->mmap_prepare hook.
+ * @prev_desc: The VMA descriptor prior to the mmap_prepare hook being called.
+ * @desc: The VMA descriptor after the mmap_prepare hook has been called.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+			  const struct vm_area_desc *desc)
+{
+	return mmap_validate(prev_desc->start, desc->start,
+			     &prev_desc->vma_flags, &desc->vma_flags);
+}
+
+/**
+ * mmap_hook_validate() - Ensure the driver hasn't violated invariants in
+ * its f_op->mmap hook.
+ * @prev_start: The start of the mapping prior to the mmap hook.
+ * @prev_flags: The VMA flags set for the VMA prior to the mmap hook.
+ * @vma: The VMA after the hook has been applied.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_hook_validate(unsigned long prev_start,
+		       const vma_flags_t *prev_flags,
+		       const struct vm_area_struct *vma)
+{
+	const unsigned long start = vma->vm_start;
+	const vma_flags_t *flags = &vma->flags;
+
+	return mmap_validate(prev_start, start, prev_flags, flags);
+}
+
 static int call_action_prepare(struct mmap_state *map,
 			       struct vm_area_desc *desc)
 {
@@ -2789,6 +2843,7 @@ static int call_action_prepare(struct mmap_state *map,
 static int call_mmap_prepare(struct mmap_state *map,
 		struct vm_area_desc *desc)
 {
+	const struct vm_area_desc prev_desc = *desc;
 	int err;
 
 	/* Invoke the hook. */
@@ -2800,10 +2855,16 @@ static int call_mmap_prepare(struct mmap_state *map,
 	if (!desc->vm_ops)
 		return -EINVAL;
 
+	/* Perform any preparatory tasks for mmap action. */
 	err = call_action_prepare(map, desc);
 	if (err)
 		return err;
 
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&prev_desc, desc);
+	if (err)
+		return err;
+
 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
 	if (desc->vm_file != map->file) {
@@ -3432,10 +3493,15 @@ int __vm_munmap(unsigned long start, size_t len, bool unlock)
 int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	unsigned long charged = vma_pages(vma);
+	int err;
 
 	if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
 		return -ENOMEM;
 
+	err = mmap_validate_vma_flags(&vma->flags);
+	if (err)
+		return err;
+
 	if (vma_test(vma, VMA_ACCOUNT_BIT) &&
 	     security_vm_enough_memory_mm(mm, charged))
 		return -ENOMEM;
diff --git a/mm/vma.h b/mm/vma.h
index e97bd2dfa786..af14ed7265ce 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -780,14 +780,19 @@ struct vm_area_struct *vm_area_alloc(struct mm_struct *mm);
 struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig);
 void vm_area_free(struct vm_area_struct *vma);
 
-/* vma_exec.c */
 #ifdef CONFIG_MMU
+int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+			  const struct vm_area_desc *desc);
+
+int mmap_hook_validate(unsigned long prev_start,
+		       const vma_flags_t *prev_flags,
+		       const struct vm_area_struct *vma);
+
+/* vma_exec.c */
 int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 			  unsigned long *top_mem_p);
 int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
-#endif
 
-#ifdef CONFIG_MMU
 /*
  * Denies creating a writable executable mapping or gaining executable permissions.
  *
@@ -836,6 +841,19 @@ static inline bool map_deny_write_exec(const vma_flags_t *old,
 
 	return false;
 }
+#else
+static inline int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+					const struct vm_area_desc *desc)
+{
+	return 0;
+}
+
+static inline int mmap_hook_validate(unsigned long prev_start,
+				     const vma_flags_t *prev_flags,
+				     const struct vm_area_struct *vma)
+{
+	return 0;
+}
 #endif
 
 struct vm_area_struct *__install_special_mapping(struct mm_struct *mm,
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 2fd422789717..2986ae6ca1e5 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1359,13 +1359,23 @@ static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 	return file->f_op->mmap_prepare(desc);
 }
 
+int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+			  const struct vm_area_desc *desc);
+
 static inline int __compat_vma_mmap(struct vm_area_desc *desc,
 		struct vm_area_struct *vma)
 {
+	struct vm_area_desc prev_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&prev_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
+	if (err)
+		return err;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&prev_desc, desc);
 	if (err)
 		return err;
 	/* Update the VMA from the descriptor. */

-- 
2.55.0


