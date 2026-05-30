Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EBDDCD6E49
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 14:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604B26B008A; Sat, 30 May 2026 10:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B50A6B0092; Sat, 30 May 2026 10:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1DF6B0093; Sat, 30 May 2026 10:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DF706B008A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 10:12:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA4C8A0363
	for <linux-mm@kvack.org>; Sat, 30 May 2026 14:12:46 +0000 (UTC)
X-FDA: 84824277132.10.F482BC2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9E2561C000A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 14:12:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IBH2a7TF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780150364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4T59/uglHamDOIexbZb00j6qdA4rH0lNQTHPsHuJ4ZE=;
	b=hybuLqLH48FVI/Fz6dOfgoWZrnkFMIKN2jXUHbXFg9ftoRq/uH+lVd8mlXRPJEX7AeoOIu
	KkJOl2yF38MBaTfos1QTSOWLJQtFF2k+PIo4NH/gXMT07A+heS/gt0pvRCbvtlilVTtCjq
	VHgAdaKu9c5pj1HONwR6cZmNCXNnZG4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IBH2a7TF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780150364; a=rsa-sha256;
	cv=none;
	b=SPH6B6ZBmM+3pf52vyiRVTLdVxNx9nPRqPSIb9fD+dGfSVjquvQpQ4RWIvhdJZnCcGFaY1
	Z50XOPDVQg1DQCiYK7xdzW2H2TXFsHMyTygfL8fXwy/w7975qOQ8XAPA15FAq8oUVeNjnQ
	dglCBBmehwzzICTbCUQv30J3gJNHkHE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780150364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4T59/uglHamDOIexbZb00j6qdA4rH0lNQTHPsHuJ4ZE=;
	b=IBH2a7TFmvT9wXyuzzTSn/vFVO2y+tp1tCqm1cui6IW1XXrPs6exl/lMJzNH0OFSRg4WkB
	kQ2Na/Vo79pu6NfvRv7yvgwYLBwgdKBOfyJuRztbO9VXYXNoL9SS9AEKyHa6Ng+HiiQ+M8
	TPM+Lw8xB6s7tYMn7RDxdcN94kzTwWw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-39-uhd7VoB3PmOUkdAVWvY-jQ-1; Sat,
 30 May 2026 10:12:39 -0400
X-MC-Unique: uhd7VoB3PmOUkdAVWvY-jQ-1
X-Mimecast-MFC-AGG-ID: uhd7VoB3PmOUkdAVWvY-jQ_1780150357
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B50518005B2;
	Sat, 30 May 2026 14:12:37 +0000 (UTC)
Received: from fedora (unknown [10.44.33.166])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 233321955F22;
	Sat, 30 May 2026 14:12:33 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sat, 30 May 2026 16:12:36 +0200 (CEST)
Date: Sat, 30 May 2026 16:12:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
	Kees Cook <kees@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] mm_access: simplify the security checks
Message-ID: <ahrwUGytgulEwujN@redhat.com>
References: <ahrsfJE3NkKjShEX@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ahrsfJE3NkKjShEX@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: vNZ6aFWx24IChQjd-clEJleOpONnoG7Zj5OsOz7XD6k_1780150357
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 46fdxeyub63hrs9ay6bn9xbcis1xqnn8
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9E2561C000A
X-Rspam-User: 
X-HE-Tag: 1780150364-196976
X-HE-Meta: U2FsdGVkX1/RpH91ouuex1wqE2Zj882Ymn6XrAlNWPI/uj1cERfOnlVPTXHOfSzBvD3Fal6aDK1PZ6TRzrYwG/girxpwlXPBl4z5TEfQ/egaewyw7ZjFMYuZSI4pc2WgeF5vZovMJtySOpM3iZLvyLDLUXi8PXZEGpZCk+g9PXFaoZtYARb5OMhljqCC8K4HQOXwyiJZcu8l5H27GOzjCpvya4eGaFCtJbgO/JSccYyIF71PR91VJAl5ia6gGK0br9kzanvOpQzcb02yw9I5HtKOxO7y0DWx+r8CZLnSw2nLpwNbJ6uwznBbogF/LyNWmDSdrrB6bRjCblT2bEoP3rDlLjyUPjEabh0JvvGqLE1/Ihu8Q8aMMTDZZkjifyA2DsZIPuHMWdWD5uxeXOv+matG+T/lb3kAr6mP/n5eOWFREDrW8AFfkdfUxU+8pJNDcxoVtxENMUS2dkE42RUz34xiWlis+KWwdpaYHdjLQQ328kqi+wEW554ZwuTuhzOYu65sdJDkNAsonEaqbVkt9+DLQ7PDzjzuFF9Y8/UTUHnBsfULSkv/vhzGehVevQld4U/3ZXqGVc/UCWHC02rKTQhoWW2InHZFTzuzDds/Rq/kVb1xRA1CNdM1V4E+pPoNNfRiJaFN7qPHOFI8ISZEiPg/+ZKI23ek47YZz06Ne9juS74rok3RqQJJ3VhwiqIH+H/epfw2yCgbZLWHHYOrLkf5QOatyzNLDvJ1vzyd0PSyzFtYeJ6kWit0kjvMMmukcPYh6YCepJX+2z/0dFfbLRPowUrcSXSC5mMLm2Acwi8S7yaTJq/+Gis2VIncT4RiTaLHxOxfUCmkVg8ezE8vH9YbllIliSl1F1lLa3G2uUj9yE2L6oKsDKiIRRt7OEAQxjwS70XjOCsa4duLRaJjC3f/VFynW0Lb2fbCqC+bwFdNefRNNPhLXYqRiYH+2lXqiwek0h+EtAS6ykRjRRZ
 v+BtKAbr
 p65QGkvsCoYfUkfVNWvowX5fjEeF4N7+tu87uZKIdGoam9J9vGOVnoPV2X4u9rAlGWJXKlIy6StN5+i6U4YDZYVhbalk+r7XB7E8oRpDR7Sn/tRBn5D4Ks74Zwx468jw9udTQSJQiIkW43gHuq++y0YdUbaX2pXFPhmhALRTQ9G5EoFTIHWXzwfyok//JTnK8kT5B2Mz3z6mkDpvKdWEjUzzDtlGZA5HEn1b5PErbDI6aYOj0iAqRuH2xdNFl4IusYoBMuXsZzADTLnzaHL0+kTCt+jCGKdTDAzRwdLxwMD/UUu6D4U5KcisOJnlKdxE7xWqMTMdhQzB3zH86be3Eipc2IeYKYQH7/Z6v9vnpZ8DZAMtFXunQ64/xqnFqU5XCblk7Uss+YKWmse7K5AJFhNBY1kJhJWGmmjkJdbaemRk9Wxw=
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



