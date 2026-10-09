Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFEBACA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3A786B009E; Fri,  9 Oct 2026 14:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13166B00BA; Fri,  9 Oct 2026 14:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01906B00BB; Fri,  9 Oct 2026 14:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97B1B6B009E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:12:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 281D7803BD
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:12:41 +0000 (UTC)
X-FDA: 85303883322.21.E1E9529
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 603C91C0007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:12:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=COJSigfr;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569559;
	b=roDbZlD/hwtoIbk1Z2jtfv3ND/b8ofE8+fGmy+CNvtuNkIuxmXab3alYUx5PMfsQJhu46A
	cq5QBzyxBlPkx6ToHM2Ae96+ggwLFyX7nNXbQBWoY1bF9M3hNnfxb4U46r4g5ehHOyYutN
	BbHhvUKxjwUbLp4H8wb2KAxh5b/+sg0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=COJSigfr;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+i+DaAt9JzfHEIOjru3Rvly0KtZKnnSUfWMgzuFSoU=;
	b=mMKxCgBfCWrjQgNJn9iO4PwAEOhpjw/J6YU0DVHVDT0Dj9cwGzOzoSvNkJhsj4klFH0OCq
	I2X/4FSFegrIKHRudwgVJi2kcvjDfGHcGZeRb10FLWkLw+mqDfLvbV125hrkytccqm1Bfp
	BE3RipAp6YrGGH7MJe0A96OceXS2s4k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9549C4362D;
	Fri,  9 Oct 2026 18:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E866D1F000FF;
	Fri,  9 Oct 2026 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569558;
	bh=D+i+DaAt9JzfHEIOjru3Rvly0KtZKnnSUfWMgzuFSoU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=COJSigfrmkGOVygi8rzPvz8GIJpy+aXVqzrmB838y4blfnkik4ML8EGNUielsnlxB
	 WUhk8r2Q16yQv8hEGRO+9qtEGQglCP4j+ObQbJWB99wDWhgk3LXMCCz/SyfptV443w
	 eYYWasRAXOS8c98QfoBURMhkkqr2qPRNczy86+L0pLgtJ4lFgfyk8zc/JL/Wl4LtlN
	 J5qLpgF49X6F9iCSlwol4VTbGik/wc7+ShiflRa9bhhvjdmjGSS0yrGe1bndT4+9km
	 AWiX6oXNqC+dMUP0Wa1JqEjYZRS7NGrHzYak/Ph8xZQxuyygfwYCfzQFtBzT+fhr7z
	 mWkXTgwigKPWw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:17 +0100
Subject: [PATCH v5 23/38] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-23-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8341; i=ljs@kernel.org;
 h=from:subject:message-id; bh=DEwsIsHyrU8dUc7I0Q85dMjaxlNnAODqsthg7xucj5U=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6szZ+M1/9qcA/kKT9qKFAudkliw6VWH3/czybdpWj
 0xvywUad5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiq3QZGZ5pllj+9pklqLt+
 R4NblYDMhqQo3sv12RNr5yx74X9Ivp2R4dUVp/i1GlLXE6srZlVfqjXQLclJ2rf6pLqQYnHCjVc
 f+QA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: f3bonrp3dz9o9wyma3pmh6jehb4bhu4d
