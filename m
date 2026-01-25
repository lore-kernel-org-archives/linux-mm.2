Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07591D7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DEC56B00A1; Sun, 25 Jan 2026 17:47:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A89B6B00A2; Sun, 25 Jan 2026 17:47:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F2CF6B00A3; Sun, 25 Jan 2026 17:47:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4446B00A1
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:47:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 111881394F0
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:47:07 +0000 (UTC)
X-FDA: 84371973294.15.ED7A691
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 72801140006
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:47:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=temhnd07;
	spf=pass (imf23.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gyx04ZBmYuzr36s0yXfjpdK2uuoX6/4zTXsC493uCVc=;
	b=HRnAWXAgrTLI/VQVPAmv7Nh1MDqpOa/EMyf9uBnGh0EkGkhSKf6ULmePWBVr45brB6XGRD
	jcU/4vFIRk5YkpkuLEtewiZNV+8PxK9mqPCtUFit/F6OM2S0U9WMK9jdZ0PQhX6IG39ge+
	8rTOA9e0GcmaJTsjp/dqDUFrA5K712Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=temhnd07;
	spf=pass (imf23.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381225; a=rsa-sha256;
	cv=none;
	b=V6zmUvtVe8mmlovIwCG0P2KwRWINBgjQELD3ZMWwofCKluGQl2PDPMSTDG3cLeNc8NG09f
	OFmJDRtqzLBHhAuoqOOp06FiyOTdn7rJmSwQRRkoOCthgXu49E4GZ24wOPQhb/5FWQGA6z
	J3/u44ioSopdM2o9t7vKWYfxYCIfEag=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C6BE40ACB;
	Sun, 25 Jan 2026 22:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BFEC16AAE;
	Sun, 25 Jan 2026 22:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381224;
	bh=CSBqMHaVS4LYUH4nZYK0n1Q3mrGckGoVFLRQaFReEXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=temhnd07RHCs6lNSYUz4dbj0AdS6VgNvDbHHoQlwXOwUJoMRDGW6YISibUt7MpdLw
	 jnI8yaWSPfggyIWb9RllrE4gvUIzfbvX7Wkkex438uhX1Q6DMwMifEXgCIYovYdPi2
	 Nz4roDXgmETt+bVRRIuD7SU6+baquysP7zPZFV0nRG/4zl4hxV7Rb9tZdivbsT5sd6
	 jRm8usW5uMG/cXmbECMxPFLPyK7QOV71u+IsduLIES03OtEaV2UMKcf37Gn97vcjpL
	 vmQQtoDswbo1ah3b/RS/Or1mUjKopIJ+G4wDoUQgpGQ9VxlcCsO/MsQZlJ6NkPPfEK
	 elrCpb0Jw4Vxw==
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
Date: Sun, 25 Jan 2026 23:45:16 +0100
Message-ID: <20260125224541.50226-10-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n4hthk7wf9d5qrb5z1jta3c5w667jr99
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 72801140006
X-HE-Tag: 1769381225-407512
X-HE-Meta: U2FsdGVkX1/+NxrIX/dBWeuhzT8Vkqq2o9kII8J3pTytPlearBRY4u7I57ypR/mxTwUKdtwlhUhvLHF4Q188z3rP82tNCDvTo/4Qbq3VTR4tK8EMVtssJzfc8E+Pbc4XRDRKx4GwrsXkjqDAJLsFBHLNx1nKQxBBgVu9lLZmITqs77mVgSg8MqdqGsgfe0eRdkNp7sxTLtC/Oo553j8Z8h5xLfRJtxX+gLdBU9nBxjV5N2CUjPauSz6FSUkZzrxtJ49ULYihco8CUF12Ndjv0TEjv/BQFMu8r/W5+aB7sHWHLu1Gkij9D+Td5/BBpl02bZEdsxPJsw6Z80T6i0rFHqFJ6zKxrY5pMpZ6qBV1uter/2ZBfMhAtX4Yg9H/0BOLnzqBfqZ0ZzmwpiKpTsr1SWcEsyUr6H/niOq+aIxyx6VF1QFS1AF9F+6mr9weuWLwXgIcCvVBX55nOPlCGpH7CSUotuR46ls1+wXR/1Uu4H9Qh0RjlnDDpsZGj9OdLkKQWDb63/tf0i5zFrRK5+CyOsKuQnl3Bp4d1aV3YMbGWL1HpQJzBijJ+0tsa8sr7WxAWaV20yKj7Vs79C8UYdx7QUQrBfhN3mcyqySoIveIdHHNz929JO7MAFW2ic8E2jyBw2DSUbexGSpMJ/8qmgHSz5GkSRP6P6MDF5Ako/gHf0Uoz0AR8j0hT5iEeV6A+kegcCFseQPVZ5Tg0ky44ECIRumxT1bSsSRFpq+lvDt9em+saRBpoo3C9Fu7qZxL/cHt7QjMprKddx+BPxemJv/Q6W7XAcaBFb9VP4ErRqna0tI724/CRY3xegylNIYsq2I1+/PKH0ANZyungzSikcyakrgZWH+xXyU/XfBjsRmk2P7aoZFbPErTgO9V6RMAylnJL/Gb76cfQnYKLoSVeEj3jWGOs5scGZ0MosrY1rt19ha7PKynsBK7NJuwCPBdcHDHECiYB7J2DxZbHhRfxo5
 ziADKrDz
 pkjoOuhi3jASBlEhdQlrO7cCWZ4lychg8WoyPOmsjNkT2aJqnn5C6uZGNEbaMpMjRcgKMcvFJwGu4UGOCjE0RjrzqtDyQqBAa4l+fQhv7DkEaGdlCcyxyHZ60VrbyvmvLNE/Gys087wbaSw9PsM7nJleKp1aXe7zC8tcuZOP+YE6ZhgoH93Q6rgZD937jcNbMPEVNT7mdnzhW2+VANO3At3oVpzlbgUf2RLhvp2Hijcq2dYg=
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
Acked-by: Jens Axboe <axboe@kernel.dk>
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


