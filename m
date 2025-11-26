Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8940DD10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 15:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7206B0012; Wed, 26 Nov 2025 10:05:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7EF6B0024; Wed, 26 Nov 2025 10:05:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDE46B0026; Wed, 26 Nov 2025 10:05:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7ED86B0012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:05:48 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E050502CC
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:05:48 +0000 (UTC)
X-FDA: 84153082776.23.91F972B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 896E94001F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:05:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ELszKdnU;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764169546; a=rsa-sha256;
	cv=none;
	b=41jsMP3165nHv1BwmlwqpGD1gRgJQWXWtHz3x3JTsX9AR1QMovK8nHoj6JCIXeswc0/b9O
	iIB8FuAkR2m5I/aIrPVn+5FK8b4YuceH2fQbbn3KRRYTMW2VvBULX8BmMkTyX2V/A9hUsd
	Cybmz88L805XQ+m+LbXVsSj7nNUEdQM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ELszKdnU;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764169546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GX2MaeAf28n+QyfNQ2FOuk5hd1rfxxFPSrIIVNEOh8=;
	b=zV9WXU8nR0nUkRj3/NY9+3BXQO+8bVxG5fJAwioqZZ/6I2iNfmXr8Kifn8qXTy6NUwGf8D
	B4HJ1AIGRP0iXwYdCxwDHqr2amMcfoXYXDIJxPWXX1tI2UxjeBijsfioczbpf78uPWrcfK
	kl7X/9vaZNvtNCIQYxzP1uVSnsr2170=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0GX2MaeAf28n+QyfNQ2FOuk5hd1rfxxFPSrIIVNEOh8=; b=ELszKdnUW5p0MC8627XXqonjgb
	wgr79aZKGnWgcRI2GNre3BH6NFEi0aaSJT3Kmpso/s2VLNoEvTzfXcImwmvsvIWAFxZRk++YMOM/s
	WW/B68ZFDX3vwp3fTwbGzAd84VEWzDEZtcqchm9smsYsIIRShggclf4/GV+BDXl+92pSsO789eRaj
	lDTvRL9X1aRL8zcXWBQzaXqZaXzDSFULBHnUV1X64Y9B8PLDLv7J0XrTnvAMwQCrv7lR2PQG62rY2
	d5iLsdX+WEz7M1Ei6JbL7OJL71mk4C3BHuXEeOj/Ifoa+17ZmkkmmIpRc/xYcxooBtB420oCuqfd/
	ZMac3QOg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOH5U-0000000AHBd-3hVy;
	Wed, 26 Nov 2025 15:05:44 +0000
Date: Wed, 26 Nov 2025 15:05:44 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
Message-ID: <aScXSEY7v7_fcEZF@casper.infradead.org>
References: <20251126034404.2264317-1-willy@infradead.org>
 <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
 <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 896E94001F
