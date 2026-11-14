Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 655DD606A33B
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 16:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=vhq7gym0
Received: by kanga.kvack.org (Postfix)
	id CAD696B05B0; Sat, 14 Nov 2026 11:47:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C37336B05B1; Sat, 14 Nov 2026 11:47:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B74586B05B2; Sat, 14 Nov 2026 11:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85F116B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:47:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C177A03F7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:11 +0000 (UTC)
X-FDA: 85434304662.27.E3854C9
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id 71A6820004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=vhq7gym0;
	spf=pass (imf31.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794674829;
	b=1jf5MIxb4BgN6CI5Yg2jCsDbMdfi95Q/kbkj1OgEbhc5Z12EFJj6MbcasaaJ4B4uDDEgvf
	Z3/qVbnR5TRo9FA6zdKH8bqM6RYf8/K4TQoUQg2p99rvNbEZ8vI5mZo4GW8J2l0+Meb+sk
	P8DS51YSSVqGZMlZF9pVIaWLvwBBbsU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=vhq7gym0;
	spf=pass (imf31.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794674829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=f9lkg5AV718yKRuUDbng7AhiBPUBTF5d9AC5RxltnpU=;
	b=op8eFHWnrV0kxdU98oCt2I1T31KmxJP61EpBaoDLhXHy1sZ13eNJHJfOug8MyKbjCaFCym
	yWcp2TQ8BpTqhbU40/vDKYiTxYjw9L2QbBt9FevrTLbmcooFo918V3JQZlnwhN808zPnrF
	JIK/djbACHEm7bMz36uhtTUh/1mRij8=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jRg5P6lqJz5BNRx;
	Sun, 15 Nov 2026 00:47:05 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794674825;
	bh=LS3poxthHIQDOPkfmHKkqMcC+PRkH+aQtxDBHIIAQ6s=;
	h=Date:From:To:Cc:Subject;
	b=vhq7gym0cPm10dacpHkPYLUq47YPLV6jbU27ba1Tv9OpdJBWu/NKpHQWenqVfjzci
	 46lrYsFX9cQXrd1vEp2Whb4JGHW6uBbaR1VEdgAARVmsXIST/nYIQ+besmq5hUlIl0
	 RrI48zBQLHVGgYluriY2SVd1aPjTMetgeeK6s7QsDPw5AmE7nttyHh05ddoT/h8+Ml
	 3RWZL+WarbkOKURce0IAuBlMnv74Jgs3em+IUSyLWROFD0CY/KsQYOmVgapRpV+7cf
	 79Rs4IbDYEGJ2poK2o+LZfvMll++1YE1bxS/JPgB7mcke0hbPncTTRGK1aaSSzzbZE
	 mMYmf0w4i6iaw==
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 6AEGktnb089520;
	Sun, 15 Nov 2026 00:46:55 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 15 Nov 2026 00:46:57 +0800 (CST)
X-Zmail-TransId: 2afa6af89081cd3-30ca3
X-Mailer: Zmail v1.0
Message-ID: <20261115004657890Pz8ERDf5nCtE-B6M7KFzu@zte.com.cn>
Date: Sun, 15 Nov 2026 00:46:57 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <linux-mm@kvack.org>, <liam@infradead.org>, <vbabka@kernel.org>,
        <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBtbS91dGlsOiBmaXggb2ZmLWJ5LW9uZSB3aGVuIGNoZWNraW5nIGZvbGlvIGluZGV4IGluIHNuYXBzaG90X3BhZ2UoKQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6AEGktnb089520
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 15 Nov 2026 00:47:06 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF89089.002/4jRg5P6lqJz5BNRx
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 71A6820004
X-Stat-Signature: 3hfzbt9gu5zbrewyfe96o4ksksgk5zxi
X-Rspam-User: 
X-HE-Tag: 1794674828-31475
X-HE-Meta: U2FsdGVkX1+cAgThfnwwCkcb59SZYCIqbCgzyQwHLnDEb2lvQ54x17D6quAC6DJY0TP9rsmxrRhhyo18vT9Xz18MoA+GBlzmWfBFA1ZK52m4lshGSt70gA33cdt4ixkdM7mWbECUCQca5rL+xpLN/zy+NF8M6fcbn4wuYBYY9p107HOqDjJRnpix/pC9ELLlaFBu/5SyR7FeXBRjIlIPuzoJ4ESZxKLeqv1jgFIzsrVhCWrZZ70qPJmAWHpGZlKa/VOdMOBnbJhazbK0smiJSI4CHYjCWqImwL/PVnmsrqotzh3V09PcpRfxMMiJ9oXO1fxk/wy3uT64rvdtyggOQrAl+KL1Aiw711/60+6f7YFSPkJVcZ6NGzKfmRaZ6B97ElpIcye2CYx0mS3LYzrBijBxEFh6Oy4qPX6TfT0Bk4Oct+egn+kGlbKvYGjgjzb8fRqEVJ7XrMCVrVzkwkuvd6g4QHgoG/70WpCsqJMOKEjk5J1wrg+1Ez+KrC9eh0fXPPkY4i5dAuMxJBhTs2aWqRSqgXb+2WjG1Kf4dLSnPApCatIKrof5ET6mSPyVrEpeIjKlPEymvgY8oPTpzwklgtOQTPxPUjBp3XgypVBt/Th/kJ1tGLLzpLmc9QgUpEqRUOQlaKJm3zhyhC+zBEqWN9Qez1xhrpfLbWrC6id8o90UBSmGQDXBUBU8PqJU/dTbFQCnVcUiY4mDTqOdWEB3JoezOqthK9/AwgC2kfRKqey303C/B2DSpp1S+pn7Yylm8aa+EQnU0l9Q7IfiFayI3Ok5fZ4yh4eb/CQYTvDXC3FSnlQ41VCWsUnhweYiXiSDICZIxOQtLirX/QPaDW2AcJg6S6Alpr6hgHHDMSL+wjDc8dr97Yd32ws3vDDflHTB99dqFMoiuMsSo8eVenaks5OiQQSXKeZbmDRf4E029NhqO8zwzyViX3HpWgwBy1kL5LudGqtTkFi3XvE318f
 mfzuhqVd
 NWjidWLichhv5aX+9xbCmOn+WUK7NkMD9uxWUap9qvS+Bkf81mFCFmH7ehIsNSAHOdEBR5YgwiWr8hfQVvrNWTk1A+x7cJ97MuoGNL3LuuGvndaYCPOdekEZzhGZ1LvHIy+B0ss2vvwF09GLgydMEvWYxXAPMnAUbdW/A0kfJYYBjKqCDZWC7dHqP5dRqoKSA18Co/nctPNHc5cl6IZFojDkD56UVAXa1hnPtOHtOVXIdQPCgzYm8QWupLa8/z/bkGAttCRsCmpie/RcfYGfkC+NK15wOxKy1A/5B8RD8heNkiX+/+qfoJk2SpQOCZoKD9JgSemncqTcU9YWoqb4r+6p+fCvZSzVeq4oMgCl3ZxG5X6GP3KbMe6A4ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Shao Mingyin <shao.mingyin@zte.com.cn>

mm/util: fix off-by-one when checking folio index in snapshot_page()

snapshot_page() computes the page index before copying the folio state.
If the folio changes between those reads, the index can equal the copied
folio's page count. Valid indices are strictly less than that count,
but the current check accepts equality and marks the snapshot faithful.

Use >= so that this inconsistent snapshot is retried, or falls back to
the unfaithful single-page representation. This also avoids reporting an
out-of-range folio index without the corresponding dump_page() warning.

Fixes: d863a12108f2 ("mm/util: introduce snapshot_page()")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
Build-tested mm/util.o with W=1 on x86_64. The boundary check was
reviewed statically; the folio-split race has not been reproduced.


 mm/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/util.c b/mm/util.c
index a5140b3b70f3305cd78144a54d3b15a794da9609..6e6a8f8640a75ebb0f81f54c9a5085f698320714 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1462,7 +1462,7 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 		set_ps_flags(ps, foliop, page);
 	}
 
-	if (ps->idx > nr_pages) {
+	if (ps->idx >= nr_pages) {
 		if (loops-- > 0)
 			goto again;
 		clear_compound_head(&ps->page_snapshot);

base-commit: 84abb955b1015477aa11a96e2f3ac1b938b77f48
-- 
2.43.0

