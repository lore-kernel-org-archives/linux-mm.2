Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EC52CA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42906B00C6; Sat,  3 Oct 2026 12:43:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19F96B00C7; Sat,  3 Oct 2026 12:43:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08626B00C8; Sat,  3 Oct 2026 12:43:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76DF66B00C6
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:43:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 00B46140963
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:43:25 +0000 (UTC)
X-FDA: 85281885612.26.71A92D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 295221A0002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:43:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Lt9ylkZ/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045804;
	b=bY0Z1K4cyLme5Xn/KMCXP4TcGgsa4oGsBvZ2Ub+8RccEMkoNbMf7tOqOGUqmxQ3C0RCmpX
	OazQQ96QI4fjFT3zpjcafT0Z4HmC9m9+qt0aayLI5dEWSeJwn+aJZF84gcIsWZddN/NucF
	M8jNfHH+p+Wi6WMdzktm3yconSxuy1Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Lt9ylkZ/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2WAPq/01IfLjO2S8vhrYpwSzi1RQ9xk+b3YXsmkfaS4=;
	b=N9lW8c6WhDZtoBQ7G8+AohYdlZ92LOFb9ZXvMN2GDPz/xv1jJRuDkjaXW7b2yP1ibhTNTN
	RWFv70Oxj9bcTT0KeI2G7zAooRGXQs2eBh6acWCBnyo7EXZsS6ZGHuOqjRIf5YuRkT1+ZH
	UuHL6rcWiFUtDz1TZ5VRMpSI22nVlQg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80D8D43CE4;
	Sat,  3 Oct 2026 16:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856251F00923;
	Sat,  3 Oct 2026 16:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045803;
	bh=2WAPq/01IfLjO2S8vhrYpwSzi1RQ9xk+b3YXsmkfaS4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Lt9ylkZ/ftM6mAC73f0pVsl4NsXM/3k688zNIjGBmez6SyxyKJwYukGr06xy4VhyQ
	 kjuSRSzoYHYJwaR+49yBaE1OC2Xf0VkaOUWtP38nthk7noBB5my8nTYk+u18B39n9c
	 4bIfO2w4in5tah9zdOfeLjTZuehc8jc/UXYwoImEsSNqIXetZcmNErglpFynb+lNU5
	 ZNXVhyiOD3lQCFgOASfftrSuLI4Kq0mGaKzcjSGxldxrr8xwHu6TehJnOLGjEBrq7U
	 HiS7nVQX+t4nV7xROxKeeZXB49jYjVknwrEI9OCf9NNx52EXXxK2aNYnaAPzlCpSqU
	 DPWYK8Wmjv1Cw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:33:00 +0100
Subject: [PATCH v4 29/38] mm/madvise: update is_valid_guard_vma() to use
 vma_can_merge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-29-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2028; i=ljs@kernel.org;
 h=from:subject:message-id; bh=lESe6gCmDf4+F4pdn3o7bqurkD1VaVSfNfkAaTS9RAY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6ml//Oaa5q/4zZVb0lOdy7DCek6Xbp3KzWW7K6bvK
 13toDi5o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABMpusrIMKF586wtL5cVetrM
 EbTy6K29mJ5YcqnCvGCpjJaEkGnHU0aG3lcBbJz39m5i57xW786/9rr6TO7Jhv+KguxOrP9xd/V
 vTgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: 31e69e13mwtc4e7rhqekqimnqcq5jyq7
