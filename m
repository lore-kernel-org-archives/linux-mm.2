Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8AECA5FAB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 04:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19416B0088; Wed, 30 Sep 2026 00:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9F96B008A; Wed, 30 Sep 2026 00:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8366B008C; Wed, 30 Sep 2026 00:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CEEA6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 00:35:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 137F7A70E3
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:35:21 +0000 (UTC)
X-FDA: 85269164442.14.BDF3667
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4CBD920002
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:35:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="lgC6/g+m";
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790742919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJv7QFSawTRf+7Qaypvc1je5cVwExR1KbukcnwAizUQ=;
	b=OGldz2SW1NqfCDAWcnRcOfk6go7HyGSGCofEz/H4qfZu3MY8IIzTBBqaMi8IU8654VqvDG
	1hSCNeL3JDqgAuL6sjOnDlYLtoDI1SPeJfDjP7mpN3opYrIqfrDVeCk8Flq+TncGP9bdIw
	Q9CKT3R2OK62l6O3y0yLhs1ZTtEEnIw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="lgC6/g+m";
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790742919;
	b=KvPaQGCIfnlMUqynnLa1mlzSL0hzjWX5UIHdSXXw8/c73GtFxnNShNsHoSIIaDHFlcOM+v
	Ir0zEcANcUQXL30F98UwD963g3X11jXaSnlL13KcXJ0UTdsyab03g53retofnffOwFwLPd
	86aIRPn2STAIzu/zq4WxKv7vnb4u+/c=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 990121477;
	Tue, 29 Sep 2026 21:35:14 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 957183F85F;
	Tue, 29 Sep 2026 21:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790742918; bh=JkHtlPokOn2BvzhlFVjlfx9DCaqfOaYocdfBH7PqihI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lgC6/g+mujq1Di8KZWt65mHC5uA/Qzc5xT80jreFuxXslxLv02NzQrV6JYjehoAuH
	 2P1nYefRlxZyTLzAxT6VXMQKFBlCuTP7bT5bKmsIoL0fufhFfULbvB17Y8MsgFrD5W
	 iGRIG26gVobM8X7tH+/OJ4uUJIzt6YNGzZ9HwqE0=
Date: Wed, 30 Sep 2026 10:05:14 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, 
	Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, SJ Park <sj@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, damon@lists.linux.dev, kasan-dev@googlegroups.com, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 3/9] mm: use hw_pte_t for generic PTE table storage
