Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A153CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 09:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04DEA8E0025; Mon, 13 Oct 2025 05:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F198F8E0002; Mon, 13 Oct 2025 05:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56268E0025; Mon, 13 Oct 2025 05:21:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D34438E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:21:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5EE0A1A0305
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:21:33 +0000 (UTC)
X-FDA: 83992548066.26.113DA7E
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2C6ABC0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:21:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Lx9m8lSn;
	spf=pass (imf28.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760347291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Y/97U6AgdiA5Dn3k47PnInPX3VlZycLa5fUP4muVjYE=;
	b=u4Tktv1JRnyBQMChVH08+2ExRQm9KrOxj15cd1fLumIUY8vK1YMI3y6eWkXRDuwdvzWENC
	kqvgBf8WpMwUsUhMXHo4OHDdp/UkbZprnZSj/mLh86f3/FYNDZrTKEZIVmPiMKzXtf2KXS
	IrWy3vHU5CV8CtCqJwpsDMmQfT8P+vo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Lx9m8lSn;
	spf=pass (imf28.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760347291; a=rsa-sha256;
	cv=none;
	b=k890RkQOIvIO1SKJg538PPFFJmrM7bxmmIKncOKWzez2P4YJnfXiTsBtwSGUA4xOZjKbpj
	HL70S5xv029SP4MNrTswFQpMqwKuCX9DprdPfVHU8wfciABnT+8hfssrVUMyyf5Dz7Y5/G
	NcsFfrHx57o3v6cFbncSqBlxdJyOBFU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760347285; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Y/97U6AgdiA5Dn3k47PnInPX3VlZycLa5fUP4muVjYE=;
	b=Lx9m8lSnjiKAsJ5Kwdv8D/3fq9p+8cTBB1unPoDu53cCKv0+jp/f9M+77EQ5m7ePa3EeEHxX90mvfXuCYG7Vjm/3AvCdA9aQVvl2rNAw1YLz5Z5H3W+PKuKjS6Mz8Zv+Yq3jtykswnHKf+ddft2mLRBmcswdOgoYqGf0DQhoew4=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wq1niU9_1760347251 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 13 Oct 2025 17:21:24 +0800
From: Huang Ying <ying.huang@linux.alibaba.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yin Fengwei <fengwei_yin@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH -v2 0/2] arm, tlbflush: avoid TLBI broadcast if page reused in write fault
Date: Mon, 13 Oct 2025 17:20:36 +0800
Message-Id: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i8chwsj7f4spa1oahq5p5h7d81b9aow8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2C6ABC0007
X-HE-Tag: 1760347288-404258
X-HE-Meta: U2FsdGVkX18uuTdRnRKfI9NoKt47mFcaqlJ2RhAQnX5bPezkrjXS7VGSIWHxYL1KuHHjJ1p+TelB+mVUBlDeXSqnOiWNGBWsl117VIjRumTAXrhW0LnmUWU3Z6KVV/QRLJKoXl+g2awHRdum02O5tPB3417PgbAEwXV3OdG51NERkt+Q1euIU7UH88WLKxquVd07VZBI/9y2qDNmFROj971d7kacq8IJPsGO7m9eqcjI2I6Ncm+kECKb3YzrymbNhEGwwRChkR+wlq0MOV9fKdDHUvy+1OhAUBNudOrJE6p5Cj//PorOt8ZOImS+XJySppiGHLBSMbEsIz+c3Ejo31wtXo3GIVhvvnvG3ztfqTRZ9wQYuhxSdcR18ha/mxBy8vxrIXCfRqU5Md9Cuq2NQjDnMM+V+3yUBgUir5s+9g4ILdrBuT+YP4iey9S4JxKa/7zdxR30KkjplG36TGpHpD+9sPyW1BDbeMM9sTNMA6W+3I4CEeNo/lgfLR0sh5FBdgvBlVnRAKvZ1grBP4o4tIxMMx7NGnGKOX70+v7gz02BYvxOvkLOrn+9uYGlGcyzwtU0SpvoV/jg69xwfjZBoTl7PKEZkGjb8YRfZOwfv2+M5Kn3srO+s4U76k5rSZljYHGFI23B8UieEyH9Jwk0z1iTHT8yK0haH7Qd68cUy9aOVx4YfYVcQo/tjZKFe6U7JybXfS+MGS47qixz9ViqMvSRJ6f6sDpRMsZKSql1ueLaRa2t8kHnPbNbgnjt7FFAfrooL0yz53+FpOdqtmGckr5MwLEvepDyVYwyJOk3jhQSuzOfEoEQ48G/MM6yu38RqdPpwfbWQgorPprxwMDf1K33ioETcbdNcQhAExDHvNjog+tqDCJi14j9GieI4uQ2iQa5o1PQ/zFAMmreXaPDhimAJCdfhFA6DpJ/U/h+aE0HowH0cdug2mpDoHagolib/fuA8W7OXI27NZbh6le
 ZHksaoq8
 c3EH5/aWs+W0DuboKVfkr+5U0bodYludA7AiNzAOAsMoAtAiXbJGt3z8WCod2CXAdl25D2+7OuzbJ1TsAdHgaNzOe5iguyhDvSZmesP/DeMGm+m/htoyGiEU5/ISCeq5fhNmZoNGj3Mg6VRSwt+6UkZpkiRG3k7v6cIQdR6d3F2FSV2UI7OxcslL8ZtoxKQJFAF6b0h3dTq8noHRWKj1XQwJdZ3LXfukjDSwGSclKkIoBgBwiDa/DFkpGDkQEmU35gRy0KwDlJPVOJ/0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is to optimize the system performance via avoiding TLBI
broadcast if page is reused in the write protect fault handler.  More
details of the background and the test results can be found in [2/2].

Changelog:

v2:

- Various code cleanup in [1/2], Thanks David's comments!
- Remove unnecessary __local_flush_tlb_page_nosync() in [2/2], Thanks Ryan's comments!
- Add missing contpte processing, Thanks Rayn and Catalin's comments!

Huang Ying (2):
  mm: add spurious fault fixing support for huge pmd
  arm64, tlbflush: don't TLBI broadcast if page reused in write fault

 arch/arm64/include/asm/pgtable.h  | 14 +++++---
 arch/arm64/include/asm/tlbflush.h | 56 +++++++++++++++++++++++++++++++
 arch/arm64/mm/contpte.c           |  3 +-
 arch/arm64/mm/fault.c             |  2 +-
 include/linux/pgtable.h           |  4 +++
 mm/huge_memory.c                  | 22 +++++++++---
 mm/internal.h                     |  4 +--
 7 files changed, 90 insertions(+), 15 deletions(-)

Best Regards,
Huang, Ying

