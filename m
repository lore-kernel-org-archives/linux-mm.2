Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AFA6D4336B
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 04:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700856B0005; Thu, 11 Dec 2025 23:27:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1A76B0006; Thu, 11 Dec 2025 23:27:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7C66B0007; Thu, 11 Dec 2025 23:27:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BE086B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 23:27:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01B08134162
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:27:17 +0000 (UTC)
X-FDA: 84209534556.09.EE2236C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9162E40003
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:27:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765513636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=n8na/ke9IE9q1bAVsI7+ErdZjhBbX1mnOYIQbX9UWUE=;
	b=rn3MMfVDiFVMXInXU/+c5gR98lWGQfUCx9lwyOjpBAmeyfymOJwva2sSj2Bv//3LqDpLXT
	g7/I8ootuOUg+G3+X0vEjUkrk57B6Pe62iJtzscastFFxMu1pVbPBoojnJ1mMwoN7w1plH
	pPIyF2JNK5lKisk2hYio+GKtsfT38oA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765513636; a=rsa-sha256;
	cv=none;
	b=4p+mwIFN40uVokwZ7jIC5sroUpqi2Dkdx3OOwkbmoFoya1PVnivClBFdvM6wO7l4N4bshC
	mB0hmQJPfhm8yI96GMSaG6kvBUjICNyWDESuF+K5L49Jl56kTuSxV0D//WEhMyXbnada12
	r/MSCKPFDKMsJLvBLjUYi6Nnq7ImXpg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 516231063;
	Thu, 11 Dec 2025 20:27:08 -0800 (PST)
Received: from MacBook-Pro.blr.arm.com (MacBook-Pro.blr.arm.com [10.164.18.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AD4853F762;
	Thu, 11 Dec 2025 20:27:09 -0800 (PST)
From: Dev Jain <dev.jain@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	akpm@linux-foundation.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	cem@kernel.org
Cc: ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	shijie@os.amperecomputing.com,
	yang@os.amperecomputing.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	npiggin@gmail.com,
	willy@infradead.org,
	david@kernel.org,
	ziy@nvidia.com,
	Dev Jain <dev.jain@arm.com>
Subject: [RESEND RFC PATCH 0/2] Enable vmalloc huge mappings by default on arm64
Date: Fri, 12 Dec 2025 09:56:59 +0530
Message-Id: <20251212042701.71993-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 7qrpa5firzq6cpmzdegjhqpd9pt835ay
X-Rspam-User: 
X-Rspamd-Queue-Id: 9162E40003
X-HE-Tag: 1765513636-933174
X-HE-Meta: U2FsdGVkX18/sXcAJmbx9DrOoCpQOOkncAn23FmvGbjrEoplIRbiBvCLma7rwmXRrIhddvTd1Q/OGXx2/ErU3QogG3GLslP7+dlnGmISBJQpSJJdTsBowAsIu4Rjft/EKlnSNP8OjGuUq2ANApJSe+e2z0LPQWSOiK11sPbEmETDLx6YDyCVs1cj+CupC0EAipsLfg/fu17yilclZlldCRwG9DbUJ0+YgPkzKnzjWTorClboX8VhaHUqi9jj4Ax1aufPvYU/taDf9rvsRTPPh/WjpRW+5fh4+8uaAR5OhLs/S2GYumZrQWhOKtPuN+3CY4nnng6w0MG2ken+mDemU4edkENO5xvz0Ac5pmSR+WjjH3foUXxdWBiUvPzn/k+YhbXsPbQfqB5RrewXGtS4c5NT+2VwVSxa4UDpoaYPbaHjP/FXQvMTiVvQnZUZUJyZdfSKRhBBDaROjiCh+oHfOR5LQfJuIqAceS3T/H9voem5wMLSFNLB4PvQHXLVNubuxS6aCJvANnWfm1BJ1AKQs5qQtWxpa64lo6EyoWjOQtm0bhlda8d/5sUwMLTCnENSHDAaYFogEpHw7R0nvCcJ6vpM5h2QcAZn4VCtDY//XDfQ+2oOhT6FpYn7bF0uqQW5n7rsNaWf6Ex5xHHr/2XhRlMPDX/gX9etl/jGt4RkPUgfVme+s/YkfZ0jsCzpT5lUYus/hLsvg+wiM+BAJiYMy6DNWqRW9y1QiOStGX0yhQ38ZRBHBIoV2y5DSZXeCo1uGnvpP3jzfTWzB0//Pk84ZU3+0ran+adDXeectNwpXdF20olFhGlKbMKxkR8ALJZqFO6wJJEA7QWZLenw66okx8j1sRHwn3cKE7bifL3raXU82F3VGk6CP+ix5eVYkiE2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the quest for reducing TLB pressure via block mappings, enable huge
vmalloc by default on arm64 for BBML2-noabort systems which support kernel
live mapping split.

This series is an RFC, because I cannot get a performance improvement for
the usual benchmarks which we have. Currently, vmalloc follows an opt-in
approach for block mappings - the users calling vmalloc_huge() are the ones
which expect the most advantage from block mappings. Most users of
vmalloc(), kvmalloc() and kvzalloc() map a single page. After applying this
series, it is expected that a considerable number of users will produce
cont mappings, and probably none will produce PMD mappings.

I am asking for help from the community in testing - I believe that one of
the testing methods is xfstests: a lot of code uses the APIs mentioned
above. I am hoping that someone can jump in and run at least xfstests, and
probably some other tests which can take advantage of the reduced TLB
pressure from vmalloc cont mappings.

---
Patchset applies on Linus' master (d358e5254674).

Dev Jain (2):
  mm/vmalloc: Do not align size to huge size
  arm64/mm: Enable huge-vmalloc by default

 arch/arm64/include/asm/vmalloc.h |  6 +++++
 arch/arm64/mm/pageattr.c         |  4 +--
 include/linux/vmalloc.h          |  7 ++++++
 mm/vmalloc.c                     | 43 +++++++++++++++++++++++++-------
 4 files changed, 48 insertions(+), 12 deletions(-)

-- 
2.30.2


