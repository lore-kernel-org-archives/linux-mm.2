Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22AE3FD5323
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 12:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7872C6B0089; Fri, 27 Feb 2026 07:04:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730F16B008A; Fri, 27 Feb 2026 07:04:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657E66B008C; Fri, 27 Feb 2026 07:04:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0CD6B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:04:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7A0F59D06
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:04:37 +0000 (UTC)
X-FDA: 84490104594.18.AD090E9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id CA81C120012
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:04:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WqeLUTK6;
	spf=pass (imf29.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772193875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plHy0cfLp1i+DSy8czN2+D8yLtODRm8EVyinDnEIuz8=;
	b=2nmI9/xFJ22MtdhNltGdpJsU6bGxSNXhO9KiIgGu7R+/dRtL1vOqHffaZstKrz4pPbxE1b
	SamFy9IKFpRG7gqhzhQE5If1whbGo+0ewYYCH49Q4uJKxhCd5fy05ee8tuK1GYb1Uslwfe
	te2G3ukCIsFfkjzIVosGOjjxOaQGdWY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WqeLUTK6;
	spf=pass (imf29.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772193875; a=rsa-sha256;
	cv=none;
	b=E412rEwiT222zHACLwJA2u1eY0keqpErHpHEVeeCC0HgOJtt1RGG+XvlyhJenHFdQjjPk5
	g0Yy9l5qvlIE1P5J+Ht9i7SCimKIo6PcpPPIKOiZdRMp1vHTgLCj2BJxzYAtMHY/+7gTs0
	9AgtvzfpeuSdihKP7gU0ownhndzB22s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772193875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=plHy0cfLp1i+DSy8czN2+D8yLtODRm8EVyinDnEIuz8=;
	b=WqeLUTK6Qo61dLp7n2oMQWO7aZBDJHkFQ3m1MlilaDnRXa5eP3ZhG8co6WYRjV/pScbzZM
	d9uHEaRN3sGGXGE9OmrBLT5ow96iNWi8fWOzxNoMo+3qgGRkKjFE1BUmN96OkYuCgc8ayl
	nWw4E5MP/Afo7rmocYB2+RRDDeCc4Nk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-lo8R8uNsO2KZP-PjRD9s0g-1; Fri,
 27 Feb 2026 07:04:32 -0500
X-MC-Unique: lo8R8uNsO2KZP-PjRD9s0g-1
X-Mimecast-MFC-AGG-ID: lo8R8uNsO2KZP-PjRD9s0g_1772193869
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 319AD1956050;
	Fri, 27 Feb 2026 12:04:29 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id A3EF51956056;
	Fri, 27 Feb 2026 12:04:22 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 27 Feb 2026 13:04:28 +0100 (CET)
Date: Fri, 27 Feb 2026 13:04:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>, Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: [PATCH 2/2] pid: document the PIDNS_ADDING checks in alloc_pid() and
 copy_process()
Message-ID: <aaGIRElc78U4Er42@redhat.com>
References: <20260225133229.550302-1-ptikhomirov@virtuozzo.com>
 <aaGHu3ixbw9Y7kFj@redhat.com>
MIME-Version: 1.0
In-Reply-To: <aaGHu3ixbw9Y7kFj@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: AjOr9YcWieKR4vopUFLvMUf_rFZQjQHVytpZGhtEbdY_1772193869
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CA81C120012
X-Stat-Signature: jgj8bhyyepnhpatek537jwcykhe67mqr
X-HE-Tag: 1772193875-696911
X-HE-Meta: U2FsdGVkX187DJYBrM3epDxB8ySzFo7JiCpwlQ8PmJ+o8cZv4YQxLu+g41n4rIv3wFURkVM/2fZpahsNWHjidokJaN9ONHfh8WFXjYTU0QwjhWoCnKpAt1La+PEzXcsbCvvwiE/koTAibBsSB7dHwVI88afZmdh39ESCvEnE6NDVorWcImsHr1GU5n5gkb2gtxtecKTD25jcNYlUPVsD2sdCYjVyY8MGQJlZOGIO3S60JvMjkjjOJVkvMAq3QIll0ixKWG8wowd/tvugJ0G8EQFZpNA6Zxro3wA3/hOPZZUaHo6azggmsaAZ0m6ewuh9udabFEmumCsBJADr6G3047ImfXLwkFtcuu1LI5sC5ewXMuKWbpHrXMy8ArCJxA/3r3m5NgYcFsoq4P6X5LTTPd/1fTiCnvOXZVWi17bJSO/XbgnkUc/AMxDGHJ4LPjZ1gj68g+xLwjRiAjF/IpmxfUoIcNaZX3U2eNARRh9PFE8ctSCI270ZXzUqiP867DeXE1HJmrlJ4cdQdXgyPPPyS53FO//OM6Nzh/7U/9uzQKMjfV7rvLpallDzPqoVK7xAjUeH6YIfWVdi+G4C4YHjMqDyImywvuY+L8DzmUU8xEXL7wvNGtVLfQdTcq70fC3WnxJGwsFEpiQzLd0dc3hsLeKLUsSSYIKP0NUr55MbWc2BuDePuupjz3FHN34ck+dxZ3O7Xw+cVjCtt5vvsyLKTQprCoYcJmdfdbfwV7JKT2ytRilOz5yX/f9nnG1N74bMyLwDm2SABRIBnyUN0Lu9YzeII7xSL8i+OL9JSGCZa6szXUjmELmf3dEolG4XAEzuZPNtXQF6TbiVfbKaUJOaoU19E9gLMeywDCUt4Wrs7H112AewVWkCcGiYoORBNUQQayj9B0ovzSI2k/T1q2pwmwqC3qWNzxTim5rPu2kYSvKKOs9k0lpRgq8b+d7oo/YjVOvBPrklIGrB5HxqXoJ
 QtlQ2Xj/
 OHhpGjT8tqNL+E8chxFuR/ghnrOF2qgPwYOmTX0FmCL2f8UgErRdi4H4ize26IkO6rqx8NEBJw7VnZfXVkkc+2nzd+rppi/hKi+TKHo8DAtKLGjJWgYTVxUyJbogusR7n9q6+LLecBIwOHXIe5HyJbxyeDk+26/6geoGM/EpNlUYZYsrzkEkuUAkCSglLKpBnyRkXmKZ1V7r4+4tbSZumZDHy4q5AsW+UINax8HYNuudwjF+6Df17xQ9RL4IM2Voc512hVHE9WGyyXgN8PyhcEREJOTCOKlDs9c27wyy19iTBPewGm6a3UP+5A2aFWVPkWWmymH4rgRpP+lP3zzuJ3Iy/EGYhXYnuw+gJWF69dWZ99fefR6gw8ZaA9zSU8aRdLok0UFTKhLnmxsRUjbVFiTJyI/mv1pQ8ar8afB9lNXH9aYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both copy_process() and alloc_pid() do the same PIDNS_ADDING check.
The reasons for these checks, and the fact that both are necessary,
are not immediately obvious. Add the comments.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/fork.c | 6 +++++-
 kernel/pid.c  | 5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 544fe1b43d88..7cfa8addc080 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2392,7 +2392,11 @@ __latent_entropy struct task_struct *copy_process(
 
 	rseq_fork(p, clone_flags);
 
-	/* Don't start children in a dying pid namespace */
+	/*
+	 * If zap_pid_ns_processes() was called after alloc_pid(), the new
+	 * child missed SIGKILL.  If current is not in the same namespace,
+	 * we can't rely on fatal_signal_pending() below.
+	 */
 	if (unlikely(!(ns_of_pid(pid)->pid_allocated & PIDNS_ADDING))) {
 		retval = -ENOMEM;
 		goto bad_fork_core_free;
diff --git a/kernel/pid.c b/kernel/pid.c
index 1a0d2ac1f4a9..082a3c4a053f 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -317,6 +317,11 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 	 *
 	 * This can't be done earlier because we need to preserve other
 	 * error conditions.
+	 *
+	 * We need this even if copy_process() does the same check. If two
+	 * or more tasks from parent namespace try to inject a child into a
+	 * dead namespace, one of free_pid() calls from the copy_process()
+	 * error path may try to wakeup the possibly freed ns->child_reaper.
 	 */
 	retval = -ENOMEM;
 	if (unlikely(!(ns->pid_allocated & PIDNS_ADDING)))
-- 
2.52.0



