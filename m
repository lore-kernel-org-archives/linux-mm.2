Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7AA2C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38866B00A1; Mon, 21 Sep 2026 11:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE95C6B00A4; Mon, 21 Sep 2026 11:16:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFFC96B00DF; Mon, 21 Sep 2026 11:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 88D726B00A1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:16:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15B7CA01F4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:16:34 +0000 (UTC)
X-FDA: 85238121108.06.173AE04
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf12.hostedemail.com (Postfix) with ESMTP id 96A0240006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:16:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790003790;
	b=Qa6ISDAw5daNIMkPmr1CXavmyDTLsGcXfp2VaGXkheN/o1d97egjaYW/Bv5bru71Md7Ky9
	sIV77Yylg3UlZwbqn4FtEBZBnbLXE8jf/s1ftAwF0wxgRpw6DZzzctkMJFJR17hj45ADpX
	U8s6RnyMWrJw+nocvqaLWS2XIvEWsho=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790003790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s7sui+l8Lk8Sg0RbbNCSGvk5FN7ev3MFPGREbjtEQec=;
	b=O6kH+WVshMS9QQY9k/GTPn1M8nHLcuC/G8kDdEC0TIAxjvcd1nJIwn+ZoGVe9wt6IV45Nv
	TsQtYGEaPHhhNkj7nod9ft/+BZaesTAqJ1x4DtOG78hBDuZDvTinCVKMvX8ucXD+bV3keX
	VHXLMuUYsWxVHW02NhHDS6+jgYdF8v4=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 68AEC20CF6;
	Mon, 21 Sep 2026 15:16:22 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Tal Zussman <tz2294@columbia.edu>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v6 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
Date: Mon, 21 Sep 2026 17:13:04 +0200
Message-ID: <20260921151306.625134-4-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921151306.625134-1-alex@ghiti.fr>
References: <20260921151306.625134-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTE0SYM0WXNjdwubovITJrTYXyTSCwr/PlRPkkCz6KhxaAixi/QamYFRTWojpv77hYY7HjUcktzM93E0S7aP74KErDRnXAJ+8qBUZxDaDQ5JnexSaYr1F6K/qzS9RP6Q9NI0CX3RagQv2c/zqGxQWHxXflkOyoED1Sdwit9/i76dx7VxOUiBK8Q/gl4KmGjDzdQItBSNGWeNMb/7oLm/w9+WdgNkyz1o/4STbT4WL3/jko4pyhjinYBBZBp9KOF1J5FSuZ+4olXkmIuTnf3/D2n3GGfFEmJXsZU+tWWpUdrPtJniqkZUNoy4ZSEspEQMmwoGgTXrRtbYeOlg8rcIdNUZWXA9n5/PlSFk5VE9dwj5B2btg/LeyHrb4ABOY49XQIHak0YNNcycGU778Jq/RcxfzfS9/OkijGlqH6xM8TJRPm34TO8QzBEEplujliQBBl4g1MrFlGeuIL/HWzCO+aXF9QWrFXo3wwSNPvN70PwS4JpAAM8WVlDhfhDJMRKJ9RH2d4/ZKSW2PYTT5Yj+vqvmHHgVMLlTov0N1kJn9YynFmvhzKCargpgIRdwwp9rEjQ/9He1XjXC4a4bWw9fxO3R09ZKij8kswkeSR3egkE8ZzzZEU6Fzzhr//lwcRaGtZZAsXf/Q/YSr4s+b8Ncxxi3GEt0Y/7qxKV+jvAvbAw07w
X-GND-State: clean
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 96A0240006
X-Stat-Signature: 138keihjsw3b6wiybpgsd3moweif7r15
X-HE-Tag: 1790003790-781361
X-HE-Meta: U2FsdGVkX1/1IOTv+0gKa/TynqpPt0JU0+Xg/Q30MA7nGp/QYoQ403b7P582XK8vjqxuljsjh/AfPe7dDAoQHu4r20eNDckHWseE8mdfc2qtEEeZfReIYgD0WR0cyoxRe7X4z19/3961VZ4tO8628s+1i4gVHQ77/x3lfNneG/qDfEEqQRWihV7iMN3XHfrgoD6ea7aSubKaogWBpCv52TTR+x5XKPAtmrzs8YwCGcx4Xw6QEamw/jePxtKQJNYYZ2qxhX5mROd6IztqhreC2C5U1GVQCMhfNpPqbC4qwyleIYXiImgUKN67165h01Z/3Aq//wreyBbNACZacFUqfv6IMgit1t7HRH5btSCPDtaqPI/xvJAci3QY/+mZPcGBEXQM5Wy9OY6x/eMR/B5uxzbHb+4opoMfxFKkYbWWDfvyq6HgyTn9AcbpVFWBePGo7Mgs6kVz/L443p2UD9XOVewekj21V/tLrDTyqHsjp+A2PWWhgkJroAYvHo5Zkk31hLgD1M7iGGew9NTat8d9E70iz2kjTLO5t9xe4bRtu94oX+ZEdi4F9zbOs4sOFOvsgeJ4YuSazo6fgKe+/81G4rUoyTgg9WuzH2t9zue+pbWULM5vrWSO7u1ZCRWT+4LtpWMIWOdDuNyuL/OC+V6+La1JCffTiKG09ztbGIBSeA+c+tm0tFGj6c15V7Pc6crdPdgpjJTZtLZVkwwZeafkiuUCVYC35vM/XhYd+MtWrUA2wHxMsIQwoL4v5eIptzUcCmi9azTGpOAjpv2lmyHe+3Ru8nIk3EsB5DyX4rBGW+6bBalJleGWb/xK9tgM3hAKB/GuNRK7/ZUlhMNcGzrLr5ewyyiAa+lASk6TIPIVeTWSCOpKoaYb8JXQ6ks0E3CgEvnnknMx/41QMm6aTIa5/oWFH0KKP2iugJnM+IQGEWhHXnpAl/AfSpzPf1jHQfvh7YRgeaXCMq3cUIReCHG
 D7o5jTnA
 2MbBVzysYKNVuVI24d3r43WG1BPjnukL4wUtnRug+92ZUjL3W7UGKY7pF4D0O1gljCvcHd3FGssIVzrY1fdhHoMqAqfbT+dGUNOdAle//hqTurqL669sbHPonEko1yZ5wBBJ6FMZ4O3DhWISI/QoxQZS6gKnqQxEXkHuj2HHSiJFBqd6/QRb6uzTLYBOVgkUDWDkf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap writeback decompresses an entry into a fresh swap cache folio and
