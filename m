Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6306BCC6B01
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 17:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65CFA6B008C; Mon, 12 Oct 2026 13:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7456B0092; Mon, 12 Oct 2026 13:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48E4F6B0095; Mon, 12 Oct 2026 13:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4D56B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:47:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2E85120C9F
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:47:03 +0000 (UTC)
X-FDA: 85314705126.05.F0896EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D92E840006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:47:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ihX6vADg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791827222;
	b=NNjADGyl62ldIPaAiaPXm7U92jrml1SgZHKRLY2+VEJmUD0bgdRzv3yEPOxTmYGHwAWpnB
	dt/7fDOhvUDuJvLPPD4NuGkxfRm2SFdfmgDgaq0QF/vu//BBT1EWrNNPqdyheEiM9YQ/I3
	lxA2x8tTFYB9MDgm60oZIa+GhgXoD5g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ihX6vADg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791827222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+g5TXryhSnKPgSPaqVMSsv6/T+/UMkqlwUebHC3VUds=;
	b=O/W0ZzBTy+u6wwrFOEbp5xTqLI6xm5Dq1GA/HxB5xYE/D8sAR5Rh4YZoFTXymRlzo+iwqe
	BbZ2sliwAeZmWlGGdBbMhR2Dx3SIWC5zxjkQ7IdYrD8MVf6q3s8Z4jENPU+CfHUPtGf1BX
	5qcGTsI1EO+gXNxeBtz2aCQgdKL50Zo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FB1042E90;
	Mon, 12 Oct 2026 17:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E231F0089B;
	Mon, 12 Oct 2026 17:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791827219;
	bh=+g5TXryhSnKPgSPaqVMSsv6/T+/UMkqlwUebHC3VUds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ihX6vADgFuOE35cu0zGAhteEVahYq066vTf05uMn2wQqi0hmjfZuiiGTMFMR9hWXh
	 xnW7REmcc8e1p3/WcFwjupa8SppqNwX/y9mIjcYy3VHazi7OTmaWgP2V5vUwjHi9I5
	 kNk8dToyKFzBYNV18fU2ztlaDEJQ6Y1VLVwZP7qX7OVegsucIsOL5qeLI+kOAMdpKI
	 5hOyy90zfW/wGKFCnCd4rlbFF+e0fhiASRsSS4s5sjVjyqospM0EHf5F1QM381KtzM
	 1dGRP+bV4orEz850LW6SfHDrkY7tFGGxMVHygnSeQy06A/xo4vxVoddJq6QQzB1LU7
	 8DAZLz8edumdA==
Date: Mon, 12 Oct 2026 18:46:20 +0100
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
Subject: Re: [PATCH v5 07/38] mm: add mmap action for discontiguous kernel
 page mapping
Message-ID: <as0S-4wDLCJGEItq@gremlin>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-7-923b70125b1e@kernel.org>
 <56cc2787-134b-48f0-a9e2-840f57b28607@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56cc2787-134b-48f0-a9e2-840f57b28607@kernel.org>
