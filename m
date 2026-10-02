Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C37ACA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 12:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631746B0092; Fri,  2 Oct 2026 08:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB966B0093; Fri,  2 Oct 2026 08:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB0B6B0095; Fri,  2 Oct 2026 08:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20DD96B0092
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:09:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B21F81406D8
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:09:03 +0000 (UTC)
X-FDA: 85277565366.24.E71471C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 14CC84000E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:09:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uy5taaAC;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790942942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XFpzUVlPtubZNxGByXwzZH4ApuR2nkpwtpFdh8/JOw=;
	b=Z+kW+ns0ePBRcdXAPMlIBaluwtYNennNhZW2JOZZ554ptmfhpTrCNOouiSJJzEa8pYX8jh
	n5j9rdMn4CrMoYlLSypv9pSofuabmgdwWFfUG5tbM9ZlRFTmq7CFw6UeJTejlEubFAb7Gw
	VCbv63Z9oimDQcq2O8qbCcYEGHA2Tlk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790942942;
	b=bsW5GKDWhQHrPVO7U8yUP7OdbWB9QwrBGHRLAHr8wgTw+ICiqq0TKcrTefvlmCFePQMNqE
	9cZRRabjVqRiDele449cQBxnpPOabAispitOe5dsaF4MZUJ7ETtjtC21SXOiVcBo6zDAp3
	h1z7ejvCkwP4+qUdyaywDs50CqlszYQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uy5taaAC;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F57560A70;
	Fri,  2 Oct 2026 12:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14641F000FF;
	Fri,  2 Oct 2026 12:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790942941;
	bh=8XFpzUVlPtubZNxGByXwzZH4ApuR2nkpwtpFdh8/JOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uy5taaACkmw4lszKyU7Yeuv+r4seDzQWxkXBg+0TVdf8xxURZsAxbErhYfWWrxxpc
	 ioGRh0AkeUlNaM0O/76kHyq/jNHajZ49qlp7kzTK/y9hmtsTG1lIh8zALpUqCprNPh
	 blExfXgLSv3QlLino90K+6/VPwq5Sd4fz4m+VygMzwLykCThr26SJaC6bhFxWHUwuU
	 RW3dRxgv9qthrHmsQVLnchIEH1GFQYCaQedJVw2qJ7fKb4CeudG3fK6a/HZ/Cbqk5l
	 1HvNfpJUOxI5LDkvyRmFGaGRuDENXBtw49ZrKzFNSoza42QyfDgjqhIdIeOYrklqzK
	 NX8pFIwFQbflg==
Date: Fri, 2 Oct 2026 13:08:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
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
Subject: Re: [PATCH v3 31/40] mm/vma: introduce vma[_flags]_is_persistent()
Message-ID: <ar-b_Ug__TBzIZsb@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-31-4583d8a23bca@kernel.org>
 <9bbdf4e8-6984-4477-a183-f0b236047381@kernel.org>
 <3557015d-23dd-41ef-9832-78b58587f3f4@kernel.org>
 <81e1e5ae-0aab-4584-81e6-3fc9c2634d07@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81e1e5ae-0aab-4584-81e6-3fc9c2634d07@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 14CC84000E
