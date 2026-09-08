Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17112C79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0535A6B0098; Tue,  8 Sep 2026 16:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0030E6B009D; Tue,  8 Sep 2026 16:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0E216B009F; Tue,  8 Sep 2026 16:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA5F96B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:17:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31F09407C8
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:17:45 +0000 (UTC)
X-FDA: 85191705690.18.B6C009D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 587F980004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:17:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nSWBV92L;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898663;
	b=pKSoWIWwQtGBUjdVZ9HVC42zc6F1QWDVjxr28XihyDGTP9c5Ln94ICzp3e0cLp2sRDrDjK
	1+mhAaDj5Ol4xXy3Ae27he+pe2Tf6bona5SpLTC959az2Gr0yg+9236OiQo9hGVRh3A7Pb
	JNmak8u8/haFEV/fRadXwnSUTrygDXE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nSWBV92L;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fq/fqooLp6MfqSbPhzdOUvBF6Y5t6h1fABLuyvNgM4c=;
	b=0brR/lFDQGk7sxdcZJ78MhDB+ESaEk9mkOm8aWrT4qhDLKESSe3IZxOHYUEftj5XC/EU2j
	TbEf6C7O4wR1I2Hldc/NM4HwrSK7rSsW98siALrC+Cki8R8sn15hmV7JkgCA8fg90HaJ+U
	5EjfsEJOqts6XsuP0SwfbIQoygTciMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D9F842BCE;
	Tue,  8 Sep 2026 20:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFED1F00A3D;
	Tue,  8 Sep 2026 20:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898662;
	bh=fq/fqooLp6MfqSbPhzdOUvBF6Y5t6h1fABLuyvNgM4c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nSWBV92L+8t85kwuXHhkDdHjHxkPeSVQxnQMn5LDdjW/GH3RVqyylhr9uF/rq7fMw
	 IfsOvxIPVuLYZAxIct2QzMu04i7HxvW5irZq3CgmmtoyeP8i8aQeqoI6bIukQ/2N5h
	 XprLc3jpyjfbL5Gn4wzXeKKiM9sllVEhyrfcl9XF77WXNObvHKajzVmpIe5dBsd1Ko
	 S7q6g3Te9Bt3hrNbZYTCSM8M6O0Ln9y/8KvHRS5h+yAbVSkOaWNKBwUXyDOx0f4iBz
	 t0zSmYE9hyM3PIZ9eCfmiKanYIC9dhvvc33E3z6yfYVF2D54QxIabTvgmvGOdILKjf
	 tqlk99+loBPuw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:36 +0100
Subject: [PATCH 32/39] mm/madvise: use predicates for madvise(...,
 MADV_DOFORK)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-32-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1318; i=ljs@kernel.org;
 h=from:subject:message-id; bh=TpPN2uIwyk7OPd2HBI4HDHxlc10ZpBuX2afWbalydvk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG71OZ8YG6oUvPbDhZWKFe1bWV9uWZA4/eGCU08LV
 +n9imKZ1lHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJ8Bow/OGw4Fc81vZa3NGh
 ZplwvVTyy0oLmQjl/ekSq1+lq1+acImR4WftM4X62JoP/VfumMyvvPKl3WmxvsPbdJG00K75q8P
 mMQMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 587F980004
