Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DCD4C79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6376B00AC; Tue,  8 Sep 2026 16:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595B06B00AD; Tue,  8 Sep 2026 16:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45E7B6B00AE; Tue,  8 Sep 2026 16:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 185F36B00AC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:08:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A0CA4407BB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:08:42 +0000 (UTC)
X-FDA: 85191682884.14.89EB53E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D6C88140019
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:08:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NlASPuvf;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8M2KGQ/Rdd7X1qvg4n3rsyBcsIsT/58MPgOQgnVvrcw=;
	b=eRAXI+4Cm2BmSPlv13114yNUtO7TI/UWDfg8frm5U24OpZguQniO5dg2wZwC3GhCexv6zD
	+OQD2kfr9odmPzFDN137MeBTLqxdoNxGdWOMCMepMEYf6mSxCCg46j8OBXipXFTMW69C2z
	eJ4fZjyDGWJHwwYTGfiFiiRHRbxwwic=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898119;
	b=n72TPIWiA2C8AWTOaeRmxTYZ4jnL3WGsC9z+8A3DYiIsSrtzbdx3ekAmIOw2C7BpcvZJDh
	kBofFWqnjvE7LHPavbp7ssb2fNVCTWL5nfCwtNeiT66ILUz9TkRiB2uVJVctyH4PUZWNF9
	8DB2Tdr/NVYAbxU/p+9PhIDxbedLaYw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NlASPuvf;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 525B7601F6;
	Tue,  8 Sep 2026 20:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082D31F00A3A;
	Tue,  8 Sep 2026 20:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898119;
	bh=8M2KGQ/Rdd7X1qvg4n3rsyBcsIsT/58MPgOQgnVvrcw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NlASPuvfs4H3JIxf4W5s8uf9UD5hDKleqbnI+oaJKfZsJVnF/y2v6u5ZZwTdOqjXk
	 YeSA64QfUB8Dg7K7sHUpwpK7nOxobcWUqRFBzZHQ5m1pZ4mnoIyXZ0ukMZBT+4Dadk
	 9MFqLZ/F+NGk7d1iXYEtgPHXQUyrVf8g2K5fBjsWBlm87Qr91SAxyG1iZK3I0QdlsE
	 rufrzQZHA5jgiE7aazRN5WnzQBFmnsTQsLjyxmMBs0ok1z+BMQanwKaU6tSgZgbfeQ
	 0tRoGU04rqbhv2hAuNJdjt/7v9wGGCnAromOCPh0TRFnyaN2Pu1c8j2iOpAy9AWK/1
	 AqgCTn0WT4UfQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:17 +0100
Subject: [PATCH 13/39] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-13-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
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
 Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2077; i=ljs@kernel.org;
 h=from:subject:message-id; bh=fdJtBNQadhST13A5/QqOS4hxZn92kbQM6NW+rZ1tlXQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG66xMrArN4c7jCJMXVipdQSDo1pk9fLeDIvn8Tv/
 Kv7mfuMjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkxx5Gho07Ve4KtFZ/9BXe
 vbpxTb93we9SAY8t0xM81WU81ueWPGRk+N/4KMc9ryDBwy3/eNcasVOSaoUc009dCu5ui0jK6Tn
 NCAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 1zhg9aqgj4zayfxtmj7o9tkp9ttkmkhi
