Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12DF1FAD3F3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC7F6B0092; Fri, 24 Apr 2026 00:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7841D6B0093; Fri, 24 Apr 2026 00:01:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A626B0095; Fri, 24 Apr 2026 00:01:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59B226B0092
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:01:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF5C41B897D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:01:53 +0000 (UTC)
X-FDA: 84692100906.30.677B31E
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id 361661A0014
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:01:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GhFXBDVc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=li.wang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777003312; a=rsa-sha256;
	cv=none;
	b=tX7b4G+ZL3EJHV0vGY1PE3XTNs2mUeRfY0DGbw+Ssw9GaooUK9qv9f7XslunI0sMOWdMxk
	Ia4i/yTEx9vsJB1gmlV7jRJfLILdwxHOqEDhC/83YkqJY0YRxHKLpfiuZ/OrSgsyi90tA3
	apy3roz6/mbSi2XmmR/1hhDJ2RNJxSE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GhFXBDVc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=li.wang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777003312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NtcN3Op0ieChDzZc8VELPGrZGUZ27l8eeX+TShLLBmA=;
	b=tma0DBJc6LyHFhWzdLlZ/r2M9Eu5gRszKX3+CSf287XDkf2bwWBVUOKp/WkGq9M0iNh01q
	NEEjMGqBUdesnYjbWn9YhukpdYfUqXHWLtixT0XJhA6nz955iYpmttqlyvwW5qECQ4xgRY
	5rM1fKB4oKqPPkhT9qvpTFoQsQvTWzs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777003310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NtcN3Op0ieChDzZc8VELPGrZGUZ27l8eeX+TShLLBmA=;
	b=GhFXBDVc38OATu0fbD+/9vkf7VvLtY6ejQzjmVAiWIK3txPn+1XYiQUn40RSMddglsjA/5
	RNJka4bkNve6DrZ/lCG5g5COj2zsxcDHxow+sW+vK27olu8Wi9x0ja6ZYguoSvFq1IiNkm
	zafc0JbOAGCFwLVyOg7t58njxyxgjS0=
From: Li Wang <li.wang@linux.dev>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	longman@redhat.com,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	jiayuan.chen@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v7 3/8] selftests/cgroup: use runtime page size for zswpin check
Date: Fri, 24 Apr 2026 12:00:54 +0800
Message-ID: <20260424040059.12940-4-li.wang@linux.dev>
In-Reply-To: <20260424040059.12940-1-li.wang@linux.dev>
References: <20260424040059.12940-1-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Stat-Signature: tqkwnzdkk64f79k319gcpk5w1rffi3j7
X-Rspam-User: 
X-Rspamd-Queue-Id: 361661A0014
X-HE-Tag: 1777003311-948330
X-HE-Meta: U2FsdGVkX1/TrMTK5YGyBeWiem3huP+WiYCO8JIEUaJK6MPT4df+6wRqMpN/g3xCKCm1iKY9XRi15ltk8NVk2BceyWlPxzqtoiSfPMHh+xegNJnF+03v1xCjjaZWBg8wXBvlWJwXmRU6q1yxUR1Mh5IkeJmDf8e2CtpWqG6VICTW9uN5NH+hZNZOn2UtNi/0qf5q+M/ppMEGEdzZR4aosRP3dgEahD0JS1eFjiwn1TXWrRqc3zqn5YYLFUKRi119tv055+PAPelizS0Jhod/qNRGdjtvOZAmaMSAwp889X2DZ3sYlUKfK995oouLsTxfuD+OY/IB8ZH0oMCobTsuNodesTqN4okH5NYT/GCJbo4WHrkMcd+76gvAOOoqYWByjCB02f1AFrc7Lc+TbmbKnL7aN7Sm2nXYtDTiDFFgxNkyGFqb6ARdzqIVBdgjT3GCgJgPEyA8LRzKrvnZEVHx96BI8bC6M1dYtGzfuhAgro2YrjE11oV03gEks+essGW7r1rg9UqRCD+wq0CN261Ho/hiGGUy/L/Z0PROVea2ubBJ2lWgept8GIhtsxnKCHUMAiUn7L9aFQdlMl5JrpsZgO9ehmXhZ9uIrPY1udh5QJO5nJ8Zol5x8vpua9CNYrZ7vHxCUBzB8Eed2SOVsvUqqJCk67gEEm9yDDRr9pytxAvAmUAm/k7u9BtPC7es324wmsgW5mX18YjSwbzVPbuYiczgf+mjSLoRuoRSfZwhNRl7PUqNyFTKn8WL7rQH35D7/FP8s7XIVKFtvZbpCZXEjIZ0iOz1/J6YAQ8biSFEPAgkXjVx06MUJMOTFH+osZI/syBPjv9Fqr6gKrmmmMKkw2r3NNIWKbusBTHyH8xx8tSR8KyXTLPmZelx7QdZrgF2Fp1bcFgr1E2ftmOtmYE9JwKliD15l80yq1mgFDlO1v5CW6JIGtd9bmgRo4yDOLitgwXYMtqgwYr3Hca+4OD
 6nRa0kO4
 0a5hYab3ANGxB0boGXO0B+lswjLcwMvBJHIBS/JmrKLdcbbh9QPTDYQNzNMRc/B8JF7NrGrPnuynISNMYFpiPCQw0aoKrSjrCK31E/FE5/OrrvEcniTichbOx7JGZSO9tYnEfdDutnN3LZ5EL4T4zlQrJrTeUeAjEBPPjqxMKXyHIYfZHn062HMfURNILX1tgMDsOeEwIw4bLotXcOmm9Nd6HfMVkjCgrKB0axtC4n+8en5Gkmau2b5whRKzXsnu5W6b5GgStji7CepR7/5k5ff9MNAfD8Anwh355UoeJrBCs0Awpf4gtCj0H5vszfjNIAHKgCUCfplLPaz2PSHhGgrLJ/KFPcjuXKj829X5Ec9Crf0LO2mlCNl09BZPMMj483b895gMlevgm1SYrbGTTszmQMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_zswapin compares memory.stat:zswpin (counted in pages) against a
byte threshold converted with PAGE_SIZE. In cgroup selftests, PAGE_SIZE
is hardcoded to 4096, which makes the conversion wrong on systems with
non-4K base pages (e.g. 64K).

As a result, the test requires too many pages to pass and fails
spuriously even when zswap is working.

Use sysconf(_SC_PAGESIZE) for the zswpin threshold conversion so the
check matches the actual system page size.

Signed-off-by: Li Wang <li.wang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 47709cbdcdf..37aa83c2f1b 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -245,7 +245,7 @@ static int test_zswapin(const char *root)
 		goto out;
 	}
 
-	if (zswpin < MB(24) / PAGE_SIZE) {
+	if (zswpin < MB(24) / sysconf(_SC_PAGESIZE)) {
 		ksft_print_msg("at least 24MB should be brought back from zswap\n");
 		goto out;
 	}
-- 
2.53.0


