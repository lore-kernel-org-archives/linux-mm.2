Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE7BCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CDA98E0012; Wed,  5 Nov 2025 16:04:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4F28E0002; Wed,  5 Nov 2025 16:04:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BAE48E0012; Wed,  5 Nov 2025 16:04:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 491188E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:04:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4E2FB9B1A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:35 +0000 (UTC)
X-FDA: 84077782110.12.A0435B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 58465A000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cyGGAVyE;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0U19jvwafjIOZHkrvh1p72wLiGgKTY6AYcVHnCGRHT8=;
	b=wx7JuvDc5dcZyzppNu7SyNdgu6BWOi+2s1z8IhwIc9zvkWUycD4+NuKUCUtUNx4MiG9i3G
	ufmhSKIAP8GE6gE16RPaMNpPsSwyt2BiMWTX4zXRnHT152RUzcY1qqxBKO09Yn/bhIbSU8
	NzASOV/nsmAlKEFgBCZTg9tyNCXTkdo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cyGGAVyE;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376674; a=rsa-sha256;
	cv=none;
	b=332MNCLuCci5iHkO1mhtSWF2UXgBPwFB8Bk3/3h+zx9Isv0Ev7jBG5TA7BsA9aH/wji0Tn
	g4SsL+o71cJds5X8L6FHE5Vu6E9KQBzPUgk7jDdMtJjDMkcd6ZU4KuAl0Nq11DfKmA59Fp
	GrJxRpIeeiRRbWXUGoUAZhgP3Pi4OVA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B35AD60220;
	Wed,  5 Nov 2025 21:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFC7C4AF09;
	Wed,  5 Nov 2025 21:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376673;
	bh=ApQa5R07ipGBiVCyA3EgObV++ftyWFoj/ra3rzP5dCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyGGAVyEEtnTJleIGvRPvdX/Cc6KEP2KDLlXtGtmXgRrPqu8Hr6k4dV2PS4NZXG/b
	 0TuJ9Xv9ZVXQWSh2Q5s5CnahVU/19PTlWf5bvziWhR6igHAhOvKcyNWxStp0IREsuQ
	 dCvjHLJNUd14dOSieLUuFACfi9H0I3xpfHEEvQVGyxubT+iCI4qTrf+SBosWgX9JwY
	 q8wUhQKNtbk77Gb5lvCUyYfdwPpF6f8ZJlnEwEOgiTX7YW4gUFPYiJIdvr5mvwbwxf
	 m8/DbHKO9hBpJpzZlv5oT+4ck92P+ii+pCIyA06mlA6F7sTvBrnc5dZH921cfMjKM3
	 ISpiuGCwxLlCw==
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
Subject: [PATCH 04/31] mm: vmstat: Prepare to protect against concurrent isolated cpuset change
Date: Wed,  5 Nov 2025 22:03:20 +0100
Message-ID: <20251105210348.35256-5-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 58465A000B
X-Stat-Signature: 1edx8x69r64oj7cmg31w78a6s3sqcgka
X-Rspam-User: 
X-HE-Tag: 1762376674-257607
X-HE-Meta: U2FsdGVkX18heSFZD8H/I/zU87APl3wKn8fQdUZ8QTEgcGX6aKXUA/NcHen7d/pUWf6/suUTEzDCxrIwiFMDF0R8HFNOyOSk4q4Sf/B5lE75LNVv621MQzFepGce1dpewhn28p7J++yFT7BuF9eojFWeFOE98LaxlHMGPQZ32wA2/vmWn/33i3i/7nFFjCDtup5rKv8MPohMehTWrqenyiORnRZXFM60Gp+qRYK8/hvNHVxxuKZi0J5g6KQlQJyB/6qylzO2SXeK2BSjaimG4y6a/aPpjiysFkb9VC37qjJLTd98y4y8pwDpbcy/EXolgZ3CYw4KgDC16teol4vb+0YCiha7tVRf19o2nY6v1Q19tzgTNPo5pJdpFTxtUO7InTnKaYx30IvLyDwl+W+LFDvWciEl/oO3Azvvf1qpw3Rv6+05FxMuYBvryzsMg0/nhhDVb/1kAF1+fynRQSPm68yrlG9RTdEa0hXk+Z6ZpWhq356tzuYmIytEfANnli476HLL1MUsQkBbmCH4xGhQ9+KVMlJmhlR/XR9iLwBHHigoEqlhJWJZpJPxDTzqW1sJU3B6vpMklSTKhB75golfxeRXiXgoeVTOixcd6z1IkYG9/jw/63PvTGOjTtMUk8YZZkn3+T74swMNLj3fB956kLhiBI9u/0Z6kw5bQMYpfBGrjGM3kfG1akTHxpCN8vyN7LkgaCen1JBfVw0aLyM5r2NssgYzpzjgdyoxdXJTM9Su2+kkRIKufj9xxhE1SEBA/i/XGCCzxh/Ql8adPJW1BycevIQBoutnHhHuebZ0w22PjhfNB5xuXa0jQi2xaMzfLy2Dl/Zam/GGmitTdhOEscJQUsj6cCtQ46xazbEAmAf86CvBwbnCMyfj9vow6hG5cemToJSiASQbhSPhIUUmpcKtBBm/tDI49MLT/EDnDPlJVbtBQlOJgXnzom5P6hSYOqjvfc9t8EUUun3Vuzw
 71GF/jUl
 0ChXG555cDE36vrMLkUbpmilgFfVIjJdYKkkZRqs5V9QVrUDm94voszu+c11byUs8b4veTZbA+USFy6QIVW/Zvpa0ZiYfxxJamnNuIWLRnLw1nMOK30KjS3pfy4PwKuB9TS67rwkR78jWZVL9EZO8wEpF3KsJwLzz3fzr1VHmccU9oZdTrYP3jX/pzpc9lvcH1iptsVYCFvMvZhYNAE8qdgbK54eCjbV0niQoDlOmyV6fPWAhMBTmmoWExrBjz4x6+anhRBoHQU78OTs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
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


