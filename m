Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9DF0C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 15:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29D46B0088; Sat, 19 Sep 2026 11:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DBF06B008A; Sat, 19 Sep 2026 11:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9A66B008C; Sat, 19 Sep 2026 11:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0C66B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 11:06:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FD65C02B6
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:06:32 +0000 (UTC)
X-FDA: 85230838224.12.F9D93B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DB877140005
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:06:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZ7NEov0;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789830390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6E/2ltl35xPsVBq7dCp8kX3P3iYtwP2nwvmHYrMGiao=;
	b=AcUfNRSQ0AD0BFgSs8gOQnwONesa6Zae51P6isJ0gm/md0BosedCrj6grb/eJAuFi3qtp9
	7n+q5g47lIWHZ6s6h3f7PG38ByXFXJErOTTIKiVlai1US1nmHrX1n6y0EfZJZH+7Xv/W0f
	wR6xeW7LfYipms8aajWorF9HwJ2mV2w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZ7NEov0;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789830390;
	b=ZMhKss51YGqtmNWdeaLzHEYBcIoy/K8LIAU6Ft0P/AU9Bi+6kMJRsKPWFXPL8eEQxJN2Ic
	WExug+SfgH3Jx5TcN9VeqOxel0MaJRM7zhihfoDQxBHQ4a7+lQK++ZPZFMT+xzrNUauZcN
	3usnMAmSCujwBwYiyunH9P8N9Pvq7jI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA7C3601E4;
	Sat, 19 Sep 2026 15:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E8F1F000FF;
	Sat, 19 Sep 2026 15:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789830388;
	bh=6E/2ltl35xPsVBq7dCp8kX3P3iYtwP2nwvmHYrMGiao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mZ7NEov07DW0ZDR9skjWGGxQUM0tilYV9cJ7x872u31P1qu1yVnwdU0E77jSYzczU
	 Rq0n7dEgh+A9eWTU+kdQxDU5tKshnvcxTa3XN1JDv7zPJ7mxY5KgfDql95Wg5316wn
	 kqxgLNkCZWg1I6A6O0IhltPcOlOLcVqsjbFRvGscwxEQOwDG8XewmgyU6Ujr9SqTuc
	 zEYCMum6E9yTv2amUuljbVi6GJTLEO9nOY5NLyIChsn3u7MRozdIRj+bylE4/Ua89o
	 aFiTM/yy7p1O+kilDkoW7RGJH5LX4eZ8RZkWZXZPSrDaZInSmA804tyjxuFh+fgV9t
	 5tO9QHfxFsFFQ==
Date: Sat, 19 Sep 2026 16:05:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH v2 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Message-ID: <aq6kzpK7wPl3iFGe@gremlin>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914180811.057cba8fcc48d6e0b53a2683@linux-foundation.org>
 <0b064fe6-ddb3-4f26-a1f2-2e9dd88d590f@kernel.org>
 <CAJuCfpFBichJH4OcmSHTb1rOuQBT6k5pXeua9_KgpWjDBKvsYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFBichJH4OcmSHTb1rOuQBT6k5pXeua9_KgpWjDBKvsYw@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DB877140005
