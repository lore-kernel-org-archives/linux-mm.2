Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 812ABCC6B03
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80C9E6B00A2; Mon, 12 Oct 2026 14:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD716B00A3; Mon, 12 Oct 2026 14:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637956B00A4; Mon, 12 Oct 2026 14:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7976B00A2
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:51:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B927B1413AC
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:51:49 +0000 (UTC)
X-FDA: 85314868338.04.398ABCB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E7042140002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:51:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZoZu3bp6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791831108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfS5bZnp3kiEU2OLFY4TMOd4BSBodNHnOtZDFG77b4A=;
	b=zXYQauKuxT/vbSmhtdqAgnHC296I+Lv3pjU1elcMM3G+YXQFTB3d9vPJ7ODUcSatpX3aLV
	CvKlT7pvuVGMN0P0Oa9nM+HipSA0FfVw4HVuezuWZOZ+nV1Fywz3J/2oEit/z34t1TJ8MI
	oRU0mbpund4l1ozFrfEjcrm/lFciLWI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZoZu3bp6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791831108;
	b=bCFl2y9YV8Y8dGnCCi6eTKev8+q6c5fE5Yaq6ACcUAlz+CaLoJ1Bdv/HcuW2z1SQKX2Tys
	E0i9PUi87mfSeJpHmEGZck+b8YZm+uRqAjNafJ7RCccA7BVmBp4dy/MvfW9S0eG/ZRCAcv
	L+7h3fW5DbS8vrkltaDgrxcHr9wGvmQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC77441ADE;
	Mon, 12 Oct 2026 18:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16201F0089B;
	Mon, 12 Oct 2026 18:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791831106;
	bh=IfS5bZnp3kiEU2OLFY4TMOd4BSBodNHnOtZDFG77b4A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZoZu3bp63JjlJ+BE2fP11usqRbOLKhKp+QHgNU3bq3lKD+TzaIYy1URiYq8BQlU5h
	 QlZBWLS3TVgVfkISPY8Z/ZyroRYG7XFVcYSbaINeHtQC3WAb39j/IXWe0+Nn0ccFGw
	 cPGvXRawYbwnzDo3gAZ3YgnPLRupAKesaBNyPBt8cSe6a9cPHySSs3ql0b0tcXsmE6
	 n8pqVsAtPYRZvIKDZD9bheajkb7z1JKVo5Wek0LiS+l8v2nJO+z9TugP5eNhXYYCmz
	 NYfjiWXssYI+2dvN0hO/5Xq09pcA1vXA12Upl5I7Do3cv66C48Lsc4fbr5VTqtqWs7
	 KQI0SQM7pbr8Q==
Message-ID: <c0b212bb-da62-476b-a16d-2ce78e1e2639@kernel.org>
Date: Mon, 12 Oct 2026 20:51:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 24/38] mm/vma: enforce that mm-managed mappings may not
 set VMA_IO_BIT
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
 Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-24-923b70125b1e@kernel.org>
 <5d51b6b3-ad58-4827-bedf-f1a79ebd5c86@kernel.org> <as0nF53W7dug-Fem@gremlin>
 <5ba7305f-0ad1-44ee-be0b-36752684cdb9@kernel.org> <as0qUOfS-FQgRnm4@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <as0qUOfS-FQgRnm4@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: afiihma6rcbz4dz4mwhjzduzdgt387gi
