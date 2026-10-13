Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AAD7CC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BADA6B009E; Tue, 13 Oct 2026 11:07:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691B96B009F; Tue, 13 Oct 2026 11:07:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559826B00A0; Tue, 13 Oct 2026 11:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 272186B009E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:07:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81E7AC0C4C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:07:26 +0000 (UTC)
X-FDA: 85317931692.10.1A2B923
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9589B1C0011
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:07:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W0CJyDQe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQQXLmuz/mYy2m0DRCE2BDh2jZAsmGDyji4q3SA7eeo=;
	b=Zr4MDsfkTX7VLV13O6HBwGlEqfO1DUDnJlQNjavUe2zE9wnTbhEYlLv2xyMCCZ86VKgZDf
	RcyNKqXlQHzQgo6q+KBEZ6COavz20hlcbjGlIhxP1lnkogc6uH+o91Xht7jkWHJbLtEwKo
	Eb74Ed92BQsv5mwcWgpxkmjujfUx4Kc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W0CJyDQe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904044;
	b=ou2UUiv7A64+f+JR4jNNdjh1UkrggTVNj2lTfgnvMtEIyy9yFrUnSPaUGaNiTAX09YCqtX
	Ob6R/8zsAV0jq53Yl159IR+KIIHFeZpfA+FAXTq6Gm7GdYgNN7odzHisLmN+HZQd6xRJ76
	OCorLx/RS1TgInDs65Lhe/s+IgKORpk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA97843789;
	Tue, 13 Oct 2026 15:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17E71F000FF;
	Tue, 13 Oct 2026 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904043;
	bh=XQQXLmuz/mYy2m0DRCE2BDh2jZAsmGDyji4q3SA7eeo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=W0CJyDQetBRxIuAkvUzo9XSWPFP2uj49nmF5Ola6oDkax5fLOw4htdgKdsytOaX5D
	 fKB/AqLxOYHFOHmAjt8ojXPCgCA78WqENnldOw0as4l4mcCFFYyBHAyH7TsB63TSr8
	 5h6dyJ6dR5KmSY3dMcYRX2XLk+RphbYhT3pyBjr6eNFn4SarroRPDThxbNL29Q3xJ9
	 lVXkpNZnmVdJfWIqYlVnErwk2NwZNrj/UnmG0wshn07J1ICxsMnOLpUqb4+uJZr9sn
	 MbIqT+7Tz99hZmqryEVpBVBnwG1IqyInMH98GC0PV7qV1CHNet8nfbYk/cY1ufQyBm
	 XE6okl5ntOaow==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:42 +0100
Subject: [PATCH v6 02/39] mm/vma: introduce and use vma_[flags_]can_merge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-2-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3865; i=ljs@kernel.org;
 h=from:subject:message-id; bh=EYqw+AtDKpEde3pCckMQkm9HGGlkplYL0cvv0S5EwV8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeRxvNhVoP3Z94qSsOTNyr06esJ1D4lZRjFPX1NurP
 rp0qphs7ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBELr9k+Cu0JUL1uEbhkaO7
 YgPmbmHhObXOcNvNOTEZ3NJSb6u+PbvIyLDkrPhkFo5anxrGB92nAo5K7TKVOrbk3qT7yqYyfLZ
 qHzgA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: f6au8wb3ni35wfzg5ga6a1m9yzcztdnp
