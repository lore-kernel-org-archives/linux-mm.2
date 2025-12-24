Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B6DE776EA
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 17:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1BD6B0088; Wed, 24 Dec 2025 12:01:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25F016B0089; Wed, 24 Dec 2025 12:01:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B596B008A; Wed, 24 Dec 2025 12:01:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 090286B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:01:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A86456020A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:01:20 +0000 (UTC)
X-FDA: 84254980320.19.E80FAE3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 19F4D4000B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:01:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lrXuPb8H;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766595679; a=rsa-sha256;
	cv=none;
	b=RdwWNykQxLIZwijd8bBJrtZkIJrixloeuJt2rgoe2c9XOBa6wjtPJtsaFUSU0rS7tPZvyR
	2OMDCT9Ox8y1enl9ZL0iR4BCJ03ph7Rncd32083aP6a8QwZbSBCm79vw7mmKtUGKKmuEQf
	2gi/Bwvn8jTWNpRxG5Zw3a426At/a8U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lrXuPb8H;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766595678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x57WztIccI1mjFn8capVH7vlO7RY9YeTP7R0mFePSC8=;
	b=SUyoClAW+Ch+pjBkdJXYCrgsoZXbjtxYh5z6dTzr7UtDoSirovIsRH7bY/3/A07jULuHMT
	83dAx58P8WERYSOCEgXWjBlYMbVGhKUkEItOefQt8+Wk5hxEtGAqx1d3FmT+2hxzm90arO
	aCOUjVhbW+DzAQ0C0v2AbRJrR2OzZog=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x57WztIccI1mjFn8capVH7vlO7RY9YeTP7R0mFePSC8=; b=lrXuPb8HSlgIrtEZ26fR9AbTZ8
	bBUQVIXX4JANJhuuBVC8a2cQrlyBqB6eHKQJGr8Zu6eV3Mh7PFw+92anJ6nc/E6dK5XiWRuYrRyRn
	LM8fjE8b3aE+iZDC1Vzx+5MLqOPQ7Oh1/gMRLPG7KTY08rMKX80QE4Igq3IJmqCF72Pg30I2U2Gjr
	FQEp41fqvFrT/H6q88s75creOKiVvAzLlLS8Wy1OzGu0k7FTO4wG3vWOfMYFYem/oKzW6v2o2f26T
	MPH9WTFQVaRje6QdWv/dXqXKAd3GW6POtDbgTtODmQLoTefBk+3dsUhLHeCazsQxVg45qhkgQfdpr
	6ia3K73g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vYSEZ-0000000EUaO-354W;
	Wed, 24 Dec 2025 17:01:11 +0000
