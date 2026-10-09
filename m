Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC92CA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F06A66B008C; Fri,  9 Oct 2026 14:07:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6B36B00A6; Fri,  9 Oct 2026 14:07:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7EC56B00A7; Fri,  9 Oct 2026 14:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A57CD6B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:07:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BA2F1404C4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:07:27 +0000 (UTC)
X-FDA: 85303870134.11.660A581
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5190E4000E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:07:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nzt9uJ82;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lu0VsoSO5Y8jAjJ4jjJfxqGBlWm16k8LaqvRUDRmuVE=;
	b=f4ck6S2tlHcH2WDOShdusb0jzCR45dUzL5w2AyFgFNzukEwqoDKPyGICZwCEH76+o87wAe
	inxsPDCD5SIGwd+4os2d0yzUwk7jmMtDNi7C+YhqZ3Vh+jsZlYISfUuwXDvgplz0BVVBuQ
	aioBKHNh28K79i3TTNDhXOaIABAhfME=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nzt9uJ82;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569245;
	b=3UQNbKoIX+mSprt3HZ3b2n+B+/0ToVA4B4/W+gBuvlrKbZvKNAoC16S1krt3uimz91zmu4
	5YCLTG6tV/lYZlvlGpRmzY+S6U4YRRdBFv3vRrraCLsFemfVbKZ8droCLxG/raJO10Anbs
	aCtpBNrhlAnF9b2Z5JolFVYvNd1WGS4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 941F341AB0;
	Fri,  9 Oct 2026 18:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9E21F00893;
	Fri,  9 Oct 2026 18:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569244;
	bh=Lu0VsoSO5Y8jAjJ4jjJfxqGBlWm16k8LaqvRUDRmuVE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Nzt9uJ82sx4kgceFZEnZLwj+r4Ve6ZiqqxzI/3FOYjJFlYy+eyGUNbRI92pIDP0pG
	 Z9Oo2YTtHERr1CoPAaDe//rdfKOPdUBg4tz9fAw6AOKmtAm0VJLakv7NsWtSZSVhxZ
	 csnEhLiUTUet31nd8xl0FiyCIIyCZ8m/bODXWymZa7KdkyrVRBJhiTe0D8sabrzGaF
	 8mmvesQj3JB1JmrZ2QkGi805ngdFREXBCYuIzQizVPWT/azVlQvYwFiAzutLo4/0YP
	 HKGUlZzIgCY7L6hyG+wRWRYLCtNd8yLZy3355d+wxWJmUcSCfXPozADeZGocNk46dd
	 hEFmm8kzMeD0w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:02 +0100
Subject: [PATCH v5 08/38] docs: filesystems: update mmap_prepare docs for
 discontig kernel pgs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-8-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4641; i=ljs@kernel.org;
 h=from:subject:message-id; bh=auqf79oCP3yh8BA+hsHadz1V3B7oqOLT7qTOqqd9Qkw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6swMYzon//Sf+CLnh82rq71Tlves8evX/CYfy/9Wz
 O+JpVNSRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACbCIMXI8Hdlj2jHofdhXbHv
 9JkvGy5WSly+y7zW4P7e8y/5uV8U/2FkmM5W9H3Oju1V05Ue9Ie+fcr9K2te0q5pD5q+eKxoa3G
 u4QIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5190E4000E
