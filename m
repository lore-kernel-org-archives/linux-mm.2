Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2164CC6B01
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086EB6B0095; Mon, 12 Oct 2026 14:45:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037F36B0099; Mon, 12 Oct 2026 14:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42AB6B009B; Mon, 12 Oct 2026 14:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF8CF6B0095
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:45:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 510F5A1285
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:45:56 +0000 (UTC)
X-FDA: 85314853512.07.3B2600F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 725121A000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:45:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hjWrxaem;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791830754;
	b=ikCSyR1gHpEyULLNJxehZREowAy7ORU0WGgNzV+VdjaT28beIPTCvSszyenykVYlOMWE6X
	4NACpFq9TdkxBJNLKzL+BAqJ11Eed35HJ9TmxjYoa+/a9Ua/9jmtw+iSKrWVfzSUFsIKW9
	9SwpQTfxzgXpiFAPZCvID1BY7jJpeX4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hjWrxaem;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791830754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KI+fzgQwEiyuK2apx4uDGmy8H+VNSYQ2Fwx2d5pIup4=;
	b=wt1O6JtSvZD32NqDUM+C+8ofWjh2Q2oIUZYSPSx9hgdpRmtI6vesg+M9p84P4Ygzv6L38U
	FRdv1xVT5hFKRiA6mzC0NqW6Duj/WJHZNR6MsNxvO3SMtafoTelDQ+mmvIuoWqJpVR2jOm
	D3gPNWXY8VAII6e2BXZYF5cdfCzqDnk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 88A3D41A69;
	Mon, 12 Oct 2026 18:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEA31F008A1;
	Mon, 12 Oct 2026 18:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830753;
	bh=KI+fzgQwEiyuK2apx4uDGmy8H+VNSYQ2Fwx2d5pIup4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hjWrxaemgQIAy0VI71DGFBjmeo3u0jkeRxOMqy7BoqZ/W9u+ymJ7mEas0GsWImzhc
	 flbp4TMOKiQO6KfZp57FCitnC9KNkqZQKbjs3rKvW9AK9dzNGznommua8ryR/VPg0G
	 IMHh9SLlVDzr5qkD/M6su3mSho454w2cd6rH82b7g0g4syW51uXFUgh4fEGBdxcdBX
	 /vdRxwsILB6yAtD2m5LK+zcjfCCd3cc3PNdcsUVGMD0otTqf07c2OfCVDedxT9SlJC
	 lS+iaRr74Ul6y2Jkqg/poElsdZhpNt/w6ePhVB38uVJ+q/vSobduzrA5fPJz50twpQ
	 SjkIx4h/BDWmg==
