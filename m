Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 511C2C88E77
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6484C6B0095; Mon, 14 Sep 2026 11:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA066B0098; Mon, 14 Sep 2026 11:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8DF6B00A0; Mon, 14 Sep 2026 11:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 258986B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:11:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 670584010C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:11:56 +0000 (UTC)
X-FDA: 85212707832.24.CAF20E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8A22040002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:11:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WuslGyfN;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398714;
	b=fTkjwx9eUhqHZqX7S76wOyoNVqyBBGNdEAITBLiHGmeDusATiO6aUSQ87lGc1aCMv/zQ7x
	JuU1kXbwS2AaYL8mXeyhYZN7aFFly1JpOkuoQcdD3EXxMIsx6BJouj/oLGWULibz6PWlVP
	A19l7Bv7K0Qva6OMD5EK3LCJBuW1fv4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WuslGyfN;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vq7fcgcALBJ39CPNP6uq81Zf3R+8jGkfxEjZiI8t2so=;
	b=ramh+YzJwI4INfQryPXFGNBz85Aj4mcaXLCRBr0yujxtA5bM+H5uRrUGWH1Qiu9mUAn5NM
	q4+fKUzjO3i3hZYxjpHdhfBg2eY4a5Ed0EN5u/NF22PnkU2Y8DafRya8bK/wus9Mch+IAF
	ix2enjj4vgIhmqoyiNSzuPZOjExIg34=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D1851413F9;
	Mon, 14 Sep 2026 15:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8341F00893;
	Mon, 14 Sep 2026 15:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398713;
	bh=vq7fcgcALBJ39CPNP6uq81Zf3R+8jGkfxEjZiI8t2so=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WuslGyfNUlT1CCQAP2ixewiYe3QGwPMAcscEwGinA101zl+Wz7ee1DE+pKMnpLwgD
	 vZvTlOxuh1doZ+AdIStIdfdv6tz6PPCiJ7MG9oS5toTfGC9QeHj9IchxR9NUFcYaFy
	 K7fPSHm2yxQKoGoDbvzf+kVD8Ip6hB10Z7Vl257YUf2F+KpuTcIo2IiaWKFEJoqh/l
	 Ngx0XepAuVzjE2BB8m6CizrhpH4qwgO5Rs0Ndy2v+Y7UoyzkKxv0JNHW/S5PqZ6KRQ
	 UFtN9pzAlfOfayOHqD4O1uXyohbiH4mfpRdYovOoAXIZWceJGIZN9OKFxcHvLlblfZ
	 8kF7YyeW4jsng==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:47 +0100
Subject: [PATCH v2 27/40] mm: remove hugetlb_inline.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-27-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5564; i=ljs@kernel.org;
 h=from:subject:message-id; bh=7idMlWzMjKkLqO4T4MHFG35a8uf1UQ6cLeMTF/3U+1Q=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG/KWpt0QPvi3IYXLlE37UUfP9AMyGKVD2n686iYa
 5P+/a7/HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjI+20Mf7i9euUSTRm9tm4N
 6Aj75/d3+twJaQXX9i+8l2fPOa0yWpDhD5/Fmt2/eae3ffjtlnMlzHKSQcmfF4rxht73L+83197
 UxQMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8A22040002
