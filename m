Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03114CC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F956B00C9; Tue, 13 Oct 2026 11:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F746B00CA; Tue, 13 Oct 2026 11:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7B66B00CB; Tue, 13 Oct 2026 11:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA19A6B00C9
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:18:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 249EB40D5F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:18:08 +0000 (UTC)
X-FDA: 85317958656.23.5928A35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 455761A0003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:18:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h4OnB56H;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHENCFhMeiM35hbKa/gacUK4mkCc1cQaFugTZwzBT9A=;
	b=tTG+IQBM0sO/H7p42SNr3D7EZy1CQgs+Fo5jlq1b2+z5PYHxIXgshz502DID11kvyJBWBE
	1lvpNSswXxZrPuyNDQuG0i75asalAA34PFC6bKzZajq0k98deGQVC9OrryX08bsyA6zg6f
	Yy0HKFSXtv3TuUNVYuW7TcCUtTt+vZQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h4OnB56H;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904686;
	b=ZvievMXnoTsZ7WwjU62PNKtGJwv8r6FFAwS99Q6tdBm3NlFw5V9UnPhuk+9zIh/cny3UL5
	QWgaS3LsmbKv1J4lmS4z7PsK+4lCtSntHxoUo38F/gUJmJdncx9UMVpaQG02Q04BJY3n9c
	WjAm1xxYu9YNenBfo9ohsPZEMzoGoR8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4069443459;
	Tue, 13 Oct 2026 15:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2681F00893;
	Tue, 13 Oct 2026 15:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904685;
	bh=pHENCFhMeiM35hbKa/gacUK4mkCc1cQaFugTZwzBT9A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h4OnB56HNjeqPiEOGE3rNlLUdEuZOAD+CtcGMRQAPmTJyATYJsOL1G7ptKcuCYpiq
	 CpgHKGtq6CEcFGtPgneSlzABDdCg4Bg3Umhh2RyNv5IhvulgPcdL4E0gc7w/lwsd4J
	 3ok73kC5oY5WBtHUwRiLfOVYbYL9SHUBU0FiaPnYYxZ3Ft4+OD+ZX8V0vRxZiMbA0e
	 7mrjljzIeRWpoZEwnIfWWsSpm55O0FMF2MjO6qTGymfS0jQMAjbI9OveshwJqYlz4+
	 6Oi8M73/28zKVP2Op5lc4WYCbc3NRmNQEDE9xnaQxhB1kNBr+EB4pIgYviUKddTNjT
	 g/T0DZh39xgUQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:03 +0100
Subject: [PATCH v6 23/39] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-23-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2841; i=ljs@kernel.org;
 h=from:subject:message-id; bh=nPlKMcYR+T3IMNZ+qaC+TydVGS50UMS+5z8Z7jsltAA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZx61nSk/PyGGTdNPBz2/bnzrll59w6V1g1HrhYs4
 t62VJDPq6OUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQAT6fJnZPiXFCuryeMhaBy9
 c4KWXPbVGV8zMrbf+bInh/MmZ96u3GBGhn/spsc46t4UG23hPj5j5S6e59G3sjIuz7reef9SAJP
 vDB4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 455761A0003
