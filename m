Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82905C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26ED6B009B; Mon, 14 Sep 2026 22:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFEE06B009E; Mon, 14 Sep 2026 22:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15B06B009F; Mon, 14 Sep 2026 22:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BCBA6B009B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:43:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1079D1A02D2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:43:46 +0000 (UTC)
X-FDA: 85214451252.18.9BE228B
Received: from mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0C8AF180003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:43:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jOLQNcla;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789440224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0Mmbjr83lh9wNnv9KMWzT+h0nEGSjHnCVH4C9/hyQA=;
	b=mQzPMOI0dOsXYcbUpxYljh7A2hNdxzyu42I3037zJ/uTq4gc5NozI3gHi+rtojDYJbJ9Td
	7v0jjsmpu4l3aR8HY611TAMB5MP3C0v+YATRkOsPDhIWzXz7c86W44Tpe8UeuJ4zqFtISb
	1RMqZpK4j/z3EChwtARvHkFnksJ6VQM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jOLQNcla;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789440224;
	b=PbI3DzZVB4mX+zzRciRtA8mxmqmNPFkXfbcbdckLBCrHfyC/zKH9oeflUuBT73XSSofP8g
	cEfu25KnVP610LzxBlymgmzAIW9PpwTrnJHmKdp0kSTlUOdTyDWFZFpEVRgdu3mlbAgM6L
	WWGnjoyBPURpV5IxIeIGZDhcZ1dnOKk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bALxJHIgAAekMhWqcUjYkzxgbHtb4sDDdgHlmxKh0to=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789440222; v=1; x=1790045022;
 b=jOLQNclagNVGQExjMJXidEsqipdzNc0JwJw4bcPHEAwXdQ1mEyk9k5JwUqouz8yv2oHwwYiH
 0FtHRT8gUjUdRitaoPr4B1xY8wy/O6zBww+DsfpiTkr/uH/V13Y0DbLEgru8o4SKVgO5tIybstx
 UONbIVXYIZF1IRrxHoz169+E=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b622b93473112159;
	Tue, 15 Sep 2026 02:43:42 +0000
X-Mizu-Trace-ID: b622b93473112159
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Tue, 15 Sep 2026 10:43:32 +0800
Subject: [PATCH v2 3/3] mm/vmalloc: extract show_busy_info from
 vmalloc_info_show
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-vmalloc_study-v2-3-cc4dfe635e22@linux.dev>
References: <20260915-vmalloc_study-v2-0-cc4dfe635e22@linux.dev>
In-Reply-To: <20260915-vmalloc_study-v2-0-cc4dfe635e22@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0C8AF180003
X-Stat-Signature: gusfrrehyjzrckzt9rgoog89hto47p6w
X-Rspam-User: 
X-HE-Tag: 1789440223-303820
X-HE-Meta: U2FsdGVkX191lsJTUd7bTJrjSJ8B/eU1i1x4tt005ZsJEVPDsujFSUWpRMraVgSzmOugVgS59aPtFqvB8kgsCCBcLsAPV6dHejwovz4XyxkzQncFaHVtL2M1PWrBmMh86S6GPL7WP/AmQyTuGxSyrXVjDJBhWsjnyHtI8XuvEHVonOwgQ03MztXR26/A1gUphCZmKw6Z8K7L97vc3ryEAntSLQ2v3GoA8hL+rR96gWcpCNmXQJJXDqFo/Te3Pv4Ruccp6MqoOIE6jx2XRAavKh9hw9KGpkmSRqQOuh0AnM54SbALRWMW+FdO3G1XofK3XaHeaZ5IExZsHgU6PBNQ3KlYQnp+pk7fNJWOZUEfvfcQ6s9VYxI1XuBVFe+B1s/rfZwWMUbvhxNZr0f+Ca6SQY2iXsQ2IqRnyAEtj1UmbqfZudohfB47ixp6mqFewQygkkI4CJmyILl+a6lcN+La1yDWYRd7xjtmo1LdDvQh1bfMDA/iJKKxDXkK/QQ6S/aVcF0LpFlMr5rXDSIYWc3NkKB6OBDcIAP2KdVIlMRtLx1DVaz3IteyWVH075uYOyEhu8QHmx7foDyfr1a6z/gkxyjtWWLl4KK7w7bskqtNVtR9Sssv5ALxn1Xh1WWop9tFC6dY1KfQi2PpGoiSQUqEfBmSpi4d0kP+LOR/bJ6mWFU87ysUhpbL8MLiHgmn70FvhkfE5hpM5C6RFVW2Duan7r8RKvKwc2aX+LSJBbvNspojBcy5NdjOvPhtnrhTd6ZXb9QeHKOTZzPTScSDxuBZmFRqYMOpmO6sF/lIDcX9Gil0DRX9+REdiFTm6z1MFogiNSZvX6lyUnKCs5tUACHMNj3+NPpdxjV/hdQZurLJYKY2epiVHWfWgx3eFWUnuE23JaYOOLtOf3gYfw9oTdrBxE1mzp1LYjcceODezL7QO44qe/XB69QgfaDdZArzIV/t4KwldD3j/XZCiosEYq1
 CiNzTkfk
 rTeAp3VHTgnfnoNKDkor479jUrPzynXy6KehS7de3Tq4EyTXf/fl+zan6iTfludBTTEJQ7JbReaiGmY1GvfNudXJE9Fa/ZscO2rUHxPfIQ9kGGIB5q8bxqpSBwwXnwbv/bI4eDA4b/JBP8JSANkFGyuzcVmPnmJSB0kjOR61NrolfTkottgBuc32E4RRecycuskzVRx61mYPe165Ia1io5HkOiNt1QcKE59z3A9ifsRpyUgSVpdJvhKEytqn/q46TtJDxX0WPOTOemyXmCpEf9VRgyvzCvPsgRoKZ9MUDLNXBH3y90XT13kxn8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Extract the busy vmap area iteration into show_busy_info, mirroring
the existing show_purge_info pattern.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 973d15ef4f3e..e09d6c8c8b35 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5345,7 +5345,7 @@ static void show_purge_info(struct seq_file *m)
 	}
 }
 
-static int vmalloc_info_show(struct seq_file *m, void *p)
+static void show_busy_info(struct seq_file *m)
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
@@ -5415,12 +5415,18 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 		spin_unlock(&vn->busy.lock);
 	}
 
+	if (IS_ENABLED(CONFIG_NUMA))
+		kfree(counters);
+}
+
+static int vmalloc_info_show(struct seq_file *m, void *p)
+{
+	show_busy_info(m);
+
 	/*
 	 * As a final step, dump "unpurged" areas.
 	 */
 	show_purge_info(m);
-	if (IS_ENABLED(CONFIG_NUMA))
-		kfree(counters);
 	return 0;
 }
 

-- 
2.25.1


