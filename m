Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC86CA5FEF
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680766B00B7; Sat,  3 Oct 2026 12:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6378D6B00B8; Sat,  3 Oct 2026 12:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520AF6B00B9; Sat,  3 Oct 2026 12:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 343426B00B7
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:40:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDCC71C3D69
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:40:14 +0000 (UTC)
X-FDA: 85281877548.23.86B1A86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E33A8160007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:40:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kuaZkCcn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=++beZBnVDw6Gdsy2YFA03hSf5WP5zFDFky+TMViQI3o=;
	b=tClOvS5b1Tn/s2vpgBmIE36qP/7p8nxwD3pgf29NGmhTGzAUA6wEW9DHaGr7IBcEn3t1lf
	TBFZ2VVotS1Ni/d06F0eJ1Skh0FFZLq9uatr9Yd/Tg3HFZHIVg0s8MNHga19h0NSrzueKN
	fllkZaooPyJQZVV5qzvLCKrevtZ0qCs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kuaZkCcn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045613;
	b=1XryTxguPz5yHJbL6ATaSo9JZ4AeFWSgOyGcNcJ7JpqhiYuVFkE6Fvm5WAZWScGHwsm5Es
	qilgRWnLKSdQkpCYDyCbCVphah28ESsUdBZ63OUwWYLGO4VkuRY/cITeAg77eFCIB2IxDW
	MwEDmo1yFGpLGL76cN/rIklHqVmoo9s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15B6A41ABB;
	Sat,  3 Oct 2026 16:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8861F0089C;
	Sat,  3 Oct 2026 16:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045611;
	bh=++beZBnVDw6Gdsy2YFA03hSf5WP5zFDFky+TMViQI3o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kuaZkCcn4/6Hf3w1CCvyvV9EywQTIH9SvrS0fqbFcNweKa1EqQX9zkTBpYBIO6R38
	 6gE8fRCb/fKtaxNuW+ZZQZ0v9kP4na7+sF5qysSPBNLUO1LRZaqxD0EPSsMNqoiKpn
	 hvSWeYScJefhxBWvQ+qRuPL60er/tgzvx6d9M6/4O2voLTQugccgsQhGdx2Gn+OQse
	 9qUmP26n65Xhld04TYdVEOD4iDiTzS1dyqqKbjIim0aVNqqEjTxrTlLjhWjuBkP1/6
	 jFX13jvU+HuR4W9WBtwwh+aOxqbTfnD+A9+8yhK+ZF2g5HrYE3tIEQAd92BvMyuAZ0
	 SYkXfkWuDjuGQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:51 +0100
