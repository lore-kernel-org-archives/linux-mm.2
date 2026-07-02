Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01D78C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 557786B0102; Thu,  2 Jul 2026 20:43:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1DD6B0115; Thu,  2 Jul 2026 20:43:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1076B0116; Thu,  2 Jul 2026 20:43:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0DB6B0102
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:43:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC58FC1827
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:16 +0000 (UTC)
X-FDA: 84945069552.18.EE7D2EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 522F2A0007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XjJmr1gQ;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783026375;
	b=soLWt7Mb1t5Gaej9HtZw1sZqW/ugRlYYfa8LGy1sUkG1LsUC41eHJuhs0RzUiy4u9/E5MY
	dTxjvR0571/daJb/GdHkL7I51mAw/E3tpisGiFF7mY0t2k9CGeFAJw8Cpnmbte8JJ0vexQ
	ldO3SgO1OANoLdgYm+yeHcg1N+aaspU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783026375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BUtL0wdhRHBCOaPZNQsX8fjUI9m5nC+jbrg8ueFSt4=;
	b=P0sT32bfwVHIsGXtQ2FFsLmm8x9eBg+7BetwgqYZtJi/zB4Y2BALCmmULkBisIMsXY6Nzu
	Id/tbwnaI2LbHtJNV92kaLbJGSz6Stohps5FdpFJs5jUOj2M6amn7puhvIxa5jIdQaZL6b
	oBLSSI9E6SMeNKMcvnn2jn9QmQNhHdg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XjJmr1gQ;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F0CE42D61;
	Thu,  2 Jul 2026 21:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F951F00A3E;
	Thu,  2 Jul 2026 21:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783026374;
	bh=3BUtL0wdhRHBCOaPZNQsX8fjUI9m5nC+jbrg8ueFSt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjJmr1gQ51HXvJVpcXxk/bKSPfbeoxDgQExOGa2UWh8rMvyKzhr1k4+rn794A4jD1
	 Uncize0oEBLHFHMtajttgUcGKDfZPq128HITOPFHWlO2nezZAyDKmIc5NZgF1QVIJ/
	 +g1Ixii4KVAr1aCJhWnW1P1tQbB0WJJc+6yYap7s9rWM1FyXTSt9K1lNDPXbC+OaeM
	 IABNn7MGGQVgVm1hJbOwakWUajkzQS3e4YECRdaeh+4izzNvjFT8sDJ/QwayXDNe7Y
	 d6aMfWSqftpt+BRoHY+bHJZ4Ic1PXEo8mYk7aBYTCK/5lQdp8dRiEaiGc+kj3OPcwE
	 +WYi6Ms0NAj0g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 7/8] mm/damon/core: remove start, end check in damon_set_region_system_rams()
Date: Thu,  2 Jul 2026 14:05:49 -0700
Message-ID: <20260702210551.95167-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702210551.95167-1-sj@kernel.org>
References: <20260702210551.95167-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 522F2A0007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: hsb1g5pa9tazzaf1ufk9t6r83d1ttrdk
X-HE-Tag: 1783026375-467534
X-HE-Meta: U2FsdGVkX1/BWQdtoRLUXk3DXsC/jeMUoBZ97ASi7Py3IXcchkxdA0e/+2g4fzYTGwt2DJ2yc3SK2GzH6/PenCV1JVH9w+DMfZkbgtg+GatjIdo/WAe3pG5D58e59U0p7IiaiDaPGqs35AvQBvWDkmc6Y956IKL8JFTmOZnMQ1rmpWYqdTBYvxuw+6r2YN2cJnuGZlikpdHC0Zjp7pp/M+v/t4jo7cmGuS5a5r98CgRCl9kaeqJl6V2xmuquF01B4FELVGiHRR4bUGwhHPxEH9TqrV1AZHB0Tsb/wkEl3NDtc/pCEWWgHOwgz8LhaNsXt/MN60kF8CAtwsayMl7ZagWTWv1srjN3qNWHNa/czIApHJPh2V5sK/wEqR/G3O2t9bCQEskw2mrf6LTPZ8t1hgSSt8/HVS/dLbWZA9+V69g/LghFkDT1JwxGP/o+N6vjy/gSgdLo+I4qUDhQkoIWSh8MB54HgsEQ887+SNckm/DbI17vQj3D13f53+4zs0f0ru93IswgHwqxwFd8uyOlpSYV3/y4s5AHlA82MQdm+xdCyyEcb8nIpDHF17LI7TArkrT0T0RmSCeJtTjz5uyKYfXYcK7K9frS0h6h5U61opVaNHbuRh8zsgNpKu5fxiOQt1HLdMJFb8f1UloM+Bbw0aHf6yTTM9iG5fOj8GFF/o4oZwUoAR1ho6LVMhhrVj2v/pWjC4aZCmSpXP8CgtbVJ0Cu9Yi6gbWodZopnmNaO1CaW8XHXd/H5LunFYmLFWojOmRBXCpvzZvM+pkWMpwRIe06UY+ItHlu/p2u5R46OM7ULqUDkNlPX5W1zWk5JycYMpQgpXrjpntFyBFwKIZjzVofyjI255hoYQW9u8I4+KuVZ6JMsoGh/ST8NJ9B2chJfzdOF48XIAPAffvdeYZKbsycFXIl79TNaeZXcrggFNqB8X1cGXb5jS1e0npZ3sKHWwoLmtY21h8kjfbqWs3
 EYr/lEOz
 zDlV3wKmmutquDSRjwef4JbhqRD0yjHMj4dcEZ4aXy7a6TcCXQUjPeds+cQPgfh8pfMKnWS5TULVHSR7iNpa0eoNaDIXijqyso7Gt+q9dWiXgoIXM4G1XiamZCSwj95GwZUacy8Kxd9KbCxi3IyMJEPf8jBvW2j0xlrIsbyfMb4jZKFqmtpVKu/bSb+IRis874lPhI1CXHUYlfU0BqRCdRQkSMXY9wbBhnP8J4qVBqvvQqW7RKJIF5+QdxI3Y/lVc7C2Penkclt38SkScHMwV4ABcMuaWlsk4sw23Bp87PlvuZfkt3Lkk4Vk5ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_region_system_rams() validates user inputs to avoid creating a
negative size region.  But DAMON core avoids zero size, too.  The check
is incomplete.  The complete check is done inside damon_set_regions(),
which is eventually called from damon_set_region_system_rams_default().
Drop the incomplete and unnecessary check.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ca301abcb9ec5..3c5a46e1c079a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3846,9 +3846,6 @@ int damon_set_region_system_rams_default(struct damon_target *t,
 {
 	struct damon_addr_range addr_range;
 
-	if (*start > *end)
-		return -EINVAL;
-
 	if (!*start && !*end &&
 		!damon_find_system_rams_range(start, end, addr_unit))
 		return -EINVAL;
-- 
2.47.3

