Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A92FFC88E79
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48CB36B0088; Mon, 14 Sep 2026 11:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435F86B0096; Mon, 14 Sep 2026 11:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D7586B00A6; Mon, 14 Sep 2026 11:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9C786B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:01:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 858BC16017A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:01:22 +0000 (UTC)
X-FDA: 85212681204.28.23329C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7F9C5C0005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:01:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kDawSCi4;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398080;
	b=Qp2A57OGJW/5SoQ7F5QqSInM1vJDUWOiDzhl2Y0WWksPSFqkaSIeoIouq7EiNMMHuYEmq3
	hhnM8dID7skGex5cqBFhPJMN9EFiG19rB7jKTMEcJXlUosZrxVm6ms17Bi6CeILHK8kcsH
	gmTdvJGwg/aPcgj+SBgXXHSjYol1Kv8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kDawSCi4;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ilZPof+0LbvqXcFOGPThHadpzY2562CA+jmNtEIktM=;
	b=iYcy+5a7rPgrCc7hqkgrCZ0B7lDm0eb5duuCtixOXbHUYBHY95Rcp/qTmgrkNeSTdIeE1z
	jOCA12bWN14bBAkHFENIc+0t27a1mmqqZhJ5M8PBe43Uq91JC8Ka7iVROIZS2VWM/Sghrj
	gJfl5PcBLtwKSl9MP5s4nxOEhYpDqKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A849041455;
	Mon, 14 Sep 2026 15:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773501F00893;
	Mon, 14 Sep 2026 15:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398079;
	bh=8ilZPof+0LbvqXcFOGPThHadpzY2562CA+jmNtEIktM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kDawSCi4DhKj/pYuYizEVxBuLMYZVZkf/PMHi3bfT7mAk54RFcQjk5ooCqgLP89B/
	 pv8WibAs2fQYov93eA+ovjx/XmpJM7HsArl+H7sDGG+vSYHIA3ckyWbRjqJqtZEupq
	 WikqKE3LrUm61hLTs3KYTt4fMxR9IPuOIqRvnCEJq4VfGSC0oS9DvCOH/Ib6uR9hIi
	 +lajvJpzKP1DEgxpprmhs0Wt0QxMFWD+MRBKUzRKMqfwhWMolP9/cQmYuUxm/BR518
	 sRcssmWxlQHmV5Wi2yaQrQTLjWcQfNJQEmJatvgQPfJ+afyfk+DbaPIzuvs973CHjW
	 SphVJxFe2DN1w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:24 +0100
Subject: [PATCH v2 04/40] mm: consistently validate VMA state after
 mmap[_prepare] hooks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-4-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12664; i=ljs@kernel.org;
 h=from:subject:message-id; bh=mxXTL8qsj7rlH8qSs/uTdWkUxg3gik0quNO5GcgMUeU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK+zFAt0VpG5Fn3c3E7j2fE9wTk2UuvCpcT+1p5iL
 JiZsPVZRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACYiqsbIsOO6n/2WO16Wa560
 bQs+vOlYlHrsQ/7OxlWXDiVyb3cv2M7wV/bWz2PHi3b3/7pffPTZfr8WWyn/M2d3dPHG90h3sU6
 R5wAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7F9C5C0005
