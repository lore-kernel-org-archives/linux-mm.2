Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32085CA9EC1
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42F706B00A1; Fri,  9 Oct 2026 14:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E01A6B00A2; Fri,  9 Oct 2026 14:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7D06B00A3; Fri,  9 Oct 2026 14:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F20E16B00A1
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:06:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 692B71A048E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:06:45 +0000 (UTC)
X-FDA: 85303868370.04.EDC041D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 81E7818000C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:06:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIQYUm0D;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lV50szqwhlOdZvvntvc8L71JtBIxPo0bLUpU4NKXmU=;
	b=UCPJonfU2i4lmplmesM+olRePGcXZOk1GtNy0XupucHvaQJbQVtb5SPAqoRGbSykWVcLQt
	5WkIyvQY3i7fGN+rNOqjwpNvFmL8Dvj9pQj3Dc1abhr/j3a3hmLOhFG/YA8S291jHRu2gH
	Y/Br5B5dcu/Ct+qQVVMANFG8dk0kVgY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIQYUm0D;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569203;
	b=BD2D/SQEs66XemwfbjTGEwehnBuNXs7YDJpgpjPVHZ+S8WuZ7AaTSgqsxESQi8jGatIdzB
	yqSuB6G9IAHnEpzizV44I6gvCAcZShc8oYYcIxQzlwrK22/AOsbgfq1rfLfyB9VMcXQ6CE
	XFKgJpp6wiDz51x7SX4chaajzyOe2SI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C88F941A1C;
	Fri,  9 Oct 2026 18:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240C31F00898;
	Fri,  9 Oct 2026 18:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569202;
	bh=+lV50szqwhlOdZvvntvc8L71JtBIxPo0bLUpU4NKXmU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HIQYUm0DLx/2bKzu66ezACO7GBokL8d6VcBRDYg55Zn4Va9F0v3kunAGC0L9W4d5b
	 hHz2ojBcicsTT0lGgtbhzgEPJ/o0NHbUsWdd+36z93oRd5OTOwid7Fpxq5JlvboqQ8
	 nHsW0BujxzAyfC/urZMNuug3vDxijOAlqlXve0WOvl1wvHUkSAVON7aZOTHGZ1pQU9
	 cNbPPSpf7UMIWeX5IxzcpXQFjOEvEIam0meh5LWCITsb64k8WUQ49ynfluF7//78jj
	 Qs8wye2NHfNLTB42oPTPtyZ25J5aTsiVuQ+4kMEVzE78xiccvR3JItPXy0ZzNxrl1e
	 J5koIBJyXk5FQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:00 +0100
Subject: [PATCH v5 06/38] mm/vma: tidy up map kernel pages enum values
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-6-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4144; i=ljs@kernel.org;
 h=from:subject:message-id; bh=nvhkE4iVPWt6ZMbpDqr0VjZaPTTvkSGU9Bdm3A6LGuc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sz0ecuhabPRdpPK2Q2xbqfD67XmL3erXzXlSdUsS
 0GX2ZyfOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARX2eGfwqMUa37yooF/+aL
 czQu1hOX2d9kaRxstGbleU4p3QuZjYwMhx/P6ddiYrn85V5Rm4dPSMdf3oxXOc6tuj8ez976/Po
 dHgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 81E7818000C
