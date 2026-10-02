Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 929A8CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9EB6B008C; Fri,  2 Oct 2026 10:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96FA36B0092; Fri,  2 Oct 2026 10:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85ABC6B0093; Fri,  2 Oct 2026 10:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4456B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:56:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE09B16071C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:56:36 +0000 (UTC)
X-FDA: 85277987592.02.7CDE6F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2E3671C0010
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:56:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fdVzgh8v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790952995;
	b=608at/nmuQDRC7Ez/GAV/iqvjkeq2BRHq+dlZHGZD6PT/eVOVFLcKd1iC8BssE4XYmpWfZ
	ad/MUyiWwRxDmvLLvTuzcUFi1u5HZnbad8Bm72ZKgUe+uZPt/PICt7JiiRCp1OJ5BQnp4e
	9WPWWtpxYFWQ18kRuQ5NL7ZQpH4NtYc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fdVzgh8v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790952995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQuiTsuvfiP4TjKhygdb17Hd1K9/CkYZDyLUI1EBmwE=;
	b=jNAQZnDitAyQNRCc7fmNSJ9zJ74uTSvXNjbYx8zbPJzNT96FpMO8Ht6d42EPAQCwNh2KdB
	nS1bwu9JHLoVrak/KrUSpGQA1Crz12A5Gx7hpNW031iuqYzKqwiN8GZEGHCY5QvDmGKfTM
	WLH04g82pW+ulsZQXw33mZ6mNwIeT6Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D3D943700;
	Fri,  2 Oct 2026 14:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88791F00893;
	Fri,  2 Oct 2026 14:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790952993;
	bh=jQuiTsuvfiP4TjKhygdb17Hd1K9/CkYZDyLUI1EBmwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fdVzgh8vzUmdaKUlZe0VUNAIbLSN/FNhbQHH4wzlHFvv+hwCHSicNk7KjrZHYj3Yu
	 iQlLhsYS9ojqwSku1HQOXWnmdKoCu8CHMkE9A7LZ/DH6hiJQldb++n4ez57oVgBl0V
	 So8/jwrVJl3CEjbngowiXAkkkl3yvYCSfnXRCFedPo61Fs2XbO15rdcGoISGxqRB8K
	 jXU4TLmv22BTp6yPLlF2Jpru5HvWTRYFQZfFHeldR1afhWGGXDAezdVopQG8Ave8bR
	 CZFLT49VpC5WBX0wYA8iUka0IczATo+lcmXmrk2MeXbxiJX2meYd90/doZTa6tYh/0
	 hugq9t44NIjiw==
Date: Fri, 2 Oct 2026 15:56:04 +0100
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
Subject: Re: [PATCH v3 15/40] mm/vma: add vma[_flags]_is_kernel_owned()
 predicates