X-Rspam-User: 
X-Rspamd-Queue-Id: D6C88140019
X-Rspamd-Server: rspam03
X-HE-Tag: 1788898119-737803
X-HE-Meta: U2FsdGVkX1/3pb4IgC2K5pTMBxTFQCFjKK553nsYrRFjSIyw+iBSM0ISMEGKTf9V4Cec9FMagHNM5ZLjqLF7eoSNMeDlVlvOaenX6aiKY6XN2bDmSgC+VXqce8fxhv0O12bAJAxec+Xr4J3sJs0yYFAKVkLEQGu5gighxSMXqDTsr4dg+hPOlzyxn7pne225lj0/P6VyXaTiykJp+O2oE4ABLl0esPPXzG994RHXqlmMxYcTpx667paVfbcZ32TnwdAXPijDX3CLcS5UuIEeL3w7RPDWVwP4hdhJLUv+hfPFGG6PKVj232k22d5oUXHu1VGcmOi9Oye60/PV2AntAQGKut+JjjCcH3nAxCq642xhIavzyr7x09cqrHoGVNigXkhUsB+Nesik1EpY88qak77g7J7DQVlsSRcMcrm8+Bpb0GNiEVhoA9h8DJfnAs56nidQrUGAjM9+IHMqX6se52qS0+gu+HjdwHY28rZhdlUg0Ibs0COAvHZ676eS25iDf06fdzPFuTuVq9MgOYgBoeyki74An2mrvTOikuR5cvgUGoSY4OZlLUz4FCCCTs7Vra8O5f1nf17qZoJ5xizddElvwcYsbiNXOcNZW0enRN02DXmINe+xdgZ9CBHiD+zahdnix47s/Cq1et/YrL+HnHsFzU+TiGl/eXRyeILnFnXr8iWSjFrj23uA5u1Oga1jlj/6dc0rsQxjIa+s3uNMDZ4n6x/TxqHcHVSXdxXvHbjRRmuh1IlvbDjJplU7iX1VRDFG5TZdqh/j4knbInxmMfcX1F1rzTRzIkJMz49M7OibjSg+CXmyC9QoF1cknfVOXtY4wSfWnWVZ8KQ9CZo8VtnisUmoRC59wjCzYuitO2RILY/0qYeTaBMDj3PiInQpLrDtLXaVFa8uI6HOWIMDD932X2oX6/AmyitvteVi/SsVcEELIvyU9ePVV6aqUiUr3ek6Hecf/HTdfXpwDFz
 bPQfQ7H4
 lK0l+YHNCRfaP0ek3Ln7NOVaBXOILUQuM4vz/Dff+YzMIlSXR7BngSDST1Uslm23p5piW1w+lQGUF8LFQXq4SMci3eDJFJ/XIK8Yv8jGEx8rIu2qJP+hXuWy+EhqrzmKbpikpjvcL9eV4FkGShcn5Ir1cAhVUq9LEaGEVqBUGpO+YSuNvtZrPavRK1vvtJlrRdUrjegmPOoE2moj1RnGWB1MJDW7pakVOlsFL+jL5TgGLWHePKUtAsJUvJN8BEyuc+6AMJLTe9sL02SPG5muc5hZlbatIdmnf1dpuHuJ3+0Vd8My9JcLm3xGcK0C0kBKYy6MG6uWPJPo1iPyWePMRP6JSw4kJS+Sao/b0h9wfz2Tw8c0FjVdfZTwM6k1yAJoadPYe+6UAIUE3ufHxi4k3UWvc1rs54dPqg17jiHgzH6KkJpionh/TNL6x46RYXowpVVQ3WzbIPYaBOdVHx96v/1bm7YlJQOTVBvf8cCHayduzN7ZHosqNzhyZDhXcn+JMee6ISF71ZULVSAAUZ1WLIPo7pY621XCxMaud51TP/1dBdaRr9W82EXOAXb+75RWGfqyObJd2vX17RIe2tOXshvzqIzyI793Yfo+0puNi+NfIgJk51ByQ1ttcDdrewJKB4AiMuz8FqC9hErMDQgN+o1u9779OTL8eq2pX+l70yrxBj34GM77nj/aPWi9bCW1CrikbmWTyFoXSmbXLzSrJ2VJoQgvO+UDo4LfYUnUA4Nmg/XpN8kOmSPFGpNbCOs1dTiU6IMQYy4pjmqorTWL+DRmNbeD9llhvOH3TbqUvElZFkH2BEWnJGT6a+MGpvU5urZyM3uZ7ru1QH3ou/47YwOPlNG1cVvV+Em5rH5+Rp5f4OZn67vl4OmFKJKm8WaNoQoYaB7eKSpzQ8KlFzNmiAuWqFibKh5V9HAEi7dZ8IfgeDYhIoLBNBklYb+KuO27LyPZM4q7OOjwzq97/pP7ca5WkEg9b
 wCvbo3bY
 pT6nZBMrNSnvm4QpXJAY8uJOn0RMs/rO7lspc5McwAWX1N7C7/EGGl1ILbR62DqUv8G2rPwNjtQgXZnhfrEuSS8kLZGOllzM+W91ky0X2hfxtr6eA4j+HjXdlqxJ7sah+4sEPLPchJbl990PcsO+tXZmnN5fA5fv5FjlqDOVDcWZR9a5w0nr0/IQtKRvwNv3BQnaRC8Zmx5T/ZBhfNmE58M6YNOM+lM5pqLexJnubP8+8gGolyjYCIstGLkHB+xXLp4LmSzKIU320YVBFCbnWvHD2alx6a2iLBgSYXSE3zg175PVj7eUA+oc27Bbn+tzsr3UPuzTYMyZObzAjldSC3uZD6XIe/+hdo3KH8DPaCGmKfZT9+9necDYZ7oobbZWa4u7eGn7Sz7IMfh0fcNt62kiHSDZzTV8p81dk1xaIO2uoz30GlN35kM0u1tL0sn+qPIaWddC8Zg0oJMinlPQmobXcBkyAk2+Oh2o9JE9IrMZuRWdQsgBcqXTtAcUaAEneari91JoxQq/lBcgyk2eGlLZUMRJ4kLeuz6y3BcP5JctbTMJeDzlO3qfNDsG1yMZz2yTNf6NVhIQO5Qepf1L3SO3Bqw7z6tjQ/6jgSiHEwJe+X9nldJ4GSYs1PASxTs5FRXStwQOpsaDjynSpqFL+BShoiEWK7pN2G7GTDx6KTRhgnSf3Y7Tu3ZLpQIf2n/zleon9BP+Hwe2IYlBRplfyGIbU9OFczaRzS/8M95snZjJrKBXD7PRiy3W9mCqyyryh1B9La+UADoe0fYOWsYrv4Y+t2xl2/8z1oXfMWLTPng/dfkUbmuZn1vn4iuSXRBz3BRGb/0gaseov+i8DsAYnb8bynSEX+yQEBjcww4NsCePf0ATgnjJxgY9mgcwgGEc7nYYDfVnD19LmKwXHpkaJeD5smFuoVPm2NuS92VU6NGD1mhaeF9MVgEJF/2abOfdBDIP8ZIpL9NqQ4PgM3icGdSk/8Zge
 vzvE3+xn
 IL3n0KHadc2AVo43dHeeskeqK6okQmIOKGNEaaWG6vqWCm+pZ46uxH59P0DQM8SbV8nE6OHJrczuH5N754TebzRVSAoJqxf0mRfomBP1aL5T++jCMznUU2T0K571UmBQG42Y8MvTycwZ4dGx6ZxYUMfKhPgYHyJLywfqFnOUpEl/fcDew6viG7A92L/33XnzhxrmAzjQJUQ1zQ/hYEOjAoK1hP5RpbAytXUbK3oy/WNI+fDEoQ2hqoGuhyL7O7ViMKsdi7Cck9sttdgxc9Xn/ZrkliVFbU8a9WkaFhvZlFbRy37RlhrOMnOZP4W7qn8zrfCPCnoRvc9Zce1+XHA64li2nejTb4mGao/jRTMNyL2LSx3G5kze2VvxEQNDT9E44O+g1gH8ANSpB50za4MB63LPmVvoltlog9pQ1ZjpmuG+yjjo0LBgAShfK82mGDD2Xk1d+EC3cZWk/dFu+rNtiXlZuGF4U2zd8tlwIozzYY3WS7/+5mnoQJyri6L6rxgN8xDpKaoheByCp7bkU1LLI1G/vjXmkLo8t5OtgT0VGbNZFtkLcCmvWtNsatvl/io88c7J2ObIYbJH/GgWTlaN6FV6KiP9H9uSfctje2ciTWVfH6Up4cuB1B8ocbYqs/NJQr5FNrTO83I9e6+z8Y4hXTImw4X9E2Pmg5TiVRH/12sxA3AhfB7sqijKL7n4HWWwg2ytLu04V4KMbaywOpMkvmIrkY0DF4pEOtrfAVeU+6kCM/Q7xfecbZ+mQmQXiZl863xEtwOIYqzjCe8L/QHtXmpi8ONd9sp+3Z4CDf1xVCZ3g7kPOwmRLWrCLeCEQKRgFFp4+zpvp1SZpRWoU5DPalLei6Wyzzlr/6mAGIi8qG0deUt4bsTfgjXsWrcBWgSJAd7qglf/XJeujPWf9v42t/U/756bNpK+EJmwTrkn7MHHBzbKjWUe+ASlI/iR/c5nuTem2e1cVp3/l3C3U6EMDlybNfZML
 qzl9jcwi
 a24M8IbCbqlOwRdW+OctKhFvoKkxzDfJGCLdw+j68HpnFW+xffXhd1IoKL8mYeVLpzoPabYmJu6J3gqdLbIa7Xtzi0fxCkCTcIGUlDqWdDjLYcQRdYD8Q6T5expooVjTOnEMG5AusqrQkpEwFKNVo9rv/RmkhGYFjwGVXccFEZgIDCThU9iA3eM1ciGMEn7ECbir37S3AAybiyGCJODCDfBTr/o2laYC3rjTSDEaNiX+qeKkNj7TySvvJn2/mPAfroio27BPmpn4Ezlp2r5K6D2o4aNeE/U0YGfwJl1W7ETXKj3G1DGVw4xR+TybNf0aahXf6JTngTN5L62E99GCyz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set to
