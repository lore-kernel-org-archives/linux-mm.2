Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4592FCC6B2D
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 05:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE9DB6B0096; Fri, 16 Oct 2026 01:28:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74606B0098; Fri, 16 Oct 2026 01:28:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38896B0099; Fri, 16 Oct 2026 01:28:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4246B0096
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:28:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74D9BA7B93
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:28:21 +0000 (UTC)
X-FDA: 85327358802.10.B6A65FF
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id C6E5F80005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:28:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="SqiQ/Tet";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 38rXRagYKCAMnxql1xjrrjoh.frpolqx0-ppnydfn.ruj@flex--kuniyu.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=38rXRagYKCAMnxql1xjrrjoh.frpolqx0-ppnydfn.ruj@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792128499;
	b=WrutkYMtzpx/QanoCZZ2i7jqqHyYyuAS8sHL/JDTLgkTprBRYWRfYylL3noKLpt93zf9j/
	rZ9ISOiSuQ60JFa5Rw3jfDvkthfJUfjASPS12YBjmZM5sMuOhJWLk0P0R1X9gYtcOLchpt
	cbsahc3H9nDmMR/GN2GjPpgq2RJ1+d0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="SqiQ/Tet";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 38rXRagYKCAMnxql1xjrrjoh.frpolqx0-ppnydfn.ruj@flex--kuniyu.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=38rXRagYKCAMnxql1xjrrjoh.frpolqx0-ppnydfn.ruj@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792128499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TOfi1okJuHw6W2fuigoKRfdJ0OT44tx1YKA+g69VlhU=;
	b=RzBfGXK9+ZV1OzqYtBur9sh7cAa12Y0EoQufGsvllHFSFFOxF7/r0phmBtqoUS9N28habT
	JiHEDHNySTt0zPl9xH+RIVm+mwfvwP2dfF2lYZW1NBY0c81iLz3vU9FuRiWIlBpkQGuaup
	+wXWWjLQGICivs1SDk14BdYH8+95/80=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-89fecbd142bso732b3a.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792128499; x=1792733299; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TOfi1okJuHw6W2fuigoKRfdJ0OT44tx1YKA+g69VlhU=;
        b=SqiQ/TetM6ifl5KJMvpAbfCxwtIWdRDWdaGdc4E2AXyrjkcsZNEMripoKYih+audWP
         /7uurLRW3I1/evIZWTmHzMsgClpIGLkYN2cxH+6e5TqJYdH8dNRf+3yCtcFCn6RXXDV9
         T9Xu61zKZsLjdOllbLjbtUL3pxuiU0FK85pNNppeLJ41lH5ZAfY1l0Z5Ui9/qKJCZLlZ
         B0h/eYmZGSGmMk4oK6VQDdhhD0koRVkXeYs/HOdDgvelOaGLwxDBRxWaKI/bLcPWLHSs
         jPIkVoFbK2GuFQbTPjomiL0Jb32FOwV+zv6cTm4xiRqO3SEeMkX2e1MOP4KTZ4YIqqZP
         lHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792128499; x=1792733299;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TOfi1okJuHw6W2fuigoKRfdJ0OT44tx1YKA+g69VlhU=;
        b=myYCNIUbq4kskQfTjDYEhZEtqRVfi9RcdzwALw1xBCWKXatagmR3NoBEk/bccLkZjp
         uioElGjRVn4hZYbplB8mfsg1Sy0opGSOUCobsAu1ZUYhXDMIPje/jKBao8Md+nCMZmxR
         GmuWE3Vf6UinO41KimHrmj1oxBUnbJDbgH6GNWL1jLaToT6TdyzIchKez9Gfv7SRqdce
         Sd2GtCruVl4jxY9VUqUTZIZHVodU5mM/YbjWVlkKUS+yFyqyh8/Bgi85C+k9vWt6NqRB
         huwroB1W9ThASOrr+xqcdmBZ9bCASYoY+wfd7NPJC1wzVRbc3mAXnGZBTmIgdEqsukDD
         My/A==
