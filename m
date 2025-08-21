Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A143CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 10:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3C7B6B00D0; Thu, 21 Aug 2025 06:22:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA006B00D3; Thu, 21 Aug 2025 06:22:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9FEA6B00D1; Thu, 21 Aug 2025 06:22:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 966BB6B00D0
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:22:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4ABBF1A035B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:22:16 +0000 (UTC)
X-FDA: 83800374672.13.726BE2C
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6919340006
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:22:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=rKsiUYA8;
	spf=pass (imf11.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755771734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRAnHsOfkqVGryjONqmeYxIHoj1DfmYgpmMCpMPPlBQ=;
	b=R6/gVG1KOY2Fp33lmCefxPO0vFw6QTj45AT/7ocEcJNXZ+vVO6dpNEC6a9Uc1vvASJajFb
	f/3WXeJD+sZ1HTelrAe+a+trrlZ995Q50qUgiwucIKRtF49+HrVHi4NHv+M0aAt5qUlt+J
	a4/u+ClY5nBQc+rXILV0SHPrXCY9hpo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755771734; a=rsa-sha256;
	cv=none;
	b=Wc+j2Wqtku4vVLuEkaACW0vM8YNmRg6oO+cnz6e7Gt+TlhkmANj9NuK3jTxnd2RMY5Iupx
	EcM4vYGbNURWuUC7MM6EFlN4niVPHCcYXusAY7WGixcJwqrHIw+hTlpPaVznpq1BMlBO3k
	DtWIWzDlG+9N6ATO4YQ448SyyNEx+Sg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=rKsiUYA8;
	spf=pass (imf11.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zRAnHsOfkqVGryjONqmeYxIHoj1DfmYgpmMCpMPPlBQ=; b=rKsiUYA89wVGH3IG3P4L0TkD8B
	QhQhniq0xN2HodgjgeZ4GWESucqR9nCGc7TtiMk+wB8/Vyn7tZURFFXWZAMaqFixBOHWq5B2rFb6p
	z7wQxtSUXI1hxOPoy2Q1gFCA5qShbEFPdVmqOvNe3z0FoAuIYmfszhyqKMdJuMM0bzULyNYCK1u/U
	Arllm3Dd23QW780w1B8/oBSauPtNb1YAJB+ISdlMYEMPOq5bLFnJJ79Gu7pzyTL60Lswpd0XNusJy
	fpLijRYQp5Kgx2eycxatNBjbwMdOp9VisPFG29G6HY3C/NHebb6synSOrDscGUXrOvyPfIe07jPiv
	OC8vLlAg==;
Received: from [223.233.68.152] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1up2Qq-00HBmV-4T; Thu, 21 Aug 2025 12:22:08 +0200
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
Subject: [PATCH v8 1/5] exec: Remove obsolete comments
Date: Thu, 21 Aug 2025 15:51:48 +0530
Message-Id: <20250821102152.323367-2-bhupesh@igalia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20250821102152.323367-1-bhupesh@igalia.com>
References: <20250821102152.323367-1-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6919340006
X-Stat-Signature: 4a958cf9ggahk865borigd6zqncxo5qx
X-HE-Tag: 1755771734-567526
X-HE-Meta: U2FsdGVkX18jUfeohTqsxR6VXUVdl/5DxzNp5TNDo9TGA4ujODT8QXU4dGjSiOt5qekUEYwpQHZDYM5RkFhCMuLljwhbvXfAn83A+O57CsB6ZLw8li2bwaD73IOPQLUcsrvSAZjFppPXeIzgLIO/u+HvCrwSI9DUdKJoRNI5S76UJ0yJVdVoxbNdVtkRsJNd+93nZ6O0dilYMwHwE5wNQscBDfxn26nwGzj3F10AaXnWw/gzNM2+n2aSSMqnBpV7pvzX9BvA3l8+CQU1VJX2ta8PWqwA/NdbIgeGLL6mESIAQQcvPjZY8hhVnD5Tuf5hKo6NWl7YsPnlj3hm4bXQVuS+a+Wego5jjpP6hmzUDrgziHV+1PpH2XBoQzFqJHoijjFbNn4uhdorXGH5USfgEImdgVzZeqzlLcqjL6KTT2r9JpK6i+7JwRBTNSAxTSYhatsn5/RANpqz62rcRdEhwejaP56hy/A0L/rtD6jmg6b7MfZX/C939OTmZPhi9XZfszAvXy1nNWWCSuolYLWQoYwO9Qo0w+PTn8Ai9s4VBw5BW8PkXioYrSSCkIN5CSspS5YoUARMLLfc+NI9TTPeN8sxJNOXv6Rc2loBW+XjxvxCCJPewjR8AHO1mxKBXpv9J/rhzE4cwHndVZlaaxVy21oFsPkLzVvHMKdVryOBdMZ1KCRUEKNfhoTJA/sOxPVZ+F/FZ2uEPE3SSXLtYIXVVcnQxOKFM01l1OPWi7eCHjoLIdcTEmUuGuPRgvjv916RqZnDhwQtXpU/d6zuLvE++Qxe+Nner9FhxuhPI/homkwNj734FN8GKcibuCpP/qDcaq9sHdElmxba4DJ2jKjzovXoHLYXAiH7tcGJbtXzR2HJt0Hwo2v/mQ8Wrs4LVH4GugqrhEcAwROKi/ts6TFklikJd1mb5NcgwEGDDTrmbmVKNAghMETCS6TKQOaD609hN2idiyP1yOWYzNLGjx5
 gniDxzVn
 fSsVNNCrRtEV0Gf3PSD1Yd+M792b2BKDZDDwUMlMPNVHAK+1FWcpX0gAIGK7JFSfmP0zgUKZ86MI9+3LXbCzQ4BCXuJzgdG9mECldj7nhzN2IM9QQLgzf61jCXcd7hhEAdLZturzRB3hNatEV+f0CkMKcaGtLAWgEAu/VdWiBm/rpQRcJikYEjwlzRPmO7f3p8yfJXJbmrUk6IkTfW0SQDZP8wF2uMBvPt7aMbzNb0X6yeiK+5E0ITh/SvAX1Xt0WD1vsdbV6Y5O/HGLCJDbOjy/3tni6B/iWHGD1bETAcPCjua0/T4KMTOn7hx3ESQVCHdeTzjiAWioPhaPtJr2rJ8SHrYJMMWbbuQSuBSpSZ580mPY=
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
index f8188b833350..24216259cda4 100644
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


