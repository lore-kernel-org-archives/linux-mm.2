Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B56A108E1E3
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 10:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83986B0468; Thu, 19 Mar 2026 06:41:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B6B6B046A; Thu, 19 Mar 2026 06:41:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97F16B046B; Thu, 19 Mar 2026 06:41:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C83DE6B0468
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:41:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 845D816049C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:41:21 +0000 (UTC)
X-FDA: 84562470762.02.82FBDD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id A6CD3C0002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:41:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=PqHkXOhD;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773916879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=1O600fcYCL7IhFDz/JNOZVOxD3fNlPA0JA/IKkstBqw=;
	b=unQwox99aCd9/nVjoXS6zQXZYanzPgfLaqiPKhsWAdcbND2IT/GxdE8HiKTMTGNW/2pndh
	V7t2yvKNoypGgR53S1MW3YMUpCtnDoXgLt6LJC/2xtQKnXd+qi3xBF7LuKd2SwWGGaB4Si
	2C5eLM+HiVbQpnDINl0R9APikfhzJII=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=PqHkXOhD;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773916879; a=rsa-sha256;
	cv=none;
	b=X0UOeaUuX0iWSeUU4sJNGEEOKj1nK+u+iLMbvtdzFtEYoHa4H6oulDjKD+QXNrsHmdYDjZ
	wLy2LIYhAaJjCiFm3+QNsJM5ggFymdxdn7x8gpRPeOsahOJPlAawP2ZW4otHVXLwRJZizC
	rMRbAo4QI/kSc/VD9EDZip/mAXCKZaM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB9CB41872;
	Thu, 19 Mar 2026 10:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F050C19424;
	Thu, 19 Mar 2026 10:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773916878;
	bh=6Zz6EFIhbf1OeHwU8aiQW85In3/sG5whL1gfkpAeXoA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=PqHkXOhDlmfajjz8FDOBfKQ5WMmdAtigwXFYnRT6/6A8BXHINQb4N1mdpnnELJfLl
	 dsoPR1/oJ9Rp9+ZuMahfdWry6eS1bgE+nNYpucF7KMZwuHdGz6PcSNzxBbcrecPxjW
	 Hq7V2MKZ1uqQRdRelws9CwuALAS7IuMTba+j3mTs=
