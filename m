Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F8B0CC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9E66B00D2; Tue, 13 Oct 2026 11:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65AC36B00D4; Tue, 13 Oct 2026 11:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB5A6B00D3; Tue, 13 Oct 2026 11:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 264306B00AB
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:19:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18DC9120CED
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:19:52 +0000 (UTC)
X-FDA: 85317963024.15.800BCED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4958080007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:19:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mnR9GGkP;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGsBHP0M3dhNSNjZ8IyLwxEUTTLsUEI8U0YmZVga3eU=;
	b=QHenPGSdxrMwCYNHP9J0TvaOx0eHUYabEprk1NurCrwz3qBivcIDlZ3fmnfciu1/PlMye+
	t2md+RGvTNRDJoFrY0tLDELp6MujXvTxfy2EkmtM8xcb6QFcsKpljc0YGpb1Zfu2VvHDd+
	tjxBN977P/OKVBnmDUMMSw1ykDKTyGg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904790;
	b=1Dlk7jM4jvc83YLODNz1LRvq8GxczFT44P+eQMFIdtVR4oiRaGfOQJ/g6eaPVJhnQjvjLD
	L7bCdGSuyKbqQyD7suZKNmAi7dW06nJidNQtcmECuuB+NXmpUgLiezbnC0u07dnUop7A6X
	AUyR0hgm2YiAv6D2plOu1DchP1RSc50=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mnR9GGkP;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 820BC43A10;
	Tue, 13 Oct 2026 15:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773B81F00899;
	Tue, 13 Oct 2026 15:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904789;
	bh=PGsBHP0M3dhNSNjZ8IyLwxEUTTLsUEI8U0YmZVga3eU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mnR9GGkPzl1l01E4TFmf3VOAC4weG5a7IZALgwa4swAlutZ0+6qL854KxsyAmbTAO
	 co71clZ6S+0juvyA6UgaRso/HwPIpIJb6u0CVybGofCQlBb49mjxkOBNrQTal1EbDB
	 MdaKB5NdJogXJYsCPF605IYNj0Gd6A4fkJW4CFnF4XC6TPqvNMfqE5tcinu6Ivgl6A
	 2yWfne7Gy9x6hfDVFdMwwO80y8yryn2F5gEOHwxDu+TSOnZsQcixdsyYZuLJRX+dp0
	 1Wb9+ItLsPJu8AuWU4EZ0UmRaSHScZ4VJ6zBO1O59MWi1erOk6VdFWiqLVo9URQwEe
	 tuOqnF+IPsOCw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:06 +0100
Subject: [PATCH v6 26/39] mm: remove VMA_IO_BIT check in
 vma[_flags]_is_mm_managed()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-26-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
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
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=7076; i=ljs@kernel.org;
 h=from:subject:message-id; bh=+FdGKRK/eGuIEVAkxlmlyX+6HKRyDMstVhSwFk3rgp4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZze9qvjQqXtnE6bgJL+qMplxw9tk1oj1XlZf8b/S
 fX7jl7+3VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJGB9lZHhfWLO/Q31r6afM
 9pDUyYsLV8zRUgnltrsvw2fZa35tjgUjQ5/E9YMHOW5f+333lqmVYZbEDd6MySXZ680v+fLuyp3
 /jh0A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4958080007
