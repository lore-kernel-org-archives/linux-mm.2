Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B7EFD45F2
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 20:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF1F6B0088; Wed, 25 Feb 2026 15:48:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6CD16B0089; Wed, 25 Feb 2026 15:48:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99B26B008A; Wed, 25 Feb 2026 15:48:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6AB66B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:48:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 510D813B83D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:48:06 +0000 (UTC)
X-FDA: 84484166172.03.EAEB522
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9B1D8140008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:48:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ot0Ickdq;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772052484; a=rsa-sha256;
	cv=none;
	b=CvsaxNcNGUoHs/WboZ3NDQQABbBQlUlT9Few5c1h0RaNIjh3mBjQBGUKj2cZzTSZtle8PP
	IQFjy/1xg325R452IBKor1qjZ4BNnpp6s4PHpU2zJWIOCjXPCkOIkWzl40xoWwqTvmh0tO
	cLJTtNWE9IT2Q5M0/IfIqnSMMsbMZ3U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ot0Ickdq;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772052484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aM6FDbg6Q9fW+D7QpYpZccIUNQZL6CJ90Cl2TVv1hiA=;
	b=PIEkyN3H5Z3eAfkK8+9kA8TA/Yg3wREx4h0svEF0i1WcPif3SBU11OEgnA+b9y6PIG40oL
	DnNB20Ooyc1mflzFX20fgxksoOvJFzxvQ0hirUjtic0KqVo3R0a/jyM0NtYHZa+qRmLW2S
	bd+dHIfIposEvOvcRfoQLiBbrFocGo4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aM6FDbg6Q9fW+D7QpYpZccIUNQZL6CJ90Cl2TVv1hiA=; b=ot0Ickdq0H2zv7aRjB/u/PphPW
	kaPoVp5JcdZD3mdGJhHgoQ5DbBgWdYqOc3zzVxpv4FuUQyk8yHVOy5RN5jkefUpKv/bdGODnpX3Xg
	JFKKeORG2jv0jzxg1H2FUo3cSeAxXza7mJLGa5TflOUMm79jb2fC5nAHK1jhXdahQ3V/ALWNMTr7I
	7Y1IlKzDEHnGBuMTZWRvbRFEAFJucmCEnKxZdPFK/tUYl+EHmhIbzKVtlKDy8MpAIa9jR06sYaWtv
	uKNYM8bzdFeCL64H4V0QvofQ3isHhc/5DY41LfYSwP53UYkrGovQFwyouDu6YWHOuZsuQceHFgTe9
	ZuuAULaQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvLnD-00000001dMS-29rp;
	Wed, 25 Feb 2026 20:47:35 +0000
Date: Wed, 25 Feb 2026 20:47:35 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, linux-afs@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Remove stray references to struct pagevec
Message-ID: <aZ9f5_pgnr_62gCL@casper.infradead.org>
References: <20260225-pagevec_cleanup-v1-1-38e2246363d2@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225-pagevec_cleanup-v1-1-38e2246363d2@columbia.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9B1D8140008
X-Stat-Signature: hhh6zbqa3x6owtusryyeiyhb864zxewi
X-HE-Tag: 1772052483-137111
X-HE-Meta: U2FsdGVkX1/hec172bwihXtWF7G8CbPR0sU2csZWv+0cZ2gLIM0cucnTgeUuSH1d8U+e/V5+jnqIQTHQrfULxFu9E1E6jT6uuaz/y3dWFZhooFCd/uf5vtrY2o04f/GrfvS29cZL8Of3rJeNRBm9eGETLUGla6ugdRFjmh13JtLxiBTiDis59oeO2XII2g+Mk3+lqKRbjO0xPjUsCYR47SgDyNWE3q1xAAIsqnUseGMUrPL9CGMMr364HA84ElDnr2GAz14nF0HtINHJUdGZdMK0K/wkWz7tC4s0hyg1QOFZwg4f3Bfja91EQMfWj/f+XUg3eoiNJLvXe8R8P5GBx/B43uJ6IskvBd1L2BvzvTX98G986nhFc2yASyzgv/DJKPMNX75il59GkvBjrBf22GScifRNJZsLAPpE20wd1QA49tPYL1b30rv3aRgUxv/9ojREjqeq6/dGOYD5I+9V9d29Oruqv7JQSpg7sbfYMBxNmj6VzvkGLTlO8oi0LSYH3rnvmGWF63x8t/72U3d0kTBHj3qhhx/3ENEi/7Jn/wp24xAgh0ijV+J6J4Oo5dciiSpPNHpY/V/1s+FdPhFpUTNL1QChZVNNzQU2Q+GQFzHVR8bb39RE4Dq2YqY0A/4jhkuh73D+bVFC62KL+mqK6SoXTiXptImSwuCVZG+fJphm+Zwg5/8iDuKmWxpLupi1vPlJNCgelFit4PtYJltNIQDTLgIreSAN7Ud4RzpNImOGJsmjtiryOrdu4UmpW9AgoshBnl3wmZIkBl1S+y2KHhA98naeZ61eLSvtNKJx5OQVvCV/PtQZWHRwdpR0PuihM4jSitmb7S6qkrdL2vu28PysKTS6483N0ESjktvxHUHqsH0nm/0Nyjp7cragj224vDtbUq3rfHdZKjYAjFDPzFAPG57XjH1wwxd2ZQr0iie+2snJ21+S/Ek2ahMl6LdPs1lK+MevVG+0aSxAvsN
 Sq6WVAEo
 VK1ZdeJjcNbpPwmdEEyLMT0YU4N+WTtbs1BWiDjv6zZak3bBpW5+tM0Rc9m4/W2j7/Ku+M6Bjvb+ttXGeQ2A+XJLcOySCE9+JyBkVO144PIvhGEVKJOiEt6I/dE2TXa/EmaoEUr0w/JQfCusxoLk2OwG0shxMkIcVM1FOuaXZoTSY23ZTpFAU8vyJaJuHjpK1kglXkOQrpMe2FLwD69RjmIbXh19xxNoz5RKFkzP8rvckw4PGww/jeQ6sVELsoVOg6pPHpwwkv9h2GN2ya2QiZLeskBcvZyDj42zn0RaifK+BRwA25WvhBtPrOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 12:57:16PM -0500, Tal Zussman wrote:
> struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
> pagevec"). Remove remaining forward declarations and change
> __folio_batch_release()'s declaration to match its definition.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> ---
> Happy to rename PAGEVEC_SIZE and pagevec.h if desired too, but that'd be
> ~65 more lines of churn... Although it looks like there are plenty of .c
> files that include it for no reason, so could be a good opportunity to
> remove those.

Yes, there's lots of cleanup work here that I didn't get around to!
Thanks for taking on this much, and any more work you want to do in this
area will be lovely.

