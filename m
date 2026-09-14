Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43A8EC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5903E6B00E1; Mon, 14 Sep 2026 11:17:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5674B6B00E2; Mon, 14 Sep 2026 11:17:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4595D6B00E3; Mon, 14 Sep 2026 11:17:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3A86B00E1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:17:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9574160190
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:17:54 +0000 (UTC)
X-FDA: 85212722868.18.A5A3834
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id F06F2C0011
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:17:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SJBEb+Gi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789399073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJh5Pnd5DL/qwxE+WalsUTaJGJt6FooGZcWLpPNnk7E=;
	b=Fwj7K0g/cs3QmMIEZVynhnQtyXmrm5opmeuOJ6DxYt2vuIWHKmGIWPXm0GruPU2Q8UCwxX
	Mrbw7Qr72Bs3ffUa7DD5Z2X+vnsT3VZQqr3UXbVy+c/8E493/ciQ4e1fD+cfANnvquVXRt
	G/cS9iozUXSBAOX/srcc5RVmBU8j4Ho=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789399073;
	b=i6P5+50g+q4Thg7CdmlMAUnM8fNlsd+PDYQhb9Z7qtXCZ4Ia6GV4dKYuSXQS6r9uz8HKsH
	v+QRWeQDpG59lyR+9VbhbzT58JE2ttIBPbU9bkAkNd8kw9GrDBOgNnahAEjglwfFI8KOwI
	QLARa8d1JcYk0w2qjNr2G6/pCUYMpjQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SJBEb+Gi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82C8260252;
	Mon, 14 Sep 2026 15:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFF01F00893;
	Mon, 14 Sep 2026 15:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789399072;
	bh=fJh5Pnd5DL/qwxE+WalsUTaJGJt6FooGZcWLpPNnk7E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SJBEb+GiYUKwq78ymyy9xZi5YxHSsl3+R12Wq1y0Nsf2/hsIt5f6VR12jG9FLsmoK
	 IEzLRYU4gHRuR3B6UrSWiBzVaqEaDWCvCvmqwrdKIuMYP29tsdN9RjYMUy4sBEBwEO
	 Qwmm0RQ5msDwyuLQ8+6UzfG1pCgJHdctl691Lrfe7MYxV0tWZUErIIggyXeia5YmMK
	 h6wnFZurT6Z7hw2RrQcbTH/vH7UDNmre0Tsy8MF/iVuJWyzO05woCfsOn57z0QCf6a
	 f3RqU+jD2hnz3/Do3nZKKt1jW7hJNKGt/eLLxEZU7UV2k/yAbKikokP9YsJLwlWHCM
	 dm/lMP+3dWi7A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:58:00 +0100
Subject: [PATCH v2 40/40] mm/vma: introduce and use vma[_flags]_can_gup()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-40-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6501; i=ljs@kernel.org;
 h=from:subject:message-id; bh=3AnqccC2jTUlmIOHAi2JESa1NkBfZlWIxg9a+l0jjPI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG/RLrydJciw/BS79IsveW9n+2r99rmurBlodmpS+
 RRx76h1HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhIkjvDP93oPv7KUwVZyzmP
 /Y5JN7v5L+H3keK5W5RUpgfrJzE0uzMynHype2puUKfCJhPhXQtYMu7XXi1Km15XEbP4QomOrJw
 oLwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F06F2C0011
