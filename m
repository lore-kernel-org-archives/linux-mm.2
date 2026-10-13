Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4350DCC6B1C
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 18:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286BF6B008C; Tue, 13 Oct 2026 14:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210136B0092; Tue, 13 Oct 2026 14:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0FA6B0095; Tue, 13 Oct 2026 14:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D51916B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:50:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 732A81201E6
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:50:48 +0000 (UTC)
X-FDA: 85318494576.28.1B9B220
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id DBB62140006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:50:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EQ4XU1XC;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791917446;
	b=oANFLCEkdUwa775a3fmcR0hYU5PPjgBzmC3QsOrZojZc44GFoLdqI8avYggsgwgK0Q3lW+
	plw6HUOtpzZcePUPMOQzVQ5Iw8aTzEml1piG103QaiYbeCCOrGafkMIKfEK41gtbbjWagc
	TwnfiGgakz+Calvox+mPqf57P6sV990=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EQ4XU1XC;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791917446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuZf8a4s4KeYVJq+WlBcJeJCEq4B3iFccAJsrfXV9NM=;
	b=iTSUCYNhAkA53SnRlT6o2VJLlFZRbVlnZ63ykFosX7+hM63TqkF0hQd+CkBgy/eKQY3PRV
	5ILegtkWmt81GevMeCN+DSMaAQhk1LmqWyg+c51ftvwHFDEPD68VxL6nCAaGeNhj4rhAho
	f3Z1LPriI/n9LKyd76DfQPgc+Pd6ZQA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AA71432F6;
	Tue, 13 Oct 2026 18:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B161F00898;
	Tue, 13 Oct 2026 18:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791917444;
	bh=MuZf8a4s4KeYVJq+WlBcJeJCEq4B3iFccAJsrfXV9NM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EQ4XU1XCFoj78Yyeld7YNcnP/9noZdX9lN5UCdmZcoKGQgrlrhgFY+A4mTo+auY+J
	 3Rac6nV/fZjHnfKTsq26wtuqYJMvkhuUDd/fkVCVq1fYNre1356490QbzZy183nF+c
	 /ycTbc039NpvwigJiKoRCcMhob/ZU3R3AoCJM5Mw=
Date: Tue, 13 Oct 2026 11:50:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dennis Dalessandro
 <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela
 <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
 <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya
 Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert
 <dgilbert@interlog.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, Helge Deller
 <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann
 <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan
 Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul
 Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Chris
 Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chengming
 Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, Miklos
 Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org,
 selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, Bert
 Karwatzki <spasswolf@web.de>, Takashi Iwai <tiwai@suse.de>, Emil Tsalapatis
 <emil@etsalapatis.com>
Subject: Re: [PATCH v6 00/39] mm: make VMA flag semantics explicit,
 eliminate VM_SPECIAL
