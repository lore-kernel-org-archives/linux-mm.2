Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B311C5321C
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 09:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33C256B008C; Mon, 27 Jul 2026 05:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3145B6B0093; Mon, 27 Jul 2026 05:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251E86B0095; Mon, 27 Jul 2026 05:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F230A6B008C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:52:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AF2A160656
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:52:46 +0000 (UTC)
X-FDA: 85034092332.23.DD3F089
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 93E0640002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:52:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iIc7Z3Ml;
	spf=pass (imf04.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785145964;
	b=iqwg9Y6ErK7B6DYTON8ka1r0RE5/TH4osxd6zmau9sPYTIwo70DpAs3F9+B90Blje0viqT
	rQnmybhS5b8OQTYGf6HWCav+yqhPCJLnIbu16QcrJm0eI09400cC2I6i4IDkW0IjO8BZsX
	28oIRNbQm7MPjNQQW9bMxy3xVvrqmzc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iIc7Z3Ml;
	spf=pass (imf04.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785145964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9B0AGZfQK2J8HufoOdi7PTgNMGb98FuuGJF+jylaU4o=;
	b=zBo4cnQ3QncX7+qEWI6k8r9Z2XhSUlOrKBGiRQ20ge4ZGd820TV/kYg3DISOvs+dVP58bg
	D856BWVvN4kgEeDu7t21FHyttSzbE7MjJN9Zpa+flgrUzWdU7fEeJYwovFp5/Mok9hPS9v
	WYF/zLgJ+G7vTYmamtuSj2gWVqdDi8o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C5501476;
	Mon, 27 Jul 2026 02:52:39 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1A5B33F66F;
	Mon, 27 Jul 2026 02:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785145963; bh=EfYVwz+NK1/iRlKs2gYESBuvvKYJIJMJC6PoEmXo+N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIc7Z3MlZSpfscuHOD6pQlnPmTcsCZp486z14QnbD886/xkJhQfbXUGA2lBJ5HVu9
	 q/jcXBZc7KOHWlhPP30M82r+wISwGV3Fjg7d6B22QyOuNFlXeDv2CrnKdg4qzB56Py
	 p13+wIfCp4/1ePx6gqovNmVv2P1RSIBTEAWKSjPI=
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
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v3 1/5] selftests/mm: skip COW tmpfile cases when fallocate() is unsupported
Date: Mon, 27 Jul 2026 10:52:17 +0100
Message-ID: <20260727095225.372655-2-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727095225.372655-1-usama.anjum@arm.com>
References: <20260727095225.372655-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 93E0640002
X-Stat-Signature: yimojtr54gugdqtjmerfx57t1i63kjgb
X-Rspam-User: 
X-HE-Tag: 1785145964-563177
X-HE-Meta: U2FsdGVkX18+9eklMjd0uzdFem5EKgeen5vUmTxEKi9x3ub7TuTDC0l2ztxVVeZmqgjgy0LSUaZen/5FLcnXoMPco3xHqzX6M4rq022aFneC8a5IWGOE/dO71f7di57H/ocRNNqTX7PLNUeetq4ZM68/mK3VXklG0TVgFWi7szAHh0twrH+dxRSg9TVJOcr3RAosiIQau0+GTAIMAcdj6Da2OeNt92MWFYQMVyTVCyMQorQHKoYaGfKDdZKQu3kV38WYw8WfK5bYZYxkgI8lIiNVCvfAmB98ZReXPHVhXZnr4pO4LW92xpTAW9j5ruhWFUaUlm1M+oDl/x6Hdg+e2+ZCOShq91XaVmrSlQRRBbdUiaP876oR5c5RTAdz4gDffa7jqx6PHy7p3fH6tolmRN7Q4K9CLP3PGQsxl1Lu69obFwI182Chp/b9+OD537lMvX5jqI7/XOxH+bt3g59scRVtHYX1GDjAhIhj9jvWTq5bfFdgtnQRquLs3B7GulDXgd3ITXFJdnDYRmyDEavqcgaio7i8uoHS0q9hAgXvYos+o1kdXdjD9o41YTrWOnSwuRMqxyddXYSFOX96mJ25PGfqmWWUI8jAfLivSGs8Rd9foxt/r+ZY4nOKdaIij/WQlhTxFzCSNuTT3IfBiEjeIFdqpMHhzhufbX+gcvarDN6Al4u6yHDA2nvDw0MXZzvqCohcI673nYd997Gtwu2PzKooeiv4UAiNL10UN/J6Yh4db1gnXGyzcxhgxhj9ritZmGAZOWNHNUQxkZ0NIVz8i2kDtQMtxJbVk4rU2WLzs1bRFtc2awGTxWWkU6esgHZZJ+rnqoc/LzlR5qxaPzgepP1AU1qFwxieg1boMVJzmlmJahjcTL1qHvXbzRGhfi680fGhHO9KVNQRzbqJVtSXZJJusXVfmUug5r+0LeHyXYGDqlu4L0ITGZwG6Z3LzXBqlyB2fz+VFoYpWsr0CiW
 vgXBCrbB
 7QxWxOgVRHuV/ErokeXgmeuYY4SS2qlaHIxHQnrv5Y+bMUS1TkxqAZUouC5d5ROn33/npX5tamsWWuu8BdRo4TYJRioNpZAiWgAnKVDdl+lNreRc5ZKH5SsWVQrrKrXpAZ0ISeVTyfFVgng7p0qArvoBM0N+VDFIlg8zA1uxw5B6hkRTjbmY8jgceIFaZ8oMM5lQyfreeKUytnDPFe3yFcMXfJECcf0qwTYoJ03g8RSrZI+khsCioawYW19O16ci/qrGi2BU1KV7eujwz/DWtRjVxHUhohTi2qWtTB3SKS/hXSA5rMFg12v+zrIPbbP3rNtXq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The tmpfile-backed COW cases allocate a one-page file with fallocate()
before exercising private and shared mappings.  When the filesystem
backing tmpfile() does not implement fallocate(), setup fails with
EOPNOTSUPP and no COW behavior is exercised.

This occurs when the temporary directory resides on a filesystem with
limited allocation support, such as NFSv3.  Reporting a failure adds
noise because the test prerequisite is absent rather than the COW
implementation being broken.

Report EOPNOTSUPP as a skip.  Continue treating every other fallocate()
error as a failure so unexpected setup regressions remain visible.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 tools/testing/selftests/mm/cow.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 0c627ea89ff7b..c1b8920e29342 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1718,8 +1718,13 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
 
 	/* File consists of a single page filled with zeroes. */
 	if (fallocate(fd, 0, 0, pagesize)) {
-		ksft_perror("fallocate() failed");
-		log_test_result(KSFT_FAIL);
+		if (errno == EOPNOTSUPP) {
+			ksft_print_msg("fallocate() not supported by filesystem\n");
+			log_test_result(KSFT_SKIP);
+		} else {
+			ksft_perror("fallocate() failed");
+			log_test_result(KSFT_FAIL);
+		}
 		goto close;
 	}
 
-- 
2.47.3


