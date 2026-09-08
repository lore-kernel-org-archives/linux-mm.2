Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89B72C79FAE
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2A4A6B00AA; Tue,  8 Sep 2026 16:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DB076B00AB; Tue,  8 Sep 2026 16:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A2216B00AC; Tue,  8 Sep 2026 16:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DDE06B00AA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:08:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 028FA140757
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:08:12 +0000 (UTC)
X-FDA: 85191681666.02.FFE2231
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4719240004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:08:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DBQcW9hQ;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PBAMhuMrY9q+D9awvtL2ZG2rfhAnynDm0uBzbV7sqQ=;
	b=AjD6Plc6bZEExacsh55QVYERXGvr4alz6zyIXQOGG6AYVszewUU/ygok66nf9lJyamw7a7
	smBLXA2GnkKeowRWdkR0q45HrEHhseRzKXF//bjNmlWzlRWUQiZK+2j6W3pVgP23WPnkx4
	PaQwehzhbi5LNieqcwAXSZpoENuu6xY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DBQcW9hQ;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898091;
	b=5fl1OHUuRzAvhJUOguhz0WuMG5MQA8g01UdsOusLcKVTVKLeGTh8GSJZdIZHf5L6SXCFEs
	9uuJpZPMlhfb+oDAILrEdumKuluT5xpg3jxBVR/ulDiKw4zeAfbQvROlLqQfT4PM+JcR/K
	6AmEPDVoQwl/SQfWtsofw9QHIC3iRJw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CCF1B601F6;
	Tue,  8 Sep 2026 20:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CB11F00A3D;
	Tue,  8 Sep 2026 20:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898090;
	bh=9PBAMhuMrY9q+D9awvtL2ZG2rfhAnynDm0uBzbV7sqQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DBQcW9hQA9x7ZkeAZxLEHlFL3iEzceyHIYHlVpMh23T35fygIU49/+z8BV3+p6Y+Z
	 v5Rr6aMVJ7G1QVq96afiv2JdSYLA3muUOJzBZtWeipU5Ef4mLgmG2n11Q1Y9AfY4Go
	 ISI1nZIiwI9wYqBbKmD2LOFykbJI7who19EYNV+aQ3fGnvwye+CZsSuAYAdTFwGBBm
	 QvtpORJS2mPgf9HCcF7NthvHF/5eFdcoe6PaCKnMq23L5zDc/2iyMlimY6dFImofbP
	 P+nQecV6wN1HlDptJ38IyGvAp5ftMb/2hdEB1aoowsQoNybmu1BzeoTbSXID0Sib2d
	 yg95nocbTFXSQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:16 +0100
Subject: [PATCH 12/39] ALSA: pcm: use vm_insert_page() to map PCM status
 page
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-12-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
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
 Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2672; i=ljs@kernel.org;
 h=from:subject:message-id; bh=iwagOJRXNrCAbgFyajHTkvwzgAThPYmzc11sUM8hVos=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG7qfnKAQVN5juHkKolWeeXZMy8/T/+73NsqenXjt
 WufAoLfd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAimayMDG/tH0x2/j5pv4n3
 0603/U9sD8tii3u595Iuw4kp/8z1TfoZGR5vLSnhKbxtxrn2clzutFn6ck7ZJ9q7tOxMiqTNv98
 OYgMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4719240004
