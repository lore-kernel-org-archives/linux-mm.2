Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48FF7C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 18:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166746B009E; Sun,  5 Jul 2026 14:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F0E96B00A0; Sun,  5 Jul 2026 14:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA036B00A1; Sun,  5 Jul 2026 14:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C24F46B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:50:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44CCAA0190
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:50:50 +0000 (UTC)
X-FDA: 84955614660.11.E8EC250
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 79612120005
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:50:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="rtHQAfw/";
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783277448;
	b=fivl1pVeXO9K2Xoju2N9GJos/RsF7dg68tyjCks5QnYB2BJZBJ2VEq1dLtGWqoDAg7qlOI
	8D+xewf/vVpdXvO73q/5BNsj7WTgYhT2qN+ZtSYtzRpRdEGaQ3UyQ6+wNFbgQll6mDQoKO
	y56ol9RkotjoO2s7l/T4E2AsZpEuCTc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="rtHQAfw/";
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783277448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8lzWoonUAmF9jSZ3sxb3NCfU6HKSy4ivLDREqGKh2U=;
	b=NbR2SbhF85PrR1mQ9CMEABy7wEpZyhugQ9ltxUXEgYSxhyT8i+hD38De9sMzFtFlQO2XR+
	nDDEwoUTexbjARzUhrIS4RenxbMEPLQAF31OMRpPJdYgKdd+q5FAFyp89wcBB8i98g50WW
	vHOiRqfHFmjvDy7GSWAEoM0nDdmdpGg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24EF943412;
	Sun,  5 Jul 2026 18:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231231F000E9;
	Sun,  5 Jul 2026 18:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783277447;
	bh=r8lzWoonUAmF9jSZ3sxb3NCfU6HKSy4ivLDREqGKh2U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=rtHQAfw/0VYKyWgm77bwW/E8pKkfWsbGSuysL2f+xSBVo5vB1tFlRD3IeFzKqfiJu
	 TxD0jxswIt/S4o37e8IIGVMVlr0C/UbcEoCdiIFvx02c9qYK7f6Mu2tDCS8cFM46/+
	 oYmEzrTVjyl1jjz5YNO2M1VONKpAk+Rs+YHWQp+E=
Date: Sun, 5 Jul 2026 11:50:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org,
 osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org,
 osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
 nao.horiguchi@gmail.com, david@kernel.org, william.roche@oracle.com,
 tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com,
 muchun.song@linux.dev, liam@infradead.org, rientjes@google.com,
 duenwen@google.com, jthoughton@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
 shuah@kernel.org, surenb@google.com, mhocko@suse.com,
 boudewijn@delta-utec.com
Subject: Re: [PATCH v6 0/5] Only free healthy pages in high-order
 has_hwpoisoned folio
