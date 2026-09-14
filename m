Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B051C88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245A86B00A3; Mon, 14 Sep 2026 11:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6AB6B00BB; Mon, 14 Sep 2026 11:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C03F6B00BC; Mon, 14 Sep 2026 11:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E01996B00A3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:05:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C2701A0182
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:05:57 +0000 (UTC)
X-FDA: 85212692754.10.10004F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B1562180004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:05:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o2HJqMb6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398355;
	b=x7xctVehEOTsoFLd+h4VdsI+4mpN1UWOyVadTZ/jVlIcEfCy/0zf4lryRUDfx4o8akZU7T
	nAkOFLlsbC7uZjhGfj0z9i2klZ014d1zJfSNhkBTgpgQMA4D/+wy1dekhxvEDtSwq9Ldep
	D+z6sg7jw4FbFYBV0AJF1as06NArDLg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o2HJqMb6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8M2KGQ/Rdd7X1qvg4n3rsyBcsIsT/58MPgOQgnVvrcw=;
	b=1hgL+rMVPBoQyFVZCWmCjeJqxFnAH8oRdehjV3QSzYCKlPd6D1Ddu9bQxng+mKlRh9Q97o
	Q2/X6voKFijtSdksN9tFfuC0aisPhutXmik4k20GjUmOzCgUJoKcinfu2dra7lb9qddoMV
	F2ZICA00Z+UQvdYqjjDYXsfk7jQ1pzw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 41EDF60258;
	Mon, 14 Sep 2026 15:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3931F000FF;
	Mon, 14 Sep 2026 15:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398355;
	bh=8M2KGQ/Rdd7X1qvg4n3rsyBcsIsT/58MPgOQgnVvrcw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=o2HJqMb6UivQC8UjJz7ubcSKeKsWvNsYPgzZqd/tAzyG8Dn3/gtoL9ZCUQFx6WgF5
	 C9FGWntSayxAU6eUnP7iATrD3fpH0wmnv07IPIwm7ET7skvb6y7buHIWqYX1zVqbsY
	 4ESb7Zg7b0mDXlnVpRhJsurFsSXv1NBjg+7iB6ZaPe7XOp9Php+Dg18jhd1evb7gJU
	 CHyw4RFTUdSF0/PGWpr3aXyrmm4xVa0kWF01jb0RWCLOxy9hiME7RTUInidX9L4jOe
	 cNIlWnTtXBkXsobT/LJM6HktktPI1sPsJ2vA4g1QBizqOk85CxnSmKSW6TzXj4iycw
	 DojmzJGshXsvw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:34 +0100
Subject: [PATCH v2 14/40] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-14-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2077; i=ljs@kernel.org;
 h=from:subject:message-id; bh=fdJtBNQadhST13A5/QqOS4hxZn92kbQM6NW+rZ1tlXQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK8XkD7BpLs7ZpLngpk9lj4boqXZJ/v8+Wqbu+pyj
 o14Atv8jlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExkcyAjw48Ps/tvhbe/NZP2
 3JZfdCLk6zaVbjv1hAN7l5c0rpyQL8zwz7Ji1sQNNbuZZzhoZ6aU7f3OXaQdavXyt4CuQNf82QE
 TmQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B1562180004