X-Rspam-User: 
X-Stat-Signature: emwzixame7js4d4qmssxmiasmpespzgj
X-HE-Tag: 1791569245-213399
X-HE-Meta: U2FsdGVkX1+XxAAYOLlZmuD7Uo+UUktbS9pDn4hid4/EDWZi6fAJbCAZHbpPVmhoxKk8fxbcGgJ9AzVkHKV1sKMqH3XgB/2Il0fwZPjrVtS/TE3rp5SKH4p45H9a6nr/PNJmNH8AB6yH6MHtEeuk5ne3rE/Yveb1SVQNiJliMTP61m8ycciQ8fc/ryUy+cwdl1VjJ7MiZMBN7lzXgSkoRUUaHR/b+m39fLRf3aTB/DTC3E0ujbNGxwLUL6eiaP8A/o25vbEtCAQL0aJ/r43OKEbfBCDct0GIPTTYzcty+AvLNKPrynQmpkACumhAiRIFfhd3e+5uz2aRjxUyZpgZ9WjY8NxOZWF0yXuMjAF+e5mLbM4Q71/itimX0rtLvwWJ2MFJWLCn9pb3ppxNpuG4dmjcjULupgg1x7CN3uSXRrVLRQcQUYZvL0tbRSVtMPyqIxaes3JBdgG4GoQ0eW5igOTjVDMmQm5VtcZeTlFTU5f3/k3ZgFQRJNTzw3Omy5MeklPYhl1lRkFZlZOwt4eApGN1xGl0r+FuKnhJyuXOXTZxOnkoaBTOGSLoCRz1HdJmOM1ViT8tjgmcZqgpngoowSVjh+HyMTDK0A/Y0RCtR9CVKD/Q7qxPIKYnDU5Fo5gWQp6Zb/Eq0GV1friluwGrzseYvvB5U1sdiw/T51O8ryWrNhrK3olxzF6CUd+qNWn6TrVA4Yv7CDxDCUgspV7migF2DFMsZrgfIKdIhyJ9uHNinLWHPOQgWCDMdS5zkTdwIYhcpaOtyc/sdCAcdGsqs4Br7wpHmpnBhxdFALNlkmFUIzjnxjycTsnWhqNUz1qrf0C/iGde02OxaaTIb+syw6MwFQWkcfuUvXkn0GI2rmzK3/NeVJ7ORUwtFFixPz9kcjHqjgv6mFeCgSjuyVIk+/L84uTircFwWEeYwWqaT0xr7oyWRUPllP9t5+hGGdsxObsmr2a7AOrxKVI6sB7
 db8KAGVU
 27ZoFGe0AGhKm0xRiDRrkdFvYcANr3MpuVgyIai4e/anCDsJ02mM8qKPAdk/kf7/Jx7Lvde/wuXkmpSZEDsi2VEG+5P1nhPjnJdVn3/jOka/6d91h0mK2YX22+VzifAtQpZiyxnzEtcXJYYROkPD6/vA1rJaPdRk1GxAiW8e8U0PbImAP3mdtoPK13O1tneHziHa4xd6TnhMjyU80He4rixlW2pb7YJVutm+V1aX25AyL58+N5wR9mrjQM7VcXjcthvMrTAPmZr9Yn23jACwYhIOT9gx36faGdFDbRhYb5mjeNfiORldujFjYcaIvm+F3YlFPqZFwaDfpK4dwZM40z9RqRp4xS6B/SKw5eTlifXMkfDULpmOCpBmKakuDyQ7YnRs3m35TPaFTLZCmuwoRGOqodJxIdCUhkRVDhzx/poVtSG6LWhn+agj05n3hkPzB4i6Aum3AMOWmzhjU3jIMYlFcWxyXFXPz6x5keQ2i1EdRVCzuZqso6UTAr0gWl9W9q5J32sgY52KmPhQJUWHy1/kBbHNx/uT3Lz6sfPuvVDvce0VV+ncReMxY1HRsNc0XfhYuwiWuCMfSsW8511dqXntHaJ7X5clconO4AcZvLZDc9swKGJmQnjCVpyPsteSpIGSociyFP+i9NL48qqxY0PjKVsvQcMbc3ZKHe+nhO6byWjivHVZd8T86yKBObCeQdDOrCBjJM6+EaMoBjJ7OBPB9EsmQEe+wPLbvQvbwY2dezhxC/UIxurxuXW+iZmpwlXcrstbpfRyCG8ikBFneKTbcAqxInsvLgodr4k52b8y/0t++e9JY0v8btdVgJ1VDF9M4kauB9zKozUAJ9Sl2rOedcHsk8rcERT3yELBhKoMPqSqEBOa9dwnZKMHFmvr69MM0s9DBZief10/GfM7XC2KaZYQtoHGFpugE+VCk55lt0aq/knqDLp1RC5Ww0T00qFy6wNIqpyrmCjwfscw8O9KS9AIA
 sD/oQK5U
 ST/iFZ3u708tPwE4YonuQQ7pSUmgupO03kJ0uvwkKe679RFFkv4Cx2zf1p/7uuekfRemGP/TBocWWshzaCUFkSn8W4/F81a9/FEXUOmW4qHpGh45r3Lebh2XDXiPFCDqq4n+b80UVwb9By7JxMQLLobYYdcIk/g0QNhxjkmXXV6E94b9kh2lXqDHciYtrsy07iP/maElew8QOxIvxQsxAY+fyvsHYKqunKBuVlhkPWa0kYdnsFsrUxeNDzN3GQOJuyLY8taTqLYlRl3TB0NcDtLgoc5eB4KmbpjyAnt3S5bDit9L5NNrR9/Ov4VPCOmwGZN65sUd1kZDruh86rQBQu6c/OFC49PTAcUQsgv8g3b+9ezmSAdTUOyQjFA/iMcFNfju3dnGNbb/owxa6NMRkBQlnZdLqyTdniOgizNwtb0hms8bUjEx+sVW3ggDn5xS+F8eBaOR7DTgODUSL14GtCvQFGKboKaWpK/7bn1gZ/rWxrhVKOGDY0oyhzvmkh+/mzn6hOX+RDe6ynxoKOkUvDHDB+uw4uJLRxXV7lVfRM2Lvteypfv0GDLWmY9niu3knIpzRSyd/D4sSHl5g2GDecjTYWAYcCmxBzAZDM81WJVOJCBldu2V/SAQ/5tgD3OqA5gA8m+gcGw4/H1/pwZSFRH7611QaaAI+xvmneFX8snXn7aHhlBmZnS0w7dYV3s4pqFKREY2EUh9D3FTyZXTo0Pfo0meskvTyU2rMbFaCIh28ElhzB2PeCwvZR+2sBhy+ZZ9DJmmE5032TB6WLhwtRAUTQpl+9S4nLTgZehh7ZHBB2blRkho/hph0mppC2ZniZu7X4vhxoUDpJw4mEopGC7nNkXqbGQ2tqdHgUfR2b3JTf3K+s7rtggFVWaIjvQXOkXTSrzTIfB9Yc2qePt/hSngWnKxzXzRutyHJrqLtYVCIgwBPgmrUUFycyr+bpGQnE6n9uVXO1Lz4C6NhOTMTZnyk/ahH
 U2wgXdXR
 AEe/bFgtp3O6WE9LzNs6g1HQsHfrbuIFiFKjX0wn5wLP9Cthy5ii3OaE41CMZOWb/v6lvynmBynimj1XapUHcHvzGdVvwAAD9vtpAwc2IBB5ZdvKWHp9P4Edxi3yM42A1mKSajL9G96rM4hi7dCqnT6vw7PX/qEjlKamyVu8yv/wohjXFigiX7oPCu7hRYH9LF7b2Ys7k7JxuTt93RDIeAEjPQFVf5gpk7L1G9wyJ0qsmCxYDV60wVqPTasoJu5vtjuGOJ1KZm7PuATQKGZ5v4lq2I04QHHl2hV+MM363+Hw2NisvvWoeUmQ0tbpW2okdiddw3Z9HzmKwjWaljXvGadYm1+BTWJ1i62K1WRTLAXDExsb1c/ctRCGCn8Y4CV2cvlcKJTU/H1jvp+bQpDNhwYsAPbSe930ap3hHuy9ixd9oWp3DpzmrNqP8+ojUcQDNVy2j5lKvsiEjCNb2bCBYGcOwvu+/er8uT7PqukVb8cn2tIFwodWIgGtUEL814kJVi/ACY5XVtwWZ6lH9aade7ohEVzQFkMwuiaPnzRT9lMyEjouAnbtr5auWjfBYTJiAlN6Tqm+VHtgLD+fsHDKq9p97tZlQvCQQZ330jnwJNRlyGsbBf87cYrz2ugzIAd/3I7owE86OK4Evn+0Sch4UJ+hKEfMp9805S67uJu/EWddsunXAmDqzKhtHUt3hZe6ClHlcFjQmiiut+mVxFXHDPuO3Wwcolt7Rncc9go7CFsE/uaHOOR1QTR8GhyjMWn8Abu5a8bpHr5ZPRlC2xg2wCx4K0qDqm3buMJc29wrGlAyge6kf/AKyo8ssE2C6g/tIWA3NRoEgTlnLPvcqC2AcZ27c8g0MuLrOQcox3Lbbg7IPIeS1vrqUfjXNS67P3OPhKRJVJWORkreswfPK4AUwpVm24rXINBAU3alG/1btXxkhDGQ+OT6K6csKhWaA+bwze5vXMtjNA/HNm2R+PREogS26wX1l
 VRqd2ypl
 1DScenGnaD6ilDOvD71L2DdTlVMYFQO/LqBNwxoQY6NSD3F4PX7P2HlrsZi3g2xeMyJSD6SPL6M7yI5VEkj12iwCiBUhZQKr0hfqBRkb22HpIbK7iW0BHUw8PuoPuTTy5lFxGmeoQgOYgMctb4taqctEbrWj/tD6UiFFAOEtLr/1gfZuNnW8zGcQzNUZ/8Kkmr2LfI/94hOzMVvMW5qGltPwDgYho1dqkXNdVV2myUc3LHsHQhZjSZL2KzpC/Smgn+bzD7IMj2cShxEw4n0cJ/fkcFnTYtHRMF514ciFRNx0qlP9tdnPsftQQ2O+bZTP97w5eGKOsdBXPV4Ni/CrmJqvFi8Z2lAAZjp53jc+p8Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe the newly introduced discontiguous kernel page mapping mechanism,
