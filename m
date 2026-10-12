Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD418CC6B02
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C00B86B009F; Mon, 12 Oct 2026 14:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1406B00A0; Mon, 12 Oct 2026 14:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56286B00A1; Mon, 12 Oct 2026 14:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7C06B009F
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:49:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00C951A12A8
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:49:57 +0000 (UTC)
X-FDA: 85314863676.12.C207AF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 321C2180005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:49:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eKSb/v+c";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791830996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ETkvxcX6k2lKVqNOx/pl7biUrWa9FssL3e7zxjhnIo=;
	b=IAvKzVWL+NO9D3e0pAkyaZA3lfIS6QIeDHv8Et/UXAFKPXoMRvNdQX1OAe27ufZtd1537u
	2Yn/zynb7imsUTebxzSbQiHME4+jgHFbGCYPU+iUtQpUWpn6CgIqPMPHk3Hy09KCPFVY+6
	zWESPfF3Q84cDclaaj3J3CbfzzK6zJs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791830996;
	b=CQFQMJJtiHqWwrxRbjmeHDwMpLFK9s2CuwVLOXfjUIR/K84lpwuGCDX0Uc9Eyse2nqIOZa
	0agfeW7cj+znVMemOQqOB0oAy4Gv9q47Db/t0ecA+9PnvAgyRrO9oyoFxACh3uOdfV3BNl
	alJE43rgfAuuB0PlRo+dg4k1qM1iLoc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eKSb/v+c";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 689DC41E9A;
	Mon, 12 Oct 2026 18:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1141F0089B;
	Mon, 12 Oct 2026 18:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830995;
	bh=+ETkvxcX6k2lKVqNOx/pl7biUrWa9FssL3e7zxjhnIo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eKSb/v+cPDwsjsY5yYdu8Jy6kfWxKxwtv3s5xYcCMTxJountc+db2DwElGZpDBmN2
	 HHJgmACoQpAy1Aw4bqeJvNPzc0XTvPnxWo0hUel2k/dJB/DfEIj/alnwWXF8KT4Csw
	 1Ip3KLDH8WRPkmBpeM22t0QT7jx5jampAZYH1OtP2tFm8Bs9XNkiXFc+yZ9Qgr7/SB
	 X8dCADJA8VeY2qPSD424HmU6c1zGUh+T8gCwDodM3+EBfLReu0yQ+DpHnxDbVi4Nj3
	 eRZgA6GqDae4XATWyIjDV1Lv8S0bR3honk/e13w3bHEFEuzwbqgbVsEyaTfEhPrrCx
	 q6NTZ4oLWf8Nw==
