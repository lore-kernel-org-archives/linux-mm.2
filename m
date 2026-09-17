Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBE2AC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFABC6B009E; Thu, 17 Sep 2026 12:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAC466B009F; Thu, 17 Sep 2026 12:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974E76B00A0; Thu, 17 Sep 2026 12:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 677B46B009E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:23:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 913511603E7
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:23:03 +0000 (UTC)
X-FDA: 85223773446.12.E39A7AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B1A6AA000B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:23:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QG6IR++p;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662181;
	b=LWcoRRBRk9aZpaxQOglGvLvr5VHKgMaNQPKqyg5nriEEA2EIfuHFdctMfcS1/NCUSkZ5yA
	ApT0SJB/CC8ucmU/TvVwlIEqKj8HvIX1Pb1+yoYdeX9gq+SrF49vh86kUqBGZ1xZegTxAi
	plC/FqVnJnTJa998GO1gbt1Qsimubqc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QG6IR++p;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=F4kEMmAg44kGI5Z/hj5D62xPoebkB5YfSHvmHRVRhVw=;
	b=UrUDgLudUxD1FYimYW6UisjKjKT8MYQoB6IZI1o4x8B4yUVWVW4Fg6d779uRYH8Dj4sA2M
	9ViVYEitLsafXa3hn6RHohhAnujBv09l/orC4AejjCB5W9DUcD49prD0i4/dWeVXZ+kkP3
	rEWWXBrvJUwGX2bZLosgkBg6uIYmIq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62FFA40943;
	Thu, 17 Sep 2026 16:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EEA1F00893;
	Thu, 17 Sep 2026 16:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662180;
	bh=F4kEMmAg44kGI5Z/hj5D62xPoebkB5YfSHvmHRVRhVw=;
	h=From:Subject:Date:To:Cc;
	b=QG6IR++pHUedJ4hUhehmQ9Bd4OPmk0i80X2hhTOHD0yM4lq8ID96oSl6v1+zVT4zt
	 08eTS4DYkoXao6VlCfVF54bnwA1qZoUY2AwpBVxsHNvUrPY8nZ1/twR7SCoIySEC5+
	 VE6iZpCT8zpF++4vmMZJhAzx19Lrx2EvTn8lmxt7WYCmZfgEpQhjz5O9pN9wES62lD
	 3U1pUwOJltggJ1jgZ37NwNXsBLgVO6pq6vhb/7JrI6laXqiqFTF6UaarlHD7x2K2kA
	 A37PrYVnMLkOJ+9KvlkxAJXvhz0Tjw+WXd1UZVAD3Q7+8nMujPCTWbFhGBB0W5EwY5
	 bWM8HgeunGWBw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Date: Thu, 17 Sep 2026 17:22:09 +0100
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WOOw7CMBAFr4Jcs8heEkKouAei2NjrYCAf2WARR
 bk7TmigohzpaeaNIrB3HMRhNQrP0QXXtQm265XQF2prBmcSC5S4kwUqqDJoGuqh99yTZ4gNgb1
 TDYFaZwdAJWWGubE5kUiWtLPutRRO5w+HZ3Vl/Zi18+LiwqPzw3Ihqnn3qZVy/7cWFUgwpK0qt
 WbE6nhj3/J90/lazLmIX0KV/RdiEhamLPaKTb7dqR/hNE1vCaV4STIBAAA=
X-Change-ID: 20260721-b4-mmap-prepare-vma-flag-sanify-2100425df5aa
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Takashi Iwai <tiwai@suse.de>, Emil Tsalapatis <emil@etsalapatis.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=11656; i=ljs@kernel.org;
 h=from:subject:message-id; bh=YNjr0dSPuiW39zPd8bCRpyQ2Yk06eE4geGojrPPpuO4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCO+euVXoocmrxU83681y3RLp+yupiPdLvWLn/29La
 uNY/G+rdJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiLSYM/5QSpH07fzvOcpB+
 carukvfxuRs/Ldz++bqlY1HPj+w/JqsY/sfaHHGYKfd4Y9F2+eu3vQ8/3sHl3HBoRsyzDy86i3X
 e+LIDAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B1A6AA000B
