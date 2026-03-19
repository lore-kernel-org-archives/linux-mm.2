Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCD421091901
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3624D6B0570; Thu, 19 Mar 2026 13:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4C56B0572; Thu, 19 Mar 2026 13:39:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA876B0573; Thu, 19 Mar 2026 13:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0CEA66B0570
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:39:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B7F311C10D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:19 +0000 (UTC)
X-FDA: 84563524038.11.C228384
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D0AA616000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f5P5ZND+;
	spf=pass (imf08.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08dKphVfSTLtdpNxVh0zM+lKvwtD8+RfKPGuI2AqB10=;
	b=RxkORvdtKtssqjLiBun1NjG3rrjam8YWtWv8GmQbIfds5efA5KMy+qmrcoxygYULLujHfE
	NEAqWmBg9FKD4aPvcTuttc2jno62IapLUgDB0SVTOg5azDGGZFQZQR5q2SYTJEK3UjcKpt
	W5ulmzAIsHTKVyS1d9KpRM60p0Rniic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773941957; a=rsa-sha256;
	cv=none;
	b=4IUkLfmHkgwLw4ujS/Bi6Xc7vUUP3EHi832NIGtIOLAYl3L4cx3vPnF5OSB5ZcmNNiX2eR
	VDSXq1/6mTi1u9RWgxwddg461ZAcuelkd7dbnOf0I0IHJfarZyxTkQvzNol/o1BJNroKRc
	X8CCp5CmnoIia4hsW+kQUL8sHAGpsTY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f5P5ZND+;
	spf=pass (imf08.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773941957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=08dKphVfSTLtdpNxVh0zM+lKvwtD8+RfKPGuI2AqB10=;
	b=f5P5ZND+eHGi9J2SQSdQzHmoWZknxXnKlXEx29ciAwbYF4huSSRrd1H3O9hyo+mfuTgiVz
	+X6ai4CTGll2yHSZeQ6LCcBuEi3rUQgDy7elNp1M2+bb2RCJpmRI00wkmxilgwtIje2ubG
	Zwznj7h/KAv6n/Q93Ao53ZTlfakf+eQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-212-FclM--_NPeiuVWdz8HznfA-1; Thu,
 19 Mar 2026 13:39:12 -0400
X-MC-Unique: FclM--_NPeiuVWdz8HznfA-1
X-Mimecast-MFC-AGG-ID: FclM--_NPeiuVWdz8HznfA_1773941949
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 525641955F6A;
	Thu, 19 Mar 2026 17:39:09 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.80.194])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0FE4130001A1;
	Thu, 19 Mar 2026 17:39:05 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Li Wang <liwan@redhat.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 6/7] selftests: memcg: Don't call reclaim_until() if already in target
