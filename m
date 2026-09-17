Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65EB8C982D9
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50E0E6B00AA; Thu, 17 Sep 2026 12:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E5596B00AB; Thu, 17 Sep 2026 12:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5656B00AC; Thu, 17 Sep 2026 12:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CDD96B00AA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:26:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B93F1602CA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:26:06 +0000 (UTC)
X-FDA: 85223781132.01.786B9F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 877F4100008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:26:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LfeuOanZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZoaVx57BbF+4trJGnF81EWwfztLzsRzS6Z31t/6zuI=;
	b=46yaV1XAFf+drm7a371uww2e2LleSxAeQKDjVOg6ILpLRNKxi47U/IwYomTBylSTkp0emo
	Yi6p37mbHPao1YpAMfIi2l0jcnFbzhx+AR7G7UOJ5txtwm7wWPQBUg0zOR2debp6YqYYUh
	g4lXGKAxHGBvSCtMbBaX1g/TwyixvZw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662364;
	b=ca153oFrljkqUR1lVipVto2yzfjTbY3lUUVtGIPPqiaL203fgsln8ff1/dvV0g1nfgPPuy
	t+nHVZvm13P7w3nHNctXg4HmSBeheQk6z6n7MXyaYQl8Anae4FV1RQou/QYarv596uSvy8
	pkaxT87vpNvv8OA31YOUu2kpTkxX7oo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LfeuOanZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 099A6601EF;
	Thu, 17 Sep 2026 16:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F099A1F00893;
	Thu, 17 Sep 2026 16:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662363;
	bh=EZoaVx57BbF+4trJGnF81EWwfztLzsRzS6Z31t/6zuI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LfeuOanZS6urw3S0zQp6JGEEPduh/ttHPbD9KA8FoyIFx6JzgZ71KTdnsHcIroS6b
	 6ywlpvLKqLCU1RBnuHTRvX8H63Wsf13UhJ273vWSNWHTgkcCgC2Gp2C9pCVBcRYzNq
	 EpTbGfW9LWG0SNNutuwnsHoPxCVkAfXhA9Y2TKL26VFnH4tkOpBGjK8cUebj5/kRJ3
	 qxr0O7Bfo3q/86HSKf3+RmnbrgI/zSWyMpUAjnRwM82ABPEtxhZvC4BbcsKj5OAnPd
	 aQrA6917GoklSDHX9zuOuHpttbfE6/n6DaP8VeRJwyOw+o0PC/7HOGyKsbGzJSsTyC
	 lQo+HrBTbZdNw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:15 +0100
Subject: [PATCH v3 06/40] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-6-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2508; i=ljs@kernel.org;
 h=from:subject:message-id; bh=7LIIBPuTeTKNp1Yeg/nblwp+uaN6aioIRCjd00dfg90=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCO+fVxH/kl3n0HK3SXGmD5bOEA6zO1QTP0eJ+UHZA
 d0Hh/1+dJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiO48y/NMy1Zm1t1Vt5het
 9h3OXoom8zqW1f9NKLl7ivOwbXl52j9GhtYMuwvShabiW+6btT5a9dnhaeN/5oSXEqvOn9/UKFh
 2hwEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 877F4100008
