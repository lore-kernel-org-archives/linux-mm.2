Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C53F0C982D9
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB666B00B1; Thu, 17 Sep 2026 12:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAC886B00B2; Thu, 17 Sep 2026 12:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F176B00B3; Thu, 17 Sep 2026 12:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 740F26B00B1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:34:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F30458039E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:34:14 +0000 (UTC)
X-FDA: 85223801628.03.3C4EE7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 22E991C0006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:34:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pyt7zq3w;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662853;
	b=hqqcW/ZV0wkOJhIph/3TIK2IhKYBaf8XJ/wCjyQlusQDsnSiZf3PlpfiUais3ji9CED8ow
	n29NsJkzOp5tuqN/h81D5PNIlSLZeLJWKnmLoG5r48oyZGPO5bOkqTGXX8xCGpZLz+wp2i
	8kTMFER/jXeWxD4ZXye46ZQ9NY5977o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pyt7zq3w;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfRJzELhUA3zmjv637fDp+tblD+oWrGBxslIXX4F7cw=;
	b=RsKVBeQCfKmOieZi25V/rDMdwlWcoqjcNz4BIsjACs+WZLA0wjnc3vMfijJ3YZR7C/HMm2
	ZKow+AEpnJ2n0zKDe49cZM8yGIhwCxny9LsOJP1iCj+s9OTLmiFrjzGRZK7obdI4zzEtbR
	/AofMpvXBP3CA53T+fbDHZhQEz195lc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 511BF41683;
	Thu, 17 Sep 2026 16:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5968D1F00893;
	Thu, 17 Sep 2026 16:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662852;
	bh=GfRJzELhUA3zmjv637fDp+tblD+oWrGBxslIXX4F7cw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Pyt7zq3wVrUAhNpXFXSuMVbDH6B9z27BuC4N5wSlqvK2YZ+YYcE38ItXJSygGLBUo
	 jAOODUNiB8Hl2Z9TIS2vNbKclQyw54/sJwA+VbvsXDn0TD6r5o228/oBdRI3ZVNXtE
	 Vn6qrdsda/Xfpp6xcB32G5ie9VvVYF6zK2oGcw7N0Tr0KugM/8h8+9skPGKu81Fu1v
	 dUTlbWz+k5DmldJr+jaFMBP1ti+JPFxPgg1webbI7hC3+m22mXIypG2Kegwu62ONHh
	 IphxagghomlS1XLWIPjchqsW+MqR5DhD81KyMXcMv4/F4ESQ4UCrMz8qtzU5tzkm2V
	 9qfYZxVjVZdRw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:31 +0100
Subject: [PATCH v3 22/40] uprobes: remove VM_IO, set VM_MIXEDMAP for mapped
 kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-22-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2070; i=ljs@kernel.org;
 h=from:subject:message-id; bh=joQXUjvjM3OjL+Ta6QEJ1w5g7Vsv4M79ot1AULAZKpk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB/q4Fj8329FrtbDMiFFC29ptVwduSnTb/sdWLDt6
 EPNQz15HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhIjAYjQysXc4jOXOkLizqe
 C2g/vP3cILJezzj8ioBasHvjo9+dNYwMOz/GLnqz6VVSzVbf/sX67g2LDpjmmxbucpy7/tS7Rzs
 a2AE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 22E991C0006
