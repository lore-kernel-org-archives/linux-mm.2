Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18D54C982D8
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 21:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD406B008A; Thu, 17 Sep 2026 17:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAEB56B008C; Thu, 17 Sep 2026 17:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9C1C6B0092; Thu, 17 Sep 2026 17:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7EB6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:23:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8ADB4804CE
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:23:37 +0000 (UTC)
X-FDA: 85224530874.20.AF69ACE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id BCCAB80003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:23:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VUF866Xg;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789680215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUNrBmtamoGTZdnjr2/yL2y2w6DcpJMvTMICnOHXcqc=;
	b=lt6QrMVeFT4fRvKLmKe1ZTgd8MF5PwP12qIVjwRIgGhUdbewP9gke6dCQGpRw+O+KS3nMO
	0RYugiyTKdSScJpJjvEGwzBugkKy++lKCi3N0pV+toCRNHXnYhxVNsbsR9H4KrpSBFjkNu
	FcLk1HXWtMHfXjWLl/6/aUE5fEMSoWE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VUF866Xg;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789680215;
	b=pLw7TpUMoY0tfsHGvSSYHyMTEm/1ExvZnmO+8vHs7GYAPN42ZglDOQVDgOqS5F3clDZGb+
	H9cVRr4yytfKVUTaND7pB4Z4it7llyWTvgg8LXl+vtP37ruAE3agLlUumfHmkQZG1cqOsW
	eWzoT2MqcpFtLL1EOP2VJMN3B6/5Gjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68D49601EF;
	Thu, 17 Sep 2026 21:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5062D1F000FF;
	Thu, 17 Sep 2026 21:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789680214;
	bh=NUNrBmtamoGTZdnjr2/yL2y2w6DcpJMvTMICnOHXcqc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VUF866Xg25rkEYuIAeRh8+Jby3Nsgi0QqQgf+tcoe0C7lFWZo2kW07wobdbQTXONa
	 IrDTi0vtFdOje+nXofZ7qVIuq8UFrLKFeRBPgY0JvevdHLKjcg92+cAb0Z4/yQgheh
	 XekOEPMPEkzPT/6xM5Mwlpf+y3YNL1+GloA5Mf1w=
Date: Thu, 17 Sep 2026 14:23:29 -0700
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
 <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, Simona Vetter
 <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel
 <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov
 <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Rik van Riel
 <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
 <airlied@gmail.com>, Will Deacon <will@kernel.org>, "Aneesh Kumar K.V"
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
 fuse-devel@lists.linux.dev, Takashi Iwai <tiwai@suse.de>, Emil Tsalapatis
 <emil@etsalapatis.com>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit,
 eliminate VM_SPECIAL