X-Stat-Signature: ukanc7u69r5u7wkuaito6hegidi5q8ki
X-HE-Tag: 1791904790-999241
X-HE-Meta: U2FsdGVkX1/WsNq8/jjq5ZoRZoRnT+jeC6mBtP+1xJIikZVfYNiCi1acYqnDX930eVup0Z190qQj3/4wNnLeRF8T+8cRYCa9GbtUbty93mIkzwWwaXuKpCQqDJ11J9pRldUdC+xvaHSDqHghtVDuJznbP6y22kyTTdkkNsRujqYRp3ZDzkkk8rU39fBTjeJmh6Jsc9WP0fWoyaM2Udzgss1HmG9+cL3Z7lWY7WuwxW/hspvsWFi7bzM1J+3m+UfuQt/Op9qZuA/WvqY0CDaocDCM+9UzH9g2s9nnYbz1gqUKD1WFXhEzoLOiXN8rNAubAqV0Z/Gk/ZN+ZKmnkE0xS0GW5Xs0GUfxRzFjVxSubDAe3TU5neaqyO9ayOCHn5ZhC6xcvGo400bL0qWrgYm2aCHbeUTzATMGSRo8rU82uCDkQ9io67HG6HQZ4TKRwCr6nOY5LMKg/PcEeqjC+H7mYSRpkqc0jzkcA8RpKfOBfEf2zCg0WlsTPqlAGFToBLquDi7p9LF2M1K0OssHLF7sLJ1C9VF9w7xRpXYMdJdqo4yXJOSvQsaWwCu6YyA75oXQ02C/xWvLdcNo60gV3kp+gVMBH0AXt9E4yeGcZgji6D/1LHuKeEJ/GKDq/umDzY7L8gEe5qKsAlIORNikR+bQmyinDURAqT2Jo+RhK4l72nefTU6778TFuB1cHaTauEV+/3klawu9/cJ9iwNxFrv5NuA8w72dkdtfz8L+V6z6hNwu+R97inKl2ffdqQYzjbtn8D49VblWD3oT7WnFLTypAQrZALgL55DlsNu4hzwtD+kXubDZKcmakksxpg5XZ0+rm8FaK0zbH0AeEkduX3aC7RtNInqAI7WXTp/sqMFQi/gOYD/eSdQjMvXnmyTrx8R4YFgvWKMoahd3f4SGgNSkpz20sRSG7oMgLpd8y4PSrXMm0YoX4Mhqj63epyA2+xdVH4DvXdUyXE2q+zcfLUo
 7RJ0eepe
 qu9HQIy16jaq+mBuo5WEl96cRjwbO1IIjyweNiPjPUlrRBBTJ1hGnjWAwoD/Ri0jGe4Rr6KIa3SGsSa07UU3VB49uEAv/3+cifnglscPTO0pmCrcvXf4OVqkhgoV/37UiWv9l4HQ1tC/tbGZjWRXVzhvY1PvK/jwIHPWjezJ9WQ9TR9JPVrjOgaxkNI4pDBOLkPmTSBNAkW4gaGLm6/vxUuz/7kgWmO9CkGHll1r7sf+CyuYgOxTMKTG1210VTi30jrfxpZ6Q+qPle6D4pE5VHLOaCaBqMLJ2Vda+dfyNsIO6n8XK8IgY4UwkmMKfS/jOCNY1PPzQtcEPt3PPB7Vh/eDJGJLTSeSdLLYz43s5Z5WZlgo9r240oRJy2W7lAfebCjkwuZvAapLLcsney/Mijx4bQUFknRdZDkxro7j9/z5aiJNAn03a5b81huZJwUEwMobh6h0yv5J8ruM8ktMm90VeGRsX2fyer06LUW+tpbEn+sCu7KkzmYw0UWs5j0RZddE4KAVOD84ETLpQkeYorzo0mkb+k5K6MK4BogVLR78KC/XtnBY+o4wdRvKhGupFnVojymsWTRrYp+yY7zdJowG/Cosa7fs2m6C8GdVXxIWhitjuG3xCcUbY7R7uAjkYGy2t2zLSy84XrHYCkwvaWh1QYgBwiELM06neUlda3yXTZxAyCuNRG8Xta57ytD0vW1wJ6+VDuvNxZlu7ZIwjLuI2WRjmwXQZpDX7hKKBNeeGBihX2LPu9k/f8L2kD9ZiSYwysVxF2YwZVuzFQUD2qTEivWFphY5innCrhBvIwn7scAXvhLNAgke9cbaNllJ787zCd1tU4aGuWS4pQ4Pb+io5JIAlQIDg+AqWFa+YPmpNJVviRIkbZWtK+4Plld0vrPmbwGLUQ5t0RlzP7i+SHk8YwV76Y/DqUO9/VkeGZd2Bo+Sj9xfTvuVEbZhOmgIRVCX42YYqyJvI9Xubf7oGYd5fDGKO
 Y1PtHZjf
 kY4NK2URiqYmKf0QEnHxRELXmgYe1pwJTA5sMKPSsIFWe02gVlnG0faERltn2X5ncPiP0x1hfTcYnA97iXRA8jUeL0v2awBG/TUPeQa2mxM+BUgZCjAhsw6VYAgpy4hKBlCBj4b+/i/uq9JBhdDW4ef50ZhVu8ZKmF5nkXRIKPRBO5mQ+qFYYY62TYuObjYtzN0nCVgpP3Wk8jdNegmwpeAlkQIaiUs3gcFCF1ysdj8Upco04ve//wdccVAcij+7jsuhZMPufeqVeEAp1uRdP4bGd9ifSqbCMI4GUI07ilQoJqNCdAj1xfGyKmgCgC2uEUavS8nzJnASb/nfaBGueuqwqCShWbKgzCBc8UzUP8gniD/AnJbd8izJMBfqQQY8OkBZWK4/rkxzpj94HAxJy/+GWTdk+1QRNCewOVVibXG+MKVwL6covzpGKvnf5A1Sw8Gf8qPcD+bUE3AJzMhNIrYl4KJCR6BN3l6QK4Ph4opSfVe44jD+Tvhe1jQ13BOo70n4kTtxFW6o5PNGDKZJHBLZmJ5odgYPnPUaqf0v7gfUpjtojlI5tSDv8WB3NI2dJgbw4uNIVOG5OJDGcBBuz5alDTaJRHOiKyYLIAlQ+bhJq7mYxAM6gLEmRH7zL4SfBeyOu/Gccz7ka1Q4WwKOz1lp0Bq0J8kVuu44WGEFPk0OVr50czhqM81uXpd4EFTL6xPSKyXqtlRGlBC+QSukCKhz56HdPBBRq0z7BO4fxfDfgWRcspJYlmYf6+Xv7W79L+mZtmRsfec3AxwhoZkoMQfynO5KfWig/ttgNF7WioAQr3fqn1VlJDKf27u91K1LxAAkc795sIkr4qg30lkTJ3bROOZa5g0Lu67zkhd2W+e+5nHWw1I0cDCz+hV46erL5m4F9phPIAYPJjfLWAichhKApSeDJA5qz2RQllyLRirCXu3vyBY0gHMR/18Mka6uOrJpfU2zkRcyTB6uSEx9AHEoiu6YO
 va2TqZEf
 mw4Wgh+93qfMHgvn8y4y5Q9fJw/riINbFJyJl+Vqyc/2B9KstHJZ3Z9g1FK0HRPIg9RcRAmFc+naUiUHX3H239HLRQRXWXb1odf81WRyIb9dnnBkowFYkw4Sk75JCIqhSyPupSPR0ISOfBjPsbSG6PkGbvTnarQGu/nXC7ybBCvG4OTYyPmSyWbY05bm66SUgk4srxpaBkSzrOqOxBKj0nc1CpDhBmKMFAeJalagthRH90EO+nYcNkKcrzLVtctfUTJbQe2gjF804rcYFzIL+b3ZEYRS3wLg1APbOQTfP2kGsnyOndxhSrSzeWUQSEofZlSDe6QvzAQzk6sjVWeW6iiuEkw6XptJ09xXJ3TVyiL5SRW7Fql7u2ZSCxdpWOcClDGnmaiylRJ4brRWHozduxrUDY/2EsIkeH3PWN2hLNkyZuB6fCMIE76BtpgcnaRzsepIvF+53NT9yAkiWB4a0FpWxX5Eq0r9+QuHnl7v3P6lsvhxA9gXjkO14mHEcHh4PVbBlbE5PzcqjlQjntvkiohQ0ADU3SNfnu3qm+wcTmNPIWOEZLtaVad9D9QietW7Qr9F4MJrvJ/AgZ3+ZUqLIJKaUdjWI4swftLrUrJXfoADlAx3LpnhCvpMyIeODYUWPag8Znrzk2PovXmPpskM7DIrcE0WHnST6058aeJbxP+iVhT4h7v6PvcdjiMsc0DgHW8Ad6+aQXzaTeQxAcW811GqRI+kJKgJr/gWBrsGEQYt4khe7zyhO8ATQQEIDpJWCptbahi1cKIMgg3YvnPr+2iOCQNszJthAPITamOai0Wbm/sArHd3oY+IdcxIWRqRESNFvx7qAlHFk5F+MIMA7iraOpIZu+BNaPHbhhAN0ym+yxXCETA3kmHZ3NpJSs2uC9k7qdvMtGHYlduWbg+oQn73nLv+HE0PfOI3Pvz/OzMoJBnvLz0bGJspBL1BrOgHtAZCAbOjyv0QVkFhh3L9P5unzBK3E
 nswILisf
 8QzeXzitVRwDm7u6Y2wFG/9ZpLOErYInVgSSBGPKM6PGxZic3UxnbxRbUv81vsKCtcwhO+DRWGdLyBAmYSNfcNXf4XK49WXKr8qe4qHV78AINiqEZApgdU3sJb8DDpn2eFSDO1Qv7W3Nff6g5wBlxooY8kEfO7DrJMKzzUdD7yYrQKTHw1ka/ZJSP8LHjOML2F7Fu4n9vEpC60uwiIJuvEb/vGjtSPKtsfhBgoGSVwczDVf4UmMs2Fub1J3HoSFFGnmsd2UfstVHC/VYdtTeBE31zqbfmiIxv+j/pRPJrqjjcI3Cp7pV+4548++XjlxOlLG5YzLYKsHwASVuzKUInO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have now made it such that every driver which sets VMA_IO_BIT marks it
