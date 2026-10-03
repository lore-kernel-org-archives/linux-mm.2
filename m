Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA356CA5FEF
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6ED66B00B1; Sat,  3 Oct 2026 12:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E786B00B2; Sat,  3 Oct 2026 12:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6226B00B3; Sat,  3 Oct 2026 12:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A58FD6B00B1
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:38:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 21ABE809A3
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:38:49 +0000 (UTC)
X-FDA: 85281873978.15.A3C30D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6D44AC0009
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:38:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GqM3Oq5f;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUbFGITjWY59hwibK517Un6q5CvbsJ/CBzqc0O6PG0w=;
	b=Y6BLnTfVkiD02wnE73dP6mOfuKpq047ukGJCUOSgFcQsh5q+0WMQ0KJf87WrEhqRLb4llc
	JlifrBrdXASTlJrN3L6nC+cpbq6QLVOvIFCgr1ny1KsoUmsr7p2WWA/FrzH2IHzN0fpnEa
	DCs6IEyQuOIqa0ktLvkcIer5tMCjDJc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GqM3Oq5f;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045527;
	b=44O1kLokCjNJs10R8OqUf7XNwtxXzzmBZ5UGB69jDt+pPC+QpRqyH2qAIoPY7/pF0v0lmA
	UDzw3DbROxdFRsrKusswpsGvHyV8p3IBf/sa1K9th6nCqDymnVAbavisyNY821ond6lhKV
	4wZqblapEyV9h+TzG3iF486fSxFlisE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DAE3E60D82;
	Sat,  3 Oct 2026 16:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2AD1F0089C;
	Sat,  3 Oct 2026 16:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045526;
	bh=UUbFGITjWY59hwibK517Un6q5CvbsJ/CBzqc0O6PG0w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GqM3Oq5fa0ezEW3LjsY1RBhCjn/Yktg5sCHb3YEQ0nPZWTtOTuR9ZhMSpDothl5L1
	 X45HTJwoTW5V3IqVwY6gptEBdNpXxzdwwCdh6r1tVAbs6DK9zeDHlav5jUzARUpGNI
	 P1UMc/+3PpP4daru4o7+L3REL2byleapWh1Wdoskrny5j/Z8GLiwh0CPGmlcy9mtNW
	 ZSfFG2PdtglfFXhzbTK3Mk3dAcZpKDMtKMqspNOSWhMsxBDMyzhNhq2AS/unDTZnYb
	 U5hHI8VX+7wlSQDEyGOiO4ckDSdnzZVWnnpF+LLpwpeney546MyYcVWjrMVWoN9R5j
	 12GOTcuZYiyQg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:47 +0100
Subject: [PATCH v4 16/38] mm/vma: add and use vma_[flags]_is_fixed_mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-16-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6553; i=ljs@kernel.org;
 h=from:subject:message-id; bh=mOnnFrkUWaUS1n4H4Gk7r71SXXuSIa1mWd+M4luJGNU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mmmTV6ayK+2rTIuWHj32Z6vX/xL668YXGDfxP53n
 pVaflVzRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACayYh/DP3v1nPAHsq7P38l/
 Ztl47mX4t9OCb4u/nJGSMvhcMnnFupsM/7SE6y/fOPTD8spkycUBjW1fS2+msjc277w85VS4Mdf
 Tx1wA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: s854bjfu7cnjso4w56zd3ospwhqrwj6g
