Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF337C79FAA
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 07:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4686B008C; Wed,  9 Sep 2026 03:38:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756056B0092; Wed,  9 Sep 2026 03:38:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6586B0093; Wed,  9 Sep 2026 03:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A81A6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:38:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00AB3120133
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:38:06 +0000 (UTC)
X-FDA: 85193420214.07.EDC377A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1A8974000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:38:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=fMvwOMtK;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf01.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788939485;
	b=KqKEOgqVQ86xwG3eZZtLBUw/ABxbLL7JUzDPiUlK/wy5XGXsIOBbhWqFXBmiLOt1LiRw/Z
	/SOo6Ot3axa3/yXRf4blflqEzRi/6WM/GueW6LOuEOClL+GEjMR6XXEC7IqNF4CEl8Yi3c
	0nPZdfUI6aFz2YGPL0VOuO6/JnBWhPY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=fMvwOMtK;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf01.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788939485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7WoiQ3kTHyw/Ii8U53W3jB43VLKD3M/+zE0Et0v4Dk=;
	b=tTeKNHQsQHd5Bxwlbws2EFbgZRRh6DowQ8bCenvv6aYTakvf605WaLqz2AfswXIGsuMuVz
	45cNs7Ieuetay+ECRe/Rno71r/uJvsovXPu5ZEhUYPE08+7ZBdTAZTL2sUPEu5nhJ6oZXE
	wxWeUQV6vl1f6DM1f3Lwr9ptqFGJABg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63EED42E6A;
	Wed,  9 Sep 2026 07:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8484C1F00A3A;
	Wed,  9 Sep 2026 07:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788939483;
	bh=z7WoiQ3kTHyw/Ii8U53W3jB43VLKD3M/+zE0Et0v4Dk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fMvwOMtKjnQJHWqbGOBFRkxLXNBsibipPgj2Q6P064WQJWMW7wfdq4gqVuVvBLOBi
	 mw2LdSGq7nWqdIa6eYDVqIpvJUSLUA2zonOikKUX6K36rwbteoOJo/Gwa7LLNDfbhI
	 EHt9w7bjV4yHdhIGfrHtCRftSsoS+o6rrCDY1usY=
Date: Wed, 9 Sep 2026 09:37:54 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>,
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org,
	selinux@vger.kernel.org, linux-sound@vger.kernel.org,
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH 09/39] drivers/usb/mon: update to use mmap_prepare + map
 kernel pages
