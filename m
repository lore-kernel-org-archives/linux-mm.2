Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E4A6CC6B02
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93D626B009B; Mon, 12 Oct 2026 14:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914616B009D; Mon, 12 Oct 2026 14:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803BF6B009E; Mon, 12 Oct 2026 14:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 535976B009B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:47:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C78E2120499
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:47:10 +0000 (UTC)
X-FDA: 85314856620.12.C2CDA06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E745FC0009
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:47:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ifoy46Di;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791830829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSlbvrIHwU3Y3EaiCo+j8HqkUnlq3n6fYvrvq7B0imw=;
	b=NqJ/bNqDGcB38boQcWhfs3LHD6hh9fqOuuBl93lbsp+12oj2C968NQcJSLOq8/aShfN8dA
	hsJQVpgf5XnEj6hIG53Lv0xNlHr49Y3ZT7ej+gaEe3rKJ08sqSGGFQ0dYMSK0rQ6ZOKP1C
	tUROoo+MXO4kuxPjWgUYwxoQPApv5dw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791830829;
	b=7UmVjkKeZZAlfTA/cqEdCapf5c+R/q57sDbpmVqVi/cAol7ZEjEAZvDVOQUEqopS+VR31+
	ze8kA1V7O8JIU6j3uJSHaOxXkW+K+/poCD5/uVGwZAolxMR+cqilysYk722IdSp39IUgGH
	HYRWeR5qeTJk4DSMYwRVvXAS3aZbs4c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ifoy46Di;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5B1341E68;
	Mon, 12 Oct 2026 18:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8956B1F008A1;
	Mon, 12 Oct 2026 18:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830827;
	bh=qSlbvrIHwU3Y3EaiCo+j8HqkUnlq3n6fYvrvq7B0imw=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=ifoy46DiXGWrvn9hHlC9sWpEOIJfnolR01lkmYmzMt8oZMHwULKUu405XHQyvJvcd
	 specWDspHy4xMW8bFKyZ8rpWjPIMeUNqSVWgVGRDTn907gomOPrB4hpaV/MLQBUx2M
	 8VIFQ806d0QftmuijbNPIH////VvTEwrO1SHh8+NpG+s7sRK1rsSEUt1INVLlwjZxt
	 1QIZU7Bw3nRpNkkvYBJS0tGBVjoOR8H8l0vwpksiXTvLIzHxaRPkznNHaA4C38A3Zs
	 mBuQbebXHvgoFrYLsANA2bsPxTBg5880xj3MQZLIL8NXEYnBg06LwVEG1x0EDcqIUu
	 3KRtQ3mdnAWNg==
Message-ID: <8819f458-894a-429a-8038-cd9bc0617bd2@kernel.org>
Date: Mon, 12 Oct 2026 20:46:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 30/38] mm/vma: introduce vma[_flags]_is_mm_backed()
From: "David Hildenbrand (Arm)" <david@kernel.org>
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
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-30-923b70125b1e@kernel.org>
 <c79d2d40-0f1c-43ec-bc25-b75ce975f27e@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c79d2d40-0f1c-43ec-bc25-b75ce975f27e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E745FC0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8xki15haq6qgb93ytmubo1znocbwcrkz
