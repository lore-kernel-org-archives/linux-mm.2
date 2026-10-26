Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50314606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LjVpZyiF
Received: by kanga.kvack.org (Postfix)
	id 6796B6B05CC; Mon, 26 Oct 2026 05:42:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F526B05CD; Mon, 26 Oct 2026 05:42:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D776B05CE; Mon, 26 Oct 2026 05:42:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39AAD6B05CC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:42:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CB39806BB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:42:10 +0000 (UTC)
X-FDA: 85364286420.04.89E67BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 959D620009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:42:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LjVpZyiF;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxsrvdQeklij5bNnoXCI3fI7ymOsyRK2is1t/Mfw9Uc=;
	b=rkivD0bwpwmV8kZAH3dZ3hRlskyvrK3S/wMfi6gWkY//MCkGpI0gCezkhlHPHOMaCom1ku
	PcT7xTwzdh6WzzW7JlZIrsIzkGlarjbOMP2LHbEds1a4CMF75inVvNJH/AElqhvde4clWF
	0xs4g+m+RtKvSq7a7T4/2e6wTu+OPuE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007728;
	b=sQFaOr/MCwiMBdCWS4lcAcK1B5pCrP3UvYj1IIA76V+abQxwi0v0pQt8lIvXrNQKomTc1l
	DGtwF7xJmS3ZgM/ZZs15F/t6X2lZiLbPAIzcVYSoFY0U4mYSPKrEjYJ0DcubahJFJdCJSm
	it1L6FsirPMIgpP5FzLdCPHyAmOAgS0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LjVpZyiF;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26ABD6022B;
	Mon, 26 Oct 2026 09:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BE01F01482;
	Mon, 26 Oct 2026 09:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007727;
	bh=xxsrvdQeklij5bNnoXCI3fI7ymOsyRK2is1t/Mfw9Uc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LjVpZyiF//41fBlp/4QleJd9wySMgtYf11Q4g773yO5jjicIeHAR1b3GvLGFUmtKa
	 rAx0NSzVSEQDT4qr4lCgCQbWo6XaCjmHAUt0qPd7MuH2dcibosdTeYBtUgKG4DXAUO
	 7DEtVx+ODrpkOBjSGBG4gObiIBi0FDb6uZ0OxNGIiuZSzsajPqyKCFWMmOQ0X1L5lp
	 q+UmrAKYpWtQOcNUCBQzy0iYsQ3ZvJ6OMhFN4s8RTFwW7P7E27RYpwr99NdJ6bPdF8
	 4Yr8BljsTzEEJIPHEOTCoxHxRMPGtE4FaKFJqNBanrHneYrYUrJbKxx3hYBQ3r8OEh
	 6PwXAh6gDkxPg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:44 +0100
Subject: [PATCH 11/16] mm/shmem: rescan after nonuniform folio splitting
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-fixes_shmem-v1-11-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1965; i=david@kernel.org;
 h=from:subject:message-id; bh=e0DEI1Pn/7U6AfFOcXN2aY3ffxdCD7lHzQz5z/jQDwA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK4hXd+vsuVVmmt4jYSMpFdqxnPlPrWL75m0Gx07+u
 8So/MS+o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIn83MvIMN9Pi69cpsSmzdRt
 RVrEnv9X5pt4Rb2Y57B2+tJHy2ZabmX4pxHl2M1QuPcE171vKmbVGnIG4qtrXe6XMDTWa64y0Hn
 IBgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 959D620009
