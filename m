Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3923C79FAE
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984926B0095; Tue,  8 Sep 2026 16:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95BF86B0096; Tue,  8 Sep 2026 16:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84BBA6B0098; Tue,  8 Sep 2026 16:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6007F6B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:03:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 047C5A52C1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:03:27 +0000 (UTC)
X-FDA: 85191669696.26.974A859
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 295B61C000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:03:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ku2gwpBF;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788897806;
	b=ZbR72WB59HxLkaVm1BI0bO+vI5QZqwyfdAKVxgSBTHXqzv08ChghIRACtf3Uz0IHAyiQRG
	nfiXundGTxvMT4HupC5HHoHMJk37UAoQfTU+vUeXVFLQ1OXq6OocXvFhK1ktVcqGOl89EU
	l1rsy3Mzvk5T0uAH3zZYiDcU2e99Hzs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ku2gwpBF;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788897806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/5irUa19/BDN2FcWAIdugpCz9h2TSbkek/eDpHMNwo=;
	b=K2ElcPKOO7/Qavalq4zxgOsg2gYhr1AamrPKNLu97WWDrIuU0rCeHva8nZwnDuPjqnW+QW
	CUqmTgCTG3OtoqsZd22ANR2piIs5fWLKgrwyqEO4GOKb2yVezsEhxuiaFAi5uqRFzQY5Xv
	wF4sT9mzmVbKdZG59PPrCKxQ30shsjM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7800540823;
	Tue,  8 Sep 2026 20:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BCA1F00A3D;
	Tue,  8 Sep 2026 20:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788897805;
	bh=N/5irUa19/BDN2FcWAIdugpCz9h2TSbkek/eDpHMNwo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ku2gwpBFwbzAQ9WpRHCfTbmHrqoxH1O79eE6GJgUgEmxCzV2zSbqhIvZn3z1K/LOW
	 jQtxKcljhwwX6BHLOw0jrP1qLbw9bq481GXnBDTftZNwaufIQ2FNDR4wdA7+QSL/+n
	 bOnrpLTwrkyLBdXeZokkp60zx/ExmXt6G3L40ulIFvnIVT8Ju5kOVZ9/vbmWVJIL8j
	 V+DXIhJB16u11Zkd92DE8Mm/4GX5O1l4UCk/gk8xTOuqXTcGQ655Gwv90CaCup9Eoi
	 Ml/J+p32Cy5gI6XpNafasUy7A7/vLiCxm1MjWPRev15TMj9H5pIh/hgmbhtufTj48M
	 Et/8nwZmluVdg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:06 +0100
Subject: [PATCH 02/39] mm/vma: introduce and use vma_[flags_]can_merge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-2-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3665; i=ljs@kernel.org;
 h=from:subject:message-id; bh=0UU6lGSovOVzdqVhnWVD0ARbEiD8RROdurC1mTuwfD8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG64vd1F9WqzdKTnan0Lh2BNLUnLtmu8U8UdzksrM
 Z+OE1zVUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIncn8zI8CNQ+Oi6+/Y7/5sd
 f1oxhWPnFNGGvybMWvt5247edb5wxYzhf37AUbvU9ayqj7YzrBEPP1yw45fFhkwVTbkIIT35+q1
 /2AE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 295B61C000A
