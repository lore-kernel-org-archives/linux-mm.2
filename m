Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A696BC79FAE
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:20:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A46426B00A5; Tue,  8 Sep 2026 16:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1AA36B00A6; Tue,  8 Sep 2026 16:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90A4B6B00AA; Tue,  8 Sep 2026 16:20:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DFBB6B00A5
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:20:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCE4E120786
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:20:36 +0000 (UTC)
X-FDA: 85191712872.16.EAE41B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2371E80003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:20:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eteeMNKc;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898835;
	b=Mz+6Ab7P0KnJkTIBWKaEFIub/FlcptKLeWHJ3PYu7abvXwfsaCk/iU2zYa3JKcRugtayXB
	hl2IDitfsPceS2shwelkUOqD51w6iwWxtUAtGa25uBzVyOPr4MY/Q+9NHW8HZC0eA2Zvyq
	/lpiRoWQ+zIY2StXgunlXCIjOMuz0vE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eteeMNKc;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Y+9oL/ecFCyRQAjQwMJw2Dhtd7MvaAf0ZcM9wqOIa0=;
	b=kFWAhPy8Ne0p2QTOVTMmBVe5zTuNM1BID1AN1polcfPquvPP2eNw5mMgsz1OBPGIkPGujb
	T+dugnsGZbyJjLo/Ltrv/nnvWRpCGDgPvvdguNjDtzG4Mm5PcyVpnLMt/ukG3jQhhJ7+IC
	1in9lwZqsf7g+cTSmL9rTxOe+TNprv8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26421411DF;
	Tue,  8 Sep 2026 20:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D361F00A3A;
	Tue,  8 Sep 2026 20:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898834;
	bh=6Y+9oL/ecFCyRQAjQwMJw2Dhtd7MvaAf0ZcM9wqOIa0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eteeMNKc3bw5QkqTCjME8KE/Uo8s2RLyCENbyObJd2//uesYBzeHpd/cO37Et3mhn
	 thzmodv6/i2aGrGFSbw89amq+CWgseY/mmVtI0zmwvdreMnFrCbwqLNlue7sPdj1R7
	 Z34dWA2QwPoLDzixr3Eiz6+B4srecPcGlaJqf9wWYAfMosuMrbyKnTPTVnpq2XrCWo
	 bRGY31fGM141IHku+T4a34VBQe4FOHg1Rnf/hbwasgK2dPjZk3Ny60O/wZyZiUoop5
	 UeUj7G663kAFRujAPTaMXvmzB0Beg6DqPVIImfITZf6U8YRqwZGceyJzNvetmoKRbr
	 ul2q/MJvHIHkg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:42 +0100
Subject: [PATCH 38/39] mm/huge_memory: remove vma_is_special_huge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-38-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
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
 Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2897; i=ljs@kernel.org;
 h=from:subject:message-id; bh=eRGK0143iN6Vv+TT1St3Vl71ux9hqcMzpEC9J57eqcY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG7XWRi9RuG+pETo53V7Fhdk3mF2NtrLvDrokHWNq
 NkU90eLOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRroMM//0Lq+dITJUQzZ7w
 8MIdjYzvs/MkOc1yJn7osrnqlWQ/153hn4Ly5Es+Rp7THqc8Xm6hUqr3uH2hKr/mvG1pfRI7V7w
 J5AYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2371E80003
