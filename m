Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA7B2CC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB87A6B00C1; Tue, 13 Oct 2026 11:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E69156B00C2; Tue, 13 Oct 2026 11:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31AF6B00C3; Tue, 13 Oct 2026 11:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A12AE6B00C1
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:15:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34FCE40945
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:15:37 +0000 (UTC)
X-FDA: 85317952314.04.0F10E87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6567710000B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:15:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V+M+VzVD;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ytmLoC3zHdwZxCxWy26b8X7pqcm/Lj2djuN1AI4Dw0A=;
	b=TcuyYs8jMIT0vzmaBY3F3w9SPo4g0ia/mqbVmqbqDX/PBdCFmLqF408ZcN2JgCTT9sSRac
	+pxyaDgrwYGgyfo7VMrDLvXRncLLrpMH6I/7uo4qjwYuAEFpu3f9TE47d3ljY27BHNoWtU
	PlxjlUk4KIg+wRrwobMLacQFG8rFpcg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904535;
	b=hptcrNPB9QLE+AD8RbObEW0dwZJ8IX/YIQsHdNwRiufmzCXO0/JFhw3mkWA7g9Bs1kZTv0
	LhuDJnOrwGAnMzp6qoUU1YlcAOPR+5g8JmOepufAHdMCjOYQdssk7c+vrDq/AuD0vuCDhb
	C93E+MKUpvZMEwpjsCAzGvbhLInTSF4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V+M+VzVD;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1433602C3;
	Tue, 13 Oct 2026 15:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B181F00899;
	Tue, 13 Oct 2026 15:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904534;
	bh=ytmLoC3zHdwZxCxWy26b8X7pqcm/Lj2djuN1AI4Dw0A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=V+M+VzVDLZ1Jub6DUULYq0X8vyNEJ/40+QVZzwG5sB5opM/2SBJ/MdHOT5WQB/2kp
	 p39uWASPOa9lQm6xOvaavnvS0ruhHZjzxG22YZ0yjxsHdiTq681eJEc4AtKJiIwrnx
	 rZgU2/o5LoCWpxJW4K84NTBzTj2cIERPK+0GsZXSdzMQNLPY3YYfQSNwiotiVRB/OG
	 oSblzECuZI6Vyr80HKcjcSKu2Y2p5wnxQUqxROqaubzZPtjqmmSFMHJlSjtppdX3zo
	 uBRBo0TNdmf24e5ddyGEBz+7lGi4STJa08iscwFt+2BnHbkU8ASGuqMwubUUc4h4q7
	 NoM01Kfp/8hVA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:58 +0100
Subject: [PATCH v6 18/39] scsi: sg: convert mmap hook to mmap_prepare and
 rework
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-18-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5990; i=ljs@kernel.org;
 h=from:subject:message-id; bh=a3PfLNgLx1GbuXFw7DoxzYfKOvfjucxXwlN8dVffozI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZxcp5exhNMlebKqtbT6WeZtsumst9nVIsr4k95bW
 qstW2nbUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIko/GH4H2Z7/H+MaUwra29J
 fHaaxJ2P63R3bbRXSTugH+O/bFogC8M/K7cnf3gr5ykX/Li/ccsPvZWPCswOLzmjUhM2l/NKxBE
 lZgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 6567710000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6rs69yp7sgyns1d1grayjgjpsmn8gqdy
