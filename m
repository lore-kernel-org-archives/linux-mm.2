Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69CD1C88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:16:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714076B00D9; Mon, 14 Sep 2026 11:16:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EDB66B00DA; Mon, 14 Sep 2026 11:16:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601D26B00DB; Mon, 14 Sep 2026 11:16:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3664E6B00D9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:16:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D125BA3F2E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:16:04 +0000 (UTC)
X-FDA: 85212718248.04.E1F059D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id EFEF520004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:16:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MxdrCpLO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398963;
	b=59TAyU0CCjgks8gvCtZu/FJJho/39WQhOOazAF34doBPiLQozej9k+ERx1tCf5e0rYXJVr
	KPF6MfrrFFwCC46aE94ZBmNf1JDYw+tGMVYd/1aq3k181PZfnt7yTAqYaBd322Iw+PgUvs
	ZHnXuoyRvsupnRy0LBCoVq0IJhjmD6Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MxdrCpLO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbEvWuDC6KaxDOww6JLm5X1oq7s2JCzdjzk0eBTVi0U=;
	b=vim8+IyC4Bed5gTkUwZKhrwZn/tcjmh9vxyhTMBsNY/8iTxLtc1KNPNVrnofdwmfTmB/db
	mKB99AYboAh5AXzOdQ8mgx5rHOccRMVf6r8L1Aqme9V3KJByKgaMzYy4IwKp+smNK8OVgj
	FgWw5VuPtZUoJxNDTQrfLIoqLL6UfaE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B74B41245;
	Mon, 14 Sep 2026 15:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6321F000FF;
	Mon, 14 Sep 2026 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398962;
	bh=FbEvWuDC6KaxDOww6JLm5X1oq7s2JCzdjzk0eBTVi0U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MxdrCpLOC2vOCZcemtaZ6oFnmQ0a8pPB9nN7DsCjDHO9sc0yLP4UpDwQK1Qd76bot
	 i90zW1WlgaXHZYE+aNgAogt/AgbuilxhUbeQIQJqk379nZKlkI9G2ntVYJTNaOHtk5
	 raRFGevq+sCzIEM4IoiUyZQxm4gpkiTWvUTfaWLf9Hd7gfcDTXzzaFmdGcqkWSagwR
	 8SFE2RsHHzFCmWDpxYDJYOK0mz6bqQe+bt4SsxlRXb5iAvT+WwozYdJ/oCY5gMr5vW
	 VWXg3xogLHwk2Db6zMqdOZu9xIvo+VLBk1KAGmklN7d4S6MOUrKkrf8+19eA48a7Iq
	 wNhDnwwUNJWMw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:56 +0100
Subject: [PATCH v2 36/40] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-36-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1631; i=ljs@kernel.org;
 h=from:subject:message-id; bh=12r+57hlfcUqhp52wOQ04zakYjCIf/s1O/YwMYeI4F0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG9mmpoQf7zZ3fy3Qrqw7jOm/b1ico4esTundPTu2
 1jebravo5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABP58Z7hf4CmAXd8eStvfkbe
 hP/b2GrnNPCGvT3x4dCJ9gmGymlrZzL8Zt0e2MmX/mib5xep7V555lc+Nkqb+u87Y56650S45L3
 /jAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EFEF520004
X-Stat-Signature: f5dpo361qifnyqn7hfqchqjb3p1dxu8c
X-HE-Tag: 1789398962-729407
X-HE-Meta: U2FsdGVkX1+8oZ0Lpn9L2y4AOLK0YqhoNKdr73DS3gePdWh01aYFUq77xl3BYKuWF6/WL/4bFBrMM7yQil3Cx5My1Zxkp8cOnjN2Watpmx8HOtW1g10EsqaGTD0NGpcb7UviBeyMSdHiR2aDkhajz6tovGizXBC6oSjYgKJ07+UvErtPZn30g8Y1U5rKoDfq0yIu/iw2ML8nEs8aOGeyQ8qVgU4ZNyiw7lX4nTwMPWLzH30emF23cGxR0paEEmFHGuDHQYYVBNSSRttXtns+uqszzxFsLaZe10cfTpR/911hqdksayUAhxowGcjExUaOgtneEdAlHdVe7p+NIXL1kEQUP4X8P2InyBijLhCsUP6EyU/SHIdYC2/WGDwsX7tUiEzFB4srB8rbbEz2JV2NvQn7/9n4tyWcL+0oIwhrK+XneMmgxldD7MVCtPLQbX0b76vXA5xaWnVWGT7NqNDbLUtUTqENbBMY3B7NlJIdLJ+TjOoGLvKIt4qop2H/BjWdaRexPZBmYzSLWnKQWyBYjovjohbRQh5T5Dj/onIEv1wOWutEqKSO8eHIWmx9513Cf++Z+zO1gUfXp2aEkdZQBykqHoaP2j9ioKKYJN70CJrN/k3aGem2OciU+e0Iw+kFW6yjr7mK/P1g2r1tKaoK5gQ7KOWHZNUGqIHWYM2L8BJdQmDFbSmEkygR3WjO8BtPRNsycGndDEXgE3lTwkuisUosU8te74IBVE2lQLnIxiOQV5Tv1WHAN8RPhtJ3S6A0tu9gTubqBnNx0CLX4C4bkucccRDX5JuUoTqQGzDGpV5yt2tvJQraRTmxp2kIo0zX6si7HpR/U0xFpgFJyLkwxbALddzq1WrG3V9RCTyYUuCmmhQRCtOO126TFe49f7xMi2FRb3hpNExJiwzaysrVFSpsK5wABfwGEVpFlIgxygrhjYOwgJ9kIwdYL1uL9BGyeXv1q6H1yN+n19P22wP
 DqMBgQBP
 0y1HeG7/UuJRG5SAkNzENQf6oqmk2Sr9Bs5BaHjxORSrrmn7wDEuT1SkycJcJ7uH4j6tr8VLDwZpPcMdDa0q8PInIN0hYzC2vfVCcRLb5EQzqJTcTp8D2w1QENoyBEG1MDvOo+P/uOJEjdGO0nGSWP16fnZ1H+jzqhXBNQFaH4X/c7bAkd+FtWpANZMYi0nKijbMGblVbVv9Qlz5SdeGS8MCEWrp87H8OGHgf+jnAfDIwFmyDSeL9O03+UjAEB3q3a8B0Vm5WcMHrw5JuhavvV0Xu1Ysm1EYm4hYu1j9OREUqQxO8f7O0RVhODoXfPdhW72fEHWWlBR380DIoBHcChZtMx67pBX7D07bfe59ggVKndrzN3B1TjY+6GMhu0plIdos+AQgVTSFIarv2318YnTHDMYAnaZJGb1GipYjGnNRGFKTTC+BUpZITYcdfK3kLX+TWKs9+U6Na36aax5kCLrYPsiKEM1c2YNCHOrWPfoYJm/wOqPiTQwLI5RO3kbmdCUGRUgMVumAP4OfnlK3l/lETc4Aq91cbcHhNoH2kuNoE/gXEz+7PPPpGvI10TC+oTiU0+cAOOKaZF8QfLAPtvulOVdDFLmb/n4WZtA7iBi8OLVwcj75qvYsChePa+FLZSzdWkm5GQtGW/ESO6TEBP+EoGwj3TAX/FePuQOpDpC+F1vHfN9NykUV/mt8sq6T96tVnax6PJLFrjikkPLHbCQzAodKzgvhPZqLB+OaB9kqjBZk+AJWWi65HyuuXvjpx47c1YMg6wusy5twHiu7ZZbDBYYiSZ7tE/JnArl3pxlrXX9P58x8om59sbg1kRtk+NgIhL5uP7cgDE1W61GTh4ylD57OqdBIFxU7Og1Snf77s4QA1guK+exY3yE9Pts5krHwjaZnL9uAOGwF50LjFf8l692YBjGcG1Fq04+SKkEH+j0iZdFruWnkROzpDWTggp98Coi0q9nMVoXMWtJZlVWSkmg5o
 IvxnIdNm
 7jUgO9BXBEc9sHs/THYafg/6WHulPnhjN98aq6Tje0+bclmQnsKWHxgeDXzuT/LD8wAUtrrZgbh3kwrvvGjaS1fQJmWxGk93X32qjBwoD5FXdOUIc5KJzES63ofTRLpoxY1RWWmHFtt5plIdyUc2lQ8XhAPSKJyGOR6esBDldst7FWhclqDlmVK3xW9sgBLsob2j0YcphNLhicml/YiJRsgYTTZQdIyC7Z2W2N1cLkJYvFvC4RgwJX0gLSKVXNTU1ZF8ZYJOa7mHtG0Y66rMdY1MBLhEYedn4VrQu9CIXhqLHQkmbXFVxOIZcn5BtPi9pCvMAU4rEIeFB4cV5oxRZ2ZrUhgeBs6YQm9+qMAgOt4g5Gv2hf/gTx+U6NFjeiP1LKvjHhOt+i9kewx8X9TsvLCxmSfZKsy+ejkivTih8pHS2jUSagmqBcUOECwu+/7J4ZR9psWjkUduC2Q+Ejkzs215vJj/FmRCHuOhAuPDyuDL5ewoQVmRmRrgf61ZaaNIPm8bX7l3N7q+NP3f3cu7wcd7fbwJeynvY7xTZw4idhj3eTI1FQ3N7cFR9Te7Vl/J64Y344fl02BM/yw7wD+uP6VIDaLUHRZfeEZX610MOlrYQyLeV7XNzlyiBwOLTzgouLkQN4n02ExFiatth+hujWLU6XfsjxxMo7zRVXg4slwYCGMN3UMaa122Z8erG0mlmggolC3bNSv2yTeQC0TIay9I5ZPA15eObU3cjkHGNFT8gPYT7cJuJRqSLP8UEJPzeiB5MvHHtifNLhKp6OBr0QU1bU9+TzKGkTw4h3ThpiY8cYD7imdBDWs1LoyNNsSISbLnSLDJRyK5hF6cn/QEYmdI21jHrfWOxUgv4/hRyh5VS1HC7uL9qvi0pgMix4oztSQuThr6wm0qCaxpPLfuVTta2JKwYdPUKHj4Euum7fo+3/YBiUt7kSalQOt9vmogcPa82XGDmQAUUd3DgcF9F5B3B6bJL
 rTfknB1R
 MdmyTsI71W69h5azEaJ+rj6ZXqZB+H/BOTL1FpRP3obE/Yl97sFaC6EMYvt1YJ8MrXh+wMrfqYsHTV5KA/U6TZXLSPZ+ASWud/3OGZX3KNz4NTlqnn7exw164ONKYnA2ryCEhqF8Z5IH5SnqGWB3S52hbm1RGab4wwKDh+xuH0Z65O3OEtkKPqgrLNmxgf6Yv+IpnXRrL29Q4OQf8RsuVUp6hPnN6Fq0Bf2hwgs8aop+pxl+Jw+pLkpLgBi9TVoDstTzjCBfaYcOHUin3R8saeTbW13wt3RRMsT7rInzvew8RhZ9IesA/4ofLlw1LnsLUQ6Ze4IsdpJjA4ELusHh15h8cABArwFGBIkzsSrM0vohqGYAa4Qflg1t061CrZFfzYF4r+SpXJqdxF/up+YDqWB76KhvTL565Joj/I4Knlp2lwC/hxUi2X5sWxizidkC2Okh/N6N/hb8UkTIPsdGdwIXAKasNLlq0P4pGDfqIHK5qW9QKcdL37wdZU1jJoNGycyVnWfrQW/SwULapXyqgUVW1lbSIIDIazmWbuqLsKWbNmYUM4yVLqmDD8cp5Z+6E9DQwFVhN4lQKaZjtR80B8AkrzRLtUDA5fJgoFJobkhg7iAnziNZ2yAoAW6YlbUpnKVyX4aEbvXAcIc0TSuMNiF2nXXVuRmSfhsdlKb1xEKd6fp6r6rFK07BnKCl+bRBW7WdK4g5LcidAQirCrZpo8uxYv5B6CgGOWBJli7Z+9t3kMwEdXc0dHR4cuJZMHqNempNfTmdB9CxbUpqtoh9cmQaYLQU1EP3UJoCP7fLHVrxDHd3BFpc+SlfUPzBTRbH8lI838gAxRoU6Hz2fVut4DZu4G6ETIqOJ8rihD7RtnTh7fhS6Mco5jr4dKBijgPNXNP3JrFbBF2OIHLF5d84UkUKaTU6K175yVpUC5d2oqn3awoOKioq3falzGtS024CPNk+nuSAM48gcHj3d99/WNmq4YxNA
 RzHiTjr8
 vth2jyJ4kBHPVuSia8Iy0DIbtyWiTvzRAXEasKU9dZ857Wez83AaYVygZM95SrIABmHMEHJrvTJjXrJ7BknpAbDhcyzYyu/Pezu0ZgFWqS93ToKKfOPnVXXsLRiPhOaF2kQvYBaRIIiNRujqV6Gg8t3UMEFiLjVDvP+dxxY8vbgMrljAB8pO5xr9gTaNdRESPCYzthDXHSz5rXBT+qJkJs7Jo+JFKwEjiP3K/f9Tzw1S0A43kEc2uSdQeLTKkzBCPitlk4Rmalp0AgRy+eD2lw+mqXDwNIvR0r1cLY2Eox0qnmNZRIzfIidBsVcYbpj4Ib+pkP5OGqEXtFWIdKqBIQOoWu5nnmUQHlUqWvuHcNS4h7gfMbJc7WUmjKwQdsJoFAcj1eexY1mwP/kzq6MmQtcaiiL9NX5nJqhd1y6LT45NU+/lMAJGd7/LRYJi20RgOfWsYe9KGzzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have the expressive vma_is_kernel_owned() and vma_is_fixed_mapping()
predicates, use them to determine whether to proceed with migration. This
drops the VMA_IO_BIT test, which is safe as only kernel-owned mappings may
set it.

hugetlb mappings remain excluded, as they are fixed mappings.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index b9c453c28795..b74c0ae42768 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -739,19 +739,21 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  */
 int migrate_vma_setup(struct migrate_vma *args)
 {
+	const struct vm_area_struct *vma = args->vma;
 	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
-	    vma_is_dax(args->vma))
+	if (!vma)
+		return -EINVAL;
+	if (vma_is_kernel_owned(vma) || vma_is_fixed_mapping(vma) ||
+	    vma_is_dax(vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;
-	if (args->start < args->vma->vm_start ||
-	    args->start >= args->vma->vm_end)
+	if (args->start < vma->vm_start || args->start >= vma->vm_end)
 		return -EINVAL;
-	if (args->end <= args->vma->vm_start || args->end > args->vma->vm_end)
+	if (args->end <= vma->vm_start || args->end > vma->vm_end)
 		return -EINVAL;
 	if (!args->src || !args->dst)
 		return -EINVAL;

-- 
2.55.0


