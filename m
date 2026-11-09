Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 757E0606A33E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 20:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=o+ZHiSlL
Received: by kanga.kvack.org (Postfix)
	id 900B76B00EF; Mon,  9 Nov 2026 15:30:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8786B05B0; Mon,  9 Nov 2026 15:30:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815356B05B1; Mon,  9 Nov 2026 15:30:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 667076B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 15:30:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFFE71607D1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:30:52 +0000 (UTC)
X-FDA: 85416724344.28.DFC430F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id B717620008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:30:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=o+ZHiSlL;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794256251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fiDCQCRdhXgmLQB5RoXvNckgRlJaUgMVt4yvwE8wp0=;
	b=32BwlrKy/oZoLhYRE57xJ8xx5Btl7FsDW2Hkjg8zt1Ds8Nl1YRA5i57fpsE8RBny/HtERP
	7MQQ9XDgcs/wpgdD8lVGRKtlsApMXLh1CwRKeRavW7FhbtEyfHX6oSGSFKYuemdGBAHPBM
	meRH3QkOdisQ71xvl/fW/DIvmMrDto4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=o+ZHiSlL;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794256251;
	b=UTRgd0mCSkueH/m3Cth4mymhICK1kd2w1qkVb4h9CwMJS63O/iRdPYShBE0lfyjK4qwZC2
	FRPvPEwbKznlfCLSvdt2WYB/TSIYYe2YsMWZAtQS3vjYDnRX+euLb6Wn8k0M4Q2JSPNlSt
	f/HVK+mwgNWNbUZ1V9lEeXdikGkQqFg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8fiDCQCRdhXgmLQB5RoXvNckgRlJaUgMVt4yvwE8wp0=; b=o+ZHiSlLjBJBn2ee3/lPBmRaSs
	VryBh9nDG8CuqdYgskBC0HfggwANkB3rxDS+VJs6NhztS84Tvg5pkagIvdKZZjuL9AN3gVZVL/yck
	wH5DnIFA8gxoTQdMEHgVLFJyphVxU/t3hRUF82o2h1zlB4AfNB8apqmUACY2FzocTTYdnCwfUAsGn
	TXfdtUC9XT6yHugH94idT1au2Wozd/Q7KscUnDZDAUvi3R4H4KzIrUB1eK6wetfnuQFbXwjl6GE91
	ANuBzWrTdFrQJu2WqNOp0H5HnRSlWZxNJfmWJ3XD7zRm2/sYafNoJwumff8oKyhMJ32MxtX0r8a1F
	sZOjsevA==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xQW0u-00000000jrk-0IQW;
	Mon, 09 Nov 2026 20:30:48 +0000
Date: Mon, 9 Nov 2026 20:30:47 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 1/2] mm/memory: recheck PG_uptodate after
 ->page_mkwrite()
Message-ID: <avItd6rDqP3GB6pL@casper.infradead.org>
References: <20261109120403.82361-1-kas@kernel.org>
 <20261109120403.82361-2-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109120403.82361-2-kas@kernel.org>
X-Stat-Signature: nfdwtfjjk34b7hm4wkmhor7px1mwxaqg
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B717620008
X-HE-Tag: 1794256250-61452
X-HE-Meta: U2FsdGVkX18xpED1RT5aqUBt7VjAF6nWJt8USUgJCSvnlf1AM9EZfxoeX7j1K3/5wUK0xAFgWmF4nAIA/MTAO4qJIKOu1FI2cT3pMlTtaGDDVm2lcfnDJEQUug90tlseRs/qN/+IoF+n5IkR6mN8DaIS6+PiHYeEZewtIsx02/8HUneDlhEjaT60SRH07wXzhNO29iJIWjvuB08CxVZMeDWFzqait8rMNdaTOkNm1z+kR3L2FqJsqlE4ATyFLngqiMMjniFjI0BFqLsmQe7McccgP4nsUXZziI+5+cXLQm8WS+kTFRIO6tWRbyX0o+LV+Xu3ylN461lRkWlNfx4Gn6qNK2gC1o8eJwSD3p9xJw1/IAB8Wgfith+XIsvUVdbFYXr8sEoyXggIwU9PBGtqVXSaobN8zCkcRuF1wBydRfqNSJkEZgc8bzna/AQZ/o1gFztWz/x1jka7Gb+T97xBOTykJ7/6ESx1heIwlGzwHyBYyf5Bs661HoxVn9jWSQtCCHkpu3zAULqvquaUmciWdTbz0OiX0+fgZvvDkjC7/EdQOKETij33vExL+JStcKVJg5X2Yhn/7Run8IT4RSIi8u0p8hcKKqUWMSdu0HwRVnVn0ojKDC0nPe5SsrAZo+z5xVqsCLPrP7SWizrMasrWZXk9qzu0ubh6PYzdTTx0AtpkEcgx2O1A33I98yJG/mBMLgBn7TU9yJJpwQEPQHJ5m8yvNmufbAIb9s6kjtO304YRQyVJgRUno8B7MEV5ZVU9N1Q8YzrA6foAU0KRpqJSsMV+2kylXxHoESjD6alCDzBUZ4IIJJsbMadNow77nCaYH3Ro+E6qn3ZhPDlOYHKsZZr7a0gIZS+iBfvhAiD3GkHNl+Rsz3SLpADD7tanjc+0RE9z4ZQ+/s6Lmf0+7gOknYzIDZ12nNNnE2Zba5kbGmrAAfbiaOUzqKM/+hqXo9eRquar3OlnUClUUiUF9WM
 anLIaV0b
 p+Us4JIm/ALn7yztFFM12kiWp6QX0W4SGhv3gjv98Y/0j04W0N32fdqVarf6MhxP6r0chjvcMyHNwHp7tmVhUkFsNMcJi0Kd2a5zC0pgpA7MmPh8s9oIRpcjDdS0G4+pVEc7VYN6GkHN7t7YsgVvtYszGAU2Mwcf/6mldtgJk4f2u9VlZEt2famtMgemfuLQvduRKeqvea34Xhk5F+TfQA2HwmXS3q88fs6/eTo5skfSP4sOb0qytbJAm1VtV0n6BdwF63Hj328z90zT7rNV6OpN+bZ6mpbNgII1B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 12:04:01PM +0000, Kiryl Shutsemau (Meta) wrote:
> do_shared_fault() unlocks the folio around ->page_mkwrite(). Writeback
> can lock it in that window, fail, and clear PG_uptodate with the folio
> left in the page cache. ecryptfs_writepages() does this when encryption
> fails. filemap_page_mkwrite() relocks the folio and checks only
> ->mapping, so the fault maps a folio that is not uptodate:

Filesystems that do this are buggy.  They shuld be fixed, not worked
around like this.

