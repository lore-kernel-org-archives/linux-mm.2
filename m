Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6B19CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB90F6B00AC; Fri,  2 Oct 2026 20:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6A576B00AD; Fri,  2 Oct 2026 20:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7536B00B5; Fri,  2 Oct 2026 20:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA7546B00AC
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:33:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37357160568
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:33:02 +0000 (UTC)
X-FDA: 85279440204.16.865EF5D
Received: from mta1.migadu.com (out-201.mta1.migadu.com [95.215.58.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6498580002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:33:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.201 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790987580;
	b=CWdGlIsWCLYjaI4MpNiCUjdnuZ7PoNdyI9+EnTncGNsRReW43eMabq2Tpprk9f872QdbsD
	gcOExKFXGhlQ3Cv1ae/lxDb1CLNL1BjjZRqrvUFQ2ffz34Mgono9WYM4WGeORKs1CPW4T+
	mcq9GEu65vuUXe16Fy02vY2VqLcXvzc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.201 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790987580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gdmAbAra5b5v8vmQ37cLZXVESr2LxAu+adPsXWwsqMI=;
	b=PoknoAT/+y3mCUiv1ZVcaGd5kzokKbSGLdUJebk0LlUHVd9k7SqbAZMKMmMk8ie41xGkxy
	psabsiVO26QOcE6VWSYrV5LWfRTfKSRJGSC3yRUeHj29Z28PIue4Sd21xjmDG+7CvP8z5c
	3bYcwtYlSzhllEVcGwXDP7cCu2rrHF8=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id fa0fdb0429ec55ec;
	Sat, 03 Oct 2026 00:32:59 +0000
X-Mizu-Trace-ID: fa0fdb0429ec55ec
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v4 10/14] mm, swap: require zswap for xswap devices
Date: Sat,  3 Oct 2026 08:31:32 +0800
Message-ID: <20261003003136.750633-11-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: zhemfktr5iym7xcdrjohxicnmnerrszb
X-Rspam-User: 
X-Rspamd-Queue-Id: 6498580002
X-HE-Tag: 1790987580-885090
X-HE-Meta: U2FsdGVkX19O89T0otsZf9spxrDPcW7NnJHxdHY+gv9r1X9Kje22QVOKRSiWlN2PiMCY7jWjrlz3Nm/Uo1nLPKobn3XNhG/kRjsU2g48+EScQP8wfzLaroQoilvPbS75y98kqbnPkINBB0fWJGgI3cwE0PQ7NAUYU7TI7OpTJmjHJeccIbJa2YatVm5qV8aZrEdZT1VhS8lkJMJHj6w6zBMjTZvP83DZDVf6euRGgLRkf9ExYkn1S58P5JvHNifSmq1V8zHcZfDbxMNKxcC1jP6D/IR6UIX8SmskCJINW2U2xNylzH89L5gwg27VjKbMo3tQgigpyl+xCGBHdYn5UxxeTfXi5LwBqq0LnPjrXtA4fSdQhggcpvPGsWg7h3QQh8F7+5mH7cM5on+V1xSIJlVtDfdVTjIqkOae12uG+znlf278k8xSOgOLZxZ92oCR6W1eVebk4c7lnQBh1vA9gO1Ca3P9CYlL1yoQpmd43WDe5OZD3/FY/92VAcbcwOTIYIarA8dIomlk8W9FAIgeE9AYEDSYE8w7UL6fPU+3dFMoSMUQYB1A01bnGnH6S15P1cBw0ppukbo9KVqd3SNFdh82qjj+P2j/+pFa7+uLe4EFTGnljJFRny2MZP5SACFQr93qgAIJsuOxEyABDl0HdbTBIJGvk8zxGSpO/Eky+7oytvzn5W5bi6PEF3lNEpDOuMTH+/XR3Gqrz9UhZCILAHkKQrXcWqadPXFwoLsh0NTHNV8GC6owK4UsHwBn9YmKnpcNh7UACumZ3t1MAYXkkC5dz+p3uFvR1s/VrTZyjRQDjMj8CT75n7Ib7t9z41qkLkmWLv/3VUo8z09ko2v5+lo3MqHFKETi/t67c+ggjfoNRUMOYZ2w9RuGQZFksd7o8VEsviVbNl5QgM7lJU3zyMXAFiS3c56mpwO3l92YZSpOusodCqs4F1k2kwwZ56tXZSzfwN1d+sqXbIcJoQ1
 InaybugE
 uP+09MuO+LOKudNHl18+IAqJwT0h/mvMcMfwzLG0avZL+N826qL1LOMyEN0TNQjFHAVrt8jbipIsyvPQFKV6mz9VMcmlpnLh8cWC/jqxkZhlSr4CFCUlPuA/mB0DTm2T8ws2/PVNwFiJhJM4Hz1MeeeV59ad7EfFA0EcJw2Q/ZkDYJEXkNrWGoBHfnto1Br6E86LDRTmnANM6OQRahN70UyWe8Uaz9buXU/mQDKgMedofbKFEZdIBhJ9MxFGnhBkNWlXKa1uMWrlqyb636wqw6an8vBnKDIkvuDGB38NABZfcx5oFagqS4f4VPL+0BsHoGJT9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap pages live only in zswap. Without zswap, swapout cannot free the page,
but still takes a swap entry. So the device consumes swap entries without
freeing memory. Fail to create a device when zswap is unavailable.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Acked-by: Chris Li <chrisl@kernel.org>
---
 mm/swapfile.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0c8b716ec5ba..8c8e99ea403e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -4504,6 +4504,10 @@ static int xswap_create(int prio)
 	    (prio < 0 || prio > SWAP_FLAG_PRIO_MASK))
 		return -EINVAL;
 
+	/* xswap has no backing store, it relies on zswap. */
+	if (!zswap_is_enabled())
+		return -EOPNOTSUPP;
+
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
-- 
2.54.0


