Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C8BCCC6B01
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:07:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53EA6B008C; Mon, 12 Oct 2026 14:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04E26B0095; Mon, 12 Oct 2026 14:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5886B0098; Mon, 12 Oct 2026 14:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4ADC16B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:07:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3429C1318
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:07:56 +0000 (UTC)
X-FDA: 85314757752.05.01441BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E303B140010
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:07:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jwx+5rDY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791828475;
	b=wXn9HgYhS6cNAxfvKs6ZI5AwVAgjgOGnWY5L2+z7UvVzWywTL9MVtBXDEcFEf5a2I+T27W
	lEJXxvz8ctFecog5WhWCZkodhmuLUojo1o1ywZpyvyyVwEVrIq0C9FwKmEREGnSBpZaDc5
	QqQxmUs7Wkf8Z79T31BCQkfOiUbex0s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jwx+5rDY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791828475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5a6IsUlcXJHOADvAwqphif4IshvHpUsfPxJJpTYlkEY=;
	b=RX2F7jCySDg5aFoVdm46W6iALlLKFG2nfRpTltajdyLknX4hZog9R9/3O/fctx7tbxeNlE
	Pd7Hh6BzD1PP/sYWyTT+4cn7z2C94A1wvQcZysESqQsD9MLK9dOhfrnUG8xu7o44BLOyyv
	In9r0F9JmfPY0lGIJPXQrpWRg1QLDGA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20ECD42D89;
	Mon, 12 Oct 2026 18:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BFE1F0089B;
	Mon, 12 Oct 2026 18:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791828474;
	bh=5a6IsUlcXJHOADvAwqphif4IshvHpUsfPxJJpTYlkEY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jwx+5rDYQjOIUBj08GLlEX9Web1Y8AehnEyD+NKJ+6JGLiDzQ2ykGnZMGinpwVxEm
	 t43H8LUI4C36o21aCrvggHyN9RyNzw2SGdD/OyPLFBA80sFmKNnm84NtWUvo2kYU8N
	 cYNbAPpDSSO2uHexKXokGU+9jMdh9g5QSHt0uWmtCrNqLoFovjiA4CtdU2HJfp322U
	 9aldNEnM+7h1H81AjZw6XqSBXIUYwZUU/Fk7ap4BPata9FLOdT63qFOxwbma7qOQ8U
	 Nq/+WfROCztx3KWcWvYYP+Ey80vw0kj1tlhrwaXghvM9DOVKk2/vrEDswVQZvybKaC
	 EY265kFEoC1fg==
Message-ID: <5a7597e2-e4f6-46ef-a4b4-2f0746b5009a@kernel.org>
Date: Mon, 12 Oct 2026 20:07:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/38] mm/vma: only allow mmap to clear
 VMA_MAYWRITE_BIT if not mm-managed
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
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
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
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
 Bert Karwatzki <spasswolf@web.de>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-15-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-15-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gcybm6i4uuim1dfw567kge5y8gp95ew6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E303B140010
