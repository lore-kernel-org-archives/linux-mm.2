Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 084FDCD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802E16B00D0; Thu,  7 May 2026 18:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3206B00D2; Thu,  7 May 2026 18:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 655616B00D4; Thu,  7 May 2026 18:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2B46B00D0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1690B1C053A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:21 +0000 (UTC)
X-FDA: 84742051002.11.FEFC622
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id B2DE11A0016
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WSfszXCI;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eTIW0e9wG6pgXoJqtpclYC5TuSr4GLdLxR6Dc7Uapl0=;
	b=fVIpvSys+6bBwIlnYzATRCALUb/uqxWQePAgDnu3dphkpocZWA/Yxy0AkHfNDPcn3A/bbJ
	EQbqBLzWE8AFRdEDrlrXKRjA7G2h/PL0C1/ymlLK6Hip3DDfCYIymtav99dpDC0aUlbk0e
	YtEDaF8AcfIoamIdDftpns6bNKb/2ho=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WSfszXCI;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192598; a=rsa-sha256;
	cv=none;
	b=Lv6K3Sk0YQnraOZoP5OpS8+p3XEzcYimYr/6DoV5DdwWSbSpDvysug25tBFtlr4vTBvsi1
	UX2oBEModBu6PedyH7tLHS5FDLQ3edJOjFRjaoBCcpetD84r3++CYoVbjr8mex9JGMmKlx
	IwpKMYJaJUYZsdecMEYcydrsijQP3WQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eTIW0e9wG6pgXoJqtpclYC5TuSr4GLdLxR6Dc7Uapl0=;
	b=WSfszXCI2cH4MYiYLmfGjxXxx7hc6httaki7Pmj8EXeRta6FFQ6DtatbNfoiRT7mSuklsT
	ebFy87btn5Eu+xX3VT47u86+KwUkQSCFn9rw6jszC75SdGfGWsp3f6yeC+tsuDlZvmo2EJ
	wZNxRB4edhcV+HePNxuA9a5YMjG+y+Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-K-SZE65VMPyRQtjKT2-DlA-1; Thu, 07 May 2026 18:23:13 -0400
X-MC-Unique: K-SZE65VMPyRQtjKT2-DlA-1
X-Mimecast-MFC-AGG-ID: K-SZE65VMPyRQtjKT2-DlA_1778192592
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-44a52d5e572so832509f8f.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:23:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192592; x=1778797392;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eTIW0e9wG6pgXoJqtpclYC5TuSr4GLdLxR6Dc7Uapl0=;
        b=Jvuz2aCZkJ4mfBLwbBwxz3n/652GOZvKUGx6nYBauH4L+WpFbQP96q8weEChhlV2eZ
         7e+ueh+1d7nQAKI2tAbtURGInxCG6X5ndAC6pFqxwxHhBfjrUdLtiEmR93FnSJg2dkwJ
         QRTpiF/u0FWbO0KSSXPrqTUIBim4vjfYkDGT8Sh5HPPmzqJCiEeA92bsQgD3q+Yes2xK
         awLtkI5oH9KoDIon9jYVZDLayRAr6U8ELNJMMkuMfsi8jcpwg8qlDrHys0oTzgm1vzLC
         QP4MZceoXrnaHSFgNjpxs+6WzLFyheONp4zzciFaSIZEfn+S1g1s/ZNrvDleOwi1i4e0
         mCWQ==
X-Forwarded-Encrypted: i=1; AFNElJ8I8lD37kxyZJfTviUq/cok84pfakgE4+o1RlbrNHOxMJ+evZmxyuI+KconVIbkOGsV6KZZy/Q1Mw==@kvack.org
X-Gm-Message-State: AOJu0Yw8Rq6ly8eG3u2dJrXqHfX36FN4q9fcTASR8HNzkElMEoTqc7nD
	1rflNDF1IaABv8dgYFewddmGUIUMFV40peqOGYJKrsRw8LzQGLsGit2V/QkcrLiyQJ9szC6aVCN
	rYx4P0Bvyg4Ll9/BITCUCfXPjRvc7mUCloizebjRi1c24mUM6NCqV
X-Gm-Gg: AeBDiesY5E+1lt5iiI8rYRfsbsCwcM+o3/9Cw6gjPU+ZzMIp3q7xBleJ1VET7phY1jc
	iRXeRU8ZdRDqQ2rcxuoE4+U6oStGBABQu7mjZ5iFxQYpQx4+oYtA/Q4dbTmoFn9yDCTDie83Ncu
	yCZTusVSDKRFsSEGjLgXjjfIr+2bWu4MesXZDmh+eSLFyU51dhkpmFeGXVY0HUlyfH2u/zyK7Pk
	gQiZrcZqTQiYTIHfGqtcc1v0r/2fQ7MuyUdnY6+MEPdBQRvze/W96fdHiqkIFRuUpWk1Duksg/q
	IAbrHl4ZYRRRg8tliF8QOm/xrBaeCGFI8e61karpziTJ3g0I33a0cXxbCHOYRPbOpLIb1Gj2ZQe
	l5dNrkBneihs5H0pkDHeUPr9jouW1Si+fYjcR1Wtg
X-Received: by 2002:a05:600c:b8a:b0:48a:56de:d620 with SMTP id 5b1f17b1804b1-48e51f32ac3mr161298695e9.14.1778192592266;
        Thu, 07 May 2026 15:23:12 -0700 (PDT)
