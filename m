Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFF06CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28DAA8E0027; Wed,  5 Nov 2025 16:07:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DBE8E0002; Wed,  5 Nov 2025 16:07:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12CB68E0027; Wed,  5 Nov 2025 16:07:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F34798E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:07:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA2C7C04AB
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:06 +0000 (UTC)
X-FDA: 84077788452.25.74068AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 19D8D18000A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MPSSO0ld;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376825; a=rsa-sha256;
	cv=none;
	b=qrD1bg1+U5f3ZlDuaGQowpERAbxZnOT89/FHWrp+jb/a7d1n0ad6GD8Jz3i0sWh7naYmpM
	uEflJDZoimqW2AF9Pl0ndCUOtpiro8M22+WzJeQ9A7cM8hhldMf7b8EiJbZoFP6rAvAmhV
	lqubNkCIJT+3e/rsaPPFaBhlo7Zyz6k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MPSSO0ld;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KF8V9p4xO/Aw0b7kAjFceNGTPOTtKngphfeUE9C2pOo=;
	b=y4Zp9acVtzSFlQSvrXSyMapScIbT49rynpQ4lozVwL76q6+5GjVJEy5ltUh/jBcXM9YtJK
	7lrLZ+YicZ7lv/lt5SK0My4TqtxAzppDB2SDgMNF5YQWcvbAlUKdyeCpsmf1EYWI8Yy/jI
	XStu06saXTZ7Y4kiWFqlDCrZAhEBrig=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A6E141ABE;
	Wed,  5 Nov 2025 21:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8A3C116D0;
	Wed,  5 Nov 2025 21:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376824;
	bh=Edp/l5R7ShU52gSdBQzYrc5ERchBT8H20BRz7+yt6ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPSSO0ldnwPIBE+qLDpp1WsWWdAtLlye9zEuu09MzwKOcsHq9395lCttXRPZS6Oy2
	 QOn05QDbGG/4CbYqnqKtnWdiOdxjEzs+mK9npTMOPEuZDA9bFtQETVdHAEUjsc1pzA
	 1pTFXjXqxdXU9XG1PauidLdVW/EBkGM/kCy4qCxc4IXzIWW3k1VFeMsW2ydpAdJHBt
	 Fo8USBYiZkFbocLeiLzW5xWCg3f66bfqZH9ozdEguU4zJotEVsfyX0yDrIyfWA2rfO
	 L/ATG9JJoKL0bxr5s86A7QA3/4MQD5/SOhQwFxy1r/vPat5+JRw+rwnuJO9VjzTpvR
	 glGPUoTcVb2NQ==
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
Subject: [PATCH 23/31] kthread: Include kthreadd to the managed affinity list
Date: Wed,  5 Nov 2025 22:03:39 +0100
Message-ID: <20251105210348.35256-24-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19D8D18000A
X-Stat-Signature: 6arpy7j9c3t3ymohnobjskbgbsf9gwyw
X-HE-Tag: 1762376824-116098
X-HE-Meta: U2FsdGVkX1+LTR4Md8uwVR8Rzg/1EhDRkS/t6FaxVD+kQiVuypX9sCjWzNk+mCPBlqH9nz/tAXZMALKikdyIK+iohIbZfrpbtX8Xu7EhpJqWc8YQ1c3f0TLBTQT7/+SmKPAIGCCkb2H9fJ1hIRbX4J215LrkvC8Isfuzb3F1MPwWknrxy5997FJM9UFBpbEAdviUes6TBtqH6vAg3B9taYshOcUl7Y6v8R2wXYsjl/hjSduSGySDPSrp+P1kkP8MuLONJ4J8WDljqwS8fr2Va010CVH2N3apLjZ3q/jB9/XsqzwYqNVWXRlyEra3d56XmkY1v6eeShfB7yjiXeVQET4pPvFKG5UR2s/a4+H4okhz1+RBRoX34/YExHsFalilhClQyYHFUWmZP7rggp8W6fBpNSmmOzmEI9UnIBWaS41bM/8ytCZIQMGLlsrqaZAfcEhXB6dcXWDP0nzNxr0LDdan7AoMSn3DeFGAs2ZxeGhNt916q0C8zQEU3N8PDKw0FxVz5SfvWYSnC203Er74HgkS+wY1qBvM3Js0MNK3aix8NU8HTGcEpZy3X/wuuFcdYnNgBFWxOU1a+2aE6QbCR8F9D7PHVJ0roDIEnQyPoXYvNEvlZ0gXv9D3BiTuWcjBbCx954k84iUrg/1F6XxMaaPeo3xmSxyAywVbt9p4OBhig4IMOt5cyZuQLDtt5XZMK0EMrstYOldlwl5oLQAZCP6fvrLoJeDcVgNI0ws4OLUeOFso5CHpThwC99vwcKaqCFuUjHH8GKliMZH9WkoFa8SOemeSGVgqZZRv+1picQD8hAHfHG+xH/5cGTkowWID+qclhE09GXBZspjUEKUym+24ZDtZCObu5/z4ClWjuLWhVjPDl8y/6LV1UOMFNu7CoCt7QD3E1C0wskbJP2JsQM335ppp4U3fTSsWjGH1CXG/g1GR6QISsv1aDlJYIN5lXizrjPXjZeRYBlUCPIz
 FQp5M7UV
 euLMOXHRuFACfl0ugFLbcZTxvniX/XUTePJzuqgj2lmmFCNCuIlF9XWzwdvtZ3dogQRGeyXftjhF7iQSngpU13jXU9PBh8Ea3xJUs143MQUv2ygkBmUx8R+1XCHoNIYWCF8FVfE9v0MGR7/uPGyaczf8SB0vskGN3dQ1NifmZwGMNlzf0VmXM+NtGHXvNSikYnvgD0Jwr/SZtfuCq1hVBzSS15i9tFEiJ38xkIXgfQ8XR/0mWqVROt4MrXN6l10E2ge8hGhATK/kvTOE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The unbound kthreads affinity management performed by cpuset is going to
be imported to the kthread core code for consolidation purposes.

Treat kthreadd just like any other kthread.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/kthread.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index b4794241420f..86abfbc21bb0 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -820,12 +820,13 @@ int kthreadd(void *unused)
 	/* Setup a clean context for our children to inherit. */
 	set_task_comm(tsk, comm);
 	ignore_signals(tsk);
-	set_cpus_allowed_ptr(tsk, housekeeping_cpumask(HK_TYPE_KTHREAD));
 	set_mems_allowed(node_states[N_MEMORY]);
 
 	current->flags |= PF_NOFREEZE;
 	cgroup_init_kthreadd();
 
+	kthread_affine_node();
+
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (list_empty(&kthread_create_list))
-- 
2.51.0


