Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B544C1099B40
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A9EA6B00D6; Fri, 20 Mar 2026 18:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181A36B00D8; Fri, 20 Mar 2026 18:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEE86B00D9; Fri, 20 Mar 2026 18:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE8F76B00D6
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:13:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B844B1DCBE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:13:50 +0000 (UTC)
X-FDA: 84567844620.10.2B4ADA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 24A5A40006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:13:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tQfW0O52;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrA05a2u3X/0Wfb2w9RRLIbyab2FHg+1yjUIIMIh8xU=;
	b=3CPNHvMhmGsHTdZxFVu7+1YRPdI+n/0kkH0oylPUIPFoRO76syss7yJtFfe84zB+HEDCPO
	+35t42QIid4BxE6qUcEHeCyzkuZSDKQrKYBy05wR+H6u1X/EFcfq8tq4dgakAfYYTkA1Bg
	VXCTTvM7ovhNSb9W4lRNYMMC0CGPM9E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044829; a=rsa-sha256;
	cv=none;
	b=R29LXrF5hokanrOPg4dOkLFryVsfULrJPtLI1dw9sJCpEc/HX01bqJgDEZz3ugtZrAlFwS
	ezx7suh5wctaK/eoC5vOFZnPf27CHrDXuht1ZyiApI3AxcjwO79TmpHc8r9o6bcPOlJjYP
	hEbJn0lGPH7E84ej/t31MS7HRFCEvcg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tQfW0O52;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A55C960126;
	Fri, 20 Mar 2026 22:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74D4C4CEF7;
	Fri, 20 Mar 2026 22:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044828;
	bh=nHbTHkZVPmgr07xrNZlc6QBoO7DF8u1xsHWbyTYeiTQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tQfW0O52ZtyktIiPAk6j94DCE/TASe1TGKNwSCHH/AqiVoKikGBfFF3W4UcBK/nfw
	 8V7Vb27Vcmrr0XvfznjhmwdnhGVPlZCBt7c1tUzBlzwi7wYWY0KR84ObQEtEz6uESv
	 dRzL5KUAy9mEFD4GI/QVpkY+cklyuLv1v1lmUNE7D7i6zqVl2H/QaLAOr83tthbwZl
	 jIT3N5KVDUM3OYBhJFn5GCC1nY/SIvLbps9ZcbkHdoN80Bzuh8s1eM7pV8Bva0XXDY
	 h8kXTpPAdxsUhuyQ3Sg8Xd7BkRgiNQ4pgqYN84AN08nzdlaoP9hShigTqDXP9QruqH
	 SbtczXznDUijA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:33 +0100
Subject: [PATCH v2 01/15] mm/memory_hotplug: fix possible race in
 scan_movable_pages()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-1-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Stat-Signature: as1dwddiirg7ed9nyifb9ip35iuhqurf
