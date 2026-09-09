Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9A82C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02EA6B0095; Wed,  9 Sep 2026 08:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA9F6B0096; Wed,  9 Sep 2026 08:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA37E6B0098; Wed,  9 Sep 2026 08:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 740B96B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:09:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44BE9401AF
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:09:02 +0000 (UTC)
X-FDA: 85194102924.09.70702DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 66E6D8000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:09:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QSBO7XfB;
	spf=pass (imf30.hostedemail.com: domain of maz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=maz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788955740;
	b=E6VRTjFGlsT/khtM0JuO7U6HeDPV0lj32vMpleYK4TSh6QQ8CPlP5135Lgm7frbIm/+7x4
	Hnp/v9FgplgO/Rq3gHioN98TO1YgB6VKuhfqI2HCKqEBIFPmS8NmTLDqiF8Ki1lC4je3Lp
	AGt6XB1MmqpWY7E77KJGsVrSV6rPKXw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QSBO7XfB;
	spf=pass (imf30.hostedemail.com: domain of maz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=maz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788955740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vl7JXesMvOyLvN4TqdpRFvW5tHWQV0Z6fTfMaOZcos=;
	b=4SojFqxGy4QIdjABUAF1W11zvFG42rUWiI9l6qgWy6+8ip4kO6+TYYYWH7dxUa6CF/2/bl
	aBGpw1K9aRy0XXa2zWD2aTvepQh0wqisRdZlKooDOLVtDHuFuqdUkBx3YzWcr0u42HxonY
	nMB9PJNsWQmCpxvEZOw3SNqiPBWvgQw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B45743668;
	Wed,  9 Sep 2026 12:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC671F00A3E;
	Wed,  9 Sep 2026 12:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788955739;
	bh=+vl7JXesMvOyLvN4TqdpRFvW5tHWQV0Z6fTfMaOZcos=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QSBO7XfB9eJuCgdZw4woX9h6hLVv1DAAKEMcqqTtIlfNGaiMpuLvQbzhC/HsUDqDy
	 15tzsyERcKb/dCy0KrTkU176RhbTCcy21TSs/XRVe0a2CeHrpUDlqlX+4eqWNdQmSP
	 ZwfdXLWGjYgxyEXXB+UjA+lgDSAN24eS4K+Y/at+9+bmLKnF2sQtudlKc4XZf2yWBT
	 GWiqoV+03Qgq8XKU5kEPlMdYwMF4DBOmSD8P6FFdNW88ziMwb+5x2tUJ7KBFC2OEkv
	 y0F1ASE9ljvI2KQ6gM2g9pgM4YchyP5SgcvLLQZd8YcLUPlszfpfiqg7ho1AxZsTq8
	 3yCEIs6vu9sRQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x4H6m-00000006flL-2cBD;
	Wed, 09 Sep 2026 12:08:56 +0000
Date: Wed, 09 Sep 2026 13:08:55 +0100
Message-ID: <86wlsu39uw.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Jaya Kumar <jayalk@intworks.biz>,
	Simona Vetter <simona@ffwll.ch>,
	Helge Deller <deller@gmx.de>,
	Sebastian Reichel <sre@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-sound@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	fuse-devel@lists.linux.dev
Subject: Re: [PATCH 28/39] mm: drop some redundant checks around hugetlb VMAs
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-28-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
	<20260908-b4-mmap-prepare-vma-flag-sanify-v1-28-dacf19cce22b@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: ljs@kernel.org, akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, david@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net, gregkh@linuxfoundation.org, dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca, leon@kernel.org, paul@paul-moore.com, stephen.smalley.work@gmail.com, perex@perex.cz, tiwai@suse.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, mkp@kernel.org, jayalk@intworks.biz, simona@ffwll.ch, deller@gmx.de, sre@kernel.org, jhubbard@nvidia.com, peterx@redhat.com, mhiramat@kernel.org, oleg@redhat.com, peterz@infradead.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dav
 e.hansen
 @linux.intel.com, x86@kernel.org, acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, riel@surriel.com, harry@kernel.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com, will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com, arnd@arndb.de, muchun.song@linux.dev, osalvador@suse.de, willy@infradead.org, jack@suse.cz, oupton@kernel.org, catalin.marinas@arm.com, maddy@linux.ibm.com, anup@brainfault.org, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, davem@davemloft.net, andreas@gaisler.com, viro@zeniv.linux.org.uk, brauner@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, chrisl
 @kernel.
 org, kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, hannes@cmpxchg.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, xu.xin16@zte.com.cn, chengming.zhou@linux.dev, mhocko@kernel.org, miklos@szeredi.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org
 , fuse-d
 evel@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 66E6D8000A
X-Stat-Signature: corr9pcm8ojwsgrexeptsuzb1zd9cscc
X-HE-Tag: 1788955740-176327
X-HE-Meta: U2FsdGVkX1+B7HErZQ8TA0VhAFfMyISvWV+DUENkkjRE3CgsZEVQpuxUGXoITs0fSurtW7yJ5fYRnh2Xs5cRHItbwwD+jGfcG0nUqJ6TKZBD9Mr6S2vW243u8wflcjZycb2iLyc8+Hpn6n3mIBeZCUOJ8iKa4mNgLcH7GN71nlGju7xUh6gXh4pAnrnzLYcN1CdCjrUuJn08mvetpqvTOSa6v8TGhqhUaJvVEmzGCYv6NZAjGk0KEtby6Uzgt7/ZK4iV+n7bvJ0gHc/oDv5yTKNuVfMcbHYOEdvJYEbabAk6jInzi1SgDe7yfhNJYEfU1z6gdjd6+VPB1cvLZ4NC1thoW5wSoXQEcTm3jUBHrnKspkcluyylz6BYlsbpf+ZMWIbKspoOStmwuVj2TizBI1x7RK8bmac/KRW9f8otlXi+CaGE6YxoiODA1loyozPNa2zOqC8hfKoyxzYIn6HeDysAOZW/Wh5MXAe753/C+6FB9WRvlo0E7kf7Zh29VYph7ykDmlGu8r1Pl1QzXGQmJuVHRSM7/4p6waH2g9i507OVkAxGhNj5urO0007kpMbpFKB2DtuCv0mr9lb4K7P7UWvZuLrmBjOauec/Bd8YWvuk4qCAKTDKRPrT8qDhgSA9VBPFKz+23GG6Bdt//23JrabFbBeS8NWeZvp7BN2LYWzg6kw3sYHzIAnEi/P94NKJjkLNl9p4RJvmbqXIj9dwPp0MLX2sxen1CnFWG/qY2jHhk24u4IOQSOYhRN0qbPB2akUSoCNWVMRUaAD6oSCJxp3wEEO+eXmGPV8C1EGy0B8+5NfpvCC93Xe+QT94zvHWPm/xZDqKwiAuWvj3/Ia+TTChWqPNUuN0bBfAynhzeql7u//Ay79ZjmE9MHFq6NlAQd8qhElM4KOYwjTUkOVMRhhaWPVLbD1h4tUHUUnYPBspFpMPYrtIhqgby9e+XOgeUujIalliVx1WupgxF1+
 evFPuuwS
 uvizYvlKqRRimuy9Bk/GLOP3Nqmy/x8WIX1eHx/tQ+zjV5SBHuq2FPNpUSD4v4143ApQaHFvTZZQ7aQPmg1xdZufIy8KlA4j3277wXPcCdJLhLRn6O8ZeXxZ9cISvtkVOvrhhb9lfrJ8i2AEWsQV6I6cHyKesJvzmHzuttQKev7yVdPR7ex3XQVK65N79WgxTiyY0EO5mwg6alGvxH8pIeZXNfKIzff5nlz7mtURRbbELhpuzeaAlcHdL1HyvtFzL/gZP6z04uU+3F8l7NONKuR3YHYGvizm2k+gc808wy211SqTblK5f55F1XukrPu5xilogoVH+llaRtcb/++SyQvJWI9LrNCKdZlObNe3aeKUjOKni4QLkFE5xO4MwZ7vBG5SbsHjJ+UQgCB7dgnoCdUaXKSu7JOs/m3W0Z4EmvcSRK7RpBukVh2qqoQeEXROQ7gHyMIia38YxOOOAOSl4rOqWV6LoDJjU8ODwr3Z9Mkatqb6/8JYd4IHIDlzsW/4z2BBxYvS8IUglZ19hLepMTYbE816pLwMYRem/HKlqx0otpwIT+ciHoBPP8o5L2qosdm56ehicDFNgQjTQOFsTCsFwUk9TspZFw/rIaUrsfJiAGaQa+M0+3aDoWaAcPfnSnweHzEAmA/wfWGL+k9LvtRbI+VAkQAVfE/y0lt2tHfM3ZBA9vcTvanubp7x4rPJDZqeuPYANYZ5J2GI+jXPSblmGCYbgPauH0Lwd+/SSQoFWz5/9QcmveyiFTM9VnBuGf8/Cujde7I7P5HaTpx/g8ZL8ut0LsTNf56Bo75t1VgtrhDy5Hx2CckmxsD3rRl1jbHVjMKFp2S+vlKAxXgKRZJ7Ru8chsak+KYMgvDaTAgE2lEy0RNl3sFx5r4fJgGuqzCazb1dOCF8RVF8cmLHg8vTdBtIdc1dcwNgLHw5gXyJhTsEfaRp8OkB4uilIlZ9jau9yxLxvCznE1P1HhijOxDmCuAy6
 pmV1mpL5
 eqneVduMwkqcmlTz9g2/jcrO/MSJFobY5+h1wy2+yzLoOATCWPzEEYjuxOJ/s3BrXGsrnnvTX3J5b7Kp1VVMAomyP2EuRlfdJF4L0IDay5MR+qak0WgRnqkI5QFf6NG++UvK3xU47dKqL/RMsZXVOrnQUg2zPzoKqTP2HuDhVVdASgh6UYVIvJMP7geUeG8y1hvNooh5m6UVCWj/nxSWEx6iElfGGOnnidZmU/LVFnqEgeybxmxS8GdfWpqb1eoRBsVETBxIC8SdS8p7yejrDH+GZk8NIzW87xg6J1v317QOd5MI/EgO1/Yffp+nMvI3gAjo5einE9wwrR61MvE0a+jGOnIjPZP6YQLcfkkaUzJD52n1myOYOHl1FcU9TLMYzb9n6UE1fVddtPlqRS8IBa3R3ZYOFDKmGo6CWhP5G97MtrRrXF6K00An1v5m02kOdtjNaHL2+0pPZSw3wUJz25u6a9H8MeIvsdB2NBfF42Y8xAJHVHG9gYU2HTzZMkMedbgkV+51h0raFipSOw5sOtSvXozmml6zXevpUySOE+U6k4vGaMQnMcTqX/jeq+yop93V8F+VuakmaWx+386NMyIH12b/txIsH985gxW7Kdm6hZN0s3N6DeEzJ7E0WtFoBy+lkQXumBMTDGD5rDF4Hh80bFUU6KfFAtuCfWqCr7iSEDEJXMS18e5pnLAIH9zE25qO/37Ry8SbGhpfBg5Ot+fY5oP7PADp8eEV8Nnt144Zo33n1IzjBcTILaCm9Swru3ESLnul3osSO1kHSogDO7JCIZeVAhm7+slg6WofJZsTR0+dR5w6shWnAEQjnQcGqbzPLSZjTRSu14cB6CSSixdT4IoMFUeUC+ruW3EpS0PBPKPNY+YxmxIADawnuxICSdo5raFL2mXpfs41x2STyv49/t1e6bQ8rn1ePqqNNpcd0FoCNyGUoB2m8xl1GEVAa41mLz6j0haNScD/NAK3ZkkyuNX4S
 22QZanYg
 JMFGPqw5VGF7JHQ7MqiwlOAo4zIWE+yilk+T9anxmCi83MQpB/Y6Z8M6UO48B+LMBRxgsDgRI7kRUFcTng7y7Nx0fy3U2tRfR7XbgLAgbDvQXT0FE6tClnUW4UYVYHk0ifdlxdozL1xd7taUq/07sAqdC+k569EU5EY79THUnO04v3ZF4PxD+cgyMonigZQ01ARU7vYAFjv08rnZlvMci3wipkQuu1QN8UGKXXsKeAa8dNouldheho2dqG+idyL0QQDe13Y2575pTUTj8xA9j9aPSwwd0hXN5UdjkzN1An3bayVENyLB9cX6RVaVB17dkwbhs88GZjH4lul43QQ/PqWau3dMTwPRTs0NVO7Q8YyGfaZtiM5gfY2XIze7rIo3DVIn4Q2j3Ji2LH5jL8rxX39vgnnOGWrYxdP7SwmfvsLV4wKhcyIzDxzmCDpPpdH+2JnThKs4Sx7zZU0NIxfOMPPrFraRGb1O+NvW/GGDn1mlyMJNXlUtOTvG81NN1JCCGLoponouEK/aqMDF2vAF6v2PUnuyOT3PYkOTXI5aTaGPB7EeWVAT7Rw4IiWpsjtgYKrzTGSvLSQLGK2ADSUXIYvISB7+QyEpebml7HKMVrpmQDilKyrkBxwaPCJPujS7KOBRc3eLJhCgI7GVjp8mHkjvwSapiMTCplB9YW0xkW1hroBxCmnVTzUBo8nHyoUo+mTtmKoaZ0o/emLKUUAyiCWAWQChZuKjjUZbt1nqE7CmoPBuAu8ypIB3ylbez6d5FOukuzW+yQ1l2J0XKLTelpHkdpOnsFRwAJzmqefo04Bxq90S3lzciEgmY0UrEqMyEeE6wbDFNYXC4eWB+Bi7LlNzAAMAkWoCAbSNBDCmtYpCOk2YaeQlP+G6Zlt3d6Ebs3/aYdRzhn0cxmoC+I4sEBxYCHoeYwIoiM//fITFAad1ssue4whGC2M/OIQkFghYdCXff9W8OACAYUfELVI+1F/k8Qb0g
 rdgzk3eN
 AUds3vLJdBPO+pBr1iUWrcRV6ODLBgrbH2/xCDfK26xZArxjEMsz+2CAI6tzjpipepvkoyR6DymL6nQX7TWQP6vvteWtnHlfJbTnJY94VwX6VQJV0TF429xXKTn/pbWrMdw2xPPZcmFn/mDsNJvcGJ5miraGnKK5mgjSf/5sorbuzLbrDdi3qZpw6zxsAK96Pgw8+fg5WBGEq4xKPAV766JgoCm0Lyq9VaZCMHPp1Y3KkYeFVxv1AVF3gKvZy97Ezygl0fRMbOqSNuCar1+gbFb/c8hxyfEd0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 08 Sep 2026 21:01:32 +0100,
"Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> 
> Adjust code which inadvertently perform redundant checks on hugetlb VMAs
> and clean them up:
> 
> * hugetlb VMAs have VMA_DONTEXPAND_BIT set so a VMA_SPECIAL_FLAGS check
>   suffices. (migrate_vma_setup() regains an explicit hugetlb test later in
>   the series, once VMA_SPECIAL_FLAGS is removed.)
> 
> * hugetlb VMAs unconditionally set vma->vm_ops, so they are never
>   anonymous.
> 
> * hugetlb VMAs do not set VMA_PFNMAP_BIT so checking for this is redundant.
> 
> While we're here also drop a VM_BUG_ON() which the simplified check above
> makes unreachable, and use the new VMA flag API.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c         | 4 +---
>  drivers/gpu/drm/drm_gpusvm.c | 3 +--
>  mm/migrate_device.c          | 4 ++--
>  3 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a7968f8d24bf..3c1240ffc38d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1463,14 +1463,12 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
>  {
>  	unsigned long pa;
>  
> -	if (vma_is_hugetlb(vma) && !(vma->vm_flags & VM_PFNMAP))
> +	if (vma_is_hugetlb(vma))
>  		return huge_page_shift(hstate_vma(vma));
>  
>  	if (!(vma->vm_flags & VM_PFNMAP))
>  		return PAGE_SHIFT;
>  
> -	VM_BUG_ON(vma_is_hugetlb(vma));
> -
>  	pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
>  
>  #ifndef __PAGETABLE_PMD_FOLDED

Acked-by: Marc Zyngier <maz@kernel.org>

	M.

-- 
Without deviation from the norm, progress is not possible.