X-Stat-Signature: sgfpsktjjc1jtrs8iyzbeg3jswfdcpym
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D92E840006
X-HE-Tag: 1791827221-149346
X-HE-Meta: U2FsdGVkX1+twVhwjojGH0DWLp0GBMGUy42stALHQHV8ELvOZblX9yzDsCeI5VP6vdS0nd4nxCR6PXElEeTAomv/xpnUQLKbJG+kD6liivtTVKyMPh4VD4ivq1czuDX5yz3cHriVn+KntljOe11PLdD2c7OrH2FYmwQEkZeNRP4lGeguBPHXffsvdCLLuslFH9Rl4wzrK5eV7Tft8yvx7swBixs9+WbqJqiWREI0itrPYvJNWc/+EuChGQy47niBUx8qFihrRPC4eQ4bUF0I2AgOwpTN96oEeLYtxoGX7V2bTpqxYEgVcBzEAtxqH0rE7fhyeGK/d/RwezMsHMYMPIQo+DXIbEQShPrMWXmfpuUt0vNv6Wk+ybP5eudNOFEmkDIfkVy4jHDr2Z6GnMBNqEP+OYhJ3iq7ZbAGZevz1rTE9dKP8YXZ5n9SkQmK7+BdJ+WTRq4JOwwlotmCQ1P+okf4QJtuC6QNNPtzCtPvQuhKF7yyi0QQvtkh6J/uhC+usHf6IrO+CBLfojJ5Bo8FxHejb5hhINoMaKn04Xp/5bk1pIIzEIY8rNyim2l8by2NavYRlG3WchGH3ZryHG8/u6ecuKpVT+b64O58XzJ/d2QvRO98x88X5Wt0RhyQijIwo7Km6sFfTkO9rGQV0vVk9VwOQ9oqs0/ugM4N06DlzJ1O6yzdckOMXhXsPCWQxkZzXG39izBU1kDMQ966jKcwZxhW2+reqlYo3IRyVaiDJ5HT03ajzDocyJXTpvKk3zKyt5llFDvhXFzBMTZfHa+dEqcUTHFLYMWX3k1KoubnMt3VEgxL94wbyiCyCt0GIzDJ+lmGA5PfXLw9GJTD8LNFx4g04hsQyPYFX6pXNClKEZP1IHTISUnhph4XfQVgDbd3Rh5hYgGtNObh336PbspKX/iroiC/MTh7YeNch+c8BUAW/D/TW4aT7YYJyhW5WjdhnFupk5rsAWr12Cgcw/l
 MU78qAy7
 tc2Oo6fM+EUY45Nf4yFcVZ4IbrxrYr7rCJ2kYlvM6sBS7759i6azbKDB/Arx85TxYG2gfgMYHGI0jACDlbRtaiW2zeAiku4pVS5/wL8s9AJSiKEk+jxxe8Wv79gfEx6OJmFxmUeOxJVtYSCH81zVPTmlq17K/OfVXDh8OjK38FNute8H4aPSDH4FP8FnxO6Pf+JnFARCkt1xsIlEt0kt5bzLkvsQ3AnDDSrHsillpY1acpcrEHzrJ/3tnhg/YbB46Yza9DanQliP6e9FNvAR7VR8j8K/LtEafrDDJSFKSOpLMMlMZwGh2DKIrT/AvobA6YBmpR96WS9LrAzKs+DN+rSSRqjmxDDduPHsD6e+wzuCZqF3mNtlK2UP9hceQYeRTe29GZQ3XxOjWC+5/zNIs7wOyPmbaIlvL1S6oKRJxO3EPJl8X4t1Ziq5mjG3YUQhFGsRLuzfkkAEVnQsIvenW9+dWTB0mdlshtmKW9NGeGtjbzyNEVmPaoB1lnoTk8gI7RYQ/K91v6BppOnxOMg+8VrUYtFGk4CIZLOqhie9x7ve8ipXs+nFe1XA6acMeRW34a9hB9wcjhW6bHjjBWzUBWDU8F+hz2pqQ+anccGd4XX+Sr9re3bNjTP/znFlFkMPhfwpTZRFGuOb4W1CNb/6CzlCCkC9tfZa8mplhduIdb34BoUOCX7TobDUDNXZZOnqTf+qNea8w2qiihyOFfEJjvVNyTNuLBPwO25nGj55WzRpLCK69pwMPMgqYkOgltKny9Bwb4NytJMPApqBO8X/rVDsGsVTWCQF740dNSzxZHL4t98gN3US3fwT3x+gNsy1A2VowYBFduuhuslAl6JKg/aMDKomk/ZRWtyy7Tw95nYGs2bIoMSQXZWV47GMewdUTdr1UOgiTD109fVRit+uBFcpmkcUKWzWekA3LlNHkYujlL3/PomOFdN3MuN2LaB83SZhRLAvLb3RQftQPlbKzVpXlRcIG
 NpcIvDlN
 g0AwI2DcH4cFwq+ofIdzpsKm+xDwwTB+f44V2yHpLBLJnHn9tNsZ8SXASYoFmCJBpY2VbNGfPgrrYst/WoOqM6KMtfjpDMfn+KpQFgSQxDXwI88W29gR2gNRPF2lvQ99A5aF1e8C/tVr8lRdc3kjuTNluAZssgCZ8+NBaYv4YQGpRJKDPNke+xKJMvA2Hyd3EnIdDFjx6nIIDYXgEgoZ3ib4Qe/Zc/n0nUm+rgaGjSYlMsnULXmGCURiH+oHcfCVojpRX3vT68thucLK40VXyaqXvxCr+d4O3/VMxFJEmNkZwWUaUgFVJT7E3GRTUEeoXx6gr1BlybzmHFYs0NpX0LP1wDHK9b2CQizu87XG/cst7R9Sarct6VEtOC02mVS+x52rZtGZwU6GGkboCfHJXlrJn+malIls48fzr1Uu2mF46zOvB27jdovKN0CFGPeOfdx5EymkkV0EwcqOR9zgxD7ZESRPbWmlFtsZgSp/WwlwB936lNBcI2HBVXdhvK5exT301i8N4BKHqK7+JPatHcveedHDrrEFdohSxTQZ05nKnAHNZH5Ia5IeZp5DNMxG5hltZiaDkFKfPySNq9/Xf0nv4JK4UKoRjhZmew5kgETLXn0Q9AYAUFx1PbfR1iEtaPGpxsaTWy+uH8RbwkQlED0nL+w+p+gml4TdlM8asNfHwZch1w7ZtSxsi6k4BntWAG7eTmt3i0p8E3pwWCUkyPlrQnGQeOVc/0ARDZY5sGTPqg3vyYLpPphF5/1YVTOE/uVKxbtrPAmtpwCzMRMufjYX3MCaDbczE+FDt9yhrRV/OXPnxmZIlY7spxEhtQt1fB31XyuGIzpIpG2/pu8IeFuCRM18u3a7lKHUIR7mhyaF85vZ+B/4gGl63MxSjX9JmrnU+v9QmdgvoffgPjfXoTmUGsSoNZFwMGrbUDf2J1VNoM/WCU6oPICqO76QGSf1gcs44WcG1vxguXTk9RGe3BooZKSEu
 OVmi/GUL
 qOFgbjMgIMgT27yccKE0kUcorCuW3TZ7JJtOmdw3oMFd3ntIxU+AOiRzh/YjQlb/58XCoTVQ7vt1KuZhMuCemIRGkOXPTQ5ugJCKyGh4ZvQ18Sr6AzDw/8Rc6Pq1KDPfPlBY8RT95+FcKBk4r6jtHgPUnTDPjzCRdII2K15FKJy6sq39OZ4TTM/kDLMUQLPnGMHtvRmljhpJG8kX3C2FlYVvmULwSKuk7MSpK4FjfOW5vU4DBrbb041LG13KHcpBQvn3ZnXCxc6u+Z1S9OajohkOnX/4fv+zlPhIkJETREnyOzTATjriOIsZ9xPBEmLSowJoG0E7Q9o/94UivdCe+ZmbBgNYHsaNOCCo50K9zvEpXKT2hlUFl9luC0JA9pDFgWi0VwrTpIRA65zdOMjvaZzNvDb/PM/362YYuDZWSjIZlUVZS+8Df7mQ+54x8KYhI1QakdRbgSJ6hqWRl0kVAMDJ+/MkLxldmM/CDwGW0Cq9o+xQOR2j+EOVbCYeuLo11Q0oNWti04IopEvreqcXk1Dn5Kw9NKyBVxY8iO/iXatOxv8mg7NBAsIH88AwzJTyRQ+byDq+WxICF91damBOy29klkEvS4fcZK1qDQCImY4MFDoEDz4f2rHcVPDL4QRWoYsl3IBKBEwzyK6MR/tKXRfkPpzcweLxPJWbLOYRusVHCsF7ohcmDV9h7LoDl5LCvaruIgLQ6VBN1vHfWwuyCsSGrKr2tk8OXaHrhfRWl+KAohN+FmiX4DtdDqyyQhw5+EexulLbRF9ogss1+k3yz36iAcqhEx9nfbcLvoIV6M0gvaFZYI8dKlbu1HYX5tDRP2+kMcAgXN4zwgAeD2TswvjAqjK0cDAsxz4wJxHoK+Kd9b7sGRD7MKzvEQ81yUUgHP4zyob0Ewxm7hMMkCgtw0tDxtUPsGHnZuaajcE13HMfaBSCbB+V9d5qW85JcGTxh7B0OtPJwP5Kr0MPf7Q0F9TlU48ZY
 rGf/3T6F
 lg6bDBcnQq/kNoiO0k4j6bJq4o02Yrl9ViV7YjBM3wGKXI8C5fgaVHDbk03T8SHjvCMhY0VNTdsw+apMyvkq/2mItLT/nKrujFVITqP14C8FrQEOR55Y4y+NXQq0GovJ66r4MGmpYiZHibW88G5vrrE19Km7uyFdBhoF8/Y9/8e76svcdfeIYsVC98e/66N9KYCpUQ0ooWmK6wbCDCwXvr0YMgRJjBCM31ReNb4tIqKUia3LVHvwHWGaGWce3ADpsl/YHHAIhga5dU92M6ihdd1gS13cfn7ktacqmor29tnDC196+L9xWlohZzdvvCCTXhKhaYaFbxnB8jJQA42YV7M4B7tjNBr0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 05:03:02PM +0200, David Hildenbrand (Arm) wrote:
> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> > The existing kernel page mapping mmap actions allow for partial and full
> > mapping of an array of struct page pointers.
> >
> > However some drivers require the mapping of discontiguous ranges. Permit
> > this by providing discontig_kernel_page_ops which allows a driver to
> > specify how the operation should begin and how batches of pages should be
> > retrieved.
> >
> > It uses the minimum exposed interface to do so, providing address, page
> > offset and both vm_private_data state and a local private state object.
> >
> > ops->init can establish state for the operation, and ops->get outputs the
> > pages to map and their count. Should an error arise the core unmaps the
> > VMA, invoking vm_ops->close, which is therefore where any state established
> > by ops->init is released.
> >
> > Also update the compatibility layer to do this too via
> > compat_mmap_action_abort().
> >
> > Batches may not exceed the VMA, but may map less than its full range in
> > case the driver wishes to allow the user to map an area larger than the
> > available data.
> >
> > To use it, users invoke mmap_action_map_discontig_kernel_pages() with
> > initial local private state and a set of operations.
> >
> > Users can then use one of the provided helper functions to perform an
> > action:
> >
> > * discontig_kernel_map_abort() - Abort and leave the mapping as it has
> >   been accumulated so far.
> > * discontig_kernel_map_page() - Map a single page, or a compound page given
> >   its head page.
> > * discontig_kernel_map_page_range() - Maps a struct page ** array of a
> >   specified count, mapping only those pages which fit in the VMA.
> >
> > While here, update vm_insert_page() and vm_insert_pages() to assert the
> > mmap write lock is held rather than the bizarre assert !mmap_read_trylock()
> > and use the new VMA API so all code paths are consistent.
> >
> > Also convert a BUG_ON() to a VM_WARN_ON_ONCE() in vm_insert_page().
> >
> > The userland VMA tests are updated accordingly.
> >
> > Acked-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
>
> Finally finding time to go over this. In the future I want to have more time to
> review such massive series, as it causes severe stress to be forced to review
> this last minute before it goes upstream.
>
> So if I push back in order to give me some more room to breathe in the future
> it's nothing personal, I just have to keep my sanity somehow.
>
> I hate being forced to review because we pick up stuff way to early. There is
> just way too much other stuff going on.
>
> I'm planning on picking up most stuff I maintain in the next cycle. For
> cross-component stuff (esp. VMA) I expect Andrew to pick stuff up until we
> tackle this once cycle later.

