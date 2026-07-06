Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6142C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C498C6B00E0; Mon,  6 Jul 2026 10:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21706B00E4; Mon,  6 Jul 2026 10:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5EE36B00E5; Mon,  6 Jul 2026 10:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8ABFC6B00E0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 191CDA040A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:25 +0000 (UTC)
X-FDA: 84958559490.27.ACB8045
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8DEA410000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EIgAZYuo;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CerPQCpLVt90M0nUjHgPSrY+HHMTa8twt+lmeeO7V1s=;
	b=z32RotpHfZIJ/C/bzqlbfAjvA0CWntSHc69P1OUQGiuH4nnRcGHrHwJSAdJyTJE4C+BGW+
	m/KRGpC5Zk7XKpbuI9U+5g+cPWJvq0DgwDQEncnAQtxAlQhhrVNuSW4o2Vl2Y/L5qAUj/d
	eQinqYa/OGujnJ+G1XPaTcCMzP9IzHg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EIgAZYuo;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347563;
	b=MEwY3PMWYKgfn49EzGm1bzBf0+msIPWVp2BTXQt2qF2eKS6rMghG0prPbll/3BgEenCjEc
	3bnm4zSywqyjIS5fU17Mt7HTYq4pTONYTLfSsZJaH2TaGSKBUfn+Ecz7YjaSwuXmVFDopp
	U5aeQAWQIRBW+dmNpO07n0+jjg6KE4g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C539600FC;
	Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7061F00A3D;
	Mon,  6 Jul 2026 14:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347563;
	bh=CerPQCpLVt90M0nUjHgPSrY+HHMTa8twt+lmeeO7V1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EIgAZYuofMDWd81/+UVkaNqqj3ZRSNPaKKACGMwYBeYRlMAAMvbM1f0BIQ3k5C4cg
	 IJkwrmB9mApp2l2uhMwmV6p9yslrT1zn8/o09WwFBR499UwI1/ZK2T8F9Q6iCJRPKP
	 FVMg/r4poJjC0So3O9QJxi3GDzcDAqu+jNn5SrLFoyahiyy4u5H1gCZPHCe+1aPf7Q
	 qhlXct3Rsv7pOZHqIHPFhMOhzQ6lEEmY8IY/PNyf49L2E/+fS0Lz2CYwr1skOmJgxj
	 ZNvJXYEEP6lPHq+rrFAXCDQHuvoYfhUyjbljcU9EvmyXreI+1iGsImGyRgFHbRDmLG
	 npOcp8NEmAT3g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 08/16] mm/damon/core: disable access monitoring when probe weights are set
Date: Mon,  6 Jul 2026 07:19:02 -0700
Message-ID: <20260706141912.88445-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8DEA410000A
X-Stat-Signature: r4zsf5gkgajx1wkf77gpt77npf9po87a
X-HE-Tag: 1783347563-783519
X-HE-Meta: U2FsdGVkX18XdGPjKZ6QltEIdLpP5NrRqWegF1EGGILiNDbyZ9eusAekk3ujSMV1tQOpvRgZX6gY22SHGfV/AlinpX0iWnzaYJPVM6J2LdGNQH6MoPcwCBMm3U+octUnHn0aMu7FO4ItH0oB9f3EqsTiE3sJYYYN+HN+zLFiOoVmVyWng8JUcqwgrKVyhYT6GOrVsMngLGhbqkip7YEobq1XCdU28kM7xeI01WgugJyXgblZMRGPwJh5HzQijjsFP1qqNtuWd7self+qfrTmo8mQrLa0Ug+ZOxD9drHpy2u+rsCiDdI8OuMUaHgVP74HNd8riVowTQdu0hL5ge61DQMcM5YtaaSaXBcyPyx7yB82Wd+t714SEENpI5O484CIIIGNRucvxznUCSgGa5iUWq4x4ShvjpeYny8Rw45LlAZa2ewrqbIXy6w0AjvtwXB/0spcwJcPB7xl2/BBupKuW8zcYB0NfZ1IHNITQC5hxGvb5vYfwuW5xJd7vOKg5GsFbAUIUgQl2ydW1beNtltZItm6ZwyzWxD9osZwiUVPtsYTBsxG7PUqvp26TCFMSppjzp/WeRia3LNtL0FlBFYyLZefCK1DbiXagwcDuPxo0fPaB3lqFV/jiT3VoZiEQry4lAm6jNFdySVRL0EIPy06WF7t/nvP+wFvIh6spKD8tShzBcEnZxE1gy7tQjBk0cqFud/dw0pesiPYEIlwPA2oWh3RIkCqmnptSt1IH0NHa26Gd/XRtSDvGKPAL6dhlLP6HbNeoIEDVhP/J1QPaXfHFPpAFA3jX2n8P7ot3sugdsJpv2rc0T+aAzeSpMSYqMuv6glNyGn74C+T8h9BLf8RQKeAy9YVa9GrS2SWI8wOzKU7/luQrDrhnkDxwE/n5KUx/NbakEXd7Rlb6s5LhkF+VJKKy4vxoEybvP0rCYcVoNOE9FX9UbzdHK/0To0vr6BVeknw7sejido6ihDQrbT
 PcTA2Jbh
 sQtvdaujEo5Qcyc1wtH+Zx3QJj3zY4COQoC3uV7lkoUURnafrBPWQskHVwJtf9tB4GGQE5J7S4RPlq443BazUeOMu2EJfh6ko+XTBQTOdrKzmmoMPByhx6ECw1rPZS7jaZ2BDysD+41JFYGTwQKormWUXDBWqOs+G5+u96yUpGeXwb5tkNJh4OkIbuhYDt9gGuZFR2kHO0HdkCHhbGQhmhjoysjTXyEwc6iw1lHJYirO6QpA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When users set probe weights, they are interested in the data
attributes.  Not necessarily they are interested in data access
patterns.  Disable the data access monitoring in the case.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9bb884ab135ec..ad0f28469e633 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3714,17 +3714,18 @@ static int kdamond_fn(void *data)
 		unsigned long next_aggregation_sis = ctx->next_aggregation_sis;
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
+		bool access_check_disabled = damon_has_probe_weights(ctx);
 
 		if (kdamond_wait_activation(ctx))
 			break;
 
-		if (ctx->ops.prepare_access_checks)
+		if (!access_check_disabled && ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
 
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
 
-		if (ctx->ops.check_accesses)
+		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
 			ctx->ops.apply_probes(ctx, false, false);
-- 
2.47.3