X-Stat-Signature: spspt5uxwfhxkceh93miw7qyrgfusw3c
X-Rspam-User: 
X-HE-Tag: 1788898834-222086
X-HE-Meta: U2FsdGVkX1/lfmeGMcW9VB7BL1o8HPaiylImmMHJEVZtFtEpr9Eg6m8oW+ksnDv59IPt1e+qR711HKNuFqco6k4n1i2/drmjxq0aTrU3Ku2a//BLnKnYUYpex5uZ3ksJpe8Inu3DunR0FLtMwGLjTSrDJJdaDj0/V8kwvbyjWQ5qK9qm4fk1Iyb32/NivCC4xEr58PF10KqwkZsnYwN+UxSjw1NfO+qTZ/VbPlHYo9QGxxZ+SU9sMubVwItp/Mq+pjYoeaamH65dTHwOx/eq8KH/EZwEDn3+1aOnqD4wJ1o1Sd2PMYyb58/70REs+3vkDHHVcrz8Fv6TzzZYqRYY86/gYx6uPktGfwGOYqz6Ih6PCKUnhY/gt/L8xrngOGbUP4TvZFo2mC9Ny8iar8TFht+H0sOaRgoas7q1lGQ0k/C+XkW/y4paKhoF350SJmj6d6cqa90Q6zflHcN84VzC9+LngpBg8ilh6c/qovHvN7OVKJ1anXSgckotQOSr0G5dKiGZSzJBzh/49BW0IetQiZiWlX+pmrcsFlBFyhqlXdah2ZUkr+sXwNWbLTqBPGitrLQelpp7f9KM4bPkBlLbMObe21QncTyBGtB976iv6BTO0oAgA0FiLxAOIa7sKC8Es/+vI3DnvG4oocSeXq2T4/WBNYVoKJzfloU3NNWTNiXmXWRzbqjgyZ5Uuegl8aYPRtVjugQsIkGQBdFfGA4WbpcYSESxiHDJ+o9TpcOtJuG7O11M31/tIObMdSSacnfas+WBo+2uNbQQFF577EDy7l4GeGyP2HCZd7ghy7eZtyd0E7/xvSBfjGnqo+pF62JAry2XbFzWb5+Zl6/eiPTxJj8vozK7fY8MH1ppkkubeHIHdktig2bpWeQZ8INImSEGCZkFjT8AL2z8I0gi/NmAusegFbyVq0yl/qarm9fUaDLGPBPqsVmknLFSB3dMiDO5GqWLPL1BxsC7ClBs4RK
 eXqxKrni
 GNbheaBI2MjywGDfYu89v3Mg4ZvghIhnZ53sQnglnOYO6oDdpgu0Kae9bkAHK2Od0ns0zY8JPD5DTe1gbChq+tfvmk8pZtEAcJ0oFRQFP7lwzYe1vasUjPyKGJV9kA6zD1pR5twYmCvWmxigbr8cPOw59pUdz2AnkyL4QVN7Uf2Lf9Rx+gpcdRch+7vZ8mRPZ5f+ewfJkpJP2T/yeaHOg8PA5e5lx5f5KeD7dgA34IzIW8lLJdzWiBv85PcCM3pUvJChXFsF7l1jwVKq1QBDQZWXBnj+cT0jayWds8wu/Fhm+U5pN4ksyDnck0uGlJlRY0c/tC2UvWW/Wh1VFh9fzmMW1hk7AaInwhrHS9BfSoBEia85KR8QwkvltPVW5OGP7gw4DFv8aa5qnB39JdDm6hEjC6YiofSUBjnEEjCP6U1PdVkg8CgZF2qoIlHANm+N5MOKTHiO5VmJiEySI8C6mfZIJx+Y5gi6T9G6F37w3FcOsWhWldR+nK4SBszVLJYxKocFOwJXd9YQkrNQCJneqX/17BZG5hdqWTkkOAUZRyQMZ7dNXY60hHdG4WdNR7sILNnIsYgMe2jCRzfM7gWrBz36xCG9yb01cZOkqw0+wRcy1/QXDJqB7Fg3sL2zHCWwcKm1a9sN62eOZ91gbQXgYrWwE9+gh2J1st+dL2OHfCcSEAQJaMGe+1TSYBKIhfxwH25EXf1r9XBHCKlxWy3tbaLKd4UiDrhD3DWd2NncYgPo1E2beop+GQ959JvEMczU44M4iEjutH0Jk6gjFX+prL5J9+sl/6mLPDbLxt9m9uOrHxFltzuk/ICzLptYvk1LebeO6GFZRA0eylDFIAec51FG7FWyfP3q0Typ2501McEeb9SX2uFRi8ca9pD9HypA2R7T2nMP9ge0cvVQEN2MmWXZTTRMV8roxrl0aGrfkqt5fZe25Z7E4e/XjyEhkclX+EBvF5e0FLJA8dLZbSxs8sKfFwLsp
 Gvx1VEPp
 CrFkHXL1KAJDW64b81ZmfD7vvCmnxhyDcjHPll2TzdYJsLag2oqh+QswMYJ/oIJisjHnrXLEtSciJrKjlOJpbxZji2dIKiZuAgTem3ICq3l6/ieJnekcxMHUTiL096ob8fi/H9vbs02EmJ0Bwj8GwVvGO7BeW4E1XQT5coz5YN+/hpwwxZ1yHZC2Y5GkBZ9pRwkATvmbGLHsRgk+QWAVbfFmFioGrKv/2avpbUvF8SoYgjEYMuqiEwf/I4s8L7P4XQ7pzwG3Wm9po0VI6ULs7JNi+/0D/vZAUP73ou9gzj6ASHDUZTjk6pOkVEy/a8c4UCcY5ogoyeY0CkT/4NwUvYv8jYOMmO5WC4yxpbO6hqDue6+7sryhDDPH6M4ab9u8C2SQRUh94cB2/Sw2LJM4fjgeLszIvpN24xeMbO/mOSTEuJeB5z2X5dt7dWmBIVpERq0bNwWylhhlIJBliYWs7Vae8UGjC3JoLmulmwhh+CnDUmmO3QQbAlNkPyw40nUYEfbo/nGothy79vUdDFqJKCim8et1K/kaQzc1tXX+ZF+z8iMv2gwnxKWU/Tm85mYvWsXmGSG6ZgE1aVjgCLkDas27VfKL1cgbwyNbvDx3Qu+yTb4o/YQhv5y1JfAf0KLcEGi9/5GYTeY67GwaWCOnPBHkEWVsqqq24GBVeK4vwZMHxsWXZaiXcOiMfTb6Gr/1SXH8OhdThPmzzRzJa6WeaYF5F/0z1a+c2uGuMB5DAnVQRK9o/f14hb0QMtxmgCW1FbtHyeebiPfzueqzyEztuK97sGA4ft4hRkWyUcP5HxxPdMpMlg1DuEoPriygLXktfsrsg9J68hTmi/s59/DDVNuLux+qcEW2nnIESI8emAhtM8W3JIzEETCOtCjX7yjGbetDXN1yEuf0qCOaO4KKFh8yI8ZnW23Pe3qMufPNd52w7JkT51tRgrN9d+o9jXjLF96QCHxlShq5qON1jm3oRIe7v9QFz
 v1s6AiJv
 LN5NdImlHpC/WRLSzIFNytply3ZFr7a1KOI/RFN3OdUnB531dQ0TcNVNt4n6+15TDp40T1v7WewZFLoNTP9L74EHrAxBAuOQ38d3B0cejNusuiJ3Qy1HjhtLdQfAV5hrOBqQZzwMg/gOiQkxSg287jaG9PH1bElXhVyvUJqt9n/k6auEQF/jb79BEjlIISKGA1vV/lGojQemiiaofYIfrn7dj8nj+u03nv7g4tVKWUqzaBrB82FoAIuzrPaJBbnZYFw/o1A0ZQrRpHxSu4E4YqIht5cWhF2Jo5OfRffmaJhj2+scRwxsF4YVrvvIGz+RBaygoIvkzUVO9bqQsTHCgJQJEERW8f3Tr+Z8+HD1Xb7o5w4PbqQlll4+YrAAVBTyx8IvZmC+piu4FS/YQHwZjOvrVx+aMA0qAdg78yVTHf9APR5vN0mvm7Fa3W4Rlkja/Qrlli0W9VTnEUMJVzMNAK/RrLJAQEubTrncbCltJPJhPxXV171LC1s3eDzEEWN5iXW0HQyLASzu6xxqzjVAikhOrHRtxfRVFBJcNwCeiSa/QKaImJBe92q3mTnOSZpdklowc5vi2ibkUR5PWPv1jXHKXfKGWWWi8gn66xbTktdo55AmmJZMG45p5ISaPUDYV2xLUalYgWM267VBK1+feOmUzcnFQ7cjsP7v9rHu78qAXCGhwJBIqXHUbkhRfAWtzbkcsZCIMOlYI7lMePlMLqXZAEYZlH4L54HduyYVOQB8ivubpANYnhY3aIG/5iXMPtwiH2qvylJz+0oM/qjcAR5AGtQ2NjZ+tiK8b7IwkcxhrYmIGsqx0PXzsOU0+0jBul15foNRlOkd1ggNN1x2/cqAPyrWR5vV/MmGg9DVz3IzdHvLzwY18OErodhSkbTPjLtgn52OTrxCg3oBhFXRuptzHbEqDkAemNAfSYbF7gWqis9U1dcfAW+vmY0L9aYjfS2MVMPISEDG56BXSTWiHoVSdijY7
 QnB555XX
 78DtD0AvXkfbtiVTojGL+ZyHmcGCcCh/DyAF2g/Pw66IHRFVSUL8dr/qXZp2j4E9EG7FmLEeJdhU2wnj3mZw/JHShLXqImHWvWHxVAabkSIABgW50NwkLd20Pa+AfgGGW+CrKK8TTuX3FDco8TMswentVbxjczjbk3yyZo7Orma/nzFaKVXD5MBaV9LTjOHeEPI/XXsVV8xUtv4OsiIbM2EbMt7LzkJv7cwI40xlcfeYFroT96wyaF5Q1uo1hX7ueMkEFEzArQc0VlXyxKXOnpNkVLht6Jh+wCI6pibVmT2Chmr0XZPq2YXTsF+9B3OFlO9UKvcB+13w0PiQjiF8K3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is a kernel-owned mapping),
