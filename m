Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E4FCCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A53D6B008C; Mon, 12 Oct 2026 11:56:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4565B6B0092; Mon, 12 Oct 2026 11:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 344756B0095; Mon, 12 Oct 2026 11:56:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6726B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:56:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0D24A9225
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:56:20 +0000 (UTC)
X-FDA: 85314426120.12.22257B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id F38F12000D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:56:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lcCuIdrm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791820579;
	b=bBUNUk7s+3tahcljlgO3DXRsmxGner8NuQo9M2OnBgjfaEoDmw8mtsL42/UAzWU38GbE9N
	QYq8I3z5l3nNEhNzofpaYSNCDKGXsGqHEXovAvoAddsoZF2cPP4a6DkfsifM2wc4btvnRK
	dogL2y5Imi7aNW+3fiaYBmp847IaLik=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lcCuIdrm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791820579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFbms1O2vgiDwDr5XNy7hfOQCE1GiDGN4QD7DcgiMNU=;
	b=0/jymsy0ZIOkMoTwTUZesiQ/tVUTRqT4wXCiOEbQSJYdKKLcChhbe4yMA5ego49URJrkQS
	MboBjjywJLFPZWdGs0JQj0tlLhwNRULrsfWi+D/sqXvfs6wp3ne19noPESCzwrZrpCcBIb
	F3sgUPRPLYNTeqSltdiSF3ZW2HoqXbw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEC2B416CC;
	Mon, 12 Oct 2026 15:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCE21F0089B;
	Mon, 12 Oct 2026 15:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791820577;
	bh=rFbms1O2vgiDwDr5XNy7hfOQCE1GiDGN4QD7DcgiMNU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lcCuIdrmMQTUiPwLl5e5Z+CrC201P9TaW7VntAlAQ0wuTIeWArybWpskzP1Cw5dV6
	 ylJBpTsnaVkD11Tx3RuJLQfK/a8MthDkbqh/N2Qo+NL+mbeJ3F+l2nHLzRgl2fwWrH
	 B2VMH6xZ4mSRm44O1aVrnpq4KXOYj1KBkqJhj4Zhsip2ZHKhYDPIEZ9S25S3KUpDrh
	 0/izKAMAcRM9eWvuTZfpYIL58pwYVIybump371ArBjzbMrNsvpmDwuL9EdnDMlpqUp
	 x6n3EvLO70LPCbwLxz+x7mIQrXQvvZz8TgmnlRpMjxmuB8UzGsynS78NvOMo7KMLyg
	 CQyvIZ4fN7eXw==
Date: Mon, 12 Oct 2026 16:55:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Bert Karwatzki <spasswolf@web.de>, 
	Emil Tsalapatis <emil@etsalapatis.com>
Subject: Re: [PATCH v5 13/38] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
Message-ID: <as0Buhi_-VCC7xLZ@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-13-923b70125b1e@kernel.org>
 <5b8ef0ce-7429-4d74-b4da-a0561c59b1e2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b8ef0ce-7429-4d74-b4da-a0561c59b1e2@kernel.org>
