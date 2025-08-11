Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C89BC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 06:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130AA6B0106; Mon, 11 Aug 2025 02:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1B96B0107; Mon, 11 Aug 2025 02:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01E176B0108; Mon, 11 Aug 2025 02:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA02B6B0106
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:46:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFBC8137A01
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:46:40 +0000 (UTC)
X-FDA: 83763543360.18.76233ED
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 382A640007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:46:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=bqHVpoX0;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf12.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754894799; a=rsa-sha256;
	cv=none;
	b=MKpyxnW9NATQQocZ3Y10ih8zgwO2Tt3FoamY+nEhz2SToyfNiRfL8qA5Co+cMw7WSPd1ru
	oqoy5dykzfwfU0YtB2BhIHHIctT1qlccDOXXQD13HMF33SYeU2jwjaISjNGAQpAKbkMHXU
	ByoEIvqljOZj/6QikS3MAlfhP3ssgyg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=bqHVpoX0;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf12.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754894799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JhBQCfWXGs3G3r8TkEW6sohCj/RBFaQuR4TU8IFeeZQ=;
	b=qJCRqRQqfGsQF+uPLJx9MBOkXRigy15LWDI0vAE5SRmOcd2YxzJmzSB0ssO/zQVgdTlOf0
	VEmS2jqHkd8Fcw5IrlPjlp+hohrOEX19u1MijO1PM079b0S6QTSvjCmTMlezWcDM6VXe7N
	5+NCOKqS5U71bRVkm2CrOmKQsWo7LKY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JhBQCfWXGs3G3r8TkEW6sohCj/RBFaQuR4TU8IFeeZQ=; b=bqHVpoX0CFjJdA0XjxgpcmPI/C
	WFMGInmi83uYPtBm65B72Q0msNgMnA6+J77c+yKJ3q3VHndYyVdOpBaLbp3dTyXZzH1KcZTnyNjV7
	y72ADIofsMLkA2kVjjVijOamXmdZuz4xIKDGym2GS9nu9esYZRUSySNSselGRlHpJ1KXAJOY6DB66
	me/84O7axpghwjoiDzQ6z2YXD+S+93OiQe+d9yPk8DpOo+kUS6gfArjoQehlAA1OYNK2XMu0xy59y
	Le7SmcIUt7AQie1E4fvhyPR0pUOpP3al3GIm+ZMPyLjLGRYltuFcN9PBCf+/tyJg7X2P+hsYS4Uaf
	aXdF12Tg==;
Received: from [223.233.69.163] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1ulMIg-00Cdun-Jd; Mon, 11 Aug 2025 08:46:31 +0200
From: Bhupesh <bhupesh@igalia.com>
To: akpm@linux-foundation.org
Cc: bhupesh@igalia.com,
	kernel-dev@igalia.com,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	oliver.sang@intel.com,
	lkp@intel.com,
	laoar.shao@gmail.com,
	pmladek@suse.com,
	rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com,
	arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com,
	andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl,
	peterz@infradead.org,
	willy@infradead.org,
	david@redhat.com,
	viro@zeniv.linux.org.uk,
	keescook@chromium.org,
	ebiederm@xmission.com,
	brauner@kernel.org,
	jack@suse.cz,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	linux-trace-kernel@vger.kernel.org,
	kees@kernel.org,
	torvalds@linux-foundation.org
