Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29608FA3722
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BEDC6B00A7; Thu,  1 Jan 2026 17:15:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8528A6B00A9; Thu,  1 Jan 2026 17:15:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779316B00AA; Thu,  1 Jan 2026 17:15:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 616BA6B00A7
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:15:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13D2B13CCCF
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:15:55 +0000 (UTC)
X-FDA: 84284803470.02.75D3FE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 721C9A0008
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:15:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SyFLLg0i;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ApjPO282eYqEcYcf0OZCGawmv5v67njckKGjdm3x/+U=;
	b=vN3r/834oW20tvOD04mfV2OkwnS8dXmqn7V994DFcmyS6PoR7JXYliHCH5zaQGNDagIWig
	OmVJ5hd3go0i2p+IhB1IXxNEHPec1WO+HPdiEg42hZm5DiBnlG5M25vfWnL946q3tCWmvV
	OI6Pm8/ipCfbnXlo5vyYpXM0XZ0178w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SyFLLg0i;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305753; a=rsa-sha256;
	cv=none;
	b=5JxiN6qUDYH4Ck+iC5HrzG9acOyl6alyrRCLliDv+N7EEzbq/r6w4pheQyFpMXQk63a3sC
	efqKd0iN0DaGTKboxIjn9aOOxhR2uON20bcOgZ6JVJMJuUakYqxERpC6vrgVn+QcgUcLB7
	LURoqmOe4/O+PavXgn6VPHXRgiAbgyc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0776C60017;
	Thu,  1 Jan 2026 22:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012EBC116D0;
	Thu,  1 Jan 2026 22:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305752;
	bh=v9YrBjmYoXXJcaUrCVcNEergJy1rpdNBj6w7mIgdodQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SyFLLg0iW6FU1eawRmvnINnCpxzead2omuxl9REafTvn+PFWHvz19FAsri2C1gbYz
	 nmBMznsPhIHNzpbRATsRTyEQmSHDmZRSJpNzzQHYX4BxZkvQqQciqWraphJHo4otMG
	 yKE6X1B02Y0h85ZIcFaIRchoCui9kzgnkUDtVsfAXxYLAi2HJxIA4Yd0JmB+Pqb/vJ
	 KFlIaxmBoJqkoT94z2kMTPUGJ4vpk1jl7UDtwx5C++CbT7Zm18ygJQdm4fRZr6G4CD
	 Tchm5MK1nQsZUtkbmbGbmnfdRBNoOl6ziRKujJrp7iJG93T0zheiYwTQ4Z5PaQM92J
	 1KWjLLM8diO1w==
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
Subject: [PATCH 12/33] cpuset: Provide lockdep check for cpuset lock held
Date: Thu,  1 Jan 2026 23:13:37 +0100
Message-ID: <20260101221359.22298-13-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 721C9A0008
X-Stat-Signature: rcqzkyed4jo3pagw3bc1rj44cgskqnez
X-Rspam-User: 
X-HE-Tag: 1767305753-331965
X-HE-Meta: U2FsdGVkX1/eNt6vqq9gvKER9Nsol12YqEYAqFGqbnDonllvlOlaWaLdhlsfi2ur/FVg5D5Jkxvqu3okoXvGNcRdTOgavxjVwon3vS5exZuwFWoJCEa1mAO+HlZ6u2WhOByMyQGUjuFrCHP2aNFXxSdFe/oq1PIfLOC1lidTddkBa1VyE4Or6Ee1udgG00almUEAmBwIOzQImhWJ6B872ihxCXN60CV+LZHO3hLxvdHNSgOH+k5WWVlDc1taiKVR4oUAcu+jfgTosIpTcfQeXTPrqeuUV/OHmSwhbdiyxa6EB4AAlBhog+6y0X5X7RnWNQ0wfB0Nf2D0abuSuPPjjo37Zaf2CDGvHyQTLYz6JGvCMFnd/CqewUq/fvzbuqI4GlSButnscwE4RAQGNr66DExrjhYOnGPZY7Xup5cF5FNJngYTBHUYVSNrDu10rGnc7oxNW19RLznYWSF3ZdMOpxxfFrNcKGQq6wDaaBrXWvnwJuvWTORbEf2kItM9ZPRiEQjoXumCerQrIBkDk8R4CpceU0Hd4hzgTBYCYxYg6ubYKozjXDRk+fd4M6wc7HwKmJyszr6uXdsOF6BBgwfS1JVoZNg0/26AqM9U0zy9u1bVjmPAjxiur8jedcWgtzoROBCxUrZuMJ1kaNkRjskMPZ3yeMAO70vQjPsqcpElwhqDU5/3sMqPBcx3cPXiuT6KbShNsRv3QY3vtzSGbSQSD9GbkOXWRDhYQJ0xpt28H6D7ApRrgPhWWQPAlsr0tcCmiDOcSTv3aq9XR7MeQC9iRGe+DPYz4mFs7+vSZ1O/lSpsXOMZmzaG6bjiyspoUY6iKp40pv63Jq11+HOnWcNe7yE0tJz5UGODTuq62OamqU58mjAUMWlJ8dGgP1d/Hd8OTdt+LKBvZp12j1/uGGRx48kTv9LsXVD7ZkKVenj5nXY0+SEC5DyT3tEnU53F/gfCgIWmZKzDi5CWSvW2pZ3
 npOVAVty
 0bo8awjFHSYGlkI5WmHEnVZlF+cVA5bwelVAFM5TTBCN/y3MafOqp4QcvJuIcYPzBotMZn06yosgLrHzzmzk1vbsguKvZ0D0nNIOGLuSITsuoQ80YQjPVBGWpd9oTV2gC+wcvmGTO9Xth3NPz0coKCvThHPaHF4s9d4Y6ycO8YRMRwikTHiJ+UIhC+Bnsr4alo0eGUeX78ls+HLijfTgSiz/4CRsweWRG0B2mowkR3pM9KCGwgchBcNiEuu45z9sHLf1B8HS18ErrxhGMD8bCckWY1A==
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
index a98d3330385c..1c49ffd2ca9b 100644
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
index 3afa72f8d579..5e2e3514c22e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -283,6 +283,13 @@ void cpuset_full_unlock(void)
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
2.51.1


