Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B12DC53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 09:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11ADA6B0096; Mon, 27 Jul 2026 05:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EF396B0099; Mon, 27 Jul 2026 05:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12C66B0096; Mon, 27 Jul 2026 05:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C600A6B0096
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:52:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E897806A8
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:52:57 +0000 (UTC)
X-FDA: 85034092794.28.4F8A66B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id A7A4AA0011
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:52:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qNR9YuWb;
	spf=pass (imf25.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785145975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rd0B+xMqYU7yZqp3d00Zbxu7mPAoVbrBmGHPMYc9IZg=;
	b=ZWa1aVZciH5ayaVmvKLV52fB7hc/vAT/rWlrH7d/uXaliqKvgJAZDJT1BNeMf+j46i2WtJ
	P86krGX5qUXLw3Sk/J1J02jkGF4qOCsutLDFhRJGgh6ln0+eVHHlfXZ5kRABI5Yg1UULR2
	WDTIbcnoVwgwzwOO3KS6qqwPojtOh9o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785145975;
	b=cOrr50KB5ZXQXVEbcUwHvcp6M3Xbafg4GRTKpmp8V+ohqdQQsnpi2PAyM45K4QHw9gEovo
	y2kqYAT18m9Jk98lVP73stbgFKL3gN4cRBJ9IvA+pd+ECJgxi+z6W48pEU3aJca7GdC5sQ
	GEArxOawEnDiBhJlRNvWnhh55U6aD+c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qNR9YuWb;
	spf=pass (imf25.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1D98143D;
	Mon, 27 Jul 2026 02:52:50 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 80FE03F66F;
	Mon, 27 Jul 2026 02:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785145974; bh=CrJxTUZLpeHCf6pBdIZk3EbePlnhQUeH6RGYCRGqc/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNR9YuWbJxmMrqAEfagfEbMBUtNmJtMBnJ24m+v4cS4MUu8ztH1DunY/hg/P/J0Cm
	 y+tmKL7S8wBm6LoOKOSGiqhB4eJRYOEjutPbHS/zDdkAFIXaETZ+el8DjG9pc/6xPh
	 nTnHkR7guUjJAQvtVNZ67JNihMWQTtw+Kt5i7DBQ=
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
	linux-kernel@vger.kernel.org
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v3 4/5] selftests/mm: skip hard dirty page-cache test on NFS
Date: Mon, 27 Jul 2026 10:52:20 +0100
Message-ID: <20260727095225.372655-5-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727095225.372655-1-usama.anjum@arm.com>
References: <20260727095225.372655-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n9oorjiqggnsykef7yn88tu8k7jhj5fu
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A7A4AA0011
X-HE-Tag: 1785145975-797631
X-HE-Meta: U2FsdGVkX189dfXsnb5kRB9vUf4upS1nudWnesJnij06gQMHTqSR8JQLiksm9vwkqAGdmG7awoJAe3mYKP+DFYOIi7um2zX9+G6uoU2ySJpmdn5YKPulTTaMFklTfwHzDhDArlqZNbF+ZdUqh9nQICNrr1TmnJqRiRKnKTQk+h90MbpryA5pqEJe24SKmyfhvIEZ3+qu3O4fmrZhVx/WnPYwvnbGg2R4dYWDjcvmPYd3Ti0keRvNynr+8UA0H05sU0BOS8xXc2nRNMvkcWCgQ+eDJ8sDArUPnjITeRFERC7d8d/sBmJbW6jQaOaKt3AtbnZfzAgKEXPqDFPPwUcpSZ3xWDLoSmCdQJsoxu+A8tnFbDPtHP/x21kAoWA38pxKRjP+QfmGO5rMchkMX3I0IInPbeQ4O8QT/ZRmG4eu0PX2eeMOKyGEHiXXPHSuK01GcnZ95JRoS1oJFF/Y9n2CY+zf5Dfk+gzTVbr4i+enIiGdEbBPNJnR7BhXTmZpDiLjZUKHznjIAoBkpXVI1+E/F5AppmXQYjPUfTiAc25qt33nibDbaDrlf/c9LJGvDQrlqkG64i2f4ySnURctJYReRDRK/XxM+U2GkJI3HvQAFECm+m/PU9wfgSUYF5Q2TFGL9aRNOLFHv4mtd1/UP2qe50VylGdNYr+3+8ktSKqTc13tto0q+1v+ubUlSvfCFdI46hi9XGjf8bAzUqFIB7f04jnXlW85HjCt9bfEe9ujbOJ5SHIfgXYwI9GA7Z/njj7wh90pMS2/cve7MQvlscKC7456/BIgkwK7oTAvswOJYUGjrl60PQ1AKJpab1mE+UEUhVa+FWtIs0h5gcl99AIrKSFiXOofQjTs3Es9c01ktYtPETc1pA2FoFnhMwX8DWjbNykmcQUGNxpymptY6ZAnsfC47G7Gpty/zQhHqAzSP4Wyx5Dk6Y/Aud0hrnep1opBby7v2cQO6ZyN/iewM+R
 kr46kbiF
 s6uNQsPoTyuGtA2t9oKow/zEiG8skMNUjval6b8uvwx6qI1Hz6EFlYiPSUmc7c8A+MQpC6A6ccF8/oIR73UEWLD9xo4k8RTuJgmJuCzeKaHva6b7wTjM3TWT2q1v+UjY+jPg2UC19Ki1AXFKOYJN2ZnD3TEZQEuP8SIPXx+91rFgHTevapbdEYN4zBQsWzNpp+0U+uMXmilT+Ms9r1XoOjpSJ64G7galoR08EdwRZfKrT61eHW53jH0u33NsJHNv3a+YfkcH85qavhzh+WyRafZndH21N8NVnHsRgTvAhROAm/n+bqR+yJnanJoaKm5vYvixDEvS/WT9QUMbOvEY0gqS3Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hard dirty_pagecache variant uses MADV_HWPOISON to exercise recovery
of a dirty file-backed page. The recovery path records -EIO in the
address_space mapping, which NFS later reports when the test closes the
file. This makes the test fail after the hwpoison checks have completed.

Skip this variant when the test file is on NFS. Keep the hard clean-page
and both soft-offline variants enabled because they use folio removal,
invalidation, or migration rather than recording a delayed writeback
error.

The unsupported-filesystem path in clean_pagecache() also returns
without closing the opened test file. Close the descriptor before
skipping there and in dirty_pagecache().

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v2:
- Explain why the hard dirty-page variant is skipped on NFS.

Changes since v1:
- Limit the NFS skip to the hard dirty-page variant.
---
 tools/testing/selftests/mm/memory-failure.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 032ed952057c6..5d00aab31f9b5 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -283,8 +283,10 @@ TEST_F(memory_failure, clean_pagecache)
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
 	fs_type = get_fs_type(fd);
-	if (!fs_type || fs_type == TMPFS_MAGIC)
+	if (!fs_type || fs_type == TMPFS_MAGIC) {
+		close(fd);
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
+	}
 
 	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
 		    MAP_SHARED, fd, 0);
@@ -325,8 +327,16 @@ TEST_F(memory_failure, dirty_pagecache)
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
 	fs_type = get_fs_type(fd);
-	if (!fs_type || fs_type == TMPFS_MAGIC)
+	/*
+	 * MADV_HARD poisoning of dirty page-cache data records an expected
+	 * -EIO in the file mapping. NFS reports this error on close(), so
+	 * skip this variant.
+	 */
+	if (!fs_type || fs_type == TMPFS_MAGIC ||
+	    (fs_type == NFS_SUPER_MAGIC && variant->type == MADV_HARD)) {
+		close(fd);
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
+	}
 
 	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
 		    MAP_SHARED, fd, 0);
-- 
2.47.3


