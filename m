Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E152CD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 04:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843616B0005; Mon, 15 Jun 2026 00:14:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81AF76B008A; Mon, 15 Jun 2026 00:14:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7575C6B008C; Mon, 15 Jun 2026 00:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68D6F6B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 00:14:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30C10A0899
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:14:40 +0000 (UTC)
X-FDA: 84880830720.10.806386F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 58ED4140005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:14:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oDkAIBVh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781496878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgCkCmXiGO3X/69D59XUfRyMCNxPXgwbkBzjzSJHhss=;
	b=tRQ07D9jAIJXNamif64DKuouuOsadKh6z+btaVk62qtzKthBkYkS5e9l2caut2XMeFyN8b
	r/O1ysgjNf+Os5A8zh3NjjqKZRjS2ConjF0QQLLlW2FHiUxAPqC2I12O3Ro1a0FCz5Q60a
	8mqtkmlSrdPZXCLitLE3vzX528TTZ0E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oDkAIBVh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781496878;
	b=BhHNEIhUK/ZEC3byCVG5NflgovElJyh/jge/55gEjgUYAbypRtrpPLQKJWW63L/ng4xmap
	25+b/I0sTo6q5VQ0a25UqxpAEckbN03MYPvhx94mJBgbdQzk0BYKxCsggjT2yEzAXEJDUB
	MDUpG/ddMPzajQWVT2g9mplkURfLlXI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fgCkCmXiGO3X/69D59XUfRyMCNxPXgwbkBzjzSJHhss=; b=oDkAIBVhxPHLV90hgi0BEK2WnK
	VfZ/lj33/CxtPRjapZUxkhVmvSjLcmZW/zNzTk0b42rJ5+MgbFpmG04RmPIEtwx9sxb9zn7I/t5N1
	Drce1+7Ii5eEICCD4Jrn1TxyT5qM6MpPhmH9oycQ6fVJia1/rlZzJpVaAf6WdbrdB3hLoE3Ipo//Z
	L524WYFtPjWOpmvtwWiKGhGgGN/4N6o2T6u04cfLKA9fz2c1W7uN2K8TBPr9zOyti6s/oJuwlSn02
	2W4Z4dYaTgJVPFRPgz92MnEjtSm8G5t4pb+DMFr0tIV2Ohvfg9ZDc6jm+qb6ZrROKu3ByOIssEkOZ
	qHmC9lnw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wYyiZ-000000088wd-1ebt;
	Mon, 15 Jun 2026 04:14:35 +0000
Date: Mon, 15 Jun 2026 05:14:35 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: Re: [PATCH] percpu_ref: Fix documentation of maximum value
Message-ID: <ai98K0r4J_wlsa5B@casper.infradead.org>
References: <20241211204017.184512-1-willy@infradead.org>
 <Z1n7BH4YBe2z6mm3@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1n7BH4YBe2z6mm3@slm.duckdns.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: fpa5t34wk5g711cnajxom9ao8kh8z8g7
X-Rspamd-Queue-Id: 58ED4140005
X-HE-Tag: 1781496877-511090
X-HE-Meta: U2FsdGVkX18FnWrxtPvA14ZrYnERgnnXBUM49c80hTwhH0xfG8vPZ4b3cNzPuILHyRfrpm0KMwqQaWgv1oR0REkEL5giYlrIaRj5U9oWllaxIKYfBK07OCZqs0bhHFVYC1MT0eXd5kxU16vC59y3Z7e+m+FHU/nLOdjfgdfByxWaNKyxL4X5GluMTOPmEpHURDflt/KrxE2VMOMCWUyDi9RKFZ2A+sMa/EOj98VRLnj7YkyviTREyXlgTubN7FAUCGtaWs3nuNZM81+zM5j+38XwJTr7tKHITNzzkJv1pbsS3skf8eC8LADH/LL9Ty/pFh9e+9jddC1f4SFIK7c6fEQ2P+iRS9d7zfYYW88Cdtx5LQTi9zWRLQdgPUCXeelFMu5pz8s/D7h5vJXnQQ5gDKofVOAH/sWG6uyoRu0i8cDODzyAoUd/jsyD2/mniaoUsT9kS3a4/MhRW9X0SdhulSJcUgKgTP+ohM9Ck+3vplmN5P4wRw7DrUJh+3ihg1IQW0aZAcZStyTxicuy1Tb51INvdHi10XWsAiWtzoOnAjdJYqhFjBu/IcSBqlumqtfA601Lyx9DgkagBu6lN3QU6hqMZcTOHpMHh3x2lpZ6vBaGMNH1ByAJOSijXoqiQ/Q8dgC89qk6l4xmqupUWZFi7C6kr8kWEhb1H5x1m5DqY+pXrmCGnCAzfLjinErrU+pyZw8iCC0r13HKx0/MBgnXVd7xSl2od6Ab91aGGtU58OrMXKMn2LqzzOfeIqBMvL40IuikAlwQ8A0nD7YNXJlfLcJGn4mYtH60ujHSUknTqFgHaLv0KQbw4LrhQNbXZtBkMCK0km/Kwg5tUahjZfA9C4W9wjy2qioOOwaMDCXz9QowWcRpFygQTGEyjF8ZrSDZRQ4F7d6FN4Q78MI9q8YjOgkcceY6mojAztcSP4jlS0DglEDfUph+zb5IceNKEfL17OZCfQ2AQwlWb0FD2o/
 4ZUWQbJw
 NSRduoKO6jYRmW8xrINPRqBUJJ/DEzAsL5EG61F9vWmctRJdDpyfm+ljDHRXbXPKmkxKKyI/DpYxWzFNqJVIyZtMtW+QwkedCANxDj8ZvZCCSRRxsLlGjT8Ah2I6sdpM/I8V3ox73Skux7BDOxIy8kbpK6Ty2jg9AhSLDSJmjGbWU1py7dylNbNr0E+ceJkkoyj9q11vsTCbn6bSZqoOVhECIj2ngD39fSHSxwIzMA3UmlYY0RhESlBOKGQnZnf4MxOGYC6Y7ffSgJfPtIUM2mX++mKZC9GNKtL47EkKP9r8shL32HhQs1P/iTyzvW8Aocp3Ddx0dKtvfLiokhdRgMfTPZB1taSs8w0b57JVJt8GTpLSv1t4Ib+TrTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 11, 2024 at 10:50:12AM -1000, Tejun Heo wrote:
> On Wed, Dec 11, 2024 at 08:40:14PM +0000, Matthew Wilcox (Oracle) wrote:
> > Tejun changd percpu_ref to use long instead of int back in 2014 but missed
> > updating this bit of the documentation.  Also add the documentation to
> > the htmldocs.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> Woof, ten years already.
> 
> Acked-by: Tejun Heo <tj@kernel.org>

Looks like this patch fell through the cracks (just tidying up an old
git tree and noticed this commit wasn't upstream yet)

Andrew, can you pick it up?

