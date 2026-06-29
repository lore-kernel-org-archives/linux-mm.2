Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1002DC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229516B00EC; Mon, 29 Jun 2026 10:42:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8F56B00EE; Mon, 29 Jun 2026 10:42:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0048F6B00EF; Mon, 29 Jun 2026 10:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C93586B00EC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51B9B140134
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:57 +0000 (UTC)
X-FDA: 84933217194.28.59FF726
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id C492CC0009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QTltAxsp;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744175;
	b=Bkf0+I9wtBqcIJO/etEasmVi6HPrR5ijAZ/yb2H+1oRMgGr8G3g9b4ayPhyN2AuxvpjzQ7
	i9mnkU4Y7g4ziqJyR2U/m+oxToDh2s8P+CrmZyufjT775RPgmu4OYU4bJRpkkuZHAQamxE
	GMwKUGsqvmWDxViU3I3+UU9gN+N8Je8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8J0QSGS65Sv3OwylyYJKeZ8VAnRaGM9NHIx0pjG92jc=;
	b=xk4WZ/Bie6Vw8ZhB0w+HEYrD0TfV8Vs7F0rAB0x0zk88zhkSfBbvglk3R6KvalbyLeKijn
	MzOaIrR6tbMEe5WG1ehDeJ6cYjsUb903CuTLMhFZJHAfoykzcYJnKo1y3EjT9O+xoRKOm0
	IshVA/ycdlP7cr10+3Ql1jR0UhCsiiA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QTltAxsp;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8J0QSGS65Sv3OwylyYJKeZ8VAnRaGM9NHIx0pjG92jc=; b=QTltAxspSWOX5++01JE3kxh3YT
	ZgGVOaA9mUPxgzE63StDKGng0Pto2z4+BSoaKrGvsPmsE6O4X44JsDmee7yETOU4Z7kgNIp4nCUCa
	ekIuyzv//oOcCeFG/y+6bD6OBSb8jUoefg6l2KyaUlTLJb9l8smAWQeTlUgUNOhuaUjxRSVhuIoWx
	WR1pVTG0/v+XWI+sDbixbXbTeT96y+1oVUnbMZY1kJWMOpnmZ/NYSdtLaxqvmibz5SclTjBuakYAp
	UhyvnT556Dzvi4afX4M5u8Ci3EG8ikm97BiWzKmlEreqDsVpYDoSpNaRKgMYaGJQS48NCWzgTKw0G
	vDbMPzJQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDCI-0000000EufR-3Egq;
	Mon, 29 Jun 2026 14:42:54 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH 14/18] maple_tree: WARN_ON_ONCE when allocations fail
