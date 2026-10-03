Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1564DCA5FF0
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:45:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F17356B00CB; Sat,  3 Oct 2026 12:45:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEEBB6B00CC; Sat,  3 Oct 2026 12:45:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E079F6B00CD; Sat,  3 Oct 2026 12:45:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B67386B00CB
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:45:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E55414095F
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:45:54 +0000 (UTC)
X-FDA: 85281891828.30.7EFEA71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 740161C0002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:45:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h2Dsfg1X;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36Kk9cCfrs+K/ZkPenTGstnZo1LIkvSMm4GHKa8AJS8=;
	b=f/JiMYJ92D3Xf5iu47/PJSDgL6wak/5TMG3ALuSNgz6fjsPUaG/jDwsLmPK73emj/TKCqG
	niNCQ17V/Y9nK90/AmdVg1kt2SogD6gZH+vFrUMAiMSCQsElMc3wBvoLMIeBqUq+SLPRFt
	VF3N3gvYPrTJAIJofpZCqVejygzGdwE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045952;
	b=bfk4CBSwGqfBL9gMg6C+N1QUJw2jT3Tv9jK8fZoPNQb0HZO+E9gNP5QcCh0GzeOy1dHE4c
	LnVykpqCdLnzn5H6AjEJgyaYQgIVWMv5TrrcQm8As/AKDRs1EJWFj1tWJBmwi7ROgPilnp
	jbYyHOBWUdIhG+Izwd0Vqj8bKzkMp4s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h2Dsfg1X;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0608660D9F;
	Sat,  3 Oct 2026 16:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0211F0089B;
	Sat,  3 Oct 2026 16:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045951;
	bh=36Kk9cCfrs+K/ZkPenTGstnZo1LIkvSMm4GHKa8AJS8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h2Dsfg1Xql747wZrXI3+/fz+4Y+deOBQpJgW4qxqntXMyJIAE2gecb3qiFuHuXvd+
	 voif1GZgA7UUtM0vblPSsNPjNQDh007WtJxzNKXuJJmlWKpUzw2tnVJ9qgiQPBmEV8
	 /KVzqVkx+NRAzVGPz7fMFbNn8ZnZgIP0r0ErqwsLluheJjglZbyJsVBdmasrHRGE4P
	 6Pq1MEmJdPiKAYiq6X7WUP7FQrKS1ygoauY3kSAe+KyFRs+sH7NmCBzkGjvS5CwQJA
	 a/SBJmbkZ0EKfc4synBXhjltgsKTDX7nydodQN9HWpicB+1/PaZ7llQz1G7dJeMRog
	 umWRkuiKGNkLw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:33:07 +0100
