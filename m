Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4637C982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7D636B0092; Thu, 17 Sep 2026 05:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06976B0093; Thu, 17 Sep 2026 05:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9096B0096; Thu, 17 Sep 2026 05:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7368A6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:58:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BF311402A7
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:58:35 +0000 (UTC)
X-FDA: 85222804590.20.5CB7329
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 55ACF20007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:58:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=isWuVbzY;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789639113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BDLANgER3p3HCZqlKV0tx0X7HCIS+iB0o+b0askj3w=;
	b=UofVIzgxoS86MZUkHlH9GG40kXkvo7DkycK+21Q5sK5k98ijBvAMqhiIzyvZdtq1HPIM2P
	TICqCAJ7dS+qb7rQB+3c48Jg7UpzcHTV5ZQJrUKb8abp/x5gweJVZQ63e/VA1tnG4di77Z
	uKMYeDDoknp270w0viEW3lBEKAKgt8o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=isWuVbzY;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789639113;
	b=yXCCLMG9H2JYamrmbfsedAyVw5jHxHf4s5S2i6qu7lDaiFhG20aGXb7IACsYbOfxNvBjmW
	JkHGIN37xLLgznV6Rrx635JPL0AJcZCaSWK7ow+hsX8FNTm3hhsr6fTVqdoqlFNEY4bsgI
	2a3CxKkguTi98vVQdoQ7Aq57UMgEP1k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC00D4380D;
	Thu, 17 Sep 2026 09:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EA31F000FF;
	Thu, 17 Sep 2026 09:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789639111;
	bh=+BDLANgER3p3HCZqlKV0tx0X7HCIS+iB0o+b0askj3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=isWuVbzYwxoFIjftdz46VsdsgIIBJV/b2LFp6yM/02MDef4JKOZ9kOY1TdyIDc/30
	 LACHzBzlm2BZ7ZOfu1upP63i+JmISIZXPneX5AaM6s6sXOqC/ZT3q2tHw6G9TORbm7
	 uyaMxHhO41rX8i22FRkG4N96szBjkfGYtWxPNRGGp83Dz+M2BsVrcKY1QuGp+175a6
	 GdHO1K1vaVn9nk+3axcRLy03cQ50PecCQ3m2wtlKX0jMOaKSdnV/poXR+30OeMTy4R
	 toRwR56CeJ6OD7Yas8T8+ZGTJWFYL2CdfHMF3AuIgVkwuKi/mHFb1uIScsd0fWlS0G
	 GskLPjj+/FY4Q==
