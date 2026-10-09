Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1DACCA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:09:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0D236B00AE; Fri,  9 Oct 2026 14:09:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE046B00AF; Fri,  9 Oct 2026 14:09:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85EC6B00B0; Fri,  9 Oct 2026 14:09:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8CA6B00AE
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:09:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0535B140462
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:09:11 +0000 (UTC)
X-FDA: 85303874544.28.FA83932
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3DDF2180008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:09:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aMQjGNH0;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXvAGJ21GFXlCXFIOD7WMGr+Kl6vRRefqbwPXSBjAug=;
	b=jfdEKA/ulckfud+ABlTVP5fl0xSnamjhD/vaClbOuXz9pmuckROLFbjSgejGomLjyGX2ZC
	0akWhkNy8zsnjExvI7uMX30yZp8y5G9ZS8WG0qSfoviylMFzR5LRPylHlyMyCWMaMr5QeW
	2hbVcrvm18wK1KUHl+ajQchGd7xhnZw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569350;
	b=Frhzc2vmIa4yqdWOZPFkNEvkudPMiMD/480TV3QbicJI9aILO3AvRn0w6b9P6yB0KBwXsy
	FOhjaettLXzYbY8jI9g4UEg6MKXNKWvv5wkwBcoAKhfrRrc/ZOYJ0fUPg5wk4Qm9gS8Iv/
	7E9FKZzedh7o2q+shgnrAEclnfux6e8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aMQjGNH0;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8184C4025E;
	Fri,  9 Oct 2026 18:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2C41F000FF;
	Fri,  9 Oct 2026 18:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569349;
	bh=HXvAGJ21GFXlCXFIOD7WMGr+Kl6vRRefqbwPXSBjAug=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aMQjGNH0miqmoIl35ZayS+qH0MGRnd6Cko1KN+6mGkZIpvojG35ka6MQIUlxiWhAU
	 7Ln8zh9hhLq9/1AZ4CUIHLlvwH0EJqJ/tkD2FYwjagFYPQvhXEaEdBgtp2EvRgPG3r
	 QJzdFeOiI1gTGjDg02fgNZbpIh+cL8WbTHfWopYGPffFMnOoPodyytvyqjVbOMnbR/
	 nvG64vKUGzUmcI49cSMjb/bTMNTJdjOHcsa3Rfch1jqWEUoXTjC3q09cCAnIvErO5g
	 4uFSPk+KvS5ycVdSSSYkwgl0u37j84fms9RT6yPBIOZhoQoMlKgF2fwxAJG4LoYA6l
	 Bnv2OZu8cljig==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:07 +0100
Subject: [PATCH v5 13/38] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-13-923b70125b1e@kernel.org>
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
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2179; i=ljs@kernel.org;
 h=from:subject:message-id; bh=tM59zMzSvZAL0eIh8BMq6f95yGj1GJaZNA6qSluVUvo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sx6cN9+uxBv5cu51X66TDxRzjfPdew4Fa0+5eqjw
 BzdRZded5SwMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiu/kY/nv+0eN+Pz1UTJJD
 f+40+6cJWZdfSV9cLmrpVVTBMWXDYRaGH+tvRH5S+Kjxrzdz+h1B1VNqyYaS59t8t3G4Bvjtexb
 GBAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3DDF2180008
