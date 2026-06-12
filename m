Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74CACCD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 05:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18C76B00A7; Fri, 12 Jun 2026 01:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA39A6B00A8; Fri, 12 Jun 2026 01:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44056B00A9; Fri, 12 Jun 2026 01:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC4E6B00A7
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:17:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DEC3C165A58
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:16:59 +0000 (UTC)
X-FDA: 84870101358.27.38AAFF3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id CD74540002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:16:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Lvf1anZ+;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781241418;
	b=ujpoyXWs9/14DpJWFOgt76sgFi1PlpzpRp/VwHkhO/wGaUjlRBpY8R0oTtYdVD6iZTXxSK
	Pb6zMiEJPFKMvp4qFd0HGxv5gP9gXjktNo7HsVq7xvhbYCSwwLl1X3n0vBByTlqXPKlcpn
	6rrYCTl9joQfycO+v9j08vCDVcN9X1E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Lvf1anZ+;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781241418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8raZXv/J5rTvp9TGhy9Jw0/HHc7BoN0/jPQQy86iNe0=;
	b=kbSP6t6/bcJHSHDnrVYCRUs+J/5WU6ih8aAvSX4qvMZggrpdkm266xxNR4s3FNBfuIKlr8
	ZrNTHeIeednI5IFg7Ui7M8YNTlSi9+Rso4IdJXYlqhiDH3CD9SgGRTM6nIicPrq7fpxxfs
	iy4CK1kl5TwvUYmpC76E3yzNCFi3Tok=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8raZXv/J5rTvp9TGhy9Jw0/HHc7BoN0/jPQQy86iNe0=; b=Lvf1anZ+ooIiKk0AdaKZIOQ/0J
	aKIpJ9ep3MYz1mpNHisbDgpSlRFeaiRjwXdeEtSGgr2ZcRwOJXt7US29j6LWrZUyR5HR+w2aiTb9r
	dABYdHqeOe0D188WNV1MnwrhfPlxWn5ri0IRjQhcJu4LYidXFiZotCsWLDqg0aO9EcPLikEPO/9u9
	SZ7/UTEVuAJPTjV7j1JFYe27a3bGpTiBXJoFqifJjbc+pPbHuLzwLUOf1AOEXNT20ZpBc2dF9Aw9U
	onqkgnEiEBRJocsyhJ9sbMcHKvhZHklDKvMZoaRZxJwBxeeIZgHcA3RJX4q/DA2a2pvUbs2gr2UD+
	iAdNcqjw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXuG4-00000003Atb-1fgn;
	Fri, 12 Jun 2026 05:16:44 +0000
Date: Fri, 12 Jun 2026 06:16:44 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com,
	xiuhong.wang@unisoc.com
Subject: Re: [PATCHv2] mm/huge_memory: do not add dropped split tail folios
 to LRU
Message-ID: <aiuWPKy0ncsMIXgW@casper.infradead.org>
References: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD74540002
X-Rspam-User: 
X-Stat-Signature: 8p5p1jg8r1mqggysjzzw3m8311hsu815
X-HE-Tag: 1781241417-454517
X-HE-Meta: U2FsdGVkX1+UQX3hNpSepKQ6r3RZ5JShtocLH1T3+8XZXDTPqpf5ebZ9yh2AyFQRxeO9bIfI1yTEL1xGK7M8OOa8EyMAmpp7z2qp+y0Yvkc+MkYfSd4TFbqeiLSlQLR8CP5Amj53zt2RjNB7cWNP+5Ze9sJ2kgasF+yTJ03PzmIUK982lbHEAczj6Afibng7CiGjUR4AMS+w8la1n1atRLBBNlXYWVa+Bi+VgNhuvPlu08fooKZAn4I0EC5NKzZmNWjCNSVbONp2JmI3MoUT0BxyPTxD776KsnA1sZWipNp4J+7+SDUeFEtrAKUHhLXit+ennjl88ghbixg0sRQL4pCX3NMrUPVlgrMhjFySvA64s8A7a3HiR4PNL2/ztCF9NqYDud6gEHtDnrxIdeetxKNFo+DWPz641YoSgMMjg0A5QXeQ29dg0eO6cXtVFVptRKu7p0/cWONGAia/9SCuE3a66Yp9VH1PhxlsMAv43o3L7iO160dvfCOm/S4lCWNgip5RVGeR8732yZSMB6SAdwPkkd0ogaNr27tc+IWz4rKD4OySeH1bFdjtyfD4czKUyoPF+MW0RZuYCdUwMLSvb3Q0q1ToKBKbV0AzkT44kOUzvCJ7fzjje/ZeF8vSL5vephdZCAgpTs0CcoSOPDraLTTn5k6ZdfOAImkRvf2kuNBnTYnJOcxzrL0HK4pnwrsVrgnxLNQc2oJCAMGiuBlShA0NPE+P9/IcFhAUtkBLrVMiDAM9kqcYi91NFlpPYaQt1DzUuGoSWWRHBu5OWvRkST5JB/EwWdwfq+y1C9MeZ0gNn0M7m/A0UW/+4e0RzYbklxjMsHkhR+tzueVW+KFvUL5bgeIOstLNpi1sJMwVk2flmU8gfMvQgSxdsAlJwnCzIi+qJPcJ43eRWoCfjSEnG+zBe8dG7gA7rLzxgMNlPdLkJE6b0YX+8GRvUIdRL78FW6Wi1W07ZyIfruJ7ASD
 bt3n4RNp
 NjY5AirBXqzOw+FMEFukySL8rSVLZKHn7kU+YhUdwjZk0braU/vJ/KBa2cOVVWAf4/mQRZi7OTqs/qA3uBlg0ozYv4lycOpGGt12JlDlzr9o75UyO4e3OapGEY9bv/B/EfIkP8OwIRVAOVhyCkqIGWa8QchJ2qXQU0hifmmjJgATlMETP57OTYZ08B1YhTEJwUAMtbpfGCNEl9Xcm/C0kgJG1NW60z2OIuols/GHyqFXnj4GAD+OYFdJYnWXXg0ht25zeQwppGieMaWbNVaN0SEfEVCcz8UgLgQfdjq07amhipup/kiumJJ4Q4yP2wdRVYGD7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 10:34:56AM +0800, zhaoyang.huang wrote:
> [2]
> *F: big folio before split
> *T: tail folio after split
> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 (folio_isolate_lru)
> *F: pagecache refs = n
> *F: extra refs = split
> *F: PG_lru set, mapping != NULL
>                             split_folio_to_order(F)
>                               folio_ref_freeze(F, 1)

I'll stop you right there.  folio_ref_freeze() is called with
folio_cache_ref_count(folio) + 1.  That's defined as:

static unsigned int folio_cache_ref_count(const struct folio *folio)
{
        if (folio_test_anon(folio) && !folio_test_swapcache(folio))
                return 0;
        return folio_nr_pages(folio);
}

so you'd have to freeze it with 2^order + 1.  The 2^order is the number of
references the page cache takes on it and the 1 is the reference held by
the caller of split_folio_to_order().  If anybody else has a reference
to it at this point, the call to freeze will fail.


