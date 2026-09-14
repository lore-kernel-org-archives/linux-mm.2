Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6968FC88E77
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EC0D6B00B2; Mon, 14 Sep 2026 11:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59BB06B00B3; Mon, 14 Sep 2026 11:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463E36B00B4; Mon, 14 Sep 2026 11:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7536B00B2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:03:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0939A013C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:03:39 +0000 (UTC)
X-FDA: 85212686958.10.767C4D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E148740002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:03:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSetHrBg;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxJPdlL4ukdxMfUTmFq0FMtswRM14QRAmb+14GeHlio=;
	b=Dji2FA1L4e8F5pA+sIXa2+yoIkAnAQtQ5It2Rhq0SUg73nwHFrn6qTRgTzXGRMl1cPAie5
	xZrs91Z9MS9B3lJDoiHEj8KQPz3+qWp5dnahAxOcMDHNlEMZ9wvMq2j8DgaBeybXMR9RZv
	cK9d5AB7o2Go6veHecQzpKfrRNm08UY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398217;
	b=q7q7f8PhxtaDvp2D3cn/nD3vLgIcKXkRADqHpGpicyCmTlGyPCe3mnanYbk8DiPfWH+MKz
	0eN8OgAYf1/qEgi9lgGRF/XJv7fOn1Fp2+v+SQp42U9pi0tWEGpyU+vVIReEs4K96tPgAo
	e7v1sYbEW9DbFuKOnA6Da/GXRVB8Z6E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSetHrBg;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FE1E60258;
	Mon, 14 Sep 2026 15:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7151F000FF;
	Mon, 14 Sep 2026 15:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398217;
	bh=CxJPdlL4ukdxMfUTmFq0FMtswRM14QRAmb+14GeHlio=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fSetHrBgzPj2+SmYbcSwP+UBBu7oqgySlvgwtfGMifcj7mtjDTFfovm9LWqpVGZ4E
	 d7LbTBCClp6uaGQ5kpmXzygZI5dGPwY1CEx4yIyt90eoup2gdN3krNS6lZoRG+OzgG
	 T/Y9KDrh7F7i8HLE8S1YLHJ7wur8fIhpd0Oig2d5jDtbELt5zPgD4WGUXZ55AClFJ6
	 ASecwckytcje5tQBKYzFUV5Mw5My6byzSUXajoDaKg5mI+g+V7W6+ZjMzxuRWpRDMm
	 1GaiGTCu4y6Xp9Vd+enrCQ22MdEsms5v3l1aX4gNaStO6nRlnTtDOQ0M01FETTbnEN
	 AVukgG7gVlrgw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:29 +0100
Subject: [PATCH v2 09/40] docs: filesystems: update mmap_prepare docs for
 discontig kernel pgs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-9-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4561; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ku45FxaXB5jDrWF7xzKWcksoG8pHB6sirZFvJa9Q21A=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK+3CPBUi47Y4JZ9bPo5/xi/KbmTs6/O4NKvF01sq
 XRJmvOio5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABNhMmP4ZzX5sUNP1OVVti8E
 rzxqY01cr34luXPC401KRvvqUp8ermdkuHgi8u/r3VPWcjI+S5gfkrcl4COD0rrwyze47s3oC9X
 8wAEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E148740002
