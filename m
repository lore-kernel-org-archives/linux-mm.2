Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C45DFEA838
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33FB6B0089; Wed, 25 Mar 2026 05:09:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE3C56B0093; Wed, 25 Mar 2026 05:09:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC646B0098; Wed, 25 Mar 2026 05:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 819CD6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:09:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 126A45AB44
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:09:46 +0000 (UTC)
X-FDA: 84584012772.29.9E0D774
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id E5CD8A0003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:09:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="U+U7/nYZ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RyxNuajQ+5BdRvcHNkxzuxTLMc1cMVmB8JwBrt3+9bw=;
	b=Jkw5E55XKCPHK3ErcRImXckuTb/b0JZk4u+HOCG5FU2gvjfyBnglqnTucqEN/YsMcjAkJl
	AE2FzlCBJLInUKk+lmf4XviVZYyAsaa1ra5nC6NfvvFkjTqHErPmBlZb/z4PPBm/S6pGak
	lyHztiDNEUhJKsl3sb802yQuJbAJVK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429784; a=rsa-sha256;
	cv=none;
	b=dSazBfsV8oE5Qtq0C2Ql6rBCgKcho1S2OYBSy0JZabM1lvqQGNpPy6UnfFSlEz7rwgcqmq
	8E0NriYcu1z0QZEV2XgD8I8rFDk3zPbJ778ni0VjeKJiC0b6l8LM3vMvdT49+0uFfRQUoZ
	n/nyjNm2hKFu49KoOdQJ5cL1Eje/mGE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="U+U7/nYZ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=realwujing@gmail.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2c1092cc08cso2893910eec.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429783; x=1775034583; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RyxNuajQ+5BdRvcHNkxzuxTLMc1cMVmB8JwBrt3+9bw=;
        b=U+U7/nYZIj91ApgfX8jK56H2YiwgXpDGz7Vo5CzS4IDRGrnEyDpukqeSpB3EniNeMM
         odkI4KFaa3foTAfh2+8LqLKj8DXN1T3ZPrQWat4CcUckIGw4LAYrWedS4IGQTaGGdURp
         T6m2mymUNQv1bkLZTBPOisL46uJyYMYvqJl2rXWlMpabeXQykov3k6JZSTx/5DRMLirP
         NG+I5LpysBUUnZmrlY6C399cZDJ6pnpLoxZTxoDkpgU2UQZeUSiixDz17UVg4W7rnTaX
         rMuaynDgC+K1R9bPRkC/Au6fsNd2plmr575XK2i8lS8faX0yq7HqAspMVqngStJMODBq
         Jb6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429783; x=1775034583;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RyxNuajQ+5BdRvcHNkxzuxTLMc1cMVmB8JwBrt3+9bw=;
        b=BA+zmA3urAyChdAAhWLGXD5m1KBsFx8MsF8HdqjgI7KsmiFwcIK5+lbWTh14UvXCXg
         oAuLPEzHbxF6GoPFtneMnpnhGLpmWPOs6kaRmbs8iaiGrYHMvQUhuRQHILzYkuccdTji
         7vli2TPBsCURT5lF9KI6v5eR8ZskmHz398PsdR6shNGwGMSL3TZgr9NCH916MfaqNF+P
         azML+ZSxjNSQpcxxT9lJPvXFDoImDRAztDtaIn0R4W9aKfj8cR5gcgScYDivDXEo5iwb
         shr5R0wwbS+hEcKWxFVZ2mLjcs4tDz8XlOgwHZTsdvWc2x8utN7Gsoa23XQZk/POt70v
         qaWw==
X-Forwarded-Encrypted: i=1; AJvYcCU8hQDNE0torRxwfTilkiEioU7nRFgqg5DcE6+YELd7Da7i8vFNpjBDH/jxKEtg44SgtUNTjmrbKg==@kvack.org
X-Gm-Message-State: AOJu0YyMXc8h+bJBHZfdXAzIiShEuZf82sC9mn0ISo8e92+chq1zYop7
	UM7qytso6wFQK3+FbgNDnyAXLWIz+J6pLDEVcngR0HUIfS8+Gj+IEUZ5