X-Stat-Signature: a3hnw7taymxhg3x75j7c1wa1a17batt5
X-HE-Tag: 1789662364-516388
X-HE-Meta: U2FsdGVkX1+040SzOPJ23u7LguC9gIhH7w2jA47oAvi2Ne83sxgGEBelg0p/ybTr0cQuCoyL3XqHpHdRgLyJ/Dol0zteQ1HFNz84LRj2mziBjs651KNu169E+hjSrOwk7EOgm9ArJh2aoJV4N+XopTtiAQdzxf08u614rhgd0TSvpAVW82jerLHJrOTQUlFIDpd7MmW2mq8XuqbfaNnpyF6HfrRGbQq3aEiUeeT1Oe0fCqu+KMSGBIgZHgyjiP2lCBqzhLh2VMfYwuJFhA/R5B4N6mdGi6qlYsil1xQ6+l3R/N/MUVPb1ro1FAQg4885JuiwkTSQp7F4NV1Pn2icUcGP+ZY6YKZoVRpB2VYx0kcUEb/R262V/pL0jEwBelRVFhxeJ2XrsvHS09eSPJC8iF7O0iYpjfMN/QMTUar7Ss7MWrtz8D1wUbPnGuj8jIQfZPmoh6A14n/r5LhSW9AUMAEZZCF3ivPpbpeOvHi14J9WA69CIXm492/o21HLfEHUQqlnOsQ5ZsKzuEiuOJ5nQKjbHh4gKXEh4le0FdIBHcEoWkPn+Ffc/UE2dGeKukpmzMUuOkKPKGUGjjmY9kxWuC62V6TTSTNrJVkDRzIa3cF4gf29SAp69ull5cMq/e/ijtWPzlWQKWA0x7GdnFV0DQKBvRmCo8YxPO3ldaajG0Kc7yMwV56athXJy1207sYWy7LF9UDxlMDvRF0NLU/rpFP9kdsr1wmbg5n06jLJe8jNxqq2VYRYDNeeK6oCJCWg0nBGbnQOc5ubtvfZ/AiDOuxc0nXpYgZM+TTg1bFgVeDhEVUKvbRl4DtYqejB+9pest0031Hi54ZnXYPeVCGq4IptAw9mmGqGs2ExPPL2hfREMCFG19HKJBkuXgn7wikFGXmzPECe6CiZ9JsRFlgqJf/G/TFcQlTZgBZ1KHOgJWQAAAMX2F5rYUcjt0UNhyud6kePguhRzMz8kFy/zZL
 jbnU//2l
 08l3HoyCltv+Va5n2aFtUgw4NlRP8a+gFKJHD7z4ee0e+LV/NwoJQxDQvGs0unLmHXuz8NpzGtMWHqpfhnBtjnqcdd2xeOpFYStbdNIPqO5C8hq9vYvYxuEWnhVwHk5iAf3NOyHfpQvWbCDotS+0uU4Qu/axvF0jUjkt9rnkWlGr8ZM/HfIsar/6c5/eJxEVPp0kYD0ZqqX+ghwEfLYOriKDD8GZ+LX1hwvAJBCqkN+VqizKr8cEijE2piXycfPs7/7bfj3VADZkT66QxIQlVFqlNl523oEN8M3jhAFbGLQa0qeobvkfHUQFQmKw0koKDGwDCWYwikFsYymB44RE7+/mTGcdXBy0kv5fbHCSPPTeXiB3EjFUUr9MxCSt/0aH3hfyvcLNMEZBRwQgD3oszb6u1w9axTec/BRlW/H45RKRTE0wImum0Tm1JfUoWkrv9rPN2suw2AOmLBxPCyFsBNkKQHI+lQHOx+mc63OJMfcwuzAkmAw6Znv6TRI3g/b8mnOwI46gq4cP2ene8NynaRomeTa0tnR4X/J8Mk5zcvmEuYqDRoOGM7G8OVQq5BjjLSEKRXrKQe/ppQYf2T1wxTpnzSLWOWPLoqRiUTKq/feJUPWSbra8jqZUOq5DRzx63VrC+K0JRoVZKbmGLhnL0uiALuOzrZkQ6fzOkJfWNK4UvnGsyLiiqzRTGIPnAermO55jJa/1UgPl9i/O/DMkDY1TBmAY46XSwB5+tCKB3Kzf7wmhWSBB7ioun4R5giwYETdWC7KA3/VqIWvVygH1sgIggYV8JWpgT6MMWgm0hCa9Dv3KtVxNfAqoWg+wP74nfk7UPs0mdxnvvhfV+hN/GQyt7aEF37qwqh5vnbNH8gmucY1LiLcUjg4kiDUGzDWRVGTdEpH5Ll+W3LJheGI1M3obZD9FXBnrk155/x2XWmWo/YbEQlNSWqUeaTiGbrfOUamaySGIpsQtdyMpPH0HsNsP4JIo5
 VMtP5ri3
 l/0L1l5O88O/0U+HyGfp4xazcSF0bOV+BX9wkOOkNDD7Dvx9jqdX7C84IYI1NwAYNfTa4M3d0cSWrepv/0w/WbU9auzAuDMRNmjctjIYHX54paWJsIGX3cTn0Q7NqntGCh3IiiUZQ2VFG994lGqZIH3RUCZx012ktjePTw7NrX4qaFjtqJ6OowpkRcc4gRicbJW3TUPGqf3j2+tjjDovdsOCEsK5SWE2xhFejf275oLFMZNTrXHUu4w/nMM/XpdRNOuzK+jhTce1FYoziTXFlk1UK6e/vhLX+vNE/eqK9RsqLyPSw03QukPM+OvLGNOLjAOBKEXzgJGTW82O9wfFQv9eD08C/foTNw8k3zlJIzo0/3Lae0QeShzfimERaBaEbmqIzBE0fYVGvCTTux15fXPNzTcnMi9UiDoLZ6HAe+23Sw8EkJY2aqbZN13g+e/G4gcO/C0WLUSXe1MQf0s+s7sKYGLYXsJ1PihTHeV+tGhbh7FyE0ZKnxQi7TYYXj8LXyc/pv6id6WZqhMChMaOyGvvFBZsfJIpYMGr8rJX11SfYyF/QUVMl0rGIjJp1k5pPzOA6c3NzgLX43JkTbaAoq+pM+/FUM5pZYxervPT1KbpmAsR+sJ6lSr9wizyKUlh5c4qQMAmoXbvqjFSj2EoDQhZBPIPQuuf4FhDBML1ZyWTZxSzxeDeMjCeBcTJwJR2dwDFCpq30mhKQwg2sqAVame9okanWizYQirv06lKLheZeY8i4wOQaLSzDGaaKeN+25DpzdPZmxhjlwj7mue6JFpRA9klRL266MDtzEGfXR/ykYO4KiUZvbCIA8dEuVdAox4svd1ecqS491AH5/nOKTKetz6M5Qq71sF3IexfAdgxIBanTQWn1yI7eqteNoOjHACqJTakG5pGuPzECia4M1MEEE9iWtF19FHsjEBvCJYAZzAklVrYwF1r0RKYpTtFPGcaH7tG0t1CK3h0/D4vEoJsRPbzj
 GcqTgzvu
 HDxebV+lbVpIITNkb/hzBtcFw2ttMzLowm1W9e1+dWt37E0wNxwz5xhwdIDKRrj5XAN2lbqxtuRAgokua8l+w2pw04oWTpXFBij8KlcR1GKfV5EUWRXUzEyd039hMfg7TsznGhjjyxVn0pi1C4HF/28FBTSfjTgH+tXNx6U2oS+SGk5LqJk/GG5SFMMjJZdXONpfcBfHWSbN3bCC/M2egWs92SJ4V4jpchHRJuVuV6pi3hpGVrdHEtNJBMrrBWBoO4Z2JT66squ58Pf4tltgyTGmqMkVwYeDUMl8hZFiqAZYPCuWxnYvNpsQ8h2VJq/W2xyKuJZFsf/ucpwhoZwX9Hh7JVdogPJd12T+CasT5Ly2Nwtj5Z2sbHJwaKE80KC8gVDuPj0fuHPt8lqZCCQIefIBpBs7D9fF+zDaqt//KYYja06hSLoD6tJ03hhxft6QvZq8fk/NXG4is4M4GG9NoErNCLEV0pcJ73G7rRzsIvUO7/r+o5q4dZ5uAXNICxTwL+owkTQ+D3yqhZ4q8N9YBMtVu5ojgatUXMbTe9X5EVt8ksyioG6qUpz/NDWysXok394vo0lVns74tP53iqlFlATyhH0Vz45yzHRSis4MBlvaoPbRM74ThSMTLnpn2p6iEMowS7JngvYqOEdQ47U5a9wBnRbqkRDZMTrsXYld384ZVGiOSuW8gbZiQor1OXQIui2D3agNMZ/3rk5zh6voWmPDnpn3EC700PpTY/MHxs/50bZVm5iFDRD4TtAp3q/Ty5yAF9UwKFhezBZ3Yw9tnf39RawPb90f5+BZPpLaeH14Q1fS+lgVy4WKh6pJoH0oyBiPuXjWJysMrAV4rZ7eLLPxIrWEnF17R8D3jCSjXUG/klxlLXNG36iP/cp+A2vW4boOMBJH8SDqHK92eQfX7mr8E8rLi39hRarV8FvzcHaBM51GD4Fmu2NAuZuO36wec2Cmu5910KpJktSdr2YduUQXr1KRn
 1c3a9QJE
 ufENDjpKmWDch3rPYuFfCeb4gcP4D5/H9u5YNgkHIO5WwBBDEduaK7H967WbEBbFMraqz/QUpp3r9ls4EZt5WxczMSJi84Xf1b2HOc3nH2MMCI85KOzXrIDhSk7tMqjlJml+eUhy9ixg77bDEtlMqDK1Gx6b2R/OTgrqx1AmIDkAgTR88rmGDUreB6r8tZ4o7a7JbU/2gbioTnGQOs7ZM2nJL7KDZ6/T28PePb8RLOMp+TYkIu6tkM+rVCyfKAG7/FnCBnyp0Q2jPMMcLPy3+k1Tf3MU6oscj6Oiws2FkkmilHPJcgULeAFw8rpxfYm63AOxMrzJ17ogcFJOj+FFaCGcpn+rwP0napH91fdCOY5fDv9rEUHEFV2H/wVyEpU7Rm0fQnrLtFlGnxLcUX445vBuqvdDjwXpHWz1BNs8b0bsgxCAegMRYKeDLSRaRIZ1RrJL1rk1bW8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no reason to export the symbols for these functions which are only
