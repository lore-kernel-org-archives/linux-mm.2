Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD2DC88E77
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81826B00DE; Mon, 14 Sep 2026 11:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B32BF6B00DF; Mon, 14 Sep 2026 11:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB7A6B00E0; Mon, 14 Sep 2026 11:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 759036B00DE
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:17:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD65DC0193
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:16:59 +0000 (UTC)
X-FDA: 85212720558.30.8F01759
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 02A9620009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:16:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwuPzG5j;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789399018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwIdZujBqtKUK3euRg5palCjbTo4zKXqAqucXZZYP/8=;
	b=r/2Xqh23sHPFAHyWFxc7DPKwYd06DxbkMStJQ4FLZu9whjS3u9nOluBw+FPOYffttzE0ML
	uXPQ7jaUvckPRLIAp1mDf02JrGtP0FMV0XCbg2m5CWUtsHKy8QgpHIt583F1BdpC7juINh
	AVybzb6EEqmQcdyQKYoCyJ58WHdQmtw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789399018;
	b=tl/w621jJdV10EIMBjs5PxYH0+80203zwCdSkYZikYfwtsYpa9nOXGckkfoSQnFJsBcJCP
	TEuJP/aEiowtgJisTV8oHDtL2Usspc4Xh/Sf85ryQrOWSseXuxW0jZTfuX52F9Omj6yxRh
	prRJX3Vi5bPdMJhykkXBtEGLjQ1zzqc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwuPzG5j;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E6C641619;
	Mon, 14 Sep 2026 15:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF121F00899;
	Mon, 14 Sep 2026 15:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789399017;
	bh=XwIdZujBqtKUK3euRg5palCjbTo4zKXqAqucXZZYP/8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MwuPzG5jc3XwBALazXoyoSf1F6W4Vk7TesRzHZph5bz4NWE+Qhr0xkYShhSOby6xW
	 rRsLSYW3lpaGbKz0UXKHDcy1hFN5oGFQXmC+oSCrSL+pIeqFLtxgAjuvobkHPVYNpC
	 bkw7r5YyO1+m3N/f/mOUQMW6E0zhuAO1Muy5SnYYjo41hU7HOLSyZaprwPDum0aDW+
	 wY3qEN//rE/RHoA1UXWcDfe8rjaygMowoJ61xJUWjNPQl+8BmChkoCDSstjxCMY0fm
	 L/aqiJBKN2tyqNX8Yb42btZmcizmbyVEnyAAzIsBJ/Qsc7aM3cqFZK65jbBu1VCD+4
	 9Lp4vmuSs/C7A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:58 +0100
Subject: [PATCH v2 38/40] fuse: dax: do not set VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-38-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1455; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RCEYQjEW6MHyrFoJLHJtSFluFNRdmgFFgjkTdNXkXXM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG/xX35bukAu27hQIH+1WMW/qMk++y7Ofd371uhb0
 JTAm/+yO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRLWUM/8sX1k1K+tX76MWr
 Jati2PIMvrhc2pl0PVXde9Ks8tM9q9oZGY5rdBodjisqvT1BQLD41PdpW049vdzYd+PhCc68+JL
 lVxkA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: yas15ke1ry4jyq69o6e96dunf3h1wsqk
