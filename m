Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB35F94CB3
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443456B00B0; Tue, 21 Apr 2026 18:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B4A6B00B2; Tue, 21 Apr 2026 18:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A476B00B3; Tue, 21 Apr 2026 18:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A79D6B00B0
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:02:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC266C2BB0
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:02:16 +0000 (UTC)
X-FDA: 84683937072.15.DB075F7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 82BCA20012
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:02:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WGq7VUbs;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B71z8WI6bGkbALDtbCGicFiZB6WFkZ9HcNzSfAqdU04=;
	b=Ajk6LAz5/b42hZsY58afNg3Nf52ucys06hCySRGe/evv/ZDX/67wy5mc+B1IqSoYN81K+5
	eKpdiOkgtg3AAF4gaqY6ubLUawTgceDUqUWbIYUUAMh7fsOoeXPbj0fBoa8Sqmg0AChlIo
	5QO6rdCYsOvHyvS6LXdLGY1nhNqBtSI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WGq7VUbs;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808934; a=rsa-sha256;
	cv=none;
	b=J6j3r/ry+iJnCGgALM/bG7ZM2k3awoMhYb0wQx73PHFLWKCfUsGxPNk6G/+ED39FDX8+g/
	cRw8b/mBcSblFu5cu7XrQ4VfBUIhQsnXTwBbNMgyamf8tzkljhTlsB+myZnvSy8LXSdtv9
	H1vXk7J+UilXvp24QTGaWZz8+X/YoHs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B71z8WI6bGkbALDtbCGicFiZB6WFkZ9HcNzSfAqdU04=;
	b=WGq7VUbsDyQhZZb5x+ipSM+sRgM2bixYifM3Jaq60RQ+3MDEZ9pIKFdQEiE1tqO2cYlsBm
	zc7aiDPFdYw+HpgHV/UYXALP6S0/PCXDAO3uFNRpvhwq0epUtiPnb5lZM9W5r1wFRecjlN
	KKcbi6lffvOoOAFN2vUymFCRmsoRn4g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-Aanf2LZoMumejJq474Z99w-1; Tue, 21 Apr 2026 18:02:12 -0400
X-MC-Unique: Aanf2LZoMumejJq474Z99w-1
X-Mimecast-MFC-AGG-ID: Aanf2LZoMumejJq474Z99w_1776808931
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488bd1ee9e7so37751465e9.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808931; x=1777413731;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B71z8WI6bGkbALDtbCGicFiZB6WFkZ9HcNzSfAqdU04=;
        b=r65BgpLGuMDb0xY/0LL90fj2g+9NOOJgYcajakZHQ9dwBfFFVkBAzv0bdbqy73XgjO
         EG6jqU/4SGnihu4Ex2enz6K3O1tQGzzVvrVyTUiS0mnB47tcb2omeWsTWABDSSUO8nsB
         SGpA+p94EL1cfplkISBbZNlqZ/3q/qXNsFwDGYD2McVGCuRSX4PCX4YoV8WmPtnk0vV0
         wowE8MH07cRoK2lHyJEuoh0QZt+7rXNOjGOEikGAmwMiWVlTuw0i+WPAhX+NhXsoFkH7
         OzITjZErxi8mdXvk3EpNw41z0aT44pW2HkcuT3fmcJbpEEppfRF5muj5t+7RWaZajxez
         FWig==
X-Forwarded-Encrypted: i=1; AFNElJ+Ge0O1jYCZTFY7FBiFxuzBhfZ03Xe3dQHtwD8T7Snh7mFn70MfEuB5qRRrQxJpC4PeemXqqbUDUg==@kvack.org
X-Gm-Message-State: AOJu0YwJojzfSywNxL5fKCZfCrz0sDH1J562v/6vkImN4MAON0gcT+IG
	QKEXixzSdVS8/DX6hs1hCc6Flbmp02vjQtz5Lhuq0eKs0n6boi1qJYlvA2c2YJub+19TTpvrcdL
	Z35LjVN+c2C8Yz/ozd4uCmfFSEhsWs7J9dg/f3FpnSKA4xYYG8Smk
X-Gm-Gg: AeBDieueRYK4BkgbpHFsjNMVQVpyyYpmM75FIB0uMOZ7TcWg3dmE2oHS7nvAjB+nEh/
	4D+uJ0KWJUrywoyVsV94qNINc2q1/IhRTxTXSPHJQFuBD2In2M4F87s/ioPVdAiHnQAuVtt8sEx
	2vkrhYB8qR79qJXdyrNolpZvObXsnCDq6yip4zoVUXJminlk33IPSMeYTUsbs9yM0M4KycMtejd
	6pF15RSPdijSb+I93MNyhIMyfq3xcTz8YI60tu45Xvr12CiRNtXY3yNnsg6RausU/1nPJu+GkD5
	/79TwPBKKEZxsSUNx9X1FfxwSmXz7ie1iTGkPymgFHPm9uYbgBNpii3bQoADxyBIIVNWqtYMWVS
	Wdv3kM5zyOjPLUUHiDQ5snTzLRs54xcUCtfe1LHxAbbDOeI3kDTm7ug==