X-Stat-Signature: i1g159g4riw77s1putmcfghiyspm5cx8
X-HE-Tag: 1791569350-16381
X-HE-Meta: U2FsdGVkX1/UZtThqCXnUtRndwhLQanR24swNbQ1MQl6fuQaFXIjTpuIe/ytdRwu6lvYT29VT9TLhjpFb+8i5LT7cjhEZkUAN7Olwo5hYLQQuHNiQgYwPmncPUmQSxb4+UaE1TJBthw9W3coT79cpZjne5FZ13m/xLrUrBJhHwETOhWJrTowPHbwozRyBo6D1nNOB31qax0D8PFishVmaGuTZbMoaJfzsIzxaOoP45J+kj9Mcl8SbQcu4echRXtxru0Vmxu1HbvNr88A23Ktwft8s079FPyuG7VSH/hfhmI1tMxznmHuEFHyUMD8OL8j0FM5WknXx1Y3kMwaqZq0hmPqMofyssPus77vIdLZY5smd1QwyZBWH6YtK20P87eY1D223DTfMc/9ZkjgpSY8w+OkSF/X6+CGQTStBXKbfslgFrZxkJMdhwhC5nrha0GGN728gVXtia05WprlKiCTlS7VZuOzr6K7AtMmR24Qp75L7qImguit+FSNkWrB3fNWuf9MZ5hzDmOLqg0Bs7XeyWnnOLBM13vMQUafazrVqHMfWkU2oiDYNKmBVvTJfy5XGiVkNZCOqQzH6IqSuuAVtxMAImQWVLF7/fSkvf4AXkyiGzSwdrxj3MsFaOMeNTutXWwMZsYHrU/bJYULNJV999p8jH3bFwXSszeefyxtE7AyRXDX6jkcb/Fk0ViIw/dizeg/ypB74l6SF/qAgVk3GEcCqneibdEnlv7R5tlHxJ/xI0H4iuHGsGeqLkvc5sx9dyCGeQ5Ho3qaGW/IJbzGHItECMZr8ssamuijoGZ4N22Uq7OPn6XTqDJdmI3EGa/mvnroxTNBaNtBUuxkERYekOskaUmz6sVEbXry7JDaWZUXpDPRi0UgfbBMD1ZZNOPr4GwRTguVJwNC5/quiOqhXsuwVjZQJaNIvv9DbPITShGKDuDddjHiLO5eCPxGwg7cDkJjbRODuRrwvkC9DBE
 B3hqV7qM
 FZ82MEtXFhWmLt3JgvBPLHmWEAryiTVBSf1jSuvRaNdgFAmebBYcXI9YpGlJFVYiYRYu3Hcn3MC5L4opLyCZ0LkwSqBbKNQ4EX+/BKQ6akt0IA4WyIxLRn9Amw/b3e5CdTU5uOauXPpuSLdyJ6Hg+bjBfGLmX6zjVSPG1nDg8jAPJcMoS/A/3+DBxtuhW/TbWn8Z5vOK9QGmOdG+LHnyPph+2tnCZYYRmrEsyHC8SnT8WNQfLNTulDHc/3+zPG/FedJpKvJy2i/K44TaiRQLkI7bl2PI7y0bgfkAbP6Q0EIW91+dmhOHpTosOiEhMLzdJHIz17nUk0B+RViTntSHyQQhfXWZjW8WqZd45FGWRA7w5w6+XzZZqEa7cU9+Eu30vz9jpA2s9dt2q6dQx6ywH5cUJUpDge+IENDlSTWVgZLKV08JnScdHNwHcJnRTtju16zjJrJgGlWi9c+HG8BUD1ht3zCzT5muxeaRdQVYuEjvnfyEvMCKgyCP9lGVUB3sS5Ekq5VOzILWogjSKs4OO4WgCV8cgwfs585bNpz92uA3xm9q/hwLbUrrzgdu4m1J5C3Wo6nS8GTh0MtB1lJlRYmVDktJOrAlcOArgmJo9ZkJNiVNZCv0Tk6ttGofpaj43w7Ybg5/6hhw8bZkPJyYDw1XJArosBYvvvO4X6MN4UBlx8l7v4ZwniLJP5SjD+mn3GyHNVeV3TCfse/HnczybFER69xzQlok1APw9nI0WlQP/64ubt2856mo/BofiHRIycfRTBHUNYn57YXNx7hCm9rXHIe3liWd2BmRNJ07HedygvPJA9YjgwagxRSUs24ucVhBFMVOVe3Gz6wjhsZG9ukNPdsfeOvWhSfgf7ifA1UawXvW/daWMg09EA/JtHUDYf9CDydFAMPcD5BdBHega1jEjML9qVd9oE/7lIduzMtPDWserC9A0M6kIoq7IKgeX5VpwBSO9y3GVZWcRXOL5vh2TPsT2
 IdNcjPtd
 aqwFteJqn4e+i0i30/ilzyJ4Bs05uuqYMstYwNl8cDj7YuIVjvt+M8GCDEnNQOAbIbLN/B7ntZHmFFvbj5zPKVSs9wAuixCE+dvhIhtdM/+9oP7P3S+ksYgSnwuKGySVU/BMtC7ScpHfa1gK6P31TiJaPbT55bqB43usqZI9WesKfIu2HXVVTZUiu+qsw4mMi2fTQO+ur4j7YmkN53gNL4EU3tinBgvfP64QS1exNGVFZvk1Lt1YSHX1ILHFG1ofxOb0w2ruXYW4oLuNZAmRFZdfI+5sRMlK4vDKHQw+x7s1DSxmCJvftwAMVJa4M7lZttf7hT1UAVJ/YiNlCnvCABJLKUI5tDWm/FvrQ/FotzDgcLEISNVZ4vr501syXMOwQD5wXa4xncdhiVAp0gsbt0kTfNoVW0P2QETJCf7dh6z08fE6zmQXydTaytj2JMrsPOPs6aZaAeznCjLWJnWq83pq3J6JAeO1IJ3AoNynWzLnHPKQhjoYQSeJvaNSwzgU8Nxzcc6BQPxeGmOvxS5Wp5N1JKO7IZRVXhg6RITgrDtKauVeE/agM93h/eQZhkD31v/y1nXh0iSwPyKqSuq+czRkod7dU2xQh78lZbCsPaziWjwEaCHzxEk/FUGwN+tRG2DbQPiLYC8xnhL7tLxysLWwUrIT05Onueqh/KKQmmMJiu0kME249BRwdyneLx6nXZTV91VYcu7eeDUl2RdcMtMwKZrW3DN8426aYGAZi3DWdbOHav/PB9GEmN+PkLB3rBdU4XS4ml+5IXbUm/PkXdPqjCE5Pa31gZIUgDd5k+Z07E7FwMctygN7huX4/Pemh1YpumeHaXk64wloGC/UjM2fSUNnsFAwMKZ58WIH15R+ngxUhXxnVxtuDM/YwkHpMW5nT4fX48TNhhSI9PleO7XMG4mu1sKCNfAYp7oAc/5VE3+A5Xt8ElTLoyr4y+vUmuG2Df5puFjvLIM3KKGLk3FjSE6ov
 eqlroPWN
 U90PfJu1Ckq3oiU7dqch7lrne3TlgncB3ngTMlV+hNkGrM3FoeiJEuyHX5Fs4pKZWELmWL7heJtLUh9rmRLm1NRJRjVDmEJFZqOoWs4BN1jPFlpiUEIeBcnZJ4AqS4TqqHzMheHdRQgK+8aOajoxppmiyErychypeoEp3tIvhtBzIcJ+BR0i863cPvOds18+SlnsUGcaMiX5QeU2DxNqUYuFpiwAifeGGPTSXG1sxIfEm/UnNWiQIwNH6SQUKEfp9/rHjtEjIZMYQSD1qotHIY9DaooLnewhzSaJv3fo3ogzVQnPZBzN+eHJYX6eZFB6rRSAL5V7b+7b37HUbPnYa3np5FvZa9swjXsVOMTYGLhfF4UlT+CW0a0YlNqa3QZ1Q8DghP6pLEjZOZA8fn9pValgJnKkTLUBioYIC7Z3vxUJ8tELZsJ4RWDEzgT9SFr+djPjWEnZ8cOBIBZxVL0ZClRd1kS84rj486z86ewbmOQgkPOsHgRWPkw1quUPygJM5NTd1jWNOJHWASvtM8d92w1FzRTSsYQStlfd4cDSYAymGu3D6spXujH49HbvlVLyp0UnPMTvJBpT1zfNS4VgdD4NAbLO5+TGbI3xcYtQwr/JCNt2qcGLXJNlUPK/kXnZTC0LDSd8tiwOqS2LnonhEAyILzaj8kCNCoTlR6+KWVGj48fB8s3koO0vrWr6gbCytwSP21rOUXpBQ1kiCkXTPs7HJtJlqI4k4MGfMBHkxb+s2X7/OzRwiL6tAhH6F4mlawas6eLZbV9Zyol1n0/w6vSPzNeDrirpc58FWKaJ1UlZI2j2pVKBUN0j2CXtNiniC5TGQe4JIveSWgZfZnegjowY0PNQi9P/2JqCMlJ6oYLrLEQJGoni9GpmET8rc7buOV0pl5mh3xmdj3irSS2l5qCEVy1Mob4vxl00ADWI3qGP28CwRy5QqX97K3AE9sCLpir/U2r+JpfgwJXPcBgtneO+9cH2R
 wo/c34cC
 FN8FZ7WSeVnZpXLOoYkoF09WKQvSrUZJD5sHvubCnJspjUWwWsBG7fkcD0AFj6TpB7IZElyPKsRCz44SFuT+5HCxwOdIJo4QTndGyaptnASigQhPTQHPHAnAdRfVUJNUuprmP5+PcC4XRLIQNFOaqEDTOCS2sxgPzZNrzOpYLh6Kl9XiDFx6+61GW+Q7o5Xsc3ysk4pQrb1aTLHzA+XlxuD3r+kdQnixfZFE6CFMwqPRmzHOOtU9Rl2uioT5Rl8yXkGwXcCpql3yUi3/QHrqA3m/EqwJqz8V707qt6OvVcUWHU7zvuPshAQL2CoyqJjE9ahC0W/Trdoc/SEyB/5Q5vTLR1eBhxynk64X6KR54JnTcDrEq8lV4q4pa9RFlcTtw21izXJtMOQmkrBq45mWCqy/YXwDNxVADJze2aAZdU2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set to
