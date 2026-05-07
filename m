Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC70CCD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CFDD6B00DD; Thu,  7 May 2026 18:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480276B00DF; Thu,  7 May 2026 18:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347796B00E1; Thu,  7 May 2026 18:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1FE1F6B00DD
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDF538D1D5
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:40 +0000 (UTC)
X-FDA: 84742051800.17.BB0AC75
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id AA20B140002
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y246059+;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=warOUQQwxUg2qGQS9g7Xsjf/DX7jQncHlRwRmsTPpz4=;
	b=fFFxHfI9nEt0kinIWZ1c86UgLtjrAXHVsKtrKjuutFg35LtANMBLiymfZwaY2FNcLxdyYz
	YnXHCYECuPddD38Va8IzhyUyI9gS13N+RnbKg41EWf1EYw/h0tPwEouksu8madOmXSkDVv
	WyhAElBAF7zIWKNgwLe6KaVJRWlhSDU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y246059+;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192618; a=rsa-sha256;
	cv=none;
	b=OI4O0sQkOpKvbN0IkyLBTwk6RAXU7rVXseM48FTWTPM+ScN18+v0kU9PSemxCvwk9EGFBp
	8gPFeIjnKCXDqWEM0dIamj6+MbNCFEtnLjBUhWRPHHuwTZMC3S0qy2E9IE8fwa23+eAqAK
	sZKj9Tc4uucXiSRlAi1hVqj3LZqfP9o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=warOUQQwxUg2qGQS9g7Xsjf/DX7jQncHlRwRmsTPpz4=;
	b=Y246059+tf0EoQ/gXTw6jgok+wInpzvJq1KJsSFtX5u3kf9neTu1CY77iSrk+DRvydwUzF
	nO35hlZx7NAj6GghZ2+KkZ0k1b24SA7Ex0AHftAu/hRYqRbyZN4AzBEOQzUQy/6++98bMz
	CSv84B3cHSMgjLOLWZ9vgubLQea6ndk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-Lah4xsESMw2PeWaQRj6TYQ-1; Thu, 07 May 2026 18:23:37 -0400
X-MC-Unique: Lah4xsESMw2PeWaQRj6TYQ-1
X-Mimecast-MFC-AGG-ID: Lah4xsESMw2PeWaQRj6TYQ_1778192615
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-44d68ed8f95so913071f8f.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192615; x=1778797415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=warOUQQwxUg2qGQS9g7Xsjf/DX7jQncHlRwRmsTPpz4=;
        b=kixtzcd4EkG6TLMcvANOuZwUwV1JSbEPLBVbcKCHvFxeYujZvCsRq0xiTXtg0VLffD
         vvvusTADz8QaCSVrU7zpYA9jMN9M1ullrjGqapPJmagjXfUrqUBPeqUw8qsnC6JSUyDM
         imOVdUBqv9X8iIx9BDXeonoJJa/uZqvG5cmsMu/4rwyrI0LWEypHGDgk7vn9JpGUJBNJ
         xB0OmfoiYsxxb/+ks7YRdY+6B9N/2w277GBVqnlnWdtL9gfh6K/6H9Gre/aQuexFLPM8
         ZDS38osXMlP2n3Z0PZQEILcn8eC+ABjWMXBS2SiZ5gHSyb/R9zr0TFtt1t6eRXHSe/SH
         vEug==
X-Forwarded-Encrypted: i=1; AFNElJ+MG/wwWsPk4E10V9ADGkzqFPTJeVIwschpRtvS11qLKaSdeEx0475TK0kGZsbm+vc+kVisRC4rzg==@kvack.org
X-Gm-Message-State: AOJu0YzJZJFzkZE1/nL5CgwtYkc3UZ0OEif8z4BGH1Tcc98BpsdTrCaz
	uK5GHcg8hDutOoKMZvAsrXQruDTVwq0IJgCGMb2vAx6y3IafaJNkYbwPnt4JldRjPFSxK5f8P1Q
	IgZfmwaOgCxQSzSrLW1PKRnoxVgyazypCmw9GoTQquMlqAi8vCvmE
