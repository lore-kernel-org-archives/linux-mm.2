Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D9C3C4452B
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 02:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7F126B00B9; Tue, 21 Jul 2026 22:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52366B00BA; Tue, 21 Jul 2026 22:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6C386B00BB; Tue, 21 Jul 2026 22:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 221986B00B9
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 22:38:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73CB280354
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:38:12 +0000 (UTC)
X-FDA: 85014853224.28.F846D6D
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id AD157180003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:38:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VVDNMvrE;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784687890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0NUjMF0YZdO+mWLr8nRUv6rJ891UqYSF7C3pZ4ivN0E=;
	b=wvgDDvcXYHT5Ni+8pz3V9R6CVwW5YvsG9j2QypHsY7dItPmCabh7tASC5RbCI7E9kQOaSc
	WgZY2ulcDCalupgL/b7mJUwh20DCklVRYuX90i+eapQxXD2apxTjCwXdvoOF+2GxWak5Ws
	g1qcgfqs+1Lnq16+Utr02P2tBQMAA8c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784687891;
	b=AQ68WTDJVSdNYp/4ZcfWX1YqPznWYEpMXru6bQ2or8yl/BEjnsym65oK4njbncPAUB0tGd
	el1CuHsY5tlPkQmQnRcv0tFatzPniqEOZ6OrD3nQAaZrsuaFIqFAyLUlQfNYNTOEyispsa
	8sNHpsaav9psMDioImxF8q+Xx1Dx0RE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VVDNMvrE;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784687884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0NUjMF0YZdO+mWLr8nRUv6rJ891UqYSF7C3pZ4ivN0E=;
	b=VVDNMvrEWyE7yjD8VHyqPTE218LHSp/o3tlLxXnwLFcrWDr8PSVimr33+t6AbU9t8LchoV
	NcsJ7rO7SDQzCexd2Pbh0y7mstQoQWk7TancWsh9Aa1JIxXfGuQ3j32xERl45wpsUN1Jy4
	ycZlfdJci8mU4zZ/iNRr1AUedWK/fJU=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] tools/mm/page_owner_sort: fix --sort option being silently ignored
Date: Wed, 22 Jul 2026 10:37:24 +0800
Message-Id: <20260722023726.600200-2-ye.liu@linux.dev>
In-Reply-To: <20260722023726.600200-1-ye.liu@linux.dev>
References: <20260722023726.600200-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD157180003
X-Stat-Signature: q6k5mqkw7rfuiodkazcwzoxq8955ysmh
X-Rspam-User: 
X-HE-Tag: 1784687888-506582
X-HE-Meta: U2FsdGVkX1+AxkWtW26/Tv3NZSmiYh3ueQa8HyZPEV8ldXGHss4oLPOq+SWIOpytCB0V8lmUBTVNSiXd7qc3tYTCSTNEJqhUJjzwDxPhoBzRnvMdPIdwFL/tqbNTch/Qi//2lyoNhHzPw0VhbdU5jDwLbNAVmX4HA+nxjNQLXYgbUnqdwkBiCD3sN5MrbVJ1UMUPD6UslecIbZLQUY+Pe0xbnKq2MXBmnTTvYT+wpLo/C7KwVoQvICTEgAbiQDAteloKjg57lCx3ERvSWS5W8zsLMQalY3Gb5pYcxuZnRs6SetB5DwaDIffjVdCmAbQ88ClS4bHbCrUf1u5qYOG2ko95ApzkhC2D19AxyWA9EcTwaf0MS/ycz/hT4OF9qIpY4I8heELmQVICHkgzjQQcsbQEz14++5cDm1Qo+8EhCgIwh2eJBL5PkIAjolw7twRfIAhvG016cUUJ++em55mgRuS5nDw172Eyx/gLEODMKkvGH8ygU2Bj/8PGSA0fmTePKpyAl8jYDhnFifNmEzqmUwxeCI6AoNvGpSdeATKh1TMawiOC/dSoGA352+Sh3PkLViuvCdXr1Qn8DldfPaAIZ0ll4G9raKcuKRqxMypAJR/NtLSP4kFLb/52zZfw9sKp8L5hc/LUqmVSwcwy4DnMaSjNesyBNJJXs1lbulUWO9fyC73tnotJnkzfZ5H7DAZEOCJ2IBXdtnX2vy3HXDWcNW4nFuEh1TA6CCoQtM+iEc2QVQ2uCkDKC3KRBgwh3tO1nYzKFg9b73lrBCJy3C6YXoyT8QzY3XM/3fGywHuzKipOFA4Nj/tbKh8M9c3QtTJDBw5dhZumyDZTj1/yPCBZub9u16oiaXYt4vpGFjH4uIVZzrPlI9Y4Nf3AzlCqEANugLT84geVwln+0Xas04rspofLFxnLMWo5jfOJ5JM++12XOjjN2QhTxdl/4zbViEw00/pVXnzAIsf7gE/4woA
 hh2toC0Z
 2KZHcz6pl13ePV35oW4eAAHNn90/HoLhxnRMBFJy2fJSHNnDiwjCfehaaEUI5ZJ5hfF00yKB2jGJDiU1cVc6eNq56vsdItZYxuMFwF6I4YM/rjkRYl9K+NpjZ49C4Q3noWPOvunwtL4EqeMjIJ9EfVMxFnWqUhqDlP5zpRcqgtdx+4wnwmRLpNf+lcLo03Bs+thOuGOyVZCnJxLVeFGY3It6JuYLBjLwzHPYS7IE41T52sgP/C2vSrwXH4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

When --sort is used without any short option (-a, -m, -p, etc.),
compare_flag remains COMP_NO_FLAG.  The switch (compare_flag) then
falls through to the COMP_NUM case and calls set_single_cmp(), which
unconditionally overwrites the sort conditions that parse_sort_args()
already configured.  This makes --sort silently ineffective unless a
short option is also supplied.

Split COMP_NO_FLAG out of the COMP_NUM fallthrough so that --sort is
respected when no short option is present.

Reproduction:
  # Before fix: ascending order (ignored --sort=-pid)
  ./page_owner_sort --sort=-pid input.txt output.txt
  # After fix: descending order as expected

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 tools/mm/page_owner_sort.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 35d3d254941c..3c86c8d0618c 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -821,6 +821,10 @@ int main(int argc, char **argv)
 		set_single_cmp(compare_stacktrace, SORT_ASC);
 		break;
 	case COMP_NO_FLAG:
+		if (sc.size > 0)
+			break;
+		set_single_cmp(compare_num, SORT_DESC);
+		break;
 	case COMP_NUM:
 		set_single_cmp(compare_num, SORT_DESC);
 		break;
-- 
2.25.1


