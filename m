Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37975D7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32826B00C1; Sun, 25 Jan 2026 17:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD5F6B00C2; Sun, 25 Jan 2026 17:49:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9095D6B00C3; Sun, 25 Jan 2026 17:49:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4E76B00C1
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:49:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B0FE8BFE7
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:26 +0000 (UTC)
X-FDA: 84371979132.15.F641F21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B09E6180007
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XMcxUM+y;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqV0jxEG5BppcU3u+EG/emaB1lxt8tp2Ko8l8KTUFyA=;
	b=0z7fa4W/7VxJgoGSzD1A1LE3OJbCM2qX4Uh7W2cx0ttgn2I1o0NvhTrVrI3WgJng1fWEmN
	1dWRueTn6xNNXc3BZHmNO+iEXmKT9wfIxrprmD66s6f3/Ydj1T0MnVWnCAKzLdf2qUp7BA
	9zs5ZDdDSrEdj7NY53IeaHXHSwIJyAU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XMcxUM+y;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381364; a=rsa-sha256;
	cv=none;
	b=r5sCtxV7q9LqMQukB+cvlyHCm3mUF+lDDKoqCNLuAOXyHThtZBc1GoZnUtGAboirFOYSTO
	WIQkCnMjhxfCl/asWd0UEaUywl045Y3Jri2YSilWidAQFdK+DQ1WQgU4aPVdddJ/srEB8u
	9w2cbyVhLHqBvWs2Bw2VxZeE0GWf4Is=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF6AB40534;
	Sun, 25 Jan 2026 22:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3246DC4CEF1;
	Sun, 25 Jan 2026 22:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381363;
	bh=FTfdEWcmOb6DfQTJTbI0bpXWltHwgECxQBbZ31X7mYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMcxUM+y8zwl/B5ZM6qLijBt8PpVzUJS0ExIUBKq3Pr+17yI5eqE/DCk5K6IogDpS
	 Ab5JmBSmKO/xfwevciVu/DgjXNBby/p8gmQt/uKmdvW8Ancmg5iqtWzVB3zrIfw5pE
	 YFZKtfsQXGdGrjJwts8JwDPOPuFQayB7+WXHoA7HGXODt67y9xqFHadzm2HhPXJfXs
	 uVGbVjNmEJhJLkM5BHC96duZkXOf3U67tMM4mhZmATXQzZtn5gV899YzmyEo+5j9vC
	 ZagSay65D2aX5KHjsbzu6IqSMfxRclXF+CE/uLzvxe/xC2rRaTuY06nyCNG9DDAkTY
	 UBg8IBX+vc7VQ==
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
Date: Sun, 25 Jan 2026 23:45:33 +0100
Message-ID: <20260125224541.50226-27-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: s3h6pe6coib4w5kr3msfgkh73tx4gd4z
X-Rspam-User: 
X-Rspamd-Queue-Id: B09E6180007
X-HE-Tag: 1769381364-592459
X-HE-Meta: U2FsdGVkX1/kRT1s+6qnC6Gf8Qca1tBs2XQaY9X6AdehLgOnf/5j2AZDtCBavlqox1xgNcXgsFd+KZ/AlH0esj0U60dG5UdpK7nFB+O/1qFuGF5ExCvZPiO4ibpc7DZY2lLCpEJ42UpH6KVeqiib0LV2pv4brhrNuYUlTJWLRj9+0PAiLBlFk7QqvnvENngO9caiTpmxsG/igDKBBL9JNzWtWHXXUFYXmpBF+vFk/6d3DFiHaqknEhGN8lMKH5laA7jkAEvZTow+Qf83+D/3bAfq8nuQqxdRDnJLI7ze4HSofhSCGxUTH53xRb/IrqfJTVCiWsNW/c9ZgSHzIKQeb9eHutOywbOQUJMQWKMKHpxjmBN30JWhpHgpIhOcZuwjScOLeHBYDgTlaxcJ4WtmS7VJQ8NXJLjs6HoF9WuPThHV7N6kcJEvohHQAO/9Xewzp4KSM6Srna/CFASb1B1HznCyLHnbbiq+xugc65AsXWfYRGiJJwDBY6EPYz3OoT87sdu5A2+sp8YJp7lcoekJ1rrkQEZiYnN0HhUmXXFZE5x2Zpipmj454yzUg4X6aPCCFejEfMdSuie2+1PVeavk74eGTAi0P/7bJ/dACtDS7tx0alAEQN/QGbb6JaX6OTdj+x0afMrkSVDgJx4SqBjGFPWYpDw1Vgxh/bANiHl+SK4DPj58V9zZQ13eVFQwnPSApwMf1WTXnFiGpHShxOhwfBnwoiWOSOr3AjXsgWqQga08y8s7r9BH5BK0kREh+XutILh3YoBQtC8iGjlXTNuzCUZ7fu4jQbAqoJEB5QRXUIdsQZAMiz8NomZgWPi2OxGuj2gpwopeypkE5Ee0CvtKI8oU318OxnDkso2GmE5Q5TAIRwBd5ZmghajfBo5cJqb5/85F9c2wSXJ1FMyo6RDXRpKBRWsuWjAhsnqAm3Zs/T5BJQiyma/QAMBAKuqW9bLq0h3xAZHNgMC0ltoKHmv
 XcS2XZQ6
 5m0rDFoO1JxdfGgoyZmfLzPmgaXd/zkFLZjjZUkBJXHqrE+OOyZSiAZHyt3KTTDrAjzt1/gS9la34SpcKs44+OoLikjxMDQgSYnT7RvtUw9Z1jak2o27zvIDbXygP++0OB0vEtXz02vu5oAr+vKepxtH9kAoRfBgIbhzPxBVMeoTbUtMYg9R3vLM+fUe/VnG1ESJIarUEss1JwzMHlPKhAR3cf9pw+dBgVvC/HB7QR9E6ifYFt1CcD+sIbMAbeWIZ4A3HXY/GRmyDjyZLWUNFaklgjHrHToX8lLGrrEUfVPvNSME=
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


