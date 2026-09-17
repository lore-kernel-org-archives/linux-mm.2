Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4380EC982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6204A6B0098; Thu, 17 Sep 2026 12:27:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D16A6B00AD; Thu, 17 Sep 2026 12:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C2056B00AE; Thu, 17 Sep 2026 12:27:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 275F36B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:27:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6E8AC03D3
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:27:07 +0000 (UTC)
X-FDA: 85223783694.25.20C9056
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id DDF5A8000A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:27:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ViDv2WyE;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nW++sIH5+QkDbGxq2Vus9hcdCzRLPa1+Wdw4UyVQp4I=;
	b=X+53Lg7HtoRz2DVervU0XrFCsCqaGA2xaUv4drp8o/djiENAEdeP3TRiHTxe1RQMOU7EiP
	wdd6Mwd+Pwmi6+dUW18caPiGrlaOt+8jN+3EaXzLTc1xiVYjlY9cST1uSaMMtpx14osn4a
	eJfh1/ffz9idAHWSrmdjcWWdUzkyDEc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ViDv2WyE;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662425;
	b=h4+nitq/8vRbOJHSaWVwUvxFWOdHfYf+hT7kyNakCVBzBV++kl3fTF0FgZ85Qstsyucxvk
	s1qEfgDI4fYtpc4rJejiBCWcvhQVc2ZeXoDniHtXtcp+Yyn31WAUbqpNhWruK7JHv61uzL
	E6d9PHOCPCoQdaoEyecITd6pbs7SOCw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E05360214;
	Thu, 17 Sep 2026 16:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D441F00899;
	Thu, 17 Sep 2026 16:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662424;
	bh=nW++sIH5+QkDbGxq2Vus9hcdCzRLPa1+Wdw4UyVQp4I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ViDv2WyEnlMmU8htS9pYWkRicYlC2W7lHbLK/fwluAUN8aPruh0xtEtHeInjKh7QJ
	 AeJfNoCdhcDmfNw61s0Mqo7zYj3Y3adfWR9lVLXgJpaJuJUM79bFJ0H1qYFplfJm3F
	 uQ+f3olQ1O1fprNr/rcci/pcbuxBdH3N4RXBXHd3pUMqwU8aM/TC2l+JlBXY7Ow0Q5
	 FWKY0BekVQJvUG/SDDHsff9wJ1NnNbD/1uWKhTsAyKgCQvIgGfp8XpljtvcxoNbBTS
	 9nedK21t77r+eo1zNk2P75uxDiXnpoZiKFyzgBKX6C7TbMYuGsoT0agcJy778NEAi2
	 tpQzHnBvanbrA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:17 +0100
Subject: [PATCH v3 08/40] mm: add mmap action for discontiguous kernel page
 mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-8-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=13000; i=ljs@kernel.org;
 h=from:subject:message-id; bh=9WhzIDxv6aNjRmRkyTl/IVkqdbWFVNggqlZznMVJ7GU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCO9/pG81r+Tdrewtj304bJ5ckZ2xsvUxl2eIv5/00
 biFN08f7yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEbtkyMrx8pWF3+1jS/JTe
 LxFTDi/1Pu9XxpmX9i3ubzPb4QfaspEM/zTMjzrOuTiN03LHv/on7UceSdk0WL350G3pdzPZRad
 2EisA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: g51js1gdzn14fe5gaj1n9kpuzyyi5ctc
