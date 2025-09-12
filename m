Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A8F2CAC58F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 630318E0007; Thu, 11 Sep 2025 23:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60ABC8E0001; Thu, 11 Sep 2025 23:45:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE458E0007; Thu, 11 Sep 2025 23:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6688E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:45:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1B6711A866
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:45:26 +0000 (UTC)
X-FDA: 83879208252.26.8F2D431
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9CD0414000C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:45:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="vCzWiY/I";
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757648725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qyQrs62isi3bE4wSQQlge28P6mKhxXCb0Z1mmjlzN3w=;
	b=7hM4+mZ2pPrQuKIhh5AG3pkVkYafRi/Vk2FAic53WuYkNb41mKl1MHF1LIVqd67YjZ4WAA
	fDX5cYX1cIpA0/snuPpYpsDqc8PjyK5lHo9ySSITNxRnnmbW3XUxUmKEzXg53bToEb/5ZD
	hnVdZWG+5nUEUJAXZdMGubZ/8AtQH7M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="vCzWiY/I";
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757648725; a=rsa-sha256;
	cv=none;
	b=DJBtKjVOJe9AV6L9SxkeouIo3OC4vnn7hTbhnU1jRaDSpQrPeNlQZUe4CZICJ84z9ei0tm
	u1FXX8u6hxj+FWvJke6RaA3CbBy49PPkf6Q3cCSA4XsVb22MtVKfiqewmy3cTe46wzCPl9
	UJMrE0aZFa7JHcTCD9E9fRVgJBZBC7c=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757648722; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=qyQrs62isi3bE4wSQQlge28P6mKhxXCb0Z1mmjlzN3w=;
	b=vCzWiY/IgCjRPy0gleKP5xIdP8Durpis042OY/2Du5B3GUc+ZahPx3y7oeAXwfkjAdQ2rCI43ogJkCo3pgAUFfybOoAzqHwFSg+fapEvw0nayor4QLrmjqDfngN2BJJiSLI3Dt2jLjywxkdM89cOwrtGq/g9FAEbtjbWsBs6Hu8=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wnp4pMF_1757648719 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 11:45:19 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	hughd@google.com,
	willy@infradead.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in pageout()
Date: Fri, 12 Sep 2025 11:45:07 +0800
Message-ID: <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9CD0414000C
X-Stat-Signature: ir5tziu6fysdqc9zebiutd5sbt7d5ty5
X-HE-Tag: 1757648724-702329
X-HE-Meta: U2FsdGVkX19kuuowQiUg9YVJByk3jdon1Gi4llZgsktAY0VSrt+I0MGc5UDc3VqeSTMymFm16VGf9KzAPNVugjoK4SLogAGzSoxe+OtmeF2CWxvTvvzhEAt2f3i9NcEnQlIYyiPm0cShVcCA5pbAKIZOCC6T0neTODiXuUB1IdqOwMehMo0YvN2VQ+nf36dFHTI0tx4j552W8fdFQtxu/f9QLx2yPLc4Iwo7sHyqoyoh4E8Dq0j0qKIKuo9e8buJt0EUKWHtYrPoBQkyw9cazG9rraZNRuLdwD7vT4r3Gxlpg/U5PYM4X5AeSYaa5ZakBI//mtabCZ3xT3EB5j5GdYIndCklF6diAiNlAzeG9ZopwDBgwnJIl/UnLnmNwl53FopNnT3/vsd8dnyPotTAZp3OkFRPaFt3T6d+x19rt7mXkWFadJw9gtioo48Svoa6wIn7QoIm0XmDIzETEwxxHC7MTE3Rr6PM+ppDzfu3BYzc5CHZK6rFPrJ1r1tzaOX39lhMYkfYcGZNdCRwbnMsLetAOy0eJAq+23RGs0ZG1zi+FBI4X+3oDotWVI4hdytHQt4xxJXapsbV+G5wZbOLEVlrp6mccBAReyFCLfdpEvLXEI0C3BmbJwMtYF5ofISxZE/eomBWvM/wLlnW/xM9HWvBlaMOTUh3060M4+JGj1XrzXr4Afd4l2wL7PplfGOVWPZt4w92PemoMl8WGh5ZdHtVBjcK62NPisnqr8tKs+0fczaEqbAyfj3wMf5OUuthGfVNwo5TR4ar7aGXpN5n6Mq3965Kz1I2WiBG1mmeHKedEENWwKTq43aLGDMFtYwcrgmabvDjN1khpCg3fDu3puZccxBTkzsTBXGqhBUJN+RqOWU93ofHmp4CkcvYrzRspc8de7yWG8YF1/vXHzrYstHiMXYEilinqb9HaiAHO+4g8MhJNXWoBoHqt1s4mx22A7knmUZ1t4YrFzXD/6S
 PjR1ULKk
 8K9FVuyo4AMkVOCQZC+rjPYjAb2nX9YtycyDTRrtHFRvHGa4V47KyFu81os/t5aAEn96Ax13wpZRR9CnNXIij+TLe9rMIh3j3xDTLN6wBVwiI6aVT7JnxGuA7uq1UEY43s/hau1tmNpstplLu3LPLRy4lFFKQuJyPfYraUbn1j6Qlpr6Ipy+29FXoyIm9NgCbNb+kISF70+ER4P+sfQvK8L8tzW4r47KTCtZkA2zCQxzE8ewA/U12KX8Y2bmK15PBKSWonmVQ1DDqYGRgaIiRbJQFkyH6AkV0gt2HS+0eIWSl4MQpU6eDJ8X5DXTB72/H8hZ9rFfzBny6dx0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, we no longer attempt to write back filesystem folios in pageout(),
and only tmpfs/shmem folios and anonymous swapcache folios can be written back.
Moreover, tmpfs/shmem and swapcache folios do not use the PG_private flag,
which means no fs-private private data is used. Therefore, we can remove the
redundant folio_test_private() checks and related buffer_head release logic.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/vmscan.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f1fc36729ddd..8056fccb9cc4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -697,22 +697,8 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
 	 * swap_backing_dev_info is bust: it doesn't reflect the
 	 * congestion state of the swapdevs.  Easy to fix, if needed.
 	 */
-	if (!is_page_cache_freeable(folio))
+	if (!is_page_cache_freeable(folio) || !mapping)
 		return PAGE_KEEP;
-	if (!mapping) {
-		/*
-		 * Some data journaling orphaned folios can have
-		 * folio->mapping == NULL while being dirty with clean buffers.
-		 */
-		if (folio_test_private(folio)) {
-			if (try_to_free_buffers(folio)) {
-				folio_clear_dirty(folio);
-				pr_info("%s: orphaned folio\n", __func__);
-				return PAGE_CLEAN;
-			}
-		}
-		return PAGE_KEEP;
-	}
 
 	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
 		return PAGE_ACTIVATE;
-- 
2.43.7


