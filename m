Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E75E1FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57E976B00A3; Sun, 26 Apr 2026 17:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52FA16B00A6; Sun, 26 Apr 2026 17:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E106B00A7; Sun, 26 Apr 2026 17:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8316B00A3
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:47:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 010B4A05F5
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:57 +0000 (UTC)
X-FDA: 84702044994.13.450F886
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id C531F40003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IKUGJIuo;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUA6w1XPigv17O5YNh9KAjtaq44ytBpbajfhTmLgsNY=;
	b=DSg0aliZJlYCV18OK/ZNez/p4m7wmpTllsqt3I6M7P/sO+C6rzxw5rFWL39+1Tsedndvzc
	jOlBG0vNbkLZR23MwMMUfle4g6McjeIZyvIC6eV/UIcaWc2XTUTsdQd8O6m4FT5SGkX03z
	qlZ6j/wY9Fxs2kgBSWGSthb/r1qApNw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240075; a=rsa-sha256;
	cv=none;
	b=rRq3dT28oe6sAyYocVhW8X1y9h0hArxDD/k16DXBv54+BhjAuW2mAoGP3tQr2dmzBodaPP
	p2m0/2ucwS7kfxUNzNCBnYFjkiW8yXW+/GuemoGz8F09RL5AdSdZZVfBLoDp2s47PhYaS/
	swpAHZTTmalrhaCPeqS7COqaDQfyzqI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IKUGJIuo;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XUA6w1XPigv17O5YNh9KAjtaq44ytBpbajfhTmLgsNY=;
	b=IKUGJIuo0B5nvL5/QhHuO+Khi0bd3LZrg93w4rGT9/kGRXKLtIHqciQhJ8PA21fZXdhojz
	87+0FhNads8mZRPf7Bi0HHYrAGOB+Y8+Pwfp657Z6/D5LR6BnSo3M7l6yNX6IMBcjvRqrd
	CLM6BTRSqv364DS1C3S+hXukR/OHpsw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-KoFi7vgJMEqUX8Wt0GyQgg-1; Sun, 26 Apr 2026 17:47:53 -0400
X-MC-Unique: KoFi7vgJMEqUX8Wt0GyQgg-1
X-Mimecast-MFC-AGG-ID: KoFi7vgJMEqUX8Wt0GyQgg_1777240073
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-488d3eec9bcso62178925e9.3
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:47:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240072; x=1777844872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XUA6w1XPigv17O5YNh9KAjtaq44ytBpbajfhTmLgsNY=;
        b=PpXTuOGQ91MqpCIibezm/hTQ4rNHOgOQJB3FIqmdEc5q3viHHoscaO8PKePGMOv+Xo
         LuenbjhTaE/6N7g6ZCRe0igHqXBdrF/7r2RqxZOX+gmfcBsMMCjRqNjD8WD9tc4mbvT6
         ncvEi9Afe7tTg6cUDUnFnAEy0JJ18e4qa6M4lt6Xs25RMmuvn5Xh33a8JvzCpn0jPuxa
         8MoiH+IYGno97vLtLVgX+KGGpYo53j/Km5B3uLGfKsPRLyy5FUS4SqgXf/Ylbz/MiyU2
         ShSrHB67NNmib9vFKwaQ08vUxbxFXrT8vQlp8VPQ2LcPhZELYZQVUr8gQl7umQmmgCKK
         yn2g==
X-Forwarded-Encrypted: i=1; AFNElJ+34D5zBYqtzcSijc5Ac887qlhD/oRzxIR1PJiWWVrymBrjcpSUQ8XTHUrRbJXeYhrFE4iL8Q/Xog==@kvack.org
X-Gm-Message-State: AOJu0Yw1dz396cBgM4nGi6xVhA2XE5oEv8BihDvo/5cLtjiaHO38RP2q
	gvdZ7eVFaedqgEoggWZlssoMECi96SURGV9YCR0tvl4mlAz/pZVgAIZrZNZonO5YgqtSdV6MSze
	nU4ibxxP47qCPf0BcyXp2+KK7xEvCNFug8pV2FfFx9/ZTVhHEYvAA
X-Gm-Gg: AeBDietqBqtLb97g6sjRgQIH2/GoT1u3F6JbglG8TZJVUINrt/TXnx8HNB2nx4wDNkL
	PFc0+uBu1EFyB31h1L0C4ILjSlmqtBtGSYIHSzJbqEVGoy3pPpmlFq3zIAW7HHColjyb4IjECP1
	yR6TQjLds5ivwCUXxETcmhPMQcGamukWi+6aMRPWwX0PpFfYyWv283xSxUuscVNaa9i49IRGmX9
	KhopadYut4jbtT+pFzRUc1CpeBxZMHUy7f6DczDEcRk0y+aFmym4VjgcUcMOPYVWziylmW6hzrF
	ITj3x9BEWeJxF//MjVGR2t3lrHhDaPtyYDsJu71PpTR9W9SWD+45Rr6J1vis4KVX9BJMyaDQWvu
	bqH1NfgQoY5vp+1Gt6d0A0aM+SxFe3sEdb2HmVQyxUMYPt4SRbPhJV4NV
X-Received: by 2002:a05:600c:2d4b:b0:489:c57:75da with SMTP id 5b1f17b1804b1-4890c57760emr286456075e9.31.1777240072458;
        Sun, 26 Apr 2026 14:47:52 -0700 (PDT)
