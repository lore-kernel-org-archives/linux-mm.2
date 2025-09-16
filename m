Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF5F4CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 22:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0702D8E000D; Tue, 16 Sep 2025 18:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021498E0001; Tue, 16 Sep 2025 18:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52438E000D; Tue, 16 Sep 2025 18:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CDE4F8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:28:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97A441DCE60
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:28:04 +0000 (UTC)
X-FDA: 83896552488.19.6C6EE23
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id E414540008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:28:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758061683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=d6Ja7gN74jIaFJCh7E3Hv4bPB5sQNmEpCjuGsIoX0Dg=;
	b=MevH5XYZd15FpvP2L8U7BmkZC6AwlScE6xhY2GCcyRKx7a5F/IwsQKOPsruwnoarmhOZTW
	/OzkVKQwZCDIVeqsmWbRowRhF4rNHVTEN/DP+ZUlopoqEfl/KA/pC5NewirHFJmec2d4PC
	koxtPHpvx/eNamxWiA3ySOutViRnMNo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758061683; a=rsa-sha256;
	cv=none;
	b=IibHN/aDQt+hD5VfUANcMlQuu+jgCSDTW/br7ucY0Brs2NLMpo3nNRdhgUI0i5fVU0IaKM
	pJhZlE8zHqKy8WqssnRo10dFZPDTDJXuyO7nOCwZXQM2auWuvFlUprLzZRnMo45Fzpw4G9
	2raQRsoWw0WqglrnpF360vm5jAjPsQQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 909E212FC;
	Tue, 16 Sep 2025 15:27:53 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D3F533F673;
	Tue, 16 Sep 2025 15:27:57 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	corbet@lwn.net,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	scott@os.amperecomputing.com,
	jhubbard@nvidia.com,
	pankaj.gupta@amd.com,
	leitao@debian.org,
	kaleshsingh@google.com,
	maz@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io,
	david@redhat.com,
	yang@os.amperecomputing.com
Cc: kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v8 0/2] introduce kasan.write_only option in hw-tags
Date: Tue, 16 Sep 2025 23:27:53 +0100
Message-Id: <20250916222755.466009-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E414540008
X-Rspamd-Server: rspam05
X-Stat-Signature: yo3bhzqwncw8pwd313uh1a17z4bbc1bn
X-Rspam-User: 
X-HE-Tag: 1758061682-518900
X-HE-Meta: U2FsdGVkX18Ts7n2a3WlZcrDRR1SE9RsJERH4csxkvkyKZbmg1qcUUndMuxUQNtKi7kmYctfQIEAy2Cfoaf3KFWzbpiUOfIXjl8wXgXfpMIFOyhvgq+t6uczd8A334zfEWf8yv9TokRc8c+2W1ZbMOdhe2j5j1Rx0ToTh4chb8SN8iipUc4UVeTkoCcDja2EBCMLlmOD/9qJZ4D4p1aK20PJEXd9y7aFMT2tKNydNd/eKu9wJ116dfQ/HkzopO/YPIW2OO/o0Uq7K/UGg8GzWKuAXrN/Vd0BfEiXk8nK2A57pDIENRPITPR4M2eAnjmNqYduEdKJMlgpQcX20CKqAtY/+2TKC0BEwT1CUOkx9Aet15fzxMB6OF568F40McXKblVQrb2zGBZGVJvPMmccWEo2kWJn8bsrWCkgMB76eGq4zffrutNHhlzwwE5ly4mXoHtIlOuOvBHvo7kBl+OBNupnmtb5e1H+u+omSist9+Ln7qITsDhDMiIj/YxC1sSlT/4XVbDV+R3mAi1bm+5CvX+Xb/eXLDSvlNOm+HjaQ9ylWYHuN7K0CihYjRfyPub8ZmszRaQ2ja7yKnbhiZyhEREZG7om6x8idNHS56oNZ86KLLKqK4gtuwU+T5fcJLAkauB/NcUMTK0CgRR5xNait9BpujzRSWktgsVnYNcdymsnoVDQOhWq3ZkYU8FZLb482QyCCXhZFUGRt0m/+piDvhCWXrKsSc/CAv6WMCgtP1NAbsuFKIfPQ8TIZoBSW0ExqgOMKaaCJflCu0spxG+/PpW0ZP1JfQF+2i6J+8pbQa59HfscXypz08j1i536dDaluxf+fRxgaCmVtn0l68SWiYrxxboOFhKSQPcB0ivyRi6SMc9Ym9ihI0Up7si/Z/QA7iDi9hijpUrDtCOnHPZD5pzfnjquydkI15Ls0ZXWQCq4SMx7ECwy+uwvtcsMexklGZjc1eiyiJsI8ZnnkgZ
 Nk5BX8iI
 hGr7wcatwVRKLNcYIPNfoTnBKVCsuTDtw5CSAIayympTyPLr3v31sSI9jP0atkUDks0vpTi232hy4wWNL8wEKEl2JVi1XDlMP+zJNpUAeknqZkLgi7bVmxdI6biMIORMwfvU7Ff7BE8I7MFSrVYAz140Su4lb3JI0Hk8acF1t17yIvsAgPP+YWOzWPukjDZZlIaZbKfbIGwqNakkT0ES1cc8TSvg9sbH4iA/ExsqPii2llny+4xApBGfhINfODR9GaezFn5FvI1/G5VYzPaOxx9spbAvetaDikO9NQ6QSQ0hQm8E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hardware tag based KASAN is implemented using the Memory Tagging Extension
