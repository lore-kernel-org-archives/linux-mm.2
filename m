Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6F01E75453
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262FA6B008C; Wed, 24 Dec 2025 08:48:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 241726B00BB; Wed, 24 Dec 2025 08:48:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16DCE6B00BE; Wed, 24 Dec 2025 08:48:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 071996B008C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:48:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D494E140228
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:42 +0000 (UTC)
X-FDA: 84254494884.03.20813DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 442ACA000F
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jiua12K4;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fqEYD4LjwJ7rhw5p4AZk4bVK7gQuvBVb7b4AGNVi+28=;
	b=EG6pFak9d2lc5KDCBxJNtC8avQhnXd9Eefa4d9DI6YWGAvIZLlIVpmMPobJlBTr534CGEt
	+1ybPX8R+YvcIg+HO7ZpPmKAOUFpZbVeGz61FxLGvDSxyjSfiaq7qdd+tIU1Q7z8VlWV0m
	T1msC9W1m+lFk4M+E+Gvtq2GYg5JaTE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jiua12K4;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584121; a=rsa-sha256;
	cv=none;
	b=Bg6nRPR74f29Wj+1KbwyEjoRNcQQUfukWTT/h/peRJpNC3XRL4Y+J4aGe2U5FvCFonMJ7P
	22Zz5P8+qqW39Gc8S6XBT16ygnJPYa1h5M2vLHrGwy9vE8DiTjBErZqmW3kOlIhTSzhDfY
	W/G9tiJGmHTbGXa+69FZEY7BUUU7HqA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B20BA60136;
	Wed, 24 Dec 2025 13:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE94DC116D0;
	Wed, 24 Dec 2025 13:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584120;
	bh=Vd5zEgAm2uI/g+D2ywWrAdEOzwZScM14UO5N/4sNoXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jiua12K4SprWh9L6H5HuFhCgLnOWGrMamurnMP0iGv6lVyZzVfsdZpVsgY5pAFARd
	 zOkTEQXKgkY1l6oL0MKegz02DeSR4WDHP9J1nzugmwToT45MZOMwSQNQMv9ZOmhpdx
	 BwmuatxKKh3I/JsIsABaiRNUp/mqAT58h/lgQ0L3007InYiU/2OYfVV7RkokDkFfDx
	 emhqVW/4R7HT4Dq6UpXspH0tXVZq89SkAW2TKLbmb38xtrOhPvwKKMRG2lmJDRoU3V
	 yNoIRcFSKEOW2mZt4rX1VAMTCuy9TZV8GFcYgxlTrZkn6IV8vdKKcLAHMwltvKX3pw
	 zlG+rYwvcWtFg==
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
Date: Wed, 24 Dec 2025 14:45:09 +0100
Message-ID: <20251224134520.33231-23-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: hi5gsjkxaknzw7k33sjzwanrqt79gjt6
X-Rspam-User: 
X-Rspamd-Queue-Id: 442ACA000F
X-HE-Tag: 1766584121-824268
X-HE-Meta: U2FsdGVkX19m2yhc8TxGLlOAil+NG1egiW5I5o2F77OI5pn/ToPP0B0fgM7lz0XH7L7N2xNdH0mPKt6gQElJeiEjCvTUtkL3brURpz0FTGaRq91KXNP9SzkxTLTXAmJYznXCZQ8YSHpxDQO0ji3CWub0WY2MjnC2Arg8FgXjRyqJLQ34FlQlMoNIbobZCZOYsf6g0f7AgXmKexcknepgcb4YyGRG18nw2uFFG7nmcA6BcVdwm13N1b/XsjKZ7ga+4tNP7HsaldhdaySgYR827hwJvPW50gFL852s2FInBHZGki2+MFgbCV8eI8/6EEpHH2ZNJfZvOLpmTPGhHT96IH3BTx8Qp2t3r4dyWpRgmcb0g2NkJOZjCHViiP9CfWunGmqY1sXwZwnUGWwXj+joo9aXq/HX2Eh7DK4VWH1xY6p7vlwexd7C06Zbixm6AjWiRFN8VyzfIUPm2YqAIrsMm6UJ7MnLXuT+hYusMMLpRCHPrAjNwhW9PSuhbEfaAohDW7bzeoLwkG0rTZzJQ5WHl6OxR9kGXRQ5X0oe7CacKNLkHbApXTlbs0gDOcJ4BpYYW0jKLd7wlJOxpD4ETHqPRHnvVfFIfR3/BGqCvk/4vP3vpIApPBCE0zAtUUDNvc5Y+tCpKoJhLs4PI+HAfoveZA4wyQduZ3OpHXBmta7hFA1G1iGEvqaD3QfblDvFg8j9UHv6qq1EldUMAxo2kSoNh+reIMuGAHXtwbDBZ6AiMJU1I1hTx7+L60yqF7nofvCEHr6y+HQxukaDns2tzw/t5ps+UhrhI8B7tE3UaiOz2duqX8lAlZve4XJmrVn+42NE2c60n7vEGdkgKLVXSFKEVj0X7Mw4XINu/1xdTuR7pkQQKeqeGj7/iseX+2jFqiYzvxciYcsWNAuIxMhBri0kkZHS4R48WH28YA/CV08UQatZSi9daPdPC1067gYQjAQxbISL9W0nfUrdBII/aOm
 PDUC1eTS
 tsrDYy6txrvECa3AKxJwa/uNoWnYDOzS4GAn73GUCMy8urz4rcJGXJPj6mjolmnixJsRCZEk1nqs91IqdsENkw3pPyGc6stgSScz9R2mycVOc/NNsnH8BS/c+m7Yl/odCiOAj/2xcLFx1kM4s4Z97mcKoEvTgwlj4z1xAFdUTiCVGqsE4IBMnr9JGmGiQ7en07mUDtJ+3SKLMbunMFtEy7ko35XoxWeNfNADsAgco896rOeY1ZnipqvvIKC59GoQj2N5zFNE8YhILu6Wp7EzMaHe7gAX2dOWaEWW9dk/+37IAJfAxgf+cZnsjsM+sJ5w+uGoq
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
---
 include/linux/sched/isolation.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 19905adbb705..cbb1d30f699a 100644
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


