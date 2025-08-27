Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73477CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6EDF8E0145; Wed, 27 Aug 2025 07:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B20118E0105; Wed, 27 Aug 2025 07:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35818E0145; Wed, 27 Aug 2025 07:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9178E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:58:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11889BA483
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:58:44 +0000 (UTC)
X-FDA: 83822390568.23.A59182C
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf05.hostedemail.com (Postfix) with ESMTP id 86477100010
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:58:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756295922; a=rsa-sha256;
	cv=none;
	b=RJ6YBtLWg5L5hTcee7tliWgA6Fhbnc+2KnpgWuK625rkf1TD+DKCCqL1eSGXZ7LliG1GK7
	Yzo1c1PR8hOAbDgSEqfj8eBBd5Mfi+GfN4hRi64wM9/TzLnkeNBXUt2ORQj6iRbGnI0FdE
	FVNSO0YvqkWMRFyUwd29eCVCNMm9lg0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756295922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=BhacN48NLFHOao+3BI0pFrHoJ3ght8EjUQWoLqUiW4I=;
	b=PbpgdEaNene46w6WvbPvstCuBrgYwdVa5qS5rcj+rrRA/wEKm+OcDUHXczPxd9WKSAs/lL
	0s/2M356tZM+Z0Ne4g0VRq3QDHAq/Cm2dSZZZowps3pHq1G4iTB4u/y1xjVLcTGVJjJTXE
	NNoQCo1nRt1HAl3ynW8gnb181AguwWs=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cBjjK4h2rz14MGx;
	Wed, 27 Aug 2025 19:58:29 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 9C630180483;
	Wed, 27 Aug 2025 19:58:36 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 27 Aug
 2025 19:58:35 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 0/2] mm/damon: void divide-by-zero in DAMON module's parameters application
Date: Wed, 27 Aug 2025 19:58:56 +0800
Message-ID: <20250827115858.1186261-1-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 86477100010
X-Stat-Signature: xpmno68tn8j8ai6bntxehyrorioe36qz
X-HE-Tag: 1756295921-196029
X-HE-Meta: U2FsdGVkX1/8fBGcUPmjnTKRhy5cid6sFSBHrC3kkOkvMUH/prhBRSQna0BNjWXZCQF1HimlMywJcoOTwfU3ql5IfQhOUlnMGmdsXLigJlMQMlEC0uiTYcVp3/W2wxF5lb4wLLHn/15p3BcEycww5CmjidS0XOJkaBQA3Ys7aTOExsW1uyQuNfiZIQeH/UxJv1cynZPABoyBaCviLNGrQ7ZlKAE5FWBR4x5lHaRcnl5GhkF+jGU3SW+c0M4JdFsdjwqbUb6Ue88yNVP5f81AnTimIA8ROWYwbo2qwl7xvvX9xw3d9HIu/D7NvzTlgNvYxWa8I6MuP2iSY8FEhXS/ZYhD2ieWTiDBEo5bl66rHqesBTG3j77osNxYTIWTlf8zyhCo3FmenllT3huDmnnpfhV0cgyLeebwWCnuqI7lmVJEUv/YYrh4dWCjRhWJW9H54bDFAYcXOxEs6xN4yUPrWkQuvNO5wHqzNaiuwl5rlvUEHck++j5vHe2oCI5PVycHESkS9qzam6p2jnso64qKuKOaxKbtTBP0gnX5OiO7+F8KFGPB6mP27UDEibIqQmaCgekP/Bijh015nEQRoevttnyb17s68b2rzg+vqGmw0w/9/CDotVspDQR3NygLkir/RQPA0LrdIlyM2Jvu0oADLwtgDO68P3zYMIahIppmQeSayZPqAeSm9HxNTvKG+nfFU816R3dFC5y8OWYD5M3eknUkZk0+HlZ/4ja6OlWmV9k/+ouJyc34ChKwIhbrAA1z71cCqhh2MidKKip1TImZGg2phpExqkM1+PIX03PDrw0+akEhMzRjtjB+jioQsCFxIF9CssZ+kk8HTDIQRJB8iSY6BGKSOnDtzE1JsvmR9t6dBi8j1qqg9hL8Kfn7ZtdfO0O+s2dZg8yoI8TlV79U4xATxXE4miWm7N6RZ7AIdKGf5RL/HazODC9JnL0dgykwJ4EMQTMlh6zrT9QGNLT
 0/pCc2ZD
 4ECFB/3DN1JwEzeM5n+NiCSIyZ3oRI4sbd479PRXCEp5VRHZLsbJ3w/TAhdun2nYhUtcLUDNnmmgrqjPu8RPvEYVfMoqMwasUBKRikIAAjh5Rt5uAc+sMOb9zJdJRxke09JXJ5V9vCQ4kUKswELRpCF/HmYtPBy5d+oFQ2NPcaCMfVvqcnkLhMuoJgbMLr7ptaXzsvNUQ/Rr/1xEbq7BlRuMF7EkX4/OKVTrzXxMCdezFoWhuFCDi76IeZ9JTHbfAVYHv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON's RECLAIM or LRU_SORT modules perform no validation on
user-configured parameters during application, which may lead
to division-by-zero errors.

Avoid the divide-by-zero by adding validation checks when DAMON
modules attempt to apply the parameters.

Changes from RFC v1
(https://lore.kernel.org/all/20250826033653.1208227-1-yanquanmin1@huawei.com/)
- No code changes.
  - Drop RFC tag.
  - Add 'Cc: stable@' tags to each patch.

Quanmin Yan (2):
  mm/damon/lru_sort: avoid divide-by-zero in
    damon_lru_sort_apply_parameters()
  mm/damon/reclaim: avoid divide-by-zero in
    damon_reclaim_apply_parameters()

 mm/damon/lru_sort.c | 5 +++++
 mm/damon/reclaim.c  | 5 +++++
 2 files changed, 10 insertions(+)

-- 
2.43.0


