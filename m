Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6299CC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D009C6B00AD; Tue, 13 Oct 2026 11:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD90D6B00AE; Tue, 13 Oct 2026 11:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE6F6B00AF; Tue, 13 Oct 2026 11:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F40C6B00AD
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:09:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4019CC0BE4
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:09:59 +0000 (UTC)
X-FDA: 85317938118.27.9B8B427
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 81136140006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:09:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QaMMPvoB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904197;
	b=PHKnfVE0snyHFndvrNUlbejhssh3IsJEbWWf6t6hksvTCYpEF/bGbYRvbG5svZIexLyWf7
	oKKimQl/mHx74BV2AxN5mtODeZd/1eK8MVuMsvshH6EtWx+nrrZLowm9/Po1SMC8C1lTur
	MPkZ4UQHBygYrwJjDwGk+SHT32Exz+c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QaMMPvoB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqjij0GQHv0uGr5m3MLqkx9Z/Edu8SdGUtOw7ak7aEU=;
	b=wCYY2QGPbAEAR3oVjhbcweNk4stkaT+oiJ+nX8q1yz/llLyZakJlMXJPoJt0JRnpD6VrcA
	fLdT/RczkESSn/XIizm5XHu+jNGrGZ3D3vFh5+CKvy5W5gXeHsrodUKA7vXieh+kdl6TrI
	Zz7FNxK8D/jxjRzezeiBs86htk0oR8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 02F8460A59;
	Tue, 13 Oct 2026 15:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699EF1F00893;
	Tue, 13 Oct 2026 15:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904196;
	bh=pqjij0GQHv0uGr5m3MLqkx9Z/Edu8SdGUtOw7ak7aEU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QaMMPvoBkRQFAMn/jOf8exJm85hwBU5pSElCP/Er+C40M6N+nEcPRKHuZe7qiGCoi
	 FMiKMiqdGgyIWPe3gPJwJ7y+l+nzSPqsSYMIwYHywtyX4x/hEzxvxSoUiwP48W61S8
	 /K1Q3HENunFrDm14o2cQDUwlnzKVqNoVxn0iE61EgkEUdMRY8R4+LWEJEa7vrkBQLZ
	 EbUqY952L3/osbrWlw36bO6EczAH1Xviw7prpI9EIF5yss6+RXyVBcjYshcFZ5laN3
	 Y8ILMCLkC9O0UPqru/KG6ii8DhSkgmlKBPfMEJvkp7fNYJ5kVy278xiAGZTGWPlERj
	 5Jcp8ZDSHQVUA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:04:47 +0100