Subject: [PATCH v7 1/4] exec: Remove obsolete comments
Date: Mon, 11 Aug 2025 12:16:06 +0530
Message-Id: <20250811064609.918593-2-bhupesh@igalia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20250811064609.918593-1-bhupesh@igalia.com>
References: <20250811064609.918593-1-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 382A640007
X-Stat-Signature: 9p9eucadx8sy9e8e3sn35uijeszx83sq
X-Rspam-User: 
X-HE-Tag: 1754894798-137500
X-HE-Meta: U2FsdGVkX19pu+zq6LTrejQEv7Sp1gbH1BtITMFvPCxc+qMTC7i1EWKNDJHGyAb4kC21s6jWC3lFjs/JD+ULKF7Efm9wU9ir/hQrbBAIlQUf3Emxyaiud9Y1VIYKzkB/xuZ/cu+w4It1SQEjNbxUyIZ2FgZBkcdjZ1NVI5850JUAN8OXSWM6khHWx9iNySZdbm2yvC62m3w66/qg4zxcASYnzDF4LYkzggZfW3Lw3+cd4Kyj8J5h/J/mAJE5pw5tsuJC2omKt8GBMfMzl/BD8E50oeebxUtRlXruGR4qKRPVoJ5yS2YDnFNZY3H0sOmC+7MstKDF7RoEg17bk5Mqjt/pqUhqYBj92D/uGOqwfMsN7Du82jty87TWjTMUGSzoPAXHEfnu4h0OL+8SFo3UZoJS3R+BrsyPv1D4IpITJhFpa73vau8G78g74S06ERlvlc4WPqB4cVRSyIA4IWPJ5GnKlnz1uH3P/G8R9iZSnYx8533S4IHA72LV8R1lJcPHCx74DUT101+vNGjAWF/wGd59mam8EPVcFPJTCMPPXoBa60LqpS20AfzNiWmNuIEvrgEUqV8whLFuHCKnclRNNpzEU9vJqckis8hQ6Ro6a55X2w4yPlM9x0iXPblwCVD3Bgb/1CyVOE87mzKmxYiQz2tF2VDXfE3o3JrdkgoM94dA+VI3ad8AHXN2gInlVdpe5OIE5hbRwn2JtVVTqYYpBXU7n7sw0HYKmGky1typuuPjcLurknqBI3cFsUNjs0LwDMmmqYX9vkMyaT7OIXj+pEoaMYRtjYZYj7WlGqn6u2pvvo3Gx0JN6O1LcxxEDQO4p+QMGUdvw6gqGzffDYaJMub7Iv3XYpTkfQvredP7gEZHBEoYFz0WnHl52Y43M45utoXaVBvYZJ7Q0FeS3M6v3pqVontQZiRkWUqrt0uBkwUtJhn5Ce+Ym022ahg7+ESXPpowBoH6KcTpFzjw4F6
 GJ7SBH8X
 gsy/MVJPGSZjUrpQYTZIJKzA7CuWZm9iBvqtW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 3a3f61ce5e0b ("exec: Make sure task->comm is always NUL-terminated"),
replaced 'strscpy_pad()' with 'memcpy()' implementations inside
'__set_task_comm()'.

However a few left-over comments are still there, which mention
the usage of 'strscpy_pad()' inside '__set_task_comm()'.

Remove those obsolete comments.

While at it, also remove an obsolete comment regarding 'task_lock()'
usage while handing 'task->comm'.

Signed-off-by: Bhupesh <bhupesh@igalia.com>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 include/linux/sched.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2b272382673d..35f1ef06eb6c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1159,10 +1159,8 @@ struct task_struct {
 	 *
 	 * - normally initialized begin_new_exec()
 	 * - set it with set_task_comm()
-	 *   - strscpy_pad() to ensure it is always NUL-terminated and
+	 *   - logic inside set_task_comm() will ensure it is always NUL-terminated and
 	 *     zero-padded
-	 *   - task_lock() to ensure the operation is atomic and the name is
-	 *     fully updated.
 	 */
 	char				comm[TASK_COMM_LEN];
 
@@ -1972,7 +1970,7 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
  *   User space can randomly change their names anyway, so locking for readers
  *   doesn't make sense. For writers, locking is probably necessary, as a race
  *   condition could lead to long-term mixed results.
- *   The strscpy_pad() in __set_task_comm() can ensure that the task comm is
+ *   The logic inside __set_task_comm() should ensure that the task comm is
  *   always NUL-terminated and zero-padded. Therefore the race condition between
  *   reader and writer is not an issue.
  *
-- 
2.38.1


