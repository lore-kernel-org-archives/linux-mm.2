Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 022AACD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 12:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286036B0099; Tue,  9 Jun 2026 08:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2101F6B009E; Tue,  9 Jun 2026 08:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FF0B6B00A0; Tue,  9 Jun 2026 08:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE30E6B0099
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:05:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C8348F3CF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:05:04 +0000 (UTC)
X-FDA: 84860243328.10.1E0E2AA
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3ABE4180008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:05:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CXDXQgZI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781006703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=k79YIo8QOQKsrDYvlKnWPNsBhiUhq9Oggnh1XXaaAxw=;
	b=HCLZz9ZxQknOFWg+BohhV3bBVbNOqx+Mb6y08afUj9hnqo/vtnRr0ieD4thtJgmWspirdm
	m9c6NvoN9UxovwjD+2wlbrmPmJUTuxuf5Nv6fhsZLsqnx1NoYZF+XToV1oEyfEGa3gbZvf
	MofzpQ4uYaC9LHSz0jcja5t3DpEc320=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CXDXQgZI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781006703;
	b=Tu0vNCy8RNhpn4YfqjwzktqkqYtRCqJUMzKNNsIVBlTXeEJXEHdOgVO7FppQObEdAQPRfD
	AGppYRLdegVT0W6u9sSqFRqC7h5MbHrtA3aRmg7NLc34ET3WwLMb1m6mI2QdWIHz3gINuL
	RbInguxDrth37fu5l1nGASLAwGWhNI8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781006697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=k79YIo8QOQKsrDYvlKnWPNsBhiUhq9Oggnh1XXaaAxw=;
	b=CXDXQgZIWnWZQFuZNeFWGtdtDAqIJpkSM8/sATcbi1GujaaExCPIkUnnO6ZloTfAN/KaQj
	DoxtVhMY0sY5/G3ZQAabDXlsLPQVqmu1n61wmSwOn7jjH4A44LCSZAAVzGJtuaAjg0Bv9N
	v8+2eO/Ir0zTJscfgZ1FQD58yxyw7VM=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap PTE accounting
Date: Tue,  9 Jun 2026 20:04:43 +0800
Message-ID: <20260609120443.71864-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 9msmbibyjga4uinsw18xx7koc314gq8s
X-Rspamd-Queue-Id: 3ABE4180008
X-HE-Tag: 1781006701-901181
X-HE-Meta: U2FsdGVkX19Znkc6yX2bjLmfVVo67AcAAMw4CC88AHVKuhqxkIvtHBgibqRL2ALsC7tOj67lEhy8hYuNZqVfIiz1iGv6twUxGhiIy2OuN5pACwiC7ErHNxnAAQT4ADqWVPNlCTa9ULCOtWEpi6vFEUoyMauK9Te4x4bP3/PogK7Wz9eULE+h0N4YtG2wpy4e2oWlxBhEwMGcQptZPjSKShsXWruftpHeOG3GeF4I7ABjLxptBY7C813Yx9Qyd/yGvF0u6uswAdCw3yZzNxdonxWKstZ3gEr8+y9rWwmjW0eQbDKTY0AFZBh4t1i0iq+sPE4TnIIuzXfcFxedboo6qWgGGC/yB0tKEuR69Sy1TOHJksFj8jVF6y5xKMw6yVSqzovTjf9J6NVxUUPBDj9La0aq5PjXy7V1MgZ1XzJN3azjmcZDNW5oTLaQRdHHj3XzUtJwJDiA31uC23c+oLDLIozc5zptrnMzzL6c2UNQ6ifQD5b6ydS9JOdAa85aAp9kuqoK0xMGamTM/1zXo7CZnZeqQcdUDyVG+dmz2sTUxqZNt4M+oDvv1TTcDhAkZFvrXa5f3uR/AlemSd2eorJe0u1DkxCYSqBvQmzCnFVEmu78tX2RUsFud6m/j3XwFa3QPzKdyLDNgf9Xt5p1eB6PYIC2opslBkCnP/Zi6JdLhsQ5Zhf5NCPf092VH2JjP3vZ7FoS1vhf52cqC6o232Gik/y4RxyVWy+8aORxutWpm9badMlmgX79MF3E84q+iaHcRx+ykz522XwQv+vvcxpHQmSXAUfYA/mgBzcbW8jTRoHMsFpMKRdmIyIwL5mgDVCxM4TPrrnmze5yxmJoKmiuZ5g3cTG3l4EuAKpdiYvWW6qOt07C2NCWDKoKlaM2SM+JWmIyEm95j5POLWA+ND7+YwojHVyHDU74V4YSqSvV9LOnpcC+qp86h9YUUzM+b/Bdhy3qunTHDVg+TJ920wG
 mskeze2v
 yNa4wEAi03uHKi0s4Ur1ozbxPVN5YK3qhCRNfj+KgirtTQxaKt4x+ozrPD70QcJy8AXVTs/uEL0k96nKt7Qwjyu+JhC9Z9a9Ed5muOkerCyo83rRnxqZA9ie4X4kWjgFoKlabDTFnWpHYfI+U0pU63APDgMscUpo9rfqZ01zG0zzUkH93zPElbZJNQPTIr6T2t3jnDIDqBr5g8t3i9JLPQrxrurnkVoNyMQJySILg2Umwy9MJetiNWnkteuMBx5mYgxDnwreF7zL4w5M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

mthp_collapse() uses mthp_present_ptes to decide whether a range has
enough occupied PTEs to try collapse. Swap PTEs accepted by
collapse_scan_pmd() are counted in unmapped, but are not represented in
mthp_present_ptes.

When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_none
so the scan can cover the whole PMD and build the bitmap. mthp_collapse()
then checks the PMD-order candidate using the bitmap.

With max_ptes_none set to 0, a range with 511 present PTEs and one swap
PTE no longer reaches collapse_huge_page(), even though PMD collapse can
handle swap PTEs up to max_ptes_swap.

Account unmapped PTEs only for PMD order. PMD collapse supports swap PTEs
through max_ptes_swap, while lower-order mTHP collapse does not currently
support non-present PTEs. Keep non-present PTEs out of the lower-order
eligibility check.

Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
Sent separately, as discussed in [1], to spell out the PMD-order swap PTE
case. Patch [2] is still only in mm-unstable, so no Fixes: tag.

[1] https://lore.kernel.org/linux-mm/CAA1CXcD7WAiA1b9GTLAuNZ+kHaFx0SzZwpBkqAZ=s+RHsTUaow@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/20260605161422.213817-12-npache@redhat.com/

 mm/khugepaged.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b12187709f6d..617bca76db49 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1508,6 +1508,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
 						      offset + nr_ptes);
 
+		/*
+		 * Swap PTEs accepted during the scan are counted in @unmapped,
+		 * not in the present-PTE bitmap. Account them for the PMD-order
+		 * candidate.
+		 */
+		if (is_pmd_order(order))
+			nr_occupied_ptes += unmapped;
+
 		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
 			enum scan_result ret;
 
-- 
2.49.0


