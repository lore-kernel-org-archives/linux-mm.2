Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ACFA606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WEUhYuHY
Received: by kanga.kvack.org (Postfix)
	id 3172B6B05B8; Wed, 28 Oct 2026 04:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE9E6B05B9; Wed, 28 Oct 2026 04:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2048E6B05BA; Wed, 28 Oct 2026 04:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F40F16B05B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:10:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E843C40C0A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:10:19 +0000 (UTC)
X-FDA: 85371312558.28.0DA316D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3807D100005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:10:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WEUhYuHY;
	spf=pass (imf05.hostedemail.com: domain of mchehab+huawei@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mchehab+huawei@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175018;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G8E1MJWzV3M4DJYjKtp16uZzM5Zd7LJCU2Q5AuhHszs=;
	b=kgCywe04ub6CSpm4HVDqDeCfNfp6mkH3Pkj4tcRdfbVFXh5J9qJAG/biyYv/af8q7pxbVM
	t2xVIrgWq0UEmur/Al7F3Di28NnVd++PqUoiqCp0CcWWYot2XnlzTAFGoe5Wx9SBvzhpkE
	0iYZ6utSsg+yxdqgvv2YV7T4jRvNSyc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175018;
	b=GrZ7DIl+ggxK2MdOtP8LTWf78XPYxB64y9Q4rkZoR/dsdK2Zm0D1VSzncNkgljBnhPBam4
	TDSS3kLYydvO7UtVmiRNiQghSNYG/y5yzzFlphDlrXF3oZ73x9ZVHysLDA7PSDZMqsIngs
	metoZDMJ8fXj8elkhw8ozP14gWOA3SI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WEUhYuHY;
	spf=pass (imf05.hostedemail.com: domain of mchehab+huawei@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mchehab+huawei@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7516143EBE;
	Wed, 28 Oct 2026 08:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5846C1F01825;
	Wed, 28 Oct 2026 08:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793175017;
	bh=G8E1MJWzV3M4DJYjKtp16uZzM5Zd7LJCU2Q5AuhHszs=;
	h=From:To:Cc:Subject:Date;
	b=WEUhYuHYvzgNxhMcu+LW59a6z0bIUFlxI/4MB+VuPikwaZjJfz7gteMZ8GzeKP3nr
	 imioDUKwKv8DQLkaZy95QnIDB2gr87JipucfqSR1u6huvnmIJS0AOKUtdkM/9HNYPe
	 N+OtU1Kamcdww9t1EdJxVTHpppbNxNdia/1y2XtVFGC8YclRjYfG2LRYqoXj9mVyam
	 d+zKh+Ehph5wDeBNqkctaX9677G66BMlYsV0tFMao3u4PMoWNhscCy3r6THm4lq0aq
	 r6C47zleLXT2O+zFkjyiQ93R0zvHQn2XP6F2K53g4z+k9DH+xEWbZ4dJqaGXK8Dwf9
	 SC2o2PcvbWprg==
Received: from mchehab by mail.kernel.org with local (Exim 4.100.1)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1xLyjf-0000000ASmT-1TDu;
	Wed, 28 Oct 2026 09:10:15 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mauro Carvalho Chehab <m.chehab@huawei.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	zhenwei pi <pizhenwei@bytedance.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH] mm: memory-failure: update statistics before emitting the trace event
Date: Wed, 28 Oct 2026 09:09:57 +0100
Message-ID: <d472a9a3ccfa8c0359d7d7acabed92c8927d8e47.1793174996.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3807D100005
X-Stat-Signature: r5wufhkjimp81duigcaqcycm5wug4pu3
X-Rspam-User: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793175018-225768
X-HE-Meta: U2FsdGVkX1/JAAWgmfRH1VgroK7HPdHwsG6+Bov803UtGjYwKRg2vNDFGOM0Nq+wOXka1es5o1An5+xoev6KZBAzTRjI5WVdjtxkfOIMP3EPbkVqdIfXd9UBLQA5lPXob6EnPA+WwP9rJbJPS3sroNg6I485VQjWFWGldseudMwy3VHUUZNYfegtT5bixFMoZ+4soxNqMaEAn7jGE272FTGxjMVBzON5PQdVEpKBnkEDuiDmX3Q5Xutf6G0pfaDt/TNrRKna5vpH8NPUYPHMRP9IE7HDsUAvfRTFSBJmcUtRSdf1yzRPy3qVeYYlChIJanI1xPYz8+GDPOOCvD5mDEQx5V9uRi1l76K0yd9cIneoFZ0Nj3vEE/TyV5X6ofo6so7aZHfCrB739rJl3EMCfFNeHoivMr1KCtAgv3Gtc9ptdp1/G/9SwLGabnrXb82L0fV1mpwa1KZA8b+JFyOe3VKWjoor9rVx3sY6WHX1gDZ8vDLfydLONGzLIpFcXbRnxCHthx6jU8jZZfMl5QbZhadbno1Sp6g3CWYi8SXjHKsjZfVWdOaQLk9DOva7kL3k0nu+Twlss/SCoXKUzIgj2q5TWV2tDbhkEGKvcHniPNuWfkfbznpfQsreluTqjFEfIKgWBTZsDg8yyLcw78kofF8nlO4e3XVko+WzRvMF/ICfWF43SB5WJdUypwnez8Lc7QtgASwUuZ1xFZ/wO2tGbj+5bTvl2uGWQALvuMJOo0kIWGpbNCurfQ+HzEjuPepA1jIuRkM3TLJG0PSzc4GPEhaZGoCosBb9+FIZIyi3yl5kzu4ziliRN+SVAzaf5QQsfgbOq2vwmyMhMhL8G64q5wE5V+YH7XVO1Y1J6HeoE42Vc4OvDHs5zpEjWWNhKqJ8n6Bb3JqmqwYYJczvWH0A6ZSldo5jMwZl9X+aVIthYBJ04dY1ZPHWER/1BR4kBhAt76QSvbFIZAVy5oRcGPD
 qtICXAFm
 1+deHzX8IIYYaty8IicjO6SNPzQ4exOqxrBpq8c5Qsa2pRAc+lpxd5XCq26yHuauQ+JtGzr0jw/3T9bEOYOG3hF07jMW2cikhKdjKwJD3DASmqRdwO4VLhLVCehl42Hxceo9EuG0abzprC+ygbjR9T3HrIDUcUU931jrKk4Yjw2eI8usiUI09R16XXpeVa6OBJCpEbV/TDBZSnJuoT3FFDDkgZeWWG96iU670jpi99M0CHXU1FcQh2NSRyfdivYxEnZUOTXRkYAfuKXtt0LYuyZsLV5pElmnTKJ6iXJTy7KPuOIQLa+jsaEIEqmuZWVh+v4usS6Go1Za3XX6E4gXvZihzjBgByw89PFN/0M0XIhho7r+8roKzZjKC+QQvP3lJar/6ijCJOcdYVCLM2Q3AC1VA4kuWSZDjuslzfAOb53jM8bc57tn5ANJtJ0a94c7hBj/nW5oRIGFYHNpoxChLFkVppLRw6eyuY0HbK3JXzIUPuqPnOL1b+/a2MiZ5Ureoyb7RuQASzBJBPJVhnyU+bQ7ZXXmAFLW/oXJgfdE9eKB+Efbieqn+N8bGPw8YPd05Q8rq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mauro Carvalho Chehab <m.chehab@huawei.com>

Today's rasdaemon-ci run showed a race condition at the page poison
logic affecting userspace (rasdaemon): action_result() emits a
memory_failure_event before incrementing num_poisoned_pages and
updating the per-node memory failure statistics.

That causes userspace to read /proc/meminfo to detect HardwareCorrupted
trace events to warn if the value exceeds POISON_STAT_THRESHOLD.
This works most of the cases, but there is a chance that the value
not being updated in time before libtraceevent notification is handled.

Root cause is commit e240ac52f7da ("mm/memory-failure.c: simplify num_poisoned_pages_inc/dec")
which changed the order of updates.

Rasdaemod-ci run up to Oct 27 worked properly, but on today's run, it
failed to get the HardwareCorrupted data from /proc/meminfo because
it was updated only after trigging the hardware error event:
	https://mchehab.github.io/rasdaemon-ci/failures/20261028T035110Z-40629018388/daily/aarch64/consumer-poison-page-stat.html

E.g. it failed to log this:
	rasdaemon: Poison page statistics exceeded threshold: 4 kB (threshold: 0 kB)

This is important for rasdaemon, as the consumer's action monitors a failed
threshold before poisoning pages. So, if the counter doesn't update properly,
it will end not poisoning pages at the expected threshold.

Fixes: e240ac52f7da ("mm/memory-failure.c: simplify num_poisoned_pages_inc/dec")
Closes: https://github.com/mchehab/rasdaemon-ci/actions/runs/40629018388
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 mm/memory-failure.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a8b03e2920ba..eba6fe1dfdea 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1281,13 +1281,13 @@ static bool panic_on_unrecoverable_mf(enum mf_action_page_type type,
 static int action_result(unsigned long pfn, enum mf_action_page_type type,
 			 enum mf_result result)
 {
-	trace_memory_failure_event(pfn, type, result);
-
 	if (type != MF_MSG_ALREADY_POISONED && type != MF_MSG_PFN_MAP) {
 		num_poisoned_pages_inc(pfn);
 		update_per_node_mf_stats(pfn, result);
 	}
 
+	trace_memory_failure_event(pfn, type, result);
+
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
-- 
2.56.0


