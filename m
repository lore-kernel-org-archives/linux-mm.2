Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC560C982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:31:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EB376B009D; Thu, 17 Sep 2026 12:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899EC6B009F; Thu, 17 Sep 2026 12:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763796B00A1; Thu, 17 Sep 2026 12:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F09F6B009D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:31:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D91541403E6
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:31:41 +0000 (UTC)
X-FDA: 85223795202.04.C25F9A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 305814000B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:31:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hvWGxTwP;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J93IefE6R7bnCPulaKM+ijl/FGhARLRmiup15HlMn+w=;
	b=zPhD0sI1e6M7axxU7DFn8Zfa2GqFYX3/NSvXlJIAv0jny9lzP4GB+esc+5b7oN/lewAsvi
	gS0tbQv9nAgrOig3Nu+HoZjB8U02VvrG+Zh29WEBHv96z8kvqjWmzcdXUMxghgVK8gKH2f
	bcpaqPPbrYdNIycwtbIGQx/JbpKpO7s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662700;
	b=4zemwCXgwXQsppI+QcqaSouOThEByX9MCAuQm71tc7vy2odCn7qqoCRYxyO7tLFU6oeSTG
	Zn0qQdrJs2V7kegx7RGSCWC7j/8sR5//AphqeO1jCieasieLyF4OLcFjLO4Wa2fuEtf1g9
	/jhsXPjZ76umFuxsW4+0jX2ewOaNfbg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hvWGxTwP;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B807B601F1;
	Thu, 17 Sep 2026 16:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25AD1F00893;
	Thu, 17 Sep 2026 16:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662699;
	bh=J93IefE6R7bnCPulaKM+ijl/FGhARLRmiup15HlMn+w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hvWGxTwPbL/0y9ufvfrDERbVeXjXo3aoZIB10YSJrTS8MkFVudd31KyZ0me7D6CKV
	 v8MPABnXhm5bFydQm+c9Bc6WjOh5tvi0rJJR7brSEO2YC2qQ5rbcvTqS3l/wQM/wds
	 LP1lWhDX4Nho9nUMv8cFnzIJ2lbt37zMJcSpSszEjoLY0p6hqhcf1Gkuse+hX8lNu9
	 O9wvRJ/aTO5pCrRJr0roLnDiPI6n/AT7t3eg4apzoU8VOCn8Is6njfXpTZK1XnxYcr
	 +Y4DomJ/rkREqe3GVD6Dg2EyVmVfBhyny8WTcmatQUJuQRtNjnwyNtIE5Rx6vzun3g
	 eMpzLndJiKcmg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:26 +0100
Subject: [PATCH v3 17/40] mm/vma: add and use vma_[flags]_is_fixed_mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-17-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6504; i=ljs@kernel.org;
 h=from:subject:message-id; bh=CGrRM0X4xfz5KjQLNJ8DloCWWdgxK3gfJkwtQtlAo4A=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB9UL1NO3L9llvkhy4JF579KOp2dlSjtcWJjJtMVh
 7O//xkd7yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEXmkx/BViW/R4VcGp3Vfz
 nt89nHAh5sXRvi0Mfs3T5gRxc+3PXfeS4b/3uWN5rmu+FWXmTVZ59mc/p6u1RjqL5nr1W8ta64X
 OKTMBAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 305814000B
