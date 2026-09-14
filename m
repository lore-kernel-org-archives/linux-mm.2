Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48189C88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CAE06B00BE; Mon, 14 Sep 2026 11:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B456B00BF; Mon, 14 Sep 2026 11:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 443726B00C0; Mon, 14 Sep 2026 11:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 182C86B00BE
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:06:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B83391C0089
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:06:52 +0000 (UTC)
X-FDA: 85212695064.06.D865834
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E65F840013
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:06:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+fBPznE;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398411;
	b=bZSIcS+yhf4hvOgPJgFiB+tBpvZbz91djYkrg5ti4IP5WPK19A7Mcv/l9rd14KPcn0Buep
	iP7uHZi1UdfYJj0nNp2KSwHmlM9iBZTUQndmrVpq8GoRA3kr2hsHKCy+56MJ1ZMF4maNXh
	bzKWwf/DFs8ARUf7lp7fvnfTz5hvHLQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+fBPznE;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L84E+VBIjXtbMM9gLwilDTXz4m90Kix4dW4wQgsIOqc=;
	b=1mP0Gt35viPMHHULysqhrCbL5UnfRyNpCiAWNEUKZxx4ImVnzIf1kn8yYCTCttF3lraeAJ
	iun2CBNADajR/jcCjD1SBGz0fAFhM0H9uTQIQndfQ9kf9+W4VNS1U+a62xiv0/Ts2IICS2
	kqyQKX7iEWJI7wRpqqQCAvX6oU0N5ls=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37CFE40229;
	Mon, 14 Sep 2026 15:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4BF1F000FF;
	Mon, 14 Sep 2026 15:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398410;
	bh=L84E+VBIjXtbMM9gLwilDTXz4m90Kix4dW4wQgsIOqc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L+fBPznEuntQN4DfHWQNuqeXQnnRid1csrks699iiOe6tqiIP1Y8KTkcD69AvMQei
	 9jtR/cCkqp/gaZt3A1+sMNxPdS/CVAyctqp/YrV6Hv6W78u7G4eW5+jqLXNQ5TIywr
	 6hRkceqaVaMnaAtb56K9+hanSTvhQHTTg5yCI4eocOSGFPYk/WVSeclcQJMQUC3VDt
	 OlPV5OqeL6j7xR9BLdCnNTGTdxwSo72OgvrUpOchz+ha3jC3OHEdIHOUM3fa4ffMaG
	 7smKzoy7srZm4qfhsfrKY/ov1CXCUWWDGG1jXRYbRe9oqb8Gal+jWDs/VXtXmuNAFI
	 gZAgSSdzNSRAA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:36 +0100
Subject: [PATCH v2 16/40] mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT
 if kernel-owned
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-16-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2245; i=ljs@kernel.org;
 h=from:subject:message-id; bh=VBJ5n0AzlLNSnyXutKBzqVELhsd1soVPc5lqklQgPTI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG/omrjXccJEyb0TfbbptCkvLPzj4G75bEaixMn/G
 3OqZFludZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiIYoM/2xSji3htFhzhp9B
 9l3a1uSpD7xP3JHol/u9c5Kk5CyxxF0M/0w91VW4xfc9KuMsTZHclZn8MIPNMnunxI4v15MmyIt
 VsgMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E65F840013
