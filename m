Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84405C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BF966B00B2; Thu,  9 Jul 2026 14:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9970E6B00B4; Thu,  9 Jul 2026 14:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5236B00B5; Thu,  9 Jul 2026 14:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6346B00B2
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:48:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB74FC138A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:48:13 +0000 (UTC)
X-FDA: 84970123266.05.D12A218
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9649B140009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:48:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BRu1AQYd;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783622892;
	b=wAfWG6ypxizbw/ZCTS2cWbvr6uLt8gryavgkOIwUmMVrELCKkW6bb3QFSZ7ZvVV2SIiRQY
	bCAIrhgLg2lbesFtcD2blC2vDDcp5JKHB1cLtBuikgthMEHl2v1VY4s0KfmxKxlZddktD9
	zeWCCohYcvzzDlLX3uX5TVC1U573I+k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BRu1AQYd;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783622892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6DkfM0ynaDTwpMKXO2jTjsFjcq8c046BhsnBelGIuf8=;
	b=ZR82WMhoBzb+H2hMVOMQP+KxiM2hFV7RMj5EOJzm+KV0b26u6wY5AdqeHaTH4WnYo2zgt7
	uh+9l2zl+1fi5c2qihQ5Wu+t01xvdxmoX8VQP1cDEfhyjBLNJK2C4hTjiwtHXeeOKBtAOP
	DJEsB/FxHF8OcRZeufcwuuKzECYzMzg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=6DkfM0ynaDTwpMKXO2jTjsFjcq8c046BhsnBelGIuf8=; b=BRu1AQYdLlfhUAtc4vKYCvLVJp
	Rj0eZ2FVn9YbIqQUDCQFd1O9FjxTcQ/UcUG5PsFMZ+d630tg2ROSE6CfBs/Au5ctjnlmHw4QuhHQ1
	hgzVNcr9L/lqtgzlIUB7b7hZCI7r8s9V1Il8nps+xV1FkzI4I/sa8IRAxBcB7Bm/DH5KgRaJiG9Eq
	nGD8efn30vfM/eqoyre+tfKvSKCfmcwiM0aIIxDjzecUhWds23MoXd2DyKVx9Cw7Z1QRkQ+qDMZvh
	1qh1OSs2CU5sS1w4JRbTh+SuXLM/tksILwxQCT2aVQkoD0RYu/BAShdoMclsYdmEIYb0RDz+A8bdY
	xpf34lMA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whtmg-00000005Oh9-0kjm;
	Thu, 09 Jul 2026 18:47:42 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: [PATCH v2 00/10] Use generic_file_read_iter() in hugetlbfs
