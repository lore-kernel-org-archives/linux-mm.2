Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E78EEC88E78
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04FED6B00C6; Mon, 14 Sep 2026 11:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 000E06B00C7; Mon, 14 Sep 2026 11:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B8E6B00C8; Mon, 14 Sep 2026 11:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA4836B00C6
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:09:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CDF7160184
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:09:10 +0000 (UTC)
X-FDA: 85212700860.21.A84EC7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 913E618000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:09:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L7mvUocc;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtYEyCC7VKqkqWelOuwt2okny02CJhbQpnc+ekNFEso=;
	b=HULwd8DKkv+NP4WXREnzaJQjHEGvn1T2fyLJWouzZWKa71s+sJtb2G8Hcp4Kyg9UDDOg1e
	+jy9Mv3yPwass+K7Em0uYFqkV0x5l6w+5COsknt95DrJC7LhnHALhV0l2djLj4L117m9dX
	ZrWMxXYuibnxBpy1JeIENGFdMmIeq4w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398548;
	b=ovaxt0taGqLgzhKfd2XHkz87+PAQXhVx0g/zSkTCUflsdN8ruwcb0YWOFUPj0JAwkSAVcz
	Rb0KZoWQEamKzZVpy17j8i9k0BbD4QcJVL+mi3gFW+dcaTh7tEynLa0RHl7cQr9mCDAv1Y
	aQs+4/zhaF0z5wa95Bsb1A8layjHihk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L7mvUocc;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CC2460142;
	Mon, 14 Sep 2026 15:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A3C1F00893;
	Mon, 14 Sep 2026 15:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398547;
	bh=rtYEyCC7VKqkqWelOuwt2okny02CJhbQpnc+ekNFEso=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L7mvUocc07dvv4gNRBD8FIWMRw7VSN7mZvf6vuvnYrejYxLoZ3JQAGznHWhHn3hPA
	 2PiUTFskJ2XtBWABty1VWW1V7Pb/ZwQ3hwijjQiJTWJxu3PbQMoWTLTHJG3w3UxY2t
	 q4tvQVRUmvdYzcG7cEjBUqL/GgjULYotnn0bklOa8SqIVfHw/4Oe7cGpeqcOk/f56H
	 kZnbdU2P3VZTSfuidrq48vWeO3Vqfjywr3cgsJsfQNdp6Kmq8KDDFsgJTxKTYrCSsx
	 KY/d5zQgTuZMRlHJAEFa2kS77Esqf2EVcl4XRAYg+l/+glQcIQjHPAWR0icTcJgUE+
	 RI/ZcB7u1K4ag==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:41 +0100
