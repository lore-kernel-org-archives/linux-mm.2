Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 624F6FEE4EF
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 14:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE7D6B0088; Sat, 28 Feb 2026 09:20:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B886B0089; Sat, 28 Feb 2026 09:20:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4886B008A; Sat, 28 Feb 2026 09:20:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0A66B0088
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 09:20:45 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC17A57880
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 14:20:44 +0000 (UTC)
X-FDA: 84494076408.24.6797683
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 48B6640003
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 14:20:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kdNYSrcW;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772288443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oaHUxVaobjs+nvwAKL/h30L1BqLPqcHDSgP0kHDwdc8=;
	b=Yf7vJzGY2FDeG3oTRgbywpMoHx71/nZs/GpL33a8e1gzgTgkqdglHQq1aDFsBsJgOzSdAx
	0w32fYZ8DsdjChKQaq3hpe8Fm84cPjNTmPyDXFyiVRLcekMnFugidbC2Sv4zi3KdkTtN2q
	Z2L2KA1VKdOku7LIJeZm0W9FLuF37bQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kdNYSrcW;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772288443; a=rsa-sha256;
	cv=none;
	b=8bBzx6ixsMqm+3gdXtrarNT+BfAKM+z7kFlYgggzheh9SjRquP9q0kYITTZfUX2Yf1f0P+
	KWGZ4vHrCJRKF/EKnUAJGOqTu8Y/JKzhwZe8tPPoXE83YNdWow72thmAP76HM1RyWkttM6
	gNx7A+oPV17rpk+Xxx+eHvtTab5E5po=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772288441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oaHUxVaobjs+nvwAKL/h30L1BqLPqcHDSgP0kHDwdc8=;
	b=kdNYSrcWgsufXjWGjib/VZy2Bqp1osTgP3+loYpCfqscJwNdtD8HlbRAcQzfLKQE3q16mx
	PE7HXXkmhnUgu4h9+jVLjjRtKRB67xXlWuOuk1KmufEOndo3fpYmiPIvPrwImoBx5Bg9CM
	SUGNO9XzYlFARce+XpR8oDn2vTDJVjI=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Daniel Sedlak <daniel.sedlak@cdn77.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/3] cgroup: reduce cgroup_file_kn_lock hold time in cgroup_file_notify()
Date: Sat, 28 Feb 2026 06:20:16 -0800
Message-ID: <20260228142018.3178529-2-shakeel.butt@linux.dev>
In-Reply-To: <20260228142018.3178529-1-shakeel.butt@linux.dev>
References: <20260228142018.3178529-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 48B6640003
X-Rspamd-Server: rspam08
X-Stat-Signature: g6gjfobxis8tstxkxsjrr6k7dd683bjh
X-HE-Tag: 1772288443-113041
X-HE-Meta: U2FsdGVkX18n1Qj2aOCN/UywfnG4T32KmXWO/+BOT/TpJUB7DD9yjzHdX+cBMy3WOqKgTAX9E4c9rlcnpaMFdpL8o4Ka5t7hVGPIRtypxCTN/34EX8UKjlbxqfJgHK7Ht71vske+nrt5mK13TQK3uI3tYL7XXEO1iBhgn8dJ7GkfZNsxYmrrWS4hnqV7NfmrvvPIRg6lFsMLo/SSGnkE2KwhHJsRYautwe30z7n7VSmsGpopTaWsShHEIe0il+h+RtRq3Mr2YjafnH6VsJAKshMoiFYjFHDCnt+aOEpy+olWwHa+fIGnKp1H3r1V3x2pi1kUnrOfZP4ZJjKyZd4d5usGU/9FusCBvanW/4ZGvEbx+oh9ErHHC53lS5s1hE9hymzKfqG7D3DilTfQRUynw97Q9xvDsUuckl0xBoKvS0kTAD9xNbR9/honLjcNbksvo1qNs81skbwVCnHVOh0JXWGZssK3lqRhnp7WBZZLMHiWG2AUvATAXiyqMrRDuNl+GZX2nGvXyDkHy+JviIogHcWUbc7Xer+jfE70IyWrtlrSdIUWzyTkRpG/sw46WdJvv/NqWdRzFmIASGPaZ+ZRBlPoKJIYGMHWucbIlrBMD4mkYG4K5oztHLKlIe45YU4EaUygXDHDHZwzn6adeMnM6v521rZP7VWWslAwLp8XLOrxJDPV7J2o6N8saBeyQBE1RyhKQrV5AUebkH+WeTofjniLhecTcg8CO7dvPqK/UvCXjPPitkQHDG0z3PCHK3FpXgAk23HUNQMZzxyICFU7ELRkoL2rST/6ryCq46EIqBoMa03xEweGQKkiOhzrVmNK5YWftIEuGFlx/98YzAMYJzOF8Jwk3nIMGth8XW3JCuedAtNPHXEKL5QoVFgB8dHtOJOld8atdos98ldZ9/D4BvMNuaYidvqhUxzI0wqKb8W+QL3c3RevwEQ4Y03ejMuCorDXnWlUUdQKeJJn6+w
 lZMy6AwR
 oSKjyiZZ+DR/PIdfnJVehz4o7ClqHbdOx8Enyjg8SfW8yjSyj0mlyDSjaN1RQZhL4RldAGDe8dW+doByr4fV4nOpaITRel5YFoksT57rPmXYNRWZoEnFSaYrw0TEIHykIdZaFlhpzh5tURAfjr9k2ty2lfi9HcZQXr9QWlW2aCM2riw5YVWh0QbtqRYNEBjGUnw/5zWWM+FJE8vMZ/GqnaCmjuMHQOI9VbLIvwQYScXu8z2exfdgdvKIzE6VWAm8o4kl5hWtKUwLhUtY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cgroup_file_notify() calls kernfs_notify() while holding the global
cgroup_file_kn_lock.  kernfs_notify() does non-trivial work including
wake_up_interruptible() and acquisition of a second global spinlock
(kernfs_notify_lock), inflating the hold time.

Take a kernfs_get() reference under the lock and call kernfs_notify()
after dropping it, following the pattern from cgroup_file_show().

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Jakub Kicinski <kuba@kernel.org>
---
 kernel/cgroup/cgroup.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index be1d71dda317..33282c7d71e4 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4687,6 +4687,7 @@ int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 void cgroup_file_notify(struct cgroup_file *cfile)
 {
 	unsigned long flags;
+	struct kernfs_node *kn = NULL;
 
 	spin_lock_irqsave(&cgroup_file_kn_lock, flags);
 	if (cfile->kn) {
@@ -4696,11 +4697,17 @@ void cgroup_file_notify(struct cgroup_file *cfile)
 		if (time_in_range(jiffies, last, next)) {
 			timer_reduce(&cfile->notify_timer, next);
 		} else {
-			kernfs_notify(cfile->kn);
+			kn = cfile->kn;
+			kernfs_get(kn);
 			cfile->notified_at = jiffies;
 		}
 	}
 	spin_unlock_irqrestore(&cgroup_file_kn_lock, flags);
+
+	if (kn) {
+		kernfs_notify(kn);
+		kernfs_put(kn);
+	}
 }
 EXPORT_SYMBOL_GPL(cgroup_file_notify);
 
-- 
2.47.3


