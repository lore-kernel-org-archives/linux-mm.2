Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4950CC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DED826B00B7; Tue, 13 Oct 2026 11:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC4C06B00B9; Tue, 13 Oct 2026 11:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB42C6B00BA; Tue, 13 Oct 2026 11:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A42BB6B00B7
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:11:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 453EB80C3B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:11:31 +0000 (UTC)
X-FDA: 85317941982.23.3E0DBD2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5EA89C000D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:11:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IKIipxQd;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XhhlSsemSmxgXNdMsOuIhrMWTeKjuFdWFETXzMuu8iA=;
	b=KO6j6VMH/u2ftF99YwGV1l+ncE7/uU8U642sjjl6iuLRiRd/n9VtRJUSoJzn8VyWNAcD7f
	FSwhvNtUxsd/bUZ4hcOE0kRkvGd4hoe/KjaYrw0zVslrMU8uJE4AZGuggqZJ0fKOK4NFuT
	K1gPwAK5B6B86Cb+DAmVcOvSYuAupZM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904289;
	b=NqoSLvLkkw8Q3cV+lUdBAxGa1PjBM8sifFBNo6vE4/R66lk34g3BASyZMtvC861sDAK2ZT
	C36Cj7KeyzKut9Ttx/DJLIRcft7KR1WC19Aq033MGn7saKVlJ1dxM8sALZ5Wkqbq+XcmQO
	HBrbbcezvdIOI3E7SYWudjQpj/j7JDg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IKIipxQd;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26FB641823;
	Tue, 13 Oct 2026 15:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF321F000FF;
	Tue, 13 Oct 2026 15:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904288;
	bh=XhhlSsemSmxgXNdMsOuIhrMWTeKjuFdWFETXzMuu8iA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IKIipxQdSPSYUc5DegrUfXhw+UY8TxEShwIHCPvOyP3Fo7nYLrh2IQNkAXJ8Fk3qG
	 5NKm3C/qQcM20S5Ki+XOsdy7/PYqEIrWtp8UI6+CeCk8YsmtC1N9fd5BTVf5cFvVNk
	 NMGpPlHt+op+fQCHjVX5+1fq9U5XJW7JYyarTQkoorG94NXtyMxzn733G9axCeMbJa
	 lkXYeo/u+cEaIxW4lgGcl+86OYqFfpNunFZ9kYAreq2eu3+0vOqMgkp+CMRpbnQdXp
	 s5LL1MpV7OhrpBtNQMA+1eZGZAfEWJqNlwJzyWsvPcmiyRSFwkJzjxFLZP17ooUtjE
	 9tF9+0ODWeiYQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:50 +0100
Subject: [PATCH v6 10/39] drivers/usb/mon: update to use mmap_prepare + map
 kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-10-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6274; i=ljs@kernel.org;
 h=from:subject:message-id; bh=MVQ57kbHbmPy06L79MgXIJ1zXhvIw2KdqOI+DoqsBik=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZww8O4S7JCc5rj36DPzyVP0/8QtrKndkVv56HDhg
 XUSFSuiOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARXWuGf7YXuo3euG15J7w9
 JGPHn3RlmbKq+WHX9sRN6v6lJRQ3z5uRoc1risU17a+rt+i4RG6aF2+pvbrs2/UKDpHg+av2vJO
 axA4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 5EA89C000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: j4xxaoykm1ex4g167urg3jwksa7r1id8