X-Stat-Signature: cutktd84cstgtnumtcde4moi4y86iac9
X-Rspam-User: 
X-HE-Tag: 1789398217-910144
X-HE-Meta: U2FsdGVkX1/yx7GiGhHRMaH56n9AFsefgYQnu1e7YSvSixt02+aN5z6KGxNSM2QAQzvwBEasa2ZmzDlpv4c/qezyHwC/WMpROBJCJ6XwWoplIlX3uGFDM/OzWNEloK1RSPdncHQxlPPLB7leEjq36T5JIQKgfRElAm8fg99n5l9+KMUG8gvEFCxuNgWomV97iG4jqQBrH5IRygmITV6B/4w64f1Io9VrdxEeJ3quFvt3NaATbIVxQ6UeAPK8vWFzvinBP/Bes0EX/GbBjjIn5zCkazau/iYSDENIFpR1Ku/ZdZ4CXABsc8aP6CxqYy+Cxut9zh5FodwvtSAxTTGDfoe/UgL765tmBTP9RP6M5eGEeUG/NGmLYnMKC3AvhtnH8HPfarwoCwQ44Uk+MoHJcaGZUBcTli5xFzHyFJcIFJnPspnMVR8tad7t4XaM8YbEoTIg1A/63ZgmcoKQ4NUoguKoatefj0gHlTVdpXlriCxNKXkSK7qzIwSwUgYKjgFKWmBYDf3tGdfLCQEP+lVUF6x79XFjUzIrI+vLDaNWJB52RKlFA08K9dow2XiNNTkjO+o/q7uRQRfeBrXKqBVEdXSHg5weMV1LP0dru0XE48ylnSN45tdXvF0qiySxuLwYGQhhTJwThqAijK6+2WlRV6uOdypZsLdw5JA/XwASROWZt3gsMf5lfek8QL9BPf51z44SWZpoL+Unp0E22yPFA4uHueTfWLuMV5rhRl6SGb5Bp6biAX6VfvWVTxFg6MtUOd5pOykQu30WkiKJA2L9EJtpbSwVn3Yn9wOQEHY5+krDW2QMX78yGUEaegf4KgFe7/pOdqWrpPqKFb/7DQkw/fm744hm2uvvHjD/XLR8g2Y2emKEYNpS4jyctY0QUDW7T1u0qgt1B8gwUXvrol4Pp3kTgnD4WAIVvSuqLpBQr6mVyr7i38WcNAFk8BPlJEksAVYJ1pfvhuvkSiW8vhk
 HTrzES5n
 ANK4y2ia1gusrS+hPESRNXUFcCeCydocFXBurok11vCCB5m2vKCgd26CRKhcWgRJ7h9XZVYmCU+16mx0wAHIQc5ov9lm+VbDta4Zpju9c2BqGh2P666z0l/9X6iGrmI0MX4oETOLKzHy3TmhO88F+X7QrWUhgfoMJyWUNAIlUsR6stT51hrpV1QcwAL++YcVWa1fInmFJFj9neFxTEIUOt6m4eeDJ4bNptw6NU7NhCprnj4U5n5UZ70s50U9IMvihYwr3uSGgZhBZZ1F5ctiCkBLgMnrO/yt3bypPPfCjLg2eWldbl7k3evgXkJpEwp8iHUbByLlUocd8KKPvoySqF3dfH1ilHUIW/pKiirRfSSzmQjYCENyYMEd/e4SZejh7HpWz/O/b6S430DTUcE1ix+Ew5yy8IVG43iGlYnFbgLwJXGSYPHu5l3i9aje+eOWh+wa+C1Z8iRmWQEyCtPYFRYF2JnAkF3GGDCEoejcJoW3pYW/nxUu4/8UDxhRFfLwPCgRw5b2U8NS2Hwrng2K6eP+xbKZM6Sry99ngIkr9dsE2ThhcfBPqwdCkjcB4zlCMsrYWn3ChYm0CevWQOriuQp7HYxPH2np1yjD9khdj+hY4nvOBP6n2lC/VHJ+VuskJhxcJ0vwiZK93WZTNYQveY8vs6tutb5+ENEbQdsiJTzjgc++k8uKlQS2nwxagyURzZZWGgJMZ4cW2zis0qXT4QNLltfvRZBnHUnsN+1B6Pb+6ekxaH/EPmsOsCAVHo0iCyqDDPiJuPoVMv0hhfPoQErePcpd6kCvLB9nf1ybOg2E7LwCkK/a7aZ7K1sw4i6doU/QJ9nMLmzxLpEkvB4FeVaYFmzdRAvYmzga3aBNvleawGa4OStBdsi3O10LWBFDECXJ7PGtlLgO4QHMfkqkYy+QE20hymcgbqmIvhpk3zxT/qGG9XV48WWvM7uS1Jrh+3KK7GxA9KUuhtiZqrlkcwx2ufk+h
 97Avzb8v
 kBp1SWWmE7N7LmnK27zOz3z+zsPfyLvr7NlHa/aP7iezFBHgXbs2P9p1UzBJqoY1JhmjfdcaDmRfoOKMn2M/gjUQX1czQteCjKgeBChji+6Vp2jlB+LMQK0BQWpKhMzv5aQOxTRGBaSII08qkYtT2ieUFm1Q71N2MqRj8v2D187SeIK4O6V4eint7U13+75Tkr7Ga3PgwZer1leITXwiLcZh/vbwrSF/qtNjqXJoUK2ZODsJnI3Rwbb6oEmlKycrfAkrZpttEnmGrhRxB3arIaj605Web0WwODwg16dc6sU65JX/G7DUhCCLhPd6HlooZt8/BUw2+/JHXq7odnonFqlb5clU02JxCgRjK+Urp84clvEfOETbEOa75lb0nptU/pzFk4jVNnNe+Ub0vuDWs7TJpcMcoSsVoGl7nBcwqiC8tr7tDp2xr6tFXCxql2aTPnh/fo+N0zDHO9GztpCu0XGnXmVrW1y+YWtOuodxP3LGuBTfeoGnzn9IS6RPbGNmSK0z1+EyQxHLRklbN/KNOikSTdxBUcw6Tl3l9BCYxOV3Val3K4nfwHW3VxvLU901Qei2IauAE2kDasViaNOreKPMr04st1pjXBmLSgfThE7j2ugxz+dZYuFSOaZcIl26q6W2o6ArGPnks5Fc5xO2uK2Bf1mxFQdOQWs74S0NIiEKzD7cCarz0tVu9qNEZoNIPiT+yWoPf0hJfKNuOAaT3lmn/TsonyuOUvqMAcKCMSBDEjM3kUv1MAlxqHNQp4nxQ7Sgcy3DXJKzq5d046TmG02e89zuT04LJ5JIff3xIAk+xQCOK1PrD5qx/MC1E4PpcyqGggvEqCvo5X3ft3SftYCv23xsYkfkKkAHAFX8gdn4hLGyjTAQTCvTO+KZphiNizDiml3+qpKNsUV1MOfLKu7gMdFPDrldP4FGgyFcBe4uHfPzGgD64edq8mf4Oc2kfo0x0FOg4M0/endBAupkQmilT86Lw
 mILQxA+Y
 3N7AJ2g/YkDonzbny4bQdfgFDzF6G4ZpXlejogOwLU0FacqwECGndzDX8xs0lk9geTGFBUtb+f5EQjWq3ol7e3EGinnrV7wpAs9d2O92IiGbe33kXJEuf3M4A0pubF4DglusM6/n3tjRDKjHUTVfpGbYiWnTfEB8460X5KymPknIP/ad2wpT5jRkUFeISr+E1B8TeXVK6mrfMU/6cl/QvegrK6XXxXxMhsDtCjEJ47/78P51E1DZd3s65cTTDcWoLPjExLkcZ7oIYqOV2uYLbvas4U0afo/aM1xWdAmsoJj9b0E1CDx0vaA7lKFj4IE5OjqAncKgV6HqLw0XHlba9FZXuhCqJAFwFS1jIPKFbehl2vHXNiIPwwCvPsi0KYnxxa2i3i72ncK+KnSasahztnf1Pkb+qw8MI/vUhB1tuTzL6exDpEQ05jFYKHPL/LJZFwC0agrkQxVx1TPa1xWNGvNWsD2/PxMAQylU7nW2ERimG0mOcXCdwLm9UIvCzdzTgrg0Rex9q+iiCC2LDbrd06kgToZG0e+lWJ7njAtC27tW5uystITUv41CCBDdJ6jz8IIhCUMI2yb1uho3eq7HSkOCMPnj+Qw6u8U8uKEyCpunBJN8sHkT7I6rsJGmdtHZTGnrQo5hm2LtlLZb59cT8LaAd42iNiKjgYNYx8e4empPE0P0uJQ5vAx0kgdbdJKDHXaBZhlol38u1rcLd1xEREjODm2EAn4ZEbjesKGSBXAzvRW5zZwZLp7nPfpXVN+8PK+VRrjew1DdvUr+cWK9T5LkYKUEewGvUlETjUHgMVRUh522tRIKG2Ib9h2VghXL4ctmYGVJ76d7zDaCan6ZrVHy2jETk0BXh23jI+Z//7QxBZ7pIWYu2TRkcPrwzKvfsoOze62iqMSNOxlD2P9k8UcyGX/d1gAYG3h1MbvT0YF0yjbxFGH2oBDhXhbybN2hp+1OowCJO2v5M57kWtJB2gMJDVIAH
 /Bf7fHj1
 DsIBWzcAJK/d0JEo5gFqGMIw5PE3jzYXMvUxMlKsNXplc0X4yz8G4hk3FD6+2Z288pDJQ8fEcF0627f8Txy1PWjIMZsW7zshY6f5nsLQaSVfQPcHkK9Bt68F3f8aPVz7cBhi6tbj+5PrHfxxGMvif5LHgdotl32yGOyz8UmPE5G+vC6qN808/tdtLxuT/Lckc4dO4Xh3xvfjduEEc2Gb9pE6TdUKrPHcRuG1CI/wI+a2MDOykC2ZfF5WWCnhixOmoAtQRnYQO14qR2LByuznuk+fuePcqFAaQ3wszY4z6bmj6iulSaud/Kv1TAyIVXTgELI7NyJ8RWgcuhCP5ENvw6f73nGdT/AVvHYTDaOPpUQRYAAuhAOYwjPP9d6jkuLQsfmc56jMSg875zlbdSA49BVMyMamWmUd3OWnO7kZeyE9M1zafdir0J3nhuLZlGztVhX/8b84X9kQ==
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
index 82c99c95ad85..a476e1006bf1 100644
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
+  size. Note that if the number of pages specified exceeds the VMA size then an
+  error will arise.
+
+If an error arises after ``init`` succeeded, the core unmaps the VMA, invoking
+``vm_ops->close`` if set, which is therefore the place to release any state
+that ``init`` established.

-- 
2.55.0


