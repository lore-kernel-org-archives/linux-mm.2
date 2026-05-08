Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8318DCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 11:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B504F6B0145; Fri,  8 May 2026 07:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28C76B0146; Fri,  8 May 2026 07:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D7D6B0147; Fri,  8 May 2026 07:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92CD86B0145
	for <linux-mm@kvack.org>; Fri,  8 May 2026 07:12:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46EEA120814
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:12:21 +0000 (UTC)
X-FDA: 84743988882.30.E043DC7
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8324C180014
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:12:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778238739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WQis/+eM7l1uAKIgv3HxViGZpt+nFeQRW+hLB5igYBA=;
	b=P7eYFY/CoK6UL60jBlV/m6LZazlgpFjQsT7kWLXuvCyurRBd0TVF4rLxgnNoX8KEljBzLL
	HC/LwSJ/F7ckqFlU1Vm/K2UIWpSoDFVae9ZgLSnj7swuuF+/TTa7HCKLl23mVYe5TGmIbI
	/p5NWbBrMJyoQCxN0w/dcFhXu/4AXMc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778238739; a=rsa-sha256;
	cv=none;
	b=H1mxbuMxj2a38wUNt69u5mnPl/rHpvaMYmB5HD+60p+HnTbLjkjmgcsBLJj6Ssx3twNJn9
	APfqhm8qPT9HfZ5vEN9gD+r8Xw5XTOuDE3xxhR4rPQn00dgpM9kcmuCYJ3dDm++Pfh/egb
	efI3kyvII4AgyBQ3yzBS2eRsX8zTrMI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH 7.2 v16 03/13] mm/khugepaged: rework max_ptes_* handling with helper functions
Date: Fri,  8 May 2026 19:11:50 +0800
Message-Id: <20260508111150.16625-1-lance.yang@linux.dev>
In-Reply-To: <20260419185750.260784-4-npache@redhat.com>
References: <20260419185750.260784-4-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 8324C180014
X-Rspamd-Server: rspam06
X-Stat-Signature: rp5bjehben8a891dx6fs57g6bhc1ossj
X-HE-Tag: 1778238739-217457
X-HE-Meta: U2FsdGVkX19MHyxbVTrQPLTGcKZhCvFz1EDlYM888c3HNMH1ufZ/Nf9kU99OulAILkBsO2MELjEJMLtBF2CSG1bGA5S2wQ9jEsNhvPAd7EDHYwfXfxqqdG3fKLETSywz3A9m8EUkaDMCupvjvZBaVHy6W6h5+YfzDuMSKjtg+YxGgpFwrAmShyOsFKfFcioSNNToLnAfRka44i9jyu43iCqbZzlbUJXJKYz2MBG98BfOQN3RfFgQYx1mJZQOJyo8B10+xLYcaeKsEFbED9MVnpRbL/RW7RSokY8R7NjSdO3J6xvPBNxBf/hmFUFDfjfZrX4bik9d/3XR8L3BblODhsP+CxguUb2jgpX3OopHbc2+SYbqMK+PDpKl/EJOsaYD7+f21N+v5W5OwGiQNZdGIkZpzMzTFOP6A4iI5lH79d0SkkRNeI4EiOMlgdypcILnyUuKBsc9zYS/WmupAfRQad/I1AIIJX4rlqBGeNJZGzUruFhW+c6pFS6hcy/ldzvHLfFM/xgAeh228G9Vzlikw9fFqUGSf7JUvjtDaSYOiLCudfuDq8qQWkbB6oDXhs8PF3zF6BCCcjh0cIpqFaIGJIJINeSwYRs+pCQd6KwLlHBYEhRzRuo04mvI75d0+YBwxzzONfB7qPCJIh+E/eRXbh0i1kPFK1orgogRI2nhwTCcUCIYM+A1p9nhJxLzISZVlxosopsHPna1YQSxHu1zWXo1nZqwwncgky847IWNyTT67KzpRZZO5K6tBkbl2mDrRHQZebdJ1WBOE2e9bJ6zzQcgfKx1+7fZgC7gnLiJVTK8rGuyR5vo/VkOf4oQnx/4enACT91MyI2voNQ/zK+gHd3AEMufau69HXmZeB+JB/dJ012nGDdCKyfxkct6qr8qcNoO+/OHqW8IlUkoDJFXvgljA+dyrrurUeC6fESOvYevv+K9NFyDHWTv2MkNY4njNnVmL+vUhx7AQG0eiPD
 FWc7WPcB
 yqGFGsVjh7149nY7JAESxKh51oOPSGrHjc4TozMC2ye1OIc3xQS4JIxX2nOWpuY8Yt1smiOiyvhz4tlOxFWQKoiVGB/DhfI3uDJinbURPZchur1pSrpQSffvaFniPuX2UxtAwwC/Ayh0R4oWoqwQYonKorS9jRvQGYL5nPlqP/pF5ou622n4I4R2zxK/bBAI3Fq8CtU6x2E6LR2wQ2HX+o3NOsCRzz34AveAaoRhtAly0XG6X3pXspRyZdm6xc6QaIgBlN4Nu2O7FfymNP6e17EEwsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun, Apr 19, 2026 at 12:57:40PM -0600, Nico Pache wrote:
>The following cleanup reworks all the max_ptes_* handling into helper
>functions. This increases the code readability and will later be used to
>implement the mTHP handling of these variables.
>
>With these changes we abstract all the madvise_collapse() special casing
>(dont respect the sysctls) away from the functions that utilize them. And
>will later in this series to cleanly restrict mTHP collapses behaviors.
>
>Suggested-by: David Hildenbrand <david@kernel.org>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---

Nice. It should all be an equivalence-preserving refactor.

With David's suggested changes:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