Date: Thu, 17 Sep 2026 10:57:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
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
Subject: Re: [PATCH v2 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <aqu5jtMV2gyZFrSe@gremlin>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-1-7d9781ed5361@kernel.org>
 <aquz9Z9JrK_H_E0g@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aquz9Z9JrK_H_E0g@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 55ACF20007
X-Stat-Signature: gm8531rxqebn8eff51ph8e7jijfs4wrw
X-Rspam-User: 
X-HE-Tag: 1789639113-18615
X-HE-Meta: U2FsdGVkX1/llsNuvVWLr6mm5gBDhxLMSCdAz5GBxoXjilDPWMhZ49W1jr0kLiS93N0oftFiXYi7b3wQPTe6mbTbN1mwv7Ji9s+Gj7+Q4jzKSX9dmObKmHgyTs5Z1mNe3320A3pn4sXdYQLf7NkqNtWN3AKEt14IAudrTLMWwfd+zHMHP8xjncmCRvSE8pVR4EuvnJC5HVnzEc1hHfpE+3B8F9JMDftbmiMK2QBGEayt7JSLnXgAY4qgHgNQJET04YIf2Usm1H19A/AIHDosH+CC/+UZzEn9uv+YRucTRmh0tiH18ak1mKT3g67oINL7UOvtIxEsPsks4dE/k4Q2w2OHUdRDGuvDLMy4Wcce7Tr7cWhyp0zjq2oGuUjbj3I4R8vm6cMHt7tnk7K3f1TAJK343eoXL51LM1rv44GXJMF6o/MxEGjrvECQ+19urE1nZBelUIhJLgQxPqwZ/DNwiWJ/ikFs1RsZ6ZSnpDMPDLK1OC6Y5tSF5u4hYqz240vdhovlL9Xv3dNp96YLGu/Cz21PfwdalgtNOp0zzAlmxBTOQHSzI02XSKiu+1fjW7BYt7FIm5xjBwiDbscObDgjcBKPygyD4wyJogt4ON3OcBEq1uXY3JEwxeq88JIMKLCUknfGOcEAgQrADUiUxg/7eiZ+I+t+smT9p6mA1P9PEfNJNQxFz57oHPprspWwdACzR+nHqIteRJjStU+EzosfX+1413mxNih/nWPoS+iPKtSNXU7lhKwBYpOR/cnOkPk0CJpi3Gp6QL6dp5gsQfA1tPD6upZ+Pti3MwKXYj3BoJz6/QQHYJhcMPkHj2akk2gsLuu2mc3Os6wSPGhs0eNkcpYr04+fjxO+hgbXFezJ8qysZrZ/kZx4H6P5pApXMglqiVRZvWOj/YllKAb+IUnP9ebOaK9ZJ2bFW/qsKdyjbnSmFu3FmEF8fzOhi1pnVYgeWJ/j1HBEvxBCl9dczBS
 Fzg/aqvd
 Mbh4ziotQVgpYCMs89ukyawVh5gIb8elVJVm6EKZx6fRO1DTm8A9k/xatFlUi21mgynJGxiDb2E5ChTUenO3QGHWzvtnD7JI3O0/CfhvagvAQO59a0JffAkWMLt+Uw622JqYWyzK24lyBtc5meJzR3bonzurnCMNPEZn/BeEV7LYfEPxIszbuGws1aAWfPHJpsQiebQs9u3TuL59/UV/lGwk9VYcrBVKdDgFcOb7BXeQFORe3sLalPMqK0L9MQaB7oAmFJt4L6vXxuBkXxVHJXa2DthjF5CHhruDjU5ob2eGKU1qPxswPUUWhSsk/oL46A7dqJcYBqXa2n4+wpytt/rjd2FQcVh+06989BVw9e1z/PxTO2Q5oV4+1mC31pFW3MCk551ZncRSB67EzeocMJpqsKjJQ3w8NHJFD1GUbjQEeDYIA3yB4PuOiFgIYM8RIWgrC7YVzZQDqQgYvyDTMHHZwBIQH219EC8hTO7mmLuurOhjW7Qvgo7tsMON53puWY/JewaDtpBJRYuZQRQmESjpjWOPsFYAF5km+bbP/055sBUOzU3wzE1I/uE/i7hyp4QbriJIlOqZJJ5tSws+ARTQ+NrS0cDbX5FUyboXrE+Nme8vWc39+k0Q0LkO8eAJUEbSBFq3fWsODARV6QGMcVjBygJmb/m7DNT3hAKLNbtXBKO7AlA6vcCQfsT+IBreECgzLno/I/JPpxNPfqewcKL/u65kokKq1jW09R9E5SU8YFUpixrDRqXMTv25sl1CdAPOu1nAfO9DPqH3dn7mmgmYV07KJEx737/sQi58ZDNlx4ghrZ6Er0IWbx6IY8/ZMfKNwK/Os1BQ/sDCt/zMpM+3CdphHcVJ7w+1JISGrZmvjwaZqyLzIaq+Xlj1+huagcGqUoWmvmx7xqj+X37Er0E5sR16OQXVJcwtj9AyOcbTyMRpy3uVcI1lfs70rwUoxoHFcqH8IKqy6OLPOrROIf5HO9wgR
 vDWIjhyw
 rYsmN5Ysd1czFzsjYIlLD4ekp+J4dIIgveS7Hgd31gZLkzsmtrQN0na/6g9C5n86N6fb8gihspyP/xctZWouaIwtr54Gf1pTLERnZw6DP7LyaxBwxeTsmv3PTObV5FjT0GGBE4x2FXSKQDd8zAxMUn2e2yOGZJcWOeJ5moPg60JrPO1EF6b+tEXoYb8d8WCG1r+jwt1P5a4LpAahNBSWIXr9zRVgoiAtLi2SCUv03pxmhPBQ0P9Uk/dKwa9Xdzl1lCbr7HfmSbRD1wikUmvL1UwQykc0ZEv9K3/lwsi/DnlSldlF0ue/uqhRsGm1G+OqONTYuYm+6gvmVADKz3igt6jpmn61PbkWegMzzbMU9XSkN0Ieh04l/yZbl++WtOOpwM4ZgYLXEFqtiFFtv2WHEu7pljztWve4kvPYX/ZScpjFidLUD9tiL6l0qHSUg/lYhHBgk42A/D1K0Pv7/AYvsGraKZ+y6MZkrcsa/geR2LJjtGUDF+SM+7YHxS6px53hzGv2GKsSTz9ymbtae8v+TS04QEaQsYAHtl7XNHyd/EA6E0UN3guQf553xnFW+qt88A4Xad4MZqgp6rpg1jGSvtn4sFd2172jVq8VyEiP1RsQQfmd0qIMiMrGuIJXfJrIRcny36b5Ss//YWesT3z54BljIlwhYjjq4r2yhsNQ4sddAuVCo4+jIfA9bdVLrceXnnX4Z5OoRF9RRktv/SlwdbsFrIodRo0wzFcIo7fTlc+AihQtum/+s6p03qBb0ioLh/C0p5Lf5YQurK5qsJKlKrZmf00zhI8hZDL1HtDFuGLl/0+qSQ/DGNzzwBjeGJQVlZVQSQOUAUy4Xu95Yl+AYN5zdz4TYNnCE/sK2n/+KE/pXApkXSTi79pBeb6UYwLHpXDfAqF3nDlszQ3yVsI0Q+JMGghEiN7pS8KaJfsUc+6oJmVR5zdQC8m83Mznl0fY32EQSQyoH4iVwyij5Yz17MWRHH3eD
 a+31kK3F
 psNyO8icEExy4YCduTxdSpYAJXYxiIO9fIZfan2eeCmT6BvORI62mx4Drt15XQGmzNnR/GVX0iMCfyhsigklzfczQbS8L1BsbBxlbhymNR3DrEXV/k0q2KFid8mZBQ44lm3OVPOrUp8a7p6XDVw8eUoO5+zzp+IejNYAFxL/dfdw58KZ8I3PPo5kchnOIqREEioSL0PEzuRtnZwMsxM/uaxvAU9Ersefh+TjM5JsYJodBDff7VRALwLZM2VZUHedkz5NPj8V84i0Aa7yy9J5BUpCGPj40dOo+Hu2zjLKRAul6qAJBiM2RBrPM8yQcefFpemqkCJg0fIq8BRTMFh1W26v7hdYmg3Eo54wdTYbOGlnnBvnkz9DN+E22EZ+etFBohfPc0gb9f6sTiBL/70TWUPnnH/255Jiq8CMzj91QroULxYUNcrbOI0JMfY6hHviIKfI2D3+wmY8HvOsdmlp5HUTY584wjBRjQSffO2ErK4PZIS7tinCwmIAx7YGGSqMceCQNVCZv12niqnVQ9xGQ3PRlIY5R8rX0N9GXfzg4Wq0ysLw7Z9FR6GTPaeikpAxKU1/eaGrwP+WpRUghF3Pg8hBq1ea64DVosYY5rSw043Qr8+yjsjb4RytmFx5dfaCxQHPx6aueX0NgDilnLCMGVp8RUufclM5Y/g/QoLv5T7ycuc0OxeA7m8iyDC/hKLoz5cJy4yBFWOaDAfwCh9f+uh4hK6HG4xYOahbngs2GN7dSD9WpvwTNDt4F5sglYrOcKlZevHf3g3oHGqv5On5+Ou9Tx5GJtHYppOsZgshu1Tkw86h+pjVnxaPhXyt6pQWUcJUasIHDmdR6P4o53ZJJbPryHS327VrFIKqryKKudktEXzaOxhhwz5z848O5wpisrubzUmlHOBCVGO68FcIA5aE+L4LLMAemFC6tRjg66UEn0o/eayeSxRd11LQ1F8zWQSLZGdo6Mot5UvFgTvcdDmSyw0pw
 ZEtQtUlO
 UsNY1pFzpQSaszCokFa7oxV784Gg2CvCO/mkkdys9LznsRKfrJGnNmBh3G3cs83pJFCq17E80/5wqTJ+ssZJViygBHVa5dsnGXXbHSGC86VAoFdd9C4ns+1lFxQw4SYCp5KYRrPOPruiHI0VUs2yHcgWTecLidv00Hq4lDs43Z1q1IgmWeINYc/ur7nI6GPDdOV86gHRec4RCAQXuFpMPfiJ3xw7N6vUAT/989P9AOUFuRR1HQ5qG65Z2Sup8QD1q56b9jBntXDKEFu2AF10HOHLWiCJZcjHtV4cPthxWqSxB94Xd7OUqy/n86K0yZ6UrDXrJ25i8oWuVZauxmIAbKh/8KnzBX+sTRWYjJteBzRP27NYQHVf1y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 12:33:41PM +0300, Mike Rapoport wrote:
> On Mon, Sep 14, 2026 at 03:57:21PM +0100, Lorenzo Stoakes (ARM) wrote:
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
>
> But the patch iteslf needs to be fixed :)
>
> It seems to be the change that broke the CI.
>
> The rest is from LLM, take it with a grain of salt :)

