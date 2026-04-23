Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4820F99378
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 11:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2751B6B0005; Thu, 23 Apr 2026 07:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224DA6B008A; Thu, 23 Apr 2026 07:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 161D76B008C; Thu, 23 Apr 2026 07:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 057886B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:50:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C117A4010A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:50:51 +0000 (UTC)
X-FDA: 84689653902.04.818C29B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 06009140011
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:50:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=l05wjaRL;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf23.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776945050; a=rsa-sha256;
	cv=none;
	b=yKcfS/9LTC4l2JzDGfpR0FUJegGrmzKSmrTT53WUznwSHGVr6IzuDM43umcyh+xn0tgyLE
	7IDSl3JDJK0+NP4OFvjF/NfnGXKmSzFDBiQhljZ0/NCfCKDO6WKms5vI5yErbklzXaRn8b
	Ze1FTbjaOTH5UBLHsNPix0qc1Fcxwws=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=l05wjaRL;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf23.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776945050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=5PwMfCR2EmAMGQidOld2kcMCz/1kK0ZUpgSpEfUfgdk=;
	b=bBC9sSXrCw/5rXCZbvQTjtWQTlaham0cuoBtgQ/7+2Ygo7LTuYFxO6898a6VB4hS8IYOy1
	GdKWPxxgHVjA2yqkV84/JeDp4+ILT43qxJK/mVR2hql8kGZiI5H5tb8+xfx9NXjaOidRhR
	RGm1gab/q+vXMtdJmjV/kEsbrazrZpo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1661160120;
	Thu, 23 Apr 2026 11:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B0DC2BCAF;
	Thu, 23 Apr 2026 11:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776945048;
	bh=aX+FNPNAsCcsZT31QgGHo2BeA8cvxRkN4QgnxDkeERI=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=l05wjaRLwQtWccPBj9tJZ2WZMcNrEhSomMesr/MQpYPL+rW5RHXxUxag+oNhZxcQO
	 28EE5YUiaF5wd6yl9LRnb0QNNt8u2KwBmtt42f5QgRqQOo8KW3XcTbaId8DOK0jbBQ
	 n51AkATSX3VNLXbrRWkOiJqGP3VrYj/2Tau5fvuE=