X-Rspamd-Queue-Id: DDF5A8000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789662425-776514
X-HE-Meta: U2FsdGVkX19aOhMJcsLyCsYz6kqIxyiDzLvnpBV4RRTOuZzk3SrUoKudCMB9Mn2Ru0thRBzI0y3dnH27eH7kRMldf9atx7Q6ZvpG0d07kloidSTc+hE21rbzl++MsYx3sDzh/9I0JNq1xCcs5Ofe14124BXEhsDSs4fkMF6YUNbl2tWU3jUm2En9+/fpWgqAxhbYW1k+WqGG26/ha7y6CfolbweizHKcmXLmzkE1i5gAJhTVN6BijCsNeoygXdOEwxE2gcIgtNpIhufHSrV14280gUOZUlyRz0oMJ9kwUD7xBDA5N33eaZer5WPHsJy4JqeXrB7lMKe+KdtM8ngkHzxsvwyfu2Jkk0R1A7J8CNYzbS17vpRIBGq9UgMgSAAzDaY3G+HuOsPSSZpS1nFgTdY5mNyASZyCGYGv1GXWRozM/ZhxsZa2nl+FIWwWQs57oun6212Tn2hLNDcqRbsdtVcNiFJ14uqMh99IAfGunoInTFo09LCV2O1IqyI2ZShb6VqXP6kR39+7uDplkc3HQN8etmkTp8V/LNULSHkiSk4QnMkcxzVDEv4p6X12kNIJG9FaugpSdbWEC/uRVldGjRNyW5uBdl0+G/M03DA0O8WGLvyKOgWb81+WJ7NOGzOPBr2fP4QY9GzTd8LQomvAmVXKDBYy2WwGVZTOZVWgKuQiVJ+7EMqXiu2wP1keTHK2ukJ6mBhWXWwm+kdM3FheJsnsjtv3ZdyCR/5bPP9TjSNVHEB1Qmqh7ESLPAUo6c+LeGA+UoLM/462HKrpqFjp/cTB7gM3l5GMKdWyBThtP2r2vkuesxOhJwdAz9zkaqTqNG7nm0vFNUGc7TkkaAPES9L+Wjfpw5+x7s0/wTptiGrdcI9Mm6a2nuMUVArtA2z4E4IU0I23/hSjujUGsVa0XLC3NT6dhZwCYRsumvdfT15Aijgk0Itm6b+UpIRhAhtGTtyzy1kcsEeywtaHrPQ
 bStI3ddB
 MQxZv1KH3odVfnRuPGDMJMCekxMTDBHztFgqEGFcbrsrQ8EtOed8DhcE4hHi3ccViOp3Y9s9+vbv+QHHIMvazpRBtGmye3O48WAN1U9bzEVg3sZlqi5Qz7+r5DCQnlsEe0Dkvb6lBDzmocYoKqBUSbIek/jAW+BGje5ORLmHab1daU27oRIOgnyMZ9S1EFpuavIR2uMmu9bYUAzidjPY7Jh1o0PtIUNRvmhnS5Z/uHaivf3n1v/ORfNo2Cs/TgsmIqdxqGTeaT5UwMwg9+Dza/4YpnwiqxCsudEb+fOWY1BjRBEAKOSVHgNLNWFZmByHxcaMxwNLss4fAsMECthGfRJRwBHZY2Zz4Ca8D5srgUU3YSpseXKXLY2+6A3oFWBZPTy3Olxt6D9cHp3epDw/5O45r6kHjC9CXolJOrCyuZVBlL0586x0yia1E0uSaq3cdc/D41w868NRgr08SFyI3I8Sw4R7phZuE799imOU+MIAoGzNfF9HrEEzcwdjd3du8XmhRMxH3AT8A4iRMmM8ER/khK7Fbd7zEZiY/kybO5dgnKpKHwz4o3IUnl8om2iqRMJCBO1GP/u799nHHDPW9q8YP+Tej81e7WOlTz32vFKWrVttv6B7r9Bk0ZbCR6OqXUBfN1UDOhzgCQRfZjAj3icoIO4BwKsxUXmdhZtCujd8vVP42YdhoU7WhPAeGkJtTG3fs8Wzlhx7ukwv62AIPhv6Ny6SHUAmrlLYRsJwB7ycK3KfhHMLQrqMy2Lyocil1f7MV5z51//RiyrgHSF+UEDsQVGMDX5ypp3ZKf0r8SoRRh1owSvhj/Csv1MW2SRqEmlyKk9xrI/FHHoPJVDwvIymPZOA2iuSvyI37j+Hk2QUlI4UbwOv3am4wz6+aYV5oUIbCgFKVTNzIogyHQTWPXffR5i/anESRO/gVjuGiGqxudfgjTe+XZRryYdWvebznc80GdX3K9ei4QAoAkaPO55J2S9UT
 P0NhOTB1
 GQpsQo8B2s/lmveTc4Eqxw0JD3z4Rrom0RopFtYlPx1yl/7Z5d5SWmNUYFmpkoLZqoizyYIvRlutpQPNALvoB4mNP+RAFUZzSVFa/6X3S5rIaAPjaUi30/x5NT005DZehluX9xMshA/sLVn2FtDRF8JRuZvRLUHq+PoNjJCrjvbce32hBjAVXA7n51XOFCivEKbyZsXZGov6vSCg9m6d8ubj7v7kQ7aFGyME0Dijw9xCKTYlcELiYfzrYVRAu532b48l/QFhgrlVOZmP2Xy8wtNmFBe9isYDsc7cvMCAAOELWe+VQW7mUWHxQijSRphnt0vy2rp3y1EooMPK/y7L0JpCa9pH9bhqbyB9ZIJZr1kdWlFUl2hJUwmHgKg9v73Oy7EPHeb5Xz50bLzlFkYvYb1DnEfodqJmJj66OJOglW87gK5scKuAYuUqUUJk8+iDRdOGPz1kAatMOMLTkFV+QVOLlsyEbkgZ0/9eiirUc6JA8Zox5vro4lg2FB57MyqKPBIAmtxXPENs32IcXuKw+7jBHesd1OPzULExvXhgVT4bU67mFP9XEJ8RN+nuiKCJKxk6RoiECSr6Qd1RMxpCqG6wXxWIhY08daHl0z7oF+TXOiDE6aaJBgOVFnNikCCYsd/rS08l1w/plSB4QiRjwqSytg4vA89Z1qMXok5b2k5HNuAYe8+mnVx3nQWfS9goeJk6EDOEQHwAnt6TQr0VpGOKQPRUH5KslUV5TjAW3LSuAUkHSUNJ5jmyeaqS4ICEHmlWvdo9azEDL5QPyz0mx1CZdzoBvtNg6xjUamx1tbXtVJa6zTCRKhKeZP4JJQ51LQJJRC0TSkPQw89o6+6VmZYz5SVG+m8bMvaHtmTc9qj9LFfqS46pMPsvV8X1FOsVboMmntPAEXszlICDVSlq1jxpjhRBT2YFG7cS7jedILncv9Ax5G3p7C9nbVlU9hXlCydXMAaDOOYQQ2hQ9RWdFs7CMx58M
 9mLwbgbH
 4MDb+w1cNzN+HyfDXgD3d9KlIVX4FbhKIx6Zc0grqXw7kdiack0aElDJwAB0I80kHhQEYbqRpWxGsWyWL/xhU5Bps0poLX503yXtoOUk4yWp1+6wm31TBgIl4Qh+vDP8fYPkDWtc1UryUm035+h0afxUKPXhhI7TcuZ2N9DE0zjwO+EXrM66AqxiAie9QFlBIoTJFn6VJ2GIDAy1mG9MtszAmARY3xGaSiUUCg+vBa1RYriA46cf+Rya5feuti9vPOL3TolKOE756iJYarUGdGOzkEDAXD6nT+A/zRzsoGiP2WumhHHm2tJ0pPW3lfkgLuxrG75bciVhiiJcPuaUmlk/rhn+6wEeZH0EawMEpvMpOacPtc2uO3H8ANGtP1lzhSvtiWIeb3iexJ7M3WZaZuKvJHeouaUJcCSERvTihm2z3fX9GQpLeuX7WMaYCRdYJWCI14d3YIdRs9+bNptR6yMCZ/XWpQaMbC7OtN24KcYTpq6X7YggoMrFbl29CLbobIGpgqA6C/wNITXkc7fkzC6ARrYt90Ymai4PtOfMcJxVwStpZcDmHWk7rylchsxSL0UKeB1xG8yNJ0hzlRCDZCvTPMHhc9NbcO5GQzv3ZImvXjBfJVG4/226T4D5IUEud6r86elPW/bp3RasuKHKbVCzgX9BVtosK2v4TXjUZP2Mwu9DRDBjAe83bKxd29GWeuKi/SxfrLxCH46jzfpsMeNHztCYGytVBZ02UY2IIebUbXvQJvynBcnkqf3kJFbeGKtwNUt9AHAJ3VE/LqppMJc8UY+PFBQL20HFMDsMovho8zGCnwPP+Tcbu0vchtvMDTHxllsoI8t5ITfMRJ52yOH7Q7vKwGnhAD6og7TyKukoZzfAIGpl4rWFae4Nw//xrPQUCWLc5DCZM7lqvwZy5n2f3nGjbfMx+2NCng8NWTtywBFXyR5CSRlkdvITvtdtDBnnokrA9gNI+3B8bVyxGmwHcDlA5
 D0z/4wuV
 JVZ03XUJB6JOf3WmBp8/ctpp7qzQnrlzPmlG2L+8SCfBw52b5Ck/r+zdR+yrkYEQEsudLEQvebNPm3w5cZFZ5Zx/GtkbICMejrX7M+bVTQA6TNIrDT1vvZUxPbkFG5cHDliAPy1Js10UFl/RsdJP96mM2jxFASJ6rzecMmDlH8m5DVYfxBl7l/6BweK9A2EQFMTJNimE5dHnkNv0MOzCeZtd4bfGR4xDCTEzbltzz0ewvDPx+qBzGxcr4SKDRTDR2+zLMBWnK0de7GyCGeC9SO8CbT3lNVqQg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing kernel page mapping mmap actions allow for partial and full
