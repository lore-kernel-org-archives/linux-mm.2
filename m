Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B5F7C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C27F26B0088; Mon, 20 Jul 2026 10:46:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFEF26B0096; Mon, 20 Jul 2026 10:46:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3CEE6B0098; Mon, 20 Jul 2026 10:46:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8547A6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:46:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D540FC01C4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:46:11 +0000 (UTC)
X-FDA: 85009430142.24.1CA803D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 33C1C40009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:46:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="q4gTrKD/";
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558770;
	b=2dsh+MCDD9pCTnlomzVo7MOgIlhb8UXPCzeZkF+Ajk9tilTbyzZqxfsABS4vI+/Ndcxswv
	84E8utjWstBEVeY3yuTg4HFkFfb6rvqmvbBGq1DQb4HBVyBFx6QsCV88T3/WXlZFKxGWI5
	FXxYR4iLHLsWglxL6RbfCWOoVhnT3gQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="q4gTrKD/";
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PfRAFhBZQchppXOO+Jgr0cSkDMbt1DF4C/TUagsgCiA=;
	b=DDi3aDSgGyLGdFAb3vl2UC6ecL1QtRmeWBq71BlWv2inDyyqOtJsfaQ0NVq3v1mwoWiQut
	UyAGCHTwus9p53jJPRZqekVbNC0PiJahBwiNLEZNl4vWTDwD6Ms/VzFLYy/jNzlj6DhJFa
	BEit3kWxuNBJQBLe5XnXkLzrL3UT/nE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PfRAFhBZQchppXOO+Jgr0cSkDMbt1DF4C/TUagsgCiA=; b=q4gTrKD/JHkF9rdgVeJRopM9/L
	urB9FO9pjuI91E3n7c9jeYmhfBQk91aQcrjjO1TtyyNPydmLVGxvVs8GYqpkhU6xWo+Hks5uvS6sB
	lbHDdqdJUCjuYiG8mU+GU49oC7mnX3Kj2F6mfBWxhopOLY7hye2br5fU7IrywpKGXRzGUth0DCKqO
	83YobtUbSGP3EUD1DQkEyI0UuUvTT/LFgFWKV0uhYRaMArtJ9d8bjgZRIC4ZiJqYnK1EvgzzFLcab
	03iYunE5zqja9kzp9HTj1eUqgezn+yrRqb7Fy3L6X8ZPqqAF9rs3rAq2uuSLtzcM6NlT1/E509PwL
	LAH7i8BA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlpFo-0000000B90V-2Ozj;
	Mon, 20 Jul 2026 14:46:00 +0000
Date: Mon, 20 Jul 2026 15:46:00 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Mark Brown <broonie@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, dri-devel@lists.freedesktop.org
Subject: Re: linux-next: manual merge of the mm-unstable tree with the
 drm-misc-fixes tree
Message-ID: <al40qCMTxhEP3Kx8@casper.infradead.org>
References: <al4jGBGNG_QACaNL@sirena.org.uk>
 <20260720144141.GA16699@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720144141.GA16699@lst.de>
X-Stat-Signature: 83i6jeu4xxihamoa97o7qhwwphkrjett
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 33C1C40009
X-Rspam-User: 
X-HE-Tag: 1784558769-36981
X-HE-Meta: U2FsdGVkX1+c1G+fEphHPF8Ovu3BNIIVRNjV9kO/QcfhjzvbnD0smAUjsEG4YAB3lkEuWNl4YwnCNzA64pV+Rk/8hlSCmJJEeHTLBHTB2Vx+9JvxbPeNFv1djyqnuENzSjj3yOnVqns8dpxQsJNqV+yOcJD4mHPkzFn6hN7Fv889pbHw91tocD711Mw6TnQO1iohNfLXnnzjyskFUKIXOiTvbK+AvrNX7GLxP8dxLyRz5C5fQZb0Sr++Gc1TCD99yMkIGEcRwQA34lrHGbqooYzRElBUi5DxoX5arZmqOkcKrNKEE8SMJypGapiwDTlucgk4WTC/prl+hNWNkJFunzobvcQygY8i55Sg23lqWRgLlEIm1s+WERjQtUr9WR3neHCVFu5up1xYZdyWAPIwyZt/s22tVUZHZXN1eRvwoWnTKLV3QuT4gnpuBxYZ0ENK+lcbuaulTO3Ppnd2OraQ1+a190HZPKHaOsxsQNFmisMO8KVR85MSDbyIS6p6HaE4uuOQdKHpNxAzqCNGb18LF9MF8FdG9uZLBsHSWrs538Vhr7Ju4CPHweQYlFu7l7t3yRXjfta6PiIrRyksfW9uVtot26pIUnjkf/uNSgbWyBSJpF4GETSokLI1LZZQqVucRH3TqJgObJzM77sC76uv4zhTZh8TDrdbTZVRpYqBpwF6UOnNIyaEhxb5rRbjF/jhZJVPv8mo6CnbemKA66zBCGakTyELq26O4ezaP3WkrCMNQKQsyPoJwGOAZPOcoadaQBvKdu/fQsktcUWK1M+FpYZEpIi3jAdpBIOvGrMA1+dkjOxj/wso9Ydq4Lv10JpUewEHMyRxKnpcb+Z6UrxuBDCKk9M2w56je0lS8o1HIgeTENsD32MrX/pgXsf+SWwh4BkFd4YfF2ExqiTu2DeLJXoiI4ntIEE9pCZgQK7nTDbGRUWNHHz14VIPzULaIaJVDgbu/0h9MiWICBOPNB2
 dPtWU7TK
 WtjQzrrE6e/YML85bE+OF9A9C/opr5g7ItmrAkHZ5TzlO6DpvlI3pk3qFH53EufjiVSqU798AlKTr5lef16yDZUVDiL69+fgSAcCbWbLO8asQpHvlrSvbAnmScaLOku0XVEmAcAJoRk+Zku6QH6zyneWzBJWJKdhwiVjLHw0WPC0fBGTsHStKN1y/OHLVrQycBVjAvw8/q+Jc1MxUwsZiOzgubcRE4G0rsUa69rAXH3j87ywDi8TBh7vx54r8mvoUzUkZzcGn4LSSg00aJipO2umMkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 04:41:41PM +0200, Christoph Hellwig wrote:
> >   /**
> >  - * ttm_backup_backup_page() - Backup a page
> >  + * ttm_backup_backup_folio() - Backup a folio
> >    * @backup: The struct backup pointer to use.
> >  - * @page: The page to back up.
> >  - * @writeback: Whether to perform immediate writeback of the page.
> >  + * @folio: The folio to back up.
> >  + * @order: The allocation order of @folio.  Since TTM allocates higher-order
> >  + *         pages without __GFP_COMP, folio_nr_pages(@folio) would always
> >  + *         return 1; the caller must pass the true order explicitly.

Wait, what?  This is just broken.  TTM should change to allocate using
GFP_COMP.  Why can't graphics people ask questions before writing stupid
patches?


