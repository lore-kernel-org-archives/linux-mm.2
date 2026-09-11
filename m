Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DE04C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 21:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4716B0088; Fri, 11 Sep 2026 17:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 295826B008C; Fri, 11 Sep 2026 17:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ACCB6B0092; Fri, 11 Sep 2026 17:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED22C6B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:06:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A90340335
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:06:17 +0000 (UTC)
X-FDA: 85202714394.16.5616BCF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9ADEA80008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:06:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ggRE77ma;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789160776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XNxSeaKPnR1SsQqw6gfSGR6lazRYUQXIpU6i6OvIvI4=;
	b=Bmzp898RQfmywq9H++VyBMiqOVE68N9dA4gXAJcj8B3JNCT1DTEv72u1uX/o97eSOGpmfn
	zBtyJ1qN5P/ejtUN/xnvNcc5jdEnt4xJ++imrUjtw+ADyEQbV7zaon+ZFZiJVEicTdQab9
	x9CEuA6oW5GjqL+phnlzarZpL7XsJvU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789160776;
	b=02oTKnPnxfp71vwMTbPRj/ApWG8CyLMv+tP/45wJimalVxtJNTXPxv9Q8ezlilpOr0f6Os
	typ94OJ0Zy9aEY86QsfUqVgbG3/yyELZojwGkJ39XLnSCwfZpZJPKKx493zbfgksdNrYMN
	8yL6cLYxtGSngYVh5kGyHKin6doK8h8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ggRE77ma;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C62C12E96;
	Fri, 11 Sep 2026 14:06:10 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E03973F8C6;
	Fri, 11 Sep 2026 14:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789160774; bh=Ko4HtAWHNGp2tQS4oxkiTDsisIyPXC3mwTAstW5j2OM=;
	h=From:To:Cc:Subject:Date:From;
	b=ggRE77ma+WZuCvCcU2DRXbCHnE8eEhQnfghWBaubvPG0j7Lkq1zMt42RDbb8r8z2P
	 6wtrYneVI4qutIAc7S4800a8aM4kvE8jtE57c1hJZb8b8Rlpehgf9OLxmOWU8Ws9Wb
	 fsKj6de4XzzjUJv2pZ9DRcQxw8CuOHTbWSKpfurQ=
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
Subject: [PATCH v2] kselftest: mm: remove exclusion of building soft-dirty test in arm64
Date: Fri, 11 Sep 2026 22:06:11 +0100
Message-ID: <20260911210611.4001419-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9ADEA80008
X-Stat-Signature: 1zriagd5ghg3xkccp6hokg4u8i3t3p84
X-HE-Tag: 1789160775-26718
X-HE-Meta: U2FsdGVkX1/8xjzanRbPXW7R+Las9seypWfJ6SYL8j7lQgC0gGtGualyPqFr8VfoXY6c+pcKW9JnNZzheFNPdJ/gRLqKzTAonVIiNDGxHPsUdJ7ogM86Ma1qOAhzNyoqBIhRyYAd7hyk171EHkLxmXAAgeFjIM0L6N/AbSUDL+nt2eeqt0eYbP0ncOX+R5oeD3f2TXsi1uP3f8NHUn+wo5mpyl7exI2wVcnHju0gCP2nSHwMSWKEI72hCQMaQtgG2I8uXfsCTqMdJKHcBX/sH6pMsM5AFiLZ9PUa42BbFhSJFARHxGw8dY/snpOzOm8DkFzyE70Ufm2mQGJO53c1XYl4ksBXbZxSuMoA4pluiTZKTj47KeQDDpyHzjN7ABoB/6GPNXvyqNjmanyGD/2HPRC71fU0Qsyv4aoBikBXHwyaLX0cyocRqDtg+k6cLlRBegWq8iTAZGkXFdWK5jkQeOIfgyU/zqBWRACcHQJr1DinH7u8Y3YjYXfUQtSHfblQD7nvkffCixJwPeaRYX2HfqQOM2u/+fEGVYk9s8Lc3MsiABpR0hBrTA0Oo+45oJEWjCo3HasB3eZaefG+WX8brzpPtLzs7G7Vb/p558m9MOT71f0GsIHhbFNbqGJWfeg/iJ20LLMb/SfnnrFIs1mO6wTAcKy6pME7HgobXxjM4NCUCi191nE/yENGIhaLux/rsm50kzndNys1Gb4O6lJcnfcXtMKYY1xMDCn7nOlWrNqv7FMLIfhEpePZ4D7gXnTitP0Pje0JIjBl2/myNpPReXUwnUduC5STlrklQ93wAyhx07z7THU0WeeGFYQtoVcNK20RHESGftR9uG0jA1Fjb0pwPVeqkvAQkbMbS4gIF2sHYE5J5SuYit3Hw/zXyhDPVf7Ik6zG6EsBoDw6LyTl88wEVLKE2bndoEungZT1tMtAsUZ1b7SUeLUpgwHJ72+Dca7cFy43dVQOVAXsnu5
 UXTHRtOR
 fy2IV031iyNp2SlQjt79aMIz4X33n1i+rcyWFUZ1HwXrfppZoms5TgiwXV9lbolMkg6kuOZuJ0azHZyuL8DmjNeyEZediGrE8XWL0Ho/v8aNZxa7RysP4m1qlvTbQ20YPzntBy6Wr32VXgnTwgx32mFpXFXnxuXtGpSR8IlGsm7y+yCVb8dAV6PNEsfzriLJKwa92iA719U1M/sywzOoRx59byHZfySlQHRBi3O0emGrkJcUsQ8LAI4geO2G5k/MgbNCh4QqDiGn3GDzZOcg44H6Khf5jeAZbBXih0XzLhQfRsvrb0qGeUDU/Mg==
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
Changes in v2:
  - remove redundant condition in run_vmtests.sh
  - add r-b and a-b tag.
  - Link to v1: https://lore.kernel.org/all/20260911125028.1268274-1-yeoreum.yun@arm.com/
---
 tools/testing/selftests/mm/Makefile       | 3 ---
 tools/testing/selftests/mm/run_vmtests.sh | 5 +----
 2 files changed, 1 insertion(+), 7 deletions(-)

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
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384e..33963535616b 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -390,10 +390,7 @@ then
 	CATEGORY="pkey" run_test ./protection_keys_64
 fi
 
-if [ -x ./soft-dirty ]
-then
-	CATEGORY="soft_dirty" run_test ./soft-dirty
-fi
+CATEGORY="soft_dirty" run_test ./soft-dirty
 
 CATEGORY="pagemap" run_test ./pagemap_ioctl
 
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