X-Gm-Gg: ATEYQzxmP1B6zUkHK+V/oF81IrApGYcv+AjTP3D88HqxOMbiO4DVOm6U2HTFwKmo2f5
	mvloj4z9WD9WY5+ALt7nWNtNbkMYc5p/N2AlVnHu0vrB4zwSKBZA580MYBnxy56xfMwWICtGRjO
	DFydlTcxPj4GKBds0N5DreH5na9xKeqfwIMVMTTsYVj5er8xdIx9JZDNUhJw+oD8t0F4Rt8C486
	Kw9NyOBnT2TEnW7HaedaQrxcZR39OcrAVUEZI/SiBsH1bN4ZCKFJpkuw5lgrUFpEO4TGdkA2PAD
	Gq6cGYgHrPNQ8WnDfhUYp/L3f6tMIZUDW5vznQ38OkESr8W5svnQiEkgXK4hWgd2mx8Sc8f4hWB
	2fICQp4X3RJ0KzdEpBcipx8U7wKpgjhRdQ6AEByZVXKLoEXIOqQkpAEL+KmnE2z1wZ03w1f+Ueb
	nnKmmcxVFRqMmesEKe
X-Received: by 2002:a05:7300:a892:b0:2bd:c285:2f3 with SMTP id 5a478bee46e88-2c15d31d7c4mr1292467eec.6.1774429782498;
        Wed, 25 Mar 2026 02:09:42 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:09:42 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Subject: [PATCH 00/15] Implementation of Dynamic Housekeeping & Enhanced
 Isolation (DHEI)
Date: Wed, 25 Mar 2026 17:09:31 +0800
Message-Id: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEumw2kC/x3MQQqAIBBA0avIrBvIMaK6SrSwHGsgLBQkkO6et
 HyL/wskjsIJJlUgcpYkV6jQjYLtsGFnFFcN1FLfGurQHSyYNaGXYE8cRu30antanYEa3ZG9PP9
 wXt73A7C9sPRgAAAA
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: E5CD8A0003
X-Stat-Signature: tfh18mhr56jcxhbkgq4au79j7zdnuioa
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774429783-297917
X-HE-Meta: U2FsdGVkX18dHhuqqVvN2AVHArT5wsRb6tU61BHELPkth2uC+Wh2UEcDLFCI5qcyNqnVgHQsWU6IvfZQvI+Y3Yo9nLHUu9dd1w716U7sy23MuAT2Ueo0PBlSVnkYJ6fDWgG1n1b6nlTgKwllxdNvxrKIEnHDDZFbJBLfOQ2iJfn6QoVrYGfmyZXaifUwjrQsW4wA7twm2KpRE0IQoX4DvFJnotJKvYRouUvm/FB/hhI1swDhr+4L7hq6KwwxdrEs8iQkUIQssfaRSt5QqdNCT6NHrsaE5myTo/MT2v39GNLwqZWQzhve0EhFib/CP+Ny/x9BaLVF65kQ5INn40eVUmw+3O/cI2gBYfkWc/51kmI3V4l1Ptzkk0QlfDwT51fXMloT74d9EF5/JWkQl4nww8mGDU7sbbPCP1GpN5FXrd7JDpUkbPkFi+iW7S+O3L/mWns1bpwSG5UD14wUaC1ZbA4bMmgC8eJ3Dz+Rs+4YiOi8ykiK9J/6kEAxstHbj92FZexSbE2XywXhIeM3bxa9lH4bpkGCyO4QID3rNjKbgNYQOBfD4okzaCG9K9VdLQrsqllFw4I7QZQyIgltvaeGXnRtE2jR9Mpj3NYTV0S8CSiTwiRZ+nVSy8UPOejkUbKn+e5QV6yo/3xKYZPsOp32WPFKoDZ7hlCs48mDPOWKdswqazAXIu2yCnZeH+C4fmytjrPHAPJu0f23nWkZKEXOqzf/o9Kcoj1PBkFIjJNq24hCZJrHZdKtduhJiFv+3pqZko9UxSz8WrbtOTLZTDdGOYRs4r/Y03YhXe2pZSu38D1AD++yk1TnHg2GBbyNcdNITGtXaZUMTKTecuR9oBdC9N7xNPL80zNmXy5u+XsPMkmjCVR5JEGKQ/0vVa/i8wKM1rabLAXBEv9trCUlrv5XzbbsydL7dnToFYJO3CKRBsWoea6ky4Ilr90ssvmDKiz65U1VNgyyigCe6p28cNn
 XnvflbIp
 n1QEGuZRTBId5SgKXXxbMIlW3whK5wnvnaBb/p/5IMUbZK314WgFmKAuToXtXkytA1HVGdVvOhwLD8iYHMTJswB6bi8T5cEpPD836XIUSH0dKOQ6Y1gv9jPBtisJwvxEfUkkcit4jXUjUA8osoj7nw7WDNsiw/IrGUzJJvIopGNglZkme+JK0zJOBsqld3tXQHowgcsDxKoRjn3hW7Gd4OLrKXD6ZQuW5kywd+EXsZyUBJ03WWyuUDEQr0QalLHp4KdhUCgCqQNCqdASO1ngUSiO71CfGtL2/RSu6+jGNEoeqfllhFbJ5eFCUAJUWoXA0s8Ldq884oo3U6BnkvPDbRnJGKiAcpYb1CniLZaJ683ldPfXQDkj5Zk9fgrPlanfoDVKsLyZHjO5B3A3Pk08fJvbuzaia8GaT+yD3qW4I4407IBYhWI48Jihcs6hauAiJ3qZbzd75W0kx61306YCWip8ul/MLlim4kw8I+uF9YS61Wi11a7XAP0ugSxvPgRIw6VqS9weOsf2iDCxPbgLrFOX/GBS5DZCkhCMabh0XImTt++rZ8q0gtiiuuM4A0tCk1NmYmAKJ2jc8VwI3dlwkHeKYOV++k1s0JCDZvH8zzGts/8Vf8b/UOvEzfav/X5QAVgRkIw6pjMrlUM23Cc7kz2MgXj6ehO6szzOeeGBj39jG4c69MjrhMMSz2TSsiwFe4LIt9wlQBp/AadRSNgLrMhvn3i2fXODj7LlbE5pu7d4+Wl09qUIQ8sldljohmEWS54gH1xqip4tPGvH81ack43waP00mTXuTA2XY+ic6RkE232wRA5mfi7rjPXQQuA1lJ8g35uKDNhgDq3GzdbIss3FatwIbvcO3mBqWY7x0u+z2kaYeTRq0NZGVpbHNO+MSo8iWVNvYjnCLnh59Iv/FW/EGYGZiYlVkPKho+xFrwYTFWRgU3lYvR0gnUaU+OW2kMUo/Rn2SDK79bD8d8klahp3DjuNW
 G5maHKCk
 ssQadJ8uorCF+2q5TiChU0oHikA3z65HVD66M+PEWZAa5C7zvz+uOFuUdzrj0MnYcXUJLtSd9eVKtf+RZZLtuuicF7LBIj9j1FxI/CjT3MAKlEO2lICIm9g5TJBBE+x9riVHxdWpQZCUcjFcIe6rvkSqMDjWNkYKb+x2s6+GAT3x7odYf5qyrEKOVHOY7ouZQJOa3HGVyEFL3NvZpOuZciTyjxwUTvk3V2xRjhub/0oarirLvRqr1I7hhMYmN/8nyLEsAEuqE6P/e5YISC6HNUCdYSvhbtWK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Linux kernel provides mechanisms like 'isolcpus' and 'nohz_full' to
