Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BEE6CD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10BA6B00D5; Thu,  7 May 2026 18:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8C36B00D7; Thu,  7 May 2026 18:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8056B00D8; Thu,  7 May 2026 18:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 680AE6B00D5
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2CD8A12065D
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:27 +0000 (UTC)
X-FDA: 84742051254.04.CF4BE15
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id EE96714000F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TBACxlXz;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/cazEjjhaO5BxPm4JyLG8Gc9L6oe2zaOenErLTI/evM=;
	b=cy/K/0E4k/yyoEPQLXYCc9m0M/Tcr26mOx/VU8QzO6yifUj8mMjDQj0S8vCJosC0IPz6qF
	eaQjHkOkKfG2YPoK9AT3DO6LgoU5JjcJWvdJxn0tqBtObObkjAOoT6LmxQTFo9x9WII48l
	fyVzV45+giTigdF5+RRTrOK9gkCHn9g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TBACxlXz;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192605; a=rsa-sha256;
	cv=none;
	b=0s1Q5D87orOZ9EpMIK7+ylvGfxBzLVqj3EtZcqc5AoGhpE4+F1M33lttjcswzWtFed9RQs
	S55Bd6trXmHpwP0Hi1sX36bjAndqKp66qw4qoENPVVFijyBSdJenBdr2sh4PBWao9uNFJI
	95hP9lt4GYPD7j1VOmf2xWvwXEIuKIQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/cazEjjhaO5BxPm4JyLG8Gc9L6oe2zaOenErLTI/evM=;
	b=TBACxlXzaD2DmduvpS/H/KcZgHuUgt9Irgho+YOyoJsIrST4KRcodIoRG1h9BvYerAqGTa
	Hh3usivjXeMw4xJfVCoidZaixwWlBAwZLpbDQK9sYCYky/NxE+dLd5dG1puShmxN71aa8l
	/TNSo9fx94Zx58o4D0oym/XnQD8svSM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-0-0n8US-M8m7LaIJ_-ZeXA-1; Thu, 07 May 2026 18:23:23 -0400
X-MC-Unique: 0-0n8US-M8m7LaIJ_-ZeXA-1
X-Mimecast-MFC-AGG-ID: 0-0n8US-M8m7LaIJ_-ZeXA_1778192602
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48a588ff84eso10591285e9.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:23:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192602; x=1778797402;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/cazEjjhaO5BxPm4JyLG8Gc9L6oe2zaOenErLTI/evM=;
        b=NLR1/f3EhHzSllrnBsdJVhngQxziJ4HLSyyye+TK60yCxY8fpkoXAHcrSe5CkbzaoX
         snXGUahrdxWLUHRRPoUXVXiEzh2F0jjcB8xngIZ9EIdz9u6NmfdPu6Rd1Hrd2fTjxqOD
         57GW9tOEu8AE6MlfelKK9uxqtB+cCIqzmjoDKKB8xKZ87gGcv6fvDPLzw/SvegD7qPiv
         NXTzTeX2NJtJUUjrPHe1mk/JTd7x+HQNqGqI+rChYHqrrX0GvVsTUCVcscnB+WPfHnup
         Mqjk4q9ulZTW9oyvy6I0+TQCgK/pWxC6lSIO5hOu5G85LizY6oqtH4S4/rHbY3h9bkzL
         Cq3g==
X-Forwarded-Encrypted: i=1; AFNElJ+yeOPX8tS4Jue6MjquX4dwdkUK2EKaO43NCp0jCyL56AwycC4POD37jnR8NcSvPi/r1Q4Y899orQ==@kvack.org
X-Gm-Message-State: AOJu0YztI7jX0U8jJ4JClBxJ19S8HGnTDiSb2QoBnE9jGdtvl40OAVqg
	I77qxDyRhRROGW+A9Yy1VId3+mfKRXUn/EvApy6YPen3bHGF1+RsN4VV40GCVsGb0Y4Hne4A8dY
	ibHlB+28AZnf3kasO9Y5L4p72mVt1nEV1OlMkXk6j9q3T1kmlxrY9
X-Gm-Gg: AeBDieuedjkZBI5b8CWrEGDu/fnU13Na4bqzePBwmY8cOyzb84X+mernLP+XXKyoDNh
	KXLD21mI3JLLIGT3N0H4cT66LHEmCcX2vdD2pylIbt58i+j2UJhTD7cfm0tBnao4Qp3ukZimR/v
	n3MCP8ZUYRzV2VhWrXB9W2yV1np+VFcniVFmQsBLsiRoI1LnX1QIddc8KEA3uE09sm+sflauVw8
	y3Abvm0SbE/Yv2Dpz+O1PEjaE49i3AjEqUl9dUpysa9RSkMFZ6A6W7/KaJY0A+8UiWNnDF+JMX8
	nbwp/EGddsCzHWpATOD0fvMqZHUpsD+kjgS0GuNyTvncJROCd09LjbuuiLtvqd062EC/DAICuG3
	44g0jHpxSnYnBT+5N4L4al3d+HOOmfKRSXerEurWn