X-Forwarded-Encrypted: i=1; AKwUvBzcDluwHQxEPDNKINnPW7ifdAy2FruR1V4/K1aRJSBGlSAYXl+DQoWX7kOX6kR8hnUnmLO4Si+rhg==@kvack.org
X-Gm-Message-State: AFq9FYLbm1GtXd8lHwr1vJiQZisdJPjs1wLOe4yUACH7nVCczOrOc+aB
	dtDb49EDXRbG6AU3YI3FySQfEjTJtMGFiKI1BaR/pK68zhiFiLlTYSxpqmA1g9AjRKhOtskEXfP
	AewLYNw==
X-Received: from pfblu4.prod.google.com ([2002:a05:6a00:7484:b0:886:3bc7:1fbf])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:c2cb:20b0:899:9267:3abc
 with SMTP id d2e1a72fcca58-8999267426bmr10023508b3a.41.1792128498428; Thu, 15
 Oct 2026 22:28:18 -0700 (PDT)
Date: Fri, 16 Oct 2026 05:27:49 +0000
In-Reply-To: <20261016052811.3085635-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20261016052811.3085635-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261016052811.3085635-6-kuniyu@google.com>
Subject: [PATCH 5/5] selftests: cgroup: Deflake test_memcg_sock() in test_memcontrol.c.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tkyy4i6ntj4nu1b8sscueho4iuak9sxz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C6E5F80005
X-HE-Tag: 1792128499-902015
X-HE-Meta: U2FsdGVkX18nQu7tOk52nXXWNvHm9A6hLTgN2ya8voVksaaqg0srdKYo2OjxBFLL2DhnsMya7a0tpUtKpoV1OzmoRFMlVGcfpVvKteNPKPdlctF0n2RBxuMhsnk9pZoF70dg8icJflsnImg3tS07JNBzI2erzK6ZIUvYW9I1n6i6wB5lnvHa/3EubOOSCkVvHGV+DLShoCozezqx7d0OO3JUs9J3NFfnIuQjLIlgVFmZm0oZ8urox6CNAm8oQkc50DsbfvayYnFCMQ4i654+lYW6pyvrN9+cS4U3KBaGBMXrVsje0cg0DJiyAJ5+fbr5rrG6FF9uduzjTTNZ0w8Vd26ZU3dBSfuS2Px1yDunItZ2LVPijt3kCpCln50vaOqkL5xgCEVIWmQUWpvuL1NYpGgKVX/KJTAcH5xSBsiJphSynzQnTTsAmMXNyu4YSpKD10h1EMVvDesg7ZgX+jBvFHixM+kC0qzUzmfekrc1jj6mld+cXzTDfB7J2dknr/AovxgaOZ4z02sos+WhammRiTeRvl6NO9qpJOmKrl8w9WXc3GblW3b/QqRuTLvupTaWZb7mgN/UE6U3eys80z3Xzdctx1qzPsyikkLbmNyhzwa+K/9BV1VNp1Cwt5hu3sWLy+Rg0fWii3DBcN75xJmgGIJrDa7f6Nowefc4i5GCK/rEBkBEu1uPNaM8WmTpwgRFt/lk9xlg5ydRLz5HLQFqg4UXzi35GSz7XegDgN9sMhW6OPhXmAPeeop+4ZWBSMYXIgbj5RWrH6o15UGMx51x4P56+x6O3RTxLuKFR8+odiUbblKXCIKq84NwFfG9KGq1Ju/wP3OOj8Jpx52JpTDfdpaHLVTRSiXgssvj2f2jRKdj+2TIJJiUBq0L1roQjQFUEo/zkVb4K4GP2J6d+DmVtYkHEmyd4Mfrto5cG0QXK7UJUncfVCgrxRTYwgJ8XXJVFG/ipmhy8rOtDPWIrzZ
 iewjUKGz
 QnHeW4TTA2rHSe43tDnqXGAP7asTqXQyZgwI/cMZIQsLiquMr1EaPULHZVROCKg3GDfRBioH98QmBdCs1hBZ2SapF2RjnOgTPE3fp2+0v799G2cvWZ0elfnfpbbBCCCi9Xs88fKaRgCpqwI3nKjfz2HVwangJi+LQGYvr7Th3gJpezihIO90BP5pPOBSF+29xdOJ2Yeidpf/AvsC3LnW+uwGWYupsDi6DgCYSQSqwdvY30MPKBslfoBWtloLoM+m9ROSSTegBbLIf1PpwbqRKeYaScPwn8n7VhL7U3fFts+SJsmQksdZLsxoYriVivlPH5TLwq67tXtTYYl+XwP7ZiQdrllSKKZr99taAvCYgxAolOarqo3VYSvsUD/J0t903f4cd8r1JlqkYYg1R2SimqElpRUd6YcWVW4WgJIdTu3PS0K95i+6DIiVIN+qgYFezbM9QQw1Y1Wjg6zTlDqvHdj22I3VC4LyngSx4JkgR05PExt0TrwlN/VzjMq//MjXPRNmIlUV//5t9wQiBsur+OfI+t2ckyxwtwUPAheNEQ0hgKpMaR29v8mlCoLr+1zPGgES1LwXCKFNXn17LT5e2dRe6cHpZyETNmSp66Uf8bAJKxWYzdhs8kk5gYKYp9BY1bVbO4dozrePiRG6yklywq+dmA73ZGkr70nzA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With MEMCG_SOCK batched in per-CPU memcg_stock, test_memcg_sock()
