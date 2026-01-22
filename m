Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90EA9D3EE96
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D40E6B02B9; Thu, 22 Jan 2026 12:02:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E336B02BC; Thu, 22 Jan 2026 12:02:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC3D6B02BD; Thu, 22 Jan 2026 12:02:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB3076B02B9
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:02:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A462C13AFF1
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:38 +0000 (UTC)
X-FDA: 84360218796.27.8F1372B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id E3260A0020
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769101357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0U+zWZUGdoCsFmLWnVOesuzbCew+/XQohymiBZWHJr0=;
	b=TrbbKOpNmWJPsPYf+K1Xf4zuAWsm69Tj62A5Txw1j8kMLx/cj1TyEnOGz9Z4JQkJSntbxv
	fjRNcCzAkvy7nrHSuqRTdX++mwWNvBqB4oR7jhPvgZ2IA9ELirt2X5FTFaTjWAClnmNLIY
	F4lCiGK1UCpH+ohN5i9fWSjPVQrgi5s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769101357; a=rsa-sha256;
	cv=none;
	b=r2DKKSzF5/rhATIj0Fn/d0usUjfiJaTZu1LFa9bxOe+jZxCjdoLVM9ghSGlhPzB31CTBqv
	Sm7+dpg8SpIF5vPbpkcg1XvRdpJooIiacXfYegdlwTjpvOBHym8jTgND7jRcnsyvwUTcLg
	GcMbzYiyeKVvXtVxtps68n3vCCj+tm0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 840A41515;
	Thu, 22 Jan 2026 09:02:29 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB2283F632;
	Thu, 22 Jan 2026 09:02:34 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH v3 1/9] selftests/mm: default KDIR to build directory
Date: Thu, 22 Jan 2026 17:02:16 +0000
Message-ID: <20260122170224.4056513-2-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260122170224.4056513-1-kevin.brodsky@arm.com>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E3260A0020
X-Stat-Signature: mg13ubnfogcjygo6f9chshi79cdsj3pp
X-Rspam-User: 
X-HE-Tag: 1769101356-347307
X-HE-Meta: U2FsdGVkX1/CEIM+Ktn+VeTROE9AZ5tSH4Uiux5lDZeuxJ/iHAZLd1rr0FTtzFFE/VvXymtvmeRJnmsn4BnKU0uoRCl32ac6zfGOo0z3HOEHfApTNhee9jMU1k6URpqZX7rm3OoQgcPe1kwpHDOEMIgA8ORGWbmXTk/zHqOfX26GgVwO/syaeJV8iJAH8XeEu0tM6NDOjJGIsPTHa5VkDCyT3cd4j+42hw8J48N3Td8IHLt6BjfT13Y8WqUj/gF0KAHK+t1d0ius59bujunGSU/5Yl9aZXEWlujZkE7JvuajUTbaoTaoBSV7p80DvHypf8Ct8LOzx0tqEdE3r4gOldzdA0ME4SM/WZfMGmhtzvA+wWnHldY5GMGglFdnocuowXoG0tnD3ohojb/J2yeUxKuYiSdHhTa8SsbJQRqUSj8k0RoNvT+eZOMmuSqU9D+uoHH8nTiDPJqB+QmwUze2gzhsZbjtdV15yQ9AhDOQctn4wJO0XRHdEWPZgt9b53AqlakLFRDzDcaa81Ptwutj/mZaQN9xQ+7liT3A+uw91o2elrnvd2hMVEHX72mJjY65v3gxcXIDYghCpLVdhOFux79eHK2/WT9tMNlbhVQrCGD65RYzTihn+UIRM+xJSZILSERG6BNpMzm8ZfLk/weYMfgNAwYez7/eQcv/xV/9oQT4H38nbHBXOxDl46KviAipCbr7Tw4PCnhgmCyOmBCpjRecAje9Nwf7RYswYhusuuI2RDJjsLi9lkcfCrHWWaSiS/XzXoIODjals9sPlv1Ft2pFV/QHVQ5D4TSoGzQtC4NatOnTRoDn6RNbc8s+cTE0I78IHNffZvxpgvVXp2GjcifBrYOuyuNFHlr+firDPDAGeunJD+ktNwSCcDvm2Ma95rEPu4jHYUnP69CTI908uGVfPtBiHtUDG199ANatg36zubbWKKMNXOUMoW98M/ONgSfXdHqDpAu2kI6r7Pi
 8rrbvCm1
 vvIxD0doNrotTT6PT8rkVnl68smVpOQw+6nN82BAkCVsw9HGoK1KPyK5skE4fc29y9PwQPCUJoiZYPl3Erv307rRyRPvCg7SjCk97Za+c5y3tfyjNjvRLI6rHBdCilX2zj5bw48M2pneFk+9imIFMQNHLHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KDIR currently defaults to the running kernel's modules directory
when building the page_frag module. The underlying assumption is
that most users build the kselftests in order to run them against
the system they're built on.

This assumption seems questionable, and there is no guarantee that
the module can actually be built against the running kernel.

Switch the default value of KDIR to the kernel's build directory,
i.e. $(O) if O= or KBUILD_OUTPUT= is used, and the source directory
otherwise. This seems like the least surprising option: the test
module is built against the kernel that has been previously built.

Note: we can't use $(top_srcdir) in mm/Makefile because it is only
defined once lib.mk is included.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/Makefile           | 2 +-
 tools/testing/selftests/mm/page_frag/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index eaf9312097f7..bb93101e339e 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -44,7 +44,7 @@ LDLIBS = -lrt -lpthread -lm
 # warnings.
 CFLAGS += -U_FORTIFY_SOURCE
 
-KDIR ?= /lib/modules/$(shell uname -r)/build
+KDIR ?= $(if $(O),$(O),$(realpath ../../../..))
 ifneq (,$(wildcard $(KDIR)/Module.symvers))
 ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
 TEST_GEN_MODS_DIR := page_frag
diff --git a/tools/testing/selftests/mm/page_frag/Makefile b/tools/testing/selftests/mm/page_frag/Makefile
index 8c8bb39ffa28..96e5f646e69b 100644
--- a/tools/testing/selftests/mm/page_frag/Makefile
+++ b/tools/testing/selftests/mm/page_frag/Makefile
@@ -1,5 +1,5 @@
 PAGE_FRAG_TEST_DIR := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
-KDIR ?= /lib/modules/$(shell uname -r)/build
+KDIR ?= $(if $(O),$(O),$(realpath ../../../../..))
 
 ifeq ($(V),1)
 Q =
-- 
2.51.2


