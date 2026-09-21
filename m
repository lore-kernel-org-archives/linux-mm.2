Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6069FC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695886B00E9; Mon, 21 Sep 2026 05:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6743A6B00EA; Mon, 21 Sep 2026 05:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 583D76B00EA; Mon, 21 Sep 2026 05:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9326B00A6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:23:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68469805D4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:22:59 +0000 (UTC)
X-FDA: 85237230078.06.4E98B3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 933F9160004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:22:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxB7xjuI;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CFoO3HjULZRPlh9ZYjAdBilyoIciysfYkAgUiyK+u4=;
	b=swLIWCWyTKQJ2hvOCksxkb0KQAbeP2GlhbkUL37FOLouyolo7e5GoHAArWngbGxJfd5+LV
	cMJOXuJDVG6GK1fFDUitRBsDIY1W/poGp9bZquWYO+00EF5fyrmOGPpKng2ZW0khx33kO8
	sSgy4tbjWO0zqAReIXGQe2ELIFYpG0c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxB7xjuI;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982577;
	b=gz9ACytbkyTyZ7O8Ahv/hSXTzH2fHP7iOC2/jHO6Mq6bUUeR2bfwmHd0bG/4GJbKn9cZ3L
	8sLNzeddrwOS1o5Fh5/d81F3p8hU50r8SDt0MF/jB+79myXxmdk5xUdaiL3hLZTRqDLCzY
	D/QBwlxJzPsgCCcBbw87OXsukiqruYc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BF52403D1;
	Mon, 21 Sep 2026 09:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848C71F00893;
	Mon, 21 Sep 2026 09:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789982576;
	bh=8CFoO3HjULZRPlh9ZYjAdBilyoIciysfYkAgUiyK+u4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kxB7xjuIgu9XSbE0bcEvnATOvW8Dks3rj4/Qaq6fXsLri3gZ1lho6AQisuaA1axMZ
	 QDGJCV9LB2wRUOgqUO15KymsnUkll6IJ/E0fEpJyqMqE3PLeI+UTlLNHLiROzY6wUd
	 mDasoKq9mSazdecv4u/T96AyYAHKmpGiBGA049UFWi2AMd8fto2neGDUAaEw3/kUIv
	 QMxASG2IOCgua6Rf7ZlRW0IArUm0ezE5wA90wDjvbr5CXqsYEN8UypLvRlzCye4jFj
	 +fBhxBJIrLOzbcU8Wn6QRo62L0t1iBMNTNjwtKvJcaatopydxAapuvBt6fou6CHMUK
	 09UBbdd5GGIsg==
