Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E651AFF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CE0A6B00B6; Sun, 26 Apr 2026 17:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A5846B00B8; Sun, 26 Apr 2026 17:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB8D6B00B9; Sun, 26 Apr 2026 17:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3ACB16B00B6
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07A3C1B7EC8
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:28 +0000 (UTC)
X-FDA: 84702046296.05.862ABF5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id CA6D1180006
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y+nKiNys;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iX7QlDEIRvMq/lhdobB75J6k8cJUQBTaq/dVJzKRSYI=;
	b=8PfH6uuJV06j8FFlsxVTdMR0eYw/kleRSqIvpX+BhUoacdUXRRnUYPbviL2waZI2WPA4wR
	CXVCKINygUJEPoF7Os6GQ2p1EjSdGkiefYUEC9EJtrODQKSyYt4E7IaZG8FP3GlTHlgsRW
	BsT6kgkNX+DL+/NrckDbaziPQE2rTdA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y+nKiNys;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240105; a=rsa-sha256;
	cv=none;
	b=wQx7dN/rxEe87r0d4eHCOjnFGA4fGOQ7BMGkyRZs+pmtGxk+cKFYdnWJeLxtP5lL53vpVz
	pGJ1Mzfnrh7TJWsG+2EdwNgC4NFXhu0uK6y7twodOF1OCAQuGPQi7Gh6R7hZta9K1g6rdP
	v+4IH9+T2j4aLuyVp0OVp8YG75vIYfg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iX7QlDEIRvMq/lhdobB75J6k8cJUQBTaq/dVJzKRSYI=;
	b=Y+nKiNysJzhgCLW/V9drMBu5yZTkmFV3CMtv8Kj08TW3IKST8p+1n8GPINVptMBGiEaZXy
	gbhgNS8lk4Ci3RPmTJCpwOgxo7PdD0T/cLMO3DgpxxEFyfCMdwYAv2cbdPZ2iPTmUd7SvU
	Mu1+Mnfrsv4R+TALNmPISN3FI9VEWqc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-N0f45js9NZKAYSOC62n2aA-1; Sun, 26 Apr 2026 17:48:23 -0400
X-MC-Unique: N0f45js9NZKAYSOC62n2aA-1
X-Mimecast-MFC-AGG-ID: N0f45js9NZKAYSOC62n2aA_1777240103
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d7e5b98ebso7785851f8f.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240102; x=1777844902;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iX7QlDEIRvMq/lhdobB75J6k8cJUQBTaq/dVJzKRSYI=;
        b=gsisiNkHLVp5NHAXU24tYEACojy+LMeOZ8ZqYrVdZpB+j+ZUIAYQk0bT3uHUdrrpiN
         Qc7JcfhI97jYTyqi28+X6c49mwGIQNs8AUvr3VHO81s+LadbznsbdEIzIVj7xqMWPRQr
         Ib6dAeFAfBO6feq47shBW0C3xnarU13LL3/jsp5OQem/jT8x2PADQqnYn/7IyyWtn7BT
         elNlcoeKTvV3dWx9fsSom5NcpBsDl5AC/X3eWZvJ4rpvwemEEjlchP1/HST1BZiZglIH
         40z2BG01Kr8M4zIj3eLkmlu2u8xZ9ySr1pF+DGwh1rFAMWCaGeZn5iS93fkS3vuUNBAH
         0vUg==
X-Forwarded-Encrypted: i=1; AFNElJ+bbC2GFekmEUJfPzxA+1u0E6rXBtZl//8LvnLNbAxxGRiDUjmvUhKm6iJysA5rdj5j2LrCLjvDdg==@kvack.org
X-Gm-Message-State: AOJu0Ywe17Vu2B2vKvC5pc3gNlcQM3z3wCKcF6aABuc9y3WTgfxTw0Y6
	z2dxem9+nYKLm0aE49gicqwc9lUfIT7F0Yg2B+D6Gkz7GXJCTRs/VSN1vCbtssiFcGAXpi4zV9j
	4Qh8727N9LtYaje86DcjXABj/XPeEbqC9RDBb83kNxHsph0++3zLa77i/+0tI
X-Gm-Gg: AeBDievqmXkL76n+3FUQk5yOsLs0FqunwO8UZf0CeepStucP0MV+XxxVR1+SfuMYht6
	Emb0ytu999zoIwfSFJDhn0K3+S7M2XeY/8jANMRCtNSQFOugSju5DooWDVjsL7b/u4zsvmIGHPU
	6vpEoi91+nrvkURfTv5zgMYOVy2T/FCqUD/yEmHc/x3pJKsJBxAHQ2F2o6QdTXqWSGyOyMULcV/
	VIBYVQM8hNO6ear+u9/+MgyBWR6NcgTXBSDxSwcaeJeW/v4zyEl1Sld6LH7dTUT1yZ69H6HvhDk
	ZMu3RqEM6arZSz8/9Kl+qOd4T/RGI/AqQzg7gbpWA9N634BxQuHXeA0cVSEuulpuD+XvuLqo2Or
	YftW3rUZF3DWyFq6cwTeEcij8tSCpCwueFsFgf1EHjFJWMy9YCiQGyU2x
X-Received: by 2002:a05:6000:420a:b0:43c:4810:dc4a with SMTP id ffacd0b85a97d-43fe3e14f81mr62740558f8f.38.1777240102254;
        Sun, 26 Apr 2026 14:48:22 -0700 (PDT)
X-Received: by 2002:a05:6000:420a:b0:43c:4810:dc4a with SMTP id ffacd0b85a97d-43fe3e14f81mr62740532f8f.38.1777240101794;
        Sun, 26 Apr 2026 14:48:21 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cc0f31sm76656472f8f.12.2026.04.26.14.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:48:21 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:48:19 -0400
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
Subject: [PATCH RFC v4 15/22] mm: page_alloc: clear PG_zeroed on buddy merge
 if not both zero
