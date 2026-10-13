Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46988CC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597366B00CF; Tue, 13 Oct 2026 11:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547D86B00D0; Tue, 13 Oct 2026 11:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410496B00D1; Tue, 13 Oct 2026 11:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1571E6B00CF
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:19:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9CC55120CD9
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:19:07 +0000 (UTC)
X-FDA: 85317961134.15.61620D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E1B4CA000E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:19:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KwQzzLd0;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904745;
	b=XWCAdWR+nG924ptR7T88aE+NpSUDqIRXY9P/S1pRCAk++2D78WJIbW/kI6l6yyxwKX68gH
	KuZ+zFqJJVwJZb8XdpCZEFPXB3pwXcPZ/cie/o6apC5SIVJ87/DPJOqV2gfOfJvFTlv5aa
	tKjxU93Hj8VXz26RlUpzJguevVKM6hY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KwQzzLd0;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CKkMTJue6E61UCBcTQnoX3cL83k8qvuMY1H2zZe0ce8=;
	b=cjK+p6AJvabON2gMfk76YdIzg12uaLvF2YBEhEBigl2yYNZShgwFnmKtQ6/8GM0yWSG4XP
	4XWeN0v1RJiJZAgmpMjWieXmekZFgGJp9ZMPEQZpAONjYYOtnhPqxVty/g+vIBmLbjAYqT
	emRAkNfOvJN2pcJXl+ApZl/0Upqtmk0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47C6C60A5E;
	Tue, 13 Oct 2026 15:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE341F00893;
	Tue, 13 Oct 2026 15:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904745;
	bh=CKkMTJue6E61UCBcTQnoX3cL83k8qvuMY1H2zZe0ce8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KwQzzLd0IkdgZnr3KuigFgWWt3CvCGbV9XPsgyVm7wErr8xX049v0KRHIMNmHTzbG
	 BvGB5F6cpGI/rsbJydvKueK6AYwbDISG2AkNKkPr0du8OA8pvdb5PbbXqVo7CCkH8m
	 vwbhvmWLezrPs2WlZx/MTBz/pcBkwrjI5fYFVaVKPs/+uifezGkcOXU20rtu/D//ps
	 wsoQ6dSIjsBFXh4JX3YvLi/JczbmGewVd25ebpFsqGDtkb6iJnnA7AbNfWhE0kqfWy
	 bvaY4tldxhmYg+F5Xm8KRNmKg6OPEWQz26o39rsyoNgEdHBAnBLWBlQcwu5+qdXMp1
	 jur3168ZJpq2g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:05 +0100
Subject: [PATCH v6 25/39] mm/vma: enforce that mm-managed mappings may not
 set VMA_IO_BIT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-25-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1332; i=ljs@kernel.org;
 h=from:subject:message-id; bh=KAx5pCgPSnqK5On44M7SRQ5XAoMkVBAlm39FSqythWw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZw2bKjdeyA27XNbkaKswLKWuPBKxp3Vsqcbc292v
 NAzyjnfUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIk4FTD8d2D0CzkZ8Snze7et
 u6xqdsi2rSd095+ZZ+eb3rFnW8OcRQy/mGdufbvOQo5/j7vEZaOft51tcj8ra23Uf+t/r+PQf8X
 TDAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E1B4CA000E
