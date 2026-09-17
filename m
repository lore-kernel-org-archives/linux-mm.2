Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8865C982D9
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0A116B00CB; Thu, 17 Sep 2026 12:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1C26B00CC; Thu, 17 Sep 2026 12:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB736B00CD; Thu, 17 Sep 2026 12:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A1DBE6B00CB
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:43:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F149E1A03F7
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:43:33 +0000 (UTC)
X-FDA: 85223825106.22.AFE7290
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 250DA1A0009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:43:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U3VCmtam;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789663412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbe5l45SH4yx4tHTzTY7+dgPoXtouc+iallQdj0tZTM=;
	b=v9VzHlzQCNhGH4BprD1l2dc+HWZhRM8IijrxbvgoEAL+92aJ3FgDVwOFnDMNhf7PBHQe8g
	AULOR+vA3z/TOB4vqkz5dC6v9mHaEZUQzFKXq1yPfAHgaq/ADYZrUvWhKWdgEIgFNJOGxp
	4uimcSUcdgyWjEy8Rt/kvxtIZlFzxII=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789663412;
	b=wohWI+StuCpqhjbu1rZ4OBLFeWUatqj3OUpSxjqa+02s3BNppIix9J/3S/gVHxMa5ltWrE
	1ZQtnXE+wf5RbJVH1HmwXGSC4PxP5awJw9qrvji6hTAfXnTRMLEOScvp/g0AtCKDJ7ihGA
	+GTDgRu9hZCTuT5UCE2xT0oHJssuAEo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U3VCmtam;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4195240C25;
	Thu, 17 Sep 2026 16:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105461F000FF;
	Thu, 17 Sep 2026 16:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663411;
	bh=pbe5l45SH4yx4tHTzTY7+dgPoXtouc+iallQdj0tZTM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=U3VCmtamsFZkAgO0QQp0B8Dds6bhn6Xl8VtQ3gAbfSk1DNVXLCJQTDAbPuGlRZSUh
	 7yqpqgv9jlRUltg2fRM/WuMoVC5li2aqV4W0sThfJFNHqKLA1UFjG8WjR5M82PpMC9
	 +nB6MzvYhPBSGwYvNXbh3ZbABwebZArPwvuGGJcg0/z/v+aWelMoyvQ7mEipMyya7f
	 MCJU4d8pMhJWq1/5iiedVEnx2LZ8lG244dtSHttXpfGn/6yyJAzddzjz7f83DXHka4
	 tTzX/L9mPofs45bYAVH+C2P6GDU1LY21fbwKfxmnBaQ05UE2mA2PdjvAXvUgANHmgT
	 qi3cjLkRQFK9g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:49 +0100
Subject: [PATCH v3 40/40] mm/vma: introduce and use vma[_flags]_can_gup()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-40-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6501; i=ljs@kernel.org;
 h=from:subject:message-id; bh=FUHFpGdL5KZVRVlCuvz5idqKgH6ZuHhZHuvnhxOArGo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB8N6G3hqV537OvayJ1O+u1V977sddvVJvnh5ymNY
 438WUo6HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIxDCGf+pJbLxPJRQLqx9k
 VRiK6Wznyd83Iavp9Cen9VXfUwXDLjMyTCz3M02xOsQ6/9lyJonHrud/Ol5PZfRjtf37uT/5lYE
 VIwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 250DA1A0009
