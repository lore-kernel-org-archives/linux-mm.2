Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D45BFCD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 05:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1C286B0269; Mon,  1 Jun 2026 01:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECC346B026B; Mon,  1 Jun 2026 01:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE20F6B026C; Mon,  1 Jun 2026 01:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC3E16B0269
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:57:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9897E1C1353
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:57:50 +0000 (UTC)
X-FDA: 84830287500.25.D617D47
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1A77914000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:57:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=HQh1rnhi;
	spf=pass (imf26.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780293468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSFfhvzoChQOQgIIJG5v3NjnH7WU8ceJmhHARcctEEs=;
	b=rUz2VsKbNreVmqWuM6rk9/d5lSLEhAH7HYDN9Tvpe3BqJ2TdqwsKXl11uDaMr/jDwWXdTh
	Ol6x52vpDobUy2FBlc6EQXm9dqDR51CIXdXiztkjo9z52POoMcoQA85UUpvkuPcdb6UzXB
	pdbrY4zGwi2gqIafw5XnvuyhhhNp+CQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=HQh1rnhi;
	spf=pass (imf26.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780293468; a=rsa-sha256;
	cv=none;
	b=hDeZgpq3rxQWk8Fcr3VD3fnyuqVy91teDc2LH+aiJY7u/RGyKSTjkJaeJb/2TSLc8uT13t
	1G4y0c+RiLk6Zq1hExv2+jN1A1k6+hyEItoZBFv6IpuAmFUsYeTgmyWzIqnPWMT+XYeZzl
	Y+SNdj9GT+3n+XIyTzCiogRqAwoWdl8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=hS
	FfhvzoChQOQgIIJG5v3NjnH7WU8ceJmhHARcctEEs=; b=HQh1rnhiRosYsEScko
	GkClTFquAuKP+Vh79FH9s2EGthCwz9V6MaOhQB2tX/5wFhrFQjJ565KBQYkPMy3a
	+1/ckkRU5cUMXC45gK942ZQ4HdnVnAi6hpF719Fa67drlNBfIfnF/4te+WYqDEoZ
	bY6j/Z8TL74u0/qa58UchjLI0=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3_7Q6Hx1qsb0MAw--.47504S4;
	Mon, 01 Jun 2026 13:57:20 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v2 2/5] mm/filemap: reduce xarray lookups in filemap_get_folios_contig()
Date: Mon,  1 Jun 2026 13:57:01 +0800
Message-ID: <20260601055704.167436-3-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260601055704.167436-1-chizhiling@163.com>
References: <20260601055704.167436-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_7Q6Hx1qsb0MAw--.47504S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7ur1ktw17Cw4kAF17WFy7trb_yoW8tFWfpF
	4agas7WrWxJw13Cr1fA3WrC3WYk34vqa15GFWxGw1fZFn0yFnIkr17K3W5Jas8ZrykJF1x
	XF48J34kWF1UJa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j24E_UUUUU=
X-Originating-IP: [116.128.244.171]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9wC5V2odH0BQSAAA3p
X-Stat-Signature: mb6mj9ux41breuxn95xfh9rgibkqxzzs
X-Rspamd-Queue-Id: 1A77914000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780293466-685516
X-HE-Meta: U2FsdGVkX19YUov14wIAcBFfbIWzLzwxl/HvhZ69v6ecxrag++zYIvIOCezDd3+CoBl9G1m+AKsC0/HaN0SHZZAOBuB4p3WZw9gYDGSqgD6E8uIXXdTCZh1nJgtT/EMLunJXcq8SOhbtS2jqETdjN2Gx0iA+JDpoxcyrFXNpm2p7cVlHFFt8qj3Gmdfe8ImYJk9bfz1WntdvNJvOmZ1zUM8Oxe/qLD/POYTfStds5rdj3rqFP1ChUXhV4rLNB2/XQ/a/n/e6c3qUu5xXoR+qmWiMTT+O5elXDCtVTCrszccUZbyHMBpurkyrBT8zUApLJWLwTVuqmWPQAwcIXoMdLRA3G4LSvt9JXuTPbsQoQ9Mx6Kbjz/GUdg6MvpfT1YSNFK9U+V6c3f8DSV6qvZJE60cPzmnnSrABP9+o+HOUDrk+tBkSLBASI+3LuuDJZlUahSivO7MQs9GyGR9rqXP2/gqjIebnJ9gTgT9gkI0Uea4hR3QZabFw2hXbmUF/VZwVzHWM1Bg3w3OUKyv+udYX96XFXLOTx4uOS5MxJhikIjcK1vUmBB/NWHnDPl6R4O/w6TEwYcwFob3oNHvk2P60MlFBpiQGlgg3blwr4/ZU9ldXMSFNwA6nrce+KvdzoyRFWDwJQb3KD6zJeHOkDfYA/3smbuR6/l/L3OO4GTCpoj7fzl1p23s3dh/GFwZs97JKidTmZfbwrGtns6n97RdQ+/KWYLyIsZMFR2ErzAO4tt0ClGMmbt9FMS0qDKd6XYu0hm1QtP5hxjzlNdqSh3xHOo/kwvOkodqxy0LvZuwal4s47bBSxjX+tzwC17IM5eHiNHOVWzEUFLgWcd893814j+wdAgllJH/761js4eE6LJpOITi+XtvhqUvNLta0wN5dVNxGygt4DEWEj0H59C3XkOI7pgTu09qE2IordpRynoXvDyp9jYxNpqefP3HuW3AalqmP5TCk2uHXU75iJ7v
 R5U0Rdtc
 zHQbvFr4hdFypH3bMNa3wmZm23fllNwFMCROotXuqE2+8/u3rLYRK6uQ98y1ehyvwfecXemzvIUgWN05MHX0Gx170F8/Opc0Nabmvd0Pb/GY5Fn/vY5gS8mMePeJK9/M9lMne7HFkWJ2OzYC3Liq+sJIPUvDVFhDKpnLPBPb1nbTDkUcDi7AMq+SidCFruom01BMmd9deEVEyUAhIyXpdOu4Jhj8j5ceulyM69IyJYJzS3E4S3uIJ8v8erY0/bcLrwgQVy0YAnMEAYkh59FWy8do45GRSd9OiolCl1ouqMAzblPUTkSCfPPT5Xl/oQugIo4nySVv9IclwOyPhTe9rfunPZbC80/Vec4kc3F0hR/ZhT8htq+CjpidwxC0LXwVNDr4k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

Apply the same optimization used in filemap_get_read_batch() by moving
the boundary check from the loop condition to before xas_advance(),
avoiding an unnecessary xarray lookup and reducing branches in the fast
path.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/filemap.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index d54450e529bd..6bc717f205a7 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2258,11 +2258,13 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
 	XA_STATE(xas, &mapping->i_pages, *start);
 	unsigned long nr;
 	struct folio *folio;
+	pgoff_t next;
 
-	rcu_read_lock();
+	if (unlikely(*start > end))
+		return 0;
 
-	for (folio = xas_load(&xas); folio && xas.xa_index <= end;
-			folio = xas_next(&xas)) {
+	rcu_read_lock();
+	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
 		if (xas_retry(&xas, folio))
 			continue;
 		/*
@@ -2270,11 +2272,11 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
 		 * No current caller is looking for DAX entries.
 		 */
 		if (xa_is_value(folio))
-			goto update_start;
+			break;
 
 		/* If we landed in the middle of a THP, continue at its end. */
 		if (xa_is_sibling(folio))
-			goto update_start;
+			break;
 
 		if (!folio_try_get(folio))
 			goto retry;
@@ -2282,30 +2284,28 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
 		if (unlikely(folio != xas_reload(&xas)))
 			goto put_folio;
 
-		if (!folio_batch_add(fbatch, folio)) {
-			nr = folio_nr_pages(folio);
-			*start = folio->index + nr;
-			goto out;
-		}
-		xas_advance(&xas, folio_next_index(folio) - 1);
+		if (!folio_batch_add(fbatch, folio))
+			break;
+
+		next = folio_next_index(folio);
+		if (next > end)
+			break;
+		xas_advance(&xas, next - 1);
 		continue;
+
 put_folio:
 		folio_put(folio);
-
 retry:
 		xas_reset(&xas);
 	}
+	rcu_read_unlock();
 
-update_start:
 	nr = folio_batch_count(fbatch);
-
 	if (nr) {
 		folio = fbatch->folios[nr - 1];
 		*start = folio_next_index(folio);
 	}
-out:
-	rcu_read_unlock();
-	return folio_batch_count(fbatch);
+	return nr;
 }
 EXPORT_SYMBOL(filemap_get_folios_contig);
 
-- 
2.43.0