X-Received: by 2002:a05:600c:4ec6:b0:489:1f98:71e3 with SMTP id 5b1f17b1804b1-4891f987487mr132175365e9.28.1776808931359;
        Tue, 21 Apr 2026 15:02:11 -0700 (PDT)
X-Received: by 2002:a05:600c:4ec6:b0:489:1f98:71e3 with SMTP id 5b1f17b1804b1-4891f987487mr132175005e9.28.1776808930932;
        Tue, 21 Apr 2026 15:02:10 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4d525sm38750206f8f.31.2026.04.21.15.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:02:10 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:02:07 -0400
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
Subject: [PATCH RFC v3 17/19] mm: page_alloc: clear PG_zeroed on buddy merge
 if not both zero
Message-ID: <6992d257f953733586275aa766add3195aa93770.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: knBosjrjlSHlaWfbbGVWjhEsQzMXHT9e034rSJojUTM_1776808931
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 39z3cfopypn8444giefu1dihw9iyg89i
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 82BCA20012
X-HE-Tag: 1776808934-279758
X-HE-Meta: U2FsdGVkX1+vZF9pxqKG9p8zuG8u64tXw5oGiPx/RNmpjpNHFqPuVliNa41lezXWjfTQ2b3HGO5ra8gakZJCFKsGtzM23AC4bOSpRFFQ+Uiu7v/C0JBj/DHliCyCMiEKLiCVUxmO0T4tKgXCEZVF0ZAFK89pKV7Opk1yUJLMUqWdRPBxblhKFywKxzBvoRMIOKgwfRPt++g7Ir4sA2EdU8KrBLuwjV75qwnHaNvNwOvJ8jsbOx3ExJqUUPkj/Y/l+AV7gDxIXjAKzSAp6DNwpVc/jl2aKse0YH2UEF4qE5EHWfhjwD208qFO2WZ88rbzC/WTAo8GQQUS/EKMaSXGAwBWPZBkxMOTyYIggvZnTxtC962K5c2leSR3nNO/3/jzp4Z3oIzRij95TnjE/ArUZbQYxM5qI6mbLssMvZurr76WXtV7/0RAgtxoT1D6dlnFxg5jocpMxy9rhkqP57I+3sib5midsgK9Uwqyp1id6uUuPYlyHZ7cgojjxuGt4yomLr1BNWf5vF+Ae1UNQdgkFHeIUVsfm54wc+aNxqu/TWgnTVHwqJToM2pjT2T5g7jC9UKpQtH+jAFr+fO56L5O9BYzoUGJuEtDL7vbq7wpF/IUQCf3IUHJiGQDKsxTiM3fRiiU46L+tJITZMrNyP5289F1xkY1xpMMQTSb72CmxPPB48sCS1LjMUas5zGaMEW8dvvcvWSY047oV85Qg8bl4Rx0rxTc6CvYijpm+z0orgYrIsKt819Ynay3Npk1JrQ5V6+17S+spig4Mx1KssGTToKX9txmdgMsM6d57yEZ2uYPr+wWMOa0dkbqm5EycTU8eqfC2xEH1jRW33gNO8TnGENosb4JH6t+8K4UXxWQmJiHcRjHO+ezYF/ei42nUVv4j0T+2+GeU+ynBGjMSNoIlTj3In8YYx3JbXxkZAcalEl5L2YBM5LXX+/xPKP26mgAk/FkeNWncg27k1TwAOc
 O8DiB1JD
 kt0m8TskrL8r45RegnagnmwrPQXOixp6kg5vKuy/Lj/EDLMMPUH65G5h875pY1HFW1LOrbMbkEIYf3r+tBZkmuBJ/cefE/qGjlx4g1id6HAJoJ8dArIbu9U8nktvWFPEE712PJUBwNZQaUqkmvr9ZJxWQ7k+e61wRvjZzwUGFLtcbuUKGzsTdQtjZnLjxnit8+byOVc1wHjWAZMQl9UeaChl8W0Pv8qCUCLriOV8K4sWsCV7CMhzkltnDC3dpRsvY+3zsHSgWYuMiFenZU6YygMi+pb/E2+MVcnuSe2S0ECVOu9awzY1H/HEsTzyCwNjyUGFb1CSRGNE0Iz8rvTrkNoDMWcxOWbWPFQXFjDZ56E3rDKPNrPagYVYDYg==
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
 mm/page_alloc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9311374bbd2d..122b49a6d435 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -991,6 +991,8 @@ static inline void __free_one_page(struct page *page,
 	unsigned long buddy_pfn = 0;
 	unsigned long combined_pfn;
 	struct page *buddy;
+	bool buddy_zeroed;
+	bool page_zeroed;
 	bool to_tail;
 
 	VM_BUG_ON(!zone_is_initialized(zone));
@@ -1029,6 +1031,8 @@ static inline void __free_one_page(struct page *page,
 				goto done_merging;
 		}
 
+		buddy_zeroed = PageZeroed(buddy);
+
 		/*
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
@@ -1047,10 +1051,17 @@ static inline void __free_one_page(struct page *page,
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


