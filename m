Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C29DEC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 08:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784EC6B008A; Thu, 17 Sep 2026 04:15:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7362D6B008C; Thu, 17 Sep 2026 04:15:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64B846B0092; Thu, 17 Sep 2026 04:15:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 419FE6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:15:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E962512026A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:15:36 +0000 (UTC)
X-FDA: 85222545072.12.D94DAF1
Received: from mta0.migadu.com (out-132.mta0.migadu.com [91.218.175.132])
	by imf22.hostedemail.com (Postfix) with ESMTP id 05468C0004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:15:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qRqOE7sA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.132 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qRqOE7sA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.132 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789632935;
	b=DtTbmBps9LMmV/WTnwDBbl7ezHb6Eg/CUN1GGe+v7o08w9cw5WPDxNP04YgirCcVMIvrSa
	M4PlhgwfxqliBqMUSRZTc4AmkQHvHFdp7+rR0IGT53Y3j1i02HWRbayDuir79dp/Muv1DX
	cgIJ2XnCPzhUb3x5FGjASRctA0BJkB8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789632935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cGCcgCa7/A8ey2mJvtXKdDl0A80am5ezlJnzsQuD/js=;
	b=PR6s39QDAIYqK3XJZH0ydvJq6EErye5W38pu272c5cjTRoGhtwOqU6nfkeiFFstp3feuKW
	VQUd72OBzSuhiEAgUkAh9RKkrQus6jlnRgUQOoUyoDaLUlR6GBMKPiVaSJFMmsfoWVZMO1
	4nVxJUJxkLtB6kbtHJiLjJqg75bGx5Q=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qeGk3zdozLcG9Sl7yQQPW4sC6MwYHbHe3QIG6n9Q47s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789632933; v=1; x=1790237733;
 b=qRqOE7sACV1CyL5htRmuRCMISU5rt3w0+Drrmfv7A/P99mM7RzIEcjfPUcNnFoUkmNg8DUeD
 4NcpBbCIgAqFlZBthxBAowiuaa8pe1XDoNlsFsIjn/PPbmsgKCaMfGi2aykFgvhNvkmCVnr6VB5
 FUUMVlp96FogY9ZoheiciW70=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f48e50a38c1503ca;
	Thu, 17 Sep 2026 08:15:19 +0000
