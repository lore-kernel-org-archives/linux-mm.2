Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC094606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TrzuZUhY
Received: by kanga.kvack.org (Postfix)
	id ACA3E6B05FA; Tue, 27 Oct 2026 03:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2446B05FC; Tue, 27 Oct 2026 03:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858766B05FE; Tue, 27 Oct 2026 03:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AEFE6B05FA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:49:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BED9B80639
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:49:26 +0000 (UTC)
X-FDA: 85367631132.27.BE4588F
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf05.hostedemail.com (Postfix) with ESMTP id D026A100006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:49:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TrzuZUhY;
	spf=pass (imf05.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793087364;
	b=wEiw7/1HiYuieoQHlS3U4fNfqhKnLFDDGxF3CKLSMHlmXWUnwiLTtFzewW0Sx5sLw7P5XD
	flu6Avwt/6sEP+PCfaVuEKw7wOk28ESVmN0rVUU54m/MJ617YmlH6dno61qQAWbruGytlF
	BDME2yfb2gE43R1m7YMUl43+ey5aiwI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TrzuZUhY;
	spf=pass (imf05.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793087364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2JsolwadF0ifSqnijIzcvLeMzpHcVPvB+pPL56nmno=;
	b=QiQtQMrII192SRzKxV/EOvam50GElf6fvCpEGt76T10xC5q53Eq/njklhyYykLiquXriyZ
	/z8602ndemfW7APNLh4Axavp1Ti0M49A+RkQsCS/IaREdVJrp4xXwyMcWvSNz9RphRxhHh
	pfVein9wo7lZWMAC0Noiuoayzspw/Os=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793087361; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=N2JsolwadF0ifSqnijIzcvLeMzpHcVPvB+pPL56nmno=;
	b=TrzuZUhY2KkudCZKz3GSZan0Ejvinl2cY/LwKMmgk5My8LtfhdO0FT83kKPOPdoZ922n1KzsPxJvCjfLrAkMdru43LhWaKbEDdBMmYuX0O25/4T9TkDFpXHHnZAUs1SvYaNBkT1a52H4TdX0MR3aflqhoo68PXCOdird3djDym8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XDd8d4v_1793087359;
Received: from x31l07246.sqa.na131.tbsite.net(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XDd8d4v_1793087359 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 15:49:19 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tools/mm/thpmaps: fix missing order-1 file THP statistics
Date: Tue, 27 Oct 2026 15:49:03 +0800
Message-ID: <20261027074904.3328878-3-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261027074904.3328878-1-tongweilin@linux.alibaba.com>
References: <20261027074904.3328878-1-tongweilin@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z8fd8d96z1r4of8izjtw1z8hfyaonr7b
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D026A100006
X-Rspam-User: 
X-HE-Tag: 1793087363-345021
X-HE-Meta: U2FsdGVkX1/AssaEd7PDp0ZiRVoQsaicOroBtBHMpXo+BHHhU5tT7G8BVFBV9kStqaPbGx2O2kxCTmHmPj/Ly7SdHVJPR3pS16ofPs2ynuNIwNfRdxLY7hIkVd+foxqS5mqWr8OfitbXN5aK/PvYcq4lVbdtaymfa1YTYNF7PJu5vLBzsUtwsrJWfiICvtgXmXkbSGIFvQf8FozRJ+qEobWR/ei0cCQT2Cx0o2Ny7Dr4orRtBnI2r6VynNhL2YiFkTaJTJMYZCP7IcRksX6SRYSPsLYJf8dpm1325ZLWzCY4hQJrfjuICRzrut17Kc+tkzrjq1C07ATJ/zgqhB4UsIzD9UwnpCAl+F3ktn+i6aS15scEXaJMFUuG7z5+eIyGrn3Qje+oufPy8Fa8c96I0IKcumr3aDDJotmH7fF9DA2R5ABM0bg8Q8T2UZD+s9gTrk1zMmDEdUvmoYI29YvY6hnoUWRPrRCiuHo/k+F8JSWiqTo1ueWhEPMFO/8HGBwWLRQiWcbEdg4s02PQuitOjfIMG97p7IcvHRT1/b2uUNM0lfJ8HRBlKvAKZnUsBYzXSnQmU9cXLvX08Gi64X0jUcaAcgsB2wCRGI7ino/d07GJgLaG8dRZyVfLldP0kDjPie7WkkTUlU2k7dpKajlhjvrApbWGrSF1gzl+ZYKeAoj6Nar7RcnZgznEK659j36nZAAnhwds3h6yU31QDdpBKY7juSvREEaAhSlnOeCnclHAfd6Gz0LXHo6WPxUyY7LenJZTqo2FRmCkURnrmeGp5V6CM1XFXIuzKxJM4eV7/J3SQ803U4HdprMUi+wR3Km89v6c0BpTInNnRKHWieTYtlABlU7HdZz9ATf8paoqouiTiTxTkVriTKwSLIYqz3kK2eak886RIR57kQ1z3jmKnR2iuyBtVTQot4HQdClmZaKAsCMe1gDimhnVFykNRA+Vk0EdaDffeCHa1vYgtEg
 Kolbshmp
 bu08nb0LAjpEmquo1U/gBUidx88g47mlm2/jK/wybNtFak6juMlA9yxQbbBfhxbC5Rf7epRzrHcCIfdDwIrCFu3xNNRubo7WVUc2FF9bp+2El38TBo80e4CNpD2e8zd/mKj39UNmcXHEt+en7qcJr1ezseRCEOkSXSBcKMBN7l//tT2jTMZ7n8osaHeN5D/0TL7EbUAWfjrvo2MrR+nSrDO5EQfOYJ/Zj0WAEZh2b6tzzw+oL3NnKRzG6wQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

File-backed THPs can have order 1, but the per-size counters are only
emitted for order 2 and above. Fully and contiguously mapped order-1
file THPs are therefore missing from the output.

Start emitting the per-size counters at order 1.

Fixes: 2444172cfde4 ("tools/mm: add thpmaps script to dump THP usage info")
Assisted-by: LLM
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
---
 tools/mm/thpmaps | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/mm/thpmaps b/tools/mm/thpmaps
index d92aace005c1..30a8e915d677 100644
--- a/tools/mm/thpmaps
+++ b/tools/mm/thpmaps
@@ -295,7 +295,7 @@ def thp_parse(vma, kpageflags, ranges, indexes, vfns, pfns, anons, heads):
 
     def flatten_sub(type, subtype, stats):
         param = f"{type}-thp-pte-{subtype}-{{}}kB"
-        for od, nr in enumerate(stats[2:], 2):
+        for od, nr in enumerate(stats[1:], 1):
             rstats[param.format(odkb(od))] = {'type': type, 'value': nrkb(nr)}
 
     def flatten_type(type, stats):
-- 
2.43.7