Subject: [PATCH v2 21/40] mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-21-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1289; i=ljs@kernel.org;
 h=from:subject:message-id; bh=NwkWQQ7fmwzL5QGJDJ/xCgQWUhs8DQGRd4wM7Vj8ofA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG/k+RBscrhhwTaTCRnnfC5YPbGVstvt9UpAnv1zz
 /41fH6zO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARRT1Ghjv+HGs7lZ2Cn/31
 1J75MPmTf3vV879Pb9ybfkn6N2PP3csM/10eP7h+eX/5fBV+hikawu4sc27YW+zalf3t6WHvwqN
 x7zkB
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8c9txi3u3y8g71ti7pdwa598bi4g57zh
X-Rspamd-Queue-Id: 913E618000A
X-HE-Tag: 1789398548-752329
X-HE-Meta: U2FsdGVkX1/NwMt5dfCF/tbKJf1M2dUbos7GzAjvl5MNlALK5BjHJTQtjL+rF673O7pVV5Q30cqFF+n5ffQ4lgLAqU9A+aw5vP6kuOgbWHCorBwI8iGYsBS6wV4NHc1gFbcil1MhcwbrKQeDCC8ZqB3xfkEt9JG6po/2MYkgowkaAm64uJghMRzraSUnmN8q4IGsJbh29H6kFwZvzHNoDqm391kRKbZDaFpXNP1Sc5ESsCuySE8ARoaZf/03kWswxoooEo9O8IdSrSnKkL54JJMXBcF9waqxDXg4w8jiaJuTDCL34e7bU5ZzTpHd+Fcbhi8AX2aDtc3oJ8SPu5Kd0kCSgpdoJQTr6VhqpDY/isOwuCSqXid5PnWNllLp5P3xc6X5xx992Q2nWlPj0OINKHRSXm/1hlANwR8oIhW5PHWA239PNDnK2xCYteUa2x1JZSGI3G6sTsxKMi/WYKAd+xgc+kYPcdC4sm6Qk/7scLVFvLZ2SB672WOy/Q9F06pJ+g6QZ5Dibd5iNS75pmuK45C5NpuINHf71HYarf9svC7yjgB7TeGfq3ya9g+fHVib5sqpglpRVnYO6k9B7uhnfyZmDlCLrbOC6Hxusix6tks4d59nspuOVpdP6/LbIQC91SBBZeFe6cA8KA6rSPQ89FPeUh1GkhTPNu6CvYrddFUo3xxc6XIGnFvsXnvIo8tx3cLiCNg9/VrfUMZb4RtbnjyEVsV6WtFtZz/ElS7SqkFbqhfhoeretJBLQqAOK72meoAY5Sleu4dwbkMfP21/R5x0NQCDatFU+3ZdV735w+xMZ96O+I28T/9i2ROGfSWMCF5lH5quITqSUS1mvKQXIL67z0zyyuPuflISDpP+wyn42iByZ0p99X3qAG0BJT+NijBKj1kTn1hEV1jgO8U93cZN18Gn3gqEikGJuVFkxdSm1ZVc0yqIjwBAuNEgod187EzXMVcNHQ1a0SIINVW
 7o26lE2j
 5DQUa+P92Df5MlImi/C4J9blUodfSaq4OTRQR4P+JkYA/2wDKEL3fbGiCRH81wUE2Y8O4Bd24SdbsEwVNQMTEZ8gzxyCMllqeXjQhUp7pY6PyTxT0G9kbRajO3utDwm/I/zBMA0ry4uy3RQFMegW5qdaav3oE5VWucZe49/1vsSMj/d7epY4LKwpc16DBdYlKwsf4rUn1KvUqDS9P5J1Yw7CvR0fsoYPCbwUzxHisTbqhTqYdBwNUUIOqmUEPG8HrCe9tE4Mb8b7k2bqMc6jOpUwM1wjP1BZ/ZLvRXpf3jNEF2/jdmvdCdJrKxB4Dxhrqo5FjvQXhRz8zVmJLTN5ufs+21koXQGDzQ//ghTlXdX63cU64bQpRMcjb9WWqUZO8lcH6grAXfEJmPrvs8J9ti3sMAjzq3gaXOK8VcQOvPeUlLJgIfWVKSQuCerrJNuUIWbmoEN09D+r9I4GqKUgNHaJTkiNgN+7RF30OAnzRjYPwwRjhJkR7r4/LgyhZUKmfQSIS7qHogrygCkcbt0PfeZy2VwkxaaJqRQKeCjwGwHWjwQNyz0kEpkFod1SXcHPzgOwNm4lnOpouWuUAYbgTpehO8HnGCzEqkjilhOQ0s3mVIot7A9Q437+d0gIgGu0c3KPJXTe10lDMCOgd24ZhebvLfokktYzxny2T1EJe8zvJcvjJit+lTY2QrBoie7XyQgsTOU7c8/sR6Tuu/qxZNgh5O1Kbr5Y87VVtoXPKC0XteBRIO2Gy8fMLXoqN3TsmDfeUK8XMCTVC1S0HKr5R4P7G/iMpcTPvsn75BqJwgAh/JGlmCPKIFvc3ZniLwpwN49O1up0Vdb5/ANCcVgFhdhiHV3savmlcNeFfZaMdXSSKN1wG5Vg1+fQNyIl1j/WhnMieNL/v6pmrNlH6xyWwsvWjxsLyoMZb9J7M/0905IfcH9cCtpTNYa1lT9xFnl2jpGctqtcGqh5DqvD3FB8LmM+GvIPA
 mzQQjv4h
 r7mDj6Rlxv9+nCtvJVheFc1E0hGEJq/CQyP5BQzWIlK6vEGuIsPt0tVhOWRrjEI5shOqmxuY2R3FImKM/w1LjeKAL173suN6b1tuo02Hoyo5RJ2y3ayo3vAdglhjfoneKaai7AXHPBahaqsRphuP5jIeM7DGPyn73yjaWjf/9U8Y72feYMFHiAUT8VzXdQk0uu90+pXDcQx4bFnxKZ2OPOvWTuYsCNd7IpHkvlT9pmd5TuticleMWl9K/A9+Cj6pNAljk46/16wwhg7zI21fm0HBL0VdmYS5D5yKtRIad5fDQ+6vESB+qz348AUmwZCUlQVtvFUqLwSZG7V2DudAI1zciLZKQCXCBZ2cyblmy06uMXmCQhuNvIws/BLQzMneHVKcAGugdr1uCcI0QIWx/sNJQQBTQhnWVgnIy8db91vCIQ0od96TX9PAJ5sBXCcGRn1reXSdhtn7DpVaSwkZsIukt72lBsXnwDgnHTwLrh/kUamEOzhhsaVsd8DrRoBt7XrP+gukWetS80vqAR/fV9zksT9mxC+fo0E9kx9WZIWIK7buPWpa8FEnVrCIXhGgWZd2N8t393q+3sfV7r4zsdmE9qVtuoBkxzzSu1a0WW2ZKhAtFowj1vWH++KGiqd1Md6uLTLgx5RxINUGZTRFNJ+YL6m+ckLrfhUfY8XLYzriqLthdoVKu8Qet7frhepuRAPL7QRshN93VWst9TE+axPypxYEQzua4XespVdNzfdjsvSttlizcROVBj3vsXa7xFc4mKyaBSJipnIXCkoV2w59Nac4wlZg0P2EgNfVFqgHq9DqX5oDevswYcybxtprK3/UTr49lecOTWqc9G4lhXJR4FTndkZ3tAPNGoMqz6thl19ZwalnMGQlpYXfP46zpx6U3JUzs+HJYR0y8Ecg4znvIIK1WA5u9kUowNRlq2ErPW8dCEKY8EvtwT0XquseuGiuEMMlaF0wuSJ3XtgMh+DpglqSk
 eij4eyGD
 SpQqUzEhaZuWRM+FdJh1N+d46zCUJt/3lGEpXoNkRsKRibPDGbfjUlEgAh3kAVwBaGMwrjnPIaUR/SVA70CWGWgCIq+0D1enuEGHGlGbW9XMnEUpqNom4KBR/zM2igZ/f6vFUplWZqj6mTSnQLteSdWiN+tJoQKjI5H5aXmu3a8lSZKQAdRgjJmauS7SsppeqeXnSFUPqLgfn4uJMAfN9HN9ggFnU9iSbTB441Sv14rp03H4pYOXSokg5xgh1OcsQKF0tepb7MHf6/ziEYJ+yHDKk4Rm2YVqZxeSaLndh4gLmQxuqIh72jRsKIlQwkPIdLSSr4V6qPUKa5D49CUv3p0/jTxmBdyGV/tElXo0eFB6CyKB9yStn7ii99L4itdr2fEiW437J5JenrEvv6BTAvnxxvHmx/zstOcBlkf1mZLqIZuXKFTi1S5Ed/95Gacx9HM46KYeTagcR+os1878LGm/pdwiupRKjJ5D7YY907dn3sA0V8jb11PUhueSpOrVpEEPG46UUWzxzaxlVS+VVSnP0t0BN26WILs+iUfuZbcgOz1/wGjO//LpaBZN1mFSphG7lEjka+nXHjw0fMmf6oizWxh5w/fQ7OBLlleJtDEOyQPZZBfly22ZmucGqx1nV/un8MJU9B0tGDPdtNSy0YYxDEKvoJOu3Ic1XWsW5Sh8AyWuvcsdQKAeCtTmOWOgHKPSMquJdDQnrf0pvNWy0A7mASUWWDqln6f3mEu5ansATDu79dGg4WlicZgWF3nb1AEfr+SdSwaN7j6UdpWCYZ4WuTt94LiliK+ZWNsvLp+rj6LfaeU5vgtkIUAVevetFuzBjYME73rb10zkl+7+PS7PKMeJRbVvm5vfDMIBnwomKMQWGDldqn9rtIcwGQ3KaH3qsd/XhZOoutnd5pzvu8bJkjBbE8JeBTnSwCCpdAY03TmsCHtex2l7+taZflOIWqQ98yQc1/E3MokUk0MjNpGepm1w4
 bgtLMUCe
 WiOEOAXDJfdqCOwvxKllxFQj08c9sQt1BSM7m3I3NroMPEKIY384czuNs15qFPgBb5uEu+HrNTbNjJOOKukXrH8p+L9P7hKCJL4TE2zsjFKcelmHVXHPtJLbYibdpasXe92IDP+a7zSve7Je/s7nqnztYyfJFRqQ5S8+E3Qmn7gm7ojHTXo5hbLM5eD/jjiacKP8iKDI2z4RQAwk0/5ISHOTQrLwg3FQGNS7wrIHDVI2Yz/MFSANIEKR1f9HUj0qX4eqswCOwpLvtCZXEvR3RpGoteh6r/gCxldalHtTjZImNMwFOp8eLuVCodZKGcygb0mRxEin09h1AeePEyAUGIh3XRUi33FYs4g3UxEi+IVsqRorWVxUdV83qvzksISp/5Mqg3yYndTiEgcXM7er+Km5J4SRudsODVVguCnQiFl8w73h+R7y1Xi93LTWTG5j4/suNpO78D4jdUmBYNrpUjhmTrUyGXYK+PirMrQnkC6DcSRFSemfVH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When populating a VMA range via the aptly named populate_vma_page_range()
an unreadable VMA will always eventually fail with -EFAULT.

That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is not.

All user mappings always have VMA_MAYREAD_BIT set, so this check only
impacts kernel mappings.

It is implemented specifically to disallow population of uprobes XOL
mappings which are exec-only.

A nasty interaction with these mappings may occur if they are mlocked, so
actively disallow this early.

This allows a subsequent commit to remove the VM_IO check in
__mm_populate() which otherwise requires non-MMIO mappings to be wrongly
flagged simply as a workaround.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/gup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index c2dfcb4744bc..e6310a7cc05b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1836,6 +1836,10 @@ long populate_vma_page_range(struct vm_area_struct *vma,
 	if (!vma_is_accessible(vma))
 		return -EFAULT;
 
+	/* Unreadable VMAs also cannot be faulted in. */
+	if (!vma_test(vma, VMA_MAYREAD_BIT))
+		return -EFAULT;
+
 	gup_flags = FOLL_TOUCH;
 	/*
 	 * We want to touch writable mappings with a write fault in order

-- 
2.55.0


