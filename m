Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 878A7C5DF97
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23CD6B00AA; Fri, 21 Aug 2026 15:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD41F6B00AB; Fri, 21 Aug 2026 15:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75A46B00AC; Fri, 21 Aug 2026 15:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7EA6B00AA
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:27:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CF42A025C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:27:02 +0000 (UTC)
X-FDA: 85126259484.18.2A9DF20
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 81EF6140008
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:27:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NguBtBU3;
	spf=pass (imf23.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ndoP4i63wdabh88dsKMNw2v1ljVqTGEjtzg/L3kwkpQ=;
	b=rfU6iitZ9zeKUt30eoLmdmzzllnY/zMlEdM1Nr/hFzw0/pyTpKADIZnr6EeimrgAdLNKxh
	sWmgVOBcx66VSXqqlhQkGOW9lP8lwTsdqYd+mjJt9SpNSPx7TBCZEEkQkMnlF0fjv8XeSu
	eoyfT5J8xDEuhcc04MHEx83Xaga7wn0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NguBtBU3;
	spf=pass (imf23.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340420;
	b=tqA9XaTdakQoNJ7a+IiHp369zR9ycEdthfGPaeQrMbw1c2G0AvOmAx7sx/v20C3HNar+mT
	P/b/1D5Mj+lXCzs1jmEeV++AC5T6B8PFGGwzlA3xMGvhpBx/YZPiKT08VznwDyN5m9kqW9
	cs8Ug2oedkivT3OA6a62UyfIbwKOFgw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ndoP4i63wdabh88dsKMNw2v1ljVqTGEjtzg/L3kwkpQ=; b=NguBtBU3ldiCLGgAXMv57qEO04
	JInGROQa6FRKw2zUmjS9QicFWUdcNuFuWA69nR+HTDAd3OGV/42F0h2WKXr9nSi/txC064OyAEtym
	WrBoRAd7I9kFz/MhNNZp6A6TwzFgks3OzLlhbeXI9XQ1jTnIMQDiwKEWGb5r2Hy7RYH3uzkoAA5g3
	sWedWXvAJca5UZqnn8m1Se6qbtuPB0xwPkJZAXbiSDhx1OFf6NrumVkmGDC/FL3+s29uYYuhrTZWF
	8X1ZawAd7iHZBOOyfoSbWF64J1LXm7q+bRdV4PunQvLkHz6+SCeTaGg+AGrSXFmZYBwu4MMg6jFMG
	zxyZI/yw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUtH-0000000E0nH-1K1R;
	Fri, 21 Aug 2026 19:26:59 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Chris Mason <clm@meta.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH v3 12/19] maple_tree: Catch race in mas_alloc_cyclic()
Date: Fri, 21 Aug 2026 15:26:20 -0400
Message-ID: <20260821192627.4085470-13-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: goashajtskoaa9m5rcxowyi6kwkqeirg
X-Rspamd-Queue-Id: 81EF6140008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787340420-146605
X-HE-Meta: U2FsdGVkX185/sw0M3U4QGjdLcs/Cyp00mvmpqnEfg3rkq8BFyt13nphpXdAxqeEL7kxLK5htjVSIjNo/5M9EpHOJBBVGBjYXS7lW8ynPf9cS4lMi+aEZ0C9Yx84y67XAIegNaHRZwTMfVRhIMMK92NxD9uJTG0YsqPqObY2ZNhHIs/o2RlejD7eVS8V58o1pRF09lcpx6OFf6oGxE+Qm6nXybonaNfUSMNGggBjhlua6y3d00fKRCe8yi8VWmtI3o/6FFOx++Pcc/nRJ6iY72yBtRUjYAoNt89IhFKLaG1hnnusxGygxdFValshkqOJNxioxbVUaIc8WVRStO1XcrLVZ3LpfM3JefWlTUEeSd8Hb+ylfKP1l5NiyXvfPYzTN8cXiXrxXaui2eRYVTpv6edrorXrraLSP3JpDhpmXX7PWl9Znmi50g9qdzAYpdLEO8xDGcQhVw8Rp4mAN5q/WNOIxZsGJtttWJsMY3v/TlDk3RnSgTs1h9xs0feQfKe6cqXyb/G2pASnTOUJs4QtH95uqHryFKihGX3F8iQkHc3UZZoo6FcgbJh42WxqjTnYZo3Az/WAH7wG9I8EdFkQ/CZkU+HraDxM0A0uIW0ej8XhPOfmLEF/ENV6RKOAYeJAFG7BiQu+J/Grv+y7f9HDzxlz5DrOOVFm/ZI9I2zjD8LMtHDXsIjMJz3haDsSx4B8UmZhg2b51W4koSJXuF0slMDB4VGKFanhzduuXJWJSE1KBQ/ETF+tT73wkFzmNRDOdSFyMxAywriNCNUqM2wgKy4lZIIuwGmcbdetBb3en89ESMZ67kSTHW4+A4n3hrS+HWEpKUjxefe81P0UjfmvOtcYmiFoWDPeuQkjCYqY/hXGqOq0BezVshvcLn3SUeyAqZT08LixQAiHmth1rPvEdtCy1L/mJexcrwtbhCcNdJ7eDzYQUOALbfG3Nm/RLc3ivWZIY9abYgyqF9RAFPZ
 ddOvPA7e
 gPN7fSGLIykb90RVITjhxPifim1t7ayCeg5jg5e11svonbW0bGRp5ACfNfRQHQc2ZrgE8tXNQDtVz76R76kBIlBP3q/2p2Z03JOG84sodRdssmeB2HzcFhXsGoaxBpOxlnEHOFWyFd2Te9Y02gITD5vZ1qcS8Zat1BZva986Uac1CsJ5Myp6VdZU/Oyoj59w51uq+8gXluUbWGSf1vnpuLnRRBPZAScHoNoo3qVnyfGjaMnkQfanfYFILOfwTkLre+NPa4AVB3h6fd7MWIkzgpFuB1YzKJoLdvnHiyohQ9k6eMqWcBASDfrgvcQbhjz2nrZOFhwxJ9SkvEcmDSNF7Ui7od+UaJxtNkcBM3sFp6ExAupX2ohzUXUoJloXk8b6g8I7s9lBC4CcXdj+w03GUjjAhnP4rO9sSl7IQFA7vj7ijaZA=
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

Moving the flag logic avoids cases where the flag is modified on drop
lock/reacquire or when the write fails after clearing the flag.

No existing users are exposed to this issue.

Fixes: 9b6713cc75229 ("maple_tree: Add mtree_alloc_cyclic()")
Reported-by: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Reviewed-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index c968e25bea0ae..190f480d68502 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3868,35 +3868,40 @@ int mas_alloc_cyclic(struct ma_state *mas, unsigned long *startp,
 		void *entry, unsigned long range_lo, unsigned long range_hi,
 		unsigned long *next, gfp_t gfp)
 {
-	unsigned long min = range_lo;
-	int ret = 0;
-
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
-			ret = 1;
-	}
-	if (ret < 0)
-		return ret;
+	int ret;
+	unsigned long min;
 
+	min = range_lo;
 	do {
+		range_lo = max(min, *next);
+		ret = mas_empty_area(mas, range_lo, range_hi, 1);
+		if (ret < 0 && range_lo > min) {
+			mas_reset(mas);
+			ret = mas_empty_area(mas, min, range_hi, 1);
+			if (ret == 0)
+				ret = 1;
+		}
+		if (ret < 0)
+			goto out;
+
 		mas_insert(mas, entry);
 	} while (mas_nomem(mas, gfp));
-	if (mas_is_err(mas))
-		return xa_err(mas->node);
 
+	if (mas_is_err(mas)) {
+		ret = xa_err(mas->node);
+		goto out;
+	}
+
+	if ((mas->tree->ma_flags & MT_FLAGS_ALLOC_WRAPPED) && ret == 0) {
+		mas->tree->ma_flags &= ~MT_FLAGS_ALLOC_WRAPPED;
+		ret = 1;
+	}
 	*startp = mas->index;
 	*next = *startp + 1;
 	if (*next == 0)
 		mas->tree->ma_flags |= MT_FLAGS_ALLOC_WRAPPED;
 
+out:
 	mas_destroy(mas);
 	return ret;
 }
-- 
2.47.3


