Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F02BC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB41F6B009F; Thu, 24 Sep 2026 06:06:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B106B00A0; Thu, 24 Sep 2026 06:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0F56B00A1; Thu, 24 Sep 2026 06:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 840D16B009F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:06:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B2711402CE
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:06:56 +0000 (UTC)
X-FDA: 85248227232.13.6AAF695
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 73908100009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:06:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PLQwBAOG;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tmln/mtpzj8HRD3oGhB2G+T5+fAuKHxHe9EIDa4XupE=;
	b=ueZWrPpvz1MbHwgygSNM1pwiUUKzsim3DokhYYCzDeaIg0PwxWLhSHGzjQOVJIgi841BVx
	V3G99a4ErjjHLAiDSft4OOomX71rxT8qZGslUD6k/cVV2Emq7Tm7nNvHUMeFpoqTBKsjvr
	HYPeWnqRQTWnt+uuYA2X0OFAb6iaAQs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244414;
	b=W2MN22IrBWrxaIgFp6T4lpqpuMqVw8/7Ee0rZvmCyd35i+X+Q5N+ruStFOp7b4mviAvMN0
	FZpy7mpFbr5rkLyfJTcXEhD6NaRTpd7rDA1HwpRzPEvSZNu8/bQ75TLRDs6KxFBgi8Nbh0
	tnT1Dyaf79lPnkSAhZseTZrtjRPSjC0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PLQwBAOG;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCE0D4424A;
	Thu, 24 Sep 2026 10:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C321F00893;
	Thu, 24 Sep 2026 10:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244413;
	bh=Tmln/mtpzj8HRD3oGhB2G+T5+fAuKHxHe9EIDa4XupE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PLQwBAOGo9zDSHvR7HKzryQ/BMyFMtzGN+nCViQmJtAxtR/cVtie3h8+uTfYAAuqI
	 031IL8YiCRbRgN3Lu0GdOWHF3up1c5eAkeUhEPdxuJ9q/SthtjUJM4e5DTQk3971Cv
	 +R/NIvQEe5TAium5bmdEyB/qSUVvrKQ3N2k6WtmzwCU8Hw7KqZ3HuHqonUNceqtFUI
	 gkBAcKeGMzG5vw33mskB8GCIprFrs11XV7eTU1DX4P4aEFuLfxG1bzkZcra4RB+dUr
	 UBz/croW/YGWjUjo9iUnRJL3m1e4m9BS//Qzg5nKK/0JyOftW1GHHLTSp3iQSWnW2G
	 YCgs9xZC0a5iw==
Date: Thu, 24 Sep 2026 11:06:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 04/40] mm: consistently validate VMA state after
 mmap[_prepare] hooks
Message-ID: <arT1xJpWlFlRHUFY@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-4-4583d8a23bca@kernel.org>
 <DLN7FLRJGS5Y.1T8T274W2NS6L@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLN7FLRJGS5Y.1T8T274W2NS6L@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 73908100009
