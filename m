Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D00CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 719B26B048E; Mon,  1 Jun 2026 13:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8546B048F; Mon,  1 Jun 2026 13:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E0E46B0490; Mon,  1 Jun 2026 13:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 478336B048E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:49:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFEFB913E3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:49:03 +0000 (UTC)
X-FDA: 84832079766.07.41FE612
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6C0AB18000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:49:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qVpxpP6j;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780336142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qwdk/pI6z0M9pmHJY0eaojInR/B76JcdGEXnXVatnqE=;
	b=bqIdWorTZNvXCUPrV5R6J936o5RMudKJVEIeF72GZk4GBE7fpbOibu0VTsL3CDFlKsTm3f
	WbUY0AFKckxKGj4RRKB/sKgEvwFYIvfK0W5XotjcVDx7FwrX3z8XQigyyN4msgiv2hqBtN
	b+OIK7wyX12osP2U1lGYvyAes15q5ps=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qVpxpP6j;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780336142;
	b=GZFeae6eMpJ5PAPvUNMmYkvVZKAUxy1XDi9LAq4xT8tgWm+x1GiY/8weTgYm8twix07A/A
	XNPJ03R4/BSa/jICtt4tySBlBN3dGus6hsKMbffB6e4g+C9Gk7uW7Dop2ir3HN11pwAXqq
	d+Ktl/H+MoyHA0kGkDu5MaSaOuWuyWc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Qwdk/pI6z0M9pmHJY0eaojInR/B76JcdGEXnXVatnqE=; b=qVpxpP6j+td4VHBF4PDCfsm1mz
	8HSqXK3eJRsLFYmDMMbDHMC+4DTvLNmxTh17W8ksydYCJqNrYET6REyBZPzNnCenAxBwpPso1ivKA
	ZV1ITNDf1dbF7d/OkpAaNhqLF2E6jxPoOwE8L3LXYezLxoprYzYlopgd35mrDtb0IaJ4e7CeCrY6W
	5cDGwblQSKoPFj8k4kGBvn6J/FEc/KurTI5k47sc+Aa2gPX8d+xw+8R5fz2F3f8zIKi+5+XsxRYB8
	Mk/Xrt0YUQGPvoulCG6f9sI7qA2ha6vS2Zts+AXF9XOTJ/GK2JY4gdiSBilmVpEYxbb20i0jgFOWl
	EzuWbsOQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU6l1-00000000VXH-2AA7;
	Mon, 01 Jun 2026 17:48:59 +0000
Date: Mon, 1 Jun 2026 18:48:59 +0100
From: Matthew Wilcox <willy@infradead.org>
To: tanze <tanze@kylinos.cn>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	jack@suse.cz
Subject: Re: [PATCH v1] mm/filemap: use folio_next_index() for start
Message-ID: <ah3GC_Ho8IrGuq5d@casper.infradead.org>
References: <20260601110425.44784-1-tanze@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601110425.44784-1-tanze@kylinos.cn>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 5wy5unr4wd3hpjaya4ozhfnhkeoc79bx
X-Rspamd-Queue-Id: 6C0AB18000A
X-HE-Tag: 1780336141-546677
X-HE-Meta: U2FsdGVkX1/dosMYL/oZqwRYh9xfZ7+qWTneIjiNgWQ1HVD0BECqiIAD3+Kmqs1tGbU10qeYkza3ZbC+wWXKC6vMFWvF9Qi3NP754ZuA9bY8XxqPw4DJxoAintwlImqGxRjtZfKtIHO8Hf1QcSuMYPQVSQtLntPuBLOjH0GKIRg+vKIv0BQlwU6Uzcz9INoo6TMAjrFdqpyHx57xfhqK3FG9vdHI48mczTkW8WI3Yf1lWuApbbzNwXtUuudHNXKtQzKj84vZAz9uRdDE4BSlXLUBj6hnZc0rEcA03+jcu1QtVYs9rpMcPAcQHe7wf6vC2FUv1XG0BzSd0BqN4T3KjRbhmFrLLIJN5tC8BnrhK+eYpfmZAXAzKGrRCCaEuWGATKNVw1URivCQM3r7BXJ0Bu3tZ5CXnaLOdJjjdSZxUb2vUlKobPk/xCpsKAGroPwaitrvqBIZ8mdMLYyfjC+bPKjLylbsjuV3q+ivIUjJZzyOUHwRIuOLYYpNn9Gxtw9bsTsdvnzbtvTYxxrBXi0qyIUcftB1SZK8+1+gMxb9FVuD8FIIoh0WiAD7YCr5Mc/bQy8ViZAoseTXHx7IsCmz5Fod06NAXGkfj71IKlnx5DwumgUC0EJu7eDr2iw0yIvuo6HpOt+ZErtxcBvlx24PITtoBej1G+KVVGvWAwIW2jjt/bed1CFmoYNLverFZiwRXDgTnGgpf4KAkPyHYdGZ4tFZVCs1prgVPULBg4nLNj4LavhitiD3qBmT4SiaXShVmhkP5Cr/nH7uHONZoUKxBqla0bLXiF5mh1O1DxzLS/GMRYXSuUEdXIm83FN+a3/rNTUMjLg5ZjKg0dkDXXLcxJXDpWqoKyc3gqpKnn8ciB3p5FPDN5VulONyPq8yg9Gu/kHcGtsGbDOn2et1jvS5ErbeI1l6psxrbG+K09Y1F4C0isbK/jy/lcCHEfBUMBqy/x3zvIco4IdsRW2l3vV
 gG2pRCAr
 tjRfBwv2rfe8cHLIK2mT7HBAJyyeSivYszfTPt2Ybn26Ljzi3bEy5ktd0QWe44B4jJauiQfSAUJl1pNaoSBxbmgb6WDm4Pdfh0x6OKzZS9MvM5mCaEzCHc0Tl10pydLb3yYkazVi49zGJbWIBV1lUYoq1wZ8bknlrphLhHntV9RTj+zuHZlk0NNsaK2Q9xk3UASe28jIhE+J4vmGjPSu/OpHoGaWcA4TglEGoY1xLaPCh4m/pr9weqeB3t6Ropr7yFidwMEdRfAKPv2oeKfP5TlliYULMUMdfzxJwYYGaYbCflZ+VBJr3FjH15XuBKB2nefrzaKdk4k8v4oXAmSUp2uV+X12q6fQa5bJiW2mqGo3HDu3xcDud80UmUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 07:04:23PM +0800, tanze wrote:
> Use folio_next_index() instead of open-coding
> folio->index + folio_nr_pages(folio) when updating @start in
> filemap_get_folios_contig(), filemap_get_folios_tag(), and
> filemap_get_folios_dirty().
> 
> Signed-off-by: tanze <tanze@kylinos.cn>

Thanks!

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

