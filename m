Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20FEDF531CC
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881386B00B3; Mon, 13 Apr 2026 16:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80AD76B00B6; Mon, 13 Apr 2026 16:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2F06B00B7; Mon, 13 Apr 2026 16:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5698F6B00B3
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:41:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC0578ADE8
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:41:44 +0000 (UTC)
X-FDA: 84654703728.01.D045FF2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 122491C0002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:41:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="nz6I/UeB";
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776112903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WByCkjiLUoqcmY9Xk0+CO+njRcv+yHwZgHE3y0xPWo=;
	b=IUDX6ChdRH1GO2PHZD8dKfx/ZRU5ojYfqZhxG7QZN3t4NFU8zv4db3rxD1+uKpL5bYp/1C
	6Y+ZOpnsHXGWHuU0WpkArgc/g0t2N3Tlr4BioY86PioFNnDSdjiPqCIYRoB6tg7KE4UVGi
	P5x2V4FxC+PpD2S+F7PCrADzvlE3FP8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="nz6I/UeB";
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776112903; a=rsa-sha256;
	cv=none;
	b=vdo1VxI32E6FOzpLqXqo2VI/r6oRtXTJZ2c8xtKUmdt8nAebcG3Uzl/8o+NOxNM1Z9KuHI
	OpDMfVyS3seSdk7oL7HD9zgOTrs8HPNWLPjEtsIcdjuKgtDJ0E+aJLgOCKTOxqUD0OIeL/
	0KW8BJFHWxJ71Hh7ImR8KxU700KGd8o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5WByCkjiLUoqcmY9Xk0+CO+njRcv+yHwZgHE3y0xPWo=; b=nz6I/UeB31UCPopxIB3F0rbi86
	SqZnsUv69hzGeNzZ4PVCquLOIt1OlfD0/uVGqu3TlVUPaeXkWFJJUFJ6+mOLPQYezOkwng160E5bM
	3MBc8hfcIhvtd1sllANYdWigpW2WL+w6EsmqF6mw/+wW8lt6LpChOtI4JL96XzY6YmHylpgFsR+wK
	bY3PSA9jTLDaeu3OFopBo/uXEFQEKohH4bTbKMzJNvZp7YufeNQNu+m0fOj5WlHYyW+Ucy54AjiVA
	1n6dA/HSOBYDxHn0T5GfZteKVFKSYlK6d0YYNDCkz11UWxGdahEt967YMy3e9sqSkNzt/f/1qhWyF
	yLqFV3/w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCO6A-0000000EUrG-0RoH;
	Mon, 13 Apr 2026 20:41:34 +0000
Date: Mon, 13 Apr 2026 21:41:33 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 08/12] mm/huge_memory: remove folio split check
 for READ_ONLY_THP_FOR_FS
Message-ID: <ad1U_Z1b7hKlgnun@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-9-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192030.3275825-9-ziy@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 122491C0002
X-Stat-Signature: ety6zgd88spzbox7bqgudd6yf4oz1zmx
X-Rspamd-Server: rspam06
X-HE-Tag: 1776112902-32913
X-HE-Meta: U2FsdGVkX19Gi89xq/6/4hoUC3RVj8hvLqQgm0jDlWE8ew00cH23qWzLlYE7u2FXVLl2v222jRxFRcbLx1rIO9hzbDpzVZ35OuOCMSfnY+lTe5cmOD+fsFgW1CYuN9XBUceYefY/6vdzgDzw5WimN4rdsaDZrkBhAtCG9i5IB5QlPDRZBy/iK3NFa7X0KwIQ9FErlHc5K7m4IrxLc3B/9uCl0z9+6habMA+wa+nMkZ5xdwHu+17V0nJkn1hZrnYzH4cRT7If29DsK3sjIbtkbEaEhlserHYr5Jx0rGOD0ExKrYMyXOP2Z+0BDxMipHw2yXpKteJCeg17yOdCsXR6/si/9kw3Jp7x9tE8Yo0RrBnf40q8o/4HB+JC/5FP8NDRqbjlxNnEdEeqU0VFHVeYvwz9eeoZ2oKeh3xHwdHbbrT7qVqovKW2+80hQSAhUU3EdebvvN2rd04BQxNrnAeuVRkYlEA1KdxCNIVj90uoEjj/eCWqBxf+Ex8S47rJNI2H+QTRbHFitOhsF7FknqlwVNmBsZAO6xOVIVIk+XxREuUChMUjCEjHgC6Wp8weYMoHb00x/zxEhgTRNlUTxDhLn3otZ9GyS7wHj2uoRon+9VqsnKesX/Fp96fnlGfP9Fej8OoeirStMJcQlcTvdzU+lx3KOIq2RkCJHqznqEJe5TxSjHguRhxmEeLO6p1aXzeuMU5pKn4o4PjM5WC/PSaKwiZxv6ec1SD4+U7+9r1ttS3jxrvGD5jOMltpNIOj30eCPVTnju9AcXpPzlnpzuPgIXaQe/71K7s0kwCE0DTgXp8XCw7wq+MgTDmWMu71osdCEeww9sMWHm6qj/r0rcNJDs3YcR3auXVCqA4pHdjB7F5OnkeZHOrbaho/gUDR+95cLKXFL2GhFrRD+VT7+VP67qXrRUUghzLg1g4jf1lb9wBrTFHKFxY9QnUDxeQKaaTJsTZGaenItkCqRGbMtMI
 DB9v9/Zw
 TR26GVwL7+yIPP1t4FLT6k0a2T5mY0pWq7MvFfIwy5bJu5jvaiOdJq9uZPEudgpeT9yTMrvUU9nDYDBELPls/FGeVQN6Sd3wQVSLRISWcWSULdFHXGQgQMlmu1Av79Rtfub6bWQzXwefAlmDjZxRuWueCIL+oN4c5x4A1BNjnESqEv5IXW2Y/7EpPI0hzOITpbDFkWQrh2RTdmhnIk41SwC+Do2LgA0PB04tTXDOWSbxVPxYeqCJeqURqi41wiiCj9rTWY5pQSrJC52q2z6L3yGN5AXqs4NiCb8HAstwP3j1qZoA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 03:20:26PM -0400, Zi Yan wrote:
> +	/* order-1 is not supported for anonymous THP. */

It's also not supported for file folios, right?  Or do we just skip
adding order-1 file folios to the deferred split list?  Either way,
we need to correct _something_, whether it's the code or the comment.

> +	if (folio_test_anon(folio) && new_order == 1)
> +		return -EINVAL;

