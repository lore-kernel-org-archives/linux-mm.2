Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0441DCC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69B86B00BF; Tue, 13 Oct 2026 11:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F0A6B00C0; Tue, 13 Oct 2026 11:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE22C6B00C1; Tue, 13 Oct 2026 11:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A27A6B00BF
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:15:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 085A2A0CB6
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:15:06 +0000 (UTC)
X-FDA: 85317951012.13.34B0621
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7E8CF18000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:15:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bvoldU8Q;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D64A0FyPbpB3tjb5UBGU9hKY5JLuh1oCwyYrtY/p4P4=;
	b=zmSossLihnCDjR/IlWt7XfqKMjaO5P3hjnPD6PxV9bt7yPFIv1/o4wnBqHa+4pxwR6ZZ2H
	aP24ASVzipQUw70GarrrWFBuc2Yye0HbHGyp7AczaNokwNUxMtHlQu3UMb2zZMUAdBZzsq
	DUBZMu4+VSIw9rrnnh5F0t7pe0xICBo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bvoldU8Q;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904503;
	b=bmZ8XfV7qH4xehEFfV2WE+kTGyrqdarFE6WRvIPbWH2oUDOikBQnd5w31apkns7wHWMZgX
	useXEYSm9k8wwEeFAkLk6bDaBNqxQX1qbdE/jC7m2X0/i+tPblJdQHz1CwYh3mmbF7YxlT
	xkt0MraR6AV+Jirc6lHGYfji6B0OOOo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFAED41918;
	Tue, 13 Oct 2026 15:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806871F00893;
	Tue, 13 Oct 2026 15:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904502;
	bh=D64A0FyPbpB3tjb5UBGU9hKY5JLuh1oCwyYrtY/p4P4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bvoldU8QpJo3JQxVK4J2tjQ1CB5qxRjNJojatUoKUKSimKeRUZ21DFIkxNXHWag0F
	 WYEsWGQT3Zk1tYNBmKwrdf19JHYSmjOvpxDzdUVmWTp+SBROvYaFS7eCDz1G/oNkOr
	 /XIBf4DTxzP6Upe4D4NtJ7vCow6X+nFdXwdGhfxIPELv9bXSydERUr0PzrcoZr6VRR
	 PDLyXvuQm5rMEiRem/EcBBiDb6/MCP4ve0UV+goQj3EYY7qdZlJ1lUb/W2eFM7aE89
	 yavwMKs4NICKcEc5ZKJ41gOo+PEh6CY/gf3RIY3AhySm0g6DIR/7WJH3UUhODYbfEy
	 ZTE3m0fGS6V7A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:57 +0100
Subject: [PATCH v6 17/39] mm/vma: add and use vma_[flags]_is_fixed_mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-17-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6660; i=ljs@kernel.org;
 h=from:subject:message-id; bh=dXM3F0LVCDO3gk2G109Oq5R7FFl/u4sVnffApMdLzBc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZw0WLT2vsW6382XLk08tzdngmbyisdsLXsv7Fz25
 p9gvPvbhx2lLAxiXAyyYoosz7+I7w8SCZvXecHfDWYOKxPIEAYuTgGYyLdUhj+c05qbb8jHzzv4
 4cLWybuX+S7XXXLkoLr2LNUMk3unbqw0Zfif8WdC5Neji/qrzeaUr5NmiGQ+nflAi0183/M1tfP
 yGk8xAAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7E8CF18000A
