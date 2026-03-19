Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80BD1108E1FB
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 12:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E40706B0496; Thu, 19 Mar 2026 08:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB306B0498; Thu, 19 Mar 2026 08:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00CD6B0499; Thu, 19 Mar 2026 08:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE9F26B0496
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:01:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CDD31DAAE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:01:26 +0000 (UTC)
X-FDA: 84562672572.24.C1EFE04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id CB6581A0012
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:01:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=1706h6Q3;
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773921684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=w3fYuJlGXCMO8AIpcAmmvG97gkpD/JY12YFIkjT06RM=;
	b=XhU6cspPLdwfqtwXtiFiBd1u3IZjR63ZCripZzS8vGraSy7nziDdNZh+YKJGiZxiScVyvA
	kt2uW0KueAPZsRzY92CsXI737IufyrXOs+twQE78MngfZt8pFzWIrn4GD7wQY/9tj0bQtK
	F4JbnfmqPoA/zjP/pwrsYYYkU5vcleg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773921684; a=rsa-sha256;
	cv=none;
	b=XNDbE5ARjQtLGHLTZzYEyDgIxPTO2T7KyTBF6Xg4FcxP4nU+P4cv2LC/Jzm6uGZkaGc+Mf
	5bPy9Smx54GPWAoRH3OU7alDSwSFpUmWn/PvTvv/sLIfJBwVnVjZ8MImSlU5FtI0bwB0sO
	0UIQaGnlnXA7HDCBS253wpeoekUiM5E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=1706h6Q3;
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CE666011F;
	Thu, 19 Mar 2026 12:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313E3C19424;
	Thu, 19 Mar 2026 12:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773921683;
	bh=lnjlgIoqOKVAYGSoe4vY2KEPYmRMOG9CxM73KMQdeXc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=1706h6Q3z82bq+LyRm3Wub4CgDcyoXaI/7yI6bUVh3e21Kvx4boo4CryaAvWXhVOA
	 BP+9Wm55QjTSp0Y3lEBrny/Hl8y87gys8ahcHu2zQ6EfS1HSZ+ZsrzgqdY5T6j8XJ1
	 Gl0Th4srDEpc+wrqaFN+WHIrOWfTXiqod+bWitYg=
