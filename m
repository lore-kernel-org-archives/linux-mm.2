Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 634EFC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CCAC6B00BA; Mon,  3 Aug 2026 23:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67DA16B00BC; Mon,  3 Aug 2026 23:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56BB06B00BD; Mon,  3 Aug 2026 23:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33DA56B00BA
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:58:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7738C08A0
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:58:54 +0000 (UTC)
X-FDA: 85062230988.15.D7C2072
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6FDA420006
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:58:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=TqRboD7T;
	spf=pass (imf03.hostedemail.com: domain of dayou5941@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=dayou5941@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JvaRAQmBPU7Ni3GnnolVzKElnN3Ho+ns0cBS2DbZAc0=;
	b=cvKPYrZgPZOF3oK5zi3NdnD/iwiWdC5KIk4wwzXDqPkIrHenj5XU2LumafhKGAp5kFxbAr
	nJV7fmce8N6HZjR6xOVC4zbp0vPJqagganDzGMKIEuebg9pWER1NY92CJy9+xu5gG1SeX6
	XnMvWBFdFNO3GmYQkZWKlLmn4hJP3Ok=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815933;
	b=qXTamY/usDyD5tzdYfffVCeT2ktdBdIjGj9Wh9Hk7GvqONXw4Ez8stcXeYdA6Mncqot5B2
	8Rjr3OPC9cTghIf41Hv1DO189sA458lEypvhWkPTexatDv9qqqjq12EWZyNUylnGKAgKoz
	/6xJottr81z4mlBbofJVrZFUby/su/8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=TqRboD7T;
	spf=pass (imf03.hostedemail.com: domain of dayou5941@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=dayou5941@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Jv
	aRAQmBPU7Ni3GnnolVzKElnN3Ho+ns0cBS2DbZAc0=; b=TqRboD7TckaublcJke
	pd/PoMSicJyGr5iZQ5KeIiJDPNLFyRcEpHkG09qTjwgXpcuw6aKP96i0rcWYnS/b
	ksueAEtAd3slDCyHrxTpANuswZBCW8RUm1FOf8W9qS1akAzzfku5yZ4lKFSsUmnj
	ImVc7RWFjkjBFjY2ABM8/7EtQ=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDHDfZrY3FqWF_PNA--.48287S2;
	Tue, 04 Aug 2026 11:58:35 +0800 (CST)
From: dayou5941@163.com
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: ziy@nvidia.com,
	linux-mm@kvack.org,
	liyouhong <liyouhong@kylinos.cn>
Subject: [PATCH] mm/huge_memory: avoid TOCTOU race in min_order_for_split()
Date: Tue,  4 Aug 2026 11:58:28 +0800
Message-Id: <20260804035828.2684059-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHDfZrY3FqWF_PNA--.48287S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww48tryUtFWfXF4rZw4rAFb_yoW8AF1UpF
	WUKwn3WrZ5WrnF9r4xJayUJr1Yq3ySga45AFZrCws3CFnxJ3WjkrWxCa13Aay5Jr48JF4x
	XF1jvFs093WqkFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UG-ewUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC+QvpmGpxY2utRQAA34
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-Stat-Signature: wd6c11cpy4druhp4z41ijq1umpf45g83
X-Rspamd-Queue-Id: 6FDA420006
X-HE-Tag: 1785815928-765656
X-HE-Meta: U2FsdGVkX18iIa71e5aMgbJE5VcZusLqNpxJN7nHJo3dDOP53gYnmBeAEysoyAY/UitLSW/T/wv2XqLrHILFpoNPgfdsAJR2XL9IX4JhT0VaMwF15+t8QimAF/3fPN8E2WWwLvG0RjMK2cUdNr9y2xxCc5f3ElnPOHs2FWQa3boDC1APounxb3DaxrnRnjVWwxq81zi63lNQPXyYOH7ML4LXy4x4peYekWu3hjWcx3bU1C7sOwMHcOA99gtkbkbsOQG/wdMxUkJyMx0ue4O6MXjYHcS/t7RThNS5HtSfo5aH84vOjTJwEVGGLeAsHct6GpicsXD4q7obWNhUUbOlnjYiqMMQeUZmAGCRY3LFyEsZ6da2PrJ8g7GELgjsEGw3c7hs2eQOskhYkJYg22QJ70dX4Fd85stc8JoYZydGuCiDrLxAN0eXHRZPFoYYt5efo8S/rkRFvzFbYtdrWC8yFoLXwOPTw3Flv839ETC6Zw+E2WW5O66a10TiEYd6Wi1CIzIedJdq7kLJJgqB4GcpJP72fN7A4ICmmYTHlgHBLyxBGcsCZw1IlIUcJBxmVF6FDYQpsv5oKx5mBToMgusJ5IUG03oiZHDA3lfqSkSifCsIO67DntQ8vjIzun9175AT3OsNclxxhDpXXLhhuJKW44rqJReiG3pXCF+jiNGgY1ZZhQZ9WagSdI3iEpheKAJkp4WjAN3jaKuQQCL/w2xO7uK/UgWzDUHz4kNF8cF6RtpMTakJPYP1IycDpxIxsyfZsjNRmp/5MTDZKiusKRuPl6uSptZZoEbUcCkfsLtCzHnOsMcSnFz25h9seogSykdlNZSBzwYUb+oyeC+elSu6pCzF7XPowhXzG2b0TUxk4BjlPMRAB0bxfX4/JbaiuNWzWMQEx7B5+/YghZRQtpVdsFoRMTN/zTR3DKAmX08ToOKRue0dESYoJ4wMI9Ymzu1mRnSol7SQMAwnpFgDCV+
 Ye/+Xyk5
 g7yOdxYi4jdYA9HV1eDg0tsohwG6ZUVHBEDtmZjoVhGl6xTeIyn5ZiLz97XV5mcJTua4f15N8vYYflKYf1pS+1GOxf3Xch73EtPCexdqJ5RA/YzRQmofU/kOtgFZf7hx0Pq3Os6qHuJQPP+BPZ834VArkSNZL2TwRThUc7zRb+ykA2pAfWWlukSvq6NsTFwQAdH+JIvLRWtcaiUou47ViHSlApx5MBERuwi6xaQuEviS4KsCeQDWRzJn61VPHFaY6Ql73o1e/0TKJeSzXXMbCA/ouNMOnsAdsNi2W5i3f+eoa4MjY9TIoIB5ERVOhCQ83eO8tdNcG2lYwhR5aueFwDRnRzZj/Og6S/zup28eX+ECNfmtX7Bnrcyb/60YlX2mDmDVVpM+AqhjwlKu0l1Y4fXtQa2PJ0XlCOpVKHXG6vKuQx1asNfeOOLYglx1amc+KtYSJcPN2JM3WVR3wO/FjGe+jLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: liyouhong <liyouhong@kylinos.cn>

min_order_for_split() reads folio->mapping twice without any
synchronization. Concurrent truncate or invalidate can clear
folio->mapping between the check and subsequent function call.
Even with a held folio reference preventing the folio from
being freed, folio->mapping can still be overwritten to NULL. This
TOCTOU race allows passing a NULL mapping into mapping_min_folio_order(),
which leads to a NULL pointer dereference.

Cache folio->mapping to a local variable using READ_ONCE() to guarantee a
single memory load and remove the race window.

Link: https://sashiko.dev/#/patchset/20260803060001.800638-1-dayou5941@163.com
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
---
 mm/huge_memory.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..54d4261a2a15 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4284,19 +4284,23 @@ int folio_split(struct folio *folio, unsigned int new_order,
  */
 unsigned int min_order_for_split(struct folio *folio)
 {
+	struct address_space *mapping;
+
 	if (folio_test_anon(folio))
 		return 0;
 
+	mapping = READ_ONCE(folio->mapping);
+
 	/*
 	 * If the folio got truncated, we don't know the previous mapping and
 	 * consequently the old min order. But it doesn't matter, as any split
 	 * attempt will immediately fail with -EBUSY as the folio cannot get
 	 * split until freed.
 	 */
-	if (!folio->mapping)
+	if (!mapping)
 		return 0;
 
-	return mapping_min_folio_order(folio->mapping);
+	return mapping_min_folio_order(mapping);
 }
 
 int split_folio_to_list(struct folio *folio, struct list_head *list)
-- 
2.25.1