X-Stat-Signature: 567jdm8aue6uhd84ecbbkoupfuzje9xd
X-Rspam-User: 
X-HE-Tag: 1789663411-515464
X-HE-Meta: U2FsdGVkX183Bp3TpYG9BwEJ3NSJu0Ft5RgE4pwGT80lJTMQNh3GZ1D8pP2Euv2ycXKPWvAxILL6DDc1zlpKAfiNBCoepQuQsbCe1l0myb6yPLFxb6MpqSSIuXh04fT11P71ryYy6zBySsH8fIQYxJQHTsho3e+lh/g/IqlwQyR/kA7oQ0OaJbaEiK+Xgglq7MytfyWMzaiUDI2IhoLJ6MEDYTzTZSo/Ra2vrbdOXVjLlneQ4lUrawaQU0nyvp2qE+STZMjl5rlsRr6yU2U8nYuac2iW8pbTAlmUGFrq2DMPpF41Ow1ieMMdR9PqKGDU1oWfXKz3kRf+tTfQfKIlqYPfZj3lqtadfOwLX35RSUyzIeDrYOlFman0t1OTzfE/3Ayw+H9T3WAbwQUKFzJop4/MvMmDEw4XyuLusSmZ2vwnUFaHXUKht8jbpZi87iluaD/nJToyKbzm6U0OWp7bgY7VtrVk1iECx5depC4Slob626icWEOGUJUfPVXNfTiWF+2paLS9jgCf/MmAKvp80k9Qq0NkTItOsjuuWaJL8Tru5llLtPYLjTV6T+8wyc4tMFeDXc/VvDvE5wjpN/DYeOP9z1jpqZmBwPzxWQI5bOdA0B06UyNNEcZy/N+PA390Mgpx2kOPQDw3d4tmzdHc2eiZr0nzAdU3QWaqSZXzN5LUci/X//rO7x2CHyBpT+6rnH5yNitVeRJCc+bveg4wuD5lH3T3EhQavp1Oll0/15EXg0AqsIaj89sVmxPoTAJShP04FEESkms0BL+wr/jaACB41KqOj406k9IMcQ0JiuSlTUAr1NFDp+3cinPz9bWB2al0GLmoh0MOGp4tiuJigm33vniC2zhAdKRE+tAf7+yKcug1GQQErHpx2kgMRu8UhmOmzbsL6ODyCAtJCQ+yta803ZNvSDVi3Bdpb7RRHiJh2hc/NVhni6kdonaXzWOmQD7TkI4Yb84H3YD5nKt
 nJiyCxBO
 4vbwaJ6+i55j6/w2aYfcRYbakbljJOtE/w6iM7gtSgw/Rk6amT6qqZSABZbzYvj/LudKjYshQDTrz0qxOtnKMi7OmGMPHOiMvoVQam1UHMI+CeTyG2FibLKVX5FnWBzumJvro6mIE3AtlW1nHTZGn6WsAFZA3PVFtSuQjQhZ+s0ZvroR/cTlilbTk4DlX80JuqDLZMqK5c+oZn9XKGMEWni3MftLCjOsyUJII1GfyKiovraEmqIKK5jTUgvO9iIelAQZ95pVSJz/xzQAqsagm0TUYvmHy5tDT5KFt6R4WEYR1uDQfiTvtAg/SBYmyBgTe9NdZM7D9iu0Tuo+7v7zRMss8Q1/NhJNeKMndJfcxSVEqbaKx+JLdMS9/nYiUalWo/09Uk2YAOEZG0W9s5nG6nq51NObOBh1G9i3nGB8ngDRBSUJErZl6ylgTQEr5f1wvPXSci4et9V7rGni7dYDyuriEXqr60fKpgFbrOEHuQeYAItyFQf91VLlt2fjOt9UWVdej9MNn/txh9Ocin6r9jctdruetx+C5HF12DjQYxLcwrs4pg0lxBL6A+lWK67omMrks6gPEykuCV5glwQN8+zq3X4bglEe2m5nSDOAd7LgGlK1BVWXZ17h+YSFL3OhJinPLNenkbfkMMozbmWzxNzo1uKJdmyhKb8Ed78R5LsQHVIYzfTpOv9OF5bjMeMWd4YS38vc1PVEUWq/iGzJw34ip6ZrEwssZwU4Fz1catpPROAJ9uDhBmDgkvEvDu/9QR28cE0WdUlFmhjaLhrVKIOt1pIOCZgLCM17NtCUGHqQIRxWMJlDuEssrCs4qTbbsva+sqjOyrjg5YRHo2aWxotBUPeiyUm5nAcuxGWJSDJHc5Yx8yspiyuI99f8EX37RKi0relriGNOu7id3nOLZ1OQW5lgtRPIzCePu0jiGEcNCT2Xd4FbVIDLXS3E7HW5S+uJAZJ4PiYaiuvgvX9jjQazMsMDS
 9dr0QldR
 PTvkoMRjv0E3HmKcp3nVyy8/N4jA7a5P8TrKpPkVvuVLom4uAMRimTyqDES+UJlMi0EM51IpoOcNCppJL4wf4BYuHbf/SYbQhVmWZ/L/HIAb17g6UWiTdMfWaq+S37mkaur528kH9Emm6X3LbyDAV3Dlqfo6EW3uh8hqyG/Xt5ejTUAk+c/Q0wMtkpuMF0WDyaR76RqztrUcrmSIQ6tuwxnIQpMkWNRReSnlNboWzcTmsFB6bExRJY/WcrHs9v/yToExnkj4kjDOADpQ5quxjMKV06V5ZmJsUrvfuK1swX/xrsIYDMJ9L5BHKQt3zVwaFbOEswOVDKv2mtYR6vYT97jH8mdROiow9k/SHa5VifpkHTB6ZecZx3tknQ0Uc6vvXGIe32Rj66KG9jEXvKsSSEzhE4YjktvSJO2Pj7KGyW3sgvaqNSXmuVwMMhJXK4adxrd5Gn2mteGSuckKOWvi+EKtPUlZItRYv7qvGbcg5OA4b8r0+jYgyGqm99jhKb3pK5A+FvXHeSUoBgIn4yd/iiSqExuF6lj0KOtJTlYJg6t366koRBnFRvSsk2An/hkB8eRutCLyiccv4Q31ZEGb1IHLgoJayVllo9z/XO3bV2Nnk7I1y2sABHuhr6+rPrESzYylxtAmXMHJxosuI5f4ggL4+2q9N40hoKkzgo7/HURV01CzZlXxFoA3Td0lGP+lqR14q2kQMqfnkBe6ZsfUqS3oB/G+ZLFtvGBGMtXHnlsz//xeLiqmXJX+ZCM5KSk5WLmHYUMuzsmwIfzAdDqsUTTiSfyfWGPeVeb/UG4YBYQ5KRgRhUijQdzv5E0aeW2iroLWY6pcMmE7SFMQUEDll5tXAl0YxaDyaeFLfLZkmYDDMq/7Zz7N1j/aYUUkbhYan4aBKzfMjgv7rVwDEgzwcuxgjwD7QL6LXD5+2wXcndHze9+Eb0EUUz5MC1n85i8e/UWP4II7fNY6HpI4uk25Dg7RluLKV
 YMh/W1lr
 a2nLDl+ixa6pQHqYPQa42pcV/3Hs/m+BRGdJj1AgWZ7rlDhudTUsZWJDaoSFet8VUEKMYlWsq5u1prPtYocsLqJtyiUPreMBVq8eEWuc4G+8ejcNrOJtaD1daeUvaKJKqLNrLEQB6M4fXBNRQUBQncPtvd46Gjhhbu+fJeqaHdQZt7OndOWVcdmYpE+BPSfsvGkiYjVPUmuoYiwIx+/xh4MWTXB/RHrdG7cUlXTwaTmOsnARPXq7DS4FUf8aBZ0PEBi8qlmPR9M0S7NKxttBVs7lupgyRx2XR6/A4uJF7QI10huMmxMGVBZbNv3I6f9745TpxSXqrCRqYygl7fo8u0XSdus90kVD9m+h13JRRQ+FffWt6JzYxtoeF4v1frKlYByhCO5EBvpEaDWE3btIiq6g4jRmeZdkME4et4jiZcV2TJmZUYI4j5nKSj6aOQlMHF0MGzcV4KFPwV2vz///58juzPgAIwtpnePvZU1jncjpM347i06E/M6gFJdsTDu46pz/yui4quJSyD7OZ9p3LcUmkBn2FK3AuT7O8bWTP5fE+KxHbT5QEHF5jDT6/cqoyEo38dUXOynVV1QskGJMIOLUj65A5iqz1auSq5WskjyxBp1uMZQB9EkHWtb1SCI9u9dScX/9OstBfDoG6W9wOcgIbYHKdMw5QKjOoUmCs9JsJQGDicEDhsNlqbrmtooBEFLSlXDSS5S2f9B+pKlcZI/m4ikPzEqR/vQIkmCgIpMwEXW/tJGuULn8Sf6b64iRRt1ca/ToTKPDmOrm+UisGZnfDJ5FwvG4BmJqg+P3GCO4kUXkxfAbipoxKRDXHu28BmnMl9jcvT3tuFeespjP8BtQafIVyEJEJffLUFviMughJhNSUzARb1G78Pze6pS1cePpIOaygM7LJPbpj+4axMXQ2XovYV3cJtguVdTMOjMPOJZrH203R8pyYCx1VZx3Rz4OijgQzsX1UkKyHWaHfD851lTcY
 MIptpsdI
 6PA/JdDfA8jNGSWBNbKsQnSQ8xjS0zZGB0e2jBHiQc0x4Si1ta/T7fLe9Nn7v/qaB9q8d+IBlIr84skzHuR3wBrJfx1Ywm490RH2NpA4S/5hqIscWslZzFxcFsRfFxT4mgenFhcx0TR+L+zeyAj/TuYYBLYm3CSuYe/GIqYdoCYACCFkWdC7RI/txJ3rSpZgtEwO/M6unCrc4I8EVsbzQhjRm/zhccGnjdCXL/zut3JG+5wMmjFlQ0rR7l5LT1y0IDJ2oPZWzRCtaDV64WhbXhu/iWjOhkmdlnEX4vh7qHfR9M2Ute/5KAh/+Qu+IhHf7sibYr1e8KCgU08UOTCzUv4espPCCNOy7tjzE9U6kBrEkITov01KNFSoWaHTOBQ9WRUxHIi50+sa/vcT2FZQwIUKndtnL94SW29WIb6KEMeKE/R9dedmR0mJBJ4YOpkAm7fIFN3lZhBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GUP cannot be used for VMAs which set VMA_IO_BIT - because memory-mapped
