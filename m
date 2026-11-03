Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD580606A331
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U51x1HrB
Received: by kanga.kvack.org (Postfix)
	id DC8B56B05D0; Tue,  3 Nov 2026 11:25:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4DD6B05D1; Tue,  3 Nov 2026 11:25:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3E26B05D1; Tue,  3 Nov 2026 11:25:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94EEE6B05CF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:25:52 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A26E1C342B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:52 +0000 (UTC)
X-FDA: 85394334144.12.6C4E12F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id EAAE0100006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U51x1HrB;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723150;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YhFPGq66AAtaFmboYz1uYaKBpqYr/PH8XApnUGdT9oo=;
	b=i8hvHJlQ/s3QpZ2GA/n1J1XQXUZAa5btKxCDX3KPCCr9Z9AwC31nxdFZCbYmreJ6c8koAe
	ocfVyHj6gXspfQd7WsNKreXDOUY/QefM7oSbmQvw8gTvOtKDjp/UNE9IFyd4WimvEANI1d
	m9AVIcoQqUjmKHyAR1Vv+3C+tpT3rr0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793723150;
	b=xVeSxJj1ApSXDfoh316qrOHxvrcWNLWyTumpj8JO45RVtAJC7Y2n0hAHh3rggfYeNyjf2h
	Nb5f3FCpo76ok7eHVVK2zUz2/2cIrVKWwtQzYmq0KKTOl6ONI3SQwkVaXDmGjZQcEUGJRe
	ppr7o1fldVoUWYxVPBu/QneozsTxPzA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U51x1HrB;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DB95400C8;
	Tue,  3 Nov 2026 16:25:49 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793723149;
	b=o/T50ihoqdq46aEHWLu4U44W9dvkikdXUWeHHfjBpNLtzXCZ6PXPU5Hn3B5CKuZLuZXd
	 eq9TqfbYEHEllj1xjhx4BZ2J2lnEiIZE/98gsSYxLMSLxudA3MRxZ3ISHCrD28ri56Xw0
	 okW+aDxx5C5EsJv2N3Ne0n72saPVnOFiuH03zxKQ9WqkwlKUjpJN+SCPCUroxDfuloHCH
	 VcLl51VohmGcQjEmAQMzjmHLM9SXM/6w8XN9CBVpTPXpq32gbR7RtCGKTX0D8ZGezuUHE
	 Y9cE1Z4OsiXwa7ygpQB+EIsZIViqKb+QNEgmslreETHNJFt0TJ4iS/ojd9tP+dSC0mw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793723149;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=YhFPGq66AAtaFmboYz1uYaKBpqYr/PH8XApnUGdT9oo=;
	b=SR00+1i4LcnTkCFR5NR13u5g5uC5/EE7sAPd0dKtjZ0Dbibge2FYeggCuRbBg39Y5Xev
	 EHo2S/TbhYi2y3d/ePEnhCDRzsKGRnSPeuaax0W1c886RCsMPoUZ7PuqHF9yTeXK83msk
	 j2T9hjveUnHh6p2nvuvQcVQ7VdSleaGvy6qs8Ow9TuByR+y5heJHKO60OabOFaW/FSr3X
	 4ke/UhE+19RQmmlM/3thFtVPZ7ZXNQpP8A2Sho3Yt43W/fgobUTvnzlvRrdjNin8i+a4c
	 kI2uMl1bFEkSXKvCIab10hvZTc9QiEy8It2J5LNWJ5nCszpqOWAmWipIIfYo3iR1q4w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C6C651F00919;
	Tue,  3 Nov 2026 16:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723149;
	bh=YhFPGq66AAtaFmboYz1uYaKBpqYr/PH8XApnUGdT9oo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=U51x1HrBbAvBU4FXVebjW5zRlZhklRZH5wj9qSxQhFxFs3sGcxl8zmuEWuqGU9X9u
	 18bfvrkU6tPb340mJzaLR5USdchWYaxrsYsegJk+Q8JZMMPE1p79sRMygtRFRYB3QJ
	 2rGskxmVZau/BglEVbJXw4hheAaJVJd2FjmUX1sVkWyt/FiZYr9NRxF8sXj70KZdZ0
	 kmlzV7kHErtclAhnCRTMjAqJ1XNIc2doGB3xN24Rd+3hcwILYShBw+vcor7pRDmb7t
	 m+Lpouh+0gDbeqAPyN+gjs5nIHfAc6pyzBbKN+ysH/0R1R5Ju0KawQZRdBlWZSNM6E
	 r09E9URk7DKiw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 35D4846A1F;
	Tue,  3 Nov 2026 16:25:47 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 04 Nov 2026 00:25:45 +0800