reduce interference for latency-sensitive workloads. However, these are
locked behind the "Reboot Wall" - they can only be configured via boot
parameters and require a system restart for changes to take effect.

In modern cloud-native environments, CPU resources often need to be
dynamically re-partitioned to accommodate container scaling without
the performance penalty and downtime of a full system reboot. Similarly,
high-frequency trading (HFT) platforms require the ability to fine-tune
CPU isolation at runtime to minimize jitter for critical execution threads
based on shifting market demands.

This patch series introduces Dynamic Housekeeping & Enhanced Isolation
(DHEI). DHEI allows administrators to reconfigure the kernel's
housekeeping boundaries at runtime via a new sysfs interface at
/sys/kernel/housekeeping/.

Key Features:
- Fine-grained control: Separate sysfs nodes for timer, rcu, tick,
  workqueue, kthread, managed_irq, domain, and misc.
- Dynamic NOHZ_FULL: Supports enabling/disabling full dynticks mode
  on-the-fly.
- SMT Awareness: Optional 'smt_aware_mode' for core-granular isolation.
- Safety Guards: Prevents isolating all CPUs, requires at least one
  online housekeeping CPU, and enforces CAP_SYS_ADMIN capability.

Core Architecture:
1. Notifier-Driven Synchronization: HK_UPDATE_MASK blocking notifier chain.
2. Decoupled Memory Management: Runtime-safe cpumask allocation.
3. Subsystem Handlers: Dynamic migration for IRQ, RCU, Sched, etc.

The series is organized as follows:
- Patches 01-03: Core infrastructure (dynamic allocation, notifier,
  enum separation)
