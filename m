Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F11AEC79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF1046B00A3; Tue,  8 Sep 2026 16:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2CE6B00BA; Tue,  8 Sep 2026 16:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70E46B00A3; Tue,  8 Sep 2026 16:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA1386B00A3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:13:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B42B0140250
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:13:55 +0000 (UTC)
X-FDA: 85191696030.29.E4B655E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id DB18D1C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:13:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f+Mr+LZ5;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zxsoHiZuiEmxcJzcWN4k6DuzJHqi17MQRpDsUiD+p6A=;
	b=UzzhiegbntqVkgFLjqudPL2zBjce3ZwNE3bvHQrZVAhss8lQMsGPxhy6a2qjKM5e9QiNoA
	5UxCT+IoOZAXE62BSZw1tSMzlRteKPrsrWSeKdl/PajDLOH7AqA8Jfde+bDscaOhSBO5Ph
	9XQT6qNhWNjfjZ+E4v0UWlLiB4+5fCY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f+Mr+LZ5;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898434;
	b=Mme6G1CWB5WCA6cMA83kJTE3M73YlLeh0q7966aMYu4sUl62zdwMuJytOWCrugO2OEcX5J
	ruAiuOuBW8QNQ3H6+E4txufNAZWOCNSuyr9YsR9dx89hXV+sMQcW/jaWkiPm3CS7clb3sq
	LMNBXLDh32VilmoJa2PVMCEWaDvrkWY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E5F443B83;
	Tue,  8 Sep 2026 20:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041C11F00A3D;
	Tue,  8 Sep 2026 20:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898433;
	bh=zxsoHiZuiEmxcJzcWN4k6DuzJHqi17MQRpDsUiD+p6A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=f+Mr+LZ58EWjR1Vj2Y5dhsxFsGCZxc+h1J3z0LW/Dz9YFUtW31pXWkPAuPHaQLwT6
	 XID45ZVviQp1sn4ZyDvfZC0qj8TiV4MhitcrJ5xl4HyXLD4mbiHsILxVcHNJu1r1eF
	 +IgSffXPhD1650r0HHbohuhzizR6waCzyazMS2u9ne16fJavkbA8xOgfWVIY7CLOev
	 +CXWw8pxxuoSNswby4MLsIWIbEgAVKt0RocXC7OHhsVYfUZSss/lLjIkmorwpW+XTm
	 XGAivUcLQSspqcjTNjKulBCyAjPHqAYEL4W5mIN09vBk00oewkoopdDJb/9JVzsb8j
	 wR2ZUYVjlTEEQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:28 +0100
Subject: [PATCH 24/39] mm/vma: enforce that only kernel-owned mappings may
 set VMA_IO_BIT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-24-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=988; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Waz7DiD3rguBJppiiScbshRu8gUGaEpIlzQeObU8kmI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG6xdK1TKJ/+t6vvAO+7/4wPmDUiFX991cpqLJkr4
 rrsxsr3HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIrl+MDGuZw/32qyX85TdQ
 2J3TPqvM223zrmdpi5nrqw3n2xX8/MDwPyZeaV/9mzmlK9K3p066/oSRYfW007c8v/9Ivea/xOh
 KCjcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DB18D1C0003
