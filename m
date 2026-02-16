Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 968BDE7BDA8
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 12:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F235E6B0005; Mon, 16 Feb 2026 07:18:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECFCB6B0088; Mon, 16 Feb 2026 07:18:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDB5C6B0089; Mon, 16 Feb 2026 07:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C77136B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 07:18:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 534CC140D7A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 12:18:00 +0000 (UTC)
X-FDA: 84450221520.23.B1B8D3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id BD2F41C0004
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 12:17:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OSemA52u;
	spf=pass (imf21.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771244278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OWX72pi3lXEUfagrehkEBiry/odtJdRTv9MQDTjMkPY=;
	b=R2MferokE0sYzse1+4HZBuq9qjULna6G1x23mpQ1dMy51fxx7bDb3Haxfx53kg5Dcx5Nb3
	Aj36HCcE7Zf4nMnkPBuW2fNOQ4jXdZDY2agRAbQF2Q9ot1F/kPcrg4uaUnNVF0fP3A3fbJ
	hjgJJQUYqxVRLDIR1TFrCrnLUkgpyjI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OSemA52u;
	spf=pass (imf21.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771244278; a=rsa-sha256;
	cv=none;
	b=au4IAjAJ5BM7fpB6Z4gntWsCBRZK9tSXd2VcugqeRTfe2LstcUiDLYLHL36nID3XoJyU7q
	aU97gsoLZbGRZUf6Mx8Jf3l1M5TBetweMFZya6gq6Z1W8w9pVvXPfS28CBipZhTDD5hak1
	T6Y/NK65UWlIXN4GLCNRw4NyJzijXT4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3ABF4068E;
	Mon, 16 Feb 2026 12:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B5FC116C6;
	Mon, 16 Feb 2026 12:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771244277;
	bh=+E6U2vTcOf3pypRLjDQO5XE3le0jSDZ9Tr+xW7xT/qs=;
	h=From:To:Cc:Subject:Date:From;
	b=OSemA52uqh7Iq40ggCxCqiZhqXfsFVOrcIFgd3Rw9ZQKl4k/4P8jivjHrf8kiQx0P
	 +L9P90YFZd5MtgNUuSeK0TziUg3SYsaI9woWafyC8Ka/5vyLV8QGCRWKQYnwEVxLw3
	 2lImbBHvCcBHQKOXQBBck9rjS1q+3lb4UTrC/52T41Chhm2WX985CP46tIgyd7j+g/
	 m7+QYfnwx3+8xCg5TNk4sjaZlGiuN8iUkxo3510NPN7sZmLsg8HUn2LagwHn3lA8mL
	 XGRZxDbZSAu71SIUZNRRdhAQ/HjTSGuS/VkIaLgArsxOnymk6pBPfF6/arGonSOweA
	 yqyQ6rnNdvR1g==
From: Arnd Bergmann <arnd@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: change vma_alloc_folio_noprof() macro to inline function
Date: Mon, 16 Feb 2026 13:17:44 +0100
Message-Id: <20260216121751.2378374-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BD2F41C0004
X-Stat-Signature: e344hnh4xd4btzbddoir3ir7t7mhzqdu
X-Rspam-User: 
X-HE-Tag: 1771244278-658413
X-HE-Meta: U2FsdGVkX1+PXrwg0/H4ZJK83iAbUJfccMsqrbcuItiBa8KdGofufmR+GX5FWoABKVQ0+BZuG4pMo0xhq3e7xpq4F37mqE+840Qz1uZ11b6mxT+Bfl+auduV+SMwN15rUnJuOM+djsbmEZE6ZfNUQvY7Gs07qREmZ2c+Z1NDsiO56JfID74dHsacisfgEPir9LTD1rEFS3sj3m/3n8S2lMWBlBmZ6FY044uPZmRbYTxMzLiI5jf9xj3YyA/UzprJCLaU9yM7rG46xoro1FzT59SdJ3FA2pybe2sfyaOu/eWGi7uBSi+UcYe/b4hR/oMvGD7dtBHAMuhfYzXRj9YVpDLDzCMS3CDkDr7jrXeQV7NEF79YjWOtrFlDT7IIeNSuziOw7yl0+JA7Qt9lXSQ8Jb0zazpw0Xmx7a0KGSgEHk40DndyWDvLxag1+paCdsbkghbl1aYu7t9UhvAEVq3Lyaxbn1Ob5QnEhgSV7O7so7f0jBi1f5cD5Pi/00XsWVzLRlVODn9zqwDPlRXeA1rF/ebu2a1vb4RPfWP1KXl4tYSapAseWvxSV6uibCVVdRy831EMIurx5bbxnYeIAL+aXUtJDQF8y3EGOxcsVqV7jlYDFMiw4X76Ca1IeJecMpBOi8vB4io1Z1u4LfXazU6vv2haNw+Tbkhek4TmSFHony7BYz5r5E15+5QIn6CQB7H7Ol3gezwiqUNoSQsI3vFZIKkZrLutHYZiTW/a/GccvO2Dei+Vdnloex1HvjwLgXNk8wTeQr14eP5f4Fh58E23NnbGNTXl518UBPhvMF3kcACV1x00PaZi2nM0YHtWKziVn+tvdEJQiR9m/UHIZnuP5qJ7mDA1OWwNFLB4OZzbR9z2TyqjrBKhUaapGK9s0E5Fjjpoh2K922x7BQs48zI0jDTQiMK4Aqjx8lPnszNL12CT140t3Bv6N+wKDDFkcRI1ZuqlEzEgh639p1b2MZW
 NtTC3V4F
 cpUPjNzQ9AkVohbD8wybZKQcNasLPLhFm5ijXV3U/sTpRO38hO55McQ9rAwZzxPpsdroofhZhWqi+VJa/yAaRxeWRyj4ZOgROLKERDbpzba/XqTncvOVXBsXiCAM8NQO4B36uffcDEVbtZyeXjJBGTvllqHwn11le6EXCamUNOdwwMlaumTiKiUTKdk/56HQw9cjSZfTWOX1XP8ZPULZG26Acx+DopYWRfkJJn1NUaJoszDqd6EqK3G0AFZzxMqP4i9mCXNc+RQGSXedbc3v2lyPyOrIjLGYbcHJOyYrhAYGdXzwjyxy1B6rALLcikesekiv3C0RDVqdt7dI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

In a few rare configurations with extra warnings eanbled, the new
drm_pagemap_migrate_populate_ram_pfn() calls vma_alloc_folio_noprof()
but that does not use all the arguments, leading to a harmless warning:

drivers/gpu/drm/drm_pagemap.c: In function 'drm_pagemap_migrate_populate_ram_pfn':
drivers/gpu/drm/drm_pagemap.c:701:63: error: parameter 'addr' set but not used [-Werror=unused-but-set-parameter=]
  701 |                                                 unsigned long addr)
      |                                                 ~~~~~~~~~~~~~~^~~~

Replace the macro with an inline function so the compiler can see
how the argument would be used, but is still able to optimize out
the assignments.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/gfp.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 6ecf6dda93e0..23240208a91f 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -335,8 +335,11 @@ static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int orde
 {
 	return folio_alloc_noprof(gfp, order);
 }
-#define vma_alloc_folio_noprof(gfp, order, vma, addr)		\
-	folio_alloc_noprof(gfp, order)
+static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	return folio_alloc_noprof(gfp, order);
+}
 #endif
 
 #define alloc_pages(...)			alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
-- 
2.39.5