X-Stat-Signature: obwgsh17c68srazoy5piftg4s6juo56s
X-Rspam-User: 
X-HE-Tag: 1789398080-497573
X-HE-Meta: U2FsdGVkX18ApETDC/iJdJd8o5bY1wRnQjTefWushrzL5BxbDSS96/U5ZoIv+AEJBNhSJuV7X8GYYjWl6Lz9jiL8OrkiR+Sy0D2fC66FXLivMtyW3T7jh+jPTRn4kN6mclMcOevzF6d7jhNBlZ+HMasoMyzNtp4yFK9viqanx4vrIqeBVK0Myrzm/koJHmCVfsHZZGubaDpexIHOE1C2e6yVSsiNS8bEfj2oMB4t4axn15mFbHIHK+bwE09Kn9HEV1EwgX+mrnPLUshEYWKeqqvMPl6UsRQNYAa7kN6osiC64aj6Y2D2qgGJ7dnVzA36ROsmhtIKEU7BQ+QNXVPBnMGwler8e04Tmqe+mj1vaihUMiGkEzm8oaMAWkhewTLOxaG1VrchVcjPQRwQAXFXl4Jzh9X/JHiRZGRgJasjMJ/vJCzMI1s+W6HHE8uF4EVSHqlRZCBFahlaBmaxzcSGgHmtNApA+GFF74sYVY6jH/cw2dBAiJieD1cfbAXBzPEeFlF6/5Tk9HjqwjYKVAvck9TQJ+emcCYA3a+qj5tMoXn84BU70vvYYyk1l735GRcRKgTVQAklngv2G4YKncF4Km1VJQN8tWBSmVMQ1CxFUsngKgjZipVQTf2JUcfKpxpAzJ5Vil6gcjLLVRIYwn2sPRlQTLW/NxQU0hv80FxzXvtFbpohbORd+iensH1LixQk1p9uhrmXlvBo4UJAnhluJgjqVaPrystSydFlnigPg8y1LbwIyADEaNJ/Qj3gtQV/+vf+7u8PNN4jFmTTc+SK9ihMTEX7tCV5LJfTCOF/ebGvrwacqSf758e330JIcv1T81WWPQj65pwKph4ZseV3OZbz/TwrkDq5uC5yagEj4Hu3Jiyw5rsrys2TBTW/LY6HXHHYCjCK7n2lCijjHGG8bvVnO8TJevrtYOrRVhQzBNI6BkpgpWFW7DM/ZeA8uNrP2XOu6sJ5OEuIphXC6U/
 EKUx2U+V
 3A9B2hLLURdsOpKzUuJVcRuxgXZ4ndCvdGGuWAU15PIUv0QkyYznNgT8Uw1fXOSt+pYu650Dn+wsfm3Dg48zEDiu814BNzV+be78hbFWrJqc4S5eFxxRh6fhapEBlJqkQXiiQp/VdFcf9Of+s1H3ExpC30XNVtuCgf30XwkGzjCSZ6qq7i/pANr0sDGGdWmSq5nUcwCNVZsgvV52S9FyS2NaT4uwUQA7/QfQwc86GkoiWRtQIjV/gDBeOdV4XzhMFNRXRtFUDL7XeVlBkKOjbeqqAk5ajpBkh2ZEP5+RjfLdN2VcHzG/1eBXGPxnF1dN03d+lXQV1gLeS99ndFygLkqbmXHVfHYyr68PcOnA3pk2n1iPHOQEHObkuwExr2KwFmZRhVhrxMr9WYXwxocBQqpYtn4KXknD2j0Pt2eHt9irJPHMIf9E+ExmLvodSQdOi7Ef+2qZRwoEEMKdOXuA/YoVTR30XH0DO5JcGGPeXoc2nsH8wMkDsJTeExdcpoCnej7f4UYpi7duKgTSzvU2FVvYyc0yaypQ5s9NtGta2sC4265ukeZruEqkiUIB47RhLpGoFvLIGPLNWjMYOOml4EU/DC/BsMGMvhLueLAC3ozvS6C0FXwnFCh4AvP+SJ66c2mbu7VXsrx5ZFFLg0byohseY/A5b4fePT0WrDw9v2mJhL+QutBIFfKs26bKJiCb85bJGgi37ptM6nWY8/kX7DgMT0CskWcBx0pph42CaoHfx3wKkBciJ0L1VIjOR27+4c9jtVFpewehRhfeBnMIvtpFN2kNcv1+E3ydgOAewvMVVFO5la0QKLb59ZVCslA6BrsxQZW969GpQ/kVRruVskUnt3WLDwa2CANosB543Xn3kRDx2CfyOWmMnAoKveEmHddXBKFCvQPf4siTlSuJg0xtonMf+hEHBdcrbJvzVv7RCOVy/Y4rfYs4q/px3FbFJbs5U1kqKa1id48kJYgG3L6kaEgbn
 taJYqaWD
 6Oh5nhv6QR/qAOnbFeOspqSSIhpoK6mdMkXfI4DP/kigtBOwMLReyh+7mh0aEkX3G57IewZ1sOAMddssjAqZ4wppcDJ3G6Ea9jRYBfYBdGQYRpVxiW5nBYugXUZc2NOUBjFnDKf9lXdqJ/XIS0Jey13DzqK97XIkgmF43YDYY5zZs9r/qUBdsvH7nW64MJnSDBVx3njUnZbsTTKKkKuUFMGwIGFiXLmPY5lmszxcpEqz67271aQQi6kZcSxdwvL1yM2+t9UsZTHMkYUdYCzGovGJiKH9UteYSaoLK9xlQLzP/Y7Czm08/FGa2ZI+Uf5dCnfuC2MbWmUvrK80UZCIUAToqEr8qTTrfxyPDNqvezG6LzMRFa6kzxmYuN35KVny2qa5N/qfQy9KwurCaYa201EcNWahMUYzRhILWWTAav/Q/lla5nTubt5xrNRO80Xuv3GEqnn47XWXKY98jjebrAo8BxIr/JhbUS3yh8GW89ETUfiPaOzhowKnUsVt2DoRL7YRPojCIcJd9hMhEjh7o7KeUJUwrNvCeYyJ0W1BDkBZq5v1LYp4gHTvqapauLQNBnyWsxWDqRvme6nmtkebYJ80hThiQEn8Dg1Vyq6cjGizcEe0B8oEEy62bemrsA0zkcPSlYrPL+SObeEis7SBVfz6woHZ0Scdm+7JT1l3IeD0eXQu7z410yvbOlXIRAFFbOCGBRBKyPMaqeyr4Gdn/m+K5cBZqdGOCNhXLK1QQANyt3mpiPkFYMJ/XnP9QKsgmtvWD/UJUWhACBjOXGXsI0vv/pxDBqkrkdfS3EeNyuP9xqN0bozDWznQCEOWpsTTfNq0TdPljw9pjzFlbP2LabZvBzNdLapgwA2odpMN2zYUCJiDlCk4U3kw4Vn7jTgsVEWA9cUfBDcB3Yd6sesnCD3Rv/0KER9p1LtCFdKkCVkfXaKIy9C1QiNNoMtG02bgpL6oCEx5+3jF+hQgpfMwRKH/pYWDG
 xwXWoBCb
 kjZQjFZ1oXKTNtPpmDekxlavhVYgBf4ncfVd+Y01swXdejPE6nu6wS6csOKQNriMplwMiNePH8699EyRU54qO/ygmLw8twUs0GNhpJGW4jJ2/ApGkP3AUG3qrw94AQjY8abqUfVS9NPfYWs2HRwEQELxTVR7Pt7hXmr96Jz1xo/nlRR9iO38lYS4qxVthlbUHm47PpKgcP/6ehI0lZPDCE77Li9/MY/8ITsefnCAzJ6l5SGgKUp9radH0i5WzYG/tsjjPaD4KuwJ0HI+1+W8ZtWc+in0G8vfePLKdXQFLHIxj24XVjivXNZuSH5jyNIfHrbROsAeiHgHC/6dMwgnA3+vY/nQVBgrzTxqQhMj9riQnG3FG4yd93KmD4hruqkQg77vIxu16KLiDQiyniRiT6VTW5mV+QMfx7L4G79P+eCrRMPlE9DSHGWRPHlum1pRgZyEQi4USDdZRj+/ce+gX74L82CVa87giFdI500KfyO9x/JcdOG+fdo0aB9/YUjPP8kVK+Kal3dzZdJLGSjgpqZNoE0ZtWF8aFxZJuLyMS+ChEQlA2yYE6fKlg5UmjOpeIAbmTOkrgQru2yTUnc9Lnp9RHEvxcp+2fz01SBVfr9pqr4trYQaCW2Jvb3AMMx4aSxs2PwYGwDBR06U6mEGmwe08DbroNgVJ5FTEHlfcOtRnxVx2TTsW2gFYZnTRgN+O9JNiFIVB+dKnZIlOMevYO/gIf46h6M+CedYEdSUs5RDB6saVyhxJRvZ9fOLRZedIQmKjhwrF9IQaqU7i/qOVeML7NGnC997gNkwdoZ2Q0TooS1xkPEGoHOVfZ1MVI7djzksAIoMa6CmqVx6BfXJgKLuEyda11xbA6y7kf12ZNBHAsyOZJlWQdS8LNo0ytJ5AjpnOveNGQ2Atq18AeliC9daMFALOZo2LJXG41bx5hDQot9lxBdJPuURP6X4iSMyUJiInfC9gJQ4ITXKbSDDW9vUT3VRF
 tpog8xaz
 1wfGPCw4hXulIcEAaMKN6ja8+9Aht0XWh4RbqF8n87Sq9lc5m9GD1s7YtVheDtPf81PYp8pE1AUI7HQ24enboRTLMsD0yJoWqdNHmfI4UiE8LIwK/QXySvk3heYW/oU4K/zWHY34F0Gx+yBkhqO45XKcNM1zUH3D8TGqe1tYjJn3L9+BMTk55QFaRY5pU8VfZFf6c4tkJ7V2IaQASLhd17sw8CwY7Ref4A/X3zMuud3Iy7KSjzSXZJdxG+DKyuq2Vp1zLgt8Gb1UqnedrKMj9bU5Wadp4dSyMvc45oKbVYEdBK28lvJf5iIjdEvTiY8bwQKUhcSvCdQOt+S9/eIImrnhnHE74DAoGpXWz2VxtKjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked, the
