Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3E5CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 18:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936C86B00AF; Mon, 18 Aug 2025 14:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E6F06B00B2; Mon, 18 Aug 2025 14:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5AA6B00B5; Mon, 18 Aug 2025 14:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66B3C6B00AF
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:18:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3366D1408C1
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:18:06 +0000 (UTC)
X-FDA: 83790687372.28.0CF2477
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 88472140009
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:18:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DGThcSp5;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755541084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9wGRp6+9zdsbZ3sDKC/whjsg3YC/gseE+3JhibvcD4=;
	b=YUgKJ7OQoS5XSeEI7gl1Ts2b05pNsdNwEIzvdqmNQ/AJnQC+26OGGicQaBRRqnt9pZCc3S
	vWSRUuh1AsdlMI/COGlYMS9yocRakLR20Ce8mZJnXyp4Q2t75jLCbuR74MaJyC6rAuLnVb
	l3FIJfXtYF1sq/miaTwuMV2MA0aV0hw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755541084; a=rsa-sha256;
	cv=none;
	b=jlhIsbzENCh/zXEnjW5RIoJdCNds77cgaCoNGTnQUIFhcnwsM0NXhXxI5mCXI4QJX6Wf/2
	jO99sagbFPzA5StTr136LBh6QZKc468Z7Nb359SbtxCRWqxMY8IeOPBmNQ1BPl9xsa5DGK
	7gPI8hSVtrlm8Zzta8R/6s+i9h9e1Ik=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DGThcSp5;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AABEF600AE;
	Mon, 18 Aug 2025 18:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A39C4CEEB;
	Mon, 18 Aug 2025 18:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755541083;
	bh=Si2VsEJ435Hpz9aDrpmWKX7tHYNWWnfoh3OSHQI95Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGThcSp5EmIH6OIMOMjHy5Sg+5LMsSPOLcKKceL23Y/OVokFATTs5cJKf92RMvu56
	 a0XGF/1YRoXq1FvcxPtc8A3Clr0Jl5z3JB7ycOMvDrbGHrIwYOGQUY7Z6+1swhcmts
	 hvkEvN1S8FFkFL4snSuIvPvSpCXWK6gS9JAnynaoX1kUJl/oi5ahZyxJwGo4Q6jkK+
	 QSWM+SP/HvkICyA8onfG7otTJ4eFby37lUIXgidh0CJdz3txJkOIJGU5kVnmhdZtAs
	 S4D6rFZD1J8LVmAxP1JtOy9mNM5amOc5owoUj2SBY5Fh4YFxdivYrFbwh9LcET+j6p
	 4x5kbQXeTStXw==
From: SeongJae Park <sj@kernel.org>
To: Chris Li <chrisl@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Mon, 18 Aug 2025 11:18:00 -0700
Message-Id: <20250818181800.59827-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAF8kJuPwfRVHpvNRr=1NT4z_3Pmr-1u4vfRYmkvh_Kh4uNGy9w@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 88472140009
X-Stat-Signature: e7g17puq6uhdrojsr54tbcshsif8qsju
X-HE-Tag: 1755541084-942759
X-HE-Meta: U2FsdGVkX19Cj7JA9U2W4bP4h8aYp7oTgTsBpDYnWC9Ni89tu12EFmcjITPYDGfjbNp5YD+L5N68AMGdc2ZDTgKkWl8dq73RXgfGtxTo7F/qUje7lr6xhm86H7hBB6ZYLP1bgHmqZHidx9d5bCEERcjx/fRyk3nja0RUFrCcUblnp9i4lTmmjB7y+OybBMyONxMQfrKbOixCkq1T1rX3YnSuFFR2dwuh3Y17UoLZkJRUundI7rNJ9rxzgABo8d98QRBWhnMmsmk0FtcF77Z3GYhUS827PItNKJgZqmolyYHEf7/vpI76Dg2fdEDpowPeSa5Sp8eWCh+Dfa6B8mMc+5FeUVT3j0jm5t3Wkg7Jd//2prcnCiKjxenHdWpr9KvVlx2abNuo679IW73JkmI4kb82u/UpCWYoEv6awoIDxvnAjPNqZ6sFh/KjXx1VU40Ptbj6FmW5mhIXPVxKnszRufboUFGCeGpCmCZK8mkymxMWqnXBzyaR9RGmFM8UE7O1JKqeux+VfOEWRxutBVdIGZTltZNuzBRRkhd0Du/jfVoPC+4fwjMkDUOAc2Anl8fXR/+yaJUYx1P834M4KJ/3oVoIbZpkkS/iFiRE6Nv8TotZzTK2R8J537h3M2CFxSafF4bnYQ1pNYAqNoZoMJC3dtX9++NVcR9F9Q1U/rtT9WALt26Nz/L/veXnkdAZliqqIGqnQHP8wJ0PWcsHZnj5be+QUDDlQ8dDqilSNaa4o5zVcLhfDie1ZEEGOh/5lXWgfjq3WN+TbGRziN+i7u+O4vRGjhiNqXaX2f1lRDth7lE84sQobhy3YR0lRH//TPTvDgnDGqnu5+bPqVi4HDi0QfiBg912FMHuCbu5YablQtiPapm1miXGAhOmYfNTsR0RqPm+umXbDN4Wmvc7IsQjoIA++fHPEfw0JDIu7LrYRihOoViT80iNOvSD/bzU9Yt2jONYMrRzBIUCLlnEEG5
 oxE/tLtc
 3xG4OwPidzi1AGaRVmBO9Xk/5Kr7jGdIgy7aL444fsPMzueFOWl0PcMdIOASUcwlqMhVqSiPAgLLYEcXEEwgBVv34wb4PVesj6tboqp9kaJElXvnPWM9sg4jcSQrYddBGzFwmnYr6QSL6yz48/0oFAUenpCSFAUkKuTtiS0BnDlDqquIwuMXY1VdhEp3lXElJkAEh+LE/lYQrVwZcozSYtRGC85r5NBR1X4BmkwopIxabY82mCgHTrHcJKNbmm4K4qSbWDEh07n7rSlzmxy7+i7XzORbVyWo4tbxs1E39R0SsYa1jK9mR+1IchjeseGuke73nbA6mS+DwCVgX43ZQyFYxPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025 19:23:10 -0700 Chris Li <chrisl@kernel.org> wrote:

> On Fri, Aug 15, 2025 at 5:14 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > Sounds good.  So in the next version (v4), I will drop compress_fail.  Instead,
> > I will add two new counters, namely compress_engine_fail and the new atomic
> > counter, say, stored_uncompressed_pages.  Please suggest better names or
> > correct me if I'm missing some of your points.
> 
> Sounds great. As I suggest in my other email, if up to me,
> 
> "crypto_compress_fail" and "stored_incompressible_pages"

Nice names, thank you!  I'll send the next verison soon, following all your
suggestions[1] together.

[1] https://lore.kernel.org/CAF8kJuPCpnGAoz=1CBwe46ytpcR0ZUMAEWLFQce7eUWkb+0ERA@mail.gmail.com


Thanks,
SJ

[...]

