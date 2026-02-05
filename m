Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2126E9126B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 06:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3926B0088; Thu,  5 Feb 2026 01:50:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361366B0093; Thu,  5 Feb 2026 01:50:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26D976B0099; Thu,  5 Feb 2026 01:50:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 122C16B0088
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:50:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8CD513ABEA
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:50:39 +0000 (UTC)
X-FDA: 84409479798.05.811D56E
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	by imf29.hostedemail.com (Postfix) with ESMTP id 216B8120002
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:50:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=VWBY12cS;
	spf=pass (imf29.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770274237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7NK/38HffDiaa77CWAYEU6e56op6bsxD1z5sc9Ob4SM=;
	b=dHa8bniUw+J6yK+7RHl4mWZxeBeItBrXsyIS5nW3WIjjCzW/36QoKx9rGz/Br1m81na03K
	d1dg81+EqTWrC9csXxYcyVL6j3JGW+pWIQi5NQ+OL4JXxlCAimJUR8XYNmwkyHz/YX3t8y
	998qOveoLNXRGL5ULL8C5D3OgiS4IjY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=VWBY12cS;
	spf=pass (imf29.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770274237; a=rsa-sha256;
	cv=none;
	b=2xqRVxSY0aG68/0Mt1nZsXKa0rqp6BM6qdcEFDZ+BKArKZJf0oA4knSiKMEQHGqjSCTN/B
	2zgkDx7Psf6DI4ph5cq1+JO+QAMaTb+V35V8HtH5yDvhxK1OWAZALSzzH8jjeQ4ZbvTylG
	zTLf+W93BW7nQ+KPFENlLR3ePThw3I0=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 6156jg9c047526;
	Thu, 5 Feb 2026 14:45:42 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4f675X3nfcz2NcFwK;
	Thu,  5 Feb 2026 14:45:36 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Thu, 5 Feb 2026 14:45:40 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yu Zhao <yuzhao@google.com>,
        Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>,
        Shakeel
 Butt <shakeel.butt@linux.dev>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang <huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [PATCH] mm: bail out from partial cgroup_reclaim inside shrink_lruvec
Date: Thu, 5 Feb 2026 14:45:28 +0800
Message-ID: <20260205064528.32794-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 6156jg9c047526
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1770273954;
	bh=7NK/38HffDiaa77CWAYEU6e56op6bsxD1z5sc9Ob4SM=;
	h=From:To:Subject:Date;
	b=VWBY12cSctWhVMIUcY8BCqW8NocjBNMiUw3Eg3gMaIzcqyrjrzXmRKGkv5VMzdVl/
	 L2e7W3mCHSv8pKUbfrRrfDn7yp/Ms4h1NChzUcpTAd7imhEEvJtk1KEy65fulSgt2j
	 kKa8pIIdlf4JKZmPTS3aZ+FdcdERxsq+9hkVXcNtUziyvyFNS9U7nRrpHzkTpl5I0m
	 aJ/6Q0A92u24r35cDcc9Gwx4liHuMb/HoPRpsLcGmbpit+p/uj7Fo8w3AwR8K3+V5K
	 m1IwH+MKkiDqR9PfX+PtBnGg3VCbFeKkp50nOD9MJmXCA4toe9GlU1yWSjB6yVXqro
	 iZ0KmTxacII5Q==
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 216B8120002
X-Stat-Signature: pdtq8a4smq9i88c868jzt4xk9nmaun4x
X-Rspam-User: 
X-HE-Tag: 1770274232-384521
X-HE-Meta: U2FsdGVkX18uz7vA9GxdpJ7WbwtTP91kAFtTQV/wtBlRXKkVNLOYtgJX7Il/3ARvQSPXj7bRD1vrNZX/DC79KUznx+cx5sIEcdP5OFY84rQIfzWyZq0jh+mIGTI03u4+IdHhJgHy+J6sP+vCyqe+ZmoXYWyfoPNK0QRQo4VhoA0UthsvbBohhpQUJtorglfy2m5mcRh9QClv3vVcz/1hr7X3TW9y8BSEUqwJMfsBmXWOBYjnDxnmwoIlbIj36H1kRTEW4QhGrAmK/ChXTrlQNaiXzSvX6PJGb99dIh5P0MebCfYcSqrjaaGaG78MDJS+kf36bF6hTsbYHVYvn71VApd+IlNzWxM0NMFHSkFoaqC/PUNdEPmqnd9IDV2GDDrgyWAzVXAaCSZMu0GkBgxB1z1VPTcDD7dKRZ19sR0VUFJcUMLNyQXmTCX3UNb8uCIv32p4mMJIwYVYoFPYoxm8Q9ROWibFZqP6LqkriUSpTOz9CNNaFluSTKZSGR40wlGzjHoFMUJ2pdZzyDvMZzatu2N7x/LAh23mSv+opQeIWVhvoP0zcPqrtdjn33SSF/K0zjc5lMDjQl5+GaSyXpetBmnl2hK/eUqybj0sV9Fb4v3cp5Lj2H1yxK9bLmruIp0x6g0/+yrdyK2waM4xnMc7SRgwi2c3TIWH1Brzg06ltvtAd6iOucV6+XeLIXeFGz8KtucMIjSwHwxKjnlYEfYUlLaP1ZfRyhNXQ6fYgiEvbB3nYA1n1BFos0xlsyjpgq1INRVjLGOii/DB/wVB18DtMoMDomEINp4ZvGhrH3xq4N4QS5WUrcfw0kznVquVNMl9tP2A1FTWEOMmARRBH9FILJ9FK69N6jJLCbZlJH5oGD0Orc0xHhnC8gm1FvDu7Rp3kDsDxdQsZ7wIbYMp7GKHVmoCabLl/OxKdWX+zI5fctJRDuf1DHGEX3TQugSmQ20qCnnh5VJo76JNwuA8aPr
 +Ggj6k8Q
 jIzgQJbJApHCxUqNPaH9C/X+AaZwA4QYWxd2lNEnc2rWWcDm+JalGAP+WjSZkgm5pP5BIC1AhM+/E6AeOg2GxpJJVAy1Tq4DRSrbHPp7xfdTiJEEEshcqVwYJwlwDjzJ0c3endZJellAarO6jR7Uz/flX/j82ggtBiDNC3MIpqPW+Bzvr7GDOtOjxDFVYJo7kZ249yZQAooloKRLv9gEln2HqMcceu/xwU/dyhfq51gFJGY42BtzfQtexk5MvwRxaDnQ0KC70zBdb4lnpd3uSXAlQcBb01z7kW1CReVkP8X9NTG1B094CSK4+Sly2SxhIbcuqrFqMfYS5NPbqFG2uxS2duqiwdn+6sgsW93sbPKS/bhV0s8pkDKnBlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Oversize reclaiming observed in "echo xxx > memory.reclaim". This commit
would like to sync the stop creteria in shrink_node_memcgs to
shrink_lruvec to have partial cgroup_reclaim bail out as early as it can
be.

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..03bda1094621 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4832,8 +4832,8 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	int i;
 	enum zone_watermarks mark;
 
-	/* don't abort memcg reclaim to ensure fairness */
-	if (!root_reclaim(sc))
+	/* don't abort full walk memcg reclaim to ensure fairness */
+	if (!root_reclaim(sc) && sc->memcg_full_walk)
 		return false;
 
 	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
-- 
2.25.1