Subject: [PATCH v6 07/39] mm: assert mmap lock held, use new flags API in
 vm_insert_page[s]
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-7-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1941; i=ljs@kernel.org;
 h=from:subject:message-id; bh=TbqTPYaAeeKYfJzERyfDmnse82FvI3oUPXbYIaX+sow=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZxgd3q2ZYbv9L0VRdKmsr5XjkcJfTodf1Xzyqz5T
 aVJd/++6yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEmmwY/hdv2LP/+bo1Rb0a
 Z7aZGO1/1b9r9sE6WSsflZSsF/vCrhQw/Pcxmb1B2vSNUxRXUMPJeh3lDYGrouy+/4x6+uiN8Tf
 ttdwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: swbsbwpjgr516etizmnx9s74qwn7j8ae
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 81136140006
X-HE-Tag: 1791904197-976189
X-HE-Meta: U2FsdGVkX1/U3dsdudD1EY4ei6k4JUtvchKKXYcJsYjwozwuMULbGdM9IrtyEIdNjJ1gx0hoh0GESJb7YkVTHKryFgHXfjgq3SF3FTgmDU2nYO1VPNWZnPWvbFB0C3AJvlfmleV0Ncr0Efejv3NB31Lr3f/iKSRa6+35BYP8pF0RXpfoqjSqrmM36ASETKqKYAQYGMI/sFFDNUfNCfI05WgS6Z0J7Oa/2ZZRywuuse+FMqHqj4ctn4a7URWqELl4Tb9M997Xa43pigrXbpsqiW7DggB0I8sh8fvLFLhnZeyWYMa4xEOrfx23/fQvKzzn4i/L/UDghHW1ucbTw7GnHwQa/+RsVqhZhBwiIVB4Vudm+zR+TrKTkGiZhQP2DP8iG0kZhs7J5lyQZvYHLGMkTGNmnv0fRBkAQhD8txCpahkcJ9ktLIw16GyHU4a/8ojkJFFWOHyp7uRgNmVk9+Smy1ZUldP/V2R/ROOYsEP3SQKh3yeELPBn68p4o+rt8CjORfFbHr33I8JP6fNOyDoY6dpMfrT+DaXpv06cnROdGqtW9goHpxvFRPUciLGLVaWSyXqIHb7+uoNadCNudz/V7rCVhzSHn3YhFN5fWzV1I6FB8rq7/ue8cNwd5oosW8Baf+ORK8row92OGlnY76YpqMKogLpkmWdQRDfkAsdLssKUTfn1Z4m4YyLFNHtkdQ9Je4tlMRW5t5Vz2fU8nwaftnETYt93NWTdEYlTmQ8j/OX5b3L10KF9i2Mbj2plnVlSv25QCZowZ2i+nODL4EcenuK9LquvEpnp1fsAW1iZBNKtWp6duxj6QTbccGv3TXIodaQ70SCFXe1UdJtxqQN+/lPG//+VObXCiuXgZ6MMbcKhaL46xEg8Pz/Je02bl572VcoEiRFNCiF0ue8bel64Y+3/b78XEGsQo3ZwbGiByrW+B/sRVS3UHP2tkeIbKfTKtXaOAfrZqBITa8AwCan
 y8Kw4vI9
 eLSX3eJS7WGJ8FKLg0huFIaBQCsw67Gv+vFbft30aIE0UTfom9w/+el0PmYfKOT+q7hKi93MwVZUC7krFrQL2DpWonwLptwaRBXLnWbWTlQr8CGHdthNZPJUyX0RV8t9fjYTuEpi2q+fzulalcJLI0Fpy89lkWaCbk/XtmeyJUgnroHjMdcC/3qjrUv5HToXatNAPvu0OH5b9q95J0wg/rwxUyLIyxIDH2est0Ge+NgP0puoD3nvWwZdMSzboMFqii6m02Qo23EJ7tk9u1/92mjsZcZUwcz5fJ5PaXRSrVoP6uNmMegDIPE/TD1CRcs0XbPlKfvMjgUr/x+E5vLaidxhDLbVJ7ofkeD6MKj0L4yeUEjbISzc9oJ1cHfRWP6zOJYNLsQtHnYVdOVZMiML6fGxJ+i21jze96HnEnXrrN9TGTa5XSQUchYm5HbCNvCsuf+YVFwBMFcfdOIj1KZXt7qSkUkOY7pDaba8IECK9ToW1/OIZQQKS0iLwyNMHrJ/gubm6Q87W92qWqoQGlr7S1PxLiJMj3sJ5jrjYa6T5x/ZNaVzCW2/U0ZtiYiBEFLIOQLjXXM47Ut5E1J5CplKSHK9nKu9NS1R53GZH+8b+LLUU9H3ClCCKWMazJJhc7ovP0FK7nY4zGSYKii1IPnEb66KCCkPEhCFvAj4Y54CiK9cm//o9Bzl7icVIbcLIluPYiWY4S9yPsddkwiwCvhIY5ZWcCnI/CjqoqPF+YV7TDMsuqOVh4YZ0R55EPofy6IQskrsBYDgy4CQnSGEKtyZKiERnjFzbZCZcGutuAsZs6tS+4HgaI6+z3aKbYKEybxrK+2ryyw5OolfZSLnDug6mmy+ztB+XcXavzfO8/PKZ6wB7N3PDhFS8dqqTsJRJPk4f2qWRG2a0ALZB90GuQ2ZiCenrJ3PRub4L3+wD4m0u/nwtjWqTndmnDgQJoMcg6WGOt2YUDwHZTX9+BUl8cAjKCY7TIXZX
 e+JdEhAs
 VEE3hPOyka3t0GCPOflHo9TWwcHpgiE+oCcyvhJ3yBB+ngMr2fD16ttlDXlLB0IyDWRGwTrwaHDyePisSTbI0IUjrtDjdZWr6OOGxmx4Wj11zkOYeH3EFoAHv/n1Ve5MKlaMHC02uVvVej1f1pDnxbEi/oB5Ts2sedy6f67YNp/LgpJ1h8Xi1XXdebtpFgPSxFcx9s1R8iSImOpYqW/E7Q3SJvLjDZuXuEbbrDmlJVHdFgmtaLMLf8Hveiiv/jyc2hlIVx11tz9MmgY7xS53W93PkZbxZ1PyEWEhc9AQT0Wj4p8SASbDvuVr/zzf7rqTLQn2ohuUGVEj/1w826sNrWPuyBH77QZp9N3Y1vKtbDS7ADDQ4f28Y9IpQ6NUR8j+NEAJMNxr6nuqzWfK3eUG9PGjSC2ylbThWgcZrqzOpF0LZ9jWLDhSgFkQlNqNl7+++87pSX9HZkCIENnstyL3K5BhvqsvBqmq950x9IR954FLTNRMQcu6gD44rYk0lF9NawNL6zbgCa/9G62bTIxBsKPa+P8toagceeSjOHj8AuHvjuIy++0HZcbu4p68JhoINS4gO2fCsP/UWnVC4R5aGSSN6YwCsePpffC9YlOttvIbxkb6y1brOIN0B5bqv6Fa4I1srPJQ/1p7v3WwPe6eS/PjRYG/DLUTye/6y0LeQ/F1o+QQ5Mw385XSgKM2t/1wqQ+a5Cs7iLeCcg1u1393goSI4ENTTsJysczHp17r4iFUVNFhW7BCF1ThmZD5cp98vYxmVwrsz+RfZb46XY2VoCWnAwQap1pQxnyZeeb6gh0LtWaYqzBkL7ZAEwwNCUXs2RXLy9888Y+NQwnosLFOrh+NtyhuyO/NDnU9MeKCqdkisBrcL4UEQ9DddTYEQc1cnWT1T5q4Lxipe4DHd2fj4AZ3VVGgXjCe+XDwfm64LeSwn4ImWjBii8vXRmjeKDZePb5oJMrkicCZo+qiN42W6CSdYpC8x
 E1sWZo8S
 rrDZS+W8yMoj+ToyuMYBDo0kqxPipewkKT7FZRHhKik4ZgkCOXQsO6qScNqq0Tz1N5nWoC5eROqZ/FYljgJ4Q8IKMQOWhthbsc6VpAimd+54TJZfRb3BewsLoIqIP6qBwQTWGDhpvjZ+PHqs4RRDm72X1WJGPQ/XN/0gNi7CL0sYe/ScOk4aNcd7cVgix12qyUYoVkc1yEZlu/b7oLMt9c1lt4/SKdZyTlxqjktG+5jWVzsyIyRa3lzWiFCG/G3mxgT6dZcMB/9QO7IJmYlpETceF619ZenbvwlqjTTB5DIIQtohBEFRZndFzrzhgeW1t1/lC+uzIJmxu9qfeNsCIIaJ0/HCYSuQEK0xPm4eOyeaOglYzXn+lr76bAz0moWN8PT69FLjOwRC7MBfOHst5X+55QZ1FEN+jJXeWRDi5FvSe2ihhLtlDvTAOe8Rtc2bHgzx1lr+qTSn/RFbZw1ETf9l21GuQCnW0QlNNGePYrvX01XqxUDprIQsVMA1PlLrtI/M+GLnTyqFttv8jZEc6sdkjhokeNc0MrQKiAoPe81R0TGehTPwuCDBDf3w07+oAzWMSMRJKPUUjg3upRq/pBH/+RMtdnG0x+wLa26JLGD9c/hez8My1ChxAefwUFdqlI7rslh+PRAUZT509pAkezpoATTA2AvJc/09xy4Wf5vw+LZcOFB2/AZDwlPWBrPoOMqrpZCMjORqpUUGH+YSaaZqiwVPfL5DvNC0qQCPGYAvyDbxDQLM8v8trHzHBL6fg3JbvpS9e7vSOm3wBHjGKfrjYJhmowCfmUI7vL8eO4Hietf3zYYHjFsXiu/bBlG4USQzhFxyvF9YUmukWTlO3zCypVLNFz/TmNjUp/yqfM+yey/EOQzlx1FKqU9pxnqV0vt/Sxq6c9DsjYHXTZ73QbneL8SQ3os2fHRqSjsTMjNz0QzFe9suOTCCtpLScn/0mOdcLtKQNYwc88xz16zE8rXWdp39a
 yY0zFMDn
 W6FA03UsOFuLHKh2u4gSzwe0oDQygH+VnV1/vUsJkEfgBdBRgmpx0SUIuRgrzcKj0mOErqM/wbfsakmAJuH3lJp3r33YJUSj8sA/1jAcYiMWaKTAAMLG0bz3wEg/1LIg1tkE277n4IXfcRL8n1LsaJJWoG3wIdFCt1cuJS/JLKesyG3Tek9SbjWPg5u+SCRFU8ObGZODjnkOOpBJFhQrB2r+K+HJELgwAYcfv3lmVNnqAJ44l2qU17pUpyssij3U+cWvTSgf+fAIz4wv75NoTnjPMBiPq2G5bYewmfWQvIIUyklPn0AHfdRCwWZ3sGrzPCS3hAZQ1a4Q7s8MjcMmCB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing logic asserts that an mmap write lock is held, bizarrely, by