Message-ID: <ar_CYfkR5Pfb7J9b@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-15-4583d8a23bca@kernel.org>
 <0623ee06-00e5-421e-a24a-ed605abb559b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0623ee06-00e5-421e-a24a-ed605abb559b@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: bkau7gtk466xozuik6xqb31jwx8n3kbi
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E3671C0010
X-HE-Tag: 1790952995-916982
X-HE-Meta: U2FsdGVkX19Q6I/6wX9Xr5WS6ibw2ZBHjNPwkI/v8vsRV2ryzAAjG6akym4nJcXIxFrHMZXuOuBG4E01nzwyITw40iKMLntU7GmwjPLYXXswT4IsWQQBgU4/DOjnEF0yUj0jL9i2yOeunqn86+qDnsB2o2kysjDvQrsLeP83KloSvhcRQ2Qn75iwn/sWoXRH+6nHTr1PIoX7jGJkluL2rAorGeim4oKmE2+mYlTsePEMX8HQyms+U+8Hmv5eir0MGf/QFQnhrLgzHoB0rYJcBCAtRwCaMqEnXlRzTYkSB6DNRGcrp/Ufy7WWm807vP1GHwSK79mOwg/c9Op4OANlQs0a9uuhLXK6Z4W+d6CjRL0rPzjPtvwj65bKGfbre5G43Q+M6kpiSWjgGYYGtN0FRpGs437DoCVzvq3yWAlPW/OQhHJH6TjwLFkGKpjX2iwcWj6tVkZ/B5fQ4BMl8PtmXI+LlR8jUB8ziZa14R6FHlqXs35iTyJzL9y6eVuJ/Fo3XO18XV5GtZCRP7H5gP5IE+Cr7Ec/+RzLBa0iKghcZMTsNY0Pqo3i4KCa0cbmirFAQBftOmcTk97qWDjrhQn+2RUng/jcfIK3oZA20gvSIkM+EbKItH3B3awhzdhtxA2uI0UINsoKdi/BAn+yR6Td0PkCLM/lrtYXMHd+osisjrCcic8mddwOL0TWWTrWDglr5lJlzcak4OpvW1qkm2Zn50J5UI9AwTKoWFBnE6f7Ti+39M3ROXY4wRTxOh27bjHY0B3lD1+zzfcrBi5ahe0whS424KE3aGqkZxha97+va3mFJMw5Kp24nT04e3CPdLascv7MFaXSqjMh8gnX7vSIZr76iOGl3H0NnRi+sc7KRc0hAtC1eJuo4qHj1fpbI3zUl/MouxQ0kgfxrkopv/aNSzxqonaEp9uTD1bYj15522SmPQeR557C1Y77m1PwNQ6yrfJMnMyxZ8GgYcDywZq
 1lnoWeZF
 4flRcp3m/9TzM9v+1Z8sKFetV5S5NmkFijDGL9WtoXTOyYCK7R6thw1tW7Qdzn3BHvXfPoCH3ZPE/O4LkY6D25YRSq/kETzpdWUlUOJaByMJ+LknsDBEnm1lkI1xBDHO2xkdIuRNS/auxYw2KNNbz4WAazc9lJXAHitwTMemz/kLu5ZIzd8AHku4QNafmPbXNurnO4cmaJRBU9dmOZysLeg/gIcwn7RSoFY/HPtdwZ4PSrCUHmVNF3DTr41+3vWzEGwaM4aGB0St1pXsDnD3JG79x9Al81CR6EHatEtLiH95ouVXmnyrFzEQKk5ibPzrt/2qRgQtJMdzzCSO4ybneRt+aZtOeuBdUjyd6y3P/wXrK7EzbIpQb5913Q+S/M1QXU9U/B2cA1BxRg7ZrJnBBKLUiuiGcZ1WnLe0Ac3MmLPVc9ivEmA05dntHtTWmf3xyaDScfPsJKXNEt1ARhuHRCWAQX4/VEBq8WrYIo/GEC5pLdGHHqp3BvWk1z3jPLRfaoVIAcgG5GKfHBi+ImaNMKDfUG6AxOmILIKjtGaDJ4BMUojAx5I324pQQfuyxPiwWjLXr/MA54eIBQ/jdsQ2F5t9ebcJ8mjyNdFLXXASlyatI2DN8tiPrdfQi97tWhVGSIAUIzTrhVAEXO1JDzy8g1w+hbd2b/nHFOY9b4AG3yueE7SxYvcIEjvfXnW3HlVObSTe1uhtvtNTHJJ2vrYXuIAm4zmGFbgal3smkz/VaHiGBbokeOeE97mTMSdpEUAHq/Md6IrwEdhtSuThOcc6Nxfh3OM5r1EfcJY1MOFo9WJiB0lMlRvZER2P8Q28t6OYLB4qokBHxl7/6rE8uoNVWFsEgx5TvXhDiqD0rweLr2xXThKvm1VXBXnlb9FRl6Fib6+eS6tUq/2jXmBdEv4+S1IM3GvTitFOtcTbW4ufKaStsnAdtKnjGWYGwWiIrckqtq0Ib2ow/ap5x/Nw78MTcZxdlf3pW
 mqngVaJ/
 xFemuPunK9TXGTfd3UdDfr4433Gx8uhd0vQhxoCFduUUYQEUQorh7inPV4tS4BnOEUEbjlvmGxHpEYcEtx3/3MKrQfYPcWRvkPgyfSsRQWTDiqXxethMzefdC+RHxYYoftIgLN0NKaWeIHYETsRQ2ZKiqA/5V3wvNGs1HUED7pRijjOTCQTeqxaZn2bvahc5valSTYG9LgIwmHQsmQnB6xVRWcJzIFmcT7PrnwryA65tRPRFDrN8/NBLcYn2ieVSjSjtslgEvcCgNgLwe+86ao0sv11IO75pXSyOCDhn+vd1BjT+FYXXeqNojqaNbrcrASUWcmnP7lxLB45gVV21Ge/VtN+j67rveuOD8d5D6JyQpbnjhnVNLTbvkaviYEAjZZMKNuIkUW7SBqBVbRul5fVCRblFNdEHtbDgkz6JOe6myLaec+Q7atQeEwTGUOgeERR51Jh0vZNGRKyelqYgsH4mo+gnk4wBVTUT5vyy3UhvwtcSDhFZMYuJgdCMLrgzmfT68cBfH9pb5H2yeMfcrw2vAk+NDYRmTPKKGxGHPO3DruN4t5Fe7oWLxFSYMPEwxoa9W7jWBEt/JnN4trj3CoUwY3uTL/sbmVxZMTrn8fMi7T/t0aYMLhbb95YWeuCZnedj8FB0VzbaW+LSPW52GRVknBMqVrR2cNkeax7jS8toYCTj8ELdn7yWG63j1GVy4DMFTCz1tTDyYN8GDw9S2D00qRzR5AUL4thQ5WIeKkvXpn5rSne/zpYb27CgjQtQJPzOVRnQoXaDiV8BwnrDi5X9/rac+MlbogdKVZMmHvBmtqrJ/xWVeUoy2KUMVFZEejE0x1KzXCgdRY0poH8Asyf4DwUplop8Dtn62OyCR51bU23j2kZWIIfgjlSMjb3scx0L3vIjUEqqjws6/hYhRUkfSEgZPYN5+0ZhT3V9FjZ6je9+X13txrxZB4tZzPnDm2Zkf1C1OX6pSRJowWKb5TAJSHHps
 rvKJlRpW
 WlFw0Eq5dmW/SKd5rKtPQMh6JR5cvrb59pYGFgY8uibInJ36RuMD12TmKTrcBesnUEKQrD1dRIm9EOfitri1orhBu7ElWum8MoQAWZ+35tffdpiXOjQEgWXd2pg7zTmlMFeHl/YYA1Zy/wRNSClz1m/hIsY+EwNSL1aBL39/v9V9hbKf00HU0t9Wo9IrKFJ29Fa+Y3OcyCMnIkDGN3m0EfbZAlrXZYYYyQIHC0Bq+LXQhJMsSzoktNxej0jk1q+x+Ox7u6MVRTqaoYs2/PfaUApAWGZRXNT9Fi4HYMqC1UxTQxYQBopeDhfQAxjsAaDhDAENe3BMohSUQIZQmATambceVsFXIx4IkD0lO4/Dok41OBsIDZwEkbXo1UBJUFZ1ewGspHeZIC7NnIsxBuyKViojnCpAq5tIIKU2w99qwqB/IOCv6nN9sHazkc5q4SOn4BhGzxZiCPfLtGUdgFUdz/Ar1mj6CJTuFMlgpeFjbRLN7v4pW+GlzpvQsHWaWWF7fB+ZOUP7qnXj2z4Mcb0mmKryVCe4eilo+m8ruxyWaYwCMl5o3o0hfoNHmMXIl+qOeXHlSHel1uv6pI+KfsKqgxsBAznH0uyX2NBsx+2wd+7mTMRKo25WAIzKcNnCPKp9cgHpL+h8T4Hm8PyLT9jnn6m0DKglKeUiwLHRHKNwU5XCkIkSZT0JbsO4zwteuOi099YMNmgIo7hsRVokLq6W/5lj/MfELk9oiKsFPcxfj4MmljgwKOWBJX9qJKRCb2NimZua7yeB1fr5yxtETzB5C0ACD3s/XGjCmB+nSsWW7DGuLphTTKUaO2WVV2p3k+z3ty/LBv8rqMzIgDAXnqAAkWC3pNRzdWmZV/MQ2v66nZp02raQD5KK95JjA3BHpVAA5tMtu7XumzIO6SucIv3PP3n9G3M1gRqus2zafzR4d0+uj+Cvow6lVMjv3cmUixH3+pKsYJyTDddj3B61qLnbh0vQCAUsE
 Ls+teDz6
 mF58wsEB/XCx6+S2GPWKI4KixAUTlO3gWXvrZZhJClv/KRThO4rRqorDAvSxuD7BxXftLAcqN70r239LTZlffrc7iYoF++GmbfJhnvahXdASkzw5TElNQvZoBgBMiRYBcuRJocKit7VJlzZz61lZ1ag2SnhBAjetGZ5uI+w0HZH/AIzkGQHFptRH1J1IcOmsTz0E0jI/YM57r5HxzLyPz4+kR2hVGQvERVJsMDr/5Uz05X/2ZYIw+VwgqRekR7c7MLCbqDlGCCy7JvlMJJfIKmQhu4eSot9g8zqPJwmBupTVQ5QCWPvcXiM5Oi1Vi/8zOxIJgnUXWcqjc1TiL4IBy6Kxc7SwjM+m3y9KSUSWaadq5QzV4vzVxx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 02:36:40PM +0200, David Hildenbrand (Arm) wrote:
