Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38AA9D5E370
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 864F96B008A; Tue, 16 Dec 2025 09:26:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4C96B008C; Tue, 16 Dec 2025 09:26:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707C56B0092; Tue, 16 Dec 2025 09:26:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFA56B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:26:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2011C60240
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:26:46 +0000 (UTC)
X-FDA: 84225560412.29.1C420D8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7C5E31A0017
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:26:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765895204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=42yEBL0g13BTQ7OeZHmVLjRebvqOOGdm84WPkMKXM4U=;
	b=r4G6sgEYI1E1+MrcNcHbLIGjAnfKs+ZZQ9LNfNy893JaRZCr5Rx9l02Wi2NV1bviJHOxgV
	/deKKvwG4c/A4RNRz6wdMe+Hruw74CKkYZbSzoTFCz9gyfREhS4VJlT82OBlcwgrDKA5pJ
	OfXt6wzcnKx9FR2BD+pobJxMFc7sfEk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765895204; a=rsa-sha256;
	cv=none;
	b=uR7sisDWAtvXW5v/zQH86gYzYlkMXCu/sEvfTjes1hcjfByTD2ZojEw/kLZZgxfEopdBek
	OMZNofr2+OyvP4/MnoU2ibE9/sSX+N2+bPU5fJwplb7E1qRan3blvs89q4NVdpwV4IMVU4
	X+ibfGblmwlR65U/BIhRrvjnUOReC1Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66CE41516;
	Tue, 16 Dec 2025 06:26:36 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C36F83F694;
	Tue, 16 Dec 2025 06:26:41 -0800 (PST)
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
	Shuah Khan <shuah@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Yunsheng Lin <linyunsheng@huawei.com>
Subject: [PATCH 1/4] selftests/mm: remove flaky header check
Date: Tue, 16 Dec 2025 14:26:30 +0000
Message-ID: <20251216142633.2401447-2-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251216142633.2401447-1-kevin.brodsky@arm.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 54s8h5jdprt97613rb8ejpu3drjnqqz4
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C5E31A0017
X-Rspam-User: 
X-HE-Tag: 1765895204-318950
X-HE-Meta: U2FsdGVkX1/O74LNldmrdyxnrb9Ja75Z8Hcna8I8sncd10PimgGi6xkkZ2EW0SnJDXoh3fSe3R6T5klPmD7Qv8xLVsRh5uT7dPYaE55Qq63la0Bg4ke3dYRGy0qBpI7JZogvvnP/cXyYaK4yBSwfJ9TArmISmb0UO1NmZl1la+P+F97RFpoUkWP6EBCouLvhKBLdKSOMPMan+bAKsjHFXCzT4YVCYqySfzIYiTjIXVgoeD+6kJPhhfshjDexgTQ8kqneceurRVfarTbhD2BtP8WeuN4K3K0nF4OuNLS7a67pydxa9tUNcavK9ict0tYX06aab1JwTD7qYUOowYVujs1cU9sr2NN4DdG8nk8mPZmQdqYt6l1O4Pin4myGtjO9l7g4h50hYkbxgCEcPsKfrydlddm71M0kuNnI17m5E4blD0fW3AYS82bSjfRy+DLVXhSPN8DvvGroalgsMI+OMnmOh9N4WLiC4xGiwE0oAKbCVEF+UqPoVau1yZVHuehvsCPy+4gg0UNm4/3GATKl6mYcGqpbz3W3JjiAm2nGgvee7Lu+2Fez4VLm63cBbrEpqq1bneSqOdQDAoZe8KPLtB9qNWKIiwnuPr0f/agfBJlrc4+2KBUMW1wSOlu3zu7K/7Hnd9XxkzVNfQd/UrjcQDrs2ZbmGg65ADC+OYii6+1ndTTBGVkdklFt1/sWnqQyXWmRKqGseQMINV7oJn97KNMxv9/93Y1m5d5myNfUyALW5xE3GH6AYgCpCnybN4cIfZrcM+C28yOyWndQGOLL0WnnPwog1AJ5p+CN1bC3V9JP+aPXuKiVGUqKMQvmppUGFYBOWcaxKRjkjcB+si32zzfR7C8N9ch5kzswmrRX9d2UeGNbV+NZU1+3tFdFHsG6iNFuR18MaS2Fatvu2Ne9F0SrZF70mVDPDcpB6sxp5Ofsg/bSL/hZrJeFBCNzTym5Pa4Qh1HjM4L/9AT+Khs
 PpjSq1kS
 rKDKZZmGPTh8G6/Oc6mrbCg7lfJHCZS5ce7z7qR6OEHILL01WoSqeVrfNu3fTicHyGqeP8mkNb+P8WIk9Rs2TTOrCYclrEv9YMEdO6XQZiwmWcnKASbm02t6SVm/+CHHplxuoNC7qhDP6L4ceUdBgOj7TJ+L2RU1h85IO3OgCGRNx76Pvxu83hdfu2qC91VM0UOlj39UUZK0k/RY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 96ed62ea0298 ("mm: page_frag: fix a compile error when kernel
is not compiled") introduced a check to avoid attempting to build
the page_frag module if <linux/page_frag_cache.h> is missing.

Unfortunately this check only works if KDIR points to
/lib/modules/... or an in-tree kernel build. It always fails if KDIR
points to an out-of-tree build (i.e. when the kernel was built with
O=$KDIR make) because only generated headers are present under
$KDIR/include/ in that case.

<linux/page_frag_cache.h> was added more than a year ago (v6.13) so
we can probably live without that check.

Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/Makefile | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index eaf9312097f7..aba51fcac752 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -46,12 +46,8 @@ CFLAGS += -U_FORTIFY_SOURCE
 
 KDIR ?= /lib/modules/$(shell uname -r)/build
 ifneq (,$(wildcard $(KDIR)/Module.symvers))
-ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
 TEST_GEN_MODS_DIR := page_frag
 else
-PAGE_FRAG_WARNING = "missing page_frag_cache.h, please use a newer kernel"
-endif
-else
 PAGE_FRAG_WARNING = "missing Module.symvers, please have the kernel built first"
 endif
 
-- 
2.51.2