X-Rspam-User: 
X-Rspamd-Queue-Id: 295221A0002
X-HE-Tag: 1791045804-835400
X-HE-Meta: U2FsdGVkX19XFigvYtEnvFfWCXfggVLkIw0x9D4KrFD8bkIoBsdgeGpycz733NjPlp8BcAzIqdSigum6ZuiuqbGhWGcGo04HpkNEnd6KkW3MwuVjqSwK1dcZsBwiSReDSKHo9blu4OJzZjh8KUoypOplZbR7VIeXtmjZeJ++3IBIGSPRH+/h1PJmKGt+lK/98LjGJ5didBCGvOBl9G5gQONJkIC55OIAgz3KC0CFipWPvo3g35AYXuY7ZtFlGp9juNl7cFdjf0lNlNN+hAuNIKAEVVNcwOaDrF6n2tMuByNP0stGmTfvVgVNxwkm4hByBCDjd6vFtYWwCRXbIL+cvK8Ykd8TgxKHvL5PtZH47ywBvgTIy6hTqQbK9dBCElEE1w4v2nM7qSVTnt3SiTy4FW57u7CF4I3C6t9mRYkvLwKhAz4J0HjcDQ7zSNTYTjvqG6eTNBqNHye3zfiBnQjbmKB5ZTmJyxr9DLXTT4+o4epRaICZ/Dpwn2LpndDk+88/EcquvM1NLXBReTRfNUyQKR8sQoQq97WKxPI/K5libOA7n6wrazN/tWClw1dl5BqU0ejIjUr8k2C8nBN3qJoRq9yx/KUXeYUoNbW/QZDkRoYeKwm41rl5J6QuLiagn6aVJusA3QVJXBonqQJ0PLJ8f1NAX2+lPFCv/gO6iQCbzzPkUNLKDZUAfmiMe/e9TAl6hET9N5RU31VqCOnRsJ82LlKDx0d7CAJypt7D8CrMQdGE8row0N+qmK5FPlwM8QH9vG6mhmi0ejllovRuzIXoj3Hdg7mbCn8XBOd2A/v+kbBVbDK9PKTS8N96ps1BO/FnU+vYOMdFVu1xFs+KflSGGZqevJfHzaZ7yhslStqJtX6i/friM3PRlR/2CBvIe54JnvQKha3D7CTtg89TfKKB3M0OjuLhUbXSYcUDSCPtZiXxHJbmlMgprJ230jcdPESl6zGRoniknyOY8n14NzP
 pWLS3e1R
 y8ZXcz/dvm0EzzQD/NFM04XhPkfs7ZXksihvmIwZ4bng8zURSKzZfXRm+B+YpV09j5QpVNua5gHABIUXRv2WOOPE+VTFcZQKfsiYW6bi7nF5iX1RUHxAHbg50bUHXUkSsLeALHbdl+T3wYwtr8PxRfqZRKciD4O0AAnCcXSpX1dQPF3YQKHkx6iqbAnOWX0bk6KBkaO9aa5btDp/s04cQvhKgAhfhD+/+ThaovVxslsPmYmaxzy7X6/YjMkHQEp+VZko5x2rOU14ljJ+65RxZjht9/OLaZA634UsX9jnamV9HGskMqE2bVunHIHFp7ING9DVxNEn3yUBeujXD93KhHsaqYAL5qcVEcGsKN6Hl3tY6KBDeFkfDpJHc8iegUXi/xS17Sv1Rp6zYOUhQN+RYWNhsyOS2ZZWCQ0S9m7ZLI8or2j+xFP69M3oXvckhwKOEnVLY3osuhaS2186wTj7aIhYS+9OtG4lRS0hu4bXPtsARz3LeSCCVpfvSBGuDQPZRScgvyrLDm4HEmfL12oigSSdykLSQnh5GCtScwSSlTYgtnNd0FvjINs8uH6+l8HK6CIVE/jkzpitigBNYXV0t4APJY8QxZ7tfDNgWJ0FqyDHSCw5IgwGp5PVRdBW7Xa1/zuh6KksY8XLpN7KfU0E5l3cBY9+VzmehuC/M3a+dyPORig8Z8svVkfKXKyNTzHenU3oQzTFweqjOhmqBR+N6pY1BDkzxfoQW8vPyVInZIqdeeLd8bYzEj7Z4FlWmuSR+Bm+oKDRzPugTt5VnofEjwQ2VOBofh5WntFVnUYe0X9x37ChqxPvWsr21SzwP2pFUsVTJbY3mEMeBLN0IHlqvj4kXECn0rLLNlCiOkZaxIV5SUPAz938e3Hx8OG6TcEmYWxdwONV7dzdZComsjdN7uCYLb+9W2If6ggSGI9dGteJULRwjjoDA9P5Anj0hIW/8R4ILdGsx0LjkehfkuHykhmf5mcld
 wCzDME8m
 o9WZOGPXu4AKKSTk4C0st/gCcCRpOYhPLm7JrdgY5Gyc1KDXxaDqWdjhY68ZgExaiKU2nRrWnYQFwRVZM4EMATPA+MA3zfFcYpPU4khKIy8bANQNFA4JpdeEYUe7WKgjU+VMxtxwN4NkYmKRIdZxNFKDZhu5OW229Y3f9/Gc5Z1EKPzMJbfSLusi1+c3ZkFmfXiQLkGSMIDyjHGY4MNVvx3Dmal1kYDdey87jU13U0GOX+GiIYcevQCRL8imrzNVQE4ZRK6dnyuHV+xkBTfwlxGTuUBnts7n+enhrGT/bT0rhBZ5+2e+H1nTxmk6+rayr14WdJSsDadRcUKQiVvHBYYIQv3wDKR68gMQEuzMEH7lcW26+eDBFa7ZjpTjOywotN36rIMZPCXqUlcB/0v+EBFMFV44DkMQ2HAHwMYpyeB5VIiXZS+LAmqQDjTc0RB6CCADP34GWdBl/72fwjO1UZe6Aub7a8amlqDQhmIBqjBPV/TXcXu2Tqgt8nNk0pGbsrrHQMOynQHMnngp4CVdstuxojWBL1cbFVmt7o4xd6L5s34Fpdl9//5xyBO3onG8gOAqguUA2YuPRap2B2snbIicxYq4ViLajaC8YGv8Uz45HHuVjimsFsIKLTyNlRlGbUWEmkO45HDEI495rkU20+3z1X0Eqks2y+w94alN8gaaO+D6RGSTAbHaln5CxqhVyRAVbXavg03L0wm4EwxYHmxjS82dHBbulvecAitk4BuOt7fwpiUpQPNQMNyUcGobX2j0EsfENtCOUJa0VL5SWgS2TWw968r47pZI2UmherubePpal7j8J+CmzYUZ13Q4aJOpLDn5u9ODh10YvQMJAO06eCZ8AUVYr9RFkYIx06HJfbohbWxZR2mea2ZfJfZ/4iyHnhGZrPViIyV8F+AWc3xJcvHBV6jd+nTtgfBYAGsaMV+izg3ndPtoO2Wj6fMXMsT0yr5zdY72fUwkMm8BbJyawBBe4
 jz4R8mOI
 dkBfs+d+A7M6KlzophHX3FbzePK5rzSBRd5MGtyIoF53qqI+B8SHN0WbS3L8wvK7t+1f86uj9lYB/4V8t/tRNmZy0hIIPEjN80Ba7I2zY7Ytn+gcYSpop/emRSRIGl7kDd1HyhgadH3n92zBfxJ/ONumSPzzd0k6PqY28XjWVthqAoI5455SVLZ/FSmVq1wUfxe65AK1HpzNGscAqD7vP/nGOPSr/PugnC6VS0nXDsrleaWxm+pLeVnwBL4sSukOYVRnO5KCvtKWGK1y6TmDw2gCmO3NiNP2XBMf+Pkd/bGDSRBy+ya46y3Jh0nG4THgmgr+rba09AGiC6gUZXE1uQ7Id936EdkaRk0S++ZThYjQY7pAJB+MUZZAjSg1KklSKaWVVx9tNFFeiMNGlnY2lWVp6sob/WtZvfJ03EHkOiS6QDBpdovkSMCUefU+ZcRo6tovDiJNmagq2wdqcb/2OH4169poeeokTi8WgzCpVJ8XealeqcKumLiTxaQR3Kb6vpuvTAzQNnRCJbvjOTh6U1ECeVbogQMo3/M42kjkMDeap0T3pTQfsyEDrF869IRIKCDIAguIeQgco3MSmp9v13MnAgSgXYnEIQ8rxuhpAsG7yUopMAeOWf26HuhVxQItKiqTwKYLcJZ/1XUnHoXOeMsEs5SE7PQGGQ+wV9DF4DusZ74KPLIgXJj2zUHQFTr2EKzSSGEUg9gJqsxpzdeeuXVIRAXr+lNuo4tSNtvwxZA3wBpT7znAvYu8Gk+Q1LWsaRCvuixlmVBcdQIbVPYoSB1v8/24pckIQ+3aAEXlSRMif9qeRF96ktbQtHhh5g6QEiysTR/dGArQyl6UHT/duVmKk0Jm8Be7a5tv+0xUh1efSbB3YWfQ5lJERXW4FtjiML8zI56Ix4hQvKHddzzgXOJ57nWKqhAucalCrG7I4e42oqEyWC7+PvxUDQL83ukQHrQDnyJkTdBQeqmmQIKRzO+4Jwqz/
 tEcgcgQ9
 4IiDcRpZ90W11J0ksLifjiFUssbUebKwbIlJ+98he+GJkACPQLR7zRwAGzczrEHZV1jDJ0jkjt+xApD2xZpu25SZUp1Vlk8QKVe9nrldJ3mJnDD8C7nNN3MbTXX5PIT+RDo1ODuLs/gfLTlvIRMqH9AlR3QfWS8s5IsI95/zPNGxRGXbH01lxvZtQuYrJ1akdgMC3QrVBgl3JjutgnU3Qdc24VdWD6K19FtJO674eT4UT7hM9jP4LmmW3MUcqppOR9q7ubAO42fw1l1rCuqBibsB2pY3PDSnrzK3Dm8YXHxJhrR3IikaAdjKi2qEXUxyYgG6St0pck+q3/7lCAGfBe8YtoVgvIjBrhzV9vYA8nNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We currently disallow the installation of lightweight guard regions in VMAs
