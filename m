Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05098CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 08:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3E76B0093; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894B46B0092; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734C96B008C; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7F76B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3C3AC1A03
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:27:46 +0000 (UTC)
X-FDA: 84888726132.10.412AE2D
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf08.hostedemail.com (Postfix) with ESMTP id E1B0116000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:27:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Du6t8X9I;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781684865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6Jc3FfHMo5wUv6AISsordZbf15xLxlvlfa02PWrjJLY=;
	b=vMt94k920kMHrjhSoap1BK68l760c/d4m3iuMF7494Bav6XEFtrcDr0Dfyd4IEUcwlmV2G
	RGzI82oEv4py4GaxxHC7gpWJuO+X9r0Mkb941Qk5U4hKWk/ZTkcQM+8+fa4Uebp2+tVfj1
	r9smORxL6g201rKgXbOAnwajBgsWp70=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Du6t8X9I;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781684865;
	b=jVixHkro4+tYyOIoLcUWegwZIoj9z4UKcCw5rTUbocWyE4IqT8qsjJd0IKAMr44Am8RUEf
	v4l67rr01qR3+sgl2PmDeDUkn6ajOh8Uu/mt0j/VQw+glx5CZLGIyD7m1L8Ff8KjDWpjPf
	CwE9/2Rg2VZzv3MX6WHKONIye9t1czw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6Jc3FfHMo5wUv6AISsordZbf15xLxlvlfa02PWrjJLY=;
	b=Du6t8X9I8loJS+VWyxfmpbmeZXtsCoQPhAmSsxDGRYW93ucqajrswqn5PFbM3xsGAjNNkz7q4
	pQjwIJt/aN90iPb4gjFfQX1M2F7DUnsNIUU9unOBfTrlNo9icyUkTLrWEgFksCyYZyO1INOuPjT
	qO/BBxP8Me26a6iYxFVCTNc=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4ggGxB1CZzz1K97S;
	Wed, 17 Jun 2026 16:19:42 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F94E40561;
	Wed, 17 Jun 2026 16:27:39 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Jun 2026 16:27:38 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 0/4] mm: convert to walk_page_range_vma() to eliminate find_vma()
Date: Wed, 17 Jun 2026 16:26:18 +0800
Message-ID: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E1B0116000B
X-Stat-Signature: ug7odq4jueoowa934qo4rq3sjoiwpkue
X-HE-Tag: 1781684863-966314
X-HE-Meta: U2FsdGVkX1+pav/68Urlklc5aWyct5qZTLyHMnGwP6SEFIE69sIWKuGmzFZkhSMHepfy38nor+91RHPfSIsCKnCJfLRsuOAsntmGMZ6tpRQDVcsCRcjJ4VUJ2Spm4bQxUV1VRNMia6BKcHXWI19rHjeV8Dpd/MRYsZH/hgOzkqMPql07AjOLeb6eqKmzrQTROGkMZqba4ymvNv9If1gdQ2Zjm0lEm5G4uNKj4rw5hYbqv5az+a7Dgg6xnSpyyPDS2V9fCSDxFidV9j77wpCne+6yOEToDQJAzh0RCVN+SarJ5N9GmIfcFAzAyhnD29ShZGkH8dRlrnjHL8vA2HEb2crFBpDAlWtcH0WWsXenzcHHSGqHb068L72MqWivo/UANMbc8XpbZYeTC+bSZdgOMZbV1QxqBATCScHFVxsoXTtpq3VeA3Iws8Kc7xnUenVO1vE2rGP5bF2d41WdbV4LjQ4cKwhrvrEi+BM5v6Bb2VyHATtmrs8sQ0T1D7H1CPBQ+joEjjboLKMFee0mlH8Il8J4mWOBjOcgqGDFz6+05gOPHuWPTYFI9r5s+y154S8i52tm9oyHySzJ7SFmPAX/42LPsf9522sPXDUG3Cq+iZGHnIhr0ac5denj1qjOBqXTnL/MrJapoCDfnVizdUD12oXuUZBoIr43/6QEAtLSFaeTaQoMUkViLsXGVUfNDx9iLMLzaT1RUC6lq1NbTMGTCaV1gYR9NzAlsDndtgueE9XNi0QKf3G2RUxW8eERLME22QPDXqprmxf9wj2fdn6/6GAIKJGHBqNe6R6c1jdfA7hgMtXIDre/OClNJD5F+Y+oQEyupr350zVqPiW8UHmnuzHo/MSGe3120ffEpmGTHcqv76oUBw2jx2OlmHbMtzy/v593jvh81Lp/fNZgFb3PWDtm/6p+oGmkbqK7gLMP5qX1McVjywuV/4bmH5QsGsHw4iTFDKir2HWgbBKEHc5
 FjhmE1pf
 0oLT5DNUOJzzaVBm/O2TwxckrWzeAQfM3dyUr0hio5to1lnfU1k97TCnrP3BFzSUGkHBTic7xYekcZ1tgf8yI8uil4nzVZd9PHynAXtTssy23R/ohjehctK3+PTpsUjWPCFskBWTOwNeRH/kVsn8I8GqnvaTdE0vH7StUvyHMetwNDZPFWGN6CEOSUjsR3X+0Tkc/gt8992hV0quSTy1pO4rE1fn2w85f61X2T5l6ReJWexxqzVgWk2JhnNTITDzpQkJ3jAyNw/vLNi3/BUukEllTSNSIwLftkx3mhaPBUjmhxCPfmBP8zrhLgkBS72beupfK8QnQeO8YLWz+E6GWirFgrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

walk_page_range() performs a find_vma() lookup on each page table walk.
For callers that already hold a valid VMA and operate on a known
single-VMA range, this lookup is redundant. Replace walk_page_range()
with walk_page_range_vma() where the caller guarantees single-VMA
semantics.

For mincore, walk_page_range_vma() skips walk_page_test() which
normally handles VM_PFNMAP via ->pte_hole() explicitly to preserve
the original behavior in do_mincore().

Kefeng Wang (4):
  mm: mincore: try per-VMA lock firstly and use walk_page_range_vma()
  mm: mprotect: use walk_page_range_vma() in mprotect_fixup()
  mm: mlock: use walk_page_range_vma() in mlock_vma_pages_range()
  mm: migrate_device: use walk_page_range_vma() in migrate_vma_collect()

 mm/migrate_device.c |  2 +-
 mm/mincore.c        | 71 +++++++++++++++++++++++++++++++++------------
 mm/mlock.c          |  2 +-
 mm/mprotect.c       |  2 +-
 4 files changed, 56 insertions(+), 21 deletions(-)

-- 
2.27.0


