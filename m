Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EEACCA5FED
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935896B009B; Sat,  3 Oct 2026 12:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E6036B009D; Sat,  3 Oct 2026 12:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE746B009E; Sat,  3 Oct 2026 12:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54BAE6B009B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:34:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DAEF61C3D4E
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:34:33 +0000 (UTC)
X-FDA: 85281863226.24.FA0F892
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 34223A000A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:34:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PghLaNpJ;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ogF7sgipSOPhVjajN8MlTmmNbNQMZnNTSMv4O0r0r7k=;
	b=SpexfW9NLTmznAlyU3BGnRnpq15QMoKB28/JI8cQrG/Cd8NqeTipsT/eINxpbF371tlAvw
	Bh7aDtxaaZgeRlKzk7FpVgO5OCnoUjJzvEp1teP+2H9CTifSfCNdxpVWJ8AfIhOwmJq8kB
	IZRKnv0QmL87s6Fs/WhjNxOIDQ3n2Dw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045272;
	b=Y9Vw8WZYKh56s8QkWEVBuThqSH/5QUd1Bp4FiNLTn4cWMmn5UGCg68yeNAQQEFuMzRF/9Z
	QfEkJsSycFx+1w4kVXUm425tvMpWtOLPGq2idHwVddEOPtS+GfHEwgqK5MxgbE/cWYu9+S
	UEc+vDQoeCL9XXuWoBKYeVo5XBeLUzM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PghLaNpJ;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE6DF60D9B;
	Sat,  3 Oct 2026 16:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABCF1F0089D;
	Sat,  3 Oct 2026 16:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045271;
	bh=ogF7sgipSOPhVjajN8MlTmmNbNQMZnNTSMv4O0r0r7k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PghLaNpJmUw3Jhc9TPFy+1pu1xx2zdCJJXHgjmydeyW2ajKRzZOraCVCpQtUl+/yH
	 rp/bFllFSfxANFVUTUfh1P6gNXYfaYSme+nNWeDNXAvs1ZnCzTnUVnv7/eevp9EY6N
	 x5z5Es+384FGRYpWKXY7+6kBpit3IPGlFOTqgZ176pCd+X09Mf1GMwu1ROHrV6YCJg
	 oBijAvpEx58XzD+qLpZuxOh0WPKuQOwKx+btZqiiXdYsH/KoddNwF5eIeY8C2FZ1kk
	 /yGhJHMF/q2PN1nW2C3nYhyyximXIf+fvl+4GOXUA1LEG+XiK7FyFJHFXlM+RFm+si
	 uIuwWENWK0XMQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:35 +0100
