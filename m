Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 238D2C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F8866B00A2; Thu, 17 Sep 2026 12:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0B66B00A3; Thu, 17 Sep 2026 12:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C03A6B00A4; Thu, 17 Sep 2026 12:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00D256B00A2
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:24:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98A221A03B6
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:24:04 +0000 (UTC)
X-FDA: 85223776008.15.3569F75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A25CDC000D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:24:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QWkBRqZL;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RLuxQ43cC1lLz4lxQslG77OEAHKejqlxyeMy3HZv9pA=;
	b=GirHCr0NE5sWbmFNDczuRU9ZEVw2iRuSPw5D5HZ9QW+JDBr5Znmrxxr1uWLIyZc60Y0VIS
	vQeYypzrOYp9gd5GWuUvq5iCt9Ku+ct7NpTr5YpYYn6deJx5yCeWUhD8gY7nnKTWr8RyDb
	a4vrQT/xEI3D3otTrMJhB4g/3PRyp8M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662242;
	b=fhi/YhN7GZzHD5M+fJOboJgigwN0Vh8hnsbHcc+hwDvP025wo5xof5obWnqB8n7KC4OMzM
	A0jtLf2NyRyWBLSKJ3SBGX9XOKPWE1CXu1vuEiymZSZ3O4Wfz9wpiQuAZCb0anr1V2/e/n
	3uro9BJwpXzYdaqtlKmiHGDgB9eHR14=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QWkBRqZL;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C1974161F;
	Thu, 17 Sep 2026 16:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C491F00893;
	Thu, 17 Sep 2026 16:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662241;
	bh=RLuxQ43cC1lLz4lxQslG77OEAHKejqlxyeMy3HZv9pA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QWkBRqZLCDNxOzD4bIoFLP6D591QCq0iBOm36/NiXTWdshlgjNwPfC2G3rAcH/Hp2
	 95W1Lz510usTswgM8JeIJl2rLqPVhR6krFVIK0DmKZo3x31YNW+Qx4QWBqTvnkY8r0
	 hsT5OU2i/NQTAAr8G7ViMBrzZ4kKUKI4NVr5+JOM7oVllH3UsE9EdOkYD9cq7a9aHe
	 fdXjKWh8vXNmRbEkoPi4X4JucUCcqOeFk5yI+H/Ow2kApn+D0xIECgSozkBztL3jIs
	 FbRx+2bmiYA8JoaZqRiiayTobqBrxEFcMh//EzCGCtoSKabDHc+OT8N03U13EE5eZu
	 WvnejAGNThGTQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:11 +0100
Subject: [PATCH v3 02/40] mm/vma: predicate setting mmap_prepare VMA fields
 on new vma alloc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1712; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Oc6a87+f8ib3EMGGxGSi+EZ7/9tYFaGdj2ExhgkqcQY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCO/78/Jqbd8+paP6cTt/5Z5+U2oglfPFdt+545/uO
 Sw4xsdzo6OUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATWXaTkaFB3yA7fdtVsSlL
 Hxos5Zlncfhbg0lew/ZbrwqeRfrfPhbCyLAk6WT6622K9b4/I/g2603cejZIW/5HIC+b8fWAszZ
 5EnwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A25CDC000D
