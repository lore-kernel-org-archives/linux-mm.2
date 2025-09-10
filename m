Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F28BDCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 15:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DEA18E0022; Wed, 10 Sep 2025 11:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6068E0011; Wed, 10 Sep 2025 11:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CC538E0022; Wed, 10 Sep 2025 11:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF1268E0011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:11:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9033613BF54
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:11:24 +0000 (UTC)
X-FDA: 83873679288.21.BD71D89
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id B994510001D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:11:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=f2VGsc2R
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757517083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BXoqASXxVm6qrPMR1jlKsH7rPKgmk0nk6UORN+Fz8Tg=;
	b=cedcXXvsXGzZeuPsoOac/porN9u0FNiFAFFhm8TgYX+wUeD4GsWKSUsnE+v7uBHP377WXX
	gK/TcvLj1iJ2zk5QX9IjNfA1OFETvU04CqqPk9M83ekEiM1Z2Nj4KRveHRv5pVyjH4GmeD
	LAkyXPgeayKblrYk8Fy833GkH43q+GQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=f2VGsc2R;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757517083; a=rsa-sha256;
	cv=none;
	b=iJIFsCDjKuYv79c2dS94k4ENpsmXsAcou+awIRvNV2fgPV90cLvy8dvG+50A+VjHjeaM8a
	OAI2FQSFAcXlP6GNTaOaiu9m1mPiPFc9ruY7s6plYzDJuBDHYijyVGLGVpe7p6V3loPEWY
	5nR76L3wh7cDIZotzVApmxV8OOr88FM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=BXoqASXxVm6qrPMR1jlKsH7rPKgmk0nk6UORN+Fz8Tg=; b=f2VGsc2RSzMKk7BnYh19QnQk+L
	b1a/8weBhoa3C3d6mgqGgvK+dGMlx0W1R+FmhcwFAdEWJ+naXP4VzZpSJ4j+/k0dhqHs9Ae5v/eAC
	rSSbSYSSsMDBqODfswg+QscO+SpoN/0ARs9E6cZUzX0PP0uyDHVE+pGzL+10iSDHkL6x+h2B41VBD
	IzPedborjB228vS1HramU68IWlPXEpgR5j71tzhqvv7WR51rXewoUCBN5Vt9Q7bxHx86lBWNIGzVP
	7ltNPrnEMBFmqktv1/Ub3rasftus4HYEKNKOWDj62+8nWT1jpxyOM2Pf+RspwnHDYg5gWDHkcub3y
	rGWr6ZXA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPp-00000008MEh-0XTm;
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
Subject: [PATCH v2 04/22] slab: Remove dead code in free_consistency_checks()
Date: Wed, 10 Sep 2025 12:54:46 +0100
Message-ID: <20250910115507.1991829-5-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B994510001D
X-Stat-Signature: ts64jsy38yz6q4y6t3csx3jtg9p7z5ge
X-HE-Tag: 1757517082-608151
X-HE-Meta: U2FsdGVkX19sOoHtonuCTZNn0D4fZZHx70sdXjB0pGo/+gqNVgT4Ebh9pWn+s3hGbtyKuLY/lYPoZKDj2UyLvRf3GlpLM/ONIRmlgEcPOCyhWADOQtmGP/1oiRVJge/5lfklDanIlmwH+RDRonNaE9bsCosko141iIwULuHnPGED1+5aQSobHWk3HM1rd4QoihdiNgCxiUMFCT4iZRDkKuOraBCov5KV14XhVepc6m1AkvzJ7gD1c51h8ofrDWSmTATiF7K+F96VL7zrlHHoZAkvrbYWHpgV2J/dg7UBwwMgAb2T1WezAWdpCcEc0Gl/HzIRP3FQdN78pcw69PHPvQDWSI+g0T4CF96n3yzicouFFNyseOGdWKPQ76uTSuhXiPVosoiDLOdbdAU6lU+VEUuenz7vYDinRfKOH3TU4yO7YVGc2IvCmgZgmN/H6B5KiEGffAUKPf539bYflMdjeaNefFjo6CwchnopPG7MA4AnFhra2hYBib7EYMyzDgTJNLmnCu+nDbjnuApk63Vm49wb0sa29OR9hMkjyRSM43/wrGLFlKlqAtlkPa2n8Okl4h2gkKlhjT92CQcLHbG9xQ7D9D4SiIpCJuun1/6ttOatEUWiSRk0+k6H9aygjSai2ydO9NJcKSGMOBAhvAq3Upsf2tKm/yJPRohS+cqI7u7Nn0nN+8CVTi3wFRy/JcTdYu2eoMQdMJElaW3PIQkjm/11nALIlnl/0SFM3+nmAu8s5+n7yxlVQINjtlQ9s+6jDV0ZKzlh6ndJ+DRcaUVpvSyx5TZeq6+oJyiHFCLCN33CZvcTHGWeBaWUi1Mst2OLtpuTJ5RenhLuVjLqBYTfg0De247+5S9+XEzFLqB+xIYM4ndzx+xLS//vEdWRgZNpKmrG6LxIfKeu66hpZ4vIqR36vD/B+8ew5eRPKgcL9BKndx+fs9ft7tDozyUGFqiaUY+1o4LlUPbZWjxnxx+
 vQ9kgmA/
 TaAu3IUTQKeGJQ1hOcvFym7pMPAQgqND4rjpr/BBEaMqvSlWRlGiOYu419n2ABS/O0FHOtp7j57WtJwmWkPWdWFDEY2qgrtBxBjkFFlCn1qAfHonn80gPvmTNJGyII9NKlQacDgr+Rx/2YtQFZVu6U1dRFRH8WhpolZm/m46gd3VLJ2c8XrsN5rNhIxynYPUQmmw8Y0jakJaLbYtDVmfJa1PinmdiF0IHzGMZo19VUDN4vVZpeXiKeK3dTlSyeUwsByF/nxLK5MnlkbbtA04DYTyb+odcTSuN03sDqKHmB5B21/4pRtbw376QSe29Owrpw/TrGG6CRci/UAmavQWRBR3rZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We already know that slab is a valid slab as that's checked by the
caller.  In the future, we won't be able to get to a slab pointer
from a non-slab page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index ac879e9127a2..b32bffdd6e3c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1739,10 +1739,7 @@ static inline int free_consistency_checks(struct kmem_cache *s,
 		return 0;
 
 	if (unlikely(s != slab->slab_cache)) {
-		if (!folio_test_slab(slab_folio(slab))) {
-			slab_err(s, slab, "Attempt to free object(0x%p) outside of slab",
-				 object);
-		} else if (!slab->slab_cache) {
+		if (!slab->slab_cache) {
 			slab_err(NULL, slab, "No slab cache for object 0x%p",
 				 object);
 		} else {
-- 
2.47.2


