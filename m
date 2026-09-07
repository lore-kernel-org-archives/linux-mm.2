Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33880C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 09:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4A56B00A1; Mon,  7 Sep 2026 05:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55A86B00A3; Mon,  7 Sep 2026 05:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91056B00A4; Mon,  7 Sep 2026 05:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD3576B00A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:14:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30DC3801CB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:14:11 +0000 (UTC)
X-FDA: 85186404702.10.AB18B82
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 66759100003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:14:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788772449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tf0/hfb3U6VprB6ZCBwpW5K0eIphYme8C0LyfUuRxQo=;
	b=bayAwcE1IRcu6kntRbo5PNCsO8CkUQS1JP+wQraTeaKy1zzceXA7EvsEnY6uFawxAWPe+M
	/TUiLpyzlgy5ivRMegSWBDyh5DVSHd7znDMyoPvn55uCZjcf9W9XfnEMTOm3LqszVZxySO
	8eqrnsboY5190aEPnSde0MVI7vOss0w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788772449;
	b=uTKaiZqpPHi7Hq8/PdjVRkvhF98uOQVwIU/huHWdXvKk/O9cWYF0jo6iJfwCgHyfrLgPGe
	8GJXw90m1j+Pfvf86E5zTCtPnt7H+JUjE4QOk5jBC/HSglhRHW0zExPFSd6NRNYfomKqmc
	WXg3zgri1a817tg+hu9f3A70NLMLtJ4=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hdhF46DxjzYQx14
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:13:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 6315D40561
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:14:02 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP3 (Coremail) with UTF8SMTPA id _Ch0CgCnZbNWgJ5qMElGBA--.7816S6;
	Mon, 07 Sep 2026 17:14:02 +0800 (CST)
From: Kemeng Shi <shikemeng@huaweicloud.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v3 4/4] mm, swap: Remove unneeded swap_extend_table_try_free() in swap_dup_entries_cluster()
Date: Mon,  7 Sep 2026 17:13:56 +0800
Message-Id: <20260907091356.53026-5-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20260907091356.53026-1-shikemeng@huaweicloud.com>
References: <20260907091356.53026-1-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCnZbNWgJ5qMElGBA--.7816S6
X-Coremail-Antispam: 1UD129KBjvdXoWruw1rGrW7uF17KFyDAFWrZrb_yoWDZrb_ua
	95A34kJr45Ja1DG3s3t3W2qrWvgrZYgr1Ykr1rtFnaya4UXFWrWF17W3srA3s2q390v3s5
	Ca1vvF1Sy39rGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb6AFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr
	1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r
	43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
	JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIx
	AIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUUUUU=
	=
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7pp4q5kcjr3jx7bcqp9fntiu6ce1sjma
X-Rspamd-Queue-Id: 66759100003
X-HE-Tag: 1788772448-534699
X-HE-Meta: U2FsdGVkX1/hxNt1Wf/qs+GXxf4dhsx8a93lxdjdCu4WbANHRbuFdu8yP2RlnKFBe8kr60ibr38K+m3jkDEZkZj7CxYRnIw8oVS8mDU2q/jzQzR7ZQjUS+2pOZwWY4o8iUtMtRGVCKP+bOiTOsJGLfAjh3HLXem7pRp/0ON3WqVtnGaNvHP3FEIyeVFBSaH9lC5NiPBja1eOow6ixbtbjLHRrIsATdgyVOE1N9Dl+dSqIwl0VU42XY4S2D7NP5VsrDkJjEC+ivMiRcAZw+gFztG8k0xkG4wpmJhdIlr7ITPqL8A6S4q3EbGrKjp3fhRI3wPmUAoOd/E5u9KlxboXTujNp8XhE15umQGP0k2zNzhOLI8B/LBGpuT1oHzUlMvfqIC8jGmMqWbj+Q4iAVHyhav+Ey7atlZNhVjf0cimkJgUwO7Ab9cEseLyj0JYRhAVuf6EOqauI22mlbvKbL+xxCY3g9Ysy1IVxUWqMWD6TSv5OaeXtOLY7UjLAZ9M4jQa3ZsOnW5esaJX7im9Bsi+kJ87OOYYrqmlaJV3QZlAwabAVZM7PdQZJJn5GUAmz2Mo6qHWGcAG1+2bCjE/xG3/TnU5TlFvxbuMfYparuQgjG+hl1M7ViulMbDnMcLH4CEFKMQbVtVzpF37TqgnSNCdTxL0eeC7zKeRYlFcBf/N4J0If76rBn1U305yWhimVy5s1rvaT+104RE9M7rWZh6xLfH6Cf5s106D4H8TiXvjeo9hQPN7g/ZwmgtwlLP4HGkucW8FLHVStwYEfTntCqvUpG6nxKOko2UnN4s95XdjrSooLQPVR5tRca8kMFBkF6GgKp9Z8p+HcX8kJRkG6175v1wwOe3tSDB0WzO0OQ6DQ6G7TcOpdhqi4n9If7jPHHtnBvu11T8NsZYGcIrw3Jq/tan3p0inLt9s5nD153yVLie01LVr1LozGL0CKIE2bsQq+udD4xb1mb0PFM5o04w
 IYwtKiVn
 tudUBub0ZQRFGHWe2rizO708HXrkOxzBD2nT6Kyh1IhW2tnX/7sxo6BPWq5b8Zy7171hEV1aHFm8xPeuLxemwfHYpb8MKFFSMWKg8FFs4wOQurh0XNw1y4j8CGxiZHtOrOyqscVJ8n3Wp6dQtE8JruHZphRGUr8OaayaxI3PTp0TfYdCUQlwM7P30pRokVfo2fTIy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 0475fde0f68de ("mm, swap: avoid leaving unused extend table
after alloc race"), extend table is always allocated when any swap count
reach MAX - 1 and is always freed when swap count decrease to MAX - 1
or MAX - 2 with cluster lock held. So the extend table will always be
freed properly when decrease swap count in __swap_cluster_put_entry().
So swap_extend_table_try_free() outside of __swap_cluster_put_entry()
is unneeded and can be removed.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index b73f34ff44f8..449890074c28 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1729,7 +1729,6 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 failed:
 	while (ci_off-- > ci_start)
 		__swap_cluster_put_entry(ci, ci_off);
-	swap_extend_table_try_free(ci);
 	swap_cluster_unlock(ci);
 	return err;
 }
-- 
2.36.1


