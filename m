Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9605AEEB57B
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082E36B0092; Thu,  1 Jan 2026 17:14:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02FF16B0093; Thu,  1 Jan 2026 17:14:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5CF86B0095; Thu,  1 Jan 2026 17:14:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D08026B0092
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:14:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEDA914157E
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:14:39 +0000 (UTC)
X-FDA: 84284800278.02.B0D1F83
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5788D100006
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:14:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bPTqFrIP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305678; a=rsa-sha256;
	cv=none;
	b=2hSlo9Sw7DttJGCvZ5g64rjMmUpQFXVTMIDLygmhPCbMLnHp+d0/Bn5nGCBwnWkhkhI/pW
	F8w0dVabVujfLiGneZbqnJzhNruTEVtu1ldKGDSBTKyEYAtSnxmc01bPl+rjMlsVCcfblB
	3dYJR3h5zKT/yBGo/CjRZuY97JjVb8w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bPTqFrIP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLzPvP10lPZmnoDZlVjZaj2C4mTuFn9mkofErYVOVAU=;
	b=D7jjb9gyrhIq4fotS6RTV6SbF24e32kGvJil1x/06IepmHrkDnlSePOZrWEJrdYCRPIPaG
	/YyZ1oELfOsM/wyYAHvnbU1j+nB26S1ubwjXovqhM+fiYST8s6e/klymPy14oB89CLUYCj
	nMNdHBlmFoeSkXlgp0wbHJtVDvDB+ns=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D45860055;
	Thu,  1 Jan 2026 22:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F29DC116D0;
	Thu,  1 Jan 2026 22:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305677;
	bh=xkhk7ZGxynk2RcaH6iYDB0TKNwEPyWR7khi8Efbu4u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPTqFrIPuMeDiUKjLJf1BdJZTy8900oENIeuIH1dkJxlc6njI1s0k74kL6OtDCJJ8
	 R0azKjfphZArLtU64G3kGqplYYG9rSP2gHe1okwairy5AcP1hIu/yPGli7wVh+MMLx
	 Cf4HBRsfB7tB3ryzbCrOSwtSLh1ZhMMxFnpbplQa4efDNabKMfYGXmlvewbsq3eSLw
	 Q1gD7Sfampvfq3ZlL6yE+MwTbAdJW22yf9odVWI6MJ/KVLI6k1vg2L2FqskDdTxYRE
	 zgzfjdPOV14ZLPrpP77hkiEf1Z3io3x+v2KJKdO0dh6Rp9zb43IWkyhypLpv3OfYav
	 /RgNIaTo+1D9Q==
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
Subject: [PATCH 03/33] memcg: Prepare to protect against concurrent isolated cpuset change
Date: Thu,  1 Jan 2026 23:13:28 +0100
Message-ID: <20260101221359.22298-4-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5788D100006
X-Stat-Signature: fjesissud9mqajpbg3chakjygfu1mghs
X-HE-Tag: 1767305678-671063
X-HE-Meta: U2FsdGVkX18n05yeds/tazo8VHnW61UVMedhXRz14iNpfpKtl10k2PXBGr06DukOkmIAn5fbsIQfWHIOgqcQeq8vhf3/oA4wosTT/kVRGmrHZToaDNSKNzOq2XOiuaodcgu+NFDTc3/MkXJyjMPiQsqjAOHlTMCuYHNjXyuS1bsHValFgFeqk77vlhA0b89Id4IKRHkQS3MhQqg1YauZ6adk6biGHBNgZ8sfup4v85tCtTkjJHNZmDr9CCHGhKmpNPw4VeL6npLTDoV4MeNB/745JLb0/Ede6mBq/usb2KcNdkXPyDwffBWxfqtz7RCv9ZUt//P3Z+p6QBtaIJU3TNwdjsn0Ku5U9WmLhlOUZgHTQBMBIxPPEWEtQWpceQ9FtkHiXhMwvlq21/Bxr71v1LIFDCZ/Juyxp7ruNr9iNeMb0PgLzvif309Z+GWqcAUU+vatuZgUHG2WQTytYmu54mTTQPcwTabA1iep/cl3pLCWPcb/OpCThLYGxn70cYfbExruef9b/ONzRE9Nn8jOvkG3fTGiILpiph6/Auz1MzSjxaeVlKCoqKPNQaAqhZSUJDtssFPA5E5ZZ7IwGOrl2zIz4CZwgAs4UWevvqUk5KGJ2B+EkZFP4m61gVkELsY4uDXyFmFDKQUBNtCN8EWJzSCBHodrWPuVOoybd3WZMMY75FhMh8xCa3H6WpdtMJw50OtN3kylUQCTy8zaM6t6hVYMwKXX2eHgzKtRDomqSZ9btczNi8OlpdmH0PBEXY5a9S+sKL0TAPyaS7QxF4i5dmTLs6CIBKfm21Ay9OEn9xqipB/+6M4+wPGBNXzVrIrLKJM+48zTzyErdBUeCKbTY09Pln67KuSGytHy3+fuU6QJKOzTQavGz+MDVj3qoZCRQEi8nVOtHTyLVClC7tP7pdiTZWc+novgUsT1lWfpUoQa/KYtNZr8KwZ3edqxPDFBHfbAPa7Ig4gM4PFK1ys
 ho9pYD9R
 CAuftUxu+2TVh+u8Y/q3i+IkYtQ83Eqbf3usxVaxOCmfNiMIrNB5GpPj3o+mdT9unuqGzI+OzMNAtT/mKdhyUsCMVW1MWuemeh/rZ5poJb/UH1QEBNOaqh+xxQWyDIB7lHBDsvUoVPXnt+xvWgCcSfRO8r17l4kDkvVDSXiEjsVsfpMOVPZZhIyC+lsguWyyi717Ug3bBwB9i2a3Z01Hlfvcwq+86ftOdkOKpanZnLNOkMJhqJL767AdNGHVCbq04Ml5ExLjf9X4XnXA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
runtime. In order to synchronize against memcg workqueue to make sure
that no asynchronous draining is pending or executing on a newly made
isolated CPU, target and queue a drain work under the same RCU critical
section.

Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a memcg
workqueue flush will also be issued in a further change to make sure
that no work remains pending after a CPU has been made isolated.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 mm/memcontrol.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index be810c1fbfc3..2289a0299331 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2003,6 +2003,19 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
+static void schedule_drain_work(int cpu, struct work_struct *work)
+{
+	/*
+	 * Protect housekeeping cpumask read and work enqueue together
+	 * in the same RCU critical section so that later cpuset isolated
+	 * partition update only need to wait for an RCU GP and flush the
+	 * pending work on newly isolated CPUs.
+	 */
+	guard(rcu)();
+	if (!cpu_is_isolated(cpu))
+		schedule_work_on(cpu, work);
+}
+
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
@@ -2032,8 +2045,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &memcg_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
-			else if (!cpu_is_isolated(cpu))
-				schedule_work_on(cpu, &memcg_st->work);
+			else
+				schedule_drain_work(cpu, &memcg_st->work);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2042,8 +2055,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &obj_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_obj_stock(&obj_st->work);
-			else if (!cpu_is_isolated(cpu))
-				schedule_work_on(cpu, &obj_st->work);
+			else
+				schedule_drain_work(cpu, &obj_st->work);
 		}
 	}
 	migrate_enable();
-- 
2.51.1


