Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E124C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F4B06B00AA; Fri, 24 Jul 2026 06:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CC626B00AB; Fri, 24 Jul 2026 06:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A586B00AC; Fri, 24 Jul 2026 06:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1947B6B00AA
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:25:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9860A4033C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:25:21 +0000 (UTC)
X-FDA: 85023288042.23.2A414E8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 40E5EC0007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:25:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OAemU0+u;
	spf=pass (imf22.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uiLb/hPfLkVJ5psRv2V8B+8XZ98NCidGcPSUf7cgro=;
	b=ry4yEmaZ0bKZTwnw0ScVbLGgCW1why7m7sADeszNq8bs4GjSwQzQkPghKkGsH2vN0StExI
	8XS1Vy3zZI6yAB/eauvCZiXz5rlAl0B/GlsmBy5AeuwKPpe0LtQBbYkBkfgC11f1SLwW2J
	JXkWyN3gwlc0OjKNghMw4b1fnWZlzlA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OAemU0+u;
	spf=pass (imf22.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888719;
	b=aEO47AA61k8xZqxTTRTwByF+qtOHhdFmj2sWcM9UFlociGzu6oNpIsYo0IJdr6KdrpspuQ
	ep0/bh39Wo8Hs8Wma/yvygJcq7LiON8XcHZm7mAcV0P7DUxvzVJIPTbEb0b2/6W29uiy+A
	QqtsgzPFRztazqFEqS1/6L2EWDdt4Sc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF5931477;
	Fri, 24 Jul 2026 03:25:13 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 03FB13F66F;
	Fri, 24 Jul 2026 03:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784888717; bh=gjhEdojn6ZH69RosJEQqB2oqwaUfEM3sBTnWP0w/g2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAemU0+uVLTgy6K8UI65WLReaYHpNiL+wmtJLPZk5gycAjgiOTE/Slg8yl+Kx7qEn
	 6E/dCgnKnZlagJM2f3tiaG3HG7RVvbVNM+YiV/9fXOsHT4FxT/dV1XnVAJIeyCpWmb
	 CQLc8U/xO8szAlH/Z52w4Hajp2pniG8CCVYFh2G8=
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
Subject: [PATCH v2 4/5] selftests/mm: skip hard dirty page-cache test on NFS
Date: Fri, 24 Jul 2026 11:24:27 +0100
Message-ID: <20260724102431.1199519-5-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724102431.1199519-1-usama.anjum@arm.com>
References: <20260724102431.1199519-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 40E5EC0007
X-Rspamd-Server: rspam01
X-Stat-Signature: ryu75qttdcnu1mwoq9gzd3m68am9k6bh
X-HE-Tag: 1784888719-363548
X-HE-Meta: U2FsdGVkX19oUAE5ZPtqtBA+TuONYgPkuybaP/6sGVnVYhzmFQwWD5iwF7sKFptgBgyPXUygB3fpeUhe3KSzFiqeIPr0H48geSroUd1bOmJ8DEhLLvTozwaPbPRSHn1pHwaND2MO08KaIv3ai6O7mobGZ4FJmXAbrKQewEG7EsboVsMI20qwpyEooeMswZRMiDWvhU4cSIdcKbiSM6bGFpseittfhyeLT3upiL7g76iIeNQXCzvtn2Xwyq5uEvyh5fKgm/t0c0qGw8pr8f+USbd7PSXBXT3ZgzxkgJ2ssdjrYHgirF4UhixtJxUXu0J1vtfewRYg/1ZQ80sjX/vLOICMRzf4Pr/QHEVf2BBmgmPWg2ry2YTTN69UoWobidtI+C6OWjVnLCbhWznIUjTvxV8JEVDyl0iMFrZEopAeoZ/DF/y4Mt86UkQGIGkGBW6pmX78ePEwhNmTHmWzsLOGJaX9vwneiESzs+kctDKbRGhxgIyXDgFswW/2fy2CEmjgYM/HUTV8HJZuaVxL8xFmH75eUCZUAvmM0u4D9Mf3xXMR5NIXWCum05H8Pk7Y+ZVMjeT/nNUYSjnnukOt/Vbm+yqDxqxeLkT+SQZ0TKyN+8pk9vHLxwrbpfSFDLyajNU907AZB0SFqW0bROAvqPoEt16RTNpUXMMBWc1/Jp9lKeOnaPKHp6RHUM/6fc79gga5kkzoXKyO/be427FkBszOERXZzcvh6n6yEYgr+2Ayha9GvKRgdoD2Mrn5moDFt7TKmsSiWD4Ww4bwk1i/XzVUjMLy6mGCxFj24aV+Bs7TNz9sypDudtzs67+oR9GY2s0DaCZ9URNSuHZ39novnaCu6n2n/NBDtW6IiX1ERsj5LVq/pewZpdBoeHo5OxDkOrjHGILtMI1GY1BxXmZxDE+lQp6NFcafEFeHuDnfNzOzSgxRH5FLppSzG8BrmAQFnr/ijXP5Zp2HnBeDfOqKbUc
 Mp5T7gVv
 EtJARz+/rfGXminY/VQcWSN2zqIRe8/CErrTW4dPcc6fu83dkdj+KVbbIguxarAtBAheWa4kULI4nhmPsDi1WZxCAVuPVvhNk6Ym5FVlng/w+wryItJsL8IoY/s60LW7LBhMW/He04SZAGHRAxcC9UwRLPA1cE564Xvw2zh7v4Agjz6ScVIayCRlYhXZjCv/46vW9aElXp7/9uqhBuLJxeDPD76vhLV0HC2ENA8/OfIDms4jPdX12iN/qZr5MVCzK3f3WkD8yv3iBapEWwPnUxqCEgcorHBJ5dXhqY0meZA3jgUCgnNvF5s0niRozmrZvUqAA
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

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Limit the NFS skip to the hard dirty-page variant.
---
 tools/testing/selftests/mm/memory-failure.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 032ed952057c6..3c72084f57e8b 100644
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
@@ -325,8 +327,11 @@ TEST_F(memory_failure, dirty_pagecache)
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
 	fs_type = get_fs_type(fd);
-	if (!fs_type || fs_type == TMPFS_MAGIC)
+	if (!fs_type || fs_type == TMPFS_MAGIC ||
+	    (fs_type == NFS_SUPER_MAGIC && variant->type == MADV_HARD)) {
+		close(fd);
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
+	}
 
 	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
 		    MAP_SHARED, fd, 0);
-- 
2.47.3