Message-Id: <20261013115040.1583b1d8e85c4b5d65a1ae0e@linux-foundation.org>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4ih5pjbdxhrjkbgy4dedsr46xaqefkmw
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DBB62140006
X-HE-Tag: 1791917445-801061
X-HE-Meta: U2FsdGVkX1+NSeSTtIJa/x7Hq7WOkhkEw9oxk1+R8mrwjuU0LWY86zhtMt8B0ADLiHfUgJnyx3smwwTzMthykUlDU579YDgDn65QsQZEszIdO77+78Ie6taW5ai1yG/RfxocO84Qwtxm0IDQD0nW3771eMWbiT/AEAaZEgM3NioVOwT7FkwuZfV+o1v0tFPGNhXPw+P9WKy5jXRuYozuolBKg6fKCW/JaY3Uak+s4YQWyG9nlxjzVCTvnLXgEPqKo9mbNpRZFCIY5s1rVkEcKNiJGXOPNOdUj3Qi7cVpodJy5PPXn3SOc5TX+asYtuuPXmt9R2obdn2P+qwURakJypnuq4PMEdZZhOu96f5+JTBAuUBXURJmE/dxkK3Y+HwoYptdea+S2r8jMLtMpZN+51ZkmoTX3WIHEEdBBb0pr0pN0590b1J6Ext2f9dDogEUtH2Vyg4WTl9j+kEFB1F8fF975Q8HxYzGr8YheyfGqbE4ijUrQjXyFw4en83dHmeCazlm5zhME4XFE6D47pHOsggQRdhSK/hqdDT3uz+IiNsMsCcJhqiEdOu9/3sGe8ZuRQNSPfjYNcpfEEai9+lq8Ppr518fOKRryFMNzbb/j5MhzXzP4CxOhmNfxutpfmzqFCKB1kaf6swEBqvUFnsljUn81Qp4dMWCpAFMunYq6J9joygo4qkl0ub5dFzSSSpzNQfbA0+ITJPxPUIV5IQSx6Rcgj+8Lz4SMP+SSEOCz2IMbTtKC9fVRFceqrEPm9slZuhHxhzOLwRcbqM/Yp0vF3aOJDvr1Uhbb9F35QDRCI2Wm+aofCrNRS+xT1JDHa5xMK9ECzkc0ale+KsjxhnSJH8S18JZ3dIG38xxIM3g6f0REZQkKH8KwctQjD5e2CnGEcoXWxE2WVOhsN/PJ7ZbbrwIRjEm1/e7cI51NF8Y/UTFoCuWxA9fwRQ/CgtzDjzFKkQWYazr5suNJ0s85gf
 +O2FDjbb
 4Cj0QWe7Dcy0Ez3fusKsHvMUbBBtOI7QNoySl7TgBqfLOSB63UaG/f2YEBzLG49UIFVfSf2rHSrUyxisECY2YEE2VVMn8Pyv3Xq1pFfNW23uOvWXaPnXAZcRKMGNDdtpsWdTG6BHNz84Vq/YOQ9k3FcvDpzkssaP3PdxXYuGYExpdrwIhl030eHz6vjHClsrT32J9qYafDaZ49eKyKuzlVvfW5GqiCn4Lrlde4/wuoon+3GwBcSrgfuF9QH7A2fULFhHD7sqCfO7PixwyHFtWPjVuEz8AFgzQb5CMxT1acBL868Vo7n6INfl+SsS3KNxdRKAg0GsrQ4VtICJ4Tb7n/BEgtjotzs1fiScjol/d3eITvslrnB5evM9QuDyuUK8GMGzfIrRhVvBPhEaeiZFD0c4merNsERTwflSm5C9RVdEM9VZwb2Edq9JP8lD+FYW1emq7GYgifdfHAvIbCI8an0MCIRabUZ1zcq+WWKXf4jEKBPlEuamLuYiQjqvM4CFGHGInp5TgvoQY7Qc/V/9RJoyhWgHHt0bDkpk00weleEj4geKmFPgZtVHzICbq+8hetfeK0ILERSjGlsWbBEEVvVe/hKqkDOveK00mZpcijNSxgJCkxK67Xa4ygsl6FwstavL1U7pRwH300x/lzWe+ofOIdxTqhlcXHW2FZz4o2iYz8j7EFF+Ek3nxy3W0Uuhc25YXKgJCHlEUizaR9wteGNVqHSKQSZvaJgdjWL5/b4vVnP8S48rHbrUw74n7Qx12dv0Rm1MGBGFJLF6xxN4e5a75SVIR/50H9Ljqp1xrPi+PqeBlY+jIWoFCM+j9OHj4PhKwncSjoP6hXDsoKaao4M3tNceSInuonPRXfev2L4swQn+D2R9mY3TziS8D2E4w8D5rTcjV0ij1pMSs5rjME3r1V5nw1nsCaZgIkCPW0RzmQxCrEwjkqoiswvSBxUQtyyT7Kewh6elXxqfE9T7FP9uLerg9
 0a+YosyA
 zzUGd9rkDNK7dCjnQj7h469ueA51w6w1c55+r2LhtJij59I4wIXyRQnxi79+bFeVSaiRR82dvUvycIW3A419L2W5+MIMWulnXvl0j24wIfwOUf69CxfdLVw1XZthdgZ+x99LYvHNIkwi0jazeu9Oi0pLSiBXTIj4IO9MmNnjnC3ZeSas2ppzoVJbYmaj7PSQ9X8BAMiXfATd2M3n5MwNvJJkHq15PwZfOjL9t9SUqIwS+GX99eVsyCX2LFbw6pMkKT/JOJqsD0Y5TNMrl1xyCB11zVgsAAvO4iie9aqBFm3NXRJJJpdIO1VTYLHC901mfgK001pfICTzLALwCBqtt7maVqHiue1qioDIRIxUKeISTMb5nRNujfOn2ACQurZo6+FiZZ2+Cw2yHH/U8k4nOsb/pxVu4FFiQOEX/pt42exv5BMDF/HffPP0hbhf5Wkr3kiA+WmkOrTl8EBQ3nuoeCiJaQ/F6b7E7hIdA5vPT6pdwJtjZGc6ILin3H7ce6uj9e/2Y52tNoWv7VUt408Hx/grkMVc4+e1gGinJZYXMQfABW66V1bA17vokICnC8wO1qvISCAkTsnhCxShb85/91XJ036YJph0/fMkDK/TcwGUuYu9+v+Z9W4bMT9M7c+PCkSTAdNtsjOsK4iHG18whSA/kjV51TxgDR5ls07lm6rEuEg7MlWRptXonycTaW5TrRjW58TeyGSyOGwfzSNtre15OByL2UhP+cIM6BMcNDBfOeOgr63gAfH2lErDZ4RxFcTyqGosFdS2Rhs14qs8Ecb9NQ36ZUDxGtMlXNI+P6F+SovaVLQxYQG9W33yfXDg6gb2guIWQoZzOnVIuQgF2YYGpbadm3fihH4TzeLUMk3D8caeEeXI13iK4fx3E3mzHi6o3rJ7H3Sm5SVm7GFmaUyhWhYcOJETb2+WaZ7b/oZv8yUSlW+Gb6madq17iDyL4ED4yNsJzYrQYl1WBvyZv2lvsb9/Z
 TezkmhyN
 LgLjXnkwZh66zF+Y+KUD5SoruDr8bC/qKwDd0UW6PHy1cmxhtrrhJQrNYgl02353ruY4CcsBoCmfcYT/j/PD3d/0+lw3voTxPC7E2GjA7S9RL3grSuHkd3dXCYEIXNQvQ5gyt8DvatNRYz15Vw4xpWBwsQUWg6/TD2GqXwHs0PEPxhn64ZI/2B1rGDR1GWI2aa2fbJJm7PT3qe5vpmLYC7RHBjxfeW8OeV1jGmgsBkHMLRK5qqfau+GFAUZB9CINpyN/2xiLG27YbL75lATY6aDNDtmbdqrv/THp95/gjL/WHOZRT8JEfylesuQNioeKKnipSfvcM7NMqbrGo85BFQ1ni6AuKWsPFaFiGhH4BNY+GLwDwBMPNGhPndNrwcYZfueICNkAFZVfdlqhb0GeRf1yF/Tndp740u8YJSjndKffRTHPCQUMTKLeYIJfST2dIIhUl2uS7c1q8m9iOceYQ3bU9ufaA1etokM0z6kGb1HVeWjjTspjhVK9yhMUXk8XkQu0IKnjqE57FTdnog/bwHZJ4ylNY/WdcgTPGkLxuuc8ukweMWNyqk55PL37kkjW+XzvZPPhV5b9H3Tzv85/07TpkXvxNPYkBNifRvrxyc+973BnmYBOxNB0sqGPBjJwFyOBHIUw/iwaxRP/W13XyVPHhTMMKn2J2SA74Zu1Xxr86AOx8oIj8P99uTjTzJnpIMwbPxE3BlU+Ppq4Lf7Xnp/rHzUdVH1oZiHGjppWP5TMdHicuO+c9wsnKZP7fBYDbWTz2mSWwU6BaUYAKeNB9ve4GFm/PWcvhWz0uY08R0Tq77jUau9nEoTd11I0v1dag6iHm/R9OVZUtu4Jv3bNRC5b7y6sKyTQwK3uLN+K28d0qV4NGJ6IgKHrjHm20OM5RR49d/7NvEdxuckg/Xl/425JbkcsD6ZtMvdww0+p1MC9eL8KwX4GBADZwJr7knWPMa8DYxcIyoM9M8BtBC8mrfxz+/ydE
 n7KlOD/W
 QQ07aKBtcL1bT5yCstWUn/XirNQrejMdQPIJlD8Ogg6KcgCSJX9JAaiHdy/tEUXTCBbvJZIDBBjq8cI+SCEmmHG4JjHGsIACav/fltIUQgdjTa0nx3u58IhYZPrS4uX3i9ZYs/iNKYcjDWx+km43/+s7ggQ7jGixOySzQBFCMZs1/TeiHNSIkywAXOKt8yKO8ny3Pc51kwz8YyBrXQvmmMp+HzFsM312PFctuy78RADBWTQXVv7RgaKL7W/SthZfJntcP289EySUqiMYSo4kDtJU1tlVCD4lv56CBlghCkZqRc9AGs7yDj5nAGul3aCFe7WGD8gXp0UGfla12DJRnbldLGGiwCpyYokST489MUIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 16:04:40 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
