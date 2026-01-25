Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2890EE63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0576B00A2; Sun, 25 Jan 2026 17:47:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1406B00A4; Sun, 25 Jan 2026 17:47:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1186B00A5; Sun, 25 Jan 2026 17:47:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 696F96B00A2
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:47:15 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B4B71A05C6
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:47:15 +0000 (UTC)
X-FDA: 84371973630.23.72C814D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8E70E180006
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:47:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EECGCyaW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5wizuhTN6mGlwa9nDLf8YTsLN8D8vmBJXyWiJsoAfY8=;
	b=y7ro5/75zSVdgthkf7djb4JBkNKZn2Hy3YTq9X0PNjI8tQQhslJJ3DGDQKAmlqzwqXZ9qT
	19XZ35KlpVghnyThycQEzenbnjfxvNy2OZKIjVhX+00b996SgjnlWjP2WflGC/G4Q552ea
	Bdq1yuPr9f8Q+UQdRLeYdFXmrNyQogM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381233; a=rsa-sha256;
	cv=none;
	b=dz3y5YU/nGGc7T97O/xTyod3Mkd0AEKvrZY24pbrNTSYPy+YZXGaQ6W3pRw0Pmt3EG6mwD
	MK4utEdHMxTEwvkX+KuIhf6wquUOC/IR1XyLc3y1/8vuHGF45TjT9PZnQgHbFrqu71/AhS
	ofVGn8L24oVQAmpteKk3uBs493rWIMg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EECGCyaW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 103686011E;
	Sun, 25 Jan 2026 22:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CFFC4CEF1;
	Sun, 25 Jan 2026 22:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381232;
	bh=cfBsUi49kwBpo1bGsw5oqJU14C2/JcinY0oHFYzJ/us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EECGCyaWvrVDR26r8FMcmAew6wPA696Yx4BFQy1/SqYAn+y03+OxAk9+r9OlqSwfx
	 dnJZcbibQmmtLq12EfALx9aJO9zD3zSyo9QEAZH+qmwiK7VWDFNOCMZAyrxdK/n6PL
	 TZsk+H5oEoc+p89p4HQbJsBDVgpGJ61Iyw1usvP+o1i4z2UQG4ptq8w8S9uW380t9c
	 cRYDPhWZFKZpG4XX6IRQTcpmxhTc8LIrKExVxVLU/3BFtxZoBYV/aDlNyu0PrMeGrF
	 wgtzwFzUlAwd4Ey9GEdOxxpf3yeaEeHIbYESHjtUcwxBHuYC6yOy+Z5Z2Rpwn5icM7
	 kxq7nEKhH18Yg==
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
Subject: [PATCH 10/33] timers/migration: Prevent from lockdep false positive warning
Date: Sun, 25 Jan 2026 23:45:17 +0100
Message-ID: <20260125224541.50226-11-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8E70E180006
X-Stat-Signature: i16menuh66ha7inw4pyajor1w878dk1n
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769381233-758017
X-HE-Meta: U2FsdGVkX1+0ERHR1ebRWNCerMfxE9lFIDcVTVmrCKRKB+Yqrq4RzbtcDgP4ZX3GUAhDnrM5pTF/eHZGMy4l44fuT+mjeL+kBgXvMyG/RC+4AGhmZuDXs+4SGY5rfI+wxdXywQQUZe2tvZnyi8S6zLF+P7ipRCfRwTDKLuEiCyJb8e8KzSYzvPfhZBr7OiFI8dwv/4chMXWcceBLSl0opOm3KPyRz4V3aJDxE72/4Z9gBYNkxQYKfd+182DSWKK+NcfD4t35U80y1AVepA8VMaOPDGwC3DK5SLPa+/N8en2DQQQdos7FdG9H/KoZYjGVdBylYoxwEtHFok7pQlCfqVS9K7FaxsaCk+R8l51lC7U7OzH9cRnpkBQLJRRo2hCqbQZjr3vReVAnscvNZLgic/QkC/WHeYMH1GSnXpOEAwbUwsGHGB4W3eBXVSQtxjwpzmklg2Pp0Lat/ftOctuYtjvfJFTlqNvIF2rW34Qp2hjXI5CvsdNZ75sxNjeiluUMdocOvB0Vr5n4MD7jLq7D1c56pdzWnxYIZV+MAgQk/W5HZOFgq9mEnvRDpSqavDyNuJ36yAiw1TMzJKwuXZo6vJUuXuIQeRRJY7Arq2FYZepoPo9uAKQJLrTvf6Lg4JzDoXk4gAWEgiKnsMpI7zsWONWhMNv6hz69GF2WHO2A3lsXNIEki7kp6+w4S3ea1ijjxe/gLrTKX6qXi1Ok0wnrXN802IEoqhcU+8tBqAbpJEt9blYqx5ycNnCwR5yx4AybtiPAcCDdG9DZiecaL9LuHa+Ja0k8XTHNFyTNj52OzFNUFQVnWsj2Chm6fM2YdRE/vorAv2zLj/ZMeRvSQc8dqArIKGoxtFvZesYP6IbMtyhjMotNN5g/hJvKUvox6e/cCg+7hnbI7WAqcrUtEb7hTWAqwZFioFEsMh1PE7zPBd5BiSy/IyLMa+djt5wu9QtQ9HWLZXwuIaNScYYblTW
 pWgX000k
 pcNaLIO6qu1RzbUSyPY2TRGIED1SpiPqpm3YBvV/WtTl5+VVvy27l0eXz+UWR6rL6PYiT1Bc5TbWK1UhiyZOugvTjR5e7U6pEQ1aknr7E6U6x42/KV364IJJnPsoRmlarFK41GmSxZ+VrNItZcSmD1QRuTAWAg/YO44+3zSvP4U6SvBCGBDo/VI4d5y55IJUCEhN1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Testing housekeeping_cpu() will soon require that either the RCU "lock"
