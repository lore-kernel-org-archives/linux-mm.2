Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7DDF606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bISE3zh6
Received: by kanga.kvack.org (Postfix)
	id C2D706B05B2; Sun, 15 Nov 2026 17:34:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04706B05B6; Sun, 15 Nov 2026 17:34:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC6F6B05B5; Sun, 15 Nov 2026 17:34:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 721A56B05B2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:34:49 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF50AA0509
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:34:48 +0000 (UTC)
X-FDA: 85438809456.23.05C047E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D0FC7140002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:34:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bISE3zh6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf23.hostedemail.com: domain of devnull+alireza.asgari.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+alireza.asgari.net@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794782087;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FaLPHI6QmzOizX2R7WI+RZFG5s4TESyYrXh8VTsFQ1M=;
	b=q4D/xW1Uja4HeBf588ouximcNbVoRSFBE+S1OMFNYgIp6RvmXrLLwsPsfO8GkHssoZ2DkK
	4Sv2tA2eFHsPXKQTOOAOA5qDLU4m3EuingEfku4NvLCr5c9mB7HDiqEM1bFmFduJ2+06Rx
	UarNDSG6eFP1YR5CCuqYtEm636+QKzI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bISE3zh6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf23.hostedemail.com: domain of devnull+alireza.asgari.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+alireza.asgari.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794782087;
	b=RdeLNVeltbEYcHxUPZ12XWthy2v4D6BPUB1jYgS/uTWH1Ro4qyCONsdFCtycintmmDfJHc
	tINHd/52Bj7uBKhRTeRZXmqpPgi7yMWvBKTWGkj4eeFXd5q+J567LO0AAP/FB4cztRdFNt
	mtwvBhaUcC8wY0ho0OQeAgd8OecMtEw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B9B345A53;
	Sun, 15 Nov 2026 22:34:46 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794782086;
	b=Q4wbpYZFEgbru3vNPbFyCmn5+2zBhgwhkBgFwo0r9huEevalZtx20v1KJMSjVVDE3nTM
	 PEM9LzdN/qglBnQcmVYstIO4NNK6Xnn2/niG1TO7Sx7gl3Vm7lrTAz3Q0GHeDhPcURmOU
	 1HmMWGwZSi1kpAXIieTJD5FKYyWbH24iEnt4l+DfkcTVsIu2ZvoBzs235z/kSxN3fsURw
	 JFBTT44ze3fzeIkM60VACfrH4fwbpt4KkmghwZukOLylCKPKs4ZGGzCSKWeY8WdC0eCbl
	 n2z9ZruAIkYxNGsnRvI6MC2O8dCip+HAAPPYE6cXlDNq52kgzREUwBn/vCebhCF0JXQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794782086;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=FaLPHI6QmzOizX2R7WI+RZFG5s4TESyYrXh8VTsFQ1M=;
	b=NBbyvf40Niz5t2LYt6+77wFo9lBLjD50UIdGNNBKdUocNgdZq5enYKFF9zKhSd450vPD
	 deCrPDLVmh7Lin2KrwbT58uGYAS+R9fyS8C9mvdbgUeP1dvNTHJ4VuCuIHWtq0GEvO7Pt
	 GnPmm+jBQTUeGmYVwftw48RplrqSsej8kfbh4sXu6t7yw+csp+xubN4mPqNHedDmw3cYS
	 Ax2NMVo0GP5kWeLYnVdYDLi2bHhtX3giWY4FzezoT++9T7OoPCW5aFsqWHz80Zkhea78W
	 m/HmYmS+D/f3Rfa1Z4blSKQ4taZVoT+L4i1jkQ+/928LIXeAOQdbq2SHcHgnNXHSh2A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D24141F000C6;
	Sun, 15 Nov 2026 22:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794782085;
	bh=FaLPHI6QmzOizX2R7WI+RZFG5s4TESyYrXh8VTsFQ1M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=bISE3zh6v5YoUqO4iihTt3xCNizWtnZRLXYlw0YZm5SUXQw2PVXC1o36NG0jXqJwB
	 zD5cbZD/Y+x2YVb1bvi0Ra6bTAOXHii1td465oztARAiXqnquIkVwy4eiAg709Bgjc
	 nRSq4fN0jZOB1n5N5MKjIqFRPngwFk6QUgW60dGrH1MpYaNpgeDZgdhVCmooZz5NvM
	 QuJQjBOw0UbY4w+KKDoWnBffMnZwU7kBc3W2M2RItnpKa01ws1ohNqjvH8cKOzc8de
	 niLttdE2eJFFmyWcqagC8zBNE1EWMoXGSNYOdX1m1mBAVPigRK0WliGnI9ghW7DZVc
	 h9g6iKv0ioWmw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 629BF4A245;
	Sun, 15 Nov 2026 22:34:43 +0000 (UTC)
