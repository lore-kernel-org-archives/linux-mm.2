Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07077CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 22:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69F368E000C; Wed, 10 Sep 2025 18:46:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64FC08E0001; Wed, 10 Sep 2025 18:46:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58CEE8E000C; Wed, 10 Sep 2025 18:46:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47CEE8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 18:46:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 008E61A02EC
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:46:31 +0000 (UTC)
X-FDA: 83874826224.26.031EE20
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf13.hostedemail.com (Postfix) with ESMTP id 56EF820008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:46:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=NNkaVuf5;
	spf=pass (imf13.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757544390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=szZx3Rn8er+I2by0SGlfSjlgP3lrbRR+Xl6ClVyRFLw=;
	b=wWGgxIQgrK2xoaHUuquGFI5R9S8JDagRs/gdw2fm8sTjfBOQsY2qbl8QO2h4VCEyaxnU5M
	O10go46Y2mKZMjO7jEDnsNcPUe2pEO32UOAijX+y7b1owzvlTN/7ZwQCywIZQOXrAMvm2I
	TflQdlFTRUOdXNTQjMdSwLwTDhzcgx0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757544390; a=rsa-sha256;
	cv=none;
	b=Yyt8QRdOTwsoGaTpAj2j+y/1LsgdTZQvUBiPsD3FJ+wv8EHpsZqY4jI2AXjLYLMRsMaVhV
	8nzcdpd55niCQwhglYZNny6ub+1O3nWn9jO5ECukrPtITqXdF7U7uZxSsEyZ7MDA6J1UJk
	MVGt6qDXIPifRF1Ll8HP2sBCWzdf7Zo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=NNkaVuf5;
	spf=pass (imf13.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1757544389;
	bh=mGSfQjrGfr4pOivTBVJSSieENFzRnGla3USrZdvp2fU=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=NNkaVuf5gzPifk5/dYjo/b13rz7z+PpnNm6or3zEcnQxx5mRd/Qsl/vAsNbDsbe0f
	 BWFqC8mb3kzznTjL7w+J06xLh+iU/7ubChVNNuLUMHNKyu4KA2upbAZJmkgaRWYFRx
	 ySCk40+9mP2aKokzcrgn23/4wfup0CHRU+MooTe8=
Received: by gentwo.org (Postfix, from userid 1003)
	id 7228F4033E; Wed, 10 Sep 2025 15:46:29 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 715E84033A;
	Wed, 10 Sep 2025 15:46:29 -0700 (PDT)
Date: Wed, 10 Sep 2025 15:46:29 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
cc: Vlastimil Babka <vbabka@suse.cz>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 06/22] slab: Reimplement page_slab()
In-Reply-To: <20250910115507.1991829-7-willy@infradead.org>
Message-ID: <8eefb8ca-e310-48d4-0c3a-fa80665cab87@gentwo.org>
References: <20250910115507.1991829-1-willy@infradead.org> <20250910115507.1991829-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: nu6cwkygree9h5oojyxyopyjnnqbof9h
X-Rspamd-Queue-Id: 56EF820008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757544390-569731
X-HE-Meta: U2FsdGVkX1/XMe6cnG7+nFapuuGVT+dBZzfbRHLmVgDH7EQ1GXSwHgqPU3o4bDN5nd5hcTUFfY/g/8jnHqnM1QQz8YRfLt+4Rck6xlP4D/2gOIONmkR0ADwZRZPPgBaYANwJzlDMD+HA8W+kon5vd3Icp0X6kA22RgWGTTYMQXS1Ov+BqbItQlPY57OzlKtWM0PReTDfyQaBXBcr4vBE/nfs9LxhRrqnGNw9KeDaKnE3furu7c9QFBrhZECqZxAHKyCtYzbFzhtTtpVIrxlGQNjDvd0nogm/0E2H/vg6Vhc9MYU1hfwXp7ASMz+0w52TIdJ51+UFzJmw48g4fNb4cGtQ4Sw0RZtRWNyxwCpOFuzdwvPcvZsvFJ4TXP9zMxAksAuTjVXWTi2VF/M4d5vFMsy2oBXzC4JPqBcrUBTUoZHrNWX8K6ucsCmiUjl9eBaWOqNa89bVBqWPvyK3ad9LdXh+EJO+1noIJzn7jY6ZqJn0nwyphHH1kIN2weCJVbsUyS8fDUoVxoI49ntQlge9jmrp8KwQRIFDNEgClQ+xfSi6tnJhRQ2gYKoebev/E7+UHn7THRyqMIG0i/fruaZ/AEihz4/tlRjShnsh+Y8k6oIy6VbsY3QqZdo5Gq8GZwCY99QKZMoF/DD7XJH/Lv1bBIN8WZHEgwhYIWhdmnJ+7ltelqI5o+2gw9G6xu59aY7fvHRjm600WkjJEJzg6RoFgj6DXbuboD91TkmmIuIxVXdB4XaBFTOUYA8/hoRR4hAmOGmbx99VXzHJdLSrbF+WX8jUlo9tWlGtl0epaH/FBvzi5lPfxSjGWcb2EnAYjmqEMW9Zcb1ID+J5pPfl5Kua4MlbQHs26IT+PDl5+6J7BUto316wvzzZP1jwahBxE057dGApGQbqLShx+nefLaTB8dBHJ3IPHy8LIIi82VWvulqHNO1TXWutGbIzlyRP3ascoJOKu6lGpDdRLmpSFEm
 CWkpon+O
 DuEJ2vljmIhXDDFNb9iXgzRz7RmEFovDaENt+9VPO+UtFYqj+t+BnIe4EjoV7nuRDzw2WWggI++XlN6eu4Z20LLyNmLhu45cSxuAcS2dOR4E4NpyZLOBu+bGi19+Hgm7UE+xbs7UpuWRjIx6C1QHIa2JZM51B7NY5ArPkqDAqVTF18ksw0G7I5iahsu8VFSxdHWsFBIWzbq+NQIt8Tu3yNAMohExeO5ZXYTXbc2sj1wXfTAPlgmr2ho8vgvHpa8ctDvPDzhn+CCvZ9RBHk/QWfusEzynHTFA3xSvH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025, Matthew Wilcox (Oracle) wrote:

> In order to separate slabs from folios, we need to convert from any page
> in a slab to the slab directly without going through a page to folio
> conversion first.  page_slab() is a little different from other memdesc
> converters we have in that it will return NULL if the page is not part
> of a slab.  This will be the normal style for memdesc converters in
> the future.

We are looking forward to another level of indirection in order
to get to struct slab?

> -#define page_slab(p)		(_Generic((p),				\
> -	const struct page *:	(const struct slab *)(p),		\
> -	struct page *:		(struct slab *)(p)))
> +static inline struct slab *page_slab(const struct page *page)
> +{
> +	unsigned long head;
> +
> +	head = READ_ONCE(page->compound_head);
> +	if (head & 1)
> +		page = (struct page *)(head - 1);
> +	if (data_race(page->page_type >> 24) != PGTY_slab)
> +		page = NULL;
> +
> +	return (struct slab *)page;
> +}

compound_head() is open coded in there.

