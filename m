Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ABDDC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BAEC6B009B; Thu, 17 Sep 2026 12:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16CE76B009D; Thu, 17 Sep 2026 12:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035776B00A2; Thu, 17 Sep 2026 12:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFFE06B009B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:30:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7421CA0423
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:30:41 +0000 (UTC)
X-FDA: 85223792682.05.7C84FAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8EE5A160011
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:30:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgeGrjeB;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ImRrf8Uis4VeyDKpz9HIiHrVsyekRqVAuTCVKg6Blzg=;
	b=V5dMci8vg+d3wHFW3poehP5HMbt22c6IlV66EPHCYYum7G/Y5jZdhPNsz90gFt3ZiuTsZd
	Ext/IH8DQrIlebcHQM2PlTdzjFmGv26LSvC7bxawtY98FiEueYGalB4VDnYEItAlIONpp0
	EUf20qlXf74W9eIvivGWo/kx/VUme9E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662639;
	b=TLqCb3Xfg3ueVcJF0HC7nUW32FzbEKkPfTOQn0qK/QN/3tOhXnJoPUc/lISorOO93iPOyE
	u9ql+1HYAbMzuAIcBYKm81QX+2Ms3/Ixj+eHgIyxNKwTk7fzzBoTtRkiKlTa7J2WclNkGn
	8hO8/+iEFY7fjcBWUlCGxt/DUssHVsM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgeGrjeB;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DDDF60211;
	Thu, 17 Sep 2026 16:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF1D1F00893;
	Thu, 17 Sep 2026 16:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662638;
	bh=ImRrf8Uis4VeyDKpz9HIiHrVsyekRqVAuTCVKg6Blzg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CgeGrjeBYmhKGotgIUun9axeK/dNVfBXSzmtlshBYV+wBy3A1YCYGxLNnaJ6AR/aH
	 zrsKDDlxEJCZprBbBAU7t6ymn5Mpi4VqWku8K/u0pLpLVD1BmNhwPtet7NcBHg6JOm
	 2kHufx0ZreU0q2o4SI4S0LfhAK3pRQr4HdFdNpKPLpACNA8NW0QmJhPaKRQ+9tZqNd
	 ysF6WgzqVf7aK5iwfSDYpEgj8ymuJHJjiJVthF93k427hNRKrXka1T2gcB6alnCkW/
	 0SW6GYu8RDgilJA8AN+MUvnaUNLilJB0GS6DHv4SowpmKmlxb+LPmPJLfkmCTp8r7g
	 7HPDZ7Utyv3Yw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:24 +0100
Subject: [PATCH v3 15/40] mm/vma: add vma[_flags]_is_kernel_owned()
 predicates
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-15-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5409; i=ljs@kernel.org;
 h=from:subject:message-id; bh=nMd3B7YARPUXIbfbJDzc6m3UAcco9vqw6A7IL7GS27c=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB9QONtu/kXVi7PDt/2g89NrD4OPLJ+YlpqWUxs19
 1LSPcvnHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhI2gpGhi0HtkmeOZzPYbe0
 oCPyny7fLT+bjdf3fRW8zSnebmM7w5Thf5DoBNGchodfxH3WXZn14qnkejXRrQX+akVf3jzst1d
 ZywoA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ycuk1t48czk9781fxhuritzhsgnzy7hc
