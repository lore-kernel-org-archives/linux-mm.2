Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5561CC6B01
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44B86B0098; Mon, 12 Oct 2026 14:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5FD6B00A1; Mon, 12 Oct 2026 14:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996816B00A3; Mon, 12 Oct 2026 14:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6250F6B0098
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:54:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF3A91A0E0A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:54:05 +0000 (UTC)
X-FDA: 85314874050.14.C77DE91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 14E338000B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:54:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cdad94l3;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791831244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LzN6QFYSsA+fcmS211ot+Qp65prbM+0x7Y3py3WXwI=;
	b=JGo4u4TwdyATNcoUZMDRYKK77IkaKCf73NvSdeTRRjdYGR5CewTOr9WGyiAT2FaYPbjLk0
	21Olg6wbs8tnfKcr8Od27suYLNiTxsoTwCSJ8kic9JzGYXriygTZmNGhMI6FU0FjPDA7qE
	G75LWXPChfRg+bBoougkul/kAyZ3O4k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cdad94l3;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791831244;
	b=Uh5Uv1VTtiXF+E2h75EkHP7tBXZXZ+lcjhhqJtT3pgSkrY4Tt8QLf0XWQXdohyOELXQcI+
	FIkCqYl/BqcqaHB/Kwx1d0NNjWu6pzJauKR+alnE/lwTOoWjlzE1AC0jX818x7t9+JQsZP
	XwWVypM9RE1INsGaZgMV2S1cVQlkvjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51B9743E62;
	Mon, 12 Oct 2026 18:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5128E1F0089B;
	Mon, 12 Oct 2026 18:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791831243;
	bh=/LzN6QFYSsA+fcmS211ot+Qp65prbM+0x7Y3py3WXwI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cdad94l3/djhic99Bhd0ObG6C9U/C2CLrUE1lnyVHNjSsnckIVbfbC8gITgmKnRX1
	 Ng0cl01itPkjwqWZ8HXQOhijaLgVbwHhhfx0wpkrF4VjvbQv9wj7oIG0uhuwb2MieL
	 nFrM6c3TFAC31S2511GqSuww8ft/27QVjBhLuGUN0OMyF1qHmN4o2bKkSkr8PsmEse
	 xKKxIbkYoBm+BrvdRQO/8Asb/AXtmVx0Fkv0c2DWvv8y0lmRL9Qdg2cfSOlXLrrds/
	 g/VuG4q2KvwqvUKiuRTRsV6x7w5z6/xHOWetfu/xkcZvo7EFPXfnYKr9gOVnLL05of
	 nQSHFxLN66GKg==
Message-ID: <ebd7f324-c426-43c6-9a6f-d55a9fffddac@kernel.org>
Date: Mon, 12 Oct 2026 20:53:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 38/38] mm/huge_memory: remove vma_is_special_huge()
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>,
 Bert Karwatzki <spasswolf@web.de>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-38-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-38-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 14E338000B
