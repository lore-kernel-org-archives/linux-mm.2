Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAAFBC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81C7D6B0095; Wed,  9 Sep 2026 05:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AF0A6B0098; Wed,  9 Sep 2026 05:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55FFA6B0095; Wed,  9 Sep 2026 05:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2944E6B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:28:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C85DC80141
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:28:32 +0000 (UTC)
X-FDA: 85193698464.20.D2611D9
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf11.hostedemail.com (Postfix) with ESMTP id E00A040002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:28:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ldFaxn2U;
	spf=pass (imf11.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788946111;
	b=XmCqgLYZ3n21FS5NNgIbI9Z1j1j+zzSyY0uW2QMJkQFgLRPYM7SbIKcoP3amzJoNAEArtg
	X4rV6mHQyUU40wmVAq4NEdFcyX7Bi13EUV5A9nMgXVmvGioELTj5xIN5034xYN8BwtWg6e
	8bh9zmCCK+ZgOMtx1W2HR6r4edrTtVE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ldFaxn2U;
	spf=pass (imf11.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788946111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uD/le38L7H4MWPEqTkCfnYrHEznDm74M/5CQRYxFSEw=;
	b=5t2wfu5S5NzAeEiO3SWk4/9i0m4szmwGetcLuoJs/rNZbfz2bsnPvrEf98cBptlyxEVWQV
	/WgEMF1bIHC4R99lyROhW7bt1L3+4nXmOrerSPdaabf4sOsOK/ZEasQU7EdAJtGztmuNWW
	EQdc8VB9UPmz5pyV4fguCa9LsXsiMws=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uD/le38L7H4MWPEqTkCfnYrHEznDm74M/5CQRYxFSEw=;
	b=ldFaxn2U3xz8nsmyFbzrsh4qQ6czzb/jEGiOl8c/LzX2rZ6q7TMtvticJzcTl847AE6rxoOKO
	Ae0y15A+0xqy5c3moeVm/5+m9Vu1ncHjgMaoUM4MeE20xIOio5xgiLsfWnpmanQhXVxUn2pMtCQ
	CV+sHlpS63nq3Hg1f49vzJo=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hfwDL75Tsz1T4Fq;
	Wed,  9 Sep 2026 17:16:50 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 7D78040575;
	Wed,  9 Sep 2026 17:28:22 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 9 Sep
 2026 17:28:21 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<ryan.roberts@arm.com>, <peterx@redhat.com>, <dave.jiang@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH 0/3] arm64: Add support for PUD THP
Date: Wed, 9 Sep 2026 17:00:15 +0800
Message-ID: <20260909090018.1991485-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E00A040002
X-Stat-Signature: 1q8xknos965xe67n8cdtoauwidqz7fme
X-Rspam-User: 
X-HE-Tag: 1788946110-833596
X-HE-Meta: U2FsdGVkX18B9xurJs3Zby/3fBkiJzu+f7GOhqXwnE5w+JLfP0/KoW05c+rD5BmRceGrNm2RKFBIczITyecQqd8SpY9lxi+APza7Rw9Rdt6lTtfyQ29IXI9ZF4gOQ95uthyMI8lv/bW8FA6kwPf4JgE0KzByAKkpbDDEohxCIugS+/+2L4wWI1VB3hi1c5OIoLHsquczQclzqviVR/G1N4+cj5qytH2aA25jEPAd72+XJ8VEor0kll3x49n90IccRr1dNG8L5Rhp71cqIMA0TWWYUdZYO+tyxWIKBRXTWth3yi0nnnxMhIbQV1LwacLfdZ9c+lbu2fnuJ8AqEHe5SSEGCZvYnOevBM+5qUr6d+d27jOqUCfQWU+bnRew0d6PBWOYceMzRJlHwAKeOzYq2PS1rnH5aMpN1GbZDTZA1927zoGwJVcQRRoubruuZNSxgs6XOCrXXBgBOq1XRaYqA+n+CcYy2kbIPlZHkaIYtXBxgoieX433cHXy89xGzGwUhZYXlPhtuScVZi86ikqBWQH2r39PUrlCxloW5IqIgodUEzE5TFtRnAWBRWgNtx0ZI5dU1zLSTWdv5QoQDAF4abZoUX8RMtkRkCMDterSVq3LtuFkNRI0XcmEtRoVUw6oqjg0eaDRpIFYIbBYn+No2XQ225inzz8o+ymKy+Ev2PpgWkBgxZRB+jqU1Ojlz5JnB90j9SoN+IqLSga8deC/qeY6+wa2BNwOmpv9jdc8sRBm0o7BFGruPRu+4fQXc/V7Q7Bg2zXXMHse6nkJ7n3/iHbBcTQXVPc5w8LT0Mx4Fetunj19X8yKFG24VnpEiDwjL0O9sO5uKz5rCGoUMGowueA6eDvraCrnqYHYjL6Yc2Xna4+fbTjG94SQkECOir9GQpMc1dKKSW90hS5tkCq92g5H2FBBzEwhnGF4JGw0J71+6UDz77KoXVhS8Mv6FNhTA46zthmcPXyiVtcRojC
 m0lUpCK4
 29BzMatAzg6YnL9zIazE6OCkj3035/2be+WDIp6iDbgfS8gqQseWjqdbM2Ofw9mu8l0BycfrQGHJQQ6Cn2c5Qy3K7M0I4scwtNqgw2mGcEflohH5UmiprfPabE7cn77QMimHcbISRgNAeb4gfnPrL5yEoud/Jl07y9HGR13/7KooDmAE0nQtDPaawM4+DOW/Z8sG7KaICT+d2ED5OD7NO/+ZTNnscbllAgTSwaJzZATkC1SH2xo34n09MS0LLU3yFJUwA5G8PefBqPNgYWyKdkyOWQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
  arm64: Add support for PUD THP

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


