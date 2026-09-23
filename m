Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA80C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 17:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54FEA6B008A; Wed, 23 Sep 2026 13:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501686B008C; Wed, 23 Sep 2026 13:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9F16B0092; Wed, 23 Sep 2026 13:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14B2F6B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:07:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABE911C35DE
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:07:43 +0000 (UTC)
X-FDA: 85245658806.07.F7E1686
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id ED30018000C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:07:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i12XGUT+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790183262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPNB6bW0x8y7Uu11BgHcG7CSR1tZ//UGOmZllbw9Ljw=;
	b=QPcf7Z09o7azWv9QZpafzU/2Xt1yn4MWy5Rcclx3fT7HxBsje55tAGP0f5aIlgw6taqss9
	EunX819tm/3xOzcAL4T/+O6lMgkzONE9pJA5MP9pBYansb9HZ1/7PNJrBL9gSphePXawNo
	CESsN11v0guQIvQN5jZHyuUluzshlwg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i12XGUT+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790183262;
	b=qUrD+3WqKEmBFd9/GcqNlgiRsEEEzh9np8umqSjx5pTR69T3x5eeEwV7QvnHBQsYZexCXb
	vDxVPl/IJrIiNGcl+0k1pYahXBm51ahecMiX2pNyjR5QtfMsKUHsQ92aoGzUuJP20lJmvd
	jTb3sNsN/RL3ioeWhzjGPe+UWsClQMI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E63E3600D4;
	Wed, 23 Sep 2026 17:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370A61F000FF;
	Wed, 23 Sep 2026 17:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790183260;
	bh=DPNB6bW0x8y7Uu11BgHcG7CSR1tZ//UGOmZllbw9Ljw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i12XGUT+ELGTRJSrycRVzqTit3D2pyM9ZR0ZSTlIa0mojim7gB9yUZwmIu+wgWYZK
	 Ybyv+CV/Yh7wSmglW9QNbCpnx18TWoVPczcRHqo0Q/mnJsqjZQ3eFn2cP25qIt7fM9
	 +POE/rp3vRI+Oxpo8QK9N4EfOTJ5jI0dLtJ432mM7IKfaNA3MKzBEomsWln5bFOqPN
	 PxFbALYbyklQCFhfUINibcEvNCNrhcGgRwqd9F7gXGPywV48eYeWHkrJqezKwBbst0
	 GSXVIWXaPeEYe4X28qZjKKxCsy9Q0ESN1tzaw+iT6CqBpO8zm4Si1SUtWVa2wxKSZ8
	 vegFjunsRBTBA==
Date: Wed, 23 Sep 2026 18:07:07 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
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
Subject: Re: [PATCH v3 02/40] mm/vma: predicate setting mmap_prepare VMA
 fields on new vma alloc
