Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8106410F284B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A957B6B00A0; Fri, 27 Mar 2026 12:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46236B00A2; Fri, 27 Mar 2026 12:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E68D6B00A1; Fri, 27 Mar 2026 12:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73D4C6B009F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:15:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42E1DBE749
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:12 +0000 (UTC)
X-FDA: 84592342464.18.F8485C8
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf11.hostedemail.com (Postfix) with ESMTP id 60D1C40015
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=kIiNtB4I;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774628110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0umBsNKXjUK+2hAq+sat8jSohQzLE1gjCa1ANMaQOpM=;
	b=Yvq8eLWGe6u/hy+G1E6KTEQCJdFyciwQfrkszW3bGvXkOHLy7iJz5RG0n5G86nexYGubVW
	TpTwmpvS1PYhEBxQv72XyT6j5pjMPycdITtPpTnyMd3d0yx+zOVqA4X8kwsLcdVDLm8c8v
	k49hXg8vCkrOL8qe/sxtpheD9OJqYS0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=kIiNtB4I;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774628110; a=rsa-sha256;
	cv=none;
	b=PRQL74jO/uImicEd+JiQzfHpErPe8GNOku7M4Zw5KYjmSZRFH86pATLpdZysyhFAeW/700
	+7UP6Tf4Pug3O+sf+5J2KTxag18tiObpjRm6EiTBbY2EELIUbHnV51acrQd5/MZ/horPdu
	AeWlI7vkYDHMXfhgiInG8Hw1q1f9zgs=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 790D6BE004;
	Fri, 27 Mar 2026 16:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774628107;
	bh=0umBsNKXjUK+2hAq+sat8jSohQzLE1gjCa1ANMaQOpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIiNtB4IPEFvaZh1DBfYaGhPicuKMcH2DZ4M+yTw0SEFwD8mZEQK6juz4PSOLInFq
	 dqQY8DG1kj0mi4YHSmk0th8NR+MEDyQnOPYrQfPCw3GKk/JuhNEiF0QKb0xhxGYI6W
	 LBk7Of9R8uGEyY0BNdFv8ZnmgY3I5fNXicz+QMYw=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v2 7/8] mm: use zone lock guard in free_pcppages_bulk()
Date: Fri, 27 Mar 2026 16:14:47 +0000
Message-ID: <8483097be6fd28943400e11cf498d360110419c2.1774627568.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774627568.git.d@ilvokhin.com>
References: <cover.1774627568.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 60D1C40015
X-Stat-Signature: kpkhzfkhqpsbdtg4kboxaxmfh4se43jn
X-Rspam-User: 
X-HE-Tag: 1774628110-903607
X-HE-Meta: U2FsdGVkX1+EZoGqENdJIKjR+fzE7ZaN+KA5BEluHIDnYQXOXg1qc6R8f8Xc+yt6BB60aud+bbtmv6AKtuWXYcVarHRcNatzTcmH7XcM2akgSer6Jbu3j10L0ceYIOAZWZQD4gzaHBCfzvYCcDGp+rPHuFelL+WMZNNgdO5xjBaRMgoFQcj+dspH7xPOrWjUMUvDdqnGJ+98Ydi2zpSGoORBwlKdk41NkdVNTCkHWfWxT1iQtRGHXmAyGtEo82MlaHTKH16LZzTn1tYEFH/Gq6yiw8+RUu9P0tuVkqscPLUNJrbs/T/tjieEACCjrSdvzQN9ZQ50FT8Ltiea8SaQ7XG5wxQvRPrW9i22Wlf0tHY4x4YSl6oM76hDox1WotX4pFHof0wE6B+nm0Qokee0kCptR0SYwEI3n3nLDps8HVGGbOGVEtLzlb04stxlShyq76Ot5NGcv4dDrupbWJqxkS4l5KEgqQxCpWUnRuaAwuWG5JU4nnasz5nOt2/weggDpQUyCrNxSZCm6wmJRT2ToY7ebRvCSC1SjKGYmHQekjcTbueQq/bw5uohTeoqI8PPaNgZn42WfD+59bk1KJbvOTO6b7n0zSO6MIrbqZI3WhD7AUCJ0WD67yGvL33s0sOHmg9gWE6CVNqnYnkgH7uuR1ZNfFl1g1yAT0tvJdl3Sl4gaWUuQPAClWaYR6PC/qLD7zlj8rSuWDNBI6TiBt3ND6sB/QqtIrqw0YsqnUTdAHrvvj5sjw4qrmc/YV5OH9D1UhNhExpWSYXPNFyZK4Hkx0uwOiXIyUeW2z58yuBm14Skvly8bveBHe3niwNfMEt2KUrhIuwA8LLUUFPVwBwzAcuJs8iBlicn2jXxB2HRStqQSr5ENQ3gGilnhQSwv+u8xtd3wV7xgy6OMN5atzK1+JuJ+bjBi5+bi8ab9RpUh/1VFraZ/2EVwbGgAw5aroz3qBFniENDn5ij2+TnGgh
 g5zgCO2L
 8TP+a9Y3x0iAPWa5ob5QnWqpS4/VXiGiJtinhZSTM3h10LWAZq6mpRyZir5Bz1vXCZSxjc2RCQknuutnuz2uMG3vM2vErv8bvxuOwFS4jGbKgVkLREUelO5uegSD0Q2Tovm99cmgiChyJL6YHUyhg/Q3PJsqfCrr8KQqNP77gDrlK49MyAj+xiDMHYr1kuvU1hg0O+0AVS38W2N7uxIyOgMv0KWIIu1KVyVST1pqHEwIwWIPC4FQX2HxhnJ0dWlXexxSdm83VnWbLNnBU/DpTzioTitvx9jZcTazxRf6xBfBrvb/dyQynEwbczWnBG5Wo9bShHMZ4gji3z7GnwJw8cSrSr+hVH9CyTsgQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in free_pcppages_bulk() to replace
the explicit lock/unlock pattern with automatic scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dd13aa197456..b00707433898 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1451,7 +1451,6 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 					struct per_cpu_pages *pcp,
 					int pindex)
 {
-	unsigned long flags;
 	unsigned int order;
 	struct page *page;
 
@@ -1464,7 +1463,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	/* Ensure requested pindex is drained first. */
 	pindex = pindex - 1;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 
 	while (count > 0) {
 		struct list_head *list;
@@ -1496,8 +1495,6 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 			trace_mm_page_pcpu_drain(page, order, mt);
 		} while (count > 0 && !list_empty(list));
 	}
-
-	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 /* Split a multi-block free page into its individual pageblocks. */
-- 
2.52.0


