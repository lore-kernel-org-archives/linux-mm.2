Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA37FEE4EF
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 14:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72656B0089; Sat, 28 Feb 2026 09:20:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29236B008A; Sat, 28 Feb 2026 09:20:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE026B008C; Sat, 28 Feb 2026 09:20:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6F86B0089
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 09:20:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 600028A89E
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 14:20:49 +0000 (UTC)
X-FDA: 84494076618.22.3F1F82D
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf03.hostedemail.com (Postfix) with ESMTP id A2C982000D
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 14:20:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CoTmr6uO;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772288447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mBR7DSPv0SQTUni7LYAlRsXlj4uQvQDqYNhgjcl//5E=;
	b=xKvovhkq3g1QE4uEvOyP/tFCOrKc8WEZdSGfj0xY162RTzQK1aRqF0XIJgRcNujz5FVQcz
	o7leRLqI263M+diRXDhXi9HDjYaqKqmCNd16QblOTX8gv88ABiJ6iHGHkRpSw5skNlf+XD
	pKowYqnAVRmL55Zt1AeVTuvsPS/B6ZU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772288447; a=rsa-sha256;
	cv=none;
	b=DAXP3iLsThJ/cziT0y7s8uguVV1nCS23mhFHDUs8/E4pKYoUfa/ghyD2Z2Vsy0xZ3KHhbN
	KkKsVoDTQTDPAGaNSA2ooPx2r+MKen+UtoM7J6VZ47uPUi5Ld0w4OXyKbeKWCtqZb2GvWV
	U+93sB1fV12zw5CsLEPwdYpA+SmCSfg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CoTmr6uO;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772288445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mBR7DSPv0SQTUni7LYAlRsXlj4uQvQDqYNhgjcl//5E=;
	b=CoTmr6uOZUtm/aSGvKdQHWKa+316V6kLKQ3lL9j/1AgwB07qO6ga1qSdBot1NMHwMCvzqI
	Nc8JlGKFJYpmR3QLBk0JvXCLav1konHLC2VKHKBodvXDu1asnQl0bmvbQawP4tOvijwRFz
	5XerhCSv6PraS2o22S9wCKt/q2MOwtE=
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
Subject: [PATCH 2/3] cgroup: add lockless fast-path checks to cgroup_file_notify()
Date: Sat, 28 Feb 2026 06:20:17 -0800
Message-ID: <20260228142018.3178529-3-shakeel.butt@linux.dev>
In-Reply-To: <20260228142018.3178529-1-shakeel.butt@linux.dev>
References: <20260228142018.3178529-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A2C982000D
X-Stat-Signature: xsdsxfz3gjyoqpptcyc89zkik5xnry8f
X-Rspam-User: 
X-HE-Tag: 1772288447-744470
X-HE-Meta: U2FsdGVkX1/3pcNlbcQ4L0RaaEgIFdyUfOGZ3JHb1qj0ljhiAELUdwZTy3hZnhn4gO36177rHUOZ40jgXUyyp6XbBjPBJQ3N4mkAkMfSJY1+yTtbZVdBmkcxusJFaDFBd/Z9joY3gufyUP/5ASvrnrAv82v9SDo7Lms+VGbue9buDoaMJRFD/RAGNadkMVkIymsTDsNRd2yy3kK2GMxBgfq7YfR/wFMCYugjVgM8a/lx8xTByRMfCAWKAwQpZI/rfRs6eNtURRXYEr5f81yDzWmmd/MpDtVWDS36rJ1IgGrNrHA5e+rDhLqU7gSj8jSfGZbT1sLGDpGE7zm4KkWgMU7hvv5vUVcGInDFtouGj6ZUfhronuyoKWLr+mlX5hEmnRkD3iaAODzkQsXOgGeU176dWOGQEZWj4FJDcAiEEwmGo8+6wVohRWBLFF8bhGFtvldkGk8GiaxQntEVrrb9vhVb4spSafdAfgUmLjHNfaD+S69AB6+jTzIlp8EP3kuhzJyQWPdwP9zkQKXnJnXj0LOSx11UA+IuhFVA5nG/22XlUI4JcAow6rno40OEYhQVtncTgnZYVsoNSDHLkl8hLuOPX0VpPNpNEobjSXlKn3o8g/1MbS7nUUVv842xm9WrfwHHA5vNT/0q2RK8JfmjfdHigeJ+bwnNfmDFNDT3wekYhK9s9l+pBwwnaUY4rWZXo+/8LhqEPKnSOsNCqPYk0WWX5syzKJwsVja9tMhNG8t5iiZam+WT5gxXxWy2GEnXTuGMDxBdMr3YlW902FIhcQq+JfWB+gjKojlYikt4RkZYcheaStty1Is0rnzuoAUbq5jcT7Kcm5ojcSSEbqHk6LXULahYReAHHGYQl9nenLp4PtEpg/z0KRx2PYYWrpDjoEKSiyNjwTSks5LG3YRKx7xDM6vjrQSEWwLoI//25dhmEKPRbSaR6hL58x0eK3sZILg0g25ynQxUvDJJhjw
 dx+bhZ7Y
 XzX63GE4JyYw6GQlR2gSay+HKbNd7+si4Ev6npAc6Tdf+tkvIUKm7c9Ij5STegoAVqiKgA1NhRycdPOLFwNqcOoUK5srItc35bWEmS/IY+KO3uCMKpbw/1YLD5CZP/9Ldfbqf0TnpFGefe8HsKiY8Xl2I4ypmCFOcM5amzsxjlZZGs7PdiKWoB0BNkKuEayPVdQgEgtC6kQ5hbpvO/FR8y9i2NydHSL3uSFvEhC7TdZtfZdOETDGXiJpCAJ8hQBxykZiOAhHOJAGEfJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add two lockless checks before acquiring the lock:

1. READ_ONCE(cfile->kn) NULL check to skip torn-down files.
2. READ_ONCE(cfile->notified_at) check to skip when within the
   rate-limit window (~10ms).

Both checks have safe error directions -- a stale read can only cause
unnecessary lock acquisition, never a missed notification.  Annotate
all write sites with WRITE_ONCE() to pair with the lockless readers.

The trade-off is that trailing timer_reduce() calls during bursts are
skipped, so the deferred notification that delivers the final state
may be lost.  This is acceptable for the primary callers like
__memcg_memory_event() where events keep arriving.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Jakub Kicinski <kuba@kernel.org>
---
 kernel/cgroup/cgroup.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 33282c7d71e4..5473ebd0f6c1 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1749,7 +1749,7 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 		struct cgroup_file *cfile = (void *)css + cft->file_offset;
 
 		spin_lock_irq(&cgroup_file_kn_lock);
-		cfile->kn = NULL;
+		WRITE_ONCE(cfile->kn, NULL);
 		spin_unlock_irq(&cgroup_file_kn_lock);
 
 		timer_delete_sync(&cfile->notify_timer);
@@ -4430,7 +4430,7 @@ static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
 		timer_setup(&cfile->notify_timer, cgroup_file_notify_timer, 0);
 
 		spin_lock_irq(&cgroup_file_kn_lock);
-		cfile->kn = kn;
+		WRITE_ONCE(cfile->kn, kn);
 		spin_unlock_irq(&cgroup_file_kn_lock);
 	}
 
@@ -4686,20 +4686,27 @@ int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
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
+	if (time_before_eq(jiffies, last + CGROUP_FILE_NOTIFY_MIN_INTV))
+		return;
+
 	spin_lock_irqsave(&cgroup_file_kn_lock, flags);
 	if (cfile->kn) {
-		unsigned long last = cfile->notified_at;
-		unsigned long next = last + CGROUP_FILE_NOTIFY_MIN_INTV;
+		last = cfile->notified_at;
+		next = last + CGROUP_FILE_NOTIFY_MIN_INTV;
 
-		if (time_in_range(jiffies, last, next)) {
+		if (time_before_eq(jiffies, next)) {
 			timer_reduce(&cfile->notify_timer, next);
 		} else {
 			kn = cfile->kn;
 			kernfs_get(kn);
-			cfile->notified_at = jiffies;
+			WRITE_ONCE(cfile->notified_at, jiffies);
 		}
 	}
 	spin_unlock_irqrestore(&cgroup_file_kn_lock, flags);
-- 
2.47.3