Subject: Patch "binfmt_misc: restore write access before closing files opened by open_exec()" has been added to the 6.6-stable tree
To: akpm@linux-foundation.org,brauner@kernel.org,deller@gmx.de,ebiederm@xmission.com,gregkh@linuxfoundation.org,jack@suse.cz,kees@kernel.org,linux-mm@kvack.org,liorribak@gmail.com,rob_garcia@163.com,viro@zeniv.linux.org.uk,zilin@seu.edu.cn
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 19 Mar 2026 13:01:19 +0100
In-Reply-To: <20260305023501.4003943-1-rob_garcia@163.com>
Message-ID: <2026031919-ounce-numbness-9a35@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: 7y11zetq1j1oep15hxoekbp1zetjqma4
X-Rspam-User: 
X-Rspamd-Queue-Id: CB6581A0012
X-Rspamd-Server: rspam12
X-HE-Tag: 1773921684-413086
X-HE-Meta: U2FsdGVkX1/5AxfeZh/68eRNbLKJN+bx99UKgewMHEtc366iATaReImkfY3OCiVvBr4cBMDyOT1Wd6f9e7kEyjHDtm6bBT5KJ1n/iuJGI8E/CmYsQ1OFJjU6hStcTT/mEyNuv3/Yti+7j+Vc0ROoqOTWyiE+6l4isbhUw8y8CQO2Pyoj15SFNgCTyw32W/uZizrLoyRkox8b8Vx+a8ooacSQk3PfUNj9KWjHICU1s/QeMdv7un5lfoqYxu3KtaRYQVK9ZPjMM7AejuEQ8mfVF3H9JWBZxtzK5p/MdMxAoOQpwQ3k5TZ5NcQfBKYoSPv5SQHxJUzWV/9RyeCecAWzKH9HSIoFOQ109drSqMW6FjbstZ+XpVn7VGF5lT3MYESnocsFBRk4vXrDAhqPEP/IK0ugj3lap1zOq9Wg+5ryMqGuDs34Teo5cruXSlJNl24h0pM+LWIi9PyWhRhQO997VAkv0PAXAbNt/CYAo60eIHGuqjldrPJx0aA6C3hXpSGOKac2MLjhu/5BsrWh/XpXiqm8FuR5hlUkzfSVqjnUwdJWJ2kLmV+nLMiP1wMCm3btyc3KGLI8mqHcQqIGLQA/4jO0XwAXmIpHjRD6aEW3563aWwu6hOHsaqsm0lYhfHfTr8KDYrI6Ku6UrHYxMrVY9BjePndlJNI1ezgAaC0E9GnBdUl4jc+EP1T9bqZ7Vg83X51FXApjJIWWPUF217pVCCKtJ2oX44iiOD4VAoMyRa5+NPtn8TuCy1j7L/lBVNDbCSKqghZPIFijePmpnlVMLWrEc4La72kF4bfejk4UGSxkQLpg9Yk+U3sCOlFLSLTq5Btd0m8ZqutVXrvALX46UyZHD9UElfJH5DblIqnOYVy0VzGA+CvoYQQX0/EvTBSJyOv3i6sXcGn4k8UdNyfqHbLJK0/Hfp7+C0SX/I5Yf+C3Dyje8VP8XrHVW1U7wwS5eRTMSxGycq21+uXwgPV
 /1Sk46EZ
 qWpevW+uK8VSV5Na0rqKhdsNddnK20+yN2GQ+BZw3iyS/AS/ZzCYj+VVldfr5MGUlwoCINwtNk+2BjepdJc+GoNWahemxyHwXZxfb4jpu11W0N9v6GU/2aDNaYqaAE36a08qI9X9MGrXhEgq7mI3kcy5ODLX8tmr2pZbeEbS6SDQLGQbnRf5VganspVByo1NCkZvaGsexFG0T4ASscCSbzcWbP2hC2XdR2Of/cQajMfL6l316i4Kk0f9joZgXlwvW6mrkzLim7INdqeyMgLa84qqHGLUBsqJWrEq8vTC3kS9MdApWFSY1IcfrCviKxdd1lHJTf7KT2PPt1FdfthUAZfIW2xMeqQW+9tEv/l+YfF3MQUPojJhrMNgchgz7WwkF0XAxOnkgkZiBtDC7wRXbmPFIYRcjb4qVQ+sOPd3XW1vUFOrmeXxIii6avPa+EcBNGAHNGxlypJytded9JPTRMPwFMbbCBHZs4+N8Pi+9Tp+wrUH81JdO/2bEh/0N5QFrBwhnh/Aj5Fbs2WKAj94It5hZSMJPPryeHCADJDFjDXdBuYdADrN2rsz/+DCcXJe7DLWZsmpUvLn8WbaUMn3OOBTkcr1Hwr1zPWVH2pcgi/bjjy2NcG/bZqNNjWLSYlE7mlsx/LxxMszUFAPhjBYYAZeHhejJ5VbfmSYz27egZu+ayCAJTlcl7HaagD+BcX3Nuo9AJmmexeJ6icBonPzCi8Vls7ObR9P+HMR8l0Hm9m/TEGpQnSBYqztOhhUvsF+yPLBRTjzWRQio6haFzSfgeS9eha3xr4GVro0PKWu0J1g6dnQ1eBAShCu2BLlGJgZGsuQr1XK1OfDgiEh4HtD0H9A2H1NxiLaHlCPXNcq34fiXzKUerbXA1tMIag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    binfmt_misc: restore write access before closing files opened by open_exec()

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     binfmt_misc-restore-write-access-before-closing-files-opened-by-open_exec.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-223166-greg=kroah.com@vger.kernel.org Thu Mar  5 03:35:55 2026
From: Robert Garcia <rob_garcia@163.com>
Date: Thu,  5 Mar 2026 10:35:01 +0800
Subject: binfmt_misc: restore write access before closing files opened by open_exec()
To: stable@vger.kernel.org, Zilin Guan <zilin@seu.edu.cn>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Robert Garcia <rob_garcia@163.com>, Jan Kara <jack@suse.cz>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Helge Deller <deller@gmx.de>, Lior Ribak <liorribak@gmail.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <20260305023501.4003943-1-rob_garcia@163.com>

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 90f601b497d76f40fa66795c3ecf625b6aced9fd ]

bm_register_write() opens an executable file using open_exec(), which
internally calls do_open_execat() and denies write access on the file to
avoid modification while it is being executed.

However, when an error occurs, bm_register_write() closes the file using
filp_close() directly. This does not restore the write permission, which
may cause subsequent write operations on the same file to fail.

Fix this by calling exe_file_allow_write_access() before filp_close() to
restore the write permission properly.

Fixes: e7850f4d844e ("binfmt_misc: fix possible deadlock in bm_register_write")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20251105022923.1813587-1-zilin@seu.edu.cn
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ Use allow_write_access() instead of exe_file_allow_write_access()
according to commit 0357ef03c94ef
("fs: don't block write during exec on pre-content watched files"). ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_misc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -815,8 +815,10 @@ out:
 	inode_unlock(d_inode(root));
 
 	if (err) {
-		if (f)
+		if (f) {
+			allow_write_access(f);
 			filp_close(f, NULL);
+		}
 		kfree(e);
 		return err;
 	}


Patches currently in stable-queue which might be from rob_garcia@163.com are

queue-6.6/rxrpc-fix-recvmsg-unconditional-requeue.patch
queue-6.6/binfmt_misc-restore-write-access-before-closing-files-opened-by-open_exec.patch
queue-6.6/f2fs-fix-to-avoid-migrating-empty-section.patch

