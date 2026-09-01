Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A54CC624CE
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 01:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ABF46B008A; Mon, 31 Aug 2026 21:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55DE96B008C; Mon, 31 Aug 2026 21:10:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 473726B0092; Mon, 31 Aug 2026 21:10:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D41F6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:10:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C9C4A02CE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:10:04 +0000 (UTC)
X-FDA: 85163411928.10.A52ED15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id DE0BC180007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:10:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZjTiFKQd;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788225003;
	b=Ex3zmDnZXvpV7gUs78y0/ObkgAwIb4alp5yM9TtuUBZGHP+Fvz9I7YskfYu+lwgU4EVRBL
	4ExfIARvswDea4Ds4vUgK+4LjAfAbNxZ+sAgVC5iXgck2SyiRehciWn/oyiytrYtB46Aga
	/xaY5Wi0fCtKTF325+AElTy5L+x6c74=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788225003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1oZm4WwnJE9a1bcKC6zS9Kgispny6D5jmDZJ5LFvVA=;
	b=zVajGD5Wm07bBnzYWfYbaSgpFogHSRe9dQaBlEBid2N1mqW4UTiQAbU3sCdit2qvtHWLiH
	H6VWoRX9aZHvsQ3b7Oq7b+5tTGXcj0X4KGUFzh5BUJG12G6anNCxhnC7Ci2yPkIQvj60+M
	vr0o0OJEBVEIOo8UiVFjRE+d1Ham818=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZjTiFKQd;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DFD55407A5;
	Tue,  1 Sep 2026 01:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7663D1F00A3D;
	Tue,  1 Sep 2026 01:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788225001;
	bh=y1oZm4WwnJE9a1bcKC6zS9Kgispny6D5jmDZJ5LFvVA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZjTiFKQdhaHeMVQoULPC2+n+Dvmm5yJu4/GHjF0ED/K1JLF8CAZMyilycoof7LN2U
	 eCr8ig6VMzyDOTfNzSPXbgAP35xuSn1CWFazWZem3JOoonIU3N7IkSYuxJhvsyqGZK
	 SIwot2H3myVPu2spB2z1x+GV0MmS9sr0V+GGCAfc=
Date: Mon, 31 Aug 2026 18:10:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 mike.kravetz@oracle.com, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
Subject: Re: [PATCH v2 0/2] mm/hugetlb: fix surplus accounting and
 availability checks during demotion