X-Received: by 2002:a05:600c:2d4b:b0:489:c57:75da with SMTP id 5b1f17b1804b1-4890c57760emr286455905e9.31.1777240072037;
        Sun, 26 Apr 2026 14:47:52 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb75c695sm225077675e9.14.2026.04.26.14.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:47:51 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:47:49 -0400
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
Subject: [PATCH RFC v4 06/22] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <fee207ee31232226c00921d568962b55e7450641.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -kKo5W-ipxcEJezOf0tEg-E7BN_c20kUx31CFPvzSRY_1777240073
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C531F40003
X-Rspam-User: 
X-Stat-Signature: z7bk94omqpeko57qt7ixs9r64qxsuwds
X-HE-Tag: 1777240075-708389
X-HE-Meta: U2FsdGVkX1+Fm/R+3WDwIBlVPDKOfqs83bLBcTyoCP71OoQ2iZ9VYVjUtjhuiq7aoqhpKbNs3CapkkyCO3e30GcyQ4gDAgKTNGsBcGD6IM0rurhK5oR+55VjcbMAQfipp3NeKUUSbrdLM//a161joT6RpqOvyAVxp+IcOtSBAmHk27MyIorkgZBYwzJTMku4cNogoQVdouEYaKgAo3YCxrHGOLk9Cz05SpQHOZ5oYgK642Vr8gyVGp4SY2N6lxeMIggWa0Q9n7ZJFWaZIprokwPcRpywBviV+ldqzd2BCVFqobyJmypP2v6RcZeit5zjDNXp/pyA9XkN5jjLQ7zOPXeuZSLME6jv5pM3JmKLeo5NPSBMBpWh3om/I2jGnUOQFgErd+leD+3CHBkZg+H5iHkJkUpH/vgnca83/lB5joQig20QMrthwcbkOfMy87a6kPpPiWoLL20icQnQpZSnW6oy+RwsjUPlgB8IvpSeTYqwpHF7WEF5yEXq2vUgxjvbCi/pFPXuzX5WK0ynE+NwUWCoNOugg8YojqN5IiToI7/hlKmIYVE/+vD6v3t0RduMTEbwNfCmPrGEbeyoZXr1kwPXbkOqbte/pqnoASU2X85dg2BKfv/8YCqlwP/Fz/K6YiTLfHL5/shK0LQQbQHvM3sLQJOyMgr9/Qv8vm9kpD5RykKQpYkq1XOagG4pr3avTgA3R9BGX7FDy09ndC6jwtd0X05CswxhxX/DlVLg9T2qYjdUQ6R5H+QBYim7Ycj/Aal26hZbBgpXXMU/0BRHMXyQivgNr+WR0KmdrFhTNOvA4YM87LyjMyzXSfmrMvYnIiOVGdgWZPYysnB5GfLxax8H8+64hw2rDy0TgNsjLhk5B1wOUOG8tMSw0GR85B9dt592sYNpbA3oLYmhV21QAj/mP5vLNerybr29KNKdZdrpH0v5Gwo5S0fFtjvtu/I9wpRxF3fSNPexPczdPxP
 /UaAGqP9
 eKMyWirL1tQFmAppntCJd40ylNyeqaACsW+/Lti4VEUxIukaacsZTGuH6xn1CSHyGriqCQc13+FKsVHGRQcMJXwJjXgB7fxWZgKXE9Kye8xFuoVq745gM0GErj4ch1a2kPX28BY35qNMKHnkg2y+GcHXp3DJLpuAMsVdkYLTDDueJZpE7XxR63xEC63nWLBCq2PnEV0XjQJosLJIAGe+BIXYtl13LWU3CYk/2eCrEgbAb98Un/w8ZmoTquiUd7QhklXfhOe4HruP0HBtfY8xlsjoTJVIVW5BlidMYYhlhUytRKxUXjPNLagOzTkHNHkMBgXhwzwCbILjOG8zDnVDvUuCz5VFopnl+MpuMDe5589Hn+kQJ/IMxtSNipA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When post_alloc_hook() needs to zero a page for an explicit
__GFP_ZERO allocation and user_addr is set, use folio_zero_user()
instead of kernel_init_pages().  This zeros near the faulting
address last, keeping those cachelines hot for the impending
user access.

folio_zero_user() is only used for explicit __GFP_ZERO, not for
init_on_alloc.  On architectures with virtually-indexed caches
(e.g., ARM), clear_user_highpage() performs per-line cache
operations; using it for init_on_alloc would add overhead that
kernel_init_pages() avoids (the page fault path flushes the
cache at PTE installation time regardless).

No functional change yet: current callers do not pass __GFP_ZERO
for user pages (they zero at the callsite instead).  Subsequent
patches will convert them.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 04c03c56abec..7791bc1eeefa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1882,9 +1882,20 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 		for (i = 0; i != 1 << order; ++i)
 			page_kasan_tag_reset(page + i);
 	}
-	/* If memory is still not initialized, initialize it now. */
-	if (init)
-		kernel_init_pages(page, 1 << order);
+	/*
+	 * If memory is still not initialized, initialize it now.
+	 * When __GFP_ZERO was explicitly requested and user_addr is set,
+	 * use folio_zero_user() which zeros near the faulting address
+	 * last, keeping those cachelines hot.  For init_on_alloc, use
+	 * kernel_init_pages() to avoid unnecessary cache flush overhead
+	 * on architectures with virtually-indexed caches.
+	 */
+	if (init) {
+		if ((gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE)
+			folio_zero_user(page_folio(page), user_addr);
+		else
+			kernel_init_pages(page, 1 << order);
+	}
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-- 
MST


