Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9156CCCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 08:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1FFF8E0002; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41868E0040; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9458A8E0040; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 778F48E0002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28DA4BACD1
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:57:07 +0000 (UTC)
X-FDA: 84050547294.19.EDE195B
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf26.hostedemail.com (Postfix) with ESMTP id 24AF5140002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:57:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761728225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GLX2vkgUmzMHIRJfTpIpp31aYJ//UpUQw3zWG9qDCuk=;
	b=R+ELX+U9hR7yNL/rbmkXzCkM9Ppcbnx7Yy5wJu1a1yKptsAOQPENyij2fB8HLYw7TNYsjv
	abQrm9SBcg98HuR7bFqNwtP4T5RL6qePjW4dbPuvLICXVXD9toqp8xMHKKcjZS6jamq2xX
	F8zF4mNP0b90ipMbggvAS8BLWZENXGs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761728225; a=rsa-sha256;
	cv=none;
	b=jTGa7rucEkgJu8mBLZMuqV7egyt/XY2FFLiXWo7guMJhPI9Hs7lBDo/PHupc0/Mb+zecJc
	M4YzaDO5ChGCuHmqQOAkENfFm4W23uMS0Gt74tfGehJB4FdWjkSwibWlsCec/tSauD+xAr
	wriqdbc21/oagitFH4A0ms7dsB6qtcw=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 29 Oct 2025 17:57:01 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	chrisl@kernel.org,
	youngjun.park@lge.com,
	gunho.lee@lge.com
Subject: [PATCH 1/5] mm, swap: Fix memory leak in setup_clusters() error path
Date: Wed, 29 Oct 2025 17:56:55 +0900
Message-Id: <20251029085659.2005942-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251029085659.2005942-1-youngjun.park@lge.com>
References: <20251029085659.2005942-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rwyko1z46r3c5eadow96z9sw3r1ojuch
X-Rspamd-Queue-Id: 24AF5140002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761728223-431918
X-HE-Meta: U2FsdGVkX1+mzmfv7E5d+FkOLX8lsG4LT+LGQL9OW6JXpzXfDWdRIREPi8dojbu9/eC6s3HypusIWjbiahuVn666TJuOq6hTp0cj552JwzTnVMKcUJGWLhwUomjJWBA+b1dPiJx8e/YM7fyz9STXIYzsMqm6t6VysMEcJDj8Kd/wxaAJQ6/pysaQQSyqx1qZVCg2Kk1+JKKtl75xgST29HE12gkKovz8eq/NvwTbNIFyOL5qK05hEg0anEvJCo+DaCdlUTodZKEiaRnWau2Q7uzwnCtJWHD+cluEDvgAaYkbv78hBPC9h8Ztz7ZDOZ5xdKhCm1TBKqZtBPWdNYLvBeOI6mqJDE0FKNzX0ruqHjdDayBYXJh74nJzr/wvvxpE3oL8ddBRiKUVLuR2e7j24NkBbtT7qwddgRG7AGIKmzjLV6FQUKjOUBH7mzc9atyxtFCr5pUat2yWOn9GVUORNQOXpCdzG3LmalF0pFUYG7K4LiARjo7C/DGeUZ33HqewmcA2zs2LcmCeTkh0Q8bOIie8AXvb9oDxQyY8nvcwLvZdS6w1aUDiFkFcUZy3garA1/r7H04Su0f6MyQT7HAOl0tkALex8hTwdZ+Hryc0uFd9FMvxDSRD5oarJHV8SquCdmJDZEUYOyWbe2NJ3Ebq6PKSwSnPeiuSbrjzJqbP4pSOOprGveoOCX8MQFb5itrL0vjWsos7syCur9SLNLqIqhfz5/+ahs94oLkNouigIVTlkSMsyI16X3EyHXVPoEodL9yGa+zwhVDUXPU9dXm33lPzGGCmZ8RLAED87mJ5VD9ho0MavrwXGVCi/7mZFMQZ/tyJwyIoRflB5Lp40DAc4h2gfUYE/oLKNTr7GKrISM1cVpMV3PqkXSBcUQxszr5Oi8IkZkLpq3ciL+c0qvTtG/Pj+0IxnXqjzUiPpCS9qB8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some error path neglects to free the allocated 'cluster_info',
causing a memory leak.

Change the error jumps to the 'err_free' label to ensure proper
cleanup.

Fixes: 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap table")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c35bb8593f50..6dc0e7a738bc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3339,7 +3339,7 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 	 */
 	err = swap_cluster_setup_bad_slot(cluster_info, 0);
 	if (err)
-		goto err;
+		goto err_free;
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
 
@@ -3347,12 +3347,12 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 			continue;
 		err = swap_cluster_setup_bad_slot(cluster_info, page_nr);
 		if (err)
-			goto err;
+			goto err_free;
 	}
 	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
 		err = swap_cluster_setup_bad_slot(cluster_info, i);
 		if (err)
-			goto err;
+			goto err_free;
 	}
 
 	INIT_LIST_HEAD(&si->free_clusters);
-- 
2.34.1


