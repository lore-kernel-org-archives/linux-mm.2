Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A827EEB57B
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84F416B009B; Thu,  1 Jan 2026 17:15:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8067A6B009D; Thu,  1 Jan 2026 17:15:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733A16B009E; Thu,  1 Jan 2026 17:15:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 664186B009B
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:15:22 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1B0AC105C
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:15:21 +0000 (UTC)
X-FDA: 84284802042.19.6A92202
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6056D4000E
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:15:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rGzeR2j4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305720; a=rsa-sha256;
	cv=none;
	b=a/TUwtSA/TeY+e+E0OUbW+qoCODx9Wlb5R/kllRq9vaBJfJmQUCTRvRdE0kq74KNBI746H
	sP/Cr1csBghvGyQ1H9ZLOIphXMf/YftAe15g/4rl/vLJbssJqdYHpfDTJq9cImLH6SVJ8d
	jtgiQi+arkkJ0fGzkYn7UQ2gXS8M51s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rGzeR2j4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNHhksth0DMgZoLPWd0R5GoOcr9klYZtYuCtgdTRwi0=;
	b=xSGFaN4DiVTQHquVGcwVhe4Mitqb5+xG/tKUtfuOzt3i7tr4r0Sl+hsy3WkizvIacax73P
	Pv7jZS9mLck2D/DEl0thTX7vcqtRX/OiO9v0W/s4xkCuh69axoRLI+DZv4+mIOEOuIs+8M
	9flPZG4IsltmoW65gDy6fi9hBxI1M8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76B104030A;
	Thu,  1 Jan 2026 22:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C277C116D0;
	Thu,  1 Jan 2026 22:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305719;
	bh=gHL1k3Ce/0Yqnu3RKEhMFCTtXjaAjQ9JVob0E5Uoa3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGzeR2j4rIaZ/Ba3+tEX6uButAsa/DeTyFZ/qjWHwok0cL1okdkghC1KZAaPrZp0q
	 mfWsThlZYCgTqIaay4c3bwM47lAtXt+WzoxXr/DRH5Et9ydvT7Pu4ei2X5wjV9AxHA
	 dFnsWRWLPe1KcJuDdIklMPPQp0cvCwu+GCWTlHWqn0B1vpor2tzZywc91kiABl8iKs
	 YBO6MC2AEqYWd0yHUjy2+T1E1ucmMfomGE3kA7Zm2U1nRI1Xk3wIAHNfdLkoAXnsRZ
	 3qMTyge8nki18nhfgnzrUVMZarInnosGSTjx5GDRWOBBUVeMhrYFL/xY8k+FpWop4O
	 2BNn6OPJ4Bz7g==
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
Date: Thu,  1 Jan 2026 23:13:33 +0100
Message-ID: <20260101221359.22298-9-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6056D4000E
X-Rspamd-Server: rspam10
X-Stat-Signature: btg6jnrzs1it17kw41w5trf9abmybpag
X-HE-Tag: 1767305720-299152
X-HE-Meta: U2FsdGVkX1/gn+YVh1hw0KYhahq04M145x8fTfQ2D+U+VkD4Wt5OSeafF9YeCoCTBXdXPuYKkfrpTy7hRPLDs4WyFqzcmZu4sdlwA2vWyMqYFI+1CfqSiOXp1RIkvsq4czTHZ3Jm4dpy3xmc6f64YhZrPk2174JP/P+JlndMl7Nt6pdyaA8RWkCaYNItrj85m5Z+xsjIFMec8HCC7SMGByfb/gRJSRzhkO5eXfPit6UUShvSS971LkiGRw0fWaRQ7FqA1f1QqwzLFMx1eIGbSUUEIKsTPqgs8zcApD5JW12evUk/c2r29gnZgHAsbTI4bCxNuN78yyxLy/V0D8okSZsPJucnO32semOj/9qSlD0u48Uae+8pCYYXGvG3vZLcrmh3MmBWfy1JNnMMekGxvZ9UjFIvucyiJd532dxtFNMg/26wLHQ7PXi9V/XlMcg50VSqB67z0NGyReJNoiOjbo7JxJijcLzzLi//VzNCOYXA1Hbtf574X21doKNhFYroPSSJqsDZWrKjBit6ayI648eJ96ZT9wjBOyzbE7pbLyWedz+k/c7z9nlRw0YxjyWCSqpAjPowHzvD8ZPpQwz6MVzXjP5j8nJn8o/SZeLyL37QiC4wuw1TFxRVKykrfOETZDwuvZ0IpJxhXq/8sFmTra8HRM4ctWAZjoU2OdjfypGQcph4+XgLfmGV1tDzYLPefEFm1nREx34MlsjKm1Uirm+5/F2OEXwbjv5sVfKSZaAqyZcPpGhlbCuEtOP6cGi2zcam3P/pGdapj8DXxcpgnaEIVu+FEtuR8JLbD6oyDajjIMbFjVYiIEzuM4yPRLpBMax2X+mOwYpVnGFR+Bap8tMgIlw8vXt8nsru5ffIursYN99v3KxIW3GQ16a/lHMp8S9s1Ne2l0B+eOepD7tRdj+cRT4/ZeBl10/envw5DNBhbZiPjXZjAg==
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