X-Rspam-User: 
X-Rspamd-Queue-Id: E7042140002
X-Rspamd-Server: rspam08
X-HE-Tag: 1791831107-66611
X-HE-Meta: U2FsdGVkX1/ThoulGNlfQT3ascgL5Jj37dsfgDEa1SmXTY6von108CSjFzZWpty8mSsaovYy0P6GiwB7oSjO5kFP/yvmLiMe4+SDSjURgMmSjprsh60w5Mum1gnTmLQRcz7iG+kAbiMkamtoZn8BSJ6MDZvQMBIfSINXqfgiXV8+ipnwpYrgO8afZ+dIexPF5lXfSTe+57IWTbMA6NPO2yb4B1NrWgRUvvpNPMz2webtWWcZXf9CGoejPSHuu/vj6rbeVgboY6R+JBK0fOT9SnDMjmcokpdZ3VGNbTRaJ8bwijnJ9jOU2d2DN1vmqWPxJ6MwYBATsRl85ZaA9okLTED4Z3WceFuqLRJos+HwbFoxC9wSU+i4FM1tSaoc2+UfowtTomKOQXoBpf4EvUIcmdO9NRrWEMIMvvbbEJIoDztGBtyWUI1JBoJ/09eXW1sy+y6mcgVYLvW2eDmiICRpKf5sTTvf/SpzFj2ll8D8yNGuLtkVJal2aQir81yhWQzr32jdrxMWgPWyPfGNHbSHS/PmQ2xJIKW1cg8a7mpndmDGGwPPr1Ju/4Wi7uo5T/FuCh5Ye154/xwGDwAdUlEYN63sdpKvTw6zprCvgT2KXP2XQspYeB9dxMhIzxXQ1NowDstpsDwJRX8vByy+DLQBBaZwXnp5LiSTMDk2mcb+zbL5xJOnYVw2uFfIzeU7BOThWRClKqg4ExqKbJQYjHZsVKctO031pYI8vymcHfRihuBpXPLKOh/seBEGSLJNSQP1tgrwFEnBzeEEEMj7lJFCeyUL/9df1GkH9QVh0dlToi3/QnFnPsTlkofpPSIemAfjNANM/71P165PgrRllowpaqTY2EU6SvoDUiFGumvniQ16tncxzvsiCSHyQNbuug709Uf68TJy3b16R8C2pSRFpS2b9rx8lLPkMyi/YuwuFIB9jPzHXfMNfuDsMf+5wtzsYBuzJqQe5C7zB4f1w8S
 wtBUma8+
 A0vA/0jcASoIlUK1P6uKbDDzpHIhMO7cAhQ8HQBFjuLAY1RjOASXZcA9sy5j6Chu1PXhtDi3KLn86RHkQXgofMGcrlnyGj0A+5cUDgOnL3mh2FfcWWGZdTLI9JHsC08nfrbmnJsQi9E0wPUbHH9+SJHLfItxig8lFXzMBZOzDl0DrDNfZHGJi1ADk6OcjYK0JwzcM+1iWYL04OvYO6wO9PPlUTE4QdS9rV5YqKMgzVo0IDKER9qtsFpaLNpxgG6IqTrIID6JATDbKFOmhnka7j9bRN76DpbTm258yPzycbn1zwEaqxd9S9e0+8wCXmxPagItyAzSzg0wiMA61ogRNF4SJRUhBcbjIhIHt0RelFm3qn4vccP/NHWTQG3Q82uIDRdh48oZCnV5Ds1P4dEMPZtS3+nIXzIiq0a1r6ojD24jzjfIrtYYDxKO5VTJDivO22XlvKYLnah90ENc5IfrvxSVfnJnhjX4RCp0w9CPsOTYlUyHC8R3C/wTu094lyWGN4McixEGW+FHw+FdqN5pZK2dZUa4nK952nvPvhbwt9f8EiGSmxa7Fjcn8ekcToWtOoySlM22/NwHw+SnGyJXjkysfHE6EBDImcedhs9kofefkPwF2YX++DmPDp4/k93mYNYjh3ALD0BQ1Kk384A79GA4V/C22h2lAUbnlfIGq4ntot/wJl4IrRK9ENO+eNyAzqBJFnhscfuWXEwhAUsNBUiUehtc93cTXRRWqzXK3MXzhOaLmJ3p+qgkdvin6mLqHMxJbP21BlcvDmXUuv/vzPXoCleo14HYKKL9wS2y5oqmltaEOypyOBSSiFuMhNoAVNp6LlPK38Bzaplx0pHc3BV6g95wVtMN4o2IcDB2eH7MPWHntN4dPfdA3kJSnJGtGuaYmr8ugG9MMTB7LljIorADMncEuqdSpum1jZGvFcy2H0N+hjn5cs3wPOqis1hSf7lc3mWBYg6o0UV3B4eRqeG/VuG+o
 zLesStbM
 Nt76Gzq+oF5YUpiuT+BJQTxtIooUJgPm5U5wZz3YWdUKKQvOx1A1fyGGI/nKhKbB5PGR9+3jtyHsqcc0mSm5siv60Yw/MhVUFpd10QWlyLsxYLCo+Pxj3CSQD7+WM2W35462G1Mb8vStA+9m3O5y0xk5NVbuxxt5i4+Y1gKeuUxCqbnsOsP3Xs79ym69cFW9RnctQUk7sFIHIyibLDYsqW8EbRITcr/I8oETcC/ep0oY9+4N0xLbMA/YOlHlbykLKzb/hV9QSF+z7zeehJfj6EoqeKlqfWzYTRW+j/X0+yYttxJhOrYk/QihrKU3cv9jE4ZKjfAUhiyr5DA038suew/wc2m4cLxx6pMZkxu7MTPMBStpS303on4udU1ICyrB2B48v0I3uan+J+CHhSHLzMKE8N91ut1l3WlUnjBb9FmLLR7SaJDOGEI6UqUZLFG3a8H3tnsahheQIi/9O+ZR90ecpT+8hfAbsOs4Tu+hvz9XJlWYBUGNQ1uoXF9kuh1ZN8+lBcsaK7pxcd4qaJJ92/u2qRybCNtyucOiltgYZgc2RAuMENvLhRY59l9YCGu94dpOnevdCctKEOo/tkbk8YjYv7nSgLg0y15xx4mKz/qGrKrOYjbL+Y+RGbW0gtwpwoe+gejTqw3DUfVed1hfwFrBH220sMyAzZG22Yrmelg+M//pZEqBsYwlS3mcmH60Yv7qtvsbijnHRWUXAOr37DUM2FPJZl1LhT68FIFm8rqhxaYLoYqQ/FgNvabmqCliAIutxswst7THj7qsRCu7L6kmjiwiU/b+9lWf0g4IExQblrSnnNJFiHLHnNra8ObB9pVFn/jhP21nMTeJ3An86zVtNOlSgIr+/Eu3lpuQ7IIczlVr4xPwWi4uZNardQA06l6nzzsKXrh0CADL9z0p2OplnsFk72Tw6jdpLYGOedtt3Q2zihavnA9j4SYKY1MDhxGZHO1dywVFeVxYLh75iI4tVx/pf
 9Y8liXuM
 t8GO2SXsWFZ0OVXMhsORc9H/nT0ssyGwt0V+Rew9VJ/Amzeawe+B5XSd8GPinhB0Xl9HNmXNqBN+vzEN7wXGCzUUlSbVbO/6FYcHDAverEm3aDcqwKDmHTUzNCq8LvoL/d7oyg9JhA+hA+lPvESqSR32EfKQeUhHBw2oQzQA7D2k7mBOI/Fs5v89wGrpne69Uhcxnosid+9Had5LkghGSyQzZ+by5Z9tyHisye6IXcdc2O+i6YNHDLzoHycBPQCWrWlvxbbXcoXMQBkJAgJsGd9zLN/uoSKSGBUSOl5AmYRrkBKOhWDbFwoc5kZ14N096u2kNOVcgnSI1AHYxAkg/8yOZS5/SBhP6f5rw21degrH5VPVaZw/0hcCEghnFkcbvOOC8vAMt3Podq9hEE67129QzyzjaKoZtFl0HlbfjlMHHylzrLvyPYC/pSlTHXp+BVo7/71f0pmPrVVhNZe4IBEg8cyWx2uogVRyXLXWbqFKDWhIfSTBS0Sb/xZehnyUfTvGeDI7teg2HTCln7f+CoANs4dvmHfSS6WQ5HOQQS95joQgbxy63HqZs6K1w8fvJBuD3jtRUyiLGVV0NIvuYTRfyLYR8/0ydjISJo1mUPChg8yCD43z0hRQPBKsNqOQdrbRFzhJ+w9ZPWgO/WvDhgIDqr++XAxXDlDwNrZiR3vb62CENeLNfV+ALAD0pS2L5heTKxINrQzTpFo4JrGQ8BuSotfmkjbLrCgWVJqeBwXn01qU6xOvISFXXO46MinQPys17i6rHJhf+Tod8lbXlvpMnVcGDDKeQAIbOX8JaNhjQqDDkME/akulebZh1IU/Xk+Voi+laoFDV4wDYe/HQM5lma9tbPTubCz6n+khPI1T4bzk5Y5caHftqMpPcwEgQedqTWg+cDOQ5VnbDsc+NVEuhHmgN8XtCrNm2/Pk96zuLPretPtH6MZRfZv57kuSgYAsy6I46IRD9a3Q3wlO6b0JTJvjk
 8yFov+K1
 ZL8q+NItBanHmVMK3FpfYj4bet6j7gfYCdtfFFHya+7RBqt9w35tBNG3AgxJBjCCNZFql6gxyomAr9LfqIZvJ5t2tXMv0mHh446HNmFpWu/IMZohVsQUn3w1mC+lEeY1/VMuBVbrVRMumRs4Ry+G4IPXqqLSwdZKZCdhefh1J8gi1O1WX4UrzROTv+h9Sd9PK8fqLX1PgfLXIB9eNWloRX/7hQY2FMBtjIhr2seIqrHlE1F4PXKxbkloV3KAQzGATAfU+S5jv2TVyIG2wYhgVhmUmzE+Gc650jlLjhMaFWxT0JKdbf6yc5xzd32/qu5NlYDk7XN7mrN5hWI1Aj6VaKd63o1qj3VEI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/12/26 20:48, Lorenzo Stoakes (ARM) wrote:
> On Mon, Oct 12, 2026 at 08:39:35PM +0200, David Hildenbrand (Arm) wrote:
>> On 10/12/26 20:35, Lorenzo Stoakes (ARM) wrote:
>>>
>>> That gets removed.
>>>
>>>
>>> I mean we do that in a subsequent commit, I think even the next one?
>>>
>>>
>>>
>>> Yeah, but to do that the code would now be something like:
>>>
>>> 	vma_flags_t masked = flags;
>>>
>>> 	/*
>>> 	  * vma_flags_is_mm_managed() tests VMA_IO_BIT, which will be removed
>>> 	 * in the next commit.
>>> 	 */
>>> 	vma_flags_clear(&flags, VMA_IO_BIT);
>>> 	if (!vma_flags_is_mm_managed(masked)) {
>>> 		...
>>> 	}
>>>
>>> Is that really worth it?
>>>
>>> I don't think there's really too much confusion intra-patch about that is there?
>>
>> I would do it as above (- the comment, as that is the next patch indeed) and
>> only remove the vma_flags_clear() in the next patch.
>>
>> But in any case, you should spell out that this is only temporary in the patch
>> description :)
> 
> And then there's a 'masked' variable that is unused?
> 
> You need to have two vma_flags_t variables to be able both clear VMA_IO_BIT
> and use vma_flags_is_mm_managed().
> 
> So the change would have to be
> 
> + 	vma_flags_t masked = *flags;
> +
> + 	vma_flags_clear(&flags, VMA_IO_BIT);
> + 	if (!vma_flags_is_mm_managed(&masked)) {
> + 		...
> + 	}
> 
> Then:
> 
> - 	vma_flags_t masked = *flags;
> -
> - 	vma_flags_clear(&flags, VMA_IO_BIT);
> - 	if (!vma_flags_is_mm_managed(&masked)) {
> + 	if (!vma_flags_is_mm_managed(flags)) {
>  		...
>  	}
> 
> Which doesn't really seem worth it for somebody who is confused between two
> patches mid-series.
> 
> But if you feel strongly I can make the change like that?

Whatever you prefer. Most important thing for me was finding it in the next
patch and being pleasantly surprised ;)

-- 
Cheers,

David

