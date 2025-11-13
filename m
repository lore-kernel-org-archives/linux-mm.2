Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 398EECD4F5F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CCB38E0012; Thu, 13 Nov 2025 03:40:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CF98E0011; Thu, 13 Nov 2025 03:40:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B93C8E0012; Thu, 13 Nov 2025 03:40:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7D98E0011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:40:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F73412E5A3
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:40:45 +0000 (UTC)
X-FDA: 84104938050.13.400B2CB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id A4B211C0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:40:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wo4KLlMu;
	spf=none (imf21.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763023243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K12fvQh8pMGfv6CV6QCeUJnLZLoYfhvqBb771xU59eU=;
	b=GYn8HPmjt0SfK27EUVftqq4Uzy4hwTWxVMzW7t+NByOxwKRjfxnXZzxwzfgbHkI8c/aX5W
	ulKxf7pa9kGSVPhdWEkNJviZIXezOIDHgo8dV/R6MbJAcQUNL6wBMAhaueAUIQgOvyTyGr
	ZdUD7L4eETnCJLZbUo1GuMy65JCtIwc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763023243; a=rsa-sha256;
	cv=none;
	b=8h33S5pp3zWcjAD2o309MxEez3MMhjlwo5GiOCbkuswLsUC5uIaofJkUPPRS0LCNXqXurg
	ubK9j+hTBsxpIzfdNDx2AKbceOWAUZPQ+tXDtiMgXwOVzkwTD9BQ0xtBaXT/GP/rMUrilS
	lmTEtnTtrWz0Of8WoX42yS5+XP9dtFU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wo4KLlMu;
	spf=none (imf21.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=K12fvQh8pMGfv6CV6QCeUJnLZLoYfhvqBb771xU59eU=; b=wo4KLlMuOIxlkDaLjjeymh3m0y
	Nq5r013Qe/vqol7Ae+oH6KXXU8JBYs6M6ShVrHvucuIwt/gPb755LXeGHvfnK2xQ1lq8dq7UdP83X
	cJv4p7bVk/jEnPJ5RKv44j81ZNK2dXvzz5b2YafP6XfHC3giifuMzgDj4ge1fzUciqRuvUbIY8HDg
	6gPQmMucPeyv88rg5viknD6dpAmBt2ZSkV/wXF3ob5vC42mDBSI/waUaejdLWmrn+R/1WL7ryZ2YU
	+AiAgtPE30hZYmmXkUdWptFyM8/U35hDXMWnUbgZDm+JdojBp+Z41ouDKijXFkMBRwrE47LcoJDVz
	qPPjtPKw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJSsi-0000000A7OI-00e8;
	Thu, 13 Nov 2025 08:40:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] mm: improve kerneldoc comments for __alloc_pages_bulk
Date: Thu, 13 Nov 2025 09:39:43 +0100
Message-ID: <20251113084022.1255121-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113084022.1255121-1-hch@lst.de>
References: <20251113084022.1255121-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A4B211C0003
X-Stat-Signature: yxmitcrqehw976pmqnkpr41p4tyu6gg5
X-Rspam-User: 
X-HE-Tag: 1763023243-858220
X-HE-Meta: U2FsdGVkX18ijkIubjQ0bGwt2B+BbYzCarIIP8W/pRcTqGt4zCJnefYMNiA9sZUfAxZrq2zY6IYwvO4pHkH3pvECqTHtN8IseymdQO8VBX7njzBO8QoFprwcPMmKw6qpaoM7GMY9KiAztlZXEw+RzhHlxUVACDd1i5krPfFaFoG7Cc6bgVqzS87H0jEFSX4yUJavzgF/RKS2SQtITUZZ2QRTL5Axim3AZFAB5QtX/CttxI7KqgnZN+dsrEKYkQthtl7FV/JRn72aI7wHVzryx22F6cm7yxieQsINl5ZEhlhHZSgvkhv9hGLFtfHYD7o53L5QF2amss8UogW2UzpR2k0YuSZdw72RG/ViitH20/kGAJNRV69dzUGTMgdPLpVbiVrRfSlJIsV3GWGgsJ4EwXLou3N5GTBjQemGnUINlfcO6QuaHfFAZ3uUHwpACdb03dxyG853KEWgMjvoZcUX4wFHfK/eTzgxs3QXRepWsrHNkDkJlrNRo5AXg8W7LBVQynLo8qwPvVtxVos6yqDK14dh8Ih02dVZtQF/gO2AzcJ+/N3nlp9BWUSKXjnc8iNL6t/JWOfu6FBc6ZB/pqeOoNJZs5r0hdkK9dPHS9xiTntoUHnH8WryKDa6vGJCe/d8VEyzrmIk/CeCiWQoR+KuAHxT5BDDwt2MyieILOATynVTdwj0fSwQgO09OzxNRJQpAF5qBthNVNMhDc0xS6fLR67eySRl1Nb9TNSXk97h5NYgtUHp1XTeq94N2NPFFtQsHfq+OxMV6glFYsY/HEZAQkJzzJWX/mujgULP4Lnpx0SCwfSE2Hv5xPpnqSfkkEr0CEnuScr7cfnRrnAUnNGD/DvNpCPg+y9GtM8BjNBcJqwLPrhVioUnNY+0OW0o4BfzX8aa5PqrrrZu9tk4n0jRmLKXggIt33gytBo9NM7JP5eGv/Yq6Mq+/qouqcSvU6mCN9IcnUP/DZVLF8n1GhS
 vTVTGzrB
 QlCzaC1EB93YJLJBRxgremOqTsHQwYnY9TExCd4zDGvnxNmW2BlQKAoladpCeANdnYXWNDVdu1JA7NYHce6ula5h8iysMbKiXZiW5ptK4cKTgy5nILpqIIKn8YR0rSI3OIt9I8S+RWf9CNq/5W7/WC4ddtop+KONT2MHgb2cwIaq/CYjF+bVadTwT/UO3GVeEQfO2dFsDcy6wsDR2p6ZWl9ZipPvy4vQGWd+uJKGvL8KAvjdk8lo7aQs4ni60bdfaqYZF4AkAWd+7Y/jxMwHD1JFRnahWoHGm3sr3lV2/V7JQxULp2NTfxeErFNKv3mS1Q3+pKJT7lNy73M9SkU2Jl29kvHSYQFvcRuSq4vhhdHv00pXsa0rI0J5vHJHHMv9FtVWngtKOQiG2+6/6zvHT+Hw74n2a0PseldHkkaXeLjQjuTwgWHoW/yQmlNql7naELgec03gKDYxNoPEdkHKJD7ZY67b13srfSB0CZYsYx8E9Y3Ij7svAj3CHxPbmlvdTLq7qFW8LeirquM+2G1Gq/d37iN0E80964mQykra7G9mBH2QQo4bKQ+Z0zWWJ4f266UY5biugKIZ/+xyCaifn1JTZgPMb0xbbXhWu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe the semantincs in more detail, as the filling empty slots in
an array scheme is not quite obvious.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_alloc.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23..b3d37169a553 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4982,13 +4982,18 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
  * @nr_pages: The number of pages desired in the array
  * @page_array: Array to store the pages
  *
- * This is a batched version of the page allocator that attempts to
- * allocate nr_pages quickly. Pages are added to the page_array.
+ * This is a batched version of the page allocator that attempts to allocate
+ * @nr_pages quickly.  Pages are added to @page_array.
  *
- * Note that only NULL elements are populated with pages and nr_pages
- * is the maximum number of pages that will be stored in the array.
+ * Note that only the elements in @page_array that were cleared to %NULL on
+ * entry are populated with newly allocated pages. @nr_pages is the maximum
+ * number of pages that will be stored in the array.
  *
- * Returns the number of pages in the array.
+ * Returns the number of pages in @page_array, including ones already
+ * allocated on entry.  This can be less than the number requested in @nr_pages,
+ * but all empty slots are filled from the beginning.  I.e., if all slots in
+ * @page_array were set to %NULL on entry, the slots from 0 to the return value
+ * - 1 will be filled.
  */
 unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			nodemask_t *nodemask, int nr_pages,
-- 
2.47.3


