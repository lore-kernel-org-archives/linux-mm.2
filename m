Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7897E63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E2746B0098; Sun, 25 Jan 2026 17:46:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299AD6B0099; Sun, 25 Jan 2026 17:46:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185506B009B; Sun, 25 Jan 2026 17:46:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA1E6B0098
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:46:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE8C6BA25B
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:50 +0000 (UTC)
X-FDA: 84371972580.18.7330294
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5DF4D120004
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UyHyvsIu;
	spf=pass (imf29.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ughUk2eWnPugNXWzTJLzKsveJLgzP8u6JsIwIQnZTNM=;
	b=wOvjSnDecQ+Vy6j/D805hvfyDmeDLq30dOepZLaLAL34K0QiPSaiQ54KP0qjD0d0ZFDzxu
	a/iArd58fLb6hc6k58OCeM4HfAPyfybG4VO+pwaRY3iJTi5gLfG7YYl2N84GCeAX9723ox
	W2Yo1N1633cGFx58HzymInDgEZyLkX4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UyHyvsIu;
	spf=pass (imf29.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381209; a=rsa-sha256;
	cv=none;
	b=TEsrxHYH6+fgWh1EK/pouWKRCZle4xP2KBW6fsu9n7ffsV8UCXxY0R8CBJ6eQhq6o0Uu5y
	wIJGMwiZzVXDdqf+NDd9++L8rfBqN8xrQ1XjqFLYhcjPJxpvHXAqbJpxzwJ/ZnVVTGRodW
	pNe5dFGz3LSir50q2O16EaH/v+97UVE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD498600CB;
	Sun, 25 Jan 2026 22:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B7AC4CEF1;
	Sun, 25 Jan 2026 22:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381208;
	bh=N56RJwx7Vb0djbwM5UfAAN+LOP0Kn2KqSnmCrDj/jJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UyHyvsIu3okQ7Dlrf1ZCbraTIEmvPj3HTE7McqBEPQFbSMXqbR7JC1o8FMfOZ5Nus
	 Q0VStLXxJa8HFC8tU9CxjBr+GJAO0LSOS68Rky95s/N/EpY3B5xpjhtYJYUnX4DqlF
	 ugG/ANCw3sRSMZvTBSK2hobdEYUt4T9D/rHhR+ohNj687AyBkaVf1S/Ds/MAyJa6ue
	 ntDh/UYinNi61GJeloa/JJXblaHR6n9fE0MGE8ZRm26svM4ZXhwoEZYsHjx6klL++o
	 gid4fhZqJNRtQyW/mAw1DvMlbvBzIy1VeVFBCDXa+U33RbENMF2WCVNMGDNzansp9s
	 u9p6/bEs4ZVWg==
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
Subject: [PATCH 07/33] driver core: cpu: Convert /sys/devices/system/cpu/isolated to use HK_TYPE_DOMAIN_BOOT
Date: Sun, 25 Jan 2026 23:45:14 +0100
Message-ID: <20260125224541.50226-8-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: s1img8xugh3x7wgpzqtachpifoseg3gp
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DF4D120004
X-HE-Tag: 1769381209-751622
X-HE-Meta: U2FsdGVkX1+Mm7ReEVNQkm3RVCGyUJUanXP+u/JEm059l93WxdGjozHJHmfkJkz4umyTaDqIrMUEwLot7YzSIi4mSzBdSKmPzdvP+shjcAzLZ5C5/zXWpolj8VVQduMPvZAzsvnKC/Jmm3EMOtVX/27Bk2asQS3YBNsAXXRHSCk/LwyKZCcSbH2qtNIQA0DZRySEG81o94mSFIYXLaKBW0fEiraUEv7Mo6I//Q0iqQR0blZYt5mw9CAihsUURB7KZ9dJBGYkv1lEMvfFcf5KX2zkPlRjOjjdXNoCAWJSNbOuz3syCTF2qYTYJSyWUw1ORNjyHn4XIutqV5so2e3c/C8loHCGUTf0IpYczyA/6Nx9mOyyt6lUrFtV71UGElUecnruUTfumYccyFzbsATMaNOlH113LB6i2oJjKvHHgUwnGg9HA2jNznazS91+656MPuAxncSrECT1248PIML/NMsonjw3oNq/s0x2uwry6VG/dBNlmiJ4Mk92hR8+Bv4vcA2ty3duDKZ4UWQ7NFKEdrKZtkSKLqPOaRYhq92ZuvLtQdQ7LYoV4LcQmHjindrz1Orxyn8gi/fST2LD8Z0+QXXERlBl2zivO+ZyssvfIeJHerv7R/UlhZmVuqIiYnBlWv5W5koxwqJ4iKfJ3yQ9CQPtd9MYCJUnXIYAfKmq8qVEI6+W1n2N0b+Y+Fz2uCPKvHfJtwCM7viCylAILtLIn8CEkDfBMTpYEN/A6AjDqwNK2/v0RsMh587WEjfUgWoxrWtuC1XifSArjZnjM4yx2MfBzAO72iJeUmca445PkCYqA4GvsXEfEJvGRqdjntxaeABiKdA87AFRlidkFvdqlc2dzpI8Z3WqqYccF2GMRxjXWJMCkNWU4OeUDMXZCFhSh1t18jPqxTzXL7z2Gc5RtMHp6RNZvyWVK2F5R9ZfFrObU4jChGyd/9149KXoNpPootu1FV2nLK697kb2xTF
 Vtlt9iL+
 oP5/5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make sure /sys/devices/system/cpu/isolated only prints what was passed
through the isolcpus= parameter before HK_TYPE_DOMAIN will also
integrate cpuset isolated partitions.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 drivers/base/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index c6c57b6f61c6..3e3fa031e605 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -291,7 +291,7 @@ static ssize_t print_cpus_isolated(struct device *dev,
 		return -ENOMEM;
 
 	cpumask_andnot(isolated, cpu_possible_mask,
-		       housekeeping_cpumask(HK_TYPE_DOMAIN));
+		       housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
 	len = sysfs_emit(buf, "%*pbl\n", cpumask_pr_args(isolated));
 
 	free_cpumask_var(isolated);
-- 
2.51.1