X-Received: by 2002:a05:600c:4e0c:b0:48d:46a:6e5b with SMTP id 5b1f17b1804b1-48e51e19110mr170280145e9.7.1778192601893;
        Thu, 07 May 2026 15:23:21 -0700 (PDT)
X-Received: by 2002:a05:600c:4e0c:b0:48d:46a:6e5b with SMTP id 5b1f17b1804b1-48e51e19110mr170279835e9.7.1778192601462;
        Thu, 07 May 2026 15:23:21 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e53907e8asm148617135e9.13.2026.05.07.15.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:23:21 -0700 (PDT)
Date: Thu, 7 May 2026 18:23:19 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org
Subject: [PATCH v5 18/28] mm: page_alloc: clear PG_zeroed on buddy merge if
 not both zero
Message-ID: <9928bb52244928b53172e7d95f770bc63d982b4e.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bUTA_KtXEaiD8mp2SW1zsg06oOK3l9LJOu7feYQYips_1778192602
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EE96714000F
X-Stat-Signature: igjdknfw9x3oaref9ginnyri3k5oerrm
X-HE-Tag: 1778192604-965017
X-HE-Meta: U2FsdGVkX19En8HNLuLb7nBhcWvFG2vpCh0jzthdKXNRVwtNaVju+2+AH0z+VDo87c1B2FkGOWZCVpMqFainCnLvyAOhyWGvIHONa6FLxFhMxJcWPlL76rHvBNTPUwlMT1WJ2e3F2hT0hEcicXChwfpLZWI56IHFY3fwssyLjpzi+IqPl8g/+bXa3bETgOhUTy5emNO7zDlnPjXxbaQEgVXAKLFkH3nVkAPfptIbi8bCe+1RrkqI2qIZcDiPMqUEA0OsAHOLcL3MJjpFXqnTSJ05SRVCN2QztZx8KPoNwMbB7og6zrhE+6f/H0ztHzAX42kMX0dGzeObrLL3M2vqsZF79xcd5h/PAlKsKywskiygk3D7nbwqpbJVVspuIXtoXpQCpqJQa8AI/9aywkxjsbkDtmVb0fKsbXazCEoGLVWYpwSKrvaY/n9azDnbQ0DgJIxuMi1snTfepmFliYsOrIajj+cXo8N6Ax8irwoRKeajjSupLXOKJUp1A+aSXJiBofA3Ea9zayVSjgTQbKTIMHFPVenfcU7bGU0v8s6bjZzr5ET39bdBE5TtfqlqzTcWYy3/9A7HNqKZgPY5HFi4SSgUzJdFTWwEtGoJwKK7hYLZ/PWxkQu5N1IShcI9/xT9m11onWcXw9AYXCEz7WYqEWa4ijL9HtHxYTq85On+K24I60nUMugRIjBTvlASywpgaJlYG5LFQOOeDoZ7BgCxQRg0w/jztiT6Ldpo6ch5L2oFStYk9ssCLWUQurtjyS0nR/HGAZMGx141Zq+Td4C8FcknRR7wooHjjQJSCGBYiBs/lRVtBT3YnCFMuCZFrmiId/ZVQnfc9bCbLqx3FeJEQkMkv29KbmpUUA6uIgx9EWPiXWvlG9u6f/mEgregLqU7VMPS87PoM7P+SnHy91p+zkRVHL4WAYiPWqFK8HhnZMEhX8Nu8BIL4+ttsE9oKksttkYRAykOmbZ3dvtO3C8
 sUkfhdfo
 ePms9Uw7G8kzXjxr9VCSiQVSQazS4UyLicmg2v3U4E/KbjTt8rK6Y7MWI4MFeae4w/OFEpH5Vka3tsAnYGqY9UJy9dchcarCb6nk9xZ68uT7eSXTUDRLCf9xffO7ZkP81wcn/U8dJnswO0dLoeRGGbYcqLUzgwnpWzkzgdNBd4f8BBU2gbA+1OGRH5cP82NMl336cEs/4KvWBiCrRWEzNL6EBNGL83ct8n1N9gfShcX0gvm4yTPRoNHw9AdHWXg4FURmqWa92sQF0eVTpD7icu+ZU6U7W9HiaCe54u0lIZmgcPi+W1lp/cOlpyez0apvMW1wObHve81bovDFinE4U5FPGuARY/P8/JBkrD2uqzAo/09AG0TSMw+53Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When two buddy pages merge in __free_one_page(), preserve
PG_zeroed on the merged page only if both buddies have the
flag set.  Otherwise clear it.

The merged page would inherit PG_zeroed, and a later __GFP_ZERO
allocation would skip zeroing stale data in the non-zero half.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e5db2601d673..63b7f396ff30 100644
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


