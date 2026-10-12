Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19B7CC6B02
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02CEC6B0088; Mon, 12 Oct 2026 14:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20076B008A; Mon, 12 Oct 2026 14:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7B16B008C; Mon, 12 Oct 2026 14:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5A1B6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:39:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 441D01613E2
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:39:00 +0000 (UTC)
X-FDA: 85314836040.02.21D4FA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 977528000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:38:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FpTrSmMa;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791830338;
	b=HrLf5L6liS+bomICjyuHHUNv3ElhZHczZ3eyOYmqzGfnsrS3taCE34Ziiu70+L5rcbCD2F
	DXlcN3y+9a3vUcIuPxJdBpeaH3HqAyMcO9GJUNvE92fgA7a8dLGrYclffnr8yDrUXcGjLB
	gQySDC40/+RuK/FQfKwubFneVCWt3jU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FpTrSmMa;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791830338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fP03qOjNgvJcNFxilOwiajFRX7c9NaLWJPxXiXEaFwM=;
	b=vq2HFL4LF5ApjP6U35dDIQ6W2zQpMb8QXwj7JudLLnKWWZYZO2WUtAzzAZBPIUsINn9x9D
	gprH7ZDAfa/YE6vVZCdIsWcONb/BxRAy/C+Tt9ibfoTa4f1I2ar6kFz+lPNUOxUVWhAYJr
	DpaJc/ixUNidgOUogtsaPoydr+NvDMY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76F22602A8;
	Mon, 12 Oct 2026 18:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B16F1F0089B;
	Mon, 12 Oct 2026 18:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830337;
	bh=fP03qOjNgvJcNFxilOwiajFRX7c9NaLWJPxXiXEaFwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FpTrSmMagijQ4s8+E1TqfKdKHrTHU0BFRjA/iCJzTavYCoIGrP+M/jA/kByrAy4dF
	 hg5+n9OJT0wTIiPuLZk3nQ4HlvQEC1Pt7lSKlbbnQhSLrANVy6PsCVdXT+ZqRFf+WV
	 GBi1IdoRtPBhhxaaK0OLjDeY5tcu18IyA0h0uTRG50/+GGfE+jKtZkG0HLfBGJiUWU
	 Hu8DdnHwjFwwYku6PhhIIj1fCcErlCDKnAGYjbWKOUSId3Gm+w+Lucn03/P2JAkYqI
	 yQmNHzkW+VZUHiTptwbi5AP53a4fnEFmQ+CHOiXo+2e7qaN83k4kAuhfxRivDIuAWs
	 d/avRkBSQydRA==
Date: Mon, 12 Oct 2026 19:38:21 +0100
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Bert Karwatzki <spasswolf@web.de>
Subject: Re: [PATCH v5 23/38] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
Message-ID: <as0osndioe9xxoG1@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-23-923b70125b1e@kernel.org>
 <50c967fb-b6de-4189-9430-5455c26a5385@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50c967fb-b6de-4189-9430-5455c26a5385@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 977528000A