X-Rspam-User: 
X-Stat-Signature: gzcf4yb13m5urqb5oaxaoo8c6zupykno
X-HE-Tag: 1789398714-529553
X-HE-Meta: U2FsdGVkX18DptnvmAwk6bW2VKo8iQn9gSNnHBz1yPlQamsKQZs/rIV0JH7u5ikQsp19kGbBYZJY9zJaygG6a1OwgWHJPuutVp/Gu3DuzqVMssMR8+ZQON6zkd54oXIEqYaNzPGseDoTacVlSSZprdoUgLoQ5UzD3IbTpnRnDOtL04FQjYLjgSlNN5zQK2oE75VfzOVtlEtpDG0nsBENIO+JW6KgdVxPaeyG4kJjt3gerIKeTuzSqFiW7wjASKZZpobsW7rFTUSsv+jE343z57YCaB0FEsoimo8DfuHFosLE8S7lT5Oro0ZQ63e5cAcLC0m4hSRaQzx0nV0url8xKOafel50FF1qoqysa9zERiGKOQ2zzvQCpW0EQTdIyEO183E+oOJ5CtIrEdpkOkgAL3L7f0U+zGE3Q6xM8URlHZMYaZYhQ6pndpUx25q4/mYt9Myq27FMv+SDhaWqJOqLkVaD3o/hdUy86mHSdm2AWRat+hO+Oxj2tiBMCHDZXq+t37SUlJ8TAx+zIP+FYGrOuL6v3IfUD0ObpKsibHjN1Ojwd4ZticVNXNtiImWoUBZMIVfbF7pZksdUIg8D/0aiSixfQ5NrZsuAjXW1ScFhZ8zS3KDXF85PY224LoXpphiq/qUzDG9LJlcho/1tBUynKnOsO+FEF7Ggu+P7zY3yga/CWlw/lji9YNsnPdWyz/x7cylsFghHjqblgz2/dps6+dtgEED8iAwpxR8pRNossMWxkR0N8GBtCvbGnBqB6/UETFRIMWH2xXWpcSzG7P4MhXDdz+bCKxF5nJJncMhd6Wz72G8L94EL0kj0pT2vI+WgvssQV2PXNsBSiIafs4VgT1R5W5CKdolpPsrLx4MzeWVWkMscYcZteOUJaF0m3C/f/CpQVrzBCoHF5aNLNPIrazEwfet8rKye4yqzcbrpew30sKupzulZWMqnsHzdhSiA5Y2R5qYtSRKCASbQxbI
 un9lD7bw
 mTrbWoxc43g9uY57/Ky/c0mipKDQvfDBwpEfizRlo7oDTGbeSOyWvEvRz0BvHZkllfIIIB46ukZn/u8fh5ECaWjUtZWvTZJZUljdOdD8trDMV2DZhlZ5iUf6kjvTHK42rV/jvOuIwbSvF6pvEKi3Fz4LtpBt5SR5ySpHpX99uyws7qdgYHrHUE1ZXP48vWtmsJSeHH0UYGSD7fZjwGoqbkQKZFPgJqU/oPI7xnhtgl+vWumbkAJWqZPLNWV3rhmsYJJ66rV5gdr2BM1qymaBwRXX9F5pE680PN/56rEce8tsfsDW90/sLC3NpIynGEbPKmIH3qXH8xwhRKZ3hZ22g/0ETYg1HU7y1X+n9g87BrEy2s9XaD+oSx8R5vO2I92hTzYHwAiaF+ofrfzRJ6F2mxzDiSI7WOzfSHiCiXGf6cOv9PsXr2PhYwk1bT0aNfLuzRoUBp8Yw+TRN8+G2nzUKJ3v6xxGTW3LUGznj3eqP+AC6YDlbBxoZ1YGc2rEwvcJLpq32oNRpSJxt3j2CukIC8brX77DcB8cWuW8uMOYFoIZdCNAAhwI05+9c3sAiOCkBmD8mExFFoGsLYUtGqH32V4UqfYF/klzI6CEk11gaKMnlI2gN8dCnUoeAMdKGIEXn/pcrQUeovFl6IrCh0h3odnRmF33tnSw/7LrM78dxqr/IrVK563ZALpXJ4JdZbCFGbvuPDvRYf78CPfJ+GtY+fzqbFuhu9AdhDoe6RNQLeJO2LFhhpykKL7jK5G978ZP4/krOLrK7e1OBr6y2wDAIJ28lVrcHdyrUAl9BFpNDxiOXdQgpzuqaubJlBj836f/TQtXREhijex0aB10mGqLlR7WO3Bi0pV/7wmjzWQjRU8EwJzfg53beGeCzjvVstR96mhIwp+HNJ9fnyQBhrxBFLvVNeq6SdEIVJKZK9ryvsjte5Mpq3qFfoq+mWtfD9oFKux7hJfgB5Io5WTqSbjQ87YzRg3NE
 mP1Yvx1B
 hQiJ0OkysbcXj5SLyMMxFow3u920mbI7L68QuTvtA+pZUlbaOiJ2Lwm3rcL4Mj0v42cWvIfO6hXYYq3NHnDz/vv1cQ5tZYUtgqbEF+1lovXywchQF+AVuzzbmQROvV8P3KVdYLdpEbgDp2j/nwmupSOXQBWNmF+Yea/rVZGerPer47HFZpkwkYPyOiJYPShqI1wukR/7tMuXZyc158wliXyxtv8VIlcnikvou1x/1wpve3aAuvm6qu3qFtcEEiwJzwyOau/yl0dpCYfeYGNXdu6GU3x4LayFGDX680aywTGv1s3d7AY3VMeNFrZlhBlm3gFfrdGe/rR4o5EftVzecCchF4foaXtGeRFo2JdtOjs9bRW8u2m4QCqL2+YmA1VsGzkTgAxYag5ss3Sh73jZCATnImZRTJxpPN2JCgRTsZUmF990qUweSFVn2ClXoaaoKS9wMh9Uzvydnj66DZ7ZD5t4P/A2UUo+c100meSuxtaeG2mrrtWsyU0GSW7jOew2fNbkoGxrsGttUIka4LaVhMSDsLWEQNLgJvaSaQQJflIayGgYhFnoVyZjuHbzN/AQBwpiHa7DibbwqZkoXExNtE7SgjF89lVJXqFQmSUlglowmeGbE1dfmt5gOSr5yobFy5XV8QHJ4/8zDYPzowRQym/pVWRphDq+6sHm414cLEGRQVbNolFLbog7aXrr39gt5bNZiNQkwdpdHLD7CEjP+R1CaqyTc2+FIYSnG40fMafjuewtT8ZnMN7QoiDQH3ZvWvez3KhwUhhTzScTKEXG1CCHZlU90ouBY9LU7UDMQZrE6lPkDyvDTHvwX7BRzDFkTHDSZYE5nq9C20DXPLhRySVfGLQ8LWWqxzu+PqqIv5pczlNHDCcsevEk2j+dDZXJa9BO4RAYVc16iAfmMYaOQpZD5ebDCpw04XT9f6m1UExdEdyQws4OD9XRqNkPwD62sr9jupvn0zq9BbCgQ54b9rKy5q2Kz
 +pjBBZmj
 u2L6uxM0Y4m9px9RMOUJDpC1pxTZDye+NuwhZecAG6PGMFEa3ZOJHzi2/6yClVd3172IiT+hBKuIA7NL1b6JLHay8ousinE42C1NmoaEVAA5bcbEOE0dZRHYvmmq2x/RnZvkAZ0uLdRBAemWl39FEasMN75QmixinhAzG3USevLzuNkW1rQzKXUZcwHZvJKJ3lCLNosmyPYfT29ZRsAkI4hvDRrkZ0viiiuCaviCsed3Lg283DwIju1ySS2ejeHq1T8ln0qcxdUPklqqoCgWadrQGpjYSFNwviu8u0hqy38H+/G2uZSx2dY7D3iltDhGc/37vj1I/afn97dbG49KKRP6n/YEneFRTwEIUtfNyy4JoEOV7NHTNRAHKAx5i+VLh7viQ+1GcjYGOqryDna0olHLMv3i48Bb84VwA+grRJjEGfCb1E0YxY8ELm95+XUL6pmfNfkwDEwHjyZ+w2yEOz1jB7xeZmbWpbVM+J/4vzVPVHDHyrc5eY1Ed4bkKaeFX/grJ+tAZ0fHKthugv0ZjeCRGrYTXhe4u4/uu/Hxy/lGfqYXTLfR/R3SS2/BCilMDESTDJxk0MF5KBQNfxIjM5J6qFZE5IbNi3C5a14rHgFJ7hmOQ8VS1qJ6xO/fR8MqLXfJ0aQwB4BlJMT2su8EzH6lmrvo/AING+MviYEkdlTkheA5WoAwWAAaK/cRVm32QbwaGZfl0XAqBqjaOBDIgxmRy1HN9XM0Ne+PXS/z+284Oxab2Mflt1+KGrPPF6jW5EqEL0VvQ/NeoKk1U8zeoX3TZpBdRebZmzCOWe6zlTZmiYe3mBYGj7/FY0EjKljhxjwsN7vw7l5uSohLlSbJklOPhcGOVs+LxmDkAwTBqYK7CGHDimhwgRkzHh2zACqGZX62hh4CKpPqCMolj1qRrHLrI7tj63X1TqQgeeV9fbUbmrdTd77syz6htoVeUyk9pEJp+2tyB9dkdjg1+FnPNizN9CaB6
 yIzn3c7S
 j2dNY/0BHIp0cX+FyAfe5qhSepNue6OXInhQK6dZPb59Qsces/FFf9db5meH7wTasgc3lR+zzPKN2O81sYYX0uNTGqsnGng7v/VtxG6cle8r+cGGULGIqNC3cuVdShEgQh/FYI/B/kO6Ugbs1VjWnSIn4CphBaAHouhALkVVTG2Irfgnq40Ulz8AMfgVPvAjRD3PUouFK4gRNZYyVQ2C3neUUiWqvGZBezGkaE6e2jmwlrlHCPSSS2e5NJFFymx2BAdQ3t+fdSpW5xnmnSn9Dtzx2uqaL+1NjEn17Vs0M75GkUFANVuACN9IwPyDHBcPHu1PZ2CwibUhxCKm2SNfBfhCBsF3qG+fyM+Mxxwf6HKwOp+Xvz8Yyzf3AnS8Ic+RVzL5x6fjCYK9NgLe/XnkyaUuCTLxqs85QTJU28ozU4kBIgetJneeeRnKQdAvDL+rB0nvoPnFMZgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This header really makes little sense - every place it is included mm.h is