X-Rspam-User: 
X-Stat-Signature: skyqa7xfsgfigakbsam7i9gpsh9fodiu
X-HE-Tag: 1789662852-386478
X-HE-Meta: U2FsdGVkX1/Wz3mxNIsFFGPQH5lQrHWN7ygxZHvxkh6L7FGgzBo7B5PKRYwwclGREVHYs5uUTpIFgVw2L8JaQaWhxVeYaDDz9EaJSxvBmrOyuP1QuFo3rs0AQNLabltGWi4sPH2ZeVu1NFjc8ACQZLNx8orezXXgT5h237gR8jJUskJdtB6/FnRFGcAvI9zKQVcMX0CaFxlFRGaSChltMmwmv52R6wTi2MzNEO4MhrgDaVVgeYNrX/A63m6fgil0H58yJsqRor1ZynsPXNLAnhk5NFamP+VYa5+mXb5voeqrY61BX6rEah47xNAJ3dhl2M+CanNGXZZ3W8S0gJ7weyXq7Bhcxvd63YSH8OiKi2ejjSLvjdFkPazUtG3QmvAA9XH0w82/RWx9jLiASXh9qZx3cgX3nQ7IGNi9D6Hd1Lpz7UKCbLMn5Ne00vRHhdiZVzDNVvUcOu7orUXWFZnBPSuLiWTFMJjk30WoOU8XUA2/lPePUUbpLqG5El/1rJNnL3j65DRrQcrqsNmDxPC8W+xFSf0ABg/kOVfj9QYtyV+tzBI9SuD9uBJFrkbqhlar2MIoWH8l1YarTJarRwniuRFz7WuybTnzO8arNeOgYTrVlMKrUsoZMOimx9vXVC30WjYEdXY7vMsEbwdc7IrTPIVEpMqDfXJ8DGGudere9d+zf3kA3PACI7eQrPUgCUwrbVGmOCv3Ccgl+zXaOcE3DxMoQOVFCX3YI/VLbt6ZrVKpk74tYTU1lzC4Q5i3DmvaLWpuu3xsh5So0hGe42A/qIWWcL8oBcc2L905DzCvmA7yP7kqIGn0datUQgdIFzCixA24l+JFnQKYD9sxC1QOQUZL2Jdxld2myCVoPC4dbIfZZLSlzG4ULcI5N3bZj5jD7FQrto1nHDi1x03+hxZAKfbqacRtx3r7+fPR2cbtCj6FUnyp1sCT/emUslM8aNOlOVWlUgHEuagX08W6Kcg
 SqhrNWvI
 XjhVcdavvBvoiG/sPCzq5FvOH/WzchMmEZOkTD+2XeGMHiYoi3WIjtPARV+S941uN88bP4v+2OMlmWxgYHdKNXeODf+BSsnBOkEj19KDibZUVekn5q1xP0jkGmfYRweeW3zs2lHvVRyR2W4YYCD4a5ZbY6MovdFSadsaEudchhdLZnCVZMf08N1XdgjvV41vPGlqw15GjLqyIZZas3VFVxgEZNdxCc9EaU1aiHgW1EQG9TXGCaqdAsUZE5SvFBL2Y0+iT4/WiGy/IPffCXYyJSSTrigBlGxIk1GjGKq2GqPWQrc5xZxjDUkUUSc1qQzWVDnTN2Sq7t2zDY+NteubPhvMvt0tpPIbRmh5MXR4hsBiPqmmz2uTrzmQ+n1QcftTqlO7LIaRkTGWA7FFGVcVrzdJZBQGq0P/ItZZ1IEBvMaiir5t/CAsG9yTstcgrwZvza88WpnT0EBmuBwTq31qqyYIj0u45CaMpG28qEWX4B1Xngn1PCm1iLM1JjD5E3DNtot3tyNh1cc2rNUpLjcEOlx49hf/P+EfH18DMb96FsbEITbyu8vIJwodHYAVS4+AMA+k24IvKyH2Jvyxde7KrnD/hMCsiQM0sTVJjPh9z6oXGamH6xbLlhBHyqp5IFtlmIiUSVRFpT6AmosvbUmsBbksrn93yuWtveWg3dzb/a0ZmOfFj+/CQFo8tQoja5dFpwUCczzzLigkmOQQ4/TsonXYEdQsNDp5YO2ZlT5KiZLdr4QQQ1HIbxhK1EzFjqsN1FsI76M8/XniaPaTHzbmPiL1wC2SiWvOLq3XoZxlCR/QMGVSwNUStS/7BprdeqjtyId01uZmlU0piwnDizeZI43GhQ1MTqN/I8LzS631U8pHUmz++YeZvbdKWo6zJhGHgT7BR/PXZvCKugKNwYgAvNJcZJEcBDMeBHoxw8G0uoLj+e2O2uWeT15a5a2//N6L13C1OY3F94WXsZ5Fm/VtCT87fhPeJ
 1VPd7qP5
 i0hkgl48wv7dDCYWm7KcG8VKdclJRh9Pkxk/tsHR4OjkkQ8fHYcYWkoO6Am3pz4aXhv8gfTdEoHBL7VbAA+f/6m0Zz/xUV0FrWanNYewRGt9lB2B2PS9gnMHglx43crnj4hnn16fj7ilgRF1zM9TM7cDYvwtSi5mEf9ntPux2sRUbC90peR/8pGv35pFQDIhCsexllUTCu5t8Ie/gHRT0EwZHuntwfk24OvaFw/KiLdjrYNUTPiTE1eaNcckl+n1RRjj2Blp0itnBbZcxUGiVWogEjwHjZ0CaqwXOsVJ/nGHnlSL2cXEva4Lfbhcj3HiSuaaUDJrX0H+vtQoLOB9pJJwX9iOawLYePgZRovlEH49mjJpI0MJFr4YS7mz350HD3gEcK21a9wP4sYtZNniLXgum8uUSVy0EyPYzUCRZHiPmIvAk2egIlMpVaeiLCCJPiDFmwWUy0GZJeFmD0FNC8xoL/npG8b/1AUTGidYDBYMaoI319ONDXC/8n3ggaroCTPBM11zISOiZlVd/rbR6T4RumrL9knklz79LFj1r494dYe3tQPsM6CAeEqIzTCt4uPTg5UYhiK9UQcI6XGuHfJoEj10VAoP1AHwWUYf4OrDhH/TfxRIBI1qTxFEAHE3rykA892WCl6VVlKmKswlAFScZTFMEUD/at0ho/R9xZUt7FR8cmYXEX5SvCl2ifQwytU4eaqAyx90IcGcidM4esb8Kxlmi1pyb7Nvd+uN8A+Ia9skOxbdZUg8JeDM8/bY/q6E7kzQVSNNf/9Ggh8YfXya8At82NS7mV1Hg0wO/jQucpA8tG1BRv8ndxoOJVi6c5wy6ImMR8Z6eL4wdltCF4pWMfIQsgVFxop3tPB+sHedO+NTK7U/y/3lAy/S0IK3OHM+9rUHTJ+ozrD6KPoTaaF5HmXvdQ0uqFrWYfH3ytQ5aRBOeCmxmd6VId6nUurFy9miJhuahDtC0xD3BxYB6E5UohDHF
 jvVO1QBN
 9JH29u7s7o6XaB48EoslTLpqH0s2ffz/5QSXaomo03GYY5XFFo2jrADBoPeC5jGrMJKJ+hziE8NwglQLjioXV5UP9GHOuYhOCceB/dT6bUsP5HB8Q0EJz0L7cbn74F3cG10nVGwYGMTK2fV7r9+3NvB8IY2qU/R7J+gilDWuKH+KOztgZVzyf/1eqzKtazISH18FlWgogzBkiDLuWLpi3ZE6jbobjYbmzph26Q7yl5nJNB+kdkb3btLXJJejGmyZACGo1WccrmsR3iteRUVGX4wwpIWoPXm89V9An3GhyhjT0jMGE7LNl8Ps8dR2YmrXD04H9KZm3OaB3ho1zqr5KcYBBwjInBARaIquPax+g7R5UWYp7G/HLh8c7AjWu1Dm5lFMRJoAxCeAEwDAAEru/FiB/CTMcKHNuOsTPz8g30oIJaF9B7LgdcwboLx3/jYfIqdFa62P34/s1uV5LxOGHXiKWG85wXxuNTx19Q5OSn5PJesTIQNHiAhF/6f9QJJTk/mS0ni0c/Q3s3XXazgtpv2ayajbob6GaqzstC1afgkIsaXFxzIhNF1xndOG3wp565rrmiExuPxSCqTy8A8XzExAi1JK7emgaSKHrvte+7WDiHOZM5sAMaRuPQZLvRj4LmmKJ9ioDkk8b01zIc0ClDyhMeOoQuz2MjEKiSIPV91V0zxD9EEKhpD+Cz19t9Dua0Ih7kd6g514rAiuxWZwcixJyRWHXsgaQjH7FKCYipPleb5YqgzPm5T5cXFpURwZmhFokwoJcezwQwi4QTmW7ywIs6y9TAVvDpOXCum5kTthPEDnFTUt7LsxyvMQ0Oth9p0a5lyyZygt5i3+dHPdsUDPho5VKbyjksH6LXqMThXul2MJSvLMLl2qzD0/jfdub3WLoDu0fkcn6DjRG7SOyTZqwEGyx01VoJqf4kSXH+iwOvb4PF6JaIEeho0c2L1Xa/0ILeK//8N0SpLE5Xmz1Zw+DIl76
 gh0DzR8T
 8a+F9788OHqNpeKu31gXM+M1W5s5eaGY/buG4EIapNZ1MASwe7DFHSySb5BS9E47pZkZJMKBs7zvjA6QPX3YqhtFs1ODOi3ORCIZwRuHABdStNVoKE4Nyvn3BN7aTorpbWHW02/bDZBq1y0xPuHLjj+LKa4uCu1WgeY7P49wFU2h87jU2oiJCszo7ffO78beF8u7sJmmWdKFIF1rMmRUBAuTNnBW64t2LF8azCLBnHzMY5Vddx50NF9ZDv74AWpOKs9w2OGu9iz1bnSuGSpT71SC/BHyfM/pBqk/bAsLQq4qC3qUV+3cPexxAJZiq+syD111uzCA57ogYhyXiOprh8658ZwIOAixC0PKB9MBMUfxcbzpCxZjTL8qF0ak9J5synObu4VRImHlFTX7f8KXCPfqTwY7Sbx6warc0/Gujw0wSjIyiM4JcCy+8teJGLpCC8d/K7PkppTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are not MMIO pages so VMA_IO_BIT is an inappropriate flag to set.