X-HE-Tag: 1791904535-842669
X-HE-Meta: U2FsdGVkX1/2+73n8gDH491lp8KhoJzuwV1eLhPWVSTSgUok4ol4hhxrHAornWBRbN765NiBVIhGlnG6y96hGjywloCOrX2C3jx4mobhPvSNWFFOvbHMIQWuwWx3txHYZdnTfZG3Vl+6CsU3aFmqfAjODr6vZpifDItNn7rMnBrPXeDq8ukZthyj/SH4z7H3G/7WEcZL0ZSTSG78Ntv3MHZTBYkJkCiNLUN2oQdYrXD2tqSkwu8teo1ezBb4xHAzJcLIJQ6pPmXqDDy2fFqgx1uRnoStNrlYK1ntVLV0Tc/iHfH3+gFOQQRXPQ/AqWWyGm1tPPCFoyDSpvliVOSS5eMENnYWOycrKt4Uc3K6bQHYSfX3pz//CV2QWqx9siH+mVFWVzHBMJ1TTl1IwbvdzDJXXQ4WEOlK+3X7h1AIkG1y07fpeZNuRL11g9PQJCPlAuxfYVrA5JX2HCLWgeHSEPE99sgAnVmVJI7+qGarqaf0TkvQAzbGP6yacCFCPSrH+NtD6C1j4GJQhj22R4zVqAiz5TRK88sR0qBXkYvvX3tlK6SF33X2WyCIRT0UJkyrzq9osw5ffDCKicxyZxkzfLBx14rxFUIwR06B9V5PVJMm1nqtf58JN6ndSAfX1XZGl3qkpMYhwcCZgOc3XvVyLT+A76BV0NANE9RHinpDwm8EW8UD73PQetat8YOxB6G6jh8c9fHTy7syUYtAddtVQZqWXnngv/GrdmqFThdZ5vOXilhT+rbMVDulLaCXTBalu2mgKo9Qh/GLky928BLBIqWV5Cqt0Kih2aUB90NZ/8FhiWNqHaPB8C3Uemq2DioorfNT2KdX915+57qTmukR/qavTcRRgnLARRu4lFAEaQeH8sIvmOBWRq/s8WU2fEnSHKE1zGyfXiECy/JphH16YneBzoAy3R03p3fHzyMY6Xyv7AdFN7zWy4HdgggIMNxAPuJ/pr39xwdfEkIaDF7
 e/HE0BEr
 oIoU6wuqpbUZ27fSEZpPS43qUA+4kODmQ2wVdpt4lQyZVuyjJkIC7vQZp1Plb9akoRWtEbU+C8BLsvOroUEZAPRDpYQX/LcBCBg3XCZYQOP6ZbC44C47TmrxwpuEEwm1tf62zXSqBKSVRMEiK+v7aQo+xFrHf/1hbdZUsRyczjY7g+VAl/nun49lMEfleSEzqcGTWCt9pY0mie6cJ10dGCYWoOtbENtSv0A89ug4En25GmpYkFVff1Z++kT6qbkR5CxPjkCJ3yJVLleaC9hYNB7LXI34hB+k/XBQ1xkZ0xZAR99DuLRITOpI1Trs3EA//IH4z632J1iYUJbvE2GD8YZTVbZ/8GOqB2wUqhZEiYNPBqVJFcUyXy2BjytngSjHRdfhYVj0hBPpMyvPLRqhWm0OXGuDqwaOCkH72Zz2rYA8yanfk2PrFiar3iIG8NyUEmKA6YeGKdShzdjI0Ex1HQbs9THepq4q4w3oKqVMcftR41WFvAoCNvM9/+ROcp/4RRiDya9r15v3bw9Pa4iKoVWbmNXPz6NfI5Uyu0DEReCx6r/geGLQDhEWnPfjCTvJQ5Qrh2UOpsqb4KerNkhtTE6gyczOlCDcAFBWEp47pbcUqRViCVg2jCJZzEYum1VvRc7HTgdMwxvdM2/j0tlXP2DPKhm2SJPGDLE5kz4VPW68qxuB92X4oqN8kqbDdteYP96ur3hTwo1TsI0qpNbzr29ifFm0Ks/+un6INgFHVDOO6JFQbUwD0s20qpKour70nmQdddru/0aQ/DRKnbogu/fOmxoeA27leFKJkFtXC57AthY1/F2V4R8TSWIoKEJ3Ur1XjNohwE/Nrijqev/YvePNQKAe7/5+LE63ytfcM0zIXDBE5gZsGg/bxnuEKwKLlIOnuoIDJslbrlG/ITpiYcdoqKj9uTZ8OhVi4Vl5ZCo9DRl6FFCHlmwaw042KnQ5aLc+SXU2LsSIrnPRHiULkpFnSGAD4
 d9HSMKLG
 jrDrH1Aq7mr4nNCddqSKRIaXU4ibL4ZQ3bUrhCsZGoi3WL9TzwH/rNkyexVvzvkXyvcYojyClftI+zull1N7QbALpxuGafzOQrsZhEY3m86RGspCLwh+egBFdp2i3YW0HUX9+CLxqtJYXRLLEZpFe5Tnw1fGVCDeN6FFFdUU6ypczZfETHfLbxCDHBynutqu/VO22QaSEGbNkmADLFj0EdtqfqMcHn8O60CP/T3CbDaf76ufQP+KqcJM05eeQBB17ygXhDPaDCaxOVInO6UjS3Ns4RqjF6VPvEHnsU/DaLfIbOPrYRQswvRHYSavdp4fMzLXOoXiS+W57++/vCMuRhhDRq9zHF9OW92f35IbIksoQNHEy9VxN6W6Ftm5RensgL+8wUGxGt0IoQaUsu6FT9/jX5AHYJa5N7YkhojX+fqRYbKCNR770tcT9fUTgXYr82SwL+ZlQUh26HyBbOydbnwPnQNEfjVx/dOuU/f68Hed2udkOWlRGeQVOuzRdmyLs5jrN+3dMvovOTCl5jklD3DBWenPGRBhejugAbXBZf6WiyKZjw4cQUKcNQEQNPWeAToHKucP5pMPqcCNdnJRqH4rmT6zC5b7J/JQMQCO8Ub9/zPkkeXLi2jNbEkx+N+JNn8LF2oqHzY0wNMdKWk6ujAIt4D4ustQlX5NRljZ7LWdRyiNVhEF8XNjPPie+1eJTHqRwtXBbPOJuE00htkVfpHhjZjefnq3tys+zT6iExqnEI8FYbejU3bnfny491WNlj82K3+fG8ZY6mq8suTbKi3FQ9QLEOkc/oOVtwucZmUs1pnAGEtAL1MqQOW23iHPDM7k9uy6vobA1HaifHbM0qaj4wFCxWG90tdVKzGVcPjwqkKiHlHxSPmiv2dhgtM/9w3sxXJCa8snqZ25DRtrVi0BFHDBEcay+EXtSaLK1QpjPLCEZcNshjFiGnkM5jvepw7PCPgrqNabNRjwi5NY1DyGVlJ4/
 3b22x/vg
 KDtPIL2JFi291rM2O6iEzJMgiDQmUdNwEF7q42vRQkjSGJVnARyj+/GgiOc+d5SOgq9NAcQivaNkPDae1bIw62/s3CjcLcpwK2uk81RbrmOfWKSqytc1Yo9ZZaGia6bIQv+qFIE1DVIhe3l9R1fpMSCmxTHfb0zsYKfN1R58ZfT/Aafv9O2Oxs1gZdPzMyUF6nGssJx0J04SKFYul2W4jtTmbL9yl+Z0LVC1QzVLZlslXC6avysV3egsMWxc3F2cIiUjo0jw9kCMOEEwSpKG+RGyR8GoBWQRwY1yt9gNACy2F1jCPODV47ihHxZNsvTRI9aB0nG6mrzYBcDHqoRva68tkFS6SF9O0Mgg7k/Cfw/24hHtQmQ1FUmjnFB+sds42NS2JKFSHCEygsQrP0+rHr2b9+L3CK3Z0+YsS9+lCBM03SbgPJQmbwjrrBECNaY2mYVierXnQ5+cGdmJiXNXl2aIovzcCcDoAr7Onc+u6i10b+eH3dv2VinJqkI0WsZDozBt3cvwpwr/IKxkQDtj7sm7ZcBQldHZbBmdBLpXh3Wie59ZocBk/TBQ+yU71gowtI1PRemnuTUMfNIb8Xw1nexg7eB5GrL46p4yL/mXHFRNBcppkudms7V0ZiBbFz5yL/nH0PO/J3CTq1LEXZmnpyJLw4NwsP4hV7f66wq6vAHzReUxIJuw9muu1Yo1OkibRkwX1G1FiyZ3PMvjH4a5hCYMmm0pUqtVjBNhCzRBx0F4w57Tlk5A09kAEPzh2asUqFJ5+/kuY17gRJqHJD9KqbT1XYz1shtkTkn54orK4OHF3N/5bB+tF5iRXfz3/N1zMJXCzVPqSI0piGSqO4S/VjKi7fFRxx39yKOdYxlYqKarKw4wNdUACHg+Q6+GwgSeb+MOB/ipop16hF0mjzZUzINJbpKZQR4W4lLkGwhQfwTiLQGWc1yaqFrJSG/gBmubebwRNE0n1JfOBCmojSgvfhrFu78jd
 z6oamwbT
 GkVKdu1pDgA4xrGlDWHrcLBuCLv8iJ2hP7U7aJcJRUM/62puhU3EH3GBM+okLGXvYRhaJCL49AKTwdTZZmbMmdp0nPnrOaddWqOlQPEU2I9xcdKyrasO6QalImEONsGFio7mQ8/Zr0LD2WEIWUMfCjfpAkfUkJcmWvt7ozHnkkqxYgjjhD4gTFsxMhNj0rgtkTTraCQXVrQj9vn2h+PDFqmQpj8cSCjfSp5JAsigC/qkN4JYAf3TILz1EEyRWnQwgBfuGUONs+3bqTHLld0INitHAfxFmfak1mhEBkvI+6MbhBsV61TPAJ1QWiSF/ui6m/S1tz9yvT33vDNb/NuYb2lnmZr5T0rC/7Boz2ZWeEw42b6r8bB74Ott42TMPF0/m7h38T5jlAO1a1FIISiYXKJsQ5wFc3v24gh+KC5GFVsapdVxWUr5HJhYoNwYg/4RxiEjgKVObFLtY8L1se6RVsWl8Weftu15I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move from the deprecated mmap hook to the new mmap_prepare hook.

