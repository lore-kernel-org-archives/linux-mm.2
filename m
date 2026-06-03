Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07BF5CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 05:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B556B0088; Wed,  3 Jun 2026 01:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69026B008A; Wed,  3 Jun 2026 01:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79256B008C; Wed,  3 Jun 2026 01:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B74AC6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 01:35:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14094161800
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:35:51 +0000 (UTC)
X-FDA: 84837489702.07.904AD30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7E91D1A0009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:35:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=afKyfzPw;
	spf=pass (imf19.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780464949;
	b=n3hD9KZ3kWkqb0HuYehMrgjt2//NsSbqc2rvALLpNLsQIIKjf/gHQIsZJ7S+zwcroU7E4W
	vZAbIGMo/mNK+eYLtbYoDSIg2vbcaiZHEPMNUGUVZ0LmoUs5dVE4xZnCABAQqq3/R46Q1Y
	mSJt7Qj2Kx+d1mnZkC5mgo6POmUAE3w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=afKyfzPw;
	spf=pass (imf19.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780464949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sk+fixDbabhLM2/BdXdj31qYla4LMHhKSpCBuaGwgRU=;
	b=xw+gvqBXzya4akJLa0sYr8BTYHVwWVWVzrSBOcb3ycRSR2djOtzEyCjTwkrrB8tjAzKn4o
	njZYBbZ08Q/I0TK1/eTRNQ9S6ht3BgQVtieD1tMIyzlJ1e9SgD4XCpQOXwFgktbHR4N+/w
	NNirFxMgZAJomAQwnza/GJ2xvEnI6Rw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E86F260216;
	Wed,  3 Jun 2026 05:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2491F00893;
	Wed,  3 Jun 2026 05:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780464948;
	bh=sk+fixDbabhLM2/BdXdj31qYla4LMHhKSpCBuaGwgRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=afKyfzPwMZnX8RIkQ62Ya83mT2tiXh6A2Y4ngnA3DTORF80aPWcCsA9Ow9tWFaL8P
	 Q3SeijIk5i44X5Pb5k1chgqbdmQBVYOP3/HhrbGvZIK87zpNHToS09FwTEQEOm0L4d
	 nEs0ObzT+Pwcm7Rms4afNdAt62/YdphsvEugwPWGcRZ7hd9WuzURbZ446f88NHkACq
	 KE0n9i1u+Hem+mJsgbcGvS0vJ1Q2wdwpgNUHCP4ztTBnHsukGxjgKCYYzx9RI7Dn/a
	 n4HtV2VhwPI7pkIPFGuV+xJkLZblh3NOxl5FA5LRYtRH68rxb65adzMMRE1aiklf0P
	 dwN5Hw0jqlhDg==
Date: Wed, 3 Jun 2026 07:35:42 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Liu Shixin <liushixin2@huawei.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, muchun.song@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v2] mm: page_isolation: avoid unsafe folio reads while
 scanning compound pages
Message-ID: <ah-9Lkp3JTsOZUo3@localhost.localdomain>
References: <20260602130755.38794-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602130755.38794-1-kaitao.cheng@linux.dev>
X-Rspamd-Queue-Id: 7E91D1A0009
X-Stat-Signature: yxy8rxs7wx7qpw8afs7k96jweo1uzumi
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780464949-810312
X-HE-Meta: U2FsdGVkX1+yiK2DOZsA20q7+V7Q7eri4fhShLBtrZNXP2dlP8qW9DptfaKHEmcKQaEri2x5PW11LfDgqHU3v6pESoGuaxFMO/Bl0GQ3Wi5b15kBVxHYMxQS+2hjt0Gksn0dNpbu+UuEkXAzWaof+OSzUnJ37gYWeqBVbLr6kij4YyxdPR9M054dxCLLNp5Vw8D1QTrhP9nVpuqWiV2aQ1052StlO284GfbjNHo9PEfhs+8XrPDgmXGjVo67DBVCcJ8+i/GoAnv+3CyuI92d6MUbxyRuFMpscrug5IHgryDeiSErfgCirt2oKQEtVX0JSJAs9AW1LfDZiLkI3Ecmy0Flu4DBQWBQ0o02nal2PMF6eWGK6RPm7oZvgNDmYaX0sOl9uuPEzdId2S0tajGvU6l0B/Ixg5v7EABDVgSh78mImfusWlwLyqczm5HdH2e3nRU+y5Uf5VQvjCV+49i9uC89ycUFaLjnIqz5538ucBDFZuaxwDZe/U8KAFKW2s5xbib7am4rFBlaASGIbhRh91X7W5x7fzC2CvPjrDH2KtLTi/OfV7t99Vh2z9XOZEM5NqYkPZD2BBT77ckk4zx1emGhlQq/CkGXer1sjggFH4pbVgPC1zJcEKa2oe0lj3SJozUTdnqD3CFGjOk8z/hxMJR/eiJanTNZS9hBQ8YxFVm3DyKRYbJ/86E8GZTV8N2OYuNWHp7CZW06gjIN+1stAkkWeIRikpUZ1UQ8kVfd0MMzKgT8d/L9aAuj3L7YyCjWFAzBf5dH6u2qjdPby6DZwjN9c50n1sq7RkccuW5H2PRo3cLpXDAeM+hmXglWplgw+lorrXngk6yrT62IBsNTAczxrgqMJHkuFVuYdcalR8JNpEz9ZYv/y5Dtbwv50swTZw9Tff2xgdAtoQz1dBDAyrVBvN4CKGxZV2AppV5lzIBs0KOMIbSM1Nq6KYFjS7OFpZowmlJN60op39fSCHF
 Eoz1rdAY
 6aVTY8TE1W9mHz2zU8knwZL5Y/KwI8p6XcWcyIoJ9fL1aYueWH0Jjo3VBl1Pnfw30eHDla4+oXigvgymn65pHKMx5OadSEXmJoItxGqW2IijRdw6eAV5hrycCQoD8F3LR7XhDreUBuOsr03M9viz6jqQhHUaM+SvzD8w85jj+tsVX3mymTd8salbApmbsw9SHDt3xcLpXu621ttIlt2JPml0pNqrSv0t+hIgDww9128HvOOuRM/C3hgxA+xDS8qGfow/P31ERVc8yjtHT7Le7xD65IYStG83bi+X9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 09:07:55PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> page_is_unmovable() can inspect compound pages without holding a folio
> reference or any lock. The folio can therefore be freed, split or reused
> while the scanner is still looking at it.
> 
> The existing HugeTLB handling already avoids folio_hstate() for this
> reason, but it still derives the hstate from folio_size() and later
> derives the scan step from folio_nr_pages() and folio_page_idx().
> These helpers rely on the folio still being a valid folio head. If
> the folio changed concurrently, the scanner can read inconsistent folio
> metadata and compute a wrong step. In the worst case, folio_nr_pages()
> can return 1 for what used to be a tail page and the subtraction from
> folio_page_idx() can underflow.
> 
> There is a similar issue for non-Hugetlb compound pages: folio_test_lru()
> expects a valid folio. If the previously observed head page has been
> reused as a tail page of another compound page, the folio flag checks
> can trigger VM_BUG_ON_PGFLAGS().
> 
> Read the compound order once with compound_order(), reject obviously
> bogus orders, and derive the hstate and scan step from that order
> instead of querying folio size information again. Also use PageLRU(page),
> which is safe for the page being scanned, instead of folio_test_lru()
> on a potentially stale folio pointer.
> 
> Treat an unknown HugeTLB hstate as unmovable so the scanner does not try
> to skip over an unstable HugeTLB folio.
> 
> Fixes: a0a9f2180b90 ("mm: page_isolation: avoid calling folio_hstate() without hugetlb_lock")
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