driver might have done something crazy that is not permitted by the kernel.

Currently we check for three such cases in __mmap_new_file_vma(), but only
if the legacy f_op->mmap hook is used:

* Did sparc ADI result in invalid flags?

* Did the driver alter vma->vm_start?

* Did the driver make a file-backed mapping on a read-only file writable?

Generalise these checks for both mmap_prepare and mmap and apply to all
invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handling
in the core VMA code and the mmap_prepare compatibility layer.

We also WARN_ON_ONCE() on these conditions as they are things that should
simply not occur in the kernel and it's important to call it out when it
does.

We invoke mmap_prepare_validate() after mmap_action_prepare(), as mmap
actions often manipulate state in the descriptor thus providing the final
state the VMA will be derived from.

Also call mmap_validate_vma_flags() in insert_vm_struct() to ensure that
special regions which are inserted (such as a VDSO or VVAR) also satisfy
the sanity checks.

This way every VMA established through an mmap hook, whether via mmap() or
the compatibility layer, or inserted via insert_vm_struct(), has been
validated. brk() VMAs never pass through a driver hook and so need no such
check.

While we're here, also fixup a couple disjoint blocks of #ifdef CONFIG_MMU.

Finally, update the VMA userland tests to reflect the change.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h                   | 49 +++++++++++++--------
 mm/util.c                       | 19 +++++---
 mm/vma.c                        | 96 ++++++++++++++++++++++++++++++++++-------
 mm/vma.h                        | 24 +++++++++--
 tools/testing/vma/include/dup.h | 10 +++++
 5 files changed, 156 insertions(+), 42 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index fe576d468af4..1ed11eaf276a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -213,6 +213,24 @@ static inline void *folio_raw_mapping(const struct folio *folio)
 	return (void *)(mapping & ~FOLIO_MAPPING_FLAGS);
 }
 