Message-Id: <20260705115045.eba41efda0c46121b1d10827@linux-foundation.org>
In-Reply-To: <20260705180714.3708947-1-jiaqiyan@google.com>
References: <20260705180714.3708947-1-jiaqiyan@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79612120005
X-Stat-Signature: so9pcdcpyz1zeopxyd9qga4ka37aaqxp
X-HE-Tag: 1783277448-24345
X-HE-Meta: U2FsdGVkX18LHGWN0o/L695VNPMcK5u+jyWEtp+6nw8kanXMLcRtZONZGK4MmpJKF+RK688cH1AlkbWgQ+eVa+ZGV9JXXBYWrdIVTbYlEot5C5KwMlGgKgl69pfwnvfx6dFW/jadHHIIGIuerfwIok6o4AluUK8TE5/2YkxZO/SiRCH05DZkPsErZ95dOF6YgHWvTIzszIAWpSetjLWkvEfkLLumRvyH7kblro5E4NXwuX1yCgIveU2D17/t2oDbwJLK0Zw5pCpxaD8Psl8w/hZ53ZNg5DMx5qqvi3TaMPhnutOIUoY+FUgb/O8p+geR7HLdMerQy6CTE0hcGnzX2K0hMaChEMfQ/jOy0hrScz0Rgxu1HUVU/cMuuXCz/9UBkXm9kA2LQAnvyVcjGvLf7zZjHsEG+eCj8Qk215lDZg3NfI5fV6Oa61VeMFANqBY6d1DKENqelRYiNERnFVdSJKj++trMYxVBnBqUNMm+J2nJ3HyVpqxXPDbark1vbOTuthyMSO2iArU2O4sKsGwsmTMFJsc80IDX878ns1GTAWGDENWzuwJHpkxkwE4vEjXAtovur47aFUTAile/T3nH/ao5JjzICJja+xY+4UbXxYfwS7v71+EQ2JefqB1PXhcnpx353Gk/7tge9pbxLgI+UF24iTCzkfHCRx+/HOPN+BTBnr4qqjy8I9ThJOViAxuUb67jMGMGCqjqPql3yW6mzPTvXMy7Pa5h1uF0N/1yprudo7Sz1KIhzlQ6xcd1S/Gva6qL1WJxl6tz2g3Efbu25KDMTanlNjtB/ea6I4MadQuG2tq1mY4Zdqfpsse51xzgrZnuKdykkLDirMjmqYXqO36AavY9ZQBhCqa1ACGJgubAkyt6BXX7xqVaTAYulpYvdtX397Q0KiBB/J6Vuwouf9+yLMT0GvFzUtWP40muHeZ7DoV14odC1MJZqqrgdgPisXOFu21eycp3xMJ5L3C
 VhCBH0vM
 W2/dV5Iftz8UbJbSyoaz0VwO97GFk8A6aPdVzhLmRo8O7165mQH05LJrjd1+5/kpwd5m4JWjtly0M322Z/4sRfly8Iyd7Rlso+OfN23Z2KwvHGuXh4v7gj3zsMKqY1usQaFMgLs32cQ/H6jYJKfQrtY2KtSKzXazcCbuCywClVwumTD7ZagIhO3fMgyRn3qVmfE8d+cvZm0o1ww/8dTexpjUUWA4XtyOEIhclngsJokISiAUiRvS8V1cx5np7KAPKSHqZN/f6qNypzwkEdtRp5+iRkZcZLnci/xUG6L1eX473UbwGtXww3nv7fHZvRM7s0LRevkPayckrsR+4HPThmBM3ledDjTaKdfZwYNI1DDMmyZaqy0wnNUUiIVjpqI46SfrcM5lUXnQt8Q/UG2pOAHYaKkkpbvgtodSAyV9xCzM9XWkmdMPuzcNiwcsBRbaSfMiR7YdJlJWhvGo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  5 Jul 2026 18:07:09 +0000 Jiaqi Yan <jiaqiyan@google.com> wrote:

> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB
> folio becomes non-HugeTLB and is released to buddy allocator
> as a high-order folio, e.g. a folio that contains 262144 pages
> if the folio was a 1G HugeTLB hugepage.
> 
> ...
> 
> Introduce free_has_hwpoisoned() to only free the healthy pages
> and exclude the HWPoison ones in the high-order folio.
> free_has_hwpoisoned() happens at the end of free_pages_prepare(),
> which already deals with both decomposing the original compound
> page, updating page metadata like alloc tag and page owner.
> It is also only applied when PG_has_hwpoisoned indicates folio
> contains certain HWPoison page(s) for performance reason.
> Its idea is to iterate through the sub-pages of the folio to
> identify contiguous ranges of healthy pages. Instead of freeing
> pages one by one, free_has_hwpoisoned() then re-use
> free_prepared_contig_range() [11] to decompose healthy ranges into
> the largest possible chunks of different orders. Every chunk is
> freed via __free_frozen_pages().

Thanks.  I'll await further reviewer input before taking any action
with this series.

AI review flags several possible issues, some of them pre-existing:

	https://sashiko.dev/#/patchset/20260705180714.3708947-1-jiaqiyan@google.com