X-HE-Tag: 1791828474-31947
X-HE-Meta: U2FsdGVkX19ZxSHpwWkRq0pRPr3rvN4NF6lJQULVS5tgVEDc8hLUpV0NjYEJR7A2+kBRq99sjlJrrPGQLHIC5c5ordVOky9dT1PoqkCgi55qF9hEDQaim8svha1OOioNobKwoCcqf5uiWwIpbEB96ORnj+7GxK4nCwm+dQL9MruP8damX65frDI3ETRdI1RvA8pOWpkeWXgNo1MLBfL7WeO0b8n/v9hLhLWEL80O8zgn9BwO8zIQJG6+SomuDwiTqoQxwxwGTh49woOx47i1XeUmdjZwrilf4RdXiCVugm8t08EAa1LE1jpvQVwNVI+3l5dcxgjBP872XGBM4j4XQ2rUjKbjR9Wi4ZjDePK6r/MdVh0fwSJPChbAB59MqThVSgGpvtcsEa1b4Fj6gfdcT8zmDPwkjMnWa1QKEdknXObJuzEkNoe2xHf8TF2myyHOcdNQasGHBpVCajcLtKyV17nENkyPCuFixLZXt3mLG/TQBcYszDWs/3xh1X3f40Ne3REdtI5HvEsJbfw8YG8YpBHdNrOa9MSuTK3R5JCCPH8ilxLhXu00EbT7i8EhG0Eg/0QtMnSAyN94pzcV0hg16eN4ETyNZJCdS8KDDChmNeLOteD0Y5/P31HE/i6KnxaD5/65syNHyWg3vfSF/2YhC9311wLTdOB4RP4/oJarg1MTmIvQ0zOJZV/k161qy/pUiT78sC/rP1DwkKD+C2E+19V2tm+SvdVK+gm8ZXdB2Nt1/uf/QRRwNqByErAD2+92Ybb92Tw2S241vu1NbbrHNMHs10lt+VHkgH/0SSdMc+I/pcaxqWSVyeiTgaWeuvnOsLycCe+l89/AEgUZMKSshxG+LY4mQ1hWsxZde/qyEfyXyQXMhss27E5A2TPR/lPvzO6/WJOOG1O/+xlB95A0ivz/a/+gqKQyB7Cf8wO+0otQOySSlhTJQxfu8IWZ1rYbNx4sPdgjTh63/GGxuGu
 l9CfMp22
 xS2CQhQwFjca4YjQnkg9HgRS5aK5MdYT2ZKpMhOAIn1ZZqmv5sG2pBO4X+mANDuMOD4ewkjur4oni7HaGNdkwO9JD/xfMttmgBnp6wGNNXj7/9aF+c8n/5KzlIRTmjoN1R5D4MiaorUY0ud44ly1qN4TEYelehDJ0z29AN3SR3LrPJUKh3qtOl+JRo/veYdEHm1iNsWH/vD5j6ccgBf8LKC+axKJLa/2PSK+3RkBYruJxkaQWw4b/aMT/ZZvkia8eyR8wUi1ubeThfMn1WISvIqqYXicZzkPJik7O6JPynZ453EjJuD/yhdau0Dkgx3RvjO9bUxS0Af/p4qTVQL8jgCPpEXH3dX6x2k0yJsFzejG7KkLVlQ0ohq9twWqKX8xJWeFpdvXNtP3IhGJXWy/nBY7mmCCgQrNXTvs0Nj8JsNNXk9Kdj+ScDHVWdrPswuWH9jwqlJ1uHX34vG62tdGvLDvE7Tld3qEn+VtJMDMOigWtY4Z/wAwdodsVy28KNv7/LA1gyaVw+6bnebC6hw5CWzaKNsGhzgEDglceyFxBb8n8lY/nyNVRzZMYD1gfsP0iQLxGreYXnpN2b9IhQQ4z2AuwhFJihTiY6gcMhiks/3rAMng8Gb/8MZDsnFENhS1cFCpf1RV5alX4p/W6ia/zRzFWPtM1XN+IRJSwUSgOcQ8DC0Evz8nNTndbb18dbNbm1BRn+ahhS0tfhZMQvbWwJ1kvGhO4cTm+K6PrZHhAxQxaUVkLg0QJbttZZXDYZ5f8pbdd0U4bDkQ+BYtkyo83fFZXzYWjMO/V7n7VTdoBM6Qr3O1njPoZ3oCSEfU2CZz/BbE/WWSHSrENcX3Dh7/Xl3g7yBNGnjnJNvRzjD6tw2y9cTxaC0Nd2CX2ytyZgbKoV+uugltD4WMNnOd4IrwSdYKPAxQGYDf4G5FqiDBlrf1u41NJ3An6H6xE3EdSyMwsS7dfkLEr27I/mmMpeKlWaO5CXXTg
 9zXTL6HF
 DKvLeIF7EzaC0GXWEKWuXpEUa1iIcZmSrwmKgrWQjn1hNg0Ka5F+apU55gnOsxe+1FkmWyh4VAG7SJHoBzK15l30+6/2R2YKz39NHMbXG97uSB0zGDuv34QtZ052Ydux7Z/F/Cxf6DIlj5Kr3ZEu2aUfj6ZhvxysPuJUKfZEli85Khqtj6UqxEh8or18kr7gUqFYcfdmIK051gh050iXUCYef90DFGOVol3hXsAcviMrMikWgKHW8o2uIWe76pdad90bmd3dnF5zqp0F1PG6oq7KlH/WwQkF+DK5AKwXWyg8NxOYXjUEK6zDXqbLsqjYs40VeBP+RXPjOemkzKA5c1pZWVi97fcAytT8+U96SvlmiURQ0YKqZPRbKiqzYo1JIhz0DdpttzpvDoSkTaj/7mslbp2XfsdWlnZT9DK1WPDE40ZtOy92B9XNLqxyo8uIn4VWA7HDFqge0DitaryePvVAhend4kOg2q3OPZMz2BW1x/PCXYpJ6H5nwV6L2F3ooHYa26UeKb8Tuz6wn5FWmgwPaahLutf/MrEFTL+9vHXdCIiCrU8w4VwR/C94xrpgD5rEemNt/bJgEGc+IP4CS0mHZjExoRsZr6q9r6zI+713iX/RSUICe9a2LI96QcCMueNRS0sQbqXgv5DOM1CIoN2OonAUDq8x1+8yblp8f9WMep2KSXaa29VwLaDfKgxgNaXlfpQ3WF/VthzveVaAOXG0Y0Dw4ANmoVysrjAQ/+6SImSpw9Z5oBNQyI3L0tntoJbAke4h9QtYrhYFIDT9kB/3Dr/iRV9Lm+bgnfje4dCiB7h6NnUUsBqx5l0aGqUuceLb9A3HhuAWWUt32ZnZI8AOVxAADrRnLql6z6txhuHuRiN3kHQG1u+9yp0torovuYVvf6WCwwxdIAn3YjGIGc31ldZMJoy+ZbYph/uGIz1xn0aubqMHVRFXQsnUJAbTmZLr72HKngE6193vSlE4x7/1ONuvg
 woy2+2Sv
 aLcjiSGpqPjMm0xgo/fWr8TfXj+RY5XCp52Mfl5NaHN7+eB9y7R2pVjK27+hayoWS0/Mw9JlOvp/IYD6tFtjWVT8DxO46ioZTkCoMu2QXBgTZu9AKmZ/6Gn6qUgqBZZTppHsIpmB4LX+mSJzSY5f37PLeVyUs9mlPneKh1o+fECNcDZAHSW1UHI0pXi+Mr+hDbZNMQO0gUiWnic6ig2k02pxFIJTLmZSixQB+gpEyspyeAm/nKMdeSnTC9aHC4OI9ltRaBTFVKbzSrHSZW78gtVlaFn1g43G63OuoIH0m+aE5uBC09TDn4XawRXEdofUMgTRWq/YrLZwYPa9xbcJhIO4TvbNhHHUp0zm2+BYZwNADp2hu8wrN7w3KmVvtLZG8ecCXHzO2t1BGfdNUi6sCqIt1NjqkbDy7WDotvWI1YOJvDn7WuQ5aSubF3xK+I8dwhz6SfqXpgKJbglOZaNZ2DifygCmbX1vsfBQMhDpOOJErSCXBgsIQXZwvUo96FrYtrQzY3k5kNG1PfcSljaBZ2yecPyYjeuP9Yl6FtAksxbdKDL679Sv/AWAugtY5rvcuBqA/ado7zs38xEk7X+xJz9IGGeBBp2RfBIsorg3koTXy2nTTzrRpUvwQI6GutAu2DG1zVaTSBBjiLYCQjihR1k70GY8XSsoIUeYUT1pNh1ldML1C2JxtbjzC+c2dmXvg/urNaINJ39YWhSlDMRx/YvCEDkHtXmzb7iYwF8+nFlyKd4PrmcUAQ0b4UbfN6WNfFFfzFWohgWySAxYLegUQlh2fLsi5aoTgbzTmptqin0fuurarvBFjbvHtGRbmYzBup1EBpgnY8yFSAC3fvoVmDhPF4I0aHj8axH0ucMoZsYPh1hBZKLRgzXDlo9tHSTLulT5fR66V++xYYrrkq27+e6YlJqT4z9Q1Ixwww0fAY6JU+pl47lrhOhviXXcF2bLcDffculO0UwfJR2RCFZDtUyYOKtkU
 cr0xS/JA
 B/5CLJyKFBCXqmIW3sfZ9hhBWoE7L1pnUkjhU4PRrMo2jM1qkCMBlcYrZ1VhpZkwT2gbq9UXgg5I7x84Vt4sMDRBbl8ETAQ8DNviR8nYlGydhxows5VdcyYJl6F/vOC1ogsVBWAqZzIyqEmfRAkmk2E6/mIHZy7rcTg+Euz/GHx9D0WUiqynEQAsvcI4CoXjqaoIkjOWIBtx1R40LThFNQ5yR25v1e0GrU4ZO2aG/1DXI82yVUq0FZNNIFRAljn6oIeGtuxDLP8wH4YMjYORxFWV8KY7OF+OH9RnALYq0M0Cq3S6MQ7VqDoAUqKMuDDBl38aejWb1w3Bi9X4Ep15BQxBbD8NA3Y1gO+wEctOxJ1uxeCVGHGUsSibxUTgecBfp2mZtIWKqY/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is if
