Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A9E3C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A336B00E9; Mon, 29 Jun 2026 10:42:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052D96B00EA; Mon, 29 Jun 2026 10:42:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAADA6B00EB; Mon, 29 Jun 2026 10:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B26016B00E9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1278D140134
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:54 +0000 (UTC)
X-FDA: 84933217068.08.513CE81
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8A7701C000C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pBdoLaed;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744172;
	b=vjHHKU3RnbHLhAkuCbqAI2pSPTiBtLfmi8Qv6CtztHNMwOxFiPfvq+F52jqkacw34waIdp
	VOfmHHTeZxEVBTRbr9D8eJJAOAYoD7tqV1hbEHvMlGM0rqyRtKMIGP5ljTNtQm/IyZscIQ
	u9+cTrO8QVy25QJRMbbq7glpECrg3Sw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6dWsdmUf7ylZMz9/kx/ayCZU5UJ+5FE1mY/hNHUuYY=;
	b=RYbqLRrpGS69MkPba0O1g2/sSTHli1Fu87NXU6o2NpjzAsrE41OpoRDHhEf5XlxZ0RxI+k
	TRrVTi8p48+ZefKe43USGhaCK+TEamxCrcJXaV43PO0Hi9pH4GKN1PKjaYtpg/eD9ewnm3
	FzqpQIrB54aPF0YzM4dyjXa6HBdKYSM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pBdoLaed;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=H6dWsdmUf7ylZMz9/kx/ayCZU5UJ+5FE1mY/hNHUuYY=; b=pBdoLaedvvzM2zY1IGOrfYPJnW
	rc4cMTP3BQzZNpHO3f4TwD8ViN2LU1m2G7bIssNdCmaaRfQOKY88AmuKd4INkaVi4RhGj1AdWHhhi
	BH5uXYb311I31dPzQCiJwqI8j0ovyq4Xd6rr5wlob7mq2xhg6AtNEvLtI03pHAoBq5rwVWKwkGL36
	fbnkVNd53FGIMZFFBQN7NUd85hqk8xGrYcAgl05BMD0G+v2MMDhF5cl0fLdgTGUSBKs5ILFiTg11B
	wEqqJJJZ+Pr5eKVMh7uNKx/Hv+hGEopYvPhTudqlo8fQWGDbxWBpqxZw9cwVAOzz3DmFA/aMuBaNL
	N7DDL6Mg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDCF-0000000Eudm-1h8Y;
	Mon, 29 Jun 2026 14:42:51 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Chris Mason <clm@meta.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 12/18] maple_tree: Catch race in mas_alloc_cyclic()