Subject: [PATCH v4 04/38] mm/vma: ensure mmap_prepare doesn't set actions
 on a mergeable vma
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-4-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1712; i=ljs@kernel.org;
 h=from:subject:message-id; bh=A0TtP+WEaYFM4Xa70Fpr782oGFOYjP8XY0ipqE17dfw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6qn93yjwaI1s2uRV7nEzv3S25j++vonDzjvIrofHr
 lu19BFbRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACaSuYLhf7nsGXkrYfVfH6d6
 5hQubZmn+t5372WtC5xcio/fXbm4pZiR4UT+9q8TjLLE1ANkVmX4vucuL8z3DZVbJypWp/W662k
 jPwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: bqa7k6ywzctanwwh1qc4x4q8ep3ns9u1
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 34223A000A
X-HE-Tag: 1791045272-841187
X-HE-Meta: U2FsdGVkX19O6LZ1cPu1BeXvVp8Lk7iTUMNllTcCpTQML1wk8F5iUgvpLcJ0YaQQu4aKuXLViNlrWzEHLcltrlzsAuTY6tK6EBdGxRs7GnOad20gpNrx1qrNBVcGYqt31uQMo84EUC70dZZJskbQ+qxZal3r/l7X4sR7DF2DgQychZ7W7xNSf213VTkSmw0UFp+cQP5m4Jtozn6j/axXk4LiE8mVsA9JBLnUAKMEMj2dmXCzfCch8M7Q4Yf2se0nS165WJpO39FE8PO33vVC+kZUauaTArkmQW3P7Njqp4aih8R9+7/V6m6G3+LkPfTZ74/YkBUEbt1WwPLGZiCBqIQZIUz5G+hEbAZi014iSO7Z+KmTjuYGBIBQBvgjyaqSJnUfIM8JATLNngyi9Gg/ye+VGIpBvMyUCbn00N9VNE1A6dPa0mhGyu3Ayil+lZ2LI/v2N9n1I2G3pTPxzkhI+Gmszgb0k71XPmtBAe7LbgvcBA84KnT0/lti+UOq7nlq4slG/jTSYxNAZ3cQnrckQ1D8a7GjA5EfGfEPVUvFnKBQRniVPccDUxrANoD3j5k6IPpsLvSyuvC9qi9DdmJbM7ctbrJ3WT289vKlMRQ868Tx85JqoiwaaI4R0YgXJD4XXt1wu7xYecSaFf+dZ+hV0VbRht1JFcigu6YrdKB/dAduMo4HRSqaB8rkCXNbdNWmGwdnd9qCsHQVIWAHZJsPRQDqMoqqchPd+RIB8SBJ5bkO+Jlpa5jcwP3x63mRW/W5i6cjokY3RNZXvXBppOt6vshjec3LnRTq8y3/pOg3Ywoar/O0LET+yZyf2j7ZpwirXo8CO+erOoZFfiecNcp2s4s2t7Jpic0rEssCPkYDzq4hPVJoxgKTFdSM96205mP19lVXlKBgqxAORKQ1BAiMvUFuuknXcHTBv4fXTrsTCh7f483FOv/rco1YzTnjr5W4zrjM7OVLPN5CuqQnJKA
 7JmJg0Qd
 UGbAYMjKSa4wNFM5NDGPfS8/Uv2gnXl3eZQUOEcO9isbLHUFmpgKufbqS2A6Zp36+gMbrbszsKLznJLCbYa7vn/1J2CvK2Qo/1qV1gF1tV8/9yzoDNy2RfG+neWtguKYweOP6QThCJfDdFiOI5HJtiPOEnPCikfZ0OpMn0mXEYQHFOAg9Bm9WaC1UFYCEyN3T9Q/YXHey9stQA6l1E46NSPivtrhwlhk/RbIt4bm7lsu2zv5hpaLYA8sx82TQEzsh7ZH+GPepduKQLnusTTQRMAPrgazGsZuJUfAEZQVA0sTEiiIQ0yKkyfO6zxysxhr7LR8JbXg/EpB6MEzQ9w8WW1BKZNoUsUn9Px/MVnYb6ixdcMrozRpzHCrGZL+CLLexgTkekmoCLcvLRlmOMd2wmsDSB133ZUDwgE1E7wu1JGy2+CJfhhU3LoEXuqbjt8wXEanxTJiLtqnH5sBNZeh9XKVbrXK8dUNi5tON9CGe5+RV4NQ7mYbNblMlLIUNHfRKtxcNvNuxjr4HxWd2/Vmr+kGKlywoPq/9h4k9Zy17Iq01CO2c7y/2vYIprxt/Oya36L+kJ6v9aUVLcd/D4ZnDs9427dRlgDVWWu4lkBfLNcPPvIN+LNUEBc9ZPgd2hNkYSM3WkFTY9Bhd6eBz5ukBrFdtpeWPijnInC03JRtPidXRQBmORXWHZrJ73o+SLGpKO880N5KOx/hyTPS3q0AWv8R6kiiGRVHj+BefNoLNcxqPqRJzPGqQ7Sbi1oYe1zDwOi5aFi84Yrvu9uZZv4/YLgE1OK7X1z1YPJByDJOHGDmg46DHOSy75+yJUJ4cUTDZRZCVxFf6BtFa+sGlB+wyQYkdmwm7C7bBdbSxITdZXDa3ptvkIQLMHYdhGqRvY29p9tRhTZlZHQY3eDsXJ760r8wqeS2Pmhs8TpLFndkAe/p/6RBB4zyUNZ3yjlemzaucvIVcQmXeYNgPpJttxJWeOLyyCz76
 iZ8jQE+P
 ZAok3X0nuvjGKjUkFb3/K/TBuhY/yNHtzI7LO/bIfzAv02rzNquJOyl6BjPSdfaARltYGPvjSSBaILY3VcFeB4QqfZ33Y8ipwBWqSIYoLYa+MjVcMH9C0OriS+MEJ0BD0XBxfhYcgj3rB04uVCAziMu+quOz1fpVSzWSEt5D+SKERfZR3lZg8Gmi6DnR2nugSa0VbTB68RJ/uC45/umeBumg08my4sE6VVVtv7kBAHbSGxosvIm7T6AwG9g2BsMd046MB+DDYKnnbAmgQQAkizgcD8ttr0fksva8SfOd0EVzqd0fKLMtXzlEwNL7yW/9riXNojQA9mQg1fO3kqY+sarKTRZcWWMMhBSINPQ7T52kblvH0zW6jgDXPVe5jE2+lHC4ybS8cG8F+OdOtUoak2cWYMv+sZ9sU/eltKeR3e0ti3/73SAoJtu2J+/Bvar1RI1QKYXVjFRqYN+asAiEJ3bVmlLKxJtsJ57iXxvdsynb6HEDn0pu4iIPxkr/Foq++rDNsrKv6D3lSNKtFqyptGFafmh9t6rbaxFWpdO4Kgxl/vnDDuQf5CyFCdnvjaHiQtfgXhHmOmp0U4ciXdUrFUs8jvwfmwzbOoPyjLo64skjs1EHiND6uQl88k0I+3EeBJMHzZAYPmhWMLuLnjBLsKqsOF5wGe/yjkgo4oSHLuJm9pMygoyQzg9j6FwhIzzBBApaUk4qkdziAF44cEJgyapVOIdFfG4w0Hz/yN8IaEKzELuAQ1MuQ4tPBen5Eyuap6gknYabvA1bjjVCQlgrR5X8reTwAf3zBnQBWMqNex6HFjHB4Per3xY3zJZCQSoEHiSJLF6tFhiC+WTwkHcEhOJpZyCZ9vGpO9OVRTMndNB1vUOLF7/a+DXTH1N6g/DMarWWy/T5baJwuAKa8TtH94IQshxPxjJKFu4vO9pLRHSm8MfGVVq8WsN4FKv85zMZPnea5CX/kGOCvJx13iYnI6D0PdZj/
 A/iRfQd5
 bl33plIg5QeUfL8keZ6DMI+XwHUExZsSkPdV19tbRy+it9ltB6ZM44NQvuK+h0+m2v8MmeWk7RnD6jCT7VV+7WPpPaOXUhjpsoUtzFCMsS+heE58H9UYE7gm6RoUjsvQs7fOR/z01LgTJCDDeCY5/HF5iJ7ElyvlQqdQ1nZhbQiCQkGcMpSC4NV1ePxDFQ0WdbzpkvA7oMv2VRBRPwCkwU083l8ZaJ7sNYboKF7GaIfaTSpaRgHIUGCPeBf6ETOtLgL+LNqWBQ3lI553LMfGakmQZH8univqq6pVPJsRZXQW0lQFDG+sO1mwxiQ/FSCZiA1jtJoLkd98J2r4GRuXy6Wu40vYL6CEHgusXXuOuXm1nhO3B7YkCQ0mpClCJd7fKg086b20QAuZ6wJ4f7QZ/L5qz9lXOeK2DQ8KTOTQ//WqWhIXn4aD3g5eI56NcSQheSUyYVhsEVfRdwkKhha8AeFGyhasEghLvfSfbTmagt4bg9c4fCEaUZzhCvsf3m66jt8+ZXrWSgEWjr6O4e7KaZ4j4sbvQXg/9n1hc/0jxNG9x4TQJxK97vpP20wbOmHCf/KVa4HXv9PRZsDSDS7vaDsIIE/e8YLEQzZhi39azGq338yh64Kh77XYqFA8Ff1CpjnVeNZI/7/++EICswEqq7QG4oLmwz/wqtTmMocqjEv/OJ5YfMUuvv3nSarnzlGsQhryrfVzLnUpeKh/baBkKuLECPJ+SwCIyvSAFneb07GzHTp8skdAJ9HuDgl3GYjeXj6wu8P3VqRDW0Mp03KKcRRr5soc0e19Li2oIQT8oi3cWaWNWRQRZh0yfMO6h84Y6tb7671LQFKLkhGHLsGMVeC/gdgq/XqS/vLqSM44Bugry29Nq5HQ+9qVdQ3FW5Vt4HDnHX9tHpw7TyBlVzU0SonUoC1K3IZy1O2CZSFyLtHe/z8RQ6rC3v8/ciiZ7dEpKmtzXzCUXUwtviyD0m1ok1FLYbBH+
 /tjh/wpV
 OK/iuwiabp7nx+eAg5dOHPd73xzQ+jr5vU/wdI7ApNnPe4DqNv9taAA8rLC7JhRSGg5GM0yFQT2SU88QC8bVKrU/GePtZvMCXp2WgbtzY3YPUdobjsCg2Z+dkiwrKtQSxtBYXN8rvbVk4HmOT5BHLIbTUiqHZhpHHWnpmv08YNLj1jziA//E1pttu92RZGcncrRo3DGiRKDOr7hf2TSLe83AHZnJe0kO94tv34wSNQP0y0FM+TSyOV6OlvN7LUWgYQrpWRdMWoAES4Xy6ygOt6Z1VPjl20PmzGK79b1o7yQsl5VqvMZt3G30EhKKht/oEXrqik0BOp8U98Zro1n5rK26H/i8eVGN7kKqVW/iN82YKLP8Sb3JiGW+TiSSWCffi9nPcdxDc2UapIB44LzdkAeRjpS68f9Tf1XXYkGRJ8JBPMDRSvvwE6UWUhd0SGMhk=
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

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index 159fd3ff8560..a9532bbd4ee2 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2812,6 +2812,18 @@ static int mmap_validate(unsigned long orig_start, unsigned long orig_end,
 int mmap_prepare_validate(const struct vm_area_desc *orig_desc,
 			  const struct vm_area_desc *desc)
 {
+	/*
+	 * It is not valid to execute mmap actions for VMAs which can be merged,
+	 * as any such merge would leave portions of the mapping incorrectly
+	 * unmapped.
+	 *
+	 * This is checked after mmap_action_prepare(), as it may update the VMA
+	 * flags and therefore whether the VMA can be merged.
+	 */
+	if (vma_flags_can_merge(&desc->vma_flags) &&
+	    WARN_ON_ONCE(desc->action.type != MMAP_NOTHING))
+		return -EINVAL;
+
 	return mmap_validate(orig_desc->start, orig_desc->end,
 			     desc->start, desc->end,
 			     &orig_desc->vma_flags, &desc->vma_flags);

-- 
2.55.0


