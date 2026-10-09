Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F69CCA601F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 719F56B008A; Fri,  9 Oct 2026 14:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CB196B00AF; Fri,  9 Oct 2026 14:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5943C6B00B0; Fri,  9 Oct 2026 14:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3368D6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:09:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B62BC804C6
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:09:32 +0000 (UTC)
X-FDA: 85303875384.22.E066ED3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id F0FA12000D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:09:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+QY84XG;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r0KWYJe9hjbal2792CpfZTBrFVJtw3v9I2TFW+N4/oI=;
	b=uoCNU+G6ls4//EaYK0ymEhrFS8fpx8cqX6cE3GHPaFGV9Xa6TQvwQ6he6GNQXnOx7539WA
	Thlg8RJ9xSsaxWML1tthaps2oh4bk6Ff+lCamLIn7jHfjrrFoZKH+766QNoIKFub4S5Ouo
	MOdb2gV6ICFCnV/Dn3jPM8uIKO2l1y8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+QY84XG;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569371;
	b=YMd3PfQC1ZXXwRASCrIROP487Ex2bPc4aAYTAOeJ9XA2RSSWvhpy2RxZACMHHHJWSEjlgf
	0YXL64oG46ICEZVPb4ZL+gVkL8l91PWClmPRdXb8Bk+WQWZNYqR1bhjnv22/j6STCuIiH7
	95xMXLccY1obzWEjr1U/J1AyZXfPFfw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A1BB60DCB;
	Fri,  9 Oct 2026 18:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5441F0089D;
	Fri,  9 Oct 2026 18:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569370;
	bh=r0KWYJe9hjbal2792CpfZTBrFVJtw3v9I2TFW+N4/oI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=G+QY84XG85ltVN0DUuViKg+meSShrA/Es2JDzNRnfupWeVD3M9ZuhwZ5082pmSh22
	 6h4ILBxrLd5HPsW0UrNocluM9CnFJ8qx8iq6VskzxxFDnS97LJNATolSxT5eGCtvaS
	 1hxlNHbE2Zgf3AVKypKv+XlqxgnCZoPVsYMss0cTze0S7FblZgmpdfBLVJn0xrbA2t
	 IVduN9Q5MB5FE2M0ej59r0qeKWot444hO9EHjWpwwKUGDzFP7y8h2fOBZzqDZDgwAY
	 ZU8z3nroc51nQHbyB9TGg4A/96xUQdtEwmRraOsZmFHw9zCcj04R3B7AR0DwSIGUN0
	 adZSmERfebMbw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:08 +0100
Subject: [PATCH v5 14/38] mm/vma: add vma[_flags]_is_mm_managed()
 predicates
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-14-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5416; i=ljs@kernel.org;
 h=from:subject:message-id; bh=XtCRiQX8ziNhM0P8NcMOzuXM9n/3Y7Dt947rZjqi1cA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6syeG7JTVfd+q3PQhUiZvQX2av9e6UVJPvX7+jbi5
 RSd1VttO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRVF6Gv5KhaYpbpHeu9Av/
 r1Hw9UHuDh0Jlf+KipPfZwmxq61wDGb4X+DX+fqRyhlp8/OfXLtUD+wJ+sRz9JB9w8ajxknGb9b
 uYQAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F0FA12000D
