Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 278CCCC6B01
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3F336B0098; Mon, 12 Oct 2026 14:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEFD96B0099; Mon, 12 Oct 2026 14:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93AB6B009B; Mon, 12 Oct 2026 14:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A802F6B0098
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:12:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E5B6A95D4
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:12:53 +0000 (UTC)
X-FDA: 85314770226.27.6C44089
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7107140008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:12:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DgQYzth/";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791828771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cE3bSEEMTqHWrj1tS3Q/lf/i5N1uRPRLGcz8J6sy2y4=;
	b=YJ5eEGNuQSne0QLUowcc7HrrfZKLjCY38v8L55EXnKnOeDEiOBSp7TL2QXa+wyfMAjEYhL
	j9QrZYgg9g+Me+2KN8DnM0KDsKF31rSEvmYVN8/gH1MJDMCDfyLKGwfuc5JLZDiPLC0csv
	5r93EQ8KBZQc1fuKXMs6rNHFAOzMdxs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DgQYzth/";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791828771;
	b=ozXv5zVTrqxXGCdPP8FW+aVpmFgYWqKtVvQ/NCaOYpu5N+tmE6NYb5Wnp2AV8JX86i6wbB
	oC/ScavlY5ky/MNM63pZwTMT5DYiI3xueico1eXPT+NRdmZM6cYiKyn0SLGSi25bW8PNEy
	WYxDmZE9oRwdM2lh1XrhmEREHaiKKe0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D282E60142;
	Mon, 12 Oct 2026 18:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999391F0089B;
	Mon, 12 Oct 2026 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791828770;
	bh=cE3bSEEMTqHWrj1tS3Q/lf/i5N1uRPRLGcz8J6sy2y4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DgQYzth/MmZoWmiNzeqXMo3pL3++4NPcxPJzPON5+Iq1S5su3srfSsiLs/CRoSsV+
	 y5o+xBW5wDB2UDULZVXK4Z+375t1dzbNUtt0abqzfCef5+wNE0F8zkc23m9IRRJQki
	 E4j3lVFrh5llmtdqL8iYb+O84Q1sd17qdYFd9Kh1re0RHi4Rwnj76YbarFlQjfDBco
	 wT37cp3+XRmGwpGtSGF5SPeOgjXQRjICCX4Lqd0pIe+Q1BeY5jWG2zzffSTDcLJPzR
	 WjJK0Vf5kjqk84P6RDfdYSn6uJUn28TopIgTD9wsdxKgdymGRHK6Hy3nSvR1UmFnzT
	 enZNuzoKkUK8A==
Message-ID: <4c3e6350-b647-482d-a81a-89ba2431519e@kernel.org>
Date: Mon, 12 Oct 2026 20:12:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 18/38] fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO,
 add VM_MIXEDMAP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
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
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
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
 Bert Karwatzki <spasswolf@web.de>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-18-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-18-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7107140008