- Patches 04-09: Subsystem notifier handlers (genirq, RCU, scheduler,
  watchdog, workqueue, mm/compaction)
- Patch 10: tick/nohz dynamic full dynticks
- Patches 11-13: SMT-aware isolation, boot-time bridging, sysfs interface
- Patch 14: ABI documentation
- Patch 15: kselftest suite

Tested on x86_64 (8 vCPUs, SMT enabled) with all selftests passing.

As suggested by Joel Fernandes and Thomas Gleixner, this V1 version
provides a stronger rationale for dynamic isolation and addresses
all RFC feedback regarding naming and notifier robustness.

To: Ingo Molnar <mingo@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@redhat.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
To: Ben Segall <bsegall@google.com>
To: Mel Gorman <mgorman@suse.de>
To: Valentin Schneider <vschneid@redhat.com>
To: Thomas Gleixner <tglx@kernel.org>
To: Paul E. McKenney <paulmck@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
To: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
To: Joel Fernandes <joelagnelf@nvidia.com>
To: Josh Triplett <josh@joshtriplett.org>
To: Boqun Feng <boqun.feng@gmail.com>
To: Uladzislau Rezki <urezki@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Lai Jiangshan <jiangshanlai@gmail.com>
To: Zqiang <qiang.zhang@linux.dev>
To: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Brendan Jackman <jackmanb@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>
To: Ingo Molnar <mingo@kernel.org>
To: Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: rcu@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Qiliang Yuan <realwujing@gmail.com>

Changes since RFC:
- Dynamic RCU NOCB rewrite: Perform full runtime offload/deoffload via remove_cpu()/add_cpu() for online CPUs, with lazy initialization.
- Robust Timer Migration: Added logic to dynamically migrate tick_do_timer_cpu when a housekeeper is isolated.
- Enhanced Isolation Safety: Hardened sysfs interface with CAP_SYS_ADMIN checks, 0600 permissions, and strict cpumask validations including SMT subset checks.
- Lifecycle Cleanups: Replaced system_state boot checks with slab_is_available() and added hotplug shutdown guards for clean power-off.
- Testing & Docs: Added comprehensive kselftest suite for isolation scenarios and detailed ABI documentation.
- Link to RFC: https://lore.kernel.org/all/20260206-feature-dynamic_isolcpus_dhei-v1-0-00a711eb0c74@gmail.com/

---
Qiliang Yuan (15):
      sched/isolation: Support dynamic allocation for housekeeping masks
      sched/isolation: Introduce housekeeping notifier infrastructure
      sched/isolation: Separate housekeeping types in enum hk_type
      genirq: Support dynamic migration for managed interrupts
      rcu: Support runtime NOCB initialization and dynamic offloading
      sched/core: Dynamically update scheduler domain housekeeping mask
      watchdog: Allow runtime toggle of lockup detector affinity
      workqueue: Support dynamic housekeeping mask updates
      mm/compaction: Support dynamic housekeeping mask updates for kcompactd
      tick/nohz: Transition to dynamic full dynticks state management
      sched/isolation: Implement SMT-aware isolation and safety guards
      sched/isolation: Bridge boot-time parameters with dynamic isolation
      sched/isolation: Implement sysfs interface for dynamic housekeeping
      Documentation: isolation: Document DHEI sysfs interfaces
      selftests: dhei: Add functional tests for dynamic housekeeping

 .../ABI/testing/sysfs-kernel-housekeeping          |  22 ++
 include/linux/sched/isolation.h                    |  40 +++-
 kernel/irq/manage.c                                |  49 +++++
 kernel/rcu/rcu.h                                   |   4 +
 kernel/rcu/tree.c                                  |  76 +++++++
 kernel/rcu/tree.h                                  |   2 +-
 kernel/rcu/tree_nocb.h                             |  27 ++-
 kernel/sched/core.c                                |  28 +++
 kernel/sched/isolation.c                           | 236 ++++++++++++++++++++-
 kernel/time/tick-sched.c                           | 130 +++++++++---
 kernel/watchdog.c                                  |  25 +++
 kernel/workqueue.c                                 |  42 ++++
 mm/compaction.c                                    |  27 +++
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/dhei/Makefile              |   4 +
 tools/testing/selftests/dhei/dhei_test.sh          | 160 ++++++++++++++
 16 files changed, 818 insertions(+), 55 deletions(-)
---
base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
change-id: 20260324-dhei-v12-final-891d1ba62bd3

Best regards,
-- 
Qiliang Yuan <realwujing@gmail.com>


