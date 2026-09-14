Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64925C88E77
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F2616B0099; Mon, 14 Sep 2026 10:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CAC06B009B; Mon, 14 Sep 2026 10:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BEF26B009D; Mon, 14 Sep 2026 10:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3506B0099
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:59:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A05F120187
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:59:31 +0000 (UTC)
X-FDA: 85212676542.22.132B0C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 79605C0004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:59:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HnW+2Aaz;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789397969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pZW21joDRBUaKxwzUQh3KFT5Y8Es/1y/2DJwB/njVeQ=;
	b=zjSojSBU/JDyohzQwsGCToxxlbWpKn8/39axcFQE1Tv9+2cakxclmvGJr/K8R6ZIlneChQ
	hu/6Eh8kPjbl/V5MrTAhlLHK2LHCBsFabvWlP3qJP34/CzIRHCUJoEEAu/iMuGA4NTOfG2
	dEq4Ufs9CA84k1zXeVppnXVYVyPn3Qw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HnW+2Aaz;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789397969;
	b=upicWHgcJKVqnhT0SCGVPvcg/YF1WlLM5DXTDKkHreWl2+n5T8PWf66T3lOwtdVBtyr9jb
	KBFV1GARcMKycp0cSwZYO1jdvtI9SSFmk1nlE0//jV1peS8jXja9h8RNJoasDcMpd9jPEn
	WOIEMe5vZBZOE2D4/CxfdBd8DeU75bo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 954D543605;
	Mon, 14 Sep 2026 14:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AFC1F000FF;
	Mon, 14 Sep 2026 14:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397968;
	bh=pZW21joDRBUaKxwzUQh3KFT5Y8Es/1y/2DJwB/njVeQ=;
	h=From:Subject:Date:To:Cc;
	b=HnW+2AazavyexVIo74Bg73UujoM3Z012DSayATOnNZjl3MfSJ9xBJTZPAKFmN3VMc
	 th+xjTSVfkLbR67we5Uq6HLQ+xbzrQTuTNvW9vch0D5psiEOKLV4/GOvkp5NRH8/yV
	 EEJvpi5ikwPDh6/KO06ZApgPjfDMDJmR8V86Y5C2DTCSLtZQiWt7CVOfK425a7xmGT
	 0ci+yJUOLZm6UcvOrHB1KP1uQzos+nofIZogXA3/FIwFgWJ3bE14JuJSuMOyoFwg9T
	 KvihyX7WrmnibVw2JjFcYJxMDk3El2hL8Vu1n/hEnnLut51kaxSRQrKXFS4Y0eV8M1
	 SGBaiAfHmO3Cw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v2 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Date: Mon, 14 Sep 2026 15:57:20 +0100
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WOTQ6CMBBGr0K6dkw7ARVX3sOwGMoUqlBIi42Ec
 Hf5OYDLl7x875tFYG85iHsyC8/RBtu7FfCUCN2QqxlstbJAiRd5RQVlCl1HAwyeB/IMsSMwLdU
 QyFkzASopU8wqkxGJdWX1jP3uhWdxcPiUL9bjNrsZjQ1j76f9QlSbd9RyeftbiwokVKSNyrVmx
 PLxZu+4Pfe+FsWyLD+cr45z4QAAAA==
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
 Takashi Iwai <tiwai@suse.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=10931; i=ljs@kernel.org;
 h=from:subject:message-id; bh=/iHtXWh2MpE1FcqpEZH17raLB5B9Z+qJUnN+hdbqOgg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcK86yWWxTubsZhvd2UHr5/qWHZmV5jPttUBLdqzon
 oVnMxae6yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEWNgYGR7uS1Wx895+UU0z
 RnrFixMlzk93rt9zb7OVCveTfKGpd/kYGV6+S34fsYVN1nDZmqvtnt46LZzOacqfl/rWFWm8P+5
 6khEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 79605C0004