Message-ID: <c79d2d40-0f1c-43ec-bc25-b75ce975f27e@kernel.org>
Date: Mon, 12 Oct 2026 20:45:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 30/38] mm/vma: introduce vma[_flags]_is_mm_backed()
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>,
 Bert Karwatzki <spasswolf@web.de>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-30-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-30-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ffuzudngyi87krdqhw5fhtossh6udcgi
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 725121A000A
X-HE-Tag: 1791830754-692268
X-HE-Meta: U2FsdGVkX1/qbvoba9SMapjaKfp6SHAWBcr/eeM1ikg21+WKw9fFF0N+vveQH6sD+q5l5AD43tboXj7k4ncdQ944vZJTCyl7+dy3x2py0IO6Jjf6XD1M+pg1D+WU0vRIM5JONgvmdx2CGupSj4wGYrbefIKOrlpyI3i9ko7WZjUKgYioIQXRnHEq3I/k9rB6uMK6F2f+pTiAR6X8tT2YPilcl7yDECg3wbbhNBwOEygjgRaHsj0CzkD+ggDz6CbcAxm5IkAolqhm4mbqoykzqgxXSGBYifgfHhuRyAUqiXiV5Y1mKVO7Ps9t8P41JOY9Z336WaPT9QuSbZcGaIi4rFhPaS4ZtWsXikpxQ5Hqd4V3lfPnEdHjEHk7sVMl3rTbYnToed9IN/i61JIADpOnTFU/qI96iCZ941FquzuZsmZRjbjCfcl+O0rBWhtjoWH6HoLxC19a+HuT4XS28TMfb/druEMSteY3SavfOmIJa6K+yp5niqqfYqCzASgLt/Xp5oinPh3XUJS043XQzNFcuBjt93NPp6quwvuG0k2tN/fCRFjiaH5vc3z1mTP1/C8U4h8pseEpagXx4l/5/KLa2d3P+JMEb7MG149KE7sZVSDripJtTCRopM/DAlSR6s74gTQpbobxPKvQ4jCfHxoSeKvE606FmKi7y/4eke8E1HM2zk7VLQNM52T4ADanqQngN+GIJalhw9Yyq7m+daSoACDReKmCSKSUd+jersuTO2sMV1Lkus2f6C5wqq4isSKz+pokPvkatGghnEPyCUddgUW137Meyrbn3FODCIFeairkjeV0Zb4Me/TFEFD9P5mmJUerzdSbcJC90jT5y+77a+LDl3nvVQMQxhX32gJheI/NULq7LHQN88oB/7S1ru9D5OgFec3BbCXgCAYUe8LszzfhDcwwtcprWF17Y6cvQEDJ0NX0bflq1XpLJk1EsPngr16FTLK4Ko7t5YePYsC
 dSYlW96Q
 NYiRyh6dVg6tfIfYbenT40/QMqd/RoH6g3EokAN8JYnFqu4GJM9UHS6/ayw+4uHOyppiTyeNmCfwPWBg+oZeNwK2ZwZeSacgyqOqglX8L/7LV4TeWtdkA6Z/pgPOq8Vh94wtFXOGSBUF2t8xzg0qpOxzhCUROpkOqa80qgA+e4me3AojNU9m/7/jRf6BWH0b3O5nKOuL1Rh9gQNPf3mzwPiyZvvYPWVfsxvSsV6LMOPlFKR8Fw+KAMR+bMBxgCU8FcL75fYA9OMvOsA5mTEAJgkkefZbDodxQqoC9I/jNpm9Nqzbnipg5/T0erSTiwIzgXKCRDWCaEwTVApppgc+A17kxlLINba+WcBzhPEonCk48a8DnlKUwFIEhzULtxn3uN2bsY905ZOcL7ErbEtqJK39lDwl+frZJKlAsH5/6hfQ/512o44CPcMCPL/VLIbApzdjX6xa3nJ0yANl58y4q2tS988+Z6Y9F3oAPoLm87VD/9gMcFKjPxQWT94hI2L9usiDl47d8hjkHWFih/ekvpaTVTL47dwqodE0MQtand94dAIzXRPNlbpLG5D9XQr4q7Y7eNqt0WeqRV2JMSnXjfGrRKo1J5x2vJS44mLnJ+OMUoZ0o/YP6TiIl3v1L3art8ZVqhel5sorvr3fvWdB+6zfeb7liy8LUdX33Uns7xuH+qQQKlNYvgdXtWBeJALjrsNzO68tZIDsfxGjrYrD58cBZeex/oIRlRBqC1FeaJ1K5uNtFktFu9dHRkaHzaFNdFPGybx6Lj4jtkKhs9NCawtHOcKPxzzGql3OuItsn02tij5dx8Y25hwfv7VKuIQphwPEliqLLAG//ACIo3JtgOM969FeF7BmymUrZ6SRZTx1SGS4m5iHvm5ivlxKXz+F2wajYq2I50SbNeJSQl4igV6LU4K6wYGh5xgjdOpPez/2o7JMc/gOAzFDNkRTaAcgzRX//XCZjxEWg1eHiWRVVOCtuf0of
 ThDqTg0n
 AkvBrnDdSLIbKomZfZ2R/XlEleCY/jzPZFNRjzXiiA8OnrVik657gvtdIcTuXmMShZQeoqefVoFWpd9L2MbPbaj3BubZ4wiFfPP7N/nrZg/bBJcfeQ5A7DyeFtu9cGGjh8S5EW+PqPpN9Ef7ofc5cQPR9EYmhNBrIDFFdYVBset/Vdmo5269NKLyFoH6DChm6tODXjkbd7Rx6g1K/9N8D/sZfFgzUAgcgC5z9XzQZ+3evNVKz8Y3GBbKKJHEN82QomHh23A9OsRkhQWuZvU1OYLJ6R2tX3gFmNsnqQyBZPI46uDYCe7L8Y3Z15pRI6JoYOcyS8DK7/BsAS4fQ/KyE2iUFvrsrJiDtUyHP5KOCDJepwH2C3GXkPkN5mQ4uJOnddUzpnPuOSqh740V3gfOVUkPuAIdkYHymlp7hQjpAn280RSq8NXkiy+9vT+ao8K0gTeB2FOKtplqEY8gCV1eGUCeUqPZeYYiJjl8H00suIf7Zpb4DK/MByA+Z08X77dy0jVOcwCFJLHfXLaM1Nv13P9W7NrbJvclbFm7i3jtvnZBewxaKsD1Ny7otO5uVq7/T2gKzkCZlb9HZZlYu7QbF1VyZUYgRbJh6ZndnPehNX7mXCjvb/uPHOuK2J1S9xXIMm5c05I5Co4WW3wk6Y5wWTuFz4kiY3Q+InUX5rXBPMCBpXhECHanQ7CU5gk4kFrV3fQS6jAiQUoFZV7SWxcq0uR92u3BLXbo5zCVEs6Mqug/GMXcez9iScZxJdM2GwrjdGOWtrZ5b0DQPCCGnBBC41YGCY+yXmu+Qd0LJlUOCo4Nvbwb1gfAYQ5R3MEk2OB1SIqwLkKCjaoll5w67rWRqN8IAzTZQkDtmerF2N+hqPQaK05LiLaXhKbfJK28sUqAnJLp+7Ov2XENiZ1RzEr0GFtE1R3AZCyFtfBZywbc+tBUJcSjuFS5mmbe3PJikSrG3B3xZLW8EUg1tBH8n6PaSselpUN4g
 mnBcz20r
 pelPUefdD/FydHIImTdwXhWIiY6rX2wIkbWeeUFAvWwtE7SdpEzBdaO+V9i/JxVVstEV/gNJe3T2Q4/lJyGqVPfE9cf3TdkWQPBaso3awM4qdAas39YtNLO+h9HEwBd7q9Ksr5XOEeTXNhPXJOdJoGFl1cOVidrGOMHr+B6DN6r88eG3+zuJMU5ceX3Fi5fhMqoySBO/uvfl573JaNdnXwy8eB7E3zDv/VvjdBAxvDcwFyarGYBMgs4WIkgYAlCd0aCSJqTIGVHhOhBYGiXjww3gsLW+/gWFfxHjmmywYuxrHbvy6V7ts8FkItoKOzIaTq7xLjiqFBRUv0wBpfX2ykpJCmQLcKNeYWOIAXiowcSRKd3pZ9C75HpPUMFRWw85728ZPMyCTxxkWKlRmUHi0dIv3t7CQvT7T2rLO80IuqvGyXGAPCu/RnGvgFyLZEpKCzrpZ7AhmgheVvRZ5FRb/ptQ7lebBd9qkVInQQjnxwzX6kKcetEFBYHPZoIsmhKha8WqfHPh6h8mxrMQ67MoZYzwARSHl8pkhyEyywmDbIPWhZURN3aezTdSwQqEbtPiwgpqOYgoenTqT4nak9nkZD9RrZQZjqrOulTAGdt4aFbK5DAsr6l5scAZeULOEozs4DFD2d3pBrb1I9IiDWW7+z7Rhq5eM+RHZjn6cWy2QFTEWFOEB+SgC6z3mk88N5wwO3D/+IN9n8RwlxuXb7xbclhVc51Lkn9Mft+fY6/jYQx/E87OESYThszHkvJ0GrWo5MXvOOm6Si8krNF3sI7sEDjazBBIpuMhVzFD1M2RI8Y1cY0vKyxZlR82DQU2AaCvz9cKHTU4EENRie0/AL/PXNIxyVxJx6m39KxU22OqMITMVGagqkDa9plx6PNHC1GkJowKVBQPRKp4T2VzlQkNeqtbS51qqCee8mVhCse/s5+V8d8eauxYemwWGmgCrkv5Z2inIpopdHhoPO20DDu10liUPFo9i
 Z0IuRp2J
 9pO8FUdzY4RvUYuyN1yi9IdrBzx29+aBGwXNhHQYE96S+KIPxkneD7Eg93vkMH4QyWcRdWGC1VkxvE/5fHisF7k1sz2jJkA+AAIMIZLcnl/iYJbpbA17HACz7ncScF5AlIHEn7YRv6TboltsT+7kG7HVdSyY5G24fQGXYgjNHmxuDzn24rLjD8914Q4S557JlHDOIfkcuzHYWNGeQ6b7nzEXPnyuKor5DglMMAY7wnniJZvPcDPj7muY/dhvipo31qJKv7y/D8+Zq09ss/qe/b+aLZ6RS2XK5mgIv+N8k+Pg5HbwA//5dxWRqYQdgQd3ocYay1infhczsyCps2t3FG75P22wyoD3wXnJH3fz3Clc3A2M9jg0q5cpSnnQ1taBwBSF792Bh8rfphVFYsLUAZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> Introduce vma[_flags]_is_mm_backed() for the purposes of identifying
