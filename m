Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3027D7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485BD6B0093; Sun, 25 Jan 2026 17:46:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467646B0095; Sun, 25 Jan 2026 17:46:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369A16B0096; Sun, 25 Jan 2026 17:46:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2571A6B0093
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:46:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F28F1140118
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:34 +0000 (UTC)
X-FDA: 84371971908.29.1262919
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 708B94000E
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NCo6OzUj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381193; a=rsa-sha256;
	cv=none;
	b=wMLsg1m5zL5XxKekPMBmWiT14mMdr4pANbdIBp+Ox1ieTjiH2aZkaIHJbvT6y+yCCWfthy
	JuAp9g773Qe2sfULMQr1YjTuRxcjZkIVcDwktGfReIuWiMCgMMs4I3Jiin/NcCqgAtR7kg
	ES5MlxfxYSvBJrdvMkCBfe348HkWduU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NCo6OzUj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0uYuDawIuSakwMNgLfCLy6eMUt5j4Ha9df3QbztFEQ=;
	b=Eoy59hneud4LxqyZkPlIjqYyDdqTIHebeUS9E8Zx1z4iRlg/tHWUo9TdK8dr+eShbAYp/d
	fn9WTeAJRG1GJw3ccv9sT+1hjJS6jf1XQdlIVAOZMxsAOF7W2na9Qs2rVN8eJxrPiTt98L
	LDoc59XEWSBs0BXW6I3Q/tt7Plpr/xw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EE34C6011E;
	Sun, 25 Jan 2026 22:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0DFC4CEF1;
	Sun, 25 Jan 2026 22:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381192;
	bh=JkXt23imzQZBGJmS8wrmieQIzrgOcUkUTqGUwsGlyvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCo6OzUj+5z3fShzlerTKOSi2VNbYcycL73l2Toam+tXKL7QepiGm0M5uE/Xi1HOh
	 w2+ws74ssU/HLOIjxZzVMs/CmT6qgAn9fIh96Bx+sDrWJI4jFGVdKg+lZv/O93VtnH
	 TDxUomhuOznH6kr8UuKgl6kN+9fdrwQuWAzEytGAQypm0VJUb07laV/4EqjL7tO7Ao
	 YllT0BwcdqB9VtbIAtFxxVD3VrldCqAofRvgCKc8w8Lj76cpGgjpsEpOAcAb/M/QoC
	 riI4/A8lGc+aQKBYnirPNe+usCyzAlKT4TFQLdhiP7FTQnsDCL4g1rcUJlBZBV16sl
	 H9KSW5ZtAXQ2Q==
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
Subject: [PATCH 05/33] sched/isolation: Save boot defined domain flags
Date: Sun, 25 Jan 2026 23:45:12 +0100
Message-ID: <20260125224541.50226-6-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 708B94000E
X-Stat-Signature: jz6r6fs3hrh1ubohdsn7sytorj4ky9fs
X-HE-Tag: 1769381193-130787
X-HE-Meta: U2FsdGVkX19g4jfCVRfhlR9qQPn2rcLdSKT+wleDvvVkdD2QrnuvyKkcPqDflopQC1k+0/B06Ei05VzKL9hvbVWBdMbmaOAI2qaw8slekaCZ4likFUIbVJcMvRmyRKukaJyRLF6eSVh/rQa+JrIwuctcWVmmo6Nx9qOjjSeMgrBoUpU3HI21mc3C2pvAjigRv1S/FMbunGfIkx3WyPwKPyk1ijN2XPG5a6XyXNBncIsz1NRAE8FVVhuhFVU1EIEqs/U2/hZlnzyZWgcb6V7XM665oix0IU0JZMDkMu/wJS5oOErltzF7/Hg2cVNQBHY0EipzOuDigCj+RBH6dtOFNtQuOuGwyMsQLez2T/V7foaEzwFH5A0V7JK2iHr1/3c6b8nFolRRlFGwZDwgfHi+muBosVOOE1yx2uMFNEOwpHJoLVFzwsShul1kNPNC2IUSJk00nn9/5zxkc47P3ygL3iqpcyn4b11Jc9eAtpzUDV7DB0NPv1+bqnBozdEYsUDcyS9TxkYtBHg9+MePBI8HoGLjfZRjfbTgKWIUnmYodtbu6SHrDI/cOUU9511vUcDfzDwv3GnzqobR5NANA2GxgKxC+uaxlY1qaPaXPaxARthRP3MFb5fXkOa1gyzWwODrlyrjpeEPU1kagoAdnBVCqIRPU7FuYaYvBopZ4ZMJVv50Vbi1GE6+VAlbYQkt9C8FrAgaroGEEg0qtH7rv07VPqzOoGPk9MQTtJnd0cLBp5jZfMm4MVmeuEIQspOPzAeL2+7LKgc/nokP4mv7rKgo+4HaS+MPHGUBYNo443ABdDs1oVzNdIti6XA802bEwLxnwhbLO9BmORl/Tr/GitshojKovVfycLWxE6UWdF7IN0ArZArVaX0fIlilOChg3sbj6ltxDoKSl7REA3LRiI2is2MgnDhyxS1WyDbZJvDBqe8i1EdwORV/PpPNDJxznhfSRBn7/L7rU5YPb59kCk4
 KLOz/Q6w
 /WOj981KxoeFn4Y5mcaTVaZdkhkaIBlhyPqpM9RXsMbje7ke4NArifg0ed/l9dsENO7Dlyx2MDQWaQlcDfIlOVe1L5gW+4pC89/xbvVi0CwnKRaBNHDqkLBCu3ddSKl3aiBKros5LIscs2K1RxQwVCsT6pVMdx9/hCqtwNHtBz6KeBllRtkW8GDfMGXsd/90ZtynYHCWTgedSo8Liky94BhpDJuMNhkfkHrh41hPm4ggOHNZlW0z3g7FVsWY7b3hmwbZpq6BxI8JxpWAnKVFjuTywILwVj/nDv6Ld
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HK_TYPE_DOMAIN will soon integrate not only boot defined isolcpus= CPUs
but also cpuset isolated partitions.