X-Stat-Signature: q3p7wcwmo5pozc16w895fjgqi4pezaed
X-HE-Tag: 1789399072-95113
X-HE-Meta: U2FsdGVkX199IIJGGQCVe8RWNQA+RDJGojV5W5AAALYBrUtjkdSeBYOjpwn96nHn0FSwtKyADvp+s7hboQgrlmzyxr5NRXNY47UDiUz9GjgoahAzDcmwcj79g5TY0lOZABZ51UFExvVuLSTnTlT5BogSTnLOaNSDsR1O8FcCXnFmobDWPdOZwWA5ZV+G1IIIA08pm0KXRe+CSRSGZ+Vk0vi7+nK0Ma4C6wELcw1U/H0wuJjM3O8c/+NdOuSqDj7n+qQCPq7ElBJPTB7mYJa2xRzPJMMJWwMd80zSGHPi7JDUEdmpzFezx3STVPZ6CrQgk/TB7BQZT8vjUulig53V44z5vXf3bsADMeOskV0PmQglwFbWf4MDdrN1wnhlgQK3b6s9oxRUGw/4lAdyDw0D58wRtPmz8kKcu+h465mic8jgzWmlHitcBq/2XnXFGAXSuI8Zm+EbebDFXVhRGluSE27aOshVA9C/DEuUGpBCMkS4IsXEAfoMh65dVdgw/nq39fpJPLfXJZd4eQ0G7bXi2E7qQxvCSJPiFCkKdTIqPD9UOj92FJLpbAYWMmNnP8KQ9rPcAYVm7Llkjg2xcumg5jeg5Hbad9gV/+wnBQ0tFrR2GBelww+kv/CRzDyBIdwMDSV7xtz3DB7D+u/XtzK25Apg8GeFiz+hrbDNBQuChnUdbVsofQoMTS6B3cArFi5qYTIRbImlsC5t0qjtTClrDg+j5En1PDeUI/5bG0CSWMY67T8W03kd1VgqHoVUK+Tw1jLxoBvkp9Sj6IdcHcblwRQOFNc9E+8UbzctrShiGyTeK7VLROWJoB+gZm5A3Jua6jNcTWNsttJFYR/Ph34ZzS92MqNwdRXRSJh/Y7YK5KL5fNHxtLqq+HogfOcYJqZzQPhhar2yvFgmCnnu0Rw9j021r3VtbAsjdv/bCBXvog2VJ2OZUYy9IzTWD0PohdEWHi+jlMxfwvMb6ujjR/V
 z25tXJAW
 J5UvHR7EHUY/hB+Z4NgtRn6LmtxMgMtsobWPJ9VxQO1OqDAH2xyOmpPH4rHqBAiEDBITkEesZPOToQ/tozpWJ4vXquS4OCRiBgLcj+KMEST5EkN8lEmZGOX5H0aV53CUcu1oRfxy67XCnvHhVBFVlNmdXBIoJGvAmlI8rDKsoXa6bKrz0zJu1Mi24p3oERRdK/BbfaFh/nDGaaRt+Ig3kMgVyMuJQ4N/TOobGRV9PqVOZFkxBWUI+kK8u7KEZvwnQHSImuAFdb6Vl1luoKwXdGBvH9V1+qlmTmi5ZH9pfv1n19AGAM7BVrtm9TdfqAV3LG43yF3g7tsybVGQMRLZZHwvwqhewKk5UJ6rv+5M29P+Fj5qeoIu64/sPnfPtp/n3bmsqpOyn1QKdnNPCneqYs0u1ix1EpHdFvxFT6FSl3e9uwaE1NITKMfdmVj23UToLvgeIawL2sTX70huAJAN4dM4y1I7q/9BkxE2nrbhKBO6+hCv/zsASA4KE+iv7KO2BB7YQDa6uW3Y1EN9qN4sa5XH6lt4DffY/iGwnudKFJNqDgeLmG4QZ4rBZh2U/6azvLREhvxz6FvJLjjn9hLFwZzpPGzCsqlBCCVHXgK/FhQnn3Ng8if9nQzgfi86yvmOwCqMQ+alCH+DRrhLrx5GczQaX4Pulk9RtF3Jr2+Fq/tU9aEm/gu9dwcHWEeJqTpK25MoGX6JL0LFgbqGvDQz+ey1aTcfmYhRirzuNenW60F4wpbHuA8b6dZpP4Kl1o0plEeb8akMCPIgVl9V1Ij8vKscOH1QAHe0ZZ7xtdn7us4KTBEl6xeIS9vOfeLxvzLQHJg/hoZ+cAHRI2Evg0dlID15rA9Iu0tfmMXW8Xg9zafBQLPtGJfPPqM5EyRdJX6pFwInJbcuEBc6YMnnaUgEgKiyTJMnsfFKKe6HN+ozH82bgSvyQ3Ni7qTE3jLlhCGDuKzzgZejDDe/h/nXpTCVm4W+72nPu
 U/R5ggyG
 +NTvqYMapMj/iWWyib3B9Ix5tG9NuB4vitixc5YVxPh78P2yyirXpQhvmvQURymn+ziant6ei7bVBuhp7rYC3Wtbz/YSfCOk7XioZNzUDVRiJyzRPQq8Fr2K3b4+GZPhgO0khEXNgS9mmkvQCDPAfchqiEctc2cE+n/UCC47ao2QatTlFD7Qft0uCFletmyX66uZ0tMYwstaFl0vCStBwIY6/eqUD75QLEnuUaoI+mplgwNtJ4x8DBijW2x31vZHtZD1IWRnjcfN9jZRRSUcCh2MST3rSEzFOIoNCyHRT6x97H0TEd33tZf8HDlRzpWvTzgRol4WTccG7R2ptjV3qSUjfS3xE3OT5sT2o9iQGYiKqfxbxLHneQUE7SvEb3DvwO9phFeWd19139Jm5II+RElgDaIpirGpyLAtI/5nIlRvtsvFJo1yTrqaeZpW5xR4Ku74JZZweUQUwBR3EzcNdseAmhGgnH9HBIoVkpstgfeYBQSnfhHxOzByM9CUftGkWmP/Hbs0U+amIfvEv6of97le+w9JocfVS46EroQX2ewqCY6RVjPQ8zwGKex0CZNkVoToetAw+v50pi5hkEfyhcMZwJ+UItxlBQzvFhKWahcN4/XSa/09csWfj5p8JWKOAB1ezTq80vL/9YBKePfpAd5E6+unwDoGibhCXlvJ9oyfcyVzZBOK3T3K0dhkowwjUMF5nmx0YjN0ASj2P40JG3yFU0oNngz0n/NBR9w2t8n1/886NhxQyUvTx0FDz6mM95u6HP92F50WstAWYemolKNj/sDZMZTHqr29hLtVfDtGVQofb/cBTOAxwQTF6o2iC4eiYlaud2skRvfnGMErhf5b5wxFsTBd/51zbaf0tRmmKXewbqhxnsdOQ48xc6CtnDDyuk2u65+BvYdyhV3lut+PojBXuZ7wm5p6vtL+JfZUL20gIEromHKLtUYCUMcACUzXfemzY2D3V8CFSAtKeRHHndptQ
 olJhOpFw
 jt6Mi//1SYf5t9U08wYFykYzG3ch8BsMzxva/jbf2md2kqZ87XKn8t7fCjHD386hRbs5FSiL4tVDcTxNxPgo/FTYE6BGGO5mqUvjHYZbH9RQwcqyi9h0Z88lejYKvlYhN3JrDad3gQ/xbI4fus9V80A4a7d0Qd26oXPM5B6sTKeCWjto2xtj+rZ0bIKyF3IN2vSofoc9J3X+YJswCnZJAtO1GbbkPDcFMphfUgp1PJpDJkQ36wRusrvkYGGoCMaleBSciza1IsvGzlFau/vkVKAOzZtavbVh5WBJpeuu4HYCndGEqAELKBOLJyBJMHxL1WWJq6yG5K3WiYF8wTzsFhLCVgA8jmEEk3SR0OLW6z2Bw4kR6Yh64CR3QEcyVYsRfS3NUjdzbOmcRaEr4UKOiv+ORPI8/tSIZspGGSRyVHgudpTE/YgsHHAPXTkMsHyTcP0wu0KWdeD2A9KKQZaD/X55FAmiIAWjIpRzS7Mv9HoaE7SB+i7DZ52hta8yg5A2M8YeGrikdvNyDawDh0H6kUzzihidwebYS2hUwJRKZhnm2BmOwICL9hu61o96QhuX/1zxgaI+BGX21yiycBhdw4RA2CHqOGXSDGtIHO2IOxQot4o3B/MPlsu/ftASe+RpzAkZtDLP2qmcRU9qzPOx5S0slqWIf9avX9Gjq04sdqxhLtzJQvfWqk+ttu+cFGpVEhvjiqfwwu089/v2NgepiqVcvzaTCE8K0Sws8Gbi3XU73U0j/BBbF9j/jvzYR0EBzfYez6mI3VfHCl6k7yuBQgPPvWSe7etAo5AC9c1MJ86xKR+sYsC6B2oIImV8tQhCd1W7eVmmPD2HrTSv72g0VvtnWn5inrvsMbHxs1D2j2ni/zF0/RytnUUns4yGcxHBwuZa0RNEGHhEl/bwcuOnypoQ7u15G9+1YX10xkoZca5PepaIviNd6YlvRIqEMWOcfy4kAIjq5hxiXmF5Am41C4WYwyMpM
 8dBj/Glb
 3OBkcbTpyL/9Fo2dqooTiEwSG+ux6B9QHgA095oQSmdKE56cfAVwQOcxhLDh82XHGToWPzbLMO7Jpu3KzPe9QoHOF2Z2TxSx3pSvgJ3F7j0sezrK+ExAGaRix5bgJ/ISuO9jzuC6lKyAxw3a0vv3FUWJVvjEBFuX5PtVxaRftfr7XnVqDBN3AJ+1mWqr99JU/MRiUldMRfAVwZFNYaSotePlv9kzrX1CVfOAMdeuhqZfxni0+Ld3VZgdXzQXPZI8DwSOTk2Hv2sqdzf4vVOUj8b8nsNuJABy5ofgYQz0fFQEBKjSF2mW9U6vldwqCkhHVQujk4b+5/cf7vYNvoznyg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GUP cannot be used for VMAs which set VMA_IO_BIT - because memory-mapped
I/O must not be accessed on the user's behalf - or VMA_PFNMAP_BIT - because
PFN maps have no folios which the kernel is permitted to access.

Rather than keeping these checks open-coded, abstract them to
vma_flags_can_gup() and its VMA wrapper vma_can_gup().

A number of other places make the same check to decide whether a mapping
can be populated or accessed as GUP would, so update those too.

While here, drop a reference to 'special' and replace a use of the
deprecated VMA flags API in vma_dump_size().

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/coredump.c      |  4 ++--
 include/linux/mm.h | 29 +++++++++++++++++++++++++++++
 mm/gup.c           |  7 +++----
 mm/hmm.c           |  3 +--
 mm/memory.c        | 14 ++++++++------
 mm/mempolicy.c     |  3 ++-
 6 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index fb21fb6703dd..9f729c594c47 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1616,8 +1616,8 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 		return 0;
 	}
 
-	/* Do not dump I/O mapped devices or special mappings */
-	if (vma->vm_flags & VM_IO)
+	/* Do not dump memory-mapped I/O, which may have side effects on read. */
+	if (vma_test(vma, VMA_IO_BIT))
 		return 0;
 
 	/* By default, dump shared memory if mapped from an anonymous file. */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5860a3b4dba9..1249e04d7b98 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1777,6 +1777,35 @@ static inline bool vma_is_persistent(const struct vm_area_struct *vma)
 	return vma_flags_is_persistent(&vma->flags);
 }
 
