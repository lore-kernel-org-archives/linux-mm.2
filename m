Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DC2CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670D96B0088; Mon, 12 Oct 2026 11:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623FF6B009D; Mon, 12 Oct 2026 11:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4546B009E; Mon, 12 Oct 2026 11:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 229AA6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:08:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE9EE1A0EED
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:08:47 +0000 (UTC)
X-FDA: 85314306294.04.AA3C22E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id DF183140006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:08:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=moBBKhZ1;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791817726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Lqz7Co/6WmIoZTvSUyXdeYqdXkwprOlXMUykscbViU=;
	b=0ZVIso1Mz+t9sYD2B+7AWlBS1dIFNxqsKxLnsMF95rakUIqWM0HNWvu72AzYEDXg7RU2an
	Bz4O3J8pR7xmVkbirNIq7cHcq/YsjXDNrU+KcKDXzoc7y6KrqdT12LZwFbloHWTnnzOKEx
	A7SJQv6l/gmRGvoHASSBvUxOc+W4+to=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=moBBKhZ1;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791817726;
	b=RWQFPQH2hWRlDh9vafz4ZsFaAQSnINFcYkgMuaTgSkfA12pdKkkeZym1XwK/fJjN45n/ur
	RqZvA9lB9WVYPXvXjCnXaqTfkrhCXq0NPzVa8TKDuA7DFiUxHEV6r9UIoPqI9NyV59fvX1
	Q4JwImFdehoLWvJW9kDXOx72FO9HuX0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13F26402F9;
	Mon, 12 Oct 2026 15:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954511F0089B;
	Mon, 12 Oct 2026 15:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791817724;
	bh=5Lqz7Co/6WmIoZTvSUyXdeYqdXkwprOlXMUykscbViU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=moBBKhZ10bYCqL5QecW09xYvPbQHaZDR7WGJEDODITEshC7evVHvSpjAoH6glmxjB
	 j5qq25frOQf1OQOUgMeuWBpPgH0xTZwNZhIl/cdfqON2DmOOhDyCWAnxv9HUxAb58G
	 UBAe3u4J3Eg+8VQMPcD/kAaKX2xWIbQvxTSwSTSaw41wCpUZshy3Kz47BxbJeOuQQ/
	 z7yDOIhsT6JrN+4uYpMlUxNCd9n9ubBCEvCaje5nabNyNDYdrRQ6UDAB6LOpwN6fdy
	 Xwo+Ef8jUxCUhzu0fTriVqllspREkaMJXtHSPrTfLXJJ5VKOU2B/63imbqYcy1tbaW
	 C6iTd0iiF0+vA==
Message-ID: <5b8ef0ce-7429-4d74-b4da-a0561c59b1e2@kernel.org>
Date: Mon, 12 Oct 2026 17:08:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/38] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
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
 Bert Karwatzki <spasswolf@web.de>, Emil Tsalapatis <emil@etsalapatis.com>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-13-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-13-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DF183140006
