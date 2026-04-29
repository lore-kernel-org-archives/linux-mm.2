Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8EC3FF8877
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90FF76B009D; Wed, 29 Apr 2026 08:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E45F6B00A1; Wed, 29 Apr 2026 08:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736BF6B009F; Wed, 29 Apr 2026 08:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60D156B009E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:02:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 227241C00BC
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:33 +0000 (UTC)
X-FDA: 84711456186.03.1E8EA44
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4FB561A0020
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=rgg+jjda;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777464151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3AZzXDLPlt3jgnN/vFQBCCKba5l+XEMx11l+vR3eeA=;
	b=qHDZEKnUfuOJ5+VbSApB+0oPJCp5vaTbUrZCLx4UsYpUA43kw+zCyPndM4jdaBT1gUo+Vx
	Je813fZund8NzEurd1W2sriwt+8Bo1PZXXFCPAjetb1xzHewbEcKfpPYAqjNgapqHIiF2C
	UtdBvpPzEkqU4agPm61GlTqOtddoTGU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777464151; a=rsa-sha256;
	cv=none;
	b=IiMksIPBPPwe9dqa8Fx+o08Y8TkFzgf/T0f4eNj2ZiXdcPQMHGq8N8xY8Uye86O2EsnPAW
	Z1UjUj++nqN8KogMNi6IJAI8y2e/9HsdzXWB7vE/tqxLgTrrF4LYyBmwnSdZhwWJQdbLa/
	oPRZdBhCQyyrQeBt+P3kpaqhaDvZ39w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=rgg+jjda;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id A820EC7A8F;
	Wed, 29 Apr 2026 12:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777464147;
	bh=C3AZzXDLPlt3jgnN/vFQBCCKba5l+XEMx11l+vR3eeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rgg+jjdaV6pxhWNX4FZU96fp3XQoxpCe7OhKAPVbuEapxkzF1OiaC55lOelqeKGuu
	 P1C03ncMCwJuh0AHyC2JJ5SrVawASZj798BBWUgpk0IYE8MiMwVlETIz4veJv6sIMi
	 F7GUHcW9dKkw0mnQQjjn2240iVt1c1dQeStc6g7A=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v3 6/8] mm: use zone lock guard in put_page_back_buddy()
Date: Wed, 29 Apr 2026 12:02:11 +0000
Message-ID: <b0fceedca37139da36aa626ac72eb9840b641021.1777462630.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777462630.git.d@ilvokhin.com>
References: <cover.1777462630.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FB561A0020
X-Rspamd-Server: rspam04
X-Stat-Signature: 1rybk7xoiwoe3m66jw7bhfz99fbrxsce
X-HE-Tag: 1777464151-633670
X-HE-Meta: U2FsdGVkX1/yKRRC255mmzNbYwGWdgOFsDTlIt+3nuSfIeAfXe4oHVYyr24ecdeb/tIy5YkvorzSixzKSBLOG0Fvb45GnygULR55uk9+EHFPauEmbyvoEkQcWHFoXSVdeo4iUbvTC2KHxUaizkT5HepUd/lwhImXkI8CVwVvYeAXLOJ/q+0qog4Y0pJM7/osEjiSx5fW+ehXjLxetafedy+VoONT/R2bEEJeweqCnz1f4o7u4Io7IvYCRKmOiaySC6kybksL+qcodgveNm/Ri8w2ja3YC53ULtRA2E8om3MC/6c1Qe6UCRLoVm4qeCcE+sAeu+G7XogHCssVRd3l1kSI5H34Wck8ril8eTY+BGrinJs1MjslNRXiorQ0OZW08WN02woYgV2QN8ZpxzdZCebacRisJNohhqXCCivXOkW8yCxdCNcjEilgLcOt5yMDTCwgKMfKzf8BX+FrTUwh3Jy8CcCdrWiEgNM/0KBMKYdsuCaAJ0vRqgNtjIWsijFZkIo4KDE3Y9JPRNj4PXaKQ4niJ1vdNZh7DRwKTdygV0y2OsajnwXv+eSxKPWgVVcLmZ7MvruwmfBtPj+oeSzgSVPe9DV5cor0wncVka/Mi1xn0iO6QWvvXQzuskEC5gIHMgtVjUGzekn9ZGoEFdLN5U3crDaDg1xxNU9G/G//UEBQV/QC2i1EydJkQZ0Kblz50SG8tDrP0GQpbB0L8ET8UwsQsAzULSrUUxF29A4tzFNNBSWqwncaAroSkcMKSvAiiA2PchTblKCo8N4pftphwEHCgPCdXUlocdZWhwor5kJjIQo3MxA4FUKjY2mu3BSHff1x9sqfgZ27Yu+vYQOD8gNhttiSPWg3KVpp3C6fdk5fmSJ/ZoIOpNW0xbJHMaj2d+eS5NK64RAr8LSzHm7X3Th74TM1BcaDCD0T1jGVhbgmjqN+CJuptIm9mntiRhJajBJsBpyBl3AuKym9358
 eq9bczMW
 vdvLh4nMWpjxqHW8FLZsYBL/Ahg0XoWjQ+oySanR+doh2C8A3s0pQbzodNq7U62BsNqzvy+3wY4pp7PCo/VSHHMYRKXZzxHq6rq1N5ETUmCL20EqldrfcQWaU/XfTxlsOamYfwBfRI7AQC/OaFgrXvv+oxuYleLQLlrkmLdI9EIwjZaBvpurInzNvr+8DysnpbxVPWpZBdGkpDHKZuqmu1QfWKPhUDv+8JQviHV1fT5eDA1fSIfYFPnsMXOLyhWiUyAToJfgmlaBZ/77T+3xn7FggYMV4Ky4yKR6Fl6O2Aht+b3n2w59atJUA4zN+xIszcGUbq2Rkmb7V09UxrgczKZQ2pLYyD4Bi1wHqQdzum0Hq/60AQn52J3pOSWbCxkuZ/mHZ632L815ZVfgn2SBzAQSZUPn5qLPxh69V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in put_page_back_buddy() to replace
the explicit lock/unlock pattern with automatic scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/page_alloc.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 013c97a3db12..87758fb6a926 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7502,23 +7502,19 @@ bool take_page_off_buddy(struct page *page)
 bool put_page_back_buddy(struct page *page)
 {
 	struct zone *zone = page_zone(page);
-	unsigned long flags;
-	bool ret = false;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	if (put_page_testzero(page)) {
 		unsigned long pfn = page_to_pfn(page);
 		int migratetype = get_pfnblock_migratetype(page, pfn);
 
 		ClearPageHWPoisonTakenOff(page);
 		__free_one_page(page, pfn, zone, 0, migratetype, FPI_NONE);
-		if (TestClearPageHWPoison(page)) {
-			ret = true;
-		}
+		if (TestClearPageHWPoison(page))
+			return true;
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
 
-	return ret;
+	return false;
 }
 #endif
 
-- 
2.52.0


