Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD095CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 14:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A4080057; Mon, 27 Oct 2025 10:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40AA58000A; Mon, 27 Oct 2025 10:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347AF80057; Mon, 27 Oct 2025 10:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 219418000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 10:03:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B52F6551B9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:03:02 +0000 (UTC)
X-FDA: 84044060604.05.2ECA0BD
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf27.hostedemail.com (Postfix) with ESMTP id D672F40023
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:02:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=nTHj0Gv6;
	spf=pass (imf27.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761573781; a=rsa-sha256;
	cv=none;
	b=csK5RDzF2C+A6bh8Z9SbIgMEf8EKA9sgXEHQE6oTdpNJPdusOvULJyEsC6pDhQILopPPmE
	VElPqDJiH9k72mYcH16Jyc7zcU88KVIzNWK3sZI4uosviV6mNxxj5fVPEAygMwFSzZ7VNu
	mOKD4nLNwrFpjLBNRZnWoDZKf7A+FvQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=nTHj0Gv6;
	spf=pass (imf27.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761573781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TzkRKGIlc/o7rNaRSYplFXt4cJ/hxYcmoSd6y1EVT/k=;
	b=HaYOY2ENUCvfIzuGhnZuHt4CuThrqbYFI4u1UGga1wHt/XKoev2iX+urPeg+DSyHqN92J/
	2eCJUpkIgn07/yfx4iWxScnhetgSSWlPBH27q+RaRtd6UK0hg+7or1r8sk1tFhaR9Q07LJ
	UAbKi1QEWHfIFFnLfi/eNjgkjA45/q4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TzkRKGIlc/o7rNaRSYplFXt4cJ/hxYcmoSd6y1EVT/k=;
	b=nTHj0Gv6+IcxCkuZdK9h/iEIQRi17XLgdPrh7V51tZICYs0XWXNokqVeqOt7buhl8SDjmVpGS
	2DuJLZExrPlHl727O16LKWBFuUSSOO1ijmc7KmcOFifJOOIohsSx+urM+QNf0ZR/4DzokFwYgSw
	v+g1wZuqAker4THd971VXEM=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4cwFZ82bMFzmV6g;
	Mon, 27 Oct 2025 22:02:24 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 1654F1402C6;
	Mon, 27 Oct 2025 22:02:52 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 27 Oct
 2025 22:02:51 +0800
From: Zhang Qilong <zhangqilong3@huawei.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<jannh@google.com>, <pfalcato@suse.de>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
Subject: [RFC PATCH 0/3] mm: PTEs batch optimization in mincore and mremap
Date: Mon, 27 Oct 2025 22:03:12 +0800
Message-ID: <20251027140315.907864-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspam-User: 
X-Stat-Signature: y8n55zfan4finawpd8rzotd7f9jh93ur
X-Rspamd-Queue-Id: D672F40023
X-Rspamd-Server: rspam09
X-HE-Tag: 1761573778-858895
X-HE-Meta: U2FsdGVkX1+cV9fgxOdN4bxtzCN4fi5ZRSx1oyN8Zn8qa31RrSEYr1DMofVwOCehTqsy2twZnJAptRCsYbBJwWVFLYTVL5ChEYuRapx1v1Btde5zANHjMv4GY5b95K6+BI6HokB2wxbLCeEy8Z43FAeVnTUHWBs4DyN7Tzi9rhhM+H5zzLbaH4wUga2XatCWpbhhKDm5wJAnGwYAFZ3/9NJukLbDAX2d7AGtmJEEWY8/olXTzntvH06VQIaxCLyFSQxSAE4uAVPQlxsQhLetloHIR4G6/vP45d8+CD3ibAteY6+baHAuyYiGmL8vdPvojeRBWkNAvR32AGtl6qkzzvSmhRy4aUqeQHedkhReIX4IQZC+1ff1pGNq/nEJZixA1cV+d4N2PThfI1ZpTge6t1gzaPqtSuBh58n4PPokV8l0Z9GO79QQpTCHfTRJ5k9hldr8KVsIXLceaEsWH1dRJ10acwDVxBWLbr03xDHlrACf6G8L14AoEAXlPpzWF9ALfOXsDf225FV2gmKErHxJOdW6qrxJTprEd5meU7gy8o1Z974hU68g2GTkpARSMJVpIwSDRy/JNjUTXwyhhLj0DSZPFacD+/MiUNt3QwwDYEwUDrZ6pZTu44JXcrolsV1mZthEM/J2ONPFAzKyGLI9uN4+a7GSdMJkCIPXbeI1meq8LWd/6sr7G2qsIMK2CPHSn6SX8dLTsfnZ6nzSO9dGtEZzvLMWhyJN4TuDXlD5H0tI4w9+3WL7HyeWYMOY8xLGRwk2jVIya4riUe+XxuMsd1Id4entvdVc7hN9w2vxLpkm9VE45s3BM3j6+4hXMwHOWv0HIasSOEsEKmT6KINW52OTSWIiLdSEeejB2IfJyvVTgMIyNJdsBvnvRY8mvmpqlwL8PnTXgCtUATKzZrg67zxkyCAQia70l/L9S54/pYeAqzOztYzhD+oeQQyJssWhuKzCKepmpRBEwoL2IYx
 T4Cupv4O
 T6PBW+fZ6xfx96SGevBLYoax5MA5T/8mJ3tezZenif+tPdq56oQvhxPDUmmUnlN7IHxm/yvcYmEYqiFRuzzxXub15hSoud1cX3cr+te01LQqlCGBAz8Vo5SD9knmPz/M6XyQhvwTOpI95cUEuiiGLWfmK3ECjk0aDvPi0WdkBp9QBSeFPcEImZ7dw/G008hL3PaKi7l8FmwiX4AMg5jIcbXZEmunYlQXtTxQZ7VolGduuychU2V+EczBC+ZCcwRcXN6NfZO7eMBf8YEs1jTk9XR7MxTfmv/F3/H/D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This first patch extract a new interface named can_pte_batch_count()
from folio_pte_batch_flags() for pte batch. Thew new interface avoids
folio access, and counts more pte, not just limited to entries mapped
within a single folio. Caller need pass a range within a single VMA
and a single page and it detect consecutive (present) PTEs that map
consecutive pages. The 2th and 3rd patches use can_pte_batch_count()
do pte batch.

Zhang Qilong (3):
  mm: Introduce can_pte_batch_count() for PTEs batch optimization.
  mm/mincore: Use can_pte_batch_count() in mincore_pte_range() for pte
    batch mincore_pte_range()
  mm/mremap: Use can_pte_batch_count() instead of folio_pte_batch() for
    pte batch

 mm/internal.h | 76 +++++++++++++++++++++++++++++++++++++++------------
 mm/mincore.c  | 10 ++-----
 mm/mremap.c   | 16 ++---------
 3 files changed, 64 insertions(+), 38 deletions(-)

-- 
2.43.0


