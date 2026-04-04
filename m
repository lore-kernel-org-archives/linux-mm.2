Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1F09E88D7A
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 04:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D914F6B0005; Sat,  4 Apr 2026 00:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1AE26B0089; Sat,  4 Apr 2026 00:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09C26B008A; Sat,  4 Apr 2026 00:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAD166B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 00:15:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5AB46C1B38
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 04:15:15 +0000 (UTC)
X-FDA: 84619558590.12.5A091B2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id DE8BF40003
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 04:15:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kv6MfH97;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kv6MfH97;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775276113; a=rsa-sha256;
	cv=none;
	b=oZ/PRs0zlweSDNM2naBr4zWRntsxrIyt/SonTPEbvGsT0DheQ4PSHXCT/vZGUFMHVsR8yp
	zFO/vmHztw7gLsZOX19yoPCkxwavezPbXLrlMDpN7DEuyf8oBOeDhC0NUuPEYYKHHfx/+O
	EB1VHOGzbPm7SW/NJC0LIRlxCzfoZmA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775276113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prgjruknzedrN/FySTUns/2cxrd1Ek5UwRzTS2GVwtQ=;
	b=MZJGqeuwsQzSayUvbGpxEH/wyCyaNrvu09m0YHv4ZSCCfNkpGN1EezKreK32kd9bXql+/R
	87YwuRFYzoPRhOh5V3SZyO5oRPTD2rPK/ecneQVzoPfbi0ofuGk0UZYmkP8u2yh6rqU/GT
	eiU8CtMlMd2PW1n9FsTVIvqo2zLTFuc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=prgjruknzedrN/FySTUns/2cxrd1Ek5UwRzTS2GVwtQ=; b=kv6MfH97kDKvbWs8u/DfmlPLjB
	5VO90TEEKgWCAeJJxC9SIn1GUrL/irrN3MiSJPxvH11ki6Gl4DulTzSMKHfC7PsuL8Wjl7goHueEV
	sPCgxGOvoZFxpMbC1AbqJwQ6y0P4YjChWmmGbbXXCFKBx3UfqsuRboj6Dx1OeXjjeSvbMibkQbGli
	cTyM035nMVVDAk4pq/XHZAQGxPmh6Q1oFikGKjEF2JZ36/fUzqMvWJF7Ib2j+fb9+fpCPdFTn7+R+
	qZQSwsX5UgYG/q5pkUtH5iu2ijNCIT6xhDm186revhAwa5YMGW2ccgsRTj4FmC58HMqUZj8GgMyHY
	YI1lbzHg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w8sPd-0000000FSmQ-0Veb;
	Sat, 04 Apr 2026 04:15:09 +0000
Date: Sat, 4 Apr 2026 05:15:08 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, alisaidi@amazon.com, blakgeof@amazon.com,
	abuehaze@amazon.de, dipietro.salvatore@gmail.com,
	stable@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <adCQTF1PQnlbNMO8@casper.infradead.org>
References: <20260403193535.9970-1-dipiets@amazon.it>
 <20260403193535.9970-2-dipiets@amazon.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403193535.9970-2-dipiets@amazon.it>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DE8BF40003
