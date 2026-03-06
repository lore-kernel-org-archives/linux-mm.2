Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0F44FCB61D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84F836B0092; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829BA6B009E; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729E66B0092; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2C26B0098
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A324C243E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:28 +0000 (UTC)
X-FDA: 84516115656.08.3A438B7
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf22.hostedemail.com (Postfix) with ESMTP id 58067C0017
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=BpySMpVw;
	spf=pass (imf22.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5MNMr1IHoVTzBoiG5P1ta/i/aMAz7SlmBpjrvkTxTqU=;
	b=dor2YaoKJpGFcVGSz4yyokQVdiOyjBJpqaXV6HPwVtTpZS8qk5shgw0apWK10BnIm8HZRy
	2gA8MiBe0oOcClDrST9jKYerXncc5T8az8r6NH5V6w4rl3iwdYcN/x0rHZe3GOPgZ4FtBS
	txPSc8WRDuj7/LpY9mFYAA4DsrMltU8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=BpySMpVw;
	spf=pass (imf22.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813186; a=rsa-sha256;
	cv=none;
	b=A5hn6YMlKHmKI26MgchELF5mUVSBl+BcjezxhxO9mJdweYytW2TFfWQvtlVaTE/s2cBwDT
	Bhe9rRbMuGibPbuZlPQsmnv/Gt7afxyfiPWPHz2cFpo1J17MP4o+Jr5AY7UsUKneFjEq4X
	lEb7aGHHpn5w5r5cHPQz0RJ/nUBfsJ8=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id B32F9B343E;
	Fri, 06 Mar 2026 16:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772813184;
	bh=5MNMr1IHoVTzBoiG5P1ta/i/aMAz7SlmBpjrvkTxTqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BpySMpVwFeY9+TCd+MZC+3/XwNvGqnwn/V5SiPGg2iQQblqmuGnAxUuZexkBhPlEr
	 uLZEY8pqaLVhfws1wtEkeCwPaX8//6ZwcG+jtHxUBtTwE6MTnvcC5YVRrfxhUC+/1D
	 dsKMpl7qUm/I5MJOwJ6KIMNtFSs8x+KgpdBLO5kg=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
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
Subject: [PATCH 2/8] mm: use zone lock guard in unset_migratetype_isolate()
Date: Fri,  6 Mar 2026 16:05:36 +0000
Message-ID: <b939ec1ac6191ab30f3a746cae397aa9826ff3a4.1772811429.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772811429.git.d@ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 58067C0017
X-Rspamd-Server: rspam07
X-Stat-Signature: gpqm1afhkpx67exsax5r4xkyzq7698n9
X-Rspam-User: 
X-HE-Tag: 1772813186-665035
X-HE-Meta: U2FsdGVkX1+bIMubaAIAYatYsoVFl+W0H10Fh1RcG4ciXhXSTA8U+OyyhIvtycqQjtE0xsTylVMGD4hWGeZfYVFdBnLLStSbpFAeOZJNy1en5ULg0KlDZSaVY6NA0gcVbfIhiiHCpubRvyWUOEel3bfuhTBjzv60WK191aW31HQiqHcp47Bgev54Dr8c/9kV/tSUWLBqWb2x9HZtb9Ah/h/hB/pYXLaLbizhoOrpxR6iABKyj13v2/yh929Nu4PyMyLqingBj/isR3ZvuM5iFZiPw/98K0FWn8fUF75+0Scq4mj+l4Bo4l0TfO3Ov6OTDFZnmxyzzYncBZnTYyre6vKG+JbZq121Z35Ec1jmoiRUrHqYBtqNi1Dqc1INYWZNULA5skXZ2E6rdzqcwzs2pydrmQsWxw1KHpVmIIDcnEHYZaiANurXk6/Uef3TDgcbX5Nn3gc7rWct9bVYnCnnWtPhNSYCBjSA/JGIFBctbiF5B6FZXlSZY8EVKf0KXBCNTnAyJjHXmiE8JFCLd/kp828TTx6f7PcNOacELQI6c+zh6nSgs4UVM0R8XUV8HOi60mlqhlY9sUhICH1bkwbnWqRJHLHFjwD8pvXAWsdOXuhuq6zkmxXm2ExenY621793QBNHTtQ56Zc21p/WjjcRS6cJN4mIFA+92AW1yig0Ttmkq5Lo+dOVWvKqn6LHidNvoj+rBpR+IV9NPjTTruiXFIyErHQDUFZrUEtuDpqHXTU98ZdjevoenQ0iwLRLVL1q/xMEVdTDI1uddf/dNkfMRQ3lXrfTcd0HYgn/28F/CMZIPOCEBskLRgqA3+C5ToXjDGKhb6L67mW2nglFC2ZgdLTzm9DWJpGFi52cdnnKu7S5ifde5f1C1/JCem9KtbKcGZ7JB7a46z3wF+7QrkK3ABXvOYhUaT++MSyEZUZ8RnXeuGXUOIqeVTWqGHa0FnGKbikPpQFXygD2EaUg1gy
 ZIsG3Kvv
 VYlt2im17Qasz0EwszAeKuCRCA0ypUr2K0L8uUQ2Nl0xBDRgat51aTrp90GYlnVXnr0AO3k12/lH8SFd664G6Mmg6rHacvx0wMZV/QnnXSMklwA2wYkRbTk1FOk2/ds2IQBdfAelqJHBo985IvX3HHlgdu9WnmuNy7PtWcWWds+sTBeccTkFA8H8ExFKSS6g+AByBSZwyjb7lWDWBqcQwMP/F5NTzv4/1iwxcmzSDZrA8MIXOys/S4PzdKR6R8oaUpIIdFS6cJy1qfgmWw7UWx74sHP5pABfn02H3r6+Fq8HVLE57RgAnHDckwvdU98fzTvZ066+dpscX916RMZ0wC5ORN7ZknMulvXP9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use zone_lock_irqsave lock guard in unset_migratetype_isolate() to
replace the explicit lock/unlock and goto pattern with automatic
scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_isolation.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index e8414e9a718a..dc1e18124228 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -224,15 +224,14 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 static void unset_migratetype_isolate(struct page *page)
 {
 	struct zone *zone;
-	unsigned long flags;
 	bool isolated_page = false;
 	unsigned int order;
 	struct page *buddy;
 
 	zone = page_zone(page);
-	zone_lock_irqsave(zone, flags);
+	guard(zone_lock_irqsave)(zone);
 	if (!is_migrate_isolate_page(page))
-		goto out;
+		return;
 
 	/*
 	 * Because freepage with more than pageblock_order on isolated
@@ -280,8 +279,6 @@ static void unset_migratetype_isolate(struct page *page)
 		__putback_isolated_page(page, order, get_pageblock_migratetype(page));
 	}
 	zone->nr_isolate_pageblock--;
-out:
-	zone_unlock_irqrestore(zone, flags);
 }
 
 static inline struct page *
-- 
2.47.3


