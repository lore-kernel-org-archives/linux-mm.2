Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7843C88E77
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1DD6B00A5; Mon, 14 Sep 2026 11:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA2356B00D4; Mon, 14 Sep 2026 11:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70896B00D5; Mon, 14 Sep 2026 11:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6D26B00A5
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:13:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCFA3140193
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:13:46 +0000 (UTC)
X-FDA: 85212712452.21.6BB3DEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0CD2340004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:13:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OCxKcU1+;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLYk3o3B0/wt5kKG7m+ibDGyo2yi3t47XmKybZiJ1Rs=;
	b=nLgISFKS/mcBYMpasHBY2DpxfNTfiUq6kuCfWG5UUCpmYvyVU6tc50WMxjBeK4NHH5EL4B
	5z5dtOfEzwxt0OcBYOrC+IeqmMV4IG3A07Nfuy9zJYZdba9uGyQL7rnaW/Yvz9GiO5EcPW
	Imi1RqDmqCe5Fn7NuH+LKJGtyngE7Zc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OCxKcU1+;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398825;
	b=0I9pqrTQL4heb97cD+p8/CNGkBA5ZV0UA0bWe+NzouMPym4eNrISXtuh1U/5cwIQwJhERP
	YCjD6JAyrR4DcuvHH7jkxDp/W9IeGn7IbVmKOHFA+XHqMTuANY/dKsqq+JdbsjkF7Je611
	oI9txlHZ6Hou1FQpQmNT2fhyElIwjGw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 968CC601FB;
	Mon, 14 Sep 2026 15:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA611F000FF;
	Mon, 14 Sep 2026 15:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398824;
	bh=lLYk3o3B0/wt5kKG7m+ibDGyo2yi3t47XmKybZiJ1Rs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OCxKcU1+iK7/VpwiCjQsfNTyLHXprYAfmjBTJYjRXOqSDbjChS9a8UNWWai1dvAvc
	 LIfatKmb7N324OjNPygUEBox7bMevCjzeSSuDsi2zo2gQV1Ch4rMdfyF2YwhWGS3lr
	 mpzUli8fzWIJhtFi5+YHpAYOWyN/jkakLNHYxhkIn0hGO8FueA/PbeqVLU3sNzh8kG
	 tasN7UGKUrwoUktzW8P94NZIU1a77PHfaA1s+GCbww/WCsxnkXLSH7cR3ehb48gVPf
	 Fubs33Mx1iVz8PhSbmXgoSeIcWefLZFQUci+t3J8RTXMiJP+VHzSPoJTGPDnXZiwd8
	 +nOVg4gC8GBtA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:51 +0100
Subject: [PATCH v2 31/40] mm/vma: introduce vma[_flags]_is_persistent()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-31-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3843; i=ljs@kernel.org;
 h=from:subject:message-id; bh=g+DP477oZGptEtdcgQ46pNPCZKGp7Qm9RMjCOcTExak=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG/2/cAr06Se1Z6oeyNo1uIpW3/LZP3oLp+5ibet/
 1rNzn+fO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRwm6G/4mn72lnsnPnfDI1
 f+xlZ1mTPzf8Q97GdUwHP9dFzno7I4Phnx1H56oJh/InyuxULtwcU5l59dZs6bsXT/Uu3mC+3KF
 vBicA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0CD2340004