> properties:
> 
> * Is this managed by core mm, or by a driver mapping MMIO, kernel-allocated
>   pages, or even ordinary pages itself?
> * Can it be expanded or merged?
> * Is this a 'weird' case like mlock where migration might race and we
>   'have' to set invalid flags to notify?
> * Is it another 'weird' case where we just want to stop GUP from touching
>   it?
> 
> Driver writers have often been confused about this, and who can blame them?
> 
> It also interacts badly with the eternal edgecase known as hugetlb - which
> sets VMA_DONTEXPAND_BIT but doesn't also want to be treated like a
> 'special' flag.
> 
> Another issue is that we cannot make sensible assumptions about flag
> use. It's not possible to assume VMA_IO_BIT means iommu because drivers
> abuse it and mlock abuses it.
> 
> Special is also an overloaded term in mm. VDSO and VVAR mappings are also
> called 'special' but they're special in a... special way.
> 
> Sometimes things are called special that are a subset of
> VMA_SPECIAL_FLAGS (VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT for instance when it
> comes to zapping or vm_normal_folio()).
> 
> There's a specific kind of special for THP too, which considers
> PFN map, mixed map 'special' but DAX not.
> 
> It's all rather a mess.
> 
> This series brings some order to things by both limiting what drivers can
> do with VMA flags and switching to using predicates that describe
> behaviour, not arbitrary flags.

