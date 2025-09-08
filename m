Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06AB2CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 06:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF738E0008; Mon,  8 Sep 2025 02:27:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4903B8E0001; Mon,  8 Sep 2025 02:27:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD218E0008; Mon,  8 Sep 2025 02:27:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BAC28E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 02:27:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC84FBC5F4
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:27:23 +0000 (UTC)
X-FDA: 83865101166.07.365EC44
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 495C640008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:27:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iAjMhQtp;
	spf=pass (imf04.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757312842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cSg5+GuqA1WdNW6xAGf2a7NsFVpIN+33VPteK3BWR7Q=;
	b=H51Xn6eOE9/Lhovn1APnxZLXFj5cW4Cv50OL3eFY6/MY5gr3Y/KgsfyOdZ05p5OTZPB1Y8
	OpkZMtfnnulxAuPZ0pF64QC3GQR7Wu1HIMCDskjecmaDuJHPCghHjnKCylByHdMfFhH/9h
	G2CtUEIMHiBBWkZO20pNXCc08dGaMlU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iAjMhQtp;
	spf=pass (imf04.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757312842; a=rsa-sha256;
	cv=none;
	b=3nELMUtS6pmu7w1SxbPT0l5Dx5nivGIU6WDfUv3ambBmorjnS5c0fqcmEP2zH76mwGQGyU
	D8f4ANbNOSt5V7awwV0WOjUrztql27fFcSpkFFhqRXgNIV34gTexALQ9NR16C2kMnJy2Ao
	LVvXc4wbGygEoPnixrbfDTpAs0AJrRc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757312840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cSg5+GuqA1WdNW6xAGf2a7NsFVpIN+33VPteK3BWR7Q=;
	b=iAjMhQtpiA2iEVUz7tk3E2fzyzDcQPmsHFqw+SDK+qaQupgSYKLkq9L0fqmORoTkt3OyZI
	fo5dC3vHvoY8VSOUmrPD1QCvqpv7NEvjl6JlaofSqHERTOOPVCXyPdhdQEmRSiY7Zzt93l
	vz+ESn6Rat2yo1+wUZRtY4GVpSsvCzs=
From: Jackie Liu <liu.yun@linux.dev>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com
Cc: hughd@google.com,
	liu.yun@linux.dev,
	liuyun01@kylinos.cn,
	kasong@tencent.com
Subject: [PATCH v2] mm/shmem: remove unused entry_order after large swapin rework
Date: Mon,  8 Sep 2025 14:26:14 +0800
Message-ID: <20250908062614.89880-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 495C640008
X-Rspam-User: 
X-Stat-Signature: nwiz1fcca9hczf58uegrgtbyeixp3xzq
X-Rspamd-Server: rspam09
X-HE-Tag: 1757312842-8936
X-HE-Meta: U2FsdGVkX1+ax5zKQ5cPfsYvSBxgHHFB7SQb6Lpan34gYmA7U4AZ/vp08UW4n9lz6gjUN4jOGRZT+pBaJWarb9MCWS0buvR4CdRSZ+KRMUYYfyHMYkEyPGm8VVbVA2oWYUcRo5MLhIicx/QIl1Tt3BrwjZkSWchHeowUV+FUkWzpOvtoT/mQP/BDJnmpztYT59AvAw0Pkr8S1UGkUOqYy5fO76yvfZSEuPXM9T3X2IN+xg6OwqtF9ITP6MuhHqWqoqLHQ0So5QXPswPrFFn6ex1KJ67iBgoVByyqoE4LuXKytcY3UP9SFB4GZsEuF/X3uS0db5haY8rhKw25xh5M/3Xja3wXUP4A+2k7wHZmIegcU0nv8OEET0q7Cs7mcz45oFZ4Ec6tM3oZNWC2V4eJYzqlY8hdYvkdb/6my/6QexxthBs5DpEPalkzSg1vbIpfp8Jea3dh1MU2ypWKjzUsBiCCsVnRjeizkoB2B8Pg/mC7i8B/Ji8oLHGQLU/711u31AJhOpGooFDGvNYwuR/wfojcT/oO7oH7N6YCkkYcpP0MV2IZvLWluEzv2l7906xr0Wktrj8xd2RvN6n7QJxPTHHTP+nj5pG12sYCEUSqPq8mFQDxoqQj3ZbMufbRL+QMSOVpkydlncBTy4J0Bk1ME4DCF+3o3F1h5VOVTSJE0aco9JUwbK2RpEI8l330aLcLc/SS3Yl9qVOYJl1twA17Xj+/xCpI/LqKPhobF6HBt99VX8YzXoia7jIJabv6MlB1+to0Y3oZY6v1vf0/udTUe7AAQBFlMeQjObUFh/SczWk+0fkdbW/z0Lh3dZuDkGXPSTU1uwxyP1yFIVsaxakUhlt5CI9ERDowg2Gb9ZqtXFuuvWlHHEW9DcD0MkRiuzAhXyiJfKuez1cG6WhfmMIr/63m6Jq3Udx5YlwVkChHQ8cNpz5QmryrZ/YjRNRzLypVxztFRHenaVvrzZaOuhm
 aZWnVjjd
 3hNvec8eNoHexL9R29Hjz9wvdzzjaZGpMedo3nf6OoM7RZePXZvhsM4ED8Z7JQh1NFGaQmaNRnTU6u/zEFFCAy0bsWYoTyndDrNuab7p5ISZbWMm9ut6o9QYqOhFW/wViHjO3CLGsSoNRYofviMmPyeOJELmFWmFd7Jwyp5sFKfM7lPG0im8FVWEzW6r/DZ5lU64HEKRuIos0vXFU4DFLMrd/ORwze6x58tcQRLd8V/oJBhtvSy0rqTeNdznxJ0wQ+yZJrZ3ZXNkvf/E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jackie Liu <liuyun01@kylinos.cn>

After commit 93c0476e7057 ("mm/shmem, swap: rework swap entry and index
calculation for large swapin"), xas_get_order() will never return a
non-zero value for `entry_order` in shmem_split_large_entry(). As a
result, the local variable `entry_order` is effectively unused.

Clean up the code by removing `entry_order` and directly using
`cur_order`. This change is purely a refactor and has no functional
impact.

No functional change intended.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 mm/shmem.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e2c76a30802b..53d28ea6e52b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2235,7 +2235,7 @@ static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
 {
 	struct address_space *mapping = inode->i_mapping;
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
-	int split_order = 0, entry_order;
+	int split_order = 0;
 	int i;
 
 	/* Convert user data gfp flags to xarray node gfp flags */
@@ -2253,15 +2253,12 @@ static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
 			goto unlock;
 		}
 
-		entry_order = xas_get_order(&xas);
-
-		if (!entry_order)
+		cur_order = xas_get_order(&xas);
+		if (!cur_order)
 			goto unlock;
 
 		/* Try to split large swap entry in pagecache */
-		cur_order = entry_order;
-		swap_index = round_down(index, 1 << entry_order);
-
+		swap_index = round_down(index, 1 << cur_order);
 		split_order = xas_try_split_min_order(cur_order);
 
 		while (cur_order > 0) {
-- 
2.51.0


