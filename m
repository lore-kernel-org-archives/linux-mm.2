Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69A33C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 04:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F73E6B00D0; Wed, 21 Jan 2026 23:16:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87AF56B00D1; Wed, 21 Jan 2026 23:16:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77DF76B00D2; Wed, 21 Jan 2026 23:16:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 676906B00D0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 23:16:15 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED2A61AE632
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:16:14 +0000 (UTC)
X-FDA: 84358287468.24.F72F917
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id B2309180007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:16:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=UP6ztmWt;
	spf=pass (imf06.hostedemail.com: domain of maninder1.s@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=maninder1.s@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769055373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=ulwZDueuEPaWeca2kmd0L47zzrWdpEGAgSW2N/gE+Yg=;
	b=US7LZMExQumzmLva+J/JSyQVwkrISidegXWqswP4KXol4yUdFeXQoqlMJ7xOVfaZ9bQnoM
	nabGVu0ApQE/MZabJ+QCtJg8PPpH45wAA2n1XK8nWz+KuwTBKQsqohmVo4bsO/LoPZzes5
	Hu/tKFb1QvD8eBGEV0JgydwUkQonHwg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=UP6ztmWt;
	spf=pass (imf06.hostedemail.com: domain of maninder1.s@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=maninder1.s@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769055373; a=rsa-sha256;
	cv=none;
	b=OxUMydSk/vKMTdSYv1xRuM+eRGYxlW/fQ1LuQ6LrvATpDKjdpETq27qsRYr2X7Zt8Q+LOJ
	YZq9OH6OW1NBe/TXAPLIlug5yjSu6w1H7uLOHmMtzYN/YEmqmvJGlvFQ9s+Tmf+ftQUBUy
	MAZ6V3VohsyjbqN84qwg9GJKIF+B694=
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260122041607epoutp0473b9f4d27e830821d5aab81df33f33de~M8nvJM2YJ1384713847epoutp04C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:16:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260122041607epoutp0473b9f4d27e830821d5aab81df33f33de~M8nvJM2YJ1384713847epoutp04C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769055367;
	bh=ulwZDueuEPaWeca2kmd0L47zzrWdpEGAgSW2N/gE+Yg=;
	h=From:To:Cc:Subject:Date:References:From;
	b=UP6ztmWtmEqjyzx6T9Qh4hbepx8uyDTSmNZgqAUTiNecrZELvZeG1AuzD7eFazOq9
	 cOpv/YuTN1L+aJrQ+MR/XlpbEw905LmXDC7cLir5xsrdCsWdnimb9hgqv9ffyg9HRB
	 ivGRf6sneuU2uQQt6Q2emIzMOip73/UDGCiSRnxY=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260122041606epcas5p3c2ae4cf2d797eed268772f8c60d1e326~M8nuuy6-k2478324783epcas5p3U;
	Thu, 22 Jan 2026 04:16:06 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dxSRV4bksz2SSKX; Thu, 22 Jan
	2026 04:16:06 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260122041606epcas5p4fb3f5c418b79bf19682e60022d7f1718~M8nugqkEh0494404944epcas5p4w;
	Thu, 22 Jan 2026 04:16:06 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.97.243.203]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260122041604epsmtip1810334375c21d205d0ec8887af3691db~M8ns316Pt1745917459epsmtip1m;
	Thu, 22 Jan 2026 04:16:04 +0000 (GMT)
From: Maninder Singh <maninder1.s@samsung.com>
To: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 1/1] kasan: remove unnecessary sync argument from
 start_report()
