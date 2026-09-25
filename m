Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E883CC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 09:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB18A6B0093; Fri, 25 Sep 2026 05:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62806B0095; Fri, 25 Sep 2026 05:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D518F6B0096; Fri, 25 Sep 2026 05:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF6066B0093
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:35:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5C00C05B1
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:35:35 +0000 (UTC)
X-FDA: 85251777030.13.61A9572
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 27AE1140005
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:35:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bzZxhyhs;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790328934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLG5lXHaGba/dPImy7unpJ5IThclo3TEAxLWPTrsKfU=;
	b=gWXVxF/Ab31/PYS8ETIrCBEmg+zG69T3t/oBQUMUJaK4gP9MSRkuq49eOjqTg0ASJyKSan
	5VHsFFfn+hItL1e0kM6KgA05VtT2L8kHWWKiuhR2/M8AESzoVX0mYUj7cgO+25BFpdiENk
	EraQjcQFb0Xe7yCBJJCUy3XKaVW+KD4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790328934;
	b=54BV/l9X4/ziOh6k02ucD1JHDL5vm1wx5bwvOAGoiVbzjGODxqf1fwwvlB2em76ZxsPGgX
	m9bo0pqJCjD1TXj4IpGx8BjA4KG5I0QL5u5bUBo/KJQt2f042ef6HXn9ox6AgcIui54HZ5
	C+WUH+27w38FbE79UxrQOoMT1B+MUtM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bzZxhyhs;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F1A4D42EA6;
	Fri, 25 Sep 2026 09:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC6D1F000FF;
	Fri, 25 Sep 2026 09:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790328932;
	bh=uLG5lXHaGba/dPImy7unpJ5IThclo3TEAxLWPTrsKfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bzZxhyhsPfPrL97TbhC325gHjRpuHNOnRAtDnIf7+He5gMfkm4PSOaeLWWHbi8c+l
	 6gLN53Uwdjt1XIK0OfcSHtcQmumMJlRTA69LriLBQLJ0wlctJVs9Bq/WbFIYgezX2S
	 o7HKidp4dQ3owP9NtNKbVP6jhZCshUTUiQ66DK4nhMPv/dIHOX+rBfreTpiYW/Trbr
	 lwzJ176A2TJiIAwDANzHglZssZ2IwPz45AtPMn/Payp0HQBUyL8MtoMoRwY1oA7vIH
	 So1mhkj16h3+GX9qr62k4qaQbTa37MdNPZHhAdlXJfG4rCoV0gvFtIiYsigAgrqycF
	 Yh3V65CGNEVUA==
