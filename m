Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77CFBCD8C81
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B626B008C; Fri,  5 Jun 2026 11:36:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 804176B0092; Fri,  5 Jun 2026 11:36:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719686B0093; Fri,  5 Jun 2026 11:36:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE4C6B008C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:36:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 03A9F8C26F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:36:09 +0000 (UTC)
X-FDA: 84846260100.12.76C0669
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2CC0F1C000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:36:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VXdtNE30;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780673768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5dsckH9YwlwdD1mktr8FrA3biFKCktv90GPZj2FBiQ=;
	b=LmEN2pR7gpeiJrjAR2kGO20SmTNwQvntZ9pMzL2lwgolREEeT4DI3hmzrCmYb8K8NBbLGJ
	6QSon1xlJBIersEsoSV7SbZHJ8g5kPoTGF49TqBH+f1wM2dwVyIaTeTt+iuD+268fcNqd8
	7eRpb3K+jxuUOaFC3C3/IjatRfFcuuQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VXdtNE30;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780673768;
	b=PhgiTwnNNU2iUtcNXkWNy0KJyFcR4894P8/7Y9Gmw17c7D0+QxUYEKWJb+fc/jJEhT3lv5
	U+6VKX8MT+QML9OZkgNwNcdFcHJLNmttqO0EG52GfV7TKsSYI9KIX5vL3F7LrClqBWckyX
	Hv+mudO4Ss+QcKd/UKgo14KW2YF34Ss=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e6fa36a1b6so1460961a34.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 08:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780673767; x=1781278567; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J5dsckH9YwlwdD1mktr8FrA3biFKCktv90GPZj2FBiQ=;
        b=VXdtNE30LfOySVB7I1OooBSZqfg0GIwwDsL5P8DU1FnAXmcr1x/171LRtCnx0PkVLB
         HCdHT95j/1bPStiwVFqjucDnMvsr1hkMl3zi6A/dmGAYjO8JKpCv7pt7pGaDYlwM00rj
         ySTUEh4xjNJeqa7FoQuWm4vDWtmIL69U++eI42gIl69aAk+jwDDE6MeZaiJUPKBXbyGi
         wZrn4TQ4DRCryAw8B0wDi19FR/jMIRHmXQIH4Yj9KOyVNXdFpHPcddJ5swAEslGJZtZ/
         lLDCvjYuUhqp0ZaPmcginSt9ad6Ru9jUbUx8xAyC81/K33CBUKFBvpQQ4rlykhxizwyB
         Mh/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780673767; x=1781278567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J5dsckH9YwlwdD1mktr8FrA3biFKCktv90GPZj2FBiQ=;
        b=Xe1ZR5rxCbmzZYaZ8EMH1KJi5xtsS3BEO51wXu7smYFBEuWHZIttWqKbgwXn1Mp61B
         XfnVcwm1SWSqLavAu7GbM4g2A4D3OV/hue6RdJc3kM6/bfu72gQONafCUKsEQ7kJLSNf
         cJA2wi3uH3afgJOTkWjfzaM40bmjnrPx+n5Gde27Z0BDO18hXXDPUH66vBDhi/BWfIzr
         HczI8/wIFdh7gFbOei20w+fcS5jbWxDw+DPgD3Y/5/pynHXg90f9/CdXWVY4QFZM3qC0
         efpCjyPyTNDqm1ovHI5lBLTNTbvA+QujmG9zumV+4NvkauU20noyFDxS/+w0+Q2TOe0o
         3ojw==
X-Forwarded-Encrypted: i=1; AFNElJ8CwpEa0nS/oCSCEZ+fyI1Joeu1nadsk0H10SUgm/ICjUajN5mj8ZjN49pdQtHuv3jlkseCdIO4AA==@kvack.org
X-Gm-Message-State: AOJu0YyNdZtnnm4wZg3BaQp7o3qeKCBqq0YkOM9Vj1UxDYAinvtGcqXr
	P38mLv0gTDr35oHR9BSi4x0PPei6GYR/HG6rPFoXwJRvrHryAWLkl5ov
