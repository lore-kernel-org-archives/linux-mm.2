Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32F25C88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 439516B00AC; Mon, 14 Sep 2026 11:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2F06B00AD; Mon, 14 Sep 2026 11:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28AD96B00AE; Mon, 14 Sep 2026 11:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBE9F6B00AC
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:02:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8468880193
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:02:17 +0000 (UTC)
X-FDA: 85212683514.05.C6D4471
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7B539C0009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:02:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FbtUOEcR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FbtUOEcR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398135;
	b=XI0XL33mE83kVYIlSIh3fqo1SowvwRGJ1lOunnYg2nCJFLYVJ2Z1R99pMUXn80yCDiL78u
	hBIyzcQG7TF17xewIiyt/zAzW2e8qQ7AYQRiqRRbWe58vWKhiCM3Hjmv2XwYy/fG8WKigH
	WKDcwsG88US15YXueYfTVQwHpPDVD/Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fTmcmc+a4IUNwae9Nxcfez5sumoqebDO82GfLQBZkY=;
	b=imfsYI8QjLkxHjAx3RY4EPCSuw5RsL4DoNUVMg/uBPBnJxeHAn3RmNtgF+zEGQ2XYpaDvH
	CBX232SX17eKSut3KCb8DYWnuCRNNtUIFpd5TlfD829S455vOVA+ot4Ps8Udj9ve5AqqwR
	E1rmPVAXriXM5pLEtZj+kODk1vNrLJc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4DF743686;
	Mon, 14 Sep 2026 15:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3AE1F00893;
	Mon, 14 Sep 2026 15:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398134;
	bh=6fTmcmc+a4IUNwae9Nxcfez5sumoqebDO82GfLQBZkY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FbtUOEcRtZhns+Zw5yDfZqYhCI9CoETgI/1XfZ9DKiPZsjMzAh+cNfYgAHHBh5Ze2
	 UJCWSzDSUrpDDioCW/uL/8TzzzHYOmlUyDKnjG7KAw9Hmdf+8JXoV637sifD5wOGXA
	 XslPofXx4VNhS1MijPFO6ayUd9qNWgPpYBakikTOKGGOLNMo09ft26O9TA/7cY3WLP
	 zfR0ZJHRxRYb05Ub2a4s0/yoqCtwb/jfek5lrNzBxvsCj7aQ/qpc1WvNqTz0Ugn2ww
	 Bx7L/tBNLBhxSd9KD1w1dJcxqZ+ZD4kcHBAWWQ5gzQPj36qivS4A+qkoEGLBOX8UIf
	 LiCbaNkrc9lFQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:26 +0100
Subject: [PATCH v2 06/40] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-6-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2508; i=ljs@kernel.org;
 h=from:subject:message-id; bh=qfAyj0ybwJ4DJXdH6Vmm7/5PNAiQvM8UyRor9dsN0CI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK+r5PCoDJPNUgphWKkfuuoH/9JZFr1nKwtUDSP3z
 Cn7oqndUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgInwyzIyNF9mWVXYPW1vb7ZM
 66s/zkcn7tkx+5WDrPIbuwuVNj2Rmxj+RxzIutOxsltC5Kf/lBLGusmzUz9u109jY071Df1+RmI
 3BwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B539C0009
