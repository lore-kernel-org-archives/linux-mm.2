Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E3C1CA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806EF6B00B0; Fri,  9 Oct 2026 14:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B71E6B00B1; Fri,  9 Oct 2026 14:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 682086B00B2; Fri,  9 Oct 2026 14:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40EAD6B00B0
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:10:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6C7FA7F95
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:10:14 +0000 (UTC)
X-FDA: 85303877148.27.766D463
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D6812140002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:10:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=epLJv9WT;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qiSoCUmsNQBqgv+Na0/FnZGGuoj/B8dSRuNq2EKkroA=;
	b=kVvB8kjivthqP9ORKdjyaAhmhsElprKV1vV9wfL2zTh6W8rpU6Tt13jr9YHMUhvbsrNSEn
	roLrYeqvm+UvzOHiLGvc+js2D9RMa3xEdf8T3NeBkVC8PXTWJ+Mvsj0d7rOCWpsMa3c5Fg
	k9dYI83GOjrudCJXzNajr9uBTmQlW5Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569413;
	b=Ll+Bcb9JFTbUMXRvMAU1ZQe4PqqSS6VdH1Gx4ozQX4ap8dbg8Pc9etdD8r8hi8RviHMcGV
	gN5OR7bPnl2IZDZFFm0f4BCnsAApATeYD/XtpkIWT7XPIJOSFpyW3umwNYFZK2AkoNwpvd
	Hy6ne6I4rGOIJU6s3Ct6kkcmcdqp/1M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=epLJv9WT;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2994B42EA3;
	Fri,  9 Oct 2026 18:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FE91F000FF;
	Fri,  9 Oct 2026 18:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569412;
	bh=qiSoCUmsNQBqgv+Na0/FnZGGuoj/B8dSRuNq2EKkroA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=epLJv9WTwKe3AO7evq2V0hTj+mFl2PEhzz7iXe03X3tckoHrl2NPJjp0PwSl88kKJ
	 V3eBpEJT6KURop63xVxVs0hcEZHSYtM2rWl9SLBlvOojzIHzkPAoC6E/xozeIC0RDr
	 AR7sRxvRrS0OoHjClM1G305sw78nbBLyXW5XLd00YLTbLOujAe3ZNnWsYFKRBooa2I
	 7Z1eOtUDoD+/TgFdiCnBVY4da0gp6/u6uLkPuQjvlgFYLCEnYJvX2azT8z+orMBTdt
	 6kOSoTmydSKnlRfPRBhRf9HvpsLKIuqKAO+NWeB+Tfo4I8M8VE+ghj5A4uKV+5StCV
	 TZXtGcSY3Aybg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:10 +0100
Subject: [PATCH v5 16/38] mm/vma: add and use vma_[flags]_is_fixed_mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-16-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6606; i=ljs@kernel.org;
 h=from:subject:message-id; bh=XHbx1xk1AxlDqSLWuIPx3vl/78XIH5S7J03fK9yiFxY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sxWYds4hVNx7X+r6e+3+r7KP+MhM11g8Tdla8snn
 w2ubX92qKOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQAT4b7HyDCBZ7JG1TEz0U8e
 zk98zrlf4vKyNgv/0862qXhl+6tfGYYMfwWYl851OCtVXueqV3Uzri495rbvwtgWC43guvyDqR3
 F7AA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6812140002
