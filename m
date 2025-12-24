Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0F17E75458
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A6CD6B00A7; Wed, 24 Dec 2025 08:47:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16EA96B00A9; Wed, 24 Dec 2025 08:47:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071306B00AA; Wed, 24 Dec 2025 08:47:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E69E86B00A7
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:47:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71A2814023B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:47:09 +0000 (UTC)
X-FDA: 84254490978.15.92B6EB2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C6675C0011
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:47:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="C/dbWhdH";
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584027; a=rsa-sha256;
	cv=none;
	b=s2Ypq5d6fS+I5OBNaSFQXXb86zG43Jf1DQzSZQc3+wHtFZT44hx6Wpk2S5UXlQu0611TXD
	ThWszio8RGBHNsmCctvmYCe2wGB87p33T3utkdM0x7zLB2BB4eEvjPcMhNtBMTcUymM4sK
	i4kGVC9EJp5PmJcsC3btCdPHaXzpwME=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="C/dbWhdH";
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/jKYvdaoFd3YJ6UutURu5Dc/OJDsnXSZ7fKkBxu75s=;
	b=PKcmej/bHZolRpxkvAQ42bUU90Z7wp2oG6Ye5jqoBzEt0/Ld7S9lpqrv8+X4NqzIT8PiFV
	vWW9R7DSxGw7RENS55K91BQxFF9ZTs9etiuuc+aqBtcxwMSej1NxiGw120FP7rLD93GFv9
	vbFRKOOyuydFLZNrNrzY+VKToCOm9cc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F398743665;
	Wed, 24 Dec 2025 13:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9B1C4CEFB;
	Wed, 24 Dec 2025 13:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584026;
	bh=JzP68aQ+gy8MFfasMpMI/FZxkM6LDJNtU1916wSaM4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/dbWhdHD06GNCGUXvq8KKBGhS7inxWnFb2kSbUh+YG2q13AT4k8yht4myZBTW9LY
	 WDNXUNliQ70+na3SSKyHYvY7V+6ql7BC6XxDdoV5W4AtjJjpZmEzdCB6ozDZLcJ1mO
	 gkf8JXfPwIkBk2m8tnSRVdgS5D1AEfuQ7nOTkd7dG+VvdpNZE9eOvYiMUnXmndSnEW
	 Ar2KWSbHVLdXXQ76iNPCUykCXEXhEgt7voYRxOiehdm+D0PHlUVoGdsVEoCg6uqKr7
	 gBWMuK68gDVGd6Yv7k/d7GQeg7IrKw8iBmhMPVgLzWRs7C/R64o3e6O6yGXuXTAQsX
	 KlJDOKZP2jBCQ==
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
Subject: [PATCH 11/33] cpu: Provide lockdep check for CPU hotplug lock write-held
Date: Wed, 24 Dec 2025 14:44:58 +0100
Message-ID: <20251224134520.33231-12-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C6675C0011
X-Rspamd-Server: rspam04
X-Stat-Signature: cpsaeerkmiobfadnuqacswfaomgpreqa
X-HE-Tag: 1766584027-90350
X-HE-Meta: U2FsdGVkX1921n3PDnQcwNv2Vdfp+oeK7sCjnDPBjau5DBJ3S/we3KeLWqFLTWoStokAcdsZ8ekUrJsksAt2L5vfGNjtW0Ti7I3hphSXAPeXah3x/fatii7h8SXSNZGQNCyuIrDW9Tafmm5e/aMS7FhJx6Qgc/ZvwdWw5kkPJKfYFhH5Tzif/LC+6VhXPtzW5+tUjcWYrwXks+nv3+aPW9P9nZa3m66pq/niEyoBpXlmeXNzHsDnBLaAGZCFrYonC28ciuWYM8/Ats+GWU26zeUFvnP87tKBEm7pkrMK5gbtf15jdMVFUUInmyqzg+lWiI4zQwa4JVFqBPvavCYeLGeCfcCGoSYfa+IugjxEbartewQha8wYqz160uWtCY4Vsx3FY+TYFKYbt7MQt+rhKTRRMEn4qq4/K4eTGKyN5tbmUbXjvTdz80lTvexZ3iqsGxlG9AWl3GfS43l5UESFxewmms1HVo+aCm/NQtrB/W6y3DIFFT4bSQE8AOPg86FkY7sJTEPbFfUTYaMXQy96GOOD84+ORYQKZlPVspDsdkewnImdqbWm3xBzflxo6r0bd1idrNTrW9oBlJOE1A6jyuTw1bLq51QYG+pWMSNiiV3HYuEe13a0EmHWez0c43YHY0EN3OElyqY4GFaamI09YkJusBT248G6CZCqAvJ8BLP7YWmV2Cxdnfr3f0j/nJXGY3+scIUtOhJgRAniKUU84R7qJrjoResO+T39jlHj1sFYuj3/31JLMiWgrWcl53VwpWGS0pCifQkFcEomD/eVz9tsZNpbPdX+WzTyvwmcq0rv+H/cv8XdwzF9hmOUCwcLtb1TQsmG7UCEtGTv9Rj3FCe/6eeYaHg4OF+7DNJtA+4v2VR0vBq4s70YpFoprGp4SpC1R1IeryKvXR0vu0qHYUv4gUdJRaCYMcPuXYE7NoA/yVxNPX7OYG5Wzqtc18sZyuUiC7fTUwgstH3xsIu
 9IQd4S+q
 o9hkmiWbe6BlLLRZr2YMkXGZFkcCvJoXJr92pWBlywK2DKwVUm16ddOj9zwDfz7Mrvzt3BbmfspX/fGbW6v57F0uuKvOMY0IYtTg6P3NdXiWHZPHrENzcwIDyrfVURzo65dBQqiXZ2Sb1tLuiZr/pRKHkVTtSYZumwkKiG26kfCJLxJtqAdKj/uCzymL1vR/egCCJQRP0YQVNQ8hT/fM1sqC/9M31ATNPjrPHhGxw4ehXWryl7NusMOV3TU5kcJSi0IbVa+S2GpN+t9o=
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
index 40b8496f47c5..01968a5c4a16 100644
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
2.51.1