Message-ID: <arQCCzmMARX81-3y@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
 <CAJuCfpEa8tUmYJBjx-cRdAE8y-jcKY0C81kAOa1QZS7F6tKdfQ@mail.gmail.com>
 <arP0oJgrgZlgtrb6@gremlin>
 <CAJuCfpFPPGaK-grNx9qiQOhzAXbxU+SO+95Fht1571TGREx2oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFPPGaK-grNx9qiQOhzAXbxU+SO+95Fht1571TGREx2oQ@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: kmwmfdweqb37ig34gti3jjrk1sig88xg
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED30018000C
X-HE-Tag: 1790183261-299682
X-HE-Meta: U2FsdGVkX18BQsuY7VuUZQ+jJB9CjxBRAOYrPhWR5GjoDGaX0ZhKWjdPyoPXodwFinWtXEwJ3eerxVCeJbkFCuRBmmTTWfARMig9SUxBI7LS6Hfa6FwavBku6B2uCYac5xlPjnfvL712kLmUW0cLW74SEnKvQyQQjfrH1FKDAMBAVVKviSNpcnBWeLOcVv5F0aFznc2q+rde4k3N6oDrKdgzcKr2iLLcUccBCyNFOGubndd/Mk+Hv6+dkU26eNQkIBm9R2Cvzsjwq1A/XKJuxUnUsO2SLLr1vNkvkzqi30GxgUIEQuvBH8w8QCbzFprG2zo8epuZfLcykG0vNO/+y+bGDEsuvdflBcDRtZH/LaEzM6vuDocOh/mCq707kzLsgxt8zlYxbDGGG6MR1JBDyrwDeaMoQllmUgsgedeEh4Mj3sK7G+1c472igGLAnDbUQ868ecBOXgspsyMReyv6xUKk+XUMsySWyGvO2yNujjZcR1zos+uDWIDPkZ29GZ0gyju3oyr9M6N5jq/cKbPMRepvrLSbQ6ejDYlyUMiGf7MzK7Izdz4JltAV2zsq1Jaan+5Y2KKc7yPm4swWOT7V72AKAU+aLQu2vV73qSD2l64G5TFsvnlma/634ycDG+ZYQDTr1V4Hhy/VwA30O6CLHxhDUG1B6qin4g/JceQ1Q2CypFDCyDhOhoMWJHEni73xPm3OrXHx50iODXfiPFRyQc9ySNuPJ//FYuvcbXWXdFZSOGMSP0Z5ckkVa6Tl8zAC1ZtJGB+y7ccXYl2o8cUE18yP94wINYr/rLZUpqCejwOv8o5ybwQUKZub+l06CCl/BmhxXxOWko60RdG/DkQpYRpdyjjfbdXPyZAeF/DLiCXY7QUaI/Mb0vwMl0ANPnzllImSW+OrFv+3oq7QoiYgQ7xrnY5Va5xjWmGUmUQs5mxjf+ExdHJ7FirPL1pilPQ89tIufNfwmSI0LXd+Q7A
 T4vCpGjO
 D2Xl1gmDqhd1J6WVKbxnhbJfshHCyMc/xF7ErDMOkz92yuAzbU/3lGotw5vHaRR2wFmU9wWN0vUi2HyqPc4cu0l81JIpPR371I1HvQUuMnsZz6Vh25uSogW9Q844zNYes3REtMgsDe0U9nCrZtUjbYwMi5DNiX3pxQQGAq5dTe1uR/3Xix1sYi04WeZLZ0cC8OgiMeGffKVVJZlyP7F1w5Pae9qGG/n1IWSoUlU/fQuOB3S4TRhOMhdNa5A37Psh4Ok9f7f9t+rKSsj5CK8dE6YLG6ymC1+iZas24kCPA3h77fDhc65i//A9kricTsBCo5vlsftA1BzId61IrZf5Ac1j0zonycLIcBHpuV8idVPgfhb6XzqL3Vzpe7D1EehGHsPTth3pnbX1gpTp4t7MK+6t1AG0MZ1Od+jx2HqjoBqn7hR80Kitp9ruQBX6DSCeKquJHhWeyXQTB9jYoH6JdG29dXXY5mJXMXCI0YGwnyZ0HeQJ2oU7aazQWw+F/FJ/lt+RTKf+DmapKGa4GMWoYf/5EErkJz2CpLK0wnh1w9Kxe63xflIuSqnz5M3TEHmd0aX+XRSDcjMdLajna2gJx2g5NB7HMuKUOHC4yP2SRDIJu8OIp47dkheqqN7bQsDUiPyrPrwGZ/8JKgFmvfku7A05QynWG/8/liOyVKNK7LmMjon+f8Mo5Cc6nr8CPle041gtOMYbBAsmNaKMAG03ZjvQ0pz0axHGRHhLtpzglFM1Jtvd6X0g7L5fWfvouktZXdH+DFUS8VHVVxfIn4yFRT5nYV3GR7q9mqqzbqbpCIIHzhevlS5XONjUH8sG1CRyZMm0AeWg1Gg20lwpD2hpDdxkUCjdEOkqWxUNKUgvEbLT/UL8m96tbYM2aFEHLo+G4DrvShnJdsv4TfbuAIV+P42AQqaZotDow7tQ2VHXLJhSxo8PqrZv84hjzOUw2t4CBe7kECQdMnYiPck5Rmsu4nSHeU2Ov
 bIKqIbp0
 PLRHN19auX/6fzCKXLFO0OM5ScTvMCl9hGKoanr6sBbe0sRzSA2Xisvkpdlt/Ze3WW2BlDd0RTs1mllmbjFu/3dp7olS2SlPMZowu6HHrM/ZXd3ZSYrPf/H4NQLh9n3aC59m+1flGCTBON0IG3tEWicNNkzbO/VnzjdO0DCs+RwNsWL+FwiW0JhkA1Y9twV8AUepjIMsehfjnTgZmt/f7w2PGB/wsBfXIoo/hEvgyZBI9sympS6drb4C7vijR0UtSfYqUyC7k/10TBpvSVef7SQlr2dRkYnHxvmV7QLtCHUxTk7Zt6NI+/4DlTC+8KSUlJKsdwOLT4/lsir/g4tRDbH7jDUtAMANNqK7+lfporlgAy8YtOLQ8Fb8VDhNlDa70CUzTVzVfQjHaDfDAFfza7PTNGwB8CIaKwKOLj1kdRTQNjcbnJ35hyV4VKEmp7j8AfuznP4QQ46mcQkOAsWwAYJE21KF8DrYJvzVMXcWdBEKrcXQ6K1yfhIbPox9GXCvSgp29xP25e4DPtjlYYbxMP2af64zMwqJjiyg0Y6Ozt8BTSQyFiWxwhWBDLMQkRJb2xEtKY5985Kl+gR5okUCagO6xwk5RtoGAwTE8niCEiZ9NemG7v8m71/p2slSbneTNK8CiaknIGW5evbUrfwQ3ta/bqUZ8r7cjQE1CgEE4UR++hjmLL8PS8D/TB7rpBGfQPOsIDG8/8WY1Z7sJeWvJGGglOdJ0Ue7CZ0kYUOJLt7Lm9dhwDJ3lZ/r1Guvl8sSEHalbK9P4zi17I9R/rGUHT9rCaXlm6/zDYzKLnsZHBIU/QKvBVqX17ul3nMJcKREhVtXlD9kE0BI9KgsrsqdCROo+ttCZb9GsAyUBXGwoFDEVoSf/VzrE2z0Jc3vTE0vqJsHJ04YyQ9HPG63IL3JTDVl7dEP9s0SmfzevJ4wJNZRZq0k4aN4RQIg9mVfzstwWow8yE/N+fy/diugvEWP5cLK1Lwre
 ebqHbk3w
 RGUzSsxrdXEBb6KVy8SauOlUgPiKSNH8TfrM6BGWHsaY7sV2zGAly8SGqPoQ+7pAHwLL4IJTStMJO5q8jJDph1CXr1JqxKY7KP18V+hpOZF5FpY+/jptqHuBuCZ81quo06BHWVZQi3nvMSQN9x/ia4S0vBVZjc+OJX16mrPmRUUdDgmlXQI0yiumc6m5bVBcV+VpMlZFBOfWo/NMILGMNqTZAKurtdAevqbnfWts5USyZeDhy1v1FlLO3AZ2EP1moO9th2It2D7/B+w1LHsArsfWqjNRceFgJgOLhZCjAsfM0A29S//h3gg/Z6KH/utKg4gw+h67Z1Oj2k8lLKTXYmOHH8+4j/Ue3yebIeKRQ9ozy9kBZ/ClXoSjurEUZHZ6SlyUbO97uGJJvYpNXBrdl+3ANn5Z1wkzpMQCUMMnry7aEqUqbLRzqGPHC/RR2PMIRgsPlSNxUgjRW3bg9XzyXwUAckNzo5nQTlwQvzkL+Pc+qVBAZSnkdBvFaAZXizB07bCyDu68ABPhTRUDm56tDgmztwXPjNWGDAXfzBhnD6AaTtQ49MVEhhrn/vmkT2+eqFGjERNWHGYixft5OnjIQN5Nl/Adq1o2kToJ+0s2rKRuXTvsGytgUfe6om3gmjbpqyN0F2cMqXno4UL4h08674vTpeTILCGoqTPsP6Ap9aRyt77ucTc1kNjU0oWBCBJbvB5I7n+5iXqSbEf1RAou4fRDQhnbDRtlnyw5NkyLTo6n6AWN9gagdl5p37PU6F/IBtP1rCvUzXEWTWoszRYgRVLQ9e8WGAjcKPoCMBEuWZox1hdyTA3qoAHvx5X2l2cDw3nwh1lwolCdwHns+69uQABnN3XwB3aGJxQqWm/Ea/wPgBY9qmi5aHc8TGucGXNUlB5VRkwCe71+94810DPB62w0yZOrqbzhNGbR+7ds7VmKa5TrytsSx4WqvkEFqIrPN/GLcvt2LwJ5Ug0Kvhql3FpYAcpDk
 upEo64di
 k98TmZJweFd+T76BN9WtfyCeg461l2oBWdgySGbRM1G5Ya83/FQbDA/nKQcMglHXWPJ/Rc0mICcg4YbkyzkA/1+IRr8pGhWA9H44L3Ng1ml4VUomOhc8jA/TVxSwG5loRBwg/YaBjtgj7U2CsReKnzIqqxk25kj12Tq2ZDr+2jVVAWi5fg4aXYYKNEFVLtDsoDJ+by8FBIRyb5HMYEpW84xb24Bk0sbZsk1/6XOVFb2EOBia6ix20F3RhZtWVY5Om5edIyx0FzTdKxNt2tAIhPOTgvm+qNk/u9ZecoFR6QrwjhuqsDwG5WSWF74p8gAtYb6mQCs/9r1TOXKa5gmOZEZ3fzRpuVJp68vTUzEzOa3fI+k20odwZDPFzQSQvcRXwPOPXVSsSrRloHdMS7OdmiYSyzFIW03EQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 09:09:38AM -0700, Suren Baghdasaryan wrote:
> On Wed, Sep 23, 2026 at 8:54 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Wed, Sep 23, 2026 at 08:32:43AM -0700, Suren Baghdasaryan wrote:
> > > On Thu, Sep 17, 2026 at 9:24 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > >
> > > > It only makes sense to manipulate VMA fields if we allocated a new VMA,
> > > > rather than merged it.
> > > >
> > > > VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
> > > > keeps its own, which is also what the legacy f_op->mmap path does since it
> > > > never touches an existing VMA. Previously set_vma_user_defined_fields()
> > > > overwrote the merged VMA's fields with those set for the new mapping. In
> > > > practice these are the same values, with rare exceptions such as shmem
> > > > selecting vm_ops based on whether the file has been unlinked, so no
> > > > user-visible change is expected.
> > > >
> > > > Make this dependency explicit, and additionally constify have_mmap_prepare
> > > > while we're here.
> > >
> > > The fact that we might be overriding attributes of an existing VMA
> > > that we merged with is technically a bug even if we never hit it,
> > > right? If so, should we have:
> > >
> > > Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")
> >
> > It's not a bug, it is an in-built assumption that the state used to assess
> > mergeability implies the same properties.
>
> Hmm. What prevents two VMAs with different vm_private_data members to
> be merged? IIUC is_mergeable_vma() does not check vm_private_data. In
> such a case set_vma_user_defined_fields() would override
> vm_private_data of an existing VMA, no?

