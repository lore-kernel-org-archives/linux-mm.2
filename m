Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60648CC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55CF56B00A5; Tue, 13 Oct 2026 11:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5347F6B00A6; Tue, 13 Oct 2026 11:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC486B00A7; Tue, 13 Oct 2026 11:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15EAC6B00A5
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:08:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0569E80C3B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:08:29 +0000 (UTC)
X-FDA: 85317934338.11.3FD404D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6A1ED18000F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:08:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FtXxcSi5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904106;
	b=gmldwBhoWvJEXp4IfLOS4fkUUNPzXY00p3xdPO7FPKu2A5044zvRzfw5BQ22cnBfCugg7p
	OW2r+Sly9oPE+2hT5Ehq/TyO0uem4bsaNKmoPwM0Y92g+l33m28caoyeOR2Ip4PwpIuTT2
	6+lCiezjvcojEzVcJVfZNsYL9ELiRaQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FtXxcSi5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rm+C7Ys434hUmEU+Xa4zb6DLDJf/YI3CeF+AWIPMT3w=;
	b=t7QX6hAdQISQwrJ9M2QMCtC6o0yc6EKyCCllw1oj0RB3kaxVZbBGJZo5GbLkHGCCTK+ZLB
	C8duu8RXY/U4egv/R7rBhUG1+KjbQwMkAja5x+d0xp9DmToj3ViIkR/ZvuRe6tBObPe0we
	mACisX2NLIX9HVijYSYhjsnCwEYum/w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98C974199B;
	Tue, 13 Oct 2026 15:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9081F000FF;
	Tue, 13 Oct 2026 15:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904105;
	bh=rm+C7Ys434hUmEU+Xa4zb6DLDJf/YI3CeF+AWIPMT3w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FtXxcSi58gS3uZ0vS44Aou+kW6lvIPxlA7zTYy04S2BLjSQ9x1Rdw5K2VD7fjm5Cr
	 knPhdM3bKcTZ/nUqqKn0fe/lm3x2wgVIFsqQ8qLXwUlgxXsgcE18/cKJbVcWCwYrJo
	 Ixy77/AT3epQrcKWrWpXjz1mrznFtf0xiKEuB5hNzmj+gkWrN6BLNlLqos9izVokhw
	 os4stsgykj0J1ATFRYf05iw8uKz8K0NeXzD2wKU2+W2L9D1OuswmcAOQ5vKjjkLYFJ
	 fm0Tk8YFuOzl/5bcm7k6rPRZuSLYWjbhWyBnSWTxNyW87nNxtiv+p7b1WXOGjb5hsq
	 WPV3/ee2ispHQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:44 +0100
Subject: [PATCH v6 04/39] mm/vma: ensure mmap_prepare doesn't set actions
 on a mergeable vma
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-4-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1712; i=ljs@kernel.org;
 h=from:subject:message-id; bh=c0okmVqdd7ip0u4PvV3oDEa2CETwat0gzMSLDhHRBRg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeRyvyMypKfLbU7hhlVb/osVCmnKzOkzKucp/C/LGc
 XHGHW/vKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwERmNTIy/GD13C5en1vzwu7N
 4S0HTq31rbzyxDVo/dJ5HBXZU6fMqmH4H39tTuXZpzNWCc05fS9/sov6DAa1//ZnUn4nLhRiXKd
 UxQUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: ouu17eh4zrrgkem5rraoj1bq5fxum1mb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6A1ED18000F
