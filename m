Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B22C982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59796B0099; Thu, 17 Sep 2026 12:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09976B009D; Thu, 17 Sep 2026 12:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D3236B009F; Thu, 17 Sep 2026 12:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66D0B6B0099
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:31:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7D0F1A040B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:31:11 +0000 (UTC)
X-FDA: 85223793942.09.DD5AB18
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id DEF171C0008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:31:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V0PXlPCx;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L7jaJ3XNIQiKLT5qkSlMCmmbkCuTcTW6Guk4wu+FJrg=;
	b=OKV+5UoixJI9yMnuVAe0RNyLpUnoDqNf6/HbuQLZtRa8BFfYWu7qZ9PiD/VFi8Gys/goZt
	oFqrE6PJnGRs90zTfPbR/AR8utHxAM1Cfm/PZxyFJDtRc1YLjfTfAjmJhroNV/61e3bTco
	+7LuJqzhHNnvdOmgMy0M8+cYoON9lBc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662669;
	b=IaKqLb5wqhExa8V7zN6iWE7lwSGTXCrFSbWZ7XksGosnbnDcNPx/WdknVdpdxCnU4vlzSs
	/O/f20xgaL+wuNL22TJRQtaAtZ1VybK54EwvdjXthAlnpz3GKYllH9ZvbpVGfwGSrmXJ8q
	8ZBp0Ed5u7NQjjQ/Fv9tRqyzDN5vJHk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V0PXlPCx;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 689DE601F1;
	Thu, 17 Sep 2026 16:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474621F00898;
	Thu, 17 Sep 2026 16:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662669;
	bh=L7jaJ3XNIQiKLT5qkSlMCmmbkCuTcTW6Guk4wu+FJrg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=V0PXlPCx7005iUwQIzRn8WrFZyyFxtVLov03zt/j4Cb9KmBmrLJgrmIpFAyfapLrd
	 H+8UUkC5mv9ThnEPdrIeBvRjIZCRkR6q8+DWj+26jr/U/1bc099Dt09f3XbstGf0tB
	 GPF/qledlC6JuLnn7ZKiMvsnyi5RO8rzGZHKayPV0lImzjxMdDbwLfhcGBqXR6uGVW
	 sVoxSfdhF2FyDVHTK+GQKY24DJ87K2yGos/VWGWHmcjL23ivX7hPCN7F87RaumZo8V
	 n08M5BJ2yk7qRbIrAGbhKLJVnMQk6AD7IM19ETyOl35+W21+u+ROFzCF9UfcNa1wD3
	 hUJk1gDPbvIzQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:25 +0100
Subject: [PATCH v3 16/40] mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT
 if kernel-owned
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-16-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2269; i=ljs@kernel.org;
 h=from:subject:message-id; bh=AQdN68/spfXtpTeKBaZ+Me0gdfgYIcDdx+d6akTD8vU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB+U/XmtbGsK473bjdP6GHabnKk7IeVwVcs4JsDOL
 zjlgPHCjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExkki3DP3WRy9bveDdY/uc7
 LPb+sUuFZsGHpirJ2GS33v1dZbxT9BgZttZGce3vv72WZ5veMwbrRweunnzCVMCUcfVzwm2X7hc
 tjAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DEF171C0008