I/O must not be accessed on the user's behalf - or VMA_PFNMAP_BIT - because
PFN maps have no folios which the kernel is permitted to access.

Rather than keeping these checks open-coded, abstract them to
vma_flags_can_gup() and its VMA wrapper vma_can_gup().

A number of other places make the same check to decide whether a mapping
can be populated or accessed as GUP would, so update those too.

While here, drop a reference to 'special' and replace a use of the
deprecated VMA flags API in vma_dump_size().

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/coredump.c      |  4 ++--
 include/linux/mm.h | 29 +++++++++++++++++++++++++++++
 mm/gup.c           |  7 +++----
 mm/hmm.c           |  3 +--
 mm/memory.c        | 14 ++++++++------
 mm/mempolicy.c     |  3 ++-
 6 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index fb21fb6703dd..9f729c594c47 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1616,8 +1616,8 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 		return 0;
 	}
 
-	/* Do not dump I/O mapped devices or special mappings */
-	if (vma->vm_flags & VM_IO)
+	/* Do not dump memory-mapped I/O, which may have side effects on read. */
+	if (vma_test(vma, VMA_IO_BIT))
 		return 0;
 
 	/* By default, dump shared memory if mapped from an anonymous file. */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5860a3b4dba9..1249e04d7b98 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1777,6 +1777,35 @@ static inline bool vma_is_persistent(const struct vm_area_struct *vma)
 	return vma_flags_is_persistent(&vma->flags);
 }
 