(MTE) feature.

MTE is built on top of the ARMv8.0 virtual address tagging TBI
(Top Byte Ignore) feature and allows software to access a 4-bit
allocation tag for each 16-byte granule in the physical address space.
A logical tag is derived from bits 59-56 of the virtual
address used for the memory access. A CPU with MTE enabled will compare
the logical tag against the allocation tag and potentially raise an
tag check fault on mismatch, subject to system registers configuration.

Since ARMv8.9, FEAT_MTE_STORE_ONLY can be used to restrict raise of tag
check fault on store operation only.

Using this feature (FEAT_MTE_STORE_ONLY), introduce KASAN write-only mode
which restricts KASAN check write (store) operation only.
This mode omits KASAN check for read (fetch/load) operation.
Therefore, it might be used not only debugging purpose but also in
normal environment.

This patch is based on v6.17-rc4.

Patch History
=============
from v7 to v8:
  - remove useless kasan_arg_write_only and integrate it with
    kasan_flag_write_only.
  - rebased to v6.17-rc6.
  - https://lore.kernel.org/all/20250903150020.1131840-1-yeoreum.yun@arm.com/

from v6 to v7:
  - modify some comments on KASAN kunit test.
  - rebased to v6.17-rc4.
  - https://lore.kernel.org/all/20250901104623.402172-1-yeoreum.yun@arm.com/

from v5 to v6:
  - change macro name for KASAN kunit test.
  - remove and restore useless line adding/removal.
  - modify some comments on KASAN kunit test.
  - https://lore.kernel.org/all/20250820071243.1567338-1-yeoreum.yun@arm.com/

from v4 to v5:
  - fix wrong allocation
  - add small comments
  - https://lore.kernel.org/all/20250818075051.996764-1-yeoreum.yun@arm.com/

from v3 to v4:
  - fix wrong condition
  - https://lore.kernel.org/all/20250816110018.4055617-1-yeoreum.yun@arm.com/

from v2 to v3:
  - change MTE_STORE_ONLY feature as BOOT_CPU_FEATURE
  - change store_only to write_only
  - move write_only setup into the place other option's setup place
  - change static key of kasan_flag_write_only to static boolean.
  - change macro KUNIT_EXPECT_KASAN_SUCCESS to KUNIT_EXPECT_KASAN_FAIL_READ.
  - https://lore.kernel.org/all/20250813175335.3980268-1-yeoreum.yun@arm.com/

from v1 to v2:
  - change cryptic name -- stonly to store_only
  - remove some TCF check with store which can make memory courruption.
  - https://lore.kernel.org/all/20250811173626.1878783-1-yeoreum.yun@arm.com/


Yeoreum Yun (2):
  kasan/hw-tags: introduce kasan.write_only option
  kasan: apply write-only mode in kasan kunit testcases

 Documentation/dev-tools/kasan.rst  |   3 +
 arch/arm64/include/asm/memory.h    |   1 +
 arch/arm64/include/asm/mte-kasan.h |   6 +
 arch/arm64/kernel/cpufeature.c     |   2 +-
 arch/arm64/kernel/mte.c            |  18 +++
 mm/kasan/hw_tags.c                 |  45 ++++++-
 mm/kasan/kasan.h                   |   7 +
 mm/kasan/kasan_test_c.c            | 205 +++++++++++++++++++----------
 8 files changed, 215 insertions(+), 72 deletions(-)


base-commit: f83ec76bf285bea5727f478a68b894f5543ca76e
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