Date: Mon, 29 Jun 2026 10:41:39 -0400
Message-ID: <20260629144145.1572283-13-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8A7701C000C
X-Stat-Signature: 9sendbb93h5zm3gbgbojx1ud6sci8x7d
X-HE-Tag: 1782744172-455183
X-HE-Meta: U2FsdGVkX1/sSVTBrVoDrxrMyD8XpnO0i+L5jI0le0p8Ka0S9+9awec28Jxh1w3b57JRAmCNGDzeG3AZX/uPtDxmXRUSnm3pQBGvkG/yYEPcMePyM35NDrwH5IogtjsF/e3t/veQegNi9S5wRlsSCvCWfS6e+z1jTbog+fAJoKDHkRvt7PaH3WeuTZxj0k/izaYtozzgu/QQpV28ESx9UK1h9Rtz2cZS6Kg4CcGhCBIV+UyZrk+dtM1jbcb2iKaYLAcXsEvBgXsipOmkC8XA1j+rFlPcsuk/DUNvgy1WJO7k0lESyCCNhjNLhXKpgcLX69blhGoT9r78/tPBHO3vAPjjy/9ch/mNYXbqPde5Rq8JC2DmKrSrNW+uCu0mH7RaRX/plz7TnDq4g8ezE5t/XZIYHk0yA4xhP5Gus804R34O/wEyFY0xq16jfGxOoQXzJ42pL4x9YBBdGKMH4zgpRG0gCm3YBAOMqyMyiNVd8QlrmLmA7wmanCL4FqcLrsJ4m5AVohWheD2s8yT24IMD8u+W6ufpRLidO9KGANXFraiPcD+b9Buc08HnNjfuC254L8P6AsIMbAi0JDNbs0c0TJAQUvLK8a99bC3awuYtsUvAV+eBm1fyeFJakPPRCLqwYzWs5QpqFH3ix/Wih1/quPazJ7EIVSEXOG1GUHb3wus8SxZ9aP+aWqMuWEKoFp20cxHKHGGZ7kEUgPccZ1BecFZS+DFUGTZyU3b1qJPYaMdVo0MWG85Arikf8elGAD4E0QG4wHfx4crs3UUXZvtGJtMBJ3SHnWM++m7e0qzsyACKkgN9JsjOkXxewfupQZ1BLp6VGPBnVD8qAd8WJgK6B0A9jD8Ztmu9s/xl8LcZd878Z+jALYD3YjctIzDZbpyzUctnW6+vq5kkjFugSvt6PSJzNk3PZskDATrz3FBiRtdAUmiXvfk/eXxpSgsytk+Uy0QAwyYzz/cwlTO4joU
 FE3PT0qG
 STULr3XATOQsbcdDAIwZ5OeqVBXkE8kIG3HTlsgi4TpWCs6qT1OuncJwTzVXY5CEYaP8alwSpp90D5SUEkQLwauTE/8IVFhUkeSrWrsKZf14F5NYDuc47mIQ7F6ygug/uXKUbp/YQQbRZYuWVOvEIAV8+8xTpbbII+KlIKxsn1caPuf1NvxylXuBJvPIHF1P2xo3qbiYBImapmlJuYYy7EVr5iBxLaB40DbUkt5k5ARp4we3o9J1YOsIWMllRuVkK2jL0BoVZO5w1PeygSyeOsjZ+g2yzRPxk6Ouk0XlYAMecZHNvc4J4Y9esYuKgFBXr/WgqqMKzXx160XDHz5u84OmdmnNSWpumt1abT1DEhfX5077cb6BfLxowjBTz6eCiGd4AZvzEoC6IvS2IX5Av5eFHPPOlOftT0EMNrvshWbBb5fQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If mas_alloc_cyclic() is called during a low memory situation, it is
possible the lock may be dropped so reclaim can occur.  There is a
window where some other task may allocate the same id and cause the
mas_insert() to fail with -EEXIST.  In this scenario the function will
return -EEXIST, which is not expected.

Modifying the retry on mas_nomem() to re-search for a slot means that
any race with other writes will not matter as the lock will be held
between finding the index and writing the index.

No existing users are exposed to this issue.

Fixes: 9b6713cc75229 ("maple_tree: Add mtree_alloc_cyclic()")
Reported-by: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 6531a2af338cd..67cc480534e96 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3900,27 +3900,29 @@ int mas_alloc_cyclic(struct ma_state *mas, unsigned long *startp,
 		void *entry, unsigned long range_lo, unsigned long range_hi,
 		unsigned long *next, gfp_t gfp)
 {
-	unsigned long min = range_lo;
-	int ret = 0;
+	int ret;
+	unsigned long min;
 
-	range_lo = max(min, *next);
-	ret = mas_empty_area(mas, range_lo, range_hi, 1);
-	if ((mas->tree->ma_flags & MT_FLAGS_ALLOC_WRAPPED) && ret == 0) {
-		mas->tree->ma_flags &= ~MT_FLAGS_ALLOC_WRAPPED;
-		ret = 1;
-	}
-	if (ret < 0 && range_lo > min) {
-		mas_reset(mas);
-		ret = mas_empty_area(mas, min, range_hi, 1);
-		if (ret == 0)
+	min = range_lo;
+	do {
+		range_lo = max(min, *next);
+		ret = mas_empty_area(mas, range_lo, range_hi, 1);
+		if ((mas->tree->ma_flags & MT_FLAGS_ALLOC_WRAPPED) && ret == 0) {
+			mas->tree->ma_flags &= ~MT_FLAGS_ALLOC_WRAPPED;
 			ret = 1;
-	}
-	if (ret < 0)
-		return ret;
+		}
+		if (ret < 0 && range_lo > min) {
+			mas_reset(mas);
+			ret = mas_empty_area(mas, min, range_hi, 1);
+			if (ret == 0)
+				ret = 1;
+		}
+		if (ret < 0)
+			return ret;
 
-	do {
 		mas_insert(mas, entry);
 	} while (mas_nomem(mas, gfp));
+
 	if (mas_is_err(mas))
 		return xa_err(mas->node);
 
-- 
2.47.3


