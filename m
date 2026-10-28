Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B57606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 12:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=YUmINJPV
Received: by kanga.kvack.org (Postfix)
	id 9A09F6B05B1; Wed, 28 Oct 2026 08:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9784D6B05B2; Wed, 28 Oct 2026 08:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819826B05B4; Wed, 28 Oct 2026 08:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7F16B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:14:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9C27160C55
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:14:20 +0000 (UTC)
X-FDA: 85371927480.08.9C18116
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5ECFA2000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:14:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YUmINJPV;
	spf=pass (imf03.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793189659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kWtcaKJ6IQ4bNn/v2x4kVI23f6xFQA7cEBIWxn7bv2E=;
	b=N//WOlmtybMWc3GbjBN8rKq8m4IQlaFctiPj/JkzNcvlzqoBd2s5t2cIVVjWoY/HVEK4wn
	zG/9gePYSILqRT+AwH81eddeznMQyomTIBibCt03Mz8Isqmf0Xm6CYxqrPjH1TLveqg3gW
	KeW4keDAuvl3uHjfz+uMw40EoAl+rGE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793189659;
	b=e3BAOtTKcK0RTORm0Y61/2jZt6O0RvsM+mM4aDAqJjPFqYemiy39GWvEFGJhCmP9a00wd3
	QnHOce1JgARIBVUN3XmyV0ZqaGlJ+8/JKLBJUK8wk9ZPivx5kV1Ce5FSNzbLq6Xrnl+Mkv
	EPp6Y2Axwqq2n+9hDPqSA/1S76MRt8I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YUmINJPV;
	spf=pass (imf03.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kWtcaKJ6IQ4bNn/v2x4kVI23f6xFQA7cEBIWxn7bv2E=;
	b=YUmINJPV+Q3oJwe5jmGuMlVsZ/ZuNKiMnC9t0XtvD097CkYW79EqI75EBOltG/oPpfkRUKLcR
	Ba184Ivdw+AhlrZ5LP230OzitIs6YI7PkgK0pVvu3qnuwje5Nuu+fC2Y5qXazNbNA1z+xJYFKDX
	B4aL0SVTQvFJVxMvNbpeFno=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jF5r55Wpfz1K9CK;
	Wed, 28 Oct 2026 20:13:57 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 34D9F4058A;
	Wed, 28 Oct 2026 20:14:06 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 28 Oct
 2026 20:14:04 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<ryan.roberts@arm.com>, <peterx@redhat.com>, <dave.jiang@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH RESEND 0/3] arm64: Add PUD THP support for DAX and pfnmap
Date: Wed, 28 Oct 2026 20:14:01 +0800
Message-ID: <20261028121404.853944-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5ECFA2000C
X-Stat-Signature: t7wamyaedjroxgqh5uppi45mg79jbt5z
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793189658-856889
X-HE-Meta: U2FsdGVkX1+FA8NTBquCzF1+23ab0FqQPCnPMtHNKc+zc5THFfObYU16ZIkGM2nv9pn2wAjSUqpadDyxc95DIpajz7uba1+RbiWYXFtuQnbKdyD0C7cnuK7lIm5s9GSA5zoA3w8bsonm2bgmYyT1d5LQMFcBENcG23T4/q2k2uYdvhCponxdiyCzxthfBdz9ryBBrbjL0DbdyukfZo+u+9r5bq73VOp6i245axmfxVKugGNyGEjbhkXINcCY0mACHcR7nTRJBNMRflz37RP9P5K4Bm7UqWKi2p+td/f6VSdpg+3R/zE1HG2XxpA0wf+E/ZMNcmNJxzhlQEMTn0rM/d2k7bMZWMJRGJGRmJEfTEamTRsgtCOid8FgTSbJ/ggFYkzFH0pbIluDNVOf9j2IEFEhjQthgYalD3Px8OKC0NZMSOhTTGguwfGGSvj27JHmlp2c/XldkU7psMYjkpknvUveQ2687Z74pCNhy9ECXd2zWMMVozxpgCo1Lo0jHRlFrWYw+iDyR0fxrBpC2oNuw3PjFIii+RnXtLcW2JFYVtlOv46KHnoG6mPvq9cplXUv83iPNuzttR69Dd45OeEnDh9SRTZBM9COqmOZ3bfEnS+fpk2WV/60jAXwhakD49cYv4bvjIrHsjzLQd/MlAsljtAeY4WtXJvi66wyYpyfHeBSHYv4Hg7th9JjYiGqS0rOCnnnV1BdzjkKHwGdzOdhsrOB35PJkcVZolo5VD5VLKLNfeQ/Jj9SvxEsUDVnzG0XXPfE4iaE5xV6tMdqssBSNXNCbxNSWuPofPkC1MNS7pPhF7Dgque9MaGLgqINirVVG0uxGznLioEgNfsUh8sMzW7ezwtEPqTfkm1OW2qfzZkr42nLzBhlzhHKJ0q28+ViMFKokfqKWEw46wrFMmXNLYbitLcTuP+d5bl1jzb2b20svExyQho849g6nhbeSpzdx6nurafOMhdq1BizOjK
 U2Tl5vib
 rgz3xw+l2NZZEiPmVGV/ieg2tDro3sWz5iXTNeydADdKMCTyiB4Vl6lKZRtK+6D/8arxNDylVfiW/6M5TOKs5YVZURL9ppPTqFdWn/AI8SflQEYIvW41JwROW2va2nUDjyoaomiqJ/YOFl6a95dCkCfy+QX4MfcBsoP5S8XGMTYtAbjQnZcHcJdS82F40AUwMiqzVfa/55IPqR5118J+oKL4XwCC47fmVep7VfdrRFTWjQbByWSeAHhyKvqVylwP/0qJVMjKvkUtiRRE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series adds PUD THP support for arm64, enabling PUD THP for DAX
and pfnmap.

Patch 1 moves the identical pudp_invalidate() implementations from x86
and riscv to a generic location so arm64 can reuse it.

Patch 2 is a minor cleanup that simplifies pmd_special/pmd_mkspecial.

Patch 3 adds the necessary PUD page table helpers and selects
HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.

Jinjiang Tu (3):
  mm: define generic pudp_invalidate() implementation
  arm64: simplify pmd_special and pmd_mkspecial
  arm64: Add PUD THP support for DAX and pfnmap

 arch/arm64/Kconfig                           |  1 +
 arch/arm64/include/asm/pgtable.h             | 71 +++++++++++++++-----
 arch/powerpc/include/asm/book3s/64/pgtable.h |  1 +
 arch/riscv/include/asm/pgtable.h             |  3 -
 arch/riscv/mm/pgtable.c                      |  9 ---
 arch/x86/include/asm/pgtable.h               |  3 -
 arch/x86/mm/pgtable.c                        | 12 ----
 include/linux/pgtable.h                      |  7 ++
 mm/pgtable-generic.c                         | 14 ++++
 9 files changed, 77 insertions(+), 44 deletions(-)

-- 
2.43.0


