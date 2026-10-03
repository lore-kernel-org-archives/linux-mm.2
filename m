Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A745CA5FED
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0CF76B00A2; Sat,  3 Oct 2026 12:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDE66B00A3; Sat,  3 Oct 2026 12:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986026B00A4; Sat,  3 Oct 2026 12:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74E886B00A2
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:35:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BB2014095F
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:35:59 +0000 (UTC)
X-FDA: 85281866838.24.FE5E729
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4D267C0009
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:35:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPz5LxHy;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1DXoUkSbCHDB5/Xr72J8sRkKl1C1gbE6EHIJqGCwGg=;
	b=wwf39n3wrXsth/YR4exltgt89oKTxWzIkCFqgqYRskuZxmVnH2XC1Ur5l4YIqLwNTKhJOs
	G8PBCUFFXyBzpEtaCF6462l1dstqGhzl0KUjfsacfMGsGoInOWsRS8Bz7mQzoys4706H5H
	fx37Xhxhn5SWi2zEdqaxVWMnxWZtxaA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045357;
	b=SK/F9sdFswTZtkt1EOdKE8o6NZ2kAD867pdm987/78EIQoT1kc8o2kkyaS/MEZyWTkOMh4
	N/h/SQORJcMmf3jOx9ei8BClCRks6cCUOj9tzbss2ZMn/uvvtEyZisuCkANzokQNin4fCi
	blkjyuIyl6h5s08vOvYJcTPmxFIT54M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPz5LxHy;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBADE60D82;
	Sat,  3 Oct 2026 16:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10121F0089B;
	Sat,  3 Oct 2026 16:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045356;
	bh=t1DXoUkSbCHDB5/Xr72J8sRkKl1C1gbE6EHIJqGCwGg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PPz5LxHy3G1qDUlvARG3+tMtiACqs3bzu8cNb0P0ui5aLGbnPdtzOBuLVXjrlBcOq
	 0xPxWL5q6CfOpYuDQ4DZGO8dyAI8Q12VoW9CDvk8LP2WLv9Yh+RIOi+bwJOMNkSKye
	 605nmP3mlMB64+H3KtW5y4Im8O8vt/v07L9NbbzBh+cgAMeDEx6+tdJa1tkF44Ic21
	 PqpWYQe2FX/q8L8Dz1zAKLr41WVAkJTRSVIbsUqAy42AxVmOENUNLa6PbXmxGtJnT9
	 wotnEiAnr+KkP6KTQwdWScwy9PfIk2OAdJPi83igA/4DoKs25Zd3a6kfZnbShoewM3
	 u/aFDA+xdeb+Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:39 +0100