X-Rspamd-Queue-Id: 6D44AC0009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791045527-959166
X-HE-Meta: U2FsdGVkX18430EPlRMKZBmlFDsk2oi9ybpHarsOJVUUt7TZwLSmelLByouIqJa/mf/YGNhFQ1bQIQQW07WyoYUa8d2prBprc1KFuMlAdEBnTVZAUJ0de/PpDkJBSSZqiofmpyH6Dg48gqIPf62nPuPZkdq82A6+1a8KheLOI5VpQg1PMixr2JXPW3JvDYpOi1eJgQDRzf2ro2FZreQKMWPSw1a8a1sOiMV8df9svv3hKDp4UfSvTEvYSeihi6OjGB4Gy4vm9qJPh9uFFoK3DVi7166fT+5mgEfcAS+pSlSDbOHLVSY1LStGA/ChxmHOktuHHtvCWQt2PoKNUSUlQJJ7ERhU6k+demk4PTkgF76vUeT3eLM0G78Gteb2biH7u63j1Ugfr1UvuGhIg3/S2VHEJ7zW/oNQRSLjpS8yNUoIfbY55wt9F146JfZl0HtjCXOesmJu2xRmx1Z7AdHg5pXDaQ4bBg+xZSCW07hMtqM1t/TyooFk4pkjkwp4WLVlmnywSJu2rskCP4tukIXI7K90OlJleRBhLuZheN1JCtPoQ0KSPv3HhQjxwWXJtx+DkXqPqiW4SrjU1KWp6+8FpeqNjTYoQQrdih35napi5nDlb1rtWlYxw700bpKKAvXqdY46mfHypN/zl20iYUBBOxONcT/qqmFySY/3XF0jwjsXPxWtsXp5GZIT6tGCkQ7b0DgFFpV+tJsGaZF7p2hdX0BvTwgPRXN9tuAiTSsQ50r0NcsmTHiGJCW2dMlcZ5Vx/ECToNfZ6MtRYeLGdpYC3LHFMvlEvAKV/q282wppK8Eu4CKQDYn7dBlY5sBIdXihSnyiIS3+qUVdiLPN/qHdQLRpm4R9mJjMSb+uuIGJqtOkN4j+ZCuoLY2qkA5AzYhAzqr7L5X8ym0ZdMsIKYk6OEGaHDRzZ1PM87mvL945sZC5qSq+euw5Z+97M04xY3/0aEoFPsEg+cLAcpsRLUo
 89Tv9OWt
 P1+HZ/gwxT/NBMpkHxxuILPoC5U9f5Q25Du9WmRAtqygOCeEmy0Q3GQu5r53i0DWHNA+mkqp1/63bQJWOzWlVjTfcsrfr9DBfRxrnPL4f8eU0mZ/tUoUcXSeL+L/nSPrRiv5i9qTp3M2jXdl4oo0UU77YbxHqWNEqnPjgtBf1wB7mmjCLjxJ/Qt9wF8VE3Dpvb4dfyCve2KBWQlEXSWM8u2czyficrRPJinEOvoORknaq/H+CHrhVJ1ZbPPOVpo0VQB74jf57gHEAucRql375z8DTwZ98bqEgTxxbBLFibr2R0zkRVMFKJORCYBmy3sFkZBLz5ZO+NV/e4/cXduq7oTiEZS9QdbH6+JZlrVuYxMCWOiKoMLgkhysAv/0qBc22NiYHYADh0gFK1f41U0kFJTAe1p12J/5bzOZf4GMR8Cz8KNOCb83C4ZE+dI8oXPtyraj8uGPafRG5apM9p4ZCMqPq/gnncxtqXPw2+n0+k+sdHp4jrqQ+0vtxvNkXgOP/2uG3CNs3kWcMyScCZg85WZE6cHaIFNm84eAsR0p2WEP7YtSmTG0rO/3iwswF63OItHR9u43mqVwJhKo84hNFV0/tRRaFqI+GLugK4YMJRqAnNhE3l97uKLj/He7fXpP4pBpzvtIU9IFTdT4FbUf6ngDz4d3nlMl9axcUy5eEVeBz3LpmuG7FO3sR5Zbhe7X1yZM4czP9ZoHI5Fq7/PpgVUotKt7ESCtT7ObdTOVRpH45VALh0QkMbFzBqYOuHzNVHMAKZ9+sDGIz7RAh1QvTj5caW181BI/tBhjfFMGAgHYvFxka/3/VK9BGIZHyHbhc0QRQUlWVk+YrlaqUCNViLS1femN/Xsdmb6/fm8iA7JVtpe0zzMp2az9jU93Mg4KwI3f7GyJj0Dz0klwBFWUxsCZzErtF5WiIf60N8S6itywjSDW7s4EjJb7mh3m7N2IJme/JNDlO5s6cUpgXweibZEUdTzRr
 cj+eMFnO
 6DWunBrmcEMJcQO5jWPnu7R0CtehklSFWn3kOgsLFja9BfYO1ZwIQ14UBg7pItMlOWjQeMeMTD96tP6jsTyS/5naRjlFBfj/13t5Uvbyzk8cs8XEWJG3fXL/YphYs5CLbzxu67fg9YGq69f2tluck64m+URRMysnW+rlA2/jHdZ1y+jq/62vvSrH1TLQaN/Mc7/UnhpghQILCZdGrjSM/cYc6eYJRGe42AQoGju29hRzKCDR+XLFa0LTraUq+TUvBLMXIuX5dT3r5rOgGHTrJrCZ0iinFkNBBpYmUcJ4MufF7pVLwALOX/Ql6ySYvsuubmlxfbfTTP0mUt+fUQoSc9WTDqB+tteU0E7L+xXT0X0f7phazyolBy9tVs/ByKdlCUTLgxSqL65OgX40rc2LlkYPTvVJHRJzi9TD/KWbwW8cJEI4zmMHM0Aqxu1/sHBnEzf20IBq01HA3lP7NcRzuUspZFWwvMqha/0/d+boPzNvKiDcMoJ8NZ3WQfMUF/4lLIZv31zvlWIHeNuKmsqhmsb1E4a9TipOsOuL1w/sNqkv4vbaEY/493hDbf+oqzvXenmZclmZLw8Dvd2CbiWHb6WJWYxNZ6fi3fr6wXM/DrAx9Ux9IILYYOAa3LTJzj/ojInghvkfzU8gTFtqbGt3Foi48+PNYbHQ9VXB8TSWHpdCXmTnODlyq3UYtwEXiXJqfzD6mh4bsMR5PRu2F7BjQauF0tcovoGaEi1E0tm7lTziNc5YeAlf26dzuYTerEhI1rOAcvvNua61HK4O3cBLVsVXqmCZdyJZG6MNIjfkDAlU+gE+CKoNI9b7QPlSHouCwv9bs7xcNdKlaAOnp3oIfwdlMVRLtRb8btnod+5RZHVViBAE5k7oTkw4k3pJunX7Lzaxp6lBERsUNYsA8vBDvAUfXxBmwe/ZicLkjIUGbJtuwddHtWGUxz3bGzzqvbV0s+1t5ry3mPMjQx7HwHOYiRR5JwaRT
 jLYD71Tl
 DKYwv2YsfY+BYnjQ35F6BSZI9MeJbAju1yGzZQz6BhnixwWTQJ3owpV2rtCO+ygDhLgAjUnMhtCQxMX4QU5zS2gy+sXChuzMWPrO/uej5ax4AN8DSzj2M3HUURmjVyTuLJAcGdUa49133z8XbD13LR+zClCMEiXBK0lb+SNh9NGrE7zE8QsZWxyaZaZbafvoASLtaU2jC4uNgMqH3YIIMLpCC6zRGA7aurgsJ0TnyLwNs9FYkpOuw3zOf+a9PXKFA4XAlznzGGHrs8fmMOMJB5co9rQG2nMNV8KxuxvR+0N7xUc/qyEa/DVTGpU16/yCQSZvuBWR23Tzq+KGi+IeQzCqCZyqbY24P2sIHXrAhSTE/i/BrlF6Y3HImX7H66LrLjnbDSoFb9FBXGjRD78o+1VuYCeQhrtnXZ3dbHKGhSZEc8nlmm4/canzHN1L3nrromgdo7N7VmD0zwtfTNnrgSjE82Y64V3LjFabS3sloJFVs7jrBJYC/hHkKBOSWg+wuOF8h0D/AJ8PE1oFNBxNZG4d7PrMhLZnA5AGaHOFPwFZ+xqlcLMvfQ2G2XMKeMJIwxKukhgpBlaDWlC8mv/gkLjbpUWNpXWh5caqaI8q/BDbvAnifAqJ/I+yKXvPXlo0fYKDAkncBvkxCqGvYKJxdGo9igvO3fbf0RABNeyY4/GEWYJasfcvlwNX7RUiqU7sqWkmf7npc0vVvSL34OZQTGKHDTubI8rxQ6uYn/Sz7XnyWcU5yUWEh260rdXR80ah+zi7pm5pyUmx4CvioPgPD7XCgtb4cgk77JNODN+w7L6u9tzmankJRedoEgz1H4cFw4re7vtrb1/jJT5P+xLjRsE605qJ/vsi5dHXsq6gN9hrKjwnGbx2oyskiKSDUsGd7p4tXxcDdCm0adQK0VS17RCuSvXjQO7JmKMy0RMSPvZdNc9zvT8tukovQ3/KSvQy5Labck15gq3bOUU6ebWuIdKW09Q+8
 ofIB7l1Y
 KxIpdJ+4nM7aCliJ6zOVFr4dbmyrkzBb7WGxlupv9Km6PQuJeUaRKxVLSrf90qZkKZIYY2KtLbwo4X82Q760oHEFaVOWF7H9ZEUiqYyxFH1kjrxfFQ/uJfZ8xcAGJwkQjON4mfDIcAdw7ompjVM4vo5WOzdKj0lJw794atTu8kFv8bZ2NW+viIcsVFPpKWUdvrE54IpqdrVO7d0Y0tj8tZLXXLSdDZyLUXbwxtp3MmirlYHZiAhwy/WG6Avf105vXLSYzQflx7NbEPI5LuUX85Ic1xSBsKyp0XtDlPefJJ5vnNKTuNbSxR0r+pd1S0o5rsY9xsT+3KU3oqy8GYNrTZcRCD/nVyJ8bSZub0mED97w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This determines whether a VMA cannot be expanded or merged because what