Date: Fri, 25 Sep 2026 10:35:02 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 24/40] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
Message-ID: <arZAC3fyGMDnxiFX@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-24-4583d8a23bca@kernel.org>
 <93672B94-BB0C-4713-8F8A-3619D81DB7BB@nvidia.com>
 <arT3K71l86fUVldk@gremlin>
 <CBD619D6-8717-4C81-B5EA-D1D0771BDA3A@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CBD619D6-8717-4C81-B5EA-D1D0771BDA3A@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: oamefsjmbbqb6bftnnkxt9j6b4i3qng9
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 27AE1140005
X-HE-Tag: 1790328933-581369
X-HE-Meta: U2FsdGVkX1/2AKmovkNu0gITWVGRrXz3EctJg3a1BBAJaJpbWi72pZyjkSymoy9naSWuvD0I4hB2H8V2T7JJfEgJyB0h4pYS8dCJlZSboHelz58pe9XbvdO3WZA9wJ39zTYHepKyVaAiEkUdIGUxF2FTYjpvyH24Fad9FunUAb/IC8QxCeq8Rly4BhS2mo8/Z3XvADS17u8/WqC7ZWC6MAZcNeCy9hXWp/ksZZEmZ9h5GC5NOqPhAz3vKs5xulnsiYBKFx/caib3fvy6wN4hUm+vtnqM12dNqAbcldkKdvRoGknCh054Jc1HyhyzwNQYPL7HYKU5c+q+2/Pc4Oths45x1EhB1GNFcu/jPWZOFeX+50pbRbY/svNiuWHyXFV3hC6UdaXjjQgY3hklHA7eI7W29yklFzz23VnaNN2c2VzVeB5nOIqPazzE0AhGC4rJ9BxQobo7Fy4FBUm39rclJeEilnpNd4CBiq+MBtKHxj5jRLHn/wZzsr7oUi1x//Ltj9ddkDe6b12wKOu91puJMw5pM6zXSNFRUK5WrDyvvkBLN5J6Q4GpLyMH4xEttPTIMVl/9arOuYGSMOeigc0LqPRaFdAseKJgv/OFaEGLGZLyxkrcewVo5esBFpWTyzA5fiCOWblIe4VmEe3jJSzG1Q31sxN3Y0VA2Z2eJ/sdtlVQmYMV6mzubsdOdValRzM62B5B67Y8i4SdtOdUTmDbFTe//oYQArEt2PctHu0Ds+6tpmiHGlYkwCt5r93MWnSN3mb1FrU4Sc/DNgEKdOMthLSLQmmZBewkjiwfVwFe0q5Dk1Ktc2PDo9WieP6t1ZxYjtUTyXmIZjrdNeOLa7dl9ogXBkWrS6ZnkkAKwrLdUIdc/Pfwexb2CtdJokBD7pXIaVcRU86uZuAr8CvqgeIaqSnGl3wOVbVVOwQhM9TklYRiIJog2JWUfNusDWA8uhO73ARN+ZvrXYMK/+HNEfP
 GbVaUz/q
 kxEJzjSU617M5FLhd0XwV9JQDEFx4Jv4VN6YJIlYVaGmyBIR3Cb3Muf+ZP2JvTH5sTohkRlfN84hscLoiMGrvk7qcrOIquJLy9O15m3NkzwfmmCF7PQ2LybjjvQInEar44+DdPQOE4YVnWRyZZmmi9O4jjk1lTXfQ8g94ZhFbcehnQEWMZaNl3ym92WEDwfSk7v2w1LZjYY29dws+kAKxBYTFln6C8xERMJY8scHiArU59Paut2hJpIVJC5Oyf9l6cqvS/WnRptXx/J+MAg4aMw34+dcDO58UsAXZmRc4zzpnpSAcacqrin1D5PP82yESAleYQLRmTQCD631S8FDJ2FhZUoIubevesyn4Czl58rYxTmwNt4Qr6E2ybT08wu1+fuXPsknoAZsIkdTuAqlk1OrOdjWoKGHQ61Bm936pmCArP+IxDW5oRlqCT7vH4QMoE+s3pYTEReNvwNGuT88EVyrCJ9wk9E57jCh+O9IaK5uGce4OQHFYwiIf77x9QUAkv2H28mG4zd3bwz+trUC5FJLL7iNu6XIJ2wNI+kVlHbBQNGQ6NJEZUIRLjIc+eB+MpjQr+8wYQhyiCvE0DJLOIQCmIpNz06gikxa5+PXA1uMTh14bQA0xxFtDqqpGbtmgdI5NbkwQxZvR/9S5KUiuECEc3i5nqvya95utRILkV8KngnnfO3EMwsGH6yJomWVyizoR+ARZRr18F15enUwjZxoargbazjvdbz7GH9LK8mspxIvRVn6a0QIfEV/J6YJmjzlYdIQWs/jNFG1BbPBdqep43bsYNRwOQORHFb/mSPAY9ds90jaF54cLK9rT5BM6NW1aucfPM9z3zgxeAn+o9Sp0TkNJevgPhRawW12WThe4k6G166uS7mQPaqhYWV8ycWpTzYWS364+RedBiIv5uJKfWDU7k0+0rXBWWzOWgtVS/VjcrD5fKk/0HjHQJg9XX82hjN/ABpyoa9ldJt5iB0WJWjYC
 k1AmbwBU
 laxB3CG4mXLGVQ00+hk8sHFBs347YMIZCMiJ+x5j1MfqPBaHWcMqM3IiT+iXBdiHM7d3/qu/4eUJdFfm/xt8mUCEdN4tuVkLcGUhA+PWLdBUB9jsMfHWsVkpIHcba+1zQjtfZEh5gxd3pBE9Rvc191py3MnC8Sqe7t9gAlU7vGWjdckAzZQ/HdIQOubrWtGI2/fxqTgpo0A9Fm7mS6QEj31WY6MBWdKegPaiIoaM4iE1+OgdCTHteYUiJKtUm+tgkCj6xD43CRejUTxC2InOGuXHHbEMm3DM9PjojnOvHYDnsS3amUyPQ1lxf8lMUVRZFShsnIhUvLfrdbh701N3MWvHS1jWuMNIPTqOeG9tS0t1k5iwwsEEJjSe3TXe9RJ6/umxFkLQNo6pN7h9RZhcA+9Op+jhq3jV++b16NjHB4dM+mg6pGTMVflL7HM/GlEw3OFg1aIgvXiq+oXB/t3ReH4QFhDSLf35629oDm6Q3OVooyjQzEYyFQITYYbovj14303+nv0OQPlwo24VlOoM3UM5TmYx5inHYZeXHUEre++KGlGzSf4buupPy02pGAB+Ht01ZzsWor1Ol9H/E11Od0/Q1/pp5JyNur+79SZYcfHtx3Ustvj3refZDfHpSeGSXgkLYAk59aeneYaCBR57SQCuI/Sy2HrIMGzutw4CqbB51YD+dZSDdSrv790S1wK5JlPXVOgoQ73LO/P+spTPV2Hume8QSbRQvOK23HKn7cabv6dyz1upcQ86hUaTBLm8o4Lj5jwYZGHcVyKzlr7p3p7LlO27wlo3Fjb24+ElhDqvIltOO2HLuPOnwj4cowxI/Y2v279QJ1okW1d2UllUVdKgzcrQwyn9RmdcY7TfK2TvzSgZWeSBfK39K2h+xMkJKv/fZoE7SdXTww0vC7Nyni+9FOZb0y9KIKg0up1TCazuNthDLVJ5HqB1YPQgRl4xr6tQ60pgu488luZzrVKM7e0xT+mfU
 nP5by/Mh
 BDzz0lDMCLXGcxnPe9MbHd7xXEf7wsMxxNUrioyzgK66QUG35cgFaBsIm76+jkI6Jt12t3+HTeEZ2cIr6q5Thsj84alM44Z9Q3au1+kRNBiSJRnt0jDP0W5U8WcjIu8/TiI6PHjG0uKar8iNMmHLkhKitSwUYxKu2cFgrLPi/KgIUC21BwunFLUX49V+jWqxW8QpbZhxfcKWptkpiTe+Ws2T0j6rh19gu6jbs5toyEmC2XwvIYKxrHJ+m6652QKroghJEB08200UhozFPHqgFsrO53ldLvl4Siv9eTWykQnwaVntXVj+X0rCA2JtuKdfZeIDFk3db5XPoDiWqKb7PeUVGpXUojpE6Q76BOk6IVVIHEN3bfDAw/Rdef+i4TQVjmsVVfXwGrZKmU6qqeMSzZeuQIJEHhXKSm5g/nF0wgZTPsR8rdj7W+yh+NZaNg//KyQh04FvnqLy0CYQ1zvuesLNVNGZKuLFsMOhCfOEYzyR6NkWcqfHFaWJrVRCzcxdn/NfJMpM+9/LmG6HmSD2o5ARz9KVETWA5VUknjMdHRHZNwwsCk8DMAUg9f/Hql1NbG30LSiV0y7DYrDzodAr3nWrNgGbSPM+5dxe48bI0aOUhptS0ybf9ILXYeIfmShZdGEmI9qLUoM1uVddlH5gQH9euDIAX1y0uB5uGV4DlS08BfcuNckfzsRkZUmsu92iFeyzoP7O09D1rpTkt/T1hO86ZFbtz1BWmwdtykdtefNeqXQNM7sopA6z/GsWPpjGrj1gR6yPjPku16t/bZ/0CqohIqJC7yGs09Jv8QrSXXqi43IEJNFHvMu7avtvqdN6QFhC+TtRNKoL9RYCIzyBh42s8zgwLTxL18WWGv2jlqFxZa+RjIDZjCyZV5Ed2qvXyyslJf/B5lCoXPrx4IY98ZPWjRuE1Av9Id3VrX/oEbenJ2zNyvXrEMhgJjJz+d7KW6IiUju/8SFlMtNK5nrKebduIFp+t
 a5zev3/m
 St9lZFjXO8fPC+b+coksGqI7FqH4eNkeWoGsc2jGxNbqMXSUXkk6zX/fmrAXCjHGWL+Vf5hffzGkIp7K9POvqUU1WKcKnKqYtlry1KU60vmJQ+WahUs5miC8we+MVM2UARWPhWGSPLNJB9Z5Y+oJ4MokPqLSKiXeqMds3q6elbtW4kYbR2nHrgN0ZTDGMEpFFn6zMq/1i9vD+9cybhnNWwAtB0thXwciGVs4x6N3o0noEbv5B7ki9dCXM63/KKlijiY/OZeotBo0CVS/PyGtQQYBhPhFGBcZKRyRFiptCJyRodZtapX2JUzdCqWS1ZPK/WJH8e37Vc7vniQNRLesa30O2CVFyIzVbpF8h7vlt4IxRI2VrIvtkA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 11:50:14AM -0400, Zi Yan wrote:
> On 24 Sep 2026, at 6:21, Lorenzo Stoakes (ARM) wrote:

> >>> diff --git a/mm/folio.c b/mm/folio.c
> >>> index 47a437e0f7fd..35e242b48870 100644
> >>> --- a/mm/folio.c
> >>> +++ b/mm/folio.c
> >>> @@ -505,7 +505,7 @@ void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma)
> >>>  {
> >>>  	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
> >>>
> >>> -	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
> >>> +	if (vma_test(vma, VMA_LOCKED_BIT))
> >>
> >> I think it is worth documenting VMA_LOCKONFAULT_BIT alone means mlock in
> >> progress, like you did in munlock_vma_folio(). Just to keep the protocol
> >> explicit for all the readers.
> >
> > Well I'm not sure it's necessary here honestly, because this never checked
> > VMA_LOCKED_MASK anyway, and VMA_LOCKONFAULT_BIT never made a difference.
> >
> > So the meaning of VMA_LOCKED_BIT here is strictly 'is it locked' and it's
> > correctly handled.
> >
> > And I fear that it becomes whack-a-mole - the neat thing about this change is
> > that you no longer have to special case the stupid VM_SPECIAL thing, and can in
> > fact do the 'normal' thing of _just checking_ VMA_LOCKED_BIT :)
> >
> > So I think it's better not to.
>
> Your reasoning makes sense to me.

Thanks :)

> >> Why I am commenting in the middle of the series? Because I am taking
> >> a quiz given by LLM based on this series to get myself enough background
> >> knowledge to review this series. This mlock part came up at part E
> >> and I only have part F left before I can do the full review. :)
> >
> > Thanks! :) I really appreciate you taking the time to look at this! Sorry it's
> > so large.
>
> Sure. It is great learning material for me. Thank you for the patches.

No worries, and sorry for the size of this change...! :)

>
> >
> > I held this series back from last cycle to help with review load, then spent
> > some time fixing various AI-discovered things, and all the patches are necessary
> > (well for the most part) to get where the series needs to go.
> >
> > I think the change is worth it though!
>
> Of course, great to see hacky code being removed by this series.
>
> For this patch, feel free to add
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks :)

>
>
>
> Best Regards,
> Yan, Zi

--
Cheers, Lorenzo