whose flags intersect VMA_SPECIAL_FLAGS or VMA_HUGETLB_BIT, or
VMA_LOCKED_BIT unless allow_locked is set.

hugetlb VMAs set VMA_DONTEXPAND_BIT so this was already redundant,
VMA_SPECIAL_FLAGS already sufficed.

However, now that VMA_IO_BIT is only set if VMA_PFNMAP or VMA_MIXEDMAP_BIT
is set, this check collapses to being the equivalent of
!vma_can_merge().

Update is_valid_guard_vma() to reflect this.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 467601a8525b..0922d5f07a12 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1221,19 +1221,25 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 	return error;
 }
 
-static bool is_valid_guard_vma(struct vm_area_struct *vma, bool allow_locked)
+static bool is_valid_guard_vma(const struct vm_area_struct *vma,
+			       bool allow_locked)
 {
-	vm_flags_t disallowed = VM_SPECIAL | VM_HUGETLB;
-
 	/*
-	 * A user could lock after setting a guard range but that's fine, as
+	 * A user could lock after setting a guard range but that's fine as
 	 * they'd not be able to fault in. The issue arises when we try to zap
 	 * existing locked VMAs. We don't want to do that.
 	 */
-	if (!allow_locked)
-		disallowed |= VM_LOCKED;
+	if (!allow_locked && vma_test(vma, VMA_LOCKED_BIT))
+		return false;
+	/*
+	 * Guard regions require a VMA whose page tables are managed solely by
+	 * the core, which is also what merging requires, so disallow any flags
+	 * that would prevent a merge.
+	 */
+	if (!vma_can_merge(vma))
+		return false;
 
-	return !(vma->vm_flags & disallowed);
+	return true;
 }
 
 static bool is_guard_pte_marker(pte_t ptent)

-- 
2.55.0


