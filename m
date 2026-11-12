Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5039606B59C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=P0xR3JBF
Received: by kanga.kvack.org (Postfix)
	id D80B16B05C5; Thu, 12 Nov 2026 06:29:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A1A6B05C6; Thu, 12 Nov 2026 06:29:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF9AF6B05DE; Thu, 12 Nov 2026 06:29:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C0B76B05C5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:29:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E848120565
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:29:05 +0000 (UTC)
X-FDA: 85426245450.27.3EC5714
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0889CA0007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:29:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=P0xR3JBF;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJExnKGIN+jT3YthQU/HCX+4pNOJnuCWmFy25CjHkh8=;
	b=6oaQ1r/M1PtwlnoCcFrG9NGPE2vQMoDc7nI4vGMib0CKJUhU7DspbM72C956Mue4ricDp3
	Boo+5NFz20lGZ+kEjE5f9k247kClnwfI3OLsQWsHVNvfYBZSSKqjkkDGyW2Ab2KRLpK9LV
	Qos4ONHXYBYUUyeSIot31uKf24HUJIw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482943;
	b=l+jQyh0WqBL2H5o0wIGYM/GRF0VyxYksf8gcQifCoimQqfYwczMRop9dQJTcIeLsBimHje
	JiPtdthY7qpsYTmzfrys1dySXza5a3cvglHoXi04Gc3y8FfOVifpV2YeZMJsHA26GATIiF
	vicIqUN8uMt8hmVaPJ3pPDQ6MtXgP2s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=P0xR3JBF;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794482933; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=JJExnKGIN+jT3YthQU/HCX+4pNOJnuCWmFy25CjHkh8=;
 b=P0xR3JBFV28agsTSVjIRuAfZhUjKcjzYym31KNjp+YCfY0w5W27/X8qQpci2WRGxOhumLu
 hMwa27TinlSPEazbBnAV8xHgD8chuHwZJfj5guQnN20BROXWdwXweypzrawHAp5YGRCz5b
 Q0rblvU9QVLqj4U47KTmZGeRV/nSs7xN/axyB1I6cajRr8R+RizIfcBUAC1YtqBVPEMRjU
 5v+hVa3ul1u6yUoDyRVpLg2HcLL2+BPS/xqZGx3P1GKCJ/Vss+6G6SUB1nZFPISOt4nMdb
 og9KogJmNcbUtaiFXDQguqs1krxyHhZtuyAm5kFYsAn62GWTjQKsWze/v7DSsA==
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <balbirs@nvidia.com>, 
	<david@kernel.org>, <muchun.song@linux.dev>, <osalvador@suse.de>, 
	<rppt@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <20261112112816.55095-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26af5a2f4+2a426e+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Subject: [PATCH v3 1/2] mm/mm_init: factor out memmap_init_refresh_pfn_fields()
Message-Id: <20261112112816.55095-2-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Date: Thu, 12 Nov 2026 19:28:15 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261112112816.55095-1-lizhe.67@bytedance.com>
X-Stat-Signature: zd7jgf1u54ebrxza76yry38mroxxisb9
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0889CA0007
X-HE-Tag: 1794482942-217556
X-HE-Meta: U2FsdGVkX18ZwDlBTyqXCdbpDSwOaemaGZjWcRGc0OaGg7SpIrLl7Qv0sQFRU6YwaMTRX32EjOW+agFwPxCnzn0cIydg7dSwKcZq5ZsrWJLt73+nQnc7s1LGeyqYh+ctaMFQ8XS6gpKw3GigaDyb0RUTWaJac87FKmiaqBmvOCEBCSCm5VeDFO4NfQ2dXbUv5hchfMDb1uuO5Tp/6jkl541BTypwrF2Q5hcHKMFjGtgWGQWxFVYNTG+ms9VwGYZoZU7bsGSWg7sPqNWn4mbN9SwyBUHHvlLBdR/Bl72KToU5o/o1i3vX455qX7k0pQQBLMTQ/KTTK1zk6A0cckGLOg1KqDSS1MycSdSSvEAk3Hb8+9iRSpXb10VSRK31LQnwyZCR0kXcNsj9NX1SThk5sGO/+dHa758Sx9wCcAvsD6/6aQeP/uBs5TIjPVUkPssIS44qiJSU7YuX2rgou089rCY9Bp6rh2orcHs2ECyH50k3o76yt0utpRKxlPkOHxRtszBuo33OHeOD6EbdFH1M6Zn4PIl9UtDg6FCj3aXbHiQ5xx1ysOJHetbRMLTxABreohKeVT3cFN/xOKA5yxnklnEFB24hwd7BJ9Awy30ThhZGltCSLyKbHtpEN2CpLMaj3c26MfSJP+MJLhfHTxmh+ul4tM8RHx+Jq650Y8ezoctEJpsobXc6Q3PP5MZBvNC2aH/TIvdjjFOQYM0iRtQl1jpq4SLhQ781uxVjDi/jliDzitKEJAi0JMgnobwRKjr04nP4eNzu7jOgdQg/86uDl7T00CQSSS21fFnccpQog8BaUs0CsWuEfggkSmIvc2dalCvJgACJUPkb4J4kib3W2Gj5qJapDLXFerD+kWjASn5roGNno6gV3P/DS0mhfRUTlqR46eeQpP0O76lf1AjDgqsw3QF54H4zvY7JZQTVAlgB+GKeeRQeYcaE+LZU4u6fGPUwF9kb1MsqfG89r+j
 6qEzGNUI
 Cjs7agP4xFhbjQafaz/IQnmovUmqT2+DEGgIVQRkJyf39wbaAsYRCKmYFaPtdYMLxKM/vZMllnyRnJxATkfhPf1DuB9jdYyHdL/fwyPu/pJufY7264j6JLsBEaGcxMUmSZmh/0tzAOrwUAy9RoAcz8O5nhffJpO+gUkXn+Kc4YO0R77wxcVZESqdaEiixunL0hfHIjVXyOTrvAM9N4/AwVcI0DbvfEN2BDNMXBhDro8jFYg/O+4FpqtBspH/KxZrEF4GsDwcKwI9sKEzkFvGzeLoB3tHocxlawqQ/3RmUzlms/w9rW0EQ27Gl8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ZONE_DEVICE memmap initialization already uses a reusable struct page
template when initializing compound tail pages.  The template mostly
contains invariant state, but a few fields still depend on the target PFN
and must be refreshed before copying the template into each destination
struct page.

Factor that refresh into memmap_init_refresh_pfn_fields() so other
boot-time memmap initialization paths can reuse the PFN-dependent part
while keeping their own copy primitive.

Define the helper as static inline in mm/mm_init.h, since it is small
and only shared by mm/ initialization code.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 11 ++++++-----
 mm/mm_init.h | 11 +++++++++++
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index d99af80ec752..33a9d8dd044c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1076,11 +1076,12 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 static void zone_device_page_init_from_template(struct page *page,
 		unsigned long pfn, struct page *template)
 {
-	set_page_section_from_pfn(template, pfn);
-#ifdef WANT_PAGE_VIRTUAL
-	if (!is_highmem_idx(ZONE_DEVICE))
-		set_page_address(template, __va(pfn << PAGE_SHIFT));
-#endif
+	/*
+	 * Refresh PFN-dependent fields in the template before the
+	 * non-temporal copy, so the destination page does not need cached
+	 * stores after memcpy_nontemporal().
+	 */
+	memmap_init_refresh_pfn_fields(template, pfn, ZONE_DEVICE);
 	memcpy_nontemporal(page, template, sizeof(*page));
 }
 
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 0034e37dbabd..7e1d6897b844 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -112,4 +112,15 @@ void memblock_free_all(void);
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
 
+static inline void memmap_init_refresh_pfn_fields(struct page *page,
+						  unsigned long pfn,
+						  unsigned long zone)
+{
+	set_page_section_from_pfn(page, pfn);
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(zone))
+		set_page_address(page, __va(pfn << PAGE_SHIFT));
+#endif
+}
+
 #endif /* __MM_MM_INIT_H */
-- 
2.20.1

