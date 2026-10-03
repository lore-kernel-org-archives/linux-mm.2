Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1729CA5FEF
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08F816B00AB; Sat,  3 Oct 2026 12:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038DB6B00AC; Sat,  3 Oct 2026 12:37:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42FF6B00AD; Sat,  3 Oct 2026 12:37:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B97EF6B00AB
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:37:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48383C09C6
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:37:24 +0000 (UTC)
X-FDA: 85281870408.20.5A3D1B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7B8B440008
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:37:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b+Kfku5Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045442;
	b=1IYR+iCVtikR8Ll2eTp2aZQvrlhdAp7Os1pTLFdCra99e1s8/cPXKR1xJ6kJutqrmV8Yl2
	gb6q1abP5tptmkPEJNnpaR70Tg33OsmTNLh9Wfw/7m9fhVRy7jDy7y7UBqMHLu2r1pg2SH
	Ur0u0UoHMuizqYYB0cnnGMe1QRPUApk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b+Kfku5Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bEhac22DjaEOz7TmR2GfxBY6Gf0j7PAmy6T6j8AnXw=;
	b=1Xn9i47m3+wZsaYz0awcS7GNBxmX5BNlC1N7VWKUH9GgDsuoxBcK5n+2y+zeY3R1my38CE
	FYXO2n13KsGvtPameq3MK9BJGKsSTVpiE68ywEAoaqcmL7hqf8X2oYtwWFZOT0iK3VlduI
	LpboqLNTtr2MWrLZ9wLyUjxkiYaqZQk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C01DD43A94;
	Sat,  3 Oct 2026 16:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF4B1F0089B;
	Sat,  3 Oct 2026 16:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045441;
	bh=3bEhac22DjaEOz7TmR2GfxBY6Gf0j7PAmy6T6j8AnXw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=b+Kfku5Yq1wiwygK8HrCD1hdjPqMTrVFkoJPgucxLG53AM/LIb6Q7/FKXI4/xzsTC
	 TYuyxi2yKBe8z4Vk5FEm31tuLwdjkIAejDEZ1dgxPkO/RavgU8dq4HfR9oRJekxHS7
	 UB2U/0lqtjI1A1zFHRWHfuXmf4gj3odEb2Gq64rnPDE8wjPlmmHdE8SkY0LMXm6DYt
	 9kL7VVgp8XhgLAC+JWIP5FugDANgmtvQDN4F1FIJJ/FaXh6dJnrmlOOUtQNCDdgAf7
	 jh+AKFopVQWSlLemYXOn/UR+QQn1CejEd8KgUGv8ErGh376yJ+X+TwYHkMyHAsPiGg
	 vKLqHiSBVX9Iw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:43 +0100