X-Rspam-User: 
X-Stat-Signature: 1erkoaoykfx55po8tbp8ty4k3jn7srnw
X-HE-Tag: 1791830338-185052
X-HE-Meta: U2FsdGVkX1/K3qV9FTjkKnK5pdlT18fNdO3ZJlmoj0xo32+Ap3KH3gmunZiEpThPTGZfX9vv1knlOFDeQ+7fhQnEKiYrpPlv8HR1MJ9LT6Zr/fz9yrsLP2GjgAE8+zLQL1WTglgN5epBZERmXkUIvDr3mAZxueqdFU9ivy2P5TPGoTKpsu/fFPWolSblyYJ0kdfq8/fpEBZL8tDc8OhULPbnW6ZpZHELkm7TK0nI1uWnvEO2j4rbHtPN+9O3rtsc2CTK/Y6ydWrAaZOv45odw7Cv9N/uyhT3jc9GGi81APpBS0wZ1yF18ZmzL2Fm7YASRI6b8jQ7bVRXeQmwvlLQcbnM0oO3toSGvnGxRLh1lI2IBVuQdlJhs9Z9mqCPrwoF1RyoeK8NxCceH/s/qFDNA5MfN/i73Ra0ImKegFgoO/jf222cPvaCHNPUZynwlS+wzgy+VTFHkpdtoLVUqtYl6XQA9zQzERNFOBt7XCBNmkJ+bRayGpLlYX8z/w5aWd13UGufoS44v+HzZ8KPHUjONayf7AvoD0kyEeIYi3ecTGFWQgWs2e+UnH/t/YVH4lYZDN7NVYQ6j/nI/16aDz0O0ZrZgDSdfqoHx6tVjjAP02aFi2gkhVKo67rYsgHJlanWMSAz/UYGZNmyfPl55Y+RKzT75B0W9zoLd29xeiTGurPTHMc5LtcD2n3n/AzxHpcSI7VPcEPkAxg1hICjaYWjkOW1It8NQNdq0QMQcWBLXyI2CfnkQGVP3rO0pJfpnocOZc6QcfqaFA2hYGFw6sx9W+oQ3ORQa89IpYEitiCl9TcG/qNg0Y4LWdIdof62l73eX4A/7O32sJormvZYa2VxthAYLH8s3/mSDV+O280YCAAZkKAszx3qSVk+i2m6zn/9waHfbgUa8FxYklCiTgXUDhjzT4dnJ+0RCdIl/VWEOIdEXpPEmr65vTVi+/vfV1L3dbCic3KE/k1jmyljlwk
 aqCIfvVf
 J+9mRcihpw0rUGwfESXyyr/UoqHmKkn9leHsYK84rAWXPRyj9F55QtRz+OLm7G9x/7t9K9cT9sgmvkpyE8xUXkmEHRr2B9/q+cYnwVq8z4eCJPy3te+HGNxINklXFE3zD9nr/KWviWkoJd2bWQ//90K8mPE9hyfLPrmxDfiATaw/j3o47Gy8W2pTcVGcxNDuQCvUku2d+Vh/enhRPhkP8UW0jxLL7VL07k1U7Xau9xnsfliqc9DwhoK3PuiiacsVaRjSP/957s4vWx4hGC7aDRdHlW4bPk37JduUFiK23+0dgFcSMyW23faHibwf+juabYsiBLi0Cv7nWs1QibBSDrYoyBMIgAEr7yMTwBNXWapM8TN5H/AYotAyIx1//GZJ3HTTfkIvEpUk6CrQpwQgOg6BuiVTp7J+F3sZJtc9yXvZ9blboi47Sk4c9zmcnc90FVTPH5mfy4f1PshKo2IT1WDEUMmcHb7RDriCX/9bCfuaCGPortim9c0RhSbxf68NAcIp8lVz54wAytf26WsjQOf7sfnqVwqKwWS9VVMp5YTxHlKPsQJy7QHbXrWknktnXrrZBip55px5VLkziWEMaWcfPDze5/a1GThhWWB/aVxJqS7XM+6tKt14Omf7zz8K1fdjuJo4JEqEry7x/IwBsUOK9rrnvazufd4gq7NNi4nSQfMoZUIST0fXiGFHuIJaRVzyWbrGOO/kNliRrYQhincQcSo8K/VB/WRph4KXHpGQG9WEjiWCeNxmldmXTTxnBk0mA3s8M/3C0AydQVkykk2EZpJfLzXCFa/jpgB9XxD3h1UM8JA+yg8nyjOq6FFeMXHtMj1uA5b/oTGAu0nHrMl7P1yixZdC0SZ1e3Rq+QUh7SEpyENC3XaOqtKjfebnsjD/2GkA7fGOGU3IF/30sLGe/0R3zdYzfjcqsExuF00aou74x/jOTc7y0D6UsV2Fux2vR96K+w/ZXJXg7d1RF40q2Da4G
 Dq3dj1/a
 zIt5obQo+jpYRziHP1PDk/9VpIQi9SnXV6Tyxqkh73OHZSs93FPC5Z3CeGkuKSXoTvvYJ2rG/A4h5jFz2Cz+FuKxaHKfqC/HMj9q89BC/jHo4+OumPMbh4VfTMqB8VDNrRBCxDeIU/E//3blVSnFdqqjJ/+ZnEqXvqBRAY5Rm9qlA49Rd6YHhZKCwjOVyaJsOONhoUbl/LQj2zk0tWGMCSiObZdcOp3pDz3WFS5/7WHAtj+JfJksmFcHLcf/bFwXhNnbj8wiJ09ZV18jogItDruJPg4CZZy8y4AMelq4UXRnFLIMNSBF4CpIc0gfvjQ8Soh8lAbCiyC+Un4b5XsqBDjql+QoH4ggfVui5CQsXm2nhhO9MkC19yIcBOy46gsSzjgDLDtBOJPxiDsj/m7gcGFtzf38WvvkZi6xs/H2Nxxf5weULBe4lMjdlcZOz16HWjXZ5zY6nufzIpohbfOn7cIN55XoZwEV+Rl8bHb5Qrj6LPCMJXjdoOA7CEc9fdLbXAUpxVoK7hUjn0V8o7UOjJJ0x3rBi/L+TaLM9gQeyqMla+ABpcKmsDugS5wMG/IgDvKYfYWcDqWCWFqEk+0bzy9MN4iw8vl0OmrsOukzjq+sUlUxlWR0oNm1LMMdAbeeYC58p0KxEzuHVkwF+oS+oPfhEgx1UjheT2/jxpUgNRm2ACOCmbciKPyBgouvJsdXyq3M/KP0dVxs48AjuOgu4pBtMSEBdPNNOqNBfM+IP0+oZB7MJqqqt27u3Sd3m9fWYHsXfha8vCIOCqbsYz4jrCPStlfF/h+6Vg7ZdU+h7MML6x4yKsqgzPbH+ucay0fGjSj5oJkrJzHxVfPxJUgTrumb8mx9OGPF5tb6MJAhbxI/XRdufR5NXmkMOn0HUt/g/UZdiyyJSdCx/Ez4N+YKCcuYu+cUocGKx/TRGS2ZFwCSLeGy/WKqMqTLGXnxHVDU/CyhYM8O4EKGnURS2NLvMknaSi9kz
 gOETieaG
 PLUMYr9PsWHXb/OHMtqyOUm5YVvhfsWT2OpZPqPBg9ku60H3+DPsa9C+fm8DJw7RuDFPVIpBN7/JNifMj7AI/Hp7Lqn1Mbr6uhe2/Jpnsas9x4tc8t3jWrkMgEYX2o1Yo1GEfbDJ3sZbCyeuh/xnj0JvAzGueqiaI1b4/wWqcKPbBB/i6U2zRHkV+M19SHsO67B/9gby/j+P1CHlyZfrdz+FbjVsfucNs4qeeT256Q8V4yPODkdoRinkYstWIYThD6zrLB7BHcoD33PVwElteikGPLTB/0TcBaUlGqYoh2eu44sPzxpa/aUxw7UdECmof00HkhbkE22qm+rNKNj536VXrBd3hOJK1MpMOchRkGBCZk8xqSEsDD54BohdgBNWOqK6CuE6TaoDzy4KFEn8E8HHaSovshr5MF68gQQAiBctYok3Jcj83xcKIrskgzBl3UsVD+edT6MAHRxWDTLPQ6xtiH7MvZajNYEwn1KPlKJUBLaMuPVTlOX+Hgn1kCAIw5T14xypk4iAj2IScokRs/mjtLqOD91ojOoRaCkjS0a/a4tdw68j0mhI1YIe5Fx+mQ1Jh5Ux6nsHDs3eJHr//dUmfrHpIfGYszNi6mMzY4XS2BnsEWwZDciGBHXJHEFqRG7HjsiT7iCv1otDuOuisMWgIi8wpFp3XqPv5HlYzTyB8uX5YTkc/ks/YFl147miuthlci7Vn74Gk7iOXIbqMFEKseZigccfvxnVPUGtocYHc3uu8dpluf2NqJe68ezTnDZjRCIrhTZhJV40WF5eTYju3YDCoH729+osS1+PYkIi7/xl7MNUHlYas5wKh2xU3w3Z6Cz/quc/65IJ7FaYR/DPcC5UdWAKDzYV8uJSv/db1O7Wz81cZza4j/SDTXLslTRJC5eFo83Ql+5zW5K+DFNHvBssqyS1gWfN6beLr4iDB67fbeFdq4ZAMv9ETdIfuCQatojjSPvsBhoKf1fqbWbmH2YOg
 Au1J5Zlo
 pLZFpfJXl38Bsu8vfrx23FRMxxuE0R2OD1EAJEw+zGLZh5IWB+LdEJnLymTjR4ptWW3tAgvHnVofnoYKvFFbuqwvfGPdodooorR56seQHE3kdQBz2RgiO48B29xTNSWh92CzmY6PJHQWPkQWd+AeDOrJTrdgGw2Dph6w/QL/FKcAVzQJ6OHbfDb4O9SwfMZPHl2H5CO9oPj4F1VvOfNdnqUZGYNm+Uk9igPTKxt/sW5DenTEpl5nzz0gmqc09QYzP63HzdQfLpHg4BSpsI/1ObaMRGGdDBm6jOKGh5pnM6PQ0N+PBgsIDEJTFRat62OtMnnKYVaWDpkapGRKYrODMuNpQOYKkYv4N/z6TYW2ZwoU0qvzLAYLMaLaqRmBhvZwL0SomLc+xacQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:23:15PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> > When performing mlock() or munlock() otherwise normal VMAs have VMA_IO_BIT