X-Rspam-User: 
X-Rspamd-Queue-Id: 02A9620009
X-Rspamd-Server: rspam03
X-HE-Tag: 1789399017-78463
X-HE-Meta: U2FsdGVkX1/BPo+HmS97bfwrgL268q1q+tD/c6Ksqfou/kwZOUY1wMGnuLj2wana338R59YL1UIp9l40C7VK6haIBU9TKEvkVIKSkcfjKTlU7EjBAKiatBe9s+cSV3iJnUnV/mhcn1/WUSVPTSRDFODnb6lQo4wwYuQBHHrWhUjzlXOl5BcNPQglFtaLrRQb3+rnEWqaqepFJz/hO3Ml5tqGTdkvjBM+aJgRsweoBXPAgXC/Il3yQdlw/J5jvXUcoHd1WOudBEArakGBQdexNmACMj7ihZFiRsAeCmtYLOJhgUuWICtjX+iEcgZp3DZvE7vjkYWXdUb6n9DiNMzQGxo+7uHEy89CPPDQzZlXmOIQwy4jT3OMEmDMvsHhw7NcC6xfQJUWo6w0Q+rrFAnqz01DeQpd+BDBfD3ZNMv2bndBSMWPitphwUrtpOqfqIfaulP/pg1eAgPFAeyHJAcl3LAL2fmavq9xQlPjH7uRrN2R6/P2tCZs/f4cfh62H41PmR0XqfBiA3xTH9YgBrOB3TDOidPTIofugeBZ9FHQCsUg7p6oflg9HsNq1KANvRzPiNcQiGhpyk1o9nY72E0Yk0PMmjQfAwYYL0mbJfBmw1F6vvPWiZkmGOdIIVQyfjznbMailjZe0qz53YEKf5MvzYIYPcfgctYPU8H0dOlFUSO4BFKKqzwA9QSlHln7qSGgmdYpYmypBX8G9+jAUJuYxZ3ZxxHbbVnQQIkSL+s3Y+z21cK8XraY4JfGCIAvYIM6KqkQWbadae8cqpsjIwmPCfPKNgJ30POQa+NGEmS8gmwXEBb7VuKuIMV6ItkhXK2kVmSBTI0Zjnxkw2O/h+z4pu66WjbCnL1ND/CVIKXiJYJP+J2j5Cv0wTAX9+h1K7SyRfVFlsuMOY5V9gTSBFm306x1l0lVw8FNPjukHsV8M50yt2fgqlDUZpPqcVChErn1J9q/vQVc1XmJC168dnA
 utCHBH27
 +D9Z4zYGBvqpE0fxpXaJLmbgdSQ/yjcMy1MBhGEi58I/vQrcQ+/NlrCBrB0lLz5b1m9QO6bBaWrzr8hd2YBCLfLcNFWHjDJj5pNzE6SjFeZ+FGRUvj8XiHDIDE9DFoXxLuJ86cl8cJLTSK1rct2f6qFKKT4/SNAp8y9Z+AmGO/kfhELPzD80wPkIclMKP/vDYkYgZK6JJZewUXIxnbt7vHe27ixSHHyjqs2dUOP7px9aVgsH0IVUqvYhJysfpUXyxNwjIM4PIdPrHwOWPbyhsQGRG5rO0j6oIFgluqbGTKKwssT5/iqCG5YaOZNDHqmPw2xy6Dp+S+33Bg121T87wyv6wLtJfS1VW10OjhnNh6wVFkJqdLFWRXdIqdJaUhYcjdTflK7BsFyWmsva8c7i9iDy1tDIpswNduVDnuUEfeMIT9hSmFden/oALrct9dqupChemKSf8i4dhq9YVH2fnZBeDGZH2qECkzHLxKhNN0krEfYATXw3TWE+CYDKyjbDl/oVS6BulyZjkPNjpC4UIltcMF4gd/+r8am3a1EZzNhRMRiXoZO47xPxeJ/yGQr/1XPoGYBM2439LLexHsG6JtaFDKDA4XIDsj9F4rU1j1VWfXLbPf3Gz0MCxpSZYLBBMQ28N3j/HfvhcvUHxDBfxkCNbJYBeXXYhDbpjYOIepI0rua/PNQoeQVZBUxxCqwClj3RDbwjFCdIyfUN5TZs2iaIr7MNmJ7TZRRsWvk8cuhk0jN5SvTjMX2pVyzUUQ4iAHADchsG/XxIx7xeR1pc6Bx3JiSfXfuX7ut286QFDwwDrJraHnQAufxzFeQfKmUKBrZSDUlHXpE2VxwyUJc9u4vu+xdj/pYKCkInGQr+EgxiGvIHZtnujnMGUspR6kHVduaBUqmaP9uF5dBqwvGRc8UhDN8GrpCZOUdQwgY+w8wLo3QCgCfFckkTVscGduBrLpj7GkTE70cs149j6OY4iPbaEsIv0
 xSFJYjJl
 +QXRKOukelYFtrTriHxOmDuHZWtuZKxO80dLl7J6tUVg5Tuy9/QmadDTA7Av4kFG8iAURdcpgCQPuGGtNAo/+F9D851zXfDUiEqVeW6wCYYaNt0JDW9WKrPPWc73Mj+J9OEiQyoyDa5KbTp2J4hQWSueGhcqR3EBECQ74g3qAW/wGdKVCn8ZDvGUENP3/lX5vxJL+l4MlHmODalyIAHUL3YFyIUsdj+2hAgQD3ZFmzqY65J2AGuxuWiHS0T3I+1Stu4VevZhOKp3JAqjPNk0o6GAhkGNxx9R6OlxHxoXqN0buPoYcklQlmSJE8dw3TpdWnSEGt89aE/1PVUlwBP+i0dU1jHUa9+qUjTt7hB+Ms75xMe0R4Rkt1Mm/1RrB0MEedZzF+HGr0yVu57tHDN6Ajgam+2219+9kQNWhGlrzRvbuwmNkQops+PAhStTOyb8pwMdi0zfOB2sAlOwoqsj/+b4bL0FOiTKBNUzWY7FUgMBaLTKo63us/xe2/h1HTfVxmse737ehsbcOS91+AEehLyIKCyNUuXy6Xsm23jns0Goz5mYfjovT+HgR+xkMrmrGY+KDj5uUP7ErO7fRHF820MiHOEkOk6JB3enP+G0XAObNKUk5JiuLWbsxTzVfcS6UROfEUkDw30ubDRQw35kDaOr8pWhxtRbbj2Mj0m1h+Cmk1xROhTqXEjxF2eIV/u6UAv1jir8M+n0ASvjiAMoCpjuKLHphOgSn3Ft4nBLYaslKgYeZW7B2a1gYkMR5n+HYtB8PA55Y+WhLSNicgsO5MOS+zUqSLwbQa6Sozm535w3wD3982Hjh68ZiccrRhmcfP7sXo1ElNL0IWF2zNe35Kgdawh6Q35K+Xg8TAHmewx5/DynlF5k4oifvgnqS8OLUdF5dDWqtXq+NkAp93K+VlomA6nTqPWa9FsZ/Qw5JixV4k5ndDifH3VXR0q6mC8sL1VP1iLzzS3phurTkXTqyBQCocnV9
 YZaLa507
 kiF53nmqWm4peyya6beGVaGIwOwAWzjfsY2rTQptzsIiXR8u0Y813zVo5v8YbAlAs78OCzr4jKYj45KYBgQ75p0UxBV3rw/4HnI5ubD0DnANHpbxUWQA8mKsD3BV08R613jCA5LiZMzG82bxowz5r9CEFFxxFlZvgRSgxm9av9+s6KAGmyWiMKXrlir2LVBGsc92NB2c9rnCvoj04yCpLQK4fUWtyMN14xhBooHaFG98E+ubYmdoLHJtaH75WV1+bhM6iz4fpfI5Z8Jc5ERRotLSnvQy3gbCZnHJPDDZemBgm32cUUcMvkVBNwV9Wdc5o234nDT8eJDnfshUPtBoDsEvnRzJbWY4NHzGNGL01IVZeO0bIFh3+XHtdsxjUDtcq4L3mzWyGjDvtBTNnGY3Ng8+96CnnoRdkiI4IOsQWZp8/N8QMantHEPAJyRig2qb3u/m0xnlrImBpEYf9Jjv1jtM+C73rqj+/b6i7aE/FN7PkYqpmOdd7CKPsnYDIynIPSU+ua7dwCy/SjjE2XBKR6ZFmV3QD61lUin6vcpmhOqrw/xxlTH43+bX+1qMRHdckTwe+PXRQxa/Dn24lIBkSSJbpE3wvHhNrx/qHeROCzZ/YBJDYQo4jdi6ygFmZY2pr8ZMSWLz+qyWTWoNNE3IHw3TZ95oG53T//s1LQl9tNZCzkGKPt65f6ix3zDED2fLEwy3kD3w+ZpwGclQ6LslRwqLgejx3szB9+2hVyeKQPK+h/XrN2oWkk+04ygKqsNxlNBDae2YX6DUohKAdp10pcPneOjmFkgBtrvRW3LaXZ7UZ9CiL8jxZTmUY1i2ECUbSVp3Wr58aL2lStpzTqUlCwrMs/ZNQLvYF/RNPKwUDRI80l3CXVFYG6AQLje/LOto/+L9SbG9QRusFhEvN0hITgHjd3mTlFoeBwosETZtaehRQKcqjFMKUldPQLXaQAkfa6I7yuSBQi1n8BsMZfytqRcXrfOaV
 8UVppGS1
 Xiu2wazU25jP/4M13hnETlRJCV00SO6C5Y2Ufx+2nhqRWaaW7s1eMTTE2lsVh/xV0Lg/amlVDyLpPc2iPiMIEjcrnxDm1VSlmiNCqlp1K8fdDboMY/w1NcWVZbmwmeooacOC7EhjW+AqKen6hxYk7qLxkyM7T3sI1ZL9DRQyVSbF1jMSctSwsdbgUjh4U+3zdu1HIlg07TZX+sC8hsqqO6Etl8cGvh+iv7+4ZnGUYfbWSZ0yy6myOih8hqYMrgWV3fWpcXFn07KEtLT788gaQlheh+6fhQFPwPRDmDw+VDTgQ8kzYpD1HlDl2JtUlsUXRf3RGh4QZATgo6MWXE7sIfUp60hSm22DuBtaCEY5dl94TifX5Xd+RCSLjQTBP39Uxu+rtf/EfTcfwWmigvlDUM7Y/97cfh1LQzoTZqTtwRKTEhtNezjfZGCGBYv2SInRGJf5Vcq3AxnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit e1fb4a086495 ("dax: remove VM_MIXEDMAP for fsdax and device dax")