Housekeeping still needs a way to record what was initially passed
to isolcpus= in order to keep these CPUs isolated after a cpuset
isolated partition is modified or destroyed while containing some of
them.

Create a new HK_TYPE_DOMAIN_BOOT to keep track of those.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Reviewed-by: Waiman Long <longman@redhat.com>
---
 include/linux/sched/isolation.h | 4 ++++
 kernel/sched/isolation.c        | 5 +++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index d8501f4709b5..c7cf6934489c 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -7,8 +7,12 @@
 #include <linux/tick.h>
 
 enum hk_type {
+	/* Inverse of boot-time isolcpus= argument */
+	HK_TYPE_DOMAIN_BOOT,
 	HK_TYPE_DOMAIN,
+	/* Inverse of boot-time isolcpus=managed_irq argument */
 	HK_TYPE_MANAGED_IRQ,
+	/* Inverse of boot-time nohz_full= or isolcpus=nohz arguments */
 	HK_TYPE_KERNEL_NOISE,
 	HK_TYPE_MAX,
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 3ad0d6df6a0a..11a623fa6320 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -11,6 +11,7 @@
 #include "sched.h"
 
 enum hk_flags {
+	HK_FLAG_DOMAIN_BOOT	= BIT(HK_TYPE_DOMAIN_BOOT),
 	HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
 	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
 	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
@@ -239,7 +240,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
 
 		if (!strncmp(str, "domain,", 7)) {
 			str += 7;
-			flags |= HK_FLAG_DOMAIN;
+			flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
 			continue;
 		}
 
@@ -269,7 +270,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
 
 	/* Default behaviour for isolcpus without flags */
 	if (!flags)
-		flags |= HK_FLAG_DOMAIN;
+		flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
 
 	return housekeeping_setup(str, flags);
 }
-- 
2.51.1


