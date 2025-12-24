Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF8CDE75458
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3025C6B009D; Wed, 24 Dec 2025 08:46:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF3A6B009E; Wed, 24 Dec 2025 08:46:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC4E6B009F; Wed, 24 Dec 2025 08:46:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 119BD6B009D
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:46:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A239AB69EC
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:46:43 +0000 (UTC)
X-FDA: 84254489886.30.DE07E81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 045FB1C000E
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:46:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YEoDZ31G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584002; a=rsa-sha256;
	cv=none;
	b=jZ95RoREq5gtYvy7UjqCi0EejfZ/HY1Po07mPkyh9c7YgCtZUUEPcxmc+vEVqiBHOxijxx
	YzoXLE4XHv+VmAS/WNZ+HajajA25/6VFf9airGNgGh/qH/d2QmMVUyFGVFGAl6b8qUrL+f
	PX7CsHLABxwIkxCW2Zg1s17Ejwiq/7o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YEoDZ31G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNHhksth0DMgZoLPWd0R5GoOcr9klYZtYuCtgdTRwi0=;
	b=UGVCpBCwa0nPXsQd2oGym7xu5QSaZaGM6BVE91/a7oDkW/Eribh4QLwrwyAC9pD9PZO1JX
	Hmxt1e1qpGaXf4jW9P5y/U3ycU+fWEjdfJTf2r/PPVjg39ztv/vXQPRwREvy0Bvslibwvv
	vwpJJZvD8OrcgqEWR/v8wevyX7513c8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DDFDC42E4F;
	Wed, 24 Dec 2025 13:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABD9C19422;
	Wed, 24 Dec 2025 13:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584000;
	bh=gHL1k3Ce/0Yqnu3RKEhMFCTtXjaAjQ9JVob0E5Uoa3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEoDZ31GmGpSVaixCaVHDjz7hz5ylaJwYHRMTm+fbM5Jar6Gye1IQ1mBYPf96xzGj
	 fGFhfdBE16gb9LLiHQ77jd2mxvDZdm3h3VCaACHPwVQjkTMQsrAeAkG4dqPnfwvC/0
	 TU1utC3K3+brNwXcaj102NZUz6hGO36B7Mh97w+Ge+ob9xdqZIwn9/YLSeiLagqQ/B
	 plH9LJrMLTEg2BRmiKnfmL0Q1YPNhDBKKOzibA1SIzgql4aWDBZRZfLJrxbL7UAg3Q
	 BYU2hqBNRR2SiJvmVFiJtWBunuhVOHTEkRaNhzJQ0z7SyXNFVu2R4zREpCJvIUdGUH
	 OvyDw/WtTjnXg==
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
Subject: [PATCH 08/33] net: Keep ignoring isolated cpuset change
Date: Wed, 24 Dec 2025 14:44:55 +0100
Message-ID: <20251224134520.33231-9-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 045FB1C000E
X-Rspamd-Server: rspam10
X-Stat-Signature: yd8jxpqzdpui1m68nuanhpbt8g9eqg5s
X-HE-Tag: 1766584001-375405
X-HE-Meta: U2FsdGVkX1/LViP/IAwvPpJKNW6q9khRZSFRqihemFyZHW6+E3IQS6TkdETOBQjiSi4cf5DIjGBfvYifg7uhdlKfC64YqeyDtyiRzkTesUlWzDXiPajfZBzjFT6k4B0xGIFRUKZEWBs9uJ7Qdj23UTptqRcnboDw+mECEDM2to0UKNwFYAb8SJlxj1dSu9i0pw5cgpDv1VBvOXKf0ph2X4Bn3vlnPdPZWBWhXBcZtBlSnDm0fkelzZ0RB7kZumm4KBzBcuNIZFEB6BIB5NFQVEY6HDYM4vFpNl+kxgxFCqIZ52LLQYziE7S3lDL4Qjy4W3Mj/H6pA7ctSIsPmcrNOu/UcX3gpqWNRyBhdtFXhvHUywKU05Tq3w4L952GsOegk+SdF9zuT7/WlEpFB/GaFBcrPFD7eKgw6a4hQ9GPWh/5SMzA8l2dgJK9ESxFLZF0kyy18jQt8WsDYzsTvMKvf5Jp1FP5JBccvX+gvVfs67fSm+EqFUcfpmzVl59rgQ+VY98NABGS57pjtsSUy2HrrnJtlN0+Vy2ArB3ZZ+HhTNqiDxAxampFMjscOQkK+rTKGRkNBSh6CVMj0VHwCQzYI1BTqRi2ZZnfGqNbdHZbV/Kq0rBMkXQVzclQrufP+ClOfPvJ9btKS9IufuqrJBY4e7j/5ioeXBLc/4G4dpfJnlEpPV7f8kcRemeiVIqx8hxKUVHzD8W6tGUjXFpqvToFQYyQrt048MTOsxZXbtgLUakcUByctQw0OSRXn9AYc0HPhN1durdBoXqsBdBu9jAswQ0FKGeCxyW3UKdozlvigWBgRoOJ3rh3d7S4rF64Rsz6jq8ZwfEicv7A5rqDEVw3oF5IPq1Vyj5loLlQogMzjz4jLsXUSvgDiFXVpYgNO6NEUrg5RvTKbD8rRPWOO0+SNUwS/6f0+rP8UEtY/DaRAqAftuUQ5fqJTXwcNe2t8vzmdF/uQb0X2eCAJ4jznF9
 jlQEojXy
 lokIuJg219LaUrjnzGOLn/Z0pTbQsxHlStUxTiwuTFH9tjBR/MDbEMWzIp19aDV+hIESNZfd3ZFTI8aZv/j5OFEzwZmfuJWPfBgutYZRMgym6A35zQi4DRcRstXKFDkv71beB/iE0sIZf1TIfEeWSx/unyTrFBRVmxfloInNY8UAQycQ1gU6fwq9yT7IuYuBqx1aXiNjLVIVM8xR+ziOpxWODSGFOSR1n3ho0+37iHODPyOs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RPS cpumask can be overriden through sysfs/syctl. The boot defined
isolated CPUs are then excluded from that cpumask.

However HK_TYPE_DOMAIN will soon integrate cpuset isolated
CPUs updates and the RPS infrastructure needs more thoughts to be able
to propagate such changes and synchronize against them.

Keep handling only what was passed through "isolcpus=" for now.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 net/core/net-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index ca878525ad7c..07624b682b08 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1022,7 +1022,7 @@ static int netdev_rx_queue_set_rps_mask(struct netdev_rx_queue *queue,
 int rps_cpumask_housekeeping(struct cpumask *mask)
 {
 	if (!cpumask_empty(mask)) {
-		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_DOMAIN));
+		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
 		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_WQ));
 		if (cpumask_empty(mask))
 			return -EINVAL;
-- 
2.51.1


