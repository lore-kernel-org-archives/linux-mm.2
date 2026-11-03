Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D3AF606EEB9
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbDjWhk/
Received: by kanga.kvack.org (Postfix)
	id 1A7636B05BD; Tue,  3 Nov 2026 11:17:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15AEA6B05BE; Tue,  3 Nov 2026 11:17:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021916B05BF; Tue,  3 Nov 2026 11:17:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D600E6B05BD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:17:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 704B3A04C4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:17:07 +0000 (UTC)
X-FDA: 85394312094.16.0D8D7C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9D4BF160002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:17:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bbDjWhk/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6XkFTBaGPcV74Hvx3Jzk/fiQfWLpE7qRTByDVFKME8E=;
	b=Q3ttx3N+M2O4Qm7RYgSoiYcGWbTxX+r1ct0MVF8Z7Nf9LGhii+7T3MB9tIAeFw9tdAx/AE
	nzUmHixI0dBVi0DSNO1fMA+X5TMj7IUyUtsYHdSopkv+4ziCZve282iSKHrzELTMO6j8Ej
	lH88gF7LBjsCwHvgEVJ2VNF7cJOa6rY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bbDjWhk/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793722625;
	b=22kx0tnyBXKlguauOJmxcUIeUrfSk/EQJBVS3VMok7iVKmI9hOPoagZSNs/0JDFkUZna1+
	wghZN/hZaXscXBBj2L9XndOkWtuypZ2+cA6xc7kaWe8uL5YMNE9E++q/CLjlDLcwLXHqn/
	CYYzCt5wS65AFsMmdddXnXXaalRPZPg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E2AAF40255;
	Tue,  3 Nov 2026 16:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2311F00A16;
	Tue,  3 Nov 2026 16:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722624;
	bh=6XkFTBaGPcV74Hvx3Jzk/fiQfWLpE7qRTByDVFKME8E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bbDjWhk/HrON7r5DDzIx0zRhSP31IG/7Z9RFLl5dyFRXh/sKuD42LRnSXT45yPJHe
	 3ZkGK/wJzIp/gz8R2jzr5SkoNMY/qbszU3v6vb3ISSiiGNtghSakPYAPDPxvw0hx2K
	 fzendGOVPobWobrFQDpnvy9XRc3L/qAX80IYniQYVVJ7iNwIZTwgUdCfEqdIW0LAnf
	 pe46xIVHomUN0FRTP9YpY4sAbwhZfBZVLgi+uHSmWrDLhT3TNgNMBBm91RnU196c3a
	 yuQqyVVpUwBW4HER5FAAJjBCBZgrO0boOYDiTQ8I+kfnliJQiFzOZIwKeICoIDMNeE
	 eMuHHGywQCavQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 03 Nov 2026 17:16:49 +0100
Subject: [PATCH v2 3/5] mm: page_isolation: do not take slab pages for free
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-pgalloc-ai-hotfixes-v2-3-e0d2890ab74f@kernel.org>
References: <20261103-pgalloc-ai-hotfixes-v2-0-e0d2890ab74f@kernel.org>
In-Reply-To: <20261103-pgalloc-ai-hotfixes-v2-0-e0d2890ab74f@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, 
 "Gregory Price (Meta)" <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D4BF160002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: is757183rcnqye6yjxdqyxrwtn63gxx5
