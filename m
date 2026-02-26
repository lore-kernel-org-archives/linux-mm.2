Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5767DFC5935
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B22416B00A8; Thu, 26 Feb 2026 06:34:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD93A6B00AA; Thu, 26 Feb 2026 06:34:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF386B00AB; Thu, 26 Feb 2026 06:34:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 89C4F6B00A8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:34:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4964A1A0B5F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:34:06 +0000 (UTC)
X-FDA: 84486398892.09.297879E
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 839AC40004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:34:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C44MfwaQ;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3zn8+Git0EggRmhaca5IE2gupO7ol+4qJNppzm+/Ej8=;
	b=KJ7ZR2h4oGzOyQ71BFTm7LhDEvD70yGoKo/4wnRKIKgR4pX8gQnVxmnMg0VaR6FcSoS0ir
	nTNV8eXkqJ6tzBi0X5R5Af8IiAiHIDvCRiLfW2V4mQQ/XC1IvGiWSiKPXDF/HOAVPbEMXz
	VXkfEf84AcGAHl8grhTE+w25d+1uNt8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C44MfwaQ;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105643; a=rsa-sha256;
	cv=none;
	b=zKnaiTq71OQXJP3Php2YZ7LJADnPKBlreDJfU5ZHsxQ1IuxoXQyZjXJWIBQydOwOCY15fq
	tQ0Ons/CwbSqCkQICH5LkzkdYV2Vzu7raZ7/76aDaW5vBQk/Ep7Cdglm5f85xXQZnM9pwr
	WU6OAIAdsduvfZpRpV6f+vWw44oHS94=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3zn8+Git0EggRmhaca5IE2gupO7ol+4qJNppzm+/Ej8=;
	b=C44MfwaQZXC9xurNJm1Gj33Zxo1gLQS8k4IWyBzLJ3bDH3iEaWw2xI76yUVCOJhu+N0fjz
	uImfnhnDx1t7VDozyvgsx0dmj2PUnj69wqMG8MPzuScq2zzmXFeTbiFWn+QmycgKIMWYDT
	hh2GKNuNvA84UQEGRKDJ+AfYcSWycUg=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
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
Subject: [RFC v2 11/21] mm: thp: handle split failure in userfaultfd move_pages()
Date: Thu, 26 Feb 2026 03:23:40 -0800
Message-ID: <20260226113233.3987674-12-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 839AC40004
X-Stat-Signature: threbjak49gwyx1dth7qin3u9bpshk5y
X-HE-Tag: 1772105643-652898
X-HE-Meta: U2FsdGVkX18Dc9En5MCumXpNvqv4IAwcgfbZ2JCK3BmK5xepgCfBWp6/wA9rugRevPM+LE+ycN0Sb4CF/oqA9MalD9fFdWAGqClRcpNrKl8rND1tXey2qgLEHif+Kpbq1zINQh8ITEO7vTCKGrv9W+squSY4OusBPzZmZqog0Xq0H4FW+XllvaNX58wburB7mHysaBKr4MwoRvqjMH6vcCeWiqGypNp0FBkhRGmW2JrJK13duardO8ksorDj+Mvfwick5jWVRpg22bScPAk/CZhaYBgGVaA5Zr9tRMXK9Imoaq8iZJ6PC+7Aut+iDLTTzqHZNYJ27LbONUI9JVrykJKWFoqeEi6A8U7c+swdWzv5QLMMoEOSHAgBlWGwU5f7aLurzqNY31Q/ExtPKcTURWraip0xvwvhfbRAjy5TifzzxgcsZ5d44FbNa+sFpp5ao/t+ymexHtHizJXFQtKCZneUi4AQ+aFMjhlGj+WNGzTSzvA6oj1Oj4+lZriUiLLChxZy5dRxuf+9zQQyHeuMD26/b1f5wV63x1AHjp7ukTn+u8sPhoIlB04uX2bc23tEC/O8bjQudG6AuYiLY5ujR1QomPKMYAYrqRsxjrU5aunVzkPnZFdk7oQp/7CdCQyIH1DlK+jsRUEjfLdAOr/CxgHox5B4Jlttnx8TULhEva3zNRT0tgkVryHbNBmQpCKsnS98liV2P1gO5njqWwjqJ/Sj5EUyahp39ZKE2WLXQOl/mGc0O7cDnSi8lCef4eQUww2azzUQRacbl4XixPplvG5Q4Liqvnu7PjToBLpM1oueuWk7iSNz88QxF9Ph6wdUdbJMD/+HgRK50aJA3WJdTEMi8u0IsRTIDEVu0U3vcaA1KFB6n9EKRWk9TnzXyLkPcqOZ+n/thRycdLVsR3hwlCI7zdKUDswtQ4EyWD36+7Z1UHbln3r+aUE7rAbaK6Mevj1dqRxMLqpyRlCm843
 q14kVtu+
 df96RWBHckEqINXpBi8VbO57SZ9RHHkEJoKJw+PcdMsVR5n4wRIy7dNjCj4SsRx71qbdLfgdIvL78TTz/TE4SOGkgZxHlDh2soDRGNEy2i/5L/Eigqrk24S6WdZSH/nm0J8fyeKadcCmqz32+EooU6B5pS+yS0ft3+78nLWXN5r8HhXt9q+aa7PBpxIc0/4Z01oAdtWOFzeXFWiCKZXWE52KdWjaGPCYBdeswpiX0QLN3NZNVaE6aUbtAvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The UFFDIO_MOVE ioctl's move_pages() loop splits a huge PMD when the
folio is pinned and can't be moved at PMD granularity.

If the split fails, the PMD stays huge and move_pages_pte() can't
process individual pages. Break out of the loop on split failure
and return -ENOMEM to the caller. This is similar to how other
allocation failures (__pte_alloc, mm_alloc_pmd) are handled in
move_pages().

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/userfaultfd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e19872e518785..2728102e00c72 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1870,7 +1870,13 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 				}
 
 				spin_unlock(ptl);
-				split_huge_pmd(src_vma, src_pmd, src_addr);
+				/*
+				 * If split fails, the PMD stays huge and
+				 * move_pages_pte can't process it.
+				 */
+				err = split_huge_pmd(src_vma, src_pmd, src_addr);
+				if (err)
+					break;
 				/* The folio will be split by move_pages_pte() */
 				continue;
 			}
-- 
2.47.3