X-Stat-Signature: rwt4uhdfgzfbyxqw73adjkkj167fy6kq
X-Rspamd-Server: rspam01
X-HE-Tag: 1789398135-328187
X-HE-Meta: U2FsdGVkX19eJUr0Ca7EqzlCPVKeFbhv9DX/Z0CIWvqiSjCGQfOLhjiVax6KgoIWvub/iXxEJ1vUp7n6YNCMV80I5WfI0PXnELzV0N4dxykmuVsi4WfTjZzOwUpe24SvT/Xdd0zvy7H1n7u9Jb5USx50nSVLwMtcB76TGhqLtb/YPgnxiyHXyWwq41U6QnajnCk/r2CnoI2pQKq0287hgg93BZSH0XruzKfKCby/EXDpVJ5yXbt9L2/pLZ38IYv31vNmBdAoM48lgTsJIjpdyM4gHO7If0hDWUPWm+/xneQBFNv72hxaFpcvXcabbaZjKdboht+u10nxzXkr5wrh+7nNmfZYk9dUA8VzjXcboxx9xixsfBVcKsXzwA2N/N6gK40jNJ3hDvY+D+ma2Ey+WTH24oMFflN/cNUpILO15rDBMNeNI98vCPkvgAzJzlDm43bRH4y6w/kwohaX9nc+bp57C3y71i4Wl1Rt869ohUKVGG2JzGV92HV6GyL/OVPAQ5GoDu0HnxCgs1yh5ajxm33pEcroRXWjhk0rwldi75oAYSV6nK1rGTbLqH3ZlJjdD3PpryJXofrZAr3DwYJnvpNW25KiQgjYSySlsHVxss6m7jh3E+62fG4X2I0mfDTZEOt2yNcPxta3U/C/7T0lgdPpS85pkq37G1yt8Cu4M78PZT9Wzvm9FDHK7nXAWNplZyjrUwJV4QwX8qv2gI5lpNpgqq77Qo15awGXHKOCR2u35U1lSLlEhIXiT86+4/uHeYir5ect07Y5dQk+1pMUPqHjDcyKfNYAJBxhE7axvsTy8giW2nUovnUyMyGBir2LOsAyQ1z5gs+ObCDZullhvGpZH0NjACYboVXBDk+nifv9ZggkN/N4iC9wK3eTz65mjFCnulURFdgoQ3eyCNhylrEmBJ1lqjx7xlGABCTdJpKsCnS4JGjbp3/DarW5x0B+KWl0YDQ/vgfurvUBtMt
 YtFq2ums
 E/lvhbUaXL22IWgEQFwCQVG2ajzEzZtAVN4QyxGC6ubMuazEinEkpDzuwZXOVksLTSgvasn0CFtvft65BPyBXnj9vL/6p+leW3UPS+X+R8CzLLXtRv7xxKiRQz9p9h2uJFJAW4wQbP/lq9PvUoZl5ZGk8tQ/sSksd3iJrBnR2f4GuFbtI+FuB5322e4DHjoVErzsP2AyGxDI4wWDs9kmnqaIGHmy03yLPPpRLjfIXW84lFHhcBTbJxWJ2wDFV//pjzsBRa+9oET1D9hH9S1Lj7enSgCRAP2jKwPtznZ0ybjrV4OS+vTSUUfRe3gaZE49CdRQrUYMBI4jjorRGGudNJqWJqD78dF2XOfuA+6yS1p03MY5qjWmHzJJO0/Mgnl4dLCl18KVtelKTB6fQzW9mahUBXUIwokxSnqsSr1eBqaX8fJDebnKXOXUjXnyx2Oi9mxcjQ2n7O3vHU42iXObNBw91LgdjBjs6B8bvSI+vKfV3Lef+gskj8JJmM+Pd72jVYjPpnooJro4AxlUAIyskSqChazRuFISttSespBe2vjLwNEPTPe1CpAFWnz/w9ZS/tm4BXAhGA3p7/lPjlxpJyuljgDnFxnR4j6MdTlvEXqbpQ0IKZ3wilseqRFRXESmHr4mtufcX1L1mGfFF8GDckLeh6VtCU2epUHmrao2TE3v71iFn0eZVcbf0FV6HxkRFxdQvX9NAhWV6BxwEyyMR3L5tS2Jt8ZEqUjxXA4WnTm8UI3BmeDwWfQZBsXkTXUvS2Qbyk4LSDfnOL2eO59ZfVNKQYrkcWuWtKfRHzKjRSBvZfWyJM2MvrZLi2ozu8Va0bjGzTr3hIazJfKLt0P9h56g1w7NFrvvf407tdnxo4L9HTOho/IVg/pEnVEvQOXjAXCVDf/WGjB6jdJcX+lWyBOeP7r0bNpgSJTulbWokY+Ap0fSFYcSQXJENF++AyhYns7dbRMs9R4YPHhXIkltfqUVICst/
 K72NmxXv
 iDyyrqrkT+Mo2ePQJYSO0av5rbgEM6U/U9TPN7orptoNZgO83SVvf12qVuOrrInzTCyxuKfsV5rIBtK5jLMVr79oDM78gnwD+ypiktQ6wotVtxhiW6Zt2HRrQzMr7dy8nbHtynRnRAfxzM3efHpvcMZPrhfmt1epraf9VrcBOYu64iAUfo7akd9x+O5I4gwCtis4LinEX+nZ+HZYTMQGFzM0Xsv3qUpgskdfhIA6cl9OqDpDQSxyvjhGZ7f9OT23O+6vtuPyjzj/5RTTJrnZtujhESokB4skQZhPK4BJou9TWHiwnD+wcCO2Zg35Ee5nrDKqjh3tlQQa5wMheoLF6dPZYMjvt9HK+uaj64Ur2NcubEFhSt3MghUv9mg+PBXmRzMpuoawtoCa0gsUZvgmzk0cTeRSI+Amx3Pro1SR572nJ1MCL/v64jyiv9w4IJuLG9ea8NsGq1O+hEotiGyxbFNtO7Hb3N4jB+41NJYJTXKUHpqBptOYuq1w6+bfQFvDGHqgLxF+O7qvbCs1AxdhtCckQF94s1DKXEoAaj+Hruaymsgk+XCPLrQ55PCmv1E6bMiMWpGR4fG711bIfgEKSSYEw5dFFX10npjo/8mI/Cc7Gxcgiryg65CTCpGfWjjD9tDNlEwvW7PkiQGkXokC6Rl/7ygO/8v4DZS8DUeAwd4igtvg1U5ji2zqz2GmHBgwpHDXH4QW2PTZBM8JuWUoja4GIgAx+dH0KAQou5A1C76hwnnWwEkipF48R2myjJjByACrbGDOwtAIVAajyyiugHLAm6K4AoUk92oRAvoA85cdIkBkbWaMtAkzBGPX24sKS71n5WnaSr0DAFoTe2+buHEoehjjbb/XZ0bmRwVdH+XCbA4Y62exE+DgiTiDh6lfpYPLR1WZ2daAlc93wHIkg9LAGH3na44R5iDqhMIJBYFeAZPze8CENMK3Q5n77QGbQjpQNFraHiUnrJ/kOYgTMqpl9Ou7V
 sjKFNbmI
 Fmn7KyN+9gi0CEDq2thXpCfTSX6+echy6HIYdxTrwBa8q5XcfKT8k35oGP1zrvt8X4QJysNNc/lSNWAjkvvgPquPmbtYA0BAkxacJVpPhPpIIRlzI++bGLKAyt0L+/CW6EOrMBQ+xT2ov80fRjL2mtVcLXtJmgSLyqlwyv0JmlAmeZidBlAq8wweeeRivHLlBvxj99SdKl9eoX0u+ONcnpcZr0E3FeAGavtjJanUru7RgeK6EefK0xr9P0IBCrkCHMKDhWfIEIitMzq4Ge5hVtTgd1NGm4id9vglfqF8zf6+Mx1R6wX4xEzMKKrvbf5/3vgV2lL7Q2ynvpSWBAYW1VKFs7yk5zNYFO8WoMbFGJdZhYKFJZT4Gltf7G4W2sWGDu+PyxvZgMNVzABsjexZhX1K16Z5BwWrcjw026D6Lsal+G5llzU9V9jmB8EHWyKAl3CqKPm5pPPf6eL6KQu9S2mPrF3CM1NE1CTtQ8pVmsIdtRetAdZpOe8YZdrQi8lrhRTElqV6bhUpRljDlRMZNnLqoDIlVhsnHxy68G3vHB4hrnfZBFLOyzfIrL7yjuNz2HXtyPaDoW/kGufdZEzqBaUPQzgaohWKcuMN38hy9Y/nzgQ8FUQTLDpvmmFqk0/+2HsW7SkyGRLAYTJyTyDRj2ajIO4SIE+YxQ/8EcBd+4T+ZsuUNysd+828+eAfHNZ0d5S7GkcokWdM7H/NZuOqG9s5Yykw/FxD6lckldH7RFC4rbY79Y2b65w3PDJ1YuioAXAVGoL2BjjwFUGR+cj49NdKmZGdfxlXsE8p0k/psQICDpYdQWeS26gym39L0i2R6OT9tiTjeOI13WktKBTWz7agqReN0uVOC9RA6pMhjXtE3UTCIJTLS5VPKMtAaG1nJBYEMJDshJCT/4841g6ITXk/Oh0UN7IHg78/SH3bwttyVjt5Lt7UwSckE8xOeqsmWMggahVZnBQHxVXtTNO1MFhp6faUv
 /Y1dWWyd
 0EbG9HlqOuUWILzBC6FqQZnJjnHvBxJRuKq6xrTttqIgc243AosLcUnCv/WBnTeENS+Si/TQBxgq0qio+6B4oprXmzCe3S6JHktWEhrXoLiQchb015b5PkI+XElpa+cd898+y4oNBrpGd+8gVI9uTq/XV5t+1DMo2eL8fOT6P/qyon3z36PADH8z5dELLXuPyjQc2aamn48U44jMzKicFhEDwppkmhUmu8zbQcWgyUdw3g87oQZt8VRayfN3Lody9s6HOOh6uCzCBp83XPtfEkQhjhtAHFtnrx+K91JofwlKDqwck+o2DItgSzEgWFmruFAPyFrBnyPQhzohdKABlx3DjkyL4GBtmk8ZGbS0pTMLTLHr6f9gfZfqEC48fRwn4Qwvv8ZEznxRT9il3fFVK8MEmLBaSDlyBavsBNlWGib8/FmQAQ3o1QI2dB6TleClxcYWyKg98Hlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no reason to export the symbols for these functions which are only