X-Stat-Signature: or4fswnc5nuhktn577dcq8b5pzhzcsto
X-Rspam-User: 
X-HE-Tag: 1764169546-931949
X-HE-Meta: U2FsdGVkX19m4lQzCuF3iXcw8uAGrOzhB7G+qjGjD9pM0ELrhYEJGEjKek2aR8gRcPRZmtXBDiJ6jJ8PujWmO+nC47fTpkzXVfIdYhGqVT1qezKbJMdlJA5NaVkVUvwqw8fGVvXVoj/DCCRNhQN7yRvAlZm2wff0arLoAALEEi91wQAjnEaEm6uieo1KO72/9wTNMYQhGwW0PXIA4P3Z1Nyvy1KIgdvfPJzrveLJHilOoRcD/PrHeExsPUP5UyQ20w0pDw+0WlxYIuo6+tCgj+bdvQdowVWWN4WOK9C8exQPx0X40mtE9MKMaCSOfdjkrrofza+y9OGm9LyTX65NCzEAlal3/btdWuUA0/glhxig44xN6Pbo73uJ8PIL8A953Lwc6TiNdYrKuKYY3XXBpoz8yBOoL6oBCP3D9JLpeRGyXlMMdecz1RdHgYyFTEdYzj1fFiRKXXo+34bl/lg24XWO+YHh31vowiPxjWB367hSx0/LuEX7D7AZliemhYMF+ya/zRBvYQKfc2J0FPmuDIs7+RtFqUNA6IbzodLVChb+LQ9I8nU6AZjBtbiDnFGT1f1uyCHx+0/L5Q/PC9+17i+rTAsO5VMS/us9EkKR4XzltbLtNgiIOtDr13tlqSZK80sg3eGCDkWhNfqLQLz7VHrcObj4Ye6kTOfGWqupytuM8XiWzl3OiAojiB9kOl2TM325o7y3jrdROD3mL5aEQw88dNX3GpYYBmzHy3BBbs4EhhllDQogurqrMdfSkQWCdYCpCRho0yjk2K3xY09NeFv8060YHpHAOR44K7wpYDFmsBNlvS2/b1AGVU2rpT4ex8SEfnZe4kWfT0YScc7PxqWohRk1x3leowpw8zbjKFdq1UGg2sBDnNf5lY/2f4MWwj2Zg9q9mMnJytMBxvUdwMV8cK7FGKP8UfnduOHo119GXfqA2M+lFLxBvVm4W+dMWtFiyl/1dLjBDl5vYNG
 BSqWbb6L
 EbTYxrQBWoLT5Oy9lL1R6YTpGdagmst3E1BaICtZeNAteMKjHTa0JUtdFEG57MXA+t/6UVM/E0JeR5/POPGeLdOeYixtNPkiV/w2vA5zB4mV8D4h6/421RLzRiQA879faz7vv2LL12QCTe7TE+chL1b2OuuEcWZxbfpQxu8o+U9L42Z2G0eJN0cCc9SOlaaUuUrWL4FCD94EWWjJLJwN+qhS4PUyt6Sr9S8dEmx3aku139u5Pa/6L/EZ+XOmPk6VnoLUie0y7o2QaEbvr8opkRMkpeGmWZ5ol3UMw8bwfrGdkBCMpifmfLukIlx7dDe+oeGqBoXPr+0sQSwCDLPxCqsTlHRz7A/H6sxxIPs/cupf4WhflNxP0Dx/ShzfbXHaVyl1qGDzstGL4XhY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 03:36:46PM +0100, Vlastimil Babka wrote:
> On 11/26/25 5:28 AM, Suren Baghdasaryan wrote:
> >> Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this bug.
> > 
> > Doh! This is embarassing...
> 
> Hand-rolled synchronization primitives are wonderful, aren't they?

That's why I liked the original approach of just using rwsems.  I
mst admit to having not paid attention to this recently so I don't
know what motivated the change.

> > Wait, why do we consider this as a successful acquisition? The
> > vm_refcnt is 0, so this is similar situation to an earlier:
> > 
> > if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> >         return 0;
> 
> But this means "vma is not attached" not "we failed to lock it".
> 
> > IOW, the vma is not referenced, so we failed to lock it. I think the
> > fix should be:
> > 
> >         if (err) {
> > +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> > +                       /* Oh cobblers.  While we got a fatal signal, we
> > +                        * raced with the last user.  VMA is not referenced,
> > +                        * fail to lock it.
> > +                        */
> > +                       err = 0;
> 
> Returning 0 in this situation therefore wouldn't be correct.
> 
> AFAIU since we started with attached vma above, it's not possible that
> the refcount_sub_and_test here will drop the refcnt to zero. We could
> just WARN_ON_ONCE() on the result (in a way to make also the
> __must_check happy) and then can return err below.

But how do we know that we started with an attached VMA?  Maybe the VMA
was in the process of being detached and still has readers?


