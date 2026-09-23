Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB8BC9830E
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DC7D6B00AB; Wed, 23 Sep 2026 11:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B4506B00AC; Wed, 23 Sep 2026 11:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CD46B00AD; Wed, 23 Sep 2026 11:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 139F86B00AB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:47:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C68DC05FC
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:47:15 +0000 (UTC)
X-FDA: 85245456030.21.CFD2F4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id EBD6320003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:47:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EIHX04oS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9s/BYxYsxmIUd2ggYhNRz11koMa/mZl2NbZ9+ZbYI0=;
	b=NFNXjT/VW0dM2MnPNd6YhlgtVUueIm3714yaaaDFSbWR1212/iCeBCjDwgf+0AYw1KJViI
	VWeaL7fpaZTc9zyvOefkXggE5XHFBCYvdfrpRRYzkkkUoBUcEcAxgOeHTqA7CmcOEtX9Xl
	YuRkZOKr+ijuh2XnOLxUq8fSAw2yynU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EIHX04oS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790178434;
	b=s09TjxIHg7pviqNevgUOTg868X7ei4SEkwCMU20U3dE37iY6+ikOnItcJJJPHuwn67YPM9
	xWOrF/G2u3ypyqo5VSH1zpKxYFAl4C7WXlUQAjvRJypv/3l5ahkY3PjafJyD7J7FGVCWue
	vMIE+1GFGP3TUrJ5UqH4pw88PZguqVg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31A44600D4;
	Wed, 23 Sep 2026 15:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D111F000FF;
	Wed, 23 Sep 2026 15:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790178432;
	bh=A9s/BYxYsxmIUd2ggYhNRz11koMa/mZl2NbZ9+ZbYI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EIHX04oSQJKo94mpzbyGnEQxAzsufArn9Dgt95ktpFqZxe3xWv1YBsUqm4+kBAxgj
	 YeOd6h9VANMyGKxodACmnSQBggFcVeQbaJ6XzAdB/bMrK3a3z5fSbzkL06oPNtVpyP
	 0iVeTcZz27Uq19vg805MtbGVQ4RDGmUIxJJSL1Q7OMXjYvaYd0CaySGe6R8SOzrTAa
	 cncsHzspiOHvV3P4rHKhkz2AWVSpblm5cxABgQxwx+6lz5bCwafz575cehiQrKU3OE
	 uoQkvgmHT8i4rSjwR86iyvQJTrpmbdAQsVmSOE7LaE1elZPlB9KagahIZQFEo9o+hm
	 X17tS4JRWuhBQ==