X-Rspamd-Queue-Id: 24A5A40006
X-Rspamd-Server: rspam03
X-HE-Tag: 1774044828-628760
X-HE-Meta: U2FsdGVkX18oYA348N0lEt7MrTfC5WEsI+ulONJfjLScBr3UB9H9uV1eqS15/FmceDtUHAftlEYtsHqdyvotAEBBX4eR3uzC3lJA0ORrF8Ewa1COdaZSDDpIyFVcwLZgsp0mnIq1y5dFFcjbof01tqehtmRT7Io8rKqEXBwNmNrtJObRgw+TH8hrzc880ewPsXoYR4IqdGMOf8MEdZ8bIrO0gSJpdJYu6sMoKIYqaelvCbB+SVKrovG6PMVUm9Q7DSTJqwbt3UYGXxRVcbl0WLL19YLQ4C7w/wHrZ/ULMIVEkTXkpnqCr5j+z2++nL8ImZ0yhWYxMffQs0fGoFyUU45d7bKGMEIHAycjT36UqBXedI6D1eYDEEk6/kH+ySHpSLkO5fQqeT1weo0woI40c1sALoosPAl/itA4Q+nKKjRXGf+59+uv3F0WByUKK9brhgE9PrmADAyQqayXXLfstBnXfwC5OlGPyZy+CGpc6f/J5IfzJMcuT98vizTiKafbV5/28z7crFRGDkig4vS4tp1QzDNO/UClrT0dVZPB37YPHoY02GsG/112RCttokJlq1KA17ol/5vvdIuENRosGbeM5Ap1GZe9wkIYX2sSP7WAcdta7THbCAr8FrIUGdXI26E6+O6wB573cb0tfmQ3HbZ1K+4+ahilzrmvr7y9w6Dxeo+fRMExVqaEq4kUmbHxEm65NncH/77AGMadIjWRNE5G7jXE8ksJadlRLsLotifppgY0xI4plwtv5nMdkFjl7z9E6BakA3CnjAK97tg4D/6xvFyzHvL20R9YcwBim2IPtSmh4S12kbjMI0t9ZpPkpOOQt942OA2E2g0ogMnHh8f3rfs7F+cA9+Yihq+//Il2edZ3E3Lt6tyQKbiOKRMg4l1p8mHnSrLo4ttaz9CLG8my01XLeTZlrzdaMdXFjA0Hrcn5szUjk8IAMmW7kWE2UqvG2h9QVlp35cnwgLP
 2y6uMFl+
 x7C/4SY5hOX5JdJgOu8k4PbHevOkOERj99i+QKZNg6LFmmHU+bDF7XPdx1I56NR/lF1ETYNDkLXnt+RU/R2NEWS4Vb7rkYLRhlncmYf1w2mBvuuEqsYAzaT3+TvyKqqZGdDHVQhBtTpN7J/hmdLEHQq7ol1pEgXiqvS3TklJsKgJgI9C4HKRd/hEpmIKmjzqh16Q2ej2N+nMwiqt9uwS4po0bKGpl83bhnDzeKcnFJMIkmlgGYvcKYDJrkLc+xkl0JqJfGFyAHv5y8TXxHbCawW8Uxcpq3DB+Fg6r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If a hugetlb folio gets freed while we are in scan_movable_pages(),
folio_nr_pages() could return 0, resulting in or'ing "0 - 1 = -1"
to the PFN, resulting in PFN = -1. We're not holding any locks or
references that would prevent that.

for_each_valid_pfn() would then search for the next valid PFN, and could
return a PFN that is outside of the range of the original requested
range. do_migrate_page() would then try to migrate quite a big range,
which is certainly undesirable.

To fix it, simply test for valid folio_nr_pages() values. While at it,
as PageHuge() really just does a page_folio() internally, we can just
use folio_test_hugetlb() on the folio directly.

scan_movable_pages() is expected to be fast, and we try to avoid taking
locks or grabbing references. We cannot use folio_try_get() as that does
not work for free hugetlb folios. We could grab the hugetlb_lock, but
that just adds complexity.

The race is unlikely to trigger in practice, so we won't be CCing
stable.

Fixes: 16540dae959d ("mm/hugetlb: mm/memory_hotplug: use a folio in scan_movable_pages()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory_hotplug.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 86d3faf50453..969cd7ddf68f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1747,6 +1747,7 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
 	unsigned long pfn;
 
 	for_each_valid_pfn(pfn, start, end) {
+		unsigned long nr_pages;
 		struct page *page;
 		struct folio *folio;
 
@@ -1763,9 +1764,9 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
 		if (PageOffline(page) && page_count(page))
 			return -EBUSY;
 
-		if (!PageHuge(page))
-			continue;
 		folio = page_folio(page);
+		if (!folio_test_hugetlb(folio))
+			continue;
 		/*
 		 * This test is racy as we hold no reference or lock.  The
 		 * hugetlb page could have been free'ed and head is no longer
@@ -1775,7 +1776,11 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
 		 */
 		if (folio_test_hugetlb_migratable(folio))
 			goto found;
-		pfn |= folio_nr_pages(folio) - 1;
+		nr_pages = folio_nr_pages(folio);
+		if (unlikely(nr_pages < 1 || nr_pages > MAX_FOLIO_NR_PAGES ||
+			     !is_power_of_2(nr_pages)))
+			continue;
+		pfn |= nr_pages - 1;
 	}
 	return -ENOENT;
 found:

-- 
2.43.0