X-Stat-Signature: sxg3n9rskeatqxmso4fqesussg6ofa9b
X-Rspam-User: 
X-HE-Tag: 1789662242-525777
X-HE-Meta: U2FsdGVkX1+4uFWI4xmmv7JPICP2T8v0CrohWCa4SdMTgK1dwJNDFlFnbwAyAbUUa2rFR2Ubfo2mETpt1/s7ZVqaJOhjSINplmqATQnAyTnyCSN74VTomy55jd6y3nWFfmgzS/eC2DmWWa4v1s9vVlLKznz8QpXZQShb7smGpVST+cPWYInvXMciJq8FgPHA2HJenASsgVpvkP19wNr559Tst9UrO9+/s7L30Z19jpxZo7qwswHIQ8Lhag9vOAzg4OsoUZIjrizIZLlUczHlZ9XbfQsQtRS0FdH1rEiJw5VK3G6tZHQNew4qImZV4csrxy11bRg6adeBTJQu6ZnePSuDRTTnSwmJWLQXLUDRW0r+x3v3JDaKeA4UUcuCtSRvJ2O0DZYvQsCDfGuQRODsY+J/7A4xqrJW2PBQnUB/HnJzMixkYHWuTvFGTsSmRli7k361WKvgnBiX8brOOVjVj17DmiW8GfHbPkNRqJ+kSyXc/pu3wkNXfc/2XQDUxUzsENr5N4dz5hl16T9fXSYj2nWimhrYP7UAnotDCKddy8G24w45JBdKfhBHHTH+RZGuSAy9GV9BZveeh24STXWrz9xReM+iaO+MdlE9mkkJLbIui8oYf8ozAS7e+/9TJQYktBl31YOjWTJ2vRyCKeTjRtiVLFOnd5T2J1LnI6X1WZa+GSlkbo0OMvWL6h+vaH+TqGhFDpW6P/yv7h7SkbavpfSOEwmAusF3DkqkLlu+t3txYa8Fq0iSzd8SAhrTBvXkSviWGopuotYG+atn4SooUlDgfEVLuTKdXNxVvxrodAXqSdroCJhcuA6FFD9fapV0kXN7gTic8CwGaG64D3ydh2tJFbPCzRzdl10rz52G9HzIhAOlU7VbRDJ+jHHM/lapzkUszlXjZ/bWCFxByDmNgW/60zG9CrabIuuldly1zxEi9H2FSFNF4zyAoeqgfZJebLXaP3Gq2qmg364UUBc
 B86aokCL
 HsMniHBjkRwcwQ70sy+orxA7ZrRw4u2ZpaNcEQ5Vdrf8bY4tEla79e9/hrkhyaVcYSiXg8Con+Hvt6KGqIjn3E+6l3xPI8KMjgV9mt62nmAz+gjGMsLrdYGMO6V3JGVKMrIEe0NXbR8+XUOppQa7eSX2S0Jv0GQ2To6oxerMMM6vtNfoUelZsBo+dmeyk9S72d02tsPu8ygNWL0jD1OyB0sXiiSfU+UBGZgukfgTPJeRdhdNsk6FHoP8OouBdrCh3orNyCmeJqRkd8iDDVd6P74ktKj3mUvSKJFfKHBw4hzWoCKJMhStoFgOWD0GnQ3Tz7OBQo6IQvFtQ/TQV61DFofwQsy0eO3wngP7Q+5W5R9K1xbasbn8fjRTudm2xnx3cGjT2tgFjxM9Nr9y3dDs+3EzG7QMcl2CKQmgcQ2n6L/hkFXa1KKDRH8/G8ZDIBXmR824foJMeuGBWZgygBAjsZmsPRHohgWtZ6ypn3i0R7+fO6EXEggJcnLPbKzQeapd/5Y/vpQBk1d63fopSS43Zs/okikEf71lLr+7FxK/sM/Gvh6UiUuEX5HvKNj3QMNHlEnEbidJQA5+nkxXx+v6048feobFRzZve4eeeqh/caJQk3E2SCPWW5/ZD4gkYnxnD+rU3g4/jRYf+IWRMyfP83SrbW4yasv+yowlnoo728AsYoHEu61xSQNkR7JX4XfbBSzLQpB5CbEeY/O9ecDqHKoD4T/vwvKdCGt/S7lfB8jr6vugmHDZo7cEoKb5u179kXlspPx2U3RMmWflmkxf0aD96uQDiyw2sntFaMbQA56Slv78WAfN8PB9cEVRDQZPbJJ7cuDPlvigvUWXob8n8N0JktdaisilRDkwBP3HlB8cFfsu2oLelv4wyug06qiwKKDyvhnV2ZswBBzuReMSc4r+TPLRsaTTX9by9OougTeQZw8Kk/q7RNp9vL8sm+dBA4Am3TEJQWVRyPavSSJ0yOz5ir797
 yQEj2Njj
 EKI7SRRjgTGcSyRYSqBDFMlBDc6XnCxDBK2EuOAGwEJ6k/LseOjSUhn6zobBpBl7rWdd+x+iq1hq7r+Exn97WCRyat04ht9NoZBE1Bt1xaeEchqrwqGUucf1l1bywKd+WXB9t3wk5xBVKAKDiM98+U7qjDG9iD/ZDHBE/QYEIW/vyYgjZZBtqeUNgL3EocwxSdLVFgpk7dU5z4K/5tBUwFYYuWOex4h66i/Aq1bqygQF5UeDJlUkNNWdEaliXiUEcs8Izs8eEndZ0UJn5VixbHU/yaAd6QbwgedRF69hOqCwAEzYjRjpEUatw9txBDt1FIyCttlBJJuZbBLtBoqZOHM5KBq26InnHUgMJ5CG5caAZhv3Y5XbS+YTLJ4kbwszdXk5D9qCzxS2Fnx3IyVGco2FYr16CU6du632TO3uRL5JZ/FA7BtxL+8ZtjaKLeaBTCfsxn8YV9q58go48xArr/e+4RCF2tW+5W6ROS1soamhvKMa5GhXFVjH8BRytSrKGFoKekGh+xTVEmwfw0xUtX66GSA9iGsNpNvr1WXOjQk/gXf+nGGyevSZwGuIQiNQQHglbdZfwHfaf6geX+e7dsTAfOC9CoaiNaP5+N/EAy2h3CXjB/cBDvWGrwn4qoAHXS4drET7/6YELssBzCNx5lmgH+GYoPttSckrLrG4yVkAOIhp+I/BxhQemEX5kjSTBzHRd6cllLAHCq4AwozbDbnn7K/akAxTbGlE6jJUSA6W5TBuC+GYf4SoZkOHKRV9LrpLvMB3wTFxIVsNk3kpKDPrd5Wv4QBc4wfNGsl945a0sTUZmtLS4STQxA3svNlw8mxDQJj5rgHWLry8V1+Pa5ipGUyHir6zfgHdvaACARRtr/EI1mPbi4KUISAMHoJwHAxNDiV4V5CMxTj7ywwlwF9Zr/Er90vp8BlFNfoOaseHAm/pI51soBa4+7NwmKg1yZ83lrbwb0U3iNz+WXYvwfXq8LNiu
 rK9cglVn
 Bz4QqCky98g9TWYP0HIonkY7EH6tAxx89i4EDtEf99y6NYG+3zSohLqAD/F6/wtkW6L3v2iJwD8IrZNJnMRf9gqRJ7XXy+F4jWVsKknYB2M6/GpdM9eGriAW38qJ3ywksqchw2vH7Rc3/lbwUesZxvDsHAPIybxhf85Z2OAWKnI6zTrn+JpCyMnPIvi3NsLCLh3htsQ9BmylxqEHMwbb9pwETgdpVrRP0KQp+Nx7KHRUqXRZdZzJqewsdPvVp4SR9/EQTw8RO/gbIvovlEDXaXL32289Vc9NZZu0bR4tUoW7lupKGovj6pzK/YcWUVZB10OqroGvHVuIzmNEvD30WPzXV5WUiYHNRDjOfiJa3lahJbhyB0aF6M4yewp6uCR5TpyrU5yRtccb11aH4cNX95RbmA+/Df93fSKLzf04HO7BctvrQehxCgpgPJXaQ/3JM0zoQoLsffheeSRHiy23Qq1LbRIpRL3vTCYC8/d+2dyhLSiWnnPwqP8Y2gPN137aq7xHdM1jJ4qZ8GA0EEddloUWAP/iu2wVRa05sFRhUmczhRrtJlbZb/rLSGlM4bLABePxeMNJVHFNPuo+UmBU6sdXNdsRdLNvSRZoUYtomZ4VOOKeqg2cECvNuILZxTbgpGYRHztjUr8oQkLIpGItn5NLSWOCdCG9703U6RlkAuLuVZpNiljWfroScFgMvs39ZVWS+RJFnHGuRmrZ7+kmDGLZUvj313rVzwxVBppBkX9om6x1Z1px/ybsfWvzIQhdwpgpJJ+e07d2FRqQ3hyw13bJurhfxCEf42g9ioTp/1Bk9dqZJSYm9OLeyBJDVu9m8DJz5Zd8Qkv1FyrJYLj0UjJLcelzGgoN4TKTFu3drNh0l+4VLmFflslyLwXpUI3ti/+i5X2Jqrn6919bh4i2kTyZfUnxNbtQa7jWNocPGm3T0E8M1UcTT5f+0f90Pzs/GTAh1Zg4JcSLIlVXPzplU1cO7DUS/
 ibfhCrBD
 tPjebDxKfi8H66qcBIb+QyJKD9igR/uE7j/o+fPyapf9u+M+Y/H+R9fqhi2zNRCU+P9beMQ44tE99R4mZ1icaHokYLsHwX4XVRw+X77QAITjFv6OFAUu0z+sffqsfbcfMlnw0SQmQWOS7fq7K4cs2aixBH43hB0HegkYdud0tk34TEca82uvb6Kuz4rzFvJGEg5Nm4ZguwbhcLWPk0maUZyd5reT+6ViKOHALrH9tIMPoePREfq5E8jVkF7P0ChamgEIz8sWF47Y68MNFYVujY1ZWXWCtNOfHO8PuM5fucE24qM4aE8GAbCXwdcdUryjpKuviRPHqGu2UG9ZoSsR3nCwUDdqhXWFrLfV1TtU2jsfgyXlhx//pswLzVhWLNbuAgFx8M1peGpp/PhjRuMflhtdISku7XUn5ihedVrnDoySFBUVVF/5Bxbqajwv9lRqKTySH4ps7oVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It only makes sense to manipulate VMA fields if we allocated a new VMA,
rather than merged it.

VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
keeps its own, which is also what the legacy f_op->mmap path does since it
never touches an existing VMA. Previously set_vma_user_defined_fields()
overwrote the merged VMA's fields with those set for the new mapping. In
practice these are the same values, with rare exceptions such as shmem
selecting vm_ops based on whether the file has been unlinked, so no
user-visible change is expected.

Make this dependency explicit, and additionally constify have_mmap_prepare
while we're here.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index fa784f069da4..4b74b48c29b7 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2894,7 +2894,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;
-	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
+	const bool have_mmap_prepare = file && file->f_op->mmap_prepare;
 	VMA_ITERATOR(vmi, mm, addr);
 	const pgoff_t anon_pgoff = addr >> PAGE_SHIFT;
 	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_flags, file);
@@ -2937,7 +2937,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		allocated_new = true;
 	}
 
-	if (have_mmap_prepare && !map_is_anon(&map))
+	if (have_mmap_prepare && allocated_new && !map_is_anon(&map))
 		set_vma_user_defined_fields(vma, &map);
 
 	__mmap_complete(&map, vma);

-- 
2.55.0


