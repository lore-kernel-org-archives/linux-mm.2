Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF7E1D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58BB6B0012; Thu, 27 Nov 2025 05:03:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBB046B0027; Thu, 27 Nov 2025 05:03:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBF9B6B0023; Thu, 27 Nov 2025 05:03:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4896B0012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:03:11 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CA7C140998
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:03:11 +0000 (UTC)
X-FDA: 84155948982.11.4753593
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0EAAF40018
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:03:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764237789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HjREI+580Mkao7Pg3EwGdu2wbAWABqLKolHMto4FY2U=;
	b=cvoxyFQqJbPPvmXktqARBvK3P0mjqkXQn7t6YsdYswjJSLtcMhtUUZuANQIzG16AtXHMI1
	mKux4B5QXZWPhAOD21dZp0iR4n/HTnJIVkjkW7e7hYMIMkIgZ6DDkdKBp+jvOTKZnASmCk
	hNZWV7/op/WiRYJobmb+I6kmZadxfA0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764237789; a=rsa-sha256;
	cv=none;
	b=e45TYF/TbwLPGVJ8DX2viIsZrE0xrRZxjuqdBFfC4a7wV5V5JS7fI7cw4AsIGljq+TB2q3
	QI0w7YXE0MLHIsXtlgm1hwkBESRtf9tRsaSnuJCx3P2Ml7drtQ0w+gSWyJpo0QSwbui6QN
	BI1eLoZRBa8MdSXC1ieHOnBhiXXmm2E=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 27 Nov 2025 19:03:05 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	youngjun.park@lge.com
Subject: [PATCH v2 2/2] mm/swapfile: use plist_for_each_entry in __folio_throttle_swaprate
Date: Thu, 27 Nov 2025 19:03:03 +0900
Message-Id: <20251127100303.783198-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251127100303.783198-1-youngjun.park@lge.com>
References: <20251127100303.783198-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0EAAF40018
X-Rspamd-Server: rspam02
X-Stat-Signature: yczpngb5cbezg15ehzdjhdn1qmtyoomy
X-Rspam-User: 
X-HE-Tag: 1764237787-199106
X-HE-Meta: U2FsdGVkX1+titVxEe0di8rsQ+ETpGAIsWiOouM078uSbb3FSHPKmj59EKmKBBp//YB3k7/e9lPt8BtHNZYA3mQI67nuB0M9W4AswqUQ9Os3E92eXMqQs2KXaJ2XODiPtKw6dL9T7qjM+KfMa6QqLP7TKYoRKVj7B4u7934+5ZVvucW2yEa97RVf/+Np4/NePR7VO3NduLpRGbkidpYREpfYWKaF3cRBKDpK6pnr78Ni0H+zWtu410sF66ZD8W7aO9UYY3joJi9jNL6s4hUTatsomWQ8bBj6DZeMyIvXjm2UJ88QQ6jf1y7Lp0UBNcqlCGp1ggLSOcRNmhzHZVhSOmuzff7AebxJKnyQfuA7Z0P4sqr4D4NL9b+Y3b0r8AekpsK3LwUh5G/1yxQt6iDq1Qj9w7MyJWTZSM9OePakBWDao+CWgGpqWf0wk3y/s0NM+kaFBaxL0GHOPZwt1p1v1oWHTnOAeYSWl5m4ao1ZpQ1EtcuNISwM4mLbLx97t8wsWu9HCKn8WSLcs1EDn7CrXOuWmWs8k4VKtxaJCtkOa8FBo3Lh5PD3r216j/ZZKJZ0eWI2jY2QkrtlP8omi6RxuRRv1d2HicuUF4NWeqjTpAR/L7Zstfd7LYgbcGl+UVYUAq5UMsB/Ft0kCsN1QlXUO/viAcECgVxTe2CpsIL8TlSbs3Lb8Lc+ofKiIca454z7NLMOstrmiHBas3MiPgJnoaGHDgLldNZpDvn1gr6ABAyi1ZLrplZzhh8rlClHZdbYTstoYpv75dvqlf1syeVSxlBDgnRHr3S99+lLQEDOdie9YESxwsnX+xiudCCMozyjbRNbv6OlQuPQdFRS6ohiLfcQUvNgB4zLwjpUIxCeN8MPEgr7HF1YPkoEUv8lKiGI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The loop breaks immediately after finding the first swap device and
never modifies the list. Replace plist_for_each_entry_safe() with
plist_for_each_entry() and remove the unused next variable.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8116f36e440b..46d2008e4b99 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -4023,7 +4023,7 @@ static bool __has_usable_swap(void)
 
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 {
-	struct swap_info_struct *si, *next;
+	struct swap_info_struct *si;
 
 	if (!(gfp & __GFP_IO))
 		return;
@@ -4042,8 +4042,7 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 		return;
 
 	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_head,
-				  avail_list) {
+	plist_for_each_entry(si, &swap_avail_head, avail_list) {
 		if (si->bdev) {
 			blkcg_schedule_throttle(si->bdev->bd_disk, true);
 			break;
-- 
2.34.1


