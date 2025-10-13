Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D58BCCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E84E38E0076; Mon, 13 Oct 2025 16:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E351D8E0036; Mon, 13 Oct 2025 16:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D248A8E0076; Mon, 13 Oct 2025 16:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFB8D8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:33:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61DBF11A7B1
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:28 +0000 (UTC)
X-FDA: 83994241296.27.DFD6FA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A04B420016
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OYkHhfUX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387606; a=rsa-sha256;
	cv=none;
	b=DJeNLN19F8yU2ZS22fuRZ+qecp021+zVySIBQsi2TK2+l09oO8ygjdR5NGg3GLqg3PZalo
	9kfZmM/2i3Fh3KiDnDbiqYVcG35CBBxNwAzJq8mtmrf/qD8uXTgL42UephRvqtikXAdneR
	8PgTI2F4OZ4si6f1xwUo+XSeUExPkko=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OYkHhfUX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRoWUlFhAwhp2cFv9PQzQntX9r9EON1eUpq3Tj44Lhk=;
	b=vThl0L1LE8oCWuPBS0ehEDZXmWdcFp4+b7bNfTqDFKFmuRVKJqKqBZKo/zG6YQ50eEgU8H
	dC1MLJ2rvYffn3byfbyi+VrkCgqYhtOwFwVeF9xHctsiEP+KFNxaEOfYeyVFXRvOm8dr0a
	4Xyc0fGOAKP9z3ojmxl5eMwBp2HuIP4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A5FDB48BA6;
	Mon, 13 Oct 2025 20:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9228C4CEF8;
	Mon, 13 Oct 2025 20:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387605;
	bh=VdxniS9PgPy7NwhH2qd2yJdMmQz1qplz7zrJIak9Kiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYkHhfUXI/oYa4SUYC3drRS/xQcuPGvoJ7NPAlL+RYkd7LDKQhVy66GIv8GRNnfq1
	 vta4/PExq+fjEPabx2OflvbpD8ELoJfqDDnIQfTM11ITuobQsbRQNXofNlQKL61YhW
	 x/NThH0eYDAZ9ccNisPSMap9HlbAI08z9DDWViQ3Lk5zSF3JuRqgNhutW4TnyAJ8jv
	 Nf59vwv9i4Rvsim9ENbglJi+KEKcK8aPqG1Zxpcx5Z/h8MD+MSx2OCYq64txa1+r7L
	 MiEYtaDzQewyIhShh6A2JbjtLxzvRTq4ZVb5PTnXWtdVlTZLWCINQsN5Q3TdoH9Nnp
	 ucj4kQYQMMMCQ==
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
Subject: [PATCH 11/33] cpuset: Provide lockdep check for cpuset lock held
Date: Mon, 13 Oct 2025 22:31:24 +0200
Message-ID: <20251013203146.10162-12-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iy9mio7eo33iid9un1pbm9y6hubinkzp
X-Rspamd-Queue-Id: A04B420016
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760387606-824781
X-HE-Meta: U2FsdGVkX1+0cvYkVczyD7kVn9xgA5itjSzMKJTnIXfUuCTVByB7eWDd/hfshLxRnrcx9nJQa7zKPR/uCBFvTW/xqv4VNUv7LUkdBU6S42hbKFMa2mM4HWrINwCZ5+oL3kihVO/qod5ZJEDd29aZynEd6tYdFHTNoSphEW9Az8Nk/8GyJjKbfGsW+1UZ6CJQvFteS4WULuYJG7ThsvYSSuhemyukGD01nKmOw6Fpa3EsKN3Qw4YGL6lRZuLRMm2URfTHNnDH3oXWoKORZMc5U13WZfBWNiUsKsIxY7+j4gGgyQn5velGlhGJWmbKFRG1AVYCapl+Dkz1+weVHq/IbqrUTxNekAodx84qNsI4JszKw7BiuMCuQEpY49f3bDP3BY2kdrenXALaNZWi99mOAIfmtzNuqtwgZ2iBV+qIoOkEmKe3k+Ko5z5c6KW1egKp1/UuaYnGGxiv/MUUc74IY2wUMaLc06GNaEW9Srv9CsfmfrbOKX239m94pghN2eebQdm9yBdWJMs1wz94KNiTodpqXHkPPzo4BBPKhGfzJXBZZuw7AA9DGbqYilKgUMGdMPk9gVvQyqSCkkSsBj/FSJ4IcZde2uaJadmDOka4ADVeNphWvsXUF9V5vPqSvG3dLBPK53IOiTJ0VMgIQ+aFScmma5cyOtfu92JGWPHysCG+d8k7TKU/SQU/uw7WeNTkCaK2hJNHuu/AJ1XlnnHQ73A32IyBZlEXaedY9RymNjPfgd/l4nND9RA5XLGpZw8H+4xs2le4k/c66cdzNlDkGqZc+8+jAnRxX47bU/D924vkUamswKz4tvyKk+t13eugbvHM2bJ1R+cywdQqAPUN7vph22TCMKp2B8P8RpDvudw5TvENCd0ux7gXHJVJQ+AD2V/fuZPKz1f2yYYZq6cKixvm9+9ivK4Mbgl3ELj5VmVxzR+SbN77tVf4c3gr6os+C8TV+ymxZYS1LwBB8op
 S5kqRZdk
 4wfXJxG3Q91TXH+TE8AC+r6rwUEJKPhJQCuTNjTQyHZCb7C4rmqB9nYWbxkceX7PzBhnBFjdhop8PzsWlUEu2yryjeNSfVArinvc9eIS2cq7eIO8fbCxhdSt9V4fZkegagoPRJ8plh+zZTVxUzamc9nRKGGtAHsgo+IZNfpJ4XO88xJZNegg5m+j0bU0h+0qFQR8h8K7caZNPI55b7++BqDGBeY6it8vN67CCa+s482/XSsjZIJM2lzqt3KPjg1MQKHZm6eyxelvLJCvQ+UJ3/SUt+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cpuset modifies partitions, including isolated, while holding the cpuset
mutex.

This means that holding the cpuset mutex is safe to synchronize against
housekeeping cpumask changes.

Provide a lockdep check to validate that.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/cpuset.h | 2 ++
 kernel/cgroup/cpuset.c | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 2ddb256187b5..051d36fec578 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -18,6 +18,8 @@
 #include <linux/mmu_context.h>
 #include <linux/jump_label.h>
 
+extern bool lockdep_is_cpuset_held(void);
+
 #ifdef CONFIG_CPUSETS
 
 /*
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8595f1eadf23..aa1ac7bcf2ea 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -279,6 +279,13 @@ void cpuset_full_unlock(void)
 	cpus_read_unlock();
 }
 
+#ifdef CONFIG_LOCKDEP
+bool lockdep_is_cpuset_held(void)
+{
+	return lockdep_is_held(&cpuset_mutex);
+}
+#endif
+
 static DEFINE_SPINLOCK(callback_lock);
 
 void cpuset_callback_lock_irq(void)
-- 
2.51.0


