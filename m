Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9314CA5FA5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65266B008A; Thu,  1 Oct 2026 04:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C15DF6B008C; Thu,  1 Oct 2026 04:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2C1F6B0092; Thu,  1 Oct 2026 04:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 921896B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:57:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FDC6A033C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:57:40 +0000 (UTC)
X-FDA: 85273454280.11.E3745A3
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by imf08.hostedemail.com (Postfix) with ESMTP id 602CB160004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:57:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790845058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=iM66IWU8foJ9Ijso0JahOxRJ2bZG5DAINtvf8mKAWOo=;
	b=HbqgA1VTitCu1Y0v8Cnc3w91WHKBjNdpO6b8ngBnSVjSHOHZ/loezCrVLCG138v4yX6x19
	/F3JGHCZAYLtGI2lUTWGj5pxQqjVx0TtmPQXkOD09N2380bZx4JOsg1DN/wI8Ly+tY/1fK
	m3BHRdiSHo44UN4M3Ag78myopbPzHus=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790845058;
	b=vV7kaiS8Z8hU8032uwNHPvkQWtfM3dVDKf8++ZAh/kSzNyhMAZ8F3HeEkPlxCkCbXOmn5w
	ZYZ/NanqELCfEoWgUYLjlxpmEhGZ8HKXG9jYjwMFaPUE4dQb1WslF2lTDFmjpH1BUfl8qj
	os1xqc2Mu0rf1bQ/qIMwYPVgMgHemiU=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 2BD693EC12;
	Thu,  1 Oct 2026 08:57:32 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Christoph Hellwig <hch@lst.de>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH] mm/swap: submit the last readahead batch before unplugging
Date: Thu,  1 Oct 2026 10:57:12 +0200
Message-ID: <20261001085730.2029773-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTF1ZYRqrGBHftE47xIW2kWpWI6gPPZrBB0Fm2rHvUXkYYWGSu9bNQ4d4HVyhDy/NIybAnjmiF6pBYixger2QutfBbU4qbhWgGqzRtaP73q9SQvz845UU72nXpi2UucOwghImYR8IYwaxIE5XH8XU/uXkuVbcQdBHyRcTjmdcGMygMcxvXMBtUX/Cg1pSgZ/wdXfFSVnOvGAji3SOIoQ1ozVEoAUSRjGrg+FkZhEQmBDIdu86mBkTKSZMz/5l2OLju48pks3Mzo4LlIalkOe+F+/vvhT9lN7Jk6nolKAiNDPrC7oiqNr1sfRzpu1z8vMb1S3hwqE22s5+3cMlgLwn/ZgQNRdDN6XnTTIkeVd2IBSOhGN9XEwPa5zd16NTnqn/F4vQfm2E4s1hI0HbcT/OgNGCgEEu4DekqyUUC+afl/R5E5zSJ+hzpg5PZYOjYcAskn7JGUYT/ADplASg1NaL08u36yxzNaaspa6sGziiFeYiEoEVte4zhuCjbspW8zF6t8ndEc91NrxJblqFzHiHTthf8wCtraXcn4Ixws7xfMqu1OIhDUsGRdoFB7tUOLfRgB+BwXg2WZEH9D1YeTMReQNYmhFIdRQQhSquGcuL97ZKtNQQ7IgZhO3/XJEm4yGF8NSn6sTxXNPt7xHZLX+MBPbVpt4K5rxTGudeYQYRAfNdA
X-GND-State: clean
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 602CB160004
X-Stat-Signature: s8zkhzo6x4p8ctwswp3g7kgkxahhbkps
X-HE-Tag: 1790845058-84452
X-HE-Meta: U2FsdGVkX186bJTCCl9yu5MzlP3yZ4+8AvSIWAZ0t+wtsLcYQP1NXZZFU3VJ+seweKuFIZ1jgLCgJnZTW2MthoCloe6qFw2FY+6ZecVVr6ahOIX4MXlHfNqfZXJC7THbkqkuY2P4trNMkt7Or5+8FJyMIfZo46jE4Cgd8ukNXFHV7B8yhgO2Z258lcZql3qwrA0ls7ywgWMUpQY/Kp2UwBwUVilR5gX+0hnW1W/FAjL/9B0hKXAIus/JXeVz/j3oXTTKTVn64DAukrr34dMF2Nj5HWS4+0A2tFbS718INEhG3IDQKnVAynCuSGOvshbMxJEwCrMJg6RlDB3WGlZBZYjFx0BVR4Eaz9eiQIAx72G8QaDXYBoEKACJSIt6Y9yXQ2pJhNc/HBjxuz6zzYBxsGDN0lRtgA6e517wkvp8wXqo7q5+IY02i1tTCLBSY+4qSsBJnziU5Jm1hWhAnkJrVJeW49QMr70Tj8X36wlHLGenBQQT8EEBRS5A6vdie+ovD1AYFStjM5+NmY9ook4O8yDB087lWAZoXmXRQrFYe+IivUWmB9N0+lu6PiZR3EHCPpTh52lrWUyJIzvs5wsy1txRkdebM3iycx0Af72HP6TKWf5lf/opovgxrVxUbqlgqETNAldM0n07GmJVEAQVwrXoCRH15/k1poagXBJZ7RSj7dFjV7dV+ephmZXn6jwMViAFNNHZSL1wVlJl3s67LWaCF7/MbBlUBwqPMzk2kUQDfrrHe2dVb7mCpfe8jyMJ9Tx0xKsX0B32AO1S6N5sqom/8Bp5PxC2XRcxqRECfjyJFL4EgyriSJ5/iH96iZRlsORz5dOoMYBmXoeTXJdGgANnXtRT4aX00JdQU/mOeqgOp5aHFjfAXoO36zJtZqyk61NHK1Vg9U7d6uMy8aGU0vyx2d0o1tjyhIKRCdJO6fkmx+9qYsK4lI/SQR3804i5NZzHtP2PgCAKTHMiH9I
 vw0f54Lm
 z93O/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since block swap I/O is batched in struct swap_iocb, swap_add_folio()
only appends a folio to the pending batch when its slot directly follows
the previous one, and submits the pending batch otherwise. Batches
submitted inside the readahead loop go through the plug, where the block
layer can still merge them, but the final batch is submitted after
blk_finish_plug() and always becomes a separate request.

So submit the final batch before finishing the plug.

Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swap_state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 2475ba29126d..ebef568cd62e 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -906,8 +906,8 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 			continue;
 		folio_put(folio);
 	}
-	blk_finish_plug(&plug);
 	swap_read_submit(&ctx);
+	blk_finish_plug(&plug);
 skip:
 	return swap_cache_read_folio_sync(entry, gfp_mask, mpol, ilx);
 }
@@ -1019,8 +1019,8 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	}
 	if (pte)
 		pte_unmap(pte);
-	blk_finish_plug(&plug);
 	swap_read_submit(&ctx);
+	blk_finish_plug(&plug);
 skip:
 	/* The folio was likely read above, so no need for plugging here */
 	return swap_cache_read_folio_sync(targ_entry, gfp_mask, mpol, targ_ilx);
-- 
2.53.0-Meta


