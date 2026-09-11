Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20549C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 10:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017DE6B008A; Fri, 11 Sep 2026 06:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0BCF6B008C; Fri, 11 Sep 2026 06:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFA406B0092; Fri, 11 Sep 2026 06:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B1F026B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:13:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 62E8A4017B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:13:49 +0000 (UTC)
X-FDA: 85201070178.24.69C3203
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id AAECE1C0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:13:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VXiIsYXG;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789121627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJ4osXGfnva+GsW9Xj6wSlPvmOYx8+Z4McGwoEWWU6k=;
	b=ZjHv7rNfq2FpnZ/AeM1s30+lcpcP4egDF2ZawqJGXcqrvxcxwraHiOvholowDpCEmvTDuA
	+wNfEIdsQMwOzgYe1gwwgESNzd3JIZDx55+5AQ9C1PTG2H34iioMc53uwtmLfY+eLrBfbv
	pOEP646x29OcmUtRUMyptkS1+8f8Ds0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VXiIsYXG;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789121627;
	b=qS47yHT+16HJFRfPAkyLiNB7WXj52X+qWfp6OZpWJKa0TwowS/3CV5Eck4lL+Df5nzK0DC
	LZOdYM9/0k/X3hp9eQuKx4I/BwrnlgM0q/J3GG+xfovYx9IHUwj1+1hgquZuz7+PUisVlw
	wHlAPTo9v6x7paWlNgTE7Ny09FFDdcE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAAB660231;
	Fri, 11 Sep 2026 10:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F4F1F000FF;
	Fri, 11 Sep 2026 10:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789121626;
	bh=AJ4osXGfnva+GsW9Xj6wSlPvmOYx8+Z4McGwoEWWU6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VXiIsYXGW7V+CUC2hoUUxshBtk//170ahXby5qOmnHCTEG6nprU1IS50u25G/fRQk
	 sf9ytH2Ce2iGqonEAUfAmBNxEiX0H5gDZvz851NX8EhIuDaWSIQBlPZWYHnVma0aGj
	 blDmI4LY1KM28dzcRxXSp3rNd+ml+k1Jf5jXcr5BNdmFsP+f0lE+KyInKD5utrTv18
	 j0kWa0ZAaMlc3Pw4wRDO2h4SoWYRal6ZvW3YmHkVxX6gQf6/JqWhQp1QSVXE2Kca+2
	 BYYLTVktrg9Xqy9CLQ0dyOX4enXiqnPzEjwUfsC5vJviK7A/gYwNlJA1GGOz2i3bhy
	 SIFHvCnClRnig==
Date: Fri, 11 Sep 2026 11:13:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, 
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
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH 11/39] selinux: reject writable opens of policy file,
 drop mmap shared/write check
Message-ID: <aqPS_UHU3MotlchR@gremlin>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
 <CAG48ez3Ucb8HyhjC1-fijFiYJsnWcTLYHvJjzMyU710mgegxnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez3Ucb8HyhjC1-fijFiYJsnWcTLYHvJjzMyU710mgegxnA@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AAECE1C0003
