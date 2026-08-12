Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05AC7C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371BF6B0118; Wed, 12 Aug 2026 08:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349626B011A; Wed, 12 Aug 2026 08:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239786B011B; Wed, 12 Aug 2026 08:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECCA46B0118
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7680AC02EC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:50 +0000 (UTC)
X-FDA: 85092521220.10.CA5CFB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E545E180007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TDHRF0AA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7y18sjno+mqqfvWT6M0Hi+njMwHX33SQLnmAtAwqGs=;
	b=O4eBRcVm/mpQfPHTBdQQ4jXkfbjib+663rkCo+wpDST6PYo4C6XCRpZgcWhU6xOx79GVZ6
	YTMB6RH4E5om08tKqBU1iL2F7UatJTMmS4EP4/n+uq0m9+5ImzoQw82JQcnBpocSmVQ7Dr
	b8NJCWDN7gCMpl1fSj+pZB+3M99w+y0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TDHRF0AA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537128;
	b=rM0IMWIiBs3U/98yp/jlBSjljpHGPdzhKUp6OkPVbS9/+JK7lwE0dt6lZV1H4n8RGFvBuP
	mOIU0SEu7Uzt68h4IRzlLsRqHQW0A7rHVh30mT67fD0Qtumwewaf7AIyBOHSa1RzP8AZP0
	j385N5oSU+h2xg/Wa91+B7Dw9wHN6as=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84CB260AA9;
	Wed, 12 Aug 2026 12:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70D21F000E9;
	Wed, 12 Aug 2026 12:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537128;
	bh=/7y18sjno+mqqfvWT6M0Hi+njMwHX33SQLnmAtAwqGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDHRF0AAx2OOlCm8oAlPxzA5y9oDBvujnLCSFyymC/pSzwTLhFqIjrF1qgCL+S6NC
	 DHXGcfnZOjAWJKb84DOaCDsJa6v9Gu9OqqMyJ2+T3GCeV3qQEx9DDbXCIAEZgw50bn
	 17NeIAML5u6HK4eslYC7gpncgsV1041VbVBJYK7xUxCteC+Tbfd9AjKmrQZjrrAQfN
	 B/cFvSsV8oAcNQy+IuR55UQXb+4kBk2WH29LN9D+8nTMRvCw9/liM8Hv+zItrxJCDK
	 Vc1XiuvW3qT8RJBbT+SrqzX7T00HoUhIIhrjrvk8rwYlIuZ1yx3cGqqhE0O/J3zXCl
	 Ao2pt8sE1CI7g==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v4 11/16] mm/mglru: skip gentle reclaim at DEF_PRIORITY for extreme swappiness
