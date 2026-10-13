Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F10ACA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 11:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8446B0098; Tue, 13 Oct 2026 07:29:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 261F56B0099; Tue, 13 Oct 2026 07:29:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A696B009B; Tue, 13 Oct 2026 07:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA0AF6B0098
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:29:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A969AC09F4
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:29:51 +0000 (UTC)
X-FDA: 85317383382.03.15542AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 223978000C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:29:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q5XSCDOi;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791890990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6XqjA/BTi0UimOJRXPoyDY9jgW+xNcOyj9nBVG0M9QA=;
	b=5B+wVMDGnm/lbVhXWOIroSUSxm9omY4hrREUNxCcfM4gUGpEG/6FrK+NN2cRg83hG4TQOe
	Bl+WCB9Ba3ZFdIwDARz54mYIMSQ2DWXFNu+5twGA9lp9/ObKlBk7wF4lr4Czp/ObQ1tG20
	EZNUJ2j/rPVS46DR19z8FH/7Mk7K5ck=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791890990;
	b=lVzOmz97Mf1z/g3rORjOP5XqJ9232ReLFxxmcv5hs5VfC9QJywffCK/d0jpSAJ3UHidxGQ
	gchMyXpPs+pw2uNwxhLgwObKlzKMY8yB386u3NSNIRkypabSRvyqpfm0IYUKgtrOeQTIEg
	Kkb8WhjCPsmC9EmfC6mwYAK/EixdL14=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q5XSCDOi;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DB1C602C3;
	Tue, 13 Oct 2026 11:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908C11F000FF;
	Tue, 13 Oct 2026 11:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791890989;
	bh=6XqjA/BTi0UimOJRXPoyDY9jgW+xNcOyj9nBVG0M9QA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q5XSCDOiMCkxmNBt3Wahjw3f3gX93ZDCSa9CdYxuU9X0hN6bEVTNB4IELta63m0QB
	 dEMhDlXbRQUfz3Ev8UIUCG0TeY/DE8JmQVCgJ1HlzvrcE0UJhAAPV4W0EvcgheF2lB
	 j6DYhxROXPlPjm+pidXFCm8wvv8jdGcSC7oNJZLDlhqrlBEsbRerhPIg47miiV6xt6
	 1smY9LeY4AAu8C5wf0CqHWMfUWbyMAjGj9pGtHRbexb2hn9pCr3gWJ0CI7ByXeA/VU
	 b2CZVSAsoNG/Lq++tK5RDQ5VuXnlI4jkuiBgwHsD8MmEsVf5mMFDl6K+DSaVvOmynM
	 jiz20RE12a6sw==
Date: Tue, 13 Oct 2026 12:29:16 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Bert Karwatzki <spasswolf@web.de>
Subject: Re: [PATCH v5 31/38] mm/uffd: use predicates for userfaultfd checks
Message-ID: <as4PHg2OaE_UULTg@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-31-923b70125b1e@kernel.org>
 <b8a6a344-ad2c-4355-adbe-be7325e7371d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8a6a344-ad2c-4355-adbe-be7325e7371d@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 223978000C