X-Rspamd-Queue-Id: 8EE5A160011
X-HE-Tag: 1789662639-745864
X-HE-Meta: U2FsdGVkX18wo2K/Pp5yRuasyDn/jJC4wrXC3Pb5KcY5BV5qXfck2+Q7GQ4v2Dq0nyGv2cYW6zzBplY0Px5aZ/NBryhDkC/KpdjjR2vC+daswFSqpWL23I4HoZiHQ8VKWN9QNqmrc5Vhefex8m4XKnthkMWnKUvI9kWqBEqbfWWrkBYH3ZnX6cr5Yg8Mwzt0GURUdQV0G0Dz0nISZYH0l5+SnD0wwung9IMbAoQ6ueNOlNPWhJ/53Dp6EKtmr4cMAlMXq0dqQBOB07IUDC+MFo2Bp1xlSU/DXj+QWsmWiZYCuYO+2i9Zw1Io6EJ0QVipfrq+51XUhZokRcncfp/kdbLv/MzyM2++a0p8Azr1Or+wAb63KAjqUvpWG/6Nt+QtX/XUGXPWsjGX2ni1tbURQolzRwapjZPfa0ghYtgmLmoWRLQHEGohn+mWtf/i2+FGfrNOGRGEA0B2zGnRG6GdQLyxts+vet0FTPee4e/Zr1QFSQiIOshOxpG14a/9b7H5acOXTrNEXnKrFGh6XkZIWznGDih0fcZ3M5MClY5sdKQG0p7D7rvEHpm22hz3Jv0XYizbg0ye+dFZhiSas3Ok9cyBkLLzS/LGRekMgl7E5XyWx8/iKsAKCzQEQaMm2n3yM2spR21jK0BJpBARGjv+iszuGSpmmvvUJysTI407ZH9nnmEp0VCpSc270ms1WXOZB69xDxl6PqHrOYwjYSCqv9nOzDTvff7KB8u++P2s/2ar9QeGwoG4jyOfJdfmoBTH9nVDp6lSmb7I+8c6EFWZR+JFWlmHDzFnUj6fApsyS7v6rb5zeOm+xclTtU1IpzVnB9eJ/5eZuG/0Qb6XEyGW1CDgPHZY9DYRvtwyq/e9B5Jor907hfdxtMV63ULgUNAeooiZX3az28MV601sGXfKaKkdHNiDU50dFEQHZpzgv0vRX7IbGNPYkiugCl1iWF9zKylbb0YsG6PipWiAopS
 tvLNP/Q+
 tcdmhv/7zg4z8vx1VW10q2VawKeCCxJN2au3nUN+p0z9yIjXjvuaxk6395PYKwRyz7oVc5ij/nqIG8GUU9oI1qqroro7UJrh1R7MbkXb98l6LPaK0clOBMBYDk7cpZgXKLDpnCC5JX4CyX3bMCJIUbutH59GCG80dyc8fA3xx2PIPO8Zu9GMRZAUeWcXPUp0UAhPa4TCMrvOgAYPJlwFJ61nB9qYEAzTvghO7X93uKIUEbPnizAHEtXSU94pAdTTeZtImNkX66T1KkO3w1Behkwl8p72ems1Taj+Bwz9h+/dRqLIQXGUyNO4vC8CMqr1MvIa+P/YtdA1hEusKxq7ExRA5Kzz6er7JXdIa5Y8J20j8Vc6TO2ZqiqT//UIfy3smvBfUdKLa1som7uHXvZmAEiFt0z7ecOr7L/9GoWeDQnErTD/xH2oLx9f/DRSGmdiiN2E7uQbvAbY70SWxRhF990Rg3/Fq0T5t6xuDOAQjVIHawVnMTzkcQwqUlD27ybMb+bAGSocBqumDuXva+1TcpHrA6ZiO6lonJiSV++T4bLySneGG7ob1d4lHV0268QrdlSZfLe2/CXUoQMNyqFvKf0Wc/ZoyUH3RGxoaYM7KWboAh/yXdSeFglC30bWl2/wDFxCarrgNYZQrfonWTwdFi/B3R1CtguxljhAPr8nNX51K2kaHcUtRqWPx97Zy5d5zO9tmtPlV/JYl0ZvSOramHpKq6wguSi40zx1zi189KCoQnZC9Kzzv3/r8jJAyv3YpbA8zdQhyLoPkHtUwM7GL+5os/LZ1SZE0r6p46ajGLQsDFF3B5F+4GOGsLLFSIRDVPIjS5ATy1iUrAn/1p8c9uhEVoTzH5+ElTMif8hYDP0oi3oSwUB+rBoDVw67ZloL98tpukB3r+hlSdQquAOZLGeB209XIr1gXusNzY8/W1C7/Ia00n0cHYf5tnXECpOE+atqEGoz0ezBtvdZSuRcz/O1fD4e9
 XAFEx3+R
 m4cvqtPLzoLZEVNANg3mEhLWfj3aVse4Hs/TVxZkXoXV+qrgBNPV7N4T5XPiOpPLzaayc3mMDVmPBUM4sxzAGma70uEDCvBSLjtkg1I8AWkKPjxRQPlgy5K3lQ7vvCjH232Ca3K81J07NdB0jF/2XSxLILEL/Vq+zZkUarlfqsFEZxNg+jRUS7d4gqHbopExvIGubchrzvMjiU02HrgnUAtorIsAVwELyZcoPSjN3UpC4ezxtluUZqNDoRTKq3TxoNLqkXE2mMe4Y+Yv8I9H5J+rPjFsuONgONmJK3ffnjkE8JuVF86Kg+20jhZyi532T+bcCex+A5s3E4K38HZgxZAhKCH6kRkzfocMDMaamsdHYdf78HJZEN/JRd1iOgSpTYite/kQ/F/HdkxgndV6c9/xO7kqNLK05Kt248y2U89XjaOV7c3PNqg8rM6kzqUdyEJkQMZW1dcFMvyVsssrqhDosybn8UpRvxzWRg+rLzJ55lVoFMkYAlDdYF1cFvm7uHIqithX+vQAkcqgCmrDobO0OzJoHxc1+EruMG9ylo5kyAx7Lwdv3j1ylopfUjss8XMlU68W8ophC/ECKS64l0PADbS1KjRVZdF2OE7Lo4BEcPJF3B9Bo7RXHrdSFur5EepssAy49oZq7ohdpnRHuuiL9lGqZtJ082wWuYOflTFJOeXBEEOnhsZtEAuUYbE5OkIz+6os04Utc4VhV7QXU2QVU/f9UQDPQM6KWUwAILprIpxjCdmq2JOPMj/8hWadytZG2ECJwcS9wpV9QWkLMlLaTa28oXln0unpMPIWuZa+lVHEzc72IHM0iK+YcpnuJVfNMQ/4jwOJdvR78UICJ5qukP3XWQIdF6iR19Uje8Cv6e/rjmHuZ6sbx8m7lDz4RDOw8HZm/dzjv4musaT7mdAhjgl3YGdC9cOsU2aEfcnL4696xYM+VHvHRi/5Ok5Qy/9CRcN0uUAiyEurHK8yrJVpNkHR0
 wCYYvmuy
 jbUtt49D8JPsiCQ2zsdpFbXSQDoR2j3We6EhgDCkPTNgiEAtebCN9oRW4DhYb6tzdd2pqvbXTesQaCbOzIvD1Iwep0ms/NEbFurwvdqn+E5jncFs0JknoktPyMkziHyAvf2ThcSBducvrxdJxY/tcqf5HieuWEEdc9TovkgQi7Cv3v4jp1VptjLW7hYACRzZHRf193X7IC1Hm8WyhvfbO1x+CmlAbzcaeeCcj5v2gc2Mh+tBd/FQX2XeNjpQAfQXE8QC+8LWf+ebAWMHN/TlTQUvd7KY1bIEYxb3O17UFCqtCHyIrVXZrqMwBJzOCV+LLqivfIPUiOLuSotL9fRUJimlA1e2wnE4Tvehr04SbztQ1cshVq6IR5EmeDRGmVGezAXEUyJEQbvYfo5lFjySzxEeTrrQgTHOVsad/le2eg1BcM/ar5uEyykIeDOeeY7NCJQJXcVFW0kbmKHrH0YA6qC9FJa1OrpeDhuQ3g4bBLmQJaymUc0T1noWZPmjgLluTQ8KsyZ9oORzrbBZVMKl1n3uaNIc3Mq3xOXJ0SxrDmA9gbePFRsi0OXag1LRlnEb/H3hIizPpk0CRtCZJ+/gdb15RVxBEY6mUXmN6Da2stxK+jl6xi9nf4oxK8ANB5bup+Zq/eJ5I94cA9j4c3995Vv+UdlLAr1XP/8/DieJ7Po1OF4q6gsxKkbDDyXIki4k41jf0fNQUs++fvIFz/iH13tuIS22FJOet2jBn8jyX+RnGCEyzH8kUO2g/KQksgedgbCEAGGAhfrk3tlur3aSLunCJYDRMW9SP63yEp9BYW5olhDGg6v5AeFq7tCDa6HhtyFe0oYGtkdZLM3m9tCqSBDpHBSvp2TUg3q7OND2bfuBCiz0QubgU/d/v083G7e/yCunciqrZKv6unHTmVhU5DcwAlGgcbNdfwE/Yif86R4JgZNhCebF11+8oZ3X2lk9c8ts803bOXy7MIZFDByoCoLy3rJPK
 Z4Hqdh8F
 dcq3COVxSEp5ZekplnOzE1SEGOIvQdlfv2lwP70W3f2bxOQT27PCVEjkCzgnGxbhJD+d0/SnMR2/cKOqQXFeYAqoWZlV/KY7aq2Djq7S7HKihjAIX6Gm3NC0wLAUNj7Iu+QJqyVyQBacs6H8mohGvQLem5kzDPQbN7rgkAjoemGuhhjjyd7sMUAALWrbOdeYWfIriG83qZ7+Yy1QB3MqYmJZHP2t4wdPs9armDSdtySj3IV78ISHKF4k7DhvDe2jT2C2urEO9uf31Dqku290/6iWx4o6nQHkn78ZT6RUWQfJAj2O2On/Ig9UxtZorxB7KRHhTynxJ0LBpNAuEiNOlR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than referring to VMA flags with uncertain meaning, add a new
