Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA466FCC9A4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6E3F6B0099; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30186B009B; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BEB26B009E; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 586226B0098
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23BB81603EA
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:44 +0000 (UTC)
X-FDA: 84528361008.16.A6272C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 79B6AC000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WROYJi3p;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773104742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUSquLS500T5Qa2yM5Tf2vpBnjnAIn+yIsPspZOsWas=;
	b=7Om8ZZc07HjbZ+SeeSGWW1ne4ft9Rozm5z+ujDZY6Na/GTeEAUtC2PKr3C8ZTKyoDeqMRu
	wnMR/Bom8grzLo5wZqdMJCSJrXdJJB6mVdwKah/Hyj5Y4MGxhyzYcUlA9AWsmNTJeVmoKv
	uaQO3b7Cp1yw9irrF6yGmUyuSqzoOck=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WROYJi3p;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773104742; a=rsa-sha256;
	cv=none;
	b=LqdhOy9gdO0EBYP+og1hDUokk+ROMt5m4k1WrlMjbBqu+42e9estiB8ZcqapzN8gh9eLxD
	3w44XKRcxlmwbjgn8snO/BePL1x3anw6KgykISAaQS/Qmey74wYN7YAAoc++fwU7ETYr4H
	DjbYvnozgD3qJS6qn+sSDgD8LE1F8Eo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 860C241A0A;
	Tue, 10 Mar 2026 01:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A064C19423;
	Tue, 10 Mar 2026 01:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104741;
	bh=pVuHdsiSK2hSc3Y/sliHzMztEBUolq4unjdQPlB02FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WROYJi3pg0s9YWJLtb+YkNLSNrzNt3u+ZPN0u5lL3irj8Sy28JYveAk4Lu1PnS64o
	 8JI9DNZvmkX8CufiB8zkHDzzB+EmakY92070cqRJWTX4NdIJf3iEnSGR6O6OSONmOB
	 TyuDCBrXCcOl8T4PolU8RlQV+0J1SUX5r1rAEo/i3Em+4dCHZxIcSSIpP/ZTlhxpp4
	 qQaci1MxArBksMyUq2EDe9KhB7UVYn8TVaUatqrYxvnGx8fcW4Cszai3cArqlcmTwO
	 nvWDvL4/UbwL+MYsk00wG7bIf8RpXxJGjzz1unXbzx12hoLVQ/hT4K03FnZuFX9FBw
	 BKwY05JUwjLug==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/11] selftests/damon/drgn_dump_damon_status: support quota goal_tuner dumping
Date: Mon,  9 Mar 2026 18:05:26 -0700
Message-ID: <20260310010529.91162-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310010529.91162-1-sj@kernel.org>
References: <20260310010529.91162-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 79B6AC000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 5yt7zy6pepcroirupnr7csc3hmomdqi6
X-Rspam-User: 
X-HE-Tag: 1773104742-985928
X-HE-Meta: U2FsdGVkX19zYXLvEiyS4G4nsoMHz0WUHuP6ATzYJo4ALnUKaOoP/LLwhhqhtKY4HkA1LHvIcLPPysXVuQgVJLBR1Chq/iWcu43qKFnWSsXVzyGUISqxUNxJgx0A3WiYJBsAkxdoN8PHUWOT3vCd4rJw0y8HQwZiws/SEUNO9eXvZS88IDeexBhZtHG8cb+Ae1VB027BowWcmFF2/dtWWd40cEnSWOnHfAyMMaf0Evw5NNuyKvpDt5LGC140r2I33EkUUhPsfNPJvnacL+8411dTFVPsFbBLoAp2UoUiK8DUzpXgodAJHHnEAzlb5GMeyQg++odOvszSI/jDcXizDN4K88M+WVW9AMGthiOQbGQOWEJ4CRrnzghPqGVD/JoK5C/4Dj9DO2PlgEJKtiih/zNCAwF7/kMZkN0pG2gmL6ltE52nAfSDBgEDe4mm8N7BWct38kKljPWYYQE8TH1jbTsiz3omXjENwMZZvS4/B0y28PihfT+8zmbn06a/li4gJDBp6gwC9sBWNKzNl32IBPx2zLxSpw+MEZwh4pPznoVeIVzep5tI7BQG30VSAJpKXtSwQJ/vWWf1MFg4ahGJvDi0Cdh54IwzKFHhA3Y4QT89k5AE9prf5YZOxtM8+vwN+iKlR12/Zn2pdeDVmaA0aIDr732mT+GmfTUC5K8GO8FLLheOT92NNe1I0bC9qXKkMjfRT89K0tWE0WilCdYAazi5SoRNqDGdtSkwgEaZQDVZ5FtXIGOmiprmBTn/F0/l97nX229jUb149jkWfKZ2ygpZE/2nDN+ztVjW/w1vv+l7HfGlYS3DEKWbmgQX69dbGJH2qjhjRyP05O4+DfyO94CAkpJV92VsMe0OH895H/9VA9sqoU5v8Q8YMiXOgkeP3W2RPpnIT5Zra2burR7uLn54PylZ232hfn6ZwtYmvQpasifuf4GBf40uQHK0szpmtkmBqQ5kWlgxmk6UPbr
 v1PysOE8
 nKkkdNVKxJLeHUcddKwOblvHh6NKmSwEbAfLmljmTtagsWRhTBc1encUXXka0hVmScJPGfT1zDc4vzFLjFABCamM1xsSTtYc8Z3HqTD9ilLBKWgQQ3miEK16sjVbY88jFMc7TZVcNKpVDmW+Pr2naS2NKmX71gUt/Y7CHXn42UgSdeRpxjM3khOF9KQVmAN1jL9n/I9rnCBD+15s4oqaUPWzpS919Uhcd/T5a9ri0nwz78FEULiPRrvdIRWCfKl4lr2sCEk8GChrZ0yzqCc2j7KZ658k59FR15rsr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update drgn_dump_damon_status.py, which is being used to dump the
in-kernel DAMON status for tests, to dump goal_tuner setup status.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 5374d18d1fa8d..af99b07a4f565 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -110,6 +110,7 @@ def damos_quota_to_dict(quota):
         ['reset_interval', int],
         ['ms', int], ['sz', int],
         ['goals', damos_quota_goals_to_list],
+        ['goal_tuner', int],
         ['esz', int],
         ['weight_sz', int],
         ['weight_nr_accesses', int],
-- 
2.47.3