Message-Id: <20260831181001.ad2df1afb44789cfeb79fd81@linux-foundation.org>
In-Reply-To: <20260831133519.2505020-1-xialonglong2025@163.com>
References: <20260831133519.2505020-1-xialonglong2025@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DE0BC180007
X-Stat-Signature: cudwjqonzbms86amo3p1pn873fsuggtr
X-HE-Tag: 1788225002-929269
X-HE-Meta: U2FsdGVkX19GOyjJaB3HKYtDmy/3ZxL9u6taKCdCq9HbJ6TMz+2c0JT2YrYrR9CGht6rDrNlvEHcbU7ov552tJfkYMhvN9TIXGGmOhyIoZwPSOU8X0+Ka+Gt2gcNEhWmPlXLhn+B0gU4gRHsFLs20CCDVhMVQSSKb0xKsr/9uk3M3nmJNHvVfORE/hFBng+VWp30he2OksAZiqOk8VVDG6eoz1KGYfZLdmt2R3Yg0NhB36uLGWHu++3gBJeGVaRhwqeAcnD8bADx8YwZcs5X9AFEfS9WP19aJPkbOgOjTSlBKJeMRKzaPCQ3V8lzVQWZcakVBkZ3iQjDLHUNrPDOVUFcAsNy/Vm28otODhPnUqFfS887gABSBBak0D97cAOCMrzi5S0ZX0Gz2KUQZsHnQkWanutzqh9IrAi6FpydVt5S9oGlQ6FU79TdlO9hO3rwstq8pAqaFI8q5qu//3YrNnh1PwoHHy/iKTovhe/xdnSgJH9BguCtQEothNqI4SuJxZcCDFmQGUqJnaCo3K1dA1tXrxRDta3PQ+1oxfGuXeprHdi7Ne6TeQs+59JvbXGhD9WNiWri33Dq5tIqRN7N5fxYRs8hdIIoLcQ6mfteYfO0evQPO3zYk6sg2VqVqNwqTzzpnrJQhdT9CZYr+CX3GNP0DTwfDahMQLg5qnW7Ava+BML2KmoWm/QwTnYCZxOvD3evwT9TwBjxwesVoEtDMnGU76DGsfX3ehu9Ckkaemnln63QYEhaKt/xKgUbOuGE84bUPabFsdclBkoMeFlBnrY0rWuCMTltNJTeLNThmM739bupPQWBYPQ+PhNaR2Tj74+s0oOti04Bb7yLJzHdyaEZqadfgmFrIRwpfSEGV6F5pJoNIUwOu+wFLyRK7o7yepAuAjajgyjNL72tUGhI5whBySiIY3OOmFfmW94xl3c5RYpvWpqTLg069iWt9kdom3rqf3zItVU4HqPQqLj
 76mEsbzP
 I0BsQse3AY4QxnM+NiJHEjHVipkUFsYx3rjO5JYonTYRIa3nCv7dlin9iWWxbMt4YmEkrElPYQB8YYjb7JQrfp7nR3wY2d9NMn9IDdnwSwPhg3oQTmd3DPFmmANUpzSypY8ew0jfSQHsA9MaO6vGq13Ztf4RK8zQP5XeOwcyWIX1ZAcidQHxJZzXvtrxzo3CnosPyxL1+u+hQEVwGrbIStQaQ41CEXIxK6+DknH7YgQBAYXQ2vFkzc7f01BCBrTc6l6T7uk4MtcxnYub2HCpR2oBZEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 21:35:17 +0800 Longlong Xia <xialonglong2025@163.com> wrote:

> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> This is v2 of the two-patch series fixing surplus accounting and
> availability checks in the hugetlb demote path.
> 
> Patch 1 fixes source hstate accounting when the free folio selected for
> demotion accounts for a surplus page. Patch 2 prevents demotion from
> removing free huge pages that back reservations.
> 
> Both fixes were tested with x86_64 QEMU guests. The commands below use:
> 
>   hstate=/sys/kernel/mm/hugepages/hugepages-1048576kB
> 
> Patch 1: surplus accounting
> 
> A vmemmap restoration failure is difficult to trigger deterministically.
> For this test only, add a one-shot fault injection that makes the first
> attempt to restore the vmemmap of an optimized 1 GiB folio fail:

OK, so hard to hit from userspace but not impossible.

> Patch 2: cap demotion
> 
> This reproducer requires no kernel instrumentation.
> 
> ...
> 
>    Before this fix, the access fails with SIGBUS and leaves:
> 
>      nr=0 surplus=0 free=0 resv=0
> 
>    After this fix, the access succeeds and leaves:
> 
>      nr=1 surplus=0 free=1 resv=0

OK, that's bad behavior.

I asked my friendly neighborhood LLM and was told

: I'd phrase it like this, keeping the stable justification concrete
: without overstating the exact failure mode:
: 
: On architectures where gigantic HugeTLB pages cannot be allocated or
: freed at runtime, memory hot-remove or hwpoison can attempt to dissolve
: a boot-allocated gigantic page.  The lower-level removal helpers
: silently reject such pages, but dissolve_free_hugetlb_folio() continues
: and can free the folio while it is still on the HugeTLB free list.  If
: vmemmap restoration fails, the rollback can additionally add the
: already-listed folio to the free list again.
: 
: This corrupts the HugeTLB free-page state.  The corruption can persist
: beyond the operation which triggered it and be encountered by a later
: HugeTLB allocation, potentially resulting in kernel warnings, crashes
: or memory corruption.  Avoid the corruption by rejecting gigantic pages
: without runtime support before modifying the HugeTLB pool.

So, with a statement like that, I'm thinking that we should backport
these fixes (or something else that fixes these issues!)

Anyway, these are matters for maintainers to consider, please.  For now
I'll get these patches under test.

