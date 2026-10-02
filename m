Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 743C3CA5FE1
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 07:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA266B008C; Fri,  2 Oct 2026 03:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868F86B0092; Fri,  2 Oct 2026 03:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70ADC6B0098; Fri,  2 Oct 2026 03:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 499FF6B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:10:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7CF7A7577
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:10:21 +0000 (UTC)
X-FDA: 85276812642.06.A85DF3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 178CE4000A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:10:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jAQYjN8c;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790925020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z0R+AFuLfT7LW4bS8vfoemEDpRx0M25PpnJ7rizmkeQ=;
	b=3Z1DfYSqAm3gPgZWfbw7Vvnd+FzpyS+nTcLg7wNPzoVZ/og2EVR0JaqBexo3UNWLuZ5d+X
	lhYyVSZ7hdMT2nYlpvPQybMK+M4XGkGr1/3lXF7Rv79S3bj/GaQAzt/TkY8DkyI9AAjZXR
	sR2aAkLONRSN6Jfm8I5dPFPoOfnDOls=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jAQYjN8c;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790925020;
	b=VjAkPsrxQwZRI3GS3+xI8iTHZp9X609rPlr7WvKksqz0dJKeQG8UYbdiar+rlzm9tyiA9h
	jEjUj+l1iqg6EZrkaq278UPHUXW3OKXz8eCVMwRX0DZjxXmPfBYt7q3uj4Xp8GPRzw8URf
	iFlUggIeep44rVvLvOu/5C355q3H5+w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B9E542E9F;
	Fri,  2 Oct 2026 07:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986B21F000FF;
	Fri,  2 Oct 2026 07:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790925019;
	bh=z0R+AFuLfT7LW4bS8vfoemEDpRx0M25PpnJ7rizmkeQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jAQYjN8cqx2Chonfaa3UgRC+q9FNer11ZTc3ym7gN4EzSUnN9yctP+HSUzPW7Na8T
	 XhXLG91INpSlxd1n8jme4BLqq8xlMmw9OyKrnwO/SeJSsiJsgHVqyQYRHY8JwXl4W1
	 JBfwx5JRCqHlYGZTghTyJgnt+WhRxlmjtx1r5DTj0z3Wkm0FuPnE6IssCOmqCWX0WN
	 i018WlOPFgg2mhJfBffqsM+y+RA+yPh22TTQPO3V2PJS5zyGxn2clBuLnsYWtkLEwW
	 Azz54A0Xm+rXoq6gG2ZN1AUO3VP2I2JSQJCTgseE8QLMDwldkpQMvF1Okha2kXwxVR
	 /ImSq7OK+twiw==
