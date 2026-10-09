Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E37B9CA9EC1
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43CF6B00A6; Fri,  9 Oct 2026 14:07:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF36B6B00A7; Fri,  9 Oct 2026 14:07:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD356B00A9; Fri,  9 Oct 2026 14:07:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A10EC6B00A6
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:07:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04E238012A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:07:47 +0000 (UTC)
X-FDA: 85303871016.27.AC121EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2F6C74000D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:07:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CVh1QKG/";
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XhhlSsemSmxgXNdMsOuIhrMWTeKjuFdWFETXzMuu8iA=;
	b=1rrSU8i4wEhmP6Z4HvMGhbSZ5jBb6zZoou3zedidFpQjA4V54EcgOKiZIT9yx47wgFKHsI
	bYOz8m3mYKlxVbCPANkjEJPMb0ll1NTGMdtbsDHkKtGJOVSgcm3k0kR6JMIa03B9JQKC2u
	cj5TxsPYUOWsCSFAhpDzBd/XCb75dLk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CVh1QKG/";
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569266;
	b=FmrSYTNS9a2AdwRSYtONqhSXBhfJn6HOLUFZafsWseM515KMr3MDLMd7c7astF+sQGa5mg
	8p6RUNWD2qDT7R+rHvOca/36n51epWdL3Y5IBtSmjPP4IwQKRt70urZ6zVbFCK0lDLBxMR
	zrdK9HSzVqn/696c9YYX+96fh0eIMjI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7663241AB0;
	Fri,  9 Oct 2026 18:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F1B1F00898;
	Fri,  9 Oct 2026 18:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569265;
	bh=XhhlSsemSmxgXNdMsOuIhrMWTeKjuFdWFETXzMuu8iA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CVh1QKG/RmVaLC/5g/1Q+3bfhMtYz+DJoCtEusgckKBXnjkL7bT0ZwvZab4v4pK7A
	 oEttV62GS/TxCdiC+9fvD8Qp32Wzh6FvEwHOSOcOZvMrBPkZ+F0y+0/vulSeabkZUX
	 eDkulGke+yBeEjJBIgxKpDiwfAiXBQPQ+ZhAHe7N35XpHMSQKQU4YjY/dEHRcDBfZd
	 8s0fCsJji7/5/3xWZ8drMtahRB6Sg7znugCL4VG5oS0iG2fQ1Px1OYPPYNx7ATSOaV
	 Tzjj8MehPQYtGrjDk53cRum6WMonkL4Kk3oASvg/gGwenxf2T3JI6Pzbqjo/F8a/2t
	 uufakHoXz8h1w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:03 +0100
Subject: [PATCH v5 09/38] drivers/usb/mon: update to use mmap_prepare + map
 kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-9-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6274; i=ljs@kernel.org;
 h=from:subject:message-id; bh=MVQ57kbHbmPy06L79MgXIJ1zXhvIw2KdqOI+DoqsBik=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6swqSffhy/HT9z7yweqanb7MvYiHXGuVWtVzYzJiE
 g/E6hV1lLIwiHExyIopsjz/Ir4/SCRsXucFfzeYOaxMIEMYuDgFYCJl+xgZNswy3SnC6jD77vS+
 p9Kb/PVexH1MfaxSEu6VtK1go5aQJMNfgUx/y7APFeZ/VJ9/j/ohZS1u8/D1u/sFroniz4MqNb2
 YAQ==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2F6C74000D
