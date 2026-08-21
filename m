Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD3AC5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830586B00AE; Fri, 21 Aug 2026 15:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E15E6B00AF; Fri, 21 Aug 2026 15:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1236B00B0; Fri, 21 Aug 2026 15:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 458D26B00AE
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:27:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C48BDA0250
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:27:10 +0000 (UTC)
X-FDA: 85126259820.17.AADC9DE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2DA258000E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:27:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NPFoLcBn;
	spf=pass (imf02.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340429;
	b=6mkQ4XixCzrir/kJxrsgvYfu7kNGTN7XT3qXE3YVuCaEvQFI753gscLE0AtC60f3pHOJrs
	qo3vORagORpT9b8KBcEmvuMBjeKQkGbW0EB3/jbMTroWbknjdl/qy4PZFgbsAKioiZerm0
	/rPc6I+aQ3nK1t5VUgrvnSaQCZz/aFg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NPFoLcBn;
	spf=pass (imf02.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZRNn+Qndzrl6cCjDNpfrHvrdmbmDeZl+l7zc8rWP1Aw=;
	b=s7KTCWq8iYdyHsh/3RHmidD3/p0eyv91wTHsnfg6WbqZGy5+2eLd9fBqO2Lblh8/Bm6QlN
	se7H5hVS8/tTK2Q+Z8N/AG2SvWc4Is06CpAWPVR3ZTjmpzrHUIaHSFKRQSt/iZCbgi3aYJ
	rd/akAyTZz6XbjibB/m8VJTkEPdlzM8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZRNn+Qndzrl6cCjDNpfrHvrdmbmDeZl+l7zc8rWP1Aw=; b=NPFoLcBnvY18i6WdSpaoMwowFe
	J42L1f21HcbEyCpBrR0snlIQEJl6UzA/Ck6k4YR3fvKnfBvPQQUevnhT5Fam8ix0HjtZlDDTYbBnl
	HtxxJtZPEotDMX2BYlJfJBgheY/RNwg/tnHuYZe61mbMKwY4Fciy8c4HIlMeO+JbIivRwtMX+IXDf
	QtHKuyQ/ucrvxCthxoUq82ieLqtuYk2Hi5PeWIdi2boxKwmi1Q8xfke2ZChFAH3HmsmZDd5s5DOH8
	ogQo5KtlMskrNzgQ1X3jDGUz0Kl7E2SSmzrhzlMLBgeaRxOQzGo0LNfdJ2T/7SLAO2C1ta6w1EP7b
	yTsPmCCg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUtQ-0000000E0rE-03IF;
	Fri, 21 Aug 2026 19:27:08 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v3 17/19] maple_tree: Fix argument name in header
Date: Fri, 21 Aug 2026 15:26:25 -0400
Message-ID: <20260821192627.4085470-18-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2DA258000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: awtwzwmc34shd371rsgyzh93ex8tj5j3
X-HE-Tag: 1787340428-839771
X-HE-Meta: U2FsdGVkX1+5Ee/WgXa34IbLqhRkAdb3KCKE0WnTNQoeah6WT14uqgA+XUKdlv+kKtsQJVAay8aXoD2nkTME/RlyIVFyHHqnVUZ8cOOBYt6LM6DRF5L716DT1gJgNpIyXRfCzZzBmJadd+jWrLt0o6Lr9/A3iymBhSiDfuuiBgwPVjp5tEFKDXWCBsFisygnWQfFtjTCIWpnqxKvJHJ9OAOxuXOjp+6nfCaQEmvashlP3pqpSFMqXAF8DP5OQz5R8jmlUNG4/AFFRlgAtw1SA+iDLoDIcmd6FcFSNVWmsCxv/vk4/D/R7HQNJNWOiDkBBSKd6gIGMTKzEVMn8LK40Kg4PDqeX4fVZ1CEiSAUURmBFo2CBXI+Y014KjZwa9Ha/ODQz2bo9pUKJza5W+LDo+x5e2oM3TNiCeHozisu8ONWCtPHN7MI282nRVWw4sUDjYoeYSbHZhS7zSa5zwA4bywa9YJvJFf1PyMt5njLV6580G6ZAfFD5EJpO8wy0ra0rSaSD2SpupOtJrwFFI4teielKPezYMkcL65CZwN3059MvOroCLshfFhcQ3cY4yhFtk8Am8L8Aq1zrim47IHA+9363FMPgeW326ZJ5wWDFNOEGhZ2qMY6dQnQkwCGVMkZWc2vFqr9jRC7Z04YEnOwOEOCMMHKZ09wmRy8ThK4sk33EdBSVs54aJLWw3tohcsxBczpqt0DBXLzswz2hjm3qanNQ9FWQF8Uo3X8vw/KHa4JVVZ2TBn79I6PWJo1JtuRzCx4lhPSPYdgdqTt3s0EmqmvFqLZZ2ZgdxiFvycl0kxwv0Pjy9mBfcwJabiQj9lTIyzyAClxILVeIK1UOuFlWz3p0gdkMJ+NL4Fm7UtK9W3WRNmnurbK9Gbe3fbR3t5avhLNciGrR+ZVVYrXeBPywfe6jh5InR31LlHs31ZelD1MHk/5SGnj6inEwlAeJ6BOTR6PFiDAvJ2m6ziugOJ
 xoCOMXky
 Zr+/C49+TDRFt90McFGGSbH/G5M/dMJlNsBhmde/U+JPoIcAndTeIWI2CcSUjzSkc6pf1jgYeKV0XMafs8tLIykAKj13XNSOAbLxL5aKSTz+Fxy5qs6gdZ2pzh+/PbEXnWVfvRbSfbYx8I4fbBrGELjFtVWEWDrRT996Ue0L4P7a9siFjQfTR2uw56q7hywUgFDCynS3SuwIgRjLuKanWEZOS1/JiD0+DPpbkSxmINEXnvKH2motcQv93kCsks7AifHQZA+x2WMvi7BogkGFf3mqf0P9l07IdDdQC9hgFnnrzGFbBCU/dKh9N5KMxu6BkPLaPdoIcstfn4ub0Ui64QPIBDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mas_prev_range() function takes a min and not a max.

Fixes: 6b9e93e010204 ("maple_tree: add mas_prev_range() and mas_find_range_rev interface")
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/maple_tree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 173602e87c14b..e595ae5cd0eed 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -577,7 +577,7 @@ void maple_tree_init(void);
 void mas_destroy(struct ma_state *mas);
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
-void *mas_prev_range(struct ma_state *mas, unsigned long max);
+void *mas_prev_range(struct ma_state *mas, unsigned long min);
 void *mas_next(struct ma_state *mas, unsigned long max);
 void *mas_next_range(struct ma_state *mas, unsigned long max);
 
-- 
2.47.3


