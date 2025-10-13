Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66A59CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2918E006D; Mon, 13 Oct 2025 16:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A626E8E0036; Mon, 13 Oct 2025 16:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9786B8E006D; Mon, 13 Oct 2025 16:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8631E8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:32:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B81A59A6E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:24 +0000 (UTC)
X-FDA: 83994238608.06.C76001D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 92CEA120004
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dmGHLoeQ;
	spf=pass (imf29.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wM/rWJ7TG0Tzgn3V0RdCFmqH5om+9J78iTD78iLzeE=;
	b=INRtut4Ke/ESk76JWKheyFgTRrie0OswpCSwTaDT/fgjlFZP94wEfUej6YXKXE6+xUDnBM
	L4SPZYvDVt5YoQNBoldPpfSCMiREVZ396RgJHYl8tO7duaFeyWeozYlO8wbFr5yI5iEitw
	4BlMk8iuOc0qsWnD7arv94m1f9sFZko=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dmGHLoeQ;
	spf=pass (imf29.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387542; a=rsa-sha256;
	cv=none;
	b=C4iwiKT5Dbuux1LIfGJYvLKVTh7WHiK+J8/5CusmyBvII1vV0NsBNVu9r0ewlckpFdq12C
	LEeelZS1XI8E/FklL3UipTg9I94wrXbqXbvnBcNfDEFcBK4UAkk2GxswyvFkZwixgl9lzk
	bv6Q1sTQ7xP4L8IjI/t6LhOH4sucTNQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0945461DDC;
	Mon, 13 Oct 2025 20:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7294FC4CEF8;
	Mon, 13 Oct 2025 20:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387541;
	bh=+2t7R2V0qL5AZXIuxvaOr0dG5kK47CKZx3qBR+Y/X6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmGHLoeQu0b50FoRUM/araypa2rlaqAhrIYYiEnl0iKXC/N7vYxIlcZ3M7iYPRMAe
	 zFQu+ud1bEjwMsEx7T8Y+JRfgDWzi9zbXIIMBgE+Imkdo6aGmMQFYF1qoJbUSLMe0K
	 ucMgaKsv3o8ITmLIA70YEYnJ/nrhVocC5Urc5GABJQfQ0gLdK3fRptNqo7CmxOQrfH
	 6j/ZDikdKGBgPPM0MBpNsDlQMtNSzpxTVfoWG2S4Hy6LGzfnbyk5RFidBqj3RkIkpg
	 cvWuRweOaVHRDHoollxSrfaWT5pdiKAbzV5q2SzRet26W4P41N54tHYj2ExqCb0z6Z
	 9B1F6flUKt28Q==
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
Subject: [PATCH 03/33] memcg: Prepare to protect against concurrent isolated cpuset change
Date: Mon, 13 Oct 2025 22:31:16 +0200
Message-ID: <20251013203146.10162-4-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: spsfj4prs5pyznrzpt5suxb9dgcbwxra
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 92CEA120004
X-HE-Tag: 1760387542-101980
X-HE-Meta: U2FsdGVkX1+FUirMOAvTpM5WwVbAx+1cgI7w5mMvT3uYQ9Xpb9A+rUwVdU4R5EdVSbuRV0vM+2ETsYWoFWo3/11xJT449IY01S4CHcTaiyPDqrnpJB07cU///iiHlDBF5jO6VS9p5JbB6ieVH4FGvgrXz59Hdez2j2J72AGJrVjxiBngb7NuX4moV/ionYKeEOHrqBbbxkHPvolqW6QcEM+hmwKBq0Rlq5nb3xZSa5NIHKJoruRvSjhwpyad1W3z0SpK4HnYYZb5oJyVn8pana3W9ye5o/QMpI6/8ltv8upfXpWtP7mzHiMwaNqEGaWSOLumbsfmlrbLRKJOIkka9dziQfLXXLcEDOfNJ1uvyNqNrq/3L7GkPZ+DRoFOXeSmX9ZH4qhGFVDgQe2uJxaBF/UbdFHpuKb+vxOgPPZnCbLEQem4BL/1J2qweL0MhVju+7qI5sXh9fsoP19ZLbgSBEn9TP19yfcTdhIehGsmAA01d10aKUpS9r/g4BE5U9EBpJ+n2vHLNa53atLL5M8KipOMOQozv35HigQIxZW5TfBI0ETCgFPGDFMbZ3O3kC8ryWlJHitIC65P5KkfAYWAsNjZa7dEfy21YH8uiKQ/PgVW+kpkrlU/qRYGry4DSaz5dS6J2ws7v+Dqx3HVeILlfJz15L1yPrSPHep68gY+Sv1GclnXh5YKnadQ6BQ5iKngbSUQxJwkrOTSkBFB027FLIlFWaiRQSfOgtTrNdxqKyIuQmkZ4O/psPCkrHD15iwHLtMiWs0hhU4HULZQM7+Dfzwgm3G8mGz4PYXVfDRP52r/fpdhuGmLOaNlsdDwH1V+sFbXw3FJZ829fK/8ifvSP5CMgskGhKcOHPeUnNf0aFrZGY3NPE0FW8HGxGTnoYFQjkAqXalgPT8b9UJ5cUBsTrtcMtxjkc/fRoZCN+TFstzlC04b1m55dDEySYnMzQoufWonDUckynVYgLd7Rnt
 FOazJ79Z
 ahTmKRfbK46s4Bzz+1f6NwkfgbGevQxrGNnt1DcULCpFzQKeZABNpYm77oUl833b55FsMrP0pQJkXXUVybrvTRrLEBkB3kgZM9Go0oOvMFGvYw2xYotQukj1ZP0WHuAshrmU+0VW2SpbjPOhWUpmIkx5n6S1VBcWBnVLuxYW1GDXG8t0hYx6Q6cjbGNTZGSruJiszrjX6QRNz0/e0r3Q2ZFEGH64laeLcTaVqSZpSPmkvxcRdfH3C5TpNt/Jr/rb8H1zFXu1dLlmWWRY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifyable at
runtime. In order to synchronize against memcg workqueue to make sure
that no asynchronous draining is pending or executing on a newly made
isolated CPU, target and queue a drain work under the same RCU critical
section.

Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a memcg
workqueue flush will also be issued in a further change to make sure
that no work remains pending after a CPU has been made isolated.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 mm/memcontrol.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4deda33625f4..1033e52ab6cf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1971,6 +1971,13 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
+static void schedule_drain_work(int cpu, struct work_struct *work)
+{
+	guard(rcu)();
+	if (!cpu_is_isolated(cpu))
+		schedule_work_on(cpu, work);
+}
+
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
@@ -2000,8 +2007,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &memcg_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
-			else if (!cpu_is_isolated(cpu))
-				schedule_work_on(cpu, &memcg_st->work);
+			else
+				schedule_drain_work(cpu, &memcg_st->work);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2010,8 +2017,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &obj_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_obj_stock(&obj_st->work);
-			else if (!cpu_is_isolated(cpu))
-				schedule_work_on(cpu, &obj_st->work);
+			else
+				schedule_drain_work(cpu, &obj_st->work);
 		}
 	}
 	migrate_enable();
-- 
2.51.0