X-Rspam-User: 
X-Stat-Signature: 7xmazhm5m6wjqki71ixxgtxy895kwh8z
X-HE-Tag: 1791569266-1311
X-HE-Meta: U2FsdGVkX18XCm9cgxr593p8xRwYWvZXaYBl0eFJIW7xvsCHBF2KdnP658mlTgk8kMHOiEkKGGpxNh2yw3XpWPqOmJ1MQdLyApwDqUIgACHUo2yNxJlVDbqqig9PNAgJSh4v5PNZcZKiw+p78pqRgXkqhT42nKO1K0r8Mtkq2hrd60d2xmCeF0PTyfKO4nka2bwG0i1RqCXN0Hp3+q6NYCla8+wcjymMVr+BIjEIHFmRIIVdleh5jE9uyrAhaio7A8MN9KubitLABU9X5s5tMeu/GJx0oyyU6kSrOXY/46QXnH5/9lhcZ3rZGVT+mFSZGU5iWsheTw/0rgke6cZNT7gq62GdEDnYRQb2n+L3sNhigkLxzVjiZBnWuPtFh3a3aL/6vOvtmG/d6YziLWkFlrSF9uVCmXqnZnRXTfBt6I2DY8wsfXZzNtyZRyt+NSHE1fI+AaxkyEHdgi80NlcnM/H2ssvrk8IWd/IQ/FkfVvACq6aoHz4i/s6idQ+idBUeJUK6ZGYeA4xmZrBz85Bk9Y2Na+iGdq8QgZLi3sAyfZs/xUSd+kQ+Mh6o8ATaHarOB2RqgyL2HTikpKxa4ZTLz7X97yXsyh8yWuB4v7f2bXt1fWyewRWXUwHncimgTPfh9xmoqze7tBv9X0FMNZmGrg7cgXTUS4nOe24cc8PhajMrZ4ZpnhKTZEPGHrFh4QlSHhZtBsroOZQ9FzxD551+0Qt7YHcPRUNHIhF9SxZdmR6eqVKd86NKQUrHOwvwSHRDCSuU53Z7oBMEuhgjtnuCTjk0FcjB22sMB3pG5o0UGz+0f6AbehCNkp8wSjqlAaDErER68M99CEBoZo5YZYXMsbCmVq4RGFZfDniVXMdIhOVQtcUdha/nGqvrGUTaf7X+7oBi9M90KvH8Exo5ThmJ3w9KQKhIvaaEl7g+t6w6iqTHnJFcxIT4y8vNZJzseWO5gLNCMB3Z5stnjpD8gMr
 GObH/lHo
 URmGuW980ZAafGqdNrDzQqF/f1TFghcoqxOFkQ8WpWEOlxkDtVEDa8QFiEAOSLv+kzpxaQ5KI7129uBFkm3vTz0Qo/PHmYwC3UEdEYO1aWNI4lqD53PHSO8XywrFVqSGiEbdmUN5mmMsxyi6vrd1JPSTRKCiCmJR8wkVigMmQ35eFgq5nLhjAgcCdOMOJakxCRUva5k+zd5gcmb6uCaoRoFeuMCTLRyeQahpd1E8rDW1LLwh5mFKsClaWrMdZrK7iH79gkWPlf/mcY3ImZk5JG6M8tjUP/MJrYkdV0xiqli7R/Su53XkUha2Vm5F56CfeOzQrTHAayw6+yX1/T494L/P66Txb2u8dENy9e3sppqcoCFifq/uAKRceE9LEHXpZT89LSzeZCvJd/zNgzpAaZlntBENhaocwWQC1mWp0dUZhWbEAeWgovew2AOw2ghWeSmfeLQ0jPco21bs5MdfkVpklEw1pp119gs1SxTMnipu5NNg7cul6MzHOqiU/ldw464QA0juLMpHDo8joazUUdQt1bu4oyp9log+Z3T8ZVP0QEKh+MyTm+N7f31GKQngreF+msYh6rAToayh8x2OkjiG1T7D1bJlwnyhOAMLYzSj/RsxFA5N2VI+GPiXyliIECZaOy0zqENFa9INjPwwh4BGA4z2bFTUnJLDepX0d8iWXCKFIsrzABmboTDDEMq5FI6hY8LTl8STAcTQGLBELjSDAGQk8QPzHWsS59Qq2se7VWMm1BulzWsZT6pYjBqrzOYX5mkr2IuEzuOsHbFzWYf+iKS6Q6LfoERQEg3lpLGOrGXtnW7Te45F/CIvqAifsgJJxluNb5bnH+5MhZDyDu8M0ZnL93G++lYcr1gu36UOf3q+0HrqP/asK/4FF8B6SpYRzjqYAdR38Ip7YjL48pElWkBFGDW95bIViP5Km6whbZnrlt1gp/DoUS9wZj+JnYS+XZQdPq9u+aZNohwttiEevY9b5
 jve10iKo
 3GPl2qUAkF1YzQf/Jt1Df/JJnnJF9/cfaidQFxek7MNISWxeAoxNuvbkwud8sU7vklmtsfMl79zyZlzCa2hMtH4Vjn/4yothiplS7+1SqVsgnL72zdoMk7eh8bx4rZYsIe1Crdhq7Mn+oZtFNtZ/6ZlEUTKxLhIH5dUr1bq1pAxZH3r6iGYbfkDPZnrITyGcGTssBpehAdNKduI4XbOn5sZ14tRcb4Ae+FWDeupJ78u3gb3w3jEEqxehRoHYeKlzGnCY3m+TTv6UGUS4TMn30VUh1o8O6hiauyGFbYvB80kLom+FuFHPt8MwZ7MwjSqiotLLnFgG9snhBXJfe3GFeLTTXX9goxoIV7G8SfdMT/v3B7ooJSnb4WTkbBXSHJq/8aFpPjFgQIcE0+h2u6ZAlpyYUPQLD/kQslbrQKY+gQdJ8MTTGp4eZxMqSFz/xEbJxNd8decOY2wbe0l6FeI4zNBCipOihR3iiHKlcR4PJMG4Qx/s7UnqJpcapDEBeiua4UdIxJ3kd3BfGcd1cNkKeORHLj1bTmvTxYrdnEJ/6pk9cgb++JuLnQJ7O/WRdKgIuEtSsNRxJnVRGzIQOiE5upmpLB4LamOS643XKZgVkDqIZh27vrhzJ2HynQcmfTs5GvmULGWWoB/uW03KMRn7Byn+CG0wSWCoi9Z20w7DEGg2nXyOsV3J/o77OHrzd6tkoaeUycH+0kp+rUYgtnDKKQOr/RNLx1iXbYFJgbyVZMYNBgVqT/xrQwrLieTPf0z9OQn/6bDItW63KapQ791eAtOAqr1H32Tjdkusv08SVRSLUo02jwPNdai+2LW4ars+R16RiihFfd+ASF/kFDklhmuk3JIDCISlYr7u/D9KNNuckjmdU1EIE5GsviTV6gdfS1KNn3Aj3/o2NDkaht/EVvZrf5dsTtrl0A8QFcNgSHI/VdvSttMZlqXT3egByF9xksVe1qyc8MAHw0lFMBDY/D3aXEJtQ
 utBtwYKY
 XXYKopltI/3YuuK8a1agZRlkFoCpeW3FxEGyoMujz+SwnCXyKQFDX07IWTmBuP3KeZJqIOGDfaGuiIP9X6GwHG4oLAVnRxhXnIiFoOYGmgyg1P0ltdktx4Xq//Bx9djjgp/Hf4kwxtduF/HQggxT5ZW2T68Ex/bEJCrJ0obyvXy/0eXEdhBwo6Dyl5IiXCs4iB8KgPXKrPLPGQQNMjIrNACBWd+MnXCplTrYcedbmtPB6F1r0EG+TyNY9oYR+Zi5tz1wWar/eOUEYS3iRMZdOrT5S8YVo8PUkVlwkA6H8A+nCDUsSK43GfLUzuUtBPp2gcI1foBRxVNix2rEW+ruy9pi7JGzqn9T5PmJJE0un7DZ3dT+wtXbpiaIGDEeqGdFXOts3oTLRRoBqphi6a1zPWo8U+todX7ivpoXpA5XpbkX3w1Qc73B7C0j3cqMSPH2bgOlM38mZFSfzhZT42PJHrfJJFIxitLVVyrpS1u9taMfgw1vm6BvTEZBTO1JCwYxzFL6zkquEK1ixTzf+i4WBoi3YdnuicTZpzc5ZNqF1vzQVYJI4rHK8v71ZJAjxwe9n/Vv+uNHq/PWPD3Ei1a6FV5v14gddiN6pu+8mLAy8/Lltir4wwXbeR1Ag8S+iZffaWXNArqVvfnuJXG5v+j2sL993WZEhHielagBfHxdJRESXJcK1wSoRVbORh1A18mQ+ESYZlh7QkjZLrtwLgB0s28yQqbVOwBTiJG0LOtG5+d8kMAlo+Qe6d7iBRKw7HmpNYzF5zN17uLeXkwKVSOApT/tfZfWLA3nHj1kOxPlveloXjWoRBDmpaxp8cTFKe1nOIxk1NRd6VG52Dubs128j1racrXUlFx3mHAaJ71A+4OyShZWeS8SMRcDDicx1bYgMsvSEGs7QfNWa3Rp3ahrCiDkQ5VLJdpcn3yw1ub5ZiIqUspX18b0LuuBJnMyr3WhqemfNM8VeheSou5jRvHmztB+HLS3D
 l9wUx0hN
 UwSIqCoI9Y2lcun03bwcAXKu+bva/0cVERVfkdFaXpntAbwa8vjqfVl7giWGPwd8SWgGup8646Pf6RATaTUYhHYuy9N9k2m8UfuJrP0kPgI27MXZiwkz5uhMSU11T1n81fHFh8nOHZ7rJkFIJkPFZ7DbIlRQGYkKpWYjzEtiPCysyVrGUN8WAcrGuV17YgGkwl9j3fY8XEBlLDUY2y16MpstmbC5Xpwu5XPDVxBMSQlC1bIXjvk4C3MPe3ta2r8NsdZIG4xP57C32mV+TQbZcBqaWEs99tcInB9El3hM+45I8x2uuM0S+Stu92Ju/wwLAkhxd8RrU4GJbVugsU9HuPzpWYic1PhUx8TOTwrjMipficn/mv/u2Wc/q8zpsUDoPZ4IWD6u1PZXoFF6RRB5VfLesC8JWkGvpQlD/x+sa2qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the deprecated .mmap hook with its replacement .mmap_prepare. As