X-HE-Tag: 1791904289-314902
X-HE-Meta: U2FsdGVkX1/P2rmawScGsAgcmGA+hKmC9F/VOqiNsMsnO6BPgwDsN8bWWf31b1A1ywChQ57B9eAS0WRjcYPfNiKOE5GdMJ+V5WIVHDamGxF3PkTXNqpkX6VWkJyHce2SgLfomeXqlcHDdPdZjGqQx4hNxCnGngUZLXM19a7uPMbemlVUYEzY7e5ev4aG29PVTDuQp93q4od0lM5rlCtmKINkaKCByl7yV1uwXRFB9AlyqlBVTqWJapJmYJSDBcjt4uM+udE9uGMdV8BBhXpvQrj1tF52ZzJvIyh9NwVGbvNRLVP3JCRgB2lInE/KFuBJ3arDpQuZFuaIuglD5VxdolgDx6yVlB6gpjOqS+UxxaAHmJr+fLyz5o6hF3B1ofHQurfXGy6AmtSA4QtYGEmY74HpdhPmZhx+TXVaULrXy3T+8egLeWwWr2MqoWmnxIgYqjqj+OyOmocYfW3kBWqIGPT+VD1+jQ2lp7HbQsSX09kParYF5uznZRFnMTFCcUcGLZyZA7zV46bZqQDVKncfOniVRMDjMweGEwHVtfGAAHKOKQqGY0HW+LZQqpsgVVv0NXkuPUfqY5evpIifBB8L7QGivsqXFsFD8gfNr/I/KtUQbPp0bEkpQp27kcBq0j46uLR6og52K8G30LvI2miY8G6hDHdIiPlXK+Puyftoux1bMgbfeneG+wmtUwxgQTxqic6yHeJI8vMNLqsWFYbncgesDwEq6FRplBdzjzQXwSv/ngJKEy0BeOEuPrj4yhj5J2UAVUT8gyf35yXaB3CcCBWAZOradbjkReIxe7aNRxRvnjdmINV1raVmigt6QeOFYWupCSUHS2IurCRgiL00xwZ2nN+rIDFPVrpEWmFpqUb1GcgLsVNUgT3RDbt95TJJjynxDafQU6GLg0zK2aU1fziVKFn52Na/It+yzHwp9sMpATINeTHUOmMqf2BS08t9CvUxgmq8j0SC/5NQLBR
 pBWz5exC
 o3DVMe9+FKwZHU5Uc5bybLAyVNhiQo4ZNUmBJTZtecGIk3sQyHQuAjQZdUlkKH/yJAUJv60FqC7dCn0Mf0xwwgoB4MGKzpuecdsFmDRvHUee4GMBJczyWaJH1XrU1r6W4pbrPc9eiGPL77boeuc2MxFU0LdqcmfX93kjLveDjsK47xAFp/8d8xSdcVdz6HYc2xxJ/PlIP9HSsT4bAwWvLz9xXhiIwDMCPYFnL0jfUzZUcCp5H9m/4WtQST09tRH54jCKgHqOo+B6vF67/6qu9kGC63gDFhsNE+PJMyatkmN407HAlzswTbaOsIMM8k4WnTLOqd/GDbfOYCw0RP8d3pq2qpdUr6Fd/5ZSNRXAzkYqVW41tCMv7IRP5kUwK//70iX+m4PU4uknXhgJ1/c7qhQ1eNsCHdM3XPXob5U7AjR/X8ZJxBdW1QYSEEVoCRTkb57VQvo8poltsSPbU4M3BaFBUFF/925x/tGc9dg/lx0v0Hi7k1bs4AfTiw8rePLJ833HCd/KedG/4fAMKjWTygS0irD7ca+hPAjighYq9MBgspQ/v0g+kMYdC08K/tS57MmDlyed9ieSFk1LPZnq7Xi+vkicwNyJ/Pes593jyRV78NDh41ictOj74Y9+rIEsgZAJGuWaNE5wqJMIzDqDmAs6aePCq2GDyu5XnLvIm01iC8SySVaK3qdJ6vstC0EnE0hbEScmogoKjvWflcg4fljnK4RhSVf2tngwHSRhXcnd76UQC+dH2kQ0+LL1ZzB32XYu+FUww8X5uQ9yjcObqpa364De3a2UjtG+UDWMOUmZoPsdp7X2t6GRL3jFltNfXhiEB7lwrdk/l3urRlznQZ8HysE65hTd/3WHfp7QlnLs4ITxXxDpSW3M+NbMGLv7a/5dbMrp3Dy6aVuOd3EoFyYKEy7QdKmvJS5duHpc5HKLsY+/vI47SqfgLrT/9IHm24HJkjX2p2/XAX/lYa4sqrSvZAevE
 h+Zr4734
 2Mbq0t1A4DweQv7fujgwCs2I1f4O//Cc2YY2tYneUP+I7t18TpgjnihIovR4w4s0ZznaTlpgkEMjmTB3WgsF3dZ6jc4w7Wx0OB/3ohgD7pBmjTxYcpQJ3vRKhMc+h0tWgcMeRpSY4hbXAPV8gp4kvH5w1ue076IK2Dbz1IBPgnHpwULLA3wlkxQaa1luvyq2O1CSunkmI57+y+8xTQxRY+f+Wl5DKsqM3t9WpQFlXDEMFCakTwtN7aSxkNjyIVE1tIS0ok6kxWDBIkpGVVVM9FRJENLrDNLkaHn7Sq9pDOWAiD+5XKS/Z/HdB6tIfrgzTXNo77UwRTJZXJswhytYescg7iSMyFzaZbVjcLy5B8owf2kwNjxHolDAiudUgThrgVa7+hyQx3y2FNzVHKInqLQDxeR2sN3KI4X2hdbipe4WTUhZrYxauReXMoRRw/0dMzJGYmgPXJ+wP81o8ffR69iHJXwOqA67AciMr5ZngSJahcZiwIv6YSkAVqCfCNXelW4IYsczJaZZy8Kiig74M8GzshhYwnrQzezopf4RDW4k8xh+THnB2ulWONLWBBypeAQpUoR4om6Yd1tYOcXkQYwb8pDXKGsP2F8FVyGdkW8dIS7dElXDZ2ADvTDiNnJRI5r81lJgd+8H/J+NB+3YLh/q0hI4m3PX2jkztd6LHU8CUrSROff6hZoi7NwGS8IbzjZIZ9K2E1VmNrehovSpNlqdvBKvHpU2VSWudHZspoJhLscT/eKd42hvAUaPVVCuHU9oGNMLZqGSrrnKfo9Apsz2P5VMDZKZhBPQJkUR2B9f1xRVX91Dkh6cT3idfVriCDvOlrlWkOkiAIEdP3Q3kHX95A6spUnCVm/zWc+lc2hTj6cE0OzQescUSM/nZEXTF9EWnpTe5uZeDRjR/ty3f/qpsmFkPoBkd4jnr5R8KsPGXl2kVy67C5jmStTGG1p4LHhhjdEvcUN8AdvZwb9gRpAFv6c9P
 Z4mX5XTy
 +vQdgCoM3F5oL8WDVv1Tq342P+ugL2U1b9RX/XurZVIsZUxh4/nwR/kyQ3ZgRgz06IysLD8xFCqIW4aHLk3mux3MVGkIqprYzsNPZIkU16MtWK+jcjoQKyo/exvkrJJjaZ5ZhFXqYpsSE4JfETzUqbw6bNwj39NNah08OFDVfOJ+0PUkds+Rimpva59fFaHtz/bKASONWsRUf1iqZqessFJaZtzdQZIRaYBQisbz7E14zYaOPQhqeLS/xyBiDpLUyECs8uv/zYF5G0ZaxdedSzvNlW8oZphfss1GDQ0aqh2qk/xFp4gxnVinChVLpkMS/iR5lB7fFCcuQBnFz1BQ/u9DndodL6NTt9LqzUNsuycY9qqwrbDHjjAdhNDG2+uVjaZhyZahn+HhMQ6F/vO8Y+PhnN1S7fzCKAh6YJlgT7U/5SuC4ye23/RBEOoM+Rp3L6gUR/P/4QeJEt4KmcyypAwBJVlm3nRXmd196apn0jiMvVFYkzLSbzS5/iFQ7Wm89ymSIAyVHdAM/v84scDDft2kd5pcHRC+0gLgRnusrYH+m86Zxk3Ih2wqhxdbxqKVECKcBf1VBIeBRFApv1BgWMJ1I8wSDXtE/Lcr+HNXEWyOz4wZL/e6HTSTlklFCjsI13LLfKaHxK5uCyjTcEaBy7A1dWQiPUOZ4OfAg6PGxDXE84ZOTmewZCvyQGQ8P7qiaHS4GjYc9YJwcj7BBSInZw2sICKS0TCryDK7Z3Tw7XE3SXg2pvoPqGKULmm/yTMKFP5YOijQq6UabRry2dvab+cjIDiZCNjTT3lRuCqpPgDenTm0s9H94Iq6F5Ancna9X2cc/8+WT34EqLkWeO8JNo0jprkluqIjXI98KNd0dl8yP95iIHpbtRrc5dnYLGodNiydSRW1JGxTw9jTCds9Z5Oje/EeWgIPN74IrotFz5VlFgcddFTIrVS2v3ZaXS7Yo5BvRPpXFYEOk3GTItsV3cck6bGR3
 cb7xCcgS
 nlATOt5u10vxYWkr5nlDRTiBkMFBPTOCZWvK7ks88zYnxylBbkLUjsN+8IkERIKuwGAJiQgkGd69eXo2P66VUcrAoRdxeuMwJcj3xiYdEdMEvHzhCbvYLiSezrc5XqdKA86x8uwPAnL2gSLF3tNVL3IFlZ5x26O7Fdn9VPe2OHrhyvy+Dp6qpi/xttdDuZ6U4apu4LUqoT2IprDk6eJwm4OKi/qQdViZGCI5nGZVQmEPL3v3K9sIxfz462fteUKVDws6NjT1VLv06oDoum1Gl1lZ2Rg61Jh9sMTZg90dqz2CBExglKaZhH+gsg624LDn2umiGLqsouA0/tdPwXtggY9YZX+xb0GRkvRUZbtFSuiOFe+u4XMr/NgxmSRcPT6Uy86sBinpWnMZui00RDfOVA9OT0TGxzg/4w9h30HwYMrZTP0/NDPVQUrLFyuURoMrK1+DLrTOD2MOyUBeBpVgzB7I8CFH+wTV0fFhyUC6BKFz2B21QD5ZpuDa4Fn1F/8JTMSHONMniEgGj4IC+vtW0asmSob6G9rrc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the deprecated .mmap hook with its replacement .mmap_prepare. As