+/**
+ * vma_flags_can_gup() - Do the specified VMA flags permit GUP to access the
+ * mapping's pages?
+ * @flags: The VMA flags to test.
+ *
+ * GUP cannot obtain pages from a PFN map (VMA_PFNMAP_BIT), which may have no
+ * struct pages behind it, and must not provide access to memory-mapped I/O
+ * (VMA_IO_BIT).
+ *
+ * Returns: true if GUP may access pages from the mapping, otherwise false.
+ */
+static inline bool vma_flags_can_gup(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any(flags, VMA_IO_BIT, VMA_PFNMAP_BIT);
+}
+
+/**
+ * vma_can_gup() - May GUP obtain pages from @vma?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_can_gup() for details.
+ *
+ * Returns: true if GUP may access pages from the mapping, otherwise false.
+ */
+static inline bool vma_can_gup(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_gup(&vma->flags);
+}
+
 /**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/gup.c b/mm/gup.c
index f166acf794e3..8e9ef5ee7498 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1204,7 +1204,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 	int foreign = (gup_flags & FOLL_REMOTE);
 	bool vma_anon = vma_is_anonymous(vma);
 
-	if (vm_flags & (VM_IO | VM_PFNMAP))
+	if (!vma_can_gup(vma))
 		return -EFAULT;
 
 	if ((gup_flags & FOLL_ANON) && !vma_anon)
@@ -1955,7 +1955,7 @@ int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 		 * range with the first VMA. Also, skip undesirable VMA types.
 		 */
 		nend = min(end, vma->vm_end);