X-Received: by 2002:a05:600c:b8a:b0:48a:56de:d620 with SMTP id 5b1f17b1804b1-48e51f32ac3mr161298425e9.14.1778192591788;
        Thu, 07 May 2026 15:23:11 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e67444baesm2942875e9.8.2026.05.07.15.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:23:11 -0700 (PDT)
Date: Thu, 7 May 2026 18:23:09 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org
Subject: [PATCH v5 15/28] mm: page_alloc: propagate PageReported flag across
 buddy splits
Message-ID: <bc23fb2946fae1c16af9fda96abf9744e8637adc.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jsNTwTYNMrVyv5nwyFGa_EmYXvnJ1sA6i2euhKgGPRY_1778192592
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: hh8de3hb6hi1akba1hqcbd1wnynbj8yt
X-Rspamd-Queue-Id: B2DE11A0016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778192598-681362
X-HE-Meta: U2FsdGVkX1/ppgUNlVKLECycgifFL9xbsbRTM24oaZWKfOTq61MtVQgiNmH2nD0R8Eix+plvxi5L4/oqUyjwbbd3FBTaphTFpW/B+0CvM0nTPlb6TsDKeLgJ8hQ13Pz69pazuuFeRwLTzkxQDp6bMp/JMv36tf5X5RphM3Q4ZQA6oUt91OpBnHpOeq4A0S+0mep6owhPJDmB7FBXJ2Dt9cIHuhqtr2GkNeqial0M4D+RB7RPlhvmRoohCt4rkzQtyGmsgp0kRdTLhf2Yu0aXFHwI7fF4Atzuyz/AqT7SQbEsn49GcstPaVjuX0zLOk+ODXTml0uZRSRj4iUQ/Ukd+woIYv+hcduV7teuaenB4pTiED0/4uAkOQrfafBwRT5EUogkpm5BwbCj3r216trhN1/d3dieRBMFhNloFSNTzD4LS2pzadzdC7EVCiWOl5Y05pioF0Tabg9Ie/jOOvyaCaLKbViaGad9PYCKns/WRxDIkLXXKnZ/8cvqvCUJqCMGXAd0XBuRv3OjM8skisMS/40ImxzM6nyAWbkcxJKgFlcz5Kv/ul9f9gp4K7XE730Mf/NZggKdshOEIlB/BKnX/F6SwK63KTDkWxTzmJGBJ0zawwfOJc4uywFlYLhFPmWSn3NU881iBun+ThkP9vGUqw9w84CWjP14B1N3pr8qny8BMxHPBv1+9kLNrmCaTMBkA/1hu8//Ey9ecF908IsGFN7SftB2711aavI6kgRx/B02JPj2dtRq3MsJ1C8ViFOl2vcdjU4e+VPm/Auat7UJYcssPyHkuU4oa9co6nv//0jrKwIhM3sN/o7ze5Yv4VBAFEo7ATdkq7t7KhTbEMzyeij02fyy3AvLiqr93MHbl7wkyF5zwwNWyH918AHH645wz2j6JQ1TQa9QwljfYrxfXrE72AiHwAo9Wmmd26RCb7qpgmxa885x67Zb+kp7SEf5X0Jr2Rug8uM2f+v/iOe
 APd5UqXT
 7d+DSuWiqH4/3/Stu+Yel6elBeQvUCv8JJFZeeertZ6H1bVzNvlLFe+FpfPiRiYseYoilSaca2kJ6Mdn5SwFmLNqw93Nmh0HtALgBDdwnnVDWekVr6GCeOfvWFY/atg6dhMhAwhCR3Sjg6TwbO2WrsRa20GbmEUPyiAs21G179lZJhZ7avZkXNml2z4HUH+MvLqHTUjM1wbYdGen3ELYyMiser5huTMW6Hfd/RrvxXCmrlbth/WFVuIOLICvNEjAQ6WCcBsJYVpfuuoMveg5x13aUewDTzz86srM3RdP9U8OAyxgk0lRg3ADRJmEsgMP9xpJs5JtCStRautmubsWyRdBD3PZxbwj+YrSFLbQ1CIRZkPBWB3cUr4Lh4fBAnTedltj/eiDlDP5Zpd7yc80Pd5TUK+WcI9aRvDaH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a reported free page is split via expand() to satisfy a
smaller allocation, the sub-pages placed back on the free lists
lose the PageReported flag.  This means they will be unnecessarily
re-reported to the hypervisor in the next reporting cycle, wasting
work.

Propagate the PageReported flag to sub-pages during expand(),
both in page_del_and_expand() and try_to_claim_block(), so
that they are recognized as already-reported.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2bfa9ab60976..127b343d3783 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1730,7 +1730,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype)
+				  int high, int migratetype, bool reported)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1752,6 +1752,15 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		__add_to_free_list(&page[size], zone, high, migratetype, false);
 		set_buddy_order(&page[size], high);
 		nr_added += size;
+
+		/*
+		 * The parent page has been reported to the host.  The
+		 * sub-pages are part of the same reported block, so mark
+		 * them reported too.  This avoids re-reporting pages that
+		 * the host already knows about.
+		 */
+		if (reported)
+			__SetPageReported(&page[size]);
 	}
 
 	return nr_added;
@@ -1762,9 +1771,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 						int high, int migratetype)
 {
 	int nr_pages = 1 << high;
+	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
-	nr_pages -= expand(zone, page, low, high, migratetype);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2331,10 +2341,12 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
 		unsigned int nr_added;
+		bool was_reported = page_reported(page);
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
-		nr_added = expand(zone, page, order, current_order, start_type);
+		nr_added = expand(zone, page, order, current_order, start_type,
+				  was_reported);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