X-Rspamd-Queue-Id: 603C91C0007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791569559-943165
X-HE-Meta: U2FsdGVkX1/5antU+CtEIraKfZrE4nUa81cw5C3ZCHAcWx9DPsXkz7fYrbikdXYWuJqTxKLs5oPweiXV3U/kDrKdqLKne8+u9oLMDNN7WGIUyV9gTGRxZfmQLUZD+/DEBlf8Wrz8McVCc1ZnXhVB66YD9SZVFLRqPq7Z1vdqPgCKXtCKu+IIIRXlLf3fXF51f/0BkgTgzSOnjrFKjQkk166gGNvTtHd9cDks1N70uBnowIJwHYji9vipe0dmJF/pAIVCKcwskmiDJXaK0/+ZHSXdCU9mhIDvkyf1lx/4nhGuwGY+EWwcd8Cm/2ecnZ+QXqxtFIwwcRR5OoYjabN+1gwY1pZfrwEeSfN683BEqgD1mqeH54CIbrlH+WfY5zUw47TPo5bjzwdnQoDhNT/TKrn2ydNuxdzeYjIUyqwNlBZLSV3y4FSOMU2KplglL0JyyDjtl+7VmbWntELT+43UCBF7r1OTAlfSBqltvwDW4LcqpvvQtAW8YLbeKY3y5xv+kCPdz1ooDF2hrudZGIeyCODPz0yXJJnymnpDiSO/6aoruTXJ5sXBHq8kW8qvzcGnRpHrjjDFDqGCp1QndCVhfhD6N37Mw4JU5ZKOVeLdhdqPLl3QkJlkOloYmf1Oj9ojT33fm09j9HaUnW3SJ9QAAA27FNzYZztAOMq3aL3/y/EcFQeHdcPkp9cdQ/SgdK39XkmaA94Oka6HM6MOT31yRITPYQWcKmwCeq1saekTpcTiDLt03672p5e4tVrOZu+02yuRSRP1uqHG30Sd0WD4z07exfkJJ5RnZxLbV7jhxAszDqVsFvxzWexXPYWuFczEV6LiBEpXhuBMXyg03GqOBCrljFepe6x/nT/pEF1MEMHjhjkPuW9/3OP+LRIvL+hEBfoSfAuWxwnRKYBZj4SsxmBqZ3VVfoJ+z85itpR2LR6clI22dTWK1CHA+MezWhIEnHgSt9EKqG13wDp5HbQ
 4F9FzkPN
 ULbpxi02i0JKwi3lcNLhHfPYVBReBuiENGe1fTmFzTlrYs4arOEPfZS6MEx2kT7VOs/Ogh/Gzyt76GOxOlxVflFBU8h5ME1eWahOzZF7tU+4VEMXMrvXv9XRSZKIBiP1Ow876impHNayaVSqLKyfNMhtV8ndvZV10Za2RaforDkcTCFCt9HycgiHkS+I9XeoWahMslsKjk+lQi2FJ8JGpLinPNsaD8NW+aZvCPQRBRCSOXZGyXM7VIDrFBlRcZCOwxhD5H+xMOpZYJhRkkp9DA+CaVCqWNwAnT2rV716L0htiWon9dC8skilGTnbyNrv+2+FWjwSKw1aOSkDBijHT9mRTe2LQ1tOobblYD0O9cQTjHI2V87IAEEJsZDiHoecXmHBgRQsXrpwYvAq401wUJwdE/vnCG6yHuhhLApS2S9n4Z6stD7Bn0i8+nHfmsjDFZY4iGk1VRdLjlEYXOTyFdlwv7rGZ2XXVgAqZGYy/SzOgCvJZl9lks8ND9kh114X/H4YILsL2KrTL16dGGo/rojUQo+e6s4XuJtHSWg6bnNfkt/gEBlGArhx0wl0SUY5/JlZzSfEvtIDpFhV6FoJNxgGFu+f3I/IpVPySfhfeVEfo5d1LkkNG3OF6jgsZqO8ACPktRZ4kaawCnJ7nlNwP61alYIgpRqXQVXBQivos7t+4Gsutie1hGYmov5L+3Xcef0pb2rtjSk3Rll0EmH3LIdCrYmbdyFlWonaFnnFUc7PmnwUVypNeXWNdJPGY//J6aslfKDY8p2zKEqoH7f2pYXv+pKIAocQUo2UsDErRzuDx4FDhiFwMFYJk8Qku0psVgrSH8fZeHBdFxQvTqvMp9BPDpXHb5CE829qVPnQ+70VN/AOvGbOHKor9J8XVV1PY7tgGKuJMTVJXh/kRCGsmEDHCyIIXRabm8vlZV6yq8XgpOuWvI+zMtRtMC9b3dHGCJAUYN+zJIbRZlflJmjBCmOA9YWsi
 B+OC2U/2
 iLkQl94kRwG/ZCrp4+80vP/HcRHB/DQ5obHL5DzueIUA7VXPWjVn9MV6e26AGEqpNiz9Fru2GGMkIRo1DfnuRzTbJ+1YYIEI5/nTyfQdvmel3MmEzQjVRcMS63n256g9YGI0PPj5TFlI+Qo8m7q6m6QeJ051NA3/2Njs2cUhyHnwLmgc1FQ2j5pphN7FEobTzG3c1b9Rkh72NswzlD6Dv6Esi7LrEB9Cx6lHdP8eCFiFG+Q3p8ISGB9UhOXqrf2zfoMUJ4kGLF62LYgvdehtTgwhsLz3r2hBrKjt7C6Qps2OUlTcX3rOusnBVSylmSiXz7V+P1hNc6Hr5rC+qBLfWcCWhUCY6M7A4WsuCZExfJmG++vLMTvNTlXo7BZuhBJewI9fLl3c/XHWwu+7wsxUny3oi8vUMuqTad0aGp2QSlgZ/7Uus9fswTar6eBUZEr1KpBdM1e21NSXFbscmGbm5VCKTaqe0hHuou/zRIOxhO0Kn6fu64NtY6AGF3u1G0TN+gATbJD/+cMw4WOg3rYEIg1DjYuUQZOLSHfNL1g/qaJDb86+caXroHF4p1OSMmF5Sg6h8UC7541E12RJ+wp0SAMcn3cL1trLvKyovWjM4GCrdG5Ejd/wNSl+G/9HrEVwcguWm8YJHhgEiIuY6GYTFxKkPye/wn28rAETYdERZ6VP+aS7cxM+ouAyTjYeFqZ5Lhe/qqxcoM+d9qvqiSFCl1ZZzf2O1E/o6UdfF7r8DY2w5iC4bI6TWJjYMrLz4zTwxiP9cNOHJjc6Hcc2DWRcxS+I388LAsI/sQ6zxFA5NYUEtoIXt5ChLpzxr7B6Czt57i3qWk6D+RvSUOqAAEFiiFSi7KqZ+Y1jQyPIM1qITf+eJussAhC3HY46lJZm3Njo+JQT9oq2n5I1hslxaLPLMt9ScOSccCBLsWCR4L1FyEM5qUFpFibDO2Xl9fRjSiKr7TVMzM0WidTc9nptq5LMFphS0t67Y
 qeeZNknq
 FywP7m9N7eYHL+utPQUs6UHby6qNg55tLMH9AQ0gIpMCSUiERgq6HUIHBZeanBI+15MNTh9LARywg8/iB7Zc/z+Rn82Ys9uzbeZqls488X/ZDQVCF/cx+AZLRQDgPXTT0nxobdrO/AvFtqpRDrFoFf1KCHoHHYBFxxDN7ltLBc3hgaZFqFcjY063VorxdBvLxCyWm7VVLgNn4ojxNGT//9v/N9CyVZtkP9FPxWDwDpdSlxAD8cklBYnngWUUwYPsAZfoHda/RocY5Gu2iDaRrIPGIejXoZE6n5dGGif85uxtHI9SN2ylZEqw/eEJI9YXdqLBa+SiYjUzJmME5lIFmwdvg7eUSZTN4Pw8Xn/iCErBloJgW4/6yJf4VMaBOyjmKLM64j31v6xFH3nyVVsTvoByVyLH6Mrbd0VN7TGBtEK6Ybosbr4GVP8cSeU9Pi35sv1vVl16Yyg2MDOU7PxxirgejstyJO9bhciLOm0TtzwfYSnjp/9D5FGvoV1clk77j66yqGV+rasZCkBZjjcmXHlpofZJWjWn+qxjFPRCbYUq6f7YKz4SEaxNhMAGu7tVToRVXkRdlnv0xEPwEj4ZvDW2INacMVWnk90shmxJYZUMMShNGPh2qSIAiVB+V26s9nqVZs0AtAFBZOu3UZ31Mrpkw08W+mbp+UkMJN23HpU1dyR/on3Y59nEeiq2gvxzsFcV+tTzHwYWguv+OwX/HSe2gu4ggRU6q+blJUG4axNXcwCoATGXSj6ebdCHbWkm976VDpA30AxgcfkYhgrIYB1aSQfzOaCcaMlMV4+HN5HsZSKOkoMFW1RCJ3wOfOvJKG6bnjqZ0Vzw6paFvAIaWOf7rArIp6XnOcx/Hn8c0MRUY9gTFBbIRztnlCYbhZ3t7UThBE/kA8CQXM4t+vUXlEpRh8D5o/NywQPMrT3UP7cLPCo6GQYAhgbWSXMtokqFOIR7Zu6tKNTOE5kZ7Z5bygmLuKrXU
 qERYxGIN
 D3YnOZQ4Lq61iOIVFxv6vnz6JaqlGCirT8hSY154PbClL9zcCqxe7DRgPcaSshBXJfNTIyXCjShG7rSqqfsoGwgQX+C+j0nyZQKCeDKj8WH6axcK9h8yBiRXVyPaUYQ8WskMfnA+5NXXxMN8yFZgu/Y8tVXktNF3UI489s6cDhMNDJa0NiMMoVRoQl3L5whgN2r/bnpUd6rpWvWlm/1c/eP/sSiKDO8UN72neO8x46SFukm11O7PPkNy1F0DAHKwG1kTO5GIUKpT7fsQH3Ex7FfyWC0P2xXfhn+onwT82hDEh3aeE1h+qMPcCuWwhiP+/Fabjkgi7FanKIig1jwVygtIDQW+W6G2yAzNQApFyVATTAlUuk8dtRE/taLlMJGlOcpOQVgvLPcy0k2K+W3ztn6LOxdsto3GXCpHPbHTKgeAcAEqfNqewUvrKyTDiLYUgVOdW0OQRJPm7PZlqdgCqLzla1ngf2NLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When performing mlock() or munlock() otherwise normal VMAs have VMA_IO_BIT