also included, and the header itself includes mm.h, so it does nothing to
reduce header size.

It also oddly does an #ifdef around checking VMA_HUGETLB_BIT, however
VMA_HUGETLB_BIT is unconditionally available, and will never be set if
hugetlb is not enabled.

Simply remove the header, eliminate the odd ifdeffery and place the
predicates in mm.h.

The naming of these predicates is odd, but to keep changes separate, we
will address this in a separate patch.

The file was never put into MAINTAINERS so there's no change required
there.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/gpu/drm/drm_gpusvm.c   |  2 +-
 include/asm-generic/tlb.h      |  2 +-
 include/linux/hugetlb.h        |  1 -
 include/linux/hugetlb_inline.h | 28 ----------------------------
 include/linux/mm.h             | 11 +++++++++++
 include/linux/pagemap.h        |  1 -
 include/linux/userfaultfd_k.h  |  1 -
 kernel/sched/fair.c            |  1 -
 mm/vma_internal.h              |  1 -
 9 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index a93eee7ddb9e..793dacec2100 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -9,9 +9,9 @@
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
 #include <linux/hmm.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/memremap.h>
 #include <linux/mm_types.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 
 #include <drm/drm_device.h>
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 044dabc1fe9c..8b8123e5b7d7 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -11,9 +11,9 @@
 #ifndef _ASM_GENERIC__TLB_H
 #define _ASM_GENERIC__TLB_H
 