Instead, set them VMA_MIXEDMAP_BIT as they are kernel mappings and this is
the appropriate flag to set for those.

This provides the semantics required - no VMA merging is permitted, but
does not prevent GUP.

However this has no meaningful impact as these are refcounted and thus can
be GUPed.

A previous commit already prevented __mm_populate() from being invoked on
XOL areas, which VMA_IO_BIT was previously relied upon to do, so that is no
longer required.

Both VMAs set a VMA name, so always_dump_vma() returns true before
vma_dump_size() reaches its VMA_IO_BIT check, and thus there is no change
in core dump behaviour.

Change this for both the core xol_add_vma() function and the x86-specific
get_uprobe_trampoline() function.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/x86/kernel/uprobes.c | 2 +-
 kernel/events/uprobes.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 65a2de82ecd2..0f60c0d076b6 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -715,7 +715,7 @@ static struct vm_area_struct *get_uprobe_trampoline(struct mm_struct *mm, unsign
 
 	*new_mapping = true;
 	return _install_special_mapping(mm, vaddr, PAGE_SIZE,
-				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_IO,
+				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_MIXEDMAP,
 				&tramp_mapping);
 }
 
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 7709ea882477..b89cc5cee002 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1726,8 +1726,8 @@ static int xol_add_vma(struct mm_struct *mm, struct xol_area *area)
 	}
 
 	vma = _install_special_mapping(mm, area->vaddr, PAGE_SIZE,
-				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|VM_IO|
-				VM_SEALED_SYSMAP,
+				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|
+				VM_MIXEDMAP|VM_SEALED_SYSMAP,
 				&xol_mapping);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);

-- 
2.55.0


