Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A70510A1E63
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C37CA6B00B5; Thu, 26 Mar 2026 22:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0FBF6B00B7; Thu, 26 Mar 2026 22:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4D106B00B8; Thu, 26 Mar 2026 22:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A363F6B00B5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:15:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 611B6140D0A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:36 +0000 (UTC)
X-FDA: 84590226672.14.5DC3874
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9B5CC140010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ffpxHw+P;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XO0R5fX+FiXnuLY0HoKuyc3BzHok+k+2YVFrwxlOH1U=;
	b=JJugAdS9YE/WlgYaLFSf4sGSgl/h2iC118YyNjcn/tqUEfhWnI73ze5wyLs85x9VeOtRqD
	dZpfLa2qdqsNR5rTFZACQKu7C+k+RZDxk4V9yWbavQZboGp8CrBrneaFd15FT6WC9mEp8r
	dui+0zYfn19DBxeIOf77XEw5xXyTkBA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ffpxHw+P;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577734; a=rsa-sha256;
	cv=none;
	b=dnveMokSa9vw2jHKtnxeRWwDjc8YDgPAUjshTzOoxA+roHK4swhL40CISlOFAKrkfEF4mu
	64FOvFySLMJ0aWAU9VO9u0/Ur5VhQY9AhmtVzCZ6cs15KRfFYACWRU/44nuR+o8cSJx95d
	TWQZh8Yl2nu1j9ZeSEs0d7SSbEhZLVU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XO0R5fX+FiXnuLY0HoKuyc3BzHok+k+2YVFrwxlOH1U=;
	b=ffpxHw+PDquRIY7PsBB+gYIVU0HGhnrg/lszSQI4Ss/ylyOhYh/GY54SqX/Gjmz298GChe
	CK1RQEiqAUEGH9vhPBlSkxZYbNei6tVRaaPyX3jC8Yd6BbKN5MzHnqPEqfYrvEF6cG/SMn
	RA3uLKxe+69mdcNlUOoR18d3XTq3a4c=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [v3 13/24] mm: proc: handle split_huge_pmd failure in pagemap_scan
Date: Thu, 26 Mar 2026 19:08:55 -0700
Message-ID: <20260327021403.214713-14-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9B5CC140010
X-Stat-Signature: 3o4yzie9nzu1ecyrrwsfqhfgsjk69ah5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774577734-830894
X-HE-Meta: U2FsdGVkX1+JV5wVevs3wYhf7B8A1vgUPGglwHEp496QOdtE4MlO9KVW6sJlSMOXCg0+YuNM6b+3KXEe1+R8/mOkD5yX9wEpQiUTazKu19kH9CXRiMS0JGL/2IA0RJ6jXhctdajcIHbcqfmx9XlVs19979JphvMIYUGTrU/rpyreiF/cfxbCOAEFWK2NeByIdGxEBJAqAntDJAfXqBzj1Wnsd18349PWLy82syHOjslWHVE5v76Dq/EAdnXvHOnQSTnJf1U9QKl5vLfPK/+vi6SibLqtVJtsw/tekS92gFUbx6n966s6SCwgZQDj7f++vJr9dmsQWD62Dra0Tr/LJl28Ep6IYuScWkfnvO96qXGiYc5NrnkCrmTAv2rc4P6aMB1rkjAHzLR+h2vXEL9+nigR3Op7Gp+5oK+tn7gVoh8GlRMa1E8+iXrUCVhM3hNoafbQaMRAmOS61P2OdGy+bMWTIKm7INtlHbwESat5Y1+tGGhz2Q5Yfaosxf2V7LMkG9RexWaTifGPFfLYRYocYWXHf6bzBPGbVBdynyiJgAhjNWCyOPfV7GUjt5uyOq/ajTIJ0xsO7Vln/cgAPnR+KxrjoA5GWsfiOWfWknjRWxACgbt5n7bSbu/zrT8o8iIhA8Fo1BFA1n3wD5dWGbPo9E9Re4Tg2+F3LwocvkybrLUnU3rUJ2mxek8eqOU3+Ce3I151RX5plAjxtle9zfz6B6JqVq3OSMMnAOmSN0p0s7ElAqUZPN0iQamJH54mXEY3jFtmzFDW8WVMT98jEltwxKWOHVyC+JtcCLhubn2nWp1MIkP37USBPABA5NT++8WUrEBHXZhbaoAi5lT5jMToqHC20AxyXjk9gslGuzULYirEcu8OCrV83a1xf7p/Mt7zTiR7uxJbAxA13+dMHqeHMxmmazxp5sqQBTqHidF5ezyOYKAlU2kmDm4OCPeSaSnuF8q4EHIxfPUDficTtIl
 9KpBIX7/
 j2jp/U/M9NqCVrX1XtqWFEo93yhCkaePbEJlNXlJGJ81ASTElvGDLcaOpUAeBEve1027wSBmXwFDMIOhDfJdrbY6S8J3G3o0MOQFBZbtkUz0YcGf3QR3aQn/JPIBpdgVFWqlqF4BwYkjshk9X0IBF2r1Qb/V21qx6Uf1zpd/8HtVPOSTIkiS3aUS2sR50yscG99Bp9ekXADhLkey0GrzDYQecAaSO8EVTtd4vVeU+DYsjuJIBKriXCK8eV3LsUAV1iVufrhTmozKeBd/CPhucxylucQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pagemap_scan_thp_entry() splits a huge PMD when the PAGEMAP_SCAN ioctl
needs to write-protect only a portion of a THP. It then returns -ENOENT
so pagemap_scan_pmd_entry() falls through to PTE-level handling.

Check the split_huge_pmd() return value and propagate the error on
failure. Returning -ENOMEM instead of -ENOENT prevents the fallthrough
to PTE handling, and the error propagates through walk_page_range() to
do_pagemap_scan() where it becomes the ioctl return value.
pagemap_scan_backout_range() already undoes the buffered output, and
walk_end is written back to userspace so the caller knows where the
scan stopped.

If the split fails, the PMD remains huge. An alternative to the approach
in the patch is to return -ENOENT, causing the caller to proceed to
pte_offset_map_lock(). ___pte_offset_map() detects the trans_huge PMD
and returns NULL, which sets ACTION_AGAIN — restarting the walker on the
same PMD by which time the system might have enough memory to satisfy
the split from succeeding.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/proc/task_mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7ca19..f5f459140b5c0 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2714,9 +2714,13 @@ static int pagemap_scan_thp_entry(pmd_t *pmd, unsigned long start,
 	 * needs to be performed on a portion of the huge page.
 	 */
 	if (end != start + HPAGE_SIZE) {
+		int err;
+
 		spin_unlock(ptl);
-		split_huge_pmd(vma, pmd, start);
+		err = split_huge_pmd(vma, pmd, start);
 		pagemap_scan_backout_range(p, start, end);
+		if (err)
+			return err;
 		/* Report as if there was no THP */
 		return -ENOENT;
 	}
-- 
2.52.0