Subject: [PATCH v4 08/38] docs: filesystems: update mmap_prepare docs for
 discontig kernel pgs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-8-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4588; i=ljs@kernel.org;
 h=from:subject:message-id; bh=koESur0zwSvHcfgESgd6PK8AsqgBdtS0d4VRrETj0oU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6ql/mv+6VEfds721fe6hxuhd3+2NfROPLu5LMzRs2
 lZ9hedzRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACbS+4jhN8uKh0+MLweGzMkS
 XPD6zDu7ugNKp6xL/oWIxR8xqbN4I8PIcKi2/KXucV3PNV/Fo2rbEuwnqLIftn6/WElq50Ob48X
 XuQE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: 8mzur4c5iw6iqwjc97d3mswpz531or57
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4D267C0009
X-HE-Tag: 1791045357-212792
X-HE-Meta: U2FsdGVkX186U0t6BfgaRE+bd7Oxho9wP4QtZdtrJORuqNLi6edCVMAZBTi3gWFrbS0Uih46T1IMw4MvP/jas4m+klDczuhBuAsKCSgBLvJRMAVlwQhk5Z+8inkU2Q6OLve7dvVT7ZrF5KtfBHQstYrcob1y5ErLajLsFcbjhaLNiRyt8gdpRqXTN5eJmeWwIOLbdtlA4+A13e6Z2T3O/R5pDnh9rw3IvJ89417u80mf1MrQTkABCuWPTXef0Uxv0MQhTdXpvaU6HiMyrhpbHsGIY3w64d3QkUSpRD+IJoXW/z/0kjoaxChdS6aw2kPu9fwjiKuN48u9RPZjw5zE3xG5qUEWOo+XoX4HnkJntD2LQO2AXpv/k38FuHFt+LbxOzM01omNFwEhkMkdUAnCcFldNgcCjJ4f5lTp203gR2qFRgl7HWwtlrEHa5B5HFwxv8P4p+oiynligjqXQqi/DliTLX2Tk4mMR4dm6/JdmFz3syAMnTILkkG+pENfjzw9EnLgcsBpIgoQ8ZlukYSTvmy1gcydmJFYyZpS+992uiodVn5fZk9gOJMbJiyJd5Tq9je7RuYn2fs2bwOcYAzsHzDM+cuissxox3lR2/ZbiT3res/o0yrwerryMPxFs1pCGnseYUjbLXp+W38ck8CtmCPy2IG0NlTi5uu8mIRBsvZF9U9z/W8zwWMlTZ7KjFJLjN5ufpwh7/MuIoY5pb0JUNKmhA2UArcsG96lYODks9fjcc3wLe/dwZ73/c3kgUGIPLNGT/mGqoDs2wX3HmSxpMarKPrj0XJ/Iggz1WpjBsn+wUZLT7Clgc+8P8Xuumsy8zXytzyOpaw5bQ75BSyGFmRmEHyWlYUzkNJC8re5fFDijjdcvIvKYfUzY/YUl6zvLoteXM+MCgvR7ZWGCAJQJ4RwQbcb9LdyUZTdrRWfC+wrJwzuEA8Yz19qA+qOvsaLyFccfwGpLga1ekleYba
 PwrR3u2W
 JPow8VUahKMaa+uyES9yhgYKaLSEOMrw+kiFv0d2TYYc6r1ho5mNDhi51obrsPAwP7UMMUCh1MLTl2WWF2aF4CpEzlSHpbaGhaoQbFtLikgZbHL9N28SjQ/2A2ciHBo6DePN5KY+t/VdO+rGupHhgDdhg22HOIhSOZSvIgz4TbWLFEf5PGx7JRxugsXhNnxB9CpSRJc1655x7C6uf4TIzpU1n0jgulcUlRzmyu0Xm+jlQ+ovEmBCPsvdqpri+Oa5FhQgsHjTzMQxpNIODr9jBxRIyR3jhlsLyxzZOQO2tIjDqr0B6CWq3R1EiIuoubEyKbgI3XWCyBMygVaq98mDRuHepyeN8AzUjtwB2HOIJAvk+nowQHRDGDumZ4sMXHI5N4kpg6XbC3+BJe2Du7s6KZoSGvsTNfORDd7b4qI7I9KwoTLPltRBKvKI+EQ4FQneSB9LF9vUUTsYxAYAi8ixy9ghpuUntzvBhP+E32UKQlh8OID1eajms+7P4MaBzwJCYPSw3YmQK6iLp8V4kZMkHTHaA7hfkdaWfPMyms4wbEPq8uIbBRy1u8XoTpy9SNRk8d3vuqhVQNBMcsLrOZHBLfSbwMsXXYG6DiM7hp4saPykmDIUF/4I67ECFApVCwe1hZzyQfDbECj3qg0vBzADxeHMD1iBuyK+rF7MAy/oYE5HxbfsUe2qhtuibVCPFTjro7UI/cPgbsZz4pBVuTp7Cn22L4Jkb5vD48tYJ/tLmWhsOY5efghdZqSkU7pV5gD5rFX8+GoUIcZzyYKQkwdqJhO+o1OuzwhtwQFpQr2K9wnFtDNo4BL4qkLHXCSLuFjKhWUOAdMFJD0FqBrtbF780rQRTfFDvRTi+GmMW9+eEuOqdrvLBgalFGxHCtuNTIDWebDMc0d3udjGY/NyGiwERk8HVtLypG9AitiGSJowpAgAXMlZTTg4ZMSeU/Fdum1+EbYgGztUM2mSIfZQC54XpznR4CcyO
 eQPWf0EI
 QOEvMH71cH36hKgIQotRXVZ8nf/KpFYO5MAbkvnTOa4dADbje4k2KEYly31SKhKzYrP60EevI5pQDNo8Wf70zg5mrKRsecQ8q7ceV1JqJU5GeFEHlZ8PPvfGC3YTOPDG4LYhpnnLSoJlXcOghebW1/xAKTnnkHmjnkNQrq9yWq/VyVKBwrK5rU0XM/1fdn8cl+3fQ/Q52tqkwZZo7TkDgl6BRH92U0ZLpvNM6WKLct73HKwTdYU8t4YP8qcnJ5c6bXMRwMkaYSBQPi69hhfZIVSU+IdesK3sJE8iAABZ4TCuxN4UxUbnQMbowCNgvojHFHs1ZXcTZlUUOa+KvFb8uUl82VHY/Hk3gRHt8Xlc3RRQelrTXWwY7Rdp9PnAc3Z/1tyrLKo+/pM6Gu+tdQOPcscLJf5h0Hv8EIYVDGYpHRakV2W45NzExHvNfHPUd4vNJMr7PiMSuEoykwS3ovBV/XMm70G02z5Qab5ZR56ERTft1aXkXFSCwbqN685NmjJJuZKJh2d5r12uasjgw4lq6Z+08aSs293gico6w1BHCnipG0d6dM1F5qWTiNgW7UOwljII2Q+D2QC/N2UoXMSQAcab/tYu/ZtbtJ54psNKtNeCiGboCusuh7ihBuoCj+nZgK8be4FQwamq7GiUF7Bi5AVr5stRvk3IciWZK1Q3HBirMsEBHVcqnbTq/S2p2Tb34SvoXNvS8KfUmx8YlTRH1ZxztO7Vbp2ZPIxYscugn1+tNj/9Z25qQFhBOh9AVTtnTOzSRcsO2Wj8iXtw2lT4IOkIl9r9UkqHFbPHyrpVCbwLHvvPOm/WDOsMIvtoyHUiNAAzgTkZkjRLTOXawmKtFrgNIOvGwrd65Q/DqzSHXc+7avAvU076OPGkMNIoHZXFTOOfN9kLSy+GE0KH6kdgdEYIs9OzkW+nmFQpLBXPYaOIia1Z6+ojCmtbcGRpT2NNK/dBx1xfnib0Y+3f0lwpS2jen/cOH
 lxVFfQqJ
 odFMLZ7C4bGddu4ume7rCy9Udwps+ImgYiWlwUchArzEgOA1dLY6LTLQdmm593lyeTDVlp63mztlDHLULgxbeX3xA4jJ/sjl5NuzkWdtHLi55HR1zJSJusqmF2VAxMKHd7+Bie6C+iQ3mWlTnr6WaIwq2ypP7Gom8QM9QiysQ6qDQbdlylM0xxrbKy1ZeISvSPwkO+06MoUd0CxlgsviqvOawQVmoDuvstcs9Ib1e9/u45Bl95mX0/5gkl9gmAqz5LfviwIyA6auuR9CCRzhQwumRXvm1a3+clZCYR+iIX8fHGnGJ3kUG/ZglLj90gnCiy2qDC/lbxQ1VrEFKsQTccmTm8I/Z1vDvlkwry1sRfIFPDDmu3JYP+j+NJtb6+sEc83acONjXRXOiN8xMzlYPm00uLKY0IKGza5wO5JAkgYOpJTpAHh3FpGRTwisIMaURAcWN3oy1D5g61ji4oy/XAfXo50UjbRsbFRtocvgAjbEyh+DDqsPqazTD2ISR3Vw6q5PuBvX7RW0WBHtbNO67ju4fCrW4YyAm1MCJ5n2UdRlOYgutnMmDxCjDVmslKbvjjrkcMbiszBIaN5mlcnRwN/GpZHR1zHZwLru2GdtiS8iOmFFu+AH9fr5IC2hi+oY5PraV54SSpWyulZIg2zFsdbjNEPp0FDLcMW/ttK/Ztz88Mb5F/NnIzpVY3EA7SH+mMEiFVuceeKVYCRDFmOhogNKPXv97Nd3DCc5CphuMmAUm5FE/2xLd1iuX/jhJRTkEuNbWduIiQhMxUdVDopstAmswivSGMIak1cLro10V3MEf7QzrbCFAjZsEnwkjeuHD/ZuTFBVkk5iEQq0sK1+jeX1AXI8C50nsEVCOXDhWVaLYaRk0UVmmkuVl+9pgmdvNYk4RQSGlnirJoC/ppMP15QW8xHsvlMIdXc3yw0lPBuhLZEK0tImF+9qQutYFbexlrnXLkXJ0vc89Ud88IjcrqdVY88Q3
 7jGxK1Gq
 e3Y31LP+oGi3xsoFhl/Eo7CBOM1pohObLcCjnP01C2+WwMhjC/KH/YHUn3CrN99rmwWjyfO3lznj57Rs1SqkNziZeaW6dhwQ3nrZHA4cStFFUMssm4dIIWJTqS9eGuXV2l7GLSfYcOTHPtjMxyhNBFae/RZ5K7o7EsMmBH5hE1kV9YBKhTsljvKj7gPY1kAy3d+qVzwCcus/BPnDnuiVxFkU9N3yayMhiCUQ3MG1+DWbE0tGTX2thtxvfKYtWcGbfS/TcMOiLV021igfOw9+9zAubgyPuwNR1TyuSq6pgzdrO7Q0YoxbfrEGyQcFKEpvGQKF/oti4WLK0j/RKIdNVd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe the newly introduced discontiguous kernel page mapping mechanism,
