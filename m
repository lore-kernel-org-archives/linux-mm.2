Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0729C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 20:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96A86B008C; Wed,  8 Jul 2026 16:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6EB76B0092; Wed,  8 Jul 2026 16:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A845B6B0093; Wed,  8 Jul 2026 16:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1406B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:32:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E694FA02AF
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:32:03 +0000 (UTC)
X-FDA: 84966756126.25.6A9B977
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 37238140003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:32:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LiWDR19f;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783542722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4BLWSX3Vyc8lOAOY+GGo9U//3Ro2nywmJm3Vhy72n0=;
	b=kJtI5/E3MANHNu0ibBuNakSsT1T5/I+qYVy67l+yheeZZ1/4XICkVb1XK5zpAjO5YdI8xb
	ZoYJQcp9vKD8nM9C6YisSqWKzjLQiEvIgmJ/8VKPLp1WwmRJG7nqm4CAJwLaWKtsYCB4VE
	fDe69mrStlm6sUmNUKcy4ylrrHG+UYc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LiWDR19f;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783542722;
	b=bSYEAAUvLm1yaM3W/I20bMucdvQPq/MO7ZvIDi0xZlZkimFkyumUe32uOKxBFn1Indf4wU
	fKiA6RThGef+nNfxIt7u3ogGR9ZfQmXGL2J5s/TbUT9++V1ZxCzvXA7iaFLuo2U8sI6XDP
	OX95ou0pA74qzkIgyxhqN5yinP89OSM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=E4BLWSX3Vyc8lOAOY+GGo9U//3Ro2nywmJm3Vhy72n0=; b=LiWDR19fAijsMT3WBjoeg9Zq69
	Nc2aIbkflyUMpXatmwy+fWPYKlaS3HozBAB9Jw42/sWUigzxN8lF1l7Dpyn6fVHZ837uRcECeMVlb
	gIksgkjmrowgediYGSSl3jzBIqy7eHHOko9S1NFnLrWJtMZQI/0ORmhRMPrI6NSh4e/i+YddNlnf8
	aw+fMlrzR5T0boM+zT8KLqfEcuCUnXPC22J1uZeoXmtYvcQ3wiShcVwDVbJx0efkMXTBKmIXe3wKg
	/Do69tz/xjkLMS+hgPHDdWXrpXPgpVd5ngf+UUMmRrcC+RZMCWF826WBsHtK5jv8WDA2BCXyzfbQc
	WCjLFdoA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whYvr-00000003NyN-1ohE;
	Wed, 08 Jul 2026 20:31:48 +0000
Date: Wed, 8 Jul 2026 21:31:47 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Luiz Capitulino <luizcap@redhat.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/util: don't read __page_2 for order-1 folios in
 snapshot_page()
