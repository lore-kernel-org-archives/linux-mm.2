Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73FD9CA5FE1
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 07:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BA266B0099; Fri,  2 Oct 2026 03:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B236B009F; Fri,  2 Oct 2026 03:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50C276B00A0; Fri,  2 Oct 2026 03:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23D746B0099
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:08:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B41C12066C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:08:48 +0000 (UTC)
X-FDA: 85276808736.29.3FDD4FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id AE797140005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:08:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L0Ii+owA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790924926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1yIhF4y93luJBvo++ntgk02PM9naHAGHJiTxi+AQxI=;
	b=L/yqODQF7KpH/H8eORiaP2OKcTZpkSCn9+M5+kxhDWQs1R+VCr7JWbKA4/aBakNUd7ISHa
	IrYxJo4XDnM07tEVNp/ra+6RyPL2yYJ16hd9rtdxwfp5VgG0j3wuT041DXkSSBIQp9rvR9
	DJ3j+Vav3pjNuQAHFHLgANxGfgDiWU8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L0Ii+owA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790924926;
	b=fJ9rIqO6xzBsYWaAD0tqmCo+COS5bV/Xqj1pZvKaI5NeTFFf3Fabonm8n149A9hH/8ydZ8
	2KO3kpcePWItUbfYH9MpyIR+EGjo7oy38DVykriSSYYib1oGB7WyPxBDV+HiKO2aVObgaC
	KgLhEzEJZkoU9BiZMzZ/OpUBkQBOFm8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E73B34359E;
	Fri,  2 Oct 2026 07:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FD71F000FF;
	Fri,  2 Oct 2026 07:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790924925;
	bh=E1yIhF4y93luJBvo++ntgk02PM9naHAGHJiTxi+AQxI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L0Ii+owAiMIKjEnXtHRGG0fivqXyvm7Omcwl10tfIvuyUXuWIJ8zzcRm10ppXiGFl
	 nGZQf/Ag81LdOTsX0yKoPSrTms9RZ60WX2PqNiDDA/BU6uMDqxUB54Fr1F9z2zpihH
	 AMEJ6uTLl6LJs/eUGk9+dcQ/77gS3Ghs5oDjCkvpBIBMGyX3LbGod/U7eVcVuFJmBF
	 wRLKeEcTeCXwWXLdqU/4ugShns3nhEv0/y/SR3UmflTmCTdFCKZwDPiJ5soL8sVlQG
	 L7XHtmJvC7UOChs6SWb8XontDWIlnRB0iFnOyl2yy5GEt8Rmif0pPTe2e0teyqfRiA
	 Kl09cc+aM+pYA==