OK I understand, sorry for sending such a large series.

I already delayed it from last cycle and sent early in rc2, but I understand
there's been a lot of volume in this one.

I've been working evenings and weekends myself to keep up with review (and
failing), so I get how thankless it can be (LPC was also unhelpfully timed!)

I will try to split things out more in future, this had a lot of dependencies so
it wasn't clear that made sense + wouldn't just cause more stress over a longer
period otherwise.

>
>
> > +static inline
> > +void mmap_action_map_discontig_kernel_pages(struct vm_area_desc *desc,
> > +		void *init_private, const struct discontig_kernel_page_ops *ops)
> > +{
> > +	struct mmap_action *action = &desc->action;
> > +
> > +	action->type = MMAP_DISCONTIG_KERNEL_PAGES;
> > +	action->map_kernel_discontig.init_private = init_private;
> > +	action->map_kernel_discontig.ops = ops;
> > +}
> > +
> >  int mmap_action_prepare(struct vm_area_desc *desc);
> >  int mmap_action_complete(struct vm_area_struct *vma,
> >  			 struct mmap_action *action, bool is_compat);
>
> There is a mixture of two tab vs. different in your changes.

OK. mm is fairly inconsistent about this, I will convert all to 2 tabs.

>
> >
> > +static inline void
> > +discontig_kernel_map_abort(struct discontig_kernel_page_state *state)
> > +{
> > +	state->action = DISCONTIG_KERNEL_PAGE_ABORT;
> > +}
> > +
> > +static inline void
> > +discontig_kernel_map_page(struct discontig_kernel_page_state *state,
> > +			  struct page *page)
> > +{
> > +	struct folio *folio = page_folio(page);
> > +
> > +	if (folio_test_large(folio)) {
> > +		VM_WARN_ON_ONCE(page != folio_page(folio, 0));
> > +		state->action = DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE;
> > +		state->__folio = folio;
> > +		state->__nr_pages = min(state->nr_pages_remain,
> > +					folio_nr_pages(folio));
> > +	} else {
> > +		state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE;
> > +		state->__page = page;
> > +		state->__nr_pages = 1;
> > +	}
>
> Why are both separate? Isn't it sufficient to represent that through _page +
> _nr_pages > 1 ? See below.

Ack yup that works.

>
> > +}
> > +
> > +static inline void
> > +discontig_kernel_map_page_range(struct discontig_kernel_page_state *state,
> > +				struct page **page_arr, unsigned long nr_pages)
>
> Is this actually "map_pages"? A range is rather a number of consectuive pages
> part of the same folio/compound page, no?
>
> (we call insert_pages() later ... )

