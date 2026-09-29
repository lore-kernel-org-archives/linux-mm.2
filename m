Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3E1BCA5FAC
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 11:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5376B0088; Tue, 29 Sep 2026 07:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66F9E6B008A; Tue, 29 Sep 2026 07:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53C906B008C; Tue, 29 Sep 2026 07:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5076B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:12:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A78A3A048E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:12:20 +0000 (UTC)
X-FDA: 85266536040.25.7B97041
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 15E83C000B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:12:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BV88qyIr;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790680339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OtKLzSVjKPRZshz2AefRxKxu1viQOmmc/Cl7ueutcPM=;
	b=tIZnaWFnLsK/FH11Slqj9uR11YUjRzQqYqPZ8cJsxlIHipC2gF0upSCjTjB8ZS63bPdN2Y
	ZaM8vUGnqfd+fBTc/ilpttlYOX98LQcR0pn0kR9VBqV0NmlBl7GKH9RCG4RTdMej2buoQh
	6/i19NGrRd0ssjg1+qBqUWUd9ToYTrA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BV88qyIr;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790680339;
	b=vp5GFEJDklr7UKyQArpxpIDgeetqd+DKUb0QPwHsK+mAVYJW1qXYsu/7DKr8Q97VuMFu3A
	WU83UAoW/AGgckpFDpZ3hzrJXa+8Fbyw9GLzdKYKdQd7vGJgzXyU+6EjzFwWsekwHXjg+G
	f7EvOQp2LfuQ0+fMlsQYUIgpMpZVJAE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 289D460008;
	Tue, 29 Sep 2026 11:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0241F000FF;
	Tue, 29 Sep 2026 11:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790680337;
	bh=OtKLzSVjKPRZshz2AefRxKxu1viQOmmc/Cl7ueutcPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BV88qyIrUdemgCTc7/Nc1a5HencKOCtUUeQF/4yuDOy+E9lTQJTXaqexwwEa+KENc
	 IHnvm++5OlPA7wQp78zpEfhb13SxfqeGtE8x0Tr4lJuOODJoVnitMUth71d8TyI8FL
	 qF9QPvRMYORpyuleZ9gBZ9acR1tOtNY6T0V0l2wM3DCoWKv97l9wnJfOLBz3QVXNcf
	 zuCeflofP0AyEaKrVdS0ufY5NE8KthdOm5n6A3n0TzkRrDI50QFp3WVuF5iK4VLw/2
	 /u7yd0WDEAicCMf2zjaEZ1eoZuTrAugZMtLq/8C7LYHaANp8hLzVqESeam3NBy6sPL
	 fqbmJ7n5T9GCg==
Date: Tue, 29 Sep 2026 12:11:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
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
Subject: Re: [PATCH v3 08/40] mm: add mmap action for discontiguous kernel
 page mapping
Message-ID: <aruboNztyLjlrXiG@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-8-4583d8a23bca@kernel.org>
 <CAJuCfpEawD2NUO9EoqKnR6YR59XMdYrtUrj8KEwJVwO8AOk8Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEawD2NUO9EoqKnR6YR59XMdYrtUrj8KEwJVwO8AOk8Lw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 15E83C000B
