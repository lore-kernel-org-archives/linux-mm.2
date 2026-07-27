Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E85C1C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0796B00CE; Mon, 27 Jul 2026 11:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2116B00D0; Mon, 27 Jul 2026 11:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9136B00D1; Mon, 27 Jul 2026 11:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 501086B00CE
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:32:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E60F41C0EE1
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:32:40 +0000 (UTC)
X-FDA: 85034948880.01.423058F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0EE4440009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:32:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ISCVbmNi;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785166359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qt3GwXR+J86gAMXxU5EG5NejNnyVLlhHQ4wVxklzb3Y=;
	b=v+ECk57ajACZAlizAy1+xCBQiPfW435cYh3rxdaWzPCngjFEdpG0Slb8+aasqdbCMMKEx7
	s22zK9Ip17qOD+eRCb4HK3lS1NTEEau6T1IKq74BDdLwQJUWzslLJsi62ozxoOuke2Vfrh
	Nq3pnyyWsk2+xVH5Uk6WqHDqLKOZe2Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ISCVbmNi;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785166359;
	b=VbP6hz+CECQMrcG5GuFbqGmTXwjoHfGSPKCrpcmP6yRp0aHVsLAc44m6kMZ0g4w/hMiJdw
	sJ1XwFkhxkPDjhDIUZSmc1POWSD9zzQ2ykJI9mtfyFc22PKxV0fHVa6yPjv48dsiOvQanA
	Rc8/WcPKbbXELvjh5wI5rdy9DP1FY+s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Qt3GwXR+J86gAMXxU5EG5NejNnyVLlhHQ4wVxklzb3Y=; b=ISCVbmNiUhtqR2WtsX76lwxDNq
	QgXAPepsEXSbiSc1Eie0JLNCyZIFdZhmLu7GYxzEGnptE0KLYFInaf0pg14091Bd66t4L7bNDyfu5
	b2LkgbrdmW5/gVZhpW/4ezxWs2vr+Lq9b1m54nIOE91XTVlTOhcAByqBcdjYZo0LFLg8QzdiaE61X
	X9L6SBKqqeBZiMANyAfZ8eGVkczgAadXmuC+AIjZ+xJe0MPHXrXnWmOhRy32o4JHSQKfUAYc3E94Q
	TyhUkILuNIBrIZDi5nl3sP7jFfNvwA+g0oVaDQ3D+yYXNldhpfK3NHx/Mi1A2mLYGDRhq48JLn8LS
	eWE4oVcQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woNJj-0000000Ax8U-21RZ;
	Mon, 27 Jul 2026 15:32:35 +0000
Date: Mon, 27 Jul 2026 16:32:35 +0100
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
Subject: Re: [PATCH v5 06/12] mm: Remove locking mf_mutex in
 is_raw_hwpoison_page_in_hugepage()
Message-ID: <amd6E4kg9_0Dtf3y@casper.infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
 <20260725160042.1557264-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725160042.1557264-7-willy@infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0EE4440009
X-Rspam-User: 
X-Stat-Signature: a8ey99xt4irfp1xu3uehid8xqunsnjwa
X-HE-Tag: 1785166358-967264
X-HE-Meta: U2FsdGVkX1/bJ2SHaaxk5sXIh8dneEIRwe38s7smgi0/JABDfQfklVBj2YAa5ma6/R5Tm2R400UyGmIM0Pp7c02wrlaydtPBD5fY34qxh9Slp6B2oi0Dn72IIEcQvFHukbyotmI2zZiHT9crZUVlsHL088QJRQx6n72459cGfKjsYg5V7hLjTuqpX25JMW+S2NppBBf8TvHV2H6BHfISgZ/dShmkXA1+1gMx0Sro8HYB3v5eW7jA/YN7Ge4EUuqojbzDBcTnEtitjk1ziKwMZk0aaGkwojYgg1ostI73+yOdD0sRNllmmb2k6drwvvFRxPIbhu/5UaZ4cSZMYkdqLDKWYMhlepHQPzqIbyMlwTQ1qjaxA4Pg4nCgTlaxf256j7g0yF+SdiL33GDAXZZILLD6LsLDkXFfhMS4lDlGO8pyjaxfTOjkEyvQMwXsOxDBbejnyTjQonnFjqOEKrIV285L0HwRAyz2usoEucGoJHfQ3K+H/x7MyIhbXu8UwlJ8bo/OFRRfbIjRYJriqjeMDHJJBbXJDrVA+CSR0sMFG6xXU8wPcn8SffLq7PT30qa6HRfCJ7QENVT4Zvu696+EEEihyjIiFwAZnq03d67RITVFP9Yt+zbmMRuilDVHx0mtdIiXFLM2KR2QvRoAwSoSINkU3GT7vK0XZ9ImiepOOOVxwpL8lJtvWfHFJSP4Wfp0HyjzCZOqIS8vK4PAUK7r5IosBajqNLP7blvLHyXlGDD2/ckFS7mOSP5aqxRuctZzqwZ50kmoF/5AyHraJBCEVaqiyJsr+zynhqlWLB8SKC2F625aI7g+z16FzMDBM3cd9Gnj9sijThYpUc07N9Mcw0PlQpEFiqzP5JnXgAwevL8uGcSaqOYu6hURZ65aj5kWY+4cdgTyfzS9Mp5XtSn6z3OYEDT3xa0XiFiXfoIUhA7+eCZzqIh1RAzhSAEOcjj8Q42XqhbX8wrUdz7Z514
 zIz6P+4E
 MZT4TIgsrjcZH+St2ErXG3D15VGwbiN/uuunO3YCNIxmbIzJONplyWTTCN+WoHn/q+2+9GqzKvkyttgfcvR7MJ36l0E0wAIsLdZWL8g3igfN2zYWmIjsqT/SfikOf6IVcskOTX9/wHr8819/tAzZT+CPiudNro9UaxbIe0yqfhZN7FCkFgqy1tIIQEFAzEJqtPR4BVozfv9GURNhRXMk8Bw0jM8YDBpHJWfNcIqmqiUbJp74pdyg9CJfNMkDBnJtWXryWd/5HMbSdMJI4CLH611kzppNXWrqOsODicMn02OUV5qNx/uGQjSQdIdPY+rAWXFo6jWi5cYro+0s4SY8TWaTs1TeuCXOlTgfwdbFPEw67m3XsOcUNli8aVj3Wez8Ae4vB2b+5waS63WeOfpjZDGT6kR1liNmxOpXWLBzENsfKiw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko:
