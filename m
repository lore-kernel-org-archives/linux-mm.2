Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47611CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73C486B0008; Wed, 10 Sep 2025 07:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ECA06B000D; Wed, 10 Sep 2025 07:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9636B0008; Wed, 10 Sep 2025 07:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39CC46B000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:32:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F0A0D5B885
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:32:45 +0000 (UTC)
X-FDA: 83873128290.07.BE79D19
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3F4011C0009
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:32:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757503964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=2ATC4ybomY+rbqzkqzg0u1Fa6HQmqppjmxI7eHYZVhs=;
	b=lCrJf3OfG9wgmSzAdNtzIgECFfWXPf2zFbn0V0GDQX6pqdc5MgQZrSo5fk3Nmj8m7KoWtb
	bYNBE08pWer03t0VtOmBaT6Jo4F9ybWRG/kf4RB7jNaLyNvJDvMP+uZKASNIS/98SK9EPJ
	4vXPRq26KUMAvC0yIeKXRsFHAAdENm0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757503964; a=rsa-sha256;
	cv=none;
	b=Upz0VZLN5GQ2JlhJWtnn4GCqwoEdG+xk0JwKQFu50UN887CJmHlJ5FO3+8Ki9RhIX0aMVI
	yMWhQj9Q7ts/z35dS99Wj9+c9gGe2f4bXWFRrZLwCQGe2OdbXaqlE4Swwn7vFr5hYK2HB7
	P5QrcVMLRwmAVZf4u5ywtZ8mqc/wb7U=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cMJSn2Mh3z14MjD;
	Wed, 10 Sep 2025 19:32:25 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 99BF31402EA;
	Wed, 10 Sep 2025 19:32:38 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 10 Sep
 2025 19:32:37 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 0/2] mm/damon: add addr_unit for DAMON_LRU_SORT and DAMON_RECLAIM
Date: Wed, 10 Sep 2025 19:32:19 +0800
Message-ID: <20250910113221.1065764-1-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 3F4011C0009
X-Stat-Signature: zqn8u9xjeayknwb1ara5axddjc8uq8jc
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757503962-714983
X-HE-Meta: U2FsdGVkX1+2n8EP04du5VOoJP1AHYMDRt4cqJjaikzJ+ZEVzk4s+BwgGcyO0a6TRCfofTF3r6tge2bzJHH2hB2BqcaxvqG134DedzoQbGBZwPutGX6ILHFWun4KsPUfOm9uvrkAms+c7uF7jipUxl9/lRTpfGhbQw1XqZU4zzlASzM12M+69Xroihod3lJoiiCyGTfR0zT3pbu0X/KzjSn1nK089i2xMnrpsE6QWDVi/pN/DTKR/S7PEznoTXbYhb7+BXgws8ny0fN1pjf1qAVe750KQId0jKLng0tgFSqTKZQcAJGtBPRa+ezt4P7zftt7sRlLAiGvZig5fmPY6sZVTKa3061xa0Bnl78c0e+ysartchLwjTnenoLB5k2HQEtV1MBaC4w2YPz3c4x8XVyXYbN0jrov65IkPX96CSKmNTMrn7BibX1MLg8yTKgk/Civ36nujRLIpR2wpAUg7A8Bt7FTAXFOTVrGmfQ633VHQhRiqhWUXAigtuWJECuju1+waoAYc6e729aCVRLbi27TVVXL9x2SU+x2AqML6ZciW+WliaN0LobODXIwcFOO5FOG4Mc1Oc+oUDtxFNl/8SVtoz3Gtor1q1bn6jGcRhRij9cTKG63eNXZZBlUNCF7JOxjxsO9S5wZcBFfYmuNE0Np+tDdTgxi8+0h7cZKwz7yEoT4g2jbxqc59vrhVWDwOk5/QVDIk5cUa1xrt2Dbwm2nvxNkHN9JozvRcNLEjwqv+Ar2tPtI3pUtB9cN+29/RkxGvI40L1qeqCUe2gj38GuQndHBR7EH5laZYyNPNLGL0y13g04w7rCYVz0rO2OTgdjQqHyE7kHTjHbs1/BcLgfINJxrI6Xb4vKQcuoLsaWWW+vlaulWVHaT2nEQbK5cqpIqte/ia492/Ma5Yjay8aySKKPLCwpOA6CA1VRCnurObRXMajlwVG5iPCcvsbIP6hWWqScnbWowZDEI0uC
 gpwQSi5h
 ctjlSSiyrpvnXwT3yGVtInEcDDIFSwPcRtlY28Rf9qzToW8ac/6kzorWl/SXDXNvnu7ySztEK1RBsVxVCU0SyJd4C2IBcPqcuMXDF/lE+1ehMDSECbNhYKWrmSRqbVzwLw+idktBQ84cyRmRHTlhoB1hT+O0OBoImQWamfjVIGxr1rPA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In DAMON_LRU_SORT and DAMON_RECLAIM, damon_ctx is independent
of the core. Add addr_unit to these modules to support systems
like ARM32 with LPAE.

Quanmin Yan (2):
  mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT
  mm/damon/reclaim: support addr_unit for DAMON_RECLAIM

 mm/damon/lru_sort.c | 40 ++++++++++++++++++++++++++++++++++++++++
 mm/damon/reclaim.c  | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

-- 
2.43.0


