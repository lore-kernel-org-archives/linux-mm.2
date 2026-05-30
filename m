Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15622CD6E49
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 13:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4896B0005; Sat, 30 May 2026 09:56:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D656C6B0088; Sat, 30 May 2026 09:56:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7BB76B008A; Sat, 30 May 2026 09:56:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B82746B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 09:56:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE0B21C0543
	for <linux-mm@kvack.org>; Sat, 30 May 2026 13:56:25 +0000 (UTC)
X-FDA: 84824235930.21.46DF57B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id DEA09C0007
	for <linux-mm@kvack.org>; Sat, 30 May 2026 13:56:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HMcYHHFY;
	spf=pass (imf22.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780149384; a=rsa-sha256;
	cv=none;
	b=qPL6BvQaty6l0RE/GY5OZvwCJ5rCnWRJIOuXGobAaHfk8R0G90Tk4Og8e2hTQHo0eizUeG
	UGp39086UGCaEfCy+EVNQhQW04ygsx6++q1reHa3P0FKRWBr0LQd5+ftMmyoBiNn/U9TWD
	uwYmdy2etZHCprchjtuIzFMKkofjjuw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HMcYHHFY;
	spf=pass (imf22.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780149384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=d1QDNrMOnCS1pRlenvxiQnR9fsbomsqCG/uqIyCgmRI=;
	b=wKbz7tGtRgdlBUpbb45KrRGfKhDRdWe2jIFYO0zK35UXBc5gA1zXNn3lmtGZ8+9RIG4Kbe
	VdzoTpGK0qTMJO9Daq19SWGTQefS7lsiAss5GlsAOvEJaDXekzDctdZJzJ5NxIiAU2Ex32
	pWAPIZ5mizTse2w35b7WlUePUgd/P5E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780149383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=d1QDNrMOnCS1pRlenvxiQnR9fsbomsqCG/uqIyCgmRI=;
	b=HMcYHHFYyjOY7agRTyU2+5tUST4JIBh9SdvkSwfX4bZRnQ1y0jVAkAxnlAQJ+uGZ6M7DWP
	B0ujCW8pASXg0u7sn5g0VHT4EAhZ8P673dg935u9S2cdTR9ZSIXCcedKqD9WrhL6uNp90z
	m/5MFRo44YYeRhqfN8gnJv1JPVAPo2Q=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-495-3D9kpUZiPnSH64OjDespPw-1; Sat,
 30 May 2026 09:56:19 -0400
X-MC-Unique: 3D9kpUZiPnSH64OjDespPw-1
X-Mimecast-MFC-AGG-ID: 3D9kpUZiPnSH64OjDespPw_1780149377
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 60B0119560BA;
	Sat, 30 May 2026 13:56:17 +0000 (UTC)
Received: from fedora (unknown [10.44.33.166])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 11FEB1770;
	Sat, 30 May 2026 13:56:13 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sat, 30 May 2026 15:56:16 +0200 (CEST)
Date: Sat, 30 May 2026 15:56:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
	Kees Cook <kees@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm_access: simplify the security checks
Message-ID: <ahrsfJE3NkKjShEX@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: h8T8-I0ZjmWN0V4n2aHJZpXrG7RzWaZDUFsXL1sBmxc_1780149377
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: DEA09C0007
X-Rspamd-Server: rspam03
X-Stat-Signature: 4gjnmcfyd9fn98jrtnt5dt8uh4y5k9w8
X-HE-Tag: 1780149383-138428
X-HE-Meta: U2FsdGVkX1/uN/n3BHUpUvGbIhdcuUzz0WBNDmu12koCY/Xf0qeJuuqbxBocYtHI/cQY4LYzqAOesq56HHEztMwiuiUCDs9o1oIm40BYdEtVA0FSyJ5wQMPQuCFZoCE7BvqDh6vY5icZOElrmcUTH8KFAagIOZJXbZolTb9OBHbPQ3PpXtkg54Kdq/9CxtJrQsF4iGlR0XpCmf5Lzj8cRxTHw2npt6B1sU2cJKNm520zoOy7QqOaLHXeBHw7xDknLA6qQ+b3EYbq8x+7XU91M3qAEd7Oo4JKkQ0Cahk2S9fjcUJZrApntL8VtPeL4uSfi2mNGm24bZJ77FJwwIhJ2lVb9QAaTdH/C1DjSA3r8ClW07SrMejPl9BiXGNNhYSXmhNPzmIIlyg6daRhJhWpmgpxyVc3pt1Z07GEnGXfb/hXiggl7BX4bNUjnvm5qjVQNbKaI0ppVnQfxT9i+Te0unjudsFoP89N9PcKciSpdPBRugfSZnV2ubkpHJM4VyjqVBGeU/LwORBpqgpN38BFiGmCJc25lRj46SY2RlUcfTgcR9xAezIwfbbbTBuKBimnr4wRUxKjP1scrxALash6LK0I/5i+EwWKLAXmmSdCxR7rN5rRbvjJBUnkXoSuVAJQD/2yCTzuhyv0QG0EAJiCy1x2Sc+EwyK1t0mklrvaCJ3psC8VdjZbB6Hxj4Fx9ionP9bOjEHVXDYcbfFUC3JY39bQi8lbfRs+1VtPbxoDSOZhXcvBb3xbLBqEfJLQNHWFMTJ7Nr9nxXr7vOuGqovXhmkkML8iZ9AAjzt6qsL31rjSMBUnFIpP+xGHZU3E/NwSPUDqFKFFlT5K+Vclte1ugiQljoUng1IQzsgt9nzH4jjubHJJDk2mNazEOTuDqjgEJGYQyTSKt7vYk+OHmAZU4AQUlV9wlXvgJhJ4UvVzkBHV1c3CVJa7GYzlng85V3D6DUwYcyPHMD1ey9Yl2Ei
 8B12vpJP
 4vdTvOUDoyGalp5LHKEukc2mH6yRmDvO4H4eqcLasgqXjVMtE4NrP4aX2Tm8wuY/wotLwWyDDgf2qAzd4MZAM+OQZLkd1/xQf7yettPWzUd/bKHKr0nhhSBZpE7ap8WjQDSMs3GD+OH4Wzaf9qkkHv9jhVD7gN3c0rG0AOBGb+DChd3mQZRPEzBdSJLLqdd0Oo2E23IVO3VgZkm3UwiqQbHlPd62Y8EMdJjO0CVehLzBOmwxdLUP5HRKoZPkDGtctyI7TTv54XHtm1qs6dh6ToGTQgGKnc/Yc/C+L/XSbq2pzyfB2OxaFEIfM75o8VESOwvAd5ur3Oo24rhrL+NDX+0Ub+izSs+qWTfMHIi135JrDyfI0BMSSZiQbcwNM2cGwfnDdV6fpyYsKM1L/BE+LnrnXJ7rSiC+QB2jkdFXFdMrID+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

1. Shift the fast-path "mm == current->mm" check from may_access_mm()
   to mm_access(), and do it locklessly.

   task->mm is not stable but we do not care. We can race with exec,
   but in this case we pin/return current->mm. This doesn't differ
   from the case where the target execs after we drop exec_update_lock.

   All we need for correctness is READ_ONCE() to ensure the compiler
   won't reload task->mm. This is not enough for KCSAN, but we already
   have other lockless ->mm LOAD's. We should probably change exec_mmap/
   exit_mm to use WRITE_ONCE().

2. With the change above may_access_mm() doesn't need the "mm" argument,
   so we do not need to call get_task_mm() beforehand, we can call it
   only if may_access_mm() suceeds.

2. With the change above, may_access_mm() doesn't need the "mm" argument,
   so we do not need to call get_task_mm() beforehand. We can call it
   only if may_access_mm() succeeds.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/fork.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index b8b651abce8b..3239380ab93b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1381,10 +1381,8 @@ struct mm_struct *get_task_mm(struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(get_task_mm);
 
-static bool may_access_mm(struct mm_struct *mm, struct task_struct *task, unsigned int mode)
+static bool may_access_mm(struct task_struct *task, unsigned int mode)
 {
-	if (mm == current->mm)
-		return true;
 	if (ptrace_may_access(task, mode))
 		return true;
 	if ((mode & PTRACE_MODE_READ) && perfmon_capable())
@@ -1394,20 +1392,24 @@ static bool may_access_mm(struct mm_struct *mm, struct task_struct *task, unsign
 
 struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 {
-	struct mm_struct *mm;
-	int err;
+	struct mm_struct *mm = READ_ONCE(task->mm);
 
-	err =  down_read_killable(&task->signal->exec_update_lock);
-	if (err)
-		return ERR_PTR(err);
+	if (!mm || (task->flags & PF_KTHREAD))
+		return ERR_PTR(-ESRCH);
 
-	mm = get_task_mm(task);
-	if (!mm) {
-		mm = ERR_PTR(-ESRCH);
-	} else if (!may_access_mm(mm, task, mode)) {
-		mmput(mm);
-		mm = ERR_PTR(-EACCES);
+	if (mm == current->mm) {
+		mmget(mm);
+		return mm;
 	}
+
+	if (down_read_killable(&task->signal->exec_update_lock))
+		return ERR_PTR(-EINTR);
+
+	if (may_access_mm(task, mode))
+		mm = get_task_mm(task) ?: ERR_PTR(-ESRCH);
+	else
+		mm = ERR_PTR(-EACCES);
+
 	up_read(&task->signal->exec_update_lock);
 
 	return mm;
-- 
2.52.0



