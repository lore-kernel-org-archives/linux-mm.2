Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBCE6C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C697C6B0088; Wed, 23 Sep 2026 04:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF33D6B008A; Wed, 23 Sep 2026 04:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94B56B008C; Wed, 23 Sep 2026 04:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8001C6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:14:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 120D912070C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:14:16 +0000 (UTC)
X-FDA: 85244314512.29.8183921
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 575EDC0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:14:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mCJlfOwt;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790151254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4asDkf1r4nhSOrT7R8hAyZcEQKKYrXhZ/zPFbXlZHas=;
	b=kWk47tB3pjRZoXgpA7fqngLXUnxBb4JHj6EpEQxd9dwuJ5/usa5Yh92YjI518SeDd5CyhA
	K1dD+xdOqMNLEBIcAQ/mXETK1Whn8fO3O32u1U3AUfRrDdrbtC32qvfXsE6RzyzzXL/QMz
	aeAtbvwKqcK3YB+W6SRifKs3LTkHt7Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790151254;
	b=ZGb7TQ+7VKXLJjWj/eIXV3KzIaJtHbRLnMZ5+g6sGKp1F3HZLnq9dCTnuZp4Co/c4ef4Wh
	JrblZJfe70k5CGURUSjtmCZlVcvtqawKGS0OWteN/l8oR3WQ4n5u4o7H8XOyufdaCR8SHU
	v7HAV9Mk8xI1ZHaUh0VA8DmVtyojvVQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mCJlfOwt;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C4D1041766;
	Wed, 23 Sep 2026 08:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376301F000FF;
	Wed, 23 Sep 2026 08:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790151252;
	bh=4asDkf1r4nhSOrT7R8hAyZcEQKKYrXhZ/zPFbXlZHas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mCJlfOwtX67y203buKELQIT2TJkfDrkJVRWjviTUThii3FIl01hNmt/2/N5niDJsO
	 pMfVhn9hKYcyv1hPNTj3q8nO0Pds6VFO+rGQe1AtibuYmlGhfEvG5fzsVNd5VZj00d
	 fkgcgDIaUfRNs16fD4U8B+bk8I0EVqFfud76K+T15hPjY5Wnzx7h17G1IEpBvKdbdT
	 fwOMBpLGIgd0Nxsna3HHhcpWKXrmzcnrf1IYhuJaw4NDIion+IMG6MmbJbYDpOjNxG
	 ds54K/vBGhy978o0s9QlAtQmkuOq1eOy+SdadnN3yilV4MeGzEJApyN21XCzbDlSMz
	 y5uiJtnDQNScw==
Date: Wed, 23 Sep 2026 09:13:40 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
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
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH v2 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Message-ID: <arOCPN02xB7mykju@gremlin>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914180811.057cba8fcc48d6e0b53a2683@linux-foundation.org>
 <0b064fe6-ddb3-4f26-a1f2-2e9dd88d590f@kernel.org>
 <CAJuCfpFBichJH4OcmSHTb1rOuQBT6k5pXeua9_KgpWjDBKvsYw@mail.gmail.com>
 <aq6kzpK7wPl3iFGe@gremlin>
 <aq6lW9FvL69QeA9H@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aq6lW9FvL69QeA9H@gremlin>
