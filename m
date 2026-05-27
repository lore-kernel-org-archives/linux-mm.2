Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7306FCD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B222D6B0005; Tue, 26 May 2026 23:31:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2DB6B008A; Tue, 26 May 2026 23:31:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8396B008C; Tue, 26 May 2026 23:31:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 906606B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:31:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 373338EFF9
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:31:02 +0000 (UTC)
X-FDA: 84811773564.30.1574E9E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 44C12140009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:31:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SzjMDLXV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779852660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FEJmjXL2EjatPDpj2uMZTIF3mYzVfl1EpI149sPwX1s=;
	b=UZJ7b9Ia9vgWyxVL9yiwz6wkS/s2uexpvNqmXaaVA9yOEF2hagi3+3PSGIwVrsiaOalCuY
	XoYCk42SsfQIreCjwBXbHi9C8vV7sgz3taIOeKukOjB4oOdT6ofdgQU6Setlm6AaWSOzg7
	m9W/RRkXHjDqGoUHGsnf3dRsMMo3Jtk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SzjMDLXV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779852660; a=rsa-sha256;
	cv=none;
	b=Vm+J6p/LTC5m23/rh+rpJlhHLzsuILxCwQWgLtvjiWEts0R1Xf5RmKPHetN4boHPzJmddP
	u6xY6p0UQG8CPL5knjEOgw6p8k7Q3JMWVUfS4P1IjmQXWhOxnuemVQ36x2xpZUKnbR0kem
	6V7gK3zjtnH/3RpNUd1kyHAT5U0q/P0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FEJmjXL2EjatPDpj2uMZTIF3mYzVfl1EpI149sPwX1s=; b=SzjMDLXVYmez33PWlioTW3LcSA
	VYfm8lb0dxWyTtKUEXzvQO58VzLd8uZ4A570kIRTn/C5VAfHG5uTI+QTyZlW3WFEQaocZc+sJe+6w
	Dn2IVlbhEmFmRE4Q8gzB4Ig7t0zyq9SP1CWxblCmLyGSyJ6LdmicLI3DvHwBbc7U1+vL453bCEcml
	GazXwnM826IKjic6pIVVwwD0LZ43zntdbgpySyA+4oyJ+v4d36kiZLysUKYHAu/d4LL1hgzaGEC44
	JXSWfpTjZKZLn53sxEolzqYvOlZCFwNi2cN+dKIPQv0K/ZWMffc3WLR+uBHJ/w9F0+cGeGUBlOttu
	i24CpnPQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS4ys-00000001quo-0A9A;
	Wed, 27 May 2026 03:30:54 +0000
Date: Wed, 27 May 2026 04:30:53 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahZlbQPzTUecMKGU@casper.infradead.org>
References: <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
 <ahYWKH9-ybDlZuJd@google.com>
 <psj3kr2gcze2yll5xdbvyyzxwcwhds5gh55poobpkfxrkpbgr7@ljdindismzd4>
 <ahZaScMpx19ZLQi4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahZaScMpx19ZLQi4@google.com>
X-Stat-Signature: tz79b9jx7g34t1burrd7zu5wyyykiypb
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 44C12140009
X-Rspam-User: 
X-HE-Tag: 1779852660-511211
X-HE-Meta: U2FsdGVkX19SUokB7zVCtFUG7CbTufMWXDJ1qtW/zuCCcvwpOuNIM18ZmuX8yYIbD/3fkMg7y0dT/W9CUStCjI3aPWesljDDPZN66vuPW47n2oIswCZ+eUN0IvraEQFiswSsT8DcRRBir+ZFFuuarcqOhqrikBnXerQSpSHmA1SMTi3hlH5Wtwv6FkHyA0T8fptDT/zxUwT5Yl/nvTUNGZUMGnFupZa4+8outiw+gVi3KHDZmy0YUKYX2O6NrFLL4uJ/oyKZ7yzj22lTp98kO35hCtZ/bfc8TMqAW4diDv82MUMtNuf0zlsAf3y9mWRHZ+36tkzgRMg0Jp8AufdBAsx7353OMz14nEYSXQ6++sIrww0yxBXAtX7N1c/sItURS5EDxx3XglRXob1vJRZIvN5d6V8djNRsFGn5B/kLuoUhR3spWAXJv79P2aTCrbCRb9xNYWuzM5nlkr6kUSdbMkiJihjruazX2D7c+LHBJ8ZA7boA5zlJgF323xkskQUlMD+x5X/NCgfiXyzr7xbJeqm3feuqM0DFMWwBynf7ms1oRWDhFAaMzpw7Z7tXEkpIrgqWj2ou1xrKql7mBeRp+Hm/elgo9+j5EPFca+5HHZqQPHy4rMF7r4+T5NMwJZsNdPvtLTZWIz1Qg/cU7H8RSzhlFrWvS7mGaV43V7HUGO6ZGiFPUSirHcmF1NMp0TMrBenJo/NkHIjd9mcUIocxSA4v5y0paLn+qU4/afBM0cKUbmoMP/2UFTXudk1zLJsDpyl09YXGkn9fe0908xZRBsyLn7BT+1LnvAUuBRMdSLCTtq5FOclOIEAtJYG/hYt4/SAzLvBqvc1KJ8zYXqDK9UMUb7tVwcyUJl8ePXgoKq+/6N7XF02cdRWgOZ6TN7AwLVzuoaj+M/s6PRTWlrlsQHfXI2vxSR0/3HY5SqRpqUzEaeDB6O6HRZykjRTIFYVWa5H53CiR+UYamt6mvnv
 AaCvsIs1
 5ry6H5XPmoj5lSOhGWww4oI0oSGMrbDyD27HSmy9HMOtx5ovGEe57OgXRiZNlLo34jyyLHvt1DeXfpphAE8xcU+NbjuaxNn9u4semyBCJspRq9s4pVs2aG1JwoPovYuCTJIMtUzM3hPW78IFXk4ABCQGP7H4JxH1HGmANW1arIqzjXejqICPft4SKhX5Nd+SyLlcuKo6AZUcXVIE8s8KtrvKbueP2F0S5oq9jiLnqsKE5oC62k6cEnOAdVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 02:43:21AM +0000, Jaegeuk Kim wrote:
> Thanks for the context. To clarify a piece I missed earlier: the model pages
> are also utilized for inference. Our data shows that larger chunks yield
> higher inference speeds. Consequently, I required high-order pages to optimize
> both read throughput and inference latency. I will halt my current efforts
> and wait for alternative suggestions.

I think your efforts would be best directed towards general support for
large folios in f2fs.  There's still 40+ places in f2fs that use a
struct page, and converting them all to folios would be a great help.