Subject: [PATCH v4 20/38] mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-20-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1324; i=ljs@kernel.org;
 h=from:subject:message-id; bh=VtGizrlrfSqF6kXUF+L7zJP/cAO32l1luKa8gsJEK10=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mkecDhyc/mG95lKcoUrXb7NlU+ofn/O+HBD16ysb
 uWTVjFqHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjI1URGhu8nONer3l7Yl6C5
 y321yqVZ/6KELx65eGb3ZtFV2xSnO+sy/OHyWVcnurchJ7daUXKN4Zrbno5/hR7osnv+aY26/dc
 tlxcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: fubm7u1p7phufrttdabxiotxapaeg74n
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E33A8160007
X-HE-Tag: 1791045612-822758
X-HE-Meta: U2FsdGVkX1+hItv9omwooSS/JEI3MbfwVVKrrVNGXa1VpPtvy3y1wOS9HAhlj1YXBar43TtiKeA4v77ELxWCByZt88ksRmxxKL/YtVsY3fYQjXZndY/n02gmo5LkFuMmPwnW9p+llgGx/UMNpnmeZTt3OopV/wNp7Lbp5tfGX7hd6RaifFpp1Vg79yalio9JdAtrUxBM+iYE6SfIhL0DvJ7i2PDX7CdRPFI7nOYijHN07LgHd2PIfu4eS6B/o5FkixQfR5zMKBh5LQZeTvkkY3rAVdnbgi9SKa0/6PUuG0PSedW6X5md428LBrtn1CISdvyQi+tckRXroC3R/T5aP7Uiyw5E+yMyy7F/nusqNLLP8l3GSZrR3soQg5B5NPuEPj4g/HMaUYVA0rLXH0QhXWdqoIeOBFuhyxBjl+X6CbrlmdKT0WrirQ/0n3EgJGtSLMOJhrOu842ukA0tv/6iiOybd3IBcPjI6tkS8ZL3wJmTywXoY5MyaIANT1othMLf5Pna8/rrJ9kEqCcF3lg4Vi6uQB7sRjZYFYi/A8E3xEGWYyQ7N6bvRDM/AZdAao5dv0JyF72uD//oIo1avaA85vcVOS32hGJfzGJmyxGAhxi5jnsJXkyJKdWbCODCYpgHf9A7fCS7+mL7UdtdxngGovCazj054tb2WqrrAMrqJ8qQce/VHQakXUH0Zuw2AokuxjBn6voy2/f/q3TgonqqrO/IxJHnWgm2C8dTMJZcOEPHQfRecK3nvAJbbsN4JpDY2E12ayS/BVwipYJx4BmlkX2my8ypi8fl9PDcOpgqhlvpSJJww6j02BlZ69BEiPbZfoS5Kf7Yuq31VKNvY3AohojGqQ3jigMhKrQF+jxkcTJhS/iKsTavhqgeYzfY6g5Jl0d64NJCiP1tAbQ2Jv6sapW9cYcPbVL2OA8abHcUDF64icUIIXDY1/5o0QLgcAwp5S7R4kg/I4GM3ZjOkI8
 QY65qdsK
 LX80cYpZQ69vDEu8fhE9a+wCwfnjEWf6NVpiKvofMmHOt9GJG2bkEcKVQYrqBJXx6WkTelbYQlCwzc5DtErxCPKXhnmdQlTWTGt+Fs0aU2eWzlwZKRdqQxG+9PPyj00OE+MyL7jcjswlIMdr8wiIZtEjAR2cFmttXzGoqnxGdPPtSB+AU0L+NnCw+6biV/TXfh7uHt60uAMvshyDnDzaOTO5i6TKPsQxpyviG3wR345gYb7gJXJc1EC8q8iUvukBc7I6PCRX/tH8mp5l9VtzQntWcabJdwCmhGaOkFtZQihRQzr6zXdQkvEk8uRGXplD16vCJAXIy3OvsJrXpkb0JW3AbssypkvXXBSOtzJiddINhdd8UzMgtIOYWNPFg8LfPcd4sphgJo/bASZ9Fl77dfu2ecuzMKllc1K6CEw0PEjRfeE6kFqp4tB9kxyV14cO7KK6Y6eTljMkEazvN6pca13gArzGeKNHq3pS9UOEUxrBCeEFiTU7xZmlCvJRu3nf6fWqBvV62mZKNTaUsFUI515gRtSKbeBSu3OTAqpwwi0rTTftbyAa8K9gdVy9pTCgY+kdaTSi9PKuOjtC+tdvrzp5UshxMiGnITTBTcwrGktMh2yxUtfoJev8kRImu/HOq0NRFekrWLpQeRHaHku6yaZq+gpFIxZTdqGeSYcx49++Y/TM0a6Fvuj6N26OxHOhrsN4KoQNoFX57BxbGjFpA550tfL+bOc5hgtif9gNzgNyR1R/6z7eO2pxCEgCQAymwrmFiJKXXZ1fETdJBRjwqDaVdckYWHupR48HG8+6Q0ccfMsRmMd2SvRxLYiK3KyC1YuR8wazj1CcHt557S6iJ29IX8xLxDErCVwnkQk9BMlxy17W6gkdCSAdCDm6epsnMVr+LobvqDrfSWJfzdVC/Azd7RlnZ0uG//PJUaf7YR1IA8BZl56SwqPE5xUZR1419Zv+4NhgUh0JgMRpRmyJlRr4ngHnj
 wErbUSEE
 eF3YGF0EitsHEDZ4yoNUftAxx7hRcuxpGYjuw6brvbj6kpUm/27Fe6wRdERdDl/vLS6Auoi20GbzD05Nc87pm16MIA7kwFfFFJxY9tZcuHctG4Uq0j2uLUZ5xCozNYfSCc49Ha/EAvHI8l1QUnIr1erEfQK1uEABRS7T+Wf4ISYkYxNm/vxP2xLb5iWpGICJNqxSkHj1bKWLZmisd6mXZ0VlDMxMJL6ppTmm5IosNYv0k1IRr/9Iv92M900nJ+hhwDeqHgMw+Hhgb9pSZvS4sYQ/3hDQE54Rp9nL96+7QQc2jveRSErOLNOdWyddmo8hdkkurQbdzjdsf6YgYA7/3uKLwYN1iwTNagw0VZttKkucJYRoeJebwG6VvmUXcvZ+ebfqSSVLkl02JknoVAhqPXNnIREwOZ9ChVtyzwNX40ngsIuTlhOlhynXQuNNo9khRFOs14e98U//uaoA5i8gEjK1hGIEZs5v14zb0DAvfJqU+E9qAi64BvEGq8EqJpZuWSm2U6KYQWdn7Du9+bfpF4kSvqFLElJOJxZU0SZMmXc9OdpESV2bqVUFObpim4fosqJcoANO1DmavhNkR07085Ch6XrezKpdNvyfSeeLv4XJ6LzrQeF9bUTGXS/WgGmNJzId//YnjlR02LcW5AMUhvsZys+Kw4OzW6KPkCebl4O3wi8m8F33vmgN2pnGU5vix4Kl8qmFjMFfLpTBp10P1TVVhOoBhouf1oc6oNLP9Raq3FpIxHI9oSvPMrX3QOZrn10JeeZhIdVOWJHGBbUy73iUjeyUxJJXyKvnjM4xbjcro15tnsEpczNxSASo3RZ9Mex1HSH4vGejZQa2tGq3ElsUITehWROfnLtzq3FUvbZIlge/M2mO3UZ/aY5/GN1TInSxPQAEyYdpNUNmeE/k6nfic+e+mGAsu4fFO6ve25JMRzexFjPEW/s7b6I5jLPR98k+rNcJ5xZq177FUI4NqoQrD72xu
 j8WQTSh2
 vXfvy1sK0+dt16hQiC2RgqH5+tgPFIiRvrYduhI2t1pvedEJjqdqqAe8hMHCli4yOwWmhUQbWTk07tixaPrk1fOSOuXiGVSJbfEhG9tsGzAXEwMACWMyewvswpltP9NRjA+ssikUksNLPuPiwuJOLvrBDxeg2IZ16rtDMAaAeELz5GIuPzUDcwxPLWlZ6ceEYE12JLvLebagRowbELifF9lXCRO7p3hfo6hHO3BEO/GUanRUgAnbx4Hij2p6KSXQqFtXWPfq4HPrxYLPcqo6Vk06CGtf+GVOZOBNlu1R88HGZxlq33BIYuGIIRAa9CUcHB/01VpltSHhFy7lknzgd0fg5Ai0+wf3MOCE/x0mZRae1mo3tvu/XzYNVwPeLVAsBSGACsiQY961KV01Wvv0lHtVBivp41by9vQOLF8iLCE7Ud6DrAkVR3UEMkCLzfPw/gTmCt5U1xsIMf8JFqRNf+FE+MSj8uG+RsrlDSeo+2+0LBXdwfeMdnaz4KBXKItImbyZRfjhz5CVyiyQlpMwv3AdytMqQMCEcMjaEPII5Tt5AnX2o4vd9p9h1/UUVHMT+hpcdlkZxlGEmM8VZR0AiYMmQjarBfTFtRNQsBVrxhZ9X1J0vTTwl0rwH1JcyKO4A8vuVTPoGWOHLpkV3dmuOb8yGnmG3yZFqrhhG9vQRk4RN+hukLLaFCbsHrXf3lBh3xsouysLAv6UCsbE2XOrbqvTBefMq82LctRWAdnLHMj4armIhyX8JHEFMzwltHxPO3U1zIZnItxegYs7WT8atRbEnxcv4QAJ69DeVcbQ6VWgZir3YEU8lHsw+ifXFR9+EpnnxoG93yfDSTZbqcEkEPOEZS0h0KRU7HEZWdHFX6KWilrlyHH3/wXqxo2xJJBwUJT7u5EVixNvJ3mY2A1bYbdeNKF5QPgJaTTt5008vEL9ZnqAy3PaWMm9t6wHWiuoQ3iRBTs1t3zvTWClSQh3kN4el5ucG
 IVI8AcGn
 7OxuT9Zy7x3Yf4rnMCqjUFprmXXSiNKmMZmJBU1uHLsvIbqFJqF7PcjIktex3MmKTBAUKSVYHT488cnSeUGa91kleToeTKRs6igw+Awc1w0TCQPnG9zDh0qgBWx5SFZrv1jy1/8c/3OtZ/3i1QcmWXJ8iOM4MsOpZvek+B22dIlCq37DChxg9sL0sM3PdZFb+WxGRLJYEAC/ZsSuxG0tJES2btaLt5BS3D70WrW9A1qCqGDd7OAVvGylTPnGVIBE760Qqc9vs6BJWA4BWWaaOjhMjSxf7DnKkSFVQmbwZfc3BAWk3UdZA5tXVPenkR3JvFFS/TefO1ibO1bQd1cTCcIcJkOARx0mgLD1pcmeT4hel+cKcbKBbAEJhswGKEXzke4wpLK5//UxL71AXBTTsv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When populating a VMA range via the aptly named populate_vma_page_range()
an unreadable VMA will always eventually fail with -EFAULT.

That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is not.

All user mappings always have VMA_MAYREAD_BIT set, so this check only
impacts kernel mappings.

It is implemented specifically to disallow population of uprobes XOL
mappings which are exec-only.

A nasty interaction with these mappings may occur if they are mlocked, so
actively disallow this early.

This allows a subsequent commit to remove the VM_IO check in
__mm_populate() which otherwise requires non-MMIO mappings to be wrongly
flagged simply as a workaround.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/gup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index c2dfcb4744bc..e6310a7cc05b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1836,6 +1836,10 @@ long populate_vma_page_range(struct vm_area_struct *vma,
 	if (!vma_is_accessible(vma))
 		return -EFAULT;
 
+	/* Unreadable VMAs also cannot be faulted in. */
+	if (!vma_test(vma, VMA_MAYREAD_BIT))
+		return -EFAULT;
+
 	gup_flags = FOLL_TOUCH;
 	/*
 	 * We want to touch writable mappings with a write fault in order

-- 
2.55.0


