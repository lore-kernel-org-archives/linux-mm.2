Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A1BBCC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 11:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BD236B0088; Tue, 13 Oct 2026 07:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16ED96B0095; Tue, 13 Oct 2026 07:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0367B6B0096; Tue, 13 Oct 2026 07:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1ED26B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:45:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E46E540B3B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:45:54 +0000 (UTC)
X-FDA: 85317423828.07.CE41BFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 460F04000C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:45:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WcbsB3jt;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791891953;
	b=fEVMb+IpoAkQXJ2KtUSu8a3zt93HekaENgNl9sRiPjtDP3C5x9dKixgBFgWbtur8QXLl0e
	8dZaphaPBNq7QNJNQ3j++AKUy3W+HvKjotH+qc8LwlqhT4umWrtk8xvgybh23V3Jd1/LLT
	Eu9a63TvqxgH+A8Dqk6rkHJmgVs5fKE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WcbsB3jt;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791891953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zuSfDICaEiGsOUsuUUs/M8PT2xH5gVwuhSNYHaltNBM=;
	b=10JZKQa+6DWK2hsUAPPyGW1pBcf4e9Ujzd2/VeY2CFRbEkxC0zBc1XFZiGLpC7bRuEF/xS
	D0YSd0muF9jyNJW2RIPPVogCXRWzTQVxMwOl2MpP18zM1HEQ0zer87DKcZ+dTy3c4nhVeQ
	Mx453E3PQeWeWR0JX4EJf3+D8qL+lCo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83B4940895;
	Tue, 13 Oct 2026 11:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DD31F00893;
	Tue, 13 Oct 2026 11:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891952;
	bh=zuSfDICaEiGsOUsuUUs/M8PT2xH5gVwuhSNYHaltNBM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WcbsB3jt6ggnUvGzUReaKgzEI8mDtTInytfY/4L0UY2EorEe9hphgicKzItvTX39t
	 Nkvy8qOh6DKVrPbR5TjupziSaZgBvlcvCG2RK2XVAR40JpMRWs5Fnw3WxwN8wSQcSm
	 e4Pa/CbDfrSNggneSmDwlGAvBdaa5OpY2Eb28vX1tjG+241iKbITOTrqylwnvqPLJf
	 v4RTtDmN5pnh9VqNzHooU8Qhyjm3hlSSYraGaunuKyYvgkLudVqglMi2nhQG7J7WTg
	 aJaagzot2j4wk7DRAQoe19+N65hUjPHU95de4mavPa6fMUPk9Di3NymEkazMnwOysp
	 y3A1k4Y5PuPrw==
Date: Tue, 13 Oct 2026 12:45:19 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
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
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Bert Karwatzki <spasswolf@web.de>
Subject: Re: [PATCH v5 34/38] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
Message-ID: <as4ZgBbVflWECfxW@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-34-923b70125b1e@kernel.org>
 <22dc04ac-c046-4baa-9bdf-a5ba07c0c0ca@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22dc04ac-c046-4baa-9bdf-a5ba07c0c0ca@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 460F04000C