X-Stat-Signature: szxy9yorhgrkzuqp8uzhdunzumysxfca
X-Rspam-User: 
X-HE-Tag: 1775276112-815794
X-HE-Meta: U2FsdGVkX1+fJwWbg474IT/q4HZMYILNjuTW4rwCuqhJpwcHlg6JirngbyjiLjWVxCJovJOZ6qrPczn0MWACY49TzRBtB+UiXCHdiJHIfmgYnETKDYwQ1qqdENfdwDTs/Eygkz1nkMY8hIk/ynxjbO+bH1nvEv656qjlTfrwy7PjOSSoh2Er18TxkVFIrMf0WabN9JzfTCCad2WmdcXqt27dvBHNaqf37yIhIH537XgIFeqJTDPzP+YagnOJHhp9C2bcD3mbL0xQnCxSR2HKlyO7ph7KEpOCcUEw0rOTK/o4QXAGJzUjdoM/eU2aSmdNcE5CgTON5ZQ+1dCUgyn+rCQnG4KfhcF0J7J2D7vOqSNp+akO23jfCinyImFWmsKE5C9WkvR1408y9hitQarih9Gq2ge5/UEuy9ZeOhyp0UC7wFt7HLgYGFx0KsHzGZPv+74BKCdktcsDgkl49k+iyrsB1QR3ZB2BJwRziBNBHrXpRFpIya0eoL7gUCPiFvGtDoxW3uN8BavSCQAwd+pRTPKw4M705unyue+RthJXk14bbPaxkgnqkuRjXAdZX+NP8Yg3IN5jMJ62uAQcUAW1J6V2/HnNGNWJJjiaYLLSWx4PCGjKo1Mbk6/gefXK/auJVKHembQSINJxSs9UhQ0MH7JMw/Kj2GUcoEj934ykArF/xMq2e3vv6HdmlTYBbv4sPZGyCbvQTMEKQcgAVbBlAZe0ZMiZ5VMZiSCEToa2r6nBN1YNKpUlG4sD6yZ4Ha0LIm7iTQwH4fl0PMGTCE71/cJ6awDNaclb8+M8G39neLNu8SkzNWvv5pa1NnTjU1wB8y6IQACX4mY6Y3UDqwhDIibaiYX0aKWpAq4Qzri7NRUGk2F6MCGAWJyTSryvUGtckrp/ki2Mh/+ZP5qjC25sL8BFOAlZkeMYtdDs+wOJ0aVKEt53rn2w4eqQaxIegSgzGQhWvbFgifyRiu9ef5z
 78WHXmxd
 AQvwdwBv73qMmw5snTjaYntFX6VznRNi/k17ZdQ1wUpfOcP81b6CF5is8hhraaN+bq+tOik+tvQq2mFJsH+cvj0Pf7UJ1Qb0tOlPVkDIZqgzK7oV/5v6QC+piUwDdF+dwQ3/m6dkG3U79i8WLKbdnZl7NGJlR1vnccxoodKA140DFuKAdaptS1Vu4xNdRMBtH1Mgrg4GmVNI8AIDymT9+1mcxyKYp8DAnLrO5+nM+dWgU6kW27Gc0y5dj6n7kSc0+jiiz/b9DVCL7zr++FAOBamF62Ip8QuLywqTsT3qnmkQqyKVwo4uKtjcQf7IbUmwp4VPV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 07:35:34PM +0000, Salvatore Dipietro wrote:
> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the buffered write
> path. When memory is fragmented, each failed allocation triggers
> compaction and drain_all_pages() via __alloc_pages_slowpath(),
> causing a 0.75x throughput drop on pgbench (simple-update) with 
> 1024 clients on a 96-vCPU arm64 system.
> 
> Strip __GFP_DIRECT_RECLAIM from folio allocations in
> iomap_get_folio() when the order exceeds PAGE_ALLOC_COSTLY_ORDER,
> making them purely opportunistic.

If you look at __filemap_get_folio_mpol(), that's kind of being tried
already:

                        if (order > min_order)
                                alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;

 * %__GFP_NORETRY: The VM implementation will try only very lightweight
 * memory direct reclaim to get some memory under memory pressure (thus
 * it can sleep). It will avoid disruptive actions like OOM killer. The
 * caller must handle the failure which is quite likely to happen under
 * heavy memory pressure. The flag is suitable when failure can easily be
 * handled at small cost, such as reduced throughput.

which, from the description, seemed like the right approach.  So either
the description or the implementation should be updated, I suppose?

Now, what happens if you change those two lines to:

			if (order > min_order) {
				alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
				alloc_gfp |= __GFP_NOWARN;
			}

Do you recover the performance?

