Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B808DC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879426B00E4; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829526B00E8; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A31F6B00E4; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F71C6B00E5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A853F168B4E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:25 +0000 (UTC)
X-FDA: 84958559490.28.600613D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1E7274000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IGEvX9ld;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWM9ulbAfG9bosKr1Xo0BbZMoQtsvPUcnEqaGbAY52s=;
	b=iAzadEnIr4wG/Y+QuMFmC59Pt8iUTTl6UkkKplXY56B5ptM0aha8aonV9M5e+SDy/B3CRg
	qQdMgJQtCsJ0Ralj6bqZ0NdWuaHE+iPoB3akywqcGA79WLEmAw/oJ+awXUNxqq1QHg+qkZ
	Td2md+SrRkqWj22LRAqfRVa+ekRAWzg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347564;
	b=thbfUVI5P1/6GbpNSFyP7x16bKkBt412vUn/MLxbROwh/B8hAT/v9QkSBB5mh/7V9NB9Hg
	LFmbOq+f3ZI+swmgokuCmqmMfSTxvDA4mv1Wzmsjfx9HsEeezQbz0o/NkrHg17UY4ioKTQ
	9G5QyYzAZsU8oAYUaiRb78orADsTUNM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IGEvX9ld;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B2A8561389;
	Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371BE1F00A3F;
	Mon,  6 Jul 2026 14:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347562;
	bh=HWM9ulbAfG9bosKr1Xo0BbZMoQtsvPUcnEqaGbAY52s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGEvX9ldaMMuYssG9Up8AFd3AOZseOjwO7bbkT9gJrWDd0K71El2q+i9XP8jLCJO3
	 XLwByoBp+S3VlZc5+quQauusWRX41PLzYKj4e1PSiaaK39TQ5bQkI3vHUM7F06AkFr
	 frW8vGtNxnq3Tpg/oVK1jRpROD9YWVcUXtG80wbWk74WQ9bGham0AeKIpVGBWbVdDX
	 i238eYqva+YsYQIaj2CCv2xqEY3r7AhYqPTXp5iZUnm/BNLsTZbSfJJZq1zFIA4IRE
	 qzHrZCbOW3mQqKyaTNVyzWil+wesGzzLPCcDY9jOHGsTlY5jYhyan2MeDW45pl8166
	 1xNlsc3nbtk2g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 06/16] mm/damon/paddr: respect return_max_wsum
Date: Mon,  6 Jul 2026 07:19:00 -0700
Message-ID: <20260706141912.88445-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1E7274000B
X-Stat-Signature: 1fnkrbe3bnmgz33j7qnxrjwn1oiouwur
X-HE-Tag: 1783347563-111231
X-HE-Meta: U2FsdGVkX1+raIDg4OBx4QET4GNTQcJm2jQyHEUCcZkWfTm24C69GSUuJFq4flBEWeqnuB+PpdwGPdNGmuDpq1b349bY17eWxbu7yDNpdBvzjhCqp0XxxlCI9dU440e75DQLiqHmgwt5kedLG+dFFKa6c+//2oMofWKY02bVTNXT5jWoy5pkabdsrp63Q6ee365RB3llysMBv3hnw3LQivlSiXdPu6ipsSZWQHj7OclK9ad8mCHSd7O/o43h6myY6gaRwKPQuHtUz9xfi+Z8dUwM8lAEvxB1Qqu8biDljmRmgsE0kl2MT+t5AE7XkedOtN0mHLxWLyNvS9J7s/8NPaX3wOVKGK4U8U/nfRXEVCHzG8EXScK9B6v+nBo/NrH6PRY5bTSRsYtkN8whfMiTFfDotnteYtmjamjx099lrBgJjjc5qc/o5mXOd2TO3Ys770qYFiWkH7ms5wdctdgH5u/MH+IqzWM7DCwGBgjhncdFWH9a6GV31gC/wPKv3rVuX/rhV46Y4yjhzI7pxW4o9FbXvjQhv7OTyggCWfCHufhcoq+Dx6IrcvxszhW4C/CRGjIKUR5lJdwiWYTuGI0pEvrISKrrqE20RI3g94Ba4MT7vUoVzjaHG8sYQINAGECTjln1ySSO++bPOHu03MCUzd8WD1bdKTCf1bA+XLvjHDHNwzdf+Uqlpz1Lj4CZizFl8gRiaC8j3MX/PZ9t32HkDX/VayLmIEcs1pc2cQynipuxolc+Y05hRpyWn3cxuV1uBrNoK/zhqrGVfg6IXT1stIau+d5VEB0/YFtDYQu7mxtk6MChl9pNpbOb8NbY6Cmjo2RLTtyTVtpzzZ2BAIAXJsUCthDbvr/ItnwznH9klofZFdc/A42dZHwhccVvBOchpHWgQHyHNCqdfxF0mHcxVZgFvv5BtD9UnSQtr4QY0E791T106fKJHMWqmTyUV9Z9q5ka1bduXw86ebh06qP
 N3CqYT46
 /jO+cDJ5G3802ThkHMBfdldMmL1UOF2cyNWf5FbPoiaQ/vDhCW4wxi5QHgj1oU6rRf39eL1Ke3u3z6PyGVi9/8KJalhEfrOGvOMgepFSV5MswbZextu5vHKxEEbFHoYyYwobiH5ustHZyxeP6cD2laXBF6C8IRN+GLvLWfxfW+qhcpTXfX6jKO3YgFWTGTdZ0KC66e32F3CUw0iOh/uByzpU343RdUzjxT/S9bASJLV572+SXW3zhodvCc8gjcjHSgTk1HpD2dTRXk19sacHxSSuGgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_probes() ops implementation in DAMON_PADDR is ignoring
return_max_wsum.  Respect it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 3eba3564a31fc..b85f88a7a38f4 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -172,6 +172,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 	struct damon_target *t;
 	struct damon_region *r;
 	struct damon_probe *p;
+	unsigned int max_wsum = 0;
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t) {
@@ -182,7 +183,6 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 			if (set_samples)
 				r->sampling_addr = damon_rand(ctx, r->ar.start,
 						r->ar.end);
-
 			pa = damon_pa_phys_addr(r->sampling_addr,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
@@ -193,9 +193,12 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 			}
 			if (folio)
 				folio_put(folio);
+			if (return_max_wsum)
+				max_wsum = max(damon_probe_hits_wsum(r, false,
+							ctx), max_wsum);
 		}
 	}
-	return 0;
+	return max_wsum;
 }
 
 /*
-- 
2.47.3