Date: Thu, 22 Jan 2026 09:45:56 +0530
Message-Id: <20260122041556.341868-1-maninder1.s@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260122041606epcas5p4fb3f5c418b79bf19682e60022d7f1718
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20260122041606epcas5p4fb3f5c418b79bf19682e60022d7f1718
References: <CGME20260122041606epcas5p4fb3f5c418b79bf19682e60022d7f1718@epcas5p4.samsung.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B2309180007
X-Stat-Signature: i6j7b6oqm1rx6mz7jmekhn8ngpi7ypf1
X-Rspam-User: 
X-HE-Tag: 1769055371-625901
X-HE-Meta: U2FsdGVkX18bzeRIjnaFBFfhWjdLasxIU0mIUJiAok/fFcmjKWhgX+xfWkwhodkVSs3wv1sHFZllpySZB3j/leF3Hd/8pcxBIO3YseX1aUj/SfVK5YUPE60Uh15r2D4FyvWU+MfN5xV/rQpzKL1p4ZQ9U4v/xmsBItlHG8LoNkZek9btXEV22a3jh/ECp184BCS6h8khVxWgKneur8rhvrM7YTz2HkSBa0sQdMasy8X6yoVA65R9VNVYtJhgI2cNnsadsPGl5oN8PjT261E+N7jgLrKJph1Ls6JFodQA5CsuqlJmxYawEld1C93MgPddJcJcnhr3ldCdmWtfEotkQ/qgdL0tNB3QuloxANSNFKXrshtBOYJiO3575IP7AkQMAgTxHlhi0vkEz8j2AtQ3/ExsDFu9pLbv2/XV6dDnLLxB91qvDl1DBeagGd3TfD/wr9K834FbHlAfSc7SgJg6QzyQjzSFHLnLXZMn1/k9m2JUuaqzHS1q+S8eySQNPjHSsB7gsA/ys9PqgVkM1Xlp6UGwop0SLTWV0Mrr17FuYs4HUJdQ9Vj3iStglnhwPh64Cr0i/mO1FsIyDZBr7wejy5RPSGSJlrJGJbUVEAkx5InAtyoCj2PQcqKDTM+65QTe1iCifOp9qezoKtWHCQHSSIYypcQVQ6PI//PglO25f4QyPm5QPzeoOixem0fkKobTRkxzEX+PQGlrxmw5wIq6gNn4sW8s2zlb+zv3t4y0v/QtQoLAW0fAB6pqSXSImZtbr2CoR98UEpYkpwQfhPxpfiAqfEdRGp25jK38yLkI46q/5IzzTCpIbxstD29TvhmCe/9tdU45RzVzrNDZLwWFusu9xdsZKZifJUhQpjRs/0Ong99BsaOgSmwt4CEglB7+JyWDDuQUQf3rzd35U3+26rthFGmrLX6pUrLbgXNwPBxoHtf0+k38z09sUOetHXhXYCvhxQ5iBrP7WhPhdcs
 D3awyb1Z
 1UZggdJf3dCvwinYVlWEj0Cj9JDSsNwqqJbi8ptcPHPxucZx9HBnYQSk5pCh5dxQNp0PFeQnkSU7GspSNy1Turh4SkzMFMfa+uXSisZIECZeCwfYfDgHvNR6Ru5y8n2Ttq2f6XqKYOpAAiCJOjdcL40TWIF1oKi+eiWRIcUBREOshnvxuPbj46pVsSD6c1g5jCKxuMb2yPPtmbjI5IITgrRWa70zOO/tzcFEZoYahmDwJiYycYbKS3Q0K/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit 7ce0ea19d50e ("kasan: switch kunit tests to console tracepoints")
removed use of sync variable, thus removing that extra argument also.

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
---
 mm/kasan/report.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 62c01b4527eb..27efb78eb32d 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -203,7 +203,7 @@ static inline void fail_non_kasan_kunit_test(void) { }
 
 static DEFINE_RAW_SPINLOCK(report_lock);
 
-static void start_report(unsigned long *flags, bool sync)
+static void start_report(unsigned long *flags)
 {
 	fail_non_kasan_kunit_test();
 	/* Respect the /proc/sys/kernel/traceoff_on_warning interface. */
@@ -543,7 +543,7 @@ void kasan_report_invalid_free(void *ptr, unsigned long ip, enum kasan_report_ty
 	if (unlikely(!report_enabled()))
 		return;
 
-	start_report(&flags, true);
+	start_report(&flags);
 
 	__memset(&info, 0, sizeof(info));
 	info.type = type;
@@ -581,7 +581,7 @@ bool kasan_report(const void *addr, size_t size, bool is_write,
 		goto out;
 	}
 
-	start_report(&irq_flags, true);
+	start_report(&irq_flags);
 
 	__memset(&info, 0, sizeof(info));
 	info.type = KASAN_REPORT_ACCESS;
@@ -615,7 +615,7 @@ void kasan_report_async(void)
 	if (unlikely(!report_enabled()))
 		return;
 
-	start_report(&flags, false);
+	start_report(&flags);
 	pr_err("BUG: KASAN: invalid-access\n");
 	pr_err("Asynchronous fault: no details available\n");
 	pr_err("\n");
-- 
2.34.1


