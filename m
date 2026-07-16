Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D05F5C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9616B00F3; Thu, 16 Jul 2026 10:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D15A6B00F5; Thu, 16 Jul 2026 10:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6CB6B00F6; Thu, 16 Jul 2026 10:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E55B76B00F3
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:54:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C0B5C019B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:36:35 +0000 (UTC)
X-FDA: 84994890750.06.B992B51
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5AC6E4000C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:36:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=MxkEnFl7;
	spf=pass (imf04.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212593;
	b=ZTmGdmrzCdG3sZ4Ho6HhK+z4qF3IoVeWg4X/aQA1Av1bXxFJvcZxuFILlEAbuzuFiablx5
	fUSZ+dpkBvN8fy3L7Uf8hOLmSE1qJ5sERykpH25+Tv0CGETr39ueg8Eh938GxMLjxoVtXN
	nDkwCZ3YCLtjZ+tHZh7+aT1MCcT24YU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=MxkEnFl7;
	spf=pass (imf04.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yb6Cwm/3woTUAoheO4z7KKKAu6lXR9oCBGtztGfVAug=;
	b=5JLwMANIAR5csARzZDRtsZ0lFM9knKBMH3n0M7J2zw/ggb4a+oKk8AL0iflN3n3CNnodj1
	Ca2j3iyK+6hdJPwRvCEwkQAvuh7aIJH0MhkMf9EKaQix1jakJj1dXzyzNBNoDwroQIwZOs
	itIAYYk7TOZ60do51PSR61wK7wXe8zc=
ARC-Seal: i=1; a=rsa-sha256; t=1784212403; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=dMV9ZN1HA5HIBvY4+WV4YpiNJFU3cvQjedrufXW1PYD+fjRhIzE1dZfMAM3bdTLIoKSMyAcGdOc8C1mbDETJORaIOoaiFXJsTJExVmYIdldJgYYgPJqW9xMAmz9H8VCR9beMpQXu2HapXvo9Ka38/rg++NrvrwsvKZ94HsrGPlw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212403; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=yb6Cwm/3woTUAoheO4z7KKKAu6lXR9oCBGtztGfVAug=; 
	b=cfYMuO7L2esHwoKyzWcFcEY0/CiF/Pq+Qv68PEy+L77nPyCCoulRNcQfY9Y086LvBx6Xemug3ccOfPEuKi/SdUJdiJFIKi7XxoO31q9fV8VtmoEaWMSJNwLGkuB9ckQwWSuPnCXy1pXRrYkAC7G/uQq2i5Bp/ZmLiYdDcRBJV7s=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212403;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=yb6Cwm/3woTUAoheO4z7KKKAu6lXR9oCBGtztGfVAug=;
	b=MxkEnFl7cfoArhzoENi4PknhrlsAuitJVyM04IyV0ygMcamDMbtLCiPRIyNRQoZY
	K0Q623GvfSSRvYsApqZ4muOcfMJSRvYdjMO04lveUVm1vCLLQHqtueHI6PYucgfKhwz
	IklWLzpodiO2DFjS+MApJH6Ofa/OyqiAGXs7O+jQ=
Received: by mx.zohomail.com with SMTPS id 1784212400577476.8024498506385;
	Thu, 16 Jul 2026 07:33:20 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 07/24] fork: expose vfork completion helper
Date: Thu, 16 Jul 2026 22:31:33 +0800
Message-ID: <daf1064397a3f3ccd11f65f07683edf493e4a435.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5AC6E4000C
X-Stat-Signature: qduj5di4w8d8aadprenihk8o6i55yk6o
X-HE-Tag: 1784212593-517817
X-HE-Meta: U2FsdGVkX19+ZWmvTB80SrxSlUBDrD2ZFMyPYmoEcXUYXufp4t75ZvtA5AGXkb0yXNgQr7OJXQg37XEHlp/PHPt6DmBtC2vQaczp1V3zOEiSMJ2SwW63fL5TQ48vD3JQ//pd304rVKieW85IRdIHnq/2rO/fK2E3r1RHmxlAfgUWMzsa0wTzoRuy5U8DupRE5V301DYUV9sDqfoI8GzxCuYt4rtaWEMQrtFtAF4HMwyg6J8EAAdhl4Hjg3/Gg2HGzd3xLzb7Ml8mMIxu+eu3v43COSIRy4Z9hn2/MXSSErHDkfOusVcDvyDbh0O8yFPluJD43rlMR9oiPgQFK3iZ8NA1sXiuo7DaZCGakB6yiNHL0oZs+7PtJs1Pf2pVzphKp55cGpujduHF2b411ikgr18J4Isy1Al30ND8r9ZE1fIvgAVMDnwC1QSOyvKTVqnmeVADiogW+MCusUEDck491xyeQDuLLs19hKcnvIVF9kxFDAipwXuZqCh5wEgpk6qvMG6KHH3Bfaa1f5pH9JCBM5Xmyvek1UqMFDtZb1wVSjP47LmSuX5Cn1VJFncdGRMQ1j4ml0h0X51p3fjpnfOB9GA8Btjxd3o52QrGk9Coaaoo76Q5XUU0Sn26bMTIyRQH8x89ZTJoJlBHWj9tIrwfTg/J8BmZzdlY2tWqcTlwfQAJyGGOQ0VmX3L7s4yOkiANkwMLqmau8gS5NOQweyZ6QFksiEovXPUbl3gi4344h4Gw8shoNz9ouK+SVtovjXVGvq6gMoqEkufAkyIM+pBerGHlXilHb4kwqKVz7tuoSajQmqy4N2rFgM6e+uUCNWBymDMUnPDG6pGZaUqpjhHsln/umf1EWbHm2P2FOfH6y1MS1fnaXiKDMZL86usyy1KSezhM/kBC6ukr55nzNQfD4tFESN9to9StJKJ9PvWTLya3LUvyjl7jPwNt54AChdeEAAMwQfKoEjD5kTfblYV
 p3lJhzFL
 Tf5oELDNG2r+PlQRPn8/w1/MBpXjaHxVlzPhPQoBWIyvSqCii9njRZ027s5DHZRDgq5ZiraqDNCPC0sAFrQJud5tHj4utnv6VggDRcuOjgUbhJj5MXcZ3qXSNpIKvXJpzZ8q4ABB2HwrbGPriernWLi75V3s9O2/1sXbye2sxgFfZcl4us8DoeLFXFJ02HsvK7B3GndFlk7Ro4JYKsBAVqQJ134Jqwj4mNtnfMzTYhexuPg8A05Pvsw6yww/AQxCUEJC402ShiNtbvLpVaVNSEnseIc9F62j3fPVcHwJ3EuZT5Wii4TVDM4y8z8f+aNi/dfMvHR8Q3iHDZjzxTbeZaAP9SQ8jiHmKcH6q/Qhmh5zwB3ujBD4N6DUTRIQmYfw4oHDc5SZfIXgvD//RdT9ZxNqZXbn09pJz3uJhmltdmAAWWLI1ukDGVYw7Ri5bbVEzY8uv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow process builders that call copy_process() directly to attach and
wait for the existing vfork completion without duplicating its signal
and task-reference handling.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 include/linux/sched/task.h | 3 +++
 kernel/fork.c              | 3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index e0c1ca8c6a188..92b4e3bc31e66 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -14,6 +14,7 @@
 
 struct task_struct;
 struct rusage;
+struct completion;
 union thread_union;
 struct css_set;
 
@@ -99,6 +100,8 @@ extern void exit_itimers(struct task_struct *);
 extern pid_t kernel_clone(struct kernel_clone_args *kargs);
 struct task_struct *copy_process(struct pid *pid, int trace, int node,
 				 struct kernel_clone_args *args);
+int wait_for_vfork_done(struct task_struct *child,
+			struct completion *vfork);
 struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node);
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, const char *name,
diff --git a/kernel/fork.c b/kernel/fork.c
index f3f378a85be4c..970810a01bbf6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1435,8 +1435,7 @@ static void complete_vfork_done(struct task_struct *tsk)
 	task_unlock(tsk);
 }
 
-static int wait_for_vfork_done(struct task_struct *child,
-				struct completion *vfork)
+int wait_for_vfork_done(struct task_struct *child, struct completion *vfork)
 {
 	unsigned int state = TASK_KILLABLE|TASK_FREEZABLE;
 	int killed;
-- 
2.52.0