X-Stat-Signature: yhyor7zgwa9tjt6b7q7yp91zarh3nzit
X-Rspam-User: 
X-HE-Tag: 1789662700-390859
X-HE-Meta: U2FsdGVkX18ye/WjATyWCIbAd5mg6yg7fqOFtDgiH+bYCQF4w2sZ9UcLEGcmNo4apsdi7aHQ+wpBD/Yl7tHdXVgZaQ7om3Qqx41AbdkI3r5z9I2QxCHxSJkWFSo7x5nLXoyI8gktWK+fgEuaDAGadVYcW7SUNIAvvO+1CGrEdVSDZyLHnEthoEM5kj8e2rB6POqiSpHSb5FjPwD0kR38aLz+Eq5DRttC9kr2pF1zsqszOvIxP5rywzbdMv8PWETasbcvwK1HBhgnAH0DzkqjeT+ycxxIqxKFWNqeDqzeFkSC2Yb4QsPmgUObDAyrf0zs+zybSrD/UIO8UPuCgH8IehOjCtlznwiL+M0EOeIewDpEY9WuMjLNZ8ChBqa0WriFFe8w+loTiicYsvL6mQkQFfMZlcIi8kkAe66hXzIYKormV8iCGpYlKffgiK2XJsHvVvO76Fs0vDMNNMnAw5Il6k8dcF8TluEPUwg6rVAeeR1WnvGk1jHXUYJlPb94Jzrc2W38pgz4UVxNSF6qC0Q5cluZxcOBbq6AkkpIF8XfeLUefA0FZED5Hl171iYzfLyDpl6O45dSryEUXGpmDSVL+Y25C880RnH/Ryi6weAdTmN6onBhg78Svk0WvfZVbtE9MgHaSlOlJQh+AdAzR1Je5wL0uHAvmQNlsawzpNC2DUaeUzRzwpPtxKH74mqstOZZZQFAao7ciyxm+ygokboXW9nk5gvY9lqIYUhkN1XAmsXkNOa2z70gWlAqeH8L+WSfxx1+Nlvv8RtsnmpIaxASdkYV2KJ1qBbgOYtGfC868zQ8oYoWsmfi0suQI3sSP6qua9ESji+dUqWD28pz8ZWMk2f5u/0xO7kkpFlXav64ecTwvkP21suIDQSVHJTQzwgSRVjpXQbeMqi4eO+q4KVK9Zl7jPzEuj78MDAg7oV5iUwYKUcbxkl6UpfxwiGO5dHpCIUMRF8XiSrM1+LLOUz
 MXddb0g/
 RJXhSCgfZy8G1FnWsIWSaWv2olBqWFUt8jG0TsB5kwSEirl9ExDK6gslansEVfdzIWBys3GtX7m25NzJSLSQk2WcDEHcC81Pk1v4K6KwTIYeeLf/whH9dv0VxbsRm+gUl1kXjDtxwwMeyfDaB6FdiwSCL8N1OIoONbW0l2BFvAdmnz6PVRX/fNPf50LR1mzE/b+sfstsyw6V+1RKBRAiK9Q6nd6YqvuaNai5XgfoXR5oWGzWP1JYZO2SnBPmFTWqKP5IpKWeFH043R3uT0EGfsaf0H8SO0aRodEHN3Zp/H0q5ifRG3EVGVI316JBEHso7b8FXCllNXjgtxffRxES0TKPglxQiorylRR5nw2aB6l9taM4PbvWQ9eAUnnQT/jLg7QpvLt316L2CPx7D9ElD0+BZmR1OBek+CWrDrvG7+8pbontTDhJ0dFl+NfbK9xcJ2mOQIFs08B+rZnUKkjJw0P/U9Czq4fmCTkk5OJQBTtkx1/flFhvsa7RclALHKzsJwfKYlyi/wPi04MPBgWSOo4YISHVcybHEmc1pq2aGuzt22yVTIGwYlAw5SveYDNqIVsPA2YHMgN+VKBr4JVyZ3uWCsSspFo5L6/CqwiEhwDUEvAMzolTYh4uAityG8Zy4lhTm+y66D9yJ6lEe415KNP+G+cmM4QRweME8l2gfP6sbPuG80AdquqXRlHvj4NAW5b+xVAU/RciSFwtfPWeWCQ5n6pj3DXZzJMlNUZKrM/hrntFa+ETD7stUI1dASFyTmGM0mR+MW04Zn0ojPenWKyuyHLo8QQ5H5HUgB9nHrdqY+BvXmCwNsz2Cl6T619ww3HAP4J/+xpKlrDAPfomkRIOCcFfL5sHv5F3s8AFLcLx4j0SHGQwsULEkCZqAiDyZsfQUolXmq8sxN2lgtTVcbgyNt3L0H5fAe8KjoXl5zY4HMD2nZ8kI9zpBd3qXIdyhWyfMspbI9xTBb3azKBw81t+tMD+8
 PUAn0LMi
 Mwf/JSswebGtFsHmiNmegQbEsEK1izQ4Jt5tCKjFiI5jD+lVefEZJL7xuv3m1LQylk5dobrcnSqlcqNANR04stTaA0HpSt+NvwZsVCPd8SN15SR65wyGU/5NognZZp8EoFp6AsuGbYfWEAKQzJcgZTblnxOEinLFMU+lG4kcqZz39lX299rD4PJBBuKQEl4Scrhdxjb/diNDiQZDGugKfj/EuE0llrqFsMjV9aTkFcVybbniRcPTiD+vEWA3MZnQjZu3fCnouQegDO+J95bI1grL+jGkPlPFSLog5GxqdDcqCVI7q2DNu15Nz46PT4fgts6T+KsGQgjcAkPEkEwA6M8ZDunfET5BfupwO+5o52M+k5gLk4zyxKNTxOTC9Q7OZgtMVI8hiJhfzO9Vdpg1ousYkuBM9T5Cw1kCFov0eINwjfzKZE2HvYnRPCFCCirbQWlc66uCiUC2i5KV/2A3yflwJCKM7jkRq8gvK5rhBcihEEU3My0XcLLGDhbDws7TljthoHg49EVND2G+J9jCvQR3kiiRvURJaDZTWhI5UYDluijN6IPBrvLP6FH0noYL7wkB1Bhh0x9y0vC+qIF2kqjsP/Z4h1v9PhTp3EFOsKfU1dclvyHZ+wOu255wcSoltGHPBPMTBJqah8mJUqs6JsxdMXEYGankBkujvM8AsCBGG240EHp8RABhonA96E2I4LGkhJD66+D12rZnvd6AGx5nVDEuiAtvAJIV5cQtcAuW1AfnJavIrT7YU14dSbyXjPI0MzzFj3g4p5WVoLApC9T9sbAykm91mX5jVQ9Rq7HLnTDXnTMoloxVJWXFh9NQP/SiFjLFInqjEm+JmqeMDOj5t/F8bancP7r0juwMCjvJZAyjdS3NzeFIiFDiB7T6td7lblui0k+c5JEtZDuWPnKY+oMAxM5qcflBb/k62ehIaPWRjLEeXl2q2E3l77Ee4oZF7Napmc+LHE+nwyFzghGEq/BmQ
 tvEYgHFx
 uYR5xSQh+HCqWWuFj3Az0pn5urIPap5ZucJckMd44rdfmVF1tE9rHNoDxuZFgb6+WgNEptQ+NmqsSD4ZskuoHIiM7US7KT+Sbd7JzMx9LNUl0eeK40f+/JCgFCazpja3xtoSzvqc3oT52d8lryZUfxP6a3ENh040S/KvjmoC7S3KI3twqk+N6q31HiraW8PCkX7b7YiGgBMw++Nw6glWdjs2o8RKLto24SYKEFiESnSIj6AjKYFlxV1SIPucmiDTX0DvHCRtN+zClx3qfWjq+RzuUvL4lnSEeJD9O7p3Gscu5nYeWo5TJitA1Let3GQhrchUGoFnvr2JXUQ4ubPF8YM0bAxAHl8r3PEhMvVnJcyPxyv8plR7y80Toiu3KFetPkulXFn6e4IfHSa3nRiuvGNwIM/Ve5e1Qd4hJ+np6TAU0IRUaT7sgJd+uFoJt51UmNgqgYD5w+deRfgwSpY+cNqvwLVHxcxRhJyK82Oh7LtOHhfgKRSNCjHtzH4h0NAwWcl0hikTzV6/dGry9REz04O2UBmV2lbcHlGLIBpbXS1tCz5go9mnPIQl0gHKFjkNXzwoFoRyHG6u/6fGFVIO73eqDeKpM06ImoW0o1BaGoyYE8Yf756WLrpEySOr0rBThQAdZGWvcWz2GbZx7gihSJu5lpRnnXdA8OKCYi7h7v8sbifPihBVAGoh7p62JHq5PgbHYjV0NW+MCSXdOstSxvT+OeM6ZMWa5mLmDsElxgrqz5Hrr6661AFeeaud9qyxJufZECWFAMkQrDAWcjhykLTud6xlfEfeOFOkiTWco4XtFWRjAiQhIuka7z53ux1xjGwHHFuFJWIztAt1F+nYFpCOa0ZrV3vStA25bLC1wjytbWCR4+KtpHqhCF9KJ8mrM/unNoFxh7xs3ON4ffZh0Xd/L7U0bIUmKy88y6AAJDpchSrTJAuwwz9UE7sq1ed4GmVw4SeoDh2aVb4Yxoyd7AzGfwSss
 689I8GZl
 ejOQI4Y2NWPdkySDckcibChaNKCxy+Idfk8pOw4imdM7Y5ZDM9N7eFh6WX52IVL692uuyMh8glzrj7pIEblcSsmr+6yg5ZYBEI1FmTY9ROvOFAPMaLDcQ9ITCdArks4TXbqAHBrOOzflNbrvqcj/Z/h5Qqq5Ym68GloYPv7oigKynr4JgO6zTuNhN7uqv6m9Vzo9Eg8hmrJ2JDzC7GZPfLCvIae1nFCffdOp6Ffoht4kU2xEGSTtB/aeH0e45eN/4HY4N7/6+zymquu+eu3GFW7azDg6S1j1Vd6sX4dm5+Zkb1wnneIfBFsJUmw1sW/hkhOew4/mim57KkTv9okFFS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This determines whether a VMA cannot be expanded or merged because what
