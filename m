Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC4ED109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 05:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03B0D6B03E6; Fri, 20 Mar 2026 01:06:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2E6E6B03E8; Fri, 20 Mar 2026 01:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6B8F6B03E9; Fri, 20 Mar 2026 01:06:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D69F36B03E6
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 01:06:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A63FF13BB35
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:06:42 +0000 (UTC)
X-FDA: 84565256244.03.36D0BEA
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf04.hostedemail.com (Postfix) with ESMTP id D4CF14000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:06:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773983201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=5LRTFCu/diTvFFLxQyTKIcBhi5N9WxHPTtvambKN+v4=;
	b=Gl1h8pgFol8K9l+rfxDDkV1K2St8aFT73M/uUC3HAczpfLbcOeTidGlAT0Olxn8l1Da5ua
	VLHxVEctpiqBAnwVuuN1r03ayJVeNKhbnrmasLzinDHmBsfMzajaYb1ECxjaq97y6sp4bb
	9ZgrkAhGpXViU8NkW9SItclsQhO/Qfs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773983201; a=rsa-sha256;
	cv=none;
	b=sSpkMrWeJCNdNIPlsGZgK9A8MDrMELhxQ6qj/9fDzpPLBKVPjsuAeWSOSUE3yyiLhyP8+H
	RuS+L2oiyxDbSta5xI+DbVVHbQbczbpT4VAF28C657T+uNDB0wU6QOkGAhlhVCIhi4ZYI8
	J4l5uWk2yWiPfEO7UIOh2yOh39kgQ1Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id DCD0E3E9B3;
	Fri, 20 Mar 2026 05:06:36 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	hannes@cmpxchg.org,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH] mm/swap: fix swap cache memcg accounting
Date: Fri, 20 Mar 2026 06:05:59 +0100
Message-ID: <20260320050601.1833108-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdeltdduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeetlhgvgigrnhgurhgvucfihhhithhiuceorghlvgigsehghhhithhirdhfrheqnecuggftrfgrthhtvghrnhepfeffffdvveefjeeuhedvieekkeefhfejhefgkeejffdukeeigfekudehleehkeefnecukfhppedvtddtudemkeeiudemfeefkedvmegvfheltdemkeefuddumeeiugduudemsgdtgeejmeeghegttgenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedvtddtudemkeeiudemfeefkedvmegvfheltdemkeefuddumeeiugduudemsgdtgeejmeeghegttgdphhgvlhhopegrlhgvgihghhhithhiqdhfvgguohhrrgdqrffhgefokeeivdfrrdhlrghnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpqhhiugepffevffdtgfefgfelueefpdhmohguvgepshhmthhpohhuthdpnhgspghrtghpthhtohepuddvpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegthhhrihhslheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgrshhonhhgs
 ehtvghnt
 ggvnhhtrdgtohhmpdhrtghpthhtohepshhhihhkvghmvghngheshhhurgifvghitghlohhuugdrtghomhdprhgtphhtthhopehnphhhrghmtghssehgmhgrihhlrdgtohhmpdhrtghpthhtohepsghhvgesrhgvughhrghtrdgtohhm
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D4CF14000B
X-Stat-Signature: mrzpk1qdrosd516oa1grkxa5hxp86e7u
X-Rspam-User: 
X-HE-Tag: 1773983200-483675
X-HE-Meta: U2FsdGVkX183lwp4zAXx7vQ9DSBMpXAKcpTgK1NfepUll7KZvdAsLAyDFWyuq941yel8QMFNC2h3KqRxToEYPAHx3FowFjkXySGg6JtUoXp/WnFx3Q1V2EXgs9AW34xookyWYbxjkV2+XiI3wb9vBTwZwr/1E+3rf5wTP5mjB4Lt6IQTceFT9VAUxoBWmdil08i2TG/WaDnr81csHaeTdxxdUQSkDURnUsYnAbrn4l0pxoPQ9Hq3DVj0k0ST30I+3RaNO0niyne4CL07F+c5ixbRT9A4FdcGThw6gE6oE+RKR1xw6BFu9up0CyRZc3L9Yw8Nz3sgd5bPJLtJ+IQvuNMyp/3iBSmF4Mk3dwvkxazgYmqhuJtiPHBpEQKavAq0seRcrE0LxhWOCIIDj5LJsvk38CJiXWznQTwhtH/8TiIorDdDbxD/1sZNRoliroMeO9DjzlSIbA4eBQ6KbPPgShBiP9jxx5jA8Fcs3ZTeCfbffZL+358SuuyZTs6Llh4Vq0JfYsrqh1eK6f3VUA6s2JliGA++u8q5SdMjCKEdDdNVJ7YjUI09Vc07Q0VkBlVU1r35eLJ6OTW8EgrsjezYS0WKd4wjgPBZCLSuQNq+zGFlXhIIlj+GtoWpOHvCICzzL7XuTuK3Ha4qU86iaiSXD5feHNRyA3vb6LXTHR4xbkMhu934OIW7ChtCjrhLLB2t76noWs4b6Wm5kvAGGE2gFHhDKiJh77OjXh+5Xi5rr7RTHBd/OhOv/515QmBjpOW3/TPyDZ/w7Q0isjICQiid8JSaW3YTmsziCI0gRF0E++Fmc4VWPUa9BLw5fHxc4g5Udt97W9VP7LgfDpoW/eC+DsRI+xLTmI5uS89nWCmjGfyr6HpS9I3w2HtRd45UnoANE4AM/dr3F/LqxQq6IgMsGOIKbwoDrSeHXeaYkTIf9EFLFUHhQo+BXLh1gSqnKkmXwUSWX3N4J9vRgXpMi0p
 ASrRXYmx
 GMcRG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The swap readahead path was recently refactored and while doing this,
the order between the charging of the folio in the memcg and the addition
of the folio in the swap cache was inverted.

Since the accounting of the folio is done while adding the folio to the
swap cache and the folio is not charged in the memcg yet, the accounting
is then done at the node level, which is wrong.

Fix this by charging the folio in the memcg before adding it to the swap cache.

Fixes: 2732acda82c9 ("mm, swap: use swap cache as the swap in synchronize layer")
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swap_state.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 6d0eef7470be..48aff2c917c0 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -494,6 +494,10 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
+
+	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry))
+		goto failed;
+
 	for (;;) {
 		ret = swap_cache_add_folio(folio, entry, &shadow);
 		if (!ret)
@@ -514,11 +518,6 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 			goto failed;
 	}
 
-	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry)) {
-		swap_cache_del_folio(folio);
-		goto failed;
-	}
-
 	memcg1_swapin(entry, folio_nr_pages(folio));
 	if (shadow)
 		workingset_refault(folio, shadow);
-- 
2.53.0