X-Rspam-User: 
X-Stat-Signature: 75uqg68pgqprastkd5ko5neynjsi9byf
X-HE-Tag: 1791569203-978969
X-HE-Meta: U2FsdGVkX19OUCTab3dMBy1qJtxerOtIzJ6GJpa9HcoocKY4yKWD3t2Bb/6VwW8apXBhx+RmdrNfQq3AViRquYVGbwn/Sx+wfEe8hYj8ycNEz5zLqBYXwjbcw5UI8l992VtihQ6GqbkdjhkXVcOJ7PFx9UY7CJc59FzumhserprPikLFMxZT8PSZQpex44iwA3OC3v/XVA1VkTFzLHj+IpPyUniulOTdgXX40bX9dJa1pNMcvFudyScY8XDNC4fPYh08sVyB7Eo6ttArCaho47/+xpaKXDMImpkJd2VAlQuMVZuzbGfGMlBrvtCWlM1IXSv5ez+ei7ozRtXwoUlZipBrHXCJ4IRJpHrIdsnvbGG8RCZjQv6iaAljgX6yJQLA9XMLprVs3tjET/sPcBT7HCENa4fnvWpdInLZSEzABs82rDmoeR4Qu8x6pr3Cmif1OT3hmUZ4dKXle2tkpLhbe9S7GGmM+/mfWx8CvDMaHcxPgDfwV+GI0DcoSVXDOWzbxGDuiLpGGAN1fV1DgasLw8zeEfD9cUZ5dODFcNB3b5VvE26A7pEUjoVmEQiAvQyc4UMGi8EhxwVVbGpmSAdyDEB1VTm82CM7E5wsDgKflzLgGpxJRltJgh1Uoafmfl7RC+S+s1RkRFeg8d72fqp/3lCAtULWYocSuGuqDSEhn6ivojK2T1j9wTRQsC1s9zAQc10Hyjj1VmBv0ZtrkQ/Yl2qQandohEQT4u2nHJ8xGXtpQxFWrwCVnAJkaOm4ZZyLRNo54ktJxmGAHdV7ihWzFDPaDS8zf6rdXflOKgfB0iSW4+NAERjwr9NEJkgQSx6p+KivjaNZsc6k8/foxFN4SBknlDzkMjltAcUy616acqpw52T/CtfdjZp/VvMWyRFRP1nWAZH3ixTNFYSDk8XCLNl2NNA49Va9hydH+2GFEvDBWk9um8LvKrgwwMqSbZo2OUl+CT5qdMtMVXsmya/
 MjdA2Ate
 a5QGIaartH/op+xf+bI6yzTxxdCC8qT0oB0YXNWV0hU3SnhhX4VfEQdIrNFF4LW4cRqQ8qX3PxCSORShhQGa4fpuoQL5XB5UWKVNv4KPfSOhYV2r5UhB2B6vkKRSMceU3H6/kizyu0r6nYhpu5k6jUxa8d2KTUOcvmiPTlQMJWT0GzyFHEGiCz4/Vcz90nhWuYYJ7W/Q7vjZUvuRpSvX7HQfvhVBKaTeaME3e+ES81QS+cgbIsm8Y8r3wseK3voiyqvlWbgupo/0IfX8kjmBOgV56df3b7Xt0llBdmV6jminUZSs0pLeDTaib/DxAfjLd+jdW3ltoeNpmRpULCY88eEBFwSRgOe5zg631HcnBhQRod7z/Qqjk9bbl7PKBBg391HRlpNCD3kc6D3fUQ1yYL3yI2SyofPsBY2Zi/BUtd0/6V+LUhHjVdwRqzeq1wZFdSgqJUM6wkGVPe5fjx7uWod1mimD0DxudTUBNAcT+iKyqwXxDQjkFc/5Oj2tjLUs6zfR8yTj6YYTHUl0p9PWe3WxWGjQsfAqLyCB5EQVLnsSfz4hOxw7ye9RmBgjLalvmOCoKVH9sbfXMteZg4aAeeUim4a1YvvmWpUAhKfeL8lwn5WkKYZFz7srhbT1zUf/fFeOc7tFdwD/c0FY4DTHW4IBpQuGjCYGZygRnKW50ROa/WtQ7V+s1ntsVY4dcDBppoD/5rVgAC8ocm1QjLyhhtCHf9Hc5QczjyX+bG4Z3Q0jxKj3limhFdrMuwuOqD/gjENJdrVnb2HEup+fJo39ZA5FqxU/RP2Sno8xIGDB9Rl27lR3VFaJe92sEhIvC6olb8KziuR9kQD1uhdZrHqXBpribrHe4Um9ujxODuJGtDbWmJc3q9KCbu6T8rSZpeAYo9CjS71crOVVTt2Ijfvue6njDG48poNMRKJDHRA7ZP/yfdpXpZALLF8ahXnbxp1TCA+DxKeu4nTYkrFVqaIZql/XFjgaY
 n4k5iOh/
 rQ2X5kutkixMuRy3/bjM+NXg77BhSDrbradQimAnMsVa6StVJrRGAH9BHNT+lffeYCDrAeWKImZOmWtZiEd89jcHdNELvLCbyj0tHj3xDR0hUduiTP16rDji2PTl0UpLyRuIKoUxODL8++Ckt61m+zfCovOjLBKW7PlPqrVmgw9AMh8roQ2q4p5XbGYTipwXPaOa3CUBgPQIODArr/cwZNDP9Bw6Br5f8cohB8Fxyr5BqGmZnoDltiOqBNq5dpQOTm/s1XFfzcJD1Lu1YEkO2qrHyFidzp+8ll298cBCEu3WANcNVTL6zN6sN4XTV2fR6TNR7Sl1PK8kYqUeU1PDsa8HAes/iI/vRvQsb2diqvLySeEmNXJszR1HuaovBsDOPOysuXABmJLc3+A3XPar68TYLiXyTWOWbQrcrr2QCPCZwlzWqeGQ1y3XU2haORlinQRIxJsAIvYeFqcX3hekcvmGsDoJCSs49umhLec8WoBTXUqF1xxR16oerE0HeXVOFP1mNRDy0TBKncxScBz8unZD/fCLOU/6iZpAyo2SPInq54EnNBE8FD6XV0y6SjwAMmVWxLUD1o3lrOaHidJetidxS45OVxDYc6npv6BvjxzT750Yfx5XWyU70sj+D2wxeqHrf98oM3c9BtXxloSQWOsSWMkdDsQqHuL76vaXpKzDKNLJYDGl4mj1HCWEIysT12B2BioNdVTj/S/clr5SjHg1qdDmehIB9aEDdGG9KXdNr2AJRvutqthyrlNjwsGuVQq7djjI5Ca70gJ39ssiBk0srV6wk2le1tNhoDYSuEBCZgVzwgaB/oJeoly8yny1CZ8l0VE3GVLOIKadekn0uservL/qkefK7MLvwreh7lGA5ZQPX6UatTEyOeba6LSf7qi0WHztPBxz0Yzvi51clUXxC4OsIPHnIrlA6zqb+7RFjnUCAsWUKU1w8mVfZS6KmdqZoaO7tF72VQL0qj4PO+9l0Oqeq
 zIpKY4lq
 5ZrstONowHPPktkrhYWjTNDH0kk1JGdw5Pq2ukWKcW/IJMJonC6wag60ZZxPWoVtMtnDC0jCky5nhLPMGrJN5sAvTASj2o2RuJQyI6mbVtc7UdTOZaiu3O2xwXIbRW2GeWhPN9VQOPFBBt7xsYA9LpXQY8qwI8FDmab0wNWt1fyTnrtd9nzhCj18WBed8/hle/WkEl5Z2re8GlijJVH2z54FHFln2DXigOmZeGI9dw0Ue448WFbdfY+ZUnymYIgxukI6UaBqS+teMFxYP6xS/XwslIyT9zqftv307SwzMeeeCUiUGjKAyr28xJ2A4GmuzllZ/6VC7hAoQ1ZXLlWw3nKxVPgIXg0KjqH1BuLe/DsMBfkNx7EdUZwechXTqlGmm5SJdIP3KAfcIPJOQE0SGpdT+MqFb3qX8Jv/NDMp+oIRyf/vvf0kaVjFXgRduSGz6+VUQpu+DpgFSMWjsRVHc2XmB9kC3TQ28TMAaP7jYQ2bZ/FOLzy4LH3uXYpHh87ZhRtAIWwwIR51jHZIoAIzu9KmhYgCBJyqhdbwn8YymQFZgE8/MECiNQniCjh2aYNNu6LI/+83rnpd/kM3E7K9PXuOwH1zsNojPY41pF1Nctr5VdasVrsIYIgoSrFFfSWHX9j8E80FHrJQ+IyIwmG/I3AzedHOrmL8omsQcMfOGizpmaFlEc33vUtfB+v+bxo1KznfL+2809MvKdR0go43qFuE6TeM4F/queJe/cTep9zu54KCRblcdFzYwWRKkdQpAIOiAAIg1VKV7hnWioXo+ZEiOtXzyVBz51HXXfVthB3VDIJ/XbSyRkUnPyzTsKjefZAv9d5LFmP0dsOeuKd6XPFxpscLsqKMlteCt07HkZs5xn8w6I1HLWvIsPpzPD7al34IKfpp8Xq8xp7pnAgoHTg7wMI2I0LfCGJcSUhj48ktQP3+P4WucEpH7Uh6nt3z63WHZNFvM2Km3n/95Dky5njb4Tett
 g2OH0F0e
 KLQFu+NP0dVsGPHI++KWprwPIa5oVWv5m6Rrp2U5OTj8OAACWlkHqQgRgeEVAR2OYuyr8+UjbI+6ABeWSYggdGLOjXrLXBiZmKojorv/ZhoBsiAsovITYu9F1kgYQyVXArRXKMFpYpkk6BurTmctAJK/fNkxBOQaeOa04WqTUF9uvvURTGMorv0a39U+JGPsZjXp+ai/fH8L0DJC23qFORKnL27ZeU2JSeLoQR8RCdJxf8i8V3cZmwzcZT9Th+sYxybR+T2uBEmGiZAQXp8naUwol0EugOEmSyTFRLlibZdtFaYFJmNaJ+NohUbd9+or3isg5HNrxiz/d9Lo5uM0tTmaCQh2K/GGDE4YBLj3tK+PuwzcHJZ/e7H6jD6vo0/xEEx7Z6fpzJF142rd29N8pzYGulMS6BrRgJNqSAVug8Z6kZQTfS8/1fy3odqf5Y3aSBAld1fmPikPnSI2UwehdxQ1nBlvuLI+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
