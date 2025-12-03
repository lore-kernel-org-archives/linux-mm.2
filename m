Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F6EAD1BDD0
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 19:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92CB36B0024; Wed,  3 Dec 2025 14:04:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD2C6B0028; Wed,  3 Dec 2025 14:04:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81A776B0029; Wed,  3 Dec 2025 14:04:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74D716B0024
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 14:04:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BE2F8AACE
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 19:04:53 +0000 (UTC)
X-FDA: 84179086866.15.4E94E6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6CA5FC0011
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 19:04:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eZAsd+ui;
	spf=pass (imf22.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764788691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkF7XjYEuAYSUNSGU1CpHQtXjuz9vNG1pHPsljnvij8=;
	b=jfV0GZVR2/qu40kPE6SyYfGH0G969JYNqZqz4tBYI9Z6N3G6OPTkOlbrAIBk32qfgL6FPC
	xb2gWhgnhIwDR+KOJD29RLOw9VR7/wtdLCeOZNYKcqch1BQibNMHO4yLoujDdFqt+5/2NY
	9EOiXFLqF4YSZ5F3sCO0sa9+50kmecg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764788691; a=rsa-sha256;
	cv=none;
	b=NbF/tUL8rcMO+9ISzYsYV7lwhbbjaJ6wc4Aow38RXfBpqifg2p/eJTHcG6MVRQFHuTW05Y
	pwhz6NRUvUyef2a533Dm6+NAXDymHqaGQu48r5Vi3wJ/V2tjbSnbHhPP16HKso9dvAjPKu
	AK+7rZaVyklHanDT0jTt2SQKlE4D4qw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eZAsd+ui;
	spf=pass (imf22.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 47568442E4;
	Wed,  3 Dec 2025 19:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1386C113D0;
	Wed,  3 Dec 2025 19:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764788690;
	bh=aGzbRJbeT3IOWtWgKv9SQeyNm/6DptS3SWAhcU/89oM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eZAsd+uiYiYijRM/xndKWYV/dH/Ysd8e6EGy32Ezg5DJnhjZP0auJVPTpr1Rx6PWi
	 nkJQ5sFfxsdhhHmX5p/kWicdMjuwqody2RxrzcUYpM/Ang7BJToUQfmvlPnmsS+Z5x
	 3z7Y9aztneDJbGimGlAT5vLYCKFKDhar33VyOnS10ElJBiPkFRzeX/NFPCi4nrJUYs
	 X9lvlQjGsbWDjYlZrLUi8TJSQDbaacDjmVEhwZA7UYAXbeKLRJXno5J1mZZTJCJaKW
	 jAKTpD2hZz6YVfLbfbpI/TukHoD9tqawayqTdawOGonDc9o57z5jIyUcu6bt++D4Fi
	 5K0SNhq5gBMSg==
Date: Wed, 3 Dec 2025 19:04:48 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm/readahead: try to allocate high order pages for
 FADVISE_FAV_WILLNEED
Message-ID: <aTCJ0Js4X7qlqzDZ@google.com>
References: <20251202013212.964298-1-jaegeuk@kernel.org>
 <20251202013212.964298-4-jaegeuk@kernel.org>
 <aS9uod21hG_qq7Rd@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aS9uod21hG_qq7Rd@casper.infradead.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6CA5FC0011
X-Stat-Signature: i7ogo8rpgmenp4966p63zx6g6cdgdts6
X-Rspam-User: 
X-HE-Tag: 1764788691-314879
X-HE-Meta: U2FsdGVkX1+v1f3YMGooQ+CEtN5rtOelZFi/HJREuveAhDVHp5srRHezEEqxzL2OSMQ76gmu88mQvNi76gG8Oz2PFPYU607Ek3lVrDg/ZmpSwEJjf8TjRVlmG7thup8AYf8l89BR/M3o5f3dfBPFwPYeW1oyh3W1wI+4X/DDWnV3BF8X8mi7ldGSuaYNDI+TaPQfqwVg4H5Oni0kPCnb63XeBmyl6iRADjaZ09mNf/9GF4sQfXSFl3R4OoUbyjLwOhuWSaBtSPPTKPOvKqkgnSUrr51CAMT2nZTdEdl7HFMjzTRZJ0gnOrAfGwLJ3gz+fk1tIVe5ZcAuAHQkQ72Loksv7kobJe5Jx6Z8F5Iblrro6Gx8VdBK9GQzLI6+kjiCQqdQ5EuYe1bLAna4qj8CTsBwc0GOTkQUXB35vfBN4VA9DwuwfIv86qAfPkpDxQkValAbS9NdJwRY6zPaH/ptRCijYHDE6rF8Xv/wh+HqwWo1i74O+ZeveE/tqxWjxd449oTwqPJSzLUfJrqyx9Mgc3dz9eAug3jwFvL3PeKvry0SmAjhEsYiR/syvVORP10655h4ns0nWcoDKYINMwdlM78ajsE80DHqIPXOs7aQxAlZul+A6pTBcGecGiIxbc8v5S5zaYhhax2lb1YyFRc0X8ZprO/sDXqEgys5beNakoT8+ZZkrYhIhvXAZldMCMvYZ0pCT2iWrKepDAtqN1TbHPFogJcwqQnw32bw0ErDKEQw7x7ZEbGXfbkklorvrNiLHX7teTzCgpFQEvjxJe0oDsIRXob+mdHW1cfseFxN+XGkqaTJ93kidVtqRnzffWQHdDludZ5Z0/mxpxh3e+9KThgSubf6tduWMRGHTFbnBtB6z2lnMZBQG6Wh41ZeHok/YfKjb8ur064ujTr+oTiwBn+R5tPPSEHXja/ao7avnLraEom/PEPUkMQuL6q+ihiaj3jcoxfEtQSyxAPMMij
 1iyWoHzY
 XRYqyI50n3n4i1AQuFQmJroQ6+4Oc531r7ZcHeDTj/1RiIFGPr8oLST053WgiVGwxl4r7ZMnDtttO+CeTBle5qNLbBaX2WpTRVYp9Y7mQHk27p4amqKpDY2+X3GdTq3OgriJdBOzW8+mBr6QpDu14+WqEWRkneN+8HBJNd4Q/ZwJnqDZ3kl6EFd9OqgGm7kaEhemdUGkeWGCychT2xs2Z1Xqwpv10Gd+KvmUMyljo/lEkTSp8zShdLTn+YKVwxBsgifAK3O9j43vXRJknaDaZ2nTgeQT5srdXiC1VbhtTwNDcKVmdtJCDXJ99vsT+CFzNi0WnFPwrOzYE9q4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/02, Matthew Wilcox wrote:
> On Tue, Dec 02, 2025 at 01:30:13AM +0000, Jaegeuk Kim wrote:
> > @@ -627,7 +628,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
> >  	ra->size = min(contig_count + req_count, max_pages);
> >  	ra->async_size = 1;
> >  readit:
> > -	ra->order = 0;
> > +	ra->order = mapping_max_folio_order(ractl->mapping);
> >  	ractl->_index = ra->start;
> >  	page_cache_ra_order(ractl, ra);
> >  }
> 
> I suspect this is in the wrong place, but I'm on holiday and not going
> to go spelunking through the readahead code looking for the right place.
> 
> Also, going directly to max folio order is wrong, we should use the same
> approach as the write order code, encapsulated in filemap_get_order().
> See 4f6617011910

It seems the key is page_cache_ra_order() which allocates pages by
ra_alloc_folio() given ra->order. FWIW, madvise() and fault() readahead
takes page_cache_async_ra(), while fadvise() takes page_cache_sync_ra().
And, the former one has a logic to bump up the ra->order += 2 by f838ddf8cef5.
I think it'd make sense to match that behavior?