X-Gm-Gg: Acq92OFCQkak8ojl/1jZXFRdZqLzrmkrN3Nc4b9RDEWF03/kn4AQXYicIfwK0YY4Spa
	eXo9EAeW4t3/yTYLlLhn/Afsupx9TMNyANACAL0EkZFnJJkmsgFIueQVxuAreVkibK1R0rwVVur
	Bw8sO3X8zzBIAcOkMcFvuPBU8AZcW1+5g0oWCSlG5Ix9z6XmQPtLkuQSsBSULvHcT2Q/YPFjIwT
	sRfHGYC+/L2gGj2QPy/P6/CIplGlBGbIoDOf2TbiaBHvbVI7u62/OBIU2SzwQH7twWmu8ONZbC/
	fnRvMbmnjI2o9YwQJAMR6p2GaCCZvHJLacxXW0WdrOtg9ePnX6sa5iscERAlfhCyPa53fZJyrEV
	b8mdNHg4RiDlAEroiO5tgo1Lvb7+Dqt+Opmj1wqFDKPPJAMxmtI6OXqwwy3XNa48zzMv7t1+StP
	nlHOIHMyzWw9j/V7hoaEeK9Ttwp4ngw6HjRrsVnpEG60Bkn2abtuQyuVodFcytLjI=
X-Received: by 2002:a05:6830:8289:b0:7e3:d199:3164 with SMTP id 46e09a7af769-7e70c6a605cmr2472371a34.11.1780673767180;
        Fri, 05 Jun 2026 08:36:07 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:a::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6e7468f8fsm6342664a34.6.2026.06.05.08.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 08:36:06 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 2/6 v3] mm/page_counter: use page_counter_stock in page_counter_try_charge
Date: Fri,  5 Jun 2026 08:35:58 -0700
Message-ID: <20260605153603.234296-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
References: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2CC0F1C000D
X-Stat-Signature: bo54akygx4m11qqso3casu4i3jqkngfx
X-Rspam-User: 
X-HE-Tag: 1780673768-742121
X-HE-Meta: U2FsdGVkX1+lVX5o5peUbDuNoyHo2wJ3n8FaVT2vbzjBVfsVefxxwSVEqtf3ybMAKsQA1yzbywR4NlsPQ//b22B4nNldnVEPsORKbmPhnRxDFr+B4ucgzJp9/AyjDMXqhmSTDrsBB0XrUy9NS1JIni/LMM1y2owzy+6mOTKhbOaaJ5emPTaPDtUuoPRSsBiqSHpTeEz+0w016A63QXjlfZg+GefH8aDb2iacIjskXPnBgeVE9vrdbLy77nlTSMoGzMPw0/ga2P86/KEnjurutzH77xh22dchnIUjIgq+0xSrsahsuuISCvOQSBiD4wz69DdxjMFgVs/p2h5XLPp2WICQt9ufzuqqT5Rd2lELt2gVtCw7fMGaupRLuz+H9Pk4X6LQrk/SNKqYmPDuxbTqXyQsCDKII32lz+PEwEV0Yl8KETIUKTCV9pv5Pf6hNizoS85I71kUlq7JaVk8WS3OjtYqCbdkre78rG4+XIqBBgXSRtr06wm3Mu9/BAIx/0GfkygruLHC35lsbv1h/DdtvSDq4mcyj4UDexY2+tG7QrwumOWSnitzzwXQSQjqFUAFyh9vSeAMFEDpGwItTm/3y4Cz2C7PYNmXMzU3UYlGbuniCXp4K/LV6R1zMEhKPplvXPGPbt+G6AZDlwp6/M6LVk2gRfJbYFqheetaaJQvS0R4t+C6+mxTzwruv3JLFuvBdsZldksTei+Ve173gIikpMnvAIx5hq5yP7hsDb+goSgCuJCwjuXEdNlMNLZ6ODuWtO7BdKJtovgsmMhUBvhvuF71z3xKx/1oWLaGot1xAN09KJmchXl/euiOmUDegRaSdYD32qKhrRr34RvNF+d/OpZT7oUk2fuscVdsEr+n2euk/363YnAko/UrrzdtMUxiqFleyYb5t/ybKVCKAGSHw/PzvSIAwsTppUHWqCZ37Pc+dDss8oncc2UNTD683xqNAKsuR0L5jkHSAOkfjCc
 mis4XOXM
 K0gr+Y2xTuIpzrUFeErYo03ADKAYWEKF0m/g87uuuOY3AlXesG3WolXez+8h+xSEDETu89wAiRYIlFkKeLWaVMzd/EASDayD5W4PDeWN4j+4zKCaHfiHE8hmTSpi3fKN0/PnuBbVmTcU+2Og/IEIEKbvyA7jCIHR/bsk8ltaIt3rk3w9takSAhVu2nKUMMiMsE0rZMTTu99sRRJ5lyc2BFcxE/PMxeTK31HHErOq5inmK2byA2v6+4WKrE4oAELq33Fpi+TruraApZzGTnhsYUlJuBWKCk9P/nSwpwRdn4yExKUDA+LRsZKxUW9vvRIKnTJdhtPsPlv3yE7wkMvy8+dHk0Ih2yUYGZtJYJmDdcCZwYZCtOAuSuFU9agn66tCMuP6Epz/eObmHAuWzTYhceF8aYmL069xJy7SY+V8IXfevlPJk3wx+Lt6uSHBJFTp2f8wY4HlDPynXkW/wyYG427JwXy6+X9eYL7P5LFcp/veD5QyKf5Pcp1nIqEQPdRX0TiVOV+DuhZS5PXRNtnu1Dudp65Xr3ROClZOQul/zil1i1JN6C1/bEajF/l057szmPoN8rVtFBy0a8rV1NVYFNW6a1Wseuo1HaRkzS+eK9cnPnRA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make page_counter_try_charge() stock-aware. We preserve the same
