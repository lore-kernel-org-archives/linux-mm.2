Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45A56C88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0256B00B6; Mon, 14 Sep 2026 08:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590586B00B7; Mon, 14 Sep 2026 08:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A77A6B00B8; Mon, 14 Sep 2026 08:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 302DE6B00B6
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:32:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69A42A03EF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:00 +0000 (UTC)
X-FDA: 85212304800.20.B689F91
Received: from mta0.migadu.com (out-239.mta0.migadu.com [91.218.175.239])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8A92E40015
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uEyKTiMb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.239 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389118;
	b=XFmPMJd2E9N6Iajc3+GSmbsmOgwOvPK0l9thSe/MC7K1knVS0SjysqiL/lOdWCH2DaOe+q
	syKtCTXNC9wzrTQx+GOkKuv8SS7ITkgOMfm9Sn9oynulBwLieFMc0hOFErhRKu9Avlc+ya
	aY4TqReNNlV4rE4uYD8RbYgvYgz0pfk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uEyKTiMb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.239 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HLTYrJYceauVb68wySayATZIcGvYhDhoDRuO/oujqfI=;
	b=GX+mr8PiQU9z8LlN891uz96dV3XKO/otjD9aQ6R/DUP+Y4V3uU+lIHWeq182FmPD3deqRo
	ZSNra+/x1u+YxXbeBuU4SN2wg9DdI4C77qfWqUabWz7xJMGtvAsRp2MrB1TWp/jCkzdBcJ
	rm8VrDli0qIBEqms4DV0t+gGTJKA0tw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PmpEBPMCGBePeR65tGhRvp39CU+cDN/bw2BxnAbshOU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389117; v=1; x=1789993917;
 b=uEyKTiMbVOQsxfB5LM1BlDCYOp9TEwNiqPgtOq25vX+38fwMcxw8NylpYUPA/Lgg+OCWhq0q
 +QdlOhLfT+74W4vZxnYc5ca/Db3GPZZ03pvu2PhRxQmK7k5o3B02f+uVf1EiX62F0tGOcKkFekR
 bYyai3hAeAgTSxl6UxxNQRJc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id abc9569ad6a47579;
	Mon, 14 Sep 2026 12:31:57 +0000
X-Mizu-Trace-ID: abc9569ad6a47579
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [RESEND v7 21/29] mm/madvise: keep PMD swap entries whole for MADV_GUARD_INSTALL/REMOVE
Date: Mon, 14 Sep 2026 05:28:11 -0700
Message-ID: <20260914122950.3283997-22-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8A92E40015
X-Stat-Signature: 4c8zo768uj9cx4jxmac5y7p5pq1hdu16
X-HE-Tag: 1789389118-239888
X-HE-Meta: U2FsdGVkX19QecTueHRPgX/fYAN0gh0vZv8N4Q4FGNg5sbo4RVMq7dnp4PVTyp/FE6iPs0/HioNCxWiyxh40pDiR2TG1clvR3gelmOaMdv9SJrFUc8BzyzEdQ0/un24c9cA87485P5hC/lLCGKzkRnY6ELUSciJtbNXruYvmmX95T8s+PxT6yRNVsNIw3maib+e9xIoybcBWKPsWtW9HqTODtYX1V9QkvrQUc0U1kiLQxBmZzm9VpBE4ohEa/KZ4yfQWyEyPyJ44bLaktfQ9gU5I4DjkqbevidlnaJIHSJLSVr3/HmKXcwnbcnK58Zt7N754Ugvh79mqnsmxNGs7CYuz+qtZ7GCKO5qjHwMiKTvV+FKzRmbzWl1eyHteDlgH0KuRwDL8Z8Zj0FQCpJIDRpGTEle6i0UDyHuaUdXybPkNmAgXESXMtaHuxmqJ1kOMwkThHfD0U9JD3J3TmKOF5ePrLGzQpzx8eQWjHReTC0MklRQjjD0d8V1YUyxgD7kn3xxxlRT5+11ULonfBn4cV2u3ZmkKfPLy6dUL84a42icnCQgHuv3JIr8SLAKLyN93kJqCnqUcuTQq39YucxMKz+IoG1uDPJIYeHA7f2DAqMV251+I2ikISCpKtPbEiADTwm7bNSMkYXJV+a+XDE6p6GB9/vxXLF43nmhBa48Pku9DnEhW06Wz2PBC53NS/XljQkjpEe//znT6Y5JOG55Oh0wamvFz+fBG64DvniSHOVFE08TLQS/jvQCxOp2+w4ahTIX1m/CTGL1b9s9lqlWzIpwEe+9bsGYPi8iF4N3a88ISJAxuVQFdUVoYOSOoAvMYZy40hEP/qyV7LgkWYe6GEmDoSyMkheKO5/u0off+wkasEkh2jYpyNJubRdH2D2CKoQcbzGVvLvXxn2cku+EABx9uNl/93aau6wCq5nxv2LQvb151c+cW8lGnxroBKHMUrE7+pMaVafW6E2dkArF
 B9IX4QWL
 BVE5sdzALoNfe+oCvUrPPbSnHu2SsVpiZAKfL9ylb0fSZ4HGM2pV9ugAHHuoyM6Paiw4xiTg4KZJLAKZSntnaljU9jp0LZAMATHdMIJZWe5/coB5DhS3WP3FFr5KAiXA140Tnk6j3jIR2nBsS7IxjV/n/aVLLW82KB/CZlSJq6cZCZkcEWKUoCNAqVhVSE1CEx0AuiKNfoXSX9rIo86Ci+0eJzjA1APl3UrFqSitYPzBVi7yYqHTMUOuWbp3kx7uVLy0dxJTZZHXp+d6gn+BZPuq9Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both callbacks test bare pmd_trans_huge(), which is false for a PMD swap
entry, so they return without consuming the PMD and walk_pmd_range() splits
it - only for the PTE callbacks to find the range populated and abort, or
to find no guard markers and do nothing.

Both already short-circuit at PMD level for a present THP. Do the same for
a swapped-out one: it is just as populated, and just as free of guard
markers.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/madvise.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index d3b5ed7e3cffb..64019668d69fb 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1269,8 +1269,12 @@ static int guard_install_pmd_entry(pmd_t *pmd, unsigned long addr,
 {
 	pmd_t pmdval = pmdp_get(pmd);
 
-	/* If huge return >0 so we abort the operation + zap. */
-	return pmd_trans_huge(pmdval);
+	/*
+	 * If huge return >0 so we abort the operation + zap. A PMD swap entry
+	 * is a swapped-out THP: also populated, and splitting it here would
+	 * only demote it before the zap.
+	 */
+	return pmd_trans_huge(pmdval) || pmd_is_swap_entry(pmdval);
 }
 
 static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
@@ -1409,8 +1413,12 @@ static int guard_remove_pmd_entry(pmd_t *pmd, unsigned long addr,
 {
 	pmd_t pmdval = pmdp_get(pmd);
 
-	/* If huge, cannot have guard pages present, so no-op - skip. */
-	if (pmd_trans_huge(pmdval))
+	/*
+	 * If huge, cannot have guard pages present, so no-op - skip. The same
+	 * is true of a PMD swap entry, which must not be split just to discover
+	 * there is nothing to remove.
+	 */
+	if (pmd_trans_huge(pmdval) || pmd_is_swap_entry(pmdval))
 		walk->action = ACTION_CONTINUE;
 
 	return 0;
-- 
2.53.0-Meta


