Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B31E9CC6B1E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7B626B0088; Tue, 13 Oct 2026 11:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2BA56B008A; Tue, 13 Oct 2026 11:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7756B00E0; Tue, 13 Oct 2026 11:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 809B96B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:22:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12ED7160CF2
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:22:26 +0000 (UTC)
X-FDA: 85317969492.26.0E1F7A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3E2FE1C0005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:22:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FwI8xuFk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzLkglerZHaeqdqXBcJqI1OUUZn9McyDsaXMwmatEzY=;
	b=SJJWpNNyYDc0TtxGgSHbeFtIag2A7/86aYk0pO72jeqEsl5m8Iy2Gwt1/CbBiwBHgBIwle
	9RAlYQcs7ubHKzZ7sZ+/SX7+7ytDSTSL35gi112MkcLwRVHcQYefUO1NzdsweX4QLeW8km
	UOwsxvIRy6symv1C7VSmC0n+DBDYsLE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FwI8xuFk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904944;
	b=0d7VCTEjZRKA1FkAnfoynh7CBGj++AxJ1+BZ4cZ4p3yZwYF97cC6STQ1sLMKYNpiMqBseH
	TI68IUfCEeuuA6EitOS0FLI1K5pRU7najQt7NS1MkYwYqQXPF5PcMF9FWWaWLRYkQkXhH5
	Kw6FY+Pqsvlv/qLDkbLLfqaoW9U6v8w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4366A4040D;
	Tue, 13 Oct 2026 15:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085131F00898;
	Tue, 13 Oct 2026 15:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904943;
	bh=CzLkglerZHaeqdqXBcJqI1OUUZn9McyDsaXMwmatEzY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FwI8xuFkcWZh7OyfP4kiO5TnL8x0H+GyT2/juwXjWPgG2q3jlzUlITXSsEf92nt4A
	 U0XQ4si39pZo1N5LDpHXtJEAi/rXzQDoxp239dc9upMoQm0OIgMO4kwEoa6Nnjmgcy
	 sdurdRML4tf7jFo06dlM7+za+GVcYLxVI8PGy9muqNSjV/nOauqRVxuqt2lTHdh1b7
	 7956953cxQr45TOjCYP5S/v0UHz0e/WN7pOzDLwUrEHL4ZWVRs9nHLznaOt/hC2f6g
	 WsDeiesyvxwB6pgmGTt+KtyRCQZe2Yth0b0GKXf9/GUXIlnTy/KdUjvQYGcfK9fx/i
	 3Mzeuebipk/jQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:11 +0100
