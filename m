Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C05CCD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9577D6B0005; Tue, 12 May 2026 22:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 908776B008A; Tue, 12 May 2026 22:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845526B0092; Tue, 12 May 2026 22:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 743E86B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:49:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8D711607F5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:49:06 +0000 (UTC)
X-FDA: 84760864692.23.D333113
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 04B481C0007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:49:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aN51modi;
	spf=pass (imf18.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778640545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ac+/09xni07WMR4KrujX3u+mPbI/ECBXE+1EPYxqsnM=;
	b=GjpJ9EQwKhQ+o2KNZUt76//lS2pIEBcBuNFQXIoAof8YJe/nKI+jWnzc+DbCa51vbGbpkB
	E02COczc65QOg2+NSrahwer8o6asrP72PH01AhRKvtOJlxJ0bu0nxBXebqNT9xgvx4jDE8
	rJMD6q6RXcQ2hoVKlSI0q9VPAg+RT68=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aN51modi;
	spf=pass (imf18.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778640545; a=rsa-sha256;
	cv=none;
	b=2RAC7v1qfJVoNLoOg5Oz3d1052xHLX7++4xLpnOlQYOzxem0LeopieJUVQiNnwqtQ7ybtR
	neyzAtcf1hslgrbCFIS2iV2dACGrPqy0KeIgSYs/V0gu9p3xQrRYG2VCeChKCCcSifWh/y
	c/38Yq51mstBkS5dVivw7QwXmwOY+Hk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778640542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ac+/09xni07WMR4KrujX3u+mPbI/ECBXE+1EPYxqsnM=;
	b=aN51modiINYEaGl+Id/b9+bp1r9lQEMHBEwSjWK1N6qX3ZxKpcg16PMRjDc2wcrvctw3Xj
	T3xfOBN5yGMOsc8CnOzfn8rXK8AUm6V+/KtmymliF+SpEBspSqMX3sAYVWS5/WrEg6uoGg
	L9Nqk/diP3bun0h8H4NPHMB7ymKRSy8=
From: Ye Liu <ye.liu@linux.dev>
To: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] mm/memory_failure: use bool for hugetlb indicator in try_memory_failure_hugetlb
Date: Wed, 13 May 2026 10:48:52 +0800
Message-ID: <20260513024853.65566-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 04B481C0007
X-Stat-Signature: uqiyku6czdgtfafz894ui9kut9gbr8xo
X-HE-Tag: 1778640544-559482
X-HE-Meta: U2FsdGVkX1+xybMAF1kBYy8v6Jykp39kfOvTZ3+SYszX0yp59DkpBs+OrX/pQIPlvlKozf5Ss0LJH7phOPID8WqXG3ZwlQIz0iCTwln1+RUMsiWqWJ5O8OAT3HGVEHR1D/houiSf0te7IIVFVXU2fiJ8spdNYUTrxf/6es+aYH+Q4XhJAjuUw/DpomZTkrKvz0I/4Xjp5rO85MNDEsag5hWez6HMQ+QD1XeXbdBenPOVj4gPYsP8bBzLckSWytEqORYi/W3wDcHYGtFrC+dZYvHMw0XGqz7aJw2mkMtJb6MTjFtjh+ByFxqmJN/P/Ds9DgAu2aPMeWe3D7/ZGOpFInwEcHh1/p66w7KnbsjWbiPuPyoyxkM1mXzbq1DG5upjE4nN8z29c7f6z7MYzkDBX7F3cyfoQFCmJINkXlwfUKie4lHnh8TUCUgQHlSglnqtpof1ofZxX5uOAljvnc1sNjMvKkyPif5CE/HUULoxR90rUo4xS776y4kCGURqrWUFjFEjhn635bHmfnMAw82xwUCY6cJu25olkpifHaw9ENLIseOaEUkNJpuI/7wL+Qa+D2Tx/X8Th1IYDCsuU/mxrOfbdzsw0ncSXquxYKOqSgS+RdSCAGEsoyUmRd9da53G6JzqdKLbeYX8GGNjdVrzSbc1Gbn45ZKZXtFGKWKf89IqB+2zu6g7lR0Zq7U0zh3cWP6KrZmsKiQFhtKOTdLOM9Iwpo3roP6SrAuqgaWxz9ro+fZVWC2lGfADuMr72Emoby6wNZv7OJLE9CQe5fXAEDC3enLhFv7sWSmYcbnVACKCbwdbNeTJDeMBJBSr+Z28uUlLnab+rkRj5JHyJi/n2ZdiFVglFM3p7+baVD6pcO7OtktO+6Oai+83ThPIuPzg3JWSG2uqdzKstIDXrBZ6f4PhMi3wh0zaPBJjM1Harfz2YwCvzLQNkse8wduZk37flBsZPFreT6OZ/foFuBZ
 CsTm97fM
 NPvPDDeOqTQ3WlGqOXwVJRLnB2xbB3YGEG5xIfQfiMljAIZPjN1+WMJylpAWzagloRuEjm+8SUKaK96l5FdgFhdw/uOiqm/FjacQxd3KrO25ZASxrW6WfZ7HT22OfzGvz6dEo2l79XkEHD9Oa6re965+yb6ruEaHf3Cwbf+dj+99Eb1iwjEqKZSPMI5Dc3N/ErQay19aC1Ukj6oKjUuv06TDjDx53HUqwXieRH+jeJMTsRyUWNwyspA/4dnjcA8Jpj6l4tCqjaD6B8lEo4TWHs1VRadEyX/k9t2oxLvfoazcmj2OBIHfDOJxc3Iea5OdANiJ934IMZ+G3j7mXSkyNEJMRRdsV/9Z0VCMzQZxseRhwCi5czHaiU02rL9tSoF7ow7gJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The hugetlb indicator in try_memory_failure_hugetlb is a Boolean
flag, but was declared and assigned as int/0/1. Convert to `bool`
and `true`/`false` for clarity and type safety.

- try_memory_failure_hugetlb(unsigned long pfn, int flags, bool *hugetlb)
- testcase path in memory_failure(): bool hugetlb = false
- clear semantic conversion in MF_HUGETLB_NON_HUGEPAGE
- preserve behavior (no functional change)

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
---
 mm/memory-failure.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 866c4428ac7e..f164fc5959f0 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2032,7 +2032,7 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
  *	-EHWPOISON	- folio or exact page already poisoned
  *	-EFAULT		- kill_accessing_process finds current->mm null
  */
-static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
+static int try_memory_failure_hugetlb(unsigned long pfn, int flags, bool *hugetlb)
 {
 	int res, rv;
 	struct page *p = pfn_to_page(pfn);
@@ -2040,12 +2040,12 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 	unsigned long page_flags;
 	bool migratable_cleared = false;
 
-	*hugetlb = 1;
+	*hugetlb = true;
 retry:
 	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
 	switch (res) {
 	case MF_HUGETLB_NON_HUGEPAGE:	/* fallback to normal page handling */
-		*hugetlb = 0;
+		*hugetlb = false;
 		return 0;
 	case MF_HUGETLB_RETRY:
 		if (!(flags & MF_NO_RETRY)) {
@@ -2107,7 +2107,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 }
 
 #else
-static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
+static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, bool *hugetlb)
 {
 	return 0;
 }
@@ -2347,7 +2347,7 @@ int memory_failure(unsigned long pfn, int flags)
 	int res = 0;
 	unsigned long page_flags;
 	bool retry = true;
-	int hugetlb = 0;
+	bool hugetlb = false;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
-- 
2.43.0