> --- Patch [6]: [PATCH v5 06/12] mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage() ---
> commit 5aafc5635bbbdae616864594ab6ced23fdde474f
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
> 
> This commit replaces mf_mutex with a new spinlock to protect the hwpoison
> list in hugetlb folios, preventing unexpected sleeping in predicate functions.
> It also renames the function to hugetlb_page_hwpoison and simplifies it to
> use a standard singly linked list.
> 
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 9d245b4f2b8fe..e2f50b4aba822 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> [ ... ]
> > +bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page)
> >  {
> [ ... ]
> >  	/*
> > -	 * When RawHwpUnreliable is set, kernel lost track of which subpages
> > -	 * are HWPOISON. So return as if ALL subpages are HWPOISONed.
> > +	 * When RawHwpUnreliable is set, kernel lost track of which pages
> > +	 * are HWPOISON. So return as if ALL pages are HWPOISONed.
> >  	 */
> >  	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
> >  		return true;
> >
> > -	mutex_lock(&mf_mutex);
> > -
> > -	raw_hwp_head = raw_hwp_list_head(folio);
> > -	llist_for_each_entry(p, raw_hwp_head->first, node) {
> > -		if (page == p->page) {
> > -			ret = true;
> > +	spin_lock_irqsave(&hwp_page_lock, flags);
> 
> This isn't a bug introduced by this patch, but is it possible for a race
> to occur if the unreliable flag is checked without holding the lock?
> 
> If CPU1 calls hugetlb_page_hwpoison() and checks the unreliable flag
> locklessly, it might read false.
> 
> Concurrently, CPU2 executing hugetlb_update_hwpoison() might fail to
> allocate a list entry, acquire hwp_page_lock, set the unreliable flag,
> and clear the hugetlb_hwpoison list:
> 
> hugetlb_update_hwpoison()
>     ...
>     p = kmalloc_obj(*p, GFP_ATOMIC);
>     if (p) {
>         ...
>     } else {
>         folio_set_hugetlb_raw_hwp_unreliable(folio);
>         __folio_free_raw_hwp(folio, false);
>     }
>     spin_unlock_irqrestore(&hwp_page_lock, flags);
> 
> CPU1 would then acquire hwp_page_lock, scan the now-empty list, and
> incorrectly conclude the page is safe. This could potentially allow
> poisoned memory to be accessed.
> 
> Would it be safer to check folio_test_hugetlb_raw_hwp_unreliable() inside
> the hwp_page_lock critical section?

Hm, yes, that's true.  I'll fold the fix into this patch:

@@ -1831,14 +1831,17 @@ bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page)
        if (!folio_test_has_hwpoisoned(folio))
                return false;

+       spin_lock_irqsave(&hwp_page_lock, flags);
+
        /*
         * When RawHwpUnreliable is set, kernel lost track of which pages
         * are HWPOISON. So return as if ALL pages are HWPOISONed.
         */
-       if (folio_test_hugetlb_raw_hwp_unreliable(folio))
+       if (folio_test_hugetlb_raw_hwp_unreliable(folio)) {
+               spin_unlock_irqrestore(&hwp_page_lock, flags);
                return true;
+       }

-       spin_lock_irqsave(&hwp_page_lock, flags);
        for (p = folio->hugetlb_hwpoison; p; p = p->next) {
                if (page == p->page)
                        break;

> > +	for (p = folio->hugetlb_hwpoison; p; p = p->next) {
> > +		if (page == p->page)
> >  			break;
> > -		}
> >  	}
> > +	spin_unlock_irqrestore(&hwp_page_lock, flags);
> >
> > -	mutex_unlock(&mf_mutex);
> > -
> > -	return ret;
> > +	return p != NULL;
> >  }

