Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FCD8C4453D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51C86B0095; Wed, 22 Jul 2026 05:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28FE6B0098; Wed, 22 Jul 2026 05:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67CC6B0099; Wed, 22 Jul 2026 05:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A64B6B0095
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:12:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 163E9A0E70
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:12:43 +0000 (UTC)
X-FDA: 85015847406.05.9B0631B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6A719100006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:12:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rEfmwAtQ;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784711561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2qhESbv4peGVg5GuMtGS17pHcEkT5xEvs7SuLp/SNQ=;
	b=6k47IjbvpCRpIuy/2Ew6ZoW1/BMr354zhSOMfFcJH7KzT/382vEjlIorzPdMgbMkxB+ywb
	0NIYztItoqVUu+r0QuenRrTdcr4W+reUnvwLmTBVAZWqoafv0zM9B1Y1POdUbHFnN4qAZ9
	1A1OdbO2WeZvW2gbPgG7ijwWww/3VqY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rEfmwAtQ;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784711561;
	b=GklYUd2EElT1meqXHo14zQ+94WC7K7xhty+0psNlDhq6SyhadovmqEN+gUyHsbEm4B1w7L
	VKaIeEMA+AU8VYOjhd2HOpkNhOIHnJ82YmLgG9Xuf1jX5B2pJAOsE4JbS3+BVRCVEg3Rd1
	yU0GKAVCid5zjPi+rL8zc6FbAT28S8U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FED11691;
	Wed, 22 Jul 2026 02:12:36 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 77C063F86F;
	Wed, 22 Jul 2026 02:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784711560; bh=MAOIk6RQMMHP9g8q0wW7WPE1XWmO8u6cAL0GlkkzBe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEfmwAtQp5FzBpgznxbXzbVFSASRpkEAKRKrsxYS6t7OaDOvBhG7lXHIMH9aMs83S
	 5q0Ogl46PYCxE4UsX2On99Aa72x+SQlwXDYDlbWwiki1/+Rwonheoe9fNeCyXF0MUA
	 znm6WmOEtVQtpUpIP2CKY8gH9TW6Njp6WSrckMmY=
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
Subject: [PATCH RESEND v1 4/5] selftests/mm: skip page-cache hwpoison tests on NFS
Date: Wed, 22 Jul 2026 10:11:38 +0100
Message-ID: <20260722091219.61504-5-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722091219.61504-1-usama.anjum@arm.com>
References: <20260722091219.61504-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6A719100006
X-Rspam-User: 
X-Stat-Signature: y1b4oje6541ypwgsym55cka4z51aixob
X-Rspamd-Server: rspam04
X-HE-Tag: 1784711561-637086
X-HE-Meta: U2FsdGVkX1/Mt/Jqj/SHDkp8ll/qz7cwwgjrNxK7mRrpT6CrRuNGiWfc8cXA9OQQ3snb+JjusxwPUAPwRRGpDVJygvY6NkVfjdHzxLykdTD3MpS7SgVqHrCqh+Kt1Ylz03CAJIPQdU7phZiT3X7SSn5l1aRfEOmDTx2Shh5WWOfxjtGkJozeb4I1PLHZHDpT0pTWuuHEDEU6hksSAVmDlNu60umw563Fgu0CmRPVVv6bkGBONIHUZdzG9KfaUJ72D+VmJfnFhR8HBB9O1D4Lv5ZCq4ipOf6v9zMUXg17vdwxz+ddR9SVvb62yb91CG/osjYKfV2d9GcrmS0Nq54Nvop44ZPsIF6/6wf10X0OxvxAaf/IsOoMAYhNF3hasJHJMrb8WTYccXDdK+7Tp/wCQWi3g+LjbDwICUtnkmQ4wVFKlD1GpMn1uwEBckzXbraaXgbktcCad/JIiKyiQy7Gqele+oNBPXb3CkAOttOEicrFABL/tizMB3+y6cJB7r817I3PqgKdjbqMdnd/A5VNk/qK1ND+VUhN0m2GRRr8GqwKD1EuJMpT+IQFhA++JWPOh4fP2tqu7j2rXcx62ekQhuHhovUuQrfXlQla2wJGhFi8N/9uIgy8VIvVzHy0McdKGJbrdRGTsy/x6T7bqWpb8xw3XoB02uFc+b7mQrSdXmZq2B8oIB7CD883u5ipTgMs2Gn0he96DyiNSMKXIwMvC0KQPP3XtuRGOKVSfUDF2SCeZZDy8K/QgVWalLq2PoxKAF2emtWvyLvIqCKjmt8HgWELBj5dSOROzthb+cjtp4Mc0U8FRIAXfvcg5WSzGymBCr1dUy4yKYDS0CTcAY1ag5GBftukYDt9Ir7h9xo7VlLcY6/63p2wMPVIRCE50/jYx0DLAgdp0l8NCGNBxxnXoDHTlvLCkRKC0MmVZ8Hi5rWDKNnQj8Sr/rXNP0ORuBI0d+DjWdqjQVCpcXFDbX3
 FozWNhZP
 ThZ0BF3ZSpnXRv6CXEiMk0H5XBRfqAPgQdJXjG8mThfgwdajhLP2dsANBXPXg52a+YjAlk2dk1UvMfLBEfVs8+Y8HSn8o8LtF1IDVbH94Bv3spqN0kJOOaQTsHsYchRE4326nghE181USBA/nkqRzUT34guMgQ0W37HSBE6BlAO8EB/yF7MqUneGjWREKTLkWa5zW9kDuk3XpvXH43SGpswYTSFy9vuMe+yaMRGAxrr6vBfrgBtucVmkWI1PI0Or+IfiarI+giCHYqwEQqWG6VonaMAPDVL8aZvPsxaLY63BUVzz+PUvxNUIgEzRCbJA4s4jQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The clean_pagecache and dirty_pagecache cases use shared file-backed
mappings to exercise page-cache memory-failure recovery.  These checks
assume local filesystem writeback and error-reporting semantics.

On NFS, the hard dirty-page case can complete hwpoison injection and
recovery, then report a delayed writeback error when the file is closed.
That failure reflects NFS writeback behavior rather than the page-cache
recovery path targeted by the test.

Extend the existing filesystem prerequisite check to reject NFS and
close the descriptor before skipping.  Other filesystem types retain the
existing injection and recovery checks.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 tools/testing/selftests/mm/memory-failure.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 032ed952057c6..2e77f58406868 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -272,6 +272,11 @@ static int get_fs_type(int fd)
 	return ret ? 0 : (int)fs.f_type;
 }
 
+static bool file_backed_test_supported(int fs_type)
+{
+	return fs_type && fs_type != TMPFS_MAGIC && fs_type != NFS_SUPER_MAGIC;
+}
+
 TEST_F(memory_failure, clean_pagecache)
 {
 	int fd;
@@ -283,8 +288,10 @@ TEST_F(memory_failure, clean_pagecache)
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
 	fs_type = get_fs_type(fd);
-	if (!fs_type || fs_type == TMPFS_MAGIC)
+	if (!file_backed_test_supported(fs_type)) {
+		close(fd);
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
+	}
 
 	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
 		    MAP_SHARED, fd, 0);
@@ -325,8 +332,10 @@ TEST_F(memory_failure, dirty_pagecache)
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
 	fs_type = get_fs_type(fd);
-	if (!fs_type || fs_type == TMPFS_MAGIC)
+	if (!file_backed_test_supported(fs_type)) {
+		close(fd);
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
+	}
 
 	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
 		    MAP_SHARED, fd, 0);
-- 
2.47.3