X-Stat-Signature: aim4me55aeg9qseyqued9km7du5dj3pr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F38F12000D
X-HE-Tag: 1791820578-165789
X-HE-Meta: U2FsdGVkX19XKly5K7HZT1W1J84XQdxNQV+IhIeR3gKF0SiAP/BattK7aq/1ccc6E0M6HVGyMEo/b9Lfm4QxZu5j/cq4343GME3b+ZWZsdvMrBkzIEF6qv2Abtud20OGYbr/EZCIftiXptbphCzt7OYF7/RGNeehGR7yh3HvlbtDM0phuSh/Ck9/TB0WFdU88N0R1v3JbqGmvsv5mAvjQEXNVMyKQ6z6ma5llOoTAKD/JQ9YPEwlZIB/n6beefubaLQDdK9ccBa+E1c4HLdTQayiJo89Lg8ydExHcSOHw6/qrVgkS7Jgt8U4wA/01TnfoCl819/ttaDyKZ44ic9bFUxhLdFIjNKFRyXeL9UtMYP+tJY+Mgx+p2UaLUvmDK9o9Gvc7B9pWrtnbInScenofY/aIGbFU+y+ZyBy2W47zuW4wMCBD1YdBZQYmg1064uZNusW3eNHHmNT6H1s7nmpaihkJqIzGt5yTHDzR2h8Hw6hLm9WuDi1XqklE9Dh0Fhaw5yVtK43uvSbProNYl/IdWL9/JFK0BZWiWkzIAQ71J7dlNoSelxLU2yFSybXve2fbWCSViiAWVUgE54c6lUHrZTMV6Hkl2zjMSJzxyFLaYojlch7l9yGYpFCZBalwwn5hP0MY+fyWj4L90ZUuHIJTAxU7cs9/kUQQdi+TqFrd0tML3gM7JvMQWeXwxJkpsy17xl8BwtxdDjz0I+vrACYrsPQHT8DzxkhVuyoApbyUFge9stFQbUtMJ8ry9KVJslh1P5bk8Q6ElruxjDaq82kBnkoFiG+MI0FM6d6tdgcRlrwSl6q3t2dSddX/rbpJHfMLA2vTyDOxqsGi2HdM0gV7Xp8t8aKfELYMDpMr6GDJyB+ihbNjsDI69srABeLSbApQWuNlgGOF+UzsLlKj95NoOKbDUrkxGxmZSDI6D7iYWaxT2K1c+88N8er2xKj47jxUyJicCArknMj8VDLPFw
 onJ3sfIo
 42tjMDvsGnqEinFD9iy1sdPAr92M1dd8fSpWGJ2bRl+B+/4aNoFzHQGEEQZfHDTKTj8NmGie6XwMtJapf34ukG69DuXflMsTlCYDrjGRWHGHGfF1VBTGRNKr632LgCv8qkrOJDRtRP+rahrFhtEXpqyWe56ee0N+z0j7/+1uuGFocraNQQoYHGst3SywsgvLCIiVGUFCld45KfJy3Ew1BqRSv0S0PG4v2HoaTECEk5h/zjXSD9EPG+MwrkulTi3XW1m2Py5T48oNm1oK0aWPnDv1CiJVymy7Wb+9jfWxkwhplusKacB5g45p7USWGyETFhDcSZ+Qpt6UyZHdWL+rcPqRqN/sWBanN4p1LSbhF0+bV8QaKyPAybzT5Fc5thNSconfiZ9wdxTkhPdAPNRzZ7TspG5eHswJ2X7akMuV/0dCqb/ldcmCOxcNkx2kNxzlykdzNQgsKQkemazZGEfgE3ml+CxLf2s/oxTSZQXcB5Wo1/+SODwx00l3KyPokdP6Sa/psq0OUe4OM6oecKz2FN5yUxzp9z0s2WXNF6Z8oUj+he7rKKFSSZAEWBiy+a1loda5uecf/Bha3SLlTy1hpF83SPNaCeswKWhHpzhmRArunlzi3ohULbEM7e5SmLYAmtpr3d6c6Ys1256QgzOczWI+hVOryo1Oig1TtdNvDgRmYchMuKOcLlKHzA/AHfOkAW7wg5hrW2XBZPdl9FOaUzb+ejVm5fZ6du67hKddsZQVPAvmBxmI0l61kihJBLdi6LBYHO2FwvPkP+OTRLu53tyAI1uX2LKeOmyWumfF5nvqgzDtzOfSCWhf0HbtzMiakBGnrWej/ASbwdzNWaHVW6TGYQmpfNrbIqe4aps3SzDX28Q2BOigrmb0XfREYNwUSidnNbWWy6Mkf6ciQZwhno0Wv1pCnbybeHVi61NB28RftUOO0RCUn54INnConZzppPlSOfu1uG1UhxlBOx59joUvfzF7N
 DaVbiXEL
 xTAz7cWt7wBjF0HWupvrlVNoZ4JDHKZrK3k4G7s7ZGmXl4UcfWwJ08JwGiaguMNYsosp8AwkPzMEoGGPzCnC8Z3mJjnxv8QkGLKwIlhZE4gz49p1+EwbHjeFr/HWG9Rsa/zz13FwQ+XEBBpbnkeKHuD9x1lmNGxF7SlWvLTqDc9eiXkz7VW7tZgLr9AIJx/jmI3hwu5p+tRqR14c3jVMY8y3utcrGvXs87MKQ1RwSOMjuWttNhIwCZHwtoQaTF/qva1EsIuEDQTP/lSanIRbeXi1fh5A76hDdOOgOBnGCN77h7B9AJzJ6XSpzmn2Y2vU/za+vqXMc9oW/QxdBsLgoWjKIHqrWXUyQ8rufEuVkksBJ1KcaFwZuORlVzQdkMdlYWlbeG+U/lHQtuPKa8c3vbehW4goJ3gy4RcWXT5JSsTP7N4I/bpXkP5Ix3PYbYluNksp7l743FJgOnMruTguQSyaBs/2i/WNYUbcRMrzKBbclzO5qTaUlukz6irtuyaOP5BjnRwiCjgnDx/C+xTGGlm71H9C7eKCvf9XpniSqAvSwlTQ0EoNM0strKPDHidfBrvlGdg2NmLvx6zn99zTEVgXTzktdoHKku2ycYQ86JgdIIjpuEfJIt2sdwjjDKh8mbEytpnseagCGRtR5j/UtHhPPnbRVEFunvf7S1aW7nAJcNRLuMTgQZNupESOTAOHlAc8ITRsnHULGv9gu9X+9nQ7H8WS6jfdvAc99SiIQg0uE2t5QoK6TFddXEStZAKEDVzEqsfqi08lbS2oGQjQSmVGG+mKNpMGzdyo74UQss+hebW2wLSzrz4MKF7NmyI/MXrCXUY3ikq88+OGhXnZ22ltZd/U/S4FM1dEstwRuPfYZlrx8Cq2tEqCRET2p2vXo84Vki+v8tUmsQXD3xfMtgQL5HLC42LCjijtDoS7MPc3Dy31t/zEa4n3cvtpJ4lxWQ5Y8/Epn1ZmgzLBkeIbfmMZw8gTt
 t2udulDq
 nfkJ4mdSteWiywSdDK/6Nk/inRPH1Zy3Yb9QUVkn0qu2Er+1sbjwrFeFvUA2uexION/hxVjj+x4Z4kcObDjuUkpnkkMaDvPy/FrS+u4JBPWojFYMC1JFRepxQUqxTCxWgH30GUg1GoISjR87l/gtS2Ewwl9HoK/CQfSCD0poOaDWOKVUp3vV5NLHga9ycVR5Cs4P+KmwQANrSgvEZO3HlwyK6GYypQ3CZK5R9igYDSfocl6Ua7ILDC8NKclUTg1Z0yadw3l9TE/VHd/UqqOqH1cZM760n9NvOsKSJc2m8NzJOgUC6UeqPtTH0RZe0+m2xn7Npy8uWGg8j8A5oB88RT4MxTR3d0LXU+yx4GsifCo8WXIJDJOHWz3fjZog76QUFPHuzqX7uxMah3LC54jXcA77mM+h9pVzm2uXBAE44AzHor6J09o0Zo+OVxP4aebiPGtA78yRREXRo1WT5PK3C7E3wbt2x8v1aYRZznhNGPTtUzLjDPvalxLu7Qcfp1QS46RThfdZwVo+175Wfwhx4QWEbaOq2W3WU/Bab6XSem4TkOMDRW6lcEzE0+GMTlC69LWJbP9XyxQiUyxXo04X+yP7yw3zmCNIZVulDN62X7RvLHRMUSdDP+oCpYtL3pHkexKEpFo3spG9Gq2Jmto/EIy8kfUlTbb9D5kb0ybm3pApMGcGEXDljCy83849QrLMnPayrdhUEbpaH7r/FW1BqL4GZTSoOCPFCoNlYjunsXixza7zKVe7l0KlQ7fUWcC6UV0Zjh0oxCzK5CXUjHxJzS1z9xPAC4JKNVvnvsQengMaflp4vVU8t1AsaaSNtrR09GThDlcpWLvxVdgUFpVj8TfKSFKD1eSdCwiNvmbE63kh3aol2Aams+54Lvia7p+QtDndO/uhXflbLQnwP9kR5ngzLyhDoqUPoTCWmqBzJzigWC+t0EGccf+foWXhS857sLWs2ExMlSflS46KJVjYqdVLprk5o
 ptwpyJVj
 jt97UJdHvKRj9Rpfw6LNxuF0BcOjIsg6r3Xkbf+7egP8jadtqIMELAPSjuhInBbVfiI/DqfTvHbp0skcR4S/i7asmeGc7jhP9XJ5fXdqrySarOfL1+C6f2vSs1SzshhOCtmVadG8oof0Aw3ChfzIixcwtGqVfwYYE6C/Krtl7TJ4Y5fkV4RLGvzFZKFy3mdHCeAEUhCEu3Gz4SZ8Q9NISF7zLU1GSw11Uda1YlGUPftrzuw4PIsUKaw7LiDVguRFB5wXEUPOdngvJUcHVNI2QiE8pf1TtgmF3jOmbD5KxzzhoQ4CX6aJPtmJTX8UpCA6nevY14P3gyk5gzkTzTxIExqUoq1vr83B3WzWAjAthvPxsVKUtBame3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 05:08:09PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:

> > diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> > index 7b6847200b43..b69fe5e34339 100644
> > --- a/kernel/bpf/arena.c
> > +++ b/kernel/bpf/arena.c
> > @@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
> >  	 * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
> >  	 * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
> >  	 * being copied into the child process on fork.
> > +	 * This is a kernel page so set VM_MIXEDMAP.
> >  	 */
> > -	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
> > +	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
> >  	vma->vm_ops = &arena_vm_ops;
> >  	return 0;
> >  }
> >
>
> Historically, VM_MIXEDMAP really just means: can contain refcounted and
> non-refcounted things. Everything with a struct page is refcounted.
>
> I think we are now changing the semantics to mean "maps kernel pages". I think

Yes.

It was sort of implicit before given insert_page() etc. but still really meaning
that it _might_ be both.

> this is fine, but we really have to update the documentation (and possibly
> rename this thing to something more expressive?)

Yeah I completely agree.

I will rename it, but I think that's best for 7.5 obviously! :)

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

--
Cheers, Lorenzo

