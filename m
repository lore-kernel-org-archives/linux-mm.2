Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F867F589A4
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71F576B0095; Thu, 23 Apr 2026 08:31:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F64A6B009B; Thu, 23 Apr 2026 08:31:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60CE06B009F; Thu, 23 Apr 2026 08:31:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 514306B0095
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:31:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DBB534014F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:31:42 +0000 (UTC)
X-FDA: 84689756844.01.DD90076
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 13017C0002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:31:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=AcqiMN6C;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776947501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ug9Yn86Vw/1qEDgAQa6/+FwdMbRbBVlAoGXA1MRhZfc=;
	b=hyrgRyCOtbG1g9Zww0f1rEZvoyEveWO3XEjmEFscngFxzZT6OHeu3eACXI0WdUceVQe3Vr
	l4qWvlS7tmuLYlPmpq705yOdM1kj7idyMS0z1H+6FZRcBAj8lg3S96VBN0f9Qs1wuI/sAh
	+LV/LZopc8iqGrC1rupCOOqRheODUPk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=AcqiMN6C;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776947501; a=rsa-sha256;
	cv=none;
	b=hXpN+9LqhUoBCwOtwJi6oC1gVKrIxpPApMp6rXD4LfSC8Y0s7X4xAXuezYPKAIqxfxxaF/
	aVXUXLm7sbF+8WdgJ8xaR7Hb3MNx0fKDLWdsNFXousqogdJwuoQDk5Ti4F8qUx6KqEmTu2
	b8dL44Sip0SPnx04mByqPRaWEgn/ccc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CEC4642E0C;
	Thu, 23 Apr 2026 12:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B6FC2BCAF;
	Thu, 23 Apr 2026 12:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776947499;
	bh=+6LhyMkl/nKAzLjoKX2oi1wS34vWVEBcgmpvLH9P6lE=;
	h=From:To:Cc:Subject:Date:From;
	b=AcqiMN6C7u0toZ1LiX1WjkZHEypbS2/n8f7hB+4HiZPiCVYa1C9G0Cyv4N9ZLJ+HE
	 r6tyYOAGAM5r46PxnA50fetdc1Yrc0ePd5Pbd8+bGkjkJ7WpSpsF+P5yfAbzVhJPcj
	 rtO0sN0OnjOYfDEFgDQe17lMvIiXhZEvnk1jviWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH] mm/gup: honour FOLL_PIN in NOMMU __get_user_pages_locked()