X-Stat-Signature: nb1pu1snx8mfm5iuwycskwwpj8p37t7o
X-Rspam-User: 
X-HE-Tag: 1788898433-731971
X-HE-Meta: U2FsdGVkX188g2CfqtVCYxNC78yhImwrId6tfrIO/0h/SBH+V6qkyDz/GKJxmi511bti4YvJw32gtVB34Nsl5sdBRLSMyVGZVzdMVeWdD1XYao7941o1IF4ziW/PETTHVasbTMT9F89sIN2J06suW6l1eh2zU8YRSUS9UkEVzS4SFuk7bNYc8OZF/NDRzRVjwnQEQulam7HGuT4S21rJAiNlc4foJujxiT/GmzQOJYCETKK1xEEve8tAWxHPyenLFw0QM9/BS2My/1pQtx3k1XrUO+J8TF1Fak2tFaysIsGdSE/gusU3rvPOjkrD0zWDZmVhqm0iPCyWbEcYA9aM+KVG2r3uguiy4DxW6VpXMZD2nS5EWgoPN903kMAoKIY3qTfhbHpP6KFnk/i4gnub8wFs2o1h4T0rrebBR0CpluHjA01totksYrRCKk8ltyeY2rV0N1NH0R70+FZ8owup5fIzP7dYvX9yNTpRRQn0lET7+UQLnARH//SmaBUpazb17zxpx4ZjR8/cbuW+gpjmTgY+1n9qEcsYdye+3KRHdBu7PbRVeQYjeFS/RTst7FFUNf+ZS/MwhVwpjqF84QaM6jqPEuFIKCPHjJZ+5VQnr1xT5B4AgjpLgNK3qy/wz7WelZlHLTKUlULCLM/QAnakFkV3OZvpTWSQkBqMF6Cp0IZBNpUpnpCfVUOaOl+jdXxZMXhbp5ulwm7r0tdQZk9zZTSH6VR322BCXjSf3K8aDc884chdWpIiNv0Au0hn9Yeq4lkoHbBX4GXs2si//a1iYktQ2InueZ2IrENihG46HCQtOg1CHoKlnbT5CeCdgHnLwhP7QJaa+rTCDYdbot36QGwduLFVeZskjj6gM3AvOZ2jYScj7qsP3id45eiMUd2YfopGMPzuG0czibmQ3f+HP5iOeBfK4Nz3SVmkzUADf1q9pwp0SATvot9xaaodItrgOQbr0095CnEIwzVm9++
 eFUoe5Pp
 Wq0OSZGXZODBtf39AfnSBYcf8WS7hHsdhbyx8tRHHdSN7GI2IxZE+11fmw83bJDJwIbtYTzkcm/Aolq69i86aIB+EFSCYRq69BJw/WrZ8/ITJwtbvUPSo+yzSIKBTbg3ChuIIZ/5N/OFswj1ggofOOef3n+fXX1hdExYQKOWUQ80cBt48E8SSGCBKIzdlw5KnnHx16uXd/ArjFTGe+Q41t6k3SwEoTKNIAmgr3icirnRih8XeKQq9hfg0lAhymXN+v6PJynT1UZZ3CG/y7NCybyh9ll740PXwdGMgMIcHFLVYZ3AWevg/pQsocnHOf8Miqee92Oa/JKIsOd6sNWCtKMooeEO27TQ9We5FimTUDyUbjIg5bQoDj9V8bn3zoey7Id5zSA6gmq6Rmeb5VGecg5dpp0OHq+L4MVxWPEruMGgUxJDkVgfWrbxG1sryd6qesgI1LrXmUHY8Fk0cmkx8lmOMHb4yHvSG5DeE27zil5j4PCjhFRyaZC6p1RszRgA7gZ12qojXVZI15CCjZgACu9crgffV3Ld8WyLqKdND6eK8nhLPzwrnh7Z3us7WeEse5WR+GM9jplu3GFe9E8UPTJvavnUoYC7pVb2SB61HSwJhGmGwYyInTMNDJ/YIQfJTDx1gi4mSNJhCgmScI8c/Bw5ReyA2pZCG/3fRlqzKfixJgQ7s0cw/9Zma1k841mDtNAIaggyamBq67IVwcoC4swUheWFBDr0hk+rs5XFMmY+ars5U8w96ZAbpQReQq8eP3S2SRJ69WZcn50tQcUtGK+71Z2Esjz3LrOegOTr0OBjssbGczXBQ087vVCkSLvSyMtzc44WrmhycsrHkfiV7owvc8ldyBcSR6t4xOba+urbv9CyJoaeCeZzdEeLD2LJu3UYUBd4Nd8EMZuAJPgRCunPoKHXYrNyNE+8O0olicrz28n30qRLiCvKkAzCfZvQGYSQrySPC9CVCm8663MXSq642IHrU
 9zawu/n1
 VjPSoIgdjHG1MjKSFv1wvQmK0XlqWTyAMFNmUwkXmR1m20FdQ3AER4Ch1dm6eNQov6SQsdO96If7kT3XXsxBfdI+AYMnDDXTYJ3nOGk09oZsfGW97bynE7zTCUaM3Xw21XTwPP4xF0UrvdwYbfVUSfJl9CiFF+ecBZQPcr9fkOkXgLE5JyNanmk9MTGruVECdLrzrJpO4m79PyTHErwKkMVsjKVr24Lp7Az+DXpmRGMf8t3lHVtqrgT4HxJV5GabbggGYq6w5L/7eAxasdlnOWIxHflxg+NXP1PCNyr5jHWJ8mZFVLPTujexaHxTMlZW4rQC36lJurrnxDDOVtTNc2Z9CTFu68gy0ZIhiNKcTl2VGvtJykTr8zVswJdm1CJjtw+ucsl73D8wlB4UiVJE69zgd0m+XFRiSOBDXjqIUS2fHTE1W/KN8C9olqC0abPZwtNzayCYMAAcvQ0t4cra7AVxZ6GkjMdAQYzf6hE358y7kjHnzgTi/hJ9/wS+eN2HFefT5klbrncL5zWH6IedE0vKxvph9dLyP6nBLyRbjmhNLAHOV3Q25u7Ix6XLCwE/HbclyUIVilc/2/8MS8Ob3D5DqTe7EMIdPeAJ1RgoH0/YumV67dXeqqRSLCZEfhULULEwPZ5WoktkEkhOnLnIJYS5CzMBlqWcGPqFqlHllCb/Y3fJiEpVKex5DFOU+LW+Ab5ea4Vvl9Sfke4HBJEjU5hort3wdJjlLe25vIF5oQ2Dfezd2RxTT3p0C5abU+RyUKH1HB3iSaKwc6l0fE2YRQDqdCeF3AA1oFBeOKhmTKTxbrXlWkpo+x2p55vL6h4PxS3loXGz1phfKy4OuPSfevTeG1ZsJa1cw5TvWoWnEJ0oWTA62PD5fZoMFI7BQ7wy6v3vseWkCO4iJV5y1ucMHUpeyw7Upj3+PdI00TySqAnYXv6gbaVj5fXnNFWnfAOgvsZGB3C2unwBUG6c6YwVM+RwAZBhr
 3n8b3lN1
 27yLKH+uJU3PH/6mJzPkhgxi5xfCqZg5IiyMnWmaBu8gn8wpXDroqKUrZ6+x4mcsmKOcJGx1yUeVPoIgsOYdFjk50nJLNblPTaXQvO7o4lebXI4KXBi+AFco4QfI7qpdKSa7Pe0vSwBsKJw0sXsITyXGlC7eY+46oH8ne+YhQXqfJoJm3Bm6kbWCyYT1531FPWnSPp2wqvUhAJ7ScjUaiWC4osfLpnmQvH7mJ2YgJtpX8p0mkAW/1zEGeKb4H+Kk1YxXGHv4IQ79DTTvKks6TkxA3iwoC/uRQon2UvOJ1gZKmUG6AK+Z1Q3vcyBfePNSAGSKnV9VTUaEfFnGaYLfDtI8XrkPlN3X5slurkbdZPnEddptTwRiFiQABGFb+6Vf47do8zKtpet0m9QTiCLUEQXPwoULv/H0K91Iqa+Brw1n3abSgnZjyMHJ0VpGWxH/C2sDn2HHDacjwYmKEQaJJ9ckdsn6+TxL0xVCdIHUmVBGFRPcexxX5Ixryk2diJUqz4BmeNa5laJXrNOOmJuLxKETe2y8rGgpXfeApWrbgig2LXaRFTqNwvw9Zsp0tN6nWjQVc7ItrBbNHsoanDZ4y9wBg2qUBBdsi9eiw9ADNudfj5AMrwflQUYrOInaKgSQln1GqVX4PiGjtrOJbxx9UQRkHSTobkhXkxHctquFjnA+cXZH46FInD/3Ly9tARySDlyXiEU5APZtBqFoBRWT8sNMYf5NP+NiggPCD2OpntAbu6DW1dLF6jSwgjshJscM6DbIpi0WnzX6ciRmLmCzWWCrssU7rOI+qmMb9Gp4pJV66nFg4PkdFEhKdW9UfJ89clCyZbTncP6+i9kgUXMf00qG05PAmR2A10S/EWO5vbjqLtvm8IW8HHKsJRHxcZZ6gl/jckO1uMTUMTyMHpk9TxF5Q1uoLazxqHF7DScZk0YoxFzag1jk2tQ5SnwiD0H6ns0gZcsyLfKuUGkjfAIMHp3S7oeF7
 9qMcE7gD
 s+AIEC7U/k9X3Fn5SjIMe61YocY71/dF2XBDKK36cWBQUwPNSmgN9m/5Lp4JSVVGK/DFbYzSjeIB0Ga/1MOCicbXtrIbswiyYtar4p7kWq8hjeNoP/U5Hzx4qNAvvTGeLXJA5rh5mQAmIW25m1LeWwMqt6t8CO62Dx0O8swSPBunN3QWtRulWs+zA7Rj1C7gTfJwuKWPooVFrk4Kex2Zy6jXtcwk6cIf66rQrxz924h8AaEx9+2f8NhCb/fEm458rN8qCy+sWOPse9dODSidSohdP5qyBdKdSGb57YjNAVrP+W9hv78Fvn+QbNHYDw7+3StqgR22WHdYADj2tafbrY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It makes no sense for a mapping whose contents the kernel does not own to
specify that the range is MMIO.

Prior to this patch, all in-tree drivers which did so have been updated
such that they are marked as kernel-owned. The check WARNs and fails the
mmap for any out-of-tree driver that still sets VMA_IO_BIT without a kernel
mapping.

No functional change intended for in-tree code.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index cb0c4c625756..5996757d5aaf 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2772,6 +2772,12 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
 		return -EINVAL;
 #endif
 
+	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
+		/* Only kernel-owned mappings may set VMA_IO_BIT. */
+		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
+			return -EINVAL;
+	}
+
 	return 0;
 }
 

-- 
2.55.0


