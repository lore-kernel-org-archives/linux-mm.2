Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C616F5A8AA
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 19:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6966B0088; Mon, 20 Apr 2026 15:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87416B0089; Mon, 20 Apr 2026 15:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D626B008A; Mon, 20 Apr 2026 15:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6F8B6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:12:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65E73E5686
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:12:18 +0000 (UTC)
X-FDA: 84679879956.27.B65DC19
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7CFBEC0006
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:12:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vgU6OGKK;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776712336; a=rsa-sha256;
	cv=none;
	b=HO8m0oHFPSUCF4AfOpRVoQSzARpop7B5ljCPrGAOzvMxkKSIHOU2z3MEI1+WSED1Lh3HA3
	IbxjiZ0UHgUkbwhJq9Ybdiiei9A+GZBQJJibG+q9JJCzNAWZ0xFSKQxfis4dkjF4+ptgh8
	aGgs05A5TTh78Tu/qHG18Mys7arCg5s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vgU6OGKK;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776712336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkzMuMQfcdnmbiI4D9AB8V2Ucb0IPvboF8F0c8KdAw8=;
	b=dyKnQfrzG3caLJavHvVDgEiDlyc2ueuDU33AnhtcP6AdFEvhxKiU6f39+j07c50QvBSNmH
	oDGLlwI+jiS+2NFoa7v57Cb26mzhMfPJD1I7f6fU0o2lAdxiqZ38yeEN98NKKzPRXNw7iu
	dSkm9bTx8A303dh52PcORHPDggB24TU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VkzMuMQfcdnmbiI4D9AB8V2Ucb0IPvboF8F0c8KdAw8=; b=vgU6OGKKtV1z6cr8YCFIYl0jab
	svVav+9t3+DNXbKDQ3pXw4PLkD63DkQUz+4XXOKeb09ver8XDUQ5DQiynDb9FTYrP3pExGfIniDyo
	0nmQvm6+iVI5SO1A7SAnQvKtsUgGHDSXO9qvnLt9yEraGAMxKFvHhhA3Kke5V1Gc/Tbttq+v6GARY
	tPJic+KrlBKRpsAIKCDnnSnveEBGPhNSNDKhym213FZvY7Pj+QImPB9hy1VCIHfiSVk06yf3RssB6
	JmbhUiVexUbS1t19gHL2xkVGS8lxcUaqF50TKs6cY+vxOEkSyRgU4kvQTblwbeUE1v6qsenLGRsEd
	n6Yr4mBA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wEu2Y-00000008uTB-05QR;
	Mon, 20 Apr 2026 19:12:14 +0000
Date: Mon, 20 Apr 2026 20:12:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, ritesh.list@gmail.com,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm/filemap: avoid costly reclaim for high-order folio
 allocations