X-Stat-Signature: dswsdr8anaj36otne9qkc1iqmgfojnaf
X-Rspam-User: 
X-HE-Tag: 1789398410-306368
X-HE-Meta: U2FsdGVkX18T9pVx9cBiYHMGkXsLOdQbclf1VYGvNFwyVKJVQ49GN5tQBC2f3T9WjFmxncWqXtzZQvy3OZGCBFitzDqJ0veW9ft82/0pM69qexW/GBLXEWIkmfa+GGAus16r2d4YxGo/7dVdVzL2kBf7fYIxI+Lhn1GD6xEzhUk0xm/eQajt3FGGVsLoNbMnO6BHGxhTxAL3jkHbiI/HRCA23UE3++CFy8QBzcNpqYWIXY9+ompVsiIxsKYAckI33gwsHwNax4NahvVHdggqpJeyUwBLDEI7tGFP+ohYoA44Om7/QD0sZJ/yop9IsGeIK7pivw7QfFhqbQh15bprVuJEQFbK25pUWz0UL3qv0VXk3ttEWfTm9WB2W8Flm1FjAnJvuv5tRMyMJgsnWM520G0s8PqcExqkkGQuI1VxhBjxqXtMPvB2aNoaQueRfqw2UICsvN7nytACmseCarMPh7dZwmXkPaZRiEWwCiO9HepthkroRwLdAaj4tyOJ0ae45Bo0Y00D8TVnIlrVmjpWuCfaDKBt7F1DebQUPJq8esINTQ0+cfAm7Bgc/tLr0f+zKLIARD0rsSDw0nAPw8/Uun7dX9jaaFECd1KY91XxZlDfF27n5XKj/j3TAsuVjJM8JGRt7ioaBWYPsLCnqYR/PapbOws4kS1zKdtdDTYeb0OVtUzedm4e4qzIKuQuEDWhJ1+k97GtcpnVE8ISCZsB1ISDrnJ4x5FgrU9Vu5lvJNd7lWX0CXunHUwOOMW0QUPheBQyGc/1KRpiRtqH1m7diba79aJeZ/WFqSBz6LtKDv/9vq+fTtj8XxsawsrvrjaGcqthlzC7NMEoTL3hc1c3BhcoJZg/UNN3FrRnH0By35bavUUUIQBWvvav0IkZUYT3nGxxsBCS6Azn19iIgtAL427h1NzUcUV5UDhAFzfTCCtXnpf5/QKffJZv2MJtZMv8bH7mWH2oinygBzRBZm8
 FGQigEJB
 YXDwL0sfi3nWZ0H0/Lw6WQPHTd1vYs/38J0tlNqgm2x3PoTGgNUKNFB/kujG/5FbCpxL1kFU+fya4roHmw3Jj2g2/8qArvMfaOzbH2ojHD2r0/FFLc8RHCZSIJQgS6xqdIUpT7oq+yvf4MSL3Zpd6G1oawM66NCT/JH8HvoRNvIaDQLss0e1QA3pwv7O60eB0ZEMDhBeSHjje9Y7Ng2BlunotNSrmK1iWBQT/wzWkLZtIfL4FQuwFkifacS3dr0AhPEbSVbU//i9dq5ROkbkpm5f6skRQCktKMiV+5UVuwcSH5SfccfFJLZ/VAkUY/MHcCIF5tjdyt+BOgk188WtxKz9ukeuv91LYGhDcc4nb4qWm+Wda9u8NFZoQgDsENXyuWg8OK58sQv9zhdT6lGCPCZdfnc2blHQ8WOk0KFn5ar+IO5eOOkHaFAKlrLxM0PMOdnfatjV3W3UE4XWIGPany/WPqBjGO+WZZOxaDjLeTZ3pZOVyI6AM0xWxVZtemgB3/O4bsuAdVI25c7wlnS3ACeHye3M77KhksSumKBqzBaAwsr+YvdVRMrml7FsFi8YqbE/VQ/E4Irn4F0oo7Izuactlf8u9qqM/R6A9eFJ2K7hTKQmflm4h0ZAlc2NS9+hs107feDAjyvUhoPpeYKRylTAzETYSuZa61BSOnOMbLtv+3WNhEPup8ws5+HxfwMCggBeo/dfy+Z1ldMmAKOo636z3/BHWOeq1UJ/cxUvety1Yi6VyO3N/pJVlwAGj/O3nutogMhTbtUQJ8oZYNJRv3LgakpygVh2vhNWUgiFOybNu+NFONYzpb29kKvEC6cOh+xslf48k1DhOexeaSt7FgGUtFDKMaOAsj93/Sd8tFb3AqK/BJfcMuxJTNekqfv67U9mLVgKk+DIMHRgRzg8ftR+KBtLMnqTaegYi9WrkZozUMceVTlIhS3D+ZtZ68G/JHeTYjO5W0bg3oVsEITLqlGBYbPvx
 MhyatRwz
 7U2B8sHHl6t0Q1K9R64rLiukc8kG7oJJUSYGm+h6Mznx+k5H+LitW0+vyCn2w0LlPuDioc2/Drf0qBDZnpcyMo5As4WqFDDi99x5HyLaFhiKSoF29D0YywPYCB7V84OZYqC5+azj7HS4Eyj7SqVLBhDQh1qrgjHX7k+W5OYN/nL+DdMjGaYKIteVhBhbGhl/DTrvzft+j8ySCNPbYAofCNUlrNraKVkTqoehvkfvtqjQwhjQVWm/6ZqyCx/wozX+t7l8wF71e5SIY5sfUBMScfyHId0pm3O0anQRxIKPqAeTTmLfQEOru7tpxVqt88ZEpeDDl2YXemssGHut6KyZTslRU/4aTB9O87B/rfk7/JTIm+uNB+CnpvxbdcDW/B6xa7lGPQ+1egg6mVEZ6oGPSM4ceC0swArI/jymfnuLmvzq93I+50dtHua2W7Dj+9JcCEaPYxYqcbdUjw/1qlT9mN12cPEcxDH+09YZ11tyMGFsSRFTXiWqJuKxfNrHazBC64AOCwREuD0nKqAf3JAO/BvBWodggeDCft38mb5Z/RPvuEWkxEAXjBLIYRTTslquvIH6qO03KBuRtLgJxJ1gJtrttFgMg1Va8eyRZZCQcHZjccww624hb0EMmktusin3MoHMEl7jlkMzd3upViMt4O6j5S8tgCP5cQX1dKUZESXCbjSEebXQkUrptEgOTCtyW98ocFliYnM7Mi80mpsPhto/j9LVWMoP0YEjK6mlXGDwj/nzTeRN3X9CKQX2w7Xy8NgJtHfO9DzzTQw8xzC0VlzZwnD38TUuh5QNz/sCamNLBM07exd42sVuIhtgIIIszzv0EK+kxcUNZVDEKqtdsxSjXmPvYgt3NIKvHOyuXe1BBoiczrSeREM+c93/dQNzC7s6+LGQ7Ix+P94pfIVpzeDwKqHr67rx1sm3BAqQEAWzgQDAT5hMMykFUmt6LttvtTc5hOvourhRc8ckhpNU4xDm5ym/E
 TCMxGIrK
 PzPhiwqBicj4lbbeRHYJJxnLnQfLWrGKtTDDt/DaAphNuQ+qO2yZHfkEaE1d12cmH6T0jxwau6eESTRj767d9P+3NwxKsTagMs5ItMO9rNsdHMrWRBooHWPAoLlNcVh3tuJClNAQtCG0zvJwxUQXS8T0TDkiS24j0YjkCVpI61q6EI+dLZ8tohs30LE0b2RAyXdCTj8FwoW/4YqiM3GVjdSwycefJMRkDrPsmEgM6VN9K4qBS1ki16LQ75d725qOmRJxJckzTarC/Yf2BjCUtesng7aqlv9jqBWjLz7OI/fnMRsHC/ZCGqTwvZZCIckHWC0VA5uDhNg10YMyXGlodRfxngAVumUkfAJ4Tl4DLgRlCoLcK74PVkuRwH5osYZJ2BtKw57BNkmL5qlcnaGbNdAkBJhlmS/Dth1HD7L5gLv3HGx9VbUB3RDCfrAa0oimmUvyyjVWGx/Dk4SKu/dK7J8tiKPHOl74JC07ZkicfxOTeoSbilY9HiC0YK/om6nBY1Ccpvs2m7sIUSa7WSHYOM9E9DorRTNhcUgl5M+gA9w3+fYgIwTJo5unJIFRlZt0zYPvyNZBZTGTMiJ1Peda1KBcl8rqdmihXp+bFTEEEmNLJG46SaHRwJJ7b2jcr/MgmtWzC0XLn5Wkb2zvdo4LcRvFfi9b0WbA2TGgX4S0z8lFyf4Z238ZFNdO2z6/fP3I0wcy7QU5ga1JBg4dvQHb2V5gqdYcMy2+M0UcfenVOJz9YE1jm7FDjNijFSZi3vxN+fWe6v1c3RmS7HsZvM6QM1YUwg6NBHIwan2z3PW6qJH0X354DNVcekRo6tYwOzhDI/psFru2ue6CP/ZWdU7VY8c6mihv5V1tYV4Qb6XcQtwXDnXUKpIRwWTplBD6ceoQz2mG3A7k6xwh/0RvEYQs9gZuILs7LK5W8bGg2GUiBBaHQUtWGPz4NcndwTLojV1uvO2lplwyAmPIyBBPf05+3tPBfnAqd
 wtMoNcNQ
 +SGNixs5rRmwV3OSDFZl3ZiY4YH629dqzC9sDD39MUQ5tJBv2lKTc8ogkufd+GfU/MTwNpXrg9LvAmoQZ6BU609OOktYgzjBcRzsPYN0BGYsBdIUQ3Whpo7JBi5HTdXy85gOCYkQguLoXOCS8eCKfkpzWvZG8YOJC94A2ahg0oFDqJU2/Fet2hL75xA46j68yg0SMQlXMt7eghnPju1KYK6hzfInY841o2tQM4ZKDW2jOtcf/PqW/ewHSngx+HlCoGUBJYdPUEXqrCX6bbw6C2DSzDxnvHgpTJT/4/WdKtuNCFK3dpqPkPTonPvydVZ0VOSURM3fEe+rPoBwdnV3aZbbseU6jSUnb9kEr3PWUNdo87o+5pPVUU3HMM+qn48Dv7iJu94mXnlz1edApahqjRawcNV5lxCuq5jTGHQaBqjPLJhfHSeCd3qdTUVYjhoMxLD53+pGfe0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is if
