Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF36CCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FB536B00C6; Tue, 26 May 2026 10:42:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1F16B00CE; Tue, 26 May 2026 10:42:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210496B00CF; Tue, 26 May 2026 10:42:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 137E36B00C6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:42:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B6248E24C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:42:30 +0000 (UTC)
X-FDA: 84809836860.07.C1B5545
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 98CD0180010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:42:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cK7/m5wH";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779806548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Z6DGhUFUUW1v4/QYZY1KnUPM8YZLgV/Jg4ZMzLHbAgA=;
	b=pOg1T3itECGm5OFKRbBFjWFxQDYBNio+QRft23ZUxWGFm2Asx1MRGb9LUuEwgG2Dszj5ji
	KNqZ6JXgi3v8ATmlNPEB1XSOGFMbatKeM8iUYXdMMUJF+WlMnITP6/BR5r+hNrqkW8QfOI
	NR5+T+5qcCAobG/3CXMjPzlAK79U8QM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cK7/m5wH";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779806548; a=rsa-sha256;
	cv=none;
	b=jqWdCf+02hshPsthYauv70UaTWxe5+6UJ0AayyN3jNDflKYZbWjRQvE7Kth/pL40uYqTs/
	3wVzOgWpDjnE5k6nvz3P7VTwHWzme5xDZfXHcbQjcwmwstwdM4u6GxPIVOukBYXaOouOGb
	csmpxu9uzmXnt2VQYLd9k5+3oaX1t8Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779806548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Z6DGhUFUUW1v4/QYZY1KnUPM8YZLgV/Jg4ZMzLHbAgA=;
	b=cK7/m5wHi8n0dxinpMsKt0cr7eKuX/uTGTfrzmv/Y0JzcHrsTRfoLRlf/FrAGqWCkSazDk
	RYXcgHKFBLkimo+lZPeEc3bgLt+C3ak5z8Tpo3t1k0L7qo7pmkr0HpvcCgK8x8L8vITVd4
	L0oNUM/5pBaot2d5D5FBrAhE83bSe2E=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-1J2E5ENRMkSY9Ontjkx6nQ-1; Tue,
 26 May 2026 10:42:20 -0400
X-MC-Unique: 1J2E5ENRMkSY9Ontjkx6nQ-1
X-Mimecast-MFC-AGG-ID: 1J2E5ENRMkSY9Ontjkx6nQ_1779806538
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA5341800619;
	Tue, 26 May 2026 14:42:17 +0000 (UTC)
Received: from fedora (unknown [10.44.48.14])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id A5B60180034E;
	Tue, 26 May 2026 14:42:12 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 26 May 2026 16:42:17 +0200 (CEST)
Date: Tue, 26 May 2026 16:42:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>
Cc: Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/migrate: find_mm_struct: fix race between security checks
 and suid exec
