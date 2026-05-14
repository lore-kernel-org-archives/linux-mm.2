Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D842CCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 10:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F28C6B008A; Thu, 14 May 2026 06:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BD06B008C; Thu, 14 May 2026 06:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85576B0092; Thu, 14 May 2026 06:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D30546B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:56:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84E4B1608EC
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:56:04 +0000 (UTC)
X-FDA: 84765720648.01.5B905CB
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id D5B87140008
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:56:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=B9HEdahA;
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778756163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1XfFPCmDqRYJH/xx62DhOLsvdI6QVPwH3gKtkBbqlss=;
	b=ViVAYUz6UHqLmWmka1DPUHEwlcz88x3ThT7vVz+UWiv1lwhQi8CzWWnM+OravzjzYP2eSa
	yH5Y4IPOZPz1wX3U4qaDpreJzfHTw5e8+IzJfmxcMfG0LpihabFau3RfbplstIrMOBTJDE
	+wCfKFOvGcv30EUVgZBXQHPKU4lVUUQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=B9HEdahA;
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778756163; a=rsa-sha256;
	cv=none;
	b=NEwwPSJYy5j+Xs+TQS+tEuq2XuLu2qD//1+spx3Ir9YkzxWAJ36qyRJVs80iSkvTzPinHw
	ZZictChNh6UhO3+t7JnMR2G0UnyZoKnkE1lxcz/lZ3Cp9XNb/1wgbVwlFA/9GniQeCbXiB
	KEUio8YEi6K1rDCcTWmS4tn6i2QUVLw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1XfFPCmDqRYJH/xx62DhOLsvdI6QVPwH3gKtkBbqlss=; b=B9HEdahAa6wSr6VvT/NOnU7vKE
	Urnc753D8MO9TmdbKrqkwpJyzZBzwLPj7NLh1/k5YceDEq+2+f3VB2mC+QQkIJl6ywdiJ7+SwAUt8
	CKuyoNBgpR4ICsG4PhDjeXRbPFgBf13NT7F32vK2nfR9br27qdep5cB41XZQZJO0nu+BZovNEiWyi
	R55CBMaHeaj1l0FbUQPc6URoeyB5pqN3bQOgJ5bUbvsScamXGVVlnR+b4Nj2vxX/4cI/BJPe45jM/
	KsgUgkPiwvi6OIhnShr1q/BgLyZcdIo2xGEgvou2ZymzZPBr24nR2imkDmXtfCikhlIKEHrZdHDZh
	O1bkZCgQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wNTj6-003tA7-3D;
	Thu, 14 May 2026 10:55:37 +0000
Date: Thu, 14 May 2026 03:55:30 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v7 1/6] mm/memory-failure: drop dead error_states[] entry
 for reserved pages
Message-ID: <agWmHFe4QlIfU7LV@gmail.com>
References: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
 <20260513-ecc_panic-v7-1-be2e578e61da@debian.org>
 <5712adbc-b2fd-49fd-9827-cace47eff9ad@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5712adbc-b2fd-49fd-9827-cace47eff9ad@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: D5B87140008