X-Mizu-Trace-ID: f48e50a38c1503ca
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Priyanshu Kumar <priyanshukumarpu@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <kaitao.cheng@linux.dev>
Subject: [PATCH 0/2] memblock: Remove unused exact nid allocation API
Date: Thu, 17 Sep 2026 16:15:02 +0800
Message-ID: <20260917081504.30426-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 05468C0004
X-Stat-Signature: eesippxrxfffhjoe4q6mswispfue46qh
X-Rspamd-Server: rspam01
X-HE-Tag: 1789632934-12016
X-HE-Meta: U2FsdGVkX19i2mxt29cd0gbYOoymfwqZ87YGVmThwanM6H4k2sGSiI7BGVmfSEc4vkq19ff+O5p6ixkAtdUhe5KDm7FmSUN7hKb4TXpTVQj9dDXN5QjchAKOB6kuyl0efnN24pN/0xHVE7ByM42vR0XAFvG1jizbSn390D36f0+YvbkCk8rxSfSlRxu9i+QuHkndzv9D4k3hrTTO65q7VJSx44CIhmQTRAPtgTKBuw0dc6QP/ikgA5+Np6nxvVKbBWJCH3pLhJSxv1jX/6PB9iQIrzWj5zbEG4k+3oRkxMttvyexGmUv9nP+Azrec/CjVRSn8wVo5np/j10+6b4z8OOdrrQXvx5hBRTRg0Ww3pHJ/wUHp2kjhIHYioIo1IkBjJqsjWFhwHzk0J+hBcKadDYlDecSCN+BEttZmx36EXZhLUTr6t9mJu4r7QMBrYmLRGn2Bl5wTB4q891A00pax/q+ijxLTBfW5+TIzovcc23p1gUH4g6NYYCltxLPcHnDmOIJSYWL5p7wsw+HS9k1ZUg8J06xp2UXDVRDgFRyLsh/WEE6pSRymsewY4cWbJ/KouM/BwTyQlq9bo0cIUjkpykL2544WlQ5phIfmGx1o7U/vGsbCa/uy4tFA2WFrtsgvjs9bjEjeGw3hgliLtxQslP4mXpXfXblkfiBJMXf3PYPOgapQF/VkWlNLO5WpxxS67z0AKzD6yWqWiotT2+RPWBAdBre8x51bmaEOcPwG8q6gw1o82tjpajFWcIh10VBLEg6VQpiFVtkMYeN242zqsFMTBlMZVtKuy63KVQ6V5vzmJGqD/1Z7FmnaxmKZR9RUnw6uPkrM2LpAvLMtgPKYAUnJOXqOCnIWfmu+qDyiJh7tWMCZhPu1Fp9MJv7duLtG09AWhlUd7M4stFFIuLjmX+4gQMQsCQPvaUkAAAqJDvEWimEgFnQ79S99NB8igrlFXgFEo77nZyaeVVwRSe
 shS9blee
 sC5EX4x/oR+K08Abc4NA5Hfv/y2i7VSVpAABMhNgy7N9jSlBv8btMRH7HkGCgGPpVW6L+KhVKMUfmO74m5pBY4iWl84aEUJJbxS0d4ETHb6S8w4JFz2jRe321GTW1zBbOwaarpK0eGuOdN8lXx+3owedwX0+zdqV5jtWxoclvOcyfOdIdPmEaQxCG9xClazH47MwSPdno3ZG79HT/xQgjw0PkAngVzpsHPZI6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series follows the removal of the unused exact_nid argument from
memmap_alloc(). That change removed the last in-kernel caller of
memblock_alloc_exact_nid_raw(), leaving only the memblock simulator
tests using the function.

The first patch moves the applicable exact-node allocation tests to
memblock_alloc_range_nid(). The second patch removes
memblock_alloc_exact_nid_raw() and drops the exact_nid argument from
memblock_alloc_internal(), as all of its remaining callers allow
fallback to other NUMA nodes.

The investigation cannot be extended to removing the exact_nid argument
from memblock_alloc_range_nid(). CMA passes true when reserving per-node
CMA areas. Allowing such an allocation to fall back to another node
could leave the CMA area's recorded nid inconsistent with the physical
location of its memory. KHO also passes true when allocating per-node
scratch areas and requires those allocations to remain on the requested
node.

Since exact-node allocation remains a required behavior of
memblock_alloc_range_nid(), deleting all of the tests in
alloc_exact_nid_api.c would remove useful coverage. Preserve the
applicable NUMA tests by making them call memblock_alloc_range_nid()
directly with exact_nid set.

Some tests cannot be preserved unchanged because they exercise
memblock_alloc_internal() retrying below min_addr. Unlike
memblock_alloc_internal(), memblock_alloc_range_nid() treats its start
address as a hard boundary and does not retry from address zero. Remove
those tests together with the now-unused TEST_F_EXACT dispatch from the
shared allocation tests.

Kaitao Cheng (2):
  memblock tests: Move exact nid tests to memblock_alloc_range_nid()
  memblock: Remove unused memblock_alloc_exact_nid_raw()

 include/linux/memblock.h                      |   3 -
 mm/memblock.c                                 |  44 +-
 .../memblock/tests/alloc_exact_nid_api.c      | 454 ++----------------
 tools/testing/memblock/tests/alloc_nid_api.c  |  20 -
 tools/testing/memblock/tests/alloc_nid_api.h  |   1 -
 tools/testing/memblock/tests/common.h         |   2 -
 6 files changed, 42 insertions(+), 482 deletions(-)

-- 
2.54.0 (Apple Git-157)


