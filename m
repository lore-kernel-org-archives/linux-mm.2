Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8221CC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 344C96B009B; Tue,  8 Sep 2026 16:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C6A6B009D; Tue,  8 Sep 2026 16:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2324D6B009E; Tue,  8 Sep 2026 16:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECCA76B009B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:04:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 801921C232C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:04:25 +0000 (UTC)
X-FDA: 85191672090.17.7AC0420
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 91CB540016
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:04:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="np/JQQhi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="np/JQQhi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788897863;
	b=2f9x7qD7zzKW28hx6hUJAkG3l15NxmYDlqchfRGZjo4BHuy7KMrWpy5RLVq/LpuYmmKSVw
	LzC0x4x5RIiGdhKp642dUYQKlJxdsPKj6bu+S05RGaDpQnNkkiRZfqmtncNLwFjTHoVUrf
	3C4XJdi4T8UkuTrE+kOo/EjH04zSnrQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788897863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbRhb9Yb4gDbpWqPbus0qjNX5XJi5UO6wGbL0nzbXu8=;
	b=R0515cIbrn5p3dMku05v3VRPDrAI8WPBxSdlJFvF3gLd+2RqY2lTa+Djwob+syEmfWmaXA
	jlcujcuuQVq2OPmZjuUii+VMQyrf7PRkGgVqHe8BkhrPnteagzqsWgOZdzzs32iTSAmVU0
	0MgW+AzIXnhti4pfeUv00MBpB6STdmk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A4A0C4098A;
	Tue,  8 Sep 2026 20:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D0D1F00A3D;
	Tue,  8 Sep 2026 20:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788897862;
	bh=lbRhb9Yb4gDbpWqPbus0qjNX5XJi5UO6wGbL0nzbXu8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=np/JQQhiq88j7qchaSLG5nKK+4MTAVPV5Cz/tGHq/JRR0GyrZjG7aNu4nPxIBia1c
	 jxac+RkNG1cGl1z4g9eRlXzaCXAbqAkvsPkLIrATIct1AWudgqYZBwWohxnnT3WSWQ
	 YiA74xVHAsTgahglVY85Lg8X3snP5j7qvgAmsk9aiVkpC3AZ4NfifYUKvjBafriw4B
	 UQSWvtm0tLvagxTwX7bNEtXNA01kKexizL2SWm/SuAEifeoCc54u49ya9tW9AlrzTC
	 tFzHfaN+2G9FPnBpbhcQPIj04P6m7U/FX8Zrp5dY+eVRXmY5qGs+wh872cMcGdMv7b
	 mU8+hdM5Yt1Vg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:08 +0100
Subject: [PATCH 04/39] mm/vma: ensure mmap_prepare doesn't set actions on a
 mergeable vma
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-4-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1311; i=ljs@kernel.org;
 h=from:subject:message-id; bh=S4K4xxOQqYF6aIxj0t3GkPHnntUAtdbixR+JacKisSY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG64mvHudrS5dtz0Zef5H4ZMmtBj+u3ouxQnCTeBu
 kCOVR3dHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZgIexAjwycGkz3ceeXz8uek
 5bxS9eCxT72j7DFdY/FCsZ0Sti4LCxgZpqzNbPedJSK4tdIn2mXq1+UPbFJKX/pYL7kwpb/4R3Q
 CEwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: 91CB540016