part of this change, additionally take the approach of mapping pages upon
mmap rather than providing a fault handler.

The page span cannot be mutated when an mmap mapping is in place, so this
is safe to do in advance (the MON_IOCT_RING_SIZE ioctl operation exits
-EBUSY if it's attempted, gated by the rp->mmap_active reference count).

Utilise the newly introduced mmap_action_map_discontig_kernel_pages() to do
this, which allows for iteration over pages in mon_bin_discontig_get().

mon_bin_discontig_init() increments the rp->mmap_active reference count to
stabilise page spans. Should an error arise the core unmaps the VMA and
mon_bin_vma_close() drops the reference again.

The vm_ops->close hook implemented in mon_bin_vma_close() will ensure
correct reference count arithmetic upon unmap (with mon_bin_vma_open()
accounting for splitting).

The existing semantics are all retained, including not mapping past the
range of available pages, with a SIGBUS being raised in a userland process
that attempts to access past this point.

Ultimately insert_page() is invoked to insert each page, which increments
the reference count on each mapped page. This mimics what was being done
previously, only we pre-map the entire range rather than doing so on
demand.

The existing fault handler did nothing that required demand paging, and was
presumably implemented this way for historical reasons.

One behavioural difference: pages are no longer faulted in on demand, so a
page discarded with MADV_DONTNEED is not repopulated and a subsequent
access raises SIGBUS, as with other pre-populated kernel mappings.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/usb/mon/mon_bin.c | 82 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 687f6a8981f3..9d00b21a8153 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1219,6 +1219,15 @@ mon_bin_poll(struct file *file, struct poll_table_struct *wait)
 	return mask;
 }
 
