Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E80BFCB61E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1F156B00A2; Fri,  6 Mar 2026 11:06:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF62B6B00A6; Fri,  6 Mar 2026 11:06:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C798F6B00A4; Fri,  6 Mar 2026 11:06:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2D1E6B00A1
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:06:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 803331A0559
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:30 +0000 (UTC)
X-FDA: 84516115740.24.863E6C5
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf10.hostedemail.com (Postfix) with ESMTP id CB5B8C0015
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=fnotV62A;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7SD1FN6utUiARoV67vR12WAaEBhC3lHP/DWE3mGruJg=;
	b=WQ4pnc907U+jFVK7bRY93gx2fZwKkMeGzElXTcv0tyqT5dW1XyF/WjulBJAotSEKLLThvi
	Z3A+cjIjnKez6N0T9RnSp+12oDOOyPIuN9T3R5ZZwATgdXqGldScdGiMdfsXaLuxdIzmWs
	3HhaQTfy0gmlbCpgN+EdaRuhxhSmEx8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813189; a=rsa-sha256;
	cv=none;
	b=IKdrsBboxSwoeUeckLMSwEhYAGRVPkeY4ydSPnaj2uLwWtuOOexlCq40CJEVhQKir/IauV
	b1bwotdTIYfb9MgahE+iA/JF1zLTtKFkkz8Kyv6ffGrTCDfsXhD3labCzijQfexkpQbucq
	EiaBn6DOgsXPZAw+/Akk7Ks+qgj2hXo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=fnotV62A;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 86F89B344A;
	Fri, 06 Mar 2026 16:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772813185;
	bh=7SD1FN6utUiARoV67vR12WAaEBhC3lHP/DWE3mGruJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fnotV62Atagvs6s/fhzNgwN3E62OYPBAycgZtQj7EDB0Jmfxz9F6HRVBBXE2EXNQZ
	 JXDEE5IkM8sdOC+gekif3WB0BTXPDOmiX7oyAAvbmcOTTPbltfNJRMUHuxJDDASNpN
	 lx2VzkIRzYVwXU8TC86a53zOj5jMU/brzK1ERxbg=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
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
Subject: [PATCH 5/8] mm: use zone lock guard in take_page_off_buddy()
Date: Fri,  6 Mar 2026 16:05:39 +0000
Message-ID: <9277af9c463a3401e833674d28c8604d314922af.1772811429.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772811429.git.d@ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB5B8C0015
X-Stat-Signature: nin5bwcag9ahm58mocjo7df89w736enj
X-Rspam-User: 
X-HE-Tag: 1772813188-649963
X-HE-Meta: U2FsdGVkX18gxQCLx7LCT+DHNgJOPs658GM0Un2TReiBUqMMewk1kEJTIgE+YWHZXvvFMc16n4cy+Sg0ottJb4InelbwX6XI4/a0H9pXjoQ97PIte3TdaUrd6EKjYgNGkQuV10LjME+gs4+3pqlfAGzhkn68uUS4GYPADuZRMeIPRtgyJLFzjBl7QUzREWB/m2Z9O54+fvVxqRQjnMILtdgGF0ohkAu0ajN2Pg2LpE9HiodEzJh2aCW9GvvdYWsv9SPHmrNMEBBNQr5Ng5u+XfbkcBxbMW68pA4jdTZ0Yu3USW8jxyu0A2DGIIDroMU1KrH77xrsc8TEQ4uKfudSv2dVdAex0XxZKEjCrahp9s4cDfFi2YUyMkXnY/VXR5i+itD5Ob77t2F5U2WXo6EVvtt19XZsXP9CdcidkgTdvGpOx9RFbRETElJi0l4iYnQYCeg+o6HBoqjOssnRHmzkJi8Q8E3fRtPl7HVgW1n3VEovDnBRhFAsIraXDSOuCyE0FP6OtQOoLSolG4RRALR4kr9BsJb8Ic0+JqAOi5TCY3eN4vLOF26HyVmPUx1gVTB91SsdHsrVEdHpxed+aL8TQ2SQdEAGMN2tCFRGJRhQ0CFv5uJnrMjEjJTc+8JGqmUzkHpq6rwLCwXTiRo0OnhWmhsPFhOEfGGYev5s8aIPkTHwNiUx2u+nbzsTzLQQzjo1zslDR0AfMJwHI6P5NekbmYen+8RRG686l5x4kbREWBGCMQ3L8xJ+1nneOpEMhyuQZrZY3u8eZhHGdeA2mCONdIBUJxt81mxbYsWHJ1vq/pwFbtvau4ZXgaydn8VGal1DjT+5778FOa0u64+WMYhpWJb5bZ8PdqE19/olMNQrlkDd3u++hRG4P2Ia9Q52n9azMNRg9t9DeQyG2SpYlCuxzANltyK+C+ShPlQb9vsD/Cte5shswM2r6E2yi4Wg0qr/l8I+KMCEz8xTiQPD2X9
 ar7VkzrF
 qM/OBVVZjuECY0sQDGHNiIfC19YEF5F6HEO2dzwKnvOxLMEIP5kig2rS6HYCTkuP0Fa53sKOlUUbmbbN9x3neUItTDRP8ytKorS/tLfBv5bALXP48xrR0DLqbWn/vNNeyxQaMEaxMNH7a0QgCVmiGGqFzpQO2lIFycAV4vJsYlr+7w2BhV1u9NB9vesSvssSeigu5yvn2S6pwJCrWWRs1OK8+gO3m2tjjzLMxfTJPuH2zcEin5LQquDupz1tQD7ZgOZ6ouRgo32o++s/c1hnnBxnsRIDIGFyTp/udFGL2NazMwdgtOMTgNYu9m3PkFgD988SUxDGMpNEtqjksjmvzAY0iMjDJ2K9guInH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use zone_lock_irqsave lock guard in take_page_off_buddy() to replace
the explicit lock/unlock pattern with automatic scope-based cleanup.

This also allows to return directly from the loop, removing the 'ret'
variable.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2857daf6ebfd..92fa922911d5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7493,11 +7493,9 @@ bool take_page_off_buddy(struct page *page)
 {
 	struct zone *zone = page_zone(page);
 	unsigned long pfn = page_to_pfn(page);
-	unsigned long flags;
 	unsigned int order;
-	bool ret = false;
 
-	zone_lock_irqsave(zone, flags);
+	guard(zone_lock_irqsave)(zone);
 	for (order = 0; order < NR_PAGE_ORDERS; order++) {
 		struct page *page_head = page - (pfn & ((1 << order) - 1));
 		int page_order = buddy_order(page_head);
@@ -7512,14 +7510,12 @@ bool take_page_off_buddy(struct page *page)
 			break_down_buddy_pages(zone, page_head, page, 0,
 						page_order, migratetype);
 			SetPageHWPoisonTakenOff(page);
-			ret = true;
-			break;
+			return true;
 		}
 		if (page_count(page_head) > 0)
 			break;
 	}
-	zone_unlock_irqrestore(zone, flags);
-	return ret;
+	return false;
 }
 
 /*
-- 
2.47.3