Message-ID: <ahWxQ3JxdR5ff2qf@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: dNQ2n4ZNXnYEiZRoFkf49PCifIQdlKJlM--vY2Mxf9k_1779806538
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: jffnuokudecmo89i36q8uuqsbs4ne56u
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 98CD0180010
X-Rspam-User: 
X-HE-Tag: 1779806548-731100
X-HE-Meta: U2FsdGVkX19mRlPVwGEIpPc/7fWjMoSNYH8jniZQ+ZZopmd8Tnm83ROg9HUTrNB8uNt0BRp4etrs57t7O4NiFFNysSqZqrik4KPGRAs64oYzvmxYGPOh3hAL9YoaQ2YNusHdVOI2shffvhbLBXxQtizIxCRB10ERktfc3sEz+zpFARB5eHsA6zdWLMM/0GLLG0kjdmw/z6QnR2hSUoQSFy+JfLBO+bnMiJVGMqdUu3zPyD0U7dNqtk0dcI+lFZaIeENH34SmGHT70U1vDX9w/+h7MiDANDhfQJuapBG0FK7MC0fzvbN0b7B4IEnh/44ysLOk4AQypTgGuyHSaIBx8TckDEd+m3VqHy3ZQNyDF7UB1ln4ELC3JOqzeA4QCIy+R85zogYBb3N5ZLM1o1rVeopmw+8QgUQ+y5jnJFs0Y6BTIhk+V1/bE8mVSTdelN72nTk2v809cG0KSSxJIvce8jsd3tTFaStjY65Osy2vC/hl89YV83156b3bMD+mexmE7cS+UmoLEvGb/6i4+9UTiPur73g6cFnG+bGx3V1slPECww08tGRhQOnQjoU4Ghn3MIlTcSQC4+/PHW9PPb44Z8pLor6R+AUVUzUxDcJzxK00ZsPZS8VW8wiFEE4oLiBBIUedzHVugkRGqEtkgXITCf1vdQIM+r2NE6VBEWXD1FxhCFvAU9B3dhoY5slILe6QzhZ9pv6hsjrNgD37zpFklD2bO4cYLsujtqeyB+vhvoqKtMPmbv1gzUe1m0WHQLHMwvWZ2YBsL+fa6dhoMnixBvbFfCYtTXHQ6OtfO4t7Iiy0rF3ajIlTsY7vixpM+nHbH6Oj/30EHFmIM18U7JyC6xeCkfRMEg3ys/HsDFPS3oYB+e12CXk6dYDIpLjb5eqTv2l06JNsfPYARJhTIQ/GtQ6UQ2wGb1PBMBt/jpxqMBg6EQlaC+N2XVIpdYh2DhsUYqYBL5I4rqDKbEQ/LED
 ZGG0SCdE
 nfsuhKUbWGH6//sKUXdSzugFQoCz8l5LUczMI/Ph7i7UADaSFi2/G4iUE8ilcUaDGp4DMohMDYs1tdrHISiTTWmwDXDUi61CtHhjyqOomp67u3COWn3ISZ8nMSwRx3jx5k4ZOphP+ZQ8XUUd5trDTR8rtPvQ1F5xI+b8S7ts3qU0WvL1CnKRgOFpBGKnwMFAAsVOCHPhOv/OLFytudVr1G2jLX+WsZYaBH/Vs/EEyZWdMpQAOn8HM0zHaWgS41KBjkFHUCqHLTkEzlkWxBy4QZEhNrBKnUvOjjjeUQwUvn56rDT36syo2RpnnlyTWPDIZGmvzWbydtRxyFMZhJUJ/fYryB/pOwOMiofQOjGvDixLNuZ6VwaL8zkItxTp1fXsFepe2TarD1DOBfmS04Ga+ItAh+DXJstv+a0L8ZSI9XwicHRxXaMxaGJsY+RZrRKbj1vROCR/nItbVgsM8P0amb5wJoSxyfzOhjygGcFBCEXUFM8eMbeNmUMwquQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The target task can execute a setuid binary between ptrace_may_access()
and get_task_mm(). Protect this critical section with exec_update_lock.

I don't think cpuset_mems_allowed(task) should be called under
exec_update_lock, but this patch just tries to add the minimal fix.

Perhaps we can later add a common helper which can be used by
find_mm_struct() and kernel_migrate_pages().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/migrate.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 8a64291ab5b4..e4cf664fb161 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2557,24 +2557,29 @@ static struct mm_struct *find_mm_struct(pid_t pid, nodemask_t *mem_nodes)
 	}
 
 	task = find_get_task_by_vpid(pid);
-	if (!task) {
+	if (!task)
 		return ERR_PTR(-ESRCH);
-	}
 
+	if (down_read_killable(&task->signal->exec_update_lock)) {
+		mm = ERR_PTR(-EINTR);
+		goto out;
+	}
 	/*
 	 * Check if this process has the right to modify the specified
 	 * process. Use the regular "ptrace_may_access()" checks.
 	 */
 	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
 		mm = ERR_PTR(-EPERM);
-		goto out;
+		goto unlock;
 	}
 
 	mm = ERR_PTR(security_task_movememory(task));
 	if (IS_ERR(mm))
-		goto out;
+		goto unlock;
 	*mem_nodes = cpuset_mems_allowed(task);
 	mm = get_task_mm(task);
+unlock:
+	up_read(&task->signal->exec_update_lock);
 out:
 	put_task_struct(task);
 	if (!mm)
-- 
2.52.0



