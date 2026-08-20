Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99A5EC5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85C476B009F; Thu, 20 Aug 2026 15:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80DBE6B00A0; Thu, 20 Aug 2026 15:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC266B00A1; Thu, 20 Aug 2026 15:34:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA476B009F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:34:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD82014022D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:34:04 +0000 (UTC)
X-FDA: 85122648408.13.AC01F4B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 48018180003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:34:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tq6Mqh4T;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787254443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKg7WlSpHg8zkU2PKR4Y+r4BI3Zw98IOJ25ILY50rro=;
	b=oZgcSHvA0zfcdvweopzgFqRJwoXHbRwGbfKlA7xMgyo087oKRqBZQwEhFJHdKRwMslyNZR
	E8NWMg4V4+ZnTpAhBd+OV9Jjc9lK5irdndsrt3AErv0FMMJ++gHrPKbtb1gHYm+r3taKBb
	wEX4corijckwztz0uEPeV96YKRgKxa0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tq6Mqh4T;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787254443;
	b=uiVzSQ0iL0UYy8rFwkiXEr9ezmaS4vXp2jj/xGSoXqTGzHbrsSHTrty277/Gv9opux77An
	1/GRQ+TM3d+oo/YZW7OiVCUiCN9SMY/CtrpzSN2UTpLZeQVJREjtZYhyOna+JX0m4+oSKE
	8Bf9cL4yLK2svZAM7RrStjyFirnAKj0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=xKg7WlSpHg8zkU2PKR4Y+r4BI3Zw98IOJ25ILY50rro=; b=tq6Mqh4T48Jf3Da3GNPxAAU609
	LuKgG3yortQBL557VvQ0sNunQjpRfZtt+QegAE0dc+d+LvNeVWyzfh2e35JYjQhHUwCZat4vHDaFZ
	Mq175d4FecV7kkHIQQHXisYFB2pDFA4lHGs6CIhkPlbgFByTKlCG9XaPSne5BGB93pxFBeZAelkRS
	f7trBxy2Y6Se94hlwmYcNmy+BE29xWxRo4bqMWY7cKSNurtRsDUSIsZr8BPgOTVKm0nfmLUZ9YgXC
	SC8rE7xDMkJc0wXq05ny3VSRNhn7SU6zzneE9hRHfidDo/w4gX5cPh9mByyFugpbMkbbybEVMcZc6
	xVxdJkNA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wx8WH-0000000GALh-0i2b;
	Thu, 20 Aug 2026 19:33:45 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	devel@lists.orangefs.org,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5/7] orangefs: Use filemap_invalidate_pages()
Date: Thu, 20 Aug 2026 20:33:38 +0100
Message-ID: <20260820193343.3852967-6-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260820193343.3852967-1-willy@infradead.org>
References: <20260820193343.3852967-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k985zhnzoj15jayktrqmfe4wb9ozw48x
X-Rspamd-Queue-Id: 48018180003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787254442-563324
X-HE-Meta: U2FsdGVkX19RzkGWbkiwTZm6j8pDL9+25JIQmzK+/eigNx3s582C3Ien/cm6tf4GnK6Rh63xbR7ma2ChcKBayPwUT/jvkEx13Dr1RfBIjXMFNKJG6+udbylEwrza6KObPtn/50N/wtMH9UkGwIxH1LNWoZnGFVG2vsXUgjh1TAFNN316/hQ3MxtXzN/D82qi68ICirb7XCAfxyUtb+MqPYBs5nOVJZl3ghCkVEgUjU5dEQ6HDGWI3Z90/WujhMIh3aRHwu8ISjQQzGqP/3OZmLKCcUrqz+9p0+w2Y9dT97SRWv59FkycBOX+TWTwNvTLf4s35+ItD9OrAUzdiLUUW93/dlAbKRCf3VX4d1n81iyjXiHQR44qnUveAIHxjvqIE0BkV+7FFe2vZo4J60F7uX0+01hqr7uJyUWG8YNXvWHjpsH8yPCooXPtjcqa8lqyT82T8/mET4R6U8TNNojj7nWXO8LUoORzQk8KK8ta5thn1kmAhp4PzF8DKApChSUUhhH7g9Af0O6Jh5bhIsaoCkrs7yEomaVzUJh/nLOPtz3Hw6CnDP7PJRbAUvj9xRbubJSYmR4wKSCwGQhuRaHrd+VCgmvGgc9NI5ymTtpv+/vooM3XI8b0v3gfrP0OiFAtJ9t1lc+8nBSwpagd1nCur3fMBs7EW5O7yFlTIhXQiXzXXrh218aqjddexTzYTNbelpMX7C/J4rrzLwrdr1SLIEesvrXZL75HWIkNE/aWDnyZQF9FPpWNGMy+HPhoet0PqSzkzSaGAL3d70d6cd66Hhs8mVuWcVzsMNItQsTyrjGnHtRgXOhtxVLfxnFq2CDhENPa+5v4VPTPuZo+0S9nGpclHJsnu63fDZnK6+Qkh3wKsIG0wcRCW8WJwszi3P2LpmJ89rjdCrb0JFzthS+et60iMdJoyvjq9uQYv9nVUFoCCv3JGUP8eCZl4cWZhDczUVWSMCP309u0QMPm4WS
 Gf3+iCLx
 M+Ju5eWyQ/1uyC1UgYp6xYbFGm/DIutd75rF3jWBIE9tevRlkzNwrNJysekq27uKPCrijMLl28NVMnVKtQqKuQ+7sfjH+Q2B1tihbjaVCF4J07pWdchm141iHBjgvP3bGwUotU+FhATRNtW7DsVU4IrN1dKJtDHsVjr7EsrumQYSPcgB2iVYZP92ugHB/N0WBjedASIybKhcnzR4Z9VGttFx98UkBsZvstMqnoM4Od/T7Z2ot3RmA8k6e4mDMhpH8msOu721wFwLu70sq6UdumfgurcO6XOiGY9KxH8ADd1w074lAcxwwrIhcG6JezOB+UWgv1iS3aCGNr0P2Gt52LmlZJcodzI8vM4J9LOIasu8Ow3xsY3KwHi/asQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This pair of calls simply open-codes Use filemap_invalidate_pages(),
so convert it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/orangefs/file.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/orangefs/file.c b/fs/orangefs/file.c
index 42591252e239..36e3685f7e89 100644
--- a/fs/orangefs/file.c
+++ b/fs/orangefs/file.c
@@ -306,9 +306,7 @@ int orangefs_revalidate_mapping(struct inode *inode)
 	spin_unlock(&inode->i_lock);
 
 	unmap_mapping_range(mapping, 0, 0, 0);
-	ret = filemap_write_and_wait(mapping);
-	if (!ret)
-		ret = invalidate_inode_pages2(mapping);
+	ret = filemap_invalidate_pages(mapping, 0, OFFSET_MAX);
 
 	orangefs_inode->mapping_time = jiffies +
 	    orangefs_cache_timeout_msecs*HZ/1000;
-- 
2.47.3


