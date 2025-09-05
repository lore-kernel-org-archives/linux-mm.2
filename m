Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36D83CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9760E8E000F; Fri,  5 Sep 2025 11:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94DAA8E0005; Fri,  5 Sep 2025 11:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B018E000F; Fri,  5 Sep 2025 11:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76A088E0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:00:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3141C5820E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:00:24 +0000 (UTC)
X-FDA: 83855507568.18.2ED7A19
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3357C40014
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:00:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=VfZ97xaJ;
	spf=pass (imf11.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757084422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RXOi5sZru2cPyRuOM2KEV2Sn8wT+4JJymSVhdB9bP78=;
	b=U+q15WcLIYEgPGpQgXQytYa2iYgpFCeBkTVTKoYtYwOhLVGcm8e9gJkS/76sFxhEuWGUML
	odUn8PQe706T4m9qZpVWWykh2IAjcJQKnkRZlZwermmqoPg1zMBGbt/dp2ElEraisuqai9
	TJRvu+eNmBiBJmGW8ScIKcmGVtig2wI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757084422; a=rsa-sha256;
	cv=none;
	b=YLk3sw4j38S91NkdEUpsvGnVmi0PirKK2GSH7nhqY53HLpHLkLpU74+K54NJer1qnlLRr+
	eyDKhmKbRhd+4NDkmXX22Ci/nGWokyFXqINYlb3jyxDqOecerjXEql/mW6htXeBpLLY71t
	Cs9gmxpaepP3aS486TjpQUp5hr6moAc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=VfZ97xaJ;
	spf=pass (imf11.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4cJKJy0WjWz9sy4;
	Fri,  5 Sep 2025 17:00:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1757084418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RXOi5sZru2cPyRuOM2KEV2Sn8wT+4JJymSVhdB9bP78=;
	b=VfZ97xaJzxCKsbqucB6C77/OY9hJkk0owMCk8Ivf5x8cWaqMhcYmcQYZNGhdb2rwIMsd9X
	Mm7+0HDe6Hm5t2FCRkmaxg6EoGWb1kCpbnpJw4vwmwVwSc5NoOvhqhXVKSdZja/WaxxkJi
	kPkhlqVCa/W2ITuyOfxZo/gIAa00YrKQ0q2OfQ690pAnz1y0rRlG7h2bBGwuuojZLR9xCT
	h1Blb4BMuR1J0fY5aHW1tBekIpzBBydn/XuSp2MmxXu/L112MHPpOVqmVLlUZju/9EJnpx
	qu+Gfqjsxi+WrFoVPwibSYDEtBsepHt9Fgnh+ULvogAqYgbm5rm7TJzkD7iT2A==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Zi Yan <ziy@nvidia.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	kernel@pankajraghav.com,
	willy@infradead.org,
	linux-mm@kvack.org,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	Pankaj Raghav <p.raghav@samsung.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v4] huge_memory: return -EINVAL in folio split functions when THP is disabled
Date: Fri,  5 Sep 2025 17:00:12 +0200
Message-ID: <20250905150012.93714-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3357C40014
X-Stat-Signature: b5m4kwn9m9cqxo3sh53qrq38uujjccju
X-Rspam-User: 
X-HE-Tag: 1757084421-687039
X-HE-Meta: U2FsdGVkX19bJNtPpEQfoqJmVN4pe/z4zjxUyDMRMN4pIWFJSYqYjTYRaxRw9if9hRABFMHuZImCnIYfb3coxWUt3Olg5yDCAm/RPjpSjF/WOYduXIw1m5SirXy4tH6wPiXVBvjq0wATZWMJrMoL+Vf8WQK8bMrCXR8lGLZOHa4ADK1wGvvDo5LHzwQxMvna4dhouA/5j+OeFHywOP4b4AWuJvauS3po9z3PEQrrMHnSA/7wRU4dqZvHRid8Gy28VxCbZkgnKcWT3tUkdVqL5a4uxhzLXq1Zo60ib7hMpFtaODJ9q98BNPbdsxjjPmlc9Ktdmkv80y0A8nBNWKEidypSLUlyE024XNmU085nEFW0KRHF2KLUW/gSLoodVPoT4UgV5XoxLM+6taDZdz3EMmjF6wC8Nf+erGeWOgVNt9XrTj0y+RkrUo4wsmIgwTGcU1JYgHCyaXO3vBhA4ump0W2fqihseuShurUI+d105QVz4fascN8F4xEdAF14OUHYb52ZUe170t77cGS/Jpg2DJWu1qCCSBHcw2i33KRcSpxuKChLpfxG66tQdm+iYgCkpqmOPtDTSGHDzceG3e/rj9/eDOflRtIPhaxmRZuvFt5BOMZWhv8CKjZ9za3KRpyEkzBJJQjzeRt7yEt5mogJKM7mXai3CmIDxHu0HrqLAnIPxogD6CLiEIytLkmN6j+Id3nKq5no0mrBdj6UJQiKzd4R6TRGwoadhuKwsskYCSqwJSNie3aLuOe0mfjvOVkXBU/SqQE/81IA4yyUiwkRrEnoHWN9/ZPymPNabUMT8dBavY4gNGywCspldsaOWT7S7jquf5CUTb4F2kyHedTR8BV7n0CnRBCHXf1yIDovs9x8YG8F+pzxPamdWfoqOvKEjgdpJObfgLochYX1Gm9QsleJ8QUdK4sT1xrLn+zahE9LTnetG0WkdM4tuALJIjhb6sTGSeSAmjj1FmEJadB
 2B84pWds
 qwUEE2YUgTaL5ILDU9SMDIcNF6PCfYKQgJpgI+fvUwb9FOVMwpSPVdA63jg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

split_huge_page_to_list_[to_order](), split_huge_page() and
try_folio_split() return 0 on success and error codes on failure.

When THP is disabled, these functions return 0 indicating success even
though an error code should be returned as it is not possible to split a
folio when THP is disabled.

Make all these functions return -EINVAL to indicate failure instead of
0. As large folios depend on CONFIG_THP, issue warning as this function
should not be called without a large folio.

Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509051753.riCeG7LC-lkp@intel.com/
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
Changes since v3:
  - use VM_WARN_ON_ONCE_PAGE instead of the folio version in functions
    that take a page.

Changes since v2:
  - use page_folio(page) directly in VM_WARN_ON_ONCE_FOLIO

 include/linux/huge_mm.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7748489fde1b..cd61d2b789ec 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -553,22 +553,26 @@ static inline int
 split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
 {
-	return 0;
+	VM_WARN_ON_ONCE_PAGE(1, page);
+	return -EINVAL;
 }
 static inline int split_huge_page(struct page *page)
 {
-	return 0;
+	VM_WARN_ON_ONCE_PAGE(1, page);
+	return -EINVAL;
 }
 
 static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
-	return 0;
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 
 static inline int try_folio_split(struct folio *folio, struct page *page,
 		struct list_head *list)
 {
-	return 0;
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}

base-commit: e6b9dce0aeeb91dfc0974ab87f02454e24566182
-- 
2.50.1