called from internal mm logic, additionally there's no reason for them to
be declared in mm.h.

This patch therefore removes the exports and moves the declarations to
mm/internal.h.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h | 3 ---
 mm/internal.h      | 3 +++
 mm/memory.c        | 2 --
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 68250ece4219..0c17f0932b76 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4768,9 +4768,6 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num);
-int map_kernel_pages_prepare(struct vm_area_desc *desc);
-int map_kernel_pages_complete(struct vm_area_struct *vma,
-			      struct mmap_action *action);
 int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 				unsigned long num);
 int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
diff --git a/mm/internal.h b/mm/internal.h
index 970fb34898b2..c767007c2187 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1513,6 +1513,9 @@ int remap_pfn_range_prepare(struct vm_area_desc *desc);
 int remap_pfn_range_complete(struct vm_area_struct *vma,
 			     struct mmap_action *action);
 int simple_ioremap_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_complete(struct vm_area_struct *vma,
+			      struct mmap_action *action);
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 926276d41920..448342883e9d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2628,7 +2628,6 @@ int map_kernel_pages_prepare(struct vm_area_desc *desc)
 
 	return 0;
 }
-EXPORT_SYMBOL(map_kernel_pages_prepare);
 
 int map_kernel_pages_complete(struct vm_area_struct *vma,
 			      struct mmap_action *action)
@@ -2640,7 +2639,6 @@ int map_kernel_pages_complete(struct vm_area_struct *vma,
 			    action->map_kernel.pages,
 			    &nr_pages, vma->vm_page_prot);
 }
-EXPORT_SYMBOL(map_kernel_pages_complete);
 
 /**
  * vm_insert_page - insert single page into user vma

-- 
2.55.0