+/**
+ * vma_flags_can_gup() - Do the specified VMA flags permit GUP to access the
+ * mapping's pages?
+ * @flags: The VMA flags to test.
+ *
+ * GUP cannot obtain pages from a PFN map (VMA_PFNMAP_BIT), which may have no
+ * struct pages behind it, and must not provide access to memory-mapped I/O
+ * (VMA_IO_BIT).
+ *
+ * Returns: true if GUP may access pages from the mapping, otherwise false.
+ */
+static inline bool vma_flags_can_gup(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any(flags, VMA_IO_BIT, VMA_PFNMAP_BIT);
+}
+
+/**
+ * vma_can_gup() - May GUP obtain pages from @vma?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_can_gup() for details.
+ *
+ * Returns: true if GUP may access pages from the mapping, otherwise false.
+ */
+static inline bool vma_can_gup(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_gup(&vma->flags);
+}
+
 /**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/gup.c b/mm/gup.c
index f166acf794e3..8e9ef5ee7498 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1204,7 +1204,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 	int foreign = (gup_flags & FOLL_REMOTE);
 	bool vma_anon = vma_is_anonymous(vma);
 
-	if (vm_flags & (VM_IO | VM_PFNMAP))
+	if (!vma_can_gup(vma))
 		return -EFAULT;
 
 	if ((gup_flags & FOLL_ANON) && !vma_anon)
@@ -1955,7 +1955,7 @@ int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 		 * range with the first VMA. Also, skip undesirable VMA types.
 		 */
 		nend = min(end, vma->vm_end);
-		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+		if (!vma_can_gup(vma))
 			continue;
 		if (nstart < vma->vm_start)
 			nstart = vma->vm_start;
@@ -2017,8 +2017,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 			break;
 
 		/* protect what we can, including chardevs */
-		if ((vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
-		    !(vm_flags & vma->vm_flags))
+		if (!vma_can_gup(vma) || !(vm_flags & vma->vm_flags))
 			break;
 
 		if (pages) {
diff --git a/mm/hmm.c b/mm/hmm.c
index 2f1e98c6b644..e9569b82a1f0 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -595,8 +595,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
-	    vma->vm_flags & VM_READ)
+	if (vma_can_gup(vma) && vma_test(vma, VMA_READ_BIT))
 		return 0;
 
 	/*
diff --git a/mm/memory.c b/mm/memory.c
index 02e9d5d2e279..9e4a70421a6b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2417,11 +2417,11 @@ static bool vm_mixed_zeropage_allowed(struct vm_area_struct *vma)
 	 * be problematic as soon as the zeropage gets replaced by a different
 	 * page due to vma->vm_ops->pfn_mkwrite, because what's mapped would
 	 * now differ to what GUP looked up. FSDAX is incompatible to
-	 * FOLL_LONGTERM and VM_IO is incompatible to GUP completely (see
-	 * check_vma_flags).
+	 * FOLL_LONGTERM and memory-mapped I/O is incompatible to GUP completely
+	 * (see vma_can_gup()).
 	 */
 	return vma->vm_ops && vma->vm_ops->pfn_mkwrite &&
-	       (vma_is_fsdax(vma) || vma->vm_flags & VM_IO);
+	       (vma_is_fsdax(vma) || vma_test(vma, VMA_IO_BIT));
 }
 
 static int validate_page_before_insert(struct vm_area_struct *vma,
@@ -7116,7 +7116,8 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
 		goto out;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+	/* Only mappings GUP cannot handle are followed here. */
+	if (vma_can_gup(vma))
 		goto out;
 retry:
 	pgdp = pgd_offset(mm, address);
@@ -7316,8 +7317,9 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 			}
 
 			/*
-			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
-			 * we can access using slightly different code.
+			 * GUP failed, perhaps because this is a mapping it
+			 * cannot handle (see vma_can_gup()) - such mappings may
+			 * provide access via vm_ops->access() instead.
 			 */
 			bytes = 0;
 #ifdef CONFIG_HAVE_IOREMAP_PROT
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 044ffb4f4128..2fd759e348ca 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2013,7 +2013,8 @@ SYSCALL_DEFINE5(get_mempolicy, int __user *, policy,
 
 bool vma_migratable(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+	/* Pages which GUP cannot obtain cannot be migrated either. */
+	if (!vma_can_gup(vma))
 		return false;
 
 	/*

-- 
2.55.0