X-HE-Tag: 1793722625-753506
X-HE-Meta: U2FsdGVkX1/gyCWcf6xLGWbCMd99xAmv33tTGSe2LCz9+A/hnBpwzwA/nyFFTArAs+SbjFb0rPGgroNaVbsY3vhrx7Kpi0yooBHNYTdkml6SmpYJjyTKFW4RpG9lcc+0kUSJaGyeiop1WM+bvX9UlpDt5bhPwQKduekLjdzJToA532rrd4vxyAwnXYHC2yN7mfETTp47/opnr5+0z2aYR/dpDsZ5OI+ph8JphQ33csSqfqkF6yYY3q25PSlKmSMzpPiZg0gPjkApI4nmkfptf79J9Lm2uQ9TFWCty+sKvHZ8QLFXlrFWKniubHVFlvrwVwDvu29vHFrL4Poo05qqYLaShqeEFjyGZ+6UV2FRMvIKTdZ7TGs1YAs0/yNWyTJhjRp+d3b1r8d4jgWpWy6JweIsmtwxKBxPT/pGOG9BeQaH027Heu/gJQVOajON2XR/PY07rOMIwim+hHtktjfOIPUZ7XKXeXORFsljUwOL87wVN4zr51CaEOa630pR3htCTvKbPyvQW2ZNE0zGQYyjXB4LJIYjviV32U2UMMmoqt8h2vv53exSd5GlDrJQ8N+F/5PhYi2EbwJ4c3jNaZ1W2KmWfPLCR1Ft2risCVuhZcDfDDqOBa4QzljvVlDBob9nDeGew1+dCIuiFuBvXJ1deTM+Dsubzc4shaCbzeiuJiyFXG61+d6QgSHguTBhb/RHdKYpgncA+C62naFewsL3LmB9DwPBFKFLQAxmyOZ32yt6Gw1m0PfQXkJQedNlAhR9qAtsT4jjQaVA8HknsKN/NrSVmszvOjbkOqjoBHVfiSTw4JMA0Ibbyscg1brILTsntx6kCnv9jtzwy0jKamnaKoSrozo7CJbhvT6jL6sGyyUUx7YSdR4/Fkyyq9Eekn732xGWuh3EeMApqS+cV0i17wRiv3d2sNJ5MP91ufKwTt/lRI8ITje8yTz0z0JBPGxeTaxT+YewEwle5k1Rycg
 eOnk1u6i
 xVZUWCvLFYzV0wJPY0aEn7XQl9W/uCHGYh/h8BhgH0mUV+aFqc68seBXpJlLDgVON6Ali+Dzya3JlBjPkYpVqHKz64hdF9IBDUyb1KnssrD1WAnhMYcuHwWOlc5nUvHHBb1htIVs0l2Etci2XQAysGJHvEIPud+9O9pXkHbQq7Mb86vwGyVWw32+AdNdvpIFtl+/F9gxP2xh3tcRDBLz/VxIdmHDwKuNN0YIciyudsxbD4U3QZchK9kAfc0WF7plPEz/eBTbW5Onr60ByG7V3ia44Ue25iCBUkWb9LdNoqcb0G8v4Xv2RWPXbZhtbs7WS0d3HT5a0UJUtDdwqOghDgfizjqqgfPlPH+AOqevIawrx1D89UErdRY/8HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

page_is_unmovable() regards a page with a reference count of zero as free
or about to be freed. Since slab allocates frozen pages, they will
be wrongly considered to be freed if order 0 (higher-order compound
pages are caught earlier).

If such slabs are the only unmovable pages of a memory block, memory
offlining now isolates the block, this can lead to offline_pages()
looping without progress.

Thus detect the slab pages as removable to return -EBUSY, as would
happen before commit 9aec2fb0fd5e ("slab: allocate frozen pages").

Fixes: 9aec2fb0fd5e ("slab: allocate frozen pages")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/memory_hotplug.c | 7 +++++++
 mm/page_isolation.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c9cc42e54f05..0ab9a6e09222 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1832,6 +1832,13 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
 		if (PageOffline(page) && page_count(page))
 			return -EBUSY;
 
+		/*
+		 * A page that was allocated, but was not a slab page yet, when
+		 * its pageblock was isolated.
+		 */
+		if (PageSlab(page))
+			return -EBUSY;
+
 		folio = page_folio(page);
 		if (!folio_test_hugetlb(folio))
 			continue;
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 5aaad037384e..f4f0571607ab 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -74,6 +74,13 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
 		return false;
 	}
 
+	/*
+	 * Slab pages are frozen: do not take their reference count of zero
+	 * for that of a free page.
+	 */
+	if (PageSlab(page))
+		return true;
+
 	/*
 	 * We can't use page_count without pin a page
 	 * because another CPU can free compound page.

-- 
2.56.0


