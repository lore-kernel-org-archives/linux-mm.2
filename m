Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82AFEC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2E866B00A3; Fri, 18 Sep 2026 10:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DD1B6B00A4; Fri, 18 Sep 2026 10:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3096B00A5; Fri, 18 Sep 2026 10:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63CE26B00A3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:30:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61C781206C7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:30:21 +0000 (UTC)
X-FDA: 85227118242.11.538C30B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9317580005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:30:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=clSyf51X;
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789741819;
	b=SqbgeHCcBaUw6rn+BUAk4IwY6a7RXCnam3AgvkbMj8+6g0gsXRDDVPF8ztFy3iRfXroS1+
	BsA/Wip1a9T3RoGNyZJC7nh0jOlUP+l2p0O16DAb0WAybxMQ75EK4TMl9NghNo7qSCF4+I
	wHZOsrchEBDgLiorw3uzpaZjUe3V/D8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=clSyf51X;
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789741819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z8DxBDctfQle4qPyCLsPEBU1oRIWLoRdyUpwbsFqYLE=;
	b=CE5HhZ2SOVzGnXH7BgPuoIo6nAZ6rXbcAWgBxo026lGOfWGC9RIZo0y6suCC/I2q8qj4DX
	lRjvJqgJrnksKkDDxXMfVHRhoqJZK3+79fMBWSbP7jOXXQRSmZf0bZKHKxIEo80fo3jrAM
	9KuhqOL0ScQgvlsJesJHmDUq5SW1QH0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z8DxBDctfQle4qPyCLsPEBU1oRIWLoRdyUpwbsFqYLE=; b=clSyf51XrV8aRcbTvneX3p6wBa
	n2dJgPOcz894gpJOnZdCOcF3UEXESwNBxWownSVKd57lnJYBBwn8UK22mY+Uu9cTVCm4bYkkLdbb9
	zwnoTjkKMM6lYQMFHN/pynLhjEOj2/5EEiCk+CstXFpuvTmB28MRP3Fdyl1b9KhwvkjSzoEaggt5r
	4zu+cgayQfsFLqmqeLGe7kyw0337RIawLytCxdWbLSsC8OhbmfdiwFeLxFGinxIHnQj3tRZJIvubH
	Z5p2yU1Pjs4x4ZBAOVPASiIaB3Jla/kGk5xR5Btk7PaRjSjDUhmPE8iOfBuqPX68vAPFbXjRIpG5J
	q2qapdRg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7Za9-006nCZ-3B;
	Fri, 18 Sep 2026 14:28:54 +0000