+/*
+ * If the VMA has a close hook then close it, and since closing it might leave
+ * it in an inconsistent state which makes the use of any hooks suspect, clear
+ * them down by installing dummy empty hooks.
+ */
+static inline void vma_close(struct vm_area_struct *vma)
+{
+	if (vma->vm_ops && vma->vm_ops->close) {
+		vma->vm_ops->close(vma);
+
+		/*
+		 * The mapping is in an inconsistent state, and no further hooks
+		 * may be invoked upon it.
+		 */
+		vma->vm_ops = &vma_dummy_vm_ops;
+	}
+}
+
 /*
  * This is a file-backed mapping, and is about to be memory mapped - invoke its
  * mmap hook and safely handle error conditions. On error, VMA hooks will be
@@ -225,8 +243,11 @@ static inline void *folio_raw_mapping(const struct folio *folio)
  */
 static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
-	int err = vfs_mmap(file, vma);
+	const unsigned long prev_start = vma->vm_start;
+	const vma_flags_t prev_flags = vma->flags;
+	int err;
 
+	err = vfs_mmap(file, vma);
 	/*
 	 * Either we tried to call the file hook for mmap() and an error arose
 	 * or a driver set vma->vm_ops = NULL intending there to be no VMA
@@ -239,26 +260,16 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 	 */
 	if (unlikely(err || !vma->vm_ops))
 		vma->vm_ops = &vma_dummy_vm_ops;
