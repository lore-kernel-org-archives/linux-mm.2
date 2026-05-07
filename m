Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78173CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3886B00B8; Thu,  7 May 2026 18:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B016B00BA; Thu,  7 May 2026 18:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 038C36B00BC; Thu,  7 May 2026 18:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E827F6B00B8
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:22:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93BE8A0640
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:46 +0000 (UTC)
X-FDA: 84742049532.17.98BF8C7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 51CE1180007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:22:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AG+h8oWr;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NawwnsjUX7qccisIUGIt5emibxZpAoP7nEpyB49cuUs=;
	b=yY5IEKjv6lTFm16Mg7U33VLB6Yp4MNZZUaE1Ih4RK0/iyzvGju5WISkfr2d4kJgY2ncdQu
	midbB89KShKaclX5DKHgCopCwDFjQNfBiqyIgLvCug4UpRcHYe6Xk5Xz+xTE0uaPKBrSit
	SFsR+sRm6xw+x3p5ZjjLvuWM8UQQ6j0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AG+h8oWr;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192564; a=rsa-sha256;
	cv=none;
	b=F8WGPs1Qp/Yw9pbgjB73q+YAezWV/oTMYInbFS7UiEjkYHQ0A4uCSEutec0y+5tWUUbmSn
	/wvOVW0NBgt+HeI+B4Uzjp8+e/AFrFXl1CnMltsOjEW0/ivHaIASZDMukyxYMvxRWGUlX1
	gkhuUL1l3JGmPh7Lyjd8tZD7U5Kvnyw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NawwnsjUX7qccisIUGIt5emibxZpAoP7nEpyB49cuUs=;
	b=AG+h8oWrwCGTaIb4/8rJjTbit3fAMyMwI6jd1OVlkRudVvcq7QYGJ0E/D8hZTAcSal+hGM
	fvK9yrmdhZdGPELH7pIPMOexTblgUJ19C304HMbfluAMpo0Q189pI985aKf4UBKFAipwcf
	fnzK+J0f+glexS9gY0xuyLWx2EquGCE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-uHwis3NYMZGzvsAnQms1cA-1; Thu, 07 May 2026 18:22:42 -0400
X-MC-Unique: uHwis3NYMZGzvsAnQms1cA-1
X-Mimecast-MFC-AGG-ID: uHwis3NYMZGzvsAnQms1cA_1778192561
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43ff19e54beso960206f8f.2
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:22:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192561; x=1778797361;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NawwnsjUX7qccisIUGIt5emibxZpAoP7nEpyB49cuUs=;
        b=cRS25fDSnGFBrYsZDCGlj0enr7GbIWPrniiwDtc89cP1GoGwnrll+Y+w5T1f3iK76B
         ajGYKKxEo/VVChRGXfuqU+e0R99dwOCAnjiZRnvcWEB9eDoYhyJ32CJey4v8a55AhpaH
         sWHVLHlWLn/CDWJNGEnNbxsYuQxDdJN8tI418ny/A/bCCwgfggt6YDqAB/pzfUdXDFL4
         gwTzjUvty67eEy6y4iS/EsiIxylXVkjVKb3XSkEUMax34SS3AR+MBfE/YwbOlS7PVtII
         DgZiepHRaRvnuLxrZEDyPFUxmB7e7hebC2Bn5DQq2mtjOAAQkFDYmQgpHrvt/X9kLXCx
         bkIw==
X-Forwarded-Encrypted: i=1; AFNElJ/+V6y8mAQ2nxegab3sWe+XhZgs2lcU2zOfdxD4hLlRfL6hXlmMiWTlErIir3TtdO2q62uhqFFdcA==@kvack.org
X-Gm-Message-State: AOJu0Yyc/7y1OkGJWjaRm7GmjWLBB7w7IpTdjTzGlSGD/hzRcs3F1Etl
	HSxzWqr2/UZpF4AkXH7Z7Nc4xTjeQjg9UMwoRzngkixW5xfm7M/63h1OdQ+d456y9CeEFeQU0ZX
	X/662BJlUuS9sopK59CyqoB6vTW9gIAuzq7E6Hu6g15644pdolsR0
X-Gm-Gg: AeBDieuyNuyXNs5buVvqwKR/pgF/uYiEmTWpim2mttCmcKM8pOjG6YXjH0VFZCF/rrM
	GCAnkvNBk/tlHeZ2LTlw8iefJLmonGhFqVqoRPGWXs/I0ZRmQvmWWLPT64ekyqJDqiHJsIllyq4
	A7FLYqQ5kHEan8WXdXjIzRBZUutdXUUuR2NLnUEo0YcFFAWeJ7xerypYGn3yyxeljY/z/0mWHMd
	z7l/ss/KsMzrTmbFWcNMiN5LVCvlP2Y1/Wn+sfp9CK39c2+SZA4hMqc+m0zxy4MYoc8NdmtZYXq
	hdfDScOp7BWTXIgd8Fgce5C6sZr5l+FNpWgvz2jjriWETP5+0sJ6sO82zVgw7pBMOddWS3szO++
	AqRZwA/vLyBBu9o1nah6mimW1YoJQRFvenJ8lufKo