X-Stat-Signature: 4edb9z8r9pa1bz3wxnxh8jotnhr95rx3
X-Rspamd-Server: rspam01
X-HE-Tag: 1788897863-762727
X-HE-Meta: U2FsdGVkX18gnsbRTyBoj9n0H3Depm2lpmrw3sp3lcvIpBnOEX0pKLf/Iy1r1AJNHSlJLwE6wqpaS7GJw0400X5z9MEs7B6MDy+7Sxkg+/2LTMqchfKc7yoktQH1a42SDRUfoWqfGdz40scnfVRe80xty4U3FUQ2u3AmeuzaYU/Y2hYMZ6VIm3Tw63yaUqmG9sqUIuN4Ly9x2en87KBcSDGS0OGSvH1fMrws+drIp4oC1yHGTeqiRD2oSVbTYt0KlVMvSRVzMPa3xENI32c3wy88c+dFnXOKXwjRYFmkzTlceerbawNmTXK/d5lmKZRBwEVTe7NrQ5tcZhX713ouAjqi/nlxXs3tYb6OLq0A0h/m+IsesIdI8euwqeym3ZkslpilP8QMTchipP35Z2yTztAMSmO7XiCU7+tf91ZyFF3VdIpDKS255C+JSk/0L+uHeYLL40P9oWzb320gh2dRoBNcQiuUWDcZj6vSoCtiLPO+V4L+RWo9mAAgHDIPDDwyoLWDjf+vRwcUhhcMvRbP7HFXoeea3B5ZSleIuPiYNgofcfpSlb1qZpVgclppjH/w0JiQ8twXp4OT3dOKq9UpkeT87GSR29DLvlpSEO4ZRzX5zBQyXlLFQJQxPF1VweHEGnNPNXsXCK/Do1dvMTyHsrKXShE2xNBsFAEli6K0mknQkSdape3ds3VJnERQjg65m0hAAF4+wqGrU5QqO2VCl7UvE83MgEhtN14bHbVc6XU9xbZkUByKkyYNE4BxNZdqru6ZxSLvEZynCBWCsmag3SdSFCHVy18edY5iTy7Pjb/OploV9SoD8gOeCtHEmcP+AOQ/YWPAOv7uK5eZUsMXob0r63KNSyTPl5icGU2P98Uby99rHznIfVIYf3gVCcwFh+VYI71gFNUc8bS265G7DkuRvV80BKqh/1NjMK2CZOHs8xLbeu7XfqzeYVTXY9rYnEEOQKv+trKQIiWZ07X
 /4xJuO5I
 JHmDanfMhJmz1KaQJ0P1RLmoOWuOrqhQ9dyIok9M/dscZqMcZSejjH9iwzRan/9aR5GZo6Cq16Va0NsxE29WBObJSSznFgrWOxBzI/nAg1MKJSn1bvTM24kX08JH2UTz2GFM2K0Y0NV7RL/Zn3bbZT16gils1VX4kaHG76rlCcusCcQMCWE0CfGLayMLhA1H8L2N34jN04l1uYZ3Q5uZRfgexmVp4AjodUYRQAKzcjLDWay0NyWWRO13R6pXldJHkM9TFv1RrKpA5nfi+UHER3gxJVC04dGpsjvMMTredshuy2ddCRG6/O9WH+2rKO+kmbb7kuUhgzhxWQPuC9GX88VYASTrqfaVwt0ozuDhERrsILXBLx928qcOrtQI1QxM1IpaQDuXuHXCwfbDJQkHgyRGBxZ01Z37l7IygsnmKk2hC1KaAolXhwQFHWI40pbCLDJ2gxayqkc6m24j56Y7jtgNNqN9xtBOxAOob/4BkwGJcZv+Acptromm0E5J2IQwOImknkt3D5HbafEslMEu0JrfxEKBbccCSoyD2CpepgwcdELS4Ph0BS00mEgfllgGnPXWagiP1d1Vj+nBNycjyEtreUDueoGal0LL/of/qrinBhK6zBE6G5O4bnftpt/3fbsSshs5u/UqjdBvOwmOCs+Qx0Nq/Gj3Am6hBKf3fFDt7JQuxocMWHeV+AaUgmOGUP3AxM26Xb53ZKqH/UjAjUZ5Nr2SI8jnBU0cMC9SO5RLngFArPo8pOtlbprX9VZ6Q7r0PvzeR0cDNjmMFPTswKgvKQSqzIJejj1kBiSVLBz4RIyrfdIOvgxKY5T8DI6HfY+OKC9pAeTkyg1qEeTAmLPi2W1+Tc30PdD0AN6XasiMIpVV0/7y4hkUuer93unjK0+9Aq+pC/19Hn1x2GDNLO1CAeGxbyYhlHnjiljgjQS6/8NfeYexx52sr8qHDf8OTmIW2OQuvwiwSnR7FztKYsn9Xn+BX
 WORHpQ0h
 9F7ZV0YyMQculiNsShtB43HQnMAHhMyqRV6QLKNMjbntpOHqMGf8vtven+czec9HXELywcorsdvc0lnHm1TxTIqrnFKp8vp5Ph4DplJzObH/j/AYOmYpmXsc/QW9ySBuLSAF5isPdXM3WJsi7eW0Nwf0AYku7oKtu64otQbBKkWIMyvQaalfRM9zwXLGr4Nv0TRfFvgfIIWIaB77UtVM20dHngD6Rlbra28bMmNJ1yuThqxIDlhQ6XdqPeKJVpOczSnZ0/Y259wJoE91HjxjJ4/MC3RUgK6bx21c/v5YWc0ScrYJTKL82s27QO8onmQrtN7WYEpgBTFBMNElWD8qEsdf6rrSpQAZO20RNcVpI40yey+h87iyZ1ozzq9t3VLvvMn+MbMunnxfIAXIrnJxULlnDZm17ed708iUqUpy0CJa/UEmYDubsr/G7T0qWi/rjmrzQ2HPkFi0d/GtjdJGo1451mm+s0E7fAeP77OIckWaHU1arj+PlCrMerukh1aJPCrmLg9chsHvI+3bpNEA7nxibEEbKPyDRd+zP7faXglhu7uMNogDCs2zviHlergsyHrnlEPnNprKBpijhQb16u599uqETmuQ3mWbCAyx2pcOiXxm+zfBIZcJOOWucFrnPY/a2USPlTCx/39a5ZP+pWUr52fICGMVOvzHCUC8uCbNav5hcxxShqcV+YmbDIz7qYVQmStqgFkPvS3DyJSdpYs/yn4+2R019+IsLb1Rg11yWfk6mNP6IFrE/x9yHa5HUXYLJwtQd3Laklume17SPrPRKv11eWZ5/oXgZiFHwN2YiPxazDnXqdPfOEIeNxRzgJm6uqrJ3trpt/LRfH11ASkE2OGrBZY0/etc1RQExlvYcLoCkMpXOX62IeoUhtCq/dzocZwG2bg7ZNPiBC0qAIYV/drXeZmSXvmRkQkZcLWABk6oMAkMNGRQ2EKoVRhWRROF1kheKzqH5QfKaMWqViD6We8Oe
 /hBQOsfm
 WvCvT0hHgQlnlVY5r/CAAtDBLJ1arSBMzaSFtaludNxQtUZO+/fmHfspq+pZSVdOADYv1sfP/70TDGUg56ogONkLbeU2Voujnll8YHubif2faYUD1YEUwCkQKrr0v6JLEInCaa5wfAVzEq0hEFegrYGvuqkHLMaWX7/fLT1Z92b7mmNhi5k8/GdWwFJ57Rjnbz5e2rEImCFxLM3XcaJZxaS8G5RgN3VNVU9QtY0ehWyPu3wZQlkcXG/yFUM3ZxMwI4UtMRPwElPKlzHBu6rtL04mrxlfYGiSJT9JFrZXwHi2YAtiy1KmrK8dz0LPvf07QDg5HxxU1jafnA1kf8y9y5ex35RUh1VPmzgJFvoBuG/VFDsnYhZkvcYecBJQh6zKh/xbn7Jpi19+oLhkO820OQhM5JPl20E1jiyJc+p3EbMZkRJAiiZBEAlzmd6EnLj0JNvV3EBCLfbrJ9LJzR3i83UxE5Xs8Tkkw4IQttR8GgATg5292P4obTLekVxNtyMclmS5n0YxHcrPNAmj0HeqhHoIpRdSYRp/tHLyge8yoR8kjk/L8T3gqa5vE66ByWGs9Kwn3qgn3ujyaz8bGwVNM+R+1vHvyJfDx+fXHgTehvGqT6v5EwT/8dLn6UqX8a6JULE91aIPOjBu+EajlL5bNQiGtPDd4IwbpIJPf40rEyXAFslLhm+9+vEwmwLhsq2/rRHCGIrHEx8hF9FL/0qpvtLSD55uB0Mx9/6sL1jdPIQab8ql1AH91jh4bG8E+GoM9CtNyrBqFdZAUq9ClX0ASD86gPSeiNAhWLLD3WxCOT5qsFAVOJlobgO9g+EpH9k3pMmOtoQe8b0BErFOpAwtRalgfWCRLrAMg7Og2T4OoN8sw/BE3+XmoAa7g4XP4B/KWrcYGdcLA+1HkBxzYVfBq3lSq7X6WHRm6POZo2otGeXxo4J+3L81YkbsKhAwuutFy9++/jXU4YIA2rf/ecL+dRLXd+hdu
 UPEP6eNv
 zr8yX+UernLrurQmYuGhWFjuwpHkGpZBGQmOKnDp9n7RtG9opB7ea1RhWe34stJHlhgpqgTAOUyH9kBVvzpn4u9t4t0AY7V5Gh5p8NsjAiNX5HXHUfGcFepQ5zitXnG5E/m4b6ZKq2UKNO2OOkd/nRKH0kJv5OxlAgIrVDajFRRooSbw1m4AU4URUVcC9IP6mbku9q2HdkF/U+A04wCGpghtTG/6d+frJ7eAiBqYe/dqGGKMZEXSoI2ac8c16Og62il9tR5djBKxQMp410EMmYEpa6m9u9kcJzQzLL2hU9cNUyCzrY5ACaedSlem/KZ60k7JBS9qK2cHvC4EtRXs/+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a user requests an mmap_action be performed in mmap_prepare, this
involves populating the VMA range with data.

However, if the VMA is mergeable, it might then mistakenly be merged with
another VMA without having populated the range.

Every mmap action currently available sets VMA flags such that the VMA
cannot be merged.

However, to ensure that no future mmap action falls foul of this, assert
that this is the case upon mmap_prepare validation.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index a24f04428580..9e45fc83f74c 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2794,6 +2794,15 @@ static int mmap_validate(unsigned long prev_start,
 int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
 			  const struct vm_area_desc *desc)
 {
+	/*
+	 * It is not valid to execute mmap actions for VMAs which can be merged,
+	 * as any such merge would leave portions of the mapping incorrectly
+	 * unmapped.
+	 */
+	if (vma_flags_can_merge(&desc->vma_flags) &&
+	    WARN_ON_ONCE(desc->action.type != MMAP_NOTHING))
+		return -EINVAL;
+
 	return mmap_validate(prev_desc->start, desc->start,
 			     &prev_desc->vma_flags, &desc->vma_flags);
 }

-- 
2.55.0


