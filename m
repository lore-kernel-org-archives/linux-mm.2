Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32A62CA5FF0
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46C296B00CD; Sat,  3 Oct 2026 12:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4429C6B00CE; Sat,  3 Oct 2026 12:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3313F6B00CF; Sat,  3 Oct 2026 12:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FD956B00CD
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:46:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92EE9120A11
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:46:36 +0000 (UTC)
X-FDA: 85281893592.22.978001C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DFC771A0002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:46:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ku6FBW49;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2aQUzTUuuuNI/ysultBnvmSy0Vxb53qrqOM+R0btIA=;
	b=qCEVP6BGbf/eeufikn0xfAR5H37/RTUWI9xCW6Prs/YeNVOtJGUb3sRVwmXRWWveZmJdSB
	rTOh/QDxaanEZyoDBMbN/PUX9Nbrv96Jk/E/0omBvXJQD/w5QM7GKwfpQZzu0s5n05X1cc
	j54AnTJ1m8t9Fny3gapd1dkvryQwUZA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ku6FBW49;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045994;
	b=YeXd/2w/3ej6xu+hGjkLVejYnjTgI2FKNQlzq0L1WkiPzyPMuKvmlaVzzpSBMktJnilJUi
	/1Iinm9unrfI7nLVQzXJ/D9+P/OKtmNptBgxTsjQe5x7/QqRSS6IuQiHG3aAcN9hhq7b4N
	Xo/9TlDRmJc0ObYF4DNzdMr8h7xKEMY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57F1B60D82;
	Sat,  3 Oct 2026 16:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4771F1F0089D;
	Sat,  3 Oct 2026 16:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045994;
	bh=Q2aQUzTUuuuNI/ysultBnvmSy0Vxb53qrqOM+R0btIA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ku6FBW49LPAkrwvQYvPuhG2A9tZpaFs5wAVnWBb1CxSYOUntmmdE1VzT+g3vHRCB/
	 wAI8gvD2dZL3efLWLd9O8T1aBHFt76hZy4DjBEN67LI8r+TKjfTLfZ1LcfJjSoq5+D
	 +/zObojgb5XSiK+6OwavP1gL0bJvpwBljQcr1aIibko31uj3P4WFnOTzxune1P1SGG
	 /wBneoTIxJM0Zf2gK7F3Bw5NBWnxNSx7st9EJvqpBIDEefq704llAKSmffFlYxfLxA
	 0Lvz4jR9pJclNhlTuW76CdWrPw9kP3j8TEfJufylQMl8ExSw15xn9ckeLY4N525Cu0
	 //BE35soPRm+w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:33:09 +0100
Subject: [PATCH v4 38/38] mm/huge_memory: remove vma_is_special_huge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-38-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2917; i=ljs@kernel.org;
 h=from:subject:message-id; bh=I2iSzq1wq3BUA5ngKyuzaIh6bRjYfHM3M8Ib2DX8Eao=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6unadC65lrS76vCNF1OzrsrvEpqY9vDlynom6cMPX
 x7Sl2b/1lHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJzPZmZFi2XDJ0sWkRt8N8
 cbMd8lv5l/B9fVSztabELN68e1nwsqeMDFv2Fth8nu96gft8z+oDq4XeefVsFD9/dSfr+Uoj04l
 H//ABAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: DFC771A0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: nzmh3xbmno3q5u5dousqbbjox9piwa9s
