Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D729CC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51746B00CB; Tue, 13 Oct 2026 11:18:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02986B00CC; Tue, 13 Oct 2026 11:18:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA426B00CD; Tue, 13 Oct 2026 11:18:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 629B26B00CB
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:18:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01D3D140CA9
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:18:37 +0000 (UTC)
X-FDA: 85317959916.04.14CFF6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1904C100003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:18:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FdT2gUkY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mV+bZBkayRN5eP4bfWthEjcGHHBfXPBDQgkgo001cBw=;
	b=BaIV8Iuqt9+ejCVRjscR8qvQesnh+Te/RClDgZZePPXQp2Wq/kfkOmPQDL3xr9z71zL/J0
	kStV+9fU66LPLh92Dm3op2MaMz5OcGYmnNtFQaHIwYIJwzTJHazcP6hoU/pKrECqa1+x++
	R2avgwPdBOQ7cNt6x1aR5Xo9wmzZq9M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FdT2gUkY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904716;
	b=014sOMA/yL9K3RniELYkuT5sksFVvCBcYC7raNOYsH3hc3v04HB+p3AJyKtPLDNWtmT79i
	ui38BKicx74GqCoFNuScOhzcBOhSElIGvb5TCnpJjnN54tT8nQVcRWfMgXg0xe7GZ3jX9Z
	X+au05rGXG1M8iuveefJKDHuan9fza4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 607D943CFC;
	Tue, 13 Oct 2026 15:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0931F000FF;
	Tue, 13 Oct 2026 15:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904715;
	bh=mV+bZBkayRN5eP4bfWthEjcGHHBfXPBDQgkgo001cBw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FdT2gUkYitiwqYESIsMzJ1KqSprPcg/NK7iNvZ0fuRv6VojDC08HNQymSyiW0CNS7
	 002TZSezcWbmeuSnrKeS6I9tiW6xAsH8S6oLqzBs6Ai8tiDe9ncigf6rlbplQgokXp
	 /s43loq0hUwgH0f9sB68E/C0HRm/NGuyK0qpKuCtgXwcV1VW5C3Gbd9McIPX4Dn/30
	 cvixNFSdANC34yY1hTFwE/9jh/5ObG2/yxfk1VI4i4r5AI6ChNyJNAa3CsqYvWGpJy
	 H9cEZOn3vFvFa3+yDSqdxDW0vTx1hvczxhPBQ/i9n4nBSuf0uZPVfAJg2X4iqxgLtI
	 1ePfwtt0f6o1Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:04 +0100
Subject: [PATCH v6 24/39] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-24-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8395; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Qa7/d9iVmEdKPUMRKDQqPwxH1YhZ/W/SAQvnlJMlU2c=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZzOtfuZKuq5MPhjU+EugfjMum1cJRcPzFXjOvhwg
 fC+e5/CO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRR1UM/xR+rLyeVJr5+vmx
 f42KD0P2/P/Bq9mZzdJdHKYSx/vAfjPD/1znDvlq1cSEP5Ncn9+f2vH00NZ+rxanKKXej8G3vm3
 k4wAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 1904C100003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: d6qn1jgumjfqii1zc5r4ukydxkzsqzkx