is held or the cpuset mutex.

When CPUs get isolated through cpuset, the change is propagated to
timer migration such that isolation is also performed from the migration
tree. However that propagation is done using workqueue which tests if
the target is actually isolated before proceeding.

Lockdep doesn't know that the workqueue caller holds cpuset mutex and
that it waits for the work, making the housekeeping cpumask read safe.

Shut down the future warning by removing this test. It is unecessary
beyond hotplug, the workqueue is already targeted towards isolated CPUs.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/time/timer_migration.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel/time/timer_migration.c b/kernel/time/timer_migration.c
index 18dda1aa782d..3879575a4975 100644
--- a/kernel/time/timer_migration.c
+++ b/kernel/time/timer_migration.c
@@ -1497,7 +1497,7 @@ static int tmigr_clear_cpu_available(unsigned int cpu)
 	return 0;
 }
 
-static int tmigr_set_cpu_available(unsigned int cpu)
+static int __tmigr_set_cpu_available(unsigned int cpu)
 {
 	struct tmigr_cpu *tmc = this_cpu_ptr(&tmigr_cpu);
 
@@ -1505,9 +1505,6 @@ static int tmigr_set_cpu_available(unsigned int cpu)
 	if (WARN_ON_ONCE(!tmc->tmgroup))
 		return -EINVAL;
 
-	if (tmigr_is_isolated(cpu))
-		return 0;
-
 	guard(mutex)(&tmigr_available_mutex);
 
 	cpumask_set_cpu(cpu, tmigr_available_cpumask);
@@ -1523,6 +1520,14 @@ static int tmigr_set_cpu_available(unsigned int cpu)
 	return 0;
 }
 
+static int tmigr_set_cpu_available(unsigned int cpu)
+{
+	if (tmigr_is_isolated(cpu))
+		return 0;
+
+	return __tmigr_set_cpu_available(cpu);
+}
+
 static void tmigr_cpu_isolate(struct work_struct *ignored)
 {
 	tmigr_clear_cpu_available(smp_processor_id());
@@ -1530,7 +1535,12 @@ static void tmigr_cpu_isolate(struct work_struct *ignored)
 
 static void tmigr_cpu_unisolate(struct work_struct *ignored)
 {
-	tmigr_set_cpu_available(smp_processor_id());
+	/*
+	 * Don't call tmigr_is_isolated() ->housekeeping_cpu() directly because
+	 * the cpuset mutex is correctly held by the workqueue caller but lockdep
+	 * doesn't know that.
+	 */
+	__tmigr_set_cpu_available(smp_processor_id());
 }
 
 /**
-- 
2.51.1


