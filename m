Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A33E8CA9EC1
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACA636B00BB; Fri,  9 Oct 2026 14:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7BCE6B00BC; Fri,  9 Oct 2026 14:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945556B00BD; Fri,  9 Oct 2026 14:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 721186B00BB
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:13:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03BAB14012B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:13:01 +0000 (UTC)
X-FDA: 85303884204.20.8C2D01E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2BBEA180003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:13:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GfjOm1Yb;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jv5vWPdrcz097br/0FGXZ4kuG0KuwNXHMoZExC0GyjA=;
	b=hvs51QccjNPmEiBw4Q9+9OlRYitbWCuTXaf0OFTWZHu8BFzo2xUVu9iEsP+SjYP1PUneIN
	XHtoifbUuMowZr05rOyMUB/pVBlFwD38uAJh++aMeaPf3KCSlM26WpUYh9CGThwxJHw5e6
	R0aqXGfcewCsJZQI/lPKXOqppgZikxU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GfjOm1Yb;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569580;
	b=OUlpNN+wLMFBQuemtEmRxBVJ7SlC4CaYhYT8w/yUzPUp7pe9B871IvfSufNqTxP04glqkb
	fzjRCfgO0T6boQ3RUYs5oqKfDWZmwb6Mz2iTjuu0uaf9YbjZ9mWpLQw1i0VEz1AhRbyhgd
	l0KPBMbA3jmR3zO8WVxnbKt/hZQxkak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76E944362D;
	Fri,  9 Oct 2026 18:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D077C1F00904;
	Fri,  9 Oct 2026 18:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569579;
	bh=Jv5vWPdrcz097br/0FGXZ4kuG0KuwNXHMoZExC0GyjA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GfjOm1YbMNP9On7qgcqTp2BVzxLPSp24ku88qx/ieUICU+qTFg9Cnglf/MGmYL+1Z
	 SWoL8jB05I3BHQvki5qjcSkECeBW38CL8iZUsu3LJUJVcZZuAIxYziR34xz5LcLLXN
	 K0JyDI8kd3sBmLFGFZjz4fSSNRKj9dScqWPqP7zAkk+i+9jB3LWleapH7Ndg3r7Vkk
	 N4uPkDv07N2mPei9qbC3NGs28joSqCgWylfaRJMwB/atrDQ9huOAGxJM21vP9zJUBY
	 e1QdNCKgRLX07M3seux7Lk6PLRLDG36FC/9pNrji+Q/tjrYFTjwnfo5Xf1jWVXaJyK
	 dWJgw9cpx9neg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:18 +0100
Subject: [PATCH v5 24/38] mm/vma: enforce that mm-managed mappings may not
 set VMA_IO_BIT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-24-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
 "Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, 
 Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1031; i=ljs@kernel.org;
 h=from:subject:message-id; bh=3En+9VaolB5QMCITsLTv3qFJ+TZ+NLC6z2q54bPNGqQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sxRYtOo1LA9Up7cm9T3boZTC4tce470ykkPuauWP
 bF7f+BjRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACay+SkjwxyfGRvyij/9OdD/
 f7lJlrqTXJibT+OWW1r3DPZHJB0oZmf4p+qy0HQSg1F6pmWchr7Ev+K9LdkaO/QnpIW4OIVYVU/
 hBAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2BBEA180003