X-Stat-Signature: jqktzzj3d9ba4hf4mzzhizms14gsdrnr
X-Rspam-User: 
X-HE-Tag: 1789662669-188292
X-HE-Meta: U2FsdGVkX18o3uXDTT3RHV2dxu1gRx/T5VJYBuH0dSHXwWDWl56KaUbNL3c4yolg1OrjFEHizoIpxHFETdaMHdPfRjESRBk25rCc1jPRg7S5U0UFxNTbJ4kJCTJ8u4uYmvobxcG//+kJr49m9Tjvprtbf8BcGNN4UZyOSzTwDYOkabC6gaEz++b4LoQ8dyrEubMjUJKQxg2vLXkAbk7Zwls1zYVcAEL51lIJUr3yGi1xexXFMoC7Gy+ApgkC8PVWz4Z9NnTug8JME/6Ah5mdjBtPCTHHADgfnOSxtHVXhsgkbtL/i/E6EhHkuw6dV/ZOxnVMI79WSKeaWgh9484fJdh5cD2PMIZ3Z+xRlE89oS3E51B7vXXZGoyHsYbzZAJdVss4e0f8nMmZOhIadCcIJOyclT/fq0LmU5LeZqtnkLhPkKpCPm65iIOCAvbZ41jm52PPFSsf7TP/3oF2SevhQ8pcNrEWI0cdVVWtKXf6XUgf2Ngo4fRSPGxXPHRpflVVx1RZns+NuylSc7lUAgDK7IM3207rrYYVuhWV0zdDMrDQeec3bCNchl4ws4nICpYpecqUJIGN4zXZXG+MK4z3xTxPG61zLxCYamUpLds7MvoJMoaasbUZoS3EbROPXP2Sz8YJck65nAnr6CTMwhSnL2ruSQEVWYWrjV6P5Umou4vroOcnYfH8mBlOl/ff9o/h32/JVp6kEKb8b1NH6rOGR/MKGbU6+05+g+9dYVoALIlJ1zsH2WissPpzup4eqgtqXxt/bCvatCpSX9t11ekKvwXbM2NTpfdzqK4P5znN3dxf8jB5SsMrGV0j9My99Ux2Z2ZeSnt/y1gOXtocCw/ZzAz2ofBn9NlizAW9KjaU40eyKsXCiGcWu3M4k/gw9iCNG+YQ17uNQhJCJg/6CGOen0bKQG6s3vd+5QtOU24HhdtH+iOFKZZkl4qq9g9v9VxOnQPnAXRd2qsou8P+YYQ
 si/pqZS+
 mfGQ/Y8sD5gLgL2pEHoAgOE1a8Fer2OsHCV85lYKe0hGtFXGyLbCOcKOY7eTohwJYK6Lr8X2tqqZ6Fi5oz5KPlLN98WbA9LRBJhC9RR4YDaPq0PBipVvN8rNpqusf5nxFubQeHgWJ0//qyAlCD1HHmQDF/nmLvyPAjZAmhg0ntH2UPhlB0WsfBIHZ1DcBvhbz65W67Kz4ZF8OQk+/lNLxYobkXARhvmTyluFs/CRg3dvlw2t8TeXNA7NqJcqB0fG6l4CBRxMB3Ua/G7ISK8bqQL5/gReoxZOUiNpH7Mi3qk7xQIqzMOYsVdXR5ULxS/8kvVuJvgeqvyD8joumMBJ7gjvjArfvCx1ER+auG6WKFCo5Y8Z7Ci//Rd408xtcMeLnJkZ4IQqtfhzB5meA9PQgR2jo6VbU85aehytSY/NEqx4D5YXgtFllN5gNKmi7UAzzKrjK22l2x0VjoeZVgVJUupH3jy4/2uVg/e2ajbc5p/hy5FzrxK+8yMNhG4lBBAsR8ejatZ2KbYdGgP3fSUb6jaGi3s/H9qPKnkyLc+lRq/20DvT0azROnqa768p08ik9LaR6FqWr0902a2KmHvIcBEDuspGiwh1UIeNDCcQPVUroUb3XbHjF3uf7+41wpTuOGItOStOrnE1LDC7S7ESSdlVhdxLQ2oY4cWn1kjix+iyJSv4DxxGAdSeByyOU073OcqwIQnx451nLCiPRVbVnMjMbmBNKKy+zp7jA+6GKacdKlOPPQlziPWQyPSFTzltMil2zcDGpGlY7KXh3g17OMYHo5f9znHOOA28Hlph2+LKniuzKUnKdy5AAe5ps0y83aXGmflRSCODeZFHakeQHfLdUz3Bgh7afF0pvjRaCcuEyG3kX8BqmgODEqFneaAofAR0zoxuRQK7EeJEIS7nzZa+jGyRTWJajxXSmIETs9maM7lvNAT2sbxyGSxcUXYlwtTdHgjB9W0sx8uPTXXT7JQhzx+HG
 Q+IdS9BJ
 aZP50DkUG+7eIqV+b4DpERpZtnFNg/M0g8NFyxjUWImIuWuL9M3zh7BUbKzJLpKP5iKz13pU10vXWgWsY5nS2nB5C1gzK5HZZnti461yZCPXtxjkIl6EMInx2rfY1Ib4Ht3XDCK/LVF8pZNC452OyxGWd4dEhmNqUoGTI45nA5h8PDgpgrfo5RWWpFj5/RKoGQJZfEu36QqhIl16M/kgYXS0JQXU2jEg0jytt5aB4QnxOhoRQSzMRSbfezzfVN6w79kyDw593g4LSx8OUYT2vCU0Id4e6ruUSZHEaeA06vZ9pnwHjJRbrXzwRjS2lYSsPLn0czyOFxkZNEdaJZsTeT6tGssn7M9UlamvleiJltjqJDVt6Mwm2oY08srMHarONHM3Qs3A5cfs7EPOwD0871rjdaemSipsVNCNByv216TIzji9ba4QzmS/6FsEtx1ydY1hzy5siTshHnPe0v+Fz+1QVdizTs42VHnHS45ST2xAbHldjRS8bwMEVS9x3qTT60r3B5U8xrPTRvqwcngite0eoAWbQsRl80K4RS+img6dMtbV0opBoFyQsMeERIiHc7o6rbJaaQcYsZZnzGhZAzlfLjq0hebpWOW9G3YakS4ego2ZyuNAMoKG9soIRS0VBKH7/bGn41u8+KcA9FoEXqyo3HDg7ua9z8ge1yt8OSDue1WtfDvR5UgSRG6oRLHVJeRhl/sActnZ3NeSPmDjyLnIzucGJWkLuSWmWIpIZsqBpY2Jw/6WrVx79cV+d6g3IK/J/ByzLRg6dsKS0ajUYCyEWSOtszMBAYdnDYOzlzz1FzZ4X9ts/OBcgkFc4GlyPLAk4C0LfDPoFAgmi3gi8nhL8lDotdmhRj1q0AY93Yho3wgkg7MgC7QPZhYuT3j/IvOGMuwOsCuMJAyUJ76Lfe/8Wl/Big60oKBOlas8A/2c2LgXeCbWfMTnP1t6vgre8iPXWs35pErKofMlvxv0Ov0dBA22V
 jy7+ffiq
 xgDdYYsHw2S0cexbQRE0A+e3CO6+w4upqSPfg/vd/EDTY203he7goeJYhw82wQ6TUupvNcS2sU5xLeIBtxq/O9r3UB5XXxRqqQpYCRsapRE6BvLd541eOoggxLL+Gv35Bd1SGZoGzIcbJNnuWOxOiW9nUpJ9wIOnQp6VDTvvTjX0JFBzDxHy7cvULxB2nZ3VaDUmy36R8B2fqEKbclDR2MkVZsy3ydfYQBLudZofK598SzBlc2rHQ1Q3GfTp5YOyed0aT0XxlRdyG9l51MfnRxxuRYJzKNOGV/89jH4ZdLffrBhTVNajUiCARUINDZyTFfc4KZBGEttiT2YeRS+Cjm09foZl5jAgpK5uGyiKgWFXvwcWsYRsqhLkPYnaJpgJoVn7RPBfjiuk4IDnV9QA3BFagZhkrrDEwyYHM43pLnELcjyM4kmytzj5ianTkCUNUORf7vLtVjK8H1ilR0SXLKLzMpWJaTNbTAWLLwRAjrJZLjN+R9Qykkhrb0x45YkBQ0MewXJcC3dKS75OIGDvfw7HTbjZcGXDwT18Z9AKQwlLP2HehdAyDDvkeo3tim+XRKfKl6JqaowCRA9SlVIli6y1atqTwzac3QrtjSCuCaBBpGmNYcgK/pOSat/j4iH1pu7hu82sAhpFWc6iPwB9uXsrErM+9uCn4BzBfyQg+k1uDkVc/THKu+vzBfQqY12vT5Ot2p/BAX/mKPeTtY/NLJ2WLgIz931+O6+JQ2DszGvDXfWp3uvwwFOFaOjqEgI6GvVPjRvjaU3UKs1XbG2q5Z80/YEDWALfRgpezpgHBBxQVietzwABu5yVOWQdDOUICF99k6066qvdnMLL6g5OFvzp+r7tHNayDF0yDnS0HllEu6cUAZES/OAjw+F9dMsnCF05lsYyJz/RYpJm97EkB3aGOS1wE0x314lZhF7UHVALQFy5pPaLYfg1CS0pcf9iBopjetDjqwG6l5saalO3x/FmzaZFL
 1ZsW0pp5
 WjYxjYYkEtuOPmGyW43BKevxsySVVvlTfPwUJI5kCCKfp2/dsYhjn7EDGMAEVxHPXkr8cPkhB274xQ34vhPoNTMmrqMK+knLo+P7ZVtJjHcYTzKmqoDEbmXLDTJI7gyobfSO73OZmuTmhe24FHj7aOC0/TJhuvmxu8ZNfwo4gYSicNreTJHQO948aBtuPkTsrdukM4dIDqmK0ugnfOvUIz5XvKsKtfNxHel9Co8VDJJOIlVoYw1Ik2pA/N1DLkH4z+V0zKgAhwUTRuEoN548K3oQGh96ZiwZzV0yjuqSJwkEsiYQLP4Cf6Vy/JpQS4g9E37o+rZRry03onXrDYMP/u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is if