solely to fix a race with migration which might otherwise double-count
mlock VMAs.

This is unnecessary - at the point of applying folio mlock state, whether
setting or clearing PG_mlocked, we know whether or not we are locking.

Solve this in two ways - thread a boolean through the page table walk
indicating whether a lock or unlock is being performed, and run a locking
walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.

This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always implies
VMA_LOCKED_BIT. These are also always cleared together.

Then, update folio_add_lru_vma() and mlock_folio() to check only for
VMA_LOCKED_BIT, and update try_to_unmap_one() to check for VMA_LOCKED_MASK
instead.

Also remove the useless invocation of allow_mlock_munlock() which simply
returns true if unlocking and instead rename it to allow_mlock() and only
call it when locking.

With the other mlock abuse of VMA_IO_BIT addressed, update
mlock_vma_folio() and folio_add_lru_vma() to simply test for
VMA_LOCKED_BIT.

The munlock_vma_folio() function tests VMA_LOCKED_MASK instead, as an
unmap racing with the locking walk must still munlock folios the walk has
already counted.

Additionally, in order to ensure a racing unmap/migration releases the
reference munlock_folio() took (whose put was batched), check
VMA_LOCKED_MASK before calling mlock_drain_local() in try_to_unmap_one()
and try_to_migrate_one().