part of this change, additionally take the approach of mapping pages upon
mmap rather than providing a fault handler.

The page span cannot be mutated when an mmap mapping is in place, so this
is safe to do in advance (the MON_IOCT_RING_SIZE ioctl operation exits
-EBUSY if it's attempted, gated by the rp->mmap_active reference count).

Utilise the newly introduced mmap_action_map_discontig_kernel_pages() to do
this, which allows for iteration over pages in mon_bin_discontig_get().

mon_bin_discontig_init() increments the rp->mmap_active reference count to
stabilise page spans. Should an error arise the core unmaps the VMA and
mon_bin_vma_close() drops the reference again.

The vm_ops->close hook implemented in mon_bin_vma_close() will ensure
correct reference count arithmetic upon unmap (with mon_bin_vma_open()
accounting for splitting).

The existing semantics are all retained, including not mapping past the
range of available pages, with a SIGBUS being raised in a userland process
that attempts to access past this point.

Ultimately insert_page() is invoked to insert each page, which increments
the reference count on each mapped page. This mimics what was being done
previously, only we pre-map the entire range rather than doing so on
demand.

The existing fault handler did nothing that required demand paging, and was
presumably implemented this way for historical reasons.

One behavioural difference: pages are no longer faulted in on demand, so a
page discarded with MADV_DONTNEED is not repopulated and a subsequent
access raises SIGBUS, as with other pre-populated kernel mappings.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/usb/mon/mon_bin.c | 82 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 687f6a8981f3..9d00b21a8153 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1219,6 +1219,15 @@ mon_bin_poll(struct file *file, struct poll_table_struct *wait)
 	return mask;
 }
 