X-Stat-Signature: 9fwbzy6bt9btbm6jz9uugd6gfthr7zhr
X-HE-Tag: 1790244414-828730
X-HE-Meta: U2FsdGVkX1/dhGmk2GA7Z+j/k+ZTVLnJzaLwyJAPCrrabEf9/HEflzd7vI5LywLR2wuQwFVIPyCOh8yj4jaZEuuQoIVCiiepbQfYbByTZolrUJLq47Zt/NyD6Igr14ix6oMW91jPVuq485XdhETdTSvkUFNNqnmNPAHTh2wGjI+upqMnWtF5q8rDBzvJC/NJ/y3qkOObh0RjzP/Xv85C6QHE7IBuXUovM2mmPusQwDb7kuvuH59vVDOmRknh+QqF1QYRYVZ+CQn+tTHAHQsjaRyxFG1r/lXkHtUlA01nYQaiv3tUYwM4Nl5pchPzHKO2vCDypsIAh8APvG15GEr7YqePVS8jgnMixU3xzoaL749wCupgBpQhLhYVBXTjC67fGJbKR/lJd8NSEQERLsUPfoNioZvgjJd70RxOAqdj1voMK5LTvPpCa7rnPcVkJM63HRwPaQCHos4a1UaBsnsTMw3ax7I9/TNJfw/GZ1nWd1XmOFcDVI1mjP32zYPQ+vOVq7/qEn1prIuO//4jNXBmRSmgmhvnhAsrZuxK/eVGSO53IXTL9iN/rmKVyBc0ib0n2PVsakMf84JA30IJj/f0Z2QCAFHsJHbFgMWQMEY05FS4DjWcFi0K/LJT7J3mx6g+uH1aVlUEyziwN1h8QrcRI5H49hh4FQ61c2MFcVyToPuDW8HXojwEjxTKeI8eSSYhKMc3YeNYjCZykxGbffc63wvi13Z5srqm6cyVuxW9+JvIZusW1nnzwGCx83TN/CY57Xk2ofxgIYc0QX7imfDhQs0SkgGYLVeKyxKJtXA6uizsaLbhFhrFh115aBHGRlFNBeVDDCtbfi2z+387f/stGVXtSYdXubwgT3NTsxQaWvrzrhrLzR+kpajc03iDN5va7nULQKIyY4PSE9tqowUeeXWH96ozxqkspiRmB6TdFWDo22+m8v3ew6nOx1CQNzsRCTo3vpWNNAAq2W69NrM
 2rvE0JNi
 RRo8NMInUJx1HTvupWxEbPdh654FrbpDbvJQ0cqGs0j/Cm96FPgd+xKYhr+VvzCxO0MTJem660G1NkCWwXNq89MarbsKnu92ynny71C3Zc+1DGhOaSudnaFhu5ynlK1SWCW37LUEu2sYvWi4nw+EccIcDgLHtbPwWmeiq52pNLQXkCjWqHlSgyokkfBbLrdBMokZoryC4LD6VNY4JPF+FGzxyNJroGhD3rp0BVMrqp0Uqk3F2+Zhpt2rjaq7yAUvhEW9LrJoPiD8A9BKHsRxf1VVUyZULvku3NZ9Y1hhIbYqdyGAMjEyeh4PAoRinZJeCT3H97U+qE7O3/ZYYLhGgrErAu3EpjSBRes597zO/ApVap2yNMA//HjafI9/az9a4xb9RzUlHe5I5RglOym1J6W6eLjIaamGggPaoI6RFSzqQw22VS8PnxYxj/o38It1YK5PURjV3nu7Nocg9XrgjxrO1S08M2E6bjr99UHLLColXgZEXEaBpAgM1EaM72r5L1oeTfJ89kc3qF6It3QG47PDg3TlMwurX9FXDhOPq2atu+pteyKivyHIvEz8wm+gLWfuTsnp1AfLM/q9Ngi2/pZ30miujkajBM8RDTKu+9WI4rAODfpRgonIxu3M6YnWUdtDO2BTJwsXYPUtTFPmyN0VWlOGhzqPIjX5ro33cj3UulRjXM91N22OBBRQP0icMd5TZutfIXV/YARqEUck4jHllNhHy+YFu54TScYOjkoEKYjroMHEKGD/Wv0CB4pQmXpCC+E9U1afP/LJ5wvLQMNoUpl+3nCVp0VhU1EsHGs4EgAAOy7U63/7f/mhraG/OrtPrmvxvjSy/Tu6AOc7RvyH7hTA4e7H9Gcl+q8RGVJDyncFudJoUdU5kgx+pKhhfqwV5CLXitNW3Fimwtt9/cseLctxH0PrqGD+VJUK/E+rbpqOPLi0JLolcuuxLxyyO0E6iCPeHkq+QIxDom7y1L+33TnvM
 Wr0sNUiW
 P0b18HV1hp06jwEHtbeqNpbCSowhkrFu9sa+oNUC6VsC+yudNJ0CaChLCpYywUTAPJ91D19mpQoN6G/Xv+hnUDrlzvQS4J3vpWDQVr+Z2de88fwmNx2jP8bw2T/sDb53stxmycHo0KfMI/ZGVk4D0Zbqvz5J19RgrbI0tgIrbQhAearb8P9bApzKiF/R4mD3mAfwjT9NotwzRymqmdlXGn8fNbOvYHm/1FiaP3xguWy7HCnUhk0wdLciDUp0s8GVbwkihxnf+oSggMJ4KfTg5JR45yrOEzmocju8MY3JKQR8vjtKyanDnC5TS7HGg8zXerNCY9dnBaVu7VIE5QI+JJCQb8p1ITw1lA8p2XbYYbWRnn4HQeFZKA8hoVN91GTdeJ6rw3VED5xLY3elmTB0qzRnhYB70qiQOWcqWBnjrswvycY6wWeB7J6NcgvNM/N59alPeUBkIGlnOh+pk2wTsN/sPhQKXEt9bMR1Q8aG/2DxCFrnxeEmYxAvdE7YjvCrTyk5YvegKahTg/S6rOoqyaodyqRWmByvtnPcZPEAdckNQ3upCaVFLNa6aquVntVANhjNmkC/NN7SmW5KOSa/4zf+sFGDoVyDIZSxC+fapRXVfgHiprADDV2uI25WKkmcf9GINwk1QyF5IHvIg4IxTiotnksZjHCZbxftan9pvLB93glmj4bEb4zWacB86OoFz6m/0vMVDJGnqGh6/I99jUHL5WoCmzJqtczTVlYcBZ1S5zHbgIoWhpyKuGiJzcHmrFRV9he0PMX/1dYUlz4RLBQRoOl2RCacYgV8aIivayzp5Y5fjefQ1UJIgn3569sLFsHHhBQG6cqBfV+qGkZc5qmbDjPfOH7TT+NGM5eehHLhjrG5qzzZ3MIfYY5CQUTrqkLQDPKxDeI0Icx7g+60BDoZUySd88MdA4TLsQqoZG40ZM7mDZpJbVhBZmoNMLtLlXoSFhQOxjsqcskT6gzAXX5F7Wxky
 jIlv7sz7
 VLaXcsbQDxgfNByd+FRhlKHHXSt4qgOtlQ9s2tIWCHb1vw9reePe7ss8FXqhHJjHCmc+YmUg/ruysUSqWb+Jp82pEmUCmEpPi05fCImqE3gk5umMqGdr93spc9ynJle6ZoYTdHPOsghqUVhNyVZaOAPkgD73F+0sj1o3f/APSCMjrPeG0UKP5h6j4wOh9ARn/YWFNmohDjXJyt1stM3bUvBXVwV4eSsQgNFM9HftatzFWXfgt7R58K+wF1lTZoY78Ln+1KmyiPZyhjm0I1E2/WlZaqGHYX3cfhNerhQYjASy3zlFBIiwbENTLqinjyctUQEEErO2O4aQIaIEtkxKPVlvc+Nfr7rhDgL1+iFxz7tjbrAawAEM2YwqnH4bVIrKwGWVXtw9odwC8yOefOrzgIG/VPLMPKRNROvdkdiPGsBRKEKMDqol4lbYj8U+tS4ublYrjCCQLcET4xBPKeCF1axWQngFNEO3kov0xD1q+Id5C5oaO8AfrC0AVrzPqWcRnhtVkbly9HDvs+oioJV0yPia2EsemsqsuED3u2D4nogv34v4Jlxv6MxHvlJRhHOoSXBhYBp460k+CPpFBM9e0s34J25eH5Ic1zwh5FjRGymQ9kg3I/LyvoDa55lrvQgahtusXqJ+gx61Loy+2v8gVE1+1Rowe/jWqyz/uNjZeWf3WDOsf6Zw6dO443jo1FvgITH5XQvg53LLTffHR6a87Q/cMEuajq1RwzKmKwjXszRmCsKnuSpRJxfWB81brwt9zpkxtxF0+FL94gZj57uKI2ztqZA7K6JlHTej6QDhK0Rnp3ABdZ74rZizJNNxW2qlMsYtEHVSokUDdrpe3dEfNa/3esJQ3tsgS2/Pb2cOnDNxb2OhyPPrimv6Qz3ZH1DX1KK1vvIf+2PrWMTSSxgHWVF7vO/+A3ODDW7fvB19gJ2SadxJgLA+cI2JVrHOe5RXIVimGxsLvUmW2YfN+TbFojkorzvJg
 6YSwy3N2
 pMrcbAFxlBuZ0Fz2a3KE8LL+w35lFuk0wPkSEAIo49/N8/LS/T7vMBJlPJaZX15Kh7nKdCPQNOPOAE7ICfLPSaD4WkNqyRuTbBJUBhUnHl6xeH0i9D5sbWUJabiu9Fn2V3yMYvFUch8Gftzn6li5l6rdkTdO1MYELvbi8OuwU0xWz5XW8IIMx+niLbTxAR7FbeDja2r7DKfHl7r9luCbHx20Xu3zvODXn9HYYH9A/aN0TTnUxZmkfWUSFTP9FChSzF7cKSmMBVqhSngFRLFjz5SIgckp22fhPRodUeD+T4KSocWVKeS7ThWBWI8AxFn4gzVuFyABAz+Q8y2giT+sznEgQjKVSmcF+00D1OuJUA962IuIWqQiBE20vXAIN3/zLDif56g0RnrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 10:52:06PM -0400, Zi Yan wrote:
> On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> > When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked, the
> > driver might have done something crazy that is not permitted by the kernel.
> >
> > Currently we check for three such cases in __mmap_new_file_vma(), but only
> > if the legacy f_op->mmap hook is used:
> >
> > * Did sparc ADI result in invalid flags?
> >
> > * Did the driver alter vma->vm_start?
> >
> > * Did the driver make a file-backed mapping on a read-only file writable?
> >
> > Generalise these checks for both mmap_prepare and mmap and apply to all
> > invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handling
> > in the core VMA code and the mmap_prepare compatibility layer.
> >
> > Also extend the vm_start check to vm_end also - drivers must not change the
> > VMA range at all.
> >
> > We also WARN_ON_ONCE() on these conditions as they are things that should
> > simply not occur in the kernel and it's important to call it out when it
> > does.
> >
> > We invoke mmap_prepare_validate() after mmap_action_prepare(), as mmap
> > actions often manipulate state in the descriptor thus providing the final
> > state the VMA will be derived from.
> >
> > Also call mmap_validate_vma_flags() in insert_vm_struct() to ensure that
> > special regions which are inserted (such as a VDSO or VVAR) also satisfy
> > the sanity checks.
> >
> > This way every VMA established through an mmap hook, whether via mmap() or
> > the compatibility layer, or inserted via insert_vm_struct(), has been
> > validated. brk() VMAs never pass through a driver hook and so need no such
> > check.
> >
> > While we're here, also fixup a couple disjoint blocks of #ifdef CONFIG_MMU.
> >
> > Finally, update the VMA userland tests to reflect the change.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/internal.h                   |  51 ++++++++++++--------
> >  mm/util.c                       |  19 ++++++--
> >  mm/vma.c                        | 100 ++++++++++++++++++++++++++++++++++------
> >  mm/vma.h                        |  25 ++++++++--
> >  tools/testing/vma/include/dup.h |  10 ++++
> >  5 files changed, 163 insertions(+), 42 deletions(-)
> >
> <snip>
> > +
> > +/* Check to ensure a driver hasn't done something crazy. */
> > +static int mmap_validate(unsigned long prev_start, unsigned long prev_end,
> > +			 unsigned long curr_start, unsigned long curr_end,
> > +			 const vma_flags_t *prev_flags,
> > +			 const vma_flags_t *curr_flags)
> > +{
> > +	bool was_maywrite, is_maywrite;
> > +
> > +	/* Drivers cannot alter the range of the VMA. */
> > +	if (WARN_ON_ONCE(prev_start != curr_start || prev_end != curr_end))
> > +		return -EINVAL;
> > +
> > +	was_maywrite = vma_flags_test(prev_flags, VMA_MAYWRITE_BIT);
> > +	is_maywrite = vma_flags_test(curr_flags, VMA_MAYWRITE_BIT);
> > +
> > +	/* A driver may not make a previously unwritable mapping writable. */
> > +	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
>
> Is it driver specific or generally applicable to all mmap(_preppare)
> operations? Is the comment too specific?
>
> During my LLM quiz, making memfd write seals writable via a
> hypothetically wrong shmem_mmap_prepare() implementation is an example
> for this WARN_ON_ONCE. It is not driver related. Let me know if I get it
> wrong.

Driver is taken to mean anything with an mmap or mmap_prepare hook, like a
general term for that.

If we start getting into calling it different if it's a file system or memfd or
something then it becomes quite hard to talk about it.

And yeah I hate that it's not a good name because driver makes you think
something in drivers/* or an OOT one or something but the kernel makes it vague
:)

Naming is hard...

>
> Otherwise, LGTM.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
>
> --
> Best Regards,
> Yan, Zi
>

--
Cheers, Lorenzo

