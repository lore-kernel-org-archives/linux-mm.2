Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 159B6D37496
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 20:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 777836B02DA; Fri,  5 Dec 2025 15:01:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74EFA6B02DB; Fri,  5 Dec 2025 15:01:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C406B02DC; Fri,  5 Dec 2025 15:01:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59EC06B02DA
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:01:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CA96C0312
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:01:54 +0000 (UTC)
X-FDA: 84186488148.14.E5DE639
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 23C4840008
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:01:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Advv6ByD;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764964912; a=rsa-sha256;
	cv=none;
	b=fMa43xzvuHRjtx3ZGta5zl+TMVjlXSzQ3E++pJ+anOGAVU7PTVTO7dZT5H3/8J37RqNA0U
	ElrJgsgy33Wt1JiBchP6i/aEbHWqT+I61g2bVm0OXpVvxbMuCzzTxb0i2dmPQSZ+MwR36T
	il8Q7ND3zjKqxzaSJcsjuaU8ffAJdHw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764964912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Y8JRrP85HeD4bfHzsqESrR1BUs8JDIpk2PBuI2nVfCM=;
	b=lWNBaLZMEr3XKrVfQcH7lnEEBTq4dpHHI8YCQbTT52pRQtimXUPNbuEuA/6l31Oue7NXI5
	d9Vb9VdXQweZMolj1uHzEi8Z3LmuLPKEaHdhsj/HlCCWNt7dBzx9ggjnyAyQnW+n6uxOkM
	hBL1v/Bf3hHxaHWzGCoD894GP7B8bN4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Advv6ByD;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764964909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Y8JRrP85HeD4bfHzsqESrR1BUs8JDIpk2PBuI2nVfCM=;
	b=Advv6ByDKq8ve4f9Uu3WMvq6lj1OPuBWHBBtjx17tIvUqti2FXx8wEJ3l0t0s7gKzcXiL4
	5eA7OJfQMlbOiSNSeZf6uSVpCmTALXkn/SxaM3N19SU8KiJBbct5dixeG8+nFoeEQcfsPz
	vrpXVt+9MrKdkISt0IyiaKV1F/22B/o=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH v2] cgroup: rstat: use LOCK CMPXCHG in css_rstat_updated
Date: Fri,  5 Dec 2025 12:01:06 -0800
Message-ID: <20251205200106.3909330-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 23C4840008
X-Stat-Signature: u5hr1hukoiokdc89tnzatktfmkwbu149
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764964911-983474
X-HE-Meta: U2FsdGVkX19E708AKVlUyaW+AbRts8lRg/rCrRYjlpocMutNZMOV06HYL3l+QcuX6QMK7YDHTRCuQf96xqKttn+a3o3EoVkW1wMvzsqrZnxJZAtRIjcLgWBZOFxqXur52J8FMwgcUPW16/nfY61DbjGDfjOfl9kM8sRaiswCfaKBzixlCB64/7+LQDOK7htkPcozLeQ8ylvjs1fAEDGbSNZe96Hm/4Pr8+ghPN6MMtrdjCOOMxoslVj3igoFWFE1hW9Q2kE1XZxvJ5fCuH+l+7bwUfX97phwjE1bDSRRRQQoekNdCwjy96fnijDxLFMHkoY+V/x7dCWAF45ap49ZJ6GudJ+u+qL4F9Npe8PHK8PDfp5erbVp9zyfIcuXsmz+agVPcFR78Noty4pTPrYgF3x20ho0UWME31Dy0kTVf0hYU47JalQFkPajqr0qTCKlf9BT4jMZUL7gOjuofIphs3dXAlHG4ChEYSNPTB8ElAARPgkfZqlgx94vBOeZ2glpcksrqg2NgkE2uBV6w1fN8vUvFoZH+hWvU9cJkUMjLVKcWGFlJYHgXk9B5L04ACavBft0LXZ/RLSXZpAWjkyVyRe5ktrVQDJ+H8WWvW7G+3PvV8Jjr0bFKTm7iPbmKAm/TcTGzOfvs2r+TkL5NRF2Mqy0gzDCXVAXxDlNUhviHwWVWTZPTzqBielwPdVkYLkCBSGUlHJZ430TTKSmsB1kyc1gkYXvO+4peGqHlhCjyhsbftTiSNUvSIBEj6wq/06gH3t2AjDk5qlR8jwDBL7wG2qqpBvb1MJ8LLfBOezm4xpFXM+5b3udemqb0Sv05PFCLZqqXvfrau6d8GmGMAPzJ5G/gk12xrH17xnoYqtq6N1ATL5jaP982rcan22gq2VjgvGboh/yZGS9Y83cMRiRG1lV8aAAoi8FYoKhbgW2cMs+n72xtLnN9Q6tk0XNMwRBd7+9UzFW99/CD8UbbGk
 /DyPTaCk
 zG+FD+24xeZ2IsaGr/Zko1FcG0UZRnKcUKQr+PHOhKZ0JoMZYYkhpf44hcUpQT4ZMTammt0A766gg1IwlI3rraq7/XfxSaCPofIJs3725FTarXC7GHirE62Jeh3wbzqh/TZa44d0jeOVbdtDmg1lzJyC4s4fC6d0edZuaHVREuxUvKaSTon+kjBadOg6OoMzIfVlNT2jzsd6Z5qq0rSTTzKtrCr43Uc/DdT6CFSmMQFILgQdROSuc+U7Rt9a43OEjhqbCIVqKPFW861o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On x86-64, this_cpu_cmpxchg() uses CMPXCHG without LOCK prefix which
