Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A6A2C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20C146B0092; Thu, 17 Sep 2026 12:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BDD26B0093; Thu, 17 Sep 2026 12:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085886B009F; Thu, 17 Sep 2026 12:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1A2C6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:32:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A529A0453
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:32:12 +0000 (UTC)
X-FDA: 85223796504.14.2FBDD24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 911C6A000F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:32:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Em9Vcp7v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqpk9MXgaX25nS5Ys5rO6UCVR/iTsHvR4Kg11ITNpTs=;
	b=7PdCGJd//cFPpmi5+f2LdQkrhP5cvlOJOX5TcaRld1MSWqcEI0xX2pYu1B/gm07SiF3SuE
	fQhGCp2L1OSEAUlQsSHjX3FyN+mI1shYpj5korFFczhl4etmvwxqOTGTJ5H5qW8GwmtLZ9
	iCeNAOukmc2y0Hp4PxXNpb+Hmz/d3Hs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662730;
	b=3xSTq4BnY0RduCKqKI3OdSrX5kOGrGnZ1mOcnlLFa2ggTw74vd6JF83BRzTzxQQfaj95Rf
	3Rvej61mJIa9wL2ai2H2VFDB7Skg4ZiuCVtlCGeqMcXaMpfezGwNDCTJKltUbytFGMYwNU
	XOUaSj1Vk6dVydiUBLcB28wAiyZmO3g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Em9Vcp7v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13A56601F1;
	Thu, 17 Sep 2026 16:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F145F1F00898;
	Thu, 17 Sep 2026 16:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662729;
	bh=zqpk9MXgaX25nS5Ys5rO6UCVR/iTsHvR4Kg11ITNpTs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Em9Vcp7vsIS4Jn8qf/ahkPwaLGTBcJ8S5LIKDJMNWb3KRHsMyPmFX4JPiU7TvPOmF
	 +MrSzGz5nbDpirTrKKpT7f6veK5ZPsJ2sVnniUA2IYHo6fkoPifqJuSw6gsonsSdOk
	 qXJfQMLxAO1xfepbXhdfm+6hYk7pWgyENu3ZHr5AgPibg54dq2nQxPUic4WtiQZx5A
	 DwAUQEVEZXEwEOTOE62x/pD269SFWj0pYwkt33CXVoAPjv7oZfWr5BxshfaNUB250A
	 h9QMdMAmTMKLNhEYJLvTV4VhhkZ0P8xHGGUUAVCdZVEIt0VSeavBiKuRA5nUo2iTbx
	 bVHAAHQknK+jw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:27 +0100
Subject: [PATCH v3 18/40] scsi: sg: convert mmap hook to mmap_prepare and
 rework
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-18-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5937; i=ljs@kernel.org;
 h=from:subject:message-id; bh=HTYbod2OP3AjRPEv6Ph886TsUDFUWldGDo6PKBX7Wqs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB+MTmlykN749ErGgtLIbfJWW1wOmzJePeXSkp6a7
 iw7/7ZYRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACay7x3D/+Iwtu3lofl/9wnM
 1bQpCNefY17DevBw5pv01fefayU83s/wT5t1Z0mEyM2PT4XbeZ4tWbny13uNg/Ymxre/m73J9S3
 vZgMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 911C6A000F
