Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5DCBD0D143
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2509C6B0093; Wed,  7 Jan 2026 11:48:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199ED6B0095; Wed,  7 Jan 2026 11:48:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BC6A6B0096; Wed,  7 Jan 2026 11:48:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E50606B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:48:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B20E9B9379
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:48:55 +0000 (UTC)
X-FDA: 84305752230.10.57D43F0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3F28C0012
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:48:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767804534; a=rsa-sha256;
	cv=none;
	b=a4uy37jeqjNasfLcIEAvJs1hUYyPJT1M9UqYF1vDi4KVOU1VyYKuXE9pI6dgp6gZf3izKL
	Y2GGUB0BqwgdguHBBvbwcNemcxRSxJlSInIFqanGx1uHUSuBACSaVaZCm2fav9A7SwjFZM
	n9KB35zKP+85Eq4fED0xqJeECavlSQc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767804534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0U+zWZUGdoCsFmLWnVOesuzbCew+/XQohymiBZWHJr0=;
	b=eSFgXzltH1hm+UlTOEA9Hn8H19ZedFv6yyD+EYyXIp2QdYOJEpF5IJ6Q8aJaV3vqfA8NP9
	1NMrHkgWnzbhyXg6kDzdaRsv5IlXNLTMmzrC3L7k4U7rrc5pD68XWIwkjM4502oBQMyV3g
	xI/yoVm8u0oVK+mtKi3mop9bdkIkkQg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5ED81595;
	Wed,  7 Jan 2026 08:48:45 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 434633F5A1;
	Wed,  7 Jan 2026 08:48:51 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH v2 1/8] selftests/mm: default KDIR to build directory
Date: Wed,  7 Jan 2026 16:48:35 +0000
Message-ID: <20260107164842.3289559-2-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260107164842.3289559-1-kevin.brodsky@arm.com>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F3F28C0012
X-Rspamd-Server: rspam04
X-Stat-Signature: bwpwmps5xuj9of9nr5ogu451uxbqdd4c
X-HE-Tag: 1767804533-580039
X-HE-Meta: U2FsdGVkX19DjeGE03chPHd7x167W6m9xF/BtWc0sXvTPeXDzbPHCkWsWyUl+qgGqKpfQ/dYyFdNqqAjuO12B6qLnPQEYoS0pfn9LwTelK/uOaaHCb4ehI3j+Do2QUMGzEn/hr7tmZeHOzwfh8qimWmRnyQTuR9z10atnBTV7k7NNBGMa1ajmNzcOnyeexYaOmxc/UAqTn4jaTiExulWy4LzAA+VOS9VWdS64F2ugwM3NWfQuBFcEuEDwPEDTQ6H4c672kmqg0SMZONpLuBzHJDK2sjKFb0AaEi6Jw3KeFt8uUXC5Tylhsf9BgF7q3GwbBi6SLCIs4ui/9W3qzPmKD+0bRwOrZSWAdtroxsj/xqDKu5uZR+l9YZJ4Zphwth2Bk3yv+idP9HLH8FVceL3L/yzT+r6OdSL6teouG+7UY5vuOO+FSy2vnW34Rn7EaczKTeA3kyCLMsJxbhSugPwAppsCbX2yf3aEKMQ9OptVauNYnrwzjbw+cKmgspAEjN1n6yHAw5lrkcgTg87NTu9+KQjknwpMaZYxd++Wg7ogn2LqY623A6aFQ9/2ZVEh4egQaH77TLCFE5/e94mV5gosd4IWbCejFxIUkAzuRzQRUqqTAKyZOsvVe4sdfzHJiccnA/+15qw8LMb5uScQ1idKylFk3fakdCdu3RGZGxnqhkEnKj4vELmaNgoSv2COO1J+Pj7WxHqS97L/XdbWaKYoNQvpZCeFRLCu0Ww8pi9SU8FKIsB6d0UDCjJuI7K+ded6V/8KfzD3eR/2gqPs4UMqLcRU2NDnD5dy52N82tPoh+MWfBS1l8Jo/4hKN9Xut5QXlzB7TfqhZ+s98kSZnVATnGftTpfHr9Es0kTuTLVKghspU/bxJ74ay32VPzhwDnM3xnf0v2Dxy81Vp1JG92RUMChhl1fDtG5AzPPtm3J6l+HuW2H18LOy3Hi3uXyyLRFirDUEz7/fPpCb0e/uNR
 A+ZFrSNW
 Jrm6OQIh337Fk4cKCa0USZZqnTxqTcvN7v+8lwZDOol6tvy72fPLuBz4HcJ6JLChRXI9K0Z8KHrgzqrX9cGex3lOi7IT5ETRPn8yCl6y8VB3uGAoa6daThe1yxpzLNS4aewrBvF1RQzMJz51lXnn42UyDtg==
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


