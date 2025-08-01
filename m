Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A973C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A66B6B00B9; Thu, 31 Jul 2025 20:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6314D6B00BB; Thu, 31 Jul 2025 20:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F96D6B00BC; Thu, 31 Jul 2025 20:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38C946B00B9
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:27:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5ED5C0BF4
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:47 +0000 (UTC)
X-FDA: 83726300574.11.398F9B5
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0DEF7180002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MDVS6bHX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754008066; a=rsa-sha256;
	cv=none;
	b=l7XOcnFm0Z8FGkwZr/IF8qzhcwfvlQVTANijzWZGPtDCmu23XeflwPA1HjoT/SWJ1WGccL
	R4VTmIktcIbrJHkfKIlUWDrOb4cCXoZa45HIbv/DiQpAYayXjb6gWXXWhwAhhPgtYr/jQs
	LtqymaWOs/VFZx5W216DApalc++rawI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MDVS6bHX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754008066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iL5+/Du77zPuPT5BBdeDwRBoU+0kycMSYogQWZ1wZc=;
	b=CVswAEJI3unJ75FmKfTvfgAOZ5fsDG1b0/ckpAUbF6DclKBQHFdDCEzdVq6LJvGy6VMgyr
	TvtE+fwMljVb9P/Ya2sCXBtTdt5xkjf+Jn/v5yhmbvi+CsBS0JDZgamwsKMth0DPsn/dyD
	hqHDyOL37vv58E3FDeLgCl9GEL4crRo=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3137c20213cso1196480a91.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754008065; x=1754612865; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2iL5+/Du77zPuPT5BBdeDwRBoU+0kycMSYogQWZ1wZc=;
        b=MDVS6bHX9q9+SIUF5vopVHx+Mfd5ikUpbPT+8bhvEaEdi3+pZpBUeX8f1jpMgCjRvn
         DdbfcvXqQdmhZfxAjuCzh8GPgzNi7NyV4mQlvf2aiMtIXE4LO0aY3ZstEYdBYL2ApQjo
         +W6mnUuu9lSoqrmnkQTmlfaPQYeWywBrfqjFiLFYpW2F3NXBWkjv3SBUqZZS+UF4uL0l
         f81YRcUoC5jM/CzlS2/V7dIw2HOE3ioFZNn0Qcn7H1qAAiyn6elcG0kQf+8sPs2sCjoZ
         N5BjO6XXPSQQqGs5C3etAPIIXA5U7ev1Iv9LRGNuQdPmZP923UDV9l7Ge5zHBCvzYw0K
         q4Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754008065; x=1754612865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2iL5+/Du77zPuPT5BBdeDwRBoU+0kycMSYogQWZ1wZc=;
        b=UIgYua+LIQF15I47kdXsJ5uv7e2huPw7uNZjWn7uucp4IPs+9NAlt4Nqn4CehUXKzd
         AP0mjx87ENrLm68uO+feyFx8QvVWGBsRNJtU4FfswlKLhEIadPP9HIUWfKQlAsM1DMAN
         OQ1if0zYAzoP1BeAcE3nRi6aGhGiqi8kg8O4KzszWUfBRGglhpRotoKQyoEqKKMTHiZ1
         41TW1OGA1/QgmOfW8UlIJ5KjVw70Z8ukSLMLRMXzpn+/PysupqWz3H72MTgwSAiMQqkP
         3iLGxEN2DQFMdH7V1fygiVU1TheZD6HPumgYdUPdXLlpG6LHtM/QbzJsDB12KH2RA6R6
         0TIA==
X-Gm-Message-State: AOJu0YyYfgStKTJIwdCadoN+zcyN0otCHBh9yu/0LFvM/KEYTFSijO6y
	8vNOFcUqlHxq1uNBixQmcFCnmUI9nE/s0qCNeWEOqvY9Neqheskv0I7B6O5xJQ==
