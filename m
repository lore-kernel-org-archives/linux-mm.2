Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9F72CA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C496B00AB; Fri,  9 Oct 2026 14:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBCD26B00AC; Fri,  9 Oct 2026 14:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5ED66B00AD; Fri,  9 Oct 2026 14:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F90F6B00AB
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:08:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A282A7EE0
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:08:30 +0000 (UTC)
X-FDA: 85303872780.04.0A5EAE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4D53C140005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:08:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nRzxNI+s;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KHIf8B2iI8fiNQJo3dAJ4TwVu9iIvLIuOzKYifaGOuw=;
	b=2/HwjUdWngMXEkITT0BGAExHk5Hdfa8jeW5cBW+BaMfg9SQD8cA2xg2Hary3PwNX8CCuh6
	5xxSok0AkksV60RM017K06yaas8HYpecC3xXXwEx3hTWHAVbSuH4xzB/wtG0Bom7d+/+OR
	PJEWAVWXwHQ0qplhO3Rc9OOqsziWqO8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569308;
	b=on1zjaUZ8Kkt8VXUyn3ykamfbF95QZHP7h0vYgSg3vSOt54lam0hq9SqL8NgMVfyRVai/A
	KdfOZDlnDe2r0PCjD5GMvIsk+YtZ1ksLhvNjaVI0Scjuc+QoQqAnFqrgGjICAm2gViogeX
	i1IPr/6djCmq+r22ycADTP7978bR9No=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nRzxNI+s;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 65CB342EA3;
	Fri,  9 Oct 2026 18:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2351F00893;
	Fri,  9 Oct 2026 18:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569307;
	bh=KHIf8B2iI8fiNQJo3dAJ4TwVu9iIvLIuOzKYifaGOuw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nRzxNI+sutDN8f09nDjKkkSVYLIVFA1KBxmkta60GSU2jmmn5Fr0ShIPbnGo2JAMc
	 FmGDoODwUQcfMnKXfnagv0XMuf2pSfBX3rbgSB8n8d0mFfgqXTtttbU61wBS0hv64I
	 HR1cerfNHUGT3EFUpSCcwyg1l/etfg6QCuenzcdkbGVaqZTg3kumDLWZu3xboiHhHX
	 GcxzBPdky67tnM0dYnDp6x+S5wL8vR6r/38MNmp6RwBWNN5oL9z7qKP+Q2E0EY2K1v
	 fJvsHQy++SIJCIpufn4IECyZpabC0v3S4H6zNL11g4j1/iEebgcLFpzeN4uETr2urt
	 jgrO9D370hMTA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:05 +0100
Subject: [PATCH v5 11/38] selinux: reject writable opens of policy file,
 drop mmap shared/write check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-11-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1977; i=ljs@kernel.org;
 h=from:subject:message-id; bh=htC5Vt0G+OXzRx+Moje1Xpkb4xzW02xQsc9pTlrK3z8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6syyLlwm5qqqxW+4hq3BtOXz0qpbk8pMXuT1zn705
 Ox2edZNHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIqlaG/+55/uKCLuaNFyZO
 b/ZR3qyvebb6133fTwaTWJS8T93+soqRYcdKk1dXz7/gfes4jXtH2iq5VQJ2myUlgicr1T20/Wq
 bywsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 4D53C140005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: dcjr6841yx6bajkjkqtzqrj7oth4zket
