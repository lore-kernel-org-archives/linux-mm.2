Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D564CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAC3E8E0008; Tue,  2 Sep 2025 09:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5C918E0005; Tue,  2 Sep 2025 09:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72878E0008; Tue,  2 Sep 2025 09:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 942988E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:21:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52DAC160153
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:21:36 +0000 (UTC)
X-FDA: 83844372192.14.1199361
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf17.hostedemail.com (Postfix) with ESMTP id 773CE4001B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:21:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="k rjuJKe";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Kv7tc5Zl;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756819294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJeUVlALNdS28seLiy00VvLxk+MhX14VjWVeCWs5TeE=;
	b=06dg/t3SBGAHV1fjLhJ6+vySx97IyrLos59i0uH5n5KrN0f11FF1ku+3MvU4Yd0gn/ro2C
	2ARpYZidbTpfKS7VYq1cUMV4Ba7l5VnU5dUe3+s1tGs/LkQvvyjHfhh7L3e+miOG65H3Eh
	5ofZnYHdpbH3dty3eScAcFUVvit+L9A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="k rjuJKe";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Kv7tc5Zl;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756819294; a=rsa-sha256;
	cv=none;
	b=0p/iBth+keTLJpPTR5ZOLrb4yaH9vL2HV1nwvA8uvr5Lo5WS8CawomB5njE/du9Ls0NH9W
	GpFQeYyv9baDPnTjJq1+Au+w/hudrsxp8gjdYd8neY0ENfnG9nHgNW0xzoDCyEJbzAbDc4
	0wA+vDVfUe+Ry2kWxVIVALNOy8s3tDM=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id BD37DEC0462;
	Tue,  2 Sep 2025 09:21:33 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 02 Sep 2025 09:21:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1756819293; x=
	1756905693; bh=nJeUVlALNdS28seLiy00VvLxk+MhX14VjWVeCWs5TeE=; b=k
	rjuJKedvnaeNqhn4Kmqjwnwtd96NVNwXtHdov0Udh6nASk5Jgy9g6owJbgMkKp5x
	AGGDn4PwvzvHoVLJg8pJHAN/zSk9MSodwJAAlXxzZTG5UnagoG7ByvAU8h8TFZFf
	KM3UuKhT0K2nmd9XdRA5p0Tee68WromgZ5rwdoo89/FIYBfJBT4OqEDq2pK91xon
	nG5BZW+w+LVEnEtlf8rcwPFag2rgAW6tAwCHKGJKfEOfM3EH17AsIP7wCvBgwtQO
	qfJ1iXLD35HEqSPNd9fbcXY1pmmb02NBk2usBmIycT1dnS1W8r7CjMDGgKP8DM29
	5n1oN16Y2gao3NxjEQw6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1756819293; x=1756905693; bh=nJeUVlALNdS28seLiy00VvLxk+MhX14VjWV
	eCWs5TeE=; b=Kv7tc5ZlsT/vS4+f+LAOEtlMomwc8TPylM+i36u17BukeMBjM5i
	fu6gg/A8n6qzwQm3kpaRbr6xTqAZE4jlifNYV81wwkkeI9Bn1M7fGIadUUAxuWgi
	mi8aonUx2qSLldmeFaPQ5lsF0WKBy5n1hNCOOd71Scn2GXfFgymo4dyOkv4bMfZw
	zkHnwYWX/ZzSmRWvcsSViXc9M5I9Zv08ZGLEAw/OlxQP972FH0FNB73U9X57fgBC
	a7BlbtY4CuFIiZoKu6Y3OuFx0GiQi6ETThh9wlxboSNjI5cFNMpaC9NcD04GCtZa
	gyqF6mvxswKx4db4dYkcuNsSZ89dW/6hHLA==
X-ME-Sender: <xms:XO-2aCNU_Fxda-TrRptuSpIMIbgBIKL-6zZKdfcTpAXtjor3TmTHqg>
    <xme:XO-2aLzWgwRfCZiqhXddAp2QhyfYd58usf-F2KQTXWVDIqWUPWl3_Fym2ffbKDJzS
    LdTk-M2YQiB1WIFZm0>
X-ME-Received: <xmr:XO-2aHgihy4R2mKQig-rV6-mdWuixFAXgmpq4FuxN6jIzf1ECN5TEwh0T3xH>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdefjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegrihhl
    ohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpe
    ffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfuhhhu
    thhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrg
    htthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtleduhfef
    feffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeegpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopehkvghrnhgvlhesphgrnhhkrghjrhgrgh
    hhrghvrdgtohhmpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghp
    thhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhmpdhrtghpthhtoheplhhorh
    gvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepsggrohhl
    ihhnrdifrghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhopeguvg
    hvrdhjrghinhesrghrmhdrtghomhdprhgtphhtthhopegsrghohhhurgeskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehnphgrtghhvgesrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:XO-2aCQ1CRmyNf7IJSOz8SfvlJfJ4glq7nMIEC-QhiFbIPEHofWZoA>
    <xmx:XO-2aEN5aQdKvgQj8sPeSophDhTeyzKBO5bQf6mt0yxgxw9iyyGIjA>
    <xmx:XO-2aHEefdlTziFsvPcBkhW9aW1UZNL-xh-p1gLTICBAW4--s3_ciw>
    <xmx:XO-2aEiYIM_kwTObNz8DEqQWcG7Yxbh8JfrWB603WzF5K63b1xYUcA>
    <xmx:Xe-2aFqkMbENbYRl7810LXgoMO-OJERlGvRYplzs4Y2Af-4uOtPuv87J>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 2 Sep 2025 09:21:31 -0400 (EDT)
