Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66765D0EE04
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87F466B0011; Tue, 25 Nov 2025 11:30:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825206B0024; Tue, 25 Nov 2025 11:30:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64FAE6B0022; Tue, 25 Nov 2025 11:30:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39F9F6B0010
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:30:37 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0094F58336
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:30:36 +0000 (UTC)
X-FDA: 84149667714.09.FA20AEC
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf16.hostedemail.com (Postfix) with ESMTP id 679B318001D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:30:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764088235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=trPPUo5dkw2o2mDAjlgHrOmAWNfV5VnNC41QBJADk4Y=;
	b=QjfKn9GmngiWgEoZBRNdwddJ2ABsxSTjH3nyrUogQrmkvsazDOQIcOC+lE1H8L3iWP+PHK
	0R3kfePT4yo9zRgVGIbEaX8I7NUeaYhe3MNR9BLLaqX3l/cjAnk6r16Nyg1kQsGH9tapHk
	Fi9xWXxRabrOrMsZGvTCVA4OSEXBUV0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764088235; a=rsa-sha256;
	cv=none;
	b=wmaT4cjt2AQeZBOJOeqFrzPEESjiLCQa01/kp1vOGpgw6mpI9wx+rdR793V/Rl7oCT5mz7
	83eH9h9epNPj2mASXLp4Y1tUWUZRRq9vZHmWHaHWU4iUNikxJXu03PNT30yQkQyIGFxplo
	3bZKbGM91g9paS7kDuLqaCKbflHrrk4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 26 Nov 2025 01:30:30 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/swapfile: fix list iteration in swap_sync_discard
Date: Wed, 26 Nov 2025 01:30:26 +0900
Message-Id: <20251125163027.4165450-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251125163027.4165450-1-youngjun.park@lge.com>
References: <20251125163027.4165450-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 679B318001D
X-Stat-Signature: 6khega1sdtky7cdy19gemjgsfhc4y846
X-HE-Tag: 1764088233-785948
X-HE-Meta: U2FsdGVkX1/RgxrBegXBZvfYqjT4gbHs1gfwM1yzOxUFeu4ZD3Tsox6z9FKo/gfHRaDWb8mhmsHbX4XjxjOBVTCG+RjTylcaT4Pe66MV9HAII92/k4JYab4mqHZOA6Zcnb+WHk4Tlam1fM8GfXkFvSd2aDcSNRQGLb9u2/+nKQBr6XoOzeeA1QoXmz7lInHz4zauFiqDa/hL1TUwFSuySxQHWF9QqYOPhgBfM38EsDovcputx33LdYcRfeHCd+pe/182rCjjNCSZEh7E4CvCUZ6yRkmpVHpOvhSwBB1+peuMfaD39RHN1YGJT9NC/XME14ZZfjAPkqBYTUnJNP8FIMHYl+vi+xikUXWaW8hEWnN+qSlGNxeId+hWo6Ep6LgAotj0WAeexUt0raJFbFqGcrGGvG91ODr1YdiH9oW7x6tNKPJgTaAWLfkWsB7+nzO4u7ubxUraCY3jL6HP58mFHSxaiWsTEhvlU3Oo6W8ClbLCTNdYVB04WRSk5MfgsCLtCXSxpR7WHGC0g4YdLkQuqtJSgGVAHAp7RHuo7OFdwyZK+Wx35NCrVTkPmByfBMphwy29HRUMEbTupR3NbEcPvNpVLajIrdXe5teosrSqN3DN9pP7hY+mI+hu66W7CLZ+Loym81Auu12vaiWCcZTm6DIGzRhrmw0XtcLRW44N3dd3sTgncuk0VH4iRoonrVz40PvEfpKMlUR8gxUBLFQmCk/koRhZlykAtHdfHV162lDYm/xM57Q17NIcTQYa3qNcilpmwwEVCkZZt6ADfmLQkRVcXLUAJWocjH89MZD1YS3PknKKsmINL5dnDMUYKZ+XiJCfRI6zEnb3Aq9BviEqqX5Ln1Wx4s5+2lD5mLTGrMJI6+Q0soglIZd3Ppo9Qp/SImu7Fd2n78+3jMLhBeFGKo8EBrCY02e0Zu93jpm7turUIli6R2svRXWpl3U1i6pf8yNQfGE9H1os5u9naw6
 LaM/ZJS5
 YMfbrtKFKriGU7fmgjo1F71AKH6zCE/0d+QPrnYOgG1Ffcb+Yxy6kU8hVdpM/99fdqUrjMhIs1T+2KyAgpj3jY4DNi7fuwUrjFpLA8YMa9JrULimHyAD9qxWcPOfTcXQP1sWhvxysNLNmj44NnkyfYFDCDMWM+1duYul2/EKxhmoBS2Zic80+uCfuI/OR32bBfv0iN2524dPrVj7PijWJ9IkHLNO+cz6BAQzb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swap_sync_discard() has an issue where if the next device becomes full
and is removed from the plist during iteration, the operation fails
even when other swap devices with pending discard entries remain
available.

Fix by checking plist_node_empty(&next->list) and restarting iteration
when the next node is removed during discard operations.

Additionally, switch from swap_avail_lock/swap_avail_head to swap_lock/
swap_active_head. This means the iteration is only affected by swapoff
operations rather than frequent availability changes, reducing
exceptional condition checks and lock contention.

Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d12332423a06..998271aa09c3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1387,21 +1387,25 @@ static bool swap_sync_discard(void)
 	bool ret = false;
 	struct swap_info_struct *si, *next;
 
-	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
-		spin_unlock(&swap_avail_lock);
+	spin_lock(&swap_lock);
+start_over:
+	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
+		spin_unlock(&swap_lock);
 		if (get_swap_device_info(si)) {
 			if (si->flags & SWP_PAGE_DISCARD)
 				ret = swap_do_scheduled_discard(si);
 			put_swap_device(si);
 		}
 		if (ret)
-			return true;
-		spin_lock(&swap_avail_lock);
+			return ret;
+
+		spin_lock(&swap_lock);
+		if (plist_node_empty(&next->list))
+			goto start_over;
 	}
-	spin_unlock(&swap_avail_lock);
+	spin_unlock(&swap_lock);
 
-	return false;
+	return ret;
 }
 
 /**
-- 
2.34.1