detailing how to use it sensibly and how the API looks.

Explicitly detail the various discontiguous actions available and how to
use them.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 Documentation/filesystems/mmap_prepare.rst | 81 ++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
index 82c99c95ad85..ddb4434d919a 100644
--- a/Documentation/filesystems/mmap_prepare.rst
+++ b/Documentation/filesystems/mmap_prepare.rst
@@ -164,5 +164,86 @@ pointer. These are:
   sufficient entries in the page array to cover the entire range of the
   described VMA.
 
+* mmap_action_map_discontig_kernel_pages() - Maps a discontiguous range of
+  `struct page` pointers over the VMA. They must span from the start of the VMA,
+  but may terminate prior to the end (leaving the remainder unmapped).
+
 **NOTE:** The ``action`` field should never normally be manipulated directly,
 rather you ought to use one of these helpers.
+
+Discontiguous Actions
+=====================
+
+Some actions can be performed across discontiguous ranges.
+
+Map kernel pages
+----------------
+
+To map kernel pages discontiguously, you must provide hooks using ``struct
+discontig_kernel_page_ops``:
+
+.. code-block:: C
+
+    struct discontig_kernel_page_ops {
+        int (*init)(void *vm_private_data, void **private);
+        int (*get)(struct discontig_kernel_page_state *state);
+    };
+
+The ``init`` hook is optional and allows state to be established before the
+operation starts, for instance taking a reference count. Nothing is invoked
+after the operation, so ``init`` must not leave locks held, and state that must
+be released once the mapping goes away should be released in
+``vm_ops->close``.
+
+The ``init`` hook, if provided, is invoked prior to the operation starting. It
+may update what is pointed to by ``vm_private_data`` and/or ``private``. If an
+error is returned, then the operation is aborted. The ``private`` field can be
+reassigned.
+
+**NOTE:** The operation may sleep between invocations of ``get``, so locks
+needed to stabilise state must be taken and released within each hook.
+
+The ``get`` handler is the key means through which the operation is
+executed. The current state of the operation is provided through ``struct
+discontig_kernel_page_state``:
+
+.. code-block:: C
+
+    struct discontig_kernel_page_state {
+        /* Map state. */
+        unsigned long start;            /* Start address of VMA. */
+        unsigned long end;              /* End address of VMA. */
+        unsigned long addr;             /* The current address to be mapped. */
+        pgoff_t pgoff;                  /* The current pgoff to be mapped. */
+        unsigned long nr_pages_mapped;  /* The number of pages mapped. */
+        unsigned long nr_pages_remain;  /* The number of pages remaining. */
+
+        /* User-defined state. */
+        void *vm_private_data;          /* VMA private data. */
+        void *private;                  /* Mapping private data. */
+
+        /* Users should not touch these, use discontig_kernel_map_*() helpers. */
+        ... internal fields ...
+    };
+
+With ``private`` being an additional user-controllable state variable,
+initialised via ``mmap_action_map_discontig_kernel_pages()``, and
+``vm_private_data`` being equal to the ``desc->private_data`` field set in
+the ``mmap_prepare()`` hook.
+
+In the ``get`` hook, the user must choose how to map kernel pages:
+
+* ``discontig_kernel_map_abort()`` - Call this to abort the operation, whatever
+  has been mapped so far will be retained, the rest of the mapping will SIGBUS
+  if accessed.
+* ``discontig_kernel_map_page()`` - Maps a single page, correctly handling
+  compound pages (if the compound page is bigger than the remaining pages in the
+  VMA, then only those pages that fit will be mapped). For a compound page, the
+  head page must be passed.
+* ``discontig_kernel_map_page_range()`` - Map an array of pages of a specified
+  size. As with a compound page, if more pages are specified than remain in
+  the VMA then only those that fit will be mapped.
+
+If an error arises after ``init`` succeeded, the core unmaps the VMA, invoking
+``vm_ops->close`` if set, which is therefore the place to release any state
+that ``init`` established.

-- 
2.55.0