called from internal mm logic, additionally there's no reason for them to
be declared in mm.h.

This patch therefore removes the exports and moves the declarations to
mm/internal.h.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h | 3 ---
 mm/internal.h      | 3 +++
 mm/memory.c        | 2 --
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 68250ece4219..0c17f0932b76 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4768,9 +4768,6 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num);
-int map_kernel_pages_prepare(struct vm_area_desc *desc);
-int map_kernel_pages_complete(struct vm_area_struct *vma,
-			      struct mmap_action *action);
 int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 				unsigned long num);
 int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
diff --git a/mm/internal.h b/mm/internal.h
index 1ed11eaf276a..0cd26277a4c8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1511,6 +1511,9 @@ int remap_pfn_range_prepare(struct vm_area_desc *desc);
 int remap_pfn_range_complete(struct vm_area_struct *vma,
 			     struct mmap_action *action);
 int simple_ioremap_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_complete(struct vm_area_struct *vma,
+			      struct mmap_action *action);
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 926276d41920..448342883e9d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2628,7 +2628,6 @@ int map_kernel_pages_prepare(struct vm_area_desc *desc)
 
 	return 0;
 }
-EXPORT_SYMBOL(map_kernel_pages_prepare);
 
 int map_kernel_pages_complete(struct vm_area_struct *vma,
 			      struct mmap_action *action)
@@ -2640,7 +2639,6 @@ int map_kernel_pages_complete(struct vm_area_struct *vma,
 			    action->map_kernel.pages,
 			    &nr_pages, vma->vm_page_prot);
 }
-EXPORT_SYMBOL(map_kernel_pages_complete);
 
 /**
  * vm_insert_page - insert single page into user vma

-- 
2.55.0


