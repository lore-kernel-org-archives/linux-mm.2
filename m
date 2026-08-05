Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1E9AC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D7AE6B008A; Wed,  5 Aug 2026 10:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962246B0092; Wed,  5 Aug 2026 10:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878176B0093; Wed,  5 Aug 2026 10:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 534EE6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:12:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BDCE71204AA
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:12:02 +0000 (UTC)
X-FDA: 85067404884.21.36F7805
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id E315A1C0013
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:12:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hhsc4gS5;
	spf=pass (imf18.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785939120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSVkiHxOCVF8oGGFv8KCXv/ezUKTNu+0csWqVWaxMlc=;
	b=so4PcDeXlJFBKEJj0WJB3Y0CGMMYiTkLhryEr8vletEEfx3lSj2hy6GyASXhEoyvKSMaEZ
	2LbpUVFLSLgkhoPquS6wNh3DQqy+LFbvM6nlJW3IbrQ6nL2UKfg3Z/cfIFasqiTt4HJ0FT
	E0esl6xDpPFa/7DJj2CYPv7Fgq7GiOQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785939120;
	b=VYow3BAEYOqk7/pwTfaFVeGYgvFNr/njq6yO834oxQAF/AlAbXWmyrNZGz7Ha5QyAspKSO
	r5rddzvb68zDNIV7PT4/DejiyRYwLYXrRdzS4URO20xols/VezRP+L72Zl+mHssdhLF5h/
	YVC3CMpfsEoMrL1B0bcE6UDZ7hZDGQw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hhsc4gS5;
	spf=pass (imf18.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84e04df8c46so1268703b3a.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 07:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785939120; x=1786543920; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nSVkiHxOCVF8oGGFv8KCXv/ezUKTNu+0csWqVWaxMlc=;
        b=Hhsc4gS5uONYBVx3glssslDfk7dh79S9azVv+w1Bz/L+bzFD2vis3PQxZiv0VC6Y+u
         rh/qihxpqkcw0VSh+DDK+vdOz6zt8/Y/NfGWMC3yOmUvozSx1/jdokTUgQKcZknN4Z5B
         Y0UC82xgd+o+wKUV8pMjeT5I2xPXCFzLPO7ZKMpl0zUwmqF6tddYxLBu/4KSHvDPhGtN
         Z4PjOX9/sqmsBgaBqvTKCQXol2cT3bVsPECgwzwYlV8gblWuOSnXydZGpvKy77joSE7k
         Cc8BQ2FbuQQrm0LnbJ38/r4Q6unljD0LNu6tWnICJjiz6NBXXLCFrIBaH8jzoOGUBK0C
         +OFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785939120; x=1786543920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nSVkiHxOCVF8oGGFv8KCXv/ezUKTNu+0csWqVWaxMlc=;
        b=S61dSfMbyeFRu+6Zoy/yvufOITVqUtRa4z9nOo/tqrAQEYL5SI6l/GA36oQ7MPIcCf
         07eGVP0toCMxieoIS5/epzPgpxO3m/xaDKU58+uWyehoY/6IPQSF53BKVp9gcivkuB0w
         w0buoZOj692sJkd4v/6DtZMxYLi7BK9pYHvUSAP9Z4jrY3COn6jHWjdqJBwkRAeHwgKe
         J4hgUxZ6L/31ah/egiLDM+OecKzjMxbQatIrMKeUutQCHmExyIHs/Mro+AdH/7a1FRzu
         BP6MTIbSaYcGjxercW9JPXVkU7qst9nxxsqtPErFJDDHHJXDnd8o48j3Lu+/aMuJCPWE
         +osA==
X-Forwarded-Encrypted: i=1; AHgh+Rry1ge6wedCQTIIGPyLcJOlZP4Od3a15eTJHLCeYhbbZpBENF1LvU6u1yDLCP7czst+CW/d23sF0g==@kvack.org
X-Gm-Message-State: AOJu0YwlSADtyGQx1xkw6W72DkMoWTv/RlyhpzqvjSp5v7dEVxl5L3ia
	WytuP0HVQNKz7EmW4NzXontHLCiZg8ZFlVGXEEfHjqLVUN6W5OB2cUbQ
X-Gm-Gg: AR+sD12PX38GlSlw6ZL/b+sAHChD3k+F4vnfHTNv1TErxEzM4GmsQeRH+PbR1LdaC4G
	alV69SM7vUfnRsQmkrFui9cbHNcHJ/BxUoNFgx2CSrXL6y0oSMRLki0aS9BcoT6TDQWoeFT0QzB
	JBbeWau2Cc4CfjXx/Vk1P4nzJY+oi4R6W5GtEw2LzkUJk6BQ/LoYDUIltj1TITi3zraDn1OcNgm
	9ksVcGWPjd+ARyeAzaRbduyJ+4vXulq84Fq9ucQeb45+tg997VRiQXwGo9l1kvGptWfCDsrFAoM
	V4EyhgUDySQax38/Gbbu5CskY4tqfV3aJfIWpi2svXL1xLYdyNAkkubHn9g6rAEFlebLbCbwqRE
	yzGN7jfj5+5dgVJNwXYWCHhCoa5wv5pLIWLtwM5w4XoEm5ZAJ9Pd66ePDpzs3JrebyuwiTVzVOh
	iqqkVRx8arRAIlUuGoKqU6fLylJldcgr6DqdkyRUhaGQImzNUmKXZlGrt11Dx0D2vlwoVM4YhBB
	F2W5Ck9gEkTVcn8vwxPe+RM1e4J+EVUKoWjCBYfMNCwbqpKjA==
X-Received: by 2002:a05:6a00:3996:b0:84e:5e4:b9a2 with SMTP id d2e1a72fcca58-84f2e0edf09mr7646388b3a.36.1785939119798;
        Wed, 05 Aug 2026 07:11:59 -0700 (PDT)
Received: from localhost.localdomain ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f2e50846esm913940b3a.46.2026.08.05.07.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 07:11:59 -0700 (PDT)
From: Youngjun Park <her0gyugyu@gmail.com>
X-Google-Original-From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm/swap: scan by cluster in find_next_to_unuse()
Date: Wed,  5 Aug 2026 23:11:46 +0900
Message-ID: <20260805141146.127776-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260805141146.127776-1-youngjun.park@lge.com>
References: <20260805141146.127776-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E315A1C0013
X-Stat-Signature: ttepfeeiqghsycn5f5ejmh4ik8wnqbea
X-HE-Tag: 1785939120-543411
X-HE-Meta: U2FsdGVkX1/OQv0ya2MrNdWt9B+ab6tUmokwxLLQLlk+LtDNx/16dvrCPOABEwiKSG9h72p2vpiED1+ebjEg6sAVAK8dwENRIpvsfBmHvWuTNDHvAb51Bxg54fgZOZIgNH0Jk16eL1cmRbFTbC4K+c1dUmhTJwWy06CWidDxMyYnspPg935sbpJ372nG1iJ7TAAi6/Tzqyb734g4VyYvAS6vVH+U9bMq55WMn30HlfYvX1JKK8Qh7dcSFVrUhkH/CZ9S07Z7Gbz+Z2eVEeDIKxGKlZBQQmUxZM7YVpXBaghy4zkYW3RP35NIX+jEcEY7BwIwA7sa85VGAvcp07rlQzyexkeN8VUU48YPAhMfUTLB/RIF73fe5UyEsKiAt9lLsTy0Q24GaIbYAkAdvn+72+a95Bu64H0U67KkfPlb+K/S5/yTjEAUvMpqRtgDWzJxiqpakB5KsctcyDlxHxZrxRSBL8WySJh83Rb0WCdtCb/k5Ag4Un9iEJdrdo/raUfk3cwuab4eM8gGxFv/Vhd4YNbpopW5n7daGesqfbicM893gFW5RZ3N+xhXDbv+pGkiTU8rpcs6ryaeq4wDwaqYdg09SErG56ahU9lWpfPxHsOmCryCvuSCPAozjuDzmSiE5sfQTrlsMvCittRg7LpjPjPbmZeJqesvxTRBE0fWXHTr4k7fgIj074x2X5dVTz062tR4fbCFRS+r8xIJR9jJf+26TxjIoeGiRMCTtnbJ2S6BnuVkoxL8040bkPglbKC5ddoyEwtzfglm34A3ywoxEk9QhgqoQktdsD6C1hFmQGCXKlfjnwsIc2s2RPM8h5XjwJYV9ONUU6NC/YgT3tc0BXFmH5KMLpdicEsB1DKecsi72W7OH+yDmQzcqz7fQUCWlvMEn+tu2VcWfpF9fvsLuvhHZrHPi5it2LE6IcgfO0S6cr2b0e1dmOpOH1mxuhDKbGipEdjaqGms2iqrGxG
 +uHIKNI2
 yPlzVi+cHwlG/PSk2njH3o6gvbCVi5wtso/27RRdeW/u427o0MQWqfnLj/ySChqlkyZuBJGp+d7n72RCQFNfdJaYHs+npVQnGdyi2O4EM76LUiyeNtA7N299Osl0UsbOEeHv21oGCQIy9XSZ2WSiRWJqXIVWo+YkpKL5z+h42HnMQVzcG8KS8B5zuX1qTzDuosWkPAjOFAYBTP3Pk2q4RyPck2lp9X5GtZJyR7W6UYVvXOOR1QZQfQAkw2zAG4gWjgmmVRuYhoaJLsvYbF6j0t9InQxvH14CZA8Zo7CNvgRQ5WRubsWcXaz+KHRQQNJ18mPUNPbYa2BlK3xsDlWklJVp6kLnqzDlpLmC8fxi/Rrg8+Jv36T94kJgEBDvyh0ngro5tlMbxuzX915xgn+nSyq7Sn9aNzlOoSDkSZ+zWHlEO9p0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

find_next_to_unuse() walks every offset from 0 to si->max, and swapoff
restarts that walk on each retry, so the cost scales with the size of
the device rather than with the few slots the shmem and mmlist passes
could not free.  It has caused stalls before.

The flat walk predates the swap table.  Slot state now lives in a per
cluster table, and wait_for_allocation() stops all allocation before
try_to_unuse() runs, so a cluster that holds no slot in use stays that
way.  Skip such a cluster instead of reading all of its entries.

Commit dc644a073769 ("mm: add three more cond_resched() in swapoff")
answered those stalls with a cond_resched() every 256 offsets.  A walk
bounded by one cluster no longer needs that counter.  The loop now runs
at most SWAPFILE_CLUSTER times before it returns or reschedules, the
same bound swap_reclaim_full_clusters() already scans between
cond_resched() calls.

The inner loop runs to the end of the cluster rather than to si->max.
The swap table is always SWAPFILE_CLUSTER entries and swapon() masks
[si->max, round_up(si->max, SWAPFILE_CLUSTER)) as bad, so the tail of a
partial last cluster is rejected by swp_tb_is_bad() and never returned.

ci->count is read without ci->lock, so READ_ONCE() marks the read for
KCSAN.  Allocation is already stopped, so the count can only drop, and a
slot stops being counted only after its folio has left the swap cache.
An empty cluster therefore holds nothing for try_to_unuse() to act on.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index dea2d3b36e06..36e4e8884b76 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -370,8 +370,6 @@ static void discard_swap_cluster(struct swap_info_struct *si,
 	}
 }
 
-#define LATENCY_LIMIT		256
-
 static inline bool cluster_is_empty(struct swap_cluster_info *info)
 {
 	return info->count == 0;
@@ -2763,7 +2761,9 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
 static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
 {
-	unsigned int i;
+	struct swap_cluster_info *ci;
+	unsigned long i, end;
+	unsigned int ci_off;
 	unsigned long swp_tb;
 
 	/*
@@ -2772,19 +2772,34 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	 * hits are okay, and sys_swapoff() has already prevented new
 	 * allocations from this area (while holding swap_lock).
 	 */
-	for (i = prev + 1; i < si->max; i++) {
-		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
-					i % SWAPFILE_CLUSTER);
-		if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
-			break;
-		if ((i % LATENCY_LIMIT) == 0)
+	i = prev + 1;
+	while (i < si->max) {
+		ci = __swap_offset_to_cluster(si, i);
+		ci_off = i % SWAPFILE_CLUSTER;
+		end = i - ci_off + SWAPFILE_CLUSTER;
+
+		/*
+		 * An empty cluster has no slot in use, so skip it whole.
+		 * A slot is uncounted only after its folio left the swap
+		 * cache, so there is nothing here for try_to_unuse() to act on.
+		 * Count only drops here, so a READ_ONCE() without ci->lock is
+		 * enough, unlike in every other cluster_is_empty() caller.
+		 */
+		if (!READ_ONCE(ci->count)) {
+			i = end;
 			cond_resched();
-	}
+			continue;
+		}
 
-	if (i == si->max)
-		i = 0;
+		for (; i < end; ci_off++, i++) {
+			swp_tb = swap_table_get(ci, ci_off);
+			if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
+				return i;
+		}
+		cond_resched();
+	}
 
-	return i;
+	return 0;
 }
 
 static int try_to_unuse(unsigned int type)
-- 
2.48.1


