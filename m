Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82F0BC531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3226B00A6; Fri, 24 Jul 2026 06:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C026B00A9; Fri, 24 Jul 2026 06:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E886B00A6; Fri, 24 Jul 2026 06:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 317056B00A6
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:25:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD35D1C07D9
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:25:10 +0000 (UTC)
X-FDA: 85023287580.17.125F8EA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id E472814000D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:25:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l+ofVQqw;
	spf=pass (imf23.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ofUGVJlLWxcXU34wDp5PR2noulXYxzV/aOVHUSP7z8=;
	b=dBP5Le6/U4UCALjCBaprSiy6eBR2Fwcfy8cCrbFxr6fjmLWhrI8SWYp3pwKOmcfyNf201n
	88+dU2MR6Kc9KbqtnnjI6ykf2AU69ifvwCx3BOt8ue74nomdb/BHysJFq9GAyt9muAZGp3
	6y2hRfSJ9b3UUjOg1522GqhyakKbMcM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888709;
	b=VxYaijn3eifjnPkBIQnmmxy0QoZUlLuCgkDY4zVBAdzVgsgX6mng8/HklmNd9IQtElJist
	xjBnACApbkZqgzE4Ym3wyqdKPNgI25TOcPSS3kDNbFaomlmq7yE0HVHFTsbnmc7a7lPUuJ
	zdPCLm0u67pgKxCB0VKxuMkvCg3VAiw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l+ofVQqw;
	spf=pass (imf23.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 283B51477;
	Fri, 24 Jul 2026 03:25:03 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 997B43F66F;
	Fri, 24 Jul 2026 03:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784888707; bh=5jwfmfxf7oRAwU0+Iu55SZwsCJdmgyHH7m7BYSAM9vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+ofVQqwbTWimElc9Yq6VbYs+ZIY7H/dk9jj9QdtduerfU0exNqtADXcl7Ebywpv3
	 ZRiV4zFxTvg/H56JTHQbkwdG0aSB2CzrzuiXcTkiB+MAedDF3R65iR6j6/O1IqiMU6
	 4xRa+d0vS16w4oWbEFctoDR7kk5Vb0gqzeyrt0C0=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sarthak.sharma@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v2 2/5] selftests/mm: skip guard hole-punch test if MADV_REMOVE is unsupported
Date: Fri, 24 Jul 2026 11:24:25 +0100
Message-ID: <20260724102431.1199519-3-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724102431.1199519-1-usama.anjum@arm.com>
References: <20260724102431.1199519-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eon3fepbm7uuydspstpkwrnfruw4b9ib
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E472814000D
X-HE-Tag: 1784888708-455150
X-HE-Meta: U2FsdGVkX1/FGbBol0Ev/8jp9Pq4i6D7iYW5C4KV3/pebeHiRihnz7KnzMX2rzuLdxmY6btqyntxfz1EtzX0EEEXIRhOb0azXrUxLC3diBdHcnIhW9eMbvG3RrdsPy80BOBKka+u9nc9tx67rH5hGMQPf4XAQZbdfl1vkscmYZ1iu3rRbcSzytWQn0jHkpTMI5NHGjCc52pgqkT0j71VPAC4LIIJyLE5SEoJ2ZuMPyYdDOgIl19vEj2HTD1o+/NnjHITYOL3J7HfFvK0/8wcZSYkOpjNvRQ0vpB+5FgLekMLuaQDxSCkanR+n84DBYeRMax2grrWGCaFVtvjLonb1waqh7VgjcnOewbu8UmJQbx7/8HQCSq0tY0T0kWEcku2oYR4l62giNMVJP1W2G+PhWUGJeiBW1bwcTMIyfqjCKn38mY1J0lBsioWroJU2gO01DdGYoPNtNif2yDbY0S3zRkyGTLThFsjiOsF4bA1xAKYHcGuj28BgdEpNBvM/mzvM4qQqaTrYGxGY8G/yDV/5bWe9IV5e5lENB0ci89rcTWvqUFaroFxj81D5aD17V/NfWCBK1LENpU/tBUk1pdODGjVS+eTyawuCmEcNfM/cLe+aLVdgYtkw6LHtanBELIAG4bE8taHIndhJgXC+rdE6yjpFZ4Q9gAzOkPNvaVUwJfPVClwHc2amTkOeTXzmpv3oAwXztyGMTnUiqB3B24Y9XehGruOjVCFRGLYwPR/fpKKLyQcBE0vTqfNPA0MTDkZh0kQyBQ6YBr764nZ1fuKMnE4mdkyv5IUN1+1jlbU1fCuGjIYQTS6jKKA+Y/WssyBb4TMDu1Lodyibwc2Q38mYm+iJhcdAuMyTvi6X96IQdJCsg7ZhQxVTm4RfcM2lKoL809qmX7okWXzk3CGty3ODRq36UNNjjeRsiLiskR19LiiJ0L2g5jt0l+8hs/KYei9e1pVBMxNEgzQdSEONLO
 zXq//5ms
 J4+xXqSfU6yQAxkk9vL4VFXXsfrH4+tFiwtEMOwQBTBri0eF2RPIwvInxrXWc6jC6XzQzeu0l4YqEvmk0N7Wg1W3sOXtUe5egz7EYGPCbAl/fdnTHabdRL4cFdM9TcLwC4jpyFEbx4dZB1P2F6tQKRAYi5qFucGAPgPqjzJrAeZK4HTMDIai/91rwmQQkaM240mNC95gYbNPECC1XFN1XdaEy3KF5eh5Ir9N4kRTwx532rYAzMEH5S4mkn6PF5yhikAWRlY/lrTbARFbn41Tp4zIB2Xu13zi4pvPDOJQG0XEQqRV8S4mvxenf+Mce+9/rSg/MFEw04z7vTKYxsKnC7L/TAqS/U19tRZ4Wzq8BVv5iYYI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hole_punch case verifies that guard regions survive MADV_REMOVE and
that the backing range is punched out.  MADV_REMOVE delegates the hole
punch to the backing filesystem, which may reject the operation with
EOPNOTSUPP.

That result means the test cannot establish the state whose guard
semantics it intends to validate.  Treating the missing filesystem
capability as a guard-region failure creates a false regression.

Unmap the range and skip only when MADV_REMOVE fails with EOPNOTSUPP.
Preserve the assertion for all other errors so failures on supported
configurations remain visible.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 tools/testing/selftests/mm/guard-regions.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index b21df3040b1c7..5c8ec3ca75d7d 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -1912,7 +1912,7 @@ TEST_F(guard_regions, hole_punch)
 {
 	const unsigned long page_size = self->page_size;
 	char *ptr;
-	int i;
+	int i, ret;
 
 	if (variant->backing == ANON_BACKED)
 		SKIP(return, "Truncation test specific to file-backed");
@@ -1944,8 +1944,12 @@ TEST_F(guard_regions, hole_punch)
 	}
 
 	/* Now hole punch the guarded region. */
-	ASSERT_EQ(madvise(&ptr[3 * page_size], 4 * page_size,
-			  MADV_REMOVE), 0);
+	ret = madvise(&ptr[3 * page_size], 4 * page_size, MADV_REMOVE);
+	if (ret == -1 && errno == EOPNOTSUPP) {
+		ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
+		SKIP(return, "MADV_REMOVE not supported by filesystem");
+	}
+	ASSERT_EQ(ret, 0);
 
 	/* Ensure guard regions remain. */
 	for (i = 0; i < 10; i++) {
-- 
2.47.3