Date: Wed, 24 Dec 2025 17:01:11 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/shmem: fix uninitialized folio in shmem_symlink
Message-ID: <aUwcV2HhtdiXXxfJ@casper.infradead.org>
References: <20251224094027.65842-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251224094027.65842-1-21cnbao@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19F4D4000B
X-Stat-Signature: dyks8nku6fk8o9uoe8jsf1txwh1z3te4
X-Rspam-User: 
X-HE-Tag: 1766595677-42979
X-HE-Meta: U2FsdGVkX1+7igjewCsidw76GNurAhsfMAoj4MUOoRMjDlxBWJ7T9CQpeLjC6Je7Y3fURznBEh0/lQqQbicppmQGBLKTznmnzdcxMNHCMCOIrY7zq2OlhqqZPMf/KHQoecdHIw2l2fG7yGjPLb6ghhfRTao6A555sOAG/IBLGiv/ORuxGcP/U2CpsxpxZG6Qvahu+0jA2xVTZ6UyYKEV6QpClFx2utZe2+EVCSykUQgto1RK8FJybkeHE1TzR2BHsDLsfXVypDG8/e1+YCUfcw2cSnAhOcpmQIVwArwKSeLKEZmd6P/C9Z1/bD/eiczApssqQVE6C4opfb+jmZsvtSRI2mTW82p2ElrHlvkI3NrPQNmu5CDhN/EupDrKI0vL7OMP+yFQduJtsAtWnBjWU+NPE6vtL29ml0qys9tS0vrBptEuKzjLmeD78TasHEf5JEFntSXGLN5y2lL1fcmObTZcBH9QkSA0OwL+WjcJrgBiVAr6Fam5sY1q1Rdb7oGoz7bgxXZTo7HI5qwhUpt47ljP/g+JMktkWjX4RIBQ6W7BK/IaqwYs0PiEO9OYTQO38Illdj3oMIoJSE1BILhqFFmjYbo8yO/6JeELVsoqMJ7qEUlxV96eIJRg4krn67OPbu+0up3no38F57WaKNWEhvzxg9sMD4TaV2/dTROzGyra9lr6RE3VDlU7XR/h7m95b3cbRkuJCZwhMhCkEeJZRNvMDGAulx3IEikfn4nYQ19TyrqqFBOhUaod27uvAmR0JAs3g9R3t1nMdN6cuNuqI4ODrkq7mcM/lkdQPIQcos/vb+nWlliHMdlvelkBlYK78fKTsbJD57GWCQOLcVBVRQwuFZ+S6wVLHk/v/bRF6ejmwMwYwneo8hmTn6u2TdPhlcYjl653AzZ3Q+n6uPEUvp789DKx6obqxdaCzTadr9zcZ4LoP5QjLGRri/KwkxJ6JGY1YNF5oGkYjayVCs9
 jxa+huFm
 U1KNQNIURwaFBpEv6vtataSEmNaLgpqYnkqFSVe2MB3gKeCV76gC8RMnimKn2xnzmnYt98gn3EOOqIDGxBZBiXo6xhnycP5HmsPaB0yCAmBbB1MH3X9W5zM7JH8qOM3U+CoiiZj0Wort3M+G3qvfNEkjfVKZPcdDkQ5YbTbMdtjVujaHGgsQ7gRcMfBmYsedxbQX9WkqrFFt7Y38r5nQ42HdIQi195FdZgF6r3iD6prG9BxRpbVIPa6yxKsEfsDEJ7dICWFwkNXkzLJ9Ekd/+aFTbHPEo8MT+ZDAq1uK3d1wD+r8PzRpg3fw77WO3BwXSpYmF4FHAYKlNqQLNCvDbbaO3GZU+qhj/0l1Rp8VL/59Vc488iJ8kJneV/H48Bj7o6fI/cHsY5UHIeR82WNvGTeOxeyO4XGKHhq5d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 10:40:27PM +1300, Barry Song wrote:
> From: Barry Song <baohua@kernel.org>
> 
> Uninitialized folio allocated in shmem_symlink() may be accessed
> during swap-out, causing KMSAN BUG:

This would be an unfortunate way to fix it.  The vast majority of
symlinks are short, and we'll never access past the \0 in normal
operation, so we'll be dirtying a lot of cachelines essentially to (1)
shut up an automated tool and (2) optimise a corner case.

How about this instead which delays zeroing to swapout?

diff --git a/mm/shmem.c b/mm/shmem.c
index ec6c01378e9d..f3b3be1b50fe 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1636,6 +1636,13 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		folio_mark_uptodate(folio);
 	}
 
+	/* Zero out symlink tails to help with compression */
+	if (folio_test_owner_2(folio)) {
+		struct inode *inode = folio->mapping->host;
+		folio_zero_segment(folio, inode->i_size, folio_size(folio));
+		folio_clear_owner_2(folio);
+	}
+
 	if (!folio_alloc_swap(folio)) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
@@ -4133,6 +4140,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		memcpy(folio_address(folio), symname, len);
 		folio_mark_uptodate(folio);
 		folio_mark_dirty(folio);
+		folio_set_owner_2(folio);
 		folio_unlock(folio);
 		folio_put(folio);
 	}