I think you're right that it should be a fix patch, I'll put it out of the
series and send it as one.

The issue here is more so vm_private_data than vm_ops. And really it's that
vm_ops->mapped() wasn't called so you could have a refcount go to zero and
stay at zero when it shouldn't have been, for instance.

But in general though if you remove mmap_prepare and ask the same question:

What prevents a merge of 2 existing VMAs that were mapped using the
traditional mmap hook which somehow have entirely distinct vm_private_data
and vm_ops but the same file?

The answer is nothing prevents that, but there's an underlying assumption
that this state is fungible for a VMA over a given range given the same
file.

In that case, for anything where an allocation or e.g. refcount change
occurred, then vm_ops->close() will handle the decrement, and the original
VMA's state should suffice.

But here it's a problem because you overwrite it + don't call
vm_ops->mapped()...

>
> >
> > And if it was, it'd need fixing a different way (check the field for instance)
> > and would apply to the legacy mmap hook also.
> >
> > This change is needed for the series though.
> >
> > >
> > > >
> > > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > >
> > > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> >
> > Thanks!
> >
> > >
> > > > ---
> > > >  mm/vma.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/mm/vma.c b/mm/vma.c
> > > > index fa784f069da4..4b74b48c29b7 100644
> > > > --- a/mm/vma.c
> > > > +++ b/mm/vma.c
> > > > @@ -2894,7 +2894,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> > > >  {
> > > >         struct mm_struct *mm = current->mm;
> > > >         struct vm_area_struct *vma = NULL;
> > > > -       bool have_mmap_prepare = file && file->f_op->mmap_prepare;
> > > > +       const bool have_mmap_prepare = file && file->f_op->mmap_prepare;
> > > >         VMA_ITERATOR(vmi, mm, addr);
> > > >         const pgoff_t anon_pgoff = addr >> PAGE_SHIFT;
> > > >         MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_flags, file);
> > > > @@ -2937,7 +2937,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> > > >                 allocated_new = true;
> > > >         }
> > > >
> > > > -       if (have_mmap_prepare && !map_is_anon(&map))
> > > > +       if (have_mmap_prepare && allocated_new && !map_is_anon(&map))
> > > >                 set_vma_user_defined_fields(vma, &map);
> > > >
> > > >         __mmap_complete(&map, vma);
> > > >
> > > > --
> > > > 2.55.0
> > > >
> >
> > --
> > Cheers, Lorenzo

--
Cheers, Lorenzo

