Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4146ACA1002
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 02:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 682978E0006; Mon,  1 Sep 2025 22:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A338E0001; Mon,  1 Sep 2025 22:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56FA48E0006; Mon,  1 Sep 2025 22:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 476BD8E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 22:58:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8742BD16D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:58:53 +0000 (UTC)
X-FDA: 83842802946.29.08C5C61
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3911BA0004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:58:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PH4fXiV5;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756781932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=lDKqAc2JPnV2X/rTVlm0clzzVKcYaSpck5KBRSBYlzA=;
	b=oFDzGHoNXviyPM/cTAKrfCWQvT5iT5edgEthPmc16pEwJaGd8S8WYQaIjGa9dCCT4zB9jv
	vlgGsaaWciAlXTpQ7hKiZZpR9tTNRk8CDvt4go5nhUPbXDBLdZWO6eWqovNHylQpFDMlyZ
	BUrkuXMMHz41kvRU7vVKfWuWLtubx8E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PH4fXiV5;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756781932; a=rsa-sha256;
	cv=none;
	b=JAbF7rNM66KCzS+Wnyv24hS5N939GtMpydN0V/uLSs7hPok/xFJW8Kmw9ehpgbwkXRzL4u
	4rBOLaG1CNhMOtd7j24dzqX57y/BIDkX+Nu6JLQviKxXlBAYfuQBV9QtnGzoUm8cAdJoHE
	vv4fz60BcNtekbA/uFBdLTnvr0ryerM=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-61cf429f4c2so8386412a12.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 19:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756781930; x=1757386730; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lDKqAc2JPnV2X/rTVlm0clzzVKcYaSpck5KBRSBYlzA=;
        b=PH4fXiV5C6yE02JolqAdNLVcehvnl5b6qIiT9PTpp+ArSQsQ0MsQvrQM2jyvVsvYFU
         qGdoj6ShJWF11+7wE0G8QCt6z1/pcRI+YVEdV+mzqVTv/In58DwRFeYg9OlyHXW/Yn6a
         iTJktNr1m4G647N/9BknYqKy/cnDCDuKd8TsDgEZofO4FVHW4d4823Fdm0L8AaYd5vHi
         tMA69tS4khvwtMy3XuARooKgUXFVoH39XYIZeL6We4KZ5hHAoLsy33tIt/ht4N0xP7Hp
         llK3sux14jFOipbaxT5ZFLA4JNcmyDTNj5op44jH2+OJdiC8pjjHjmX+mUoqa+U6Sged
         4TpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756781930; x=1757386730;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lDKqAc2JPnV2X/rTVlm0clzzVKcYaSpck5KBRSBYlzA=;
        b=CdKaiiolgY+TQJiSpm0iqCxToWsN3IxRsx4PL6ZXGMMO6EX2G8uHlWV7Jp9m/YeTlv
         Gj82KPHe4gg1mxWWMt3WSK6P0AWUzlKPPrGwkHcbWji6Go+eSyXwnu/w1R65d4MPUzZ3
         1D+1pH/YHqcFwH1mKGIJoRToCveqs9K8WxDjcFRR+BQNWDurIn8xIfsnlj8GuhpOQ2S6
         5vjgEU94vMElA+p/OCzvvFeadfdiLx6JBZVSY8nxoY8TjoH9jbrwYGXDr+BbGBkegL6c
         VDPFlGYbjILNJndlc4SeE4Sr3TGPoDXhO3q8vd32w61CGozEz6cfZRKqxPFmLp3w3EnI
         n4CA==
X-Gm-Message-State: AOJu0YzTWzussFKAT1MFa2ezKIVfKxDrdxX0fQKqLGeLBic+KjDPjtY7
	2ATO0w1pBb50echHwhqjNWb1HCVPlI8Hw5EgZ8QZu7zSwPbEVxN2gT63
X-Gm-Gg: ASbGncvjha/W7h70X127O4OEvRFfq31F54d4wChrrYORasVjIlMDwQ3azaUu9XW72In
	Vg9kjKFZiPBLtIhfKQmUQAfzqltwdmzyozuGl/RLoqe1+sJFeTPCgQerpcY15PPGvEXx/sh99zf
	aPR0xwYnc3OeMAf/c6Qjob7I8UHyKzvOYyj5f0h/DZX2lkwStH1Ck9j9mXkaP0T1mGuR01Z1oRB
	RyDU9vEZNxPUlfdX23LunaQsEJMkpAkzQHoOeSsp0db3jkgg3cWZEVuCzOLvsRK8LoGpdpdS162
	I5aABT7gEspJM3FYH4NWzs2I53Yx+ik1DTaRYDDdc2f97rRZJQxjwLEukYk6BVYXrbmCfvnQ5A8
	wvSwVupGCP03IVGnDsazNYj/G3Q==
X-Google-Smtp-Source: AGHT+IGinlz4NpBoEdvjGkoLdg+Ud8pZq7eNputgQ7f3vA1eStmb4e8WiOoyxBqDYi4GQktalEwaog==
X-Received: by 2002:a05:6402:518d:b0:61d:8de:39dd with SMTP id 4fb4d7f45d1cf-61d26fe6c35mr8791206a12.30.1756781930525;
        Mon, 01 Sep 2025 19:58:50 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc4ea764sm8444460a12.40.2025.09.01.19.58.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Sep 2025 19:58:49 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	vbabka@suse.cz,
	hannes@cmpxchg.org,
	ziy@nvidia.com
Cc: linux-mm@kvack.org,
	vishal.moola@gmail.com,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>
