Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A20D2C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08296B008C; Thu, 27 Aug 2026 23:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8CC6B0092; Thu, 27 Aug 2026 23:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A76C6B0095; Thu, 27 Aug 2026 23:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80AA56B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F0549120352
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:47:35 +0000 (UTC)
X-FDA: 85149293670.17.27BFC02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4BB46140008
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:47:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PD5yoXvb;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787888854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m710DFyKBAhfKCuWsHObfkPb2khG82TsQpFvBA/k2JA=;
	b=RV15aw3cK/ckcZ5fubZLJXfkixiCFWa/e9ITuqpjNe6ZRbnh1HS7aex7BC5n6TOQWUSTqC
	ZGb9uFXpcdTXMvdglonQJXPeP7sdJKQWCgZIjYywhUDiKpVJD69wmtT8nUBekTsqAc/OrN
	pcv2H7jPFz2OWOZuwrBvRHtTk9FMipw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PD5yoXvb;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787888854;
	b=jpfjwi1+HZg1uFnl9kXeNhlfvr+KqZ7ty8Dnncd3IlEIJyYUg1ZeskmXGNxm6/rWIKO5kp
	cvZzkJKOPcwfuDlqvTXQW+t4G07qTPNaqvagyCJ6VZ4AuWCkZyQnolYprvQUWWTQ6UguuG
	jBgKpD5qzzo8Mskc5M+x0IJ0eVN0HOo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 91A6C601FD;
	Fri, 28 Aug 2026 03:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20581F000E9;
	Fri, 28 Aug 2026 03:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787888853;
	bh=m710DFyKBAhfKCuWsHObfkPb2khG82TsQpFvBA/k2JA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PD5yoXvbnJPvy0egNb788P1/kZ5UVxXwv0AbKXVrjtZaLfmWuL7VQjHYesVvQA1dF
	 ISgqaI1omZ3HE1QMqlThC+6VdlF/i3PeqHGSA8Tsf2OcOCy3BFsJaG3kUmIeOqF0RX
	 2ZgscW9XwkXja21nwKKs7zPEnpfp0BGDNuaGJ7x8=
Date: Thu, 27 Aug 2026 20:47:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Xi <xiqi2@huawei.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <sunnanyong@huawei.com>, <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v3 2/2] mm/page_isolation: guard compound_order()
 against racing
Message-Id: <20260827204732.367c52ad420acb0b87bf29ed@linux-foundation.org>
In-Reply-To: <20260825120549.966271-3-xiqi2@huawei.com>
References: <20260825120549.966271-1-xiqi2@huawei.com>
	<20260825120549.966271-3-xiqi2@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 18357atpkr8cmdbaxzky6stjr484udg5