X-Gm-Gg: Acq92OEulH8alSfF8WgiRQiVcQicrL+FL/m4QO64LjFfbPDGTEfrRuSzTEHBzL0d1LA
	FaGWCYz2Q2n3SQ86zA2R9vgxupyAo7h+l8lQQpCSZAawyLnZu+8aXOnU8H8eYbLY/tFW8tZAhL3
	y55UnTNYTARRxRZ7XY+Gh3gWOtgyTRYp4THgQpFtpKXn/uZxU7bURHfQ1oSJL7a83iUwFKos1bA
	6FJ9PYp2iQJtbPfL23RPJi/tMWK7Y2U3dxBXtBpahNtZsvjjTnMIPafk0glxgH0Gx/BL+jY3GbJ
	UOMffTN88ATbcnufS9E0gdrKyNqPyonarmbWNylReQnhGm5TnnmcXdhjT5DBZU4xSd//utZLogF
	aTHqSjAsyYa1unKBm/UT3YbYkz8oPDMWzU06hCWegMSQ5LDQfofE=
X-Received: by 2002:a05:6000:2383:b0:43e:a75e:352 with SMTP id ffacd0b85a97d-452e78b35a2mr6956789f8f.4.1778192614676;
        Thu, 07 May 2026 15:23:34 -0700 (PDT)
X-Received: by 2002:a05:6000:2383:b0:43e:a75e:352 with SMTP id ffacd0b85a97d-452e78b35a2mr6956758f8f.4.1778192614089;
        Thu, 07 May 2026 15:23:34 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45417124ee4sm2243093f8f.28.2026.05.07.15.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:23:33 -0700 (PDT)
Date: Thu, 7 May 2026 18:23:31 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org
Subject: [PATCH v5 23/28] mm: add free_frozen_pages_zeroed
Message-ID: <a6479c695868be86e42206497650c247bc5b7c57.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: haybbyKM9YjDmoWC3folXABEo2MRG-1zuDL7TDonGfA_1778192615
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: d933mghqxr7hx6e1bqd8xjkm8h8uqrip
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AA20B140002
X-Rspam-User: 
X-HE-Tag: 1778192618-916821
X-HE-Meta: U2FsdGVkX1/BjrEoyGxrxqWKztCi40/0+vISk/RJfxDZSnk1cK6i9BXHBlyz6s0hor/CpLO/7n82m3ybV0h/KWM/6zaUQDaRlf1stMsguI5Jv63TbLZokXp/drWjBpMNcG+aubpalntAs4RbZhCY5JFfrSYf9+BQpKwGtTEdSPzq1txrEWJCQFaLkTVD2AzrBFUEiAr2RvVNYxRzmWcI6UiL1fft9Ymqicp3Lm0hdA36PAnxKjWGXW6r9XvwYMNUxPXwakWiJ+kPy9lYVVBnEhzxC/usJvGAe8KD/eYE+tPF4LXPYstdw3P7xljYxzAm2SP5gt+9AyLD/WgyhJUBfxCTUXUr2ne9bQqEOQtIwUrIvA0ORrpPtjJGimUr/txi/YPEsUXZUImdBZFFQbvvcYZbvbRpLhPPgjkMaGoddu+ext3jje5uB1qC9zLaPbDkl9sAQuaBQxfaxd6HkSGtq8kxApcUI7gwdE0vlLjlIX7pnIlKwjEnh8SvRzU+on9fNSVKC1cHz1Lj3cE1fWtcSOHsMBsfG/l0Kyza5BWfxCJaoh2HTUeoOzQx+S6siWLcjlBDe/tLkpDwoQ7ZGkiABzZ5cp+6wx229kQa2Qbi7A7IPLFNk38z1W6SV15tpws8UyC8tAPw59VbImXqiFfV16tCGtN6+qinQ2d7xkIXPAE0xxjT/dJGoK+fn0ylp5biMjwR81PmddoSjXVPv4v6DzbEwAjLyr+efByZXhxaU+o8otCr/BKO/BDil3wGKsBEJx7TZB62Hfxwjv+PNJwADlqalVnR45WGjSLOQ2tbIxjeN8FbKokMO1mQ9WTzxo9FC9dGk8pp9alIcw1yCjugXmsojFEEUot42aAl1sfDrtmf6J0+TE1LeadpOhD7ujA+TfEiAR6UGlXDjxJHgo8ZgdEl/OSulzWRxBfLQg6QoZknoqed+bCxdq9urDfhfllZ+WYZRkOkuDRpGZZb/om
 kEok0mqV
 fV3CCDVTQQ/MV1LEB5tQb/PCaO5BfYEaQ5K/E+INFohU8FNsJiW6uOA3dXrcvlBtWPQ9AGDuufyiHvDVWXseCcwPysxNpCyaIvhpZOJ6qbY5TVGTQXlxwrjK/SBkl27PPtZrA/1JrgHUY0svyBUhH9UaDxOFA/qnT1S6awiJ0bkpmHhKoUgA0b+J16BI3NI8TIErp8WX7lQKNUKPhC6YqBfEc0w29cvcdztXfQrpElmhMwZv2NsMiYdxH0GsgZ4qn6j+rbpz9lodZ8nbuQ/4MEiXgOJ5l6bZ/iV8o2L4H4q79eLz9pTgpzGruzvdwXg/YwNcdW+Lb0ZznSLKAgMfY77GGh/ZWas2XNgTASkBgbono+AmuhbIrRUFVDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add free_frozen_pages_zeroed(page, order) to free a frozen page
