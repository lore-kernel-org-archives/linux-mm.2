Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4CB0CD5BAB
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 16:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24446B0096; Sun, 24 May 2026 12:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4DC6B0098; Sun, 24 May 2026 12:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11916B0099; Sun, 24 May 2026 12:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B07EB6B0096
	for <linux-mm@kvack.org>; Sun, 24 May 2026 12:58:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FB5212019C
	for <linux-mm@kvack.org>; Sun, 24 May 2026 16:58:17 +0000 (UTC)
X-FDA: 84802921434.04.C59936D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7091820007
	for <linux-mm@kvack.org>; Sun, 24 May 2026 16:58:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N3AR3VZS;
	spf=pass (imf31.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779641895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=uF5Ltar24PxhfK2RJK52qj/LVT6BFAvA6BDox8hw3ZE=;
	b=PXX5esfOu30QIPyYy72blHSOsFOt0SIC7hdR/4kaLKCEL6FhvXs5KVOObf4HFvmLVwPmiL
	73wNZt1Hbb0ZlxHTN8ujZL3XDkbfyi1lRRxc6WbapuCfEKzd8RAVqYug71aGWd2e1OTVZt
	UaqE1y8PVwCrdVqSMHugfPoc5ug1Ku8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N3AR3VZS;
	spf=pass (imf31.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779641895; a=rsa-sha256;
	cv=none;
	b=UxGLRRRH3P1DyTCF8USat//otcqcZPFjeQ+Qcvg8KqJTQ1wSsgfQNDugdt4AFQdy6DW4Gn
	pdM9+KYk7vGahh4Ab7+yt3BmtvQ5Q8i3bC0Boz2ULGzRKQfIXuYbCKk2isa18oQL89SZS4
	+ZrElrWuoI21tdlDN9lrLvIQmqZ4pcE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779641894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=uF5Ltar24PxhfK2RJK52qj/LVT6BFAvA6BDox8hw3ZE=;
	b=N3AR3VZSIRbyChHx1QhTvFeYpWD+fH1HoIvYOLDcfdt+1ialNby64uxFytBLcmSSm5FBuz
	oz1iO0RIAfL6o3mmsr/WHs0MKYL3A5ZnZLJc2309RUHbCinHCZ3N5i2GPrNz3fXH8lDd1M
	UpglhEMVQ5sgxmFtqMbwIqbYHT483ns=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-47-zju1gaudOq27gyZFRB49-w-1; Sun,
 24 May 2026 12:58:08 -0400
X-MC-Unique: zju1gaudOq27gyZFRB49-w-1
X-Mimecast-MFC-AGG-ID: zju1gaudOq27gyZFRB49-w_1779641886
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E01551956094;
	Sun, 24 May 2026 16:58:05 +0000 (UTC)
Received: from fedora (unknown [10.44.48.14])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id D8272300019F;
	Sun, 24 May 2026 16:58:00 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 24 May 2026 18:58:05 +0200 (CEST)
Date: Sun, 24 May 2026 18:57:59 +0200
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
Subject: [PATCH 1/4] mm/mempolicy: kernel_migrate_pages: simplify the usage
 of put_task_struct()
Message-ID: <ahMuF6FC6TIOZ-iZ@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ahMt6xyUNnacZU8-@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: zwJJrKBbofb43x60j7HtZHA0sDiPqb_Da41UvmG1tS0_1779641886
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7091820007
X-Stat-Signature: z4ia5xocofhuxwdskuhqohzhcko88ehr
X-HE-Tag: 1779641895-316345
X-HE-Meta: U2FsdGVkX1/TE0qE6fA1Dfiuybv5UnM3uqMhIVd1I9L45liky3sdbE8vZ4d0bLlhTZFZ/t8a5Sn85VX8V8WCrXZnmE7MeBxi3BVqauiPEQuM81mQXug70rpPUM3RZmSfSjhQClY9lgWZ6wvjm3kgBS0zbBJYX1vopqcov4D8zJBFhHbkGjxe7iMwaa6ERqPKsKwJ2e/LwBLZAzCNOLDxrdOfpd0MwDTRW5/hfrgD+wWEK/8hGSBUJu8cdeuwmbFTuS/cH8SsZ+3By5+xtYVO8g1kMoKzwm8hWtJC0I0/L0rlXCWMAZ8vga4b6e8eFnD8vdJUSsy4wgt/linF0pwUYZc/7KI/mfLKM5Wn9dhAzeSzaY0XgJ5VIdQXmxU5hpglrc2h1OsoaAVMH5VkoI3EHEmx1CBFgFpZkl4LIaUUtQn1hN9p1Qu6vPU2IRHR5AmZNTLJFrbLmciVv+LnZyVY9VfqnC0WbmGpaNEt5aZvPnJ2ZD6qPOJ+mHDWDQK4ffVjAehXDVmJ9oQ9xiQoIEybDq4cqEYt8GGTm9RZYYOWEBkBvRpjpsh8F+5YvfcWf0ZjB/+l1ZooeB/GRzfgob3gUCd9+CcwzyTdXhP1ncWjjVmiio5xfAvUWbTey4Gt2LWKCZRrCeBxs1rKvO2TYrUT5HGFDY+BOe6qbej8wzWNP6Zb+8OXwrvP7U51EpZ3Iy5JEgCYj51nCO7Ynrj66Yx2HaRHcmLjSW6qM1euZ9eyigeLN7EXiPU94ST4qmsO9NJDnWCfy6PZmPCAy429ZZbMNIzVt3YWmrAnlBRdradghvjYw+QcvQ4jDwQgbp08PI78OGijcGU0D78yrK+yQExDJNNAmtPYPiyegigPvr2vd2wak4ppgVqiwv4bY/KEmH3pIAVVc9aJomYquZ+em9wysts9UTHKLp/QVVfMaa7bnx2asVNHW+Gb5NludB+NZZNRiv2QGPQoZzvXP51SKJL
 6bOWhFe0
 2StJm4h9BGtMGvsiyyo1J/J5CGTo+dpa2olMMLfrQk4oJeGc2cBphb29oHtoLSeyXwvwyp/47YjPbB4IJi5RzwARrRmONpUFhsfFdZYtO7fCvQyy9VL8uyLUrvOSOz4sw9y8/rRODZsr0AmHM9VAJ94Zcj0I+hgiTS6m4IwRbMvCxKdhOVE6p/pC9Oibm1DQtKeySw29tzchgyQEB2VabDeUjX9LyrZ/P/ABqetlYMWPQacZZQUzPCYtwG47EnPL5GtFQXrCoyG4Z/UOfC0LefQE6Tuwr8JrlHGi+mQCkKu09FOjPPVVAanjqyjyjYTgy2+X/OsuPCX4+yySSFJRneCBwducG9EmnsNTzqhsXJQrONhe+ZvoZ9ETUbskkKfIRJ6qEHZI5JVi7+VQiotWKK56Z3xPCkvhB0QVIgpu8yQn9HIKdl6YLZvkjrRTmpwIehyvECMjmhsMPuIgZv6BBAbjD6g02m/eeUsahcCSTy/FJe1ErQPiKwisEMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kernel_migrate_pages() calls put_task_struct() twice; this complicates the
code. Move put_task_struct() to the unified exit path. This also allows us
to move the "out_put" label up and avoid another goto.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/mempolicy.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4e4421b22b59..4326dff16aa6 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1922,25 +1922,20 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 		goto out_put;
 
 	mm = get_task_mm(task);
-	put_task_struct(task);
-
 	if (!mm) {
 		err = -EINVAL;
-		goto out;
+		goto out_put;
 	}
 
 	err = do_migrate_pages(mm, old, new,
 		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
 
 	mmput(mm);
+out_put:
+	put_task_struct(task);
 out:
 	NODEMASK_SCRATCH_FREE(scratch);
-
 	return err;
-
-out_put:
-	put_task_struct(task);
-	goto out;
 }
 
 SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
-- 
2.52.0


