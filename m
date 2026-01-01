Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B43EEB57B
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 931C56B0095; Thu,  1 Jan 2026 17:17:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901A06B00C2; Thu,  1 Jan 2026 17:17:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B2C6B00C3; Thu,  1 Jan 2026 17:17:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 72EAE6B0095
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:17:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43F5613CCD2
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:48 +0000 (UTC)
X-FDA: 84284808216.18.7596B91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B36784000C
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tkk9fQ0Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305866; a=rsa-sha256;
	cv=none;
	b=POO5k5L+e+4eZ7Gnm236HK66dR1svqFDx7i3uHymGh4JmMi6rDLs7oftoZ+d6o+/DFPI2t
	zOE5+iVG+kewMfWsf5DRGbow6RQM7QDaAo5caBsBwMjgDGpcjQcEPGOmWVjLwNC8jBgEFF
	FT9KBEya/CqTOr+ZjLvAIa+M1ksb+bw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tkk9fQ0Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqV0jxEG5BppcU3u+EG/emaB1lxt8tp2Ko8l8KTUFyA=;
	b=zRm/gWUYxhIaU62mLur80MN9lB4uoyTcL7Q6Xz0QOibT3wFa3ZAegZCRQdQQKEdwjPYk+A
	N/T6a/EFY6Ww/0cvME8jXhRKW/Ht01azSruPnMh3IeMc3yutiaqh4znYt8hbg6bl5w9efR
	8oQl7L1g062CZDJlAN8wgs2dXWeQzV0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48576600AD;
	Thu,  1 Jan 2026 22:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8A2C116D0;
	Thu,  1 Jan 2026 22:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305866;
	bh=FTfdEWcmOb6DfQTJTbI0bpXWltHwgECxQBbZ31X7mYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tkk9fQ0YxqsER1NIYCYAosngscJ4AdypdNtqtaJFGu9GcutE6+K3Jp7bcDA3NQOcH
	 Xytzse9mx5JPmfO5GyVTdWYK5YFWOq2SOa+0UwmyekzSxNnR7H7CdbRcJ4wn0VUcE2
	 BloJ1HDGpQYHr1o5ne77EZVEJFAMqZcvAJcxkkwqW+6RYgONx6ovugYS5UJbc3MsGQ
	 46al2/dLj9svm4BceMLmrQv7cEOqWMDC/MJ0Nt9QJs9G8/f/CXDGVdlkiTDzPCRHIu
	 d7zSfba6m/XDB0RQczXhePFboKDtAaVIaMnukN1N41tEjfibT6WhpuV5u4rwIUmoUh
	 uDHS7oRP2rgHA==
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
Subject: [PATCH 26/33] kthread: Include kthreadd to the managed affinity list
Date: Thu,  1 Jan 2026 23:13:51 +0100
Message-ID: <20260101221359.22298-27-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B36784000C
X-Stat-Signature: j5rfwk4xyt79db4gf9anw1oogoxuodx4
X-HE-Tag: 1767305866-997108
X-HE-Meta: U2FsdGVkX1/reiy/OcdpQUobxSM5HnT7qazrq4N2y+LpDPehfRKfW8jD32j15Xeo6vQsGlBNXul0+QIKXPgf+Jqgw2aM2DVQbr2mXG07Dy17N8j5qwhNDRXWzEUrLUAOoRzXeKnZEtOEibGuLP/94684kp+EjnFzpzfcUVWQsSDA5q6eRHNtdKdeZWWwcqyJSB9VU++NVGIGTcBsXzUL+l81Gl0ujdWUlJpznG4PP+R4UFC/JgAFS2OPkLG3kCayHvQDfrVzTvO4in0x3w48PH928wz+KkA/83ccSsRB8E2Pfmmu4SWb4j6wjlKBvAfStFDRj4ZppVsuKcmkZoyOS3ql8b/nRfRU4S2PmMjTZK1fc3OE5mOo8FVUUEr4oGTQiAjgKt2sUNLvfQ5Bh2BbaURIM4Lqaxe4kzb1yuurqZZN30g3XY7TbIN8IN1iS7L62/SQslSYW/mH4ACwkWnlFBTfedQIl4kqKVUB4+RZS5n+IIl88bdZCsSf5/2hzGV9GMtCxcDX6ZCGX9+3MlDQ1egIlYIyT9CZvKCQMDuxGMdOYEGQrDiJ3zgo8r4s3RwBvwhkohXFqRDFk2q9vKRGFLkZKlyfqAJiOapu33iRL0lNM9/tvXwvNd99sQXOT2Fxubc7ta1QLrxvHIdsZCPsY5AsiVG0cwD58gXm8SU7Ndd8srudvoEo+wGZihF4d8cGdCZwoaatstBlVmAHF0jKvwOkwJ2gr0LpQNGYfOenMb0zqqIHEQRyD/o0HAeFCF/BZpXxTxNqx93TAQsyd2rwpLINzIJOiJ/YUdLJzup1dX20rEii/x4L6bP82xUa5OoREynAwauq4mybknUpLOwVXc+737yme7LYU5HxYBqMWwLb2By4kp8vTYwMC7C82V/AT5e7WeE/V8CinEDEfzePXOQ3sqQ3a+aL+PIbvPPw3OvDGRSTjijhJXPVPZA9v1kAQKlaaJg2eSAEw/HMb0J
 vjvXBVhO
 dUZm7ckQsa3jjjyk++a/kj9AJKloutPWJzouKYC4WKFfRXQPt/iZpFSw3iUJ/zd39cMPsXAMLsjWJDf9qz0vFKMeZQUlqm2MBAWDIAgQPKgC5prI5Cbt7Gr9JuOuKJAe40+lHcvOrpKtquInGFowkxZnnNUVXkrlEdnL9v5oH4/F2FDfV0oeIwj2WNgZvvfWPlAi9T6KJaf3btZESYVF+X5DMe8EtnqzZs9+teeXP4dkVqJFw1+eCLCxT5T40cGpMamug45DgcfSlV+jvyKUpPew0jA8aG0Kh2Fz9
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
Reviewed-by: Waiman Long <longman@redhat.com>
---
 kernel/kthread.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 51c0908d3d02..85ccf5bb17c9 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -818,12 +818,13 @@ int kthreadd(void *unused)
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
2.51.1


