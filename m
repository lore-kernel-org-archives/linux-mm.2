Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5615CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B2F6B0095; Fri, 10 Jul 2026 08:01:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2AD6B0098; Fri, 10 Jul 2026 08:01:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2F116B0099; Fri, 10 Jul 2026 08:01:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A56BD6B0095
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:01:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 364F71C3ACE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:01:12 +0000 (UTC)
X-FDA: 84972726384.19.A2C33FB
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5607414001E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:01:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ooTgpcSd;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783684870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SC/MapQaHbUTUI3K9nyriPUJ2aS11yn5U+TrIzZcKUc=;
	b=muIxKTtLAyKmTZnCq9kkHfN6W8CD6Eaxac2JjSduSOqdkxRRXrM4hfuf4XHamqCfApJs+e
	370RCD1h4KOHlqNrXmYhuHM58gUxef2C977lDJsEKvyvI984H4JYY5+P0a3VHf8UbzYvDm
	cpChonE++MUiCJjlfMWuEfNwADfaOe8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ooTgpcSd;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783684870;
	b=eyebGpPY4nnqz3CeMPhR822xi5ddIhZ0SczVeRCMYOQm2S8NSTj5wcyguQNsfIT9F9BV/N
	mWpGtoBQw1wSsvA5O1fY9OFV/NCulT2WTRxN3mBZgn0bo0DlwIYkS0/RNGT9Enx+8FpC3K
	4CkF+RdYk95jZulPeu4XPH/ubQ2gjgU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SC/MapQaHbUTUI3K9nyriPUJ2aS11yn5U+TrIzZcKUc=;
	b=ooTgpcSd46lfrPEDWKakuKWs00cu0QLHw8RbySElfS6nImXaimL3LSUTZXQOaAxkPzUcQiUmv
	pw1J5+8yi1LAm7VhPbQKFJBPjWKoN6lD4OgfMcxCp7iR289u2ABEzh+wwKz6Xap9uGUr1NP3DKu
	Y9rgV9nvn+06tA+SIyapaFQ=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gxVYD6nGPzmVWY;
	Fri, 10 Jul 2026 19:51:44 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 784EE40578;
	Fri, 10 Jul 2026 20:01:00 +0800 (CST)
Received: from ubuntu (10.50.87.83) by dggpemf100008.china.huawei.com
 (7.185.36.138) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 10 Jul
 2026 20:00:59 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, David Hildenbrand <david@kernel.org>, "Liam R .
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 2/5] mm: mincore: replace __get_free_page() with kmalloc()
Date: Fri, 10 Jul 2026 20:00:48 +0800
Message-ID: <20260710120052.103886-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
References: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: 5dmp7ntd7eigi5fi6qdp9emd1j71xc5j
X-Rspamd-Queue-Id: 5607414001E
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783684869-176272
X-HE-Meta: U2FsdGVkX1/7sAswBzQiLQ4i2UfPihvBUS7Nd7f4wV4gU5z8lg8i/X8p4UhTGP9Eaz6NqSDzDiQIQizvFaQ0919Wk9Qx+xXPKOcd1j42XcOTX46p2HLhWnKNNVFS7tGbFNTIs5FUy7esBxhln/4Rbs2L95rYiZ9/Yq+47je92uTuElQALDoAuljiR3moxKlD3aDLqegukK1N6yk3lGXv6iS0LgPfzmIGRiqln0LBvuC4z/+SdAvcxy9sbEw9cKgWonRkHDcAdwb6WGaauojvMLgxnSM2SMnhTACxkiRvikkawTFwuwxlTlJaeKYOShuPdUbPGrgZoZzqHx33XjCSqM+17mUWGg5IvT67pgKqMzmJ9NVLLEtt6b9JQg4OdU9ykiPDs9/rg7ZNDFLnSVfH/mODKqe9aslX5iQGXI1kmymORwp4oriAVyC5H9RjVMk2CHR5ySL+Y/zCM8bCjNHyD9xnt9QC55pq7ecBD/e8/G91HiFW3ihf37na4l57f+Xclulm8PlY6TNLuerydSSBCmdqaiEAfA4daivoIpOo3wdEL01qv/U4wBFjq+UpgLjYIgY7rdO4v2/097F9KNIfAxi2B1oEtNMBEj9cluOBLR5i084QyYuPeK8iQk6nJy89XtMThfhG9K3I2eVQ06nlDkU0UU2NGpHFxgSz5WTHeVCLl4URhOiciM3pVhMfJs02ybanbDO57JlwfMM2Cs/SK4UCAZA7ftc4cV3wSBIDYgWckQS3Xm/vdLxoqaX7v01Pqq0S0TJ1w61DXELyoipJNqa9XNn0RczmiyKnANFngPRxO3orF8XMIZhVlpHDYMWnJGPxnzlAReWmu+rfCBY/j7x8otcLcVnvwpNovcpp3Gj8eZJ+nSP45vv812krNzJuSSw06avUJK92ifFbJW+bBQ1cn0Gn3f68NLH56K8tcLeniFo9xqKWTGtQAYue7scGXD05U49ccpqCAfT0yxf
 qbeSLjp3
 ZSynbrbmdWMzsWQqcbYijJlU1ljl6pQFUXR8XqxDPhMnmjzxcObl9q221uzAnZ9cvxatE989S3tOkFXRtl/AJqPg1ay0WevQI4CgCDXL6oLnLLN7q/lNiNqsfSB49WHs6cvppY24sQW4BJ88BAKhd0RdLnTe1uOHz/Y1cpMpbXQ8dcp7hnfR8+rWDLLC11no8pSE9sZr0M5tPynJnGgn9dlU+p+v+b00N1pITL8cfTt8n+yzK4+Vs6Enb93JFqSEt13E1BQvBplvfs+ZdqB1NYrE+bKW+yJA3DojQDVXmjnicqpEmHCc3STaqfyLIR+zQu/YPU1vrfnMvUYMnJQclJGyWKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove ugly casts by using the more natural kmalloc/kfree allocation,
also replace GFP_USER(pointless here) with GFP_KERNEL.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mincore.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 0eb832ee0a30..bff19a0df9f5 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -12,6 +12,7 @@
 #include <linux/gfp.h>
 #include <linux/pagewalk.h>
 #include <linux/mman.h>
+#include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
@@ -313,7 +314,7 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
 	if (!access_ok(vec, pages))
 		return -EFAULT;
 
-	tmp = (void *) __get_free_page(GFP_USER);
+	tmp = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!tmp)
 		return -EAGAIN;
 
@@ -338,6 +339,6 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
 		start += retval << PAGE_SHIFT;
 		retval = 0;
 	}
-	free_page((unsigned long) tmp);
+	kfree(tmp);
 	return retval;
 }
-- 
2.55.0