From: Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org>
Date: Sun, 15 Nov 2026 22:34:42 +0000
Subject: [PATCH RFC nf-next 2/9] memcg: bound memory.high delay arithmetic
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261115-b4-nfqueue-memory-accounting-v1-2-b9cc30819997@asgari.net>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
To: netfilter-devel@vger.kernel.org, linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Shuah Khan <shuah@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
 Chris Down <chris@chrisdown.name>, 
 Zhang Jiao <zhangjiao2@cmss.chinamobile.com>, Song Hu <husong@kylinos.cn>, 
 cgroups@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Alireza Asgari <alireza@asgari.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794782082; l=5496;
 i=alireza@asgari.net; s=alireza-kernel; h=from:subject:message-id;
 bh=w3ayk+U8FCJ6lXFONsO42X2e0VbfkJT2uJZSfO6L6nE=;
 b=7Z0tS5xgqA3bYLUfmPyREPp431QgCdAYI5U0LRMjsIixhzk90bkt7WUmUx5FBL8IKOplA3krb
 fdElWo/CNpRAFHKXE8tJFC0elxZLFFJXqMoF+ZXM1deKDCqsTXQLByw
X-Developer-Key: i=alireza@asgari.net; a=ed25519;
 pk=wuQ0/M69FqoVnrCMUJ13EQCwrCwVjCrtz75k15vW8tw=
X-Endpoint-Received: by B4 Relay for alireza@asgari.net/alireza-kernel with
 auth_id=1055
