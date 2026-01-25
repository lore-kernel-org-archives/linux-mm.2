Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4559AD7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9E16B00C4; Sun, 25 Jan 2026 17:49:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7D576B00C5; Sun, 25 Jan 2026 17:49:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996C36B00C6; Sun, 25 Jan 2026 17:49:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 860146B00C4
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:49:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B4E61A05C8
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:51 +0000 (UTC)
X-FDA: 84371980182.08.3D33AC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 97B5B1C0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xh9qasXM;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CH9CKuGBomtUGQZ4+PlDf6AcFHLxJeql89OGbhEvJI4=;
	b=OsebIDmlT4EEWHGw02S31aNOH43gBo+3ld36mDVztpCxS2LMgCPkOCptAPiO1Jfrc5d7LH
	fs154HMFTtT6fOWRf4JX/p9fbksJYJO3WDxDJ4tEayohP+eCS6wPtvsetcFJEyMhq5Avf9
	94aor5NYkuLSQRTPOqZS1pH8HX8Gxfc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xh9qasXM;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381389; a=rsa-sha256;
	cv=none;
	b=VuPM+gUvz/VbRMMT7fv3gdxawlEUDWSGl+CqXWYcTR/LdQgw0Sd5mWY+DxqWlVIFhHiAOT
	sr5ozve5owBP50dT7x2HxDPikE8aqUjawlwjZ4MyxF/IY1Dbkiu+1kTD9X5eJi40j292fb
	3Z8DIelssAevlC88To1slpWEetJwxk0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C1107407C8;
	Sun, 25 Jan 2026 22:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F034C19425;
	Sun, 25 Jan 2026 22:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381388;
	bh=8YH3jJJ1l+zWkUBN7W5HQtnoatv1adfZkeKPi8o8s7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xh9qasXMZUMlZAvDOzubOT1QTX8nu9zdOSq/aG5SytkYO8dDUbUHJYFhPOhMIbOoc
	 shv9P8Bht3wB1y2r2jVGvZJv0HRG80ck2wtcmqKvSpyaFC/xFWa1YeBCz4KK/9ivCR
	 hYkK+Dyczy4RyH0t8DqAhfix9gdqot+5+jz0nhKl5oWWR6gbyqD0RRWpWeslUSffQg
	 5ffYgiOyzrLcj7I2oZeUcUBGC28h6CqUynsHVapP6lqi9yhKrLlwD6ZJaiFeb/Dw6q
	 li4SD3zXYvOkkw7bhKz4ZGmz1nuunbm6XlRzlwkUldb6lKhtWEGk/kgzKSmleS680L
	 XVtpddRKIJWYQ==
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
Subject: [PATCH 29/33] sched/arm64: Move fallback task cpumask to HK_TYPE_DOMAIN
Date: Sun, 25 Jan 2026 23:45:36 +0100
Message-ID: <20260125224541.50226-30-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 97B5B1C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: z6sd7gb1oqreqap1siwsruk9dgxifcbm
X-HE-Tag: 1769381389-212208
X-HE-Meta: U2FsdGVkX1+4pvobC/Jk2KBqLD6qgqMDNODXtNDUwvbpSvaE4/nWhaDvhkSfxz1yqT10pML+pq87nXAQd77Wr8s4Q+EzDbZoDF7SgKWjZLwZ+LLFE0jf0h/E9LadXcP/JTRbAHEcC7KrMSR59SC+Bbo5auP6JRv7u5IOeqPMJtstzdK7wMDVqXUXfD0hODX3v/iJ95sKFSOlU2D16H3tVtYMxIxssfcjAWt9jqYrkubg3FTB6QZMw6rBQFPPcpCWfvQUBL4YDbsygmNepGgq3QUHnHzlSoL+5V1W3RCjC1Zcw/I6RwjK2b01Kpfao31nWIv0AOS3uX7mFuTD8Zu19EQNBSEyEeFafMoCQUc45FFZP17Je2fj6SrkusvC0ABSijZQVhURBuqqYo30dpWvGxUN2gx4sZOOsjC2VOeygnjrOn64N07Ovh81WkgaT3lRqoSHepcegpWkCPijmfB06pHZOemRX0QKGcAIh5zElo+DLHDQnzECbapwLL6amEjrBcxS3v31H5QSetDl7hrLGI9Esgf81PAfrIudbMfJO6sai7FT7jofEWc/jAa9MUyGkrMJFKpNwTjzgotULRmxsIZZ/ZbqdGWclJiyT989wWG1WtPALBJ8+D6+kw8jfnbvWjDt1IcVuXzjKqYFWW+CCHFRtOzL8aMKLEcwjaws+rG5ccCBfE7r1+7Y9aiim1ctQAKEe+pSMDvUO2vLSA1S2+A+3cqfgNwr+x9nwkmi1TIuhe0u4S0FRr62IWy8khH460e/qhVeVEou8o7K2W3fFrIuyjkU1Jsr8oLE1kZIx35px/yuuCw79lKIwy1ZRvjRRbZnAEA63/aYrV4B/TfGDyRC0bmLnvkpbItDNiVnmOQ+hGugfr+Xo3RyaK48cDXU5aKidNmv8UXxpntCcUYi++CUHtX8tVA8yn8OYvbtD3FX2a5A3IZO4ZsLnNxuA9arS8yUDu/kTlopqC20F8P
 IuKvRzrc
 JxI4lPNVzvZ7cbMisCJqpTb4A1GBFygaaRQsoQm7MOcrTY0mzDxoY1yLOoiMVsiodjZGLEOLJzldfKcD8GSZvGBuOZCO97txXTAbKfX1z6gHixRFMjRlaesRL/76xrK5nTTnYcnYLknXcoB6JiHFuiExjg/Gb6Lv1SrR0PF6ivZAQ8i6J5XCUwS2aUkiQvDSHu+niZAlZQhngcntgNR2GexU4eT/X3b8U8ircV+puRvSwV6AHPU3PEwJOh6Z6gJRYGrq+C+VFm9rW/W0W24xWANp5WF2jtHejcf4eCgUdF/N/hyAh4T0K2GJ76A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When none of the allowed CPUs of a task are online, it gets migrated