Thanks, I've updated mm-unstable to this version.

> v6:
> * Applied tags (thanks David!)
> * Added 7/39 to split out the vm_insert_page() / vm_insert_pages()
>   mmap lock assertions and VMA API changes out into their own patch,
>   as per David.
> * Updated 8/39 (was 7/38) to collapse the discontig single page case to
>   a single one and to rename things, as per David.
> * Updated 9/39 (was 8/38) to update the discontig docs to reflect the
>   change.
> * Updated 23/39 (was 22/38) to put expression on single line, as per David.
> * Updated 25/39 (was 24/38) to mention the open-coding in the commit
>   message (fixed in next commit), as per discussion with David.
> * Updated 26/39 (was 25/38) to clarify the commit message around the
>   removal of the VMA_IO_BIT check in vma_flags_is_mm_managed(), as per
>   David.
> * Updated 30/39 (was 30/38) to no longer exclude droppable mappings from
>   vma_flags_is_mm_backed(), as it doesn't quite fit into the broader
>   definition, as per David.
> * Updated 30/39 (was 30/38) to express vma_flags_can_merge() in terms of
>   vma_flags_is_mm_backed() (with an explicit hugetlb exclusion), and to
>   no longer use vma_can_merge() in __thp_vma_allowable_orders().
> * Updated 31/39 (was 29/38) to use vma_is_mm_backed() (with hugetlb
>   exclusion) rather than vma_can_merge(), as guard regions have nothing to
>   do with mergeability.
> * Updated 32/39 (was 31/38) to retain an explicit droppable check in
>   vma_can_userfault(), as per David.
> * Updated 33/39 (was 32/38) to use vma_is_mm_backed() with an explicit
>   hugetlb exclusion, rather than vma_can_merge() which makes no sense here.
> * Updated 34/39 (was 33/38) to retain explicit droppable checks in
>   vma_supports_mlock() and ksm_compatible(), as per David.
> * Updated 34/39 (was 33/38) to use vma_is_mm_backed() in should_skip_vma(),
>   based on discussion with David.
> * Updated 35/39 (was 34/38) to use vma_is_mm_backed() in
>   lru_gen_look_around(), as per David.
> * Updated 36/39 (was 35/38) to use vma_is_mm_backed() with an explicit
>   hugetlb exclusion in migrate_vma_setup(), as per David.

