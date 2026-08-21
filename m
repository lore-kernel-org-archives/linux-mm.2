Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A76AC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 03:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC44A6B0095; Thu, 20 Aug 2026 23:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B886B009F; Thu, 20 Aug 2026 23:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD91E6B00A0; Thu, 20 Aug 2026 23:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0966B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:10:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDE3F160372
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:10:41 +0000 (UTC)
X-FDA: 85123799082.20.BDC43E1
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf06.hostedemail.com (Postfix) with ESMTP id 19CD6180006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:10:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oAEBqRaX;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xiqi2@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787281840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8yDcFR+JRwUAhHUbxEslRG4ozUpYc7mICckRXd+YGaE=;
	b=f/4G+CxM6CLKZriayOQCvlDCLPbOgYuzZ5tmSgxmjE2L3Y4Ibv8zu+0VBTrbtmPRwxRg/5
	eNAO62B3yBDeTbUD0Qlts0Nyhbw0NtMkc7HQRg98UfUGifRwAyVBOXElS3NiufCRCuwp0f
	eWvrYZm1i7aicXJxNVlMbtItqGMgrvE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oAEBqRaX;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xiqi2@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787281840;
	b=uACD63JCOiyGWHbeLe4QbTccSjJONNgrXkL8MVB+ZuEJZb36zyz1On8nEontmSYE82FSQB
	AQ9ZipRawMbqXKjGRXDPtQHZXZLSLRmHQRR/bBez4MNm87devIGxjAPEqhXLn143tiLnUN
	IcGiZSmjcEWPvP1uw07V1t7DRYAFHn0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8yDcFR+JRwUAhHUbxEslRG4ozUpYc7mICckRXd+YGaE=;
	b=oAEBqRaXGTzh2urxagPrdacna/rgkvtCBxJ37E5f1pOYSkxOwjdt0kkdW402ehzjeXxN72N7w
	xuU3oiQ004ruk0ljZF/C3Yjgr/VKit1fCoHBvhggTGCTa+rUNkzGo5M8WQH6X9oC0gDZ0I+MKOb
	SLxaxIUD+emKPHnNvrcLmA4=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hR4m33YB0z1prLg;
	Fri, 21 Aug 2026 10:59:47 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id D3EC24056D;
	Fri, 21 Aug 2026 11:10:31 +0800 (CST)
Received: from huawei.com (10.44.142.85) by kwepemo200010.china.huawei.com
 (7.202.195.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 21 Aug
 2026 11:10:31 +0800
From: Qi Xi <xiqi2@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>
CC: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
	<wangkefeng.wang@huawei.com>, <xiqi2@huawei.com>
Subject: [PATCH v2 0/2] mm/page_isolation: fix UBSAN shift-out-of-bounds in isolate_single_pageblock
Date: Fri, 21 Aug 2026 10:54:59 +0800
Message-ID: <20260821025501.2752563-1-xiqi2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.44.142.85]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Stat-Signature: g375a3rta3fjxdhkesq49puddcmqp6jb
X-Rspamd-Queue-Id: 19CD6180006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787281838-320014
X-HE-Meta: U2FsdGVkX1+7bQfbIq3qE03tdsYsSL13aINk4zrFOnxarAlY5xBP7AqxIye5Sp+DraZOj4zEp37tXdwDDelulHKqr9O11Xx3U/D//YFECj8xaVPyYvcdjfj8hpJPGg8wnzBcEUahAAo2FnJ53pQ5pzqolWffvzTtvQy5VTt5w8oqJ+nm3no3Ng2o6K7ZzkiED01AvGrqUtEGg4DzIFq9FB3ZqxOzC2V5dW8XqI3gDGo57NU1lgaPdDm7v57XTjG5EqmZZIIVy9zA/aAenQbx7EyeljoYrIZeReQwisFDJ6NgIsFBMS3kLn6sC9L/Z+7B//47m2E+NdbOh1Nt8/7qCyCNZKERm4PG6VVUqRURJD/X7xgtar7JCSY9INr8flBL90VQDgmhqKiNt7ZpFMHXBeNKBu5lAhXUnCNYfCXds1O5uFK+4r5sZpML6nwUwij+gtvtTh/gyXxV08bx1/cwZ4jNKeh6Lgt1FAiCQ0uH+P808cORZKzWrC6dB+fUPvzeHIsuJ7ePYGNU2C5312Y/h6Nx3+R/lKmiI3czVrziauN3ANZxo85fOjIU2GlFLDeiKGqiSJoecG/LZ4cSpPVwDVyc6nenlthVNBD30xPngiqGwf3jYTvwdZEiuC69evtDxePouniWa7IxRVyLz12lUXsxo1UQKV/vZfAs9PfRHKF8R6+2/UudX2tCJ/PgUQX1RLFKdzaJzjpU9RYeDigQlg2utUQe49UUzhBoyyEf/aN/0lm0xnMqzUywZF4C9rwm3kBeJC7WEEyQq236Omqy0V/ZrQntdf6EkIVGHtWcted0dTYr3WMX3oac3qBIh92f23Af1Q4qPDHJKV+GvzckY8sbEQP8DbUmIjTf7Gov/Fsrn5SaV3pAuARFYwj9WT8ifGYXYGvh4IBpKXJ//PJQ/A/KBf55SwdQ+EVJ81dlP6tDQ1pGKRo8UOxli7eboPEDqOYacc8FTRjdS5e9g2p
 xmwwi4cM
 0HM5qIMPToNCtWL8fA5zDnifzcNOO7vK9RPYpFO5IAGbz0zspeMlAxK/DffcFpkrMcQof67VpHI4q7Cz3yH5ctVoLGOwmvC8nEniP8NpJ47Cq5p3dEDqG1xhL+jfgSTfKq0Ar+KNXIntunlfolewPXMJCQ49PMlC6Y31wUBwDyXemYnjAAcu/ciwzzOkMwrPXV+NteLaCetm7iNBuyHaFzYxEi1FPgjqY4mhw+Pb/+9uxy2G5uCOGL6sTdHbD1u7b5P3Ot8Kun2izKu+RjzMDfetopSUPv72qk6rXDwmc2D9Ei/sUAmC00A76cXFUGGUmHbSe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 1 fixes a UBSAN shift-out-of-bounds warning in the PageBuddy branch
of isolate_single_pageblock() triggered by concurrent buddy allocation.

Patch 2 addresses the same class of issue in the PageCompound branch, where
racy compound_order() and compound_head() reads could lead to out-of-range
shifts or incorrect page skipping.

Changes since v1:
- Patch 1: drop VM_WARN_ON_ONCE, bail out with -EBUSY instead
- Patch 2: new patch addressing PageCompound branch race


Qi Xi (2):
  mm/page_isolation: fix UBSAN shift-out-of-bounds warning
  mm/page_isolation: guard compound_order() against racing

 mm/page_isolation.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

-- 
2.33.0


