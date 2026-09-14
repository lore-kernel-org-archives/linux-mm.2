Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 981D9C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A93C6B00D7; Mon, 14 Sep 2026 11:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982216B00D8; Mon, 14 Sep 2026 11:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 870826B00D9; Mon, 14 Sep 2026 11:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A87E6B00D7
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:15:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E46CE1C02E2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:15:09 +0000 (UTC)
X-FDA: 85212715938.01.7677CAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 09D3F180002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:15:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4g8Eomu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4g8Eomu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398908;
	b=bdnm0WKkzJvZhrX0pCDgQaH9/TC/b5hxyljhFwPm16N4Y7b21NwYdEFzrsJVhxC7NKPpYe
	bTJCxx5OzmFFZcn/k2JzyDm+6DlvqAiposaQq08l0sfpwpBtDPGbM4+FhK/7nGdWaDsL5r
	PhQ41cDgfSqXnCc7S/sPRTqZiFw5tcA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/40s6lyT9bZpyR+Yy0EbDmmnq6isDZhtDSiJykjXkI=;
	b=ghHAJVD6TGgYu90+ykaZqql7TXQaAi1lgtnEeTzixl7SLIVL1OzyZUpLG4TRoXxaBtjVcV
	u60tcWGSvA5aeWyzQpVBLb0QW5Qy2yve0yZqqU4KWwTSY86ImcAUcFQXrfUxjohNQkWnmj
	i4dKLMYprhGK74qp+3lQAOFNXE4qaEQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44B504178C;
	Mon, 14 Sep 2026 15:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25111F00899;
	Mon, 14 Sep 2026 15:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398907;
	bh=1/40s6lyT9bZpyR+Yy0EbDmmnq6isDZhtDSiJykjXkI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O4g8EomuSoGBr7JylEOBMDOs3EdIDMAHiNHZiNGz+WkNkHzqvkLnkveyns92XmSaK
	 wAzE3bORHhTGKcAQe5Hf8hb/+VQbrptzz+7CpdpSbhSF6Ak9fW+WiMgHW7pdBriEZb
	 x1qYzxdun1eTBlP+f0tcdbxD/mcC8XDF9QvwLAItTu+ZCl8rGQ1ivKpjUoQLjAVuve
	 TQkUIu+X2Hd82kd+orGw8xK7SiE5bY3VPKvliUth4R5/IbejZhi62XqkkKwt+1y25p
	 0sHJHkcCeG+Ri3Wx73Wf7lYpasYmVxZfDSV/Zm9zNWhuwtzQWZm1Wt5g7T4j79mhUw
	 wlQ58L1roQOOg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:54 +0100
Subject: [PATCH v2 34/40] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-34-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2543; i=ljs@kernel.org;
 h=from:subject:message-id; bh=eDLmjh2bzHIv4YAPniXBvBcmDHaqL2K0F9inIsPpqyE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG822Cv1Qqjn/738q/w2imubyv2Yroc8Xc7CMn2BK
 M+FzX1/O0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRmd8YGY4+iF7kaBlja2M/
 has0996Dzf52ZxQyGKu113QtjUpWUWZkaM0/pbGovvL7i22q23s3Cwn6htf/l/mc5GKntH3nROa
 L3AA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: 09D3F180002