X-Stat-Signature: hnkb9j8xmusrs7i37d4k6kw8p7jto64s
X-Rspam-User: 
X-HE-Tag: 1789121627-832755
X-HE-Meta: U2FsdGVkX18Nw8tvnIJM6o5g6vy92x2FdLO1oimmhA0EzgP8Doj0vu0PeB5sDKWjh8JMxZ4/5uU7pjUXNOKNvq22ue1QHhiT3u4lB0jII/Ibda/c41G5P+qpsNWYjMND/XWLeASuwqO7ktAbnh0RUqruH5/6KkDKImA+zW5jrcQNmuP4n1gub5MvjIbjqghvHTzTbINN9v7Vz+ww3g21yGsqIaeye3Xwaqj5Qxr8alLNALubVg4ZI58+qmUJoij+aw3HMKbErSIdzG/xDMhr35YiqQcBVtTVbSP7b4c0P/leqp3nm2q1TiatsnSwS43dwNedd5UMlZlT+7SlwZTRDP+GTQrHKr5eHJjlxYf31ZXj53GUA7+uxxbPW4HUDnZj6eWkvev8q+zYwM+EIFuPChDc1wCp3QR7euCB1aH+eyIIBpMIDxBb+azPMahvvHdWwLZ48z1UaYnBPhbuMT3EAo6Iubv7N2ZpLhZx/U8sO8CHmsbrhmKvc80KwMjnCk5Qo9z3QHyNeTxbluFnPaWFt9Ojvm5Z2e39yokPC7Xtw0lkcBVxtZme0hdvhT+FteKSQ4RXsr6XUG6BZ41t63HAEfvUw2TcWoJP+6hc9fH6zev9XLgZq1l8jERfaFgTBwikZAkX8rGyPJe9JOXYsbc9NAH08NAI2ssP+jdYVkzh7GyV6AUiL/Ba8g0/S54+mpTBm0ISLraGFSQhC0MxxqGxp2MjIlqCWS4s0UfR+wZ9/7pnPnqhGi+i+TDrTAdidUmfjVwdXkbpElGceE4CoQoTMbs6NfbFy+ic2w3hI+m0YKpTRqgjXfOPO1X3WQ1q/DauxBXsASXV7NrjrGpRiIT2h/MzbJHMkt6yxeFj6hC2bgwPC4h0tzJgchqbhHl+AOuwXNnm0idbjyINgO2aWYWQGX6TvuZ1TFWzlUUtGSJoVqPxn/x0Wz6vw+MdgbrXnWBwsgQlE1mERtyCv/hvUnc
 JvQNjmOE
 1+9qGsJvlLGaAnZfj5F4INHIhCwTmytm18GWvDI8/fcvPAq4VyxxLbD7EKFqmg7/QjaXgIHyIuPW2xJonN0EVTvrtQAsTf6LZJ+ehf1A0Ve/15esS6v7zwiPncl2EzWA7PnwMWDoCJa2EejLwMQNvd4V7D/sQW40SV46Xjdx+UQRiZaErisDKTts+3hHYQ7ra6blMFeCmGJN/lotLeQGfjNfoVt6YqBQ+OfTNRizKAaqK9b022FIXxyTBDTq6EehFTLElG9xgn4BvO7AkrHQrUaNIkXoFnnVK+f3o3XfC71dzwnYLCasld5ZZz5+in43YfTQ5e1SaRKPSCPiJoteyBkgsTq62c6XRTF1nl6sU63HXreo1IebbYGIdxeGp478NWKHGMm2keTySUZb6OJrKZAWLyyk3QoNRK4wf74NqPCQWw032KfNu5z4br4X+qhWoR2ECjG3PFt4NAqjHxedEmQoJJzVjGJM3SJf30Rq+tlySXrAlKT7JinJMhTbuZqGLNdM7OSc9vWK1QLhiOf9J3ngnwVBXlaZ4HkgzG3Sv9FCoRXX86H+Ygeqrz3uoaH4Ny0Ix9wdBuqo63o6mg7va44HGtt6LRoV8sRkhfROkkqQwceoyegWKjY5jZT/Djm0FtMpDiQZCFDkpas0J9b5GkWi6/G67HbWfqeVMUZ8oj3d+gs5Ba4EP3dsIvkUFK/HmPUDmnkOG9+/n3abJWgAPgmT/VtbZfbKcZ6uy5mz6Fm2bMqqNoOinC6ncZIB3Rn1UL7FfW4Gkx12g8FTMFST0uCvfoM7h3tz+ZQWbiiWKHJBw9ybUOon5UCHUKkbOyNNpDXrOtjua83cYaoi/Ue1Dl9fTUNnBwp8k0Le20QOEonVqvaMrrMMMfifulsw4375K1pVJvrUNixkE82lQim6n5DsU3bGnwesWa2f9jqZjnZzw7IZR5whe79xKkOMBoxxEKFKGRScNdMMda/Cw5zRFaP2GSaTE
 5bLz9JXq
 c1DzloUkfpJXhvzcW6iJdW0kbzZJvsVio3L0DbCOAI53Pt76/IDJLqzAVdzR3dyBwbSzgBaWx05tOZvgS65vb/V9kVOkomseVn2D5Kf1ZSHrVyx58wZDwXLulhVrYi+r5X2+i3WSnCKzl8Ap41VpDbnPb8qwXBAQaQ63YULi8jM8AgVSgAU2zxpJTi7+fyVt0FdorLcOyMaDO7NIFHM0M3MCJs94tl1GHgerGaHpXk1bkJyoZBG9Cz4PXGW5sc3juvb8uUUuxuOUgmhWs/wVtvZ302Za0ChXJguLSZTQwLSv3mmEgK4KaOpHp6oE5ymWEueqWGRb/6UomEA0/YFKPFbOYKYDnGj0URAJa3Rqqg69hL2vcfj8ZDxuIzi6G33YRajcBdV4TzcusJT2fvY5VgqhKGCVx6qmOoTCZUOUIBbfNLH0it4Gp1iewzs4Kpt36pRxIV5exL2kQ+A9Xkbbulpr9OTU3DyT39GSjmR03js/b9W4pgszjtLhbi9ztSLjpZoDKrsE6ZW5ZwPPukxiFV0RYjepWJpYDpkyas94yguc0cAKaJ9QsEwuiKqavKqFcOEtpPAPwIgAawwv4J7TILNmZecd0HrbHdoIDMCLjfC57shG8W3EVY6HnpjJmcIINOeTyAtl5Oics5xsMpqP2vNpGD76kCweqZv2ewY2WzaQ+ymP9tDatdZpwOxJqbDVuPxmo4EfY2K/RIQWOiu15bQSv0cp0gJftUo1gmdScAcsnsqmLoPZbuSxnvr9wfXrlB3acCg4r+dAO3pQ6em+N78316VuiZ24e71BiaWqmnwr5LF9ipbpBOpDxA8FzKhiNIHl3P7Lno9yr3fRj1qCF4o0paomIV8sMvt8cxMQUf57gk7f/1xvngWeXcICHqEU108WmF/G61CyWCPul1pyvXGHVqYsT+9Hbvh0Qvz6lI73Jwg/hwus3xJohOtWHCm7Em9vEwTC9nfy+Km2O3x3gInoGw3Ks
 VZjmkU1D
 Xb94dRHglD3r5pyQq2KixJTbgD1MPCvsRE14isKc+0aoRM5ygum06tXTu1gqMyEqgwqZSoZEBM09Oc3xq9mXgf2hl5UTDNmVNniJxEnRKrFOF+KRpev5jiVJUX5bMjCyoV1yf9PYtAGw1w5lyT8D2NiTnLjvbUPufhwjv9DBq+Yxr9RzjTEahV01clcW5PCTA0C7+BuPeT5h6hvtcB9NiAvXMmHGoWQZPS3LZFz4BYmYuSQ0K1MWGQi1KhUJPKcDYjeMfoZTJSDEF7VeuqPBSvy22UxvVU1fPRetY0er7wFMvH2Ahh8VlOQTNgf8eoJ8wwsV/vRjh6Tygs+guPbGRVch5Og/ucfS0ieZpacLrgd3PR73pvCC5aB/2mVdSHP8ZD/qudZYgHihngj9E41pI7h7fgDa8WOTAWVSFoG+bFL/97pd+GK8W8CZiSKS6ZgpEeBxV5m3r6VxewKRYQECBtt85JnmS0a+E4OheQckMc+sfPfuJwHzVHPInsmfECRbnuERTricV75uO6WED2tkN+YMjNFQNImyvixvmjGZz89Tp/vcQdmgATgvEEL0cDy3ut5yNg3Dxcc6PsqL7HwlWi5uc88IrydgdkZhEfrCoFf4+AB6zKKCZbGfZMqbjB0Wj+zq0Z6c+qqdhbYRzVacvZCdZ04IFyeZdY/jEyj/G9A6RK+VDFSdUE1fvf+uQ44WwvFpZwDb0P4USDw+qYWO9kWbRh4aj6hXLGrfXxHLSX5ZpgVYLLj/KDnjMT8o3g/oOmnh9he9nWxSHAiYBQwOigZb+7LgCRWYQ6jw8kiLeqjg9hdiAPw97Ke5VWYLB5cwzuqwVxlQEA06Duf95vwtXU8W/lT+KxutjapeH7WUfzE6dparNOYwgGbwy/k00caCUE6nQD3FavZ319Vwx9usEeilGz+X4RMjvhXPM9ni18L91maOy5rzY+BWoOy0iaxo9UH2BkqpkDsa0ggrUnfvTKgduZgqA
 wGA/Sv8e
 8n34lp9K3/NGNf5rQJdcbs8yMFNmbJPDUn2aeWbmsRqoUz9PT/coXFf7Yw+26d8R1yravw0bvBa5hE9WXBMq6KE2S631cvRE2gD/q7IrKnEU9GuV15IOtwtIzjLRY60irHymAx231zeICLrvxm6AYyCpgcM+zDaHUuy+bzixRC6Rvu/FxSiRYwskCCv7O+GwUgtMsz/xE8XclJHr10QlTZOyt6qxNIjw+0/tzPN1zFtmkDhydkmlnm8aT0iTgWQzqvic5WdRGIJVUA+K5pRq5+XKy/1XijpgcSNK8ho6tzNYKMdtGCcHcnQricOCuYR6d2VcCeujwLDwlfhgCJTrPDpigc82vebdMdxwa7K6WQ3SlESXj39MnN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 10:22:20PM +0200, Jann Horn wrote:
> On Tue, Sep 8, 2026 at 10:07 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > The policy file has no write method and is exposed read-only (S_IRUGO in
> > selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> > CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
> > kernfs does.
> >
> > The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> > clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
> > check in sel_mmap_policy() cannot be reached. Remove it.
>
> You should also be able to remove the sel_mmap_policy_ops.page_mkwrite
> handler, which is only for shared-writable faults, right?

Yeah I think you're right, though I wonder if it's a bit out of scope for this
change as it's focused on removing a VMA_MAYWRITE_BIT clearance for a
non-kernel-owned VMA.

So maybe one for a follow up?

>
> > This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that is
> > neither a PFN map nor a mixed map, ahead of the core enforcing that only
> > such mappings may do so.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Reviewed-by: Jann Horn <jannh@google.com>

Thanks!

--
Cheers, Lorenzo

