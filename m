Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CBF6EEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C15C26B00BB; Thu,  1 Jan 2026 17:17:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF34F6B00BD; Thu,  1 Jan 2026 17:17:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23276B00BE; Thu,  1 Jan 2026 17:17:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A10376B00BB
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:17:16 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4508513CCD0
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:16 +0000 (UTC)
X-FDA: 84284806872.03.27AB1BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C8A004000A
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jc7gn7TR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305834; a=rsa-sha256;
	cv=none;
	b=d1izmyQSJqRQgHP3VMXEWXAuNUYRwmqeyJ0N57J3qt5ONxUcTfbi6K+1GDYF9KRhl/Itt4
	TGnCsp8WlogsnetHmgHIeQxJfAheCGBxwdPLRsOsyw+Vp/rg8IaL86Jodk2itsQ6QpBpEi
	r6wCtAwDoenpBs8Zf7QiMTrDze58GD0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jc7gn7TR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KoMmvfhYRIZFGYOO0Tq4CkHWPN7Pe/K/9zLHg9e1FQ8=;
	b=Bmfx4MKpSxd2nLKP2C+pkj8poE+zvZKIavPEuRUjxAluSKitu50QmaLJUoAUjhBfLq3PI1
	jv3F4aHEaDLL6NEErPqgbb+7V3QD2rrT6PE1BaPh7U7xaj4DuJ0OpgJpc5f+TNTbbx4SsL
	qluPrjAEEr91jTkCcYh+02jxTcSRzwc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A47D60055;
	Thu,  1 Jan 2026 22:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2F2C116D0;
	Thu,  1 Jan 2026 22:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305834;
	bh=STgH3vdgePx/NwxeTPu0LVfQh6HZMobxiXNItthO3G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jc7gn7TR1w3hwydX3z0B7EcH9rCjv5djOTIhB0+TMcYJdJELjE0CyYpzKA654hMLq
	 hfAROIBc8+V2iNgqs2DbNnrn+tlCRM8nif8NqFp4zKLJWaTGPWsaF+aSyArU8GuV/a
	 oY9NxNLaiyBHWD/IcotLAwtCGDD7HJyMQy1vxXi6MblCVT9rRMhY357N6WUdgqZM40
	 2eqKe7IgayKiFXlcUJ3THlim3HDHOfKGkYUJFSIBeVHBRTZRZoP551DOU71dUpVa+E
	 r3tV1aztmgSCFiWXB6B8iYBW+Bg6uXBPW2DXRuZRRfDY22u2frlTY3qc9SQEikfzmH
	 11SsFwxSg4qag==
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
Subject: [PATCH 22/33] sched/isolation: Remove HK_TYPE_TICK test from cpu_is_isolated()
Date: Thu,  1 Jan 2026 23:13:47 +0100
Message-ID: <20260101221359.22298-23-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C8A004000A
X-Rspamd-Server: rspam03
X-Stat-Signature: ypfxoyqjtx7g183spw197jfmugdpht74
X-Rspam-User: 
X-HE-Tag: 1767305834-140877
X-HE-Meta: U2FsdGVkX1+PlRITXrjvGwAqsGjuCxpZVp2R7gQJN3uShQrosbbmKTZzY8Q+4u2UzRoIb7MhilZDT6AtXpS6qHC20sXNNW5Wa8MSD9xT1BP0+AaKgosBh7mi+kwZYRss/UmeALsk6dmDK32FjF6PATkSTvwnMNDZJw7GiPlhIjTieltFVy8G1Q3A3mmaaEtBnnqmcfYaOmGQai6H+Q21NQWYxCO6THcwybKuVxQuW725TabeG8jr/TVfOc5yZEhjNokBCN9j/MhtUBkppDmQwC6nJ1Sqk577O+ywhQiR3Glq/y+TS8gx0uUhg3mmIWy5TeCsk+YWT4aEJM9Q99SPBPfimCjGa272zrnPtL4R7EfSFM7U+pAvo+x37W6zy63u/b8t/oB45BxfU9dzsrwdBGvHY2VSomtavidUCvDCdWZpW1O1z2yPMo0IjSp+fVeGA6hMHSJ+pdbZZC+sTpg8qeeAha1oZwsXrKOFhUWwngH71zgCF2rZnDpXOb0gzwqY4iUVSIS8kYoTwvjmaDSxH/ekrQhoEBIkRsW40RzpRG7pn3wL5ewg3dPP59Arcz26zgDHzUpX1QYrEd92+ZPi0JBe9J8DyX0iK0DTXE/gRtMuJw+eqZwQS4rJj4wtL53DXb/l8Cj+DcspPfajHjUIfxt/h+xvgNuCLVsVbj+H2dlVcTKKdCQtYtjuyz4+E0G7Zncp9hZo70AKPKbh0bgtUmAc9jjI1dtnxYcHQtiFUxUFS0WbxegB5I+POzcE32+q3rcjFpClWRFXrEEaK+AykqQOXCIbhWj25VmhkOpODQ4erdLYpXdjI/HzodjLDRaHbeTWBIisx15WVd2MRRjfhULqHjK7+dXXm2EkfyaSGFpDSxXX2Xw/k8VQJYCPN85F3xhViWQfXGIInhIXuYUh3UtI7pSLpU4vocYDD82QQdMgjjhvw7RaXOtNSkgoJh3XYdXCmPtK8WRtz8qwZ0x
 hH/LeVhl
 f0RYSKxmP+CWN3SEf+hIX25HTo0VwpZf4jJKvkQvxjxqrj6bHyQa05oXqXz4f/nYpSxv1nicj6nD8YV2HF05K5iJZioHHO6Ns2COCod0x8lc1Gxsu/Yp7yxjaWF33AbcPZfqa+H2FNlOJpPTOr1yhvdd6VeJkwTsm+pIMfMsS7snNy6qi/0/41We/2OkZWjCXV+/QjPhLMFLqEvik4/4ESXXxQgAgNXW7rq0nURcmgPspt2wIJjBk+flFwzLmCSWzE4ZmB/A8v0liWbZGUMUxC+LIFX3zrNn9xEuZxS7bp2sGSDOJzKyHgiNYbpdvkNGJQT1H7WXrWB+trR5y+do4XUH49w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It doesn't make sense to use nohz_full without also isolating the
related CPUs from the domain topology, either through the use of
isolcpus= or cpuset isolated partitions.

And now HK_TYPE_DOMAIN includes all kinds of domain isolated CPUs.

This means that HK_TYPE_KERNEL_NOISE (of which HK_TYPE_TICK is only an
alias) should always be a subset of HK_TYPE_DOMAIN.

Therefore if a CPU is not HK_TYPE_DOMAIN, it shouldn't be
HK_TYPE_KERNEL_NOISE either. Testing the former is then enough.

Simplify cpu_is_isolated() accordingly.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
---
 include/linux/sched/isolation.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index d0fb0f647318..dc3975ff1b2e 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -82,8 +82,7 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
 
 static inline bool cpu_is_isolated(int cpu)
 {
-	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
-	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK);
+	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN);
 }
 
 #endif /* _LINUX_SCHED_ISOLATION_H */
-- 
2.51.1