X-Stat-Signature: b8u1q4u7ihj5yp51bxe7q8xhngx5yeze
X-Rspamd-Server: rspam01
X-HE-Tag: 1789398907-220619
X-HE-Meta: U2FsdGVkX183fi4dfQkWBg/JVemjac4U1p02lqL07C3tMN3rDkgxcjGkwgeVL5PEGqPGMj+PEllurIS+Lu32D2fG377XrLr9jP6+k7VvBphB1RR6C8JJOJESHENav9uYtJb66tCguZ0mi8FFCVw1cL4GCXiIFnGQ0ifiCJcKyiFbB8SAFfkP6VWD4Rf/7wTpUccoQSWSBTmVkSz9IzaUxE8ZOoCKHqfG0xeqFPHPXZ48HbHkb3i7gw6bLGVUPt5egMwkoSr6oEzGHjypf07lCsRBdeIuHJAzYycbPNsR3E+elC9B9SGVltrfrZzZz0uC1vlPNhzfPVVzJXKG5kTX3Psdw9NPfgxYYRYeuX6Xh/IhEa62dIydPm2abLwtyO5/ahMjK6zKuVKOaAMoTPJzfWW8X4t3Y4Y2lFZyeViX6Ulhi59eAfQG35XOaal5Lx+qxTaAeFUIalzFQAtZ3jmOte1/KVCtUaeYlhVDYBfQeG6otBUUSLKegpXvVszrYBMJnqLkMylZ32xx9r/iboxqbogNBjuBjknF3/YO0ug5nDGpaVIKoDKhOr47L8UbAKVCEZWKv05GsbgqFxK/adPoI5qU9JmqgRB/sOG1zCofP4rvKXEzCVU/sCo0/pwLDO/+VDT8MeVTy1seBX92AzwXTkXVl1ZCXm1Hvh2VGjwcJyrwXRUkb9YPFVwZ00ou9aASi6HQunmNUtaUcJNLllxz8GFZCi7j+dHtB0/zRQaGq/HBNKaEAoy7TfeZvlAUYw3tzFLuJgBujf98JjPMWrwwROWdZn/5Qi1lF0zeSDrHytk+531/TJ45Kvh70Uop8Pd+wQfLEriM6yTZf7rR8OuCxncDJ0cbsqAaFomx3boz1XpMGGk5+/4V0bAPUCjWjAfILxkSzs9BMGKIdQvIbrKDbuCNGM7OtUGHMDPqwK3o1oS2HaeVYzMDWdSHPJT3vSRjPJuBksjKnaH8FXmp7TH
 WX4LoGFw
 6DZW3+FV12ebOTMFHMXoqDEhGem3G6Ug58Njf1KSYQcN85+Eadshup17x5sv6Mx+r/dk8nx3cV+Tl901d6l6oDkynrFJNfp4YjdQFMxk1biQLHBlO5xGZkE+onbMfTw5XroBfzhZG2mUEdpMKW3kG/ivme24+/5rm3TaPDuccHE6FN/xcYIAfvc4UTXBUiQEjEqph5T5AaXjnBfKQE6llTgpKkSPx6hBEzCUWSh9AB82oRwJmEs8SpYe7PeGiBVvr1Qbwu+YCE0kSn2SAnLXmqBnKUXGvR4eA7RwvAvezSy7g9kOEqs7d7yPSO8njsRs882wS0TjfsvROiYUMaC4vg8HTuhTQDCVRhFHAo8wYLR6retQu5eu1TqCVNfSTst4W/MU48j+keE91H8X8MAzNH3k2cyXBL5IYJg/+o2TNiF39kFLtuuLRb4b1jA/mJsqlBxlaPa66Dr/HlWP1jb8OxLGgSqFDu4+oCsehkl3q0ivr7stnAotHvSDc2oATpwqHbBlywnCqbB8ssYn5UXttUH7yFJqWPEZDVdpJDvFq0MT8NZSvyiWhpBrJRzxB9j/xCPvF10yitFS8kNgKu+jF0xkBNawAF1vVYGzCVnaPI+TDC/RDFC5W3oAKXYiUkug4A30MTwlDbvLE243Am3n0QpHXwwFg5VJXWdKoGsSNnLSPQChWV9rAKkxIYg4/AGe9ILiFcAxYC9p0mMAnxh+RV23cbAwAZcwLE8XOebxVCeUuoOysabV/at+KjEDPtlBC/PITKdyH3V9AmBqxfZCzwu92BbHINob5ibjKlIXU4l+f1co95IA+HDXbU04t9QgGp94vcPgOxuzPwE4DJ845oc+iZS/ca2NXPb2sMO/OC/oaWb50lVpieXxjHs/qSVYGcZX2m1aVojCP8luWmz1teIhPjWLMpDwnyL/TIyCUbpFfAyOwN2tR60OBaMth0TfEOMkQUTbnd7CisQw5fY8o1d9W2EE0
 XAfdd20R
 iVJTZ7Q7kX70PCTami41yI9eTMTe8PuRVecS7KuGDfs4zhwyf69wUE16Ak9HRdLqv+1UR8kTfXhVBIr4oZeB53WyrlzhgwX3ZsFqaizFLcxHOMskLsInTHDWSO/B671cIq0Mo//swOyOMhiN/cfB1NsAWyXeCElLyAatwe+SZqStxqDQ+pIpMaDZU7Y3f5U6BL8jMiVY43jeLDAibocHcA3hsgB+CBaI5jKPiEzyLpWVCkxtiU1FbZb9l5oNjgFbK2daU4/3l6CAo6yyKdKWt9J9EW+oO9VmtsjnWruy4bRMEeeLWv/ZErGmybVuB6Hi7MxtEr3lCfPnwMQrGIVuENPU0CTlbM0fM4AHwy+H2ugNMLRWyGJuD6ds5a7+c50ZDAEL86rnRNsoC68kdz5m0tRkjK2Bn0XTWS0rt7bo+CWse1qYz1k88GbG08nvKGfTyUkTzs1BgeEBvmeIs4E/rSl0jokJKYEEywefwO4l9gn66uXaSwnaha6A2DdoUdRkB9SzdNYkxOLCEZr+gjqGBhZZKFGfl1vmDNk94iuEIt3ky1sv9RvVdF4NpnZEvWJgosvztCtHwM0QzFMEm5raW6HMti/r/ioz0K/2EVDmzvAlAl5nZhpRTecuEY0VU4KyGFi4/Z/vLyiH3l3JGxiQ3IMF6RA+1NENVzK+frcj8DezYkOYr3EHM1N8Coy6AObzdVItNegcucxfZ1RiGU57kT3+9OB/XcNrSWLtR06oun4uK0YbFSRhlcIEJv/QMK+GZjncpRuO92bNTOmQXd8hZStufNZ5bgjG7LijQVlFXdNB21shhH/dSIrZlaf+l5K6E2heWGgBmjNC631sI7Jk9jn3fi+FO1T+Pd2G/XWXjRlqmFkTZPj18w5s8Tggq0yEtQYlcNfrT0gGOT3ToTWZoz/WKL/b/BhtqarzR5JSILrGhph3vwKG0AXuOZB8nwS3QmNw+U3BSsLRL+lCH/UrB90iidK6j
 g4r7W5JI
 4xQj3pMAPD4PeQDDKMFRIu22MvFVLRqAheHBLiA7X5KtoaXH6cyQqOsG0AIRsLPCdYpQks9S2AaJCUDxBKlZer+xlOu15VS8sCQbQ9jRsa4VL7KRtauUVN80ut6zvvV5wFW26FUzdUnsxXhXONYPUgZ0LeSMYd/DBsaD8KgZNC6ER0AznAL9REqpSvblvw55xn29pZeIl76eWoUERJcevPvKPvDJUdp4EMzqwl8zpN5RcWAoS1GDRsqgFrIdxSZzmaEy81nFZwqy+TSHiKXgZeAw88zuVkX9ZanoYdmBFdrvcjdwCJ5BCMbKlcRvI0hQJZzQeOU2ejEM+G3c54Izuu+FDo05Gt/mxDUnbFQoxRlvCAJ9Pc/pyH7EfZtgBSNg/y35wgDYko/B4RxusjnPmBOd9/xJyNk3+QgCSeb5fDYzLGn762ASYQtN5LMGQf6ckDqsjWg5mhHjkAf6C963X35kpuCsfzooieMtu35eeqdb3SC0utOXRUIAb9TnFhTDyNJXULUV86d7oTl/NpSMawuqW8M/XrQWl/hMRSMXIEuWC+fLVP6QWsLNaMEMpuEz/XjNxQFDqeyWihl/n0oZQm/VQAVKqgN0haMH0GX6yv6ETeHfCYuOpypbY8SlOQf8spjx9xyHXiCVb160YtHKuutIUOW97BBx58rHJmGFKCxHFOZoi485w+oyRDiZvtdKDVtpxa2cViH4S35ea+9Rupd5Bc7ItMbI2igBusVYalGcYmGgw4DCRawuuTZ7yvub6fPdNT2t4WAeCUp5FY4Skg078efb0AmwEPady9QHRvOykG/S+K/HNXO0Sco3w6bxdOj3n+6l08et30oyBxBnHcliYRlRVrkC643bHOA+s3n+qpCOxSrmn50gRKsPCycjlKOho4bXrtlvSiY23NV6+ElcrAFxYXMxVBLlvq66NY4tg5MZPONcdRXUHyTNAv+rFGInzUXyltigzs7sRzVL+WXZ9qWQW
 2TvMrYHa
 JYboL1Hxr1xcx80NMV+jjcJOsUEsrAmhd2iC/ikXGDxVfdmNzHVdDJCgLXc+XwcFiD5JYChnaRjd7NRDy1X/QNl8NSUN5Y6WWjp7amegb9m+s/xBPSJi+F1USnXOhiWWyGd6iB1AdjiMaxeqQvFdmA2FQpXSn7ieN5OCZfJ3A1yCZ6vbfjEsegMU5Lpm6twPtb5PvF+fMYvzBssk/X/7b8oAecM5bRWoSit+KlQnTRl5Rr3FUWWxGxgg2WCq/CV4MuFnqJlTCE/HfDrSXpxbZ6utEVo/CRDMPvc+q9L0EAFGaC9utJwlivtrMciKIA5OaBAXKCw2wqJVj8gNEVHLugA0vtlXCfTbUGYoEgDkdYtxwu6qD4xhYEYSEYDz0TPdFWxE+6v9Qbd2lK9R2+u+NqHMB0kNINtxQv5b2Ohrn6dIKr7orGl1AEMhatzSK49iVx929PY9H3rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is now an invariant that VMA_IO_BIT is not set except by kernel-owned
