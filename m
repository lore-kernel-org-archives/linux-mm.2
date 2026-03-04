Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BAF8EDEC12
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 05:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F986B0088; Wed,  4 Mar 2026 00:43:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7306B0089; Wed,  4 Mar 2026 00:43:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E866B008A; Wed,  4 Mar 2026 00:43:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF9356B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 00:43:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 399C7C1C31
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 05:43:44 +0000 (UTC)
X-FDA: 84507288768.16.DAE8946
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf07.hostedemail.com (Postfix) with ESMTP id AC8A640003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 05:43:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="Jn5/86da";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf07.hostedemail.com: domain of rob_garcia@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=rob_garcia@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772603022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pPN74FWzl5rs99LxJXNVQ8txtlabNPkvj+TmaCnurlU=;
	b=QV11yWoIuvpzTbEI/SPn1BgF26PawJxm0z14cTVpqLE2P+fUmP4zhWA7Kej4kDqHeJr43L
	R93ir6Rm9ebF2TM78cpZ/1mis3bhxwpopAk+hHw1HoYxhIXHoe3PkQdFsll3ohRNUKi/7F
	PZ6K+AfuJ1uLwQ1fIYrH/raaNoUSl/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772603022; a=rsa-sha256;
	cv=none;
	b=MWMoSXGW4W/hF4avaNjlr6APymURRN8BGmQ9TeeomI8kpMYsoq7EPaNzCoUyEwYF/hwwgJ
	jmzIPUNUxZ0DZTIxS/e0TXYUrPJDO64o2OS2ZsI0XEgLcjOQCbIn4ALdySuSP6hCo7UHrF
	v+27/WtSWqlw7wpn2Uraoh/fvzaH9hw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="Jn5/86da";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf07.hostedemail.com: domain of rob_garcia@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=rob_garcia@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=pP
	N74FWzl5rs99LxJXNVQ8txtlabNPkvj+TmaCnurlU=; b=Jn5/86dalwHPtUpAF8
	RaPAnqmmPKZUCsldPD8lOSVZjNkPUkM/qx4W5Mfq9pi9C/opveVxHSf5/CTLr4b5
	ZFxK6ZXHSgAgsePvLzd86H8cyxZvDyeMHC+78VLDD/DY8yUKzPezp9Zpksw7rm79
	SX1Ug33p0uxTLJLp4JDWwDPHY=
Received: from pek-lpg-core5.wrs.com (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wCn2vtvxqdp8eEYOA--.5674S2;
	Wed, 04 Mar 2026 13:43:12 +0800 (CST)
From: Robert Garcia <rob_garcia@163.com>
To: stable@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Robert Garcia <rob_garcia@163.com>,
	Jan Kara <jack@suse.cz>,
	Eric Biederman <ebiederm@xmission.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Helge Deller <deller@gmx.de>,
	Lior Ribak <liorribak@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.12.y] binfmt_misc: restore write access before closing files opened by open_exec()
Date: Wed,  4 Mar 2026 13:43:11 +0800
Message-Id: <20260304054311.108543-1-rob_garcia@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCn2vtvxqdp8eEYOA--.5674S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw4fGF48tw1UurW8AF1DWrg_yoW8WF4Dpr
	W5K34UtrZ0qryj9aykAas8WF15G3Z7GrsFvr4kWw1fXF1rXrs0gFZ2g3yj93W8A397ArWF
	qF4rC3sYyryUAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U4MKZUUUUU=
X-Originating-IP: [60.247.85.88]
X-CM-SenderInfo: 5uresw5dufxti6rwjhhfrp/xtbC5RISfWmnxnLEuAAA3e
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC8A640003
X-Stat-Signature: 7w1haabh5mzekfh7rrgqpao5tc7p8fa5
X-Rspam-User: 
X-HE-Tag: 1772603021-79475
X-HE-Meta: U2FsdGVkX18ZkYhOfZulPNBy7qDhpw0aF40BvwVxQN4MoyDr1wzInI/ZFxp+zNMH0bQeHSGDLejakxB0hku6GqkGdiHtTNzsLrb9JjLLJLA5/BeRUjOt6Ig2Rn88PUC84ekkhWw9QNlR+ni8UKsiGQv035gz2+8nNzE+EqnTlIU+GIusW5etrN0EhzuuGi9u2sMb/0RW1jd33JG2GjzN8Qd44jR74gTo5t53rxPvHHO8ZYpqwlvkVkd0P+YRbV27XbXlhqhMcSrmTlAZiM1LCQxPfqDOHjBVWw/g3XfIiHXjGTACMCcQn5qBXhmz4gvsSPNrRIUoN+qcrOOzBv48lwQP7tsCFv5ONbeLi2SFzkfIybgb9tACO5MRJrZrD9mik6F+RO51ygbmaXnd2WSm2bbD55xFscyc+Ui7Ry2Sm2M+cfQxogeDGyhhMjj9+aeyfxNBKBHx1X1MXCjNLcbkL6gDNMsWdE9UC7xr7dNkIgH5XDNCAYQvB739YWDCDEXO5U3C+X5unkTdv7eZ6RDvG705osOXDiz9nW82x/0Q7HjcdZv9nUv1rE/wyWEmJjZN1pVEqX5VPLvxGywPXBIwCSdXY7wxv9d1mi83bDCfXXMY9MKuG2Px7Mu32JKfZeoYEBAETGTJkifdsSlDAl6UnrFB905yHiRfIP7ACp5yQvSF/rPLRlUEAWyL/fHqS0gWYWkTCFOQg1ji1K2LkE99jaaUQ/ZjQdNEZo8UK7yjzEXlbQ2eZhCJgxEbQ/EvzqvW+nzkquyBtA0iwtUbAUUd6D5wbkM7l2xdx7ShDSch/vK8AzGRwKXA/xzRGzkIn+qUXieDd/npoApZbtbGgaKVsAnXfp+1fOV/XM1dkXlIuL9yPhAsxBK7Q+y8qUYDE95Qf+5mucESKQhMdkhiUcmL9VTm88VFOrXfxh+x7hYs273sytMsSSZdg2rLDwUl+iOUq77TOZpbu/p5noQswn9
 DgZV0FY4
 /p9CbkGl8LRxprZkyNj3Nil1m1nougT9kx9HIsoPw4BQCSRuyUMa0ZB0F0Yys5mVAqOCJC6lY/k9xmGCDTQQKpoKbPS2oAu68AP5zp2+CtE7BnR5e0KmOwNio5gLveXx17/iUv8OS/9+NnqORTlKWiDdnZqaOY1AmafKYWHi0lkulWG9yUC105HcobhnRkUF/zbNtDuQNuduB9LDqqeTW7By8j5ld6814UA9+hAI7eoYewtDvqiKZQtiQWG2+KdnqYXkNxmlyeNu0EDfhnpodshF1+UgI0YnCs5uOqsjQyz3d2UETA1UH1HhCX9liYZoCvGrDAmOiAKO0PaN5SlDb3o8Kr3XHC56IXAoe5koLDDyBfvI7PA+2mUU9PFXer4+Zz0Bf8IjUQgwAs7bw5sT7F2k775hrgPxb0W13g5ivCS/A8Yb4Ra4jbtUJnsLcEpIbzvveUiuy6zukQF81DO9H4yNBWcYmpioLWX01pbuU1i1Ta0yuNT4tVWjHSWYHxJrZBSSuxx1sUiaJf2+p7gkbxlrbmzTx3vfXOtfP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 fs/binfmt_misc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 6a3a16f91051..9fbff75e3faa 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -875,8 +875,10 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
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
-- 
2.34.1