Here's how v6 altered mm.git.


 Documentation/filesystems/mmap_prepare.rst |    2 
 include/linux/mm.h                         |  120 +++++++++----------
 include/linux/mm_types.h                   |    6 
 mm/huge_memory.c                           |    7 -
 mm/internal.h                              |    3 
 mm/ksm.c                                   |    3 
 mm/madvise.c                               |   11 +
 mm/memory.c                                |   16 +-
 mm/migrate_device.c                        |    4 
 mm/userfaultfd.c                           |    3 
 mm/vma.c                                   |    4 
 mm/vmscan.c                                |    7 -
 tools/testing/vma/include/dup.h            |   44 +++++-
 13 files changed, 128 insertions(+), 102 deletions(-)

--- a/Documentation/filesystems/mmap_prepare.rst~b
+++ a/Documentation/filesystems/mmap_prepare.rst
@@ -240,7 +240,7 @@ In the ``get`` hook, the user must choos
   compound pages (if the compound page is bigger than the remaining pages in the
   VMA, then only those pages that fit will be mapped). For a compound page, the
   head page must be passed.
-* ``discontig_kernel_map_page_range()`` - Map an array of pages of a specified
+* ``discontig_kernel_map_pages()`` - Map an array of pages of a specified
   size. As with a compound page, if more pages are specified than remain in
   the VMA then only those that fit will be mapped.
 
--- a/include/linux/mm.h~b
+++ a/include/linux/mm.h
@@ -1695,57 +1695,22 @@ static inline bool vma_is_fixed_mapping(
 }
 
 /**
- * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
- * merged with another?
- * @flags: The VMA flags to test.
- * Returns: true if the flags permit merging, false otherwise.
- */
-static inline bool vma_flags_can_merge(const vma_flags_t *flags)
-{
-	/*
-	 * VMA merging assumes that a VMA's flags and fields completely describe
-	 * its state.
-	 *
-	 * However, mappings which are not mm-managed may have established state
-	 * upon mapping not embodied in any attribute of the VMA.
-	 *
-	 * Additionally, private (CoW) PFN maps encode the source PFN of the
-	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
-	 */
-	if (!vma_flags_is_mm_managed(flags))
-		return false;
-	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_is_fixed_mapping(flags))
-		return false;
-
-	return true;
-}
-
-/**
- * vma_can_merge() - Do @vma's flags permit it to be merged with another VMA?
- * @vma: The VMA to test.
- * Returns: true if the flags permit merging, otherwise false.
- */
-static inline bool vma_can_merge(const struct vm_area_struct *vma)
-{
-	return vma_flags_can_merge(&vma->flags);
-}
-
-/**
  * vma_flags_is_mm_backed() - Do the specified VMA flags imply the mapping is
  * backed by core mm?
  * @flags: The VMA flags to test.
  *
  * An mm-backed mapping is one managed by core mm (see
- * vma_flags_is_mm_managed()) for which two further things are true:
+ * vma_flags_is_mm_managed()) whose contents are established by core mm's own
+ * fault path rather than a custom ->fault handler.
  *
- * 1. Everything mapped was placed there by core mm's fault path (no custom
- *    ->fault).
- * 2. What is mapped stays there until it is zapped or unmapped by the user.
- *
- * These mappings are the only ones which can be sensibly locked, merged, dumped
- * or be subject to uffd faulting, as all of these assume core mm and core mm
- * alone manages these, and that the mappings will remain there.
+ * Mappings not managed by core mm are populated by their owner, and fixed
+ * mappings may be mm-managed but have their contents established by a custom
+ * ->fault handler, so neither are mm-backed. hugetlb mappings are fixed, but
+ * core mm owns them entirely, so they are.
+ *
+ * These are the only mappings which can sensibly be merged, locked, dumped or
+ * be subject to uffd faulting, as all of these assume core mm and core mm
+ * alone manages their contents.
  *
  * Returns: true if the flags imply an mm-backed mapping, otherwise false.
  */
@@ -1761,11 +1726,7 @@ static inline bool vma_flags_is_mm_backe
 	 * by a custom ->fault handler, so core mm cannot assume ordinary fault
 	 * semantics over them.
 	 */