Date: Wed, 12 Aug 2026 20:16:53 +0800
Message-Id: <20260812121658.69965-12-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zzfq11bpb6wrhsfs6w3kyy456sunow94
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E545E180007
X-HE-Tag: 1786537128-298927
X-HE-Meta: U2FsdGVkX18sRecA1Azrp5MJjlTo8VqiytFClFy9+sMarZD/cjrPbdpGkB42u2ji3B7YdOclG1HSOrS59JBHrf9Pgthcc9YfN507eymYRW9/uC9ymdSetxPdVxAq5GcUEyjpJR1DkXb8+TUzH3cS7RZ91wp/KxFUu/FDeNJkxJeBDbpK8z0ql7nAIgjCp9IhdMtfN5eAPnOHLzJz9DIdmJBquHwFOifsn3MULarlVC4QWvusWrPm13P7aeGkPNt6MaeyWBQIPha/x84YVvbbZoKdjP6qLP9+pDQ2cRKHeZ7pbmr9W/95i9DbnXYCm3mOcD62r2DOQyZk26+emhwa25jHsdS3xSSSs6mkvKan3aI6cc8rFngyEoK/ZMnepgfE6ASI/lef8YhyFPp0V6TLyp5Be1V0xbLJEduoD8XOXPqT2EL3S69ShwCou70hSo3JzZVb8dvycdY32XVd+h2Ns6FZOHqR9x/WfDYGnWjtNlwQsVaAZQeWWLcmLZJck6qL/DuipiabTtmspfMhFLT2qKEB2xij7o1G4qkM0NCboJjZudmYU+UhmjKmh2jkWvW6ozSafkWEXYergTFPAwwt+MzvcKlzeCECEt67xAyeaS9eumbS6NWL9Cq0tvGKQPifE8cmTMvUTLkX0Sale6qpWZflFEJStc6Y7MB5QsyeBAmXMvW6hflVkBqY0KbNLB6J3q3WY/7SgXIo1ftJMSQZs+gUQ/EeZyFm9oH+AHups1ZS7TOPeAa8s6huFVxeaGzKfIJshla89O+Sl0xYsQQu00VDwIi2jx8rCxoVLFIg4ijAU8XxVlY2v5zQHn/BnzA9oX5Rxv6w7JYqSXBS74sPHorVcVDdtzf6X+pmE8iYVeeRb6n+xHO8KYUi4U8vr4sF7P82jGtfQrBLB3z6oDTU4fFs8tAV4A7LZL8XK3/kKGEiGrHsdctvEQ7Y1JT+gHB1oKGBfTq6vZ6ftuQh2IG
 ahrMXUQQ
 7KCrKutT8MvxqsU2JR0Q3Y4/x1oPbS+AVvD6IjvlhjG2Ic+C71T6VDXzShVZ5H/OM0s5rfIcVBuseCJ42ruoc0Y5lQmy2AXsZlDpXtx7OZlZQvEv4vtY9CxM5K8q5CEvBbbjjend5l+iZwvCbmVc0mfaprASFGJ9Bk4WlvdR27TQG/lUHIL8EpKKWUerYEopLMa+Yk+pntz/9/imD88Jrc0WM+XPG+EMlJC5ZS27YciQPIrDmGkyXdSpUyET7JR+UXuucWOo7453kmZgGE9hYDvUtl8IxfceJTcLMV8GObKawujje+dZt2m8HYkvM5X3RZGKIRwaiJZzV2Pf1AFXxeyKxEGdvTWWvywgPubz0VQLxoJ7DRdyxJsUTmToVQmayuEnOquiLewUTJWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For extreme swappiness (<= MIN_SWAPPINESS + 1 or >= MAX_SWAPPINESS),
skip gentle reclaim.
Falling back too easily, even at DEF_PRIORITY, undermines the effect
of extreme swappiness.

This matches the logic in get_type_to_scan(), where we have:
        if (swappiness <= MIN_SWAPPINESS + 1)
                return LRU_GEN_FILE;

        if (swappiness >= MAX_SWAPPINESS)
                return LRU_GEN_ANON;

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b6c17ece3b3f..48a068b50678 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -281,6 +281,13 @@ static inline bool is_exec_file_folio(const struct folio *folio,
 	return vma_flags_test(vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio);
 }
 
+/* See get_type_to_scan(): these values always select FILE or ANON */
+static inline bool is_extreme_swappiness(int swappiness)
+{
+	return swappiness <= MIN_SWAPPINESS + 1 ||
+	       swappiness >= MAX_SWAPPINESS;
+}
+
 static void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
 {
@@ -5094,8 +5101,11 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
-	/* try to avoid aging, do gentle reclaim at the default priority */
-	if (sc->priority == DEF_PRIORITY)
+	/*
+	 * Try to avoid aging by doing gentle reclaim at the default
+	 * priority. Skip gentle reclaim for extreme swappiness.
+	 */
+	if (sc->priority == DEF_PRIORITY && !is_extreme_swappiness(swappiness))
 		return false;
 
 	/* better to run aging even though eviction is still possible */
-- 
2.34.1