asserting that an mmap_read_trylock() fails (which is not the same thing).

Assert the mmap write lock here and switch to using the new VMA flags API
while here.

Note that the vma_start_write() is explicitly broken out from
vm_flags_set() here in order to use vma_set_flags() safely.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 448342883e9d..a35cca09eb71 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2599,10 +2599,11 @@ int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 
 	if (!range_in_vma(vma, addr, end))
 		return -EFAULT;
-	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		VM_WARN_ON_ONCE(mmap_read_trylock(vma->vm_mm));
-		VM_WARN_ON_ONCE(vma->vm_flags & VM_PFNMAP);
-		vm_flags_set(vma, VM_MIXEDMAP);
+	if (!vma_test(vma, VMA_MIXEDMAP_BIT)) {
+		mmap_assert_write_locked(vma->vm_mm);
+		VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT));
+		vma_start_write(vma);
+		vma_set_flags(vma, VMA_MIXEDMAP_BIT);
 	}
 	/* Defer page refcount checking till we're about to map that page. */
 	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
@@ -2675,10 +2676,11 @@ int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
 {
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		BUG_ON(mmap_read_trylock(vma->vm_mm));
-		BUG_ON(vma->vm_flags & VM_PFNMAP);
-		vm_flags_set(vma, VM_MIXEDMAP);
+	if (!vma_test(vma, VMA_MIXEDMAP_BIT)) {
+		mmap_assert_write_locked(vma->vm_mm);
+		VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT));
+		vma_start_write(vma);
+		vma_set_flags(vma, VMA_MIXEDMAP_BIT);
 	}
 	return insert_page(vma, addr, page, vma->vm_page_prot, false);
 }

-- 
2.55.0


