Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0C6ACD5BB1
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 16:58:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1F986B0099; Sun, 24 May 2026 12:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED09A6B009B; Sun, 24 May 2026 12:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98A86B009D; Sun, 24 May 2026 12:58:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C69D76B0099
	for <linux-mm@kvack.org>; Sun, 24 May 2026 12:58:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75765A0D3B
	for <linux-mm@kvack.org>; Sun, 24 May 2026 16:58:21 +0000 (UTC)
X-FDA: 84802921602.29.4953551
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 985E440003
	for <linux-mm@kvack.org>; Sun, 24 May 2026 16:58:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I/FFC7ML";
	spf=pass (imf11.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779641899; a=rsa-sha256;
	cv=none;
	b=D4slp3/Bd3tcRzhEnvm4zL36IplB4a0knOQfRz8BUBNLN7YUM1NgkPDlnllsyiQ7W5CuIH
	QDw5spjs4p7hiv38XTklMSvNRsYYjMUYuxNHlPCjDR2mBcyVWUiWqxsWVsHtiBCLCliQKV
	llcpMP9vr1aO0lO/nRI+y3DEPteCxNo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I/FFC7ML";
	spf=pass (imf11.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779641899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=XYbRs3tCnjBDML/yVXAZgXnRWFC9EoMypl12Py3Braw=;
	b=h31W+okSit93Ce/oF6e+T/Fz1nrqgRNf2G34+BnC0GV/cM0vND0IjEIv0tLg49/Vl68a68
	22B8gTF586mYLEwPN9vWTwQdNG3hQtbnAtvt2q6CFnuh0iqCobOo1VMb8f8Rmmg8FLf9y/
	JpOJlpJbZ7h2HcY8JgKmr6JqtmzLiW0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779641899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=XYbRs3tCnjBDML/yVXAZgXnRWFC9EoMypl12Py3Braw=;
	b=I/FFC7MLVdqs8ozszdr3vKKu44721gN7/t+UEXl2vMuM1zjOsw2b9fQst08e4G4iivnJN1
	u/E4EIrSRdCHPFOx+kcgd6F4FFN2C2fKGlU48uWkhy2QJr2qut3Ct+BX1PKT5J+3/LVtH8
	03NKSOoZOEcEYUznx0u2G4RaUngtMAE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-438-7I3IUvEbM8mkaBpGZEJI4A-1; Sun,
 24 May 2026 12:58:15 -0400
X-MC-Unique: 7I3IUvEbM8mkaBpGZEJI4A-1
X-Mimecast-MFC-AGG-ID: 7I3IUvEbM8mkaBpGZEJI4A_1779641893
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF71F180044D;
	Sun, 24 May 2026 16:58:12 +0000 (UTC)
Received: from fedora (unknown [10.44.48.14])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id CF0FE1685;
	Sun, 24 May 2026 16:58:07 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 24 May 2026 18:58:12 +0200 (CEST)
Date: Sun, 24 May 2026 18:58:06 +0200
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
Subject: [PATCH 2/4] mm/mempolicy: kernel_migrate_pages: use
 find_get_task_by_vpid()
Message-ID: <ahMuHiLJgStBo9_Q@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ahMt6xyUNnacZU8-@redhat.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: trJxj7p2umgwlP5DX9RLnfr8T9RDAqb3_Qc5FVQDZEA_1779641893
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 985E440003
X-Rspamd-Server: rspam03
X-Stat-Signature: wn4e3xijqaq1a6kro9gzp646bo48uxyg
X-HE-Tag: 1779641899-228085
X-HE-Meta: U2FsdGVkX1/gXwVDce//Z4OUgZAcWjIyDYiIPfQP17BcaDbZhWBliJk+T7FNU1b1yxbbW3LILh9gegW4+eRjqciDb2W2tyJGoi7B33eJSgP0WWetwV1XXsgThr37Dxm5jQy+AGyj2w3FxTLr86UaM1keJXVxegC9qrlcNEWmzb6J1dJEb7VkDyS/XGRwSkgnaeEb9I6ZguNXljsG3pH8u1QhHfdjalIp0EGR2WSH9RIPWfz+6DSezvEcdfplJuOY8brjZh6YPERJMKDS4cqAT2XXLiBziHpUzbaBBbxkurKEZhWQtty8aSlyBuz6ktt5pAN/ZeATW5K8XrlWOkv5jHR29cUSiYFH61rdSshU4dgQDOPXASs3UHichpkQOVSP4DzFL/ff4eZMCHe1I1qhcOnFlbn5q6H/XDFKSPtrqU3wPTtwT/FeR+LYqRF+lWdxfY7FszHKwlSGGJswWOHsNJPza1NMMbtg0OSHUIVSZZpjs+CTGprQpL5LWdYd2qs6Z+7VO1iHVsr2jD8GE/hPM35YHV6VbmcU9JjLp8HnoAoFc1Ontm+lpRjGEbCfSzifjhgxMKDoNn1G+hDU1YtcTEp2ZiN21p2bjuAwu4Zql7ozTUbjlUPCQrywWxp+DDTTuGuDS2LHST6iH2ipQMmCn7NIx3iEN8DuZOzvblXcjZoa9gnEiPhP9eze0svjgZ+GSZmxcNFyyF8KqDEfnnM63gE/sLt8A3OTFzcavJgZrd9iJg4MR2ZvTZeclp+NTIpavy11feOqAXYaTlEbP0Xgz23L3deglaDp6Y0Ra38hcNsMrqdpa9iNQoWENdeIV3KnBy5UfkgqaLwvByIx0DpD7U7CUwH8iKf8ig3Z9p7Bgspt15dY9jQjhcnPpG3fLbAKNJIT95Eaw/L3M1jQijulhb/ooSbgq2EtwFVcVWQk0kCA1qL8k64XeLHUm9eSoBuPZoLaz2VuOzV7J+vdP3O
 TRmXuWXv
 wwbWmyc3yO6jo5eAo8aZ2N/MOa/2GWjWRJ1DYn3KCJO/+uoDxdmfahlCb58VEVCi2ZL91pyH64/7i/rxiEjVpqxWyVDC4IXZA/Tfwx575Z74YDj7C7r8GdxLD0Vuoh3FbCOquBVcKWDRyYIQRXWWs4XNO//BpVq3Th6IupIjgZVy4q23AIHPgltl35iK5un/n5C+1/hSo4yZ4eo069/AfzkX4rk4AAzptT5zzDY13PkNgslcWj4Z9eg9fjgEBiyYB1cvMO9CUOCvXfd7N3BUfHw0vRfCHdi2Bt7hvMjX+f9GfUXSU+J/eIHJ3KqYv9XbgtbfbtiRT8Y+eTU4otA4iYTQeIkghGYmS7yQNN7mVhPxtV3Kx6CmkMpA/YvW+xWa8MPspedsIDG3Cj2azX+4WMwe++rGuZxDlFduKNnA1HmsbboN9xLOwCdiMo125om89wK+wmGNyq72aVb8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kernel_migrate_pages() calls ptrace_may_access() under rcu_read_lock() for
no reason. This is a leftover from before the commit 313674661925 ("Unify
migrate_pages and move_pages access checks"), where rcu_read_lock() was
needed to protect __task_cred(task).

So we can drop the RCU lock right after get_task_struct(). Better yet, if
pid != 0, we can use find_get_task_by_vpid() which does get_task_struct()
itself, and avoid get/put_task_struct() otherwise.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/mempolicy.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4326dff16aa6..2ec14001e4dc 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1883,15 +1883,11 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	if (err)
 		goto out;
 
-	/* Find the mm_struct */
-	rcu_read_lock();
-	task = pid ? find_task_by_vpid(pid) : current;
+	task = pid ? find_get_task_by_vpid(pid) : current;
 	if (!task) {
-		rcu_read_unlock();
 		err = -ESRCH;
 		goto out;
 	}
-	get_task_struct(task);
 
 	err = -EINVAL;
 
@@ -1900,11 +1896,9 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	 * Use the regular "ptrace_may_access()" checks.
 	 */
 	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
-		rcu_read_unlock();
 		err = -EPERM;
 		goto out_put;
 	}
-	rcu_read_unlock();
 
 	task_nodes = cpuset_mems_allowed(task);
 	/* Is the user allowed to access the target nodes? */
@@ -1932,7 +1926,8 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 
 	mmput(mm);
 out_put:
-	put_task_struct(task);
+	if (pid)
+		put_task_struct(task);
 out:
 	NODEMASK_SCRATCH_FREE(scratch);
 	return err;
-- 
2.52.0