Message-ID: <799f9f13-1462-468a-a6e6-6b8bd06c0fb8@kernel.org>
Date: Fri, 2 Oct 2026 09:09:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 38/40] fuse: dax: do not set VM_MIXEDMAP
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
 fuse-devel@lists.linux.dev
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-38-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-38-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 178CE4000A
X-Stat-Signature: 3ab6g15d8c7itydz4316o4the87tn448
X-Rspam-User: 
X-HE-Tag: 1790925019-891249
X-HE-Meta: U2FsdGVkX1+O5ANE9DxsypILJfNjxfudHziRuudhbdwuvnx4R0k+59iZmcm5EugS+iPFzeD/fACfmpbcJGZf+Dq4VOG6evNkgo3NguN+fmqc8tGP8Lw0cg247awQ+bdRSLIc7jLw/oGVtTqPWqmCTprfnfNIVoQ4e87kKdngQyBIV/OIR30DT86++dic1QbNtfItxQs9utJ8e470RvIbOhzGJspZYtC1AU+cOHe4cVXYrAVZfUnvHUXC2TqcZFJ1BHaK4hc+U4mfE9WOrzs1cXcXaaq4pEKHC8bgFO1EbVYeAHWqgPvx5h+MTVrkavEZKxgvgY9gjjuJ2UiIFuubN16VxtHWag7EvFwGjUVSoxhCh0sw6GI5rqmny/CEG4fuvolgiZVkLdTVJl6Hkr5m+ijuxMMNVrQlS//zOCkChUG2pj3EZTTbWmyVeDj/po/ZFD4gvxeOZcRIBtMpacGF7PH1yPSKewwk6Zdu/2/t95Z8q9Xf3iod4eX3rMxtcA0T6/uTkkIM+49vQfxlfMKGGVt8UvBFNoz0fTxd8yT6a0d4JaC2h5gIYdx9V+8iyE5YVL9mh9UdAWCiS7y70oLYSXThQnjVgRjZRmqdisM1OKAe0lSCveeFUW3N8ea3YuabPuotJ1ZH3/y7VWttLQOatUzczCCsWHcOSSC4vS8CuWG4Xqwx1HbsVnNLotXT/PllUtr7b2WzFrZn+5NWTtM4U8dJ9NdRobboEUFdI3vfyw/Y+AVhftUDw7ghd2RUifagsd0dtXUIRE2EBwuW//MoP3O8kMliJDpl1EntcAlkfVKKfVLO2ZMFxZlzF/ec5Sm62iXkprkv4/jYIsifW26UyJqo7n+24AYhRnH+Jd7uI+9a9tixoO6zrHalA7vM3gMkq/MKKD4HElwxLtQhtv0k+oVTpGpxCsIEr9JJ7Bup9azBzPX5sxvCC6XT1jvglBiCNn9VJ+4Bh7fsX7hdfxB
 /yfwOGLI
 DuxI+P9zaffSYBSO4a5Gi5C4XuzZLvrruHijxTjSI3I2buyU1+mgfMVJGNuQwNRGZ/kIAmi/arvF4wzjCF6OobCCVoYlaG5ptFk068n/Hk2TIlmYM3wIcnR3fdgGb/E9zSN00SkgA66UeQxvSuJZ31z6jEH1CZ/8JDl/R96h0n4T02unXWoGtbLGDeJpW+hH7racWX8eY8j0zOahykfLA5nV+z+ijiTrsxMQfCt2vSgumjH8DT53oGIseKqUPpzrGhIexZxlyidvTr13Ta4GfH7e6luAUkoS4UnYS5LCO48GWdzxksRDgz7q6dFXQYOvbF606U3mV5Dsp0P+QctYvyyQcZmLMpEA7SM1jcz24oaDZzmmSaSp3oIAKEyStm9wklmqsBebV9Z+hldA+jcQ5eGeR12ebkuBSH6UogZ+Nx2cYkxFwTuLo1goq+OPeoEJL+iQaRadXCyDhrh9YWmMvztQASfXDY5/p1o1kx5wUtNLFJgJqrN8ZF5IKv9+vQUW8eL2OZY76M3lDypHtBLJBSRJRXUgdxtaW4PSw3DNbN8nl9FRpwMfKsNyOSgzKz1jmndIFEMdoCqiSU6lH4LdvQtDud67kE/GBWMI8oGco08CPDJmKyeSVXHb4TaL7z2Nazpsg9XWbtLFzbnSO+9yGrJiurP1QpnVnmezMa1aGOEPwwO5WoIOxRSpjGcnaFpTzwFtUxZ4sHs13fLB8lyg3MQHSygdWLigF1eQB6xa5e4R49v3qe+QLsAPnqPo0IG7mjHmkHfFMI6k26zNBTWAeQlrHrxPsS6FHkcxyPFoifCz5gqOMzQXXXw/mZ9NYnuWbAElXeOR077XPJZIYf35uypEyPmptdpwVgyeBDnRVVJFIqLnC5iw5t713KD/nUsJG5ZuH45gCJpo7crkVF1r2THJnYw2N93b5rZDW3JhZhlJVhyAUwl2tG+jdqqzQf6nmn/AYS4zmICqncO+oD98bFXcnhCHq
 iRG7xRvK
 XmeIJL9RN1nX37at7pRVbeg0S3wrmvtnhxCCFWA+bHWWbgUoJbaZ8vjVXAPGsRdGxJElq6n7Tv1ofFmxprq7MK/WdG3J0iQ97dD/xZTJ7/a3zWUJtjP8Dn4YWVc2nVS+iAY/uglSFvAx82OgUYTXNZgzymignVniiAYSbDCtoKdO4Pdu6BqGeDCIdq/7EKXB4kaiI41kP5+P7/5+PMjjyWC+7tjn/qaPC425OscmRNJHgJGXZfqBeEJBdpBAgFFZdTPELb/jqOejIQ2O2Lf1c6TFjD20pk/feR/U//RKPV/0Nidyo/NQNHJpXhCu2WhadEsmxg7vsQ0pC7V5p2iUxUntBFW7fh/JrZco5E8dBhQCKaHNwLk1667HlIc9rYYQ7HXe9YoFOCVw5o9m1J1mdbtGdBzNTIvwmgz4ZEhQgvqkg+eumJFUCMFRvHhEsm1yWFh1nD5DwAIf/pTrt44JRVKmT/w6aePGcUobYOGbr5uf7/3++1RAX5yLG8r7RG9Ta+9XHkZnZXWGAtadCykOhWNKJtbdfZyj8vmo5AlVmHxeqh61PyA5gnG/E1xupnuRhF/UY5UAvkwHAi6+b54shXvZLwTV92nrOJjm8PUDyevqDBfnm9mP4tO86ccseN8nPubtRhVf8y1nQlVXeiaZ6ukHcJLAbJbTWwBWdN+Y0yhs5z2PBX+bdFxFGSIl785ZkAZ+63UlTyU5k0cT8t3Jnwksxfbm+MGFzM0BZ5rR9E/qGSN4xqqCnXmMTed6Tk8v+NfbvLC8PT8aTTBSYLGcjEPg4vNr+L8iRBRwQlGGvgE0MVvGkOgXI88OmTWe/6jjAPMn7gElz3nqr7g8ucLTy9gDWFeDvAE4CEIfGnGHNmZGANAuPrKyJerlFS1ceKey7CIzJTVXuRbEEkjSua0m5bT2HBlsdQ7KIYccWR2Q07faHoDi+4terYylDiSvy4mRMTt0XWAIKwvrpogtVW8G6yO05mRUP
 edypsaQv
 h3igNh7Q4A3aGHqX7fOK/FgynRkEN3ouDZ4XE49UOxd6/KnkK/MCcRAoa1sWjwQ/IWKKEnryUTmI2RXLblmOiIx5AzV08kzcWatEuKdItcYayUU+oCRtfuZvm8aWZBd4zbWljV9czqg3iD7TmerSS9+V/bwsRwKcU48gArj8WQVKU+bC+YQ5MyTXZfQxwW6Htz2LyVLVUXR2lyyXYB+NeYAagu73g3OGFbB1AQ8Sm+9V38706eG1+UwzWh1SJHxSuG5+0uxQxY3yjnnDlmbG6v8uNYXzNZlHnIiX2e4TthPlnqk8JiAfE95OlS9l4o45XXsK6khbz1KOwr8xY7ZxnS6gWXEafhwHeesXwVi/QpZqzuO3ipvblv0Me1/ukMXDgygNeTyB3jikxPSmUaWBMahO28Md3FSgNc/UzEK1KiTgTY2dloF3KXHo8LSbUCz0Zpw/7yzD293tw7uf/n/ls/uK3Z6nbvqiH0xJGPUFjtz8jEKfbLQ9qlzzoJZvHph74k8ai5LQIIzegdJM+Vxz5xxdpsmZXu6c1udVJi4BnAZ/35bw2arhJQfM2c63QPCrwbweVsTnDPgkqtiC0bMBTDTAK8KWPLZMPQ0sCtc2MNfuEdyUxpawa0T8PKjO1azQIDppfZi8SM/INp8EdgWBgud6kUvbdr5Yqm3QFzoemnPooMouJXpXFptROLRN5LDMiZ5aLN7YJhquI+PwdPCEIFv3QrI23cgPio8MZtgc+3++IRV5Oab6r3SiaJyMmOVwaK3QqO3zVJwF76zh7gih3URt09nuZtwttWk9DVWGoz5CqP0le3D8oMj2HuVXYNksDyo4uUhP3X6+9j+IsiuazPFd2fib1QMpj0bjXX+duQ+8fnTW7gS/guPUoEt+fqU/8MN5cLbxqu4R2bxe2uJmVxvu60WK/8hxE6iiJsgXzuNTtQW73TNVECDqf1F9+bdX9aAzjy+MbkFQ3gSW1zs8cEj2de8BR
 SyrMe1qE
 m9gKsl8lXt1UkNyla3m7mAACJ4+TQvgVBPeyTYdj4ZFVG7V+9THDZbkuU2jo53tDoGjZZGuLfIsblarSK64tgeQQlGc5RUPs5HA9fstWUSwOl2C954CfsDrlC7zZ/dKAhhUmAFJzri+f2/BZjCgUxmRjhrfY7+cT8pzaoNtKUKLCCz89n6oVW4qML9a+bcwoYrGV//EdKhN7jTZDZU557w5At24W6LUd+kp3u9KZ9avWvGmnLPhJjyC/3ReNTOXN/pqo9krqDZacSkwvFSSvL3Fn3lQsgyXQAE5n5wmCAsunaLAufT4Q/BxmKVtfh8px3oNwCd1ejlPp85ckRGy/dJ+dSf2ury7UKdWZSNFwADTl7fGJ7K/t39
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> Commit e1fb4a086495 ("dax: remove VM_MIXEDMAP for fsdax and device dax")
> prevented fsdax and device-dax from setting VM_MIXEDMAP, as DAX no longer
> relies on it to direct core mm paths.
> 
> The fuse DAX implementation, added later, copied the old pattern and still
> sets it.
> 
> Fuse DAX maps pages the same way fsdax does, via dax_iomap_fault() and
> ultimately vmf_insert_page_mkwrite() and vmf_insert_folio_pmd(), which
> insert ordinary refcounted pages and so do not require VM_MIXEDMAP.
> 
> Setting it only serves to mark the mapping as kernel-owned, making fuse DAX
> the sole DAX implementation whose mappings are unmergeable, cannot be
> mlock()'d, eagerly copy page tables on fork and reject MADV_DOFORK and
> MADV_DODUMP.
> 
> It also requires vma_is_special_huge() in mm/huge_memory.c to carve DAX out
> of its kernel-owned check explicitly.
> 
> There is no reason for fuse DAX to keep on using this flag so drop it.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  fs/fuse/dax.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
> index 85cdf0199bc0..a5994f1c637d 100644
> --- a/fs/fuse/dax.c
> +++ b/fs/fuse/dax.c
> @@ -826,7 +826,7 @@ int fuse_dax_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>  	file_accessed(file);
>  	vma->vm_ops = &fuse_dax_vm_ops;
> -	vm_flags_set(vma, VM_MIXEDMAP | VM_HUGEPAGE);
> +	vma_set_flags(vma, VMA_HUGEPAGE_BIT);

Yes, I think I stumbled over that in the past as well:

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