> On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> > Rather than referring to VMA flags with uncertain meaning, add a new
> > predicate that explicitly describes what possession of the VMA_PFNMAP_BIT
> > or VMA_MIXEDMAP_BIT flags mean, and then refer to that function for
> > determining VMA mergeability.
> >
> > Either flag means the contents of the mapping are owned by the kernel,
> > usually a driver, rather than by the core mm: the memory may be MMIO,
> > kernel-allocated pages or even ordinary pages the driver maps itself, but
> > the core must not populate, reclaim, migrate, copy-on-write or merge the
> > range on its own initiative.
> >
> > We initially also include VMA_IO_BIT here, as by implication, these must be
> > kernel-owned. (mlock() also sets VMA_IO_BIT transiently on ordinary VMAs
> > while locking them, which is addressed later in this series.)
> >
> > However the intent is to in future remove this, as no mapping should be
> > marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.
> >
> > This forms the basis of further work intended to improve how we express VMA
> > properties such as this.
> >
> > Also update the VMA userland tests to reflect the change.
> >
> > No functional change intended.
>
> Of course I have to bitch about the naming :)

Yup :)

>
> Intuitively: kernel owned vs ... user owned?
>
> No, it's kernel owned vs core-mm owned.

I would say somebody who does:

	ptr = malloc(4096);