mapping of an array of struct page pointers.

However some drivers require the mapping of discontiguous ranges. Permit
this by providing discontig_kernel_page_ops which allows a driver to
specify how the operation should begin and how batches of pages should be
retrieved.

It uses the minimum exposed interface to do so, providing address, page
offset and both vm_private_data state and a local private state object.

ops->init can establish state for the operation, and ops->get outputs the
pages to map and their count. Should an error arise the core unmaps the
VMA, invoking vm_ops->close, which is therefore where any state established
by ops->init is released.

Batches may not exceed the VMA, but may map less than its full range in
case the driver wishes to allow the user to map an area larger than the
available data.

To use it, users invoke mmap_action_map_discontig_kernel_pages() with
initial local private state and a set of operations.

Users can then use one of the provided helper functions to perform an
action:

* discontig_kernel_map_abort() - Abort and leave the mapping as it has
  been accumulated so far.
* discontig_kernel_map_page() - Map a single page, or a compound page given
  its head page.
* discontig_kernel_map_page_range() - Maps a struct page ** array of a
  specified count.

The userland VMA tests are updated accordingly.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  45 +++++++++++++++++
 include/linux/mm_types.h        |  44 +++++++++++++++-
 mm/internal.h                   |   3 ++
 mm/memory.c                     | 108 ++++++++++++++++++++++++++++++++++++++--
 mm/util.c                       |   7 +++
 tools/testing/vma/include/dup.h |  11 +++-
 6 files changed, 209 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a1f2d375cf7d..2a92193ac6a5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4647,10 +4647,55 @@ static inline void mmap_action_map_kernel_pages_full(struct vm_area_desc *desc,
 				     vma_desc_pages(desc));
 }
 