Date: Thu,  9 Jul 2026 19:47:28 +0100
Message-ID: <20260709184740.1286561-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9649B140009
X-Rspam-User: 
X-Stat-Signature: cp7woukzpbytohiyaxcim3gfrx1cbph1
X-Rspamd-Server: rspam03
X-HE-Tag: 1783622892-256739
X-HE-Meta: U2FsdGVkX18k2oGlwIBmPNdXRNjuRieyrdv5B++WPP5So+ygFIRAdSQgi+FlC38opYWd1GobTu2iUeTQX6VjiMW4/bgn7WNEkysWXqTNfEUVxWGrPPUMwaf/DrjycjZITyadi2Kxacp4xX1WPaWVbIZ7veVpIkTms/L9v1gbgrFFVDUaaZAtYUVfPCMCG4wrqKy5PXV+nvK6/DSHuGY0/WAPm5t9ObCVMaIGvDOcMJbQ/LMhKDHbPs3HQtsszPdkL6yApvMIMzxOXBgBDpHtx13CZzQ2wyvG9XXlYaQKeaSapsVAQmZtHN2ojnXgKG1NUn2vSVrW3VoI57/f9EUSGx0EAsczEswIKvbmRYYVMbTphRQrSPYPDQi3hVQcIu91HZdKmbKYmpUsB95AJUL+kHnk50K7h3SaW6xs7KrKt085/ly43NdPpoOM5EWn638qPWuFxSDKyj7kN1x4qGu8eiHnv9B3QLpzDvkdN8+TfGe5lqLpayBLyEaqGRt7zz5MGlKdFwvohOh7A6I73ChulJwbgGwGJc1Qe1oJafn8G/7nFw+VO0/ka5IQeEa7PGVBpkq8p71iiILdm5I3Jbiko8XO3o9zL+zNlIEwNlAa5qtN0oLzADvppXU7A5q/mNdClyBjeNhQsjCVtVI3K6P+z1E70HXVax1PcLP/Oex99ElEyGA6VHBRjq8kJcGUN/BpIvSCNu6JTTh2C5xkN4p7K2n6pfbv/G5fXIEkqKR0aRiOLnfKUaxFWzE2+yn17IeQVUWaL0fXYCZBDQpfst9qHUFQV2cI/oNCLUADwZB2j0D6bqTozTJTgjJJFomAepL4v5nzyDYv5XnA2qfn/LAG/VafCpirqKD1xzshjT8ViH7N1VUXpnEvEcn1QyFwY+CjjzQnk9vWIqtpkkqblTK1aAWbR8ondUOcegDAFqwPf6/aVvqGeNLuPvulWliid4VImt7uB5CJQMFk0krxW0X
 DMVnnRBI
 hrq5TNu+QPy11JIxUYtQdeXvSJ/FnKO37Ex1T83Mow5UN7Wq4c54K2z5tdPY+IuXFnQP+f6iXr86RQGaSRHkBrr7H9BH6IM7Io1rseAT1uxdG6qxcEGjAxdwQh/T8iKRVwsxLtV1mninudmmBEHJadR+kDykzLfsLxeKVhEZdPmsNHhVN930V4mf9BL9wBiL1goT0aDWCg4W6HCvw2udpcr3xpVsddYUdyBZnnD0dgH0yPj53WmGI62f72yAvsQGQBI7hPfJaR1qtLtpwkKX9hZN46aCtZNfaLpn7bUvaZZMBnZwA1VlzTEHPU4OEPw8nUzUU8ZwVqT5ZHH3EuKo8ah81ykWhBKIUx+DhSneopgISXk6uSCPA293LEk2UixeadJt8b4znQsU2nZvET16HpGh9AsDNGyut4rAPOm6fZkJYG7fSrc9m/+CMmcdMANISEyij
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This set of patches are separated out from Jane's earlier series.
https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/

There's enough potentially controversial things in here that I think
it's worth considering them by themselves.  First, handling hwpoison
in filemap_read().  I want this for shmem as well as for hugetlbfs (a
later patchset, maybe).  Second, handling misses in the pagecache as
holes rather than opportunities to populate the pagecache.

v1 here: https://lore.kernel.org/linux-mm/20260707181713.208282-1-willy@infradead.org/
Sashiko had a lot of valuable feedback on that, and that's all addressed
here except for the things that I don't think are relevant.

Jane Chu (2):
  filemap: Add hwpoison handling to filemap_read()
  hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()

Matthew Wilcox (Oracle) (8):
  mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
  hugetlb: Mark some function arguments as const
  filemap: Remove checks in mapping_set_folio_order_range()
  hugetlb: Set mapping folio order
  memory-failure: Remove raw_hwp_list_head()
  memory-failure: Prevent UAF in raw_hwp_page list
  mm: Handle hugetlb correctly in is_page_hwpoison()
  filemap: Add support for authoritative mappings

 fs/hugetlbfs/inode.c       | 122 ++++---------------------------------
 include/linux/hugetlb.h    |  24 +++-----
 include/linux/mm_types.h   |   4 +-
 include/linux/page-flags.h |  28 ++++++---
 include/linux/pagemap.h    |  32 +++++-----
 mm/filemap.c               |  46 +++++++++++++-
 mm/huge_memory.c           |   2 +-
 mm/hugetlb.c               |   2 +-
 mm/memory-failure.c        |  39 ++++++------
 mm/memory_hotplug.c        |   2 +-
 mm/shmem.c                 |   2 +-
 mm/vmscan.c                |   2 +-
 12 files changed, 128 insertions(+), 177 deletions(-)

-- 
2.47.3


