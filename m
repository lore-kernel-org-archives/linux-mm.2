Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87DDDCC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C09F6B00C0; Tue, 13 Oct 2026 11:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9723C6B00C2; Tue, 13 Oct 2026 11:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83BBF6B00E0; Tue, 13 Oct 2026 11:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F68F6B00C0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:24:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B588A0AC3
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:24:58 +0000 (UTC)
X-FDA: 85317975876.10.667A60C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A86272000C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:24:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TI12Y69C;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791905096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdfilYnY7/QJRyyrXDcc+D7C64Noa2vFiY13x6gB4tE=;
	b=zG+7mJBwgpc7IVtya1vkL2Qv6mcLLDCbatRaRfXQxRLdBk/b52+xO1PxK6xpSBORXPRLux
	Cu7uKa6gw/98ME/u+qcAg03N8LJyn9/QO5jdbObu5dmTilBiSBsgNMUHgTjSEzZMst6QnW
	aF7phdu4CnshtO8rGlxawv6zeyCgqrU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791905096;
	b=T2wl0x2VwUFDbWuXs0nRZ92WRONbcal/FV2tVXSQMhGPE6Hs3owY8Y71WcdpyDa/ajvu6u
	OsoXFMkwkgmG7iz8bW+rAbAA7Q4+fNAy3Qso4QDnsg54C1UdJrJK2MimEw+l2algqpRiyB
	96brtU5xSgZUMf1XvguauSOBTesxYf8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TI12Y69C;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E4E7B423CD;
	Tue, 13 Oct 2026 15:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304C61F00898;
	Tue, 13 Oct 2026 15:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905095;
	bh=cdfilYnY7/QJRyyrXDcc+D7C64Noa2vFiY13x6gB4tE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TI12Y69C2azQMxnJdGWVrYHFJK5BQvRwIE+Sy09suheM063XciXKotKazifkjr1cs
	 OgrvCucCkud1a26NQPuA/xvn6AO2KlWKlfrtalTFNFeQbV6n/kqhaWcKt5X6M9qTRP
	 3PnK25qmABodKKTOgSKlufaaCeK/XnURL2LqntblJiyaNxWbnLRdQS8VE0/QvCKw76
	 2QitzvHRYG9X2xOTc4IJWRFlwQxieCwg4EvoyqQ8l+76JsVjvDYeIKRlsSazWOAnLt
	 uKIVdZrF9drkwfDNDBH8oRlZouDFNGbSfnY6gMtNiJP0NvHzEiHtIGL3Sf30bAyVbM
	 /YgQBMIBb9Ntg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:16 +0100
Subject: [PATCH v6 36/39] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-36-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1785; i=ljs@kernel.org;
 h=from:subject:message-id; bh=61ufkRP/9pZdXyLGPvf2Hc5mJmJahJPscpi8fMRGHAE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZx9139I7+4UCYUDC8usdX5Vl3g/eMt++6n/jAkT4
 t/dmxnt0VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJXH3LyNBTe4fNsuKkwPM3
 fTv77Y5cXS/xYbF0n//BhInmEx6pRb5nZDi43Tixxu2T/H0t97Ajv97tXsbpLqwwVdefI3Lli1f
 6vxgA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A86272000C