semantics as the existing stock handling logic in try_charge_memcg:

1. Limit-check against the stock. If there is enough, charge to the
   stock (non-hierarchical) and return immediately.
2. Greedily attempt to fulfill the charge request and fill the stock up
   at the same time via a hierarchical charge.
3. If we fail with this charge, retry again (once) with the exact number
   of pages requested.
4. If we succeed with the greedy attempt, then try to add those extra
   pages to the stock. If that fails (trylock), then uncharge those
   surplus pages hierarchically.

As of this patch, the page_counter_stock is unused, as it has not been
enabled on any memcg yet. No functional changes intended.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_counter.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index 9f3e3f8d896c4..1a71de4f43fd0 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -121,9 +121,25 @@ bool page_counter_try_charge(struct page_counter *counter,
 			     struct page_counter **fail)
 {
 	struct page_counter *c;
+	unsigned long charge = nr_pages;
+	unsigned long batch = READ_ONCE(counter->batch);
 	bool protection = track_protection(counter);
 	bool track_failcnt = counter->track_failcnt;
 
+	if (counter->stock && local_trylock(&counter->stock->lock)) {
+		struct page_counter_stock *stock = this_cpu_ptr(counter->stock);
+
+		if (stock->nr_pages >= charge) {
+			stock->nr_pages -= charge;
+			local_unlock(&counter->stock->lock);
+			return true;
+		}
+		local_unlock(&counter->stock->lock);
+	}
+
+	charge = max_t(unsigned long, batch, nr_pages);
+
+retry:
 	for (c = counter; c; c = c->parent) {
 		long new;
 		/*
@@ -140,9 +156,9 @@ bool page_counter_try_charge(struct page_counter *counter,
 		 * we either see the new limit or the setter sees the
 		 * counter has changed and retries.
 		 */
-		new = atomic_long_add_return(nr_pages, &c->usage);
+		new = atomic_long_add_return(charge, &c->usage);
 		if (new > c->max) {
-			atomic_long_sub(nr_pages, &c->usage);
+			atomic_long_sub(charge, &c->usage);
 			/*
 			 * This is racy, but we can live with some
 			 * inaccuracy in the failcnt which is only used
@@ -163,11 +179,31 @@ bool page_counter_try_charge(struct page_counter *counter,
 				WRITE_ONCE(c->watermark, new);
 		}
 	}
+
+	/* charge > nr_pages implies this page_counter has stock enabled */
+	if (charge > nr_pages) {
+		if (local_trylock(&counter->stock->lock)) {
+			struct page_counter_stock *stock;
+
+			stock = this_cpu_ptr(counter->stock);
+			stock->nr_pages += charge - nr_pages;
+			local_unlock(&counter->stock->lock);
+		} else {
+			page_counter_uncharge(counter, charge - nr_pages);
+		}
+	}
+
 	return true;
 
 failed:
 	for (c = counter; c != *fail; c = c->parent)
-		page_counter_cancel(c, nr_pages);
+		page_counter_cancel(c, charge);
+
+	if (charge > nr_pages) {
+		/* Retry without trying to grab extra pages to refill stock */
+		charge = nr_pages;
+		goto retry;
+	}
 
 	return false;
 }
-- 
2.53.0-Meta


