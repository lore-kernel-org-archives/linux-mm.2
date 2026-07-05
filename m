Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D55EFC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 15:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780FE6B00A7; Sun,  5 Jul 2026 11:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E37D6B00A9; Sun,  5 Jul 2026 11:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AAA76B00AB; Sun,  5 Jul 2026 11:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35BFA6B00A7
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 11:56:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B94BEC0475
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:09 +0000 (UTC)
X-FDA: 84955174458.29.D24C129
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 268B040002
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C6MmsbUS;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783266968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4VafhRbm8rnHMCZpEIBC3NAXIVyFpdQKn/cpt2JTi7U=;
	b=P1f9KqQBg8PxgfJTf0RWzWscmmRpwvwvvDVYbpBRP4HyWvsbTdmvLH5xAZ18RYkTPuZbml
	GtuSH+jCRmAuDYCCr1r3Utzy/j7P/FecliiwIBPCS1RFcSYVIdH4KOxq1U7ieGn1WEFlEc
	vgRKle1jDFP20d8TGB6YCCyGH6oOuxQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783266968;
	b=YgQP3RMbn2weNc5b/Um1Uop2jHULMx6mb0jnWznDNs00xTR2HnLGJFsXmfRiNruj7Bv+vG
	Y38OxxgCPp937p2itEKdIemqulQTYfValxAM3NeAdhnx21TlKK19kMhjZVOTnlS+r50biD
	bmpWfmzYY52wCPLawccMY9ZyoXhegbQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C6MmsbUS;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B8FE43C1B;
	Sun,  5 Jul 2026 15:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397F51F000E9;
	Sun,  5 Jul 2026 15:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783266967;
	bh=4VafhRbm8rnHMCZpEIBC3NAXIVyFpdQKn/cpt2JTi7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6MmsbUSMWJyRvF1mGdO+EmcCiAWgxvSYbcLNiXa/aQBbPxCPiH5jb6aQG4UZ4aB2
	 VXRPOXGSkMdGrhLaFI2ofZdahjG898Ul/o5lPQac1Ba7lqSsBlljglDhmewAhNRH6B
	 3IJeJT/9cVpZ9mVWkh9cZjWo2Iy/WwrBAZt6GtM6r0hRLINZokrlPnF6+93ldahHpa
	 LdK0rwG1a6HRIEXnS8ClAbje3Hwaafe6ANBnTRlMppQpf/6HWEigDnthf8I0Oq+lT3
	 7Q4X1S8ESLtOTW8fJaLPlpjF3ztNgl6eqK09j99JIQRKOpoFE/3PirGD/YZUuPrHb+
	 HKJbhuBfjXH8Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/8] mm/damon/sysfs: remove region size validation
Date: Sun,  5 Jul 2026 08:55:59 -0700
Message-ID: <20260705155600.96555-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705155600.96555-1-sj@kernel.org>
References: <20260705155600.96555-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 268B040002
X-Stat-Signature: cfznsngty4rhxxkmnzay4u7heh757a6m
X-HE-Tag: 1783266968-363280
X-HE-Meta: U2FsdGVkX196Um3VjvDXaAI81YSfPvQFVACvRxnYDChbNeOvInQaiS4PuWqGYHBqctvLgorlQX0NlZhiRQN8iYwxvW2PMe+CTAkQJ7YeN3SqolnXQ5YUN5sKfRTpLnaDbsBrKxoPkG1ep5voe4zfFMBthOJkew7YeQtEQE4tRxKis6nnvAHz5TdZC0AF/AG8j57sv4Eu9zBMyDWyPkCtwJHhoMbZ285ngCn/BspM1zY/niHLro+kcHMCSxkyH4vraNuvwfsxlD0g48PGcKzyQ0hkxaVgdsN+WDbZwx4jnl4cWfqPr3/HPs5wC8gI2uwJnWe6oK1cPd5pI4Zh9UaEauBnJKBN/E2ZtvofqZwohmALm8eaTzTZeR1XlInObtEUIneiFp+ePHIzJJyREYKa2KEtwMZPMh+ZPfw94Cymo72qfX/aOflF+Je19L7WoBrgX2WxIktes8IPekO7wOAyAKTpHQJtH8+SEH1AOEWTcgknrVOCpHI1cB5uC2JZyQL+qCJI0LUn+W6TSEOOKc9gun2+DNkMCa2rwJRHXu6Wo9frF8H1Edkd34OpUg5RgLzEL7CZf+aCwMILGRaIP8npMyUOhtfNwiGA+RDnZIwBpfyhda6+aBIpb8ue/Rrqo2lCB8cyx5shRfvndXjZsgahQkNNgLmNLevPdyUpc29XoQ51WJY7pX63t8XePV/n4DIeGKv8kYt260Pd/GrkGo1mn4sF1RP1RCrdq1o+xLejbHaxT7uwAY+O8ubucKZ+PjAzUH+x3ksa9rF9F/blqZXujqqGbqLHLWdMU1T/euLtMIOi1H+e6w8ascgZxufJLjYS8r/cUenoiFGdrwTaSRrZeDIlCpcZ5QCxknnZos8cuWF10znM1kq146TMAYegtYQipDGfJdT3JyovnJmtho4xn+Z15N++338yXQ4fiJTRu2p9H2ucW802s7XH+3yJnkaaVJAHbnN32XdLQpp4c+R
 NaLZz41i
 E5+3AwCyJHoOdkJ+fTXIUozdAXN0u2EONZHLo+h+nD2DGucecdqm2hw6O7mBSzXv1f8ulJv38OFgqlLSJWIk9RdHf55KoXliNClDhDNIp2X2Jyf0C8H4Y3gakO6HZTgvFNzdhQrTug05MQOSJBRZTwAwDJEC/u8AXb+H8pwgY33XWzczAqmQSoYAdnaZMrGUavpDuF9vc5Qql4Qdy1c/OBo9RyBcDAvzeX3jjT8wxRr2Jer8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_SYSFS validates user inputs for monitoring target regions to
disallow negative size regions.  DAMON core assumes only positive size
regions, though.  The validation is incomplete.  Fortunately
damon_set_regions(), which is eventually used by DAMON_SYSFS, does the
complete validation.  Remove the incomplete and unnecessary validation.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e666dddf1feba..b65651498e0d1 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1987,9 +1987,6 @@ static int damon_sysfs_set_regions(struct damon_target *t,
 		struct damon_sysfs_region *sys_region =
 			sysfs_regions->regions_arr[i];
 
-		if (sys_region->ar.start > sys_region->ar.end)
-			goto out;
-
 		ranges[i].start = sys_region->ar.start;
 		ranges[i].end = sys_region->ar.end;
 		if (i == 0)
-- 
2.47.3

