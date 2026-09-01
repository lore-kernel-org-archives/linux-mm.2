Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96456C624D5
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81EC96B0199; Tue,  1 Sep 2026 09:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7B56B019C; Tue,  1 Sep 2026 09:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733A36B019D; Tue,  1 Sep 2026 09:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 546B26B0199
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:19:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4C961A0405
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:03 +0000 (UTC)
X-FDA: 85165248966.24.D303FBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3DF104000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ig92mQta;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VvO9nu/pvwrT8AJnGanMkEVbhfeAa8vp4BSGaiM1GXg=;
	b=BIPaeIpECS0jiFYWv1Gjp/duM396sqemT0+QY6hg1uZeJZuRC1nofPynapoLLkgnLFwMk7
	MR+kTi4FNb92Y7d3SFajm9g24OrRaWdUIIMG8msfhoNGNYlAxuUJ/jzoC/s3eq6/RcoYGN
	AUZVuMttp23wcBuy1JIvkxQF02dS+T4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ig92mQta;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268742;
	b=DQY5yK5JdKucadwFIDFhwxoARLQJ7E9hd4LjTQUHfaLPHX7dzqLhtbvfdopYFZFm1AKp+c
	8YmpgwKaarVnC7LCyvSDVZlX2r2jgynfwQBcSoWnX1EmvwtVT+5k4CiCPHq/zobIJvUtvf
	6zLRII9jMZx96KW8PuHSAQwcDBLHcvA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 911B642EA5;
	Tue,  1 Sep 2026 13:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452D01F00A3E;
	Tue,  1 Sep 2026 13:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268741;
	bh=VvO9nu/pvwrT8AJnGanMkEVbhfeAa8vp4BSGaiM1GXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ig92mQtakTdHt0VVFboiQzpG74wWcUaalH06d9B8H+DqFvf8O10xsK8agpzNt48dI
	 J6z78dAJsmkAgL1bGwzouj7Bo1tsFXUwjGUhxaemvkiP5iJj5I27039kzIr6sPksz/
	 JmcUMbUDgwzghHaFtsLePi+nD/8bOnxkGtErWkZTfW+jquJlWqsN8qC0LBAV4yE2Mh
	 E6LBN4vo828WsQkUMz4FEZZroCbmbvGpWvYiJZv6EeK+4lqNiYuxidJqZjeLKjMtPt
	 iXRCXVLksLVM8WMlccLkVlGFJDyXyLeFnLG3uFITa+I94BxAVO5fXbh2YuVmqx6CPS
	 uPIFRnMKnnwDg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/8] mm/damon/core: handle extreme memory state in get_in_active_mem_bp()
Date: Tue,  1 Sep 2026 06:18:49 -0700
Message-ID: <20260901131850.98037-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131850.98037-1-sj@kernel.org>
References: <20260901131850.98037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3DF104000A
X-Stat-Signature: rhe9kwsqf1x7yqodsyrr59a36tkyzq5y
X-Rspam-User: 
X-HE-Tag: 1788268742-369728
X-HE-Meta: U2FsdGVkX1/WYOKX90owMix8oINH6opLksiBwS/1tD2G0x25lij5135FpUVwxKIkIKJ26Tp8nT/eShhE4Pmim5cQFCapLDEduQxe1kuEhWmvEokFCKAf/uI0hgfdjV4yz3MfCQ4xURaU/MFObIT8od1Qq8OdectHHyZ6OBMnQ3c8zQJ2FBblffJ77eg6XuhNzfz1mqN6ERWWQZ9dvHpzT5xXEHpOEZ+cV1/WTCrnFXqkWfMI1AONHr9+RztLwGC3IABd8ME9T8OR/lpyq+RXYIe02+f7Vi2Xz7lP7ofh24yfBBMBJbDaMlhiW7SF4m5nUAS0ft+A+1teszV+lWtbBBkCRbXm1dP1iE++JONyiNgMBggC6gsHmy0Bu32V9WHdcq2dH5btGMuuE+Myc6QyLKLOnq83D5oGUab3VyuiwvWZQS1ANfENmMr92T/uc80YD3dPYh+eyGR+GJfjLRTNSgfqZ6BpLVu9Y1dy6rALG/WLUOHlATd4nE7BqK1rTieXbai8N4NId7O/UL/TyUZLnsgsJtoPYhHUWr8iqAc+SuGVxjRL4EQPCkPjFWaDwHvY+SlMTZLM582EbQ3P5LJEkSmO+cyOCkcZmHxNI6OhE13+ZhUVwHZcRYQU5gq/RTJ5JlqnVEQfKSD68OLzZNwzJKD7TCHuCgGQdFwZ7KJsE2LJBNrQSpY4u+SBezeusj0M3W+U2DlTtecRHxx08SzbglM2WPnuqNKuGmxWtzPj1FAK9KjFUUhq0HkkC7BKAdhKFyN72iRy7NJkiyDPFp8Kcv1aSvnX3E7CHjrlqO/uI2YqkuoR6HtlNToHJIt6EBaAKj1JrVwOpAqZJDt8XmtXAJ7s5S4Vb07ZQM7yR3GweaaF3SHZrrgp6eXLO4i1lvT/lcvzbQtvx9Bj34Tb2LEWUolJcBLbbJB0t/4/SeNK/4otESevLhpKVwvReSCs9B6OYjFu0U86v5BMZ2Gzsan
 sd3D4BGm
 jpetKan/OTdzaWFpbcx0NC5iKPSUpwus/ukD8KEN52If4hynUADfz9OME53NUdEl7gza6NZVeNKcSI11Tb7U/pKgxYeHbqZiU7cqRCf6m6X/S0P2aAcQuRaRP1sjjnyUuJ1cGqHDqtpZKF7v3VaTrT9mR8SFVQJ/jp6/NbtODI04UGnSTiF0U8yecDq0QwP11EaHFrXVb57CmgXqd2viXl+KSpqVQU8/569fd1rAa4wFl8GTsUIwuuA2YztNzyaTVhzVkCmmggaiTn8GexTUnNqmTuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_get_in_active_mem_bp() uses the sum of the active and inactive
memory amount as a denominator.  In an extreme and unlikely environment,
active and inactive memory might be zero.  In this case, hence, it
results in a divide by zero problem.  Avoid it by changing the
denominator to one if it is zero, before it is being used.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260721034756.147011-1-sj@kernel.org

Fixes: 4835e2871321 ("mm/damon/core: introduce [in]active memory ratio damos quota goal metric")
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3060edf5e4fa6..0df785e72438f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3006,7 +3006,7 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 		global_node_page_state(NR_LRU_BASE + LRU_ACTIVE_FILE);
 	inactive = global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_ANON) +
 		global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_FILE);
-	total = active + inactive;
+	total = max(active + inactive, 1);
 	if (active_ratio)
 		return mult_frac(active, 10000, total);
 	return mult_frac(inactive, 10000, total);
-- 
2.47.3