X-Stat-Signature: frdwsw89nqj1izuigtnc4wf35546ymjc
X-Rspam-User: 
X-HE-Tag: 1788897806-226016
X-HE-Meta: U2FsdGVkX1+WZoIbeLYt8RFUrnsejhgSog86kPuVdTd8Di7OQm5O3/w9Gm7MtwG+mu+L0BboTnDUttjLxbqlwBhD+IMkXB52+QF7Har3dA9JwLZvmuO8yR6M1A++MmtR+CzR8aCdiw397ea+DeOOJa9R6thddPUutXZxCVGo2ftRM6Sg5zIqvM/nHA4Tv7UiR5A+3lbtRPY9+wKNSVw7XYiovKiFJ2gpy0m5vADvqWXNHN57fEcm7fOBu7aYivDmKN+42Tj+IDap2sKSZhy/sKzKYp0DoNb53CLeIWbkhdDqlG/nsbXBWOIHkotQmHD1hINetecdfM9p8imfPlJQ1LidaX5C3j10wfqtf4EWLtJtlVavzYfMHKxEgkfzTUAuLi656UdROvZQLZzDFfYNv1ll4zGE9lUzpX76GCVqG8xc3iLB9VE/cLccMB5Xu9w98YcHKQlig/0de84F8PnUugCRcE/f2PwVG9Iw3xFWRfQuFJqlvW8Nuyy0vGQnt8ZWfsfHyd/WDLRCyrkZGu5eYeNLq3GNquZkR5uihAzxUPhvc4c3z06kx7DtQuJ7Y9hdyM/9RYcgWZA70VMqtlzQMNADB6os5wtx/Ap+uCCSDJcyJrvgU2nllmmiJBj3z4tZO14E3FZxJgiANu/SI2OnmN7coAMDv4iuXHiwHnnMgrxMG/5H3VrTXBWE4EfWqyvqp953o8CcW/dipep+AWh6elAvq3Hh12pSzCZK/hhQ3GIxXS7pPbNuq6zlGMZgV9CcDRn2SB3pPNZjtj6x+DJWh/HfIojm5wY+y2D+OoX/iDevWSWi4by2NgLPdZVm6vMpYjneiaY9wV3Z2NPWZO6IpY1h4M2tmLCIAG6tdVLXbz5WvLqnW5OzP49dqzkEEmzpt7NynOjJdpZgtGOCzzzjiAgkKg2Il9nTIvAzs00hsqw4G+bsh/pGxv56Slgg0DZefzbg6QmPqejwiu2daVv
 NtQBYjMj
 s6m+wqhGYwwlZIXKo0SIMJnai5vORXFSIf7mzRzWrWqSePxxJU5NplUBhbCX2+iammg47wppRbW2/BMkSR7bmUiTkwfrw7Ysg8Rw7XlxcfXuddj88s1gt2jVq7Y7EnPTmahRo4Xe/ZaEDfMc8vzYeJtgHgeVagMw7RcaxK+xEMbUwYROlLrURF8NETWqvGtBPtxz7Z2B2kWkF2+rc142XaloIgHzrnH+NEoM8rZuCjp1jVBYSxjEMSy3LLpV8PplQ1tu65/2CCuGMiVWUMVm7phWg0ky9/bmru9f3Gg59/G+qD4RBAvbB5nS2h1dd46MAJY6uwhRodKyK9jXGHBJEICthGYWlTPD3x/9fxAeEQiALMCLgOd0e18jWk4XTFzXjdfamKKSjyUaJDqEQSuIUUTFFr1FajRIHcFf7VpGJZHuf0HMURorVyKwsyyF+4ikspFIv2nAGFZs4Bue8O8ppjla3BfGd1kRjXe/GJasrjzPfVF5sgKAUKSKWRvz+4vOmE4FHcZogW4E4JBqHYLP4skkz7d9UDGK/nlROMri5/MRg4wJR1W0lK6jGLpLc8YeYRY/Rourgdn2/2ofDKHVkupHaPO3SRZdaHa6ix6diZTLYhKIAT8hTicAAmysgJ9Hivx9mSzBV79skWR/8hQ9z1WuVYopcab1cqV6xj2Bg/XxNNEFpPzPSQm9rEe8hDSk6EVZfPfzdM89sNYu+SjfIZKYTbvPdKMvbd+f0+T3ieJQR2Gl+fCWO6OFNdrty5/CjFTHKjFwWiKLJPa9djlJN64GdZzz6TpGs3Xrlo8S2gWVSpfC0X7VK9kDB0MJWf7o0qxAGLRCUjHMJf6nWtRk0HfmtNI/6mT7x+pRUuvj403LABUl/WeYymOpLe+b6JEsB/cGXpaD/vVgKISmlVxFPfLktEnWw/s957tNOzPwi3FQ+wiJOEI05B5/OvDnBP/cRzNkn/fQA5Rmu5m2KYRV0Ygh9JrFu
 +wI9/Mqr
 duoWDKoQjU/urjvs/IptL/ridaGCHbrBEfmHlDNdpxgj7NbPUmI0GMunCzSJhAoTTve32gPie9fpIVfj2O+hDkDHAqmYGWhaUmbgkbBx4lN7PMPbg31wDUewYYi0uhGJ/pxWQZ1itW6vVg44qPGEnQVUwjtllh8++So745JakxLGnzRv55podA820JCvAQtVY9JU2q5jj+EHi70E4byNJrWwStdrOO5eVXBqZmxScWL0lOpEb7qGV6X7uc+Pfic3aQnMHBFC4nm5fUDKem3vPP5SCBPBSh4BHKSovIGS6mZiQ35GojRFj9R/zSVZwZark2ESyR7EcADyXH67x8c+gbv6OaiTT0rdd5eq1AR9apqKgDr8tD3LRQkNhCnoC7l7cUvnCunGThQXLOTRJeT+WKytAbZjEKimd04QefXpZH/jJcLW8Zm2+QlxCIIkvS7RPqsERPvJnyqXSeKOQTkFWEers9jNMurIjuYN7axiEFgdlLDXQu7rYvcA9CvZkw3nMpPdPAJF5fik0qHWctJvfkvM626pumlhPZQLK3lS8LgmeOSaY+gUFrrRgiBK3YnDCb9RQcouj/KntRmlpGEA1dLO17QRlA2+GquqNDwmf+W8DTv28pH1eq42ZLgnRanJ6k0AfVUTqXP72yGslXHvUwaw4tw3RVN99vR1a8pDckIMwSTC6cZew9l92F5FKl3CfavgbLn5P6XV0LOuduVjxyCi7BWrMMvGcXYeK1ZXcu+KLct7c7Xqfdv5Gzf82B2BlEwr2mHcIxj+y/xaGSg8OVmxY0eGfG1NIo7AZ1DnhNbAvngBA63ISz0lmmjUWD4AmbpeUoMr2Lmotm3B0YxAT/guwJ6Hg69k88KQN7+/z+UuStp7ObJu3g1D6VOPeWwcEzXCchCiNW1fTMz7/+skGFNu+mGkGN9zdEKFhhcNZK+Bq+9AkIwHR26i3GS7iVQnunhxIcfRbNpiQ3w+i9KlMPWmPVe/k
 lmYG6RrB
 m53I4vnKX0u2c0M38VmVixiom6LkEWbqgA2b6m14V6wixycPLB69BPfHlTuzXUpYdoxlsRW79ZVri33MUc7bLNDK3FIP65KngcB0tulMNGTAOXxRTjpTYMux95hpcbUQlW2oRO1Eamkvs2AC52gsX4OcMZyiqo7rWoytIQC6d+HzhR/EGpYdlLfkYfu/HctI4Dzqzb5ufaxs2WKZ2iczMl+IlSUnVxgmhlc8NmmXi1EK1k7yD3v6glBdrBUEhXYwzk7XMB8Q2ONGHjw2JiO8UFO5+hdr2+D7HOXfJkBumBAmWWI0FUX8yTl7kzdQo26rCyb+Re5D123GY+b6MNSR7kj6fKK4G0yzM2VcwBWUbPW5nHqBgonu0ZupToblb2EgfAghWloSh0VezVeeqtXqu54avezR28ZS0UBbyMyJq/DDUbD2GwqFHP5xIBgTpIMHhqUboZ6kzcCt8OaWk7mJOPEuZFOWB+e7hQx0RRRB653VNEHeEDMNC8oUOQLIDH/+bC7CnItVQqqFoNnK4cPwVQmZV9jt8WqOwKzvy0KbPypu37vCGgsLWKfQFHK/3rDFQ//yIJNSXPtFjWZJWHuB5Da8ptA9LaUu4yLyS4t/UIKsBnpSX+vqfe+xG1E21HFrloLFcz5eZ1Xe8urgFtS1NwVrsmNeP7jfT/O9X2BApvEIIzZRJFDNNZE+YymS5v879beSFA79HdUr95ZA1WU+70Gq9OBqiO6TP9M7kWH0S0em8Pn+A5FIfusNN8222lY0XqIPRxwxUKe2ygGxkBSUFsZTFhs7rB/1DiYf7hMOKU9B/wbJnNgkNmIKaKDm7Vb4oZ1IdtGTH6ITRmaXB4bqBiXmQbqIMO4PfnQeA6bAYXMuwNcEpQIBqP4MsJp0uqmOWQlVYMo7g9HJMkfoAln0UU0X0tmZiFzg9M+zYTZL5Vr5Nz3hDTTunefNiAvEPPML8zi1qYDzYXSIQAkat0gbyRCDNUTS3
 fGUIg06Z
 Qm7w5PFMwKSXPmhHPa5l9hrvN6ZHYfvsqXLCmubPXap8rrodUC4Tdulnc1WIWxpU1zlu3kgWIgxjKgMYdktZ0P7zZzHyewOgVIN68MvKeb2Zq8QiOb5wXz8bTIYA5pWoo+DJ31eBlkJaeXEBHHHy6GjELCbWYYFDB6ECiyK5FUBkmj8w+frra3gKRTWkuCxsDZWtbdbP7ypLjMpjPQxVtiV2981aTtNB4TZ5QYwYF+h1fD3A31nfkdgG1RFCMaSYTtMsLEsuBAs7KHk8a6LauWddDVlZKKCyjrGC745j3twfeSWoJHutDDWGaTsdq6K7Aen/A7pW4JMOuAFHusZHTa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