X-Rspam-User: 
X-Stat-Signature: 6spedqeypaexsmepetq48wxhz8oik5q9
X-HE-Tag: 1791569412-659483
X-HE-Meta: U2FsdGVkX19uZf8MBROkKQM+GQkLc9Qwl470+xqfNru3hX4TUUCZFbU3Ln4IOFLJa1ijlTCvZRiM0+uZd/6PoSF9biyVYerbnekT5imo4JofvnvwQdgIl6FU0epUNS5x7tzwqmOCS4SbvLHYASVPWMsNhciVUEwG4ykaFck6n6PI3GUSGvWw1eBFMUy7q43cl+x+y2+SF6PGLNnHELwP2pywqKWhMacowqkkTARrh4UeB7hz3S9nkXsZlBb38ziAYN5aBFFZ02WksvzMGA7XvmFPfSfj79xD/v2u2fGtVA06ZyE6zZpmEwzd3kpDDiB+BTO5wENR/qz2vCfdyx/hJS20vfYaadKecWRb0rjmFc3UUFNlLbG+HDX5mnF6YeoGBQm8ZOP3XAiutl0ewpnHe+DquHo+qRTQetxrpqJDCrpgBdodOJZAES4z35uSLfLWsj4grcuqEG6Ph4CQnE9WJYfmAR4/jIXqi4slaI0dF3HZZCIymfDQgzBcKwA97RSKKPvsGlaNUOjQZIwa7rGsfs7PriFByHE/4g9iqSDe2xmTwUJZk0AOWH9p3sEmNFlYYKoyL7CPQcxhLySWqjI5IpRmrConQKTq5GR+YGIfe0Q120fHngJzwcrmpkv7Ra11wLHNTedqhgfZ05M8laIto/p9b8I9LTulTb9gcKfBNcya/wCe4yWfL0NVSlPaPsFSdPZKO22sUBB6MHgVaHjLcHySOm8KelHiSkEnbxWTgbVjXGKHDZJ96gTAXKj93kAVrlMMVR/7PVcmvklYHVYoEljH3d3u9aERguGo8MFex6MkeXCr7/dLq9llCREKM1jXfh6rCVG4u0ZYpTelXIisl/gq2m8eJ8ARvc+/EGOqV7BLWHIqwHj1+tLTYnBj/ZGHjKbMyx0u7bFs0OKOWBOLf+AdaVUT5WYVi+DrGeniz8chgPlsEHRMNWgqwZuNXMyhtjc6dtxeB+0DXBFI3GP
 bKfsiUK9
 FEDdW+giWd0+ZC0OiKIHZEL9b3qGOd+fNYOyQ2pTDEZT+1C3jMqcu+OACCpGVMbx7Ycp7YrszrVqCAHyClQFSXqYe5U770QAUcPRkAFOkDtHuDhtF6C99kZpLs8TZ8C8kIxrDiYwovz3G0D4a6GXbxpD6o7iRKvDrxEWCn0FauqpLUOEOp+/vm/Y0aXLx6KxVldGWt48Zdl8gDaX5WeZ5k8llLVxU+3vYSyY9/+lszGcNSR/CHNdlHOgibhY6GK36AKSro0PxLn9tNXIvon4S8HjCQFjfVzY5KUmugkc6zpyZ/Qb3THTKAs8go5X+ekxWI1rN6AhZSQ1B7HF92Jt6NlJC8pvMqaT/dmxxTTwMYODIrdiKFSfDAid8EID+aCAdSaz0J2ZTsnm8FUFJI2ALPUxF1EsAc3aKeFS2+QrPO4rinNCEJtNd1SWSkY9Ts8UrwZjjl3GptaMFvmpQtQXjwIw2vF0sqljlxVQrof0gLUMEKZY9nUP6PUNxCiION36CuTogyCWytX9ipYy/izSM2tBUBX96XlOaVcSeHDiYd2uvHDt/HeytvfOhIM+I3fbI2Vws4N9oJXPWjxFeExjMdvXlJbmoVTXrU1Wmh8eIpN3IQLJEcL1h++8G8KFdmv4rBVChAmMalTg97AYwiiCjQ3P9zimaqPd1AkzACXPGideUOZwYp5jwSs9ELW1JJG5yBrxIjcYzuWwBJo5CClVZjxVuQrZD96r8TSSs3Rp5pa8v9cnpu5B+rMYPMG9rVPvXm5eltGUZSkUzgK3vVwujaHOarFA+h3wJpMijOKrK6BYNs9cZwtJI+wI0Se+5wYWnHROp3QwcKbsB1K2P1bjORh+z5TRnfR42WKgd4sthxTdi2o4qKfCHi2qyD/OSUDtO01AA5jMk3mSeMwG7lj3F6ONiIbFRYtdCpcfRfLEM0I9BMt0LmPcGJrOADXg1ogg55ER+Eptm2pzWu62QcrhOIOtMCoih
 XFIv9uWg
 sjcD7FXz/DjNvBEKX3RT5tFDptwXOoWwN5IznYfCSO748GHGlxbDxZa+frxjNbQnfeQIGUbWFP7YKzM1pe5wbyIdzBOoow/Un01B8ir27nsgdDLAhy6g03WSL2nEN5aW0Ih1YbQxivhX82I9WffSOjo40PV7bgTvLFcxAwSTBzZWsFVdZvz8D77Q6LuPMd1O1tpgekgxfH9aiWrzKD7ksU6cjKeKayW8W7NpumN79kWGJP88bO4yZGw/gQJm+ay3yX/6cEQA5LkN6EBzUBrp4oBUz8eIzk6uj15p5WnGu1e9qqj+nBB/54bLbVRrdPkrmYk+EucJFPtzz8xvW2NQeWhfpf44hmrdwUWmLFQCTreax3KwHUMAQV5TaIe1pg9MJEm829FaYZgT02eqklhRtl7UrSN+ns8i8EGJtKp4uPIWTPxm4oNwGAuktOwJQHF0V4IHOGfxfjtAzVgx5kkol5cPQL4d0pUGQrt7ub17KiiHEhe/TD3DaqNDBInKaGRUe33DdaXjyzv0fe/WiUBL9I5p23Lke4YnAymeqcMFtH3bB6cxDGHkY7GzZ4WDHYWkcgLjenBucoioOqABKIxeIumppymc74mM6WhiArrITSdKfVzrB0lyjmKkJbg2nl2T8hkPyMbkWRgH2QYjjNEmfwQH7PCbAFPOOioN0ktYKv21rUPqS745WtPKSppu/QldGywQB63nzaJ6XRfjgu2v1VnewUMs9EDTZV4ogjsE3Ui9D0f6zHIgvwBe+FdMftM/zEtOgQaCU4ETEMaG2NgUfM2xY8vNqm+j0KPliMdvG2+QSq76e2k5wRkednL5FGwaVxP8W2a5Y7CX83QxBG0qXBmbm6kRNk3tn4mG1NzgEqJoEZgOlA/gI+uI0OJEq8/v3q5mqc7mZgvre8g3x4D+TJf7K7KiqUQgAN0asR1ukqZlss0+4b1bNI3m3hiBBZaXR7h4GCh64excoSRFcdka1aje0QlQ1
 I1fyzbiw
 g5Rl3TPlMWpvSVrpSCAmUlqRd8vRbbFu3V1oa3VM5aJfBJ4LyH6VodL/UGVNOtf6ou924F8/gNKyeIvsf0yOYBsfPArszBBpctsaLm1xxPo0NinA14ibDlTCRVuAIUj8ilwC7PbLmzjEFBDRHGPfG71fFzFz6n7jwAni0MEsiqFmR0g/NtBHNlmDT9mu4e2w7r3yPCfSymqc1hCPOptUN6tDkVDBWZjAPdsVU2OIyBhSpWS339hn1l+Yf/3+d5CW5V+q+22VCENiNcQ/og7S4f3W9E+l13Byb3cjpKwwYfSEpy9pDbE/+j4wK2qcwS91z727lEs1v4FS9zuvz8bR5tSi+tPsoFTaqsIf6wWMqgZCyOox+W/NYhKa1XEiu2hu+OacZxT4awxrOP/TIW5GYo+u9J78fnSWXn49vXUpuBktpYGjFrmrAwcRm2p7/lTaaUv4SeoYIZL/zzilkcj4km0KPDi6+fQihlqOSEjRvS8cjIeUWNoqKuRihL3eiV8qJM0iDzUuFkWN3OBnGoxmCx9J7XgTn0nyVxEAOZVs37IeedJA2lfv3JbgPaT5jkUWkN6vbU/NS/6KsBNHD5P8/aq5C5tF/jvQPB115wXxFBamwBAX/nO/4+Lxz29GOWW4uCbWSXY7/7qL0CKGtqb3WLQVU9rCqgZfwfdA9wH3J02VANNcUhDA4IDBw8yNzFO1QnYY7cUuSgRgr8Lw5kH0nndQDnZjimbT2haqc2IP4PTfFkJc+XMuvrY1dqDMuPCqg/Enu0ayJkJKsNQrOzDrpsA1kn5QV0kEwP1baTHFiQ0IUYsywl8zjT8GYB2JDsr2KGoQ72wr3tTCKEa3WQE8J3XYy3mNw5rYr+4VMm87QyS9m3mxsSALYwYjDLDLJjnchYuGEncXbua8/uSjrlpWXQpf4sef2VZxjYBEQuXocOIkXpb5phBxjjQOcCca1V9j9tcLz4E4zJakL7OXRWQta5HCsCoFS
 ui96OBY3
 IK8N3FOAjRGzKbyj1Xb6wQcAo06+r9jkZL9hUoDItxp3KXluLf/7fs6xrXXwOGu6M2hESWPk9NsIY5WTXk0w6FdzeK7C72zks7iKzVSj0a9K5kDt/8spUWJXlwQ6/fVv6qu4aZMdDGxyfGHtzzEOadWFtjVFlI7tZTSrmuX/adWPZ8VVxg2lvvIA14vwpJxDpIUwmNVp136FR0SmIgPXUSKEuqL9G+VlLqaONN//pB01uo4qmTdmGD7+GqvG9rlPiCfGcpstPAF8qmwY65xpv1bEehLOlEZHYkGwJgREGYOHbz6hG8ZExud3abljdc9Hw43M7Zeu+oFdf+aZNqspKJYr0pUL12QAHfoZFGW53IVqwC4gpoqLewUDVAUJ2jQsIhu27YslV6rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This determines whether a VMA cannot be expanded or merged because what