X-HE-Tag: 1791569308-956651
X-HE-Meta: U2FsdGVkX18G/quZukgV0nH0Gg2TolvxVJP6ZedAagszk9gFrpw8Bsd/byUL2Oy1P5p172HOAZmVVtaXJrZ6SnV0lVEYzao43Xqwb7qn9qTAaRYZoIb6HasfglFDbnHacAaM4SKBVfpw2+IFcoszelFMwLnbwte1vKqqnX9DH/6cVeXihT/VDgbtGPx9Hg4+M71ZkERQU42IqaLTCSjlE0QUpaPhh2dmGs3k3x3O2AgUNETiT1k878kKQLuWcMhgXUZOYdUMwukaAYjEwESw/x5t28qi2FTOp4kHcuAzzQqpAYXQKH7gGEGNOESrFKHYdsaiQ9wkxjhiEpyPCukJ0cCwCF8wbqI8F6v1lzno9orr3kvUqh2Shk49hu73FMQqcbTD+YME6z54vEdWzTN2HKa9FEy2rP6/cNFOY1t6Q9AtLz+aTib7403mgmoMXVlLFoJMDZun3lX051WuIQsONDzEVt45QkczNrKignu3sFnFgQEL1O/U0en1f183MnckqDIoUYgMk9PGO3xcB1g2YoPszbNi4gBudQkuBwnuehI8QNa/OUrGnQsh/SyXfiGFuABTeWnV6d7TdL9OrVUz5NnAgu30fU9ltFW1KCZc/a7zPp3a1DH2Ect1Yin+bUJkdv5rFSvhYpCva1g11/VWE1mqEzp/v4EHRL8CbMy2hY9+H6Li0yDOBGfchyq6XOSfxuPoeuIaEYc8b8acALK27IKVzkNTUdte8MJVih2ZF0Qujw9se3rHvysMf/EtVkJ2+hqaJR10kz+Hf89nzssv2FbQIt4PkN6CIdSz+vb34j/bvbqoq8u6oaoRpcTuBa3gnfPXaRgCyCtVUIdwzco4rBhPabBMb0KHvW9AD3X5kb35Z/VZQozHVgR8c8KlhncbQtqlIvYWPkkCCjXvxx32zP3DbGpambyKHmsucZtB/Q2u4Muy8iA+mU2bWXK1mdIioUEDjfDLkSgXtKkNL6x
 5qQbEigu
 RYSoRe0B06WjGj9IKebDxvXi+ckTj/Qsu/kbyLskAwrQOcvVt3Cqr9Bz9P1gu1KsxuffaGmVZIA9Z0z9ER5JMwt7YmIWlvBh4tP7ZIfwh36Vy5STB6yigDKjkassduu4iMpeNh97qV3DUT1Z0Y670HY8elCT/AoEi2bEFeEGeOmU/MyufutUCUBq1AVaJBH5kP5FrSPYhbNEowYTxFdcBh54nsgJ27FWboFECQ/M5XLiXfyT1aCT2Z8hoXy7zlseQL8Z1I90mXRD73L3QqWqJbKkq22ksKtoRPxP5V1BHTQi7V3iRXUFuHsulSezfJntfzs8G0M6PK00TVR9PuTgoNH3Q1XF9LZIgYOMeNCmkxAj5qfMxIxX2vN/iWV50he182bDXfNfztGHagD8yWl5AH+Cz5kZ8wOSpgnCQuylZYbBzAAE1+EQreouOPcDcKQO9i/k0pp+15ouQS9yetcCkSC1QeL++EkQ7+Qjaobpy/F25r7EjI8fAEfrph3GLU34MVOyeKL0b/sVcsAHxlP7Dvi1A78NvhM3Sy6mUWKVjth0PsTaaiyZF6AObgCxReP7BBd38ssUl9f3Vf+flQ3Zp2G2ONTUgvOEGIXJ5CTIeC1BsfHnG2uvZHsbhavihzpeo+3LXRxbaehclpgpZ86sj356v/2FV4gIJ1/E5BkJgoudeJ5JfVmVhJ31J5M2ImowhxcytO9wSUEAZnqpaUOgAKXZZsq8TjAOtk2qtrBWabwS4FTh4YT6RvAKLmKgVYW3Qj+2XU6+VPjbBNDnVsrXbOlDUbvwppma7BTJd8RVHbuArzDXF1cLDxxWDtC+fHwe2ox2EjTqcRy3rZLH4DsrfTd/GSB+XDB3TOl2fv9z5xpRw+wxtuhK6xvuF6aH2cCVuhkiD3HBz1cb73yUjbdB+HrI7Qufqvnd8mvHRqOU7m3kNqX38XuB2W0CqwFM2Ybv5UhRspCslDVukBWXNXls20UCbJZmI
 tLvAreUD
 bpMRpLnEAiwmKNWMw9ytm5Gb5wFmQ7OAiwZ6FkOoDbhqREvr0JnYeXbcC/dERH3KQ+TI/zZiadASF9ko+ROa3s/Qlw4QvuseMCdmlo8gbEqDwChw9ccCrXapVCpHQHxInbTD6u2kBXVRHvyy8mKt5VsjHKI8VgERQLFIPetj4rCfTw9CGUjAeik0I4O4joGGpS1e8SSsVY4AZxEUFEjFFA9w2HMksQJDeTAHSAsPwRcKy8NK0oeqVXWzkHTvKAxv14nWn94h1v/O4n/YWtDD+q/B6AKZfzHmDQM/FElqnDsezY6Bd212IfZnu+Po8rbqZ9TtBDyErC/7k310VYtYy/RZCzqzFUSIMtm7/wbgIW9A45c9ItfFonAVB8jp0WmCclPcWDnN++IRl10Wron6zr2kCzSRe49Tax0+iELXcRDIDANWU0zh0t5tkqvdZdEuXpr9ogsfye6HkhVM7eA/4aVTy/BMyfMr9YrVwB3EqiwCR6hsjKgRGYtoiYVam+6o4MaYnZk11PwBx69sVbcH3goP2/MqkETwtwdRPDPs3B5BdhU0Dlo8hgenPY30uZqDJm6Ca3K0c6vn3SITNzIb3w3qEzM7P+R3wNTI5lRVXtfrftj41D4NmD2kOaXSY/d+Fd9Y59eSaVjdRfjYeoLgTfOb5qSQSJOwBqQmZA+rTbyll9rqv8F6YStq9JGYadcc65iEFQg/azew0z8cpWIwN/vtsFv33Jl3Y+SzL3txHfLtjAMcx9fcGy0t9nsYeeeZ9eVt00js1LXCTo7o95CeUDUbeYinC8S09JUFHGRyXSGdmmdhOCmyrYvi1PZn958AkLu6Jc5uzrz9lay3xrN3ajQkSeT7T+pPUhGrf8/KClHHMjUPzw4X3N7slJA4G2GlTLzdQmWCR9O0MPIR36QJETL4DEcGzjEMgqqRLGmSsFwxfCJRIbOHppm1LCj23qh+98pjkNpMlCuStiLIUzwRodye5dw08
 +oT+saxG
 duG2oAZmFWzzcUPqCF0rWWjnRoCrFJRQy9oCL+ZH5EbiJpH20oa0z1xW1Gs1BDZK8H5GNNaLES2H+weS874uoghjCNiTwjrDKZws75Z1itCzrXSIZcHR3FS3Y2Sn89qdy+kHQ9RGBXWwn7gzwE8E+8JdpjjpnuIIR7uuAOlhkBgg5sNnIeXZfVAiNAOkvzBDp/AeXufvc6/EtUF7Sdn3DpfzkCLBuyzd34a2++CH6kMWPOxODu/4w5OVwsIAA40W3tJWMQ0TpNLvQYTbzXBNwNirnRSlxerzP3JynUR3eTg0MRP1Cqevv1hkME6s0gyo4fmvcPum94r8yhp3Oji8v8EnMqQ+4c9Cf00ZWh9LBNYz9WBr1J6t6GD/bPgqEbCqvT0FdToJAqG0juXQ33PHRJXN8amxq5s8REGk9nfpYArNk5PAIBhWi4cdkmZH+HppHi0IJjuAhPgf3WlZAeIkrCDlHeksWofd/9daW/2tOl8C+bW7sZUGBZXK6Rta0z0c+/dllH8O8HyfaV6DLsuhz9/lVtzLbmt7fGw7VLb7UA0mnFcNArSahDpUrgMowyLNCBuWad8XNg3GAutO91sYgvskmfPsURrXrr/V9vBt+9QKgwt+6wIrpKlquo8D1PJXCLnCHHrrh04qOD2q5jWK4rdaqFyM3EnJfqG2l/VNya6IzUeaWmfx06hBeFsmVD6JKDNl/ENY2vX4vHb2CfIenGpIooAWKbQ553fe5XVgKqSOJTlOgURCYfKh9PcxhnIVqQu4DiWLVCSmPjXpSsIg7mW8jtbauO5HtX00hPbju/EnvD2VKdt5ROcOIX4rL9p4nqT0PSv3nHddJcJ1BF9g8sWhW9G5Ctqva1MsS3YDnHtCsjOdvKV0TVRtTateNcHS5YUbD18SY/VmNjFAJgG4aBmGwUjBbpqjDA4f69rG/L+XqYXER4UdTIcnbnDcVsY73V6mdmhZi2MnukvQu1jF3MUcCVO0s
 hWC8IQ/t
 mFi0UFwu+mvtVIOw0KFcpEitnCsK/z1YymXSVcisXi75Mr/AqGWLV8hRs91ijfkMcq/eGDfSAapWAeUwD8qxvqkkSfTTlgg4FOmH+HVeOvi84icRM+Ie0OcaUCBZCHif15M7A5N0MLyMrVPMIMUQ2JWZIri2PHRvd52/syUBPza9gutDgD73ll5u77bLCNOeAD2ChyD4Nhe2Nh+sH45DV6ZGlh2G0XQnHQ5/7lMThla2RU7SHyMlp/bhsrfBI7Uv6v9efED1cOCofTdR1p53kQoLs04nLz/1+kQPzDwqmHQkdnaUToE6pgyH3PN5yEsPO4ORO5qe7q1cu5OvSo4qtW4jmKIzg3cOK13YNr5/rD9Yhxs+k8fhjTTMMN99zSc3++MNigH+ICVHOWlGApZriZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The policy file has no write method and is exposed read-only (S_IRUGO in
selinux_files[]), yet sel_open_policy() performs no open mode check, so a
CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
kernfs does.

The file can then never be mapped with FMODE_WRITE, so do_mmap() always
clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
check in sel_mmap_policy() cannot be reached. Remove it.

This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that is
neither a PFN map nor a mixed map, ahead of the core enforcing that only
such mappings may do so.

Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Reviewed-by: Jann Horn <jannh@google.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 security/selinux/selinuxfs.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index c7d91476971c..545a6f89f9e7 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -340,6 +340,9 @@ static int sel_open_policy(struct inode *inode, struct file *filp)
 	struct policy_load_memory *plm = NULL;
 	int rc;
 
+	if (filp->f_mode & FMODE_WRITE)
+		return -EACCES;
+
 	rc = avc_has_perm(current_sid(), SECINITSID_SECURITY,
 			  SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL);
 	if (rc)
@@ -424,14 +427,6 @@ static const struct vm_operations_struct sel_mmap_policy_ops = {
 
 static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_SHARED) {
-		/* do not allow mprotect to make mapping writable */
-		vm_flags_clear(vma, VM_MAYWRITE);
-
-		if (vma->vm_flags & VM_WRITE)
-			return -EACCES;
-	}
-
 	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &sel_mmap_policy_ops;
 

-- 
2.55.0