> > solely to fix a race with migration which might otherwise double-count
> > mlock VMAs.
> >
> > This is unnecessary - at the point of applying folio mlock state, whether
> > setting or clearing PG_mlocked, we know whether or not we are locking.
> >
> > Solve this in two ways - thread a boolean through the page table walk
> > indicating whether a lock or unlock is being performed, and run a locking
> > walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.
> >
> > This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always implies
> > VMA_LOCKED_BIT. These are also always cleared together.
> >
> > Then, update folio_add_lru_vma() and mlock_folio() to check only for
> > VMA_LOCKED_BIT, and update try_to_unmap_one() to check for VMA_LOCKED_MASK
> > instead.
> >
> > Also remove the useless invocation of allow_mlock_munlock() which simply
> > returns true if unlocking and instead rename it to allow_mlock() and only
> > call it when locking.
> >
> > With the other mlock abuse of VMA_IO_BIT addressed, update
> > mlock_vma_folio() and folio_add_lru_vma() to simply test for
> > VMA_LOCKED_BIT.
> >
> > The munlock_vma_folio() function tests VMA_LOCKED_MASK instead, as an
> > unmap racing with the locking walk must still munlock folios the walk has
> > already counted.
> >
> > Additionally, in order to ensure a racing unmap/migration releases the
> > reference munlock_folio() took (whose put was batched), check
> > VMA_LOCKED_MASK before calling mlock_drain_local() in try_to_unmap_one()
> > and try_to_migrate_one().
> >
> > While here, also replace some deprecated VMA flag predicates.
> >
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/folio.c    |  2 +-
> >  mm/internal.h | 10 +++++++---
> >  mm/mlock.c    | 51 +++++++++++++++++++--------------------------------
> >  mm/rmap.c     |  8 +++++---
> >  4 files changed, 32 insertions(+), 39 deletions(-)
> >
> > diff --git a/mm/folio.c b/mm/folio.c
> > index 47a437e0f7fd..35e242b48870 100644
> > --- a/mm/folio.c
> > +++ b/mm/folio.c
> > @@ -505,7 +505,7 @@ void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma)
> >  {
> >  	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
> >
> > -	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
> > +	if (vma_test(vma, VMA_LOCKED_BIT))
> >  		mlock_new_folio(folio);
> >  	else
> >  		folio_add_lru(folio);
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 4ae08fedffff..ea8fa94ebe1b 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -970,8 +970,7 @@ void mlock_folio(struct folio *folio);
> >  static inline void mlock_vma_folio(struct folio *folio,
> >  				struct vm_area_struct *vma)
> >  {
> > -	/* The VM_IO check prevents migration from double-counting during mlock. */
> > -	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
> > +	if (vma_test(vma, VMA_LOCKED_BIT))
> >  		mlock_folio(folio);
> >  }
> >
> > @@ -988,7 +987,12 @@ static inline void munlock_vma_folio(struct folio *folio,
> >  	 * always munlock the folio and page reclaim will correct it
> >  	 * if it's wrong.
> >  	 */
> > -	if (unlikely(vma->vm_flags & VM_LOCKED))
> > +	/*
> > +	 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
> > +	 * mlock_vma_pages_range(). An unmap racing with the walk must still
> > +	 * munlock folios the walk has already counted.
> > +	 */
> > +	if (unlikely(vma_test_any_mask(vma, VMA_LOCKED_MASK)))
> >  		munlock_folio(folio);
> >  }
> >
> > diff --git a/mm/mlock.c b/mm/mlock.c
> > index 39215a3eab1f..4235a1518fc9 100644
> > --- a/mm/mlock.c
> > +++ b/mm/mlock.c
> > @@ -316,22 +316,10 @@ static inline unsigned int folio_mlock_step(struct folio *folio,
> >  	return folio_pte_batch(folio, pte, ptent, count);
> >  }
> >
> > -static inline bool allow_mlock_munlock(struct folio *folio,
> > +static inline bool allow_mlock(struct folio *folio,
> >  		struct vm_area_struct *vma, unsigned long start,
> >  		unsigned long end, unsigned int step)
> >  {
> > -	/*
> > -	 * For unlock, allow munlock large folio which is partially
> > -	 * mapped to VMA. As it's possible that large folio is
> > -	 * mlocked and VMA is split later.
> > -	 *
> > -	 * During memory pressure, such kind of large folio can
> > -	 * be split. And the pages are not in VM_LOCKed VMA
> > -	 * can be reclaimed.
> > -	 */
> > -	if (!vma_test(vma, VMA_LOCKED_BIT))
> > -		return true;
> > -
> >  	/* folio_within_range() cannot take KSM, but any small folio is OK */
> >  	if (!folio_test_large(folio))
> >  		return true;
> > @@ -352,6 +340,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
> >
> >  {
> >  	struct vm_area_struct *vma = walk->vma;
> > +	const bool lock = walk->private;
> >  	spinlock_t *ptl;
> >  	pte_t *start_pte, *pte;
> >  	pte_t ptent;
> > @@ -368,7 +357,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
> >  		folio = pmd_folio(*pmd);
> >  		if (folio_is_zone_device(folio))
> >  			goto out;
> > -		if (vma_test(vma, VMA_LOCKED_BIT))
> > +		if (lock)
> >  			mlock_folio(folio);
> >  		else
> >  			munlock_folio(folio);
> > @@ -390,10 +379,10 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
> >  			continue;
> >
> >  		step = folio_mlock_step(folio, pte, addr, end);
> > -		if (!allow_mlock_munlock(folio, vma, start, end, step))
> > +		if (lock && !allow_mlock(folio, vma, start, end, step))
> >  			goto next_entry;
> >
> > -		if (vma_test(vma, VMA_LOCKED_BIT))
> > +		if (lock)
> >  			mlock_folio(folio);
> >  		else
> >  			munlock_folio(folio);
> > @@ -428,31 +417,29 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
> >  		.pmd_entry = mlock_pte_range,
> >  		.walk_lock = PGWALK_WRLOCK_VERIFY,
> >  	};
> > +	const bool lock = vma_flags_test(new_vma_flags, VMA_LOCKED_BIT);
> > +	vma_flags_t walk_flags = *new_vma_flags;
> >
> >  	/*
> > -	 * There is a slight chance that concurrent page migration,
> > -	 * or page reclaim finding a page of this now-VMA_LOCKED_BIT vma,
> > -	 * will call mlock_vma_folio() and raise page's mlock_count:
> > -	 * double counting, leaving the page unevictable indefinitely.
> > -	 * Communicate this danger to mlock_vma_folio() with VMA_IO_BIT,
> > -	 * which is a VMA_SPECIAL_FLAGS flag not allowed on VMA_LOCKED_BIT vmas.
> > -	 * mmap_lock is held in write mode here, so this weird
> > -	 * combination should not be visible to other mmap_lock users;
> > -	 * but WRITE_ONCE so rmap walkers must see VMA_IO_BIT if VMA_LOCKED_BIT.
> > +	 * LOCKONFAULT without LOCKED never otherwise occurs: it marks a walk in
> > +	 * progress so that rmap-side callers, which test VMA_LOCKED_BIT, do not
> > +	 * count folios, while try_to_unmap_one(), which tests VMA_LOCKED_MASK,
> > +	 * still refuses to unmap them.
> >  	 */
> > -	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
> > -		vma_flags_set(new_vma_flags, VMA_IO_BIT);
> > +	if (lock) {
> > +		vma_flags_clear(&walk_flags, VMA_LOCKED_BIT);
> > +		vma_flags_set(&walk_flags, VMA_LOCKONFAULT_BIT);
> > +	}
> > +
> >  	vma_start_write(vma);
> > -	vma_flags_reset_once(vma, new_vma_flags);
> > +	vma_flags_reset_once(vma, &walk_flags);
> >
> >  	lru_add_drain();
> > -	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
> > +	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);
> >  	lru_add_drain();
> >
> > -	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
> > -		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
> > +	if (lock)
> >  		vma_flags_reset_once(vma, new_vma_flags);
> > -	}
> >  }
> >
> >  /*
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 5332c52909be..b4a4b3929044 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -2239,9 +2239,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> >
> >  		/*
> >  		 * If the folio is in an mlock()d vma, we must not swap it out.
> > +		 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
> > +		 * mlock_vma_pages_range().
> >  		 */
> >  		if (!(flags & TTU_IGNORE_MLOCK) &&
> > -		    (vma->vm_flags & VM_LOCKED)) {
> > +		    vma_test_any_mask(vma, VMA_LOCKED_MASK)) {
> >  			ptes++;
> >
> >  			/*
> > @@ -2395,7 +2397,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> >  		}
> >  finish_unmap:
> >  		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
> > -		if (vma->vm_flags & VM_LOCKED)
> > +		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
> >  			mlock_drain_local();
> >  		folio_put_refs(folio, nr_pages);
> >
> > @@ -2770,7 +2772,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
> >  			hugetlb_remove_rmap(folio);
> >  		else
> >  			folio_remove_rmap_pte(folio, subpage, vma);
> > -		if (vma->vm_flags & VM_LOCKED)
> > +		if (vma_test_any_mask(vma, VMA_LOCKED_MASK))
> >  			mlock_drain_local();
> >  		folio_put(folio);
> >  	}
> >
>
> The mlock.c changes are a bit over my head (mostly the old VM_IO handling ...),
> but it looks good from what I can tell (hoping Hugh could review ...)

If it helps, Lance tested thoroughly and found 1 place I forgot to update, now
addressed, and Zi has carefully gone through too.

Essentially it's doing the same thing VMA_IO_BIT did only with
VMA_LOCKONFAULT_BIT, which is still pretty gross but much much less so and makes
it all make a lot more sense (esp. with the locked mask).

(VMA_LOCKONFAULT_BIT when used for lock-on-fault is only ever set with
VMA_LOCKED_BIT set too, we track the folio operation by it being set alone so it
doesn't trigger lock-on-fault behaviour).

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

