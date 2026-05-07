Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 018C8CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3F16B00D7; Thu,  7 May 2026 18:23:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654DC6B00D9; Thu,  7 May 2026 18:23:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A676B00DA; Thu,  7 May 2026 18:23:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 47BBD6B00D7
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C08B240654
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:30 +0000 (UTC)
X-FDA: 84742051380.21.B03D14F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id A08A240006
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LVHp8Eig;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QlFr+m2Pk5vg0O1/5MoawoNrwUSv9ERusu/cYrbRsds=;
	b=SzDuIpKeHI8zNGFcYgERwPq8siMDs3vQMmHo2QZ30GdcVQ9/UT2t9uZ3NWKmLvBI65fW8E
	/HOkRD4IiI6AO7OnuhMNXYtCyp8F5UMVqxwfdQTUkdSKVHaQUuPL3VVuDTsHWIrUX3Mbmh
	ghFpG9IuBtRsVNIGXG2ddkLHN9wQlus=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192607; a=rsa-sha256;
	cv=none;
	b=yLyO4Hj9wtLXmmngRTA8VpUijaWba/26BeptVjjNd/k5z590OBYb9r4viO9O9ik6df6HAx
	4txu/ekcgk8KRH1IgCMrYLJhb6Ydg1BPrEDrkqgM1XiQtGXbc8LK9wwxG2PQNA0PopSnt4
	xq4W4aYBU0gHb2OMZuIB1KNcrfnt4qw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LVHp8Eig;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QlFr+m2Pk5vg0O1/5MoawoNrwUSv9ERusu/cYrbRsds=;
	b=LVHp8EigCS88aaXzTIhTWiBL7m1beI2chFdABileJMASsnfQqdriczI68J9e5MxBWc6i3r
	GNwOh8QfBm+HirrM7SxiexSl/CoJeh/4JoQ5dKgVe43swaRrNRp0mOl1sSgF/T4YRZjYhi
	gLJ3x6EWsE5Z5+tSN2lcCBlUDj4gu6g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-NHOKtavmOoe7R-Sr1LXxFg-1; Thu, 07 May 2026 18:23:25 -0400
X-MC-Unique: NHOKtavmOoe7R-Sr1LXxFg-1
X-Mimecast-MFC-AGG-ID: NHOKtavmOoe7R-Sr1LXxFg_1778192605
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43ff19e54beso960510f8f.2
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:23:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192605; x=1778797405;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QlFr+m2Pk5vg0O1/5MoawoNrwUSv9ERusu/cYrbRsds=;
        b=CzKYFTWbaYlGhHvyPqOE1DxJ5XukLy0msxWFYg/5KsAHbiVlmNX+DPWHKcXlm+JPzJ
         dTclECGpIQ4h11BeET95OtsVnr21FYgXfuXpNM6GFzcQkepGYr4s1f7Q76WMRLMCjk1U
         NNCXxpR6BSIu5UwjwO0BljK0/Ov25/jlTMcLETqO++XHowpNjNR7BD15nO2jdbUkXGEF
         MsrrrN9xsrry9z2x4i4Ke0u6PvhNVoDyj45lupDMXMHosyV9+YvhB0V+yDaU2Na3e2yC
         69kgrWSRKZjtFmJ6+1AqIHeJh69cy99ijt7oXG4BVm28zjA0/1Ql6NYgdIy9f8Jgm4bx
         o8oQ==
X-Forwarded-Encrypted: i=1; AFNElJ/AkvurjvkouilqkW+2CmQnaGZC7oeFFRJqJSk+c4olQrxGM8Iq7X7QPisqBJFUe6MZkKUkjD6Wpg==@kvack.org
X-Gm-Message-State: AOJu0YwlVE/8iYRpxivoJVx7kJf/Ge7zUP3bQweBZOwOEdk8nwMZYfjJ
	3pSeR7IKBImMYt0JhdY2Hr/tYoxccSNYjVFeouHRYNo20Be7+BJuK0xQ6Pr7vJF2OKgE2V4dUpm
	4S55KW1EPL3SLtDUsCS6nUQfQy6ISL0JsdsgNviqEZva8GeQlY40e
X-Gm-Gg: Acq92OEtyMBZVOAqKIy5kPsVePdtOFHwWel8mrrLfTbQ1xUDNhA4uukEmErg+YT3SB6
	aPd8vKO0RJzrsUBML5fuaP9yKm2LZ+axHOgWI5ADQf3SvLd4MKuYl+gg23oG5/aSMYSxGHIQx5S
	SOLDMsNn8bgNX2XNc077wcl4n6EFEVhprXCHhca7uiBm3p6Hhr+Wi8BIeSfr2B6i1InecxUYxWQ
	FJgCBK5/Rm6EBkyJegd4Xdj/ST6TNl9wC6I+vCTJpqlrW5GG8t0ivog1buU9aD+8qDZBcRyOFsr
	RJfq+ztgMJpcVz8oW4/SnkV1tZkciEwJtw1mr7QTdTlvG5+225x3MBqDj+z5947r8Rk/22iOaab
	VdzMsRpj5rUaczhYma+KQ4BF/lfNm4cBL6OZ+AUP4
X-Received: by 2002:a05:6000:24c3:b0:441:3144:efc5 with SMTP id ffacd0b85a97d-45463d8a9a9mr271779f8f.42.1778192604524;
        Thu, 07 May 2026 15:23:24 -0700 (PDT)