X-Gm-Gg: ASbGncuYZ7H4qfvYd4dgwBE9pMosj3v4Z3oYf3XX7GptloQnp0e3h68VOfVHgdK+jl8
	K5rz1TEYa5RADMC88iVRJ+g00Ds31aQB8U8Gf7/rExLuVqFT4c1o/e91dDsYh7Ap3yuWmzsN2f7
	WF6xzU/vFQQCAC1Y56u9DPvMkhAZ+npbrMn5GdHQvhjPAnxFi4j90Wed53dAkyLdNM0mCTY7BMz
	RRz7tGKb18Rzv9BXiN7jjnAbPWsqmFqrqEHXayXwvhzihXHRL03bYH+elRy6KFXcv62Ttt9BrjE
	pC7bpToHYMEKSla4IQ/FCQ5/szUCwP1ySsbGP5Z8hZK1rsHi1V1gHK7afkuESYm58B4w739PPy/
	XN03uB94c8pHdHZt/qg2D/nNQ9TQ=
X-Google-Smtp-Source: AGHT+IFTYp2XQLCKe8uWgctEzQRHy84xjDVpnH4CLvIVboTXgumwtlR+C3477qy8FGVR/8oe4PAq7A==
X-Received: by 2002:a17:90b:1d87:b0:31f:32cd:97f0 with SMTP id 98e67ed59e1d1-320fb779607mr1021381a91.1.1754008064549;
        Thu, 31 Jul 2025 17:27:44 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3207edb588fsm3041461a91.27.2025.07.31.17.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 17:27:44 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH v1 04/10] mm: pass number of pages dirtied to __folio_mark_dirty()
Date: Thu, 31 Jul 2025 17:21:25 -0700
Message-ID: <20250801002131.255068-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250801002131.255068-1-joannelkoong@gmail.com>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0DEF7180002
X-Stat-Signature: xh38nqbr1h8i9cdzizhgnq958wzbp5p8
X-Rspam-User: 
X-HE-Tag: 1754008065-628248
X-HE-Meta: U2FsdGVkX1+2h3RHQmvrpmd14QPg5uj77w9aKI/BKoIUjD0GdisWu/Nof615BcoIEOGBGJnl2ur9fYumK1stS7uvnnQaHba/E0/cX86X+yIKpWTn/wscOI7dUmSIqWGcPWjbLtozYPNY4sUrD3YGy2Et/hiBihhbha3rYc2Yd4gR7eVyz92LOeNDgjv7FHCQoish9sGcr6BGh0J6O5kXGHSBdqIh4Kaa32Ymad+jH1zlQgpv7YW+DRBn+B6jJoReqcCXoYxILSPdTuh7PDHAzX5As2WVM9YMGETBvCQemyYW4xCDPl3JUffQqZEOo3hThvpb9MXGWt8+Ungys4t6a1xQ4jGd4l9k0mZoMzR4L6t8cu058ofRBbl2B1ZVoeXzJaWgd0aiklPH5/R4U9Fuo5HZLpJNSe//FO8PkHmX7Dluq7FxNTYLvEvG1BmvHUNsKMH7XBIAPGjo1N27yWTRYkXNH0PkjsbIkWdynKxeeAWeu0CM1ktV6KgX3d/o1K4y1GK+AWKoXm4d1mA+9wNOAzT8y0FvnUEXo/OEEO29RFwoET5/wfPQ+GmZ/W64n6SBWi9/CU9A6Y23GAAG3QQsV7oWkt+2XuAqIyxBttnmT5e8aFnCXjcCIzye4gN725fqL2W4P7QjGxoOm5lmgP41KV1et5Mg7mSWC98JJ8yAEYFocNf0821uY2Yf/m5Ez1fzPcJr31+va+Ba60NNGrbOJjp6/FajwNsbMjc4VEEzMQaEionsQUXwJkMytf12GtWsYk2n5F8WYp8lIOPVZDYpC0FJ5SSa740o/PVRiaN8Thmqv+5lFl8rg0cGXaDmqFWtJsCr0M6De1QphznCoiph7dGqA+41rRGf9Yjhq/DRV5APtxrNsUrEZO1I56e7AjOACS/fwyLMlT1DCbbPtM+2AuYAW5Jcn53ojiMQ2Cb+mUt+3slb7lZhd/ycHlqOkSB5SaBl54CDHUjJACGcOGg
 Bhjfy6MS
 FO01OzoCHGwQVXR3BsBCFmGRJ/qDTY14fq25eVUFmyYmxTLrD3Ny7G8EydQQqJLsAYbXYgnkE8lGlQULt44BUCZy94YgzbtYRM7N44CCgjAe0CH4KaTVcqiPRlpggfKThIz5eccjT2wa2mGxFNFuIVGQXyJs+actNb4z00eC3hp5Ep2FxtleNX1tgcZTQFc6Hm3JDhhK9GPp5jST9e04mrtyUJMpdZF/jJDVn0kcl5+dtlXgIauiGp2R3M+OQkHt+X9aZwVJ4jEIf2vZdxW5ungwvTfd1MGDvtRHV6mAPa9ZMkR4+kcx1qzTqhxbZwK2bCY9JflAMuK7oVhQ7PyNe5cFySuMZD1F0Vo6jii67kYH9TdLk0x1+ZtSYvh95fpDB1mgS30BaicaaNEOYwhSr5t/24OZ3Wfnvrl4ITY17S8sNXaHNMxV73n6uhJ8y+/QUo7FpMYnpS2S7qIrK4hkbr0kOhGymzE4yDXC9uRwZDi3bsiqcs4ji8TAO98m/X0pSvXdXkBmaL3IG0Fy8DNP2xh+meVK22c1frhbNSbfwXsP8VaM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an additional arg to __folio_mark_dirty() that takes in the number
