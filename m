Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45C6CC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 12:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B99C6B0092; Fri, 11 Sep 2026 08:50:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1492C6B0093; Fri, 11 Sep 2026 08:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00B3F6B0095; Fri, 11 Sep 2026 08:50:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE4C96B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:50:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42EADA021F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:50:38 +0000 (UTC)
X-FDA: 85201465356.18.4EAF216
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5DA5D40008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:50:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cDOU2Mbc;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789131036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=K26NH2ePKSHYqhGfatvyCC4cXl8E+lNDvwOOPUufPHU=;
	b=pPIqll4o0wY+emxHh+J7PI9MoYkIH1jJ7sRLx7Ig+1IDtnO9S/85PAEi4cTK1ykb40ZivE
	bP+bVOTCg0qF19AQ2Zs3xHb6dwqsVEO4jH/DIBu/khEF2ZXHmk41XncIx/ybwR4KeaD3cj
	OsXbEnm0whOTYrSGWtRexErfvDf1Sbw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789131036;
	b=yWUEhZWZyNQQ/QwiblpZWKUqHem1oOitDDjWmEZjnIgg2Y7dySZSVWvw1TSc+TWi98tHNK
	2k5Ux5/HBTwqFQwm0pPfjqNR56Q9N1rtMXZd8hIFZttK8/Qo+9gI8Zj/83BYuyfZVBSqEf
	OdRW3CdoBYeqDAK7p9vhGhk8vJx+xFs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cDOU2Mbc;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFF481655;
	Fri, 11 Sep 2026 05:50:31 -0700 (PDT)
Received: from e129823.cambridge.arm.com (unknown [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3E8FF3F7B4;
	Fri, 11 Sep 2026 05:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789131035; bh=xWtNJUTwM42lJpkUN0xjfcVe8e21SEBz9UB8yrPkMAw=;
	h=From:To:Cc:Subject:Date:From;
	b=cDOU2MbcaEMP1yBMbopyBDyoAv5Zy9emYA9RaAc3TnMstvdkF4LYm4+k+cEnpKQCI
	 7/gQ7+WrMc+1qMOvwOBxu+AXs2Vq3icXGCknW6CgdHvPoYvf7lR0variw/Sne9+SLm
	 O+SKNVnvemrESZxz37YQc/Nlik4oMnL0N1u0LlhI=
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH] kselftest: mm: remove exclusion of building soft-dirty test in arm64
Date: Fri, 11 Sep 2026 13:50:28 +0100
Message-ID: <20260911125028.1268274-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5xdzmeyidyseu4xp3a1djhdbaw6qt59b
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DA5D40008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789131036-687954
X-HE-Meta: U2FsdGVkX1+DOBH1ttxHO0QKLdleqOyvfVmOi13EvJg9wYj7zrgoAm9fWBDVHuQKRTvWKrmCBQ1gFkhCDSSUNiadf5fLYoxje63203UrcjSJlEpTYWnqCPIQhWyZdZvgah09cSXjnFzuXA+2eynFLFYWP/pZo2LKJ6bAu+3PNgeFu4cgx1Axuuon3eWNBDu3XxPC1212rfB1qEBccWfFGZcVlqg4OEr6Tyv51GfOtPRa3gnK1ICGeiBh/tSwQLwI8yXtsZIdSxfq6l6vj8Vl0ncv4Qjxko8Oz5FoWUehix88u6G8C0uXtTmSEXAW8aUJxRqc+N3d16RAIsJpSXxW1Q493tUlAxHHUr+epcbVzWoW5yE34CqLuCJM1CracSTEDsXHY73r9GxFD0YiRKxW5G3pq07gbmlscxS/5LzT9dUpM1Nhz1NIzpDNNXE+0xxoQ8mi0KdOLlJed/DFIOd+DbqogmYZ68BYeKYQAthq/kymPkG5tsLk6mAGwHdid+jMZ+dSgVz/JT8ILFTWaBiPawMLzXF1YTj+uceikGY4XcTeFXIp39Djwg4VqHCY2WVNJD2Pd2xNyQOIkhCDN9sNPVuklmWG+hagIpvRNz3lD31juYNI4Ow1IR+0ee672TYK2DDa/YOUy8ZfkjlVuiKeuK16YdSk1P64Mk/SNjeUNUDgs7YV4RHMjQlHBsGg0tWRuyqXhGhwZvLQ4Ddh0GuHxIrGYaayjgwAnQF0z8OdY6poKdM7eRVleqGKTKtlb2CaR4f6kpNs1xCp+VOd5pxTM4kWcHxLxatQSMufpnPsaVxiGQXlX/LYQBTsNR9CnIdZJBJuVJ+hW4QRhk9kZVKLZTju5u/AXLZ9Pjhm+ThxpJgucv+2NpD6h0L5+EJtTYEpLXt5sTAw4wT8fD1xG3GhrMoEpdCbWDM67Xjn3+vaSY3SCKRJx7SY4tV+6MGWhkvlhY2cjuAl052tRvlLAi6
 kvNsZoZJ
 jeSEyHwbMT65ldPaArHMzKzBL+D3Pdzcz2F9ggNjohV5ef/UZE/NAdG/W74Bf3WGgcCnlCQtSQp8lmPFw20W3FjIt0qwLlyeS1Z7TtklZh3hinns1QnoAlqXDtenr4iq1hJRYJziGX+AU4N/N7rKpWrf1tk2C0NeUI96hUnor0trN229Ny9TCv56VsUF0gs9V5TOdCABBIIPV6+d6gYtSJBS1FGLXQJ3sgbDjmZBIbyzJ0pHT3RVm2o0soJ8Od8eFpkvCRTIPY7N846sK/7q9anM3oxzN9/ziKIJdiynciztj8Bw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 0389c305ef56 (“selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled”),
the soft-dirty test is skipped when soft-dirty is not supported.

There is therefore no reason to exclude the test from being built on
arm64. Remove the arm64-specific exclusion.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/Makefile | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 2d5366196e30..d3e9bd67904a 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -104,10 +104,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
-
-ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
-endif
 
 ifeq ($(ARCH),x86_64)
 CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_32bit_program.c -m32)
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


