Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B13608360D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QB3fYHuz
Received: by kanga.kvack.org (Postfix)
	id B48856B05B6; Tue,  3 Nov 2026 11:39:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B201F6B05B5; Tue,  3 Nov 2026 11:39:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999E36B05B9; Tue,  3 Nov 2026 11:39:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 762356B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:39:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0144640495
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:39:18 +0000 (UTC)
X-FDA: 85394368038.20.E69DF08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 842FE80003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:39:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QB3fYHuz;
	spf=pass (imf30.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=U1lxcS3q2M2BGowz3comI0WJhii7k0j7HI0vK6MSldo=;
	b=Xl1SxI0a26+67BLxynzekMRMsootHPw1lQFUZ4bPvElfK8avsjut4gRXyuU+UVNnGVr0me
	8/R5ED96hzNMCeLzrZYFOYukvcZx/6gNWt9ElwoWo1lxUXFdRlpR153gMCQlB75i64jaYD
	5OPS9sAKQz7jbJWIzTmdBol6gXqVql4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QB3fYHuz;
	spf=pass (imf30.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793723957;
	b=tHxrQmkNaktkf/SWXUj9O5PPrTlrlRfZTbeRFkfBY2/Y9kCskE+BtTo/BZFruLTYBzcxgT
	+xFlcPubrli/5pXJaAu7AOszX+OnRvkQmsahzbqmc7hw288o5F9NwWWIxRT6F3PDR5Gscp
	s5phqYnGdfUAU+3cC4AsAkZQdC5D6k0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17AF8609EC;
	Tue,  3 Nov 2026 16:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4FF1F00919;
	Tue,  3 Nov 2026 16:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723956;
	bh=U1lxcS3q2M2BGowz3comI0WJhii7k0j7HI0vK6MSldo=;
	h=From:To:Cc:Subject:Date;
	b=QB3fYHuzgSfjedcjS0LfcKXF0ioqA65RuwWVlcDg7WpTcczrHmM65uT3k0u4ze35N
	 1E5g9k7+zMPWCdkbQ8+LpnE5KupAvVkmuHwvn9TwMOydXMCL7V1I0mDpb4InEDg3hd
	 E8jAuPwLLzesrFO3mzrZrgYBtwz8C+9WcmDphO43+jGDeULi0kz8NvzOLs84qJMokA
	 QnTyJhatn2rKaNZ5/ZLi6+DgW07p44lT0uOvFfCI9DXkxtb0cHV7wZbGtjzIXYbii4
	 NwBBYMPIDl/Lccj+3lAbg761XffyhwQ90et1MhFEizjNQM+bufgJTwkX9Xq/558TfZ
	 3z9StkXbrR5uw==
From: Sasha Levin <sashal@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/proc: cast the PROCMAP_QUERY address through uintptr_t
Date: Tue,  3 Nov 2026 11:39:15 -0500
Message-ID: <20261103163915.640990-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3uxuw56tspdhrapnkzoqodseiwegi9s7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 842FE80003
X-HE-Tag: 1793723957-914886
X-HE-Meta: U2FsdGVkX18aq/DLp3/5krzG4Y2SDel7xLoy4KraUHfGS4JFpILhA9VTEYrlS1Hq88Zuyy+9wfZN4L3qMVGMWuqBeUSs+5fPf9xraDV3rkv+dck4s17F6QL97wYuCM/opeYSPt5mvP3goAt/PLhUurw17WrWMtMcX0MPuHbwARH+6zhWbQM9si/pVJ2M9gA8Eo1oX+i8Nphja9ehWObLbIvOO4EkvvoLRJq9m/M6aNSEQvmn5AULoznUgtvhsd41q2AEwuZekyG2gLtc/lUDzDyOPvezdeT9y7culU50L9GSRwRwdqjheDnNpHGGugWWd3iMZaDM0kVfUQmH53qsjvw5ztYdcq+eoPUmEqMtOBKewrKiPiDh/5V0367MYXjLipMEihaJDFvUnPdD3AnszZlrc2rwUW7GvLQIjDhEEcuudGXkMZwDG9xmDENNAF9VLsJSBImmM3ErP+5DwbK1oaeW2RHV6nnphU6LqLX4q81fFXkaIGy3TeszUGWxf12zuy6JpSwgGZ3kL4lZkho9O97bqwGOgm2OPvOrI/2Lqgp53U+4eG5YOUD+pXz6HndEhCvrbsOV3wk9P31B3AM07rqpCI9dErr35pQn1YHD3EAmFgQ1NQa1+slq3dFxHNLx7wF8Pj8gD5zHu0ReGlPRxXEIoGmuQUG5vxGg91vilajIawcVIIU42wIZe54TmyUXkgigY3IwdN3OYAb4ZtoiuAnWdisKJfxrXqSWRqgeoquNpkouB7ZIp+Gw5ByzrxKEPEahT7Kxi7Pv0eTIDUf3m3qvMVvNE5ENeqZmJHK45oS8jHBNLo5aaGg/D5c0ggg6Lc4OkK0sHuMNZ6RF/Q2MlTq5Kbk/t/ax663FNGvYNsYolmY0Fe+PHu+qTzj6IrkIpFuXg7/+02ETOcyDSvz5MkwAA+XtIHY+nIzm7g3ttAxuPi1umKgECASZxe5EnGzOLgmzpGD4jocxUFtW+O/
 NvUnrgDn
 dp7SwHjaXQRU1owMFhcxnMIvMj47RpXsGHvb+ONyJUzMh0yOQ9910UkogAA5ivWxLR5NQiEaZKTU1gus1w0Bg5NHeD+uB7jQHiqh4VcLBBC4ChEWWhk/wMoAtH95T5skBAMHR118utx+YfI6NpM4Eue/jYlVbCjiY4kVbz4JKwCL68PQg1J0pDaJywUPsSAP0Q0NIYZI5PCLPZUOsvGcXWB/xpMWqrxQ86NrxSmikHwDPqK5h3OKScfdTqJCjBuZ599ZPylljirIgfYtm2ZDZoOLG/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc-maps-race puts a pointer into the 64-bit query_addr field of struct
procmap_query with a plain cast, which warns on 32-bit architectures:

  proc-maps-race.c:626:24: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Cast through uintptr_t.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
Found with 32-bit builds of the selftests (gcc 16 and clang 21 with
-m32, with and without -D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64);
KernelCI's 32-bit arm builds show the same warnings. The changed files
build without them now, and the x86_64 builds don't change.

 tools/testing/selftests/proc/proc-maps-race.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
index bf4c5073f6fc8..c484a14eb6491 100644
--- a/tools/testing/selftests/proc/proc-maps-race.c
+++ b/tools/testing/selftests/proc/proc-maps-race.c
@@ -623,7 +623,7 @@ static bool query_addr_at(int maps_fd, void *addr,
 	memset(&q, 0, sizeof(q));
 	q.size = sizeof(q);
 	/* Find the VMA at the split address */
-	q.query_addr = (unsigned long long)addr;
+	q.query_addr = (unsigned long long)(uintptr_t)addr;
 	q.query_flags = 0;
 	if (ioctl(maps_fd, PROCMAP_QUERY, &q))
 		return false;
-- 
2.53.0


