Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78580606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CN4+/0Gn
Received: by kanga.kvack.org (Postfix)
	id 345BA6B05BD; Mon, 23 Nov 2026 10:01:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D3F6B05BE; Mon, 23 Nov 2026 10:01:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20D386B05BF; Mon, 23 Nov 2026 10:01:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0179A6B05BD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:01:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7945C1208E4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:01:12 +0000 (UTC)
X-FDA: 85466696784.28.796E3D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C428A40018
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:01:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CN4+/0Gn";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446070;
	b=tqYRrQlVhaejgaHOfErs/oloip+2zL3jQ+J7/MHWJoOlQZzpxaWPAM496SpBVTuJnxIEqd
	TPlvUfFO9UuSlap5vC015zAnFwL44qoOorYIPlNBA58mrz8sNEC6Oph9seODOk0rNVgkWo
	5nPlhkRg1CARA0pveErhZFpHuUhm08I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ta1APtJZ3SbnBo9Poepvc+VpghMZSCLjVAvUkbF7mMs=;
	b=7g7UBbb9Y6/bE0bojCLwzvV4ws1wm/9AzwnQwsZm2CBPm2k541wuy7clsJnvTid7+7p6KC
	QEMJMak2iBq71YsITzT8pNfGpSoIU8Z5+kqM76fETlFWClQk0kXbQGfPWJXeEWYEhfwInw
	JElkRCTZxhOv2FxasiABLFt4jXqs2yc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CN4+/0Gn";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5501762292;
	Mon, 23 Nov 2026 15:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F491F000C6;
	Mon, 23 Nov 2026 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446069;
	bh=ta1APtJZ3SbnBo9Poepvc+VpghMZSCLjVAvUkbF7mMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CN4+/0Gn8La1gLwsgprHfMz/omHDvSNFjCxQwHPhimmlwEacFqD8PGsYCOyFDiVyk
	 ze+P4xBPSBNDIzhdfquMAInfch8/HX9gdFdCOnlrbU3aDg95jvFDCC4g22pUUMrhqc
	 j5suvJ7voB+XjPYD68SY1B+Ig+LGY1DEDWUToNaM9C00vjBZ6dfN6O7Ch3p3CHpv+Y
	 eS/c6SY4084KamWuNC+dCwuQQMKSyPXpVqXVyFEMIUE37iaWrJ7RH8alfiT840gElF
	 SkRKIxLJqOZ6bT/52loQEAsbEb6xkpW4leeTSqHjWjBPadZC6miIPJHh9uz+7DpDQE
	 /uGaDvm2SIynw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yifan Feng <evanfengff@gmail.com>,
	stable@vger.kernel.org,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH mm-hotfixes-unstable 3/3] mm/damon/core: do not overwrite wmarks.activated in damos_commit()