X-Original-From: Alireza Asgari <alireza@asgari.net>
Reply-To: alireza@asgari.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D0FC7140002
X-Stat-Signature: ijz6d8cf3mz8oze7n7yijugu8cxhpsxw
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794782086-909257
X-HE-Meta: U2FsdGVkX184+FbMfulee0BYtSFaLfPhB8GojZ62KSPRwPn8M4RBz6dOuVv/V7olVLfr3Rfahk8QYj0iBZx9S5E9W1eIOoKcodu0LGPQQAAA9nT4uBnefR95TBjAzB63OZyHPTFOhGuCA5hkIgQ5dBqYgWtCeManMPyEX239EQLGfq/qko6tTcEIvqtckznTL7Nmhgc9/Efq698M57ThlrALisCHIQeLNSxHuFuyU5QulQY/4MeNIcP4azc5zUTPHJ0kWT2j8sRxfq5gO6uDfSj2PD37jFY/Lht3HCmm4XaxnkVMbr0SeZHonZW/CmjsFjIPMcD/6/W0UFHgtkDgDMwn0+O4dvq6TmONGkjc7Ray78NGN1hSpDrFU6DHnaKjruHIYW6d/0hA/huvR4mKqYW91Qc1fmTix1+0j2DFf9X0oHL4aJwlmSr77HXeXNQ3mklICsCc2k/2cDsFjfNwKNzqdi1Xh+OWR8D3OJPy/SaOsbJbotJ4TIRDFiBs2Y2Z+/cZp0x3qfEpxQ9LUg3RbwhC54BqdzHnlpkD8MLnI1yZdkLUHLe1JqfYZf1rGPdT2H7t3TlOqczrOoNn0vObDquLAZRkEt57R69du+rf0n5+XjAz7wqc/6O/R/a7tvRPvwbuVdWJRjI/yTf2A+0fCUOF0bKSi+Hphj9pT9w7BFLmuMAHaEGqpohsn1wbHZHkT2gMRHCs9ZlSPS0l1sVFGyIoD/a1AA9zSFljmQGQUWmWF2xjDw6b4UvGS6Zbhjoda86YVgQU8VhTyc0Tf0GVU3RE235rOgfJnPSpc605yBQ9kYttgH5SvTzwrBwTCC3e32wzwfLk8UNclaxqz8Nde5hmOj3zvmlP8b0O7QShkR/kj2qAouxJTqe+zcLEyxgerFV15f53HQjBGYTPGxRaO8f4mV59v0BfvFzFWX+7lHjHCS78N5ZbZmOu62ZkVUcAeFxQd2/QZq/iAs6MxO+
 vY/MYLuD
 QEW2HpCMH8idNGmPN0i3DXWjJ8Rr8BK42J0MakhC2+f98CWg1xI1NeVT1gNtmiIuoukBeUvCFQg0zeKBJ2CxZf4ug6IRrMdefdifWUQ8jLldZovjA7Ub+iAaMK8oViaLFNJd1oxE8INY3vhsTgGxAyKZ0h1HbTlyYMz+i4XxosdDvfYZu9o8QHobOTOXHx8lu9BPoiGHtCQKDenxUH1HTp1EFTSghkjllqBNAuMGI0VlnctVf1IP+dPWsAdH7W9PfGa0bB7kXG4as7Kab+E6LIOHeSXXKA/nVmcvLuxyzVVS2xc2gdZbgh5emzY0j9+iExsmsVDIWj/fYHWkVsUW4tPRUY1ny6mgHy+4ZbpwUMjaapXY0Pg432VWHp9KYd5QyRmVolCe0HohUFGquecaJ8tJaFBtjQsdcTDKsK7txnGKU3LMiwkhdEbYbTe6SumHRN8ffkrBI6CPp8MF1dvuW/MvrWi94NxeLzdE/nU7BC5x8f6jdlaz+HP7dFRaYC6DRj0YXOPHXEACJvn7cjJgI+WcEfyaVq54gKdM1QtcTDQUrviJgdODU8vcfxFtqqgrZyFcAkExwAOc37NpNUqa6ePFa0dJpaOG5oZEJmNitP8LzIZM259X5Z5milnmOWAzR0wi0ObmgzcfsmYyX0qQHTUavWq+NoG9H6/jG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alireza Asgari <alireza@asgari.net>

The memory.high penalty can overflow while scaling the usage ratio,
squaring the scaled ratio, or multiplying by the task's deferred page
debt. An overflow can turn a large intended penalty into a small or zero
one. On 32-bit kernels the unsigned-long intermediate is also truncated
before two right shifts totaling 34 bits, making the delay zero.

Keep the intermediates in u64 and bound the relative excess at twice the
high limit. At that bound even one page of debt exceeds the existing
two-second final cap. A bound of one times the high limit would change
valid one-page results. Below the bound, use wide multiplication and
division so a large numerator with a modest ratio remains accurate.

Preserve the fixed-point rounding order. Bound each memory or swap
component before converting to unsigned long, then retain the existing
cap on their sum. With HZ below 12288, the bounded square times HZ fits
below 2^56, and the later product with UINT_MAX pages fits below 2^54.

This work was examined during AI-assisted source review of virtual
capacity accounting. Song Hu previously reported the square overflow;
Zhang Jiao proposed a fix for that overflow and the 32-bit intermediate.
Johannes Weiner and Bingfang Guo also discussed multiplication and return
width. This implementation addresses those problems and the numerator
and debt-scaling boundaries. It is an alternative for discussion, not a
claim of a newly discovered problem or a revision of Zhang's submission.

The accompanying KUnit cases call the arithmetic helpers directly on
32-bit and 64-bit kernels. They cover zero and sub-batch debt, ordinary
rounding, large numerators, the cap boundary, and the prior zero-delay
example. This isolates the arithmetic; it does not reproduce end-to-end
reclaim or throttling with large physical allocations.

