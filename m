Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8861FD5B16E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 14:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7EF36B0006; Mon, 15 Dec 2025 09:19:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2EFE6B0007; Mon, 15 Dec 2025 09:19:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D466B0008; Mon, 15 Dec 2025 09:19:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F4A16B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:19:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 22B7D1A0278
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:19:48 +0000 (UTC)
X-FDA: 84221914056.05.0FA940E
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id 701FE40013
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:19:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mYhHQlYj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765808386; a=rsa-sha256;
	cv=none;
	b=mK+uXe6Q8c5JZqLHgqFPl7ES+ekRREmoxFxEQXlcB33NeMBYMwoxKlcKg2VTHVOdih1nQQ
	dqn4+DkbrmshLVK10MWtmllXiJtkw+i2wBnESKNF2bO4Qv2JtflcYpP3t+H0QSmCqSXt/+
	KutaJL8x9K82VuUNWZsp74KxcyMoKn8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mYhHQlYj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765808386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sz2ZyabzWF0ZrqxI+wXOJC7zHA/OIk4HRDatPq5ZR/Y=;
	b=8YzXJ+/rLIal7oAox1LeH4FU7H1w6fsPFoi7iCuTv2hj4/E9Jt4h9SLBIednr1xGNwK0Hb
	lR6foNa1KeJCisP0w/mztRgQYxqACdXhJB67aH4QtBBmAwfiUEiMw9tBlidyPdZQTwygaB
	r1NK5kVCNBhSauUyKAD6M4QaN7uqeOg=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-34c24f4dfb7so1875212a91.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765808385; x=1766413185; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sz2ZyabzWF0ZrqxI+wXOJC7zHA/OIk4HRDatPq5ZR/Y=;
        b=mYhHQlYjQ8El7WFYIBvOFHa21xTe5+fKnrxwWtejHCMzceU0eVKSUGm5EJ7GIDrh3S
         lv1OL0slZKfG/iUnEkk7uTSsodlNxxXMzlj1Fq757iIhbXaQGlyiowuUd1C7hhkxN07u
         kjhAba6Cn/1UojUXAeQv5SNOMLJUqZ73aodwQr6OMiTktAFBdZ4VMODJ750YY3DZt225
         /o4cc4mR+ldTjsrD/KTJ8tXxQe3oiaazQWyzTROFHCUuDiuQakehQbfJEmwp9pX7uqvz
         RvDChiYUQ62U+qAMJtIJPK+pBSx0AxgmIh2kcar+X2qaX88WWrrvMYqRqhdSou2E5f8+
         lnUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765808385; x=1766413185;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sz2ZyabzWF0ZrqxI+wXOJC7zHA/OIk4HRDatPq5ZR/Y=;
        b=mwCXKbzM2LMiN8pctjxITCWWFKlmaAreHQrD1M3x828vjBiZ+mdYYlbs0KxeDvzTxK
         d6F0Yemfz100scs4GQm8rfWBBCNzrn5tUvrUqO9P7jAfLgDVE32nDssq+clyGdIQQSQI
         zVYgx2M+p6Mnw6XovXUOW0c5uyIi3KA0Qi60tgAgVjPWTuUpl/9A46pb8ZLhp6uXXDps
         Wxlw3FGf+uheEVS72QUa4mRY5Gkc8/N0ZC1Wp+VIh0bH7BOODnxA1+tAZLEfP3kRjJix
         +7MqYSPQEDVhvoftbwGQl6jdLkjTn3PHzHhGBWRokeWKxr86E0+UPJNT7tHO5z+lz3/v
         ysRw==
X-Forwarded-Encrypted: i=1; AJvYcCXzQH4e4ZYOIf+HDa7LEl9nefHe9sEneNGg7K9K9HJ7aRNZnA4aIr7wkdFeA06Xxo79ubNcY7rxHQ==@kvack.org
X-Gm-Message-State: AOJu0YxJBO2to31HMxm8sma1eGIYqddiT7ominuYw+b5wf5dyG0h9UYo
	SDAsh+T6J0SWID4jOdvzCE7JTAMiaSHcJEx7IV/OIlOwXvjOuU2L7wUc