+static void __mon_bin_vma_open(struct mon_reader_bin *rp)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rp->b_lock, flags);
+	rp->mmap_active++;
+	spin_unlock_irqrestore(&rp->b_lock, flags);
+}
+
 /*
  * open and close: just keep track of how many times the device is
  * mapped, to use the proper memory allocation function.
@@ -1226,64 +1235,79 @@ mon_bin_poll(struct file *file, struct poll_table_struct *wait)
 static void mon_bin_vma_open(struct vm_area_struct *vma)
 {
 	struct mon_reader_bin *rp = vma->vm_private_data;
-	unsigned long flags;
 
-	spin_lock_irqsave(&rp->b_lock, flags);
-	rp->mmap_active++;
-	spin_unlock_irqrestore(&rp->b_lock, flags);
+	__mon_bin_vma_open(rp);
 }
 
-static void mon_bin_vma_close(struct vm_area_struct *vma)
+static void __mon_bin_vma_close(struct mon_reader_bin *rp)
 {
 	unsigned long flags;
 
-	struct mon_reader_bin *rp = vma->vm_private_data;
 	spin_lock_irqsave(&rp->b_lock, flags);
 	rp->mmap_active--;
 	spin_unlock_irqrestore(&rp->b_lock, flags);
 }
 
-/*
- * Map ring pages to user space.
- */
-static vm_fault_t mon_bin_vma_fault(struct vm_fault *vmf)
+static void mon_bin_vma_close(struct vm_area_struct *vma)
 {
-	struct mon_reader_bin *rp = vmf->vma->vm_private_data;
+	struct mon_reader_bin *rp = vma->vm_private_data;
+
+	__mon_bin_vma_close(rp);
+}
+
+static const struct vm_operations_struct mon_bin_vm_ops = {
+	.open =     mon_bin_vma_open,
+	.close =    mon_bin_vma_close,
+};
+
+static int mon_bin_discontig_init(void *vm_private_data, void **private)
+{
+	struct mon_reader_bin *rp = vm_private_data;
+
+	/* Dropped by mon_bin_vma_close() on unmap, including on error. */
+	__mon_bin_vma_open(rp);
+	return 0;
+}
+
+static int mon_bin_discontig_get(struct discontig_kernel_page_state *state)
+{
+	struct mon_reader_bin *rp = state->vm_private_data;
 	unsigned long offset, chunk_idx;
-	struct page *pageptr;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rp->b_lock, flags);
-	offset = vmf->pgoff << PAGE_SHIFT;
+
+	offset = state->pgoff << PAGE_SHIFT;
 	if (offset >= rp->b_size) {
 		spin_unlock_irqrestore(&rp->b_lock, flags);
-		return VM_FAULT_SIGBUS;
+		discontig_kernel_map_abort(state);
+		return 0;
 	}
 	chunk_idx = offset / CHUNK_SIZE;
