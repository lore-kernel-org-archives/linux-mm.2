Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5823CA5FEF
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E246F6B00BE; Sat,  3 Oct 2026 12:41:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC396B00BF; Sat,  3 Oct 2026 12:41:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCBCF6B00C0; Sat,  3 Oct 2026 12:41:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A97E06B00BE
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:41:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 781ECA0989
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:41:39 +0000 (UTC)
X-FDA: 85281881118.16.E79E74E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B758218000A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:41:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ogv4AfDS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045697;
	b=yjvrCsFf2IdkhOob3VHXaaZnlGp1ng6thYjvlYYhcBc7zp5mDlF+cRf50qe4hJ10+Klta2
	g7pmoKmX+5XW9S/LVRX84+3c3WQJI6yxPOZgRU1qNcxzHwFC3+F+jAsWPTTWuz66B1/onx
	yKo6mut8ZqTcT2rPpVLPsAeymXum6kA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ogv4AfDS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8cbH4W2d2frf4SZjqSPrrEOkr0mVRQ2Wa2Lp/0qcQ7A=;
	b=aecV8FZPV29xaBVHRcJsprseV+JFPSkQG1d5OrsgEc/YA58zMFaXzs0SbGS/T00Dtgjhmn
	fNYEdCFU5rKmZAQaPtrEyK477+jPFmw8URNtJiYCfXgfZ4/e7PEcFVpiLh9TKOKT513EHX
	fQY5C+0zHEdav21CrpEB6Di+kSMeTr0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BE2260D82;
	Sat,  3 Oct 2026 16:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FE01F0089D;
	Sat,  3 Oct 2026 16:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045696;
	bh=8cbH4W2d2frf4SZjqSPrrEOkr0mVRQ2Wa2Lp/0qcQ7A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ogv4AfDS8gJsOHdEgJsWUaqPTN4Ln5Q6yYxR3FUgA2lJJvT5p0nvZgbBk3N8cSM9S
	 K3FoCapUs31WQ8/tK1Gcki49u1+clrq4azIXJ4k+p4JWc7wRIJ4YKKXqr8UnMF9/1+
	 7skaI2DD8C9b0LFKZxyCp7dz5kA9ejFchdZ4XUk+3ZhAxmZxXA4DRbRo02x+mTWyqB
	 A0aTeMqdWKpOk+jfFztj8oZxodPu+1By9UNgJs2/vejAzcyapl+x2rKX3/HUy983MO
	 hX8pSPHqVjueLV8T3LcdcXu/dRP9y0LNWza8MLaTcRI/ONOqK+rXAp22pW6JDKvMZg
	 xWQbWWIhIMBPA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:55 +0100
Subject: [PATCH v4 24/38] mm/vma: enforce that mm-managed mappings may not
 set VMA_IO_BIT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-24-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1031; i=ljs@kernel.org;
 h=from:subject:message-id; bh=viOHSThOS9We/pO5YQ6PY1XQxyFv0nyC3aFgb3NzQYM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6ml5TfLp3p78rP3PbaEvXIWlDNysTTf+P3NYe2ni9
 xVfJCXjO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARgw+MDKfv3J7zSuPJameG
 80+vafVPmrhvyeNWt5VeRcIzk/bMP/6XkeHuLr2/TnL7DA5/frH9i3b59SuMj3b8+XOcn/FA4On
 r2be5AA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: 3cu389fa76aoupdeat8kxjxrd85s6pp4