We are mapping kernel pages here, so use the discontiguous kernel mapping
mmap action to do so.

Unwind the rather confusing loop and instead map as many pages as we can at
one time.

Note that we do not need to pay attention to rsv_schp->k_use_sg here, as
the pages are populated for the length of the buffer at
rsv_schp->page_order granularity as compound pages.

The discontiguous kernel page mapping logic handles the compound pages for
us.

sfp->mmap_called keeps the buffer stable for us. As before it is never
cleared, so a failed mmap also leaves it set.

We also remove some useless vma, vma->vm_file NULL checks - these will
always be non-NULL if you reached the mmap hook logic.

We retain log output for consistency, but change what's output on page
mapping to indicate that sg_discontig_get() does the work now.

Note that we drop the VMA_IO_BIT flag for the VMA here. It was never
necessary as we invoke alloc_pages() which gives us refcounted folios that
are fine for GUP to access (VMA_IO_BIT would prevent that).

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/scsi/sg.c | 115 ++++++++++++++++++++++++------------------------------
 1 file changed, 51 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5408f002e6c0..3f9e08725602 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1212,85 +1212,72 @@ sg_fasync(int fd, struct file *filp, int mode)
 	return fasync_helper(fd, filp, mode, &sfp->async_qp);
 }
 
-static vm_fault_t
-sg_vma_fault(struct vm_fault *vmf)
+static int sg_discontig_init(void *vm_private_data, void **private)
 {
-	struct vm_area_struct *vma = vmf->vma;
-	Sg_fd *sfp;
-	unsigned long offset, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k, length;
-
-	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
-		return VM_FAULT_SIGBUS;
-	rsv_schp = &sfp->reserve;
-	offset = vmf->pgoff << PAGE_SHIFT;
-	if (offset >= rsv_schp->bufflen)
-		return VM_FAULT_SIGBUS;
-	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
-				      "sg_vma_fault: offset=%lu, scatg=%d\n",
-				      offset, rsv_schp->k_use_sg));
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
-		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
-		if (offset < len) {
-			struct page *page = rsv_schp->pages[k] + (offset >> PAGE_SHIFT);
-			get_page(page);	/* increment page count */
-			vmf->page = page;
-			return 0; /* success */
-		}
-		sa += len;
-		offset -= len;
+	const unsigned long req_sz = (unsigned long)*private;
+	Sg_fd *sfp = vm_private_data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	int err = 0;
+
+	mutex_lock(&sfp->f_mutex);
+	if (req_sz > rsv_schp->bufflen) {
+		err = -ENOMEM;	/* cannot map more than reserved buffer */
+		goto out;
+	}
+	sfp->mmap_called = 1; /* Prevents changes to buffer size. */
+out:
+	mutex_unlock(&sfp->f_mutex);
+	return err;
+}
+
+static int
+sg_discontig_get(struct discontig_kernel_page_state *state)
+{
+	Sg_fd *sfp = state->vm_private_data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	const unsigned int order = rsv_schp->page_order;
+	const pgoff_t nr_pages = state->nr_pages_mapped;
+
+	if (nr_pages >= (rsv_schp->bufflen >> PAGE_SHIFT)) {
+		discontig_kernel_map_abort(state);
+		return 0;
 	}
 
-	return VM_FAULT_SIGBUS;
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
+				      "%s: offset=%lu, scatg=%d\n", __func__,
+				      nr_pages << PAGE_SHIFT, rsv_schp->k_use_sg));
+
+	discontig_kernel_map_page(state, rsv_schp->pages[nr_pages >> order]);
+	return 0;
 }
 