Date: Mon, 23 Nov 2026 07:00:48 -0800
Message-ID: <20261123150049.81317-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123150049.81317-1-sj@kernel.org>
References: <20261123150049.81317-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rohmso4outgp6a8phyxaucdqf837oz95
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C428A40018
X-HE-Tag: 1795446070-927459
X-HE-Meta: U2FsdGVkX18ugunnVCOSBEQRANDMS1XMzmAHI0g4y2dmg612cd4JnTlMAgZTKutGzye+Y72K1gGN/3FcaqzaZwl1436mPZKfp/Nft8iznYbGSZz4gg76Oo4OxAKJTte2r5JKXUb3CrugzzfVlSGtzj0saUHIooeBG6CzcqU0EZS5ddhYxR3aIAEKyfp4KnktnxgQ5dWWVSK3gprPldqrzmgz/6nMa5meHdpCHUjWJOnLwLQA0nGGcm4cavGRXBL9Q8W5CUG1qxtP3cLzxqRvTCQE86qquULMXvS6szlfWC+UZphJD+obq2mOgHfV0fpMHRu7kySQrdB8i+mNb70s7di8gfMW3TzmkZpS+GVitdiz0mnuz/Ik//OtWFNbJIjSOK09dbqesPlY/u+lnqxEkll5N+drbC2zvu5q3nYil5eNvNkIYoSwYaGGPPiN+ofmAeUR8HvG4XLOU6hz8E1CVU97l7jrgGMIY6Jf+zdr6CrBdJEniuP+pfJ6CX26VZzjPSjyTEvML/U9cilS20hKTq9qKu/MFy35RA3YfSuP/F2cncwD2rlkOhLoLdZonde1cjgTM/zWz/9GDfVV3tYNoV5gj+08+FOA8xQHCwEFYrMp+oeM9Y5Rj3tOeG8vUlPARHDTAW+e+yRw0WdP+VLewdkk8zyG5tC5rbFoTCASt8JNZwts4hpVZerbPbYuYv0xV3VCoYkidDqvjgIuJ3PHd1t1pdAiSKV9zSY29ZuyyGKIx9u8dCY+mmfFUCnkQBSAbgm7eCtaZLbXhgVT6N75C7nYvtBtA1pc9mSk5tjWxTmIqkZT5Nq/2xJ2sTapXN8aqch3/TsG/1kg32vZe5v234OiHqNigEPhSQHQUt/Y0UZ9rb7cQ0oJjInjOrhIRF/g4Cm251j+7IRmggmoqG7WKlw0jWBIUjeYMU+hCGaqZQ0OgcL3pVKVfdfEaoCYuQbxAZP3MLJJ/ULQ1p782oN
 XcIeNVTp
 6WYyS6Cxavz8JTi8CS62J0vdfvZitHzpEYJEGprHX4GdHO2J3IiX81efZcHS5w/1u8Hq0m5K/lBZ+OJX8aXui+emAS4XIt9spLyLW/egOH9h1lPB0DgR4Tn+IzhLXZUPL8iDPOoxOEf53KtWmCvbsLHdTZIs2xwNJB7QBcLoWP3OTJ8EVzGbFnPfdCEz3TFk3BC6ilM2msStn+FGooKHdmKsAupCC7xHxoqpKuzNvw//KdU5KRc8zh61CekL4l0EmT0obLSVtoBtG2C87/KaGld0N7u32sfIr7IEW2J4tZvpljJGx4k/LzcjgwZscT/NfEqFxzel57RxctTptg6NCGYifRoH0BVSTjaPcuppPCNCOopCPSEqV33Shl1uYEFVphItPAZjdPb7NvqBqAGR1l2cAc8dXn5VHmbMbf87Vx+p6+FedYl1KjQC2a47WELqHOCCl4MjxA2JZrnpKclj01drtc1trjuGnk1FezWRSZO6Qp2tFiNZGBNfBXRV3h3+hobyxTQlpBgQ55ITvr0KIrrA0sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Yifan Feng <evanfengff@gmail.com>

damos_commit() copies the whole wmarks struct from the source scheme,
including the private 'activated' field.  The source scheme is a new
one, so the field is always true there.

As a result, a commit turns on a scheme that the watermarks turned off.
If the metric is between mid and high at that time, the scheme keeps
running, though it should stay off until the metric goes below mid.
DAMON_RECLAIM and DAMON_LRU_SORT use the same path for commit_inputs.

Save 'activated' before the copy and restore it after.  Do not restore
it for DAMOS_WMARK_NONE, because nothing sets it again in that case and
the scheme would stay off.

Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit function")
Cc: <stable@vger.kernel.org> # 6.11.x
Signed-off-by: Yifan Feng <evanfengff@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261122002930.98401-1-evanfengff@gmail.com
- Collect R-b: from SJ.

 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2748f91999240..0e6b361f97ea6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1567,6 +1567,7 @@ static struct damos *damon_nth_scheme(int n, struct damon_ctx *ctx)
 
 static int damos_commit(struct damos *dst, struct damos *src)
 {
+	bool activated = dst->wmarks.activated;
 	int err;
 
 	dst->pattern = src->pattern;
@@ -1578,6 +1579,8 @@ static int damos_commit(struct damos *dst, struct damos *src)
 		return err;
 
 	dst->wmarks = src->wmarks;
+	if (dst->wmarks.metric != DAMOS_WMARK_NONE)
+		dst->wmarks.activated = activated;
 	dst->target_nid = src->target_nid;
 
 	err = damos_commit_dests(&dst->migrate_dests, &src->migrate_dests);
-- 
2.47.3

