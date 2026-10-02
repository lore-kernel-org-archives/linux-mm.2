Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD656CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 07:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC0736B009D; Fri,  2 Oct 2026 03:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B49CB6B009E; Fri,  2 Oct 2026 03:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED386B009F; Fri,  2 Oct 2026 03:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 606146B009D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:07:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E71D5A74E1
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:07:07 +0000 (UTC)
X-FDA: 85276804494.25.498C3C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1EAAF140008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:07:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hCp+2fkS;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790924826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0hWcnJnpydfH/GKmmOH7T4iJhQmbefzXV8L2WDslX0=;
	b=shZf2Rlax3lStoNfHszMPHCYRidbwJFWgFYRQEt5GmdinsbOjyrCQGcJU7ZaUz2mxgjMYX
	LR8ghfTYUdEUvc3k8I582yAa7aZKRzP6B5BQnFMgh0uz8kDtQ8qPyYyfiGoak+RApNOln3
	m4AV9lATKA+BBsmgCPWXd+bzZ6mQGPw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790924826;
	b=iqA+ds4I2KLVZbtWMQmAueLkuzvGwGSVkB+KeNMt5f89sNOeiZUl6u5bjX6FiUh6XWP9HY
	Yw3a7Z9QXBZpEtYoGPGMLhjMPMHJSoOu+3YaE+Uwg2DOx7w8eRnRtZWHny02yivrL9qSi9
	mAH6YnwbFV+158gVCnsALOlk7pKxbkw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hCp+2fkS;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F5CB43B95;
	Fri,  2 Oct 2026 07:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6261F000FF;
	Fri,  2 Oct 2026 07:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790924825;
	bh=w0hWcnJnpydfH/GKmmOH7T4iJhQmbefzXV8L2WDslX0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hCp+2fkS7OxRcZij2y6mBt2E3fDjEzOc8eHQJhsPx6m3He/HdHGtPW8k/6BALSnES
	 it9LIVVbOqRgF48rSD4m4wkZr4hRQPc326H3ja1QY80lqE6iDoDqoZY08TD6Vm4Yes
	 4JPqjTXiinMSYZN9WiIVnXy9fwCU+AhW+ZvjF+G+XIeE3rg8a8zPNSdbxV/F/NnBVe
	 yHFUXl/91pMJM4tYtl2NVWacIZgiVwfPtWjYJeDkPfVagJjZ/YB8wc2ATnaZvC5PST
	 VLDbqudcowc61gUKiq9yWqil67iFcoNVjQuPuSzPeWpzp8TUN4jjZAsuXZKXY9oCTW
	 54TzUxJRCkj8A==
