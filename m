Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE563C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 16:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37286B007B; Sat, 18 Jul 2026 12:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0FF46B0088; Sat, 18 Jul 2026 12:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E284D6B008A; Sat, 18 Jul 2026 12:37:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B17076B007B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 12:37:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D2B7160414
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 16:37:21 +0000 (UTC)
X-FDA: 85002452682.27.6B0D591
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9471340009
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 16:37:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=otAS01m9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784392639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/NLv8lWlFLX8POfC/o9e/GmzCTrY3L3nsFmzwSxFA30=;
	b=olTlQRAOa5MeeWvtdeCUuOouUYBtgNdq0XyaCsIv5ZRL/ta8JVRO81BZ6MBhb/qU478IgY
	7LhbQSsfU3lMTCJmWnwSlxKhBgZyyvxA3NU2GNuURGlXcBDm+M2Cdq3UaCfDIh8VLVlHoV
	WIcluiTYs60xQo0qdgDhxE11o4kEw1g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=otAS01m9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784392639;
	b=7IYlhc89ml+tT9W4xg8kL+PvIrjingzOHetzZDEIYdjj8IROfzFW6qGDUjuk3/aN9i3bre
	TDlt6AmVXsnx2zXxSCO2OcCrSDugzXuZodOdD2SLBEArgAUACCfKT9B9ddiV92kpwbFv5G
	YD/D8SZzV444Gp+0MhI23jnQYAPGtrk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E8A5060018;
	Sat, 18 Jul 2026 16:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3EC1F000E9;
	Sat, 18 Jul 2026 16:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784392638;
	bh=/NLv8lWlFLX8POfC/o9e/GmzCTrY3L3nsFmzwSxFA30=;
	h=From:To:Cc:Subject:Date;
	b=otAS01m9vVCzKAR6avi1M0LBz981e1I6CmxlFLclXf4D4yubOkFbJx2uk+H41ThxG
	 ixiDFjMqhCKY3hNGMsOapGPFQqJzotsJEZzwCXR17J7HAFdTqdpySxmapZZBpnKfH5
	 r8KtGH1fW/aN1rTzfH1JpNUXaIpoyGskUVABSvS6owPGRFyX1y3427OXninuv413nv
	 +8xpHGOiPP7ZIpHthx4Zys9A9MQewzdPs05kCa7gE7hwYV8n1pf0DShO3fz45+3pxQ
	 8NvX0rDZh7Z7Fx3qHlsp7kl2wn7LiOIZAY9vzQOoPeLFZBg3y4Ltl0qglXhezDrpLN
	 ZozlD+WMIwUIA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: handle region split failure in apply_min_nr_regions()
Date: Sat, 18 Jul 2026 09:37:06 -0700
Message-ID: <20260718163708.84113-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9471340009
X-Stat-Signature: 4jgx5utcshr859q58b8g4o5y9e4xhtqr
X-Rspam-User: 
X-HE-Tag: 1784392639-901712
X-HE-Meta: U2FsdGVkX19OKSIxoTBH9WwkUWuVYyX1X9Lqc5X9lTOaY6OijQkzl4nrHqgsJm7odxe4EFmCWkoD+oT0AINPvXeQhmv3fiWWZXWAnuKZBW94+aOVkFcF+lqsCJMubDUSnFFKngipi2txnf6h3ycdNDoQ6Sjxad/extsIfr5UKWgBPQtYkp4IbQhb9UNj3XI09Jvi0VLpAxAGzGNeOKE1wl8EY6d/PpRu5qbPN1A0QwzOIAfRqzqOeT1xcbjX0WEvqB/TYMPYFfwwNBSVNSkwCrreUUPLmIXybxvFwnAZRF1207f17eC9OFNl28tjVX4Bnaj1k0xzCFxDsMMZ9gpmEDb/TWWJDnDx/TJhYp23FDYQ/PZzs9V+SG8JlHT7bI+NYG4ByMofmhvJGhlxA8HWuq6tgBEvH0WAdUSmSdsNLmDk4GR8kLd5V8XFIiuXU3qCJ47q6P5iMwm9LiXKknW2zBtdCBAeXIrz2Bij3+9LBERncrWhDZmBx8is3iEIR8LU3RDlBJxUTp/LhjJh7KfSAzfTm8baSU7Nj5t5MUoH0CFx/0g9GN34hfQXVx/d0TD7/dXw63V3d2ZxE3v0HhHbWROgGDQj355wDVPlTBXrhFIYx/tcj86de8TmFXftTJhTo5RCeTIPndTQEg9UFycr1NDvR2AGshSKe3n9PhZF5kDY1/n8wyZmsjfCd3ZOKiRUbG7+lOXdeQgryPB6//KzlO3x4DJaTeK7/4ARcIV46GkPBs0Flh9q2vPwwQfOZD8WGCdCDqentyV4RwKyXzHKTpjwiy5Qoc/FxRw58ICWSlbAoiDZ1CHnZeGVuIr3C4WWr4Td9CyYoZ0SrHl32Ov8dZCBIyYCQPgrKIgNigSwDtjf+bW2Eq6m0OAB+4aXF3oL8Hssa6lNewzHkr+TST1LwU0g1cjzwwhF8f/dIlhG1EPBf6uzXIBSP7sSTXeBESgEe31+bVi52AZJqtiJeeu
 KPG14GJG
 mdUMQWhZB2D3s7dJF/+X1/q2FAEiJkCcwebqK6ZNXoKgQYVUm25u/eMYQKoUS7/rh6A+0VTH6FZyBKjPIP0o0AIgIqp2kh2Kf9md9ShK3Bt1nN3Av0rE/Ky+PAo9wKkzidf6aZm8NKCX/LDJ6RTEV/pD5NoQzxfWWPcJlHSGLczpIGoX5GX0h+7mY0JvglbgDrhJ1X57mLfsW9nZ0lZVmX+CNzyjFKE7XoSfWiC8BxyuSBNPz26HeuS+LEixaGfDxnOREpPE3CgeNNkCRX52sdnkhnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_apply_min_nr_regions() repeatedly split each region until its size
becomes small enough to meet the user-defined low limit of the number of
regions.  The loop assumes the split operation (damon_split_region_at())
will always succeed and create the new region.  But the operation could
silently fail for memory allocation failures, for example.  If such
failure happens and the region was the last region, the linked
list-based next region fetching returns invalid pointer.  As a result,
invalid memory dereference and corruption could happen.  Fix by breaking
the loop in the corner case.

The allocation failure is unlikely since it is arguably too small to
fail.  But, it could still theoretically happen, and the consequence is
very bad.

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260717011834.120715-1-sj@kernel.org

Fixes: b1029f29eb1d ("mm/damon/core: split regions for min_nr_regions")
Cc: <stable@vger.kernel.org> # 7.1.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260718004301.88883-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.

 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 20d267c615faf..3d829e0ad63b5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1913,6 +1913,9 @@ static unsigned long damon_apply_min_nr_regions(struct damon_ctx *ctx)
 		damon_for_each_region_safe(r, next, t) {
 			while (damon_sz_region(r) > max_region_sz) {
 				damon_split_region_at(t, r, max_region_sz);
+				/* split might failed */
+				if (r == damon_last_region(t))
+					break;
 				r = damon_next_region(r);
 			}
 		}

base-commit: 5817557f6220462f0ca298b73e4b3f4bb91ccd1f
-- 
2.47.3

