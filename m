Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC7ECD484C
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02FB66B008A; Tue, 12 May 2026 22:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20F66B008C; Tue, 12 May 2026 22:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E103B6B0092; Tue, 12 May 2026 22:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8E796B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:21:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B37314069A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:21:37 +0000 (UTC)
X-FDA: 84760795434.22.1649FAD
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id B12EE4000C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:21:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gGJ7WfRR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778638895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jtTSPXXssTR71PJ7XGF4Aw7pwvwBqg7uPvuO6u95H7U=;
	b=Qm+NQZvM9nyRnNQIh0Y12I+zle1z4cujufc281Gly/1IaGAGzDvPWcGHtqFIEQ+RNxNRDc
	l8/xMQ6diGc/w0bfrFF0/5HPZAOCYr+2MjAOJMozX3lNC3HtInxN/DBP2usrV2jam0VQIn
	a8A/O8AyxzVLjz2w3XQ3z2mWj5sANUM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778638895; a=rsa-sha256;
	cv=none;
	b=4+y42PXpHnX6+37AnIBZ+E5jwN4p3LxVXvL1sdm1lvOSwDy/7n6RWQJNq47YdpcHHbLAgY
	2ql7Q7lfwIvd7Dw5TQ+fL9eer7S285P8Ee+/a+5c9X3qCQdFDKz7Aj+Mift0VgOAzADePB
	vB0EjC8aFOhV3FwgR2C5mIRluyto0wQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gGJ7WfRR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778638894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jtTSPXXssTR71PJ7XGF4Aw7pwvwBqg7uPvuO6u95H7U=;
	b=gGJ7WfRRA9Ncvx+sOdFxjxX86MOf1fGTu4EuYEp7EfTD5vqew87JHGqJ/tcNqpVLAMjibi
	lLS1GyawOgt/gohrHcBqpx4C+7Bw4bcrElFARadK01lVDg4sH4TYruXj6X8JJezCG6x5m1
	xG99Ib1EqV5B3Cggdd5doG0frDLzjJU=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] tools/mm/page-types: Fix typo in madvise() error message
Date: Wed, 13 May 2026 10:21:16 +0800
Message-ID: <20260513022120.58033-2-ye.liu@linux.dev>
In-Reply-To: <20260513022120.58033-1-ye.liu@linux.dev>
References: <20260513022120.58033-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: B12EE4000C
X-Rspamd-Server: rspam04
X-Stat-Signature: 9ndu1day1jc1so5k5jyan4bq9jk31hi6
X-HE-Tag: 1778638895-683369
X-HE-Meta: U2FsdGVkX18KssvOWIi+0u4MgrCJErEVMGSP9ZG/Avj3q4xePbRVj8wzj1ieT4G0pwG6SYvlR3PBCFx17XoHoS5YFs5g6KAIAogYWODsCG2n8vOvH7l3RvJGBY7IDwzl/CIXD+MTYkrsaqNQFCsETb85vOvSSk9nHfZPXtLmr09+dXTzw1pBh3h8WkfJqc6kgB3YBo/Rmc3XRWJ731jQx/8LviCNCdcKNAEPOrwLPpFg94nSqP13/YDYqbW8bvfpUztwzYw+fXS2rbG9Uu5U46aJlXVZnJDAz7xOulScbZdMdPb1svkoP9FCjmdmpQP30omjusjdCy1fGvtwLidgjzrOVs5RGdBILBCjIEmxzcsKmaV7be5SxrTnh7Qdu9/3OQrDkLj2/bhDEDMsNXVNGm0zcHFcDQ2q8ubqklI2ICygWk6u/Rk3YF0o1Lx3GYLs2brWr1AAiKX3Da8OOmKQxfLudeGj5rAeUoCYNkmLT/FcsV+fbe/NVIWnypCNtN4pBQK2IXtt7yuNNSDQashW40ok3hZC1KVryI68zKatdJ0heL2A5Ii06t8UwWf0GS13+B/kUUO51etYqxLlJdLwMYEGkJztvxXccPXU2wz29ZP905tWxTVfWSPuXen/ieCgtOlcBRN+BWBGbX9Njx0lvXRfxxNDUhsuRvFB1+BgxRThWGhW3WO3KfaZN9E+Eisgl6fQU+4RRxFvxx80kYQ6DaLnkVKIAXex+tSme6W+13utVmwWZbtXNU8IFyKpvMfoIwQgJb8z7ZQxxGEIuczelYkqDpSyufaN1QBKFgHgNGdZEq5hpnD8KJXI2Kxxx8Vzichr6JDWAex3YUIbAHqVyGtkuhrEljC88s6xNdbrc/z0QdThFNMyfbN7WFNBRVeF9h/MkE4PsioCs4dSNfbhYrqYKupQ5YZPwF4O+INwFc7wOXHwZcFapqu/AqxW/7ITDYB+/cOIb5oglMw3ToB
 dPuMFhRS
 aDfv5fqitiXZTZi/0F38vjsYYJRuVEgncZwlKUqGBU9/zYG40lQILOBn4e8YbeKXGwlXcw6Dg2SBWuravIoB3N4JmYfXUmJgRqRisD1izc12PgIY5So/4B2FFr9k4GAz/8wsb4AYgdvv0ztDGTBRunr0ObaS5PBBTUsI9JLWuLnQ2Pc3YXx8qqOzKbB5hoWQQpcKW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Two error messages incorrectly spelled the madvise() function name as
"madvice". Fix the typo in both occurrences.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 tools/mm/page-types.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
index d7e5e8902af8..6594245217a8 100644
--- a/tools/mm/page-types.c
+++ b/tools/mm/page-types.c
@@ -997,7 +997,7 @@ static void walk_file_range(const char *name, int fd,
 
 		/* turn off readahead */
 		if (madvise(ptr, len, MADV_RANDOM))
-			fatal("madvice failed: %s", name);
+			fatal("madvise failed: %s", name);
 
 		if (sigsetjmp(sigbus_jmp, 1)) {
 			end = off + sigbus_addr ? sigbus_addr - ptr : 0;
@@ -1015,7 +1015,7 @@ static void walk_file_range(const char *name, int fd,
 
 		/* turn off harvesting reference bits */
 		if (madvise(ptr, len, MADV_SEQUENTIAL))
-			fatal("madvice failed: %s", name);
+			fatal("madvise failed: %s", name);
 
 		if (pagemap_read(buf, (unsigned long)ptr / page_size,
 					nr_pages) != nr_pages)
-- 
2.43.0