X-Stat-Signature: rpphn4knogy4ou3rn7xn45hszeweigzo
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793007728-655292
X-HE-Meta: U2FsdGVkX18dtv6Wx5QwMibw6d42c6Cpl+AFtjlA8LKht+gulkLs6umFRpJhrWvZ2b4tRdClzNvfNnvgP9ab4IZuHuZn+mMp52BEj5B3StH11apreNRrhaKD6Do+aq8wNi/i8AaBRRpVdpS49UBDgve2MakWn9ZCQllz9cTBKJVe2r2WfmIB7Ph1mHvva1PqIoKFDANbMly0oY4SVU3rWymgnbHQUeEJJmNNC3BvvuCweu9E6WiWWpU9n1SzrVqBIy01BH7psStO81YUVhsTDwFklJA4gEEQfQktRN+ICVgbeEyXmJ1qUOIhMTMU1P6Sqmw4U1xKmoRGesG9AurWbg6vyht1p3R6M1VImHfMpIdMwrF8GIkwZZVpuIMq+UQeKBd8PoiPYki2svuQL2555DFQswpZSybLUoBJ4AaKzjl4QZ7SQ9FuvyS50aDm61tiLnr4ia/QyztC9iND9K2gGYZQ+4q3fL3V3ioVKsBU+YRn08Wb+fRe/gchhERXApWDYs06cLpZj/xVMaaP5vT1h2De2XXavdvxvBeG16YrqON/UciKncC8AL2tBhb5SaFRwk+JRFXB4JZQ5WcwPOcQFJqn0ivolYnZTlEB2V7A2J1P8BaigrJ+ncc5miRWkvlZuQzC1z0akmxbOvkqna82Fo3tunY3yE7n4ePOA8t9CrfN1LwQLD4xCOQXOrv0KpoW1YkhghAUEpM0r2fPscS1Ts2WvNDNQMxNaRxH4Ta9tO8Wj966r/VlepAnQB490M+UTMfMSusBkXldrF5bx+uTO12xwWv/Z1/b3heCNK52/rJTnXMGnvNWfQPLHiqKBxrHHXr+CUvHuSP7B2rQ0hKuhVrvyhqrhlyGuoe7+eis+ZfstXTD6UFE5XrLXGPTrNtG850NQrH/zPYH15/S2O13iU/ERp7yOM43/xg4l39qebObbGv2EUvt8S6EqYm4C7h1hyoLHN9ACkPGXBvqHmh
 BknV22Ay
 D3lft5csLyK+2Ek+JTaqiZwL99dKwylPxiUvXu5cjFhHQdA+HOSTliyOsIQ0ZJFt5SP7vVzsnkD4KaMtymn6ln0B/L80MqkxShxOEmydT1yFRxtozrEpQW0QxLY7XWRKm1FvHfVRhPowU/TxlDVOXn0uSHbX1OfhWW1Fy8uWldMtRqEDDuj1MrFeQw/KWW/a1uTpQ6kDLSkX1yULjN0lnpNeKcdyX0Zmtzh0MidHzVwm26953r+f8y5Rg/m7H8PFDcZb9DxV5Y+KSTZJtdOr/cuuM8YWwkVE47uCLP37OTZSEaPNoYbblKhLMsr7Fi1Edrh/X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The final scan in shmem_undo_range() restarts after a successful split
only if the original folio is no longer large. A nonuniform split can
leave that folio large, so the scan skips the newly created folios.
Hole punching then leaves pages within the hole allocated even though
they could be discarded.

For example, a fault below the hole can allocate a 2 MiB folio after
boundary handling. Punching a 1 MiB hole at offset 64 KiB splits the
folio successfully but leaves the original folio at order 4. The scan
continues past all 512 pages, leaving 2 MiB allocated instead of 1 MiB.
The hole reads as zero, but the pages and their block charges remain.

Restart when the original folio is still in the mapping after partial
truncation, identified by checking folio->mapping. If the helper
removed the whole folio, no rescan is needed.

Fixes: 7460b470a131f ("mm/truncate: use folio_split() in truncate operation")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index c8608026e06ef..fcec40a2dd707 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1487,14 +1487,11 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
 					/*
-					 * If we split a page, reset the loop so
-					 * that we pick up the new sub pages.
-					 * Otherwise the THP was entirely
-					 * dropped or the target range was
-					 * zeroed, so just continue the loop as
-					 * is.
+					 * If the folio was not removed, it
+					 * was split. Retry the scan to find
+					 * the split folios.
 					 */
-					if (!folio_test_large(folio)) {
+					if (folio->mapping) {
 						folio_unlock(folio);
 						index = start;
 						break;

-- 
2.43.0


