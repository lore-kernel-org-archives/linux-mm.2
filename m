Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62AA3CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3348E0085; Mon, 13 Oct 2025 16:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53EC8E0036; Mon, 13 Oct 2025 16:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21828E0085; Mon, 13 Oct 2025 16:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA128E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:35:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C22E1604BC
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:21 +0000 (UTC)
X-FDA: 83994246042.07.F54806C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id AB61D14000E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T3Txz8mg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ABzBvs8zUa91NjRajmi2ivpwHz2Zn7lBOca4AwQQzSs=;
	b=gmcSixe1Olc+E7nn9r/yZmtVFQV4h2Mg4VTjEd7Dj7w7kiFkv0WKCmJ3S4M6V1ft+2xm/O
	CLZ6XqW1CC5FgnyFnSucUP7CueJiMviGOAB/s0tPG2bcj3Mm5YTO7Q6Zb/V+iaDxceZq08
	JDTa5d+7eMqPVCO5PuEhfr3g4SAhGHc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387719; a=rsa-sha256;
	cv=none;
	b=J4qGdRUbd3FcFjlk+uIXfOw/SgPgZwYEhnB76lzke3wMp7i6NIzPBrsbF3yHfWCvRwPwsM
	cMkjyl91wRyNs7uo1ef9+FcyZGYPx341UYXf/77qTeGtCzST+aVqzdxE+3P4hPpGdJE5OH
	4W6VsL4Za/tIoMNg2oGVNiusDT+mHX8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T3Txz8mg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B7FC61E25;
	Mon, 13 Oct 2025 20:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1816C4CEE7;
	Mon, 13 Oct 2025 20:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387718;
	bh=JHjdxV/oITldUpJEMoCsfp/cWcTZCJek1YGVWW127DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3Txz8mgpJQOAR5Q8RlIAsx+W79AdsTGWIS538nSAXstvMxpgqoCd1CtaXKa8z0mP
	 BncFntpY6MkVNyZLbDABp+ZV6kRxpKxyZSvdRqK2wkQhA7bV6F7GfQ4gfqvM28Hz3y
	 T6DhflkS3Xv1xc5ZVNxutdoobVw1aaMPtgOwbwcdMd7GX9599YIqi+RblNEO+ddq+F
	 wfMgZCcXYQLRXuiPvRB9tHivW+ejrXIuTYHc6H7MjvZglIQrOWxVIuQRnQ0C+JCLr0
	 qWCVDfuiy9cg2d7pis8gDNCF4/vDaZBYzB6WlQDgcCv9iJ9k5+557jhWRQQibK4kwz
	 idmviYxE7LmPg==
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
Subject: [PATCH 26/33] cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping
Date: Mon, 13 Oct 2025 22:31:39 +0200
Message-ID: <20251013203146.10162-27-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AB61D14000E
X-Rspamd-Server: rspam02
X-Stat-Signature: wbmyse9rrkjomdsg377m7xmrt6jto3t1
X-HE-Tag: 1760387719-405516
X-HE-Meta: U2FsdGVkX1/NaONmszkn2I1s4InmOy1arUd7h5T89NddhpomfUDa8v0H3qvVr7H5c99gnWCBQenvKilDDWLJBnLfSrkTsxoptwtcyhre+3n4vEq3POzyniDEAwTBlTwhy434c5G8bRdoBywObGxqwscuq0hca7D8KtolUrmDUpwyRRRTHCUF3Zadk8x2QQZPU8sGoWHxxkXSKl/z6hau4TzJG7O7eu2Unu2JuhRnTjFoLQTVOTqFuk2zuQ6YzvTm8dvEQ8ar0cCCZu91bY5a8OTdDAvWOw0yejC3Fo3z/0+df6iKJWyaKxfuwPc+Yr1SYyoDPtq9wzY+3PrRt62MasVkdUHA4j2ZwL7CAWx+z9+kYXExVBgNvzFoUuHmUS6gxRN/cyPfzfvYZ5vm8/foxx39FXV/+/xzHz+qy54hnmKy3+JVwNScDcTZ4BPFT1+aHdlE5VXDJiPtQZbdHnyeWBAhnuua/J85ROs680AYD+Y+4zE9262roH+F7FKp75gor8jnQ3WCSq0m6qtoSuSlJE1e4Qxrw7XE+9qKm0rVS7S63xaufUJkYFkMZDcQAB5KL6aiYWYDRq9l9a7eSOmbvesVaHS2OpAJUNIK6vqmrySrO7dqYzbfFJcAr1n+Xw5s81GmqnL0EaP0ncwcfYerOQRvarv3Yuem10JaE+d+EJ2JCQY2PGf3Ni6fVvcXJEXJP6F6qtWZnuTG3jfPCzc6LgUebpnpqHk3Z+5gFVfNdO3aoCFQQRiAFjSCZh2QUyjF5VKDaam9qvHtYNh/WYIYPTZHTaSO/v1piMldB2T02NEeaoEY7lECFW3VmWGU228JCtcgW5LKJTceFx3kuM9VpL1x1bj4inPMB1mso1+34kqaC3OBWhR5Em4t6PFK+beCaK85AUKpQiGnAqhgaWnvJBv82kEBPkeBQyMdFZgOmYD77P+LCuZcyefuPSnakrSSHzxWVSgKgFp8/svmD19
 Y+Jgduum
 /zZGuErvKzCLXOukFj/glzLcM9Rf3KUbKZVPFrH99QGgO3B132g4Bak3vhU56GRak0nq3VVGrsDPQL5Qjgyttw7S/L5buwNgieVzsmp/W6W7UQRn2tU4JFXb6W3FmNHM37qfXZpiYoSXUvngnMmn4wwXfbjf4o6X6NVbCMRtqYgp33AbBCFRA1sUtJXeDF8BDbcFjSds03yl4c2LGL2RAm0U3STKQDWa9LCxn9y1LEom/pZ48PfyAiwbAL8NzkI7cuop2m3x+3zuWte/jfteja0G3lCrf4R8Qh+EVpBDXE8xYMu5pvw8Y0SpPZvdB9IazzRYhjn+FVGlrZk63nBV0hRtS7w==
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


