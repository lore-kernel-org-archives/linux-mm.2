Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6981BC79F8C
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 13:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB0C6B014B; Mon,  5 Jan 2026 08:33:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2979D6B014C; Mon,  5 Jan 2026 08:33:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A056B014D; Mon,  5 Jan 2026 08:33:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 047736B014B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 08:33:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2CE9B2E40
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 13:32:59 +0000 (UTC)
X-FDA: 84298000878.15.9222FF2
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id E8623140013
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 13:32:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DCkLtOZi;
	spf=pass (imf26.hostedemail.com: domain of suhua.tanke@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=suhua.tanke@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767619978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oJm6OiRS9K3PqeaDgMDkLMzyrlgeIiwTpzJ3FbroMYM=;
	b=C+3DfjAJtqNOAwE6seGWjzdx1HmCbRbPsYwfBqaL2pzA+Zr9SQl/4Q54CFVOWiny5c/xw1
	474WMOMCLczsmNviM8ycZYPJTb4Fvbq2fXQLT5EofVokmKNuI7BpkyyHBVvRxKg/w01RPT
	7dvmB2ZT4oC7SQV9chk3lkIBqRV52RM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767619978; a=rsa-sha256;
	cv=none;
	b=uvUFM4XZfmI4gUFhjcb/d2oMevCTn7/j3jsu0iddG8SCypIMu+aw2AtNohTEQo5qxW6c5E
	FbijR4/8EChUnD6DHd5F6XKbmvKA7MSyC+3nroJVUldvrHaq+nf2NpotKSW+ezB0GphGVw
	Gl+ti6oMh4lLJwmi3+YvEPfyOgFyGDU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DCkLtOZi;
	spf=pass (imf26.hostedemail.com: domain of suhua.tanke@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=suhua.tanke@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so13017606b3a.1
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 05:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767619977; x=1768224777; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oJm6OiRS9K3PqeaDgMDkLMzyrlgeIiwTpzJ3FbroMYM=;
        b=DCkLtOZigXciLYUJeLT4jM/Mk6wpgZShiEXkN5byEIoa3EhU6lE4pWK72j1rdG5zG6
         tZIG4XEs+d4eNpBCaj6SOggAMPnPY4BNNjCnoclu9sQRZBAxJQVhMkiD0CUANybWzjRb
         Ku7naDfo5ddIT4vHqeD1VUu4ajetIOBgbZWQIHlG3ofgXbtO5ov9iEFGB6twvF5d397T
         9Ez+0evCiax9zU/KeWst48Q4K+u1jZwcClsJAj3ysFvudWcrsMiRlS2dDP9zcn8zFZqp
         efXWt7RukfJt+btcK9HIAZQF/ZooY1yM6NZqMzdDOSFzBPUX+gHiDkPFSMhRj6SIZZVh
         nOmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767619977; x=1768224777;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oJm6OiRS9K3PqeaDgMDkLMzyrlgeIiwTpzJ3FbroMYM=;
        b=KAj19lXoHK5hkvAmfpRpYPTkXJeltjY0DIXhe8jdBc5SF3xDytuaX5L0lHJhHSVvAZ
         YaODUE5bNgpxQgxnnpsEDZ02D/llwnB/gZXfz0ishkyw9WJf08oYG1z1U2BB1gqOoik8
         W+pm01DSb5mkswel4btFyJimYvWBalWenLJYD4c+KYsQ9Xyc0464KVtSp283VU/hrUOq
         9YgACEvcsoju5b7pBSCUnXyss7H5OINdeO8uWKCt/9IQgvH86EG4vA68w9j3M6NWOwmD
         Q+vhk62TfS1/8P+nnxYQlBv6Qbv0kO79MAMeqVXHiTYiS7BduCxXqQ3KjebUd/+miD0Z
         +goA==
X-Gm-Message-State: AOJu0YxJU6ajEPmHovPbWnIDmXLo3TbMc6vWjMAfENLpG7w56D1cJKAD
	Rhce+pYcyi2HPy0brd8qHa+MKl8JkQ97P8neHkSoDW+GtzNCuGbRg4w/
X-Gm-Gg: AY/fxX7baypxNNQks/Tpuc6IlJM9qD9HLkHgS6HF/2bBXE+b/40Ff1VbwYsYFCMEGDc
	k8dAemUlcO2/QlsjXmZt7ES/wsKgyPUXwG54uaDKwXoRvE7eqEhTZaQ44ZVsj9kOiN+6yaiOQgP
	vXvnv/lzxGb5TS01edgvi1DXo/P7sKkeeyIs7KtgTcMMlbaYJ0pmEh5BqDb4wfq7ggJth/4ODCD
	4M0hVUgO4YJyOZttku/smKYGPyMxxeoBPz0lekteDv1cY/lJUfNJBhAcJplk0xjdmyeEBOcrd6L
	+Dn22vEKorIaRREpsv9kgeHPigNogMTZn4yEE8vjCVXnVAS+qt6M5nm3TXCPCFTOOh8B7mEnGGm
	s9bTJlC/YBV8ZFLS/Z9stNpUVK/shJkTP4LYxz3QQiEkZX7ZOC27qtDaghUCGyUNkwlUw/cgG0m
	m/L5sVGQYmpkRKTwSw/N63hashQ66W+tymyfJfRTKg1fYfKqQ+mtZQSggcMvljNiY50U4=
X-Google-Smtp-Source: AGHT+IFcfxyiX7l4rPQkTcK0i562jckqNjZwoBg+p1wVoO/k/BzFfOrlmw0VrclwAigZJSDfdEyimA==
X-Received: by 2002:a05:6a00:ab0a:b0:7e8:4471:ae60 with SMTP id d2e1a72fcca58-7ff67456c07mr40295975b3a.44.1767619976607;
        Mon, 05 Jan 2026 05:32:56 -0800 (PST)
Received: from suhua-virtual-machine.localdomain ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e0a19d8sm48306894b3a.42.2026.01.05.05.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 05:32:56 -0800 (PST)
From: Hua Su <suhua.tanke@gmail.com>
To: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	suhua.tanke@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hua Su <huasu@xiaomi.com>
Subject: [PATCH] mm: fix execution order in alloc_contig_range_noprof
Date: Mon,  5 Jan 2026 21:32:50 +0800
Message-Id: <20260105133250.763076-1-suhua.tanke@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7qascjmuwru4p53f1kc1xg4apzktwyqy
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E8623140013
X-Rspam-User: 
X-HE-Tag: 1767619977-218145
X-HE-Meta: U2FsdGVkX1+tSK9dd+Xct1OsN6Do/5JtD72FE3icES6BqKw1qTfaeP3pdcGmMeLnDMfAUOwW2mlS8el4kGopBSViPs7x4hGmmoV0HfTdedH/2qIzh4L1U/5CRNVsB0Kk7OD8n3a8GbXK4EYOAPgsTjbJwn+9CsLWQx8Bqpjrc1S99XVNAl/uH7nBtVByfLziirbnYIxt7gkh5E9Wa8ht5EeWDkFUyZh60y5Q8CHNdHRaJRPzJvgYcIRZdpQIr62y+KHbwuQVLYvWJyUsINgS4UBd9+vIhdEJXvZsJE/Dmre9xUQJqmx5LGOyxTdnLTEyOr/pgdlcqwDbIBwm7Y1mB51pmthofToLhaqfYLRx6jvOVCS8OqX8rxytFMI/NMrMbU6d9DzZWei/jq6Dzt1jADHI6eu8Ygw72dbRj+xCH5Rj1ZTZPa1BE8181+HfFCcHj4TLaheIbnrKdGKJggmiYr5W9GfwMpbZjPpSxq2ge78mym4eHcZ4+H+mipcBruTU+1mv+imIrecRn2EcWvbLapyVnINnz1rGTMufiz9F7Z76wzWHW2nQAq9/zLnnEa/njZUeK50/HLi//kR6cLHiJKfcwNtNPi53C7Cvl15VX4O4O8YqW8KKhhNIYx9r2b4IBZMvLlL3FstJwjTq9tz7Mshjgj5zP4s4LWdHMBt5NztrnftBaXvElUNiuvwZW4voMhLD0eERj49SURFPedw5tgkTYq7qfpwPxazyo4jJZb57LvzUmx6Q3OlAAfK+hG1PtfVrzpd6GPlyoxWl2geYPfdxlcxH5zcFAUjp0eZpxkHhD/xalNy8F7CiW+dlBrGY4xYCJMKe4Dl+e1Ciyz/QRMRaEa2QK9yOW2N/Py0l6fB4ErmwdOsQbUlEm1THzwwZV9IULi846OE6WhihgXuMahaGpUYQjDcxa4Kqhu2mPFEyaDUY2P7q6YnVFIbARjOtBFFOcFfcpSbskbph4zm
 CPn4Yrgs
 Pq6RVdmivgaNUeKjxFRenoQYqnF1x8u3UZr+QSZxpIybGhXJNoTlqyhzD/I8nFVS7kZjvuVhgZAfKjPKUAMwGGv871PGUvi9nMaj/tVAa8wQ2PBgjf72fiakLhCHeWtfs2/L8oabBEbKYB4GBbcg0p56lSF/V6yr3hGm80pUapYsXMMVKPKJ5uyiG1VcDej7hw9jhi6RYopaXFVwGiyBt1jy5oyRAzHYoN4ecRO4bKLIuuhpW9DvkhF8MhXXckmCXUWUlTVEAqCBTLktSs4RE0U1qlAMEGu+GYcyQ8fzSGEZXDAWb7nKa5W2LU0PzthgDthK7u/cDrE5B6fds2a0TKpArMH87j+2kqZiE2+qJkq/EiY7iULozNVc8Zq08kZ3xSbtp9Myx4IKQD8clT+t+zzGgaFRt0ZlraaV0vSHgTDCgGfj2IPCZmGZB3BlFRGplsImUMRCdVlSGSk+uG4FV6Swg6bfd8UvqDWaHiN1WSekCV9Ch1ydl/yRjtHzm61OAept+++SrnmYZhFDlRrFHZt+vIahw2Wi+XA3sJPd8DQ/HpBgKvMPEbU9PHAQeouDQMB5c0+cBjagpkuSYwBPvUpgfeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix the execution order issue in alloc_contig_range_noprof where
drain_all_pages was called after start_isolate_page_range, which
may be lead to race conditions.

Based on community patches commit ec6e8c7e0314 ("mm, page_alloc:
disable pcplists during memory offline") and commit d479960e44f27
("mm: disable LRU pagevec during the migration temporarily"), we
disable pcplists and LRU cache before page isolation to ensure no
pages are left in per-cpu lists during isolation.

Signed-off-by: Hua Su <huasu@xiaomi.com>
Signed-off-by: Hua Su <suhua.tanke@gmail.com>
---
 mm/page_alloc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6a47443c48ff..d08f929ca64c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6815,8 +6815,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 		.reason = MR_CONTIG_RANGE,
 	};
 
-	lru_cache_disable();
-
 	while (pfn < end || !list_empty(&cc->migratepages)) {
 		if (fatal_signal_pending(current)) {
 			ret = -EINTR;
@@ -6850,7 +6848,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 			break;
 	}
 
-	lru_cache_enable();
 	if (ret < 0) {
 		if (!(cc->gfp_mask & __GFP_NOWARN) && ret == -EBUSY)
 			alloc_contig_dump_pages(&cc->migratepages);
@@ -6973,6 +6970,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
 		return -EINVAL;
 
+	zone_pcp_disable(cc.zone);
+	lru_cache_disable();
+
 	/*
 	 * What we do here is we mark all pageblocks in range as
 	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
@@ -6998,8 +6998,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 	if (ret)
 		goto done;
 
-	drain_all_pages(cc.zone);
-
 	/*
 	 * In case of -EBUSY, we'd like to know which page causes problem.
 	 * So, just fall through. test_pages_isolated() has a tracepoint
@@ -7076,6 +7074,8 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 		     start, end, outer_start, outer_end);
 	}
 done:
+	lru_cache_enable();
+	zone_pcp_enable(cc.zone);
 	undo_isolate_page_range(start, end);
 	return ret;
 }
-- 
2.34.1