means it is only safe for the local CPU and not for multiple CPUs.
Recently the commit 36df6e3dbd7e ("cgroup: make css_rstat_updated nmi
safe") make css_rstat_updated lockless and uses lockless list to allow
reentrancy. Since css_rstat_updated can invoked from process context,
IRQ and NMI, it uses this_cpu_cmpxchg() to select the winner which will
inset the lockless lnode into the global per-cpu lockless list.

However the commit missed one case where lockless node of a cgroup can
be accessed and modified by another CPU doing the flushing. Basically
llist_del_first_init() in css_process_update_tree().

On a cursory look, it can be questioned how css_process_update_tree()
can see a lockless node in global lockless list where the updater is at
this_cpu_cmpxchg() and before llist_add() call in css_rstat_updated().
This can indeed happen in the presence of IRQs/NMI.

Consider this scenario: Updater for cgroup stat C on CPU A in process
context is after llist_on_list() check and before this_cpu_cmpxchg() in
css_rstat_updated() where it get interrupted by IRQ/NMI. In the IRQ/NMI
context, a new updater calls css_rstat_updated() for same cgroup C and
successfully inserts rstatc_pcpu->lnode.

Now concurrently CPU B is running the flusher and it calls
llist_del_first_init() for CPU A and got rstatc_pcpu->lnode of cgroup C
which was added by the IRQ/NMI updater.

Now imagine CPU B calling init_llist_node() on cgroup C's
rstatc_pcpu->lnode of CPU A and on CPU A, the process context updater
calling this_cpu_cmpxchg(rstatc_pcpu->lnode) concurrently.

The CMPXCNG without LOCK on CPU A is not safe and thus we need LOCK
prefix.

In Meta's fleet running the kernel with the commit 36df6e3dbd7e, we are
observing on some machines the memcg stats are getting skewed by more
than the actual memory on the system. On close inspection, we noticed
that lockless node for a workload for specific CPU was in the bad state
and thus all the updates on that CPU for that cgroup was being lost.

To confirm if this skew was indeed due to this CMPXCHG without LOCK in
css_rstat_updated(), we created a repro (using AI) at [1] which shows
that CMPXCHG without LOCK creates almost the same lnode corruption as
seem in Meta's fleet and with LOCK CMPXCHG the issue does not
reproduces.

Link: http://lore.kernel.org/efiagdwmzfwpdzps74fvcwq3n4cs36q33ij7eebcpssactv3zu@se4hqiwxcfxq [1]
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Fixes: 36df6e3dbd7e ("cgroup: make css_rstat_updated nmi safe")
---
Changes since v1:
- Updated the comments based on Tejun's feedback
- Added link to the reproducer
- Updated commit message
v1: http://lore.kernel.org/20251205022437.1743547-1-shakeel.butt@linux.dev

 kernel/cgroup/rstat.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 91b34ebd5370..3b4d71eec8b9 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -71,7 +71,6 @@ __bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
 {
 	struct llist_head *lhead;
 	struct css_rstat_cpu *rstatc;
-	struct css_rstat_cpu __percpu *rstatc_pcpu;
 	struct llist_node *self;
 
 	/*
@@ -104,18 +103,22 @@ __bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
 	/*
 	 * This function can be renentered by irqs and nmis for the same cgroup
 	 * and may try to insert the same per-cpu lnode into the llist. Note
-	 * that llist_add() does not protect against such scenarios.
+	 * that llist_add() does not protect against such scenarios. In addition
+	 * this same per-cpu lnode can be modified through init_llist_node()
+	 * from css_rstat_flush() running on a different CPU.
 	 *
 	 * To protect against such stacked contexts of irqs/nmis, we use the
 	 * fact that lnode points to itself when not on a list and then use
-	 * this_cpu_cmpxchg() to atomically set to NULL to select the winner
+	 * try_cmpxchg() to atomically set to NULL to select the winner
 	 * which will call llist_add(). The losers can assume the insertion is
 	 * successful and the winner will eventually add the per-cpu lnode to
 	 * the llist.
+	 *
+	 * Please note that we can not use this_cpu_cmpxchg() here as on some
+	 * archs it is not safe against modifications from multiple CPUs.
 	 */
 	self = &rstatc->lnode;
-	rstatc_pcpu = css->rstat_cpu;
-	if (this_cpu_cmpxchg(rstatc_pcpu->lnode.next, self, NULL) != self)
+	if (!try_cmpxchg(&rstatc->lnode.next, &self, NULL))
 		return;
 
 	lhead = ss_lhead_cpu(css->ss, cpu);
-- 
2.47.3


