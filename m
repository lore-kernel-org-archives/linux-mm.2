Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69ED1D7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D563C6B00A3; Sun, 25 Jan 2026 17:50:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D168D6B00C5; Sun, 25 Jan 2026 17:50:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C431E6B00C6; Sun, 25 Jan 2026 17:50:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7CED6B00A3
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:50:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84A38C2060
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:50:15 +0000 (UTC)
X-FDA: 84371981190.22.778BBF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id DA30A140005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:50:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PwIC4g98;
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArkG22qdZfeZQL1mg0jDVHZEGKaocQfpykvwK+7103I=;
	b=E72Wl1d2Jh4sgtD2dL6nqaFuwBLol+T4ayq27HOXvsJ5uO0yUycWOs6B1504TR2fd/IMgO
	xHF1oklXdYvBvYw6/lKOUtNFQuxCvuWZveM3V8SuTDYkczRDTsSgH3Bue8jEJDGw6SmfEk
	LbLdkUBTAMJGhgCXk+XPC7pCVBixsII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381414; a=rsa-sha256;
	cv=none;
	b=xZtKmQu3fE1TblVUCuBVyTyWV5jGBDOdgWYMxvDd8zh8Y2Fe5E71XE1I83h5ojheJ+eBvr
	tXrQ6SxjRgsTazdX3hDtvKPR7wgv8d1HfhEmue74lc5Lm4SLIUW010jA112Zl0XNHXMdiW
	zQ0eHt7HdOOVwaY/qK66tXfto16suXE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PwIC4g98;
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FBFB41A67;
	Sun, 25 Jan 2026 22:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120E4C19425;
	Sun, 25 Jan 2026 22:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381413;
	bh=kluxsGzh3yUyBuEdMQW2ChyzrN9Wa4B73tu4Iho0QMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwIC4g988r+B+FQPa2FGhJt4tSrnNd2nr3Tz4JrNby9d+xw96kD0fCjntTLY1+H1n
	 uXxDNbXKSPe2PPZHG2MkM8KfxPUVZcHV22WrAGuzzmO872gdpB+rEYMVaPF9zDiHeA
	 4DAVOo0ZX1apu66trrhs8xQp/0u1Hpi6J1VWvFy9lMGJMwfhvoSf3REVbWUSMv1fy3
	 w9NNX6yNDqcaFM+CfcvB1OrCkCSjmfni8NhXoeV3iRN0cEMtFRoxEHfQHvq7WzyJd8
	 2Ta3I7sXvWD+IW/l3nN7TVys5aR+iJcCHXKGctB2PGpo2OIwb6AJNGfhBRwGPUwOXV
	 m2Z/opj23gBYw==
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
Subject: [PATCH 32/33] kthread: Document kthread_affine_preferred()
Date: Sun, 25 Jan 2026 23:45:39 +0100
Message-ID: <20260125224541.50226-33-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DA30A140005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: w8pisknduirqhxuohp6a3hsi6g56yec7
X-HE-Tag: 1769381413-613518
X-HE-Meta: U2FsdGVkX1/L3o4bgqkZt1aOi9Zw+tGT/xrOOx/7StjJtQFjJEpV6HGmM3QNOaHcZCOPfSgTyHE1XO8zoKpeQQbkT7Eu6d45fafTyUMQmQOFaBvWZ4srZrg9jlON585VYybhtXQCZsfKqupuvPPphKod3w/e9sWQKG4OPlsJYGy3mVSE4gcXt206QgFAW13ZCRA3umippVEQoUbdw0I721iV14lSFpLRfdcEobhi3ioNz5OsfOebN2PJ+egQvM7PuRSUSksnYH/h67+cZSWOvMtPrq8Hpkzm5acZtLRI8TcoUWuxDXDAaF8/JXjapaj2tp/lSIi4TElcFyEaOFhvYZYVZW3L/C2da8CIDHbXZ4Ti+q0hlIp0sXQCsWzQP53f90Ri6tB17xiFiWLmxIKt1U68/yWbtGlvSp26fKB/AETdimsFmo5++vaX1E9D7DFolX/ZrMyszQ76OqE4E1xxlbrKJCUUxWfHGdoK1kGfpMlsuvEJM2Hl77YJVrnvnAIznDNHZmeXD5nwHEFbmVa5BFV3J5k78EiKzbmwvD3Pglpek29K7HMcQ4Klx3Mif0EA0twN4QHAI7CoZzIGCVbVRu+GsahQUYxhaqvzrO/Ile7ItTlN6y5dHgN/oV+fw8nJKwlr7+YKMsYAz9gzTlQANXQP4Hoqz8/z+eE2Ld/zzJf7DGPGM0t/LgmXTfrPcqMBoVUGfdx+vztIAUr+e0FEjgnmuLrZAZaUgtzRDHFGXtIx0+myzidomoZ6fra68T3p0zMOzpA3nVby1e7lAjnvzavaO/a+1DWWmD41bmuWC0hU/v7jnLdB5LisfZY4C2jixVsk5tgeYRAdp/QH2ZUJWtvjDLc66OkbtxPw47Ma5FJ6f04Gg+WvQ1hc69NYAVzvc0Vg+X8JU8wIQghbsad8jfN+fapQmiRSJgg7iY8pzqMqSWCzcbWCyP1wKnhW5E9HhbbQa71Bk0lNNAJY3N4
 ln+CBrKZ
 1cG6Ff7gHbDBVNdIo4XEQw+8BE/xOWxzBHe9BOxSJ0m5l+HcONnTkBnlfi+XA9OB2t+ayZ8/JPF8l05TJpu/ttjntIhTbzcBrN6efo5zt3dv91uAdFuapfpnSw3hoJFfA1U0PPA9Peh8pvqMzy6U85cmBz3wOeD+IvNqX0n/Kiqz4TV5y7w/yMBwLDskL3do0qp4vDdDpvjtw7oQ3Tm+hL+54GdBYOI1d1MdjtPXzmr0vT28q6Kmt3WozXhHAoSL4LsZazpx2MCD24vddhJQokLUlIVL2f7da62UoWqaq87LPfTIOqrQ0/pf08jEqs0rf3Rib
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The documentation of this new API has been overlooked during its
introduction. Fill the gap.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/kthread.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 51f419139dea..c50f4c0eabfe 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -856,6 +856,18 @@ int kthreadd(void *unused)
 	return 0;
 }
 
+/**
+ * kthread_affine_preferred - Define a kthread's preferred affinity
+ * @p: thread created by kthread_create().
+ * @mask: preferred mask of CPUs (might not be online, must be possible) for @p
+ *        to run on.
+ *
+ * Similar to kthread_bind_mask() except that the affinity is not a requirement
+ * but rather a preference that can be constrained by CPU isolation or CPU hotplug.
+ * Must be called before the first wakeup of the kthread.
+ *
+ * Returns 0 if the affinity has been applied.
+ */
 int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
 {
 	struct kthread *kthread = to_kthread(p);
-- 
2.51.1