Message-ID: <cf13854ffba899df37f25e9dca05c6ed9efc1a64.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f-2VeEtZflzSwAkZ-ZZxd4Zsf3X0FGRK3K_QBkve8Sw_1777240103
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CA6D1180006
X-Stat-Signature: pt6jbw9h6owcktygkouqds16uhp1b67p
X-HE-Tag: 1777240105-723224
X-HE-Meta: U2FsdGVkX1+eSOCEDpxomSUslTdsgEaSB8K+1GXMetQaC41Z3ljFmFqZ8o2F5eNhVUiWi1bcRYkPpAyEMNxQ+npGAfk2a/4mY2+L45R9o+Ws8rXYSuVNNxbgsEeX1ddYSiecZ7gu+Zro3sQTuGJ1340nyLgoFqnVCzunGkoiDzCdRxy+VHrDgzGs528zxvixO6eaxcy3msylwZ67gstP0M+7VUx3hdHEy/uERK1ccHAw7km9fk8YA1ZH0fMMOq1sSvk6neDWqjjvAzcf3pvGa483fNsWMUaJc7pOxWn8zhl0cff9/2exV5lFse01s00z8FIDG6E9X03LOsYL7dyEaG3TCBt+cpXPPnaNWn6yenArtWNyODPt6HQs2/7JIa8hiAfk60nLEk4Kw1tdL/PyrdHhUY97oY2HyQPh6k884Tgr0Lppgez7DewoPqV7d4Wmih3m6U+1bN6jTMrTneDFWf/9S44tU5s7HCA4xz53DZ1wNxOPX8d/r4uTCzVfm4+Ax0Wowojbn7i7RTmJHyk0DgTcbzBb4YJbEsMO7IYOxcWD99P4MgknDoSjEIzyJqt0HTlpHrQHtaLCPMyT9UZ8SgvNCaNwx99SV1JQG1gUB13AMOfK0VsjyejEDR1JYsBPA+1w1lSEYtkG825wQ7XRiJEITxtlVqRoRzeXUBjemcsrvWiOtldan76QF17LHu4A+Y4+quGEtyRj/uf1mMxQ8mPLl5XxLO1ndL0XZ6pDcq7oq5qP+yixxDd+2JeSU0zdRn7agiIPManaQi9IfTO8vottA7CukhjWBDyQkgVbsXXNptD9eRrGDwy4I7oj2NntHNopSptFi3ri9dA1L/09IdP6DiRhHG06fw8Bb9nTTaavDAjsLXoBWLEi0W2hS79p8KtKp0KWGtZhDI/sVCufwdcThx1T/1oAaR15aGB3cF3yToj728txlIt7kI++xIQWoKd6uMT8aEUZG7IyKjx
 WmhJXiRQ
 fMdlNmBuSmFW3IbqlxkW/vYRXF5quVhhGYZ2EaawhgKLX+KYXWx/4erOFvuB3NxJw8jkNMpu0DT2drajgOjhQ3Rjxcccz41mrxnTj7OTeBC9I5hUGHs8rt9H4i7Bz51/bMTgdXxr9wsnnsHngNaX7MImpQR9KItbKqWSCTPd8L83YQJQg22y5cryEt6vJX87KH49T3EACZuEoypxgXobnphu+iLFru4BfGIEvFJrHL4V/evi3jtTfVO8TNVNXMEpfjckQPxpqOfx9+fH1IPXlrgkgsKmaKrFkJBjl1tLdjK1UPvp7kwHj/3zi5JQTw4sP4leReXiTpXQaUJziZ97vv0957krY/DSzCF470LCYKLFASyHacnltLiSV8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When two buddy pages merge in __free_one_page(), preserve
PG_zeroed on the merged page only if both buddies have the
flag set.  Otherwise clear it.

Without this, a zeroed page (freed via free_frozen_pages_zeroed
from balloon deflate) could merge with a non-zero buddy.  The merged
page would inherit PG_zeroed, and a later __GFP_ZERO allocation
would skip zeroing stale data in the non-zero half.

The page reporting path is not affected: it sets PG_zeroed during
allocation (page_del_and_expand), not on free list pages.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index eff01a819744..1183ef3e91c9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -984,10 +984,14 @@ static inline void __free_one_page(struct page *page,
 	unsigned long buddy_pfn = 0;
 	unsigned long combined_pfn;
 	struct page *buddy;
+	bool buddy_zeroed;
+	bool page_zeroed;
 	bool to_tail;
 
 	VM_BUG_ON(!zone_is_initialized(zone));
-	VM_BUG_ON_PAGE(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP, page);
+	/* PG_zeroed (aliased to PG_private) is valid on free-list pages */
+	VM_BUG_ON_PAGE(page->flags.f &
+		       (PAGE_FLAGS_CHECK_AT_PREP & ~__PG_ZEROED), page);
 
 	VM_BUG_ON(migratetype == -1);
 	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
@@ -1022,6 +1026,8 @@ static inline void __free_one_page(struct page *page,
 				goto done_merging;
 		}
 
+		buddy_zeroed = PageZeroed(buddy);
+
 		/*
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
@@ -1040,10 +1046,17 @@ static inline void __free_one_page(struct page *page,
 			change_pageblock_range(buddy, order, migratetype);
 		}
 
+		page_zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
+		__ClearPageZeroed(buddy);
+
 		combined_pfn = buddy_pfn & pfn;
 		page = page + (combined_pfn - pfn);
 		pfn = combined_pfn;
 		order++;
+
+		if (page_zeroed && buddy_zeroed)
+			__SetPageZeroed(page);
 	}
 
 done_merging:
-- 
MST