> the underlying file is itself read-only.
> 
> This means that mprotect() cannot mark a shared mapping of a read-only file
> as read/write, as doing so would violate the read only attribute, and
> permit writes.
> 
> In general, we do not want file systems to be able to do this for
> read/write files.
> 
> Doing so would violate fundamental user expectation of file attributes and
> likely break userspace.
> 
> However, drivers pose a tricky problem here - the /dev/xxx file may be
> read/write but provide access to a resource which is fundamentally
> read-only.
> 
> Therefore we must allow drivers to be able to clear VMA_MAYWRITE_BIT.
> 
> To achieve both of these things, forbid this for mm-managed mappings as
> identified by vma_flags_is_mm_managed().
> 
> This constrains this ability to drivers which own the mapping's contents,
> whether memory-mapped I/O, kernel-allocated pages, or ordinary pages they
> map themselves, and so define its semantics.
> 
> Every in-tree mmap hook which clears VMA_MAYWRITE_BIT, some twenty sites
> across drivers, filesystems and bpf, establishes a mapping which is not
> mm-managed,
> with usbmon and the ALSA PCM status page converted earlier in this series
> to do so.
> 
> Note that drivers may, if they do not gate on VMA_SHARED_BIT, be able to
> disable MAP_PRIVATE-file-backed mapping CoW semantics.
> 
> This is perhaps not always intended, but we retain this capacity to
> maintain existing behaviour.
> 
> As no driver which clears VMA_MAYWRITE_BIT establishes an mm-managed
> mapping, no functional change is intended.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

