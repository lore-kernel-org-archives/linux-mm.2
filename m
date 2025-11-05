Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BD3CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7926E8E0019; Wed,  5 Nov 2025 16:05:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743138E0002; Wed,  5 Nov 2025 16:05:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658E68E0019; Wed,  5 Nov 2025 16:05:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5501B8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:05:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24E054B160
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:05:16 +0000 (UTC)
X-FDA: 84077783832.30.AD032A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 76CDA40012
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:05:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hIVpOBpq;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6r9dUGTT0Pb7skaglOTsE7XzSAG3KQbh/Dg9jfDd/9E=;
	b=7RMq6O8wEUZag0ipN9EX72RpUzq0ZoO97/4dXAkBmxTj9Z917DwLoCRpn8x6IvyBFFQ7vK
	uCROW0RdTULfCrDTXEDgGrVDI+Q52YnsqipWmI+v5tjXQgWeT0MzxSCfAadOot0zk78I7E
	Cg67W5hWgT4OslU2dhjj4ueBjfroeYs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376714; a=rsa-sha256;
	cv=none;
	b=cmSVAAokhsPUl4pOOzBOawsIUx/FSquUg0Ew9fSSCYf0+FiEDT1Nl7IsGrwHsaLzVsZYzT
	KQbn10Ly2AQS6VWjqDXwr4pwYsf7IJuA1fiKZaSR3cUkKFRP9JnCnA8s9xbXOK1STUAXlp
	sXKY6kBX49asXFBtuOQce4lc3K/OZSg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hIVpOBpq;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4215B4330F;
	Wed,  5 Nov 2025 21:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C8DC116B1;
	Wed,  5 Nov 2025 21:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376713;
	bh=9PqeZuz2EE5nGKqtZVUtfHjP+RBKx+k8UZ4YoNv5ao8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIVpOBpqfmDE5JQSQL6FKNplt/gJBikhmp1UFRydi+QdTh8oOUYJQlGiB4XmWUTH+
	 Vqr9dPoZ1kcgFGocAY+e2Wx9dvdHV5fLeJdsh/b30bGh3/fnHbgkXpEqxNce/04c6R
	 DyLBgJ2XOfusrMjIL8NhE2/aR01FlDQSc9QdkYFnrLh3UayYn6US9vZO5mM2muRRM2
	 y0sUBgROywsAL3lRHGT/BtiVj7xh/6lhWY4kslHyoee8mxsAoMZhQuf9SVDiUh5iIX
	 PuYTBP3315vJsPvAkzANuVXMu+SqS8chEInT75TJVn1gTfvUqrAJADrwdphmm2YvUb
	 rPFeAsWq/Uc6w==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 09/31] block: Protect against concurrent isolated cpuset change
Date: Wed,  5 Nov 2025 22:03:25 +0100
Message-ID: <20251105210348.35256-10-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 76CDA40012
X-Stat-Signature: p8cqmjyeaxxewhdik8bxzyem3ymsrfe8
X-HE-Tag: 1762376714-354027
X-HE-Meta: U2FsdGVkX19oxLMYCCz4X8HMxhvRnBp2Aub1AXhNGP961bBGx3p2k/xnR+JCBTjPlhk74aQCidc/nEaW6dwzSm6WvpH8sWT7AQauNJcFmIUwQXZKjjwMEAI5ANx8uSuzYjIIss/Y8NkhXkmmoRnEuBg1WGpanyNCYphJfYt+ILLWv66QOB3ALcSQiSEMLf18UpJUC6RltdDDvMre6OmAIbYuaMULLlOfVUZ/8er9qlJAPKv8CztyhGbaogSB8vQGZQ0h5olVzHLQJbBXvitnriWqyG1wXOkG+QC+9rQ8Q+FrWo7cZ6Am+WsVXGXJAHQRXXTlv4BIRwmX+1dhYT3DY9qdogfGBnRZMZkr4Jd+q2qJT0skqg/JF4fhxuMPhrSY8kUHiYh6/yHatm4NNwbk3C/ZcrZ/y12+p6zI4zuXVMdkM/ke3p0DLIEJswLsC7vJ2GsLa0UnFdWonXywSQ4jn6cz7dUzOmY2nDq+501z97uvHm3yrk93DrHFLammj0EFNW6XeNeuRlYCsqvgE2NKcIYllG9JTncFkthrpgp05IM7iuKpDUq+H/2Gk60PjW6F6GC/G/1mH3NM6CVzOq1iusEvqThwgILHx4bvXXc/pdrrQWotvedBdgc+gYE8b+Nq1iGmM+CJU4uFwlR1OtUp6Io2Pu2l9p2g2DgD5CMH0f1y8t2OzfyTUBGOBDEvO9KVGsLYkrMXmZtvhJr9fg0LgKvGkNVXQMTp250KcjYJlmd1F6w6UuiVJwI6vlxL+p5qjt9TtE8A0hx1nEfVjfO52bmuFqkS7E0SyA1/zPfgr7UpPuhuxYxTA8tbULhT4oWwJXyv77eCWt/q9bXRTF8aJzov2tOznAprfHy8F6DmftKN8+gYzA6zSJSCIg6JFD+6IaKPGw85SYzP7sbea/mxacuwCbjXZjg8uStA59YfkBqb29vXMB8CLluSOdL+fqVqm+yWevqnpEtfrJwK6sn
 KV/fpHfh
 oVqWB1h1qVYxmt4iZnuKDKiDyIoIq9tPn/bk9+XACc/zyaVMpz3Zp5hqwfzAScoUcVZl1I4PuoTUWd++QAK40NLoe0IhFqY3ljokK2BfzFImIeESCKrKw+NhiW98UK5bHPt0FvtAdGVsRcWsuJOdwqpKDmvFi1B7xiwNAEvo2ZofPDJjTvpwsYCX6bmb2hcoQtgDcorZbYK/Hnp8uVFJLkNVfa6uHkEvdyMzFUiatsDVVYNw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The block subsystem prevents running the workqueue to isolated CPUs,
including those defined by cpuset isolated partitions. Since
HK_TYPE_DOMAIN will soon contain both and be subject to runtime
modifications, synchronize against housekeeping using the relevant lock.

For full support of cpuset changes, the block subsystem may need to
propagate changes to isolated cpumask through the workqueue in the
future.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 block/blk-mq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d626d32f6e57..7a6137b15dee 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4240,12 +4240,16 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 
 		/*
 		 * Rule out isolated CPUs from hctx->cpumask to avoid
-		 * running block kworker on isolated CPUs
+		 * running block kworker on isolated CPUs.
+		 * FIXME: cpuset should propagate further changes to isolated CPUs
+		 * here.
 		 */
+		rcu_read_lock();
 		for_each_cpu(cpu, hctx->cpumask) {
 			if (cpu_is_isolated(cpu))
 				cpumask_clear_cpu(cpu, hctx->cpumask);
 		}
+		rcu_read_unlock();
 
 		/*
 		 * Initialize batch roundrobin counts
-- 
2.51.0


