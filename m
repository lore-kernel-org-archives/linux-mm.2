Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71403C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641366B00B1; Thu,  2 Jul 2026 20:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619186B00F5; Thu,  2 Jul 2026 20:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556D46B0115; Thu,  2 Jul 2026 20:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2E86B00F5
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:42:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1602016823E
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:15 +0000 (UTC)
X-FDA: 84945069510.01.99FDBC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8520216000B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Porqi2o2;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783026373;
	b=sTEx8vrtqI0+nw6XSJ66M3ZxDheBweRLpJ/4cHcQkgDbb79GOAt7x9bTEiieTeGjh8rxQk
	uRzZsYwxBQWfPf+ZKkicBxPwA1X6k4qKJOc7Ce3fa2nezVePZMGgXniI7Rru7HzifFKJ/A
	k2AL9FqEeKYoLqYLVHw6YnBrxgAXmvg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783026373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flGogPd+rUyChBMLRSMN0vLB2pILqw+V29hJNORLFwA=;
	b=dzu4Su9a5zb3m82+g0dYzqM7sNeJZUgkoyehCGKfkuHHLADziKA0X4HafRKXHTnUD4mXY1
	+oUygDrUbqun1azdEJQBcMhAiI4k8qD7FiPNWzLYs/6nrixPpqGtUwGvq3z/IZ/vNbhhH1
	TPayhhz31qOUVx0ND3wFnpeCLl+NmSA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Porqi2o2;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69FB0601CF;
	Thu,  2 Jul 2026 21:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC29C1F00A3A;
	Thu,  2 Jul 2026 21:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783026372;
	bh=flGogPd+rUyChBMLRSMN0vLB2pILqw+V29hJNORLFwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Porqi2o2NHBfwr3i9HRm5oEQCIJdgB3mKb3ntTcUub29r2DSySmsOGJF6kVmR6fiv
	 fjFqUB3sTZFjUZDv8iDlk7zoyHyOpKFaczHoi9HL9BYgyOFy5BwINzvlri1d4cWo9A
	 DI4hGotkdKq9Mz4+aNqC2RrPK+Ach2h26tDjS3wg9oNwn7EFpGez/ISWacEw64v2EG
	 LQ/LDEvrb61A0YxNXJiEI7pkJZhA5mgag6ur7ISJNt6XokeKMYB7w8uJwKTUsz9Ybb
	 PnZPXKznN2sgSFeUUPYs0rwS/LTIsRSGpsN2jzGg9njB3+imF/CYS/fiKqeNGCVx5m
	 asTMFe2j4I6SA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 5/8] mm/damon/lru_sort: remove duplicated min_region_sz power_of_2() check
Date: Thu,  2 Jul 2026 14:05:47 -0700
Message-ID: <20260702210551.95167-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702210551.95167-1-sj@kernel.org>
References: <20260702210551.95167-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8520216000B
X-Stat-Signature: 1fb4dmc5mi5bi8mo86rirrpwa7zajqbw
X-Rspam-User: 
X-HE-Tag: 1783026373-446974
X-HE-Meta: U2FsdGVkX1/KgrAfXJsiMvm7gZhjL7oAbFwDh2U3RAUM1vS10YcClX8LdSGzxbcvBd/cT46liH7qwygVSNu0DCdOT+PeyBkVSzipcMcvcGtXFOLaipx6hpd0FfsRzLjQtMBl6/fuLYFNsXsVpORljUqjSIW6PdwEUZnvIDoduw76PQ0o8hnotqew2hxQmaUgPIGqBJ0gZspbxQeBqGP3tG69ri6569jsc2mmIoseXzshTMm/UR+k38/lQZngd5vGYRpT8WExJHNn5oZhWymVHDIV/Y3vPwrlpoBBGYXYJt7i74+vb8OP+X0NKXSLgUsNM7bu6UFdSeImJjGwI7hIO+ggCD21rK5dBSalOCYQaFkiExB3fA4+9nZaEOAfjfqKo5V0q7s9EMVM0tuY0LMpjZuIiCmS+Q4zruRyD2nRgqwDFNZ231m7pGmZnF2IUDoXNr1uA5EP6bowljpy+lEYtH3qIM5ScX0caQfsfpUbMrEbOl7uhWEvGgo4nrS57se0OuKwjA2YXn+EMfoHgyD8Uxn8GNh9vj+6O5BJ929GdSN/WAUCNRGPxw0Lq1HNLqxKzUwkyz/lVgGpOlwefxcFcwHABSE/hAnECwiH1ZggvuHrV2K9gYdehvGsMwPYQl1QZ+fDJxFdLyg4HtIA3MaLwLinRAF9SPstJxPch6ZdV+nn/dAQ28AlrwJ7KprSMpTlwuwwC73BpSA/V1ZkP8m1J8VcI/IA0tgcMVU0bZgj/h1l3rw/fzm30tfviEKBj1zFssQhx3w2n8slaZrFMwuXDbGHaDkFului2IGuuxLbGYca4TUmXnme6+zSJE5bKy3WaoAbSNKDOfqPSpYNYmNAcag2WCMSm0ft0kF18VXLL9Brzn1kA6FE8RLQIkZkGamOuYEK7boDoD/t/EcsLMJaGD8oHKde7s+0T5NqrUyZnK8sVWdiWVJVwmBeAAKjXKA4ZRtggh17JaOFRhoX4X6
 0oZcPUmT
 LgMAJXKGjotN4o9xhA+dir6DQbFk8ZJER4Sr5TraM4OSNJqyl/M9R+vy9W/VqO+8yS15mvBn2HvKwPRMIudzpJTT5CoeBk28eiPmT1sRWTtAvIcAKxf2pyPE8Qm6fmQWpboO7eoAm1MuBvgsrTPIewW3jZyAba+hLmtpRfAXY6rf0ZQ05wqkEa+cNZUWeiGV3qCp6bd2WDFK2/p3awSZB/Y1i04YpG3saU+z0cTaSTRWsMC4kC4USeMzMcV9b1RoIIDHuz08Ta2ILaQs6fzLyspSEqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT validates the user input for min_region_sz.  The same
validation is done inside damon_start() and damon_commit_ctx().  Remove
the unnecessary duplicate.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 32f41491b726b..2dd0cd0d26273 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -284,11 +284,6 @@ static int damon_lru_sort_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
-	if (!is_power_of_2(param_ctx->min_region_sz)) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
 		goto out;
-- 
2.47.3