X-Stat-Signature: zn1cc7aekuya8xgrigq3u7n99upgdfgr
X-Rspam-User: 
X-HE-Tag: 1789662181-712893
X-HE-Meta: U2FsdGVkX1/apNwaBXMryDdOC3K+LCfMahOCKWrWxZxkz5y5xVfOJD4OkwEOQeW2p3cmPHf0A83LrORjw337Q6Grhfb174Mt/P7MOgPbl91qZtG9E3MjtZtKinDP7sjJ6goPvPdpr8fifwyLG2K2tU+P2QzvOySkohdlBkj6HFnRFShOWWbztb8tvRIT19tQcf8NsGolEcPaCz8/3DXF90zwZWHAvoSQ5olS8UP7xmz0cJ//7O0FkN9c8Rde964XmxM/6W28/SCy53TF2JaZFFy3QcWpfw6Fyh5Yvnnx1fGJBbrYRTHhSiDyegzVgkWHRsFZJCWQzwkco4XHLvehNEO0Mnh5tDjZrl36cjAIXm+bePu9PtD3lGy0vx1sd4FfQxZ1/agTLgaf7b6rtVv5RWcFMEzvheQYwCjULHBlRQZpTVk9woUChVVkJBmq+piIOblIs0MIbP0jfjwR0ZJ0odd/6ZH7OAFwIqkC5KNVNCa0PUH7JwOsDKUuhY0BjS5ct8xp9P6Xq853bvxjYP3T+5vcdxs3FB3FZ2EvF6avV4afgS+CbdOLvud54/9zFzz30Mb0nuSCSmjyP5tXcugMcKYau1yppp9V7Kfd0iY/Xl6wY3TeQb7VabUtw6NJX0TU8bNLiKeNW0U1RL2eAUU3PyO8X5nybBK7gfKiGUaCb44vAn5KBv2kSLXuEOjDWb9FM971Xq50AOQegMdbcZl41LsrabdkjYdQP9uMaiNuYJyTGx+AMEHxBBH02HYExN8vfFX0EncRj9HDWGORJTZ4eHM9gTX63dtZ5iRA7QEhWr/RsRUUTjdfmwTG+fLkyUgoXMIRa8EFq9KDW41yATxkquhXSynKiTiijpLK/4r70w1KgTl6nJFGcDUIrgIZt3+zahxE1e8R6F1dpyAbGms7bXOGd3TBPnqOxl1w0EwAaeKtAxaZLh5o/PluH396z3Zsvg05LIDPob4WhisKZh9
 VLRso0a2
 od52/ZrUWrK1ppFiEUVp5wtO4Z2YDtxfzd7kG0KULb5Dw49WIY/vVCL/0E+MRmSRNi1+FLeUn+k4VmsiB0AsAky6AD/avPtdPuWC8Qt2GAflyrpHlvzUveoXYDPwUHhIDMR7SBbMZsa1sBDemcRvol+mKJwU+2JB3C98oyk154/06LRgykZ+5aRrOVJa+p/jNRWzaPAve/XR3q60DRUGadtmHr9a4PezJSSvRcWgzz9dKxWOSYlS9QbFv/7wBugWp+jzWW7aYBOXSQVHqtzEIkaWhmWZStwQRjiW+O2H2k8kcW9e69+aQXI6SLVlbaDP2XENJmzpJIkbCPLbu3dHbwQoMRFS+KL+N/TN5yEVV03MCbq9S0cVlbF9/U0sfkr6wJggig75JIRYoZqMjqJxnOQdk+3tKHTTatVm8u3kDMdw9yz9x9GYo7TD6DPuSZXhpxdwQEbwH1Am2VYULN/lkYoz9tVt08gFsc309LRGXPNfoDvoCDktp5YDsCEFMANGoCmTTj04irJOZG5X+jUfVl7ejQjQ4voqA2vKb8iMJmXXfTlbnWR4XRatEElJv0B56k3m1QYtV+4OhKDi3R9iJu9XU+Z1pY5E4VN0Ql6QnhEtrnus3jKBRRnY+xUuMsnMZ8RUx3ONHNCwc6Gd1tr1ECfaXvh6IB6PmHeRzhNlfQDmtyubQrVQRBkE1wSdiqKM6odI9bk8WRLES2yXUTtSCZbRk/8EHk9jI24bvswR6rhwhAhQFIBeolXjtXL9SaU4U5M1UYXVOtjrAiJ7LO8nNQ0p6h8RnJ4ycjBGu8PdCFexFFF2j8F/ozv1E6xhU1vYQhSWGOhOtMRCIvdweTKlDiIDcoCl7ifkgVpm5tU9Eswfjtyy6H/SW8lhh/ebUkOx++poBFkrN3XtC5DJAXCt0C4BH0Vblpv2J9rVBVgPGA5/KvbwBRUaEtADheLZ8u8mbkZMMhXb65dZz6Hhb1ZBbpc3UZulB
 FW6Fdie8
 JKDe0GtoysMVolzVzZwPuZ2S1q2mwtpR/DRlxuyMGXa+2kVdt00PWpSRNhEpxEq23Ihf5+ku+JLUqX3sBv0KbeAozxAy1hTew7fnpvhUJq+rmlfIcpzf5DxiXL5IlqiqBwjbLax+082e9eQFAP2ZanQvNEG0db2ky0Iq59wUZ3Pf30vTpT3Oj5RJLNTuHESoXY77/Cw9rJCO4WJqqbCMQcnGwVVrSoDj72aUxgBEFSLcJ49FjmdOdJTyoPElnNKBWNmttUkVE+a2Eh2n9k3PB6op5plXxYnChvcCXhXTyhvsiWRR78SH33wI/AxHv20rRmOK9Bkr+k1XB/QZDVQvdWD9HUTVQveA3h5j2sZ8JML+APEUJ5I/pAbUcTMA27i+f5TN0j+U8n5MFuKAgsZ9vyrJbA7tOZ2Vo4bC5u1Ob4AfJ13KXy9lIZEDmrs68bJZDYaYb7jWBvOUZ1TUNDx8YW4ahwp4dneeL6FRZvb+H0ExQBLUr+gnJFK9LTKu6/0Yujvk/lHC3BcYt9mERjrXajzrxIbFmCmB0Al0+z6DZtENgiTH9KyLgFwKMn7eQH2CTiDGpMvYXqyTQie1hHwnBskQZEWLROdAivfLlk5x+mKCE0/rUseyEkIRe+m52WgOcHatRjAX+aFTjQZexbTbhI1nBuBpGGV1jXMXGY3iUEGdTlV2R4ifZZqsNIsK7I3r/nQzCSYFF+9OEyayBXhMlB2kqM6vMSSkvOWF4n/n5ZKX1+7q+SGoO+LblEcxnXee7qN8OnWeMjqF9t66g2D9qpQBWoybHJwXtm6a0mBpNyvvqxwldQSpYJWN8oPkk32Fl0MU12zTIs5mWWv3DI170fM+d99ZS18NOhmzzIWDSF60vP9/A6+oa3SubGU2+SJbIWzkkMJkkksBjZwPvmtYrfzuulNLKK5yDATI/8etW0cJNl8qz3Fvir9HxubEytx/qosVf/SXHl2X1vRFG1GzwBGgZ6nEM
 JxvF/hyt
 MdfAOux14kh4j8PsYcz29gvsRhHrlWiEXF/2UjWJWJNIwwLLTQ1rVpX4YmsEFd1dIc8drUiKoUrAlldsrMbWXLxplI8Gx2df1SYeoOsorFgzz4KxP0okfPL6c8WkJnKH1Hj9Nl73NPgY8XEb0bq8lyOvarpJfByAyi5YJjNes+YBYcHMq92+LPVpTlrSOQO+OA/CEt7v62oygZA7hgL0dxArFGwkuQTThapilOK4wYaSoUqZKmnQ6HBzZeCMzxBpWraH+aq1AoJ1jWB86YBjl8cvBGyXCxHOYDm/AutKuStFcjZM20UVr9XzW3yj3lhmuQOvcZHEsRdi9yNtTYhbF2XThEsycWYa8enE6SoWoWZ20XXlEFsA9QoSoz3tYq/FxP3FKQOmireCD7h3Zh2srjvXjtmXJHbHiWudZtJLaAUJVqz0EpaC6nc1S1CqNi+YJplbx065RikvOp/qZi8yrJTDwlGFnkQcM0OkUfkArQKXQ/fZCcFQQa5hjlDakRt7a1QBn+MzWUyPQ6hgLUD+qks6BzNkVPKxEUvf41grt8AD7AQj+0lKYKHWB9/nUaWHtFElw4QydIGSUrnS0H6MrwO8CSHlyL9sSApZ73De8g8aOCo04NdTGy4ltA/u8gh5aIqMEIzw+d3e6ysMXiG492W5BbSV13Hb+HeisFtA0PKhOaRdmrgjVtbUh6sZZ8Sk33pYQ14wzy5br1PeNWTaZjPgkd519x6QObRsAkcR6hcxOfS66hFZSy6AEQpseejWHjKDITyzOf3CoY2cQQTD5ny5XdnnjzPFmY9oFw+qxZ6ys5XZvlvJadA3WkUZ1iWbvAAaN+qdJBg7+ftTjMcDBuAtzqDxf68x9PaAt9L0QnP/7EX/04IrY/maW+9s692SjDgxsfluKjNLVqCyD1e5ZLa3RkK6EaE/581MRITyEyCq/LkmbebCT4kA7U5v/76QE/cJPhiouKP1KBO1/lpRE1ZOLCEro
 Ep1nfLex
 ZR8C2fm67sEBxs8D1+fM5Um7o1ePyQdkZxpmX3mKs8q6RjMih9sgdbvwXN/E29aM5nxUVQf5x5sdym8GhxhOc/Nn6az5GRv7aGB33H1lek3f8zWE73JEfO47TTQf5g7/Ag6hpDlPvBTDTM3MAAVgy0s9Sal7p6SImnkAhxgv+zC8A7G4R3IlX9NLcTxAGISHEe70S9CXtciIQCsByi1wuAIh9hl/57Yalce8u48f61GVHdZfro3x2ExtyaJRxv41FXyIfvrYrz7tn7zPTrSPeiOBUiiLBJl6V0w741N4Q30f02QzqxIW/k+hMYVjcVdGIbKk7/KVNKhMeuc8ZwHgc4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