X-Stat-Signature: kq6cqa3q118d3zuq4zidbms93axs89k3
X-Rspam-User: 
X-HE-Tag: 1789830390-128720
X-HE-Meta: U2FsdGVkX1/tZuatjSgKjLdC4mPq7iBtS/AkvGp7o7KLO4x+Ee0Nv0Eh4gVc8eJ9ZwqEVfwIkk8j+URzHbyJ0AsP8tNB9ggnqMlCiDk6hdPR8tgtrpwyrpLa4Feg0SUWGwPdK+FtIBnsDf7rIfMOWVqtbc1y1ifLKETP54uOD3npw+n+/UHjuyyx97JomkCsOU9rMmf5dHEKYLcNnzpiVcBWw/NDW9vW6NqVXREZRmgK8LZ3y3ABLC+ybzZPnybCwh7mI7lzpaMZs/F65frNXu8/JlEdeoip1hUBrjQGTq5MbtPzKji4TUSvV9GZY+LUMlw0QQagFItse3CoUv8MyQZhlSorPTZ8YdZVpBo16ut91hYuewhXOvUINLlsdAaYUl8i3ubLm8MZit/OppQCIb0ohLuaR8oxa7hS7MSQwcPP9sKQP8zIq6VDajEE+VQ/XQcNJWo+KuXzgQ9CtPbbKmnWFZgvEuwfeF/5oJfwa5MHE7e5JDH9y64oFLDP18Wx5+Td7CP9bYcLEVeg5YcA5z180x0Fk6oU0vYwJi36V7+0Uhc5rwUwUoDn4klbWdnx4V/Wl0UmmnmbnRCzZVToT6nB2VXFxqkU4ZoXPOLENCfZKc8Bp9KG1o4vKJhzGF7YYac36R6T1GFxU7+klW493taQjKBmC4lNOZnZXUyqQUTM1S/NgTB8h5tDJsV6qT1uHkE8V8A2AVFVDRVpOMd5SGklMR5lCvHgeHZEqareInvJHkiWAAGFX7E3tQnFxVkNZ0dILcZucZ0j6MeP4ugd/mfp/zWXOeSB66pQkmNb+1B9dgq57c3pxOPMj9anymY/394xtD5grrxEvj9upR+O4IDEOJf9zedGVcJPhQSxd5xp5EheHYn+SYFQLdar36+wcAR9wsAk1LPzhZvb+9ATIBjH0oNuCokvZthqq2Kw0iwwPQRsNTLladaNiRmYM9e+f+tqgOdyNIBK7O4ww0q
 Q5h9xlSq
 KokYo+SNF1YVwlXdhAhSA9YrghstNc8T2qdgit2F1N8jhu/nYzTrbkv7mnvlJzbtBDe0kx75uwW4jtazVig039+ryC7o7yoXqIMdlTNFRGJlalaAPcV4yNkppXEK8jZvjCi/iEXLvaqINZ0+xxwCxqWzbZkV76j1b2NE8cmACUccpwdnZxEPGnVT6CGRnKSnj2gcjUjQism0vfB190VJbhJw8kNIm0VqxoEDfC/N+Dr5uHXftpB+nGSC2LmOMG70kOLOAGHzx5sHqKxw8Ud77wmJuuuNMnR7USWRK3gflNxD4jAQDRewY+mTa+IrJ0J1jNzDV0vZJjuHqL0dbIh1dMitpParcoNGWeQcjYHVzXu+d8LMH7G8esOizNmErkvJirINAP1WfNxWsfHjzZZlTVGOB7uAXHCV3+kGFNXZom3HGUzH4j4NrDuXlO/H2MMaw8/ODlUVa/nNbhILqot//LHyKnVHAFeIy8Kik6cEB8Ptr80CEAXIHNxgDjxLKJElwWn0veqx/erSdQs79fIvnThy9uYcmS+whw1sYaBlIw3ffEi0A8+y9Cl+NYgmcBw6Gm3IiNUket2QUd5DYy+RHHDvGxpwLSVBsyHPgcF3QhBmhA6Hb8qza9JSxDBk4W4HzWRZXp7xVGuj7UyLTpDzCu31tcCHKrIsPBySCvqAk2w1gnKKyGtY5VfTpEXz7CFF1iC+YnGVMH1Mv+8rtkXVhTKVYX70aDI0gCTniJO3JkVJ5zdBm68zmQZbycpDKV1egv9x95/sKmso3dCoG31skL8Xn55vlOjCz0hE9+kJv2iV5wLqyyRsTsmhjj7LDuj8BceY5PqL3RB2bPIpyQMmxiHtBpfJ1kBC2dxq1Cx13X7YVUnmX3KFWfW07ECYDZuQpa1deqrfBW7EXKSX3mivENjvsXHHphWyRXdhfD9fnLBuPcxyb2HtJtzMB085NcPPvjgt9UA5UnDrDb+rrhjLax5zOUxWO
 wRQvf4N2
 q3Yi9d0UMm8ilZTpyIgE/BQ6K1zXwUQItd+8P0JKR7BXYWSLWwPaSDZ4fzc8LK7r2k7sisH88uewmwyHHdq59pRUmGa5RhOnDodRmTqh3qWXt/H8orknXU9ySmpGN9cM30bvLE6J0Di+rcWYqI6rxGA8xSD5EyIwunIwwer37OydTctvb2EcldH4R5gfWDWDIwokAWpDAx9G6kikfIXmFwTBY/g7TcrvZQ9Z70vfiiHNXc6umgC0NKCSw8Tps26+ofCalGdYIH67XyVfQ8YWKeBMRHhQadG+eJtq9tJbZUew8kBUy1Za2mx+uAbEW/hm0NZUsD5zy6YS2Xb5aqdfaMXoTAUBflGFrMVKbn87sbvg2E9SzX0Np0nRuZGVV0w3rYTTvVpl9PBvHImjtAmglfE/8Jez23xcCJVDY01hIEqaohHAeKvo+Q2P27lNoxpYUhVqS6t6EgrkJfI7GMrcmvbATtqi3fSCoejwZsLQhpQNeCZ6xhzUiDTEg/GScnszddyk8O9F+2zNzukCIDzS4KiaKQ4uqHM/M5ELwamvpXaSRvGpsDKfNMzRMWjyCkPcGH+E4gqs56Y6EZlrwynAQAfUHkI81K24/9893g7SwMjcygOF64EzVOfwt07AUTjTPq8ssWaFOYQNtGFGw95+KqLFrkslPO094ghOQs50KxQvGOTY+chBtAZLM7VKLnlYo1wNL5QOOraImCTXncojxZ52a6rQjdoHy59CfvBeX6TdH2/yV2rL7lTxYaMo3iJzm1hvYfhkgC/N7E/qseUenCllkbi5xY69f7w+RvT8H9cUXtF90D0fehZ2ihu30IwC6A/dZgYbBrFQkz9TutpIiWFRXG9ndKGOQwoJsbB7o2blwbVAhY99FdLDZV6MLH6WdEGfmQez6tlchlLgsQ6pEeJ5VOt+/ghtQx0/tye+SUurLVU/JtxLRNUEXE/RdecyvWZwBxPBwFR6+Ogi9oWI+tkoLORKE
 WRvTl0yu
 7dV9XUX13ItgtE1f8I2gZIc80AuqyzMPrtzhVEvlEvjAt76kEnmn6xNSg7Wjmc4GGW9Wam5FfvOoll7DX536719O+B6EaywOpP3pm8/hknZ/gh2pMcNwtxRVcipOp5pz/u7j9lWs0IdZ4fXltPwCBPWFe4cd4uS9HCnbaJWH0KZSjWx87HjZt8iS6wdy3c/kT7DU8OqBesMoF8Fqp3oPwSj1UVFeaaKNWn1prOLP3HHXIdZ3fMptipIW0o0rXf1mK0ABYnVD7j5VD/cvfpwZ4OEJo6Ee8zh3ySIzKowYHNAbCPT1IuPLDxgruZNoXAEAIKP6uBxOAmwe7kML0pZVqomJ1JnbPNAjeRQ8PwRPpomflwPZDff2YkPSmqMlnop6/SrlktVONYeH3OJiBH6O0bbDp+uMFvqbm0y7kbvrOXtTENUdrJ7uHlAz2WpHPF8Uac0qFcRc+8eirrWm0uozKl9+b7Ve3K8BHdF3xGL07Xpff+/t+Z8KAVC32EG8+w+KMGIvfMNK05velwHg7CNIbWoZJ7Jn4Ei8GiOuC9BDhEAHGMtYUQ4BM/hJhUi/8Qz4kk30zFQy0XJFsMuRsFa3u3GH2iyPJdSMiGiRuY/DsUMHHYXwhRGChfVVbN+iZmLuaoUDRSAXb5N3pnOGVpCw7aRioD1BkxxNMg+m6br34TyKPQ971tWWrMXtYPQNpwU9hyZrYijMclbpCrnB91DH7LXwmWUi3BK+PhQ8b9ZkarnrfWzr3MqfzlfvtZOAOvinyMkYH4SjW6qqSVetQoRSdbUchmUMcG8XgkPsxNZPOCpvHLt+I0/GaH+2g85UmOCEARiUdatiRFXEoycZjtRw88X6t8bqRW16ikHq9avDzuTP4zmecVP/tggHlCuL+3jk51e577bNeG0KiZwa4/Os8OwzNkrc12UEqVbUhK2qo78RVCRtCjqVijUxoW34tPWct+lKKFK8OXy1SIrhBNhcWQyAONu9d
 AO+2os5W
 eQZ66YWQhGb+h5R9CmQTb/A3NDIi8FOpczkA6AoZTPwdscj7HO4fBFDmCcxL0bGO2nK0yFM1LgewwZaz1FJftlIznGMtkWXgncR86HjKa4bXxW14AIjrJlYKMo5oB1fPBd3YqWT9c+izTeikoSRxE/LDIkpv0BFvBM/hQbyNjUe+pE86bUEebQG5GMnyvsDxohfYqe7dr/fy8rAu7G5lRBHzS6nLYHmJjNkW+2LlErLXo0aP3A8IM0ihNFSxHECU1Qyink3uDjP1CATpK8u0tAP0eGJltTS1iMp4XDEwQsKiYR+Oa+Bb6A0I0O9idN+TXftKPKR+pX5Sh1snpQqFK0W1+Kp27rzmXaqnx9BNHX/x1K+rQhOaho49PG6I+2ioa16W7rWz5Y7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 01:31:24PM -0700, Suren Baghdasaryan wrote:
> On Fri, Sep 18, 2026 at 1:21 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 9/15/26 03:08, Andrew Morton wrote:
> > > On Mon, 14 Sep 2026 15:57:20 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> > >
> > >> The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
> > >> properties:
> > >>
> > >> ...
> > >>
> > >> It's all rather a mess.
> > >>
> > >> This series brings some order to things by both limiting what drivers can
> > >> do with VMA flags and switching to using predicates that describe
> > >> behaviour, not arbitrary flags.
> > >
> > > That's a lot of patches.
> > >
> > > Review is thin and I expect this won't improve a lot.  Lots of "no
> > > functional changes" changes.
> >
> > I'll expect to go through all of them. Might just take a bit ;)
>
> ditto

Thanks guys!

>
> >
> > --
> > Cheers,
> >
> > David

--
Cheers, Lorenzo