detailing how to use it sensibly and how the API looks.

Explicitly detail the various discontiguous actions available and how to
use them.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 Documentation/filesystems/mmap_prepare.rst | 81 ++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
index 82c99c95ad85..ddb4434d919a 100644
--- a/Documentation/filesystems/mmap_prepare.rst
+++ b/Documentation/filesystems/mmap_prepare.rst
@@ -164,5 +164,86 @@ pointer. These are:
   sufficient entries in the page array to cover the entire range of the
   described VMA.
 
+* mmap_action_map_discontig_kernel_pages() - Maps a discontiguous range of
+  `struct page` pointers over the VMA. They must span from the start of the VMA,
+  but may terminate prior to the end (leaving the remainder unmapped).
+
 **NOTE:** The ``action`` field should never normally be manipulated directly,
 rather you ought to use one of these helpers.
+
+Discontiguous Actions
+=====================
+
+Some actions can be performed across discontiguous ranges.
+
+Map kernel pages
+----------------
+
+To map kernel pages discontiguously, you must provide hooks using ``struct
+discontig_kernel_page_ops``:
+
+.. code-block:: C
+
+    struct discontig_kernel_page_ops {
+        int (*init)(void *vm_private_data, void **private);
+        int (*get)(struct discontig_kernel_page_state *state);
+    };
+
+The ``init`` hook is optional and allows state to be established before the
+operation starts, for instance taking a reference count. Nothing is invoked
+after the operation, so ``init`` must not leave locks held, and state that must
+be released once the mapping goes away should be released in
+``vm_ops->close``.
+
+The ``init`` hook, if provided, is invoked prior to the operation starting. It
+may update what is pointed to by ``vm_private_data`` and/or ``private``. If an
+error is returned, then the operation is aborted. The ``private`` field can be
+reassigned.
+
+**NOTE:** The operation may sleep between invocations of ``get``, so locks
+needed to stabilise state must be taken and released within each hook.
+
+The ``get`` handler is the key means through which the operation is
+executed. The current state of the operation is provided through ``struct
+discontig_kernel_page_state``:
+
+.. code-block:: C
+
+    struct discontig_kernel_page_state {
+        /* Map state. */
+        unsigned long start;            /* Start address of VMA. */
+        unsigned long end;              /* End address of VMA. */
+        unsigned long addr;             /* The current address to be mapped. */
+        pgoff_t pgoff;                  /* The current pgoff to be mapped. */
+        unsigned long nr_pages_mapped;  /* The number of pages mapped. */
+        unsigned long nr_pages_remain;  /* The number of pages remaining. */
+
+        /* User-defined state. */
+        void *vm_private_data;          /* VMA private data. */
+        void *private;                  /* Mapping private data. */
+
+        /* Users should not touch these, use discontig_kernel_map_*() helpers. */
+        ... internal fields ...
+    };
+
+With ``private`` being an additional user-controllable state variable,
+initialised via ``mmap_action_map_discontig_kernel_pages()``, and
+``vm_private_data`` being equal to the ``desc->private_data`` field set in
+the ``mmap_prepare()`` hook.
+
+In the ``get`` hook, the user must choose how to map kernel pages:
+
+* ``discontig_kernel_map_abort()`` - Call this to abort the operation, whatever
+  has been mapped so far will be retained, the rest of the mapping will SIGBUS
+  if accessed.
+* ``discontig_kernel_map_page()`` - Maps a single page, correctly handling
+  compound pages (if the compound page is bigger than the remaining pages in the
+  VMA, then only those pages that fit will be mapped). For a compound page, the
+  head page must be passed.
+* ``discontig_kernel_map_page_range()`` - Map an array of pages of a specified
+  size. As with a compound page, if more pages are specified than remain in
+  the VMA then only those that fit will be mapped.
+
+If an error arises after ``init`` succeeded, the core unmaps the VMA, invoking
+``vm_ops->close`` if set, which is therefore the place to release any state
+that ``init`` established.

-- 
2.55.0