mappings, so each existing VMA_SPECIAL_FLAGS test need only test for
VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.

This is precisely a test for a kernel-owned or fixed mapping.

Update a number of callsites which already explicitly handle hugetlb
mappings.

vma_supports_mlock() and ksm_compatible() also explicitly bail on droppable
mappings - detecting kernel-owned, fixed or droppable mappings is handled
by vma_is_persistent(), so in these cases use this predicate.

should_skip_vma() tests for locked, kernel-owned or fixed memory (having
already excluded hugetlb mappings) so simply test for those there.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h | 4 +---
 mm/ksm.c      | 4 +---
 mm/vmscan.c   | 3 ++-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1b6153013061..83a4ba52aaeb 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1111,9 +1111,7 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
 
 static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
 {
-	if (vma_test_any_mask(vma, VMA_SPECIAL_FLAGS))
-		return false;
-	if (vma_test_single_mask(vma, VMA_DROPPABLE))
+	if (!vma_is_persistent(vma))
 		return false;
 	if (vma_is_dax(vma) || vma_is_hugetlb(vma))
 		return false;
diff --git a/mm/ksm.c b/mm/ksm.c
index 624f37975e12..f80372bfd4b2 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -747,9 +747,7 @@ static bool ksm_compatible(const struct file *file, vma_flags_t vma_flags)
 	if (vma_flags_test_any(&vma_flags, VMA_SHARED_BIT, VMA_MAYSHARE_BIT,
 			       VMA_HUGETLB_BIT))
 		return false;
-	if (vma_flags_test_single_mask(&vma_flags, VMA_DROPPABLE))
-		return false;
-	if (vma_flags_test_any_mask(&vma_flags, VMA_SPECIAL_FLAGS))
+	if (!vma_flags_is_persistent(&vma_flags))
 		return false;
 	if (file_is_dax(file))
 		return false;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 12ed3388ee41..09ff20c3df5b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3477,7 +3477,8 @@ static int should_skip_vma(unsigned long start, unsigned long end, struct mm_wal
 	if (!vma_has_recency(vma))
 		return true;
 
-	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL))
+	if (vma_test(vma, VMA_LOCKED_BIT) || vma_is_kernel_owned(vma) ||
+	    vma_is_fixed_mapping(vma))
 		return true;
 
 	if (vma == get_gate_vma(vma->vm_mm))

-- 
2.55.0


