Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A4F9CD583B
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 11:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C30236B0098; Wed,  7 Jan 2026 06:33:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6116B0099; Wed,  7 Jan 2026 06:33:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC1A6B009B; Wed,  7 Jan 2026 06:33:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CB5A6B0098
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:33:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FCD21A02C3
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:33:28 +0000 (UTC)
X-FDA: 84304957296.12.E0FBD70
Received: from sg-1-103.ptr.blmpb.com (sg-1-103.ptr.blmpb.com [118.26.132.103])
	by imf20.hostedemail.com (Postfix) with ESMTP id C37311C0008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:33:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="nQMFR+/u";
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.103 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767785606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9nSEirhy+0vN+k5rbIUt6cf9EJAt01I3/f0PFptLibw=;
	b=lvFYT8M9ZWyeIHrbrHVWQUvLgyUc9NpNZf0rf8kGkPTgtNGeTcWQCPLFyp8V0yZ+HSqSUt
	7rzMg7m8tIxKCfLCFwczDxPbWgutDytRVZGko8NAX9UaRCJXZ0Dy3mxBjmRmFSHPlx2yXy
	wKacLC7nk8yeUvLC+2Bx2BQNOFicAGI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="nQMFR+/u";
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.103 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767785606; a=rsa-sha256;
	cv=none;
	b=7gvNvizClN8GTAdg4VDLSmARpSLi0uAMm/hIVLfPFtHvw8I8WfXYHcNgp/iTbqvuPV1DAb
	YlE0ZM4D1ziZQp5BVgIua2CSH4oPaaa1h2tIVLjd3i2HMcjkxJ+l5ewO7c2M0hkBGEzSdN
	B2rc4IB10zmRZQReN4gUHRZNqqczXBA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767785599; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=9nSEirhy+0vN+k5rbIUt6cf9EJAt01I3/f0PFptLibw=;
 b=nQMFR+/upHHs3GBwUfVERg4tUQHXza9RNnduhAYjzlqRAKHSCZnprZdVKQyMuKC8yFEEC2
 hMY0vlh4koLqsh4nR//suZ9RlNWUqBJutdIkspBkSmdfRswn8nADgyWnjQ0GmBYsXRzFrc
 wSEsgjKkGFBfVHPgVTr02Kja8sK3RPpDn7mtc7aeM4AKxwotWKxHGIBrg+XgvrqswaivMn
 GzGw6tbl3XGABwytu2bamFrpJMGHzBPlqUO2A7fHBU+12uPcqdPatFIOkwBxQfZyf6ST80
 /HYItB1N3K63x51lcx9S+yaKuRswk3NN7INxWKEgiv6l5LY13l/ey7Vu3jntSg==
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
Subject: [PATCH v2 3/8] mm/hugetlb: move the huge folio to the end of the list during enqueue
Mime-Version: 1.0
In-Reply-To: <20260107113130.37231-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed,  7 Jan 2026 19:31:25 +0800
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+2695e447d+2d62e0+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
Message-Id: <20260107113130.37231-4-lizhe.67@bytedance.com>
References: <20260107113130.37231-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam02
X-Stat-Signature: r8qdp33quhofym3dj3gokc15caj7rche
X-Rspam-User: 
X-Rspamd-Queue-Id: C37311C0008
X-HE-Tag: 1767785605-900879
X-HE-Meta: U2FsdGVkX1/JGjWE9k1QzdAgo+IFcN80Haki+enyf8vx9l5X40nT5mrRXbsz0fF6/GRB7Wbaf29PZzBkakcJ2FBL2DFHDoyQq6gdg1wKIUHs1z1Jg+qXBXZH7KXeQIuzmShZdhCT6+p5XG42CR6tckoK8gfPwx1T27bY+5bmJo9zA4fDw0IArJastAfswZi7W7ppoa3Mic+BYuyF2P226pAeO0ZVXqAEeqi6P5ls6pP+EJ7UnD+YMnfauyEBJbi7O1KmM78Netml/mhTmQRSs2SY229h3uPAqzb+CX2iwJG4ztccP52yqSRPf8+BEyd0WroEPfimBd8D+Vn7qB0NF0JCCz4paH0KCdhpy/TusYktpLkq7zNIFuCluCw8EccSfZdxdSoAuhlLmXyMkZBnICRFLxMt/gH1JrZZYdqrthtvwd4JiV+9aont39FUFoKstfrJB2Zrq7GQhFDGAZD6GC0cGh8HE/niABN95IrWiVxakguG8wv7NmU1F6Ic1KuVN/Rx+7anAp/Q7tQilhRXmIjGvovfHu0lxP7x2z9FMAoyzZvnZWSBz+0JMH/0JVIEyzNYb2aTrgnMeLSnTV0xDOkftFHw8MksNcMRoBJgck4w0A/rLfnDIUbgiop7S1fAfDN0gz2fOLDmUO0LZup10/DcttLIE+7As3ZLKeb5XaQ7E8vM3pfT8Bvo+RbX93WGHG65ZeiGhM9njJvXqvelI/bVm0VBses10OOx9f59cvks3F0+BrgFxJlQMlkzbztbJy9Reail37ph5uERBJ3yhj1o45rN6ivwMweGg+yRq38UxySaiC1XVGsTPEiGe51NfJrEjKf6mjT9Knz0bMFELs1dvePLe9s0er/jSw8SRHSf1A9J1YzD0CUt5k0/3k2h5i5ugO/Mm7HWWm+BT1tmwM9LmZlOILcFTEbAwbaEylWcnMMrlmeRQQM5fTE2iUCsK6gY7zGP+2Au9iUwFcE
 papsAN/I
 mNbSnea+b/ffLG8Xz6UUS7xoLuwJDD4NUkNxhN0Rr1OZIlCPGy4WPAcUOgz1o4Er9drn0+SivVGKCVOXn+Ub5BqvGFCph4/N4D3YrG2vaQpGHTDvNXumPNt4o0hzNQCcOlMAcxAG9U8sl2Wbp2loKb/d8aajqhKredcjYpMhpplwGBunwMQkgOkxrcSvgNzHgAs+Z9k6fS7EUrXLNe58NQ4m72SlfY0mUhQoMNcpoVAMq0Z8JMpdDhVVibORKKTPi1czOiKj1bdhyfGfWpwTpvS5PJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the huge-folio free list, unzeroed huge folios are now inserted at
the tail; a follow-on patch will place pre-zeroed ones at the head, so
that allocations can obtain a pre-zeroed huge folio with minimal
search. Also, placing newly zeroed pages at the head of the queue so
they're chosen first in the next allocation helps keep the cache hot.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a7e582abe9f9..42d327152da9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1312,7 +1312,7 @@ static void enqueue_hugetlb_folio(struct hstate *h, struct folio *folio)
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 	VM_WARN_ON_FOLIO(folio_test_hugetlb_zeroing(folio), folio);
 
-	list_move(&folio->lru, &h->hugepage_freelists[nid]);
+	list_move_tail(&folio->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
 	prep_clear_zeroed(folio);
-- 
2.20.1

