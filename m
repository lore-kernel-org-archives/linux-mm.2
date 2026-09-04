Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 236C2C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 08:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8BE36B0092; Fri,  4 Sep 2026 04:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC77C6B0095; Fri,  4 Sep 2026 04:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F556B0096; Fri,  4 Sep 2026 04:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 936F06B0092
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:30:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38496A5040
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:30:42 +0000 (UTC)
X-FDA: 85175408724.10.D63A21A
Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 20EAA40006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:30:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SsjtsYTS;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788510640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4IiFElv7MbBifKONKB5fiMKIqPp3fwvTk3ZzyVCmNo=;
	b=SogYJOv6kAL8o6Ay53+XMSM09tAsWGfqKYxHM16FHWlt5IDXu+IStcy32wjOl14HWCjLDb
	rgEOVEouO4nAQvuM4kgnPIGID6CQk5vsuk+PERvWutWW/VZvUYQoNDbfDUweOCbXZIHrth
	TRYjlXcb57ZoLdl+GUUfbP99ObrsiXw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788510640;
	b=v/sF2+26Ic8wd4PZ22RuGaM094w1d0POO/jADL7/6HtboMRJunzSjS23oyzUE2GCdiCKBg
	laxSXkEr0ww0o2JuQjsPAVCqBPMllBvwJ27nxxayrN9nF4qrkWRQ4qsFHhTD7wIEWRLeeT
	4bSIPZ6vBe9M6bAEkXSNjwStWcPY9tQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SsjtsYTS;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JamvyTb3oE6oY9RFFl9Xgqmjsm7Tu8R7P/y1cNok9Qc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788510638; v=1; x=1789115438;
 b=SsjtsYTSVR5JEdUoweSC86iS4Oj6ynzXNNii7sFtAurZ3kW+vyytR3HWqB2May7cjfE/lRMB
 V1JTKNLve9p2WDhbFwSq/4tIseLOXzO34DHBNAtjVbXT0VJXNS32auLyvF8XVqTXQkbFSO615h9
 iPynoU9GbI3y/03p4SPktRGU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id eb80e7cdd3dd87ca;
	Fri, 04 Sep 2026 08:30:38 +0000
X-Mizu-Trace-ID: eb80e7cdd3dd87ca
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] mm/ksm: convert process iterator to for_each_process_rcu
Date: Fri,  4 Sep 2026 16:29:55 +0800
Message-Id: <20260904083001.553587-4-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260904083001.553587-1-ye.liu@linux.dev>
References: <20260904083001.553587-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 20EAA40006
X-Stat-Signature: 1s3z8hnynsyi4h3eb7qbqy1n4orxy5ok
X-HE-Tag: 1788510639-378336
X-HE-Meta: U2FsdGVkX1+9dNEJ5mNN7uxYGzNeuquMrvt4l9kqEtZ6wQ+K0ccS/yvauP7P69FsnD+BbKM1xN6NY6AzprkMOsa7f31fmYBvPlKP/1wMsPde+pQLO7RGLPgQ6XzIcHaEa7X0pBCeGP8ijlPOsRNon/ZC7o+jGU5GcLY5ZwzkqV+PYy48+k75HQ1buozG2qVCLWpBFQMMM8OiDw/OZlge5F4zUvp8M1VvFOJOpnWAdWbk4IYZrcES0d68JZp0JzbEOxTs6uws0lztjwkXzjn2Kbzprl1M57FHXwz5/gcoFldyfS3ceaNTTKwMoyBaC70+O8HLE86PSmkbQaA812aKDQesPml2rf22PGbG/c0kGmsDxbBeqExaLMk3iYR/UtCsuWqJZ489MLid0iVEtKovykYpvaJJsIW+8YMX/xfVRI9T50u3oBvmVdxh49AHBpgcMUrSSnGW52vcDvpFMgWH5+/mXD5PnGrCo+sdNeowqBmD0SEhWWMC4FzWA4aBnsnMHHzT0AW0nE0cCjbAobKcX3zd5GeRPyxZ+nqlsJ5nqSQf8QkeSD1YLecBtsov/mzn/k/o8akOyj/BuzNjOuXeJeKTuZ9X6CTqd/tnUOV1fMtfTcLx6n1SXYxwRk2rSX67tP7rQnZjAfbtt4Lcv70jnPbTctZqLldHMmBQ06sxJgrZijrTZsGLtNlxIw5iTpqsKsdX9Zrjdy9cQoDA+erQgSZyG3bv2lC4I5jB7AI2c9MHxaVgb+Ej43Hbqd0kswBbIFVhx1Fof9a6y3GAazcqKI8sRmM55SFr+9IUim6V9+VAz5C/hTRaM5qrOVg7psCWERqWJWKQb8v/W25bPCzYWjUd1wKr+g5P9/UPcahgkotN8ptDK+/k1T/2OjlAGCxhMaRNbIJM6mB7aKNlms3U/Z9TeflX4/aQOt1F7ayZNi3JeLh3KEXW1h6QhX0gkgG51d6T9Gk1Cz1UqYZQSSF
 Opc0XqUA
 STN5+evyk5PslQ6VBE4BBrwomlDZrDD23idTwkrrOzCOebdKQ+RrxR0Py1PgfMgKoYvaeB0ATU96j2ONCRlV9BxWtJ+TDCx3qSD2niMIQ/cH292EGVcD7a58klAblfUC+EMASSZf2RfdIyioHJ4gpnwAGwAX7akSLadYRgGVEwR4g4fotn24GRrz6JMOjH4w9qdK0S6fJVHY1S1QmYIA9mEnfuH9B2f7gpmQG6+m8au9NgyVvqmYi7RuIeWp2HWOwYqB5QNXWgcefeeTPqEOEtf/88A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_process() loop in mm/ksm.c with for_each_process_rcu().

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/ksm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 49d48d1e0998..fa5e4c47fb1b 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3280,8 +3280,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 		struct anon_vma *av = rmap_item->anon_vma;
 
 		anon_vma_lock_read(av);
-		rcu_read_lock();
-		for_each_process(tsk) {
+		for_each_process_rcu(tsk) {
 			struct anon_vma_chain *vmac;
 			const unsigned long addr = rmap_item->address & PAGE_MASK;
 			const unsigned long index = rmap_item->linear_page_index;
@@ -3298,7 +3297,6 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 				}
 			}
 		}
-		rcu_read_unlock();
 		anon_vma_unlock_read(av);
 	}
 }
-- 
2.25.1


