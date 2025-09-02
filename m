Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AADE6CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:41:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6FD8E0009; Tue,  2 Sep 2025 09:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 087E28E0002; Tue,  2 Sep 2025 09:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E915A8E0009; Tue,  2 Sep 2025 09:41:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3A908E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:41:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7EC43B6A55
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:41:06 +0000 (UTC)
X-FDA: 83844421332.01.8ECCFA9
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8153D80013
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:41:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=K3mhGzre;
	spf=pass (imf02.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756820465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ywssiw/YaYwXrQoqZBjHzV6kBM/9ffLqYweAJQR0/Tc=;
	b=DDAJn7l1/Ai9hdGvX96/DovdVyANwduuLPgkV7IT4M1YwlbRxbWPbdFDJ/0q66gchMQn1e
	0LvcYdV76HAmzGRxboB6XAiionoEoUAN1+DusSetQX6QgB2wuLzxa41YWLxUjSUjHhUiIq
	RGeEXXMyLb0uS8RRgg1yAA7jsybzUTA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=K3mhGzre;
	spf=pass (imf02.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756820465; a=rsa-sha256;
	cv=none;
	b=rBlDxckgOXHeAogicZfXsjgs/yH8Qi8SzsHyMr8jX8xlyIe66x+vqOCqAMGHQcjihDHacy
	deIMH0tPj7Kb6ytbDTBTYgmrE8ttB8UC126eXo7FPqdQ85cvLtuZR/kpjzKRRvkTlR5dip
	53oGj4ofsFuQmvvcXLgCqshMtFq2xic=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4cGRhr0yqXz9tgd;
	Tue,  2 Sep 2025 15:41:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1756820460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ywssiw/YaYwXrQoqZBjHzV6kBM/9ffLqYweAJQR0/Tc=;
	b=K3mhGzreM+Xd/rnTCuWWyyeeSQURhtz9MzSVz380rrhsQLXWop33JBz326eCtL2131w2UG
	nZvkOhGuSxD0qT+X4QQVW3iEwUsfRPbj/MRB8Uwv6gO1t44dXfCrN2nOBSwGbmBOuQz/uC
	n0AePi5MebOJaXOb8Aj69FVewcca8yT0bWwNu5lm6zbFBYthSI2JbYX6e8/LhvJ3owdpMj
	67qy/o5CuUV9hC4kVnoYQux+baZ3eFeoReIxP/KKGDDe1rvlrmEqOXf33QaS6rJr9KQ1Mh
	hB2muN1xq55leopbH/Z7qXtphKdkuT6n7IXwrbd9mehYx/vEBcsgzeDCzmzdGQ==
Date: Tue, 2 Sep 2025 15:40:39 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	willy@infradead.org, mcgrof@kernel.org, gost.dev@samsung.com, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH] huge_memory: return -EINVAL in folio split functions
 when THP is disabled
Message-ID: <ic5kobuxfm4zi6agfvosjxs325mdgrfpjz52mi3zn27epbuvef@z5dmowge6uyb>
References: <20250902084036.208921-1-kernel@pankajraghav.com>
 <qh7s3j26aac3hyzgnr2ee6byjenstxhjnlwn4qxbvz2l32ohqc@qbhdxvpnuhtp>
 <90cd5be7-cbe6-42c5-b0eb-bf9613047097@pankajraghav.com>
 <6l6f5idkqebpai6qn6n3phbnydz55typdwmvp3eexwnhk4qr54@otcgssegyqke>
 <519df8fd-b02d-4b4b-bf47-79070e3d2c9e@pankajraghav.com>
 <h7pqst5vvkahposrvf2iy5qz53t4crrujold2ky4ssrpawaefv@yaqaj3so2hxi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h7pqst5vvkahposrvf2iy5qz53t4crrujold2ky4ssrpawaefv@yaqaj3so2hxi>
X-Stat-Signature: gu7isfzuku8it53erjoptby7bmpccg3n
X-Rspam-User: 
X-Rspamd-Queue-Id: 8153D80013
X-Rspamd-Server: rspam01
X-HE-Tag: 1756820464-59128
X-HE-Meta: U2FsdGVkX18Sb2Mwz73Skr500L6U7ZOCHTk6MfINu94wYlXXIBHn0FXDisvRFIkUW91RAgDdwPgP1jJZ4RR+AJYAPMuDeC3005L2354g7idwLTwBzf9jfkAjN/9G/do9urfoxcoigpQ2GxfFu/9h8YoSvpHVohlpssWTC9KZB0BLw6YXOE8PLCtCx1T5gxLY5ib4fojRUOXZSUjHU3oRh5pXmjVW5kD899QJvi+6XYZQFuQYVu3yPJGgAWfmHVQdOvs10ILii+DYQf8306ERed1YrUzk4hn96zno92MKVaACVfZQCKFy1tXYsJezg463NQyY7PJfI1REZPEVboo+yF1ZDJTFnTENIfTZmAxhtXbN57kLu9qEZIRyBHZ9x9APhdz1toU4FW+egKflsl+CyunzKafl+SxYVKOyph7lXVZJQ//JtRLHhYZCHMdGQsqLrFk/hAC3j0qq8vvKDWQMxnI7YpQbzR9BxiuHq0CmGWTijbhtYGKmtLdizzMWaBcpi6wXyXynQlgjDMSYx2H6XEPShr8IxjNZrglVBUlZ28nE/CptjUv3W0fb9re88g7MdoLhNr9ODsjx+uBXBzG0WY8Xf+VZqqFPLREWIZFe8GY94XAP1/l/HoflqTFsBNYslGJj9p1KUfi/Wtjz1/ZaEJ65VS8nJjHoL7Fq2Rk8W0ZR6kAPnSPCzOv0Fr+P09le62MHH2cba9EPQMr9oQkYY9Jsg1aoEjhzWbtoueJ+hK2Ahq837W2V0VRkeOxwqjtKNafx+lldrfEBfR9Bm6mbEO7T/d0U1LJG2paEoJPU9EhZtcx8sQIdOIDv84f/qmlPWjrElCXJ79r/VlEfZtkqlpRvlrtzPQCVRK7Pt41cUZ0HQs0IqX2SdT7OvexvS2Mp8peCAnj/SK1O/M0T0jPvm1n3ZAuOlPlVuzSv/zi1cqdV8MZjx1aEutP5dlyWMBVzpHXU11PJ+u98OQJvlFO
 whpIWClw
 RAR4wHPG/QCYoEU6nCI6qq2Mty9xEEL0sW0grH8wEg+0sIYiM62MhK/k3gaVRA4jZ2UBFoSt/UjJdS5Lk6g1rbSF0vFanufchL/V2IdEMQ7uNiykJq9J9HXOE8x1kfi01NR7ozYIIh0ugvLIPQ7ND9SLS/1qa9z0voXMpvXIwmKCwmNeo5hqkcgeK9SCotIzDb4QSsVQQ77ZTAwO8Eft6hLEMzss2O6JHoXLp1qE+XUn4MEkuV4oqwT9CCGGo8cRVLMT0ZF65K6WpUkaFHygIOwlS1Tlasp1pmDNv585bYPW7xFKpVeQlGqQhuQRhzhSe3gpUBXVBcOi4bN66Mkjl8yddL/ioV3c3JjDsrOprz3rInoX2JQt4v/MxBlxWGG6sTdcr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > 
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 48c4f91c5b13..4ddf9e87db91 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -588,21 +588,29 @@ static inline int
> >  split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
> >                 unsigned int new_order)
> >  {
> > +       struct folio *folio = page_folio(page);
> > +
> > +       VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
> 
> No. Make it unconditional. The point is we don't expect to see any
> splitable folios, so no reason to get here at all.
> 

Got it.

Just one question though, in a future world where we remove the
dependency between large folios and THP, then we can revert back
this change to do a conditional WARN_ON?

--
Pankaj

