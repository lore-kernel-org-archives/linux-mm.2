Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63C41FED3FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CABE16B00AE; Fri, 24 Apr 2026 15:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5CEC6B00B0; Fri, 24 Apr 2026 15:33:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B72CD6B00B1; Fri, 24 Apr 2026 15:33:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A7C186B00AE
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:33:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 55AF61202BF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:33:10 +0000 (UTC)
X-FDA: 84694447740.12.C4B69CC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id AB34A140009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:33:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Xr6CBaIa;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777059188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2PAallPai3NT1Ru+JLoUF71PzOdI7Dew3EE7u60fC4=;
	b=LBmS0+T4TwnnXUnttBbfSJAN2mlaA70sZaeW2wUgxHemzW8oWIuXUF34qTVYcqYqw3HPWR
	UnQePbHl2WOEP2zxOFOeXpWtO0JDQOt2Jat+DdyOuDYvxUXTmmDvM5whDfUhfL79xNGg/O
	SDQJYGKQaqVGABo+7o4WGKlkOVI/0yU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777059188; a=rsa-sha256;
	cv=none;
	b=KzGdO29fE9kyIogWk936AayL0hPNmfOrymRc1HwmGLWICs1jx3g6J8ghFUc4gsDiEvELQJ
	+2Z1XZz+juAfLteWV2fi7sZgOvJjQElZJDuQzEcOPIrY+FIFcixyOLeheZb6qHhFaVhL9w
	fIoHJdixcakeJyALRk7e/zt5FPD1e3Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Xr6CBaIa;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d2PAallPai3NT1Ru+JLoUF71PzOdI7Dew3EE7u60fC4=; b=Xr6CBaIapBw6xdIU6KkiuKamAU
	hhXfugzjoN1SzNwKa+AVSxK8MLw6gLgrFm8LB83ADQf37w8XGME1BmN0zQRbsQD6InAJvK7uZ2T6M
	Q6OeG/vjJk8H+ogxA3RQDIGtoi7TX1iuIRK0jV7z3i5KC3OO7PPv8fWnQuTnT2VQSEa19ewGDDogv
	kpJFRvfq5dwzrtWgJ7dmj5wzgZ7OYRjBhNZHx2Z/wEGZ/cVWgz6RGJYDTi/Y1J6nR0eh0pDaTge6D
	KRINvi/gXQIzWE6QRHNfq5mL0zLE5g1GCPE8ft/lldpy4oyyhe+7tDjUU8VjAnfHormcQWKauTOMV
	qQ7pEnDw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGMGt-0000000Fhjc-3cRb;
	Fri, 24 Apr 2026 19:33:04 +0000
Date: Fri, 24 Apr 2026 20:33:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, mhocko@suse.com,
	brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com, Minchan Kim <minchan@google.com>
Subject: Re: [PATCH v1 1/3] mm: process_mrelease: expedite clean file folio
 reclaim via mmu_gather
Message-ID: <aevFb-ZemUo4nB3I@casper.infradead.org>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-2-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421230239.172582-2-minchan@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AB34A140009
X-Stat-Signature: xhkmm395s453fejo1z88x1zxuw7917wk
X-Rspam-User: 
X-HE-Tag: 1777059188-681461
X-HE-Meta: U2FsdGVkX19O1Ot44SZflqznv96zoN0YckfuEQiObgip6/hMSCMu8G9eAMGr792NGB1ba0SGo+6JgvfUjEjBDwXaxVVfhQppjOdODUKGaJcTYIwcxEKY7azBOrbxNiCKWE0NvJI6f1CHmWjF4MwV6hML8NId5nWn4wfyaxMs6vz+6oX9P9l1BV25PAjk9kHjbYR8ijTtuKpyhA1Eu1pK0c6AOOGvJ2GYs5cjjc7/tk5Fzv7URyqDi4uV9Z1aCaf0DUa/24sudov66rGiLGBykYhdICtWQUzDdzsqVGidaHbCzR5okf1QEC9m1tLSWfAo0gbjMFaqx7ejwMgqSWSGhm7gYT1I5n6QMcBFHmAZHVpDtAwL9EMziqqbmxLwoE2kXhBkyNdwxOCfsmdI+PssVLjAubg8WEeIJtoUMadZTr8NdowlgNZdi4qlXh02FxWfS++lKGHFLPNzM7idrmxYy4Rfdu3QecMNlu2lBUtkQ01cEGpy8m3JjlgjIsVobq793jtV8xbGySH7zAGiQbvMIAPTZzL+m9r7brOYkr9ZQQ476miu6JEmixQ1Vf2gNYE55+bLbXGWk0/TQ0F78w5zT/oYvCh+ylzD5jQnQjn11w0TaqeelaO9+TAmvIZ+LXnMW8Ee/hNx3YHHpYFXRN9cN3hT16x+9SqOWvMPWdiJ+5Un0HEUxzq0i31qOmuw2mxRKQwWXKQKiO9hNPQjJtLGIKtgfP3aA2EZGo9hvSQrg+m1zeQ5YpUGzmuvMu/hbO1yz/sODAvS4Gx8M7xeIw0GPeT5jDVRLE2iEBwzDAH9rN4KeBE5FFtCBSEqdmpI6j/wgmmqqAX3ewIYqSjagiA6LqrbvYxZObI4XhLoVWRy7CNBLaD9Pfy6K8E0uzLAZ0rnzKWtDESOZsLK8O+TBd3qxn0R+zg+7PHnFdQdBYadgZ4R8JaiITLff91HBzySkbVfTyq3j1hXreqKaS3YgWW
 ssSQ6x23
 aPIJny7mKOXjrRKyVa79PmwUsmh6dt/9ZsxtgN6n6AXVtu1lFaj4DWUozZe1gODlmh2DIx+JxKNkaSs3i2WAqRWaqY1fcGuq+VFeTB68Ymi76DZPp01H5xcei5XSWU77wa23sJMMNJ43Wd816nT63IjH17yWOtYfdKtgAqtkNLYn8yGuFqTIfsXHyQWStrQJH8Pe0MsXhYelUJX1fiQwrLDkhuKoiJLu5OxsJZGCma/oKV1vlqljIZD1OAoSiv746HX9288o3uuEiOucp2gWKXbLXN9LIL4e41voZb9UG7UQ0hSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 04:02:37PM -0700, Minchan Kim wrote:
> +++ b/mm/swap.c
> @@ -1043,6 +1043,48 @@ void release_pages(release_pages_arg arg, int nr)
>  }
>  EXPORT_SYMBOL(release_pages);
>  
> +static inline void free_file_cache(struct folio *folio)
> +{
> +	if (folio_trylock(folio)) {
> +		mapping_evict_folio(folio_mapping(folio), folio);

If we already know that the folio is for a file (and I think we do?)
then we can just use folio->mapping here.  On the other hand, if it
could be KSM or something else weird, carry on.


