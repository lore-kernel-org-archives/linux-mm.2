Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E94CA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 825BC6B009F; Sat,  3 Oct 2026 12:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AF246B00A0; Sat,  3 Oct 2026 12:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677626B00A1; Sat,  3 Oct 2026 12:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38F376B009F
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:35:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA389C09C6
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:35:16 +0000 (UTC)
X-FDA: 85281865032.10.773FC6A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E45F5140007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:35:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=an5n27H4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045314;
	b=Bx0X1VIsauxJ44g0jYPu0tZqZaYlzJxQ/Er9VQV0oG8nWbLD8F61LT5DcI5vc2Wp8AXqjw
	GK5sxCUGBAF92hOOfgR/gPpmnd6U7al2NATnfDcc/NlAFLmkiU8b7pE/xgw0JV74UHnRGv
	REfCFA9fdPz+iBQEtzpHgSfc2XrqwJI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=an5n27H4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lV50szqwhlOdZvvntvc8L71JtBIxPo0bLUpU4NKXmU=;
	b=0MsQKHpuf9HKvT1QHhs9sO8SwjXLdCTWFt7D9kT6LWN1qxZhv8fc7eo+axXSBrA8OTJzZx
	c38vCwcicFwyq0CAMbrvdQNkmsg6aBm0XBmwTCizOHbEOmiffukqCGMKPyPYfB3U5G2nX9
	8qjz4WV3JiKgvCWPmhi8Q/LQtlzcGOw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6146960D9B;
	Sat,  3 Oct 2026 16:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380BE1F0089E;
	Sat,  3 Oct 2026 16:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045314;
	bh=+lV50szqwhlOdZvvntvc8L71JtBIxPo0bLUpU4NKXmU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=an5n27H4LaIr8CIfMU/aI3Fk3pEz9sSK/4qokHkcvLqenEIQCYMhEkBWrNO0yeVfg
	 16r87sVhe24eeEVlr9eXmI7QTEho6eKgQ2A0E1e7TV8wjsgnVgcHUdk2CVDd1hxO1Q
	 lFtztBV1kuZLQsbZivrVXfPbO100aQXG41jl7uJBf1V31vPVBb6TD0j5KNX7J15guG
	 ICSkP8tk7DlD9DeLSiXZK5cD+NnpcfRQOoISt0tIfE5cMK4sFxHt4VOytN+rzdi+BN
	 9O2SM49V8l4K2yLXhTKCGoA0q2vEgMEoieVz8vjCoCZq8tlUTiVvZriByLrAHXVHV/
	 8ZlHbMSIJBAPg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:37 +0100
Subject: [PATCH v4 06/38] mm/vma: tidy up map kernel pages enum values
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-6-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4144; i=ljs@kernel.org;
 h=from:subject:message-id; bh=nvhkE4iVPWt6ZMbpDqr0VjZaPTTvkSGU9Bdm3A6LGuc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6qlXnfu+6PrhGK/z0yqdLPtFD8kmSXPGfvorynrDy
 1f19tKPHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhI1ExGhgOdGVdeqMyXKto5
 55fa7Edqmhc2xlt9uFwVMPdkzZSLFwIZGTZ/uTZxH7PKhoLV+TqNfpMjHpvk3Lh96YFQPEPr8rB
 9tSwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: mhjxbrpr63yckwyb3zx8ity85pmj57rd