X-Stat-Signature: cztqrok38wzgc1aoze357zkxgbbuuwhq
X-HE-Tag: 1791904745-762140
X-HE-Meta: U2FsdGVkX18qQ+HotVpI/KltWDOlWgruevddP+uiAoQNEQlDOnd+4WEu6dZhqfw9pmjrLSR/s6qZMV0qf20k0XQNg5QXHZ8QbZjuwI72dKRJVr1Up2boAcRVkrIDoIIIQNocdEBrrvmc33mBVrWTQDsxb6s7CPM9D06DkUUpN/tZNuzvCDrHoNno/qNTk0MFwnoRjZVPpVLRvvMmdaQNdh0v+CPGlpuxGPYNefRbUM9viHv94u2LVC3oWiONt/DKtHPeZEs80NAoNDblQZyj0NWUMJIt53fDx6A0c/SHDWEQ9TIVd7N1VaQj1XkhOEnd6d/r4v3MDsIKVuC2PR7xi8OOA1hL26mDJqlHpbOOS1lTF7Wn3F07oc4qidNjnqFZHqTzGJi7auiAPnm5ndoN0bSk6NHHCeIEaGnsnnv/LHdN1l/VJEAMkOVfjzDYv+WeIbpwwlWWOWFgetMrZNEs3nn4rmV18+1AlThDLFZQQbQkR4Ysg7PfDdoFP6xm2qrUykejNLR6W5yngJfCQHg8Jtio+zfN3Yd8hE8vDiNj4II7tg2Z4f8APHZrWGZYvaTqaDGkh/9ujOb7ZFSoqQ6Rf8MspjXa4IviCfBvDSFCUj5rgUOVbuknF2qR36I9MeMx2XuskegkK1e5Z+q975RC7LvrlhZqnnc9eYnCQdl3ybdaLexKWpUSzlXBA5Eqe+ufgcm+O1MZ/ZWC1Bx1qsRDCSIzcCe2wHyavMY07UlqiUcbGDPiWaPdnLHVeW+ut8Br8x1+OZYqvdQrERnrYMfCWXNnT04ZTtBA54/U/pG+clmYDGwtednILnWgm8bsgKmlOo6hdPQI663Qrzmu/dE+fb9iXNZA03awevASz1hQxXasuS7EYm+rW05m3euJHdIAD521mX2vFZX/Ic0KVx+nNgpD0uj7wF4q39aL60oCWhSoevD7Mqs5aOySbMBGoyTWeCVeNqPSxgKoyf1fk4N
 fWCviHEK
 3/59mm6Wted5ZOHnJRnhdQQzJuhxNsfP4N+aKEWqyavlb9gd9HATLTBy78885Xq5rfqZybslqvJ5WdmUHZHhcjH4b3hAUdo4Br9eBCKH+HCib+DqffuPG50I6oUV9Hfp/DSCyVeaa63tr5tgx5Glsb2FeIlpkqUnYsl87zPtMLrwIfk+MU87tpjVfDeNfbhlLPpnC3p55Nwd09dSjUtamso0gzDBO3ttN7kjeewP8++0rifFlbfXGJ5SeRRtV8HJj4cqaEdNnVsxUwKQJZTBe6gklSCBu3mHJEZDSU1ZdyKVK0Y79+rbmqMsOYrlsu4yu1jPYyjk+7LVvJ/ytgKSgJOE89lnKpNBWcOnKLhlk/mGOFrYThua4lqJkMOieu4w4JD8EK2ObgbWhQMWbmqoBZyxhArAuolf7BEm9WU9DnFnKdlWsL4EWaYGk51lG+s7sYFWFn1BXNCO0CbzbWKRmP+BKon/iOV6F2UBox1d3eyR5PEKK4HO/fZZXYNDuVBMU3NsDns2Z9u+9jC3Mb8r7HD4kkQarWhdiZLcFEZPszAqx0tuSUSXr9FL7jWVv/14y1Br+V2W1ceWpmBxWeAO0TTTsfLWwZyLxtlapUe+bGErYsQZFOQQNFQzlt4PLPH1IiFE0YpKjRpEI0uLwkBw3a1r67uab+mLo9ucOIaLOFhfDb9sdJoZ5xUlDJsIxZ0cw0At8Af0FUh1vUIYiUkeJNML8KACGt3F4VvbdJCtYghHWz3uwBUIENwbhaojOFxirZoE3DarE6Nn8wIzvsv9PG9TJmkjd0n7+POg/xUPEFH48G25yoY3SsugpdtP3XANxg5NMK28Wcbg6+iZAzNrwb0FAAoilhsztZphN0vz8p0c9BPu/xSbOI5Q2mhMXMFctJc2cPM9iy7Q7rdGcvq4Ao0RsjtYahzJlynDg7CQPxd2z/7RBpACc1qRCsF0l+i0cyoUsLdkghY3ECOXBu0wYblUqFbj+
 8UY0hQAG
 6Tqo0cINPrTSCtqD1piXlNdrgU+AQbNuLwao574tnOQ5OSkw3Y2vT8GnRHwS/ux7NQRgjwZcvmZhRiHLs8I2haOb9HrP+LuX/XRufdokga5EclZ448PF3fysRTuUmZ8KU7fuqyqUwsj5UrEEWVLXua/NIGHO5vxYPcQR5Trh8RM/moLo1gI2VdadFEJvWu92zLvLk+bD5X1CKh7SWssYzJMBcT8WG/iUQrV04YtZVLT+s+/6YWEeJGePCtKwhg4CcwixwzF0YN4hlqNQ/62Z8pRddgbeHVpBS6nTC5tGPJw+HVgTlhxpbuBqF5JPuSuepI3xbN7Yo9Fd7Rx2CyVu8d5dfc0Qv3oaN76aZe9G4jlDEDyWrvvnX1VpXwYaol81TO6lXpbp0rCMQHpo18sQJ7lcJubOrEtwICjqWJxsXVhOurVd9OQzZ75KeVz7+bYsOTmmGnEpxK4ZjpxXjyZKMLHFfOLJSv/NrUOn379OO5t38sBMJdKCnRa5po1qI/LgjUa5l1rWMWRtufwH136NHhUoI9Dr0yIqWHvFHLvSh7CTxtgo46oaWf3gc/RZ4ZNdpuNhyAnHM+vqSvHOEi+4vqVashnxpsPPxN6IEFj26Omw3FyIB0QY2jBUaiJbRLh8lZGXfyE3hFgYyWR6LldE1oB9nxgtOrvAFRS8VSLs6KPyd339/IVmnri0X3XGj9G5O8mA0Whpe11tiYmOz66kY9+slS0TJsq5mlduYFpQXSX/ZkbweW535T5JEbXrc4Gc1xgnbh+He2aPcJ0S795wt1pXZ+C94L2R74cZPBGtFCll5JUhzDpZHnhyKKPXCoj7cS5gwyFWR+GdOTJN4flaZaT7n9ay/GACTy/4e7at2ok1c+ddGIy5f4IQlvISyPJNu9SyAuq4OPUFBCN1V8/d/6qcgNCkuHIdA3948CDroCmtVaQdwKY3+lovJgqGW0OpYGBMzjjhIHExM355zqI1JQpI+Q4o8
 ZkeUryC1
 t6wm6st+pq9vuDPTEhregJGAVVnrST64PeXcpaRTW5qowpnbil6fsr3IT8rQDLu74lS6Ee5AzKjMmoMl9sLE/+kOcW4Gd/akkBkV4LuuI3977DXrKNXzKULfF1OXqMqjaAu5WeW7KFL+7mj0iEW9LrvbrPU2izbEyRW53HaKKC2eMSL7ndwZgoLCHu4ra9FZa2gM90uRHTU+qAMYWL7fvqZjGXl1nb0rrTj+BNVUkTuQbLnTgBH5kLvt1djure1v9zfC5WuFRAX20PG+D3EdTFzLtx+cRjn9QPMpYa5GKrMgEl1ZyvwQMY2oqZNuDWb9iNXsQKlyfXL/DLmY4I6YfV+W1+SIkZSiXD4Aq7V7dT6PvRLv3TWLHiXs9eiAf++mAEPMXXDH8lBAKsBiqI+B8lfoV7kAa+RcOBfK13tldLqq2TzX67a+BI/djwix1CF1vaVOa1uYiParvlBMbvSRF2YUON5kg5BU7JxR0vW9+RuBBv9KbkhtB2ZFHJfajnlD3kNMy/oUIuid3ImL8/XEo5SnaBylbSRsp1uMwXXshA+jxYNeA3a/+xa3HFhHr6KbBgOanGEJ1Lyydmy/ufzHDes72mvBPSNPEx8eiNGsifz+siM5GsA6XyHYRd/0rASfhShAwpnh5V2C6BdXRx6+ekNTMvjVw+at/zWi+you69CPNp+TZhHxXpb+15OG3pII5A5KmoAHdwDiJab+SKTkifDisX9LvVXK66D6sWMkc/leE+8I+/ihNYrsUU5r2eh57U/px6W8Ux7ZeG8NtX5iS7/yPa7bmRp0DxfI/2mQOupqEDHNeOpYEOod5klisR7GqevFkEXJ//aJKQ2DTP28llvK//A96dDcN37uryU/rLbzIfZe6h3ruSeKCAD4r3d14LnvW66DTcYAvqwExDrdiGpPQebM+J9fvMB8fM2nHtvo29sxrGQIeZ0aPn0R3XncqkxATs5LkFrgnUWYJ4LSUFOnNEC/X
 GwGzsuFo
 m/6AXwU20ki+X+5Z96jUz1H5poUxzRs15gdDRSDB41AUCG54ztKgukR6u6UPkl3Q6LdmeqJMn+yTwwWUhj4WqJdwd0ccFMQJlP028HP0BUVx43p+1tcGAts5zQwXAVhyLJlL3Ri7NxCeJIO3igeMAfpSIPNk9fgQVxD11nE3f5TJM9hfDmdXNqxsbXxp0rN0zS4oVqtodTG1BnWg4G8Xvyvcf7go7G9pFAmQ9c6W4VQ9zTWZE+KgoIlltQd4l2tsjhZLveDqFcy3XA8OtXU2eD5jIvkd26SteOwTunDiMYwwwhzTEhv44ZZG+XczFYo8QGG+4+mzzJACrMahWUWziB5+VlIlV9LZfIvASHzE10Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It makes no sense for a mapping whose contents the kernel does not own to
specify that the range is MMIO.

Prior to this patch, all in-tree drivers which did so have been updated
such that they are marked as not being mm-managed. The check WARNs and
fails the mmap for any out-of-tree driver that still sets VMA_IO_BIT
without a kernel mapping.

Here VMA_PFNMAP_BIT, VMA_MIXEDMAP are tested individually rather than using
vma_flags_is_mm_managed().

This is because vma_flags_is_mm_managed() still checks for VMA_IO_BIT.

The very next commit in this series removes this, and the check is then
converted to use vma_flags_is_mm_managed().

No functional change intended for in-tree code.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index 6cfda4575997..affe464a7c92 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2794,6 +2794,12 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
 		return -EINVAL;
 #endif
 
+	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
+		/* mm-managed mappings may not set VMA_IO_BIT. */
+		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
+			return -EINVAL;
+	}
+
 	return 0;
 }
 

-- 
2.55.0


