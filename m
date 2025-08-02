Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8053C87FC9
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 07:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BFF46B007B; Sat,  2 Aug 2025 03:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270F76B0089; Sat,  2 Aug 2025 03:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187146B008A; Sat,  2 Aug 2025 03:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BFFD6B007B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 03:31:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97EEF1357B7
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:36 +0000 (UTC)
X-FDA: 83730997392.04.41A08A6
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf19.hostedemail.com (Postfix) with ESMTP id 243A91A0006
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754119895; a=rsa-sha256;
	cv=none;
	b=dZvJwM29b2i2r0OMdjFfybTYewBpTQfsdhnFKxvp1UedpzlwDH26gUUY86Vj0gbh7MTgH7
	ShOPgk3vw0cFzUAxuEgPFs9KcGjaOMu/gD7LJi5DNUrWOMM9AomOYFRoHpTRY4wtAHUl62
	1Uup8cgdjPErPxuVGeNe9vKZX4IuX0o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754119895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=AnaE9sQEig5lG9bwzasHEHHBVI7lGQNLSykozA5QoP4=;
	b=Mey8xd3xrQHEBhYRlUG3WJieB8LaI3t9MP67ScIEkYsRY9aCAD5F+s/+m1lB1s4Z1BoEec
	smXAVg7HHdJGcBFFCnwn02VRskqT/45dVy1Omc+rFoUiax9kF5R95mOA56tXuOgZFFMnhI
	baNgb8zPzodpBkpw5tSUWvOD50DMyk4=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bvDw00ZwJz2TStf;
	Sat,  2 Aug 2025 15:29:04 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 1CBD714022D;
	Sat,  2 Aug 2025 15:31:30 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 2 Aug 2025 15:31:29 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>
CC: <linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 0/7] mm: hugetlb: cleanup and allocate frozen hugetlb folio 
Date: Sat, 2 Aug 2025 15:31:00 +0800
Message-ID: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 243A91A0006
X-Stat-Signature: 35tz13rs5ahmndoa1y8zhbthm3tsjrk7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754119893-225718
X-HE-Meta: U2FsdGVkX19nwC2SlEoP5nlbCzsNBM/zvrPrP2Uomxk+pvFEFK9MsK3DdxGlhPsLCgqi90eiGNHMiZ247lAytCAIdqPxGdZGVu1lWJFoMy2pmF5XUR6/MVzL5dlXthGDVmgJdhCU7YnwQ6evyE1W/pOctgKnJDbsVSSoZFxDcrkhAIsCfhyPJIv93uywXpHVSXNYhtmRQrlXo6Vm63oCtCMyVUKoqx9zevl2e5Ioiwhh9ByjLOfzjHRvWdHZWCtkoPvHIktKBWmiAx/AFzj8i0lDgHZulBt4ALLMB86bCv/c0vqOqwJFMZd9iZ7CkxQNKS/7kIogDpXJKUNCsVqNozMdLG4tkNHytFYfgUF6lVvM5YD4NwwBO4+N9uZnME1fs2t953HueiP7z0Dh8BsONvIFz3JgjB/fRgg7QorE/HyFEGEtJQYTBKiMpEbPkA+HXwT4DFKE7La0+Hx+tby93NQXzN1dE8iksAv4hVKUW16X7d0rpMsdapok8+cNvhNPCqIvNbpfZgK0PZNkrpa+oTcEZwr/uDeN+hYT7VjAQ/VJpGKHisBbk7Sk861DBw1ul+kJa8fO5DFwjoMwtvnH89Ulbk6vAo3m57EmdhtG9x3jZ7fSvqYh36lZKwaKaIIO7XeeBy8zp7bxVAJFchd395hTPKOvsLr+2408jRx88oeWpE0ft6zsuS4gE8LFuXG7w3X4mc6LCu493UN6qr8HFB0Lui5oWH8PuamxoP6Eg/BI8Ek7wArRn6xk5pc2EdPr/PS02PfRkeQDigpClYwm29zrG89J+J1Vfa0u4uADYNMaPoxyqAp3DTg77ONAm8YSNS0KE0rRh4AFzDwITjlRVgFviEpo9MGuOTsKyjxmZGVjdxScsSh6ljjQSQ0iJa1OASkpZzMv63eoCz6XV3cG20OrfDfilwcFSYX64j7VdT4UXrkwV0+RXdU540nWRCPOF7S8oo16uGr06w7IC6w
 cZDchBnt
 OPjx/2DYFGNcZ5V3I6f+WTwai8OZbWK0tw+JUa8/Z3WCWwDmB+GLrZu9VD/OuqcL1imxSlAMKCY+gXUccPxBBC2k5RPYMTTOckIwvJZ9wyjxMtQLWyB9zG5jGkbbS6xlBWmeao9xoOqiTCQyqq/K9mQk4+ne+k/PNF8+cKY8XYapgWRM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first six patches cleanup some hugetlb folio allocation and the
last patch convert to allocate frozen folio in gigantic folio, similar
to alloc_buddy_hugetlb_folio().

Kefeng Wang (7):
  mm: hugetlb: convert to alloc_fresh_hugetlb_hvo_folio()
  mm: hugetlb: convert to prep_account_new_hugetlb_folio()
  mm; hugetlb: simpify alloc_buddy_hugetlb_folio()
  mm: hugetlb: directly pass order when allocate a hugetlb folio
  mm: hugetlb: remove struct hstate from init_new_hugetlb_folio()
  mm: hugeltb: check NUMA_NO_NODE in only_alloc_fresh_hugetlb_folio()
  mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()

 include/linux/cma.h |  20 -----
 include/linux/gfp.h |  23 ------
 mm/cma.c            |   4 +-
 mm/hugetlb.c        | 182 +++++++++++++++++---------------------------
 mm/hugetlb_cma.c    |  13 ++--
 mm/hugetlb_cma.h    |  10 +--
 mm/internal.h       |  37 +++++++++
 mm/page_alloc.c     |   8 +-
 8 files changed, 124 insertions(+), 173 deletions(-)

-- 
2.27.0