X-Received: by 2002:a05:6000:24c3:b0:441:3144:efc5 with SMTP id ffacd0b85a97d-45463d8a9a9mr271750f8f.42.1778192604026;
        Thu, 07 May 2026 15:23:24 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45412cefe8bsm2089364f8f.11.2026.05.07.15.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:23:23 -0700 (PDT)
Date: Thu, 7 May 2026 18:23:21 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org
Subject: [PATCH v5 19/28] mm: page_alloc: preserve PG_zeroed in
 page_del_and_expand
Message-ID: <ad4cd37e4aea1baae241ebf308e89ac8e34b98aa.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bVtV-UY18Qu-IoQ1pPTPB1HHPF2riK4GNt62oCm6ygg_1778192605
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A08A240006
X-Stat-Signature: 7xozdat6dfj9kpo53i73aeprw16yujyx
X-Rspam-User: 
X-HE-Tag: 1778192607-335012
X-HE-Meta: U2FsdGVkX1/JPOC4mtEtTXQyUxDsVFQL7vWmWRbUAYuiLfS3/iVplhcm+xcDSCADrg9Mtwj+rWNQyt2rIT2PK7Nw093JY+9jVOAuen1VCDt/E/+enGiwVGpAaxo6j8fUlpmroy05NcDsEgXGxV9nZSj4re/9O4fEB2bgBQWsOYb9CIwhWIz2P0l7+LVrg4yxBpS+OZt7mJmBMu4O7tJuFkRYhxgdbKnrOflyY/5CmTwpwMMl556iMFePVZSebgIsFieYx3wmgvhpVrDWUkAj+/GW8K5BgaApq1aoD+MFlzyqSJVA7+fDjOlomf8fFAcfRG3h6nf7Gd3u81LrkdLpJDSS5K7PyKXbGf+yfG85boXLIBgHNYfFyGcCLBrSa65IPUuhX9lCNPHniXFPyVuLB7JvqUdziwNzfBgwgg2bmtkXzxsTU5Ywk7R7LRNBCH9GZTLeg3NieSQnmQ523UHPfAx5sjbtjAUTW4BSUu/39P8rFRiL5gMQss7ag/Ne2NhxlSbo6EJmwpFzInk+ZFK5+E/AeogHhMLhOqr2Bkmf9Z4zjrZ9aDrQOX7Hv8TTV+ZP9UbE2ekR8bFwTIkgOWQDhtvZNXmgswXtj5IP9cjUErsQ1gK7W5G01/EwA6EeycAcjFZ0VQu09cLMeBeHl/3SmEEthDx4fa7tDyZaC8GNVeyQGk57Xv7mi1lSxEZSyZKcvF3Cx3dCmqJ96sTywnXeNjAWiywwwe8Hb8j7rLrAEA6/QmQ64BjpyWQ3Ga4JTJ+P5a43KGblLU7IZb0OWCUqKbREMtQXiz5M5qHPc+VFTanLnOXmmXdGIFgCk/MjPdfTsb2mYM+skB2sDm/Ipo9weG8NAAAuQY9vGZlNWS9fhQWzg+4qGRcry0FHW/OKwTDzWnGRoJYN3aMNhwFMISQHg1hYlySH00BymPSjFBN4HihL1h+iH/cDVYSZLF03KXFJQa7aZvlqChkBmzZHejZ
 IqQRtHf9
 O52M8H4pMS1nKG0d6+hYEc7Kv0OYJbC0ifXoiWpG7D1xWMKCY/I/lXuRYFQRcC3Ic3ODaRJs3W4PBKKVt5tZCmUhdAtJEqjMCjEpwI4Z7rLxWfeXGXWHsibF1fXxKAQrC+297pGsDxsWeHSuWgKsDWiMFgn7mVMVn01YeCcknBuXqaFKXUZQ4Rgky/0NBRqYYpdgkYuaJBvHGCZh2GRYZnMDTG1zMS4FTDPx0xgZ+7NBGT9QLGP8Q+cDO3e45xKC4X5t6J8Qg6S/TYDNnb/OPMnU8OXLWDTi9NQqsrh2V5ld/fvA/1QasdAHou1Y9319FWYYiyxmsxfkbZ4lVvbhlb5OkkuhkbdwmETrCTzanyZKQxbAQnDB/MoumTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Propagate PG_zeroed through buddy splits in page_del_and_expand()
and try_to_claim_block().  When a zeroed high-order page is split
to satisfy a smaller allocation, the sub-pages placed back on the
free lists keep PG_zeroed.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 63b7f396ff30..5c6ab949855a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1743,7 +1743,8 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype, bool reported)
+				  int high, int migratetype, bool reported,
+				  bool zeroed)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1774,6 +1775,8 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		 */
 		if (reported)
 			__SetPageReported(&page[size]);
+		if (zeroed)
+			__SetPageZeroed(&page[size]);
 	}
 
 	return nr_added;
@@ -1785,10 +1788,12 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 {
 	int nr_pages = 1 << high;
 	bool was_reported = page_reported(page);
+	bool was_zeroed = PageZeroed(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
 
-	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported,
+			   was_zeroed);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2366,11 +2371,12 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	if (current_order >= pageblock_order) {
 		unsigned int nr_added;
 		bool was_reported = page_reported(page);
+		bool was_zeroed = PageZeroed(page);
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
 		nr_added = expand(zone, page, order, current_order, start_type,
-				  was_reported);
+				  was_reported, was_zeroed);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