two new functions vma_flags_can_merge() and vma_can_merge() and update the
merge logic to use the former.

This abstracts the check and expresses it in terms of the desired behaviour
rather than an arbitrary and confusing VMA flag.

This also lays the groundwork for making further improvements in VMA flag
usage.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 21 +++++++++++++++++++++
 mm/vma.c                        | 19 +++++++++++--------
 tools/testing/vma/include/dup.h |  5 +++++
 3 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c49ef99b4413..83979ec28f5c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1612,6 +1612,27 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
+ * merged with another?
+ * @flags: The VMA flags to test.
+ * Returns: true if the flags permit merging, false otherwise.
+ */
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+}
+
+/**
+ * vma_can_merge() - Do @vma's flags permit it to be merged with another VMA?
+ * @vma: The VMA to test.
+ * Returns: true if the flags permit merging, otherwise false.
+ */
+static inline bool vma_can_merge(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_merge(&vma->flags);
+}
+
 /**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/vma.c b/mm/vma.c
index 2a90c509bb31..0db2fc306993 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -924,13 +924,14 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
 	/*
-	 * If a special mapping or if the range being modified is neither at the
-	 * furthermost left or right side of the VMA, then we have no chance of
-	 * merging and should abort.
+	 * If the range being modified is neither at the furthermost left or
+	 * right side of the VMA, then we have no chance of merging and should
+	 * abort.
 	 */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!left_side && !right_side))
+	if (!left_side && !right_side)
 		return NULL;
 
 	if (left_side)
@@ -1152,9 +1153,11 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
-	/* Special VMAs are unmergeable, also if no prev/next. */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!prev && !next))
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
+
+	/* VMAs with no prev/next are unmergeable. */
+	if (!prev && !next)
 		return NULL;
 
 	can_merge_left = can_vma_merge_left(vmg);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 16c09dac59d9..2fd422789717 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1647,3 +1647,8 @@ static inline bool file_is_dev_zero(const struct file *file)
 {
 	return file && file->f_op == &zero_fops;
 }
+
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+}

-- 
2.55.0


