Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73986EFD215
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 09:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8667B6B00CD; Wed, 25 Feb 2026 04:28:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814A76B00D1; Wed, 25 Feb 2026 04:28:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713616B00D3; Wed, 25 Feb 2026 04:28:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5AB3E6B00CD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 04:28:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3DA213AEA0
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:28:00 +0000 (UTC)
X-FDA: 84482452320.14.2F3A802
Received: from sg-1-105.ptr.blmpb.com (sg-1-105.ptr.blmpb.com [118.26.132.105])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0BF734000F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:27:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GqT2PZBp;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.105 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772011679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EyFMWTwGWSbAiRL/vJa/jH/xyi3CrIaWxwsCjWHQ2Dc=;
	b=7YhniVBDcFC22WC1jcExOF3XD9w/JeAzKeW6n+3pdQQ3cMiivHfi4wMpEtRoxqWr1IVtq3
	c37nj0S4vujpHweyAZK83Ih2QFlUDV+54LtHbjhvYVp6pZ5C3Va4E+cc5gu5eruWPMm9qH
	UN1Yd7TYlMXkHhOBlwpsOZtGRVl3ItQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GqT2PZBp;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.105 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772011679; a=rsa-sha256;
	cv=none;
	b=JnjTeuQP6S+iLhgdRtI4iIQaFc+qs7ephplfKDDXPASAyx94BYdVDKeniXx47efMLyWwNw
	tRn63zOnnVURVXop4ZSQAHhhH7z/2Yul9MK8kmorwk6cxP9bE00hoYnNb5pMYwH83+H1/1
	766La3ASH/1u5G6j05AKFyypfcke0Hg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1772011669; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=EyFMWTwGWSbAiRL/vJa/jH/xyi3CrIaWxwsCjWHQ2Dc=;
 b=GqT2PZBpBEjiC70/lEUoRApLHj4gDFwrSWL56QHtLVW8CUMWtc1SJKpFK83fElheZAWQ0l
 M6j3hlSVanQpp63ZQLq3j9yVrk24kOhmWrm6nf4QHxqAhndKK4DKA/v83G/JkY6cuIBzXI
 Lh07/qUGSWKnNw5oxzab7BX3mP6ZaiUsEFWjx7bb/Oi4yUQQIyfgQKREw3vymx3xy03923
 m0zEiCjYPAoPZSCllUqvvfWlbwFGpXkABqqsyDQhVik5PThhxdpngIuCCD6EQxBGL5iOrg
 sYxZ70N07q67cqgRhdIdv/HdiAKI+PnBC7wWNxibF2C9FWFXyQWp15SK4Cft1A==
Subject: [PATCH] mm: Avoid calling folio_page() with an out-of-bounds index
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260225092628.11687-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, 
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, 
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, 
	<mhocko@suse.com>, <ankur.a.arora@oracle.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+2699ec093+e5d514+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Feb 2026 17:26:28 +0800
Mime-Version: 1.0
X-Stat-Signature: kqga5rwqwd57j3r1zaqf1ciw8y7pqugg
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BF734000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1772011676-880216
X-HE-Meta: U2FsdGVkX18ACbH/oaTPrWGbubHv83oV/qz9c16WUa3TG9MK1rfUBAQcCoFq7lHQlqZRQPrtdsi7f9Lagp33wZ6r1isIvd2PnZapeBEdWem/hKjiRcP26IX7gk58IalWIoPgwJraP6LK4CgCGwrDNkLl8z8FEhRManKpOg1bu74cJqvkZ4eQEi1rttEt6dqY+VpCY5ytrxbrFLSIgGHITEC7T7TOxjrRFwsW92b4TrTNvg8tMcgT9ro+teOxh1745xA9EQCBIwmK/uWEcQuDxk+czE4KKxA48ZJFSgFa/Bm8hIKh4zIfKaJJCXEVJJ5r6eZYUQyO9JtzL98JvbxVarnYW+YE3b0bfYApPaoUalqWJgUNozSqZYlrtdZ5+fcMeLSCieXTTLiGDxgjunfvtJcHrLOHgAT7Qu6VAK760E3zjy8WSAOpZ9ToKRaBega5g5kGQlPwxBPP7eRYCF8aab+LdJLIMxcF+AXveXEYvyIX8krrVEH9ihSo/Fn44y9hwfASH4kw/kxIW0+6TuBEKd5lQxTO5wAo0yrrtTafpsw/9vOLDjT7obl69hJDShMEvPdmdnhwaAu0JHNHatMBa2xf5hpD7Oxp/FvyoksnPlJDihwQB/AKxdgP2kMYJRVGxGD4vxVn+OiHzWjT0cE0n6CBhBa13yAUP+wB6yX/qPOgRUbJaZeEF1dT7zAelmGVJSRChR2OI4JSZf95ms0rwxuGXs7C6lJnCUdv/lsripJ14rBhSWoc9+jMwPDGJoMONMqSDYvFHc+JfzlCjoXbwve5GxwUzw+ylou+uVMcFRs3BcX7zMWQCwH0WrzLRl+BTjpUtP+qKCJLuTODawZYqbpE7GU9lUVB/gmyTmApIWtaHBbxNWiUdIxXbB6f32dR7m53BB7VuV18Wv22EIeuK/SjikKJ8Q9COcmav/guvZmu0Cy8UhDu69UoWKfRfyvh1nLXqv2RDOzvmK5RnPy
 FyEjzwWx
 HVEdI49zd46akMfk66TSobQVqWwDxXy6UCvKeGTwVrfxwHr0WOKTcQOVWai74fJtnlSIyPnUzFR7adOB91RhS+rf14Lm+WTDOuAR/jSqHdLQASZgV7ZiylHNOCTZ0RfRgGRf9a20ArNng2PHJ1kEwdiZRJKxmCOwN7b/NS73HRG8CGA5KGiCAf0VxNpavKGh4Dk7VLdh7gaM/zsqLqghlONXvMucKikdI71qzPhDVA1Ft/fuoPbXvSO1GXAm4cz2AwKsqMSj3giCOlk8FFxXhl8uJ/o/xAndGIG362TIMqEWST6s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In folio_zero_user(), the page pointer is calculated via folio_page()
before checking if the number of pages to be cleared is greater than zero.
Furthermore, folio_page() does not verify that the page number lies
within folio.

When 'addr_hint' is near the end of a large folio, the range 'r[0]'
represents an empty interval. In this scenario, 'nr_pages' will be
calculated as 0 and 'r[0].start' can be an index that is out-of-bounds
for folio_page(). The code unconditionally calls folio_page() on a wrong
index, even though the subsequent clearing logic is correctly skipped.

While this does not cause a functional bug today, calculating a page
pointer for an out-of-bounds index is logically unsound and fragile. It
could pose a risk for future refactoring or trigger warnings from static
analysis tools.

To fix this, move the call to folio_page() inside the 'if (nr_pages > 0)'
block. This ensures that the page pointer is only calculated when it is
actually needed for a valid, non-empty range of pages, thus making the code
more robust and logically correct.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/memory.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 07778814b4a8..6f8c55d604b5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7343,12 +7343,14 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 	r[0] = DEFINE_RANGE(r[2].end + 1, pg.end);
 
 	for (i = 0; i < ARRAY_SIZE(r); i++) {
-		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
 		const long nr_pages = (long)range_len(&r[i]);
-		struct page *page = folio_page(folio, r[i].start);
 
-		if (nr_pages > 0)
+		if (nr_pages > 0) {
+			const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
+			struct page *page = folio_page(folio, r[i].start);
+
 			clear_contig_highpages(page, addr, nr_pages);
+		}
 	}
 }
 
-- 
2.20.1

