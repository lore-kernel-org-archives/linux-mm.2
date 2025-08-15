Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2C4CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 12:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7D6900247; Fri, 15 Aug 2025 08:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA8558E01EC; Fri, 15 Aug 2025 08:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE500900247; Fri, 15 Aug 2025 08:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC1A88E01EC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:24:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5182555202
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:24:24 +0000 (UTC)
X-FDA: 83778909648.11.DA62A8E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 949D5120015
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:24:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FBvgaCMd
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755260662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgPEkDv+7jph4GklLNs9K3EdOtaugPbD7LdlNYsxyPE=;
	b=iB9ctcn2hWcKYTR6rMMgE+MSFaVb5P44lNK8p3MO0sLV0e1/wll2fmiv9ifdZRBy9gWgq6
	JJK/LdIGUGP2SgJDXiFMBnV5IkixWUhEvXCq5BBry6VThXtedGAI2HGEijVdtAx7UlVsSU
	KrKu9t4VMQJezpbMlIVyje113QfqvN0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755260662; a=rsa-sha256;
	cv=none;
	b=lrPelhMrfIXhyRFs8KRAulmRDYnoBuIBUBKQRRCyvKvCmeIy/7w6Oe1P4PZv+EYgRqq6iR
	DWHj29bklH4Lv466y0qGJXvXoVtASm1Z+nSP3zijW/YcpPWQnZ/V8ovFSo1dwn0/Falbqk
	jTP53gnUxqOgrpbH9/GVssSHJj7pZ4c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FBvgaCMd;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jgPEkDv+7jph4GklLNs9K3EdOtaugPbD7LdlNYsxyPE=; b=FBvgaCMdtC/ao9r/NkTtaTi/Hv
	HTjyLJiXrA8cTXYfnZgj+WAZoUYd5gpntXRRXKfJA3uPUnKK4boTcQ3X4DiPGQg632ym1FLFpkCL4
	wSZxR+P+tRTzyVSvVQWAJf+3oR5b9636ujdKdR1y4hPDPaKL/BnEEb8r7ko8OGZFEhkjGRToo1GXS
	VDmrhqCeMKTbKpEkJ5X8CuZ+jZ+oCF2Ebu6ShuTbUR0VvNXWszN6hBVoWLwN1cd0RLkU9r1iS5UxB
	/qk7MuptTOUzDItruvSVp6X2i9Ex/GXIoy7gf0qGD156tjY4B94p6v1jevkEqQJz8KlFu21mjvUIN
	1FJ5oM5w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umtTY-0000000CYl1-0asH;
	Fri, 15 Aug 2025 12:24:04 +0000
Date: Fri, 15 Aug 2025 13:24:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page-writeback: drop usage of folio_index
Message-ID: <aJ8m42sM1NX_wEE9@casper.infradead.org>
References: <20250815121252.41315-1-ryncsn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815121252.41315-1-ryncsn@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 949D5120015
X-Stat-Signature: ksqm1784qu859acsumcuxzu7z9d19d5i
X-HE-Tag: 1755260661-139838
X-HE-Meta: U2FsdGVkX18Ty6pe5H6WAhSRJ/Yg/LfQZZHQ6fJXV5D0PzzSsFCsu9Rn8lc37ts7OR2o/4kDU3a/TXcFbUyQXSer+g06Sl2AD/5yLvGTVy0F3yXDYAeObPCRwEGYc3UjYdFi6APDAC0PlU0+k5zxbUEAhs1myHprqX7kep0YqGkjCiM3edWroe0E9uYIEG2Mq86mvrpnqDNoIa/9b+9OdxX3c9VualoQmSgbb6FLg/S1IreI40FLtyVnA8Y0v7yXE85MS5VeS8fvAqFgN9eubbpiQndbZnWIDC9CD3dfrOr0JPcJTdYwS6hcD14LpaAo1Jh2wCHBV5hLSNfcDrLEupggzp9iF2ZYFLq1K1X0Xw+REmQUpdfwaX9tnXUl9bOMC0wqTlA219xzid4E6/UHMCx+NLykLvxR0AZvfYe65Qc1b7b13N02nuhIhFnqHCmoWK1z96O/CzaMEjMb6Cyy28mKqc8CuIn8lfpA+6C+WXPau6MClBJoymh6C/8hvUCPb7ga55c868qSnrXnj0gTiMNiKDFl7F9lGmYfT5cJVloREKpJ6xlBTFZKLhJdONNGyiOwljzqbfG7pGgq9WtNh7vx+9sJlo7DHe0IuXOFdEvjHVYDwYgz9W/Xva8odRri1sdLJJrwnAZlA+0gPMQnXfRVZnNZoeLJJWagpHjXQqSpcuTw9AdVpDmx2pEUQ4po2EV/Iyo1E3IBKDTHPjBFZ7dP003b+RghBCy8RtLxMj/RFv1ewWXIsoHoCDR/r7Vv0e87kXqBnXt+ubNxjnT+UoNaXxHU6ARa+lEMo3wrkXHc8qMyeKs19vcKvjgCBZoQUTPMDNhHnjIuN626Kh3gk4uTGdbdMIMPWK2buqx42oxMhbCO77Qlglno0qLXQXBVouhBMi48U6gBEK0b9i0fO4NyWL2/1CzULtvD9+5TDPCa6rIU5CFR60WBMmHdXzNOiMWI2DNTOeLaZ6XHS/w
 cyCM37u6
 M2eAWtGk9JkEz8eTuTNxeUbzqdLp1x6trQQU740JFP1oLw0wj0iBCXn7XLJRFJTYnGIiLx3FLo9IO8C3fnnrMJgg1xSFIDlPstiTw9li2ysPatL4qySDPboWLAPGBg9NeZ06Onqjww0eHsg6UrYkjDGWS26fykjeMr/oXe4bHnRlhyJCV6KRb8JjEuKcHv67LXj8McC+EerlGuSAMs5uoH2gS3k0IGQ/cL/eX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 08:12:52PM +0800, Kairui Song wrote:
> +++ b/mm/page-writeback.c
> @@ -2739,8 +2739,8 @@ void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
>  	if (folio->mapping) {	/* Race with truncate? */
>  		WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
>  		folio_account_dirtied(folio, mapping);
> -		__xa_set_mark(&mapping->i_pages, folio_index(folio),
> -				PAGECACHE_TAG_DIRTY);
> +		__xa_set_mark(&mapping->i_pages, folio->index,
> +			      PAGECACHE_TAG_DIRTY);
>  	}
>  	xa_unlock_irqrestore(&mapping->i_pages, flags);
>  }

What about a shmem folio that's been moved to the swap cache?  I used
folio_index() here because I couldn't prove to my satisfaction that this
couldn't happen.