Message-ID: <e65264f1-52dd-4ed4-a647-87e7a1778b6b@kernel.org>
Date: Mon, 12 Oct 2026 20:49:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 33/38] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
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
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-33-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-33-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 321C2180005
X-Stat-Signature: drf7rthimgkzqhapctq49xeqskuw9qow
X-HE-Tag: 1791830996-30012
X-HE-Meta: U2FsdGVkX1/dvXSIsB4xcjy9JNf+oZVvnD1Qtm9Sy6dmN4HqeqoqciM9nr8XeFomtzVixSYxljGdpVZBcJaBoxAwGwXpKic+FUFoKgTXXmNEDFu39EY5q/C5JLfUi7HQRIhayCWw1nGak+jmhwxKxxLbsNrvvNWMrT7wmTk+8JsLaFc9NQd7tyXnvE46p1YUgYNWh9frOmygRv3IRkSQVosxHx7dIzoi3qzxG/ykrWsWhWNPNz3JfZq71vUL+5RXQ4ubKiTJdG4UB+NaqPifE6P/SO4QqcJAkII2LXaEE2HjGmYNHUY9t8XLvN2kiU+Z2g9UKrD+2UYUUDXk+is3D8OJ6njm+Wf7sNX9A4xWb/8lhgajH/AcDv/SUsOBkmAW2FUbkukfn/GTcuXdD4LJoJHinm7YsjV8iHpUpy8US3Ef0U3cUf8UqkG60LcnCAUcuvNiCgU4bgSdHYex7o0A+itsoxZtEFifr58p9ZLr9RkUCRMbPNnnA3hZmCs4QXxj/ez9sQsdiQVH4gwSac5GGsSr2ZV7u4oaPJLEZ1wys3VZ1OewdXmNmnkSpietVgT+5e4k4JT0SvCrkAlRSghJnvsrpu5M5GVpacHVPCmfe1DuqFsaRZ5rxiOZWgtZuJ5yX6XyuFiPlM7O82q4htQYP9AQhKu/h5bO2TgLyLnesAoUFgf7gQd5llCSQKlndPyK/IsGV8X9VO0BkW5/nx0urWvCuql+yHV/f7nn8ui9FncmEwoU7e5Hchyx1T/vmjmWX4eA6Zv0Ae193og/b7VErI/nV4tzwTCwDw4pSSCQXNcfvBGwGQE5K+1IIdMjKcS5zUmx0rxEQkZvfDuK9DFUraKPd80Pi4aeQ4orbELnfcSk3dnK/g6/czbr2br7REY7g4fNwSz6cibYpSkg4LQqAgLwvVkx2hXeZbr7Fe1/c4fs6RX/Rfr9Oh0Fmmjeh7dazi1tC5K0Rv4C1ZG/KxD
 SEr2WW6o
 /6QtDTfEpAWnYCmuAPibv5Y5T6V5ikSSc8pkIVJKE5fynzCP2jYn7V+edpJhSxHvb/UqKn+nY/TRWY+x/S8ayuaXDsRrkodNT+49CJV6Dv5nQV0Uwew6L2TCwjcoKspjhqTA8MSsMyJ6vo3bABDfz2Zvsk65w4e8H0zRYJ3jjaNu0bVXoGXjtkihT/b64hAcvJkDuOjA2/bmTmKLKz8GwpcqXeFJ6gSlfrmVjrb/4Ppk7LaLPfQfSlB/wshg+Vj7mssNRTJT17k8Dg8dFxh/k+7wU19E4210jkmM2/e9fJgOr51rVOG+hO9MmFdzj3znHLwpzCgcbiADjNxI4uQFjICSlFmUXjEbWUuG3Qj0Mr9WajNiDbiLTENNkN8yvUUhg1hU0bVFU55MXgo8rgMqb1165mr/mHHdypc5N4wpvrpSXiTaYdESVfHyyAALhyeffaeYHkU7x9joIte4RGX1buf52OokTQtZXAotC9JZ54OYsm5gq/jOPgrMKTmzfmmMRHx40kx5n7vs/eUDe4mNydmU/lZiWg4tgUIIEUCXfAhM59luAqvqzE/odl2oDdXs/4UvFgvScZjmAVN8EvLQ2jQoL9UJC6+R61YIO96TDKxTU3z9/FwKkkU4Aui69FiU/snWqadw35yFrHilAkU4DyigUOg9D9w95PtWXM3EzMR7sQOm2E85c+Pj4mdccrMTrL1xc2UKklVObUmWHJ9DUz+ZvYw1fM/D5MxfbyWWMy55bBpaxwgYGdoduQi4BO2lYlaEKysWiT8ScYKqAkZx+/3JPH4+oKtBlEgBLLthoi8n7qATdArwS4dYYQULQpCmJRD6UwZ8Pxu7Mq+iobWjEKdgN4WLXE+jm7pMYYaxuX4F+ClywJRTD6d8QKSPZ/VaBuYOY3bdZg25f2w3hUr0axkSwTEPYAW71G1PytO8ygwuCuDOt+ec/b4kY28qqOFc51omZRR7Qe2lg3CwINsVVFnAamPqJ
 Z+/+MkuU
 orFQMGN/J4G9O7IlhtyNUiL34DbzoUnTTWUEKJPJJRg6ptPT8ZWPm6njp2nZaXQR2fRPvNlpghtg7tiX9rvsW+s332nuJspj9+o4F/qRvGv2IoZURN5KvzQZfHVAniZddlJdolhuvKlgrA+cSjVlJ20sU3MK2aCSDzvXKnsUIB13bHtsX9reNNgUnYJyAGV68Jcj9dqZf2ADQ1ga9SgW/NnExMokOGVpD5kg5HS7KYhwrqlmu5wInph/4YhDFCInTkrFJAFfKf4kf3129jyYSF2NGC0HGMW5TFwpkP50hdlH+xPmoTwCBJFFpU0Foz+d9PwpDtkdg/Lm5Fr1Seatjf2oynNELXDnRgIBX55eF38y4a6bHA+FUlupDFOspH54B0/FQVeFGXYpkdQkYW/oUL38+Nczy367MvBihzNjQmgeURnSNdZCyQ4L+kQts2t2zgH+ZBv1ysnKhG6rRcGjQg+8BjEu8orhmKHhnt90sFkIJP3lq4tbvorpkZ8miO34olNVPlflCha3fyaLwYLQHjeMhumsknJcm9ZhHpuVnXZsz75p65jXXloA2XGeKlX9DyAhp9mPdWzj1FZbZeOndMsHdFYxWbTsWqXJtl1toSNyG9yBWst3OWzMjcKn87po81iZcvCpiamPnpt8akt+fHzkyhqoiD0NQDU4l/YW1beoGHaQi5D4RExFpCddWLyZwZDAbUoCuDuL7HQ/FPZvMUcmLgDg1fQ1h4QhKg/2PIegRodOJXvt5HqNN8sthmLj4m4XP4GQh9LvLLFsowDgHcM54ERjwhiVgwbyC7cCzJJNhLw3ROkbL1oKjdiwxeHfSxg7yBLBcLLBbLV3/hnXa9mIEzciK9BXqv+2jeJ9EVtH6fbFNUoRpizxzOL+HBSqP+rvNV8evz8pZgT/243o1qOILdTeo4mojWnZlasm8gugmx0dBmD+cvBorEOG97FXEnUem4GFDgA/Bj2qYIvvoGAub5KeZ
 dJ8XLAiO
 y7f3iAGdaENfUNOBEOLDecLuHwXBZWXFDVyzBBf6iRA6JTKZuFYlWusu26P532DfCOTdloAVfzED2gWTpXYHlmF6Rbplt6aSl1BE7SaJV/TSB8Lr2Gt/h7yFq6tB7/dy2CrvhtFaD1ShGL3xWRZfJlkq5WRbJ29LLmcbPmTlxSXBp/F8w1s9puD5UisKNf6RHk131n+tKVwBn7uTltOUsI2vC/iUCVtIp1a1yofQPc+WxdycALYkVMlABg1d0p+j5Frxgkqu0d/+EZm5BojTGvw+ONxC/pCd6lJy13rgLEJJOSTb2ThHuta/a7wIDQhJC3poqvSzD4VUO1Zl+VMSuruR2zejQ0QL3J5GfLxfiseEEaCfX44SkVcxBbYI6Qe/fSW+ok24yAUgQ8jjlj6OZrtJ+sa6akQfsL7Nn1GVpkGcU0tpHKLalDHAwEiFj0iyVIR02cNhMaiRgVY14OGvBzXQNV3HuL7j5xwtQPabe5y+8sNOEeSiY2eBkWPk5E6t6+obFmhr2qEE1en9r2wuKNjLGujDlIputFDY1Es78gUqOjgKDhQ1p6sU5vYX0uWscBbYy7gPi4/176HAmVIfEe8iXrZjRAB4WwcqVm3pRvT5xHRYWhy0wIaIU6zdlD3tnDL9Sy8VEFnAdPc+eDJguOAK29ZZmNHbSzDgflMY5bXmkiGuhmEWX5gN7vzQ9ncIekO3i6QUHrPRXO+EbZztj9YCMHe3BqQS56C2fEtvMCBhDAXRPnN1o7LfMAjl/uri9lBz19VvPyb95YBiHDJxAtxIn/gDeAdAqK8iyHVMVddkDLSPEbDnYygpYsyZE65tnJAxk4kwP/kmj4OT0nE9xYpsaM2dMEgd3SyFpV73/Fuc5x8WIfg6hCKiE0faeG1+5jt5MEhG8nMLR3YmCQgWhz/HigR7o5inkeyX9eaTjBWvDBeEWmpXpN7Ptv3s4+fzfHSc2r7XRBrdlaqXQ2sN4Kq/Xl8+q
 Q9TCYD7j
 G3zjGD5SVQ6kHBrCxgjT5MCsYYOHwcZpq3jyzHHtGeqiZ/LtDAGPBjdB5BmZWvKyFEezabRn8Yb4CtoBE8wUz3yReN5rAx3u+q5bxwgT9QM9MVRmALX5NrE1KHkfSTTAiXupUwJIkQ6V80tQnrgqLAbCGabCgrHsiIEo3SwlU902cawrnKxzJyUmQAsfNLJA8Of+eyiC8zySbgilVk6C+jQjAaZGp0+o/72IgkCaF8al35WiNn6kGsj2/IMACYlY6C0ZhcDlHiimmc3um0EtoyKD3Gnw2w1Mnk8Kxd12S9eKWPSrmhDiwUCJr4PDk4d5FRLtNT42iDM2mZE2QtlsUHUZWghE2mxqkdgsarua7bKw9aKgy9KCpKdna1CilgEpR6sxl4O9FoKMK+uBzMB49m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> It is now an invariant that VMA_IO_BIT is not set by mm-managed mappings,