X-Stat-Signature: ebpcj9psjhqo6bt96z5jqneqqz4gshmp
X-Rspam-User: 
X-HE-Tag: 1789397969-238478
X-HE-Meta: U2FsdGVkX1+RJlKhh8cFl02AIqrwMIEpaz25duqGJkb9Wo5FhLaebfnfnJCIWg66tFNxNtuce4Kn7soczQ4tTE9x5NIKcR16I3cMuaAPgn/4RS8E/djiqa1ogSzq+kPvyrDIjz8d///6cboQRvVLn/xfdiZcJqumu1dL2nr8Jh5pbUT6jYBZtXbncrBDw3sAA/pn/0wr62s1x627RA2gQk8o9lSSng0EhiF1es/Ht7Vtmi+D8QACJv3KuEAnnAtk5NGBzOqFExb9qIHFpcOhzcilGM2rHu10HuuLFtQJlV4offPj5006XDLjY42+TsRy5MtPDcaTaVsViwE4VeNBO3yzv+m1gvcDqLLfwpHaGp/Dk0GiOMs2Y2J2ZeWE0e0g7Ot+FZ3p07LfdLuHr8eat7IWLswc8/nJTjUPZYPLo8XOTvUotzQZm0sbdylVf53shWPbYbbo8Okn0n5aKO/wnmlir9jcpFVia8mCjaqlg21Ep5Z2dvP/Sry6d/iAah33NZN2gtZwBKVEP8yMol9BJV+79MH2GYtn0ArGCuq4NZVNgapnS3qD8bhPYUkAb+KUhXataVh/+HEAm/rM3jxsYd4WmwJAhsiF3xHnXrhbKVe/Y0ivRpcWe3Hd8V0FD8JJ5U05iE/A1iiXKXuu6THPb7wsLcyyoN2xA9ugKhD/Z0ogJ2UwUqXbOeDMYmU7oUvQKvV3CQJMR6N1aFBlgwYdMljTK8mKeU1FdqPjUwirWWITg4PNRy5VIHyD+sKBXfLrmz22eOFddKpT9PxW+yW/4bxGiz2BFX+Q3RFsC31+QjXqCc66v2YJ2K1HlTEPA0ylN3LkiGOamgCKSsvkcoonofEVqqXRHY/w/YV3EsN34jmpAYiAMPD1Y/XvMpLMM+GZv7/nwBmroGyFFNdSJFh7SuhszlGYO54vTkY9OH6VCzqyC18Qa8DLSD7NBNsw+9EgwGdiJ4+qzvlIWUXOTsg
 vWb2/75d
 pzXS1t4xGx89xqySuTjmQF2w39V0Z2bzjjKAbne+EE/KmmZXIcnDnZORajM1T0WWQr68FVYtu0R5pZJweC+dGcORGs5mbjBPo7XCd+R3FRLDyz9lDrjwFcSpQU3gbtW0nQQs746Z471bJyS3HTxtRkbn6gs3B3Nib2jEfD/wyp/D6ijfRshQ0NmjfzhrUaZrDEFIL00YojhgJR9KL0Wph2fkaSvuOx7hJofwW1MCjgejPBVwhu1Ar6JJzbjD6IPDcpvjeuzeo8dgYSMNClhUpx6zvCzcj8xiSb8PDyQ7IOypUW2UQ7LggbrJ78gfzr40vLvBmdl0PExjuqJaboXfwfmwmaNFYW65VIpi5YOYXeSAPmGsi6gkeIABzizK2qMv78SBW9tmsNbqH0IJ4jYek5EpnUon2VhG38J6ossIHHOe7u68Kx47GvpshoRvttDavLnTwk+AlRBPlk2+DFtPAiiJquanEB/qSwGTK/OarAK2LohlVcW8ZkF2AhBG2ZBFjxeDC5FoWAdtMXpDeMW5eS6/OWmIO4rnbV3d9YnI6sUuMGhyBtXXEWKZg5MtZssrtZYMgPsgQpOBkvGpIY0EnguBy8j0h/ViyKK+Ha6vw4dAuW6xqHuC3KHay9zPqCMOnWp/V6ofbYTbLei6Mpgf0gRJPQvQFSYBqmfRXLQ7qD9M1DAy/Zuz23FSbOTzdACjJbfcWnuVQL3C+0zC/xtFGCSdjzg6Pj3/2UDnRuYOxGx0edPLiJCpxJZJuqYUhhD6n/29obfEjDzRC+dvS1tlfh5IAEV6J/q1kbpdvCOxkWRBvcEGlFdHyiKEJNoNPxzZCkWLWhu3R2y8LjkUthonkD25ARp1PHr32bVCz21Ao/PqQC2/6TdrcO8balkyqma837Uqpm8AYpl2vnCVHDi4a1N1Gr77nybCSBDq9SOCOXf6tkxIL/NgXSvnR7ZylKTz8uTMEIX6z4td34FmmcWKsxUFCpZ5T
 ER6wuyue
 n82C3VoV1TBf37gMjAkvBb2UNOo2gVUylCMb20QyoHVA3sL5+Zr8BV7mLwQXLdGKxMGHrUDcuKvOB5FskIeylAgya6Ap8k1jOwYSNhiAOKYQrCM2SiKYm//2D1pEc1Y8x70y+RhA9MUrHBI7r/2dKSRb2HhYookVuJdBKX2I/Mq7kcc7ohHkEt9g2YGYTL4ylTTMdBInNXqzvwnLj8oUR23B7Q/qXJbYMlR+toeV5GUSzBIc3nj/uaAeFEAJDfXRmlFSdx8/zCoNXoHfFMLgKhytuJKL7zkXy5l38hggOoCOqBWJKsoqdQrda9s387owjVH1kn3dGfFMX3kg9zSu1jvB50IPN3hlZTGkHF7uHW/dXPluJ5Q9WHyLMwQMGCU1bl7fvdehEEznK5G/uZJaZe8k408CS+3X7m3Oo2+wiQrjlXBzLeZVZJsyfs8XDN7VMzqqMNu9G8xCRhQtZKH7nxqnONmvG/isZFANhpMQHFYaCdMW33BXRNAIvd5bo7oPG+tYt8bjF3eTIiOZc2qZYyPQEgWLJwY2OmBM5KRGY2AHeaNjCOnL3RALBGeftK3n1oloDKR/++F2l1PSm4ky2RiLf/VaKvIzeRnXphtKiPQPpKBpvgrOuaioc2Nc8FRi5aKLGPvAdhezeiGORI6lKTreP3dToDXGyJePD2GQTQhHXMqiHEjhmkGmGDANCATyYRZCSrqp310TI2eskLJP2gKDtYPVZDpvcE5tgOHeaKgEko2fmp0yyV7Gar50fLYA+G3NHkC7MAZRO7UmP/vjepoBURePB8z2sI6REjvrV9I33Oh7b3JGaq61X9RKBI8j4sjQH8vvKMYeyJxWuNOacO8JNbPeGEKzC+6/3QtSQlL09u9Tb7VQWOk0GcQ0aKoGWlZx0zNoOz0ImbqOtdGXzcmXlCcSo8jRIQqafl+0eRMsQHb70tcwDsQCkQxhXsG1h9L926wmNU+HBcn7HcIx03X6m20jj
 95Tp6U3t
 OOEWgqz2DA0rQywEwHWPoNXnsDQN4X5Mmsg5BC/TjHjzkJHi9qZpAHQgI/rINeW6zddyte2cqOYxizOt4uzKBab8SFov7cxxLNtDqOCpBq3XzeiagnUQjfk4Ns1+D0q0LXsI5U2jEK2fMDC/z7zUs3OMnDMt8qNGK6LE0i5J0N++c9Yse+m0Z36KmJvfAt5eQgJsQ3yINUWwZQpLMonIUKXAyYUAlWGhgieVbAXvtkmUrJMFe3QNpfxf3lVtez1qk08iR1IA+v2ccD9odi3dX06tTsEcIwLEggqsrJxdv48+b7ZL558B1ZBwZzIVTvhEwaqDK2/o8B7GZwCDqGNwvejZHk/dwDsFgluKVWhXqf8gIRrQtWaK9QjXIEyFTaEwCWoJUlX0FthG4iD/WBFFZoWXCXtAilvTZZ15h1RYrBRQniXulqXL9uCZrgk3zpz3CqhkRF6lKTSzkDhxD0f14O1TOhM83mohtvKoaj4mqn/4UsWHK/2By55ik6zKJAmkCnV8L4jRw8bTvUUaD8CKVFYVN15wsbQrVfo77BTev64797MREf6bh6+3DqY8ka+2ipnWIeSzaZLIpydUA8NqA1dglkMN2ppWN4bVYQND323hNtKwrTMoJvu8mKTdHkLTSTIqpoZ+/jIaLQF+ltv/M/FP4gLFgPxmBP6eJWVfZkZLwBUYn7lgNdjZy2foXPoFsMPupTskUHpq3XCwRG2ag0SQldw66Uz7AbeTAlhI+EKjhnEIi6VTMLTBnUKoe/4Ty8xKzu/631d0cRlQr9CmNNGV5v7a0CW24n4tKyu6cwJ0HC6hEr1aWHammKOjVeGqzC0f6stZNzvG3LaY2qCif2mxPTTHv8LqZMBROTYaNJfffm6VxV6aSiXmZmsIXOKZyCJzPW8cB8cqTWoMxXDlJNC+HUBDtd+DHXmHuNJhqnuoA0fFMfHMvINwVvrZUXKdwgvByrU+A0itDsbJxmcipM+CjiMvR
 swtqes8V
 iwPqJqDyI6O5fyo6Yi4npmeWKMi35CTR6R7fMscEQDNL7HhK3VCu7RnTrKIb1/z+3VD15i7+D4384/ruqXAgZ28h5+Tcvcdjoge5C18RNXwcEHnum/Z6aNLUuzv8Lb/qo8z6y+h2uM74MP5kah/Vc8h6+Xs4U6bPMeb40rH9oYCg/vRiggsWhx4B0ZF+ku3LQAohkz3YHP0PVAiK6RgLUN9YVBjorrptGUKM2TirCweSzk93XdqtyyZzpvyQ+xoSycQ2bgNUW418XWnbUbEp1Ckb6LIj+mbU095q8hiapmJltudPGBeVaodQS9Wii7s+aSL1af7EPA/Afr+tscv209
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
 mm/internal.h                              |  79 +++++----
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
 mm/vma.c                                   | 254 +++++++++++++++++++--------
 mm/vma.h                                   |  30 +++-
 mm/vma_internal.h                          |   1 -
 mm/vmscan.c                                |   9 +-
 security/selinux/selinuxfs.c               |  11 +-
 sound/core/pcm_native.c                    |  38 ++---
 tools/testing/vma/include/dup.h            |  66 +++++--
 tools/testing/vma/include/stubs.h          |   2 +-
 tools/testing/vma/tests/merge.c            |  10 +-
 64 files changed, 1153 insertions(+), 582 deletions(-)
---
base-commit: 6b41451631cabf9ea3b384c2a099088e1598f963
change-id: 20260721-b4-mmap-prepare-vma-flag-sanify-2100425df5aa

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


