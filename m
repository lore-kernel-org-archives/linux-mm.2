Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6186CCA5FD9
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 07:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7DC6B0099; Fri,  2 Oct 2026 03:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1576A6B009B; Fri,  2 Oct 2026 03:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F216B009D; Fri,  2 Oct 2026 03:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD16E6B0099
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:03:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43F40A0642
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:03:06 +0000 (UTC)
X-FDA: 85276794372.21.253B85A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7A34DA0008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:03:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ijpyrGWn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790924584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2e5cYzTU0sh5LNP2W4Golqb2KICqZdt5/yieI4RARk0=;
	b=PCbiRC7FXdtqfLcpbX3yHYTi31YFBqDu05ZulWVO572OkICMX9rJH6azIioTWs6hZwLEOw
	9NDaeULSHMv7Gn0PDxJ6mv9KSjUnPlCOkkAKYEo6l8pGBxZiBd50rKO+W1um6t1F1Ga/WL
	DiAVHPqxqvBCVfTxUI/fJxGNgjp8S3Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ijpyrGWn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790924584;
	b=p6FtwViFAQ+xD8MM+Se1m2ChBUrYS2dbA8WJks4UIBrdsyoPYQSFAbLWXq5mP0Bej9Y24j
	2J3UINQfym2izt8CLw6AWLlsmlHWNJ8L8vo46X5y2vdrNq8tIggWhrXrvctvTLkhG8HzY2
	fAaJ8NL4fT1afI8x9henJQ19cC9jTvo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D766860A5F;
	Fri,  2 Oct 2026 07:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E14C1F00893;
	Fri,  2 Oct 2026 07:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790924583;
	bh=2e5cYzTU0sh5LNP2W4Golqb2KICqZdt5/yieI4RARk0=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=ijpyrGWnbwdrhe2jSIA1tgjRHqpEFUuAuz2LAEPYijz+fXIwGq93mJDGEe3i4p03a
	 1AVGdzilUttbUPpMOUj04JL1e9sSyWG+acUrJzdTAjfiLeciL3f8g6h+U/TZatFcIF
	 U866q+DJ7IA9Boh/zre7ocVlNathCqD5gQ6etybZAUwNUTH167xXnXPTfAsZZqEwe4
	 DuJ8aLGp5g+gqy0B3Wp22qbl+WPtsYQwd01ik2WjOH5Jg6dYWPEEx21Ac0zdqIs7+9
	 kxAVyqvMkf8gmPDrdkN16r36L6W1KBCW+EuwCxuwuaQPDB4Lc/r7HUMYNn1ffvpga4
	 AkJ/nVm1Xlhew==