> mappings which are mm-managed and whose contents were placed there by core
> mm's own fault path - rather than a custom ->fault handler - and which core
> mm has not reserved the right to discard.
> 
> Mappings not managed by core mm do not fall into this category, as they are
> populated by their owner, and nor of course does memory-mapped I/O.
> 
> We exclude fixed mappings as these have a layout core mm cannot assume
> ordinary fault semantics over.
> 
> hugetlb mappings are fixed mappings, but core mm owns them entirely, so
> they are explicitly carved out as mm-backed, as the MADV_DODUMP check
> already does.
> 
> Droppable mappings are excluded as core mm has promised it may discard them
> at any time.
> 
> Use this functionality to update the madvise MADV_DODUMP check to test for
> this rather than open-coding it.
> 
> This replaces the VM_SPECIAL check which means it no longer checks for
> VMA_IO_BIT, however this is safe as we have established the invariant that
> mm-managed mappings may not set VMA_IO_BIT, so we implicitly include
> these.
> 
> No functional change intended.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/madvise.c       |  4 ++--
>  2 files changed, 52 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 2ce68713e4c3..55320cf2c525 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1738,6 +1738,56 @@ static inline bool vma_can_merge(const struct vm_area_struct *vma)
>  	return vma_flags_can_merge(&vma->flags);
>  }
>  
> +/**
> + * vma_flags_is_mm_backed() - Do the specified VMA flags imply the mapping is
> + * backed by core mm?
> + * @flags: The VMA flags to test.
> + *
> + * An mm-backed mapping is one managed by core mm (see
> + * vma_flags_is_mm_managed()) for which two further things are true:
> + *
> + * 1. Everything mapped was placed there by core mm's fault path (no custom
> + *    ->fault).
> + * 2. What is mapped stays there until it is zapped or unmapped by the user.

I still dislike squeezing the VMA_DROPPABLE check in here.

It's just weird semantics to squeeze pages that are *managed* by core MM (#1)
but are simply always lazyfree into this check.

In fact, core-mm manages (zaps) these pages, they are really just just
permanently lazyfree.

Open-coding "this (DUMP, UFFD, MLOCK) does not make sense for droppable
mappings" is IMHO the right decision, because there you could say

"dumping something that can get zapped every second does not make any sense"

"placing pages through uffd does not make any sense if it can get zapped any second"

"mlock'ing (and thereby allocating!) droppable mapping does not make any sense
and could actually break droppable semantics"

Not a hill I will die on, but I much rather have the droppable mapping be
outside or  have it called something nasty like

vma[_flags]_is_mm_backed_or_droppable()

-- 
Cheers,

David