they mapped was determined to be a set size at mmap time.

This typically refers to mappings not managed by core mm, however
VMA_DONTEXPAND_BIT
is not reliably set alongside VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT, so we
must explicitly test for this for now.

We also explicitly test for VMA_PFNMAP_BIT as VMA_DONTEXPAND_BIT may not be
set for VMA_PFNMAP_BIT's despite the one implying the other.

Use this predicate in vma_flags_can_merge() and in check_prep_vma() in the
mremap logic testing to see if mremap() can expand the VMA. The criteria
for khugepaged and MADV_COLLAPSE eligibility in
__thp_vma_allowable_orders() are precisely those for mergeability, so use
vma_can_merge() there (with an expanded comment).

This obviates the need for the VM_NO_KHUGEPAGED mask, so remove it.

Hugetlb VMAs remain excluded from khugepaged as hugetlbfs always sets
VMA_DONTEXPAND_BIT.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 39 +++++++++++++++++++++++++++++++++++----
 mm/huge_memory.c                | 11 +++++++----
 mm/mremap.c                     |  5 ++---
 tools/testing/vma/include/dup.h | 16 +++++++++++++++-
 4 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 83953757735a..6b5f06cd174a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -600,9 +600,6 @@ enum {
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 
-/* This mask prevents VMA from being scanned with khugepaged */
-#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
-
 /* This mask defines which mm->def_flags a process can inherit its parent */
 #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
 
@@ -1647,6 +1644,40 @@ static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
 	return vma_flags_is_mm_managed(&vma->flags);
 }
 
