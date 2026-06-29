Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B06AEC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFA596B00DC; Mon, 29 Jun 2026 10:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0A36B00DE; Mon, 29 Jun 2026 10:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4A826B00E3; Mon, 29 Jun 2026 10:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FCDA6B00DC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3EC9120128
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:45 +0000 (UTC)
X-FDA: 84933216690.27.9E62905
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 777AD180007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ASg6zH6V;
	spf=pass (imf16.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744164;
	b=yj4l5Vwu7XWmTmGxvh6hPmebjB0up0/NqNYsKIoR+qQX/USv9KbmU3YmLIJqvNkrPp+pbc
	FCKfz9RYTpUdOxcfIqjdvQW+ENQBI7W0nljkC0S6+PPJoD1kaL5cf511Wk3cW8hvGiyIuP
	uMoW6KwZFxZElBJaBmx+V2nDzX5Jfl8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TVVMo16TNRm7PRWmHQW6fZz+VCRjTretVoH73fawlt8=;
	b=RkPzMnOwhYV/f7DUxDKs4G/LR9kPddFhSi9yvFH0XsG8bCtYJ9gADBXvToABEOBMHAKdKG
	oa9ElBiMQBRslMCw3SdqCfnFNGwjjcYIbzgGxzNs9t0YPDL1kC4ULA4VqXuNUF8v0pFhgV
	ZS0oUgH1r6B733J6K8p4Ia4wmMwCFiw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ASg6zH6V;
	spf=pass (imf16.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TVVMo16TNRm7PRWmHQW6fZz+VCRjTretVoH73fawlt8=; b=ASg6zH6V4HikVZVus2QkfucNtJ
	h0sAETDT6kI/7Endy+TlipZJr6okkcPDd9OXkpw1YJug/8wLV00IzfOsNhrY8JVQ9uO/CiIX/79ko
	bk6dNIs45B6hOItHp1nlSwhOuLFFVicZSeru08uTy0UyFIszZUKHV2z4RS3lNQ591mc6ErqbcAFhx
	pXaIHbE0v9Llrx0dqdTd5d116+iLVYDRU46sK4CXEBMAfDcrahE3cGpLfy5XuU5wvjtmarBIXAWgI
	ZXxFUrg8nO1lR625WfdqrGR3YgQzM0IZHNVrDIL4XXG5aHfEPaZ1XhUuT+wkkj7xTycs83WrYevjp
	2VsaVl1Q==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDC7-0000000EuZq-27Cc;
	Mon, 29 Jun 2026 14:42:43 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH 07/18] maple_tree: Clarify comments on mas_nomem()
Date: Mon, 29 Jun 2026 10:41:34 -0400
Message-ID: <20260629144145.1572283-8-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 777AD180007
X-Stat-Signature: w7yyokw4ujmz4wcp8e1b7gdaxjuegg4q
X-HE-Tag: 1782744164-873898
X-HE-Meta: U2FsdGVkX1+J/qpvAz9oRUd3HHtnjgHw2uBUy0d9xBsKh0KxrGp8RdrXDSZ/kczOo/bHeQwh6KnTzUTMLoY0/Bx6YPj6Fugule01sxtYPadV62ysW8jAy/ubOvS6EIn6lV0OOr1cnjIfW2cIcgBqxO2iwD+t+nzr+hTPwPNqh9iDR+EhGju/S/0VBMSgOUm5NNS5pnimyTUGdYLTcpO7JFzg9rEfliZ9S0dCSiFeJQ0jwgrRdBgVimWFSQ8PB+o8UFf3UXjmNRNkHcxTKKVASfuKO/qnNUj9xdzbkHulecShwZiUJwH25+8WNQoFGSu33MtNIcjEW9ai2CRNbU91e/A547cOlCaxaLmKcuh4SiAPfeLVCj0N7irMXMhzyZegiqCyTQUcvvaevILyZN0qnBV12bGFDanGLhSaZveAYI7WV/kfELkCIk3I8RlQZ9mEegtcqpmlw4x07MaHhE7YBYLtatLK2GHgtLmVkqFGk29NOlLFNyf/4DMMyecguObZITA/FC/tk38cUSBCih+E8VFIHOEbvXnlSsrO8RYAgHpZdYRCoFIndB+haro39bz8yiu0deslE5xYZoZVqe+EBayRIpp6BnHhNpuYZ8osNkA0P7wl1/gl2B2YJFasA8BFH0OrgtjtNAeakEn8VTSPGh8q2xj4Dp0q3p/l+6oiCKBUo+cTVVvAWOrMUAKtVu5Xum99xMDVyrHQnuPXSlza+MdVs56hbDhaMqMMvFIsnIz5LlnrCxpPDP1r8wK2kOgRN/9No29Dzqh6YA/sR+NRHlPQ+1ZbkU6sVmaFx/mI3tSd/CmGGlfhATukVhFpKKQyl3rdMnHPx2bx/Azd/turjtAzrA1XHv0eZfn9ti1FWq8Hrde1giXM2GsLvykD0Q3tqRqwtP2OGAtVlGS/+r0d9sJSK8QelSpr7rBdrRsIaMVBzjeag8iLxQmcjcaKq5gcWu4GC5Vxnc+wWiMRj+3
 xBsjP3+/
 589+KTGRf1JtB9ciqZUfNZa0UF7s+AR7A2cruGjA+f4Nk2tpsOqWv5oPqIM+0B2HKqYin5owibOxnK07OLy0+suj/OjK/y+WkNmtgMfj6TnY+ggbG6glG+Uu6KguXHshs7C0Cx8g2jCHZo5jrsXenksET4ek0Hj3/BH1Yhf4LKTP0QJ9EZzEqiyufZxSLtLk4EK+J52/hGHv/4eSi+2Y4dGW2vrl0e0AS50lGUBBAHdwhg43b1McRsQJGOy/LwmeoI3D8f1EM29Uagz5xb06lQno+Pfw0qzzBT0zEHhbr+Dl6q6bD/ZRM4UcizJT/EDrZfRKMLydmeAoCESb05sRFGwHWCA==
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
index f0aa08902b462..8106eb8bf2eb6 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5672,10 +5672,11 @@ EXPORT_SYMBOL_GPL(mas_erase);
 
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
@@ -5691,6 +5692,10 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
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