X-Rspam-User: 
X-Stat-Signature: qmd9h53wz1yt61e9piajzkozi7fyqp1c
X-HE-Tag: 1791891953-587778
X-HE-Meta: U2FsdGVkX18nBduDMg05VIpo6fA+2Z+tmc41AKDwyN6wce/6iXcVxDg4U58c4zoAngUqYj3PYcOjFifLP6BFAMMkjqryt9KNPYQZDL4T4FFh5VqURaGBSHEeHZvZv3NndRum9yeJSI0LSx/bR3GWalzMXgY4fGwx0qNU/CnBAWoQi+8hRIy7nkervFpCd4dcVY3ku9zggdCjIV9nm/t+qtdqLi00RB/a2BTR88hjV9jJX46Z6A/+4REKZU58GygBaBcmQo8JGDAeAGojpPcd9hzX3KCK1UjC0xJWtLxjNjYh1Y2hHqJl9RTgr3o5riVb56UghUxtmk6inqA6xGEPl89Bw5f/URcDRKrTW1g7HdQUDVqNIc6NHBr86zjvQ69A29X/CKoYEixIG3sFkxAK5RMVNHoLhfxcj5hSi4OfSHCDoUmm/PosWu2UqMwxe5tUlWA6R8XPkdWJ3Y36w7o9omYPyfzfnve2BcMSBwRaJHZfxkP8Ql8OM8TGQtohMJP0yRbbENRcl7OgpyBxxw4w6eXvUcrXG9xUkjtM1mupuXtZEanh/Avzmz9WDdIGHWgOdsumZdT6bPtsF5TcrPDWGJlV2S3AgprpPcEKcNMOkVQyuhA4ZVEYUtpSCIg84OOIup0c9gQuXNgLvIoPR+Risw3WH1XksQYifcpuPCsthpBcseyxkIQr/zLFXIZ/xxYYcDo4I72coLGU6KiVQ5VgDbx1/K1lWUxPpIDqya9BcEtIA5xXaNyOMyVq8sXQAA6gStibnU+lzRz+2l8UZEgnvIsVs7O72rHUiWBMpQTeBmC3Z4urvcRPlBrhGn/EdgcbawsMbXEvHbUKe+duhkzq6nahHagcYTFm9PeL4JNlHnkXofUS2RVpZRO+qI6AYW2T98/L94q26WDn9ofgpTeLpkARozephNVdb0gjU8bTeeqn2+oXRooCmNcfGlAoYTARrC2+wDGtXbhkt7xIaeZ
 ViQP7t47
 tOiIKWKNUEkg23gbOQpaMgnr7Lc6pr0EGJAZRK49TSmRZJqnzWf2x/+2W3vns926AvCYCbH8DtOUKHN6CLHIvSUDmiaUD2X8VO6CP/eKkcVGBHPR/bwMyH3t0M5mFzTn0Mt/pBmzvrebZRA5ebQSj0JsYF7+YjwXUqO3N8ITeXmAmHe3X3ocF0PVlr8yOwuwmgkFrtayWwyW7tIR7yRbkElKAeZ3I+8HSPUwFAugP3BSA5qY/DAeyq+bMkHBkXqOOXtvxKFJVuCfJMEpxpbDSDWuWMNQ+Mj11o6o5uZLqukSndvFGutHSXOgtTsLwnLC2QXtkosr1ZII9a8kUYBNWEL1z2GlMwarJTV8KWG8ruuydcdfWClZEQzzkHNJqHMezE+2c18tfPK6mpKhRPkdQcEfif/eFvntiw+3r6ZbaTQyZ/2JTzvk22oZGnV6zfQQrtOaRu0iXLPiLTM0g3py++/i1gbVdg16sNKoqDrQzq6NYi5lzD77Rjn+FGMksZWS9G7/00egC/zB0qEJ5CO713JlsRtRKtfCCNr3WZVy9OYT4Dw/uuhBecJTeL+DkEBHJdFdTZlNbIe2PFpCv/k6EVyqXLsHOTOMMnTdFTt28k+RgeYRMOExy+l3ogcFQZbZcVRwPkqMtKELqs5KL8/Nf27XCHHwucmXvpTaVTXy8W8PdFLrbbv91TnT9GQsxQLfcJ0Q2rWpvD55xhMJ+4l3thWpokyF0eNknAMesNaKIy9dAQh9k9L3EoTDKNJl5yYj5/55MOhOB/SnIyYKJAG86CsxQn75637vbZ+CYeAKtUSYrRA7LBLWo+OAt+HDShsD605vCVYsSnLutUYXzDrxOmziCdbXAPWG9rp4Hp//EeUA8cI/WU7GBh/ZZ98q+n/to8BpAHqQKzi/nIZg1+dvgWRpy0RRv5z8bul/0F40Ls1jMOFxwjt9PXFMhFRKCgmjG0N5m8O2wpdIS57sGayYejM5ZTZXb
 Q228ZRJr
 WmZTfMxjQmAP/ZphvN0RHDWNpulXYeesRJCsTvgt8nIXPlEaQQYUyXg9HRSwzXYrv1xLEW7I/s+YuDlRl5EnjsnQC6lGgnWJtWowV1iQhNblv0BiVsUu0LH2rpikVWHGAbiNR92yFl5R1D8wbN6NAVfTPJgvxpFbefDM8HuLeNyB09kOuSgzvQSFq++uSsMuiwWG0YP7pj/L7t36nomQhx6mRorBxh3HYtHieZ3ooUucZUWceyAA52QgF7xlZfhpgsXnAfnzqScGntkRm/6znP+Q/FS+7x1+5zwujWcB7MPDHVfnyybPXgS+BKiBFafflbhel9gLSNOBBi8EJF/Q1eM6nNHMfSP4uufwvPEMyvKvNcQJmdd3Urh0cGWYE0sQtwQX2GL40IKSRJZu2wCimGrs2gXogf5zkc2w75DqC4dJBh7xuNw5l6sNCXYpsY0NsYVk/tRcf72hmJIcWBadMs+qlpa7Xk5W1UWi8V3h6QmJgNvX2h6ow983gXYU6H8nPPaWhgMswLXQfWZTBoO/wokdNzJdyYfaq0KSBVAucxGXrJL6kHP0KN2SsQRFUNhjlXWwb4dY1B+paIT8DH+pAo1PPcjcVVjgXuIKhS+EStA/tggSLJ4ot1bFw0KTQLBejyZzzXGBCybsSzvFKP0pqmhgcyif9kQjVS9GVs1d06SOU8j4CcPZgl6tpcKRPSocTEC+018vAr9vCKWNqSAZBM07oA6suRizkoh0R0SqEWO6QCRkJjWM0eVdFvzV6NMoioU2EwYXLoHP9OriqTrKgc48lbvFSIzP9f3Ss2FHfJeAQMnBDYBXAjEPjRteOZHxIhtJ1yaHOh4QcK25Wngq+OfPbJhm10KvJOsPXhLEtc3ToCJGOQALWiLP83WSZztsbOwtupbClgGrKOozYCoCfJSBbuyvzDI6arxgdhV7f6Vjcdm706I2crrcYTOEeCYqgkfq7Znm3SKiq1V+N7KKH1HjR91RM
 ZpwIxzsK
 VFXbbjZn4xxz0tjDYHSbjoBCPYi0cZ7pLGkbHftQQZpHhkJnwP5tBJRqCMrOkHtK1qadpE1QeAbqEmpEqXa7qKS7HyncFOdinKfOmQMT9fkVKCplG1G6cBneO4+UDaAlm/9bCfcIfbD6Z8uP6ccCS/JM/ya9uMCzayjfahSxwEmWnlBRKTOTDal3XUGGb/xZ7Tkz7uxMB+JsiouCBTf42Gp04wCoJZ0/2TTF5EYM0TRoDSud7ac35jknUbYAsMZRo1SspCHuf14Ii2NbLEhh6o+qSFYi13w9goV7zG0pEp8j1lpHxpW5jOYHl0ql8hLXZOm4k3RuDgV40WXzaWCCLqS2JM2QsWcXGjjcwQd6GVnXSdu5UPBQmBt6V84qQaLumjcg79x/xSR64bUrBCkgG/xGU55RdGQavyDdwlI3gFKdkY3NUqQKcAXRW00bs6wyaJ0RO3iney7hAFKtOfU5mAgGXGwaRV9e9yp5+5wrono/2K8hRx6Bruvq6u4CP7ITI66H67xaRQh21bVl2Xkt6rf33fhWHoCoDf7KBap88FhFxvexNugg7524PVQIJ3aD6IR2DB4oZclYn3/WaiGB+x2FXkMu/57wysMkNb+5wvAGXdbRTTR9YNICP6gv1pdTWyuiOxd/z3RLm63WKaCNYMXdTzyLgelw0EkFDYlhME1KCaKyYiKNUn4YQrFnRUCVZncLqY5f91W8xe2A1DI5J0QcP5MAvLgtQEHZnKBChynAf2vX64fdg3uHBhrAObNxzLQo3vaWMuxQ5soas6uxyfjBEHQF9ghoaQPHYGnizi5zUBkJam/8iMoWiW2xXZpRisTa3XdXOks3hKeQwa/WKD1jqR+YVgfY0GCP1UjgTod71TSrsiVuGYqEQ4mUxHUkcnzmDRp050Tls/w1qnchLGibuGZjr+I7Jx8unr7jccSCRs/cp5cRRLAG8n6J/t8So47YOH6nKf8Macmly9VYDGL+Ehzfb
 S/Fb3Qlw
 xkUvJxZY90Mf92XbrUlbmALhXv9Kzs/UKcJfOG7ZE7WcCwIMdwhUOQP4LhlcYnLPf9WPRigBuNuUVdvfKL5PO45jbgzptcTJSnML9gi1SWFLj4VUCUP/DtdNI2d0wo1wgkpiCxon+Y+Nrdx4PzqepbNIX1U91y5C/yNWRhLnWoneuzc0Ka6lnJh7bva6Dkc0URSyvgYHnTBowt2XHeqznGo1X4fQyPdTcxL5EzdGVSl5Arg5bVFX3OD+UlzbtGSBAazP4gTq4QccY3ex4XhLN/LoejNQ9jV09t7ZxAwNnz69FBAUvm2+413Ru6EAaHJWNI9V9B6ZCDt1gyH5F7Iuj0beASCEAUGAS8uqWzTolOQPUXqu+g/Ivw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:50:09PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:

> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 3b318efa2916..7adffe8182b3 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4418,8 +4418,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
> >  	if (spin_is_contended(pvmw->ptl))
> >  		return true;
> >
> > -	/* exclude special VMAs containing anon pages from COW */
> > -	if (vma->vm_flags & VM_SPECIAL)
> > +	/* exclude fixed and non-mm-managed VMAs containing anon pages from COW */
> > +	if (!vma_is_mm_managed(vma) || vma_is_fixed_mapping(vma))
> >  		return true;
>
> If you keep the droppable thing out there you can just use
>
> vma_is_mm_backed() here I think.

Yeah I think you're right, will update for v6!

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

--
Cheers, Lorenzo