+/**
+ * vma_flags_is_fixed_mapping() - Do the specified VMA flags indicate that this
+ * is a fixed mapping that cannot be expanded or merged?
+ * @flags: The VMA flags to test.
+ *
+ * Fixed mappings are those whose size is set at the point of mmap (for
+ * instance, a mapping of a fixed range of memory established by a driver),
+ * and thus cannot be expanded or merged.
+ *
+ * Returns: true if the flags indicate a fixed mapping.
+ */
+static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
+{
+	/*
+	 * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some callers set
+	 * only the former.
+	 */
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT);
+}
+
+/**
+ * vma_is_fixed_mapping() - Is this VMA a fixed mapping that cannot be
+ * expanded or merged?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_fixed_mapping() for a description of this property.
+ *
+ * Returns: true if the VMA maps a fixed mapping.
+ */
+static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_fixed_mapping(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1668,7 +1699,7 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 	if (!vma_flags_is_mm_managed(flags))
 		return false;
 	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+	if (vma_flags_is_fixed_mapping(flags))
 		return false;
 
 	return true;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4cd917f77f3f..87e8bf8029ab 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -212,11 +212,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 		return in_pf ? orders : 0;
 
 	/*
-	 * khugepaged special VMA and hugetlb VMA.
-	 * Must be checked after dax since some dax mappings may have
-	 * VM_MIXEDMAP set.
+	 * khugepaged moves data from VMAs once collapsed, after they have been
+	 * faulted in, relying on refaulting for file-backed memory.
+	 *
+	 * Mappings not managed by core mm cannot be reliably reconstructed from
+	 * page faults, and fixed mappings (including hugetlb) may well be
+	 * mm-managed - precisely the mappings which cannot be merged.
 	 */
-	if (!in_pf && !smaps && (vm_flags & VM_NO_KHUGEPAGED))
+	if (!in_pf && !smaps && !vma_can_merge(vma))
 		return 0;
 
 	/*
diff --git a/mm/mremap.c b/mm/mremap.c
index 7c368440fafe..ed19b47c2caf 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1788,8 +1788,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 		return -EINVAL;
 	}
 
-	if ((vrm->flags & MREMAP_DONTUNMAP) &&
-	    vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
+	if ((vrm->flags & MREMAP_DONTUNMAP) && vma_is_fixed_mapping(vma))
 		return -EINVAL;
 
 	/*
@@ -1827,7 +1826,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
 		return -EINVAL;
 
-	if (vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
+	if (vma_is_fixed_mapping(vma))
 		return -EFAULT;
 
 	if (!mlock_future_ok(mm, vma_test(vma, VMA_LOCKED_BIT), vrm->delta))
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 89c645a6ad60..442ea9eb098d 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1676,6 +1676,20 @@ static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
 	return vma_flags_is_mm_managed(&vma->flags);
 }
 
+static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
+{
+	/*
+	 * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some callers set
+	 * only the former.
+	 */
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT);
+}
+
+static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_fixed_mapping(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
 	/*
@@ -1691,7 +1705,7 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 	if (!vma_flags_is_mm_managed(flags))
 		return false;
 	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+	if (vma_flags_is_fixed_mapping(flags))
 		return false;
 
 	return true;

-- 
2.55.0


