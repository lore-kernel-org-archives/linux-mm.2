Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9184EC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 17:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8C26B0088; Wed, 23 Sep 2026 13:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569716B008A; Wed, 23 Sep 2026 13:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4310C6B008C; Wed, 23 Sep 2026 13:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0CD6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:01:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC67DA08B3
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:01:15 +0000 (UTC)
X-FDA: 85245642510.16.A9DF8CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2F3C91C000D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:01:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZcQp1PRn;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790182874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJaDFCurzscncuVAFa6+vn22cawBT99G95jk4ztKBZA=;
	b=QaLRM4RPzpvaCPeokTzouVQbGjoy+ihFVvHZJ97ZOZK5Y308lB/Q95H0NVsRV4t7arGk3o
	07rwI1d0/QfOE8f9ShE7R6iisrpriIbiRjI+Xc4zBlQgsatkYqQOuR3ahshvzfak+CHF4+
	of3WOCFdnytgKwaJsyyt53N3RvKR0d8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZcQp1PRn;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790182874;
	b=x1Kbrbl/MZHRVeaLnAg6djo/k0EhWaO1QZ/tAicXZ7w59X+u1NEH7b7TJxew5LvKM1BU3z
	Nw57kAflwfHCNxMdMqzLLuKXCQb1keAM/nAPRE+M2vAPHxuL1huKyDjooq7n5C87XIObdd
	ZCUYwCTPNo/rEqlEPHiGzOjnHO9PMco=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BC49418EC;
	Wed, 23 Sep 2026 17:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561491F000FF;
	Wed, 23 Sep 2026 17:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790182872;
	bh=IJaDFCurzscncuVAFa6+vn22cawBT99G95jk4ztKBZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZcQp1PRnB0QUSVQpuckyN6NnlN+6MRRjA34s3hMaCu8POd1KGSSc4nMgFHRy/IHqA
	 sCDiNxAphIqnCATmrKjeMRENal9GdJ2FHLLfzcPAvtBm4HQgDI17YB3YuuU9mmpey8
	 M40JgzYg2AeW6EmFVSPS3WJjbwL+R67KY/9UZgXjOugo+2fSheSMvvUrWSx7A6M9mR
	 6+iMWSwNyDGjyL6vwrzt+dUQVxRsaK8B7fh+pUqbFmYGQUDsh1+AuIGD6iO43coutn
	 vK0C7KFxaOB2Put8d5jI/j+DturfIgk3i+kflpxHx5ltcdoSP5VGVCG112PoZDHOPD
	 a2ikeQJL/niYA==
Date: Wed, 23 Sep 2026 18:00:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 04/40] mm: consistently validate VMA state after
 mmap[_prepare] hooks
Message-ID: <arQFp_bwAHnmkp2V@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-4-4583d8a23bca@kernel.org>
 <CAJuCfpELP9Ups5XeS3PNbF=VtrfkYbkwRj-LuEHd7bLsTw4LUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpELP9Ups5XeS3PNbF=VtrfkYbkwRj-LuEHd7bLsTw4LUw@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2F3C91C000D
