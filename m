Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD9A0FF6E90
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 22:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E49C6B009D; Tue, 17 Mar 2026 18:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E5C6B009F; Tue, 17 Mar 2026 18:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636086B00A0; Tue, 17 Mar 2026 18:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9056B009D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:29:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A474C1603D7
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 22:29:58 +0000 (UTC)
X-FDA: 84556998876.29.CDE3447
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf23.hostedemail.com (Postfix) with ESMTP id B724E140008
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 22:29:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=fyc1TcUA;
	spf=pass (imf23.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773786597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tt4RF9KNtssGzdEl51RiADXjFbSZ7mpR4OrL6sbsIPM=;
	b=NTssZuAJXqSxtnd/2C4dpzoSUrO+956dZRFezT7bUr8iCF8kLhsvZmgcyCVSKljiQW4k/a
	s0ZM2R0nJ2msR1i+NBCgYvPOgQFXY/bxFicsOlECn+MZMJm4Lm4bNLL6CuQfR2mwUGI901
	ULFaFUSwOvlQVtQzOhtwnolz0mqhxvQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773786597; a=rsa-sha256;
	cv=pass;
	b=vDFJ01wqKVy7UeIXFZnJaZXmshlj7NzD9XHItlqv1tepZT6RmFdBE9bCDc/seb6WbnRehb
	G8gxy+5AOao5K4wrUmV5kb0/spooLt9UFQeJMLeEn5S/cwZ2rtn1gzD2KrzxJzA/9AmWEY
	KcGQCzPVW5bHQUTsMsnKM1IJoc958mk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=fyc1TcUA;
	spf=pass (imf23.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1773786569; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=LrO8uIjgDsxf2WxX6XYuJaDHUGdDoot9AxxVOR4O6IxHTNsN3d1UPvS2jyxKbyguTP1sfftbjDMZh747aHwtGCDKaswO2aOb6bltzGvqUbNHQnTY7kdqY7TVhtU5llaSj/Y85EJeaKdYcw4dfl0usYYlz4AwGDvU8H+T3bZggKo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773786569; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=tt4RF9KNtssGzdEl51RiADXjFbSZ7mpR4OrL6sbsIPM=; 
	b=DBeo/PFN56NF5W2j7hD2ud/SKRHxpQ6iAPTAks6SMOsJHZzWR6DpgjTGy57hJUv/ATIi57jiaAnOds1eBl3fC8aVgDOO1iTNMCOVF3umrSIJK/QDF8tb8adwSB4JBv54EtXTytncJBYdzAkgPU4oF+gTRt6qCTk0Bn2ajjtV1+k=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773786569;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=tt4RF9KNtssGzdEl51RiADXjFbSZ7mpR4OrL6sbsIPM=;
	b=fyc1TcUAwIjJbAp+5obQfgkztqugMkuE1xp8ijhx8QH3XDTSG6/p26aWk2pMquq2
	C5yl9E9iivYoLCRvyIm8dHFwcztQTosxy4I9bf7xIThsROy9hAbaHnsFvO96GRb/dVm
	n0eWcIplvI8EKkxRfuX6UPdRE2R6RB+6uaSke9Xo=
Received: by mx.zoho.eu with SMTPS id 1773786567108939.6708811150448;
	Tue, 17 Mar 2026 23:29:27 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH] lib/maple_tree: fix incorrect dead range comparison in mas_topiary_replace()
Date: Tue, 17 Mar 2026 22:29:25 +0000
Message-Id: <20260317222925.87929-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B724E140008
X-Stat-Signature: ftxq31fhcu1bwtznhfzoyipa7toh9p36
X-Rspam-User: 
X-HE-Tag: 1773786596-123836
X-HE-Meta: U2FsdGVkX19rH38ekoCFFq8hxLezm09k85OKPDEXXNqzcKOP1qGWV3n14AjqSSr7yrrS4RJh/HyCe1sS3HZ7bhuppaKsXj8RuFO2pQorWXLeP0dKhqr4zClbFR6381Fd0hmUz7bXeNGY217EPYL0cFDu7bkcyoH4XBUTkrsG1z5hjc1mFqkqG1hq66t/rPdG+j+3wtuIfRzVOJrG0h0YJ/94dxUm6CdhERaYzPqEL0WPlN1jb3krJtAG+RPWRWz4i2ozlYtb1CC9ZZqYcROKjxnC2uALYCW8LWbMN/bvLxDvS0i8VE4mKGlqaMUUTS22VrqHiyAPMM6ELfldUBJKgGpNskZhDU4Aq4Y3TVqBo9CWU8JWxSgfjpkitQMdeYmWcIs3McqCLZFUix0Zr1+IyALxV/RcEwM+KpEqbQlUjvK3dQLjhIWUmlmr/saB3ZTU2Z5OBQhWm+ewG6LWq/wFwqkIJQHfH8Yx8gkn0PL6uIfMPDIDexsXTtuxAHJKAWcQdC2h9+9OBgCEHAKjFFiEe8xVG4t771mPdZYIX2ENA2tdytT+XEvnmPt81QwPGyKQkcP6fAGVOrBBrQV9HeM7UeRI9qV4ttYiA8y6lSzZt8MJC/450/JrqRu4fZZG8UgfkSvQKJAmmt094zzJ0njOQbg6WKIfVqsVOUM9qnubSOHv3iI2ulI//b5rG1gU0p315wZqXKlrszO36Wq2RqmnAOTuLT99QcvEfDpQe7D/JzAv7oyjblqfQ8SZhkYadq0fzjge4N4ueHFYOF6u+60CtVZvqTcvPi4Egc83l7vdwsIlJZt8ccZdvL3ywpk2EBH2xEg6TL+GpyNKJoYNO6JEAyHtx/HeMY+odSAK86UNP2BNTRIYv7QptmHHJDy9QWiwZEa0mcPHEuSxmC1yXLH6oAH8BByPUOftdC2nIH2E8siBeqy99qDwjzpW4xHs8gDEvUZ2x30u18fZHsjntfg
 3At3EuBv
 l05GJFtqdD70sLuL7ZZI3olC8VBFM24WklVisqu/zFyguQNkR4LVskM5+no1mEoRAnoAaHl2Km8B2+unTbw8GFoMEPH6FQ1xHdWwbt+ZcAcTss8gY6RIg2LwpQr6drRDkDVGInaTApfJJ/OoXIh+bQLajGoPVnlydXxcZqko+noJDiPkvwlo4QQchcUT4evZHqAPVqHjWIk3yyHkwmtDAOEAOfQR4V951RT/DsmGCvDrnOFeEvso3wRb79fFTvtvKHYvAgynvYOGXSvvGLZwH51Pb5d8NDnJwCG/TH0NM2oBWTC73RPoyd0Q5tAwBa57k6GQT/gSXX+QJ1x7zKzu1nfS//WeMFn7s9sLhod1KsH/6x662RhMOFBetyj4HgYUrfH57XpM9rdmN26o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When collecting old nodes for destruction, the dead range check uses
tmp_next->index and tmp_next->last, which implicitly dereferences
tmp_next[0] rather than the intended dead range. This means children
at indices n=1 or n=2 are compared against the first child's state
instead of the replacement range [mas->index, mas->last].

This currently produces correct results by coincidence -- mas_find_child()
copies the parent state and mas_descend() preserves index/last, so the
values always equal mas->index/last. Fix it to use the canonical source
directly, as documented: "Nodes within [index, last] are dead subtrees".

Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Josh Law <objecting@objecting.org>
---
 lib/maple_tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1eaaa5f964e9..64ba117ec254 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1874,8 +1874,8 @@ static inline void mas_topiary_replace(struct ma_state *mas,
 				if (!mas_find_child(&tmp[i], &tmp_next[n]))
 					break;
 
-				if ((tmp_next[n].min >= tmp_next->index) &&
-				    (tmp_next[n].max <= tmp_next->last)) {
+				if ((tmp_next[n].min >= mas->index) &&
+				    (tmp_next[n].max <= mas->last)) {
 					mat_add(&subtrees, tmp_next[n].node);
 					tmp_next[n].status = ma_none;
 				} else {
-- 
2.34.1


