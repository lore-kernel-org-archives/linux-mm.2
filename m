Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D2CFCD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76BFA6B008A; Fri,  1 May 2026 17:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742386B008C; Fri,  1 May 2026 17:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630206B008A; Fri,  1 May 2026 17:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 477756B0093
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06D0DA02B8
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:16 +0000 (UTC)
X-FDA: 84720078912.10.716EA82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 086F0140011
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DmFIAXtO;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669454;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s75X/xsg27+0owfl1FTmDc2iK1mRBEkOvMsJcC5aWDQ=;
	b=w1BT2Bm56MQGHCo7D/yF2G902jZ2XTZD7pDI+sfAN3+Xb/ulug0Nhrnyhrm5HfBfwy5ZXH
	tyd2aTGzbdb11oYkOSpX9lwuyqkKdNMmKYwZy84bh3haH7OfcbphBSAcr7SbxpCzzGvo9s
	ZEynjlWPfJlhhsfCY1x6WVTPBdEd8Pk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DmFIAXtO;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669454; a=rsa-sha256;
	cv=none;
	b=w2gAaIoZDgfIYEZ6KSkbiz6+NJ2rK4c2gRn+7lSKvvYGQGhgkWIlnnCuJsRySvLdHby94I
	va6INJHINZ6Ma04peeCm8i/qSor4b0lSl9pvH+KTAjDLeVfoINpWzMpACJIeaY2HfLo+6O
	QDSHMKV9MW7lrEdfJIWaE5x9ZXiprBA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6217E60120;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EE78C2BCF5;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669453;
	bh=CSC1oi4wyTxesQHZPPunJdMxPvfSzuzhFGjoMvX2PIQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DmFIAXtOGlRJorh94KbBVFxch7PD6wkK/70yQ+Bj8F2VxZkvozpE7G64d/BvqhlfP
	 Xc6Q2/WLLjgaPKGmBtbnVdZ65tQQGdkr1rm0Lliu054sZSIM5ElJ/T3rtEnz19IgXu
	 CUF/9JHL/R5nWq+izgCXDCr+Y+yWA5yWASNPkhwQIqxyQwgFBUzwV6gXjv8uZAI1u5
	 ESRKeugdqKRPmcyAkOz9lt+WFYOjS7CnUq2oqOkttlHOFCh9Pkehx/gwW8qB0Wpdcv
	 1Shruaf1GD2DGbjLykT8YkVOUyBgr4TWe3kUmEf4RIXeu/Bcfo1zIeVDBvSQiPjbbH
	 8z2sWMtLfPfdQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03237CD3423;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:00 +0800
