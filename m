Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D95606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 03:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZRQbI+t8
Received: by kanga.kvack.org (Postfix)
	id DE9996B05B2; Wed,  4 Nov 2026 22:02:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D99D96B05B3; Wed,  4 Nov 2026 22:02:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61D36B05B4; Wed,  4 Nov 2026 22:02:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 699C96B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:02:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0219980906
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:02:48 +0000 (UTC)
X-FDA: 85399568058.15.CDC9E22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7D34BA0003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:02:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZRQbI+t8;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793847767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zGZfT70XyONJWUn47AyDJ+cOnVzmjtxiZaxG/uXFuOA=;
	b=xu1chNV2mB+o2kWZhFEjkVAXzJD0BNVGNoud+VJQxCeOyibMz4+/XdxvHvlWeqkk1shIh8
	sRfJj9kWdiiot8hGtsSagtwbOHzxy2PzQLWiPP8Dgung4Eo9DJbGnAwNVD87Rurrobwnz9
	GPlZ1ToWafp9bGTCLggcgF/BFG/2Ois=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793847767;
	b=qzcR2XNeSz6mO2C+YO15tslVvyZOHndw7rNz4z6+kpEkzjZ11ShYG5w8T/g4KEjKvTd0Si
	xy2I94vneUoaY6xIduCBbtaxVerFfhq+/Aqb42RPY1JqfUxHSlPsU+NJG6AAfiOD5QsmaI
	enb7Mfa/CK+8/vxBHv80ZyVSAuWbsY4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZRQbI+t8;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9787F43D00;
	Thu,  5 Nov 2026 03:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E8B1F000C1;
	Thu,  5 Nov 2026 03:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793847765;
	bh=zGZfT70XyONJWUn47AyDJ+cOnVzmjtxiZaxG/uXFuOA=;
	h=From:To:Cc:Subject:Date;
	b=ZRQbI+t817mQXZkNttd+gHuqAA44iJMUXeDiQIUSXTrPFP/K3YlmPF8OMp6wcehz7
	 ep2l76pxw6rI5FPtzNemsq9Zt8Hvxmlyc/AzpjxVhZd1LZPQFBHkHxxBrF2j49WNCu
	 chDRbIiobEPaUNLWEW2Cmiqj9CtGnquQ5XqSCMUjkVXLQrk5Ti5HFaeBssFD5eneWt
	 z14re8NUk/JAaGvdNg3DWwS3abUODHWy0aAKWNxIeRRGh6dv+a/T6LqWlLEwXQvHVl
	 kbK340AdP6KM/rcyPE46Pbj3IYRNHz0RZ5Mvi30G0+W9t3pWd1V976WurCIiLdIquF
	 LtgHowtaWKWRQ==
From: Sasha Levin <sashal@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/mm: skip split_huge_page_test without the split_huge_pages file
Date: Wed,  4 Nov 2026 22:02:42 -0500
Message-ID: <20261105030242.1241448-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 9dds6zk8douffbukzuy6rujcz81696if
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7D34BA0003
X-Rspam-User: 
X-HE-Tag: 1793847767-3391
X-HE-Meta: U2FsdGVkX18SdCEqRMvepgZfR0TURCFq3AcymW22fVnJyoLjMpGaX/oCsv9yGL9iupwFtk1e1Mo86GsXMcmf8pZP/yuf0N0IZsNmyDfojs54Kl7bjLHX+C9zLlGOJD38wKzylxtfw0j7u40q4dlPbBNWcs8pDN4UxEnq4KZ/J5JfhKQzcobLHs5Qy0Tas0UXpOFSoxQNpMawgZKkXOGaNDp9fekLRZ9KdRcP6J6JsAylKTgQn3C/C8VOugWH+R+f1AV2a+TUguzN6VhJ7+KaCJ3bkyyEeFR/EquXF3KF6K4giuG/WAhw1rmfe5nN6KQuAOw5So00Juj8F/7p200AUSvQvPODDvpgotGmGoHEBa42QbeXkXHUFlaYNjQci1JbqlXqhU0ZSDhkqbVC0oAwqhEAJfeGnR8IrBqlFrUqIOPLIDYziLARxgY0/ljufTO55rjhNLJUp2hy3eLOVxnheISL71LgY/ky3apgFPl3ZSsRxQGelzcyTjEwauCWfS2sr2mVfFigSMM43r6Y93d3mQcMHRJCRYnD28zt1HT4qHkupbZDRo4VCjVXYJ+dGR685Rf+iu63tgKd9uHk55s/Qzyubr3SmCnUdfg2O+0BaBznWVbbSYjV9HKDBN5EK6grkAe+kMCfL+HVSk2Z4NLAdP3SUHVTrGqms5d1a7wjMCxYO06YyINZv1bel5xCetwf7wZyC3AbqJPx6c+GcoYlRmKEF9QXJixDLqry1A5aF0IibhczSkS0ZkkCpxnvP04QYz2sN7ZnFB3stl/RSn6V2+yujE3enD+MFtBWwXd2SCnXTCkRjjzK3jF3uL0WTK8dhTnaN60f2OicxLCGtsZTA7o3ogGpCGqx06ebsheSeO4zb7V08/leTvSKPAR8D4aIYcdD5EBTtxy9nTgp/hP5XEfP2SK9Pmu5AX02fl12b8OaFXXfllBD4pzxJ43gQD3Iz/32nqJRoGHxv/XSFIr
 MVNKyCyD
 oql4WuAJDdB1FW2cnHspJg6Jep8EIIskSxOA18c037btFmUQF9F1s69JKbpA8gIrU3abcfWw6RNv3NNaMt5uhjaP4/yhvxBDS3KVepDyHz+qHYfzBPBUr50Mxr6yvZmlrNclPzyHyEeKHAgolitZwXq9toOTJOWoR//p1vMJ/M2tk/JYczR0jJJBaZQRIMOXenSB7Sv2OYDaaR1YxfdwSDVbnzxPO7xs6s+/v/hs6fBKAsA2+CTB5NOs0pejpvwGEQdmHZeWyS9YWQemTk/AYpLPt+K9foJCTiMER
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every case in split_huge_page_test goes through
/sys/kernel/debug/split_huge_pages. When that file does not exist,
because debugfs is not mounted or the kernel has no CONFIG_DEBUG_FS, the
first write bails out of the whole test and it is reported as a failure:

  Bail out! write_file(/sys/kernel/debug/split_huge_pages): No such file or directory

Skip the test in that case.

Fixes: fa6c02315f74 ("mm: huge_memory: a new debugfs interface for splitting THP tests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
Found with KernelCI's NVIDIA lab, which runs the tests in a chroot
without debugfs. Tested on an AMD EPYC 9655P with KernelCI's x86_64
build of next-20261104: without debugfs the test now skips, and with
debugfs mounted it still passes all 62 cases.

 tools/testing/selftests/mm/split_huge_page_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 33a2473327bb7..deabb7db06192 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -610,6 +610,9 @@ int main(int argc, char **argv)
 	if (!thp_is_enabled())
 		ksft_exit_skip("Transparent Hugepages not available\n");
 
+	if (access(SPLIT_DEBUGFS, W_OK))
+		ksft_exit_skip("%s: %s\n", SPLIT_DEBUGFS, strerror(errno));
+
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-- 
2.53.0


