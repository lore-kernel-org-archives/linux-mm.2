Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3AC7CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE308E002A; Wed,  5 Nov 2025 16:07:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5878E0002; Wed,  5 Nov 2025 16:07:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DBF48E002A; Wed,  5 Nov 2025 16:07:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 188A78E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:07:31 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5698C0460
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:30 +0000 (UTC)
X-FDA: 84077789460.13.D6F5116
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 35E6A1C0006
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:07:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UOtgUGl4;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ABzBvs8zUa91NjRajmi2ivpwHz2Zn7lBOca4AwQQzSs=;
	b=qNtmPT5mU0BNup4ELcTfuZFDbZMXcQrK60Bpjji5aaHHOnIJ6BZNKy282VeN96laLXVvEW
	QZqyqT2kfeiuXU/jDwo1zdvC2uqafH8DF5RAoRK6Z2IpKIungbMP1YOUuWdeE6MSd9iPxY
	Qdw67XKCI2hQaWKwMFyp1odq+iH6Y+k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376849; a=rsa-sha256;
	cv=none;
	b=20bnpTQ3bWGK8TfOYXUSzp0EuHccYbMuPkBgC8RnxzOApBvFf1sM0BQHexH1SP+l7ezBSu
	LhpFG4w1HIRjHVgIKr8/3TWmfKz2cNBm4VznJVEtk5gqPBRGMndKxGOnnP9iUP9N0CA7Wl
	TEDBnriXh2IQ1RtePaFNwMuaciXTvwg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UOtgUGl4;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE969406A5;
	Wed,  5 Nov 2025 21:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DB2C116B1;
	Wed,  5 Nov 2025 21:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376847;
	bh=JHjdxV/oITldUpJEMoCsfp/cWcTZCJek1YGVWW127DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOtgUGl4EzIT/CXtpPARtWFryXQQmWL1KW/pmPm22LHMDdgbfer7GuF7zoHKnxHqD
	 TB4QqR5XgJcd301661MTdPJCcxhHdWwK6+v9/a2D5jrHEcrxFjwsmYvJ69GAjnfSXc
	 JmDP/+paNlSwRUwnoWVwq6PHqKb967VDINvF6ALtLmEl5ZK2M4Ofx/bl9AYMVJH9Rl
	 AFMWTf7iYm9QKnVsrpVA/GIn0bAqNBwkTW1syD35Kawwb9Cd2hde1s5GBOrKRTLdqB
	 /ASLAVCihQZyf2B71XvlxP0975zoCeKrez94TdSXcb1rVwMldhzZmmm9/IIfjVVqZs
	 dlHQCiNEdGKYQ==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Gabriele Monaco <gmonaco@redhat.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
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
Subject: [PATCH 26/31] cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping
Date: Wed,  5 Nov 2025 22:03:42 +0100
Message-ID: <20251105210348.35256-27-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 35E6A1C0006
X-Stat-Signature: ahja95m9exu14hsw8mdtrgyarnofqsgi
X-HE-Tag: 1762376849-896193
X-HE-Meta: U2FsdGVkX1+Fxkci/RytYai3+zDQ02DWnGc6vhn0kC9uaNXOPyUDUfPM1SUsNs6YQmkY+BDO/qTTiP2tbB/yS642ekwYEKWnLCmP3Kgd9Dj5SQq8uEQYVJuFOX1mdHGZM+MVdobnQnxH65JAVQu3etDOOHXh/mJtuYf9VkxtPJ6qge8NUjhE4OkcpcDso99ZmYzLR1TD6tMSxI2pUJLv8BwQ3aJvu6/kE9McDYr+GCMcdtk/ttWHYlDZyxyylB8GulZzCk5eompNzXvvtfEiJNfv7B+ysNfNeN/4fjpcKcqIP++WPx9UFN5WbqFZbJ3DPpoJR5Ju0ujPYwACwSCXucNf66ZuQXKKD0Iz/nJElfpf1CcqDwJe7QRmhFhZ0BL/MTOS9VHDF9dd3RMjkzgtBP+o0ks70TwVUGbrGWwwrqEVt49bX+gOjj8QScU6ILRySCh2BybQKeKG4nCornyfjEm2f9bpGIlU5CyD1j5dthVDx3CZ9bqSF7VTDQTSqPZFn0IXSwihpqlj+WSWODs1F0rKqY0nvloZ9vqoAAeBt6zTP4KBZ27O2kSmXIM8g9lIuqPUVJhEHK5p+Kz9xflp2gcNedNTKFMORMdR+kwsONBfeLKkrE9jXmj3kOQj7NSldCFtc+aunjJ6gcxhRUaCCeK+0Hcsq45mmq46eEbfN75I+53CGUTCtV1ReMGeKLR0RgNDaJNKB3zjH0teGRjCgfle9jIS1Upx/MR8c249+ewwRa2rJZGXdv19oi1AZq0VFYMBZ6HZgsDbeRgetyYA+NceRAoyCxvaf+o7rz9Csjrd+FLachig1j/BAdMXtWuOA0wd2owouXxnTMKu/3k1EDUnRWBFM6AxorUMQTndq1L5l3l3Pmk8JBj1jrCFbYUzdn/A1chm1LeqLBg0/KxrWPq6oWJ2WiAAm0z6hzl7EG7vUiOj0OXTM+2p5A4DRYIMtBBRnVZuUMm49C9E6dX
 /FpO1DP8
 yZdLZF4kTrLBTVrhV37X9efk2ELAMaUbrVB0ZAJ+23y9PHF+cvzeQ2Mt1q+Yfkpww1i/Dw5J8/hAhx7TgJNE+XRqmjFQJoPKoyWJ5SOsMv20B3+5Bx+uMVItwpfDWjS+7M9zW07RyYZUixO+2Fwz0ZtCtPPU2sL4zsNDns+v4w7cLCaq1rfck3ohjHSHchKF+NssN+FA/R2biOxzv72AlX3mV5RzCGKS8aoLUWRirbdlBlw7aM6vuNDR4UzykVkVATQTagIni4WP2OF6vm6AtLID2wCERVzFWWmXV01uRvSBFN7GuklqtXYQj2aOSFqHl6n8kBzdUVEQH3Upbdsdiu5bW3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gabriele Monaco <gmonaco@redhat.com>