MMAP.

Also while we're here delete useless comments for mmap actions whose names
clearly indicate what they are for.

Also update the userland VMA tests to reflect this change.

No functional change intended.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 2 +-
 include/linux/mm_types.h        | 8 ++++----
 mm/util.c                       | 8 ++++----
 tools/testing/vma/include/dup.h | 8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0c17f0932b76..a1f2d375cf7d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4623,7 +4623,7 @@ static inline void mmap_action_map_kernel_pages(struct vm_area_desc *desc,
 {
 	struct mmap_action *action = &desc->action;
 
-	action->type = MMAP_MAP_KERNEL_PAGES;
+	action->type = MMAP_KERNEL_PAGES;
 	action->map_kernel.start = start;
 	action->map_kernel.pages = pages;
 	action->map_kernel.nr_pages = nr_pages;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5413bd10fff2..9ca2ea3664bc 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -815,11 +815,11 @@ struct pfnmap_track_ctx {
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*
diff --git a/mm/util.c b/mm/util.c
index d809e08c7b4d..1660910e2a22 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1467,7 +1467,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return io_remap_pfn_range_prepare(desc);
 	case MMAP_SIMPLE_IO_REMAP:
 		return simple_ioremap_prepare(desc);
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		return map_kernel_pages_prepare(desc);
 	}
 
@@ -1498,7 +1498,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 		err = remap_pfn_range_complete(vma, action);
 		break;
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
 	case MMAP_IO_REMAP_PFN:
@@ -1521,7 +1521,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1542,7 +1542,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
-	case MMAP_MAP_KERNEL_PAGES:
+	case MMAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 077df510a311..023ad6092e9c 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -454,11 +454,11 @@ static __always_inline bool vma_flags_empty(const vma_flags_t *flags)
 
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
-	MMAP_NOTHING,		/* Mapping is complete, no further action. */
-	MMAP_REMAP_PFN,		/* Remap PFN range. */
-	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_NOTHING,
+	MMAP_REMAP_PFN,
+	MMAP_IO_REMAP_PFN,
 	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_MAP_KERNEL_PAGES,	/* Map kernel page range from an array. */
+	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
 };
 
 /*

-- 
2.55.0