Both arithmetic cases passed on 64-bit and 32-bit x86 KUnit kernels built
from this series. They exercise the production arithmetic helpers without
requiring large allocations or claiming an end-to-end throttling result.

Fixes: 0e4b01df8659 ("mm, memcg: throttle allocators when failing reclaim over memory.high")
Link: https://lore.kernel.org/20260818012115.65838-1-husong@kylinos.cn/
Link: https://lkml.rescloud.iu.edu/hypermail/linux/kernel/2610.3/11270.html
Link: https://lkml.rescloud.iu.edu/2610.3/12576.html
Link: https://lkml.rescloud.iu.edu/hypermail/linux/kernel/2610.3/11904.html
Signed-off-by: Alireza Asgari <alireza@asgari.net>
---
 mm/memcontrol.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1980fb7431a8..665ce8dfb9ec 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2521,6 +2521,15 @@ static void high_irq_work_func(struct irq_work *work)
  #define MEMCG_DELAY_PRECISION_SHIFT 20
  #define MEMCG_DELAY_SCALING_SHIFT 14
 
+/*
+ * An overage of twice the high limit gives a nominal delay of 256 * HZ.
+ * Even one page of debt then exceeds the two-second cap. Bounding the
+ * overage here keeps the delay products in u64: with HZ < 12288, the
+ * square times HZ is below 2^56, and after scaling the product with
+ * UINT_MAX pages of debt is below 2^54.
+ */
+#define MEMCG_MAX_HIGH_OVERAGE (2ULL << MEMCG_DELAY_PRECISION_SHIFT)
+
 static u64 calculate_overage(unsigned long usage, unsigned long high)
 {
 	u64 overage;
@@ -2535,8 +2544,12 @@ static u64 calculate_overage(unsigned long usage, unsigned long high)
 	high = max(high, 1UL);
 
 	overage = usage - high;
-	overage <<= MEMCG_DELAY_PRECISION_SHIFT;
-	return div64_u64(overage, high);
+	if (overage >= high && overage - high >= high)
+		return MEMCG_MAX_HIGH_OVERAGE;
+
+	/* The scaled numerator may overflow u64 even for a small ratio. */
+	return mul_u64_u64_div_u64(overage, 1ULL << MEMCG_DELAY_PRECISION_SHIFT,
+				   high);
 }
 
 static u64 mem_find_max_overage(struct mem_cgroup *memcg)
@@ -2576,9 +2589,9 @@ static u64 swap_find_max_overage(struct mem_cgroup *memcg)
 static unsigned long calculate_high_delay(unsigned int nr_pages,
 					  u64 max_overage)
 {
-	unsigned long penalty_jiffies;
+	u64 penalty_jiffies;
 
-	if (!max_overage)
+	if (!nr_pages || !max_overage)
 		return 0;
 
 	/*
@@ -2589,6 +2602,7 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
 	 * its crazy behaviour, so we exponentially increase the delay based on
 	 * overage amount.
 	 */
+	max_overage = min(max_overage, MEMCG_MAX_HIGH_OVERAGE);
 	penalty_jiffies = max_overage * max_overage * HZ;
 	penalty_jiffies >>= MEMCG_DELAY_PRECISION_SHIFT;
 	penalty_jiffies >>= MEMCG_DELAY_SCALING_SHIFT;
@@ -2601,7 +2615,9 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
 	 * MEMCG_CHARGE_BATCH pages is nominal, so work out how much smaller or
 	 * larger the current charge patch is than that.
 	 */
-	return penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH;
+	penalty_jiffies =
+		div_u64(penalty_jiffies * nr_pages, MEMCG_CHARGE_BATCH);
+	return min_t(u64, penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
 }
 
 /*
@@ -2654,6 +2670,7 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 	penalty_jiffies = calculate_high_delay(nr_pages,
 					       mem_find_max_overage(memcg));
 
+	/* Each component is capped, so their sum also fits unsigned long. */
 	penalty_jiffies += calculate_high_delay(nr_pages,
 						swap_find_max_overage(memcg));
 

-- 
2.34.1



