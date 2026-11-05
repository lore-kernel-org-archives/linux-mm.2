Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C14256082BCD
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 01:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UUUFD0/R
Received: by kanga.kvack.org (Postfix)
	id A3A846B05B2; Wed,  4 Nov 2026 20:18:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC3D6B05B3; Wed,  4 Nov 2026 20:18:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900F16B05B6; Wed,  4 Nov 2026 20:18:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63F2D6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:18:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAA4E408FF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:18:29 +0000 (UTC)
X-FDA: 85399305138.15.7DD0BDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 639E440007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:18:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UUUFD0/R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793841508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mQmK1VyNyRInh3bcu1F6pkwNvgg2G6ZMbyKt5yTapqk=;
	b=aERPImCQIFFvuAG1+vCXSgAj6F4Nm3I6bpO5I0fuVZLvfJYKb2gl4YvJcdpwL1qN4TODQN
	+FPaVnq4EGLG3GgbFC0e4qrtWJojaenSWzR5ljHAXqMqn3p6j25UmJd8uLAgiRC49sWwoo
	Lx7trBvKKMHJEACnLfziYx90nmDndGQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793841508;
	b=rLFdzU8IlwDYGzqVY+sxTlpHpNBqdmRyJilXfgwSYqQLS2tTqjJF4QGXMkC0avQ2/1Elxb
	YeYRau/VuizoUkd5mNPhXTP09HeffifbosfbikZBhs4ToumMM9DpIQWPmgmKMJkkh+eM+3
	n/AjaNVkLusnZzJbovMEcMy/nsQu2gY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UUUFD0/R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84F0B60604;
	Thu,  5 Nov 2026 01:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1531E1F00A20;
	Thu,  5 Nov 2026 01:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793841507;
	bh=mQmK1VyNyRInh3bcu1F6pkwNvgg2G6ZMbyKt5yTapqk=;
	h=From:To:Cc:Subject:Date;
	b=UUUFD0/RgyXitm6KMRBEe87kCtHttmgDX46T/atU2r8acWM3dB/s5NllRUEMpNEiK
	 MU6WSNC2Acb8ZjI7ca8uVCP7sKxODSHEukTJoVUU5H5HhkiNUEmceiK9xQf9i/lG3+
	 L3G4RTgZjbY2tRV3wXkdQdkjyzXMhJXESbPL3hTac1K7cWvu6hbHwuTUS0R2gygPLE
	 2wQ/PdHfOtCkuOgpm82s9gSuhZzkEqUkA62y3uHLmGIP9JfpEvCRUPcY8Lpghhv22/
	 htt2GoRebJ9LMjxCGPTc1Ti9LJRFq1ZMviUFBrLHIEEGUPpgH5CR81IGoNiOtRkNAY
	 Hz9QsmJIYNVsg==