of pages dirtied, so that this can be passed to folio_account_dirtied()
when it updates the stats.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/buffer.c             |  6 ++++--
 include/linux/pagemap.h |  3 ++-
 mm/page-writeback.c     | 10 +++++-----
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 8cf4a1dc481e..327bae3f724d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -751,7 +751,8 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio)
 	spin_unlock(&mapping->i_private_lock);
 
 	if (newly_dirty)
-		__folio_mark_dirty(folio, mapping, 1);
+		__folio_mark_dirty(folio, mapping, 1,
+				   folio_nr_pages(folio));
 
 	if (newly_dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -1209,7 +1210,8 @@ void mark_buffer_dirty(struct buffer_head *bh)
 		if (!folio_test_set_dirty(folio)) {
 			mapping = folio->mapping;
 			if (mapping)
-				__folio_mark_dirty(folio, mapping, 0);
+				__folio_mark_dirty(folio, mapping, 0,
+						   folio_nr_pages(folio));
 		}
 		if (mapping)
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 312209e0371a..0ae2c1e93ca5 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1204,7 +1204,8 @@ void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_pages(struct folio *folio, long nr_pages);
 void folio_wait_stable(struct folio *folio);
-void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
+void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn,
+		long nr_pages);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
 void __folio_cancel_dirty(struct folio *folio);
 static inline void folio_cancel_dirty(struct folio *folio)
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2afdfaa285a6..b0ae10a6687d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2677,7 +2677,7 @@ EXPORT_SYMBOL(noop_dirty_folio);
  * NOTE: This relies on being atomic wrt interrupts.
  */
 static void folio_account_dirtied(struct folio *folio,
-		struct address_space *mapping)
+		struct address_space *mapping, long nr)
 {
 	struct inode *inode = mapping->host;
 
@@ -2685,7 +2685,6 @@ static void folio_account_dirtied(struct folio *folio,
 
 	if (mapping_can_writeback(mapping)) {
 		struct bdi_writeback *wb;
-		long nr = folio_nr_pages(folio);
 
 		inode_attach_wb(inode, folio);
 		wb = inode_to_wb(inode);
@@ -2733,14 +2732,14 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
  * try_to_free_buffers() to fail.
  */
 void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
-			     int warn)
+			     int warn, long nr_pages)
 {
 	unsigned long flags;
 
 	xa_lock_irqsave(&mapping->i_pages, flags);
 	if (folio->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
-		folio_account_dirtied(folio, mapping);
+		folio_account_dirtied(folio, mapping, nr_pages);
 		__xa_set_mark(&mapping->i_pages, folio_index(folio),
 				PAGECACHE_TAG_DIRTY);
 	}
@@ -2771,7 +2770,8 @@ bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
 	if (folio_test_set_dirty(folio))
 		return false;
 
-	__folio_mark_dirty(folio, mapping, !folio_test_private(folio));
+	__folio_mark_dirty(folio, mapping, !folio_test_private(folio),
+			folio_nr_pages(folio));
 
 	if (mapping->host) {
 		/* !PageAnon && !swapper_space */
-- 
2.47.3