X-Gm-Gg: AY/fxX6ivqmQn+nCOSiSqTtm5pJxz+Xh8BMogTCHE34IQjxdNjXi/UBHGvNyLu9zIF/
	xp71gL73IEHcY83GWruAX/PiikdBOIHAiVG6Vf/8RXUZlrQIlXHaQmVcxMt8IwiXdTz6GPBIy+N
	xgr6uKxZs+0xaTXjHgDkXVmLgBhYl3W/hZ0AHI3ErpzHn3lKOB7FBa6Gr/jqfa78his1Wc3TqEE
	zA1BkUSEjFTSluWIYQiCSeXYsrD5rTeHv29JGH+KV3GC5Flsqz/06/N4jLk77LpORsCug4jXWX5
	xCxnG+ZRkgtgsTAX+aiOT3N4tnUHdutOlfwtU7Zo28ciKNNuZ+Sp5fM0ypz18zej6U6SwgYEMK6
	SENVHXx8nbK3/EQj3q2qDrRF2bGMrgqwl433NiH4b5Bv2exfEEx6BoSRJSIG9hY8dzj0Oj7zh+Z
	G6eQ8=
X-Google-Smtp-Source: AGHT+IGdF2f/MNFoSK/nrxLbzKgQ5vS0nfeLfMK+djS7OwzM+f7jzutmhjxvjiyFHRAZZn9EuGNBFQ==
X-Received: by 2002:a17:90b:3c4f:b0:340:9cf1:54d0 with SMTP id 98e67ed59e1d1-34abd7a93f1mr9394279a91.1.1765808385125;
        Mon, 15 Dec 2025 06:19:45 -0800 (PST)