X-Stat-Signature: m8aydk5ozi6y1g8ae47ytfzyur4reduk
X-HE-Tag: 1791904503-288561
X-HE-Meta: U2FsdGVkX1+b1Hvuoum2Zk7U2Tz3HgWRgnoq7EkDbduF1OjM9G/XEKuq1DZd96Q2/qxo+H3YFL8dMLFzPjB2ENNeonT3+e2OpuH1BJQCb6ne/KPK4jXKSaCk2Ty4qk3rcodsHxVXTUsFMuRMKqGqSExnkNEBGqxg9vNpUkJ5TeAiBlger2cJssuJ/a/+kEU5W4OPjHBNGWm9ojkXsxuYd+kHa12udWndin9Hn2AOIbWr5ZLv53Dtd8appDspFWWP5Gej2U4dQqcNH4k9741UKt9esS6QPCbdmGFGxOel1/DWIeITESNa0Lq82eFmHvfg6KvqR7Er8dINbb3WhgJSICLCwcplSvJfyN7Dtg1zDPaq5k6bwCuDg2CY57e4iKH4hixQxUKJo9dzNGBgcH9zI3iWm4+RcxdIVJBjj8PkJqf5631ia0gPF7aHu0dyXbroAO2mr7Q+wIVGeS9Aq0RldI6X66mwdJqPMUC0kb/aJefbDKuOsZF4rB27PuTkms7NffUgZAcwLQJz1yqG2hfq53u3M3ofH2EMaRTAbfltK24/N+4WFe0t4gVXRO/5CXWGjd7wnQ98SF48MLP9veNfHPLfkjwNbrJamqrgszz6/NEfvDdM0o754Cp7k9i12q/Z/AOFSzjgbM6zNRoqUhyrsSfCYNAmOBq1gekFZlrfBXfDRP80+YgV8i4W/p3i8kJ3RY0lS1AuFozg2Bjv+20TtCnyJIE5sq2yZCBj1XoHqw2XekNKDzZrnsSAvumfnC6DO6kADDapP/7gdNOuSWGOvBl20DAShLbZ2b2hfzzgUjKYN4aeMXNSeKweGs8sDGzUcBhRC7uj1zqkx36uEzcYuX2CqS45/W+AkPlJDiGaazvt0k2S3imZq0WSOt3vl0prBHeWn0aOfsuOerq06ZReUy3/tGKqVhAkMAoGdrRM/ueuPio6Zfg1SxDuJirUNR9xiNKxnW49LEpSaNt+5am
 u/cpZNGE
 RA99Pnv8k2/LZY9YPZP2sYawX2Tm7DvfAzzW9cvcdx8xjQj5MKdBvMYHUhCxVaWdnsoQtwOBt925rSjtlRPwir7aleWPjvjkgdPibXMrtU6bcRVocx1nGLVVMG/a/VQOk+GoD0KWV3dIRanJT2Xq9tk8Fn2JFAvFYlGeRJyz6QV3sCW54IWYOA+A4wLvDgG/QAg64ByleEOXoptipuFXsdMgkPYKBo9K+oZzGQuptqHpErchG+3HtOR/nVmspdEPDB2nEviRAEUFFl0BvaJ+BtvvboNDq8SSBlNaeFG3T5zGFOhSEPSKBMlBe8mLf+G780AQDwBVvHeFkzx8iqorU9LN7Dxt0UUhTFFNTXL3XwN4MMjitSHPz+Xx+jQY1nh6rFnHV4U0gvoclGvaQtG7//e0zQTwSFYnHqzV+AXELcS91CM7BQurHTkJG3jRdYc7ihCvfXB5lpm9YSr4rA4DTmC1/DLYWgh4KJQktMfKvfkrQgSzN4UMJF6nMguPjFZvkF51/8dN1buiaZb2PAqOAPE9u7j9ZYXLJ73ZLwQZtuEgl3eQk+H2GYGuTZeR6od+p2OsLH8BM3AnqomQ1hfGCNdQsgXVN6YRxwP4/L1BgzULUGKjjifX9b3VKyc6M3Mzw7Nmb0+sdCduPUohokylwCs+z/233YGdY4h+CNXDXPiysiWFCKEDad5+CTdF02Mb54WRG+vCRLl4UKiwKBp+3rwoA2CmoJ95H7SanOiBKBeleFFQilLMjFzTffWVIgTVo/ucOJHCAZsTCIq3XVHvFaf5mMfAVV8G4c3i+lO/Nf867xSmE7BBg9Z+JToQQA+qydse8AdPZgEd9TZoKsPI9l8rBN/nlXAOTPYHfTf5BLM14hjxt43MO02dWnrynYwpiUNYod6MQyLAXgihI1o+p7+VjM7QLBqtYmGtsMo/A0a88Ed5CXvOQMotOzZWew/35PgLezO5IMVeknWDHOmm720uabGfu
 DFTsB+QM
 jOtgnqC/JFSGTA3CatHdNRm0FkF0YaSW//pRMJcFNR4WhaCpTZhxxIzHqMER9uziiSLFgTz7H2oK1691UWcmHxrNeJ5bkQHbTI2KPv0n0N6uBdmfAG1+22e7eFyvnDhdCy7DqFySQ/+788wYpl66onPEa3Q0vGqvM3xMK4cz2V34X1vku9Cospba5EbrfqGkmbxQqlfapFD0zTCM77dE3CHDnAFSUWYMM+LqamSmlU0lGQG4LQzFA4zsRIcfYnAVdkxcpZML4VL5Zfggp8p9DNMYcGlWWTAti/fja/nYlwzGAakUS8rVCXmEJBRh5mopHG46x/E4+9ssfMAXnYjNI4MEml4ndWvtlYuVRApbgcWO+bRHu60gbSF6tvk1vp51mcDykP4lGDMrbmbOIqpa4oACMvtz93ZufG0SloG/+3fBareTXnzKMpnFR0bIJbWJ31SZ1XihL5SA5O7OK1HYviq6/wFm776zgOzKtSR2uokJuTe/e5unRKQurtlAEtTZSX936Ko4l37TYeDvazpY5tBgYlBy4eHkP+cy8P659uzX+pYqMuuYklq27G0YcE0IVy8TyVZ8FyNaDkO5oUIRTPD/ruXCGwmedXPG1av3sJhIHzdZ5NY9ZsXujCMGfDSUlcv3OUXWjJssgwHwRjtmK2YvdRnzWYqP8d+1GFc6+H6O4RaPmsR4lhzapSc1iQNCxz4HHG3JEJnYnJLB+gOBqOcXXuVHpwZY8UBK88xx3omwjSyeWivZLix+uh7COXjv1NvVv2a+SJOsSOZOcVTPp8989TyFuAoHLnykT3BEySzJByu4K6Irrfbmb881lUdxHsRNxVhNG9rVeJGensE1Za6QXIvd4k6ghLToqotekhj/EGwEmkUS47vzYLM7OjUCrTlAaxGWFsjQIxXqqNVFxoS3QqScSyQkYCuJlYhuz/sg9Di5SGAe8t7z5W4uy1znOn7pSSWrjzZLv2iTGqs4T8HvThugw
 5iFsSXmr
 JTJhGlnN5U1bteQbaJko/BnOSf0Py20ELBwR6HaRwZxzf5knvf5kM2mqLaOFVPVhuiFUf3lctRlgLysohplKEp30y6f9yHezAnjHcQfLLpZcNGZZAkH+8XPR9YMILVN0phRFrZGUDCzYzowaXXbKn8kxGOQzlmAWd1uca8wIqfGV28bMKEoGHCb+GPtF0LQler0zrFB3PaobIQSzy2YTMuo+z/M0eh5Nz3yCSpoTMJVgAEl8Hbl6/3ZB99eAOIQBkgcZcymkTR+OyFdM6iIUmsabrllqqdnMWG5VoxUAmWK6nHHzSGLKxZqW4t7t8EJdp+9+RL9UKFBonTfUqokkodoUlNOfSDIgRR6Vjp4rm2wuxs7B5WFVAFGSHkvE2giVSKAFq4swPhbCJ1PNtXFTi7+dD55lA0hPI1imR5O0PasnOppCoITqb7EC272QjzqZQsAS2v6Fuiz4ksMx+c0EdNLFVtExHmvkjFWcLLRKe6/VQIX52qwxXlq7MNixQ5HBfODHiYW30NxLIks/xxNDu0ayOHSLzss+NSPmP3cH8Kdmir3IfxwzRw/wHgUR6j0kNCeQjKkq1p9JVtoOZlrJBIUVYnOeDjwibhGTeOb7zTagtgu1iMDh5uf7/DXpLeWXtnOrrRoVJBG9iT3e8jzqDpi/RUrPdzaIhnryLp6eFjGoHZL2mD0SbBCvp8m16ZNiuugTxe+GPZJJKpW/UZRY+UsL/1Z+3+J/unqg5OaMFq8am/Musq13nBK2rJ65A0ErHHBGjANguRgtkA0gn8/5/4zO8bBdKFcVS6huyMclmosa62Pjq8GYSGZKd7kDCr72pFcmzWA6TGkv2kVy1Zi0EFDyikz+41gqT4GSi6BKP2R6KWUx+8zPixGnmfajHOg18JY6ax4J4RrPVhv7goguBhi/zf/N5Y42f9YNxzq3ofV6XDj73b1nxy4HDG+nq9SCfGVQYP0bSyXS7SSCBUQ0/1Ws61M4z
 jSLOK0wE
 2PIgQFdTy/gqYdLo19vqQ2sV8Duij2s3J9JinlhuMwAmtXIZMH9jX5tXvyOsJqMmBcg2S3xQBo2ZabKKhWleNprrgn/mckgRdVvs+FOn6ofg6s9EqhlMOA0yILtP/Uvgc15v8/cfghoRN6btyvvF+p4FeXaivDeSmpus4w2SYAh0QtvCBkd3mrFmHmRZ/iwwEVmwwE0w5rSdDHP34E+tkbwVrFf0G8ugqc3+XIP8V1VjKc3Gc8BQx2hmXcDt0gU4arFXzltqBCHUAlq9817mR0FNi43V9+GPmacCOAOxEcIOUfKgvwRtCS1X/ElhjvVsWIZRKK06HYNieTVJyHkjCjK/9AuMDNGTYFthG9e5zirLST09mvtdp7+LLh9X4aOFVRAhKCW4nvAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This determines whether a VMA cannot be expanded or merged because what