Message-Id: <20260917142329.369cd6539261d590600ce7ec@linux-foundation.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BCCAB80003
X-Stat-Signature: n7achckfh6bub8q9wmhynckoqopus8yo
X-Rspam-User: 
X-HE-Tag: 1789680215-642259
X-HE-Meta: U2FsdGVkX182Nyxa5/UtOAgpGpt04PyPevQ8DPNiUlnQHTXUDgl9VMFHQbi4rKdlDQAUUavY2rJe8+dRNuZqIltHEc2HwSNdb3q46nlHF2YV6G8KX5rYpCAaR1lqVI1LPYxirwkt31/3uH6U80plUWZrD2ZlJYLmbED1gxigPUSqA+SWB+viJ9CufpUEhFkyPVUJW0NupTz+gHXXQ9Sht1UGaqFyvZcMl7r4112FOgqA4rYLasGknUnNGhjB1k3ueFkV9RpodIcFc5STY+vVkBg/gTqZiMGTUBp9/W4urGG/V0r5EPgpJ44YKjpa+EoB+HfQX3sHQQ3xaONuRPXLM3zHt6GRXSrsYFu1PPiAzRxyDCksDYRdvFfUGR4cxb2bdbzSlglTEJIGzEWeO0pM0n9Jrrca+tvJAoJ2IyCv0rR4FBXLOIJJPUgxB8CxNckvD+SX3uT7rOLkAsBbm0KEL6AMHN7ajwQKj+XVvoiwrgmusw08Y/VmSCk0cUIFVUvIP2iIcVvpZ8spLIGI9h0NFN2Wz8FAAutpIyG/ZUwuQXnvSuqcZzjNWccBJhZoWiXHcLhIDG+AAst8XbmkvXm1Fi+CM5EtjLGtIK50VuC0RqdedIxdKHVNEKj0UbLOrXaA9QjVlxXZpPAz2m8FnESzsK3SKbXSXmBpo4ZHlYWf6UZioZhZUHaSEo/oi/qV7yQl967l7LPfqSGZNhaH/+yhTtWJNHMTz7+diisCkl2rCUJcSCxoKVUYinLEwQFDbRGY/WxXeCmgOoDXU3zE3fkBfXNizsnd3uGA8IWNBG7jThKfGZZCDUlOHqNsFZvoAbfEjOgSOtsKcT8ThYLLrPomauB337ZMdlxjrtk/gvhHUFeANe92NkE72VfS0/oLeNVJ0uLz63bIcOkqinBN5LUaVLUDyCOuT5MCSKD/xa+7X4ogx+JLCcuR3rbkSO23lguU4j0x0q+oHoJxSOX2caS
 vKfutgPW
 olpCWZVQCh/JiXE8XS4sInxZEvdZSiCNsts3Kif8puVPHdbL4WOSyAidwj/c5EgrQP/3czS3lr8RKx0UJOxnTAzIjOkp4Hy9W0wU5b38hJOA7525hBPDr4foqF97Cu6h5hWJ6RURJtkGIvMwNP8NZ+SXqQMgqf6GRbWuOAEfG7dCu/NG2f+SPaz0QFdPxCoCfUd1mLTHH3f/ogZAjLeYVe+L5eE+rwwwZx4B/o6pSb5v5AjC3cfjLHq9vlaipQW0m7aJyqrff/pNIp+VZcnsqisYKkN6x1Ltl2DTge9XvCazCxW3foU/WOjq0G6rh4dWuUgV/115HdZZ0/q84JG9I2hr3pf8265+LMCt61Y90ssOneU6lZBsHY93k7vKZ4yajPCWZM+Wh6FmhbBweqIpK+yGl26V1Rk1wItIx09eveLhvavSMeVGdhJSgbX0VB8Syj/ZZLmhVvKHrQICcW9BVvBk0HiLx7CywZNckkpPqyLNTg9WWHkhQzY5LPOubHaa5arpOS4n5qFLdmzptGo8X4J0RHazO/GucR0G711JgNYnYuIaDvlH+88CVvbWFZoo1WM/frCaT9TQ19PuVrzmkIaKDEpc3+DOZN2gTtJdaN4VkomTEZY5aHALxWspAh3PeNNl9n18avvZIf6/HuQqe7c/7x96hLm0F2KLXTQnA7uq3ROLy0HLPT8cTtH6sTpkWEDn5w9JpRYqOaiC7kgSPRlaiwG//Kb5YKDvjpRtmoQqsNd2GGGYgcNeJ7SZKZFLRT2rOYADcAeN2mmYwFpepunaPRINKkLMmwAkvDZ/3oM3EhFDTrPv2hZ0WT7OYtH0yHWZIey6tsX5w4WSyW2fBoEQ1Ot9HCXf/uIpG7k+FUoanyU4jO8xmdsxfn8Rz/10AHwt/KrE3Ipxus8S+0vxZ/xReA6E5ujsURf5xKxAoFzOg8Zav4VvYiEnV9IYaiW+3lLcaKpC6/fySAHkJNjyetYrQ0r4P
 7vGWMI8p
 uNRrez/0YUtyGTPDAyOU3K6dYaW7ptTk0m4M6WajsoynowSkmlYpimsNL7+Wa55vinWc+s/GhBET14ADvdx8veStzgFC85RMe60uXrft7i3CWe1BmloNeUzIfryiCoJdWp36lNsYvPjEAvVcvFgyrXP77GjkB06ba7QL3l4x8F326hYJfzLL2Ii5q05n8fpS+ULgGIjdxDcTp9E9DAwgiClLfaVRu5tHISn8boEOzMOeeURl5k/0plrJ5CKS4c/Bg1Gg/zGZ+g4IzwxA0hzRLQ3+G7yoALGZPs69pjudHIupw1oI/awms7LAuSez3yH3nUlVlE4FzY4Dwf6q8FTXPzodN0p3VNUD4z8+rWlyiFKwXJdkOlRVO8BjuJzp1UAKALz1buL2HtbN0rZBw/UMOlleH0v0lbYP25JJ60RRedFet6BjFHyGuaSiJHeB5yJqtAwFSHKa2YQWnfNDTuV70iRnZM5DzWxlmquL0autqiiIdepBa42R1yIk6jQLcsaJjPVLWwls3rcZWfLgCmD5Ap/olnWK3DGdx53znogFvflPqYRYiQpF1Mj/9OLnyzAS419+FPFsy/UpjsqQHJA0E3hyxq7Ro+gnWXrwht6BfQoVWNgvCfpMogXQxA8v6T05UJJTWV7o66DhM6FrQsI6hBUHxdR5k3zRXKByPWSRBYCOqG3pVk2Vr0OzcStSclennt2BeDTvc19zEnprZhTvBx2fMI7Wa6fGh6VX3WR8rKypxGUFIfy8VAoW+mBamJnif3dElJW4vafhMRjqqqSZsueuTPS1XPGZNISPxVx+t/Eo8sGTOKe7aPw96OgU778BF/+p4euaRouni/r1iO1rkjghPtCYp/LAOtALdiSmTR/9hPwLK2NW46RVxTO54jXjrNOCtAEqJetJVynQnnN6Uew04qCpNC8uv28JYd/EhdmJ/cIpxJLWbhfnqsHepx2ZL1dswBIkwx9IR4LRWC8EwhG1ZcgFZ
 v7dHn8h8
 eJtvEpV/MIhP5s8VyoFreoi8tnGOk4CuTIwN7ZZPT1xpzjMrBdyXtUuX64uMXLpo50Q1DLIRC5xkWfZ8jyY0nZlIrvixuah7FadgQuizk5NW61BwEWN6AxNaJRp8cszdzRL/FqVRET6bkHDoU2+ai6G4cCzef5GXkVCzwB5m73x7Lm0uXaRU7Rohj6AeeChDkbXecJ+xyKZKc3PMczVGygj01lkwMKmtDYLmX+/ysA0Zsdra2FF2/Yv/Ou/52yNpQhzUeiKN+k042hS9+7L6TO+pl0jKy+MKXwArrcJWJ0/DIENY65nckVKmoot5BRztuFdLa44CMnDc4uie/O9edSYjfx6qYAaVI6vpEnLoPPtu+VICn7n0rjUyEpNNvCl4iXe7FBTxy+NVQPiR0b/RV6DQG3OX4X+QrqPiI/XRv1PuMAhT9yiVejubx982+b9bEh5rK7hLOQTAL8Qch3HX107fW8zp0lXfAYKm6BpI1pPRiSEtMs5irPjIjSxFL8xFwWomsHFP71Q+PYEdIp0MI9OsLeuHJ57kROmDji3JLOa9RIPnPkhm6qzwO/If+XK3HjkbfNfhdatEMuOyaqjRYeYPKOrUDZZkkES5soAYzE8CMoDXk74KrhT4qDbUoCTQvIDPVjvCLuJUZzC+DLfDnG+EwLLSZjrYIkPDFBy1c/G7cVm0KFLLXnkyQNMnKu8SqaBeyFhUQgrC6vk1ITwTkxXJhqBOzsMd6CZqRGaPdWW+CoYx2Pwm5XCitbUekOCY2jldcMAnC1pfVEOpli77/O9tYO3tw8ftODGRtDNM+tiJxsusw+xT/w7tl0s2+ytNecMyAehg+2mlIq7qp1++jQ8VqpB5vIpWcvLnT1GEVP7mai80pWyP7GdvTvCiB28esMw4ZKKP5hwVvGX9SxIq0gaHFza5QeIc3yj4fVabuAIuC9hfGj0c23p53Bu1rMLS+gqyhD82Gi2mdfowFeV62IDcqBNWX
 iB2zGatN
 g4yztOc6xPevKridOXXNyTijswUO9s4c3/oLbZutztz9T9aLfxAZcZLDqQsHq8v1ar/Xl8h9TAXYFa4eB9JYOO21RAP3DttJwquZnNPPZ2NlQvmswkwLqCcYgu7ifC274K7MDdPgrVqNNujpCdrghs1ldTTfe9T0DD4isLxDQ1ZS1SFrDWO3P2m92ptnZaqfRzqybuK9MYR5JRzpsrD4BIgYbz/dl9oH4FNzrRTTAfXozzdRsBIY9kuhRcA2Rin6v21FFkfaaJ7eocj9NSaUGdO2o8O2i7WtAc73P0QjiSO1lB/IEHtTb74bOnTquBwZ/pSqdagsiWQGI8k9VJl0fjPNEg0aut2i8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 17:22:09 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
