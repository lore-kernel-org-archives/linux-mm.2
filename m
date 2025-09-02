Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F0D2CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DF098E0011; Tue,  2 Sep 2025 04:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6218E0005; Tue,  2 Sep 2025 04:40:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2DB8E0011; Tue,  2 Sep 2025 04:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF568E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:40:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C65411A8DC
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:40:49 +0000 (UTC)
X-FDA: 83843664618.09.4DFCED1
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 032BC1C0004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:40:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b="Y/4F16wa";
	spf=pass (imf21.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756802447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0/a02yz8h5AoW0d65xNVfVoFW4HrPL8se2AzkAPbTQQ=;
	b=ilWcjfNjyAHlwJ2vh+5uesnL2lDV5FJVncPJ49GYX/Tj7xKhUw5+kYGJ0Fg0qT0BMSaU8e
	YQ14X83qzyFtTqc18j3uB6fqcMcvRX/ND/fHSuRC+ekWv71qh7cqwg23vlwFjWcJ0qYrGT
	aVIgl3gXhLZacTBUxXB7URqWiN9w5Kk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b="Y/4F16wa";
	spf=pass (imf21.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756802447; a=rsa-sha256;
	cv=none;
	b=0nipUzErAXyUoeKtwfZVfGEWA8FXTsYfAEYNRxpMyCqOr0VrgOS9qWp6C65Wy6tQZDXITn
	cQ+b0FEU/m4QdWbDbQDzMHB+xxUubSUVp8SYp+3J11bN+iNw0qnC0qztsQrKWkLefdgQKB
	QkAb8Te4Ifey35h8u4w8xCE1pOnqiag=
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4cGK2L66GNz9t8R;
	Tue,  2 Sep 2025 10:40:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1756802442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0/a02yz8h5AoW0d65xNVfVoFW4HrPL8se2AzkAPbTQQ=;
	b=Y/4F16waScTi9XnCuVH0PZRtbDFxtutwki+0JNbugO3Aaxt4FbTvqUv2L5TB5OHsxISQ1L
	L3BXdllpf6C6k8AmHMuJW0c1OlSjjklVoUC0gMYx8+UrCfWL8uQLJuP9RNfXZ7bBqCyJat
	6T5Phrxkt+STzam57amAQSOP4bcaz0n6/NI/watvCV+P8E/o+Eof3bGToLXGrgSPbrwrz4
	WGDmphVpW0cuU0ksMRenfeY3jycJuy0J9E+/kUpebF9RkGHT4bfJVKXzP+S2BeGca/xX9I
	fGPNPgTktMwFvpA3uKP0PB3mztxiaE4R33Po3viQ3UgudwnhyCEsuHO7r6Z1Ow==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: David Hildenbrand <david@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH] huge_memory: return -EINVAL in folio split functions when THP is disabled
Date: Tue,  2 Sep 2025 10:40:36 +0200
Message-ID: <20250902084036.208921-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 032BC1C0004
X-Rspam-User: 
X-Stat-Signature: ee9b8gikpu43qyrsxfaqf55furo6xep1
X-Rspamd-Server: rspam09
X-HE-Tag: 1756802446-1408
X-HE-Meta: U2FsdGVkX191AcVUneQ2uCz3BvQ+3q7n5V3L51xl7E4j/5Yd4Dg4VoePZ6GM30zIj2WGAKssFv2dbgqO0K3KxRIyQ1Hpsn067IqFgNEPH3kQ6VpEoA/IGs0XY8qqF+vMi5Zim4hh5C3vwbkjAAwUbkX/lvBHmGjJQ6rqygx6gtklzxSM4BFa+b3XgeayUIoIi2UxlPy+akipayIO34vltjnAaB7x72PxoFrkhcPNxq1JIGbkUxmkhaSrcB2Zn0RfDsdAa2OyxjxFEkVBLbLNEjU4Z7C6O5L5WSII6FkJVBt/6Z7OQ3f7ii6USO4WjtmQYUECArNwIQhtMN5luAhw/M3koVjH261Ebr6HlST0n7cDBDl18NjOzk4PxTMOjqCkHVYpPf2seiP8IWaz0YAZiqKJglgicPNLGy1VA+EyW5LsQ9oGvElZLSNneIFyIetgCvu0gLW2K8xcG1vo7VxcxesIStU9e4LBbj2sWh74qduHSsgVWW7RImvTZa4CIIXLKgT1oucclG3PjpKinnu4DUxc0VrTeXgOWu3OXe5uScefGKPmz9Wt0gOUK5b4t8v7AKoxeHxqE9gy4SpP4Y+BNik3iwUGW6Pl21aQmUOT96OP6irOIb2AyStx00/1mjGperh/aCBxHRHmog3v2rK3USEwUX4U4JYnxYNK/LCe9ybFMvKki+SqwyX+BjAhfGhbkKHgcrVzZ9bLXAA+n94pzoC939Q1U/QrpGQII9U7IwK5VWBaJEl63La5eMsVNP9/KFT0dgX1Tkmq9EBRFYtY01oKWWkHUGBt1GtoLzgzKWz/9eCUDIoTrqAm9QutLdjcBLrj4dmZAMRv3JGDzoWIswOxsmed7ayWkH+HGTyl7avzyTLA4nhwL2MxHjKwnUAlJ2dpDqiyW42bwQqE6YzvbNbqPB3WtrPUgNAzOijCQQrwCd0AChZa/vCLY1pE2PdFayMyKXbhU0fl/yfhAyo
 XbL59fSj
 Aq6/B3w7Amp10U4rmkG2CSLSiN+aXMr4D/6GyK2QRNu0Juz3qVUPQcJ1DwE+YVOYeb83u4/48tsjgk+DIzss2T481RMyaQ+LgaE0u0o+EsD9ZI0FISF2IdBXRdjejL8NNiwzO955cz9X6a/nkLrVrjCIlNQq6+eueT8vwZ8g1ve8NNkqEnkRAfL2DOaH9RtDpj3BTUngjKnrI6I1T3/l0vx1PFlrKE5Q5R+m/Vh8Ksc0GIdRonObKfYJMSRmTOBdHLe/ricL2RbapKh2wxCy3AAg978zA0bjHnaZOpUWQh/E7Jx29UQ9mvm01JOfILJKNbeykTQCKaUqL+WHVqiL0R0X8/gvNGZs7Aa0/cg+bEdiYr4sm/JsU5gxcqdsRlTzmNFQhNOKLFR7+2aw=
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
0.

This issue was discovered while experimenting enabling large folios
without THP and found that returning 0 in these functions is resulting in
undefined behavior in truncate operations. This change fixes the issue.

Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/huge_mm.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 29ef70022da1..48c4f91c5b13 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -588,22 +588,22 @@ static inline int
 split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
 {
-	return 0;
+	return -EINVAL;
 }
 static inline int split_huge_page(struct page *page)
 {
-	return 0;
+	return -EINVAL;
 }
 
 static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
-	return 0;
+	return -EINVAL;
 }
 
 static inline int try_folio_split(struct folio *folio, struct page *page,
 		struct list_head *list)
 {
-	return 0;
+	return -EINVAL;
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}

base-commit: 291634ccfd2820c09f6e8c4982c2dee8155d09ae
-- 
2.50.1


