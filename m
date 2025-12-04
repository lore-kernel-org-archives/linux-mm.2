Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8A5FD2A53B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 21:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 180E76B00A1; Thu,  4 Dec 2025 16:06:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1580E6B00CD; Thu,  4 Dec 2025 16:06:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BCAB6B00CE; Thu,  4 Dec 2025 16:06:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F37466B00A1
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:06:16 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 828BBB7E35
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:06:16 +0000 (UTC)
X-FDA: 84183021552.16.7989678
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf04.hostedemail.com (Postfix) with ESMTP id C5EA04000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:06:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hFj7MC3a;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764882375; a=rsa-sha256;
	cv=none;
	b=0OWRlaezxXZUuZb3AULJcgfbhLI0AeG/iFNYbr6uBWLezJ3Ckv4Wo9qZt30q0Cn0mPocu4
	kaS/k2YtkDcOGO9EnFEixPFsnmMiFfbBG1D/SAmnmgkXJ/C4I3tmSppuMVwpyhRsrqeL2w
	UDZipXlAV9cBHMyK2jiScxDqVNsx+/E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hFj7MC3a;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764882375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0j67/z7yk6sd+zTCJWqAb0hXxvwGHY4UbGjl3Fe8flE=;
	b=hnQcxVfvmAvP+CWbjjAZAKQh9TZRzhppKFGqFM+A/gcPc+rSDikjHrta7SwVELTGScnakk
	8cJVLyTgeugRBW7en0wlbNH6lFvioB6H6Yq5+wyazla0qKIeT+/iK94aI64/CvLclwXA7K
	kh4iX6dOOS6MtZkDOQioflTQyNx8u7w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764882372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0j67/z7yk6sd+zTCJWqAb0hXxvwGHY4UbGjl3Fe8flE=;
	b=hFj7MC3acdifeWtieWAoehDskmNBka9rHl/IULh6FoUzZ2bguCTJGvcRwIEpH/QQSX2diQ
	vDXcEkK4kNkbUzv/LkdhjpAQ+wDyKI0VA2tjThW8vueIQBggN2ygIIlRDE/1CcdHsE/koT
	x0zbc2mtDlhvAOQRrdw6NHT1k0I+OtE=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH] cgroup: rstat: force flush on css exit
Date: Thu,  4 Dec 2025 13:06:00 -0800
Message-ID: <20251204210600.2899011-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C5EA04000A
X-Stat-Signature: ztk37dnt5qt4oa77hhmrbqqktjwdjoct
X-Rspam-User: 
X-HE-Tag: 1764882374-289447
X-HE-Meta: U2FsdGVkX1/tbujvS6myXfRXD2SBf3FYz7nq5TcdAKC7GP0PYt7ighnBrJElzbFY0BVhYdWm65JP7MNMzI+sJNzxRH2QFIB4/Z0H5QoK7e+3APFayARiZKXx4hJe1J2TppXwbNNcKaW2SZDExQGg3349ks/voM5j0RxgaNN9p6yl3FZi8p1B8uPx9RRbg8Dzz8d0aR52hrl+bEhbzEiYHflTWVyYQFy2FDmncRLh3OTxEADw2290u6wyHXSBJa2n3J+Jl8Oc4S0KG5Yl8eCUjSolO3xjeBk3JYUR1ygaHlc183mj5a5sRbokHG8Qjh2CGHECzIEUIH/BchsJQypdcvad1idwFqEW5dLVOu3dq4g0SRvZ22seTX33i7reSGCzdf1WlFEaOo8WEXzBZzoM9yYl+kHA2s52KNiFPbDfAWL3wglapz+XyGcxm2y0jTQ2aIqTPXVy+CFCa3zSYF1Nezn4ArntN2cB7rIAVLKKUzuWC+KrHXtRxmmqGzjin8n8bO+FRlvIZNjSX6Tqs1ikIc+Pzr9Xt4q1it/nPLSTtwsDznuwtpDF+OI1vwp+rvhkrWlYBV1TYy6LSnMQVsiotaMvt4wiTa1OZA7KKAOR1jDPoPol1N6QuhTEplzxJQk3nT3oVo/W8PKLwybkIdYXTYcMveadXwjNXnP80fvWRWhqcWs4X9jzEFYCJCRKuvtiIaaQJP3uSDJPHlnL3tF/Oy2dxUV7L0HxlUZYfkE2Vlhg8IxM7isKMiRg9RMaJcvMBmUqjsH8RB/voaaxi/V3KpTgxkRv4Zpfj7bZRmvq3/UG21HdpxrJ4QHG5EHR0EQKWQx9X+3ZwJSNzZjAQgIFF+3p+EcQfVJ4pqB3svjSe/mBzX46v9NF6IE1GMJu8wf9sFA5LYVJXu1p4yUGB9+v812050qsWGAjeKdP6SuSq6I3sOG7zucG3reoctC9d6uFQoyEcq6EkmgE5RPA9w/
 bPON9S6E
 qqkzHWfIDLxylK4ssST7SfzNPR6a9xzTp42sZBYEMbtQpNY9kZZX5OErKtv+iYZaeqeOgpWDMmDU9vPY06c4FrKoeZouLbN0BMEqHcT3oYFqZu4LUJReU2PMne9P/wuoH//q5OWPAPxqaoh4sUxKGkqW68KzRP44cl2kZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cuurently the rstat update side is lockless and transfers the css of
cgroup whose stats has been updated through lockless list (llist). There
is an expected race where rstat updater skips adding css to the llist
because it was already in the list but the flusher might not see those
updates done by the skipped updater.

Usually the subsequent updater will take care of such situation but what
if the skipped updater was the last updater before the cgroup is removed
by the user. In that case stat updates by the skipped updater will be
lost. To avoid that let's always flush the stats of the offlined cgroup.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Fixes: 36df6e3dbd7e ("cgroup: make css_rstat_updated nmi safe")
---
 kernel/cgroup/rstat.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index a198e40c799b..91b34ebd5370 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -283,6 +283,16 @@ static struct cgroup_subsys_state *css_rstat_updated_list(
 
 	css_process_update_tree(root->ss, cpu);
 
+	/*
+	 * We allow race between rstat updater and flusher which can cause a
+	 * scenario where the updater skips adding the css to the list but the
+	 * flusher might not see updater's updates. Usually the subsequent
+	 * updater would take care of that but what if that was the last updater
+	 * on that CPU before getting removed. Handle that scenario here.
+	 */
+	if (!css_is_online(root))
+		__css_process_update_tree(root, cpu);
+
 	/* Return NULL if this subtree is not on-list */
 	if (!rstatc->updated_next)
 		return NULL;
-- 
2.47.3


