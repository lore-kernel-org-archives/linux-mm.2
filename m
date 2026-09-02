Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D343AC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71916B008C; Wed,  2 Sep 2026 03:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3A36B00A6; Wed,  2 Sep 2026 03:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B416B00A7; Wed,  2 Sep 2026 03:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 903136B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:38:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14DCAA472A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:38:16 +0000 (UTC)
X-FDA: 85168018992.30.1436B30
Received: from mta1.migadu.com (out-20.mta1.migadu.com [95.215.58.20])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1387F40008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:38:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SQy99hWh;
	spf=pass (imf04.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.20 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788334694;
	b=ZJYEekG5rOfBRp9kb6tQVYbBxtMUYzIj0xS41YZMLKqwr3drKIfl+UWYH5toTusObm0sys
	R5UiAJqgeFAjv+OUOgoxHaDpWtsv+DpLvCyc0JeVbxy+Kp32PzUFj8y8uLC3icD+WGbluy
	o9dwj9xlcKTXie+vuUHHc77BYJfNLfs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788334694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VbZhKQi5kY//eqYJoF5P8zibfVmJK3iE39lm5n8jhfg=;
	b=Fyoqt1RxEY95Iriq//6lUg8DgwtBH+d36ZQ7X9a1aZFLEkY8jfi+fsXlxFq4Yh6uQzuFCW
	syjLjGpZNWKy7mdu6Tz1vxHhnY0xL9ugLOeAorDKUgW9nanE8g92hhtwp9FYRbKhWHmNNc
	xhyw3FIIx8Hu4OWW6QQcYHsFG2yThuU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SQy99hWh;
	spf=pass (imf04.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.20 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bWqKM55BsocJ4wzic/HTSDg71D6vbUFl84C/nnmct8E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788334691; v=1; x=1788939491;
 b=SQy99hWhLtiJPdW9cUVXJW3A1ZnJfkNAWnUPiixEJCE1nBEHIxnMoVvo6WePLMCkJt3XsfNr
 EEG6h31YXFNpe9Tus3CvVKSzJQk3j2K3RWYjwl7WmhgZ50gyZmNX1yiGws3scVHPKYCmJUmwfuH
 LarBIfy5yK47cdFvAr6nT1Bk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7b5fe957ff10b172;
	Wed, 02 Sep 2026 07:38:10 +0000
X-Mizu-Trace-ID: 7b5fe957ff10b172
X-Migadu-Flow: FLOW_OUT
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/shrinker: fix bogus set_shrinker_bit() with cgroup.memory=nokmem
Date: Wed,  2 Sep 2026 15:37:59 +0800
Message-ID: <20260902073800.305481-1-jiayuan.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1387F40008
X-Stat-Signature: ewuqfxg9m1jzti93bg71fu57rk68i46e
X-HE-Tag: 1788334693-307663
X-HE-Meta: U2FsdGVkX1+I8ebbqgGSFQV2hpkGc9bZg2L66jPCiES06Ew6wksjwzUVc1E8xmBOwaiKMNW0kjzu3d0uWiJhZ4Qr1MWH4j5euj+RVGzlkcpSSWYSs5vtb1wzA1M6SG5mqQ/BfWy1ZHTwIDjiVhCSasPt8qxNa0GiKkHkJbAzfNHZjXFddUEWRzOfItS0BVfvTXjWok0z1cI8nTUyesRm/uhjm/Yd5m3EO2SMlgWL4kYz3RATmqg1n3OeJqUzqJZrlgUN0nWu2yMFefCTK3/fNrydesmnk+qEZ8EHAnGFYKtCpwA124JrqhHJnHxt6oSFhpjZtGARnUJS7CZ4RJKqtHFz080AV6F7fbj26GHtBZ1gut02T7jTuvdoxCezYtc7hvUen6DNPzuhsl98+7+qP/E764JTUehLMrwoe3W44ryPtU1K40HtAYn90lj4199YufC4KxToOq9wTKiCqZVYuRU27Ag4CcTnYtjVTooIqzKAByIhAAMYe+Ymt6J+kHPs5WtpQmq+nghlu1hWpz+Ya/FHGEzkMk7wWP3UvJc9CVqV89RsF5a+tutyJRZ5mVacdNGfOAPBMdzGA6g732NZsHEbiroLKqncsYvE4yDLfs8hcVBqud9jVvQQOvDb25yyh0HRTIczui97xccQLIhPhpdOt3FEv7zK41VgvmvCsgeOq+ucqwL0mSLOnun3L6VHtf5MsPWwq+VBh4USZ90RHm1x51mWkgge4t6mNxa8kbr8VqDptBEWy3sCaaS3pbYQAjpyNRQzsXeeXIhz8T4KwpPyvftqzoO/Kyf7EfdVnE+zqjoQ+AIRwFXYW1CqjsK5IzyMANh/ikvVkBS4WiTzqDZ9FjOaM27aHCvSK5/ZLdvFRFvo7g7mLNCU7DqHgO27fc+TJ5edTFBFSnaSrBfMQEHP4X0bThnQ0eYsmXOZDjPTVMpYGcQW6Rlxkq9PM/Wmnm83Z2q6Ek/chTvuEZf
 hxFTafAP
 /73jEPSFKKIhc2bo35HBrS4BUqS1ynUxv8QsvM5CfjVGJ30hJiqDZ6lehJIey4Kr3zER2/y/2tQksaYPzi4PIgGK8j+5obB9X/UOrdImTLebAdiMeUOzhJwcoTCM8dyCXb82y5jgRoNrxPjSCV5ZWNCYhwsxsjLkpithdFtyhNdR5cqvuBekxy2LqUUEU7AbwgX2fsyA8CPBBuN9ahU0PDeLH35q9RyAU4P9sDuDeDPlz/ebKWr3/1FmUrd+Z3CD+NARmsP3GPMaEfSYgNNkSfvxucQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With cgroup.memory=nokmem, shrinker_memcg_alloc() bails out early and
never allocates an id, so shrinker->id keeps the 0 it got from the
kzalloc() in shrinker_alloc(). __list_lru_init() then copies that 0
into lru->shrinker_id, where it looks like a valid bit index.

Nothing calls expand_shrinker_info() on nokmem either, so
shrinker_nr_max stays 0 and every memcg ends up with an empty map
(map_nr_max == 0).

deferred_split_folio() hands a real memcg to __list_lru_add()
regardless of whether the lru is memcg aware, so the first THP queued
in a cgroup does set_shrinker_bit(memcg, nid, 0) and trips the bounds
check:

WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x7d/0x90, CPU#126
Call Trace:
 <TASK>
 deferred_split_folio+0x18c/0x220
 map_anon_folio_pmd_nopf+0xdd/0x130
 map_anon_folio_pmd_pf+0x14/0xb0
 do_huge_pmd_anonymous_page+0x1a1/0x620
 __handle_mm_fault+0xea9/0x10d0
 handle_mm_fault+0xe5/0x320
 do_user_addr_fault+0x1cc/0x870
 exc_page_fault+0x81/0x1b0
 asm_exc_page_fault+0x27/0x30
 </TASK>

Harmless, the WARN_ON_ONCE() is what keeps the out of bounds unit[]
read from happening, but the id should not look valid in the first
place. Clear it before returning.

Two other spots could paper over this: drop the id in
__list_lru_init() when nokmem turns memcg_aware off, or make
deferred_split_folio() pass NULL like list_lru_add_obj() does. Both
leave shrinker->id lying around for the next caller, so fix it where
the id is handed out.

Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 mm/shrinker.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index a70aab124a0e..7ec2a9704f6f 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -227,6 +227,8 @@ static int shrinker_memcg_alloc(struct shrinker *shrinker)
 {
 	int id;
 
+	shrinker->id = -1;
+
 	if (mem_cgroup_disabled())
 		return -ENOSYS;
 	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
-- 
2.43.0