properties:

* Is this kernel-owned, whether MMIO, kernel-allocated pages, or ordinary
  pages a driver maps itself?
* Can it be expanded or merged?
* Is this a 'weird' case like mlock where migration might race and we
  'have' to set invalid flags to notify?
* Is it another 'weird' case where we just want to stop GUP from touching
  it?

Driver writers have often been confused about this, and who can blame them?

It also interacts badly with the eternal edgecase known as hugetlb - which
sets VMA_DONTEXPAND_BIT but doesn't also want to be treated like a
'special' flag.

Another issue is that we cannot make sensible assumptions about flag
use. It's not possible to assume VMA_IO_BIT means iommu because drivers
abuse it and mlock abuses it.

Special is also an overloaded term in mm. VDSO and VVAR mappings are also
called 'special' but they're special in a... special way.

Sometimes things are called special that are a subset of
VMA_SPECIAL_FLAGS (VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT for instance when it
comes to zapping or vm_normal_folio()).

There's a specific kind of special for THP too, which considers
PFN map, mixed map 'special' but DAX not.

It's all rather a mess.

This series brings some order to things by both limiting what drivers can
do with VMA flags and switching to using predicates that describe
behaviour, not arbitrary flags.

It establishes the invariant that only kernel-owned mappings may set
VMA_IO_BIT or clear VMA_MAYWRITE_BIT in an mmap hook, enforcing this by
validating VMA state after every mmap and mmap_prepare hook.