+	if (unlikely(err))
+		return err;
 
-	return err;
-}
-
-/*
- * If the VMA has a close hook then close it, and since closing it might leave
- * it in an inconsistent state which makes the use of any hooks suspect, clear
- * them down by installing dummy empty hooks.
- */
-static inline void vma_close(struct vm_area_struct *vma)
-{
-	if (vma->vm_ops && vma->vm_ops->close) {
-		vma->vm_ops->close(vma);
-
-		/*
-		 * The mapping is in an inconsistent state, and no further hooks
-		 * may be invoked upon it.
-		 */
-		vma->vm_ops = &vma_dummy_vm_ops;
+	err = mmap_hook_validate(prev_start, &prev_flags, vma);
+	if (unlikely(err)) {
+		vma->vm_start = prev_start;
+		vma_close(vma);
 	}
+
+	return err;
 }
 
 /* unmap_vmas is in mm/memory.c */
diff --git a/mm/util.c b/mm/util.c
index 016932780925..bdd5923eebc7 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1224,19 +1224,28 @@ EXPORT_SYMBOL(compat_set_desc_from_vma);
 int __compat_vma_mmap(struct vm_area_desc *desc,
 		      struct vm_area_struct *vma)
 {
+	struct vm_area_desc prev_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&prev_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
-	if (err) {
-		if (desc->vm_file != vma->vm_file)
-			fput(desc->vm_file);
-		return err;
-	}
+	if (err)
+		goto err_put;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&prev_desc, desc);
+	if (err)
+		goto err_put;
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
 	return mmap_action_complete(vma, &desc->action, /*is_compat=*/true);
+
+err_put:
+	if (desc->vm_file != vma->vm_file)
+		fput(desc->vm_file);
+	return err;
 }
 EXPORT_SYMBOL(__compat_vma_mmap);
 
diff --git a/mm/vma.c b/mm/vma.c
index dc74b3d721cc..626a18c08a26 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2623,16 +2623,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		return error;
 	}
 
-	/* Drivers cannot alter the address of the VMA. */
-	WARN_ON_ONCE(map->addr != vma->vm_start);
-	/*
-	 * Drivers should not permit writability when previously it was
-	 * disallowed.
-	 */
-	VM_WARN_ON_ONCE(!vma_flags_same_pair(&map->vma_flags, &vma->flags) &&
-			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
-			vma_test(vma, VMA_MAYWRITE_BIT));
-
 	map->vma_flags = vma->flags;
 
 	return 0;
@@ -2710,11 +2700,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 		vma->flags = map->vma_flags;
 	}
 
-#ifdef CONFIG_SPARC64
-	/* TODO: Fix SPARC ADI! */
-	WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
-#endif
-
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
@@ -2777,6 +2762,76 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
 	vma_set_page_prot(vma);
 }
 
