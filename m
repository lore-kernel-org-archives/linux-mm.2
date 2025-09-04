Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42666CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 09:04:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D1AA6B0008; Thu,  4 Sep 2025 05:04:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8D36B000C; Thu,  4 Sep 2025 05:04:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BF016B000E; Thu,  4 Sep 2025 05:04:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C0896B0008
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:04:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A4945C45D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:04:33 +0000 (UTC)
X-FDA: 83850982026.23.2A6BD4B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9BAFB20007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:04:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Msx6Ilfl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf13.hostedemail.com: domain of andriy.shevchenko@linux.intel.com has no SPF policy when checking 192.198.163.15) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756976671; a=rsa-sha256;
	cv=none;
	b=ugHmqr8HgyhM7Ue1Y1goVGl0SnCekitHDavIsYEet/Qw6ggUrY0kSaWuq8U5dNbD7V/r5M
	6oipIeUdwjZhkyxrzL2dMI5Du/KXKR+Ax78Qq6Ijjy24Y1NtrogM/9yzsmkZncpTtE6C1E
	OI/kFe6CnB4pvO4Qt/Fx9omdXGASQr4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Msx6Ilfl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf13.hostedemail.com: domain of andriy.shevchenko@linux.intel.com has no SPF policy when checking 192.198.163.15) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756976671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YWTIeZ+TzQnKknsO5jMn6NxuT/jhvsaId5zo+U39dgk=;
	b=egD3MDEESNjoJMIqZXHKP/arpLZbyycrsbMTBNfH8L6puPMcmhVgLygeQ7aoovjevkXHQ7
	I+Edvd27DyArjxeVqDkj+aAhJcMfiN0UbXF2R+8mPxyHdddsf5Zq1AHiYBmEJp9XXb/HTO
	3gIW4ML5SVYUSmOGn9gt9ewD43eeDxI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756976671; x=1788512671;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=l6j2BAL8B9Jl9DGCMUcF7Ikqoa6pnHZsWN8KE462QuA=;
  b=Msx6IlflMBRtSnNQf47WR4A47JBdkAJQ8YqFLQraU/qINLSGkLIXEr5A
   Fwr8R2jaWJopHaYFU3f+HL1bTFc/e5pQ7U0fHrZZ09Kx7aMir6QL5j/v8
   LBn3Syr6uNa1bsp9xjxgLurIuXU4dNwQfSHSOL4PYn1uaAZMK2AcpilP9
   fo0QhWTwdAhiVFgg+oZ0jpk9kiAb0LD71d5GGgkYQg8jI0rvmxMk/rjuJ
   yNYGMXqwTpbE4DUJXrCI7mNtlv0Z7a3CiFCQF/oVy/MG3DmsKSL6aaVNC
   vtME3mbMxzKeOe6C30916hcNWVaVdtXT0ZLzvDhY0J41OnZvQ7ZoPD1ys
   Q==;
X-CSE-ConnectionGUID: 4buC9nLFRv+BjKcFvx1KMg==
X-CSE-MsgGUID: tcDXZ0QEQYWYsFxGDhiU/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="59418323"
X-IronPort-AV: E=Sophos;i="6.18,237,1751266800"; 
   d="scan'208";a="59418323"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 02:04:29 -0700
X-CSE-ConnectionGUID: /g8fJMWZRRO37IE8lAdetQ==
X-CSE-MsgGUID: mHNykIaaS0KaF3glhfuDAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,237,1751266800"; 
   d="scan'208";a="171771381"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa006.fm.intel.com with ESMTP; 04 Sep 2025 02:04:26 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 0321794; Thu, 04 Sep 2025 11:04:25 +0200 (CEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] mapple_tree: Fix build error (`make W=1`)