+static void __mon_bin_vma_open(struct mon_reader_bin *rp)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rp->b_lock, flags);
+	rp->mmap_active++;
+	spin_unlock_irqrestore(&rp->b_lock, flags);
+}
+
 /*
  * open and close: just keep track of how many times the device is
  * mapped, to use the proper memory allocation function.
@@ -1226,64 +1235,79 @@ mon_bin_poll(struct file *file, struct poll_table_struct *wait)
 static void mon_bin_vma_open(struct vm_area_struct *vma)
 {
 	struct mon_reader_bin *rp = vma->vm_private_data;
-	unsigned long flags;
 
-	spin_lock_irqsave(&rp->b_lock, flags);
-	rp->mmap_active++;
-	spin_unlock_irqrestore(&rp->b_lock, flags);
+	__mon_bin_vma_open(rp);
 }
 
-static void mon_bin_vma_close(struct vm_area_struct *vma)
+static void __mon_bin_vma_close(struct mon_reader_bin *rp)
 {
 	unsigned long flags;
 
-	struct mon_reader_bin *rp = vma->vm_private_data;
 	spin_lock_irqsave(&rp->b_lock, flags);
 	rp->mmap_active--;
 	spin_unlock_irqrestore(&rp->b_lock, flags);
 }
 
-/*
- * Map ring pages to user space.
- */
-static vm_fault_t mon_bin_vma_fault(struct vm_fault *vmf)
+static void mon_bin_vma_close(struct vm_area_struct *vma)
 {
-	struct mon_reader_bin *rp = vmf->vma->vm_private_data;
+	struct mon_reader_bin *rp = vma->vm_private_data;
+
+	__mon_bin_vma_close(rp);
+}
+
+static const struct vm_operations_struct mon_bin_vm_ops = {
+	.open =     mon_bin_vma_open,
+	.close =    mon_bin_vma_close,
+};
+
+static int mon_bin_discontig_init(void *vm_private_data, void **private)
+{
+	struct mon_reader_bin *rp = vm_private_data;
+
+	/* Dropped by mon_bin_vma_close() on unmap, including on error. */
+	__mon_bin_vma_open(rp);
+	return 0;
+}
+
+static int mon_bin_discontig_get(struct discontig_kernel_page_state *state)
+{
+	struct mon_reader_bin *rp = state->vm_private_data;
 	unsigned long offset, chunk_idx;
-	struct page *pageptr;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rp->b_lock, flags);
-	offset = vmf->pgoff << PAGE_SHIFT;
+
+	offset = state->pgoff << PAGE_SHIFT;
 	if (offset >= rp->b_size) {
 		spin_unlock_irqrestore(&rp->b_lock, flags);
-		return VM_FAULT_SIGBUS;
+		discontig_kernel_map_abort(state);
+		return 0;
 	}
 	chunk_idx = offset / CHUNK_SIZE;
