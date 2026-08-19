Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6151EC5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 02:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30C316B0099; Tue, 18 Aug 2026 22:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294EB6B009B; Tue, 18 Aug 2026 22:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15CCB6B009D; Tue, 18 Aug 2026 22:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D35586B0099
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:16:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6028340383
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:16:32 +0000 (UTC)
X-FDA: 85116405024.09.DBFF9E3
Received: from mta0.migadu.com (out-111.mta0.migadu.com [91.218.175.111])
	by imf16.hostedemail.com (Postfix) with ESMTP id 81D11180002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:16:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zfqpwbf5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.111 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787105790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I1shSzmFovxJ9e821em400uZT++kwT5wukUXXYKqPG8=;
	b=GzrzvqWhXJwiKwSHYSDlC2i0JiwFp/c18xJ9cAhuFQDwg8MR4dt+G3rrYYnrqxejyqgllm
	FJsthNIJA2atVF4Siop1P5AHKcaCR8Tjoae5xgJlpOP/0eXFbzKvS6SnFJurZkYsgXNLd0
	kUPEH4tTrEMXon+RbVxBV5fCJ6irhqs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zfqpwbf5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.111 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787105790;
	b=0fY5BlOf+njnVlJvPcS1+2uiqj6+bFKFcAxIyvaGEmm1UrXWLcoOc3LCnKlbEpUMLp6kFd
	k4IPwg8W69trbiQEA6nGO+Zye5/8feUTDLOutqBWNbk5Z/MnomCwcl6fIDxnKt6YUiPEHg
	a7ArCrg+wRsTKRtYTCRyzcUI56ZxZd8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+IgmQ3QdqUivnU4s8tJXVFnhCQ/DhysrQg5XBqnFDwM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787105789; v=1; x=1787710589;
 b=Zfqpwbf5U/5+irehiTBSG3Xey7pY7NKYFdg6tnFtteZLpxydiOEdTn8EVH9W2Ebsm1h6fVsP
 DoJmwSDWj/Lw/AnW+LRvMX29gBxEnYtBMBvv0S7VNPcHdjqHy9H2mdTz8TXiBpXTmuHuybj0KXr
 U5txFejm6WFKmpE1e5vMuR1k=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 3ab2666dcb9d8750;
	Wed, 19 Aug 2026 02:16:29 +0000
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] tools/mm/page_owner_sort: show available sort keys in usage text
Date: Wed, 19 Aug 2026 10:16:11 +0800
Message-Id: <20260819021611.2910835-4-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260819021611.2910835-1-ye.liu@linux.dev>
References: <20260819021611.2910835-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c4be8h8ey59o8wrtme1t8834zje1fmid
X-Rspamd-Queue-Id: 81D11180002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787105790-723444
X-HE-Meta: U2FsdGVkX19JHroWWWblZTNgbqEh/LR8HMuK6zAg8le2LRPyYF79W02qdi+dNbjTwkcRIRb1hNpQMAeABuVEGpxgPeTK4gBUDfWoIF/GeHfPF/cJdXLfkpZs5UVfHfQND4Iewe0+oP8itb8UTg3gtJgXAdNzkF0yjASl7XW+bwVMd2ELlFTa5XHqj2WTnFSUyVwtCP6Dm/djUuN5LmvnrFTXidbhJ52sjGhaoWnNTf/T+i52u48gY7YSsM7U5gC52dNdDQIDOgDx5S2dBuwyr2vfDNAW+ZzXmscIwfFVGt4glKYVqM6Rg8CGLnwvFbR4WISAz7MSYl60efElUKBZDQoJP3KZwHcEKBRcx7KIhvCQDSgOeqM2FADridrmycOTyUUXT0jkQG/qhOPsENMuPvgbwD2B/P0Lnvzrr7wZsqWCJlDa7+0AUGKAXubT0NNPBqrKhZ+ym/0Xj3KDiEDP6DjzleIOabyES8WTnLdDNqVaHlxtOi1q7YFNPWSoPSjdRVL49Jh9i4KRaTcv0Pr9ykFYsBOC1vvvasQSwas3DVsN0SYH2dvDH9WZPcuGUkoL5BCp629L3jWQwuJRd8VsTeVF83c9uvmljlMS/KOulCrrAhYC3Jwzu23SnvB68I/gZuRrKCerkW3LknmYMdbQBV4elKcX8ciGuctgtdHUATTfj0utYvVZoKBWS6CbGfEiq/u15N0kSyPy3FIppjZtX0RjNAVG4grDs1aRXEEhpmWNNa3V1SHJXS0sh4mkpCXvAdrIj6cJE8b+UuWTRqQ90tHj1o+0hNLh4Eh6l3NUSYu8xjWNjbsybzQYZhH58xMgAXqdnTPN16yVEdCN6w7xOR9Zj6NGeyIgOHSlpgxs9kSJSvVu6Bi1SkmAxf72wi27E9owpyMvFySjmybsBLI7kIv82shivaMTOEhsk1H5aByIoZcs8zR4qqIfs5eIEDw0LCaHjuYbaNkZECNKPmF
 EKEg0st4
 BmKuIQtKc1aIfxhla1Ojdy8KZ7cDywUYER2uRkgSNaVp3CUwsBZfrEzxe1Crmd07ZcHtyoJHqBICCAV4Qu8DMGVjp8XhNbRCDNxoa/a4mVQXO2Tr3IGGs+PJ9X4mbb5g5Faaj3JILv6tcKq4z4qzzD+xnhe3Az8h+giSXDR5VrUOtjaZ/YK/5Ciq8it0ipmf1JahMCSAt7h2o59pUN/ysyJsi4a81fiSMN74bFmGZOc5W5QzLTk6ChzNfgEBf+J36zDvaeuziTMDQJ6t1TcOlTcFI7XFJRiZrtnkt9HZNpIeIUaU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The --sort option accepts abbreviated or complete key names, but the
usage text never listed them.  Users had to read the source or the
documentation to discover valid keys.

List all available keys (full form and abbreviation) with a brief
description and examples directly in the --sort help section.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 tools/mm/page_owner_sort.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 10a814ba5301..5c1b23c0ed8c 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -772,6 +772,15 @@ static void usage(void)
 		"\t\t\targument in the form of a comma-separated list with some\n"
 		"\t\t\tcommon fields predefined (pid, tgid, comm, stacktrace, allocator, module)\n"
 		"--sort <order>\t\tSpecify sort order as: [+|-]key[,[+|-]key[,...]]\n"
+		"\t\t\tAvailable keys:\n"
+		"\t\t\t  pid(p), tgid(tg), name(n), stacktrace(st),\n"
+		"\t\t\t  txt(T), alloc_ts(at), allocator(ator), module(mod)\n"
+		"\t\t\tThe \"+\" is optional since default direction is\n"
+		"\t\t\tincreasing numerical or lexicographic order.\n"
+		"\t\t\tMixed use of abbreviated and complete-form is allowed.\n"
+		"\t\t\tExamples:\n"
+		"\t\t\t  --sort=n,+pid,-tgid\n"
+		"\t\t\t  --sort=mod,at\n"
 	);
 }
 
-- 
2.25.1