X-Stat-Signature: i7e8s1eiuqyr7y8mxxstpoos6brsn3cu
X-Rspam-User: 
X-HE-Tag: 1788898091-218356
X-HE-Meta: U2FsdGVkX18zlzWO/oHJ6PSMTyphXHuh3vj62LmHLYjHMK0zJGgJJuGByOnUoZizSaxVTW+eVQyvB3M8I012ruI60VZqUwXeo381CBSt3vuaVP+fp2UD+iU8L66DzEeSsXiRtbTVAf+zYlzAvR/rf4e57ngbpwWEaKDMsuKQEMyTtOeyOAZ9DJCVvM1X9kUclZeVuuB4q3oUyPRrwkssIE+Xbq2jMxxicUkOF6y27LCCeVHAeYntrqGyTRT6puBYXOqAq+J/73PZnPZYYuzCIIyawt7OM8rMIVnZFRLmlRPPVjxT32Fgp1ot3GTt61wPexNXgEVDxri5RRgCyF41FPNABXlh48lzSURNm12910zwdBXiGXOwRw1FogyMhCzPvysn9vBtsrNEqNi/c6Sw+gwuE+tXG3E/jVS8OhrllbuPuB5lNS0h8/3UhvOYH3dG7J02IAKihRCADe17UX6/8+1lsK1eIXVW8NxFPFR2HcYrn9Zve46wXNPmCrCNMWZYT2V734ZX02lQkt/rF9UOfHwE9YSFnc54+9NpUQ8u2/RLJrynm1ocRjlzwrVCnLfCznwdbSbsal1zrGuTMYXu+OGJdhJfPzQnFVu4c0plEWo/l+zYAv30XIofkYl/wXimDOUf1CB+wvEfo96/Jmsyj4Tk/+P1cyjC9OttUJi5MKWMbBQBk2BLtYELUig1deEJLfVeqdm372fjSPPwGq8Ob8iVs9uPcb+g6PyX0aJBgYRi8aHR9GUzIapgb7uOtkpP1s+bmQ7aBr9kioVgalxU/xy+IU3Z8QOvsVuCeW3D1jwHv+iVhDvrWjMuErS4k2k+U8LJizxoZVAb4RB6GfsR5tTW3jJ2X58qLvRhYtgThh2Dn8aI6DHhsgi7jNNAciFjH2LnHisdAbY/6XnRFUZk2ze151uT6hAhHZkWajpzeu94WYK5RHKl1hPwAe+uvuFmnqonJJ7wkHWDzxxJLNm
 kwT8u8tR
 sGsSp9A8aq4D65hdgy7OxiWYeXFc3Rd/2B2Tkso6EpHfGedxbaP2gw2Lurvm6lPl29M6tcf+xz9VQaS8kesDECBf457yvIWx0qaLylPTzvXCPZdeduc6XEBJ9ebJfJcaaIzlMdgg10FkVmcSh5mPTm2xUBXFkZztcuZlDhp1LqYMFdueT4yEO/UU6oyaa0h14ffpwRvXSyqjAb5stILZQ2QdhRqZALU6ULaI59jc8tfBzkuKkk09XoXISc5FISu6lOnKPSyoPMsSFOc5u1Ul7+B/22N1SrEIFAjwUNWvH4mBenpLR9T4NX9gIfU/yKYMS4/uXHPx+cUgF30aNq6BQxO1sahW44d2qk7WCW9/pnl8z0RegvJ+hx5XuUWX9e2wyx/8jkcpAFuPTp/Ea5ya2qrtNkwiVaYbdepG54AAyI57xv5c9J7eA/BeroRmW2snxju/jcEYwI4vTylvD8pHEC+pbDDpPkRa3yUp5gm6G869Z7U9SJPP2x8gYRQkpyARDFaUgc/TI3mfs9Wf1Kgeycc/Wq0fGetC3R4aqOJGcR1UeAK0LbHv9jChk/ibxOPTfx/Ya9IHwi0G5OAFpffHBDS4gO+/0EzO14wlhAB3FCbQYdMp3mUhQadZu7T9BGoRrwmWuwcyPfCoQqtoktJQWo/kLBAzhwySTAQfxNZBMsv+jcgU8uawX/6ed4RwZsT2VUWcZG/AM1+sPPyDYiHoPGtVXYvEVxyCogk5fDxvAA2orcKggpFNJnFSbKBdauiLj/e+5WzGxMdluw0E6Ea/CG6MHwZt+HbffheZIIe5HbKmukcID8hsFIoIqrA3U2RaAsotJCIa6HWVbUdBU+/Zm0c8t+J/iaMg75kQqtDS/aVvRN9ld0eJtM6hqcgF4zX/V2JVx7DAC5h4MNSUnqRjr5+cf+NmstWAXV+qaEvQz4a5oQ33VU7x0vg2m1X7FT8Tm16xtTKmfvWHJOxjw4+Tmxm31WJzM
 1cLywRCM
 SLglyZzWwPzPqhGov8iIp4CU1USlVXtNl27jpgob9H20+2JAmkf6DWP6aMsUJbUOzlahEPxe3wZSDS2Tfzw9cPUTpwXlKcya2rS+NTEcPe9HzFgRwZaelemq4W80w7Xmuw71heiUGIitDcdpNY9hv4XftxqkopovaptDKEob7QX71dyO3tGvUiWA5eD7hlyDFnGM3Fl/wDi3w0gv7YCJ7RtmgN8U4RDAup/uQcYbqFgEpQLrxlf+Im4maUtXNGyH0YDFD5OSCCayAfuVwba4UUqDVCdAwV+YxP8gqTUpl7qgfObLjERm7MgcDKucCPpcVqjzu8qbJ2t8KfeiB7468UpsISKq4SJjsT10xgr6mbRo1kK7kLlwt2UwOedJMzhTYjtlABJ5U1WJ/uimanlqQirF380B5N80iNogrWBqLjcdK/PBxYjNCqdO4PyX/ktT97prju3YFYgxVkIx+/7Vg7XZGgxO2UV1cuS+cHnekDSVdtxgBO8AI2SJ4XGkKSj5hgnPLxsmhD+bh2FDUeldBG3vjh/ImHgoepz2StOAVoBsrFjUWnmOWznSNNTvTn+zv5Eiv8Qh0g8WcCl4/lyliN4m643ED6AdZn4CoT51WZQc6Gj2VOTaXut878E+SZEoq0bQgUg8Eele3DM/cdGKlSpN1l4SmzqPk6K99pYTBFfbhDvaRK7DIx4z+lJu2fJfzmDvne3pONKKJZltTgfppUd+mtGGQa+6FLFAqVfyx6GmU5lLMTIFxHQnayOQC6LYYVAREB/PA9jO3emrTZrx6VUnnul6XRLc5SIXq4tJVcxP1kgR5vBn5F1s7BbI3bwFyp/KvJ/MSrU30MOFPQ5uCRNiqNjDNuhQ44IAxsz+bE47cfXBMRFug/psTVfvgNzTFDnCntMGTpxSDQ4WoV98nRUJ9ObktpawoiZ/HGidk1bUaGhxUFtWvO5/zPT4mgLW7yLsJSUYTO590OvB7zdFpSk5D/W+Z
 9O59BPnN
 tLvPTSbZdxjQ6S2fDNg7jDiUo/eM/TjLsbbCnhzlsMOwTmnr3gczV5WKq+7AIiRQ13/7rF/+PnRg6TiNqjqRtWXbWxa588/XCxr9qoBnadn8z08OTWKwB14hnSKQgdL//rgaC798gkSWCUe1mVSRxxGprsVyib4tPoz7pFm6KqMKYfmI9Nm96N4rK1jEZi32G9cfRsqdS580B/N1dr4T33WOBv1rz9dwIgmBvKlKkTsfYMduMXI+CclwsdUlVR0xC4mCAR+x8Fv7wtGICLNtWYxBgjAaeHi1UKQuPlYJE+FReVtSrHMGoMGWwfhrQEV1RrGl2qH0Dnb9t612yyD/Ji3OOkTqkFypChrPstaYTAoKrPkOX2CSnDY9HWNkYN21hSR5rcwn7n4QkznOyoYPOcFXAr/kS0tuYZ4w1xV5hsJ092CkFYRqf31E2TwpHgk6WoPduzl1N0DfUlROUdS1Qxj9NfXf5wdUc7aiomhTAVTcl0Qz6yBffqnm0VuQKtBJC3woOHWTFGDNhxU8bdesjYXKYAZgSavcoqtJUWsg3qm+gco/c+FvT9A/sKfJQ7K6BK2rLsgnOEYcxIxWRttEgjLdfb/Z8l30AskYdvBtvaMDWMcBp+ctYgUgdD42J+ptxCLuMTFzp5R2nRTqeZwIVmFKk6u4d23josBot4Yquxd3t7y/O88QJ3M5g/3SCVDz0Y8hZo4ntgOocUi6DoOlaTIyfmrD52Sq9Vj627l7bxaxfo8jSuU8cVIPG5RSs9ju1GP7XJPxfTuWsDfwqWI2ffINaFZ4R/fwTGBopWsDcQd3tQH1T34E8rbFBPQbXCJuZJTtE6Cfy+RFkbhLzJSu+std+TX+y9ociKQIcYLIZL+ERzeV/HXQkoAfDgxQf3QTcprxElQiY8NJRugjYIKogZA7HTUggqMpqSEBxzShe2xwHZNv5/WPsbWV+F46m0srIkrVb1PUYCQQmjtmvVF/5JjQp6yn+
 tLtPuUnI
 M2Q3izmNghym+YU0wBxkGYbiXF/1WC0rITgADU24LDDBjdMlEpMURQtShmxqDzUOdki1TV7hHHfiehDFr9xrIbonZL9A1peyQAK4UVwrOd7MG1YCr+sVpi5Y7vh/4smnYdjqDOjslabA8bIxgegG6zugIoqqMSJRvox1XzpbuMt6RGLLQh8s00EksCcoQEWD4bjiOaxdFPmLnERXl2z0pNsD3GoZoBiL43NspBYK3uQovIg+haQB0cy6syFxxDt7t6s96TE0LWvMzYgNNdso2BRH1/F6YdcjveObBZtiSxTvKozDOqnL9ExJwr0uhvQI6wcIrjLGRsjr+XUdlp8t4In5Rv1pFojMYvK9+V1JVHvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to keep a fault handler around for this, instead map on
