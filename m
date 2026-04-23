Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8161AF589DD
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 14:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24E36B0092; Thu, 23 Apr 2026 10:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC326B0093; Thu, 23 Apr 2026 10:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C118C6B0095; Thu, 23 Apr 2026 10:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B034F6B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:28:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B830120118
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:28:15 +0000 (UTC)
X-FDA: 84690050550.23.1F16B60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9B7D51C0011
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:28:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=rTUho39J;
	spf=pass (imf20.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776954493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BxtraOYvK6W1P2V1EHlOP7s37u1hcfzuL8eb+6AlrfQ=;
	b=Uiq7RVq/BdaDx3b69NvPoP4aybYARFmgxeZotRmqF5jryQ0dHm9+/sffn767HFhiC3DwQ9
	av84tE/GVH8WNffq1qzyWU5gz9bpgqnH2CzgIw6SUhgQcI2j4zeb9GTBEwFzSBNGLR6t2l
	i7j5p0wYEEUgbCd8l4sTFcCtAckZ6OE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=rTUho39J;
	spf=pass (imf20.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776954493; a=rsa-sha256;
	cv=none;
	b=dI9mNbSJWJHV2Lm0IIVRCPBYYRJMgqcHwRx5AfOwbKpWDUGTDXuv6yDk/tChsab3i1Fl8C
	sdbcWbgUstol2BQewQ6Wm2OjrRxhZCWbSjnyR7DqEUsGR6XXZUZq7UsgWEWc6tthTZHKGa
	pRllTU0tVI6tPF6QQj4RbV3sYXI0+Qg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4C074172C;
	Thu, 23 Apr 2026 14:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43754C2BCAF;
	Thu, 23 Apr 2026 14:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776954492;
	bh=JWk89U6swzJmb7YDGRY0DozQlkMigh411V2GF7LYZmg=;
	h=From:To:Cc:Subject:Date:From;
	b=rTUho39JZwtd2gxrGHXsghM6i0kIGa/veNJoDSk9TE7Ge27ule5btLnkqsT5ChhqY
	 FP1/04kpdm08SVRyjQXtcd/q4D4jqSbuVF0VDQuiAXyVoBenJV4QaNhVzQ6yQ+gkQX
	 GSexWue10dynTWpPzOC4AAmGtoJgKQrbBGTJuHuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH v2] mm/gup: honour FOLL_PIN in NOMMU __get_user_pages_locked()
Date: Thu, 23 Apr 2026 16:28:04 +0200
Message-ID: <2026042303-vendor-outright-b9d2@gregkh>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2864; i=gregkh@linuxfoundation.org; h=from:subject:message-id; bh=JWk89U6swzJmb7YDGRY0DozQlkMigh411V2GF7LYZmg=; b=owGbwMvMwCRo6H6F97bub03G02pJDJmvdEqS8ma+OxQnx+X5qr55XqPfXeGEwNv2F0M2CiY5h qn+5t3WEcvCIMjEICumyPJlG8/R/RWHFL0MbU/DzGFlAhnCwMUpABNhk2BYsI9fe5JJ+Trpji/a E6IexK23WJN8kmGe9sfbEZ9lZs0rkub98HHRyw2f+mTVAQ==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qjn1cupus5o1z78ntiax46o9ts8poguk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9B7D51C0011
X-HE-Tag: 1776954493-796627
X-HE-Meta: U2FsdGVkX18q/86KLink09YadIi27RyMNqGIY2u14wCW4II5gQ52Gk7HtPOCPJlcXYmk5O1FYnQCq6AsSapmYI6o6uhbI4KfpvWSjoTBKoJCPRKrk/f3v4VUfuysQzhHvpMTBQ1t7lDd0Im4/TOWpJmAg9wgLz8qf56D+pti735CHo4g1FS0oqkKnpEQ8Tbl+1hBE0ULZyZKSGwCS2FLkkpXEYSbhXGgk/rtUE6Qc8yzE9fviUd8sNK3IlGUAFnXZtIwwnALfXve+/IhKFtGf1UL2yIMoise5CyXPmKLUcWZNdN10ttVaQuKN+IQZOnLg/kRM9n2V6M3E4h8kFkZxzkc7Kye2BXAHjo1UaKy5HzT4yFAez2t7NlK5Luah148B0tvdczd6+cG3wglp22iozAbE1FJBq6Mtx7vRG0tG/5IXaIj/YjC8FgWAJkOAWz4D/5sNf06B0hgu1zGomttWhrz38mRx3VefpdFrMLZc0d9jkpcq7dkn+ewg3GYMlbh32QgKI3UMILSr7gE8fbpX+C/ClDvXXQn8X0sNXzy9dEDcj9QEsu4Q9fR9KlRNSOuJGy8udxle8h8XwKGfSrzFQixd7juEuRQumIECdrYQybZexCe+tOM2SeHwBXYI4a1RP+1BI5/7Wi9TAREgUtl1QVAoY9iMOZIRWRFGhp9DAtgsKHnssvRXdmjBSlUCRgCFbEf22DdDow4jn6ykaqtCEqcDiV9BJn6qJlVylGKR7pCl6L06zY8qUGUah8TmeawEjJOiSB0RTUcw2sYrklzFITdafp2zDeEcBuDPUMP8OgsLqutZ1dvrZbvYWSzvnUYgzCYKN9lqkHjPLWi45rrQrHDdNgEPEtdrVjfNns/MJZ9VtPYC94F6DR6zYVr7+TP6uHtBilrKFTVYoY9qPg21bKi42Bus05HHrh8o4U/HLGvIkrGRK7PKtXx2GHQYYVclG/ft6olLrJSouXzg7b
 HpgF7M9M
 X/ZfRUdr3xWlFlLp7U1+TUFeqtHKFXPJNOh2S2W5FDwUJQ3+MIiUD0ce+0lOcmYhQCwkWAhLnP2XXglX4gq3EkZ0IdyD9IXJdTAmsrF449LBavJBmJxflouunIvhRBPQVa2ECFbsf2frlYWWKpSChiItQBIAmXos3Sto6TE4Qs7ePnI01443kEW2Aogw2Rhfsf4a70FnW8KNQQjSBzqY05ihG/hki2QTr1agwfxjpHvFOArufAUbnh1V7R8am0KJt/ojWti7EZBql0j6hGamJonLzTc6ufEe9cdzqMxPCxxQncVBHafQ8wUn8fHlicJm01V4R+XzDOdpwyO6iZhiRAUf61BQ2Zf9BBNRsxic139bSNs7RmeS1RDm7Zkh6UacFFmRmsQdSUxCpslHkzYqdppn1vPLIrZihNpDhvbzo0rZn/E1xUnMU7nQj8Q9Fy3/JIAaznIE3MXnVEQ/59nIkwr0mOsHh+ZRtdvjtXB/9JkFQeKhzcMv1A00ow9zqszH/ZEHLRq9vmdieI8WZnXaxs6uUy1koByNuHXInhCNlWBh4cQ9NGJduS5UhdGME4K99Ul5q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
get_page() reference for each page regardless of foll_flags:
	if (pages[i])
		get_page(pages[i]);

This is reached from pin_user_pages*() with FOLL_PIN set.
unpin_user_page() is shared between MMU and NOMMU configurations and
unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.

This means that pin adds 1, and then unpin will subtract 1024.

If a user maps a page (refcount 1), registers it 1023 times as an
io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
the page is freed and returned to the buddy allocator.  The remaining
1022 unpins write into whatever was reallocated, and the user's VMA
still maps the freed page (NOMMU has no MMU to invalidate it).
Reallocating the page for an io_uring pbuf_ring then lets userspace
corrupt the new owner's data through the stale mapping.

Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
symmetric.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Reported-by: Anthropic
Assisted-by: gkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: - drop huge comment
    - rework error return value based on David's suggestion (heck,
      pretty much the full patch was written by him now)
    Link to v1: https://lore.kernel.org/r/2026042334-acutely-unadorned-e05c@gregkh

 mm/gup.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index ad9ded39609c..2f6f95a167af 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1983,6 +1983,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 	struct vm_area_struct *vma;
 	bool must_unlock = false;
 	vm_flags_t vm_flags;
+	int ret, err = -EFAULT;
 	long i;
 
 	if (!nr_pages)
@@ -2019,8 +2020,14 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 
 		if (pages) {
 			pages[i] = virt_to_page((void *)start);
-			if (pages[i])
-				get_page(pages[i]);
+			if (!pages[i])
+				break;
+			ret = try_grab_folio(page_folio(pages[i]), 1, foll_flags);
+			if (unlikely(ret)) {
+				pages[i] = NULL;
+				err = ret;
+				break;
+			}
 		}
 
 		start = (start + PAGE_SIZE) & PAGE_MASK;
@@ -2031,7 +2038,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 		*locked = 0;
 	}
 
-	return i ? : -EFAULT;
+	return i ? : err;
 }
 #endif /* !CONFIG_MMU */
 
-- 
2.54.0