X-Received: by 2002:a05:600c:45c5:b0:48e:526e:1040 with SMTP id 5b1f17b1804b1-48e676b45eamr1526005e9.23.1778192560926;
        Thu, 07 May 2026 15:22:40 -0700 (PDT)
X-Received: by 2002:a05:600c:45c5:b0:48e:526e:1040 with SMTP id 5b1f17b1804b1-48e676b45eamr1525695e9.23.1778192560371;
        Thu, 07 May 2026 15:22:40 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e65c01d7bsm4569775e9.8.2026.05.07.15.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:22:39 -0700 (PDT)
Date: Thu, 7 May 2026 18:22:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org
Subject: [PATCH v5 04/28] mm: page_alloc: move prep_compound_page before
 post_alloc_hook
Message-ID: <249b45850d1c864563ba4415d55eeca9ef12dab9.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MKOXueiyQDRjqb5qCNoC8zjsCJ64plMV-gl8suLSiRo_1778192561
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: andhszzpxusoii4qodorm9aeb8zx76re
X-Rspamd-Queue-Id: 51CE1180007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778192564-614390
X-HE-Meta: U2FsdGVkX1+Cfq7uKx7WrfSK9dF70W+/rBYRgKs5k1TlOrGInr8Eh9nKe24UgiM9wA9Uhjmy4fLKyZgC1lqqLzxO0Z2djMSkWHIkk6Y48euKh0wKm06/Mxt/wZ/vptlgjc+C/8D0Tz90vpmwqNbG4oKtlREuIU2RTuUZhhPxFW45D662vXFR7F4HCBr0rtcWC/+kq6CrHmsCBlZJPt5irE9TUkK/oPv8UHlJTjuifLWEsRDdYjV1psa5KsYnR9BVA3Axk/aa5TTukFhlPaUdqC8q1rRbleDAODYaIiLP2IBoYOZHYCsEwHYLYXkelqnbZuxNBOnocP+2wRLhFWjleePUdYjBTixcjtEdM/amgA0hO9ZZfjEmrUrLU/+mTQHmtOp2xOWMT5PU2R+fsp8QSJPpaFLeeqxyQeeaQKbOL0kz6sLhorjEofFleL7xpJwqS9hH1BQO7NWQhg+9zJd50T5Fe1ILZEju9/NcX7nyZWvP3WXUmToQfmAtB91oZChNsKPBXMpAcBI8CVRZ/HW0LQgxfFMxO5hlSeEshw5BUaKbX/z0dG2qq6dMfkA38wNP0QEg75fOY/p3JNLyTnPEn+yTFGVNo7eZJZphG6MoG1ayCzEi9fQfic3H0A1PVJC7mf/DgPGGjULDmTuwTdb8bRl+AGoQztv1zcWE5n+EutQkTpP+/JY50TAF6UrPyRH0zGetEPUgosTLlclolG8rSjayuXOS7L+Vd8NG6/shkMA5VWrwNLlVH1nrv9nISMR2ehS3MiK/OshuqvCidCMFTlp8KCHHbnO8gB9FmPUlL2cPJ+FEk8+fXoev3Mm8TJ5BCbbonM8SFBGLtyHvtNWq7PY9bmiM+TaB9asRRQ5ygMObXbkde7MAAxZ6BEbD1Hi3d672Icr3KQZNpChhzaXNOyTEMnfsqnWKMm7R7P0Xd+E9cadqzobOF8AhKF/Q9IwnF6xXupwZ5n+Ld/QHvvR
 QehqtBQj
 03SaxB65IatMZStJvZD391S7XLzRnFj+hi3Pq8wBzSvgl+jAMn3+9tSRqp0bmK4igy1BWBjfxE1o6R7ZT3/+gQDr2Q7pC9Y6XJATnLSHiLSq7WFBdCBWlxzFqS/36xwZZUl46IxEc62JwPg3zImaixQSeHv0CKYfpmuL3yTqL6NUTWiSWQVAs4hDt92T+x4tUyav1lcLqGUh1G9LU0uZ79ZuibjybowJTByz2s2rJyrwP2E7DZtrGLC7KbYXgl6PgYM+TvxYbq+52hppgbXqd53hEC+lkz5+FLZ9m8xiDpG6y4Zg5+4d0nxczpzt3+WW7YIgfbBpFIL1nbCSOaOi88MevEqEfrOWqWo5xmSl9l1k2AWB8QDzuBVuO6A==
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
index c9efc07741b9..92640ddb0b7b 100644
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


