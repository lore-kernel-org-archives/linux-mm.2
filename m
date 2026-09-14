Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F31A6C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4726B0088; Mon, 14 Sep 2026 03:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D869F6B0092; Mon, 14 Sep 2026 03:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74DB6B0095; Mon, 14 Sep 2026 03:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9516C6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:43:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CFBC6120BF1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:43:36 +0000 (UTC)
X-FDA: 85211578032.16.11D9C97
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf27.hostedemail.com (Postfix) with ESMTP id 24D6F40008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:43:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=St45ENHK;
	spf=pass (imf27.hostedemail.com: domain of louis2665573906@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=louis2665573906@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789371815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nYJD7VTts/AH4L8FmbbSGUiWjAUaPCR6VveqwEnLy7U=;
	b=4opx/SucJCxRg8WEnyVUfgnyQO0uSaQ1cXyv/EbkAhqglhsGCF/vUzBiQ8nEyyBDf5xw9C
	HwmfS6g7HdaVBfiNisChtqPn23mmyTOJ3E01LHT/QlQ+na9YGDeZ0ee9wcnqkKAoGvYs1d
	c4Uo4MWH89ytGRKIHhsjZnWPhwP+Ap4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789371815;
	b=UyAUb2fWKYO53rl83KXIvHLWotTpdWxCd2VX84N10phXOuMQuPPE4m+ms+nnu1MzSr7H6Z
	KYwV33CgEX9LDiXOFLtn4ho5zBzfnpbJgGkQxBwu8mStPsj6B6I7lIrrTgH2Yj1nz8fzWQ
	IWKxcXsAxrlvTFnKttEnm7M8qBQn3eg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=St45ENHK;
	spf=pass (imf27.hostedemail.com: domain of louis2665573906@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=louis2665573906@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469b355ffso920383b3a.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 00:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789371814; x=1789976614; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nYJD7VTts/AH4L8FmbbSGUiWjAUaPCR6VveqwEnLy7U=;
        b=St45ENHKhAI5rPQGl7IgiofNCrub6gQx1ruydZeHx3X6iZIO6I3u0wVerCmSXwsySZ
         rShE0XknHJk+H2fCSkYz76aU2oQVkJP2sZtHbyj98Im0smCNbNy5LZW9qlFk07LcN6CZ
         ZHE1E187AcNixHXHrglb93Rl2FauMC4oEzxbl9wPaD1g6kGZqiTL6wz0+4Gqr6cOdH6s
         rfWYXihXakT1JoBepOwu+Olvp+Zy7ZGDYI6X2dghjErqM+BwhNeHaFmVkFRGY1RSUDBl
         pQrHCQZli7TqValrLJAKqIR1hPp28vu9Upnq7bEFZ9SVy2r0+NyjqTMicdjbUEIPcPUu
         3sOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789371814; x=1789976614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nYJD7VTts/AH4L8FmbbSGUiWjAUaPCR6VveqwEnLy7U=;
        b=LymQ+BVDQtjUPv0DGVcHdSOz46uERBhDfOCcb/QA7/5yJjnxkbOtMjOI/pGxkLuGqM
         n5uIShmHTnhWm3pPoKwZdBM0QQtJWSjQCks6Ay5goTAl5k3a2DWXpsQNTuDVxz83GMAO
         d9DKhOcgYmjgFlwq3S4mKbDALr8j80BsaW+XAtA6JDIKPLDb5AnagDx3P2qLxupIh6qP
         Ln5XpUzT6qPw0t2NFu9Kd5U0q9BtQTkZ8CEcZXREz88B5D8pMDtH421XPLnw1ShuqbA1
         Ckn0BzdWPie34/mkiJtCIQw+yJ/vNiDtjU653dItZBVnIK3O7rgBc74DBnpxaP1vvOQv
         5qfQ==
X-Forwarded-Encrypted: i=1; AKwUvBxsIxMRwok/H8bJ7ygQKPPff/ipOU9pJsUf3w1tLiM3CiUfAAl37gwAL+BES28bfxV/fRFO15Q0Lw==@kvack.org
X-Gm-Message-State: AFuF++mxxVmFoerNDQk3sNjHJ9A2KKzBdSFt6VpQh006jkgLhAPzBkh0
	+5KnKFdC9vQKCelYTXuxfs7+17/TesWw+3H/PDfGCSxuctjRTpBNWl7k
X-Gm-Gg: AYBFou1u0qMKMLmhmVMfuiA/khNQMBAeikIdvNxtJOrZtsrUFeQ08dgxHoSU1OASE0T
	qIyjhsOpaZjR7n3NTo9dXaTRLDrPkiNFUADjkumLGX7t34uJLRto2z+VbuYL2AOi5Ji9sRwXtQu
	sEWUy4KtU/xxc6xkE8J09TVHAolzinlt61e4EENfODvWUArN8q5HPT4eSrxwVP1GPQRdLDTO5XS
	1JpGuuW4ePOlcO+fJ/a/z2MBfz4eCapGKOmWdWLpFsQ8WjidouQq9TRBBhSRIvdiNZGt8gmIkHA
	Rs5T5zY1w/ZxRdmF6GgHqXrQwtUck2PeEXYwSlyo0Qv9OJ6KRyhsz4fCeAErurF19npHsP92NAb
	0xqbzHINOPt7uMXQdoQ1UJgdn4JY+9xT6KQ6iWt/TX9ya7NZoTaMZrTYelsD4NgDp0/dxsNSDld
	BLsDd8UH8hJkYKO2vpDYxbwCpRHNiXLMlVL5OYoZqBNMkuofj7KFukLCdV3JUHuu+VaAMZTYA+2
	ca/xGaPpdLPXWByvH0Pi3ASNqGlVWQE+gDZ4xc=
X-Received: by 2002:a05:6a00:4c9c:b0:85f:b00b:8760 with SMTP id d2e1a72fcca58-86f82a5efbamr3533434b3a.5.1789371813846;
        Mon, 14 Sep 2026 00:43:33 -0700 (PDT)
Received: from a317-tower1.tail2eac45.ts.net ([59.72.109.34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b250c544bsm4088751b3a.1.2026.09.14.00.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 00:43:32 -0700 (PDT)
From: "Zimo.Lu" <louis2665573906@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] mm/memory_hotplug: use public nodes for migration targets
Date: Mon, 14 Sep 2026 15:43:22 +0800
Message-ID: <20260914074323.3567923-1-louis2665573906@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 5uani17um9h7xm45mj3onf1fbuo3ga6t
X-Rspamd-Queue-Id: 24D6F40008
X-HE-Tag: 1789371815-729089
X-HE-Meta: U2FsdGVkX1/MDwaW5TMpNULO+zHFdP26tZrSQYeGKENAQ5zSr+KWtt+JZl6G9VpmeULLBur9gui2BglAgrGzJAhBjdZIKtq4WXb2wewXsrsv7kgtO1Hv5yl9rg0Fs32Hg5krgdAakLXDyu09tZLI5bKYyJbeMBKEoh10dCviqr98eWjx0GKL6593rladajVriKUiw6cE0HYzZTHHhasB9jrMpsDHdIfG7+uSoTGaUn5r/bb4fZpl5U36cbvw8EugNOIjrQrm+xs9m4zg19LjU3rHgYVLL69HN0JRod5YywclFi0CHU04q5ni5qZryykwkU7bgyHOrFvP2Bkmq5Ii/LexWWW3BoqHmsc/ZjyVW5qynQF4riYA4/Yv/SQDhD9aPYZI7tTJYZsTWdZ7M1l1EXD3mps5rEDK7bFlvkx9r6oo7eL1o3Z8FEzNR1Y41kqu2/gX2PpCe0FPvuYYliiyA6/TuVGaiiPZEE2JZ/nlGqYi1CJPqqQla+qlRdA7hu41Ge71XMxvuNsbesZESkzIHSaetXj/KmDDtUKnuHtmMyOiMf54E9iKjqr+kTOoVi/g8W1x8xUlMK94k5dBBqMVEtucuPPwBT5GyUtlRPiBajVLpntKgvt0KYUNSWaLni4u5Fqv9O48MM9InD4xzPYUQb5e0KkugRAqEpv5lftcbftoqg4hOZG4TC7Du01uE+xuqKG+yZGDvorquexkqhLlOfFasycyn7OxLCd+7/uVdDC36TQWmnyvXChQMEY4l6IKqKUmzI1vn2PheVHVShQqcxlIOcxfEXLPFYqo+FiPWFQaPNjFlJNtgboZiS9Y7nxOZ/LIc0/1WSXxunlyJEb+OfMLbIFD/XND0i/G/buKpxRHvBx4uKC5CyZJOXQnbHOSSLYMxhtp+64js+joCaYdnw2yNnplvv3/TUAr+DWW6vrPbSZ6sQXJbqYxniWN65VnDtD/4/7jNGn+FuMAAZK
 w6dLyhsR
 jLg9KssZ8MRSLSRhyv+KqZ9kJEQcNQ7zl76rBx8dCKAEFHEg4ZUJli5HtvhvsFgByVM/nQuD84SCYaIo6U0bumsIk5qUkszV7iSW51MkjNFW0PeCv71yjHTmVMFlF4jRgMcrvMTjHPaQgIVbqWC5d1CpEDzxtT9K5i/4/MC8Z7H7bXOXYByt8Qeym41OeOg+3ZfUsGQIsmdk0Zrqt8I2zP+r05zjnZrDdrfqlV3q1AZHfAHO9/MLAFw3rO+WC10FofmWZ+PEKb8LAfsRPBwYea3FG4OduM2ILvD9rmlJCnVighJyi31toMP5/Y1Nci/KpBV+BofxQs3ghkVWKe0bZW+dZ6MGjuOnCeIpWOUYXnt1RwXj7pgJHt+oleOosBwDrBO7WyJ1FbwTwT0MDohp798MzUG4j86qXrBLCeHejmy6q/MAfxTTT7KctuhtbIu8qAGrGnJYUtOjwT5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_migrate_range() excludes the source node from node_states[N_MEMORY]
and adds it back only when the nmask is empty. With private nodes in
N_MEMORY, this can leave a nonempty nmask containing only private nodes,
when the system has only one public node and others are private nodes.
Ordinary migration allocations use the public fallback zonelist, so none
of those nodes can satisfy the allocation.

Build the nmask from N_MEMORY_PUBLIC so that private nodes do not prevent
this fallback.

For HugeTLB migration during memory offlining, this also excludes other
private nodes from the nmask when the source node is private and public
nodes are present.

Signed-off-by: Zimo.Lu <louis2665573906@gmail.com>
Assisted-by: LLM
---
Should we use public targets for private-source HugeTLB migration during
memory offlining as well, or should this fix be limited to the same-node
fallback problem on a public source node?

Based on the author's node_features_v6 WIP snapshot (base below).
This is not a patch against mainline or the posted v5 series.
Private-source HugeTLB migration has not been tested.

 mm/memory_hotplug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 22d20ee96bb1..8a95ba26552d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1937,7 +1937,7 @@ put_folio:
 		folio_put(folio);
 	}
 	if (!list_empty(&source)) {
-		nodemask_t nmask = node_states[N_MEMORY];
+		nodemask_t nmask = node_states[N_MEMORY_PUBLIC];
 		struct migration_target_control mtc = {
 			.nmask = &nmask,
 			.gfp_mask = GFP_KERNEL | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
@@ -1953,8 +1953,8 @@ put_folio:
 
 		/*
 		 * try to allocate from a different node but reuse this node
-		 * if there are no other online nodes to be used (e.g. we are
-		 * offlining a part of the only existing node)
+		 * if there are no other public nodes to be used (e.g. we are
+		 * offlining a part of the only public node)
 		 */
 		node_clear(mtc.nid, nmask);
 		if (nodes_empty(nmask))

base-commit: 38c7f48162aa282dc6a9edfb7011378594057c10