X-HE-Tag: 1791830828-684500
X-HE-Meta: U2FsdGVkX1+MObYxj1kKq5lAvmyWAOy87ifj5mndzfLe/U8Pe7PFeeK0WcaHSjfGBAgj+sSRoMpduahKRvV595zOBnbrpSnXlzevLlq/00Ow6kd8lwmut2fSgwz7f6ZRIwRl7jKYtgftZ9NGCDdQocYa2mOjN3y37SmDPZubPBaFmLntjaDAYZsIUV1Y4yMi8wHUtlkS/nJXM1R05CmccjK9GwjugE85WqQxknkd2yoZAaju5b4UhvLhY7U8PSmAMxhg5qaCAmevctYPwTS2OErYtw4wwwUUBtwsdafKfaEzII7yLAdTw7lLxWPHhEY7YPrhxq/VW08E+gwAW2qSzKVDdDwAjzzDU2+a7dY1SeTcDzY+Pc6e+6n+WmWVHusNKqQffxyuekU/ShqhMO9QKsNlOK7wQAVyZLZSYp4rCVoRJ1tpGbnO3wis8P02jPCXFxCncuQqHBcQfiEbweXDidCJfpu7ZawUKwMSX82cjYUpusZoBViXYKCOCFzB4+C6b9rnPfrK6nLeyC+bcPymmNRJ2IcgLsrTlc8YNbJ5ouxsijePsYY1KSL5lmc58Lyy9zsRjxiIM/0LfY9D1Vyrj1aEfBf0gwGfdCxgbe6vLaVfN/D3VbWEHs/7UjcZbp+p7ATneskd0UozGx+4SsaeHMrGN2+5fBfjiNccm6FWTZZUT6XzaXAs84oyxrTEHkoL7kya9NKsLrBuUqFTgZP/qDD2hToC8qM4MqeDJo5NqMhP1FnD4y+kv9ZZ1kBrKIPl5XT2TQrnF63gDmkkm0l9MFrc/42kcrbMSDoUYGj+z0bAGoTWl8sWipTFGtp704uCobeNtKqDIOQt8G7B+MhWzSEZyKLN2eqU1MZ1Kwm+8EBmMvWZ4EEiiBz5GCKUYVRXeMAvgwsGemzOgW2py1N2SPP145BpyeBQA6GOs/BQgyyRJQboKhOBPzo6QYV2+bj+gWX3/lGLVr96RLZJl4Y
 IUoabQQ1
 yRX0bhXvzTjekt/jOd7ccFw4mb5JVrl/bQbatc4j/4JTJAp0vke1+XQo7fgdTN3l54fy1sWMjoy+pwXtOnJQB+5WIFL1vGrOQX0AeSFhpcX/A38IChxbt6tUgNpR+CTPvLuUBf1BpqiVzyVk1SrczcN+0GcOw8g8M/nVoYsBwP+16GShFWP8lDef8oUlTPERYniX25KeqEHJ/TtdBnGAzRa737AXZwfv2Kq59p2N8+4vcf0lFYQ/xss3W8yGFlXIrgcEOudDddxe0e2G89VfXT3uA6aPpw6F83yzEx61SBa4/g6rnhdReXCHHdA+NWZ5Kij7L5o+Aow65G3C9ft8ZtmORuYMKm5yvK280w+pkJ4ugT7A1tsPKjaTryGFe1BcYHnRcoGP/h+nE3E0RtGrPm/X46yO65JzfHbgVaCkocRwn853UPRQf8+2lVdD/R4vHejCZ2pU2sHjCJDgQErziGD/oKmF9ekSzhEOBf4JCfiGMmE9WewFPCOgjdxHifjRItMmJ60Q+UXzzxfkSvX+xl9jVmON8UJhFAGlbflPIXuXOT3jT4lvHVl/HiYbCOJx8KuV6vIgb1o2aLXuiYIk6k6TmHKkKqkBzF4FkSedrQ0KczV9adp6CprMdBGib2kLqiQ1BxG6gn5Fno36CDjtsTrVCXnkP9Vv801xmEtkvJ92A86g8IX1Mo6y7lz5uVmwcGnwN3m01UygWUyHW3uOvaQo/bxLCuK0E36EEBIk4tEHfu/iIXx9PUEpv/C65l+Z1hCspS4oknpG/guZXmv9TUx5zj8kwBImFU1WiEgEGwqSIvyIQxXJ2tB5QY3BLo3R5Rwm72cW06kp0FnobX6sk6Ev2I3wEIKFcKKO6racTx67OuV3DOgKYFLmgitFZIXW6tcMHzijQQWQeA+LMHo9Mv6fYLvftG5e3644P0uDKtk813EvRg6Nfol66pAjfwqT3oGRzE6Yshiwyuu6dBW/fSjoe9rT5
 UGlxq5mf
 jQd799M5awWfe+MSXVY0Euw+YsV00pLN2lmsbn8WlKB0ZpN/IKreYjDiqvcdZtAxUPnm0fxG/NK4Mcm2Riahl21m2jm3ZqjyQTuO7EKxYCjBRWrd6dd3aSoCxON2h3Huv88TWwmYQHLXt/3ikDT+W7FE1LYjO4aSPXp5xR7TfTZpyz4Gtq1X2DUQkc4Ua1QxqgSntaEA806p5umjVV1s67M25yvb2S3GatCNuI7LJpMfmXTZJTPBJ4LAU9pKQsfDPKGC3AWY85F8G1Q1TDd6m6QHvliN8etpNv7dyW/PwGT1MtEQ1OU0u3sEmbK4MWYhskzUpVFD+VrviVRYGOJnkk0SP/n+leEXwF8sGyBOMDjwdY95E+CNBFcd1r7r6OMLfrnxIZbvEYHfUuEaOZ1ZVlm0KElbfnOew29stzT4wbjruU7FPQKZpwsIO5eFvaFuoMCkfeP/U4Bl2aa1EXKRM+Sx76fqEEBM+s16o+dR0EZa7BNhdY1bvac10ayrjPD0MX8IswrrFedB9FnY44z26bblCwOPe5D1sSGazJvdz3y4bV8ejX6Pq4GA7KigSDloih8Ea4mXIB+ldgMrvLtulx+E4jg/fyd3LDjdL1hUKaoucuyVFpWdQHYPVKw42P/hGrVDau3N9gDu3evJL5KXkUj51FIB5VE6t8Xz2Pv5KG1y/FgvmZnAFC9MmUoLJMzX/ynyhKOMbXEI3JjQuZAi3hUpV0NkQHU9/R/g7glPq00mG+rI9SL5NSNLevF32PqRHaIP+OOTwoE/n9plAha3eM+f77G4MlcAOJ28IVqzhXxPvOLxurvuJ8u5j0mLVEKtPLIa25niv6I3+VftzueG09gJGFmueO3kD2eP4VllUGyRh00PWSId11bGvqbtu7sFMkFOO1rq3smdxC7+s0GS2tL/Rtc/jtN/h7111YSY0h8frNulJDuwTCZjl2fkEy1eAlv2elRTQHhuuOqRDHnm1EKQAYl+P
 ki9QwV/F
 8HDB2MyaCnJfzB1M0UQJAZ+HX7evXRWh94NIZm0cZlRl5SDz/2LUK18Ej3jYCmu4FMnmm2Fz09Bewe2rQHgNgeaybkNJVx1S8fJ7mkOcILWn1MQmZY4ZGUV5LEGhIdgKiMlftxd5OE92XCnC24F1foO0x5tOnHSWlhwxMGms6Oex+CB7vgKzZVGYf4u/bv904S3OCnydIQxE2zg1cW5FxQBO5SI09z87V3/27VCGLwYiDEWX3CGWKTsIKVaC6mbZKVrUcYzQF+v/np8vzAjhOE9ryulMi4q8LxQvXCpHPTkjRuzKw4Mv7/cO+EE+b/d6h6jzGyIytssbYUJzuPq4O13Ci5a8llPAD4aRc+1w39QD4hRreEPYEqUWMxA5x3STGoNWMfS34mUoBm4hMFKw0gQkKfRAxBfZq7uteAs59jxNm26YNOHzrCGh1itaIMme8IUkyqYKxVe10/CGSKFyv/pIB3dsAfMjUm06T4L9wV5bDcmCEw3FOscsXyNpi/kSxKE+V1Ne7HjJ4rbQMNFRdGVNGLxKUNn3krn1Iv5ltHCtt0QP6tYgZC7h01MQgI1vp4edDSbEiA0aXX6liYbTj5Yay3IHminMZcx5aj0wkiCwpSSMCRjU5i7cuFBLbEoJQBN2jJxUftBb6MnOa4JLYEu7X0YQe44UXyWG+ICJQ6bAhQfwsv8biAfDc3coCyAtsxGp2Y7Bk3oHTvcQLs0Q6CZGEJBT+pXz8iKSV2EjTnvBWfoFKEDOHbD6lPV1YTIZEPlFYDFOaB2VJeSKkWO6bejltVBj9gtU1ZkMe+TN/KC3+ImPUcxM6x7uAt1JuE3dGcZyo8zC9bBpPnJjXTYeYKQ0WV11fh6UnRNAPLCOBrcmaRuyLmXzQmRKIp/WsYSlL31UyRak26FzFRcKjS0dK45PvKB6JETb3fLvFdI19JyoZU+qICf7U8icQ1tGTFDjyvN6KOMhBDBiJ99wEd6U+fd3Fx8A9
 7Ejksgy8
 bY0kmvSKYlMxdW27aeSiDtcQ7ROhHtNIuVP7RnFaYPzYXxHI3bpIayfsyR8qhZ2wbRrvNXuXPSd+REye7hkaCAMU8Q0uoBmUOVSr/BMw3xHJCb56yE0ewqVTt4PV4fPWTYjwS5tlnU9JelOk4Q7w96+rvJaDqqdbKTEjVu8L2wkXjvuN9gHk29ocJy5wZVgpSFBYwjYTJwPCKZ8rhURer59CCedRtRIDJPWF0hZi+QbQaE2It0fefnW8CASJu8TM+v5MwR1hU84v4n7THsfwGReWxM/oLa4zSL09NpNnaK4zBhYZwAsJwdC6dJpy6Ya4pcGR0effCLS4zrnkYvHRiyoEmbIEJ5Qb+hz49/slDZqhHrQFHHmQ34uI9qIx37Ry/hDYOFQe4Ihp/X7LUBxJ/V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/12/26 20:45, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