Message-ID: <3557015d-23dd-41ef-9832-78b58587f3f4@kernel.org>
Date: Fri, 2 Oct 2026 09:02:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 31/40] mm/vma: introduce vma[_flags]_is_persistent()
From: "David Hildenbrand (Arm)" <david@kernel.org>
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
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-31-4583d8a23bca@kernel.org>
 <9bbdf4e8-6984-4477-a183-f0b236047381@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9bbdf4e8-6984-4477-a183-f0b236047381@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ste5ou97x8doju3rgy6nxjmo7sijmpfw
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7A34DA0008
X-HE-Tag: 1790924584-386514
X-HE-Meta: U2FsdGVkX1+e5Pv6MhkI/l4DtDpbW20Mqv+8A/Ip8S7mZ04aBct2GPkw2LVbxl4WJlDsDNA7qFTq7gWQfACA7nuWnwEFLWLrT+C2HvNdviD3B/hr/WwQVCb4GhKwfOghbwmMw/F0t1ziAAi0hgMN7YnhZg6NzKSY/zYPLTMP5IDLNfRXXGSyLz4PUzWsnWDYsyYCqqxyfvE5qfLD1L46n5x95+33jAjFeBrlW0Ksq5UkaXTW9WSy9b0HdQeHRzcqCAkt/5JmNyNNTh0Kv+DeDvYtkoyB9yNl74W87SHMHEQtC2RYb4NgCOrVU1gcsoQHVDN4NxHA7Ehe0CQgM0ds1OHHR5bzIBGx+vmIEqlg3Rf0hAhO1tq1e3nAbcQTgJk7AozOU6C5yljZcAPyfJ2J6DTTxW56brnIp+u4IFc4HhXReSljpf9F5StjLZJzk4M5fS3yRRmSSLDqurj8rh3/myFgVK5KGXDBDNSSr83AoI5cx09svFG2HwYEueNChKG/2U+0mPGPEww8lr3sfmWUzU0Mnp7JAZLSYWu3TsXj2zz2B/Yso+zK1hmKfN1ZKSzlJ/dFgK2LG6P62MZE2Jm1gctM1Qom3iAidwSRNH5MXFq3ZWojxs+hzBTCn2DrJ9FrW/g4M5Go4rQpERS9eZioUfZ5EepAfnW2vzCzqVQ3ugCTdGO0sHHv5PjDCX6dpI1p+EL0BqTotZMj67oKLuOgd4F3I73cNlvjoKOqTgbf7hx/jBvXPl1NqV7WywF9uEA26S1KuUqBqdF8qpMPT8zL9rdISoWP1hbcYI1tTFZCK3+cHD2kO6CzgFrytYPuScYTwMi/E9UxKRBnxhvqkQmCqQcq3yUdiRpzSyLIiIg6ET3HkKFovTkDEXvzRjtOAda1DW5Ti/5YYw8I3WYFZJtkmjnl/PHpbNvOH5dqr9kyCOU0ugC2wiWTW5HE4ZnuaJEndIxYDHADrYMKpiHyXYa
 4eXsGHjs
 UpGR1JFRYOvffB2RFhjwu+yggdib2ajR0JKbwUv2nuwD+KTy+FyhRLY2pV3haJMVziAsz1zwDvAC4qkP22FAU/i+jEh+QjS8mS6nMCCG0XSlr7uXLmE3PjU/VbiWsSaeVFDXoQdgBOqadaxA8VHohQ64I2Aha9HPZyFg+Qe3MKU0jXCPWesqiM4doAw4l8rjjmbwYz1zR6aVZTWFoBA5N8xfSZqxITRX9jDLKg0FzwuSUsCGI4FQNK+SQO0p9j0XxV4Vrc50Lddpk8rebCk04V68SzEjxPMOiHN4UBHxQL1a5S5zYzM7zZsI9tysIEuoAAZbVcF26Ynnrwb1FPjtzMZSXI3mBJ1PuuCHMMKbskW/mtsbLykta5zj5o6teAlGR+WE7xmxX4xwmRsahcp+izrFqp6W2HOF3XFzkU8ZIdJziI7c2UauyxL75y7ob7obkwgNcP5bSHltEYo6f8t1cpgdEMRxTwVDaK/sairO6mnqsUrYEdkSPWD9abTUIlIJmQSUqCeYMJOjOI99rse+qU/l3NhlebjqgWAbp/F8rfl7jHo0lsBcPqReExzC/xXsEBUTc9OWDtPXUor4DVofp8D0YyGyXwPbi1BHVaLadl0LZ1ZWlnXbPTF6V9KK1IU/UEL9QsSTqIH2dbfjOQElRdxhW5Yg7mfeCtIjylNvsiN/inlNFGPcWugX1HUtz+H2h+C2HQZKfaIcnu9j4oRQUicFwEOg9DxSubZ8K+LbAAj2FHUg5lKvQv40c74HKdI6LM6sSkhP0eB2zcNFgHa4tpXyERFqYi6sBrwEpg4LE/AvqFw694AzxNMXeELIH1bOwdBUcHaCFdPiuCEVqvYKfnfb/U5QPZeb/1LjEOjLhUQVxVrSD1U40Jj2bSHb+w/DRwjbZ3KsMSvXhbGP2p8l5RfNhGGTjePbKjPMPyrxbK6MoZeWzyLkh4y2xGLS5JpuxKXDGPbNT7Q2hc8PiD1Jz2EX4GELD
 N4X/CbrR
 qDToGY5eS/FEusHFUbrSFAfTg0qmru9B7sST3ZRj7Qi9xew+NsnKTYIk86LbUuFNrVUe+GnuOXNeZYmsjOok6asXdG/+V2hcCUGA+6Rv5epuwLuhdbENfq+B1h/PfZiFPGzVLl5wk69/kvyvFxtiZwRe35EJit/VH+gMnlglOlc+D4QMwgZFaXZ3Xz6C0VpktsDFV3JKUZTWhPGqKbMFCdQ9XE6uuyPSeF6C/WjqrBOLBWvrfYqZd339u+0a7+MwtWcXS4RepPyK2J5THmSpa/ZABZSH6IOmAeThuR0KGU6nUnziYLbKSnsLFjbdz2iCo+SYLwZJLrVNJhlU5QhDj7hKtwU/Q44XrCsZetRXoRIux8a6AU2SzVJvrwORmHc/YtNHmzn/5deGIEKFOrIvsYscIGJk9SN36gTys7/tHJ2So7KSzShT+I1tfCUSnSvWuA3rScqm9usCHOa8T4G9M2aD/vPYBk2l3LzCKbVfY0IJ9OgvZ9KQ6svLX6xqhOgg47wd/0EzyIPDh1QZiApal7b+jgG3PFxscIcRaiPpE/3XbXRMErFlszVsk5a4EVbJcmkmJYxGum0Qofrqqgff3oY2G7nUwMO0bV1j+BuaTdkqvYjGzSjzdLS9J5FSCoKlUCjDPC8i8WvjwODcHwNujkRxF+kuppcBtbHA0fKmW1X1K3/AxBlD/jcF90s7meeMJMRitDyhKsNw7YvfqTwtI+kKLeHZD2w5Q//m6nBDmNpp/Ew0z4v3QFqxQgSIAJKg7VG/sgULAL+acHmsuBDDWr5zXnA5WRhRfAvo6tngzgMZxWdqLRrOFoi9q7/E8mEEz0IG9ZudAuJwPZNGqyD8kC/y3Ab7V+XMDWKsdS8ABURIOWeBt0CeQczJVFNTxCGuX5oRLA9f8P3De1VUgSAZPoVTc3Y5pOkHgd9P3BMKRLu4Wq7vNkdyCebeUdkwO6tWLDPLyzMjLilpDbucnaeMWSE+Mp6IF
 rQ0yjP9s
 +t1IwVsRjVu4t+ljEbwSPeakrdi3muANu6nqdrvWyOaZQkTMjZ8Z4TYwUb8pmQGHU7/Dwpphr8WgQtkUugrhqYzOKQlT+cXe+QARwfew58AmNvLosN+wynIUiZF4W1yhM6A3jk63nOwQyMrcMr517Zpo0v24V67OfLtloe6A4MpJ6ZoOt9KFyLdszAILu0Sb+AvGsZSPRESOT7HY+RXxD8J8CyZRgL6lBtO6lfnBt7SCNMTqrjFdDF9vvqDD7UTOsJmhp66L9YgKYK1ul0RLBLRMlYyMGzLCDjIIoaHSoKeERA7rkwjyarf+UdiXyeofyeHdqPHELAjZzePSjufA8vtomQqW491Tgs5E1hrrTZy7E8b93wxRcUlVkOwhrUJ7I4I/ls7qgVW27GcJEqe53XgYPAinNqW6ktoJDxhtSRf4npGv8dCmt6UQQqvrQnhUCJs6mAnxcEvSCbxv3ArLnMYCa7ZypEJaqxD7f/8k5eUPKg3YMZPpmxMNXfZzfiZxe0hjuRHLfv8Y58zWQjsEkVv7Ju05LbgAbw8IFGRTJ6uBjtyrJbZtvAw25CFuWZj4ETjWiJ4/xt82MwL92agojqzk79Qx0CqQBMVYivpaVu/6fm8eSqUoMbFM/h5ZJE528i9FuoBTrNZoKr/mE5dYrm4vTr+qBo5yH1CIzI77XlVNvOFTMbd5n0wo+R+mF3R7B/STwR84x5A10crLcrtp21U1LfrNTYPrMo1djxYhwz5w9mjAgcj8MfsGJJIa+D6nBHjTaItp8sB5LWe2qLKKy3PnhZ+3rUMnm4bsaXlvUFu5kjYVd6wxeGhjsL1ixBVJYiENiAeF/MtCliORfWja+LGLOAFXEYqcQJbfPBFN9S1j4XSnM+0oMnPV9lHFwxZCOzEild3FyU6p8S0uOCpAEX15fDotrKkH+WWkbA04IwloBze13cIDplNdSwKVMFfXG2odiCej/JCPRd0l+l0TzyFVYQf/H
 bIHCIJJj
 Amn41NWuvVwrMINSRaQgBkGdiyiCptyHKLLwnYfVt1JXxfgkFWZc84dGFwT/nPdPABqXuXtDNbzYOMjnUdq35ygeF6GvVcs1Cu9lK1KQ5U2TSg/a4w7k6PC07G9v5VrnLevrN6VSFClXi69K7MqUmLGTNlAAP7CbofgJJKua8K/JW9gHLOpJ+dS10cLjj4qnabWJWnT0LPVtwHVeVn0aOrMDBMFgfK17Qih7MWZTls/xYHbx86dtJUTZ5a3VoHKiBAfsaTSOQ21OleqCDlFri0jqHAzxsadxjyIJXB+BTLGyftSPAf8Gj93ZOxrzZidNYel30bRRK2kE+vnmV7ZGABbXwfiO7pT6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 08:59, David Hildenbrand (Arm) wrote:
> On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
>> Introduce vma[_flags]_is_persistent() for the purposes of identifying
>> mappings that are persistent in the sense that bytes to the mapping stay
>> there, and bytes read from the mapping are the same unless changed by
>> actions taken by userland.
> 
> That's extremely confusing, sorry. We have to find a better name for that.
> 
> Is this really all about user pages (pagecache, anon) that we would find through
> the rmap?
> 

It's also about droppable mappings AFAIKs. How many more users will we have for
that function?

If it's "no others" then please don't add a helper function with misleading
names for it and just keep the special "dumpable" check in the new form in
madvise_vma_behavior().

-- 
Cheers,

David