Subject: [PATCH v4 1/3] mm, swap: only allow swapped-out slots into the
 swap cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-swap-hibernation-slots-v4-1-0ba9393609e1@tencent.com>
References: <20261104-swap-hibernation-slots-v4-0-0ba9393609e1@tencent.com>
In-Reply-To: <20261104-swap-hibernation-slots-v4-0-0ba9393609e1@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Jianyue Wu <wujianyue000@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793723146; l=3324;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=DSg4zPkZqnOQvGhK9sG11r29/KrXHPQLe9s8Rr3DHeY=;
 b=11vQE85hIvbe97NqWxRwvbKHZLTqYj7++y3AJG7mDwZH12EvUhPH1qnjISuktefyl8en6VaMR
 jh9fyvGQjrxBGIJUcby06JaCEM3YOc/F9b/KUBNKe9Fh1hR/a8I/AfT
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam06
X-Stat-Signature: c4pofm9hwiuwz96znyr91z1y3m33h7be
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EAAE0100006
X-Rspam-User: 
X-HE-Tag: 1793723149-224069
X-HE-Meta: U2FsdGVkX1/H9TJSJDpPuFiSurDucGiJ+vC4W8H74x0bwVTsDbC+t/EJR/Ylqll1l7NgRq/4O65Al1vyKGaP0CtzAW+1qNq9eCGciQdSr1lW1j5VEkxcc0iN/JzdTgGef2WxKIsk8q5wNqeGhJidtDI2t7E+Zk8fcRCy2CPR5x0LH20QHwQq84yULdOx6MDzwUXNkZxqY881V/uwfYt7ETKxo8R6W04OZpSExnG1+orqVZBpvCATGvfUO2koeAuN7mCRzhfklppUBbWwnilfOR6v5c4NRgxpg5FnFRKpw9p68bZZ70xVJyhyXTRlFG/HZysqH1oyHxRwJEwUBh/YYolk+FhHLJPtK7q9NjwSVbw13+6xktyHixLDg7KoEfkqpI5xEmmo88aR84Ag37WlRVLwRLe5R7ojlqDM9BC/B1IsR/B0vgQnKh1b82X97AEbGZTf/+dTFyytjf5pgw1U1GNlMWYlKbbHKQa7ZpKq/BSWRjhxsBtc+m/fe9MkccAy8AUl+Lk9cfbuEETeruvovEnfxXjipdUeSiXrzHtEdvUw8/4W4mg8THxWdqP12QwvYmtjfcu2OW5EhR1HHm9YsEfvHUndB3rkobn4nrO6aXEMJvlMWE/4xGPHTSldYZCVKdsYqCo+YD91oOhFUQG8dI8IZad4a4BxAh/9E/+GTqixxKQTcPlTYy3ENCv/55j0j5AWWt5qNG+fxGSaNkUrZTFBco0tV7aWvfQqhZKm+OQZfM0DxtJcu/u9vDoAocoUA476y3F/Sc4VKpksAWHV2mPObt5whJa1MNJ4v8T7vsYEwS596sfS8FOdfC3683RX6YtQdG8Wxuqn93FGY5AztaH55drUBoWFqy1aXPILvqTL6RORFqoT7QV/YGHVVysg6CYJUPe0uBVZjLBMldQP19DcUKaIED+oMdYqn6/WyzV4E2vGiB+xT8Sk0w+DfESKYx7sWyDncUtnE0XAr2h
 Qh6MF+yB
 dCBV+QRk55b7of4ZpibP7d5kpKcczrGHSxtYqy0mCxAanVrzYKWnu+m1TtHXblwaobFn13H0nOo5Te/fK11ThsJI8PTUTdySy7vdFOm2/UoNVkbsazxPMDnyHPm2nKpQdebNi+92HG86ZLzYqzan2a9QCcTIG+6nqTvJz72/XIlKXGn8PjuSfvPkyCzrx/W/UZrGpl1f/HdH8TtCLiakxNVEFzBtJAJaSkoPM+za/3DMzTHwhpQn7C/WGOFCsbwjHh2paaQuBTc+KjS5n5csMKYCpXW/twv911bFwrLEZIe2jJrG5JkOAavI4REHY5rQGqsfYCvMla/S+rUx/EYZhbA0GUjYdbZ3WtddIAallJNtOrYhQvxuF90FaCf0K6UBFuWoze9WsTjoLCBpSk53NzakZb7Y9hy9BAuK/42ZVJY9am1azJD5kSF4LOIDXO79WmK924MBjLuVfFFdxPm8i6HKSqfExxYDOROaCs1DXWa/iiaWCbsRBRaRutQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Youngjun Park <youngjun.park@lge.com>

