Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 269FFC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 19:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEF9B6B0095; Mon, 27 Jul 2026 15:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0C26B0096; Mon, 27 Jul 2026 15:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A3B6B0098; Mon, 27 Jul 2026 15:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7BB46B0095
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:29:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16D1016019F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:29:58 +0000 (UTC)
X-FDA: 85035546876.01.DBB4AA9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id F0BB512000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:29:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dECcdZ3E;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785180596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXQQvCKPFegovPWBYsHPfyk2YJzL2wBgSj2tapMk4TQ=;
	b=opCoxxlTHKA+VAT3TslM8bbqh6njGj0SKKZT90KLMB9MmlvgWTv1rrnpj4zbP4rGxFrtHD
	XXfVXk73Qt7AH5MZwMLHpKecqmhihqLhPIAjpewssl6Unlhc+kzuJTJEQya8H51cOFxdR9
	XGmJ3EHpJHKu1DyTrERqSOEO5OOBGaM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785180596;
	b=xsHoHqmC9lYTOboKG0M8DuYP8Rd5ffOGFtiIVYf9wm4LQ3gc/cspel2cOQsRsWjFrr2Rvh
	xSTOb3UoNjkh3hQfInrUns6SPpQamveZWkHQ2+lpllEUfiQAH8Y7mgohRF343jahQKW2Re
	iTnNhzGWcNr+zl9AGnXtOCOpbb2WLSM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dECcdZ3E;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RXQQvCKPFegovPWBYsHPfyk2YJzL2wBgSj2tapMk4TQ=; b=dECcdZ3EiKFQUVB+L02fve8Jau
	IQlzRYmIde1dgB6atfX9k14pjnwP178ZV7VfKeOqJx4BitXMpKa3gsQxyh8bAI9yoes2n5AqcCW85
	QvR8kVfSZ5awT6mWidhI+atOY0dtBHqRXmQ4HxbVrxv0cR4FKfNwfmjpkvY16Fa+s37FKIxKCfE7g
	/vHloSPg0Xd2qL52vVYVUOwfwq/xEq/60PMXAz7+DAFyYSAoow46lmxqWka09bElkSddSzPAgZKZc
	FI6Zun/sE7d9MOKYhc0IyAvap2xLqdxLfe/yN5mxSn5EVlAzoufOA4mBIzrD5ymEXiKzB8JQeaTFF
	V467TZ/w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woR1N-0000000BJnR-1515;
	Mon, 27 Jul 2026 19:29:53 +0000
Date: Mon, 27 Jul 2026 20:29:53 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v6 06/12] mm: Remove locking mf_mutex in
 is_raw_hwpoison_page_in_hugepage()
Message-ID: <amexseZ43DyZjFoE@casper.infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
 <20260727181310.2671972-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727181310.2671972-7-willy@infradead.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F0BB512000A