While here, also replace some deprecated VMA flag predicates.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/folio.c    |  2 +-
 mm/internal.h | 10 +++++++---
 mm/mlock.c    | 51 +++++++++++++++++++--------------------------------
 mm/rmap.c     |  8 +++++---
 4 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 47a437e0f7fd..35e242b48870 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -505,7 +505,7 @@ void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma)
 {
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_new_folio(folio);
 	else
 		folio_add_lru(folio);
diff --git a/mm/internal.h b/mm/internal.h
index 4ae08fedffff..ea8fa94ebe1b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -970,8 +970,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/* The VM_IO check prevents migration from double-counting during mlock. */
-	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_folio(folio);
 }
 
@@ -988,7 +987,12 @@ static inline void munlock_vma_folio(struct folio *folio,
 	 * always munlock the folio and page reclaim will correct it
 	 * if it's wrong.
 	 */
-	if (unlikely(vma->vm_flags & VM_LOCKED))
+	/*
+	 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+	 * mlock_vma_pages_range(). An unmap racing with the walk must still
+	 * munlock folios the walk has already counted.
+	 */
+	if (unlikely(vma_test_any_mask(vma, VMA_LOCKED_MASK)))
 		munlock_folio(folio);
 }
 
diff --git a/mm/mlock.c b/mm/mlock.c
index 39215a3eab1f..4235a1518fc9 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -316,22 +316,10 @@ static inline unsigned int folio_mlock_step(struct folio *folio,
 	return folio_pte_batch(folio, pte, ptent, count);
 }
 