Subject: Patch "binfmt_misc: restore write access before closing files opened by open_exec()" has been added to the 5.15-stable tree
To: akpm@linux-foundation.org,brauner@kernel.org,deller@gmx.de,ebiederm@xmission.com,gregkh@linuxfoundation.org,jack@suse.cz,kees@kernel.org,linux-mm@kvack.org,liorribak@gmail.com,rob_garcia@163.com,viro@zeniv.linux.org.uk,zilin@seu.edu.cn
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 23 Apr 2026 13:50:41 +0200
In-Reply-To: <20260311081046.1668003-1-rob_garcia@163.com>
Message-ID: <2026042341-numbing-washtub-7420@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam10
X-Stat-Signature: o8b3be715ixy1xukm7fyrncrsszs17nw
X-Rspam-User: 
X-Rspamd-Queue-Id: 06009140011
X-HE-Tag: 1776945049-356095
X-HE-Meta: U2FsdGVkX1/aolIkjwSjYTxyReeJav1Fuc/TyRPNOxKIQciJMrSGeadURpu8vTISycnRH5U181aLMnTDDG9h0zMyNZWwKNMJ6H+aube+6IAWSpKZSgEC03g7cwU77RB4LyQG9tzcdsX+VJq62GfBFnO6Kv/5ZBEuJZ/3dISa95/c7TK0i7sOqFbEMcv5+pY5trgoCQTyG/bXOlvqg/gHcWYjD96jAWrwgLXex9zw4qBDgUBsNFrSkIenarq4wUd/jX0e+GwEoPb8FxhlelsJ1TPm6qSzFaGfL/TFkXQd3CAoI8bnU5/hiKTy7ds6Unz3xZAq/pVmLpfz6F0LsOUyP0sDqmhuqz7kDylk4ySpmRdWP2b+zNyspFK9VxCwJBvRSevsr7tGIBfowSk3swD8fo4A/fhIVrDJZiouCJDpfDz6vF3c3oEbYM/4b6pGcmddEqdE/mDW1TdI0JnAzStInWkqVxCDjDvIY+hvGF3I1Jd9Fsy0jATeWsH63gBZy2C0L7/zvSO7c/c8NOkNyowaUO0w9XspOdp4SGHoT18XoUz8XAUglVlV4pQ2UiWTGMWgMuCSh3Y4a2delQ7S5qHB0+/kCJL5EMd6hkf51glHtIASJGTMaxEiHW9Tzzjuzm5+PVuEcmdEVPSkOZMwRlpR9StX90uX4kfpUX23IL0VI/bRLSRdp1IQL0mZWWcrQ4LRzXuja+0uKrsE2325x8NEA6dkX9GZlY7+SkP785BQzcG8xUsGMMlQ1MzepUpEWwzGpqnDldluF9ZpKZ0R+RM4m39jnbzobdtxOQZjvJTTSARIvdCq8KQuuIU2WXpaU2k4bCRoWWYHY4uPsOIILS7nV+gSofW8r6wh7WeiefypkYEoIaXd39iw46iLk4HvDI09d1ba5aT/eUHm/VMv73RXo66DVm7b2GMjfV0xuP6IpykkuJ/JF019SPjSlaJL6X7tsW9wBSHmZlKBa1o1V97
 a8Li3H31
 vc/Jit4nfB/QlEJioRNJ2ZsJdTqddDYYakQUn3gmohxVI0Aobu2vD5wbiVdhGFdanqUA6cKYLNZ3JQ641S5uA03jMP0EsAdNg3zDUqjTrUsuyaa1sRm31O8Fmf7PtXaoXMTrCrsfo228vPj0Dh/JyjxetWNbh3E1BK7XX8iPxPMwfFiEHGek+bwdSDje4JKLhgo82L7sQnWOnkdFie/pN+Mqx3SPGdaXJ6uGuLzLOl7jqPrQtjpqx9+6OOIcFtM9d8HmbJKiUodGRT1vtzLZasBuEXuMA72BhCNKIY5luWGAbwjEyQEiZ5yHmU33GSdr2dnamGTX+/TWlDmOT8Bl6bYu406aNEZk9jXpJV0bRcKYXoMiNZFjNQaM50h1utU1vjL93JZxiF5FS6pdxp8sw6Hssqv4kRKQfUovjwTOMKeBgnJ15YLnLf0wwP2Z2hndN2efALqDc8JI0g9HW0JRcETU7kbVDtfWgcDTPfVPeRUvPRQtjwXJS6aBaqHc//GTSeghBhhh5pDVSo5pvCncEHX8dKB5Cd3l9OCckllFU80URzHKnbt13qzr9vBYwTBcc0VxRyc+8mvc3yXazn+IiP46Pv2pgWKI4yUNUMLUElw6N0PcDOyEl0qOMAJ599epYbvcdgbSIPs7EhzNLoXkv3rzrfVGYDQrucXb7mmXQbmTvJ137s1iINbPJBs5L8d+V6gnEQPhbF3URc35F3fe1k1K2f6iCAf0MSAV3Xtv281POvYnLdZiFbKpQWwATrRfNro9b2JGbfrCBpqgu7Yq/RRo8kRxiQPuEH3RBowxlMM89fKmRiglnnaBVaQQWIWDKgec6rMdX3HYedm2tn2nA0X5y9Zxxkzs0wjPu2jJ2GicWuhgj0IuWWu/TEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    binfmt_misc: restore write access before closing files opened by open_exec()

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     binfmt_misc-restore-write-access-before-closing-files-opened-by-open_exec.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-224649-greg=kroah.com@vger.kernel.org Wed Mar 11 09:12:27 2026
From: Robert Garcia <rob_garcia@163.com>
Date: Wed, 11 Mar 2026 16:10:46 +0800
Subject: binfmt_misc: restore write access before closing files opened by open_exec()
To: stable@vger.kernel.org, Zilin Guan <zilin@seu.edu.cn>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Robert Garcia <rob_garcia@163.com>, Jan Kara <jack@suse.cz>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Helge Deller <deller@gmx.de>, Lior Ribak <liorribak@gmail.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <20260311081046.1668003-1-rob_garcia@163.com>

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
@@ -816,8 +816,10 @@ out:
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

queue-5.15/sunrpc-lock-against-sock-changing-during-sysfs-read.patch
queue-5.15/smb-client-fix-potential-uaf-in-smb2_is_valid_oplock.patch
queue-5.15/pstore-inode-only-d_invalidate-is-needed.patch
queue-5.15/wifi-iwlwifi-read-txq-read_ptr-under-lock.patch
queue-5.15/alsa-control-avoid-warn-for-symlink-errors.patch
queue-5.15/binfmt_misc-restore-write-access-before-closing-files-opened-by-open_exec.patch
queue-5.15/spi-cadence-quadspi-implement-refcount-to-handle-unbind-during-busy.patch
queue-5.15/f2fs-fix-to-wait-on-block-writeback-for-post_read-case.patch

