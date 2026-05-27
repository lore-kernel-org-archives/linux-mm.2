Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA902CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE2E6B008A; Tue, 26 May 2026 23:39:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C58D6B008C; Tue, 26 May 2026 23:39:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402586B0093; Tue, 26 May 2026 23:39:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED3A6B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:39:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2BD74049A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:39:17 +0000 (UTC)
X-FDA: 84811794354.20.26407C3
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf14.hostedemail.com (Postfix) with ESMTP id 450A6100010
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:39:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XjjgQoyL;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779853156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+cxbxhZdlUYhyShSVcB1R4gZ5/57w7jfc0KexcGnvXs=;
	b=PTmXqoKp4RhbhFnYhuipIiHfLyWm5FhjyLTIDvxUVOAtSV7aZIrsEwi7EVpcoNYCNSLVa/
	k3+Xj8lERfUkk2REvTEnpMRg14d9UqFSIMKlBjclgGLMItUYGVHO7YrA29FNH6CGL8kzA+
	em1K7vv/zdsoxgSgiWV8u/RSlMhGHmU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XjjgQoyL;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779853156; a=rsa-sha256;
	cv=none;
	b=hcTroFQbPAzjKzbMAYHIRNJcxqrW/5c4GDVfLlw93oeqg70XKfxE5F0/UsjXgEspUHp6Mo
	INSaTnHqy+/Dt/W+oEqMbEB3aTSl1XXWgGTHHRcutyJ5fkzEYH9eJQylT8yjESZ3CdErpN
	+6ll8lYHJOO7N51uwaR+SiONXz3Ze4A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779853145; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=+cxbxhZdlUYhyShSVcB1R4gZ5/57w7jfc0KexcGnvXs=;
 b=XjjgQoyLWWQRwtjh6asBScAkA0PK9toxFsBttGjSQcgZ4F9XO98k//o+68O3y2pHGXVkB/
 5K7HEiU46Gbz/1eE+Vye1TJUbGbKOymhOZ56PlwfiAQ4LbITsNPAUhefiM+P/sJM/cSL0K
 e9GDYrM65m1oJn3NeK8d1Xq8Tt8Yp4ce23/MPxQPmoOqsgK/UVlFFWgsQLrjhdbXorW5Ti
 XVGP56elmQ6qUiZsYmmeI7l+9FL/TJLGGSqfJCUQUN6ydG12yhFEUzUO4wI1x7V7F5CPfb
 wj8c/6YMrH5jlHA1FRssV1nkwLzSQ/xALh9/N/9xET8UOll52wJL1fSzepzz8A==
Message-Id: <20260527033636.28231-4-lizhe.67@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Subject: [PATCH v3 3/8] mm: add a set_page_section_from_pfn() helper
Date: Wed, 27 May 2026 11:36:31 +0800
References: <20260527033636.28231-1-lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260527033636.28231-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a166757+28ea46+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: s8hpkcbiukj6gd45a16mtzf5qe6b7pr1
X-Rspam-User: 
X-Rspamd-Queue-Id: 450A6100010
X-HE-Tag: 1779853156-15789
X-HE-Meta: U2FsdGVkX1+bKxFqxTv6xRTNgaY5auDMVt6F7ssDjhPv/c+/kUS1j/mz1cb6tf716peIBGfxjmYyn/4kKGLhtWzjArRDLaIKDlDDgm7tFbVqXhMcebUgJCA0qnG9OoDLhjMakMVgKZnMG0EvDzBqd892Pa6gmThayAgqPX32Ch+/EMQSmISzAQu6Ei5ZyWkUiicz7BpCAg6nhm2Y+0y6SqO+tDwetdU3tqs+fZEjuQbyGkIfbdBE2F1q05w2fLKzrS5yk2z8lzqyhCnq8E8t/e6H+WGmvgFIXZbhgGTOb6Q1EvO7RgXkC7ekaDY1UMzqW2gF1qWqYnaIsTC1eMjpRkD+Ie4fy3kRxE1sqd/ramkoI+rlnipFFhQUFvKobrntAU36leGxXVbbsBwaSCrNnaXHT54ccQLyyQaUT+bbjcawrpDdYkHdRZBKMjX351nhZ5J+zmcC8AcWjdBRC83m1Iix5wFuJGAMPDxMkCLaejjTwjoZ74Z9/YDVKEw0un0vTHMLQq7phkEvQAfKQF6uYEJy8lfWX+nIuX7xCCSOGnIolXf6b5hUaIm1JkckONeAHOuzzwyaJgPzJfiz8zmN0Bmn7Qw3LbwScw6pjtPZzcPMm+t0dmwsub7Fmxb39Qplbdojg2cdYXBMEVXzuQL9pYn3TPQlg9rJUfg15lo8HZM4qmaPlAgtsYVJ6qqF5YpZxtNXPrgNGJ8bC4xPFPuNCCPryKHVYEQi6WGP7yxEabikaRmHncxwFIZE5wdFOcEUtlJyDisnuOzuJLLmQ3JJzIBNSWUVHvqL8nM+r6FkEGop+ij1ayMPS9vWg2c8kPdKizHRqlo2bdUdCAaF+3lE4QsHbxHeVfe3azZmX2GBBWM9Lwu7Oj9c2LVDzZDJHAEZmQH8CdnrED+K3IfS9KblXEriO34+a8CIoAItuvQsMfS8U48zatO9xIsl27ZosHzpF9cgQfZcOly5ydzfYal
 Hb9JiqIU
 x8y9oo4PJdo9keZ/0whyjZ0arEiYImFkQn/zDIBC+M1PE3a/31ocG4fdACgJoMQjyS5HDwCsD+qk9uehJtuG4jwggj4v/bIzb6PWyA3UsMFopamNN9udn9M5HfGKqj7vPgo3B3yZfH5NPj1i7LCjMPATFolEvDskSS/QTTLAb7/PrlW6uG5CpiHysnridF30nviZhqypvFavPm2VLmTJfvkrlm+4Dj1P0VCFsqPODsMngFrQLHgUs/u+q7qgfIJsupxIDM4Nu52mcoXZdwN+4QGuxZAUg6ulzDf49Guf8NmgjK4UDl3Y56HeMEwFV0X5+0x6Mi3swp6G7fTXPkIYRYaT+UpSK3NWOswCEdd+zYxwWxk14mqMZcaSQzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Callers that want to update section bits from a PFN currently need to
open-code:

	set_page_section(page, pfn_to_section_nr(pfn));

and guard that sequence with #ifdef SECTION_IN_PAGE_FLAGS.

Add set_page_section_from_pfn() to wrap that update in one place. When
section bits are stored in page flags, the helper derives the section
number from the PFN and updates the page flags. Otherwise it degrades to
a no-op.

Convert set_page_links() to use the new helper so later ZONE_DEVICE
fast-path patches can also update section bits without open-coding
SECTION_IN_PAGE_FLAGS at each callsite.

This keeps the PFN-to-section translation local to the configurations
that actually store section bits in struct page flags, and avoids
exposing that detail to generic callers.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index af23453e9dbd..bf84e698385c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2507,11 +2507,26 @@ static inline void set_page_section(struct page *page, unsigned long section)
 	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
+static inline void set_page_section_from_pfn(struct page *page,
+					     unsigned long pfn)
+{
+	set_page_section(page, pfn_to_section_nr(pfn));
+}
+
 static inline unsigned long memdesc_section(memdesc_flags_t mdf)
 {
 	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #else /* !SECTION_IN_PAGE_FLAGS */
+static inline void set_page_section(struct page *page, unsigned long section)
+{
+}
+
+static inline void set_page_section_from_pfn(struct page *page,
+					     unsigned long pfn)
+{
+}
+
 static inline unsigned long memdesc_section(memdesc_flags_t mdf)
 {
 	return 0;
@@ -2734,9 +2749,7 @@ static inline void set_page_links(struct page *page, enum zone_type zone,
 {
 	set_page_zone(page, zone);
 	set_page_node(page, node);
-#ifdef SECTION_IN_PAGE_FLAGS
-	set_page_section(page, pfn_to_section_nr(pfn));
-#endif
+	set_page_section_from_pfn(page, pfn);
 }
 
 /**
-- 
2.20.1