X-Stat-Signature: qbmttrt3yuoia9pj6i79goxei6nqdbc1
X-Rspam-User: 
X-HE-Tag: 1790182873-979753
X-HE-Meta: U2FsdGVkX18vS2QZsyY9ctMEH7ts/wijBSjkjDF1S0QnI0XkKmHtTAqmFU5Wzzuee0VmRAGPwUg5uLPgdAv4fGf7BmqA2ck3w59CaHN0TleDTjr/GkWiKhXo29Rt9spMxnSjB5/WFxxqseNlM9qHFaW5bkfUT7DAEgaN9uHFiCS5XeC/GJWrdRKnb/rRkTlgYjTt6tUy7/AZnoMJreDQGAmzUKAJkU3Lg0TaGwgUyfYRsTQWin9KwawHpxQrtiNeDRINQt4BfmQl3BN7v0ee+jucus+AgLGq77Efzp/Gkm98A28nTWR6HY0wjtBHdLXb0zKxMsuYqmjnAwF3jbA4fZj+Nq2+12MPPh2ySFNRXkrlhszlgZO+YxidsOs2rBH46fc52IC8edFRa16BlHbeRw837ahmbjANg80NVIz9b5yxUgjnIOfKx9Ed+VTDSz3znmBN+BJgH+H5Mk8udj7v42XWu/a9SPfw30J4m+tEiIEXyRhbDkUK6AwDNRTPCuufnGj/VIUXBlWLR+1rXNZDXee7WYrqyZyjyLQsgpC9WLQrGminvVcwBiqLlnwcz2AzNAxkJhBNB0Wkl/E2WFUgQ635I3alJ0zBbvKkCMQC70RsRGwV2HuQ9XvzVpk+tiSwJkgCDrQZRK/WBh+/aLM7vSn9rNWCR+F6d4OEhi5pFiD9Ehz3mdbBGgPaEs/V5RHZyG+RU18zYbUXu/BUaK40P0oMl0zXawP+umiYF98hSq/M1clKoXAROc1IhadcfqpeLs+JUJMxkzKhryu1Zk0fm3FgyvUBINjZRmLPpipfkr4+z45rCaBqulY8R61b838N5LOZwqwqrF06iQt2Yn/hBFXpiUYDYLjru5MDdfsLqXYL/suKa7OS047aeVqxviLRK6fig7O7QeWG/fPkQSnA3ZAmNn+ZBj2Snfn8txUoN77xZrjx4MFSXrw/6yQqNNj2CQ5yATUS/BniSnfciID
 kQATidC0
 LwjnRajCbSNZ1pm/Nizm4iKrfKbJ2pDWiZ2JXXfQQlDCnAJ8CE4E/GmudF7BZtiGkhzx8ddJptmDsNjToqa/1KLZa1kOxqceqQykHJ2aX16bgRvEJakIhWQe+Fiwv0mA10yQNt1/VKiiItCyAjejB+WajZAT3wJeJy2UZr9mtkDmXtatGh45C/7sSDu7slnDYFcilgHGk66Nw2JfqVB8GRhILfb4utOYePI+qO9n/RbowHPBFivYdsRtFX2G6w68/c4hWoNEc6bYqppJs4mbnF7xDKYENO/JP38UmOMQ+B2qPN96UPuTYAO7lsO17Igevxh+v2nQDCh6DElvs1niPY4629k4WK3BFAiYAKRfJOgzKPFO6fsUiMU0UiMzG2nqlQrLPcWFV7FvJxdniY48CWV+Pwo+k60ImBYtAtVhCuQ8sz0ccnMWUMobKh2ZL4nL+Q/H+IGuftHXbxXQ0EQMw/9I5HfiRlFEkJoWYKZK1C8cwpEXw4xoKrlXXqnvW4mAFzPRq/37SStwZlIi5NaxloaJLYSX/ALRGxKf6vr2fEh5eKWneiJhFKim6KtflMaxcnr5Y+3mH+8KmPiogkalekFnD7I3bEROZFuNvZt7o9Wxo/DPw+Vw1xy+Z0ZF+6vs3V5rgjSouvu6eA5HZDtQTeOgzE6BoMbSm7Zy6mjZ/U6DCG4hyKGCNNM7U+aneEVJTSM2WJZNQeUh6hNvO4vBw+A5bd+puOigO34oaTHcvypmsy1fcpO2j/YGgTHIqceg4QbHX0q3RdaeMBlAPxhuFxNZ+VSzerDtc0OsKfPEhr6umWwhOAtD/CygVeX6uY0Etx98WCDAxZV+0tOPut3mOSh3ZLWKAkuNKXYLIJMKJ3VMtiM5HduIR5Gyk7Xb12oKajVJH39rRXKHHVkAzBS5D0cY/uV8QP/HE85O24Cn3071LtAPsHJ0WIlBFWzAGoEAfta1fI4Ahf3JinP9di/qr2qQvcq2S
 TcWDZt2C
 1QqKBFfcXvuhSnTXAGkyAeXq1CGtp92BfFLMPtSodxn3QSQ5BAgOPBL4aPhhbUGVOkpXbA6lvRFlzguO0Z4Y0XSKpIEy4ywqUAhkhwM3E8AXttoy0r00dohscLMo+WkAIZjhOn5loQh+J6+GZrbB10ZhyQnoLRp5oL2rxnwOL4/L/VSRmL4uMD/5tdplYt7hADM1qRYd/WJudBaX6jtGyhW1tT4UXxuMkxep9wYFlqcvc7W2S/uyJxyuQUtmtaPTjUOZjdelmFAWtug2VJWVZ4ZLi27oVX+/vy4JTsYMGPQY3P/LZCOf+WmM3r4GAgV+z+2Ht9TH4exn2B/WSparahuvSH6Jt6Ark60Ex+4ge2CxDRC4y2v7qKsLZaB7cDpgP0Jp1T1xItl+NzwZXcRS2nlZwg49ZtzXHo4dsIr0rOkcMT3XpZs2Fh2oDyqgcHtTMepOCeNFf0n3nGTskMa2U6pjSB2Cb5cBefV989hUxtaH86ttu2b6uApQhAzt9R2CwSvafcS41kPsfEQyzt5lneD6QMeD9mLpXCtLr46S0OGpNlIqf0/hxB70m70PnFbd6jz1dn/KUNbR40+KeDpvYAZi0QKA0rli7yY5tQTBTugBzHwtXlivZ7CVnJENFPaRKd4QWw0Re8pKzCfv9uN88981ZOc1Ps2FzUwJj4+srCfL63kKG1ag8WJ2e5j368P1L4/DMq9EG0s/6odBb2TjrXu6PPCou+Ing7T1a02YmArUZSZ0Q3/C6ALPsyPhnoHhmaBazhaBk4k7LfrBjcKW++zp1HfxtXdiQLPB3lHdArz3o0eA8hElTm5aZSB+mE8tkniBK3uhIORNVPSNFTff/+WRDWHZsCx61M6cEkwhWvzQQczX9VbZkrAQJgkgVL4XISjYRAgmleOA5AmtjHU6tudfxu3avGN1Qsz+rWdtnKmgJNtAOn8yCisHYrynSxQFVZlAy8zQ/GFHSi3OTTHGVbjUlIdig
 wMyBJF9R
 W2bSr0eitksWLVJzzdLi3UNKvIL0Wjf+2gaiNKow75Fb9xtPPbYcn/W/o+rsjKCadNrIWrJxEHtdoD1gG9pClw3MAHDUwqhwbyfgmhoIR59nDKY39QhI1+c53fv05g1/vOQMUCYmrs/yCqlNQbbZgGptbQT2U6NHA6ZsmakdWavDCBldy6hJsUboaysbUrpGFO6RNMgoWGLqXb66J6XWVB4RKyBvurhaglN8DYciO1FiGYImshfzLLK2pVAx78K0LY/g4BLhbqP9y7yCB3nEDMs9ExB9xuD9kFcbUgowabNqsh+l5w+j9Xs84yi+daKjjpW1He/m0VXjlLVz6tB0HusSgKfemWsWpSEaA/HSdI34SbPLNadhgboRBTPpaQZQKR7Ml55CldpWI3wj8g0Ifx1xGQXdPeE038YikXRb9g2L7RWMqDA3DPTOLQZgkxExVvtyXwyxm9jmfWa3D2/WlGlw4ZuiVTalm5RR/P42WyhOlSqrvA0cQ3zI4V3fzOCkBEy4jT4akt+zigCnN+ViZpCZ3gocknEJteonxGiOuddZuQrerzzKvqiFyl6KDlk3nIMUHdU6VE31MD+WIzCe+VpCRkzi4aJmNGAYA/xjkNDIq02q8fzGRpiBQCDYrqNL4GH9Y/9ShlkoZlvT65AaLV4xnOTzn2trUQvYE9dO0Vo5NlMylBGyQ9iSX4yvDDDMtAwv+6FLvc53qMGzb/u8KxfBAhackhYhBs/H8uq4+gjngdvXaV5nIAQNSaN/+kxRzqYwSt3c0hu79/V4mFxJ+bxU2IMbGCWT83/+3qU5p11mtJx3Out6NezK8lVqUTgxTxlC4IoI2OBQM1yY78kouRxZ2UoP/rf1gBhHGv3QLRdfuCtIlOlL9mWeqNyIqSAqCTVQTAlcLor3TYVNVvisCBev+RxqtFxuaDDKnlg4MK0/De6MTtsLncNnVKfsAS5HwsqEVSrC3E8866jStM2XdzQM2H9Sx
 /q5lpq1v
 DQMOXGBF2rttCoE97CaCO6xaxn7egsS10quqCP1loUhU9CA3hk0ocvYS6aBMql92eSa+lptPf/P2EFe6icquVBlrhlt1XvtV3Jmos3BnFTzVt2JjoIHqG1eNfyWpj6Q3p5gtxynEHZdn0+y82qt5U+rQSpNWet6gmC+Y+fJ0NWwDtiT4ejbYEQTpk/1WWA7LrVs3OpGnuZlWc+FGcJmEKigTYKerRBPY0vXLjwuuBVMJlDv4mRLqjUm4kSbHDVFJxbNOSbktDwz4NwjPAr0YQHjUCjR/iGbBWFliSAhr8mnnWAE+oku6uxyLVPYBHgjCceJYpGex8BVNiTUF+5ral+PVKOsELi0NvbvtmUlmJbtJB2oL/m6A3UO9BS9a68NaV2o9sGqxWP7273EVWTyqTn3doZH2GNNOEHaDadbIY8GPrYopjkiMvY/lVPlS34dNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 09:47:20AM -0700, Suren Baghdasaryan wrote:
> On Thu, Sep 17, 2026 at 9:25 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked, the
> > driver might have done something crazy that is not permitted by the kernel.
> >
> > Currently we check for three such cases in __mmap_new_file_vma(), but only
> > if the legacy f_op->mmap hook is used:
> >
> > * Did sparc ADI result in invalid flags?
> >
> > * Did the driver alter vma->vm_start?
> >
> > * Did the driver make a file-backed mapping on a read-only file writable?
> >
> > Generalise these checks for both mmap_prepare and mmap and apply to all
> > invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handling
> > in the core VMA code and the mmap_prepare compatibility layer.
> >
> > Also extend the vm_start check to vm_end also - drivers must not change the
> > VMA range at all.
> >
> > We also WARN_ON_ONCE() on these conditions as they are things that should
> > simply not occur in the kernel and it's important to call it out when it
> > does.
> >
> > We invoke mmap_prepare_validate() after mmap_action_prepare(), as mmap
> > actions often manipulate state in the descriptor thus providing the final
> > state the VMA will be derived from.
> >
> > Also call mmap_validate_vma_flags() in insert_vm_struct() to ensure that
> > special regions which are inserted (such as a VDSO or VVAR) also satisfy
> > the sanity checks.
> >
> > This way every VMA established through an mmap hook, whether via mmap() or
> > the compatibility layer, or inserted via insert_vm_struct(), has been
> > validated. brk() VMAs never pass through a driver hook and so need no such
> > check.
> >
> > While we're here, also fixup a couple disjoint blocks of #ifdef CONFIG_MMU.
> >
> > Finally, update the VMA userland tests to reflect the change.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>
> > ---
> >  mm/internal.h                   |  51 ++++++++++++--------
> >  mm/util.c                       |  19 ++++++--
> >  mm/vma.c                        | 100 ++++++++++++++++++++++++++++++++++------
> >  mm/vma.h                        |  25 ++++++++--
> >  tools/testing/vma/include/dup.h |  10 ++++
> >  5 files changed, 163 insertions(+), 42 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index fe576d468af4..970fb34898b2 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -213,6 +213,24 @@ static inline void *folio_raw_mapping(const struct folio *folio)
> >         return (void *)(mapping & ~FOLIO_MAPPING_FLAGS);
> >  }
> >
> > +/*
> > + * If the VMA has a close hook then close it, and since closing it might leave
> > + * it in an inconsistent state which makes the use of any hooks suspect, clear
> > + * them down by installing dummy empty hooks.
> > + */
> > +static inline void vma_close(struct vm_area_struct *vma)
> > +{
> > +       if (vma->vm_ops && vma->vm_ops->close) {
> > +               vma->vm_ops->close(vma);
> > +
> > +               /*
> > +                * The mapping is in an inconsistent state, and no further hooks
> > +                * may be invoked upon it.
> > +                */
> > +               vma->vm_ops = &vma_dummy_vm_ops;
> > +       }
> > +}
> > +
> >  /*
> >   * This is a file-backed mapping, and is about to be memory mapped - invoke its
> >   * mmap hook and safely handle error conditions. On error, VMA hooks will be
> > @@ -225,8 +243,12 @@ static inline void *folio_raw_mapping(const struct folio *folio)
> >   */
> >  static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
> >  {
> > -       int err = vfs_mmap(file, vma);
> > +       const unsigned long prev_start = vma->vm_start;
> > +       const unsigned long prev_end = vma->vm_end;
> > +       const vma_flags_t prev_flags = vma->flags;
>
> nit: Might be just me but when I see prev_XXX in VMA-related code I
> picture previous VMA in the address space. Maybe call these orig_XXX?

Sure, will change.

>
> > +       int err;
> >
> > +       err = vfs_mmap(file, vma);
> >         /*
> >          * Either we tried to call the file hook for mmap() and an error arose
> >          * or a driver set vma->vm_ops = NULL intending there to be no VMA
> > @@ -239,26 +261,17 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
> >          */
> >         if (unlikely(err || !vma->vm_ops))
> >                 vma->vm_ops = &vma_dummy_vm_ops;
> > +       if (unlikely(err))
> > +               return err;
> >
> > -       return err;
> > -}
> > -
> > -/*
> > - * If the VMA has a close hook then close it, and since closing it might leave
> > - * it in an inconsistent state which makes the use of any hooks suspect, clear
> > - * them down by installing dummy empty hooks.
> > - */
> > -static inline void vma_close(struct vm_area_struct *vma)
> > -{
> > -       if (vma->vm_ops && vma->vm_ops->close) {
> > -               vma->vm_ops->close(vma);
> > -
> > -               /*
> > -                * The mapping is in an inconsistent state, and no further hooks
> > -                * may be invoked upon it.
> > -                */
> > -               vma->vm_ops = &vma_dummy_vm_ops;
> > +       err = mmap_hook_validate(prev_start, prev_end, &prev_flags, vma);
> > +       if (unlikely(err)) {
> > +               vma->vm_start = prev_start;
> > +               vma->vm_end = prev_end;
> > +               vma_close(vma);
> >         }
> > +
> > +       return err;
> >  }
> >
> >  /* unmap_vmas is in mm/memory.c */
> > diff --git a/mm/util.c b/mm/util.c
> > index 016932780925..bdd5923eebc7 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -1224,19 +1224,28 @@ EXPORT_SYMBOL(compat_set_desc_from_vma);
> >  int __compat_vma_mmap(struct vm_area_desc *desc,
> >                       struct vm_area_struct *vma)
> >  {
> > +       struct vm_area_desc prev_desc;
> >         int err;
> >
> > +       /* Derive state prior to mmap_prepare hook. */
> > +       compat_set_desc_from_vma(&prev_desc, desc->file, vma);
> >         /* Perform any preparatory tasks for mmap action. */
> >         err = mmap_action_prepare(desc);
> > -       if (err) {
> > -               if (desc->vm_file != vma->vm_file)
> > -                       fput(desc->vm_file);
> > -               return err;
> > -       }
> > +       if (err)
> > +               goto err_put;
> > +       /* Check the caller did nothing crazy. */
> > +       err = mmap_prepare_validate(&prev_desc, desc);
> > +       if (err)
> > +               goto err_put;
> >         /* Update the VMA from the descriptor. */
> >         compat_set_vma_from_desc(vma, desc);
> >         /* Complete any specified mmap actions. */
> >         return mmap_action_complete(vma, &desc->action, /*is_compat=*/true);
> > +
> > +err_put:
> > +       if (desc->vm_file != vma->vm_file)
> > +               fput(desc->vm_file);
> > +       return err;
> >  }
> >  EXPORT_SYMBOL(__compat_vma_mmap);
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 05d2c676672e..d6ed10cefc8f 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2623,16 +2623,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >                 return error;
> >         }
> >
> > -       /* Drivers cannot alter the address of the VMA. */
> > -       WARN_ON_ONCE(map->addr != vma->vm_start);
> > -       /*
> > -        * Drivers should not permit writability when previously it was
> > -        * disallowed.
> > -        */
> > -       VM_WARN_ON_ONCE(!vma_flags_same_pair(&map->vma_flags, &vma->flags) &&
> > -                       !vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
> > -                       vma_test(vma, VMA_MAYWRITE_BIT));
> > -
> >         map->vma_flags = vma->flags;
> >
> >         return 0;
> > @@ -2710,11 +2700,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
> >                 vma->flags = map->vma_flags;
> >         }
> >
> > -#ifdef CONFIG_SPARC64
> > -       /* TODO: Fix SPARC ADI! */
> > -       WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
> > -#endif
> > -
> >         /* Lock the VMA since it is modified after insertion into VMA tree */
> >         vma_start_write(vma);
> >         vma_iter_store_new(vmi, vma);
> > @@ -2777,6 +2762,80 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
> >         vma_set_page_prot(vma);
> >  }
> >
> > +/* Check to ensure that the VMA flags of a newly mapped VMA are sane. */
> > +static int mmap_validate_vma_flags(const vma_flags_t *flags)
> > +{
> > +#ifdef CONFIG_SPARC64
> > +       const vm_flags_t legacy_flags = vma_flags_to_legacy(*flags);
> > +
> > +       /* TODO: Fix SPARC ADI! */
> > +       if (WARN_ON_ONCE(!arch_validate_flags(legacy_flags)))
> > +               return -EINVAL;
> > +#endif
> > +
> > +       return 0;
> > +}
> > +
> > +/* Check to ensure a driver hasn't done something crazy. */
> > +static int mmap_validate(unsigned long prev_start, unsigned long prev_end,
> > +                        unsigned long curr_start, unsigned long curr_end,
> > +                        const vma_flags_t *prev_flags,
> > +                        const vma_flags_t *curr_flags)
> > +{
> > +       bool was_maywrite, is_maywrite;
> > +
> > +       /* Drivers cannot alter the range of the VMA. */
> > +       if (WARN_ON_ONCE(prev_start != curr_start || prev_end != curr_end))
> > +               return -EINVAL;
> > +
> > +       was_maywrite = vma_flags_test(prev_flags, VMA_MAYWRITE_BIT);
> > +       is_maywrite = vma_flags_test(curr_flags, VMA_MAYWRITE_BIT);
> > +
> > +       /* A driver may not make a previously unwritable mapping writable. */
> > +       if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
> > +               return -EINVAL;
> > +
> > +       return mmap_validate_vma_flags(curr_flags);
> > +}
> > +
> > +/**
> > + * mmap_prepare_validate() - Ensure the driver hasn't violated invariants in its
> > + * f_op->mmap_prepare hook.
> > + * @prev_desc: The VMA descriptor prior to the mmap_prepare hook being called.
> > + * @desc: The VMA descriptor after the mmap_prepare hook has been called.
> > + *
> > + * Returns: 0 on success, otherwise an error.
> > + */
> > +int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
> > +                         const struct vm_area_desc *desc)
> > +{
> > +       return mmap_validate(prev_desc->start, prev_desc->end,
> > +                            desc->start, desc->end,
> > +                            &prev_desc->vma_flags, &desc->vma_flags);
> > +}
> > +
> > +/**
> > + * mmap_hook_validate() - Ensure the driver hasn't violated invariants in
> > + * its f_op->mmap hook.
> > + * @prev_start: The start of the mapping prior to the mmap hook.
> > + * @prev_end: The end of the mapping prior to the mmap hook.
> > + * @prev_flags: The VMA flags set for the VMA prior to the mmap hook.
> > + * @vma: The VMA after the hook has been applied.
> > + *
> > + * Returns: 0 on success, otherwise an error.
> > + */
> > +int mmap_hook_validate(unsigned long prev_start, unsigned long prev_end,
> > +                      const vma_flags_t *prev_flags,
> > +                      const struct vm_area_struct *vma)
> > +{
> > +       const unsigned long start = vma->vm_start;
> > +       const unsigned long end = vma->vm_end;
> > +       const vma_flags_t *flags = &vma->flags;
> > +
> > +       return mmap_validate(prev_start, prev_end, start, end, prev_flags,
> > +                            flags);
> > +}
> > +
> >  static int call_action_prepare(struct mmap_state *map,
> >                                struct vm_area_desc *desc)
> >  {
> > @@ -2803,6 +2862,7 @@ static int call_action_prepare(struct mmap_state *map,
> >  static int call_mmap_prepare(struct mmap_state *map,
> >                 struct vm_area_desc *desc)
> >  {
> > +       const struct vm_area_desc prev_desc = *desc;
> >         int err;
> >
> >         /* Invoke the hook. */
> > @@ -2822,6 +2882,11 @@ static int call_mmap_prepare(struct mmap_state *map,
> >         if (err)
> >                 return err;
> >
> > +       /* Check the caller did nothing crazy. */
> > +       err = mmap_prepare_validate(&prev_desc, desc);
> > +       if (err)
> > +               return err;
> > +
> >         /* Update fields permitted to be changed. */
> >         map->pgoff = desc->pgoff;
> >         map->vma_flags = desc->vma_flags;
> > @@ -3457,10 +3522,15 @@ int __vm_munmap(unsigned long start, size_t len, bool unlock)
> >  int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
> >  {
> >         unsigned long charged = vma_pages(vma);
> > +       int err;
> >
> >         if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
> >                 return -ENOMEM;
> >
> > +       err = mmap_validate_vma_flags(&vma->flags);
> > +       if (err)
> > +               return err;
> > +
> >         if (vma_test(vma, VMA_ACCOUNT_BIT) &&
> >              security_vm_enough_memory_mm(mm, charged))
> >                 return -ENOMEM;
> > diff --git a/mm/vma.h b/mm/vma.h
> > index f15faa83f3d6..b2c3bc832a48 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -782,14 +782,19 @@ struct vm_area_struct *vm_area_alloc(struct mm_struct *mm);
> >  struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig);
> >  void vm_area_free(struct vm_area_struct *vma);
> >
> > -/* vma_exec.c */
> >  #ifdef CONFIG_MMU
> > +int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
> > +                         const struct vm_area_desc *desc);
> > +
> > +int mmap_hook_validate(unsigned long prev_start, unsigned long prev_end,
> > +                      const vma_flags_t *prev_flags,
> > +                      const struct vm_area_struct *vma);
> > +
> > +/* vma_exec.c */
> >  int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
> >                           unsigned long *top_mem_p);
> >  int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
> > -#endif
> >
> > -#ifdef CONFIG_MMU
> >  /*
> >   * Denies creating a writable executable mapping or gaining executable permissions.
> >   *
> > @@ -838,6 +843,20 @@ static inline bool map_deny_write_exec(const vma_flags_t *old,
> >
> >         return false;
> >  }
> > +#else
> > +static inline int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
> > +                                       const struct vm_area_desc *desc)
> > +{
> > +       return 0;
> > +}
> > +
> > +static inline int mmap_hook_validate(unsigned long prev_start,
> > +                                    unsigned long prev_end,
> > +                                    const vma_flags_t *prev_flags,
> > +                                    const struct vm_area_struct *vma)
> > +{
> > +       return 0;
> > +}
> >  #endif
> >
> >  struct vm_area_struct *__install_special_mapping(struct mm_struct *mm,
> > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> > index 2fd422789717..2986ae6ca1e5 100644
> > --- a/tools/testing/vma/include/dup.h
> > +++ b/tools/testing/vma/include/dup.h
> > @@ -1359,13 +1359,23 @@ static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
> >         return file->f_op->mmap_prepare(desc);
> >  }
> >
> > +int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
> > +                         const struct vm_area_desc *desc);
> > +
> >  static inline int __compat_vma_mmap(struct vm_area_desc *desc,
> >                 struct vm_area_struct *vma)
> >  {
> > +       struct vm_area_desc prev_desc;
> >         int err;
> >
> > +       /* Derive state prior to mmap_prepare hook. */
> > +       compat_set_desc_from_vma(&prev_desc, desc->file, vma);
> >         /* Perform any preparatory tasks for mmap action. */
> >         err = mmap_action_prepare(desc);
> > +       if (err)
> > +               return err;
> > +       /* Check the caller did nothing crazy. */
> > +       err = mmap_prepare_validate(&prev_desc, desc);
> >         if (err)
> >                 return err;
> >         /* Update the VMA from the descriptor. */
> >
> > --
> > 2.55.0
> >

--
Cheers, Lorenzo