X-Stat-Signature: j5qpxrhy7gyu1qznxozqz1tza5kkr5wt
X-HE-Tag: 1789398355-723777
X-HE-Meta: U2FsdGVkX19Rky6PdcjQsYG5gdh1LNANNU1cWWy0ah93kObd7TFn4bu9gNyPFosvH8ueRoPKhVZDlr9Vua3+yVx+kzg+8U2XOyz1GLku5GcrtnnUgJGpKGmhs1hnBzBGFG2lz0NapLgRERgT7GkAGKtT8BmQpQRFLwQSutd7IQaRdwuLGSqQPQbHXUo9M6+qCr/QafuThpft8INfRvjyI0Bizh0euSrzzfQqz8twP1hy3wCfgESEiiXE59UYE9E3h9hDYuABOb2rIe38pr6fEqS57zTNJgWmQJd0IsGJmE1Q+GZHBGRojUkimNCfrwQJZYwn7z98mRPrvYZ1se1wdEncSjkoNEka+aGn/scinHEFf7uhvkVKF2m1U3tYTmT59yvr0tVw5e23gBfupAXWi1mVAAd56hSRTGHmqsI89p85mReQpISL0IUNl0rOTpWFTU4Fox0E3RggMhJgN3l652W82Laaa1HybC3bKYYs9TeM/Q2iyK8CN6Ns3e6ZDX36sym66VU7BPBhxHzHEga0xzystCSoh/x7GELCzAGHs2wk6M9p7kOCVAevtnElhGgzMtH6suv2I59A6wIbaUVfUlbYOzbiWaMNJR0MzBUjtvR1Vt767GM2Jm92InoMY0WQVTwg672bBXRF62R3JKEZsElXZ2AUWCT8EBaD7m+EvkaVYXFYGW64Qk+0uvs0VBl5q7Lyyd93MrBP6Xjm70Y1sp8dl+EZdxwzpS67+w1wbclNOTgbMDX5WKxNJWpzgbOK3osT6i9ii2T5IcFl9cRLU9RWqfucUfXqJ+TCj02iCVvUaYeAezztvqYySKdnqn3luONTwoJ8Afk6zUoTmfKmC74PMcAtW6PyzcfAHAs96hBJv/hnlx8s3zo8XdLKjYNLj6vymTgcUVEG0pLE07dW/AOXxVl8vrHY5VU2aJi0vYFhZ8RaaDBQ/i9Uqq4+6EbsuJpnDm0MwNUc22iUL51
 woPnJ7H5
 EIw5qfvfHJ5HZ1nu8xERO8RPRCxZRCXATDMkMtWL9gs7nFWQZs+taZwBaySu1e9o7kpL5s4sCDR4NAtoZXBSPfncXfmqTE5FXRWCaEdg5jZiUtdbqrBH90Dqi2p5N8jcViFjd2pItzBejV0SPsdyQWH8X1gi3HMOvl4yueTQ4yv7GdWwMhoQB2rE4jPy0pX3YUGyqRd21UEFmufrq/WQtEhRkNSlglL7M7cVmrrwbS99eOvySphaVxTKMvm84Gh5K2cYpkg5e3w4OBNcJVuvJu2dUavR8QGvVhjz8+r/qspdSOLr35A7rNrj/Qyt/OfDocTnLkUFAwpM5Vbuw1poySXi6jEwoMFes7ldS1rhAX54AJJi39CLqkolOJC3BloDGtEi/OniwZnjAQq0GjW6zc50EEhvezdbP6bnl5X3rSP2mBIPuiwbbGPBDzrKv36p070DPZsHcgXpQ34G9oD6wLAXwmRD889knqmRIKbRWLwVzF25Khj1NVVD1jB4sfY9HPKg86iXfpyrZ6V1jcW8DVlJ6eX1TE3G2JDAMCg4G8aXhr+kCOlesdLcI/tIgiqBW9xSXO6XHaQa15vKizYaGSTZFkEZkqL3wQ8NOY1qziOMLm9+DdXQgEm6olb7/mVGfadgNxorARNmfkmB2zSUjyIkcwy/CJMRfnQYwOrbnIic4uMLAIb2cvyxkgtJCr5QNLDA2GFglZzU2HFupOZZUqvOO5+vXuWu5LFp6p3K3yMWkE9Lc7VYWmU4g6jksXonPxR2AMKe5GIRWLRuMgrEDpgfiIioLafhLYfOHLRaOi3MvL+cvqvAMClOvT/9vNupUnieapZUWSld/RKMNS+tV+ipoTrpIsjMNSBMVoZlNvLHHyBVIY7bKzcr6DyI2lANx5+SPjO7S6riFnyDFinC8qT3fladW+9xW1gdstrgkfqILi7IMr9ImIA+JN0Cb+VmiuSLxRFXWrT+yg/kjI0rrjukuevw4
 znqyjsEz
 tqDTMmhvYTy9u4LT+X2knBOtIKPEmGHEpFry64vNoxw+1Lyhu/4mVr0NxeLXSlEq7butXUS9K9XDVKiTiMJrdYS9zBqynT3JhqXJoaIoORTLj7lBBefhxZFd3wWQVWDN2BmHB92YxMmScLP2Jx9MCs9Q+iQrosB1NlYwaF+9EBmBfMu9sVvheQn7b0IHfJnEY6TjBULpwbUlOFZHalJr9nMYApopRh4lLvmi2G1IyGFZPbgZUVCHZV6SrN78qfnO8AHgJpR7UcGAwQ+6POsHVo6HMSMkuc6ma2b1ZIXK7k34PYnFL0Lvw0FjCgKyjeDXac99g2BI0v29aNsUUbEcL//DH8+OYFgavCmeGRjm2SrWVLzQRVFXNjAz9HYkMc7N76mDmPXHtVpfVv8ogsTZ588lMHwW0JkMg0o1Ep/6+kwm7g2KiXl4K7lEYumpVWxrkTkJnkEY4blNtMxGbYsXVgwmv7+oycajgMmAMrdLQbwrMAOC8PFvuJl0G8VIYsjz6/P5llyADxzvlP2Tr5VJ1+evuEKIkF63ouIflB3ItRlTyjNAHprTw/3QDHsZCv0oMhS1womWPvN54EiA0zIpH5dHIyr5eicB7DH0TSBcTtNcla5JayTkUl0zQHy3siilAfpbLZIh1hmEwcKXlsK9RL+P3AQGwRYdkP1uD4qfaj1kiXAB7+8Lg0azDu0eqWHiVPP6kjyV5ecGJzRRoK7QUO1cca23ORTaMS8AV4NiaxBnXWjvPTkto/osKYFwb+enm9gpDL/yw2RYPCMbnbYL+TqmtxI3++wUemdx9mzPQeOY4hHgnXgKGAT6dDSXhyzKCP6lKTo3mMqpsdOuY3/wn4b2NuB/xAopECmnPfJ20GPowmDpvyqiy05VY2W+GZhzYcy9TJMF7r0sj6W1q6mKJsDbr0Ybnt9F0HOZS6ImYqvr7B2K0yV/0A23GT1vGA2M+7GsGYDNDIXsYCVUzmpXUuWBsjHGe
 uGsmyF73
 8xU/kx/wpOmj60IJlWsPPT3ljFGxdLdLSLIQjBJkQrtQbc3faxEkWft+2bzzgheby6GlOc3rqtISCi5ftW8RH5yDGvAQbuQ636DFCU0q5i8T2iIvsiqznPzlijGJcEb75QwlrYl/St4wWYD5hSQrlRKhWS2sAVbZVMUKFafohDlEYWQ9lkII2ngreWQ8kjRl+n1fwD8qx9k2HFQS8w/0py0+QDJ2AQWP/pA/jFRMVIxIcO2Y/eidqNZAydSrT9TwYv1w72zp67bvwlxFOtezV3Z9K0docVtwP/NRcAILfb6AAXJM72yLhqGQhqbDqfT71CqWLx9nMp6nSKjuE+t0axvKfroXmUXp5pI0K71EF6GkN+7nET20cnsmCwZOfvb5JsXb5pD3bemnI8+2Krw9Hq0Geuq9w+DCuPcAx8rLr7oLz+vaPHS6P8TCvnK/vZdMa8PrT6RmyU56rQmt6iPl13YhFwvK08+FPnVtUMwUL2Q8AXiCh7OBPav8BYmmo/a4AI84/2MfAfBt7i03+ifqZF+aCY3sFncFqwInWNFsjzQ8vh8vuQhUmT6Ag/16NTqahimHFrW/MV4ziQyZy4NBvM2XMbh2dTaxjiOAwSvJ9QfaCDl+Tk/waki55hUmiVKncJR4pcRiM8LMuXtYJZgGkOPyF8sEmLedCkGhgAQq3QQjqqampfLsKc4WD/rngqiH8/bIFuU+i2SnliwW+ALkfINwtb6h3qsOax0Du0iz44gsgqH8WEweF9CvEVEEZv2NvvLgeasPqR5pUvGhoWuL2fAX5cN6dyEqls9K+uEPkKrUNrO2972v8CGVn+Tg/MmGQCBzCu7gWl72HRipWLr0iqvHF52tzwkTG5tKzdv6f4L4XBApgEG5GepbKuQzxDvFzeWnMrQRC3f6uwDbPENLRxU4U1RIXsx7Sy1NL8SruyLUxAcrkR9W/5TMPAeyOAdhUao6uKTOgN70gtcoFPXzVYWomduJI
 5gV+VZi2
 VEAoQx+784E0Bp7PklPCTke846xsHNCgXyGWpjWqguJg0seV+iSDo9ZJOePDGMwQe8I89JoQhZotoe2DNMcU4F0Ap7dW6a+p02tX5MNpYvuxXVUQQq0BTlZcmJ2bIN5Unblb+OfNfsG8sW9jurres5w5YE4wb7RzhNsHIgn2WhqQdd6by17iNmNZ1SMle7BL1WUsykAqhl91eoywq9UKrjeZdGo8iPw6NUWsM2HLhIOyufGqrObbV5+tqb8GruJyTo7Qn8i5TxWSK3vbY5/iWz950OhVzhNGjkxrS0q04/b1ZqJKEQcv2vK/jGgjdWhKg30JEW15nu8Z3AvvtCgIN1E6Znc1mn6oZEyAglcWstpHfy3iaTKlVHW6T5kNj2Z7F+Bjpj7ergyMYtD/MIpfvVGKGjLx9jMYf87B6eArnEIpxWNDPMhACakuae4xX5jZ4Z9C6doa4mHw==
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