predicate that explicitly describes what possession of the VMA_PFNMAP_BIT
or VMA_MIXEDMAP_BIT flags mean, and then refer to that function for
determining VMA mergeability.

Either flag means the contents of the mapping are owned by the kernel,
usually a driver, rather than by the core mm: the memory may be MMIO,
kernel-allocated pages or even ordinary pages the driver maps itself, but
the core must not populate, reclaim, migrate, copy-on-write or merge the
range on its own initiative.

We initially also include VMA_IO_BIT here, as by implication, these must be
kernel-owned. (mlock() also sets VMA_IO_BIT transiently on ordinary VMAs
while locking them, which is addressed later in this series.)

However the intent is to in future remove this, as no mapping should be
marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.

This forms the basis of further work intended to improve how we express VMA
properties such as this.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 56 ++++++++++++++++++++++++++++++++++++++++-
 tools/testing/vma/include/dup.h | 29 ++++++++++++++++++++-
 2 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2a92193ac6a5..cab29d6e15c1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1612,6 +1612,44 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_flags_is_kernel_owned() - Do the specified VMA flags indicate that the
+ * contents of the VMA are owned by the kernel rather than the core mm?
+ * @flags: The VMA flags to test.
+ *
+ * A kernel-owned mapping is one whose contents are established and controlled
+ * by the kernel, typically a driver, rather than by the core mm's fault and
+ * rmap machinery.
+ *
+ * The mapping may be memory-mapped I/O, kernel-allocated pages or ordinary
+ * pages the owner has chosen to map itself (shmem via a PFN map, for instance).
+ *
+ * In all cases the core mm must not populate, reclaim, migrate, copy-on-write
+ * or merge it of its own accord.
+ *
+ * Pages mapped this way are not necessarily reference counted or map counted.
+ *
+ * Returns: true if the flags indicate a kernel-owned mapping.
+ */
+static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
+{
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				  VMA_IO_BIT);
+}
+
+/**
+ * vma_is_kernel_owned() - Are the contents of @vma owned by the kernel?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_kernel_owned() for a description of this property.
+ *
+ * Returns: true if the VMA is kernel-owned.
+ */
+static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_kernel_owned(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1620,7 +1658,23 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
  */
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, kernel-owned mappings may have established state upon mapping
+	 * not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (vma_flags_is_kernel_owned(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }
 
 /**
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 1d5f6b3cbd21..d09148ce2305 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1665,7 +1665,34 @@ static inline bool file_is_dev_zero(const struct file *file)
 	return file && file->f_op == &zero_fops;
 }
 
+static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
+{
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				  VMA_IO_BIT);
+}
+
+static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_kernel_owned(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, kernel-owned mappings may have established state upon mapping
+	 * not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (vma_flags_is_kernel_owned(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }

-- 
2.55.0


