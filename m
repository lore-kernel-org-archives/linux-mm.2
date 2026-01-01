Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EEC7EEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859FF6B0096; Thu,  1 Jan 2026 17:14:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82FA76B0098; Thu,  1 Jan 2026 17:14:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7460E6B0099; Thu,  1 Jan 2026 17:14:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62CC46B0096
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:14:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 329F3141580
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:14:56 +0000 (UTC)
X-FDA: 84284800992.06.0706258
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A08E240002
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:14:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hThhxW/r";
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305694; a=rsa-sha256;
	cv=none;
	b=5QgbM+7mVt5spudr+3fOHUzZP88lBeD1gK85NrRQnuxq0867fGY5PwT5pUqqA2+E/0uywc
	QHN4AQkKA7xJkAYWnUtO0utbcIgfhKqb9vwHA/tGEi7WS1v6bHy4S7E0ahw+DJoX1c19Sd
	hb8FX+pdIAm7+1WGNOnjHXNIhGyQhOk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hThhxW/r";
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwgunH+qRhPAbly3f5Lw5XmpPn3TtQxhOF2mp/vDJ3I=;
	b=G54Rc8P9GVUmjj4WXpwOWiJg0X6gzh+R+urZBnqSs6Cskc4DTGtUNqz1XVLHaa5KqMY0Im
	zwdGUV7A/MDQO50+Wbbdh+oK3UId1a27oBIKlqmGBoBTmjOmocM/xttWPakcuARWCqfyeK
	G4By7GUV7p8C77MQWvH8aUjqOumzIP8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DF1060017;
	Thu,  1 Jan 2026 22:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE100C116D0;
	Thu,  1 Jan 2026 22:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305693;
	bh=HhWObUaCwi4bgCO3C817jvURXsArjqmd8mmB3XQmmVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hThhxW/r13awo16phbPQQ5e18yCVLIuhRzdsJIdU5vBKwFF6zis9e1PhqvNKeiaxE
	 yNXDpt710ACQOYxh2GmJjvjzcHWU5Gd1xag5ereyYbgGEFnlSpeP8vAXu680/2diLX
	 jo6v8CAvwNQTOAN0oaMH7e8idLVQhK/qSovtp8T/kaGnIkp4hP1m0QX0GPK2fjYvt8
	 7Za/OOJXaPJAarRlJy/HwZHD+iehQY2If61pGgbQr1X2ZCi82h3YyWRj3IzO0pDQz0
	 0+lv7FiSQ8XZfglJirakzrVfN6V0hzAM3xpAbnWoi0mG9peAtd27xWuskx9SkgyJNC
	 SpF1uI0hnPzkA==
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
Subject: [PATCH 05/33] sched/isolation: Save boot defined domain flags
Date: Thu,  1 Jan 2026 23:13:30 +0100
Message-ID: <20260101221359.22298-6-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A08E240002
X-Rspamd-Server: rspam04
X-Stat-Signature: 4z4c6kzx7bp9qj74r8j3e4grj8wiouoe
X-HE-Tag: 1767305694-59275
X-HE-Meta: U2FsdGVkX1/WaBHgKO75t9Z9iM+76IvuEkb3qLdnaLneCGQBy8AdeG88NUp+CFpLGMKdLTeQ/K7CYPOd7Hb5zcqikTLyuz23ML8SX9QZZCTgjkgxZ8Yvmcs/U52bVd6IYbTCxDyEYny9KK9tQb6uEqvFUcJoMCrPYAeo3YSzdPExxownmGILDmsQsiuHHQ/WYXs+VErOx243f3Hcs2VqOA+0q6I5sAPN0fLIaKVbMmX74CiWyZGVPDdY44TdehqnMHmcCxA/XAldssx8onYrD0T/BAAP7Hv1YvYlqZDOR4pxsGtu2/UYzD75IQ0IxshXzHpFe+MarIpWmsRAd9xiqQyP3MIokV/JmToa00L5+99bKGjCX+qhEAwafLc/PVznm2hvmQfY+gTfQk9UHu4r3cGHvv0PPwTEKk1g3LHhaiMOHkdW1ITgnPaPJb8rs9XXIm6d7sQzi2xAi1CGxxBBM+cScPlb6wDmaSUGFsZWghnRq3isCpct7XoXsD+gA1zuq4KGpLgJw/2vN92gf4JeF5sL+r9gDovGIwkic1mcJhbl+6heFeqe8njofsMc3WJFzvrsOd2R++cPveRQEXJDLdyKWU+8TdPCupjmkJppFH0BMpudMY5OhVzuF1IL7updlyU49rPF76anG7qizNI1YF5pOED8tuMtSJZe8lj7e9TYVExdRJRFV+a/0imzKRj4LOBmWsPAlKotj4wyY9uGC1ni47NJeg69ckZWIe6b7xoCqxj1qebhWA4Ob+GZt5XQVGBkuahODNQwK/E5BBL2OFuREjivmlkSRi+e3jIEap3CCgkCI9id/FFbeSjjPJFcrFIcisAyugE9Ek4MeEAFwhgb5aByK3k0UWp2y0u+x9wtaJlTuhqgxx0z3DGQiPvSDukmm8YC5ZSw8m1bMKDqtjZ4jpbfqz8HrnADbM6fgvOeoSlj70M+Zae4S3h01svNcvOJR7NmEiEgCE0hxzf
 Vhe+EQ4m
 6aj4oYTbf2CKf0aFS6WOX3POad9ItJMPQrJPJHvixgGOiy825Qs4nYbjGoQqFSHppSW5QkkcgHhWBEsFYQdUBk5V8QBuBiShhrZDAI4UXCOFn8djHEvUTuFDxW+Jrk/4wCymknWaki496AZntqfrZeaJvBXvLPKhaopUTfcE+MZ9FnqO5aOUCquY/y2jU/gVcjlSUrrvgIjmxxZFntN8kHWPeRrXLNiLVOGQZelDGbNp2Pw51MxCTvX445JbRZMrT7yaVodDBnspLb3lh5vXZxxH06+BQCIigIFaJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HK_TYPE_DOMAIN will soon integrate not only boot defined isolcpus= CPUs