X-HE-Tag: 1791904106-50234
X-HE-Meta: U2FsdGVkX18tFYqs6oL053LqW3AgSaZLJfdjzEPVl64kVRfW6tBNOVF0LGss+qUG41qf0lPWf8+T0laf6bpk5lgETlYRsX/3bAyARqRw+m6z99mod7kPwUxdzBRK5bqGewIEUoUJpxa+qsYjfqauls39bEEIh7RP8e6hqltwGGoKmvHpmQ/Rl7ufCzyzWbHFHwWYEnZySj7ztEffRozaUwR2kJufu8wviOVKForff1WHLTN4yw3iy3ITbK7zw8TIoY6KBjtHsvCJeqPa8cRUrngcDYuWoFxMAI1ap5j4BPvUtH3D3XAVASPBO2QclTjy/pDe8fkpZGGAH0HvkvPIi1MwH2XEX2zQKoxmdTRrbhIcy3gMR0jS9+nvlnAMKfdGlfD1JE4hdv/uCVUnFsA5BVSOkX/OkKwOSAHkgJrWsoyY4jw2/eS3JeQaGuzR7cMFGC1Ny2f7JGIBHboASvYjNb1rmq7VIeEgqtihHL1ErcOFCM9YTaY+94gkfPJ+U2uzEb9xBLhJNkct88oH9MF5YscbLaZXfaBv9ISW8Ca/l2IKr9OuRE3d2ROx32JZ69rTVEK4mxOyfnSvuHkwBzox7IxtC/4gypvStgJU9NGcJd78ivwYDXgrSXrdoDxfcXooe6eSvoMXs0452WYAQXMfFJf33k/KQA+bqb7XRcvsXVV5cnb31fOTESF1W42tJeST+45EcIcVldWndPYAMYeNqvgYqESMAN/TAiEDRYZ+6lNgvSjdcd0bSbIaeRwJ03qrNXyTMBvVHjPLAvv1XDuU3HBd84q7gHLSsoYhkPPGppiSO+X2gsKJ9Y5s/2tTwxOllI4MIh/UfXhSKxgR1Db/oCeP48wsM1+LJpyZLUA6cWuL1ss2g5Lgh84gCgJfLrsMsJq1VKoYS0Pcbvwf6govAHratjHeZCCBIRV/ucGCWxLviZroRwP8xrcd++78yDqfJGMTaQY0orzzqc2D0aY
 xnUqj09p
 f70tTJL18zGUTZXKf7wW/gtDPRTkH0y+xIiDlr0rFWVl2QBuC3y2eTXKDRDK46+p0uj3EFh3UnloA3edGq9czz0E7yQZjE0XoDrs4rXutDxd83azwNcqJdmaQMjHQhDfSOTEVxRrq3ANPCp1xcMNRVagjeCeXOm7M1vXWRhwDexJISEhYLK7HgzuwNN3bPGp3NZKgiIj41jc+kU1kSE2LX/VvSo6NCIzEwzF7SSa7C/EWfqr1kaSbtgvMcz2rk+JXOi3r+mwtYrRI83sO0Bzi6UCFb9nCJAkQ/ZcnUSX/NZQJKpzRsstFS3dwIuFpRfO0norIjzJNqFeFrH2W39Itx387H7d8NuIAM4OaTTSUnfBclPThEjgjwkPiwLOT6HiED0kb1/0Ws7YTWZmBmBWIOzADET1ZnsV6EYkdprX+shvJ5aDCeuMolJuN81leglIAAPjJV/1NQ4O2oOHElR06OP0vwefBZRhac87VCfENxcc9mtYnfKBBIgMOJTallPzrixI1Md10AChKcPcjsuvCSvlX5+KOaSOpkvzjZ55CeWUbZSSQE6S+CcQaETktlhMEh/afbKqggxRbGwMw/eidPn02S5JW1urpa4RijahpEUcFMwNOJ0XA0S2R/tOdQeA1d5lIwYSCJNGX//ZYmC+L3ZGnQ2gVR5KhZPCOfAz5DjfHca56KyOudZj4LO2XXW1NxHXlZJu9IirG3pG9Yh+KtTifeiAnliGYdqOMLV8O0OU51XwU9ah3PKhurYx/1hddTFI5u3ZVZhIAVj9xITBOPRG6pwzFMZx6hI03GruW8ahfr4b5R9STlFxWMDs5j0HG5h+mq56hs4sx9jaDv7U/mAfJbvNVDOeCuSJSFJf2f0iq6/YPpxeacugiOh3uuqLRNefluAiPQalLPAIkBpDEjz0vlxKTheDwytq1an24fodQmBtV6YHLZ6QIC0NVKmD3l8I6+Xu3e/UjktijKniBqX7yHGhr
 MqSreEXz
 OkEyy6+o25wJFP8/sLV4CUyTb8iAI5NSl+QJlpU2J8Cjlg4eyKbsIHumZ/nDZL0mOjVCc/uwWps8qEloBt9Sdk0z0yvXYxfg58tIOkRvUiISYy4ON1k+WtjhXUBgAQ4reBb/+sRIVuXIY4dZTikefl7js9MKHKXnuyriTbfkVYERL9jMmTiMvSMbkaKXVs4etSFSm4KDZMknEd59+Z64jmOTLlDo7M7pCZvaLmKDCysJpJXc86HW8j00y7RYvdfjdNaDaT5MB1ydY8g+EheY5PkUm1M4CM1f63nZ/dzXaRe+c70MoTKMZH1zs3jdYFULW2JLOjAAOOZwG8YBy9jlPxmn3o28c6Br1fPUrWlIz9pQo6j86Y4IBGU5cGzMtQvcmsRIr9DMV90Cr1G2i9tmS7CClI03k5LTj0uKJGWe95YxiS3wJ/aMfeq6pU8zoNwD4kvOcUAtDAkq23Y9UOzZTb7Ls7nqV8zo5ZLLrTsf8IeVDpvrdgwp255KYVvMj2c90MSaeOOpbFtYMiP92AjywHXKNWmF5mk9sjEdQ1JiL17Rzjrv6LyQv9SJ5dVWNAYS37nNYBdyvhZEvQ/E29k5IR85TYt8raSV8AXcaSAUcFAwHiMmdrRmP22LjwjRzRJ8wR1fP9mG1qlmgupHA3FRJH8ijW8EIYH3CFJOH/FhKdjK6Kn+NhVu2xAkqCAcK2RQ9rlpY/9zO/pDv72N1ethV1yGd/w4fpbKEWor6PQRJR5fag81qu0mHqAdP2kEnjEtBYqyYFItavMO8PsdHqWCg5HTSg99i6eit/c8Rh8gNPWZQM48Geoti9ofCzMUWQFyEJKKwCHvym9KCVG/0a6ZtaxULpSTWcAphepX/ZeiE04MkVNgku8E7bdmKeAACENUG2WYsZbhDfDwZVlGWebRnmEuAQCBHccFoR347HbRMxq+8heVRZ1PyVP5E5yO4QTafRrM/MxmAIX85cgEDp9QsHCmH9LQD
 6hM2hDPH
 FDNO5sHXq0ypp+mJ8VF9o8lRNtn0HhO//A7++EAC1BYVsltuqKCpfnN41EwzUf2FI2ZFsUe7IkpUIJLFgK086pcnLc+0a67gOTwvQW30Nei4XPbcT6hyFWQiDuCzN9E7bvrqB8akEAbsnnjjGMC22ytcckGeEMrgBRZnIdJ/sOghVMSaxIydx+Qj0kTPwMIUoOnfA/YluyYoMKrSxPYyVxPq3yCgIyWHsIvnBb7jMTiwzYlBWhCT5HYR02R5QeLDVtfzzmHaslqIrMM5yBH0+jUeIbek3GobxK34E3RTwsd75uCubShIVwNJtrlig289CEfJvkR5fwJDh+0IdI16ERmRdz9pV41o1eOORT9qMoAdC1Yo7wSZgrmzDw+fg8C/Q9E4Kx58HyP4Eqn/E7nrn+gLjkCyUXk+9XveAYVTXTVHs11Nc/tZkKOmzUOcVpX2EdS7tAHBnVp9LOA0hM9VCsLMmQ17yJKME0DcIn2n/Zh68ioCnvSAWVcer98KOtb2KjZkDBnDIekrNkzqeVFqSSWq/lLewH3Z+XmqeNlwMFgACslOr1Ws9R9RC4kVTyc9zNyXkfy7Ze+Y+NBzdBl/YOeyrXhiC/+Yd7K5/At61shd6Zem0v8Q9NuNs7QBQ6nVPpxc/6/QYISfJzlBYUqXLQ+EmJJOvXZoAmsZcz2vCm5EzwgtsiGfaFhfNzyEvkatNDBzGfLQhayFALPkQhF3agQk9ERDLAbwkBnkI1JirFTnV1bCUw3sVNMbe7C/30RAj1NxfIb+4BnhFuESW9yfEjdPCrnBuUGiqh297CCbqA6KcKZ7Tyi1SdWpEZUEd9GllpfkP3LC6YqCQaEWlaxK7IE6n7gZv8ndJXEH6qSQhpf2SfW609ECIiutg2b0MMuSCZM9gSgM7HUd5/cAuTUOKXFPyHHpAoBJH6zXrcWdRiaxvPO5pTghKsQRFMDAz+bO8Eh2PSL5RKVJ6xz9AUjiSOkj3Zalh
 dQpetnUJ
 LF4Q6cHvPM63e7k4DPoD1QL5VPD5GLY/7zethsCHSlpRTYE2Ory7xhrFA6zGnN2yG8b6RIfDwEfLMYV33WGp2mSKPCC9ocAw25iuAKMn88Vp7hZPDSKy2NsFVbuk5eCSJwhCDylFP0gA/yd7IM++xZD5aMq1xhG0x3QuBjrXPCkG6Xmlm/towelAq2dnizoPM+t5QHu5EpsPivByw5/ZwKAU5TqWyshnFCXj5uc0a33JhwAp1u/MQ4vngDNUq4nRYtNmr0iQlsR8Imqjh7MenlvDbeKSHR+o+ceJ5xmjQAUtGJEm2WXlhwh7DzGp6VXPgqcrwT73b+lyt8I7UeM+/wf3ZdlVEgxmHauE/hcRwPVV2s2M69c8QhtCZMjVJ191zAvFab6Ou+tvh8SKjVofn29iZ4/VOGFvECJXY4talRWqCZGl0+F/5fXTZsU+RCydR8UVy9zP21x25L7j40Uj2oxkFdoqw7dFYTa63BxxGdSzBXNk/8FuYxlB5lWTqMtzydFEEbASJBtu9vOe5QulpkU0kNtdJaT/xEtLo+GADdJhBA0CpvPWRv
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
index cedc24dcdf3c..c067d6a4c826 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2815,6 +2815,18 @@ static int mmap_validate(unsigned long orig_start, unsigned long orig_end,
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