X-Stat-Signature: yhbbgqzf5hkaqr5k3jsancxs95gdcsez
X-HE-Tag: 1791817725-564682
X-HE-Meta: U2FsdGVkX1/srusJ4pDlazMaF4HEm0KxTzJpEvRuVMztKgBiz1ZMTgT1h0qNxQqWG+6p/D7dNEVyWGYGHYgoNQvIZwHfUjZdl0kZy1LJQ2dxMBU89wRJSdNLFEBUrxHDkESQoQsILCBOSgNwBG4a6hMomdnLIYV3sFYlHfiEDTcpAXuE2VM/ctgEcEtdzBPifeMX3Aj+phe7aHiXce2Nw2OaQgJWY/T9O2SU2egIQ8aN92yuw1alzMyUUtoNMnpw+RmJfpuXr3UOb+o7nqpMI6UiTxpnocSKrvc/I6Q3GbBNRLCCIi1PIgL4igfDu6l+UF8QIR0SJg6x8BE+2MPUMi0Uvh4lt9YzgWg3/UDcTAoq4PA3Hk3HhnDzG8vncihEOvHg8M7tdpREPuxg2SZLHVyHTSOr8qIf/HDWk9L/G+IBsQjoOxugeP1FO1w3LiYhHp8GwjJZ/caBJngdpVyUzTzYRevO2EO/32Kc16W1j1IRRQKJJwJpKzZVoMVoEwyrZCt/okTo/5GnEhypsQgpiffiOMuneY7yZ60DbogUW3fiwI5kdQVp647AW0qKOKEOAmuQ/jUUvEPOZSE7M5y6RLwhT2OazfCaU9BOnp8PF4VW2Nwkrrv1/4Be3TLuDOq76OD+NoOlrRllSBFP+HDP0DFobZsyXF6/NHXmuVFMWLu0WurEBHq9y9xyv0OSmqy4ecuYh3MGclyoTh/awoOPY8Cov0j7FJAO0/K+KE9LW+p4Sgb2IqgFtGMia7bArk5McAlhQQsPe22zZ0ZWPOp8REaSKPmZcefVBUzWQqImtn9TczHyhuzRfZdSvDRd2dhR8ztbwWNSZ3Bnh7o2t95Ad7901dR8h3XsvUPUuBLqn1u1/wRdFgd9rWuzoBcAXdtULust/Bi3isbIm0Q+lWjVzsdhIt3J2gqTL01c/xrDuMWr4ezv6HT8BVR0CgIucL5FTadJC0y16sG3purwo6A
 tlbCZhKn
 aCSa2ErtY2H1QicUTJK7Sqd31vBK4EejFugcWaqi3oQsNF7bLczTto8qNxg6icgdkW77Nb73jE4Jexnb711DAESO6tY4HSsYhIxoEuLqotF0+yttD+mOTkM6R5o+w6s9b+eiWAQ1RzW8DIZNh8JFOl9Hw+x+ZxOvAUO15ZhlDBuo2bYZpgSWM4k8EZM69xbqbNDiV1Hg9GjbG0+rvqTmC5Sf+HQAhI7MRsJ2ZiijJ6UNSLszZmNRpI53SyZcIhwfiv+rNqx1kBNr/wSLPdM9vvkYw92PKbpWTDVga1Kj5gWrkIwCR/l7cE8mzJiXexhPatB+jdDN5azj5u21lx3M5ApBH8kKCO7YcZF4KMzVbqPyJRhl3IkNY9JZhP01oDJ/uwEn+GTq+EByY/J6CwezW4uRjGNgoPw9D/ou9DN5yMTcvLKU0nflO0czQJnK2R5QG2CnIX8kcAORe7/dPTTAb5WHYP9NpWBQYkJg8Wz2MNdfs9qNG1l2bcms75FHYcnv6pslszsuVF6cB34P4ch3WrU0mOai5b2ch1DuJldtmBrO4ifC6If7UvPIaMLYiC6EazC1Gq7k9TP1qGsoT6V6+6kBpdkRcdiihmmQWiyqQ1z7XOPW5OYK/IbXm4KqEG9H87OSywAr+X9ViGoRtF03FvtGjSFuTKLnZq9wYWqj9suQC0PH80FeVFS++fymHn/Woof4Rq8M1U09k0C2Su/XLfR5RNw/6cVXp8E/fOEBa91tzLOsyO1pGk6qXwtl0JS0Yk3X5ICwfzcVvC1cjjjFw5QFcrqhGCDoBvAlM+F62AYtlGeVWO3UyTS1AOTiXx8TDrGumPMnJWW3spyIlFfMraZfC8Q0u9izfl+hPTzr0pPsiz1qoSPO6wjJzu2sUtcGnHhysME7ZvTseYl8wf66+/29xZtfAdCdwBAViuL2v728CzPd7ojxjxSniJXvoU1OUHhq4mNcq89ZD8og8YwHxzCY67hcd
 goUR5sJo
 sAhrPgxUIndxt6IRu0022OQVEktrwi9lrU1KYhzBwoj1SyVFSJnfjwjlBy529gpldMxTiJDaqOFlHOkwN07PpeUYAh5fGPitnJYOqn41U/wA5knDBLxIEJ5Q5eeVHZ0sI93Vct5fMMBEaUIZ9/kTpE0j8ZUqjhnlcryfck2Mgeo/yrvVat/XYaqfjEoxr40r0flgM0+WZQp+SNCLJtjYZpSy4xPQhD6BZQ7d7PPUDQMDnFIU7DbhiE+MHCf0dtef05STg1/gw8ewfcOQdPjpbxfIXme+ryemrBOkaxV8fCxWAwHkDP9+66A79umvQz4mKR16wBs5IQ9Up1Ibpn/6uIeB6R6vknJZ3NVsqvEbm3axOUKiMud9TQQdcB0qTLyT3MxylNhy1GMCIkjgWm2WEQ2zlkqHWMtqefQ5I96CQvFkUr1HeIRiWFJQ9VeJZ4Ptg5LR+P8EaskF2wgOSisYeQssQOLUCG1ADBDX14GctXXnXh13LIW2DZ+L6fpq/BGItkqtiC9XEGyB5jZg5GsMEziPql0cyjRcDcg8TFjflRFZrSQBU4BbLZpf73zNq0/0cQmPJYdaFgnrctzAOLxFnALm4F94w4artDMPI32JZbGat4WApgNEsbmmXbtZ9bWN76MTcN2mbPJt0gsN0zeuYx5nZ7nAeMkr6OU9GcQ2rV372Vimh810QIm7cGkDLb/TUxQtpoCidvp0mujJremTKvearQ8UKUoBFM0+O1n1ILr/Tzm+uTox527pB/zk/wo8yX5rnvR61oP5kIbWZ7wM6T3DGnp9OS9hYrRN5rkUPczjHNdU7bgvjLpKZnguMxkTHfOyj/DOQyHT1CoKL0DNOtVa+RrhXqKWXq1Ujy66wnW6C8Pm2/N+urqRNlxOFOlpPRoR+3Sim2q1Afzr3H2TI/ab8462R3aXZybK3fHn2oRfmNVnJs4dQeDGjHJEJlToZP+Gna/FX/RYrv+xXr/AqYtEUQAlr
 EOEgeM3G
 McwUtGFNvXtbcav72Nn7p4aBEgtIifLlkWUOWdOJ0IxVEkW5qb/gdtJ7LgmX3EViK96TaQ+U1bn6grv56xyDICuCZvxjoA+4lroBktkVHJ1ZqbC057PPHIfqXplFrtur7O5K4sqcTWRgAj82MVkEDh2YU5zwA/GQkZq0YWtDSlpXGODo2fZ0gl/PwdCoooDJG+sRZ+GApW83Nz5EjA2OoWF6DPr/dxhAONsz1IWOeRS64s8k00wcxOMthw2eW8HWYh4iiz6pJoPePT92kIZKC9rB27IzMCVCpQtRsFMBXHbthZ4gCCdj1+qbTRKcjoZxCrneYdVQmus2Rn6yAHic2uqbaUPoeYo/6mQcyt7rDXiD3cVKSzgUSOvBtqnNpFoXoRlMdWWrLFbXonENGE44NtYJ6WVlpjXFq2/kcgihAUf2cr1Jl4CEUWKS8j8jcLD3Qpcu7oCHxPhUL9RFPwhq+X4gguBh/4ib18tFm9pq+LSOq6aZF9Z0T4lr00Rzx7r9DUftx1w9rCEgeVA6QyYAnwAWZWm+8PplJn6iucGYNoNagwtKgQeRKB/4tOiKbSvky+ZHAjDxRe/9Hd+5kDBqE0wUFRcebjpSJ6lahFPHStZ+JrNe0byTRiPGiMJwW6DVcuE0dGRi6oTfvz/+ynHPSLfK1VYXDIgf+I1BgwtPMo8n0nPU+ARfqBwZUGD/ckKngHrZnbQUy5m1g2MJfv14Oy92EkVfvvvBpuDBDe3Qeh4cIl5ECRuObyBSp0EhV4mS0Krix33u/wPAAN6uw3eGmampMzzVa5TWE7iB4Nq8uvag2O0czVVF9Ugtcq/9CjncxsBvlkwQq8ghafDWXUP4IM8X+RR6s55FSoG5f+nFcR2L4yQo21bWr8APLi8YqBWn7Dq61GiX0cWBHCUShoXigd5FQWCBLYtJ66+HZk93Z8GMjGoFv8R3CncR7dT8S5oS9uN+/NRhZ3lh9bJ7R2OinyfxW1oeC
 Rmz81xHo
 32sIPTNQ30Og/AJvpGCIWasztTn2vptZgjX5fiFk73Ghzxl4qrOa6iDUEv8iCXREEVsOrDqJXrYN6uDwjChLYY/gtx3TrQ0DgarFaKeghnEi8f6ljyHcKkm2s63wYIY35Vttn1giL9QyRJOuzbwgrdMas0TiuOHImM22FkARZgkCIaqU9/vVGY1kRTbIGN7sm1bs6xrGrZbuGeZXNdFah13+mhyQT61bRqIyHVFPXucJmXL/uXnxoHDn+NSaMo/g51o1n1g2YNcugsFd8ryVcO53BuAaFkYCnIl3KiIZ86ytS86lGwkm83sTn5ztQrZO+H9cBnWu2zkZnjd6+8IMb7qdXUiPFIuATxu+NpeWa9qaiFZ6wgkCk8QcEr1KZ0bs712E2cxovsqSL/e9OZmD0QUM+l21iQUR3OispuV/sz42VrJniVmXW0MpSIewU+43wMwNgo390CBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set to
