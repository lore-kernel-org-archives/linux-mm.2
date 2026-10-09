Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B263CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA24E6B00C7; Fri,  9 Oct 2026 14:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7A3C6B00C8; Fri,  9 Oct 2026 14:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68276B00C9; Fri,  9 Oct 2026 14:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC1E6B00C7
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:16:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 122EF1C3C9D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:16:32 +0000 (UTC)
X-FDA: 85303893024.17.5AE2D91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 390901A000B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:16:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m018Hjmf;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569790;
	b=OsrjXftsVAwZi9rfw3fwOqvLHannnzBcGsBmbRGMGiToGjPaMmiyDWBMJCqyBKs0JJxE0Y
	b3fk/zueqz9T+qpJV2SWSBeyPcPqoPJVs9hakmW1xMK7KISWAOsSCtqfwoBQB32hkrgmRb
	X6ee3IaR1efd4jrYmH2CPAfapTI28EQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m018Hjmf;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNxRxaa4FCG/PyGcafpOW4Vhq6S2764syPChNm7Rjt0=;
	b=gP0s5OpettW0mvZ83PeXe08mauLxLNTM9YcPlESQripKLeTgECpcwyQnnK7y7lDkoBb4QJ
	Rx7hXk10o/nAtPx7j+Z2W3J2O9s4p5xYZLKvZCkjRAH4PzltrMq37k7Vp4LDteLRSrTxab
	jqb//+QrMKleYdd9k7ryglFp2egSFT0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D01543A86;
	Fri,  9 Oct 2026 18:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8E51F000FF;
	Fri,  9 Oct 2026 18:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569789;
	bh=sNxRxaa4FCG/PyGcafpOW4Vhq6S2764syPChNm7Rjt0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m018Hjmfn/pxYuj3+eTlmGklX9bJP9V7GcFJt+kUpcCntKb6FCNazqjZw0N5gPxR/
	 m/N1FNcfoPguGqAtl31eQTqnrPuvibp2WpHFLGmOZsyzlXkq7R5pmrahmaCAHUI/ZK
	 +MwQE6km+nqBMC+iMAvBvOjXenS1+gXhieyp58nOmdxiWiVNnZ0Q/S6DyA/NGmdyTH
	 ylTPlouva0ci0VABvaemvPL5bADRItMnL2sHTG37mxxDfBhKjrye0CwAWytflxgnFC
	 rPb7OPGYZqacFV1D4jx1z/bKXZZgevuxdcoa30kQBqjIopi4v0wU8NBTbXS/y+LNyw
	 BqzS+8gamX6Cw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:28 +0100
Subject: [PATCH v5 34/38] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-34-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1268; i=ljs@kernel.org;
 h=from:subject:message-id; bh=HkTbLGiMaDy9mSSm1Y8681jTpkwBcd1ymOGev1wsVuw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sxbMTVXVcSGa8rCEpmcR2sqHz4PmPrzjd+9a5P09
 rEu2VR8tqOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATmX+dkaH//9VUNo22rJTP
 6xl37bKf3BvxwOZaJ6ebyKrIfee/cncz/E/i/7Hh5+ygwwn9pRHbYjacDSp9JVHd23ni0NKma2U
 JtWwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 390901A000B