It updates usbmon and sg to mmap_prepare in order to do so, adding a new
mmap action for mapping discontiguous kernel pages, and has hfi1 and the
ALSA PCM status page map their pages eagerly instead.

It also establishes the invariant that VMA_MIXEDMAP_BIT be set when mapping
kernel memory, something that is usually the case but happens not to be for
some users - specifically defio, cmt_speech, uprobes and the bpf arena, all
of which are updated to do the right thing.

It replaces VM_SPECIAL and arbitrary flag tests with predicates that say
what is actually being tested:

   vma_is_kernel_owned()   Does a driver or kernel code manage a VMA's
                           life cycle?

  vma_is_fixed_mapping()   Is the VMA not permitted to be expanded or
                           merged?

     vma_is_persistent()   Do bytes written to the VMA stay written, and
                           bytes read stay the same unless userland changes
                           them?

         vma_can_merge()   Can the VMA be merged with a compatible
                           neighbour?

           vma_can_gup()   Can GUP obtain pages from the VMA, i.e. is it
                           neither a PFN map nor memory-mapped I/O?

Remaining raw VMA_IO_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT tests
scattered across mm are also converted to predicates where it makes sense
to do so.

And also the opportunity is taken to eliminate THP's vma_is_special_huge()
which was an existing source of confusion.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v3:
* Fixed up bug in patch 1 as reported by Mike - have to delay setting
  map->vma_flags until after action prepare, though map->vm_file needs to
  be set before for correct reference count management.