X-Rspam-User: 
X-Rspamd-Queue-Id: 9589B1C0011
X-Rspamd-Server: rspam08
X-HE-Tag: 1791904044-504408
X-HE-Meta: U2FsdGVkX1/fgOarcWLe3X9LyPrTq9J9PTuN9XHuHO6ul6fK2G+dcHixR5oLGUAagcscJHmQr1V0UKoLKuOtapRfrk6hymgoJj2ozobaPKqgMNOTZFjsHPmc9b5x3sm+4dKwKme3K4FzlOxKEo0wpAjBMYQtCHdBuD338B3GgNcGgn3BJe6zX1rYBf6Vwwk0no/v9gvTZNrtVHb9qFdy6CEYfRViC0RcU/NTxWX7CfDEKqFNRtYTedOTVGhkRPlyWPq9uE7EaljtNrNXe9YhrIwSUMfNrSlj8/SZxaYu6kAup14GgJLdpkSgcnVH2jGk49MMziLPHzxUjcrJMXvjjGN4lJ0FBclq35KvcAeGqtOg1v6OFMK1J5Hn4v0G7fyl2l8V0yYs08wwFXkm+/54Sq0PySfdgNJAt8CP+xvlrMeLM0755ADMfcyjWN8wBj7Sto1QFaJuXTUSmbNpzOMhOcXFJykKDcLacCNZ9OyfDH/BmRYz5Aafmhs4ckuzPeCzrt3D3lSVdZgyKsFr0c45/DLZDLmzxeZ2zGMwZc2pviL0ZOSHu7zDYhlsfdiBtTWsmuxJ864vbZWYAiE9Is3rZQWtp2jcd6GWIVgvFK7Vm8lAIqlTT/uMxtyYeHXmsZ0/LhoM7XmXjU6qI6TRaUQzrEdsr9q9cxlE0b0KcmwgrLK/OsBxQCKR70X/HdRSn8fO1FRcUcETD186WCrjoSb1EMdkBt066AO/RWDXDbVXJ2//n4xJGaZABeki7T7Tpd8NSRQO0RnGEEu/OznUiP1vseWepRMpyqeA1xRsm2wptXfOO4nFWS/O9L+Ycsdfx5nRd8aLwG/uhyl27CZXicLnX92/o4yf9W8w2ts5MuJ7hPyv3KW7QW7ZWCaoz6pzlNcDJDEWw4SyZqSAgR0Fn/eUUVCNh7FGYM7geeE3i/I8H1PEhKkC06+5CliaacbMctnviqZxe7FBg058fOksU83
 Cw74joHi
 pIV/0hUSgKA79F50huabvCUf8Jv66h1cTRKQdMHSkvvmgU8mgNhoXJH2X1WQPG2RMY633jpWpwtmzmQzUNAPPEP30r43loaMk7NK36deP5RectKdh+HCKf6jRGpFMHvbyz6hlBEtVbxSVahU7I+lNJq7j95IulcODP/UT4InYAVOn3+MnOhJ/uHSmSJ+TfTqPiVwT6OUI3uKmUKKhIULFADKFFIFR8pysbParfeQuFcNzwjP4C75TsxmM8fMZ4e8Hmrxl2o4KtOU7NGaD0cjiYGz9rGayMJdx3LJMI/cktHyOHPRufSwfRIgWmngFpNVAvVjF04Lw9IX0Gw5UEVdxpUvTPyfZIm/mYzu5YqZJPPwCZbwKQXNYsmvCRUrddjd1/rm5ezZRgWJFNhJ+PnDk/mAF9EKcBRJE+MBZ72FCEgMKAey7OjUmlHP/t/bfwUoY4u1L5lUmqgY9nxpRajZlatn/4BJdXvyk+DPeR2eHT/iMdqQbjP1k79XtG3Zd2oh0wn/poo5mJ5qoWv6+AwxhH0QVnSYLN4TkODe2AIMO/47AGq8CgVFb06Fl03T3ItUgWpCIdEFo5kB7MKsljHIxvQi349y4GuPK+F5FiBcZajFCb26Z+34EzZRIdfjPruflUFGZbTX02N6LfrWW86DlIsohK1KcH4o1qAeqmgnwNrFn3+r0FbZ1eo1gw3NR3+4hhVCtDW/RTiHnvYhaeV3BXTtzzzjSDyjDaH+5jirn2bDtqZNrV4j1qh+KUef1WPFhI8NKaFltGv+WmJ4+VvFHYLSFcntx+kcLFOtWFRc6qSUIWxFQruNVNI0uXY/vAVTD1opYN91KGG0Wy81HAbkuDx1M4v5q6CNwhirvSNkklYQMfHYGvrAzhqaGVICTE7jBBeyOdWpq6zNTf3U6Zf7bvgSLoZa5y9uZ43KAcJ8e1W5YJcjecXwjgk11oJqUfaYhsm0ZNZcv8E3RccXTj8XAuA1t9/JC
 rDyYsILJ
 RJRgYwtea4hABRuo1u2ZoxqQNafzGsfeYXsi9YXQ70sAhyuNbEGSyaMja78p9ChkgulEkP9Hr27ZWhLiPodfxNL+9vmlVKoFHzYFUpF6P/r/h15yzIH1h3lH3MR0kIlKl6g2zs8ATRvNABTEuQ3c+y7sUCR6/6WSl2ismo1VJBMrjlYIBEYBrZnbajMrBS2NgstCcunD0yRL5R1PPSaqD+JunNU83xluDeSKmR0yPNBu1WgdngMKrj5QEqLORmmVy7h0gIskOL90TQCWVkUEiyLsnimfTemvrC2SbDS1nGjnf2iH9eMSkzLsj7xLuTyU/5ULIX9fnsBJbFDyzG6liA/ta2bmjfttu0hzyGlDLUzgtHuukbjXoZQNbRKy5lqzOOf1ZOXxryZQL0xm4wmvU+P4xgLv4GcjBlHp6RBmdE5/H3c+oxXuSbIP3zFwJum9CYL4ydDAUt6ewjJlV2YyFe4HVzi54HuMgve0i1QrUQtNLGUPAqV8WMTuwHRZgX0w9T5yUFH9fOlK5ci2MGbjghQgXZTrmunBQcxKMCxTm5ujdWd+vjEiud6qviGXc6VUFRIn2oJOBrR6lvO8a7X7TSY2OLDbmeuKRw/Lu4tN1KasaxNRFOMvUtt6Kr++tcK3TwfD131+1FJ1vvEb83sCUvWmXigO/xzJpu/CEqJ+FBRUk90DjzQl3Wja4Ez6cm3xtlora1xIzanuH2f0UfcRaUUoSw4BJPotBO1qtGaQTtpnQiTFqbr3aVZ6ZQfm7HbA4pMZ+/mFWyIwuhXWVcdBDuuKy2sMCLSnnU8jvkXegGImFqt2g3NpbeeQtAeChaqc8tomrYOwrcUW/S+r5oXkFflrkRJ3rRUTiAzjxDjYHH8BqL4d6ZdsFhmIn9RBf/onmBP1HkSLG/VkWcukzPF+JIMRkItl4yFJxitJ/h/ltEfcjBJfmGhdosleo1VmP9n5VF11JnDcZObvChQL3rksW1/jo4na0
 3136PjEM
 BWrhJfWB4XM85E3vfRK5/9OD7j1/qoM0ft8IB7lFvNvUvghqwsHqcbiDgq+MGz7Fw3a5lEe5QjkoOtMEN52a9N5hm/CmOqTF6VcCIBdb2QULfZRBhdPgYxz4DrHNVT3LOFraOJt4eQRb9rNrylxH5hta69KEQHVbfEi2c768SEQ7qrV81DicN7BqpkR7Pw3IMwjBqKpkh2RugWi/SJBLI1gX54Q/mHp1ej66oF6lgpBfT67crC+V+rUbLHmTAtew6o+wv4fJNCgWnnZd4jwJYJveL2KmqEFCCRSviTZwl1NX3QA48z1zvG48X+nARcFlFodoTF8Uf8tIXhzu4i/39AAXsPg3nIfN9BG45nIzTToEknd0cH4xrCx62Sj+6sEgb08lLMOGozolveBp5T7JVP40Mi2Ota+IUxXj3cWxXJRJuX1BAzgDGdAkw9tOV/7P97duPvoqXPtua12vez5JXDAtEO8CDRyQilSxn2wlryw5U8CqLIweAO5HLBA9X2shZpbWj99g5Fz7L3dB7TXVponATlj9+d2ugoy24Y8SYuI4UMzQhOdC9AEVTqrSBJ/m0rIRmmpsZsF0RBLJuXM1FCtQc0a0kTb4BtPIAagXzCePc0kqWQPDpo11mZfwkzVyoBLWBUykcLYZ1yXuGkATDtX8pQoHRdTgfBFONpd09pa+hkOqCBPXJfZ8Um+YH4B8DTWSE22L7sT6XioYDtggHKgmHmV0UNsxaE41tMcUkeA5Lo1piHbLW3tobEuLAnIKckWxPgqcW5WuafKMdR4Va1WChqlTZbrBgGoh3VuKpSHvZVC2YBRKAwNHU+otSJ9IZjNico6RR5zwNqfmWtloVatYI9TLERqSa8OCfS51WiFGL479bZabgeJaqO05/43WzDnxehlLfgTLP/0DCAiMvO905KF/5qJiTiNcEnwiou1U3XuLGu212iWimrPbewE/IMwdZiPuCh6bgR9SL4SGGxD9kIOaN
 I3HTCfoC
 p+NvXvfJN7DuqhDCmkk6FiPM/JReSeas/9UioLdVITXOaNxF6QqPX7TLhUchbJg2eB2V6L8hi/OihVg+rOfXwgVDteeR7cnX+mbb2jnwtXcZ9GPHlBMg/T6FzXoxufpipyh7ugqXPWSOL6cfuwUbrhOPi3naLHrMe4D8V+mBiJ/qeqrtRx8r6iTtJcfTH+fOEVsin0bWuvaQOXXJmKRdGYjmomOne3efUTV6j7PvbE66WJNJvN6SHIdsQs1VvViqXkrxItB44jdWiMcQD0uQJ25dRqQZToM2HU6P95zc8ChzGS0DL2LKKmb3VHIh0bknH4u2ZWTSM7KMmUTa4nKyQseQf1D/0OMm9cIfEg+Clx2mYPi9gTX30JT3uPdtBIG6OuGFIpVbSkjovxM6VRWzJXVwnBNZYDopGANLEwaYVTetvw3BrjTgnB2b6Qz42GbljjWFMoz7eocrIDaDo/fPmRIvV/tlQgtWjqpH2ufLJ2oMHMWIWr0UcOdUABPBxft1ky66uE139eA091DBnRi6G2cr/jwmAmSs+s3mFG2/Zmg+yRdUYvlH8W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
