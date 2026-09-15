Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1623C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5F536B0096; Mon, 14 Sep 2026 22:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37406B009B; Mon, 14 Sep 2026 22:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9966B009E; Mon, 14 Sep 2026 22:43:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AF836B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:43:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C68F2402C8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:43:44 +0000 (UTC)
X-FDA: 85214451168.07.AB03E72
Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id C05A81C0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:43:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mKk2zpXv;
	spf=pass (imf18.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789440223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVnTq/hVfntkQ0HRolgLqoiSN2sR07gRrgvmIygH9UE=;
	b=3EF7RQplLIiwqzOpPC2kAHA9JhtRsB95/I6/BKJGZVsAzMJiYff3ylMA7mz8RD6Saz3COo
	8eLj1lnnY/lFgOAB4jB2dskijRQLRiQ+JI51DNcUVsC45DwOJa8+Wj/pcWHTT8oQEhE0q0
	1N2HF6glpMiU3VRS+gnvsZAWckmPF8c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mKk2zpXv;
	spf=pass (imf18.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789440223;
	b=8Bul6vuhhG+KMXfjOg6LJX4YY94m92C/sf8ZW/sKhR4krlc7dPoZP10zOUfO5ch1Y6Bwze
	UOHsBpXMo8lTa1gPU/h8c3VodPmKHM2/IerYpnyjZDbWyO+xFKRWoVEJC9wfzaVf9WXoEs
	aQR8iBvW6zCrxROVXDGuZ3ZuwkZK0uw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=F73hVyZvf0eZtl+4VEeziRhY9hxVXl8gY1uJk53dZ98=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789440221; v=1; x=1790045021;
 b=mKk2zpXvRBnrjD76Y/5amv0teeUuJoz+PwTU4C8VIur3dzy8xHK8+2JAYAU4xWwhbzB0CuZM
 5z5U1WSiIDQgE/ueU3vXJMUd23yglqZnvbOzagLri/nu3GFZie9JPV2BHE21VBWuF32CcJKIeYR
 aXVPqXhZ7bCtIgEuIdzPAsaY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a551f472497e0f01;
	Tue, 15 Sep 2026 02:43:41 +0000
X-Mizu-Trace-ID: a551f472497e0f01
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Tue, 15 Sep 2026 10:43:31 +0800
Subject: [PATCH v2 2/3] mm/vmalloc: extract vmap_insert_free_area helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-vmalloc_study-v2-2-cc4dfe635e22@linux.dev>
References: <20260915-vmalloc_study-v2-0-cc4dfe635e22@linux.dev>
In-Reply-To: <20260915-vmalloc_study-v2-0-cc4dfe635e22@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Stat-Signature: rw3wx91o7p3bkzz3gm3588jf1cobabp6
X-Rspamd-Queue-Id: C05A81C0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789440222-613061
X-HE-Meta: U2FsdGVkX19xUh0hUOAM25mpd70r4Z1ScbNxOlbFzLSnzVyS7CGZn9R3cx7B3ohve+uur+f6nI9jIsa4F0rMn+7n1OjCssERMB4cgVyTGuV4AoQl27v3IZZQ8Q4keF9pt8SZarvJrTJ1R9Zl4IRjoN2GUy65/xlTd+dbexJ89mSy8P843gJKPqYzz0/X7bgfMm33Lttt3nD5PnHnl6DM73VXqvCId91Ct63GfWyclNSc6cwbhbxnP4C4slIq875WsWc+Ae6kEpZxpAWU8ZElUnkhY1+kH9avrNaPumNtx2yDcPK7JYumT1VLIqeZwD78gCUhZoqRWvQehEwlJQU5wgVQDgIZatkROUEWblzsRmQxGjKUD2XX8Asl+AHPVWAK9Ko18q1InzOXjnPqRMRVYCtHn3lyRP3rtstlSTd9j+qln3wcGJLila47M6HUWgI6+wyJZHlvmRoAAFWw9j2l6CGlwgs1P7n6HOMKG0ZHo1/HZpereTRiFIzVV7fVmTOlqrN9VvI7lE2W1fAc6eEqb3AFRso8CbE+WGDgyCz40w2l/l97eohlM+569CzWRxmtvGlvxNZicfPEiWM9Askb7FQjnMtf1QJAHPtPxOyiqhUgFhp0r6oXPvTGfHYGbL0sB2zmVedkeFuMbd8uF6IluhPzzYhZ4ZFiuQ9qJ9JlOF9YdNHcoxwkbFMivcW7mmpK7e6bVWjnReTchs0B9N+4AvLpZkEGWCwqKw5BrbxKr4dqNxOmu7HPgVMq1ZYlqSFS6gju+E3zbNo8YWARgNkhAO7CzRwLkKh5gCvZgLObSw5QtseoM/c6bWdIiXW/r6LVvMUF2vwRBsvsgIRkJJi+HuDCkXQWwpsNS/+pPcIfPVlz/gfcg0heOyKFgkWRTbvPYfZ0FEPZN1JsAVJoXGDzJfUU0aB1+kYHJuBOAa28TZkV9uT98j3LHRfBC34yyBLEcD3CjvIYe83nt50+IHT
 HPJwmivs
 dizkyYMLvP2c5KH+S5OD+N0krc4wXt95Tj6Msg8xrYmq2+2bBSBZr8biZ9kN7wDyMQtCkQS7v9LcbeQeEH/wEtMFvxk/JThv7LSaXX26fpsZltQlx5T3eu31WRRvznDrKEkJefGUjqJ/x33mXhcOpMgs+V1aeWIW7qViZlBKfDLvox4h28p0UBI0MZiSmI3+M7mExLx0YZ3gnzZzi2COp/eegLM5qeMNTWfN9V1/MQKDbxesNUjLDMHsLma11akyDKHag7dNJS5ZoKrxQiwAtf2WVIlsXx7zQzZX8LWLVwSGKIdK6caDz4YiSzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The allocation and insertion of a free vmap_area is duplicated
between the loop body and the tail of vmap_init_free_space.  Factor
it into a small helper so the main function only deals with computing
the free gaps between busy regions.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 117483dd048c..973d15ef4f3e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5433,11 +5433,23 @@ module_init(proc_vmalloc_init);
 
 #endif
 
+static void __init vmap_insert_free_area(unsigned long start, unsigned long end)
+{
+	struct vmap_area *free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
+
+	if (!WARN_ON_ONCE(!free)) {
+		free->va_start = start;
+		free->va_end = end;
+		insert_vmap_area_augment(free, NULL,
+					 &free_vmap_area_root,
+					 &free_vmap_area_list);
+	}
+}
+
 static void __init vmap_init_free_space(void)
 {
 	unsigned long vmap_start = 1;
 	const unsigned long vmap_end = ULONG_MAX;
-	struct vmap_area *free;
 	struct vm_struct *busy;
 
 	/*
@@ -5447,32 +5459,15 @@ static void __init vmap_init_free_space(void)
 	 *  |<--------------------------------->|
 	 */
 	for (busy = vmlist; busy; busy = busy->next) {
-		if ((unsigned long) busy->addr - vmap_start > 0) {
-			free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
-			if (!WARN_ON_ONCE(!free)) {
-				free->va_start = vmap_start;
-				free->va_end = (unsigned long) busy->addr;
-
-				insert_vmap_area_augment(free, NULL,
-					&free_vmap_area_root,
-						&free_vmap_area_list);
-			}
-		}
+		if ((unsigned long) busy->addr - vmap_start > 0)
+			vmap_insert_free_area(vmap_start,
+					      (unsigned long) busy->addr);
 
 		vmap_start = (unsigned long) busy->addr + busy->size;
 	}
 
-	if (vmap_end - vmap_start > 0) {
-		free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
-		if (!WARN_ON_ONCE(!free)) {
-			free->va_start = vmap_start;
-			free->va_end = vmap_end;
-
-			insert_vmap_area_augment(free, NULL,
-				&free_vmap_area_root,
-					&free_vmap_area_list);
-		}
-	}
+	if (vmap_end - vmap_start > 0)
+		vmap_insert_free_area(vmap_start, vmap_end);
 }
 
 static void vmap_init_nodes(void)

-- 
2.25.1