X-Rspamd-Server: rspam06
X-Stat-Signature: uo1yznatjd5tiwbwtn64uu4mim4acnx7
X-HE-Tag: 1778756162-964093
X-HE-Meta: U2FsdGVkX1/agVQHjYbgA2Xqofk2IbW8B3ffPCsdehIR2wLbuxDAsj5ZX2MtP43TMQZAr1qhcRpALpHjHAiY6Z8lFxW6BbHHA2U3E2uNC/x4/xzhdbVoRvI2hxrqAID7rEMqBmUwj2DNhlVhQ/floEx+cEIl8HASEkOu/OWTT3Q5orrHC1Scn3G109RoP7lHsz9BVQxAhw+5Zw1GpmqjdWuHF/+KuhsTo472u0lGxAI/OcuZlL1Nfkb+pwhOXa41u4ZFk2kpebPBOiO2k4Y8dPJyvs2gLOMYjWO97lqFy0ny8Yl974ou9rfjiEfoK3JdcsHsPx5pjYeJaEx61HrgtPgP9kLzPmoAOc9DRZwQYxN6b5BI8qpTob2+PVzzOg6EsJWGyZ8TiH7wtvA9ZFh/WGHp78LN+wyMGoQX+XNly2hT4614CBDMVYpXAXRnkdCb1O5j0uj1Al9KNPq9GJDhTSCqLHkarhPYaNc7r4pT9uuYU+XW3chLf+SfCDoarO/lwqH/6OayRgrxU0x58a+iQo71BMb89XC9jNspAVSuUf/Qpad0Ub8eXaFMxpMO7K2ZL5QOXerv1Ij1M6Z9BxZliTQm3l7Y+yxfvdjPKL+AHFUffr47I9JpfJJ1qt9HVqQ08UBSurlSGI/iq4eHoiwHeEnS2SsjoZ9JFOrtrqxPzT983TJkoaNfRfThvWZjObphSMapKXPN6PLvCKbnptFkRSMRUx8PWoIFDBiAOIghk8j9UUc8GM1NtG+X0TDYqPrRO76XrqVLvaOHhJRF+/FDWyEAUw4NszyTMAr2uq9/rzgnokve1MWzbNfT0mSn74ZqssRyhMr+TWCQ4XTTJZ9sH+DYDsgPXKEclyMT/nsgDqeSq1AnBBgyW8mOz2+/2teWdGmL7xjYnjd906nlyVkB1NNnr5D88e9fv0Bq7iDpex8KrBenNyzJ7yxYzf8r58n/XsohxkgQ014/kubLxKX
 5A4flevm
 YizrJrdypV9zx9GAEEHvf5i2J4nD9v2NQFTwpgZyXiVxK+VaUh485k8qhzvTuWn3hiIjHDpQPe2wkhDKNxuA1hgP1Bbu6da4I8tmoHHaq9SYzWQuyeApZLEO1xve5LKAkQskqarHHA9ZGrwqXlxad8EFU/5NFjK/nySSNWEnP6F1nfGSdBrsbghLhO4JQZz/9GfCJkSeC3cYIZWLXfinvBMdqL06ozDesahpB2x8SYKfMb1IjGYLEzOpWGTnYQT/KEXSfa0tQ7aH90ZvSevOStJ7eXl/AFym1zk7psZXV165R6vCZyfM3bhahRpzTLJlfC1hHdisEnxn813VQbmTEk/xTXypxLV50gPpgXECPLaFX3Bo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 10:10:27PM +0200, David Hildenbrand (Arm) wrote:
> On 5/13/26 17:39, Breno Leitao wrote:
> >   * memory_failure() reaches identify_page_state() only after
> >     get_hwpoison_page() returned 1.  get_any_page() reaches that
> >     return only via __get_hwpoison_page(), which gates the refcount
> >     on HWPoisonHandlable().  HWPoisonHandlable() rejects PG_reserved
> >     pages, so they fail with -EBUSY/-EIO long before
> >     identify_page_state() runs.
> 
> You should clarify why they are rejected. There is no explicit check for
> PG_reserved in there!

True, I meant that PG_reserved pages do not fit any of the criterias of
HWPoisonHandlable().

I will rewrite it more explictly:

	__get_hwpoison_page() only takes a refcount when the page is
	HWPoisonHandlable()'d, and HWPoisonHandlable() is an allowlist for LRU /
	free-buddy / (soft-offline) movable_ops pages.

is it any better?

> >   * try_memory_failure_hugetlb() reaches identify_page_state() on
> >     the MF_HUGETLB_IN_USED branch, but the page is necessarily a
> >     hugetlb folio there.  The first table entry that matches a
> >     hugetlb folio is { head, head, MF_MSG_HUGE, me_huge_page }, so
> >     they dispatch to me_huge_page() before the (now-removed)
> >     reserved entry would have matched, regardless of whether
> >     PG_reserved happens to be set on the head page.
> 
> See hugetlb_folio_init_vmemmap(): we always clear PG_reserved for hugetlb folios
> allocated from memblock.

Thanks. I clearly see a call to __folio_clear_reserved(folio), so, huge pagetlb folios
are never reserved.

A better summary would be:

	try_memory_failure_hugetlb() reaches identify_page_state() only via the
	MF_HUGETLB_IN_USED branch, as hugetlb folios don't carry PG_reserved at
	that point (hugetlb_folio_init_vmemmap() clears it during init).

> Yes, I think this should work.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks for the review,
--breno

