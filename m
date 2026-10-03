Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3252CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 05:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5092D6B008A; Sat,  3 Oct 2026 01:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9AB6B008C; Sat,  3 Oct 2026 01:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D0066B0092; Sat,  3 Oct 2026 01:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DB946B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:42:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DEC31403E0
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 05:42:26 +0000 (UTC)
X-FDA: 85280219892.20.5187108
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 82C3380002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 05:42:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGcc8t9L;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791006144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Lxs32MO/1KaQWUGPpR8gZBNICnnme3zabEKaWBwIZ+Y=;
	b=ohBlNVQ9akh7JKul7fvbuRMnKDGrRcOo/ePPNTS29Cu4E3Vesghd2kCf81Ftt6UXQJPIuV
	ixfPJnFHRupJVpasYqLc3dIJhZ+Kni1qkKshf6FxcKX4fuOPv1n7EXq3z1Nui7bGVErS/8
	dljIjIiQwdSOGtl7CEwHsogvv6dXU1o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGcc8t9L;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791006144;
	b=jgjSSXYWx0ZKOOCH0N9TEZTRptbPRvcxrY0up+7nDexo9MPyJZW1BXVGipqs5HrkiCo0cV
	2z5ofjmEPpDxB9JP/FDpspaSLaBCzzZSmcCB0L7ciFKhsb4+Us6RPIq/pdUrAzcfA0Gn2M
	b/8+aQATNnC41W+GSPWnH0x5jMHvk6o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D1F0860AAF;
	Sat,  3 Oct 2026 05:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB431F0089B;
	Sat,  3 Oct 2026 05:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791006143;
	bh=Lxs32MO/1KaQWUGPpR8gZBNICnnme3zabEKaWBwIZ+Y=;
	h=From:To:Cc:Subject:Date;
	b=BGcc8t9LutZCkZm4brTVAGjgD20mBYs268Ll02tD8yG/XxcwUPrWlKTrbA180hn4r
	 BPlyC21urqOPvMO8nHC8MKb5ejGX4Oq7tAi+//ClL22VRQskArFVK/rMiZlsByaxIp
	 s3YOhe3ZAm8uQMb9XaYMl1yWHPnpdeTN1PXS6gAyLn5iWCJafcY0bh8aNErru2QulN
	 gKc3IoUd/z5xpbmIqpaGSiSgMGHeroyyvTsXSFwB5NXnrRm+vFoXjoL9coQP4ttOb2
	 gQZlB0B9pm54QqtENseZm9kLHbR8bi97eEDzN1QaHl03eRf/QgjfLPJY20i6XKqEj3
	 TwkxA/w4lahhg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu.xie@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	chenridong@xiaomi.com,
	Yu Zhao <yuzhao@google.com>,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [RFC PATCH] mm/mglru: Avoid reclaiming kept folios during retrying missed rotated folios
