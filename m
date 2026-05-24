Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32673CD5BAB
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 16:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97B3D6B009E; Sun, 24 May 2026 12:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952D36B009F; Sun, 24 May 2026 12:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869536B00A0; Sun, 24 May 2026 12:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 772556B009E
	for <linux-mm@kvack.org>; Sun, 24 May 2026 12:58:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E94F1C2388
	for <linux-mm@kvack.org>; Sun, 24 May 2026 16:58:35 +0000 (UTC)
X-FDA: 84802922190.24.C47FFF2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 34DF54000E
	for <linux-mm@kvack.org>; Sun, 24 May 2026 16:58:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Hblewz4U;
	spf=pass (imf07.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779641913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=fx9P0XwhXW7SmBYCB2M08iDg2xYh5gHDBQzMHIVQsRI=;
	b=OqBflm2V9wyfu9uj36Ylc5kl/R/gL10Ayvwhb5MthOk1u2bJwk97eegyAl7Zg55KdkcC/a
	FWCMfTply8pVbG3NEc4MXmibvpJZmvI8CdWnITKUnB6MRpB91SwDtoLdvYaFS2znGhHep/
	pC32HhdtxslsxYzJA2PCkISYgYYhwrU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Hblewz4U;
	spf=pass (imf07.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779641913; a=rsa-sha256;
	cv=none;
	b=m+4XglmE+rqZVRNhcZCkwOcdQl2artDb1FOIAicUJHlRLH+c0r0MD4eogNEUTcy77Rj6RM
	/3ExZaQidIEAFEUMDsVOGYopL8d665orEle6erHEBLpf8Yo+nwrpVI8iNc/FXVxsa1jn35
	UqumDxY2YxyNG9L09dqatOM/ZPbyQfs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779641912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=fx9P0XwhXW7SmBYCB2M08iDg2xYh5gHDBQzMHIVQsRI=;
	b=Hblewz4UOKYZcksJanDR0yWMUMmXbczTyBKKhsiuSbFg4swGsdvNMiW/TV9eQotvzU993i
	OG3ERsmGutsnIzIg6wQFb0rKYS2ahFXIxyyEFIw7wGM94m23qnOEm/w2qday0hasLGQ7gM
	nVXO8tH5fB52yPLKJn798IJQjO2m6Ko=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-80-SAQWZFcuOPSreD9kou7wRA-1; Sun,
 24 May 2026 12:58:29 -0400
X-MC-Unique: SAQWZFcuOPSreD9kou7wRA-1
X-Mimecast-MFC-AGG-ID: SAQWZFcuOPSreD9kou7wRA_1779641907
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C661419560A1;
	Sun, 24 May 2026 16:58:26 +0000 (UTC)
Received: from fedora (unknown [10.44.48.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id BE6D119560A3;
	Sun, 24 May 2026 16:58:21 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 24 May 2026 18:58:26 +0200 (CEST)
Date: Sun, 24 May 2026 18:58:20 +0200
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
Subject: [PATCH 4/4] mm/mempolicy: kernel_migrate_pages: fix race between
 security checks and suid exec
Message-ID: <ahMuLN2Foxpgx8ZM@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ahMt6xyUNnacZU8-@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: fJi8gmAdrgZN3wa33Knf_P-zW2D5kd3bM7vVgDMgwg0_1779641907
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: yq3f9h6ax7z8aon51yqz379zg856yroa
X-Rspamd-Queue-Id: 34DF54000E
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779641913-695531
X-HE-Meta: U2FsdGVkX1+zxP0WrdGbmJispS+GUnxwaJC54uOCaLBwpNVvD7cK4O4jaOcAP+41Kmh3Zb0l7j4x8G8FM7H21UnuxeT78q4uN75GU1VxAmcJ+59F+D7VIFjaRUgQiHkLY9JLI1rxvyIzyXIS0n+bNnpi31csTN67Y/nBaFY2qGQYE0ZtwL0XREhbalX6ReeV0iY6DSHV9+WRtBpdKyYjVdgJdw3EbkgpZ99DsXRaL/bbLbVw0gWh90qooYCVERARUytu4/KpumuSki30VaRbWomWQ7hn2OqGa9A+3LLor7ZYCwziRnjWUORZmT43C3wnkJ2Gyo0dI3xyYO2THzHd8FjzgAQZaj+q9VTVSsdnkrPaq42IgDIoko5MQFF4bi4Viz/Ktb+TH+vYBi7hrZV7EwX+P/c5vpcPtMa03i/zInB9phQ0D6PiFn4+pTUL5V0q2H57z94X5723w341NNeLU2oJO+Ei/hl/dBJBUaqTXpf8dteJiC+N4apPfXOruAh9WpY//+kA5xohgcDAOJ2/qYxBacoIAj7bNTz3aFJd3q2D8Xr5wUuRFL53SRc2bdVdyjq0fmaQYro2U9nucV6lJtIpXDU7IJLYuVhaI+8B5byFNlhe4YVSmUdT2ngGmv55Nl2yz0JAIlmeqwHollxhFCdaYbsqzjCSIU2NdAN/nLFv/bcRB79oQ+/Uvdpjo0Hn7Biq7Me36sOQxMIHEMZbJ6TDeFbzXsR6mtHk0QZlmao5TufgwItntqIU2L0Xdxg2xvIaypGV4Hj1PD6gdqg8nfBGNB4iOQ9FygZkpgMV5aPf7qSbLnqcHyd3v3Gp0f3SIhaHFMS5UtmttunfvzXdCUwKRvFI6L3V1OzG2npWvfy6LBegm6ts1NOLYHXB3/TVA59Km9A0U7slqblM9VmmkiII+uwLfezRstmlaS1eRVKsFPjqoxmkhBGzDaKu2eB68iA6lQX2GY55zKqIyH1
 9bqo+G6f
 FcpkjFRVhCmQd7VE4yCeZot39/hxv9F3C50plWsHnoayQhoFFTTPOdHdCLFLXXQBBFfgpSfwYzMHqHOL2VYPB10YIhJjvyCdS2lvjuOSQ4JQQWlI3rbWcEevSx67BYlII8u0eqPeeX9js9uxaLy+5Xr9XW/cW31QqHTLeM23ruG2rKtFnibAYDJ7Guki60UVC/UnMAjMtV9uU0VV0xfMfSVMeTF2zsNkuYO9skpYaF/sEMOCJexfI1dJ0Ogzt10K9boH1ty53lFitjEWvjgNt4oRFi+9MKA8RYqcbeSX+v/6XW+Y6+sWRzp0d2BxlEYA1L6bNoIgVY9gMn0IK/Ykmmn7fuPZw6ZbUNQish+CZRNy/heS5ypH+3aYpPL7MG8MiOgscMJbaR9qsigsGpDbJx6F7rI+7dMqSxa2/TVA4C9xrvqhj6bDGNmG6k/2CkcYpL3ZaCkNl5WE1HY+j2RfewRAy1a0J/ocXhQCe3btYedDvjE/yUWl93pyJ9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The target task can execute a setuid binary between ptrace_may_access()
and get_task_mm(). Protect this critical section with exec_update_lock.

Sadly, we don't have DEFINE_LOCK_GUARD_1_COND(rwsem_read, _kill) yet.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/mempolicy.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index c09ff9f9aa96..cbb45a876a93 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1902,24 +1902,31 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 		goto out_put;
 	}
 
+	err = down_read_killable(&task->signal->exec_update_lock);
+	if (err)
+		goto out_put;
 	/*
 	 * Check if this process has the right to modify the specified process.
 	 * Use the regular "ptrace_may_access()" checks.
 	 */
 	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
 		err = -EPERM;
-		goto out_put;
+		goto unlock;
 	}
 
 	err = security_task_movememory(task);
 	if (err)
-		goto out_put;
+		goto unlock;
 
 	mm = get_task_mm(task);
 	if (!mm) {
 		err = -EINVAL;
-		goto out_put;
+		goto unlock;
 	}
+unlock:
+	up_read(&task->signal->exec_update_lock);
+	if (err)
+		goto out_put;
 
 	err = do_migrate_pages(mm, old, new,
 		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
-- 
2.52.0