as not mm-managed.

However, vma_flags_is_mm_managed() still checks for VMA_IO_BIT and, if
set, treats the mapping as not mm-managed. This was previously required to
handle drivers which set VMA_IO_BIT but none of the other flags which
identify a mapping as not mm-managed.

We have now established that a driver which sets VMA_IO_BIT must also set
one of those flags, so the VMA_IO_BIT check is redundant.

So remove the VMA_IO_BIT check in vma_flags_is_mm_managed() and update
mmap_validate_vma_flags() to use vma_flags_is_mm_managed() rather than
open-coding the VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT check.

This change means that vma[_flags]_can_merge() doesn't check VMA_IO_BIT any
longer (which is now redundant) as it calls vma_flags_is_mm_managed().

Now that the predicate means precisely VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT,
also use it at the other sites which open-code that pair, so the intent is
stated rather than the flags, with no functional change:

zap_special_vma_range() only zaps mappings which are not mm-managed, as
drivers use it to tear down ranges they established themselves.

The mprotect() arch PFN modification check applies to mappings not managed
by core mm, which may map PFNs without struct pages.

NUMA balancing skips VM_MIXEDMAP mappings having already excluded VM_IO
and VM_PFNMAP mappings via vma_migratable(), so it skips exactly the
mappings not managed by core mm - say so.