writes it back. The folio is cold by construction, yet it is left on the
LRU for reclaim to find and free later, wasting a reclaim scan and keeping
cold memory resident longer than necessary.

Allocate the folio off the LRU and mark it PG_dropbehind so the swap
dropbehind path frees it from the swap cache once writeback completes.

__swap_cache_alloc_folio() evaluates a refault on the new folio, and
workingset_refault() sets PG_active when it looks recent. Until now
folio_add_lru() consumed that flag and __page_cache_release() cleared it
once the folio left the LRU. This folio never reaches the LRU, so nothing
would clear PG_active and the folio would be freed with a
PAGE_FLAGS_CHECK_AT_FREE flag set, tripping bad_page() under
CONFIG_DEBUG_VM. Clear it after allocation.

That is a workaround: the refault should not be evaluated on a writeback
buffer at all. A fix for that is on the mailing list [1].

Link: https://lore.kernel.org/linux-mm/20260911092012.92399-1-alex@ghiti.fr/ [1]
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/zswap.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 0d2efe21f18a..dc8425d6b21e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1014,7 +1014,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	 */
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
-	folio_add_lru(folio);
+
+	folio_clear_active(folio);
 
 	/*
 	 * folio is locked, and the swapcache is now secured against
@@ -1028,12 +1029,12 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	tree = swap_zswap_tree(swpentry);
 	if (entry != xa_load(tree, offset)) {
 		ret = -ENOMEM;
-		goto out;
+		goto err;
 	}
 
 	if (!zswap_decompress(entry, folio)) {
 		ret = -EIO;
-		goto out;
+		goto err;
 	}
 
 	xa_erase(tree, offset);
@@ -1047,18 +1048,30 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/* folio is up to date */
 	folio_mark_uptodate(folio);
 
-	/* move it to the tail of the inactive list after end_writeback */
-	folio_set_reclaim(folio);
+	folio_set_dropbehind(folio);
+
+	/*
+	 * Drop our reference before starting writeback so the swap cache holds
+	 * the only one: the drop in folio_end_writeback() needs that for
+	 * remove_mapping_set_shadow() to succeed, otherwise the folio is
+	 * handed back to reclaim instead.
+	 *
+	 * Nothing can free the folio in the meantime: we hold the folio lock
+	 * until writeback starts, PG_writeback then blocks swap cache removal,
+	 * and folio_end_writeback() takes its own reference before clearing
+	 * PG_writeback and donates it to the drop.
+	 */
+	folio_put(folio);
 
 	/* start writeback */
 	__swap_writepage(&ctx, folio);
 	swap_write_submit(&ctx);
 
-out:
-	if (ret) {
-		swap_cache_del_folio(folio);
-		folio_unlock(folio);
-	}
+	return 0;
+
+err:
+	swap_cache_del_folio(folio);
+	folio_unlock(folio);
 	folio_put(folio);
 	return ret;
 }
-- 
2.53.0-Meta