* Updated 4/40 to add a symmetric vm_end check as well as vm_start in case
  of a dangerously insane driver, as per Sashiko.
* Updated 8/40 to check if a driver did something REALLY stupid like having
  a NULL discontig_kernel_page_ops ptr, as per Sashiko.
* Updated 15/40 to trivially synchronise userland test comments.
* Updated 17/40 to correctly duplicate code to the userland VMA tests as
  per Sashiko.

v2:
* Rebased on mm-unstable.
* Introduced new patch to fix various mmap_prepare and file interactions
  that weren't quite right as per Sashiko. None impact anything upstream
  yet so it doesn't need to be a fix.
* Restore vma->vm_start if an mmap hook has moved it before tearing the
  VMA down, so we unmap the range we established rather than the one the
  hook invented, as per Sashiko.
* Reject a discontiguous kernel page batch of zero pages rather than
  looping forever, and bound batches by the pages remaining in the VMA,
  as per Sashiko.
* Add the missing map_kernel_discontig member to the userland VMA tests'
  copy of struct mmap_action as per Sashiko.
* Set VM_DONTEXPAND on hfi1's RCV_HDRQ, RCV_EGRBUF and RTAIL mappings, as
  dma_mmap_coherent() doesn't on the IOMMU-DMA path, as per Sashiko.
* Recompute vma->vm_page_prot in snd_pcm_mmap_status() after clearing
  VM_WRITE, as vm_insert_page() uses it immediately rather than at fault
  time, as per Sashiko.
* munlock_vma_folio() now tests VMA_LOCKED_MASK so an unmap racing the
  mlock walk still munlocks folios the walk has already counted, as per
  Sashiko.
https://lore.kernel.org/r/20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org

v1:
https://lore.kernel.org/r/20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org