Message-ID: <2026090947-daycare-gentleman-9796@gregkh>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-9-dacf19cce22b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-9-dacf19cce22b@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1A8974000B
X-Stat-Signature: yktddxfete4eurr1gcroyzgoxmasru76
X-HE-Tag: 1788939484-56347
X-HE-Meta: U2FsdGVkX1/ZRODySRIKVXv+wQOELHwuM5SVNxD1/NUucY73Q/Kz7fA4mHeR94mxAoGXcJe5Xex0ytKSXf6d79c4hnPF+ZBnahV4nq6JIVGZubtX/Cpw8BdEUHS9zdhM+C3CJHCFtYgsbtFUOijVVn1K0nMcLuBaaZt+g1d4HOfbg7SWYecn9QFmlXF5Y9XMcNGghtm8utQ+bkABxgpeZvOQ0AnqUJIem8aZfHxB39Bww/8bW4pQcrFQagFdQYNOxd92+tGpU0Lq3HhQWu7SETvt946Sqe0Lysg+RERyhqr7ThZnqwL4EmvujmIIkSeFSDA+fz+rUTyjme9eMnwg5noVAbf5sUFuHJum8DYYnSK8CUubs05Jx08M52ofNpDslReep5RoKTY3b30X15Pz2lkmOc5pYWQwtmpnzlUpnlXBkwro73Pl+eRXo6e6akhH7T23HkXZ5S05FobxLTRIKkAYyt/aRgV1xCJsSUgun2VdVArk9dnMFd01/GU3+oH/VmWsx9TptieaqXw46siY4s0XyVVg0kEePX9pQ/xIOSLIyj8NX0B2yMibEwMmq/q+nROL9SEIoVDdIhFw/ThCN1pPYtzZDZ9LF2sZBrWn6Jus8CHEbQSw1UtJL4W2M/FiBV58Ql+FJjps6lfowEZYYiX6X13GrwbKcs9pS6V81TIyt19MALTDUhgbriJeNPhuRVo5MyuGLBAwCrs94Tqrre78NfE/0+ip599o8WS1ZSF92UhjILCO4OyPO+eRW2Abj2d5vBePnCnI+fXBjf+e8pT/T/I2rv+UwYXZCRY+ylKy/FrIhjOb+DX4r7HdbO4gRKNVlwCJKg5k5Aa1gY07hzbuWLnvE4fR2pRDGjlM2GmyvLPXn83IXcOAj6ui4ERmXrpM32SpDzt5wkjaRE5ItZxINvEI+s4qit05dhEs/UmZjojgiJt4Hdvf0uOUhR0KHmeu4gK/z+KNaHAQQOq
 HM2XYVNA
 YMOSA/H0CkV1sE6ldZei/nbNfxrDANGCqhAK8UkrGqVI6JM8/cT7QXfTkUCfIwn/TJUJ4uWQsQKFL6hIfMCxviFHM7io1p7BB5icV07OLQponUg1KBI3g11vqhAK9AFuooRY19jfcjwLdZwLb2KLTEl/iIRMJjY7BDjVSM6MObbACVg0qGiVWnGNexqCADjB8bhWGzXdLkd7q8K2ivkFPz+XfdonQ9gTXa5Luz8vygu9CZWgVx83dFCbwMWYX2eFC+WTXmBwVaGElCXozVs1glHVJyp2quhkzht0MlYYWFoJ995Y7+zHP02QsHWpIb5RgBjr9anufiFGU9EglJtuWdUuNauLVRNAlGc1PW4SG+AJnOpWy33BYjIWj58XoRa0F64YMdc86AAgFDVqe6S7toQ+ctrJ7AQ97G5FnqIk8HPdzvX6YZQbFA/kXRa69Hzh5uQLnzD1EMttG+CtIqxvU9rRCYmb1jSLGI6x2F/m2yVSNNOTyKGjqXpvHKL1hDdupRuwksZlqeop/FTeGMswl+BZvDyBA8lAWXE93ihfl+X4rUVwLTrA/4jC6fsU4GvbI+2MeuHkrcucfcLudh2yC2AdGWXb8KvvtQE1UOY//CIPsk8F3G3wLUXZ19Iv4NErGPvpSLnGbyFENQ0imZ324s8AtVtI/3KU6VUxDZDQiGFTd3+zGC/GLyRbbNW36PAYGQrYL22iE3SEfGSeTeIXP6GgCXcFXH4z9TWAAeSKFcUGCLqQyvjMnNDI3wYFzx7eym+Sbep1mx3m28fpO6pOaq245Bd5I3RrL8A6/YTNq3yP10W0uIGuoQUpbjN/pu4ST15aHAmN084vDQQde808EJQbgBr4MAW1O1+R/JutzKl0eHHB/0mCZQ+t6dUMaG3i6HXoIpdq18WcsLe6Mw1302idsYEzEILLaQrQ49ibZMQuVP8pMddVep4arLM8siP8LeWpurG1y7DvTzcPXjoIuxI+iRnv/
 YFQ/GZHV
 ggpk+aP/K8Hep6yMNgXl6DySy2j0FiYYVaNRMVMDIV+D99a3cwjk4CEQT9F9VzlUpPIQfLAmSfUgDzwLdtcFnicZ9AmQ1GtOiStLUTUGCVMbZAHR1D6Vfh/oksgjZqwsh5S6dFkTmp4vcymEKDhuCmtLuzKyGgmCdeB58nrxxVEvge8R+bs6hJb8JNKjS8Y1tCj8LYfuSzYzFf6Kf2iH3a5xlqYy/hKWx2ywt8fSgjKO9nes1ETAQvWVyijHZKxCG9EbikAMR11IhmD2R42RC7UKojn9MGu+bp/3eNsjKXWnpk/c4AO3rHxEKsMoWMzihY+Oos9mWuoBnkVJkb+8CS7X7dzfkweSu6fWuJevzsnZ+IUBr9CDR2FzXsrq5lk6orzKIxGnmtpuKImCPgBx4mhZJPf4Wc29RtfuLhz5rv0bFtQWIneC+UnMfB+pHT6VeMeVdSzXhcamc3pNKO5DsfJjJ1stGTj2Utrrhk2EydztJOlqKr8NOl9tiPKQCwD6vMfePfsOAhQhotTRPppsnnBo8J6NgSWb8Fdd7j7tnU57+azlLCYYXM/0p6IodFYHmN/TApwiYFXgIzgCdtAhYVT/F3CjBdrvdfMHI8Vs7QnSCD5wo5jf43xBP5JKyosIc995cWxQabUq+pRYzqFxwx1JtX6x80ImgFrgupZXk6M7y7RZgF0R3pjOY+NSWjEXTqNF4jvvxZgkNBRKbvSApxyumU0N9haH3QKhQZb+kprKOcidlnkgu1ppArFgYNucPafEsC4CyaZk5Me5HhF54IGNZsvX0jxKbtHvJeqOV9kq4u6O73l5Nysh0tceO57qcm7N4SM7a6dxALJ/EwoPfg/MsAWs1bAPSQskDNmMDZvrqQVuSJxt5hAaf1zQtlEN6TaacCRVNOD1/AzlxBdsUpsDQQZsCuVN49SVxtsYNjfErflIkXMn9Aauf3HaFbU8mqoHrVLqBsb/0xoYMYTHaeBafwQT+
 0o2P5n3M
 NmNlVKtTIsL5s+VjKbin5oiySM3BpWlPILNpHbx4A1ZNNPJ8so9mh3KQSfGKFuvCDO/YFePplvgNVub1eNw0Z/YwZ5b/NVR0W0Lzg7lIwj3Kbnu99lwhVEcJM9bAS3RCtIakDhtXv3elnkgV6GxzCBxcyIzSYhL0K5E64c8gaj29x9lS5tPj0dtFb591X9z5zexl5iwESRy8QsRF4DB1KCdfMW/HwEQ3ZzjRI8ImsninnM9Ep+8b9ZwfVbQBkzIDUATRIYPcisZTOMFuHMS5XzihonP6ZgQf2m44OOdkaFuk7VB7PpXmJt0YuU2HuT7M+yunKhCR/J0Sfln8gAVJO9CN3Z09ONuQP8HZlt7AEdXq9QAkrHKa5rM54xVxj9gCwNEO4hb6aZAziZdqwCjtZYrGfZBZYoKCjJbU+9jmOlQWGVMge1Daquax1x1Iglq64vzVGg2nMqfKtGahxhTfzzJWMoxqVh4DNZITVChsGQKWLbIXYvGOQx5h5Q36U2EZfYDlpI5KgvNe3/SgED9PG+nnf0Vvl1O7Wfn5uAlpvjhNl6mbrvl1zyIVbDPqMNt5WPUiujGyvckNEd1a2OE4z9aT38vXW2BkcKcxC8maX/icTEzOhHbqmUpFy5IxJdS6ANycuNb3cRr2Nbwzn2b80XeVfrACRyiTh0vUg+5OIWGM80Y1p50IbhO4etcEb5Am24FIzuKINqcrnavDpMgyaUvl1SrHIi11KL/c7n/rFGvKiOhx4R9rAOZD2m8Oj/VL/U2ObPdcOYG0tgtQIGIEiq6duDl0JwlgUYLGvYu+9OjjmeRRQU+K7vnEB1Jd0uMxZrpyqFCFPXTocBfvyaamkCiMZCgvpHsA78OIAt8/saRvDQ4KDilNdxAH3Q4Ppn3UZvWq7uCe/x/T+GFdybjJr+dOeMn4wpyw8hBpAKKWRnDHI26SlvpFdHM5oF+QCvLkhvQ782Qyy5lrDiYx3nOv+LrNZfsob
 3Q8UyRdi
 +7InlRn7RR8bW1HLo93LwNMekxICe1Q7W3TBOx3uOnDfXCzxEblQgDYAVb7kBNzgfCZEC7ENrrS7JQrp12c/UwO7P4Q+zVRkj4b+ozTZK4rk+Oi78XwEkkSWqDFalSEZildWEIXy3D6Cruf5Fcswr+cOM2enw/KrxUBhjN6v7bbB5iceNUJem2Xw7WNZkZ1PdvrN1DrrlIBLig+lJspIbxJIgWwf6iSnJkZyz9yD6XoK3rWX1JtLM7lhKDiEqvibe/pxtuTyOrgn3RWnavVSMbyT9Pqgk0OyfsGnbUod9UrjURo+ytCo8ox+SeWhvliBAQbGf/L8RijfzAo2BtZkBv4a4z3eN5nFG0vfSN88knd0+7Dw5GElueZfLoHwfn2cLvmIutcIjAr8dV8S+nKfA9sfWEIsqrZOW5OMhqIepm753QaRQQibiQnOEjUhw5NbEvbLrKkqMEfp8mr+iUMILml528o4fApFYiuk1DpvZnFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 09:01:13PM +0100, Lorenzo Stoakes (ARM) wrote:
> Replace the deprecated .mmap hook with its replacement .mmap_prepare. As
> part of this change, additionally take the approach of mapping pages upon
> mmap rather than providing a fault handler.
> 
> The page span cannot be mutated when an mmap mapping is in place, so this
> is safe to do in advance (the MON_IOCT_RING_SIZE ioctl operation exits
> -EBUSY if it's attempted, gated by the rp->mmap_active reference count).
> 
> Utilise the newly introduced mmap_action_map_discontig_kernel_pages() to do
> this, which allows for iteration over pages in mon_bin_discontig_get().
> 
> mon_bin_discontig_init() increments the rp->mmap_active reference count to
> stabilise page spans. Should an error arise the core unmaps the VMA and
> mon_bin_vma_close() drops the reference again.
> 
> The vm_ops->close hook implemented in mon_bin_vma_close() will ensure
> correct reference count arithmetic upon unmap (with mon_bin_vma_open()
> accounting for splitting).
> 
> The existing semantics are all retained, including not mapping past the
> range of available pages, with a SIGBUS being raised in a userland process
> that attempts to access past this point.
> 
> Ultimately insert_page() is invoked to insert each page, which increments
> the reference count on each mapped page. This mimics what was being done
> previously, only we pre-map the entire range rather than doing so on
> demand.
> 
> The existing fault handler did nothing that required demand paging, and was
> presumably implemented this way due for historic reasons.
> 
> One behavioural difference: pages are no longer faulted in on demand, so a
> page discarded with MADV_DONTNEED is not repopulated and a subsequent
> access raises SIGBUS, as with other pre-populated kernel mappings.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