X-Rspam-User: 
X-Stat-Signature: 17fyb8iod447co3h38bi9bmwnegracst
X-HE-Tag: 1791828771-855558
X-HE-Meta: U2FsdGVkX1+u+qHQZcPuaNevpzj0VDIAFVlyS6YU7sY/hSmm6CqjZzU2bgci0FZnnxT7uuN00qdECDhrbSMY1CoviiW7U1zATuTyeH4RBlGjYCTpnDhvLKEOHUhMKhJUGVjOeAa1f+xm4C8RtqnHtD7pJYgbHAZCTS9HRZdsYePbqwN51ny5TqeNgQsjehvvRE24rXEH6rqSxNZnUg7dxk7cUE+Ur/fJTmiKaLnMr5LBuW/G6cBDcTDlHDSTCHxxtlk1M3GwRDBZ/fHqvzQLAO39+RxyK24JJNvsBzt2sUQwYxs9pt3wOTMUQWhjCCItp/XBLMU5iPkPynaCdiU9z6jfL8VzG36JrhCjNEY5G8w1qpgAftdWiXCcq21GgsNsBqlo2PSyCxq9Nc1y/64GE2nRnlcaO8NHwdxd06xTbalSEzlZwTfsVk/7e97SU97mkE9CT167BqGw1NN7e/C+3MhqAQWcCfo93dlwHbYtR+kJl2AgWzOH4bzSvW8uf3qC1CyongE1yZbEnmMSmKZm9rYI14VddSMdSLUoE4h5Ecr9jDff3Tk3dX8PPlS5o9fOhSGD39driOfdi4ututrRefGSysSVGwzfC/MBsPnEs/pJg7cc5EiPzFHMnAkiqyPcYZbEf8Xuloh2U2mfg9SRgYOIQKmTuzMQwEgofT1eMBdK/bzge0f4MoWS/3CAR7et1S8l/UGMBuxHEDj0ELepAueOz/Oh96ZTkH08Ct3qn0qfgjbpeovOGHGchYanTUD/wa9CsisrAfwH46tKhlco9MdMh/51Ruhz1ONYXAIyMINA0DjRG6T7OwW5KhFI8VUvXnxdmdwYkDo2L6/qsyeU+6XTRtfr/MUQ3SgneWkg3zLpDrSpT469jp3Hkzr3uck1ywGVQ0GtejMl+nCvvhgPYIFb2FCT5u+t9oltoV5ngR0c/PvEO2AXX3/9s8brwN2qrJT1UEER2dKaXJRdj0y
 QTRBvmVg
 7qh5gKL0tymD8pMtGPHvs9yq6JXATGhsdWpCNbshSw51Qr5XXOnYd3ctfQhiw32C2941pAL8BbvDGu/w7GBmIufLi+JgfMD3OYpg5RPSykuNOrkqlXXXaOsHxkk4aYrUWtVQ1drKOZCbgOAL+L18r1SUhRrpX8hGICGEIB0cnxfAImzeshPoGvB5jgJcYPXAdIagjCcmmrkup2JRdM7EUsuKgbhwwDhfhH2CoGipY0DkAm7/pZxT+7pVzwFaKcYPUhAyzmJzEM6N8V8MYKWb81kyxPqCwKtax/5KAr4XbjPwvnhcULuyt66HENnygaOOLZ+Bo/D+paO67DWwhgLwWiRRjohFzSYMMHBlaI5LsotHZX9l4PpC8c2kiY1mO0adMRDCOFJciik/StEzdYCXdd4T1UTvFlJhrqm/mLLzIelKImJ2HKRrqMDMAkcxahR5GsVeyIS8nyPkTE2pfjV8+kD/ncO6mkzB7jSANmsAvn181eldX3d0VoNGwBZloz1qoo/wae9Ia6YmwQyT5snupw3IMTFd3LjYqPTrrj9dsFMlQlx8tfB3qJKZhj2C4jkEAaK0gAXerFfxFsFWRafYPvQ5CTub7Nw1zHN/DsIeYkMEVnqy++TqUjRVPaZu6eNsD4wkL1IUJxc9py0Xn4T2Gh8//K4ZjakHTJVSgtvk6ee5XJOHQolM86UjzJp+H3YTMOea9rEmsy7GzbIMMH4j+pv+uzZ0reQ1cC/BP5wQ8U687GU9VWDKymr2NAgQbvIStOjquCwLw87B7Bll37sIh2Pr0JlJcDKWtde2bxhhhVWg5WF99yZmkt82XV7chz+cTvr3encMSq0+YUeIG7wfnF40saK9CIqwHZ+IGPwTA6ho2LdIkyP7G/F2O4nATSUzUhKmYBgOX6LF2sc2PL5PNNIDU7LQgh/Dwc7RkYo5pMZd57K+sCyLDUeJRPkIJchXZzvfCpa71dzztYLVfCL/B6eQSdKsM
 56P/iZ2I
 PG/okVVv4ZBcaPhpB0uI17TDdmWXHTw3c2tCkihR3gKhua9HOb9FgN8ecwFpt35arBWtzGYR7+KRMzuymQXQjcCBq5Y7Mg9XpNENWuD3wygI+phNAuXy1K1DSzWrve4bcWlSTk4Jz75Fnj9gcgFosSVKP4T6W3CmNUYDtp66Dfdy+sYOxNHiOYo6XmHfRBDkzpST6lG3ivHXaBf7y3CBkj9W7kr2+RmM5B+JllNr/IYeAWcIwE2beYyDWnumsTIXziQa6/5N0my+tAo3kZAIVd6JEamI0D9+QZ+l+w3ikTskV/e5RtMex0r3kEFmPwn/Q4KhkMtKCToRR1pRZLEng/zTXe6eHFxkymhAgodzp5dWrOezNc4r1mD46MS2ipZreCfsP5Qtm6JYiNEPXHdvLdbdpMjy6JrvPElcul9WzD3VSkj/NTksVZP+ozyRYNmBJ61g3CDCtGsW75ShNXklejW57WhD/jJAyOSn8bzLd1ZdViZcMjBHJhI4qCbQJb49Ep5EfHwoNfSsDCfUl3NAjzOQo0RQP8GC8o2pVl3Gdls+BrbkhRHi6rJNg220k6NZilj69kpZ+wS3tUmCgegTjmWNokXtBtvh+DMgB8rTVfchuS8QM64S5I0GYr1pb/ZdOQ8v7m0YHETkxUaMUKGFifDcMj50bDM+tQ82KdvBkVl4vOBZX8QeoYcZje8/qO1WOJxKOsGGxY9rBNHi5FZxTd/tkCFBLGjAazYV/SKedYNrpiomZYXeTyLrqhETKlUhAfhT0i9tZ0j+opmCSwKmKWRbFpM23BZKFFeowpjCMzSAgQV59S+mvwOy+18ROoogrWjjZC5rQKUy4uUvdL5Sm4dJAJcSyFWN9tkY/0TqJd8oa16nSFze/LOneI6FzmFTFqriVl61LK2isUmE7Vjs4wjn6OiBIiU1IvYHi/JH8AY5XEAVGZgwkwgOGEtZhpoc7C5qwFjC4X96loPhKfsvkgdz3JQnp
 LLI5G81+
 WgB29FQRYeTjxryU6HycYpvmnxMsLDVXoqYlEQsSytqIckhCT28bQn//7brzuOwKUo92dwSKzyqkuUZJHmuXAQ7+2dBlt/v8Jzk1tpNwh2y5beXPveXR90x2raUrjopsdBu1nlPDQUNBkONsM/Fq4tkTv/WSZ0wbdAo9ttMt90lrNpVTGY5OqPh9frnptMnxO2bHMwTBkoNMkZRCK3walup+7z3GV6jabs0qoIF0JzyomPs52zBmP8K6hR2y4OaxI9QJ9bVljw7UlFCfClEwFG07xoOGo6JV4JKRPzGBny70siAL/utP4934Rru/eGWEECEh+tJFfqmMvEu06o0apkOrpH7P2471ZL35ye0h44HUbNi+rSvgOwyNAyHsUfnUoU0iknIx7eX5F51/o9ilOedvv4bpufFtgeF/qfm6eV/U4zc6l+2RgtLaws008EMEkrfzK9m5DXr2XzAsFUgEShnIgZLl4zZDy1chwITIqO5E51aLNC8ykbLsCDY4YkfB5hwXhQsK2QdlqLmoqSf14C5PfmnImF8U337G8pIV+36k/FQNHfppaefXCQNm+CAbPbjl/zQAaJmqpseIQD3c0I8Lb6w+HBEYuxnFRUtO3t1zsM8RhUwyrwZIsZJtrhy0WyBHZJrW7pTaPaDWemDmTjZnFQ1c8CmE9WCZYcglelCmtnZ17nhP8Ctq/gBdqW/U6Sam8v/4Iv17nb+SbotaHka9JOdj0lxLhp9AYBRIv/GrXtLhqPe9DzwaKqzjyY6gPa97LYrmmm5ek7o1qap35YPpX6+U1KgV7mYnw5OlZojBqkAHselktYG8c3m75rUdNzVsKdJS706vUmTA/R/kFJmXpeT9SlJtIlcMFdjT8wgU5jqjV8YP6faTpG7MD8bGXiWrHenxS587mDREqobXWeZaTJuJ4rvF9qXl1ETly3uzRveA0zUA/JquiwifAmUscHcuQ9dbn5NiH9gZHlvbuDdOiQjMm
 MFCyDW3u
 OVbSing1XYctzGLm0gwq+QxR3Ie+I3X0eUx7un4curwbwYVeTv80oRhCbjNTlu2hucZddiG8vryTSORJZhE7Cq17OE14AmDhwpzrTflwXloxLbdt33gp2wsJUJiQ1t2sf27l398xMjK+U+AtaPkezdMT4SCKj8ydkPRrvjuGNMIrHGCrdM0V8B5PbGbQR4jBy5KCU7wKNA1TWt7akzOrnns2PMos5Kni3u8Z4ygiuVc/M1vinpzqW4hwXo/6bTD84yz9pa8ZM0DrduvD+m0tYtzCs9qBvjJz2c0YhCs1Lq/k4fB0R5Wp5JtcpFz5icMzolhWkhkaZ/EoJqu62fkYuMq0GM1ZsDAsvKgoZEFlNz8QfoHnfZIoYeVN03Prq361Wu2RpOZsnb9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> Currently all drivers which use defio allocate system memory. All of them
> also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocates
> system RAM, so simply failed to set this flag when it ought to.
> 
> This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_IO
> in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
> erroring out with a kernel warning if not.
> 
> The logic requires a page from the driver and since commit 1ecbc7dd2902
> ("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
> always required it to be refcounted, so this was implicitly already the
> case.
> 
> Finally this patch sets VM_MIXEDMAP, as the logic is mapping
> kernel-allocated memory so this is appropriate.
> 
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