they mapped was determined to be a set size at mmap time.

This typically refers to kernel-owned mappings, however VMA_DONTEXPAND_BIT
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

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 39 +++++++++++++++++++++++++++++++++++----
 mm/huge_memory.c                | 11 +++++++----
 mm/mremap.c                     |  5 ++---
 tools/testing/vma/include/dup.h | 16 +++++++++++++++-
 4 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cab29d6e15c1..ca598e5f9715 100644
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
 
@@ -1650,6 +1647,40 @@ static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
 	return vma_flags_is_kernel_owned(&vma->flags);
 }
 
+/**
+ * vma_flags_is_fixed_mapping() - Do the specified VMA flags indicate that this
+ * is a fixed mapping that cannot be expanded or merged?
+ * @flags: The VMA flags to test.
+ *
+ * Fixed mappings are those whose size is set at the point of mmap (for
+ * instance, a kernel-owned mapping of a fixed range of memory), and thus
+ * cannot be expanded or merged.
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
@@ -1671,7 +1702,7 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 	if (vma_flags_is_kernel_owned(flags))
 		return false;
 	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+	if (vma_flags_is_fixed_mapping(flags))
 		return false;
 
 	return true;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4cd917f77f3f..4d0acd9a1099 100644
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
+	 * Kernel-owned mappings cannot be reliably reconstructed from page
+	 * faults, and fixed mappings (including hugetlb) may not be marked as
+	 * kernel-owned - precisely the mappings which cannot be merged.
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
index d09148ce2305..b8b1462ca710 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1676,6 +1676,20 @@ static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
 	return vma_flags_is_kernel_owned(&vma->flags);
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
 	if (vma_flags_is_kernel_owned(flags))
 		return false;
 	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+	if (vma_flags_is_fixed_mapping(flags))
 		return false;
 
 	return true;

-- 
2.55.0