Subject: [Patch v2] mm/page_alloc: find_large_buddy() from start_pfn aligned order
Date: Tue,  2 Sep 2025 02:58:07 +0000
Message-Id: <20250902025807.11467-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Queue-Id: 3911BA0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: i114r357qczurefu7wodz6abza797pds
X-HE-Tag: 1756781931-464311
X-HE-Meta: U2FsdGVkX1+I6TH9tY1c1G1Fmp6F+1xyqsbvEHdzitHRseocY2OljJF+70oc9IaWorAvEt8PFo1SRMcTdrGDUtwAWXHDW+TGPabOo80wzEYrkKQzUAq+Ui8xpEykZp6R8Mm4hsPVPLk6+1XMiHpBocH9oV5aATxwUvNXSt89x+L0dlFULlPRqlETYIQSUzA3RCSSBFruuV0JzmZTtKvcBUi/bx9YEs9ZV6aYVW+olEk2Zdo8Lb6M7OVTQIQLC6XE0xdNvs4d2QDMPh5BjjAQeWx64HSf01sZ9jvcuVgOaJjTwCXiA/0pMHqvTv1SJJXASo4ZFtZ+jhfjtu87ifhQv3cLJgGFo6o+xxjZOvqRET9/TdYyFjzWAMDf/yU6yekyIsFaCVN9aNjpNTxyOBiyeRiSH1iUWaT39ujR5/LCxwWVCdyA8DtQIh1xE4ZUyr7mrCQIA/ElCOPxXfhupGMNfcbEWO/IbFp4snXLRPP4TISOsofZxsdnkaH5cRsnnDZJoFnbQrpYMyRZoUEy0RFAW0amjMQHkRWo1MCNvlQdur7JFvCIHUx70Gh5h+NGQYlJXnXNubgeNLetmW7yelB7WZ3ZDccHWEIajC6O2/XuSYPXdhFFutQ9wpldGQkFZvlPplYevqm62bWtYHKhxT+2RmD+U0qfL8Ct+j0CZafFBpVzxTwTTQPFrutvzHpVOAU1snCmpv77Cgsh4vQUdBw2iGpj1zg3dK6kFMOVPL54t3JIThI/jzdGvjPn+5h8sYJ5eanUo3jTdefhrHmMST3WUruYYzsywP+Tz6LWMyu3nLad7CEdEcBi3ntr91yB55hLtZPWvQbQ4Wsm290CPBn/FPjylli51CIklHmdozMOtald44QVKdKX4klfy10R5Kru5kAzDKCH4eNDyErZ9kjL/FjcnN/0S/7nEModKUXIq92jZmmvq3ucHrvJ/ndSDK4NK+5bVSVkmCNDzXTPBAF
 h/MBWEE7
 gBgE/2S6wB8ldViSqPIWyU/CKDYDgGdnFI6M9GIQyvruXP9JopOvoXphZo5wvoYUZkIDmtinfFTX0fzXMqqKkGSqBxB7zr9TdIRngxWJVbsy+d+W+E+MY+kjP+Yds9HIaN9NmIqEB4jbjSiiTa9cNt8I0/3XMT43LADNIY3v2prdRnUCD4Jx3qQEm9kmAWcDFlbO+QdHxw61HLk86cy7IWiVRYLOIZTT26ZKVoyiUCZTYt2yOXQPmbri8g129BzlvcETiII2VQuRqm6KyGLeJ467PA9shYxRlkGYEQSjpwWwEXRNTRzLW3ERWu9N86nRknVBYwKGE31Es93T74IJ+xwPrCNFfUhBdPHatr8liYwMz2FhZtiebK91S8TIQPr/0OxHq/WTwl1u3FBsJBgOXetFNTGvQW/oPJe76TKcrqltUR9cai2EU46w8nWBLZX0wpYUMUjeAhAF47Ub248kKs6UYDJCgl5bdrk3d0zxaQo3yMEghI5dZ1ksr1FfTEzdg9FOjTWuZe4FmQ2WG04EfcQKDzlL69bfY0qScLEx/z2BAelQk4RiOuRzi58IPIRjMGeeVaO51xKu1RSOIrPW1BMiXj+9CtjtFAqR1Wou6lOM59c9EEB8kt6/y+tlk5NT/EaN6FrfgF/a4nAuOdtKmdK8rS6yhGEmkrxnjApG8FhzBiGZcKZM8cHAy8fyc4ZQiT3c2B2HPCXkaXN0kSBQDnMtjTnCY10Kw00kyrmNjwdgTu8Vvdt5VstC3MpV27znoT5hm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We iterate pfn from order 0 to MAX_PAGE_ORDER aligned to find large buddy.
While if the order is less than start_pfn aligned order, we would get the
same pfn and do the same check again.

Iterate from start_pfn aligned order to reduce duplicated work.

Link: https://lkml.kernel.org/r/20250828091618.7869-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>

---
v2: add comment on assignment of order
---
 mm/page_alloc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 07d79ae557f8..5d9ceca869e5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2033,7 +2033,13 @@ static int move_freepages_block(struct zone *zone, struct page *page,
 /* Look for a buddy that straddles start_pfn */
 static unsigned long find_large_buddy(unsigned long start_pfn)
 {
-	int order = 0;
+	/*
+	 * If start_pfn is not an order-0 PageBuddy, next PageBuddy containing
+	 * start_pfn has minimal order of __ffs(start_pfn) + 1. Start checking
+	 * the order with __ffs(start_pfn). If start_pfn is order-0 PageBuddy,
+	 * the starting order does not matter.
+	 */
+	int order = start_pfn ? __ffs(start_pfn) : MAX_PAGE_ORDER;
 	struct page *page;
 	unsigned long pfn = start_pfn;
 
-- 
2.34.1