Finally, update the VMA userland merge 'special' flag tests to no longer
assert that VMA_IO_BIT prevents merge as VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT
now suffices.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  3 +--
 kernel/sched/fair.c             |  2 +-
 mm/memory.c                     |  7 ++++---
 mm/mprotect.c                   |  3 +--
 mm/vma.c                        |  2 +-
 tools/testing/vma/include/dup.h |  3 +--
 tools/testing/vma/tests/merge.c | 10 ++--------
 7 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2ecf39bc857b..1006d8567e06 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1627,8 +1627,7 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
  */
 static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
-				   VMA_IO_BIT);
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
 /**
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8dff37059faf..a07a658cd99f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4212,7 +4212,7 @@ static void task_numa_work(struct callback_head *work)
 
 	for (; vma; vma = vma_next(&vmi)) {
 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
-			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
+			is_vm_hugetlb_page(vma) || !vma_is_mm_managed(vma)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
 			continue;
 		}
diff --git a/mm/memory.c b/mm/memory.c
index 1a6bb0aef8cf..142a8ef13f6a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2343,19 +2343,20 @@ void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
 }
 
 /**
- * zap_special_vma_range - zap all page table entries in a special vma range
+ * zap_special_vma_range - zap all page table entries in a VMA which is not
+ * mm-managed
  * @vma: the vma covering the range to zap
  * @address: starting address of the range to zap
  * @size: number of bytes to zap
  *
  * This function does nothing when the provided address range is not fully
- * contained in @vma, or when the @vma is not VM_PFNMAP or VM_MIXEDMAP.
+ * contained in @vma, or when @vma is mm-managed.
  */
 void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
 	if (!range_in_vma(vma, address, address + size) ||
-	   !(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
+	   vma_is_mm_managed(vma))
 		return;
 
 	zap_vma_range(vma, address, size);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d87..706c679d4281 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -783,8 +783,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	 * uncommon case, so doesn't need to be very optimized.
 	 */
 	if (arch_has_pfn_modify_check() &&
-	    vma_flags_test_any(&old_vma_flags, VMA_PFNMAP_BIT,
-			       VMA_MIXEDMAP_BIT) &&
+	    !vma_flags_is_mm_managed(&old_vma_flags) &&
 	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
diff --git a/mm/vma.c b/mm/vma.c
index affe464a7c92..5df02665d1ed 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2794,7 +2794,7 @@ static int mmap_validate_vma_flags(const vma_flags_t *flags)
 		return -EINVAL;
 #endif
 
-	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
+	if (vma_flags_is_mm_managed(flags)) {
 		/* mm-managed mappings may not set VMA_IO_BIT. */
 		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
 			return -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 442ea9eb098d..94bf818ad0e1 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1667,8 +1667,7 @@ static inline bool file_is_dev_zero(const struct file *file)
 
 static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
-				   VMA_IO_BIT);
+	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
 static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index acaab282939c..b26f1a66a170 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -496,17 +496,11 @@ static bool test_vma_merge_special_flags(void)
 		.mm = &mm,
 		.vmi = &vmi,
 	};
-	vma_flag_t special_flags[] = { VMA_IO_BIT, VMA_DONTEXPAND_BIT,
+	vma_flag_t special_flags[] = { VMA_DONTEXPAND_BIT,
 		VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT };
-	vma_flags_t all_special_flags = EMPTY_VMA_FLAGS;
 	int i;
 	struct vm_area_struct *vma_left, *vma;
 
-	/* Make sure there aren't new VM_SPECIAL flags. */
-	for (i = 0; i < ARRAY_SIZE(special_flags); i++)
-		vma_flags_set(&all_special_flags, special_flags[i]);
-	ASSERT_FLAGS_SAME_MASK(&all_special_flags, VMA_SPECIAL_FLAGS);
-
 	/*
 	 * 01234
 	 * AAA
@@ -520,7 +514,7 @@ static bool test_vma_merge_special_flags(void)
 	 * 01234
 	 * AAA*
 	 *
-	 * This should merge if not for the VM_SPECIAL flag.
+	 * This should merge if not for the 'special' flag.
 	 */
 	vmg_set_range(&vmg, 0x3000, 0x4000, 3, vma_flags);
 	for (i = 0; i < ARRAY_SIZE(special_flags); i++) {

-- 
2.55.0


