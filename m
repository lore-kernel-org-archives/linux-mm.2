Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44EF5CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 15:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928308E0002; Wed,  3 Sep 2025 11:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FFED8E0001; Wed,  3 Sep 2025 11:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D778E0002; Wed,  3 Sep 2025 11:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 717BE8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:00:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29E50160746
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:00:33 +0000 (UTC)
X-FDA: 83848250346.20.377503E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 36A6320021
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:00:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756911631; a=rsa-sha256;
	cv=none;
	b=Cy9HkWxEz/nuRZAzpSycAZMLI+bREESEMYnD+q9/qSCXi0rS5szuGgN4MQqeFOZu8xlS49
	4JbilJBzsF/UUyuO8TgUIHRrdHh6+5NGuEta0tQx4qLtixmUQNY+HS4sGl/1f8pSxEm054
	NcNsPEAKwKlf1kd/CF7c7zYeDbQw49g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756911631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=GWtECCYO/W3ZeQTeOSKG2/hfJYDhLePie2ke5lizwtk=;
	b=z4cgDbwxwGxHUDRyx0rSq5ll2NEAqjWiXzEga55X+Y+NGxPGWahb18idaBbCRalW5hBPPf
	/p91DOiK/LMQe2u3vvRnfpucYakjlg+WdPV8Wzt0hi1FQqZ8Hkln8dMDYJvdPOEfOv0dUr
	vIMJwDULmowF5TYTsvcj3JQPj3O7QRk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65C9A1688;
	Wed,  3 Sep 2025 08:00:21 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D89543F694;
	Wed,  3 Sep 2025 08:00:25 -0700 (PDT)
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
Subject: [PATCH v7 0/2] introduce kasan.write_only option in hw-tags
Date: Wed,  3 Sep 2025 16:00:18 +0100
Message-Id: <20250903150020.1131840-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 36A6320021
X-Stat-Signature: qihww4z3bp7xiqfusq4uptq68oubiogh
X-Rspam-User: 
X-HE-Tag: 1756911630-991651
X-HE-Meta: U2FsdGVkX18vin3M2Dun7NHNjIXXv3ebDApRKhIsa+gXEWt5KfecknO+hrlpOTQzLhOlEt3GeWt1NNdkfoHZUZZ18nxwEllFG3TCHs/4PYvASvl6emQSt35FaLFtTwWvc6nTgjnYH/G6VS9ZlneUsDZwOVuBZAhZEzjMqqBqqDWUWsLDVDkyAyrMp8FT+QgW5R3BFSjutzymnQQkV04VIepVbKIySn86zQX3/DzZLtrWZI97pJxlTqarCP0ioawwlZhdxfnp8C3GAB7by50iUUVpaFP9iTJ9Txsy/vWOPs/EmoQOi1YWNDasYzmiLwOFZiNIyx76LEA/4Pb0MfYfRlGPfZODq+W+Ci9FMzHLXvdUowHS5LCnD7I14EJU47D9DoZM1RRLvqUJsUW3LE/AvAXvNdVoL/F9JAN5m84Kdxt8SqeNR225eSFLy4XDdqIRQvwrDche+BLOVyvXCo7fCyq1hCQnnVbR5H3DzsQsvaU5XYwKtK3NVhMDjxmvaU6ae9ywmlYlQ+mELtXr/F0HMbsWQFxYVmWemQ5qUeUwh43fa/xkOimfgF+7nk8AvfpilcpoBOtZy5jve1Uh1nfcJCL8iUCizZniMMTCjMV8JER6Gm0LqAZsOO+qISoVQl4whiwxkXUoYCkfB9Gc7APKHG7B+qIhatOv6gT8P+/98wDHjjyCrcZBZalkNeYji62S8YEG6ia9duRhcruXdFak5BT7j7FHejPGxm3dLxv0HFvthnIDeOVzK8WK1rbtNjv90n3mFT6r9K0rA/iHp7z1u/uTOrbTVvlHprjHQSwfWbrHdnfv91Ei3/eh+WQrXIeQj8zQh6gQd7Z0mAgm2bbQcbSjeqhbE47pHFHAA2Qh1/gk9aKVlDZcViI2vm97Hdk2Y8OqmZx0qs5Rehdj4y7sTkFg9/pGVuFDhlJWKUTJi2o3dZxaEltNRVKLz1t0vvh39nX1DlpFsrUtNzaY/aX
 fCEnO+8w
 D8gOlfAHecyKBYer8jufAc2jDhoIl8+IGR/Sh1zk1C+65Glx6ZeBmBfeOnvWH5oNG+CXavM3wc+2mEvNN+sJdCIecyZOtda4pM76DVG789U4+WkGjN7MjQ9G76KeTy2owFhN7Zg3AFUu6pwvNCwSiBAEcr29JOb+s0s+YMHeavJmwYz0WlWgUFitmbL2wd7M40tOyT5nNrmAvgkbW5Kzgzv3F3kCj4CQJJqzCv1D3sb4kyQkTctsURcgY2iqVxt3mA6wCV66fOU7XaCf4fBA5xY09SW58mjsHL6vZSICftiAJ0Gg=
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
  - change MET_STORE_ONLY feature as BOOT_CPU_FEATURE
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
 mm/kasan/hw_tags.c                 |  70 +++++++++-
 mm/kasan/kasan.h                   |   7 +
 mm/kasan/kasan_test_c.c            | 205 +++++++++++++++++++----------
 8 files changed, 240 insertions(+), 72 deletions(-)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