X-Rspam-User: 
X-Stat-Signature: ec7fcbhuycjfdtb85nhdihnnhwup6tha
X-HE-Tag: 1791904686-548714
X-HE-Meta: U2FsdGVkX1+lYm9aS6drsmJEzkyv7G4kV0v/4Cbds85Zszy/NqrP3UflHjm83H6cxwk32C+4oxS0dJzFh1ubdcKwhwM/lo5teIctYYPUxLDResW4EJJAbCmhwVNX0re0e9hgS9P6eykxwP7qWMGAix4ozJkbSeKIF6t4aS2UmnohV1/maXttLyD1RJsUl9TIq63WDkEp+Bh747qza0HTWlAIrigG4JIT0oIih1+wUXduHGXekXe4fVBgVgfprmOEZhroEIswXRSw651qXCdJZnKnpWx8kQG5PZqu4FrAIKiqnB2gJJTEo2gO59F59mgo1KDcJjkU62eBntc7VJbhpdfgCL6g08K4EmNrbVtlT/9pxUbvyJXM/igNoNSobddKNg/GtK4xuMSJzqkXstuZod5rW3qCWNtuBRT0KX90MJ8em9H0kHb3YHN1TtUmR1VdiXJgiC7HEeyAkHIh7tnjKRSMmAkibnRmGapCsKw+TNtlXeMGhEt1/XZs0RK8yTCF3WHfD3wU8R9xsL/uhyK6aVxee40qgIhM4argMpLe2sXUmieTDdxF6bQEZDe3h7HTphRWmwMrpv9qdgMuWU6Ah9Mt117Gv4fiz0OBsOb0ZlzK+evC2GhNC8jFTXWIVPsY/nwoRrdV4clzUb3nDCD5BNtRkSgrpSPYbaO2EisQ+plDrTdy9RTSoamS99LwZ/7yUxyVZxtE2/JnoLiG918oZiaaaxXsxXOnirBwCQPEmcOiRR6umYYgg10z27XZiW774n5U+2z7ZK+7wq5QBpSPT/46fxnArHVuB3p6zmXYX7cJveFU116ATQIOf+9ppIQjiE8FcTmRZMoM/DmgGSfiTR3RAnGFDkCzVAJuQQDKbfdIeY/5JE1pXn2rghiP7FCLwO6v++Nzmt44xLbU3/D8fsh63QOCOI4r3RTrOzZ+SpMemM+5YZj9zSVndkN42f8fZZ4Z8c3TcEBIO+Uf7WG
 ko9EcOig
 VuB8ZlCKK2eD510ugWm5N/AFLoeUgYgsFO8bbf8jzoBA3GdKvOIQqDqPZKSsl/G86ex+/TWphDWSMg8YyYW3rOHCchYFgFM3Oe6i0BZhB5vv1P//U+vPncccc9u8sVJllsXlOK9UPfSVZelpZ40e3QlMqMdn5um8MB2eCU9xWc/M2qBfekvuP8IUY9v0zZEzDQKr651T/qeYd30Cpk7LTkx7+GBbzI2S9At2FGjqqRwmYXR4qaSs/HmDxL39T4cXzHrEHgU/CPGfOFi6Flnt/6we8EHCPJXa9oD3BE3U8YHCIIsonHP943smf8d4bH3RV/GW1uMKotA0S3cbbIzAKwto1Hxx1qHJEKU3Z+98K90rjw6I7ycXMq2xSRt9NmoQKqHc+cRPXFnxxSvW8PrsybEU2oJpV2NcfJq/CKQovfQ9wC9dznUB6rEQxhac+A5wMO6LIc/jXiL6Zb8gDblmmTGk6zV3Wqu1ryyjzKi1BxumY2FWEtgl38O9YFyakRGjtTSYA6iDENJ5ZWWZRwfau2kv+/M+0CxEA2SgfmZELpTJGaStzUyRpBKlnCqxUK+zWkeTlMSRI8lDxcZ5v4ceLldh8zCqIAx52LR43EihNOK+hx6HZRxshO/Vo1Ww6ziGRw+PqEge26d8rswVdXEEt+B1sEtKcTSXFomWB1c8ByIc76PWrZhB0knRY/qVZC+rBfXYr7LgZoKZDfSdmW5D/N8Z18UxjrHg0HfGOo3JIH6hifSsTp3KDQ2fFC6g0/lzZBIGO2VeY3xxbXRuuTVQCPE2OTy1o5zKpFv3yz0oCtFYwubf4NnqDdgVBlWRGGbbKQbuqSIu35s2kd83nAdXPccdfftjUVyAMBZCc/fmhxcs+SRGh0o7xTZ43xTb3pZpbR8H5G7giulIvd/G7zpwAGV/Zf+5p/7BT4BfOEq97E4a5ZBGAecUKgwicnnfeNp6GN2oOX238PGqMaQs3/Xp2Fi3QM+Zc
 t8MdZ+cv
 fQ/f+4y2VsbEpPnV/UZ22FNvSCfaZJKzn9gwC8m1ZdpaBj9k47wOlLKwwnjV5mOjum1ATvwHOJYP+skd/8CCk4qtFlYMyXN77RydWbxftWW0KvMI6q4uHUhDFMd8nWOweZ2hcBLsMc8Gfnpe9qHWBSK1k/5Fl+WNZufJLgUjdYk43+YNPHJH0YWkiBrmv7jMJpr810/Ya7TmSNGQsg3DPzdNlpVDUaELwVNxTah42JlMRr7D9SWVAYjMUoOT6Ec0sZItIWH/+lrCErjJk/nC0yo+hHhTSd/zccnZiB1OYVEMoU0K1K4XZO4RV+8nINr2OuiJbJm8fQfSorfL7VMbezgGFDIlIFH2ECKFCLAQkT68EIjUALa7QITkuMtCXy9oOrpbmi+/kK0pllKAZVruixvkariR6Bepu6xNBsR9zQS6L1kxt68SWyTkwK/DP2UZspPvxHK3lXbzGb7f7cg60bx1hiooVjhKBd+cixOS0gh7TvkbR44OfCUvEqlhhB0Xd+Y6MLtRpymLazY+hOy84Teqj51Mg8wckxDGSgrL3rapVzHHHxlt04G1wY1nLL1+Cv5KNWDBM9dOp8ExrDufTgSOw0T/tnP2Je3TdVb9SRtmuOJr2Sm8DVPXXSU7Dfmb+/NhGVYDu+bpJoobi2Gsr+QYGZ/ZmLEvGgoZZL8hEuTOjlojvzxZU5rejOdr0xQQ7bVetssAyR/LEbMGnz/kEtc7lPiQ7/O0goDbjDztZ1x2GJOF+tf5D6/6XIy9KBd4Za4OGzCBmUvzDwdKhvboNMQaM3VXidNSfQZzKXZkCaSqXMWzdKEHd0BOAHXL4jf/QuJtBTWEYQFm/iFtmYYy/SyFU9xJ9Ignwdg3B0T2khXiXb3X58A73ZZAjf1sOCppAZ4r6nLXaD1QwiO8b9S1f95OPXYst32fVdvL/FWReUk2AxwPWZjtni/+P6E1G+qFfYCcrXygbcG9fyER7KrHaG98TQTk5
 3iEDHT81
 1MVsJFRPgLKOrvA/9czFTpkSHjQQVJpDv9bQPMSgYgt6xrsruxHPJ01ti0FgzvJIEXou4zWOZeySHPE0mXbX9itM8R/GjmNgDB6DABSWdua/uflZZ7+7ZuHbgB/sEhSISaZlJCQylcmTcu3iIzVtYnkYmuvHMFJ0qaoCmaFdNCAtLJdfKrTTTFwLxepLy6QbH01CbKZ0IMgaHp4sKpOMzyFgTHIuEpiEFwOFiDuk5lHNSvCY1Tsd0SI6tDh1PlGKp4R/vSOFRuIUWIS8tnudZNYGrZLZzYq56hFHVeu8UBnViWkrxcm6AsI1WhE9g/gULgHRJxIe4mEOhinFeUOJYsO4ZMp71s31Uot4kKFL3WAgjiCO/xpg/Ry6pFFgA5j/NLNqvKqY/Hg5DSZrdiMLgGYWC7Uu5WoaAjyHG2u1gx39DcbM9TyHBN/AnbMWc45Dw/P7l3jvVf/Tox4dnm6epZ5B3xT3BHUhrjLMbQd6sAwfexDbis/WqzyfDDK7Noci4KV1gPUWS4q9T4eDyMSVf4G8uzB9Z339flf65sJx3O80ynbmnCTqAOfIogPnIwNEYtYsq01nVr4v2VkZiWCnC3EqpquaCeS/fcz7ji3kMtxzl56k8cySdT3FdBgAkd5xs/o/4jRJZa9lihv3Oy2d4ru23XV2n26z81oLiphLO8qEwLq6vKxHrXygUI2T3zLUWsGqX9Z5WBvvlmUHYsZUh8EUIQjfVIf6Aji663hrCF3srUxZc/8w1v7eBOHgg4LOETpC6xuQ/i/7b1YSH3rtYw5SImUIEH3f68/Ih3e4eSDUdVTU41fBzrolEsoPZgS6Kk229byir1tKgliP/kmkwhs/8po5BWrp9Tm9Egi4m6L/Hyff6cPR7pGsRaJQgMKMQBD9ld+tD9apPidUXd7FeIHeXw6oqum8VBGMDxNcbmee4J42fHEX99VqJG/CLNnEw3cqkELd0loEyCqS4bj8oyxD0yy6U
 ebz0c/0k
 jnhWswl+bp5xWBA/gbhPzZflXLVF7kLlU0RzbdBteCZEYOeCp1PPS0/pjjc3Q1IOsyP3w/ec/p79ipBCfwbYhs5Mxxdil0Oy1dq771E0M+eL6nLECe2mY/wHveTOoCMmADPYgIOwm552UqkC1R0WfjDgABNenFEraI279XpsZLrtKIuMBep2a4byKz8pnl362EigE4F+Vj626xO3PY2VFsmqxIh0wVuvX4iG7pWwqWbevjrFqoIxnP3Rvo0+7zQLDk2Kx+81xwODfY4thvKwcpqj/Kl/U4SCZIR4XztEx3HLDQ2R3LeYLxr7pkOCwTdINx3gVqhprhuJtoewMdbI5NhrxNITusFR7cUVDkVRcdgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently there's a confusing mess around VMA_LOCKED_BIT and