to the fallback cpumask which is all the non nohz_full CPUs.

However just like nohz_full CPUs, domain isolated CPUs don't want to be
disturbed by tasks that have lost their CPU affinities.

And since nohz_full rely on domain isolation to work correctly, the
housekeeping mask of domain isolated CPUs should always be a subset of
the housekeeping mask of nohz_full CPUs (there can be CPUs that are
domain isolated but not nohz_full, OTOH there shouldn't be nohz_full
CPUs that are not domain isolated):

	HK_TYPE_DOMAIN & HK_TYPE_KERNEL_NOISE == HK_TYPE_DOMAIN

Therefore use HK_TYPE_DOMAIN as the appropriate fallback target for
tasks. Note that cpuset isolated partitions are not supported on those
systems and may result in undefined behaviour.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
---
 Documentation/arch/arm64/asymmetric-32bit.rst | 12 ++++++++----
 arch/arm64/kernel/cpufeature.c                |  6 +++---
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/Documentation/arch/arm64/asymmetric-32bit.rst b/Documentation/arch/arm64/asymmetric-32bit.rst
index 57b8d7476f71..fc0c350c5e00 100644
--- a/Documentation/arch/arm64/asymmetric-32bit.rst
+++ b/Documentation/arch/arm64/asymmetric-32bit.rst
@@ -154,10 +154,14 @@ mode will return to host userspace with an ``exit_reason`` of
 ``KVM_EXIT_FAIL_ENTRY`` and will remain non-runnable until successfully
 re-initialised by a subsequent ``KVM_ARM_VCPU_INIT`` operation.
 
-NOHZ FULL
----------
+SCHEDULER DOMAIN ISOLATION
+--------------------------
 
-To avoid perturbing an adaptive-ticks CPU (specified using
-``nohz_full=``) when a 32-bit task is forcefully migrated, these CPUs
+To avoid perturbing a boot-defined domain isolated CPU (specified using
+``isolcpus=[domain]``) when a 32-bit task is forcefully migrated, these CPUs
 are treated as 64-bit-only when support for asymmetric 32-bit systems
 is enabled.
+
+However as opposed to boot-defined domain isolation, runtime-defined domain
+isolation using cpuset isolated partition is not advised on asymmetric
+32-bit systems and will result in undefined behaviour.
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c840a93b9ef9..f0e66cb27d17 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1669,7 +1669,7 @@ const struct cpumask *system_32bit_el0_cpumask(void)
 
 const struct cpumask *task_cpu_fallback_mask(struct task_struct *p)
 {
-	return __task_cpu_possible_mask(p, housekeeping_cpumask(HK_TYPE_TICK));
+	return __task_cpu_possible_mask(p, housekeeping_cpumask(HK_TYPE_DOMAIN));
 }
 
 static int __init parse_32bit_el0_param(char *str)
@@ -3987,8 +3987,8 @@ static int enable_mismatched_32bit_el0(unsigned int cpu)
 	bool cpu_32bit = false;
 
 	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0)) {
-		if (!housekeeping_cpu(cpu, HK_TYPE_TICK))
-			pr_info("Treating adaptive-ticks CPU %u as 64-bit only\n", cpu);
+		if (!housekeeping_cpu(cpu, HK_TYPE_DOMAIN))
+			pr_info("Treating domain isolated CPU %u as 64-bit only\n", cpu);
 		else
 			cpu_32bit = true;
 	}
-- 
2.51.1