Subject: Patch "binfmt_misc: restore write access before closing files opened by open_exec()" has been added to the 6.12-stable tree
To: akpm@linux-foundation.org,brauner@kernel.org,deller@gmx.de,ebiederm@xmission.com,gregkh@linuxfoundation.org,jack@suse.cz,kees@kernel.org,linux-mm@kvack.org,liorribak@gmail.com,rob_garcia@163.com,viro@zeniv.linux.org.uk,zilin@seu.edu.cn
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 19 Mar 2026 11:41:14 +0100
In-Reply-To: <20260304054311.108543-1-rob_garcia@163.com>
Message-ID: <2026031913-moonlight-disburse-f8b6@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Queue-Id: A6CD3C0002
X-Stat-Signature: o49mma6eynfixaxf3ygup1p37ta6dj9h
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773916879-340076
X-HE-Meta: U2FsdGVkX19nuVY1J6hE/O6NOgYX3HrtZDp7ckeh1KYI9168pStKQ/MFWv7j3GaFmdjTt8ZF7fgyqgSv7DPsuqdfXaOzJTgKuQ1OB3PmkVknhJyX6JGeFXjDsVTWUqm728IO0VfzdP9rVjOP1S1Wp11MPXP7v9Y+lEhvxnJZqSBmf8hslYjp6EjEKZS0GkqRl9ZSRLcPOsOjfZCHZfUVfl56SQk9cuW8U8GEgwOylE2+d+Kl/A95jYutkBKUIi5vKODg+wboxK2rgVdnLvWUJfmJ39AdzNj+uQOfybCqGoTQGRQsftQYYURrIEx43dHEHmpj2ge9eECYFesR4GRzdTS31YVNBTBGC3LqPIym+4FIAF96tnSfzmwQqdQER0SzHu1YcURSNnGQvdbx1ZDGyIMnr38VSPpvqNgmbJvE8vBXvrd8tuRbB0WMFJkQd+sC3kJxqlKXadoaX68/7lImp1s6vREmaA7kwppjCwzwu5Js/NkhYo02mW8Zx3yy1+MBu9npQ3ZmWj3v5FsWdmI4u6VTqF09QnDxLziJHmnqOfxilSWU9dFVbgFSKHhLREc9yHwECZOvh1eMzw4lTkTbWhYgrbTIJNqR3YYqq8Jn0cWA4K2VD51oSp1zE8kyNu6TDKZkaiiuQBCDPhNVJVZLSo8LSWBTsO0HpweDS5IFbP5vOvenT354kLg7YNR72VAxX4rlKKErcuhdcWLDJokeYOL2hEBGo8Xpe1DXpr3F9bdliL0dFB0Fpm88Dt08SxwWOb9J2QRQPTPyjc4+gOHcKDU1K9hZM/HHaKO7WaxcbpnaDJggNWRsF7SDBfceUHzzRMvnXc45kkRGwsC0U/7zrM2sNlDGxCr/ecqp/qpkmyCev021JLjSjrZAdtjKV+rHoD9rF72HwrHVeNF8J1igAkkIy1pDwG0VAo4MGPwhEBB6Tytg5R0naFduFxKS/tj80qgESHJlXha8WoX+uBJ
 oFEL/dBm
 xaTapwA8wMxZjPzglv9+wELixq1a1JlZrg2yGCWZxdNlR2dkuy1ODrV34/lQzsw1+/y9bGRqXaGkMiRivTZRsqiOX2m6ADpdG1X32WQJ3OCyfglq2H2tdXKTEsCLcpHvTYHg46JcF8xuOOeh8UeT2u8knMHE14BThC11weDC0vPRassyacwSW58pkWKjj0eR+v8A7g0rVSM7uHN/BWkIjcIjd2MHae7z4ZJGLTAuhIELY7/ECm/4b7drzkZdoZ8Bes9tFEvGgq/MVX7/R+G/NaH+lqF15DgAZCG5rJVOxFFTl6Z8zbLeHm8Ma7seEJ8iEyllaetAlcDO4W9ygzpxI28zghxrojg2fKBc8gvdhpV5fBD/i6fkL8Tqfyb3LfejBuMyl2suaVmVApWuUjjfj5YXh+ZH/hQULYa+KgZ+6gSDwQAe0njr8//GOS7Z1l44CC+sHS4CRx0NvCuSskZOum1K/4lPUD/qqJbKuSMNpBMDctFwfLR2Vki9InGNl8HEAjePMbMXodvjBHZqXywvl1rAH1FX2MsuEgCq7/NXbHrr7kqeY0LqKQmmmpgHI1G+J+aF6sIJ8VBUm4tRMV5zQjcmU6gcqpC7q9JyxA30o5d9mvo4WiGUeE6p+0YnIPzJXI6Jsp5SBfWKu8l5KO41lYdrULJayoKOiWnBIFg6l0JcUHp96HI8Mo1OvnBpxCnS7BVKTQsgK9z94QnJJV0JJd6DrjODR5iNDCZ+KmS1cNYzvYZKUNOUqdVbNzKfrdW9RwVi5u2xCGUvUG1E5q0BKvB+p1ERkOcDYwL3zy3FmSPV29GmfQqJViYywnpcfQcsEpneCzXkEMBORpJYkI3qqfyv/IoLUYjegLQRgcXXJLni7D8c8UKWLvPFHLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    binfmt_misc: restore write access before closing files opened by open_exec()

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     binfmt_misc-restore-write-access-before-closing-files-opened-by-open_exec.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-222980-greg=kroah.com@vger.kernel.org Wed Mar  4 06:44:15 2026
From: Robert Garcia <rob_garcia@163.com>
Date: Wed,  4 Mar 2026 13:43:11 +0800
Subject: binfmt_misc: restore write access before closing files opened by open_exec()
To: stable@vger.kernel.org, Zilin Guan <zilin@seu.edu.cn>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Robert Garcia <rob_garcia@163.com>, Jan Kara <jack@suse.cz>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Helge Deller <deller@gmx.de>, Lior Ribak <liorribak@gmail.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <20260304054311.108543-1-rob_garcia@163.com>

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
@@ -875,8 +875,10 @@ out:
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

queue-6.12/rxrpc-fix-recvmsg-unconditional-requeue.patch
queue-6.12/net-dsa-properly-keep-track-of-conduit-reference.patch
queue-6.12/binfmt_misc-restore-write-access-before-closing-files-opened-by-open_exec.patch
queue-6.12/spi-cadence-quadspi-implement-refcount-to-handle-unbind-during-busy.patch
queue-6.12/f2fs-fix-to-avoid-migrating-empty-section.patch
queue-6.12/blk-throttle-fix-access-race-during-throttle-policy-activation.patch

