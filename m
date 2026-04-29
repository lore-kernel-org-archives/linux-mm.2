Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14ED1FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 765CA6B0093; Wed, 29 Apr 2026 08:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1CA6B0095; Wed, 29 Apr 2026 08:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561006B0096; Wed, 29 Apr 2026 08:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46E406B0093
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:02:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7918E1A01C4
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:30 +0000 (UTC)
X-FDA: 84711456060.23.43EF122
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf05.hostedemail.com (Postfix) with ESMTP id A63AA10000A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=OxcwZUNT;
	spf=pass (imf05.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777464148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Twsn80r9MVJjFSVO/LrkxIQo9g3SRn97RPzcuSp3ljU=;
	b=m112AWhqIaZa/n+2+qR0/8KYxolefNu2roBXOHESQwKlsmbv/JP6+OkLE/xgexp5jqHJUz
	jMZRn+WC3RejHiCDOp1TQFvgrLMgKiaf1EvyAPbv4awCnKm5x4b6B2ZNuN15uTSWamFYkD
	ozCBY2iX9ErjYR7IjKGjCepjaVW0qUM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=OxcwZUNT;
	spf=pass (imf05.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777464148; a=rsa-sha256;
	cv=none;
	b=wdTNE9aUg9gRGYdDxyhfFaJtm5jGPaqbsH7qO2F+Uawg0p55fzBEVo8w60mihULWECrmxz
	dcTXlZpImvMpGXsNtn66J37sct71BzU5MIAyetFPtk1D/eK49lxiv3aJzWclKLno25m8HJ
	d94WJIhotDd4OXsVhfVZjwJ9WPF+ehs=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id B70E0C7A80;
	Wed, 29 Apr 2026 12:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777464146;
	bh=Twsn80r9MVJjFSVO/LrkxIQo9g3SRn97RPzcuSp3ljU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OxcwZUNThGf9of/51uzvrJuCoHDFTXqLQGk1tOuVjzRSwSJADfPZS6QzSKivX0AlF
	 BcSozBnEnpNhad9j21v2zZNvdA9wIA6/cFMo6byu51s7zIYB1CKx2CvS11r3rGZw57
	 S6r4ajuoxfTHgPYypleG1+Rj9A3aVZqO87MahRhQ=
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
Subject: [PATCH v3 2/8] mm: use zone lock guard in unset_migratetype_isolate()
Date: Wed, 29 Apr 2026 12:02:07 +0000
Message-ID: <815c0905ea77828ed32bf56ff0a6d3c6548eb3a2.1777462630.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777462630.git.d@ilvokhin.com>
References: <cover.1777462630.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A63AA10000A
X-Stat-Signature: hwytxeomb1z6s1xbqt38u44ryx6fy4bh
X-HE-Tag: 1777464148-502153
X-HE-Meta: U2FsdGVkX19KYKTACIUhlmcUGICzvEBNFr/NtecYi3CTBJGUke6+Vi88MoXZ7xJzsJwmDksBYxmde3IAuUSQLAWXiOX4SEtaBi+i6tAOS2Zaj78qJmCzSR72CIJIaWLkYvrFdlyN1EPhscWEEOzy4Lu/eajBHAyDs6037RkVL+RKofhMwdwzcKnCJYNlRR+PFCIuQaxD42kZurUWVHufOShDokXYcMJL0XxNhqqYbq90WM0oNmctv4YXki9BEDPrVARPZqV3hTZGoIDGstdVJ7OXq5G6eiSkZTS9Hsn4oYjLPdgJZCyx4x8LlEparKqMnrS8AngH2HJMidQLvKra553+WUDH52D/VsEcp3zaTgwFYc5K3Z58nlG0ciHKz8ph8k68XY4rckj2Ev7ey76q0MpUvMyyxX3+S4NaI12f++8R/2rMvvkBgKriuara6BYZc1Gw8NytbIQ/sHF/e/J4UiTH9QC9O+A6Umbme/Mq/coUr/oyoxLkWxtxOlqNUEQ4cZhsBV6GJPQ8Zya6+aILIGB4IKQqUXqtqdTpIi4tzoGKAjn9TLSZqCFe5l+VxMKE/JlrdrSal5tpOJMtEkEoLqkrbjQPbKQaS18wi2PTOUjrRaDQmynB2CVKfqD5DYvbsgbdRlXS/+Ow3KwnX44I9fDdL45btcLqJVaNFViyzVJ9+9cFsaIozpYnZNx/R5eUnKS/NKWkObowVHbZRYZOOyUwYuaZxHZE5+ZAV2kGlhS8TwdOXu/8Q7+R4WjXxxO2Y4NuHMBsyq4yY7AoGBZ0jX3FlqnxR0QHs4coQDjeyfsSHmANfqpPJr5flI+3pzXhNrix/6n6M2+IQc+TyIOhEZRjxdkJE/1UJPmomNMDf8XtfyV+avEaXUVEL6QpvXYBh2mHcqjY5+yBo5qkd53mXCRZb3lVt0Bni3DYzlbTWgxWPgJWx+jQ2cLNowNWj6jm0sJdnSTI/iLOLeJ+Xf8
 I/BbzWab
 keJvpe4EHra1eHYX3Y5z4mI3Iq/UzrdP87ZW8rseonV/tAhQ//2hd87TdN/WXJcdPSmNABeaw/81QxEZtP9eCHHLXTM0VomIaYyxFU+7rAH0aHpXZlWwepkn4T3SsdhFRJ6Ep0h42NOwazvs0F1TiiwPoq1HzTp8KoXWonjsVJbNv5R5N0x+1uHu9YlDdH6KclbgdmUC3fomUJwp3i+5fHchf3KpE/TgwbfTy/3xxPnpf/NJ6iFvKgJq3IKQf32if1R4IOqanqJeJGpBP0yuvTlOMCiDMQg0UJfguQehfDs4X2MaoFCg0buME3fKDUrrlEgL2syRmbzBhuoKbo/jyeEaWmQf7TKnnYCnGt3uWMDbDqIo9uYdMmMKhMNWbZIEu3j8FbIgomqkcfXBXmek7R3AghQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in unset_migratetype_isolate() to
replace the explicit lock/unlock and goto pattern with automatic
scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/page_isolation.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index c48ff5c00244..9d606052dd80 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -223,15 +223,14 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 static void unset_migratetype_isolate(struct page *page)
 {
 	struct zone *zone;
-	unsigned long flags;
 	bool isolated_page = false;
 	unsigned int order;
 	struct page *buddy;
 
 	zone = page_zone(page);
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	if (!is_migrate_isolate_page(page))
-		goto out;
+		return;
 
 	/*
 	 * Because freepage with more than pageblock_order on isolated
@@ -279,8 +278,6 @@ static void unset_migratetype_isolate(struct page *page)
 		__putback_isolated_page(page, order, get_pageblock_migratetype(page));
 	}
 	zone->nr_isolate_pageblock--;
-out:
-	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 static inline struct page *
-- 
2.52.0