Date: Mon, 29 Jun 2026 10:41:41 -0400
Message-ID: <20260629144145.1572283-15-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C492CC0009
X-Rspam-User: 
X-Stat-Signature: 7wfnxkdhrgxdxpu81ff9wcg75azjre5h
X-HE-Tag: 1782744175-714649
X-HE-Meta: U2FsdGVkX1/oLXVKFs3CxezVhjJttx0+epA90/GUI2H/lMzoEW01rBqAiB0ICBxFjxz17hB7T06CIYFLlere0UfTMt9TSAj9wf6gfmZ1HLA9ccqZLP3KOs9gAd655KGy3jYDVdj0gEXOFAOiHrxPDKsZcabOXcjHapa7Tf4RKuyrgIeHiN8odV4yLvubALCxyBdDfg8SGduCHC8r1CD1fgdF1IUFawV6+AM1lRcHXPgAVikpT3NS9k2wvFfarIUBF+cz4WgzqUIxXX1zgXr49US6uKIDNKIu5xgO5X7oQLeULxmIJ2vLhsVXQ4MSuNCGn96unGi4a9QHvihLB8c/Nk6jN8KeKeGMgrCo8hG0M/EsNAF9/cRXZeHSJiaaZbzBDqmpcxrMpfk8qYaeVbAo2Xgksghld6YbCHxkY9bUmot5puudl/Jnh6tkfacIPrhoXE+7kXzGseycK2LBfAqv+2c0OYh47F+vIpocm3vvzOwhaF3CPxqBXfMw1VtJS8OkW43d6HT+a16bBVkSJ4ySAxoBI0Ap44TgfzsecUMHb5zihJoBlfmAiZT9REKwujmGV2zfVYr5HIcby6Rgqj3PxqjXSuPtaehc2VfRklhrzlh7FFoxTt4At1rmwk02xY9Wu+D27UFbqLKz3AGPfLgu5Gei1nNmHLEw61GLGk3l/dtufmqh51xyxAmJh6Zg3jVPAUHAgG0zMmI+9pCw6VwCbpvrcdwkNatd+9jHm49XejAOXM63PyrhLdzP5YF4Ov2OwixAlV3NjjQJhPkP62fDPSA+6Pgqja8zleOcS9c3OSa1JwqekZ0sWOBWJhNBsnVukC8tajv7mYWIpD1K9qDaSU3MQt6pCe5yg+KiHY5WNERDxkYl8/5O7Quzm6hzDdnLZOGgs4i6we5ZDGa0OiSUNP35k+EmCYv6FER8gdcaUfiHz0Lb/90I/GFufMZ+4BATCG3oZzHe07s+rHmzlDe
 dXVD5jKO
 l+X+dyOmHEOsDajmRcbCntaOMq4keuZSYCglAzqUoLvjSO92LiX1U345c6mYGYS1mj7WCIbIgnM86KksC6WQMUAMjEg7/Q8drFrgTDiRbCsNm6gYN1NmeN9tzEPqEK/cbRyaL/0c3MhEiNhwxuQn0x0iZTsguI4ZLvGbAzrAyy3P0+6kUAkEngOhgYbw5etaEr8nfz1w4CsPTm4S0udQeDLXFMHunTkFHx+2AGg6nh6GdyKHROyhq7r5v0p/tKJARa8XMgjYdmzzwh6Psx2Hhd2r1qLHt8yWlktORyPtD0QOXvaJ5uqrfzFG4cMvrjSdidXnNRX55EmfHvGhLGfddgz+pcHxeFR2nF6Xo02JSTBq94aQbty7WEXvb7u35JT5oQgXGLijV+/HFzkqJmx6gwwHuZ8E1UXTQyvXKgZi5DIcHMqbLpNI0QkJqYnYn+xGtXZ2YxzUUbWv5Qww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allocations should never fail in the circumstances that are expected to
occur.  Add checks in the code to ensure the circumstances are correctly
set up by the user and warn if they are not.

Also add a warning on failure to allocate, which should never happen.

Cc: Rik van Riel <riel@surriel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index c5efa3e2f7461..94f2d5b9bc881 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5747,6 +5747,10 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	if (likely(mas->node != MA_ERROR(-ENOMEM)))
 		return false;
 
+	/* Allocations can fail, don't do this. */
+	WARN_ON_ONCE(!gfpflags_allow_blocking(gfp) &&
+		     mt_external_lock(mas->tree));
+
 	if (gfpflags_allow_blocking(gfp) && !mt_external_lock(mas->tree)) {
 		mtree_unlock(mas->tree);
 		mas_alloc_nodes(mas, gfp);
@@ -5757,9 +5761,12 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 
 	/*
 	 * Return false on zero forward progress.  Partial allocations are kept
-	 * so the retry path will attempt to get the rest.
+	 * so the retry path will attempt to get the rest.  The failure should
+	 * not happen as we try our best to reclaim.  The user would need an
+	 * external lock with a non-blocking gfp in a low memory situation -
+	 * which would have triggered the first warning in this function.
 	 */
-	if (!mas->sheaf && !mas->alloc)
+	if (WARN_ON_ONCE(!mas->sheaf && !mas->alloc))
 		return false;
 
 	mas_reset(mas);
-- 
2.47.3


