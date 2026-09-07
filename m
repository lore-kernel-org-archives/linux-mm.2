Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 311EDC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 09:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715246B00A0; Mon,  7 Sep 2026 05:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ECAF6B00A1; Mon,  7 Sep 2026 05:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6023F6B00A3; Mon,  7 Sep 2026 05:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41C6A6B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:14:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0AFA1206F4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:14:10 +0000 (UTC)
X-FDA: 85186404660.21.092333D
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2ED321A0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:14:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788772448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D+kSM/RbU44QJgX521Fea+vNgGPaB9G4roWRBWHIeEQ=;
	b=XZXaX1nIZu+YEB1hXn2QoE2vtdfnajCs2AmmROIsNzaSs4Xbt+eD3I6/wmeAs8roARt6B2
	OXn1RCz2EP9CqtPyfT9yQs/uyGE4gHJa7St+RS/tEw7dXj2+bSJ2ZtIFIHP6BVF6L//ViT
	u1enWY5I4W8Mmmha+CAMgMWJ7jLVvjA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788772448;
	b=bMSgHvhvDfZVykVCFNElYSTytl/3ehqkMdqAvic1kqxZBNTT2svCfuaA/JHhW4typkLLtC
	aGIb7o4r0JzM8+Y8q8I1zoZsqr+eMSYGqNqs7Eq8cYGQpNlJc3BjiTmjn68fd6uOt2CASq
	IntER4auD93zEzPmeJLrBCvZvPGgCYk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hdhF42mzwzYQx19
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:13:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id E00AF40573
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:14:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP3 (Coremail) with UTF8SMTPA id _Ch0CgCnZbNWgJ5qMElGBA--.7816S5;
	Mon, 07 Sep 2026 17:14:01 +0800 (CST)
From: Kemeng Shi <shikemeng@huaweicloud.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v3 3/4] mm, swap: return early from swap_extend_table_try_free() on first non-zero entry
Date: Mon,  7 Sep 2026 17:13:55 +0800
Message-Id: <20260907091356.53026-4-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20260907091356.53026-1-shikemeng@huaweicloud.com>
References: <20260907091356.53026-1-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCnZbNWgJ5qMElGBA--.7816S5
X-Coremail-Antispam: 1UD129KBjvdXoWrtw1Dur1rAF1rKF15Ar1xGrg_yoWDKwb_Ca
	4Ivws3JFW3trn7X397tasrXr1fGr4fK3Z5uF97tFyayry5X3y5uF9rXF4DZw48Ka1IyF9a
	y3Wvvr17Kw42yjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbkxFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWwA2048vs2IY02
	0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84
	ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
	C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kfnx
	nUUI43ZEXa7VUbpwZ7UUUUU==
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2ED321A0003
X-Stat-Signature: m4w3n74daozz9iqbpb9bys619cag5tw8
X-HE-Tag: 1788772448-281922
X-HE-Meta: U2FsdGVkX186bhPPQKsl2+R/p2VGFfCGEvr4RGtYqC5cc7YHxY70BSaniovVHymQfNSQS9HrJ3ulQ2zjz0rPSS+wgg7WMmeLsYZ8b13h+8zOWIXLzYCmCqQmCJnBKN7on7/NdFEL+ckid72dygIXlMHrSSnZgDDbyz01nS6FfyAXGFsZFJ50hI4pXc58uIok9PtTdYgo3JV9I7ZROirH+gK+y+yykkSB/s6o4+6UMpIqkm41AHiFaa0dF+6UNj7iXgSr6XOIrVwmLJXE3ybR/e8qcgE/GSRcL/2UyWepAo36eh8jeo9soi1B8KDxQPwj38qliyDQvYZwF46Mnz7x/dcrv7MU6OwaEBzndwGi56XaUH/UVjhtbv7w2WCK9HcNj6OuBm1ChMLeRxdaW6cAENRv4yYwzcjRb6us6omUjX0AwBOnJzpPMf6dYIMT4fVFztD9F2YqXw//nsf1xKJ0U26XbVg6cyMusw+NyDP5cOfhYb0d/GjOUGOKoXOisnD3hC44w+B4siU/waZ+OIbXCupzgCyiiaA7OMLGl4XTpivhPgJXroR2B61KuD8K0KbBrD207DecRopeNieKyAPNmXd7OvX6kfAixoylsGNDz3YqBLkqJsJ0tRjJiBrUcnDNwOB6G+wtc9ZAgGiIkqfvq1gOWfkRBoEXk3rL3ZG74oqQQX88Tck0ESWMXKk1M5D5cGk2eakA7xjIAmCs77B7mG+HzcODf/zg8aZvewh3TeJCmUI1+WKXGTUNimoMqjSogSlBfscb3OAW3GoROnthy5SdfLmhNVX0fQKxFEha7OEuAHImZkFfrpYrgnbvPn8iyFFkJjb2MgvmVW5sFI9rJxI0vrvPFUCBsaOxGnxpy3jns3pzwhuquVEN3E3DSzNKu+vuURfmAU7YDoHgX7lseR/b0JjLd94+EG8AjXAkSb/+fAd6xi7tmR8xhJwnTh0wILYgN/GNbtz4I4PQ8tX
 m+l5YE2N
 FUc0Wb3vZiida/Pw08lg/n4JLdATWAo5mqnlik4HFWmGmdYzN+6VbjJzapl+tWglZBSaYcU0ga1+Pc5ygH5vv7DO6iHlS2M9B6y8MGbfGXpnFcQTDQiuSh0MLYcQR/bmokp03jrbttbYmepSqWZdIaIiATAmlvJzGb/yUjI8M1tpJUKYIE82x5DqpdgF1ObKHfatw
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
Acked-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 767d83d89d0b..b73f34ff44f8 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1527,20 +1527,17 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
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