X-Stat-Signature: 8qp3xkxjh1xrcz7aohsp8iurhozq915r
X-Rspam-User: 
X-HE-Tag: 1789398824-299567
X-HE-Meta: U2FsdGVkX19w240dhNT5RsRsm94f42UMH+uCdOlxRtebJxCjHu8i9WWY+G06dvxjOl8o+S94oMwfLpA6bmRoi5t6RndHH9ncRIt4qZFH7AS+pyvdgJ4XhXElRRYs2BODBE3TQXL2kXEJhZBbMD2/6Bma+jZ8kj3tVQYo0FrmQjIf4f2xyh2fcdl5vSXcBW0l1eW9vUudNFORV9+aklDWqlK+oRXjlVG/y7obUeIWv+83OrDetoPv8k89B+4O0t6bR2iZIXPPzKR34GWogwkLojF34ncbuCq+8YtTPzPZQ2yEw+n9KK97Vf2SdoBYM2bofF3N09dMXRasSCmAvn8b5KBdHSxZeOig1Zvm8gRZ9udDbG4CbAj8s6kR5dBC7qfqQ8VFkriYN0vLdgY2ljfzmQRg99hKYCPLZnXhEdKnFh9BCkoomQ6o32lmioLuFfIRUSWfvpdjlo6Uh6E/S1Qx9UL+o6jfLNdMd87dnqnlgXZAgtCjitmgPBvjnivzL9Cd+hU7GJiS7VTj+MLckDRUr7+6yEw0FzEkbkqlOVi1t+nK80mSfM6heR/cbkt0rZl6yjEyYZEHS2pHtOSheiRA1aJlZuw7ltURBFRKWDd9e9gfRTh5imlOiLpKF8T1dKhIsZFs/UUwrouzdbn6wpW7IdnQiU6pE+Eornmj3GRF3oLgYYrFwQEuyvNyOjUNO/sPQ/9BuSNoW63ujGe3SLYb+jxt/UmlrO+MOoqFprLplZLf6ktCDg4fuGvfTHzO5dGQ/4CEmMqmlxKUdMUhuX7Eh70J3iQOq/7liZw5CHlBehBg62RaI/WCzjpf2wrnbWP7yhd+kz+n7FG0GP8G1T0gXLNCHD8ExnUhsEBI1zpcZP1onvWO26wbNMvN23GxRsv76AY9Ph25P8PxvYUrOqRDZYfnO77dfBrJDgqqdS35QQVcLRJ2wumrcu0xeQDTvMNWK+kxE5K/YGfYCVNN2TI
 TMplqX3Z
 etCN1em7onb9tS0cmaOK3flOGL8S4EdhYOKzWGo2Y57226Erv5Ere+dUZF8pxcPfBjkZRWNt1wBoRLUFJbIcwDvla/JLmvP5l5Knkmi56dQeXf+l5uCE+G3DltTIbEe8W1pjjZ71T3yk31n9x+mCIkq9l8hVrE6JuNTYSkVfpy+rWH2k2MCpHSrNUsUrXDj4/8vmwja66KxyhYGVc7FoBrj7dKefzXoOhVB79hBevhISi7KCxpyzLDBDyVorpphzmBIwO2HErwn6GZW8awYmlyrdNDQvls3Nhi4Y62EsQUa/rNjwEVyt1vkyRIp1a7emBQUC+bzhQreSlTD4zsTEp2cR1+/IsUQG3kEP2D/Pu6lxgnfFwQidT4M8GjCOL6TnbC70d+46z+xjPxQ7g9q8I3DRFh8S8D8kd2+n/RmTkywVvbo4u3+LC5rRLxyUHqjteo3IpmdQA6kOmbSpwABUV7QFMUpLZAOsPzxbljsyl3b9FNYSUhXyAseRVNBzEMMTbkuKAP27BMrgpkLre7vpLDbF1Hog/cetLPBIVMF3tEluUiPJLNJNTx7aJzFSROVUGHN6GfsrgHRl/ajEIGz5XlQOC3mCGdLzZHgLOenZ4lfgKD+2q8hMGv6Kf1eeLMNmrBUU4t2+uu+yjsgFQmq67w5kd8vtL3D6nFL012ol23agcVljM1LLwgUY+YhGCfSG3nPQOvps85rrdsLUjbfkAvNC3eWO3sa8MFWdO81IQmKZngkKkQ3p+j0Y+YjGmuzMKmHI6eGvIfYlfmbJN/1jM5XcaZzD7/ZqB+GY/9Fx14Z/LOxtHLXI6MiZXhUeFGr5iUBHvVqx1CauYMwEPKTWHjDzEnuRVun/IrunS5bsn9i8BqKxBjx5msmeaPGSjob35sn49qtYnCbjxhfGhkEPQcm8Ewqwwlo2JH3eCRCGQ2TnWj+smgoN7GnVEfjzfW6qin5j7WibOqeVV4/f+9/8NiyU29fIo
 swqtQXPI
 ARZvpwqi4kwCLlJFs1tLV1CjGbrM8XwAXqRw8YhTZaWJqDUmBI9EKc+78bYKdLmdxeLViWoB/dmktrp7F4LJXng4ape4GJyNQSccma39+NHlcCf0ph5smN5XUcxlvH68HziP0Vm7pFjWSGlzs81dc2IFFMECUhUfx6SAG41ztNNtuqz4cPNwlu57Yi+l/BSX3wHD+aaLinuo3rlz3SuNpSem0S0qgPCAipAFVW3DZ7KbIyBXYK1aOa90z3fhcZXcPxT5R1xcNDMTDRrVdH8ZQVOUkf/LxHmU0Q4I5QvzXZxDT+OjaKtGCv9R3zadXHYqQ6uTFGyErTvfQvJCW7AmU1qc6G6CdDcUbSvP1HRulGIOoEHezCDqQ2AWcRWKSHCUUex/XJ+Z2PhdCEcNxFV6o/iEAeKNH1tEuD9sL/DYjoGXYFDCkm6BbAKksotx883c36+3dKhRISEB0FsFzK1lioJab0jzq+NE44kC0FfjtGIb2N3u5TC0Dp1qD1xN0m98Ly2UM58eJHqabV/TLAglrjUyqw1L1dPYYdWLxrdvKBMHawhDdPkDBYTIaTU3gpo0iW/O8+uKEH1MnoFolFH08hiP0xvwF6R75nYgA7UzgCDE009NIIQYpQ9aM1472VprP1srXtBuozZDV5n95AZh+uFzInK8lxx31BdpejWtlyZ0FzizmKsWXAC9RCBqlv0ObXNPdpC36/h4PWUn7mNeEVVqWg6+Ycuvq94nRNFTzxG3kjXNbmflWx0Df0QfevRkcAJNQbsZYvkrMmJ6Jb8JNzQxSVgJeRNWyX6Qq3ssVMAYeaaDumhoXsG+ucntp+RjbpnETtZqp6OAjw2MZgE/6xe2NjNMZRStirIDraXAz/M/iXioo51TogUowSC2ZBLbMzn2ttU00+/YJEF2lqorOMaFsUAngZklMsf5bLiDsaqi3LSknHcfklcZj7UKRRdhitidCuDHdza3BIW88TJBTl8IjnYMh
 BOe+1N/1
 X1QUkfYBMURUcXAtS6+qm9HKerCFjfITVo+8EluL/lk4RmIq5W15x7WzXKztSNIXo1uXvkjQHkMjHNrVThVXXPfsQXcWox//YdxssTD76C8nOBkcazXkBHRP2tbaJCuUMID7EFLur58Wj4u1XkP2QICf3YkBrd/2TgYn/VDE0SsSk496+VY1upoCRqg1RFJsexPK+4kvdtZTIVHDFI3PF/GWgS1+KTF55JUzI3uaFqhTkAp+4XArxehmQSf2qhLJ8FRR3CNK6tk6QrxZHSyabGZ5yr+iFBm4SSOpBJue5KybF4AuF53aRwmFvi5JZEq4AMktnIJq56V1XRxRfyHOtR46PaPTcjeyBmCjsAju0URfvg//LrJREAaf5qpJ++JGcoLOWyLKCnds3HX4almNc8zrpp2xhgVFM2LM2kgfsvTxQzgE2izagwMtlLSIGlbjzdrsXFkCYUHhlhLpRnoi3YsHy/bLjC1J7dEfUNaeeZzWZFMzfnUow6pe5ACQauJhWfiwP3IUxsPrxYCPjWE9ELXLVicmEqEmzAC59nrtTWqoqAM0de9UH5WTJ3gkE2sMDjdq2KSUHaaH8T9jZhksitf9Jh/in2r8LsHsoTMy5oBRRocRuLNO3pJE4y5wlebIU4G4EjfccoE84LGTjXBJQGruExUnweP5NhGKkFM1/b6MZuwWu3O3KuGDOzd7yslndQC10oci5OovnBEGzAM/5aEYPsjhb7B2pNqn92KLeFIh3S5x7Lh27WGoV2X87n0YvxZHI/7mEzRWi9Tub1Pprao3/xTsFBZrZ3FKDSoQ0CwO7qoefPX3hidSuLQzp8eKFMHohcJhSuyA8V7qEOaCH7u/pg8nATU1YlcFJUtgTAvsXE7OKXc8fkBzHzZbPqmCrOoJ2Ll7jlHs289aed64xbGL7LVBVm0hCD4zjX/GzbPXb+r71EgPksC3CNfU0VOnlmE5ntbZnBzUuNk8m9nfao0y9k0li
 bmsPJysf
 0e7H1CXO7RxjNjbgQLKLeCBG2NCKPaD1c4pQYmeT+V82FgEEEFFptw2R/C5DlwoPM/UXuBy+dwRUdqMNF1i/1FmP08hvCH9OhCemEjMjTQiNwOAIskMv0ballPO/2MDg7ZBco0eoJfPCPXEDgxpthKhaNKpJLQw/MeOQHDNKzpDDbqUHJLOjRa0OAQBr1Rio9S8ZQZb1sn8z8wis6OiPVSqfdR3VlfCdTRXzAPBXgNF7ndomdJ2ei8n0Cdf5Z7jhpDaGsp+y0x0eezcyWpOUzzbHU2ZblPvbOj970JbyvKOglBH9DF2xnR5YwE5GcZh19qJUUl3vfFczEBMiqk/5LkVq8xoJPxwRig5KXRXkIFpiRyX2lT+oFWGsZMWrMUkH0P8IzG6OrqNi5akoyrSdctoQtOjLBFVrQ5BIFGr5MYHjKW/VVvK0GbYHcOCWD87k/L4Q9qnuV+XA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce vma[_flags]_is_persistent() for the purposes of identifying
