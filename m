Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39BF0606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gSuQYfan
Received: by kanga.kvack.org (Postfix)
	id 5F3CC6B05BB; Mon, 26 Oct 2026 08:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4446B05BC; Mon, 26 Oct 2026 08:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E13E6B05BD; Mon, 26 Oct 2026 08:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3D06B05BB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:23:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF0481406FB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:23:29 +0000 (UTC)
X-FDA: 85364692938.02.326C841
Received: from mta1.migadu.com (out-15.mta1.migadu.com [95.215.58.15])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9F57C40007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:23:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gSuQYfan;
	spf=pass (imf11.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.15 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793017408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dboJrHVswMnEFwppg3/y09UwLLyzftCZlSmkEUInPO0=;
	b=C9DZYrVTuk+A69L/NVtQodxBy594yW/3qqt7KDtndA0/qeNQ8+XcjVb26Sq5Oz3Uu6Dp8X
	JuXZMcTeL4aNYDnBRIFkbVCQw47JsXMIJtG1BY7mf2gDLGwgzAnsHIwhi++03ruHguHOpR
	rtMM/iVLCQzrc7e5ZPrlBjxnK9pYgyE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793017408;
	b=CF/V4xUmM6pqoubr4Fxnew1TwaRYqoqvYA8V68JfSm302F4YW15i0eTuRVx8TTyb5Q3usW
	f7v/9sJJSh5ucr8ljVP5b5clMhL30LTSTE5lcxy7eW888OE9PFzL2CM2JtNr4qum8zGGn/
	4Olulfj+N3JKiqiT7m/5nfyMuCVX0sY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gSuQYfan;
	spf=pass (imf11.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.15 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TKJOozfmmHwVWFMY6G0uMAS57LKpM/pay/4AO+73ogs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793017406; v=1; x=1793622206;
 b=gSuQYfanOCnt8np0fVYk+C9YcM7Wbp2nkmaXjb9iuF0drtnduXj9HeyVC1WRAh2PXCu7P5Nr
 kqDU0/964Z13fjqc5EaxTFwqUZnL3YivWKtShYbfCya3M9+GP1UBLbtSNJMV+PDFfITYov7hUkE
 WeBRVj+bHmk7BkSpOmjSjtNs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5ac50a1b89887b30;
	Mon, 26 Oct 2026 12:23:25 +0000
X-Mizu-Trace-ID: 5ac50a1b89887b30
X-Migadu-Flow: FLOW_OUT
From: Jackie Liu <liu.yun@linux.dev>
To: glider@google.com
Cc: dvyukov@google.com,
	elver@google.com,
	pjw@kernel.org,
	alex@ghiti.fr,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	muchun.song@linux.dev,
	liu.yun@linux.dev
Subject: [PATCH 1/3] kfence: fix pool cleanup on metadata allocation failure
Date: Mon, 26 Oct 2026 20:23:02 +0800
Message-ID: <f6a6154134fd14c21070f280739acbeb5881df65.1793017074.git.liuyun01@kylinos.cn>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793017073.git.liuyun01@kylinos.cn>
References: <cover.1793017073.git.liuyun01@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9F57C40007
X-Stat-Signature: 9y8deike3b58knfw9e4xh9yndbjchyex
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793017407-706428
X-HE-Meta: U2FsdGVkX1+yJQxaPCYTH297lZRZlo9pyxaM1P8vZJI0ucEOT09ChpSyenmvHdE93u8KYpI5T+E6tRaWRvaa9NPvSMjxSBi6mN+VZr/nGAPalMG5S5LXWYewFIjjn0/YqgFBWxNXrDYBGx5abwV0mECs0OfPunJbG3XsXgl4ML0/ZFA79T+xAOXqUKlfjE+t3rxjB13QdmrPJ2KoxA1LiiKBEW0cjJvMr/uf0SHKNFLPloP3ZRspTXQ0jiH7V1pmUh0l+Zyikf7WOs7XsYmc6MOGTgVhhmz8Mlt5UCS3TWiKJDDQvYKD4EiJI/xGNtEYlTLY8AdMofFhmRHCE0uGM8IviwXQfIsZ1GUaqmXK/U3U8N34U6OUnIlB1QzLpEEk11Xwy4bFa0IQOp1f46BvAesGihf92pL+SIoGnsGZY5lB+39niqC+l6VJ9cOsB+NqNOMxQYYpsGQY8pYNCWothjF2Hi2nwvwqacjlpUHHmhLjvy1ZgEaab/+WOlHIuzfmiS3IHrmsaZnnyqdQxUdU2gvNmqjk7KMYfbiXeBd39SJmu0QJmZwbyPWEPgqGVMtQCzCw2pK60mvIqqb6Ic8+bFGWdpA3jI3UeV/WsOC4KZT82wkUU1L/zi1YuQWrJKGvQOf+nm+oIpI/oM8kcs1J+eEZiIYtdNlSHhRvlTL5cGvZpDNnNDKHm+R5rrJZpjXqtyV66EnPeYyneXKQp3BgDY9fet3egbIIXz+uVtCc4iDLxbe+kTYcF6+uNlGMouGqXLUE2C6jE3SokrIp3YWhHNPYl3xtgCvkMBVOgs7kcdkNm18sRI2DFtghg7FT6tBsEufi8rhqClA1pMofIaNapazrX2JK2mpprw9VnwdNw81UGnsOamDEWXma+UO/HzDatV3XJdDs7tfk2molWInsI1xjZUH0y260+jcCea5nnG1Y+gszTJP2yl3mawIS6ruQFctnc26kzekvcnBpIu1
 w4lEJ2xh
 R6LpP94TMJp2I/Kj9MYo5q6yW7Ldw7upuNn0zTvRLuxGgErPMBzI94WACQZQCQVkgE20abpE8V80+gI/LvK0AM33Lz3mROcIeeGZwe7diJDIak+gIM5u0yZFX5xT/DV3jtAMVAiPtl+jTyuyNIQOx7xxKBFNNX9G5V4pmAJyj+8CxgSa3amh6YRIrK2CQv5CSBnZ7vEc820QI4jIdgB66jSotug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jackie Liu <liuyun01@kylinos.cn>

kfence_init_late() saves __kfence_pool in addr before allocating the pool,
so addr is still NULL if metadata allocation fails. The error path then
tries to free pages using that address.

Set addr after pool allocation so cleanup frees the allocated pool.

Fixes: cabdf74e6b31 ("mm: kfence: allocate kfence_metadata at runtime")
Cc: stable@vger.kernel.org
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 mm/kfence/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 90925c646c4c..6e3d01bccdf1 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -999,7 +999,7 @@ static int kfence_init_late(void)
 {
 	const unsigned long nr_pages_pool = KFENCE_POOL_SIZE / PAGE_SIZE;
 	const unsigned long nr_pages_meta = KFENCE_METADATA_SIZE / PAGE_SIZE;
-	unsigned long addr = (unsigned long)__kfence_pool;
+	unsigned long addr;
 	unsigned long free_size = KFENCE_POOL_SIZE;
 	int err = -ENOMEM;
 
@@ -1032,6 +1032,7 @@ static int kfence_init_late(void)
 						 GFP_KERNEL | __GFP_SKIP_KASAN);
 #endif
 
+	addr = (unsigned long)__kfence_pool;
 	if (!kfence_metadata_init)
 		goto free_pool;
 
-- 
2.56.0