-	pageptr = rp->b_vec[chunk_idx].pg;
-	get_page(pageptr);
-	vmf->page = pageptr;
+	discontig_kernel_map_page(state, rp->b_vec[chunk_idx].pg);
+
 	spin_unlock_irqrestore(&rp->b_lock, flags);
 	return 0;
 }
 
-static const struct vm_operations_struct mon_bin_vm_ops = {
-	.open =     mon_bin_vma_open,
-	.close =    mon_bin_vma_close,
-	.fault =    mon_bin_vma_fault,
+static const struct discontig_kernel_page_ops mon_discontig_ops = {
+	.init = mon_bin_discontig_init,
+	.get = mon_bin_discontig_get,
 };
 
-static int mon_bin_mmap(struct file *filp, struct vm_area_struct *vma)
+static int mon_bin_mmap_prepare(struct vm_area_desc *desc)
 {
-	/* don't do anything here: "fault" will set up page table entries */
-	vma->vm_ops = &mon_bin_vm_ops;
+	const struct file *filp = desc->file;
 
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_desc_test(desc, VMA_WRITE_BIT))
 		return -EPERM;
 
-	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_MAYWRITE);
-	vma->vm_private_data = filp->private_data;
-	mon_bin_vma_open(vma);
+	desc->vm_ops = &mon_bin_vm_ops;
+	vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->private_data = filp->private_data;
+
+	mmap_action_map_discontig_kernel_pages(desc, NULL, &mon_discontig_ops);
 	return 0;
 }
 
@@ -1298,7 +1322,7 @@ static const struct file_operations mon_fops_binary = {
 	.compat_ioctl =	mon_bin_compat_ioctl,
 #endif
 	.release =	mon_bin_release,
-	.mmap =		mon_bin_mmap,
+	.mmap_prepare = mon_bin_mmap_prepare,
 };
 
 static int mon_bin_wait_event(struct file *file, struct mon_reader_bin *rp)

-- 
2.55.0