X-Stat-Signature: f1a5qq6sndhwxbsppwabywaaipwudqjf
X-HE-Tag: 1789662730-241096
X-HE-Meta: U2FsdGVkX1/evhi7+7f7v2UryJ3XVUW+7ZbV10Qk/fZL7/usTg31WqIZsg0loL0nkzJkUSbG5IpAHL7dNRFeKjhqxV84soaQhn9G2/KkLL8FvHMYfaomDd2R0YpZgv7Xqm52CVIcfZP3xzQL7CazonoOe3L0Czi6XZxmrbJlXfS0X128RlSvyVvAp1OJUkDpMAeBX2hsWlrJeAwXD97ITdwrUZI2y+4kqd3IqYIiHXgcg/jOsIWnE1rBbX4HgRFSAwqKfwsIPpOHkiEkiFa0Hti8QIvLKVvuw/S8egBF2NJ4lXGLMm+l+2GDdpSDGTkvkIW+jqiNy2BKdHN4pGZxMSDuF5zNJYCkiAdaCRLgsOb0zhBkNsn3NJdU/KBJHmCD0EhO9rqUPvh8gRiWrDoyOT6e6hpFNgKuOL3In4O3VxGLLS5PE7zI5gHCQqLtZFw1VkVg/JzovHIs2D22rKnQpGLu9X8VwkvCXgbsrquNoAuWFo97u+agi6rrL0USgciiet5S3biQuwD3ENHqDUsHQsmdiKhK6tPnPiFM1sUq/ThULFf+0nMMeLR1tvYxN1Qgdhqp513FMw965C7wscBjrzxU8wwI9JhshSrkZ6t6BUVjcaPMn01oJe9DDd4QLxH9fFMyD2+Cz4/Q3rvdfz1p/hSq4UhGCNnKwGZUxSXj1vyVHz9qdrRrtoJ2u8YlyjZp4esLMbRnzWKvlvQJJEQ8F1Ccw6s9OiW4aXsyKRu0qXJj5pFvGn+kg/yxcc9sYXTP7JbOvHFEHrRRwtAVHptnwU+qYz+zCY/B/4DpaqJye6iHMADv1hVIR2r57ZpSll0Z4UnkrA+rgs4XsMUCw3ZP16TQYF0+c4G4i1I1lPqlOoGsUG1hef6QwspEk6A8xlhoR9RZRRUT8UPxqN7YuEy2BgPTY93YtWfuTJ67R2/6DOuICoun9+CA5rdin4gCVOxqOMBls5l4N6RyVLkRRI0
 1BNPQetl
 7caiDlUHSIV9awYMucwVeW5v8tN1lWAUSFISzYecab6ifJquJOvWoqGcYPKkm95dB15z/Sh6IucVP8iHUlBAFRpNpDI5w/Psw6xMNNgBTUEnmnt8NCmMDox2FSMEeF3UfOauN/iVvpGdEjvQwqKy9ivJJE9jhTbR4jm8rkXSUV/QrrQIl0G9GmMPLyqkJnJcDwOoVSuNohR9UjWpBdl915uSUOHAaTWsxKbuBllHAksaMb0YQUycpboTsjJmF1h6C1sWNgmml9MHIMRH5rXz/+oo/l4wV2gnpQMG3ChkI44PkWzJTjoMwSP3ApbjfQAUiZthVOLiwCP9SFGglG7IeUFGZj/RtUY0b7nhZAcyAv6gRe/nltaUqe96sq0pKjypL42tVzXw4qlwaam0otNtf1li9LW6wKssB1Kizc5r6DuXE7Vp36uN710KiO6s91I//QMGR5HIGZvJexSu1XIYb8dWUpNkh6M+KBalWalqjR56WS8jUsDt2z2x+94iuglY4CLocopZBWmqiZ8wmijjv98pgugHiJx0fSUF1cYDs29zP084lqSk/erZYtO4rKQLnxa95beXyO9mrznRFDJ88XnSzxKPw+UiVNc09BQEAt0Y8jBYswEmA/YbB4vsA7nbGaW1CQItB+l5N0Q7LiLBCq98qwTuE9iDCd69jgtl0j6bpxfQUWIqdU/rpkxGJ8qhKvmK1EO69ppPvDKFhpnQOdUnRzW1phPRX49qRCWZ1nDzNRIIyg4gHMNjyGIrGLEGQy+wHH1SvdKrZXx7w+8gEzaAQ1IZWkcgoY3+2owfEpCbtnAEQkegJKKkg2KoqMpA9/ERypXwOAzhIJfCDnL9B2PSxVs1L4J84rj/e1UZgqYkSW3Dzz7NqBSU3UKTByD/C8+oJf5FAMxB0zUAydrHxX2ioZZQXzIhenozRKScP8nHFMeFCtPoQXEbJ9BCk80OI/FP4Gk8Zrn7A/07EfGZyjLbyrP46
 UTkzaUgk
 wrLItJ0wJs7pMkSr13neSx/5VnZSD5WJSkiU5UxC2CAXIVigmHwm00/VtYjFnue9Hsmcyuo7mOFCZr98qo4t0naHV2RPyg4OcyLHJaKG5DIFGTuo4OxkQwixKPo3TfXVQbCSPr8l8wc7TiJMXJzINDUr88tAbYsd0etk/WZkV310aVO857yfjEVYhVeCrMkiHQLqNInjmIMYsAPWNV268HRe1Z0gvWRp0Dn6M4ovgHCOP7ISV90tsnlyehxhdtvEK2vVYhnAJ1T0Hlw9zu1X/I2TRjbeU0rzr79c4E9Tbcfh5Tz3iIZdFzWLBG57VnLYtXsKv2v2xsT+UJCrBKAzTudo0F8kyRLN+l8Aema1NhUpP5O9R+Jp6D1x045vNzVg16D5pVO/zBD5nBWZhxWQQHlIZMUVVSm0iFH87VdrkbDT6QpFr2vTsE6yFuK2U5EGrxiX21sINDIh6pcw+ixkSbfQ/mp9Sy+rtPMp+V0KnfltIy/Yn6FQbzWnZFWxT5PBXNhrJGVGDHH/YuSYBMArTf5WwPApuX9pn9Um4I2VMsfpYDpWgHFIl8ELeeGIzJXUB6UAAVEKZgtyR4GsyYydeJHjtHo1uDPDwYRWPdn5bEgi4fwDglmYXKMa+XHasNBNEypgo8WABhCqXHa0b2l3Ih3U2hIAUMcnrps5zc3DgwoqCtt3SfVjFProBv+hloHkHeQI0K2EiAxvlA3pbU2u/xQbePlAGbryiPFjx5gpvvoQLYVz3nODNP920i9bNhD0YSDzWJu8gYyH5zGoW3PE74rz1M+xGJQ5xMtYbq0m4prU1BWi20HgCoVDyCFsPcCtDkJAwAuwhEern8/8mz8rUQuQN570IN/QZQ/1uzRSHodquENZ3MO0oEa7oHxEKq11u4a8at/j5sFdPWt/2hDkP3o6QTb388+lCbswNTwPkHTTYE7Y4jd9xo3bvS+4+KnvvR+cjLv0BJPnK2d91QrsHhU52X9MY
 KljaV4AF
 jruvW4bRVXzDeUow/KQjTkR9drFEsiud9BiQWPymlTSvq0URRuJBV7yL+L/tAKtyrDC7TXApawsadKbCXtflCrr1hl/x5WlHouQ8efPIVwSGVvSPO/Mhkxd2VZQY32GK+WcoVS/qdzrIIx7qu9Mjf5x+hVWw6vlDfAunZ6i6rhL7nqJlmEPHrbC1jY+oIfmuWt/qr4qxSduGrTvy9UmxKVVCL4X5B2+ZxJSJwpMF7EDWzXzQfvjTTCSDOeY1IXu57xt9Bazibk1refM44Mdng41JVTPKo9nuBOz++ZbU75038C1sWwKsklg249+A4z3V6DZKUIMFxUcaEOTNm/uIsU5hJQpYNHsU0Az3iRlRYqEbXVTkppbVENuY/FdxDF2yyYD0ED8uzMwrMdaFi8wo7L2A2MxlqC9/VAIH+xG4fe07z8rJyP6CNlE0JNLKfPDBt9zClTMjnyErgEIIMPsapRt2e0alU1SFVVyK56ucfRx2UbSabUqJKfqvkstA7vhgKuUWBOjaeqMIjwMoby68cJ8eZAA3Kffr2J3keudMY2eDEZQ3dqUJ7oSYt2AaMUwBw5HQUxF5LjpjJNEOp8p8G9zxJYEXVN3H33rHLiEVfKZskejjxYn77P6OjVwZ6Yhyy3LX2ziwazZBSY8ulvd5DZZXPj+5EE91R6HDNFajd3whS7xRpHNohDfkZN/WbE4M9N/VTU0e69a89W78OrIzFHDlO81yL5xxbOxufaXV1cqBGSSoE1+yYDl0Sq8+Gcno7mzfMu3MdOkX+jOWE/+uvKG+umr1p73qny4ScmYGEe8lcwv6fmtilTCu7gbEM0Dmx6CkLnGlICEF7d6XiFXP/xE5teg/i+d1CwNs8djiuTTpQdIr0MV/UFBrtTmLQwgWe1pwXRr4tzdawiAH12xbiQUPjQqmMUnsNsa0DZ9MJuSITN0LDxZAPNvx8S1+pxO13yA5OALakpx/JifK0j3VR+Fot4/OZ
 saJ6ejAu
 D0ZHJBbMtiBYzVzgiW/T8JHL5awgDroBbzxpcdjX87ATuNUk1RHskvkpQMW0fxVBR5ks1cpOSPAzJBgmZ+OBXafAxn79Zc7wGyU+GYQQ4rMUxayqz3kVjvG0IB6FNOQS3azcYtSWn/eyzyw1oA+4COid90uKkjsJOkdhmmseLq/BDY0HshxC4pPSf1oZ3coH0TUHh/Yc49IIEaYosufdpDnSnMV6B+RB0wBE7LaL9Ok+wZmKO7lddAa2dVp3+ehpjS3UGboCrJLdo9JWdJIcsO8FSCByyKkPhFUo5NqUL8vrpDB2iuIO0g6sY8th7WmxdRkU0oR9hH6jf06QDSnWs0Zhq6tmGPchmxMnA5qEWvHAEQGTpb0meQAVLghcbrJemReJez7/yQpZZwpQPl3Swe91gGh3LVVZ7vlGzcqH8yxBAcAb1RD6yPJ6l7CycRNeANNwHu+UYKsg==
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