X-Rspam-User: 
X-Stat-Signature: nwpurie7d3zu9omr1jh735hohrgt1oa5
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 575EDC0002
X-HE-Tag: 1790151254-537842
X-HE-Meta: U2FsdGVkX18XkAWpoy+lfkPuG2nWUXla5wT+P8k4zo7LVQjfGKWNmli8hZ19JJkrssMMf40iSmN4yAcbbkOj5x5Zgvd0IVPxK/0k/7UyDwe2mjh6kHHp8/7Z14XTb4JiUTMpiKo/O9+R5Uzs1XjVOUeeqg1QAikXJXM9wiapLtK7wDX2myOZS87EYLFM8FQyZkBBUUDKNfiPJGHBEUxyQs39P4A3BV0OJ4UaaVv4bC471CQNZ5FfoZbreyBviZOLjcP9XQCKQFpQZG1pkYH39OoSirXKsdZijMSR2eXMQnQe3w6KXNFmukYt/65zbp3Uw6x7fUPY7B3bpDBKgobkRbqeWiwy6yzjLKAGJSr+YuwMQ3wkt9SAFeZ06XJQWzve4NV9Zt50bwlc0bsqC4ePX9L+YJvO561qHDTnerotdyOyVnxnlKorSkplFsUWG4dnY3Gp8g/1VUxGTYiOFxdM6YIA452VdN1e4AveXeqHHGh+Khu4EaFbeX6lEK6HFGf0FfP6oZ3pH+9n0uTwTRZqUaBR10ApOItPky/KHWVXCcRCLm4PGbqne7l8dq1h6yP6uMFGei0nZFgk0QZaZ9RlU5kMv8m2mFYS8dgPz/VZu4+17uU6J4rk/uHc1WJJ4AvIFMtkRK5O20Tymnm63nggxv+nLlgekCdgzDFZRP2CgLKady8mgpp8DuYY4HvIVqaoYlqHo9HJmInp4OnF2Vn1e0R8PQmZK5oTP1GRA6WZSFMjfhcqD2BpAsX3FtdCaMb3bdN/prcUA6o1qXc8Rrztz0w94T61nBzA/6Yvtl98o54om5RGJmo7EutPFsdIO4DAjyjSB8Ie6vRdeFS8AKF0FZxzspEGZkOeQZTz4LfBMfWx3OOMcT3+bi53izOaNfCjFbVL9Mq95Y0qxORu24I38Xe2jpE2vb8yRKZXlt0To9/aswgG2T7Qtm2aZMXETluLddkYnSjXrtMxPU6UQh9
 z2LnJgIC
 /vHZ/S2JRefliHv/irqFpHReViLtidNoLxpDKhN7f/bsj9UknrGCMA+UBzzM0YF0C+TcI9gjZthzP9QKp/3OMxmWeNpF4+/48MPGN5nGHverGzbvqw4Q23/cYHsFumB4/of1nbK1Nb/wS2FqPNQqX7kL0FFPcVDLky6fN3DLBQaGsxK2O0nJSTvpzNQDYrkcpIGBuorCF/e3sYyBjqZfnedvW5P6rnFKIcjvRZcVGZs03Ij3G+7w7jZbInFzJgi0GKPjvKTQnc1ZpZ3KgXLYPxUkmx+N4jz214N1gKBpUOiDdBr5rL3wJC5iVXisITlDTqtDOws29mfqNGi1UY5o6pFIr5ebBwvaFB/r9zLq7xTiym/q9zjgUFwnJL7I5PKbE04Mx0IqYsDynZWCp6gdd9ZQV5Dznp3MDyyx9PpZHFRPeVELLH4cmzxXtJZ2lI0fz1FXsstpwSJR7qWh+mm5/QffDczmburK0rdAZQhMdNZ/Gbwcxbx+fKMrDcrD0oYbVfeTbIVntnWVm1Hhgr52L3fazTLHl0ZGuob3ta83eRgtmRA4rvImnXkrL845VPITsCsNw8Zg9rCmRxIHSYpg66nRDYRtRqAuZY4BoBaQpg9+7/ebNjhESw07AD+7kqBp6aq/CZVDCfkUnJcLOGnNXTN47vZ1TthZsHUMGk1fKBst9Rz6Kw/YSpg01DoE2CvpQaRrVeZJJBzcJYfKBFsY6QatQVbT+62EfbUAt/qRDSmr7/yFHs9JQuspOAMQQAU88UvbjBL/IqpeS4A+LI3xLBuPO3Q612xEvAlwhKwcQLbBCH/kP9psqaqEFB6Hw04mWuFYN5KMzWFaXsL01SqF588cLtvJa1FbpcMyfocz2n83lNaleRhX656bjEp7fS5p1f6HnM/h/yWBsBwADKM6lv84JUggrAbK8UmbngGQ5Jt2bbVIBUaWLAAV052glWWGKj/Sn2xD7r2rSdAiIXhXBLK7eDBmU
 MPsCzhef
 6Ts1it0zHjfywBqCypDLufy+LK+mDPodbluTMw5PtkHklt0jh0nwysNP4/FIKEePK4o8pHq8rFEkhJFwE5LaJ7eGfMH6VbB7Mk5o64QZvjCaxQac8KIKR1TIA7ljDA2aqM7KHHyG9IB9uYNzBrZCRGzz22sVGUHtFcEBMjdkF/XwqKVlpVpzoS5PS4g+Ei74FPte7i8UsxVfKcen56ZvPjJ4J4dwYhIWwjVClwPH+damGQF0plq3ZPkQFDgUiGZhMWcutdeaiyPIYpVbrBeHioUFz7+GuuqNAxE92E7qbPN5I9Zleg8b6IEDGQMwbI75hFavrTlw/Xpeg8cYORQ62rPOAdlP6ej1E6OSh5FveInCn28IBJYBYUSu6f4z6B61vKyNfz7MKdmBmgk/xgEITNxhXqmimzArt3/cnVUgKBP6IA9cGeAcBCodoPabQv+T7U9afzsqSaAC7iG+Vba+VCTlbR4bjFBbn1n6d1KITv7HPwbbzCumKdrqyhET9D5tyx6ulVKTHSeO3si50r5uJ0vRNT9DWMQwxVDRqd7MMfL7Ap/xUaLMzJ/oxYOmv1QueA7sHv+xIQQe5EAXRM3iGiXNW5NT5tFManeHdjBRVKjLvSm6Xf/AbPSboKmshj0qBHepffI9VCQy4n5VWsl4NOgqvCLOpzvBlcetuaART36iayhhN6kem5YZHlkaQZP5tFxrVwJx8jdXVXs+Jiw8rkxWgXpWvudl0KLaqoEKDEh1GxaiqOVeYLZ68wZR+u0MN5Vk1E4LjV4clAAOBvp5OrqSlsNGS6VcL+RESLTBFfxSq2Np25uQbgLjxWKwdyId1fyvpV18BY+PbwKRKvBi4qQJ269FX2Dre0VmMuNI5rwtAKliwRp/ikSE1u4n2kyPWa2f1MoiQoBvHNz0KtjP0kK/ealOJ6q1AhtBbUyAETlxPkjhlWzCjZgd6ba+82Ep5Cw5VBX5DCST3WIIeopO1kUhpXOCj
 N+y2IC7/
 9o0XBTPPIJrOLYmb2mLqCKyrp1wDh7/ciKnjYTLJUFtleHHJHrg4SUZsLA7RCbQMMMCiMlSiXZHzA7Y9FMaDN7a6nIriCI9Js7BVagtLeIFTFvJRH3zJrR1Fd7F3HI3GGHkIL3EOzQeZuj+nVadGqFx93WS8gCK/Ba33xKOlkBg/RlnPimMejXk3vggxz1667FyT7eCbl9Sltqm1oLQ4MJOIwy1yBQ25CLwZpsnqx2p7U5i18DWsOG4TkcpnNBPBl5K3QvTRB1lQztmG1OVtA4nKEhZ+jHNQoAI19fcQB90w/P/WdQxcfvexmliu3Mm7Q2tvBzg6t+wEcKnN/oaqKy7NXfEWO/JbE1DmOD8TqkZlHPv2AoLs+lFIlQftPbG6ZbeIlbeOucRzXcUmCJp1AW385F3ed4Vp59PYbYZth/Ydj+Dafz1lUKeDW9vXnsPE6Enclsv85r77wNGjfZRJ9H3AAIivLkBa/kMkfY7gVkjyz5aoU6RFrMwYg/bkg3LMesDqbmTGuK7yNjJmuqkentkvxFvr9WASzkvk/6UFflMhCJx3CmEZ2vgooIitUHKhb+YbTbi9oaJdzik4RTVP4QcUZIKE/wZZ3J2KR6JKS7LvIuHBn8+jSG+B+4qIGnFiUNfX7aQeHDId7STchg+dJhTUeh5qCe7dclnWwiRJ/1ejg4umcaKQxMFVqYAwlYVTqXtrm2Y4Cds6AetKVFz9mR3AqFU5EEJfkpCPkOpq7FjbawjE0vMTJ6yGHej7I6J7foUAvi3qxSHQyn05RkHGpdvCwHFNCrIdQ8iPgqaeKgQpN2an+mqmdEgdkTnPJ5koj5s4vYf1IQ67d1B+SXAFCory9TZkMfnGIYn2hV/wP+fYMN1KAJZWUdx+XyFhyRlSn2ybz59R9ceWyYcnajE0EWVQrcF9o+JL8pz5Nu5/qTg+Kn4i0Ve8KIe/5Oo2udPKnCCjZFT1mR/Daz13W5a/EUOBglRHi
 kExmKtjN
 Uo/U+2/0GRzvfQxY9h5Yx/ED7kqC7dIPpXQT2/ksMyZkmwy3MVO9tTGu6HQyor3h0AFxGAwpg7yQ1JqNZidSbMqLzPeQskDYSCfDkHpypjQCQMDld1uOHH3BFDj0bpOEA0tpysjbhJ20TuFvarqU8/Hs+LvK/sTx52U9/EhMzwj3nuqEpA3dvf+yknqmg43XYJJzjB3VRIOyB88rs4gUy49L6rvEy5uwZALJ21KySlBTkgflKQQXVt+19moaoTX/1PmcPR1skt2m2675PSkfHPPrx9x/fs1UhQ82ErD+Rfxy3NzaJY1nyKq9XgRo+GwK+ZAv8P+Q84EU3xUCoB/g6Kovr1l9Ofdp0R4tM6xpZSZJ6ZI+HrrcCYdN/w6vOpTUy4MjttozlsOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 04:09:13PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Sat, Sep 19, 2026 at 04:05:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Sep 18, 2026 at 01:31:24PM -0700, Suren Baghdasaryan wrote:
> > > On Fri, Sep 18, 2026 at 1:21 PM David Hildenbrand (Arm)
> > > <david@kernel.org> wrote:
> > > >
> > > > On 9/15/26 03:08, Andrew Morton wrote:
> > > > > On Mon, 14 Sep 2026 15:57:20 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> > > > >
> > > > >> The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
> > > > >> properties:
> > > > >>
> > > > >> ...
> > > > >>
> > > > >> It's all rather a mess.
> > > > >>
> > > > >> This series brings some order to things by both limiting what drivers can
> > > > >> do with VMA flags and switching to using predicates that describe
> > > > >> behaviour, not arbitrary flags.
> > > > >
> > > > > That's a lot of patches.
> > > > >
> > > > > Review is thin and I expect this won't improve a lot.  Lots of "no
> > > > > functional changes" changes.
> > > >
> > > > I'll expect to go through all of them. Might just take a bit ;)
> > >
> > > ditto
> >
> > Thanks guys!
>
> Note v3 has been posted to fix a stupid bug in 1/40 + attack some very trivial
> sashiko stuff
>
> https://lore.kernel.org/linux-mm/20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org/

Just a gentle nudge on this :)

If you guys or anybody else has some time it'd be appreciated! (obv. the v3 as
linked above not this v2!)

I know the series seems intimidating but most of the commits are very small and
it's been in -next for a while.

>
> >
> > >
> > > >
> > > > --
> > > > Cheers,
> > > >
> > > > David
> >
> > --
> > Cheers, Lorenzo
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo

