Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B73F5C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9A696B00A2; Tue, 11 Aug 2026 13:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4BCA6B00A4; Tue, 11 Aug 2026 13:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A646B00A5; Tue, 11 Aug 2026 13:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB9C6B00A2
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:22:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 010A4A146E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:22:18 +0000 (UTC)
X-FDA: 85089657198.04.C9572B5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id CFE9F120011
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:22:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TVRmqs7y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lr81ZlDe;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786468936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIxFR5T1oCJWCYenB/yqWbkPgsx+4uxFKjjdmptf6BY=;
	b=BHbovur0U4LjARBAlIMPf1mDMWZOl1O8fWc7iIv/0infI/T9EyQ67Hf3iq7N26E/GR0FW6
	OY4bVXQT/xzK/ShsDlsWN1vHHJZKJGSksN+jW+goTj/rjQBHz/8zFnji3WEzKGoHA42OhU
	aBxdWZrkKPYX9Gh0B+g0nHAqXYWqXOA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TVRmqs7y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lr81ZlDe;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786468936;
	b=61rbyRW5803zn8vEr9ENAmLWnN6fXM98BOIR9zcVd+HY2w/hDU0X24vVpgmmHziX1fv+23
	vacTxQOJfYNqAWLOIAYIuZ5VE1BMUm7+mrwB/Ogg7zZO69ml3L8K7jjUderGq9uttAh+YP
	gYYD1nuMlrUpH7qa8Y901QSywUqo+54=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6F6083E28;
	Tue, 11 Aug 2026 17:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786468930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SIxFR5T1oCJWCYenB/yqWbkPgsx+4uxFKjjdmptf6BY=;
	b=TVRmqs7yGQZ7KKUHjCzM1QE9n/S6E4xBaN7F+Hk76LoZ07xt/724Uxc0Xuz2GJBk/NKN54
	HFTTHRdEjMEB3DvmJEISOItx2VvJ8y8fCPnYY2xsjyuRi04D9iS9kyOBiqC594KEO58ssi
	DPVUYtxV/WjkWHnQYUtbeiFntQOhFBI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786468930;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SIxFR5T1oCJWCYenB/yqWbkPgsx+4uxFKjjdmptf6BY=;
	b=lr81ZlDeeRT19Y9sx8xev7hYNSa3Dnwrrr0HO26qPIa6XpbNtUSnYNmbD6RH0Z3Ff+SM9t
	7UeSxtgGv7iLnVDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 73A99779C0;
	Tue, 11 Aug 2026 17:22:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AHSqGEFae2r4TAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 11 Aug 2026 17:22:09 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm: replace custom bad page map ratelimiting logic
Date: Tue, 11 Aug 2026 18:21:55 +0100
Message-ID: <20260811172156.356053-2-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811172156.356053-1-pfalcato@suse.de>
References: <20260811172156.356053-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: CFE9F120011
X-Rspamd-Server: rspam07
X-Stat-Signature: crp9uik4n7t9ffbm1ga8mgxoyzqkaqex
X-HE-Tag: 1786468935-176041
X-HE-Meta: U2FsdGVkX1/f49xH2ou0fHrvD1WQ1G+ZT21yb9hozWayziF7+uro0HR2U0R2B5SuywDNO5g6b9Iv8GRfh24JV4PXhKnEIsJ37ZxW2g/1QLurm46mdHXr91z8loIzB8GVD5rK5ne+2ADG1kIhU1YDIs3m+EZn99FYJGZdovggfSfZlpd8Dkf5NTVEEamnGlPwH5AvHWD7yALnj09ngEj3hQPVmpALVLYDMf30jPQV80z8qyhvltQKZzZEVLAnnyQeJDacU7VJ+LZjK61EqxyUsv9c7OrwWe/w+Sq3+BVGQ4e8VJKZDeshhiF1BQ4jbbUIyu1WAOgcBbbzIoI9QeXefzqX3tm/xIFeWoabMhsg9FJeNSHnlWj7rsa3mVhpmbl9d/HZYLho86aNAzoG7ZlnpBVBRZeO6b7IAcyR9giGNB/tCIpR7A5iNJ9hRBl4h8XIO5eWzCI/fRnNRRLrDibZqbyPOEfYbZWTviaEFNG3Hiu+3rBdGu9LPyJ+8M9PUse/pRV8ysBQs2oXwNvhqfIwFvxGEl5ClcUZvAC+IZLr4sv13cFOcuB1gw2ZvTY2v8VcPr5V5HmIHd2ELvqaxF67tX3gtX0Gkh520yf3nwoXa8nizdJkSV1cMzGS+N4W6lFyvp+D7+jqxGmB9KDNGcBWLl30/5jpaShtuCN2+H+zWxi129ZzKZ0EDy5SwMFDjOFwZoPZjjYQMUtfyVr+8Kxs9eaQcUZcw96JZWxOAQrOMYSrC4zwb9QhCrqqxRUCjUd3+WO/6as+yIbXKoF3YNJ5BHzS2XsXS+dOv5WUi6hkKMzq6y4xULROdz1L53y24M5xIOxjMjkZDlboxLzyxsPXpUyVL89p5smDJLHtncuZpwPGzB6ztBZxEAv3vsJDSlj6RUjCCWzGT2xBo9T0SmQ+TNZUEbwrnNU4MXsbYROPew6alhceQp/QwiJYmhSMpJoVHd/rvinsUOa1Xq96PzQ
 jiDRL2AQ
 oJPoKfdZJ8f9BjruenPY7I3xbLO86+Mmw8dBoO63mqGc/p+iIfMy92RGwNoCy085wtRtlPXFj/xEHlIH7FKhaLr4+XCSXCfyL1KPYHv6fd054z9T/1J9TRlV/EdzLZdcXoQ+T2S5rhqgpG2rUCUQ428na5rmowt/5lyXBKDgWntze6hEczJxj3zxTL/DehgEWU86Qb2RtddqHwSPNj+HY+GIicp4G+6sXbVCLvDjXIszTQOUyx0cimB3RnEx0X7BN0XmmQEGQIgXLylQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current logic (allow up to $BURST prints per minute) can be entirely
replaced by the generic version in lib/ratelimit.c, used around the kernel.

Do so. The only functional difference should be that the new logs will
read something like:

KERN_WARNING "print_bad_page_map: %d callbacks suppressed\n", ...

But that should be fine enough.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/memory.c | 30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 4134ac607ee0..b4be57b590ce 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -492,32 +492,8 @@ static inline void add_mm_rss_vec(struct mm_struct *mm, int *rss)
 			add_mm_counter(mm, i, rss[i]);
 }
 
-static bool is_bad_page_map_ratelimited(void)
-{
-	static unsigned long resume;
-	static unsigned long nr_shown;
-	static unsigned long nr_unshown;
-
-	/*
-	 * Allow a burst of 60 reports, then keep quiet for that minute;
-	 * or allow a steady drip of one report per second.
-	 */
-	if (nr_shown == 60) {
-		if (time_before(jiffies, resume)) {
-			nr_unshown++;
-			return true;
-		}
-		if (nr_unshown) {
-			pr_alert("BUG: Bad page map: %lu messages suppressed\n",
-				 nr_unshown);
-			nr_unshown = 0;
-		}
-		nr_shown = 0;
-	}
-	if (nr_shown++ == 0)
-		resume = jiffies + 60 * HZ;
-	return false;
-}
+/* Allow a burst of 60 bad page map reports per minute. */
+static DEFINE_RATELIMIT_STATE(bad_page_map_ratelimit, 60 * HZ, 60);
 
 static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
 {
@@ -633,7 +609,7 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 	char entry_str[PTVAL_STR_MAX];
 	pgoff_t index, anon_index;
 
-	if (is_bad_page_map_ratelimited())
+	if (!__ratelimit(&bad_page_map_ratelimit))
 		return;
 
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
-- 
2.55.0