X-Rspam-User: 
X-Stat-Signature: rttp8a5e9e8zse7zxa4y1bsdjremao8d
X-HE-Tag: 1788898663-748725
X-HE-Meta: U2FsdGVkX19nJ5ucfi1fsGnarxbOCpoop8Y8fZAaDYNTEDa1qfMDLC3oQAuxRJ338oqXi1phwenbTdgTm9r/hQNrPH0othTLnpIxTx45gY64jHhaXoSJKYkn7Npdlr/VJRoBgiWTO5sK2LT8IudaLCuK8a6P6zB2rFHj/Q1K2V1mVRtQ82zd0mUzo5hqiJlZVSB9Z/yMfCDKnXBpE6Tx/442Q0UzOFJOm+MpkDpENX4V+isLtsBVJjH2eAQnEgnbfbNscJvYyn7WvE5ROsco8SGKdHmdDCJwMOk+kprdE+zz4JI1gUK7cIK9sqPsFgkXDXw3aMW0A8G93t94EXKVNIOWutz2WOLF9dwsWH0ln69IbXf2cJtsc5CsnRD+kCRCsGjaKmt4rLwSy2YkN+78BjlABVIHPQLDm092Ij1VviJeOG95fOhw2ioPq/Nf2ey3paqQcd/F1C7o3jkFsNYNZIKNgtSlbHA3Z/ptsveg8J4MjXg9VTnuM9kIEk5gXTsV2JRD+tbm2pZ2PxGa+pgnk6IXEw1id6PFmGY3aOdx48c8bQjF6N/xYgFY/1WFH1Yip55swCRTG/MeUc2krpzga/W5lSD5PxpcGDSgLt22PE/0f5jWjrIQAJytkbQTTagAsq3ZJZkO56J748xJnmkB9SGQlbMesFry47MQ7v/JO5MYVJUZk1l73rDanGIAzL5efT7L5/0AbBeLBdAT2mtrXMDfB4BC3za0OOANM9exzIJ8EZi7yH+tRbBnc+Y1EJN6AqKRy3r0ZIdK/BEwsuwe4S9s+nkl6C6bLwXmL3iGJT9aDj2kzPV/tYyNfb+oHn6vm4bDP7RgrADG4RhQTJ+9frO2QFcWZvuDu2wLmksYoGezwxPQakPS4MpF8eGvzzg9XUb2wCyXCTrZed5FlcreJTnULGYNBoMYeoCVqXz5zawsPV/A1YkrYOvNDecj4aKwU8w8L/JkvUM+5AQLA7Y
 UFFfFHgp
 zxgk1+d/M68cmrn9X9Jv9pBWjtazXG+BiZ1HSaNi5Il1455hNfRh/dIzlzKdB5zshHNk7Yc4hoNI92M3MYmmwyGUPy5UNqZLMhFSINVxBB8qR9pJLH39cZ9sYBPAV1u9Q2OL85SfHd32v5e7nhD6mHoIcFSDX13Jbs7rGvZ63+cLDStUeJz0SgfgBg+b6Zxs8qMZ602WVGnFctltO/EJTo2ZWmKC2s+MmJF3+APWGhIE958Ht/oGxIbi6hNIxc+ErsK9qonjFZwAwVn/qjsoMfRF2YATCrh0C0eMcsTXvf1Vof5Nou6o4YaG5lHxUe9iV0OYKcjbs9D24+H7dawJZztlHWOLYyYsH23KrLPeBwhChBLiJ8x66LdoTLBYbP4ZQuraTlF+z66q3jPlt1ss7vQMzI7dSNwCHAzQ/FzgzgCBJRuUv8VkEcLDWT8m3CTP2oXU3jpCkGlN2U1phNkd0a6V9oQUY/ke44XZbxTX4lxkbLNajYwBcc2y67XuDJPHJgbo8rbUGGHJs4F8okXlzKTz0x1IWsPgJ4DdrfICCcR1E26cHTLXIDNQmerw7r2ZTqpaLalAyEbVSnfL6iZkYsOifGFIws2nXVuC1UWLYYHwGWYN4GzTSfKYG7bMi1ry5fTZrgqsefQ+SqV9usZYhIzDgN6PW8fBxnn839xKLLJU+LUxHdg+Ukyp4Blv+zSnLqO61JMG1rW03t1V7+xcIBxudXZpJXW2XzZdrXYkh3zDH/V9KUvfnq3xUWzr2NYEvwPSaemansd8/WEdgR/2JkSNofh/eDmVnPtncP1pnCujsV+ZyvevsdFYLg4dqrfKzMOIjuZKMararOEHIY3OCLdDWUYnSzTpDFS55BDoWk72nZjLJ1YM8g+aPXDyVZXKvw1lp66uqgZ8w5ij9nhVsAKiRCM5FvzcMEofb7X3U1HU7a7xJTs78cPRCXJ5yhWj7VKH2muF9TSqm56Qw5r92JKhkvkFc
 INZ2ysdQ
 eWN3uBv0SeQXC9Js1XzXfmNLNM1/UNzjSBebAwfZny+A1a2LnyrbNII9t+PTXQdV1mj+LdDmBsAQmUpIk6gLPL8joUwvzU5BOX5jD6LCqTXMajDRXhSMXD3o6MZ/8FW1BLNipnKCOHoHYhyKxqLl3zDk+dkYQOzplMv2vF7S+VbJVXKYT9RjKX4eJNO2IkLDQkHjmAp2tHPUxNCXtRYKepBpnRCbMFUN4njB8w+Nexy3Jgqsr5gMBpBtJs3FlKxsSQ1lQoFR+8iO0hq87NhAlsDNLnAzii7gWH1AgfCzn83IsihRopOF3a14hi6EwlWCUvfTnbVQzOiUOy3c365VduaLsg+5DPjtFzAj1H1AQFG0jI0nApLFp6UGjeN/kG4TNzFJ9q8Z8LBwJ8M/xwBiUxvaxxcPQysQJ4cwxxvIwyhnESzvlikru/PVNqkEfDqRjI1aw6LG3sSq3IP/jFOGklHvcGuuU+TK7lCClXSNQb0T0FKaMIllRItXkBY2KeDlS8PqWo+QjmCsYFiFoBGdBzN99IFzUjIv36KedKEV2Xgb9/Bq49X5cTtIrtsCuch6Nxt5i8cBlI2kHt3buzRCTwV1hQaxUheNTXDAavLGTuPneFa6zmTxibMB903so1Mxmv2ipndv2YYW1yAV7o405jsAk51R9bd1S8GVP6hqjFkgZAC9/r31SSmtVpuGFSX8p9+BFDitFdqRHwRwNfyofB7dIKVfrvnaERQ/B+gdkAhGmA4WuO4TjtXDzrDpZ0ZQ9aapDRXthx6f09MIrQjEslcq+quKoaiLGxE4XR8wUByKDtDDOrazF01/CSJNIXciXOZ4GkVQHFIs6Ks6d5DhhQbi4TbaQNT7hDLtAwtu1QUnDLw+zOrNH/9PK8Swcw0VI6ybLjmOZTOAGE4/JZpDg1usZISK/uXKYS0maPmfidpSOP1TzoaDPjMlf6YBBIQOp9PLBI0i3tAN0cfkfVK3muK58kn4C
 gP8EcTke
 BZxnwHCoXm5F1dioSG+9Vn6aJAtErtsPuSnI46rca5ZOzGZK/jXMun8ln8ZH3sKbpJmqpWDOlWhbBNICmraOIdTljqCX+LJ6PSOXzBoHJ93fp5Bx8hwisCT5PHNtxQa6zU3p+shE2JvTzMup3rm6NDwLNCkuSSu7PfPX9RtbjCXoqOFcG59eBWmHw/oiTxlTEb7Z2ijlD89i1Bf1UMgpeEK/86PB1fHa0tVfsXUQt7jNAvkQWj5U7QHdtB7ksmzp/N290pvCR5tBWynSGhTIP8KOjPGUiHJeqoDRpOllt27U3c9KTWmBZ22Ltv8A9u9ragRQlZmBLGAaqM1ZBjak7dMor9VIQIiuS17eldw+gCMnAlQ+wuQpVi8NuIro08ITJUiC54tKnNa7rXv0jsX87ogGCehml3lGQz/xxZTIzsKJAHqe5Y9tPIMAddFmZsbLIbUzAi0J6hENTHLxydAs5B62V0nqYFKJyjPR+7ItQ87vT3npUOSaKVtde19fp94BcQWp0rqd0kQenT3ERzhI11IQdGwVpV4Zp7bTk9abYsR8EzprvFwQSgP7v/dgISDKgZhI2zklkHgLaM4Ufv9RSZAbBaS0GybJeJzfEwAY0LUDY6dBsQmpppe33W5dwGNKi1UttIX11mo4aPzQx/jYDxWpX3UqPYRQafRi0F11cj6X1ohuSjqzzo8UOhZQ3vYhKqQ6vcLQnk0GgO86xFWBVBlGLCDKlOxGtAiqQRAeqh5D9lQmQvoDvdlWTcAuwhq0XxyreWd9ERdZNk95Tcgxz99+jlCn3MdDIDn9ZPtj/iRHVCf+rUR2obK03QaD0nQeriVSPS35t4gvY74ZWqKAwJZZnztwP3oEugzpI06udFa3JNLw/pmePx4rgvyEI+L6ZSsL5WZKKh51pGQF3zCfrIKGNatMjT64goTbme3pdnpanqpDc6o2pJgbsofMao6bBP47+QVZ2Xi8p3fJuaf/G7G8baHtl
 ZoHkElzr
 b2HYpcxOAhOKuV9diXKQFOjgeTm03PMkKJMYdqHqUlIAk5bI2EENqcXtWYWt4ielGE805UwExCrk+xUqGYjALojrM7nr9X1xRZyDqfUCb1h7qPCBUKX+f3/R71urhumwydncmaTqBGZpBuTRiWBHRTQ3vzS4rP446DSLNKj9xIYhxEaTN+R8NJkfsaXfD6GJh3YCNXbk8FPPIon88sH0PnEIUBW89qzKbyaNWxFaLPvyDkXA/MIpkYahmZ5sLL0rCdAC5DkG1XskUXsj967Yzr8LoBApBJ9zheudXjvnqR2PXQWeRY2E3tfo97En5oaiv7bVRrqLuDWEsO3moxh+MA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make it clear what we're blocking in MADV_DOFORK. Previously we simply
disallowed VM_SPECIAL i.e. kernel-owned mappings, fixed mappings and
VMA_IO_BIT.

Now the invariant is established that only kernel-owned mappings can set
VMA_IO_BIT, the VMA_IO_BIT check is redundant.

The rest is equivalent to testing for a kernel-owned or fixed mapping,
i.e. exactly the same check as whether the VMA is permitted to be merged.

This was established by commit 0b2758f48f22 ("Require (reasonably) normal
mappings for MADV_DOFORK") containing my hands-down favourite call out of
all time.

Express the same thing differently - if we wouldn't be allowed to merge it,
then we aren't allowed to manipulate CoW behaviour on fork.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 0fc31835fee1..f805a4876c87 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1400,7 +1400,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		new_flags |= VM_DONTCOPY;
 		break;
 	case MADV_DOFORK:
-		if (new_flags & VM_SPECIAL)
+		if (!vma_can_merge(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTCOPY;
 		break;

-- 
2.55.0