X-Stat-Signature: pntnohfn1kb8bm3t3d9qfrcp3sycusee
X-Rspam-User: 
X-HE-Tag: 1785180595-129019
X-HE-Meta: U2FsdGVkX1/f+KbwojBZ9M1EhYy16EHErMpYTT7GGKFNDJofYKkDSebmWkcUG7XTF36XvIFdIoCVQagNxS1G4ubhOUaqaDY1kLGT8CcOshSNojmjT8bouq8jDPXyyjVfI0wva1RMfo3XzxP64/g9Vy9fWN4CHoU0DnHxhBSY2vG9PKeElFIkzBR95T8d2Iwzvw4+Cwy/4g7vfS4D+7vTted5yVkkqGNFmgDSykGCNz/6K1WueN2x/KfxE3ie+fLy47hzPsvJPZRRVMdCzDw+UYVJ9s5DKc9tANnOd8F6tVbahDmDUztEZvhDt0ibuOSxszfWLQQaDgUBA7fdZvZtv95tUMdEWsn+qVTTaqr7Rt4rvwpoYLtwko37zBlXioDNG5Nqu8r4VDFgWpnq361S0UFMPHIcCOly3A2AkeURLhwOoRG44X5Ltsadu7+NmQ6MVIskasuCLe8s9pfgFKW0PG0KanhmD25pbKkh4cE30KT4lkeOCm8rY+WxsF98YqmJAWqkfWxbOgfuSepJWhhVXO3O7uyWEdjIEw9WyLflBdbENhsmXL/wA3U7bEJonEYYncKEAtQiOGFAPLjAI7bWRvq4yddyxDQkFy8g94gEYpC7Qydy2m3jv16eW29iK5GJaAdfKnZNI4HMilmKpZ+8NFhga1Z5da5WEZe+Og3KlC7X80Eo2o1vFZcTkVZMvKHNhbZmXblnsuemMOaFAeERGwXpNan04iDLcHcTMO+tWYWcV4uJ7WrYXUhCN0gMBnhav3CCYpIAFOlE2obER93O1dQr29iKJCwf/q7jdkzR5o4eatKdlr6IY0ZNl8vCEB+hzPKlAHBmlkLRs0dr4TnFsiVY8QdsIasouZ11PGRiTQjSmjyrY8wGZ6Y+yiR3yxAaC8665fnZvlT/lssTrH014TopuLNBLBUti5lYVWDErUmScbqHGEkOgtuDj6scclKTdeb25Sb5BVjmb6i0W9G
 5AviIOI8
 qmak0gxP6W3h3l/Z042sFOFozeoD4ifkC1DeYand5NM567Fqu8/2CTA83IcyYwWkw+TTTuFU026qhZIxXWUgqV/phYDC7ySttqfyEmyYTKllR00FUjTwz1B7i7bU3eTxEXqXviMDNJyzCaKERiMPQG6ZL12Dpa9PP7iMge10UU5uIE51hWBhAMf73a+foIeBJmqSHiKBowTSIwdvQG593+/oAR+jT3WK+qujif7j7gpWExG+/HsoE7a9n4tfejXCppMPQhDTB3LQy456Ug0xRlNubUfGNHdoMoYLihMMgEqUVohj0MWeejnAl9KZC4lO2JMXPQhQPzQrrtD34SjndhL+IL8lUYAuTyWy+Hi7GNBzP/ZDE1HJR4RJAlJRWThA2CY2A5eGv1hI6K5EghjMBKi9JrAw8/aBo/ufKkA3CYfcazbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko:
> --- Patch [6]: [PATCH v6 06/12] mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage() ---
> commit dd77b291442dd4b4a9034d9d1b8338037122f7fd
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
> 
> This commit replaces the sleeping mf_mutex with a new hwp_page_lock spinlock 
> to protect the linked list of hwpoisoned pages in hugetlb folios. It also 
> converts the list to a normal singly linked list instead of a lockless list.
> 
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> 
> [ ... ]
> 
> > @@ -1838,16 +1838,17 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
> >  {
> > -	struct llist_node *head;
> > -	struct raw_hwp_page *p, *next;
> > +	struct hwp_page *p, *next;
> >  	unsigned long count = 0;
> >  
> > -	head = llist_del_all(raw_hwp_list_head(folio));
> > -	llist_for_each_entry_safe(p, next, head, node) {
> > +	next = folio->hugetlb_hwpoison;
> > +	folio->hugetlb_hwpoison = NULL;
> > +
> > +	while (next) {
> > +		p = next;
> > +		next = p->next;
> >  		if (move_flag)
> >  			SetPageHWPoison(p->page);
> >  		else
> >  			num_poisoned_pages_sub(page_to_pfn(p->page), 1);
> >  		kfree(p);
> >  		count++;
> >  	}
> >  	return count;
> >  }
> 
> [ ... ]
> 
> > @@ -1959,7 +1966,11 @@ static unsigned long folio_free_raw_hwp(struct folio *folio, bool move_flag)
> >  	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
> >  		return 0;
> >  
> > -	return __folio_free_raw_hwp(folio, move_flag);
> > +	spin_lock_irqsave(&hwp_page_lock, flags);
> > +	count = __folio_free_raw_hwp(folio, move_flag);
> > +	spin_unlock_irqrestore(&hwp_page_lock, flags);
> > +
> > +	return count;
> >  }
> 
> Could this cause IRQ latency spikes by executing a loop of kfree() calls
> inside an IRQ-disabled spinlock?
> 
> Since __folio_free_raw_hwp() detaches the list at its start by setting
> folio->hugetlb_hwpoison = NULL, would it be better to only hold hwp_page_lock
> during the detachment, and perform the while loop that frees the elements
> after dropping the lock?

I think rearranging the lock & freeing would be unutterably ugly.  Since
the lock is held by the caller (check hugetlb_update_hwpoison()), we'd
have to eithr have a calling contract where __folio_free_raw_hwp()
drops the lock, or __folio_free_raw_hwp() returns the list and it's
the caller's responsibility to free the list after dropping the lock.

Until we actually have data that this is a problem, I will respectfully
decline to follow Sashiko's advice here.

