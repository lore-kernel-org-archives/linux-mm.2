Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A032EC01A4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71D006B0005; Mon, 23 Mar 2026 05:03:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3EB6B0089; Mon, 23 Mar 2026 05:03:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6098D6B008A; Mon, 23 Mar 2026 05:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51D906B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:03:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E6DC160A9C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:03:21 +0000 (UTC)
X-FDA: 84576739002.25.B9297FC
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 795D7120015
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:03:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xXnx8bmE;
	spf=pass (imf29.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774256599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AyS+Y+2Ai9P2Zvq5PmdY42vcDofhHhz65pz+VBfdu+o=;
	b=iL1Tp9FLlu0eO31tJwPlW0QOEBotvwgla/YlnHHB6YbAF0hie+r/047zQWOJLWtWvTTFkC
	7dzO6RQl3c5+F8B2dkbss0ETDxmTw3CwL3RK2LyY5Ykjzg76poXXTRYj0VAFg7JBXGFQju
	1ppQhX937TFqLvk7kvGqEhCvwy6eg6A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xXnx8bmE;
	spf=pass (imf29.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774256599; a=rsa-sha256;
	cv=none;
	b=6pQXi0eRT11fS7hw5Rg6ZMTaIWk9eFF1BkTYi8ZSm5vzgXeuNmS+JUp9H31wOF8WJUkUSX
	1vMaZWz2Wg8565LikbPkUiDA+mvf/Q39KTY4flTFmpk/I+oyY6ATAGHCZnCfxf2sP1OJgt
	lBQ9GcCtPz6kfStomYGDhFmzk2duRzw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774256597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AyS+Y+2Ai9P2Zvq5PmdY42vcDofhHhz65pz+VBfdu+o=;
	b=xXnx8bmEjq3p37iW0Ig9dPqTZXX3HfqXH11c8zishltzxN9p4V/tYpaSQdK4HX4NKu5v9N
	uwB4RE9efWKUDvR93FfDq0LnpoXnok94gfXbgquI0H6MJ9rvpCF9IhQlPrp46sXVGFFc5c
	fVApH81zt6fIjp5Rm8tlrqwqzu6XOhw=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Remove unused page_is_file_lru() function
Date: Mon, 23 Mar 2026 17:03:04 +0800
Message-ID: <20260323090305.798057-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 795D7120015
X-Stat-Signature: pdmb61m4hggqiuz6birupfx3b3aqwqox
X-Rspam-User: 
X-HE-Tag: 1774256599-558624
X-HE-Meta: U2FsdGVkX18Q6LSMi18yL76/MtNEcxdeHqljVfhxm0mrTREUDzhR1UDMpyae9WEwc82pjLiVxF4FEawJod1TEUIFjm0jWUV4a7f8xJMlzu2BeBzfT8IwcJzXAabQg7KnW81KB0VLdBZX/hY8Vu+kbLy/OBgb+o3bjRa0maXSJXRv6o9brCyamHboNgbhmeF8Xjd+ROwQ5j0gjEmeVAOkPWjEXaj/ty74MtBoLwgB7TJD6bAkmGguEzV8SI/ytFrU6b8J2RGURVTXlUvpweXCfMWXEslmvttXzEg7+iRZ5HRxrlt0K49t4WdYr/D0KF7wytseL7GXat25kOwS0HKZR7oqWQ6HMa8aoUwApjO5dovf0oqUIVNfqInCZz4d3y0fTVgBUNkMYsOeNBsZQcUsOID/xC5ODeOJAubeh386Au4AdUVU2hA8zKTvVQidok0I38J7Kfr651gU7V1CvDYJLRzAVkd6cuKFjeWty3AySiJ3my061TjwSP+8ymrAjD6CWwdhSFVg9kLsW0rlZZkYtKAqC+pdYiahZA8tv6ByGMMCLRkhiSrQ+FBBNQTO+foFBvFXBgzNIgxTSHBeq3+PFcjj4yhz4bNKXTamaMvz3vhnjhup5rm5UniEiE1e5EdO2PRoNueedncoqFWuzf3epP985rpu5WTB/5jsu/9UPESlsB3TMJeas56AMofcN9aGIBpQkNo0w59ovBbCedrZS/p47cnaKgVEQlHdNtbEGCl8OTyZHKKVCwh/gZDkk6cy6P5t2zHwn/i/TYTcFFiRmUBVNm2jPzNOp/eAdxHxCMq8TN52XQw2trn+qiPC8YSfkK6HG3dLA8X1dmzlwk3bwe8I8hT5E8WS75Xk2vDj6GX6N1Zeus8m5g8C/g0zDSSj3UIPGhYkvcGfPODgggfCkF9vJbXcP/qaSHKf29yhh/4xA9J+2jdsXIH9ISu3X6y/faqf4AhlEOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The page_is_file_lru() wrapper function is no longer used. The kernel
has moved to folio-based APIs, and all callers should use
folio_is_file_lru() instead.

Remove the obsolete page-based wrapper function.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 include/linux/mm_inline.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ad50688d89db..4fa480bf1dd2 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -30,11 +30,6 @@ static inline int folio_is_file_lru(const struct folio *folio)
 	return !folio_test_swapbacked(folio);
 }
 
-static inline int page_is_file_lru(struct page *page)
-{
-	return folio_is_file_lru(page_folio(page));
-}
-
 static __always_inline void __update_lru_size(struct lruvec *lruvec,
 				enum lru_list lru, enum zone_type zid,
 				long nr_pages)
-- 
2.43.0