X-Stat-Signature: myfd8g6ahiu5opbmmre4c4pctydjzmmz
X-HE-Tag: 1791569580-728712
X-HE-Meta: U2FsdGVkX1/5PQgNI4uEcRUi5b8jiE+Wp42LJCECT9quLQBniKA+TIi+wfbJ0C9uDV1RdjLMAtUZYSNT/9zJLaR9kXIWFMelGIv1k/kqdbjhfTPcVz36LYwykDZMEtws2UNokbCM1eZP0lM6fRWUokYx8ZU9od10jiE0QNKS/lcmGXaYHIGBYq/eBcb1mKbQl/ky7eeg9phryCcEF3GHyijiaTp/S42hvkx3CuIraqrsFKrudtOwZByIN2s0zMcTmxupxBcjX6B9svkFs2QW/KqRsxbqfBc0q+3Gp31PRpQ8H+YYFc4A9erYcPS9b3pybm0VVsnJTSzUeGdHzYn/SoAr3t+KlhDjlOnnAasZWDd4Yo8gJKr8dF8huC1hNjAlodA95nnThWLIm5D3YZ4fJ8CFIgBWa70wv6ut3IEu8XqHcdrkC+JkK4iDQnPLlrs9QT5uY/TqGF28BWYkbLqu0FoLu1+rsRBVtUVUNAntxgV2TAq447cxebuCq4TcufQn9dWry7iDew2K+lIvZo+LqE563SqQ9chhFsnn7MEQtwaOcN0mRsEn52isLMXFWEGGD3Ehrgn8EpUYeMT4Dy9YK7e2+lc21EPA78z1QjwNlN7Wt2nPbNWqlLIBdtNTrfi2T+liaXABkZ6Rt6kdeYM/FSj6ccrsrhB0WpIEeDDR/h1vGkOfAsVuf9jMjsvJotwF+VZTNSdeSGNQtmInh5h/3OK2UScEn0r7mhhOCneagxjtEhcvqN/FR8iyNkCr2/YErchm2C+E8jqxW1EpJckogS/Tt9Bm1Syshi7twmscngBqKR4ads9ns9loyKXbPNhPS9zFatDEq4QslJXGYemfrsdgnSIHpxmtfczKb13ngNPDyYb6U09VwTrwKNq3PDICrSfCgF6t16aiyMLF0uq563IyglyL6XsnDG57CR5/U4tbmDf2/K2TERK88EkTl2eOhUYpLgK6td8u9JaYU/A
 oSQVXbee
 1Rjlz41xUNWMRiNraAcpcNd0v5fzho+m9OrB3+aQFFzxdLjl1TsCVMrs2PjvlGPXWHf4dleR0XGIIq6UPK5mprUy1iMafKk2SLbeMkS/XTWC+2OnE+3MoTuMJzlYm5/WTzutkfnYenIYjJ4ejloVuKQEyFK/WfospEUeqi8Xw71PyZHJTLRrF8EIUQwV1E9X4mm5WltHrXYlGX/+MmQv2EOnf4CMI9gzlaP7KdBnxIBvi++9GyaejE5RZZOKEL30nJTzsMv45B50IX76Fa8s6Srkgspeqaf7WINL2NQCmBY2p4UXJQ+3v5l++vDdc/yGlOCJ/x5zU8Ae96GFD1o3LW86xXe3itraXHd1fr/NIObTdjTzTve1Ln+04VDDmzfeuMpKXuPveHhLE9CeUCMydFe1z2RCgSAAqfe09hes9eUFRR3F9XDB0PvSZHlpCkFhkuwtYUNkEwdGg2t4PrktT5IXpWTOvl2FY0WZAtqotG/GMEWWnVFSly11KmXAjzAvjAhXZmLtY2S5vpb0rP7TPVkAzFM8UgCv75BAhAacEjPaon0Sv6Yd+XYwlA4JctWyaTOXnbLOiMluIsPmbwyHmsGBhi3X+bwjeDrAykc4cb0Q1V7QW2Y1IPRA2i5FmVUXgfntTTR/zAhZaOCJzxhtxXigelXDoSb6ewpTPU9dMS5sD6idZC1HbYml6a3Pl1m1MYRetq/KIUeN2O5maUFGeIN084YRv7nwBrFJZ8S9AqxqimGa0D8usWQHUYoFs3DjtHIzOfLqSWwYuRnkRJWyb+/1t4rXgvV5V6dESica8xbLSWSV+pNhjSe414oOZUbP7OPlyEt3YMkcAgn5znGKXHrTPtDz3+YfXt7ipTIkUJpEmv2e76ttUWQYOZ/WQGWBV84/AxKpHdMM5YU5WPldXNwWp+CR82+3AxCdsQ6zkmD1KFamTMw9Ya4f3WC7c2DJtwzm6BEFLefltIu3MqeUDaYsp+Kx3
 EkgubVYA
 iBGndz+6+BRw6QTjJP/7wLtNuAZOOpXoHpDECI+foaoPBb9842SW/5tAdHpZJruxpCzSJVgtPB6vFfkhP2cOm8KGnTcoOSAC8oy2BTpfiRKQXylbr+hTUC1xeL6GTQbBXl3U+rkX3iMKJrHpR2ZMbxe8tVopfGQ2bW7AK8e101U1bxYnxgSrjrw2whtdL2HUBix16n9WbuAz0XJGw6i2uxufTNGvcCFT1qWHbYIl4zeS6VwmsAUW3sd8lB724sKnpBGItw+xDlI25CUvIuIBhCDoAjRFaMprVguLV5Irp+A/Vr3NxAHz1xC+xF5QVSsPT9qIuyYFXtxknUzGnJx6P1rmeZxHt5KBdHh3Y0ryu1gcRrPUu7q+92xQdd9vlF53iLOT/wAQHsLaOIIlPNRkmwZG76PeOeUhpaJ1NybmeH2cgi6GdL4YmSBijFoPeFGRkbjese1VFWUs631XsRWnJUGgeW6aAuFzLNdWSpvqHG/IAFzrS7Dn/ZVU2eVe9dz30f/HfEesU/p/twCbp29tGxe4shXofouiw+EtU3EH4m4vCIVty7+ftQe810M+HvKOgEqHUJgPsSV8UmUS8smZ4/c8Tiza6UsU1JU3SNOGMspsFfhZwNrGLL2li4qOVYvmX1ma0hk4nHZxBoL7jHBu2jk1K4xIFvIRpIrqHe717gZQPgKKBrJub75hqHA2BXfppsvmdb1jzNRBVirWJZxtkWD6zx7pN5jiZ5Wc8DE8WROFqYWkk3MlFJdHqMSoDBZQFi2HxTbnClXol30N4BugF5y/ssYf1S3cWvg1Eb2E0baTF+gA3sypWNv9gMbYqMMvMiLJcPCp4N90dSwn3uORPFc2c1fM4bmob/8cnhcP2BV37o4z4v4SvmQLuOlPuf/08OZajJowEHamLrAiqXP8OIKrpJCa37VeYSlBgi8lEg0B4Md565H9FPhivBd54pVO8l2TPQw6ZSxOC+olEciX5HZkyCJFQ
 6syUtRxR
 mdhSozDUBeJiSPIqQsmGqzABD7nsATnNKFCKjD8LyZWcv79T0osn9VFT3H2iq5uc6/JYuekl9MoOo3PeUzmGk+BMtOpesWS6G1CWcBSlwla9aCp3hWKqrnrQGPvM6P2LsMz4rS7CHdn3HmuxZzSh+MeV1Nofm/1CX0BZTefr4S7mKDSK1GJxGZ1+DSusFTBz92q9+rj35mDv9boK3Y7+71W1bZf4x+fTMjgQ0YLxQFVvQ7JF2O3MRMGx1MncCWEyJubdwOvFWk9xe4xZMNardvgrUo6pgxYItwAy+DLm2wQa7bgEpBkFymnhUm42wYlJyzbStC6HovVhj6CbeP13N6rAVNR1DD9qjIfDIsAzwJrTMmKL+ipGwgkl1V9OR0DDv936cT/tHWta2MxIxsblu1eAQga/j5xYjAZ5nIQGO6lyzgg4iYVnoq9BmorOXnKs7wlRS2aTyVxxHXSXJHc4jIQiSHDYGCCcEmbyFSjNgIJ2F9CmtiLe/YDUG88EAFFBc5wUo15E4pX8IozBFi897EsMroJTIsrpHP+qdsn8fhgPyL7j/1FRZHq5YiyITIFAm0MxI68TJqwDmSxjX49qRj9QhBforXwu2nssdaB47Og2dSIF/4wqh8/4evcyArhUewQqimJS6IgSt0SfAjTpPf7ctYEo+LtQN6ZQN4KGScj1Pp/DoVOI2G/nXtnZbDXPJ7JT65CSO+rW73US7xJpwI8R+qBs2AKy7+DceZ6cYkQUnlicyfezR258oBfs9AyNl77Do7GG01C87B8zGz0g/dIF0MHK73jA3VxjVPt1BlF6gv/WSNsJh0v/7PaRSYLXCJaYOAdabEABSDVdA1x0Axh78SLlsyY+IiKL+0+awnwwDzf/Hkbq+7yOdQtK6ETNoL4bJCFZpLze7CiX5ksIZBF2GU1IUqlx1qbhtNyH/bySiHHW3NqFs1y4TK59+N53VokdPTvpbZYqm2ydE+IuB+t0Kcv9h
 3CauOpz8
 MhVdUIRElRa0dnwlbK6WOrUZvxeaWvaJgJH1USx6ckLhDQgrzfP5GgwMZZa/Yy4wbA9u53VqstB5KdK8LaDbP6WLLsIlFnXJqbBWbslxMxCDbReaNrPp+FBTwdwQs7tSReEriy9Yg36gSz/y/wMIFLNlbFJ+bb7IuIP5wn/8umi7nSpX+n5hwdeKgWiSnnORbTPQFf1TM9upDD0n5beGp2T4eDmFW4GdTzcjAbQN22FBpGm6zvODuEoLnz1uBqr9CzpsyCLMQQkSrrsof2Dq4RvpJ3BsJsMeYsSO6QsPM+MsQDQmrOSqpOxqo579UGjyH4GN03zjNEmPVyjJFQNWlrzDGruN3oo6TFTFBC/63FLUMRLu5S8rGU/72yFJ2dnObIGA9KpLfJdRScVmQlYTE0Xkrxnnsro191chZkKBLS3Kw0f0YfTsqqIhmTPvFurchm1As90Zuz7/wpfieDoh2dvbmCkeQ5p5Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It makes no sense for a mapping whose contents the kernel does not own to
specify that the range is MMIO.

Prior to this patch, all in-tree drivers which did so have been updated
such that they are marked as not being mm-managed. The check WARNs and
fails the mmap for any out-of-tree driver that still sets VMA_IO_BIT
without a kernel mapping.

No functional change intended for in-tree code.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index 4f09fb98a2fd..51bdbe08bb02 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2796,6 +2796,12 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
 		return -EINVAL;
 #endif
 
+	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
+		/* mm-managed mappings may not set VMA_IO_BIT. */
+		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
+			return -EINVAL;
+	}
+
 	return 0;
 }
 

-- 
2.55.0


