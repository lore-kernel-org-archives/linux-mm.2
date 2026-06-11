Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F44CCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 10:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A20286B0088; Thu, 11 Jun 2026 06:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95BFC6B008C; Thu, 11 Jun 2026 06:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A246B0092; Thu, 11 Jun 2026 06:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 710F06B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:51:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12D4AC17EE
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:51:41 +0000 (UTC)
X-FDA: 84867316002.07.8171622
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7FD06160012
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:51:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hTqlktC2;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781175099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0s7UpgjBDSfz2QS9ezb75mzFmzbkNnsRo0hYTKP+0g=;
	b=rWcSUE4G1r1LczTXfqEi4+YJpLuviU3cAepdGsP9pOnXROgSME+f9DA+lr6Pq/tQhUw8Go
	IWBEa4Y/VItXVfOzO86c5B3PnHNS3CWoddHuDyJV88KadSO2/PvohLkAs5eDqUqnmJn2av
	MH5XHHx42tjLRIZtSApL2nw1NuER8Bk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hTqlktC2;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781175099;
	b=fCuOSBuugZmZCWcsfoWwbIsSXGZ99YfCAXHDt1qmvUCea/rieHcNyRyyimXY2dFKGC/mwc
	WFGu8Qhopgf+IT/kRPaUV4wI9aT1Tvo83+/CIvBxFEuvPZFLxeIIxFRpUVOuTrQyB/Ler8
	xWpiP38v5Kl/uVB2DhlP2K2BaxxJ4Y8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1988160215;
	Thu, 11 Jun 2026 10:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEA51F00898;
	Thu, 11 Jun 2026 10:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781175098;
	bh=D0s7UpgjBDSfz2QS9ezb75mzFmzbkNnsRo0hYTKP+0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTqlktC234qrJRVePFIoWyyOzNDxH6ZTuZLG7rdmABAX1n782qVJpbjakKbenKhKX
	 549+aODTDis3NO49HEySttn/vHay0/ntSMxzqivp66k+UA4qObUl3j+HolO5scsx7m
	 NFXn9hT27+9qR/sI0CctpnMkSWzmyhJ2ElRkZ5bpSnSpVhcgwaqhWSVz7W08NHVUlJ
	 zwstbHtvUS61ctJcgc22F5O4xAZvSA8NrKOlhqT1bFZZ0PL/GLqb6e04S54teFPaTl
	 dyZ/2ELnovdWX5EI2JLhHxsCde7LPPtV3q9kqWpIuJKAgmEID/cmLnjmFOeZhI3BlN
	 M1jsPxHMd7BDQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	jp.kobryn@linux.dev,
	usama.arif@linux.dev,
	shakeel.butt@linux.dev,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 1/3] mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
Date: Thu, 11 Jun 2026 18:51:22 +0800
Message-Id: <20260611105124.98668-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260611105124.98668-1-baohua@kernel.org>
References: <20260611105124.98668-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7FD06160012
X-Stat-Signature: 783xcjfwubkkn1cca7cpi4topcnmg6fr
X-Rspam-User: 
X-HE-Tag: 1781175099-256560
X-HE-Meta: U2FsdGVkX1/zJqMKCVA0lZCqj3QITp8Mn+1Suat3eFNL8IstpXuGGkxcfyz8+bSkw+ueuMdB912e3pgSDqEWO1k+re5pOrz73VUGKSs5A8t+9krGAYzsP66bnmojdRr0wyajCMoCRefGcTtrjom9VkIQcc+9BcRIGadwkIZScI0qbbGFwEflOZnc8LaOAQvJv5jdK0ZPXUVL/RXp1krsOPihDAmsjeA0x5vThEuwCTw0u0VwtESAbZYqvB3cIe18jMpG9Zuy8rCjXvFOfKYQQMUOGnJS/PDHs6JDyDxP1YjNGLxgC4/gpBuAtejZ1TTSD1rHtIogyAzU0MnBZxxdG0+1p1IP4VlddfrWg4j1rXEcMK+ZV91i+Xr9kvxNeEDuhvwcJeepdlqm0A5plo0jTFsP45DmHa59yHzLUoiny2Oa/zU/wRwlDH7vBpBL5nD/OHiToUJiHN3ilGh71SuXOzwz/2xzBHI19BHTWnqdKpSM9xeFJP8y3FTy+4bz0newfQwWUxhnpomScxi2YC6l7XiFfGCDefqruBS7uXFGSrUZBCiEe4+UBLJEpESLa5G0tqz+8hMK/ORcPj787nyUMT24kltNnxA/Rd2E4rtlwHkAyjX/vK7WPOmeQVXBMbs3NUMC0P8c4Ft9BrmPxluMzYQJ1Tvu3AkNdxSZUQP8LONRhJU0Xa8/rOE4ZpKbN1Zv47VDGvSitz18oMx2xiOYnSIcyV4eGao9ziB87dwAFG4kGI5mzhX4Op8lFj4H+U6hBdPcwojxjjGDKonxAldz+aEer2J/qMCLLDZLhMOJVqdzyWwZ9QSQ6oSIpDg1COGEQFADaiqbFArwZYfPy4IufjTk/a7D5jS/BFnhH6W5JE14Ek0ZSS8m1za/UrBHE/x5r12Erluj+ewQOROYhz3+p0xOuJyWcBu03bVRqn/cGsH7y/FMuSFQk5teYZFNIF4MXv5BHd0r2H9cmrohx0u
 k/tFmPMD
 I/thAOaEnIc2/76jIWJpNpq8jtIaZZeaV0+Tt8cd61qRXNsed/+/w/ZfRPTvFaLde3ScAST5XxyEJEAL0KAN5CqWRx+hVlYEfzwwm9e3X0yMgmnrrZjxvIbk3NHh078la1xIi98ubmQ9YN0ddrNgw7sSgecQExZx4/TgnXCP9wI9ZTpTcGUgE8vtSmPchK0cidoBSWjwqiRgmycSJ+RpN7PUz+O7gb2edQ2pk2yH4gtuSO9TEuo+Kzk/Gqzl/BuTcmDJcQPiedttTDq5taSlClnfMkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We always unconditionally drain the LRU before retrying anon folio
reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
are in lru_cache, and use the refcount to avoid many unnecessary LRU
drains.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/memory.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 56be920c56d7..487a34377a7b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
 	 */
 	if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
 		return false;
-	if (!folio_test_lru(folio))
+	if (!folio_test_lru(folio)) {
+		/*
+		 * Assume folio is on lru_cache and holds a cache reference.
+		 */
+		if (folio_ref_count(folio) > 2 + folio_test_swapcache(folio))
+			return false;
 		/*
 		 * We cannot easily detect+handle references from
 		 * remote LRU caches or references to LRU folios.
 		 */
 		lru_add_drain();
+	}
 	if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
 		return false;
 	if (!folio_trylock(folio))
-- 
2.39.3 (Apple Git-146)