-	if (!vma_flags_is_mm_managed(flags) ||
-	    vma_flags_is_fixed_mapping(flags))
-		return false;
-	/* Core mm may discard droppable memory at any time. */
-	return !vma_flags_test_single_mask(flags, VMA_DROPPABLE);
+	return vma_flags_is_mm_managed(flags) && !vma_flags_is_fixed_mapping(flags);
 }
 
 /**
@@ -1782,6 +1743,43 @@ static inline bool vma_is_mm_backed(cons
 }
 
 /**
+ * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
+ * merged with another?
+ * @flags: The VMA flags to test.
+ * Returns: true if the flags permit merging, false otherwise.
+ */
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state, which is only the case for mm-backed mappings.
+	 *
+	 * Mappings which are not mm-managed may have established state upon
+	 * mapping not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (!vma_flags_is_mm_backed(flags))
+		return false;
+	/*
+	 * hugetlb mappings contain per-VMA state, so their flags and fields do
+	 * not completely describe them.
+	 */
+	return !vma_flags_is_hugetlb(flags);
+}
+
+/**
+ * vma_can_merge() - Do @vma's flags permit it to be merged with another VMA?
+ * @vma: The VMA to test.
+ * Returns: true if the flags permit merging, otherwise false.
+ */
+static inline bool vma_can_merge(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_merge(&vma->flags);
+}
+
+/**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
  *
@@ -4824,28 +4822,26 @@ discontig_kernel_map_abort(struct discon
 
 static inline void
 discontig_kernel_map_page(struct discontig_kernel_page_state *state,
-			  struct page *page)
+		struct page *page)
 {
 	struct folio *folio = page_folio(page);
+	unsigned long nr_pages = 1;
 
 	if (folio_test_large(folio)) {
 		VM_WARN_ON_ONCE(page != folio_page(folio, 0));
-		state->action = DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE;
-		state->__folio = folio;
-		state->__nr_pages = min(state->nr_pages_remain,
-					folio_nr_pages(folio));
-	} else {
-		state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE;
-		state->__page = page;
-		state->__nr_pages = 1;
+		nr_pages = folio_nr_pages(folio);
 	}
+
+	state->action = DISCONTIG_KERNEL_PAGE_MAP_CONTIG_PAGES;
+	state->__page = page;
+	state->__nr_pages = min(nr_pages, state->nr_pages_remain);
 }
 
 static inline void
-discontig_kernel_map_page_range(struct discontig_kernel_page_state *state,
-				struct page **page_arr, unsigned long nr_pages)
+discontig_kernel_map_pages(struct discontig_kernel_page_state *state,
+		struct page **page_arr, unsigned long nr_pages)
 {
-	state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE;
+	state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGES;
 	state->__page_arr = page_arr;
 	state->__nr_pages = min(nr_pages, state->nr_pages_remain);
 }
--- a/include/linux/mm_types.h~b
+++ a/include/linux/mm_types.h
@@ -825,9 +825,8 @@ enum mmap_action_type {
 
 enum discontig_kernel_page_action {
 	DISCONTIG_KERNEL_PAGE_ABORT,
-	DISCONTIG_KERNEL_PAGE_MAP_PAGE,
-	DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE,
-	DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE,
+	DISCONTIG_KERNEL_PAGE_MAP_PAGES,	/* Array of individual pages. */
+	DISCONTIG_KERNEL_PAGE_MAP_CONTIG_PAGES,	/* 1..N contiguous pages. */
 };
 
 struct discontig_kernel_page_state {
@@ -847,7 +846,6 @@ struct discontig_kernel_page_state {
 	enum discontig_kernel_page_action action;
 	union {
 		struct page *__page;
-		struct folio *__folio;
 		struct page **__page_arr;
 	};
 	unsigned long __nr_pages;
--- a/mm/huge_memory.c~b
+++ a/mm/huge_memory.c
@@ -207,11 +207,10 @@ unsigned long __thp_vma_allowable_orders
 	 * khugepaged moves data from VMAs once collapsed, after they have been
 	 * faulted in, relying on refaulting for file-backed memory.
 	 *
-	 * Mappings not managed by core mm cannot be reliably reconstructed from
-	 * page faults, and fixed mappings (including hugetlb) may well be
-	 * mm-managed - precisely the mappings which cannot be merged.
+	 * Only mm-backed mappings can be reliably reconstructed from page
+	 * faults, and hugetlb mappings cannot be collapsed.
 	 */
-	if (!in_pf && !smaps && !vma_can_merge(vma))
+	if (!in_pf && !smaps && (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma)))
 		return 0;
 
 	/*
--- a/mm/internal.h~b
+++ a/mm/internal.h
@@ -1114,6 +1114,9 @@ static inline bool vma_supports_mlock(co
 {
 	if (!vma_is_mm_backed(vma))
 		return false;
+	/* Core mm may discard droppable memory at any time. */
+	if (vma_test_single_mask(vma, VMA_DROPPABLE))
+		return false;
 	if (vma_is_dax(vma) || vma_is_hugetlb(vma))
 		return false;
 	return vma != get_gate_vma(current->mm);
--- a/mm/ksm.c~b
+++ a/mm/ksm.c
@@ -749,6 +749,9 @@ static bool ksm_compatible(const struct
 		return false;
 	if (!vma_flags_is_mm_backed(&vma_flags))
 		return false;
+	/* Core mm may discard droppable memory at any time. */
+	if (vma_flags_test_single_mask(&vma_flags, VMA_DROPPABLE))
+		return false;
 	if (file_is_dax(file))
 		return false;
 #ifdef VM_SAO
--- a/mm/madvise.c~b
+++ a/mm/madvise.c
@@ -1069,10 +1069,10 @@ static bool is_valid_guard_vma(const str
 		return false;
 	/*
 	 * Guard regions require a VMA whose page tables are managed solely by
-	 * the core, which is also what merging requires, so disallow any flags
-	 * that would prevent a merge.
+	 * core mm, so the VMA must be mm-backed (excluding hugetlb, in which
+	 * guard markers cannot be installed).
 	 */
-	if (!vma_can_merge(vma))
+	if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma))
 		return false;
 
 	return true;
@@ -1402,7 +1402,7 @@ static int madvise_vma_behavior(struct m
 		new_flags |= VM_DONTCOPY;
 		break;
 	case MADV_DOFORK:
-		if (!vma_can_merge(vma))
+		if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTCOPY;
 		break;
@@ -1424,6 +1424,9 @@ static int madvise_vma_behavior(struct m
 		/* Only mm-backed memory can be meaningfully dumped. */
 		if (!vma_is_mm_backed(vma))
 			return -EINVAL;
+		/* Core mm may discard droppable memory at any time. */
+		if (new_flags & VM_DROPPABLE)
+			return -EINVAL;
 		new_flags &= ~VM_DONTDUMP;
 		break;
 	case MADV_MERGEABLE:
--- a/mm/memory.c~b
+++ a/mm/memory.c
@@ -2674,26 +2674,24 @@ int map_discontig_kernel_pages_prepare(s
 }
 
 static int apply_discontig_action(struct vm_area_struct *vma,
-				  struct discontig_kernel_page_state *state)
+		struct discontig_kernel_page_state *state)
 {
 	unsigned long nr_pages = state->__nr_pages;
 	unsigned long addr = state->addr;
 	unsigned long i;
 
-	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE)
-		return insert_page(vma, addr, state->__page,
-				   vma->vm_page_prot, /*mkwrite=*/false);
-	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE)
+	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGES)
 		return insert_pages(vma, addr, state->__page_arr,
-				    &nr_pages, vma->vm_page_prot);
+				&nr_pages, vma->vm_page_prot);
 