can fail in two places:

1. In tcp_client(), reading memory.stat only flushes rstat
   synchronously when vmstats->stats_updates exceeds
   MEMCG_CHARGE_BATCH * num_online_cpus().  Because mod_memcg_state()
   is now called less frequently, 16 read() iterations (0x10) on a
   64-CPU system can finish in a few milliseconds before
   stats_updates reaches the 4096-page threshold or the 2-second
   periodic flusher (FLUSH_TIME) runs, leaving "sock " at 0.

2. After the TCP connection is closed, up to MEMCG_CHARGE_BATCH - 1
   pages of MEMCG_SOCK delta can remain cached in per-CPU
   stock->nr_sock[] (e.g. when the initial charge published +n via
   try_charge_memcg() and mod_memcg_state(), while the uncharge was
   absorbed into stock->nr_sock[] as -n without overflowing
   stock->nr_pages[]).  Since the periodic rstat flusher does not
   drain memcg_stock, "sock " in memory.stat can stay non-zero across
   cg_read_key_long_poll().

Let's increase retries in tcp_client() from 0x10 to 0x40 and write
"0" to memory.high before polling memory.stat at the end of
test_memcg_sock() to trigger drain_all_stock() and flush
stock->nr_sock[].

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ed82347044e..1311aa5bc522 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1333,7 +1333,7 @@ static int tcp_client(const char *cgroup, unsigned short port)
 	const char server[] = "localhost";
 	struct addrinfo *ai;
 	char servport[6];
-	int retries = 0x10; /* nice round number */
+	int retries = 0x40; /* nice round number */
 	int sk, ret;
 	long allocated;
 
@@ -1447,6 +1447,13 @@ static int test_memcg_sock(const char *root)
 	if (cg_read_long(memcg, "memory.current") < 0)
 		goto cleanup;
 
+	/*
+	 * Drain per-CPU memcg_stock so cached MEMCG_SOCK deltas in
+	 * stock->nr_sock[] are flushed to vmstats.
+	 */
+	if (cg_write(memcg, "memory.high", "0"))
+		goto cleanup;
+
 	/*
 	 * memory.stat is updated asynchronously via the memcg rstat
 	 * flushing worker, which runs periodically (every 2 seconds,
-- 
2.56.0.212.g129ede20d9-goog