one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
or arena_map_mmap().

It is convention in mm to mark mappings whose pages the kernel manages
itself with VM_MIXEDMAP, so the core mm knows not to treat them as ordinary
page cache or anonymous memory.

The map_mmap callbacks ringbuf_map_mmap_kern() and ringbuf_map_mmap_user()
use remap_vmalloc_range(), which ultimately invokes vm_insert_page() and so
marks the ranges VM_MIXEDMAP, and array_map_mmap() sets VM_MIXEDMAP
explicitly.

However, the exception to this is arena_map_mmap(), which doesn't set the
flag.

This patch corrects this and updates the comment to reflect it.

The pages are refcounted and vm_normal_page() finds them regardless of the
flag, and VM_DONTEXPAND remains set (marking the memory as VM_SPECIAL and
thus unmergeable). The one effect is that NUMA balancing now skips these
VMAs, as it already does for the other bpf map mappings, which is the
reason array_map_mmap() gives for setting the flag.

The intent of this patch is to be able to establish the invariant that only
PFN-mapped or mixed map ranges may clear the VM_MAYWRITE flag, as is done
in bpf_map_mmap().

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 kernel/bpf/arena.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 7b6847200b43..b69fe5e34339 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
 	 * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
 	 * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
 	 * being copied into the child process on fork.
+	 * This is a kernel page so set VM_MIXEDMAP.
 	 */
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
+	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
 	vma->vm_ops = &arena_vm_ops;
 	return 0;
 }

-- 
2.55.0