X-HE-Tag: 1791045994-295436
X-HE-Meta: U2FsdGVkX1+QzWUq7AGtJs+6wllgLl9EkYcjijLZjfZzWAm7VOfa8kwxG8KpERivLVPoJreWaEjbtV0hyWV4w5B/JCfXrEiBNYeOWuSHE3kl8FjjOCzcOm/kjKuKLw+tib/u+RK/vhevLZSmhHjNNieZp5yIuSiIcS0aMhaCl9t4DHcjQNMyhmbMdyIrxbel8nDwwzFMRZsYrCAVj2OdJvWQfnKfFjyxTXZBuQxQRHmy7aHt1vieL4wzqdFB2w9kWGQakG8mnbvl78V5l8Z77VCGz6uqhPBxvTwTwYMt9szvvjv7YYGy1Zknu8WGdAF2UOG2d+LM5n9/lrjLO8j6/do4IIeZSaCaWM/K8yj7PoLFLMujAhECN4dpN1lrw1ZYgd3v7ae7XLtoUrpyPv8VO+uV59G3vHOz0otXOuv+inDJ/b1uEuj/NaFLxgSGzi42erYnKwz2+iOH33gRccDbUdnFeR3ZETM8khM8AMXRdw40qcPVdsPnJQGdAXZH3yEc47BeIYfPcjYdh3qsfzPTPtno6wAcgIb9SuXS3kzsp1wlYPoB/vfgSH8zq+BDdVF8aVNUqQduNmw+CUAtftTJDt5SwdR9tWb00WyfOV/40pVbncypDYAAbnGZECc/gSqeUj0AuxA2TAZWsfpq16z4XHSm6+fG+4gcb9A3qJqd9Jhgb0FZ96NNAsWbfll5wvKonUx9FPH2UjHXIRLcUSyGoULC6J5xmpLdqPB7gzcfot4JvNrI1E7IzhWvLvVImRwPy0lpWK/lc6mLGUxIiEJmxDyECl0yubLPt4Z1Gzm5m0hpoAQ14QrJ71nltXZpIoaqIVUV52U+0BIgPbfSRZuA1luHpHx3fb42A4zGU8d9OtunfJ0gSrRj+IbX6S9PcqlmF9/gRiBqSpAT4ovIZDnZMGfMASPY2cZr5YECFFfqXbwa0pyPx/ntuaZBvj5P2f/Qib8ya2j6mzq5DLfiCVb
 DVXCWwbz
 p+WxPCGZ1vA0b707jV8fAA0JCdibuBDOG1GmAMuHtIag1AnhnsnYvBSlfMEd68+ZqkcxOeB6Isw11tvRQHe0G6SdsUUrs40CUG+3DMc7/qcyDOhFZ4z216ADwDDt9ST0YLJiTVy6+wdxhCG9EdknDm4q2zORtRs2e1JEYOqckT3urxvwzfURg+Fqx3Ksa3MPvFKA6aXASzT6mWPodk467vpkLrHWVDHlHDoQfT1uDa3rhpJhUstC0M0yPgd/Piwc3+NcfCip45glOq3gnl4MlYLamr8IbWhiNfQ1Yx8LvVGJRvAIRloTsCt793M7/8H+/bDyn31n4P6kuq7mUPbfFZei5Bh47GDxr118QcAck8xwTuFGVSwNxtVtVHKsT2g1lzl/hnq1/un4rA+0OIHlmFNnazXm4leAwlaSy23tigeyuv7QSroaelno/J7K0DuXlPExwey5K9UCq9agkkA5hm5cFW6JH+939H/87nDTT/w3Cw43xZ9kcAITvWpv1jaJXvXAi+ByqcBy2clxGO6i32NNnVkR/srukXthVtXfWBKsZ68WF45uqhZPJqh8pkAZrLya132e0FDtAOHFnJUtFOMFN/MDCaehCt0kcb4wvWFP6Wi3ay5x9I1z0LPtEZFqvPimWHTu9bp0pdBas1L/1Fo/E/CkZRaVci5t8Ts2dGajGI/LNZZaLJK7Q/Yu+WosV/wzbxNJW9u2++sfOraD9/PCzgFbB7xCc4hOP36H7sceTcLKMUq9ccq09KfTGn8rKJQ5Jwo6lDSFm95btLMY153WkyNGBUb0wTy5AFiWsQPrr00qZ+uUvUAOrwwlH+P/AF6phFPTeJDUuQfQQVq8AicEYmU+FrYNs2AID0CFkI5eO9tWu0xKp6oZlDBFaqTVDpqI26BkLLXuEUU2Zfq/iNe599OLFyRjvLU4a79vAjBN3695oPjBDmK5mMvFIjSdcVvjBFmH8zAI0UMsdciNV3PeTQWJb
 rOiI/193
 JobEGGbGN9/Ubuhz0YquyZlFXi8aE4IamYhe8p41rRt8DjqcP/2j0yQ7j8GT2q1kLlSZ7Hym6gcTwCKNS0mJEwPyR6Wv+Mt89TbWYrKFQsiRY9Mkf00RJlfgEMkfIB2E81kq6LZrn2apBIR84qFoiGpBnR8x3RwkFk1GzbuwljhUDfTODidnMX068bWvAiiDdpPo50HFFMaUKt3ffFNCKdhbZBeAyBxycfw6CEzOmMsrgvl83IcMA2P/983quF1uZci2xwnPtHS4vQPn3xbmWOAz4wuuh4byvh+sLc2LbcufJ9A7WJxSwbEUPFn4nu61xujd0msa62Av078qJKx3T/qGoJqmxg/WOax7VijQOsrtjQNbUqPAGy2mKPmWiktX1zY1vl+p3oTpF9Ie5q1tiK+m9C8+SLHZaQA7QKLueEp7O/Z7fJFBHTbVZfdF/MvPq48aSRpSiVVJ25unq0SqoPyxOcU/wtCKxCRxdxmw10ZJBMd9mSeBAJYqW4Sl8o11+YNBpCedTEZVWXJ+B0nu4sdHqGLyRffKJbIbfJfSmV64NgRHePZyih3wG0ZeUWzga4HVeTiFHi5KZ0g4XGY8URONhphiWaq/wgyN8RXerkSXHnAR4ztfenax1LOyxusPplEHVKLVjRJZnB1f4P52dwd110CRiUinCS+oFJ5wfseqk5daZ7vl6shdH6HF1n5I9odgt9258smWQeRHkPjONxmkIPg9kSEvfvKJUVjH2ghC+aUqBNDo+GMhQN5iKG/6NFrTlXw7ozleq0/ZYwb0MYo2sQNfnZE4Y+PK1eEK0LbRqLpbwdGOBQEi/6k/jJM8HNG3mNT1nFCCBU9ev0eW9e0dXxh1GfrgDCczFlQ6n3Dsn3DtRiMtTrJ8v/p8EWXBPt6310TV0PIZyN0a9rHFrqJfSFZNHR5myW1mLuPTCuW5bEnab3iwAubuOuLCFt24Iqp2rTATWV4XyUiqFQH7kpcz8vCKh
 cz7KT2ks
 rOlQ76ki3jD/W3YegsFFbB6RPohNhe9KKWF9dfDjJkACCWbRc/94KDpQ3fImLlKyEVCkVwMCpd3tQqOSkqNPL3GRng8EYeHGqdks/82CpKITUVG9ctGCylVbeCB1p3YqtAmE1axsWsdoKi7hhkPJ7/umrOqg2mBKD9UQDTwayDw3GxZFDGHOm5SkmRZ1fHphaFehKawFQUq05cvs0WKD9JCCMFJplf8shtG2ttDxFZstHvo87vfenwVCdxDlLtGrdXB/f9WkBvQMV7Ae3xGtYapEMDVGjgnoHOWecML+7c/cxwpCsEqEttzk/mXseUL8eJrsD8Aa3B45aiThNpQQqUyuaHQkqpMtKw2XzxYX5PEq7xl/7dh/ngLE5AWaSsNsRNRlI1m0HGq9jP1nmuXJ8N+KvWpsnjMwE4nwOWSmrXJsrQ2VdX9aUkuf75btsmGFToVTD9ZyRH6eZ1NPMZKzbXd05MdiwUOIAw6/5ywVvCPB1XfOADPDxEQ/KPXCMKwguhI3cCEBBxC86QA8OlmL+5MzrYkVlTwFPfHNG1rOjz7jbAm/AERsc2hvCnjZEi1KXkP2PMTLDORx8dSJF1dqYHsmxMhLSVPX3Ap5td8PeOpuTUTsEoSQCofLCj3ovNkmq4igD0KsX3EmDGhWcrs0KpfzWJHNB228qqMq+QLFDHLc/bSwLjmYLCLIXUY+oCIRCyCxIGzLi3hniJ5m1WJLLFhDQT99GO/ZiVb6jR1ARbhDQu2AAwoCJWove1c35fJans6WpcT+ceAe0aQupUzOvDdRI4Hw0OT2Z0pYmghzUEMVTvvO6mZhGLEnQyt7PiEHtg9kNT/3RsorbL0UYzD67E7GMGR92XX1V9+dx5FYX19nU0x2ErVdAIgtXNrlnw0VF1XpPGXWEuOf9dXgT2P2F/ECTYwuHpPba2HWB4a1GBkwnrlretBDzX8lNkQI3X+g6eAyMg48RETUCord8fgij/GCoRH3p
 uDnn/cDm
 Uw4jmvANroc13tEYNhzqCglQRZpYVIpnlFSbr7BepAaPuI5Rs2+wvWjK4QqCN4QxeiPbl1mfFgw1wznQBo8UdybaLVr0RkbfIWyhtT08Cj6ElS6QGpKyuf02WRSioLbjo0yTC91vT8K8nnOIt2yuDhanQEwqBVqNxzCq2Kb4ZWwC/qVnc+GSRGrMj5bOgSqNVJPguK6Bu3MQ7tJMQS12HfymK9hV+GFY7RAkFk+muHKxqNLNg8YhvKQ6fQL/0SaDk9Q7V2umbTGpeoUt0877Dg2/k7jMmRMyN2N2GdwHrQ7oQm9SB5kbcskO8veTrV/CEjfActXt274+vGAKCMNXnHG+xWJspz6A8VNbyy7mmZBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is not mm-managed),
but with a DAX carve-out.

DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no longer
required.

Therefore test for !vma_is_mm_managed() instead and also drop the
VMA_IO_BIT check, as it is now redundant since it is enforced that
mm-managed mappings may not set VMA_IO_BIT.

This also eliminates another overloaded use of 'special' within mm.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 83dd63b04568..000c4bb50f71 100644
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
+	else if (vma_is_dax(vma) || !vma_is_mm_managed(vma))
 		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
@@ -3066,7 +3058,7 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
-	if (vma_is_special_huge(vma)) {
+	if (!vma_is_mm_managed(vma)) {
 		spin_unlock(ptl);
 		/* No zero page support yet */
 	} else {
@@ -3222,7 +3214,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
-		if (vma_is_special_huge(vma))
+		if (!vma_is_mm_managed(vma))
 			return;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
@@ -4765,9 +4757,7 @@ static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct *vma)
 {
 	if (vma_is_dax(vma))
 		return true;
-	if (vma_is_special_huge(vma))
-		return true;
-	if (vma_test(vma, VMA_IO_BIT))
+	if (!vma_is_mm_managed(vma))
 		return true;
 	if (vma_is_hugetlb(vma))
 		return true;

-- 
2.55.0