one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
or arena_map_mmap().

It is convention in mm to mark mappings whose pages the kernel manages
itself with VM_MIXEDMAP, so core mm knows not to treat them as ordinary
page cache or anonymous memory.

The map_mmap callbacks ringbuf_map_mmap_kern() and ringbuf_map_mmap_user()
use remap_vmalloc_range(), which ultimately invokes vm_insert_page() and so
marks the ranges VM_MIXEDMAP, and array_map_mmap() sets VM_MIXEDMAP
explicitly.

However, the exception to this is arena_map_mmap(), which doesn't set the
flag.

This patch corrects this and updates the comment to reflect it.

The pages are refcounted and vm_normal_page() finds them regardless of the
flag, and VM_DONTEXPAND remains set (marking the memory as VM_SPECIAL and
thus unmergeable). The one effect is that NUMA balancing now skips these
VMAs, as it already does for the other bpf map mappings, which is the
reason array_map_mmap() gives for setting the flag.

The intent of this patch is to be able to establish the invariant that only
PFN-mapped or mixed map ranges may clear the VM_MAYWRITE flag, as is done
in bpf_map_mmap().

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 kernel/bpf/arena.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 7b6847200b43..b69fe5e34339 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
 	 * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
 	 * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
 	 * being copied into the child process on fork.
+	 * This is a kernel page so set VM_MIXEDMAP.
 	 */
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
+	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
 	vma->vm_ops = &arena_vm_ops;
 	return 0;
 }

-- 
2.55.0


