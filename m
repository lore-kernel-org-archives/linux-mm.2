Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78718C98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574586B008C; Sat, 26 Sep 2026 05:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5253E6B0093; Sat, 26 Sep 2026 05:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413FE6B0095; Sat, 26 Sep 2026 05:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 188306B008C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:41:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AAAC160672
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:41:25 +0000 (UTC)
X-FDA: 85255420530.30.045E361
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E5F8480007
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:41:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jp0AvcBc;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790415684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0u13dbBevDvvrKeztStjJV2PV5yx6LiZibgW9CGmgFg=;
	b=sfJ3I+iQtpcZCXoy6cAu3kNa0a5RT0Z2MSXOxOekVLbNsbkDMnL3xhewJleTIMY8L45t3r
	XwqN3RA0TOP3EZvNi78TRQBoGm4kJWEtih3H/TMXzpjDwh/z+tttgraq2n5CqGGZvk1sHB
	6KjMa/Oc8l0Tqqt2kQT00sfgl2BiBE8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jp0AvcBc;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790415684;
	b=bQSFZXRcRBClUoVGSN1yOsPAuJJG+0V6taf9Vgv2XsCBaXKM1qYa0rGdP/BmLbpvWGeD10
	B6Bqpq301oM78O0GIGFrKiaRUdPaHRgxbHaK1Ya1gy/PPAVCbslcYDanYjitaj2qBkCz6l
	pj4xk730jiD7RXxWJ+fAOTfSrafDLJo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C05242E19;
	Sat, 26 Sep 2026 09:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8C81F000FF;
	Sat, 26 Sep 2026 09:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790415681;
	bh=0u13dbBevDvvrKeztStjJV2PV5yx6LiZibgW9CGmgFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jp0AvcBc2qFPX1KUyqat5xOo7kolWDkC6C0w6P6DaUvXm5iSIG2CZI03JVCmdPvQ2
	 vFXKg46qQ6h6qbDwt9b4xtSV8aaaHLKGAB793g+poJ3xMYhkIZo7xqXL5RLvULfLUx
	 vltnCfE9F9DOd8HFLd4r2r4Sg0lUuE/yF336VcdgoJJtQs97NrE8ayt+3eU4eDKxGI
	 oItyuRRw3Cj0jyhydyYqR3Mm1CDYrci/+rQrHCVid7DDrx80EwRj+MiAUgyhESJ7FS
	 iOAhXbJnk5J5uDUKfyr1oX15QJ3wMcCu5lNOsTEzc+QVqHwaov8/ApQZu8GqGu9l4+
	 gmVl8+MdCcOZA==
Date: Sat, 26 Sep 2026 10:40:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	"Kirill A. Shutemov" <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, peterx <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Dave Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S . Miller" <davem@davemloft.net>, 
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
	linux-perf-users@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev, Takashi Iwai <tiwai@suse.de>, 
	Emil Tsalapatis <emil@etsalapatis.com>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Message-ID: <areSEI5pWBadkqIe@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <d4d7d4c2-a1d5-41d0-b1c8-8ea0cc5a0397@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4d7d4c2-a1d5-41d0-b1c8-8ea0cc5a0397@app.fastmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E5F8480007