X-Stat-Signature: q6uzk6gcb3pm1iabc791e4wp58gbftx9
X-HE-Tag: 1791905096-623079
X-HE-Meta: U2FsdGVkX19oQ0Sml7GIZeBcZ9O7kJSoyeKAXmVZrIi/n7Dz+jkv6GfbXZH0ChXwyNdx4BV9lzXQJ9lXiV0Pd94BamKZSOHXa8G7gXWCPBs9UcQZETwHUWTwSFkq9OWYBZT8CYHvjbqMg66llpIdwJ6WvUFVA3gh7vMfNPD5mJpYphzoseYSMfxX24jFh8xlfEEXAFlcebA79sD53TYrhYq7E+9Ay4AFswGiLTG1lbB8TJOnZ5v3VeKoYZB6V3fANK9/kW2Q5jtVHq/HFfOOAa7jJvu2gnhW3T8LMs1PIeZ8SXX2Ap73ps3hP8/bAwCZ/i3LCM+mjI3lGgDnQAvVDlo2zC27RBoD92dwBBTI4qBEgL7rQXmnMbhPxt2DnoL9y5NgtMGfyz/fC1A7JsX5pOeDPNUXJScmttUYyd6CGEJGwrBW0GT4cOuXqXVBNfcYpLRtOXv21JQOKsDDjdvIGW7fl4rwREnCEdKGCkEPnWrkwggWrknlX6n7xWY1ypXuCbCrIuUlhN6nxLcT1j2Vx87js8jwSRzlL6HjXFtildf4RO9rJI79js0mdv+MOwxduR57P4zz9flN9yi2cAHov2xoervWTKRfPYwCTtP379KNAlqT+cgpQJDMDKRHsWCDSr/8vgepmM7DHR/4KSEY/opg71y2ICep2w19IH8jNBFS7E0mZRecPjq/Dj28fqDPpniElw/wQ4opx1PEh58OL9YvJ6vfOZh3+RPELi02mS5BxnYfuejV237yvT9tnpik6Og1G11CBtnwX6toxjyKBogFS5LXcW+PTvTKB6Nc/hL6kSWH/3Q+SS08AqSUnuSTDTcCfBcoGeupb+IjO0yarAlPEh0y7SK72CblQL5HPQ5CqyrIVZQuMm+4LEGxhzefJEHbRqGw6wZEPhFMghLQwdTAw9kHWiC+pX57tPVG8JRvOlHSmC7De+4HuMxcjlhwGOqKpToc5THtQ20JbRZ
 N/r6rpls
 kZZ17CpsXJJIuKAVpO6cFi07ODkcjudrQCcGRtYyi2bKGZBgrxk73lXHZ3ejCcfCbEfoFckehNYbTJwsYpbdgjeXeJ6SQ+KZrscSKNgBy9WDP5Pl4ZXPsS64GAC1fmIzu3MJxeyCxS1dQ2X0REm7s63+MusJA51PAYZV9CuPrbXR5UFTyaNYKCBm+OHAeYYJYG5LYDY0rfJ6bgItuP1Ff+0tQgy4A/LUqSSZpxBxTJ6+gcJBY+0LaVnOyQm5JGSMmPgCIj5Af9d8DU/IedD3BjO4sQaHI9ktcD1HDWBzRMkX6TmRgJ03dtp65Nui546n9C1wvQHCMTVk7qmgadzb+93RLSyMJC/resgKwKW6fgICrtW3rUxmQEqaO+GQJnFfJQITI7mfbaG6pQ4vf28q/Gh43UVc5PfsVk7cpU5sVMLuXySTY7a8j5dmmIBlEIHH1goNZO4+2uOGPNG4YjZGmqTKPeFI/hR1ebpnCjqL/r+/lmGFOjA1G9tKFRCkq0PQYs3hfq28/YMDzYByKFoCxsiDX7Vuk5dLj+/l564u7IaglZGrt7Ni+vYybuKoirnUV6h8E+Nh+vlLb7HRwo6XW9HTPp7h/CXgwFX/B4LJi0dbb7rpoFEX1Sf89YaK5Rur8ew+AAGgemd+G6/27SyozI2XxOOBzvZ2rLMoPzM5gA1xEeqxUToI1ETw6KXaUNkXXjiNjFViiNBQUWPac7FU74eaa8TMLf0GVOFWY+talp4fBSIpVYZ0jdKWN6Al2i9Wc2g1+kva/PC9DyRdIndbdJKcJgK+khgEA+YX9oOKmbrkVwYyEc9BMWYYFWehjEHhhRFXNeSk2eJic/kfjGVX+eJCMFZ4Ofdk/DPz6gtTV440X+a4yqg0R1R4ZkuUNVVFhK9XjckdDA/rkcrTJtgu1hkYU9cwxMQgMmqz6otYkGXG9MhWwUtrZ4IvXU+WsqHWocZ63+0t2Ymp8UovZlHmua1/VqzrE
 6osgjY8O
 uZSK1trBMEg+0Q8CiZUlXC5vL7FoCkr0wbHiWClEwcJugDOUTMl+iEtt40fmdEAIYPGQrVJ7wp59pMxlRHPPvgfySoyaal7zzzgcfCmzYyZL0MbR7XFGOX4Oh8uZAYpuAqZaZ+Kjco96/x+eGgKWKETvRbOrm6zt5Pv6C0CcfGzcOQ2qE8cLX1dur1k40nTu2xDsMPCmftSYgrH+bUqZ+dr6Z/Of8hkGBxsP1myk2rcL+VURbsASAjql1EB3rI/6NokvJwi0PjwBK4ztryCjSR8L6R5Wg1ZKDjOY5dIkk4tdCOaH2x8ypfeEG1UQ/9H/tW26BAsM2mDl2MJg6zT7nsb428a4TGW0S+IHDNcOqzk9B38GT+Wh/xuYpgKbFmM1fK9nOkSN4SDLyq1CP86yRgS0HCT4pps3rjEOs0h8j61MmrPYZOj0abLjrnwBjWDgoc2If3HSH3CpRR3IN5PDX8sIIpCYpyNH8x35PmjtEL0JOSJm6omMiCv+g+ozpY4ix+d1DrN26O9ZJSOIhuJ6bhpeY8BwxTkxFItQYx60BbmDZ+U3DK2P2Vtvg5h+neSmNV+D/cxIJQELcPdRFgVKV8+EhK6MbrGtg9TZtTaLE7TDDEifNG1TEl1Rv/3rBefl5CXBxGNRGKFwi82870ABJAfs2GWlqc//C+hCNK3f/DIB1CNJfUV0wcW4Nf+5yuKbYxopnq5iXn545K0Y48Jnzx1KlDlQCQvpnJYSbTQp0miqt4TX/1igpQ5fqsxhmTr1WXagRBxKxtdcwb3pzAXYgzeUwjeup2oMXl5+SdgnkyC70G8JWxFG47mOku61tGSgdIns3p0NBH1T8k+7Mz7f3+hGH/0jB4FczaEoSBQ5wMlEfvt4pTnNhC+wcUuxY9KI5JHuCzj7bcMsKyytFx2sksajQ0dLeCJIsfCr0NRDWb+7VgOq8VxSps6DDbHuSce/kx2SZnC50rJiCgCD0w6fK4SuPOKM+
 NnQeGmcd
 MBXMG2MBZ9oYI59/GJLWrBFOBY97Pc61BpFRELIiChkbvGrnF3lvqGr60Qjs2U9b2QS1Tle89N0ZNL1FSrx/IsB7Yd6HtG9HA5sP0MLps5zCQqoR/y+gALMZTkiS2SO9GXD6gT+nTY+jsSLgaS/rNaHYOUDRj95O5LKKZfGwEetNMmobesQUcsXxKEboYgo8pMPee9JdPonrUTJqC170NHwz2Q2hBKHGgAEuxL3o6pbccfLlgT3qidIJ5+qZI/mlTZk8el8Z/lFjKjRUQIAfW4qXg7lHntsgju35Fez90YrD2PAw4j++8lC2vi7kiHhVjsd2VmVls2Wt1nDzyUCzZkeropXUVl8VHI9QQb3qEdMDgqqRz6JtD27EzPb7MB0jrPkVP5dKUaVvwlOFfN0AFmN3y/Pr7MIQoHYX3+6igKqLiv086E0w3rauUEiXV+pwPuvU34Wxv3vwQuGUcBWpS0KJ9bN3jVtVQSWosetjJy0z6Ngnnk0hpT1ucFZsMIKPZywyWkdVDAQ2ES/+jNrnDs/xiHRE1YZxiBMu4PSDgjhR52FyhkIoDtgm8sfRbtRp8Z3xoRfmJUNWBy03UVTWxgrkYuAiX6C9mQ6XUhGTZTKW3ryBfyKNsAr5MQGi4J3q+/tg8xbwOsb0q1OpL2Vp9aqcqOMrMkBPskIPB7lQqMdabTh+jfyc66noISpld9blGe5+rTydDOxDli0Oapp1AahwG/PyuAsgfoAxt47p9/Dk058cdXKXGOMpi/aqM5lsAW2+ILSMCQPiCi2ugZZpJPi1hGY/C3dFEQaKYOlk8Ih0RtKGWXFkAqQOLeZkkK+89/jnXGtX3b7prIeUmzJB8otP80ZS//qPbodajOz1675bq4NqasCyqP0cjPsW5HwwFk+QHFXaH99/q/vLPEKFaa01ubXKJtlntJQWfvxP5qRVImmd5OH3643EdNATneECprA49xZh8mql2cJRwvVWqCvFiphHP
 infwT1ss
 TS5zWctvS1k5yxcv/1AOtStiVL4do/WymLZu6AdrBYtmNWTFmMFL4Q1HBQtJGgikp/L50kjp6hScF3euyH8HKd8yhlCkUJTe7MDCkWaeo1tTllV9HCqEsOs2/vmEPu2wJhJF/rm5r2uRjU+iruDDRDkD1Q/xLWHxMvF6pSYDzDx6SClubme/cLNB7PxBZYx0KMqe1KQhf9wU+zA4hq2f3wYBsjo277cmHw95m1G7UPxTBP9e7MOlFELj5dALKKKUjH9NR20fG31oHtlsg2hWSqhMhnjl2F1GAsWJhSD2/bY1DIK6wyePf1GgTKfAOpFmEEyyG9GNr33J8H4roJ0IeElRieSON+5EAZHm6AwmUxDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have the expressive vma_is_mm_backed() predicate, use it to
determine whether to proceed with migration. This drops the VMA_IO_BIT
test, which is safe as mm-managed mappings may not set it.

hugetlb mappings are mm-backed but remain explicitly excluded, as the
migrate_vma page walk has no hugetlb support.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index b9c453c28795..9e19fadfa65c 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -739,19 +739,21 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  */
 int migrate_vma_setup(struct migrate_vma *args)
 {
+	const struct vm_area_struct *vma = args->vma;
 	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
-	    vma_is_dax(args->vma))
+	if (!vma)
+		return -EINVAL;
+	/* The migrate_vma page walk has no hugetlb support. */
+	if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma) || vma_is_dax(vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;
-	if (args->start < args->vma->vm_start ||
-	    args->start >= args->vma->vm_end)
+	if (args->start < vma->vm_start || args->start >= vma->vm_end)
 		return -EINVAL;
-	if (args->end <= args->vma->vm_start || args->end > args->vma->vm_end)
+	if (args->end <= vma->vm_start || args->end > vma->vm_end)
 		return -EINVAL;
 	if (!args->src || !args->dst)
 		return -EINVAL;

-- 
2.55.0