Message-ID: <6547c594-5669-4234-9ae4-ffac1ca74b69@kernel.org>
Date: Mon, 21 Sep 2026 11:22:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/17] mm/page-flags: check page/folio->private instead
 of PG_private
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Jan Kara <jack@suse.cz>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-fsdevel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-10-bb68b6a21869@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260920-remove-pg_private-v5-10-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 933F9160004
X-Stat-Signature: zdjoct1rxkbrfwzyfz7eeqzn9amwdzc8
X-Rspam-User: 
X-HE-Tag: 1789982577-27666
X-HE-Meta: U2FsdGVkX19MOIlb7xKF03L9JzVSVu3gKZMsS+zgfUO/hCnDwjlPTULGDotKb3g7aLA6NR/4+SRCbmAQleXPI4WUgL09K9OF0w2znQ0xyH1DmFcQRXTzXOLUmyjfNSDih3tPfcQ54X0ovsj4dyw9nWrdRVQ8rBw6MER5BfbNOt1DW5je5nSq9hkmpEckosLpJ/Byl83OAHHZUahQWeM+N1mzInfV5qR/QiO2m/Gim1rLEtbRicggefXfyEY4FNs/FuO9SlpieFqxjc1/xz57RIJKNFxDU6K+FnicgGoQpYPZS90DVsuLFjiiwNkgwFmdn3CHkz9A8+J8Pc91/Eym7EZMfccpVPQ9DCaadg6mcc+ZqN7/nR4dlEyPLf3Oz6RFLMHACveS1hDQ9UfFCpT3YChpqDRo39Gqo5n7TcgaFPVhvK/sy0ED58Pv5CIHrmpGHnkT/OEWl0PyAbmDlNGu8Qkywbv5S+8op7+qUH9zVgwcjrFf0vINjdmOyiCUVw64BIcDst3kJxWGqZSc1gzkkqLtW2i3zaXKQTf/G7O1+2w0aoRFc/NQkhRGJx+C+6EF8+uns14A3hreFKoN8S19YS6JFXYqgEWS7St/4zbDpLDkgtKxJbYwTYJkcGsT+Xu8E92pL6pSNGzCOzpQbHP0J3Bk8GnrUzNLNyp6EnSWO/JwEWmfRvCV+D3n7lWJBzJjRgii3ohv9neOspQ8gYz/UqJlii8oic2VI+TAdQn7bAaphkDXuc+SgqRLFvEQFc7AjPdG3j1gACC7CM7+hWP3ukM27OhySNbBbPo5htqJ0WMsySHPvzHeLcGp+6DdXso8DTbtREb32yOwQ5rGcdkB5v7JBbwwXYPyUL7gWqWZEZVJMuFf2z2JIJyFH5HoRBlL7rKPxc+PeL7yaiUj3+vRb0ocYQaTWd8WaJacmRTPIAwhfZzIAGwVzt9s/d68OumqdPlcj9yLMSdgNVzupxb
 bgyVeJPk
 QytS+p03v49hI5moQq1tYcOxApqE8lPFpzmkR+oBw/4W9Oyh1xUeI0Wuc6WMhFKkcmF3nO/8WaTnx6K0tSfi844FWGPjgMNH8TUuzH14Jb9UG2TUD8VdfG3UVXM899CIrj5c3Gy67BYEfDbE4KCAgFr7tFLPOThsXe8GRADc1nXEpgYQZPPOjIDNr7ff3XUyGpzemIodSIOmQt0yIGg2CDJF8L4P1XeA6bDn/O1sHC9D1ZxI+nRnACAibaAjOW2uuOjFRXDoRw+wt7V9pIDOodJn+Z+kdrne6XelQ823ymUfmzTlohgjsipbuDfx9LqCYoCZ1tT86KzXzwDrq2xTqpT9I7GqgCg3lUtsicoMW39+WwOSTYV33b3dea+d7mzmDsfNBHUxG6SDhFzRJ5K8CP7sP1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 04:28, Zi Yan wrote:
> After the changes of the prior commits, page/folio->private != NULL is now
> equivalent to checking PG_private.
> 
> Stop checking PG_private on pages and folios and use page/folio->private
> instead, except swapcache and hugetlb folios, because the former uses a
> field (swp_entry_t swap) overlapping with ->private and the latter sets its
> flags in ->private. Exclude swapcache and hugetlb when the code is meant to
> check PG_private only. PG_swapcache and folio->swap.val cannot be set/clear
> as a whole, so excluding swapcache with folio_test_swapcache() is not
> reliable. Instead, use folio_test_swapbacked(), since PG_swapbacked is
> stable when a folio is added to/removed from swapcache. Add a helper,
> folio_has_attached_private(), for this check.
> 
> folio_test_private() and PagePrivate() now read folio/page->private plainly
> instead of an atomic read of PG_private bit, so KCSAN complains about
> possible data races. Annotate them with data_race().
> 
> folio_expected_ref_count() can be called without the folio lock, so
> annotate folio->mapping with data_race() while at it.
> 
> folio_set/clear_private() and Set/ClearPagePrivate() become no-ops.
> PG_private is no longer checked at page free time. They will be removed in
> an upcoming commit.
> 
> Remove KPF_PRIVATE since PG_private is no longer used.
> 

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