Message-ID: <xzlxdkrjilskjcagnl33eed7ijxrgfhoalmmmq5ks3wgjmkkhi@zchtxpr2amff>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <20260922-pte0-v3-3-5670b8cb9059@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922-pte0-v3-3-5670b8cb9059@arm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4CBD920002
X-Stat-Signature: 31eajtwhft5p4fuacfoo497e3k75gx7m
X-Rspam-User: 
X-HE-Tag: 1790742919-320093
X-HE-Meta: U2FsdGVkX18vmurD50bAgg7zbaW5BLZvZUWOh4utdKXc1kmpcLvzsQoMLXM3uio8mvl0TEG+ve4d0k+AqxEnYFAcwRAwKgNHS6HezhdbikoVPEfdfJxj0YznrHlJoXfmH3K6ZhXu9ltQug7HO3CKS9QyyPfUoizE+EiCgr/Cquj3asLwkos/rY4ZhUewvVr1Tlb8J5XKy2w5NG19bLmHvdR/NAkenBykLt/6kfYUjKRPuXZdccu1Au+sg7+raaEZzxo1eO7h0kf/uA/FkmPApmn8/f9QKEIvFRdNoztC570bbJn0B7PnRl8QSiFkofJa/oX3O110Sbw+44JuHt+B0hKZ5cE6UZ5+7MTEBy2cCC4bLJmEkjwHafW+cqgEpn1qhTHrFSEs7AlO6NPlMbq47QlHWLUXnYbE8SHhXjyaUOFfpnQ0xwGgZlAIghmhOlFBbPuECRlPFjdqWyKKEugqqf11JIB6LFlljUAqZbQw4e7TY26jCt4KbUfOFvLS+gMLMyKIRDiTounARFDSFVuwZPKRebm/v3GFNLzzZfpReLbaqicCHCecQk/vslyS0EtGTWGSDmM/AE5Gj1AVKiKBxgdaJkW+PuBKY1IA2fWTF6gcrpb0NxaUzEZmTYNFTSLUFHm79lRsh6ysR0BieeYkD/NOURnKIv7+k++rRSXJt3bqwhEMbCDB9cVeGIT3X22xjvVUGCYUlOIJyF+Q7WYtfmZPWsKCbRMj6plFU5fh+mFg0cg9wI9Sh3X6xJgF5nZR47GYkuewe0sh/EpRPJPxCm3w7ZXWig2WzmxGlieC+H+/5d80tQk0OW3pbWvxYVXZ9pUW3Au9q6I/jAOEYj6f7Jke5tKuc+tN4rRbJPF3wMDVxx/KQ7ZRwbO+gPubO0/1dyb7kARN+mIGSkYbjeJocdx2DmTy9MWBqoe5R0XGJv6E/t15IVgJIoMnearef/VmOc63BzOQ/dQV8Ht0BuQ
 3Rp60Zcq
 pVl05cvLGz7Oi83Yd31BP/vSVdvgDwLkwaCV/A7lYJLihmHSlUmIzxLVyrdXzyWkQNSQeuFh2rYIiRYCcIH2OKxJIzVNumKj6dfhdVLJFAGz6vg6kIoPxudCvcJNhzHHMX2uOwCSgA1NmYJJ+fbJRYSDnRBuWccbNpY2FpFqf5PaRiWyiUsiCGbpzYYIq3k3BdSpEcUvLDhScZZkPP5iJUhaUH7lCkpw2fxjgtzNFGnqnMHB1BUK6ZzxaXZwvE+aVW2QpXebjWVavpmA23ikVQ1hsPGg6MHQuBQQCtIEgrdtzuXw7Ey4OpUdwCmBLcedhjdCue6rnCnImY7jNBGa5cG84NFKu4h6fHmwdHSvRuN9du3gKErTMa4AlUdzGgCRkF3m5B3xdWeJJNtL88/KnlvquhVXy50YRhq9M4m58V1erPCzVe08BaEBW142C6z/Ejyi5uP0neDYb6tSzDWi7FgmtLSyoT4iLq6/BqVdNS9MGy9r6fjsVF0CPLLUb+M7M2372ntT1MoIQZHVKOWrvjKAW0qMT2oa03pE3o7636bEVCDukPdW9MeEFIuy7Us3Q59D6OxuEwtpCdBJ91TXPjAfELzuk0WKLYDhJVjzelsItiRO6bwTKUUSlODm6OyvsiKlcxJ4z3hI7kCSX3hPqOrGMfwpGfLzZloI1hOazcSnGfGVEV+kUrgHlDvejn2bjLvx9tma46a1fLDVZaDbYal6zzANk6VEfUX3nTRryJCD4r7+J32vpDB/qwiIifAkTJeqjKcq51kwsaLUYRb7qe+qcOcIPWlOskRfUGxj+ZkTYB/5YqpoDkw7BlpjgLUMbq/Ccg/OXpBU6Mlqmd0HHuJZ05CdRSyCDVSrR20TE+gC6gkctbTUstA28LHQBsQWiB3w3WIF0xbeypTAUCjtTdQUu3eWbkG5dxGEP6BrIom6T4HpcrZrGRD1iue9Qke6VLYTHPZgNkayGZ98ytYRa46euqDLq
 8zMllitZ
 Zuy3zOL4dFrfHZGixPfp0ohPf7IJxkmQ9B7cGJzEuYijd65K3C3EezQzK/ewbDyt3tm1FcDc2992rx2/6wL0qi/Msh0xmLRhRRN0EOLrWwarpT/2fYeHamCyJFpPZ3Lcc/J2QgSAQjAcdKvd73ctHUuIHNj+lhWp1nwNjWxtzNUJArzHWS8R9CYWHum0sg8zFTtSDl9jvuh4lAgGQJQvRrFR9JufxU5toujJIWgKONBZmIMfns0CnHEJxn8ZX98NVJWk6u3Q0fJNCRxFP1ePe8ztmaaIdeex+bccW99ExUNjR/lnRSzWWM6/7m0C9oMBKRaL2LPvWsL+3YPP6G4Wi//PsceHUmVaSa5FcTcc2K0cdv01/IX9zHPsyYrX4rk1DP+EmB/I+VCEN7R66fPoMxFamc8Fk+S90tC2v9B7Ugzeead/FTO6epQI4bmmUgflRM26eoYlNpnDiJfVaCwjhQVXkpaNoCluMqK4P51fO5Hy++z7L/WtZBEJS3plYVjVyf79loWFQsNS0k7/Fkyr0tnQSXrhuQVF43bzUM27z7rt26uDl2Mi+GxC/njXGgk8ryGMMBeeNW32v7IjnkykqCq1kWl+bhyDuVu9lI9spyErYVR2W7uOAE6feyGq1fKPyO0HPw2C3MYcoXtTSz2yD6X4CJOkZCm9/Jae7r90yITm2qtxuP85TjcT24jC3RjqqIrbXPRRDRVn4wtedx2ahis2+4uuG3GObV6YLJx6e1JZ6pZfyszAmLL+IB+BUnvYqoVQwTLwcinLAHZrJFQRWM/MvyI//rd4d70D0SvQdqyYkIM1hGAc1+nnAJTxbHEl8KUjMnI2lA/CeK9NNiYqQ0vG3sVLRikcFSGXXrCyZxSABYlqgPFfku97xzlU+PAYiYFfX+tNMRhIZ8MtY1npBZlWDa1x8KxFZSBBDJSoAviWj2db+ewGi+TCauiyK9cUOjouvuTOfKoTn0dEiv6QxLo3uVhjD
 1ews2Rum
 yIv4Dy1mDafzCLY5dQAKUami5GCVW43uUZkg8G5D6b3+fqWN4g3ASZ3+BNugwW0mOSFadDQdv1IyEx00xrbx3kcBF7CZ5WPPsLueRCqEsWo/BUnyOaIbgzNE0+imi1dfnDX9dJgR7/IseU3z694hIfwyXgNT5kkdsJQWRLl+jgzNttbaobP3nwaQyvbVLe0qVX85eJRr01w5/XvnoSPYklDYFMS4zs4//fZZ3aMXGRI+JVoHVvPYasVZjgewbaWTykErMLgFUmFOn+/GMDQnPRoIZW7a+/49GpMeiFYrgPAQg6d9v7XXLsJ1mYM7beWPusS8Ap12fF0mbfgYee7LpnmxEmmRumvpoHdo4nHL9XxGcEQJJVJ4MMaIhQ9okAVPyc2kKxLNTeezEgKvdmsWb5RLBNyn5x4T8neuXhzE28YqZGqeEduTGeO5fUm5rNT6D19iLkAoWBOxDob6k1UnJn5LqGLsI/xlCCmDowGCvb8DLwb40N3nzwYEwS2PYwIYYv9eEN5uz1PWW8f84P+evUOr00eIXcigJv9cGmoaNHnO9mIuE2iHedKDBp7Jtls7HqsBlrgab3fY7YbQ1g/k6BxsEZ3kst1w9gxmMo+8jfq8hx4Rnmjyl5KHzp0a77jBX7TraPW9BM/iKajTrAN5jbKazHuTxENuzw1yZqVb1JZijafTTzjE4e8F5f2Y/0/QCay3hZfW/KiV5hDhyIupQEx30XvM8jgZpC+1CGvNff6PW75BEm8slG/kJkqMuO40Ysc30CA6j5GGmD6PNkB2ZsXU8bDgd8NmI2Jv60c82x0/AObGuqDgZtFdUqLrOc5XNArJv4Czs7mYgbOJg+XNcPakxlP5Z0H1YHxTkETGBlX2TcmiKldAf8a6VO7LB48WtmyCs2bOSeQGuUVOYm96hvwJnqGUp5kBYZ0eiH0J3Bi6vEbJoqbRD8TouvH0p3enhL+/UvawzJODxU8AwEuk5PR3gCRLF
 DhaEDhdh
 iNeZzGzNJ0V+Aa+Ld40JfghpRz6j+ZIrS5jev0u24DxHq/00xiICK/QFrRP7zA8NAq8bOilgT2h++nCuPW920vyARskEm+dkh85x9wVtL39eo1MDs+5jMqNZnAEuTuzlOtq853+4lQfbvWywDHsayJtTqQb4cK7nESZwoZh98YhZ5ydnFed2WyCTsB+5bf/GJT0v1okM/PzgIO60gd6NzXWgKjSQIr88OiEW5W+wjOK0BDP4UP0h/QxuYppqnArtZOdV0oxXgmT1T9/sCoQULZ7aOohukbXmKB7MGoHyoVBZ0wGG5+dya9pSkxRsdUtDABqP3ERF1HIlXDvLfsa512VAUaBjHpfNGHojGkpCywDFkmWCcwVP1f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 06:12:31PM +0100, Muhammad Usama Anjum wrote:
> Generic page-table interfaces use pte_t * for both pointers to PTE table
> storage and pointers to software PTE values. Convert the generic
> declarations and their MM, fs, and kernel users together so parameters,
> return types, callbacks, and local pointers that designate table storage
> use hw_pte_t *.
> 
> Include linux/pgtable_types.h from headers that expose the converted
> interfaces. It continues to provide pgprot_t to vmalloc.h through
> asm/page.h.
> 
> Keep software PTE values as pte_t and retain pte_t * for value interfaces.
> 
> No architecture selects ARCH_HAS_HW_PTE_T at this point, so hw_pte_t
> remains an alias of pte_t and this changes the interface vocabulary without
> changing representation or behavior.
> 
> Most of this mechanical conversion was generated with the Coccinelle script
> included in the cover letter. The script deliberately ignores pte_t *

Just wondering - should this Coccinelle script that converted all these
instances be saved inside ./scripts/coccinelle/ for future referene.

