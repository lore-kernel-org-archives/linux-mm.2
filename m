Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1106AFD88D4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 01:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61F486B008C; Tue, 10 Mar 2026 21:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AD3F6B0092; Tue, 10 Mar 2026 21:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DAAA6B0093; Tue, 10 Mar 2026 21:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40B096B008C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 21:01:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1994140491
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:01:18 +0000 (UTC)
X-FDA: 84531978636.16.5C15C1C
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1F5A81C001B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:01:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ccsx1/kW";
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773190877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ql30l3PkbeNcbzr2KL87n3zGyPvc/RHjLKkGfbTuIH0=;
	b=dMNmjc63ro1QHxHql8Fq7PebMNnN2gHIBGTDs+Oc41Wocez+5Ftn/8ifejJjmqIDjat/7X
	NpX1dFk/2i6HkNPESSwdjdrVn7YvSlqoCa9gvtsLbprI+NfJc0cHngQUzLwPThvIWlensH
	NHrJ57PtlfGNZdTXjLkGXHbnnUHNq68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773190877; a=rsa-sha256;
	cv=none;
	b=XfFUzT1Iqd9czEbnf4XHGNAsOdIc+fVvTtCD8MufJAsewcQL11GUWxU5xAOmtm5sI9t1ha
	iNxMopQOsOYwPVAyxOw47iBNIJevJB2e7ERPcoNlIGz2POHzqHUFtxnzFbuGVx3KdWU23N
	1dfPZU4peeoLEt4z0AI0knr+vcM5Scs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ccsx1/kW";
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773190875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ql30l3PkbeNcbzr2KL87n3zGyPvc/RHjLKkGfbTuIH0=;
	b=Ccsx1/kWEQE637Iz9fq15VANKbX+Sc52j5gJqkyyS8WiTnvG1rt0Nq26WNuowFqsaeVz5e
	TVv7q7ZfgqfBPvuvsPAIWVAO0My4sYJy6kLqoP5o/4+GC0kpOqROj3vc/aHkuK1lY3OYYT
	wOsJX6uvUs1m9KF6WlfWhSG4VIhvuQI=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] cgroup: add lockless fast-path checks to cgroup_file_notify()
Date: Tue, 10 Mar 2026 18:01:00 -0700
Message-ID: <20260311010101.3306366-3-shakeel.butt@linux.dev>
In-Reply-To: <20260311010101.3306366-1-shakeel.butt@linux.dev>
References: <20260311010101.3306366-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 3to9pdrwcosgrgu7f8map4mn4igmd374
X-Rspamd-Queue-Id: 1F5A81C001B
X-Rspamd-Server: rspam03
X-HE-Tag: 1773190876-5638
X-HE-Meta: U2FsdGVkX19ZEKoq5iDF+R3pveV6uUxP3o+JXk+uv38e/B56sYiEaVDZ1+5kEihnPZWkwPHDBdOJafqEzlfivlKBjDrDPfocNCGeL4JfhLqoApkIhekpK6s7i0Ddtm0+lelgFDv+QoV4V71pQygdjmZ9Kymsh2VmCOVwWrg7di9F3Pk0ynZoqR2ipMqlAmhlU0VQ8Ga7KFSW3SpwUXI2KbNmQjgvfQn8x0Ncl/GbA25pdxRSRkCdYesKuZ4SDSlmKFw+Fvm3FK06oQBjitwJmzRofAajQZk+T153ud+Ku7FpTfzBbtArfLgdPbNNSNi7zNDG5dxzKjT/ckjwMfugbdPJI3zZo7Rrs2Xk+xey5C+qYZkotxs8iTQevqRucHm5C0Pqqfdf+/Tvyu7XANzvWy/m7bqHF9j4IYxvDYjTevO9SGWavPP4xPcvHqpLOJODq/nigH6EEaGeBGl2Rjf2ois0Z1gj8Nr8jL7EEU5lKM52U9AUbvHHdxWhZaU+/jSULnWR8g3HymbfiC6zaOvg0Ej/Y3AakDDlEluli0kmdj6oYJo47ZfJH4IQPVvqG+6Trdv/d6yRSxrErU1ooccLM03fzKFwY7zGiiPPT/gNXcqJM6A2f4afaJcLTKzfXBe8KOwqXl7vaiQ3MhDdA75Wb0mffdpGCN62eAGsuk0E/86bI/gwjzRpcVzYl7QWSXdY222fsyyKkkYolB0NPB+xOvOEUmkGKnHsXYyNOJ5Yvpi1sYEf4wvP24h9FKcCtlCOw5Euh5V8Eo9d8sKGf7f1uCw7oKSdce5i5lCdVvMUUY3+TNonagVGIeWeaQGR24vE6WesincncGX416J1TgO1Mh5nn7naMJUybukNSQ9ZVwI2rHnjzYyCEuzzKZpEl7Hbb4aaTc/dfYHK37i+1Ycj2+E6kY06VcvANPBExc05MLT/bwJBctQD084q3T7YMeu/hIsI+9Eef+cu7pewAci
 OO87IScc
 osfTCG0AMQ69PdXTIemSpr80jCsOSTCzOYzyt7Y5UCdicikX60Jq42kuRHU4HJXm+VqNbiIgXkeb0V+vO4RPglopTTolagEj27EiD8dInTtQORmEpA1XQoVuWU9BC1QxdVzd575mqHy6wm8etTD8gEoFbXmfj8Jv6dwUh9JB8Mi63oe5jxXOrgRBAC7yJBqW5U4dJacftOosUotlaFeRilVgbvImSdu2+TZuGOqYMKLJ667EBiF3gka8TGCpKYXcmjrVGgGWFJ1WEzdk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add lockless checks before acquiring cgroup_file_kn_lock:

1. READ_ONCE(cfile->kn) NULL check to skip torn-down files.
2. READ_ONCE(cfile->notified_at) rate-limit check to skip when
   within the notification interval.  If within the interval, arm
   the deferred timer via timer_reduce() and confirm it is pending
   before returning -- if the timer fired in between, fall through
   to the lock path so the notification is not lost.

Both checks have safe error directions -- a stale read can only
cause unnecessary lock acquisition, never a missed notification.

The critical section is simplified to just taking a kernfs_get()
reference and updating notified_at.

Annotate cfile->kn and cfile->notified_at write sites with
WRITE_ONCE() to pair with the lockless readers.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
Changes since v1:
- Moves the timer arming and rate limiting out of lock.

 kernel/cgroup/cgroup.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b3fbeadb2b5a..b00f4c3242e0 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1749,7 +1749,7 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 		struct cgroup_file *cfile = (void *)css + cft->file_offset;
 
 		spin_lock_irq(&cgroup_file_kn_lock);
-		cfile->kn = NULL;
+		WRITE_ONCE(cfile->kn, NULL);
 		spin_unlock_irq(&cgroup_file_kn_lock);
 
 		timer_delete_sync(&cfile->notify_timer);
@@ -4429,7 +4429,7 @@ static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
 		timer_setup(&cfile->notify_timer, cgroup_file_notify_timer, 0);
 
 		spin_lock_irq(&cgroup_file_kn_lock);
-		cfile->kn = kn;
+		WRITE_ONCE(cfile->kn, kn);
 		spin_unlock_irq(&cgroup_file_kn_lock);
 	}
 
@@ -4685,21 +4685,25 @@ int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
  */
 void cgroup_file_notify(struct cgroup_file *cfile)
 {
-	unsigned long flags;
+	unsigned long flags, last, next;
 	struct kernfs_node *kn = NULL;
 
+	if (!READ_ONCE(cfile->kn))
+		return;
+
+	last = READ_ONCE(cfile->notified_at);
+	next = last + CGROUP_FILE_NOTIFY_MIN_INTV;
+	if (time_in_range(jiffies, last, next)) {
+		timer_reduce(&cfile->notify_timer, next);
+		if (timer_pending(&cfile->notify_timer))
+			return;
+	}
+
 	spin_lock_irqsave(&cgroup_file_kn_lock, flags);
 	if (cfile->kn) {
-		unsigned long last = cfile->notified_at;
-		unsigned long next = last + CGROUP_FILE_NOTIFY_MIN_INTV;
-
-		if (time_in_range(jiffies, last, next)) {
-			timer_reduce(&cfile->notify_timer, next);
-		} else {
-			kn = cfile->kn;
-			kernfs_get(kn);
-			cfile->notified_at = jiffies;
-		}
+		kn = cfile->kn;
+		kernfs_get(kn);
+		WRITE_ONCE(cfile->notified_at, jiffies);
 	}
 	spin_unlock_irqrestore(&cgroup_file_kn_lock, flags);
 
-- 
2.52.0


