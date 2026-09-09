Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A4DEC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BEEE6B008A; Wed,  9 Sep 2026 08:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570786B0093; Wed,  9 Sep 2026 08:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4110F6B0095; Wed,  9 Sep 2026 08:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0B76B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:08:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DBE9C01C0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:08:05 +0000 (UTC)
X-FDA: 85194100530.06.A83B403
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8078514000E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:08:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TLY49pi+;
	spf=pass (imf26.hostedemail.com: domain of maz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=maz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788955683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0XvwQqrYpxLMLTJmGlP3OBogX+H2vHo2hOLlq5lC/4=;
	b=zINgtJ5jERg3667OqADRE7qMdEP2n4nsOpaLhhv767KYUyGe4K+m4mcXscLMC3Ey3PlGNf
	1PEj+ZOniftsgWda2KGowrVWHEiKq8PxsVLkVr7I50ZdIklziNPdKtygvUNc+cqCOmlbff
	5f618L70jvhOYwnf7tAxB0TYLYLtkBY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788955683;
	b=KOAn0GPyfm+1w8SF7PhnSollEGVAxu0kjPFIJTMWm3Gp0HnN02JTBcesNpsCSUpoXmluk8
	oAcagV4GSZNOQcVPCIOfPZ7vlqnx9+a9ry1IXb812vQeeO3KqsgJAcDWUy6N5lyRDkvn0j
	27S75dX2PrbE+VAhdBS7IAZ/z7qDUYY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TLY49pi+;
	spf=pass (imf26.hostedemail.com: domain of maz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=maz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 05A6F6020A;
	Wed,  9 Sep 2026 12:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B041F00A3D;
	Wed,  9 Sep 2026 12:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788955682;
	bh=s0XvwQqrYpxLMLTJmGlP3OBogX+H2vHo2hOLlq5lC/4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TLY49pi+Cs7EEMaDTGcn4qy6Qpcb4tCLLQabsiuxRuieFcOduuhR0SXsNy/UqV053
	 LTLJzRsrZobFM+u8KAWi/AxL9rak8lF/hB3ASc5j/P5gK6JsTYTLznyOIjtDTtDa+k
	 ORmjuFe/YcEbLMRVg0hXrf/0pz4nkqGBIjyKjBGWoHBcNRUe90PkvSLs5HLrZYszHB
	 EdQZy99ss9QvvDBlcj1jiu7Nbzz/FMu6uLgae9WC6VNYg9MrsiTw00X9RT6CKbWfK3
	 uOoG3Ngxmo6HIBl33vl+TtXZPg1CPUWrOiI2FFoUv677uPNi2hHjh6Cry1F/dt0+F4
	 wpDbNWMsR4n5Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x4H5r-00000006fj0-1Co8;
	Wed, 09 Sep 2026 12:07:59 +0000
Date: Wed, 09 Sep 2026 13:07:57 +0100
Message-ID: <86y0da39wi.wl-maz@kernel.org>
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
Subject: Re: [PATCH 27/39] mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-27-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
	<20260908-b4-mmap-prepare-vma-flag-sanify-v1-27-dacf19cce22b@kernel.org>
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
X-Stat-Signature: 77p5wxomcbyceifn4jgsqo3bp6a6enbk
X-Rspam-User: 
X-Rspamd-Queue-Id: 8078514000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1788955683-890214
X-HE-Meta: U2FsdGVkX19MSHWiFBeknbh/4wSo8Ng+Fm/wMboshGjQ5L5RCzN3VOfOQrTTlIsggD2JiNbJZLg76B5/CfYM2UYBvDlm8CuKa5gj3VUjLf5VY+1t90b+NQYabilOD5MBuyoef57Xpf7xGQ3cw4Sa/5ibmFax8lzRv55ZySxTilW/Vb3LNNDH67eIgc5wbDJdCoI61P73qcksuEpvlxAGsZGQEmVicpazAD5UqG5+utgYfWhNDweA3WRD2CJIhvfzHJcVXXJ/wHlYNsU0jMLeuuHPw0Of/JSARcLhNTOQaIta9JHRhI9f/LcRlvwz8dqxv17PJ1KSQLshVvvEfKunK5P6QKhT3BvxzEXyBd8XC5UGYEVR9Ja7b3URHmVJSfNjadxPqSmrwfQy/PQQUWWZ8tRXcN6PI4SnJGIo4lHn5oBopj0GLli4QGBZcMVr1BLCuBvPg7dYg0keonPZG88BXyIKA5wD9iGvEqdFWCfDQkY6WJIhAZuTMI+o2CUwpNA9VE8QaLomPYHbSWpiy6s2B+lJ15uiq0IZVfGNhTOabX9kZnKr+Lq+wuhpIdQJhvz/grF4R8rAWjF2aOv/C3tXzS54B0K1TijF3ulVXZrJ+YmaU5IOwSMXyAneAYcYQNBJj3KiN7vkf+WP9KyR8pZa3i8DAaNQXjeXNumJ9JmdYr2ZoVWub1OmMT6EaGXc6Uc3O5G3BJ1vcEGcTu6ZHXqcE+s47fuJT5YhrtIhIPQ4Z+PT/uoBXS85Km1Zq9p5UpZYgZCtYMGv4BsWRhbut7fnCjgvyZwRS1JTmmc9hDwCMSdzSJIEB7o8LA0vW4UcbMMbkL+83yqTjG79o8sT7g94JiuOD2usBfF3YyPDI12Ge1xvvxDJuyTEe++Fq9A202GkUz+rH7xKMxzZeE2bSMokyC7T1bmJg2sAgkas0Uuh20QPnmanwiOxyrB6cAFfoM3rYBfHFYpKOxseGtn57Wa
 Ij9CheVl
 YmuFLiXPDD4KYm5/KIbPGyMi0yXhQ+vTrXW7CHcrPpQ9EhNgKDw0zFwbS7J9hqAOsMyRvJ5fIkwq9jWY+22fpI9+LHN8L6gseoUZVKKtJI2IxSDpA9uxDi7LjPztkSKrZKGHCrqQnxJM7qr44pGGzoloh+jaAlzrrd9vxji7g0Ur+YZO2qWleNeHsCMeqKkY2cFe1OZU157pnG0FR3KEQYNBorf7h5anmdg8Cy/bBPRrVgQ22xDjWSFgoLorsXxWz4VwhjK7TWdez/2T1hzpThx1GurCtlbDoKBEqyN7j1dF9dm8I/rh+oRKBffbaSMC9lA75mCJ/MBgQL5bL6EEwrJ20FAAKuCMRGtHYAvSwhW3k3gh+XORwyATzF7RcOq23OmiSlnGmpyloL/RCkmVmagD1bnon1q6xtV8LVkaQzNcIpILfBTe93Opd/EQZQqZO50PuTpDDm4t5DrndWv7Vegr/rxn1BdgBKyApyajwEjLpZFdu+W5qrv0W1W6Ld+PSrftZTr+H5kGL57QPYQNykos7YQJvdmn5phMRgJGswwrilmWZDtDrEMLgzpEp/ewCfU4Okdc+Rh75gDVkAsJUYiEOtwoumnIgGL5UcpG7pPqoNSiLUce4e0SxZ1I4Qs5jKGSK6u8FyJV+f/G2SICdX1qzKVn7WUJFlzGthMadU39ZeXA23Lf2Yne2nCP4+SuTxDcKpaDyePikurLMSobvqRJz0Hfj5l5j22Vx6tjXfIC+wjwo0/ohV9wdWjBEBwViSug/uYZEoZqs0L0vrFrpS/Pqh2vsvjQwFuie1XqB093q+5WttVA9rWdXAaSMlyBevpjTUsgTB+8KISl5Q5MpCQkItr88YFo0F90a2rU6FhnHPbLhT3W2w7Nb/oiTWg/k1aA8CcARHcMY9unFyXh04N7wonl/xhATADvdvZ63qbmU/USW+XAGEhOfN7AM/qSL5AQB2X75ZYQQ4M5EMZz476Ymmixr
 K2YqMx99
 o844QDYkQPCE7so9Iv9u2VAukX6AP6L0VG3r6HLt/wPcLCdGIDRgsXaR7ylq2ckdpkRUO0JxEdsvNDfV3waQt+YHUkAcIjyv/NpC7biP64mCaL8boURm8N3HcpJVyOOqx9Suar25KhoCNFEYrtMLpZkWyO6SCPXVCEJGn2UMqBZT8flfgYF0f6MUOYlC/3jV85TdAkhfSklMF+ksNQf+97mrFextwxrGPsoeknx/ksbsQLth/dkaU5+ps+0nF4BsPefflwyQ/J0sKkeTsiDOlSnibxjtH7hQ+P/ubkwdymrtuCDsXoAvYzZ1mpipfLF41m9kCxPHtLKht1G6NoMiERO0rHuhYbelGyI1GmlrzR2fcnn8Z18VN1Nr+4qRnD9r7tr1jk4eGbj2Etu5LSpdL8JyutvdhNPn1DOGSpR96izbr3Im02EtAJPgiLejigiYMGLIWh0D+fkme38zbMt82m1PlRdHhUjHxYJWFibNZtYzSjYKipUw3zOeHqvAc+4+W5AVW2GEpk5T8ZUGKZctNA6mnEUoVzu7s8ACb9QxNYS4fAumrsRTTVUPk7eG+rqMEkhaYYlXM6gRqDwM1QrIsLwZ375x1XI3lMqt68rVcGEwuEU/n4A6PvFax8bKLyMS6CUPkpc9ZnqmUW6ZPCxpBT+LuRNqqPNzWgI2uobk66d1JPUGFTlIsyeD+z2gWmzJ8MHirf2A5M4dTTAWZahkcem/s702vwpmaQm+SQ+BJEnwXxZ5WXv4Ka8yX13CTJtH2eXKI/FCcD+y9kAML/ivNUFbyJq3/KXp7djFzWzd6Y5gawAtnE1EfWlJZs4t+CRyvZd90kJ0kZiA4zoTSVPvVT7kHSQbHLKXSMIKUnKmpQLlOrNL98lzF5lL7EPjTMY33dCle53/7Yd7wK6NC3saPGiy3lyEPHFD6fsZ0rCdZ2rCLbBxlqzOkt6ekz9wY0NjwRKyWfyZ3Ip2iIPa3AG59pSVfdg9u
 I8LF6Io1
 uXkrpAIQ8Kl6WE2V2CH3tpuqwtVHfEmDBeUY1Ya/Bd6h4IiDSPXB6FH/mGCk+5ydf0PqPZW/UDjZlEDcbPVVR5NnEb8HuACt9u8u31GYg3u4NH0owim0JHPR9l6XPD/5gGPM04Ex2ya1msxkJkpOkkyc6Ni+NhrONdF2XffwUF0+A/5dahWIFreojaMnnGb5VgAT6jqwYtdLQWHafsmi4V1Bxp6M3zCfz7tzWqCyNvKk3OKFySHjHyOASXFJl8GT8iFn486KrFL5EdgSeqvfYUGx4nVHNLuiSJ3jP/wXBI583FU9P1o+CnDovbdCVuT3eSrlV7G6Qd+pLedyuBgRlZvKw/Ik2nCTwCDxaoIMxNfBMM8/2eWn2nSkFkyLCziUKrRFGw2+rmksXj8sktuiCcNJbaRECloyL5oL+WCs8yU9NYgwe24rpanmZMOcCJvnh8u+Gmk6RQP4T3nY6GHayAdaDe+g7ZNGoFmF+M7EeUhjLPLkfzocKOR4wbctHXxE1beBIgOe6i08+8BIISPH9ZaJLLgoEdNabiqS0GScKNhMFtPj46M1xbOM0WrQAmbOycE4M5jcFUjY0TLRfI0pSv9VqSfh3JRdU5WVl9Lekt23xB6wbweQUgNiyG0oUwDTfyxvH9QHJB1gCBQ9f8nOTZMb9HNMUuE/qYF1LhuPBblg9H/4zBJOhpulACnqSqbJ2lesYqRFEc1KVgzy6omqTBFWMUdJwssrZ9lVnfPqA2fqv7Za0ALvD9z3wvd847IIGZhVu1A+QDiqKnm9jPY0lYexbqmz3sbED9r9sZpYdijSC9N03KIAQ3e8NArwlYpFGU6MTgTwWR6hp3F9Vm9Izy0JMzJSVZ7AOgys9ByIqWFrw/wI326kD8X/WFe2UznWEf4JZA+xSABBNsRi6T/ji/jaQJGtn5y0czY3LhH7CogK++gwpzPfYFseYf0HzfOu8Hx85yFAmKbu3eI8oX8Af0UUn7ea6
 anALIUUM
 q9+vCGUnottURECn+VyMhnsNHTAneZY844fvBCWAyVUTP7mmOYIyAE+nR85485vyxJm4D1iJIQAa33cP9bWct9L3cLfHj702Bc4JFcwgQt9MqgNApihzRZ/vqRH4YzNWH7hhqaTcUHI97tXH2uE6OVVVYk84B8YmyAc04kB2qTSjbnSwhOZEe4RbLVE6Buf3AxIM08rlBKJTgxs+Kmh9tkJCHfzrNk8ei0JNwODNfmsAWo+3vjyXOt9IoeUaEeFNEOitdhy6H5ZwxkTfwM8mO0REs6Vye/lxH59Pw+O/DZHuzJ1DtIluc1IT5xvqSfgLmrJq7R0UsOnZRXZMfR5rIt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 08 Sep 2026 21:01:31 +0100,
"Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> 
> The is_vm_hugetlb_page() predicate is badly named - the mapping can span
> more than a page and it is inconsistent with other VMA predicates that
> typically are prefixed by vma_.
> 
> Rename to vma_is_hugetlb() for consistency, and while we're here update
> some VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA() as to avoid unnecessary
> oopses.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c                      |  4 ++--
>  arch/powerpc/mm/book3s64/radix_tlb.c      |  6 +++---
>  arch/powerpc/mm/nohash/e500_hugetlbpage.c |  2 +-
>  arch/powerpc/mm/nohash/tlb.c              |  2 +-
>  arch/riscv/kvm/mmu.c                      |  2 +-
>  arch/riscv/mm/tlbflush.c                  |  2 +-
>  arch/s390/mm/gmap_helpers.c               |  6 +++---
>  arch/sparc/mm/init_64.c                   |  2 +-
>  drivers/gpu/drm/drm_gpusvm.c              |  2 +-
>  fs/coredump.c                             |  2 +-
>  fs/hugetlbfs/inode.c                      |  2 +-
>  fs/proc/task_mmu.c                        |  8 ++++----
>  include/asm-generic/tlb.h                 |  2 +-
>  include/linux/hugetlb.h                   |  4 ++--
>  include/linux/mm.h                        | 19 ++++++++++++++++---
>  include/linux/rmap.h                      |  2 +-
>  kernel/events/core.c                      |  2 +-
>  kernel/sched/fair.c                       |  2 +-
>  mm/gup.c                                  |  4 ++--
>  mm/huge_memory.c                          |  2 +-
>  mm/hugetlb.c                              | 14 +++++++-------
>  mm/internal.h                             |  2 +-
>  mm/madvise.c                              |  4 ++--
>  mm/memory.c                               | 12 ++++++------
>  mm/mempolicy.c                            |  2 +-
>  mm/migrate_device.c                       |  2 +-
>  mm/mmap.c                                 |  2 +-
>  mm/mmu_gather.c                           |  2 +-
>  mm/mprotect.c                             |  2 +-
>  mm/mremap.c                               |  6 +++---
>  mm/page_vma_mapped.c                      |  4 ++--
>  mm/pagewalk.c                             |  2 +-
>  mm/swapfile.c                             |  2 +-
>  mm/userfaultfd.c                          | 26 +++++++++++++-------------
>  mm/vma.c                                  |  8 ++++----
>  mm/vmscan.c                               |  2 +-
>  tools/testing/vma/include/stubs.h         |  2 +-
>  37 files changed, 92 insertions(+), 79 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ba86450fe4a..a7968f8d24bf 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1463,13 +1463,13 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
>  {
>  	unsigned long pa;
>  
> -	if (is_vm_hugetlb_page(vma) && !(vma->vm_flags & VM_PFNMAP))
> +	if (vma_is_hugetlb(vma) && !(vma->vm_flags & VM_PFNMAP))
>  		return huge_page_shift(hstate_vma(vma));
>  
>  	if (!(vma->vm_flags & VM_PFNMAP))
>  		return PAGE_SHIFT;
>  
> -	VM_BUG_ON(is_vm_hugetlb_page(vma));
> +	VM_BUG_ON(vma_is_hugetlb(vma));
>  
>  	pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
>  

Acked-by: Marc Zyngier <maz@kernel.org>

	M.

-- 
Without deviation from the norm, progress is not possible.

