Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FE1EE75453
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EAFE6B00B9; Wed, 24 Dec 2025 08:48:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0C76B00BB; Wed, 24 Dec 2025 08:48:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4CE6B00BC; Wed, 24 Dec 2025 08:48:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80E796B00B9
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:48:25 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4ED391A0237
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:25 +0000 (UTC)
X-FDA: 84254494170.02.2A8B95E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B494B4000B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VP9vWtEQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584103; a=rsa-sha256;
	cv=none;
	b=tjhx9/TouNOMx9I/e/U++eEDo6B12M1mOK9YEsm7HOIJ5QvElN4atlcZ85YzWGhjI+cfSL
	zTHPUfJcVk9JZ0LmHLex2ZgW7YNecA38rYCf9L8KWTkCCQhFCPwCU/i6mTU+dz3JExP7aS
	dLTPJNP2eBZPMGYhqV3j8mupYspj2Dc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VP9vWtEQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/10IlccYcazenHZF7/ruQEbfw98HxxiKHU+5k+KbG/A=;
	b=B3XDkYjwIaE0YidBTDQvu3tKd5dZcsfsWAL6UBY/w5266HYxG/ABy9jXkqzthrusixNf13
	M/H2OlFf+aWNYeJxAvgzvLbe9h/eI1HjkjSBYd/wF9Q6ojP3MZEhR1ry18CUYcCfAmGAdW
	u+3rb/mTh/3PfcXJynnuO9Ckz8LOXaU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 38FB36016E;
	Wed, 24 Dec 2025 13:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25099C116D0;
	Wed, 24 Dec 2025 13:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584102;
	bh=j5Xo9SgxVc3Z/snvIhCh0/gaEOBvl1HuvW1WHfNbS+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VP9vWtEQMKo+zDsbevT5wQSFQoFkJ6bHLkXPQ4e/hL1GMsEmhA9S6VLnkLTgADD1/
	 G3SeK7SFyIWx/tRRfwEf7fW8TxX3ip+2wJF7N3zAB5PhHZvpi4vme4GWEln2CpdSbX
	 1DAp1RM9eIBNG1TY46EEx8DQBRDXFtMCcK+HT5K/09bzrHbUOQPTz3M7xa7yrhFaAZ
	 HXwKm7+63Mhl/YGnJBl89pDwpCgx8UfxUJQqTMc5AUlDdZxiRw5amwB/tEiQZcJfm3
	 DvhRdcxE9C3ohMufQvarOKmcMrhy7XmYpkVSGL5E9E/HFmkf3DNsziUIQKNaLRYURj
	 ekZFnfaRzEuRA==
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
Subject: [PATCH 20/33] timers/migration: Remove superfluous cpuset isolation test
Date: Wed, 24 Dec 2025 14:45:07 +0100
Message-ID: <20251224134520.33231-21-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B494B4000B
X-Stat-Signature: tdd1aqsk81pbikwtoj9ab3388tmt3bw3
X-Rspam-User: 
X-HE-Tag: 1766584103-725711
X-HE-Meta: U2FsdGVkX19xANH8Hy9U1s3KxTGUuT10iHrHitq4FWYGO6e3EpZUmFP3K3Ygv1jQVsAwh3DgZJVw0DFs78WvCrORrboUacCf/67pFgoY5YbD2R5r+MJ4nWeom4p5+LFzQt5IpFcASL8dl/hfKMWKFYPjjIcq99lhclx5qsT2XPbHLYePCow1zwBqCg/ogh0MlITHltZc2AzvuqGQDolZsg/UaAcpmQNAOiWT+0WtKyfn0XxxNheUq1T8pqXrCBcGcHjmLnpq0n2JNGb5XXEz29liBcOnZ2Gi5An05iyfQ9khaVfBoxrwEy/I3v1AV//BSru+dpMVUH7YZ5ueLKfb41m/hao6ClmXqezvZIDO8G15mkdCDNxYUg8hH3RH/czQ6SeN7CZd3qczLDgDOE1FhxID6JI62Dh2eH2+HMvYJ4IrWojMuSLh/uGpz3XC0kLdVDqaO66jKMLfieMz3f54yvcsB6X+TUC67cJ6NCOnWkzwyehbnop4105O5uV1TbrhBKIyBPMG1bHHmvjWVmtzSwPbXSy+ibJTeTjw3pZ6nM+BkTYRiuS4d09O2VoywRvz6vu4JLPKvlFD3w5v8en2THiaHNIQyXxGDKn/P/TXtNGb3LHA/HoJyybc9ZSwCOpczKb/2SiaEVQjY5wmYVwSpDwJ0UJsC8pduAc2gahoK9urGMsZ0I2YZY3btP7gke694p4ll1i420uMHRbaWqQc+dq0TRRNICA46jVyerWYzgm68Nlt/V2eFICPgtfOx5Cw65AbRXdId2rOJSijrGEgH3pQPsltyn+rXRZd4ljOYmTapbchn6DztSx3/W8LatOvfXluD//oa6Q03JidK9npSYWBrlFc6w3xikI1gAT5ARovQjKQ9ca+65qZmUl6UExAl6DFQcXPi0klZ/CDZ1UqfGt36Rwb4rzGD90ol2l5ZtNrQACh7bvz3pMGoua/8Yk8P6UqjH5q3c4oDS47jfT
 Hzz+6b9b
 NnHBvB+/DUg4dZ9SHxmopximfvC0cGlMDs555EYExGwUkmTpUjfRIt+aYIYJ4GxHO6ah+4tEhFL5pULbL+amVkuSsSnzKdIzc30PWj5z/prC2DPZbxrS/c7gtpV3/HRvzNZiUvIL5dWYf1fEgLD8a6g002H0JwQIQJ6WJ4ZeZFw6GxsSJM2wxOkvNjl9Wc8XOO2H6v0JEXgwS2A3TgGWzGv5n0i0oVmVUY346pVoLjfPmJzMBb4HLrJAoj9Cvsh2rPgrKpRB10/N56SY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cpuset isolated partitions are now included in HK_TYPE_DOMAIN. Testing
if a CPU is part of an isolated partition alone is now useless.

Remove the superflous test.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/time/timer_migration.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timer_migration.c b/kernel/time/timer_migration.c
index 3879575a4975..6da9cd562b20 100644
--- a/kernel/time/timer_migration.c
+++ b/kernel/time/timer_migration.c
@@ -466,9 +466,8 @@ static inline bool tmigr_is_isolated(int cpu)
 {
 	if (!static_branch_unlikely(&tmigr_exclude_isolated))
 		return false;
-	return (!housekeeping_cpu(cpu, HK_TYPE_DOMAIN) ||
-		cpuset_cpu_is_isolated(cpu)) &&
-	       housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE);
+	return (!housekeeping_cpu(cpu, HK_TYPE_DOMAIN) &&
+		housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE));
 }
 
 /*
-- 
2.51.1


