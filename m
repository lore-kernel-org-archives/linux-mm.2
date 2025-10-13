Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CA84CCD18C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88F2B8E006F; Mon, 13 Oct 2025 16:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866C78E0036; Mon, 13 Oct 2025 16:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77CDC8E006F; Mon, 13 Oct 2025 16:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 658BE8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:32:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35DD01A05C3
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:31 +0000 (UTC)
X-FDA: 83994238902.17.B28DD5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C63DC4000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E9QIBiXi;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxlZG7DL0iHhX5/Y9tVzDv+y+uW134MKHXXUDW7fdvw=;
	b=J137aWX+S2NykyazXA0JVbVd9QY2K+zeciaA7GWH+V9n9ojEj6PKLMgbq0AYLHTbI5krCw
	fPexhPh/FR8YAlLEt0WLY73EgcAqc/zq3ch1xdug20ncUqVaA2e7PYPmO0xZFrdWV7+RN0
	L/REG1BvCEemcxk9D++hcv6+baVeimE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E9QIBiXi;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387549; a=rsa-sha256;
	cv=none;
	b=BlKgtA4GD8nnj2/XvEsnnr1jwnILKHTfQOWFCVH1ZeDKF+utxteQ4gBkx4oBWK8ehXB222
	BCAmI/F8pNntvac7ATycHYhRxqggA2cfQ+qZ6rZdVY0VRLiDVpSQAAqt5vWFjGkaedtQaw
	46+YfEYt5d1/klIPy4PfG/m3i6cqDHQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 39D3E61DF0;
	Mon, 13 Oct 2025 20:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF1BC4CEFE;
	Mon, 13 Oct 2025 20:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387548;
	bh=j3Yn5NfIqiY+L8eK9Vhd8gsEecPCt7Wufp6RLuexjXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9QIBiXidYsZWsu1jAbV5EpCQbVgypRg6OIyTAb8uAKJP5F/YAKJvhjAfNlvkxDjW
	 awaI/15P+xNEsT0NmFWdETXLffdy/5VaLpBO+YuXJsuJToTfLbFxHxR6dAoijF67md
	 QK/rRPUUSF7rF/ey5AbbxbDn8n4O+o20A/9fGxfVCOBlR8AR3UG+IawKTys2dgVT58
	 zJDnygaDk2Ds1Bhdc+XOJEzvN4u444CFho1+rpg3teYAsFo5vo/4N8ZLTLRDLXjW4S
	 +EcIwRduhsS6CUfrWGbJhLmqHwvOepcsLlrue71vdu8IfPkkex48lCiRrlhh9fpMpi
	 8rpXiyrMupMzA==
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
Subject: [PATCH 04/33] mm: vmstat: Prepare to protect against concurrent isolated cpuset change
Date: Mon, 13 Oct 2025 22:31:17 +0200
Message-ID: <20251013203146.10162-5-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C63DC4000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: gah65n5ny1iu77m1fd4kcutqn5kdyyyr
X-HE-Tag: 1760387549-39580
X-HE-Meta: U2FsdGVkX19RgbRFWHEj24L+cb2ytH6ymwxa0DcSsM7SWHzODZugxkDKYxl2QQYA6D1ICnD+Zx4EiQxqXG1TQC8EZtAfcBprl5Va4JKHXBGojgUreFpNT3QF8SJm6BaluKv8rzceZCGnmD9SUdsjRyIe50eFdwoyM0dKQt9XpzXZC9xw3Q+CXgTyQDJuLHqOjgkznQ4eFot2nT8kwg+jWUZpMogt+h/+qqfnePdtfjZ1ENuDKhXQJWxPIojYAo+aYK1Tvx0WiFiUIjJ1xmO1aNroLFDBT7zEjhhipNCYMUuZXrbJah16oGIzRcMLqyGgoeaqksjhBZ4hjIJsnwWhSXG4RC+9GD+wLPzC101ygpSj5rwfQ/RkUxKdt+5Ri1MwgqQ4Zwn5QMwTrslYb96EV9d6uzHPdrga2WE28nHtxoCychdbdyJpTDpwNHSiZyaI6+amZ+YorFv18Bu3FnPrlm0H00jB7BJsriCAWDhFAFYZ3/44bexUNzeSprg/p1DaGYMDIXt6FjQSzXVnSh6xPvgLvZkeZZ9MpmyDlSXNK+l99OtEjQ78jA5s+WApHxRewJLbiPx6Hzi/OnXVAO5zcI5/5BGVZUQteIZ/6jq9ZalIp2hOsCbRI66J1PmedyDPIQEHU2jcxhqeqKW3xUmKqqS6OYoeXk8P7ztqUmeVZHU3rsPu5svAPo4QEHFWJ1jq1I2c7WEnP9Q086NhWoFQJbdnXe/ZiC4iex/8938zXnSu0CoA01KCXddSgbesE9P1oaQE3t0kYRRLLHkKKKEpNHOx82HH0XXPBuDk4Q1OD7agxtcKpVkRZBHDFW9nj3MTA5f4n4O/C/Uc2jcjLHZGBjXwepA3D638xujoAGqQ9m1044U6+sYH8fY7FVgB+3WVwOFpr5jW3ruDKY/VbtCK9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifyable at
runtime. In order to synchronize against vmstat workqueue to make sure
that no asynchronous vmstat work is pending or executing on a newly made
isolated CPU, target and queue a vmstat work under the same RCU read
side critical section.

Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a vmstat
workqueue flush will also be issued in a further change to make sure
that no work remains pending after a CPU has been made isolated.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 mm/vmstat.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index bb09c032eecf..7afb2981501f 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2135,11 +2135,13 @@ static void vmstat_shepherd(struct work_struct *w)
 		 * infrastructure ever noticing. Skip regular flushing from vmstat_shepherd
 		 * for all isolated CPUs to avoid interference with the isolated workload.
 		 */
-		if (cpu_is_isolated(cpu))
-			continue;
+		scoped_guard(rcu) {
+			if (cpu_is_isolated(cpu))
+				continue;
 
-		if (!delayed_work_pending(dw) && need_update(cpu))
-			queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
+			if (!delayed_work_pending(dw) && need_update(cpu))
+				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
+		}
 
 		cond_resched();
 	}
-- 
2.51.0


