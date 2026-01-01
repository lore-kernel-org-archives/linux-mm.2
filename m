Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 031CFEEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 682276B00A4; Thu,  1 Jan 2026 17:15:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66A186B00A7; Thu,  1 Jan 2026 17:15:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565EB6B00A8; Thu,  1 Jan 2026 17:15:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 443B16B00A4
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:15:47 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E801AD09B8
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:15:46 +0000 (UTC)
X-FDA: 84284803092.16.04D9674
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5F342C000D
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:15:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EwXbskvK;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/jKYvdaoFd3YJ6UutURu5Dc/OJDsnXSZ7fKkBxu75s=;
	b=yV7w+VQzJk4QaxTIedByayZHSPmfYdDiwj4XfHdUo/FKnMZyJg4U6412+YQkU8J5wG7Zzv
	CUv5zxcfR+vxCHT3hTm+dIJJSOoEg0gsMpB/PxK4L3oEyg5vo5zdYqsxu40b8X73TOhRz3
	+GBzA4w+wk0hDnvgwFhz2qs+DAtXoz0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EwXbskvK;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305745; a=rsa-sha256;
	cv=none;
	b=KEEJVvP3OGNpc1DlX8YHUlgM+HIDa3aBz54o3JnDbxuSNTw/Xh/3cUnUT9GBL0RPENk0m0
	/RSCs7tRZHXdlhY7VT4zmuYcyMB856Z1vtszqJsznYMfhbYkaGD8XglasO3y6IjN4VySWi
	FhfUCmEMrpRiq9ZXGRaEqhZMcCFodDE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5F80600AA;
	Thu,  1 Jan 2026 22:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B3EC4CEF7;
	Thu,  1 Jan 2026 22:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305744;
	bh=JzP68aQ+gy8MFfasMpMI/FZxkM6LDJNtU1916wSaM4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwXbskvKcD7Va7qJGFYsQ0tn0UygWfaV28ml73obDfEt2Rsj/99pH16UNZ5cR6iUo
	 vbdeDrnnEdkiX0FQ1mimKP2wbxcY1aw0ZvNIjkMuXMyOqBY0x/9Iyh73ce4Y+w7I70
	 kHppkovnKnWEnZk5r0f1Bfjz7WMfMcePEOGtAT8lpEFS3sydbtVf2CFwBpNbWkr23U
	 ZrBbHt43U9Kh1t59lnvVO5fcfcKHNrZLditSrGrPNY8TTkHUjYMzyAnmM4JTQawqP4
	 pB5g+F1jCHz7O8Vszz3059lsP/23VujUCBswiL8zX4qHVm8K2ERG+BbzVyWgnHE1rf
	 akC0dHnN/5uHA==
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
Date: Thu,  1 Jan 2026 23:13:36 +0100
Message-ID: <20260101221359.22298-12-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ca6becysebe1e9omaz6nm4azhgxu6t4y
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5F342C000D
X-HE-Tag: 1767305745-197224
X-HE-Meta: U2FsdGVkX19ssUMGXK95RNfjGBZ3kQemwDLvwT/7Vw0XtJP6FuiRhFr9Aq9yd7p5mZT/NlSqcsQUkZvE8TK68HvK8YzQ/+hYiMOrg6HsG167LhU9gjGUxtKpOKcfA/9yik3e//jb+pXsd8xaE+ifcprmG/h0sbItmP5tZxq6OsajbhhDjU4yGkKgbyLf8dJSIAEc0vuWmRwV15xq4TVgWFzBp+C+XhjN+Qk3Pu14h4EF9wshYisMy1mpMXwXlJjvymZLFobvDQvnYxVSN+eZUW+GIXYMXPkmiAbkptPimKaBwkTvn3a84L8NK+YGUNeby8Zg+j5UqBdxR0Vbz5DxeRuA8uF9ROzbRhoRbDiQbHjEbPze7hpjccngMJTS80ZaW7nZz10BValsfnguf4t0IGu8/nY/kaMmdSVZj5WWeMjJVek/3bkMlXBM4oqvfSyg+QKrYDfWOXfDjSGJ42Ql8oreq3WJD0EW4NCyvcMn2+rJTVu/G4BuPZmUmxDRGUm1lQipxYZXJsFpzSWUN+223ppQfFQi5nRoWgPN70fTqWr3hEq8XM1OFzJoPgRsiyYgzoFS083kBOf1Vg7DlsnbEwA1LZtjKfz1sulyhgSWEaYRlKCGhLbESmy78M8UG5ShvOIoFb5hBR3DxHOPYl9C63oXICXZtZI0BDqe5ME9sFAUD1ypSCK+0QBv+xr1MR8UPIpK0oLlD+J3uNTm9A0XQC2OCzn/2Oni+2G4iMPEx589cfNzP2cm2KYWW3lXjQDqeOWYTTJ/uurdZ4GSs/JbHtxpTZMAnA8Tvpw5qhpP2WPLUNYTEA53zuV5hMlCqHsXDfWrNJ12j35ydzA5j4NJOteO5sw7sUJhz0x6WW6OxRsTVL05L08/HGYXhvJOqlvlsQk++u4/rowebZRvvJXJ2O7d47UDZj7sqOiE8efzFvgDd8SXrw1DFdjTzRSm4GgE7KgGpaJx0CfoyWj8O73
 Qmug3wXt
 W3JJdS9DPYm45vN/mfk9l+CWSAlA0p31SVz2UNr6Y4SVpjGDajEc/iN8JFYzYNlZpVOWA4eGWVbLG1h6sUkLI+0mhbFJ6u9hSjFTbwTYJUFHTo1gou1MD1eqIfDD3vo4IsssoKRYFEN4Y42E5oc9/+MR/cQ2t8E+l22su/xVUfQb4Tr8Lhtdk5uCU/8J1+BDr1oPibj91gmbJDxRQ6YRyaumfA57tqXq3qhAisN7x59SPAkM6zqg3EwU2PuO6E3PF2dDMiPyNmcbRhJk=
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