prevented fsdax and device-dax from setting VM_MIXEDMAP, as DAX no longer
relies on it to direct core mm paths.

The fuse DAX implementation, added later, copied the old pattern and still
sets it.

Fuse DAX maps pages the same way fsdax does, via dax_iomap_fault() and
ultimately vmf_insert_page_mkwrite() and vmf_insert_folio_pmd(), which
insert ordinary refcounted pages and so do not require VM_MIXEDMAP.

Setting it only serves to mark the mapping as kernel-owned, making fuse DAX
the sole DAX implementation whose mappings are unmergeable, cannot be
mlock()'d, eagerly copy page tables on fork and reject MADV_DOFORK and
MADV_DODUMP.

It also requires vma_is_special_huge() in mm/huge_memory.c to carve DAX out
of its kernel-owned check explicitly.

There is no reason for fuse DAX to keep on using this flag so drop it.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/fuse/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 85cdf0199bc0..a5994f1c637d 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -826,7 +826,7 @@ int fuse_dax_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	file_accessed(file);
 	vma->vm_ops = &fuse_dax_vm_ops;
-	vm_flags_set(vma, VM_MIXEDMAP | VM_HUGEPAGE);
+	vma_set_flags(vma, VMA_HUGEPAGE_BIT);
 	return 0;
 }
 

-- 
2.55.0


