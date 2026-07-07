Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E04C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 09:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4D46B00A4; Tue,  7 Jul 2026 05:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8556D6B00A6; Tue,  7 Jul 2026 05:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792906B00AD; Tue,  7 Jul 2026 05:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5570B6B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:04:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9742C1DE4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:04:29 +0000 (UTC)
X-FDA: 84961394658.16.3D28D13
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 382034000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:04:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M8isa4Ck;
	spf=pass (imf01.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783415068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=m+TQGdgxECBNC9OMJ+xs98RGgyR7DvdWTkKho6jTn4s=;
	b=mJyhpXCaq0YDYEbmLyKdiOiihHtYSJO6iUiE77abB7tCkSFx8sJXlnt+z452F8S1RFd7hs
	ayGaKQc0FX1rG8LVl4K4DmFMQWcOxagk0TKqqqTP9g2hPzHSjdasOQqGRbhhxgi7XzXsuq
	mr+pplS1htAfiqSJQ56CpJol3mOXyTA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783415068;
	b=qCEUY2V+15Gfu7bQaV+F/u1B0SjBDwmMEkGkzno9nj9V2EbF/qiGVft19SIKuRK0UKYot/
	new4Xh6WDGdKL0EBEYWLtFd59tLz1FkQN3D/fjnAZcTm9HMVyPKdwjOPlgIfDNln8+0KFd
	+tvnJLcCzrOzWv4EijzDvCvZI4DOouM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M8isa4Ck;
	spf=pass (imf01.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783415066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=m+TQGdgxECBNC9OMJ+xs98RGgyR7DvdWTkKho6jTn4s=;
	b=M8isa4CkZYBjafl35EWfZC9X0rYgK7Guh6wcgOXcHz/PCHUEF5veFk6FgHejJ+BJWsJ8Oh
	ctNwbFncYQbVZiQGdbSU29JimGVytu6g8iMWkZ9W+E4MpfS/FgIrKbJO4Dcp2ZXLK1tZ47
	RuQGpsotgRznbaIpN984ZDXz7oQ7Nu8=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH] mm/kconfig: Drop redundant memory hotplug dependencies
Date: Tue,  7 Jul 2026 17:03:31 +0800
Message-ID: <20260707090331.52971-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 382034000A
X-Stat-Signature: ymnm78qe5krreoxzbe3sjymmxrx673o1
X-HE-Tag: 1783415068-383600
X-HE-Meta: U2FsdGVkX18L5YYqQZuPiYFwDrwLhrxCMVx3tcTYSP/8LmK7Jq0QHV0LB6INS4DIWWtEHEQaeVGrJewzSw0dYbU+b4Y9sS3yqDrOa88qzV7s+JhUaSFEdUQMT3CeZUOKWV3pcS1FuR1fSVAMSTQzhZvDor9RQlPK0p6Do1/u1PGkeOKPMFA19a1vajt1RMajnayZUpvFoGxRYpRhIqeQ/CHNmaQhJUL+iJiJJFqW9VSht0PDg8hfKw0HQnIthsHTMcj6DrEwYW8oBWs+WfN4l0A3kIohyijfXv2qHk+RDePwu3bIRjqfBj1xmUq57bnw91si+QXmOuaJUVtgUyYhQz21QdxNywAjFxN7g1Vh+hRDGPmQmIWvewwGsFFwwoyLdJQO28jaFaXkzX47G//88YRGzODZYmbmd6U9usCk7j1xOF54vGl9aGXrzQb6eUthR4T+Y+rENCLkLFZbSKkkn1+f6MeLgSN3izzctDPjFbWgtaYLddHA3lU+vyRRE1dgTqjXgmIQdgcNAe+IKYU165np2nvvSvhJFyKZRgI8OA6MSekyupE82SCAjyyxOLNpL6eIn6bLgG/epwuQdo+ZFq0U111odNfypY7r/qFhSGEgQrQb/9fdnZNtT3uPvmKxK7Z+ZP5zAXtaMC+K6UFKIhZweRdZnsJOjmOWWQcp6tgw/wvdVnjnP2bG9PPi2ISG5UsVhmm4aPbL91w0k/w7uvthwSNem5Yc29vLtrjZbkFJobbHyUD2vzLUWPHj9td5/5to4ohDGrBJ+MbPx8QZcGPVyje9B2bmQ04WyFQCrZNijVcXjk04b/ZIRK4pJA/kXCX+Y/lRSWWy/ZHwui25lG+4P9bYvYGZVyrYhBtzdJ62pfvNum/PaxuAoPsAKtSk7gXt2yGHU/AnEe2GYur3H2LDz6zzvSUtQMR6wGITUdX1ajjH2qp5GZv1Tqr6t1ww9BwDBDejFU1HyIOMghZ
 MD+PEfNJ
 zT3q40fillHGNGOjrjbtiJPXYVQuSV3tqSJWuMNzHVS/ypUE92LCMiNwO2RAsXqw7CR5U9lCxS/Sg9M2HnNGToHmDWh9qz6jy0ZfWbM6Uc8dBmHt2fNR3TVDwThAoYFJAac2vvpxVLv7v1K3680H2RWestw/oPNct6fP+5rwMAsgB6SkhV1WhCYUvbgpc46vBRhHO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

MHP_MEMMAP_ON_MEMORY is defined inside the MEMORY_HOTPLUG block, and
MEMORY_HOTPLUG already depends on SPARSEMEM_VMEMMAP. Keep the explicit
MEMORY_HOTPLUG dependency for local readability, but drop the redundant
SPARSEMEM_VMEMMAP dependency.

ZONE_DEVICE depends on MEMORY_HOTREMOVE, which depends on MEMORY_HOTPLUG.
MEMORY_HOTPLUG in turn depends on SPARSEMEM_VMEMMAP. Drop the direct
MEMORY_HOTPLUG and SPARSEMEM_VMEMMAP dependencies from ZONE_DEVICE.

This does not change the set of valid configurations.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 04fe5171bb8c..ff29f770d10a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -596,7 +596,7 @@ config MEMORY_HOTREMOVE
 
 config MHP_MEMMAP_ON_MEMORY
 	def_bool y
-	depends on MEMORY_HOTPLUG && SPARSEMEM_VMEMMAP
+	depends on MEMORY_HOTPLUG
 	depends on ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 
 endif # MEMORY_HOTPLUG
@@ -1235,9 +1235,7 @@ config ZONE_DMA32
 
 config ZONE_DEVICE
 	bool "Device memory (pmem, HMM, etc...) hotplug support"
-	depends on MEMORY_HOTPLUG
 	depends on MEMORY_HOTREMOVE
-	depends on SPARSEMEM_VMEMMAP
 	select XARRAY_MULTI
 
 	help
-- 
2.50.1 (Apple Git-155)