Date: Tue, 2 Sep 2025 14:21:28 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Pankaj Raghav <kernel@pankajraghav.com>
Cc: David Hildenbrand <david@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	willy@infradead.org, mcgrof@kernel.org, gost.dev@samsung.com, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH] huge_memory: return -EINVAL in folio split functions
 when THP is disabled
Message-ID: <h7pqst5vvkahposrvf2iy5qz53t4crrujold2ky4ssrpawaefv@yaqaj3so2hxi>
References: <20250902084036.208921-1-kernel@pankajraghav.com>
 <qh7s3j26aac3hyzgnr2ee6byjenstxhjnlwn4qxbvz2l32ohqc@qbhdxvpnuhtp>
 <90cd5be7-cbe6-42c5-b0eb-bf9613047097@pankajraghav.com>
 <6l6f5idkqebpai6qn6n3phbnydz55typdwmvp3eexwnhk4qr54@otcgssegyqke>
 <519df8fd-b02d-4b4b-bf47-79070e3d2c9e@pankajraghav.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519df8fd-b02d-4b4b-bf47-79070e3d2c9e@pankajraghav.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 773CE4001B
X-Stat-Signature: 8ermspbaegeo66xi76bb9d19ihc9usdy
X-Rspam-User: 
X-HE-Tag: 1756819294-724663
X-HE-Meta: U2FsdGVkX1/2JDC1AlRgEPMiKI7YlnXCalZQUlkxjUSz+6RoAvGjQOMvcwlv6haqvWuHP9jS1CXO0YxdKDyNNPyy8TBpnqC0qHmIyd4WdGDdPaywaenDWMHChm5t4r8xxEiVu3/gxCLQgd+YnOq51rcNsstQ08rqYs7DkLdIV54Y9f+opwhh79hqm10TUXk1bcHf/xsqHh+cmylgBIzCecNCuW2fo6rxxvxnOzT1+yI7Tl3qp49K48s3yhtVqlUc34pTeKarynkHakyh8eIgfGmqmHLBMOrElkBMfc4ZOyX9HK0ArsDTXkBaOz8ULTnX6IW9ANR+1T85S9+xRZQaCGtEcYRYAn4CDzqU9v/HvQdS+Btmh4n1AkeqHPk6Q20LNm+Xq7F3spRauF8noyFwR7QnSkz7rt7reDI7Qg0T+5TAEjiJBqurBEylTyl+CGLwypTV3mTKpfPM9slXzsdNQLHSLFkxoY1kZ+m1Se/MTRvhOBdPoZ+c/SWT7nnfsqESHwH56hv37VwB6VtbhYffc8/7YL67lp+SMY5lZsLFQHLvsXLRVh8IunSWYYTH3CBbpI+j7ioG8YacuDPgI7ft6geCgck1Ykue8d6fbRj7+bYNY+vXtrZtH8ocazkVFhOG0pZ/WKLfHixisU/tZ55rZ5r34dtFPSn6/De0IUEV3EB8wddkZ5XxgEndP56YuwM9SD33OENRDx7a5NBIsTNZ53FOJtvF1k/yv1on4KxeX0L6FJkW1fRL/jP/undCrsKL0X/HPAPuNX+AWdmBREVEsbYM9WTZaVsiVHOaeDx/vTrg9A6ITfbJZK2JTqSOWKedurqXtbBMPQcSj5vnySYCsDNTLpj4ZLgRCU0ZoyWbABN7BRCrF2TzLC7SXgmI6x5ZHCWvvQkuWEz59Tb8EwQs8ml2RL6ycetPorbFREq665WpkD2VI/fRTQRQGXHjJfbcj4EniU7E5fbm+o2clc+
 F4T0uLut
 KDjXSV692sPyv+a5S3LU6k+nEJOZDL97hn0WkjPbKy0U16aY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 03:02:23PM +0200, Pankaj Raghav wrote:
> >> I was hitting a weird stale content read error and finally ended up with this fix.
> >>
> >> I thought this is a self-contained patch that can already be upstream. My argument is not that this
> >> should not be reachable, but returning -EINVAL will do the right thing instead of returning 0, which
> >> means success.
> > 
> > Okay, makes sense.
> > 
> > In THP=y case, __folio_split() also returns -EINVAL for !large folios,
> > but it is not very explicit:
> > 
> > 	if (new_order >= folio_order(folio))
> > 		return -EINVAL;
> > 
> > In THP=y, we also issue warning:
> > 
> > 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> > 
> You mean:
> 
> VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);

Yeah, copied wrong line.

> > Makes sense to do the same here for THP=n. It might help to catch cases
> > we do not see with THP=y, like getting non-THP large folios here.
> > 
> 
> Yeah, I think that is a good idea. Something like this:
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 48c4f91c5b13..4ddf9e87db91 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -588,21 +588,29 @@ static inline int
>  split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>                 unsigned int new_order)
>  {
> +       struct folio *folio = page_folio(page);
> +
> +       VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);

No. Make it unconditional. The point is we don't expect to see any
splitable folios, so no reason to get here at all.

You can try to use BUILD_BUG(), but it can be too messy.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