Sure, can change.

>
> > +{
> > +	state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE;
> > +	state->__page_arr = page_arr;
> > +	state->__nr_pages = min(nr_pages, state->nr_pages_remain);
>
> So we expect all of them to be non-compound?

Yup this matches existing insert_pages() behaviour.

>
>
> [...]
>
> > diff --git a/mm/internal.h b/mm/internal.h
> > index fc4e249e2343..557e629db8c5 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -1515,6 +1515,9 @@ int simple_ioremap_prepare(struct vm_area_desc *desc);
> >  int map_kernel_pages_prepare(struct vm_area_desc *desc);
> >  int map_kernel_pages_complete(struct vm_area_struct *vma,
> >  			      struct mmap_action *action);
> > +int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc);
> > +int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
> > +					struct mmap_action *action);
> >
> >  static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
> >  {
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 448342883e9d..e5c1d1c35bc7 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2599,27 +2599,34 @@ int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
> >
> >  	if (!range_in_vma(vma, addr, end))
> >  		return -EFAULT;
> > -	if (!(vma->vm_flags & VM_MIXEDMAP)) {
> > -		VM_WARN_ON_ONCE(mmap_read_trylock(vma->vm_mm));
> > -		VM_WARN_ON_ONCE(vma->vm_flags & VM_PFNMAP);
> > -		vm_flags_set(vma, VM_MIXEDMAP);
> > +	if (!vma_test(vma, VMA_MIXEDMAP_BIT)) {
> > +		mmap_assert_write_locked(vma->vm_mm);
> > +		VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT));
>
> I would prefer to have these changes in a separate patch. Or is it strictly
> required to have this in this very patch?

That was because Suren raised the 'assert on mmap_read_trylock()' thing and I
wanted to get the other cases here to be consistent.

I will split it out into another patch.

>
>
> > +		vma_start_write(vma);
> > +		vma_set_flags(vma, VMA_MIXEDMAP_BIT);
> >  	}
> >  	/* Defer page refcount checking till we're about to map that page. */
> >  	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
> >  }
> >  EXPORT_SYMBOL(vm_insert_pages);
> >
> > +static void __map_kernel_pages_prepare(struct vm_area_desc *desc)
> > +{
> > +	if (vma_desc_test(desc, VMA_MIXEDMAP_BIT))
> > +		return;
> > +
> > +	mmap_assert_write_locked(desc->mm);
> > +	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> > +	vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> > +}
> > +
> >  int map_kernel_pages_prepare(struct vm_area_desc *desc)
> >  {
> >  	const struct mmap_action *action = &desc->action;
> >  	const unsigned long addr = action->map_kernel.start;
> >  	unsigned long nr_pages, end;
> >
> > -	if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
> > -		VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
> > -		VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> > -		vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> > -	}
> > +	__map_kernel_pages_prepare(desc);
> >
> >  	nr_pages = action->map_kernel.nr_pages;
> >  	end = addr + PAGE_SIZE * nr_pages;
> > @@ -2640,6 +2647,98 @@ int map_kernel_pages_complete(struct vm_area_struct *vma,
> >  			    &nr_pages, vma->vm_page_prot);
> >  }
> >
> > +int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc)
> > +{
> > +	const struct mmap_action *action = &desc->action;
> > +	const struct discontig_kernel_page_ops *ops =
> > +		action->map_kernel_discontig.ops;
> > +
> > +	/* At minimum need to be able to get pages. */
> > +	if (WARN_ON_ONCE(!ops || !ops->get))
> > +		return -EINVAL;
> > +
> > +	__map_kernel_pages_prepare(desc);
> > +	return 0;
> > +}
> > +
> > +static int apply_discontig_action(struct vm_area_struct *vma,
> > +				  struct discontig_kernel_page_state *state)
> > +{
> > +	unsigned long nr_pages = state->__nr_pages;
> > +	unsigned long addr = state->addr;
> > +	unsigned long i;
> > +
> > +	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE)
> > +		return insert_page(vma, addr, state->__page,
> > +				   vma->vm_page_prot, /*mkwrite=*/false);
> > +	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE)
> > +		return insert_pages(vma, addr, state->__page_arr,
> > +				    &nr_pages, vma->vm_page_prot);
> > +
> > +	/* Compound folio - have to iterate through each page. */
> > +	for (i = 0; i < nr_pages; i++, addr += PAGE_SIZE) {
> > +		struct page *page = folio_page(state->__folio, i);
> > +		int err;
> > +
> > +		err = insert_page(vma, addr, page, vma->vm_page_prot,
> > +				  /*mkwrite=*/false);
> > +		if (err)
> > +			return err;
> > +	}
>
> Summarizing some of my comments below, I wonder if this could be:
>
> DISCONTIG_KERNEL_PAGE_MAP_PAGES - array of individual apges
> DISCONTIG_KERNEL_PAGE_MAP_CONTIG_PAGES - 1..N contiguous pages

OK.

>
>
> if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGES)
> 	return insert_pages(vma, addr, state->__page_arr,
> 			    &nr_pages, vma->vm_page_prot);
>
> VM_WARN_ON_ONCE(state->action != DISCONTIG_KERNEL_PAGE_MAP_CONTIG_PAGES)
> for (i = 0; i < nr_pages; i++, addr += PAGE_SIZE) {
> 	struct page *page = state->__page + i;
> 	int err;
>
> 	err = insert_page(vma, addr, page, vma->vm_page_prot,
> 			  /*mkwrite=*/false);
> 	if (err)
> 		return err;
> }
> ...

OK. Will respin for v6.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

