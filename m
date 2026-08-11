Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C28DC5CFC0
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 07:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA54F6B0096; Tue, 11 Aug 2026 03:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56CB6B0098; Tue, 11 Aug 2026 03:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45606B0099; Tue, 11 Aug 2026 03:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E90E6B0096
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:35:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07F2A1603A9
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:35:21 +0000 (UTC)
X-FDA: 85088178042.12.9CF9104
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3ADBFA0006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:35:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=v6v+JOnM;
	spf=pass (imf25.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786433719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hoLXg3qBES80sGSjnvB7C5r4qPEp6f8ujBG09Jv7+Bs=;
	b=dIrG3qHEFDNgzP7LemP1fMBKgfBNG99/Cq/b2sN9eY3Hqnh/N9GL7zq7ARpRl2bU9UBe72
	3lSGjTlkYlZtk8Fx2jZV3QebrjKnmYfG9xW0a3WAzQetUhjSAv6AoqYEJPJ5fbFidXktrr
	jKuH/Tqc/vl/cbxmqXHyTEMSkmqN89k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786433719;
	b=uQddFoDKW1rdQBDxSZRSjyyiRpMSLVgwfDgUnYgLSX+9svlzxLhj7+mscZc8EXWSlYUu1i
	W/baFPBYILpS6k3FDw695vFbSJZW3nKnCQ6Zz0EhIyzhYIOqJWmGVh/MlphGBn/kLLy0/z
	A3hJyHXo80HYAXGS+Czpd2ZRJz1NAuk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=v6v+JOnM;
	spf=pass (imf25.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hoLXg3qBES80sGSjnvB7C5r4qPEp6f8ujBG09Jv7+Bs=;
	b=v6v+JOnMklo462ZtpAGnBiIbI8Ay2rgAy3NuRxIztH3o+UREa67WHAjdWDHdgmPB+F29T8xcb
	S6UC4N4MsnXZjjWou+LwQXsWL6+u7QemubCFI/V4FlrRIzhC9T3o9Djd2EUPXlc5Y9yNy0Scq1X
	1aNRohToEPiNPcNpxP0i9Vk=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hK36706XvzKmT0;
	Tue, 11 Aug 2026 15:24:31 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id E0CBE40565;
	Tue, 11 Aug 2026 15:35:10 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemj100016.china.huawei.com
 (7.202.194.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 11 Aug
 2026 15:35:10 +0800
From: Wupeng Ma <mawupeng1@huawei.com>
To: <akpm@linux-foundation.org>, <liuye@kylinos.cn>, <hannes@cmpxchg.org>,
	<mhocko@kernel.org>, <david@kernel.org>, <ljs@kernel.org>,
	<hughd@google.com>, <mgorman@techsingularity.net>,
	<yang@os.amperecomputing.com>
CC: <zhangqiuhao@huawei.com>, <wangkefeng.wang@huawei.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Wupeng Ma
	<mawupeng1@huawei.com>
Subject: [PATCH 0/2] mm: vmscan: fix scan overshoot and ineligible folio scanning
Date: Tue, 11 Aug 2026 15:08:47 +0800
Message-ID: <20260811070849.1332165-1-mawupeng1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3ADBFA0006
X-Rspam-User: 
X-Stat-Signature: qd9ym7hgi1pd6xrze8nmsy3kr8unzxia
X-HE-Tag: 1786433718-51855
X-HE-Meta: U2FsdGVkX1/zc3raOLc/Sb8lHTdoTP7YD+aCozyNODJmGF91Bn5Wnx5SO2YaFz9Btb8h9kS9FUtOAsB8Hdc19tFT4XRaQhw5BJv/YRrpKH26JyXWJ5pDDtOnD0VyoZ0VkdhvDdrrGDfznadP3BmZyL6BjjH8BKULPePJSlbQayztaDPiWH225Yxz5+LDG9NSeWz5Haj+/C7fM+xgPHuCSPsVzm6Z5vegyajuJUSil8MRFfdE+Fr2nXxp1nEu2yo2HRfJ3h8BHi1opcMYc0DW/4OQTv2LF/vZVB29U0juZvbWDVdRRF95jCdE9S9aP7Lu9FsuUUvO3V2nBuwXFtcG94Bgl37bBii4MXQvSC7vAjf1Cz1NO3wEeiiybkanddJ50u1rjlnwHB1T6lfwqv2Bi/AF5dxGZMviTM55RVILtHzl3m13aQNA9twAOMo1eavNs/7K8CbvBEwIe8sbVZjfFAPRyLjrVfnpqA55R4qmVRLxTo84wDsZgGmnT5DkGY+rcy0cmN5CWQg70PZMyEVHnoEW9BcFZwWVqnJgaU/GmIkpt12QnKZoa+Wxzz7YECLr9I04/dVReTNiRzb04bBZa2vkdXcdRKXKlOAPNuYH81EXV+TrIdt3+9IrZV4UHQd0PMvmjojFYAX06KbnjMg9l5rfAGbQT31MYiq+RpItbJsIYdnW7Gay1a/zxll3e85jwOppHB/etCl3RIlvzMbkOOIEN0RvFQ/ZsMMvjBibypm8Rv1bX8+g2eqZSLX46LRFszsjkuY7h5VCb8Cuk5TIO7rM2mwXqKkIrUbaSOL23Ji3p++bWR+hO+T3xWTiiZstAY3mECHDR5dRsd3g6QuUuH7g8Z9Au6VE1HFX7cGo+MPYWZqGHbimC+VnfTAnB/zGClwlYOD76YXyt0lCvXt1ekFXjdQacbQWmENlvnqVKcdotE06NKGgtsiD+8CNNzLNaK/ZkeMWO56mrhghu5U
 6l1IBWkd
 4ibh7eAm+Rt+jIOFtLKvxc+/Q+gGSEdQLRApLwk7Nn185+gE7s6FEs/NnudjRduvPqEbreJ+hN34tZ90Eoy2VYL/fhaFQG9nnFMa/B9XTTvWKSQZASQpwHyEVORIp+uqUeCgxZtzoe8XO/mByESDNK2EhG8Z1Y0YQ/xOti63oe3KvTkbu+0VfrOAHiN4cUJGWWerpno8hjjoPBzB+4OmgBEd7I6WVpRs22iF5+HLPJBal7xAklxlzjukb9iVprUuVcVMrwA9XpxVS1QM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shrink_lruvec() drives reclaim in SWAP_CLUSTER_MAX (32) chunks, but
isolate_lru_folios() may scan far more than that per call on a single
LRU.  The excess is never charged back, so shrink_lruvec() keeps
rescanning the same folios round after round.  When reclaim targets a
lower zone, the same scanner also keeps walking zone-ineligible folios
that can never satisfy the allocation, inflating nr_reclaimed into a
false progress that delays the OOM.

This series fixes both:

  [1/2] Charge the isolate overshoot against the scan quota so the
        next round skips already-scanned folios.
  [2/2] Stop scanning once too many zone-ineligible folios have been
        skipped, instead of force-isolating them.

Wupeng Ma (2):
  mm: vmscan: charge isolate overshoot against scan quota
  mm: vmscan: stop scanning ineligible folios after max_nr_skipped

 mm/vmscan.c | 48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

-- 
2.43.0


