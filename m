Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5543606A893
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UOjGdaBm
Received: by kanga.kvack.org (Postfix)
	id A3B096B05B2; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99DB36B05B7; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8857A6B05B2; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56DF76B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB19EA80AA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:23:12 +0000 (UTC)
X-FDA: 85446189024.14.A63ADDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B79EC40009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:23:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UOjGdaBm;
	spf=pass (imf07.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794957790;
	b=aroeA/E5Mt56MX4S1Ymiq/vfBvDyc3cOk+0d8t2W8nwLqcOHq8/ur0YiB3JtYzB1wJ+seA
	IOCBVctKTwc3r91JoiVBB0lhAJonqqm/HDuEjJJmCZSALCiiGItPBYpaVCsV2FBx75uPj6
	/zMPjr/b6Z6oQNkHx7FDixh8C2y6WcQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UOjGdaBm;
	spf=pass (imf07.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957790;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1JBagyXxECIQ4yhDUegePc/CqbsWLNLNpVx2YFp7Whg=;
	b=JmAVpF0h1WHruz6cilxQv28gFXzwRBt8EpqMNoK6KMHKegqdGw+87eQt/fEqIP2pN7zGyu
	L1/GcNAZ3odn+yjwfzIlgbQLQVO5sRb1u/+y5vz+iiMmd+RHcEGGjhRL33CvyD7BCEnUfa
	fTUz6FgmcxOdlK+G8J09T2ULZD4dhJo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 560A261D4F;
	Tue, 17 Nov 2026 23:23:10 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794957790;
	b=vfBerCRycTHxFKfN/0pumBYSq4j7o+cYUIcp0tB534h96w90GsEg4IkDam6tKkUCYdjY
	 8gVpvwBw7e1Pd0dL0Yrodonc6Es9DAt8HjS1Ng7tU9RmwjYgshSIlDPb7vSH/wE5eOR3T
	 dZn9QLW2H+wvBXZbHkDMo3plE9qH7tNWk6CG4qQCmT8/BW6aS/5n/qAOwNPpmN6MHVI2c
	 sSzHBLg5eXZMd0033TJCNjcS1VzCETLDuK/DAEje8BNrrKJ+x019knEzj8gnmlD+lD+Mb
	 I254xYi7bzIwCatzmH5euWlT2oxH4oosg9KJ1uLdtaiLVoAUEO8YlttH5u6henRTLgw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794957790;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1JBagyXxECIQ4yhDUegePc/CqbsWLNLNpVx2YFp7Whg=;
	b=wnuOuHyob9nadjW4I9twHDaPpruui2fhhY17/5GNU+9mVkbAImf2dhdGTZ/2hqdCnwcy
	 QDX/rlK9fzZkuKUO2PM4/ZoaF0U/IjTHHgJgXdE7nDCgMh0EfSxrF0yImmB7/8XqaAvxG
	 SXdhKfPulFiYmkxu0Vq6h+Fj/Wu5IjgKtPa6ADugDN6KDc0D7JrlcsCjKzFMqceIM4gje
	 84saTEKNhH20n/sTNpS3Cn9K4hRjSPvfy6y6MB726PyV7Sb5dx+WAlQKH5rBpx6AiRlLa
	 NqKtmOqRNr3mknDEQi6D2aSG5SIxFN25xjWUhLt1n30+zoPLSBcMidrsDuH3nc7n9cQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 427221F000C5;
	Tue, 17 Nov 2026 23:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957789;
	bh=1JBagyXxECIQ4yhDUegePc/CqbsWLNLNpVx2YFp7Whg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=UOjGdaBmWkKDubE4UImOKArvPgd4DJKRCJJKYCj/tIZ7SPA/mfFVt+ZAYA1kOGkas
	 rZYJl4avTMnmQ92L8q4EUlW0hP20N8WVtESuCRExbvP82EMUM4/kVqihVH40AW0He4
	 N8SZ2uOGSu3MNlnkXnZEmPwvICV7NrId7AXm817LWH4+bjp/QP5UW2lFUb1Mui0uTS
	 Lig/3OifZ6DyReRtPlYhmfhSIO0S4mX1s1rM5PeZ5pye/mfRAXLbZyRvQY2byUipno
	 dTSh+eF0eOuRq/s0YztzetsapjU6b0URUQUBaAckTu1Pi89245lny4Glaif3ymtkxy
	 /lUWoLb5tVprQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id AEB3D4AB1F;
	Tue, 17 Nov 2026 23:23:07 +0000 (UTC)
From: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Date: Tue, 17 Nov 2026 23:22:15 +0000
Subject: [PATCH v2 1/6] mm/damon/core: introduce sz_ops_filter_passed_last
 stat
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261117-damon-sz-ops-b4-v2-1-439888fa04ac@uber.com>
References: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com>
In-Reply-To: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 Mattathias Pinchover <mattathias.pinchover@uber.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794957787; l=3175;
 i=mattathias.pinchover@uber.com; s=20261113; h=from:subject:message-id;
 bh=+LoR4vjeWULTWq1HaaBRt0DI5bIP4EpokrffEX6bIPk=;
 b=nBOXKM5iPHzAj1ILlavDb0aAPQuMN5r9fq6LxK9NPV9D0KILcoJdEjHVCvjtqFuCMeHpD2Iz3
 5fo28ZEQAffC0GPmCeQNqzhchoE13xkTJZ+AmSmLam4X2MVtIQhMIDL
X-Developer-Key: i=mattathias.pinchover@uber.com; a=ed25519;
 pk=6Bh6OEwWiU6dpON0CVcoipq8fXtEgvhsM1Tmm9CTmtY=
X-Endpoint-Received: by B4 Relay for mattathias.pinchover@uber.com/20261113
 with auth_id=1515
X-Original-From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reply-To: mattathias.pinchover@uber.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B79EC40009
X-Stat-Signature: sjmxhp1nj8hg3e3qgjpudiz98yg5skt9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794957790-500052
X-HE-Meta: U2FsdGVkX18Z43Wp6+7YB9+Tv2yGjI36WMwJTr9KBnnXE2eLI+VTC9Du2bWkhjSmMQJBJaNd7rJlwGdbBi3JexlXBm8RD6H8aWNF4sYDCiOvT5jWwHX6bcStVAJbGQaQtASeGIh6vVjnE8xFIFOIhGmn6F5EAHCHlr+VB2JdxEmP9vGYeGPR1fXEctaFO/x7pIpEhk0S2SMOl1Vf1FBE4nQ9fteCMVlABmqvfJ5A1inRz0t4ym2NMUcvJh+8ONgezMzpFvr7TcvnvBq837G4pdleuOvRwRDLg84rq7f8kUsgxdC3Y2/WbL0/llb3eLr3WF3XmEyIosBqiFy5atSCC/rX1O0ZOC8tLNk9DRQBsdpBLS7WhdZ7kK4QJFcbpktiH1jsTcoARVbOeXJ8Ew/5gnt1ZPP+xZ//iZ7mE09m66HS1PiCma8662lqgqvqSZsLV4DRvCxZXdWsVTrhFdN5RnhJMAt3+jHyNTlvFroUmTnW1yvdDmjNFqzHKFL8mSrvbKTbbGhagiWg/uvPtHWoAJinzWSGZL9qsxY5qwBxhNxaFfXjpgY7wfUnHCgXO5ZSU7WhSRieOlUl+vRtdQb0KRySBLTgzeev3QblY6SB85P4RQjI1hyqcJ910U8XPLZV7A1Uu4RnMafcb3t9LowKEI7tgNk1BW/RN0z9gZ+m0H+a0kUBSVq+yEMbHX7E8g5Jg3kVXNCRlh8tEjWYkNIoP3EwZ/qvBVZkBQpnsJAFNHhXOqDsGs0mDwkTFE3yLwWsF8z4T2xC3Gw6BT7C2UZzP8lSyYATJoPTuAlyEh3pskos7XOKc61fbM5fEp1cyWLzbRvIbpXMKGYNmpKIVU1/UMpiq+cgVvLCLACMoSd5YKFTET2FSyodvH5kdI1qYHZDeMqirjS185QRBSIBBLtvKO1yukTM9Gjwze2bjI3NdH64CA3mlvKzhoAHgHwMfe53U7xY6PMgQpcnaJ0UwDk
 TaS0yIjx
 t7timW3EdeC5/5M0w/8kd4UeynBtBZUO7GIZkOT2o3HUEpZW/DG7OxmdBnAxiJWIF0iGq64jEZCPdncvvzQmH7pICULnukadeA/f3BM16k/Vg9mULJqR+wsxajzE+1RsMnbZzBf2AyaauVaZ7yT/NFQAsussLZ25mZOP5bIKfjvp4V5XOlDaQxlDojoU5/kiYIyyj5/HYzF3KWQwXJ63CZ8qFuqrsm5coWaWHJnFk/r8Va2ozBFj1hbTjZHN+cPTxvOOWsYz1okVkPtunZ2RtuS6ALJcZ9jQVHdNQGAVbySt13sndtojaFbmlp3zmjKVBBpwlgNVMbgmzhVXOqsTK6EaLmiOr2+9ksJihBgxTZq7IewJYn6qfmHLOdu/oHdGkv8e7KGeHQGtMug/JOieJ1laZxyHvKSCj8zb1oESdmG3hNXdAoa35ZCbxq5EixXKAOtEsVRrybL5lUY3wK2CrkzI0oi78kGNu/E97N/YwJoSuqK9D4qoQGSt1uTluPDZSc118S2fW3Fr9NYwlWctAO3u7IymqO3h5xdXuhBo8+H70EHUkPq4Z1XvE9ZZgU3ZDWFfoSYWGap9HZM2D70Mu/kYv4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

DAMOS stat sz_ops_filter_passed shows the total bytes that passed
operations layer-handled DAMOS filters, accumulated from the beginning of
the scheme's execution.  Users who want the amount for only the latest
apply interval, e.g., the size of a workload's anonymous memory that is
cold as of now, need to keep the previous values in user space and
compute the difference with the help of nr_snapshots.  Because
nr_snapshots is increased once per target per apply interval, the
computation is complicated and error-prone, especially for contexts
having multiple targets.

Introduce a new DAMOS stat, sz_ops_filter_passed_last.  It is
updated at the end of each apply interval of the scheme with the amount
of sz_ops_filter_passed increase in the interval.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
---
 include/linux/damon.h | 6 ++++++
 mm/damon/core.c       | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 06bd92981af2..3aff5c525132 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -351,6 +351,9 @@ struct damos_watermarks {
  * @sz_applied:	Total size of regions that the scheme is applied.
  * @sz_ops_filter_passed:
  *		Total bytes that passed ops layer-handled DAMOS filters.
+ * @sz_ops_filter_passed_last:
+ *		Bytes that passed ops layer-handled DAMOS filters in the last
+ *		apply interval.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
  * @nr_snapshots:
  *		Total number of DAMON snapshots that the scheme is completely
@@ -379,6 +382,7 @@ struct damos_stat {
 	unsigned long nr_applied;
 	unsigned long sz_applied;
 	unsigned long sz_ops_filter_passed;
+	unsigned long sz_ops_filter_passed_last;
 	unsigned long qt_exceeds;
 	unsigned long nr_snapshots;
 };
@@ -578,6 +582,8 @@ struct damos {
 	 * @action
 	 */
 	unsigned long next_apply_sis;
+	/* @stat.sz_ops_filter_passed at the start of the current apply interval */
+	unsigned long sz_ops_filter_passed_at_start;
 	/* informs if ongoing DAMOS walk for this scheme is finished */
 	bool walk_completed;
 	/*
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0a056949604f..6af3309691d4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -769,6 +769,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	 * or damon_attrs are updated.
 	 */
 	scheme->next_apply_sis = 0;
+	scheme->sz_ops_filter_passed_at_start = 0;
 	scheme->walk_completed = false;
 	INIT_LIST_HEAD(&scheme->core_filters);
 	INIT_LIST_HEAD(&scheme->ops_filters);
@@ -3533,6 +3534,10 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 		damos_walk_complete(c, s);
+		s->stat.sz_ops_filter_passed_last =
+			s->stat.sz_ops_filter_passed -
+			s->sz_ops_filter_passed_at_start;
+		s->sz_ops_filter_passed_at_start = s->stat.sz_ops_filter_passed;
 		damos_set_next_apply_sis(s, c);
 		s->last_applied = NULL;
 		damos_trace_stat(c, s);

-- 
2.54.0-uber3