they mapped was determined to be a set size at mmap time.

This typically refers to mappings not managed by core mm, however
VMA_DONTEXPAND_BIT
is not reliably set alongside VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT, so we
must explicitly test for this for now.

We also explicitly test for VMA_PFNMAP_BIT as VMA_DONTEXPAND_BIT may not be
set for VMA_PFNMAP_BIT's despite the one implying the other.

Use this predicate in vma_flags_can_merge() and in check_prep_vma() in the
mremap logic testing to see if mremap() can expand the VMA. The criteria
for khugepaged and MADV_COLLAPSE eligibility in
__thp_vma_allowable_orders() are precisely those for mergeability, so use
vma_can_merge() there (with an expanded comment).

This obviates the need for the VM_NO_KHUGEPAGED mask, so remove it.

Hugetlb VMAs remain excluded from khugepaged as hugetlbfs always sets
VMA_DONTEXPAND_BIT.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 39 +++++++++++++++++++++++++++++++++++----
 mm/huge_memory.c                | 11 +++++++----
 mm/mremap.c                     |  5 ++---
 tools/testing/vma/include/dup.h | 16 +++++++++++++++-
 4 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index df8a5a1eb9c3..2ecf39bc857b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -600,9 +600,6 @@ enum {
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 
-/* This mask prevents VMA from being scanned with khugepaged */
-#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
-
 /* This mask defines which mm->def_flags a process can inherit its parent */
 #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
 
@@ -1647,6 +1644,40 @@ static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
 	return vma_flags_is_mm_managed(&vma->flags);
 }
 