-static const struct vm_operations_struct sg_mmap_vm_ops = {
-	.fault = sg_vma_fault,
+static const struct discontig_kernel_page_ops sg_discontig_ops = {
+	.init = sg_discontig_init,
+	.get = sg_discontig_get,
 };
 
 static int
-sg_mmap(struct file *filp, struct vm_area_struct *vma)
+sg_mmap_prepare(struct vm_area_desc *desc)
 {
-	Sg_fd *sfp;
-	unsigned long req_sz, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k, length;
-	int ret = 0;
+	Sg_fd *sfp = desc->file->private_data;
+	const unsigned long req_sz = vma_desc_size(desc);
 
-	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
+	if (!sfp)
 		return -ENXIO;
-	req_sz = vma->vm_end - vma->vm_start;
+
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
 				      "sg_mmap starting, vm_start=%p, len=%d\n",
-				      (void *) vma->vm_start, (int) req_sz));
-	if (vma->vm_pgoff)
+				      (void *) desc->start, (int) req_sz));
+
+	if (desc->pgoff)
 		return -EINVAL;	/* want no offset */
-	rsv_schp = &sfp->reserve;
-	mutex_lock(&sfp->f_mutex);
-	if (req_sz > rsv_schp->bufflen) {
-		ret = -ENOMEM;	/* cannot map more than reserved buffer */
-		goto out;
-	}
 
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
-		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
-		sa += len;
-	}
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->private_data = sfp;
 
-	sfp->mmap_called = 1;
-	vm_flags_set(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_private_data = sfp;
-	vma->vm_ops = &sg_mmap_vm_ops;
-out:
-	mutex_unlock(&sfp->f_mutex);
-	return ret;
+	mmap_action_map_discontig_kernel_pages(desc, (void *)req_sz,
+					       &sg_discontig_ops);
+	return 0;
 }
 
 static void
@@ -1415,7 +1402,7 @@ static const struct file_operations sg_fops = {
 	.unlocked_ioctl = sg_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.open = sg_open,
-	.mmap = sg_mmap,
+	.mmap_prepare = sg_mmap_prepare,
 	.release = sg_release,
 	.fasync = sg_fasync,
 };

-- 
2.55.0


