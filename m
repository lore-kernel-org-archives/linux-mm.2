Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D754D1061B26
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1A86B009D; Tue, 31 Mar 2026 06:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44AAE6B00A0; Tue, 31 Mar 2026 06:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3671F6B009D; Tue, 31 Mar 2026 06:00:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 222FB6B009D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:00:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EAEBBE15DA
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:38 +0000 (UTC)
X-FDA: 84605913756.17.C87A356
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 332251A0008
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPB5Vr9q;
	spf=pass (imf19.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951237; a=rsa-sha256;
	cv=none;
	b=C25VkXFua4f45V7DZEHmWIy/FAmWjh0hAg/xwAMNfpjBcMU20WqvGdiR2ohLFFfKCvVgQi
	V17DzXLlnX0G/62o0BASEwaSae7QJAm9E+MunB+lQcdXwEW0K+PS7UCpjrKIDN2aoZFKwm
	qubkfw51vPF05yYYdB9CubBG0oy08WY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xW5ABiJuz0SZngodIpjwN+RMsQf+p1fjg8v/uggLew4=;
	b=G1VEIpTjWuOJE4dWL8HJbJEG3yC7M+CAIIMcK+nHvSGgXAtUTsZC8yLkCfL9xN6GR1gAvK
	6qFbyJH29sWbo09/S3RqOPqcVUYXFNl74OiOuUqvfivVqh6ksJSbATAYlDxfVj0ge7NndN
	nI+LDjhVQMhxpShWmNo8ml4cLDCxh0k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPB5Vr9q;
	spf=pass (imf19.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8737260133;
	Tue, 31 Mar 2026 10:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA56C19423;
	Tue, 31 Mar 2026 10:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774951236;
	bh=xA8iRNbldwAg/IWB0t2FyV0TtMeqN3qjpeDuNnBZW50=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TPB5Vr9qWbumeBuwOxgrV3ajCVGtfgSc04MSZoTzT+N+Ky/SJO7mY400stC8X+YJE
	 zSuozt9uNtYKA5a8FG+ckBKsq4Kqph/USj9t7jAhBSHAllzf7JfpI88qTYUSTv+qgb
	 0md2i+/s6b7xeUV66zkeskIhyGVNndjnX7ggvITFVp0vZ5DyYwYKuXvlFvI23ZWPdD
	 YC9+/VUNcAcCrRMiAnSF8o0zC3DOyjBcW28uUYyd9jWj8H4tltwGYCvV4jxmqyzX6N
	 jwD2sWy8nLEQ6KKpE41NFqxWX6Z0gpHOwzVrhzu6SRQQlrrbVAVtryF8yaMQK4BAbO
	 F5TuUhIiispzw==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 31 Mar 2026 12:00:14 +0200
Subject: [PATCH v4 5/8] mm: cma: Export cma_alloc(), cma_release() and
 cma_get_name()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260331-dma-buf-heaps-as-modules-v4-5-e18fda504419@kernel.org>
References: <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
In-Reply-To: <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: Albert Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1725; i=mripard@kernel.org;
 h=from:subject:message-id; bh=xA8iRNbldwAg/IWB0t2FyV0TtMeqN3qjpeDuNnBZW50=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJmnZxsI6Xe+TK9UnDHRLtbgwJbFopPP/dhVv+PAg01Wv
 KlqiklLOqayMAhzMsiKKbI8kQk7vbx9cZWD/cofMHNYmUCGMHBxCsBF8hgbtnx+F7ySsWL5NZ33
 X77yzKwUuPSl8MmbK3lWiivUzr24rTGP/7vkh/jCec+bJpT4bAq6yFjv1Wq+fqdSUluwTsHjJ6I
 O8u82se9i1/E6V3NMN+GgkFtuqU6d+a/K4162Bs6vj2RwXwYA
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 332251A0008
X-Stat-Signature: 6h44kwnmtcwgppk5xbymn4ee1i6za43y
X-HE-Tag: 1774951237-415536
X-HE-Meta: U2FsdGVkX1/6L8wWhIx2Z5c4hfsICFpUYjDrWHjwq7CwH1wmwY5qtp2EOZjcGWR1rBphw0b3ftXjNvNGdQ5++oaGH6nsXNyqglHSYDzQ4TeMikq51vzJL9K2fRifMbPFIyiJG5SYM0GYcGMsI/3yGrs5uKcNuRAc5hN4VZFFvI7IY7vZ+wSBpcy2bCex0E2F4Sy36mMpptC6qQ5D22OtX1lt9WZMG4OqyjaQKwYr6bvnjOWg94kqM3GzMByfnNTtJiCFciIZp1F8APzfirn6ocCjOGV8KVPO+xgO+nP3stPOemH510uUGxMV5KuKF948n8QKAk2u037O/6aDhoT+r5Y8AlMnBVWmfEK2thfsFGqb5LmVIfhS+YWdnTF5mGlnhyP+aVg7FflFv/0xy2Vw4SRB4cq5sT7KCfOPY/Dk0Y7St9JLyNa6aaCFrLE+RJI5zZiognTkwDfckrxbH8UKsFSm2HCY8yeW+ycysjq6rGcX5c6o4aS7dPr/VjwdrouMNfgnoMHl8DlR1pY4FE9uo0lfrAsATkme7SWRPX/ST01TquztVcKoxqlB8fcrRQBVZyW1sGIJMKVLpb9FvGDvszNKSH6xzTFD6f5bJVpthazMJ6vnwg4b2F2mu0+0yhTWDso7twyy+zIxarw1YOZlWKqbMuNjSNzPuza1hv+J6q5+BBrU8JONSB3v8kEMeg/+Z493e6/Ez6qV8B66kAdPVjYcq0E6zFYFNQgzuIANzg1F+jnJEoaWS0y7zZkuMyTdmNDpNMA1zeSuXvZshnlUpJvrAvCvV5YQGGw9hLgeNbcN9b+HviDhxSNCyxnCzSn9ILhKVka/aeaUd4skkTRiAYrDy6M06DRd7j+aQWLu2ZnKaBXVjoeapEZR2QJf5shiDXVahGWvSpjXFnxWhYVPiRpBtx1IS0IunYuY5RRwSGQKn9dRuK5eKvUzfGzcYhERMtijuXWMyUejTDZTuHl
 VzahF9cq
 BoA9fp72jHM7AJ9Fx0HYa2ZNQFv7ILx53WvFlGEpXt19dWqO01iPfJr+vNlOUke45rRyyndagB6l5glL+lQCS1gXLQFp9kgc+erJR6TrpOJ4ZO3kr+31nF7//LdjlCUwRpTN7EYlEV+ZWa0qNC7Jjtyya33MF7yHCLImLzgWflKQdm0b/X+tFLQ6uimMzvfSc4TTFmpW4se9MHyAyLZJodR80wG/lgv7+X4cdjK7mgiYPBjitMM4BxKVkkT93PGGgShz1LOfNhwU1OjLdgm2No3MlFdJWqEuLbYhVqkTJjsELBndTHbsPTZ57QQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CMA dma-buf heap uses cma_alloc() and cma_release() to allocate and
free, respectively, its CMA buffers, and cma_get_name() to get the name
of the heap instance it's going to create.

However, these functions are not exported. Since we want to turn the CMA
heap into a module, let's export them both.

Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 mm/cma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index 94b5da468a7d719e5144d33b06bcc7619c0fbcc9..550effb9c4e01cc488b5744fe61d55a5b70a6d6c 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -50,10 +50,11 @@ unsigned long cma_get_size(const struct cma *cma)
 
 const char *cma_get_name(const struct cma *cma)
 {
 	return cma->name;
 }
+EXPORT_SYMBOL_GPL(cma_get_name);
 
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
 					     unsigned int align_order)
 {
 	if (align_order <= cma->order_per_bit)
@@ -949,10 +950,11 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 	if (page)
 		set_pages_refcounted(page, count);
 
 	return page;
 }
+EXPORT_SYMBOL_GPL(cma_alloc);
 
 static struct cma_memrange *find_cma_memrange(struct cma *cma,
 		const struct page *pages, unsigned long count)
 {
 	struct cma_memrange *cmr = NULL;
@@ -1025,10 +1027,11 @@ bool cma_release(struct cma *cma, const struct page *pages,
 
 	__cma_release_frozen(cma, cmr, pages, count);
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(cma_release);
 
 bool cma_release_frozen(struct cma *cma, const struct page *pages,
 		unsigned long count)
 {
 	struct cma_memrange *cmr;

-- 
2.53.0


