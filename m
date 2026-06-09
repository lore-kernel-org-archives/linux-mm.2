Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AFEDCD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9417E6B0005; Tue,  9 Jun 2026 14:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919366B0088; Tue,  9 Jun 2026 14:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856146B008A; Tue,  9 Jun 2026 14:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A4096B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:10:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 111E2164F9B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:10:25 +0000 (UTC)
X-FDA: 84861164010.03.E326062
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D9DFD140013
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:10:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zLBEZnL8;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781028623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gTxiinItA/M18gsL2pov1Gxb8jn8dEK6DGbUFosQnQY=;
	b=U4hF2U1Ab0LXhk+vIk2nHY3nMd7AiafcUm43aEpwHQlufWMTc6n+rQfd5XdrcAlzwKHAwG
	Fi6l+et7Ucw5Q8tzzGeO6geTdb/IAxtKQz21fYE17izPp6Aydm2WcApHHCJCiCgAsRTrQL
	LUV8oiC92fxlYUSSuBopjDNvkujnp+Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zLBEZnL8;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781028623;
	b=HzqfeZ81KmKgtfmHU8wMWoZ0jPiC5oQllLUSNyd66ez2T1LkLjh4ES5KbO954cWik/4fRT
	emnbRLxeKwY6I4YSdjA6oJIjKB0GNiBEArNtSZpXxUV6W8fYOVelkIPtuAd3S8dqVwj9CO
	B8cQQnkqxAQKr/HPSdz8tL5R+obp3mM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FFFD60218;
	Tue,  9 Jun 2026 18:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1551F00898;
	Tue,  9 Jun 2026 18:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781028621;
	bh=gTxiinItA/M18gsL2pov1Gxb8jn8dEK6DGbUFosQnQY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zLBEZnL8a3T5c/z7U6Cj4ItzXNne0YkfEHRwKpnAz3vsg3C4GobBxMmrl/ZSci7aU
	 Q2zWXEr4eDoaFCZJm1Sg9eTHvVnOo6Zjxcb8wLu7iV4BrZixhfKBj7vaTI8CTiHBvg
	 n6zTywTsgpDeOOxzzmUZbqlsgwx0NwylIDGItyGc=
Date: Tue, 9 Jun 2026 11:10:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang
 <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio
 =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, David
 Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org, Andrea Arcangeli
 <aarcange@redhat.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
Message-Id: <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
In-Reply-To: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
References: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D9DFD140013
X-Stat-Signature: a6fmy5zq3ti14xes47e6p6eyhqq4u555
X-HE-Tag: 1781028622-484202
X-HE-Meta: U2FsdGVkX18e+INuENN9M3SclnkLUR3iHnZHtUzXOdm+KsIQJ40R3yTqoFX1z8JrjzhDBMJD1iLK7Rbwl5tt1SDSTfmi9y/r3Swd3ILAFThcOa3cUN0fQ2Zb3II/Rr5bfAFasoe7q5MPKfgcrz8A2sw7Ty5+LIH2NfSe2jk6d9w9lOLEGXJzvhtTqU3x/gnbMOrDEmk2G0tGLR/r9GoL1G1NvoJKBl1t7SY8lHPS9f448EtPjmwDyS+Q1B2Qtqt8M1ihrEMrhiHn1W63Pgw9FO6AptNEFojxQ+1KBk9xxTu+JKiU0C+iUbQqTX2KsNB7D2gZ0pFm4JhiuxNZTpugcY+9kxCrjfHaJpETsjjE+WI+I+tI4g01WdKLDqlOYx+J7e3QNGfbJ9KdZ8aulR+MEMQzV5zy5kJnTBRgPmOpZUK+cgoS3C+sEPF62NUjZelLykeybaiWL939qSjGUELz1ou5W8dlNLffD1yGCJ9pJlrGAZtcQfIUvaLKjt/c2/BQgDQnWGmPq99dgwcZsVkSC9PlO9B9CiYHNHvo7iBNtNEC1aTyZOfQdZpdRmuogsCBIP0UUyLH2NWv2xc85YUm5n5pmDgKZyNimTA8Cu+dgaUsHDA5qiucWax22WF2i1ihm2nenzfoHf9Sb4Rulbm8SPfmFodSSA5sA0+KXNbDorBUfEIoGtMA4Gh3B7XDI7vpm2G1HUqcegkevB5ZjtzsedQ35TN+NZ+xc7O6omZ1bshTz4wH/2DsbKRQeVb6Bz8pEhrBCfuT6JV1BXZd4aauaVIwWwuzWso66GSaurXGLOghpNyNzau5g2V8/9/1jHJKlpknpLOLfKsVMeqfAhoWXEtr73LT1X0Vtezqdt8LF/kXYN8nNPltGOxCdjjXSvCYKfboY3I9QzIQjo+zLnu5+Qe8indhCLEmATpSTDGuIzx3UnaTHthnFITv3FCTO07zZPKWZVlBhRNgj+aWBvD
 xJG8+x17
 RPeCuyM6zlt13YtGhVLbi+WcbFOKsKt6ExY1EZP5Bpkt2+Bv2qlCn+JH8z3fryv/iHvsdfBiW8o1j36+w0EA2CNwbfxTdzWhIUujsya8T58DOanZ5xFpLC3I0wDe8NOgpoYOBxwqdIz5KksP7DQesaBAPJgsBQCV4bozpsqz/hFWaXGZfMnjnv3Fcl4xMpOjy1X/k7wJoag2z7uQ46hYXFQc/H9fqCrXXTC0JzEYmDuuZ2kaiimnZdDlYiNzSF0cB0lgsG/Ckb6LmbYClTWiBajKKRZD0P4Z9FnPQzHdfb7tdkUqTQhGNRNzl6rechh0+FEoPccTwCGufnPoLU81FGVlIF754a9VVQ9sydrr5sB+6AsSJxsHbIDXbyWq89sH0rZZT2BP2UwimUf8nApFtkdctF93pzMYwLNLD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Jun 2026 06:12:49 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:

> TestSetPageHWPoison() is called without zone->lock, so its atomic
> update to page->flags can race with non-atomic flag operations
> that run under zone->lock in the buddy allocator.
> 
> In particular, __free_pages_prepare() does:
> 
>     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> 
> This non-atomic read-modify-write, while correctly excluding
> __PG_HWPOISON from the mask, can still lose a concurrent
> TestSetPageHWPoison if the read happens before the poison bit
> is set and the write happens after.  Will only get worse if/when
> we add more non-atomic flag operations.
> 
> Fix by acquiring zone->lock around TestSetPageHWPoison and
> around ClearPageHWPoison in the retry path.  This
> serializes with all buddy flag manipulation.  The cost is
> negligible: one lock/unlock in an extremely rare path
> (hardware memory errors).
> 
> Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
> in this file operate on pages already removed from the buddy
> allocator or on non-buddy pages (DAX, hugetlb), so they do not
> need zone->lock protection.

Sashiko is saying this doesn't do anything "Because
__free_pages_prepare() executes entirely locklessly".  Did it goof?

https://sashiko.dev/#/patchset/df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com



