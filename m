Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 407ABF94CB4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A564C6B008A; Tue, 21 Apr 2026 18:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330476B008C; Tue, 21 Apr 2026 18:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E076B0092; Tue, 21 Apr 2026 18:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 820226B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:01:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1038E1413AA
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:29 +0000 (UTC)
X-FDA: 84683935098.09.1808F48
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id BF77F140017
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EvRQgoM7;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808886; a=rsa-sha256;
	cv=none;
	b=x4AElt8bTbsy/rI2NgTMxAU9TBFvcm9lS442O25sizymEDjBkRjA6g150lmxmR+JAhSxud
	7cneZoSeOXo7dLMSDRzCjgd++d4JpIqhX5opVxZPzHYGJyyKQZSzkHcro51KlrBMNy36bK
	ZO6X0QAzi0Eb1GoeKJW1BH+FyG/jGQo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EvRQgoM7;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Et+lyeWTt5FeJ2gsFu/8TUEAo6EEauFnoYjswzfOPc=;
	b=pOWHCFpy6U+ZhS4+loP7fX/jqsAhNVW7ZT6KQ87yO04JYD47T1nZcruJpq3ohftme9wH7Q
	2/TsvlCC0B6fsT3VHJ1vwkUgmlBIjjyjLJm1sN+Otlw6e5HeGcajK2GjoalJSQrt+JpKdT
	uKh5LJClL8Z8kqSqFYJhYhftdA69WZQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/Et+lyeWTt5FeJ2gsFu/8TUEAo6EEauFnoYjswzfOPc=;
	b=EvRQgoM7zcF3RmfH+PBuWccrZ/UXrg6EuvhX333QjFOrrqgRx/NZgUtwun7FiieDV7HLeA
	D2Ud3soneIpLefYBzng6dGeOSad180tbMFfYh49JrUEBQXUrxKk/nMDRuJ7eHUsn5ijL/V
	v6OZZewuTN8gbHcrtrLSLPQhUM2NJjY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-mLFur-qoPKOyeM7dkgkWdA-1; Tue, 21 Apr 2026 18:01:24 -0400
X-MC-Unique: mLFur-qoPKOyeM7dkgkWdA-1
X-Mimecast-MFC-AGG-ID: mLFur-qoPKOyeM7dkgkWdA_1776808883
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488bd1ee9e7so37744365e9.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808883; x=1777413683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Et+lyeWTt5FeJ2gsFu/8TUEAo6EEauFnoYjswzfOPc=;
        b=CsnWCRFZs9i/Q2e1Dde3JTqQEFauLmWFqe/KVxI8sHxbdtrktct8oLa84OjsIRzPZO
         2BgXwe9lI4/bdFMpF6B8oWf8DY7wjyXvR0nacY8wlc509s7ulJq8NbxOjYvxUEsoP7Vk
         s/qNl5xsGNy1wYgJwTHq9M4uvnbJwtBfF7qszMHVyM5/YqDPSqFrmm2f66PnlNYvfJA3
         TQ+JpsLw+h74pob+rruJU2AoAnMdxBPjkvOztr3bbpcN5MfPI/ygjAfEhuneBJmETnuP
         v74Y4KA1fPLomqQZHQT+mIjU1lx4DI7qJTtnmywsgugAnZDUcsBFTPYhNUpHO1JjHok2
         MKyQ==
X-Forwarded-Encrypted: i=1; AFNElJ9qwr7rAAIcutAeDtIh23216w4nKwzV8dXeg6ihK3tUl1/XVvZpRfawGb6OeQhYFjTNaGYpz3DzMw==@kvack.org
X-Gm-Message-State: AOJu0Yz2P1poaz+Cm94IitlqF9A2lxFYQwZxO5dfkXmXRvRphNwndmeb
	cJCofl4Ti8R9cZ6yVG7QGciW7k30U0MpTxoHdiKU+xM6tbWCwsov9L736IvvdG4tPWx0H92zoGm
	tIth29mUPgkzVXtGEQoqnpAy1mvhbm6X46c/Z1WNQlIp6Xmch26Rs
X-Gm-Gg: AeBDievD6NSURP6qNaJWCeVhDnlpfVXgz6uZE0cZxsSLn4yooYIKjcOOHhd21pp6KdW
	fm7+x9V89Q96bgZlWDt9dOnnBq7JjXnQnre0idVyFeShxK325bxxfWpo/jV7iJNfvQSa1ga4vOo
	sHz2HB0tFtO5ud+dlFCClVxZyMq3h0MW8wbNSuyFchbqaAJE9VrFLl9KT5j89ZPQz6ltjdS3qG/
	kp7GhmGjHEfIoKJUHKmGwqo9mBJaaSrgXiu3e4I6CuIAS2KwsgsgoqB+3Ewq9DQs9Qlxyd7V7yh
	qbp9uuzAm5fkpk3iDdVZtSbvd5NTaIOKZZQ91rHLaB8HiV4ffJT8TAfO/ObR5ahmwgq11vYSMql
	yhhy8wlQLuHqW2Pppf1ccwtIxByBXkL68A5fGWqNAYWb3Wpa465Z+/A==