+/**
+ * vma_flags_is_fixed_mapping() - Do the specified VMA flags indicate that this
+ * is a fixed mapping that cannot be expanded or merged?
+ * @flags: The VMA flags to test.
+ *
+ * Fixed mappings are those whose size is set at the point of mmap (for
+ * instance, a mapping of a fixed range of memory established by a driver),
+ * and thus cannot be expanded or merged.
+ *
+ * Returns: true if the flags indicate a fixed mapping.
+ */
+static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
+{
+	/*
+	 * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some callers set
+	 * only the former.
+	 */
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT);
+}
+
+/**
+ * vma_is_fixed_mapping() - Is this VMA a fixed mapping that cannot be
+ * expanded or merged?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_fixed_mapping() for a description of this property.
+ *
+ * Returns: true if the VMA maps a fixed mapping.
+ */
+static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_fixed_mapping(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1668,7 +1699,7 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 	if (!vma_flags_is_mm_managed(flags))
 		return false;
 	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+	if (vma_flags_is_fixed_mapping(flags))
 		return false;
 
 	return true;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4cd917f77f3f..87e8bf8029ab 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -212,11 +212,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 		return in_pf ? orders : 0;
 
 	/*
-	 * khugepaged special VMA and hugetlb VMA.
-	 * Must be checked after dax since some dax mappings may have
-	 * VM_MIXEDMAP set.
+	 * khugepaged moves data from VMAs once collapsed, after they have been
+	 * faulted in, relying on refaulting for file-backed memory.
+	 *
+	 * Mappings not managed by core mm cannot be reliably reconstructed from
+	 * page faults, and fixed mappings (including hugetlb) may well be
+	 * mm-managed - precisely the mappings which cannot be merged.
 	 */
-	if (!in_pf && !smaps && (vm_flags & VM_NO_KHUGEPAGED))
+	if (!in_pf && !smaps && !vma_can_merge(vma))
 		return 0;
 
 	/*
diff --git a/mm/mremap.c b/mm/mremap.c
index 7c368440fafe..ed19b47c2caf 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1788,8 +1788,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 		return -EINVAL;
 	}
 
-	if ((vrm->flags & MREMAP_DONTUNMAP) &&
-	    vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
+	if ((vrm->flags & MREMAP_DONTUNMAP) && vma_is_fixed_mapping(vma))
 		return -EINVAL;
 
 	/*
@@ -1827,7 +1826,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
 		return -EINVAL;
 
-	if (vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
+	if (vma_is_fixed_mapping(vma))
 		return -EFAULT;
 
 	if (!mlock_future_ok(mm, vma_test(vma, VMA_LOCKED_BIT), vrm->delta))
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 89c645a6ad60..442ea9eb098d 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1676,6 +1676,20 @@ static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
 	return vma_flags_is_mm_managed(&vma->flags);
 }
 
+static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
+{
+	/*
+	 * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some callers set
+	 * only the former.
+	 */
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT);
+}
+
+static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_fixed_mapping(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
 	/*
@@ -1691,7 +1705,7 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 	if (!vma_flags_is_mm_managed(flags))
 		return false;
 	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+	if (vma_flags_is_fixed_mapping(flags))
 		return false;
 
 	return true;

-- 
2.55.0


