Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7753AC44500
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFB956B0125; Mon, 29 Jun 2026 10:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB23E6B0127; Mon, 29 Jun 2026 10:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973646B0128; Mon, 29 Jun 2026 10:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F53F6B0125
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:56:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF0F240179
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:56:41 +0000 (UTC)
X-FDA: 84933251802.05.8BB84BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 02C6140005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:56:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJRDV1f4;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782745000;
	b=hZLr3UfjmT+DiZ+VO/S/mzCP7KhnXAhMyterObuEmTZSnNKYu8iRf9XFh2gzFdTKvAvXs8
	APi9YcD44rOlOGaJmyY/XlpAi7BQ/5NtCcPUDjODfLHo4x6U/FLoPYS6u+vViWYLQk8WVu
	4svVGx39P9q3kNQurMOPgVXUUWiYbGw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NatPVMmr6lCmbwrlx8nymHKQLSth5j//NGxvrJ4IneU=;
	b=mWC2wBhhn11uhEoxUYbuUEtR+pSnFKT8p4EivdGxI3ADRzugqZ/dtS4ozRQ1G4AV7ptB9u
	gCl8JdCV7vKFP/ngkcoQpBaUlL6oB5Ghp0VIDC2hyk4Wvtu0eET6j+zN8vlAAUzqLRgVr9
	CzMAwS7ESNXsLbrfQY4q3O1TTP0VZnM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJRDV1f4;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 836F26001D;
	Mon, 29 Jun 2026 14:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75A61F00AC4;
	Mon, 29 Jun 2026 14:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744999;
	bh=NatPVMmr6lCmbwrlx8nymHKQLSth5j//NGxvrJ4IneU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJRDV1f4my+izevuENYAHKkEumYnZ2U6dtePGJAVwunGLNbZNgrq3imspiQVL6zOw
	 5iV4NRR8ojJUinocwL/VoKfkP9WaqOsroCXEgq6nCNZdkmq3h9lC8/G/6XebN3SHOx
	 eieNMwPMJtATCYbQcn1xrSRqCv3nzrkFoqST+lATlEFCi+C6qCDQkxVQxCaoaJL2Fy
	 03vqCdsqh7tJMDsy79Ee0lWkdBzOQsKgiZ5AtZNq8a9ndiQcE4UxBLpb+4bBAwxiw4
	 rp9ktpeSBiFbmeK1FpPPZ77C0LpwFk1N0cIq+bUt7fVBNZ+GkAlDC4EmneVtg55ZXR
	 IALxxuDZEIquA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	SJ Park <sj@kernel.org>,
	Shu Anzai <shu17az@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/2] mm/damon/core: split a fraction of regions when nr_regions exceeds max/2
Date: Mon, 29 Jun 2026 07:56:28 -0700
Message-ID: <20260629145630.134891-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629145630.134891-1-sj@kernel.org>
References: <20260629145630.134891-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 02C6140005
X-Stat-Signature: 6emyss38tuyg3dfprai1oee7hn3cphqc
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782744999-585009
X-HE-Meta: U2FsdGVkX1+DZHVBMmnwILqvy9kzmNq5+WzEH9w7r9heOzWGGAxoGkMUJWZclGe60i+KEf5RdAn30wJugm+hpF25jYzSiaEERWQ9Zk7MnTeCyZnHO6nbRqi7TGoSgnVHPAdlQB2OfPMbKW0CPLgwDrIN+qOyvQOuGqzxIY0XJVvxyTgpzQP1i1O5ZKOngglJF5u4toePeSvITMr/kbB/YBuaCtD/i518TtTGfiL1bIgHkhklIZjsrlkjVlRB7F8gP22XAJBL7fhEQjXd8GgsB9ECbF+0mSCvldpRTrUes642hmlACWN/RJssVEyk2j7nJGDdlLwrqDYcA2IDyElYjFjp9sAQUqxULYFZa4Vw+0sGbhfarziZb52UGsAJtnpidUgDtkOENCSHJFA2Z4ofWifTnBBkH+uL50yPT5jagaZCs+r+PlumZM0+36cpSBumrjZi63HdwZUK2h/w3uXWh2tnT2B1w99GKFfGKSyFkO68J2PXIkfMC2LiYwXHBN7Bbv4p9CUMJrDgMKiOw/5rB/sH11x66FLvh/cIJ8i7e31l1gw4jUWIk/2TgQPdUdiGyLe9i/NIr3Vp79Bhw1GtIqrMrEXRGrfLTAc5Shjv6+/Dix2d8e19mkik794LMDtfhh7uDUVzANeVCrDnHYAjuy/2pIyAHsaUlewdjXWc2KLx/qyiWOZbo7U/jsbRnmF+JDai94wT/NW77fnAtYSgNL0ulvqynC6vmrDE/cWznaX4BXvoIJl/wrvxNx9JEOWlfFfyvfKOLFrvqlBPLlVzSpW/wz3KPdBS9yEUP9U1+nbrSIdtnHG8TTxuMUdDrumHaMo56Orki2XM/KT5HRY7Cy05Svn/krQIPnnuOSnRAVt+yjJsP7gRcQZqWsJrZ4PafqBCe/W+bV0VVNTqDSyneeA+bsMGsMmxOq2m7s6al69BHTD5B7J0KGvCHlRvC6+ixhXl1/L5HuiHszWYJKP
 A+ethg5D
 XHPEx85zqTCPov6k8nQddbOQu109ksQZMd6NRnb0nyNJIbiMyZ+esO9+BiS955F/zMJHv0cuFbBQYFlnKB7blq1FrUH56lGDIQIUsNA+WoUCYfCayfbnKbe/vLlrx6N8T5hVXLsfza3AEBc7qz+Iv4QuR/RWIz7/UMnPE0sr5rc6sUMoItyDSsNpvd73WFzhgZrD+1tyxohwbjxs+2ahcwpmPl/NE+xGVCA4vi89XAYPFPFWFzNBdKNobxixxYUAMs++VrbTPZ2RtJ5gX+dBqDGbfWuK02XoVnIaHxfYjVmxNlkkRdX0djQxs80RI/LSw2a8lX5VokHt81y0Dqu7CwpkaQ76c3hTYdQ5wBXaP1OD4a5z3CDb2tmQZwtzqu2AIF5mjLLvBgpnpHflDqH5bekhXDqK2nwnkhr/3Qrwl7sBrQmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