Subject: [PATCH v4 12/38] ALSA: pcm: use vm_insert_page() to map PCM status
 page
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-12-a1f052500fd7@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Takashi Iwai <tiwai@suse.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2771; i=ljs@kernel.org;
 h=from:subject:message-id; bh=mNCJrxc7px5YuTacAZTswO6qmAoR87Z0kQgQbb40+XI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mlopln/WVzruYR9J4PfBGP2NzvDVx+Y+PjZTrWv+
 p+sT1+O6yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBE1m9mZFhZuf2RrGH08k/b
 JGbv5dp2e5bek3lh82tnb1mdEaJl17ye4Z+Fxtzp8r2L2H7+ODp9wocoxwUWVd0PuJI3FzBoexV
 nWXMAAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: u7nx7w34o9wb5tef45c4mr4r9wmr84if
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B8B440008
X-HE-Tag: 1791045442-486647
X-HE-Meta: U2FsdGVkX18pNbXSC3f+S2bKcDLF2QtW8Uj9dXMC4AMj0xmt8d+RYtzFQAacH5/dwDSoSH9G2g8DIcax2KYd+0dXyiBZkYRZ/dxqvpCB7N1xaq0SevmbdGJDhvNncYvmCmNmP8S4JoQrobnXKOdXh25lYhVvgvoBtDF1XZ2mxU7R9oHcPiPbufuz5XW7P3NPXMUiUMHlTlBk17R1kdFtEr5t+21JyGe5qOGmarI7iBILpsk373u5uxnioOUP89wbEgIBgGg2p3RgA+bE8Az9z2OeJlvjR3kko21S0prizLt5PSoJ4lIWr1GxkyyzLNxX+33DDC+yfK4StM550/PH0thd/gswFcFXlr1xa5DJ1sPfqWLqtziL5h5kc33dNm/VAsupXsiz+wEA9RrXqksfiydo4xc1vV4r9N6lmN08jNwJn1efxfDnVfxAanwnOPx+efSE1peEAjzkHdEbOtSj1YKkRW5uVXSwy/P77ZSMZRn8RE2XcwKmbboWY6Sa07iJNIDGHfo4AYbHmEY60M5vvFv9G9F40b2xRpmBh9gBGITY2N3e51Ggk0nkCdFpkwa7X2kk6fumbHlEfMPt6UTTjy4OUgo9adSPstViLNNq519ifDfrbqhmn3qUhJtfeDHJlX3tEedHpY/iYbyUSwjlxv4SCOWU8Bc3A3HGSdom4leZz/TQMgv7lstXjeFDf5kIWXGO7a4uWcEmpXDOvY7z584nXy0WJmgsi4kJqLrDfxwTyK7/+6j88AzXl3bOVkd2Tlhk3phgl6b/qzWKV/CtFBZegDRsJqO/Ts/AB9YTfN2w3CDvEb4MnsJ/A7IljydNe/5fA4ejVgh2pM9jlr/LMPsCtrgDl+XWxYNngXxFErxiLNC911CYt6kQd8TdaNHL6HRKMFm3KOSN3sO1f0EIMvJJiiOkLQg86oV1T8HYJBi1OSWQpHdvAM3AkflTMOtu24KWoKx/jyrFJJyby1P
 Nc3DirpH
 oo1ky7is1+NpzXSr7YFalggz4GsUjCqFglK1Qkl6hAjUuIaVFO2aYulSiNJ39VZQWAf1I13I6yvywrMeLIEW4i8jRhuD30Gg7g6UU7RzEcSBsxO9HjdWuHgEEYVzevtlxGc1rV9QEhWc7rhKY5UQEn6V6sAdxdR5OjXSjy8pmsFET22yf2E44UF2i4WLWD8mkPim2+9Zs1CUw+T9XmU/GAZ40x7s0X0U6XLph5YuVxwsWUugJUiHrqtlJj3PDfe19NTHXjG+ogIrxgYMGCEB2iUVoHV52SGg/Lsy+SLhs5M+5duQ/5n/M8SHPNCAHpZ7ADNg5xZ6k5EpDiDXR6SZF39udNfh44KzFWg9cyBAvz4d1QiRcbwQpehxUSjjHC/Dk0DxgmRcvITxEzmujODkQ+ZjNhJdW1iSegFICV0ZM/Y9blGm5pgcR4BEQsSiRmKuvuoMI0g89y5a/Dkm/jwLcL9FyQ2zaxMvEJrD4lANd11kjjO/VsgJZWsrNYz9nUTplSIVC+kSJeMTgrnQXrwkH6tAQ+8sMckYKqJVo0+FfFLF5Io+xyKEQimbCPGiuBIJWeGCrAmI31x7FfOoQM7Tqom7G6cKLSQQNZAYByZ44xMM5t0bi9poncvIROv6V+GCjt5aIHrILEW9qyq7awd4lWhvPxlnP94t8IxEqUuKfyg/L/M3HXZHLOiOdwYLbMZeCCroIYJhae70wE1f40Lp002wJSJRD7ZL08Zt3p5X4rJms5aE53LH6IE3SriQvanNYNERWMeb0vvQHMqO6rLUMw+y+zb05uFl6nfVHTUGialh6tPxeQG5/TOAPv08UXbMhmP7OfQnbSEhDK7voqRE79eHpSjdZQZzd4GLlmg8GPKHfUr2/88LK6hdczMl8Gpsx0K4C+M/VY+oWffjgvHXAhz3LO1JHGGrXVJ3U64mkrKiSESYxeg9H4NGgNWo+yA4/rUNJ7vgyaMcDSONA1bAz8NvJomqX
 i6Q3AvQU
 23GraxutvkNgPOkHAYTewRbAtx45+i4N+XdPL29V2jGbhtnjWotShKvODHGuk1SD1t2x5CJJadFHa8eKH3Z9q71reJekwHQMFa/v+GJNRNraJ6rYMCRbqxhAnMxuL4rtI/vu/bObU7Ys1+XbQ+SkxVufYjZ5lAhOSQMj4/XiE7OWcZNW2FSUyNOQukQrjbgA8jI2pin3a8CeoJPYixMkhBOEMG3f+sQt6/888p6xa2KF+lkJW+1ZgrrWgfXZh/ssWiJpxaQJQ0xzagZBDXXmOTdhnPcorKhafleXqGhlseLqI+kbplaPxM/kqk63EDR4rDexxwv258zBY9xqGWBtS0/ZC4JmTKWBTLC7hYYuCFhcCqyf8SnVzuDrqynojS48tJ5CdgSORZ6ffgNF0bL/4m0EGWIFK269KVWrB5UCQIuExtYyhw8vqCupEujvllxhJrJUUjL/bmSr0KW+6FDe4o9fGpUotncVDGlm1Ph99O/P8GVIR/j3yOYSn6MEOWs8CRszrCnZZLyduTifhkC2NbsLBf/UjZb1D1TrLgYGpnlLJrkJiXYTMjmIaUwcPJmU4vsWlVit4xuGlrGhBE6OgiFMjNJjWTQ0id/2NfggKNeFqFuPLchopgiFQSsVvVuWaKYKzNw8S9my/lAoQY+YWH0Iamy9VEnJP8omWZnQ0SVYsSjL4eHLFY+QLu8Zc13799x7HulEfZbd7OBZ8hxaOBKKY5WGBXmJm5T2nrV3iotVb8SFYLhhVNqJ9KFTRh6GkaZkmUCgFMHGUOwAqDC++XPpgIUE587+Tl9usc7Ea9z5Nw1zcLtO/Zoz1Qu1Gr4haz/vjdrI5/g7SeEB5kjdai/mTIl7d6luZlG9b4oHN4cKJuLb+7y5xi/so4umC7xsnd1sxAaeSrzAoIr5Lwf222t8E8rCHK9bdiYvzkncv05DPiWtr5WrXPcV8p8MeUnSLXS2xn+bILceG26iWK+wn3B+1VcNN
 NihemACt
 sscjS1OV/Xc3RydnGZBOqG/0uIL1ioKGzgZ2HjGGsncZ6faW5dTWtvE6Gotxt240+cnR9fhYe2n6on2+BAjysSyAimT+TUp+vDN0zVi1r8F+8FBWBhWSTzTiWoO61FUYTpTKC+aaA292R3hBCVHtqxAr9GebIzgivOoQ3XXr0lY2cgvi6xLYBbIwSFepL+/yi7Lqpswnlp2nLGDXlB4nbWMkjZ/jcmaV9rVcli8W+b0NVobaLQg+Nzw0XI8WZNWDg6j6SMe1u5JJjZA1k5w2jqM4K8t3fJ2QkgZbuwTfrMKJtCaNKIWyl63uvm4DlwEws2oXSAIUiVW7hBCEtItnhwo2M9UK8wXFADJiASYHYilt6iLJ7PpnUXGq/VhBUAeNzc/O5SdDsxRUnpxcsg41uLgtQY8jW7Ota9NyyarVGlxI2n5CGtprr5oI/x+VTbTO80D4+rBK4mX2nEhfLpT3L05Brxu0FC0Cz81dntHkkgbClBZ9uDioqxnOLHs+RUoY6X/6KDvV1n+4kGzDYD6bVWjcoG08e7ZXd3sMSFA171avmA3SLqx8uHew/9clByNryBjLkIwDVN6mfPX3Sq6Y+qGl7KCyerQJsjPu88Rd8aQCscSiSnTlc1/hoHaQxBPyxu87787/JHpvOp6iUM6o5EUb/eGbl/a0AmVyMhUJ+bQg91UaR8v9GRIjp49LlOFCxE8q4pCf1ruVmwFVCM7huFFsJxDrPahD94wvpWydaHSWIjEsCCQwq6DBJcfPoOr/rGuGcdsWmYJlvAUZh6e56gugFIMgx6ky/pxd4xQw4JaF7QGV7HSObm8pK8svbHM13DLY9GjCqvATljYyg3mcCEFYMjlSex4unNvikH/rJtvoMdXbSlpGhJsxZAPoprIvI52w029FAZ4Xqw+JvIsIQHsiwSvBSf9jm0r862RVIxRjAKBOyzt1ohmTn3NgAsOTUhk+ZCtZqJAFo7ealGe8avDqO6U/p
 zJmKNdTF
 hJOy6JYkdYKTxwOF1Y7h86AhwuzUH311FsqL8vm0MaiUbQxZz7TTRiDU35iD3IPN21ZpHg1bY9/FavZvFzrxSUBPSEddeyeq3dUAj62ys1KR5wJ3IxW55FtnHVfoMOlaIN+OvEbWzdaGdV5bwXF9juhlf2/KyvsUK9ChH0r783pu0ELRD+UEdBxE9Xg2qzvTGHEgsiYPKYh6+ey6VFUhOcTUwD1aDgmokoavXX7HVAnhJaFp1v+8KMl9W5yFMN5oKn73iGJ4zg8/8jFEOLqMXHRMuZN1EpGNPVxDYChUb5ZfQpSJQvfZmn6OYRDCd7Qv655viQ4m1JHuygqiYDUPaN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to keep a fault handler around for this, instead map on