__swap_cache_add_check() turns away folio entries and slots with no count
and lets everything else in.  That is safe only when the caller owns the
slot.  Cluster readahead owns nothing, it walks a raw page_cluster sized
window of offsets around the faulting entry, so it can land on any slot.

A bad slot gets in.  The check reads the count with __swp_tb_get_count(),
which shifts the count bits out without looking at the type, and
SWP_TB_BAD has all of them set, so the slot reads as SWP_TB_COUNT_MAX.
Readahead then allocates a folio and reads the offset off the device for a
slot nothing will ever swap in, and the folio entry that replaces it drops
the bad marker.

Readahead used to be guarded by swap_entry_swapped(), which goes through
swp_tb_get_count() and gets -EINVAL for a bad slot.  That call went away
when the swap cache checks moved into __swap_cache_add_check(), and the
raw accessor there does not do the same type test.

Require a shadow entry instead.  A slot dropped from the swap cache always
gets one, empty if there is no workingset value.  The type test runs first,
so the count is only read off a countable entry, and the check as a whole
runs before the folio allocation in __swap_cache_alloc().

The large folio walk in the same function does the same raw reads.  A bad
slot cannot be in its range, but the range is not pinned, so a slot freed
and then taken by hibernation still trips the countable assertion there.
Give the walk the same shadow test, the folio check folds into it.

Reproduced with a badpages list written into the swap header by hand.
Readahead took over four bad slots before this patch and none after.  It
needs a crafted header, so a normal setup will not hit it.

Fixes: e1e6750df3b4 ("mm, swap: add support for stable large allocation in swap cache directly")
Acked-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index d9e36c505398..da65d75ceead 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -191,9 +191,14 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	old_tb = __swap_table_get(ci, ci_off);
 	if (swp_tb_is_folio(old_tb))
 		return -EEXIST;
-	if (!__swp_tb_get_count(old_tb))
+	/*
+	 * Only a swapped-out slot may be brought into the swap cache.
+	 * Cluster readahead walks raw offset ranges, so it can land on
+	 * slots that are free, bad, or owned by hibernation.
+	 */
+	if (!swp_tb_is_shadow(old_tb) || !__swp_tb_get_count(old_tb))
 		return -ENOENT;
-	if (shadowp && swp_tb_is_shadow(old_tb))
+	if (shadowp)
 		*shadowp = swp_tb_to_shadow(old_tb);
 	if (memcg_id)
 		*memcg_id = __swap_cgroup_get(ci, ci_off);
@@ -206,7 +211,7 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	ci_end = ci_off + nr;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
-		if (unlikely(swp_tb_is_folio(old_tb) ||
+		if (unlikely(!swp_tb_is_shadow(old_tb) ||
 			     !__swp_tb_get_count(old_tb) ||
 			     is_zero != __swap_table_test_zero(ci, ci_off) ||
 			     (memcg_id && *memcg_id != __swap_cgroup_get(ci, ci_off))))

-- 
2.56.0