kdamond_split_regions() returns early when nr_regions is above
max_nr_regions / 2, leaving internal access variation inside a large
region undetected.

Such a layout is common with damon-paddr on hugepage workloads or
damon-vaddr on processes with a large anonymous mmap.

For example, with max_nr_regions == 1500, a target may end up with
799 small alternating-temperature regions plus one large region that
absorbed a uniformly-accessed range during an earlier merge:

H:hot
C:cold

      r1     r2     r3                 r800
    HHHHHH|CCCCCC|HHHHHH|...|HHHHHH..........................|

    nr_regions = 800  >  max_nr_regions / 2 = 750

If a cold subarea later emerges inside r800:

      r1     r2     r3                 r800
    HHHHHH|CCCCCC|HHHHHH|...|HHHHHH........CCCCCC.............|

The small regions cannot merge with each other (different access
counts), so the budget stays full.  r800 cannot be split because
nr_regions > max_nr_regions / 2 causes an early return.  The cold
subarea is never discovered.

When nr_regions is above max_nr_regions / 2 but still under the
maximum, split only a fraction of the regions instead of returning.
One region in every 'max_nr_regions / budget' regions is split, where
budget is the remaining room (max_nr_regions - nr_regions), starting
from a rotating offset so different regions get picked over time.  The
fraction shrinks as the budget shrinks, so the region count keeps
refining while approaching max_nr_regions smoothly rather than
overshooting it.  An unnecessary split is reverted by the next
kdamond_merge_regions().

Link: https://lore.kernel.org/20260626085851.70754-2-jiayuan.chen@linux.dev
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shu Anzai <shu17az@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 49 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ded76719e8a14..972a19fcee3ec 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3240,6 +3240,37 @@ static void damon_split_regions_of(struct damon_ctx *ctx,
 	}
 }
 
+/* Split one in every @split_step regions into two, from a rotating offset */
+static void damon_split_some_regions(struct damon_ctx *ctx,
+				     unsigned long split_step)
+{
+	static unsigned long rotation;
+	struct damon_target *t;
+	struct damon_region *r, *next;
+	unsigned long offset = rotation++ % split_step;
+	unsigned long idx = 0;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region_safe(r, next, t) {
+			unsigned long sz_region, sz_sub;
+
+			if (idx++ % split_step != offset)
+				continue;
+			sz_region = damon_sz_region(r);
+			if (sz_region < 2 * ctx->min_region_sz)
+				continue;
+
+			sz_sub = ALIGN_DOWN(damon_rand(ctx, 1, 10) *
+					sz_region / 10, ctx->min_region_sz);
+			/* Do not allow blank region */
+			if (sz_sub == 0 || sz_sub >= sz_region)
+				continue;
+
+			damon_split_region_at(t, r, sz_sub);
+		}
+	}
+}
+
 /*
  * Split every target region into randomly-sized small regions
  *
@@ -3253,25 +3284,33 @@ static void damon_split_regions_of(struct damon_ctx *ctx,
 static void kdamond_split_regions(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
-	unsigned int nr_regions = 0;
-	static unsigned int last_nr_regions;
+	unsigned long nr_regions = 0;
+	unsigned long max_nr_regions = ctx->attrs.max_nr_regions;
+	static unsigned long last_nr_regions;
 	int nr_subregions = 2;
 
 	damon_for_each_target(t, ctx)
 		nr_regions += damon_nr_regions(t);
 
-	if (nr_regions > ctx->attrs.max_nr_regions / 2)
-		return;
+	if (nr_regions >= max_nr_regions)
+		goto done;
+
+	if (nr_regions > max_nr_regions / 2) {
+		damon_split_some_regions(ctx,
+			max_nr_regions / (max_nr_regions - nr_regions));
+		goto done;
+	}
 
 	/* Maybe the middle of the region has different access frequency */
 	if (last_nr_regions == nr_regions &&
-			nr_regions < ctx->attrs.max_nr_regions / 3)
+			nr_regions < max_nr_regions / 3)
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
 		damon_split_regions_of(ctx, t, nr_subregions,
 				       ctx->min_region_sz);
 
+done:
 	last_nr_regions = nr_regions;
 }
 
-- 
2.47.3

