Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF75FFD3762
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 14:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00D0D6B0005; Wed, 25 Feb 2026 09:13:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFDB46B0088; Wed, 25 Feb 2026 09:13:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09B16B0089; Wed, 25 Feb 2026 09:13:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9C896B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:13:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 855F01A0618
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:13:40 +0000 (UTC)
X-FDA: 84483172200.18.E17519E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9288A14000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:13:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=R3E1ZrUX;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772028818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gS6jXWPt4Zdu93IKPbSBVkFYOsRbvWw6AnriGigF+4o=;
	b=eS9uVFfj38yHU49IofRq5VzMDj/Ntya+drUgXCb0yFBWIoaeaq8Uhre4841KGJ3nc5d40e
	wuRj058XbUB2v7aDti481GC+B8SKDJ5m8qDWb3cM+ebLDtpYjNCgeJ6e5F+sxg6Gc8z4AC
	ndRsUwhDUBhUMNozgBtMPbGdSmHSgVs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=R3E1ZrUX;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772028818; a=rsa-sha256;
	cv=none;
	b=w8RnLAvfFBEviASLxyquT8CaR7QgwV2gxcRX0WM9aEw7RpEzn43vyrYUt6F7LcDmZjHpBj
	fv4YaYGdtcCbF3MC1HtHqQop2x3+IhQ8xIdp3De5B7tomI1yAZ4vILKEEolScMNzciURg0
	bwDkFSt1r2U6uT3+zyo3c4T5ds1saws=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gS6jXWPt4Zdu93IKPbSBVkFYOsRbvWw6AnriGigF+4o=; b=R3E1ZrUXqH0fZ5QB5RGjxTCzZ7
	No3sDUAz9zaDUpNb9xDgo/k0oPlxOWkXnZu7bZVTvyMHyxjqDr6Kwfsx2z+8dXfB+ul8tKYz1eANC
	lDQdQPBBZxOFVWoZGMZOVrNww1zKNGkAlmgVdH6/tHt18fY0hZqvzGmZlVLic5NapYcA2xE0mDeJM
	2j3lBpbNd/ZgC+pj3ephDo12EtRiVValqjg+Pd6hPaLdHJdn9FKpXTYOwZaD8kTYa/EvIe8QuegaM
	lpQzSpetHU4xCQ11XGIIojsJ9F0JeRf/8SyQl/J6U3D8W2Q6/jYcxERZ/RtxvKWdUAxIkBgnCN0i3
	tILhXusA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvFdu-000000019ru-2krx;
	Wed, 25 Feb 2026 14:13:34 +0000
Date: Wed, 25 Feb 2026 14:13:34 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>,
	syzbot+006987d1be3586e13555@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] radix-tree: fix memory leak of intermediate nodes on
 insert failure
Message-ID: <aZ8Dju5ythgf31K0@casper.infradead.org>
References: <20260225071623.41275-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225071623.41275-1-jiayuan.chen@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9288A14000A
X-Stat-Signature: i77xyq8hgjsifhxzbpkth553opg4dk9p
X-Rspam-User: 
X-HE-Tag: 1772028818-297369
X-HE-Meta: U2FsdGVkX1+sJncwPs7EOxkG4WRrcMXzccg6/tGiPVmxkmm6IDU2RVKyrpezfVBB9t+d0HCLjnA1jf5V7jhwdwr2PQFydwpbcaCgxE4Z1WOW5+5vbMu9sVu9HpIOpkRYwY+YRp4E4kIct6FLVH+fOM1RrxwMKTY26dsSMVN9E7lNsTIydoy/qs3y6vMctBnrDS4sm/ecd0wy1eNqIti6/aFBYVyOfrByaOaCdRKc3VVNV1O4pGB8Uh/imi4HzUXyBzrv3JzdCeOLnT+yb5o5AVKm2mqrev9quWF365Bvj/lvnJvfv1WnX2sX1DKmgD5cFKZEIt4CItorfD2pjdKvOnNSBtqAGIGE+Ihtu6O+fDCJM9PbEZTAzDmdbTPlmSFTWrkyuXtINdMUerl5FiSaCefMk0V+GGGAmMe856ZN2+TDw/ZUAmxeYM4YSwsJsJ02tBoXBrsDVicg2YBXG9e6iOXMyj1kMxRlirtYo67bY0Oh67eUQcDI/FT71ujmP+jpCqE+QzLtneT9ZUZiVzuDL2ucV7f2NLpxwXg+aV/WqM4SGr5raOcaH529Af6DwzqIQnkIaLkM5uNnhAqZF2X3fvkXuM3GZ1hxAIMZ8UO/+h6tCfRcwxJN+tIV/u06vSgVOJmC60avdeG2IMYqmLs8Qzy51RsjyfGy4tam8609mtDO5EDU/PoRzFcoPdQLG1o/YnAekjLYXwBjivpLjk92GJz65UFFe/jSY7ip4i3gKWUic4ne2wtH6S4Fx7ZcTVa5pWn2/Mbl1r61ZECgBUlTO4uiGkG6vDyZAZoT1tEtdxpfVmu5cxPAl2E4my+l/+CsLiR8fp6YaOKjKXn+0LYtZ30qrpAmYBtKHSU23DBxv6k9D0uxiHw4kmoN47THycQGkBqglI5oN/mWu0/fqFphPj92KgcmssJJLYDPHqNLRh+tQA58cjLD15rKya0r02cHa2YRrlxrquuQHGCS0Du
 rrOsUhlQ
 y1qbtswevMUAEq+j0jDkny5Zubmts5Cp1wKS5It0919A2kKtldG6PprTauEcp8OYmBUZihomvQb6OTzljJSFGhWQkHlwmR2TZc4djRx9ZD3Ig3U8qJdYGKlfQDoLG9CSkeHF+TrylzeOSoVd2R2iFImLpzOexpZXnO9YDLijkRkPyl7SOAsFi2kh+zfoHZYxxHw1ZpQEFW6JhvW6Z3vfOvU0ACgmu2p2ZXnJa55VpRxAxGJ5jU2nbWJQDxuzQYM55qkErSJu4sY2h+z9G+WwGkaRY5QAcKC4gZs559tDuMUiYutqZ3DLOhAeRGI3EA2tsDU2K9H2oLIAriuM93DFXRSoCww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 03:16:18PM +0800, Jiayuan Chen wrote:
> Fix this directly in __radix_tree_create() by tracking the first newly
> linked slot.  On allocation failure, sever the partial path with
> rcu_assign_pointer() and free the orphaned nodes via call_rcu() to
> maintain RCU safety for concurrent readers.

I'm not interested in fixing this.  Migrate qrtr to use XArray.

