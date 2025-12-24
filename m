Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A00F1E75453
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113BB6B00A4; Wed, 24 Dec 2025 08:46:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105446B00A5; Wed, 24 Dec 2025 08:46:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 007BB6B00A6; Wed, 24 Dec 2025 08:46:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2D8E6B00A4
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:46:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FAFE89885
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:46:51 +0000 (UTC)
X-FDA: 84254490222.11.CEBB565
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E0E441C0009
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:46:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QkYBtnhA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584009; a=rsa-sha256;
	cv=none;
	b=sll8NzKVVQwKL6RXsN9h6v5PqeadBhWGZkm/8ZQOU35rInK6ckGrriC7k6ixqOCorcagcH
	kvl1lI6sTVrLpgLjZiiM69bcOpPGesTASj2rHfYMPq81l2Xmmxvx5vOWe/p9btFltszgJz
	KhrFoHyKrtsNI72leGYVfQFk3Yu5bYU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QkYBtnhA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WbUPE6bJh4bG4sGu5jifyq21X5wZFvvwK42Lk0RJlI=;
	b=AZ5g10inhZzlK3nwY840ayPh6u1Za/Bz9Kg9Pj0DaXPJBucUwUbl4lw4yGo64GJzJWk/26
	opWHFtdU9KQeD9EJ3l8ODVdEjWkBm+180SohU7pOBl6o0yBkSSuMf5T7IRPhwIN8QmZskT
	o+uMYAPp+L5AgpYUBQVc24YryZThKFQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7953960138;
	Wed, 24 Dec 2025 13:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3641FC4CEFB;
	Wed, 24 Dec 2025 13:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584009;
	bh=uGe6Ex9InA/ctQyPBwEfQeCRruCOXrYZdOto/ar5f3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkYBtnhAQ44/QDhvyD+7F9s+u0UyEIzuX1QswgTK4hn9nB5xybx6i1hFP+3OlC5e2
	 n3QTVokwjBgbk6ivKWOtdU3iSevx+kpxs7OA6i6eJ/CwW1beUG7tm+q8zZ5DLeEHG8
	 01i13pW9Hf6tjz3oP4mIP6n00eIg3L/gvfs81iaM9AvkPwBHbSLXFuflUzQAcAnLPl
	 gGJgYTg7vHeM+EwQmsb9L+8Agyj9XOWgkiM2t2qaxQzfTm8hMC8yE6gHr4XY3BIac3
	 uQvrHdBPyTk6U0rXMbbBYsrr5CULeDo3AMXZByb6mc07RYSNfapMAKagVHUaH2F5E7
	 ZsgsPEuaKJTbQ==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
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
Subject: [PATCH 09/33] block: Protect against concurrent isolated cpuset change
Date: Wed, 24 Dec 2025 14:44:56 +0100
Message-ID: <20251224134520.33231-10-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E0E441C0009
X-Stat-Signature: ciniyrehcrb74bjar4e58u5oz5zog4x7
X-Rspam-User: 
X-HE-Tag: 1766584009-368917
X-HE-Meta: U2FsdGVkX1+qePc3oUGuCgWrKGaySnFmpYQyRSCIqQKq23SPGpyG44Kd/gf7wK8qHAf7LfYPv7KTis08p9DgsY0zXYq6bIDEZA9gKtIwnXmmBNZ+5vvjsP1oinJFqvku7rT6MY1bRr4WJzvrJtYaU086uVH/6v7+zDvMFy+uqbTE3929jnAL3tdqDu6hcZPMU6efdHYPLpi9Z0gVMW9eI/ERvk/ac53axrk93tSUNXFUYj0CrBrfYZbKgp/Hgv538EcXY3JnPz36hNV2D4mImU6uCWgxbfGmdkyLf2yRpz9UgIqqFmk5TmaMiFvY0tTRaKTeAbY9TMQ+Ewa4XVYptMvxDPMbCoM2RPK94UkhkOyYd8SABnu5yJJa85HwuXSo+txhuGON/209ptYQedCc+tWn780IzJ8JWnzsmUf7pVdzbG8cM+T+EfcQtWcnLaJ88F88fnA5GNr0XvIHiwwOKRxVYVqUjFtIb/1kn44tj6U7ncpevPWxUAuLNsdDkJot7EvMRmNZUYKCDQ2LT6NQ01IJREXrdIOyJEhSwArmCJPzYlZM9NM8Ml0KolzuMIU0MiaEAY9VMYfjRL8qA/T/WxA3tk5QBp/eWdpmoSroPnliSEyKciE3pCDmyVelAfv5LLyLbtpF4iJeWtwvQBbl0PtXeqx9LH3Fo79LFWUAoWUQH2ybP/k6lw9MOE0erSLkMbEXI8Loyp+uIfDGqqpcdJYYt8o6FSa+/Yupy/DsLm8b5wzVeboQd1HkjonWf4Ju1nQNF05rzaKkPKE4B1540ftcO7YVxUZn3R9xooehcUfZhES9wrvqvaZDZexEQUyvHWC8HqS9tCGPCOZGjS5aCmv8SdRFjqFajbd16TuKP4mYvc3Zp0Ib/uP4Bq9ZGxVdV7JbeEg8dIpeD4kU+4XiTwsOXNVWQZnOPUDsSqF9tN2kJv1viwajR+UlVB+Pu/Vn1iY37rJM4T/VXoUhhlV
 URuEu+ck
 Aw/B+OaMVcq+07iVYGakT14m97Vb3AZSNIOUD3H+3ZiVgZB1wIVSFV7K7vA2KqGFiUsuKBPv0lHNBOqcWU/lf4h6do5wppdzqG1iT4cxlF2mz19oZtOw2qPpTOTJNGEapaoUYSdtsiCIAwQBxjPVY4TQmphpjTzVeXip7sNpvdb+RgHOFscup/X5dyUSX5V6WaXfB+KpjeOhFx+sAxN/HJuZNsqE01/V+XkFdQY4HNDV1nTk=
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
index 1978eef95dca..0037af1216f3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4257,12 +4257,16 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 
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
2.51.1


