Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55536FD88D4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 01:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940396B008A; Tue, 10 Mar 2026 21:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDC86B008C; Tue, 10 Mar 2026 21:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7386B0092; Tue, 10 Mar 2026 21:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3FA6B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 21:01:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00AD25911E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:01:15 +0000 (UTC)
X-FDA: 84531978552.04.18EB2B4
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3E652120013
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:01:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mENMEn6+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773190874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qk+QKL+WWCN38YTC4yYy3ziupLEe6KfdX1avXXt55Pw=;
	b=qbVXXVp9rEhlazH+wrg7IJ1F0n5DSE5cNt/dG5VDUd3hQ4o2BJu8Bw7ZZA1uO5hOnt8PKC
	Y3u8ofuhyOU8rm3ozFLFvsIpUL5CyVfELamiIWBskX7KjgeLmqOkYwef031RD/IpWwmxPN
	ISlNzWpIooCD7H1IIcs29cCbZ8XdAj4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773190874; a=rsa-sha256;
	cv=none;
	b=z+Q+PbfP+SoshmsTla0mzd4KsKmhTt6pygAIb9C6QEhBpXrb8rkq95YHT/CNZ8JlL/bQPw
	3UmnGMBgjMOw4GUnmw8lbyCVdnWE/FkAckb/UCJHvHEvjL6qUmHCpAo82WeQOY+ljE6ZRA
	D7wNCbPQeWZ4YqKwtoQESquZyljph7E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mENMEn6+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773190872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qk+QKL+WWCN38YTC4yYy3ziupLEe6KfdX1avXXt55Pw=;
	b=mENMEn6+BnsiU6XV1NWHpmL1SS60MUkAa0TYha8EuJ+HcpgFsTh3g3+yZWm2JbmUzTk60x
	5ZI+gQXEPI0d31SneW9hVgYfrQqPcyApjeizbDMb/HcJg1y90MgywSWKPH3aOHmYtdIuOp
	KI7aT5tKCeWCb35clfum+yD1/0FaEio=
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
Subject: [PATCH v2 1/3] cgroup: reduce cgroup_file_kn_lock hold time in cgroup_file_notify()
Date: Tue, 10 Mar 2026 18:00:59 -0700
Message-ID: <20260311010101.3306366-2-shakeel.butt@linux.dev>
In-Reply-To: <20260311010101.3306366-1-shakeel.butt@linux.dev>
References: <20260311010101.3306366-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3E652120013
X-Stat-Signature: db9oospaot9t1o8pfupuhp8j8h9zos7d
X-Rspam-User: 
X-HE-Tag: 1773190873-58797
X-HE-Meta: U2FsdGVkX1+o4p3NvgZrvC5GmB3MrZjcv5yj+6OkbscL8gR1dMAKf9+ZAXd8XFzAjnhmMyUtArQrDKZvM4o7EiVlw+5kLcTh+pfOZfIeo4VX3xQ5qSDHR0fW/0TnYeaMmzqCcdZReyYLjy/ZOQTJbaqy1pUnlIfo3unkp4kpPfG4vROnK+hAD9LIr4nniK9k0j2uzi4QzR93MZFP2lY4vIK/PKQmEaLHSnFNXUKGeY0OES0kKJ0Ll1GaaE3aVdhRGl8hx6QjDLCYlXootC8wN9KgVOF1KJXiEUornM5AoKDY09IzAv93R528CIHnOjbYSC1TBr7uqfkoi9Ie3aICoO7Pd52QqaawwrBraavX2enzAkz75oE+7uhxfQh+Ytx8X6+MgxUD+32LEg2cid35vCoNdPI+DUcSdxZB03Imbgl/fN5b7MAkVFNBXJxVHGWsiprW7JbwF0PkuIU1ObcjfdwY2iUJEN46LZk9pRwuCCYK4V5UYxhdh03wfudxLZymaRHhHd40t7nSgBa/fXtP1S6+Ml8Hva3AYrB+b+pX8ZkNUZEFwOQWyxC4cVzvjplvKkbrD2J3p/yKs1+7F4GrLVB/iOV5A3kjWl5fqE22y5wjxU3EBqFsGiVKVMwFb3CEyrs9T/GnIXeBkyB7YaM5pgYpmWZM3g3/2PU6czwjR6XclUZ1Jk3eDjimi6p8nQi3ooRwXAH6I5/37T+wN3+qCAM/cONaEBVtXZxRSvffyfCzfp9EWUDhJxHtMkdg9OPmKgGDBbAQWz3M8lKxR00rYM8mzacPxXlW5zZYWkS4VbrbDFfJULZly3NPtOpVt5tYUwX34x/a2FbTQNd86+iMEs5qWsbowCihAVXAsD1aWZSgiWG4AtzdttIcWvMd22p+U55q5KKwNkYWA/HqB+Vb9byDQNIT69GsX3Q4gql4fwgeH80V1kHsmUoYzB1x38eDFaiJ6pZ2EHbD/D5a+Tt
 ZOByMWVd
 cnyg2T0H3vTAztUiy3F8DKPlW/iEXBcAkv03NKuvTf8pv7QHVXQm5I6Y0ohgDOAb8bjm5ZWRhgb8l3yyX8IgBJvyMJuvyuHXD7Yq00YEKCeCVhJV84YQRs13+KsXYxQPrjXDYm846dtQdTkntn62cj2Cg2gyysr50V9LJovgJ221xUL+hBi4xtclXXB4cS62UEYKM0TtkGvU1XqdXSoGkNAS4u5MJuUc8GbiGqk+jWDYW4ICv5emubNY0CcueV6IOGE7A04a8uXXfIp4=
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

Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
Changes since v1:
- N/A

 kernel/cgroup/cgroup.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 7e99258e9090..b3fbeadb2b5a 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4686,6 +4686,7 @@ int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 void cgroup_file_notify(struct cgroup_file *cfile)
 {
 	unsigned long flags;
+	struct kernfs_node *kn = NULL;
 
 	spin_lock_irqsave(&cgroup_file_kn_lock, flags);
 	if (cfile->kn) {
@@ -4695,11 +4696,17 @@ void cgroup_file_notify(struct cgroup_file *cfile)
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
2.52.0