X-Stat-Signature: 6ku3o6xczxyrjt98j35j7w8q856oyjr3
X-Rspam-User: 
X-HE-Tag: 1790942941-498889
X-HE-Meta: U2FsdGVkX1/+uEjp7cwf4uu0hzh6Z/QofPG1O/0fkL2ruMVQxeaYz4C7mAkQAXOiaS6iPnrTEf8gJqCdkfCv7L2rP19JL1SXCaI5NqQcUNCOwuldQBjllKyGvE4yFinO7Udb0+es5x0U6fj6zGuTZqy0j2lX4aBf5G9vBKT6O6rYmgl32ofhwwdWVZdj//vyaqXyvaFFdfBj1K3QZhE/vU7rF9oJnIAzmBn826hbYjaKdfUwz5tYWqfvdKRD1m+sHNOvkftNSU2KY/mY5pUiiBCgtFM7S5x8Xdu05xbzbMy5YIy7fxqyErevvrq7IBTk0bSOc/yHDfI1WmRdRmzDwW5pdyJqs2a2BX9whZaY5J7A/29dBfNX47V0GcqkgnRwE8tki3IrPUofiS2q85OFYP6ofFSurGi3+3OMBzfBRKHPgIotRPFLuCZvypfSTA3+ZY/lZ0UqtudGK9XT2a7kkjSxS76cXDfSBTHNPuOaF8GCg7XqZzzoHX9nqf5Lokaw6N2SthmAfsnkpLYhJk4+VuTWjV5OeDvq1Bwgk44tDYIIPOJHPjKfbAjLm9XSsSPF+ARhi10l74wmmq/hj+7QAYO6+79lp6+wSPT6z1UQPrGZ01YircxWx+XA+5kkBDHG7W3bnQEr1jtqPYNLsM+M5KLAG3uJ0d3HbeZHEiFOn9K+0sNSQo+YxlQBi6cUCjfI3Dz9vGW/AH/IzRlo3lTF4qZlmBGlaReBjjyvYxlNROfBPrWz3VQdVmEXy3DJdYctccl42nYUtqzlq0057HDgdd9maecy+NE8uAHt8DbASd14vNBJn9O43zekfnxMEobZp/j0wIMJhJOqSo0U6H1oVOfZVIAXbrHAO2oqQXWVkGTpe83UKaBqPpaEyY3aEl2PdXJPMrO3VG5UsnzQrJ1ekdg2OJdW9dZqHOs0ewYObeVGOg7hCH0jvweYzIyVKDcZaWWtgXKBM4DriyzWuIk
 tJkykrOV
 ZkL3bKpAI/9a2HYF4+64vKJ9P9rGtwhkXmxpMVrwQ6e8uVHcWiK0oS2pHn5jEUQ/PmwOba5LPBybeFS2pCcC7W3kL2oWrAWKCaGKIfL1xYP1vLr+ngjvjU+KXQOIaTKpKlGsErhVZmd1LO0iQ1YSTah+KM6jl/tPrdkkiJP/Wgfxw4ienLkWkiKg7VMBk/KrcHb6zdmFMao/ioP/dzTCABuCT+/KPkJ9A/Haw72MyYCdoL03OGcFy82/9qLQhcqcgCAICC7JLQXjJtfidtTsWgKheHD4R/8dBAjR8q0E+7GfRYDNQ7eJlzl1nItDRkIOWdv49DP6d/1Lt/VpXmWYXzBRV5jDEt3Ys/+sWnR8GbdVOcNzH4/3LVF3oVdItMhMJy14QU/A6QTq1LicWWaLTd+jsyZILsw9ZkPy8/1xh5/38XC57qK5u7kxbnjsrvFYURiMlUdhSnX1QrgMvaTqajxMbKK3KbZl3RaLEbJRteLOdtwd1oklSlGbtNeqhCw3JCUsCGNrt4yuhXjxtpKbmx63jETqteP7TWOUiE653jCNKFunbgMNK+r3MT8v7F/cUPTpC7tpUtfIkR1U3alQFYextTuKM7DoJxLHlny0rp0LVRK5cTOBceC3AFgzdBGFQgVHY3OFqKT8/ALIBcvsyPUdk4oOAlNj+rKyDAlvKnhuvG1aFGKTPEJwfbXecxBuJYtXfBDUc+YfAX+q6CPHANcPtv2sTK3LivWOt+MxGrXJ31QBAIHvP7axRr7zt3X6+OAmQJfujVZGgSa4s7a2E5E4dXHr9RgCQyU1n9OAxKhxDQHQ9gG7M+k933prYLURwaugxeLMYeoICYlLlZQ0deaLMN2RNE3WMZ4aWS1hfDfnnCB6m3TiigllrxhOSKoVWwfj2lvX/W2+pWKPuDtnjQnqJa3gIsEa3fQMWCBntifBV3b/kvhZrxTdKr0D2Y1ibY1wZztprq0rqqrmaUGoiTjviu2x9
 40JJw5qO
 fDVpWhwxZhGUrE6JoK3aR1iVtCW5Ocy68ma76P9Og6ZR9Neenek17g4rUs1J8OoGEmePShQMGmcKI3vXo7AXNlSSlMNxEmZDUrPnudqXuZ6yxjVCvQ9HxWoVyZYnj9dPlfnAjcBGS7jUPQkPUthOmI+OVQZj/0ZVA9/j+c06xzl0laesDyAn3fNcgfAXHCt50toxZU9HOV8XA2we8f/g20NAfE14qSqautiHZA45UpN1Ct2XZGX506yhv13Qq2BatNyXG2fTcERMpstlk4lq/1/N9K/YrmqrmDgRC2xHBqNsghbOzLYPbG7AWtSXBCR0l3VJVdpSiIDv330AOtVmRoM8vYEvQAcY/S4DjTPn66507ejCYYXDpssD0I4QobOcKCd19Yf1Phlqb6pbloM0atBvF5GLU18DQXgR+zsZgrq24F+L2RDGXvTBvKHkF3kZ0O9rkpXeDstFAM7CKNW6ft1FO8sZ0t1KgZTIDpO49hosZIVfdMvdHghs7zd47Bw+PKud15plmDqRl+7i0ivK41QUF8LstN3iTHRYmac1RjYv7mpTw4WTmVR+LiH2mOk2NWd+/q83rOaNYeYKJywixMWxPsywcKDj80iG6nL1Bo8Dckwd+TSl+kJfF6fjdK/T4SYnwWxEWOegqEyMa7kAbWiOgSQOi9vkCzBtoi8keGtt1iUGV8fjsEM40fsn6Y4VpkqunnZ98daY+JtsgqTc3wyi4gTMotUetuW0eCI/x2E9bK1Ymp3vywP043/BmqzJpavoKCezBdBoXd0SVSUTpFbr6DtLRSWW8cMNYUxTYZqBqn3DWMSjDqU+UjpLCmy5Vo03dRPzyRl4mj3x2dKX0nEwL2XpDX8x2fCHRubF9rz420vqY7W4SNTN5GOTAfACL3+jqWd4iFVR9QGGqN5+nauj0ADNGgsLCZ8dLx5h7M8W9MIHW4Ut9DjEn3F3ryQ2GfILAh7Fo+rRJ2md4GtA/rhbfxeEP
 UMg1tr4p
 eK28QWlSh5AtCqLNVj1GYar9rqsDTRo+3W0qnNinRDjxmuvamp78ACCZlnL5tZHnTjBcCAs0p+2LJLEF9iwyo56IIu4xMFDxwKhQcSzowIuV+R7IIqnPFtD5wpkyj624mVgWCjumYEEI0S9O5w1gn1dBxek9btfASaNS+2cwljyLQcQWIxLLJ/k1K/BDVHOjKWbh6PFaUpJMDHQYgePIeKS+8yRsA3WuQlgeQyS/ppZt7M528QZrdl92wCKV6Mi56hn8K4x7coY+kCZCFUdRXO/SgbGGIHHeRSjWpdja74AG/fupyAR9f4NoszkWfHKFCZwQ7BK5P2qJ5yRqRwI2jQ7uPG+d41V5TkDZLpEhxkk5+iqhTWkXbZX++Mef4iLY0j9jl/ue+AU8YRjYIIFaLCf+HrscpIXT4xfGXxn8HRpXbd3F4+YoRlO5/UXdqamPtLQRPRXiSA0zBZAiSNWaLubjJCDClgeAmQKPVUI5jcJkYJjANc9PPNQQ6CUg1cCsFPJmOKiA/dz8G75C9JxTU61uzKB/a+4NQh0EFLUDYHO2GcaUjthFnXo5L03nqDGuDaKXboTNLcNUVG/mOlqHXeix4E4uJ719uPHePcY+ZMp9wHDXc2Hd5MJZkX8yS++T/rQHxf1iu/XFgd93tLSxSI2HQSffzP7BoHgJS/q/X508PHNT1wi8UP3KSm8Z/mBjcaPHLJZqm5tt8mk93SiEhlJagporUdP6OUXT0d4xGexzBL8rKM99hBxss3q5cAVlm336CM1K/KP1ajUlOP8Y3GbMguLp6pIe3OmiYPPwo8ioowWaoOpttzx+qJjvJOUeJ+jFCaadxTpm/VlJ6YKqSdtK28F0lPtfReGPNi0Ynonb42+CcKg5rXNiM1n8Ezj7Oh7eIk/1e9p4+154X2Q+nnuqSC8bKc84Lgfc/xRwtNJG1nyetlQX2F+C8MgJxkOUJ9gyRAJvHnHBptA8fW3FQluCOz/lW
 fwY3FrUt
 dvAxtr8jsY7HW0CuXFYqzOp2Uz2D23Hz+urt3m+hFjA9M2rBEkNax/A8TKA2k0UPSeAzuhXEs+GtCgWTxGRXTK1P0ZgWk3QoegU5zPduWOpT7M3ELqSSHT/6RaGJqrrB75toR7K1ZrpJHpVloI2HnHXN6reZp8hPdbCcnSsajNQKBjtCkHGXMxuubnAI6q07Vu5F3a3YWFBocvHBMdXrccpSgLzQM1Lp7TkAaisIwyvBzN2cIxNGloPtr9borjvxkYS4wHgwJgQzXGV9KxTM7fci18JGb4POCrZMoS4x0lYRPKK8noAUb5nHQkKe/7+fMppBjf+drmUzUP1Qa6mYb+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 09:05:15AM +0200, David Hildenbrand (Arm) wrote:
> On 10/2/26 09:02, David Hildenbrand (Arm) wrote:
> > On 10/2/26 08:59, David Hildenbrand (Arm) wrote:
> >> On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> >>> Introduce vma[_flags]_is_persistent() for the purposes of identifying
> >>> mappings that are persistent in the sense that bytes to the mapping stay
> >>> there, and bytes read from the mapping are the same unless changed by
> >>> actions taken by userland.
> >>
> >> That's extremely confusing, sorry. We have to find a better name for that.
> >>
> >> Is this really all about user pages (pagecache, anon) that we would find through
> >> the rmap?

No, see below.

> >>
> >
> > It's also about droppable mappings AFAIKs. How many more users will we have for
> > that function?

Anything that requires stuff not to be dropped behind the user's back, which is
at least 4 cases!

That being open-coded all over the place is a problem I think, and I think stuff
like the PMD device private are a reminder that open-coding all over can cause
problems.

> >
> > If it's "no others" then please don't add a helper function with misleading
> > names for it and just keep the special "dumpable" check in the new form in
> > madvise_vma_behavior().
>
> Talking to myself ... the more usage I see of the vma_is_persistent() the more I
> think this shouldn't be a helper at all. Especially not one with such a
> confusing name :P

There are 4 open-coded checks that test four ad-hoc flag combinations checking
for the same thing - 'can the kernel or a driver change things or discard stuff
behind my back?'

So abstracting that to a helper, alongside the other 'let's ask based on
semantics' helpers, seems sensible.

Maybe invert the meaning to make it clearer?

	vma_kernel_may_change_contents()?

vma_contents_may_change() is shorter but easily confused with something being
writable by userland etc.

Or maybe:

	vma_is_volatile()

?

Which is analogous to the meaning of the volatile keyword.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