they mapped was determined to be a set size at mmap time.

This typically refers to mappings not managed by core mm, however
VMA_DONTEXPAND_BIT
is not reliably set alongside VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT, so we
must explicitly test for this for now.

We also explicitly test for VMA_PFNMAP_BIT as VMA_DONTEXPAND_BIT may not be
set for VMA_PFNMAP_BIT's despite the one implying the other.

Use this predicate in vma_flags_can_merge() and in check_prep_vma() in the
mremap logic testing to see if mremap() can expand the VMA. The criteria
for khugepaged and MADV_COLLAPSE eligibility in
__thp_vma_allowable_orders() are precisely those for mergeability, so use
vma_can_merge() there (with an expanded comment).

This obviates the need for the VM_NO_KHUGEPAGED mask, so remove it.

Hugetlb VMAs remain excluded from khugepaged as hugetlbfs always sets
VMA_DONTEXPAND_BIT.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 39 +++++++++++++++++++++++++++++++++++----
 mm/huge_memory.c                | 11 +++++++----
 mm/mremap.c                     |  5 ++---
 tools/testing/vma/include/dup.h | 16 +++++++++++++++-
 4 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 83953757735a..6b5f06cd174a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -600,9 +600,6 @@ enum {
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 
-/* This mask prevents VMA from being scanned with khugepaged */
-#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
-
 /* This mask defines which mm->def_flags a process can inherit its parent */
 #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
 
@@ -1647,6 +1644,40 @@ static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
 	return vma_flags_is_mm_managed(&vma->flags);
 }
 
+/**
+ * vma_flags_is_fixed_mapping() - Do the specified VMA flags indicate that this
+ * is a fixed mapping that cannot be expanded or merged?
+ * @flags: The VMA flags to test.
+ *
+ * Fixed mappings are those whose size is set at the point of mmap (for
+ * instance, a mapping of a fixed range of memory established by a driver),
+ * and thus cannot be expanded or merged.
+ *
+ * Returns: true if the flags indicate a fixed mapping.
+ */
+static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
+{
+	/*
+	 * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some callers set
+	 * only the former.
+	 */
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT);
+}
+
+/**
+ * vma_is_fixed_mapping() - Is this VMA a fixed mapping that cannot be
+ * expanded or merged?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_fixed_mapping() for a description of this property.
+ *
+ * Returns: true if the VMA maps a fixed mapping.
+ */
+static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_fixed_mapping(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1668,7 +1699,7 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 	if (!vma_flags_is_mm_managed(flags))
 		return false;
 	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+	if (vma_flags_is_fixed_mapping(flags))
 		return false;
 
 	return true;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4cd917f77f3f..87e8bf8029ab 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -212,11 +212,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 		return in_pf ? orders : 0;
 
 	/*
-	 * khugepaged special VMA and hugetlb VMA.
-	 * Must be checked after dax since some dax mappings may have
-	 * VM_MIXEDMAP set.
+	 * khugepaged moves data from VMAs once collapsed, after they have been
+	 * faulted in, relying on refaulting for file-backed memory.
+	 *
+	 * Mappings not managed by core mm cannot be reliably reconstructed from
+	 * page faults, and fixed mappings (including hugetlb) may well be
+	 * mm-managed - precisely the mappings which cannot be merged.
 	 */
-	if (!in_pf && !smaps && (vm_flags & VM_NO_KHUGEPAGED))
+	if (!in_pf && !smaps && !vma_can_merge(vma))
 		return 0;
 
 	/*
diff --git a/mm/mremap.c b/mm/mremap.c
index 7c368440fafe..ed19b47c2caf 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1788,8 +1788,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 		return -EINVAL;
 	}
 
-	if ((vrm->flags & MREMAP_DONTUNMAP) &&
-	    vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
+	if ((vrm->flags & MREMAP_DONTUNMAP) && vma_is_fixed_mapping(vma))
 		return -EINVAL;
 
 	/*
@@ -1827,7 +1826,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
 		return -EINVAL;
 
-	if (vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
+	if (vma_is_fixed_mapping(vma))
 		return -EFAULT;
 
 	if (!mlock_future_ok(mm, vma_test(vma, VMA_LOCKED_BIT), vrm->delta))
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 89c645a6ad60..442ea9eb098d 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1676,6 +1676,20 @@ static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
 	return vma_flags_is_mm_managed(&vma->flags);
 }
 
+static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
+{
+	/*
+	 * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some callers set
+	 * only the former.
+	 */
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT);
+}
+
+static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_fixed_mapping(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
 	/*
@@ -1691,7 +1705,7 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 	if (!vma_flags_is_mm_managed(flags))
 		return false;
 	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+	if (vma_flags_is_fixed_mapping(flags))
 		return false;
 
 	return true;

-- 
2.55.0