Would think of that memory as 'owned' by them in the sense that they
control the lifetime, they established its attributes, etc.

So indeed, vs. user-owned.

>
> Which implies core-mm is not part of the kernel?
>
> Yes, this is confusing. ;)

I think what you're missing here is what _creates_ or _establishes_ the mapping.

Intuitively, if I do:

	ptr = kmalloc(GFP_KERNEL);

I, whether I am in the core kernel, or a driver, or whatever own it in any
meaningful sense of the word.

I think the issue here is you're confusing this with other things like the
rmap and refcounting, etc.


>
> I assume you're coming from "map_kernel_pages*", but that's rather "kernel
> memory" and not "kernel owned".
>
> Usually we say "driver owned" when not talking about pagecache/anon. Or user vs.
> kernel memory.

I think it would only add confusion:

VDSO/VVAR, perf ring buffers, shmem mapped via PFN map, uprobes, etc. are
all in this category and I doubt people would consider those driver-owned.

>
> So is it really all about "is this (excluding CoW) no ordinary user memory that
> we would track through the rmap" ?

VMA_MIXEDMAP_BIT mappings can be refcounted and rmapped so that's not a
correct description.

The distinction is - who put them there and who's allowed to change them
and who owns the lifecycle.

>
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  include/linux/mm.h              | 56 ++++++++++++++++++++++++++++++++++++++++-
> >  tools/testing/vma/include/dup.h | 29 ++++++++++++++++++++-
> >  2 files changed, 83 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 2a92193ac6a5..cab29d6e15c1 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1612,6 +1612,44 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
> >  	return is_shared_maywrite(&vma->flags);
> >  }
> >
> > +/**
> > + * vma_flags_is_kernel_owned() - Do the specified VMA flags indicate that the
> > + * contents of the VMA are owned by the kernel rather than the core mm?
> > + * @flags: The VMA flags to test.
> > + *
> > + * A kernel-owned mapping is one whose contents are established and controlled
> > + * by the kernel, typically a driver, rather than by the core mm's fault and
> > + * rmap machinery.
> > + *
> > + * The mapping may be memory-mapped I/O, kernel-allocated pages or ordinary
> > + * pages the owner has chosen to map itself (shmem via a PFN map, for instance).
> > + *
> > + * In all cases the core mm must not populate, reclaim, migrate, copy-on-write
> > + * or merge it of its own accord.
> > + *
> > + * Pages mapped this way are not necessarily reference counted or map counted.
> > + *
> > + * Returns: true if the flags indicate a kernel-owned mapping.
> > + */
> > +static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
> > +{
> > +	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
> > +				  VMA_IO_BIT);
>
> I thought we have cases where we drivers insert pages and neither set
> VMA_PFNMAP_BIT nor VMA_MIXEDMAP_BIT.

There were 4 - defio, cmt_speech, uprobes and the bpf arena, and I fixed
all of them :)

Other than the DAX-only case below of course.

It's not correct behaviour and part of the point of this series is to
structurally _forbid_ illegal behaviour by drivers.

>
> I assume vmf_insert_page_mkwrite() is fine because it is DAX doing it (should we
> limit this interface to DAX?).

That is a DAX-only thing and DAX is precisely a case that should not be
kernel-owned (and isn't!)

This series actually fixes the FUSE case too, restricting this interface to
DAX only seems like a sensible follow up as well.

I could also add a patch to this series to do that too if you wanted?

--
Cheers, Lorenzo