VMA_LOCKONFAULT_BIT.

It is permitted for drivers to set any flags they like, with the VMA
already possessing lock flags.

This results in the absurd situation of a VMA possessing both
VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.

This has resulted in mlock_vma_folio() having a very silly check for this
scenario to work around it.

There is no need for this - just clear the flags before invoking the hook
and reinstate them afterwards if they are required.

Nothing relies upon this being set during the mmap operation.

mmap_prepare is unaffected by this so requires no fix.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h |  9 +--------
 mm/vma.c      | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 557e629db8c5..4ae08fedffff 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -970,14 +970,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/*
-	 * The VM_SPECIAL check here serves two purposes.
-	 * 1) VM_IO check prevents migration from double-counting during mlock.
-	 * 2) Although mmap_region() and mlock_fixup() take care that VM_LOCKED
-	 *    is never left set on a VM_SPECIAL vma, there is an interval while
-	 *    file->f_op->mmap() is using vm_insert_page(s), when VM_LOCKED may
-	 *    still be set while VM_SPECIAL bits are added: so ignore it then.
-	 */
+	/* The VM_IO check prevents migration from double-counting during mlock. */
 	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
 		mlock_folio(folio);
 }
diff --git a/mm/vma.c b/mm/vma.c
index 39ceb03023e2..6cfda4575997 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2607,6 +2607,11 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	if (!map->vm_file->f_op->mmap)
 		return 0;
 
+	/*
+	 * Driver-specified flags may make the lock flags invalid, so clear
+	 * VMA_LOCKED_MASK and reinstate it afterwards if appropriate.
+	 */
+	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 	error = mmap_file(vma->vm_file, vma);
 	map->vm_file = vma->vm_file;
 
@@ -2629,6 +2634,16 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		return error;
 	}
 
+	/*
+	 * If the VMA is still eligible for mlock(), reinstate any original
+	 * VMA_LOCKED_BIT and/or VMA_LOCKONFAULT_BIT flags.
+	 */
+	if (vma_supports_mlock(vma)) {
+		const vma_flags_t mask = vma_flags_and_mask(&map->vma_flags, VMA_LOCKED_MASK);
+
+		vma_set_flags_mask(vma, mask);
+	}
+
 	map->vma_flags = vma->flags;
 
 	return 0;

-- 
2.55.0


