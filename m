Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 150DCC88E79
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 195C56B00DB; Mon, 14 Sep 2026 11:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16EF56B00DC; Mon, 14 Sep 2026 11:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66AD6B00DD; Mon, 14 Sep 2026 11:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1E4B6B00DB
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:16:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 641DC16018D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:16:32 +0000 (UTC)
X-FDA: 85212719424.03.3B1746B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 824A78000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:16:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VpSMzAnS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XL6LKrd6M/PBNjkU6hF8z6KNQ8un+D3E9f5GrhJIaKA=;
	b=jz+hKUbtKM6EVuEcXqDBUhJSgat3oWsRn/FtWQ72Dl5OAhSYVDASIyMdqtF67tdDnLlRI3
	/0NxjXyVffrl8y2BuNDAXpSaHKMMvUnFawN3S9M8OyA2ydW3HKFoRiGEsNJM5qvaFiq6Q5
	eGSWCbyfgiV6GoFrPz2CS5QQueHUW5o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398990;
	b=WejP1hsaGq/IX10+H6cNr8Qv46G6fCeGjDlsFL4G+hbBs5+/5d4u4osT0uYkh6G1KvSB9V
	3g3mojQS5JgDiWhcCrQwhvTPDD7YIroIgqpwK6MXjHwmEYGWsULGB7jxzQxv6xt422kfMA
	80k2VGoNLYTR4BCvER6agHe/1ImL/0s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VpSMzAnS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7B0B41245;
	Mon, 14 Sep 2026 15:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932411F00893;
	Mon, 14 Sep 2026 15:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398989;
	bh=XL6LKrd6M/PBNjkU6hF8z6KNQ8un+D3E9f5GrhJIaKA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VpSMzAnS+A0EUvVcscKjUFm7YaTugBaGsQpZqkD7dfIWRrVXvOUf4AZg5eiUIkgYb
	 vNr1ifzun1Cr2XzqBIyUGEJhCva51xAQ/uSRdxXaFIXps05ytE72SCrNMODy3PtBv5
	 CA6bD3grq8paI2j/M8rV5qTJT2PHki3kbR5ws0Co3vm1sOHIU7aZxJ8Dw27RLLoHsS
	 4igGaxrRkN5Kmre20YkQB1uTXCp6EeIOc2bi0OwRERk6TRlrmZ5eY2g7o0Y33slxPM
	 k7XUBmGGCptiE2ctMFAtHiaIzfV7jvIPd5XRMFRgs3P0fwHdmKde2x8Geb9KvZgkR1
	 eT2vUY5lEQ/dQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:57 +0100
Subject: [PATCH v2 37/40] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-37-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2135; i=ljs@kernel.org;
 h=from:subject:message-id; bh=lzK+2c/tEosn3RgAl/J0FNyvUX6YrR1d8AVyW8bOJGU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG9Zt9pOavsKvgW8ORm3rs6//269i3P5myfBKT/+L
 Kqoy+au7ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEpr5j+F97cZlqw7eHRulX
 U/mjZ3F33bsre1BCPMy66nSTTuOTXD9GhmtsRzQO7H4V8+7B7FbvW8EfFq20ns4Q1OA3v0B2+8F
 nTTwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 824A78000B