while marking it as zeroed, so the next allocation can skip
redundant zeroing.

An FPI_ZEROED internal flag carries the hint through the free path.
PageZeroed is set after __free_pages_prepare() clears all flags,
so the hint survives on the free list.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/gfp.h |  1 +
 mm/internal.h       |  1 -
 mm/page_alloc.c     | 16 ++++++++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index ee35c5367abc..e0d5743de68d 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -384,6 +384,7 @@ __meminit void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mas
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages_nolock(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
+void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
diff --git a/mm/internal.h b/mm/internal.h
index a01bc2c85cf2..4b9ced7fdca2 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -905,7 +905,6 @@ struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
-void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
 #ifdef CONFIG_NUMA
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 954d86655f77..ca3b2072be21 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -90,6 +90,13 @@ typedef int __bitwise fpi_t;
 /* Free the page without taking locks. Rely on trylock only. */
 #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
 
+/*
+ * The page contents are known to be zero (e.g., the host zeroed them
+ * during balloon deflate).  Set PageZeroed after free so the next
+ * allocation can skip redundant zeroing.
+ */
+#define FPI_ZEROED		((__force fpi_t)BIT(3))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
@@ -3038,6 +3045,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	if (!__free_pages_prepare(page, order, fpi_flags))
 		return;
 
+	if (fpi_flags & FPI_ZEROED)
+		__SetPageZeroed(page);
+
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
 	 * Place ISOLATE pages on the isolated list because they are being
@@ -3076,6 +3086,12 @@ void free_frozen_pages(struct page *page, unsigned int order)
 	__free_frozen_pages(page, order, FPI_NONE);
 }
 
+void free_frozen_pages_zeroed(struct page *page, unsigned int order)
+{
+	__free_frozen_pages(page, order, FPI_ZEROED);
+}
+EXPORT_SYMBOL(free_frozen_pages_zeroed);
+
 void free_frozen_pages_nolock(struct page *page, unsigned int order)
 {
 	__free_frozen_pages(page, order, FPI_TRYLOCK);
-- 
MST


