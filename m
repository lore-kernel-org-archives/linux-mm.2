Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA2DA606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=BnQfriOm
Received: by kanga.kvack.org (Postfix)
	id 19D9A6B05B7; Mon, 16 Nov 2026 21:02:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14EC16B05B8; Mon, 16 Nov 2026 21:02:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09AE6B05B9; Mon, 16 Nov 2026 21:02:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C21E96B05B7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:02:48 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20D1AC02D3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:02:48 +0000 (UTC)
X-FDA: 85442962416.26.E5884DB
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf29.hostedemail.com (Postfix) with ESMTP id 68873120009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:02:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BnQfriOm;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794880965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3j1/LPII0agGL+7GGF+Dy4qs3ftQPKUhDA9Jt0WBq1w=;
	b=d7Lbzhi694JoWbCUP+8Bjc4uSkMDUODbe66LCH3MAy6mqAd1P5OErzqTZH49oWjU/C7yEH
	d1ZHd+l3H1ugDSkg24YB0SE/iXYUlxaxSlso73AZyPMvOd4IGsigLdMYAypL/tDyFEestQ
	KcnaqTY9RsC3EpNAiz/pxF7AgDfIlYY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794880965;
	b=OL4hMw9MWpr8axr2dFaaZ4Kr9t4gqj8nPmHoJHV0Meop9OrKJRXZhW+0IdhkgpjVOiew5j
	JRRg2v55fSCtPJmNCB7WlEO/vVkk8fFzZhalBQvCVoofI6KrTurmI6lhHcKkfh4FG+ucBe
	1onIKg1Xrq+5jeC9j8ZiWm+YOO3DsxU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BnQfriOm;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3j1/LPII0agGL+7GGF+Dy4qs3ftQPKUhDA9Jt0WBq1w=;
	b=BnQfriOmjYqZaNtmWwEWDJ7ZOGw6Lhma2L1aTwiU+hOtUzpBpDbq9ivkvsipKWXiMz39V0uDe
	rWQ1ecG8Yr1S4rXiyPquSYC8ENi8R9F724umfppvjQc3LCOuhceS1eEbyqcHpRjvuYUMC609ur4
	KpIyDOIcbNwNMpvQDr6YXgY=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jT7K72lS3z1cyQG;
	Tue, 17 Nov 2026 10:02:19 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 68C874055B;
	Tue, 17 Nov 2026 10:02:38 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 17 Nov
 2026 10:02:37 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<ryan.roberts@arm.com>, <peterx@redhat.com>, <dave.jiang@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 0/4] arm64: Add PUD THP support for DAX and pfnmap
Date: Tue, 17 Nov 2026 10:02:33 +0800
Message-ID: <20261117020237.4037980-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68873120009
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: gnxxyfyus7jxzm4p88bgkhcg6ez3wchc
X-HE-Tag: 1794880964-716097
X-HE-Meta: U2FsdGVkX1+IFlBv/ByVO7ADmGEEcLrY9WJ0jLYE8tIieyne4Ld7Ow4TtTsw+JFjy8Ale9ZK8QX0qvvMa3ezCSunwKF0FMZIM0HUwheFN8xetCZjA5jtdS5rcPsUoKXjI/cdbc354jfZsfw1VLf/8on01RI/RqKAlynvvD2RALyOGrBofioWBT6sk/kYc2OZYrxAN1bBm3CMp8lEFyljUSjNcj4ij1b3Ht9GvehOwVvWWbJ58QWkyYSg0YsUXdL7EaHKy8ljtNkapRKrTtk6Qd5nnFxxs8bOZlcm58mFyO5nQs+gSlnc5/rjIXoAlrxqdTr6bThc7Ng5P15CkTDo1cAKrm/LSVxringk4LtB1bnioe2N6KyZhrPgZ7BMS9GxXB+CvW0I5VydelcIV3I/tJhdlNrSMWYePck6/5nn457F7yi0Y8uXoC9dm6Y6WIyVa2Q08YZ2occNEj58nf98KSofA9Vxi0Se/Y9T9PRAL4+zqVJbVyHr8yYVaZ8DUn/GzwegGwujkonOPEj0NoSJLpuwtoOllMZOw5gdUtZ5s6dL2clCSyKLp3lCxJ7LE7ZtyemLM2ptGIpXp7Ml2h7HX4Y3gNKeDQG40irvgxltd/ydDeghu6eAcEGvogTTglr0AtHhkvu7acgaXVLjrCNcc+HL7tgv9XehuyDiHsiiQmj2yOZuWVRbuC891IdwowW7Onx89gYFm0FZtgR8v7zcEldiy3yw6oMihJxvyIpusQvfscublIMF2/Xif1ekzuw64RZhjO0M5WaImROfwVt9fz07LIIBR/sVWUq9L/rEBNd1vndQUnvMufYhW/uFh4RRoVGOP3k1xAQXalh28qqfyawO4KyOp1nL200aQ6WOPHXHbuMG3f01clwx9NHL/F9nwpqmkKODE1CW/9fq/O1wLSMHDOAUOUQSujvF3aeU1YkFp6JZ/RlWxIes55L5hH87HSrRxI9j45qfKHXQynX
 Er4T0BhN
 iOcOlUbgFgQ0AGjO2DPfCn8Kw7zfYD7Y5ubLE9Pqp6OkU16nVP3s73qBGNnhoO0eAY4/M9phve/65i8LVU4NpV0cjsIJOLZgw6wyuIDCz7ZtbuN9hdVgXfoDLEq3x+ZnJYkQNwBNX9uOCbUENPGMBMOZce/S/dvtB+UAf1J6fcdSD/bs97avIXUCHe1LMMlLDdwEzmuz38NXb9hlVbOALBNkCfzZ7Yqc0JjDiwp8xxMYEmt7RHimQ4wDzExdUmShy9b+SNVlsVegskeU=
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

Patch 3 adds the necessary spurious PUD fault fix and PUD page table
helpers and selects HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.

Changes since v1:
 * fix issues reported by sashiko

Jinjiang Tu (4):
  mm: define generic pudp_invalidate() implementation
  arm64: simplify pmd_special and pmd_mkspecial
  mm: add spurious fault fixing support for huge pud
  arm64: Add PUD THP support for DAX and pfnmap

 arch/arm64/Kconfig                           |   1 +
 arch/arm64/include/asm/pgtable.h             | 104 +++++++++++++++----
 arch/powerpc/include/asm/book3s/64/pgtable.h |   1 +
 arch/riscv/include/asm/pgtable.h             |   3 -
 arch/riscv/mm/pgtable.c                      |   9 --
 arch/x86/include/asm/pgtable.h               |   3 -
 arch/x86/mm/pgtable.c                        |  12 ---
 include/linux/huge_mm.h                      |   5 +-
 include/linux/pgtable.h                      |  11 ++
 mm/huge_memory.c                             |  17 +--
 mm/internal.h                                |   2 +-
 mm/memory.c                                  |  14 ++-
 mm/pgtable-generic.c                         |  14 +++
 13 files changed, 131 insertions(+), 65 deletions(-)

-- 
2.54.0


