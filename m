Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A7E1CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9A28E0070; Mon, 13 Oct 2025 16:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A6B8E0036; Mon, 13 Oct 2025 16:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70C38E0070; Mon, 13 Oct 2025 16:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C60368E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:32:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91D77470F0
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:39 +0000 (UTC)
X-FDA: 83994239238.21.D5B2585
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0B8B6A000B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y74oHsMC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89JlczJW3/4lbLwv4f6Rnp56viIwvqW3/2ZWEWjCf30=;
	b=Wk7uxJ/7kgPqD/MCFbL9hgrAR2LXSFj4XvAt8rdlP6/psFf4j70Q1xYIAAP8skvAtRRInJ
	ujx76BKoGNKpA646ZLWofAfqkoh1fzmnI1NWqKi1OncR3MZ34CtdR+TMU/9QyJkQRIaXER
	fhQF7tojScxgY2wDMXKVL73GpduZTco=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387558; a=rsa-sha256;
	cv=none;
	b=VqKekzmpYTHAp+t7sIE4rYfv0Jdb4YIqX1DnEb/nknvFGGgtkxaFUWDMtR5cziPlogE8nY
	Xd7p1R78OOYawQH+zqoaGJCVcYO/W2N5I8WcsUZC8lX6luavDHGhCJRpfAyiCadOxEFk/C
	GXosu0KWVAEvksIpv10fmuf+dKV4LRY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y74oHsMC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 80389602DC;
	Mon, 13 Oct 2025 20:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCA9C4CEE7;
	Mon, 13 Oct 2025 20:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387557;
	bh=0DsWfneCzpjIl5WbzWDNydymwnwOLTzShyRdiw34zDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y74oHsMCUCu7xOUlp9LjQm6NP3nUM+9L06MxVNQbTC49iOQPzY3C7M9sVklCKROT5
	 fNk3jHeO+EYTF+wNfi97wYtL6cD7is4C47Xjld+LW5m2+8AmghpZuErpsufnn7JYtz
	 0Eh7+vvIb3tpv6FKaaajFXK5oCF8Nc4efzes0xyaxQQqt+QbXch9Tizl4KJb/5a6CX
	 XuLKEUq59kRyITBcpG5J+NZQUMhZz2W9EFcqsqLoZjYbkuSOwZGc19LtJk698QFUjP
	 gz22SoQuMWCIQYRcP1zFr1BfDhIiTIMDLOSDnEzXuTOPOvzt4GVDU+kFULF/8BtWYb
	 i9U3ltzfA02vw==
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
Subject: [PATCH 05/33] sched/isolation: Save boot defined domain flags
Date: Mon, 13 Oct 2025 22:31:18 +0200
Message-ID: <20251013203146.10162-6-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: wj1uooakp5cec5nbiin9fkjw77cixpuu
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B8B6A000B
X-HE-Tag: 1760387557-1100
X-HE-Meta: U2FsdGVkX1+HB0IrEXeKjhJ+jhsYXFc4F/iiJqEQYqVUGFQqmyQ/tPS0ecybLqcBmI9rNJ2y5gkfdmnXy/y0RFdrBd6E1aKhG8+ua8kvDKGdAvaGgrMbWy8Xb1ceYeQYV5TESUmyRhcwegzEpYnUkAZ0nT9G3+dqj5+ImOtOx59TkIXq+Bwp6R5iU5AibU22PdCnvvgdZ1tl/kpEQOLKOYfiToMvqzQsb6TUM7D3bQXbjfvetwfocDWucxtsg+PWBqLY8AyFpkESVLcxiO9EPLk3K2HqThNLYEsiSCkyrT189N9QZQvA7rerdVy9PbZTYknzvotAx83t8OJu2YB0d+fT5W1mEP1AF9Nx64c/eAbzzfANqwt9CeVQih6wCFwSiMigG4X7J6zbcEQ9akyU/1kRwbZE5nZf5DX6qqPlK2ronhVaXT3h0ouGGw4c+f6EUtW9O0SsUTKI8z2vTrhbCjN4vJLAYMC8TC+/cWveF44kKGldVR74MS6JdtM8llSMwB802CHS2+dsgd8/b3Pvjzy4E1kSI0rLqZiKWYt3oSn6cN4R1JnzZm91Y5sqMWMcpzm0I7UXtOJp+fcfsM2C2Fj3sPWyHccib/fqSAG2oRmcD/b07TjPmhKY/yPzptFogWy91ZY9RH5ccQCX+E/L7wTQGugxgH13CVVAxzRe+Rg3jHOfhGA3vxlS3rdTvHEDnJfxZySviqcLnPh6lsQblEzDNz9H+jY82T+ZphIuup4ZaHRZmKDj8MkMnexXJ53D2vaGZUYJeFyWMfmVn07Rk8zVUKlX6vTKk5LrynUvFgw3yq78pzQaHh9S+DxgpMHMfiPv2Q33dbpocTgan5WDTzzekfGrp36kNXRKau0/5OvJh9qEdRH+lYLdSnnqjdYVMqztVMu82cVTKWQSVdY8RgXEic1+tmNLooMIIpB0WkM4VpTSfQZVXHU7sx/iMR3kplbYt4bj6UCkaCnNTnA
 XrWasal6
 Ig16tMZG096N2SI3fXygfWBtK9mXqd4fhXTlTbyrfrlliieZLyHy/iVE530uOTqymEXRPgwvyTP3vUSQKPTaMGXzy3I6BgU2AsiRU+NMVA49sU8Y84dPssPQcFUKErYh74roeh+lkXohx7/wKRsXAzh+Qk0nKxfLSqWCm4c/KXWsA9vwxdJ5DkJJiWpbm5vXbpcV3DbkvE9mD/614nVHiUaXV6HG5dDT60mR8qJdX+jo1N4yn+dqKVG1XUCx2nhQs0F2uFV0POWUFXV9u4lGegAAUhu5ih1ZfK/s9
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
 include/linux/sched/isolation.h | 1 +
 kernel/sched/isolation.c        | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index d8501f4709b5..da22b038942a 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -7,6 +7,7 @@
 #include <linux/tick.h>
 
 enum hk_type {
+	HK_TYPE_DOMAIN_BOOT,
 	HK_TYPE_DOMAIN,
 	HK_TYPE_MANAGED_IRQ,
 	HK_TYPE_KERNEL_NOISE,
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index a4cf17b1fab0..8690fb705089 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -11,6 +11,7 @@
 #include "sched.h"
 
 enum hk_flags {
+	HK_FLAG_DOMAIN_BOOT	= BIT(HK_TYPE_DOMAIN_BOOT),
 	HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
 	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
 	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
@@ -216,7 +217,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
 
 		if (!strncmp(str, "domain,", 7)) {
 			str += 7;
-			flags |= HK_FLAG_DOMAIN;
+			flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
 			continue;
 		}
 
@@ -246,7 +247,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
 
 	/* Default behaviour for isolcpus without flags */
 	if (!flags)
-		flags |= HK_FLAG_DOMAIN;
+		flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
 
 	return housekeeping_setup(str, flags);
 }
-- 
2.51.0


