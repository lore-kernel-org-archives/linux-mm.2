Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E20A3CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D869A6B00B1; Mon, 28 Sep 2026 13:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0946B00B2; Mon, 28 Sep 2026 13:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAF6E6B00B3; Mon, 28 Sep 2026 13:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB076B00B1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:42:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2096F80294
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:42:06 +0000 (UTC)
X-FDA: 85263889452.19.AC6DA5E
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4573A14000D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:42:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="E1ZSOD/4";
	spf=pass (imf26.hostedemail.com: domain of 36qa6aggKCH8vprvwdidjrrjoh.frpolqx0-ppnydfn.ruj@flex--smostafa.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=36qa6aggKCH8vprvwdidjrrjoh.frpolqx0-ppnydfn.ruj@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5BgLva5vXrAwBl9Y3v1BBOsVeywVgMCKKqE5NVyRxk=;
	b=55pHnTAT5TbnhrXgNrA7zutNHBjt4xSuRdswpi6J2wPSDt1e1JpQj6DbRhQhtlQwOHmCZN
	rkbUyhU3bfvhiXMm2lbyAN1FhX5QVECIhNYP3yCQUyq5PddbibMxXRpTgNaDEvFtudqLQh
	05gHpTRfE5ALhZHfe3/esKuNM9dwNLw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617324;
	b=Oo+HefiGk4Zb755dsePbhH2dFRnjx/GxGE7Mk2M2x5sSS365f3Gt9eiL+g9z4ZUS1p/oLX
	NebCB6R+Obpb/rpl72Iq8hA8BY9nIx+j8BuRG71+TYFsIpuBc5OYYTIMEsk906cpdaKPBo
	NAWncjEBSEJ6F+AZG6s4zZN2sKbLqZU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="E1ZSOD/4";
	spf=pass (imf26.hostedemail.com: domain of 36qa6aggKCH8vprvwdidjrrjoh.frpolqx0-ppnydfn.ruj@flex--smostafa.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=36qa6aggKCH8vprvwdidjrrjoh.frpolqx0-ppnydfn.ruj@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4994d67d0e3so24283995e9.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617323; x=1791222123; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b5BgLva5vXrAwBl9Y3v1BBOsVeywVgMCKKqE5NVyRxk=;
        b=E1ZSOD/4MKnL7zFi1OCsYyBcr+dlYP7Ty8y57LbfzZWpYJDhLBWJ5+DbGUGvnbBR67
         Aooc9ip1EByJNbZa3A0cQSNKyWNev6BRRI5kgiByDLPWA1O5PV4zvtK47lbCP6DeM8lb
         qhG16uajpWkmso2w9wHtR2/HEP9Jq0Hge9bIIjdwLlKZe+rPy/+z4HeJiA8Js/pV91gH
         f/r+R1MOkKoyd9PRf9UsxJV/5aciFIOM7akTdcAwFJtUOEiZlsCg1IRoubq7TiHLguen
         sgiDTIW2rwHZvkxMrpaNTzPwQvZBc3neg4XqsMzyqRvH/30ha9R32BZcAB16aV6R8j+Q
         pjjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617323; x=1791222123;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b5BgLva5vXrAwBl9Y3v1BBOsVeywVgMCKKqE5NVyRxk=;
        b=W8li2ykSaTRwUqRsRz6+25ZfgaXg58MfOHyTywtnrVMJ4zxkiuw77E88L41l4/p757
         9DN54X/rl+MWo5G0CbtDGnC6d1cH3puP8jO6VCF67XQEvvjqC5eBk8GTzdyqLhU+BSF2
         3zsJJRXTfTxytj7LMtOVlP6zr/3u6mIF6ztKyUYyUjBFwo3aOvPIR7+A9ixWzViloNtJ
         DuHUDq7jHzYgnLa+R8SiAJOhZFidDiXIAADhc3WT4UPjK7BTF7+W6Kh4dY9fNxjfvWxn
         Pgukn7eaBJ9ZQg51K9guTQKwp4KeZTo6Mx8/cL4FOwhbV4VsU/W7+FsgYzygsXu+Yj0b
         OI6A==
X-Forwarded-Encrypted: i=1; AKwUvBztmNuyfH8JMAaFBqI3XGpEYxDBVFBRqEfVQVlvu9LzZ0Ijyk8A9TvV9uIlq/WiOnbUGmmPLE0ZZA==@kvack.org
X-Gm-Message-State: AFuF++neSz7FP36+1c1t7G1gXZ//s+uGSdnQVLuwRI6vq45E7uHOxel+
	snpuo0sgiTOL6eErgQY3K+Z6No2RinySUlGQXfafL5K3Ex944iagR0ZpaJ5d1sznA758sbenF/d
	NB2gU5GyLYtwYVw==
X-Received: from wmhj21.prod.google.com ([2002:a05:600c:3015:b0:49e:8337:33d])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:83c4:b0:49f:c331:39e4 with SMTP id 5b1f17b1804b1-49fe66ca101mr236733115e9.7.1790617322864;
 Mon, 28 Sep 2026 10:42:02 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:19 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-13-smostafa@google.com>
Subject: [RFC PATCH 12/15] sched/task_stack: Introduce ARCH_HAS_VARIABLE_STACK_SIZE
From: Mostafa Saleh <smostafa@google.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	akpm@linux-foundation.org, urezki@gmail.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, kees@kernel.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gustavoars@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: aoog1sbtzrbw7g16bgsrjgb756wjad67
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4573A14000D
X-HE-Tag: 1790617324-757126
X-HE-Meta: U2FsdGVkX1+j/Lz/Ty1YQrOmx54knEN9AYgIPYEE6e4b9P8pRbUh0NnwVyknI8NqFuU2uqCDbUn5xcKC24BFfXad1GjlxOJjaRoxn9IOcN73V0QfM/gVFbFTt/EB890WkwO5OAyWTSoX7i5HaSPWfO1iCO2+su7WkGHoEXStOQOTTU5QYwRXeXp4P2PAi/pHKfGms2BVx5G6PVimgLDtGdU2sghNmSbOlVA0iD1m+dRQVm4s1N7EE9bP5j4cd3GTAjiTLBcY5m1isDUJKHg01akECJKwLA5G+NXIBBea38T/MKAN+7YhNBDQ8BQNZiVc5JTzGg0L7ZOr2+HGeJ1i791F35KWjVXsgViYQlkKJo8NZZ8xdbGj0Kuqq1kuum79EC0TxCRt2h4lshjLUuUVcLvScS4M2mkmnqj4qS8pN51CxoW40z6AYMAoEO2qHeEBZSEamKn4GCdpQf+1zsQ+X8CyD8b0X5C0etvPjEtEieQoEbHAjFfwFLOpSrIhETbtsXyTFuc8S9WCAH5/ENhQK0LSk3ZyD2wUoAFop+Vb2J0mb8DjzRaKeEEP6qx1/TV3NSvROljdSPfFqAvblSHwr2hX4OOJioICFcVOwqdu/WArty6o9zy/Et1Oa0zPX6zkbTway2YkRLmZlU9INGL1G27soQsExWhJcpQIEUVYLdXyIjqNrxbCkxBie/dD88GN348DKMA8+z4vNp3b8QQv8JYVdFvZ1q6ubAjDpaGQT7FWXUWJQCo9uS7BiGviXUjHypso1FbkCUp2T32Gmi2lGbbsPfDM6i9x1hnmjkecyd6L6vLP0tqrSr5d1P1P3Nfj2BMxgyM3kdENUwsyTcezcPXvpjJ/OXS/Z25tJ74l2Jz8ICYn/N24e9pIRbP83eW0HDZrXN7YoVoMQ0WHkOz5zJlwuuylXEEZb8WJC+oP6vCaXQTL7+b6FQSOlqa95Z7vdec3VT+DXfxZ/d5GiNs
 nfxEq2QQ
 0LW0GwnU+2byOV/Ge7YtxHG5s0mN9u0K4n+RLO5ZAdsHM62ZhLg7+l8G62+949r5fSPAPqKflKrhv3sPNXfae/cLqVExRqGXbZo+Cga199EUoUe/zIannWFTAtXWN0CP4niPodcjb7E/yZTwbdQl1LzSwkTihQsMgBn3OfFM9x3gpTPueHal5swNgoq/0lgZlpbpXKD6UeNL3ffbWR/sbesEY520UK9aKS9kt/zJ9szbzep0B7gVc2NfSwc3/rUGQ+ShLz/zO2M3kmaFchl7uPGmCxcTtMkPM5MbELCvay4LMChG7rLql4rOXGQ7ujO4LgP77EpgddzN89HAFLCFBHDEA6hxwNT9cHZ4g8leSUOJpxCDt7QXLhs/l1I+m9hqaO25Og9qTYoCGVDooS7RHNzqMDehK5TiBy+nZcTQOvc70IATs2QoF7ICkCpMgyOzHOQa8CICtdW6BnX3C1v1DLeRvDZLO8oKL+1pPb7whfQDBdpNQ/oUr/VImLR1KOnw9v4JVaKg4Z2OJ+Xl0vin5Yc/95QJV/SOzgEaAEg2j808hHad2SZb4ahLiTPlxuqUgzsQQMhJ0VdTn5gWWtl0IUusgJp6BpIybS7PegJ7z6FMiij/0jDMK2zKVqxJIBYThEhxucSlnzOkRHF41XnvmRBNRscFFsSFjEYUy0eUXaTmNEIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_ARCH_HAS_VARIABLE_STACK_SIZE is enabled, the kernel stack
may not be fully populated with the THREAD_SIZE virtual area.

Teach task_stack_size() to return the size of the vm area and not a
fixed size.

This propagates to end_of_stack() which makes functions like
stack_not_used() and set_task_stack_end_magic() to use the lowest
valid stack address instead of THREAD_SIZE which would cause data
aborts.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/Kconfig                     | 10 ++++++++++
 include/linux/sched/task_stack.h |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 45c657772362..d6fa2ccb0599 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -431,6 +431,16 @@ config HAVE_ASM_MODVERSIONS
 	  <asm/asm-prototypes.h> to support the module versioning for symbols
 	  exported from assembly code.
 
+config ARCH_HAS_VARIABLE_STACK_SIZE
+	bool
+	depends on VMAP_STACK
+	depends on !STACK_GROWSUP
+	depends on THREAD_INFO_IN_TASK
+	help
+	  An arch should select this if it supports dynamically configuring the
+	  kernel stack size.
+	  For example the kernel stack size can be from the command line.
+
 config HAVE_REGS_AND_STACK_ACCESS_API
 	bool
 	help
diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
index 4a808f9c4631..07d73adaecd1 100644
--- a/include/linux/sched/task_stack.h
+++ b/include/linux/sched/task_stack.h
@@ -10,6 +10,7 @@
 #include <linux/magic.h>
 #include <linux/refcount.h>
 #include <linux/kasan.h>
+#include <linux/vmalloc.h>
 
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 
@@ -96,6 +97,10 @@ static inline unsigned long *end_of_stack(const struct task_struct *p)
  */
 static __always_inline unsigned long task_stack_size(const struct task_struct *task)
 {
+#ifdef CONFIG_ARCH_HAS_VARIABLE_STACK_SIZE
+	if (task->stack_vm_area)
+		return task->stack_vm_area->nr_pages * PAGE_SIZE;
+#endif
 	return THREAD_SIZE;
 }
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