X-Stat-Signature: tcj64repip8dthti7rqas69swb9kciws
X-HE-Tag: 1789398990-344222
X-HE-Meta: U2FsdGVkX1/QmM3hn7HEwjJ76949aIUTcXrBx1JA8fIfzcKfIhWVPXT5rkauRdh12CIKaRxoc0mgE0HXdjNIKqM0wIQb4dBFGhV897l7PX+N9R2coBX/8oCDkj4I3WhE30ptDDwQv1MKKO4/88SntU3Kl8WRPdcwheST/Xs3FRBri5Lp54sc2GWCRJ5Ltjy+Q15OIr+cvCOPRq7Rljj/SnUFmH6fld+RZ9+GRJs2uBaEuwQ33ZJ0Xzuj/bCTqIAV7Ynig1VaBh0W7zpGozvN5JPywf0A4MnFTCEBItT6xhSrALL+ojj/mvFpVeP8CSap5UCpFMb1LkA+NDCAjrjnS0Q4lPf2Pm6tMo2TxxTVXXyw6BzjqfggamE13PqF2vd0dd9x1LOF+/fgq2dQcv+8w+Emzgrb/0+N89ctIp/AgIaOz/rwT7ucNEPkNhy96e6wrpqEGW2fRNt0xt9I2i67CCeRYE401hmE9BcoHusCLTGjknH/skZmPC8S67F+G/R/tSdgZdbYiMwHZmhxVUl+AYan9oNtDIjFwxfcoA/EKIzZC1OGrLo2nsPZL5jPRStNHRBa5hopxgHLjtievUcI0C+nBVIsKptLFq3cnmTWlR0HMXcildfcJ22ha8+w9joMM/bjbOuMsdyws5aIB/1ZhbhoskDs87uKzziWPKzAxwTpPje272LxOzqcVm1kBpn8XC1y2PYCPrfmQfioyn3kv+RIi3qjW0fJF4SM8XAMopSSWGwddudDULNm8ZIzXAKu2koyEr8N866wcyUXVeCLNdg/mDna+f7Q8+oi0yx5gQTXwY9E2f5wIbIwY+9GDl2z0CKkW8CHEk25lTFCs5xp5IMUN2Uj2O4aVKwuQFYmxbbDBTZMe4MmtLgzFvYwJivgqaWLnjdynD6XvF2nS4wwngZTQGcOZqE7OHh5UpiparGUi5gdAJVcHHAtw93X9VlK2gLulItvH6iOsWWg6Q6
 SiL6jumC
 iyx8Iz19Jx+TNxaffNnbyCFa/HGLxP+Y1BR5Y6xhopUVMc8uQMssbx9PyOS53naN2QZRJadUQ4Yq7ik6QNnxQ4xThRRYrpB7HTcy66vABObCkRYE0/cOHhvCywSLAcZJQLsJofy7s5loc7CIWbtytT7wiXRGQGGiMBEcbna9nhqPJ1V9uUU3f1j02p+j51slLCFyIGVjaB6M7zSvYlZRkTv63yErbPtmKCTh9sloiNe3dlr725UJ/rVd5mU05LP9MeNX8jEjj8LtdCrJwW+moLX6TM0m7xzuxWimZ7EZgtlgiwNP0mv+lajUbUSBrD2qIrFTFqGA3Rv211Po/97Z8CyHQlpsOAxL8FBVi6PPPdq7ku0cp10DEp00bG+M5qUD2z7cPOgm9DprSbTmHhWYd0UnmUySALwnURxeY/krNS+1IQHFWFuluvS7W72JDbAWoa7Q4lY/3wTBjur7gLr4iMSliBYdsNeYhxaVcQd0WiyxQA9EziMpp9xKH6hDtqA/qqbKkACykUqTEogdbvvl17x0ZK3icvte7DsyH6NGrvINA6HYYcu2lrCJl+FbmAHz59ceHH/D4JGVyZErTJSKX1qL7/2E1vAIvgKQVO5fhahTZgRZqg6tpTI5fby2w7G+4U1aXtcxN9sJlygWPZhk2F2evalrmVuEoC9jVyoFjqG8UvWHILcAxCvR5oGpo/4nYK3VcBLdz50KIMdxZUdM8gpTQ3hI7QtvkSvW4bkUl36diOcpJkYMhRT5kBc4/YBXYzrfeox2lmOWeAqgaEfr0Wed89wcYbAhfi6MKPbKmm0vt73YlBRfrU/YzmNQCtcKScdxVjautJwTCYxp2ll5fgcm+R8FZMRcij9+iUa9/y5lmpO9rpPk8goIwUKRAIVSRXpfaeK2nMOhth8uWRqfajtKUJqScTMDsvA34AnjoGNwTxgTmHYwb94MX7mZTaHQ5T4ULgCs43liMT5DpKAY2xYCBXvj5
 8NfzYsFe
 WlQWh1ak09gPWEEnnQmnAMYsiu8q/Q2GfBTGXSVCNLObbrIn92nn6N8hIBls/QnsW7DfSsTbhXdZz0J+s11z8v/GxowES7leY75wMA0zVq+EOc/KqcgukglBh5TV+IswmIuuDdz2hB/YQjRQeKTPPkoIAlFCGIM73oK3HWS95Bplaf8yqlHaogD94Ff3dQrurYXF/xA/UQHc4iw8VxYKfGxfMintX2Jo2yOd26R53XR6q10H+ZsKANVINpMeBHMwjeX1z05FriCKOHY9nLSn+TNndrKy4vHP1QPoeqWII+uxc+YJ/aEt+Zm2JUJQsmJvPOV/NH5z0Q5gkhdt2wm33Ko23LJzGPifm2x8fIVsqv7lDDl0vlx6+3KSH8XiJakFcqVQKw6DveX7p9xj1OBaP/v3NEk6uMBiiImNr1nV/SnoTrHI4yzKUEcJVroS4Bd1oT3M1xYuklkuQ12TnvpzGOTDwiioTa0HPTfl/yywYf2QBqpWRvznwBOi/W6RZ+psc1ecofYNX8W1ZB66zNaYqUCvFBxwLQbleSPplHhb3AdXlxKZk3PGwPoWegbbwSOE9ttwSzAk/oryaPJn5PRocXqLvl/HvcLpXO2OPRNYcj+NqKn+adLV6G5ksoDxqTjUxl1ZmdGojBVN9o5q8Sj/SOgo/y30ZdkJZOuJR2YL4nfpjJ7Qq2nQOJHtONilntoSVgVnxO5/mTvOcYviRacjPfcW4JteRRcHBJ5fGnShQJP63VRkFFLkt1grBJIPSh6uB+Jy+WwNxFKYpjqt1wukLRkXCBELuRAOFf3RRNPo6CQAeCoDIglDSxJ5QppXxvdCoRRrf9y4FylgwqYV5f1fgZIRu2lEzSrHEvPdZqtcFlagsB4vkvd/NioCYZRANcSDoxbBrMWVCQ2mOEmLrb71N4pveRmIcXXsQb2+NVPwhbbSV1W9dYCTVR/4015QWoGcPqHaDUxjAycn0y+iOcazaOudTDcaw
 y5gVgWjJ
 funyx4u3mvXVONINgV8rZAM/8yLQFY9cRJ3WnTRNdmr3PiitvdolCzNRtKczeDcd4cTu5k8Z6xZVA7Hgy1mFSOkFWsstwBCM7QYpweNETmlCLyeXFG4GYYni+fIpkzTOcA0kyPwKIuVFvNR2UlREUWUNR3LTqDHFpuhj21PdWsOLba9vYA4SxZZc4NNOGS732xVkWC8tvu26687JyOrQL2M1P93L/G+CBwa+WSJAsIAoIdOJJZub5jgKbgwZHAfojnF9U2KXwAa5gq5abgfgGI0KWnPh0Tspt/ZNCOwoNXKEPUwQ/X1qcF+CiTvXZjO7hJrEHHMnEvEpcOUbKGE7BgRVfTuBeiw67mKZOcGsXXWN5lIo1kp93ezKjQArgkAqQINXxNoCnEz7bqklnBRZIw1cIXtja2O5ACXqztf6CeLYu++quaGH/+iNpyXVd3tMUnmEbxPfo0vTq999PPe7HR75p+fEJ5INJXdzk5RwBZnAcZC7CL/xD3XDyoPQtXuPE/TdR5g8/feIAXto4Vtw9kfL0UAHqNSFqikaH2z2Srjhvao1WROu1TH3K8TPXk0mDeRL4kQFTZaqIjW6lYR4KpOfQvuUNfX4ozjk8/DoJiXDshNLxwLNRNiaSDYK5lkMPojtfda8XIg5HBWw6n7L6oPfsmHsFlcfzFh2MFOfYZpKV4UVvCQi1PqsSv+P0ITWGJp3SkoMZs25Q2FfRMT5cr1qsPnR/SteyYo5NdI+gS+0I128yP3LOaJ4kod7Og3YkBV3PR2POjTWpL//u2RQLaE3snBtnsFZK7hEMBNvh6YeUbI7q+KKMWF+p3dVcFyYeI9/tlVci8yjhiP+lwDMwB02Izqw78MaPcHBJBnS6784dC2NoD1ahULleLRIKP4DeMGpC7YRcBgu6Xlj/wRnji4KvfC3SKnqoEMbLzpNBKpoZQl5EeRYQjhya+znHVv5HcsJ6473FFqyvKWndAGAbhB102kTF
 C6BtcD9C
 D2bTqhaZLl4XMnXnzhTAzYdUot6IvCFgmPQcJKshoP0mycXvyI+52RWmQ73UhFtzBh9Est9HPzzYecP/Gko4RUN/h/gbeWTjEbfWt5TXD0OpVXexbagX064ArhsKI8h105iv8P8LjfCqKWqBFzBy0a3fvYYnVJVnH1FYVixfDJ/gVB09LFYPL73BpC99NwS3jV9JPpuafkLWkIzzGavbqWMn8/YdogzdWaGkIpYQpOTAmvY64xLnaeQ6CwAVMgbio0CSW4v1ORwgvZhGx1UnbiHIqhYuFVjWNo7vwfQ4TQ1f3xYJNfQqyAPaiVCs6Iuavs62qMHP1xjCKhMoM3v//qfrl9EwMNDtecmUsjj9MsSRK3eMHsiXovPKAf7k4uHU4xxUz3+MpMK5mtJ/7xgQ8gYUvHGlek+J3b/NqRSZdktSRCuWegL6AAfX+fdFrwKFNR9lJ7pejREQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted to
predicates which explicitly express what is actually being checked for
rather than the nebulous concept of possessing 'special' VMA flags.

In any case 'special' is not so special a term of art in mm - it includes
VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
other cases too.

Therefore make things less special by eliminating these now unused flags.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 8 --------
 tools/testing/vma/include/dup.h | 8 --------
 2 files changed, 16 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0579e6afb19f..5860a3b4dba9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -576,14 +576,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-#define VM_SPECIAL vma_flags_to_legacy(VMA_SPECIAL_FLAGS)
-
 /*
  * Physically remapped pages are special. Tell the
  * rest of the world about it:
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index de429ed4d60c..dc24f43a9394 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -352,14 +352,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 

-- 
2.55.0


