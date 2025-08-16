Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72503CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 11:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 118DE6B011E; Sat, 16 Aug 2025 07:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9B16B0125; Sat, 16 Aug 2025 07:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFAF76B0124; Sat, 16 Aug 2025 07:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D75E06B011E
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:00:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFE21117949
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 11:00:27 +0000 (UTC)
X-FDA: 83782326894.15.8619228
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id B2F2BA0014
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 11:00:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755342026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=79D07NhcoACxwO39xy+5B94I7RjXRqTsb/zfTzN/WF0=;
	b=hXyiIiBnsV4uCc6CGTZkOiQ+jhJNBlmtQ+6jFp5jm/ADZQDvTDxQQvEFw7lFIBCTZJjeIP
	L4SnwfKbvhOo5Uvyd2s3tmJ3hDRKM/W95jYXwhJ0NReVRq0LTW4wLehh1tzSKvKR/yx5kw
	1GSfR+rzN/XT0cbHBt4P1IV0NlPgvBU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755342026; a=rsa-sha256;
	cv=none;
	b=aW1y4Ogqn8qdzjzv/qKhx553Ukyn6nh3wvsbjFZpHxhKtXXUUOM1eOaUOHYYqNIqfQkt5J
	rKrhCcQcpGjyUW9WPMnRTBd0qBukGlOfrtYVqyVaoiYLMzaLArwmSqczkgkHQU8Ki632if
	WBpIRQBBtQmZgMGVyOt9iXV2ubjQQnw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C7BD1F60;
	Sat, 16 Aug 2025 04:00:16 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9F8873F5A1;
	Sat, 16 Aug 2025 04:00:20 -0700 (PDT)
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
Subject: [PATCH v3 0/2] introduce kasan.write_only option in hw-tags
Date: Sat, 16 Aug 2025 12:00:16 +0100
Message-Id: <20250816110018.4055617-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9b5xfxprh4oae9a6yheruy4iwhtws5nf
X-Rspam-User: 
X-Rspamd-Queue-Id: B2F2BA0014
X-Rspamd-Server: rspam05
X-HE-Tag: 1755342025-659466
X-HE-Meta: U2FsdGVkX1+uPwZ9CPcs+iOG/CNOCDy7nm+jxLoBdZtIrwBeSx7TzNGcpnRb3hmM7DgIDY5uWuAfWVg5MKYk15ax2i58AlFLQ8C0pP+2C8Hj7CjgM3rbYf5WCcG/r196Xl4p1uKCYvcShZOKVVaAGNXbOenh5rvJBtmqbRwy8sckvS8SdQ5HmLluzMSsXIeRKeBXOFBYtp7EQV9fOkZY2lUi5M3nrWWDmVsWcqfP3Ks3LBNMQG3Z04wk2nMLcDiuQaFpp8epRIGYXK4Vk8hTBMInu9M+9f9MeYHaqnrWtsaL0NN7ne26POQvbjBLilwqYO4x13+yjeTWV4t50z15t5cZJCj2GAJX/uHBnS8SoQmYjOKrDGdFlGZnE60T+vRepLpeQlb1vkgzalNtY8bBDoix7VlBuhvbhSygdfPnEONy42hVbMAI2yB05/V+V4d8q+w6WkoxW6MwuRPBEavNrbi3o3D10v5SOMpOuG5Tlp4NiX9mPjWPzTqV+Ry1ubhXk4m3uUn13QTTJnXP9Xn+B+AZH2Jyi/0mdhYGkssLYJTYnQnXN4mWPCpaUDtXV0nr9wUkLHmUCClcDvKAHg/nz0n2TODZ7rR26VUNxKRd0AMY3FFuSHd3I0UQGlKvNUfcPH1eAbSUDSyU5Bl6zdh6AUO0RzxTyj5EKNptzRpr/avSPS1NPTBFXpcjzVKth0Ov/QSCuGiJkh0AvSdKD5g2uHepj1v4qO2kILO+xO/KIe3g65rhQtp7+duBvz7CGixLXpTV+h8cyvrVz3yJWP+t5lKMlMl4wdY6msFUK0gjvYaSO04g5kVi4WIJNI57mvJB861OxXhG9/m6Owkf4/fgLPxAdIPnzvwao+MKRkCsHe9ckIOzaIPCqwInGmdWgoEge9AFuYPURUzRnotyCzWVk8XPMlmk4U/UiQMyabBJY4GfxX4hH6uM/0nQ8bi7znjVSXITkqpmv+MIbQMe4U/
 0K8wQOxL
 kG9FwWv42PA4uLpUGVenrJAxqEmq+e9LIC7emFPae7VYKw/V2Z0XEVSpHERTcZDG7ryXtJGv653lcZcobNKfluKgeLDy2G/RGpe1b2mZEy2PUGlVTquY3Q+WmBW8yxU7IXwrOP4jeixJhLPNGoFlPN3cKHcqy2BE4YYj18R+DcT8fkowenkl1FHP1mwXo3YvYlVbQagcat9e15FpC3q0BIzRdCq7btrD48BhwXDUMitm9LEZumIW1msTcRo+2TC0rPrr/lzMvjQjdNKGSCYXbsB82TyEumg5PYeR61MjFwjTcPAE=
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

This patch is based on v6.17-rc1.

Patch History
=============
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
 mm/kasan/hw_tags.c                 |  54 ++++++-
 mm/kasan/kasan.h                   |   7 +
 mm/kasan/kasan_test_c.c            | 237 ++++++++++++++++++++---------
 8 files changed, 250 insertions(+), 78 deletions(-)


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


