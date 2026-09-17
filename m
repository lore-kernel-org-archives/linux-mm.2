Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C656C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43646B0096; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3866B0099; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DDE86B0096; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 671E36B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59B7D1C1A8B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:48 +0000 (UTC)
X-FDA: 85221915576.04.680D868
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A8E1118000C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JTN26iIo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JTN26iIo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789617946;
	b=NhJuxtATJN5LC84beIEopuDQIKjyeM/JjIiKz12dQbukGSDuJS3x5iU0Ru9KKPULRIJ9Y4
	AKcgrjaStCPPW70jskyZALtBvojhgBLAZEVw4xkkIdHUL2lkEbSine+WExVHEa3s40vAvJ
	ceF/EkjNgF/siLLucmo6wwYNwE23WjU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789617946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7NGmBAgLNyxB6QRiSTsc0KXNRJO/iSY1w2o1E3csW0=;
	b=q7xDpjFdERgl94BfC+HSIbk9iTUrhv54J2Rz2Jag2Xz6sKSNVhg2T/wHCxuCr+7xZ3Vscp
	NCuJt0DOsMyrAR+eWtNh1m6X2bd6ahw/5OCcmWSGuZY24MWv9jCCMC2ZY3y8Bf0LTVIqJs
	yisryYOmPw+ssNpim4rH+jnMlOUFAkA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C74504400D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ADC1F00898;
	Thu, 17 Sep 2026 04:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789617945;
	bh=T7NGmBAgLNyxB6QRiSTsc0KXNRJO/iSY1w2o1E3csW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTN26iIoHZhelS1NeIJaA/1L6mykFHnMmouYpjQ7s2E2tM4Hdp5ad7L46DnZbdfUH
	 S7bSCftBfMXaJzhFRf/w9OMZSaMWJlZcliIKIiRBngJhOyJRgL4QSj2+rzrHK17gNh
	 qpCC2hkhGferGcj7KF7/FHsVJZmFThTEbywk2ItarAheMjiEYIyWXrmg7fnhJNJYrO
	 6IpAhYsnBhGUFBkZjxtkDHoIuJ5P6klF7lkwSe7f5lElKaLsZbinzse/4wftbalHqP
	 VhvOXd86KOikIksTTR8J0ZyKNT/F6RjLMHVs5y3IM8HtSSsFMJhFcUHRCHfR7LFx2k
	 eixXf+TisSNGA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 01/10] mm/damon/api: remove NR_DAMOS_FILTER_TYPES
Date: Wed, 16 Sep 2026 21:05:27 -0700
Message-ID: <20260917040537.107341-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917040537.107341-1-sj@kernel.org>
References: <20260917040537.107341-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A8E1118000C
X-Stat-Signature: znupt9g3eot81851kaitdfen4ohxt1qn
X-Rspamd-Server: rspam01
X-HE-Tag: 1789617946-883457
X-HE-Meta: U2FsdGVkX1/VfPSDhCEn0Ww4t3+e67t6K4rj+NZleY4yQ+6uvGzReeYIPyaenwwxCR+8coHrjuY9V6qWfhuTGufpcwJ+U9mXUgVR+QKTiUAPJi7p7JNVbjcySFtJ3zu6ueGx2w3aQN+Z3voFXJeJ9A5TO/x1zLiKgwYK+hY275iv+lpfoTYgsUTCGrps3V6bWYlFJ+1JwNZBFNW8M1q3j6wHllYROmavq7uIcbseuRkgc7wNxOjgMarRwwzfvJZjDmraZVu7vtmMSa7f5LvfIrQ5hOjTmkhn+SAep1QI8T98bWJMytZnYrpXmnwllDhq1/kw2v6BIJftl24ZRf5v9zjsQV0z6fgaQ0W9pk0jZ4DaK/7Dkm1WsRyI0W5vSMqYh7gz+2Phm94zED7wvnLiDPMKN6Ze2UIsDF/U9ileXpe74tZDriZQtl/1hU24sppPck1y1f3FUOMZha5RqgnfjPbjvjf0t9Vo0f+w73wgskGntzfLNxq736p43pCX8YuRpbdT38FRu7hM0D4dqI3LpWtXr0/AriEleOtOkYJbrJEmXws5Jswrfqb8YurW3bv4zwz4JienSnPjbKiAo3Uj87/RZf/sXmjOPdCWpKnvPpra5XoIuq1+QWSHsL/ke+JOEpj9XqqBGRbyTsPPRrkQAY2QXkzaLcq7kz3RmHv+umzq0JIfMEjjWNPeLT87uB/eHuXUdx91LJBF6lPEz0X4kdaA5/id5aucJuBqvl08Mgl0byIprPaudjGauX6S1Dqcko6atV5WZoX7VkioYmqGCarKkPYZUn1XwDVwBOCrUhifdTDi1qym1o6xk3/UmmE72X3fGVRaDnW++21iPdE5y2CEVZ7O/oujh8NbESxS8Lyg996fNFjDjHvWxrt2I+ZeWUWY/um2/N8vqumdpxi34uYBms84HfIsMyYILqZfPONG5ejzS6qPV74NWZov7X/BMLOyaDdsCNyBCQ0zfhc
 /w5M2+43
 xf3UAtpXSQNUefRQuYefJp9l0HpS30y9vK6ES2WQnHGWbEK64WZ5kYt+j+Nn4xK+OQ1OQf6SSGu8oqFLAurRx6X+t45QVqpUwhQe+VMzhs1oGwpFf1KcF8DlO+JzgwCR3zmy9uYH12c3JITbQhGujHiamHnUdjJAhgwx0KfMs9J2NPLi+VREtVCFkO0I32H8LFEJxgAXjiYxUqHONUUIpEFLA0/Egms07cxeE7/rloFPUMzQ81fSQGQd9atxWGt+fljmYe0gO0BT01m7G2fDGaPVsS5JpubC2AC5TWZx7QdBgTYxK7vVT3mBBABAEqlOjb8jhtUv6gBtevNCMhy61zYk1UFEqXOmF2S/dJHeMRyTw69SNySyUvO5OzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody uses NR_DAMOS_FILTER_TYPES.  Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index bbb190b474015..836353c4ab9aa 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -400,7 +400,6 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
- * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
  *
  * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
  * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
@@ -422,7 +421,6 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
 	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
-	NR_DAMOS_FILTER_TYPES,
 };
 
 /**
-- 
2.47.3

