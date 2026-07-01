Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB7EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E406B00A9; Wed,  1 Jul 2026 02:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 055B06B00AB; Wed,  1 Jul 2026 02:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5936B00AC; Wed,  1 Jul 2026 02:49:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C95876B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:49:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A5234025E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:49:56 +0000 (UTC)
X-FDA: 84939282792.04.375C1C4
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf17.hostedemail.com (Postfix) with ESMTP id D452740003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:49:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZROQTcya;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782888594;
	b=KwFmXNs0SLYyQTFgIjcs5M9Ei1OO+BZ5CAGjUlQy1O9w7v6E+Z6zc4Io9r6gz0ty3nTp2p
	6DtDKa3N3JJFpl7u+1ty68awXdkbM69Ot6/bNGX36RbGoh4TPJJTSba1eWDjkHJvBOE1pf
	a07qhVoooHlxcXMsAofkJ2AEOu5pEH4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782888594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zd2opAEZdyfY+D+0IbQCuD9WR9PIvtSdIduSxlL8mTg=;
	b=jdCbBWnBiWsH6/mo1C6PktmqX8pU2KBKbD+lhhekIrCpVpq2jjctB1+ChS2JVkJ0Zz6XWl
	8mOOjSNuT2aZDaL7ybeJqyf1FWgFOENjpyyIuuJNwNwU7iSomcADzLzBhTBHx158K/8Q2p
	sc5nrdZvgQ1VMLNj0r13GbFub5cZGQE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZROQTcya;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782888591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zd2opAEZdyfY+D+0IbQCuD9WR9PIvtSdIduSxlL8mTg=;
	b=ZROQTcyaCG+fELLScxaOCHawW/fBPCebAni5xoGNnpS/3Jr2CCPf5rOPz3W5ERDJhOTiby
	m9DSyqQMsiV1ye850laC9XEqpHhBhkI4UPuCIsIWVD5Wc9yz1oSDERI4vJ7uRtQHMNoCmy
	eyRXQFirBLuTuDf+NKLcJTd0DbiT460=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	rppt@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/compaction: stop recording free page order in page->private
Date: Wed,  1 Jul 2026 14:49:37 +0800
Message-Id: <20260701064937.5131-1-lance.yang@linux.dev>
In-Reply-To: <20260628-keep-subpage-private-zero-at-free-v1-1-f4ce3930d10f@nvidia.com>
References: <20260628-keep-subpage-private-zero-at-free-v1-1-f4ce3930d10f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D452740003
X-Rspam-User: 
X-Stat-Signature: nag9yd4o5hbgps75mpdtwqrfti1ba6yx
X-HE-Tag: 1782888593-300268
X-HE-Meta: U2FsdGVkX19FUxGz3FzjSWMOs48nqCY+CSK7kxxh7XEGMfiyN7/AwCq3EPH6wbpZX0itsqTT+fzCjbMcHjjTW9dgWDcYd6tqLNfXD+pOjLrctwYtzMo5fxEEQiaipUQp/dbbcHrTOjy1NRSmXjcK/MrkbM16W1xexPdnuyp+lQUjVVOqzNbbS0wLHu/iiwCOagOq4NZ6ebNL9xKxFs3DJ/Uy5fgztssKBI2ZXhZyE27inQvJLkieqyVTXzrIrjtSdGxGmSh9KWUGRJjHHcIoIFjP+bX2CHZlqbwXD5gCnqfFyLCzMXUkklVxrkWffVrM+U40RhYw3JiNWVOc8ufqtpMv32sqQzBRoNwHbcRcHoiDD9abtb/JHrGiOLyH04y2jBu+9q2S7oJE2f3gLYWSFY22cDzP0FsJ/PLZDc3zoiKlFa1hSf37BQJad9cFV7CU+n73pfLyxTPrq0O2N2pM3rcZRmjZrUSDzHCzvGI2drQeFkdOSBv4vz95lMmsxChHkfb/Qq5HT4gcSezugIyhPYOr9aEtlerovO/aSnSVW7ipuJp/7PygIIaKYMuazmOolsfJtI0WmbywqQAQTUlGm4ZwXev5u4rtQPqs/DyGjBbZj/IyAxuwZFFrPM7jJu5sBW+wFruZLS86JtlOwQjSFwVgTUQejOT5ru6nfw7mlR7pvTBa7uxQ7g7B6xk15fDEYCwF/w/4IFV5ijCB2TeLO6N9YVgQV/pkEfdEHaB1a5ob1L9em6DbhHeTgxjL2ksAg9dxeLpgBHV1EMM8VZl1tDKTd3/WMdP0fPTjHXPht4roFkuxar93wQ+zh+ZZe9GT2Lb7XYQ0CF/IHTsN8Uj0NYbrmiv7mSYf08u6Wau/4ULVysj8BsFzDTZC3ceJ8kHkr8xa0yiU9lQEBEPCYIVYOT2qyNV2yd2BZ3u7+OBY4ZVcief1dKdHZfcxtP4p/TluFHAh+DVmV6l6vKo8ObX
 dNbkh/gN
 xJfL6eMDmhMACSrW5kQ3jt4pXc0AlnSN09oN50kL3hyvKK9QU1IQ/r3AMrVxZmNWNUcyFM/nT6knNjp3aLPfKF1BFFFC/vGdTbZHAOLCO3WwbL0oXtm58z9R6Whg0uoIIdwz1CgfuM7AfKZaoTwDhNyud4VvN7BzbjykGR2iDJjYOZ86HtqhbrpN4f06IALrGP6E2ISXRc74i6YiL6GERvBIn5DpAcvFyQiDv09Fq6cPbnoo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun, Jun 28, 2026 at 10:56:19PM -0400, Zi Yan wrote:
>Commit 733aea0b3a7bb ("mm/compaction: add support for >0 order folio
>memory compaction.") stores isolated free pages in an array indexed by free
>page orders, it is no longer needed to store the order in each page's
>->private field. And there is no code using the stored order. Stop doing
>that.
>
>It also prepares for an upcoming change that ensures subpage->private is
>zero at page free time and the removal of set_page_private(0) from
>prep_compound_tail(). In alloc_contig_frozen_range_noprof(),
>isolate_freepages_range() is used to grab free pages from buddy allocator
>and it leaves the aforementioned page->private set until
>either split_free_frozen_pages() or prep_new_page() is called. That
>triggers the upcoming subpage->private nonzero check along once
>set_page_private(0) is removed from prep_compound_tail(), which is called
>via prep_new_page().
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---

IIUC, after isolation, the order is tracked by the per-order freelist :)
LGTM, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

