Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2728CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A21D8E0082; Mon, 13 Oct 2025 16:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279B18E0036; Mon, 13 Oct 2025 16:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18ED28E0082; Mon, 13 Oct 2025 16:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0622D8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:35:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE2C213B670
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:59 +0000 (UTC)
X-FDA: 83994245118.12.33AAE33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 23D861C000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u4POBJV8;
	spf=pass (imf21.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FKDACPjgME0JvXqDsvgIUuO/Ttx5g7TIauTBOF0ghGY=;
	b=E5z/qwOKlhx8UiHJpNg1Zo4wwd0dCIesV+zwYslCT4vEaTAtGkY/uqwxm9RnU630ApInBQ
	S28eB9bJcZkgpv1YCB4LSRi5r9EUSEm3n/pyMLS/pQMIYx3nKUnyfCtKp2Xvlt0qYQL+YB
	TEC4m6npe7aNX7uMePg0Zp3xlpc8irg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387698; a=rsa-sha256;
	cv=none;
	b=5/idrAo9ZzIHUTY0Rgzz9b46mo1YxLA5E+OXcnIzQgYIoRj6qr1Ve75mDF363U8if/errc
	Wx703WB3Uj5F4KfvMsPoAMGz/obLJV553A5RU69Jj7igIftzk90lg75Qemi3l+8YpZTvE4
	f432qzYmMhCalJEvvNidb13x7YzpJN4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u4POBJV8;
	spf=pass (imf21.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EEA14056C;
	Mon, 13 Oct 2025 20:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB20CC4CEFE;
	Mon, 13 Oct 2025 20:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387697;
	bh=pzOS1AH2wHJHSLxWx9UNzEZr4fjsciwBuMuPCFGnunY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4POBJV8Q0FYAriEUpqMBAwcUBtO9Ks+qUN2STRweeoy5m/JKlJepbuN1MXuQsKNJ
	 tmaonk/Nc31OweK/JMses9BdyC7b1ULpJLkElOYpV6EBqpWRnPU3NC0nWTBtzAaN9h
	 mm5J6raV5dmzXFtU3FdYlx5TsNUj3oLFgVRbAabCHBPzNBloUXUldJ4QpunsiBoE+a
	 Cr7Z7DfzVjv/pvCbP3VNnAeBhRi8KZpXAvj18LiIvZQUz1RXQUX+joCU2bzRpMmOng
	 EnSyK7Uijn092Jdb2o2dcpRQGVjI9xPT9qNJeUGoNK974o/GVvTOfwmu7hxYaVZlQU
	 kI4eN3Qob4oJw==
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
Subject: [PATCH 23/33] kthread: Include kthreadd to the managed affinity list
Date: Mon, 13 Oct 2025 22:31:36 +0200
Message-ID: <20251013203146.10162-24-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: o4uje49ygojdzoawaxuodr8mbdtmjgju
X-Rspam-User: 
X-Rspamd-Queue-Id: 23D861C000C
X-HE-Tag: 1760387697-449718
X-HE-Meta: U2FsdGVkX1+v7n5sKoh5iRCSNdqXpKXJOMIU+q5wNP4aT5hdO4cHVelG9Qo9sHsNacdhn/r0dORqW/k8mEolMBLzxFoqAA1Rn2Xgeiw2CjYIOhp6+Jo8FeEMLIZMKnWGGcEnbjcvEiBNt9On1hPdts2qNDiPMnAwkmIqM3B09IcK+64g/juc88MEHO1kzaV/Le4m8/DeGfx4SitG9o+Ubetypxzs+0NnmgYyvPk8dBoKn0LMwknECZfkKJQin1Y876xnzOeHJVd1si16xgTK7rU+Avk6sddCAfBzpvESN3I6hfZi1tMb5tBeJqZQaZo+iAtjN8v8SAedCk6ecYpG5AqR11A/g6GAEFxVL5zM8nqaM29HY65FwGXkIWDkxnS1ENXLKOkrNeTBQOzlAonWGIo2fnXEFgpaA8PMc9BeMABg9agzMmDYRNTyTANClW2bfOzUsQxhphNFokR4ckbrK33coY70qV9WvqL6LVT534AmhQEUt5VOgTwAnU7vgkh5vAB+ermDt5v1tcV6EDj41RhuTaH5yGog2X12dqA7ok9zTb5ARQRIug4/uIZblvTkXcACd9QcnZFRYTlOxt8auH/xFZZLTwO8q/K+bfi8JlOm3DFGBXObF2CW28kLJO2QtTVubb8CRU2HZap988y5MgZQz/KRAduPEYOuKrFnxled9UTgfUYvmMyulGQNTd14ujkXIbuWxouwebA72OkRAs4D9Ve88hFnUB7+cG7R5IisSPCFvhOppd/HVUUf5EjpUoJm8NiRabPUWamkS8GcavJ1l8VgmiIlQ/r9Hv70nUDOL4Tu84QN0Um7Qjh+24XrFqL/m9ZScHZDx8eA1cQCKbUOe4Xj2RbQUHpQEnn2FgGLTqyCEqzF9pJgQ1JMojPrGkmrjRtWblgOh74ioHTspzXjoCNAu1pwrLPB1PlxG3R9zj8egy/SNWRGA4BFCYIVZDI45oMKOKQ3Y/aoFbw
 oNMYNle+
 GVHah2KznQCZbrZaDQBRUQm7s1tV66QyATsPsJhU76eaPRgdMlmkBqJjlkN28sjX6BhKX1pXn/UWRSx+3G78RCvrJUUICPwJGIuolhiq0OYcfLCilVv+2UDvU1OlI55icuUS7Hvq3+jgkXGn1L2/ErmMsLEyxlX0Sw2u+EAa0kNEXIwG3PXZ4ap0Wfzll2n5033t24/O5dOJ6dqRNsVQoRssPWAZjjTjTSova3JJrBwEcVW3Y1+6pSo6R3ME0gs8seYSmB9juzcVP+g8=
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
index cba3d297f267..cb0be05d6091 100644
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