Date: Wed, 23 Sep 2026 16:46:42 +0100
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
Subject: Re: [PATCH v3 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <arPw-ivHytA_YZTQ@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
 <CAJuCfpFe+pLusPy-xWYHp2rTP1becBb2nhX16xXd+hKD5Q+Z3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFe+pLusPy-xWYHp2rTP1becBb2nhX16xXd+hKD5Q+Z3g@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 51uuk5aqmtyecooxfnrf41rg8yrgkrix
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EBD6320003
X-HE-Tag: 1790178433-202729
X-HE-Meta: U2FsdGVkX1/o+eoVUgBq6PuQm7crAh6FOCGeC0SoLZB9MQyGHcrnZCYWUY3xcBrGDe6cqifZP71QuzKZ5jpWk2uW6eSRFjzdmqyPfAl8K4yfbfXtR1SY5ObXmPqxS2zkXvrze60+bIEM7rlsw+0YPgeL91t6X5ToZuvT8GRBjHhB+ZizNwvqgDLvqhRiB/BM+LtczIWXka08nkbTG169XTi1oRLpaAegnxn/ddqtVFKBxL7hM6g3WsGX2T+Iic6eyYyzQ6hFmecRhy7SLdFXm2xUhK5wm9tRwmnKk5U9d8ACSn0x9aomgbZIb6SPifVAB0wbIRAHQFCVubJgUpQJs9kZdsNUl/EBSn3skhskXqP1RPDuWRfa4FAgopjiW4saB4qTGBDEfjSjPG3b9PQaW3u5oZfYlGpQQSTqzIHoCHHVMxmvdC/nn4oMszvTYXcAS+W2U9TGTMuj10+5zZsT6c6cZ1rQuGJ0QeuNJ+ed1FjpNzQXbrnv/G2QgNZkq+u5KsEy94QGUbgTJdLBgJ15441L4+FjHZh2AzMNh8GHrhr1X17D2HCJ4sgFjP/m9OToEswfLvlcxapGm1mRKnCYo2I5sZaVu5M+QOuOLPTcdTUXD7cIvAsh1UvBmOOrxHGuKuLh37BaUlXiOr3sZeh/pIBmBG9yqHYRhPauIWpxuzgtC3asrwlm0WoLY0+tn48n373973GyNHFQiwKsfqCgf7Y6vgn1l/cZ7L72KCtLyvsKfOzUgRwUuJ5VriZtzTT4oj7r1Z7NSXx9J2hBXkDcl1H9kSQDNVxGbzOPGeLFj2d9K5a6ns+1Nq20bat1Qx9peviNH5JnqjCOG7OsGj+ti5YbCmN9+LRB1Ro5Ts5oprQklXeFDKF2+gYVTB7vBmmCr/FJLKLhprAMkTSu5cpgGqitaCjzfc7rE/edLMSR2E60INYfn97Ds8hTkYPO422//tZDJF1h6SLu08bliPi
 2LZvHPES
 fIdu//bYpu4C7Du6MF0WgnHCe3FYxaGJEA3Xq5+WWV0jJvHC5qlytS1RTZM999i7CYy83qaCHbTWIc1ha3RvC3jkpJaPgYNRKgzv8CudBxZa9fzgfruL6VABoV2iyF5psnZXHq5IsOVsfNZlpBj1zS3ZD4lgXHYhVw0fcRE9cT68B7fTpVnXvH4afM393n2L7FyKQ1XATVj9fWxevIkS8DFtTpdL+Zc2i4p32M5rnOp7M71vXUDd9Mg59PYMQJYGC7HTCMjikmLN9X6XxemRSEhs4qgJDbbuFSk6h1Uejp32uVOLQ06HVG17jRuJDP68TLMQkvorqx6bt+g7RGT+b46hUGCN9/0w1/CmmzbxZWJ6kmrNO15Nu8dH5E277BhbWViMR3w8fcLPmO4Ca3xh7OeJ/RsvRAcCiF7f0xFTH8L7J3Rtu6qaxms0HY9HkeHMeEG4DYoOlA4+L2vhbSdxYDUCXU4Znm8L3ou0CtBq5gu4htNhinRkbHpSFAdjDs3QREUUHUyhWzQSA4axbbsGZFHNy7W7+nCzj4GBXfB7zhTysGIuzNDXlHjU1Wd5TOex6O2bLHbMouBXVFGfYqN5OzwksR7eNJ/VVrfOVgbgDCXGEkHvjVHfcuTPnjn0QxAdksdoFCJBpYZ2KWRF04eXzA9cmc5Jdg7cDkR6iGzjWl1q7/30m4LTrfuE0XyWL9y98e7xW0Ylot6aZlke/guAgfMmWp8PRHsCIRfeGa2eWrXDgD2ZZLcDsRnt/XUxg7BB09hNhArH7OAjlnQwR0mnrbE6k9noIm8dtDzPxAA+fI3aloFRCfG/qeYtloJbemxzge9077TjEUt0f1z63U+JdkOy8iymZVEi19sB9Hrp7olAaCZs1HE2ssLpkLd2OKMGXEFlN+vqKnuPvts6YFymKKiwCqqF7i9DEshQ9jwg8uMbL00qFOD1/9a8VLstLaBfH2DdCR+kxf8IG7DXbzZKqBUnPUE3r
 4tn0Qj/R
 9FWHFKQWpRLxhR7BpMe/r+T0FV1s+PdkF+B17OOiCNTv8a442FWajajBqjtZ+GfvsekwsQf1N8SLcV6wCbhEaYwsc0IdM2flVtrK1XVg4WbucM6SC0Mn4Edhh/L4Hxp7m6TlsbPXIjzEy/AEFAw3IFBWyu9F2pkzPfZ8x2sXKXhHCix2XisTmiRQRefpOB/kVCZPEEkyrvfjpxIbCjeDwcfFnpefZWyaxvUQY579idsrM+4yVDJ+edt/GeX/z5j1GJzyxom5J/CJWAgQrvOba1K8u1QpKJUtMyIIZgsQNU0Z/B39qp9sC1HdZWwRU545jy5Lr1JYflhqm4V/1DFLUblUJzTfKVkW311QHOOz4OCqoIz53Y0phbdeeoFq7t6RKmHE60ocx2zEDIEPb/WN8me5yfhvhAorFeurOMsbgcuD6Z04HqA7NI9qvs/Hx+IApfYzLh0+xYbPq1sZNxh8n3secOv7Zv+NDmv15eQ34mAiRGkYHuOB5T3iN8uLc6uca0WXOoDQSoo0lqo1PB8+gmlCMfFprP2Osveh/i5cdYq6sZEm5Pa26kh0wf0I2N838i7Nj36d6QcRJ+HhjcBv3No5TtR1o7FL3Zl4XaPZcwGLZCNn/9BC3/0o3tNNC+S7CgfgdO0JR1RPdVt4/MH2zW+BPU2tB5VZKBWuCW5o0Me+LuO/8Jo0Cq3z755jgablQEewKxa3VGlE806IBFxsYpFxkKZ5IrjQRjQ+mVU0W8ARLh5QDnJDkip+bnILmcO9AOGdBtT0ib9WoKJl/b0lgKzPq4pP/ExyttBoVy5bgDYBF+e5LT+yES0N4cusyy6UhnvclzKgReQ5mRrDNOAxmzAAFVJ4wTN+zM7aO4GCf0QhfmBJanOxo/8IQDSUYHOTIF4GNfegjOrCiol0oCFwEUT6pjlvJE+JT6uLzpg6rYqe8tKf/DasNKJLBewj0BNzkHGn9MB3Ux7T/2HhE7mtiSSgNP9kN
 f7GfLAmy
 dxI5A5q4EAEcEXYAKr/0LsqnbD6iGFhszvapVCKB/179oN3elqqKp8olk+Bkz2mWBYJS26EmLKqQxsE94K/CDIi5t9oJWLZP1MBQyLSPUoykAtAFGsbrlA0epLA3nZz85X3Tt4s0rVhz9dRRnxEio/M/ha73XoJMbpn6Z3KGjauPvstUxah//gzHP2yrfrHOTbj420fd0NF8DW2jVd7icWqKJ+pRIKxay34xsDbgEZCzq4+8teJLLfjzsiZAf4U0StpXwNLoYwIctHToRucvcl5o7/YQbrDCEl5LJqmEX9U15ynYD6xl7im9hn3r34hQJ/Te45lNEX+j2XLF/r4RNOEt4XNgqAhyQn20XjDCx3erFp5F4aY+flc5TQV5b6JAYR8txdeuvxxX6Yfii4c0SNP3sdcNfk7BXVQDmMDFwIliULowGCHdgBAYG1O0oofU9jOr3RhhWh2kdBUvMqAvg8pxPjYq4ZHX6nS+ROh/vSxYaYt2RU6/lnqL5pH1Y4EsJudexhulQiFZw0wsEIr7DTVwwxWXk3rcj5uYT2V8atcN3X+Gemheb1T4Rh+RcyLmguBWlEqNBNn6YVS5akg54l+Etx6DbAMjdcHwwoMvtrkXml9ZKIa61xotJ/2vSCDMxBGNvum8rReExdp7/NyKpuLYjakORZrXcwPOOFPvt0rlsCmkb29j3YfT1MZN8rR8E00UK9H2Iro9J3G0VL1gg1kmF5F1XhHT0YfN620cHUmtGA+WdBtLvXuL7GUqD0evBjU3apVLGBkeM4SVKKst+waQsstCkjApoMe0+69tQiNXpOVE88kox9EBqa7+MY+jrUH+3AGZgkCn13k4V8UhbrNjRclai0XnDo6+6lhXTdFZ+kUrrYlTk2iz8JPVOiVxTCdxf+duY21WzcVBXyobLAqI+xUeKE86ur9aY8+EsNi9LWPU3+LFvj1lXHlsP6EAiBOD10OcXGZhdbBNnRJ1OD2ehqo9f
 ppWlPTzu
 X65u0TP/D45ABkoGoLT4aJV29RJdZKLM86Qivi8cnhc6KDcBZRO99a0RTr3LviN1+8UiggHNJJUSwC7eqxMX+eIg8PKoJoREKLxH5A+xo6W/AndA9Gj1zICLW3hmYKcJJAmgreylgO4ZWtPay/b4F0p0e4i6Mn0OUoCTrDdIY8iRHMijcJMcR2kk0e/U9nVUZsbEhYRHr7X3+M1LT3ESTOBoGLGkMPqgZWMGIVtAKz+kNt22xUw+tFnYLQXpGNzWpmMUkJlGgWR2KLUdPK5UvWfmqvylDJmWZClp/Z6iNhTZ67EPCKlcNoA5nkXhmE/tkttcCoSY7P2vwsROvXPgrIB+nDdINiqm6nKx2s7aN3WJbYTQe93H89seRB4fVh30cN/j3Y4ks5lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 08:21:58AM -0700, Suren Baghdasaryan wrote:
> On Thu, Sep 17, 2026 at 9:23 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > The map->file_doesnt_need_get flag is confusing and the existing
> > implementation has holes.
> >
> > Drivers are permitted to change the owning file of a mapping. If they do
> > so, they are required to take a reference on that file.
> >
> > The mmap() operation which ultimately invokes __mmap_region() is guaranteed
> > to drop the refcount for the original file the mapping was made under, but
> > this is not true for the replaced file.
> >
> > This has been addressed so far by tracking map->file_doesnt_need_get, which
> > is rather poorly named and unfortunately fails to correctly track whether
> > or not an additional put were needed in a number of cases.
> >
> > Make life easier by removing this flag, and instead drop the reference for
> > both mmap_prepare and the deprecated mmap callback in a new function
> > put_map().
> >
> > Track whether this needs to be done by aligning mmap_state with
> > vm_area_desc and store the original file in the map->file field, keeping
> > the updated file in map->vm_file.
> >
> > In order to have the same behaviour for both types of hooks, only drop the
> > reference __mmap_new_file_vma() itself took in its error path, deferring
> > the replaced file's reference to put_map().
> >
> > To make this work correctly, map->vm_file has to be updated before any
> > error handling, so update __mmap_new_file_vma() and call_mmap_prepare() to
> > set this field first.
> >
> > Also when mmap_prepare() changes the file and is then merged, the reference
> > count also must be decremented, so update the logic to call put_map() in
> > this case too.
> >
> > Also update __compat_vma_mmap() to manually perform this step for stacked
> > file systems using the compatibility layer, and update
> > compat_set_vma_from_desc() to replace vma_set_file() with a correct
> > refcount/file update.
> >
> > No in-tree driver is impacted by the incorrect implementation of this
> > currently (no driver that does this is mergeable for one), so this does not
> > need to be a fix.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/internal.h |  1 +
> >  mm/util.c     |  5 +++-
> >  mm/vma.c      | 83 +++++++++++++++++++++++++++++++++++------------------------
> >  mm/vma.h      |  6 +++--
> >  4 files changed, 59 insertions(+), 36 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 0dca33db068f..fe576d468af4 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -7,6 +7,7 @@
> >  #ifndef __MM_INTERNAL_H
> >  #define __MM_INTERNAL_H
> >
> > +#include <linux/file.h>
> >  #include <linux/fs.h>
> >  #include <linux/khugepaged.h>
> >  #include <linux/mm.h>
> > diff --git a/mm/util.c b/mm/util.c
> > index bf0513d1d3d0..016932780925 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
> >
> >         /* Perform any preparatory tasks for mmap action. */
> >         err = mmap_action_prepare(desc);
> > -       if (err)
> > +       if (err) {
> > +               if (desc->vm_file != vma->vm_file)
> > +                       fput(desc->vm_file);
> >                 return err;
> > +       }
> >         /* Update the VMA from the descriptor. */
> >         compat_set_vma_from_desc(vma, desc);
> >         /* Complete any specified mmap actions. */
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 55917d097933..fa784f069da4 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -24,7 +24,8 @@ struct mmap_state {
> >                 vm_flags_t vm_flags;
> >                 vma_flags_t vma_flags;
> >         };
> > -       struct file *file;
> > +       struct file *file;      /* mmap()-specified file. */
> > +       struct file *vm_file;   /* May be updated by mmap_prepare. */
>
> Overall I like the change but I think you could avoid extra churn by
> keeping the name of `file` as is and add `struct file *orig_file`
> instead as:
>
> +       struct file *orig_file;   /* mmap()-specified original file. */
> -       struct file *file;
> +       struct file *file;      /* May be updated by mmap_prepare. */
>
> Then many uses of map->file would stay unchanged.

I didn't actually want to do the churny version of this but the problem
with doing something else is that would then contradicts what's in
vm_area_desc:

struct vm_area_desc {
	/* Immutable state. */
	...
	struct file *file; /* May vary from vm_file in stacked callers. */
	...
	/* Mutable fields. Populated with initial state. */
	...
	struct file *vm_file;
	...
};

And suddenly what is 'file' there (inherited file) is the modifiable one
here and it's more confusing.

As per the commit msg:

	Track whether this needs to be done by aligning mmap_state with
	vm_area_desc and store the original file in the map->file field, keeping
	the updated file in map->vm_file.

But maybe I need to make that decision clearer there?

>
> >         pgprot_t page_prot;
> >
> >         /* User-defined fields, perhaps updated by .mmap_prepare(). */
> > @@ -43,8 +44,6 @@ struct mmap_state {
> >
> >         /* Determine if we can check KSM flags early in mmap() logic. */
> >         bool check_ksm_early :1;
> > -       /* If .mmap_prepare changed the file, we don't need to pin. */
> > -       bool file_doesnt_need_get :1;
> >  };
> >
> >  #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vma_flags_, file_) \
> > @@ -58,6 +57,7 @@ struct mmap_state {
> >                 .pglen = PHYS_PFN(len_),                                \
> >                 .vma_flags = vma_flags_,                                \
> >                 .file = file_,                                          \
> > +               .vm_file = file_,                                       \
> >                 .page_prot = vma_flags_to_page_prot(vma_flags_),        \
> >         }
> >
> > @@ -70,7 +70,7 @@ struct mmap_state {
> >                 .vma_flags = (map_)->vma_flags,                         \
> >                 .pgoff = (map_)->pgoff,                                 \
> >                 .anon_pgoff = (map_)->anon_pgoff,                       \
> > -               .file = (map_)->file,                                   \
> > +               .file = (map_)->vm_file,                                \
> >                 .prev = (map_)->prev,                                   \
> >                 .middle = vma_,                                         \
> >                 .next = (vma_) ? NULL : (map_)->next,                   \
> > @@ -2447,7 +2447,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
> >   */
> >  static bool accountable_mapping(struct mmap_state *map)
> >  {
> > -       const struct file *file = map->file;
> > +       const struct file *file = map->vm_file;
> >
> >         /*
> >          * hugetlb has its own accounting separate from the core VM
> > @@ -2496,7 +2496,7 @@ static void vms_abort_munmap_vmas(struct vma_munmap_struct *vms,
> >
> >  static void update_ksm_flags(struct mmap_state *map)
> >  {
> > -       map->vma_flags = ksm_vma_flags(map->mm, map->file, map->vma_flags);
> > +       map->vma_flags = ksm_vma_flags(map->mm, map->vm_file, map->vma_flags);
> >  }
> >
> >  static void set_desc_from_map(struct vm_area_desc *desc,
> > @@ -2506,7 +2506,7 @@ static void set_desc_from_map(struct vm_area_desc *desc,
> >         desc->end = map->end;
> >
> >         desc->pgoff = map->pgoff;
> > -       desc->vm_file = map->file;
> > +       desc->vm_file = map->vm_file;
> >         desc->vma_flags = map->vma_flags;
> >         desc->page_prot = map->page_prot;
> >  }
> > @@ -2586,6 +2586,10 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
> >         return 0;
> >  }
> >
> > +static bool map_same_file(struct mmap_state *map)
> > +{
> > +       return map->vm_file == map->file;
> > +}
> >
> >  static int __mmap_new_file_vma(struct mmap_state *map,
> >                                struct vm_area_struct *vma)
> > @@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >         struct vma_iterator *vmi = map->vmi;
> >         int error;
> >
> > -       vma->vm_file = map->file;
> > -       if (!map->file_doesnt_need_get)
> > -               get_file(map->file);
> > +       vma->vm_file = map->vm_file;
> > +       if (map_same_file(map))
> > +               get_file(map->vm_file);
> >
> > -       if (!map->file->f_op->mmap)
> > +       if (!map->vm_file->f_op->mmap)
> >                 return 0;
> >
> >         error = mmap_file(vma->vm_file, vma);
> > +       map->vm_file = vma->vm_file;
> > +
> >         if (error) {
> >                 UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
> >                             map->prev, map->next);
> > -               fput(vma->vm_file);
> > -               vma->vm_file = NULL;
> > +               if (map_same_file(map))
> > +                       fput(map->vm_file);
> >
> > +               vma->vm_file = NULL;
> >                 vma_iter_set(vmi, vma->vm_end);
> >                 /* Undo any partial mapping done by a device driver. */
> >                 unmap_region(&unmap);
> > @@ -2623,7 +2630,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >                         !vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
> >                         vma_test(vma, VMA_MAYWRITE_BIT));
> >
> > -       map->file = vma->vm_file;
> >         map->vma_flags = vma->flags;
> >
> >         return 0;
> > @@ -2631,7 +2637,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >
> >  static void map_set_anon(struct mmap_state *map)
> >  {
> > -       map->file = NULL;
> > +       map->vm_file = NULL;
> >         map->vm_ops = NULL;
> >         map->pgoff = map->addr >> PAGE_SHIFT;
> >  }
> > @@ -2643,7 +2649,7 @@ static bool map_is_private(const struct mmap_state *map)
> >
> >  static bool map_is_anon(const struct mmap_state *map)
> >  {
> > -       return map_is_private(map) && !map->file;
> > +       return map_is_private(map) && !map->vm_file;
> >  }
> >
> >  /*
> > @@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
> >         }
> >
> >         /* Invoke callbacks. */
> > -       if (map->file)
> > +       if (map->vm_file)
> >                 error = __mmap_new_file_vma(map, vma);
> >         else if (!is_anon)
> >                 error = shmem_zero_setup(vma);
> > @@ -2797,11 +2803,15 @@ static int call_mmap_prepare(struct mmap_state *map,
> >         int err;
> >
> >         /* Invoke the hook. */
> > -       err = vfs_mmap_prepare(map->file, desc);
> > +       err = vfs_mmap_prepare(map->vm_file, desc);
> >         if (err)
> >                 return err;
> >
> > -       /* It's invalid for mmap_preprare hooks to clear vm_ops. */
> > +       /* Update first so file refcount tracked correctly. */
> > +       if (desc->vm_file != map->vm_file)
> > +               map->vm_file = desc->vm_file;
> > +
> > +       /* It's invalid for mmap_prepare hooks to clear vm_ops. */
> >         if (!desc->vm_ops)
> >                 return -EINVAL;
> >
> > @@ -2811,10 +2821,6 @@ static int call_mmap_prepare(struct mmap_state *map,
> >
> >         /* Update fields permitted to be changed. */
> >         map->pgoff = desc->pgoff;
> > -       if (desc->vm_file != map->file) {
> > -               map->file_doesnt_need_get = true;
> > -               map->file = desc->vm_file;
> > -       }
> >         map->vma_flags = desc->vma_flags;
> >         map->page_prot = desc->page_prot;
> >         /* User-defined fields. */
> > @@ -2826,7 +2832,7 @@ static int call_mmap_prepare(struct mmap_state *map,
> >          * anonymous mappings. Rather than allowing these mappings to be odd
> >          * outliers, simply make them truly anonymous.
> >          */
> > -       if (map_is_private(map) && file_is_dev_zero(map->file))
> > +       if (map_is_private(map) && file_is_dev_zero(map->vm_file))
> >                 map_set_anon(map);
> >
> >         return 0;
> > @@ -2845,7 +2851,7 @@ static void set_vma_user_defined_fields(struct vm_area_struct *vma,
> >   */
> >  static bool can_set_ksm_flags_early(struct mmap_state *map)
> >  {
> > -       struct file *file = map->file;
> > +       struct file *file = map->vm_file;
> >
> >         /* Anonymous mappings have no driver which can change them. */
> >         if (!file)
> > @@ -2868,6 +2874,20 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
> >         return false;
> >  }
> >
> > +static void put_map(struct mmap_state *map)
>
> nit: maybe put_map_file() to be more specific?

Sure will change.

>
> > +{
> > +       /*
> > +        * An error occurred or the VMA was merged.
>
> It's a bit weird that the function explains when it is being used.
> Having an appropriate comment at the call site seems better to me.

Ack will change.

>
> > +        *
> > +        * If the file was changed by the driver (which is required to increment
> > +        * the replacement file's reference count), drop its reference count.
> > +        *
> > +        * On error, the caller always drops the original file regardless.
> > +        */
> > +       if (map->vm_file && !map_same_file(map))
> > +               fput(map->vm_file);
> > +}
> > +
> >  static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >                 unsigned long len, vma_flags_t vma_flags,
> >                 unsigned long pgoff, struct list_head *uf)
> > @@ -2922,7 +2942,10 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >
> >         __mmap_complete(&map, vma);
> >
> > -       if (have_mmap_prepare && allocated_new) {
> > +       if (!allocated_new) {
> > +               /* Merged, so need to drop refcount. */
> > +               put_map(&map);
> > +       } else if (have_mmap_prepare) {
> >                 error = mmap_action_complete(vma, &desc.action,
> >                                              /*is_compat=*/false);
> >                 if (error)
> > @@ -2936,13 +2959,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >         if (map.charged)
> >                 vm_unacct_memory(map.charged);
> >  abort_munmap:
> > -       /*
> > -        * This indicates that .mmap_prepare has set a new file, differing from
> > -        * desc->vm_file. But since we're aborting the operation, only the
> > -        * original file will be cleaned up. Ensure we clean up both.
> > -        */
> > -       if (map.file_doesnt_need_get)
> > -               fput(map.file);
> > +       put_map(&map);
> >         vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
> >         return error;
> >  }
> > diff --git a/mm/vma.h b/mm/vma.h
> > index e97bd2dfa786..f15faa83f3d6 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
> >
> >         /* Mutable fields. Populated with initial state. */
> >         vma_set_pgoff(vma, desc->pgoff);
> > -       if (desc->vm_file != vma->vm_file)
> > -               vma_set_file(vma, desc->vm_file);
> > +       if (desc->vm_file != vma->vm_file) {
> > +               fput(vma->vm_file);
> > +               vma->vm_file = desc->vm_file;
> > +       }
> >         vma->flags = desc->vma_flags;
> >         vma->vm_page_prot = desc->page_prot;
> >
> >
> > --
> > 2.55.0
> >

--
Cheers, Lorenzo