-		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+		if (!vma_can_gup(vma))
 			continue;
 		if (nstart < vma->vm_start)
 			nstart = vma->vm_start;
@@ -2017,8 +2017,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 			break;
 
 		/* protect what we can, including chardevs */
-		if ((vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
-		    !(vm_flags & vma->vm_flags))
+		if (!vma_can_gup(vma) || !(vm_flags & vma->vm_flags))
 			break;
 
 		if (pages) {
diff --git a/mm/hmm.c b/mm/hmm.c
index 2f1e98c6b644..e9569b82a1f0 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -595,8 +595,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
-	    vma->vm_flags & VM_READ)
+	if (vma_can_gup(vma) && vma_test(vma, VMA_READ_BIT))
 		return 0;
 
 	/*
diff --git a/mm/memory.c b/mm/memory.c
index 6c011979401a..338fce99e711 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2417,11 +2417,11 @@ static bool vm_mixed_zeropage_allowed(struct vm_area_struct *vma)
 	 * be problematic as soon as the zeropage gets replaced by a different
 	 * page due to vma->vm_ops->pfn_mkwrite, because what's mapped would
 	 * now differ to what GUP looked up. FSDAX is incompatible to
-	 * FOLL_LONGTERM and VM_IO is incompatible to GUP completely (see
-	 * check_vma_flags).
+	 * FOLL_LONGTERM and memory-mapped I/O is incompatible to GUP completely
+	 * (see vma_can_gup()).
 	 */
 	return vma->vm_ops && vma->vm_ops->pfn_mkwrite &&
-	       (vma_is_fsdax(vma) || vma->vm_flags & VM_IO);
+	       (vma_is_fsdax(vma) || vma_test(vma, VMA_IO_BIT));
 }
 
 static int validate_page_before_insert(struct vm_area_struct *vma,
@@ -7116,7 +7116,8 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
 		goto out;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+	/* Only mappings GUP cannot handle are followed here. */
+	if (vma_can_gup(vma))
 		goto out;
 retry:
 	pgdp = pgd_offset(mm, address);
@@ -7316,8 +7317,9 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 			}
 
 			/*
-			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
-			 * we can access using slightly different code.
+			 * GUP failed, perhaps because this is a mapping it
+			 * cannot handle (see vma_can_gup()) - such mappings may
+			 * provide access via vm_ops->access() instead.
 			 */
 			bytes = 0;
 #ifdef CONFIG_HAVE_IOREMAP_PROT
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 044ffb4f4128..2fd759e348ca 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2013,7 +2013,8 @@ SYSCALL_DEFINE5(get_mempolicy, int __user *, policy,
 
 bool vma_migratable(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+	/* Pages which GUP cannot obtain cannot be migrated either. */
+	if (!vma_can_gup(vma))
 		return false;
 
 	/*

-- 
2.55.0