Message-ID: <f4b5f7ee-4324-4340-a938-752815d9924f@kernel.org>
Date: Fri, 2 Oct 2026 09:06:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 35/40] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
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
 "Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>,
 Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>,
 Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
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
 fuse-devel@lists.linux.dev
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-35-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-35-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1EAAF140008
X-Stat-Signature: tgfse6jiptpexf3sbotxr3cfx64pqshe
X-HE-Tag: 1790924826-298106
X-HE-Meta: U2FsdGVkX19Oz18WGNM1nOci44VCj9hHxRQB6NtjTV+v4qfVlche6s1yGiunDO1Yk0Tx9L8l0LSVo9RmkZWqqAMjpAkB2PKUTBfdZglmiemzdHCWaGA00JLlnB9yfXkaDU9FGoihZJFePe14Uk+KUgDujZj3crCHHQbjLsUV4xOTBeaALWN+Lwe8ky4SuBE3JgxPzjpu1H4pbgJN4cGmjynJ5uZu7lqtKkgxqAPSPRt+ao1wIhIr6YgP5u6uNbt7y69ghbqPoM2FN7AZ14bBUa4XZeZBnWx8unmxhzTgZZ7dAISYd1xVlQdJ6uU8rkWxJQd7atDpFdhIM4IG3/ebxqPadf36eWs5De3YL7sixd7cucvlfsC+uMsk7XRELD3UExKjtwU1LwexcVU1yGEYBmGhIgmg9Lz29xS2T9OsSLL1nI+4dsHNC3JKFNts6O0Aip5utyQgsljprHOTHIF4iNJkIIf3JyTAfHfxqkYnhQD/etMD+yEmGZlnCGgG9fcFTClehyV9/iLAeqwtQ4OigPwUR6BD8foFEMpts8v8h21jWs2pXDPcUuB36/KfoTH99KJD7c3kx5BhyVFHvd69tKhk1uCzseSTQSGEs9aSfVXlJmysTpR4mn402PtRHWVam2UvnwBFak2XlPEfIRmCE1EfEuYGSw34KgORvWznb4rZc+JPZ/AWq7Sis2ot2b5qOBfnzPYtPTLSWRwo6tY9bSc0TfDaZ2PG0OjQBsFbV9IAMZlBQS16EcH3HCLXHRAzpOEVwsJJNKlAY2krHAMwCjlqcH3prXAucYeYcQgea+quTszqwZDHqMC48C9BhU9aylhfUOW/meVGSQ8zoCc05+CK3dNJrCY36L0nt2Nl77+Gk5mMl0+s25wcSztQIHHuKfX+J3/xm/o4xudn6q1J46soTU+ezMo769HwvWUL4q0qToKu/08nRCt76vGQj0/gDY4kxnprXki5p0rm3F9
 DWNmizEF
 3JcNRokGtXAMBUrp6z3+COdx+4p9/AADn7iWN6evKX2VGTNxMUTAZ2YnMV9qWYuNOMWHvbhUGYvfKtclMWqamiFKioSGAfm+wYb+4BuhctqH/0halomY9LVUZdOr1p80itZCIHjXRwdiKCcGJC1tOm5pOLrctQP7d0vc/Cgb6IKzy1+0bCNgQRM2HzHWPKLr+PbAcaVmkvXiquDfdgUUtViS4CLfe1H2gLw6OAKSZimmVH4AJZt/lXYNIjv/myVUI0fuytr5aaetw/ODMZp7AuuvSLsq3rp/lbS1JNpJbzSIiOuZxVa5NB0Zlbhrqb/C2uhPr6ausTO+9rR7r3yo1VpTzRSzRv4HWLJXffVRknrngvMjwmdha/x16XwjeFYCbMKi67BN67PQY9bG64WdGKJjOu3i6bTjHkn6mgUp8m7iZI6zeniFigtaenXY9k/5X35jduMjegsJ3CqkoYvVbEfgGIUWvN1KMoBiv8UMt54wqIpWmU99pZCPpHKtBF4vtH08W02qRo78zVI/3Ky/YHY7JuGf7S0ZjAJiqlZxuwD9D/fsHgGdTovZc5gnDm/fBOuZ3fOSRLN2oq3aYGu8FxVlBW2u1QjwL5q0rchb5KBlOOgiK+619X8mxSihSr57+HCjvkuJBy9XgHD4U0eSCJdrnLZi189TjIIVS6h8Wy3ugsM6tKXWIr0wnHCn4dyaHiYxXI14thOE9PWOxgETyLSXqRPTP+M7GEuHTksRPZq1puDajt921cCRJw1xri/z08hkNAdgaaWHfvvpJaGBuqQd2k4KAABKZm26HQjjgBiV2VvqmI4VP3u1+U9Wc6/EiXoFlPv7hH6hcidrVd836yEP+kJGzk4n+bDKht42kO43uclGOEF8iwYR86Hmqc34A/rocaHiBio/iO/iF5ciTPAAdjsHRqV+QlXhWnThR2UdP6zn3LGQEw+PPKnYR0c6U9pJBhOJO6eVyqbqUvbB2fp3vZAwq
 9T4IDqIU
 XbzxSgDvBFDZ+tbZiXs/KES47yYykc/Ho5xW+dJBZPaxw8RLTp/ARUgOiv/0fTpsgL3dK6CLXPN2ts4GA78v+LCHIAnpY5tse1cFHSX28kT2NZJEiKJ7W6GfcdPEZ/HjqvOeofW+i5q71drrArvVn2PSq9EI8m1HWy62AXUVXpJTCrC89Zv8gN+ujqgYhOBkYzfrvn6d2ipuSdNxOCQZhFMzCmyNq35QqReDIwWJjdSX1HwvemJDbM4DPoJ5hZug8VYZHhol+tjwEZepvmh7nY+S+0UKznN36fEYNVY1YVSxpz1sMfBJPQaMeAzvbAGbzNQVaAMCpLYiqB+nVk3m4doAW3NinuTD+//948PQaPu1bQd+OLqr5PaPTft/JfgI+69m1qbHS77YBH7R0/UXxJVh5+NL3EWDS2LozpFPssrJabZDMmDr8lsv/k+vhApzBDVyRvXhFBHBE5R8c8Qo87Mrq39MErs4DbDrwtcq0yF84B/remrw2qbw9WDqNWSgkvSFXZYYKwCwJeOH/aZJe3Jz8IPQEZ/64vor4LVJQykveJCvNXZZYbVtzaiaiMrJK+tpExSTO8lzrtb2Qciryb9DNgGYwGE7vNK5GW1dp9EswOB3CHcj5mCBxf8l8vessT2GJZDEc+lVFFX5Yq/nOQtNLAgXWLHQOV4a1i/UvBYDwar9X3qesal5/bhMmdvi2YHssGxVwNmC9rNEpgMqZ2ZDN5S5xW0v6ys7w/ZeBkoc/aJOi6ka2Qla7Cgl33rzG82eXiRRhaFikmfgGUq/c1mmqk/SRLhKoG8XZvXJYv4P6nfFjrONHFIdL60/b6iXCHY/H1Dyk9UuKtb1zBZ+9SZm5MowCNQcGpiTLjyPNcATi0hDvzzhLOh96vFHQsuac5fbZbZES4oN0iG7SoE+eaRr4tZOvUXXpF4T/eJa8OOnr9azsroa7AxNFJdMz4mpUkd5vtgXFY3J3r2q6lJVFgAPhO1ju
 BBrUAu7O
 qiO/AZdyJwa0OyL/7LAuvsOn3lvL156OvPNxY3pmioPyqqUGQ96c2lG5Z7R+GqjmKCE7W3FGw/Ghr0w7twFEIBrGqM9ciRq1PCRaRB5VHRLYqNUt/hzdiM/Hi6/4EkQG+K5QI5iV1sWvA8fK3KHnsKoboLkAaxQsju+l7OsQMTPdaZqrKuY2acRJdm2TzZbVbQwxLLAi+XQ8doGpBnSp6HR6zY8lg1FDW9Yy4XIKZo3houqTUMwVlHRiQLYkpsIFDzgcLHGzMgOJj/Jy9k6z86sQs8AgIq59HKjWRsiKHchaT2jRO2afGsDQQULYu6zveMmIflXPdKiIL5FI+0Kk81GWQe+ZuHxFvoxWnqSCMAFlUffQOg+ameMAQILLGFxZ07/C4EAVDAm+6aaFt/KQaI6yNu50380f+QAvIKOjHI43n9blon0lR3j5Ml+2o1Fy+A29bPM/pvIJQS15SZUq8lFZXCTLFJUqAuKVAYS/2oPt/4C5fuGNDZpY6HzqFmvAW5CjDQ6zJrNlzw+yQnylFtwJvlBGZeQ4cegCB3ifLrSB0GRn8xjjc3Qa9xENr/ndK63JPmmNHNUNapPxt7vvCOOuMQFuYcMqmPavfhcEUo1zfaJe4BfpHYhJmDOqCahAQvbsCIQ9f341p2DR1cn/65KTxlvJWcHgnV93QbirHXbZcB2bEAdlNe+gQDgA5RSp5boa5bZfsG5khmwqzAFs6CXI0rNLf9NAFzOHOa6Ik53bwK2E5CD4EkkVX6qJvuYXLNyiXgSphKmP76aAAOgwyf8iLTzWNYVJOFUhin/JvBYjyy+6UspVbc/xcTYaEXZcmz8IoJYWbvCaaCodFAcksQg/qQLH7uoZw40e/sbsemyTqGBeGsYidLWzcsOW73kOwG+TSwSlgh0BHPyewcKiWqKsQQYImJujDRwIXNBMJrkDhz0diMiGsRc1nlIkOxzeVGTU7+eTFXJP5JcBDsj5A2QWjANrH
 1sZ0Ckao
 gQt9sAP+GOJvltUdsuhjK/01SCnXfi1kC+gOyxqK9H8vS7lOUMxHDaczG5/kCc5OSOapn7qlzk8z99H5rutf0wERRHuXgQJWbTJtbc8h80IFbrx3ejDJMtxb38oFmXSBeMziFHrlPu3vJSqmkXVEShhE+vMsYO8QFo+RuI7FaSmSBNKReR/oFW6mlDQDMQLESjT5EJIw7JjR/y5s4LRuydYIhlj25llNUbKgeDc1IgiD3mbl/sI3eBXugeASIW+crCuDinokQVTikAm2VoJz9/66iYYJ6YGq3sOYXpxGeJATSjye/RCuVeluwvpn289dEOfcyM40UDV9QrqJqwYvhIIMKYOWxLdvt17P1QUy4leHgY4Ee/hGUN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> A kernel-owned or fixed mapping is one which sets VMA_PFNMAP_BIT,
> VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
> VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop as
> only kernel-owned mappings may set it.
> 
> Using these predicates rather than VMA_SPECIAL_FLAGS makes the check
> self-documenting and helps eliminate the confusion around 'special' flags.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vmscan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 09ff20c3df5b..001f8b760266 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4418,8 +4418,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  	if (spin_is_contended(pvmw->ptl))
>  		return true;
>  
> -	/* exclude special VMAs containing anon pages from COW */
> -	if (vma->vm_flags & VM_SPECIAL)
> +	/* exclude kernel-owned and fixed VMAs containing anon pages from COW */
> +	if (vma_is_kernel_owned(vma) || vma_is_fixed_mapping(vma))
>  		return true;

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