Subject: [PATCH RFC 14/32] mm: convert rest folio LRU referenced usages to
 new helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-14-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=1270;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=s9IM5saCZOi1yMrQ9wd37CGnZKAxDY3IwusY5KAp2fM=;
 b=AjjRfwfd76/c82mEMrSgQlxsNUhdUausxOPl6q2Enso4MgBpO0AY3ccxZG3B8/BDqvylfIBb0
 ERx+uZevY/aDpfqVoUhUizG7Af7iJlG4HWFUFRPpixkNa46KQ/KyKiL
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 086F0140011
X-Rspam-User: 
X-Stat-Signature: m7ht8nksrprh1t6zqd45de7kimzodfqd
X-HE-Tag: 1777669453-519585
X-HE-Meta: U2FsdGVkX1+4JuqgdlghfU47e8aT9LcP8CIWC3Rftcaejuj2gsfJoB5U7URehtzHOKIBAu7ss9p+LfiVU71qbody91BZ8pLPE3fhK3tgIHb4UdEBJa/ze6J+Iip9mqZbpIXOsb72sGl22M9T/Tsd/qaJMYRBUaFkvTXeXG+IcivI6kgztQTJRjFHAUfwijxGhBhVneBf9Y7eoKnfcsMnlsD0ceVpJKUC2qNbl7tATGESln0LgYSU6hDwDrD2XRxfHehONBYmkFZf0mdcu+XcxFpDc8jxpC8kvd6c8zWeWIctPdjNtrAm2ml0TR12j0Sr3nn3pAH4EiscyMnkaLSQdRovGcJeH8qXmxlAQyXS6WKuhHeIWUPrux0lXnepAcuZEbZ3aojCodf9SL+jBYbn3n58lhoZRbKwUARop89hnC1TN3l9O8pBjWOdfQIXQ9bX5XXGRz/DgNe4fBWYxvYyJvfU2Kz1oTC2odqrbKMCd8lqn7iZm1NXSWLq0GgXEouJK5UkA/rwp098bHNvXkbpX75Bm6ax6U6bAQn3e3sqOk22pGYoW1smAH0Pa3YWZibFBFt64JrGpCIaPzxFQglXDqlh6weqN6jDvAOgollvpQ86URYXSZ2sIyMetkVdu22QLn+phiUT/1SPvRj1G25rXoHSHUDtNq9m1oPWzmD5jd91WaHoQ5/8jtryMUYHlMlewvrUfk7ue5OxiRjFjflTZer+W4hBRsgMrDHkVyC/qQpVdpofV7CD1y2A56XFB0h57+pTtIZP7SZ6OYvySwAnjnGwVFkNBuBt0BsUu8ZAI1cjES0O7GqrViQ/UeN1SY5D+KusMqOe0NWJ7oOoL+KPdXtpxZZ9ueaZSjpIz9GDliVFgWT8+3kNzwU8fYp71RqH+e7TjtDJOv4e/wqTaGToO3UWzDq78588BIgl5zuiuyAjXHef4tbmmYc/pYqu+UJZ94ahhmsQ9kX+3da9eKk
 RPTU6lUF
 VjbTF9cMYDW+6dg/rkHRob+Y4XUVirryr5eOrY39CvkwmXrbika6ugRKVJanueWfxOgFGtwFB+POOYWbtt8VoZ+RfmLLHd4axdlcMHnIZuTTF5DzvOsyCvboBqS2/FS6NN/yPBgM4NjM/JryfFKJERSbQP68ii2uynVQK+S+KVAfQtODJJ59cp/Cy+KfaOCgAA/xiDD7Ow545apFrTfnsVOxnwgdDO8rEtWUhDC+ZBB7Lc8l+RP3oyWdcirzl7fZrFWfMV4n1MMBHtkjoJjPeo+9fuPTRiYDzr8ervwaZRh3lPNc2H7ugX5OxaK4QnZBqAI7PXMqEe0URCEsvaLR7cQ/Y0UJz5od7bOEjz8D304/gyd0Z3psXRBfT3Y461B6Io6LO89PWSYsXeIBhzHx3MEonjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, everything is bitwisely same with before, just
preparing to drop the page flag.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/filemap.c | 2 +-
 mm/swap.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 50897ca1d74e..91a1d1c03475 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2015,7 +2015,7 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 
 			/* Init accessed so avoid atomic mark_page_accessed later */
 			if (fgp_flags & FGP_ACCESSED)
-				__folio_set_referenced(folio);
+				__folio_init_referenced(folio);
 			if (fgp_flags & FGP_DONTCACHE)
 				__folio_set_dropbehind(folio);
 
diff --git a/mm/swap.c b/mm/swap.c
index 5fc8a9ffbedb..6e0397ff881d 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -514,7 +514,7 @@ static bool lru_gen_clear_refs(struct folio *folio)
  * * active,unreferenced	->	active,referenced
  *
  * When a newly allocated folio is not yet visible, so safe for non-atomic ops,
- * __folio_set_referenced() may be substituted for folio_mark_accessed().
+ * __folio_init_referenced() may be substituted for folio_mark_accessed().
  */
 void folio_mark_accessed(struct folio *folio)
 {

-- 
2.54.0



