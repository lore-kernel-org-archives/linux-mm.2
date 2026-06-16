Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC3ECCD98EC
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2376B00EB; Tue, 16 Jun 2026 17:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B619A6B00EF; Tue, 16 Jun 2026 17:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F166B00F0; Tue, 16 Jun 2026 17:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A03C6B00EB
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:34:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02B86140289
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:34:18 +0000 (UTC)
X-FDA: 84887079438.05.F88C508
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 654EF18000B
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:34:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=I1V+L04M;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781645657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lwNI3TC3ZkSqHP1ZixJ+WWxbe0YFuS4gEBaM5KRIT7g=;
	b=gWx1UtouaeEEIw9QMBhmgQxq+igengO1Yq3hsjPIJOUVHZC51RmNiFyeyUX/kYKE8JI4f+
	XGQ7lLuVDX+d/k8MY3t5yD4uSEfd8DXdeRZHlvQEYEGyYWTF8l3c6wIRQl0VavBHj2F9UB
	um/D9vBLGOQhEQ0FU4QVlAsHy+axZ50=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=I1V+L04M;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781645657;
	b=YNzZZnPxgy0mMopvtyj3G8FEOoH0BEaCpJ1ol3C6vPDPblspJF0HY4yKuI10CLzdhU5lOH
	EERuAtxmZax4kI4nZolsdBJFwP/s3ko9gYCpr8q0wkBOg76OfFB/BatMQGknlfqJDr65QT
	wiasTTFmvF9H42p6VB6nx2cZCjPvx0g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lwNI3TC3ZkSqHP1ZixJ+WWxbe0YFuS4gEBaM5KRIT7g=; b=I1V+L04MelcOTOgv85PNkmqbZc
	Q2uV34S5ntdDUDsNXSknZ6otAZQ71RV6DAPYIFP0pOraYqGqxNF6kQZ+FsBx8U7exhSoRfUmDDhCJ
	TIElMDq/maMiurbZlGJx6QYP/3z7WSXzqp0FahLK1lv5V5nvPruVmQ8A5STUiFmagJZ+NG/JEoYYq
	jJRTG0+EPXOGSbxnLxBepZnEXbC9Tmv5/T0ahjW8EcQDv3nSZw6/fd/pWxzdAJ5e9pJw2CuLamJc0
	U2MG7FgEBw571xw15eVHIsAlGBzvsohVuhFrZrfQCuagW/ildtdRs7/InyGL30zayWbW7ZfNXHQDw
	Va4Pr1DA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZViw-0000000AzBP-3A0I;
	Tue, 16 Jun 2026 15:29:10 +0000
Date: Tue, 16 Jun 2026 16:29:10 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Hugh Dickins <hughd@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: khugepaged: free xarray nodes left behind by failed
 collapse_file()
Message-ID: <ajFrxhGf7loEHUeX@casper.infradead.org>
References: <20260616145413.1491961-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616145413.1491961-1-riel@surriel.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: tg3ytnu9zpdrnjyrupfkax9jfeaij6nd
X-Rspamd-Queue-Id: 654EF18000B
X-HE-Tag: 1781645657-621984
X-HE-Meta: U2FsdGVkX19uhOI/3NX29CduC3+Y0aV9dUEUm6wdDTyn5dK+N0Q9P8lLIzaW8DLywAtkD6SFLHUrqrHPpFiMLumd+A1i5tKwlG0eYhyZ0NHgFszr5MqASeVeuBjEvYTykcbw34dLQkUtNkjHQPSORiZBEdbTFflxERw6o92nq34Df2XwaHyEnS0c0ko0F4VshyL7iVNasnpGVKJC3Es5eiQBLhnI8qA3jOLi4yaLOudwcDpl3wMrfKTk3LO0b1qppn0PpaNp8gHrvx7U9HqxLq2f564CrD+4xzF9lkPR4pzNNQxEgLG/HOp0NfA7XMMl0THePZ6DNdOovwDZ4NCeltCv1kitT4rdvYfr7CJn/S9VLGNzLxJquaFP/iakQNMkdv1kfYS/2/cr0sDhudHq4ggp2vNC97ZU66ZW4YOWED9XRBSdCYmcpIJMGpFS1RYJZDbt+w2cugk0vDecyYE+IspIVkefAhc9LyjDy1EMOn7+WWfWMyEdv2suxDpIRJ0vWGHE7HwyIbAZV7leuqmKnNBNsgQ1eZH8XPMoqUSWHmkliSaqTlRoP/CmFwWD0yZl27wSGSi/NJiKqgW2ymJ9cmG7guxLVBSZ0t2911CeGfg1/ACd4PCrFL8QaFLvaPxgBFLO68jNE9fzjVhoLMIj9ZEkLiuMXqUAy0+0e6ZBmi35QV+8yUX5KQHpBZf/t9GYtmR2woIkSSefSyHUWSSOzsx78JYuC/rRiHFszx+8UPIOsfyCLrfV4kct5d6jGrg0dbfuMU46ldQfddYhQdbjuRsL9a0KgpEoT62+YEZXYBSG8oX5ac0VULeX/YGDA/DdeQiQ8Cj9i4kyNN9iXly4BPTUJ3GfGHVPN+mylvI3vBwF1jsryo0jiSNjZ/ChpKKuvH7T6R1szlU6ug1N+fXWBOo4gKPQMVffMG9OkL7+nTwtfHskwGe09ZeCK9Bx/N89t1nESpQQAwl5oKe56WD
 7AbxsYYr
 KKJOtfWh13+bKUb3TOEzthM14OaI6YUJV00dIyQ6wUFsb02saNvNf+pJkUJaJw8ijvIriAnMB/6+Ps5GWYCRTljpvFMTM72qMiifkpadlslz4OcHxcrH5DWB2kf1+HZ2ggKRVD3cDnTrsQDpOo3xsi73d8TJjaS5oinLnZ+fncFYH5oTNN51ZjYY+t8CS+Af0NyAVtXxV3qzPoCtymI6cZcvok3WCfPoVHQlRPkm/wM1cisvh8mVQcXmoyoTSR94xOiCvtwAjvRZ7x4DVAdGS+1Vv1y/lddt6MIv7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 10:54:13AM -0400, Rik van Riel wrote:
> syzkaller reproduces it trivially with MADV_COLLAPSE on a sparse shmem
> mapping (collapse aborts with SCAN_TRUNCATED because the range is empty),
> and also via slab fault injection, which forces xas_create_range() down
> the xas_nomem() path before the same abort.  kmemleak then reports the
> 576-byte struct xa_node objects allocated in xas_alloc()/xas_nomem().

I think the ways to produce this problem are sufficiently rare/unlikely
to not merit this level of cleanup.  Why don't we defer it to
clear_inode() instead?

reasons not to:

1. the page cache is not the only user of xarrays and
theoretically either of these things could happen elsewhere

2. can a user do this on purpose to screw other users over?  i don't
think so, any more than they can dos the system by bringing a lot of
inodes into memory; we have cgroups and ulimits to protect against that

diff --git a/fs/inode.c b/fs/inode.c
index 6a3cbc7dcd28..d92c5a296504 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -779,21 +779,20 @@ void clear_inode(struct inode *inode)
 		fsverity_cleanup_inode(inode);
 
 	/*
-	 * We have to cycle the i_pages lock here because reclaim can be in the
-	 * process of removing the last page (in __filemap_remove_folio())
-	 * and we must not free the mapping under it.
+	 * We have to cycle the i_pages lock here because reclaim
+	 * can be in the process of removing the last page (in
+	 * __filemap_remove_folio()) and we must not free the mapping
+	 * under it.  We also remove nodes which are empty; these
+	 * can occur in two different ways.  The first is that radix
+	 * tree expansion can fail partway and the second is that THP
+	 * collapse_file() can allocate some temporary nodes and not
+	 * clean them up.
 	 */
 	xa_lock_irq(&inode->i_data.i_pages);
 	BUG_ON(inode->i_data.nrpages);
-	/*
-	 * Almost always, mapping_empty(&inode->i_data) here; but there are
-	 * two known and long-standing ways in which nodes may get left behind
-	 * (when deep radix-tree node allocation failed partway; or when THP
-	 * collapse_file() failed). Until those two known cases are cleaned up,
-	 * or a cleanup function is called here, do not BUG_ON(!mapping_empty),
-	 * nor even WARN_ON(!mapping_empty).
-	 */
+	__xa_destroy(&inode->i_data.i_pages);
 	xa_unlock_irq(&inode->i_data.i_pages);
+
 	BUG_ON(!(inode_state_read_once(inode) & I_FREEING));
 	BUG_ON(inode_state_read_once(inode) & I_CLEAR);
 	BUG_ON(!list_empty(&inode->i_wb_list));
diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index be850174e802..d776a6e9ad18 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -571,6 +571,7 @@ int __must_check __xa_alloc_cyclic(struct xarray *, u32 *id, void *entry,
 		struct xa_limit, u32 *next, gfp_t);
 void __xa_set_mark(struct xarray *, unsigned long index, xa_mark_t);
 void __xa_clear_mark(struct xarray *, unsigned long index, xa_mark_t);
+void __xa_destroy(struct xarray *);
 
 /**
  * xa_store_bh() - Store this entry in the XArray.
diff --git a/lib/xarray.c b/lib/xarray.c
index 9a8b4916540c..ee2459ecdc9b 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -2370,6 +2370,21 @@ void xa_delete_node(struct xa_node *node, xa_update_node_t update)
 }
 EXPORT_SYMBOL_GPL(xa_delete_node);	/* For the benefit of the test suite */
 
+void __xa_destroy(struct xarray *xa)
+{
+	XA_STATE(xas, xa, 0);
+	void *entry;
+
+	xas.xa_node = NULL;
+	entry = xa_head_locked(xa);
+	RCU_INIT_POINTER(xa->xa_head, NULL);
+	xas_init_marks(&xas);
+	if (xa_zero_busy(xa))
+		xa_mark_clear(xa, XA_FREE_MARK);
+	if (xa_is_node(entry))
+		xas_free_nodes(&xas, xa_to_node(entry));
+}
+
 /**
  * xa_destroy() - Free all internal data structures.
  * @xa: XArray.
@@ -2382,21 +2397,11 @@ EXPORT_SYMBOL_GPL(xa_delete_node);	/* For the benefit of the test suite */
  */
 void xa_destroy(struct xarray *xa)
 {
-	XA_STATE(xas, xa, 0);
 	unsigned long flags;
-	void *entry;
 
-	xas.xa_node = NULL;
-	xas_lock_irqsave(&xas, flags);
-	entry = xa_head_locked(xa);
-	RCU_INIT_POINTER(xa->xa_head, NULL);
-	xas_init_marks(&xas);
-	if (xa_zero_busy(xa))
-		xa_mark_clear(xa, XA_FREE_MARK);
-	/* lockdep checks we're still holding the lock in xas_free_nodes() */
-	if (xa_is_node(entry))
-		xas_free_nodes(&xas, xa_to_node(entry));
-	xas_unlock_irqrestore(&xas, flags);
+	xa_lock_irqsave(xa, flags);
+	__xa_destroy(xa);
+	xa_unlock_irqrestore(xa, flags);
 }
 EXPORT_SYMBOL(xa_destroy);
 