Subject: [PATCH v6 31/39] mm/madvise: update is_valid_guard_vma() to use
 vma_is_mm_backed()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-31-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2135; i=ljs@kernel.org;
 h=from:subject:message-id; bh=6dMykbuVKPHDM4xFoe98lOwVyjcSXwfICmdhz8DaKPA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZxhWeI/k1t/+0bj2V5v9vMW7pEtb9Y77P/q/98og
 StpV1LyO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR/qcM//1Yl/R9mrfruMzR
 zNWKb38qF4lP7y/8pROyX+TS7/XeX2Yx/I/cevmz66tHxnHB7a3/WD95Gko+9pSSE1ryNvD89eL
 S66wA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: h5qnpzf54yzpnd9856k6p5bjcu9wgbbw
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E2FE1C0005
X-Rspamd-Server: rspam08
X-HE-Tag: 1791904944-3902
X-HE-Meta: U2FsdGVkX19RS5EbtX8ngj2mWj7smoMi/mAYsd6+MLY3iL5JhLzK/590BiSZhRcoOVp0dovAH0OI71+IqP7PoCPw85y3MXc6Cz4GIIk5GgS3fpr5+4tshf4Mq96Tpoh5Hr9Q4oSSzkN6Fe+Xmz54MlnpKyX87mys6EC7f6me2zXQrRX1quebdVKZFV0kTk65F3de+XIo+42XrqFFmAUanCzQ/eKlJk2iNrRvdrRtERhW6h6qbNRc2CuowZ6oYd45wizR0D0/RIM/SS5iI+h+hNiZG9Hzt3oM9nqBV3fU7EKnR0d00TTXcbWJUdTC1zaWUvWtMRSqs26P3cyy3zchz5zQnwOezX92vVPo403mApSkCgyFO12qADi1I6oH00WMB+qgLxjg8aBo4XrQ2YM/fWQf4FDVuTCy+Pr4ziD8cQujEDPxlqiuRccLCx1yIKUuEltRaz/0H4WT0TmO3g8Uioc4M8RJkxHdBuCe+ZOtO63n3JxVB8YYGcu+zWLUa6CnR/9b/NS4Gj50uFQWCM5N809SvVZIxw5aQtRCLs+DXoEj7rb4Cpdr/Uq+KIERspD9htsogkRXE6CgF/2F9UtPZ/JoEihIHgDUfzVvR4HYt2924T+p9WkXqBZRBGkBS14QliJBdilAchXLcLVU0kYR0s0sRjxcpC+9ljTgL7ek6Jbik3HxDbobRY0wcefootxXH/szcqYz0cSK72NnI+oy65zBxOxKMcDGmwS5yHV2ece5xvJhhP9T9V0EI4iKqIGL8tFVRAlrD/KSH7Eo16byI6FbldWM2JzrEi/SouaCAMVVAG5a2NX33NMwIE/PHecAZMm1iC8UxD1uTOeNRaapyZ/tM0k9RD7pIlo2kckjFUMiLV6GlepE1hJzJFNTxpjlId+p8JB12GYWzNfJOnWgUwGwI4bD7jRHqPYoUIRIa0WSsvw+xlUAzQuegb5yw95rVbRd4U1aExMFCTraRAc
 xadUhrV8
 8Yw9gy6dQG0AMp/293+VsmJcfd8C0Fhea09dBaVC57ko2J3HmNmLT5d6rmoWvDOePHtgJHEzJ6giEY1wPj4vkWjkHTUqpR/UCacs7uRO9ZFCOpqTg5DuyaBRDgZ75D2e6sn6Et2gnV+9xjYkcrcGRIL9f2hvpWKNqwB/XOYSS+27TJ8JiMvQCEjlmWytxa2DRa3YkvPml7pAMMu9JXtYzWFa1SLODhvbafhSgwT05SqgL3AkwnDofnfv7TzheLe1so2T2fLkEo+2oNgOCDDEuMVZesQHIlNtRTBlO+VytFMTfTw2KSxXVnWuy0QXSb71xHuqpWhLpej08SPjjd1w3hsOu4GqIHFm9cIVQRLQHebR9y0j1NSM8nbNakrureie+AmITfvHvk+/K6ZDHsUtj8jW8WyZ2Yh3v8aJm2P+/QGyCz7+lMxfP5hhHqTPcCWwzUtqX5IYwuZhQHP08GUek3Y0tpX4yLDYyGlsbn+t9NLSP+h/rzaoXT/Q76EoCmxsyCMgMJc0xwbMxylky7AX6EQRF1AUpcdIm8hljXnQwQKTmHe4poBTkRNlz3Zz46El+rjBAmZuk18JNQgTc/k5RTIK+lsskCzTVTNuJC3E2G6TAihoPRx/BH3XCK7jJlSwggKHvRpWO8PjD34/VdzAhvYuqdc0MMhGHI4QLJEJYd0njskaOzT4u7owzScZLtLsb67+x0x+PgDS6kYT/DcvDv9fe8CXuBHB9YsdGYkrAYRyNWTrJLIBO3x1sD3yKoooAAjldxQpvxeiB7xpeLHBLY3eQ0drT4QhA45crftMRAY5J8KJHAd3yRPY2PLl3MAw0oAMdd0/Nb8VJdf9L+jQl3r7vouefq2svNaW78hu/xUp9S+h7P8wiQPQyKdU1Mx2ueXrhzzGy1UyC9YKMQ3muucQTHHkQTP+goYjBPRpOuecl3gHxTfiuc3WRDxg3CGCwYOW30ZeXpyThZ9n+vF+FKe+k5U3y
 hhySX4vu
 vbchOHuxiIcf+zcxJylHZzTsvkI25DrGh5zGT9hbn1CIe2ZUDfmF3NhcPz7Yu8Vk/5W3uqBRrXdDIrnDKWx3W1j3owoA1P8kc5srO0FG5xnsGTzUREy/1m1HG60+FBw0PD6Ef8/U6u5Ny/vckYhy/LZnWkxnuR5NYSFci6R7RxQW7uYUvbscGxKFcRWYAPJIMrMHmCkp90kAh+7a7a/GKW0qHvVRTuIUDVBMbsJ+gAGnhCckGIi/mkiVwwDpD92ZJXbLa+Q8jSXKHE6u05CR1S2iCNGmToVyPP96zEt++UMjyhblFJik/fLh6hB91C2tkUdzRdHL53Q2n5m+7KuBxeUHRoF0GcKtALFU2dPhkBnWlBBiDsHDijCNUwz51EY92E82J3TlTUkcE6Omt6YtluvrfPC7lbsVkFRpA1XMJ5u6NNrwHFcpJJxN6PHE8yRs2EDYkdghOc/8rropkc+mWrN0/s7Q4Bd0vTZKmGWqRRE6Rh1AKOTrDygwOlIrz3w1C5lol9Zh64BS5np+je/lzcK9CGYnXTFHX8gAnC0aGbXD/po2q9oL1caTFM+sCC6HvWB7wuSrHOAFPbQke1yerJRuoo8pNdy98403k+2tdfxViCVQAZSucnrm6vzsG5bKGqD3OrVwzw6T4cvcIgnMjcQEsVNV+9chDD7F4t6vgpM8KUiRMsziXnjCXpyibeiU7nOf265zrfiolSkrxlQPc77sWbf5QMZSqFDtyORHCb1w7mfSEHCoagwhWEmpj9/7ii6XIBN3GeVjxcMPzvzemw9qGr6V8qykHBKjvUhetjwzCEFHvyA8QVZZ/BJee1Rwf5eL8XYXDOvPbiwDSZAK4UpJB2uaibrOBGCtM9hOTnnEkw6bDgot7mdouEGTYycuCET/yy0+3WoG3Yp32KdCYOrvnt/P9rVAXHZ9v4KYyi42RagTUeHfWWJJmcNTegM/9NnRNR6jkafrS6s3N8dSjvNT3Sezv
 0ZIpugX9
 CRXNmPIm7B8t+PJ6GYtTvvdVdNtapUS7BLrZNYLrzJjWC6nXwGaKmcw0JNfL8Dm1fZ3Wn+mwZ6ibHj78h/TL9Rp/076Xs5bTLysTrHFyb9XJtMsrVc/cSXCjut0t6nVds3RKBH5oP5zkj2JYDHzBkrrtXZNEHMCdPmHY0WO3vC7f8aey70628nXHZvmYEq2qTsX6Nwu1P6s2EMFyryy9BvHXX0sw0njfMon8OjLDI3w4AM0iEwNhdZv0D+9P+p2d3MapKldXQefmuaj1ZBKLMUdXHvMUCrqEtaS7cn538E8Ac7bC2411d+EfRNSP9NElucCJT5TMgJzO3GMrdYyrzV2N74PNzI5Vp0iCk5nxiAZD9f+1JSIaao2AYm5OghOwYMDB1ewM4wly+Gio6Xx1T16Ue77YB7hmwI0cPeY2XnldezOj89IitnLEeij850UsyBLkI/tdBriHs6J20yh3wT0LpVI26Gy9DGy6dctW6wGTwZvduxbrXe9N7B1EKFoNkVnV8Uc6tbD+E3RepmaNx0LO6QfvfxhD645doImi3gxftayoJy1+tjDfXv55QDMOOEd3KPbHdR0GkWPrtKMcIJve6KMPNNnu+o0+NS9bIz+pQq4JiDWk21HnON5dPPGn65ZQ41RLLoC3YrHPV83adaUpjmvJYEVx23fv0JlnMyYuv0tqDnz+BZA9ggAZxSK1ELtgtE11zqtqgXENw7j+H8hMvdEUggCvxco14lNP4sNPrZPtbMOV0N6oqJARq0cpJPZX1dhM64KcRgBTbZzQZ9Qirm3bQJTEcpEUXRWDz5Fh5ey+nDHp1uegVy3tCKAt6xbzOAFKt3P8c+p83eR2cGGwjTBJ35IMWpOzS4HYSv1eNJGlcLhOrv/2vX1xPKoXGd3acaURs8bMFDYi15kh6AtaLYZYHeAZRDPQb5mgwVqP/0Ssi2DOKAEoyOQ64l849nNeOcYfOU1OUF8C+e1zsG6szVwxP
 oSklmh66
 bBUX7bIPn4BTM8vcjCx1rFZCE4h3CIvPKH2RPZrNhIeOF9fRhp9iViaosbqBQQCXunKYT174/d2bRY5b3lChnrDQbl5ujnUnVu6U8WguGfg9Z+zCgxXtowEPdVCc62Sgf49xzf4Q4rmRvTxuDNMokIDKg8uo4rv3gSL4W952lPywjpz6VWcmqiCFF29+uCINHPI5Ru/HmCdoJ8qjluTizH387cFZLZxlDLQXYWk1S9LgnK9U5qEaeurZKB/V+p2HKYUpbf1rZIeWYEA4jRYhrlm74OOR9Xo5KFf/kaIKKa6uOTRPwaZaypqiwgUtczzcCdCQynZACjMjkMdLXRroG4nFF/hbfJd8RLNy8Q8W3Esg==
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
!vma_is_mm_backed(), excluding hugetlb mappings in which guard markers
cannot be installed.

Update is_valid_guard_vma() to reflect this.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 3d25202db5cc..7e14b3fd92f6 100644
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
+	 * core mm, so the VMA must be mm-backed (excluding hugetlb, in which
+	 * guard markers cannot be installed).
+	 */
+	if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma))
+		return false;
 
-	return !(vma->vm_flags & disallowed);
+	return true;
 }
 
 static bool is_guard_pte_marker(pte_t ptent)

-- 
2.55.0


