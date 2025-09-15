Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ABB4CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 03:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8506A8E0002; Sun, 14 Sep 2025 23:30:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800E08E0001; Sun, 14 Sep 2025 23:30:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716D48E0002; Sun, 14 Sep 2025 23:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4E38E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 23:30:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1319558DEE
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:30:20 +0000 (UTC)
X-FDA: 83890056600.16.0467DDF
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4B6B7120003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:30:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jmIGEfN+;
	spf=pass (imf29.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757907018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1dkxC6b9R+oe5bvNNaXAu1xng9mdxaGiWxJPd/5Wb1I=;
	b=u9IXtbb+tHg2rkaYodVE515p7w3IPrEZFVYv8Jq1gIcy1giZ81KYeGtZntqnhv30bGHBzP
	0gh9LYwmox48Xeg1hPC/z6auAwI/5nVpZjUXsGhPKabgXbbgeF4MQNd6umptcnd2qOxdG8
	DROdnvFT/QfpCvfMUneHTx1u0HzjylM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757907018; a=rsa-sha256;
	cv=none;
	b=shR/5viiaLGRmLUWUVFxpCXvsVdT4g4xVEYkOcdfceMN53rMjEsbSm7YIiKhZ5vchZcEkw
	jcAUKvbEAr5jN0RnoMWVBdaawk6TehpXcpQhu+bDWQ0b2pGSwzKaFzspTox/3akp6uJJju
	6E3KITl7edQmFE1hJknv5OXDxcwDnOw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jmIGEfN+;
	spf=pass (imf29.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757907014; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=1dkxC6b9R+oe5bvNNaXAu1xng9mdxaGiWxJPd/5Wb1I=;
	b=jmIGEfN+vAnEQN096GQbypgaNblf+rhLUYYbNIQgB6HVAeIGudFoZRQZHM9I9RDRq1mbno+YFlVjiykiAk5QFfaK1detQDy8zhzScABaAbtBFiaKoe+RerG1oWu3PcF2UxKEOyWU0MG/a2EBouQBG9PcVHH9VCrJmVHGMeMQmRA=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wnx2CEE_1757906997 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 15 Sep 2025 11:30:13 +0800
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
Subject: [RFC PATCH 0/2] arm, tlbflush: avoid TLBI broadcast if page reused in write fault
Date: Mon, 15 Sep 2025 11:29:44 +0800
Message-Id: <20250915032946.33203-1-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B6B7120003
X-Stat-Signature: 5pbsuhbgfnt179a1jra4bgdtxxr3nqrx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757907016-938116
X-HE-Meta: U2FsdGVkX1+oQ3PrH1H5IoTKaFXd4lJ3Ruha8TqWXktP4ByTThf7+AsARGKe8x6Uqg6KNbOdvT2SbyiBdtDi4F1kTsVZl9R376SW2teJ1VrR+7Ti5sEaZugbVMew1737rf4fwG3T4qyLTKNHp9ry7hDbu4vH6KdGEBHXUmm4mk+vbJCpPtq+NdHW+mUb/jTvhtXdzGINphIEq6B5naG3t5ADFy7Dd8ArhCxODlM5zGLeuJekjdVZEb8iPVKDlDqAq3ovTVBf+o1rdu0+ADAEwA3G9iOpc19ae45p67SwleaqVcznCuu0TE2nSaokS2aDnbZMg4rDbdNThyh9rooNQjVsrzVnG+svx8w3ENamyikxHD2Uy9qjOnepwyUhl0slAxWN5BdtTEXq9m9VgdwZyej23kDXuzPROa+U+WazS7NgqFFTR0XYssLWPgWqyfUN915/LjDyo1MFbdLlj4ZkY1azU8nCph9sD9CYROULOYT3bJk/FnCeKolDT0uHnO43aW8ZEYCVEOw8JddJFpjSctF72FjA8fTbpF1p3HPTc9uWNm4OXRurECoV8alsG5mgdktlgphWVXPzs9KQb+C7YciBPFwglYmdPRneoHiwfhJUzDFLjSnfy8bLzvj+iwyApVHvVjLJndCBkYdNFPKdOAYUi7YEs81f8Ezl0IPpJNRsGDxqaxTsExSm1zWEkRAxSUKOGOshi2KsZMOiEGGTQmBQxBx8XHg1Nsoyb8avDSd/Ilfu2MTlDrakpvEinqDACASIrHbHphn/pJg0jSflSlD3P1lOUKI5ezFiVszMqKop5d4FyS8D1GNdVs54WVcX1sovVv2bga9bN3H4lpzCB1dJuiOu9uDz/dXZxYBNmSBaqKH5b6ZQtoe5BXR1zDzU1JKJusHy831fpNHJS4MpBf+Wf75FT58Q
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

Huang Ying (2):
  mm: add spurious fault fixing support for huge pmd
  arm64, tlbflush: don't TLBI broadcast if page reused in write fault

 arch/arm64/include/asm/pgtable.h  | 14 ++++++++-----
 arch/arm64/include/asm/tlbflush.h | 33 +++++++++++++++++++++++++++++++
 arch/arm64/mm/fault.c             |  2 +-
 include/linux/pgtable.h           |  4 ++++
 mm/huge_memory.c                  | 25 +++++++++++++++++++----
 mm/internal.h                     |  4 ++--
 6 files changed, 70 insertions(+), 12 deletions(-)

Best Regards,
Huang, Ying