Ack will assess + respin

>
> mm-ci mm-unstable red build - bisect analysis
> ==============================================
>
> Bad commit: 2a937a04babf1 "mm/vma: fix mmap_prepare file handling, remove
> file_doesnt_need_get" - first patch of Lorenzo Stoakes' 40-patch series
> "mm: make VMA flag semantics explicit, eliminate VM_SPECIAL" (v2).
> https://lore.kernel.org/all/20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org
>
> Symptom: tools/testing/selftests/mm/pfnmap.c triggers
> "BUG: Bad page map in process pfnmap" during __zap_vma_range()/vm_normal_page(),
> seen on process exit/munmap. CI's run-mm-selftests.sh greps guest dmesg for
> BUG|WARNING and fails the job regardless of the test's own exit code.
>
> Root cause:
> In call_mmap_prepare() (mm/vma.c), the commit reordered:
>
>     map->vma_flags = desc->vma_flags;
>
> to run BEFORE call_action_prepare(). For PFN-remap mmap_prepare drivers
> (e.g. /dev/mem), VMA_PFNMAP_BIT/VMA_IO_BIT are only added to
> desc->vma_flags inside remap_pfn_range_prepare(), which runs as part of
> call_action_prepare(). Snapshotting vma_flags too early means VM_PFNMAP/
> VM_IO get silently dropped from the resulting VMA, while the PTEs are
> still installed as pte_special (real PFN remap).
>
> vm_normal_page() then sees a pte_special PTE in a VMA lacking
> VM_PFNMAP/VM_MIXEDMAP and calls print_bad_page_map(), producing the
> splat. Confirmed: crash log shows vm_flags:080000d1, missing VM_PFNMAP
> (0x400).
>
> This is a plain ordering bug in this one commit - not a driver-conversion
> or vma_can_gup()/predicate-logic issue.
>
> Bisect method: built/booted via virtme-ng, ran pfnmap selftest directly,
> restricted to range 2a937a04babf1~1..0a80aa0fb08f1 (the 40-commit series;
> tip = mm-unstable-2026-09-17). Pre-series commit: clean. First commit of
> series: already reproduces the bug. All scratch worktrees/branches and
> bisect state removed after; mm-unstable-2026-09-17/mm-new-2026-09-17 and
> mmotm remote untouched.
>
> Diagnosis only - no fix proposed/applied.
>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/internal.h |  1 +
> >  mm/util.c     |  5 +++-
> >  mm/vma.c      | 95 ++++++++++++++++++++++++++++++++++-------------------------
> >  mm/vma.h      |  6 ++--
> >  4 files changed, 64 insertions(+), 43 deletions(-)
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
> >  	/* Perform any preparatory tasks for mmap action. */
> >  	err = mmap_action_prepare(desc);
> > -	if (err)
> > +	if (err) {
> > +		if (desc->vm_file != vma->vm_file)
> > +			fput(desc->vm_file);
> >  		return err;
> > +	}
> >  	/* Update the VMA from the descriptor. */
> >  	compat_set_vma_from_desc(vma, desc);
> >  	/* Complete any specified mmap actions. */
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 55917d097933..a319a9fc2f29 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -24,7 +24,8 @@ struct mmap_state {
> >  		vm_flags_t vm_flags;
> >  		vma_flags_t vma_flags;
> >  	};
> > -	struct file *file;
> > +	struct file *file;	/* mmap()-specified file. */
> > +	struct file *vm_file;	/* May be updated by mmap_prepare. */
> >  	pgprot_t page_prot;
> >
> >  	/* User-defined fields, perhaps updated by .mmap_prepare(). */
> > @@ -43,8 +44,6 @@ struct mmap_state {
> >
> >  	/* Determine if we can check KSM flags early in mmap() logic. */
> >  	bool check_ksm_early :1;
> > -	/* If .mmap_prepare changed the file, we don't need to pin. */
> > -	bool file_doesnt_need_get :1;
> >  };
> >
> >  #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vma_flags_, file_) \
> > @@ -58,6 +57,7 @@ struct mmap_state {
> >  		.pglen = PHYS_PFN(len_),				\
> >  		.vma_flags = vma_flags_,				\
> >  		.file = file_,						\
> > +		.vm_file = file_,					\
> >  		.page_prot = vma_flags_to_page_prot(vma_flags_),	\
> >  	}
> >
> > @@ -70,7 +70,7 @@ struct mmap_state {
> >  		.vma_flags = (map_)->vma_flags,				\
> >  		.pgoff = (map_)->pgoff,					\
> >  		.anon_pgoff = (map_)->anon_pgoff,			\
> > -		.file = (map_)->file,					\
> > +		.file = (map_)->vm_file,				\
> >  		.prev = (map_)->prev,					\
> >  		.middle = vma_,						\
> >  		.next = (vma_) ? NULL : (map_)->next,			\
> > @@ -2447,7 +2447,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
> >   */
> >  static bool accountable_mapping(struct mmap_state *map)
> >  {
> > -	const struct file *file = map->file;
> > +	const struct file *file = map->vm_file;
> >
> >  	/*
> >  	 * hugetlb has its own accounting separate from the core VM
> > @@ -2496,7 +2496,7 @@ static void vms_abort_munmap_vmas(struct vma_munmap_struct *vms,
> >
> >  static void update_ksm_flags(struct mmap_state *map)
> >  {
> > -	map->vma_flags = ksm_vma_flags(map->mm, map->file, map->vma_flags);
> > +	map->vma_flags = ksm_vma_flags(map->mm, map->vm_file, map->vma_flags);
> >  }
> >
> >  static void set_desc_from_map(struct vm_area_desc *desc,
> > @@ -2506,7 +2506,7 @@ static void set_desc_from_map(struct vm_area_desc *desc,
> >  	desc->end = map->end;
> >
> >  	desc->pgoff = map->pgoff;
> > -	desc->vm_file = map->file;
> > +	desc->vm_file = map->vm_file;
> >  	desc->vma_flags = map->vma_flags;
> >  	desc->page_prot = map->page_prot;
> >  }
> > @@ -2586,6 +2586,10 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
> >  	return 0;
> >  }
> >
> > +static bool map_same_file(struct mmap_state *map)
> > +{
> > +	return map->vm_file == map->file;
> > +}
> >
> >  static int __mmap_new_file_vma(struct mmap_state *map,
> >  			       struct vm_area_struct *vma)
> > @@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >  	struct vma_iterator *vmi = map->vmi;
> >  	int error;
> >
> > -	vma->vm_file = map->file;
> > -	if (!map->file_doesnt_need_get)
> > -		get_file(map->file);
> > +	vma->vm_file = map->vm_file;
> > +	if (map_same_file(map))
> > +		get_file(map->vm_file);
> >
> > -	if (!map->file->f_op->mmap)
> > +	if (!map->vm_file->f_op->mmap)
> >  		return 0;
> >
> >  	error = mmap_file(vma->vm_file, vma);
> > +	map->vm_file = vma->vm_file;
> > +
> >  	if (error) {
> >  		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
> >  			    map->prev, map->next);
> > -		fput(vma->vm_file);
> > -		vma->vm_file = NULL;
> > +		if (map_same_file(map))
> > +			fput(map->vm_file);
> >
> > +		vma->vm_file = NULL;
> >  		vma_iter_set(vmi, vma->vm_end);
> >  		/* Undo any partial mapping done by a device driver. */
> >  		unmap_region(&unmap);
> > @@ -2623,7 +2630,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >  			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
> >  			vma_test(vma, VMA_MAYWRITE_BIT));
> >
> > -	map->file = vma->vm_file;
> >  	map->vma_flags = vma->flags;
> >
> >  	return 0;
> > @@ -2631,7 +2637,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
> >
> >  static void map_set_anon(struct mmap_state *map)
> >  {
> > -	map->file = NULL;
> > +	map->vm_file = NULL;
> >  	map->vm_ops = NULL;
> >  	map->pgoff = map->addr >> PAGE_SHIFT;
> >  }
> > @@ -2643,7 +2649,7 @@ static bool map_is_private(const struct mmap_state *map)
> >
> >  static bool map_is_anon(const struct mmap_state *map)
> >  {
> > -	return map_is_private(map) && !map->file;
> > +	return map_is_private(map) && !map->vm_file;
> >  }
> >
> >  /*
> > @@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
> >  	}
> >
> >  	/* Invoke callbacks. */
> > -	if (map->file)
> > +	if (map->vm_file)
> >  		error = __mmap_new_file_vma(map, vma);
> >  	else if (!is_anon)
> >  		error = shmem_zero_setup(vma);
> > @@ -2797,36 +2803,34 @@ static int call_mmap_prepare(struct mmap_state *map,
> >  	int err;
> >
> >  	/* Invoke the hook. */
> > -	err = vfs_mmap_prepare(map->file, desc);
> > -	if (err)
> > -		return err;
> > -
> > -	/* It's invalid for mmap_preprare hooks to clear vm_ops. */
> > -	if (!desc->vm_ops)
> > -		return -EINVAL;
> > -
> > -	err = call_action_prepare(map, desc);
> > +	err = vfs_mmap_prepare(map->vm_file, desc);
> >  	if (err)
> >  		return err;
> >
> >  	/* Update fields permitted to be changed. */
> >  	map->pgoff = desc->pgoff;
> > -	if (desc->vm_file != map->file) {
> > -		map->file_doesnt_need_get = true;
> > -		map->file = desc->vm_file;
> > -	}
> > +	if (desc->vm_file != map->vm_file)
> > +		map->vm_file = desc->vm_file;
> >  	map->vma_flags = desc->vma_flags;
> >  	map->page_prot = desc->page_prot;
> >  	/* User-defined fields. */
> >  	map->vm_ops = desc->vm_ops;
> >  	map->vm_private_data = desc->private_data;
> >
> > +	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
> > +	if (!desc->vm_ops)
> > +		return -EINVAL;
> > +
> > +	err = call_action_prepare(map, desc);
> > +	if (err)
> > +		return err;
> > +
> >  	/*
> >  	 * MAP_PRIVATE-/dev/zero mappings are an ancient way of getting
> >  	 * anonymous mappings. Rather than allowing these mappings to be odd
> >  	 * outliers, simply make them truly anonymous.
> >  	 */
> > -	if (map_is_private(map) && file_is_dev_zero(map->file))
> > +	if (map_is_private(map) && file_is_dev_zero(map->vm_file))
> >  		map_set_anon(map);
> >
> >  	return 0;
> > @@ -2845,7 +2849,7 @@ static void set_vma_user_defined_fields(struct vm_area_struct *vma,
> >   */
> >  static bool can_set_ksm_flags_early(struct mmap_state *map)
> >  {
> > -	struct file *file = map->file;
> > +	struct file *file = map->vm_file;
> >
> >  	/* Anonymous mappings have no driver which can change them. */
> >  	if (!file)
> > @@ -2868,6 +2872,20 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
> >  	return false;
> >  }
> >
> > +static void put_map(struct mmap_state *map)
> > +{
> > +	/*
> > +	 * An error occurred or the VMA was merged.
> > +	 *
> > +	 * If the file was changed by the driver (which is required to increment
> > +	 * the replacement file's reference count), drop its reference count.
> > +	 *
> > +	 * On error, the caller always drops the original file regardless.
> > +	 */
> > +	if (map->vm_file && !map_same_file(map))
> > +		fput(map->vm_file);
> > +}
> > +
> >  static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >  		unsigned long len, vma_flags_t vma_flags,
> >  		unsigned long pgoff, struct list_head *uf)
> > @@ -2922,7 +2940,10 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >
> >  	__mmap_complete(&map, vma);
> >
> > -	if (have_mmap_prepare && allocated_new) {
> > +	if (!allocated_new) {
> > +		/* Merged, so need to drop refcount. */
> > +		put_map(&map);
> > +	} else if (have_mmap_prepare) {
> >  		error = mmap_action_complete(vma, &desc.action,
> >  					     /*is_compat=*/false);
> >  		if (error)
> > @@ -2936,13 +2957,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >  	if (map.charged)
> >  		vm_unacct_memory(map.charged);
> >  abort_munmap:
> > -	/*
> > -	 * This indicates that .mmap_prepare has set a new file, differing from
> > -	 * desc->vm_file. But since we're aborting the operation, only the
> > -	 * original file will be cleaned up. Ensure we clean up both.
> > -	 */
> > -	if (map.file_doesnt_need_get)
> > -		fput(map.file);
> > +	put_map(&map);
> >  	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
> >  	return error;
> >  }
> > diff --git a/mm/vma.h b/mm/vma.h
> > index e97bd2dfa786..f15faa83f3d6 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
> >
> >  	/* Mutable fields. Populated with initial state. */
> >  	vma_set_pgoff(vma, desc->pgoff);
> > -	if (desc->vm_file != vma->vm_file)
> > -		vma_set_file(vma, desc->vm_file);
> > +	if (desc->vm_file != vma->vm_file) {
> > +		fput(vma->vm_file);
> > +		vma->vm_file = desc->vm_file;
> > +	}
> >  	vma->flags = desc->vma_flags;
> >  	vma->vm_page_prot = desc->page_prot;
> >
> >
> > --
> > 2.55.0
> >
>
> --
> Sincerely yours,
> Mike.

--
Cheers, Lorenzo