X-Received: by 2002:a05:600c:468c:b0:48a:56d5:16f2 with SMTP id 5b1f17b1804b1-48a56d5179amr56678845e9.7.1776808882883;
        Tue, 21 Apr 2026 15:01:22 -0700 (PDT)
X-Received: by 2002:a05:600c:468c:b0:48a:56d5:16f2 with SMTP id 5b1f17b1804b1-48a56d5179amr56678425e9.7.1776808882298;
        Tue, 21 Apr 2026 15:01:22 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a5549f582sm28902765e9.33.2026.04.21.15.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:01:21 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:19 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v3 03/19] mm: page_alloc: move prep_compound_page before
 post_alloc_hook
Message-ID: <6e574eb533603db74fd03244399df760a174bdea.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SCBgH2C1o3e_aP72y-r_pKLbhMWuGTwF726wVf6n-OA_1776808883
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: BF77F140017
X-Stat-Signature: fh15p3t19fxisgzphz3dfw4y7c4oiujq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776808886-67757
X-HE-Meta: U2FsdGVkX19UpkEsK9fByl5hGcHfw+Ug0BDrNvqy+aZqfJ2DjWULu2abEM3nEjfMtQjMMJYuHAyckEJ9n6izpk2FELDeTgHJp7L+czwbpVoTDBw6Xlkffu4qbDMrFEmPmRSebQzFSq7X2aVGfpKxhaT+E7VWlQXsrUgiFnTEoZXLk13i4UxVgfUlU2/iyLLPrhhVGydQzr7AAPKFgOdJdUwY19SxDiuwz0hnHWCh+kOCDpvMLsN25oAagA+An7YMDRd8517kBnkGeEn15QchRtEtHlJQnf8d1Qhd/w8rsj4ctNplk+EUYK7TDdcvtbISK0ENDcOV/p96qqtwhXIDvM7qoafuiIPpV9kFXjMsY/kBu/P1c7lZm703D6Va5sM4cHbzbelpfNZZpXqtlc/xczImo50AKN4sJQquZQRhmgz2m8NqgeNJ8ovvKt9a0Wnr7YGAPqBYO5VX/S8lUQEBN0RdlSoz9i5BCy0OzwiqUQbbUW0DPCaPqxFftSUbCrZ5eOYUAUVHeh4hTQ3z+/PfNgf2rZYE/yYRYRHxR24ni5hx8yaRlNcTsJ0tsiO0c6zz7TLSZrYWps0xP98kmSNSHL/tkzWhufxuHa9TZ5VbG+xsvVA6S08PybU++VsJ0zLjRVb0VeFYi94M4MK0T0MUVm+rjhhn1YWo7dK0Y0DFlo+srJjDpWxA99ZLdx7b2UqExr4t/xm74PWQEJ1hMX9vUVMV0yI1zjnuwwYEznDnWQlKTy1f65tGPPlOB0tSv3MeQnKpgmjB7UxIJsGL0o/3MKUbl9MAB9dhKOq3OW6ZHTvTowkyDsThlena7hUPmMnBHo7dJjeQ6c+ozlSqsIn88fCRofTnd149KJDVbZvd73U8S6tJjTqwu92sdmKBKuNGlsKxvucNEzV/yqVKaexHdku03d0sLQvgwFwqa8yMz9CgHkjuu6zoj9QbVLgD3umnkH/PlkcRLNIZrlpFOMm
 Yc2by7xY
 a5HjfJn7LpglvrW5CjQIkKao1GbJhUv/ke6hIWVIy96jQ3mz0TaqcrfWg2FHtKCbzgiuyqW4rfUKHsOeOHYP7c2nV+DkPSVI59nVpRo2tNiN7izOtxQg6OpNR0oTDGOjpNdKGKJYKMkIR/FBZyWVY5wYTHhkOiNSsM8tB1EYjs7k1BlfhqilxCqUpc6jRLwc3wCSYFd3A/7dbTNDFXF7/iqob912x1fMpGfDYjFKFF2vUMSfjgz9Zh1ME5p01HIgPtUgvfGKGp3SLSB8uHggRkcLcmiWXbbYAaBifzAJ/j+iOPsX+IOMxOXTYeiYdCn+WDY+p/hcE55X31Pnit6XzXBg2UTDwvskupDo40BgUsPKO7zjHDrH9K04trA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move prep_compound_page() before post_alloc_hook() in prep_new_page().

The next patch adds a folio_zero_user() call to post_alloc_hook(),
which uses folio_nr_pages() to determine how many pages to zero.
Without compound metadata set up first, folio_nr_pages() returns 1
for higher-order allocations, so only the first page would be zeroed.

All other operations in post_alloc_hook() (arch_alloc_page, KASAN,
debug, page owner, etc.) use raw page pointers with explicit order
counts and are unaffected by this reordering.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1cf5551849fe..99c01eb2d59e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1895,11 +1895,11 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 							unsigned int alloc_flags,
 							unsigned long user_addr)
 {
-	post_alloc_hook(page, order, gfp_flags, user_addr);
-
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
+	post_alloc_hook(page, order, gfp_flags, user_addr);
+
 	/*
 	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
 	 * allocate the page. The expectation is that the caller is taking
-- 
MST