Date: Thu, 23 Apr 2026 14:31:35 +0200
Message-ID: <2026042334-acutely-unadorned-e05c@gregkh>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3165; i=gregkh@linuxfoundation.org; h=from:subject:message-id; bh=+6LhyMkl/nKAzLjoKX2oi1wS34vWVEBcgmpvLH9P6lE=; b=owGbwMvMwCRo6H6F97bub03G02pJDJmvBNVsbn/IDea2sW/bu1NPIqnwQMVNO83zagd32bDHM 62fPeFsRywLgyATg6yYIsuXbTxH91ccUvQytD0NM4eVCWQIAxenAEyk4ynDgpunp/foFSyayqyZ YD4/LNslZMb3WIb5leVV7PPVl017luW3lPtkxfu/BzRNAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qgtapi3q48k6hpxti9973h68ze714doc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 13017C0002
X-HE-Tag: 1776947500-704829
X-HE-Meta: U2FsdGVkX1/MZaUCPZkVs+xnsJ//WcsizauhccXNMEbfGfcFsqeWI9TpEfkSYEvTo9xJaKvs74X/RPTk/DO5tNAcPbi7fkK1eRs9uDdx/RvvLGHC2dbVZHD7hip/8ZkJ2LMoCv07zDTrhVl+vjjgEE1l4CpPi0fUJO/YlMxRMVDVhlxrqhHsR4cHGRTdreLYUDvRBvvoWS4rmnJXhcne22KRiAk7gCx2gibERmurM6V5Z1cnvTLm/hcCp65xSuc4maEvzbEpNpzwgOZ0iiJfK8NqqFbaXaLB2DE7tUKmqepjV9ooab7MPbyl5fQmkRzd8W7yNVKSs05/jkJwHeVyu3Bztf7Ld3ufBXRbeHlThKA2GdbGPudnDuzwcv+tRu5lVmQv7XANgRytVxca0Kxp5kwHikerLkZeuQ9QjNIDkY68HxDqHI4LlRC+A5gAfQLool/+cs1nZmObQIYsAj8R6+kclNq0nJIdo/0S35Q9eWE7yvam4VapgL9jkVM0KiUBa44PwC8eVHMApwnDt7K3+M/5bevUQmtJzqfrlgqjtJ8DsiH4+lH2Od8tgSWAO0pK1AV1C78NSZhsLdykA2/kJHbqcNWtkbIgIdxkF84vgC47kTYVE29oLYUy2EusF9gLjoriQ+hFqjYiYoszIlWKC1sKbTRdy1oDT5ftgKdnWj5ivjYgoijCBseNCV28aLGKhKifqU+VRJY5Ae2bAFZnPL1HuYBsplhw5ZYCMVv/FyfNaKsejOi8Esh92ZTbFMeCv85/fHNKsQIeQj4vh5wUyzP7IfJxpdA722rlLfaQVbKtF3dHsjM8bJ54bOYqRDJCscLTQ0sE6061A+CGdHxShofY1CliNCKLWgDNti13YnNk4jQlveOr7mCsZFUiIXwhdvTrZSIPJAdJ7oSwDRSZoLN7gfEeF6bh81rndg6I3hlkBZInb0DY40Pt8AY4LhdVk+Qd2S2e9ogYtULYwPE
 EJak6jO7
 9DnOH0uwcziQhypm5OpL3iMgQeU0YxaFf3Or0utuXZi87N0HMMOFlYKPsRjy+cCb059u7mQqLj58EOg4zQfztUaYAFouZymdDgaF0xpLogpO08bUzv+n4L8uDsORuBuwzh9LqTPQ+hU9lyczmxEzJa77PTES2zRG3ptJ3iADmkv+RtXO1uIogs7JPbIncQ8Ownl+UgO8mV1mLAltRGvmhEpkALBVNhAPM1XvRmkJwbj76SsVc+d3Dj+T5QnW08mSEjvgJahZWzr/39n3ZUgItLj2/FflJYT/f9wBqcOmL5/5FNY0mCb+sYv5VjGTM76vkB8II3sJ+wxfaUGBF+Z9cIPgD9i3ASnb3bYtWrTVuL3pVct5Dxhqtb/tl0XRC9fv5WW9hPRzZhYbMM0el/60e1Rl5JoNgzCa/irBtZBn/yDvE1fI/XEjMac8pYESI0vlhzpiMGEJtR5tk+46P/xIJOEK0QF7JyEdksjdlsnSKoS2JB7D89ebeZtxgttYM9QjwoukZ48RekTLtFWmf1+YXa/j58JU6bBLFHIL2PWOyTShFzvBxZByEa5niXaE9MLTbCFtF
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
My first foray into -mm, eeek!

Anyway, this was a crazy report sent to me, and I knocked up this
change, and I have a reproducer if people need/want to see that as well
(it's for nommu systems, so be wary of it.)

If I should drop the huge comment, I'll be glad to respin, but I thought
it was good to try to document this somewhere as it didn't seem obvious,
at least to me, what was going on...

thanks,

greg k-h

 mm/gup.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index ad9ded39609c..c8744fb8a395 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2019,8 +2019,27 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 
 		if (pages) {
 			pages[i] = virt_to_page((void *)start);
-			if (pages[i])
-				get_page(pages[i]);
+			if (pages[i]) {
+				/*
+				 * pin_user_pages*() arrives here with FOLL_PIN
+				 * set; unpin_user_page() (which is not
+				 * !CONFIG_MMU-specific) calls
+				 * gup_put_folio(..., FOLL_PIN) which subtracts
+				 * GUP_PIN_COUNTING_BIAS (1024).  A bare
+				 * get_page() here adds only 1, so 1023 pins on
+				 * a fresh page bring refcount to 1024 and a
+				 * single unpin then frees it out from under the
+				 * remaining 1022 pins and any live VMA
+				 * mappings. Use the same grab path as the MMU
+				 * implementation so pin and unpin are
+				 * symmetric.
+				 */
+				if (try_grab_folio(page_folio(pages[i]), 1,
+						   foll_flags)) {
+					pages[i] = NULL;
+					break;
+				}
+			}
 		}
 
 		start = (start + PAGE_SIZE) & PAGE_MASK;
-- 
2.54.0