but also cpuset isolated partitions.

Housekeeping still needs a way to record what was initially passed
to isolcpus= in order to keep these CPUs isolated after a cpuset
isolated partition is modified or destroyed while containing some of
them.

Create a new HK_TYPE_DOMAIN_BOOT to keep track of those.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
---
 include/linux/sched/isolation.h | 4 ++++
 kernel/sched/isolation.c        | 5 +++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index d8501f4709b5..c7cf6934489c 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -7,8 +7,12 @@
 #include <linux/tick.h>
 
 enum hk_type {
+	/* Inverse of boot-time isolcpus= argument */
+	HK_TYPE_DOMAIN_BOOT,
 	HK_TYPE_DOMAIN,
+	/* Inverse of boot-time isolcpus=managed_irq argument */
 	HK_TYPE_MANAGED_IRQ,
+	/* Inverse of boot-time nohz_full= or isolcpus=nohz arguments */
 	HK_TYPE_KERNEL_NOISE,
 	HK_TYPE_MAX,
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 3ad0d6df6a0a..11a623fa6320 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -11,6 +11,7 @@
 #include "sched.h"
 
 enum hk_flags {
+	HK_FLAG_DOMAIN_BOOT	= BIT(HK_TYPE_DOMAIN_BOOT),
 	HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
 	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
 	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
@@ -239,7 +240,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
 
 		if (!strncmp(str, "domain,", 7)) {
 			str += 7;
-			flags |= HK_FLAG_DOMAIN;
+			flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
 			continue;
 		}
 
@@ -269,7 +270,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
 
 	/* Default behaviour for isolcpus without flags */
 	if (!flags)
-		flags |= HK_FLAG_DOMAIN;
+		flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
 
 	return housekeeping_setup(str, flags);
 }
-- 
2.51.1