---
Lorenzo Stoakes (ARM) (40):
      mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
      mm/vma: predicate setting mmap_prepare VMA fields on new vma alloc
      mm/vma: introduce and use vma_[flags_]can_merge()
      mm: consistently validate VMA state after mmap[_prepare] hooks
      mm/vma: ensure mmap_prepare doesn't set actions on a mergeable vma
      mm: make map_kernel_pages_[prepare,complete] internal and unexported
      mm/vma: tidy up map kernel pages enum values
      mm: add mmap action for discontiguous kernel page mapping
      docs: filesystems: update mmap_prepare docs for discontig kernel pgs
      drivers/usb/mon: update to use mmap_prepare + map kernel pages
      infiniband: update hfi1 to use remap_vmalloc_range()
      selinux: reject writable opens of policy file, drop mmap shared/write check
      ALSA: pcm: use vm_insert_page() to map PCM status page
      bpf: arena: mark arena_map_mmap() mappings VM_MIXEDMAP
      mm/vma: add vma[_flags]_is_kernel_owned() predicates
      mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT if kernel-owned
      mm/vma: add and use vma_[flags]_is_fixed_mapping
      scsi: sg: convert mmap hook to mmap_prepare and rework
      fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO, add VM_MIXEDMAP
      HSI: cmt_speech: convert mmap hook to mmap_prepare, refactor
      mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
      uprobes: remove VM_IO, set VM_MIXEDMAP for mapped kernel pages
      mm/mlock: clear VMA_LOCKED_MASK over mmap callback
      mm/mlock: eliminate weird VMA_IO_BIT abuse and simplify
      mm/vma: enforce that only kernel-owned mappings may set VMA_IO_BIT
      mm: remove VMA_IO_BIT check in vma[_flags]_is_kernel_owned()
      mm: remove hugetlb_inline.h
      mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
      mm: drop some redundant checks around hugetlb VMAs
      mm/madvise: update is_valid_guard_vma() to use vma_can_merge()
      mm/vma: introduce vma[_flags]_is_persistent()
      mm/uffd: use predicates for userfaultfd checks
      mm/madvise: use predicates for madvise(..., MADV_DOFORK)
      mm: eliminate VMA_SPECIAL_FLAGS usage when hugetlb explicitly tested
      mm: eliminate VMA_SPECIAL_FLAGS check in lru_gen_look_around()
      mm: avoid use of VMA_SPECIAL_FLAGS in migrate_vma_setup()
      mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
      fuse: dax: do not set VM_MIXEDMAP
      mm/huge_memory: remove vma_is_special_huge()
      mm/vma: introduce and use vma[_flags]_can_gup()

 Documentation/filesystems/mmap_prepare.rst |  81 +++++++++
 arch/arm64/kvm/mmu.c                       |   4 +-
 arch/powerpc/mm/book3s64/radix_tlb.c       |   6 +-
 arch/powerpc/mm/nohash/e500_hugetlbpage.c  |   2 +-
 arch/powerpc/mm/nohash/tlb.c               |   2 +-
 arch/riscv/kvm/mmu.c                       |   2 +-
 arch/riscv/mm/tlbflush.c                   |   2 +-
 arch/s390/mm/gmap_helpers.c                |   6 +-
 arch/sparc/mm/init_64.c                    |   2 +-
 arch/x86/kernel/uprobes.c                  |   2 +-
 drivers/gpu/drm/drm_gpusvm.c               |   5 +-
 drivers/hsi/clients/cmt_speech.c           |  33 +---
 drivers/infiniband/hw/hfi1/file_ops.c      |  83 +++------
 drivers/scsi/sg.c                          | 115 ++++++-------
 drivers/usb/mon/mon_bin.c                  |  82 +++++----
 drivers/video/fbdev/core/fb_defio.c        |   6 +-
 drivers/video/fbdev/ssd1307fb.c            |   2 +
 fs/coredump.c                              |   6 +-
 fs/fuse/dax.c                              |   2 +-
 fs/hugetlbfs/inode.c                       |   2 +-
 fs/proc/task_mmu.c                         |   8 +-
 include/asm-generic/tlb.h                  |   4 +-
 include/linux/hugetlb.h                    |   5 +-
 include/linux/hugetlb_inline.h             |  28 ---
 include/linux/mm.h                         | 266 +++++++++++++++++++++++++++--
 include/linux/mm_types.h                   |  50 +++++-
 include/linux/pagemap.h                    |   1 -
 include/linux/rmap.h                       |   2 +-
 include/linux/userfaultfd_k.h              |   1 -
 kernel/bpf/arena.c                         |   3 +-
 kernel/events/core.c                       |   2 +-
 kernel/events/uprobes.c                    |   4 +-
 kernel/sched/fair.c                        |   3 +-
 mm/folio.c                                 |   2 +-
 mm/gup.c                                   |  15 +-
 mm/hmm.c                                   |   3 +-
 mm/huge_memory.c                           |  31 ++--
 mm/hugetlb.c                               |  14 +-
 mm/internal.h                              |  81 +++++----
 mm/ksm.c                                   |   4 +-
 mm/madvise.c                               |  28 +--
 mm/memory.c                                | 142 ++++++++++++---
 mm/mempolicy.c                             |   5 +-
 mm/migrate_device.c                        |  12 +-
 mm/mlock.c                                 |  51 +++---
 mm/mmap.c                                  |   2 +-
 mm/mmu_gather.c                            |   2 +-
 mm/mprotect.c                              |   5 +-
 mm/mremap.c                                |  11 +-
 mm/page_vma_mapped.c                       |   4 +-
 mm/pagewalk.c                              |   2 +-
 mm/rmap.c                                  |   4 +-
 mm/swapfile.c                              |   2 +-
 mm/userfaultfd.c                           |  45 +++--
 mm/util.c                                  |  29 +++-
 mm/vma.c                                   | 246 +++++++++++++++++++-------
 mm/vma.h                                   |  31 +++-
 mm/vma_internal.h                          |   1 -
 mm/vmscan.c                                |   9 +-
 security/selinux/selinuxfs.c               |  11 +-
 sound/core/pcm_native.c                    |  38 ++---
 tools/testing/vma/include/dup.h            |  80 +++++++--
 tools/testing/vma/include/stubs.h          |   2 +-
 tools/testing/vma/tests/merge.c            |  10 +-
 64 files changed, 1169 insertions(+), 575 deletions(-)
---
base-commit: 6b41451631cabf9ea3b384c2a099088e1598f963
change-id: 20260721-b4-mmap-prepare-vma-flag-sanify-2100425df5aa

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