mmap.

While we're here, rename area to vma to be consistent.

This correctly makes the mapping a mixed map mapping.

This works towards establishing the invariant that only PFN mapped or mixed
map mappings may clear the VM_MAYWRITE flag. The status page mapping clears
VM_MAYWRITE, so it must not be mm-managed; the control page mapping remains
writable and is left fault-based.

The assumption is made that the struct pcm_mmap_status structure is at most
a page in size, which is asserted as a build bug.

This is safe to assume, as the size of the structure is 56 bytes at most.

Acked-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 sound/core/pcm_native.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 62324282fcae..c98fb3df14f3 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3760,39 +3760,27 @@ static __poll_t snd_pcm_poll(struct file *file, poll_table *wait)
 /*
  * mmap status record
  */
-static vm_fault_t snd_pcm_mmap_status_fault(struct vm_fault *vmf)
+static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
+			       struct vm_area_struct *vma)
 {
-	struct snd_pcm_substream *substream = vmf->vma->vm_private_data;
+	const unsigned long size = vma->vm_end - vma->vm_start;
 	struct snd_pcm_runtime *runtime;
-	
-	if (substream == NULL)
-		return VM_FAULT_SIGBUS;
-	runtime = substream->runtime;
-	vmf->page = virt_to_page(runtime->status);
-	get_page(vmf->page);
-	return 0;
-}
+	struct page *page;
 
-static const struct vm_operations_struct snd_pcm_vm_ops_status =
-{
-	.fault =	snd_pcm_mmap_status_fault,
-};
+	BUILD_BUG_ON(sizeof(struct snd_pcm_mmap_status) > PAGE_SIZE);
 
-static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
-			       struct vm_area_struct *area)
-{
-	long size;
-	if (!(area->vm_flags & VM_READ))
+	if (!(vma->vm_flags & VM_READ))
 		return -EINVAL;
-	size = area->vm_end - area->vm_start;
-	if (size != PAGE_ALIGN(sizeof(struct snd_pcm_mmap_status)))
+	if (size != PAGE_SIZE)
 		return -EINVAL;
-	area->vm_ops = &snd_pcm_vm_ops_status;
-	area->vm_private_data = substream;
-	vm_flags_mod(area, VM_DONTEXPAND | VM_DONTDUMP,
+
+	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP,
 		     VM_WRITE | VM_MAYWRITE);
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
-	return 0;
+	runtime = substream->runtime;
+	page = virt_to_page(runtime->status);
+	return vm_insert_page(vma, vma->vm_start, page);
 }
 
 /*

-- 
2.55.0


