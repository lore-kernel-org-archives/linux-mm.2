Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9589CEEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFD3A6B00A3; Thu,  1 Jan 2026 17:15:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0D96B00A4; Thu,  1 Jan 2026 17:15:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6F36B00A5; Thu,  1 Jan 2026 17:15:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED896B00A3
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:15:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 166D0C06B8
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:15:30 +0000 (UTC)
X-FDA: 84284802420.09.FE551C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 84C7A20010
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:15:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PjJIQyPZ;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gyx04ZBmYuzr36s0yXfjpdK2uuoX6/4zTXsC493uCVc=;
	b=XGKk3QaKaACH4iGbz9LOut+lSpVg93z6M0iJb/TM1XI22WlKlry85K81fY4VrTmjGcwLWo
	Kk80NcVyH8q+L0WI7q0cKrbVyZ59pcLTevp3VLf/YsHc7A/EVnaFv4fZb9w65n2NI1aAZb
	QWAO21LvnnTJuOiqahKvtboZ/8kh658=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PjJIQyPZ;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305728; a=rsa-sha256;
	cv=none;
	b=vxmzzxxxRxU3GpSRCmCu62Y8MeXaqE5+jkZJUqN9kQqrdEw4YDTKwlZauM0ukF5m2W3mV7
	qxLhgkfwCdCBNUzb40JgKM33LJcRmNKgmaESIs0AVNOPdj2+cYORn3HIHzjE4q7nuHEg3w
	GqrkqU9P1OnU9mXqFDArncvoJeGCXHg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 003B8600AA;
	Thu,  1 Jan 2026 22:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B51C4CEF7;
	Thu,  1 Jan 2026 22:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305727;
	bh=CSBqMHaVS4LYUH4nZYK0n1Q3mrGckGoVFLRQaFReEXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjJIQyPZ3gNH+xw/gL3DNsTYhPXKrLZGi+D4wZQyD/V9H6meQ28ftUtJ322hNWm6R
	 5KdjwiHSktvOFFoVDCyBtYLnU9HjLsgFkaWgfhBfA2hcf29PmqGHSFCZ492lymdaj5
	 55ZgJnaLIL5LkrhelQb0w4bW/QTmDSGT6kndD4EuRqOLUBKqJZmcOhCgZ903eSxams
	 /TbBRyvx2meH/0HFPN546AYKBNER7m35Pbjlx1R/LHKVmP4MUyfEYZlHYfCYgB0T8p
	 DwjBvugnF9Y55uPBHcwYxhBnmLhu3yZKw0Wk4nZK8QmCVpCskJyWtXmhuh9oEZ39S6
	 2palunZI8oI9Q==
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
Date: Thu,  1 Jan 2026 23:13:34 +0100
Message-ID: <20260101221359.22298-10-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: xdhjdruxcbuerxryzkngwwpfe658umnt
X-Rspam-User: 
X-Rspamd-Queue-Id: 84C7A20010
X-HE-Tag: 1767305728-480348
X-HE-Meta: U2FsdGVkX1+KlK9d2Pb5yznSL+FNy9oE7vcXwYJmT6BZyaaxd17GA/kuKfn97BeeadNMtsI2yfNbJdrwvzfwKCFzaQlJcgdQDtQyPJu53d0Z/ndShW/+qOCLJxWZYMbFdEPH3aFKJp7e7ycltWHnKnnNUN+YOQ4VIgSqpbKFF6X2qv37K8b8HMKfKlTyaSNAXvG4KhwwazoQRLDQ9CxribQvT0yctxV3Ju5PqwySDtSM6NPuzqx/X0OpB/fCB0C7fVORdcXvbW99gjcan8CAZV4nNfElI5jjhYeiYNxtdcPL8VJ8TmNr5/JdTLcwtSUgu44+KtVsxwEKQ6IfrMZVvLbuV8SUn0wI9jLRYEM7UTgPYo7iJJjGJhV9wWDRtNahAaEJOITB8OU7TdYQDUr8DU8Bv45Gb6HRdfBLmA8FuqzFbjZMbculO0Gd3yzdqG53bMoR92OvobnyspX0YOFQp/Y/5lUWemjjLveJUsE0HOZQDs4JIAb5h1RpjvtOYFiMcq62C+kMSYl0sny1xMbIB1dqPRmuWd4NvnrPq0Cq4hnQH4UrSc8Oz9tVWml8HG3MiQXiLiloFYmdZdu4/8KHpscqfHcfwa2C+D6WztF/9iS1hFZT13hdWpdDG+/1TKK8G4TrdxKmJxqzmcCa1PbLgubkRJ2qfvpNo4oIXD9q2NTHvVpUYCdv0ACmYRwksnKXi9wP4GLCLkvF6BO4MRXyHsdlKFXQkWytOesAnkN2tmiyKyCFfankAKmNonztkVYY8bCi/QYq8Q+EzYrddHYIp1SH9j43iJlddo16dVdU0EA5X+Fd8nWl1pQy8gHm3VPxuJv7vr2IM4vipS+5qk6+S7DELWecPJ2lVCQDhE75toU4N7wm7XN2gYUvqqIDHRgC5VGwkoPVotVJmdFlzKsMPsNBteMmigkUwy157PEI5RgYLbEr+leuqnG20Bc5kLAlpmq6+NOUzTrU57Zj4GD
 Vb0Jpq/b
 yDprwnhLa3E4KK8OBxY958J+2i+Cn5te95X2NNIlmwZ+QIdE3CNc5QThUUv8Oq4WU+cpRQtZBsW8sFpZCiEj/m+xXe81qmS3Y80A85hdBPsXURXYPECefGIN3RM+iFIc+16jajoSc4awSPUerENdEs12ykoy1scOXs+UuShu2HscRNTH5XtmpmZQGgWiEiGOLHCrZIXh/tU2SVZvcW6Z8YTESEcwsgGH9J6+QPIZub4W7M9c=
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