X-Rspam-User: 
X-Stat-Signature: zqisnk7jgbfch7pbz87e66jeynmm5y5c
X-HE-Tag: 1791890989-619934
X-HE-Meta: U2FsdGVkX19Rwfra3qWTb7qknS4oiz8mvSKvkybqwjvoRAwKVBvnYgwDeZdHIg5Xk8MbvyH9s5R2xbr3+vtrwsFp8lnR3PYcKBOMtp59MooGrsatFwKGjMueU+KayOYHPW6Mgt+BSA3/wfBBGnSCkNjSPNQPI2W9J48HGEizMgcayvxexLNi4nr5BdMcO3aICVMyfvMszW4Y85lMIaLOtVRSLxWeN9qgY40RQ1Cjwpg6XqF4kmc9RL3V9PCTSbuwtePQ7CpA8EQyyHElyIZ2WYvNVZ4q1G1opzZBLD2GJ+UYucEkNSCe1CUUqUNe/zZt320BjZEHStyhCLbCeCJVgniPiXSYOFzWrPlHgRexYJ0YW3bXBiG8xuJQjHfaMf41kUyuv8rragb+R5Aa7Yn9gkQlLRXQPtlRXTdCLZypWw56tLXL3wSo6RMDsoulDcHKqw1WnsrwonPYJ4ANamhZMaDvksa0HzoimC+QoaJiDZIHWLUg4zORB5+cICwYJsTQFXGflAJvIccahgA9hTEV1pW2ysHY5SvkR2IaY4yVWxErzcrWH9bx9kCB1jmBcbAW8X2NoBlQu6hEqxnMQuL7Qxl0cUtvv0HLxcUjfVETBO1DM/DkimlI2ZY1vAGBuDuylo7O3slZYYnWy2XepVv4c7HPNCMIlSiQT8RMFk6a5RiHEHH9Yn8FG+dU5lEKC/In2Hea54Tblj1t05EkAnKZQ9n2ZmI5G6ydu4xvhZ57hC441vWGSCDeaYglhISTwkHgoAu7NzKHnvF/jY1PGJqFxjDCiyhYTULtYKGogBV1ztXDa6uSYzAZoIYKwQL/vhpAPHbP0B9nPYqlFmj83Gyk+uSWrut2N/Apa8prwCLlyg0oOTSGCMxEO+CvvTn7yX4akiSrSRoflS7yJtvVMF9IDY7lWYKf2p3ZuTD8i76rC9Mi8RUyWBr5r9h707R3eRT3NQ3DhDs4RwdPM8XtgIT
 jcnnn/gp
 uLpG/0hq/Yd9xPtKeJwlFBe06IcxSHMrEgYYJ8yPeyebiWQU2Ygm6vjSteqvHslO6JwDBvG6aXTT87WbdKtqgh0eujIVTVWQJDW7018eZ+twYijHNw57d5cbOwY9CvkzgQ3yjDNA7sqU+ObcrA9ilwknzV4GPhAOj26j9Ho/hjnep6lGQPFmHH6BK2NvQRGVufUfYNMeURAEjZIt1OAr1zbRKo7Jdt02qo12i2reJ+lAVJjZPxuNsKxMOaCh9+LKKs1rEOeP7dRtv7XfYgIK2OvKDeXkgugVAcTRm+pfUumsiBN6+V+g8Av/BsK99jVJU/k87oLNbnrC9UoAKKo0FH5ztTNCF3h2zCUjtOU+oT6R8yNiZmrgP58Q2a4461UZsQFqgUmwO5M4LCtgGgTo1E6tDRheYXU6fOw0xcNVWraKxGebkqe6y9bKGmg7UPScMGjDw3f+bqOA7NNGQ+g54V13J20zEN0IcLx98hW4uCMRwG36OivVM61/cp+1w6ejpOjJoSsUEQiwM3cInj/TsfcNRAdtvlwfS2MLL7A3RORkrmNPBkfkA/tfz2cD9I9hMrezrNAaA18o2xVFgX7jMPL5OPhP/EbXBR6Qsbc07zfP4YNXngdfTIMOItHNdqnFOSo5cis6b5IYOWF12SXER4kM+E1X3nLZ/CmCLW3VG+7npAik5/hEDTe0Gv2FyFn2ws4bA+bYDFI1TDIa/ojGhXA5mnb+Yo/1tPT/yxls6M4AFwJh+5t4JL4UGVvnH3yq2TFsaGIptHXVT9YcZ+xQ0mDmZiZJ7xTKnwOBIHnYE/Fjv8OWnIVXkKOi930keoMs3XL/WsOQbBzvLD+mQZoMTl6y+WWfPIvV51P0hyqVEj2GdV9d+PFbOG4TvsTtZzTztGXxbNM1jpG/n8FrrI9bSdCd7WFpT4UATyQlL2UBMALVcrLRh+E922XR46cOmG9PPUMzlayNipzDzkre+AuRclY/kS52q
 IF6K6+Rc
 rjaMlF4VrdViQ9XvrwlKrGjM9WkKrIpQ45BUYZaKlVzcqwnYlvctsxgqGQyNzr/xaX1XBG7lQEY6uwmkxlfJGK4li2vWqfEvZpIasJhoeiRVDXi0++3mQIroN6XskTgH4fvumDmBKW5YcobH9sqYK3NOE9orf4YpVVhOGjKcOFQgNZ8MIqLtFd391XYzaOoHFNeN2a/sJrRVGt8ILorVUthMI9RaNhsnLg+NKWSf1Yfsuo3bO2LvpmuXl7yzo6DXxmGnsNvm8afJ94VsZOBwGoIJa+jl5VatpsuVEOYPImcvKhOXEPkTU9n8dfYvqubDjtWnwD5q8kxfGzzamP3P/Zj4NjpR9LsUX2BGk60JfrQJyvoM2aBTX/HGzBchCs8sj1J+6PF+Hfi7islonJ7gILu1JkyNQQTSPYg+CyKoWSg+wFBYOlDehGEYDaKS/hAfYoIeu4gsXYeDVe3W6IME4vKQzWf6k4nPsAU4734JHGyS/cfoWrhQpNOOOJQnfsGvi0bXTKY17M0WH1z1LR1wjtKkfauzdIee+04gy58c3KMJ+4GiQb2JouAjcXTnq0kNm9q8enG4QaO5tsUfvDhHNbXIIyV+y/uOWUys2FDVthTI2mHHUTfcuAwMhb45luAKrVbJtPIo8njRsP4LlwEedQR70YN4Rs1CtLve2Fvt0ZzN9S7eW7hGid4MfUBfi/TDENAaC6XR5q7JfUehp8Ntr7CYGzaeCQFm73z4wkJrF1u0cphIXQKJ3+dJdx5KxxCj2n4XOSH8HfWO6HRMB2m3Xw4N9jTDm8CwVAO0XoV2h+oDLOIdJ3wJ5Z01XlPVlDMMz6AByqH1SXok3ces7vwYWDewurF++vgolQlgubEwkZzVACxtQOhA0p0pvqxaLiaLzmZpnNlYieeMrXyhD5izrQv0ieWfGMEg3FgrLjuNKx+cwaV+3MpC8vMUpjIHUwYoZ4LrZdqdS+jLYLeCilUAvXqiKstrn
 WjVBS8yX
 XRE9mWelQkkZeyqj3miu3sU3A6ygUvetgci34Vkm7yIN9D2VKiOH9ryYGlTdWzQEaDLLbuUj2b3pRdfNa4Oc4mdhGSmQ5BrIBvNVRby760bItdvfXMLwLm3Nqwmc9FVRpXW/SuZO9TT+l9T6oh5WpXghJ0F6DETb5V10PdFxp0lwLatX9CaCBtDvSxUDzZxxKK1ceK2g1O8e2VtZN0PKn9J9ipahAFZrtLCg+2eXoqaa43nGIqdqxHiO/SN92JnPAFlG8uoGRop3O1pMJZu048S6tY/BA8D6wYWP6PphDi+UmUDYpEa7gQvI1hoy03fr2443fSXay3ZzLhc7Ceq8WX+q78gcilcG+7+m6bUnGHBY66ZuiCzgxYcy0/cBwejRGmUeETpP0v0p/kRVOD+YtOlP/E9WAnRLJ3XgkfcfMY6JK1sjVb3RNsjCtKXdSlNUq/1HPJ4djuBk7hikRpiyawgADNurmSkLpofoW1SbzVTsXcGfadeFJWF7QyeyFH5VEmWSjuJrlBesxDqdY5ToziCNKLq2E85kgloOC7xCJfEl5uQSHcBldZOdCRRVTflwcQIWXZS3d5bsaa9gv0/1ZMXqAGUUrErsnAEIL6SzgDzUlxNhnmVO6m+2a39cf9MO9q9yBDsVxwdypiSSJ0rCuhRlLIYiRCRDTsTdOviZ58q7AeOaLvKi/xs3K6Q6vwEQYYrib0f2uvMYX5AdGHoSfNWrXJsfC7lRozyBXUHYSKiNFh+LDj+PQY3Cuac1lhfO3zZsXKtP7bFKquQtYOLBN5kIBODQlF7lDbRUWNlXD69Tnqpyu8n8m+uhHP4tK7l9yx2xpT6Sxngk8hQJEiIxDkJQhyDll7YQvP1tUQjU/sjze++Ngc416/II6U8sCkEhkdJEYGMwikcXyPrGFtE8zjB+Wt5imbvTasKGhiy71g0eKTVfUqgW6OVUtaafghapRSE4Bj/tnnHrJi62vyhnqYS/5Xtvm
 YaYU16O2
 AihKvGAXMgv5UbiX6FCGO9r54s6k27ul7fC6dA9RXtHOUTw5YtjMcbNuFsBGRFc6Jf3LSEWzROVErTzBlYLE+R3LQDRQ07f1dmMNZMJt1e0lzYHw6j0xc4DsPkjdT5wpp7ZneQsPuaUFbyexv8hEufa8LdJHPK/rMjy3o4w3uXqn8ZLY/ZFIqFNHHJcKXE+vB4aF1Gs+TQMOK0F1Mu3TzT2E4KbTmHpNXRgosukuqZdImtXr7RgWnqtCreWt7VqGH3ptu3f66yCyNrmpJj/kdd9e2ypvCFU+O34VgwVEmx0cspJOBI8vQVbADaoi6ZqMg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:48:04PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:

> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 949017e60608..f33b04700838 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c

> > @@ -2146,10 +2152,11 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
> >  {
> >  	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
> >
> > -	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
> > +	/* Only mm-backed memory can have its faults handled by userspace. */
> > +	if (!vma_is_mm_backed(vma))
> >  		return false;
>
> Again, for both I would prefer keeping the droppable check separate.

Ack as per discussion on other thread, will separate out for v6!

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

--
Cheers, Lorenzo