two new functions vma_flags_can_merge() and vma_can_merge() and update the
merge logic to use the former.

This abstracts the check and expresses it in terms of the desired behaviour
rather than an arbitrary and confusing VMA flag.

This also lays the groundwork for making further improvements in VMA flag
usage.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 21 +++++++++++++++++++++
 mm/vma.c                        | 19 +++++++++++--------
 tools/testing/vma/include/dup.h |  5 +++++
 3 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 969594074fd2..68250ece4219 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1612,6 +1612,27 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
+ * merged with another?
+ * @flags: The VMA flags to test.
+ * Returns: true if the flags permit merging, false otherwise.
+ */
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+}
+
+/**
+ * vma_can_merge() - Do @vma's flags permit it to be merged with another VMA?
+ * @vma: The VMA to test.
+ * Returns: true if the flags permit merging, otherwise false.
+ */
+static inline bool vma_can_merge(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_merge(&vma->flags);
+}
+
 /**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/vma.c b/mm/vma.c
index c27aea6d58d9..8f8c554d5c07 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -924,13 +924,14 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
 	/*
-	 * If a special mapping or if the range being modified is neither at the
-	 * furthermost left or right side of the VMA, then we have no chance of
-	 * merging and should abort.
+	 * If the range being modified is neither at the furthermost left or
+	 * right side of the VMA, then we have no chance of merging and should
+	 * abort.
 	 */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!left_side && !right_side))
+	if (!left_side && !right_side)
 		return NULL;
 
 	if (left_side)
@@ -1152,9 +1153,11 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
-	/* Special VMAs are unmergeable, also if no prev/next. */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!prev && !next))
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
+
+	/* VMAs with no prev/next are unmergeable. */
+	if (!prev && !next)
 		return NULL;
 
 	can_merge_left = can_vma_merge_left(vmg);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 16c09dac59d9..2fd422789717 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1647,3 +1647,8 @@ static inline bool file_is_dev_zero(const struct file *file)
 {
 	return file && file->f_op == &zero_fops;
 }
+
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+}

-- 
2.55.0


