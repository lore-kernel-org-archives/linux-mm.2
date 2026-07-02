Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89F5BC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75CE46B00AB; Thu,  2 Jul 2026 20:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70C106B00C8; Thu,  2 Jul 2026 20:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623076B00CB; Thu,  2 Jul 2026 20:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A54F6B00AB
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:46:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B17381A02CE
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:18 +0000 (UTC)
X-FDA: 84945069636.23.950844B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1EBE818000F
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DSA7olTX;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783026377;
	b=5uPvy5DwzrDPVgwsUZ6bmvdw553v8uwld8DvWPo7dmDDEfwbzwmPI6rfqIfbV27XJjp7S7
	9y2+iAd7qlNuiXMspKH5p3/wwqBAEPeiq0JMTDi8yWzD1T+zvzvXN/94kRaD8MxvWg+BXO
	jCRLmFw+TLzDuyKouPVtYNP/6Bkx2iM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783026377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4VafhRbm8rnHMCZpEIBC3NAXIVyFpdQKn/cpt2JTi7U=;
	b=GP1MBu9l8Hl37IXnG8mLZzwTQs8TL7HJtAZPzw9qh3A8kdbAvhZxIS1RVIcDkyo4y7i1Uw
	T6GedvJPgUNYPkVuPFlTCe5kUYKlj8EjnnYTzeTO8qLHc4O9QzA6tkEcuV+Ndh10JU0Mq8
	jv7TjnWXz9CVrCjzynac/z0oGWRfsac=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DSA7olTX;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B67D6601F4;
	Thu,  2 Jul 2026 21:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12941F00A3A;
	Thu,  2 Jul 2026 21:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783026376;
	bh=4VafhRbm8rnHMCZpEIBC3NAXIVyFpdQKn/cpt2JTi7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DSA7olTXiK45kxIsJ2zUsJjlHNjfe2YGVGHkKrxOn+m2Kvh7MW1DpHKwaoHSDtrZx
	 UYfI3QmQJroc/k3L6Qz1cnKLIbCYUBtrycelGNDd4aG8liuLE4VHj3oW4/KJOarXD2
	 ao2+jfYyKunNNtzGA85zeoLYGPZ2TxHsnUPNoS9dCEEwn7nqnLilHyzPQwomoUjGE2
	 EyFbHGRbw8NrUnBIWwB286euTRDLUdSG0vYBsWTruaFyVM6/i/1MkNYt/n2NsVIQwt
	 N/1KVzLtVQIv7i/ZqAyCxaKNxKzrj6RR7dRsAq/EcdHil4PGX1zu2tdA9X0AkX1gb7
	 GqhYboUbPoS3w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 8/8] mm/damon/sysfs: remove region size validation
Date: Thu,  2 Jul 2026 14:05:50 -0700
Message-ID: <20260702210551.95167-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702210551.95167-1-sj@kernel.org>
References: <20260702210551.95167-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1EBE818000F
X-Stat-Signature: fgmj8q7aboc11unwxtjgbkecwp7npk9w
X-HE-Tag: 1783026376-496958
X-HE-Meta: U2FsdGVkX18YFOabwmlWqc60TRcMueeoDZDioDhZIy8yTbL+2QnMJ0jgWro/jEZwXy2bRedhcErsT6dvTs0+nXX4haM3cloopo7GbRW53ja4znwsiVIom3Sf1uk0OI0eVV8WL99fqUTA5jJXU4fCmLzy8nNcqdnGzDKRQfNA3kADziMznEvSzgGd+U/CdA877puglxqN0UVHv58/RE72cXhtoba+d+hBtb+vkqRAJ2Il8ZH5ndDj3Tgr4hoCbkQ0GWqOe7IsWnsW1nrYi1RAXYa4dzTHSN8kWUo56dtj9w4JXzz2zSTelch62D3uE8AfIYmC8pnQ6g8AaBDSeLDS2Im48Oqgz7O/wPdJx58Q58eFcDst3hGMp2sdSwWXktXSgWIPAre3uW7ksZM88qVT9bLv21j9CPX6c1WwTZP+nLR+/YWQZkotK1hHOu+H9tVdqgbLAexDqG8iviMEVyNxbUTZN1pB9r/HM5u3oc6Hp76eUlGFCgdzNMulnUGpTttjXGO5C5QUrHqL3YwND8aXrQ5c1iosU66Tu3+32zzi2XkZeXU8NA0Jx6oqyjIJgCSQ5dCwSUchJXabvmyE6jDBWR5gDG++bRfCcsRAnHp52gCazJm6kkjD0DXR2XxySJAppectsk1lhrSQ8R/z0P6k1I0sVNHRYLCg7A7N0qXlsXV1iiPuzQPigl+QBDz7Apj68K+T3UYf4+oPxRtxvpvj9BYvG+Qyaa4ZNsG3f7Ap2Z8YHX6loeNlHk2qXo+RohsZ2yEE1pRvZqdg2n70vQbS8KX0YKeAod/ETHKngNlxS9lzHNGsYP+GzLFVc1HZrb+SQpPBUC62iezCyEXictQGwCOFEJX1FhAsJ/xwPBIdA3GdrjzoNTJjSQGCc1Kcw4RPbPad2ggFhTVgEW2hm+OXTNNaxHIWXRr2fLXG0gJk7n8gfxeWIioU/qo5fb4uwrzQeMwq04cMgKLjplRdw3z
 hX5fyhRd
 j6htk+g7tdNR+uZ1zfu2q9jsBt8bpiXsLE0szdRcJVs7aVs+G7zusjshcTJYbeSCGj1XApx/gdx5Q4o5tAX/l/XlNyX0U+FMk/F1ZmeqgrwokS1VAC+FpzfHnbtTOxtfhOtr1BWVbKWcFgRSNfB3bggLPeZegVzrwmCjwHoX6Gda7uJTwYtepevQbVNTNmSOCr97Uf+LT2g+5DKXEiZicadNEaTSv+4F30NKC5fAH18Pq98o=
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