X-Rspamd-Queue-Id: 4BB46140008
X-HE-Tag: 1787888854-744235
X-HE-Meta: U2FsdGVkX1+j6SiOJ3hG/kAsGnQFlLs1X3el2GUXLdL1/1t8SvdyRw2ytCsEttmMaOJI/VROhdrNwtdRGp72E75mvMAk4wwH0FmuewKMMKJPwG7drUTyV8uBq/cOK31VeIy172taYnjWGHTB5mPnOkiUXVQxGIEfkPGm/pm3QUCBwKKU7R97fVNbePXO9AA1GJtp2oTCysqZqW4SqK6mv5QBLZClhH4XHmkwHnguTFjCgO5pyGAYrYa4QLH8iSEQB+W5IbgP78ryFYiF3WSrKBv7EdzP56rKRUxa8vK0FZ+/UoOhtuCsyVqDjhF0UWR/YwL+hjR+ySANF6Mj3ldjyPw+XQadXQ21m8gEZORSx4Vv3MfgGdhbLcliRscvWXzSvmwdtlvZZ99/WOpapg0ByPMNqgs+ezRZ9x5upcEtuJciU4fPZgHm/vZW3PNr2cciz3sxHvend63Uxak9UdLv+6/3p8/1HTBxwTw+noZBJxcApDeMFhVCSCrH5rLIfo9nyV8CuancXv3cY9VLm3nM/7kzyqWUxg/DOuVNdI/2GLZ0xkGKziyXpPLs9CN7KZyY1+Y2RM7ANsQvXIzx+kjr1caTZDigX6XkXQ5I8WzBCSPeAmDAzJ4RVF7ANLSRMN7yy7lZnJQQ+GLQA1iHaI8yy4szjyRWHW+6MI+O7kvDUwb4zB3icuzkSiHSzj5sQ+w+uX1rmH/rdHHd9bf5dlTnvEyFRBolXuO1gHyWFPFQMGH5/wq5G6GSg7A9mgv+sEe92p5tGlyqxbCNBIxqe9Ur2THmDUHS4j4C/412z+NPuK23INDlHmU+fa5YEPv5+Q6ELq6Qfk0UxP21TyMr5QEjwytJc7BxAMA1lFwRo/DKSnEsTsp8oKFkEY4STIWJX4VktV882mBIUXAeEL/YwRlW9Qr8BRCrLOss3B/R1jySm1e1KcA9lyai9VN1YNwMossKEJ54osQz/bF314StGwa
 cnajWYyq
 hjLnHWUhIzkSMtK8ewPYFJtA3mzeWhu463MwNYmzNN7+jm2wta/h1q9h/XXcJugGo9WcgGWngPe2rStpLeO6CMLMkys8clJvPKxY0B/9MpGTdv08TnzKSPJmUXwqw8e8h/Zx8TESrDGK31kE/Um/sphB4gjfsq68aIwMbXxabucegMHMMlXThme+X/rQzfQ7IOOiySkBjHRiKb9rQZ0EciYvnFmTHA8wqwQJLdpa/C33FJJexfggBW+evXrJ5lXRSjStU6eGldggAQCWrPmPODJwyaf4tXsis6qjJvTOCqzlO9lUit0/qvA2vGidYObdbYkpGtzNuzWt9Pplm2XM/1J3d0DgpqYkXI/rEw+syeQ8+JASkOZgK2IoP7ikGvE43ykCt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 20:05:49 +0800 Qi Xi <xiqi2@huawei.com> wrote:

> The PageCompound branch reads compound_head() without holding a reference.
> A racing split or free can cause compound_head() to return a stale pointer,
> and compound_nr() reads the order from that stale head, leading to
> out-of-range shifts and making the skip distance meaningless.
> 
> Read the order explicitly with compound_order() and validate it is within
> MAX_FOLIO_ORDER before shifting. Also verify the derived head_pfn against
> the legitimate pfn: the head must not be past pfn, must be aligned to
> nr_pages, and pfn must fall within the compound page. Bail out with
> -EBUSY if any check fails.
> 
> ...
>
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -418,10 +418,28 @@ static int isolate_single_pageblock(unsigned long boundary_pfn,
>  		if (PageCompound(page)) {
>  			struct page *head = compound_head(page);
>  			unsigned long head_pfn = page_to_pfn(head);
> -			unsigned long nr_pages = compound_nr(head);
> +			unsigned int order = compound_order(head);
> +			unsigned long nr_pages;
> +
> +			/* compound_order() is racy. Cap it at MAX_FOLIO_ORDER. */
> +			if (order > MAX_FOLIO_ORDER)
> +				goto failed;
> +
> +			nr_pages = 1UL << order;
> +
> +			/*
> +			 * compound_head() is also racy, so the derived head_pfn
> +			 * needs additional checks to make sure it is valid.
> +			 * Otherwise, just fail the check. pfn comes from
> +			 * __first_valid_page() as a legitimate PFN, so use it to
> +			 * check head_pfn.
> +			 */
> +			if (head_pfn > pfn || !IS_ALIGNED(head_pfn, nr_pages) ||
> +			    pfn - head_pfn >= nr_pages)
> +				goto failed;
>  
>  			if (head_pfn + nr_pages <= boundary_pfn ||
> -			    PageHuge(page)) {
> +			    PageHuge(head)) {

Sashiko suggests that this PageHuge() test suffers the same issue?

	https://sashiko.dev/#/patchset/20260825120549.966271-1-xiqi2@huawei.com

>  				pfn = head_pfn + nr_pages;
>  				continue;
>  			}
> -- 
> 2.33.0
> 