the underlying file is itself read-only.

This means that mprotect() cannot mark a shared mapping of a read-only file
as read/write, as doing so would violate the read only attribute, and
permit writes.

In general, we do not want file systems to be able to do this for
read/write files.

Doing so would violate fundamental user expectation of file attributes and
likely break userspace.

However, drivers pose a tricky problem here - the /dev/xxx file may be
read/write but provide access to a resource which is fundamentally
read-only.

Therefore we must allow drivers to be able to clear VMA_MAYWRITE_BIT.

To achieve both of these things, restrict this ability to kernel-owned
mappings as identified by vma_flags_is_kernel_owned().

This constrains this ability to drivers which own the mapping's contents,
whether memory-mapped I/O, kernel-allocated pages, or ordinary pages they
map themselves, and so define its semantics.

Every in-tree mmap hook which clears VMA_MAYWRITE_BIT, some twenty sites
across drivers, filesystems and bpf, establishes a kernel-owned mapping,
with usbmon and the ALSA PCM status page converted earlier in this series
to do so.

Note that drivers may, if they do not gate on VMA_SHARED_BIT, be able to
disable MAP_PRIVATE-file-backed mapping CoW semantics.

This is perhaps not always intended, but we retain this capacity to
maintain existing behaviour.

As all drivers which clear VMA_MAYWRITE_BIT establish kernel-owned
mappings, no functional change is intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index 2648fb0e1995..d71ec51255b1 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2795,6 +2795,11 @@ static int mmap_validate(unsigned long prev_start,
 	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
 		return -EINVAL;
 
+	/* Only kernel-owned mappings may clear VMA_MAYWRITE_BIT. */
+	if (!vma_flags_is_kernel_owned(curr_flags) &&
+	    WARN_ON_ONCE(was_maywrite && !is_maywrite))
+		return -EINVAL;
+
 	return mmap_validate_vma_flags(curr_flags);
 }
 

-- 
2.55.0