X-Rspam-User: 
X-Stat-Signature: 4pp6jx3mfo4xsndda5pm6ikxh7bibqhy
X-HE-Tag: 1791569370-304885
X-HE-Meta: U2FsdGVkX1+GqQsFIyWRWzTND3qi3nYz33/07J8vyloZ+PDIT/eDAP2IQFnR3560EAtc1atiI0U2t+eCC220y//csY+Sba6b2MDQpNhoCAHa8ie2pya3eRYx29GUQKwA6HM3pqGWA7M63kMBYaLsnTy5v8RhpwusjxcBhyjEUMvv9DQKXELq5b2H5FxSf485iMftkOHY0kkQmkhyd2wtSgfL//dHtVP9M4m3CfxRNfCF1t5/muI/7WQJUXWraXZ+vyfxEcy7tmnYhupYnu7TJbyqPUt/to5xuYPzuTtbsIXwJM3OHwybeXTLbL9u7/cymSC2zSLZQ0aKV5KOPLggJDR+KqklNYUeZcQ6CcMNuFadKVvxkRJNgz5Rvpfw5x5bX+fbpH8BqZdpGUWOfCmEPffABdp48j0VRp7bnY2TldTRUr8c/4CkPlAaskeoaLZPO5rZ8P1yC6ckEufm0opvoofVeEIUgyVJs2BtJeMQTud5nB1ltCDPA+yZ2dUhI5dm0Y3RCZZbg4Pg3gzPuVIAWHarN8UjRCuilO4dz4514mmiTARkZUCTozj3A0DhNTBAZ3NJaXkAEEcW8Tcxn/wIZQvcFVcZVaAbZUt/VlIUDTvT6ZZkjnsCYdCXmbH73oAU6kFJNgln1yVJdk983iUyKbDhWFuog56766QK0Y6qybIsuyzHXcl+vKuw43AOO0uqfv9uO5OW7tFKkLAB8+krSctP0n1WdvHfRZYFgAhNBw2MFB0yggJEngYlRn7PnC31tgcxACpE5ffl6k9rUK19FGetyxV67WCPVpi8d3niMrKTu5tavNKCb21Asxloq1hOHErKF776H/KIcnYsNg/ndwCLY6/5zxEsINo6m6+d9Ngnj/daTf41kYhRgRMQSErwaHRG3zWii2v1FyvG/QF2+CmvRAN48cZ0Q3aoMwtpTkcPkuWW7T0uUiy0e40F0108JUg8V2ZaECIYoJvSJBM
 cfETlFS6
 12MvQ2oSewM1Ha58iyw3m53fFK+/Z1Jw6BKRfWG1nPXyRm0kDsUuhZPSJqrAzJOMNbDXiEb/53kkKx//++2vGYkFadJDZpZ/DgD3+maMsnV16gJw997iGlN5b6i3M6ZoKWtSRx3Ei0hw8lCWxV5q4JnAQKxO0zahBzZrxPvNpP1cyvs/bidZceqPmPyafA855KrRt/YfOuF6l+sdhrpYMeDodnihyJMmeKkirLoZTUbwfzmJk+mLuf4U5mD9Yqj8SvsqWdlZGjY9oGj/EzP9HaD7fHEPlna2cQ0KOwmhlYoVmSITU1yO9FpC9W+5qL+bSa628YILzL/QvfowAgCyjAj1PJDfzNSR9Rz7x1PHX9RWw1SpKtw+FhXGHwJgNU/LYd6xcb1SggdsCxQGQ0WMDiWMLKcDNWFx7UzbswhGwH4ZdjVXCtk1Xp6HrZrnjyoWtKhoBFxoi1FK0lRJTqBmsfzTVelkrkwoDKttGr7tOW/j+v+9vIUYrhCmxbmTjH0O1YXthr2Gop6/iGgC8iiFN6NSghdRj045uTfhQY16SkhRRnMNIHz4l5ExiTAsvEjiGfLs6oOWH7NeAH9v23Ir6YzvqgEt84eJY/a9VC+u7/+ht6VwZw0GxLEH/eZCWGoFDLZWpjtJAXAnragz/7ei4bQ2XltBzQtJYsCtGTsfxGGxq+DQyPoiSTee/s/1nfE4Klv5gGLcVJIhaiFbuq1d7v/jIxp9ZCIBSKhshwjJkDJsF84dEFW9xCacjmOO4wcHldR/OnruR8C3JoxzvjBihgGWxArqgA08nhE15GBURIiYGnfG/3VcGsgeUxzdRnoAexq93+nKSl5lEOsopy3CmzJufxp/661zSy9T/g8XSFbqcuoon9AjDp0ldS62C4VIJPt7VSfO6u6yjnHIDbMGm3n9cbafk5Xx9vGLuk4jDxJsqQ7Ix3HyXQ8BY2EAGGrx961kemFTy3zrg1YkicdJJP/xR34Bp
 J1tVbURZ
 oAsdG0HqjHEFKnKsairdhtxCmiZbqe7bQsqSXM7mjSmxpL9y0BzT3JWwLT3fKMR67h7niW8aPjWThMLAY/EO2fzQxSCy8O/r2Qoo101crGm2LNYk8AR5YA+nzGAd2jxoX6DmENCUCg2XUdmAJTkV5Ojl0iLURfFxzgm527L438F50YQ5jZBezt0pFsXSMU1mP9WMG2vrGSX+5N3w5Z+/djJpMXi+eHxoLSOdO7+wlB8wDILmI6jxt2I/zaq/hTqEJkFPfw9BZBvGvAmrduzpk8cJTgwj/th5Y3wI4dee/e3QP1W4OLrGwwJCAKE6APtB1Edq0NwFdLgpmS5cquy8d4/6ly3BhYxuG40uzB5VzQOWMaoysMijj4HO+L96th/aWnvaqdAApK/PGF3iP5fLgL0Dt6+QUGlR+7ssKVblGuHVc4C6nk7XAy2pn3nxo3X9xn0PRYFp81Ye/RTBuibvICsv3KXH8Eys2YCUVMPMmZ7Bo1ZFhM7LqlaVYL1iOCnYSzzmSMST5Jw8LHfsiW7IhtgU9gBimtudx8taDa2vjFRAt168OHmpBqKAhU31nqM7cLGYzAYdhTD3Mj7t1V6MREHqsJARdeijrmWJHjPHbuhmfQGqhAMCl4unweWTTdq287x8q/6ISu9/ycr/rdtBsEIMwENOm6tiBvKqVAc0Y7jEYccYmbV+F0IA8z1GDF9X2XLmx6E7MEstHXqp3ngA+l6tEWxBAiZD8pcjXI77fdm5jjrtxhjGZQa1e+hygmTPzm9vVurCTSVamxWORBJO4N5qGCEJCofVywQtWeGqnJNHgt5cYYNPQj+H3RMJUosXSllHGgu5PD36T4GhUyvg1GKb5F/AIAmQwqryhCm8pswyd7mX9mthCLdgvaI7+5HWEhgpF6Pf93XfNdqjSL7I/X4OHSoaZNOl+757seRf6ZJE0WkTG2KIcQyoZXeDe6E0QL/uoD+fWnzodmHWSSU/tNr2qoUV/
 G+DzVGC/
 5ZOBuOCAXId7yRtBVyxmdP32y7dYe6bClH044zlMCt5oSW7duJd9ulSjKdYJmBd7VVuUAwkhqXPJIbIjP+ob+MJxVKiGAO0VIJJ0fTgtHijPUQSasP//o/iqsM/e6YceNi6s1Qqm35KhT1jaNjCSzqPEaQaD/AnJMIt2sDRjtsYQ5yk07kMxnKYxcCHRTi/75NleBdd6izJtTFrZLUbDNBlcK1xP4s8ysN7VpJXN9orziwQtwrIVGOl8A+GY8sP1sIITUVFWAvWfp27w2byyRa4VfBjRPCHCusdfHu9zJ89ufC31MUj66TJ185cwi+kPgJLXx/TOsOTaIsab7RS5+XEr9bKh5EhiNXmts65eLOUaDyMWlRYHSJjXSCaYeq5GuVSFxYQuOY7NcKpS1ZPn353dFZs3GUQEfTaqR8FxOrVsUW1hw8EcojVw7GLuzFCTC4DM+Y98REOS7h3FISiTyTLxLbfN/eX0rZkx4MFwdlx3p0K7H91OwqFNhRjV6hq+mMqXKPwE7LDDlRhjQAgSoQebM4YgFKGngws6rgoNfqOVfj8M6Ulp1CGa0hVpEDdViZHkG31dtEF0/NCo+SohEiTVezxc/nWb6HJkzXM9jmXCmmXuwrT6kdUk3R5ehWFWKAWBMt74fVUWf5HnQnq4zl1r7PIe8/P8GOBwuEd0Y7XxaST8/U9SSWKM8xZ955y+KwaLcwDImn183LMhy59ELnHXaIqx2c2Swcxb9IRxDIJrKsHkDYmPxRd7NOV+QPebgb9wHlc+EIAbVxIDxo+V7j5elGwz09Ey7Kn4wXsA/0T+VAeVmVNDEN6yO+LEF81FFAtq/pvKJHYJ6eAVlRhPd2MszwYyKQlMH1RvsyXiJkiiKcjnw3WelYEZyEZ8u3q3gQY59fLX3+vjUZ3H8lxHaDOjU6ytGehuMFNJPD7TGhyYfol1trv4KAyfhMnOrg6CaggR2g34JRpMig6FTDF0CVRCqdhxG
 BZyv6YZA
 nJoOzLFZq90IQ4KaOvDA1sc+c31D+swQD2+l5muEZvF4Htpw24tdDEn76Suh/PHRcuy/f0ECr8pT4h/0tnYWHO6CyJhA1qvfCNxG1KNS5vW7JDKGHXlnI9b9M7hYkjys/LKdlIY1NkETY+lPJhoWOFfvYT5SyZdLGThOdMZ2bm48OzQsVm5DP9Fids2M2FwvmQznKEYBc3jKZu99JHSNXeR07UdoQRxZ+zPM0ngwvuROvrCSDkYngC8yUuJz2+UEl/OLRcB7j6o+CXEYheuJe7jrsdswmNHxIOaLVAkEH/D9v072xIyEtf34/DRUbztU73Z6ooxwGNkKLHpEJ6yKbwhRioXZOYJWIJquqk8E7SPk9bgGkNgUqVmTAQFCjO4CCn4eFNH60Jlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than referring to VMA flags with uncertain meaning, add a new
