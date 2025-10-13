Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFA4CCCD18C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7D388E0007; Mon, 13 Oct 2025 08:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A024B8E0039; Mon, 13 Oct 2025 08:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807148E0007; Mon, 13 Oct 2025 08:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65AAB8E0037
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:21:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9BB113AE03
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:21:28 +0000 (UTC)
X-FDA: 83993001456.23.C5A1FCC
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1BD8720014
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:21:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5eImwTrr;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760358087; a=rsa-sha256;
	cv=none;
	b=C0+4y5Nqv+Z0vmuIxmkQ7KiE4hnNtb9zAb6WfBLYLNOP+Q3wKtt8Kzx26s2K1hNP6cuVro
	tP4A5kv5pN0rFDg0SV7hDxPq767TeC3TGNn72NnnKB/i0frMGEiI3RbhmvJRivNSAeugpv
	DUFi2lSaHCqQ0I91YetMzsdcA36Ye+c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5eImwTrr;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760358087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TJlv/4/7jmB8PzhGWai86ziGmjrO+epuQAnqHqDz9uU=;
	b=E3+P27dXSZGrZFWRcEbIGmmXC4Fqkb3/IUf90d+QilOfKw4uRZ1JuiZ/J+7TviwkfXsEiu
	znElsvOIB9lHa1KnhK0cgZyyL1cM03xsJ4b9niMpa8WagYyFzwETqBkRtM6JMtDm2WdXQr
	67zWA0KqOOfra6d8p7F5Qt8Lci9velo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TJlv/4/7jmB8PzhGWai86ziGmjrO+epuQAnqHqDz9uU=;
	b=5eImwTrr0Idb+V1xP+rym8FNkw3+kSmojV2Lvb/5oQo+mFfq9EMdIHIs/TaS27zeBsSeHQyVT
	tpzubP05rQvgELgqCC4iZNNa8paEATNpuzWUYHZyyQ/ZuqTSO91PD7Op7KpdU3zJj+qrUXuQc0+
	IWCa3AMKKeXDAGSLSlCe3Dw=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4clbzd0jlzzLlVL;
	Mon, 13 Oct 2025 20:21:01 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 4234D140142;
	Mon, 13 Oct 2025 20:21:20 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Oct 2025 20:21:19 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 0/3] mm: some optimizations for prot numa
Date: Mon, 13 Oct 2025 20:15:33 +0800
Message-ID: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: d14wjjs1emug1poy8tu3k8ujn3dqnc35
X-Rspamd-Queue-Id: 1BD8720014
X-Rspamd-Server: rspam09
X-HE-Tag: 1760358085-216089
X-HE-Meta: U2FsdGVkX1+lblpyqCNDcJ9kl07jcRjKxi82jkRZQyIO3pZswlVePiWXJ3qT5FyF9tVLA7cB4ON5XOiMxjaZ4fv0ovUbPbfjvrEhk8FA4APbjql7gg62EVqEKqhyJUGaaZs4pMCqP9SZCNKHVFZK44sT44GNvOWpPNwSYlNa/IcS+YWaSHw1ZkjsfLmXAcT1AoKe1Q4OyrMNRP0yQcT4OaAaR0mKGNr3+XBaeuSuSA1QPCnN80h/M95SPmaESzyawoLVaUi9U2Gt+qR4dN/iWZenZ2gGBBPT5VuKhyfhM9nkN7edKp2ZzXEwAeGUiWe/l42euB6yyfcvkADghN/nGjsOjzn2GD4q9ktQh0UvikVWvUTdktjrNkqQQzepb9K5d5SWjcITXn/F2GiWC/nBWP2JEeQuH4r9SUUPaFC5xEQ5ZdJTgitR9ZbI3A8rEco2t+XK9EcoLbvsWNAGat8STkmn3Nue19gsq6Saq27eaH17cvcSpSrhSnewg2tjDtckYTJ4Mme9jBIWdMpev9FrNdHEhJpSO4A6IffX8sdpTX2cL8eRNI1w4aReOkodCDKOy7MbDxzc8rGDlAXFmn/oYdpScwpunv3Ae2Bs19XEF1JA87SnSVk4iRJETKYCnSJJrSpC8+PUBAlFWAYwnj1ZU8eqgJcFFbNTu3jrnT1dmHu1jQF79fBSRjhknw+giVljicwdvSj6BUJuzmhasVYTfmPPhKyA1KA2Cy17RoDoQqdJ32YHvktK4yPhg1+cRX0r829tXjENnqz+1xayXMusQiWRzRe8Vemeq+jUezTn6deLYeCRqVcjB6M7iqmFTY80G7ODmoow8U0gSx8sC/jEeuAbE5M0Gt9nwRFd7jAMtn8qx0P76DJyenAtCI5XdEqPJGkuBGlagTPnO/WssoubtgyTF9t7lRPm4oCGKqqBelyT5kJ8l3ppcvNWzBmwc+/F4kL2dbfH5EkTk7151lK
 ahuyQbVs
 iWAb3Vxt86NJ+DuVK4UbnAusiQ/LAFapEo1C5oNZqhyGxWTOlyGdCEx4I8aV+YMGfNqZNrFp07ycis+3B5q8Fz4aEszM2bP1ZXggHSEfWO3Q4YrRYX0WzuQsHuCKbgbNAQvA40R8E5NKF0EQLpf0EwNzu3+lzqWX5sp2+bmkZbdTeyfUJUmNSj+9Ts+xQvynVXp/lXSuWB1tF2OXG/9aaNXVuR59tz/tGSBp1vKfz9bLY44Q2Ft5F4z8WYvnRcV27W3sw2R8ERbY81fRV+5YZR6EIfmQaMBrhsQ7i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kefeng Wang (3):
  mm: mprotect: always skip dma pinned folio in prot_numa_skip()
  mm: mprotect: avoid unnecessary struct page accessing if
    pte_protnone()
  mm: huge_memory: use prot_numa_skip() for pmd folio

 mm/huge_memory.c | 21 +++++++--------------
 mm/internal.h    |  2 ++
 mm/mprotect.c    | 30 +++++++++++++++++-------------
 3 files changed, 26 insertions(+), 27 deletions(-)

-- 
2.43.0


