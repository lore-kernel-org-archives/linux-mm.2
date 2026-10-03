Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F52CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AEAD6B008C; Sat,  3 Oct 2026 17:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45FC06B00AE; Sat,  3 Oct 2026 17:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375506B00B9; Sat,  3 Oct 2026 17:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 124C46B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:35:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9AD8880A28
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:35:05 +0000 (UTC)
X-FDA: 85282620570.21.E3A9792
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1D45F140003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:35:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="bWo5/h2B";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791063304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Dko3HhaGSU5/rU0ME1b74b5ts31WWOq3griU0bVvQeM=;
	b=mgzoST9+Dhp56/r0fI74hUSk5+7TxaiRZGiAv7yzbMmMKRDVLH/6BomWgaQ4rDNbq+a5Tm
	47UOFuOX7ipZNrisf6s16V009+AVEqUG3SP8ylXP1qHBLEjC73qF7ZzDnpVvhivuAMn3iN
	K+z2OSkA7DjkIxfc98ftMZCz5cuFnGo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="bWo5/h2B";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791063304;
	b=1W2tA8yWhtC/OMIvq456mk+v33pCK0lZ5dXV77sKcQGouoTUZdGI1H4ZHMD/Tc0tHBwaoC
	XGP38s1WWv7AbwhgFwNJfweFIO2fLSxgq928MDCqNmllrRh7YyhEVrzVy61IYW3RUKFwAy
	vmZaA7fHKwJ6Z0cXjQaDX2jYr6knKq0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Dko3HhaGSU5/rU0ME1b74b5ts31WWOq3griU0bVvQeM=; b=bWo5/h2B/eXlcufjNCfpbltF8+
	yui55u+/jNqokXHr86VsBe2PBs3P3O0M4WqXt23QfO+xBQSossudxnknRXEbQrqEYooFYFIjUFVht
	/ZJ6ePPvkx7ydtTgcyMSPtaw0REWYqf6wH+OPMDeOa1t7XfgLMnzPh9BFnfOBwzSevRzk3Emj/umy
	3Vl8JoxW1TSx4rH7lMKl7oPnDz4wSDVZ7UjaFt9zXp1JYYWEXF13aL94llosp9bq7VzIQTqGnpBD5
	pCI/Hq5Wgfj5Lz5HVJ3FMWE/4oaWiDMsBoi8F7XTiCuzZ27V/ilqrC37bWaoZ48+7qYC+sJrUs4uC
	9CiBkUVw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xD7Nj-0000000E5Dy-0vvS;
	Sat, 03 Oct 2026 21:35:00 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org
Subject: [PATCH] docs: kernel-parameters: adjust reserve_mem build option
Date: Sat,  3 Oct 2026 14:34:57 -0700
Message-ID: <20261003213457.96408-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 16x8wnbp6ztcbwemipekb39mozhsgyc7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1D45F140003
X-HE-Tag: 1791063302-860406
X-HE-Meta: U2FsdGVkX1+b8/wavdmT8qkECMHLGb+fyhGBhLQc507dNEsKjdGl/4xIMR2A8VQskuu2rfxkVOFeYP9efFnjc8tIzZrCZ6ycmnTvWEzoXWLBwdKlgSXXstP5NmXWr40dcpOl760H2mtpD6gYJ5VfDNbROa+UwMx8ssERpSBKJMBUWksyeUQuWjwXYQqI9eogeofAKPbR+eyNXafvCD3Z+rmatlje/uHsguSwBpe3XstVSKhxxrq0d/TZUJ3pBLxOx7kqxziKBeSEaSvspf6pRj4arNfHDDD9QdKiA/+2ZLskHGtSW/T8EI+M+FExtra7/S50RPYy5ppbMDl8EcR1I2hRg3VqdRFDnwpVr8QyhTOoLfK6tMwmgevPiXWrNhLOheCB/Ud3lkImVNOHnn1dMNr4C6RN1cLpbNB3o5K4IUWNK7Y0wsJkBZ/WiwngHjC0pvPuQJbUwkrvgeQBfQiYM6twN+8eMlOn9VdKPataJ8NkE734e/xXJI36UqItLHdp1R9Z6Gle2aTT+Y2GocPiIpCtm7aZxkopoZ9fLCa0PO9xyxe/ZeTijyI1xpL6FcdBvzOpKjIJqBPcJaFQpLN+dB0tEAkAfPtQasR/J2BXBkptNsR7+xUWvq0iL110JdgBuphTj+X7sCaAliujUn/1rYo56+HB+WrotIvhq4mRtwjAsnHby7JNUx24i00j44fKxT2M0IbBd5x3l0HLdIa7cNEzPrMi/KQ8xMLjAl1UxLG70lMYJi1WDnhGiHAYQN0me96SgJwnzV5ECh/Z9/WdfXvwWeoSOc28NFa6WRWb6LX5Bctm7YUMdlE7m+o1r3uZ8XaUmgaD18GYgwTYj0GpQpP6YMHQyzm4gRlZyMeBm8w/thL8v59nXcTjYmG9Cg/OOUWC/7JN6VoDtpqv302c3/TcXqvG/7C/b8rY/g1GyIEF4U5l8jf7Gy1WZjxZF95RAp954vZyGn0zUeymIGZ
 8DWcbdPm
 QO5rGos+a5EkI18dob8NH9dBiT2CmrJsPZPZE7vK1mmflJjS3/SW0jK8JFpZhmLFOo8MFxku3icsWzyX7Ui4uXrh9AiSPsjE78FHAd8bruJvAdbG6Ol4y08+risIvRYEsxvYh8woBL8kieMgV2N08WrMeBJvXpBym91plNMCMzTugPzJ6G0qy4trSpcuJgCb0tm7Nb5xEoIyjbTsQr61l6p3vncyaVuPbAxO12DtHev2iQVDUcfg1jnuHXING4wTugJnzBg6SWA/OP0Ub06FYVN3bDNHEwBx+nO3JLtZDkCxuud9L/ByJ5nfNOL0CZB/6y0Hogsq07z4KmPWpidiiMVFC2x/oYbySVPEeUO5YAjIUhexdImzswWVcSBoSLxTUBbcXNavSdwEYjzIBGIMSotDRrWkHA5iMzFvaBuGGV8e8ulaM6XEU9TLfnwS4oNjVDMUU/Ys2Wq/DbeV0kgV6t1NcU2yKIjt74kdm6j3rNNT+Isx/9+RmhDjkfGZvdAtFZx50uzwyaYJv2+uqIYRLDhcl3IwXV7gTSPvT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"[RAM]" means that the command line option is applicable when
"RAM disk support is enabled." However, the reserve_mem command line
option is not related to RAM disk support, so modify its build option
relevance to "[MM]" instead.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org

 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20261002.orig/Documentation/admin-guide/kernel-parameters.txt
+++ linux-next-20261002/Documentation/admin-guide/kernel-parameters.txt
@@ -6693,7 +6693,7 @@ Kernel parameters
 			them.  If <base> is less than 0x10000, the region
 			is assumed to be I/O ports; otherwise it is memory.
 
-	reserve_mem=	[RAM]
+	reserve_mem=	[MM]
 			Format: nn[KMG]:<align>:<label>
 			Reserve physical memory and label it with a name that
 			other subsystems can use to access it. This is typically

