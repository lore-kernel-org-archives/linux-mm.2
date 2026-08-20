Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1F76C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 11:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499786B009F; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4686D6B00A1; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357486B00A2; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14DB06B009F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 994E0160127
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:55:16 +0000 (UTC)
X-FDA: 85121492232.28.F25B0DF
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id 289EF4000C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:55:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787226914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eFziaLsKsx+Kds5iQIN8WvbND9u9AqRtOpymvfuRAro=;
	b=bka590UPU5ZCC7GktP2nvtoSBNFhGm3XTI4OZ8omzHD0pi/m/1eBcYv/pWdJFjLmnimorJ
	glcp/tuVj73hJG8bNRHTSdPUGEq+sxe5WcF1UB1moUSC5kshxRx4n/BUATcZGekvg9ocTU
	Jf0LhMUXuhkTL5V3sJJ8fmrtHRWuZ6w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787226914;
	b=5+g3wThxLwpUsh0j9DBZ6c+1HDIq5pBd7F0iT5F9BphhXPO4ADkakf5OxZlfNnpFsVJ/Dg
	/3M6OfqyQltKh4mr+p6K69mkY6wZMSaRZ+f+O5bKVdNF4Pmb/6FqrmySR8LIkRvsvyIjkS
	/sG5pXWjNHMrNg55vTZe8kAp+7iWFUs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hQhgg4jfZzKHMJf
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:54:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 5BFBD407C1
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:55:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP1 (Coremail) with UTF8SMTPA id cCh0CgAH99Ib64ZqI3IEDA--.64911S5;
	Thu, 20 Aug 2026 19:55:10 +0800 (CST)
From: Kemeng Shi <shikemeng@huaweicloud.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v2 3/4] mm, swap: return early from swap_extend_table_try_free() on first non-zero entry
Date: Thu, 20 Aug 2026 19:55:04 +0800
Message-Id: <20260820115505.20027-4-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20260820115505.20027-1-shikemeng@huaweicloud.com>
References: <20260820115505.20027-1-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAH99Ib64ZqI3IEDA--.64911S5
X-Coremail-Antispam: 1UD129KBjvdXoWrtw1Dur1rAF1rKr1UCryDZFb_yoWDCwc_Ca
	40vws3JFWaqrn7X39rta47Xr1fKr4fKF1rWF1ktFy2yry5X3y5uFnrXF1Duw4rKa1jyF93
	A3Wvvr1akwsrtjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb68FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWwA2048vs2IY02
	0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84
	ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r43Mx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_
	Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwI
	xGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWx
	JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcV
	C2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbN6pPUUUUU==
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspam-User: 
X-Stat-Signature: cfygucfnttwuqhqocc8wjiprzinxb871
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 289EF4000C
X-HE-Tag: 1787226913-882088
X-HE-Meta: U2FsdGVkX19uhfTJc7dGsc40AfDdkLvE/VymK0GAaVVirUZ7BELMW5y+KAnqT5b3CiYaobcsPtoFmiNQxe7eMPEuC+K5glIzz650LL+WqrraSwgUpIrRkOMUCSU5kRxDcvkixf+hsnqe1xhW+E+Az8jVfNew+v9QxBggqVBZSygwTfrZGBBi8RYU86ii9hUP90XVG/ZM+ZdlHZqsqmb42512bOjzTXjJtbYv4THmEsBWrtL8x0kv7qpn/S7+qYP7qpNCqvf6nZ+Dh/PcR4SNGQIOwYX6hp+j+qRe+9wFMQjp88ssssvFRJSinBcfb+jOJHiBjesLiTfMF5RZigrQXnlkY2v1I6E3FA+IlLPgkOTGCuci8h4Ve2bZLbKDUe/+OUuPPcuhDAqABtVwPmHjbWQxwXIi7B8+g0nRokelHhEcM7jOP2GIwXxZglNApCqM50bpeLXnkdwRcMlQrg0rO1mZFzNAWaLePGfaENijMYWrsMStljBtj5S19RbC6ELPdjOFENw519kzeoGZHLIkX/QWQJZT1zLmJxpdlC5WP7MGGwnkcNcScmteD5Mbd5bF4U/9UR5JW5ocTFRb3ecVQeZXDUbaVPa2js5hTW4DedQGFmtz4Y3s4Nqx0nnttl5woOy7cfxHyF9mEF67gOXlh6ckOLFm+0+diGse4idCy4f6ZSUBUDzE1iZv2TIympcgZuxNslJGjwafQhDoOoxFt+JN7Y6m0bQvqcXCvsM14beFuR8kkuZZAtvR0T/j6bOzTaAy7cQakGn84H3RS2CVeQtDyKqGZqnw+IahdWGFA1ayhhU0UzLczm7C7/syWla+Wrmu24tHLGH5Et8xiAXqaJOUxy1AzjO/rbyWCqyG1A42OiX5WAfVcM6aLAVrzjc3Sa0Fw1SH4LaWSjl8c4HniEYkSmrpo+F0jv25W8zfIlvxu54dhEK+BlHdISJFcJaRr3GJAA3X5j5UNrX8mnv
 gncgCNBS
 HhsCBH9M/b25clMwcoCJDVlDSfB0x9GKRVTs6x9dH2LudAnw5SVWauMy/PPC4p3T8GCREhJVEwVw4qQiZrwzv+ddExlWljDkMHVP+NJxl8Gr9lHl/+B/ygI5tffVrZ5g2H0mFGxbuJ1W9yeMYIn5A7dM7o3WeuPeXR/XW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Return immediately when the first non-zero swap count is found as
any non-zero swap count prevents freeing extend_table and further
iteration is pointless.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index e9554c28e6eb..9f43ab43b927 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1515,20 +1515,17 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 static void swap_extend_table_try_free(struct swap_cluster_info *ci)
 {
 	unsigned long i;
-	bool can_free = true;
 
 	if (!ci->extend_table)
 		return;
 
 	for (i = 0; i < SWAPFILE_CLUSTER; i++) {
 		if (ci->extend_table[i])
-			can_free = false;
+			return;
 	}
 
-	if (can_free) {
-		kfree(ci->extend_table);
-		ci->extend_table = NULL;
-	}
+	kfree(ci->extend_table);
+	ci->extend_table = NULL;
 }
 
 /* Decrease the swap count of one slot, without freeing it */
-- 
2.36.1