>> Introduce vma[_flags]_is_mm_backed() for the purposes of identifying
>> mappings which are mm-managed and whose contents were placed there by core
>> mm's own fault path - rather than a custom ->fault handler - and which core
>> mm has not reserved the right to discard.
>>
>> Mappings not managed by core mm do not fall into this category, as they are
>> populated by their owner, and nor of course does memory-mapped I/O.
>>
>> We exclude fixed mappings as these have a layout core mm cannot assume
>> ordinary fault semantics over.
>>
>> hugetlb mappings are fixed mappings, but core mm owns them entirely, so
>> they are explicitly carved out as mm-backed, as the MADV_DODUMP check
>> already does.
>>
>> Droppable mappings are excluded as core mm has promised it may discard them
>> at any time.
>>
>> Use this functionality to update the madvise MADV_DODUMP check to test for
>> this rather than open-coding it.
>>
>> This replaces the VM_SPECIAL check which means it no longer checks for
>> VMA_IO_BIT, however this is safe as we have established the invariant that
>> mm-managed mappings may not set VMA_IO_BIT, so we implicitly include
>> these.
>>
>> No functional change intended.
>>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> ---
>>  include/linux/mm.h | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  mm/madvise.c       |  4 ++--
>>  2 files changed, 52 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 2ce68713e4c3..55320cf2c525 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -1738,6 +1738,56 @@ static inline bool vma_can_merge(const struct vm_area_struct *vma)
>>  	return vma_flags_can_merge(&vma->flags);
>>  }
>>  
>> +/**
>> + * vma_flags_is_mm_backed() - Do the specified VMA flags imply the mapping is
>> + * backed by core mm?
>> + * @flags: The VMA flags to test.
>> + *
>> + * An mm-backed mapping is one managed by core mm (see
>> + * vma_flags_is_mm_managed()) for which two further things are true:
>> + *
>> + * 1. Everything mapped was placed there by core mm's fault path (no custom
>> + *    ->fault).
>> + * 2. What is mapped stays there until it is zapped or unmapped by the user.
> 
> I still dislike squeezing the VMA_DROPPABLE check in here.
> 
> It's just weird semantics to squeeze pages that are *managed* by core MM (#1)
> but are simply always lazyfree into this check.
> 
> In fact, core-mm manages (zaps) these pages, they are really just just
> permanently lazyfree.
> 
> Open-coding "this (DUMP, UFFD, MLOCK) does not make sense for droppable
> mappings" is IMHO the right decision, because there you could say
> 
> "dumping something that can get zapped every second does not make any sense"
> 
> "placing pages through uffd does not make any sense if it can get zapped any second"
> 
> "mlock'ing (and thereby allocating!) droppable mapping does not make any sense
> and could actually break droppable semantics"
> 
> Not a hill I will die on, but I much rather have the droppable mapping be
> outside or  have it called something nasty like
> 
> vma[_flags]_is_mm_backed_or_droppable()

Noting that that does not make sense, as we would have to reve

-- 
Cheers,

David

