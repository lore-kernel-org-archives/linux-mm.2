Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E80CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80FBC8E0011; Thu, 23 Oct 2025 07:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C03E8E0016; Thu, 23 Oct 2025 07:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FDFB8E0011; Thu, 23 Oct 2025 07:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FD498E0014
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:42:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A353C0AF6
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:42:36 +0000 (UTC)
X-FDA: 84029191512.30.5FB584B
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf07.hostedemail.com (Postfix) with ESMTP id DE0FF4000C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:42:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761219754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=NhnQnYAfSfbm5MRq2tRIxdEVAoikqJk+V2mZCxLyu+E=;
	b=AflewLJ5nzNdCUIKPwPo3kxkHsjwu+Gg/2j4M8PSyXoAtut6N/9WvTN/hc9IWHAuClolZm
	eQZ7TYxBjVqSdwIOPlQYNulyFiMmFMLturoAv4bS9VzHOCyz7m5qrOxbPthna9YGG3wuP8
	wNPbu4zIS4e09ckkTPp4GnataBR/DuQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761219754; a=rsa-sha256;
	cv=none;
	b=bnCDl56DHvNRQNu/eVl65uQKYLfEbvn3rzW5mQ5B8ND7+q+/3l3Ogl3Aaq6i1CpKcTwzQZ
	j4fV1Kjkk6nL/6vFRxS/VGg9fDSBy57yrvcPEZVmBFoa/9dmX1o8yJlFRNmRAWy4nyYk4m
	NrlUPs6yrDV/BQaSVPbFWiEw9+/LvKU=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cskdw0c89zvX4b;
	Thu, 23 Oct 2025 19:41:56 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id DFBBC18006C;
	Thu, 23 Oct 2025 19:42:28 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 19:42:28 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v5 0/4] mm: some optimizations for prot numa
Date: Thu, 23 Oct 2025 19:37:33 +0800
Message-ID: <20251023113737.3572790-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE0FF4000C
X-Stat-Signature: u6mw66oujdijztwoixhjfiw6xad1mfwb
X-Rspam-User: 
X-HE-Tag: 1761219753-915327
X-HE-Meta: U2FsdGVkX19pBKPQI5n+1TBK2ye2ks40LLBjyXRQ2e6t99i8xocEnGlbPTwrVlfLv+KRcImdKUthBkg91/FFA4iExQLR4tY+gws/nW2fZ/+Cnlya/nvvnbPNpquOZF6MekyIDL4+YDD12g3u49i5u/8vFBzRsSnLsyJwl0L9Nwc9CKbbJNiqoOvmndbIB9R4w1AIHwEpOrTZdxQIS2Y/WtYSR39xl+fWwAiZ90uLg53pFa5dgDcpBvP4TgdCoH8KLfH9aE7Ox4+STr2WhIwVge4i+AONre9KphYWB+AqS1wvl17x+T2eBK/BnlOL+AWKx9GDNFG1NlfM1ASrHmIhQYB/WAOGSDihIBHHYJeus6lf3/O1mrQg/2QfDVlnbcIB6N9GEKBp2a+R7stidLF9D+2Bh99+u1bNanDGsWRtyMxbkX8CWTS8LMoWjG2KzQNEq3zrfXd8aJvpZirr4j4SOfdOsqS6TpSFgRSEUJpOi6a/KMbQX+N2TSDMkhqroXFtgsmirGYWmiRWm7CfbbQlb18/57FVS5mTV2kfydaa1t1Q0QzSROkEQK9SHynb0tU0wO/KfhhTP9/xpEBBcdCoEi55UGFdxl3QdlOtTz2cuATj4TlHAAumsmK8eJOxWb1NLO85LC0EcUQUZYoq6FmI+jdVUy6RHKPBmtbmes6P0Zs8OzNK11WsA6XoTRDoa0HYUYdk7IO3HkauWmynN12DA3su0qE8Useu27OiipoHOCysaFwMwAhBSjzfZGc0nTks17/R1itON8R+TzURiiBTjg9gvIq4TFXJjUgH88BUo5fs+FLQE4GmS7/bXR9oy6YMNi8bHZxSvWS6MXt63MmGbJHDh2QOsFe7Yit5GLj5WjoijJIhlVNW+u+ZvIsQwroU0GlIJjAH05ING0SgsVUy80zru7up7bugmNQ9DMa4oyDYPA+fxrIvW51IUjm7qUWeBEOJcQhcRckReuTTdPv
 qHQLyJTz
 EsMn4BLL7JyJ4GBln0ad1dFBtWEdoV4HyiKYOagkZxpOmE3IvJgU9E2B+XgWyJcrK5jIqqha7MmIoxvc6jW6VBnQJUU+B8c9i9Fme42V9Ws1DAnL23KXTiBTmZSUB4n/1W8LUgHweZ/KEtitFpEjTLe+Tr8zs3nciXJhk3AMpQbBnnTA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v5:
- add vma_is_single_threaded_private() to remove code duplication,
  per Lorenzo
- rename folio_needs_prot_numa() to folio_can_map_prot_numa(), and
  move it into mempolicy.c, also update kerneldoc, per Lorenzo
- correct the changelog of patch4, per David
- collect ACK/RB

v4:
- update changelog for all patches, per Lorenzo, David
- split the rename/refactor into a new patch, per Lorenzo
- collect ACK/RB

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

Kefeng Wang (4):
  mm: mprotect: always skip dma pinned folio in prot_numa_skip()
  mm: mprotect: avoid unnecessary struct page accessing if
    pte_protnone()
  mm: mprotect: convert to folio_can_map_prot_numa()
  mm: huge_memory: use folio_can_map_prot_numa() for pmd folio

 mm/huge_memory.c | 17 ++--------
 mm/internal.h    | 20 +++++++++++
 mm/mempolicy.c   | 61 +++++++++++++++++++++++++++++++++
 mm/mprotect.c    | 87 +++++++++---------------------------------------
 4 files changed, 99 insertions(+), 86 deletions(-)

-- 
2.27.0