mappings that are persistent in the sense that bytes to the mapping stay
there, and bytes read from the mapping are the same unless changed by
actions taken by userland.

Kernel-owned mappings do not fall into this category, as their owner may
change the contents without the user having initiated it, and nor of course
does memory-mapped I/O.

We exclude fixed mappings as these are singled out as being unmergeable and
so cannot be guaranteed to persist user data.

hugetlb mappings are fixed mappings, but their contents are entirely the
user's, so they are explicitly carved out as persistent, as the MADV_DODUMP
check already does.

It excludes droppable mappings, which by their nature are ephemeral.

Use this functionality to update the madvise MADV_DODUMP check to test for
persistence rather than open-coding this.

This replaces the VM_SPECIAL check which means it no longer checks for
VMA_IO_BIT, however this is safe as we have established the invariant that
only kernel-owned mappings may set VMA_IO_BIT, so we implicitly include
these.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 mm/madvise.c       |  4 ++--
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 154fc25c9efa..0579e6afb19f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1741,6 +1741,50 @@ static inline bool vma_can_merge(const struct vm_area_struct *vma)
 	return vma_flags_can_merge(&vma->flags);
 }
 
+/**
+ * vma_flags_is_persistent() - Do the specified VMA flags imply that the VMA
+ * contains persistent data?
+ * @flags: The VMA flags to test.
+ *
+ * Persistent in the sense that - if you write bytes to the mapping - do they
+ * stay written?
+ *
+ * If the kernel or a device could write to the memory independently of
+ * userland, or the kernel could arbitrarily discard it, then it is not
+ * persistent.
+ *
+ * Returns: true if the flags imply this VMA is persistent, otherwise false.
+ */
+static inline bool vma_flags_is_persistent(const vma_flags_t *flags)
+{
+	/* hugetlb is a fixed mapping, but its contents are the user's own. */
+	if (vma_flags_is_hugetlb(flags))
+		return true;
+	/*
+	 * MMIO mappings may not store what is written and may be changed by the
+	 * device. Kernel-owned and fixed mappings may be changed by their owner
+	 * without the user having initiated it.
+	 */
+	if (vma_flags_is_kernel_owned(flags) ||
+	    vma_flags_is_fixed_mapping(flags))
+		return false;
+	/* Droppable memory is discardable by definition. */
+	return !vma_flags_test_single_mask(flags, VMA_DROPPABLE);
+}
+
+/**
+ * vma_is_persistent() - Does the VMA contain persistent data?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_persistent() for details.
+ *
+ * Returns: true if the VMA is persistent, otherwise false.
+ */
+static inline bool vma_is_persistent(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_persistent(&vma->flags);
+}
+
 /**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/madvise.c b/mm/madvise.c
index 0922d5f07a12..e15973292f94 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1584,8 +1584,8 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		new_flags |= VM_DONTDUMP;
 		break;
 	case MADV_DODUMP:
-		if ((!vma_is_hugetlb(vma) && (new_flags & VM_SPECIAL)) ||
-		    (new_flags & VM_DROPPABLE))
+		/* Non-persistent memory cannot be dumped. */
+		if (!vma_is_persistent(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTDUMP;
 		break;

-- 
2.55.0