Received: from localhost ([2a12:a304:100::105b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34abe1ffde5sm9524411a91.1.2025.12.15.06.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 06:19:44 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>,
	syzbot+4d3cc33ef7a77041efa6@syzkaller.appspotmail.com,
	syzbot+fdba5cca73fee92c69d6@syzkaller.appspotmail.com
Subject: [PATCH] mm/readahead: read min folio constraints under invalidate lock
Date: Mon, 15 Dec 2025 22:19:00 +0800
Message-ID: <20251215141936.1045907-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 701FE40013
X-Stat-Signature: sb47idpp49yftz3axo55z3y9ymbaw3bw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765808386-52082
X-HE-Meta: U2FsdGVkX1998vGs9Y7bSNPIBuseI62ot50HI/QEKam8nNyjWANYlnXjW+e837jeTx8GdOq3oI4GTdnyOh90Q95vCinbPo6Y+vhivYKG94RarsvFJNmvALvjU8dTCxqG5f38bVgDnuA6TNz+ckQrtoUOZRSMWggwYUNE1uy3nf6T5NMXkpHtZDWwpmjPV6Ux1sRTTwctG6BUrg5auytfvD2iErsesXoU31vjhOZINR1ALCTNEirpNr9WDcEc7FCs1ajg0xVUiEj9Ey3WbFmM/+QFOgPymyhVlyyaH28PJz9znFZbCE5mDkHFMQ9x66EvVnHM1Ku/f7uFguSaWbBYhRgPomiza9YxKqBB+ZUULqCLjGEfUbBWVmiV9XmUeWaG1p26kpViEeBjVimr+xjFN49MYNUPs/mXs1WNHFpLQyD94YBhJmMY48Iq7wZ1eva5PhcZqP+fkDeSf8YGVhBG4yhzjdoFA6SxyMR7S62NcNu2vjlU9b39cxR0QxiP6qGKIQPNaQuP+suJI/xeqYcpykgAIDM4WFLXIuilbaxzVnDNXRNZrJxNmp2MNXTWWQ5sfpYZSjC03Kh/b7CiTj575zapSnD3S8sIXGgudrKVENoC6So+BKCLPlvPv3sxPyAMoyhr4rRMc+ygIYX/DU+V9WkI+/QOLgdHhoj1tGGnjYrrclWxPNiZO+d0AGciqYb1SiLKFfFnR+qlKPBymeOQS15VxS8Eyw5jOjlHPcxsMLxN+rV0AwmiSA4Jq6kjqirZCVm1Mg6vpyyWlM5lO4scgFY3ZVlIgr+HMoWkgsvk5WuA1oKx7GWIN38SaaRAPwhV244+t9qBrAhQkQgMvd4YuGLS0os+LXMrUp7/8VtkUMJjHNaiV18aNFXtA2fkZIfPIW9hy9mHtKg/EBX9B7QiWGPHxWuCrdPT+GIV3omny+TmoJQ3zpYB/pceiLSpPlPSk+dO2Swbj/v07DESWuq
 puJoKM5W
 aJLnrB/+AoR7eqj1j1VlsJkh5o67nOdCND1SzYzueWwqcICWKi+0fgRDPrkHCdsw9yedORLeIvYQ+CoFbc3uDOkUB6nl1VXVDBT0zGf+h4jheR5fHKJH75dfRzA+tehtKu2Gmauz3X3zKEaYrdHSk5/PA2OU5Ehs7TFzJw9yJKdfedKvduZXn8NN1Kc6pohOyVgbRQ2CaVa8+Uw/VdhBVnLJQ2ziI11vpj6+nvuZimWN14Pc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page_cache_ra_order() and page_cache_ra_unbounded() read mapping minimum folio
constraints before taking the invalidate lock, allowing concurrent changes to
violate page cache invariants.

Move the lookups under filemap_invalidate_lock_shared() to ensure readahead
allocations respect the mapping constraints.

Fixes: 47dd67532303 ("block/bdev: lift block size restrictions to 64k")
Reported-by: syzbot+4d3cc33ef7a77041efa6@syzkaller.appspotmail.com
Reported-by: syzbot+fdba5cca73fee92c69d6@syzkaller.appspotmail.com
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/readahead.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index b415c9969176..74acd6c4f87c 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -214,7 +214,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 	unsigned long index = readahead_index(ractl);
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
 	unsigned long mark = ULONG_MAX, i = 0;
-	unsigned int min_nrpages = mapping_min_folio_nrpages(mapping);
+	unsigned int min_nrpages;
 
 	/*
 	 * Partway through the readahead operation, we will have added
@@ -232,6 +232,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 				      lookahead_size);
 	filemap_invalidate_lock_shared(mapping);
 	index = mapping_align_index(mapping, index);
+	min_nrpages = mapping_min_folio_nrpages(mapping);
 
 	/*
 	 * As iterator `i` is aligned to min_nrpages, round_up the
@@ -467,7 +468,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	struct address_space *mapping = ractl->mapping;
 	pgoff_t start = readahead_index(ractl);
 	pgoff_t index = start;
-	unsigned int min_order = mapping_min_folio_order(mapping);
+	unsigned int min_order;
 	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	pgoff_t mark = index + ra->size - ra->async_size;
 	unsigned int nofs;
@@ -485,13 +486,16 @@ void page_cache_ra_order(struct readahead_control *ractl,
 
 	new_order = min(mapping_max_folio_order(mapping), new_order);
 	new_order = min_t(unsigned int, new_order, ilog2(ra->size));
-	new_order = max(new_order, min_order);
 
 	ra->order = new_order;
 
 	/* See comment in page_cache_ra_unbounded() */
 	nofs = memalloc_nofs_save();
 	filemap_invalidate_lock_shared(mapping);
+
+	min_order = mapping_min_folio_order(mapping);
+	new_order = max(new_order, min_order);
+
 	/*
 	 * If the new_order is greater than min_order and index is
 	 * already aligned to new_order, then this will be noop as index
-- 
2.43.0


