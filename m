Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A042CCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08D3F8E0017; Wed,  5 Nov 2025 16:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0649B8E0002; Wed,  5 Nov 2025 16:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBCF48E0017; Wed,  5 Nov 2025 16:04:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D83998E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:04:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A21001DE882
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:59 +0000 (UTC)
X-FDA: 84077783118.07.5FC5BAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 213E880017
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kItBEaDN;
	spf=pass (imf02.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldfXdTVU47tWvWbMJyiK3+mGtcCL/Gxcx9lBUXcC8dg=;
	b=wE0XpYKHM57lq1XPe/SOpfykuuBTlIembfV9UDrWLdtSiPuWgNDtOevg9qJds93zHtkQdx
	prGebqDfNSkQ4gBFHck5zNIu8mie3u2UiKbYkPL1qRHxjpEhG0jcxBZn9Mn/+0tOIQMyR5
	jTztOW5VrszY+V86zCBA0Rs4eeAwxDo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376698; a=rsa-sha256;
	cv=none;
	b=ABH0CntTQhp0/gNm/iuuXnNn06i/riWBRouvOakEmOxVA9LSQaU91XyKSdF1gDemldAVWB
	vDcZhollc7zto+pop84novMpH/CQfkfVfFIQIduyxD3iIVEeY4kSvvbyYxJYvMO0HYmPT4
	GnKK5L1qCvXflu9SxCmdzBjIuKDjmiE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kItBEaDN;
	spf=pass (imf02.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 49430409E3;
	Wed,  5 Nov 2025 21:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B89C116D0;
	Wed,  5 Nov 2025 21:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376697;
	bh=SYoV9ZciDsKT7uyTlAb1HvnL9v8aWR3nKq+oz55/MdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kItBEaDNwg83NtBZHN0PY2kO9v4qG9+R9UGhFJXkfz3oeoYG2txCyhHm8tQi1BkuD
	 NWItfaf8aoElYQ+RjvhVLcKuuhff34s1plgMvHf/SEFle9YrkEyqQFq6fErNgLNiEW
	 uYEF73IW+07iSZb619oMuwv6PrVbrMjfvyg+P5grwt/pH++e9JAObxCWjuc5mzZKMy
	 aZ1dugkuLqmPVgs+1gxfJiF2/ehXeFrMHeF5pPRKqaxAvbJcpRFu4H4XfmMUY8PXiD
	 CpEWomCTEysE3h4vCqrk/emFOvpj2sqiG0G0gliDyXtIxhlNYCuVzrEsNmaUc2145Y
	 6h2pO0qbg3p6A==
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
Subject: [PATCH 07/31] driver core: cpu: Convert /sys/devices/system/cpu/isolated to use HK_TYPE_DOMAIN_BOOT
Date: Wed,  5 Nov 2025 22:03:23 +0100
Message-ID: <20251105210348.35256-8-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 213E880017
X-Stat-Signature: 8rmcmninx7rak1xrhdaz3f96mctjyqeg
X-Rspam-User: 
X-HE-Tag: 1762376697-529666
X-HE-Meta: U2FsdGVkX18HRqf/3WAxGo8x7x8NNf4D+uWvmJFLKoh1ALGlRvq9dkHaTPiklJkKjcVT1WGgoBB4iw2aGr6jQAxVAsvBNepnptX7yHq/WHklfy2+8Qf9CV6pLjUF7iH7CTIMIM8ATd9vUmnh4VyAr5fg8wBro6XFo2e0yZJRv4CXiUy9GcJF+NuGyEJrbuop5kFIpg8jH8F+7NqReEG9f915YZY7OU7SmHy9WGdJtZNwugmwjOthorzFzTmlKEj4kdq6lIViDZL0EsIHNTktiPMrHUYa983I+qAHxbE28LSllum4bMn2ExlZTkHyG5y2BXFzW0GtwjfA9kwRKZGwxjqJAfiM6aehcWKzT2imrHL/2RlSCCNT2oI3e/Lwequm5L+7qGTQ4JH1KiYvnNENLFP4ZCXYX/CXT9DYxOlJwOl+D0XWovYmB8bEF/rcydi5qhfiaSajnIxLPQRc4ZAT8MQjqedBKR18fo67ozPx4sxbA7a2hIoNecg42GxwCaWfDE2/hRZKcGYvIOdj5iS2sZsZx5SLITDgDqt51HYjYMYNPWLl56JzLig/lfK2OlZYiIvCGT87UuabQvZcJTNq9MV39uU2o3JkkhG5Xz1QYB8+R0RU98svoHduzf0QIEdTf/dNzfctcJrID2pabNO7c2iJ+e4lCCa7cByf5mSWgCGdKKO0DyCh3s4ooLmwTm9nTV9nBEx/Hj6hEGN5WOzCAhX2tWdrRpLXjjCBkQfFEQ1Z136yVi4DiPUQnorYKBqaPCFuanyeFYu0iE6qNbaSS/+/YsKYvpi7r9cfRUbuzlrnjlQ+tEjfzGK0wDhxyoNC3upJOCqBSGrhjAMVEqmUfinjW7aQF9aHX4JzsNceduooO0fkoodDUJmzLqYKhKagFQxU/ppp1KETSZ+dwlTet6zqbMyK9m906oFX1bNXZKu3aSPEHDoHoCTOxNU4RlauFHU1Z2mPqhgh/o52WDI
 kNIjDbhF
 rM7P+Vpitqg71ork=
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
index fa0a2eef93ac..050f87d5b8d4 100644
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
2.51.0