Date: Fri, 18 Sep 2026 07:28:33 -0700
From: Breno Leitao <leitao@debian.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
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
Subject: Re: [PATCH v2 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <aq1KeFmXBIEd2YhQ@gmail.com>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-1-7d9781ed5361@kernel.org>
 <aquz9Z9JrK_H_E0g@kernel.org>
 <aq01JFp8hRReyY-O@gmail.com>
 <aq06hcheI4OGi_3A@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq06hcheI4OGi_3A@gremlin>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9317580005
X-Stat-Signature: h7a7n1mse1ss6e3szfbfh8oee91a7efr
X-HE-Tag: 1789741819-444905
X-HE-Meta: U2FsdGVkX19r6Gd1n6My2bL3FQ8hxPvFBykWVCpoRfTYtkumeXy06BVCzxEhNzCYIBcaKMAq1CV2GRfZRPDQxuVQ/MBSAIAUHp7yqvx9IilmGtP+2y8xoTrWn7Fn2FDZejUMtqBPyREl22TWDL21v3lUjIpqZ8a8TYmgKc8Y9Y1M3JeteXL3PeS5cemz563cwIC0/Vfvr6R6Q9DISTzf1RwXGp55L/wGDMBLq11l3n+8bgaqUYYB3yrAhiMRYxbgMK4ZFbnzZdDXnlxVSZs+XCr2dF4n3OvHphZJ7OR1FfHTBKy6RytJZeAtGOjYsCVpuAOVOvQygdvS04FWM9T13i+U1sPrg45R8Vw7qaXuCQQFcqQmHSBMmd3vCn027BUv3L34Iqdrh3EPF4OOlMnXhXo+7lk+ywEg/UwkV1mg5is1gkiwmCRq1fxun7GuZbRp/dQjKkReIrQoTIvJPWRcZquJBKE0QGVdylYeCujNKjgzwFxov+vXGAhpAgc0m6NrysdK5mnXc6eixTzJMZNBtqomTVQOWqB8yVQQvSoW4WVhSyxeM03Ob6d8YpWl2hwaO5RZO2Is3tY7alUK0tF2U/Wg71bpPEPtXm/LG7qqmN594v0VNawMuGsclPkKxME2sWAmVCCx85JuOrwbauw3tK0Q/On4rGj7m9p3Bovh7HGxJQ7DHyfiT7+x5a+VTeS1BMNSM+PnlItgfl8jZpgivStYdqIXskRQ3tip1T+Z7GPvN6nyU5LBVCgfuOOVQznchhYX6qRZAD3Y6136T8fUpbqj8De5wmcSc/+PHws1mePWL4KBoH+CVV0pYLiLUbq5urasIrOa+n3OpCIW3gMnvSS4biGwlNcq0r7GgSxESL8phbpYem+nsQq//rIZH59Azvm3VRSNNSgdt+3cTaiC+u8A1NjkOkb9f36byeBu1AUKOjVpJ/schkDEPOC7pKmnzxHy/EbWv/03RFQ762k
 6yXJqj/H
 Y/tg+qGr6VJ+zL0I6OH3lxhogOBxFUrNoMxpa+pueZiYsp2KUQXbijHHTX+Kc29TW/8kBf7BzUwKOxWm3TaQ7JSfUbJAVjS8KVG1NEdzHqXVGqmTUmZM37GR3cDaC2OO6aJFf8EPjdlfP42BHbsDX5rM0qeRzvK80Khmr/z6zq7kVNOqaj8l4qd9zz72fnqqnJz3QT1YP6WxfosqrHSDADucnEZXH3htdHClQpCYvQJMEjXICgrMi0KoJZCq/BdU/r2UQsuKAQ4P/N8XrNEJIkObsZWJH9GwXL7jjM/fpe3f1uM3OUkj/OTpRRT+/t2SVwRX+zlGSVtQuclMV9f80Co1NmOmE3HXPijv8BrxRQNyJSJK49M0gWMLRvIuAdIDx1Ss7G6o0+yaDO7lmjuWH9QmzcUvpHJZqRxoXVDeQ+8SkDQooT63xmKxrzuGvzGy3El7VbFPkO+SDb/XudRHNT0WZfypJ6gQx4vWpMh0dnxNTwbJHzyrFZY3Rl9R3bQrpPY/eiwuHXiNQTcIT+6xH9T0h81YcHQsvZ/ybnnufz0mhJeSHyqWEwe0GM1K4jgw2qO+ZNKgCsuF8r+MmSag2wVNIVEhPmF2eZqDq7pazgbdeXyt4Z+n9gKnfdj6Q4KwzUVNYWpRUxuuKolwowlscVgXG8vHmrbSNlCdWuQ2jZeMkUkkD+01L73GXZKxH+VHWkoG3TH2i3VfhdNUJ089USd5JWgfBmjECSVofEpBXgftauAMI5AhV+reTlxdR+Z6B525cb6Y0RO8HND+eLkt6DV7kv2RlFvkGX9wopnHlWSb6O8CyDtzxV61CbtJTiJkj0pbOCTid4NWCdI28ZW1YN3BqgYxFigQqkYKXGPgYwzm+L0FdCvZoW3W4DlU7/w4RvaakkbG/mwnzINt0vfvsWNbv5yYJEsIdMDnfs3495BbprPQhGFGKFTEsJrKI3DYk86232FH+6JW83sCEsEj3FUsj3X3x
 payxbhJ3
 3c+TjyH2pgXHwzhVwwAAIzgkfxR1kuV+3gCYooTPWjDpc8vWN3lQUT/9AjBem9jNYU47+BQpEegXdiFKw/SRKKTaAx/kkUUk9J+McvE9y5eXPIdXAbGpeDGNZbJryaU+nbltpuailffUIqi34ECyDAqGFqSMSaD5O7AMSzh8CDkYyrKUDqGRMig2hoQ4/Vn3FNhVz5btfESfq/NOa7/Kkzb0GHRkCH8hF+mZDsC0PqFWEJ9OgpcLUVc5K2/f5fkdYjgZzg43uNv9D2UukkOWGWM024VcXUmbl6qS971X+j+3MpYBlHMP0WURDSi25dF6N/QagTYWOBfCQLpxqN2mLXwmNJEM7Ng1m3BJNpdtE+7RjJt5HYauwuhMMrm3A3z1TjfyheD7Jx99Lz5qCyPJ3ftKWJuOnliRK3prj+T4qw1JmH6D7dMPx/MUEmuiyccQIReIcvoeMBSHiogYE6G+NOwfgnMwcuIAVhbcqm8ZBU+abmUQ1aKxugliSOLgp9pssC45FGJdPHclOv8o7kEgXMCjvbltVxPlItR9SLaQgHeMUNcL9xPUDDhFL5XPbTjx5qkQGx4mZJX0mlvCTZpPewHiNJknF6nuKY4PxS+P0iVfASpdNo7R7GhlgbafjL3Dfd0efiX74lW+Xngl4TbG0I4icRxqTic/TF8nMF/+hcb+8xOipaWs4RoV9I5TDEYBL1PLT64nGl7NlNg3jmdgrNdkbTj0eCW54FWgEp7Pi86PoaYI5jKlRdUFPcfifsogLA7b/uZWNK4m8JJjh/lz3BDXyR96lt8KiFk0RHQkYeatfKniKZrF/x4wFMeILtXydVo9AVvVYJQbHUFj5bRddR3121Mf+Li6XG498TNi0vT9CRou6HaZtZ62cI3ojg9zGM88T7UomolulZgLBNroema2BjRxAJARN2hvmFfcxrNKeDGyfb30pQK2tm2yYRtTS3GkGktf9Bv0EaR5WIt4YWEiXourg
 IagCrilo
 XkWrzpz8C/PHFGI9xjTfJawBTi3j/Lkv9qeejoDVraro93AGHmnX19AgW/r1DVTPxvBqG9A3Jt0ejVw8tCglVv1ZIjPTVFw9cUUCv06cbARtk/wYp8CoDtZn8tgRFth6f78gYJSBi5ozTsgif6RKmZ1dcHchqhAMyTy+3Pdg4hAF9WRate+/KgR3yaEw1xqFBuruLZmRuT7D0qaqgURZki2v+XnMMQODntb7eFNGTfT3WDdQHSgXZCoioyIDrhEHThLHjQ4E3n+uUHYXDYSuz0z150VmwYPyt1zFsVP+B9K4K5tY2y4gutVve3nyn1bzUpXR4ubZP2TpKpyF/hi4otndNjBSWVw/rqOY73bjBiOCQ4vxFZybbvzPiHjMkDoRHBK0l6++h5BdJTaNpyFtgAkBN0wXG6W9SOg/bAdKW2wy9NCzb1DOUlGV3hK4q8lS+GjdpeHhT+7mVRxTWJfFaHMD/p/ejWQYkrMKceFPTCYS2t627GGcCrlPIiTkNhbkFkGOlfNpXj0q3HItI4QSjvfZ9OZuidxLG34cWBQTLqfGef1/QcCplYzWpOolCWqLpVptNKCr1vniqz36zzsjNQZMRP5ATdFcpceBgeHvy/kTsdawA8LWuohzJT5H9bJSgw67igWHh3PRS6XrtgbqBF7XIlzEUxneD0+PJaRX+ZT+dH43nubEf1iaGbNkegMt4DHti4P04lw9GadFdASNSK9bapX0ddk4eOd+kQFdL2Bk9UHniTG3cPSX2I0gjETNEfyof01HB6hvrImPZQwkTSNINFo8EPZ+I2YnAyThXurMmkulL+KOpcRUoNPfXqQgYt24C4DJYdndjnfPC0cuCjQB1KPP6xAhiZJJHDJQ28e96ESgEZyj2wt5Atw71B6uoxllY4tlEsWGH+qFbmOjm4RFIBgVmc2B7TKVcYfoCYOJ08U4XgHyvLhFc4tRcbuIMH4HVs2T2KAWe6T/0Y7V62UmQLZdo
 zB50c1Rj
 2NH+8KcSQq5KV0M1VqFseC2z8QSELDup6P85zVNQoeSLkw51s3cnG1E3Y2ePk4slH2i2GtdFF2cZQLwSiyDKJ6T0WHAXxsF0QbXrfMtjPLvuWrYwqHcvUl5rpjcGqWbvuhZ2xTk/LWInOo2qhQPEmrIr0oreiHTdi4slKEeFyZJFyuRVXhauPAXU+ggd1KQZW+0IobYazhZOluwJ9++KiXZh1GeSh3c9+GeZ8hzwDfTcaLsHWpJnAOlza9drlZatPBFRHuLD1ZQm/aXIZFadn/zqf0+/2sCh0qYQgKAyWAFKszzD+PlLbvLIijXvvVw0T8y/MOQubinRFs5GSXHdhMaHAYjjMou8t1aQBSEiYUDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 02:20:34PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Fri, Sep 18, 2026 at 05:57:51AM -0700, Breno Leitao wrote:
> > On Thu, Sep 17, 2026 at 12:33:41PM +0300, Mike Rapoport wrote:
> > > On Mon, Sep 14, 2026 at 03:57:21PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > The map->file_doesnt_need_get flag is confusing and the existing
> > > > implementation has holes.
> > > >
> > > > Drivers are permitted to change the owning file of a mapping. If they do
> > > > so, they are required to take a reference on that file.
> > > >
> > > > The mmap() operation which ultimately invokes __mmap_region() is guaranteed
> > > > to drop the refcount for the original file the mapping was made under, but
> > > > this is not true for the replaced file.
> > > >
> > > > This has been addressed so far by tracking map->file_doesnt_need_get, which
> > > > is rather poorly named and unfortunately fails to correctly track whether
> > > > or not an additional put were needed in a number of cases.
> > > >
> > > > Make life easier by removing this flag, and instead drop the reference for
> > > > both mmap_prepare and the deprecated mmap callback in a new function
> > > > put_map().
> > > >
> > > > Track whether this needs to be done by aligning mmap_state with
> > > > vm_area_desc and store the original file in the map->file field, keeping
> > > > the updated file in map->vm_file.
> > > >
> > > > In order to have the same behaviour for both types of hooks, only drop the
> > > > reference __mmap_new_file_vma() itself took in its error path, deferring
> > > > the replaced file's reference to put_map().
> > > >
> > > > To make this work correctly, map->vm_file has to be updated before any
> > > > error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
> > > > set this field first.
> > > >
> > > > Also when mmap_prepare() changes the file and is then merged, the reference
> > > > count also must be decremented, so update the logic to call put_map() in
> > > > this case too.
> > > >
> > > > Also update __compat_vma_mmap() to manually perform this step for stacked
> > > > file systems using the compatibility layer, and update
> > > > compat_set_vma_from_desc() to replace vma_set_file() with a correct
> > > > refcount/file update.
> > > >
> > > > No in-tree driver is impacted by the incorrect implementation of this
> > > > currently (no driver that does this is mergeable for one), so this does not
> > > > need to be a fix.
> > >
> > > But the patch iteslf needs to be fixed :)
> > >
> > > It seems to be the change that broke the CI.
> > >
> > > The rest is from LLM, take it with a grain of salt :)
> > >
> > > mm-ci mm-unstable red build - bisect analysis
> > > ==============================================
> > >
> > > Bad commit: 2a937a04babf1 "mm/vma: fix mmap_prepare file handling, remove
> > > file_doesnt_need_get" - first patch of Lorenzo Stoakes' 40-patch series
> > > "mm: make VMA flag semantics explicit, eliminate VM_SPECIAL" (v2).
> > > https://lore.kernel.org/all/20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org
> > >
> > > Symptom: tools/testing/selftests/mm/pfnmap.c triggers
> > > "BUG: Bad page map in process pfnmap" during __zap_vma_range()/vm_normal_page(),
> > > seen on process exit/munmap. CI's run-mm-selftests.sh greps guest dmesg for
> > > BUG|WARNING and fails the job regardless of the test's own exit code.
> >
> > I am seeing something similar here and stress-ng can reproduce it:
> >
> >       WARNING: mm/memory.c:3225 at do_remap_pfn_range+0x9b4/0x9f0, CPU#25: stress-ng-dev/354858
> >       Call trace:
> >        do_remap_pfn_range+0x9b4/0x9f0 (P)
> >        remap_pfn_range_complete+0xac/0xd0
> >        mmap_action_complete+0xcc/0x3d8
> >        mmap_region+0xb54/0x1978
> >        do_mmap+0x588/0xb18
> >        vm_mmap_pgoff+0x1e4/0x320
> >        ksys_mmap_pgoff+0x2d8/0x510
> >        __arm64_sys_mmap+0x100/0x128
> >
> >       BUG: Bad page map in process stress-ng-dev  pte:0160000000000fcf
> >       addr:0000ffe8d9080000 vm_flags:00000071 anon_vma:0000000000000000 mapping:ffff0000a0c4ea98 index:0 (file) ffe8d9080 (anon)
> >       file:mem fault:0x0 mmap:0x0 mmap_prepare: mmap_mem_prepare read_folio:0x0
> >       Call trace:
> >        print_bad_page_map+0x63c/0x740
> >        vm_normal_page+0x228/0x240
> >        __zap_vma_range+0xbe0/0x34a0
> >        unmap_vmas+0x240/0x318
> >        unmap_region+0x12c/0x238
> >        vms_complete_munmap_vmas+0x318/0x958
> >        do_vmi_align_munmap+0x254/0x2f8
> >        do_vmi_munmap+0xc4/0xf8
> >        __vm_munmap+0x174/0x288
> >        __arm64_sys_munmap+0x70/0x90
> 
> Yup I already fixed it and respun the series :)
> 
> https://lore.kernel.org/all/20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org/

Very nice, thanks. I will give it a try!