-	pageptr = rp->b_vec[chunk_idx].pg;
-	get_page(pageptr);
-	vmf->page = pageptr;
+	discontig_kernel_map_page(state, rp->b_vec[chunk_idx].pg);
+
 	spin_unlock_irqrestore(&rp->b_lock, flags);
 	return 0;
 }
 
-static const struct vm_operations_struct mon_bin_vm_ops = {
-	.open =     mon_bin_vma_open,
-	.close =    mon_bin_vma_close,
-	.fault =    mon_bin_vma_fault,
+static const struct discontig_kernel_page_ops mon_discontig_ops = {
+	.init = mon_bin_discontig_init,
+	.get = mon_bin_discontig_get,
 };
 
-static int mon_bin_mmap(struct file *filp, struct vm_area_struct *vma)
+static int mon_bin_mmap_prepare(struct vm_area_desc *desc)
 {
-	/* don't do anything here: "fault" will set up page table entries */
-	vma->vm_ops = &mon_bin_vm_ops;
+	const struct file *filp = desc->file;
 
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_desc_test(desc, VMA_WRITE_BIT))
 		return -EPERM;
 
-	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_MAYWRITE);
-	vma->vm_private_data = filp->private_data;
-	mon_bin_vma_open(vma);
+	desc->vm_ops = &mon_bin_vm_ops;
+	vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->private_data = filp->private_data;
+
+	mmap_action_map_discontig_kernel_pages(desc, NULL, &mon_discontig_ops);
 	return 0;
 }
 
@@ -1298,7 +1322,7 @@ static const struct file_operations mon_fops_binary = {
 	.compat_ioctl =	mon_bin_compat_ioctl,
 #endif
 	.release =	mon_bin_release,
-	.mmap =		mon_bin_mmap,
+	.mmap_prepare = mon_bin_mmap_prepare,
 };
 
 static int mon_bin_wait_event(struct file *file, struct mon_reader_bin *rp)

-- 
2.55.0


