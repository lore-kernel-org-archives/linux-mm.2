Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 371A6C982D9
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275616B00A5; Thu, 17 Sep 2026 12:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C766B00A6; Thu, 17 Sep 2026 12:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164F66B00A7; Thu, 17 Sep 2026 12:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDB2D6B00A5
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:25:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0058DA56E8
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:25:36 +0000 (UTC)
X-FDA: 85223779872.14.34F2B87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 485FF40009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:25:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jIIfr1dY;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zUDlDajoLo9shAT2eWSvXFFt1x2wdqtDjriRhbNo6Y=;
	b=ocV04RhIFnaFMWcjWymydx7Mhke4fgzObN4MVtdIIezcIIOezXbZa9yCe17BdwQx4+1r7T
	C/QsHB6rT8Ixj9oDpkZfCcD1jcvpx9fLAmBgVuzhaXJ1793m7dn8iCKtRWM7cqXM5IK+da
	FGavHNKW0YcDkT/3HgWJbfalDWKPMIU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662334;
	b=B5M659HgapXGrsStqG5WxuuSbwhBJRpGG+iMgSHfgDYPH1QULYiGP4w+fPnnfaxieiYiKf
	5sSaBnZxUxfICrarbb2uN8ZUafCbx2mNxd3oKZz7PfLROeBDro2Gw43JaFc1hW0Sxsd6yX
	+kRFQdNkc3F2g7wJf6HRDXqlimix3uk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jIIfr1dY;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D93841503;
	Thu, 17 Sep 2026 16:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC121F000FF;
	Thu, 17 Sep 2026 16:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662333;
	bh=8zUDlDajoLo9shAT2eWSvXFFt1x2wdqtDjriRhbNo6Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jIIfr1dY5Y6yUBVPzpQtob/6PKGQ/KkiAaN6tkH5dtYIPaU7u+htS8ArcPnlhxaXJ
	 tHJxyzcbqBjgQKUa5UQC/IT790lvfATEygmgoPx7gBSUiC+4ji4Wdp5mMVNWM0NoKy
	 zHyuAFujuXmFR50iBT3C5hJroCfuXBIuwkbhitV02qQcKqrUlJL/eEMPl+CANyccwK
	 k3ZV7wtR7pyYo7QLyuI8SNULhv2ot0z9DARSve+y4UekG4p3Ycjuj9H/20kPMpU8Kf
	 GZT0O8zTdiTinqgWKO98a5x1Yug3NZ/9GWFi/Xgm1t6SuLqfQcS0Hm6Rr7uLRHz024
	 UwI4k4J7cE4kg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:14 +0100
Subject: [PATCH v3 05/40] mm/vma: ensure mmap_prepare doesn't set actions
 on a mergeable vma
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1368; i=ljs@kernel.org;
 h=from:subject:message-id; bh=w3dS+6CYztzIjEhtJt3yaqv3CXCLNku1+RXavwrSev0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCO+/vHnCoy+HuE5fLHlRPt1qp8T64Jl/V1y40DHtZ
 fPTiz+sfTpKWRjEuBhkxRRZnn8R3x8kEjav84K/G8wcViaQIQxcnAIwkdvqjAwzQ1Ljhcx4prrN
 2n3L8vw+PsttEWszl93ZWrDtX9Xr5IQEhn9qfvO3fuXmu6sYzP07MHhLa0rMgWMfLvX5KTQF1Jp
 8OMgDAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 485FF40009
