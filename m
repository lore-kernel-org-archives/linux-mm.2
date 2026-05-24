Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76945CD5BAB
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 16:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8CA96B009D; Sun, 24 May 2026 12:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64156B009E; Sun, 24 May 2026 12:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97A826B009F; Sun, 24 May 2026 12:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8163A6B009D
	for <linux-mm@kvack.org>; Sun, 24 May 2026 12:58:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17BEFC3B46
	for <linux-mm@kvack.org>; Sun, 24 May 2026 16:58:26 +0000 (UTC)
X-FDA: 84802921812.25.3315FE5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2AE75120008
	for <linux-mm@kvack.org>; Sun, 24 May 2026 16:58:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WixJszsk;
	spf=pass (imf29.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779641904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=yLFlGxdl4EO7bP4Z/X8AUVIY28BTwYFrCTa4X/x2wjA=;
	b=z4uQ+rYEimb4zpMx4YmWTyBBNhUNign5GEPCYyyB4O/ELbghOnUBcMihb/lXDOULeyloo7
	M0upQ4r3uLNy6VS6wUcGpU/MjK6KI++UcDfeyqLhPOrWla0dpkg3UqUiRd6S0sJw7pLzSE
	sisclQOr2QI8OkaUdeuHbw7GqR6DtM8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WixJszsk;
	spf=pass (imf29.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779641904; a=rsa-sha256;
	cv=none;
	b=NxFfqHZIYALEfUC4YzczU1Lv/HMgmKiuco6ihu/KxLWyUVjBB7gxXgMMWDj4WP4l66c6KM
	Q3elx+OslZd0kZQ/I/LmGSza9cvMPNMlC+KUYO3NpG8AUIkucKj7yV4OTmuRZ7WYBBN1yn
	jyUX77l85pKaepoDIn8fSeDiYKO4Unk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779641903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=yLFlGxdl4EO7bP4Z/X8AUVIY28BTwYFrCTa4X/x2wjA=;
	b=WixJszskSeEL45oRfrubDftlLQkz30N6wgRjNzNTkeOk7hBJRYRhk62QNvPUrc3QdD7msp
	ix5ymBQb5pYl9sgh/UBuBepCVwNuTtJ62z+kD/LV1sjAq7Pyi1PmyUrzAe8/R8Nzvg1d8B
	nl+Yxwj+S985UICss2+nZNC0TehKV+Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-201-j0TEpCOBM_asKwnPEo2EwA-1; Sun,
 24 May 2026 12:58:21 -0400
X-MC-Unique: j0TEpCOBM_asKwnPEo2EwA-1
X-Mimecast-MFC-AGG-ID: j0TEpCOBM_asKwnPEo2EwA_1779641899
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE02F180034A;
	Sun, 24 May 2026 16:58:19 +0000 (UTC)
Received: from fedora (unknown [10.44.48.14])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id C61E71800465;
	Sun, 24 May 2026 16:58:14 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 24 May 2026 18:58:19 +0200 (CEST)
Date: Sun, 24 May 2026 18:58:13 +0200
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
Subject: [PATCH 3/4] mm/mempolicy: kernel_migrate_pages: check
 ptrace_may_access() after nodes_and()
Message-ID: <ahMuJYliz1ioWpt4@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ahMt6xyUNnacZU8-@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: e8upyFNs3QnYd4KqxIPOnidWKSoinxcWzBgGTFDifQc_1779641899
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: f8836gdq4sf5okntmta4etxbxymdpsx4
X-Rspamd-Queue-Id: 2AE75120008
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779641903-221584
X-HE-Meta: U2FsdGVkX1/Z3hsR1NqVlCgMdaufTwsKxr6UouE7zCeHVfzhwWcfPnKtfo2314Y0FdGzVvEOHidKHpZmfLOYksFgkn6RTOc5FDFLKVZSg02oUMaofhjQSxXbxp6oVX/oqiAjDEonDNV6LDA/VoPsHbMY965DTI3S78P3x/eMUwqAzF2D4WICRlg9/Eov0v631McZUIF9swON5SkWDuUHT2P5UR368MAa5mv6lyQ/mtdyYKJ3kTgk0/7k0bxT0ryL3SGTELqNPXk3nMqnz8Qk8SEbf2N7O/8IG9hoPhSsyui1mDrLijZMrfOKyNeewmLyKYDMeAAUXRnDnFtnNXTGh0d9zxZEjrJrz9hcjY5pbHIsikHYhqR2GY73n3t4IqYEFVeu3JJnRmVT9XHnUJSOD2754q5JijlkIttLjuxVT6NEl3HOoGqChBoBg0REPX8FQTq7qGtkqwVAMJZ0uQFG+2+tE8xxTZpLwNeA/ylj0UHLnHXxcfHVIGu/IWXKj/r+J81rI8qsOFcOSozJNTafjPCPZlPB9+9Ky5TkL3eQ/aA4QCDSZkqkNbCGZPtkxx57yiGjaajkwG12Kwop12MFY/Ig4kKqcZr/AzJSAxFt9mXpumaXsjm8eJEf8470Qx1ZMhqL1BX9n5GaWbIiDx9r4DRuh2Q+HUP0lLisKwzDgdmivbJtTl4gmaAOFkNB5QuFWw/jDw+6vNwDYUN5G/K21uinz8f9bZAxmccOVJ1xCZK4VOgYz6Hz4Rn9kmtVNOGhe2T5a701s3GMCEQsesq8xYwVzql+Z5M62QfB5Fk4xMVhuVk1LctUXE+ig+nc0AX994uPbcgVN9V7kVOPNHIPaNju98V2P2Im2NhdV3Hl8S9wfLVQok9p0rOK3GbGV1c4dIfQ+TpXTwWIna7Mm5feOdKmGx82PWVdg7B/ArNQr9DN1FvhhEhwJ5iyuSjisuWS761X9ywAAPCxFar/XR6
 OdjvfuNj
 O5UlMnIKcNUTwvLBE1s8UCWOHkByIBFD/mo/m6AP0Y2U9uTFxdNsrHdHGCK202wk8CSUfOqqUgf6QpRMJvfiAIb07TmVFXPnvH6KxBSiDofJMly23apTsvfzgRKIQhMKpxGC8JetB0Q4NXB2uBZ3R7VmvRqsyCUIRvznu32T1RoexIdgJInWRbvDcFwmtJ7nUCif4yV3zQ4ekdy/bpdDaXghbgAK5u6tlwdV3ZMNsHG6Z06q5xoXLQJSJoXtaReORc7+6qPfyIFMBLSqFpFM2KHOoZqXTQNc0bt9P8ZN0cAwb15Tkpu9yUnPJXSUm8sEmfvhq6MHKBi8pGb4ran/b0QudWbPSHmrN9tR5yI5QBOhTRSThgpw3HrFTge79qoXfNbzRlT+vg28a6NE7cEKRRtqYCwTn9g9pNv5GWtE+EAetjh1xL/ggJm2iEleg0vV+Bt3f2bydv6zurDn/p8thja0j+fYueqfsoye0ANzEgY5rb+Vl2OGHukorVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the ptrace_may_access() check down, after the nodemask validation.
This is just a preparation to simplify the next patch.

Note that because of this reordering, if the caller passes an invalid
nodemask and also lacks permissions, the syscall will now return -EINVAL
instead of -EPERM. Hopefully, nobody relies on the old error precedence.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/mempolicy.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2ec14001e4dc..c09ff9f9aa96 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1889,17 +1889,6 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 		goto out;
 	}
 
-	err = -EINVAL;
-
-	/*
-	 * Check if this process has the right to modify the specified process.
-	 * Use the regular "ptrace_may_access()" checks.
-	 */
-	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
-		err = -EPERM;
-		goto out_put;
-	}
-
 	task_nodes = cpuset_mems_allowed(task);
 	/* Is the user allowed to access the target nodes? */
 	if (!nodes_subset(*new, task_nodes) && !capable(CAP_SYS_NICE)) {
@@ -1908,8 +1897,19 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	}
 
 	task_nodes = cpuset_mems_allowed(current);
-	if (!nodes_and(*new, *new, task_nodes))
+	if (!nodes_and(*new, *new, task_nodes)) {
+		err = -EINVAL;
 		goto out_put;
+	}
+
+	/*
+	 * Check if this process has the right to modify the specified process.
+	 * Use the regular "ptrace_may_access()" checks.
+	 */
+	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
+		err = -EPERM;
+		goto out_put;
+	}
 
 	err = security_task_movememory(task);
 	if (err)
-- 
2.52.0