Date: Sat,  3 Oct 2026 13:42:16 +0800
Message-Id: <20261003054216.9155-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 82C3380002
X-Rspam-User: 
X-Stat-Signature: ddbo3r7t98xwscoopxjc79ohwehmhnbf
X-HE-Tag: 1791006144-337391
X-HE-Meta: U2FsdGVkX19FjEtm3jjOdY+N3XwR9GGxkNfaH02vs7xNtf1aYWEy/vRODv1JAztyCj5uxagUedcQqTd64XOoP7WEqP6AiLUsIvp0jb6LowEoEcuaYA5JmNKrukJHdgmkkEdRXVTmQnUg6SabtgETFzswaT+D4biLRmb7ngFjr0qB8Pq+16+zAh8nuKnlCm/l/BlzHQoT02fJss9QxXf3pWTqleyHZ8LSph8cLFipB1V5WgI3F0H5tqbVzGUgSv5bBzPPa/pM9hpBfMoprmrRlJmcvGrJtUxsnqpwe0VVDWi0I5g+j3nkz5yypGt3i1aqknh0H2yFDGaydXQszQOtL2U6KaSuxOz7qDE+5I94TdLmZwteytp4A2qfANB0/yZMoEORZcbiku/M/0Yl7stdyY3IifkQEPfhGabP8rNm2flNF1DmKQoOoRQ1S0jnBIou8nNqGJhE2YaUASUwdvqKmukChebsg0BEsRWSDDnZgQZ816WoElIim2G/KeFXyrMtKYVjj7A//Q5hkfiUoRoqMGiSYt41RRn5TxId8wgS1a8Alywg722iVI0gvkE70xoM2UKwx8OYKj5EczQxn79UqsXtNusuRN5u//i+eBaCVlc0C1gm1redfbKE0fcQGhp+iv7Jn6+WeevD81adDM8l7g0P6iGZ2IiaA+Fhawx5WU1Lj9OeGiWgg6vPsxiNk+GyBKogAj+Y6lXGaD5FhKfUs1XuWPaxqCJ4/AYnMkWGOdqOuzLuASkDrcR0VIFMdc2Z9HJcEuwv6Pk3N+AgX/F1ZcuNLYpThDOItHdNb28ncTZCoRE3El34S4fiYjZfsWvAhA8wkTms6FytkBpS2bK2/vlde4XHEGsTwmByP+Z2wuXX+46tIuZBNEBiaxFcdAiVCzH8Z1Mxsz5H1J1xs6IrrmVrLEsOMW+UivZ4cacQaxMtcZwMNjSQe2bvr2TJaPmRaZaJ54E5kW04IeVc6FA
 r4pvFat5
 4+1GvKRkvJejjlhHYLtCIBJwXRrMbZUg8fg5FTYEy7DaluefyLqsOgoaS56eEI975AdFoJFN4KK8S+q8S+kwgiXZKw2J5x2Z7yrFA/eH4px6Veow82Dri/GT1gHcGoXMlL79stiGtTieIFJDoVo2Aeg6Wf6Ha9vV1EzEpkalbMFdIRGIcEFAUOv4dNIT8Dl/c7GtFi8oGZZQoNhUfLp7Bbao3NSaoEKvV/zOsyFaKeNzBpwlPvdWN+P0d/B2pNOrrWKmh/bO2eu/IkodJYPbxbECOBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 4d5d14a01e2c ("mm/mglru: rework workingset protection"),
`folio_test_referenced()` was accidentally removed when checking for
missed rotated folios. As a result, kept folios without an active set
could be added to the retry list and eventually reclaimed.

The impact should be very small, as we have the `folio_mapped(folio)`
check before retrying. Kept folios won't have `try_to_unmap()` called,
so this is really only applicable to folios that are unmapped by users
after `folio_referenced()` has been called.

I'm not sure if anyone else has seen any issues with this. Sending an
RFC to check whether it is worth fixing.

Fixes: 4d5d14a01e2c ("mm/mglru: rework workingset protection")
Cc: Yu Zhao <yuzhao@google.com>
Reported-by: Bo Zhang <zhangbo56@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 91295070ca33..6a931b576b7d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -994,8 +994,10 @@ static enum folio_references folio_check_references(struct folio *folio,
 		return FOLIOREF_KEEP;
 
 	if (lru_gen_enabled() && !lru_gen_switching()) {
-		if (!referenced_ptes)
+		if (!referenced_ptes) {
+			folio_clear_referenced(folio);
 			return FOLIOREF_RECLAIM;
+		}
 
 		return lru_gen_set_refs(folio, &vma_flags) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
 	}
@@ -5110,7 +5112,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			continue;
 
 		/* retry folios that may have missed folio_rotate_reclaimable() */
-		if (!skip_retry && !folio_test_active(folio) && !folio_mapped(folio) &&
+		if (!skip_retry && !folio_test_active(folio) &&
+		    !folio_test_referenced(folio) && !folio_mapped(folio) &&
 		    !folio_test_dirty(folio) && !folio_test_writeback(folio)) {
 			list_move(&folio->lru, &clean);
 			continue;
-- 
2.39.3 (Apple Git-146)