X-Stat-Signature: 369d9w3cbkyzezpk88f64ujt7st9wms5
X-HE-Tag: 1790680338-178054
X-HE-Meta: U2FsdGVkX18oLjTEVqogprMoissFSS0igw7TN8QnfjZa4PJmPiS5Ad7+scDY4kDuXnwn2A1qsXV3Ws/tGYaOvpr4crGytx0/YZQ02hK7LZXe+tjXJcTVEzf2wkz3BbmVcfITyPB0XP99yMSbNjxIsixS4CBifZg2sCyqIRrpfHfkYmEZ2cQSBDicbzhRLosIw69XKP/HkJOVXYtCBClAQrq35GRr6iz5eOTkKxiJwoCAYK2KWo61S7MJHv5pOgp1A4ribjb97x93C7tBaXJk08ojGjGFFEOswDw9w5P3e5qOXfTQD5zhhgXKTKoa0uUifo5A78skauAmhYqMqC8LDU1uJ1lkF45blO/WEWVOji0uMJDymQrg25D+oqVOrpuDf2hoJ8aCioJFg9ecBAuMyu1rE65BIAI1sg4eC6P935wPeAaUp1Bv7oMk8X2Wjl4laLN4mY9Jp1dkoALPTwjfEccxUbl+wLnm/Z6Yl/Hyp1Egz91bNh2zFxH7LJZj6pJYU0DnyXbHCQwmiSTHaVZcue+Mx82k1nff1g7FBpROY9nBeiZfDnmg2xPscQmKHC3gIfr707cf/byM2EojvZsMYdYJ0it0YudhjfslYvW3+a7DcHGggCf2lu4GlYMtreo5UlrKY3GAVZruG3NXyJKaHTYwPHO5yBSixdepMAI2qZ73gxGMNWONMdxa3jYfm13jpw7lPHvh/wygPtQ3E7RL8zS2fGuYPrppRbnnvOBmik137SF/RPjzmAdF6j/Pig3lcSjk/8Zs6CGJtOv+7rEbH+sCHn/TeykZSbJqqXxVgVIQenInexrOiCXp+emUxY/3hiiuMJlj/GAQYhh9JJdVmrrFsdOyq75qXk7/K+21482+rlJm8mfAHB8N2TfdFGiJXaXh7zucz84CUFVWuhcmWZx/Ulk5NZ6J/kY6RA/lPY6rXV5YMYXqMSOrnITBrNpB1p10fmtM70gp4JrBUm0
 u3LHBbfG
 DXcPnjEwsXZxt1i8iaZcapD9v8ISk6L9NU/Ate3/YqRF2dsDWsweKa/lwFXtbae+6FdDtjmu0iEoo09L7APvRniZe/D+Z7Unl12SduVIQOtZwbWeFxs7Jrah6Hkwt3k5U0G61kOh0iiDk1mu0oH00O1bUvhkHEGg4VbVUQ6bBP3RbeSCUPKmjmZzcTxaHcz78TeWjLHm916cw1RHWKBZ4v5OcE49kp5qBq+ZdK1m/bJi3urpUVoF2kR+zDV3SKccfJqiEfMYtURT6q6vAZHBMao7AwNxkMRUPIuoedy8QE1tSsc11HGB2dSaIsGduKCOd8FvfkYxN0tj0icqcv4ouYZp1G8PSHqj2fRhrGjrRGglMCC66bdraVqMu1fXHRSvIlWLbozGzsh6yAHrwwPDnL3B/PdSoxLBpkFI0BShS2ego4P2rgjYBRFBuDtqTcVzdJvuMWDC/PdQrhBjpt6pcbqxTUA0fPr7y5K193Tz6GnCdhluAqW6hs96dstPTs1rK85SdE4k6srCPEaG/cLBt3tQUeXJqWseQCgCl+mQaQwJBgQioIR0Y0uNSV533k/n5YCT0RYHLmzjHjKM7jXGwEIoKgfIWLmqV8zvfX6R3Seo7WXtWo5Ck43J2ia46GE1kdv8nxP9MsInmJcTuMD/5w64SO9v6/LlCpxR0gwJGKcNOtVeDLLHdwCqR2tKrY+UGRvJSUDy5Iv8gt9yCrPx3usoNqAsrUvCImERfpSbPm5TNXicLQwOTOYvlP3lAgmGUi5XwsWR6P4ETmFLkaWnGftxc52RAa9W2Mz8TzUSNMMDbAnH23iVyR68TC4I1hLZeXfK7taOT3uhQzmmDbVdiv7nMtC2TfNA3Fqu5QByLKMz5IyqZqihO9UfVAsJJq88TvYqWlZIL/xT01dF0CoRInwri+dMqLhXoThgKb2knNSd1ANFUXLjVzKSUJUuaQi5HOvsxp4wcjFgQTBms5rrNc/CQ6fvW
 garJjyQC
 C7FDX3YXpF14rI3EimnNwaK1JCZ2lDFLFngS6JPO+h+d9FGymkSjJtYr7E+5lI9CwFZpzLNGtKF1sDa9o+qseRpLrZq8uzums8QD3UAixwEQhXuGVmd/WXJeePg5A9XUl1DHZtY6OTGK3efgrtFKlg6ePWOGhkNFNTRMqnLRMtd5vMSXfRxiP3+YSywLDepg5EmLf9lPobUTmauRMwKxcTidUnod6Qkg16pxdg3GxnAATrOl3ER+tEjvFjrabic7nG+I0IjPbqUQ+KKNvbb8BHP2zGPt3vEXZpu1c9YVmNwkED/L9GOXv2N5049e+W/c5/F8uY0NIxOxxHO2XDHeJdvnc3bbQPf1OE/5p6BddN9l0CoewuZ59CG+BQlCDf8fmReHYRJohpp+mNFnaPkdBMsHLOh7i9Ag1QpCEyG51tbGuN9RX9wWcVMlaCeEsMCcQ2fbv0E/5ktUJp7TW9cKMt+TcKC+MMwADzIaI7dRiTDDuU8bc82Rwa+jQicxQ1OzsylxlF5LZc5sTqM5Vt4F4iopYRGb3Zc5/M93IjqcWKvU2qFRtMsoXb3Ga2BHuZ8IHWpvXLrJkF0NnoyNgOGJpDjtZikowTv/p7lQecCVOtxjsQxVMqUQZ11YJHTONiUY4C+nv94HiMNe/wJsUFGy0jPCV+wDSENYMim9zDexix1IQMWew6QiMBXXvGgxdtwyiB+oanEIif1r5ntkgsaRCm3b7FyIfJz3i9G0pAxHVeJALfvrq9/TBhWkWH4MT+UEmW2MYTm9b5YhKVmxfMnzWptqfgLswjAEusy0DF9TxUFAUjvu57K+xFJcKYnMS5FZFsWGQlBzPXcuTJn48cDiHxvw69l0MvBes3rCQk+4cuBz+w5vxZMWoLWsYqyrjiJL+JNcVIafIbvnqQ7Ff2zPfGOF+IdCpN5HDBqMqvqHQheNqmFe7n5La6lP86sdneBSSKLkoImdVeU7XHmEQi7isiX1Izp2Z
 vdwV+VDR
 e/eWs5EBUAJ2eASjOR6uJin1ro/6DKVwWLTkiQL6lKee17YeL4rdyUPqqHmdtBM4LeV1rN61BC1b1yC0ugoDC2FEgLB91pe/1YV+AyTmdnJXp9H4D1sY6BpZYB0eXAKf5+ix2UEebvBy9kBeJbcR5fauWcC3t3i12rsfi7bFJOCz1WcI5MfFLfsqjDkdZnczmVcbl3gGjY6QOfN+tGdZ6vM5Y3qcxAKtTfn9/XgNYDzrJySood925G5TrAkE0k2t5cStLEV79q6md9Lp4C0BH8GU5oycOafRC3QBlxh5QyEBZVauQMkthKapsgvq3uWZsYChnNnGYm6iZp4ibBC0EVeUkdJAl+wkWbt4HJ2MpXfIPhatWOvWnJbK4m8tjiSJorAfcxeb3Aex8/twQwi37Sw9jyy6aL8iVn06VjrGWDJG8KLSuyII6/wdCzQTID7ofV2LBJAhmSiMyNHYOzXWS6WWCBXj2UGmdEEdk9LGGy9FoABHYqesXCll6+gSf7KIXYRjp7LO3Vj96dCD50VM9FAepRIqye7zKj0goUvaPWU/APUHsrAUNPygXDSZMyy/FoAsL8SiQhnfZ0QCdCW2twxU2DzOda1CxqHrHmvSeZuXopvIorl3cvUcBi51uSz9Pfx3mp9HLkoU3onX48PnVlMxN0AS8u26jhKaeA276HiS1OcYBDsKBStQ46lYfzb4y8RR8pZCU9WbclCF0hoei+dDxqP8bYWOkWm5GoO+l/o0ioVv14KzY7Lh9NL2vkrCawMCJ68iYfQv8HgaeAxrek0uq1DZzQB6W3lsLf9+oSLMITr6gXcVExjY8l8Fsj5zzycCpzx7Ei4i/FT0GABLKTcbXvOMScqR0snt52TMmgOyzLTd6qx5L7OCSM8OR8krhzHWhTtVD2SXInmKech286sCFaOQM1y1ZCOGjh4hqBI3GcUOylSnXj4zxZKBKTgzc98X4M7H8KdZb6pii1QVUguzE3Q9b
 XqPNyaX3
 vZWB6mFKLlK7EVC5y41mG1BfMMd93QvdTTzdP+S7+d4vizSGfmeAjNPqLijSu8lC2V/c9lHIFA+meJD5W7R/hOYtyzv0jGdwq9l06OTOyOPFWKc6cj8l/KoYcdeG3JMciw7WKufCnC1yP2WLiOcuvf2Fx6/JjJ9ZYNvazpKuSua1+mi4ZGLWwUlDXFV83aie47txU/wKHQJxgRp/jU6XP6Lkb7iGtvwRfIzxAWeGU9g1+j3xpNDDUIsybg8ZNQl1nSqbY2CRdB2Gp8Wg2KNuMUuDmpKnzh2MGfB+ZhS0khWQE3ALRme6q8Yc9X44nUuYQ3gJtWR/i1YKxR2fUhlq5l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 27, 2026 at 02:44:18PM -0700, Suren Baghdasaryan wrote:
> On Thu, Sep 17, 2026 at 9:27 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:

> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index a1f2d375cf7d..2a92193ac6a5 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h

> > +static inline void
> > +discontig_kernel_map_page_range(struct discontig_kernel_page_state *state,
> > +                               struct page **page_arr, unsigned long nr_pages)
> > +{
> > +       state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE;
> > +       state->__page_arr = page_arr;
> > +       state->__nr_pages = nr_pages;
>
> Shouldn't we cap state->__nr_pages at state->nr_pages_remain like you
> do in discontig_kernel_map_page()?

Ack yeah good point, will do!

--
Cheers, Lorenzo

