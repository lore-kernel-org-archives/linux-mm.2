Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA6A0C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 09:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8A596B0092; Fri, 25 Sep 2026 05:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14266B0093; Fri, 25 Sep 2026 05:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB616B0095; Fri, 25 Sep 2026 05:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A41E16B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:55:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B31BC05B6
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:55:35 +0000 (UTC)
X-FDA: 85251827430.10.A3F7C40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 91D9B1C0002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:55:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HxJQcEvn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790330133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wHcL5jPNS47s6Ul8XnEo1uFsA8Y0TKv8vyd/Iuc4jW8=;
	b=UKPIW1YKYpNwwsdgki8Sz8N1XsKlosmdVCsG8Fhssoxj8sCgxQ6z6zjGxQkot+IlBrHI05
	ed9EXeh0VVpBfhdGEKWjT3JqGmG9b0ml07MoIbu+oLOMhQxETG0izn4w+8nJNOHWFccyUs
	epqZBXYOrMTuLa5JRQkHG0OTDfqAEQM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HxJQcEvn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790330133;
	b=l5e5oW+LunH0Qi6RJvtvkBw6wRxT1Hb33ANtKBItEvvByLBtsE/fuHAscawpsk1zR8Do+G
	hIZaAOUy/iEMjoi/5i83SaAWIMLUquy6EOwNxJH6/RwbejQ5TH81xpsaSTykaR6gWsTxpU
	1JWKdYhhak4PHEwK/VURYypQCl4UAw8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD8AF4067F;
	Fri, 25 Sep 2026 09:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C76A1F000FF;
	Fri, 25 Sep 2026 09:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790330132;
	bh=wHcL5jPNS47s6Ul8XnEo1uFsA8Y0TKv8vyd/Iuc4jW8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HxJQcEvnuhUOHH3Z6mzmWye1CE1PjDtpVrPBVFbcNDGyG6yBkjOShg1wXTRxmQKyc
	 TCJMHEkTxA8Sxw4HyLR7LdXQhRJb+9udY3QgV8ET7cug6AZBPLxgIFx/TdmYGQ8bVU
	 ptEgwP56FVQ2pJrDbYSWaP8xyRORQKPPWrshPWAAjxwWnAwT2YIoJgfyo9wv4EO7c3
	 7ozDd+omlnSWJmwSq3s1563JOKXMeNxa13jAxu5Ee20miDdmPGzcEIeZWGgnBBy5y6
	 eWzAFHQy56s+qgvvgTG8xUGQUmf5tQzyaZcP9CgdenUpWl9R2UycwCgDON1sf75KvU
	 KkanjhxFaUGcw==
Date: Fri, 25 Sep 2026 10:55:01 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 05/40] mm/vma: ensure mmap_prepare doesn't set actions
 on a mergeable vma
Message-ID: <arZE4aXD0yIbXVFU@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
 <DLNSM8R8JS9A.1850RMXAG9NSR@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLNSM8R8JS9A.1850RMXAG9NSR@nvidia.com>