-	/* Compound folio - have to iterate through each page. */
+	VM_WARN_ON_ONCE(state->action != DISCONTIG_KERNEL_PAGE_MAP_CONTIG_PAGES);
+	/* Contiguous pages - have to iterate through each one. */
 	for (i = 0; i < nr_pages; i++, addr += PAGE_SIZE) {
-		struct page *page = folio_page(state->__folio, i);
+		struct page *page = state->__page + i;
 		int err;
 
 		err = insert_page(vma, addr, page, vma->vm_page_prot,
-				  /*mkwrite=*/false);
+				/*mkwrite=*/false);
 		if (err)
 			return err;
 	}
--- a/mm/migrate_device.c~b
+++ a/mm/migrate_device.c
@@ -746,8 +746,8 @@ int migrate_vma_setup(struct migrate_vma
 	args->end &= PAGE_MASK;
 	if (!vma)
 		return -EINVAL;
-	if (!vma_is_mm_managed(vma) || vma_is_fixed_mapping(vma) ||
-	    vma_is_dax(vma))
+	/* The migrate_vma page walk has no hugetlb support. */
+	if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma) || vma_is_dax(vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;
--- a/mm/userfaultfd.c~b
+++ a/mm/userfaultfd.c
@@ -2156,6 +2156,9 @@ static bool vma_can_userfault(struct vm_
 	/* Only mm-backed memory can have its faults handled by userspace. */
 	if (!vma_is_mm_backed(vma))
 		return false;
+	/* Core mm may discard droppable memory at any time. */
+	if (vma_test_single_mask(vma, VMA_DROPPABLE))
+		return false;
 	/* The shadow stack should not be written to by userspace. */
 	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
 		return false;
--- a/mm/vma.c~b
+++ a/mm/vma.c
@@ -2654,9 +2654,7 @@ static int __mmap_new_file_vma(struct mm
 	 * VMA_LOCKED_BIT and/or VMA_LOCKONFAULT_BIT flags.
 	 */
 	if (vma_supports_mlock(vma)) {
-		const vma_flags_t mask =
-			vma_flags_and_mask(&map->vma_flags,
-					   VMA_LOCKED_MASK);
+		const vma_flags_t mask = vma_flags_and_mask(&map->vma_flags, VMA_LOCKED_MASK);
 
 		vma_set_flags_mask(vma, mask);
 	}
--- a/mm/vmscan.c~b
+++ a/mm/vmscan.c
@@ -3521,8 +3521,7 @@ static int should_skip_vma(unsigned long
 	if (!vma_has_recency(vma))
 		return true;
 
-	if (vma_test(vma, VMA_LOCKED_BIT) || !vma_is_mm_managed(vma) ||
-	    vma_is_fixed_mapping(vma))
+	if (vma_test(vma, VMA_LOCKED_BIT) || !vma_is_mm_backed(vma))
 		return true;
 
 	if (vma == get_gate_vma(vma->vm_mm))
@@ -4462,8 +4461,8 @@ bool lru_gen_look_around(struct page_vma
 	if (spin_is_contended(pvmw->ptl))
 		return true;
 
-	/* exclude fixed and non-mm-managed VMAs containing anon pages from COW */
-	if (!vma_is_mm_managed(vma) || vma_is_fixed_mapping(vma))
+	/* exclude non-mm-backed VMAs containing anon pages from COW */
+	if (!vma_is_mm_backed(vma))
 		return true;
 
 	/* avoid taking the LRU lock under the PTL when possible */
--- a/tools/testing/vma/include/dup.h~b
+++ a/tools/testing/vma/include/dup.h
@@ -1681,23 +1681,49 @@ static inline bool vma_is_fixed_mapping(
 	return vma_flags_is_fixed_mapping(&vma->flags);
 }
 
+static inline bool vma_flags_is_hugetlb(const vma_flags_t *flags)
+{
+	return IS_ENABLED(CONFIG_HUGETLB_PAGE) &&
+	       vma_flags_test(flags, VMA_HUGETLB_BIT);
+}
+
+static inline bool vma_flags_is_mm_backed(const vma_flags_t *flags)
+{
+	/* hugetlb is a fixed mapping, but core mm owns it entirely. */
+	if (vma_flags_is_hugetlb(flags))
+		return true;
+	/*
+	 * Mappings not managed by core mm are populated by their owner.
+	 *
+	 * Fixed mappings may be mm-managed, but their contents are established
+	 * by a custom ->fault handler, so core mm cannot assume ordinary fault
+	 * semantics over them.
+	 */
+	return vma_flags_is_mm_managed(flags) && !vma_flags_is_fixed_mapping(flags);
+}
+
+static inline bool vma_is_mm_backed(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_mm_backed(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
 	/*
 	 * VMA merging assumes that a VMA's flags and fields completely describe
-	 * its state.
+	 * its state, which is only the case for mm-backed mappings.
 	 *
-	 * However, mappings which are not mm-managed may have established state
-	 * upon mapping not embodied in any attribute of the VMA.
+	 * Mappings which are not mm-managed may have established state upon
+	 * mapping not embodied in any attribute of the VMA.
 	 *
 	 * Additionally, private (CoW) PFN maps encode the source PFN of the
 	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
 	 */
-	if (!vma_flags_is_mm_managed(flags))
+	if (!vma_flags_is_mm_backed(flags))
 		return false;
-	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_is_fixed_mapping(flags))
-		return false;
-
-	return true;
+	/*
+	 * hugetlb mappings contain per-VMA state, so their flags and fields do
+	 * not completely describe them.
+	 */
+	return !vma_flags_is_hugetlb(flags);
 }
_


