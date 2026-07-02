Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70536C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7ACC6B010F; Thu,  2 Jul 2026 20:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C2F6B0111; Thu,  2 Jul 2026 20:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1B356B0114; Thu,  2 Jul 2026 20:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4A616B010F
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:41:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 301408CD7E
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:15 +0000 (UTC)
X-FDA: 84945069510.06.BEE3B6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 91519C0002
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ljGPoVaR;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783026373;
	b=e1Ac0rUWGynGIWHriGQUt/YHrbxgV8/ehDpsxz84tcgakX+UsXeuOnUvOOcWq3/qpgSzXI
	4AsCQPKTly47VoEcPwVt66zjAZHCB92vvAXAL9tQbX1gljOlUND8TzaxxkYADRUMw3PjS+
	NnSivvK/Z8Ke2y9GXfXbnW5caiSa4f4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783026373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4feI/qU1SbwMydOJY76MHjKjfYHnoO820guZYu+4uI=;
	b=YI6DjqxUrnn0UHIqMGCSK0BblIvhYm4ohxtbvEVBbBVImy4HuFxzLkB86uiU1xULoPVy18
	+H7QQc7fYtZCjIJcWwG3OL8a20Euzec4ZL84yocFH0ovNFIgcACW1ewQrkdDImQc3nwSSX
	lg+FACt4MfNMqjc/mfHUpI+Dc36JDhw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ljGPoVaR;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB22B601F8;
	Thu,  2 Jul 2026 21:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD1F1F00A3D;
	Thu,  2 Jul 2026 21:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783026371;
	bh=z4feI/qU1SbwMydOJY76MHjKjfYHnoO820guZYu+4uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljGPoVaRPSsYpd8xs8EBy2MLqzQCKbktUtw89flLSbk4nzvtlLCe/43mE10Bq9u+4
	 akxWatJ3/XfFjzRYBuiPRshbxUd5pDyWnZ1AvBxB0+79mzcKtLtsEoBUQzkJl7bVc6
	 oZLkTrQcoVHvCMcYhMQhAySQOVd9S2PunLvrPf2ebBHGXNvT9w0IU42vESskpQwZxT
	 O+zmtBjwLSBc3qqg/a3LBrDWFCA11CFy9kVsJHxei4AMYtopl39KS3WXXYgGFUYypE
	 H/e2AkkcfzlNXxhvnCBYJmzGa3MBij+3UPIDawYwwMRUyFnmltMK/yJUBlvQCDrpI0
	 +wC1CUFbLRFmA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 4/8] mm/damon/reclaim: remove duplicated min_region_sz power of 2 check
Date: Thu,  2 Jul 2026 14:05:46 -0700
Message-ID: <20260702210551.95167-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702210551.95167-1-sj@kernel.org>
References: <20260702210551.95167-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 91519C0002
X-Stat-Signature: 5xd1g6m8fr75sker3gtjm5ubycpyjj8g
X-Rspam-User: 
X-HE-Tag: 1783026373-93529
X-HE-Meta: U2FsdGVkX18menFSyqDTLr2ftPRk+CX47MhDoOw95mDXRD/tMxRlRL7RP1XIXkdESFWnFBj/hPqxWVUg5dV92an+nsWE9Ln58C4qrrzler9UIWux5jxuay/rOV6QQ1qgLivp7533dVQYiuOIcJGtOdbgtNpEipVWsg8iH07gn13PyjBeZz9TLiN32M+QhaTB0hmmU5GA2eYb6wU8Y4rVou3blUsdzAMxCRqpIjnzrJYcO/9psyUqY1DulwD6pZvT/YHm2YN1XFvJ/0JdZu8dWEh3I4XQf6qUYnIqs+HRFXzzSwih0FjuM5Aj69fWdSYRBrfRzy1OPnjRLpsC5nPz0+UBUDObOsUC/ZUsSK9POPvHHAM10G2p4+nBcF/tyDyFXQsoBec53c2n31App4qzq8MyWjZE3ucKXYrU1sYtIIugLeNokieN2hywmbxOMu62lTMhJArQ0muHEVKOAn1TqqbSQ/vVTT4qJxLHR/qn/IUtqw0Tkpu+DANOjmADzprwSeSvsK6oDIR2FCd5HyRtDsJBpTJijXaOaCrCRaeU0xSkOebnUm0/opqit1HuuWA5JwAwcG8l+0DikDFprR+k056JTJ6Fb+9df9OzDQ1iBHkglt/8XNNLed91svdg1WXgozJguSbJuvPB3ywK+LGqqjCC3DEJyL+EO76sXKGTqJFaiJifPNx6sDESrHMT4BJanb0t/Wp6p/k4Npsu315fmU/Uqtsqp/+Kd4Eh9tp8xiiHgzz82dtqI6enmi18BbTh2QZ2cXQ52fcdHJyTouDFx5AF0fX266WyCgtMouy75D0tjNDcXE4t9iGNwmMVA8LSwltxFQjqP9surPVfDeL53JQeOwLuue36mdrn5ixdOrb1+GOjLcGP8xy+pjoJbQQt6ymmQG5nbVONKVeQPhbmhOHysajMzffdLlLr7BCPogJokwa14FCVHIfTBNSO5XEubKixl7VUHahn1TRUsgV
 sKBEAbHV
 oIiv+XDxHJD3rhbpCVToiH7q1zAy54ObXORARI+dpg8YBACy+X+VWRIDFBdErbQZAYP5jgk6lyX4VaZ3Ix3MloOL0DHbnCuytmnK7PxSKFOwzVd+2cuq6RziGX1coAEeI8R1UZdBG8zipYCxD3lW7RhPMGVWw+lGc9o6l3UtTIisrKUAK3m8eXJdt8nU/DjeJlfIl6J+BtbbiXxPE4BGeiVo80Mb8T9z2PS3EmK5hnhMzfYvS9Fc56JqrHmOCIOiOU7QuvqkSP8Ev1tlnW5hGnVpAbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM validates the user input for min_region_sz.  The same
validation is done inside damon_start() and damon_commit_ctx().  Remove
the duplicate.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 11b70d0a9a6f0..6469b25cc34f9 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -208,11 +208,6 @@ static int damon_reclaim_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
-	if (!is_power_of_2(param_ctx->min_region_sz)) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
 		goto out;
-- 
2.47.3