X-Rspamd-Queue-Id: 91D9B1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: goik1af3f69cskx4nz7jmdnkmhy7sa46
X-HE-Tag: 1790330133-725055
X-HE-Meta: U2FsdGVkX18jhvW3f+B6MgI2qrjdb+N/KHdxQCusfI2O0iw2VDMlfEooLVJOQ0johhFLMotPtPqAalvSwQlh3i//VjU4sf0dQ53HrNitv2EOSKMkrqryYiHtMND1XNFhXYe67KRJi2o2ANYYwUqIgFWM9Tdi92u/fs3DQWCR4e6mu7O2I1frUR6mEn/Nx5G0R5L1eKfqd2QhNcHFDS1a7+N2dXE9lrmGQkNyeeIA9ETuvicVMWmukSrmEwE7oQBAcsdA8qb+CZqnVnKhYvAaqOdTWylEb88jSGB74fIaPNuxTdzApLU2juxWc2g1mzuC/SxyOBKkEqq/5XyHP5rIj26nICAzMapQNCTDYY04nBSSa7v13MBfmWxicnOo3AXwvhqZq6QNlJK1XKqkNOOeKt3Smq8u8VpGOVLr9F2l/eK7It68AUmHmNDlzJ/flg+4ShS7q77IUo4QM1xEblrKW4p5JdAa6jrw2jJQx6LNXTjQgaYFh4GLfm9crp4GTeRubC61fxROios5EeAZHDRzcSXVG6pE1hUpI8V+9IKrLXXOwMhvSv3ZJfNZSBtzJM2PwCCY/9oTQ7Ws+LZpU6bXr0kKNty6WBQIkuWdO/z4TdZ85pk/hGmFIUBfkiqW2KI22cJoOYL3Jb66r5TEIlFLu3tLAwrKJcTFbzaX6x8Oz3oAvtEZDrMDB9wEA1tetCGdldGfXMG/72tax4qF6LgYQ2hfCLs3+v8uyNgS5hZAaHR0ysz7uV3dJI9LOWwMBm/95st+uKAjbe5ra90pHQE0OJQfnAiMTMUuGIaKKtRBkj3kHwiZQNxs6ZwZ8GPjwSKqsTfodyg0ctB+D2xm6WhhtZRDt4c565MKwuWxgEh9m4eL7i7uWK6JNsKgRoKCD3ZLJKG0Fr8GfvCU4IMDJtgR/RbqhGnSZLu2Hj2JOchJa+qqoj4xWtCkmgKLa/ycHO3c7xBJuMHdRpm2tBZc3ay
 +h9XT1Sa
 71TK98z29NvnhGIokHNQZddiZaRiIo3wP7QFNx/WqHHlMtb996MHLH7seyOMBhQfraRWPYG1AgZBocgwYGO4zAjCYp3ZxV6K30pOgPbEi+XVaZBUk5eOoUdQZ5MiLEEj6BwSNiXb2sY4mT0ydFxkQQvHRKbj/EHuSG8mT5f1KLS3hnBFiP5XpuARMS/AKRZl1VlpOH2oN7MnmpNeEBY5hUeILRhHMAGNfJI9wN9V1ZVxbbcKcsP2cLiFw1I7plWprhif2U1lCZUgIxCpXcV85jVMMFb6YHAZE0dunbr1YSWSuq/Wsh4PZ78vhkdTbfK3tWUMY4Zm7qG3HP4IsPY1Rg4Lb+SAHKu9KMrzI7/b6VmnRwzZSr3W+6GsJK2P253QddctuPDO+ONd2Fp7Gw3v2tMP2K+E5ID4Jeq7rQua5fER08glfW8Z++e5EL97or61sprShcu0TyBNoJTLZGhxvXRNZLRULXVXGUPDwRaumxhAsIBIIJZQt0SfSju+1DBlZYJ2SXPaFqd4YPTLzGzdLls73uxBuPovsJe3PEhOp6338Ri7EDlxil8x0orshy8Mx+2MtTbNLwRW+ZFI4dn7kXtAEmp7Ju0mMmhl4xZYma04jyOsVhvCstzg1FHwJTOJ56EDUcvbVKnBKZoZBmvlwzV+w8cmmkiCRqaDnZLz/Nnmviatso+gx1w/Fo/4htbAVbFlYXEdhCZ8JQLn5ZYwQe2hnEQeEkkKCnlzgq/4IqX3ngzWymSqEL9Zuxtcb0yf88cI5Me5kXFVkn0rgNLZXmgjoryiVk1SsdXroM/UzFpPyTmWXKYb7Z2CrLHvmraenGuQQ3yD0+yRibhpzeFDDrgwWQVqvQNlCyOV8CzUIr0/d8pE8ld/oM342buPu8x33bguWOponbjRaVhpd6vSSXVN5GBgJesNyJvm1TJR985FLfBS5ScP+/bgerEeUDcGl2CL0sTouDuH4Qkbu2mXjHeFZ27Ww
 XQbo+4rT
 hgUkjsMMZZeWwm5IY1vEy+8ftECqgbJAP0pbhp0NoxHogHgPvmL84+wlEcNHASUPOBmjEWOECZLuwbnDTQ9TnRJSAH+2bjMgcWnfG/G7V9MJknFGJxpVm29mlHA6vLoHcFyrDp3eYKsU7rYQ3ZTwuIU9UiP9tqyBZ9g7yTOLczpRqldhuajTlvOUx2sOhT3dDy1d1NxBZrvkO6R2kmOJBdGRM5v7z7qcXWoFVr7i8URYBoacLnivuHea8iWTGS3EdEEWQBgHsT5YsGHq7VAuJvd0uz9UOOzumZ3kR9HYcZl8hfi10a3odvJm6c0EiCTWpWXggMFd7fS+1LybSUdywlbKZj5cJPuwAoGAruVLrM30JMxS/WdO8R7jv5Jn4nfoBrMt5wuoE8jnKfGB+NUA3mgzeDbNE2dndnHZygGUiuA5kNHh/N6EaF2IhO829i2bs4+cgsu2p98WyAMhXTHByy4F+LY6OclF2IjDles65fsh067LMoj5fdNwzOrNxozRoiVh7Qkz0CFW8PH1dEWx0M+4POvKGxeYqqw18hOm6ariuwqWWZWkPdwzKwclJrIz42VsLfmoorgnjf6Ag0cosi4NFyeq/4bJeUwMXGXLm1o/NKg7/pMFZbg4wMw8U4zR/Vt7XpVTbLLC3aXqeyQoebbOhd3/49GyJozqBB63/pe/N99VOlp7tfh8QiOu8IAmaAhoBV7eHy0DLqbfepMTB0WykCRg51J6gXpPEO04cWTZACiTRJ0zeH0sKTKYhabWsJyQfBCRV25n4qsRTZV4I6NkNIEryRLUiv/qRohPVEtXexkXEcS4KplRQVXNr6VXL+xC5BsaNdx8+9T2PnyAcg1cZth5fEz6gnCjohEAOJQ+YzHVONcxf5lDYreb17ZKNuKeAc89h9M1EldMTU+6VCLlJrzoSktguNT+ppGpq/59BZe/XNc5epFf3MefQ+BlJB248WbtlrT+df+p9EcwKM9IYSYuU
 NPHMyASG
 p/Reai3TT8xwuy/hkxRX2mxH/0No9PBnEz+aUyVg72zhHJas517+d00BzW7GSS0XIfh8HiTmdDfZo31cTlmUfLJK2a8JpajwEdNs3XX/BWRU4/c0gd3w1mDeCugbNe94CZAx3O/bsaqf/xQ0GdMtiIKeZIspOCk6k0nyRg3zsbvPtnc13ghvhTEe1WfFjaqAxxY1XfIkjwrq0VOPbjqq64Crqzl3xJ2uHF3C3dA/hu/Q+aXw2H0r6BXhZyKXpIqbUDa/B7M0oSSSQoAo3jNfIumuGqOM8flaAJY3pDIx7tOVkDlxDx4/xAjOHYXlRAE+p8pEdPpJ2/n9c4RD5RojY1+bsgRrY9Ass5CqYEp9pvsacBA8dJTerL93g0UbgiHtNXQtGd5Yg78KB9DTdHS622eUnZmHYMcfzgaWKkoZr5FuskcgnDX/FzXhaNNkGq7Shy8s0lQy5s+imSzrVJ17bEARqHZ4alW8cajJbE/KhLBaSGf3a6RIEnucWlmRZbKqskhWmaxPCMo5hJHfpqbmL1BmGyHylhCh3uxH0xxBbIhWU1fzoSNm3Bx0DN5Z96/vpkBSYjX6DhJEwX9RofhB4+3+5Ewtg/SKIu9DDF0uVbILxc1EDpe8GX8ns6XrneuEmEuRGWvZPPbRoz3GicdGy3asvDsxoGeBIdf8kK36xdAi7C+pEEQsfWc+84ofXBy6biGQa3iWltDB97CXwaQ/yIDOYXX6RsoZhFoZkf1cZdhkEwUR5QYeWx6CnVYdulbib6PtpPXNRDj/fUrW+V2pf1LTcZZH7X1gqOMx7TkBGi++RWwnD+bDem1PZUq0QSnyUYHv3z6laEklMU3fcQyoU9YxqIr+yST08cW06VjdJH4zkLOIFekpDz9cTigYppUt+Qec9c/sG0ycgWEx96LZQA5LhFHAW14uXinZwccoqy8mwgFrL5fFEG1N73udZ+yIbJoN4dZBpTRpM9P2dh1eeBv2jwS2j
 A1/EUKQe
 i5FJP9bBlffT3ElyHZaLl8ODzdmiK1Ia1xhpRG7UySWnL76CwV/y9YN0HsA17bdyasyfpoGBEStjyrmSwhfU+CzPAq03OioH6hN28wdbjozCj7/XiBCIcqZcVW74YnMEDwTa+Gi49WiZeReIuv2yiPTJsSxmhfvSsCv09OzXMyCCQ0BsOxpG233M4x/Fw0zEopUsHXfZ14e8mH/ftAhIOA8BH23+IYpzqJFeT2WMsL+TIyj5yc+TVmszTc3WCr+kNFWX8c8KGdSoCab6lxN8jfpG++nuuCDj6p5YodYD4VxdC5frmZVW6XWuMaSHsEuuPqzh5pRjIFRjuXuqKLi12+k2Yo6EzZ1tbbHWgmDkHLgJdAgbel5xH+tQiIrZuSJZswTeveXexFRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 03:28:10PM -0400, Zi Yan wrote:
> On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> > When a user requests an mmap_action be performed in mmap_prepare, this
> > involves populating the VMA range with data.
> >
> > However, if the VMA is mergeable, it might then mistakenly be merged with
> > another VMA without having populated the range.
> >
> > Every mmap action currently available sets VMA flags such that the VMA
> > cannot be merged.
> >
> > However, to ensure that no future mmap action falls foul of this, assert
> > that this is the case upon mmap_prepare validation.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/vma.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index d6ed10cefc8f..62f2ce1ad5a1 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2809,6 +2809,15 @@ static int mmap_validate(unsigned long prev_start, unsigned long prev_end,
> >  int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
> >  			  const struct vm_area_desc *desc)
> >  {
> > +	/*
> > +	 * It is not valid to execute mmap actions for VMAs which can be merged,
>
> Is it better to say "for VMAs ... after mmap_action_prepare()"? When I
> first read this, I wonder why the check is done after
> mmap_action_prepare(), which does some work based on action.type. Then,
> I realize mmap_action_prepare() changes desc->vma_flags and affect its
> mergeablitiy.

Ack, good point will update!

>
> > +	 * as any such merge would leave portions of the mapping incorrectly
> > +	 * unmapped.
> > +	 */
> > +	if (vma_flags_can_merge(&desc->vma_flags) &&
> > +	    WARN_ON_ONCE(desc->action.type != MMAP_NOTHING))
> > +		return -EINVAL;
> > +
> >  	return mmap_validate(prev_desc->start, prev_desc->end,
> >  			     desc->start, desc->end,
> >  			     &prev_desc->vma_flags, &desc->vma_flags);
>
>
> Otherwise, LGTM.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
>
> --
> Best Regards,
> Yan, Zi
>

--
Cheers, Lorenzo