Message-ID: <ak6zsw5R4Ub8FnmQ@casper.infradead.org>
References: <20260708201954.686111-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708201954.686111-1-aboorvad@linux.ibm.com>
X-Rspamd-Queue-Id: 37238140003
X-Stat-Signature: rj8esini589g3oxqpjmf69d79498j5ga
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783542721-547938
X-HE-Meta: U2FsdGVkX18HZA+mcDNOyPXvWN0otPtfiqSs5yJD5Pn9Tg8k1/Yg/DNzHdhA9I5/1udv44lJ32HUyRzKiviujR8LaMi4cf1oFJnnXF33gcqnjCkJRMDvmvYI1W9uGGuYSvFf79BYNWnxhkBpA/yESG19IbZiDy75UgHwnvo82lpTGmhP8ujylTNBaeGG4PzgtGGoE/uiqTd4wJf3qkcYkSrNxqrW3ycmTWi992/uirA8P6qywvxXU0Yb+gv3BCveejd75ZB3M6LeV6D2YIf39Wkh35WRpXgx/B9hxfH75wbG9B5GcGcW4JYBnfrowGzTWMZUBrxY6mH2xL/k+Elo+7rPm3Gdpi/jN7RSIYOUFAHWGSD5cVoKQhlhXWvJ3cGdHeT0ZbOz/M2zq+FSA2cmFdIgr1PHiq0zGxO/x1BZA3NCSxYzlsuJzIhuLwjEl0sTsMN5juWu+sXEmg4rVHE2pW9ogrBs0aR8X4YMKuBcPAW6QZUp8mLKGL8JVEldiZ/rDrhuguJDLcSGgp429uv8EvDvk8rjAXZ3oyX1vqOsM2pvEY16GMJPES9P1Snc40Rp3zIL1PQvUCVteRjBezZbc9tmCYwTmNsA/lN0HMAcIR9GzrGLbuPeRR1Dmq++3G8KNEMzKK7im2sfa/JslC1X9fOwxYN9csJLUjGF2Fv7CHgIPmWmpUHwJo+1h4HCOWyJijHlYnShkl885foO+4w9vorhB7QqJ4Q1B7dEjPEMsLIjRC3X8EEY+gNqn/+uDj5J08/EzYMK2/Q6OL9rOenv6xtto53h2qPCOmplRlHUeilGgXbgTjaOl0MoYCCpZGPsaGnqISHP2RDB4FL/7j5pBSvZHv/rz3cX2KwQXGJZnVmfUUYoDDiGrqekuJGO/B47j7BKUxN2notbbpmmfFoIqqUPJlxyuDPv5TtcjRZ+f9Jb45dcLXjcNVxkNSpmbtFmIiGD8FFMpFVeJlX5TjT
 LJpVTu5X
 YdLhisrFE5XroK5kRRoFI4Vj80s/IOANTJHB5vsBjKrMSF28VU3tuOI3yHs/nqU583zZ94XiE2BXbjwWVUZ+Cax6mDbs8yOGOTRsdj7b4XwUlN/rWeyB3lK93WkmdQxnwXxnm50AZdpVhEiZ+qKwKQ7y9o8u1YA7Lg9h/uTAUz1mF2EGDN3HEIR+nKneyGbutbmuqt2hzUpYSqO9OJqVLI9fTWp5a+2hbScUsN6QtVjklmv29TKJ7cJSGPdvwcs4UTKH72tERBfvrxggAXYdmiVtdz9DIKY8q7XEEgrEHz53xQGnfEzAK/8/noIjHV9fWRspyuQ3oJkvUi0INuqYfl87ALWZO//Kmp+2cVUoYI1ZyH4y7SAeg4Clt82BLRS/BJRefnbwvyAL31W4KA4pz8cqqLu7QSY7uXJMq4atoIa7XYaH9ZC0dTuRRQJQL5sKDobDTGctaF3zKtihyKS+p7LxLER1E2X1ZfwzI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 01:49:54AM +0530, Aboorva Devarajan wrote:
> snapshot_page() currently reads __page_2 after checking nr_pages > 1,
> but it should only do so when nr_pages > 2.
> 
> During DLPAR memory remove on a 22 TB ppc64le LPAR, snapshot_page()
> oopsed on the page isolation path while reading an order-1 folio's
> __page_2 from an adjacent absent section (unmapped vmemmap).
> 
> Fix this to avoid reading memmap that doesn't exist (e.g., a vmemmap
> hole).

I appreciate you're absolutely swimming in it, but there's absolutely
no need to inflict IBM terminology on the rest of us ;-)
That second paragraph could simply be:

If an order-1 folio is allocated at the end of a vmemmap section,
__page_2 will not exist and reading it will cause a fault.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> Fixes: 31a31da8a618 ("mm: move _pincount in folio to page[2] on 32bit")
> Cc: stable@vger.kernel.org # v6.15+
> Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> ---
> v1 -> v2:
>  - Condense the commit message.
>  - Drop the code comment.
> 
>  mm/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/util.c b/mm/util.c
> index af2c2103f0d95..34cb43b3eaa4c 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1353,7 +1353,7 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
>  	if (ps->idx < MAX_FOLIO_NR_PAGES) {
>  		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
>  		nr_pages = folio_nr_pages(&ps->folio_snapshot);
> -		if (nr_pages > 1)
> +		if (nr_pages > 2)
>  			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
>  			       sizeof(struct page));
>  		set_ps_flags(ps, foliop, page);
> -- 
> 2.54.0
> 
> 