Currently the user can set up isolated cpus via cpuset and nohz_full in
such a way that leaves no housekeeping CPU (i.e. no CPU that is neither
domain isolated nor nohz full). This can be a problem for other
subsystems (e.g. the timer wheel imgration).

Prevent this configuration by blocking any assignation that would cause
the union of domain isolated cpus and nohz_full to covers all CPUs.

Acked-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/cgroup/cpuset.c | 63 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e19d3375a4ec..d1a799e361c3 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1327,6 +1327,19 @@ static void isolated_cpus_update(int old_prs, int new_prs, struct cpumask *xcpus
 		cpumask_andnot(isolated_cpus, isolated_cpus, xcpus);
 }
 
+/*
+ * isolated_cpus_should_update - Returns if the isolated_cpus mask needs update
+ * @prs: new or old partition_root_state
+ * @parent: parent cpuset
+ * Return: true if isolated_cpus needs modification, false otherwise
+ */
+static bool isolated_cpus_should_update(int prs, struct cpuset *parent)
+{
+	if (!parent)
+		parent = &top_cpuset;
+	return prs != parent->partition_root_state;
+}
+
 /*
  * partition_xcpus_add - Add new exclusive CPUs to partition
  * @new_prs: new partition_root_state
@@ -1391,6 +1404,42 @@ static bool partition_xcpus_del(int old_prs, struct cpuset *parent,
 	return isolcpus_updated;
 }
 
+/*
+ * isolated_cpus_can_update - check for isolated & nohz_full conflicts
+ * @add_cpus: cpu mask for cpus that are going to be isolated
+ * @del_cpus: cpu mask for cpus that are no longer isolated, can be NULL
+ * Return: false if there is conflict, true otherwise
+ *
+ * If nohz_full is enabled and we have isolated CPUs, their combination must
+ * still leave housekeeping CPUs.
+ */
+static bool isolated_cpus_can_update(struct cpumask *add_cpus,
+				     struct cpumask *del_cpus)
+{
+	cpumask_var_t full_hk_cpus;
+	int res = true;
+
+	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
+		return true;
+
+	if (del_cpus && cpumask_weight_and(del_cpus,
+			housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)))
+		return true;
+
+	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
+		return false;
+
+	cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
+		    housekeeping_cpumask(HK_TYPE_DOMAIN));
+	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
+	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
+	if (!cpumask_weight_andnot(full_hk_cpus, add_cpus))
+		res = false;
+
+	free_cpumask_var(full_hk_cpus);
+	return res;
+}
+
 static void update_housekeeping_cpumask(bool isolcpus_updated)
 {
 	int ret;
@@ -1538,6 +1587,9 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
 	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
 		return PERR_INVCPUS;
+	if (isolated_cpus_should_update(new_prs, NULL) &&
+	    !isolated_cpus_can_update(tmp->new_cpus, NULL))
+		return PERR_HKEEPING;
 
 	spin_lock_irq(&callback_lock);
 	isolcpus_updated = partition_xcpus_add(new_prs, NULL, tmp->new_cpus);
@@ -1637,6 +1689,9 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
 			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
 			cs->prs_err = PERR_NOCPUS;
+		else if (isolated_cpus_should_update(prs, NULL) &&
+			 !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
+			cs->prs_err = PERR_HKEEPING;
 		if (cs->prs_err)
 			goto invalidate;
 	}
@@ -1984,6 +2039,12 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			return err;
 	}
 
+	if (deleting && isolated_cpus_should_update(new_prs, parent) &&
+	    !isolated_cpus_can_update(tmp->delmask, tmp->addmask)) {
+		cs->prs_err = PERR_HKEEPING;
+		return PERR_HKEEPING;
+	}
+
 	/*
 	 * Change the parent's effective_cpus & effective_xcpus (top cpuset
 	 * only).
@@ -2999,6 +3060,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 * Need to update isolated_cpus.
 		 */
 		isolcpus_updated = true;
+		if (!isolated_cpus_can_update(cs->effective_xcpus, NULL))
+			err = PERR_HKEEPING;
 	} else {
 		/*
 		 * Switching back to member is always allowed even if it
-- 
2.51.0