+#include <linux/mm.h>
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
-#include <linux/hugetlb_inline.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 80a5a03e9cee..d7e6563cef75 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -7,7 +7,6 @@
 #include <linux/mm_types.h>
 #include <linux/mmdebug.h>
 #include <linux/fs.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
 #include <linux/page_ref.h>
 #include <linux/list.h>
diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
deleted file mode 100644
index 5c29cd3223a1..000000000000
--- a/include/linux/hugetlb_inline.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_HUGETLB_INLINE_H
-#define _LINUX_HUGETLB_INLINE_H
-
-#include <linux/mm.h>
-
-#ifdef CONFIG_HUGETLB_PAGE
-
-static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
-{
-	return vma_flags_test(flags, VMA_HUGETLB_BIT);
-}
-
-#else
-
-static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
-{
-	return false;
-}
-
-#endif
-
-static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
-{
-	return is_vma_hugetlb_flags(&vma->flags);
-}
-
-#endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4b6aa0b47b00..726c2fee35fb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1609,6 +1609,17 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
+{
+	return IS_ENABLED(CONFIG_HUGETLB_PAGE) &&
+	       vma_flags_test(flags, VMA_HUGETLB_BIT);
+}
+
+static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
+{
+	return is_vma_hugetlb_flags(&vma->flags);
+}
+
 /**
  * vma_flags_is_kernel_owned() - Do the specified VMA flags indicate that the
  * contents of the VMA are owned by the kernel rather than the core mm?
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 939f3a5e973f..d7d8b312466c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -14,7 +14,6 @@
 #include <linux/gfp.h>
 #include <linux/bitops.h>
 #include <linux/hardirq.h> /* for in_interrupt() */
-#include <linux/hugetlb_inline.h>
 
 struct folio_batch;
 
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index a4351cffc60c..a14b8a9ffb7b 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -18,7 +18,6 @@
 #include <linux/swap.h>
 #include <linux/leafops.h>
 #include <asm-generic/pgtable_uffd.h>
-#include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
 #define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a71f0ab79bcd..c75b5c50af30 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -22,7 +22,6 @@
  */
 #include <linux/energy_model.h>
 #include <linux/mmap_lock.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/jiffies.h>
 #include <linux/mm_api.h>
 #include <linux/highmem.h>
diff --git a/mm/vma_internal.h b/mm/vma_internal.h
index 4d300e7bbaf4..4f73f0a4db79 100644
--- a/mm/vma_internal.h
+++ b/mm/vma_internal.h
@@ -18,7 +18,6 @@
 #include <linux/fs.h>
 #include <linux/huge_mm.h>
 #include <linux/hugetlb.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/kernel.h>
 #include <linux/ksm.h>
 #include <linux/khugepaged.h>

-- 
2.55.0