but with a DAX carve-out.

DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no longer
required.

Therefore test for vma_is_kernel_owned() instead and also drop the
VMA_IO_BIT check, as it is now redundant since it is enforced that only
kernel-owned mappings can set this flag.

This also eliminates another overloaded use of 'special' within mm.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index cf6c50e531f5..1ec1cd970ce6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -110,14 +110,6 @@ static inline bool file_thp_enabled(const struct vm_area_struct *vma)
 	return S_ISREG(inode->i_mode);
 }
 
-/* If returns true, we are unable to access the VMA's folios. */
-static bool vma_is_special_huge(const struct vm_area_struct *vma)
-{
-	if (vma_is_dax(vma))
-		return false;
-	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
-}
-
 static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
 		enum tva_type type)
 {
@@ -192,7 +184,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	/* Check the intersection of requested and supported orders. */
 	if (vma_is_anonymous(vma))
 		supported_orders = THP_ORDERS_ALL_ANON;
-	else if (vma_is_dax(vma) || vma_is_special_huge(vma))
+	else if (vma_is_dax(vma) || vma_is_kernel_owned(vma))
 		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
@@ -3065,7 +3057,7 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
-	if (vma_is_special_huge(vma)) {
+	if (vma_is_kernel_owned(vma)) {
 		spin_unlock(ptl);
 		/* No zero page support yet */
 	} else {
@@ -3221,7 +3213,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
-		if (vma_is_special_huge(vma))
+		if (vma_is_kernel_owned(vma))
 			return;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
@@ -4750,9 +4742,7 @@ static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct *vma)
 {
 	if (vma_is_dax(vma))
 		return true;
-	if (vma_is_special_huge(vma))
-		return true;
-	if (vma_test(vma, VMA_IO_BIT))
+	if (vma_is_kernel_owned(vma))
 		return true;
 	if (vma_is_hugetlb(vma))
 		return true;

-- 
2.55.0