X-Stat-Signature: gbmt8r3zit3oz8bj9dkok1qye4x8uj65
X-Rspam-User: 
X-HE-Tag: 1789662334-15827
X-HE-Meta: U2FsdGVkX1/Zq8Hyu/ht3pRQlvpHGm+fmadtXrYEaH/pnhk2fJWT+zv2L8MJAAeXIDVvw3pnPd75oQM9DtacFrpopW7yml9R5B81aJmrNUoQidaEHyKb+pw1B0HE3H9V8M1vZpttaRq2h6aHlS1f41RBbLwhWCjhtqDoGsEt9SVv89hDLJkbqifA4cH1V2ECzQkRshjPR0GOxflBU72+f5kPoYmaiHymOJ2MeyCGeJC9J1ZcfaZ2b98X8+NI6pylYivsPQ4HnYdp5cYa6wfT+TQjK0tZXqMv+vseZZ0HK8ZeosjTwKRz0IyxDftEPRTagkblr4hWfibXQ2J4B/NwXqxbQARLX9CcMgRBPE/3iqHQHdvHus5wrN9YwkF0ouQbvZBfMaTL+hNyd3WEGsaB5yPrKEvPxQy5SoYyljr+ratmHDlrpAU8jy9idwH79qUZEU+UaZ9i/xoUqfRSlazoNe+yyOnQknY6QTc4uswohI9AvgTFYkCiT+KeNDbLmTJjQLe5ycwlzBLl6tASyuYJpaEnWaNjkHF8/kYD5e6Thua3VeJr5LwTiE7N2qKVraKM3wTyLB0nRWjqpuyy25AZQHMU4KoLP67ge6W8jN1C58O4/hbofbFmUrWksdY/zjxxRz6STuyVX7VXsG9yxJcL3hmHFjonQVcnIwt9SHfM3UACypCkuKdGiErfxpa85y1GpiZvNTAfJU6jeb08AWYdZAEHqQ3H8VvpdfpeFVugqYZxVquh8gWXvvJiG8w4amQSNQx6Ey7Z2bka9L2+QQQZxPCr5ZLsTCt8OaLen0BkoIyIuxkh7D/Sr8yboirWfiYWFP+bD7e/lLs6Y87vyLrf3h16z2EbHQl83mRtTXYawojRqm+h/jKRf3tD+dV+vAMmWo/a4fqcROd1jAf8flDFlKf4pItR9BAkBZbvC+NefCQJGdA44R4WEDoUsMKQFssCqwft2/sdHNHH6NVuC3g
 BJcNit/9
 ssXpzqjoaUatN6a0Ctz4nqex8biC88Zvjxu69rXxhF+secci0865DFaOLMNA2YZKxtOp9vVyWpNyZWM3x76f+jrBiUp2M9fZxif6/jrPem3irTvkadxpTWAdCz5DJ+g/RHRee04FpbDtO2FfsQDxfJ6+0OqRgjhLiUh7ze+9s9GD4AWKka9b+OMEVa1hy1mp+4AtRRXNEjRqyZwpgUNxzhdooWaTD6Ga8wQv6fnNdCX2INKr5V1nRR7iErrZHGshmxsE2uIyTwmXs58xPn48mjU5GgExoWxuyLQLtVKDzfnvJdbohKjJrn09zcavLraZcnqU6R/YYHZ7vdTijM3wJstSLaujfN31WF2FQIlRcukTyNYIKcNtmbM5gZTWDdUOhjg0ItI0n3NSv3taqYJRJi/NGbiRnO3/6l+Vq4TNS1vbefsLIId+sAqC7l4dENVzsPQDo0tYrxhUEIuIyH6HTZU6TdukmOijrhmnoHWf0dDfcbtphAt8sOMhPApBFtBojEnQGDIKG1NG5TDFyYt1WUUH+Pnh9IC0ootnnjNMdekzNrXytH4Issr8SXCfIYHliB1uM/K4V2BMdhR+yF4c07LT8CH/Eezw1SegHgJ8KI6eHVAoKs+impxILlziszTI66RbmspHMfE3M10ydKH/0+S8hFjcNj29vW2Wvdb4tWDRqZCqUPDaPep6HDmEzIL4NZTTxMn7eyPBjvfDCc5xfkAySkgWogwarjrpgM9cWEL3On9Gf8gTaDhRls9FvCercFTeASLLxL7j7Z1TlXVdrTcKmplWinhwGEpGuyKtrxvUMRfbJO5iNUhYnY5yryOjk/t13dxoU4RdlgQ2w+zKuKXUv6OjhyuFLEBvmECzLCsokKAT73kM3K7rgMvsfb7Nb47LRaLPzUrLbTH78uf1WXjutqQhxxYYBH0MSzU62PndeoAD4vhEo+jB6AAgnV9Tygbtu3iMWxhB/6fkzk8Xm3y98lPPe
 r0LubgOe
 TXP334GHmkAQFtBXFlO8HoCGZHxEFIaaYtwGp7prAKyUNfoknSN1bifM6DMMOfjN2wUSsxghjFl1W1n69fD0zSjYVFulnCJcbKS/FzCDOvIi9NugLSff14A+nyk+vlcIte5sJO41bgjABty1v80Ur7XUqqLDglsQabe3cT/3HcMUMAa1Qo1BZsag2r0tnxJpE6IF+qIRmu9e2jJAEaNHxwko2dGPGOBKrETCqPXGPukaO8RgK8RQfwb2iZhp8lGV1uv08c2qwI61HuhiN3YC5uHTkUq37Zf1KMY3P4Gszj3H/f3G3rrrSi43DbEFGCRW3nSiLhXm/eCwbw3aWS14TIOQ2hTVhIXGhTaoeI0wyLZ3slMbHUVDTbIYRCfPBC35F2JCPi9lCGUojGjIJ//LvBVxsFZJQlTkVlD5Ax+NklRvCDtGuUHK7jsrL1i1fwQ5WG7CWyzQ2PxWKfgVm79wM3LagBmfugvL+u/iGH7APdt/V+lGjVk+xCBVnFDo4RDfD2H2P9A8Gglcj5TxJjxoh+ZOtrsTkaRl+bvOTanf9wKESAHdy8k+ziyR3rkxTK8s/nMyFUQIFMlrwys3CRdvFxDLjYezTihZpXrdTOvymLnfTk/tLlc7YPYku64SoHLuShhe4KDPlngK7TVNzwNoXhGzkJZxFzG2v+Z/4mRRJHVVGcJ1jenz/5/ZDCDZD1Th57cwQpwsPqS8mpUSk+P7cubTrC0lin9XLEZpnlLsM4LKEXBtjm5VqTYTvZ68KltAlhTh6tejhhXI/+ByfD9GcZQebjtbxt57hAHrxCJkljFbeTaCI5zD42HrHwl4HXcE8f8uruo+8TGz/bQQajGjamHYm11/UlZom177qGIkVFMPrleJN2Fmpa96lkr0rWRryPzCFLkwuuq9QVcetWbkFG5ES5vrtSH0+iDafE/K6ZiJIedeF8wtKtlrRxp/aMiG8gvpuCFJp67jLxMvHe1r5VgLLx13g
 SRNEdYsr
 P8sq2HA5qFcAvW0NknvHVULIuFoex+AkXQ+6o2+JSmIyfORkc9VheR/Ol82JcFZDM5TTxDB0KlA2HDkltym24+t/fu2uzzm0FY+37FUNtk/riGoCM/1I/+I1QsOl92kbX7wAaqVhqe3PUpR+hXPvxx24FVi1w6irRaVLhul9456aEbRBlpd4pD6GtJhV4DI+oIHwsiKOBv/TIBWD+rlFVO5u99gUv4tYrsGfcIsCBGF41P+mDF/MZ4ci4AHIQbtyk+BXpTboI/QJY9u8H9a7GnR1AhfZuhq7TNylRbjo9Bonf4KCx3ncmZ8HR9E10AMMV0EUzaE45LNC0wnwBxkGifPSxCSCCB7hq85YZx3nGfXv4aLp+iMbRXOinE/8h9XQcg6hRGoHa8Uul0xvfp0OL9UUhE/GhwaP47xMo80ZiWvfRcsF4TaRZaYIERbXTTZLnG0l93swRv6Kg0X7Rc6LeVnM7oTd36lp9HAuV3e3pwCEvi8fpJUAJIV6pOdF3qx0T9y0PQAt4E8KkQYkVuaNjivI2z4TPfEADfomJ9Dl9bAb1lN2kRKVhSjZZ5oofjBJEOn6UhPTWSaju0lGD480UhpCcBgh7/CmE93IBYdmF54nIWscRKxAg8UqIeR9dlmHUZ+QpX8j5abkpAR/xwnQcPcffmyUoa14hAjnoKmgaxc1//bO434zka8p1Xa9MAkwm2x4DUtlyRx0cBfnVx4JQQvvBQR6HetFHv/fmuBblM4bEtBUXWBnDHCnpYe5BODKxFO42eYxQBiHhzeRfeuYxNvLWMbdpunZknvDjk+bMtzSRFxnAyt7Hbly4vvSDUJZSwKg53ScLD/up2MF2sKE59vGYUloGYv2iIjOugkkzJst+WXdQmTlPwhgKRPeypzRDY+4ADtFH+wcN87CAg4Rbb8KaObAwFc3lYmj0EJwB9gT7UfuL/vzjB3ahdXylrtDQjUNogi9bK9+0zjRvOsKIVq2pw5+q
 e/2n2Qhg
 FrXfcA1rwB3BHjFErnJd/JENxcea/KfpMUou5LGf5Xny5WSv430Tby3YXDNE+J8eCiSmJjYRNmCe1bKSRO6nA/+o8U+pCCgiaJP+Afx/nKOwXBQ48IXWZq+tQBkJn2owtZ6IgIqBnlhQmp18aTp9g9lGR6JOasDhLRM3HOAQitY4IkVvLLEAGtJc9SOPDwSI/9YJSWZvbZya0vv38c7lrJlImOOg86+693rv12zvMshpS6qFdtzYfGc62cvL0w15NtC+gxpPw/JlY/z41k1L0DCQyo7Aiv++93+1BL5i0nJE9lF3pd5jZJNkPecZAbIA5icilZphGMmpSZKD9/q4xV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a user requests an mmap_action be performed in mmap_prepare, this
involves populating the VMA range with data.

However, if the VMA is mergeable, it might then mistakenly be merged with
another VMA without having populated the range.

Every mmap action currently available sets VMA flags such that the VMA
cannot be merged.

However, to ensure that no future mmap action falls foul of this, assert
that this is the case upon mmap_prepare validation.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index d6ed10cefc8f..62f2ce1ad5a1 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2809,6 +2809,15 @@ static int mmap_validate(unsigned long prev_start, unsigned long prev_end,
 int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
 			  const struct vm_area_desc *desc)
 {
+	/*
+	 * It is not valid to execute mmap actions for VMAs which can be merged,
+	 * as any such merge would leave portions of the mapping incorrectly
+	 * unmapped.
+	 */
+	if (vma_flags_can_merge(&desc->vma_flags) &&
+	    WARN_ON_ONCE(desc->action.type != MMAP_NOTHING))
+		return -EINVAL;
+
 	return mmap_validate(prev_desc->start, prev_desc->end,
 			     desc->start, desc->end,
 			     &prev_desc->vma_flags, &desc->vma_flags);

-- 
2.55.0


