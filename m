Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3356C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DF736B00D8; Mon, 29 Jun 2026 10:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868B26B00D9; Mon, 29 Jun 2026 10:42:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730C16B00DB; Mon, 29 Jun 2026 10:42:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E31EE6B00D8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E8DFA0138
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:41 +0000 (UTC)
X-FDA: 84933216522.23.1F3CB76
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id EDF4DC000E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YwaSx28w;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744159;
	b=zf1UMVXfhqg1UftIeDEPkb+9EsTRADlwMRD4jwVqlP/rAnNtxoGRrQSTBQecKOuz0hOxDX
	7ntYqjqXhghX4AMskB+pXFFiJP5QYIRJbzbmQYnZdJ17hEcJfxEIi/n5rGNeFvEXvWxKtX
	xzFmwlrkyoVDZA6xn1EOIPVnc4YTFak=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bme1R0KydCT471vE89SzSzHkPBH2aH3edsvHBOUIvRE=;
	b=bVNRV8kBvjcp3YhdmVoAgaVDzI8TKBIRm820qq0t/zZBhrQtc/h3yFWpPRb3jmlMw5z4w3
	gkGMw5EKrFRWmio0UfoHmbBckMwe5NH/7oBphLnRN+7isHYiuLQzHZPJf1kS+3vzO+QcY2
	jku4c2dOCokypl+mzLcuBVVyN04YW/U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YwaSx28w;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bme1R0KydCT471vE89SzSzHkPBH2aH3edsvHBOUIvRE=; b=YwaSx28w/O5gSi6+sXWoqR2n+9
	Y/VZRxH6qJ+v6KV9DbfIFP2qZqkNQImPJFuF0FcLsDB7fGHWGNY00wNU3+OBKII/67LYOEfbINgAk
	wzSzlzI9wbWw4eADLRwyrmWRvOOCxVT9nm4wKi18MQC+uDKNUpDu2t1s/eiuiiLpBV6SJg/Q8UN19
	hMIOvP514EQ4L5u+dOGsvqm8P9WRGIxQcpg1E6HgcejlaEIuzW9uy+melW+voVt5O83VSqK/ggWUb
	MnfpBeKhkgrsMYXS2SXISD2OTBAv8yfXZzOnot8aP4mNllEq0zJQCjt5Ke5TpH9q7GLIG0LsvijXB
	TxUrYUNA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDC2-0000000EuY8-38SR;
	Mon, 29 Jun 2026 14:42:39 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH 04/18] maple_tree: Documentation fix
Date: Mon, 29 Jun 2026 10:41:31 -0400
Message-ID: <20260629144145.1572283-5-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EDF4DC000E
X-Stat-Signature: mrouytuk8hz8q11sqjsw891mciwon1s8
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782744159-27387
X-HE-Meta: U2FsdGVkX19PHJLvBdEiP5El1eIMdj3qJHH0Lt1NRabbIohmabT7dZ0FVfzV8heoq1RBNgAPbpLnkQ9baz1DYJJ2MHxVoncce3aRlI8NpRIQyqMb2kHPuT5d+Kp8eXdsex8LJPSa544k3tD4xqiBPqMtYepsNcxQZdEAg/IVXISl2nULRdkCJWsg3b6+cFMceMbcgfNp2pE3E28Pm2rkgsukDDJrpl+l5RRWckjp5H5MZW12GQsmjN7qP0m+rJqwhcudyUvKdgFkyTaNIgi/5/lbJBhuKcJPrfhnmwUcBTNXBFPOFVTBz26aKOvl0yLS315+bzUJ+cB0lTyM+GQi6ULsTYqUw/EKBVDGuXUWUdeWeItzrrT0qtpwbC2ffOQmbz/ETSjMv7KIVChyQf7bZ1jpbs+kkffkct4G9QhaI8WQrDbORsi1W5cosvg4dYuyXIeM1adSjFbpyXc3h13fRcxdqXe6PgRI4VH8nIZRyuv6QAdFDQ+778X6UcJrmGEcAo8vzAgWcT5LEQDTyXfCNq7WKG6IL8pLyc0JVcEqavj+t8rkaeCy54Y6C4IElIQblVU/ibgiGWU86bJXqqXoLEKsoUPPDMMN5HVjHTn/okaOGhE2RWpCzMF0a5jFnM5aq+l8sxhkmr38DjbbSn+DV9M8HYHKLa6Qj9LpN+5n5OMA7Kq71hiRF4+uOx1QjZevYQESFg1enMUNRQ/bjhXSeFYf8jnbIgiAFjdOpCjcbvwHaCBbBLKtLLekxEo5LDCog+7Pab21+BHGnLFRUzRbFooQSoeeLdZ7LO8gxbXXrV9dm66BB2seE2lF5AmBzegTh4LUW5FWP5tLskSe38ZsckPFoSDObH/LgFKhbO+ChbkYjTR0inuoc4wv5WMiv/OmyxpzW26GMAC7irsBvgZHB0jcDv+NupAfx7SaRbclKcBc2KN3WXlxFVWnMqasrID/3dcllAVJczXtaxgC+1n
 TTnOYpRK
 7bnrVW3mhcT4PlCq85Ct/Co/70ALtmULKC8sS+Wd+9dEEm8WhMmMg0Jc3sQ4gQmBuQCMIsNZSiyHDhH48naAkq3IU+ZNz8TMN+zRNRIWvLhBuf3aymhXueirhgbYQbdvGM4q4E5GYjJ8PTZ3V8CrLUWIbYLT81FK25Ovw0vhim+d2Mmu9YujnM4u+Mll+omtykgH41M1l30cKEjtNjMaXypdEJdlPckuceh7k2ZosJHF5t4EV6sfkEiT0BOJxx6zRzhwpoXOFlKuc+ZkofzpfAQo2ZSW/5ZO8tPIdMn3MtCCa5HeqYPc7iq6sN2hb8NC1Cw6zj2JpO+ku0+bjLf+blsKz3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Don't include the word flag in the quotes with the actual flag.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 Documentation/core-api/maple_tree.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
index ccdd1615cf974..34964ec88d179 100644
--- a/Documentation/core-api/maple_tree.rst
+++ b/Documentation/core-api/maple_tree.rst
@@ -211,7 +211,7 @@ Advanced Locking
 
 The maple tree uses a spinlock by default, but external locks can be used for
 tree updates as well.  To use an external lock, the tree must be initialized
-with the ``MT_FLAGS_LOCK_EXTERN flag``, this is usually done with the
+with the ``MT_FLAGS_LOCK_EXTERN`` flag, this is usually done with the
 MTREE_INIT_EXT() #define, which takes an external lock as an argument.
 
 Functions and structures
-- 
2.47.3