Subject: [PATCH v4 36/38] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-36-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2224; i=ljs@kernel.org;
 h=from:subject:message-id; bh=D4Bktmj1CFdgrn8TjfxCWBpiKXIl0qBVGlP1ttOp62E=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6unornY/vrR45rV+j2uBywp8dvvNmSxU7+n9/NWs3
 aJ+svP+d5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiYh8YGebu/HL6nv7eWw39
 GyuW/VrPzaW79K14dimT2lbWJtGUiukMv5i8wo8cZas3Zl5++fGUqQvXCFf+/z1F/2tr5tngzWr
 7U3kB
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: 16i1khi5tfe4nzox6ap8ueimwke41po6
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 740161C0002
X-HE-Tag: 1791045952-336437
X-HE-Meta: U2FsdGVkX18f8OaQ7Qd0VzU5w70+Wm3eABZXOIRuVwuC8YH4aYcXiR8zZV6d/gF4kRkZhlCw049xr1eiDF2a77h5jlFnl/h0o97vFG5biSbguPHlbNAFONL/W9O8WcE2TMsjtQKvberXAi/X43tzjgC3Lu9tD1hGmjgt1idxdZEYjeIJXbF9foybA/PJzboUe71AMhQEe0vya30260tOhWQhZzuAGVwLFvjICmfUiMySQ2Vq3kxi975M3CFqDvoObOf+LSPrlbfo0oLLg6srmHk2j44PKFApzcr+gMSdnK54E5GT+CILjlm4p7qmQpdgTIz0zuC+nGfKiZGkctdNCVSilhndXD1KSUzRM7UIJ3fk2L9fFWxGxfA0tIgv5X+b7Ir45Ko0FIYEPe/b6zYygLEjlQbkJmnl4Kyo6Ave/AkDCPQViRcHnDSJb/KB5rkS8T9Vby3w+w2attJ8Z3jE3Jqr+BYp5zHRUONDeCxSJ9UTu248rseXo/7C34CJRPzz0OiTNGzAojZqpFVHwj2L0oYAZr2DPzBJruBpnx0AeL6PhJw067JtJla408bhZ9ONKGspFiG4Qz+SNPWnHi7mm5oW0lwwTBG6avn7gC7EeeEO9SsxAu0OtVtHMzby9ZopUaktEuG1exPvrNj7dakE0hQNYnpNIabMtoUmZazOKCpYoomL7UZQ3XHbd7wKmGBAC9wl730LT9MfKatLR/l7/JnF4o10sxTDpODJpXzFVz346rGGCzRqnZVOLLWIW4iPvIKu2o72mel3/yn0ns0v+QvwCV5WKH1Vo4FDE8u7oNiw4KeA7JlNBM8kCMUSLzkIunwbEHAPz5gIHzGkxA4GUip5+PODD53OeV1pix8fMEDt2vtemm7JnFuccxfZsDJtPWxBcJf/WEt/o09/Te80F/SFMTxog91vb7uV+Kgbd/ztqKpLugzNGryQ7KzlvFnbmpHJfbqIcnpu90uTiGy
 KDIYctrq
 qj6CNx1GSaLDU9Hswoq9u0QRq0BMgtoqkw6+479jfB3HZwNjakhaLVUWbRAuDjl8FgYLK2+OShnTtk67MQcS4Axamle+1eD5uy8UWSdmkCKy5mpP00Us4XzjsGfExB7iv16hFtGVR5l4yNzeEtjs6CDRlHiC2kEN5AYTw1zCC4acnK6t2Dvf52H3PTVKVaXFv3Z9wyyQQZtvi8nTx1zBsPN9DxCvK51bo/Cnc/BIRzu3PzhtVLDcrTZfXSYP/6H4ZyZSIlwaDu/LsVwc4RSRy4RnwDDca4QB1gv3u0tj+L8mVJpDPRV8i5/8CBkbRp+qUHLL5nx/OPhickoXRn4ZsMB1N0ROMPt5VQw6+NHt9LQ0+ylqBYDuntIw/bXUKumFTDlwXLdGMS1pQPUyEI6+qnJAzVH5Cg7XkzRlJTl0qEl6MczxDcHFBqwLEE38qdg1xwiWwNl+E6W4bCJJhcu9InL4AzCytfvZWLrz1v+7x/f2le6YIfyQs5rLP/8bjdP3T8BYaZbPIV43WcFWMQHM6w3kF3VY951i1mM6CAYM/EUFtehR6QfOZN2XkrolXO5UplhzzufycFblBIDZCXf3l/ffb5zSgVhTVdpZe0IVNRNFnEgTUxNPxj6yeKPodo/u7cVSD9ZLvLBXWOt9EfMgkQBs6JTqRpeFHDF7jflt8g1uW/PL4Nrs3YdszuSR7yoN8cJqq9kg1eHoWr0DihFGAb4yaxHMkuzbZd65CtNgjOUFn+x7c+EmqHDas4/SriZSiSxCti7BFrbOMhqvO9NkbGPN91Ko8wx0ZQ4SbBPjiC56yTIGlrf4Z1pAYFUsaIxkmOcCQ91xuDVFwfM2qHRw8zLdUeKSAAki+MFSilYVfvvq5EBYpGLeXzB0Wb7ue6AGAnjOS4Rdug8YPKWmDr3P5l7W9H4ikrFxRJL7M7x42YyY4vMYWawuBklSgvo39qTczORV0JRotjoswcHHT3iYKQ6AeI/GJ
 Hb3o1CkR
 tZkoPg+aUdzCt8/hsgfu/LisZinJEzUqUq92VDRm5IrDOu0Mdx4DiXOVu1eTfBQswcvH9n4Lqr4uS1IJiudC7crihs531MMuecRf0UvspRggrGlwETtrSvcYv4TYEJHZkypAbAmO7WmXQpXuGPk3MSSmKyo6Mpyo1JVGxW7H4HOfICQ0K03a+5uA0zZVb9ZngN0MKX4WWfWEnWV+McAllBb/4Lx8+Vob78cwiolFsDH5Jt5XU32l3wCc8770Ne7UyeW1ccTisCdjyu2VeeUkOeuazRBEdLGl7oOPT0XfLY9X5PPkwZiopY8c/kehvQZGmy0TG12fohoFlJ5SkKo+YdsHypL3SZsffawbKCsB7NCIjlZnhaEM+jqJTnlCp4jc29UNG8oHRowTuHtIhM8kLcN4gVdEH9mtCCzM3FxoUR1Y9vy13fqirIpv6JdwCasT0mHj+lpKMebp4Eq0ET0w2chYKnNAmfT4qY2Ck4B8ZsS93PjuIAygUZed2aYCcVHVtPPH4SSYnyaCTmPCAZQUctc6uiQiseFg7XOlItKfNTli57DzKe3Tm/Oa+q9wnFcoNmQVwkH7nFlfzic9MdY7/Pst30vm41sLt05BX1WtSYhaQQdhQ2Pke4dj+2WC+jgO8vbHnKX+iyVAQBAJleU7rjhD8H9IJ1xzhUei0fZ5onv1qDqY3qiQlwkWueUQDrLZ2bpglCkjZcocuzQUVJDcfFZHW8KPiJnoTPrOuoqbkGnlUvSVeqWRzsZeP0oqIiJ81yCZYvBf+DhUemIC3z1r20W2eO9BKJ9P1HICJH/143wF9Ws6jMA7d3EucQtqwEaRce2erdbklocw73MNGepDMiUcywOS5m8hprig32vP2ESNwNeHeiS4ZUm1GMuqAJjRL+OY3NyIdd7irOv8kiAD90S0l7kcBuCIuvPdm7rQQL2Tx1LHbMjNc8kQbBlwZfcp1wkD99AnqLrHfLIUcbes+gZcBKP3G
 wYjT/C0r
 1c11dF6UrOC1FPM0qanTRzmmfcRejg0n9ewZGI84nfUAM30A/Gp5ggyZn+1EpIzvy58myRh/4nDjHfXPwU6tFGZwyi3T1xI2/CvQbxj+lY06oBAPn0O3AY1JWJVrDunk2LKJ40iDm4MqZt4DW1LfVRpNVFOKntMnB1qLzoBfQD2sA4Q1ynPviPiqUiViq6Kw6ucZ6cyDsEQoCMmvGVeELkhpIJlr2SOcRCCdpdgDP1FC+4NVm5T7RFhsKwinioZq6Qh11sWT1/261ajcQ4h79mZ+MkUjK+Idb6547TgYSfeiE43bq2tpWKPvdJz6qARmcMFJBy6AqfDe4Y7lI1rQ+dqORX309u7cW5udgOdN5+S6pEj8RBOp8Y+3f/PMk2+AzzcrtMlhDSlL1tAVH2+vO7IuuK07zLOy4YDQA0n5UaFn3XlUc8jHvTSlIyKyhrngDbnukRDwk1xllxNmUC5OZEaCYPMYcMGxDcBSgP68hmGmoV/4wdqctYRUfE1BJIwj05zZD0SXHvtIrdjb9ZXHwwzdxdsarY3Y8l1p3jseQQI0TZuoPQH+Ej2YAFUvybUKC6hYURdVfbmqtgfDafshnGfyWZs5+c7kmx+npRdqXfycgYUQ5ph/F3HUOIR1rlf8J/R4BItdanlNpIJ3j7D9Qa3aXI1xu5rNJXJt5ojAidMKtise9CEHpYYb0aZdd9D//24G5ccIpKjSJpJycTaT5xXAWHGkfRbhEq3hm+hfAJI3HZ12j4xqC4piCFQUCLA5Li54m69FAmjMxRCTaRhi487Pwpi4QvJMmubcT7+29UeCqtUrbXnhjDthXJZDJFei6VtlysL/txWiHUvGAw35s3CUCUxGf1eHvHfSm2IZNh5qz0/7uzz7hoxMBcj+4fGcMZgG4QZM53+0zbMTEXKaJg7IrAULt5lbIpIURz1yvQ0Nq4+cIXQJsm/fuafaXTVig6GTFIeodxptnOgnatCvl71cn4fXB
 ZhangjGj
 4Tb2TdjaFvj1e0Kz5KMq4izVY/9PrlRDgFdXKcqk4vk07QqNQOx0Y+wY+uG6jXfYWmfmNDHxAfi1zOf5UaaUbGuwwlvkVbgbhVHChMXhODyklQaBZE63jmjwvcF3sAB/aHJdSG8O+UliFwPD2+qpiig94SoPRA9rWdv3t1pJDVHL1b9NNF+jxzImaXnFEnmajpXB8BVN0/zEeb93JSraFxlXCMWF4IjN5iOtSHDqJYj2deehTrOUCrU81tYajCa36uBTYgvjI9qhvYncddG9DkDQP5uvKf0timzR8y0152V5H2IZ2upLJ/qVXJfBjqpk247uEv8lEEykl6VuJxjgIBjHH8iW/Z6hmjdPeIeXVtYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted to
predicates which explicitly express what is actually being checked for
rather than the nebulous concept of possessing 'special' VMA flags.

In any case 'special' is not so special a term of art in mm - it includes
VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
other cases too.

Therefore make things less special by eliminating these now unused flags.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 8 --------
 tools/testing/vma/include/dup.h | 8 --------
 2 files changed, 16 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 55320cf2c525..7ada0da24d0c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -576,14 +576,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-#define VM_SPECIAL vma_flags_to_legacy(VMA_SPECIAL_FLAGS)
-
 /*
  * Physically remapped pages are special. Tell the
  * rest of the world about it:
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 94bf818ad0e1..7a6d99ad5303 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -352,14 +352,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 

-- 
2.55.0