Date: Thu, 19 Mar 2026 13:37:51 -0400
Message-ID: <20260319173752.1472864-7-longman@redhat.com>
In-Reply-To: <20260319173752.1472864-1-longman@redhat.com>
References: <20260319173752.1472864-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 48yrgkL87NwW4JHH_4plQxT9Xjdfk2q7jG2F8HlwWaQ_1773941949
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 6gxj1hfezknd7548o1mfd88c4pp91c6d
X-Rspam-User: 
X-Rspamd-Queue-Id: D0AA616000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1773941957-91343
X-HE-Meta: U2FsdGVkX187qwCmNQ9l6AaiNzREyVdAicO3YmZ2Ntn4Jhe7DPCGIe6tn1g6KKDShK8kiNURwU4xi27xFqDpo8yTEdCcQ/KASdGAJEKUkwT/4Kegg/TKQJulakbvSib7r8ronBG2sXg5nQ4aJL2HIrGoFltttSoHt2tNUpQ2VtVFagcP2UV4eAl1ogMGEfKWWk11abBOGBmzFkDyIkbdF6QUUFfKNXFFO+S5MkYa/BPCwIfOJQokLtNxcIT2rR/joxPEMMJmNdnsMo5uybEnOoMAQOMcxpvEeDBjW3MMBIE7zPgkIy2Ijk/1il6D7uEEm3JHdenU0O7UcxyLpAhRrVVGZrJzU1B7amROMFvz64z8XoX4p78jnnfs76hr8q3CckFFohfNBN5GwMGkdLjhQQ1JCC0Qc0Innvihdnk7b48NAIQg9lsfiUWy+Jr6SqIBXqL3AWHJ9RsrPdBAUvYZsu8B9PzYTA2wt1YCbXhuVdzDxtRQFeuolFKfHbfj+VBnXAVjXcAYPEfYO/s9akSpr3hiNlhMnWHpBW7XQ5LryHsinJ0wLOXLoUbrfX6acjT9BzDiiW6gHRl5BrpRc3pBRujQmNWd/L/hVNv9zMidyNLKWxbqY74KRGVPSC4ljcaEBPv3q820uKY+P5f2q7F2m5TJWGbDe0ud+fbXtTz+n1mc/N25f7qRaMB9MQeVdEiFlUtfpG1f+mPhualzaNLlmzPeU2tmglEXfgyI7LEoNkFlvkSr/9AZSo8q1T8YkGXpNWZ8XUZ5RRy7xdunQ7oz0TGcjtpVbdA70e9g3xyutQp+8VdtzvVuuQ+qV66kD6UpBkUawaDa7ob9coBJQv+kkna2mEGE50CH1YnLikB3meSUrArNEW5RqL0mC1aG+aFMIdoPHJH5tE+KPDeJtUkRB+H6Bnj7nE1c1K887SA1G3rtfCJiT0zRigp+JCCDJUwUuuxodbQ91+IKtjK1Nme
 nTv7ctCF
 yla3ryE9YMwnmU7fkx09uBBysgQJTVogswUMFRl6tBW7Q1d2R3y0qykyuMJmoVAjLcNFLqAaa3kVqpE2QFAR4kkIBe9R3ozdYUOlTTvGXp7uDZZG3ROvoVHERCSzFDX8HlzZFJQ8D25+3u32gndxgDl+OlaZB//dYTyBtGZb/bpTVZR6QJUQ7kSYkBFmuhtQUwv5htBrMzu0rOIkeCx/mOCFPeOWsza/ihQbFBp+y4iT9bBVFiRw7VxX3HtjGNJ8FA4Bz7fDkvmk4amqL9wSd3QyPPPw6YlLB+VIKN06DUph8fUtS3MjdbepY3piAkyjaJ3eSMCcwLcraF6yKkuGYavcZBDG9iYWLop0vNjwrzlrWiSYsjWfZREh7FzxhBNpJngOvJLpB3twfbtM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Near the end of test_memcg_protection(), reclaim_until() is called
to reduce memory.current of children[0] to 10M. It was found that
with larger page size (e.g. 64k) the various memory cgroups in
test_memcg_protection() would deviate further from the expected values
especially for the test_memcg_low test. As a result, children[0] might
have reached the target already without reclamation. The will cause the
reclaim_until() function to report failure as no reclamation is needed.

Avoid this unexpected failure by skipping the reclaim_until() call if
memory.current of children[0] has already reached the target size for
kernel with non-4k page size.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 4f12d4b4f9f8..0ef09bafa68c 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -490,6 +490,7 @@ static int test_memcg_protection(const char *root, bool min)
 	long current;
 	int i, attempts;
 	int fd;
+	bool do_reclaim;
 
 	fd = get_temp_fd();
 	if (fd < 0)
@@ -602,7 +603,15 @@ static int test_memcg_protection(const char *root, bool min)
 				       9 + (min ? 0 : 6) * pscale_factor))
 		goto cleanup;
 
-	if (!reclaim_until(children[0], MB(10)))
+	/*
+	 * With larger page size, it is possible that memory.current of
+	 * children[0] is close to 10M. Skip the reclaim_until() call if
+	 * that is the case.
+	 */
+	current = cg_read_long(children[0], "memory.current");
+	do_reclaim = (page_size == KB(4)) ||
+		     ((current > MB(10)) && !values_close(current, MB(10), 3));
+	if (do_reclaim && !reclaim_until(children[0], MB(10)))
 		goto cleanup;
 
 	if (min) {
-- 
2.53.0


