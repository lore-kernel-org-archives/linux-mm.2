Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00F85CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 15:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 408A28E000B; Wed, 10 Sep 2025 11:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9918E0006; Wed, 10 Sep 2025 11:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF4C8E000B; Wed, 10 Sep 2025 11:31:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 186C48E0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:31:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A7CCF13BEB3
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:31:24 +0000 (UTC)
X-FDA: 83873729688.10.F0F9055
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id CC0D914000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:31:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WCaM0rba
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757518283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5aVi8r6jhz0kPtGNnXfUNhQ+jvyUjBVH+/xmLw7VdU=;
	b=Vcuvl2yRKgYBmRzM611eg1swZlc9wRsLjKweLxiQxPDtE580iSsHftqyGRVACOIh20wg0B
	rv71dtO8tb8brNFHiAlzpAM3E9RgsXx/79S9wxPXP/lqW/DckVQPjHbHrRl8Sa8fSOG+bD
	wCHhHI4Um5m1amHcRzF3rnaAb7im5YE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757518283; a=rsa-sha256;
	cv=none;
	b=dkzQqTk6gtPrUO+evgHdpiG1ZOoeChGmmvm9U7UURvfRJ4EuJ7Yg2RI9+D8tEw61uMOAr2
	SPr2/9p+Um+7FWWFVifrJNJnKxnkRelMHUmqmK+aPkvPGomzLv+f+FfLqBDnyE6GF/uSse
	D5K8/QUINYIz9mH8rd252rKqBCoqY2Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WCaM0rba;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=z5aVi8r6jhz0kPtGNnXfUNhQ+jvyUjBVH+/xmLw7VdU=; b=WCaM0rbahP74DCZA0P2R5ngSaA
	DNXMfZHkvQ7Mq31/WAhWddxnJR053xZwyVcj4bu2HNYO4Iy2rAA2SbIs6FHtvQeFCdsJkLcp9hBRj
	QjFKgjOMxjmOBP4VD1Y4EVsoe+PAFe2cuFPBw9jkcSPDwdNVGzwPJljd0FHRubEux4eCSw52JOiS+
	ZIwYnYOz/4jENF4Bky5VFasw7b59GjM3ojp5Lgi6ROdg1Fg4io1IluYHPN9Tqrg0vEupS79uW5ZJF
	XoX/dQqNn7TrfEamyU8un+L7QnOH38U3bTZHxYDok7towxp6ycX5hx8qEUR64JjEukO5VwfTLtD6C
	6nwZiOBQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPp-00000008MEX-04EV;
	Wed, 10 Sep 2025 11:55:09 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 03/22] slab: Remove dead code in check_slab()
Date: Wed, 10 Sep 2025 12:54:45 +0100
Message-ID: <20250910115507.1991829-4-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CC0D914000E
X-Stat-Signature: dx9ta7xgagimteebsbs19irnojhdnt6i
X-Rspam-User: 
X-HE-Tag: 1757518282-391112
X-HE-Meta: U2FsdGVkX18Z14a7+aKblT7cZ8GHB866IfAlIA3Qat+rloMFCeUADkBwmHp5Tf97LeR0hXgo9G+JeSHQpYnqcMGIB1Wgrt6V1HarYZtl6gajjeZwjYfqI+tjsOaswL9yaR9g5+bCOWMTLqxMauhyNQqnA1HO2x/c+04Y0wXAH8RlCXNyVrJIWxjgaFoHbkmwwuUQZk5p1UstVzM44C1pzFbOMU9xf36bzKZ3mwrb8lJLy0zbj/F5t5CpcIyGKsJu+EM0V0+luR6HPMfOB49LmFIX/tR1+JOa2WeCcP/EtMBW679x6g4xSSwFCzOXdvvNIBQ7uSx1fxG89N8Qun8F1fxbq6SA0ngJBcedBKadAv4uKw3rUU8RLE9guDmpC91XAUh+wMqOGsN1x8/BZb/1RvYyj+/Pec/PS2vX87IpYzsSqGn9nq/sYZr90IwviLfClvZCwpVgfhuOcErQvIKBpsycDXcj+wC+SgWXtdtvFlEmjmU7HrMobf4R0E2xgfOsPiSkQypIiZcSpyTu+KJzZkRjoWrL98QfcoZ3nPWnOVuZuTrHovD/WVWZvvvsFAQLGKUnRHVkT+QvYuJ7RjjZ365rSfQir/vfI7ZxmN3dUVx7vY209gO+CCwFqsaoitY5NSFLXn/iRrc7Uwdu+ZYMBDzfq+f+JeoNEiWo+lnCk67CiuEFU/NVk1eJTapRts46ZP3T2E1DURCMK2yVb2+jqE/+eJgZWslurCzyv2FRG1jsHYKYWELOVflu6MZlIFij2tq7p9W8Re1MBMOXfwiB3fRspGg53F+82TqMCilKsOjaJK0CfIgElWPtNwiuiKKoB28qILGNVStjAGlG8zp4xx1wSQmaUJgB63DB81da3hDEcF6MVnOX/VJLmYXu3jXMxJ4tryTFtg5KllKnczySHWa2qUZsEbV9R0uXuR5OKjB5Kkd/In1ZMt+At0rT/j825ASnq2/qL7Vj74TemQk
 e8nPXDYp
 HDQi2qdeiZmHG2ZMSf6ri6DaXQb+Dt4kdNOYqbc6+D1RpNvmfVKOe9Kg8ErE07Savs+gogMO79X4XhaZyPb2K1hkzbSrMIzDD06w/VvOFISbXT2HAQMkhQrVyULc1TRKOSD/e87GgQG2aGdXHXvE5J6Vjo/anpW2/coc93VZONV8jm5EkZCNXSY14cXsdIv5Kfjqo0EbjSaZa40h8J/Pbif1Jw1AKQIu36+Hyex5/I17mm2khqLt/CaI9Xw3leYYR7pp04iNzn6FNAHLJgMuM6/D3CPw4bEZIBPNG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We already know the slab passed in is a valid slab.  This looks like a
sensible check, but all callers assume or check that the page belongs
to slab.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 81f08891741a..ac879e9127a2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1515,11 +1515,6 @@ static int check_slab(struct kmem_cache *s, struct slab *slab)
 {
 	int maxobj;
 
-	if (!folio_test_slab(slab_folio(slab))) {
-		slab_err(s, slab, "Not a valid slab page");
-		return 0;
-	}
-
 	maxobj = order_objects(slab_order(slab), s->size);
 	if (slab->objects > maxobj) {
 		slab_err(s, slab, "objects %u > max %u",
-- 
2.47.2


