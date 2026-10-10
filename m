Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF96CA9EC1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 20:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0AB06B0088; Sat, 10 Oct 2026 16:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBAF96B008A; Sat, 10 Oct 2026 16:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0D26B008C; Sat, 10 Oct 2026 16:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 969346B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:51:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FDB41C3DBC
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 20:51:21 +0000 (UTC)
X-FDA: 85307911962.26.FB7AF34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4F7BC180002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 20:51:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UCHDDdub;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791665479;
	b=meZAT/6TKvWMjNWEoFinDRc5kXgLvaunyLxiyBItXnmaoW9GRvSlxDBudbZOFyBwbQVlsL
	lkqR/zZhiZqWZO73yV7CWPRpGJ+JlV2UkM2PRNI0yDXCgkAJev1ZnIA3JJsGubndb19R1g
	C+PZFXEu1SR+0+lK6DZdPypqSV+L0MU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UCHDDdub;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791665479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUFEw/UvQszY8V/MSvsl3qes7TlA12pcLfGdknNAePo=;
	b=6usRgnARIPjDZJEyujTqOoWjWNmUndb6JVCuTBSf6zcKrUTqEc9q3dgf/jVauv0adSlpy0
	IAzsVNFnWb8JvslvDKeOxVPHoCVQny7ocyfRw/Q7r5nCJwzoR7/TEX00VKHHqGYE05Yvou
	SLXDUCQ6xVaw74V72mq9R2AV5Qqd058=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 786D04173B;
	Sat, 10 Oct 2026 20:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093061F000FF;
	Sat, 10 Oct 2026 20:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791665477;
	bh=NUFEw/UvQszY8V/MSvsl3qes7TlA12pcLfGdknNAePo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UCHDDduboxO+fyA8mS2uiVB9eEogTIMRs9IW5Aq2BjUCxHSf6BtyxLzks7JuwqszS
	 GOgQwxtPFF+h+r/MTxGa0wiI2oR3R7t5v5nUgaEm7MLdpVfD5WoSqTwH/WNVcdNABp
	 vk7eCigaFDA7GdnNLfwrzHUqfCR/XawWOgHZ/YnM=
Date: Sat, 10 Oct 2026 13:51:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: albin_yang@163.com, liam@infradead.org, ljs@kernel.org,
 david@kernel.org, vbabka@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, albinwyang@tencent.com
Subject: Re: [PATCH] mm/madvise: add cond_resched() in THP branch of
 madvise_cold_or_pageout_pte_range()
Message-Id: <20261010135116.7d2a4f3b1a25e54fe4617fb6@linux-foundation.org>
In-Reply-To: <aspKmWIrOzNjiP-t@gourry-fedora-PF4VCD3F>
References: <20261010024042.4070048-1-albin_yang@163.com>
	<aspKmWIrOzNjiP-t@gourry-fedora-PF4VCD3F>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F7BC180002
X-Rspam-User: 
X-Stat-Signature: p3ehutoyu9jdps9fp34txs6t3w5p57az
X-HE-Tag: 1791665479-464820
X-HE-Meta: U2FsdGVkX1+rcggGjEDrVW/R4E26FeACsDxdgjvqrYG5HoYOFcieryVxAX9NCKVfNS+ctQlHu/+x69dl8IvribAUN9G2wNs5eobUYDT5Rzn48IUuWLSQW0a9u9Y3aesBknsky9JaPLHp5b8GEkh0CJxRRjj3dyjpMFSH/Wi92i3uYCWPcZLhHcuNz/b6ALIR0SYYkzpCm26c3JCaq8+jo01nccqnTcqq8UzraTJN1zVoZPgxvFIohJRvsKs2KHtQfWQz72JW/n44H7rElPBxrKOd7ESTbaaDmX5zmEhSMzFdg7++F3yJiR6KXAI7KnthaDTl/K2sBEzDrygzTVMm1NP4p5jIpl0431dUtd10PIbjah2NURJ6qUXZFoNwycFFlACFwpM73Mex0/Gwfkp5rR++h116zFA0qIXcTMLXUEG6Lgmr6Hh6bMSb5PQLLk+EAYP8ErbTvUMd5uecKFiPX8q+BLNjjWui4GRFnIVaLF7/CJbfaUCRkqJPRDnxojPu7XFdSKL0fjaTahJIUl5M0FvjAYiLEQEYi2DnEhmlfStueTxg4VtM6hH1amKpXJwJftWpyZTdh9bpLDM90fz54ZRr/3rYehpwgcnAz4Ta3e9gvd30nYyMYwFRardlaxoAajtXfSOXnpg4jvH4OMMnqZEzidsqbqw97mWlfj0iOv2WivsV0uvPjhX0Bwdtq9kynUu0+CnYtBlpZ5q6fFDD5Xw6fNOH1FGWVgF5UqV63kekm7g4XHUcdm7VKS9cbb16/5jWK1RGSEwSmYA08tNV54oSZMWNz7K8XnbnzEpW+nLsvpfQrOoYtLsKL/usrICahsp6WZF33EVsqwqLW7eqpR/aDiIOj6e/iNDRoX/2I96ZqTBsdoKfYb2IVgXBP3uFmsgaQd6gBBqC4et1e9myciDjY4DCvaTipuVGRxjK3coY/1JP+BZOaSQOwl2NHJx4x7xbMqHwdPUszYaBUZh
 aexkm0S6
 5tgdjGYDLoGgTBZLaguKVdELI6z5TTu7JLC92o9DO8rzaW3N3l3QUP4XT8SjTT//OWN9JfKDg90CjpwKqmL85B1lafRazT8lIiO005bHQ8it91dU2Gb8rdOai+UKRfaWKUglvX+I7m/+dCNTyRGxrRCHrjqB7bUfhRNWCr6jzmHvzLSOhFDsGKUueQYa3AY4DoBmAVQOnoacp/EfpvOe4U5iuv4nkHEO5mJ4IskPgVmJChwsfnkgDXWffrE8kWLj11jA34cgR6dYqMk22X5jm2yLklFSqUca0qFyqVWWjHdvdHkfLTedZ5JRxS3ipupDF0uvR6NtNLGs1lPEH/rwzOSW++v8JVXWLvGWKO+kHn6f4JE/pTlAQDYUyAu1jaNuLBMpnhN4XGclWV1Sytr+L8qs4gQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Oct 2026 10:26:33 -0400 Gregory Price <gourry@gourry.net> wrote:

> > Signed-off-by: Wei Yang <albinwyang@tencent.com>
> > ---
> >  mm/madvise.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index eeee82cf2b3f..0755e6d99757 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -450,6 +450,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
> >  		spin_unlock(ptl);
> >  		if (pageout)
> >  			reclaim_pages(&folio_list);
> > +		cond_resched();
> >  		return 0;
> >  	}
> > 
> 
> This same improvement came naturally from refactoring the entire
> function into a proper pagewalk structure:
> 
> https://lore.kernel.org/linux-mm/20260922235830.2350770-10-gourry@gourry.net/

I'm thinking

Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")

Sep 25 2019.  So 5.x and 6.x kernels want this.  Current kernels
actually don't need this because PREEMPT_NONE has virtually
disappeared.  But 99%(?) of machines run 5.x and 6.x.

I'll go with Wei's simple one-liner for backportability & safety. 
Let's look at broader changes in future -rc cycles.


