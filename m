Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B562EC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AA6B6B0107; Wed, 12 Aug 2026 08:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432C36B010A; Wed, 12 Aug 2026 08:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F776B010C; Wed, 12 Aug 2026 08:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F14396B0107
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 853FF140357
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:30 +0000 (UTC)
X-FDA: 85092520380.22.32E5612
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E74CD160008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hlfLM8xQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//ieBRIhh4nll3qPbLkaxIxKpZguGkr7hzBbi75fbu4=;
	b=KJpDWu8q4ENZeDzy5rPMp/vIv84KxanvB0/OtW4f61/Pj+rFbgO6PeXLMBXAlo3yOMHNJY
	MGqwwM1O8GWsNdpyZVBVlr4nkjRmbrc6d3UfgGl9+NnyrxtY3CaQLok7KYTMac6CwfA6rZ
	/CT/+De0Tb2ZVm4wq8Luros5HjzHpts=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hlfLM8xQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537109;
	b=6cu6EJwyijNDgD+rJpaQhKPDTBNselF9alkJiwZJ+UoUBfBiVHjn9tHTTkueitxQ2sccnh
	JjmPtk20HN7s0K4XdYKyiZj2F29xD51ygz+kdAKSzO2pte8jSAZad2X0vFRf8uWmdwr0yd
	rs+Vjxv1XEHbn/poFcTReWeqP5yA+2Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B70F40112;
	Wed, 12 Aug 2026 12:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1E41F000E9;
	Wed, 12 Aug 2026 12:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537108;
	bh=//ieBRIhh4nll3qPbLkaxIxKpZguGkr7hzBbi75fbu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hlfLM8xQi8KQaXw+J7ZyMU+xzBNGMgaQJ38nanoZDFLF92B7RFmSJxOSjC6btYMfB
	 jNcHmL0DSGsLmeaLjaNVO7gk9eIy7/f2tvDXVxVJ/H/4sdMLRpaip0ODjNNxmnR1gi
	 p6KKiBiOnd1Jmvq0r/4MEIKAcNNvRQ30kd6uaalEdXvoArBlDGcWhQRHbszHeHRDui
	 PBwcUJc2MXMKyi4PURpglOsBz5RTBqtC+n3MctaQz5nXJxclzkk9631VKhIsK9vb/c
	 RcN8AYZqgMq3arGkjouIxZQ5CGb1rC46IlLuAUjVMR8qyF+BpOUW3DLDDj/R4p2g0F
	 SHz7g8ARwdt5Q==
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
Subject: [RFC PATCH v4 06/16] mm/mglru: batch update lrugen->protected in inc_min_seq()
Date: Wed, 12 Aug 2026 20:16:48 +0800
Message-Id: <20260812121658.69965-7-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w7h4iioxgtb41rhm4ihi6rh7cjffnmbu
X-Rspamd-Queue-Id: E74CD160008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786537108-674413
X-HE-Meta: U2FsdGVkX1+ikTv4NwsafzW8+wnnZP+vaf/d7lSgYW7jIsFAhVii4J0a5DBGW6gI6Puwp9+snCOgZW6qHwPwZRaWdjCUGjEZ0DOHTG890ujYvfQRdiWf+d7TlTo5Y+aoGuTbf5C5MNTJWkbSwssToPeqqd0XNsvvdPynIWgzJ8bNola1OYiC6sWit9c/tivhjOCsUAUs8K15/jwnx/gdBXUm1HQX+1tRffl42UDMAWriJf8vOBa1ti3CArhh1/B298kn4k7okRBKMYLtMxh7TXPFvpwk9HK01VRb8Unq9OJbA7PAnI3d3iCPEvDoPONzhIokkv7uy3niTmIPmdtRrjKhnS2ctUCex3wCBjmVsmgC+BdFrMrxhAchlIWwbYe2f7ZZKQSA4SkDb5c0lsGnjJ1Z3mG4eLTTRW5P5w2bGbovpMCDvSMcUdvi6oNtm1ax1OplQijIWWgl/UVEMYM9LjNhTLBlTbIAQeJ+uHbtbmuGzo0DQl2NsIFGWWtKpEVE0TNy9c25APPj+WZXflLx2bBAMFOHYUw8emnE9flfRCaBYKnw+SjeatICQqDga5e+j2OwB4XiQjNh+K6OLmAI0GeHfRb4veK7XvzPwOBKnpN5GaqdPc+cU2jS04GVROJsAkLbfzug+OR1VzGMfv/AhrZobqg8kLo/JvjfKhqkjzOM/ZlFb8agmXDKPvh7rT6qwKsc8q39zshvhXmnsN4u3Jf8/SZo6k2hacnPfM060h+duZs+IGEqgv9sbDtXo7JmFmO+VrbNvft29VZaOpr2qw6JafcnS/0NU/C6Us5w6PACwjVv0moTvQmrDCiCr4nB/aJAOpodZBozQGR3UHzQozOlDDhlkfkSQXJH9IiDaROgQ7feScdu1LI1n5BhiG7zBVh6h9mggklmmltbuFwfboqzFppjnj5zfVGtIZ2xqSmmyxzSVZtZcr9UgxIqlONpEo0bIexyjI16e13XmgK
 GccIpgSd
 SPZG/vLJ9P7XFlvRPWZdc7JJyqBSRdpUoE09qQnF0Vrxwec4Txlc23Xw7UaM1JQ2n8x+FdHqbR1WvB8ZdNPph4enD8jA45isqH8x5srowYUk7jcTWNxCNpkHWSA35yHlBCeQv/Erv1WBKhlcpsVpvCBLLBvjYEvTDXIXhHukWCa6+WCURfMyBPD77CdzImlc/ie2QZeLsbH1XZQQm50am1y0g25XWU/UpFkofRTFNmwWiFyenII454sNOenv7JJV1Yefg1GFzIR110ZqfzF7Z7exKuqPmp3m/rtyXELWhMD8PC4+a7VzNBP6vIiNa1BzR+3LTTUzd2Z8fnxUXSTO1I/dypr7uVxQH8HUIVOXIcaA4aLFNET0zLSUZ+b1CqSW+ra8Xnd5ldtTZEyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Avoid updating lrugen->protected with WRITE_ONCE() for each folio,
which may prevent potential compiler optimizations. Accumulate the
updates locally and apply them in a batch instead.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c6e3b92c8cae..10f690389f5d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3930,7 +3930,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
-		unsigned long delta = 0;
+		unsigned long protected[MAX_NR_TIERS] = {}, delta = 0;
 
 		while (!list_empty(head)) {
 			struct folio *folio = lru_to_folio(head);
@@ -3952,8 +3952,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
 				int tier = lru_tier_from_refs(refs, workingset);
 
-				WRITE_ONCE(lrugen->protected[hist][type][tier],
-					   lrugen->protected[hist][type][tier] + nr_pages);
+				protected[tier] += nr_pages;
 			}
 
 			if (!--remaining)
@@ -3963,6 +3962,9 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			   lrugen->nr_pages[old_gen][type][zone] - delta);
 		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
 			   lrugen->nr_pages[target_gen][type][zone] + delta);
+		for (int tier = 0; tier < MAX_NR_TIERS; tier++)
+			WRITE_ONCE(lrugen->protected[hist][type][tier],
+				   lrugen->protected[hist][type][tier] + protected[tier]);
 		if (!remaining)
 			return false;
 	}
-- 
2.34.1