From: Sasha Levin <sashal@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: cgroup: fall back to an unlinked file without O_TMPFILE
Date: Wed,  4 Nov 2026 20:18:24 -0500
Message-ID: <20261105011824.1143947-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: up9m1iwb1tdpj5xohcbfa4ytxjq9kpmq
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 639E440007
X-HE-Tag: 1793841508-775481
X-HE-Meta: U2FsdGVkX1+w5bw7N9A0rwk029cgNsr+kyhcn3IuU0OH9lAR8vLcHPULU+2mti1ThdspuXLvoezWZI0VStE6rKJOe4DD2TkOm7MyVh7OEOvtLWD9OOWwL1op8mdZvEgoNjII/XGCjxefZuWfdBD2ax5Ov03FBGerjBVXL0aveCHfj6xtmzeCKmI29FOzkdX+NXGg6uO1NbLH/G+7W0NPVnLnnMn9ZYaIT4fwTXIh0SJ2shhh/HIep5zN6olUaVuzojo3d6X8JZVaszchw5mXT2g6dUBkgEPd0lhGoiYF/afVCyqEwkzwYUdUKP9IoJGibpD9lKnVZsIP9WP5pY9rnnfoMIjVRc6WcL49vTT3t4ZI43OwKToFRqtIr0Rnx1mSGEVWiMzwQmLmNWJrXax8GUfOSkbzXGVySrUf11xdmAiSUJXJnKoXCIdhcSbLJFuyrS2VhdzHf0bti7dZD5udQsEP+iKaO/RBUMJSJ4H4KI2ZtlR/6WTcPWNwwg5ddr0Mi+YPIjtDFaEdttBQ5/k6gtttZl/VN4PeJsxrzfUxtrq3rFwK3fJGpbJqVMJsSHjZGZU0qI0ekQPpmuRmPQtlFrFaDLRvpGED8bVwPYUw+0JL+QLl76nLYdkZUSoVVplC5cQ38LhSGDsHj5AaijLQuJ8oJ3czEb4WERWg/mNJBNjm1aUm5Ywz8z1WWwLUa+HtjYYsaScvCv88/5+njn3vVmPMRJUXKltlS1xoCk0FrU3aL5V+aHJgeOY2fESGliSG3/edqNUt1MDkFc+jjesKv5QFi4Rq2jWSQeSYfMlxjNQotypy6EI55DUG8nnaXd49RLc1TD6EWlyp9xKCS3OqQDJjit4ZXRwjXtNV1Ep9HV/biknRWzIYk7LLIr6v9aPFRUhrhsU7b1wmzbvBZSJdhP0tSgjccDUNOfnr8X6/crfsy77d01x42b5FkO0GZ9wLnuzyxmFBxr1SXMJwwZh
 /TN7YRBQ
 aJgG7n/LjTNuTqfpKooo14DsCNlR2C36dWFQYYuVUZbZXaqICRk35ikth/Fb9lf51ZD123ONG9VGCsT6OG4tlcLl3WjuINj+r/0Oq/Xl3XOhTN9M2oYpc6cs8js4tHaN5JZkJMr+o2BlfPTqeLmiOb9Xmt/aNToDdQY5Feziibw8YITcfm0/tLv0OA8bt5OaeYybcKe2j1PG7oB1ffbaNYhG7bCp/+kQ8gHB7jSEk0+IAJkd19kRcyiQPg+PgaBBb6ySKbsMHnbo17FOIS/GNK58dj4Ekt9Dzo+sO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

get_temp_fd() creates its page cache file with O_TMPFILE in the current
directory. On filesystems without O_TMPFILE support, such as NFS, the
open fails with EOPNOTSUPP, and with it every test that needs page cache:
test_memcg_current_peak, test_memcg_min, test_memcg_low, test_memcg_high,
test_memcg_max and test_memcg_reclaim. Boards that boot with an NFS root
fail all six.

Create a regular file with mkstemp() and unlink it in that case.

Fixes: 84092dbcf901 ("selftests: cgroup: add memory controller self-tests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
Found with KernelCI's NVIDIA lab, whose boards boot from NFS. Tested on a
144-CPU Grace with KernelCI's arm64 build of 05441d697f7f9: run from an
NFSv3 mount, all six tests fail without this patch. With it, they behave
as they do from ext4 on that machine: the other four pass, while
test_memcg_min fails and test_memcg_low sometimes fails there too.

 tools/testing/selftests/cgroup/test_memcontrol.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index bb673012dcf08..7dc9c26628675 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -33,7 +33,17 @@ static int page_size;
 
 int get_temp_fd(void)
 {
-	return open(".", O_TMPFILE | O_RDWR | O_EXCL, 0600);
+	char name[] = "./cgroup_test_XXXXXX";
+	int fd;
+
+	fd = open(".", O_TMPFILE | O_RDWR | O_EXCL, 0600);
+	if (fd >= 0 || errno != EOPNOTSUPP)
+		return fd;
+
+	fd = mkstemp(name);
+	if (fd >= 0)
+		unlink(name);
+	return fd;
 }
 
 int alloc_pagecache(int fd, size_t size)
-- 
2.53.0


