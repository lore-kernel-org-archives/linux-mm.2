Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B96CDC43638
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8616B00EA; Mon, 29 Jun 2026 10:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 890426B00EB; Mon, 29 Jun 2026 10:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77EF56B00EC; Mon, 29 Jun 2026 10:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42C726B00EA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9DFBC0467
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:55 +0000 (UTC)
X-FDA: 84933217110.12.4B4A84A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1967720003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="kF/nDrHF";
	spf=pass (imf13.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744174;
	b=ZhbOFucCpxwLBDq3XpjVdS5QhjAwnvlC7IKXXFKia4mcE7t6Y7+ZmTxStdwH5LjP0bNGgy
	xvY7sTMeTZJs7i/nyoL09iabIsfwsGeAfMcUt9jymfXeo95J9xEjrt7ZKJI9AF2M9sH7AW
	OSdm51QSn+JVEDMsYP8foQbUnJr7Tis=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDYO40C3otyc6wJw4wPvItsggsDazRYQojvAiTMkGMo=;
	b=IAMo91P4+XXGrxx7ijpDafckqW+RhLSDdme6pBJSrX78Z+NJvKLXh5ikylTigIpKve8QPe
	beodMppB3jUWXOkFWw4etBl9dJPiOJVJedUYHiqrJsqkfSycuYLTSxfXytsArPjCpumRwG
	qM176jqbu4BFVbNrvN4oxxfQxKal9p4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="kF/nDrHF";
	spf=pass (imf13.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BDYO40C3otyc6wJw4wPvItsggsDazRYQojvAiTMkGMo=; b=kF/nDrHFbEKSDBZJqaqdUxEOZM
	N/5wRlMnCc7N4K3u4LC7H2/Dm96WTp8QFcR8xGyEUw5hN7U3z3Iz7pcA4gUx24+FzD9RsP3xN9XCX
	zPwVLHZ/LlRtArGUT+jVYiRABSIIVGE7p9bAsVRroZU4BMql40EVN/z3YfgJhTNula0sMc/sioWco
	nda8/WHj20Eb5OnwFpv3gVTuLURC0uM7fg3wAf2aEUm+VOOljFmyxmt/enUNmapYsjtVAAoerfpir
	sPrxQUWjufAe6OBVs8rQh036kEr4ovIYAedekRwyK71ct5LIp9I7A4ZsbANw4A7qgmnT6lbWAauzu
	0fOgegGg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDCH-0000000EueX-0LsT;
	Mon, 29 Jun 2026 14:42:53 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH 13/18] maple_tree: Document that erase may use GFP_KERNEL for allocations
Date: Mon, 29 Jun 2026 10:41:40 -0400
Message-ID: <20260629144145.1572283-14-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1967720003
X-Stat-Signature: qctaokpm4hwykazoxkq8x1gp4u6w5ja9
X-HE-Tag: 1782744173-870071
X-HE-Meta: U2FsdGVkX1/+/86d36IoYHlpQJ6yiz0CQ4Ca8cm0iRrQ2GW7mISADaF2XbIvJEa486BtcZiBxegcLmCGeogG87h1mYoeA/VAuHJdD+21MUwW7zE0oentEM0kLHuuOCbBHbCv0cW65CT1IXf+NDAgnNYb7sxvsDtzizmX+blHl3yHbzV5iG1bQuB9ZFtqysvOGxCEgaM4gYR699www3OStoKr9gaHGfpE2W3H5cO8X63yw98rYW/EmiPc/x688esqA89ht1lMSL8qIRX4ydn9nKicQtGibp8UeUdk0Aypy9p8TFJ58D8REhDL1fbqYvvL+zlqAH+kBjzDFGj7nZ+Q/i1EX9qz+ORBxFHkDcfponInbnY/Qg/SCUZTaMA5PFD7ihRI+tcxerZDHXez3l3T7vs4P/fKeMGGBvGyzmnCJ0x69WaMMWkNx90569gr2Ec0C1jeXRA2wHX5sVMf7C0M3kQLIdL9jGYW1vXVRcFTqGQCmefaDVZgooXAQs+7K583f8U2jL0gR3/wu1KizpXcXWGLe26EA9Fcuff24TWhLK4W8HI7BNoccLrTb9pKkl8ojNPRkSSCUOIcQ1ZNDUdcdDs2spOLUcvgkjf7IbE0AbvCmzXTB3YGZPgFYoeadyuKAD/MzbnN1fw+BSRAp8MzeB9YaakwsifYxiQD9oAzfWoBBrJZmUcqFm8UDAnrEio70UQLlLZg/nfClIyNrwhTtr2I/oOgy1eHWKPEOZyi93FKHBvvwGkvD/ZHeX7QBJAkMF4skqQqEp6LraykKwma1gImZu5evFZez4NQuGivZc1ZL+raUX7Zag9P6+fRj3mgRlG9jJwafnwvHenNYAeobytO3Wmc8gW7e6C/ESKh95l49qx1qjAiroKYNaccH/siSYLIdYjQg2/PKggE4rsE2UB8Iest/VlfngxWJvfoW16r2gVclEnFDZkYrez7iA/LtkvqkFQ3D3z9HMFjyYG
 EtC/7rNa
 RvoFcB64ZWaXKMjUNx0pWV+ynBD4iRZDjWYe3vHlR/D2vOL7iTj7RMfSot888C1kJNKEWRhLnd660jz8d2d5dFYSJUqam/OdYW+J86oMh+z3Df3s7cIYv00lGOHhzDbNmQWN2QRsNsKVOaB+hBdI699c2j6xzuW7dUKtvX4Jo7xpGCJxaCtvQ7BsebIfZrkU7eusuBVUxrLz7eJRLfZYP76dCHokWQtzACpyYNrS+KoF4uRCq0FqYPWmzy8stRRyyZoUiKHSGBDnz8XUc+0Kk5PyzT7tlk8mNk2bc4IQHoMWvCUSlFRORGAp7f9d9dzaR4XUS6fY+dMO7jHQeteAsaBPRUPerKAk0wtXpRvT0YqpJlrrdEvruWG5R0RhqbypAWjbRxbWI972mT8i70cUEXjGHkzaZc8PNEQ+ZJc6uR73Fgz26xcNzOCAw4cDQmkYvJFvvm4MWpodSUaA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

State that the mas_erase() and mtree_erase() functions may use
GFP_KERNEL on allocation retry.  Don't just depend on people reading the
documentation by adding a check that will warn of the use.

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 67cc480534e96..c5efa3e2f7461 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5686,6 +5686,10 @@ EXPORT_SYMBOL_GPL(mas_find_range_rev);
  * Searches for @mas->index, sets @mas->index and @mas->last to the range and
  * erases that range.
  *
+ * Note that erase requires allocations and will use GFP_KERNEL to do so if
+ * necessary.  If the allocation fails, the internal lock will be dropped to
+ * retry.
+ *
  * Return: the entry that was erased or %NULL, @mas->index and @mas->last are updated.
  */
 void *mas_erase(struct ma_state *mas)
@@ -5694,6 +5698,14 @@ void *mas_erase(struct ma_state *mas)
 	unsigned long index = mas->index;
 	MA_WR_STATE(wr_mas, mas, NULL);
 
+	/*
+	 * In low memory situations, the allocation is retried with the gfp flag
+	 * GFP_KERNEL.  The internal spinlock is dropped in mas_nomem(), however
+	 * the external lock is not dropped.
+	 */
+	if (mt_external_lock(mas->tree))
+		might_alloc(GFP_KERNEL);
+
 	if (!mas_is_active(mas) || !mas_is_start(mas))
 		mas->status = ma_start;
 
@@ -6040,6 +6052,10 @@ EXPORT_SYMBOL(mtree_alloc_rrange);
  * Erasing is the same as a walk to an entry then a store of a NULL to that
  * ENTIRE range.  In fact, it is implemented as such using the advanced API.
  *
+ * Note that erase requires allocations and will use GFP_KERNEL to do so if
+ * necessary.  If the allocation fails, the internal lock will be dropped to
+ * retry.
+ *
  * Return: The entry stored at the @index or %NULL
  */
 void *mtree_erase(struct maple_tree *mt, unsigned long index)
-- 
2.47.3


