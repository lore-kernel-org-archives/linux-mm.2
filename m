Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB95DE8784C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 16:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA6286B00C6; Tue,  3 Feb 2026 11:59:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55446B00C7; Tue,  3 Feb 2026 11:59:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53AE6B00C8; Tue,  3 Feb 2026 11:59:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B02AD6B00C6
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:59:08 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D85FD160583
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:59:07 +0000 (UTC)
X-FDA: 84403755534.20.5816B78
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id B66B3180006
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:59:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Iubxm0LG;
	spf=none (imf06.hostedemail.com: domain of BATV+86a917d310add611ad46+8199+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+86a917d310add611ad46+8199+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770137946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0aHSbI6iDavO4xs9+kYxiUbZ+ujh9oTdr7K2zYuvZQ=;
	b=qIq4tRDRp5pMgJdNmDQNBJggh+LQ5uIqjt+7UW0fj0eKb/8kntxuMkf0zHqyn/s5ZYQN6j
	DVDtjboBQlm5TftXZcO18wdLVsZzONW69VaIJH13JBPb/oi7emmmd1VO3EgkkijVVw/HHw
	TYY9IEn1+2l+zll2Z3d46trE+qjsJ+c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Iubxm0LG;
	spf=none (imf06.hostedemail.com: domain of BATV+86a917d310add611ad46+8199+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+86a917d310add611ad46+8199+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770137946; a=rsa-sha256;
	cv=none;
	b=xSc5BFZZjdzpdCPIPbsXrl/DlRfcPQj/4/GjYOi67xFL8Zm1TiAVS7+vtcAQpdHsRQwEEJ
	Rh64MQbwWpGrjcwwM7nLJjzj5X3wQS5mZMgo9nkJ5rbTj9J7rYWUJnSSYbFGHNkMOSGrnD
	5wkWpJVfAeqIgzp5dx2kkYigBm1CYIo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W0aHSbI6iDavO4xs9+kYxiUbZ+ujh9oTdr7K2zYuvZQ=; b=Iubxm0LGYBl2K95ObztodfZ3QK
	Ql6Q/Lk4xxacizw+FwPFXFwGcGXoEaPeUfWB/kH5Mz49tv189YHCJji44KldFSQ/pwEBiyWj8uyK9
	GPmqPtVRAOjjWIYLaKzuYfmy48jucIa6q6AQl4XiRJL4ZLvQ7qlt/vN5L/SJLaX3axhE2F9fcDA8y
	xDtR5jlqvfEfOAZ8o3Gua7QP3HLcXU98j+6diiBVsT054Ix6xbOj/42incZA3afUGIxZMgLNYFr95
	irwN1V0b/F1JNDeHgnspkB3pDAbPwyHwYlnkjTy+O45yiyGN24FNJ1fRtbN8v9ocW251zh7Hq+Zci
	BEW0Cj7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vnJjy-0000000700q-2t8Y;
	Tue, 03 Feb 2026 16:59:02 +0000
Date: Tue, 3 Feb 2026 08:59:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Harry Yoo <harry.yoo@oracle.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	=?utf-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>,
	syzkaller@googlegroups.com, akpm@linux-foundation.org,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [Kernel Bug] WARNING in mempool_alloc_noprof
Message-ID: <aYIpVq-jTKyTQE8G@infradead.org>
References: <CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com>
 <aYBiza9L1hmhmXbb@hyeyoo>
 <fwutwpejyptpo6gqv75zanqciv3fmxvillomwcjvtz4auebbc2@vazub2ct7pa2>
 <aYHFZ5OxfL4j-_ze@hyeyoo>
 <aYIh1wPm7BrId9dk@infradead.org>
 <6f5881df-0e0b-4278-808b-7c0cffa12a30@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f5881df-0e0b-4278-808b-7c0cffa12a30@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B66B3180006
X-Stat-Signature: q7d5jwqr7fns6or71bopuam5dtaggqmx
X-Rspam-User: 
X-HE-Tag: 1770137945-651850
X-HE-Meta: U2FsdGVkX19yQJAoBaSRl+1/aEnK9NUQl88GDaM6Z/rKEYuAbFJEpRgWqZL88Tc5TZ2IB4sup6aA52pLV7ocQP88Xamvf17AEw5NfkNimQ6+B5J2tTvpppXLmxIAzRvuFHQ6C85MfrdDpqWBVj9Zh28tGTAGI0GbCUVnTGefJyUdgDUysEIuYLHU452gNRoU3eyYN+7Y28Ey53AIBYRk2+CqXr9l+McZ4DOa9fNMTUFtIbFI7j7BAqi60IrXOzx4bgqJArSXqslFra4wl+Pjlib6fHNLqU6T177PqU2ZPIJfHYirnId7q27QhS78Ym6NR5OMvgZmw5k83FnSO5VpWy5EZjY86d67zwNkNNgDBGHS7p1COk8URjl8giFKc0Dnd8K6/48uwxA+CmZO3XgeHBYcBk3vlY3f2S8u3r5F4JJ8KQw86SqNwx+mkmkWs/WFrrIOaYRQHLAxXAXcwNZGjxfSkikictndHeRRFFjNsHnFPzjcG361zBaCMmjaTNZbl0XVK4EDARGE3ttQwrLT9MX6GxQGXvoeXDDGmXjB4d/LZdYkaBuD9B2IH4QiKUPifULkei0Kt76l/rfi5jRXsUvEn0BH7AEAZnapw3TUfIHl4Vh8xZYeOjWMpqPsvtm5LrDiO5XfgnF2CfnZZcgtqqJ7d9ekfJvpX5L/uISk41dRe45OHdu90zITtkGThlqj+1pGDJ8nYDMVzTFHvx82QUrbzw3YwzGLwPwtmlwHTMEbApiPzCJAbCLdBh+4o/Tm8OeKWuwxcxBXpAmvd6cyr8+sbkGpnvAx/9AtJSA5D85o+8wTvPWmj4uGBzOBsyKc3xvtujfUHMue38L6jFRHS2tBN3YrjSU3AFc8xAPyS3lOXCyKCoczCAO8Ju/0kLeQl3KO859mjethRmTgo3nkYMoLOBS3NNBVkpT21SfPkdsjpZ34IuJmRTVLPvK+IfQjfdMTR/KcbnJ3hWqJjhk
 DA+z2LI8
 EBd/POPQ+Yhwt8LmDe/Ty6nsON8j3Lob+/JYY/2fmF9qoaIXcWaL165gHhCldv7fNNP0DuQTxa76dYQTsKdtlC+04HRATvEgfqbni5W+9inwPJut4ame9JzFygmelix1iJlFQwx/qnMrLoh2gavBNGaRHEtbioZjpwBQokkSjJd+AUxb2yhwEx8JrJstxVKwEjf1GshYrxliEK0UVZmkAIDpFdd51jZCQIZkLEdaqxxSYfVJLx5tbEXbyvXvQAN6QY9tzi9Lc8YD3ksQ/LebiRXzxY5+qtgfqzSvoMzXjUSuYAVwOY3XbTRwMqmCH7ypW3bBDSFmjdJRVPuCn0lsM6TsB/70Fzf+6nAfR1XhlYtrlqDdKHLYOHYj0KkJRkniF9kaH/SYui8j70U6sdflSUnn0bkdsBvKY2VtX7MRUe3nwB4dXWqXcu3VYUPExCR+E01nhWocQvcVe3EsbyGpE1cKgzVyf8LgeZQVMh3DCRuDl4aTdQo55ECT3DW6haZu9R3p53wZEIbLKg8+ANSRx5cqp6Vle54ACR4Zf0XjYF72/BOM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 05:55:27PM +0100, Vlastimil Babka wrote:
> On 2/3/26 17:27, Christoph Hellwig wrote:
> > On Tue, Feb 03, 2026 at 06:52:39PM +0900, Harry Yoo wrote:
> >> Maybe the changelog could be rephrased a bit,
> >> but overall LGTM, thanks!
> > 
> > 
> > No, that does not make sense.  If mempool is used with __GFP_RECLAIM in
> > the flags it won't fail, and if it isn't, GFP_NOFAIL can't work.
> 
> So that means as long as there's __GFP_RECLAIM, __GFP_NOFAIL isn't wrong,
> just redundant.

Given how picky the rest of the mm is about __GFP_NOFAIL, silently
accepting it where it has no (or a weird and unexpected) effect
seems like a disservice to the users.