Date: Thu,  4 Sep 2025 11:04:23 +0200
Message-ID: <20250904090423.2293933-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9BAFB20007
X-Stat-Signature: ac3gkpdyjr4ytm755896rox97nmpjxzu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756976670-255883
X-HE-Meta: U2FsdGVkX1/YrDJl3SoKMhqZmKO/SIWqBvBoePQ2+xRplUvYeuEgLETXzULrR8lEFu00cGXoTvVHaNohBNuln2+dgJJH4mxFIwaov0T/cEOe/zi+xZbWlZ0n/jQBwRuBd3IBZGREU28pQzBQPTwhthiMjBVCDFqkVKhgHGi5gOpogfTadBqMy9Ki+h0uSO8+VvqdKXEzYQxTO1aWJ/IfIuRqsSQY8lds55c135cbS2ZQDqTuOK6qKFv/7EqxnMdN8cmvvQxo8aYvRwJkLd1hnVjo/uguO7yz+fs3O/AktG9Y0Mb7SFfGifrniJYLipq/2YiDvc8a8fFQg94wS7FTviJpVD1r7M9jCZNjL/r/WG+wtlEs5x5jE8naajhTwA0Cy7tSvixh4HSy2GNxyUC6EfHUmZ7GL3P/g9kF4Y2i+rfoHXn+O+Zk2Wg5cAI5oPPmz/5kDQoAUcWFJWUKBuMb7KV8KZR0z0SLkG9VFIxveUYjttxfZUlzlX1me0bNIi8Vi/w/HBwZqaPtIaKKsioSR0S+GiARM4mAdn76B+JOQ6HCf84L9Rj7perN2C9K72BHDNMC3yKbeLSAFHjYPcX4qVic+Pq/byiJRAeucx2Z3jnm1E0ICu8AwC3eZNgWbm6GjyXWJf0leS07MaifpvuBMhUo9rUwao6IX/ME0cKIc4zrwe5v5fkr5u5acnlnkIywfKpzWT3Behbv/H1R70otP/9HmiZVa+Wdo/Ts14Gv0OsQ7c79uhJdo6D2iLcF3iMrWqrh3g/1i7ncQ7LUVp1Zj/nRLeevs+kXQVRoLSKHUaa6UVTgl9zWlvpP/i8qi27UmKW3m9GuBx+IFx6K2C373aKvBbeDNqu0ttfoAWGC9piRGGFVMukMr7gOxBe0X8UBAyv5dQjfvkkSsan1y7hy6riPdnXYzbQh7nZeh4Pa6G1mTbxZkTbUkmG5gIxIWFDzwG3sM2/XB9yZEOwdSMz
 An7ZF3+c
 VOHPoqZjiatadWh7cs6Eswru35SGKIXYIB5PDc2OG2d/+F1tB17c7NLu7CctrERNHJgGPi8nA9qWR5pvVpVmnMyN/M5g4MCYZLiM7wywZh17hJ9csYOAofJNC//DL0hoDLFSscyym8eHdvmhKw82tLusbMa8KywxBr0YFzDMDeN+cQ0N8zqiVVeiid/VfeKttqPRnkEjg983p4EL+QEFwvFSeb5r7MoGgkZXNuqyHaXbgzEiSTO6JLYnkwvA2aYLKLutjAXQ2GVOW2x2B22wJXt9PdgVY0QSMxWrH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

clang complains about unused function:

lib/maple_tree.c:179:19: error: unused function 'mt_alloc_bulk' [-Werror,-Wunused-function]

Fix this by removing unused code.

Fixes: a48d52b2d21b ("maple_tree: Convert forking to use the sheaf interface")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/maple_tree.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index fce329d6c1b2..ca8b3c2e0362 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -176,11 +176,6 @@ static inline struct maple_node *mt_alloc_one(gfp_t gfp)
 	return kmem_cache_alloc(maple_node_cache, gfp);
 }
 
-static inline int mt_alloc_bulk(gfp_t gfp, size_t size, void **nodes)
-{
-	return kmem_cache_alloc_bulk(maple_node_cache, gfp, size, nodes);
-}
-
 static inline void mt_free_bulk(size_t size, void __rcu **nodes)
 {
 	kmem_cache_free_bulk(maple_node_cache, size, (void **)nodes);
-- 
2.50.1