X-HE-Tag: 1791904715-753862
X-HE-Meta: U2FsdGVkX1+7f8Z426Xb5ZtqEl+J0j9lFXcrveCkXxGZ/TP3cG1w77vBrg4DFyB7a7nMEwyIJGvMJO/t+mLkoJ77Hzav+dsCLqKxH+Cg3sz7u24HBN8OxPPxDlr/L8DjC5aaYqteXJcGmlWjiDSfIr9x4FxpDqxctA42yhDkjc1ba8WIOYPaJ+yq7gcX1Dey7x2TPfd8QzdTeKfEMoutKlKA2tCVJS1+rN8umMRfJahiNwMcdzhsYGgnNHnAx+h6XBvdkRJhUln9/em9B8r56sUVyquQe4afD7wVf5tcr28IssxTM4TBY0ozovwQXHP+vCOD75jLT+6lfnDLJTJnYh83OUoLtgu5jYQQB8DaS7mlkPRCNf7SyvTQSFAod6cu4Eo42er/taZ13p0+MYAkeO8d8jkYicSe0JbJ9es/NZurXaHfwiAg8PIa6y6RYvSosKiV1tY+PW2hy+mvwAkg8yVvcWTRgxzETcsPffsalNmmsIz46hmKiaXu6VjL00Q/vWdIcGUWpHiDbWdTaqBuqebeymzMR8tHjjagsxN5J1XvSGRWoZdmG6Q/tVNfhA4HR24erNYNFvHwoRuUm5NOrpw09ZMKOdYna0diw4IFqcbsK8NRxtp7OBYaliMg2wk6wGY64uAikhqArGakG5sdqYGpDT0CnYLtZmhoQt06vpe+gC1wDqwdK3bJeUeDac9NYo+ebwIxLhxjdt1/stjOb15u6o03d7+Xb0iCAyv60CWZQ29fCqUQWwqqjEXmUkDuODqb0ZKISe5oIbeV7iMDbsU/nGeAnHZJHBed5h4dOQeTPSz0CxRxVPttlYQtnZn1X6VNlcL4/BenxXJLybMGf1mEUGOpv9uk0Ue17Bryoso04imJzJmJpXmRZ/pl6GCd0MkVIiA7yspfcSe8GRZYbjd6OciFl1+iMHTMnFIdYrVi4P+Kc2Yahsp+3WgeNEIKFQ/U019Nczdbzf6KFYA
 sV2UKCyZ
 w50Hcrvq31HPgiCp29qQzjlCoL5yeyBrQR5bEXgLJkSMNsk1JACDB7D+cK7F4pzK+m6J1AkDHUs+WoJhcazxc6kE0cBnhm9a+CnwVGeukehhawoN6rd8q0+tkV58DFXZtFj2ISjoaUV2k8mI5301cLotKNyyThpxatkTT9/7uyXg7ckGHQsJumjh1a5nbbC6jBCM3Nyl30+9DUzZ7tzfpA27b9/8ZUAta83+K2unrPJJfhE4HH4vRXgBSC+AKnL2jL2m0AusUimRJw8s3oEQrGhhQhcMMOmnnWwolyph+JjxYREAbujrtNqe25m+Owey6NYhHQqZLS6WmdBBFOK02h/e1mP524R9UplyNNi84dK5x5hO+h4a4xs5kGxxRAmIzvCTUbVOg2eLHHnTi5xNbZjUmJZDbcTwF14AmXaqPactYYJgVTxrvmlDqKl3bKqZ9vLlwP1svFmgssMn3YuAcpAkNMSXD8P7gmAttjSkIVYhz/ZVU5EwitV2WWbznDtuDbRGpygBOdtXU9fMIdXFlC7iShASlQV3Anx7igKmmTJsdYNcYOjgrDXoiB8AhtVjs4iVuXJMzYTnGbk5YVn+7UJdsI2nI5bbUifM+R3x2iF9jGDcgt/P0ab3BxRzdH4faP5lRoD6YW1DJX7nwgIl697ma9JgM4nPOWbta/9QzRfoSntzMxdGniJtAjUExrtfgHfZk3jdgyHYjfF6AIGNcFQuSIXp4nYlzyrruw8TKhW5z49ZOAxuOhsA49GvEsXIyvWimHNxaZMpfrdprguftAJPfmvRI1iV+mG3UBijTQPYqMAQvDpXBqnDFv/eAfB6VbPo0aTARbrN7AM61jdKgNdjpAWmsnoQEW4Fdyb25O6H8gqjuzSjRlijevLDAE67KJ58lsBq4IRawC1ntCKpZ6w7tQzunsbOomLJj1S8hroWa/sLYQR8Gv0/nJU2yNG+i/5cg3mY8XPPtNjqLdBQWZGwoalCP
 w2WTg2wa
 QJJLZ5a8AMTlAiCXwFASpWrcnOatVw0Prrjtm6v4+vc7r5pVoEHd2oXxM9//qkfC1j/y0j0BJoMPissxqOEhcn61hX0hy/epuhKtCxT7EIfrcVKQC18Jc+c5GmychkEEPy6MMbWOal7YGaPmsi86ootrD+uBxwMpS7NZMdu/vTx3DwSC8RIa6S3i2YigjGhSJwBaFkiZHljhxgc/WOe3saPmBDKgrHt84TwuUixgRLZniB7j1vHt/e8MPmSQse6/gNOGZcIGPhuyD4h2hkbJfVEnBOhCgGA/GDNCNsqwIHO8V2GhiCaBzxXoviPHRqUL6zWAbjLle+zreC338C6geYhYiEB1cEXPKm3+B6XOu72n8pg6ZBgKlVVQvPiXxQy2Ni8SXEdVQNKHAorLNay8kZmK+CzT1v8N9FYtPa2sEW3Ox/DDL/t9bDXWmcEyEquqgmQU2ivFdoZikhlD078OUj7kFQZURwHI4ch8kQnRDF94ZDISW4DqQvo3deCexSDrIzxJ4WLS49sM1X+wxfOnaMwMRx0B92wLpUDblG0wAay7/ufE4tOEKTMVTP6JZOL89mTQpol9+1Nv+r2v5iFBHjwTVUpejvZwGfhi/CSS4bFXt8tDtTfJ5KScPul9fo9cD916xbLTy8SU0n9RpXr1Mt48P3WUqL6DcpbBGvIs3U8+ewUF9vWXXdnb+eDGcYlbdzhI4uwpv7FS4svo7PaWA1+sPwAR6SX6+27rK4A7oq+KAETl3Pu1eTVF1D8OFTDBU4k9JBNkf4inScS78F3N2bb1GUA29SHcm8m0loQxzExdMKkFg9toyiQOZ5FwTMN3+bHedjt4Kbaf2xZ/+OnERyIESEeDgZQKsbzytFxf9+IKSY636rXEdBLX1ymrPaRJSFfqQAKMH+41PsR6V5pHrEtkEw0LU7VSrjUS60KFtEQDlsvBTCwcJ9AugzSltEtEaHHOxPWTic6oc0spmI6YQzLB5px4k
 3jYbDENX
 9J0xmgN5VlZSBbssf0R+nCH/eEbZfhJB3JEzHNT+J/5AJ43JaQH+Rhf7rCAmf3+1kRBNTJ2Jv3+p/gVw4SkonNgJdtY/u69/v1pdzpC/+FjXz7XKd6sCuigSzx7HjhGQqR+AvBaP7mcjXYAJJr0OTG6VQa1S7h4zV+xFsGpSkfshppjPRUjKjsvdK1lHNiaWkMP0Iq+6L8qlVH6lWQHAKQtMSlhqr5v1IWJXLLu0obDh7dOb2h94IAN+Kpdy59wmsX36ySv9G/eeSuVlJiA6AMIBr46YEPhtylg1Sgc7agns3nKG2ls570F6u6weSxY7d90+LRoWr5K1VsTppqMJcK2hFQk2OtRhwxLYACuKyzoYtH9C+bCB2MAgw07RL0KnigjFaTbQB24fpT1GgKaDUTdw+luSDqMADKryO39pb/bQzpKT2Mi6T+nY6ieT87f5m/wblKRPRYto2l16s4GwlCeQBn0u4sh7DcGDz85G0bCL+rVXqc73ZAHOhbrlHJ0OoXycTVJHJ028WYy4o37nHahYXUaP76K6iubZeHs/W1eXw7XRrAjawTFy1QTz/dwcJ5Izu7JpgcG0Q09xpSCZj5HYFTX0Veuu76hCj6HqIbk6MxJux2wiunGiGb3RLqQU+EIJBYU3ppegCaLo4Sfe7NsXNPb429igIqVNJp8txuFaz4Bha/xU1cXVIaIvaTtB655Vap3MNFF9IP/1LHEq/dAtRiU1Q8LTZLjC9z/n3OGJX7A5DcAazHjThMAUB+IC0BwiYywkGwkCIWCby+HEaLRyXMcXG7Y3hpZ28dEpJgXwAHMge/ogBdoUk1SqoHnhRu12hpShKIimUo4JYm6vChaGLxk2fQarZ5wp3Ut7cDik5YZSlVqPoy4ZLup4/LvlfRUWJ/SCghPt8wYQ2jm0j7fibJe1wpN8vo5rH372hKmLf+UxEwrlByeLkQwFevtW1FSb4xevNwRw2ulBKbwBD0nOzo1hn
 zrUh+jIS
 4zVM4kdiqFa/x1wER4UW7dlALkGCZqW5PWtIUDW27+2JYEMmiP9n3iA7ZuzY20D2oIhc4rE4yJ9jhvum73qrpFuNcAPEkNUnUH1nJHI5cMMEJY+rkA268h/FTOOFPd6PCNQigMygaRUhdvXEe7KAm2/YAiRB8CJIpQSWkASSz8RsAj/lBZMsKI5XUVwcKG0msZNZJKLgdWz4oo+NDQVD9K1X/+KYgBDClyG15JTzaG32JcUWGwKaZ/NUAOy8wbilHx1a+K1i0LfR2+kkN3tJMgYzPeTCMq0232hDFU8+9T6ZjpKtCFMI12EwL/y3WdLlLI/KYb7GCP5Hed0dyYWdHZ9QJaE9V6LpoCjerIKTCDoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When performing mlock() or munlock() otherwise normal VMAs have VMA_IO_BIT
