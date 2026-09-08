Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74ACDC79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800D06B009E; Tue,  8 Sep 2026 16:04:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8A76B009F; Tue,  8 Sep 2026 16:04:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EEA06B00A0; Tue,  8 Sep 2026 16:04:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47BB56B009E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:04:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A513FA4D2D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:04:53 +0000 (UTC)
X-FDA: 85191673266.17.776AA01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id CB8B8140008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:04:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgNcJHrI;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788897891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=un73ww+h8zBwSSl+qaFjnff/QW4HiQeRH/QM5IZ7ncE=;
	b=P/h2SLhcSCNMqz4us/WX0vVVaeJ6/Ti9oEJgn4sf9ZAcl1d+sf/QmHgGBF41F+sUrGO6hL
	Z2kMYheFlYGSP8gAOKPWy91ShAU4W58Nr0R3mYquhOHvXPY8XXJqz7HXnBxrxnFF2jgE9k
	plhh6xkJSBVT04memTu1T7OM4/hSDxI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgNcJHrI;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788897891;
	b=zskTmm1kztn50A1TKFAlAVmaToZE66bjmFmLxRpNd1A26suoP+EO8F0DI5nIOzVTcg3iEa
	D4J7hzhj6BaEx7A7bKAfMhg7q1ftozsfjYOaeOIm58O3cNrFXILG9Nj03a1r+vDkd+V87A
	DNlKhtLJcY3Plbt+VXap9BfELA9aElA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B024402C4;
	Tue,  8 Sep 2026 20:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B05B1F00A3A;
	Tue,  8 Sep 2026 20:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788897891;
	bh=un73ww+h8zBwSSl+qaFjnff/QW4HiQeRH/QM5IZ7ncE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kgNcJHrIsAyP9FoHwkY/UlNNKkz2k1exmVHpc/q7NXsHR0SFsicZXr51FBZCHVzdc
	 m6HagKOCrN7Ge1YK7AWXl9byvV28Vg7N6f+XFYR++SRYzgYNIKmlyIHN9TBBmmrt6F
	 AbeEaN6wNEnuhMenXUWUg8SuV33kVn+FxhyFPiNPkRuFA0j/gKEnKA0xqRdJmXNI8w
	 1UwwMhe/HjHfMme+Kh7/PuPwzfrZJkVn3yjVibx8FnP5bqCns4nHZRjJsUZ9rSGFI7
	 1CT9kO3YPQKqqJgPuqD0GGH/MMYNBBQnD+zYQOzFRX3cdIdl6bMV8Ekx2/1NiA9FmN
	 dsnpmdIQrykBg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:09 +0100
Subject: [PATCH 05/39] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-5-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2508; i=ljs@kernel.org;
 h=from:subject:message-id; bh=C9MJkh+gx+24EYH+MHri5nsCtaXC/IaliXlE/6c5aic=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG5cwcHaVLPiRXXgSTG7mzbqjVFyG1Z2vlIWn6ott
 ERJqTe2o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABMJq2VkmCfI3Nx5rK3p+r5D
 518yRk+UXt4ooPTvc5Lve0meNsVJkxkZtt6XqfUVPcY18fmmojv5yY3i+0V/BM1+0nA0a/lth0k
 C/AA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: zozuydipnr1duimxz966398dazg9d5fg
X-Rspamd-Queue-Id: CB8B8140008
X-Rspamd-Server: rspam07
X-HE-Tag: 1788897891-271569
X-HE-Meta: U2FsdGVkX1/8L0mY1sQWhAQIlcELG9JOJI3lAKjIBRNhAJQXUpKUnYN4YJkaE899UAObFXTYKm2rJfC0pcti2tyqSBANxFoZWsRDYmuR1C8ZiBWpFWd4l/gPDtXI4vPzdcVOuCL6YkC/mN9SogjIpt2dph4XCcy3ubzidslfj1aSn4hnYfWIgNm0fGp9bhzOc4CzzwWGaFynRKHoBrIgAaPD97D/3q9Y0DqRxcuMq9Er5OmPRXsfi4pWw/b7HyN266hgDYMnseA/0ke6xjbx75aDWSl9pDpuE4Rf2HcW2Mm+OtTOPtipYKzH9FTRgUl30NgQpwz5uLKMFn5gT+ITtZskm1LGivBit6UozPcHueTraWRjwMW53+u4RZmffi0du5c/f2AVV8o/IyZUPrzTNtF3/4h8u4Ve+MauIE5vs/CKIGgfYK+F+yS6gmZGYaQaqcEcqI/g2331plGAAhmk94zou9o0tTeBPU3EOVYCH1WfnYaI4vvbjC03uX9kDpyb5yqtkO91YpYuIsYYq5aJYv+Act36hFpkzvHedCMJfQ+KCljQSUNVNQjWQVAN7dVY1UFujDttU8uAfndz9t5hb3FsESGXvM5ojcAllDb7DGOef9w67M5XU59jY7ZU++PqL3CwAs06HnmgqtAUMl9/iPWcVBIOlTl+idKFvDqcDRBT/E7Xr3p+Mrko/YmFYH/CtRRvQ+wvsKdJfPSsAZleWv/wMMR21ja1FYsc38mjGNuibhk0BJq61T+UBuL06JCLPsp4uKV2INOmAvGBcXbX0loXT5U9L6bjPIy9Ess2gBcirvBi7gLjk64PxzpmOuQLdYtAAFVr+2CRUQntto/89eL6lmDOvDazDpWp5Nj4PgDax8dJXVuvzQth9mN6HniwYddmPxbiZP5VmjJGMlCVRo5cX2R7jT15hHOwogdZikTYJV8NQy1R6vdZCtTyc/tuXxzNZAjKemmnsnTI6GQ
 TkJOfd89
 8F0aNaesjGDqyX6cDOcOHBl/ZjfsU31fQB48T7IWjP/Do2dxRVY0ss0CxSLMtjl1Jg2h+U7TWQhXd+PMMh4bK95cKXgvFYJEqc8pXuz7GUiT2UllKMQEP0fIedt+ys6/x+D/memj1XeUkUcNxZLXUoZeKDzCGYkUj/0iTgzD0MVlmJL+N7wWoKHq+h4m8ENbMvDnxV9yc3N/adb63a3qH50cx0aVFN9kYrtFWXzKbUvR7Vh1C54eBCm6S79U42r49AgxsdgqMSmqCWIPSaia8TAnjXvjq0iQNzwgmI+B/bsSsrldqReypVDMzOFsn6jlZPdLmQMvhBuz6ODxDVDOtLdXn6sMeVsKd8GVLHtFJZR2gM1a+OLzpUAJzU+Eia4sBDRqLab6c0Na3koHh4F31rVUWspIWW9mE2bnRDnEYGnW6f/z9iGrcUFZyZmChpsZ+rVNAAdNR5qG61WxHuIc1yK2Oip8Qt3Rzd4GPhCn/fJ0jukwAUkGwlHU+exEe5jxbTWnel8KekXWm/8+UM5tlTVV2Sz/LGCKPANCoWCsuwuTKw8ynYAGttNnXtvneN3Y2ap6kyTyZdZp+1xaNN8CwpyBWOu9/qtxeb28F8ktiDQSx2WPYfgdFEkRn8XA4OM0vTrYBV7g4HEfccStWn1v3lUB+kDzEfvloHHR4QF6Rt0ZmAXO0FE5yl84vPXvBOmOYngqdE8EXXtwgrWRjAAyGzbyrOtuCxOvrjAz2yUXjVAFNW895YLOOFLiX8ZBDPQfVNxiK5gz8391iPncrkR94JUiXemGgMtIA93+DQWGjP7WpsQM1+IF/2G5XoLe7tmkXUXxuVocxpp9tmpn8A/rOGV4UolMY4FQxg/Vc2sMyHx/Sgt4ZxdCI0ItI6xkzO0cmeVwsHT4KBi2MwwfvDsUX476c8jjM7eI7d24VQ+5PguOWRr14ah5kg/dLRsRizWzeFMk0EnAkD5w9ZodNQinGlYou8fB7
 rzdt3sKD
 xyKQY96MQdXuBXKV7mUL39RR7qb7+qOMgIIplKB0Ob8nbqpCCHNb4g0sCCgrLjwCa4dhuGAUQtZNlls1aU0kiHq7iZZ4WvBZ0g2zCRdUlPiX2xlWBHdk89XbmbUKIv7WupfWMYJgKDEqgX5ffiy+tx07u2sJ5nEk3TKL4H9uVUuMoYtdShQEpYGbDdAosQP+2htNxdApdqXiag33M2itIL2tXDPFNaTsb8RRxM/UhN5NDXPpfgwYDOm4sEygKRrv2KQLxM/8Il0rCAkuc+hGKcAHO1iLTl/6mx9qzIu4XBYRNLbev2aak2CjMibAh79Cb2hurQe+k36mPJ792rffkzzC7tMh6/vJByG8uR4aYjbFasQEEVCublxywkPgIXMyLWQehJDSXYlSCJHuIm3cZncOoDEKIq2/TM7NBTsADyPnFh+aJnvLKQ3k7/19Vl7w2QQBgLnrMChwFSHCba1VCuDaWxjWCCqYAJ3sSUE4mJlnqxhReYzEQ4Dw/WAiMVo3PQ0rY3UB81nbLbxJBW61Iq1Llsf5HoOXcbBkdvtPjk00Hi0f+3oM367q/Os9Ypgq+NZjn1i1ZurHUIL/8hcKyezpGm4TAB/8rRU6OjehrSsf0JT75Ib9RCC0LOwTSLOXgwmbAkSS9Sy8luxKlc4XbFZyli6cmZk2tpHYYbCVoOfs8QWF7jX75eBHb4goLxnsmAWGL89hrIX+inG9Z79AudXedx2AEUMUs7ekbj3rZ01/Vfv60/0UbisKJbA7f/ICyrsjIrMtg3iwUfm4zEW11xLgmHjvBFGoaATTH/I9JIc0LCLVfx5OGpbTAElbC5ZqdMBFYnochhccWGgnPjR78QkHxsr4HOqyL8QW2g14fHJkvBV8xWdMy1XNEJTK7BXNxE+h0tuLiuXH7J3m6ARrHewMSoF2r/YYcd6wfkPk1hmQ1U/gGEuaq1CSYzZAv6hFYKheZKBqvYls/ENmsXWpJYFFYqYM2
 jQY3e4LU
 jnwxB9eIHTnjSllL16hxUkB6kgXbGQukTILEHdkcWNWg7gge06Q3DPHSk707/CAvp04wezEpsS08s8yzB4i3gP24qtS3coBG5kgfdww2UEKg3ifP9rrZyRKl1yUh+RvtZ3qUvRfQz3QxZ34jMNa7i8jkQF+lVZby4rWd/d5nLJLkt668abMj0ihXw8M4wRHtNdkozRJYvErfRvTedecWDYmwe2kOAb43Ww74Y4N99sEwvs+Zwi9jMhUQGWduJ3b4HhdpFPH9DX1U+MPgusZY09G6a2JU6AV0QQQp8RVdHyPHmCkHg7Kqik2PCqCSJVPUsDcTOxenCl3kAZK1NMG0mHI8ySAN+6uihG+V1C50Il7TNGPUlzK0mbH/cO8dAr/EnT1znOSYn7HbJtyeppYg6+v/JEZOk06QQ0hgctOTxxmN/NImim7P2bSoBXFIFSvhl13zdWM8mIX7qJ2wwJ6oknmCv8euPe2jOicQA//qagc5jy27WkzTPfbEEOpwP+gnyGgcnYIek5xrrdKnc+/Ci2ctwGeLobHVazf1LNqJzApjPQWnD7312tskpPuSA3pGuFw5K59nsDGAczaHFl6TUHgHsaNA7jjE9xTVD2DymhgoImfYpMk1wZ++DVi5G8D4u4OtET3WSv5UowFZJYZ5sH/x0oQquq6BJq5vTF1eCtgTHX77mJGviyb6RcNRdPukguF+0XQ1rso30rjp4qj7Xo6jJe3+c2vGMO0BULhfEVyMlRAYgbmGO1lQT/LWMWLqlUFCSeOFXm+d08MUl5TV4Yi3HOJ2UZOyOyq9Adi6iQ/McTADbgrqHFLnjcjzPCZLJE/NHfh1pcMz6dn4DZWRJM3AVJ+CV6sbvYuaN6A97krfxEyFd8wFrR3fh4j1Upmo7t+qWQLsC2saCjQTgKRbKmXj68Uc8xe5fGI+5TpVHEvZ0K+abP9ISE2Z0jnDwz3MkT5Kca5UZ537SXl/KkJhoSDgJQDPT
 3vJBrrMU
 gWDVnI45KKZOnPmZcl7tDEd1UZrdtxhYwPLb3kCzUtqVeJCPoUreQfqaFUNGVghiUlHJs5pOjlxJhKvmu/Pj6vknKBDCFGyBZlaGDnOEVnwlVlk71qKXCwFeTn34TeXFLjG3vuW3CRWtqOvWmM2rfxag5ifOYbdg51jXRDnNmj3lToQd84b+GkKhx7/y/CCoRwt6i88GDi+UE2eQU1iJCLv5cNMsYjapU0RZWojWnggA+5ySFa8grucc8swc/iVCYyrHTEsAEQ7wX2sEOThczDT8Q3GiasaAq/1QcaY4Kvk6ulMYAYHbrbBoal7lOqzw15omjctYTEXMSKVvcZn0jU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no reason to export the symbols for these functions which are only
called from internal mm logic, additionally there's no reason for them to
be declared in mm.h.

This patch therefore removes the exports and moves the declarations to
mm/internal.h.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h | 3 ---
 mm/internal.h      | 3 +++
 mm/memory.c        | 2 --
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 83979ec28f5c..5709b03b6ed3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4768,9 +4768,6 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num);
-int map_kernel_pages_prepare(struct vm_area_desc *desc);
-int map_kernel_pages_complete(struct vm_area_struct *vma,
-			      struct mmap_action *action);
 int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 				unsigned long num);
 int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
diff --git a/mm/internal.h b/mm/internal.h
index abb0fae8c637..fe93be1cea32 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1517,6 +1517,9 @@ int remap_pfn_range_prepare(struct vm_area_desc *desc);
 int remap_pfn_range_complete(struct vm_area_struct *vma,
 			     struct mmap_action *action);
 int simple_ioremap_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_kernel_pages_complete(struct vm_area_struct *vma,
+			      struct mmap_action *action);
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
diff --git a/mm/memory.c b/mm/memory.c
index ec63dd6212ac..dc38cad1dcb7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2628,7 +2628,6 @@ int map_kernel_pages_prepare(struct vm_area_desc *desc)
 
 	return 0;
 }
-EXPORT_SYMBOL(map_kernel_pages_prepare);
 
 int map_kernel_pages_complete(struct vm_area_struct *vma,
 			      struct mmap_action *action)
@@ -2640,7 +2639,6 @@ int map_kernel_pages_complete(struct vm_area_struct *vma,
 			    action->map_kernel.pages,
 			    &nr_pages, vma->vm_page_prot);
 }
-EXPORT_SYMBOL(map_kernel_pages_complete);
 
 /**
  * vm_insert_page - insert single page into user vma

-- 
2.55.0