> so each existing VMA_SPECIAL_FLAGS test need only test for
> VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.
> 
> This is precisely a test for a fixed or non-mm-managed mapping.
> 
> Update a number of callsites which already explicitly handle hugetlb
> mappings.
> 
> vma_supports_mlock() and ksm_compatible() also explicitly bail on droppable
> mappings - excluding non-mm-managed, fixed or droppable mappings is exactly
> what vma_is_mm_backed() tests for, so in these cases use this predicate.
> 
> should_skip_vma() tests for locked, fixed or non-mm-managed memory (having
> already excluded hugetlb mappings) so simply test for those there.
> 
> No functional change intended.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/internal.h | 4 +---
>  mm/ksm.c      | 4 +---
>  mm/vmscan.c   | 3 ++-
>  3 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index b5f7be8f65d8..e57c35e5f90b 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1112,9 +1112,7 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
>  
>  static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
>  {
> -	if (vma_test_any_mask(vma, VMA_SPECIAL_FLAGS))
> -		return false;
> -	if (vma_test_single_mask(vma, VMA_DROPPABLE))
> +	if (!vma_is_mm_backed(vma))
>  		return false;
>  	if (vma_is_dax(vma) || vma_is_hugetlb(vma))
>  		return false;
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 624f37975e12..ed66a90e0031 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -747,9 +747,7 @@ static bool ksm_compatible(const struct file *file, vma_flags_t vma_flags)
>  	if (vma_flags_test_any(&vma_flags, VMA_SHARED_BIT, VMA_MAYSHARE_BIT,
>  			       VMA_HUGETLB_BIT))
>  		return false;
> -	if (vma_flags_test_single_mask(&vma_flags, VMA_DROPPABLE))
> -		return false;
> -	if (vma_flags_test_any_mask(&vma_flags, VMA_SPECIAL_FLAGS))
> +	if (!vma_flags_is_mm_backed(&vma_flags))
>  		return false;

Same here, it's hard for me to tell my brain that "permanently lazyfree pages
are not backed by core-mm".

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