solely to fix a race with migration which might otherwise double-count
mlock VMAs.

This is unnecessary - at the point of applying folio mlock state, whether
setting or clearing PG_mlocked, we know whether or not we are locking.

Solve this in two ways - thread a boolean through the page table walk
indicating whether a lock or unlock is being performed, and run a locking
walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.

This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always implies
VMA_LOCKED_BIT. These are also always cleared together.

Then, update folio_add_lru_vma() and mlock_folio() to check only for
VMA_LOCKED_BIT, and update try_to_unmap_one() to check for VMA_LOCKED_MASK
instead.

Also remove the useless invocation of allow_mlock_munlock() which simply
returns true if unlocking and instead rename it to allow_mlock() and only
call it when locking.

With the other mlock abuse of VMA_IO_BIT addressed, update
mlock_vma_folio() and folio_add_lru_vma() to simply test for
VMA_LOCKED_BIT.

The munlock_vma_folio() function tests VMA_LOCKED_MASK instead, as an
unmap racing with the locking walk must still munlock folios the walk has
already counted.

Additionally, in order to ensure a racing unmap/migration releases the
reference munlock_folio() took (whose put was batched), check
VMA_LOCKED_MASK before calling mlock_drain_local() in try_to_unmap_one()
and try_to_migrate_one().

While here, also replace some deprecated VMA flag predicates.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/folio.c    |  2 +-
 mm/internal.h | 10 +++++++---
 mm/mlock.c    | 51 +++++++++++++++++++--------------------------------
 mm/rmap.c     |  8 +++++---
 4 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 47a437e0f7fd..35e242b48870 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -505,7 +505,7 @@ void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma)
 {
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_new_folio(folio);
 	else
 		folio_add_lru(folio);
diff --git a/mm/internal.h b/mm/internal.h
index 4ae08fedffff..ea8fa94ebe1b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -970,8 +970,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/* The VM_IO check prevents migration from double-counting during mlock. */
-	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_folio(folio);
 }
 
@@ -988,7 +987,12 @@ static inline void munlock_vma_folio(struct folio *folio,
 	 * always munlock the folio and page reclaim will correct it
 	 * if it's wrong.
 	 */
-	if (unlikely(vma->vm_flags & VM_LOCKED))
+	/*
+	 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+	 * mlock_vma_pages_range(). An unmap racing with the walk must still
+	 * munlock folios the walk has already counted.
+	 */
+	if (unlikely(vma_test_any_mask(vma, VMA_LOCKED_MASK)))
 		munlock_folio(folio);
 }
 
diff --git a/mm/mlock.c b/mm/mlock.c
index 39215a3eab1f..4235a1518fc9 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -316,22 +316,10 @@ static inline unsigned int folio_mlock_step(struct folio *folio,
 	return folio_pte_batch(folio, pte, ptent, count);
 }
 
-static inline bool allow_mlock_munlock(struct folio *folio,
+static inline bool allow_mlock(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, unsigned int step)
 {
-	/*
-	 * For unlock, allow munlock large folio which is partially
-	 * mapped to VMA. As it's possible that large folio is
-	 * mlocked and VMA is split later.
-	 *
-	 * During memory pressure, such kind of large folio can
-	 * be split. And the pages are not in VM_LOCKed VMA
-	 * can be reclaimed.
-	 */
-	if (!vma_test(vma, VMA_LOCKED_BIT))
-		return true;
-
 	/* folio_within_range() cannot take KSM, but any small folio is OK */
 	if (!folio_test_large(folio))
 		return true;
@@ -352,6 +340,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 
 {
 	struct vm_area_struct *vma = walk->vma;
+	const bool lock = walk->private;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte;
 	pte_t ptent;
@@ -368,7 +357,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 		folio = pmd_folio(*pmd);
 		if (folio_is_zone_device(folio))
 			goto out;
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -390,10 +379,10 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 			continue;
 
 		step = folio_mlock_step(folio, pte, addr, end);
-		if (!allow_mlock_munlock(folio, vma, start, end, step))
+		if (lock && !allow_mlock(folio, vma, start, end, step))
 			goto next_entry;
 
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -428,31 +417,29 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 		.pmd_entry = mlock_pte_range,
 		.walk_lock = PGWALK_WRLOCK_VERIFY,
 	};
+	const bool lock = vma_flags_test(new_vma_flags, VMA_LOCKED_BIT);
+	vma_flags_t walk_flags = *new_vma_flags;
 
 	/*
-	 * There is a slight chance that concurrent page migration,
-	 * or page reclaim finding a page of this now-VMA_LOCKED_BIT vma,
-	 * will call mlock_vma_folio() and raise page's mlock_count:
-	 * double counting, leaving the page unevictable indefinitely.
-	 * Communicate this danger to mlock_vma_folio() with VMA_IO_BIT,
-	 * which is a VMA_SPECIAL_FLAGS flag not allowed on VMA_LOCKED_BIT vmas.
-	 * mmap_lock is held in write mode here, so this weird
-	 * combination should not be visible to other mmap_lock users;
-	 * but WRITE_ONCE so rmap walkers must see VMA_IO_BIT if VMA_LOCKED_BIT.
+	 * LOCKONFAULT without LOCKED never otherwise occurs: it marks a walk in
+	 * progress so that rmap-side callers, which test VMA_LOCKED_BIT, do not
+	 * count folios, while try_to_unmap_one(), which tests VMA_LOCKED_MASK,
+	 * still refuses to unmap them.
 	 */
-	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
-		vma_flags_set(new_vma_flags, VMA_IO_BIT);
+	if (lock) {
+		vma_flags_clear(&walk_flags, VMA_LOCKED_BIT);
+		vma_flags_set(&walk_flags, VMA_LOCKONFAULT_BIT);
+	}
+
 	vma_start_write(vma);
-	vma_flags_reset_once(vma, new_vma_flags);
+	vma_flags_reset_once(vma, &walk_flags);
 
 	lru_add_drain();
-	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
+	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);
 	lru_add_drain();
 
-	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
-		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
+	if (lock)
 		vma_flags_reset_once(vma, new_vma_flags);
-	}
 }
 
 /*
diff --git a/mm/rmap.c b/mm/rmap.c
index 5332c52909be..b4a4b3929044 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2239,9 +2239,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
+		 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+		 * mlock_vma_pages_range().
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
-		    (vma->vm_flags & VM_LOCKED)) {
+		    vma_test_any_mask(vma, VMA_LOCKED_MASK)) {
 			ptes++;
 
 			/*
@@ -2395,7 +2397,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 finish_unmap:
 		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
-		if (vma->vm_flags & VM_LOCKED)
+		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
 			mlock_drain_local();
 		folio_put_refs(folio, nr_pages);
 
@@ -2770,7 +2772,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			hugetlb_remove_rmap(folio);
 		else
 			folio_remove_rmap_pte(folio, subpage, vma);
-		if (vma->vm_flags & VM_LOCKED)
+		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
 			mlock_drain_local();
 		folio_put(folio);
 	}

-- 
2.55.0