X-Rspam-User: 
X-Rspamd-Queue-Id: B758218000A
X-HE-Tag: 1791045697-188907
X-HE-Meta: U2FsdGVkX18gxXfSeC1A5APnc2jiTJfH+up5FoTIMrfQy37qhJ6oFd4voHstBWwdVXjK4pF/1luIAxPaJb+2R4l50tBrR0nLKEZdLwWnKiBpESD0n3eMjEL6ytyddKVWcYAPD0Dfin87bGVgbQ0tOMX0dzMAcp9oV9hPd8ehEmi+WTOaPIJobm+JXOGyNRUiBDob9bUK7xHT4v5J8cp9qj1LjeZkw1GmYLiUvgTmfPkt0TVyW68AY0Ix3FkDvc3JidxpoftOCagOK5VcIccPgM/SHuoKRd5+2HUfFg5akbxNNzsNGHrtbnzkP7xG/ALUrjyhKFo6QLG21ZncDZQzrALK9+oZ/OOOufRzMZt+VBpdjVeihRrChCWadaXadfIGx/v0mebM9JXJUrQk+twFz+ZdHkm5PFloKCNBesYd5Lna5acpZ3DYj4+BJFrqxwF1nLwmQ/j1BVP6P3CXj2/G8cBlnljXiR5WkWqt0Xd5GUpcjz9cDjPqiOItcev354Ik56I88tCJByCcmI90TqNFrJtVCtXZC7DuK77zMbGtiMXHdyhV4mfh+YckNcOn9m/GSf0QUWF6rMu62MrnTEeiZwizpahe7uBpm8EcrpMPT/62yj9no3ra8oKs+5yMU0vvl4bNkvMvLuK+1UFFZNJoI4MQb2FP92LaQNAWkgf4MKhBjoD5owqzBFCwnoNo8mU+6aOBirin8KPL1pMFEnAsZN+ljPlQYbUFieIYRJ8BPkML+02Q8oYCE2ePOKqxx+jNNgnXh5y3EjdwtHYiw/+v+r07sczC6tUZ+DQrqTnBTxfHK2VCLQZcMU+sLHX44pTnvis9olKXb7JOkV/EaJD0ffiVO6cz1gkWTbCS5uyN5IHwovFz9Yn6SgZx/16WmQRVaYIfJe8yBsPV46RlUJ582Lc2ULRY3qL9tWZQwgnHykRm3cdPBa8R0qkLPsVa9rHIhXVIu+N4oVX7bV+rRTY
 ZfDRmDai
 0PY0zVoN2lgS3JJ+njsrm/6fQbf62a6S9jpOhZ0kIbAELBJpD2eSfACGqc/Gmbb8SE1cbbdZxowrTOvsaeouFR4d5T9D4qampHYy4CCnaPUgr2d/zwV3MbC4BRCt59PPuwGjEDAJ7Os1aQj34eWbcHip3igJxWjAwxa1EEyWcaNRHQYRGnpmNl4zSrSo84bYDkal+MleSzPLbtt7EhIAZlBwGMb/i4ESMZJWeQxK5tYHl1M4Oyy30pPjuke4Q25Y1uZgv4L0O5/ZeVH6Gh2ihYwcOIRL6yQdiwARVTrw7dR2fq3wBb78CVh5XA5SoEo9ie435DyC5dr9Qu5VmLRgi4oauMcUCrC+OcydB/UxoLnRuSQXuMk+h+/qPYydr7EhW9Vd8On/SKQ46nWIWwBCeBRM90k2TfWx5HzThW25M05WxPGvaLT0GTz6rdRHlJQjhcDt+09hybCC8OJ5A+1ARHo7UCDApXHM0cDAe1CQEfYRMS/KGSdBxrscuabgaH8s8I38Vv0kWlZYyrODD6owWstx3glJwUG2uRQLPnpmswc+cwAjeO5qtP3/ZTxko+KtU01iPfJve5J0WufOJfswog5b0Rpc8uGzjMqyz650LgQZAz1qV09EMq2NGSiSCsf/L1/UJELQs1AV2FkDt8MTFscks7ydfez0nL39Hslj+4XaGFKI+kjd+rFvUXc8e1HfA8TMyNShcx5KLPOEVyTjs8TKmPXb7UYrsS6EhXd1Lss+KE6NNAggQeJ2houqR03S1rZ85RAWeBFKMzJMCXOYlh2LRUDyniG9Q3D+qq4C4rxRsuGgukDB9gQyflKeqFobF3wqY7qP5/aKvO6Igg+r9Roi36tOrezgwATTf3rEO4EGkL6nLdtY8uZK1HIE9GblcSqYSiZjYpEUR1i4H3MPUXHLyuGCRH2m6t6fJLmd7R4Bh4hqcaW2fcut03FNEeuOaU404i4TlCyjAEU/hYSDPLnRzZXPV
 A/CMp1n+
 t+GUfT4qGfiYpQpj54O3qdwvNVoI0nJ2xAqm66PWAHiQ1jnBeJg4b+qmHY+iOANNNiVjxwVOoaDQQSDPm6M7YJxkdZQVPNAy3BdDlh8w/BQnJAmYEOxuyk7qlSy2WU2rJVglI9DgveGoCdS1EV6X/r70fdvchz2dylyWDcVVvBpdEd8QSvn30lqWUMuwOpdTMUUd9BSFbOZ5mCYO6RJHnmmHZIGv0Jr/eEpBMiXXxBBh+7uRLJ/p462qi74nXC8dn+satJMe4ACLB6A5BvheKxGTN99Ho9j4LyfOlMJ1wTQYzcBjT62d+pfuw1dSAZYVnBUpGb730RPixdZKvq7f5QNrt+q4KjUypxLqXa2TJ8MLnYmO71wZa8jwMp8c0bUqOJA9WreBVXv/Do5x7gd+7eSCZhZ34L0c6Ha+tUMs2yeHklGNF+9NB/t3WyrYzcZKlCaightczO6Ti6ace92P7n2V+LDk0iqs6tD+OG6I8XGIHprnSMa5+Q7X6rrn7qWM3+YMj3+sH9ulLbB+WMXtVyG+ZKYmLWFd9bafyZUqJJ+rxaoGqgHnmpxszT24c1RhbYUCdJYYcy2c0KxW+Rkg9tEjvJQ2ygYgBpWYZWm5EFslkt6M/ON5LFD/twiSOsUCSsIhNnu1hmWUOR7aAx6PZ0QcxDVPCXrnBPR7RyAZ5S7B7z1UT1KmhjO8hjoiHDL528pAPN8yRAVZdchqXHzOyawjW+ZW+M3HgeRdWYlVHd3VWY1dOzNYIPZLvN/1Uc4+GYpytdRwL3w0GYhRy8k12JdqguxftyDjR7twxd08dto/t/zA5eSOr/lCHC83ojeKjvnif0haf5hOdN/LvD1+HDyx98c6ZrTNtlEwCAVT1/q3j6nEUppeQFeKD/mMbF7cvVuFKqLwpBaXcNsOpNgUERvsguT0FxGjrHFGh9c5R75q1wh2ACJGRjTf9vPZt3WsflAI631KeVm8W3TlIpQOTW+CY9CMz
 PbUrvkaI
 KUsAwVlATccClaKVx157UIddVAiFysgCrWIfJpsYROA3DrFHrJpquUkdmpTgmIqlsT/frFVePXfxfE8bT8Y/GC4E9JSxjNLU6bGafDRudCzUVyLpYObduC/b6xgtxvqkIROH4YX34/uLl6M8xmpm9J7FAdIrxBzBgmUjWH2cXclsPAtAuUn3QG4rtYZEODMEaMLaWw6b3r8EH0BgJrsHBWddMIo3aDWfBojFtH/tkdUAZ2mTtJyqfOcrqOHnP89HQuZt9FqwUhhr3wS2ipHTO/FYX9lJKsq17CKv8RZRdW9MUYUoHI8SUppGwRPKx4Y8mzAnsVgbzqocdfe92TSfeXlpNuojX8G3Bb8W2hivQrKyzmBl9DP24C7gih2H4knyh6vu0dMJqT6eQQwpwOgQkVhJ19neRgmddYH95R7z0YH1FXuLPdOD+VEih7q29dgt+kakNIcldaK4ekpUrkp6HevkTSIaZyag9qRlylget9CzV37ZAV/sWBWTUIJhi9uOpO6LDAmbKZ4omSxJHOcK2STHxKh4KWigOaKqBOXripNhea5EPFqyuaOiUzLsZA7GYBJdWbiMKW+ujYI8M2LSwZsnfugeujNnHGXu+Quh60BYApZ3jd4rkBSuGX/PRRe3XdC6hkoDoL3cBdmdoXrTogiieoOeifr0E1vdub5j4k7vEwd75TgpW5Iru1rDclVE726P2bsds6OaB1irG9gAh1HsPfzUZt9G6K8cLtTe29ROgyR9j9ZIQiKFBJCV7YY1Sprro2UqaiqXAvP8YThMePFRvQxF0+42UvnIbEGv5Xb2TyJQJoMPyOVXOc33H46r3/CCxrSDFAkdaPiSmparJe2nJwzStMCGJm2TkYsLpF23KZ3a4BSiL4cKZJ/mbqattN3gdQrL2Xh3dyFiROpDOcIlXtNRuIL5MHbylYHG5ubW5an0m5IWf6T3t24lT6DFwUL+uo0Iq85MxSxshnwIQ2aGDV/wM
 tj3rQfLF
 6XE7nvW5nWSY4zeK2Zi7GW4rnvp6OnR7eUHLCyIz46vsmY0lmY+Mod6WeXJsYR4h4QoRWZosFH53xT+SZTABZpL/qgToUacqxkmX+F09W9Kw+ud16emf68Tz5m52iJbr62Zv1qbh3FVT7Nzw9mEEGT3wKhnAe57pqLXgpFWnlTpOTaZZ4izB7O6TAuIHq4znX2dJUquSSRZE8HAohLC/V/uKO113i19U0vhHJCrfhClqPdX3GNtMaez5Wgu6JlnoJUbaKZ5KhGJNjmWrQNUQdMnW3NxBs+kK3LxaYJLdcq5RgBCXq5Q/UzI54yafGuRLWfb856wnp1N5ZyeoXhRKZHXGGAABFXCt5BjsQDX05PiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It makes no sense for a mapping whose contents the kernel does not own to
specify that the range is MMIO.

Prior to this patch, all in-tree drivers which did so have been updated
such that they are marked as not being mm-managed. The check WARNs and
fails the mmap for any out-of-tree driver that still sets VMA_IO_BIT
without a kernel mapping.

No functional change intended for in-tree code.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index df2efdfa3805..43d32c3b8f6b 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2793,6 +2793,12 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
 		return -EINVAL;
 #endif
 
+	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
+		/* mm-managed mappings may not set VMA_IO_BIT. */
+		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
+			return -EINVAL;
+	}
+
 	return 0;
 }
 

-- 
2.55.0