predicate that explicitly describes what absence of the VMA_PFNMAP_BIT and
VMA_MIXEDMAP_BIT flags means, and then refer to that function for
determining VMA mergeability.

If neither of these flags are set, that means the contents of the mapping
are managed by core mm.

Otherwise they are instead owned by some other kernel component, usually a
driver: the memory may be MMIO, kernel-allocated pages or even ordinary
pages the driver maps itself, but core mm must not populate, reclaim,
migrate, copy-on-write or merge the range itself.

We initially also treat VMA_IO_BIT as implying a mapping is not mm-managed,
as by implication it cannot be. (mlock() also sets VMA_IO_BIT transiently
on ordinary VMAs while locking them, which is addressed later in this
series.)

However the intent is to in future remove this, as no mapping should be
marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.

This forms the basis of further work intended to improve how we express VMA
properties such as this.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 53 ++++++++++++++++++++++++++++++++++++++++-
 tools/testing/vma/include/dup.h | 29 +++++++++++++++++++++-
 2 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 97e1eb4fe3a4..83953757735a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1612,6 +1612,41 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_flags_is_mm_managed() - Do the specified VMA flags indicate that the
+ * contents of the VMA are managed by core mm?
+ * @flags: The VMA flags to test.
+ *
+ * Such a mapping is one established by a simple mmap() or brk() with no driver
+ * or other kernel component involved.
+ *
+ * They are rmappable, and core mm services rmap operations including reclaim,
+ * as well as population, CoW and merge/split (if eligible).
+ *
+ * Mappings which fail this test are those where this is not the case -
+ * e.g. MMIO, user-mapped kernel pages, udmabuf (pfnmap shmem), etc.
+ *
+ * Returns: true if the flags indicate an mm-managed mapping.
+ */
+static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				   VMA_IO_BIT);
+}
+
+/**
+ * vma_is_mm_managed() - Are the contents of @vma managed by core mm?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_mm_managed() for a description of this property.
+ *
+ * Returns: true if the VMA is mm-managed.
+ */
+static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_managed(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1620,7 +1655,23 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
  */
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, mappings which are not mm-managed may have established state
+	 * upon mapping not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (!vma_flags_is_mm_managed(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }
 
 /**
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index a6a8e53c4b38..89c645a6ad60 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1665,7 +1665,34 @@ static inline bool file_is_dev_zero(const struct file *file)
 	return file && file->f_op == &zero_fops;
 }
 
+static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				   VMA_IO_BIT);
+}
+
+static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_managed(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, mappings which are not mm-managed may have established state
+	 * upon mapping not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (!vma_flags_is_mm_managed(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }

-- 
2.55.0