> one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
> or arena_map_mmap().
> 
> It is convention in mm to mark mappings whose pages the kernel manages
> itself with VM_MIXEDMAP, so core mm knows not to treat them as ordinary
> page cache or anonymous memory.
> 
> The map_mmap callbacks ringbuf_map_mmap_kern() and ringbuf_map_mmap_user()
> use remap_vmalloc_range(), which ultimately invokes vm_insert_page() and so
> marks the ranges VM_MIXEDMAP, and array_map_mmap() sets VM_MIXEDMAP
> explicitly.
> 
> However, the exception to this is arena_map_mmap(), which doesn't set the
> flag.
> 
> This patch corrects this and updates the comment to reflect it.
> 
> The pages are refcounted and vm_normal_page() finds them regardless of the
> flag, and VM_DONTEXPAND remains set (marking the memory as VM_SPECIAL and
> thus unmergeable). The one effect is that NUMA balancing now skips these
> VMAs, as it already does for the other bpf map mappings, which is the
> reason array_map_mmap() gives for setting the flag.
> 
> The intent of this patch is to be able to establish the invariant that only
> PFN-mapped or mixed map ranges may clear the VM_MAYWRITE flag, as is done
> in bpf_map_mmap().
> 
> Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  kernel/bpf/arena.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 7b6847200b43..b69fe5e34339 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
>  	 * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
>  	 * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
>  	 * being copied into the child process on fork.
> +	 * This is a kernel page so set VM_MIXEDMAP.
>  	 */
> -	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
> +	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
>  	vma->vm_ops = &arena_vm_ops;
>  	return 0;
>  }
> 

Historically, VM_MIXEDMAP really just means: can contain refcounted and
non-refcounted things. Everything with a struct page is refcounted.

I think we are now changing the semantics to mean "maps kernel pages". I think
this is fine, but we really have to update the documentation (and possibly
rename this thing to something more expressive?)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

