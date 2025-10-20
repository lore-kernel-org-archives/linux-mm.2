Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB14CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 06:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83648E0005; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8648E0003; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8668E0006; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 599B48E0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 092E0BAE94
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:20:10 +0000 (UTC)
X-FDA: 84017492580.03.A3F68D6
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf22.hostedemail.com (Postfix) with ESMTP id D9349C0006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:20:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=F6c7Z28c;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760941208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2XZFVslpyAEbKAhaCWtTAlwRVtVsiaOJqfezOV1TElM=;
	b=k9bmFFrFNjGV0JjUZ/RqitqPBMUohuq83LB/U2ED+YbjL7g4NO64sZajw/DQM4FZ7X3p57
	Dxn4ysUcA6SyzZ+NewVX5uo+WCADURlIINpVCJFgTSEB6AezkOTDuoWedHeRNlFK5HV9xd
	EYqVd3EDOdn0zE5DE7sUipE5DnVQQPM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760941208; a=rsa-sha256;
	cv=none;
	b=cMgheTcHGnzxl1S5yRxEke2WoQnMP0n7yjruvsBNvwPVL43N6GEWyjjZRTymPujxxvF4dD
	CGsLM/h3iQnSmh64bCYeEGyUHUK6baIJkpf7eU6F45cJDa9Wr3S7gWGzZaW0nas9jQnEfG
	T/SnjkSSjCX6awA5areTuNRajWWclmM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=F6c7Z28c;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2XZFVslpyAEbKAhaCWtTAlwRVtVsiaOJqfezOV1TElM=;
	b=F6c7Z28cAReEOYtCOdwF+kwpZ7Ekm5yZh4UwMUycpkwBAkzaVOwVAgLLEZyHi9LMFXhpGaxvN
	B7C3MclatDMLioEIBzZT2rhEzHyOhC+h/A0dJzbzvppauCTbKnyAePOdQqYOCMvtOJlRXkiyjTz
	VyqNgpRGR2uB0uw7Wn+7c5g=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4cqlcd6VqkzpT0D;
	Mon, 20 Oct 2025 14:18:57 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id D3C92140156;
	Mon, 20 Oct 2025 14:20:00 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Oct 2025 14:20:00 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v4 0/4] mm: some optimizations for prot numa
Date: Mon, 20 Oct 2025 14:18:41 +0800
Message-ID: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam05
X-Stat-Signature: hsyphbhhz733zg7n7xcht95o35bb6ofj
X-Rspam-User: 
X-Rspamd-Queue-Id: D9349C0006
X-HE-Tag: 1760941207-987882
X-HE-Meta: U2FsdGVkX1/rU7MANPkQ404ins7VLev5e24suFH7JTrv294DHZDAlFfmffM1/7eyymkV34PQ6eYBEGRdng6i1xTje44PZzed0Adiy88lNndOo1+8I+01Cn7dTDX15i3ZcELeGIwh6QQiDX0jA0WrAROK7Tr4Pcft9FaBNsxwl8OkCSJWkaEy8rG5neavaoGfJoN2R9peicDevzxVptmSrH+uNHItHESbmz77IBoZDC1uAtvRE0N3mp6fe2Bna/sUd41D8BvuzksIiIsz9HTzAtwetbEmWePDyCE7DtsUw7pDQ37BbCUCzEXm/YGdz5c2+QG9LZ6FNuh/Fv9fEoedX8mdI6tWARu6O29YtYtTDvRu6QH2GqC3SIEegLd0bv3E3picKLYgLRFT6WfRBQZfC9N71wxqPaTolnFhYnrTjf8/D1t4wHGmzk+o1XdGlLYMoEu2GSbJGulcxePfF3wJ8KgZs6YGyfrxfA3IbXVauSaAMYe3jLzDZbhMMKgUz48Cs26ktjkPzn5+BlYd4VNg0hH/QV+lbPZgEtg3r2DerazVdc0Tq0VrLcsno2epxnxtRyZwJ1xnyX+JWy5u5qaCmL67fo1jxMNqRVTTmbe8ndmm8rUaTirJS871OwPWhjCH78kykTEUFGewxrJ+gLyoRxaexZFoutHU76Aycg+Shgd7zngning3E5VH/ogkMfacQSoJmylvMBq80586Fmkt0IcX9alF4IO4XWkF07yupJ20xezODRPJ8+yeIGwPmY7Sr+VWPbpsrtw3IQrKQLT8TpGrZdsOc8QzfaSGAwQptKsg6elmzcRPov1YkdfC3cCbm1gUIgVKAoqtptR6M1v53OBfXOItaP1PGk6FeWevkMnQJPHNi6d/5PgnoMORL+/pDk6S9xiDchKcQg0czUttkonrd1YM4KA/o/y51hNKoVtpbrh8fojAB7nYhbp91VKCzkzMPbCUhR4UbBS8Snu
 KAb/bIb2
 WEMYtmIN5vkrJFjo0db7umga0lXoZb83i0YPjDOxnW7B7B2Kub5gfkwln/d16A5FvaLcnZa0A8Jbjks0txhdy9OoRPBFiUvLMwO5JEY+SXdO3aNfL5opIdmuOvVDGWkgcHQ66eVF35gYucmcaivryEWLLmx9X8y8j9C6keJycj19/Ct0ttbFWRzeblZHfAxxaxXG/zwpzPKbfgpnwMLPG/T8E9qErc5/DCXVV8nbk+LVeBiYOHPKz1Y23VWXsqK5ov/eyRBjgkuR5hGaxH3uRb2yM5WuXYOBi+hCP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
  mm: mprotect: convert to folio_needs_prot_numa()
  mm: huge_memory: use folio_needs_prot_numa() for pmd folio

 mm/huge_memory.c | 22 ++++++---------
 mm/internal.h    |  3 ++
 mm/mprotect.c    | 71 ++++++++++++++++++++++++------------------------
 3 files changed, 47 insertions(+), 49 deletions(-)

-- 
2.27.0


