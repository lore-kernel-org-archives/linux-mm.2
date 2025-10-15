Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CDD7CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452508E0006; Wed, 15 Oct 2025 08:35:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402FF8E0002; Wed, 15 Oct 2025 08:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318E38E0006; Wed, 15 Oct 2025 08:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2F98E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:35:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6729B654E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:35:29 +0000 (UTC)
X-FDA: 84000294378.10.E44D9CF
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf16.hostedemail.com (Postfix) with ESMTP id 43C4B18000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:35:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4kqEpyg4;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760531728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hiJjvwcOJRLVURQTkGMxRwAeKlpAlhKvAvkgM3BUU+Q=;
	b=zfxWkJq3B8trNHay6LENuTPnoGbBQliK3AZjuNye5kOshUL6OZxcEsRqfYXFIu0au5E2bJ
	t7hv2knpvZHiyjrRB/w5Yscp1EOepntTfnKZ6dPQuLa2jZmfAH4xQzFFnxUiYOCyVnmM4l
	j5pKgJKyeVrzFX/yMtcOB/xBc/fS8NY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4kqEpyg4;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760531728; a=rsa-sha256;
	cv=none;
	b=r87rRg3IRcMVof87bUoGY3wcmBgSHQbBRZmwwj1DUFOccI6Xz1FQ0sEHbpRvDItJpYKuoM
	m2nn6A91r76IivJRkhaThmiDmx0vtYYt1SiEbTqkhj9xlqGlj4sXrs6CTGOW0MAiyY9AiE
	0ZxkvuaBVI8HP3CMZHdg5ZVokZyIV/M=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hiJjvwcOJRLVURQTkGMxRwAeKlpAlhKvAvkgM3BUU+Q=;
	b=4kqEpyg4EqyGa2WDBYK/pFbzfelNLmbD9ISOk6l5dnYzS4z2yf0lANnvbzuYdnboB/lrCqSAi
	x1F/lGUe8SLyCrv5p6Uy1pub9VT4gPLJYdpafiP39HTYaU+dQT10u0N+o/QsjCm3rWkSXnzEfOq
	UmOn98j4ckGtd6iQdWjL0EQ=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4cmrBt3cYQz1cyQv;
	Wed, 15 Oct 2025 20:35:02 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id D3EEA1400CA;
	Wed, 15 Oct 2025 20:35:22 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Oct 2025 20:35:22 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v3 0/3] mm: some optimizations for prot numa
Date: Wed, 15 Oct 2025 20:35:13 +0800
Message-ID: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 43C4B18000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: j3tok6wrqhzn1g7b3rab4gispudfcor8
X-HE-Tag: 1760531726-630969
X-HE-Meta: U2FsdGVkX18WUWKJkxtYyYDnNh1xZPWBATaiaWwJv6Rq+BykOFwTfAzRvTPdPylyWVoKKVzZRJlN1YwG1eZ17NI8yZnN3J0Xvxa2W/EkuT9FvCpgTX3vhigqTAa3VOJaFvOgJavQf/p/qNp7BZRZBeyIgr4OVBMmCfNdh5SpxUUF+8Zsv+FkLp9HLtJt7AYf0YEVSz8dwZnXuPhNuEIlgYTcIh5Y0PPZ0lddN//edPNt9oMvsdW4+4tfwcKt08ktMqcCzC4knyfoCbSz6cENNXrgMw609lXRLqAZNCJC23TDAcsK/BxBnzzG09Zs4eMquS2llO1lFxzJix6lU3c+Fe/7S1leYrbZvJiPir8dBI7g2y+K/jZgSm1+5msOxdLRgqZOwSkyvXT06Oo16hgVxWSHDBgscM6TqWdhKTwNqXMplpyuuUUdeC/PinBvitGe0yJe+oISyS3OJ1sP3XieilmsJomtKIs2YQiKvuJMkFkQeJxSpY9ICfq8XZkcLA5winrArOFKFd4li5bJMWjWtEuwuzyJIZch8ve9QUDn8o4pZS5fLdJf1wdBeEJ1J663d0XqVCKit3Yw5YuOEPYu5qQ1sTGo6mY2fxaU3GMeLeP3wKkQJrfdMEokC4lGDHm7prb9aFEpWJQe1y2PWKe3irQKREKvoeBYk/YruIp3qlyRCMk5fPzI/lrMNNg7hsUUpSlbX5y1phi1Cc45NmAxzYaZGXWlGSQKw3eMEOYRuscTdSX/Q8VlCFcrS2A5d9ygEi7A8xnjDQ2BKFB80xzje5WnIQRwE1hoqbDKyd5bXzfPAJX6+NcWhWCRjH/fuyqzqA4orZoQYKWkmAtdWeCHiSpZUaNACJv4RrXfOfNcpghBnHEYpWmCBYh5VHtIYKbOH3mf22RZEhfc2dtt34UM+RgAV1U8v83s9vA+mJ8B60pBUbVuRcD6hqv3g0/5qRoh/jEI9fNc14JLe7eXXtw
 72CmBqNJ
 qnja/EGxr+IOLQkw+2jXYNrhYXJYWgcElc3+AAqxjwUjMhedaSgqNuGNzUIi+6jqKyKE3pr5hN8TGfTlOekd+EWROmhmNGios7z/HrvjqhWIaqZ2OfPnB1l2FjIrS8MkQ/9+4PqpDHCgSTTBiri067Sao2owuwouFbc02HmoBAIVFzLlI5nvA4qwf0zdMjdtXjIJVmE57ODWF+2Dm9V2FvVlm6HLmkJaVi5FSm4iLRf/Ut1dCFudJkNCYz2/lUXVCG+NTuUDrTG2jupmytMi6XRTac31bulXp9Veo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v3:
- use "&&" instead of "&" in patch2
- rename folio_skip_prot_numa() to folio_needs_prot_numa()
  and add kerneldoc
- add RB

v2:
- update comments for pte_protnone() in patch2
- rename prot_numa_skip() to folio_skip_prot_numa() and
  cleanup it a bit
- add RB/ACK


Kefeng Wang (3):
  mm: mprotect: always skip dma pinned folio in prot_numa_skip()
  mm: mprotect: avoid unnecessary struct page accessing if
    pte_protnone()
  mm: huge_memory: use folio_needs_prot_numa() for pmd folio

 mm/huge_memory.c | 21 +++++---------
 mm/internal.h    |  2 ++
 mm/mprotect.c    | 72 ++++++++++++++++++++++++------------------------
 3 files changed, 45 insertions(+), 50 deletions(-)

-- 
2.27.0