+/* Check to ensure that the VMA flags of a newly mapped VMA are sane. */
+static int mmap_validate_vma_flags(const vma_flags_t *flags)
+{
+#ifdef CONFIG_SPARC64
+	const vm_flags_t legacy_flags = vma_flags_to_legacy(*flags);
+
+	/* TODO: Fix SPARC ADI! */
+	if (WARN_ON_ONCE(!arch_validate_flags(legacy_flags)))
+		return -EINVAL;
+#endif
+
+	return 0;
+}
+
+/* Check to ensure a driver hasn't done something crazy. */
+static int mmap_validate(unsigned long prev_start,
+			 unsigned long curr_start,
+			 const vma_flags_t *prev_flags,
+			 const vma_flags_t *curr_flags)
+{
+	bool was_maywrite, is_maywrite;
+
+	/* Drivers cannot alter the address of the VMA. */
+	if (WARN_ON_ONCE(prev_start != curr_start))
+		return -EINVAL;
+
+	was_maywrite = vma_flags_test(prev_flags, VMA_MAYWRITE_BIT);
+	is_maywrite = vma_flags_test(curr_flags, VMA_MAYWRITE_BIT);
+
+	/* A driver may not make a previously unwritable mapping writable. */
+	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
+		return -EINVAL;
+
+	return mmap_validate_vma_flags(curr_flags);
+}
+
+/**
+ * mmap_prepare_validate() - Ensure the driver hasn't violated invariants in its
+ * f_op->mmap_prepare hook.
+ * @prev_desc: The VMA descriptor prior to the mmap_prepare hook being called.
+ * @desc: The VMA descriptor after the mmap_prepare hook has been called.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+			  const struct vm_area_desc *desc)
+{
+	return mmap_validate(prev_desc->start, desc->start,
+			     &prev_desc->vma_flags, &desc->vma_flags);
+}
+
+/**
+ * mmap_hook_validate() - Ensure the driver hasn't violated invariants in
+ * its f_op->mmap hook.
+ * @prev_start: The start of the mapping prior to the mmap hook.
+ * @prev_flags: The VMA flags set for the VMA prior to the mmap hook.
+ * @vma: The VMA after the hook has been applied.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_hook_validate(unsigned long prev_start,
+		       const vma_flags_t *prev_flags,
+		       const struct vm_area_struct *vma)
+{
+	const unsigned long start = vma->vm_start;
+	const vma_flags_t *flags = &vma->flags;
+
+	return mmap_validate(prev_start, start, prev_flags, flags);
+}
+
 static int call_action_prepare(struct mmap_state *map,
 			       struct vm_area_desc *desc)
 {
@@ -2803,6 +2858,7 @@ static int call_action_prepare(struct mmap_state *map,
 static int call_mmap_prepare(struct mmap_state *map,
 		struct vm_area_desc *desc)
 {
+	const struct vm_area_desc prev_desc = *desc;
 	int err;
 
 	/* Invoke the hook. */
@@ -2828,6 +2884,11 @@ static int call_mmap_prepare(struct mmap_state *map,
 	if (err)
 		return err;
 
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&prev_desc, desc);
+	if (err)
+		return err;
+
 	/*
 	 * MAP_PRIVATE-/dev/zero mappings are an ancient way of getting
 	 * anonymous mappings. Rather than allowing these mappings to be odd
@@ -3455,10 +3516,15 @@ int __vm_munmap(unsigned long start, size_t len, bool unlock)
 int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	unsigned long charged = vma_pages(vma);
+	int err;
 
 	if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
 		return -ENOMEM;
 
+	err = mmap_validate_vma_flags(&vma->flags);
+	if (err)
+		return err;
+
 	if (vma_test(vma, VMA_ACCOUNT_BIT) &&
 	     security_vm_enough_memory_mm(mm, charged))
 		return -ENOMEM;
diff --git a/mm/vma.h b/mm/vma.h
index f15faa83f3d6..77d395b8b103 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -782,14 +782,19 @@ struct vm_area_struct *vm_area_alloc(struct mm_struct *mm);
 struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig);
 void vm_area_free(struct vm_area_struct *vma);
 
-/* vma_exec.c */
 #ifdef CONFIG_MMU
+int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+			  const struct vm_area_desc *desc);
+
+int mmap_hook_validate(unsigned long prev_start,
+		       const vma_flags_t *prev_flags,
+		       const struct vm_area_struct *vma);
+
+/* vma_exec.c */
 int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 			  unsigned long *top_mem_p);
 int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
-#endif
 
-#ifdef CONFIG_MMU
 /*
  * Denies creating a writable executable mapping or gaining executable permissions.
  *
@@ -838,6 +843,19 @@ static inline bool map_deny_write_exec(const vma_flags_t *old,
 
 	return false;
 }
+#else
+static inline int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+					const struct vm_area_desc *desc)
+{
+	return 0;
+}
+
+static inline int mmap_hook_validate(unsigned long prev_start,
+				     const vma_flags_t *prev_flags,
+				     const struct vm_area_struct *vma)
+{
+	return 0;
+}
 #endif
 
 struct vm_area_struct *__install_special_mapping(struct mm_struct *mm,
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 2fd422789717..2986ae6ca1e5 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1359,13 +1359,23 @@ static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 	return file->f_op->mmap_prepare(desc);
 }
 
+int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+			  const struct vm_area_desc *desc);
+
 static inline int __compat_vma_mmap(struct vm_area_desc *desc,
 		struct vm_area_struct *vma)
 {
+	struct vm_area_desc prev_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&prev_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
+	if (err)
+		return err;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&prev_desc, desc);
 	if (err)
 		return err;
 	/* Update the VMA from the descriptor. */

-- 
2.55.0