X-Stat-Signature: 9owgkwx3efyxqj51juxyf5f9f6e5t6ke
X-HE-Tag: 1791831243-535381
X-HE-Meta: U2FsdGVkX19jGgUlRFsfbRHQK5lMlP7Lj+UWN5SynAsMpHE7KVi0hWglHXrmlsE94pcJEzQeG1xy+T5HzRoj7mzP+7jpEf6kd5cHRZ16gFMrF25RvEzg69gnR3AqZ1FuVs+tej1fiwYMBREQaKAHbKf/mPgFGbNUGDHQKkMSn64aHAE1VxBIfh7Ok0miIeM9HZYWaej+3f4OGQ4RfeDdJVdPEiIVnpCy6Vyfd9M8TmIcg+vlTgY/LVYVXZ6tGKl/ECvACSs79VG3gk+FQiNGk/CKIuNa5rAzlPotQvtRA0Nyjp5EQ2T+NR/vQVhD+7MiTLbXYs/wYVU3Eg/iL6LtdlDeJbDipiEc6pTLPau1smYq/A7lOFJFCU3TpfKO5au7K+vQ8Q7yYFyD/EHV9Nw07Y3KUwBUjIJ3eA2uBYIDWHux1eUSV6quw1UcHToJEXCBD+uvmJKnjE9dnFHtqlpg6YGTfB/uGIjAHy+4NRUSddXj+cT5ij+bistMQ+Zi7G8zUmjOhsMV+fLSwuOO+PF6tZYBo8DZ4/mYKiZNq4PtnQc8mo7Aoqsxm5jHiWRrUm3XbfAlm4h+9yEDAb1BAcqdgjv8JX3S7u6F+Ei/S/NiG2NcZpjA9oa928bTnYyvA6qPNvNwGybRHECxpo7ysZ5C7uD181A+0P/hhZFCweaph/j9J2Z/jtummRHO6XoDs/iiLqbE+0lkAibPCMrEwR0Eii5nENYFjmp76b+wAbcxkngr3d4fZFfBG5nkUqo2KJbS34PT1hHhlJC1aeNPbe0JEQRhpY8BAwklxSGWVJl7XsX71bS0V9PWj4A30oshJZtKnS8zkzbEnJAUyBaXRV0B+oo2ChGkWsKuKeQRHr8w+ICC4+PA79Ur1TqKohGIFqgBAmnqaRtGNok9l6+akwfazD4YfLdRWL983ZX9Od7+xV9x3KW4/4QFudM76iszsEtiqp4fy7gewnzEBtWhAt7
 BcSdji7I
 Rw15fufzv5KvKn9QOSNjEweusVnnPguG4yBvp0+Im+UegEJKBzJ05HJNsP8qTUDvDBe1TF1oD6MtrHOLOQcR5oeDWCAVVrlr+e/6VxnE3w17Gy+gkxm8Agz8GIaxstuoy1X/ZE83NC5WcL9m4Xrj41MwHgpxe8a01xgY87nuzkon9uk0v/gT4gldXLmHYlQaXMixHnisXedcEL3FKczW6lxrhOCyoVBH8rLUgbSJcXe2Qgtepr3tBy0pq9iq/9wAd6zgRtN2uwlCLjrZvh0BvdFFsylau+94B0f3M3oZmk5p9bMBbcnYykImuT0Fno7bJB3QhWfC1bUJriWSqXYeYP8Tg6t6yVtAgzE8bSX3FIY9wCV1fIYPNagtbtS75F7yxeOfHXRPjPtNI/J1NGjfo2DbfRc7hl5/x1XFM5XpwWApOZGmC91s57G2ZQtFjmjgrV1R4+FCnKVBJz9a7zug8uBovTRoee5ndXTS4c6yLOuE2RIQQz68FC7LwBNKYCPyhcoDIxrWSxYOI1LuLA7hziG9LViWg1gNH7fr+UMamaOE3FN2rySTeqctwj8J9crOjzNBziqgXr+QGnhuiE8OOE0j/gdYEygvRVQ9PQ7lAhMOYl+2Rr1B5BypMYJk8FYrL5oDKHRzCYxbt1/w3x6B3bvuo7ashf28mL19OM5NZnvBMELoxKlz+FRGLuSDXUxnFDS0GQjhfCFPc3VUFMKPgGaKlxUojiMkeS8rvs/9VqGv82r56UTLtE82Z58O9fQPJZN2xz/fWITvFfJQKRsVeRRJyqU1ZoXj5r6G0NJXwJVe1hEtaoimnGbv1mrejY+SGX+ZIyr5E3Qh6x0xydaTO1Nj+DTFeLTzo02CfLoB3dNtGz4BU1CA9J83fxUtYU+nau5dUJCsubnFjFsT28rQJDzPKspfyXDuqEsqxP9TLOpeIjpONOzO0kIyyJ9X+7hSEqvUP1OHAupPtig/v///f3gDUl4dS
 PC5QrdkB
 7EbK0l4PDuqHkgWypTpVKVRdNFmHuk7w6ffkYR6Ol5B9+pY0wnWsk/EJoT9HAlcOsC2axQKpSMfpa0kOW56nC9RI3CoZNfzqKUf/571XNHYsQNdvl88w778+7tjU8JZgNeKwr7FtlG/ctMtWQkU5ju3Xy8OYfwYs3ScF0dY6KB1Nsp+UTPXNH9+nbjz6xbVZ1HtIP6QmRpvpjfDIcHi5TQwIXEvRc7YXXWx/6ELSd7pNBbm59MqVDB4ftzlRyeAby4sx+sfBafT0Dj1fuJg/6u2pXh6vvkZHSCI75BPoem5gPQRQEKru+JEv6QWoSgDNP5z1+ub60XbZnRocV9a9QJTofOTHeAIiTPSFJbV1qSgXsFgINJK1wZ9iOyJtp12dRBEi4YX9zMmqIer/D743zYWlv1eYvxDzG1SZmb9EnczeSA1MovXCXTE5PsqLztue2pnrmiaFGAk3thvUu0nN+oPqtMcHD4xjq2XXbEAEKqIQZj+y+rwL7MN3Zfq+4WzqjyA834KsFoJYChTvePwIQKSHWOiS3XYKQlp0AUD+lwLI5pYQcb3jHd3JfhMf6358NDKNcm7MEm91IVhXQm3BTWF8OA88SU6CTVzkV+KAzoHTfHniE2mdyV9gMOiPsgPhrmh7Jsvm4j8bRnsBAAf6LNNtAcL3n/mh3Ym6iqI0m+ywaHzcY41OJB/tBjxMZZuKmfmIqK6Og5B68+TMxbCGUSSz4CpNfgu0m1oqR54IjazBhHSfklgvJRiPo976SSVvOEcn6dbVeKppfHsEwXlb9RmD/M1afxnoovw5LpeVPxrP4fH/4WmtyYp/SDFB15wQGV7rALlHuq6VEzzf64ujGbS1pBNsQoAhjzoFpnxAg4sqJmS2gsB4bE0n3h9usxtsG83uiu8OY0u2f+VFTPDZBS4aC7s3OvslqCEOOq29+2ebRYeAmRVLNYAWHLq1YMzdGLAjpCFe70LpWVDd/yiofac2N3VAT
 qyRc7vff
 RT0VQIxmdkQZ8hjv0CeLJTr2+H4pLNHzBC7kS2+RbA/W80iAFGfvWZArn2FUerv1wZKqoy5Fhu7yWXqpADa1kTqR3fFNv4IhCldwp5vy/8mb8a9iCCLaYBHcjsoiBOL2/1e1THVT2/VSR+6gDn1Yqj0hbrZpAR2LBD045FxwSYMFytWoiTyXKGSVdrCU/VJMBIOGrCRgG0p4iMU6mSNKhk11t6ebm5VmucVMmIW+j6NAXivII9VTq1p2LQhKNvvR35xbjeOIy/gAFcXRrZsqAI6HGXZOibn2Nt6Vl2+NTVW9514nmNSf2PQCiAZXy8A/zDuRxhqvoneQS3r6aXyVb6ZjmsWKeXgGd1fvgku/KbZEZmepWTkcy4XPOXRSmuN5IMOxpF4em+CeCqlSrqyF1Oj8x9ya0NDfUH1peHuaHDGueW2I3x/1bKm/uFIQ3+be+n4Eq+sqjdJ6LWxTiVe6crIPaMmJRXif4i0eIWj8eGIf7V2Gdmgx97bHanuIUbdXs0PxT/pla5tE19psYMIolxoh567CLJhVrlp9OqFrO6LwB0Fl81xlKgPG6YSi7/D4WjEysrTGjfDG0NvW8WSpgMJBYCxUdr46YGPzmMx2Niz8dNr1zr5rgsD5TcuyTJ5luN0NVP9L3IlgQRzeAgMWxHDdSmbpn+e1SRmHVjLL15lJyB3qUIJ+R/GsKDly7NH5NoOi5ED6OJWvS2kAGIAZeBviwRIBrPvtJmZ2wredZyzPfJjHFKyaWxW5+hfZYtQNXLpZb+B8FuhjtV3zbKK7sHKUQ/Y+/C/ALtuXawgg5f1QMrNhnPmNlmSnyiHc159LjyKJHXqEIRmDClhBgW1ZwXRYkiIo48G9OIvizLi1V51IHP6bJyvJlPfASo/nTB8SrnJEzldEgXKQFOjPmwM73W92yhEhpoqXSDuhtVyPBtpVh0ZkEhXYTWSalpmi1InMU+3Dde+u5OvwLqdgaZEVeonakslVH
 QbsvJyBb
 ln/egtdQbLJEbc6mriQJP7wkrTFxCQEeyxUjyTSDNIJoiH0XQVkGNKhs7tlbts9KnhlqjKR5EN6HL0VvQg/qVNdg1qGXqwt7achZll1sp73kF25DGSOmMtgTkesldOgOyuysGfVZ9kUBYhdAmKvqybCXVBQggSf1LUTYrxc937XjRrWxjYxXPCc52FADDutnLt7ljvS02zgZ1fk5B+N4TjIEmI4TfYBchjRA5+NKfBxE+YfQXlWrvVlxb7o+zgFOOiqjErEPNedWDL8efY2nlgF48Rle88GxUM1FkH+cEnbRLtafFD592Yzugfwzz2OK7Mkbg51bkHSvSjL3s7dECbKFyUAl9TUUyHutHBUECaVLXzn8akHJBRXuI3Foe64nNJMGp/QUbT5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
> VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is not mm-managed),
> but with a DAX carve-out.
> 
> DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no longer
> required.
> 
> Therefore test for !vma_is_mm_managed() instead and also drop the
> VMA_IO_BIT check, as it is now redundant since it is enforced that
> mm-managed mappings may not set VMA_IO_BIT.
> 
> This also eliminates another overloaded use of 'special' within mm.
> 
> No functional change intended.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