X-Rspam-User: 
X-Stat-Signature: ogdmfc64su1oeinxmwae7hsrhpiuih39
X-HE-Tag: 1791569790-824871
X-HE-Meta: U2FsdGVkX19hFCC83Pe+yZ8mUubeIL8tyUgVm8iPGxAmv14FP57PDtZX9Vq/XoHagXBTKLTyNyT0cVChzZTHPNxHfDOKYU7uj/dcj1oag2IoEv3BiMNJQYlQ3X4d4/oBkAPfF2Wdz6EAhnsgGMjSE5YuoxJa9D4wfogJYRTXaG3oZCSjl8qB7oebWCZx4YoeNOqyTwRdSScWDZElSeMEUXStBbgxvzw3NKtOOmufWY+jZAtkkoHmL5hnJk81cM8ACZsuUGGNdrBTQyodqQ09ew/IFUQMyarYBY0UfGWRA26fY+iFc8mbKNqkBALBoshJkVljIJ5KRfqdtc7vYyvreF88YkmexsbJpT2uekrFmc0FVf/M/wuSwbCGGL6QbOnVdS39JbQpvbjYeNrKFm+2nkDI39bEhkD5u/6j0nt/CqY2DVKWzb7Ige4Td9h7ZOu6oonCxvT0+6tJngpCeBz2CWy8dM0m1eiydEiu9TOnwQbF86gWjzQHKdQK2Tr6WM0KDrblsdJf9JqNj4nxtKRpbH0MJ9yt8yK6UqUHtIXBitqr7vyHW0abqTzWPWM8j9/4Hzl5RI1Hop47hhVpGFmpnQuPCzgAw42e5xT2/3xyDBJYh9i0/ofASW4KoddJ4e/NvZPsK+GGdnsLG/4vqw3/LFTU8uTg2WL4CDLq8VbmTi/38sOinT9vRC59ktDZ2IazrREOXXcJda975OJvoO1INq/mcIjrDw4mDsR/luCh15B579tF3bZApU+sIsdg7ZeBXJHWKSGHJdMA9mc6vkvyGxLQ48cLaLlf7hT6wEAnkpvbJ6OAU4wPaSZ6K6ySxVearxXDGMysKrYabgjsEDJLG9gpajuv+kQaOXXjUwVimPU6CwuhmiD80J9CNF4pTt0wfYZNpNI9XcUXo/eBh7TDaX+M+0ffOVpLNtnB1hm3CBHxs4uNQR1m58e3GfACapd7wnePDfFfedoxvisb4/Y
 C48ZwvGb
 AWpK0piuqlvAQQcKY8LTg+BwTBnUw+fx55LlagmS7esoM0+6WLN4wtgeu7r4bfm6Hj8ht0foMWQAPDXlLqKcrqkG/DLdwzLipuO1QiztXWA4ky0IRZLMv6Kiu1Hsk/tqq3iAT7HfJbNYxZag+pg45lkmugLKBS/Lukqxv7hTHm/7V3qHXe2sXaVdCI7/S3BKtQU3r+3gFuZ9RJ1kRzzxJNpY5wceF7LsocsQfPEniA4dfgMJ8bzRDM6UH7uPXJNSbcAbtnacmwX1Fft0P/eFxssUyiXCtL2sW1rfpoqIrojyU6RWYiUvS9UECXTwbZYRJdBWmsTsQQG6K8YTwxxUMaGW+LW8oh7kACjyGgLtkTvhmNnVl8Jh3p0W6DQ94vW+/njgZPoF9IU+MQhowW/jXDUfe/8sePpSon5LjMzpbsS4zqZOs6/xGo5iL5kgVlZbHOLzztQHpyyYVCNiGcNx3mgA6aAhEIn/bjRMr2NxBG/2h1nL5vu4Kmh6mjbl1KwKHLHyh8Kc9V6H9YGDakzCVXaywEAXo8XUOb0tRpxcCO6Oj3ezJMVZ/f30dwJ1dBkGV6yFi1hgXp3bimnCIRRw8OGH07Qeke4fWlO3Tv3No8g03PJ676MqF93XC17Zx4lz2lXNeFL1gZFfOLg2UZLGxwrpKDjsKxnFbPn25xR6XxM0rNWEiDb/CSnhzytV0tMw8NiHKYlBZITQXC60KSEHzM/oTJb73Cjr+FR5nBunlOHoO3flDvvEK2jTQToxpQ0J/XmMUi3zZlGua5Xhd6810QHsGhi8NCaqz1xvDVa4TKWe0SpkhS7d1Z6OfNf6oQ9FofIw1M5cxH9CTPIM/IaE2032Mc364s/oL8SvGfkRNWgPGDd64EAVg0lPQyr+vVs+xsNt25v6/EgB7bqJeItbl5oPSUJdmVpGzS99jpFPgleOi9Sm8ArDUYIvyraoQL4anmC2GAGZXLfBcYXPcSYWOfUARA9iI
 BBzXcDcb
 h6lw2RWDktXQK1rBQXzBfcfyAeKoGhzSJ5V91WogLpA8HsN+3FJoBgSGmPAUvi/Xkr0dI3duuifPdQCDqREVrUdCSvfvA8BjXd52ItE2ol0CR7mXqvAOhSUlpDQbrcna+Asnw25Vnksrc5tChernl+lWMiPU0PPA8OklK3DwcH8/n8sWfs9DUYaU3RctsiNAS8CWo0ujyjj2CG3krDCqXj4ywL+JtrUjjAZmmfq/cKh7vVuMJ2snWkGJ3o0PnEXcGKXZSj4ncvIy5UQ61uwsHQ76b8+RrFEdZ90LzZEF6vRiUgg0586dJ4eMHsA5954AEZMkzq33L/lj7rWDYftvSSws8qbofVEdmHaPtpB6UuVBpYw7jSVkOhKpixRnCe6YVvhUQWjqMIlNt3PJV8weK3PaISNZorfxW300lAEXID+8EZHJqpiw32WKVb8XQDhjnCW+qGR5RbJr+2RpCqdxAjCNi4GePofKLytNJWnG/w1YDa7Cnosnwwwioet0AfLkhNyWwUXWFN4Qh3dGUIfKBuAJMJaU5cIzKk2PSNAT2DFJULy9oLEY6jUp3mOGNHvIsu83crcpRQe3rVPcvlFqQyLgV9vPzR8xldgo5jq1bl1+1PPS50T7/wI5gOSwyWR2aL318xI80l21AZ/umix5REZn7y0eAaZHT9x9tZRi7IZb6bMA8NtSmHpKWZSJ25dQFU8anFo1FtvFVtpHbjLE+sQyf8PBmGPkY+rvWwWikKwf821zX8aEECVJsJfARsXxUdAszaTUWNxxvo8Yi4097pQH7L7EzhYJ8kMwJBPwB13eeMW8xzBLFANSZkPXfFfo40zZ2Cs3u+2bdjQdemcORWkaT4fEkuNIyTpGm95slXGa9eLOKDXWQFbvV0StaqpZIzoS4IJwrc1GNxpCGfTXCDreUpnwLVO2qTK3LA0BUlfBVi5zz49AlQvph7DUkh+O8XKlcgT5hRHXUomtwLTRtmGJ6LsLC
 ZZn1nFN9
 BbjUOpDvXzjdguYYjVaGhiQ8QYQl8b4YdedXfDFPOtblOn0KMTnSq/EhBukOZoxh3J6U82yrd0juNySoXYjjHqax2PM3EeGLwG7DGUjjC5T1cuv8JYoC3gPkViyES+qCx2gSw2BtgQDGajXT0M9aUNSgSMWKTYI6Jx9uQWo5voRtRwvOeJaxRB++3Ue9USGdaECebJyfGC4fjP6Ij3nrcnT4fjHreUax1F0NeBoJ6fGw/jmHazQo6BZFmZzNpeG+Tl3FD4epqWYNd61Vn4Qg3KwRrFqiVX0ExSd8xFhF/elsuXBC6BSM9u3pGphRf7NXC8qhIgIb5eGN7/n6nuJU7c6ee9P6R6LNqmjAatkF6ej5LUM2n08IKZ90mNiEvZ3C2Z7bSvwjQI8uZQZebcAIkP4H98FlUsOJGaWEXBlII+AWBpF8kC+NsHBjS8G5X6YthHiWaQ0XjyN4cSUdGXYwshQ6+raQChexvHet9TcOn6j4lYPAE+wpvTf/DxgJNGrdZw62LfVWRDuoGMEuQfOSmpgksiLkSjtyk8pM/XkxRt/g3ZffwU8B15vu7529iSDZFTiwW+DLPjIQqn4A7M3R/9mHyJST1+E5MVjoQTgU8FvFiihsPXtdBeG/8hqtjkbZqRLCQByjU5AlcdpbiDLqs+BhH6owMsn1Vzl1VoqwWSx6aV2hf0hKmLNofm/xUOgSwRbqYHI665DHt348Ny3T06KEqQEvSR5KShSea5uGD+01zhyBaKANiKBNb8+2b/VtEpLdmlxkis4OB1vwsSAWEGNMVBjV6dnmiLjxnSsNeZdJ/fpEmGlLE4FgT/+NZQ/Ia2EJ2iDjhtQxc2RI18a8T4fHrBFSRFSMxwM9Zx4eoLOFaGcJT6bWp2p6wXZ+zAJDf0DR3b35kRltMtnt90EUz3ByGmBL3CV52Ligg7zk8gIheRcnZUWGL0yp2L89GOvM3GPXfZj1VG5C0r95Rih3Qoupn75yZ
 oq7vKD4D
 zDW0+k0gtZibJwRm1ga5Vf12WvriwTmYnahkbqCiUHL9CqkiqVMqxixlAtnitzsB265xj9brfgcR9u4yaxtYtZb5c6x5LfDeWcfit7o5LdQAblpXKz41ov44oDetYulk6Yinl810s0OceO+rAIoDBOTPd1spIdZCj3Rc0kdPxuxfizNNm2XjoSqm7OXR3hkq8EnCdaSU1Y1h6ukyl6GS+LhTB3TGmAQVKMMjpTbhP5qq8iqtG09dFSQM5i+bvbavdTTNQDKd02dlpnMRcSDquq33y9BtAZFYjQ4JnOeDL6CUbDY1aR4QfJaBgAuLdzkIwgIxtBCZx4iKk8swS4ng+UBmUwi+WegV7RwbHokFr9+wNnogGwxB8P1r7MBjADfVVPS7HssoWjZfmgAgW5ePzIUibMXLVpcuEmSHG/+nj04519I7hwK0uYnSjPEq8FflrhrmqWlbleEkbRpRDI7WrGwkkctzUd9KI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A fixed or non-mm-managed mapping is one which sets VMA_PFNMAP_BIT,
VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop as
mm-managed mappings may not set it.

Using these predicates rather than VMA_SPECIAL_FLAGS makes the check
self-documenting and helps eliminate the confusion around 'special' flags.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3b318efa2916..7adffe8182b3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4418,8 +4418,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	if (spin_is_contended(pvmw->ptl))
 		return true;
 
-	/* exclude special VMAs containing anon pages from COW */
-	if (vma->vm_flags & VM_SPECIAL)
+	/* exclude fixed and non-mm-managed VMAs containing anon pages from COW */
+	if (!vma_is_mm_managed(vma) || vma_is_fixed_mapping(vma))
 		return true;
 
 	/* avoid taking the LRU lock under the PTL when possible */

-- 
2.55.0