the underlying file is itself read-only.

This means that mprotect() cannot mark a shared mapping of a read-only file
as read/write, as doing so would violate the read only attribute, and
permit writes.

In general, we do not want file systems to be able to do this for
read/write files.

Doing so would violate fundamental user expectation of file attributes and
likely break userspace.

However, drivers pose a tricky problem here - the /dev/xxx file may be
read/write but provide access to a resource which is fundamentally
read-only.

Therefore we must allow drivers to be able to clear VMA_MAYWRITE_BIT.

To achieve both of these things, restrict this ability to kernel-owned
mappings as identified by vma_flags_is_kernel_owned().

This constrains this ability to drivers which own the mapping's contents,
whether memory-mapped I/O, kernel-allocated pages, or ordinary pages they
map themselves, and so define its semantics.

Every in-tree mmap hook which clears VMA_MAYWRITE_BIT, some twenty sites
across drivers, filesystems and bpf, establishes a kernel-owned mapping,
with usbmon and the ALSA PCM status page converted earlier in this series
to do so.

Note that drivers may, if they do not gate on VMA_SHARED_BIT, be able to
disable MAP_PRIVATE-file-backed mapping CoW semantics.

This is perhaps not always intended, but we retain this capacity to
maintain existing behaviour.

As all drivers which clear VMA_MAYWRITE_BIT establish kernel-owned
mappings, no functional change is intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index 62f2ce1ad5a1..1dec10946918 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2795,6 +2795,11 @@ static int mmap_validate(unsigned long prev_start, unsigned long prev_end,
 	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
 		return -EINVAL;
 
+	/* Only kernel-owned mappings may clear VMA_MAYWRITE_BIT. */
+	if (!vma_flags_is_kernel_owned(curr_flags) &&
+	    WARN_ON_ONCE(was_maywrite && !is_maywrite))
+		return -EINVAL;
+
 	return mmap_validate_vma_flags(curr_flags);
 }
 

-- 
2.55.0