X-Rspam-User: 
X-Rspamd-Queue-Id: E45F5140007
X-HE-Tag: 1791045314-804080
X-HE-Meta: U2FsdGVkX1/n1ybiJuI4mwACuN8jdjJt5UlLC7NuD2jjlAr6QyssGhdXuv4dUk1DYIcJ34bLQLhPAjD+zYmXAvy5lIX94eVEwyQNY/3GW5EOsoR/76gEPco1AB68AEqSUt70qnywDkZduU0JjODNp02LX31hVH64qCY4kw434Z7S5SuOm8WT4+uVh6+NDhK8IF3yknrZ43sROUGFezMPRYBAmLXBbhbJxUrZc9D9dC00yxIgEwWoDxcKaRxxm1s681KUKmLjbYSObQvEXnooTcpN/FNvvptkmJ4eLAybA2BzFgeIHuwxyhztGaY9x1auY1UUDFr8XdJ8+x29XxDMC5qavTPB0RkRH7AQgzuoveF/BZT0sGMkgE5REye27tVxTnCNuAZwhWyOZ2SCwC233FuVf/llqyRPOCN/Tig8ksshsl9FOTfiutN960TDP2o0cMU+SxKt4QZkuVeDFCaIkaZ8Lq5gajfhZ+TZR6GskNpFCleZiQLZX8iNVINkcwok8e41Utu9BQZC479C/G0P1wceu7m0IazzMld9o/ac2kGUMONvkhEU1f9XvdRDGnhizT2FtPeotj4VqJ1I18e/ed/cE1sq6YhCZ+AMdTd+Q4pcnEZG5dN4Yep51msMZSv0u5Mz/ryOMh4ImIyvOjM/7rPNj34DGpqrZ/566lJ8vPutbGFqdhSxbt0y8uzQw2//L339uhtbzEfwUz7jF7qgtnFqavCOGk/hNCkYktP0VYSNlrknfMYjK/CpSmxyHEK0bDkPeotnqAd0EfqRh4VvrdSVkVOQotVyOhV2Pifg24O6/hxY96mxUasFYGlc14qlJzCKTYSjFPHW5Akl3JUKOdy+zPhBYz1N2apybFlkxsy40ErNhwfrTVu6FzpOIh6stUypIoyffsGvUzdzw+cclRTrlIt+rwo6NwKt9+WDkGbd5V0jrtnd5CumAfoR4LUS44gU3qe5HeoOuDTJe17
 LKSUUG/1
 37Potf6XtAJ+yHNR/isYHnirVrR/9P/fnQMV6He89qQSObpb1OxxMJCfEiUBZm3Hojm8CAPro5B6PzZbC7f9vMMw2bgjtlRju1whKPa3Wy+RZuB8/56AaFSzrTEQ3UVj9wvoBH62EspE3pzlFT/lgPhgHga+EamrKQd8MHVPmy9vEC7Gt5owgcRqefBqsZMxdf7dukye0TcAJgjmXRs09UqwVxzQU3ohs0WK0bsuttqfFEJLvlVdi5HAdx8cOiMCmY6MvW5yPVTs57YcIaINXkEu//YqE3HQ0m5ZznKfLZFm5s0X6mag7KSpSm5JUNw/YhiX9/aySTcU41pU3xUwU/jkn4mL8nP82whPLNjQujsRFJLLcl7gxVffdMycr94Z175gL8FeIe7AquKGDANk8rPJKLgoDQV49fNhYK9nLWRgbCJVMgElDafkDD2AHgjyR5AUbPoyzW+vEjNNzOTK8pxpF5PZFIBgXRQanpr/z+AiyrYvH1hzbksuceSqhFFVKp8PKOp7m2INVALN/pPH6n5OVxCF3jZxwGNXdpjbNHxM3GUJ0rGM4srwtUEfI+hufg+IcOJTppLDA5Prx2S7XYYvNF27sqk2/VQtH3k6l5IZske/hyyhdG1hlHwJ39zQsMxbZPu7EJXYFtnsEYoquXtnKr+tHEqfPYPulTx9NZH/mSKmGP9wTR+hfzqqt6tXB6wiOb4lj6ENLUrPwSSNIWugOU5QTyDlS4ZKeJ/dMxHLGidZO0e50xenb23BIDjrpwfpdUv1yrc300ZJppS6YnLWk1PpPsR/VZn621hxDyjo4f1LVBVyisXfBlacuptqd834fZOTjkP9rs3hNgPPZ0aelabkSwxFh18unb2UWfm/LViunAXH6pFCJSXdDaL2Lwy+kfM3wuNRHX+9PDQRJCC0ymFiaufH06Jw5pudd6fjNt7C3Hqq6ncAWMtaln14/IadjDxiORxqd8kdhXWKLFfE/peef
 gdkkx7mY
 2t5GcDCwW+ztD5HCRlZRKjH29tIMfqIP2vgAWlQlgL7ZkaLbOzPWTStIe9LDKSn6DaDqNgTen4MOdtdp0gOIVOAgZSQ2yngbbTh1HPVr/fMjDvgoIlWOJdjMsxrqbKmpdlkqqT6kzoUt8ZTIdBLXuCFD+VDKtPfJhsqM9C4IISRqM5BwCsOmy/6imRnjvYfbtC/tW88tR/2u/R1S61uOwOdO3jEF9FMykEMI6428ErgzAYdlG9XJDn4SKWMenr/37H4xGp4KkNuwCFC/QfJbeP5o//klFObA/8opqJfENC9/XOHjknAQApociCPRiG5JLAwSrfy/62D3O1/SQj+8rnjyGGb5LTulfRmHnb0vaQ6tkqS23LhiCZVTKlTAR/TOjbZQVmSSJO3yk6ordqPnEN3/raSE6lY9TEyTY7o0TJAiN9nvAhZ5NRE7nsMnLY0FL/QAGW4VjjoHGEjsFDXzZtVs3iI6oJuad4pM50t5Gpcks7ysYaQ1GVJjCPxZktR6GXE4uCKB/5uT/1XAJSa1g2sdBZbK3/U5R5JkV5T7rDc6n+tQi9TYwdSiB5oyXjtCmcKKCRavAoxJvTqPxRcnIGlSem18p9viL3+f5bTX1tswIrctx37ymsDZtVC7Yerbn0IqL5u6neJ06BVnqvDiNoOIe86dRslwnPgy4QnOe8VHtu3+QAeo701ILljI9gU7vqn8TuSvoPZAOYGZrODifimkv9VFYQwy/gJTfPhPqLBZ6/Vk9QwM0RQ9qVnk1xznHiaGee6WpJ7VsmNDnN0+TkEHhknHp01ZUcgzW/u4nVT8ICq0jON5lVV1yr1+ba/plkRtlCN7WjiViFd3K7Yigktl/oG/KIUzE73mF+8EgQZq4PfWQyhMXaKOK2eU3XqGmM2e60ze05jT3y/crYYQ8VWw7TSFhc375fsfUmuDjas4WF2a1c6PH86P1AAVkwNbyHa4z6MSmtXfJ0BRxTWTDc2KJAwni
 HYsIjntF
 06juI5aUfSqeIM047Zh5qdl2xDDx1N+FW3k8f3GSBdhFDGiT2xtE3soeEBRIsHZiR4Iy/IQ3/YSRGzOKf3Vt4b8Wn5lyAxezzi+T4sOiC9tWRIsr6FmmVyswuIUtTryZL543m3KaNTe7xvou2wHi65XojEJ8AnMRcBqOOvTNaUgenBkqkKDSj3Tz8qEDc7IJWl2tkyV13gBRcLliRt3NvfusEmV8L87+/SahLV1Hf4XdzS1U0mQ5J7gpU/TBTsX0pqG0arq1h75M9Ha8Esxn9dR85VhsB1My53MDheN3zQiAIRm6cYzZC7p/hoqdGXWvgP5sx0XwUSWjrzybOmXZy2QDDI9Fl2A1V3SjpK7kRfjHzvz04zGOfF9PUBMjNcOdz0RtveLIg0bNgVmFIGZ8SJFTUeo8l9+0knbPakF/WpMHFT6OQqKg6HY6cpBBzFsI7FrixiHLiVQRtobLWEI+naQilRsyFS9esLPv4QmFOGsXpTBU7ddyAJFwtE5GmLHRzSZxrOZ8DQOuyERHr1ctLldiqCeWgdbeACFkvqF6bfwV41Dv2llZ12X4lRPtebXaN1RLJwyOHfm9YqPoxaHvZOCNO8zh4zI5XvLf0nk81di3HOwRv6BHuK+R8fn6ZA4M2WtQcXOMicDvEnxRmt7GuUuGgPiXolAifllGR+i7jUPuxkZjnjRGZQgR7I9YcLxKFMs3ID+Fo6qFRZFVtMY1p6+S7PNXFrmoMHEDEiG6ELLsJ8Feal4QhxuPZ9y/KRUoIBUBfpPG207+VZ8vPQd/BcAvfG3BMb/Mkd17vwbOWmDeKG1c4RxLrY1Dbur1O+5mHt9v3pfeUKp3Wge/5zATkgG1P65YGULaACh7LKfJLql5vLDUc7hS0Ps+1F3aZ2zwy6pHXW2kgfTAjz9Qe1Tv1OKtXVRLOW6hLbW8mj62nB2V0WUt4mC7vvbmS3hJ3JQiTwxMPidvSOZsTwu/o2NZd6wg32cWs
 n4P0jKMj
 IL8MQntYG81DxlIBU5XDaXPzP5IZPUBqW1J+HP5kUeQSTRbGnP2Q+PyY2AgfFJnVNXn21fvBCdx7qKvxP2006XoRi/uzm215lOhzejW/Utv4ZXFMUGx+6gZpSJXgGFK8K+noDSKCfnEG6FUHlv5VesYTEkejkmG9k5sTQIGuEshYHR+qEJsFPatZ5OpRHgx30y49Jq0qbr0IN557uD7cARoB2E7crSHDn2MC06WS8MwAi49OzGIYMnw6KQE1/3QYhPB+nakqVCejzOcKoEHs1hYQ30YXsqerkCynFk0SquisUlkRSYri4mZ/wTc3qM0hJLApMFiMwlbCM8HhWnvCq0uXuWDzJNBn2SGi23VH3r8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
MMAP.

Also while we're here delete useless comments for mmap actions whose names
clearly indicate what they are for.

Also update the userland VMA tests to reflect this change.

No functional change intended.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 2 +-
 include/linux/mm_types.h        | 8 ++++----
 mm/util.c                       | 8 ++++----
 tools/testing/vma/include/dup.h | 8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0c17f0932b76..a1f2d375cf7d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4623,7 +4623,7 @@ static inline void mmap_action_map_kernel_pages(struct vm_area_desc *desc,
 {
 	struct mmap_action *action = &desc->action;
 
-	action->type = MMAP_MAP_KERNEL_PAGES;
+	action->type = MMAP_KERNEL_PAGES;
 	action->map_kernel.start = start;
 	action->map_kernel.pages = pages;
 	action->map_kernel.nr_pages = nr_pages;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5413bd10fff2..9ca2ea3664bc 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -815,11 +815,11 @@ struct pfnmap_track_ctx {
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*
diff --git a/mm/util.c b/mm/util.c
index d809e08c7b4d..1660910e2a22 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1467,7 +1467,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return io_remap_pfn_range_prepare(desc);
 	case MMAP_SIMPLE_IO_REMAP:
 		return simple_ioremap_prepare(desc);
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		return map_kernel_pages_prepare(desc);
 	}
 
@@ -1498,7 +1498,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 		err = remap_pfn_range_complete(vma, action);
 		break;
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
 	case MMAP_IO_REMAP_PFN:
@@ -1521,7 +1521,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1542,7 +1542,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 077df510a311..023ad6092e9c 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -454,11 +454,11 @@ static __always_inline bool vma_flags_empty(const vma_flags_t *flags)
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from an array. */
+	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*

-- 
2.55.0