Message-ID: <651c8852-39d1-4351-b899-80f54077b494@kernel.org>
Date: Fri, 2 Oct 2026 09:07:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 37/40] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
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
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-37-4583d8a23bca@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-37-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hnngx8xrpd7hyc3yc1rmpdi1qfkujbit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AE797140005
X-HE-Tag: 1790924926-227871
X-HE-Meta: U2FsdGVkX18H8yEz8pYTTvtqjK50svKIQcyU0rYfvWvAxCi62sD9ZiPUI9hWs5kCdCUdPeSmaaKpXoTbSutLiLTAKqANCTGON4/KK3z8FiQjDL38lykS/WEUcIZezWdZKX8bDPBgUE3ELdGABZNpPc32yuKLADHrsxFSEIQqKAN63BCgvc+jPgJq8SOhSwEl0dZqgTTA3GgiPx5wvf1TbJ3/jQ8xUH8VSd7CtRvraKx5a3deC3HxaMz7z96yFXGkYNlFRIOxwVMUOI+fknnPHMTxznbVJ7+0kZLB+HNjQrGx4luKfb1rcUGC0kxtIvacasTCo3G/+AYt9pUv/VzHeXRwOMYCu/GfzeSoA6neRZcx1xZ1CvsTKuOMMwP9YyOX0dGtcn3JhSTSbmU8K1TSWoePyvP/17nvDtXDpNJnIHppX5bJbUIZa8R96rY01h8BhIRlmVQ7Sw3vNUJq0bBQqYkmuDlFKk0Ccc4uRPzDATCwZQ/V9dARPabV51wv9CUFr3bhQrr8KgAoiC9SLSyMpDklHGbh6RCOfKaCNCtMKZ+ZY8t6sR8oi93b5uvgMs5hnofQiFzxk3NYNKXC9gW2TZSmqCF2kIE2xL5UprvW2wX73+24JRIgu3bn1MXC2y40ZXAgSG41aTooFRnzsa3PnVh76tLSbRf3N8YwDvVJguG7RInbvOOxkTHg7zjfMGiNZn5K/+9BdTevF6t/LkgTn/JC1Sv+HopaRC1KUdlWs0D6+i7kOYpE/uc8+nszKUfWYgsI5sTy1y999f0brXIiaIFSbkJJtqLHHl7w3fifxju9zLfbbhoX7C4Au0mkP2e2kI2o2gdtz3i7jLgDI2ycYwe55H12sFgIA4zIMaW2niWEANzMiCgQU6IVDGIAKMmeGNva7q4rc+r5EwE5SmBs7z8wkCdA4rgLAj42eVZxKgpAnbVMSwgasIdN0oS8SckgLKr4kyLiUQ+TyWgDwbE
 j070+fBF
 eEdoVAigAy7D5u7kkX2ydleN/xsik+VtkcV8QzBc5oeZdBuyHyn6RqW0AR08Mdjx+PPVJw+k1J4cGwltEfLpUOaXtsQ4IEARP8XvCYMuwmlJkqLiSrVxKq0ohXQtmKS24Aqjwszqj6G/B/o0JuhaMigkUTbnOOqJCldZRqL04CoYhe89TStrDOebiZ/rj2oSv4t7W8VboTemIJFw9ZAS9SBqNi7s4gIs29R7Mr2rrt5U2w5NCzqr+oTZzt+S0cKj3//fOa8oGt7iGp9c+6mrRNPE8VH/Cu6JipN1cIBTQkZigMewbkR1lEjmEVdfUzKccmhnOHFAfnHKmZUxhAolodohSd3AeowMtsslwfkkEJRIMq0ac6ctlaeoMB5Y7DHd3jR6CrDQlkl1QQ+VTnTTfvy1W4CVsPcOqDxuS2FNe/LsLA2v08zDS0y1uxHG1IJS2FP04wozPT/TL/CDnq6oBEwcFRdGuwiYf93ubT0jogQMzZEgXTQUY3dSQbZ+qxOEu9j9B5qo9h96CP7L/8xodmbgQ/p0NHBNE5TyudcOqWDtxFxCrxhAkP9OohYZxX+M+qdQmgK4oCPMqZDPsO3JbFtFCGR+Fh62JqSd6nN0i3tV/KniSMc5ycBFvT78IjMNbSZESvizVvBB2gBfYtQUiYQWZncDYWJFNd+YGvwlD7/nPpBdDosk4+5Ya8/62dHP97BoIHxBQWbCbQ2R7rMJCHikCbcdj9NAdIa/5do2Nd4zbftyVClL1P1v1s+vlg6FaILkELBKdZhGkmzJ8gJeHoDJeq4yxbSuUx8ZRK39/6+nBeXFyldWvrSH+2aT8bdmKsWXNYN1YLimXUqxt5D4QoOpyK3qzF38lsyIeHHZqgiWYGVH1kiMf98aPlpisspD2CBHctYFh9sVfpwEtLyPP86n+qvTh6zQCwsCLBsDoQXOYyJZJo3XTtVDqO81g1+dQMmFqBC/cVsMeNn5om8rZfm0K5oOe
 CTsUo/1u
 ykotDk7HF5L3UeyaczmvtklIzB2MDezykjM3vfryfIZIKQhCN6HhADAOMvn2BIHD+SVjk58lA5qlEc+eKGgd/r7kGJ5DdSmHITzoq+tRg3Hk1bN+/TJcxknCEkv23bbbuS8ukHe+JAZIzZc8Ef0cIwUXnvGpXAqXWumWtJIB6gHnHmw2yZ4o8z2BTrGy+SBnfXox5n3y9++ARIeTnHAcx9DrXWitL0LNKhKLB+4IpHGESDdp9xVvKopyKfwSgp9SC4LLgFqs4xbiDaIiHCelkv9NGd3KY8qKlG9jQW4Mgq3oDWrot7CYiTsCuIcdVpuyHImeoOnQKicnD6T7Ah1lvW6+FzkMNziT17BiwYFCHNHiAwyvgn5J3DJnbW8TPqUhDAkT3gFcJHq8oJETTsYIrMe09HbMKFtQ8NVwG66IF90jBslBNUWhJzS7wdqIgf9YKstdVa5mIgxrMlG20NiolYpWQQqMeAB4/ClR1Y1C2jRm0QBOZF7x09bkN4a5Lo/+a+6G2JLv0jGavHBYx+7x2Wl5snIbL5vKLXSzNhje/u6Op3x784qrGfIHR58r3ueAMDOGQ47FRQXG+jjRBL84ksmvKSu8G1xjc8L20ShVQ55UWSglOnxmS5ZZ6bESAQJavJIlBHJnjmY3dZHXVRua/dgE//xXyD3ggo8VJBd//R/EC9CsFBN9+0wXMbxY6tKeHdAt3jeBdjlH0Tve6m2df4RNGxFMEtKpp3yyGD7aJtsjoZUswRComgvQoX8o3KBfc0mNOZeZ04x1AAg8V47mFaEPqFZ8AxJ+MhZ4zGrfq9rWv1HWgWanL2bKwqTtp1OG8vtTQ//M9YLfAVYuDoA53cPVwEHTYFl2eTimlnjECQEd6IEG/axZjH9WUH6Dx0GfVonS0gvWTQFpet023ij/uPvm9AQQIwWslhSSlt9Lp3OI7/xYHPN+/wijKIY2U9TikSyc26C66H/6FEi4zoNTNg74ZESy0
 PwwjPQrO
 ZT9nxibuHJdzwVoI6fwWCiphWzI3fK4JDcOzYfPN3ex45Ucy1Rmx0x3FYM6EAWLuuQAAScFTjD4X/Pu7+NckciTM5bl5KjXa9uSxaG6iMdLP7CVGhXiiAPn1ydpWmx8mfknbrub69cOLU3VHs1bxV0ZckXpJUBtuj3qXPoLtz368cruvsrtvSaKQkKXM6lQx4QhLXilLP2dlo8BKBL/E62OWJJUNP2wLwGVDeVjWTuLLH7fEkYbaMQtGAW8Nzd9sclbbhC/iU/CD2moX64D2lArM/3JmoajUuliS4cdT37bZ6a8ghuHgWBVIeGwtc5+WQTi1UadaNZLE12QhBG2Ra7QW0Bf/6vtntfAzrVBygrDn3gsx1mf5DrAgqYYCDR6w4rHA/US2ZfVLH4bEPrekoioJY70EErsAmixA6aP8l9SNa2vc7+UFWRxFb2ZP6pmQ7HYTmh8eZI0mnjeprArbXiW3qHB9PKcFuxzwfsI/vjdrJ8KzGnQerWzFYLKCnwNd1fnXOMMw5cHOBxT0QCAQKttpLR2uszvdH1VvmXrhIz4yz2/Y3H1hiH+l0xIpXJFESTuyOg3ohWgw/Fwyys9djsBhnPtb49JLLuH1GCJkr0eEmtaVNOVU73Cfe7CgoVA6NeyQuiaKVE8Kxwxpu4xqte3cfGMCFKWg3N0YpLU2/7x5m0+rs2EGBxiWQxN64xDyYkBkdinfcnOP6+4904PbgcmhXSpLr+Qs/H8CGJ5ya0SufgPswlRA4Xbg9LPV9XlvYRkxlnB82BloT4xMJWXURV697du6ZYYvsXe7wbYkIbSnCU8wyvS1a831+1UIAtaTXpSfd5FXrYJwYT40V6MzORLJfu7UkVWj7oLFrV+GAG0YXlPretPdzGUuThiNA2cQKe13+7lwbJZGewTSPa9KDkqHzMFT1KLgp40GqwfRElexsZxBjXDpcPNhXI5RbzmbS//QEyyKSlL39kXvS5sbzMHr3kErp
 wLSqgfAK
 lreRDmOnyOF4uJvoQilbxCSjij1irOK88cKxj/dcJLAZgKA3xNAUzmD3r5Cb1/DBuFJXUqPlL+VLF4XKzAMGICdHMOKCrt9H3QtUGDA13EOAD/BEEx0OF74klST/iiFvs8tXGhjj0l3pzpVq8QPsABee1lGv9NY75QMwGihHDVI60dwnvGYATVEIDkK2SS10+i3Y+7HmdGiSQM+TVSLtK3sSmDkvq4Qrx8CVkl23fbytffxI4VJ7RRs02QZ3W4uapQEY+I5GXNWQqH4gey6hsVDhgdibbtVPC6iybds0VH86BWzPAE8wQeb2YMz9r2/65wJsvtr+kmEEJNM33AceQ02yShxPGBv84qFCmz5NSTwlR5buQnHxRh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:22, Lorenzo Stoakes (ARM) wrote:
> Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted to
> predicates which explicitly express what is actually being checked for
> rather than the nebulous concept of possessing 'special' VMA flags.
> 
> In any case 'special' is not so special a term of art in mm - it includes
> VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
> other cases too.
> 
> Therefore make things less special by eliminating these now unused flags.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Awesome, thanks for doing that!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