X-Rspam-User: 
X-Stat-Signature: gc4md4s3ny1qkwj6kcdqhct4ifj8gfm8
X-HE-Tag: 1790415683-668508
X-HE-Meta: U2FsdGVkX18S2k2ZRSxyJJyHBTKib57JtI+X4kAv0vtLEW8LoibAvxTl9sBYFe7NWrlUJl4FPQhDEhrVy/u6IWYlgz7HGQujZ2qtTx+W8Mn5AAQ1tPvQD0X57OSM7Mkza+0lkwfe+ZrkLhV3ydAzfreFrol91Sh7pCa3GKGCxItN/EaE4T3x6pOASfrkj8DOwY/l7MnazHrDcwrFAnwUwMJSo1fZskC7OgRKZU2/twVh1Hvy84rkhan311OrE3JYzxNLO81XAjXWhJ2F6CTMn5P+Im/C1uWIq1iXZbskNg0118pICRborzUP4zK7GXSy6G8yo1Z07vWQcHnbbTB3TAPElSygvSOobsn8YpzUkPUqc0RFxF69qZfcB1MdQUk8C59WfBEnoH9g+TdOWnMZpD1K+o5tzGfDyqRu8EEW5lnobHu5Chw39XFJb5tyddaM0oC2/Q15EksrvWDIr2QsNtkIHMiWSTDjOplPxhej2TS5kFGMN8n0lEV+Rw1TIdEjnaq56Ba/5r/HDoJ6Rc1U5mOJK3fZPW06+jd9vtPJYO2Z5kKBt+/P60+Dn2IxphCuK2uZUfL6hiu5t1B1GBF0ScIXGjmxTyAtb+PK3BOpzuoS1LYClL6C7uDoXN9xNKw3+/5W1BRb3cHXltsMvNPy32a1OaqQ1utpPw519VbsQzTsj9ZnorcsbYJmubfE0SLjV7Mz+OEJvDM1npZrs5zZ5YYLD/fZTWzGKFYagX5UW50lKP3U5BpEWv/VaBCUqIKZ92OLRXReeK4r/gdVEa+w1rj/t+6+10tfoYNOjAETPz+2tudACV4UQiTxVYXUvmDTvzyry3uIzML2e12q8VNc+/C+YGQqB4/RTWHgd39GVt/bpb+RE7ie+LNnh2dBhO9S/2tiDmtEwnX6JUw+m6h1Twi/d9znvshIrxFx+4bTP3OVOUnOkBaX6K/KD/pqmeqO+3L4xZkJiSrGDb2r/a0
 npPBWzLT
 KzfaCE+ZQi8qZVo3fOUweWNbdLYscf//H7C5gRLQ/GZoCV6gtAf0RihNKJwiS6xYBIe6R2T4YL+qA87Jqap6jQw10D+dvYih2uif6uwaGiOH0ujaIaJGZkkOrOUEZxnJ28ifq1Xyvc5xwiJxU+PpZk/qZM7le71lkEvoiDhrS/0Yd/fGPwBRQQ97BlX++dq+cLm+FMMsEn+ub0XxL9bVONKNNZG7nKIBlRAYlqzE6v8vrauo8orZltJfHaKy3pZISCBgtYCHMuhn3W+Jk1aEEH7YyyZzUqTtMvFDMISvIq1TCXZgcBRvgNYz0nc1x45FHz/zjUSSLadh+bWJk5DMUzHUoQaFqNMJ8URFREj/Gfsd+cNUAfM8ZXpunXnBmkDqY9JlYpuI3aoVrKm83eRSpfU52YeyvPhkEkK6fUDqeuYbxtW+vqFeaM0RpzdvgQRcwZzEawRodvDB4stFK54TE4ZyQtsirtuETp3zT9PTYE0F3CPwK4m9W6cMthzGmEhBbvdGfS1aQcKGCuJiurco13xoRE5HYyEX+2bSeilrH4l8wE8/06UhmDt89hs4ISmEdeFUXbqA3i0IjwlaCsKhTOsSNScUKBvhwGgPrsFTgit9fmRzBwPXsuT/arDpgAtMvda0+kj75bu+nFyQCrYdt1DCTE1alD6rIpjnIh3+zqsvJGDEFromEs6PXlvSaD9ZfpOLgQhe/Z5WlqJ2Zt5gWwbOwnJYk1uucRIylEW+HB19OsO+C8WywhLzr/du80Qv+ZFgwKQY37mJsoVPJu2DcxiaB+yosqlgAriyP8r/E11KcUy2Us6kafvTQSA3WtsNj+2jiluBLdYO4Hf8V+lWkqSAeSihPAsIGKgY+KjBtocTEw23l3QnCPuWUq8bLCVg8Cyvf8jDmTivpF1R/1wxQaPxLMv9qKIprz1r36a4jtIf7/nNcQjBFtti4p7LZR2V93WS70fComouYlxxXvfIdPZnbFemD
 7aKKnON5
 LCZlDQmFH5fBAo0B4gE5cAzLqmRJVuu71rvdydfhS2V03aD1ciABTXD2NmOoi8vVAzqbdOjwBQUwYLwuMivKpTyJQzzXmi4II15ns717sVcXwFF9IdPCNQV0SdFf02h869MfYXW2Ycp0pJkni3BQ+c6NEd8I7rSusl+L7FG/iZNrw91EilkiNmmHb3pCFoSG6g1f3DIz0bzF9eGLxsLS/zUMGrMw/PVuAExtQb1nkqxpzslmwlec81vdBrLDIwRDyAEkXphXk0InumdA0yZLW9zId9hPfqouNZf6VAOz/WU4ZOyqDQ7exyn5Enmqe6/Gqoi+e3W6atVZYrIETaE3QytfbTaarmc/xlEOawVsF3f75Ma2w6a9iai+Qxa2LWkzvg6SrazPuAdB6hJxGF+37xNK+89BNsFZ0q7+rdG5M8My/J+Su7Nfnhnpt1TP3AZRraGU9c1P+FEMk08dzbVUfS5qjK96l6auzBMew3FTqzGgu8Y6LslHZuL//I+ep8LN1ZF6Q6tGPjWO44+uyXb+EHxPMwKovm3NQ1YNHUeXRA+IrKMF7RLGWlh4sKxt1nbEnr17cVLdhF+L3Ue90nAaMyU3CLOsFtyAh6QYkjcIxUXLgalGf5KOBxNPZFe+hqdTAf14aDZaV1N+/ep2jym5r8dhacP+h/WXou3lJ4z0Js5Cs1uscHerLhhOr3hMsZiL0dlvQPiYvN1cnE8jLp4z3w7Ju2o28BVbzDapFcB5iwW4Y+ZiDm5wKppHsXBU4mp0BjpM1pl/wRiimx321NQQ/WY5k6g7/X3ZTjbNhOQSY5cFvFNKF1m0iVqWbdPL35YwZEGVmCEfhfC9PtoGJLMF9yx+rjR4v7syIzG9y64yDffKVJVDtUxQWygkivmcY5/Uvxe1Ex06aNFgL/pROEyBQtBlE4EycoZ3WGtl3EB+DjlSlJ2PHfvuA+PkzOBOLtIqBQSw+kUsUuGSaA48lx1cE55lqwg0R
 3a9Wukf7
 X+OCzkTdBZeLZb8ZZMBVedb5KQC3AHVmk7s0nsYfpKFtPG2Mw3/XRmtCT9nUfuPOPd8mgg2G1LzYHMcT157GnrTJ38HzqFDRLmRooQiavZB74axtrP7SL6zraqu2eeUQfqMdRqh3us5JQeaZrkNRJYaYfK+0ANakQskFFM6miugNm6KlQzeGkWWF25LeCV8kIWEqxlx9+suxQd8gLQqLclK8b2aU3I1z1fNq46w3xIuEiskcGOQ4d+BngQAcq029NVb0qoMqCRd6KT9AsYcaTX44qanSb/Z1+fjZmDB2xsIdhTwfvxeIEk67C+KY1cb1uMwxCLfjwt2OeRIeR02KHsQbqX5SX7JYMnlLJRFkkFRSreSYguS+mGM2tXsl1WBGkpSa9phxYh6FfhvZnkhQz+mok67aGR+U44CwnSipp2V3zjmsTm2Xr2qvxuh36Q6YdiY7zUUQSwjjkWj+DvWFqW+LgRsKH1CAP5kSdqlIol3TfIX3KWqtZAfToR61XHaqXIKNVRjrPmON9YSkV3AaFKYZzHB6FH+y2XCGhipZiFI+MH2xgWtZPmGXaN2mQjbTUhwH/xIoIzkr2eFEqqJCAqzY2FZkVsi8mJyd4wVIQsLgQyGwGs4YfZKcNcu6s+FTlJNWtAD4nRSyunZDLDD2Hfz3xn+v5QBMTrhlak3EVRUB8xjeUK+Gjj8M4i/dtxTH/Og8qhd9hiEM5i/olTYodAeG+hVmGBTfUy+eXx4RdF1BGZ5iyaN+VWPYac1t44/1bvqdHGxGpJbnmZeu5X8Or5byXgIScIR4DmppMu4TlRFqIPjQumStiHt++f9EQqzBQ4PkOvvviLlq16L6R/BVdqdwwHKJlze5Fky5sSgalvGvfzUsSLpAbIPHEQCy9R8pFR8/NdS9JNIiu0o9ns5N4uBkTZWsZmXEW1wIke3kdSFgvm5K/G7jcWErE5NNgXdL4WHRmDF75jfY/8cQ50RbzwrCqYnKN
 23u6TAmf
 GKolgbmt+b0dlr1dgCVDlMR60AUbI6GXeJpAawN3VC21jSjEIITjUONoxnAdhNNSEhZ3paJtnpSXvPtvxORF5w7yIYx7is618ytR73/mUgE4oQfLD1j68i7SN+eaNdPsV0faoNfPlcSZxIpzqy/qBBpJNNgfB1UBig/6kFhKGb/T2z2c2Ne+T+/32I8cFTFGE+6DTiPJ4X5nuXLPbWTmwy2s98AZBTAsHqcEAB/RkOvtAU+u+PZcci4PpaCBp3zEfdZNIs/1gCyBL9X4ymrRMjfA4OX1WwsnxWa123215rxSam1BFW3TgVoodomwKHjHpB8JBF/LV82Nsx4eOl5ZM1ZG6EWkm2jo/ITGD3ze6a+i9obfTdZS+q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 12:06:22AM +0200, Arnd Bergmann wrote:
> On Thu, Sep 17, 2026, at 18:22, Lorenzo Stoakes (ARM) wrote:
> >
> >  mm/vma.c                                   | 246 +++++++++++++++++++-------
>
> Hi Lorenzo,
>
> I see that in linux-next there is a new build failure in some
> configurations in code that you are changing here:

Thanks for the report!

>
> mm/vma.c: In function '__mmap_region':
> mm/vma.c:3083:1: error: the frame size of 1552 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]
>
> I don't immediately see anything that you did that would have introduced
> something bad that wasn't already there, so it's likely just gone from
> just below the limit I was using for my testing to just above. The 1536
> byte limit is what I use on 64-bit builds with KASAN and otherwise
> still has a clean build (with a small number of local fixup patches).

Hmm are you specifying this limit manually somehow?

>
> What I see is that this function has multiple structures on the
> stack that have nontrivial sizes:
>
>         VMA_ITERATOR(vmi, mm, addr); /* 104 bytes */
>         MMAP_STATE(map, mm, &vmi, addr, len,...); /* 384 bytes */
>         struct vm_area_desc desc; /* 128 bytes */
>
> The config that caused this is https://pastebin.com/raw/5M95qHy5,
> which is an x86-64 build with CONFIG_KASAN_STACK enabled, and likely
> a few other configuration options that made it a little worse.
> KASAN_STACK tends to double the stack size used by structures
> in order to catch out-of-bounds accesses.

Yeah, there is a lot on the stack admittedly but there is also a lot of state
being used. I'm sure we can reduce it.

>
> If I sprinkle some 'noinline_for_stack' annotations on functions
> called by __mmap_region(), I can get the size down to 1144 in this
> config, but that doesn't sound like a great workaround.
>
> The large stack usage is potentially harmful if this ends up
> in call chains that have additional large stack usage (e.g.
> kmalloc() leading to reclaim). Any ideas for how to reduce it here?

That can never happen :) this call chain is _only_ for an mmap() call.

>
>      Arnd

In general I am absolutely taking this seriously and will find a way to
reduce this, but my only question is whether this is actually something
that needs to be done in this series?

Because it's already huge and I would rather avoid adding yet another patch
to it if possible.

If I can do it as a follow-up that'd be ideal!

Thanks!

--
Cheers, Lorenzo