-static inline bool allow_mlock_munlock(struct folio *folio,
+static inline bool allow_mlock(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, unsigned int step)
 {
-	/*
-	 * For unlock, allow munlock large folio which is partially
-	 * mapped to VMA. As it's possible that large folio is
-	 * mlocked and VMA is split later.
-	 *
-	 * During memory pressure, such kind of large folio can
-	 * be split. And the pages are not in VM_LOCKed VMA
-	 * can be reclaimed.
-	 */
-	if (!vma_test(vma, VMA_LOCKED_BIT))
-		return true;
-
 	/* folio_within_range() cannot take KSM, but any small folio is OK */
 	if (!folio_test_large(folio))
 		return true;
@@ -352,6 +340,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 
 {
 	struct vm_area_struct *vma = walk->vma;
+	const bool lock = walk->private;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte;
 	pte_t ptent;
@@ -368,7 +357,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 		folio = pmd_folio(*pmd);
 		if (folio_is_zone_device(folio))
 			goto out;
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -390,10 +379,10 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 			continue;
 
 		step = folio_mlock_step(folio, pte, addr, end);
-		if (!allow_mlock_munlock(folio, vma, start, end, step))
+		if (lock && !allow_mlock(folio, vma, start, end, step))
 			goto next_entry;
 
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -428,31 +417,29 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 		.pmd_entry = mlock_pte_range,
 		.walk_lock = PGWALK_WRLOCK_VERIFY,
 	};
+	const bool lock = vma_flags_test(new_vma_flags, VMA_LOCKED_BIT);
+	vma_flags_t walk_flags = *new_vma_flags;
 
 	/*
-	 * There is a slight chance that concurrent page migration,
-	 * or page reclaim finding a page of this now-VMA_LOCKED_BIT vma,
-	 * will call mlock_vma_folio() and raise page's mlock_count:
-	 * double counting, leaving the page unevictable indefinitely.
-	 * Communicate this danger to mlock_vma_folio() with VMA_IO_BIT,
-	 * which is a VMA_SPECIAL_FLAGS flag not allowed on VMA_LOCKED_BIT vmas.
-	 * mmap_lock is held in write mode here, so this weird
-	 * combination should not be visible to other mmap_lock users;
-	 * but WRITE_ONCE so rmap walkers must see VMA_IO_BIT if VMA_LOCKED_BIT.
+	 * LOCKONFAULT without LOCKED never otherwise occurs: it marks a walk in
+	 * progress so that rmap-side callers, which test VMA_LOCKED_BIT, do not
+	 * count folios, while try_to_unmap_one(), which tests VMA_LOCKED_MASK,
+	 * still refuses to unmap them.
 	 */
-	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
-		vma_flags_set(new_vma_flags, VMA_IO_BIT);
+	if (lock) {
+		vma_flags_clear(&walk_flags, VMA_LOCKED_BIT);
+		vma_flags_set(&walk_flags, VMA_LOCKONFAULT_BIT);
+	}
+
 	vma_start_write(vma);
-	vma_flags_reset_once(vma, new_vma_flags);
+	vma_flags_reset_once(vma, &walk_flags);
 
 	lru_add_drain();
-	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
+	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);
 	lru_add_drain();
 
-	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
-		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
+	if (lock)
 		vma_flags_reset_once(vma, new_vma_flags);
-	}
 }
 
 /*
diff --git a/mm/rmap.c b/mm/rmap.c
index 5332c52909be..b4a4b3929044 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2239,9 +2239,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
+		 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+		 * mlock_vma_pages_range().
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
-		    (vma->vm_flags & VM_LOCKED)) {
+		    vma_test_any_mask(vma, VMA_LOCKED_MASK)) {
 			ptes++;
 
 			/*
@@ -2395,7 +2397,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 finish_unmap:
 		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
-		if (vma->vm_flags & VM_LOCKED)
+		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
 			mlock_drain_local();
 		folio_put_refs(folio, nr_pages);
 
@@ -2770,7 +2772,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			hugetlb_remove_rmap(folio);
 		else
 			folio_remove_rmap_pte(folio, subpage, vma);
-		if (vma->vm_flags & VM_LOCKED)
+		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
 			mlock_drain_local();
 		folio_put(folio);
 	}

-- 
2.55.0