+static inline
+void mmap_action_map_discontig_kernel_pages(struct vm_area_desc *desc,
+		void *init_private, const struct discontig_kernel_page_ops *ops)
+{
+	struct mmap_action *action = &desc->action;
+
+	action->type = MMAP_DISCONTIG_KERNEL_PAGES;
+	action->map_kernel_discontig.init_private = init_private;
+	action->map_kernel_discontig.ops = ops;
+}
+
 int mmap_action_prepare(struct vm_area_desc *desc);
 int mmap_action_complete(struct vm_area_struct *vma,
 			 struct mmap_action *action, bool is_compat);
 
+static inline void
+discontig_kernel_map_abort(struct discontig_kernel_page_state *state)
+{
+	state->action = DISCONTIG_KERNEL_PAGE_ABORT;
+}
+
+static inline void
+discontig_kernel_map_page(struct discontig_kernel_page_state *state,
+			  struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	if (folio_test_large(folio)) {
+		VM_WARN_ON_ONCE(page != folio_page(folio, 0));
+		state->action = DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE;
+		state->__folio = folio;
+		state->__nr_pages = min(state->nr_pages_remain,
+					folio_nr_pages(folio));
+	} else {
+		state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE;
+		state->__page = page;
+		state->__nr_pages = 1;
+	}
+}
+
+static inline void
+discontig_kernel_map_page_range(struct discontig_kernel_page_state *state,
+				struct page **page_arr, unsigned long nr_pages)
+{
+	state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE;
+	state->__page_arr = page_arr;
+	state->__nr_pages = nr_pages;
+}
+
 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
 static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
 				unsigned long vm_start, unsigned long vm_end)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 9ca2ea3664bc..0cb4f9603956 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -818,8 +818,44 @@ enum mmap_action_type {
 	MMAP_NOTHING,
 	MMAP_REMAP_PFN,
 	MMAP_IO_REMAP_PFN,
-	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
+	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
+	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
+};
+
+enum discontig_kernel_page_action {
+	DISCONTIG_KERNEL_PAGE_ABORT,
+	DISCONTIG_KERNEL_PAGE_MAP_PAGE,
+	DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE,
+	DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE,
+};
+
+struct discontig_kernel_page_state {
+	/* Map state. */
+	const unsigned long start;	/* Start address of VMA. */
+	const unsigned long end;	/* End address of VMA. */
+	unsigned long addr;		/* The current address to be mapped. */
+	pgoff_t pgoff;			/* The current pgoff to be mapped. */
+	unsigned long nr_pages_mapped;	/* The number of pages mapped. */
+	unsigned long nr_pages_remain;	/* The number of pages remaining. */
+
+	/* User-defined state. */
+	void *vm_private_data;		/* VMA private data. */
+	void *private;			/* Mapping private data. */
+
+	/* Users should not touch these, use discontig_kernel_map_*() helpers. */
+	enum discontig_kernel_page_action action;
+	union {
+		struct page *__page;
+		struct folio *__folio;
+		struct page **__page_arr;
+	};
+	unsigned long __nr_pages;
+};
+
+struct discontig_kernel_page_ops {
+	int (*init)(void *vm_private_data, void **private);
+	int (*get)(struct discontig_kernel_page_state *state);
 };
 
 /*
@@ -844,6 +880,10 @@ struct mmap_action {
 			unsigned long nr_pages;
 			pgoff_t pgoff;
 		} map_kernel;
+		struct {
+			void *init_private;
+			const struct discontig_kernel_page_ops *ops;
+		} map_kernel_discontig;
 	};
 	enum mmap_action_type type;
 
diff --git a/mm/internal.h b/mm/internal.h
index c767007c2187..b81fce5fe510 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1516,6 +1516,9 @@ int simple_ioremap_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_complete(struct vm_area_struct *vma,
 			      struct mmap_action *action);
+int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
+					struct mmap_action *action);
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 448342883e9d..45b21bb04a18 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2609,17 +2609,23 @@ int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_pages);
 
+static void __map_kernel_pages_prepare(struct vm_area_desc *desc)
+{
+	if (vma_desc_test(desc, VMA_MIXEDMAP_BIT))
+		return;
+
+	VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
+	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
+	vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
+}
+
 int map_kernel_pages_prepare(struct vm_area_desc *desc)
 {
 	const struct mmap_action *action = &desc->action;
 	const unsigned long addr = action->map_kernel.start;
 	unsigned long nr_pages, end;
 
-	if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
-		VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
-		VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
-		vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
-	}
+	__map_kernel_pages_prepare(desc);
 
 	nr_pages = action->map_kernel.nr_pages;
 	end = addr + PAGE_SIZE * nr_pages;
@@ -2640,6 +2646,98 @@ int map_kernel_pages_complete(struct vm_area_struct *vma,
 			    &nr_pages, vma->vm_page_prot);
 }
 
+int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc)
+{
+	const struct mmap_action *action = &desc->action;
+	const struct discontig_kernel_page_ops *ops =
+		action->map_kernel_discontig.ops;
+
+	/* At minimum need to be able to get pages. */
+	if (WARN_ON_ONCE(!ops || !ops->get))
+		return -EINVAL;
+
+	__map_kernel_pages_prepare(desc);
+	return 0;
+}
+
+static int apply_discontig_action(struct vm_area_struct *vma,
+				  struct discontig_kernel_page_state *state)
+{
+	unsigned long nr_pages = state->__nr_pages;
+	unsigned long addr = state->addr;
+	unsigned long i;
+
+	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE)
+		return insert_page(vma, addr, state->__page,
+				   vma->vm_page_prot, /*mkwrite=*/false);
+	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE)
+		return insert_pages(vma, addr, state->__page_arr,
+				    &nr_pages, vma->vm_page_prot);
+
+	/* Compound folio - have to iterate through each page. */
+	for (i = 0; i < nr_pages; i++, addr += PAGE_SIZE) {
+		struct page *page = folio_page(state->__folio, i);
+		int err;
+
+		err = insert_page(vma, addr, page, vma->vm_page_prot,
+				  /*mkwrite=*/false);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
+					struct mmap_action *action)
+{
+	const struct discontig_kernel_page_ops *ops =
+		action->map_kernel_discontig.ops;
+	struct discontig_kernel_page_state state = {
+		.start = vma->vm_start,
+		.end = vma->vm_end,
+		.addr = vma->vm_start,
+		.pgoff = vma->vm_pgoff,
+		.nr_pages_mapped = 0,
+		.nr_pages_remain = vma_pages(vma),
+		.vm_private_data = vma->vm_private_data,
+		.private = action->map_kernel_discontig.init_private,
+	};
+	int err = 0;
+
+	if (ops->init)
+		err = ops->init(vma->vm_private_data, &state.private);
+	if (err)
+		return err;
+
+	do {
+		unsigned long end, pgoff_end;
+		unsigned long nr_pages;
+
+		/* Default to abort. */
+		state.action = DISCONTIG_KERNEL_PAGE_ABORT;
+		err = ops->get(&state);
+		if (err || state.action == DISCONTIG_KERNEL_PAGE_ABORT)
+			return err;
+		nr_pages = state.__nr_pages;
+
+		if (!nr_pages || nr_pages > state.nr_pages_remain)
+			return -EINVAL;
+		end = state.addr + PAGE_SIZE * nr_pages;
+		pgoff_end = state.pgoff + nr_pages;
+
+		err = apply_discontig_action(vma, &state);
+		if (err)
+			return err;
+
+		state.addr = end;
+		state.pgoff = pgoff_end;
+		state.nr_pages_mapped += nr_pages;
+		state.nr_pages_remain -= nr_pages;
+	} while (state.addr < vma->vm_end);
+
+	return 0;
+}
+
 /**
  * vm_insert_page - insert single page into user vma
  * @vma: user vma to map to
diff --git a/mm/util.c b/mm/util.c
index 438170490e7f..c5ee52aede1e 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1469,6 +1469,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return simple_ioremap_prepare(desc);
 	case MMAP_KERNEL_PAGES:
 		return map_kernel_pages_prepare(desc);
+	case MMAP_DISCONTIG_KERNEL_PAGES:
+		return map_discontig_kernel_pages_prepare(desc);
 	}
 
 	WARN_ON_ONCE(1);
@@ -1501,6 +1503,9 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
+	case MMAP_DISCONTIG_KERNEL_PAGES:
+		err = map_discontig_kernel_pages_complete(vma, action);
+		break;
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 		/* Should have been delegated. */
@@ -1522,6 +1527,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
+	case MMAP_DISCONTIG_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1543,6 +1549,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
+	case MMAP_DISCONTIG_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 1098655a5f4a..1d5f6b3cbd21 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -457,14 +457,17 @@ enum mmap_action_type {
 	MMAP_NOTHING,
 	MMAP_REMAP_PFN,
 	MMAP_IO_REMAP_PFN,
-	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
+	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
+	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
 };
 
 /*
  * Describes an action an mmap_prepare hook can instruct to be taken to complete
  * the mapping of a VMA. Specified in vm_area_desc.
  */
+struct discontig_kernel_page_ops;
+
 struct mmap_action {
 	union {
 		struct {
@@ -483,6 +486,10 @@ struct mmap_action {
 			unsigned long nr_pages;
 			pgoff_t pgoff;
 		} map_kernel;
+		struct {
+			void *init_private;
+			const struct discontig_kernel_page_ops *ops;
+		} map_kernel_discontig;
 	};
 	enum mmap_action_type type;
 

-- 
2.55.0