> properties:
> 
> * Is this kernel-owned, whether MMIO, kernel-allocated pages, or ordinary
>   pages a driver maps itself?
> * Can it be expanded or merged?
> * Is this a 'weird' case like mlock where migration might race and we
>   'have' to set invalid flags to notify?
> * Is it another 'weird' case where we just want to stop GUP from touching
>   it?
> 
> ...
> 
> This series brings some order to things by both limiting what drivers can
> do with VMA flags and switching to using predicates that describe
> behaviour, not arbitrary flags.

Thanks, I've updated mm.git's mm-unstable branch to this version.

> v3:
> * Fixed up bug in patch 1 as reported by Mike - have to delay setting
>   map->vma_flags until after action prepare, though map->vm_file needs to
>   be set before for correct reference count management.
> * Updated 4/40 to add a symmetric vm_end check as well as vm_start in case
>   of a dangerously insane driver, as per Sashiko.
> * Updated 8/40 to check if a driver did something REALLY stupid like having
>   a NULL discontig_kernel_page_ops ptr, as per Sashiko.
> * Updated 15/40 to trivially synchronise userland test comments.
> * Updated 17/40 to correctly duplicate code to the userland VMA tests as
>   per Sashiko.

Here's how v3 altered mm.git:


 mm/internal.h                   |    4 ++-
 mm/memory.c                     |    2 -
 mm/vma.c                        |   34 +++++++++++++++++-------------
 mm/vma.h                        |    3 +-
 tools/testing/vma/include/dup.h |   24 ++++++++++++++++-----
 5 files changed, 45 insertions(+), 22 deletions(-)