mmap.

While we're here, rename area to vma to be consistent.

This correctly makes the mapping a mixed map mapping.

This works towards establishing the invariant that only PFN mapped or mixed
map mappings may clear the VM_MAYWRITE flag. The status page mapping clears
VM_MAYWRITE, so it must be kernel-owned; the control page mapping remains
writable and is left fault-based.

The assumption is made that the struct pcm_mmap_status structure is at most
a page in size, which is asserted as a build bug.

This is safe to assume, as the size of the structure is 56 bytes at most.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 sound/core/pcm_native.c | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 62324282fcae..37a157d55832 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3760,39 +3760,26 @@ static __poll_t snd_pcm_poll(struct file *file, poll_table *wait)
 /*
  * mmap status record
  */
-static vm_fault_t snd_pcm_mmap_status_fault(struct vm_fault *vmf)
+static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
+			       struct vm_area_struct *vma)
 {
-	struct snd_pcm_substream *substream = vmf->vma->vm_private_data;
+	const unsigned long size = vma->vm_end - vma->vm_start;
 	struct snd_pcm_runtime *runtime;
-	
-	if (substream == NULL)
-		return VM_FAULT_SIGBUS;
-	runtime = substream->runtime;
-	vmf->page = virt_to_page(runtime->status);
-	get_page(vmf->page);
-	return 0;
-}
+	struct page *page;
 
-static const struct vm_operations_struct snd_pcm_vm_ops_status =
-{
-	.fault =	snd_pcm_mmap_status_fault,
-};
+	BUILD_BUG_ON(sizeof(struct snd_pcm_mmap_status) > PAGE_SIZE);
 
-static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
-			       struct vm_area_struct *area)
-{
-	long size;
-	if (!(area->vm_flags & VM_READ))
+	if (!(vma->vm_flags & VM_READ))
 		return -EINVAL;
-	size = area->vm_end - area->vm_start;
-	if (size != PAGE_ALIGN(sizeof(struct snd_pcm_mmap_status)))
+	if (size != PAGE_SIZE)
 		return -EINVAL;
-	area->vm_ops = &snd_pcm_vm_ops_status;
-	area->vm_private_data = substream;
-	vm_flags_mod(area, VM_DONTEXPAND | VM_DONTDUMP,
+
+	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP,
 		     VM_WRITE | VM_MAYWRITE);
 
-	return 0;
+	runtime = substream->runtime;
+	page = virt_to_page(runtime->status);
+	return vm_insert_page(vma, vma->vm_start, page);
 }
 
 /*

-- 
2.55.0


