Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E66C2C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 857046B008A; Fri, 21 Aug 2026 15:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82EE56B00A4; Fri, 21 Aug 2026 15:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9716B00A5; Fri, 21 Aug 2026 15:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 416096B008A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:26:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C98EE1C0D57
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:53 +0000 (UTC)
X-FDA: 85126259106.19.8500A2F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3353A40009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=LybhbZbV;
	spf=pass (imf07.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340412;
	b=P36boKmbRmufjKlaq4yeeEBWNgfsu1UE0Ur0v6K6cN/zRWhGHpIvZ7aqTyoWbEqSaV8Ii8
	iYFIeC+Qtn5fspryrzLIjBdphJcBLQaM4Fw73JutJDBbpwr3IdW4F1TIcKlS+YFX5ZRNkc
	0Y+AsvibOFgBpVzSzeAhbCmwbROvL68=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=LybhbZbV;
	spf=pass (imf07.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pk599fpJe4g3OOOhG/1qwXP3ndv15oabFg8bnXYjU1g=;
	b=v/QyCOtneu6trNSXB/tVC0cJf9Qxe7Vg14vL3v4nF1xHJWAZAEb47CuHLDZkbi/rwCfrid
	oH4xKzw2U3Fy0wsMCi72c11DHBgcwLOWA0jBSHrdow5ttpTipKjJZLj9ZnXlE639oLX9IJ
	mvwNOnYsZwOILRLeDbvUS3O+QItsKrQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pk599fpJe4g3OOOhG/1qwXP3ndv15oabFg8bnXYjU1g=; b=LybhbZbVSG4/L63q4HPXuHeFdO
	B2SOynWj41QtQnJ4vx923V8FDq4p/VL9FoQzwUxQ+5RmWL+yhKCqMvg6J8iH19dfN4gR/nYTqbQa5
	iKw3xmRtu1KjgVaXQCVBrOdg/SJIP1R+FnAUPy8MF6it6Sxff6uRAigRUIEP882ZsMTqAX1v01dpP
	nKhKqqvyqtlayWJ5g7WdAUUgmvU7dlbRQa9tY8HsCo1fIcVLpc03XtLUNrhUe5aH7sALsxeQhgDES
	oZHLgiiMyZGbd7JuzSNFSVM92m9Ci5y+a3gzjpABq1famvZsD8uZe71AGbp53Yu1sswBBoVmKlSQO
	ITfAz3kg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUt9-0000000E0jm-0fLj;
	Fri, 21 Aug 2026 19:26:51 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v3 07/19] maple_tree: Clarify comments on mas_nomem()
Date: Fri, 21 Aug 2026 15:26:15 -0400
Message-ID: <20260821192627.4085470-8-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3353A40009
X-Stat-Signature: ty1fmm386i5qmdigae63ozxthj6gpz3t
X-HE-Tag: 1787340412-26029
X-HE-Meta: U2FsdGVkX18RB8YLGlDEchPGZEPAqraclPA8+0bmR5ghc0EC+oNp+m6mCvzb1Jk8OjFrLb+fbGWf0hSO6gvQ539QqOQrwhJlavigSY4zBcXvwouY+CpfVGSBHdNz2c5m7oTwUYIBVtt62AL3GYvqtkulWwx3ledqG8u24gi8TNSUnZqjl9FmfZArLr1LwlSB069kRdl8S2VLw2ozr+PSkbMjn8v0RV0fuYIHJ/lPyBGTKDSrJdtThulkpK/Zw/SOPJpEpeNXq8tiy57S+9ZTTdD7pwnvJ8xRki4ZUEdk19IwcwY1p6My66NC2RjegaGrgKKt/HADTOufif7pAqpGYIqmF4kLf7NEwYHL7KPoAQvnjx5VN7yAPxkBScPxGbdFBLlFEalNFvYqlLoiOrxw2ZNkqB7S7mM+0PQ/u7Z4LME6Qcapx14wKaZJQGVU+pnpDViRtkujMGll4hjPqckjgTlMhxGG5Y8JMbVKbPmLqoL+fiqeGw7R+G6YE2q4+Pu5gUj35KPtsOIo4sDcWcrUJq7ZDL9MGbMT6fMAAYkvlQHmop/W0X9ruWl0GwucnEcX7222Ot5TKmvDWtsyNPjSbvNqQ5yu/y27Uq20LmGth/psmxBMwucGZifLJ4lsJVBsaTZUS6jj03aK+jPse+3Wu4WFkLkDxuwpaUZS6tjCaChdgU1SVtmUE8X1N35g9bz6Z+aV+Jup6ikzyttiIKOhbk342NGk7CoUGsC39hlO+XiGk+jCmUuWi1AJBSb89cBgxvFWFp145FUkQwY+4sMzaExcqJ5zs2UqIBU1e8zeW7lPesmtEuaKOaKcgzqpLA+IjPPCguwtNqaKGsztN+Bmx0ibaCXMor71lS8mTdVD3eCnQl491LHHd+fnqUKXiHw45KOHZ/QSfTpOERuH3iYdgCZY1pJRx9k/P2bBKvdO5AHkrGZBYhbR6ogQ4fPsLbtH88CWfXRI/uZxR6dnw9e
 f1Bjx3M3
 bzWC8+4so1Pzt+z1dGgMy0ByM0iyzTMu6k4KYG+lQwgoY7zsFjd0t282rCz30GaPryjvHXoSD6HByCvIk5DEW0dz2RH5nz8q3itqoKspHOn4xm6T6GkJQlQyxRS539OaXncINAXA8zCi9xLSwO92OlvfICqiRTunv3eBJuWcDMT+Y86tHRrYEZqzzUAXw+xU3EnFEX8MbC4XPPivaOmC3pLg3wBCB5cJxdzZGdTGK+jdbXnfdC7u8HJqyJOhEx87RPVSyzxbrbL2AZxs9WXGU6VDx3H2hvmIBId8EF/PJCQh/fOTzW+OyUfnjAIncYOTFTex6teeD6ce2IFdQe1blue/2Ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an allocation completely fails, the return is false.  If the
allocation succeeds or partially succeeds, return true to indicate a
retry of the operation.  Note that since the lock may have been dropped,
the operation is retried from the start - including potentially
allocating more memory.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 3509e293c84f9..baaaa128594c2 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5677,10 +5677,11 @@ EXPORT_SYMBOL_GPL(mas_erase);
 
 /**
  * mas_nomem() - Check if there was an error allocating and do the allocation
- * if necessary If there are allocations, then free them.
+ * if necessary.
+ *
  * @mas: The maple state
  * @gfp: The GFP_FLAGS to use for allocations
- * Return: true on allocation, false otherwise.
+ * Return: False on no memory.  True otherwise (partial success as well)
  */
 bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	__must_hold(mas->tree->ma_lock)
@@ -5696,6 +5697,10 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 		mas_alloc_nodes(mas, gfp);
 	}
 
+	/*
+	 * Return false on zero forward progress.  Partial allocations are kept
+	 * so the retry path will attempt to get the rest.
+	 */
 	if (!mas->sheaf && !mas->alloc)
 		return false;
 
-- 
2.47.3


