Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAA27CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5038E0075; Mon, 13 Oct 2025 16:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C248E0036; Mon, 13 Oct 2025 16:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B27A8E0075; Mon, 13 Oct 2025 16:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 08A2A8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:33:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9F6111A7B1
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:19 +0000 (UTC)
X-FDA: 83994240918.27.B0763E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5202E140005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nr0fuxx7;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zb8BTW0f0Ao7/Wihg46QLJz7+p0vPQEQj1GFgHqt1bw=;
	b=xoM4RZxmQUn6pRlGRTm5cdThDALUmH6w8y4K2y6FDZx7dv4BmCTr0YedLz4tjDFjb2d7Gs
	+QfQ5GLm2fYxSBzd3vmMC6aAPRKORVJUq/qHWgNOWzyNJFAr4uiM08a+aW//CnniqWYlTD
	9Ma3wx0AsaG4YK6edkB1tAzKESwbT2o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nr0fuxx7;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387598; a=rsa-sha256;
	cv=none;
	b=gKovHAX/xwv58gGpqcwSKsWsfoIycQtRdvzYDZMbWO+89n9XhhgUy7ovtOOI/qrnnfUaVR
	NJzPwWwYQSiCo9wjQ/tX42g1HPVmP/FKIu/voklV252I4q+7NmoIRWljXzmxXm7Kx4Ly/H
	YcF1LXYRZi3DsslbBGg51dv6dYr5gPU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BE6CE602DC;
	Mon, 13 Oct 2025 20:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82C6C4CEE7;
	Mon, 13 Oct 2025 20:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387597;
	bh=069wMqK9bF6D74YIJY8nZAw2J7YjllAfy3UAu+j/YUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nr0fuxx7FtPY7fJU5ejEizbK2Fmcqu1mfEn+GquUnw3jwyvpq3Y9tKq2/T8KUk6RR
	 JZhoiumkpvbJpazECFQNPowuPt0W4T85Ke7okzvxlIm2MuwLxGoEXBZNa3j1904pYv
	 ox/vfzysa35T1SZh5zfwrBb66qwCYUwvfg02dUiHd1kBSvqOuXOjgwiEREbkpvWfRH
	 DZPrxKv8Kag1TTXWVLbDwL5Kk8ngthFxiKL93tBh2gRoCOZY8reOajnxkT1t3cg6d6
	 kUuv9Evj4Q1a3xNZ+yJ2C8CeeZhGjAyplt6wurS9Zo0IGEgcgrZYbW/RJw9DOo2nyq
	 iNjjbjUDB8ZKw==
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
Subject: [PATCH 10/33] cpu: Provide lockdep check for CPU hotplug lock write-held
Date: Mon, 13 Oct 2025 22:31:23 +0200
Message-ID: <20251013203146.10162-11-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5202E140005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: nr7e8hos8pg96168f6ojk7sjwhes5dwi
X-HE-Tag: 1760387598-460581
X-HE-Meta: U2FsdGVkX1/qzthqH066EJ0IZWZvaO2iGEZq71r0b6Q6ZoAUb1K941ppllzySVdAtEdaaCoIS0UHSPYIEpP8qu9q0aYOBoLdXml5QWkdOfjQZY4yBDUrNUtOCCj0FDRYwXNkg8SJD3wFbh/CHzHi3No0Ac6ZA8DFunp7CeKEiJQiJNbWPxlhmSk1Hw9HipdaPEMZT8i7n3gjnK3RbSYNOl+zpMCC7eq+/KCRiR+ptJKb2tIw6NTUwmixMpYjNyS1ibkNTeJXV+ZEvg7vEMBx/iQcNJKM4gszv8c+tVCrTNdWPXpmY16W8pTver9C3nrrqwnHLONmdGE5POGAiCh4f5TUcxfUQLk1+d9eJrOSFucGB4ZviUJVLbqU5f/qyxddahMKaoIBHlqXzPS8kf3bw2eQuAzqIjsV/x02dFakWZgXOJoQGrDsqlk4kKlLsKidgiquDx/ysJSDWBjmRLx/pjXembM1+L2eQ2pA0ig5xPjY/BJucJJ8gAB8iVtwYf0PEY/ff1Vh/o93K4qO/QOEL+5pJ9eb7R/3S91gdtXltq89KkLWwCStFoPX1lyIw6TG/PN8aTVev619H9zlV74HmRZJnKlT7KqR3teMBKKsut7vOwwfvzDDIab1z0icQXId84olU2dWLEntz+GhINRtMA8qmmAGwYcRTZa8oUPv5WtNkgcJMk1yYMByYYSRk1278A6N5GZcMBF+YRBCz9eJXSpZE3B31ctbap9sGlW/yVO8fAIWPLwBYC/kcdHP/iJ7nSnDnQbuHhQTTKYmFZU3/fmex8fl/5iQpVIGVF9Ss0EZiS09vMShaYFyDJr4g4Msnf/nuHpDQxnq2MLmyMquCzzh+idQpVPmv9NOs/Cgp2JRE49smoujjp44QtWk4EF4U0e0XRL+juOzbzu4gB/2g1IgAxn8zJ7bTPzQfiCzQp7MEb7aMluF0Vi5VrIJfoPhq411Tczsn/ME3c8kxE8
 CWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cpuset modifies partitions, including isolated, while holding the cpu
hotplug lock read-held.

This means that write-holding the CPU hotplug lock is safe to
synchronize against housekeeping cpumask changes.

Provide a lockdep check to validate that.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/cpuhplock.h    | 1 +
 include/linux/percpu-rwsem.h | 1 +
 kernel/cpu.c                 | 5 +++++
 3 files changed, 7 insertions(+)

diff --git a/include/linux/cpuhplock.h b/include/linux/cpuhplock.h
index f7aa20f62b87..286b3ab92e15 100644
--- a/include/linux/cpuhplock.h
+++ b/include/linux/cpuhplock.h
@@ -13,6 +13,7 @@
 struct device;
 
 extern int lockdep_is_cpus_held(void);
+extern int lockdep_is_cpus_write_held(void);
 
 #ifdef CONFIG_HOTPLUG_CPU
 void cpus_write_lock(void);
diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
index 288f5235649a..c8cb010d655e 100644
--- a/include/linux/percpu-rwsem.h
+++ b/include/linux/percpu-rwsem.h
@@ -161,6 +161,7 @@ extern void percpu_free_rwsem(struct percpu_rw_semaphore *);
 	__percpu_init_rwsem(sem, #sem, &rwsem_key);		\
 })
 
+#define percpu_rwsem_is_write_held(sem)	lockdep_is_held_type(sem, 0)
 #define percpu_rwsem_is_held(sem)	lockdep_is_held(sem)
 #define percpu_rwsem_assert_held(sem)	lockdep_assert_held(sem)
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 453a806af2ee..3b0443f7c486 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -534,6 +534,11 @@ int lockdep_is_cpus_held(void)
 {
 	return percpu_rwsem_is_held(&cpu_hotplug_lock);
 }
+
+int lockdep_is_cpus_write_held(void)
+{
+	return percpu_rwsem_is_write_held(&cpu_hotplug_lock);
+}
 #endif
 
 static void lockdep_acquire_cpus_lock(void)
-- 
2.51.0