Message-ID: <aeZ6jQKL7zSCXNaP@casper.infradead.org>
References: <20260420161404.642-1-dipiets@amazon.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420161404.642-1-dipiets@amazon.it>
X-Rspamd-Queue-Id: 7CFBEC0006
X-Stat-Signature: n4njby6f71ptnkpuisbmk4fmhtdj4pos
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776712336-102447
X-HE-Meta: U2FsdGVkX1+X53UUy9ZJa+Gr/tOqd15NjVcSfB6iwJP+H96SaGt9WVTgRaH6ycuuw91zxbBshOVf+Di7Hok0r74w1H98Hq+vaf9nXd+BuWkS4J6HNhRoXNMqAA8ul5zac6jMNvWEK5nH0YVe3cyYrkKliTvr4aThvzew5FjAxTpdtQs8vQIJPqkhyaTUAtxtwvPV5MjeTUbH9JQJBE+NKeUXY/7NRf9/uc0ph6E96vd4v1gvlZCN9csRQrtXvCj88cY3HLj0AQcwjjZg+rFEVPSpQcReCiF7rEeJQMvUOOzic8ukUDi+F5zpLHlovxjy/oa4OcKmeqmd2AHe5SgX2uX1NeaYz3IRgA3B4oJkNJ3nblVCEy84uk3VDf6NkvQYfv/lf8KLDuiB3+k+NI0B8YMqM0c1MoUy3rZxlbwqsjZZV+KGcDS7cS6LkVXCNSCqD7D9dJwU+wrxe4RSG82rMRKqwK+/9w+y50kEsa6y+ZeOaLD0HYnWby8DcZ9af1l0Jw6QHYVf93nrNMZvcjip/qC5yEnUUMp/NT1UKKFEZz1zLm9lQucJ6+Rc3itX+jFhSa/u9GKuz/h6uDioXGyG9VtDwuBR/2oPZBvWK1PpNSnQtSCb1JM7lYcub062kLpR/GqYw9i4nWryssGnJoL9QI6VezkbWYwmhhHuzJKkcS0tUj7ukJ3eo97bLGgTZwVh3ZO0CSbZbphltK7WS4T+ZjdOO/NNpoH3yLK9DjewgpKu4bnslkn3EUxDDt0T1OqwCiQLANZj35KwRN27IRaB7PHaFid2tTiM62czqOXrmU2XcfASsw9+rYkyBK/1PVXTsw6Iu7gh5eRBlElZPkgc1TjIKoiUJoGHoqSttyUaDfsKPzym4KpOlRewhzmm0nuezqGVo1TwfTXJRvF0jids75YoOBCQCSMedXUD4E9Q6J+afoEbJM82MFJXKXUY8Tm4whYXZ5JrIo/Y/25jkub
 GQPrxTIn
 r+Q2bkWeNiMH5zMryFD2iKuzHi4VUZFcdntVEctF7HSgVZgiIwckr4cT6CvhKJWElQQG2YAkt5kSnrgWr4wGJuyTv4XIHsWhUnLM/cApuLSbsTDUhsOMft4W0DY3HFWWarhHbjt6C19pKF7SKezMW8dizbjcnYJLxA5Zt6/z/JUXIKoJs8/bnHYDFPEy4XCkhLnQnXbxVa55Bq+5f6xcMffRFnpTCJc4eyq4ZHM4iVoxIANHcaJGEEYwKQC84ni39BjWPIVZsSC0PwvqUoIBjPQAgJYXVZV7mo2EGmJZk5BpQ0S4PWdIamfxYPOaUapWZJxZm27DEjspyHaW+FRGzmXGmQHM8+BH81Gef+/Fjwl1puyqVMtFh3JsgM18Ro+wOJpCbj/NmGtDO1AKc8LdEihwN4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 04:14:03PM +0000, Salvatore Dipietro wrote:
> v2: 
> - strip __GFP_DIRECT_RECLAIM to avoid costly reclaim for high-order
>   folio allocations
> - Moved fix from iomap to mm/filemap layer

I don't think filemap is the right place for this.  And neither does
Dave Chinner, nor Christoph Hellwig:

https://lore.kernel.org/all/adSY3GnLHyQatigQ@infradead.org/

I asked you for performance results with different patches, and you
didn't reply.  Now you're asking for this patch to be merged instead.
THIS IS NOT HOW IT WORKS.  You answer the damned questions being asked
of you by your fellow developers.

>  			err = -ENOMEM;
> -			if (order > min_order)
> -				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
> +			if (order > min_order) {
> +				alloc_gfp |= __GFP_NOWARN;
> +				if (order > PAGE_ALLOC_COSTLY_ORDER)
> +					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
> +				else
> +					alloc_gfp |= __GFP_NORETRY;
> +			}
>  			folio = filemap_alloc_folio(alloc_gfp, order, policy);
>  			if (!folio)
>  				continue;
> 
> base-commit: c7275b05bc428c7373d97aa2da02d3a7fa6b9f66
> -- 
> 2.47.3
> 
> 
> 
> 
> AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico
> 
> 
> 