--- a/mm/internal.h~b
+++ a/mm/internal.h
@@ -244,6 +244,7 @@ static inline void vma_close(struct vm_a
 static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
 	const unsigned long prev_start = vma->vm_start;
+	const unsigned long prev_end = vma->vm_end;
 	const vma_flags_t prev_flags = vma->flags;
 	int err;
 
@@ -263,9 +264,10 @@ static inline int mmap_file(struct file
 	if (unlikely(err))
 		return err;
 
-	err = mmap_hook_validate(prev_start, &prev_flags, vma);
+	err = mmap_hook_validate(prev_start, prev_end, &prev_flags, vma);
 	if (unlikely(err)) {
 		vma->vm_start = prev_start;
+		vma->vm_end = prev_end;
 		vma_close(vma);
 	}
 
--- a/mm/memory.c~b
+++ a/mm/memory.c
@@ -2653,7 +2653,7 @@ int map_discontig_kernel_pages_prepare(s
 		action->map_kernel_discontig.ops;
 
 	/* At minimum need to be able to get pages. */
-	if (WARN_ON_ONCE(!ops->get))
+	if (WARN_ON_ONCE(!ops || !ops->get))
 		return -EINVAL;
 
 	__map_kernel_pages_prepare(desc);
--- a/mm/vma.c~b
+++ a/mm/vma.c
@@ -2797,15 +2797,15 @@ static int mmap_validate_vma_flags(const
 }
 
 /* Check to ensure a driver hasn't done something crazy. */
-static int mmap_validate(unsigned long prev_start,
-			 unsigned long curr_start,
+static int mmap_validate(unsigned long prev_start, unsigned long prev_end,
+			 unsigned long curr_start, unsigned long curr_end,
 			 const vma_flags_t *prev_flags,
 			 const vma_flags_t *curr_flags)
 {
 	bool was_maywrite, is_maywrite;
 
-	/* Drivers cannot alter the address of the VMA. */
-	if (WARN_ON_ONCE(prev_start != curr_start))
+	/* Drivers cannot alter the range of the VMA. */
+	if (WARN_ON_ONCE(prev_start != curr_start || prev_end != curr_end))
 		return -EINVAL;
 
 	was_maywrite = vma_flags_test(prev_flags, VMA_MAYWRITE_BIT);
@@ -2843,7 +2843,8 @@ int mmap_prepare_validate(const struct v
 	    WARN_ON_ONCE(desc->action.type != MMAP_NOTHING))
 		return -EINVAL;
 
-	return mmap_validate(prev_desc->start, desc->start,
+	return mmap_validate(prev_desc->start, prev_desc->end,
+			     desc->start, desc->end,
 			     &prev_desc->vma_flags, &desc->vma_flags);
 }
 
@@ -2851,19 +2852,22 @@ int mmap_prepare_validate(const struct v
  * mmap_hook_validate() - Ensure the driver hasn't violated invariants in
  * its f_op->mmap hook.
  * @prev_start: The start of the mapping prior to the mmap hook.
+ * @prev_end: The end of the mapping prior to the mmap hook.
  * @prev_flags: The VMA flags set for the VMA prior to the mmap hook.
  * @vma: The VMA after the hook has been applied.
  *
  * Returns: 0 on success, otherwise an error.
  */
-int mmap_hook_validate(unsigned long prev_start,
+int mmap_hook_validate(unsigned long prev_start, unsigned long prev_end,
 		       const vma_flags_t *prev_flags,
 		       const struct vm_area_struct *vma)
 {
 	const unsigned long start = vma->vm_start;
+	const unsigned long end = vma->vm_end;
 	const vma_flags_t *flags = &vma->flags;
 
-	return mmap_validate(prev_start, start, prev_flags, flags);
+	return mmap_validate(prev_start, prev_end, start, end, prev_flags,
+			     flags);
 }
 
 static int call_action_prepare(struct mmap_state *map,
@@ -2900,15 +2904,9 @@ static int call_mmap_prepare(struct mmap
 	if (err)
 		return err;
 
-	/* Update fields permitted to be changed. */
-	map->pgoff = desc->pgoff;
+	/* Update first so file refcount tracked correctly. */
 	if (desc->vm_file != map->vm_file)
 		map->vm_file = desc->vm_file;
-	map->vma_flags = desc->vma_flags;
-	map->page_prot = desc->page_prot;
-	/* User-defined fields. */
-	map->vm_ops = desc->vm_ops;
-	map->vm_private_data = desc->private_data;
 
 	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
 	if (!desc->vm_ops)
@@ -2923,6 +2921,14 @@ static int call_mmap_prepare(struct mmap
 	if (err)
 		return err;
 
+	/* Update fields permitted to be changed. */
+	map->pgoff = desc->pgoff;
+	map->vma_flags = desc->vma_flags;
+	map->page_prot = desc->page_prot;
+	/* User-defined fields. */
+	map->vm_ops = desc->vm_ops;
+	map->vm_private_data = desc->private_data;
+
 	/*
 	 * MAP_PRIVATE-/dev/zero mappings are an ancient way of getting
 	 * anonymous mappings. Rather than allowing these mappings to be odd
--- a/mm/vma.h~b
+++ a/mm/vma.h
@@ -786,7 +786,7 @@ void vm_area_free(struct vm_area_struct
 int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
 			  const struct vm_area_desc *desc);
 
-int mmap_hook_validate(unsigned long prev_start,
+int mmap_hook_validate(unsigned long prev_start, unsigned long prev_end,
 		       const vma_flags_t *prev_flags,
 		       const struct vm_area_struct *vma);
 
@@ -851,6 +851,7 @@ static inline int mmap_prepare_validate(
 }
 
 static inline int mmap_hook_validate(unsigned long prev_start,
+				     unsigned long prev_end,
 				     const vma_flags_t *prev_flags,
 				     const struct vm_area_struct *vma)
 {
--- a/tools/testing/vma/include/dup.h~b
+++ a/tools/testing/vma/include/dup.h
@@ -1667,22 +1667,36 @@ static inline bool vma_is_kernel_owned(c
 	return vma_flags_is_kernel_owned(&vma->flags);
 }
 
+static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
+{
+	/*
+	 * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some callers set
+	 * only the former.
+	 */
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT);
+}
+
+static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_fixed_mapping(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
 	/*
-	 * VMA merging assumes that the properties of a VMA completely describe
-	 * the properties of that VMA.
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
 	 *
 	 * However, kernel-owned mappings may have established state upon mapping
 	 * not embodied in any attribute of the VMA.
 	 *
-	 * Additionally, PFN maps encode the source PFN of the range in
-	 * vma->vm_pgoff, which may otherwise cause spurious merges.
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
 	 */
 	if (vma_flags_is_kernel_owned(flags))
 		return false;
 	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+	if (vma_flags_is_fixed_mapping(flags))
 		return false;
 
 	return true;
_


